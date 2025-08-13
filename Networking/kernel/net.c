#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"
#include "net.h"

// xv6's ethernet and IP addresses
static uint8 local_mac[ETHADDR_LEN] = { 0x52, 0x54, 0x00, 0x12, 0x34, 0x56 };
static uint32 local_ip = MAKE_IP_ADDR(10, 0, 2, 15);

// qemu host's ethernet address.
static uint8 host_mac[ETHADDR_LEN] = { 0x52, 0x55, 0x0a, 0x00, 0x02, 0x02 };

static struct spinlock netlock;

// UDP port table
#define NPORT 16
struct port {
  uint16 port;
  int used;
  char *packets[16];  // Packet buffers
  int lengths[16];    // Packet lengths
  uint32 sips[16];    // Source IPs
  uint16 sports[16];  // Source ports
  int head;
  int tail;
  int count;
};

static struct port ports[NPORT];

void
netinit(void)
{
  initlock(&netlock, "netlock");
  
  // Initialize port table
  for(int i = 0; i < NPORT; i++) {
    ports[i].used = 0;
    ports[i].port = 0;
    ports[i].head = 0;
    ports[i].tail = 0;
    ports[i].count = 0;
    for(int j = 0; j < 16; j++) {
      ports[i].packets[j] = 0;
      ports[i].lengths[j] = 0;
      ports[i].sips[j] = 0;
      ports[i].sports[j] = 0;
    }
  }
}

//
// bind(int port)
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64
sys_bind(void)
{
  int port;
  
  argint(0, &port);
    
  if(port < 0 || port > 65535)
    return -1;
    
  acquire(&netlock);
  
  // Check if port is already bound
  for(int i = 0; i < NPORT; i++) {
    if(ports[i].used && ports[i].port == port) {
      release(&netlock);
      return -1;  // Port already in use
    }
  }
  
  // Find free slot
  for(int i = 0; i < NPORT; i++) {
    if(!ports[i].used) {
      ports[i].used = 1;
      ports[i].port = port;
      ports[i].head = 0;
      ports[i].tail = 0;
      ports[i].count = 0;
      for(int j = 0; j < 16; j++) {
        ports[i].packets[j] = 0;
        ports[i].lengths[j] = 0;
        ports[i].sips[j] = 0;
        ports[i].sports[j] = 0;
      }
      release(&netlock);
      return 0;
    }
  }
  
  release(&netlock);
  return -1;  // No free slots
}

//
// unbind(int port)
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64
sys_unbind(void)
{
  int port;
  
  argint(0, &port);
    
  acquire(&netlock);
  
  // Find and unbind the port
  for(int i = 0; i < NPORT; i++) {
    if(ports[i].used && ports[i].port == port) {
      // Free any queued packets
      for(int j = 0; j < 16; j++) {
        if(ports[i].packets[j]) {
          kfree(ports[i].packets[j]);
          ports[i].packets[j] = 0;
        }
      }
      ports[i].used = 0;
      ports[i].count = 0;
      release(&netlock);
      return 0;
    }
  }
  
  release(&netlock);
  return -1;  // Port not found
}

//
// recv(int dport, int *src, short *sport, char *buf, int maxlen)
// if there's a received UDP packet already queued that was
// addressed to dport, then return it.
// otherwise wait for such a packet.
//
// sets *src to the IP source address.
// sets *sport to the UDP source port.
// copies up to maxlen bytes of UDP payload to buf.
// returns the number of bytes copied,
// and -1 if there was an error.
//
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64
sys_recv(void)
{
  int dport;
  uint64 src_addr;
  uint64 sport_addr;
  uint64 buf_addr;
  int maxlen;
  
  argint(0, &dport);
  argaddr(1, &src_addr);
  argaddr(2, &sport_addr);
  argaddr(3, &buf_addr);
  argint(4, &maxlen);
    
  if(maxlen < 0)
    return -1;
    
  struct proc *p = myproc();
  
  acquire(&netlock);
  
  // Find the port
  int port_idx = -1;
  for(int i = 0; i < NPORT; i++) {
    if(ports[i].used && ports[i].port == dport) {
      port_idx = i;
      break;
    }
  }
  
  if(port_idx == -1) {
    release(&netlock);
    return -1;  // Port not bound
  }
  
  // Wait for a packet if queue is empty
  while(ports[port_idx].count == 0) {
    sleep(&ports[port_idx], &netlock);
  }
  
  // Get packet from queue
  char *packet = ports[port_idx].packets[ports[port_idx].head];
  int pkt_len = ports[port_idx].lengths[ports[port_idx].head];
  uint32 sip = ports[port_idx].sips[ports[port_idx].head];
  uint16 sport = ports[port_idx].sports[ports[port_idx].head];
  
  ports[port_idx].packets[ports[port_idx].head] = 0;
  ports[port_idx].head = (ports[port_idx].head + 1) % 16;
  ports[port_idx].count--;
  
  release(&netlock);
  
  // Copy data to user space
  int copy_len = maxlen < pkt_len ? maxlen : pkt_len;
  if(copyout(p->pagetable, buf_addr, packet, copy_len) < 0) {
    kfree(packet);
    return -1;
  }
  
  // Copy source IP and port
  if(copyout(p->pagetable, src_addr, (char*)&sip, sizeof(uint32)) < 0) {
    kfree(packet);
    return -1;
  }
  
  if(copyout(p->pagetable, sport_addr, (char*)&sport, sizeof(uint16)) < 0) {
    kfree(packet);
    return -1;
  }
  
  kfree(packet);
  return copy_len;
}

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
  int nleft = len;
  const unsigned short *w = (const unsigned short *)addr;
  unsigned int sum = 0;
  unsigned short answer = 0;

  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    sum += *w++;
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
  sum += (sum >> 16);
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
  return answer;
}

//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64
sys_send(void)
{
  struct proc *p = myproc();
  int sport;
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
  argint(1, &dst);
  argint(2, &dport);
  argaddr(3, &bufaddr);
  argint(4, &len);

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
  if(total > PGSIZE)
    return -1;

  char *buf = kalloc();
  if(buf == 0){
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);

  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
  memmove(eth->shost, local_mac, ETHADDR_LEN);
  eth->type = htons(ETHTYPE_IP);

  struct ip *ip = (struct ip *)(eth + 1);
  ip->ip_vhl = 0x45; // version 4, header length 4*5
  ip->ip_tos = 0;
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
  ip->ip_id = 0;
  ip->ip_off = 0;
  ip->ip_ttl = 100;
  ip->ip_p = IPPROTO_UDP;
  ip->ip_src = htonl(local_ip);
  ip->ip_dst = htonl(dst);
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
  udp->dport = htons(dport);
  udp->ulen = htons(len + sizeof(struct udp));

  char *payload = (char *)(udp + 1);
  if(copyin(p->pagetable, payload, bufaddr, len) < 0){
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);

  return 0;
}

void
ip_rx(char *buf, int len)
{
  // don't delete this printf; make grade depends on it.
  static int seen_ip = 0;
  if(seen_ip == 0)
    printf("ip_rx: received an IP packet\n");
  seen_ip = 1;

  //
  // Your code here.
  //
  
  struct ip *iphdr;
  struct udp *udphdr;
  
  if (len < sizeof(struct eth) + sizeof(struct ip))
    return;
    
  iphdr = (struct ip *) (buf + sizeof(struct eth));
  
  // Check if it's UDP
  if (iphdr->ip_p != IPPROTO_UDP)
    return;
    
  if (len < sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp))
    return;
    
  udphdr = (struct udp *) (buf + sizeof(struct eth) + sizeof(struct ip));
  
  uint16 dport = ntohs(udphdr->dport);
  uint16 sport = ntohs(udphdr->sport);
  uint32 sip = ntohl(iphdr->ip_src);
  uint16 ulen = ntohs(udphdr->ulen);
  
  acquire(&netlock);
  
  // Find the port
  for(int i = 0; i < NPORT; i++) {
    if(ports[i].used && ports[i].port == dport) {
      // Check if queue is full
      if(ports[i].count >= 16) {
        // Drop packet
        release(&netlock);
        return;
      }
      
      // Calculate payload offset and size
      int payload_offset = sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
      int payload_len = ulen - sizeof(struct udp);
      
      if(payload_len <= 0 || payload_offset + payload_len > len) {
        release(&netlock);
        return;
      }
      
      // Allocate buffer for the payload
      char *packet = kalloc();
      if(!packet) {
        release(&netlock);
        return;
      }
      
      // Copy payload
      char *payload = buf + payload_offset;
      memmove(packet, payload, payload_len);
      
      // Add to queue
      ports[i].packets[ports[i].tail] = packet;
      ports[i].lengths[ports[i].tail] = payload_len;
      ports[i].sips[ports[i].tail] = sip;
      ports[i].sports[ports[i].tail] = sport;
      ports[i].tail = (ports[i].tail + 1) % 16;
      ports[i].count++;
      
      // Wake up any waiting processes
      wakeup(&ports[i]);
      
      release(&netlock);
      return;
    }
  }
  
  release(&netlock);
}

//
// send an ARP reply packet to tell qemu to map
// xv6's ip address to its ethernet address.
// this is the bare minimum needed to persuade
// qemu to send IP packets to xv6; the real ARP
// protocol is more complex.
//
void
arp_rx(char *inbuf)
{
  static int seen_arp = 0;

  if(seen_arp){
    kfree(inbuf);
    return;
  }
  printf("arp_rx: received an ARP packet\n");
  seen_arp = 1;

  struct eth *ineth = (struct eth *) inbuf;
  struct arp *inarp = (struct arp *) (ineth + 1);

  char *buf = kalloc();
  if(buf == 0)
    panic("send_arp_reply");
  
  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, ineth->shost, ETHADDR_LEN); // ethernet destination = query source
  memmove(eth->shost, local_mac, ETHADDR_LEN); // ethernet source = xv6's ethernet address
  eth->type = htons(ETHTYPE_ARP);

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
  arp->pro = htons(ETHTYPE_IP);
  arp->hln = ETHADDR_LEN;
  arp->pln = sizeof(uint32);
  arp->op = htons(ARP_OP_REPLY);

  memmove(arp->sha, local_mac, ETHADDR_LEN);
  arp->sip = htonl(local_ip);
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
  arp->tip = inarp->sip;

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));

  kfree(inbuf);
}

void
net_rx(char *buf, int len)
{
  struct eth *eth = (struct eth *) buf;

  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
     ntohs(eth->type) == ETHTYPE_ARP){
    arp_rx(buf);
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
     ntohs(eth->type) == ETHTYPE_IP){
    ip_rx(buf, len);
  } else {
    kfree(buf);
  }
}