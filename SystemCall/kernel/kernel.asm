
kernel/kernel: formato do arquivo elf64-littleriscv


Desmontagem da seção .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	3a013103          	ld	sp,928(sp) # 8000a3a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	559040ef          	jal	80004d6e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00024797          	auipc	a5,0x24
    80000034:	8f078793          	addi	a5,a5,-1808 # 80023920 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	3ac90913          	addi	s2,s2,940 # 8000a3f0 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	782050ef          	jal	800057d0 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	00b050ef          	jal	80005868 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	f9250513          	addi	a0,a0,-110 # 80007000 <etext>
    80000076:	42c050ef          	jal	800054a2 <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000084:	6785                	lui	a5,0x1
    80000086:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000008a:	00e504b3          	add	s1,a0,a4
    8000008e:	777d                	lui	a4,0xfffff
    80000090:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000092:	94be                	add	s1,s1,a5
    80000094:	0295e263          	bltu	a1,s1,800000b8 <freerange+0x3e>
    80000098:	e84a                	sd	s2,16(sp)
    8000009a:	e44e                	sd	s3,8(sp)
    8000009c:	e052                	sd	s4,0(sp)
    8000009e:	892e                	mv	s2,a1
    kfree(p);
    800000a0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a2:	6985                	lui	s3,0x1
    kfree(p);
    800000a4:	01448533          	add	a0,s1,s4
    800000a8:	f75ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ac:	94ce                	add	s1,s1,s3
    800000ae:	fe997be3          	bgeu	s2,s1,800000a4 <freerange+0x2a>
    800000b2:	6942                	ld	s2,16(sp)
    800000b4:	69a2                	ld	s3,8(sp)
    800000b6:	6a02                	ld	s4,0(sp)
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6145                	addi	sp,sp,48
    800000c0:	8082                	ret

00000000800000c2 <kinit>:
{
    800000c2:	1141                	addi	sp,sp,-16
    800000c4:	e406                	sd	ra,8(sp)
    800000c6:	e022                	sd	s0,0(sp)
    800000c8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000ca:	00007597          	auipc	a1,0x7
    800000ce:	f4658593          	addi	a1,a1,-186 # 80007010 <etext+0x10>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	31e50513          	addi	a0,a0,798 # 8000a3f0 <kmem>
    800000da:	676050ef          	jal	80005750 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00024517          	auipc	a0,0x24
    800000e6:	83e50513          	addi	a0,a0,-1986 # 80023920 <end>
    800000ea:	f91ff0ef          	jal	8000007a <freerange>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	addi	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	0000a497          	auipc	s1,0xa
    80000104:	2f048493          	addi	s1,s1,752 # 8000a3f0 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	6c6050ef          	jal	800057d0 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	2ef73a23          	sd	a5,756(a4) # 8000a408 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	2d450513          	addi	a0,a0,724 # 8000a3f0 <kmem>
    80000124:	744050ef          	jal	80005868 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000128:	8526                	mv	a0,s1
    8000012a:	60e2                	ld	ra,24(sp)
    8000012c:	6442                	ld	s0,16(sp)
    8000012e:	64a2                	ld	s1,8(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret

0000000080000134 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000134:	1141                	addi	sp,sp,-16
    80000136:	e422                	sd	s0,8(sp)
    80000138:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000013a:	ca19                	beqz	a2,80000150 <memset+0x1c>
    8000013c:	87aa                	mv	a5,a0
    8000013e:	1602                	slli	a2,a2,0x20
    80000140:	9201                	srli	a2,a2,0x20
    80000142:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000146:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000014a:	0785                	addi	a5,a5,1
    8000014c:	fee79de3          	bne	a5,a4,80000146 <memset+0x12>
  }
  return dst;
}
    80000150:	6422                	ld	s0,8(sp)
    80000152:	0141                	addi	sp,sp,16
    80000154:	8082                	ret

0000000080000156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000156:	1141                	addi	sp,sp,-16
    80000158:	e422                	sd	s0,8(sp)
    8000015a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000015c:	ca05                	beqz	a2,8000018c <memcmp+0x36>
    8000015e:	fff6069b          	addiw	a3,a2,-1
    80000162:	1682                	slli	a3,a3,0x20
    80000164:	9281                	srli	a3,a3,0x20
    80000166:	0685                	addi	a3,a3,1
    80000168:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000016a:	00054783          	lbu	a5,0(a0)
    8000016e:	0005c703          	lbu	a4,0(a1)
    80000172:	00e79863          	bne	a5,a4,80000182 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000176:	0505                	addi	a0,a0,1
    80000178:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000017a:	fed518e3          	bne	a0,a3,8000016a <memcmp+0x14>
  }

  return 0;
    8000017e:	4501                	li	a0,0
    80000180:	a019                	j	80000186 <memcmp+0x30>
      return *s1 - *s2;
    80000182:	40e7853b          	subw	a0,a5,a4
}
    80000186:	6422                	ld	s0,8(sp)
    80000188:	0141                	addi	sp,sp,16
    8000018a:	8082                	ret
  return 0;
    8000018c:	4501                	li	a0,0
    8000018e:	bfe5                	j	80000186 <memcmp+0x30>

0000000080000190 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000196:	c205                	beqz	a2,800001b6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000198:	02a5e263          	bltu	a1,a0,800001bc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000019c:	1602                	slli	a2,a2,0x20
    8000019e:	9201                	srli	a2,a2,0x20
    800001a0:	00c587b3          	add	a5,a1,a2
{
    800001a4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001a6:	0585                	addi	a1,a1,1
    800001a8:	0705                	addi	a4,a4,1
    800001aa:	fff5c683          	lbu	a3,-1(a1)
    800001ae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001b2:	feb79ae3          	bne	a5,a1,800001a6 <memmove+0x16>

  return dst;
}
    800001b6:	6422                	ld	s0,8(sp)
    800001b8:	0141                	addi	sp,sp,16
    800001ba:	8082                	ret
  if(s < d && s + n > d){
    800001bc:	02061693          	slli	a3,a2,0x20
    800001c0:	9281                	srli	a3,a3,0x20
    800001c2:	00d58733          	add	a4,a1,a3
    800001c6:	fce57be3          	bgeu	a0,a4,8000019c <memmove+0xc>
    d += n;
    800001ca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001cc:	fff6079b          	addiw	a5,a2,-1
    800001d0:	1782                	slli	a5,a5,0x20
    800001d2:	9381                	srli	a5,a5,0x20
    800001d4:	fff7c793          	not	a5,a5
    800001d8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001da:	177d                	addi	a4,a4,-1
    800001dc:	16fd                	addi	a3,a3,-1
    800001de:	00074603          	lbu	a2,0(a4)
    800001e2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800001e6:	fef71ae3          	bne	a4,a5,800001da <memmove+0x4a>
    800001ea:	b7f1                	j	800001b6 <memmove+0x26>

00000000800001ec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e406                	sd	ra,8(sp)
    800001f0:	e022                	sd	s0,0(sp)
    800001f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800001f4:	f9dff0ef          	jal	80000190 <memmove>
}
    800001f8:	60a2                	ld	ra,8(sp)
    800001fa:	6402                	ld	s0,0(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret

0000000080000200 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000200:	1141                	addi	sp,sp,-16
    80000202:	e422                	sd	s0,8(sp)
    80000204:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000206:	ce11                	beqz	a2,80000222 <strncmp+0x22>
    80000208:	00054783          	lbu	a5,0(a0)
    8000020c:	cf89                	beqz	a5,80000226 <strncmp+0x26>
    8000020e:	0005c703          	lbu	a4,0(a1)
    80000212:	00f71a63          	bne	a4,a5,80000226 <strncmp+0x26>
    n--, p++, q++;
    80000216:	367d                	addiw	a2,a2,-1
    80000218:	0505                	addi	a0,a0,1
    8000021a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000021c:	f675                	bnez	a2,80000208 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000021e:	4501                	li	a0,0
    80000220:	a801                	j	80000230 <strncmp+0x30>
    80000222:	4501                	li	a0,0
    80000224:	a031                	j	80000230 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000226:	00054503          	lbu	a0,0(a0)
    8000022a:	0005c783          	lbu	a5,0(a1)
    8000022e:	9d1d                	subw	a0,a0,a5
}
    80000230:	6422                	ld	s0,8(sp)
    80000232:	0141                	addi	sp,sp,16
    80000234:	8082                	ret

0000000080000236 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000236:	1141                	addi	sp,sp,-16
    80000238:	e422                	sd	s0,8(sp)
    8000023a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000023c:	87aa                	mv	a5,a0
    8000023e:	86b2                	mv	a3,a2
    80000240:	367d                	addiw	a2,a2,-1
    80000242:	02d05563          	blez	a3,8000026c <strncpy+0x36>
    80000246:	0785                	addi	a5,a5,1
    80000248:	0005c703          	lbu	a4,0(a1)
    8000024c:	fee78fa3          	sb	a4,-1(a5)
    80000250:	0585                	addi	a1,a1,1
    80000252:	f775                	bnez	a4,8000023e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000254:	873e                	mv	a4,a5
    80000256:	9fb5                	addw	a5,a5,a3
    80000258:	37fd                	addiw	a5,a5,-1
    8000025a:	00c05963          	blez	a2,8000026c <strncpy+0x36>
    *s++ = 0;
    8000025e:	0705                	addi	a4,a4,1
    80000260:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000264:	40e786bb          	subw	a3,a5,a4
    80000268:	fed04be3          	bgtz	a3,8000025e <strncpy+0x28>
  return os;
}
    8000026c:	6422                	ld	s0,8(sp)
    8000026e:	0141                	addi	sp,sp,16
    80000270:	8082                	ret

0000000080000272 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000272:	1141                	addi	sp,sp,-16
    80000274:	e422                	sd	s0,8(sp)
    80000276:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000278:	02c05363          	blez	a2,8000029e <safestrcpy+0x2c>
    8000027c:	fff6069b          	addiw	a3,a2,-1
    80000280:	1682                	slli	a3,a3,0x20
    80000282:	9281                	srli	a3,a3,0x20
    80000284:	96ae                	add	a3,a3,a1
    80000286:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000288:	00d58963          	beq	a1,a3,8000029a <safestrcpy+0x28>
    8000028c:	0585                	addi	a1,a1,1
    8000028e:	0785                	addi	a5,a5,1
    80000290:	fff5c703          	lbu	a4,-1(a1)
    80000294:	fee78fa3          	sb	a4,-1(a5)
    80000298:	fb65                	bnez	a4,80000288 <safestrcpy+0x16>
    ;
  *s = 0;
    8000029a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000029e:	6422                	ld	s0,8(sp)
    800002a0:	0141                	addi	sp,sp,16
    800002a2:	8082                	ret

00000000800002a4 <strlen>:

int
strlen(const char *s)
{
    800002a4:	1141                	addi	sp,sp,-16
    800002a6:	e422                	sd	s0,8(sp)
    800002a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002aa:	00054783          	lbu	a5,0(a0)
    800002ae:	cf91                	beqz	a5,800002ca <strlen+0x26>
    800002b0:	0505                	addi	a0,a0,1
    800002b2:	87aa                	mv	a5,a0
    800002b4:	86be                	mv	a3,a5
    800002b6:	0785                	addi	a5,a5,1
    800002b8:	fff7c703          	lbu	a4,-1(a5)
    800002bc:	ff65                	bnez	a4,800002b4 <strlen+0x10>
    800002be:	40a6853b          	subw	a0,a3,a0
    800002c2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret
  for(n = 0; s[n]; n++)
    800002ca:	4501                	li	a0,0
    800002cc:	bfe5                	j	800002c4 <strlen+0x20>

00000000800002ce <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e406                	sd	ra,8(sp)
    800002d2:	e022                	sd	s0,0(sp)
    800002d4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002d6:	255000ef          	jal	80000d2a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002da:	0000a717          	auipc	a4,0xa
    800002de:	0e670713          	addi	a4,a4,230 # 8000a3c0 <started>
  if(cpuid() == 0){
    800002e2:	c51d                	beqz	a0,80000310 <main+0x42>
    while(started == 0)
    800002e4:	431c                	lw	a5,0(a4)
    800002e6:	2781                	sext.w	a5,a5
    800002e8:	dff5                	beqz	a5,800002e4 <main+0x16>
      ;
    __sync_synchronize();
    800002ea:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800002ee:	23d000ef          	jal	80000d2a <cpuid>
    800002f2:	85aa                	mv	a1,a0
    800002f4:	00007517          	auipc	a0,0x7
    800002f8:	d4450513          	addi	a0,a0,-700 # 80007038 <etext+0x38>
    800002fc:	6d5040ef          	jal	800051d0 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	54e010ef          	jal	80001852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	480040ef          	jal	80004788 <plicinithart>
  }

  scheduler();        
    8000030c:	68b000ef          	jal	80001196 <scheduler>
    consoleinit();
    80000310:	5eb040ef          	jal	800050fa <consoleinit>
    printfinit();
    80000314:	1c8050ef          	jal	800054dc <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	6b1040ef          	jal	800051d0 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	6a5040ef          	jal	800051d0 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	699040ef          	jal	800051d0 <printf>
    kinit();         // physical page allocator
    8000033c:	d87ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    80000340:	2ca000ef          	jal	8000060a <kvminit>
    kvminithart();   // turn on paging
    80000344:	03c000ef          	jal	80000380 <kvminithart>
    procinit();      // process table
    80000348:	12d000ef          	jal	80000c74 <procinit>
    trapinit();      // trap vectors
    8000034c:	4e2010ef          	jal	8000182e <trapinit>
    trapinithart();  // install kernel trap vector
    80000350:	502010ef          	jal	80001852 <trapinithart>
    plicinit();      // set up interrupt controller
    80000354:	41a040ef          	jal	8000476e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	430040ef          	jal	80004788 <plicinithart>
    binit();         // buffer cache
    8000035c:	3d7010ef          	jal	80001f32 <binit>
    iinit();         // inode table
    80000360:	1c8020ef          	jal	80002528 <iinit>
    fileinit();      // file table
    80000364:	775020ef          	jal	800032d8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	510040ef          	jal	80004878 <virtio_disk_init>
    userinit();      // first user process
    8000036c:	457000ef          	jal	80000fc2 <userinit>
    __sync_synchronize();
    80000370:	0330000f          	fence	rw,rw
    started = 1;
    80000374:	4785                	li	a5,1
    80000376:	0000a717          	auipc	a4,0xa
    8000037a:	04f72523          	sw	a5,74(a4) # 8000a3c0 <started>
    8000037e:	b779                	j	8000030c <main+0x3e>

0000000080000380 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000380:	1141                	addi	sp,sp,-16
    80000382:	e422                	sd	s0,8(sp)
    80000384:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000386:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000038a:	0000a797          	auipc	a5,0xa
    8000038e:	03e7b783          	ld	a5,62(a5) # 8000a3c8 <kernel_pagetable>
    80000392:	83b1                	srli	a5,a5,0xc
    80000394:	577d                	li	a4,-1
    80000396:	177e                	slli	a4,a4,0x3f
    80000398:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000039a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000039e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003a2:	6422                	ld	s0,8(sp)
    800003a4:	0141                	addi	sp,sp,16
    800003a6:	8082                	ret

00000000800003a8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003a8:	7139                	addi	sp,sp,-64
    800003aa:	fc06                	sd	ra,56(sp)
    800003ac:	f822                	sd	s0,48(sp)
    800003ae:	f426                	sd	s1,40(sp)
    800003b0:	f04a                	sd	s2,32(sp)
    800003b2:	ec4e                	sd	s3,24(sp)
    800003b4:	e852                	sd	s4,16(sp)
    800003b6:	e456                	sd	s5,8(sp)
    800003b8:	e05a                	sd	s6,0(sp)
    800003ba:	0080                	addi	s0,sp,64
    800003bc:	84aa                	mv	s1,a0
    800003be:	89ae                	mv	s3,a1
    800003c0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003c2:	57fd                	li	a5,-1
    800003c4:	83e9                	srli	a5,a5,0x1a
    800003c6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003c8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003ca:	02b7fc63          	bgeu	a5,a1,80000402 <walk+0x5a>
    panic("walk");
    800003ce:	00007517          	auipc	a0,0x7
    800003d2:	c8250513          	addi	a0,a0,-894 # 80007050 <etext+0x50>
    800003d6:	0cc050ef          	jal	800054a2 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003da:	060a8263          	beqz	s5,8000043e <walk+0x96>
    800003de:	d19ff0ef          	jal	800000f6 <kalloc>
    800003e2:	84aa                	mv	s1,a0
    800003e4:	c139                	beqz	a0,8000042a <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800003e6:	6605                	lui	a2,0x1
    800003e8:	4581                	li	a1,0
    800003ea:	d4bff0ef          	jal	80000134 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800003ee:	00c4d793          	srli	a5,s1,0xc
    800003f2:	07aa                	slli	a5,a5,0xa
    800003f4:	0017e793          	ori	a5,a5,1
    800003f8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800003fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb6d7>
    800003fe:	036a0063          	beq	s4,s6,8000041e <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000402:	0149d933          	srl	s2,s3,s4
    80000406:	1ff97913          	andi	s2,s2,511
    8000040a:	090e                	slli	s2,s2,0x3
    8000040c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000040e:	00093483          	ld	s1,0(s2)
    80000412:	0014f793          	andi	a5,s1,1
    80000416:	d3f1                	beqz	a5,800003da <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000418:	80a9                	srli	s1,s1,0xa
    8000041a:	04b2                	slli	s1,s1,0xc
    8000041c:	b7c5                	j	800003fc <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000041e:	00c9d513          	srli	a0,s3,0xc
    80000422:	1ff57513          	andi	a0,a0,511
    80000426:	050e                	slli	a0,a0,0x3
    80000428:	9526                	add	a0,a0,s1
}
    8000042a:	70e2                	ld	ra,56(sp)
    8000042c:	7442                	ld	s0,48(sp)
    8000042e:	74a2                	ld	s1,40(sp)
    80000430:	7902                	ld	s2,32(sp)
    80000432:	69e2                	ld	s3,24(sp)
    80000434:	6a42                	ld	s4,16(sp)
    80000436:	6aa2                	ld	s5,8(sp)
    80000438:	6b02                	ld	s6,0(sp)
    8000043a:	6121                	addi	sp,sp,64
    8000043c:	8082                	ret
        return 0;
    8000043e:	4501                	li	a0,0
    80000440:	b7ed                	j	8000042a <walk+0x82>

0000000080000442 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000442:	57fd                	li	a5,-1
    80000444:	83e9                	srli	a5,a5,0x1a
    80000446:	00b7f463          	bgeu	a5,a1,8000044e <walkaddr+0xc>
    return 0;
    8000044a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000044c:	8082                	ret
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e406                	sd	ra,8(sp)
    80000452:	e022                	sd	s0,0(sp)
    80000454:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000456:	4601                	li	a2,0
    80000458:	f51ff0ef          	jal	800003a8 <walk>
  if(pte == 0)
    8000045c:	c105                	beqz	a0,8000047c <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000045e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000460:	0117f693          	andi	a3,a5,17
    80000464:	4745                	li	a4,17
    return 0;
    80000466:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000468:	00e68663          	beq	a3,a4,80000474 <walkaddr+0x32>
}
    8000046c:	60a2                	ld	ra,8(sp)
    8000046e:	6402                	ld	s0,0(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret
  pa = PTE2PA(*pte);
    80000474:	83a9                	srli	a5,a5,0xa
    80000476:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000047a:	bfcd                	j	8000046c <walkaddr+0x2a>
    return 0;
    8000047c:	4501                	li	a0,0
    8000047e:	b7fd                	j	8000046c <walkaddr+0x2a>

0000000080000480 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000480:	715d                	addi	sp,sp,-80
    80000482:	e486                	sd	ra,72(sp)
    80000484:	e0a2                	sd	s0,64(sp)
    80000486:	fc26                	sd	s1,56(sp)
    80000488:	f84a                	sd	s2,48(sp)
    8000048a:	f44e                	sd	s3,40(sp)
    8000048c:	f052                	sd	s4,32(sp)
    8000048e:	ec56                	sd	s5,24(sp)
    80000490:	e85a                	sd	s6,16(sp)
    80000492:	e45e                	sd	s7,8(sp)
    80000494:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000496:	03459793          	slli	a5,a1,0x34
    8000049a:	e7a9                	bnez	a5,800004e4 <mappages+0x64>
    8000049c:	8aaa                	mv	s5,a0
    8000049e:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004a0:	03461793          	slli	a5,a2,0x34
    800004a4:	e7b1                	bnez	a5,800004f0 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004a6:	ca39                	beqz	a2,800004fc <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004a8:	77fd                	lui	a5,0xfffff
    800004aa:	963e                	add	a2,a2,a5
    800004ac:	00b609b3          	add	s3,a2,a1
  a = va;
    800004b0:	892e                	mv	s2,a1
    800004b2:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004b6:	6b85                	lui	s7,0x1
    800004b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004bc:	4605                	li	a2,1
    800004be:	85ca                	mv	a1,s2
    800004c0:	8556                	mv	a0,s5
    800004c2:	ee7ff0ef          	jal	800003a8 <walk>
    800004c6:	c539                	beqz	a0,80000514 <mappages+0x94>
    if(*pte & PTE_V)
    800004c8:	611c                	ld	a5,0(a0)
    800004ca:	8b85                	andi	a5,a5,1
    800004cc:	ef95                	bnez	a5,80000508 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004ce:	80b1                	srli	s1,s1,0xc
    800004d0:	04aa                	slli	s1,s1,0xa
    800004d2:	0164e4b3          	or	s1,s1,s6
    800004d6:	0014e493          	ori	s1,s1,1
    800004da:	e104                	sd	s1,0(a0)
    if(a == last)
    800004dc:	05390863          	beq	s2,s3,8000052c <mappages+0xac>
    a += PGSIZE;
    800004e0:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e2:	bfd9                	j	800004b8 <mappages+0x38>
    panic("mappages: va not aligned");
    800004e4:	00007517          	auipc	a0,0x7
    800004e8:	b7450513          	addi	a0,a0,-1164 # 80007058 <etext+0x58>
    800004ec:	7b7040ef          	jal	800054a2 <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	7ab040ef          	jal	800054a2 <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	79f040ef          	jal	800054a2 <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	793040ef          	jal	800054a2 <panic>
      return -1;
    80000514:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000516:	60a6                	ld	ra,72(sp)
    80000518:	6406                	ld	s0,64(sp)
    8000051a:	74e2                	ld	s1,56(sp)
    8000051c:	7942                	ld	s2,48(sp)
    8000051e:	79a2                	ld	s3,40(sp)
    80000520:	7a02                	ld	s4,32(sp)
    80000522:	6ae2                	ld	s5,24(sp)
    80000524:	6b42                	ld	s6,16(sp)
    80000526:	6ba2                	ld	s7,8(sp)
    80000528:	6161                	addi	sp,sp,80
    8000052a:	8082                	ret
  return 0;
    8000052c:	4501                	li	a0,0
    8000052e:	b7e5                	j	80000516 <mappages+0x96>

0000000080000530 <kvmmap>:
{
    80000530:	1141                	addi	sp,sp,-16
    80000532:	e406                	sd	ra,8(sp)
    80000534:	e022                	sd	s0,0(sp)
    80000536:	0800                	addi	s0,sp,16
    80000538:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000053a:	86b2                	mv	a3,a2
    8000053c:	863e                	mv	a2,a5
    8000053e:	f43ff0ef          	jal	80000480 <mappages>
    80000542:	e509                	bnez	a0,8000054c <kvmmap+0x1c>
}
    80000544:	60a2                	ld	ra,8(sp)
    80000546:	6402                	ld	s0,0(sp)
    80000548:	0141                	addi	sp,sp,16
    8000054a:	8082                	ret
    panic("kvmmap");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b6c50513          	addi	a0,a0,-1172 # 800070b8 <etext+0xb8>
    80000554:	74f040ef          	jal	800054a2 <panic>

0000000080000558 <kvmmake>:
{
    80000558:	1101                	addi	sp,sp,-32
    8000055a:	ec06                	sd	ra,24(sp)
    8000055c:	e822                	sd	s0,16(sp)
    8000055e:	e426                	sd	s1,8(sp)
    80000560:	e04a                	sd	s2,0(sp)
    80000562:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000564:	b93ff0ef          	jal	800000f6 <kalloc>
    80000568:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000056a:	6605                	lui	a2,0x1
    8000056c:	4581                	li	a1,0
    8000056e:	bc7ff0ef          	jal	80000134 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000572:	4719                	li	a4,6
    80000574:	6685                	lui	a3,0x1
    80000576:	10000637          	lui	a2,0x10000
    8000057a:	100005b7          	lui	a1,0x10000
    8000057e:	8526                	mv	a0,s1
    80000580:	fb1ff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000584:	4719                	li	a4,6
    80000586:	6685                	lui	a3,0x1
    80000588:	10001637          	lui	a2,0x10001
    8000058c:	100015b7          	lui	a1,0x10001
    80000590:	8526                	mv	a0,s1
    80000592:	f9fff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80000596:	4719                	li	a4,6
    80000598:	040006b7          	lui	a3,0x4000
    8000059c:	0c000637          	lui	a2,0xc000
    800005a0:	0c0005b7          	lui	a1,0xc000
    800005a4:	8526                	mv	a0,s1
    800005a6:	f8bff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005aa:	00007917          	auipc	s2,0x7
    800005ae:	a5690913          	addi	s2,s2,-1450 # 80007000 <etext>
    800005b2:	4729                	li	a4,10
    800005b4:	80007697          	auipc	a3,0x80007
    800005b8:	a4c68693          	addi	a3,a3,-1460 # 7000 <_entry-0x7fff9000>
    800005bc:	4605                	li	a2,1
    800005be:	067e                	slli	a2,a2,0x1f
    800005c0:	85b2                	mv	a1,a2
    800005c2:	8526                	mv	a0,s1
    800005c4:	f6dff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005c8:	46c5                	li	a3,17
    800005ca:	06ee                	slli	a3,a3,0x1b
    800005cc:	4719                	li	a4,6
    800005ce:	412686b3          	sub	a3,a3,s2
    800005d2:	864a                	mv	a2,s2
    800005d4:	85ca                	mv	a1,s2
    800005d6:	8526                	mv	a0,s1
    800005d8:	f59ff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005dc:	4729                	li	a4,10
    800005de:	6685                	lui	a3,0x1
    800005e0:	00006617          	auipc	a2,0x6
    800005e4:	a2060613          	addi	a2,a2,-1504 # 80006000 <_trampoline>
    800005e8:	040005b7          	lui	a1,0x4000
    800005ec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800005ee:	05b2                	slli	a1,a1,0xc
    800005f0:	8526                	mv	a0,s1
    800005f2:	f3fff0ef          	jal	80000530 <kvmmap>
  proc_mapstacks(kpgtbl);
    800005f6:	8526                	mv	a0,s1
    800005f8:	5e4000ef          	jal	80000bdc <proc_mapstacks>
}
    800005fc:	8526                	mv	a0,s1
    800005fe:	60e2                	ld	ra,24(sp)
    80000600:	6442                	ld	s0,16(sp)
    80000602:	64a2                	ld	s1,8(sp)
    80000604:	6902                	ld	s2,0(sp)
    80000606:	6105                	addi	sp,sp,32
    80000608:	8082                	ret

000000008000060a <kvminit>:
{
    8000060a:	1141                	addi	sp,sp,-16
    8000060c:	e406                	sd	ra,8(sp)
    8000060e:	e022                	sd	s0,0(sp)
    80000610:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000612:	f47ff0ef          	jal	80000558 <kvmmake>
    80000616:	0000a797          	auipc	a5,0xa
    8000061a:	daa7b923          	sd	a0,-590(a5) # 8000a3c8 <kernel_pagetable>
}
    8000061e:	60a2                	ld	ra,8(sp)
    80000620:	6402                	ld	s0,0(sp)
    80000622:	0141                	addi	sp,sp,16
    80000624:	8082                	ret

0000000080000626 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000626:	715d                	addi	sp,sp,-80
    80000628:	e486                	sd	ra,72(sp)
    8000062a:	e0a2                	sd	s0,64(sp)
    8000062c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    8000062e:	03459793          	slli	a5,a1,0x34
    80000632:	e39d                	bnez	a5,80000658 <uvmunmap+0x32>
    80000634:	f84a                	sd	s2,48(sp)
    80000636:	f44e                	sd	s3,40(sp)
    80000638:	f052                	sd	s4,32(sp)
    8000063a:	ec56                	sd	s5,24(sp)
    8000063c:	e85a                	sd	s6,16(sp)
    8000063e:	e45e                	sd	s7,8(sp)
    80000640:	8a2a                	mv	s4,a0
    80000642:	892e                	mv	s2,a1
    80000644:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000646:	0632                	slli	a2,a2,0xc
    80000648:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000064c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000064e:	6b05                	lui	s6,0x1
    80000650:	0935f763          	bgeu	a1,s3,800006de <uvmunmap+0xb8>
    80000654:	fc26                	sd	s1,56(sp)
    80000656:	a8a1                	j	800006ae <uvmunmap+0x88>
    80000658:	fc26                	sd	s1,56(sp)
    8000065a:	f84a                	sd	s2,48(sp)
    8000065c:	f44e                	sd	s3,40(sp)
    8000065e:	f052                	sd	s4,32(sp)
    80000660:	ec56                	sd	s5,24(sp)
    80000662:	e85a                	sd	s6,16(sp)
    80000664:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000666:	00007517          	auipc	a0,0x7
    8000066a:	a5a50513          	addi	a0,a0,-1446 # 800070c0 <etext+0xc0>
    8000066e:	635040ef          	jal	800054a2 <panic>
      panic("uvmunmap: walk");
    80000672:	00007517          	auipc	a0,0x7
    80000676:	a6650513          	addi	a0,a0,-1434 # 800070d8 <etext+0xd8>
    8000067a:	629040ef          	jal	800054a2 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000067e:	85ca                	mv	a1,s2
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a6850513          	addi	a0,a0,-1432 # 800070e8 <etext+0xe8>
    80000688:	349040ef          	jal	800051d0 <printf>
      panic("uvmunmap: not mapped");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a6c50513          	addi	a0,a0,-1428 # 800070f8 <etext+0xf8>
    80000694:	60f040ef          	jal	800054a2 <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a7850513          	addi	a0,a0,-1416 # 80007110 <etext+0x110>
    800006a0:	603040ef          	jal	800054a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006a8:	995a                	add	s2,s2,s6
    800006aa:	03397963          	bgeu	s2,s3,800006dc <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006ae:	4601                	li	a2,0
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8552                	mv	a0,s4
    800006b4:	cf5ff0ef          	jal	800003a8 <walk>
    800006b8:	84aa                	mv	s1,a0
    800006ba:	dd45                	beqz	a0,80000672 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006bc:	6110                	ld	a2,0(a0)
    800006be:	00167793          	andi	a5,a2,1
    800006c2:	dfd5                	beqz	a5,8000067e <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006c4:	3ff67793          	andi	a5,a2,1023
    800006c8:	fd7788e3          	beq	a5,s7,80000698 <uvmunmap+0x72>
    if(do_free){
    800006cc:	fc0a8ce3          	beqz	s5,800006a4 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    800006d0:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    800006d2:	00c61513          	slli	a0,a2,0xc
    800006d6:	947ff0ef          	jal	8000001c <kfree>
    800006da:	b7e9                	j	800006a4 <uvmunmap+0x7e>
    800006dc:	74e2                	ld	s1,56(sp)
    800006de:	7942                	ld	s2,48(sp)
    800006e0:	79a2                	ld	s3,40(sp)
    800006e2:	7a02                	ld	s4,32(sp)
    800006e4:	6ae2                	ld	s5,24(sp)
    800006e6:	6b42                	ld	s6,16(sp)
    800006e8:	6ba2                	ld	s7,8(sp)
  }
}
    800006ea:	60a6                	ld	ra,72(sp)
    800006ec:	6406                	ld	s0,64(sp)
    800006ee:	6161                	addi	sp,sp,80
    800006f0:	8082                	ret

00000000800006f2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006f2:	1101                	addi	sp,sp,-32
    800006f4:	ec06                	sd	ra,24(sp)
    800006f6:	e822                	sd	s0,16(sp)
    800006f8:	e426                	sd	s1,8(sp)
    800006fa:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800006fc:	9fbff0ef          	jal	800000f6 <kalloc>
    80000700:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000702:	c509                	beqz	a0,8000070c <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000704:	6605                	lui	a2,0x1
    80000706:	4581                	li	a1,0
    80000708:	a2dff0ef          	jal	80000134 <memset>
  return pagetable;
}
    8000070c:	8526                	mv	a0,s1
    8000070e:	60e2                	ld	ra,24(sp)
    80000710:	6442                	ld	s0,16(sp)
    80000712:	64a2                	ld	s1,8(sp)
    80000714:	6105                	addi	sp,sp,32
    80000716:	8082                	ret

0000000080000718 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000718:	7179                	addi	sp,sp,-48
    8000071a:	f406                	sd	ra,40(sp)
    8000071c:	f022                	sd	s0,32(sp)
    8000071e:	ec26                	sd	s1,24(sp)
    80000720:	e84a                	sd	s2,16(sp)
    80000722:	e44e                	sd	s3,8(sp)
    80000724:	e052                	sd	s4,0(sp)
    80000726:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000728:	6785                	lui	a5,0x1
    8000072a:	04f67063          	bgeu	a2,a5,8000076a <uvmfirst+0x52>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	89ae                	mv	s3,a1
    80000732:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000734:	9c3ff0ef          	jal	800000f6 <kalloc>
    80000738:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000073a:	6605                	lui	a2,0x1
    8000073c:	4581                	li	a1,0
    8000073e:	9f7ff0ef          	jal	80000134 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000742:	4779                	li	a4,30
    80000744:	86ca                	mv	a3,s2
    80000746:	6605                	lui	a2,0x1
    80000748:	4581                	li	a1,0
    8000074a:	8552                	mv	a0,s4
    8000074c:	d35ff0ef          	jal	80000480 <mappages>
  memmove(mem, src, sz);
    80000750:	8626                	mv	a2,s1
    80000752:	85ce                	mv	a1,s3
    80000754:	854a                	mv	a0,s2
    80000756:	a3bff0ef          	jal	80000190 <memmove>
}
    8000075a:	70a2                	ld	ra,40(sp)
    8000075c:	7402                	ld	s0,32(sp)
    8000075e:	64e2                	ld	s1,24(sp)
    80000760:	6942                	ld	s2,16(sp)
    80000762:	69a2                	ld	s3,8(sp)
    80000764:	6a02                	ld	s4,0(sp)
    80000766:	6145                	addi	sp,sp,48
    80000768:	8082                	ret
    panic("uvmfirst: more than a page");
    8000076a:	00007517          	auipc	a0,0x7
    8000076e:	9be50513          	addi	a0,a0,-1602 # 80007128 <etext+0x128>
    80000772:	531040ef          	jal	800054a2 <panic>

0000000080000776 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000776:	1101                	addi	sp,sp,-32
    80000778:	ec06                	sd	ra,24(sp)
    8000077a:	e822                	sd	s0,16(sp)
    8000077c:	e426                	sd	s1,8(sp)
    8000077e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000780:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000782:	00b67d63          	bgeu	a2,a1,8000079c <uvmdealloc+0x26>
    80000786:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000788:	6785                	lui	a5,0x1
    8000078a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000078c:	00f60733          	add	a4,a2,a5
    80000790:	76fd                	lui	a3,0xfffff
    80000792:	8f75                	and	a4,a4,a3
    80000794:	97ae                	add	a5,a5,a1
    80000796:	8ff5                	and	a5,a5,a3
    80000798:	00f76863          	bltu	a4,a5,800007a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000079c:	8526                	mv	a0,s1
    8000079e:	60e2                	ld	ra,24(sp)
    800007a0:	6442                	ld	s0,16(sp)
    800007a2:	64a2                	ld	s1,8(sp)
    800007a4:	6105                	addi	sp,sp,32
    800007a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007a8:	8f99                	sub	a5,a5,a4
    800007aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ac:	4685                	li	a3,1
    800007ae:	0007861b          	sext.w	a2,a5
    800007b2:	85ba                	mv	a1,a4
    800007b4:	e73ff0ef          	jal	80000626 <uvmunmap>
    800007b8:	b7d5                	j	8000079c <uvmdealloc+0x26>

00000000800007ba <uvmalloc>:
  if(newsz < oldsz)
    800007ba:	08b66b63          	bltu	a2,a1,80000850 <uvmalloc+0x96>
{
    800007be:	7139                	addi	sp,sp,-64
    800007c0:	fc06                	sd	ra,56(sp)
    800007c2:	f822                	sd	s0,48(sp)
    800007c4:	ec4e                	sd	s3,24(sp)
    800007c6:	e852                	sd	s4,16(sp)
    800007c8:	e456                	sd	s5,8(sp)
    800007ca:	0080                	addi	s0,sp,64
    800007cc:	8aaa                	mv	s5,a0
    800007ce:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007d0:	6785                	lui	a5,0x1
    800007d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d4:	95be                	add	a1,a1,a5
    800007d6:	77fd                	lui	a5,0xfffff
    800007d8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    800007dc:	06c9fc63          	bgeu	s3,a2,80000854 <uvmalloc+0x9a>
    800007e0:	f426                	sd	s1,40(sp)
    800007e2:	f04a                	sd	s2,32(sp)
    800007e4:	e05a                	sd	s6,0(sp)
    800007e6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007e8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007ec:	90bff0ef          	jal	800000f6 <kalloc>
    800007f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800007f2:	c115                	beqz	a0,80000816 <uvmalloc+0x5c>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f4:	875a                	mv	a4,s6
    800007f6:	86aa                	mv	a3,a0
    800007f8:	6605                	lui	a2,0x1
    800007fa:	85ca                	mv	a1,s2
    800007fc:	8556                	mv	a0,s5
    800007fe:	c83ff0ef          	jal	80000480 <mappages>
    80000802:	e915                	bnez	a0,80000836 <uvmalloc+0x7c>
  for(a = oldsz; a < newsz; a += sz){
    80000804:	6785                	lui	a5,0x1
    80000806:	993e                	add	s2,s2,a5
    80000808:	ff4962e3          	bltu	s2,s4,800007ec <uvmalloc+0x32>
  return newsz;
    8000080c:	8552                	mv	a0,s4
    8000080e:	74a2                	ld	s1,40(sp)
    80000810:	7902                	ld	s2,32(sp)
    80000812:	6b02                	ld	s6,0(sp)
    80000814:	a811                	j	80000828 <uvmalloc+0x6e>
      uvmdealloc(pagetable, a, oldsz);
    80000816:	864e                	mv	a2,s3
    80000818:	85ca                	mv	a1,s2
    8000081a:	8556                	mv	a0,s5
    8000081c:	f5bff0ef          	jal	80000776 <uvmdealloc>
      return 0;
    80000820:	4501                	li	a0,0
    80000822:	74a2                	ld	s1,40(sp)
    80000824:	7902                	ld	s2,32(sp)
    80000826:	6b02                	ld	s6,0(sp)
}
    80000828:	70e2                	ld	ra,56(sp)
    8000082a:	7442                	ld	s0,48(sp)
    8000082c:	69e2                	ld	s3,24(sp)
    8000082e:	6a42                	ld	s4,16(sp)
    80000830:	6aa2                	ld	s5,8(sp)
    80000832:	6121                	addi	sp,sp,64
    80000834:	8082                	ret
      kfree(mem);
    80000836:	8526                	mv	a0,s1
    80000838:	fe4ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000083c:	864e                	mv	a2,s3
    8000083e:	85ca                	mv	a1,s2
    80000840:	8556                	mv	a0,s5
    80000842:	f35ff0ef          	jal	80000776 <uvmdealloc>
      return 0;
    80000846:	4501                	li	a0,0
    80000848:	74a2                	ld	s1,40(sp)
    8000084a:	7902                	ld	s2,32(sp)
    8000084c:	6b02                	ld	s6,0(sp)
    8000084e:	bfe9                	j	80000828 <uvmalloc+0x6e>
    return oldsz;
    80000850:	852e                	mv	a0,a1
}
    80000852:	8082                	ret
  return newsz;
    80000854:	8532                	mv	a0,a2
    80000856:	bfc9                	j	80000828 <uvmalloc+0x6e>

0000000080000858 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000858:	7179                	addi	sp,sp,-48
    8000085a:	f406                	sd	ra,40(sp)
    8000085c:	f022                	sd	s0,32(sp)
    8000085e:	ec26                	sd	s1,24(sp)
    80000860:	e84a                	sd	s2,16(sp)
    80000862:	e44e                	sd	s3,8(sp)
    80000864:	e052                	sd	s4,0(sp)
    80000866:	1800                	addi	s0,sp,48
    80000868:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000086a:	84aa                	mv	s1,a0
    8000086c:	6905                	lui	s2,0x1
    8000086e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000870:	4985                	li	s3,1
    80000872:	a819                	j	80000888 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000874:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000876:	00c79513          	slli	a0,a5,0xc
    8000087a:	fdfff0ef          	jal	80000858 <freewalk>
      pagetable[i] = 0;
    8000087e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000882:	04a1                	addi	s1,s1,8
    80000884:	01248f63          	beq	s1,s2,800008a2 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000888:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000088a:	00f7f713          	andi	a4,a5,15
    8000088e:	ff3703e3          	beq	a4,s3,80000874 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000892:	8b85                	andi	a5,a5,1
    80000894:	d7fd                	beqz	a5,80000882 <freewalk+0x2a>
      panic("freewalk: leaf");
    80000896:	00007517          	auipc	a0,0x7
    8000089a:	8b250513          	addi	a0,a0,-1870 # 80007148 <etext+0x148>
    8000089e:	405040ef          	jal	800054a2 <panic>
    }
  }
  kfree((void*)pagetable);
    800008a2:	8552                	mv	a0,s4
    800008a4:	f78ff0ef          	jal	8000001c <kfree>
}
    800008a8:	70a2                	ld	ra,40(sp)
    800008aa:	7402                	ld	s0,32(sp)
    800008ac:	64e2                	ld	s1,24(sp)
    800008ae:	6942                	ld	s2,16(sp)
    800008b0:	69a2                	ld	s3,8(sp)
    800008b2:	6a02                	ld	s4,0(sp)
    800008b4:	6145                	addi	sp,sp,48
    800008b6:	8082                	ret

00000000800008b8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008b8:	1101                	addi	sp,sp,-32
    800008ba:	ec06                	sd	ra,24(sp)
    800008bc:	e822                	sd	s0,16(sp)
    800008be:	e426                	sd	s1,8(sp)
    800008c0:	1000                	addi	s0,sp,32
    800008c2:	84aa                	mv	s1,a0
  if(sz > 0)
    800008c4:	e989                	bnez	a1,800008d6 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008c6:	8526                	mv	a0,s1
    800008c8:	f91ff0ef          	jal	80000858 <freewalk>
}
    800008cc:	60e2                	ld	ra,24(sp)
    800008ce:	6442                	ld	s0,16(sp)
    800008d0:	64a2                	ld	s1,8(sp)
    800008d2:	6105                	addi	sp,sp,32
    800008d4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008d6:	6785                	lui	a5,0x1
    800008d8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008da:	95be                	add	a1,a1,a5
    800008dc:	4685                	li	a3,1
    800008de:	00c5d613          	srli	a2,a1,0xc
    800008e2:	4581                	li	a1,0
    800008e4:	d43ff0ef          	jal	80000626 <uvmunmap>
    800008e8:	bff9                	j	800008c6 <uvmfree+0xe>

00000000800008ea <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    800008ea:	c65d                	beqz	a2,80000998 <uvmcopy+0xae>
{
    800008ec:	715d                	addi	sp,sp,-80
    800008ee:	e486                	sd	ra,72(sp)
    800008f0:	e0a2                	sd	s0,64(sp)
    800008f2:	fc26                	sd	s1,56(sp)
    800008f4:	f84a                	sd	s2,48(sp)
    800008f6:	f44e                	sd	s3,40(sp)
    800008f8:	f052                	sd	s4,32(sp)
    800008fa:	ec56                	sd	s5,24(sp)
    800008fc:	e85a                	sd	s6,16(sp)
    800008fe:	e45e                	sd	s7,8(sp)
    80000900:	0880                	addi	s0,sp,80
    80000902:	8b2a                	mv	s6,a0
    80000904:	8aae                	mv	s5,a1
    80000906:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000908:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    8000090a:	4601                	li	a2,0
    8000090c:	85ce                	mv	a1,s3
    8000090e:	855a                	mv	a0,s6
    80000910:	a99ff0ef          	jal	800003a8 <walk>
    80000914:	c121                	beqz	a0,80000954 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000916:	6118                	ld	a4,0(a0)
    80000918:	00177793          	andi	a5,a4,1
    8000091c:	c3b1                	beqz	a5,80000960 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000091e:	00a75593          	srli	a1,a4,0xa
    80000922:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000926:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000092a:	fccff0ef          	jal	800000f6 <kalloc>
    8000092e:	892a                	mv	s2,a0
    80000930:	c129                	beqz	a0,80000972 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000932:	6605                	lui	a2,0x1
    80000934:	85de                	mv	a1,s7
    80000936:	85bff0ef          	jal	80000190 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000093a:	8726                	mv	a4,s1
    8000093c:	86ca                	mv	a3,s2
    8000093e:	6605                	lui	a2,0x1
    80000940:	85ce                	mv	a1,s3
    80000942:	8556                	mv	a0,s5
    80000944:	b3dff0ef          	jal	80000480 <mappages>
    80000948:	e115                	bnez	a0,8000096c <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    8000094a:	6785                	lui	a5,0x1
    8000094c:	99be                	add	s3,s3,a5
    8000094e:	fb49eee3          	bltu	s3,s4,8000090a <uvmcopy+0x20>
    80000952:	a805                	j	80000982 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000954:	00007517          	auipc	a0,0x7
    80000958:	80450513          	addi	a0,a0,-2044 # 80007158 <etext+0x158>
    8000095c:	347040ef          	jal	800054a2 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	81850513          	addi	a0,a0,-2024 # 80007178 <etext+0x178>
    80000968:	33b040ef          	jal	800054a2 <panic>
      kfree(mem);
    8000096c:	854a                	mv	a0,s2
    8000096e:	eaeff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000972:	4685                	li	a3,1
    80000974:	00c9d613          	srli	a2,s3,0xc
    80000978:	4581                	li	a1,0
    8000097a:	8556                	mv	a0,s5
    8000097c:	cabff0ef          	jal	80000626 <uvmunmap>
  return -1;
    80000980:	557d                	li	a0,-1
}
    80000982:	60a6                	ld	ra,72(sp)
    80000984:	6406                	ld	s0,64(sp)
    80000986:	74e2                	ld	s1,56(sp)
    80000988:	7942                	ld	s2,48(sp)
    8000098a:	79a2                	ld	s3,40(sp)
    8000098c:	7a02                	ld	s4,32(sp)
    8000098e:	6ae2                	ld	s5,24(sp)
    80000990:	6b42                	ld	s6,16(sp)
    80000992:	6ba2                	ld	s7,8(sp)
    80000994:	6161                	addi	sp,sp,80
    80000996:	8082                	ret
  return 0;
    80000998:	4501                	li	a0,0
}
    8000099a:	8082                	ret

000000008000099c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000099c:	1141                	addi	sp,sp,-16
    8000099e:	e406                	sd	ra,8(sp)
    800009a0:	e022                	sd	s0,0(sp)
    800009a2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009a4:	4601                	li	a2,0
    800009a6:	a03ff0ef          	jal	800003a8 <walk>
  if(pte == 0)
    800009aa:	c901                	beqz	a0,800009ba <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ac:	611c                	ld	a5,0(a0)
    800009ae:	9bbd                	andi	a5,a5,-17
    800009b0:	e11c                	sd	a5,0(a0)
}
    800009b2:	60a2                	ld	ra,8(sp)
    800009b4:	6402                	ld	s0,0(sp)
    800009b6:	0141                	addi	sp,sp,16
    800009b8:	8082                	ret
    panic("uvmclear");
    800009ba:	00006517          	auipc	a0,0x6
    800009be:	7de50513          	addi	a0,a0,2014 # 80007198 <etext+0x198>
    800009c2:	2e1040ef          	jal	800054a2 <panic>

00000000800009c6 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009c6:	cac1                	beqz	a3,80000a56 <copyout+0x90>
{
    800009c8:	711d                	addi	sp,sp,-96
    800009ca:	ec86                	sd	ra,88(sp)
    800009cc:	e8a2                	sd	s0,80(sp)
    800009ce:	e4a6                	sd	s1,72(sp)
    800009d0:	fc4e                	sd	s3,56(sp)
    800009d2:	f852                	sd	s4,48(sp)
    800009d4:	f456                	sd	s5,40(sp)
    800009d6:	f05a                	sd	s6,32(sp)
    800009d8:	1080                	addi	s0,sp,96
    800009da:	8b2a                	mv	s6,a0
    800009dc:	8a2e                	mv	s4,a1
    800009de:	8ab2                	mv	s5,a2
    800009e0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009e2:	74fd                	lui	s1,0xfffff
    800009e4:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    800009e6:	57fd                	li	a5,-1
    800009e8:	83e9                	srli	a5,a5,0x1a
    800009ea:	0697e863          	bltu	a5,s1,80000a5a <copyout+0x94>
    800009ee:	e0ca                	sd	s2,64(sp)
    800009f0:	ec5e                	sd	s7,24(sp)
    800009f2:	e862                	sd	s8,16(sp)
    800009f4:	e466                	sd	s9,8(sp)
    800009f6:	6c05                	lui	s8,0x1
    800009f8:	8bbe                	mv	s7,a5
    800009fa:	a015                	j	80000a1e <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800009fc:	409a04b3          	sub	s1,s4,s1
    80000a00:	0009061b          	sext.w	a2,s2
    80000a04:	85d6                	mv	a1,s5
    80000a06:	9526                	add	a0,a0,s1
    80000a08:	f88ff0ef          	jal	80000190 <memmove>

    len -= n;
    80000a0c:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a10:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a12:	02098c63          	beqz	s3,80000a4a <copyout+0x84>
    if (va0 >= MAXVA)
    80000a16:	059be463          	bltu	s7,s9,80000a5e <copyout+0x98>
    80000a1a:	84e6                	mv	s1,s9
    80000a1c:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a1e:	4601                	li	a2,0
    80000a20:	85a6                	mv	a1,s1
    80000a22:	855a                	mv	a0,s6
    80000a24:	985ff0ef          	jal	800003a8 <walk>
    80000a28:	c129                	beqz	a0,80000a6a <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a2a:	611c                	ld	a5,0(a0)
    80000a2c:	8b91                	andi	a5,a5,4
    80000a2e:	cfa1                	beqz	a5,80000a86 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a30:	85a6                	mv	a1,s1
    80000a32:	855a                	mv	a0,s6
    80000a34:	a0fff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000a38:	cd29                	beqz	a0,80000a92 <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a3a:	01848cb3          	add	s9,s1,s8
    80000a3e:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a42:	fb29fde3          	bgeu	s3,s2,800009fc <copyout+0x36>
    80000a46:	894e                	mv	s2,s3
    80000a48:	bf55                	j	800009fc <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a4a:	4501                	li	a0,0
    80000a4c:	6906                	ld	s2,64(sp)
    80000a4e:	6be2                	ld	s7,24(sp)
    80000a50:	6c42                	ld	s8,16(sp)
    80000a52:	6ca2                	ld	s9,8(sp)
    80000a54:	a005                	j	80000a74 <copyout+0xae>
    80000a56:	4501                	li	a0,0
}
    80000a58:	8082                	ret
      return -1;
    80000a5a:	557d                	li	a0,-1
    80000a5c:	a821                	j	80000a74 <copyout+0xae>
    80000a5e:	557d                	li	a0,-1
    80000a60:	6906                	ld	s2,64(sp)
    80000a62:	6be2                	ld	s7,24(sp)
    80000a64:	6c42                	ld	s8,16(sp)
    80000a66:	6ca2                	ld	s9,8(sp)
    80000a68:	a031                	j	80000a74 <copyout+0xae>
      return -1;
    80000a6a:	557d                	li	a0,-1
    80000a6c:	6906                	ld	s2,64(sp)
    80000a6e:	6be2                	ld	s7,24(sp)
    80000a70:	6c42                	ld	s8,16(sp)
    80000a72:	6ca2                	ld	s9,8(sp)
}
    80000a74:	60e6                	ld	ra,88(sp)
    80000a76:	6446                	ld	s0,80(sp)
    80000a78:	64a6                	ld	s1,72(sp)
    80000a7a:	79e2                	ld	s3,56(sp)
    80000a7c:	7a42                	ld	s4,48(sp)
    80000a7e:	7aa2                	ld	s5,40(sp)
    80000a80:	7b02                	ld	s6,32(sp)
    80000a82:	6125                	addi	sp,sp,96
    80000a84:	8082                	ret
      return -1;
    80000a86:	557d                	li	a0,-1
    80000a88:	6906                	ld	s2,64(sp)
    80000a8a:	6be2                	ld	s7,24(sp)
    80000a8c:	6c42                	ld	s8,16(sp)
    80000a8e:	6ca2                	ld	s9,8(sp)
    80000a90:	b7d5                	j	80000a74 <copyout+0xae>
      return -1;
    80000a92:	557d                	li	a0,-1
    80000a94:	6906                	ld	s2,64(sp)
    80000a96:	6be2                	ld	s7,24(sp)
    80000a98:	6c42                	ld	s8,16(sp)
    80000a9a:	6ca2                	ld	s9,8(sp)
    80000a9c:	bfe1                	j	80000a74 <copyout+0xae>

0000000080000a9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000a9e:	c6a5                	beqz	a3,80000b06 <copyin+0x68>
{
    80000aa0:	715d                	addi	sp,sp,-80
    80000aa2:	e486                	sd	ra,72(sp)
    80000aa4:	e0a2                	sd	s0,64(sp)
    80000aa6:	fc26                	sd	s1,56(sp)
    80000aa8:	f84a                	sd	s2,48(sp)
    80000aaa:	f44e                	sd	s3,40(sp)
    80000aac:	f052                	sd	s4,32(sp)
    80000aae:	ec56                	sd	s5,24(sp)
    80000ab0:	e85a                	sd	s6,16(sp)
    80000ab2:	e45e                	sd	s7,8(sp)
    80000ab4:	e062                	sd	s8,0(sp)
    80000ab6:	0880                	addi	s0,sp,80
    80000ab8:	8b2a                	mv	s6,a0
    80000aba:	8a2e                	mv	s4,a1
    80000abc:	8c32                	mv	s8,a2
    80000abe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ac0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ac2:	6a85                	lui	s5,0x1
    80000ac4:	a00d                	j	80000ae6 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ac6:	018505b3          	add	a1,a0,s8
    80000aca:	0004861b          	sext.w	a2,s1
    80000ace:	412585b3          	sub	a1,a1,s2
    80000ad2:	8552                	mv	a0,s4
    80000ad4:	ebcff0ef          	jal	80000190 <memmove>

    len -= n;
    80000ad8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000adc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ade:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ae2:	02098063          	beqz	s3,80000b02 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000ae6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000aea:	85ca                	mv	a1,s2
    80000aec:	855a                	mv	a0,s6
    80000aee:	955ff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000af2:	cd01                	beqz	a0,80000b0a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000af4:	418904b3          	sub	s1,s2,s8
    80000af8:	94d6                	add	s1,s1,s5
    if(n > len)
    80000afa:	fc99f6e3          	bgeu	s3,s1,80000ac6 <copyin+0x28>
    80000afe:	84ce                	mv	s1,s3
    80000b00:	b7d9                	j	80000ac6 <copyin+0x28>
  }
  return 0;
    80000b02:	4501                	li	a0,0
    80000b04:	a021                	j	80000b0c <copyin+0x6e>
    80000b06:	4501                	li	a0,0
}
    80000b08:	8082                	ret
      return -1;
    80000b0a:	557d                	li	a0,-1
}
    80000b0c:	60a6                	ld	ra,72(sp)
    80000b0e:	6406                	ld	s0,64(sp)
    80000b10:	74e2                	ld	s1,56(sp)
    80000b12:	7942                	ld	s2,48(sp)
    80000b14:	79a2                	ld	s3,40(sp)
    80000b16:	7a02                	ld	s4,32(sp)
    80000b18:	6ae2                	ld	s5,24(sp)
    80000b1a:	6b42                	ld	s6,16(sp)
    80000b1c:	6ba2                	ld	s7,8(sp)
    80000b1e:	6c02                	ld	s8,0(sp)
    80000b20:	6161                	addi	sp,sp,80
    80000b22:	8082                	ret

0000000080000b24 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b24:	c6dd                	beqz	a3,80000bd2 <copyinstr+0xae>
{
    80000b26:	715d                	addi	sp,sp,-80
    80000b28:	e486                	sd	ra,72(sp)
    80000b2a:	e0a2                	sd	s0,64(sp)
    80000b2c:	fc26                	sd	s1,56(sp)
    80000b2e:	f84a                	sd	s2,48(sp)
    80000b30:	f44e                	sd	s3,40(sp)
    80000b32:	f052                	sd	s4,32(sp)
    80000b34:	ec56                	sd	s5,24(sp)
    80000b36:	e85a                	sd	s6,16(sp)
    80000b38:	e45e                	sd	s7,8(sp)
    80000b3a:	0880                	addi	s0,sp,80
    80000b3c:	8a2a                	mv	s4,a0
    80000b3e:	8b2e                	mv	s6,a1
    80000b40:	8bb2                	mv	s7,a2
    80000b42:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b44:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b46:	6985                	lui	s3,0x1
    80000b48:	a825                	j	80000b80 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b4a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b4e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b50:	37fd                	addiw	a5,a5,-1
    80000b52:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b56:	60a6                	ld	ra,72(sp)
    80000b58:	6406                	ld	s0,64(sp)
    80000b5a:	74e2                	ld	s1,56(sp)
    80000b5c:	7942                	ld	s2,48(sp)
    80000b5e:	79a2                	ld	s3,40(sp)
    80000b60:	7a02                	ld	s4,32(sp)
    80000b62:	6ae2                	ld	s5,24(sp)
    80000b64:	6b42                	ld	s6,16(sp)
    80000b66:	6ba2                	ld	s7,8(sp)
    80000b68:	6161                	addi	sp,sp,80
    80000b6a:	8082                	ret
    80000b6c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b70:	9742                	add	a4,a4,a6
      --max;
    80000b72:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000b76:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000b7a:	04e58463          	beq	a1,a4,80000bc2 <copyinstr+0x9e>
{
    80000b7e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000b80:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b84:	85a6                	mv	a1,s1
    80000b86:	8552                	mv	a0,s4
    80000b88:	8bbff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000b8c:	cd0d                	beqz	a0,80000bc6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000b8e:	417486b3          	sub	a3,s1,s7
    80000b92:	96ce                	add	a3,a3,s3
    if(n > max)
    80000b94:	00d97363          	bgeu	s2,a3,80000b9a <copyinstr+0x76>
    80000b98:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000b9a:	955e                	add	a0,a0,s7
    80000b9c:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000b9e:	c695                	beqz	a3,80000bca <copyinstr+0xa6>
    80000ba0:	87da                	mv	a5,s6
    80000ba2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ba4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ba8:	96da                	add	a3,a3,s6
    80000baa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bac:	00f60733          	add	a4,a2,a5
    80000bb0:	00074703          	lbu	a4,0(a4)
    80000bb4:	db59                	beqz	a4,80000b4a <copyinstr+0x26>
        *dst = *p;
    80000bb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bba:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bbc:	fed797e3          	bne	a5,a3,80000baa <copyinstr+0x86>
    80000bc0:	b775                	j	80000b6c <copyinstr+0x48>
    80000bc2:	4781                	li	a5,0
    80000bc4:	b771                	j	80000b50 <copyinstr+0x2c>
      return -1;
    80000bc6:	557d                	li	a0,-1
    80000bc8:	b779                	j	80000b56 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bca:	6b85                	lui	s7,0x1
    80000bcc:	9ba6                	add	s7,s7,s1
    80000bce:	87da                	mv	a5,s6
    80000bd0:	b77d                	j	80000b7e <copyinstr+0x5a>
  int got_null = 0;
    80000bd2:	4781                	li	a5,0
  if(got_null){
    80000bd4:	37fd                	addiw	a5,a5,-1
    80000bd6:	0007851b          	sext.w	a0,a5
}
    80000bda:	8082                	ret

0000000080000bdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bdc:	7139                	addi	sp,sp,-64
    80000bde:	fc06                	sd	ra,56(sp)
    80000be0:	f822                	sd	s0,48(sp)
    80000be2:	f426                	sd	s1,40(sp)
    80000be4:	f04a                	sd	s2,32(sp)
    80000be6:	ec4e                	sd	s3,24(sp)
    80000be8:	e852                	sd	s4,16(sp)
    80000bea:	e456                	sd	s5,8(sp)
    80000bec:	e05a                	sd	s6,0(sp)
    80000bee:	0080                	addi	s0,sp,64
    80000bf0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bf2:	0000a497          	auipc	s1,0xa
    80000bf6:	c4e48493          	addi	s1,s1,-946 # 8000a840 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfa:	8b26                	mv	s6,s1
    80000bfc:	ff4df937          	lui	s2,0xff4df
    80000c00:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb09d>
    80000c04:	0936                	slli	s2,s2,0xd
    80000c06:	6f590913          	addi	s2,s2,1781
    80000c0a:	0936                	slli	s2,s2,0xd
    80000c0c:	bd390913          	addi	s2,s2,-1069
    80000c10:	0932                	slli	s2,s2,0xc
    80000c12:	7a790913          	addi	s2,s2,1959
    80000c16:	040009b7          	lui	s3,0x4000
    80000c1a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c1c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1e:	00010a97          	auipc	s5,0x10
    80000c22:	822a8a93          	addi	s5,s5,-2014 # 80010440 <tickslock>
    char *pa = kalloc();
    80000c26:	cd0ff0ef          	jal	800000f6 <kalloc>
    80000c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c2c:	cd15                	beqz	a0,80000c68 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c2e:	416485b3          	sub	a1,s1,s6
    80000c32:	8591                	srai	a1,a1,0x4
    80000c34:	032585b3          	mul	a1,a1,s2
    80000c38:	2585                	addiw	a1,a1,1
    80000c3a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3e:	4719                	li	a4,6
    80000c40:	6685                	lui	a3,0x1
    80000c42:	40b985b3          	sub	a1,s3,a1
    80000c46:	8552                	mv	a0,s4
    80000c48:	8e9ff0ef          	jal	80000530 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4c:	17048493          	addi	s1,s1,368
    80000c50:	fd549be3          	bne	s1,s5,80000c26 <proc_mapstacks+0x4a>
  }
}
    80000c54:	70e2                	ld	ra,56(sp)
    80000c56:	7442                	ld	s0,48(sp)
    80000c58:	74a2                	ld	s1,40(sp)
    80000c5a:	7902                	ld	s2,32(sp)
    80000c5c:	69e2                	ld	s3,24(sp)
    80000c5e:	6a42                	ld	s4,16(sp)
    80000c60:	6aa2                	ld	s5,8(sp)
    80000c62:	6b02                	ld	s6,0(sp)
    80000c64:	6121                	addi	sp,sp,64
    80000c66:	8082                	ret
      panic("kalloc");
    80000c68:	00006517          	auipc	a0,0x6
    80000c6c:	54050513          	addi	a0,a0,1344 # 800071a8 <etext+0x1a8>
    80000c70:	033040ef          	jal	800054a2 <panic>

0000000080000c74 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c74:	7139                	addi	sp,sp,-64
    80000c76:	fc06                	sd	ra,56(sp)
    80000c78:	f822                	sd	s0,48(sp)
    80000c7a:	f426                	sd	s1,40(sp)
    80000c7c:	f04a                	sd	s2,32(sp)
    80000c7e:	ec4e                	sd	s3,24(sp)
    80000c80:	e852                	sd	s4,16(sp)
    80000c82:	e456                	sd	s5,8(sp)
    80000c84:	e05a                	sd	s6,0(sp)
    80000c86:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c88:	00006597          	auipc	a1,0x6
    80000c8c:	52858593          	addi	a1,a1,1320 # 800071b0 <etext+0x1b0>
    80000c90:	00009517          	auipc	a0,0x9
    80000c94:	78050513          	addi	a0,a0,1920 # 8000a410 <pid_lock>
    80000c98:	2b9040ef          	jal	80005750 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	00009517          	auipc	a0,0x9
    80000ca8:	78450513          	addi	a0,a0,1924 # 8000a428 <wait_lock>
    80000cac:	2a5040ef          	jal	80005750 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb0:	0000a497          	auipc	s1,0xa
    80000cb4:	b9048493          	addi	s1,s1,-1136 # 8000a840 <proc>
      initlock(&p->lock, "proc");
    80000cb8:	00006b17          	auipc	s6,0x6
    80000cbc:	510b0b13          	addi	s6,s6,1296 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc0:	8aa6                	mv	s5,s1
    80000cc2:	ff4df937          	lui	s2,0xff4df
    80000cc6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb09d>
    80000cca:	0936                	slli	s2,s2,0xd
    80000ccc:	6f590913          	addi	s2,s2,1781
    80000cd0:	0936                	slli	s2,s2,0xd
    80000cd2:	bd390913          	addi	s2,s2,-1069
    80000cd6:	0932                	slli	s2,s2,0xc
    80000cd8:	7a790913          	addi	s2,s2,1959
    80000cdc:	040009b7          	lui	s3,0x4000
    80000ce0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce4:	0000fa17          	auipc	s4,0xf
    80000ce8:	75ca0a13          	addi	s4,s4,1884 # 80010440 <tickslock>
      initlock(&p->lock, "proc");
    80000cec:	85da                	mv	a1,s6
    80000cee:	8526                	mv	a0,s1
    80000cf0:	261040ef          	jal	80005750 <initlock>
      p->state = UNUSED;
    80000cf4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cf8:	415487b3          	sub	a5,s1,s5
    80000cfc:	8791                	srai	a5,a5,0x4
    80000cfe:	032787b3          	mul	a5,a5,s2
    80000d02:	2785                	addiw	a5,a5,1
    80000d04:	00d7979b          	slliw	a5,a5,0xd
    80000d08:	40f987b3          	sub	a5,s3,a5
    80000d0c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	17048493          	addi	s1,s1,368
    80000d12:	fd449de3          	bne	s1,s4,80000cec <procinit+0x78>
  }
}
    80000d16:	70e2                	ld	ra,56(sp)
    80000d18:	7442                	ld	s0,48(sp)
    80000d1a:	74a2                	ld	s1,40(sp)
    80000d1c:	7902                	ld	s2,32(sp)
    80000d1e:	69e2                	ld	s3,24(sp)
    80000d20:	6a42                	ld	s4,16(sp)
    80000d22:	6aa2                	ld	s5,8(sp)
    80000d24:	6b02                	ld	s6,0(sp)
    80000d26:	6121                	addi	sp,sp,64
    80000d28:	8082                	ret

0000000080000d2a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d2a:	1141                	addi	sp,sp,-16
    80000d2c:	e422                	sd	s0,8(sp)
    80000d2e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d30:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d32:	2501                	sext.w	a0,a0
    80000d34:	6422                	ld	s0,8(sp)
    80000d36:	0141                	addi	sp,sp,16
    80000d38:	8082                	ret

0000000080000d3a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
    80000d40:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d42:	2781                	sext.w	a5,a5
    80000d44:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d46:	00009517          	auipc	a0,0x9
    80000d4a:	6fa50513          	addi	a0,a0,1786 # 8000a440 <cpus>
    80000d4e:	953e                	add	a0,a0,a5
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret

0000000080000d56 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d56:	1101                	addi	sp,sp,-32
    80000d58:	ec06                	sd	ra,24(sp)
    80000d5a:	e822                	sd	s0,16(sp)
    80000d5c:	e426                	sd	s1,8(sp)
    80000d5e:	1000                	addi	s0,sp,32
  push_off();
    80000d60:	231040ef          	jal	80005790 <push_off>
    80000d64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
    80000d6a:	00009717          	auipc	a4,0x9
    80000d6e:	6a670713          	addi	a4,a4,1702 # 8000a410 <pid_lock>
    80000d72:	97ba                	add	a5,a5,a4
    80000d74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d76:	29f040ef          	jal	80005814 <pop_off>
  return p;
}
    80000d7a:	8526                	mv	a0,s1
    80000d7c:	60e2                	ld	ra,24(sp)
    80000d7e:	6442                	ld	s0,16(sp)
    80000d80:	64a2                	ld	s1,8(sp)
    80000d82:	6105                	addi	sp,sp,32
    80000d84:	8082                	ret

0000000080000d86 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d86:	1141                	addi	sp,sp,-16
    80000d88:	e406                	sd	ra,8(sp)
    80000d8a:	e022                	sd	s0,0(sp)
    80000d8c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d8e:	fc9ff0ef          	jal	80000d56 <myproc>
    80000d92:	2d7040ef          	jal	80005868 <release>

  if (first) {
    80000d96:	00009797          	auipc	a5,0x9
    80000d9a:	5ba7a783          	lw	a5,1466(a5) # 8000a350 <first.1>
    80000d9e:	e799                	bnez	a5,80000dac <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000da0:	2cb000ef          	jal	8000186a <usertrapret>
}
    80000da4:	60a2                	ld	ra,8(sp)
    80000da6:	6402                	ld	s0,0(sp)
    80000da8:	0141                	addi	sp,sp,16
    80000daa:	8082                	ret
    fsinit(ROOTDEV);
    80000dac:	4505                	li	a0,1
    80000dae:	70e010ef          	jal	800024bc <fsinit>
    first = 0;
    80000db2:	00009797          	auipc	a5,0x9
    80000db6:	5807af23          	sw	zero,1438(a5) # 8000a350 <first.1>
    __sync_synchronize();
    80000dba:	0330000f          	fence	rw,rw
    80000dbe:	b7cd                	j	80000da0 <forkret+0x1a>

0000000080000dc0 <allocpid>:
{
    80000dc0:	1101                	addi	sp,sp,-32
    80000dc2:	ec06                	sd	ra,24(sp)
    80000dc4:	e822                	sd	s0,16(sp)
    80000dc6:	e426                	sd	s1,8(sp)
    80000dc8:	e04a                	sd	s2,0(sp)
    80000dca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dcc:	00009917          	auipc	s2,0x9
    80000dd0:	64490913          	addi	s2,s2,1604 # 8000a410 <pid_lock>
    80000dd4:	854a                	mv	a0,s2
    80000dd6:	1fb040ef          	jal	800057d0 <acquire>
  pid = nextpid;
    80000dda:	00009797          	auipc	a5,0x9
    80000dde:	57a78793          	addi	a5,a5,1402 # 8000a354 <nextpid>
    80000de2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de4:	0014871b          	addiw	a4,s1,1
    80000de8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dea:	854a                	mv	a0,s2
    80000dec:	27d040ef          	jal	80005868 <release>
}
    80000df0:	8526                	mv	a0,s1
    80000df2:	60e2                	ld	ra,24(sp)
    80000df4:	6442                	ld	s0,16(sp)
    80000df6:	64a2                	ld	s1,8(sp)
    80000df8:	6902                	ld	s2,0(sp)
    80000dfa:	6105                	addi	sp,sp,32
    80000dfc:	8082                	ret

0000000080000dfe <proc_pagetable>:
{
    80000dfe:	1101                	addi	sp,sp,-32
    80000e00:	ec06                	sd	ra,24(sp)
    80000e02:	e822                	sd	s0,16(sp)
    80000e04:	e426                	sd	s1,8(sp)
    80000e06:	e04a                	sd	s2,0(sp)
    80000e08:	1000                	addi	s0,sp,32
    80000e0a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e0c:	8e7ff0ef          	jal	800006f2 <uvmcreate>
    80000e10:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e12:	cd05                	beqz	a0,80000e4a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e14:	4729                	li	a4,10
    80000e16:	00005697          	auipc	a3,0x5
    80000e1a:	1ea68693          	addi	a3,a3,490 # 80006000 <_trampoline>
    80000e1e:	6605                	lui	a2,0x1
    80000e20:	040005b7          	lui	a1,0x4000
    80000e24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e26:	05b2                	slli	a1,a1,0xc
    80000e28:	e58ff0ef          	jal	80000480 <mappages>
    80000e2c:	02054663          	bltz	a0,80000e58 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e30:	4719                	li	a4,6
    80000e32:	05893683          	ld	a3,88(s2)
    80000e36:	6605                	lui	a2,0x1
    80000e38:	020005b7          	lui	a1,0x2000
    80000e3c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e3e:	05b6                	slli	a1,a1,0xd
    80000e40:	8526                	mv	a0,s1
    80000e42:	e3eff0ef          	jal	80000480 <mappages>
    80000e46:	00054f63          	bltz	a0,80000e64 <proc_pagetable+0x66>
}
    80000e4a:	8526                	mv	a0,s1
    80000e4c:	60e2                	ld	ra,24(sp)
    80000e4e:	6442                	ld	s0,16(sp)
    80000e50:	64a2                	ld	s1,8(sp)
    80000e52:	6902                	ld	s2,0(sp)
    80000e54:	6105                	addi	sp,sp,32
    80000e56:	8082                	ret
    uvmfree(pagetable, 0);
    80000e58:	4581                	li	a1,0
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	a5dff0ef          	jal	800008b8 <uvmfree>
    return 0;
    80000e60:	4481                	li	s1,0
    80000e62:	b7e5                	j	80000e4a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e64:	4681                	li	a3,0
    80000e66:	4605                	li	a2,1
    80000e68:	040005b7          	lui	a1,0x4000
    80000e6c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e6e:	05b2                	slli	a1,a1,0xc
    80000e70:	8526                	mv	a0,s1
    80000e72:	fb4ff0ef          	jal	80000626 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e76:	4581                	li	a1,0
    80000e78:	8526                	mv	a0,s1
    80000e7a:	a3fff0ef          	jal	800008b8 <uvmfree>
    return 0;
    80000e7e:	4481                	li	s1,0
    80000e80:	b7e9                	j	80000e4a <proc_pagetable+0x4c>

0000000080000e82 <proc_freepagetable>:
{
    80000e82:	1101                	addi	sp,sp,-32
    80000e84:	ec06                	sd	ra,24(sp)
    80000e86:	e822                	sd	s0,16(sp)
    80000e88:	e426                	sd	s1,8(sp)
    80000e8a:	e04a                	sd	s2,0(sp)
    80000e8c:	1000                	addi	s0,sp,32
    80000e8e:	84aa                	mv	s1,a0
    80000e90:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e92:	4681                	li	a3,0
    80000e94:	4605                	li	a2,1
    80000e96:	040005b7          	lui	a1,0x4000
    80000e9a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e9c:	05b2                	slli	a1,a1,0xc
    80000e9e:	f88ff0ef          	jal	80000626 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ea2:	4681                	li	a3,0
    80000ea4:	4605                	li	a2,1
    80000ea6:	020005b7          	lui	a1,0x2000
    80000eaa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eac:	05b6                	slli	a1,a1,0xd
    80000eae:	8526                	mv	a0,s1
    80000eb0:	f76ff0ef          	jal	80000626 <uvmunmap>
  uvmfree(pagetable, sz);
    80000eb4:	85ca                	mv	a1,s2
    80000eb6:	8526                	mv	a0,s1
    80000eb8:	a01ff0ef          	jal	800008b8 <uvmfree>
}
    80000ebc:	60e2                	ld	ra,24(sp)
    80000ebe:	6442                	ld	s0,16(sp)
    80000ec0:	64a2                	ld	s1,8(sp)
    80000ec2:	6902                	ld	s2,0(sp)
    80000ec4:	6105                	addi	sp,sp,32
    80000ec6:	8082                	ret

0000000080000ec8 <freeproc>:
{
    80000ec8:	1101                	addi	sp,sp,-32
    80000eca:	ec06                	sd	ra,24(sp)
    80000ecc:	e822                	sd	s0,16(sp)
    80000ece:	e426                	sd	s1,8(sp)
    80000ed0:	1000                	addi	s0,sp,32
    80000ed2:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ed4:	6d28                	ld	a0,88(a0)
    80000ed6:	c119                	beqz	a0,80000edc <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ed8:	944ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000edc:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ee0:	68a8                	ld	a0,80(s1)
    80000ee2:	c501                	beqz	a0,80000eea <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ee4:	64ac                	ld	a1,72(s1)
    80000ee6:	f9dff0ef          	jal	80000e82 <proc_freepagetable>
  p->pagetable = 0;
    80000eea:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000eee:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ef2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000ef6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000efa:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000efe:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f02:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f06:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f0a:	0004ac23          	sw	zero,24(s1)
}
    80000f0e:	60e2                	ld	ra,24(sp)
    80000f10:	6442                	ld	s0,16(sp)
    80000f12:	64a2                	ld	s1,8(sp)
    80000f14:	6105                	addi	sp,sp,32
    80000f16:	8082                	ret

0000000080000f18 <allocproc>:
{
    80000f18:	1101                	addi	sp,sp,-32
    80000f1a:	ec06                	sd	ra,24(sp)
    80000f1c:	e822                	sd	s0,16(sp)
    80000f1e:	e426                	sd	s1,8(sp)
    80000f20:	e04a                	sd	s2,0(sp)
    80000f22:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f24:	0000a497          	auipc	s1,0xa
    80000f28:	91c48493          	addi	s1,s1,-1764 # 8000a840 <proc>
    80000f2c:	0000f917          	auipc	s2,0xf
    80000f30:	51490913          	addi	s2,s2,1300 # 80010440 <tickslock>
    acquire(&p->lock);
    80000f34:	8526                	mv	a0,s1
    80000f36:	09b040ef          	jal	800057d0 <acquire>
    if(p->state == UNUSED) {
    80000f3a:	4c9c                	lw	a5,24(s1)
    80000f3c:	cb91                	beqz	a5,80000f50 <allocproc+0x38>
      release(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	129040ef          	jal	80005868 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f44:	17048493          	addi	s1,s1,368
    80000f48:	ff2496e3          	bne	s1,s2,80000f34 <allocproc+0x1c>
  return 0;
    80000f4c:	4481                	li	s1,0
    80000f4e:	a099                	j	80000f94 <allocproc+0x7c>
  p->pid = allocpid();
    80000f50:	e71ff0ef          	jal	80000dc0 <allocpid>
    80000f54:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f56:	4785                	li	a5,1
    80000f58:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f5a:	99cff0ef          	jal	800000f6 <kalloc>
    80000f5e:	892a                	mv	s2,a0
    80000f60:	eca8                	sd	a0,88(s1)
    80000f62:	c121                	beqz	a0,80000fa2 <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80000f64:	8526                	mv	a0,s1
    80000f66:	e99ff0ef          	jal	80000dfe <proc_pagetable>
    80000f6a:	892a                	mv	s2,a0
    80000f6c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f6e:	c131                	beqz	a0,80000fb2 <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80000f70:	07000613          	li	a2,112
    80000f74:	4581                	li	a1,0
    80000f76:	06048513          	addi	a0,s1,96
    80000f7a:	9baff0ef          	jal	80000134 <memset>
  p->context.ra = (uint64)forkret;
    80000f7e:	00000797          	auipc	a5,0x0
    80000f82:	e0878793          	addi	a5,a5,-504 # 80000d86 <forkret>
    80000f86:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f88:	60bc                	ld	a5,64(s1)
    80000f8a:	6705                	lui	a4,0x1
    80000f8c:	97ba                	add	a5,a5,a4
    80000f8e:	f4bc                	sd	a5,104(s1)
  p->trace_mask = 0;
    80000f90:	1604a423          	sw	zero,360(s1)
}
    80000f94:	8526                	mv	a0,s1
    80000f96:	60e2                	ld	ra,24(sp)
    80000f98:	6442                	ld	s0,16(sp)
    80000f9a:	64a2                	ld	s1,8(sp)
    80000f9c:	6902                	ld	s2,0(sp)
    80000f9e:	6105                	addi	sp,sp,32
    80000fa0:	8082                	ret
    freeproc(p);
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	f25ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fa8:	8526                	mv	a0,s1
    80000faa:	0bf040ef          	jal	80005868 <release>
    return 0;
    80000fae:	84ca                	mv	s1,s2
    80000fb0:	b7d5                	j	80000f94 <allocproc+0x7c>
    freeproc(p);
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	f15ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	0af040ef          	jal	80005868 <release>
    return 0;
    80000fbe:	84ca                	mv	s1,s2
    80000fc0:	bfd1                	j	80000f94 <allocproc+0x7c>

0000000080000fc2 <userinit>:
{
    80000fc2:	1101                	addi	sp,sp,-32
    80000fc4:	ec06                	sd	ra,24(sp)
    80000fc6:	e822                	sd	s0,16(sp)
    80000fc8:	e426                	sd	s1,8(sp)
    80000fca:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fcc:	f4dff0ef          	jal	80000f18 <allocproc>
    80000fd0:	84aa                	mv	s1,a0
  initproc = p;
    80000fd2:	00009797          	auipc	a5,0x9
    80000fd6:	3ea7bf23          	sd	a0,1022(a5) # 8000a3d0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fda:	03400613          	li	a2,52
    80000fde:	00009597          	auipc	a1,0x9
    80000fe2:	38258593          	addi	a1,a1,898 # 8000a360 <initcode>
    80000fe6:	6928                	ld	a0,80(a0)
    80000fe8:	f30ff0ef          	jal	80000718 <uvmfirst>
  p->sz = PGSIZE;
    80000fec:	6785                	lui	a5,0x1
    80000fee:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ff0:	6cb8                	ld	a4,88(s1)
    80000ff2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000ff6:	6cb8                	ld	a4,88(s1)
    80000ff8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000ffa:	4641                	li	a2,16
    80000ffc:	00006597          	auipc	a1,0x6
    80001000:	1d458593          	addi	a1,a1,468 # 800071d0 <etext+0x1d0>
    80001004:	15848513          	addi	a0,s1,344
    80001008:	a6aff0ef          	jal	80000272 <safestrcpy>
  p->cwd = namei("/");
    8000100c:	00006517          	auipc	a0,0x6
    80001010:	1d450513          	addi	a0,a0,468 # 800071e0 <etext+0x1e0>
    80001014:	5b7010ef          	jal	80002dca <namei>
    80001018:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101c:	478d                	li	a5,3
    8000101e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001020:	8526                	mv	a0,s1
    80001022:	047040ef          	jal	80005868 <release>
}
    80001026:	60e2                	ld	ra,24(sp)
    80001028:	6442                	ld	s0,16(sp)
    8000102a:	64a2                	ld	s1,8(sp)
    8000102c:	6105                	addi	sp,sp,32
    8000102e:	8082                	ret

0000000080001030 <growproc>:
{
    80001030:	1101                	addi	sp,sp,-32
    80001032:	ec06                	sd	ra,24(sp)
    80001034:	e822                	sd	s0,16(sp)
    80001036:	e426                	sd	s1,8(sp)
    80001038:	e04a                	sd	s2,0(sp)
    8000103a:	1000                	addi	s0,sp,32
    8000103c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000103e:	d19ff0ef          	jal	80000d56 <myproc>
    80001042:	84aa                	mv	s1,a0
  sz = p->sz;
    80001044:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001046:	01204c63          	bgtz	s2,8000105e <growproc+0x2e>
  } else if(n < 0){
    8000104a:	02094463          	bltz	s2,80001072 <growproc+0x42>
  p->sz = sz;
    8000104e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001050:	4501                	li	a0,0
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6902                	ld	s2,0(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000105e:	4691                	li	a3,4
    80001060:	00b90633          	add	a2,s2,a1
    80001064:	6928                	ld	a0,80(a0)
    80001066:	f54ff0ef          	jal	800007ba <uvmalloc>
    8000106a:	85aa                	mv	a1,a0
    8000106c:	f16d                	bnez	a0,8000104e <growproc+0x1e>
      return -1;
    8000106e:	557d                	li	a0,-1
    80001070:	b7cd                	j	80001052 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001072:	00b90633          	add	a2,s2,a1
    80001076:	6928                	ld	a0,80(a0)
    80001078:	efeff0ef          	jal	80000776 <uvmdealloc>
    8000107c:	85aa                	mv	a1,a0
    8000107e:	bfc1                	j	8000104e <growproc+0x1e>

0000000080001080 <fork>:
{
    80001080:	7139                	addi	sp,sp,-64
    80001082:	fc06                	sd	ra,56(sp)
    80001084:	f822                	sd	s0,48(sp)
    80001086:	f04a                	sd	s2,32(sp)
    80001088:	e456                	sd	s5,8(sp)
    8000108a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000108c:	ccbff0ef          	jal	80000d56 <myproc>
    80001090:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001092:	e87ff0ef          	jal	80000f18 <allocproc>
    80001096:	0e050e63          	beqz	a0,80001192 <fork+0x112>
    8000109a:	ec4e                	sd	s3,24(sp)
    8000109c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000109e:	048ab603          	ld	a2,72(s5)
    800010a2:	692c                	ld	a1,80(a0)
    800010a4:	050ab503          	ld	a0,80(s5)
    800010a8:	843ff0ef          	jal	800008ea <uvmcopy>
    800010ac:	04054a63          	bltz	a0,80001100 <fork+0x80>
    800010b0:	f426                	sd	s1,40(sp)
    800010b2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800010b4:	048ab783          	ld	a5,72(s5)
    800010b8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800010bc:	058ab683          	ld	a3,88(s5)
    800010c0:	87b6                	mv	a5,a3
    800010c2:	0589b703          	ld	a4,88(s3)
    800010c6:	12068693          	addi	a3,a3,288
    800010ca:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010ce:	6788                	ld	a0,8(a5)
    800010d0:	6b8c                	ld	a1,16(a5)
    800010d2:	6f90                	ld	a2,24(a5)
    800010d4:	01073023          	sd	a6,0(a4)
    800010d8:	e708                	sd	a0,8(a4)
    800010da:	eb0c                	sd	a1,16(a4)
    800010dc:	ef10                	sd	a2,24(a4)
    800010de:	02078793          	addi	a5,a5,32
    800010e2:	02070713          	addi	a4,a4,32
    800010e6:	fed792e3          	bne	a5,a3,800010ca <fork+0x4a>
  np->trapframe->a0 = 0;
    800010ea:	0589b783          	ld	a5,88(s3)
    800010ee:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010f2:	0d0a8493          	addi	s1,s5,208
    800010f6:	0d098913          	addi	s2,s3,208
    800010fa:	150a8a13          	addi	s4,s5,336
    800010fe:	a831                	j	8000111a <fork+0x9a>
    freeproc(np);
    80001100:	854e                	mv	a0,s3
    80001102:	dc7ff0ef          	jal	80000ec8 <freeproc>
    release(&np->lock);
    80001106:	854e                	mv	a0,s3
    80001108:	760040ef          	jal	80005868 <release>
    return -1;
    8000110c:	597d                	li	s2,-1
    8000110e:	69e2                	ld	s3,24(sp)
    80001110:	a895                	j	80001184 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001112:	04a1                	addi	s1,s1,8
    80001114:	0921                	addi	s2,s2,8
    80001116:	01448963          	beq	s1,s4,80001128 <fork+0xa8>
    if(p->ofile[i])
    8000111a:	6088                	ld	a0,0(s1)
    8000111c:	d97d                	beqz	a0,80001112 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000111e:	23c020ef          	jal	8000335a <filedup>
    80001122:	00a93023          	sd	a0,0(s2)
    80001126:	b7f5                	j	80001112 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001128:	150ab503          	ld	a0,336(s5)
    8000112c:	58e010ef          	jal	800026ba <idup>
    80001130:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001134:	4641                	li	a2,16
    80001136:	158a8593          	addi	a1,s5,344
    8000113a:	15898513          	addi	a0,s3,344
    8000113e:	934ff0ef          	jal	80000272 <safestrcpy>
  np->trace_mask = p->trace_mask;
    80001142:	168aa783          	lw	a5,360(s5)
    80001146:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    8000114a:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000114e:	854e                	mv	a0,s3
    80001150:	718040ef          	jal	80005868 <release>
  acquire(&wait_lock);
    80001154:	00009497          	auipc	s1,0x9
    80001158:	2d448493          	addi	s1,s1,724 # 8000a428 <wait_lock>
    8000115c:	8526                	mv	a0,s1
    8000115e:	672040ef          	jal	800057d0 <acquire>
  np->parent = p;
    80001162:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001166:	8526                	mv	a0,s1
    80001168:	700040ef          	jal	80005868 <release>
  acquire(&np->lock);
    8000116c:	854e                	mv	a0,s3
    8000116e:	662040ef          	jal	800057d0 <acquire>
  np->state = RUNNABLE;
    80001172:	478d                	li	a5,3
    80001174:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001178:	854e                	mv	a0,s3
    8000117a:	6ee040ef          	jal	80005868 <release>
  return pid;
    8000117e:	74a2                	ld	s1,40(sp)
    80001180:	69e2                	ld	s3,24(sp)
    80001182:	6a42                	ld	s4,16(sp)
}
    80001184:	854a                	mv	a0,s2
    80001186:	70e2                	ld	ra,56(sp)
    80001188:	7442                	ld	s0,48(sp)
    8000118a:	7902                	ld	s2,32(sp)
    8000118c:	6aa2                	ld	s5,8(sp)
    8000118e:	6121                	addi	sp,sp,64
    80001190:	8082                	ret
    return -1;
    80001192:	597d                	li	s2,-1
    80001194:	bfc5                	j	80001184 <fork+0x104>

0000000080001196 <scheduler>:
{
    80001196:	715d                	addi	sp,sp,-80
    80001198:	e486                	sd	ra,72(sp)
    8000119a:	e0a2                	sd	s0,64(sp)
    8000119c:	fc26                	sd	s1,56(sp)
    8000119e:	f84a                	sd	s2,48(sp)
    800011a0:	f44e                	sd	s3,40(sp)
    800011a2:	f052                	sd	s4,32(sp)
    800011a4:	ec56                	sd	s5,24(sp)
    800011a6:	e85a                	sd	s6,16(sp)
    800011a8:	e45e                	sd	s7,8(sp)
    800011aa:	e062                	sd	s8,0(sp)
    800011ac:	0880                	addi	s0,sp,80
    800011ae:	8792                	mv	a5,tp
  int id = r_tp();
    800011b0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011b2:	00779b13          	slli	s6,a5,0x7
    800011b6:	00009717          	auipc	a4,0x9
    800011ba:	25a70713          	addi	a4,a4,602 # 8000a410 <pid_lock>
    800011be:	975a                	add	a4,a4,s6
    800011c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c4:	00009717          	auipc	a4,0x9
    800011c8:	28470713          	addi	a4,a4,644 # 8000a448 <cpus+0x8>
    800011cc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011ce:	4c11                	li	s8,4
        c->proc = p;
    800011d0:	079e                	slli	a5,a5,0x7
    800011d2:	00009a17          	auipc	s4,0x9
    800011d6:	23ea0a13          	addi	s4,s4,574 # 8000a410 <pid_lock>
    800011da:	9a3e                	add	s4,s4,a5
        found = 1;
    800011dc:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	0000f997          	auipc	s3,0xf
    800011e2:	26298993          	addi	s3,s3,610 # 80010440 <tickslock>
    800011e6:	a0a9                	j	80001230 <scheduler+0x9a>
      release(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	67e040ef          	jal	80005868 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ee:	17048493          	addi	s1,s1,368
    800011f2:	03348563          	beq	s1,s3,8000121c <scheduler+0x86>
      acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	5d8040ef          	jal	800057d0 <acquire>
      if(p->state == RUNNABLE) {
    800011fc:	4c9c                	lw	a5,24(s1)
    800011fe:	ff2795e3          	bne	a5,s2,800011e8 <scheduler+0x52>
        p->state = RUNNING;
    80001202:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001206:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000120a:	06048593          	addi	a1,s1,96
    8000120e:	855a                	mv	a0,s6
    80001210:	5b4000ef          	jal	800017c4 <swtch>
        c->proc = 0;
    80001214:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001218:	8ade                	mv	s5,s7
    8000121a:	b7f9                	j	800011e8 <scheduler+0x52>
    if(found == 0) {
    8000121c:	000a9a63          	bnez	s5,80001230 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001220:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001224:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001228:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000122c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001230:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001234:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001238:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000123c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123e:	00009497          	auipc	s1,0x9
    80001242:	60248493          	addi	s1,s1,1538 # 8000a840 <proc>
      if(p->state == RUNNABLE) {
    80001246:	490d                	li	s2,3
    80001248:	b77d                	j	800011f6 <scheduler+0x60>

000000008000124a <sched>:
{
    8000124a:	7179                	addi	sp,sp,-48
    8000124c:	f406                	sd	ra,40(sp)
    8000124e:	f022                	sd	s0,32(sp)
    80001250:	ec26                	sd	s1,24(sp)
    80001252:	e84a                	sd	s2,16(sp)
    80001254:	e44e                	sd	s3,8(sp)
    80001256:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001258:	affff0ef          	jal	80000d56 <myproc>
    8000125c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000125e:	508040ef          	jal	80005766 <holding>
    80001262:	c92d                	beqz	a0,800012d4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001264:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001266:	2781                	sext.w	a5,a5
    80001268:	079e                	slli	a5,a5,0x7
    8000126a:	00009717          	auipc	a4,0x9
    8000126e:	1a670713          	addi	a4,a4,422 # 8000a410 <pid_lock>
    80001272:	97ba                	add	a5,a5,a4
    80001274:	0a87a703          	lw	a4,168(a5)
    80001278:	4785                	li	a5,1
    8000127a:	06f71363          	bne	a4,a5,800012e0 <sched+0x96>
  if(p->state == RUNNING)
    8000127e:	4c98                	lw	a4,24(s1)
    80001280:	4791                	li	a5,4
    80001282:	06f70563          	beq	a4,a5,800012ec <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001286:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000128a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000128c:	e7b5                	bnez	a5,800012f8 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000128e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001290:	00009917          	auipc	s2,0x9
    80001294:	18090913          	addi	s2,s2,384 # 8000a410 <pid_lock>
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	97ca                	add	a5,a5,s2
    8000129e:	0ac7a983          	lw	s3,172(a5)
    800012a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a4:	2781                	sext.w	a5,a5
    800012a6:	079e                	slli	a5,a5,0x7
    800012a8:	00009597          	auipc	a1,0x9
    800012ac:	1a058593          	addi	a1,a1,416 # 8000a448 <cpus+0x8>
    800012b0:	95be                	add	a1,a1,a5
    800012b2:	06048513          	addi	a0,s1,96
    800012b6:	50e000ef          	jal	800017c4 <swtch>
    800012ba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012bc:	2781                	sext.w	a5,a5
    800012be:	079e                	slli	a5,a5,0x7
    800012c0:	993e                	add	s2,s2,a5
    800012c2:	0b392623          	sw	s3,172(s2)
}
    800012c6:	70a2                	ld	ra,40(sp)
    800012c8:	7402                	ld	s0,32(sp)
    800012ca:	64e2                	ld	s1,24(sp)
    800012cc:	6942                	ld	s2,16(sp)
    800012ce:	69a2                	ld	s3,8(sp)
    800012d0:	6145                	addi	sp,sp,48
    800012d2:	8082                	ret
    panic("sched p->lock");
    800012d4:	00006517          	auipc	a0,0x6
    800012d8:	f1450513          	addi	a0,a0,-236 # 800071e8 <etext+0x1e8>
    800012dc:	1c6040ef          	jal	800054a2 <panic>
    panic("sched locks");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f1850513          	addi	a0,a0,-232 # 800071f8 <etext+0x1f8>
    800012e8:	1ba040ef          	jal	800054a2 <panic>
    panic("sched running");
    800012ec:	00006517          	auipc	a0,0x6
    800012f0:	f1c50513          	addi	a0,a0,-228 # 80007208 <etext+0x208>
    800012f4:	1ae040ef          	jal	800054a2 <panic>
    panic("sched interruptible");
    800012f8:	00006517          	auipc	a0,0x6
    800012fc:	f2050513          	addi	a0,a0,-224 # 80007218 <etext+0x218>
    80001300:	1a2040ef          	jal	800054a2 <panic>

0000000080001304 <yield>:
{
    80001304:	1101                	addi	sp,sp,-32
    80001306:	ec06                	sd	ra,24(sp)
    80001308:	e822                	sd	s0,16(sp)
    8000130a:	e426                	sd	s1,8(sp)
    8000130c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000130e:	a49ff0ef          	jal	80000d56 <myproc>
    80001312:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001314:	4bc040ef          	jal	800057d0 <acquire>
  p->state = RUNNABLE;
    80001318:	478d                	li	a5,3
    8000131a:	cc9c                	sw	a5,24(s1)
  sched();
    8000131c:	f2fff0ef          	jal	8000124a <sched>
  release(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	546040ef          	jal	80005868 <release>
}
    80001326:	60e2                	ld	ra,24(sp)
    80001328:	6442                	ld	s0,16(sp)
    8000132a:	64a2                	ld	s1,8(sp)
    8000132c:	6105                	addi	sp,sp,32
    8000132e:	8082                	ret

0000000080001330 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001330:	7179                	addi	sp,sp,-48
    80001332:	f406                	sd	ra,40(sp)
    80001334:	f022                	sd	s0,32(sp)
    80001336:	ec26                	sd	s1,24(sp)
    80001338:	e84a                	sd	s2,16(sp)
    8000133a:	e44e                	sd	s3,8(sp)
    8000133c:	1800                	addi	s0,sp,48
    8000133e:	89aa                	mv	s3,a0
    80001340:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001342:	a15ff0ef          	jal	80000d56 <myproc>
    80001346:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001348:	488040ef          	jal	800057d0 <acquire>
  release(lk);
    8000134c:	854a                	mv	a0,s2
    8000134e:	51a040ef          	jal	80005868 <release>

  // Go to sleep.
  p->chan = chan;
    80001352:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001356:	4789                	li	a5,2
    80001358:	cc9c                	sw	a5,24(s1)

  sched();
    8000135a:	ef1ff0ef          	jal	8000124a <sched>

  // Tidy up.
  p->chan = 0;
    8000135e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	504040ef          	jal	80005868 <release>
  acquire(lk);
    80001368:	854a                	mv	a0,s2
    8000136a:	466040ef          	jal	800057d0 <acquire>
}
    8000136e:	70a2                	ld	ra,40(sp)
    80001370:	7402                	ld	s0,32(sp)
    80001372:	64e2                	ld	s1,24(sp)
    80001374:	6942                	ld	s2,16(sp)
    80001376:	69a2                	ld	s3,8(sp)
    80001378:	6145                	addi	sp,sp,48
    8000137a:	8082                	ret

000000008000137c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000137c:	7139                	addi	sp,sp,-64
    8000137e:	fc06                	sd	ra,56(sp)
    80001380:	f822                	sd	s0,48(sp)
    80001382:	f426                	sd	s1,40(sp)
    80001384:	f04a                	sd	s2,32(sp)
    80001386:	ec4e                	sd	s3,24(sp)
    80001388:	e852                	sd	s4,16(sp)
    8000138a:	e456                	sd	s5,8(sp)
    8000138c:	0080                	addi	s0,sp,64
    8000138e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001390:	00009497          	auipc	s1,0x9
    80001394:	4b048493          	addi	s1,s1,1200 # 8000a840 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001398:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000139a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139c:	0000f917          	auipc	s2,0xf
    800013a0:	0a490913          	addi	s2,s2,164 # 80010440 <tickslock>
    800013a4:	a801                	j	800013b4 <wakeup+0x38>
      }
      release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	4c0040ef          	jal	80005868 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	17048493          	addi	s1,s1,368
    800013b0:	03248263          	beq	s1,s2,800013d4 <wakeup+0x58>
    if(p != myproc()){
    800013b4:	9a3ff0ef          	jal	80000d56 <myproc>
    800013b8:	fea48ae3          	beq	s1,a0,800013ac <wakeup+0x30>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	412040ef          	jal	800057d0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013c2:	4c9c                	lw	a5,24(s1)
    800013c4:	ff3791e3          	bne	a5,s3,800013a6 <wakeup+0x2a>
    800013c8:	709c                	ld	a5,32(s1)
    800013ca:	fd479ee3          	bne	a5,s4,800013a6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800013ce:	0154ac23          	sw	s5,24(s1)
    800013d2:	bfd1                	j	800013a6 <wakeup+0x2a>
    }
  }
}
    800013d4:	70e2                	ld	ra,56(sp)
    800013d6:	7442                	ld	s0,48(sp)
    800013d8:	74a2                	ld	s1,40(sp)
    800013da:	7902                	ld	s2,32(sp)
    800013dc:	69e2                	ld	s3,24(sp)
    800013de:	6a42                	ld	s4,16(sp)
    800013e0:	6aa2                	ld	s5,8(sp)
    800013e2:	6121                	addi	sp,sp,64
    800013e4:	8082                	ret

00000000800013e6 <reparent>:
{
    800013e6:	7179                	addi	sp,sp,-48
    800013e8:	f406                	sd	ra,40(sp)
    800013ea:	f022                	sd	s0,32(sp)
    800013ec:	ec26                	sd	s1,24(sp)
    800013ee:	e84a                	sd	s2,16(sp)
    800013f0:	e44e                	sd	s3,8(sp)
    800013f2:	e052                	sd	s4,0(sp)
    800013f4:	1800                	addi	s0,sp,48
    800013f6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013f8:	00009497          	auipc	s1,0x9
    800013fc:	44848493          	addi	s1,s1,1096 # 8000a840 <proc>
      pp->parent = initproc;
    80001400:	00009a17          	auipc	s4,0x9
    80001404:	fd0a0a13          	addi	s4,s4,-48 # 8000a3d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001408:	0000f997          	auipc	s3,0xf
    8000140c:	03898993          	addi	s3,s3,56 # 80010440 <tickslock>
    80001410:	a029                	j	8000141a <reparent+0x34>
    80001412:	17048493          	addi	s1,s1,368
    80001416:	01348b63          	beq	s1,s3,8000142c <reparent+0x46>
    if(pp->parent == p){
    8000141a:	7c9c                	ld	a5,56(s1)
    8000141c:	ff279be3          	bne	a5,s2,80001412 <reparent+0x2c>
      pp->parent = initproc;
    80001420:	000a3503          	ld	a0,0(s4)
    80001424:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001426:	f57ff0ef          	jal	8000137c <wakeup>
    8000142a:	b7e5                	j	80001412 <reparent+0x2c>
}
    8000142c:	70a2                	ld	ra,40(sp)
    8000142e:	7402                	ld	s0,32(sp)
    80001430:	64e2                	ld	s1,24(sp)
    80001432:	6942                	ld	s2,16(sp)
    80001434:	69a2                	ld	s3,8(sp)
    80001436:	6a02                	ld	s4,0(sp)
    80001438:	6145                	addi	sp,sp,48
    8000143a:	8082                	ret

000000008000143c <exit>:
{
    8000143c:	7179                	addi	sp,sp,-48
    8000143e:	f406                	sd	ra,40(sp)
    80001440:	f022                	sd	s0,32(sp)
    80001442:	ec26                	sd	s1,24(sp)
    80001444:	e84a                	sd	s2,16(sp)
    80001446:	e44e                	sd	s3,8(sp)
    80001448:	e052                	sd	s4,0(sp)
    8000144a:	1800                	addi	s0,sp,48
    8000144c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000144e:	909ff0ef          	jal	80000d56 <myproc>
    80001452:	89aa                	mv	s3,a0
  if(p == initproc)
    80001454:	00009797          	auipc	a5,0x9
    80001458:	f7c7b783          	ld	a5,-132(a5) # 8000a3d0 <initproc>
    8000145c:	0d050493          	addi	s1,a0,208
    80001460:	15050913          	addi	s2,a0,336
    80001464:	00a79f63          	bne	a5,a0,80001482 <exit+0x46>
    panic("init exiting");
    80001468:	00006517          	auipc	a0,0x6
    8000146c:	dc850513          	addi	a0,a0,-568 # 80007230 <etext+0x230>
    80001470:	032040ef          	jal	800054a2 <panic>
      fileclose(f);
    80001474:	72d010ef          	jal	800033a0 <fileclose>
      p->ofile[fd] = 0;
    80001478:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000147c:	04a1                	addi	s1,s1,8
    8000147e:	01248563          	beq	s1,s2,80001488 <exit+0x4c>
    if(p->ofile[fd]){
    80001482:	6088                	ld	a0,0(s1)
    80001484:	f965                	bnez	a0,80001474 <exit+0x38>
    80001486:	bfdd                	j	8000147c <exit+0x40>
  begin_op();
    80001488:	2ff010ef          	jal	80002f86 <begin_op>
  iput(p->cwd);
    8000148c:	1509b503          	ld	a0,336(s3)
    80001490:	3e2010ef          	jal	80002872 <iput>
  end_op();
    80001494:	35d010ef          	jal	80002ff0 <end_op>
  p->cwd = 0;
    80001498:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149c:	00009497          	auipc	s1,0x9
    800014a0:	f8c48493          	addi	s1,s1,-116 # 8000a428 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	32a040ef          	jal	800057d0 <acquire>
  reparent(p);
    800014aa:	854e                	mv	a0,s3
    800014ac:	f3bff0ef          	jal	800013e6 <reparent>
  wakeup(p->parent);
    800014b0:	0389b503          	ld	a0,56(s3)
    800014b4:	ec9ff0ef          	jal	8000137c <wakeup>
  acquire(&p->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	316040ef          	jal	800057d0 <acquire>
  p->xstate = status;
    800014be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c2:	4795                	li	a5,5
    800014c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	39e040ef          	jal	80005868 <release>
  sched();
    800014ce:	d7dff0ef          	jal	8000124a <sched>
  panic("zombie exit");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	d6e50513          	addi	a0,a0,-658 # 80007240 <etext+0x240>
    800014da:	7c9030ef          	jal	800054a2 <panic>

00000000800014de <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014de:	7179                	addi	sp,sp,-48
    800014e0:	f406                	sd	ra,40(sp)
    800014e2:	f022                	sd	s0,32(sp)
    800014e4:	ec26                	sd	s1,24(sp)
    800014e6:	e84a                	sd	s2,16(sp)
    800014e8:	e44e                	sd	s3,8(sp)
    800014ea:	1800                	addi	s0,sp,48
    800014ec:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014ee:	00009497          	auipc	s1,0x9
    800014f2:	35248493          	addi	s1,s1,850 # 8000a840 <proc>
    800014f6:	0000f997          	auipc	s3,0xf
    800014fa:	f4a98993          	addi	s3,s3,-182 # 80010440 <tickslock>
    acquire(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	2d0040ef          	jal	800057d0 <acquire>
    if(p->pid == pid){
    80001504:	589c                	lw	a5,48(s1)
    80001506:	01278b63          	beq	a5,s2,8000151c <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	35c040ef          	jal	80005868 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001510:	17048493          	addi	s1,s1,368
    80001514:	ff3495e3          	bne	s1,s3,800014fe <kill+0x20>
  }
  return -1;
    80001518:	557d                	li	a0,-1
    8000151a:	a819                	j	80001530 <kill+0x52>
      p->killed = 1;
    8000151c:	4785                	li	a5,1
    8000151e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001520:	4c98                	lw	a4,24(s1)
    80001522:	4789                	li	a5,2
    80001524:	00f70d63          	beq	a4,a5,8000153e <kill+0x60>
      release(&p->lock);
    80001528:	8526                	mv	a0,s1
    8000152a:	33e040ef          	jal	80005868 <release>
      return 0;
    8000152e:	4501                	li	a0,0
}
    80001530:	70a2                	ld	ra,40(sp)
    80001532:	7402                	ld	s0,32(sp)
    80001534:	64e2                	ld	s1,24(sp)
    80001536:	6942                	ld	s2,16(sp)
    80001538:	69a2                	ld	s3,8(sp)
    8000153a:	6145                	addi	sp,sp,48
    8000153c:	8082                	ret
        p->state = RUNNABLE;
    8000153e:	478d                	li	a5,3
    80001540:	cc9c                	sw	a5,24(s1)
    80001542:	b7dd                	j	80001528 <kill+0x4a>

0000000080001544 <setkilled>:

void
setkilled(struct proc *p)
{
    80001544:	1101                	addi	sp,sp,-32
    80001546:	ec06                	sd	ra,24(sp)
    80001548:	e822                	sd	s0,16(sp)
    8000154a:	e426                	sd	s1,8(sp)
    8000154c:	1000                	addi	s0,sp,32
    8000154e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001550:	280040ef          	jal	800057d0 <acquire>
  p->killed = 1;
    80001554:	4785                	li	a5,1
    80001556:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	30e040ef          	jal	80005868 <release>
}
    8000155e:	60e2                	ld	ra,24(sp)
    80001560:	6442                	ld	s0,16(sp)
    80001562:	64a2                	ld	s1,8(sp)
    80001564:	6105                	addi	sp,sp,32
    80001566:	8082                	ret

0000000080001568 <killed>:

int
killed(struct proc *p)
{
    80001568:	1101                	addi	sp,sp,-32
    8000156a:	ec06                	sd	ra,24(sp)
    8000156c:	e822                	sd	s0,16(sp)
    8000156e:	e426                	sd	s1,8(sp)
    80001570:	e04a                	sd	s2,0(sp)
    80001572:	1000                	addi	s0,sp,32
    80001574:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001576:	25a040ef          	jal	800057d0 <acquire>
  k = p->killed;
    8000157a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	2e8040ef          	jal	80005868 <release>
  return k;
}
    80001584:	854a                	mv	a0,s2
    80001586:	60e2                	ld	ra,24(sp)
    80001588:	6442                	ld	s0,16(sp)
    8000158a:	64a2                	ld	s1,8(sp)
    8000158c:	6902                	ld	s2,0(sp)
    8000158e:	6105                	addi	sp,sp,32
    80001590:	8082                	ret

0000000080001592 <wait>:
{
    80001592:	715d                	addi	sp,sp,-80
    80001594:	e486                	sd	ra,72(sp)
    80001596:	e0a2                	sd	s0,64(sp)
    80001598:	fc26                	sd	s1,56(sp)
    8000159a:	f84a                	sd	s2,48(sp)
    8000159c:	f44e                	sd	s3,40(sp)
    8000159e:	f052                	sd	s4,32(sp)
    800015a0:	ec56                	sd	s5,24(sp)
    800015a2:	e85a                	sd	s6,16(sp)
    800015a4:	e45e                	sd	s7,8(sp)
    800015a6:	e062                	sd	s8,0(sp)
    800015a8:	0880                	addi	s0,sp,80
    800015aa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015ac:	faaff0ef          	jal	80000d56 <myproc>
    800015b0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015b2:	00009517          	auipc	a0,0x9
    800015b6:	e7650513          	addi	a0,a0,-394 # 8000a428 <wait_lock>
    800015ba:	216040ef          	jal	800057d0 <acquire>
    havekids = 0;
    800015be:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015c0:	4a15                	li	s4,5
        havekids = 1;
    800015c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c4:	0000f997          	auipc	s3,0xf
    800015c8:	e7c98993          	addi	s3,s3,-388 # 80010440 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015cc:	00009c17          	auipc	s8,0x9
    800015d0:	e5cc0c13          	addi	s8,s8,-420 # 8000a428 <wait_lock>
    800015d4:	a871                	j	80001670 <wait+0xde>
          pid = pp->pid;
    800015d6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015da:	000b0c63          	beqz	s6,800015f2 <wait+0x60>
    800015de:	4691                	li	a3,4
    800015e0:	02c48613          	addi	a2,s1,44
    800015e4:	85da                	mv	a1,s6
    800015e6:	05093503          	ld	a0,80(s2)
    800015ea:	bdcff0ef          	jal	800009c6 <copyout>
    800015ee:	02054b63          	bltz	a0,80001624 <wait+0x92>
          freeproc(pp);
    800015f2:	8526                	mv	a0,s1
    800015f4:	8d5ff0ef          	jal	80000ec8 <freeproc>
          release(&pp->lock);
    800015f8:	8526                	mv	a0,s1
    800015fa:	26e040ef          	jal	80005868 <release>
          release(&wait_lock);
    800015fe:	00009517          	auipc	a0,0x9
    80001602:	e2a50513          	addi	a0,a0,-470 # 8000a428 <wait_lock>
    80001606:	262040ef          	jal	80005868 <release>
}
    8000160a:	854e                	mv	a0,s3
    8000160c:	60a6                	ld	ra,72(sp)
    8000160e:	6406                	ld	s0,64(sp)
    80001610:	74e2                	ld	s1,56(sp)
    80001612:	7942                	ld	s2,48(sp)
    80001614:	79a2                	ld	s3,40(sp)
    80001616:	7a02                	ld	s4,32(sp)
    80001618:	6ae2                	ld	s5,24(sp)
    8000161a:	6b42                	ld	s6,16(sp)
    8000161c:	6ba2                	ld	s7,8(sp)
    8000161e:	6c02                	ld	s8,0(sp)
    80001620:	6161                	addi	sp,sp,80
    80001622:	8082                	ret
            release(&pp->lock);
    80001624:	8526                	mv	a0,s1
    80001626:	242040ef          	jal	80005868 <release>
            release(&wait_lock);
    8000162a:	00009517          	auipc	a0,0x9
    8000162e:	dfe50513          	addi	a0,a0,-514 # 8000a428 <wait_lock>
    80001632:	236040ef          	jal	80005868 <release>
            return -1;
    80001636:	59fd                	li	s3,-1
    80001638:	bfc9                	j	8000160a <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163a:	17048493          	addi	s1,s1,368
    8000163e:	03348063          	beq	s1,s3,8000165e <wait+0xcc>
      if(pp->parent == p){
    80001642:	7c9c                	ld	a5,56(s1)
    80001644:	ff279be3          	bne	a5,s2,8000163a <wait+0xa8>
        acquire(&pp->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	186040ef          	jal	800057d0 <acquire>
        if(pp->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94783e3          	beq	a5,s4,800015d6 <wait+0x44>
        release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	212040ef          	jal	80005868 <release>
        havekids = 1;
    8000165a:	8756                	mv	a4,s5
    8000165c:	bff9                	j	8000163a <wait+0xa8>
    if(!havekids || killed(p)){
    8000165e:	cf19                	beqz	a4,8000167c <wait+0xea>
    80001660:	854a                	mv	a0,s2
    80001662:	f07ff0ef          	jal	80001568 <killed>
    80001666:	e919                	bnez	a0,8000167c <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001668:	85e2                	mv	a1,s8
    8000166a:	854a                	mv	a0,s2
    8000166c:	cc5ff0ef          	jal	80001330 <sleep>
    havekids = 0;
    80001670:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001672:	00009497          	auipc	s1,0x9
    80001676:	1ce48493          	addi	s1,s1,462 # 8000a840 <proc>
    8000167a:	b7e1                	j	80001642 <wait+0xb0>
      release(&wait_lock);
    8000167c:	00009517          	auipc	a0,0x9
    80001680:	dac50513          	addi	a0,a0,-596 # 8000a428 <wait_lock>
    80001684:	1e4040ef          	jal	80005868 <release>
      return -1;
    80001688:	59fd                	li	s3,-1
    8000168a:	b741                	j	8000160a <wait+0x78>

000000008000168c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000168c:	7179                	addi	sp,sp,-48
    8000168e:	f406                	sd	ra,40(sp)
    80001690:	f022                	sd	s0,32(sp)
    80001692:	ec26                	sd	s1,24(sp)
    80001694:	e84a                	sd	s2,16(sp)
    80001696:	e44e                	sd	s3,8(sp)
    80001698:	e052                	sd	s4,0(sp)
    8000169a:	1800                	addi	s0,sp,48
    8000169c:	84aa                	mv	s1,a0
    8000169e:	892e                	mv	s2,a1
    800016a0:	89b2                	mv	s3,a2
    800016a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016a4:	eb2ff0ef          	jal	80000d56 <myproc>
  if(user_dst){
    800016a8:	cc99                	beqz	s1,800016c6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016aa:	86d2                	mv	a3,s4
    800016ac:	864e                	mv	a2,s3
    800016ae:	85ca                	mv	a1,s2
    800016b0:	6928                	ld	a0,80(a0)
    800016b2:	b14ff0ef          	jal	800009c6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016b6:	70a2                	ld	ra,40(sp)
    800016b8:	7402                	ld	s0,32(sp)
    800016ba:	64e2                	ld	s1,24(sp)
    800016bc:	6942                	ld	s2,16(sp)
    800016be:	69a2                	ld	s3,8(sp)
    800016c0:	6a02                	ld	s4,0(sp)
    800016c2:	6145                	addi	sp,sp,48
    800016c4:	8082                	ret
    memmove((char *)dst, src, len);
    800016c6:	000a061b          	sext.w	a2,s4
    800016ca:	85ce                	mv	a1,s3
    800016cc:	854a                	mv	a0,s2
    800016ce:	ac3fe0ef          	jal	80000190 <memmove>
    return 0;
    800016d2:	8526                	mv	a0,s1
    800016d4:	b7cd                	j	800016b6 <either_copyout+0x2a>

00000000800016d6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016d6:	7179                	addi	sp,sp,-48
    800016d8:	f406                	sd	ra,40(sp)
    800016da:	f022                	sd	s0,32(sp)
    800016dc:	ec26                	sd	s1,24(sp)
    800016de:	e84a                	sd	s2,16(sp)
    800016e0:	e44e                	sd	s3,8(sp)
    800016e2:	e052                	sd	s4,0(sp)
    800016e4:	1800                	addi	s0,sp,48
    800016e6:	892a                	mv	s2,a0
    800016e8:	84ae                	mv	s1,a1
    800016ea:	89b2                	mv	s3,a2
    800016ec:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016ee:	e68ff0ef          	jal	80000d56 <myproc>
  if(user_src){
    800016f2:	cc99                	beqz	s1,80001710 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016f4:	86d2                	mv	a3,s4
    800016f6:	864e                	mv	a2,s3
    800016f8:	85ca                	mv	a1,s2
    800016fa:	6928                	ld	a0,80(a0)
    800016fc:	ba2ff0ef          	jal	80000a9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001700:	70a2                	ld	ra,40(sp)
    80001702:	7402                	ld	s0,32(sp)
    80001704:	64e2                	ld	s1,24(sp)
    80001706:	6942                	ld	s2,16(sp)
    80001708:	69a2                	ld	s3,8(sp)
    8000170a:	6a02                	ld	s4,0(sp)
    8000170c:	6145                	addi	sp,sp,48
    8000170e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001710:	000a061b          	sext.w	a2,s4
    80001714:	85ce                	mv	a1,s3
    80001716:	854a                	mv	a0,s2
    80001718:	a79fe0ef          	jal	80000190 <memmove>
    return 0;
    8000171c:	8526                	mv	a0,s1
    8000171e:	b7cd                	j	80001700 <either_copyin+0x2a>

0000000080001720 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001720:	715d                	addi	sp,sp,-80
    80001722:	e486                	sd	ra,72(sp)
    80001724:	e0a2                	sd	s0,64(sp)
    80001726:	fc26                	sd	s1,56(sp)
    80001728:	f84a                	sd	s2,48(sp)
    8000172a:	f44e                	sd	s3,40(sp)
    8000172c:	f052                	sd	s4,32(sp)
    8000172e:	ec56                	sd	s5,24(sp)
    80001730:	e85a                	sd	s6,16(sp)
    80001732:	e45e                	sd	s7,8(sp)
    80001734:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001736:	00006517          	auipc	a0,0x6
    8000173a:	8e250513          	addi	a0,a0,-1822 # 80007018 <etext+0x18>
    8000173e:	293030ef          	jal	800051d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001742:	00009497          	auipc	s1,0x9
    80001746:	25648493          	addi	s1,s1,598 # 8000a998 <proc+0x158>
    8000174a:	0000f917          	auipc	s2,0xf
    8000174e:	e4e90913          	addi	s2,s2,-434 # 80010598 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001752:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001754:	00006997          	auipc	s3,0x6
    80001758:	afc98993          	addi	s3,s3,-1284 # 80007250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    8000175c:	00006a97          	auipc	s5,0x6
    80001760:	afca8a93          	addi	s5,s5,-1284 # 80007258 <etext+0x258>
    printf("\n");
    80001764:	00006a17          	auipc	s4,0x6
    80001768:	8b4a0a13          	addi	s4,s4,-1868 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000176c:	00006b97          	auipc	s7,0x6
    80001770:	0ccb8b93          	addi	s7,s7,204 # 80007838 <states.0>
    80001774:	a829                	j	8000178e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001776:	ed86a583          	lw	a1,-296(a3)
    8000177a:	8556                	mv	a0,s5
    8000177c:	255030ef          	jal	800051d0 <printf>
    printf("\n");
    80001780:	8552                	mv	a0,s4
    80001782:	24f030ef          	jal	800051d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001786:	17048493          	addi	s1,s1,368
    8000178a:	03248263          	beq	s1,s2,800017ae <procdump+0x8e>
    if(p->state == UNUSED)
    8000178e:	86a6                	mv	a3,s1
    80001790:	ec04a783          	lw	a5,-320(s1)
    80001794:	dbed                	beqz	a5,80001786 <procdump+0x66>
      state = "???";
    80001796:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001798:	fcfb6fe3          	bltu	s6,a5,80001776 <procdump+0x56>
    8000179c:	02079713          	slli	a4,a5,0x20
    800017a0:	01d75793          	srli	a5,a4,0x1d
    800017a4:	97de                	add	a5,a5,s7
    800017a6:	6390                	ld	a2,0(a5)
    800017a8:	f679                	bnez	a2,80001776 <procdump+0x56>
      state = "???";
    800017aa:	864e                	mv	a2,s3
    800017ac:	b7e9                	j	80001776 <procdump+0x56>
  }
}
    800017ae:	60a6                	ld	ra,72(sp)
    800017b0:	6406                	ld	s0,64(sp)
    800017b2:	74e2                	ld	s1,56(sp)
    800017b4:	7942                	ld	s2,48(sp)
    800017b6:	79a2                	ld	s3,40(sp)
    800017b8:	7a02                	ld	s4,32(sp)
    800017ba:	6ae2                	ld	s5,24(sp)
    800017bc:	6b42                	ld	s6,16(sp)
    800017be:	6ba2                	ld	s7,8(sp)
    800017c0:	6161                	addi	sp,sp,80
    800017c2:	8082                	ret

00000000800017c4 <swtch>:
    800017c4:	00153023          	sd	ra,0(a0)
    800017c8:	00253423          	sd	sp,8(a0)
    800017cc:	e900                	sd	s0,16(a0)
    800017ce:	ed04                	sd	s1,24(a0)
    800017d0:	03253023          	sd	s2,32(a0)
    800017d4:	03353423          	sd	s3,40(a0)
    800017d8:	03453823          	sd	s4,48(a0)
    800017dc:	03553c23          	sd	s5,56(a0)
    800017e0:	05653023          	sd	s6,64(a0)
    800017e4:	05753423          	sd	s7,72(a0)
    800017e8:	05853823          	sd	s8,80(a0)
    800017ec:	05953c23          	sd	s9,88(a0)
    800017f0:	07a53023          	sd	s10,96(a0)
    800017f4:	07b53423          	sd	s11,104(a0)
    800017f8:	0005b083          	ld	ra,0(a1)
    800017fc:	0085b103          	ld	sp,8(a1)
    80001800:	6980                	ld	s0,16(a1)
    80001802:	6d84                	ld	s1,24(a1)
    80001804:	0205b903          	ld	s2,32(a1)
    80001808:	0285b983          	ld	s3,40(a1)
    8000180c:	0305ba03          	ld	s4,48(a1)
    80001810:	0385ba83          	ld	s5,56(a1)
    80001814:	0405bb03          	ld	s6,64(a1)
    80001818:	0485bb83          	ld	s7,72(a1)
    8000181c:	0505bc03          	ld	s8,80(a1)
    80001820:	0585bc83          	ld	s9,88(a1)
    80001824:	0605bd03          	ld	s10,96(a1)
    80001828:	0685bd83          	ld	s11,104(a1)
    8000182c:	8082                	ret

000000008000182e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000182e:	1141                	addi	sp,sp,-16
    80001830:	e406                	sd	ra,8(sp)
    80001832:	e022                	sd	s0,0(sp)
    80001834:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001836:	00006597          	auipc	a1,0x6
    8000183a:	a6258593          	addi	a1,a1,-1438 # 80007298 <etext+0x298>
    8000183e:	0000f517          	auipc	a0,0xf
    80001842:	c0250513          	addi	a0,a0,-1022 # 80010440 <tickslock>
    80001846:	70b030ef          	jal	80005750 <initlock>
}
    8000184a:	60a2                	ld	ra,8(sp)
    8000184c:	6402                	ld	s0,0(sp)
    8000184e:	0141                	addi	sp,sp,16
    80001850:	8082                	ret

0000000080001852 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001852:	1141                	addi	sp,sp,-16
    80001854:	e422                	sd	s0,8(sp)
    80001856:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001858:	00003797          	auipc	a5,0x3
    8000185c:	eb878793          	addi	a5,a5,-328 # 80004710 <kernelvec>
    80001860:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001864:	6422                	ld	s0,8(sp)
    80001866:	0141                	addi	sp,sp,16
    80001868:	8082                	ret

000000008000186a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000186a:	1141                	addi	sp,sp,-16
    8000186c:	e406                	sd	ra,8(sp)
    8000186e:	e022                	sd	s0,0(sp)
    80001870:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001872:	ce4ff0ef          	jal	80000d56 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001876:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000187a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000187c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001880:	00004697          	auipc	a3,0x4
    80001884:	78068693          	addi	a3,a3,1920 # 80006000 <_trampoline>
    80001888:	00004717          	auipc	a4,0x4
    8000188c:	77870713          	addi	a4,a4,1912 # 80006000 <_trampoline>
    80001890:	8f15                	sub	a4,a4,a3
    80001892:	040007b7          	lui	a5,0x4000
    80001896:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001898:	07b2                	slli	a5,a5,0xc
    8000189a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000189c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018a0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018a2:	18002673          	csrr	a2,satp
    800018a6:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018a8:	6d30                	ld	a2,88(a0)
    800018aa:	6138                	ld	a4,64(a0)
    800018ac:	6585                	lui	a1,0x1
    800018ae:	972e                	add	a4,a4,a1
    800018b0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018b2:	6d38                	ld	a4,88(a0)
    800018b4:	00000617          	auipc	a2,0x0
    800018b8:	11060613          	addi	a2,a2,272 # 800019c4 <usertrap>
    800018bc:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018be:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018c0:	8612                	mv	a2,tp
    800018c2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018c4:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018c8:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018cc:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018d0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018d4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018d6:	6f18                	ld	a4,24(a4)
    800018d8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018dc:	6928                	ld	a0,80(a0)
    800018de:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018e0:	00004717          	auipc	a4,0x4
    800018e4:	7bc70713          	addi	a4,a4,1980 # 8000609c <userret>
    800018e8:	8f15                	sub	a4,a4,a3
    800018ea:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018ec:	577d                	li	a4,-1
    800018ee:	177e                	slli	a4,a4,0x3f
    800018f0:	8d59                	or	a0,a0,a4
    800018f2:	9782                	jalr	a5
}
    800018f4:	60a2                	ld	ra,8(sp)
    800018f6:	6402                	ld	s0,0(sp)
    800018f8:	0141                	addi	sp,sp,16
    800018fa:	8082                	ret

00000000800018fc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018fc:	1101                	addi	sp,sp,-32
    800018fe:	ec06                	sd	ra,24(sp)
    80001900:	e822                	sd	s0,16(sp)
    80001902:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001904:	c26ff0ef          	jal	80000d2a <cpuid>
    80001908:	cd11                	beqz	a0,80001924 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000190a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000190e:	000f4737          	lui	a4,0xf4
    80001912:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001916:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001918:	14d79073          	csrw	stimecmp,a5
}
    8000191c:	60e2                	ld	ra,24(sp)
    8000191e:	6442                	ld	s0,16(sp)
    80001920:	6105                	addi	sp,sp,32
    80001922:	8082                	ret
    80001924:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001926:	0000f497          	auipc	s1,0xf
    8000192a:	b1a48493          	addi	s1,s1,-1254 # 80010440 <tickslock>
    8000192e:	8526                	mv	a0,s1
    80001930:	6a1030ef          	jal	800057d0 <acquire>
    ticks++;
    80001934:	00009517          	auipc	a0,0x9
    80001938:	aa450513          	addi	a0,a0,-1372 # 8000a3d8 <ticks>
    8000193c:	411c                	lw	a5,0(a0)
    8000193e:	2785                	addiw	a5,a5,1
    80001940:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001942:	a3bff0ef          	jal	8000137c <wakeup>
    release(&tickslock);
    80001946:	8526                	mv	a0,s1
    80001948:	721030ef          	jal	80005868 <release>
    8000194c:	64a2                	ld	s1,8(sp)
    8000194e:	bf75                	j	8000190a <clockintr+0xe>

0000000080001950 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001950:	1101                	addi	sp,sp,-32
    80001952:	ec06                	sd	ra,24(sp)
    80001954:	e822                	sd	s0,16(sp)
    80001956:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001958:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000195c:	57fd                	li	a5,-1
    8000195e:	17fe                	slli	a5,a5,0x3f
    80001960:	07a5                	addi	a5,a5,9
    80001962:	00f70c63          	beq	a4,a5,8000197a <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001966:	57fd                	li	a5,-1
    80001968:	17fe                	slli	a5,a5,0x3f
    8000196a:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000196c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000196e:	04f70763          	beq	a4,a5,800019bc <devintr+0x6c>
  }
}
    80001972:	60e2                	ld	ra,24(sp)
    80001974:	6442                	ld	s0,16(sp)
    80001976:	6105                	addi	sp,sp,32
    80001978:	8082                	ret
    8000197a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000197c:	641020ef          	jal	800047bc <plic_claim>
    80001980:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001982:	47a9                	li	a5,10
    80001984:	00f50963          	beq	a0,a5,80001996 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001988:	4785                	li	a5,1
    8000198a:	00f50963          	beq	a0,a5,8000199c <devintr+0x4c>
    return 1;
    8000198e:	4505                	li	a0,1
    } else if(irq){
    80001990:	e889                	bnez	s1,800019a2 <devintr+0x52>
    80001992:	64a2                	ld	s1,8(sp)
    80001994:	bff9                	j	80001972 <devintr+0x22>
      uartintr();
    80001996:	57f030ef          	jal	80005714 <uartintr>
    if(irq)
    8000199a:	a819                	j	800019b0 <devintr+0x60>
      virtio_disk_intr();
    8000199c:	2e6030ef          	jal	80004c82 <virtio_disk_intr>
    if(irq)
    800019a0:	a801                	j	800019b0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a2:	85a6                	mv	a1,s1
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	8fc50513          	addi	a0,a0,-1796 # 800072a0 <etext+0x2a0>
    800019ac:	025030ef          	jal	800051d0 <printf>
      plic_complete(irq);
    800019b0:	8526                	mv	a0,s1
    800019b2:	62b020ef          	jal	800047dc <plic_complete>
    return 1;
    800019b6:	4505                	li	a0,1
    800019b8:	64a2                	ld	s1,8(sp)
    800019ba:	bf65                	j	80001972 <devintr+0x22>
    clockintr();
    800019bc:	f41ff0ef          	jal	800018fc <clockintr>
    return 2;
    800019c0:	4509                	li	a0,2
    800019c2:	bf45                	j	80001972 <devintr+0x22>

00000000800019c4 <usertrap>:
{
    800019c4:	1101                	addi	sp,sp,-32
    800019c6:	ec06                	sd	ra,24(sp)
    800019c8:	e822                	sd	s0,16(sp)
    800019ca:	e426                	sd	s1,8(sp)
    800019cc:	e04a                	sd	s2,0(sp)
    800019ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019d0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019d4:	1007f793          	andi	a5,a5,256
    800019d8:	ef85                	bnez	a5,80001a10 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019da:	00003797          	auipc	a5,0x3
    800019de:	d3678793          	addi	a5,a5,-714 # 80004710 <kernelvec>
    800019e2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019e6:	b70ff0ef          	jal	80000d56 <myproc>
    800019ea:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019ec:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019ee:	14102773          	csrr	a4,sepc
    800019f2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019f8:	47a1                	li	a5,8
    800019fa:	02f70163          	beq	a4,a5,80001a1c <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019fe:	f53ff0ef          	jal	80001950 <devintr>
    80001a02:	892a                	mv	s2,a0
    80001a04:	c135                	beqz	a0,80001a68 <usertrap+0xa4>
  if(killed(p))
    80001a06:	8526                	mv	a0,s1
    80001a08:	b61ff0ef          	jal	80001568 <killed>
    80001a0c:	cd1d                	beqz	a0,80001a4a <usertrap+0x86>
    80001a0e:	a81d                	j	80001a44 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a10:	00006517          	auipc	a0,0x6
    80001a14:	8b050513          	addi	a0,a0,-1872 # 800072c0 <etext+0x2c0>
    80001a18:	28b030ef          	jal	800054a2 <panic>
    if(killed(p))
    80001a1c:	b4dff0ef          	jal	80001568 <killed>
    80001a20:	e121                	bnez	a0,80001a60 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a22:	6cb8                	ld	a4,88(s1)
    80001a24:	6f1c                	ld	a5,24(a4)
    80001a26:	0791                	addi	a5,a5,4
    80001a28:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a2a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a2e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a32:	10079073          	csrw	sstatus,a5
    syscall();
    80001a36:	248000ef          	jal	80001c7e <syscall>
  if(killed(p))
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	b2dff0ef          	jal	80001568 <killed>
    80001a40:	c901                	beqz	a0,80001a50 <usertrap+0x8c>
    80001a42:	4901                	li	s2,0
    exit(-1);
    80001a44:	557d                	li	a0,-1
    80001a46:	9f7ff0ef          	jal	8000143c <exit>
  if(which_dev == 2)
    80001a4a:	4789                	li	a5,2
    80001a4c:	04f90563          	beq	s2,a5,80001a96 <usertrap+0xd2>
  usertrapret();
    80001a50:	e1bff0ef          	jal	8000186a <usertrapret>
}
    80001a54:	60e2                	ld	ra,24(sp)
    80001a56:	6442                	ld	s0,16(sp)
    80001a58:	64a2                	ld	s1,8(sp)
    80001a5a:	6902                	ld	s2,0(sp)
    80001a5c:	6105                	addi	sp,sp,32
    80001a5e:	8082                	ret
      exit(-1);
    80001a60:	557d                	li	a0,-1
    80001a62:	9dbff0ef          	jal	8000143c <exit>
    80001a66:	bf75                	j	80001a22 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a68:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a6c:	5890                	lw	a2,48(s1)
    80001a6e:	00006517          	auipc	a0,0x6
    80001a72:	87250513          	addi	a0,a0,-1934 # 800072e0 <etext+0x2e0>
    80001a76:	75a030ef          	jal	800051d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a7e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	88e50513          	addi	a0,a0,-1906 # 80007310 <etext+0x310>
    80001a8a:	746030ef          	jal	800051d0 <printf>
    setkilled(p);
    80001a8e:	8526                	mv	a0,s1
    80001a90:	ab5ff0ef          	jal	80001544 <setkilled>
    80001a94:	b75d                	j	80001a3a <usertrap+0x76>
    yield();
    80001a96:	86fff0ef          	jal	80001304 <yield>
    80001a9a:	bf5d                	j	80001a50 <usertrap+0x8c>

0000000080001a9c <kerneltrap>:
{
    80001a9c:	7179                	addi	sp,sp,-48
    80001a9e:	f406                	sd	ra,40(sp)
    80001aa0:	f022                	sd	s0,32(sp)
    80001aa2:	ec26                	sd	s1,24(sp)
    80001aa4:	e84a                	sd	s2,16(sp)
    80001aa6:	e44e                	sd	s3,8(sp)
    80001aa8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aaa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aae:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ab2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ab6:	1004f793          	andi	a5,s1,256
    80001aba:	c795                	beqz	a5,80001ae6 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001abc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ac0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ac2:	eb85                	bnez	a5,80001af2 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ac4:	e8dff0ef          	jal	80001950 <devintr>
    80001ac8:	c91d                	beqz	a0,80001afe <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001aca:	4789                	li	a5,2
    80001acc:	04f50a63          	beq	a0,a5,80001b20 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ad0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad4:	10049073          	csrw	sstatus,s1
}
    80001ad8:	70a2                	ld	ra,40(sp)
    80001ada:	7402                	ld	s0,32(sp)
    80001adc:	64e2                	ld	s1,24(sp)
    80001ade:	6942                	ld	s2,16(sp)
    80001ae0:	69a2                	ld	s3,8(sp)
    80001ae2:	6145                	addi	sp,sp,48
    80001ae4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ae6:	00006517          	auipc	a0,0x6
    80001aea:	85250513          	addi	a0,a0,-1966 # 80007338 <etext+0x338>
    80001aee:	1b5030ef          	jal	800054a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af2:	00006517          	auipc	a0,0x6
    80001af6:	86e50513          	addi	a0,a0,-1938 # 80007360 <etext+0x360>
    80001afa:	1a9030ef          	jal	800054a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afe:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b02:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b06:	85ce                	mv	a1,s3
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	87850513          	addi	a0,a0,-1928 # 80007380 <etext+0x380>
    80001b10:	6c0030ef          	jal	800051d0 <printf>
    panic("kerneltrap");
    80001b14:	00006517          	auipc	a0,0x6
    80001b18:	89450513          	addi	a0,a0,-1900 # 800073a8 <etext+0x3a8>
    80001b1c:	187030ef          	jal	800054a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b20:	a36ff0ef          	jal	80000d56 <myproc>
    80001b24:	d555                	beqz	a0,80001ad0 <kerneltrap+0x34>
    yield();
    80001b26:	fdeff0ef          	jal	80001304 <yield>
    80001b2a:	b75d                	j	80001ad0 <kerneltrap+0x34>

0000000080001b2c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b2c:	1101                	addi	sp,sp,-32
    80001b2e:	ec06                	sd	ra,24(sp)
    80001b30:	e822                	sd	s0,16(sp)
    80001b32:	e426                	sd	s1,8(sp)
    80001b34:	1000                	addi	s0,sp,32
    80001b36:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b38:	a1eff0ef          	jal	80000d56 <myproc>
  switch (n) {
    80001b3c:	4795                	li	a5,5
    80001b3e:	0497e163          	bltu	a5,s1,80001b80 <argraw+0x54>
    80001b42:	048a                	slli	s1,s1,0x2
    80001b44:	00006717          	auipc	a4,0x6
    80001b48:	d2470713          	addi	a4,a4,-732 # 80007868 <states.0+0x30>
    80001b4c:	94ba                	add	s1,s1,a4
    80001b4e:	409c                	lw	a5,0(s1)
    80001b50:	97ba                	add	a5,a5,a4
    80001b52:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b54:	6d3c                	ld	a5,88(a0)
    80001b56:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b58:	60e2                	ld	ra,24(sp)
    80001b5a:	6442                	ld	s0,16(sp)
    80001b5c:	64a2                	ld	s1,8(sp)
    80001b5e:	6105                	addi	sp,sp,32
    80001b60:	8082                	ret
    return p->trapframe->a1;
    80001b62:	6d3c                	ld	a5,88(a0)
    80001b64:	7fa8                	ld	a0,120(a5)
    80001b66:	bfcd                	j	80001b58 <argraw+0x2c>
    return p->trapframe->a2;
    80001b68:	6d3c                	ld	a5,88(a0)
    80001b6a:	63c8                	ld	a0,128(a5)
    80001b6c:	b7f5                	j	80001b58 <argraw+0x2c>
    return p->trapframe->a3;
    80001b6e:	6d3c                	ld	a5,88(a0)
    80001b70:	67c8                	ld	a0,136(a5)
    80001b72:	b7dd                	j	80001b58 <argraw+0x2c>
    return p->trapframe->a4;
    80001b74:	6d3c                	ld	a5,88(a0)
    80001b76:	6bc8                	ld	a0,144(a5)
    80001b78:	b7c5                	j	80001b58 <argraw+0x2c>
    return p->trapframe->a5;
    80001b7a:	6d3c                	ld	a5,88(a0)
    80001b7c:	6fc8                	ld	a0,152(a5)
    80001b7e:	bfe9                	j	80001b58 <argraw+0x2c>
  panic("argraw");
    80001b80:	00006517          	auipc	a0,0x6
    80001b84:	83850513          	addi	a0,a0,-1992 # 800073b8 <etext+0x3b8>
    80001b88:	11b030ef          	jal	800054a2 <panic>

0000000080001b8c <fetchaddr>:
{
    80001b8c:	1101                	addi	sp,sp,-32
    80001b8e:	ec06                	sd	ra,24(sp)
    80001b90:	e822                	sd	s0,16(sp)
    80001b92:	e426                	sd	s1,8(sp)
    80001b94:	e04a                	sd	s2,0(sp)
    80001b96:	1000                	addi	s0,sp,32
    80001b98:	84aa                	mv	s1,a0
    80001b9a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b9c:	9baff0ef          	jal	80000d56 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ba0:	653c                	ld	a5,72(a0)
    80001ba2:	02f4f663          	bgeu	s1,a5,80001bce <fetchaddr+0x42>
    80001ba6:	00848713          	addi	a4,s1,8
    80001baa:	02e7e463          	bltu	a5,a4,80001bd2 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001bae:	46a1                	li	a3,8
    80001bb0:	8626                	mv	a2,s1
    80001bb2:	85ca                	mv	a1,s2
    80001bb4:	6928                	ld	a0,80(a0)
    80001bb6:	ee9fe0ef          	jal	80000a9e <copyin>
    80001bba:	00a03533          	snez	a0,a0
    80001bbe:	40a00533          	neg	a0,a0
}
    80001bc2:	60e2                	ld	ra,24(sp)
    80001bc4:	6442                	ld	s0,16(sp)
    80001bc6:	64a2                	ld	s1,8(sp)
    80001bc8:	6902                	ld	s2,0(sp)
    80001bca:	6105                	addi	sp,sp,32
    80001bcc:	8082                	ret
    return -1;
    80001bce:	557d                	li	a0,-1
    80001bd0:	bfcd                	j	80001bc2 <fetchaddr+0x36>
    80001bd2:	557d                	li	a0,-1
    80001bd4:	b7fd                	j	80001bc2 <fetchaddr+0x36>

0000000080001bd6 <fetchstr>:
{
    80001bd6:	7179                	addi	sp,sp,-48
    80001bd8:	f406                	sd	ra,40(sp)
    80001bda:	f022                	sd	s0,32(sp)
    80001bdc:	ec26                	sd	s1,24(sp)
    80001bde:	e84a                	sd	s2,16(sp)
    80001be0:	e44e                	sd	s3,8(sp)
    80001be2:	1800                	addi	s0,sp,48
    80001be4:	892a                	mv	s2,a0
    80001be6:	84ae                	mv	s1,a1
    80001be8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bea:	96cff0ef          	jal	80000d56 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bee:	86ce                	mv	a3,s3
    80001bf0:	864a                	mv	a2,s2
    80001bf2:	85a6                	mv	a1,s1
    80001bf4:	6928                	ld	a0,80(a0)
    80001bf6:	f2ffe0ef          	jal	80000b24 <copyinstr>
    80001bfa:	00054c63          	bltz	a0,80001c12 <fetchstr+0x3c>
  return strlen(buf);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	ea4fe0ef          	jal	800002a4 <strlen>
}
    80001c04:	70a2                	ld	ra,40(sp)
    80001c06:	7402                	ld	s0,32(sp)
    80001c08:	64e2                	ld	s1,24(sp)
    80001c0a:	6942                	ld	s2,16(sp)
    80001c0c:	69a2                	ld	s3,8(sp)
    80001c0e:	6145                	addi	sp,sp,48
    80001c10:	8082                	ret
    return -1;
    80001c12:	557d                	li	a0,-1
    80001c14:	bfc5                	j	80001c04 <fetchstr+0x2e>

0000000080001c16 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c16:	1101                	addi	sp,sp,-32
    80001c18:	ec06                	sd	ra,24(sp)
    80001c1a:	e822                	sd	s0,16(sp)
    80001c1c:	e426                	sd	s1,8(sp)
    80001c1e:	1000                	addi	s0,sp,32
    80001c20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c22:	f0bff0ef          	jal	80001b2c <argraw>
    80001c26:	c088                	sw	a0,0(s1)
}
    80001c28:	60e2                	ld	ra,24(sp)
    80001c2a:	6442                	ld	s0,16(sp)
    80001c2c:	64a2                	ld	s1,8(sp)
    80001c2e:	6105                	addi	sp,sp,32
    80001c30:	8082                	ret

0000000080001c32 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	e426                	sd	s1,8(sp)
    80001c3a:	1000                	addi	s0,sp,32
    80001c3c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c3e:	eefff0ef          	jal	80001b2c <argraw>
    80001c42:	e088                	sd	a0,0(s1)
}
    80001c44:	60e2                	ld	ra,24(sp)
    80001c46:	6442                	ld	s0,16(sp)
    80001c48:	64a2                	ld	s1,8(sp)
    80001c4a:	6105                	addi	sp,sp,32
    80001c4c:	8082                	ret

0000000080001c4e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c4e:	7179                	addi	sp,sp,-48
    80001c50:	f406                	sd	ra,40(sp)
    80001c52:	f022                	sd	s0,32(sp)
    80001c54:	ec26                	sd	s1,24(sp)
    80001c56:	e84a                	sd	s2,16(sp)
    80001c58:	1800                	addi	s0,sp,48
    80001c5a:	84ae                	mv	s1,a1
    80001c5c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c5e:	fd840593          	addi	a1,s0,-40
    80001c62:	fd1ff0ef          	jal	80001c32 <argaddr>
  return fetchstr(addr, buf, max);
    80001c66:	864a                	mv	a2,s2
    80001c68:	85a6                	mv	a1,s1
    80001c6a:	fd843503          	ld	a0,-40(s0)
    80001c6e:	f69ff0ef          	jal	80001bd6 <fetchstr>
}
    80001c72:	70a2                	ld	ra,40(sp)
    80001c74:	7402                	ld	s0,32(sp)
    80001c76:	64e2                	ld	s1,24(sp)
    80001c78:	6942                	ld	s2,16(sp)
    80001c7a:	6145                	addi	sp,sp,48
    80001c7c:	8082                	ret

0000000080001c7e <syscall>:
  [SYS_trace]   "trace",
};

void
syscall(void)
{
    80001c7e:	7179                	addi	sp,sp,-48
    80001c80:	f406                	sd	ra,40(sp)
    80001c82:	f022                	sd	s0,32(sp)
    80001c84:	ec26                	sd	s1,24(sp)
    80001c86:	e84a                	sd	s2,16(sp)
    80001c88:	e44e                	sd	s3,8(sp)
    80001c8a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001c8c:	8caff0ef          	jal	80000d56 <myproc>
    80001c90:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c92:	05853903          	ld	s2,88(a0)
    80001c96:	0a893783          	ld	a5,168(s2)
    80001c9a:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c9e:	37fd                	addiw	a5,a5,-1
    80001ca0:	4759                	li	a4,22
    80001ca2:	04f76563          	bltu	a4,a5,80001cec <syscall+0x6e>
    80001ca6:	00399713          	slli	a4,s3,0x3
    80001caa:	00006797          	auipc	a5,0x6
    80001cae:	bd678793          	addi	a5,a5,-1066 # 80007880 <syscalls>
    80001cb2:	97ba                	add	a5,a5,a4
    80001cb4:	639c                	ld	a5,0(a5)
    80001cb6:	cb9d                	beqz	a5,80001cec <syscall+0x6e>
    p->trapframe->a0 = syscalls[num]();
    80001cb8:	9782                	jalr	a5
    80001cba:	06a93823          	sd	a0,112(s2)
    
    // Verificar se deve rastrear esta syscall
    if(p->trace_mask & (1 << num)) {
    80001cbe:	1684a783          	lw	a5,360(s1)
    80001cc2:	4137d7bb          	sraw	a5,a5,s3
    80001cc6:	8b85                	andi	a5,a5,1
    80001cc8:	cf9d                	beqz	a5,80001d06 <syscall+0x88>
      printf("%d: syscall %s -> %ld\n", 
    80001cca:	6cb8                	ld	a4,88(s1)
    80001ccc:	098e                	slli	s3,s3,0x3
    80001cce:	00006797          	auipc	a5,0x6
    80001cd2:	bb278793          	addi	a5,a5,-1102 # 80007880 <syscalls>
    80001cd6:	97ce                	add	a5,a5,s3
    80001cd8:	7b34                	ld	a3,112(a4)
    80001cda:	63f0                	ld	a2,192(a5)
    80001cdc:	588c                	lw	a1,48(s1)
    80001cde:	00005517          	auipc	a0,0x5
    80001ce2:	6e250513          	addi	a0,a0,1762 # 800073c0 <etext+0x3c0>
    80001ce6:	4ea030ef          	jal	800051d0 <printf>
    80001cea:	a831                	j	80001d06 <syscall+0x88>
        p->pid, syscall_names[num], p->trapframe->a0);
    }
  } else {
    printf("%d %s: unknown sys call %d\n", 
    80001cec:	86ce                	mv	a3,s3
    80001cee:	15848613          	addi	a2,s1,344
    80001cf2:	588c                	lw	a1,48(s1)
    80001cf4:	00005517          	auipc	a0,0x5
    80001cf8:	6e450513          	addi	a0,a0,1764 # 800073d8 <etext+0x3d8>
    80001cfc:	4d4030ef          	jal	800051d0 <printf>
      p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d00:	6cbc                	ld	a5,88(s1)
    80001d02:	577d                	li	a4,-1
    80001d04:	fbb8                	sd	a4,112(a5)
  }
}
    80001d06:	70a2                	ld	ra,40(sp)
    80001d08:	7402                	ld	s0,32(sp)
    80001d0a:	64e2                	ld	s1,24(sp)
    80001d0c:	6942                	ld	s2,16(sp)
    80001d0e:	69a2                	ld	s3,8(sp)
    80001d10:	6145                	addi	sp,sp,48
    80001d12:	8082                	ret

0000000080001d14 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001d14:	1101                	addi	sp,sp,-32
    80001d16:	ec06                	sd	ra,24(sp)
    80001d18:	e822                	sd	s0,16(sp)
    80001d1a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d1c:	fec40593          	addi	a1,s0,-20
    80001d20:	4501                	li	a0,0
    80001d22:	ef5ff0ef          	jal	80001c16 <argint>
  exit(n);
    80001d26:	fec42503          	lw	a0,-20(s0)
    80001d2a:	f12ff0ef          	jal	8000143c <exit>
  return 0;  // not reached
}
    80001d2e:	4501                	li	a0,0
    80001d30:	60e2                	ld	ra,24(sp)
    80001d32:	6442                	ld	s0,16(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret

0000000080001d38 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d38:	1141                	addi	sp,sp,-16
    80001d3a:	e406                	sd	ra,8(sp)
    80001d3c:	e022                	sd	s0,0(sp)
    80001d3e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d40:	816ff0ef          	jal	80000d56 <myproc>
}
    80001d44:	5908                	lw	a0,48(a0)
    80001d46:	60a2                	ld	ra,8(sp)
    80001d48:	6402                	ld	s0,0(sp)
    80001d4a:	0141                	addi	sp,sp,16
    80001d4c:	8082                	ret

0000000080001d4e <sys_fork>:

uint64
sys_fork(void)
{
    80001d4e:	1141                	addi	sp,sp,-16
    80001d50:	e406                	sd	ra,8(sp)
    80001d52:	e022                	sd	s0,0(sp)
    80001d54:	0800                	addi	s0,sp,16
  return fork();
    80001d56:	b2aff0ef          	jal	80001080 <fork>
}
    80001d5a:	60a2                	ld	ra,8(sp)
    80001d5c:	6402                	ld	s0,0(sp)
    80001d5e:	0141                	addi	sp,sp,16
    80001d60:	8082                	ret

0000000080001d62 <sys_wait>:

uint64
sys_wait(void)
{
    80001d62:	1101                	addi	sp,sp,-32
    80001d64:	ec06                	sd	ra,24(sp)
    80001d66:	e822                	sd	s0,16(sp)
    80001d68:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d6a:	fe840593          	addi	a1,s0,-24
    80001d6e:	4501                	li	a0,0
    80001d70:	ec3ff0ef          	jal	80001c32 <argaddr>
  return wait(p);
    80001d74:	fe843503          	ld	a0,-24(s0)
    80001d78:	81bff0ef          	jal	80001592 <wait>
}
    80001d7c:	60e2                	ld	ra,24(sp)
    80001d7e:	6442                	ld	s0,16(sp)
    80001d80:	6105                	addi	sp,sp,32
    80001d82:	8082                	ret

0000000080001d84 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d84:	7179                	addi	sp,sp,-48
    80001d86:	f406                	sd	ra,40(sp)
    80001d88:	f022                	sd	s0,32(sp)
    80001d8a:	ec26                	sd	s1,24(sp)
    80001d8c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d8e:	fdc40593          	addi	a1,s0,-36
    80001d92:	4501                	li	a0,0
    80001d94:	e83ff0ef          	jal	80001c16 <argint>
  addr = myproc()->sz;
    80001d98:	fbffe0ef          	jal	80000d56 <myproc>
    80001d9c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d9e:	fdc42503          	lw	a0,-36(s0)
    80001da2:	a8eff0ef          	jal	80001030 <growproc>
    80001da6:	00054863          	bltz	a0,80001db6 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001daa:	8526                	mv	a0,s1
    80001dac:	70a2                	ld	ra,40(sp)
    80001dae:	7402                	ld	s0,32(sp)
    80001db0:	64e2                	ld	s1,24(sp)
    80001db2:	6145                	addi	sp,sp,48
    80001db4:	8082                	ret
    return -1;
    80001db6:	54fd                	li	s1,-1
    80001db8:	bfcd                	j	80001daa <sys_sbrk+0x26>

0000000080001dba <sys_sleep>:

uint64
sys_sleep(void)
{
    80001dba:	7139                	addi	sp,sp,-64
    80001dbc:	fc06                	sd	ra,56(sp)
    80001dbe:	f822                	sd	s0,48(sp)
    80001dc0:	f04a                	sd	s2,32(sp)
    80001dc2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001dc4:	fcc40593          	addi	a1,s0,-52
    80001dc8:	4501                	li	a0,0
    80001dca:	e4dff0ef          	jal	80001c16 <argint>
  if(n < 0)
    80001dce:	fcc42783          	lw	a5,-52(s0)
    80001dd2:	0607c763          	bltz	a5,80001e40 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001dd6:	0000e517          	auipc	a0,0xe
    80001dda:	66a50513          	addi	a0,a0,1642 # 80010440 <tickslock>
    80001dde:	1f3030ef          	jal	800057d0 <acquire>
  ticks0 = ticks;
    80001de2:	00008917          	auipc	s2,0x8
    80001de6:	5f692903          	lw	s2,1526(s2) # 8000a3d8 <ticks>
  while(ticks - ticks0 < n){
    80001dea:	fcc42783          	lw	a5,-52(s0)
    80001dee:	cf8d                	beqz	a5,80001e28 <sys_sleep+0x6e>
    80001df0:	f426                	sd	s1,40(sp)
    80001df2:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001df4:	0000e997          	auipc	s3,0xe
    80001df8:	64c98993          	addi	s3,s3,1612 # 80010440 <tickslock>
    80001dfc:	00008497          	auipc	s1,0x8
    80001e00:	5dc48493          	addi	s1,s1,1500 # 8000a3d8 <ticks>
    if(killed(myproc())){
    80001e04:	f53fe0ef          	jal	80000d56 <myproc>
    80001e08:	f60ff0ef          	jal	80001568 <killed>
    80001e0c:	ed0d                	bnez	a0,80001e46 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e0e:	85ce                	mv	a1,s3
    80001e10:	8526                	mv	a0,s1
    80001e12:	d1eff0ef          	jal	80001330 <sleep>
  while(ticks - ticks0 < n){
    80001e16:	409c                	lw	a5,0(s1)
    80001e18:	412787bb          	subw	a5,a5,s2
    80001e1c:	fcc42703          	lw	a4,-52(s0)
    80001e20:	fee7e2e3          	bltu	a5,a4,80001e04 <sys_sleep+0x4a>
    80001e24:	74a2                	ld	s1,40(sp)
    80001e26:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e28:	0000e517          	auipc	a0,0xe
    80001e2c:	61850513          	addi	a0,a0,1560 # 80010440 <tickslock>
    80001e30:	239030ef          	jal	80005868 <release>
  return 0;
    80001e34:	4501                	li	a0,0
}
    80001e36:	70e2                	ld	ra,56(sp)
    80001e38:	7442                	ld	s0,48(sp)
    80001e3a:	7902                	ld	s2,32(sp)
    80001e3c:	6121                	addi	sp,sp,64
    80001e3e:	8082                	ret
    n = 0;
    80001e40:	fc042623          	sw	zero,-52(s0)
    80001e44:	bf49                	j	80001dd6 <sys_sleep+0x1c>
      release(&tickslock);
    80001e46:	0000e517          	auipc	a0,0xe
    80001e4a:	5fa50513          	addi	a0,a0,1530 # 80010440 <tickslock>
    80001e4e:	21b030ef          	jal	80005868 <release>
      return -1;
    80001e52:	557d                	li	a0,-1
    80001e54:	74a2                	ld	s1,40(sp)
    80001e56:	69e2                	ld	s3,24(sp)
    80001e58:	bff9                	j	80001e36 <sys_sleep+0x7c>

0000000080001e5a <sys_kill>:

uint64
sys_kill(void)
{
    80001e5a:	1101                	addi	sp,sp,-32
    80001e5c:	ec06                	sd	ra,24(sp)
    80001e5e:	e822                	sd	s0,16(sp)
    80001e60:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e62:	fec40593          	addi	a1,s0,-20
    80001e66:	4501                	li	a0,0
    80001e68:	dafff0ef          	jal	80001c16 <argint>
  return kill(pid);
    80001e6c:	fec42503          	lw	a0,-20(s0)
    80001e70:	e6eff0ef          	jal	800014de <kill>
}
    80001e74:	60e2                	ld	ra,24(sp)
    80001e76:	6442                	ld	s0,16(sp)
    80001e78:	6105                	addi	sp,sp,32
    80001e7a:	8082                	ret

0000000080001e7c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e7c:	1101                	addi	sp,sp,-32
    80001e7e:	ec06                	sd	ra,24(sp)
    80001e80:	e822                	sd	s0,16(sp)
    80001e82:	e426                	sd	s1,8(sp)
    80001e84:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e86:	0000e517          	auipc	a0,0xe
    80001e8a:	5ba50513          	addi	a0,a0,1466 # 80010440 <tickslock>
    80001e8e:	143030ef          	jal	800057d0 <acquire>
  xticks = ticks;
    80001e92:	00008497          	auipc	s1,0x8
    80001e96:	5464a483          	lw	s1,1350(s1) # 8000a3d8 <ticks>
  release(&tickslock);
    80001e9a:	0000e517          	auipc	a0,0xe
    80001e9e:	5a650513          	addi	a0,a0,1446 # 80010440 <tickslock>
    80001ea2:	1c7030ef          	jal	80005868 <release>
  return xticks;
}
    80001ea6:	02049513          	slli	a0,s1,0x20
    80001eaa:	9101                	srli	a0,a0,0x20
    80001eac:	60e2                	ld	ra,24(sp)
    80001eae:	6442                	ld	s0,16(sp)
    80001eb0:	64a2                	ld	s1,8(sp)
    80001eb2:	6105                	addi	sp,sp,32
    80001eb4:	8082                	ret

0000000080001eb6 <sys_explode>:
  return 0;
}
*/

uint64
sys_explode(void) {
    80001eb6:	7119                	addi	sp,sp,-128
    80001eb8:	fc86                	sd	ra,120(sp)
    80001eba:	f8a2                	sd	s0,112(sp)
    80001ebc:	0100                	addi	s0,sp,128
  char *s;
  char buf[100];
  argaddr(0, (uint64*)&s);
    80001ebe:	fe840593          	addi	a1,s0,-24
    80001ec2:	4501                	li	a0,0
    80001ec4:	d6fff0ef          	jal	80001c32 <argaddr>

  if(copyinstr(myproc()->pagetable, buf, (uint64)s, sizeof(buf)) < 0)
    80001ec8:	e8ffe0ef          	jal	80000d56 <myproc>
    80001ecc:	06400693          	li	a3,100
    80001ed0:	fe843603          	ld	a2,-24(s0)
    80001ed4:	f8040593          	addi	a1,s0,-128
    80001ed8:	6928                	ld	a0,80(a0)
    80001eda:	c4bfe0ef          	jal	80000b24 <copyinstr>
    return -1;
    80001ede:	57fd                	li	a5,-1
  if(copyinstr(myproc()->pagetable, buf, (uint64)s, sizeof(buf)) < 0)
    80001ee0:	00054b63          	bltz	a0,80001ef6 <sys_explode+0x40>

  printf("%s\n", buf);
    80001ee4:	f8040593          	addi	a1,s0,-128
    80001ee8:	00005517          	auipc	a0,0x5
    80001eec:	5b850513          	addi	a0,a0,1464 # 800074a0 <etext+0x4a0>
    80001ef0:	2e0030ef          	jal	800051d0 <printf>
  return 0;
    80001ef4:	4781                	li	a5,0
}
    80001ef6:	853e                	mv	a0,a5
    80001ef8:	70e6                	ld	ra,120(sp)
    80001efa:	7446                	ld	s0,112(sp)
    80001efc:	6109                	addi	sp,sp,128
    80001efe:	8082                	ret

0000000080001f00 <sys_trace>:


uint64
sys_trace(void)
{
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	1000                	addi	s0,sp,32
  int mask;
  
  argint(0, &mask);
    80001f08:	fec40593          	addi	a1,s0,-20
    80001f0c:	4501                	li	a0,0
    80001f0e:	d09ff0ef          	jal	80001c16 <argint>
  
  // Validação opcional: verificar se a máscara é válida
  if(mask < 0) {
    80001f12:	fec42783          	lw	a5,-20(s0)
    return -1;
    80001f16:	557d                	li	a0,-1
  if(mask < 0) {
    80001f18:	0007c963          	bltz	a5,80001f2a <sys_trace+0x2a>
  }
  
  myproc()->trace_mask = mask;
    80001f1c:	e3bfe0ef          	jal	80000d56 <myproc>
    80001f20:	fec42783          	lw	a5,-20(s0)
    80001f24:	16f52423          	sw	a5,360(a0)
  return 0;
    80001f28:	4501                	li	a0,0
    80001f2a:	60e2                	ld	ra,24(sp)
    80001f2c:	6442                	ld	s0,16(sp)
    80001f2e:	6105                	addi	sp,sp,32
    80001f30:	8082                	ret

0000000080001f32 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f32:	7179                	addi	sp,sp,-48
    80001f34:	f406                	sd	ra,40(sp)
    80001f36:	f022                	sd	s0,32(sp)
    80001f38:	ec26                	sd	s1,24(sp)
    80001f3a:	e84a                	sd	s2,16(sp)
    80001f3c:	e44e                	sd	s3,8(sp)
    80001f3e:	e052                	sd	s4,0(sp)
    80001f40:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f42:	00005597          	auipc	a1,0x5
    80001f46:	56658593          	addi	a1,a1,1382 # 800074a8 <etext+0x4a8>
    80001f4a:	0000e517          	auipc	a0,0xe
    80001f4e:	50e50513          	addi	a0,a0,1294 # 80010458 <bcache>
    80001f52:	7fe030ef          	jal	80005750 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f56:	00016797          	auipc	a5,0x16
    80001f5a:	50278793          	addi	a5,a5,1282 # 80018458 <bcache+0x8000>
    80001f5e:	00016717          	auipc	a4,0x16
    80001f62:	76270713          	addi	a4,a4,1890 # 800186c0 <bcache+0x8268>
    80001f66:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f6a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f6e:	0000e497          	auipc	s1,0xe
    80001f72:	50248493          	addi	s1,s1,1282 # 80010470 <bcache+0x18>
    b->next = bcache.head.next;
    80001f76:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f78:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f7a:	00005a17          	auipc	s4,0x5
    80001f7e:	536a0a13          	addi	s4,s4,1334 # 800074b0 <etext+0x4b0>
    b->next = bcache.head.next;
    80001f82:	2b893783          	ld	a5,696(s2)
    80001f86:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f88:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f8c:	85d2                	mv	a1,s4
    80001f8e:	01048513          	addi	a0,s1,16
    80001f92:	248010ef          	jal	800031da <initsleeplock>
    bcache.head.next->prev = b;
    80001f96:	2b893783          	ld	a5,696(s2)
    80001f9a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001f9c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fa0:	45848493          	addi	s1,s1,1112
    80001fa4:	fd349fe3          	bne	s1,s3,80001f82 <binit+0x50>
  }
}
    80001fa8:	70a2                	ld	ra,40(sp)
    80001faa:	7402                	ld	s0,32(sp)
    80001fac:	64e2                	ld	s1,24(sp)
    80001fae:	6942                	ld	s2,16(sp)
    80001fb0:	69a2                	ld	s3,8(sp)
    80001fb2:	6a02                	ld	s4,0(sp)
    80001fb4:	6145                	addi	sp,sp,48
    80001fb6:	8082                	ret

0000000080001fb8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fb8:	7179                	addi	sp,sp,-48
    80001fba:	f406                	sd	ra,40(sp)
    80001fbc:	f022                	sd	s0,32(sp)
    80001fbe:	ec26                	sd	s1,24(sp)
    80001fc0:	e84a                	sd	s2,16(sp)
    80001fc2:	e44e                	sd	s3,8(sp)
    80001fc4:	1800                	addi	s0,sp,48
    80001fc6:	892a                	mv	s2,a0
    80001fc8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fca:	0000e517          	auipc	a0,0xe
    80001fce:	48e50513          	addi	a0,a0,1166 # 80010458 <bcache>
    80001fd2:	7fe030ef          	jal	800057d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001fd6:	00016497          	auipc	s1,0x16
    80001fda:	73a4b483          	ld	s1,1850(s1) # 80018710 <bcache+0x82b8>
    80001fde:	00016797          	auipc	a5,0x16
    80001fe2:	6e278793          	addi	a5,a5,1762 # 800186c0 <bcache+0x8268>
    80001fe6:	02f48b63          	beq	s1,a5,8000201c <bread+0x64>
    80001fea:	873e                	mv	a4,a5
    80001fec:	a021                	j	80001ff4 <bread+0x3c>
    80001fee:	68a4                	ld	s1,80(s1)
    80001ff0:	02e48663          	beq	s1,a4,8000201c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001ff4:	449c                	lw	a5,8(s1)
    80001ff6:	ff279ce3          	bne	a5,s2,80001fee <bread+0x36>
    80001ffa:	44dc                	lw	a5,12(s1)
    80001ffc:	ff3799e3          	bne	a5,s3,80001fee <bread+0x36>
      b->refcnt++;
    80002000:	40bc                	lw	a5,64(s1)
    80002002:	2785                	addiw	a5,a5,1
    80002004:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002006:	0000e517          	auipc	a0,0xe
    8000200a:	45250513          	addi	a0,a0,1106 # 80010458 <bcache>
    8000200e:	05b030ef          	jal	80005868 <release>
      acquiresleep(&b->lock);
    80002012:	01048513          	addi	a0,s1,16
    80002016:	1fa010ef          	jal	80003210 <acquiresleep>
      return b;
    8000201a:	a889                	j	8000206c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000201c:	00016497          	auipc	s1,0x16
    80002020:	6ec4b483          	ld	s1,1772(s1) # 80018708 <bcache+0x82b0>
    80002024:	00016797          	auipc	a5,0x16
    80002028:	69c78793          	addi	a5,a5,1692 # 800186c0 <bcache+0x8268>
    8000202c:	00f48863          	beq	s1,a5,8000203c <bread+0x84>
    80002030:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002032:	40bc                	lw	a5,64(s1)
    80002034:	cb91                	beqz	a5,80002048 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002036:	64a4                	ld	s1,72(s1)
    80002038:	fee49de3          	bne	s1,a4,80002032 <bread+0x7a>
  panic("bget: no buffers");
    8000203c:	00005517          	auipc	a0,0x5
    80002040:	47c50513          	addi	a0,a0,1148 # 800074b8 <etext+0x4b8>
    80002044:	45e030ef          	jal	800054a2 <panic>
      b->dev = dev;
    80002048:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000204c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002050:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002054:	4785                	li	a5,1
    80002056:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002058:	0000e517          	auipc	a0,0xe
    8000205c:	40050513          	addi	a0,a0,1024 # 80010458 <bcache>
    80002060:	009030ef          	jal	80005868 <release>
      acquiresleep(&b->lock);
    80002064:	01048513          	addi	a0,s1,16
    80002068:	1a8010ef          	jal	80003210 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000206c:	409c                	lw	a5,0(s1)
    8000206e:	cb89                	beqz	a5,80002080 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002070:	8526                	mv	a0,s1
    80002072:	70a2                	ld	ra,40(sp)
    80002074:	7402                	ld	s0,32(sp)
    80002076:	64e2                	ld	s1,24(sp)
    80002078:	6942                	ld	s2,16(sp)
    8000207a:	69a2                	ld	s3,8(sp)
    8000207c:	6145                	addi	sp,sp,48
    8000207e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002080:	4581                	li	a1,0
    80002082:	8526                	mv	a0,s1
    80002084:	1ed020ef          	jal	80004a70 <virtio_disk_rw>
    b->valid = 1;
    80002088:	4785                	li	a5,1
    8000208a:	c09c                	sw	a5,0(s1)
  return b;
    8000208c:	b7d5                	j	80002070 <bread+0xb8>

000000008000208e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000208e:	1101                	addi	sp,sp,-32
    80002090:	ec06                	sd	ra,24(sp)
    80002092:	e822                	sd	s0,16(sp)
    80002094:	e426                	sd	s1,8(sp)
    80002096:	1000                	addi	s0,sp,32
    80002098:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000209a:	0541                	addi	a0,a0,16
    8000209c:	1f2010ef          	jal	8000328e <holdingsleep>
    800020a0:	c911                	beqz	a0,800020b4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020a2:	4585                	li	a1,1
    800020a4:	8526                	mv	a0,s1
    800020a6:	1cb020ef          	jal	80004a70 <virtio_disk_rw>
}
    800020aa:	60e2                	ld	ra,24(sp)
    800020ac:	6442                	ld	s0,16(sp)
    800020ae:	64a2                	ld	s1,8(sp)
    800020b0:	6105                	addi	sp,sp,32
    800020b2:	8082                	ret
    panic("bwrite");
    800020b4:	00005517          	auipc	a0,0x5
    800020b8:	41c50513          	addi	a0,a0,1052 # 800074d0 <etext+0x4d0>
    800020bc:	3e6030ef          	jal	800054a2 <panic>

00000000800020c0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	e426                	sd	s1,8(sp)
    800020c8:	e04a                	sd	s2,0(sp)
    800020ca:	1000                	addi	s0,sp,32
    800020cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020ce:	01050913          	addi	s2,a0,16
    800020d2:	854a                	mv	a0,s2
    800020d4:	1ba010ef          	jal	8000328e <holdingsleep>
    800020d8:	c135                	beqz	a0,8000213c <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800020da:	854a                	mv	a0,s2
    800020dc:	17a010ef          	jal	80003256 <releasesleep>

  acquire(&bcache.lock);
    800020e0:	0000e517          	auipc	a0,0xe
    800020e4:	37850513          	addi	a0,a0,888 # 80010458 <bcache>
    800020e8:	6e8030ef          	jal	800057d0 <acquire>
  b->refcnt--;
    800020ec:	40bc                	lw	a5,64(s1)
    800020ee:	37fd                	addiw	a5,a5,-1
    800020f0:	0007871b          	sext.w	a4,a5
    800020f4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800020f6:	e71d                	bnez	a4,80002124 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800020f8:	68b8                	ld	a4,80(s1)
    800020fa:	64bc                	ld	a5,72(s1)
    800020fc:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800020fe:	68b8                	ld	a4,80(s1)
    80002100:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002102:	00016797          	auipc	a5,0x16
    80002106:	35678793          	addi	a5,a5,854 # 80018458 <bcache+0x8000>
    8000210a:	2b87b703          	ld	a4,696(a5)
    8000210e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002110:	00016717          	auipc	a4,0x16
    80002114:	5b070713          	addi	a4,a4,1456 # 800186c0 <bcache+0x8268>
    80002118:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000211a:	2b87b703          	ld	a4,696(a5)
    8000211e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002120:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002124:	0000e517          	auipc	a0,0xe
    80002128:	33450513          	addi	a0,a0,820 # 80010458 <bcache>
    8000212c:	73c030ef          	jal	80005868 <release>
}
    80002130:	60e2                	ld	ra,24(sp)
    80002132:	6442                	ld	s0,16(sp)
    80002134:	64a2                	ld	s1,8(sp)
    80002136:	6902                	ld	s2,0(sp)
    80002138:	6105                	addi	sp,sp,32
    8000213a:	8082                	ret
    panic("brelse");
    8000213c:	00005517          	auipc	a0,0x5
    80002140:	39c50513          	addi	a0,a0,924 # 800074d8 <etext+0x4d8>
    80002144:	35e030ef          	jal	800054a2 <panic>

0000000080002148 <bpin>:

void
bpin(struct buf *b) {
    80002148:	1101                	addi	sp,sp,-32
    8000214a:	ec06                	sd	ra,24(sp)
    8000214c:	e822                	sd	s0,16(sp)
    8000214e:	e426                	sd	s1,8(sp)
    80002150:	1000                	addi	s0,sp,32
    80002152:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002154:	0000e517          	auipc	a0,0xe
    80002158:	30450513          	addi	a0,a0,772 # 80010458 <bcache>
    8000215c:	674030ef          	jal	800057d0 <acquire>
  b->refcnt++;
    80002160:	40bc                	lw	a5,64(s1)
    80002162:	2785                	addiw	a5,a5,1
    80002164:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002166:	0000e517          	auipc	a0,0xe
    8000216a:	2f250513          	addi	a0,a0,754 # 80010458 <bcache>
    8000216e:	6fa030ef          	jal	80005868 <release>
}
    80002172:	60e2                	ld	ra,24(sp)
    80002174:	6442                	ld	s0,16(sp)
    80002176:	64a2                	ld	s1,8(sp)
    80002178:	6105                	addi	sp,sp,32
    8000217a:	8082                	ret

000000008000217c <bunpin>:

void
bunpin(struct buf *b) {
    8000217c:	1101                	addi	sp,sp,-32
    8000217e:	ec06                	sd	ra,24(sp)
    80002180:	e822                	sd	s0,16(sp)
    80002182:	e426                	sd	s1,8(sp)
    80002184:	1000                	addi	s0,sp,32
    80002186:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002188:	0000e517          	auipc	a0,0xe
    8000218c:	2d050513          	addi	a0,a0,720 # 80010458 <bcache>
    80002190:	640030ef          	jal	800057d0 <acquire>
  b->refcnt--;
    80002194:	40bc                	lw	a5,64(s1)
    80002196:	37fd                	addiw	a5,a5,-1
    80002198:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000219a:	0000e517          	auipc	a0,0xe
    8000219e:	2be50513          	addi	a0,a0,702 # 80010458 <bcache>
    800021a2:	6c6030ef          	jal	80005868 <release>
}
    800021a6:	60e2                	ld	ra,24(sp)
    800021a8:	6442                	ld	s0,16(sp)
    800021aa:	64a2                	ld	s1,8(sp)
    800021ac:	6105                	addi	sp,sp,32
    800021ae:	8082                	ret

00000000800021b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021b0:	1101                	addi	sp,sp,-32
    800021b2:	ec06                	sd	ra,24(sp)
    800021b4:	e822                	sd	s0,16(sp)
    800021b6:	e426                	sd	s1,8(sp)
    800021b8:	e04a                	sd	s2,0(sp)
    800021ba:	1000                	addi	s0,sp,32
    800021bc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021be:	00d5d59b          	srliw	a1,a1,0xd
    800021c2:	00017797          	auipc	a5,0x17
    800021c6:	9727a783          	lw	a5,-1678(a5) # 80018b34 <sb+0x1c>
    800021ca:	9dbd                	addw	a1,a1,a5
    800021cc:	dedff0ef          	jal	80001fb8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021d0:	0074f713          	andi	a4,s1,7
    800021d4:	4785                	li	a5,1
    800021d6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800021da:	14ce                	slli	s1,s1,0x33
    800021dc:	90d9                	srli	s1,s1,0x36
    800021de:	00950733          	add	a4,a0,s1
    800021e2:	05874703          	lbu	a4,88(a4)
    800021e6:	00e7f6b3          	and	a3,a5,a4
    800021ea:	c29d                	beqz	a3,80002210 <bfree+0x60>
    800021ec:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800021ee:	94aa                	add	s1,s1,a0
    800021f0:	fff7c793          	not	a5,a5
    800021f4:	8f7d                	and	a4,a4,a5
    800021f6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800021fa:	711000ef          	jal	8000310a <log_write>
  brelse(bp);
    800021fe:	854a                	mv	a0,s2
    80002200:	ec1ff0ef          	jal	800020c0 <brelse>
}
    80002204:	60e2                	ld	ra,24(sp)
    80002206:	6442                	ld	s0,16(sp)
    80002208:	64a2                	ld	s1,8(sp)
    8000220a:	6902                	ld	s2,0(sp)
    8000220c:	6105                	addi	sp,sp,32
    8000220e:	8082                	ret
    panic("freeing free block");
    80002210:	00005517          	auipc	a0,0x5
    80002214:	2d050513          	addi	a0,a0,720 # 800074e0 <etext+0x4e0>
    80002218:	28a030ef          	jal	800054a2 <panic>

000000008000221c <balloc>:
{
    8000221c:	711d                	addi	sp,sp,-96
    8000221e:	ec86                	sd	ra,88(sp)
    80002220:	e8a2                	sd	s0,80(sp)
    80002222:	e4a6                	sd	s1,72(sp)
    80002224:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002226:	00017797          	auipc	a5,0x17
    8000222a:	8f67a783          	lw	a5,-1802(a5) # 80018b1c <sb+0x4>
    8000222e:	0e078f63          	beqz	a5,8000232c <balloc+0x110>
    80002232:	e0ca                	sd	s2,64(sp)
    80002234:	fc4e                	sd	s3,56(sp)
    80002236:	f852                	sd	s4,48(sp)
    80002238:	f456                	sd	s5,40(sp)
    8000223a:	f05a                	sd	s6,32(sp)
    8000223c:	ec5e                	sd	s7,24(sp)
    8000223e:	e862                	sd	s8,16(sp)
    80002240:	e466                	sd	s9,8(sp)
    80002242:	8baa                	mv	s7,a0
    80002244:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002246:	00017b17          	auipc	s6,0x17
    8000224a:	8d2b0b13          	addi	s6,s6,-1838 # 80018b18 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000224e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002250:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002252:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002254:	6c89                	lui	s9,0x2
    80002256:	a0b5                	j	800022c2 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002258:	97ca                	add	a5,a5,s2
    8000225a:	8e55                	or	a2,a2,a3
    8000225c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002260:	854a                	mv	a0,s2
    80002262:	6a9000ef          	jal	8000310a <log_write>
        brelse(bp);
    80002266:	854a                	mv	a0,s2
    80002268:	e59ff0ef          	jal	800020c0 <brelse>
  bp = bread(dev, bno);
    8000226c:	85a6                	mv	a1,s1
    8000226e:	855e                	mv	a0,s7
    80002270:	d49ff0ef          	jal	80001fb8 <bread>
    80002274:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002276:	40000613          	li	a2,1024
    8000227a:	4581                	li	a1,0
    8000227c:	05850513          	addi	a0,a0,88
    80002280:	eb5fd0ef          	jal	80000134 <memset>
  log_write(bp);
    80002284:	854a                	mv	a0,s2
    80002286:	685000ef          	jal	8000310a <log_write>
  brelse(bp);
    8000228a:	854a                	mv	a0,s2
    8000228c:	e35ff0ef          	jal	800020c0 <brelse>
}
    80002290:	6906                	ld	s2,64(sp)
    80002292:	79e2                	ld	s3,56(sp)
    80002294:	7a42                	ld	s4,48(sp)
    80002296:	7aa2                	ld	s5,40(sp)
    80002298:	7b02                	ld	s6,32(sp)
    8000229a:	6be2                	ld	s7,24(sp)
    8000229c:	6c42                	ld	s8,16(sp)
    8000229e:	6ca2                	ld	s9,8(sp)
}
    800022a0:	8526                	mv	a0,s1
    800022a2:	60e6                	ld	ra,88(sp)
    800022a4:	6446                	ld	s0,80(sp)
    800022a6:	64a6                	ld	s1,72(sp)
    800022a8:	6125                	addi	sp,sp,96
    800022aa:	8082                	ret
    brelse(bp);
    800022ac:	854a                	mv	a0,s2
    800022ae:	e13ff0ef          	jal	800020c0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022b2:	015c87bb          	addw	a5,s9,s5
    800022b6:	00078a9b          	sext.w	s5,a5
    800022ba:	004b2703          	lw	a4,4(s6)
    800022be:	04eaff63          	bgeu	s5,a4,8000231c <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800022c2:	41fad79b          	sraiw	a5,s5,0x1f
    800022c6:	0137d79b          	srliw	a5,a5,0x13
    800022ca:	015787bb          	addw	a5,a5,s5
    800022ce:	40d7d79b          	sraiw	a5,a5,0xd
    800022d2:	01cb2583          	lw	a1,28(s6)
    800022d6:	9dbd                	addw	a1,a1,a5
    800022d8:	855e                	mv	a0,s7
    800022da:	cdfff0ef          	jal	80001fb8 <bread>
    800022de:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022e0:	004b2503          	lw	a0,4(s6)
    800022e4:	000a849b          	sext.w	s1,s5
    800022e8:	8762                	mv	a4,s8
    800022ea:	fca4f1e3          	bgeu	s1,a0,800022ac <balloc+0x90>
      m = 1 << (bi % 8);
    800022ee:	00777693          	andi	a3,a4,7
    800022f2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800022f6:	41f7579b          	sraiw	a5,a4,0x1f
    800022fa:	01d7d79b          	srliw	a5,a5,0x1d
    800022fe:	9fb9                	addw	a5,a5,a4
    80002300:	4037d79b          	sraiw	a5,a5,0x3
    80002304:	00f90633          	add	a2,s2,a5
    80002308:	05864603          	lbu	a2,88(a2)
    8000230c:	00c6f5b3          	and	a1,a3,a2
    80002310:	d5a1                	beqz	a1,80002258 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002312:	2705                	addiw	a4,a4,1
    80002314:	2485                	addiw	s1,s1,1
    80002316:	fd471ae3          	bne	a4,s4,800022ea <balloc+0xce>
    8000231a:	bf49                	j	800022ac <balloc+0x90>
    8000231c:	6906                	ld	s2,64(sp)
    8000231e:	79e2                	ld	s3,56(sp)
    80002320:	7a42                	ld	s4,48(sp)
    80002322:	7aa2                	ld	s5,40(sp)
    80002324:	7b02                	ld	s6,32(sp)
    80002326:	6be2                	ld	s7,24(sp)
    80002328:	6c42                	ld	s8,16(sp)
    8000232a:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000232c:	00005517          	auipc	a0,0x5
    80002330:	1cc50513          	addi	a0,a0,460 # 800074f8 <etext+0x4f8>
    80002334:	69d020ef          	jal	800051d0 <printf>
  return 0;
    80002338:	4481                	li	s1,0
    8000233a:	b79d                	j	800022a0 <balloc+0x84>

000000008000233c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000233c:	7179                	addi	sp,sp,-48
    8000233e:	f406                	sd	ra,40(sp)
    80002340:	f022                	sd	s0,32(sp)
    80002342:	ec26                	sd	s1,24(sp)
    80002344:	e84a                	sd	s2,16(sp)
    80002346:	e44e                	sd	s3,8(sp)
    80002348:	1800                	addi	s0,sp,48
    8000234a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000234c:	47ad                	li	a5,11
    8000234e:	02b7e663          	bltu	a5,a1,8000237a <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002352:	02059793          	slli	a5,a1,0x20
    80002356:	01e7d593          	srli	a1,a5,0x1e
    8000235a:	00b504b3          	add	s1,a0,a1
    8000235e:	0504a903          	lw	s2,80(s1)
    80002362:	06091a63          	bnez	s2,800023d6 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002366:	4108                	lw	a0,0(a0)
    80002368:	eb5ff0ef          	jal	8000221c <balloc>
    8000236c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002370:	06090363          	beqz	s2,800023d6 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002374:	0524a823          	sw	s2,80(s1)
    80002378:	a8b9                	j	800023d6 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000237a:	ff45849b          	addiw	s1,a1,-12
    8000237e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002382:	0ff00793          	li	a5,255
    80002386:	06e7ee63          	bltu	a5,a4,80002402 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000238a:	08052903          	lw	s2,128(a0)
    8000238e:	00091d63          	bnez	s2,800023a8 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002392:	4108                	lw	a0,0(a0)
    80002394:	e89ff0ef          	jal	8000221c <balloc>
    80002398:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000239c:	02090d63          	beqz	s2,800023d6 <bmap+0x9a>
    800023a0:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023a2:	0929a023          	sw	s2,128(s3)
    800023a6:	a011                	j	800023aa <bmap+0x6e>
    800023a8:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023aa:	85ca                	mv	a1,s2
    800023ac:	0009a503          	lw	a0,0(s3)
    800023b0:	c09ff0ef          	jal	80001fb8 <bread>
    800023b4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023b6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023ba:	02049713          	slli	a4,s1,0x20
    800023be:	01e75593          	srli	a1,a4,0x1e
    800023c2:	00b784b3          	add	s1,a5,a1
    800023c6:	0004a903          	lw	s2,0(s1)
    800023ca:	00090e63          	beqz	s2,800023e6 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023ce:	8552                	mv	a0,s4
    800023d0:	cf1ff0ef          	jal	800020c0 <brelse>
    return addr;
    800023d4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023d6:	854a                	mv	a0,s2
    800023d8:	70a2                	ld	ra,40(sp)
    800023da:	7402                	ld	s0,32(sp)
    800023dc:	64e2                	ld	s1,24(sp)
    800023de:	6942                	ld	s2,16(sp)
    800023e0:	69a2                	ld	s3,8(sp)
    800023e2:	6145                	addi	sp,sp,48
    800023e4:	8082                	ret
      addr = balloc(ip->dev);
    800023e6:	0009a503          	lw	a0,0(s3)
    800023ea:	e33ff0ef          	jal	8000221c <balloc>
    800023ee:	0005091b          	sext.w	s2,a0
      if(addr){
    800023f2:	fc090ee3          	beqz	s2,800023ce <bmap+0x92>
        a[bn] = addr;
    800023f6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800023fa:	8552                	mv	a0,s4
    800023fc:	50f000ef          	jal	8000310a <log_write>
    80002400:	b7f9                	j	800023ce <bmap+0x92>
    80002402:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002404:	00005517          	auipc	a0,0x5
    80002408:	10c50513          	addi	a0,a0,268 # 80007510 <etext+0x510>
    8000240c:	096030ef          	jal	800054a2 <panic>

0000000080002410 <iget>:
{
    80002410:	7179                	addi	sp,sp,-48
    80002412:	f406                	sd	ra,40(sp)
    80002414:	f022                	sd	s0,32(sp)
    80002416:	ec26                	sd	s1,24(sp)
    80002418:	e84a                	sd	s2,16(sp)
    8000241a:	e44e                	sd	s3,8(sp)
    8000241c:	e052                	sd	s4,0(sp)
    8000241e:	1800                	addi	s0,sp,48
    80002420:	89aa                	mv	s3,a0
    80002422:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002424:	00016517          	auipc	a0,0x16
    80002428:	71450513          	addi	a0,a0,1812 # 80018b38 <itable>
    8000242c:	3a4030ef          	jal	800057d0 <acquire>
  empty = 0;
    80002430:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002432:	00016497          	auipc	s1,0x16
    80002436:	71e48493          	addi	s1,s1,1822 # 80018b50 <itable+0x18>
    8000243a:	00018697          	auipc	a3,0x18
    8000243e:	1a668693          	addi	a3,a3,422 # 8001a5e0 <log>
    80002442:	a039                	j	80002450 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002444:	02090963          	beqz	s2,80002476 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002448:	08848493          	addi	s1,s1,136
    8000244c:	02d48863          	beq	s1,a3,8000247c <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002450:	449c                	lw	a5,8(s1)
    80002452:	fef059e3          	blez	a5,80002444 <iget+0x34>
    80002456:	4098                	lw	a4,0(s1)
    80002458:	ff3716e3          	bne	a4,s3,80002444 <iget+0x34>
    8000245c:	40d8                	lw	a4,4(s1)
    8000245e:	ff4713e3          	bne	a4,s4,80002444 <iget+0x34>
      ip->ref++;
    80002462:	2785                	addiw	a5,a5,1
    80002464:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002466:	00016517          	auipc	a0,0x16
    8000246a:	6d250513          	addi	a0,a0,1746 # 80018b38 <itable>
    8000246e:	3fa030ef          	jal	80005868 <release>
      return ip;
    80002472:	8926                	mv	s2,s1
    80002474:	a02d                	j	8000249e <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002476:	fbe9                	bnez	a5,80002448 <iget+0x38>
      empty = ip;
    80002478:	8926                	mv	s2,s1
    8000247a:	b7f9                	j	80002448 <iget+0x38>
  if(empty == 0)
    8000247c:	02090a63          	beqz	s2,800024b0 <iget+0xa0>
  ip->dev = dev;
    80002480:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002484:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002488:	4785                	li	a5,1
    8000248a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000248e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002492:	00016517          	auipc	a0,0x16
    80002496:	6a650513          	addi	a0,a0,1702 # 80018b38 <itable>
    8000249a:	3ce030ef          	jal	80005868 <release>
}
    8000249e:	854a                	mv	a0,s2
    800024a0:	70a2                	ld	ra,40(sp)
    800024a2:	7402                	ld	s0,32(sp)
    800024a4:	64e2                	ld	s1,24(sp)
    800024a6:	6942                	ld	s2,16(sp)
    800024a8:	69a2                	ld	s3,8(sp)
    800024aa:	6a02                	ld	s4,0(sp)
    800024ac:	6145                	addi	sp,sp,48
    800024ae:	8082                	ret
    panic("iget: no inodes");
    800024b0:	00005517          	auipc	a0,0x5
    800024b4:	07850513          	addi	a0,a0,120 # 80007528 <etext+0x528>
    800024b8:	7eb020ef          	jal	800054a2 <panic>

00000000800024bc <fsinit>:
fsinit(int dev) {
    800024bc:	7179                	addi	sp,sp,-48
    800024be:	f406                	sd	ra,40(sp)
    800024c0:	f022                	sd	s0,32(sp)
    800024c2:	ec26                	sd	s1,24(sp)
    800024c4:	e84a                	sd	s2,16(sp)
    800024c6:	e44e                	sd	s3,8(sp)
    800024c8:	1800                	addi	s0,sp,48
    800024ca:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800024cc:	4585                	li	a1,1
    800024ce:	aebff0ef          	jal	80001fb8 <bread>
    800024d2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800024d4:	00016997          	auipc	s3,0x16
    800024d8:	64498993          	addi	s3,s3,1604 # 80018b18 <sb>
    800024dc:	02000613          	li	a2,32
    800024e0:	05850593          	addi	a1,a0,88
    800024e4:	854e                	mv	a0,s3
    800024e6:	cabfd0ef          	jal	80000190 <memmove>
  brelse(bp);
    800024ea:	8526                	mv	a0,s1
    800024ec:	bd5ff0ef          	jal	800020c0 <brelse>
  if(sb.magic != FSMAGIC)
    800024f0:	0009a703          	lw	a4,0(s3)
    800024f4:	102037b7          	lui	a5,0x10203
    800024f8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800024fc:	02f71063          	bne	a4,a5,8000251c <fsinit+0x60>
  initlog(dev, &sb);
    80002500:	00016597          	auipc	a1,0x16
    80002504:	61858593          	addi	a1,a1,1560 # 80018b18 <sb>
    80002508:	854a                	mv	a0,s2
    8000250a:	1f9000ef          	jal	80002f02 <initlog>
}
    8000250e:	70a2                	ld	ra,40(sp)
    80002510:	7402                	ld	s0,32(sp)
    80002512:	64e2                	ld	s1,24(sp)
    80002514:	6942                	ld	s2,16(sp)
    80002516:	69a2                	ld	s3,8(sp)
    80002518:	6145                	addi	sp,sp,48
    8000251a:	8082                	ret
    panic("invalid file system");
    8000251c:	00005517          	auipc	a0,0x5
    80002520:	01c50513          	addi	a0,a0,28 # 80007538 <etext+0x538>
    80002524:	77f020ef          	jal	800054a2 <panic>

0000000080002528 <iinit>:
{
    80002528:	7179                	addi	sp,sp,-48
    8000252a:	f406                	sd	ra,40(sp)
    8000252c:	f022                	sd	s0,32(sp)
    8000252e:	ec26                	sd	s1,24(sp)
    80002530:	e84a                	sd	s2,16(sp)
    80002532:	e44e                	sd	s3,8(sp)
    80002534:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002536:	00005597          	auipc	a1,0x5
    8000253a:	01a58593          	addi	a1,a1,26 # 80007550 <etext+0x550>
    8000253e:	00016517          	auipc	a0,0x16
    80002542:	5fa50513          	addi	a0,a0,1530 # 80018b38 <itable>
    80002546:	20a030ef          	jal	80005750 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000254a:	00016497          	auipc	s1,0x16
    8000254e:	61648493          	addi	s1,s1,1558 # 80018b60 <itable+0x28>
    80002552:	00018997          	auipc	s3,0x18
    80002556:	09e98993          	addi	s3,s3,158 # 8001a5f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000255a:	00005917          	auipc	s2,0x5
    8000255e:	ffe90913          	addi	s2,s2,-2 # 80007558 <etext+0x558>
    80002562:	85ca                	mv	a1,s2
    80002564:	8526                	mv	a0,s1
    80002566:	475000ef          	jal	800031da <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000256a:	08848493          	addi	s1,s1,136
    8000256e:	ff349ae3          	bne	s1,s3,80002562 <iinit+0x3a>
}
    80002572:	70a2                	ld	ra,40(sp)
    80002574:	7402                	ld	s0,32(sp)
    80002576:	64e2                	ld	s1,24(sp)
    80002578:	6942                	ld	s2,16(sp)
    8000257a:	69a2                	ld	s3,8(sp)
    8000257c:	6145                	addi	sp,sp,48
    8000257e:	8082                	ret

0000000080002580 <ialloc>:
{
    80002580:	7139                	addi	sp,sp,-64
    80002582:	fc06                	sd	ra,56(sp)
    80002584:	f822                	sd	s0,48(sp)
    80002586:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002588:	00016717          	auipc	a4,0x16
    8000258c:	59c72703          	lw	a4,1436(a4) # 80018b24 <sb+0xc>
    80002590:	4785                	li	a5,1
    80002592:	06e7f063          	bgeu	a5,a4,800025f2 <ialloc+0x72>
    80002596:	f426                	sd	s1,40(sp)
    80002598:	f04a                	sd	s2,32(sp)
    8000259a:	ec4e                	sd	s3,24(sp)
    8000259c:	e852                	sd	s4,16(sp)
    8000259e:	e456                	sd	s5,8(sp)
    800025a0:	e05a                	sd	s6,0(sp)
    800025a2:	8aaa                	mv	s5,a0
    800025a4:	8b2e                	mv	s6,a1
    800025a6:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800025a8:	00016a17          	auipc	s4,0x16
    800025ac:	570a0a13          	addi	s4,s4,1392 # 80018b18 <sb>
    800025b0:	00495593          	srli	a1,s2,0x4
    800025b4:	018a2783          	lw	a5,24(s4)
    800025b8:	9dbd                	addw	a1,a1,a5
    800025ba:	8556                	mv	a0,s5
    800025bc:	9fdff0ef          	jal	80001fb8 <bread>
    800025c0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025c2:	05850993          	addi	s3,a0,88
    800025c6:	00f97793          	andi	a5,s2,15
    800025ca:	079a                	slli	a5,a5,0x6
    800025cc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025ce:	00099783          	lh	a5,0(s3)
    800025d2:	cb9d                	beqz	a5,80002608 <ialloc+0x88>
    brelse(bp);
    800025d4:	aedff0ef          	jal	800020c0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025d8:	0905                	addi	s2,s2,1
    800025da:	00ca2703          	lw	a4,12(s4)
    800025de:	0009079b          	sext.w	a5,s2
    800025e2:	fce7e7e3          	bltu	a5,a4,800025b0 <ialloc+0x30>
    800025e6:	74a2                	ld	s1,40(sp)
    800025e8:	7902                	ld	s2,32(sp)
    800025ea:	69e2                	ld	s3,24(sp)
    800025ec:	6a42                	ld	s4,16(sp)
    800025ee:	6aa2                	ld	s5,8(sp)
    800025f0:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025f2:	00005517          	auipc	a0,0x5
    800025f6:	f6e50513          	addi	a0,a0,-146 # 80007560 <etext+0x560>
    800025fa:	3d7020ef          	jal	800051d0 <printf>
  return 0;
    800025fe:	4501                	li	a0,0
}
    80002600:	70e2                	ld	ra,56(sp)
    80002602:	7442                	ld	s0,48(sp)
    80002604:	6121                	addi	sp,sp,64
    80002606:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002608:	04000613          	li	a2,64
    8000260c:	4581                	li	a1,0
    8000260e:	854e                	mv	a0,s3
    80002610:	b25fd0ef          	jal	80000134 <memset>
      dip->type = type;
    80002614:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002618:	8526                	mv	a0,s1
    8000261a:	2f1000ef          	jal	8000310a <log_write>
      brelse(bp);
    8000261e:	8526                	mv	a0,s1
    80002620:	aa1ff0ef          	jal	800020c0 <brelse>
      return iget(dev, inum);
    80002624:	0009059b          	sext.w	a1,s2
    80002628:	8556                	mv	a0,s5
    8000262a:	de7ff0ef          	jal	80002410 <iget>
    8000262e:	74a2                	ld	s1,40(sp)
    80002630:	7902                	ld	s2,32(sp)
    80002632:	69e2                	ld	s3,24(sp)
    80002634:	6a42                	ld	s4,16(sp)
    80002636:	6aa2                	ld	s5,8(sp)
    80002638:	6b02                	ld	s6,0(sp)
    8000263a:	b7d9                	j	80002600 <ialloc+0x80>

000000008000263c <iupdate>:
{
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	e04a                	sd	s2,0(sp)
    80002646:	1000                	addi	s0,sp,32
    80002648:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000264a:	415c                	lw	a5,4(a0)
    8000264c:	0047d79b          	srliw	a5,a5,0x4
    80002650:	00016597          	auipc	a1,0x16
    80002654:	4e05a583          	lw	a1,1248(a1) # 80018b30 <sb+0x18>
    80002658:	9dbd                	addw	a1,a1,a5
    8000265a:	4108                	lw	a0,0(a0)
    8000265c:	95dff0ef          	jal	80001fb8 <bread>
    80002660:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002662:	05850793          	addi	a5,a0,88
    80002666:	40d8                	lw	a4,4(s1)
    80002668:	8b3d                	andi	a4,a4,15
    8000266a:	071a                	slli	a4,a4,0x6
    8000266c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000266e:	04449703          	lh	a4,68(s1)
    80002672:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002676:	04649703          	lh	a4,70(s1)
    8000267a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000267e:	04849703          	lh	a4,72(s1)
    80002682:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002686:	04a49703          	lh	a4,74(s1)
    8000268a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000268e:	44f8                	lw	a4,76(s1)
    80002690:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002692:	03400613          	li	a2,52
    80002696:	05048593          	addi	a1,s1,80
    8000269a:	00c78513          	addi	a0,a5,12
    8000269e:	af3fd0ef          	jal	80000190 <memmove>
  log_write(bp);
    800026a2:	854a                	mv	a0,s2
    800026a4:	267000ef          	jal	8000310a <log_write>
  brelse(bp);
    800026a8:	854a                	mv	a0,s2
    800026aa:	a17ff0ef          	jal	800020c0 <brelse>
}
    800026ae:	60e2                	ld	ra,24(sp)
    800026b0:	6442                	ld	s0,16(sp)
    800026b2:	64a2                	ld	s1,8(sp)
    800026b4:	6902                	ld	s2,0(sp)
    800026b6:	6105                	addi	sp,sp,32
    800026b8:	8082                	ret

00000000800026ba <idup>:
{
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	1000                	addi	s0,sp,32
    800026c4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026c6:	00016517          	auipc	a0,0x16
    800026ca:	47250513          	addi	a0,a0,1138 # 80018b38 <itable>
    800026ce:	102030ef          	jal	800057d0 <acquire>
  ip->ref++;
    800026d2:	449c                	lw	a5,8(s1)
    800026d4:	2785                	addiw	a5,a5,1
    800026d6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026d8:	00016517          	auipc	a0,0x16
    800026dc:	46050513          	addi	a0,a0,1120 # 80018b38 <itable>
    800026e0:	188030ef          	jal	80005868 <release>
}
    800026e4:	8526                	mv	a0,s1
    800026e6:	60e2                	ld	ra,24(sp)
    800026e8:	6442                	ld	s0,16(sp)
    800026ea:	64a2                	ld	s1,8(sp)
    800026ec:	6105                	addi	sp,sp,32
    800026ee:	8082                	ret

00000000800026f0 <ilock>:
{
    800026f0:	1101                	addi	sp,sp,-32
    800026f2:	ec06                	sd	ra,24(sp)
    800026f4:	e822                	sd	s0,16(sp)
    800026f6:	e426                	sd	s1,8(sp)
    800026f8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026fa:	cd19                	beqz	a0,80002718 <ilock+0x28>
    800026fc:	84aa                	mv	s1,a0
    800026fe:	451c                	lw	a5,8(a0)
    80002700:	00f05c63          	blez	a5,80002718 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002704:	0541                	addi	a0,a0,16
    80002706:	30b000ef          	jal	80003210 <acquiresleep>
  if(ip->valid == 0){
    8000270a:	40bc                	lw	a5,64(s1)
    8000270c:	cf89                	beqz	a5,80002726 <ilock+0x36>
}
    8000270e:	60e2                	ld	ra,24(sp)
    80002710:	6442                	ld	s0,16(sp)
    80002712:	64a2                	ld	s1,8(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret
    80002718:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000271a:	00005517          	auipc	a0,0x5
    8000271e:	e5e50513          	addi	a0,a0,-418 # 80007578 <etext+0x578>
    80002722:	581020ef          	jal	800054a2 <panic>
    80002726:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002728:	40dc                	lw	a5,4(s1)
    8000272a:	0047d79b          	srliw	a5,a5,0x4
    8000272e:	00016597          	auipc	a1,0x16
    80002732:	4025a583          	lw	a1,1026(a1) # 80018b30 <sb+0x18>
    80002736:	9dbd                	addw	a1,a1,a5
    80002738:	4088                	lw	a0,0(s1)
    8000273a:	87fff0ef          	jal	80001fb8 <bread>
    8000273e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002740:	05850593          	addi	a1,a0,88
    80002744:	40dc                	lw	a5,4(s1)
    80002746:	8bbd                	andi	a5,a5,15
    80002748:	079a                	slli	a5,a5,0x6
    8000274a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000274c:	00059783          	lh	a5,0(a1)
    80002750:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002754:	00259783          	lh	a5,2(a1)
    80002758:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000275c:	00459783          	lh	a5,4(a1)
    80002760:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002764:	00659783          	lh	a5,6(a1)
    80002768:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000276c:	459c                	lw	a5,8(a1)
    8000276e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002770:	03400613          	li	a2,52
    80002774:	05b1                	addi	a1,a1,12
    80002776:	05048513          	addi	a0,s1,80
    8000277a:	a17fd0ef          	jal	80000190 <memmove>
    brelse(bp);
    8000277e:	854a                	mv	a0,s2
    80002780:	941ff0ef          	jal	800020c0 <brelse>
    ip->valid = 1;
    80002784:	4785                	li	a5,1
    80002786:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002788:	04449783          	lh	a5,68(s1)
    8000278c:	c399                	beqz	a5,80002792 <ilock+0xa2>
    8000278e:	6902                	ld	s2,0(sp)
    80002790:	bfbd                	j	8000270e <ilock+0x1e>
      panic("ilock: no type");
    80002792:	00005517          	auipc	a0,0x5
    80002796:	dee50513          	addi	a0,a0,-530 # 80007580 <etext+0x580>
    8000279a:	509020ef          	jal	800054a2 <panic>

000000008000279e <iunlock>:
{
    8000279e:	1101                	addi	sp,sp,-32
    800027a0:	ec06                	sd	ra,24(sp)
    800027a2:	e822                	sd	s0,16(sp)
    800027a4:	e426                	sd	s1,8(sp)
    800027a6:	e04a                	sd	s2,0(sp)
    800027a8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027aa:	c505                	beqz	a0,800027d2 <iunlock+0x34>
    800027ac:	84aa                	mv	s1,a0
    800027ae:	01050913          	addi	s2,a0,16
    800027b2:	854a                	mv	a0,s2
    800027b4:	2db000ef          	jal	8000328e <holdingsleep>
    800027b8:	cd09                	beqz	a0,800027d2 <iunlock+0x34>
    800027ba:	449c                	lw	a5,8(s1)
    800027bc:	00f05b63          	blez	a5,800027d2 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027c0:	854a                	mv	a0,s2
    800027c2:	295000ef          	jal	80003256 <releasesleep>
}
    800027c6:	60e2                	ld	ra,24(sp)
    800027c8:	6442                	ld	s0,16(sp)
    800027ca:	64a2                	ld	s1,8(sp)
    800027cc:	6902                	ld	s2,0(sp)
    800027ce:	6105                	addi	sp,sp,32
    800027d0:	8082                	ret
    panic("iunlock");
    800027d2:	00005517          	auipc	a0,0x5
    800027d6:	dbe50513          	addi	a0,a0,-578 # 80007590 <etext+0x590>
    800027da:	4c9020ef          	jal	800054a2 <panic>

00000000800027de <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027de:	7179                	addi	sp,sp,-48
    800027e0:	f406                	sd	ra,40(sp)
    800027e2:	f022                	sd	s0,32(sp)
    800027e4:	ec26                	sd	s1,24(sp)
    800027e6:	e84a                	sd	s2,16(sp)
    800027e8:	e44e                	sd	s3,8(sp)
    800027ea:	1800                	addi	s0,sp,48
    800027ec:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027ee:	05050493          	addi	s1,a0,80
    800027f2:	08050913          	addi	s2,a0,128
    800027f6:	a021                	j	800027fe <itrunc+0x20>
    800027f8:	0491                	addi	s1,s1,4
    800027fa:	01248b63          	beq	s1,s2,80002810 <itrunc+0x32>
    if(ip->addrs[i]){
    800027fe:	408c                	lw	a1,0(s1)
    80002800:	dde5                	beqz	a1,800027f8 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002802:	0009a503          	lw	a0,0(s3)
    80002806:	9abff0ef          	jal	800021b0 <bfree>
      ip->addrs[i] = 0;
    8000280a:	0004a023          	sw	zero,0(s1)
    8000280e:	b7ed                	j	800027f8 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002810:	0809a583          	lw	a1,128(s3)
    80002814:	ed89                	bnez	a1,8000282e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002816:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000281a:	854e                	mv	a0,s3
    8000281c:	e21ff0ef          	jal	8000263c <iupdate>
}
    80002820:	70a2                	ld	ra,40(sp)
    80002822:	7402                	ld	s0,32(sp)
    80002824:	64e2                	ld	s1,24(sp)
    80002826:	6942                	ld	s2,16(sp)
    80002828:	69a2                	ld	s3,8(sp)
    8000282a:	6145                	addi	sp,sp,48
    8000282c:	8082                	ret
    8000282e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002830:	0009a503          	lw	a0,0(s3)
    80002834:	f84ff0ef          	jal	80001fb8 <bread>
    80002838:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000283a:	05850493          	addi	s1,a0,88
    8000283e:	45850913          	addi	s2,a0,1112
    80002842:	a021                	j	8000284a <itrunc+0x6c>
    80002844:	0491                	addi	s1,s1,4
    80002846:	01248963          	beq	s1,s2,80002858 <itrunc+0x7a>
      if(a[j])
    8000284a:	408c                	lw	a1,0(s1)
    8000284c:	dde5                	beqz	a1,80002844 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000284e:	0009a503          	lw	a0,0(s3)
    80002852:	95fff0ef          	jal	800021b0 <bfree>
    80002856:	b7fd                	j	80002844 <itrunc+0x66>
    brelse(bp);
    80002858:	8552                	mv	a0,s4
    8000285a:	867ff0ef          	jal	800020c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000285e:	0809a583          	lw	a1,128(s3)
    80002862:	0009a503          	lw	a0,0(s3)
    80002866:	94bff0ef          	jal	800021b0 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000286a:	0809a023          	sw	zero,128(s3)
    8000286e:	6a02                	ld	s4,0(sp)
    80002870:	b75d                	j	80002816 <itrunc+0x38>

0000000080002872 <iput>:
{
    80002872:	1101                	addi	sp,sp,-32
    80002874:	ec06                	sd	ra,24(sp)
    80002876:	e822                	sd	s0,16(sp)
    80002878:	e426                	sd	s1,8(sp)
    8000287a:	1000                	addi	s0,sp,32
    8000287c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000287e:	00016517          	auipc	a0,0x16
    80002882:	2ba50513          	addi	a0,a0,698 # 80018b38 <itable>
    80002886:	74b020ef          	jal	800057d0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000288a:	4498                	lw	a4,8(s1)
    8000288c:	4785                	li	a5,1
    8000288e:	02f70063          	beq	a4,a5,800028ae <iput+0x3c>
  ip->ref--;
    80002892:	449c                	lw	a5,8(s1)
    80002894:	37fd                	addiw	a5,a5,-1
    80002896:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002898:	00016517          	auipc	a0,0x16
    8000289c:	2a050513          	addi	a0,a0,672 # 80018b38 <itable>
    800028a0:	7c9020ef          	jal	80005868 <release>
}
    800028a4:	60e2                	ld	ra,24(sp)
    800028a6:	6442                	ld	s0,16(sp)
    800028a8:	64a2                	ld	s1,8(sp)
    800028aa:	6105                	addi	sp,sp,32
    800028ac:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028ae:	40bc                	lw	a5,64(s1)
    800028b0:	d3ed                	beqz	a5,80002892 <iput+0x20>
    800028b2:	04a49783          	lh	a5,74(s1)
    800028b6:	fff1                	bnez	a5,80002892 <iput+0x20>
    800028b8:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028ba:	01048913          	addi	s2,s1,16
    800028be:	854a                	mv	a0,s2
    800028c0:	151000ef          	jal	80003210 <acquiresleep>
    release(&itable.lock);
    800028c4:	00016517          	auipc	a0,0x16
    800028c8:	27450513          	addi	a0,a0,628 # 80018b38 <itable>
    800028cc:	79d020ef          	jal	80005868 <release>
    itrunc(ip);
    800028d0:	8526                	mv	a0,s1
    800028d2:	f0dff0ef          	jal	800027de <itrunc>
    ip->type = 0;
    800028d6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028da:	8526                	mv	a0,s1
    800028dc:	d61ff0ef          	jal	8000263c <iupdate>
    ip->valid = 0;
    800028e0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028e4:	854a                	mv	a0,s2
    800028e6:	171000ef          	jal	80003256 <releasesleep>
    acquire(&itable.lock);
    800028ea:	00016517          	auipc	a0,0x16
    800028ee:	24e50513          	addi	a0,a0,590 # 80018b38 <itable>
    800028f2:	6df020ef          	jal	800057d0 <acquire>
    800028f6:	6902                	ld	s2,0(sp)
    800028f8:	bf69                	j	80002892 <iput+0x20>

00000000800028fa <iunlockput>:
{
    800028fa:	1101                	addi	sp,sp,-32
    800028fc:	ec06                	sd	ra,24(sp)
    800028fe:	e822                	sd	s0,16(sp)
    80002900:	e426                	sd	s1,8(sp)
    80002902:	1000                	addi	s0,sp,32
    80002904:	84aa                	mv	s1,a0
  iunlock(ip);
    80002906:	e99ff0ef          	jal	8000279e <iunlock>
  iput(ip);
    8000290a:	8526                	mv	a0,s1
    8000290c:	f67ff0ef          	jal	80002872 <iput>
}
    80002910:	60e2                	ld	ra,24(sp)
    80002912:	6442                	ld	s0,16(sp)
    80002914:	64a2                	ld	s1,8(sp)
    80002916:	6105                	addi	sp,sp,32
    80002918:	8082                	ret

000000008000291a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000291a:	1141                	addi	sp,sp,-16
    8000291c:	e422                	sd	s0,8(sp)
    8000291e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002920:	411c                	lw	a5,0(a0)
    80002922:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002924:	415c                	lw	a5,4(a0)
    80002926:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002928:	04451783          	lh	a5,68(a0)
    8000292c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002930:	04a51783          	lh	a5,74(a0)
    80002934:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002938:	04c56783          	lwu	a5,76(a0)
    8000293c:	e99c                	sd	a5,16(a1)
}
    8000293e:	6422                	ld	s0,8(sp)
    80002940:	0141                	addi	sp,sp,16
    80002942:	8082                	ret

0000000080002944 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002944:	457c                	lw	a5,76(a0)
    80002946:	0ed7eb63          	bltu	a5,a3,80002a3c <readi+0xf8>
{
    8000294a:	7159                	addi	sp,sp,-112
    8000294c:	f486                	sd	ra,104(sp)
    8000294e:	f0a2                	sd	s0,96(sp)
    80002950:	eca6                	sd	s1,88(sp)
    80002952:	e0d2                	sd	s4,64(sp)
    80002954:	fc56                	sd	s5,56(sp)
    80002956:	f85a                	sd	s6,48(sp)
    80002958:	f45e                	sd	s7,40(sp)
    8000295a:	1880                	addi	s0,sp,112
    8000295c:	8b2a                	mv	s6,a0
    8000295e:	8bae                	mv	s7,a1
    80002960:	8a32                	mv	s4,a2
    80002962:	84b6                	mv	s1,a3
    80002964:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002966:	9f35                	addw	a4,a4,a3
    return 0;
    80002968:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000296a:	0cd76063          	bltu	a4,a3,80002a2a <readi+0xe6>
    8000296e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002970:	00e7f463          	bgeu	a5,a4,80002978 <readi+0x34>
    n = ip->size - off;
    80002974:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002978:	080a8f63          	beqz	s5,80002a16 <readi+0xd2>
    8000297c:	e8ca                	sd	s2,80(sp)
    8000297e:	f062                	sd	s8,32(sp)
    80002980:	ec66                	sd	s9,24(sp)
    80002982:	e86a                	sd	s10,16(sp)
    80002984:	e46e                	sd	s11,8(sp)
    80002986:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002988:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000298c:	5c7d                	li	s8,-1
    8000298e:	a80d                	j	800029c0 <readi+0x7c>
    80002990:	020d1d93          	slli	s11,s10,0x20
    80002994:	020ddd93          	srli	s11,s11,0x20
    80002998:	05890613          	addi	a2,s2,88
    8000299c:	86ee                	mv	a3,s11
    8000299e:	963a                	add	a2,a2,a4
    800029a0:	85d2                	mv	a1,s4
    800029a2:	855e                	mv	a0,s7
    800029a4:	ce9fe0ef          	jal	8000168c <either_copyout>
    800029a8:	05850763          	beq	a0,s8,800029f6 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800029ac:	854a                	mv	a0,s2
    800029ae:	f12ff0ef          	jal	800020c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029b2:	013d09bb          	addw	s3,s10,s3
    800029b6:	009d04bb          	addw	s1,s10,s1
    800029ba:	9a6e                	add	s4,s4,s11
    800029bc:	0559f763          	bgeu	s3,s5,80002a0a <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800029c0:	00a4d59b          	srliw	a1,s1,0xa
    800029c4:	855a                	mv	a0,s6
    800029c6:	977ff0ef          	jal	8000233c <bmap>
    800029ca:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800029ce:	c5b1                	beqz	a1,80002a1a <readi+0xd6>
    bp = bread(ip->dev, addr);
    800029d0:	000b2503          	lw	a0,0(s6)
    800029d4:	de4ff0ef          	jal	80001fb8 <bread>
    800029d8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800029da:	3ff4f713          	andi	a4,s1,1023
    800029de:	40ec87bb          	subw	a5,s9,a4
    800029e2:	413a86bb          	subw	a3,s5,s3
    800029e6:	8d3e                	mv	s10,a5
    800029e8:	2781                	sext.w	a5,a5
    800029ea:	0006861b          	sext.w	a2,a3
    800029ee:	faf671e3          	bgeu	a2,a5,80002990 <readi+0x4c>
    800029f2:	8d36                	mv	s10,a3
    800029f4:	bf71                	j	80002990 <readi+0x4c>
      brelse(bp);
    800029f6:	854a                	mv	a0,s2
    800029f8:	ec8ff0ef          	jal	800020c0 <brelse>
      tot = -1;
    800029fc:	59fd                	li	s3,-1
      break;
    800029fe:	6946                	ld	s2,80(sp)
    80002a00:	7c02                	ld	s8,32(sp)
    80002a02:	6ce2                	ld	s9,24(sp)
    80002a04:	6d42                	ld	s10,16(sp)
    80002a06:	6da2                	ld	s11,8(sp)
    80002a08:	a831                	j	80002a24 <readi+0xe0>
    80002a0a:	6946                	ld	s2,80(sp)
    80002a0c:	7c02                	ld	s8,32(sp)
    80002a0e:	6ce2                	ld	s9,24(sp)
    80002a10:	6d42                	ld	s10,16(sp)
    80002a12:	6da2                	ld	s11,8(sp)
    80002a14:	a801                	j	80002a24 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a16:	89d6                	mv	s3,s5
    80002a18:	a031                	j	80002a24 <readi+0xe0>
    80002a1a:	6946                	ld	s2,80(sp)
    80002a1c:	7c02                	ld	s8,32(sp)
    80002a1e:	6ce2                	ld	s9,24(sp)
    80002a20:	6d42                	ld	s10,16(sp)
    80002a22:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a24:	0009851b          	sext.w	a0,s3
    80002a28:	69a6                	ld	s3,72(sp)
}
    80002a2a:	70a6                	ld	ra,104(sp)
    80002a2c:	7406                	ld	s0,96(sp)
    80002a2e:	64e6                	ld	s1,88(sp)
    80002a30:	6a06                	ld	s4,64(sp)
    80002a32:	7ae2                	ld	s5,56(sp)
    80002a34:	7b42                	ld	s6,48(sp)
    80002a36:	7ba2                	ld	s7,40(sp)
    80002a38:	6165                	addi	sp,sp,112
    80002a3a:	8082                	ret
    return 0;
    80002a3c:	4501                	li	a0,0
}
    80002a3e:	8082                	ret

0000000080002a40 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a40:	457c                	lw	a5,76(a0)
    80002a42:	10d7e063          	bltu	a5,a3,80002b42 <writei+0x102>
{
    80002a46:	7159                	addi	sp,sp,-112
    80002a48:	f486                	sd	ra,104(sp)
    80002a4a:	f0a2                	sd	s0,96(sp)
    80002a4c:	e8ca                	sd	s2,80(sp)
    80002a4e:	e0d2                	sd	s4,64(sp)
    80002a50:	fc56                	sd	s5,56(sp)
    80002a52:	f85a                	sd	s6,48(sp)
    80002a54:	f45e                	sd	s7,40(sp)
    80002a56:	1880                	addi	s0,sp,112
    80002a58:	8aaa                	mv	s5,a0
    80002a5a:	8bae                	mv	s7,a1
    80002a5c:	8a32                	mv	s4,a2
    80002a5e:	8936                	mv	s2,a3
    80002a60:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002a62:	00e687bb          	addw	a5,a3,a4
    80002a66:	0ed7e063          	bltu	a5,a3,80002b46 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002a6a:	00043737          	lui	a4,0x43
    80002a6e:	0cf76e63          	bltu	a4,a5,80002b4a <writei+0x10a>
    80002a72:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a74:	0a0b0f63          	beqz	s6,80002b32 <writei+0xf2>
    80002a78:	eca6                	sd	s1,88(sp)
    80002a7a:	f062                	sd	s8,32(sp)
    80002a7c:	ec66                	sd	s9,24(sp)
    80002a7e:	e86a                	sd	s10,16(sp)
    80002a80:	e46e                	sd	s11,8(sp)
    80002a82:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a84:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002a88:	5c7d                	li	s8,-1
    80002a8a:	a825                	j	80002ac2 <writei+0x82>
    80002a8c:	020d1d93          	slli	s11,s10,0x20
    80002a90:	020ddd93          	srli	s11,s11,0x20
    80002a94:	05848513          	addi	a0,s1,88
    80002a98:	86ee                	mv	a3,s11
    80002a9a:	8652                	mv	a2,s4
    80002a9c:	85de                	mv	a1,s7
    80002a9e:	953a                	add	a0,a0,a4
    80002aa0:	c37fe0ef          	jal	800016d6 <either_copyin>
    80002aa4:	05850a63          	beq	a0,s8,80002af8 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002aa8:	8526                	mv	a0,s1
    80002aaa:	660000ef          	jal	8000310a <log_write>
    brelse(bp);
    80002aae:	8526                	mv	a0,s1
    80002ab0:	e10ff0ef          	jal	800020c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ab4:	013d09bb          	addw	s3,s10,s3
    80002ab8:	012d093b          	addw	s2,s10,s2
    80002abc:	9a6e                	add	s4,s4,s11
    80002abe:	0569f063          	bgeu	s3,s6,80002afe <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002ac2:	00a9559b          	srliw	a1,s2,0xa
    80002ac6:	8556                	mv	a0,s5
    80002ac8:	875ff0ef          	jal	8000233c <bmap>
    80002acc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ad0:	c59d                	beqz	a1,80002afe <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002ad2:	000aa503          	lw	a0,0(s5)
    80002ad6:	ce2ff0ef          	jal	80001fb8 <bread>
    80002ada:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002adc:	3ff97713          	andi	a4,s2,1023
    80002ae0:	40ec87bb          	subw	a5,s9,a4
    80002ae4:	413b06bb          	subw	a3,s6,s3
    80002ae8:	8d3e                	mv	s10,a5
    80002aea:	2781                	sext.w	a5,a5
    80002aec:	0006861b          	sext.w	a2,a3
    80002af0:	f8f67ee3          	bgeu	a2,a5,80002a8c <writei+0x4c>
    80002af4:	8d36                	mv	s10,a3
    80002af6:	bf59                	j	80002a8c <writei+0x4c>
      brelse(bp);
    80002af8:	8526                	mv	a0,s1
    80002afa:	dc6ff0ef          	jal	800020c0 <brelse>
  }

  if(off > ip->size)
    80002afe:	04caa783          	lw	a5,76(s5)
    80002b02:	0327fa63          	bgeu	a5,s2,80002b36 <writei+0xf6>
    ip->size = off;
    80002b06:	052aa623          	sw	s2,76(s5)
    80002b0a:	64e6                	ld	s1,88(sp)
    80002b0c:	7c02                	ld	s8,32(sp)
    80002b0e:	6ce2                	ld	s9,24(sp)
    80002b10:	6d42                	ld	s10,16(sp)
    80002b12:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b14:	8556                	mv	a0,s5
    80002b16:	b27ff0ef          	jal	8000263c <iupdate>

  return tot;
    80002b1a:	0009851b          	sext.w	a0,s3
    80002b1e:	69a6                	ld	s3,72(sp)
}
    80002b20:	70a6                	ld	ra,104(sp)
    80002b22:	7406                	ld	s0,96(sp)
    80002b24:	6946                	ld	s2,80(sp)
    80002b26:	6a06                	ld	s4,64(sp)
    80002b28:	7ae2                	ld	s5,56(sp)
    80002b2a:	7b42                	ld	s6,48(sp)
    80002b2c:	7ba2                	ld	s7,40(sp)
    80002b2e:	6165                	addi	sp,sp,112
    80002b30:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b32:	89da                	mv	s3,s6
    80002b34:	b7c5                	j	80002b14 <writei+0xd4>
    80002b36:	64e6                	ld	s1,88(sp)
    80002b38:	7c02                	ld	s8,32(sp)
    80002b3a:	6ce2                	ld	s9,24(sp)
    80002b3c:	6d42                	ld	s10,16(sp)
    80002b3e:	6da2                	ld	s11,8(sp)
    80002b40:	bfd1                	j	80002b14 <writei+0xd4>
    return -1;
    80002b42:	557d                	li	a0,-1
}
    80002b44:	8082                	ret
    return -1;
    80002b46:	557d                	li	a0,-1
    80002b48:	bfe1                	j	80002b20 <writei+0xe0>
    return -1;
    80002b4a:	557d                	li	a0,-1
    80002b4c:	bfd1                	j	80002b20 <writei+0xe0>

0000000080002b4e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b4e:	1141                	addi	sp,sp,-16
    80002b50:	e406                	sd	ra,8(sp)
    80002b52:	e022                	sd	s0,0(sp)
    80002b54:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b56:	4639                	li	a2,14
    80002b58:	ea8fd0ef          	jal	80000200 <strncmp>
}
    80002b5c:	60a2                	ld	ra,8(sp)
    80002b5e:	6402                	ld	s0,0(sp)
    80002b60:	0141                	addi	sp,sp,16
    80002b62:	8082                	ret

0000000080002b64 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002b64:	7139                	addi	sp,sp,-64
    80002b66:	fc06                	sd	ra,56(sp)
    80002b68:	f822                	sd	s0,48(sp)
    80002b6a:	f426                	sd	s1,40(sp)
    80002b6c:	f04a                	sd	s2,32(sp)
    80002b6e:	ec4e                	sd	s3,24(sp)
    80002b70:	e852                	sd	s4,16(sp)
    80002b72:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002b74:	04451703          	lh	a4,68(a0)
    80002b78:	4785                	li	a5,1
    80002b7a:	00f71a63          	bne	a4,a5,80002b8e <dirlookup+0x2a>
    80002b7e:	892a                	mv	s2,a0
    80002b80:	89ae                	mv	s3,a1
    80002b82:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b84:	457c                	lw	a5,76(a0)
    80002b86:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002b88:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b8a:	e39d                	bnez	a5,80002bb0 <dirlookup+0x4c>
    80002b8c:	a095                	j	80002bf0 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002b8e:	00005517          	auipc	a0,0x5
    80002b92:	a0a50513          	addi	a0,a0,-1526 # 80007598 <etext+0x598>
    80002b96:	10d020ef          	jal	800054a2 <panic>
      panic("dirlookup read");
    80002b9a:	00005517          	auipc	a0,0x5
    80002b9e:	a1650513          	addi	a0,a0,-1514 # 800075b0 <etext+0x5b0>
    80002ba2:	101020ef          	jal	800054a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ba6:	24c1                	addiw	s1,s1,16
    80002ba8:	04c92783          	lw	a5,76(s2)
    80002bac:	04f4f163          	bgeu	s1,a5,80002bee <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bb0:	4741                	li	a4,16
    80002bb2:	86a6                	mv	a3,s1
    80002bb4:	fc040613          	addi	a2,s0,-64
    80002bb8:	4581                	li	a1,0
    80002bba:	854a                	mv	a0,s2
    80002bbc:	d89ff0ef          	jal	80002944 <readi>
    80002bc0:	47c1                	li	a5,16
    80002bc2:	fcf51ce3          	bne	a0,a5,80002b9a <dirlookup+0x36>
    if(de.inum == 0)
    80002bc6:	fc045783          	lhu	a5,-64(s0)
    80002bca:	dff1                	beqz	a5,80002ba6 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002bcc:	fc240593          	addi	a1,s0,-62
    80002bd0:	854e                	mv	a0,s3
    80002bd2:	f7dff0ef          	jal	80002b4e <namecmp>
    80002bd6:	f961                	bnez	a0,80002ba6 <dirlookup+0x42>
      if(poff)
    80002bd8:	000a0463          	beqz	s4,80002be0 <dirlookup+0x7c>
        *poff = off;
    80002bdc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002be0:	fc045583          	lhu	a1,-64(s0)
    80002be4:	00092503          	lw	a0,0(s2)
    80002be8:	829ff0ef          	jal	80002410 <iget>
    80002bec:	a011                	j	80002bf0 <dirlookup+0x8c>
  return 0;
    80002bee:	4501                	li	a0,0
}
    80002bf0:	70e2                	ld	ra,56(sp)
    80002bf2:	7442                	ld	s0,48(sp)
    80002bf4:	74a2                	ld	s1,40(sp)
    80002bf6:	7902                	ld	s2,32(sp)
    80002bf8:	69e2                	ld	s3,24(sp)
    80002bfa:	6a42                	ld	s4,16(sp)
    80002bfc:	6121                	addi	sp,sp,64
    80002bfe:	8082                	ret

0000000080002c00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c00:	711d                	addi	sp,sp,-96
    80002c02:	ec86                	sd	ra,88(sp)
    80002c04:	e8a2                	sd	s0,80(sp)
    80002c06:	e4a6                	sd	s1,72(sp)
    80002c08:	e0ca                	sd	s2,64(sp)
    80002c0a:	fc4e                	sd	s3,56(sp)
    80002c0c:	f852                	sd	s4,48(sp)
    80002c0e:	f456                	sd	s5,40(sp)
    80002c10:	f05a                	sd	s6,32(sp)
    80002c12:	ec5e                	sd	s7,24(sp)
    80002c14:	e862                	sd	s8,16(sp)
    80002c16:	e466                	sd	s9,8(sp)
    80002c18:	1080                	addi	s0,sp,96
    80002c1a:	84aa                	mv	s1,a0
    80002c1c:	8b2e                	mv	s6,a1
    80002c1e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c20:	00054703          	lbu	a4,0(a0)
    80002c24:	02f00793          	li	a5,47
    80002c28:	00f70e63          	beq	a4,a5,80002c44 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c2c:	92afe0ef          	jal	80000d56 <myproc>
    80002c30:	15053503          	ld	a0,336(a0)
    80002c34:	a87ff0ef          	jal	800026ba <idup>
    80002c38:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002c3a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002c3e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c40:	4b85                	li	s7,1
    80002c42:	a871                	j	80002cde <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002c44:	4585                	li	a1,1
    80002c46:	4505                	li	a0,1
    80002c48:	fc8ff0ef          	jal	80002410 <iget>
    80002c4c:	8a2a                	mv	s4,a0
    80002c4e:	b7f5                	j	80002c3a <namex+0x3a>
      iunlockput(ip);
    80002c50:	8552                	mv	a0,s4
    80002c52:	ca9ff0ef          	jal	800028fa <iunlockput>
      return 0;
    80002c56:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002c58:	8552                	mv	a0,s4
    80002c5a:	60e6                	ld	ra,88(sp)
    80002c5c:	6446                	ld	s0,80(sp)
    80002c5e:	64a6                	ld	s1,72(sp)
    80002c60:	6906                	ld	s2,64(sp)
    80002c62:	79e2                	ld	s3,56(sp)
    80002c64:	7a42                	ld	s4,48(sp)
    80002c66:	7aa2                	ld	s5,40(sp)
    80002c68:	7b02                	ld	s6,32(sp)
    80002c6a:	6be2                	ld	s7,24(sp)
    80002c6c:	6c42                	ld	s8,16(sp)
    80002c6e:	6ca2                	ld	s9,8(sp)
    80002c70:	6125                	addi	sp,sp,96
    80002c72:	8082                	ret
      iunlock(ip);
    80002c74:	8552                	mv	a0,s4
    80002c76:	b29ff0ef          	jal	8000279e <iunlock>
      return ip;
    80002c7a:	bff9                	j	80002c58 <namex+0x58>
      iunlockput(ip);
    80002c7c:	8552                	mv	a0,s4
    80002c7e:	c7dff0ef          	jal	800028fa <iunlockput>
      return 0;
    80002c82:	8a4e                	mv	s4,s3
    80002c84:	bfd1                	j	80002c58 <namex+0x58>
  len = path - s;
    80002c86:	40998633          	sub	a2,s3,s1
    80002c8a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002c8e:	099c5063          	bge	s8,s9,80002d0e <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002c92:	4639                	li	a2,14
    80002c94:	85a6                	mv	a1,s1
    80002c96:	8556                	mv	a0,s5
    80002c98:	cf8fd0ef          	jal	80000190 <memmove>
    80002c9c:	84ce                	mv	s1,s3
  while(*path == '/')
    80002c9e:	0004c783          	lbu	a5,0(s1)
    80002ca2:	01279763          	bne	a5,s2,80002cb0 <namex+0xb0>
    path++;
    80002ca6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ca8:	0004c783          	lbu	a5,0(s1)
    80002cac:	ff278de3          	beq	a5,s2,80002ca6 <namex+0xa6>
    ilock(ip);
    80002cb0:	8552                	mv	a0,s4
    80002cb2:	a3fff0ef          	jal	800026f0 <ilock>
    if(ip->type != T_DIR){
    80002cb6:	044a1783          	lh	a5,68(s4)
    80002cba:	f9779be3          	bne	a5,s7,80002c50 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002cbe:	000b0563          	beqz	s6,80002cc8 <namex+0xc8>
    80002cc2:	0004c783          	lbu	a5,0(s1)
    80002cc6:	d7dd                	beqz	a5,80002c74 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002cc8:	4601                	li	a2,0
    80002cca:	85d6                	mv	a1,s5
    80002ccc:	8552                	mv	a0,s4
    80002cce:	e97ff0ef          	jal	80002b64 <dirlookup>
    80002cd2:	89aa                	mv	s3,a0
    80002cd4:	d545                	beqz	a0,80002c7c <namex+0x7c>
    iunlockput(ip);
    80002cd6:	8552                	mv	a0,s4
    80002cd8:	c23ff0ef          	jal	800028fa <iunlockput>
    ip = next;
    80002cdc:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002cde:	0004c783          	lbu	a5,0(s1)
    80002ce2:	01279763          	bne	a5,s2,80002cf0 <namex+0xf0>
    path++;
    80002ce6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ce8:	0004c783          	lbu	a5,0(s1)
    80002cec:	ff278de3          	beq	a5,s2,80002ce6 <namex+0xe6>
  if(*path == 0)
    80002cf0:	cb8d                	beqz	a5,80002d22 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002cf2:	0004c783          	lbu	a5,0(s1)
    80002cf6:	89a6                	mv	s3,s1
  len = path - s;
    80002cf8:	4c81                	li	s9,0
    80002cfa:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002cfc:	01278963          	beq	a5,s2,80002d0e <namex+0x10e>
    80002d00:	d3d9                	beqz	a5,80002c86 <namex+0x86>
    path++;
    80002d02:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d04:	0009c783          	lbu	a5,0(s3)
    80002d08:	ff279ce3          	bne	a5,s2,80002d00 <namex+0x100>
    80002d0c:	bfad                	j	80002c86 <namex+0x86>
    memmove(name, s, len);
    80002d0e:	2601                	sext.w	a2,a2
    80002d10:	85a6                	mv	a1,s1
    80002d12:	8556                	mv	a0,s5
    80002d14:	c7cfd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    80002d18:	9cd6                	add	s9,s9,s5
    80002d1a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d1e:	84ce                	mv	s1,s3
    80002d20:	bfbd                	j	80002c9e <namex+0x9e>
  if(nameiparent){
    80002d22:	f20b0be3          	beqz	s6,80002c58 <namex+0x58>
    iput(ip);
    80002d26:	8552                	mv	a0,s4
    80002d28:	b4bff0ef          	jal	80002872 <iput>
    return 0;
    80002d2c:	4a01                	li	s4,0
    80002d2e:	b72d                	j	80002c58 <namex+0x58>

0000000080002d30 <dirlink>:
{
    80002d30:	7139                	addi	sp,sp,-64
    80002d32:	fc06                	sd	ra,56(sp)
    80002d34:	f822                	sd	s0,48(sp)
    80002d36:	f04a                	sd	s2,32(sp)
    80002d38:	ec4e                	sd	s3,24(sp)
    80002d3a:	e852                	sd	s4,16(sp)
    80002d3c:	0080                	addi	s0,sp,64
    80002d3e:	892a                	mv	s2,a0
    80002d40:	8a2e                	mv	s4,a1
    80002d42:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d44:	4601                	li	a2,0
    80002d46:	e1fff0ef          	jal	80002b64 <dirlookup>
    80002d4a:	e535                	bnez	a0,80002db6 <dirlink+0x86>
    80002d4c:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d4e:	04c92483          	lw	s1,76(s2)
    80002d52:	c48d                	beqz	s1,80002d7c <dirlink+0x4c>
    80002d54:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d56:	4741                	li	a4,16
    80002d58:	86a6                	mv	a3,s1
    80002d5a:	fc040613          	addi	a2,s0,-64
    80002d5e:	4581                	li	a1,0
    80002d60:	854a                	mv	a0,s2
    80002d62:	be3ff0ef          	jal	80002944 <readi>
    80002d66:	47c1                	li	a5,16
    80002d68:	04f51b63          	bne	a0,a5,80002dbe <dirlink+0x8e>
    if(de.inum == 0)
    80002d6c:	fc045783          	lhu	a5,-64(s0)
    80002d70:	c791                	beqz	a5,80002d7c <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d72:	24c1                	addiw	s1,s1,16
    80002d74:	04c92783          	lw	a5,76(s2)
    80002d78:	fcf4efe3          	bltu	s1,a5,80002d56 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002d7c:	4639                	li	a2,14
    80002d7e:	85d2                	mv	a1,s4
    80002d80:	fc240513          	addi	a0,s0,-62
    80002d84:	cb2fd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    80002d88:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d8c:	4741                	li	a4,16
    80002d8e:	86a6                	mv	a3,s1
    80002d90:	fc040613          	addi	a2,s0,-64
    80002d94:	4581                	li	a1,0
    80002d96:	854a                	mv	a0,s2
    80002d98:	ca9ff0ef          	jal	80002a40 <writei>
    80002d9c:	1541                	addi	a0,a0,-16
    80002d9e:	00a03533          	snez	a0,a0
    80002da2:	40a00533          	neg	a0,a0
    80002da6:	74a2                	ld	s1,40(sp)
}
    80002da8:	70e2                	ld	ra,56(sp)
    80002daa:	7442                	ld	s0,48(sp)
    80002dac:	7902                	ld	s2,32(sp)
    80002dae:	69e2                	ld	s3,24(sp)
    80002db0:	6a42                	ld	s4,16(sp)
    80002db2:	6121                	addi	sp,sp,64
    80002db4:	8082                	ret
    iput(ip);
    80002db6:	abdff0ef          	jal	80002872 <iput>
    return -1;
    80002dba:	557d                	li	a0,-1
    80002dbc:	b7f5                	j	80002da8 <dirlink+0x78>
      panic("dirlink read");
    80002dbe:	00005517          	auipc	a0,0x5
    80002dc2:	80250513          	addi	a0,a0,-2046 # 800075c0 <etext+0x5c0>
    80002dc6:	6dc020ef          	jal	800054a2 <panic>

0000000080002dca <namei>:

struct inode*
namei(char *path)
{
    80002dca:	1101                	addi	sp,sp,-32
    80002dcc:	ec06                	sd	ra,24(sp)
    80002dce:	e822                	sd	s0,16(sp)
    80002dd0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002dd2:	fe040613          	addi	a2,s0,-32
    80002dd6:	4581                	li	a1,0
    80002dd8:	e29ff0ef          	jal	80002c00 <namex>
}
    80002ddc:	60e2                	ld	ra,24(sp)
    80002dde:	6442                	ld	s0,16(sp)
    80002de0:	6105                	addi	sp,sp,32
    80002de2:	8082                	ret

0000000080002de4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002de4:	1141                	addi	sp,sp,-16
    80002de6:	e406                	sd	ra,8(sp)
    80002de8:	e022                	sd	s0,0(sp)
    80002dea:	0800                	addi	s0,sp,16
    80002dec:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002dee:	4585                	li	a1,1
    80002df0:	e11ff0ef          	jal	80002c00 <namex>
}
    80002df4:	60a2                	ld	ra,8(sp)
    80002df6:	6402                	ld	s0,0(sp)
    80002df8:	0141                	addi	sp,sp,16
    80002dfa:	8082                	ret

0000000080002dfc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002dfc:	1101                	addi	sp,sp,-32
    80002dfe:	ec06                	sd	ra,24(sp)
    80002e00:	e822                	sd	s0,16(sp)
    80002e02:	e426                	sd	s1,8(sp)
    80002e04:	e04a                	sd	s2,0(sp)
    80002e06:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e08:	00017917          	auipc	s2,0x17
    80002e0c:	7d890913          	addi	s2,s2,2008 # 8001a5e0 <log>
    80002e10:	01892583          	lw	a1,24(s2)
    80002e14:	02892503          	lw	a0,40(s2)
    80002e18:	9a0ff0ef          	jal	80001fb8 <bread>
    80002e1c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e1e:	02c92603          	lw	a2,44(s2)
    80002e22:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e24:	00c05f63          	blez	a2,80002e42 <write_head+0x46>
    80002e28:	00017717          	auipc	a4,0x17
    80002e2c:	7e870713          	addi	a4,a4,2024 # 8001a610 <log+0x30>
    80002e30:	87aa                	mv	a5,a0
    80002e32:	060a                	slli	a2,a2,0x2
    80002e34:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002e36:	4314                	lw	a3,0(a4)
    80002e38:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002e3a:	0711                	addi	a4,a4,4
    80002e3c:	0791                	addi	a5,a5,4
    80002e3e:	fec79ce3          	bne	a5,a2,80002e36 <write_head+0x3a>
  }
  bwrite(buf);
    80002e42:	8526                	mv	a0,s1
    80002e44:	a4aff0ef          	jal	8000208e <bwrite>
  brelse(buf);
    80002e48:	8526                	mv	a0,s1
    80002e4a:	a76ff0ef          	jal	800020c0 <brelse>
}
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	64a2                	ld	s1,8(sp)
    80002e54:	6902                	ld	s2,0(sp)
    80002e56:	6105                	addi	sp,sp,32
    80002e58:	8082                	ret

0000000080002e5a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e5a:	00017797          	auipc	a5,0x17
    80002e5e:	7b27a783          	lw	a5,1970(a5) # 8001a60c <log+0x2c>
    80002e62:	08f05f63          	blez	a5,80002f00 <install_trans+0xa6>
{
    80002e66:	7139                	addi	sp,sp,-64
    80002e68:	fc06                	sd	ra,56(sp)
    80002e6a:	f822                	sd	s0,48(sp)
    80002e6c:	f426                	sd	s1,40(sp)
    80002e6e:	f04a                	sd	s2,32(sp)
    80002e70:	ec4e                	sd	s3,24(sp)
    80002e72:	e852                	sd	s4,16(sp)
    80002e74:	e456                	sd	s5,8(sp)
    80002e76:	e05a                	sd	s6,0(sp)
    80002e78:	0080                	addi	s0,sp,64
    80002e7a:	8b2a                	mv	s6,a0
    80002e7c:	00017a97          	auipc	s5,0x17
    80002e80:	794a8a93          	addi	s5,s5,1940 # 8001a610 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e84:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002e86:	00017997          	auipc	s3,0x17
    80002e8a:	75a98993          	addi	s3,s3,1882 # 8001a5e0 <log>
    80002e8e:	a829                	j	80002ea8 <install_trans+0x4e>
    brelse(lbuf);
    80002e90:	854a                	mv	a0,s2
    80002e92:	a2eff0ef          	jal	800020c0 <brelse>
    brelse(dbuf);
    80002e96:	8526                	mv	a0,s1
    80002e98:	a28ff0ef          	jal	800020c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e9c:	2a05                	addiw	s4,s4,1
    80002e9e:	0a91                	addi	s5,s5,4
    80002ea0:	02c9a783          	lw	a5,44(s3)
    80002ea4:	04fa5463          	bge	s4,a5,80002eec <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ea8:	0189a583          	lw	a1,24(s3)
    80002eac:	014585bb          	addw	a1,a1,s4
    80002eb0:	2585                	addiw	a1,a1,1
    80002eb2:	0289a503          	lw	a0,40(s3)
    80002eb6:	902ff0ef          	jal	80001fb8 <bread>
    80002eba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ebc:	000aa583          	lw	a1,0(s5)
    80002ec0:	0289a503          	lw	a0,40(s3)
    80002ec4:	8f4ff0ef          	jal	80001fb8 <bread>
    80002ec8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002eca:	40000613          	li	a2,1024
    80002ece:	05890593          	addi	a1,s2,88
    80002ed2:	05850513          	addi	a0,a0,88
    80002ed6:	abafd0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002eda:	8526                	mv	a0,s1
    80002edc:	9b2ff0ef          	jal	8000208e <bwrite>
    if(recovering == 0)
    80002ee0:	fa0b18e3          	bnez	s6,80002e90 <install_trans+0x36>
      bunpin(dbuf);
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	a96ff0ef          	jal	8000217c <bunpin>
    80002eea:	b75d                	j	80002e90 <install_trans+0x36>
}
    80002eec:	70e2                	ld	ra,56(sp)
    80002eee:	7442                	ld	s0,48(sp)
    80002ef0:	74a2                	ld	s1,40(sp)
    80002ef2:	7902                	ld	s2,32(sp)
    80002ef4:	69e2                	ld	s3,24(sp)
    80002ef6:	6a42                	ld	s4,16(sp)
    80002ef8:	6aa2                	ld	s5,8(sp)
    80002efa:	6b02                	ld	s6,0(sp)
    80002efc:	6121                	addi	sp,sp,64
    80002efe:	8082                	ret
    80002f00:	8082                	ret

0000000080002f02 <initlog>:
{
    80002f02:	7179                	addi	sp,sp,-48
    80002f04:	f406                	sd	ra,40(sp)
    80002f06:	f022                	sd	s0,32(sp)
    80002f08:	ec26                	sd	s1,24(sp)
    80002f0a:	e84a                	sd	s2,16(sp)
    80002f0c:	e44e                	sd	s3,8(sp)
    80002f0e:	1800                	addi	s0,sp,48
    80002f10:	892a                	mv	s2,a0
    80002f12:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f14:	00017497          	auipc	s1,0x17
    80002f18:	6cc48493          	addi	s1,s1,1740 # 8001a5e0 <log>
    80002f1c:	00004597          	auipc	a1,0x4
    80002f20:	6b458593          	addi	a1,a1,1716 # 800075d0 <etext+0x5d0>
    80002f24:	8526                	mv	a0,s1
    80002f26:	02b020ef          	jal	80005750 <initlock>
  log.start = sb->logstart;
    80002f2a:	0149a583          	lw	a1,20(s3)
    80002f2e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f30:	0109a783          	lw	a5,16(s3)
    80002f34:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002f36:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	87cff0ef          	jal	80001fb8 <bread>
  log.lh.n = lh->n;
    80002f40:	4d30                	lw	a2,88(a0)
    80002f42:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002f44:	00c05f63          	blez	a2,80002f62 <initlog+0x60>
    80002f48:	87aa                	mv	a5,a0
    80002f4a:	00017717          	auipc	a4,0x17
    80002f4e:	6c670713          	addi	a4,a4,1734 # 8001a610 <log+0x30>
    80002f52:	060a                	slli	a2,a2,0x2
    80002f54:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002f56:	4ff4                	lw	a3,92(a5)
    80002f58:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002f5a:	0791                	addi	a5,a5,4
    80002f5c:	0711                	addi	a4,a4,4
    80002f5e:	fec79ce3          	bne	a5,a2,80002f56 <initlog+0x54>
  brelse(buf);
    80002f62:	95eff0ef          	jal	800020c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002f66:	4505                	li	a0,1
    80002f68:	ef3ff0ef          	jal	80002e5a <install_trans>
  log.lh.n = 0;
    80002f6c:	00017797          	auipc	a5,0x17
    80002f70:	6a07a023          	sw	zero,1696(a5) # 8001a60c <log+0x2c>
  write_head(); // clear the log
    80002f74:	e89ff0ef          	jal	80002dfc <write_head>
}
    80002f78:	70a2                	ld	ra,40(sp)
    80002f7a:	7402                	ld	s0,32(sp)
    80002f7c:	64e2                	ld	s1,24(sp)
    80002f7e:	6942                	ld	s2,16(sp)
    80002f80:	69a2                	ld	s3,8(sp)
    80002f82:	6145                	addi	sp,sp,48
    80002f84:	8082                	ret

0000000080002f86 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002f86:	1101                	addi	sp,sp,-32
    80002f88:	ec06                	sd	ra,24(sp)
    80002f8a:	e822                	sd	s0,16(sp)
    80002f8c:	e426                	sd	s1,8(sp)
    80002f8e:	e04a                	sd	s2,0(sp)
    80002f90:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002f92:	00017517          	auipc	a0,0x17
    80002f96:	64e50513          	addi	a0,a0,1614 # 8001a5e0 <log>
    80002f9a:	037020ef          	jal	800057d0 <acquire>
  while(1){
    if(log.committing){
    80002f9e:	00017497          	auipc	s1,0x17
    80002fa2:	64248493          	addi	s1,s1,1602 # 8001a5e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002fa6:	4979                	li	s2,30
    80002fa8:	a029                	j	80002fb2 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002faa:	85a6                	mv	a1,s1
    80002fac:	8526                	mv	a0,s1
    80002fae:	b82fe0ef          	jal	80001330 <sleep>
    if(log.committing){
    80002fb2:	50dc                	lw	a5,36(s1)
    80002fb4:	fbfd                	bnez	a5,80002faa <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002fb6:	5098                	lw	a4,32(s1)
    80002fb8:	2705                	addiw	a4,a4,1
    80002fba:	0027179b          	slliw	a5,a4,0x2
    80002fbe:	9fb9                	addw	a5,a5,a4
    80002fc0:	0017979b          	slliw	a5,a5,0x1
    80002fc4:	54d4                	lw	a3,44(s1)
    80002fc6:	9fb5                	addw	a5,a5,a3
    80002fc8:	00f95763          	bge	s2,a5,80002fd6 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002fcc:	85a6                	mv	a1,s1
    80002fce:	8526                	mv	a0,s1
    80002fd0:	b60fe0ef          	jal	80001330 <sleep>
    80002fd4:	bff9                	j	80002fb2 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002fd6:	00017517          	auipc	a0,0x17
    80002fda:	60a50513          	addi	a0,a0,1546 # 8001a5e0 <log>
    80002fde:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002fe0:	089020ef          	jal	80005868 <release>
      break;
    }
  }
}
    80002fe4:	60e2                	ld	ra,24(sp)
    80002fe6:	6442                	ld	s0,16(sp)
    80002fe8:	64a2                	ld	s1,8(sp)
    80002fea:	6902                	ld	s2,0(sp)
    80002fec:	6105                	addi	sp,sp,32
    80002fee:	8082                	ret

0000000080002ff0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002ff0:	7139                	addi	sp,sp,-64
    80002ff2:	fc06                	sd	ra,56(sp)
    80002ff4:	f822                	sd	s0,48(sp)
    80002ff6:	f426                	sd	s1,40(sp)
    80002ff8:	f04a                	sd	s2,32(sp)
    80002ffa:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002ffc:	00017497          	auipc	s1,0x17
    80003000:	5e448493          	addi	s1,s1,1508 # 8001a5e0 <log>
    80003004:	8526                	mv	a0,s1
    80003006:	7ca020ef          	jal	800057d0 <acquire>
  log.outstanding -= 1;
    8000300a:	509c                	lw	a5,32(s1)
    8000300c:	37fd                	addiw	a5,a5,-1
    8000300e:	0007891b          	sext.w	s2,a5
    80003012:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003014:	50dc                	lw	a5,36(s1)
    80003016:	ef9d                	bnez	a5,80003054 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003018:	04091763          	bnez	s2,80003066 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000301c:	00017497          	auipc	s1,0x17
    80003020:	5c448493          	addi	s1,s1,1476 # 8001a5e0 <log>
    80003024:	4785                	li	a5,1
    80003026:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003028:	8526                	mv	a0,s1
    8000302a:	03f020ef          	jal	80005868 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000302e:	54dc                	lw	a5,44(s1)
    80003030:	04f04b63          	bgtz	a5,80003086 <end_op+0x96>
    acquire(&log.lock);
    80003034:	00017497          	auipc	s1,0x17
    80003038:	5ac48493          	addi	s1,s1,1452 # 8001a5e0 <log>
    8000303c:	8526                	mv	a0,s1
    8000303e:	792020ef          	jal	800057d0 <acquire>
    log.committing = 0;
    80003042:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003046:	8526                	mv	a0,s1
    80003048:	b34fe0ef          	jal	8000137c <wakeup>
    release(&log.lock);
    8000304c:	8526                	mv	a0,s1
    8000304e:	01b020ef          	jal	80005868 <release>
}
    80003052:	a025                	j	8000307a <end_op+0x8a>
    80003054:	ec4e                	sd	s3,24(sp)
    80003056:	e852                	sd	s4,16(sp)
    80003058:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000305a:	00004517          	auipc	a0,0x4
    8000305e:	57e50513          	addi	a0,a0,1406 # 800075d8 <etext+0x5d8>
    80003062:	440020ef          	jal	800054a2 <panic>
    wakeup(&log);
    80003066:	00017497          	auipc	s1,0x17
    8000306a:	57a48493          	addi	s1,s1,1402 # 8001a5e0 <log>
    8000306e:	8526                	mv	a0,s1
    80003070:	b0cfe0ef          	jal	8000137c <wakeup>
  release(&log.lock);
    80003074:	8526                	mv	a0,s1
    80003076:	7f2020ef          	jal	80005868 <release>
}
    8000307a:	70e2                	ld	ra,56(sp)
    8000307c:	7442                	ld	s0,48(sp)
    8000307e:	74a2                	ld	s1,40(sp)
    80003080:	7902                	ld	s2,32(sp)
    80003082:	6121                	addi	sp,sp,64
    80003084:	8082                	ret
    80003086:	ec4e                	sd	s3,24(sp)
    80003088:	e852                	sd	s4,16(sp)
    8000308a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000308c:	00017a97          	auipc	s5,0x17
    80003090:	584a8a93          	addi	s5,s5,1412 # 8001a610 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003094:	00017a17          	auipc	s4,0x17
    80003098:	54ca0a13          	addi	s4,s4,1356 # 8001a5e0 <log>
    8000309c:	018a2583          	lw	a1,24(s4)
    800030a0:	012585bb          	addw	a1,a1,s2
    800030a4:	2585                	addiw	a1,a1,1
    800030a6:	028a2503          	lw	a0,40(s4)
    800030aa:	f0ffe0ef          	jal	80001fb8 <bread>
    800030ae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800030b0:	000aa583          	lw	a1,0(s5)
    800030b4:	028a2503          	lw	a0,40(s4)
    800030b8:	f01fe0ef          	jal	80001fb8 <bread>
    800030bc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800030be:	40000613          	li	a2,1024
    800030c2:	05850593          	addi	a1,a0,88
    800030c6:	05848513          	addi	a0,s1,88
    800030ca:	8c6fd0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    800030ce:	8526                	mv	a0,s1
    800030d0:	fbffe0ef          	jal	8000208e <bwrite>
    brelse(from);
    800030d4:	854e                	mv	a0,s3
    800030d6:	febfe0ef          	jal	800020c0 <brelse>
    brelse(to);
    800030da:	8526                	mv	a0,s1
    800030dc:	fe5fe0ef          	jal	800020c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030e0:	2905                	addiw	s2,s2,1
    800030e2:	0a91                	addi	s5,s5,4
    800030e4:	02ca2783          	lw	a5,44(s4)
    800030e8:	faf94ae3          	blt	s2,a5,8000309c <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800030ec:	d11ff0ef          	jal	80002dfc <write_head>
    install_trans(0); // Now install writes to home locations
    800030f0:	4501                	li	a0,0
    800030f2:	d69ff0ef          	jal	80002e5a <install_trans>
    log.lh.n = 0;
    800030f6:	00017797          	auipc	a5,0x17
    800030fa:	5007ab23          	sw	zero,1302(a5) # 8001a60c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800030fe:	cffff0ef          	jal	80002dfc <write_head>
    80003102:	69e2                	ld	s3,24(sp)
    80003104:	6a42                	ld	s4,16(sp)
    80003106:	6aa2                	ld	s5,8(sp)
    80003108:	b735                	j	80003034 <end_op+0x44>

000000008000310a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000310a:	1101                	addi	sp,sp,-32
    8000310c:	ec06                	sd	ra,24(sp)
    8000310e:	e822                	sd	s0,16(sp)
    80003110:	e426                	sd	s1,8(sp)
    80003112:	e04a                	sd	s2,0(sp)
    80003114:	1000                	addi	s0,sp,32
    80003116:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003118:	00017917          	auipc	s2,0x17
    8000311c:	4c890913          	addi	s2,s2,1224 # 8001a5e0 <log>
    80003120:	854a                	mv	a0,s2
    80003122:	6ae020ef          	jal	800057d0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003126:	02c92603          	lw	a2,44(s2)
    8000312a:	47f5                	li	a5,29
    8000312c:	06c7c363          	blt	a5,a2,80003192 <log_write+0x88>
    80003130:	00017797          	auipc	a5,0x17
    80003134:	4cc7a783          	lw	a5,1228(a5) # 8001a5fc <log+0x1c>
    80003138:	37fd                	addiw	a5,a5,-1
    8000313a:	04f65c63          	bge	a2,a5,80003192 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000313e:	00017797          	auipc	a5,0x17
    80003142:	4c27a783          	lw	a5,1218(a5) # 8001a600 <log+0x20>
    80003146:	04f05c63          	blez	a5,8000319e <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000314a:	4781                	li	a5,0
    8000314c:	04c05f63          	blez	a2,800031aa <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003150:	44cc                	lw	a1,12(s1)
    80003152:	00017717          	auipc	a4,0x17
    80003156:	4be70713          	addi	a4,a4,1214 # 8001a610 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000315a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000315c:	4314                	lw	a3,0(a4)
    8000315e:	04b68663          	beq	a3,a1,800031aa <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003162:	2785                	addiw	a5,a5,1
    80003164:	0711                	addi	a4,a4,4
    80003166:	fef61be3          	bne	a2,a5,8000315c <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000316a:	0621                	addi	a2,a2,8
    8000316c:	060a                	slli	a2,a2,0x2
    8000316e:	00017797          	auipc	a5,0x17
    80003172:	47278793          	addi	a5,a5,1138 # 8001a5e0 <log>
    80003176:	97b2                	add	a5,a5,a2
    80003178:	44d8                	lw	a4,12(s1)
    8000317a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000317c:	8526                	mv	a0,s1
    8000317e:	fcbfe0ef          	jal	80002148 <bpin>
    log.lh.n++;
    80003182:	00017717          	auipc	a4,0x17
    80003186:	45e70713          	addi	a4,a4,1118 # 8001a5e0 <log>
    8000318a:	575c                	lw	a5,44(a4)
    8000318c:	2785                	addiw	a5,a5,1
    8000318e:	d75c                	sw	a5,44(a4)
    80003190:	a80d                	j	800031c2 <log_write+0xb8>
    panic("too big a transaction");
    80003192:	00004517          	auipc	a0,0x4
    80003196:	45650513          	addi	a0,a0,1110 # 800075e8 <etext+0x5e8>
    8000319a:	308020ef          	jal	800054a2 <panic>
    panic("log_write outside of trans");
    8000319e:	00004517          	auipc	a0,0x4
    800031a2:	46250513          	addi	a0,a0,1122 # 80007600 <etext+0x600>
    800031a6:	2fc020ef          	jal	800054a2 <panic>
  log.lh.block[i] = b->blockno;
    800031aa:	00878693          	addi	a3,a5,8
    800031ae:	068a                	slli	a3,a3,0x2
    800031b0:	00017717          	auipc	a4,0x17
    800031b4:	43070713          	addi	a4,a4,1072 # 8001a5e0 <log>
    800031b8:	9736                	add	a4,a4,a3
    800031ba:	44d4                	lw	a3,12(s1)
    800031bc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800031be:	faf60fe3          	beq	a2,a5,8000317c <log_write+0x72>
  }
  release(&log.lock);
    800031c2:	00017517          	auipc	a0,0x17
    800031c6:	41e50513          	addi	a0,a0,1054 # 8001a5e0 <log>
    800031ca:	69e020ef          	jal	80005868 <release>
}
    800031ce:	60e2                	ld	ra,24(sp)
    800031d0:	6442                	ld	s0,16(sp)
    800031d2:	64a2                	ld	s1,8(sp)
    800031d4:	6902                	ld	s2,0(sp)
    800031d6:	6105                	addi	sp,sp,32
    800031d8:	8082                	ret

00000000800031da <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800031da:	1101                	addi	sp,sp,-32
    800031dc:	ec06                	sd	ra,24(sp)
    800031de:	e822                	sd	s0,16(sp)
    800031e0:	e426                	sd	s1,8(sp)
    800031e2:	e04a                	sd	s2,0(sp)
    800031e4:	1000                	addi	s0,sp,32
    800031e6:	84aa                	mv	s1,a0
    800031e8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800031ea:	00004597          	auipc	a1,0x4
    800031ee:	43658593          	addi	a1,a1,1078 # 80007620 <etext+0x620>
    800031f2:	0521                	addi	a0,a0,8
    800031f4:	55c020ef          	jal	80005750 <initlock>
  lk->name = name;
    800031f8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800031fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003200:	0204a423          	sw	zero,40(s1)
}
    80003204:	60e2                	ld	ra,24(sp)
    80003206:	6442                	ld	s0,16(sp)
    80003208:	64a2                	ld	s1,8(sp)
    8000320a:	6902                	ld	s2,0(sp)
    8000320c:	6105                	addi	sp,sp,32
    8000320e:	8082                	ret

0000000080003210 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003210:	1101                	addi	sp,sp,-32
    80003212:	ec06                	sd	ra,24(sp)
    80003214:	e822                	sd	s0,16(sp)
    80003216:	e426                	sd	s1,8(sp)
    80003218:	e04a                	sd	s2,0(sp)
    8000321a:	1000                	addi	s0,sp,32
    8000321c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000321e:	00850913          	addi	s2,a0,8
    80003222:	854a                	mv	a0,s2
    80003224:	5ac020ef          	jal	800057d0 <acquire>
  while (lk->locked) {
    80003228:	409c                	lw	a5,0(s1)
    8000322a:	c799                	beqz	a5,80003238 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000322c:	85ca                	mv	a1,s2
    8000322e:	8526                	mv	a0,s1
    80003230:	900fe0ef          	jal	80001330 <sleep>
  while (lk->locked) {
    80003234:	409c                	lw	a5,0(s1)
    80003236:	fbfd                	bnez	a5,8000322c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003238:	4785                	li	a5,1
    8000323a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000323c:	b1bfd0ef          	jal	80000d56 <myproc>
    80003240:	591c                	lw	a5,48(a0)
    80003242:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003244:	854a                	mv	a0,s2
    80003246:	622020ef          	jal	80005868 <release>
}
    8000324a:	60e2                	ld	ra,24(sp)
    8000324c:	6442                	ld	s0,16(sp)
    8000324e:	64a2                	ld	s1,8(sp)
    80003250:	6902                	ld	s2,0(sp)
    80003252:	6105                	addi	sp,sp,32
    80003254:	8082                	ret

0000000080003256 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003256:	1101                	addi	sp,sp,-32
    80003258:	ec06                	sd	ra,24(sp)
    8000325a:	e822                	sd	s0,16(sp)
    8000325c:	e426                	sd	s1,8(sp)
    8000325e:	e04a                	sd	s2,0(sp)
    80003260:	1000                	addi	s0,sp,32
    80003262:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003264:	00850913          	addi	s2,a0,8
    80003268:	854a                	mv	a0,s2
    8000326a:	566020ef          	jal	800057d0 <acquire>
  lk->locked = 0;
    8000326e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003272:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003276:	8526                	mv	a0,s1
    80003278:	904fe0ef          	jal	8000137c <wakeup>
  release(&lk->lk);
    8000327c:	854a                	mv	a0,s2
    8000327e:	5ea020ef          	jal	80005868 <release>
}
    80003282:	60e2                	ld	ra,24(sp)
    80003284:	6442                	ld	s0,16(sp)
    80003286:	64a2                	ld	s1,8(sp)
    80003288:	6902                	ld	s2,0(sp)
    8000328a:	6105                	addi	sp,sp,32
    8000328c:	8082                	ret

000000008000328e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000328e:	7179                	addi	sp,sp,-48
    80003290:	f406                	sd	ra,40(sp)
    80003292:	f022                	sd	s0,32(sp)
    80003294:	ec26                	sd	s1,24(sp)
    80003296:	e84a                	sd	s2,16(sp)
    80003298:	1800                	addi	s0,sp,48
    8000329a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000329c:	00850913          	addi	s2,a0,8
    800032a0:	854a                	mv	a0,s2
    800032a2:	52e020ef          	jal	800057d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800032a6:	409c                	lw	a5,0(s1)
    800032a8:	ef81                	bnez	a5,800032c0 <holdingsleep+0x32>
    800032aa:	4481                	li	s1,0
  release(&lk->lk);
    800032ac:	854a                	mv	a0,s2
    800032ae:	5ba020ef          	jal	80005868 <release>
  return r;
}
    800032b2:	8526                	mv	a0,s1
    800032b4:	70a2                	ld	ra,40(sp)
    800032b6:	7402                	ld	s0,32(sp)
    800032b8:	64e2                	ld	s1,24(sp)
    800032ba:	6942                	ld	s2,16(sp)
    800032bc:	6145                	addi	sp,sp,48
    800032be:	8082                	ret
    800032c0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800032c2:	0284a983          	lw	s3,40(s1)
    800032c6:	a91fd0ef          	jal	80000d56 <myproc>
    800032ca:	5904                	lw	s1,48(a0)
    800032cc:	413484b3          	sub	s1,s1,s3
    800032d0:	0014b493          	seqz	s1,s1
    800032d4:	69a2                	ld	s3,8(sp)
    800032d6:	bfd9                	j	800032ac <holdingsleep+0x1e>

00000000800032d8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800032d8:	1141                	addi	sp,sp,-16
    800032da:	e406                	sd	ra,8(sp)
    800032dc:	e022                	sd	s0,0(sp)
    800032de:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800032e0:	00004597          	auipc	a1,0x4
    800032e4:	35058593          	addi	a1,a1,848 # 80007630 <etext+0x630>
    800032e8:	00017517          	auipc	a0,0x17
    800032ec:	44050513          	addi	a0,a0,1088 # 8001a728 <ftable>
    800032f0:	460020ef          	jal	80005750 <initlock>
}
    800032f4:	60a2                	ld	ra,8(sp)
    800032f6:	6402                	ld	s0,0(sp)
    800032f8:	0141                	addi	sp,sp,16
    800032fa:	8082                	ret

00000000800032fc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800032fc:	1101                	addi	sp,sp,-32
    800032fe:	ec06                	sd	ra,24(sp)
    80003300:	e822                	sd	s0,16(sp)
    80003302:	e426                	sd	s1,8(sp)
    80003304:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003306:	00017517          	auipc	a0,0x17
    8000330a:	42250513          	addi	a0,a0,1058 # 8001a728 <ftable>
    8000330e:	4c2020ef          	jal	800057d0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003312:	00017497          	auipc	s1,0x17
    80003316:	42e48493          	addi	s1,s1,1070 # 8001a740 <ftable+0x18>
    8000331a:	00018717          	auipc	a4,0x18
    8000331e:	3c670713          	addi	a4,a4,966 # 8001b6e0 <disk>
    if(f->ref == 0){
    80003322:	40dc                	lw	a5,4(s1)
    80003324:	cf89                	beqz	a5,8000333e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003326:	02848493          	addi	s1,s1,40
    8000332a:	fee49ce3          	bne	s1,a4,80003322 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000332e:	00017517          	auipc	a0,0x17
    80003332:	3fa50513          	addi	a0,a0,1018 # 8001a728 <ftable>
    80003336:	532020ef          	jal	80005868 <release>
  return 0;
    8000333a:	4481                	li	s1,0
    8000333c:	a809                	j	8000334e <filealloc+0x52>
      f->ref = 1;
    8000333e:	4785                	li	a5,1
    80003340:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003342:	00017517          	auipc	a0,0x17
    80003346:	3e650513          	addi	a0,a0,998 # 8001a728 <ftable>
    8000334a:	51e020ef          	jal	80005868 <release>
}
    8000334e:	8526                	mv	a0,s1
    80003350:	60e2                	ld	ra,24(sp)
    80003352:	6442                	ld	s0,16(sp)
    80003354:	64a2                	ld	s1,8(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret

000000008000335a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000335a:	1101                	addi	sp,sp,-32
    8000335c:	ec06                	sd	ra,24(sp)
    8000335e:	e822                	sd	s0,16(sp)
    80003360:	e426                	sd	s1,8(sp)
    80003362:	1000                	addi	s0,sp,32
    80003364:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003366:	00017517          	auipc	a0,0x17
    8000336a:	3c250513          	addi	a0,a0,962 # 8001a728 <ftable>
    8000336e:	462020ef          	jal	800057d0 <acquire>
  if(f->ref < 1)
    80003372:	40dc                	lw	a5,4(s1)
    80003374:	02f05063          	blez	a5,80003394 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003378:	2785                	addiw	a5,a5,1
    8000337a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000337c:	00017517          	auipc	a0,0x17
    80003380:	3ac50513          	addi	a0,a0,940 # 8001a728 <ftable>
    80003384:	4e4020ef          	jal	80005868 <release>
  return f;
}
    80003388:	8526                	mv	a0,s1
    8000338a:	60e2                	ld	ra,24(sp)
    8000338c:	6442                	ld	s0,16(sp)
    8000338e:	64a2                	ld	s1,8(sp)
    80003390:	6105                	addi	sp,sp,32
    80003392:	8082                	ret
    panic("filedup");
    80003394:	00004517          	auipc	a0,0x4
    80003398:	2a450513          	addi	a0,a0,676 # 80007638 <etext+0x638>
    8000339c:	106020ef          	jal	800054a2 <panic>

00000000800033a0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800033a0:	7139                	addi	sp,sp,-64
    800033a2:	fc06                	sd	ra,56(sp)
    800033a4:	f822                	sd	s0,48(sp)
    800033a6:	f426                	sd	s1,40(sp)
    800033a8:	0080                	addi	s0,sp,64
    800033aa:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800033ac:	00017517          	auipc	a0,0x17
    800033b0:	37c50513          	addi	a0,a0,892 # 8001a728 <ftable>
    800033b4:	41c020ef          	jal	800057d0 <acquire>
  if(f->ref < 1)
    800033b8:	40dc                	lw	a5,4(s1)
    800033ba:	04f05a63          	blez	a5,8000340e <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800033be:	37fd                	addiw	a5,a5,-1
    800033c0:	0007871b          	sext.w	a4,a5
    800033c4:	c0dc                	sw	a5,4(s1)
    800033c6:	04e04e63          	bgtz	a4,80003422 <fileclose+0x82>
    800033ca:	f04a                	sd	s2,32(sp)
    800033cc:	ec4e                	sd	s3,24(sp)
    800033ce:	e852                	sd	s4,16(sp)
    800033d0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800033d2:	0004a903          	lw	s2,0(s1)
    800033d6:	0094ca83          	lbu	s5,9(s1)
    800033da:	0104ba03          	ld	s4,16(s1)
    800033de:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800033e2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800033e6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800033ea:	00017517          	auipc	a0,0x17
    800033ee:	33e50513          	addi	a0,a0,830 # 8001a728 <ftable>
    800033f2:	476020ef          	jal	80005868 <release>

  if(ff.type == FD_PIPE){
    800033f6:	4785                	li	a5,1
    800033f8:	04f90063          	beq	s2,a5,80003438 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800033fc:	3979                	addiw	s2,s2,-2
    800033fe:	4785                	li	a5,1
    80003400:	0527f563          	bgeu	a5,s2,8000344a <fileclose+0xaa>
    80003404:	7902                	ld	s2,32(sp)
    80003406:	69e2                	ld	s3,24(sp)
    80003408:	6a42                	ld	s4,16(sp)
    8000340a:	6aa2                	ld	s5,8(sp)
    8000340c:	a00d                	j	8000342e <fileclose+0x8e>
    8000340e:	f04a                	sd	s2,32(sp)
    80003410:	ec4e                	sd	s3,24(sp)
    80003412:	e852                	sd	s4,16(sp)
    80003414:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003416:	00004517          	auipc	a0,0x4
    8000341a:	22a50513          	addi	a0,a0,554 # 80007640 <etext+0x640>
    8000341e:	084020ef          	jal	800054a2 <panic>
    release(&ftable.lock);
    80003422:	00017517          	auipc	a0,0x17
    80003426:	30650513          	addi	a0,a0,774 # 8001a728 <ftable>
    8000342a:	43e020ef          	jal	80005868 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000342e:	70e2                	ld	ra,56(sp)
    80003430:	7442                	ld	s0,48(sp)
    80003432:	74a2                	ld	s1,40(sp)
    80003434:	6121                	addi	sp,sp,64
    80003436:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003438:	85d6                	mv	a1,s5
    8000343a:	8552                	mv	a0,s4
    8000343c:	336000ef          	jal	80003772 <pipeclose>
    80003440:	7902                	ld	s2,32(sp)
    80003442:	69e2                	ld	s3,24(sp)
    80003444:	6a42                	ld	s4,16(sp)
    80003446:	6aa2                	ld	s5,8(sp)
    80003448:	b7dd                	j	8000342e <fileclose+0x8e>
    begin_op();
    8000344a:	b3dff0ef          	jal	80002f86 <begin_op>
    iput(ff.ip);
    8000344e:	854e                	mv	a0,s3
    80003450:	c22ff0ef          	jal	80002872 <iput>
    end_op();
    80003454:	b9dff0ef          	jal	80002ff0 <end_op>
    80003458:	7902                	ld	s2,32(sp)
    8000345a:	69e2                	ld	s3,24(sp)
    8000345c:	6a42                	ld	s4,16(sp)
    8000345e:	6aa2                	ld	s5,8(sp)
    80003460:	b7f9                	j	8000342e <fileclose+0x8e>

0000000080003462 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003462:	715d                	addi	sp,sp,-80
    80003464:	e486                	sd	ra,72(sp)
    80003466:	e0a2                	sd	s0,64(sp)
    80003468:	fc26                	sd	s1,56(sp)
    8000346a:	f44e                	sd	s3,40(sp)
    8000346c:	0880                	addi	s0,sp,80
    8000346e:	84aa                	mv	s1,a0
    80003470:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003472:	8e5fd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003476:	409c                	lw	a5,0(s1)
    80003478:	37f9                	addiw	a5,a5,-2
    8000347a:	4705                	li	a4,1
    8000347c:	04f76063          	bltu	a4,a5,800034bc <filestat+0x5a>
    80003480:	f84a                	sd	s2,48(sp)
    80003482:	892a                	mv	s2,a0
    ilock(f->ip);
    80003484:	6c88                	ld	a0,24(s1)
    80003486:	a6aff0ef          	jal	800026f0 <ilock>
    stati(f->ip, &st);
    8000348a:	fb840593          	addi	a1,s0,-72
    8000348e:	6c88                	ld	a0,24(s1)
    80003490:	c8aff0ef          	jal	8000291a <stati>
    iunlock(f->ip);
    80003494:	6c88                	ld	a0,24(s1)
    80003496:	b08ff0ef          	jal	8000279e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000349a:	46e1                	li	a3,24
    8000349c:	fb840613          	addi	a2,s0,-72
    800034a0:	85ce                	mv	a1,s3
    800034a2:	05093503          	ld	a0,80(s2)
    800034a6:	d20fd0ef          	jal	800009c6 <copyout>
    800034aa:	41f5551b          	sraiw	a0,a0,0x1f
    800034ae:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800034b0:	60a6                	ld	ra,72(sp)
    800034b2:	6406                	ld	s0,64(sp)
    800034b4:	74e2                	ld	s1,56(sp)
    800034b6:	79a2                	ld	s3,40(sp)
    800034b8:	6161                	addi	sp,sp,80
    800034ba:	8082                	ret
  return -1;
    800034bc:	557d                	li	a0,-1
    800034be:	bfcd                	j	800034b0 <filestat+0x4e>

00000000800034c0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800034c0:	7179                	addi	sp,sp,-48
    800034c2:	f406                	sd	ra,40(sp)
    800034c4:	f022                	sd	s0,32(sp)
    800034c6:	e84a                	sd	s2,16(sp)
    800034c8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800034ca:	00854783          	lbu	a5,8(a0)
    800034ce:	cfd1                	beqz	a5,8000356a <fileread+0xaa>
    800034d0:	ec26                	sd	s1,24(sp)
    800034d2:	e44e                	sd	s3,8(sp)
    800034d4:	84aa                	mv	s1,a0
    800034d6:	89ae                	mv	s3,a1
    800034d8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800034da:	411c                	lw	a5,0(a0)
    800034dc:	4705                	li	a4,1
    800034de:	04e78363          	beq	a5,a4,80003524 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034e2:	470d                	li	a4,3
    800034e4:	04e78763          	beq	a5,a4,80003532 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800034e8:	4709                	li	a4,2
    800034ea:	06e79a63          	bne	a5,a4,8000355e <fileread+0x9e>
    ilock(f->ip);
    800034ee:	6d08                	ld	a0,24(a0)
    800034f0:	a00ff0ef          	jal	800026f0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800034f4:	874a                	mv	a4,s2
    800034f6:	5094                	lw	a3,32(s1)
    800034f8:	864e                	mv	a2,s3
    800034fa:	4585                	li	a1,1
    800034fc:	6c88                	ld	a0,24(s1)
    800034fe:	c46ff0ef          	jal	80002944 <readi>
    80003502:	892a                	mv	s2,a0
    80003504:	00a05563          	blez	a0,8000350e <fileread+0x4e>
      f->off += r;
    80003508:	509c                	lw	a5,32(s1)
    8000350a:	9fa9                	addw	a5,a5,a0
    8000350c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000350e:	6c88                	ld	a0,24(s1)
    80003510:	a8eff0ef          	jal	8000279e <iunlock>
    80003514:	64e2                	ld	s1,24(sp)
    80003516:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003518:	854a                	mv	a0,s2
    8000351a:	70a2                	ld	ra,40(sp)
    8000351c:	7402                	ld	s0,32(sp)
    8000351e:	6942                	ld	s2,16(sp)
    80003520:	6145                	addi	sp,sp,48
    80003522:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003524:	6908                	ld	a0,16(a0)
    80003526:	388000ef          	jal	800038ae <piperead>
    8000352a:	892a                	mv	s2,a0
    8000352c:	64e2                	ld	s1,24(sp)
    8000352e:	69a2                	ld	s3,8(sp)
    80003530:	b7e5                	j	80003518 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003532:	02451783          	lh	a5,36(a0)
    80003536:	03079693          	slli	a3,a5,0x30
    8000353a:	92c1                	srli	a3,a3,0x30
    8000353c:	4725                	li	a4,9
    8000353e:	02d76863          	bltu	a4,a3,8000356e <fileread+0xae>
    80003542:	0792                	slli	a5,a5,0x4
    80003544:	00017717          	auipc	a4,0x17
    80003548:	14470713          	addi	a4,a4,324 # 8001a688 <devsw>
    8000354c:	97ba                	add	a5,a5,a4
    8000354e:	639c                	ld	a5,0(a5)
    80003550:	c39d                	beqz	a5,80003576 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003552:	4505                	li	a0,1
    80003554:	9782                	jalr	a5
    80003556:	892a                	mv	s2,a0
    80003558:	64e2                	ld	s1,24(sp)
    8000355a:	69a2                	ld	s3,8(sp)
    8000355c:	bf75                	j	80003518 <fileread+0x58>
    panic("fileread");
    8000355e:	00004517          	auipc	a0,0x4
    80003562:	0f250513          	addi	a0,a0,242 # 80007650 <etext+0x650>
    80003566:	73d010ef          	jal	800054a2 <panic>
    return -1;
    8000356a:	597d                	li	s2,-1
    8000356c:	b775                	j	80003518 <fileread+0x58>
      return -1;
    8000356e:	597d                	li	s2,-1
    80003570:	64e2                	ld	s1,24(sp)
    80003572:	69a2                	ld	s3,8(sp)
    80003574:	b755                	j	80003518 <fileread+0x58>
    80003576:	597d                	li	s2,-1
    80003578:	64e2                	ld	s1,24(sp)
    8000357a:	69a2                	ld	s3,8(sp)
    8000357c:	bf71                	j	80003518 <fileread+0x58>

000000008000357e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000357e:	00954783          	lbu	a5,9(a0)
    80003582:	10078b63          	beqz	a5,80003698 <filewrite+0x11a>
{
    80003586:	715d                	addi	sp,sp,-80
    80003588:	e486                	sd	ra,72(sp)
    8000358a:	e0a2                	sd	s0,64(sp)
    8000358c:	f84a                	sd	s2,48(sp)
    8000358e:	f052                	sd	s4,32(sp)
    80003590:	e85a                	sd	s6,16(sp)
    80003592:	0880                	addi	s0,sp,80
    80003594:	892a                	mv	s2,a0
    80003596:	8b2e                	mv	s6,a1
    80003598:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000359a:	411c                	lw	a5,0(a0)
    8000359c:	4705                	li	a4,1
    8000359e:	02e78763          	beq	a5,a4,800035cc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035a2:	470d                	li	a4,3
    800035a4:	02e78863          	beq	a5,a4,800035d4 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800035a8:	4709                	li	a4,2
    800035aa:	0ce79c63          	bne	a5,a4,80003682 <filewrite+0x104>
    800035ae:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800035b0:	0ac05863          	blez	a2,80003660 <filewrite+0xe2>
    800035b4:	fc26                	sd	s1,56(sp)
    800035b6:	ec56                	sd	s5,24(sp)
    800035b8:	e45e                	sd	s7,8(sp)
    800035ba:	e062                	sd	s8,0(sp)
    int i = 0;
    800035bc:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800035be:	6b85                	lui	s7,0x1
    800035c0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800035c4:	6c05                	lui	s8,0x1
    800035c6:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800035ca:	a8b5                	j	80003646 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800035cc:	6908                	ld	a0,16(a0)
    800035ce:	1fc000ef          	jal	800037ca <pipewrite>
    800035d2:	a04d                	j	80003674 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800035d4:	02451783          	lh	a5,36(a0)
    800035d8:	03079693          	slli	a3,a5,0x30
    800035dc:	92c1                	srli	a3,a3,0x30
    800035de:	4725                	li	a4,9
    800035e0:	0ad76e63          	bltu	a4,a3,8000369c <filewrite+0x11e>
    800035e4:	0792                	slli	a5,a5,0x4
    800035e6:	00017717          	auipc	a4,0x17
    800035ea:	0a270713          	addi	a4,a4,162 # 8001a688 <devsw>
    800035ee:	97ba                	add	a5,a5,a4
    800035f0:	679c                	ld	a5,8(a5)
    800035f2:	c7dd                	beqz	a5,800036a0 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800035f4:	4505                	li	a0,1
    800035f6:	9782                	jalr	a5
    800035f8:	a8b5                	j	80003674 <filewrite+0xf6>
      if(n1 > max)
    800035fa:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800035fe:	989ff0ef          	jal	80002f86 <begin_op>
      ilock(f->ip);
    80003602:	01893503          	ld	a0,24(s2)
    80003606:	8eaff0ef          	jal	800026f0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000360a:	8756                	mv	a4,s5
    8000360c:	02092683          	lw	a3,32(s2)
    80003610:	01698633          	add	a2,s3,s6
    80003614:	4585                	li	a1,1
    80003616:	01893503          	ld	a0,24(s2)
    8000361a:	c26ff0ef          	jal	80002a40 <writei>
    8000361e:	84aa                	mv	s1,a0
    80003620:	00a05763          	blez	a0,8000362e <filewrite+0xb0>
        f->off += r;
    80003624:	02092783          	lw	a5,32(s2)
    80003628:	9fa9                	addw	a5,a5,a0
    8000362a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000362e:	01893503          	ld	a0,24(s2)
    80003632:	96cff0ef          	jal	8000279e <iunlock>
      end_op();
    80003636:	9bbff0ef          	jal	80002ff0 <end_op>

      if(r != n1){
    8000363a:	029a9563          	bne	s5,s1,80003664 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000363e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003642:	0149da63          	bge	s3,s4,80003656 <filewrite+0xd8>
      int n1 = n - i;
    80003646:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000364a:	0004879b          	sext.w	a5,s1
    8000364e:	fafbd6e3          	bge	s7,a5,800035fa <filewrite+0x7c>
    80003652:	84e2                	mv	s1,s8
    80003654:	b75d                	j	800035fa <filewrite+0x7c>
    80003656:	74e2                	ld	s1,56(sp)
    80003658:	6ae2                	ld	s5,24(sp)
    8000365a:	6ba2                	ld	s7,8(sp)
    8000365c:	6c02                	ld	s8,0(sp)
    8000365e:	a039                	j	8000366c <filewrite+0xee>
    int i = 0;
    80003660:	4981                	li	s3,0
    80003662:	a029                	j	8000366c <filewrite+0xee>
    80003664:	74e2                	ld	s1,56(sp)
    80003666:	6ae2                	ld	s5,24(sp)
    80003668:	6ba2                	ld	s7,8(sp)
    8000366a:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000366c:	033a1c63          	bne	s4,s3,800036a4 <filewrite+0x126>
    80003670:	8552                	mv	a0,s4
    80003672:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003674:	60a6                	ld	ra,72(sp)
    80003676:	6406                	ld	s0,64(sp)
    80003678:	7942                	ld	s2,48(sp)
    8000367a:	7a02                	ld	s4,32(sp)
    8000367c:	6b42                	ld	s6,16(sp)
    8000367e:	6161                	addi	sp,sp,80
    80003680:	8082                	ret
    80003682:	fc26                	sd	s1,56(sp)
    80003684:	f44e                	sd	s3,40(sp)
    80003686:	ec56                	sd	s5,24(sp)
    80003688:	e45e                	sd	s7,8(sp)
    8000368a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000368c:	00004517          	auipc	a0,0x4
    80003690:	fd450513          	addi	a0,a0,-44 # 80007660 <etext+0x660>
    80003694:	60f010ef          	jal	800054a2 <panic>
    return -1;
    80003698:	557d                	li	a0,-1
}
    8000369a:	8082                	ret
      return -1;
    8000369c:	557d                	li	a0,-1
    8000369e:	bfd9                	j	80003674 <filewrite+0xf6>
    800036a0:	557d                	li	a0,-1
    800036a2:	bfc9                	j	80003674 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800036a4:	557d                	li	a0,-1
    800036a6:	79a2                	ld	s3,40(sp)
    800036a8:	b7f1                	j	80003674 <filewrite+0xf6>

00000000800036aa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800036aa:	7179                	addi	sp,sp,-48
    800036ac:	f406                	sd	ra,40(sp)
    800036ae:	f022                	sd	s0,32(sp)
    800036b0:	ec26                	sd	s1,24(sp)
    800036b2:	e052                	sd	s4,0(sp)
    800036b4:	1800                	addi	s0,sp,48
    800036b6:	84aa                	mv	s1,a0
    800036b8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800036ba:	0005b023          	sd	zero,0(a1)
    800036be:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800036c2:	c3bff0ef          	jal	800032fc <filealloc>
    800036c6:	e088                	sd	a0,0(s1)
    800036c8:	c549                	beqz	a0,80003752 <pipealloc+0xa8>
    800036ca:	c33ff0ef          	jal	800032fc <filealloc>
    800036ce:	00aa3023          	sd	a0,0(s4)
    800036d2:	cd25                	beqz	a0,8000374a <pipealloc+0xa0>
    800036d4:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800036d6:	a21fc0ef          	jal	800000f6 <kalloc>
    800036da:	892a                	mv	s2,a0
    800036dc:	c12d                	beqz	a0,8000373e <pipealloc+0x94>
    800036de:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800036e0:	4985                	li	s3,1
    800036e2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800036e6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800036ea:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800036ee:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800036f2:	00004597          	auipc	a1,0x4
    800036f6:	d1e58593          	addi	a1,a1,-738 # 80007410 <etext+0x410>
    800036fa:	056020ef          	jal	80005750 <initlock>
  (*f0)->type = FD_PIPE;
    800036fe:	609c                	ld	a5,0(s1)
    80003700:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003704:	609c                	ld	a5,0(s1)
    80003706:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000370a:	609c                	ld	a5,0(s1)
    8000370c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003710:	609c                	ld	a5,0(s1)
    80003712:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003716:	000a3783          	ld	a5,0(s4)
    8000371a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000371e:	000a3783          	ld	a5,0(s4)
    80003722:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003726:	000a3783          	ld	a5,0(s4)
    8000372a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000372e:	000a3783          	ld	a5,0(s4)
    80003732:	0127b823          	sd	s2,16(a5)
  return 0;
    80003736:	4501                	li	a0,0
    80003738:	6942                	ld	s2,16(sp)
    8000373a:	69a2                	ld	s3,8(sp)
    8000373c:	a01d                	j	80003762 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000373e:	6088                	ld	a0,0(s1)
    80003740:	c119                	beqz	a0,80003746 <pipealloc+0x9c>
    80003742:	6942                	ld	s2,16(sp)
    80003744:	a029                	j	8000374e <pipealloc+0xa4>
    80003746:	6942                	ld	s2,16(sp)
    80003748:	a029                	j	80003752 <pipealloc+0xa8>
    8000374a:	6088                	ld	a0,0(s1)
    8000374c:	c10d                	beqz	a0,8000376e <pipealloc+0xc4>
    fileclose(*f0);
    8000374e:	c53ff0ef          	jal	800033a0 <fileclose>
  if(*f1)
    80003752:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003756:	557d                	li	a0,-1
  if(*f1)
    80003758:	c789                	beqz	a5,80003762 <pipealloc+0xb8>
    fileclose(*f1);
    8000375a:	853e                	mv	a0,a5
    8000375c:	c45ff0ef          	jal	800033a0 <fileclose>
  return -1;
    80003760:	557d                	li	a0,-1
}
    80003762:	70a2                	ld	ra,40(sp)
    80003764:	7402                	ld	s0,32(sp)
    80003766:	64e2                	ld	s1,24(sp)
    80003768:	6a02                	ld	s4,0(sp)
    8000376a:	6145                	addi	sp,sp,48
    8000376c:	8082                	ret
  return -1;
    8000376e:	557d                	li	a0,-1
    80003770:	bfcd                	j	80003762 <pipealloc+0xb8>

0000000080003772 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003772:	1101                	addi	sp,sp,-32
    80003774:	ec06                	sd	ra,24(sp)
    80003776:	e822                	sd	s0,16(sp)
    80003778:	e426                	sd	s1,8(sp)
    8000377a:	e04a                	sd	s2,0(sp)
    8000377c:	1000                	addi	s0,sp,32
    8000377e:	84aa                	mv	s1,a0
    80003780:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003782:	04e020ef          	jal	800057d0 <acquire>
  if(writable){
    80003786:	02090763          	beqz	s2,800037b4 <pipeclose+0x42>
    pi->writeopen = 0;
    8000378a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000378e:	21848513          	addi	a0,s1,536
    80003792:	bebfd0ef          	jal	8000137c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003796:	2204b783          	ld	a5,544(s1)
    8000379a:	e785                	bnez	a5,800037c2 <pipeclose+0x50>
    release(&pi->lock);
    8000379c:	8526                	mv	a0,s1
    8000379e:	0ca020ef          	jal	80005868 <release>
    kfree((char*)pi);
    800037a2:	8526                	mv	a0,s1
    800037a4:	879fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800037a8:	60e2                	ld	ra,24(sp)
    800037aa:	6442                	ld	s0,16(sp)
    800037ac:	64a2                	ld	s1,8(sp)
    800037ae:	6902                	ld	s2,0(sp)
    800037b0:	6105                	addi	sp,sp,32
    800037b2:	8082                	ret
    pi->readopen = 0;
    800037b4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800037b8:	21c48513          	addi	a0,s1,540
    800037bc:	bc1fd0ef          	jal	8000137c <wakeup>
    800037c0:	bfd9                	j	80003796 <pipeclose+0x24>
    release(&pi->lock);
    800037c2:	8526                	mv	a0,s1
    800037c4:	0a4020ef          	jal	80005868 <release>
}
    800037c8:	b7c5                	j	800037a8 <pipeclose+0x36>

00000000800037ca <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800037ca:	711d                	addi	sp,sp,-96
    800037cc:	ec86                	sd	ra,88(sp)
    800037ce:	e8a2                	sd	s0,80(sp)
    800037d0:	e4a6                	sd	s1,72(sp)
    800037d2:	e0ca                	sd	s2,64(sp)
    800037d4:	fc4e                	sd	s3,56(sp)
    800037d6:	f852                	sd	s4,48(sp)
    800037d8:	f456                	sd	s5,40(sp)
    800037da:	1080                	addi	s0,sp,96
    800037dc:	84aa                	mv	s1,a0
    800037de:	8aae                	mv	s5,a1
    800037e0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800037e2:	d74fd0ef          	jal	80000d56 <myproc>
    800037e6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800037e8:	8526                	mv	a0,s1
    800037ea:	7e7010ef          	jal	800057d0 <acquire>
  while(i < n){
    800037ee:	0b405a63          	blez	s4,800038a2 <pipewrite+0xd8>
    800037f2:	f05a                	sd	s6,32(sp)
    800037f4:	ec5e                	sd	s7,24(sp)
    800037f6:	e862                	sd	s8,16(sp)
  int i = 0;
    800037f8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037fa:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800037fc:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003800:	21c48b93          	addi	s7,s1,540
    80003804:	a81d                	j	8000383a <pipewrite+0x70>
      release(&pi->lock);
    80003806:	8526                	mv	a0,s1
    80003808:	060020ef          	jal	80005868 <release>
      return -1;
    8000380c:	597d                	li	s2,-1
    8000380e:	7b02                	ld	s6,32(sp)
    80003810:	6be2                	ld	s7,24(sp)
    80003812:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003814:	854a                	mv	a0,s2
    80003816:	60e6                	ld	ra,88(sp)
    80003818:	6446                	ld	s0,80(sp)
    8000381a:	64a6                	ld	s1,72(sp)
    8000381c:	6906                	ld	s2,64(sp)
    8000381e:	79e2                	ld	s3,56(sp)
    80003820:	7a42                	ld	s4,48(sp)
    80003822:	7aa2                	ld	s5,40(sp)
    80003824:	6125                	addi	sp,sp,96
    80003826:	8082                	ret
      wakeup(&pi->nread);
    80003828:	8562                	mv	a0,s8
    8000382a:	b53fd0ef          	jal	8000137c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000382e:	85a6                	mv	a1,s1
    80003830:	855e                	mv	a0,s7
    80003832:	afffd0ef          	jal	80001330 <sleep>
  while(i < n){
    80003836:	05495b63          	bge	s2,s4,8000388c <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000383a:	2204a783          	lw	a5,544(s1)
    8000383e:	d7e1                	beqz	a5,80003806 <pipewrite+0x3c>
    80003840:	854e                	mv	a0,s3
    80003842:	d27fd0ef          	jal	80001568 <killed>
    80003846:	f161                	bnez	a0,80003806 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003848:	2184a783          	lw	a5,536(s1)
    8000384c:	21c4a703          	lw	a4,540(s1)
    80003850:	2007879b          	addiw	a5,a5,512
    80003854:	fcf70ae3          	beq	a4,a5,80003828 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003858:	4685                	li	a3,1
    8000385a:	01590633          	add	a2,s2,s5
    8000385e:	faf40593          	addi	a1,s0,-81
    80003862:	0509b503          	ld	a0,80(s3)
    80003866:	a38fd0ef          	jal	80000a9e <copyin>
    8000386a:	03650e63          	beq	a0,s6,800038a6 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000386e:	21c4a783          	lw	a5,540(s1)
    80003872:	0017871b          	addiw	a4,a5,1
    80003876:	20e4ae23          	sw	a4,540(s1)
    8000387a:	1ff7f793          	andi	a5,a5,511
    8000387e:	97a6                	add	a5,a5,s1
    80003880:	faf44703          	lbu	a4,-81(s0)
    80003884:	00e78c23          	sb	a4,24(a5)
      i++;
    80003888:	2905                	addiw	s2,s2,1
    8000388a:	b775                	j	80003836 <pipewrite+0x6c>
    8000388c:	7b02                	ld	s6,32(sp)
    8000388e:	6be2                	ld	s7,24(sp)
    80003890:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003892:	21848513          	addi	a0,s1,536
    80003896:	ae7fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    8000389a:	8526                	mv	a0,s1
    8000389c:	7cd010ef          	jal	80005868 <release>
  return i;
    800038a0:	bf95                	j	80003814 <pipewrite+0x4a>
  int i = 0;
    800038a2:	4901                	li	s2,0
    800038a4:	b7fd                	j	80003892 <pipewrite+0xc8>
    800038a6:	7b02                	ld	s6,32(sp)
    800038a8:	6be2                	ld	s7,24(sp)
    800038aa:	6c42                	ld	s8,16(sp)
    800038ac:	b7dd                	j	80003892 <pipewrite+0xc8>

00000000800038ae <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800038ae:	715d                	addi	sp,sp,-80
    800038b0:	e486                	sd	ra,72(sp)
    800038b2:	e0a2                	sd	s0,64(sp)
    800038b4:	fc26                	sd	s1,56(sp)
    800038b6:	f84a                	sd	s2,48(sp)
    800038b8:	f44e                	sd	s3,40(sp)
    800038ba:	f052                	sd	s4,32(sp)
    800038bc:	ec56                	sd	s5,24(sp)
    800038be:	0880                	addi	s0,sp,80
    800038c0:	84aa                	mv	s1,a0
    800038c2:	892e                	mv	s2,a1
    800038c4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800038c6:	c90fd0ef          	jal	80000d56 <myproc>
    800038ca:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800038cc:	8526                	mv	a0,s1
    800038ce:	703010ef          	jal	800057d0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038d2:	2184a703          	lw	a4,536(s1)
    800038d6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038da:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038de:	02f71563          	bne	a4,a5,80003908 <piperead+0x5a>
    800038e2:	2244a783          	lw	a5,548(s1)
    800038e6:	cb85                	beqz	a5,80003916 <piperead+0x68>
    if(killed(pr)){
    800038e8:	8552                	mv	a0,s4
    800038ea:	c7ffd0ef          	jal	80001568 <killed>
    800038ee:	ed19                	bnez	a0,8000390c <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038f0:	85a6                	mv	a1,s1
    800038f2:	854e                	mv	a0,s3
    800038f4:	a3dfd0ef          	jal	80001330 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038f8:	2184a703          	lw	a4,536(s1)
    800038fc:	21c4a783          	lw	a5,540(s1)
    80003900:	fef701e3          	beq	a4,a5,800038e2 <piperead+0x34>
    80003904:	e85a                	sd	s6,16(sp)
    80003906:	a809                	j	80003918 <piperead+0x6a>
    80003908:	e85a                	sd	s6,16(sp)
    8000390a:	a039                	j	80003918 <piperead+0x6a>
      release(&pi->lock);
    8000390c:	8526                	mv	a0,s1
    8000390e:	75b010ef          	jal	80005868 <release>
      return -1;
    80003912:	59fd                	li	s3,-1
    80003914:	a8b1                	j	80003970 <piperead+0xc2>
    80003916:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003918:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000391a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000391c:	05505263          	blez	s5,80003960 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003920:	2184a783          	lw	a5,536(s1)
    80003924:	21c4a703          	lw	a4,540(s1)
    80003928:	02f70c63          	beq	a4,a5,80003960 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000392c:	0017871b          	addiw	a4,a5,1
    80003930:	20e4ac23          	sw	a4,536(s1)
    80003934:	1ff7f793          	andi	a5,a5,511
    80003938:	97a6                	add	a5,a5,s1
    8000393a:	0187c783          	lbu	a5,24(a5)
    8000393e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003942:	4685                	li	a3,1
    80003944:	fbf40613          	addi	a2,s0,-65
    80003948:	85ca                	mv	a1,s2
    8000394a:	050a3503          	ld	a0,80(s4)
    8000394e:	878fd0ef          	jal	800009c6 <copyout>
    80003952:	01650763          	beq	a0,s6,80003960 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003956:	2985                	addiw	s3,s3,1
    80003958:	0905                	addi	s2,s2,1
    8000395a:	fd3a93e3          	bne	s5,s3,80003920 <piperead+0x72>
    8000395e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003960:	21c48513          	addi	a0,s1,540
    80003964:	a19fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    80003968:	8526                	mv	a0,s1
    8000396a:	6ff010ef          	jal	80005868 <release>
    8000396e:	6b42                	ld	s6,16(sp)
  return i;
}
    80003970:	854e                	mv	a0,s3
    80003972:	60a6                	ld	ra,72(sp)
    80003974:	6406                	ld	s0,64(sp)
    80003976:	74e2                	ld	s1,56(sp)
    80003978:	7942                	ld	s2,48(sp)
    8000397a:	79a2                	ld	s3,40(sp)
    8000397c:	7a02                	ld	s4,32(sp)
    8000397e:	6ae2                	ld	s5,24(sp)
    80003980:	6161                	addi	sp,sp,80
    80003982:	8082                	ret

0000000080003984 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003984:	1141                	addi	sp,sp,-16
    80003986:	e422                	sd	s0,8(sp)
    80003988:	0800                	addi	s0,sp,16
    8000398a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000398c:	8905                	andi	a0,a0,1
    8000398e:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003990:	8b89                	andi	a5,a5,2
    80003992:	c399                	beqz	a5,80003998 <flags2perm+0x14>
      perm |= PTE_W;
    80003994:	00456513          	ori	a0,a0,4
    return perm;
}
    80003998:	6422                	ld	s0,8(sp)
    8000399a:	0141                	addi	sp,sp,16
    8000399c:	8082                	ret

000000008000399e <exec>:

int
exec(char *path, char **argv)
{
    8000399e:	df010113          	addi	sp,sp,-528
    800039a2:	20113423          	sd	ra,520(sp)
    800039a6:	20813023          	sd	s0,512(sp)
    800039aa:	ffa6                	sd	s1,504(sp)
    800039ac:	fbca                	sd	s2,496(sp)
    800039ae:	0c00                	addi	s0,sp,528
    800039b0:	892a                	mv	s2,a0
    800039b2:	dea43c23          	sd	a0,-520(s0)
    800039b6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800039ba:	b9cfd0ef          	jal	80000d56 <myproc>
    800039be:	84aa                	mv	s1,a0

  begin_op();
    800039c0:	dc6ff0ef          	jal	80002f86 <begin_op>

  if((ip = namei(path)) == 0){
    800039c4:	854a                	mv	a0,s2
    800039c6:	c04ff0ef          	jal	80002dca <namei>
    800039ca:	c931                	beqz	a0,80003a1e <exec+0x80>
    800039cc:	f3d2                	sd	s4,480(sp)
    800039ce:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800039d0:	d21fe0ef          	jal	800026f0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800039d4:	04000713          	li	a4,64
    800039d8:	4681                	li	a3,0
    800039da:	e5040613          	addi	a2,s0,-432
    800039de:	4581                	li	a1,0
    800039e0:	8552                	mv	a0,s4
    800039e2:	f63fe0ef          	jal	80002944 <readi>
    800039e6:	04000793          	li	a5,64
    800039ea:	00f51a63          	bne	a0,a5,800039fe <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800039ee:	e5042703          	lw	a4,-432(s0)
    800039f2:	464c47b7          	lui	a5,0x464c4
    800039f6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800039fa:	02f70663          	beq	a4,a5,80003a26 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800039fe:	8552                	mv	a0,s4
    80003a00:	efbfe0ef          	jal	800028fa <iunlockput>
    end_op();
    80003a04:	decff0ef          	jal	80002ff0 <end_op>
  }
  return -1;
    80003a08:	557d                	li	a0,-1
    80003a0a:	7a1e                	ld	s4,480(sp)
}
    80003a0c:	20813083          	ld	ra,520(sp)
    80003a10:	20013403          	ld	s0,512(sp)
    80003a14:	74fe                	ld	s1,504(sp)
    80003a16:	795e                	ld	s2,496(sp)
    80003a18:	21010113          	addi	sp,sp,528
    80003a1c:	8082                	ret
    end_op();
    80003a1e:	dd2ff0ef          	jal	80002ff0 <end_op>
    return -1;
    80003a22:	557d                	li	a0,-1
    80003a24:	b7e5                	j	80003a0c <exec+0x6e>
    80003a26:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003a28:	8526                	mv	a0,s1
    80003a2a:	bd4fd0ef          	jal	80000dfe <proc_pagetable>
    80003a2e:	8b2a                	mv	s6,a0
    80003a30:	2c050b63          	beqz	a0,80003d06 <exec+0x368>
    80003a34:	f7ce                	sd	s3,488(sp)
    80003a36:	efd6                	sd	s5,472(sp)
    80003a38:	e7de                	sd	s7,456(sp)
    80003a3a:	e3e2                	sd	s8,448(sp)
    80003a3c:	ff66                	sd	s9,440(sp)
    80003a3e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a40:	e7042d03          	lw	s10,-400(s0)
    80003a44:	e8845783          	lhu	a5,-376(s0)
    80003a48:	12078963          	beqz	a5,80003b7a <exec+0x1dc>
    80003a4c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003a4e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a50:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003a52:	6c85                	lui	s9,0x1
    80003a54:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003a58:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003a5c:	6a85                	lui	s5,0x1
    80003a5e:	a085                	j	80003abe <exec+0x120>
      panic("loadseg: address should exist");
    80003a60:	00004517          	auipc	a0,0x4
    80003a64:	c1050513          	addi	a0,a0,-1008 # 80007670 <etext+0x670>
    80003a68:	23b010ef          	jal	800054a2 <panic>
    if(sz - i < PGSIZE)
    80003a6c:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003a6e:	8726                	mv	a4,s1
    80003a70:	012c06bb          	addw	a3,s8,s2
    80003a74:	4581                	li	a1,0
    80003a76:	8552                	mv	a0,s4
    80003a78:	ecdfe0ef          	jal	80002944 <readi>
    80003a7c:	2501                	sext.w	a0,a0
    80003a7e:	24a49a63          	bne	s1,a0,80003cd2 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003a82:	012a893b          	addw	s2,s5,s2
    80003a86:	03397363          	bgeu	s2,s3,80003aac <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003a8a:	02091593          	slli	a1,s2,0x20
    80003a8e:	9181                	srli	a1,a1,0x20
    80003a90:	95de                	add	a1,a1,s7
    80003a92:	855a                	mv	a0,s6
    80003a94:	9affc0ef          	jal	80000442 <walkaddr>
    80003a98:	862a                	mv	a2,a0
    if(pa == 0)
    80003a9a:	d179                	beqz	a0,80003a60 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003a9c:	412984bb          	subw	s1,s3,s2
    80003aa0:	0004879b          	sext.w	a5,s1
    80003aa4:	fcfcf4e3          	bgeu	s9,a5,80003a6c <exec+0xce>
    80003aa8:	84d6                	mv	s1,s5
    80003aaa:	b7c9                	j	80003a6c <exec+0xce>
    sz = sz1;
    80003aac:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ab0:	2d85                	addiw	s11,s11,1
    80003ab2:	038d0d1b          	addiw	s10,s10,56
    80003ab6:	e8845783          	lhu	a5,-376(s0)
    80003aba:	08fdd063          	bge	s11,a5,80003b3a <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003abe:	2d01                	sext.w	s10,s10
    80003ac0:	03800713          	li	a4,56
    80003ac4:	86ea                	mv	a3,s10
    80003ac6:	e1840613          	addi	a2,s0,-488
    80003aca:	4581                	li	a1,0
    80003acc:	8552                	mv	a0,s4
    80003ace:	e77fe0ef          	jal	80002944 <readi>
    80003ad2:	03800793          	li	a5,56
    80003ad6:	1cf51663          	bne	a0,a5,80003ca2 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003ada:	e1842783          	lw	a5,-488(s0)
    80003ade:	4705                	li	a4,1
    80003ae0:	fce798e3          	bne	a5,a4,80003ab0 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003ae4:	e4043483          	ld	s1,-448(s0)
    80003ae8:	e3843783          	ld	a5,-456(s0)
    80003aec:	1af4ef63          	bltu	s1,a5,80003caa <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003af0:	e2843783          	ld	a5,-472(s0)
    80003af4:	94be                	add	s1,s1,a5
    80003af6:	1af4ee63          	bltu	s1,a5,80003cb2 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003afa:	df043703          	ld	a4,-528(s0)
    80003afe:	8ff9                	and	a5,a5,a4
    80003b00:	1a079d63          	bnez	a5,80003cba <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b04:	e1c42503          	lw	a0,-484(s0)
    80003b08:	e7dff0ef          	jal	80003984 <flags2perm>
    80003b0c:	86aa                	mv	a3,a0
    80003b0e:	8626                	mv	a2,s1
    80003b10:	85ca                	mv	a1,s2
    80003b12:	855a                	mv	a0,s6
    80003b14:	ca7fc0ef          	jal	800007ba <uvmalloc>
    80003b18:	e0a43423          	sd	a0,-504(s0)
    80003b1c:	1a050363          	beqz	a0,80003cc2 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b20:	e2843b83          	ld	s7,-472(s0)
    80003b24:	e2042c03          	lw	s8,-480(s0)
    80003b28:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003b2c:	00098463          	beqz	s3,80003b34 <exec+0x196>
    80003b30:	4901                	li	s2,0
    80003b32:	bfa1                	j	80003a8a <exec+0xec>
    sz = sz1;
    80003b34:	e0843903          	ld	s2,-504(s0)
    80003b38:	bfa5                	j	80003ab0 <exec+0x112>
    80003b3a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003b3c:	8552                	mv	a0,s4
    80003b3e:	dbdfe0ef          	jal	800028fa <iunlockput>
  end_op();
    80003b42:	caeff0ef          	jal	80002ff0 <end_op>
  p = myproc();
    80003b46:	a10fd0ef          	jal	80000d56 <myproc>
    80003b4a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003b4c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003b50:	6985                	lui	s3,0x1
    80003b52:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003b54:	99ca                	add	s3,s3,s2
    80003b56:	77fd                	lui	a5,0xfffff
    80003b58:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003b5c:	4691                	li	a3,4
    80003b5e:	6609                	lui	a2,0x2
    80003b60:	964e                	add	a2,a2,s3
    80003b62:	85ce                	mv	a1,s3
    80003b64:	855a                	mv	a0,s6
    80003b66:	c55fc0ef          	jal	800007ba <uvmalloc>
    80003b6a:	892a                	mv	s2,a0
    80003b6c:	e0a43423          	sd	a0,-504(s0)
    80003b70:	e519                	bnez	a0,80003b7e <exec+0x1e0>
  if(pagetable)
    80003b72:	e1343423          	sd	s3,-504(s0)
    80003b76:	4a01                	li	s4,0
    80003b78:	aab1                	j	80003cd4 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b7a:	4901                	li	s2,0
    80003b7c:	b7c1                	j	80003b3c <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003b7e:	75f9                	lui	a1,0xffffe
    80003b80:	95aa                	add	a1,a1,a0
    80003b82:	855a                	mv	a0,s6
    80003b84:	e19fc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003b88:	7bfd                	lui	s7,0xfffff
    80003b8a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003b8c:	e0043783          	ld	a5,-512(s0)
    80003b90:	6388                	ld	a0,0(a5)
    80003b92:	cd39                	beqz	a0,80003bf0 <exec+0x252>
    80003b94:	e9040993          	addi	s3,s0,-368
    80003b98:	f9040c13          	addi	s8,s0,-112
    80003b9c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003b9e:	f06fc0ef          	jal	800002a4 <strlen>
    80003ba2:	0015079b          	addiw	a5,a0,1
    80003ba6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003baa:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003bae:	11796e63          	bltu	s2,s7,80003cca <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003bb2:	e0043d03          	ld	s10,-512(s0)
    80003bb6:	000d3a03          	ld	s4,0(s10)
    80003bba:	8552                	mv	a0,s4
    80003bbc:	ee8fc0ef          	jal	800002a4 <strlen>
    80003bc0:	0015069b          	addiw	a3,a0,1
    80003bc4:	8652                	mv	a2,s4
    80003bc6:	85ca                	mv	a1,s2
    80003bc8:	855a                	mv	a0,s6
    80003bca:	dfdfc0ef          	jal	800009c6 <copyout>
    80003bce:	10054063          	bltz	a0,80003cce <exec+0x330>
    ustack[argc] = sp;
    80003bd2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003bd6:	0485                	addi	s1,s1,1
    80003bd8:	008d0793          	addi	a5,s10,8
    80003bdc:	e0f43023          	sd	a5,-512(s0)
    80003be0:	008d3503          	ld	a0,8(s10)
    80003be4:	c909                	beqz	a0,80003bf6 <exec+0x258>
    if(argc >= MAXARG)
    80003be6:	09a1                	addi	s3,s3,8
    80003be8:	fb899be3          	bne	s3,s8,80003b9e <exec+0x200>
  ip = 0;
    80003bec:	4a01                	li	s4,0
    80003bee:	a0dd                	j	80003cd4 <exec+0x336>
  sp = sz;
    80003bf0:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003bf4:	4481                	li	s1,0
  ustack[argc] = 0;
    80003bf6:	00349793          	slli	a5,s1,0x3
    80003bfa:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb670>
    80003bfe:	97a2                	add	a5,a5,s0
    80003c00:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c04:	00148693          	addi	a3,s1,1
    80003c08:	068e                	slli	a3,a3,0x3
    80003c0a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c0e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003c12:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003c16:	f5796ee3          	bltu	s2,s7,80003b72 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c1a:	e9040613          	addi	a2,s0,-368
    80003c1e:	85ca                	mv	a1,s2
    80003c20:	855a                	mv	a0,s6
    80003c22:	da5fc0ef          	jal	800009c6 <copyout>
    80003c26:	0e054263          	bltz	a0,80003d0a <exec+0x36c>
  p->trapframe->a1 = sp;
    80003c2a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003c2e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c32:	df843783          	ld	a5,-520(s0)
    80003c36:	0007c703          	lbu	a4,0(a5)
    80003c3a:	cf11                	beqz	a4,80003c56 <exec+0x2b8>
    80003c3c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003c3e:	02f00693          	li	a3,47
    80003c42:	a039                	j	80003c50 <exec+0x2b2>
      last = s+1;
    80003c44:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003c48:	0785                	addi	a5,a5,1
    80003c4a:	fff7c703          	lbu	a4,-1(a5)
    80003c4e:	c701                	beqz	a4,80003c56 <exec+0x2b8>
    if(*s == '/')
    80003c50:	fed71ce3          	bne	a4,a3,80003c48 <exec+0x2aa>
    80003c54:	bfc5                	j	80003c44 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003c56:	4641                	li	a2,16
    80003c58:	df843583          	ld	a1,-520(s0)
    80003c5c:	158a8513          	addi	a0,s5,344
    80003c60:	e12fc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    80003c64:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003c68:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003c6c:	e0843783          	ld	a5,-504(s0)
    80003c70:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003c74:	058ab783          	ld	a5,88(s5)
    80003c78:	e6843703          	ld	a4,-408(s0)
    80003c7c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003c7e:	058ab783          	ld	a5,88(s5)
    80003c82:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003c86:	85e6                	mv	a1,s9
    80003c88:	9fafd0ef          	jal	80000e82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003c8c:	0004851b          	sext.w	a0,s1
    80003c90:	79be                	ld	s3,488(sp)
    80003c92:	7a1e                	ld	s4,480(sp)
    80003c94:	6afe                	ld	s5,472(sp)
    80003c96:	6b5e                	ld	s6,464(sp)
    80003c98:	6bbe                	ld	s7,456(sp)
    80003c9a:	6c1e                	ld	s8,448(sp)
    80003c9c:	7cfa                	ld	s9,440(sp)
    80003c9e:	7d5a                	ld	s10,432(sp)
    80003ca0:	b3b5                	j	80003a0c <exec+0x6e>
    80003ca2:	e1243423          	sd	s2,-504(s0)
    80003ca6:	7dba                	ld	s11,424(sp)
    80003ca8:	a035                	j	80003cd4 <exec+0x336>
    80003caa:	e1243423          	sd	s2,-504(s0)
    80003cae:	7dba                	ld	s11,424(sp)
    80003cb0:	a015                	j	80003cd4 <exec+0x336>
    80003cb2:	e1243423          	sd	s2,-504(s0)
    80003cb6:	7dba                	ld	s11,424(sp)
    80003cb8:	a831                	j	80003cd4 <exec+0x336>
    80003cba:	e1243423          	sd	s2,-504(s0)
    80003cbe:	7dba                	ld	s11,424(sp)
    80003cc0:	a811                	j	80003cd4 <exec+0x336>
    80003cc2:	e1243423          	sd	s2,-504(s0)
    80003cc6:	7dba                	ld	s11,424(sp)
    80003cc8:	a031                	j	80003cd4 <exec+0x336>
  ip = 0;
    80003cca:	4a01                	li	s4,0
    80003ccc:	a021                	j	80003cd4 <exec+0x336>
    80003cce:	4a01                	li	s4,0
  if(pagetable)
    80003cd0:	a011                	j	80003cd4 <exec+0x336>
    80003cd2:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003cd4:	e0843583          	ld	a1,-504(s0)
    80003cd8:	855a                	mv	a0,s6
    80003cda:	9a8fd0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    80003cde:	557d                	li	a0,-1
  if(ip){
    80003ce0:	000a1b63          	bnez	s4,80003cf6 <exec+0x358>
    80003ce4:	79be                	ld	s3,488(sp)
    80003ce6:	7a1e                	ld	s4,480(sp)
    80003ce8:	6afe                	ld	s5,472(sp)
    80003cea:	6b5e                	ld	s6,464(sp)
    80003cec:	6bbe                	ld	s7,456(sp)
    80003cee:	6c1e                	ld	s8,448(sp)
    80003cf0:	7cfa                	ld	s9,440(sp)
    80003cf2:	7d5a                	ld	s10,432(sp)
    80003cf4:	bb21                	j	80003a0c <exec+0x6e>
    80003cf6:	79be                	ld	s3,488(sp)
    80003cf8:	6afe                	ld	s5,472(sp)
    80003cfa:	6b5e                	ld	s6,464(sp)
    80003cfc:	6bbe                	ld	s7,456(sp)
    80003cfe:	6c1e                	ld	s8,448(sp)
    80003d00:	7cfa                	ld	s9,440(sp)
    80003d02:	7d5a                	ld	s10,432(sp)
    80003d04:	b9ed                	j	800039fe <exec+0x60>
    80003d06:	6b5e                	ld	s6,464(sp)
    80003d08:	b9dd                	j	800039fe <exec+0x60>
  sz = sz1;
    80003d0a:	e0843983          	ld	s3,-504(s0)
    80003d0e:	b595                	j	80003b72 <exec+0x1d4>

0000000080003d10 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d10:	7179                	addi	sp,sp,-48
    80003d12:	f406                	sd	ra,40(sp)
    80003d14:	f022                	sd	s0,32(sp)
    80003d16:	ec26                	sd	s1,24(sp)
    80003d18:	e84a                	sd	s2,16(sp)
    80003d1a:	1800                	addi	s0,sp,48
    80003d1c:	892e                	mv	s2,a1
    80003d1e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d20:	fdc40593          	addi	a1,s0,-36
    80003d24:	ef3fd0ef          	jal	80001c16 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003d28:	fdc42703          	lw	a4,-36(s0)
    80003d2c:	47bd                	li	a5,15
    80003d2e:	02e7e963          	bltu	a5,a4,80003d60 <argfd+0x50>
    80003d32:	824fd0ef          	jal	80000d56 <myproc>
    80003d36:	fdc42703          	lw	a4,-36(s0)
    80003d3a:	01a70793          	addi	a5,a4,26
    80003d3e:	078e                	slli	a5,a5,0x3
    80003d40:	953e                	add	a0,a0,a5
    80003d42:	611c                	ld	a5,0(a0)
    80003d44:	c385                	beqz	a5,80003d64 <argfd+0x54>
    return -1;
  if(pfd)
    80003d46:	00090463          	beqz	s2,80003d4e <argfd+0x3e>
    *pfd = fd;
    80003d4a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003d4e:	4501                	li	a0,0
  if(pf)
    80003d50:	c091                	beqz	s1,80003d54 <argfd+0x44>
    *pf = f;
    80003d52:	e09c                	sd	a5,0(s1)
}
    80003d54:	70a2                	ld	ra,40(sp)
    80003d56:	7402                	ld	s0,32(sp)
    80003d58:	64e2                	ld	s1,24(sp)
    80003d5a:	6942                	ld	s2,16(sp)
    80003d5c:	6145                	addi	sp,sp,48
    80003d5e:	8082                	ret
    return -1;
    80003d60:	557d                	li	a0,-1
    80003d62:	bfcd                	j	80003d54 <argfd+0x44>
    80003d64:	557d                	li	a0,-1
    80003d66:	b7fd                	j	80003d54 <argfd+0x44>

0000000080003d68 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003d68:	1101                	addi	sp,sp,-32
    80003d6a:	ec06                	sd	ra,24(sp)
    80003d6c:	e822                	sd	s0,16(sp)
    80003d6e:	e426                	sd	s1,8(sp)
    80003d70:	1000                	addi	s0,sp,32
    80003d72:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003d74:	fe3fc0ef          	jal	80000d56 <myproc>
    80003d78:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003d7a:	0d050793          	addi	a5,a0,208
    80003d7e:	4501                	li	a0,0
    80003d80:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003d82:	6398                	ld	a4,0(a5)
    80003d84:	cb19                	beqz	a4,80003d9a <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003d86:	2505                	addiw	a0,a0,1
    80003d88:	07a1                	addi	a5,a5,8
    80003d8a:	fed51ce3          	bne	a0,a3,80003d82 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003d8e:	557d                	li	a0,-1
}
    80003d90:	60e2                	ld	ra,24(sp)
    80003d92:	6442                	ld	s0,16(sp)
    80003d94:	64a2                	ld	s1,8(sp)
    80003d96:	6105                	addi	sp,sp,32
    80003d98:	8082                	ret
      p->ofile[fd] = f;
    80003d9a:	01a50793          	addi	a5,a0,26
    80003d9e:	078e                	slli	a5,a5,0x3
    80003da0:	963e                	add	a2,a2,a5
    80003da2:	e204                	sd	s1,0(a2)
      return fd;
    80003da4:	b7f5                	j	80003d90 <fdalloc+0x28>

0000000080003da6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003da6:	715d                	addi	sp,sp,-80
    80003da8:	e486                	sd	ra,72(sp)
    80003daa:	e0a2                	sd	s0,64(sp)
    80003dac:	fc26                	sd	s1,56(sp)
    80003dae:	f84a                	sd	s2,48(sp)
    80003db0:	f44e                	sd	s3,40(sp)
    80003db2:	ec56                	sd	s5,24(sp)
    80003db4:	e85a                	sd	s6,16(sp)
    80003db6:	0880                	addi	s0,sp,80
    80003db8:	8b2e                	mv	s6,a1
    80003dba:	89b2                	mv	s3,a2
    80003dbc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003dbe:	fb040593          	addi	a1,s0,-80
    80003dc2:	822ff0ef          	jal	80002de4 <nameiparent>
    80003dc6:	84aa                	mv	s1,a0
    80003dc8:	10050a63          	beqz	a0,80003edc <create+0x136>
    return 0;

  ilock(dp);
    80003dcc:	925fe0ef          	jal	800026f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003dd0:	4601                	li	a2,0
    80003dd2:	fb040593          	addi	a1,s0,-80
    80003dd6:	8526                	mv	a0,s1
    80003dd8:	d8dfe0ef          	jal	80002b64 <dirlookup>
    80003ddc:	8aaa                	mv	s5,a0
    80003dde:	c129                	beqz	a0,80003e20 <create+0x7a>
    iunlockput(dp);
    80003de0:	8526                	mv	a0,s1
    80003de2:	b19fe0ef          	jal	800028fa <iunlockput>
    ilock(ip);
    80003de6:	8556                	mv	a0,s5
    80003de8:	909fe0ef          	jal	800026f0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003dec:	4789                	li	a5,2
    80003dee:	02fb1463          	bne	s6,a5,80003e16 <create+0x70>
    80003df2:	044ad783          	lhu	a5,68(s5)
    80003df6:	37f9                	addiw	a5,a5,-2
    80003df8:	17c2                	slli	a5,a5,0x30
    80003dfa:	93c1                	srli	a5,a5,0x30
    80003dfc:	4705                	li	a4,1
    80003dfe:	00f76c63          	bltu	a4,a5,80003e16 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e02:	8556                	mv	a0,s5
    80003e04:	60a6                	ld	ra,72(sp)
    80003e06:	6406                	ld	s0,64(sp)
    80003e08:	74e2                	ld	s1,56(sp)
    80003e0a:	7942                	ld	s2,48(sp)
    80003e0c:	79a2                	ld	s3,40(sp)
    80003e0e:	6ae2                	ld	s5,24(sp)
    80003e10:	6b42                	ld	s6,16(sp)
    80003e12:	6161                	addi	sp,sp,80
    80003e14:	8082                	ret
    iunlockput(ip);
    80003e16:	8556                	mv	a0,s5
    80003e18:	ae3fe0ef          	jal	800028fa <iunlockput>
    return 0;
    80003e1c:	4a81                	li	s5,0
    80003e1e:	b7d5                	j	80003e02 <create+0x5c>
    80003e20:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e22:	85da                	mv	a1,s6
    80003e24:	4088                	lw	a0,0(s1)
    80003e26:	f5afe0ef          	jal	80002580 <ialloc>
    80003e2a:	8a2a                	mv	s4,a0
    80003e2c:	cd15                	beqz	a0,80003e68 <create+0xc2>
  ilock(ip);
    80003e2e:	8c3fe0ef          	jal	800026f0 <ilock>
  ip->major = major;
    80003e32:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003e36:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003e3a:	4905                	li	s2,1
    80003e3c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003e40:	8552                	mv	a0,s4
    80003e42:	ffafe0ef          	jal	8000263c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003e46:	032b0763          	beq	s6,s2,80003e74 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e4a:	004a2603          	lw	a2,4(s4)
    80003e4e:	fb040593          	addi	a1,s0,-80
    80003e52:	8526                	mv	a0,s1
    80003e54:	eddfe0ef          	jal	80002d30 <dirlink>
    80003e58:	06054563          	bltz	a0,80003ec2 <create+0x11c>
  iunlockput(dp);
    80003e5c:	8526                	mv	a0,s1
    80003e5e:	a9dfe0ef          	jal	800028fa <iunlockput>
  return ip;
    80003e62:	8ad2                	mv	s5,s4
    80003e64:	7a02                	ld	s4,32(sp)
    80003e66:	bf71                	j	80003e02 <create+0x5c>
    iunlockput(dp);
    80003e68:	8526                	mv	a0,s1
    80003e6a:	a91fe0ef          	jal	800028fa <iunlockput>
    return 0;
    80003e6e:	8ad2                	mv	s5,s4
    80003e70:	7a02                	ld	s4,32(sp)
    80003e72:	bf41                	j	80003e02 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003e74:	004a2603          	lw	a2,4(s4)
    80003e78:	00004597          	auipc	a1,0x4
    80003e7c:	81858593          	addi	a1,a1,-2024 # 80007690 <etext+0x690>
    80003e80:	8552                	mv	a0,s4
    80003e82:	eaffe0ef          	jal	80002d30 <dirlink>
    80003e86:	02054e63          	bltz	a0,80003ec2 <create+0x11c>
    80003e8a:	40d0                	lw	a2,4(s1)
    80003e8c:	00004597          	auipc	a1,0x4
    80003e90:	80c58593          	addi	a1,a1,-2036 # 80007698 <etext+0x698>
    80003e94:	8552                	mv	a0,s4
    80003e96:	e9bfe0ef          	jal	80002d30 <dirlink>
    80003e9a:	02054463          	bltz	a0,80003ec2 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e9e:	004a2603          	lw	a2,4(s4)
    80003ea2:	fb040593          	addi	a1,s0,-80
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	e89fe0ef          	jal	80002d30 <dirlink>
    80003eac:	00054b63          	bltz	a0,80003ec2 <create+0x11c>
    dp->nlink++;  // for ".."
    80003eb0:	04a4d783          	lhu	a5,74(s1)
    80003eb4:	2785                	addiw	a5,a5,1
    80003eb6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003eba:	8526                	mv	a0,s1
    80003ebc:	f80fe0ef          	jal	8000263c <iupdate>
    80003ec0:	bf71                	j	80003e5c <create+0xb6>
  ip->nlink = 0;
    80003ec2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003ec6:	8552                	mv	a0,s4
    80003ec8:	f74fe0ef          	jal	8000263c <iupdate>
  iunlockput(ip);
    80003ecc:	8552                	mv	a0,s4
    80003ece:	a2dfe0ef          	jal	800028fa <iunlockput>
  iunlockput(dp);
    80003ed2:	8526                	mv	a0,s1
    80003ed4:	a27fe0ef          	jal	800028fa <iunlockput>
  return 0;
    80003ed8:	7a02                	ld	s4,32(sp)
    80003eda:	b725                	j	80003e02 <create+0x5c>
    return 0;
    80003edc:	8aaa                	mv	s5,a0
    80003ede:	b715                	j	80003e02 <create+0x5c>

0000000080003ee0 <sys_dup>:
{
    80003ee0:	7179                	addi	sp,sp,-48
    80003ee2:	f406                	sd	ra,40(sp)
    80003ee4:	f022                	sd	s0,32(sp)
    80003ee6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003ee8:	fd840613          	addi	a2,s0,-40
    80003eec:	4581                	li	a1,0
    80003eee:	4501                	li	a0,0
    80003ef0:	e21ff0ef          	jal	80003d10 <argfd>
    return -1;
    80003ef4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003ef6:	02054363          	bltz	a0,80003f1c <sys_dup+0x3c>
    80003efa:	ec26                	sd	s1,24(sp)
    80003efc:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003efe:	fd843903          	ld	s2,-40(s0)
    80003f02:	854a                	mv	a0,s2
    80003f04:	e65ff0ef          	jal	80003d68 <fdalloc>
    80003f08:	84aa                	mv	s1,a0
    return -1;
    80003f0a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f0c:	00054d63          	bltz	a0,80003f26 <sys_dup+0x46>
  filedup(f);
    80003f10:	854a                	mv	a0,s2
    80003f12:	c48ff0ef          	jal	8000335a <filedup>
  return fd;
    80003f16:	87a6                	mv	a5,s1
    80003f18:	64e2                	ld	s1,24(sp)
    80003f1a:	6942                	ld	s2,16(sp)
}
    80003f1c:	853e                	mv	a0,a5
    80003f1e:	70a2                	ld	ra,40(sp)
    80003f20:	7402                	ld	s0,32(sp)
    80003f22:	6145                	addi	sp,sp,48
    80003f24:	8082                	ret
    80003f26:	64e2                	ld	s1,24(sp)
    80003f28:	6942                	ld	s2,16(sp)
    80003f2a:	bfcd                	j	80003f1c <sys_dup+0x3c>

0000000080003f2c <sys_read>:
{
    80003f2c:	7179                	addi	sp,sp,-48
    80003f2e:	f406                	sd	ra,40(sp)
    80003f30:	f022                	sd	s0,32(sp)
    80003f32:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f34:	fd840593          	addi	a1,s0,-40
    80003f38:	4505                	li	a0,1
    80003f3a:	cf9fd0ef          	jal	80001c32 <argaddr>
  argint(2, &n);
    80003f3e:	fe440593          	addi	a1,s0,-28
    80003f42:	4509                	li	a0,2
    80003f44:	cd3fd0ef          	jal	80001c16 <argint>
  if(argfd(0, 0, &f) < 0)
    80003f48:	fe840613          	addi	a2,s0,-24
    80003f4c:	4581                	li	a1,0
    80003f4e:	4501                	li	a0,0
    80003f50:	dc1ff0ef          	jal	80003d10 <argfd>
    80003f54:	87aa                	mv	a5,a0
    return -1;
    80003f56:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f58:	0007ca63          	bltz	a5,80003f6c <sys_read+0x40>
  return fileread(f, p, n);
    80003f5c:	fe442603          	lw	a2,-28(s0)
    80003f60:	fd843583          	ld	a1,-40(s0)
    80003f64:	fe843503          	ld	a0,-24(s0)
    80003f68:	d58ff0ef          	jal	800034c0 <fileread>
}
    80003f6c:	70a2                	ld	ra,40(sp)
    80003f6e:	7402                	ld	s0,32(sp)
    80003f70:	6145                	addi	sp,sp,48
    80003f72:	8082                	ret

0000000080003f74 <sys_write>:
{
    80003f74:	7179                	addi	sp,sp,-48
    80003f76:	f406                	sd	ra,40(sp)
    80003f78:	f022                	sd	s0,32(sp)
    80003f7a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f7c:	fd840593          	addi	a1,s0,-40
    80003f80:	4505                	li	a0,1
    80003f82:	cb1fd0ef          	jal	80001c32 <argaddr>
  argint(2, &n);
    80003f86:	fe440593          	addi	a1,s0,-28
    80003f8a:	4509                	li	a0,2
    80003f8c:	c8bfd0ef          	jal	80001c16 <argint>
  if(argfd(0, 0, &f) < 0)
    80003f90:	fe840613          	addi	a2,s0,-24
    80003f94:	4581                	li	a1,0
    80003f96:	4501                	li	a0,0
    80003f98:	d79ff0ef          	jal	80003d10 <argfd>
    80003f9c:	87aa                	mv	a5,a0
    return -1;
    80003f9e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fa0:	0007ca63          	bltz	a5,80003fb4 <sys_write+0x40>
  return filewrite(f, p, n);
    80003fa4:	fe442603          	lw	a2,-28(s0)
    80003fa8:	fd843583          	ld	a1,-40(s0)
    80003fac:	fe843503          	ld	a0,-24(s0)
    80003fb0:	dceff0ef          	jal	8000357e <filewrite>
}
    80003fb4:	70a2                	ld	ra,40(sp)
    80003fb6:	7402                	ld	s0,32(sp)
    80003fb8:	6145                	addi	sp,sp,48
    80003fba:	8082                	ret

0000000080003fbc <sys_close>:
{
    80003fbc:	1101                	addi	sp,sp,-32
    80003fbe:	ec06                	sd	ra,24(sp)
    80003fc0:	e822                	sd	s0,16(sp)
    80003fc2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003fc4:	fe040613          	addi	a2,s0,-32
    80003fc8:	fec40593          	addi	a1,s0,-20
    80003fcc:	4501                	li	a0,0
    80003fce:	d43ff0ef          	jal	80003d10 <argfd>
    return -1;
    80003fd2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003fd4:	02054063          	bltz	a0,80003ff4 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003fd8:	d7ffc0ef          	jal	80000d56 <myproc>
    80003fdc:	fec42783          	lw	a5,-20(s0)
    80003fe0:	07e9                	addi	a5,a5,26
    80003fe2:	078e                	slli	a5,a5,0x3
    80003fe4:	953e                	add	a0,a0,a5
    80003fe6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003fea:	fe043503          	ld	a0,-32(s0)
    80003fee:	bb2ff0ef          	jal	800033a0 <fileclose>
  return 0;
    80003ff2:	4781                	li	a5,0
}
    80003ff4:	853e                	mv	a0,a5
    80003ff6:	60e2                	ld	ra,24(sp)
    80003ff8:	6442                	ld	s0,16(sp)
    80003ffa:	6105                	addi	sp,sp,32
    80003ffc:	8082                	ret

0000000080003ffe <sys_fstat>:
{
    80003ffe:	1101                	addi	sp,sp,-32
    80004000:	ec06                	sd	ra,24(sp)
    80004002:	e822                	sd	s0,16(sp)
    80004004:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004006:	fe040593          	addi	a1,s0,-32
    8000400a:	4505                	li	a0,1
    8000400c:	c27fd0ef          	jal	80001c32 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004010:	fe840613          	addi	a2,s0,-24
    80004014:	4581                	li	a1,0
    80004016:	4501                	li	a0,0
    80004018:	cf9ff0ef          	jal	80003d10 <argfd>
    8000401c:	87aa                	mv	a5,a0
    return -1;
    8000401e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004020:	0007c863          	bltz	a5,80004030 <sys_fstat+0x32>
  return filestat(f, st);
    80004024:	fe043583          	ld	a1,-32(s0)
    80004028:	fe843503          	ld	a0,-24(s0)
    8000402c:	c36ff0ef          	jal	80003462 <filestat>
}
    80004030:	60e2                	ld	ra,24(sp)
    80004032:	6442                	ld	s0,16(sp)
    80004034:	6105                	addi	sp,sp,32
    80004036:	8082                	ret

0000000080004038 <sys_link>:
{
    80004038:	7169                	addi	sp,sp,-304
    8000403a:	f606                	sd	ra,296(sp)
    8000403c:	f222                	sd	s0,288(sp)
    8000403e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004040:	08000613          	li	a2,128
    80004044:	ed040593          	addi	a1,s0,-304
    80004048:	4501                	li	a0,0
    8000404a:	c05fd0ef          	jal	80001c4e <argstr>
    return -1;
    8000404e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004050:	0c054e63          	bltz	a0,8000412c <sys_link+0xf4>
    80004054:	08000613          	li	a2,128
    80004058:	f5040593          	addi	a1,s0,-176
    8000405c:	4505                	li	a0,1
    8000405e:	bf1fd0ef          	jal	80001c4e <argstr>
    return -1;
    80004062:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004064:	0c054463          	bltz	a0,8000412c <sys_link+0xf4>
    80004068:	ee26                	sd	s1,280(sp)
  begin_op();
    8000406a:	f1dfe0ef          	jal	80002f86 <begin_op>
  if((ip = namei(old)) == 0){
    8000406e:	ed040513          	addi	a0,s0,-304
    80004072:	d59fe0ef          	jal	80002dca <namei>
    80004076:	84aa                	mv	s1,a0
    80004078:	c53d                	beqz	a0,800040e6 <sys_link+0xae>
  ilock(ip);
    8000407a:	e76fe0ef          	jal	800026f0 <ilock>
  if(ip->type == T_DIR){
    8000407e:	04449703          	lh	a4,68(s1)
    80004082:	4785                	li	a5,1
    80004084:	06f70663          	beq	a4,a5,800040f0 <sys_link+0xb8>
    80004088:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000408a:	04a4d783          	lhu	a5,74(s1)
    8000408e:	2785                	addiw	a5,a5,1
    80004090:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004094:	8526                	mv	a0,s1
    80004096:	da6fe0ef          	jal	8000263c <iupdate>
  iunlock(ip);
    8000409a:	8526                	mv	a0,s1
    8000409c:	f02fe0ef          	jal	8000279e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800040a0:	fd040593          	addi	a1,s0,-48
    800040a4:	f5040513          	addi	a0,s0,-176
    800040a8:	d3dfe0ef          	jal	80002de4 <nameiparent>
    800040ac:	892a                	mv	s2,a0
    800040ae:	cd21                	beqz	a0,80004106 <sys_link+0xce>
  ilock(dp);
    800040b0:	e40fe0ef          	jal	800026f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800040b4:	00092703          	lw	a4,0(s2)
    800040b8:	409c                	lw	a5,0(s1)
    800040ba:	04f71363          	bne	a4,a5,80004100 <sys_link+0xc8>
    800040be:	40d0                	lw	a2,4(s1)
    800040c0:	fd040593          	addi	a1,s0,-48
    800040c4:	854a                	mv	a0,s2
    800040c6:	c6bfe0ef          	jal	80002d30 <dirlink>
    800040ca:	02054b63          	bltz	a0,80004100 <sys_link+0xc8>
  iunlockput(dp);
    800040ce:	854a                	mv	a0,s2
    800040d0:	82bfe0ef          	jal	800028fa <iunlockput>
  iput(ip);
    800040d4:	8526                	mv	a0,s1
    800040d6:	f9cfe0ef          	jal	80002872 <iput>
  end_op();
    800040da:	f17fe0ef          	jal	80002ff0 <end_op>
  return 0;
    800040de:	4781                	li	a5,0
    800040e0:	64f2                	ld	s1,280(sp)
    800040e2:	6952                	ld	s2,272(sp)
    800040e4:	a0a1                	j	8000412c <sys_link+0xf4>
    end_op();
    800040e6:	f0bfe0ef          	jal	80002ff0 <end_op>
    return -1;
    800040ea:	57fd                	li	a5,-1
    800040ec:	64f2                	ld	s1,280(sp)
    800040ee:	a83d                	j	8000412c <sys_link+0xf4>
    iunlockput(ip);
    800040f0:	8526                	mv	a0,s1
    800040f2:	809fe0ef          	jal	800028fa <iunlockput>
    end_op();
    800040f6:	efbfe0ef          	jal	80002ff0 <end_op>
    return -1;
    800040fa:	57fd                	li	a5,-1
    800040fc:	64f2                	ld	s1,280(sp)
    800040fe:	a03d                	j	8000412c <sys_link+0xf4>
    iunlockput(dp);
    80004100:	854a                	mv	a0,s2
    80004102:	ff8fe0ef          	jal	800028fa <iunlockput>
  ilock(ip);
    80004106:	8526                	mv	a0,s1
    80004108:	de8fe0ef          	jal	800026f0 <ilock>
  ip->nlink--;
    8000410c:	04a4d783          	lhu	a5,74(s1)
    80004110:	37fd                	addiw	a5,a5,-1
    80004112:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004116:	8526                	mv	a0,s1
    80004118:	d24fe0ef          	jal	8000263c <iupdate>
  iunlockput(ip);
    8000411c:	8526                	mv	a0,s1
    8000411e:	fdcfe0ef          	jal	800028fa <iunlockput>
  end_op();
    80004122:	ecffe0ef          	jal	80002ff0 <end_op>
  return -1;
    80004126:	57fd                	li	a5,-1
    80004128:	64f2                	ld	s1,280(sp)
    8000412a:	6952                	ld	s2,272(sp)
}
    8000412c:	853e                	mv	a0,a5
    8000412e:	70b2                	ld	ra,296(sp)
    80004130:	7412                	ld	s0,288(sp)
    80004132:	6155                	addi	sp,sp,304
    80004134:	8082                	ret

0000000080004136 <sys_unlink>:
{
    80004136:	7151                	addi	sp,sp,-240
    80004138:	f586                	sd	ra,232(sp)
    8000413a:	f1a2                	sd	s0,224(sp)
    8000413c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000413e:	08000613          	li	a2,128
    80004142:	f3040593          	addi	a1,s0,-208
    80004146:	4501                	li	a0,0
    80004148:	b07fd0ef          	jal	80001c4e <argstr>
    8000414c:	16054063          	bltz	a0,800042ac <sys_unlink+0x176>
    80004150:	eda6                	sd	s1,216(sp)
  begin_op();
    80004152:	e35fe0ef          	jal	80002f86 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004156:	fb040593          	addi	a1,s0,-80
    8000415a:	f3040513          	addi	a0,s0,-208
    8000415e:	c87fe0ef          	jal	80002de4 <nameiparent>
    80004162:	84aa                	mv	s1,a0
    80004164:	c945                	beqz	a0,80004214 <sys_unlink+0xde>
  ilock(dp);
    80004166:	d8afe0ef          	jal	800026f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000416a:	00003597          	auipc	a1,0x3
    8000416e:	52658593          	addi	a1,a1,1318 # 80007690 <etext+0x690>
    80004172:	fb040513          	addi	a0,s0,-80
    80004176:	9d9fe0ef          	jal	80002b4e <namecmp>
    8000417a:	10050e63          	beqz	a0,80004296 <sys_unlink+0x160>
    8000417e:	00003597          	auipc	a1,0x3
    80004182:	51a58593          	addi	a1,a1,1306 # 80007698 <etext+0x698>
    80004186:	fb040513          	addi	a0,s0,-80
    8000418a:	9c5fe0ef          	jal	80002b4e <namecmp>
    8000418e:	10050463          	beqz	a0,80004296 <sys_unlink+0x160>
    80004192:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004194:	f2c40613          	addi	a2,s0,-212
    80004198:	fb040593          	addi	a1,s0,-80
    8000419c:	8526                	mv	a0,s1
    8000419e:	9c7fe0ef          	jal	80002b64 <dirlookup>
    800041a2:	892a                	mv	s2,a0
    800041a4:	0e050863          	beqz	a0,80004294 <sys_unlink+0x15e>
  ilock(ip);
    800041a8:	d48fe0ef          	jal	800026f0 <ilock>
  if(ip->nlink < 1)
    800041ac:	04a91783          	lh	a5,74(s2)
    800041b0:	06f05763          	blez	a5,8000421e <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800041b4:	04491703          	lh	a4,68(s2)
    800041b8:	4785                	li	a5,1
    800041ba:	06f70963          	beq	a4,a5,8000422c <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800041be:	4641                	li	a2,16
    800041c0:	4581                	li	a1,0
    800041c2:	fc040513          	addi	a0,s0,-64
    800041c6:	f6ffb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041ca:	4741                	li	a4,16
    800041cc:	f2c42683          	lw	a3,-212(s0)
    800041d0:	fc040613          	addi	a2,s0,-64
    800041d4:	4581                	li	a1,0
    800041d6:	8526                	mv	a0,s1
    800041d8:	869fe0ef          	jal	80002a40 <writei>
    800041dc:	47c1                	li	a5,16
    800041de:	08f51b63          	bne	a0,a5,80004274 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800041e2:	04491703          	lh	a4,68(s2)
    800041e6:	4785                	li	a5,1
    800041e8:	08f70d63          	beq	a4,a5,80004282 <sys_unlink+0x14c>
  iunlockput(dp);
    800041ec:	8526                	mv	a0,s1
    800041ee:	f0cfe0ef          	jal	800028fa <iunlockput>
  ip->nlink--;
    800041f2:	04a95783          	lhu	a5,74(s2)
    800041f6:	37fd                	addiw	a5,a5,-1
    800041f8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800041fc:	854a                	mv	a0,s2
    800041fe:	c3efe0ef          	jal	8000263c <iupdate>
  iunlockput(ip);
    80004202:	854a                	mv	a0,s2
    80004204:	ef6fe0ef          	jal	800028fa <iunlockput>
  end_op();
    80004208:	de9fe0ef          	jal	80002ff0 <end_op>
  return 0;
    8000420c:	4501                	li	a0,0
    8000420e:	64ee                	ld	s1,216(sp)
    80004210:	694e                	ld	s2,208(sp)
    80004212:	a849                	j	800042a4 <sys_unlink+0x16e>
    end_op();
    80004214:	dddfe0ef          	jal	80002ff0 <end_op>
    return -1;
    80004218:	557d                	li	a0,-1
    8000421a:	64ee                	ld	s1,216(sp)
    8000421c:	a061                	j	800042a4 <sys_unlink+0x16e>
    8000421e:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004220:	00003517          	auipc	a0,0x3
    80004224:	48050513          	addi	a0,a0,1152 # 800076a0 <etext+0x6a0>
    80004228:	27a010ef          	jal	800054a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000422c:	04c92703          	lw	a4,76(s2)
    80004230:	02000793          	li	a5,32
    80004234:	f8e7f5e3          	bgeu	a5,a4,800041be <sys_unlink+0x88>
    80004238:	e5ce                	sd	s3,200(sp)
    8000423a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000423e:	4741                	li	a4,16
    80004240:	86ce                	mv	a3,s3
    80004242:	f1840613          	addi	a2,s0,-232
    80004246:	4581                	li	a1,0
    80004248:	854a                	mv	a0,s2
    8000424a:	efafe0ef          	jal	80002944 <readi>
    8000424e:	47c1                	li	a5,16
    80004250:	00f51c63          	bne	a0,a5,80004268 <sys_unlink+0x132>
    if(de.inum != 0)
    80004254:	f1845783          	lhu	a5,-232(s0)
    80004258:	efa1                	bnez	a5,800042b0 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000425a:	29c1                	addiw	s3,s3,16
    8000425c:	04c92783          	lw	a5,76(s2)
    80004260:	fcf9efe3          	bltu	s3,a5,8000423e <sys_unlink+0x108>
    80004264:	69ae                	ld	s3,200(sp)
    80004266:	bfa1                	j	800041be <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004268:	00003517          	auipc	a0,0x3
    8000426c:	45050513          	addi	a0,a0,1104 # 800076b8 <etext+0x6b8>
    80004270:	232010ef          	jal	800054a2 <panic>
    80004274:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004276:	00003517          	auipc	a0,0x3
    8000427a:	45a50513          	addi	a0,a0,1114 # 800076d0 <etext+0x6d0>
    8000427e:	224010ef          	jal	800054a2 <panic>
    dp->nlink--;
    80004282:	04a4d783          	lhu	a5,74(s1)
    80004286:	37fd                	addiw	a5,a5,-1
    80004288:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000428c:	8526                	mv	a0,s1
    8000428e:	baefe0ef          	jal	8000263c <iupdate>
    80004292:	bfa9                	j	800041ec <sys_unlink+0xb6>
    80004294:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004296:	8526                	mv	a0,s1
    80004298:	e62fe0ef          	jal	800028fa <iunlockput>
  end_op();
    8000429c:	d55fe0ef          	jal	80002ff0 <end_op>
  return -1;
    800042a0:	557d                	li	a0,-1
    800042a2:	64ee                	ld	s1,216(sp)
}
    800042a4:	70ae                	ld	ra,232(sp)
    800042a6:	740e                	ld	s0,224(sp)
    800042a8:	616d                	addi	sp,sp,240
    800042aa:	8082                	ret
    return -1;
    800042ac:	557d                	li	a0,-1
    800042ae:	bfdd                	j	800042a4 <sys_unlink+0x16e>
    iunlockput(ip);
    800042b0:	854a                	mv	a0,s2
    800042b2:	e48fe0ef          	jal	800028fa <iunlockput>
    goto bad;
    800042b6:	694e                	ld	s2,208(sp)
    800042b8:	69ae                	ld	s3,200(sp)
    800042ba:	bff1                	j	80004296 <sys_unlink+0x160>

00000000800042bc <sys_open>:

uint64
sys_open(void)
{
    800042bc:	7131                	addi	sp,sp,-192
    800042be:	fd06                	sd	ra,184(sp)
    800042c0:	f922                	sd	s0,176(sp)
    800042c2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800042c4:	f4c40593          	addi	a1,s0,-180
    800042c8:	4505                	li	a0,1
    800042ca:	94dfd0ef          	jal	80001c16 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042ce:	08000613          	li	a2,128
    800042d2:	f5040593          	addi	a1,s0,-176
    800042d6:	4501                	li	a0,0
    800042d8:	977fd0ef          	jal	80001c4e <argstr>
    800042dc:	87aa                	mv	a5,a0
    return -1;
    800042de:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042e0:	0a07c263          	bltz	a5,80004384 <sys_open+0xc8>
    800042e4:	f526                	sd	s1,168(sp)

  begin_op();
    800042e6:	ca1fe0ef          	jal	80002f86 <begin_op>

  if(omode & O_CREATE){
    800042ea:	f4c42783          	lw	a5,-180(s0)
    800042ee:	2007f793          	andi	a5,a5,512
    800042f2:	c3d5                	beqz	a5,80004396 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800042f4:	4681                	li	a3,0
    800042f6:	4601                	li	a2,0
    800042f8:	4589                	li	a1,2
    800042fa:	f5040513          	addi	a0,s0,-176
    800042fe:	aa9ff0ef          	jal	80003da6 <create>
    80004302:	84aa                	mv	s1,a0
    if(ip == 0){
    80004304:	c541                	beqz	a0,8000438c <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004306:	04449703          	lh	a4,68(s1)
    8000430a:	478d                	li	a5,3
    8000430c:	00f71763          	bne	a4,a5,8000431a <sys_open+0x5e>
    80004310:	0464d703          	lhu	a4,70(s1)
    80004314:	47a5                	li	a5,9
    80004316:	0ae7ed63          	bltu	a5,a4,800043d0 <sys_open+0x114>
    8000431a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000431c:	fe1fe0ef          	jal	800032fc <filealloc>
    80004320:	892a                	mv	s2,a0
    80004322:	c179                	beqz	a0,800043e8 <sys_open+0x12c>
    80004324:	ed4e                	sd	s3,152(sp)
    80004326:	a43ff0ef          	jal	80003d68 <fdalloc>
    8000432a:	89aa                	mv	s3,a0
    8000432c:	0a054a63          	bltz	a0,800043e0 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004330:	04449703          	lh	a4,68(s1)
    80004334:	478d                	li	a5,3
    80004336:	0cf70263          	beq	a4,a5,800043fa <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000433a:	4789                	li	a5,2
    8000433c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004340:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004344:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004348:	f4c42783          	lw	a5,-180(s0)
    8000434c:	0017c713          	xori	a4,a5,1
    80004350:	8b05                	andi	a4,a4,1
    80004352:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004356:	0037f713          	andi	a4,a5,3
    8000435a:	00e03733          	snez	a4,a4
    8000435e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004362:	4007f793          	andi	a5,a5,1024
    80004366:	c791                	beqz	a5,80004372 <sys_open+0xb6>
    80004368:	04449703          	lh	a4,68(s1)
    8000436c:	4789                	li	a5,2
    8000436e:	08f70d63          	beq	a4,a5,80004408 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004372:	8526                	mv	a0,s1
    80004374:	c2afe0ef          	jal	8000279e <iunlock>
  end_op();
    80004378:	c79fe0ef          	jal	80002ff0 <end_op>

  return fd;
    8000437c:	854e                	mv	a0,s3
    8000437e:	74aa                	ld	s1,168(sp)
    80004380:	790a                	ld	s2,160(sp)
    80004382:	69ea                	ld	s3,152(sp)
}
    80004384:	70ea                	ld	ra,184(sp)
    80004386:	744a                	ld	s0,176(sp)
    80004388:	6129                	addi	sp,sp,192
    8000438a:	8082                	ret
      end_op();
    8000438c:	c65fe0ef          	jal	80002ff0 <end_op>
      return -1;
    80004390:	557d                	li	a0,-1
    80004392:	74aa                	ld	s1,168(sp)
    80004394:	bfc5                	j	80004384 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004396:	f5040513          	addi	a0,s0,-176
    8000439a:	a31fe0ef          	jal	80002dca <namei>
    8000439e:	84aa                	mv	s1,a0
    800043a0:	c11d                	beqz	a0,800043c6 <sys_open+0x10a>
    ilock(ip);
    800043a2:	b4efe0ef          	jal	800026f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800043a6:	04449703          	lh	a4,68(s1)
    800043aa:	4785                	li	a5,1
    800043ac:	f4f71de3          	bne	a4,a5,80004306 <sys_open+0x4a>
    800043b0:	f4c42783          	lw	a5,-180(s0)
    800043b4:	d3bd                	beqz	a5,8000431a <sys_open+0x5e>
      iunlockput(ip);
    800043b6:	8526                	mv	a0,s1
    800043b8:	d42fe0ef          	jal	800028fa <iunlockput>
      end_op();
    800043bc:	c35fe0ef          	jal	80002ff0 <end_op>
      return -1;
    800043c0:	557d                	li	a0,-1
    800043c2:	74aa                	ld	s1,168(sp)
    800043c4:	b7c1                	j	80004384 <sys_open+0xc8>
      end_op();
    800043c6:	c2bfe0ef          	jal	80002ff0 <end_op>
      return -1;
    800043ca:	557d                	li	a0,-1
    800043cc:	74aa                	ld	s1,168(sp)
    800043ce:	bf5d                	j	80004384 <sys_open+0xc8>
    iunlockput(ip);
    800043d0:	8526                	mv	a0,s1
    800043d2:	d28fe0ef          	jal	800028fa <iunlockput>
    end_op();
    800043d6:	c1bfe0ef          	jal	80002ff0 <end_op>
    return -1;
    800043da:	557d                	li	a0,-1
    800043dc:	74aa                	ld	s1,168(sp)
    800043de:	b75d                	j	80004384 <sys_open+0xc8>
      fileclose(f);
    800043e0:	854a                	mv	a0,s2
    800043e2:	fbffe0ef          	jal	800033a0 <fileclose>
    800043e6:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800043e8:	8526                	mv	a0,s1
    800043ea:	d10fe0ef          	jal	800028fa <iunlockput>
    end_op();
    800043ee:	c03fe0ef          	jal	80002ff0 <end_op>
    return -1;
    800043f2:	557d                	li	a0,-1
    800043f4:	74aa                	ld	s1,168(sp)
    800043f6:	790a                	ld	s2,160(sp)
    800043f8:	b771                	j	80004384 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800043fa:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800043fe:	04649783          	lh	a5,70(s1)
    80004402:	02f91223          	sh	a5,36(s2)
    80004406:	bf3d                	j	80004344 <sys_open+0x88>
    itrunc(ip);
    80004408:	8526                	mv	a0,s1
    8000440a:	bd4fe0ef          	jal	800027de <itrunc>
    8000440e:	b795                	j	80004372 <sys_open+0xb6>

0000000080004410 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004410:	7175                	addi	sp,sp,-144
    80004412:	e506                	sd	ra,136(sp)
    80004414:	e122                	sd	s0,128(sp)
    80004416:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004418:	b6ffe0ef          	jal	80002f86 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000441c:	08000613          	li	a2,128
    80004420:	f7040593          	addi	a1,s0,-144
    80004424:	4501                	li	a0,0
    80004426:	829fd0ef          	jal	80001c4e <argstr>
    8000442a:	02054363          	bltz	a0,80004450 <sys_mkdir+0x40>
    8000442e:	4681                	li	a3,0
    80004430:	4601                	li	a2,0
    80004432:	4585                	li	a1,1
    80004434:	f7040513          	addi	a0,s0,-144
    80004438:	96fff0ef          	jal	80003da6 <create>
    8000443c:	c911                	beqz	a0,80004450 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000443e:	cbcfe0ef          	jal	800028fa <iunlockput>
  end_op();
    80004442:	baffe0ef          	jal	80002ff0 <end_op>
  return 0;
    80004446:	4501                	li	a0,0
}
    80004448:	60aa                	ld	ra,136(sp)
    8000444a:	640a                	ld	s0,128(sp)
    8000444c:	6149                	addi	sp,sp,144
    8000444e:	8082                	ret
    end_op();
    80004450:	ba1fe0ef          	jal	80002ff0 <end_op>
    return -1;
    80004454:	557d                	li	a0,-1
    80004456:	bfcd                	j	80004448 <sys_mkdir+0x38>

0000000080004458 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004458:	7135                	addi	sp,sp,-160
    8000445a:	ed06                	sd	ra,152(sp)
    8000445c:	e922                	sd	s0,144(sp)
    8000445e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004460:	b27fe0ef          	jal	80002f86 <begin_op>
  argint(1, &major);
    80004464:	f6c40593          	addi	a1,s0,-148
    80004468:	4505                	li	a0,1
    8000446a:	facfd0ef          	jal	80001c16 <argint>
  argint(2, &minor);
    8000446e:	f6840593          	addi	a1,s0,-152
    80004472:	4509                	li	a0,2
    80004474:	fa2fd0ef          	jal	80001c16 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004478:	08000613          	li	a2,128
    8000447c:	f7040593          	addi	a1,s0,-144
    80004480:	4501                	li	a0,0
    80004482:	fccfd0ef          	jal	80001c4e <argstr>
    80004486:	02054563          	bltz	a0,800044b0 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000448a:	f6841683          	lh	a3,-152(s0)
    8000448e:	f6c41603          	lh	a2,-148(s0)
    80004492:	458d                	li	a1,3
    80004494:	f7040513          	addi	a0,s0,-144
    80004498:	90fff0ef          	jal	80003da6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000449c:	c911                	beqz	a0,800044b0 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000449e:	c5cfe0ef          	jal	800028fa <iunlockput>
  end_op();
    800044a2:	b4ffe0ef          	jal	80002ff0 <end_op>
  return 0;
    800044a6:	4501                	li	a0,0
}
    800044a8:	60ea                	ld	ra,152(sp)
    800044aa:	644a                	ld	s0,144(sp)
    800044ac:	610d                	addi	sp,sp,160
    800044ae:	8082                	ret
    end_op();
    800044b0:	b41fe0ef          	jal	80002ff0 <end_op>
    return -1;
    800044b4:	557d                	li	a0,-1
    800044b6:	bfcd                	j	800044a8 <sys_mknod+0x50>

00000000800044b8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800044b8:	7135                	addi	sp,sp,-160
    800044ba:	ed06                	sd	ra,152(sp)
    800044bc:	e922                	sd	s0,144(sp)
    800044be:	e14a                	sd	s2,128(sp)
    800044c0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800044c2:	895fc0ef          	jal	80000d56 <myproc>
    800044c6:	892a                	mv	s2,a0
  
  begin_op();
    800044c8:	abffe0ef          	jal	80002f86 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800044cc:	08000613          	li	a2,128
    800044d0:	f6040593          	addi	a1,s0,-160
    800044d4:	4501                	li	a0,0
    800044d6:	f78fd0ef          	jal	80001c4e <argstr>
    800044da:	04054363          	bltz	a0,80004520 <sys_chdir+0x68>
    800044de:	e526                	sd	s1,136(sp)
    800044e0:	f6040513          	addi	a0,s0,-160
    800044e4:	8e7fe0ef          	jal	80002dca <namei>
    800044e8:	84aa                	mv	s1,a0
    800044ea:	c915                	beqz	a0,8000451e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800044ec:	a04fe0ef          	jal	800026f0 <ilock>
  if(ip->type != T_DIR){
    800044f0:	04449703          	lh	a4,68(s1)
    800044f4:	4785                	li	a5,1
    800044f6:	02f71963          	bne	a4,a5,80004528 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800044fa:	8526                	mv	a0,s1
    800044fc:	aa2fe0ef          	jal	8000279e <iunlock>
  iput(p->cwd);
    80004500:	15093503          	ld	a0,336(s2)
    80004504:	b6efe0ef          	jal	80002872 <iput>
  end_op();
    80004508:	ae9fe0ef          	jal	80002ff0 <end_op>
  p->cwd = ip;
    8000450c:	14993823          	sd	s1,336(s2)
  return 0;
    80004510:	4501                	li	a0,0
    80004512:	64aa                	ld	s1,136(sp)
}
    80004514:	60ea                	ld	ra,152(sp)
    80004516:	644a                	ld	s0,144(sp)
    80004518:	690a                	ld	s2,128(sp)
    8000451a:	610d                	addi	sp,sp,160
    8000451c:	8082                	ret
    8000451e:	64aa                	ld	s1,136(sp)
    end_op();
    80004520:	ad1fe0ef          	jal	80002ff0 <end_op>
    return -1;
    80004524:	557d                	li	a0,-1
    80004526:	b7fd                	j	80004514 <sys_chdir+0x5c>
    iunlockput(ip);
    80004528:	8526                	mv	a0,s1
    8000452a:	bd0fe0ef          	jal	800028fa <iunlockput>
    end_op();
    8000452e:	ac3fe0ef          	jal	80002ff0 <end_op>
    return -1;
    80004532:	557d                	li	a0,-1
    80004534:	64aa                	ld	s1,136(sp)
    80004536:	bff9                	j	80004514 <sys_chdir+0x5c>

0000000080004538 <sys_exec>:

uint64
sys_exec(void)
{
    80004538:	7121                	addi	sp,sp,-448
    8000453a:	ff06                	sd	ra,440(sp)
    8000453c:	fb22                	sd	s0,432(sp)
    8000453e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004540:	e4840593          	addi	a1,s0,-440
    80004544:	4505                	li	a0,1
    80004546:	eecfd0ef          	jal	80001c32 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000454a:	08000613          	li	a2,128
    8000454e:	f5040593          	addi	a1,s0,-176
    80004552:	4501                	li	a0,0
    80004554:	efafd0ef          	jal	80001c4e <argstr>
    80004558:	87aa                	mv	a5,a0
    return -1;
    8000455a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000455c:	0c07c463          	bltz	a5,80004624 <sys_exec+0xec>
    80004560:	f726                	sd	s1,424(sp)
    80004562:	f34a                	sd	s2,416(sp)
    80004564:	ef4e                	sd	s3,408(sp)
    80004566:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004568:	10000613          	li	a2,256
    8000456c:	4581                	li	a1,0
    8000456e:	e5040513          	addi	a0,s0,-432
    80004572:	bc3fb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004576:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000457a:	89a6                	mv	s3,s1
    8000457c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000457e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004582:	00391513          	slli	a0,s2,0x3
    80004586:	e4040593          	addi	a1,s0,-448
    8000458a:	e4843783          	ld	a5,-440(s0)
    8000458e:	953e                	add	a0,a0,a5
    80004590:	dfcfd0ef          	jal	80001b8c <fetchaddr>
    80004594:	02054663          	bltz	a0,800045c0 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004598:	e4043783          	ld	a5,-448(s0)
    8000459c:	c3a9                	beqz	a5,800045de <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000459e:	b59fb0ef          	jal	800000f6 <kalloc>
    800045a2:	85aa                	mv	a1,a0
    800045a4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800045a8:	cd01                	beqz	a0,800045c0 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800045aa:	6605                	lui	a2,0x1
    800045ac:	e4043503          	ld	a0,-448(s0)
    800045b0:	e26fd0ef          	jal	80001bd6 <fetchstr>
    800045b4:	00054663          	bltz	a0,800045c0 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800045b8:	0905                	addi	s2,s2,1
    800045ba:	09a1                	addi	s3,s3,8
    800045bc:	fd4913e3          	bne	s2,s4,80004582 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045c0:	f5040913          	addi	s2,s0,-176
    800045c4:	6088                	ld	a0,0(s1)
    800045c6:	c931                	beqz	a0,8000461a <sys_exec+0xe2>
    kfree(argv[i]);
    800045c8:	a55fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045cc:	04a1                	addi	s1,s1,8
    800045ce:	ff249be3          	bne	s1,s2,800045c4 <sys_exec+0x8c>
  return -1;
    800045d2:	557d                	li	a0,-1
    800045d4:	74ba                	ld	s1,424(sp)
    800045d6:	791a                	ld	s2,416(sp)
    800045d8:	69fa                	ld	s3,408(sp)
    800045da:	6a5a                	ld	s4,400(sp)
    800045dc:	a0a1                	j	80004624 <sys_exec+0xec>
      argv[i] = 0;
    800045de:	0009079b          	sext.w	a5,s2
    800045e2:	078e                	slli	a5,a5,0x3
    800045e4:	fd078793          	addi	a5,a5,-48
    800045e8:	97a2                	add	a5,a5,s0
    800045ea:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800045ee:	e5040593          	addi	a1,s0,-432
    800045f2:	f5040513          	addi	a0,s0,-176
    800045f6:	ba8ff0ef          	jal	8000399e <exec>
    800045fa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045fc:	f5040993          	addi	s3,s0,-176
    80004600:	6088                	ld	a0,0(s1)
    80004602:	c511                	beqz	a0,8000460e <sys_exec+0xd6>
    kfree(argv[i]);
    80004604:	a19fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004608:	04a1                	addi	s1,s1,8
    8000460a:	ff349be3          	bne	s1,s3,80004600 <sys_exec+0xc8>
  return ret;
    8000460e:	854a                	mv	a0,s2
    80004610:	74ba                	ld	s1,424(sp)
    80004612:	791a                	ld	s2,416(sp)
    80004614:	69fa                	ld	s3,408(sp)
    80004616:	6a5a                	ld	s4,400(sp)
    80004618:	a031                	j	80004624 <sys_exec+0xec>
  return -1;
    8000461a:	557d                	li	a0,-1
    8000461c:	74ba                	ld	s1,424(sp)
    8000461e:	791a                	ld	s2,416(sp)
    80004620:	69fa                	ld	s3,408(sp)
    80004622:	6a5a                	ld	s4,400(sp)
}
    80004624:	70fa                	ld	ra,440(sp)
    80004626:	745a                	ld	s0,432(sp)
    80004628:	6139                	addi	sp,sp,448
    8000462a:	8082                	ret

000000008000462c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000462c:	7139                	addi	sp,sp,-64
    8000462e:	fc06                	sd	ra,56(sp)
    80004630:	f822                	sd	s0,48(sp)
    80004632:	f426                	sd	s1,40(sp)
    80004634:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004636:	f20fc0ef          	jal	80000d56 <myproc>
    8000463a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000463c:	fd840593          	addi	a1,s0,-40
    80004640:	4501                	li	a0,0
    80004642:	df0fd0ef          	jal	80001c32 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004646:	fc840593          	addi	a1,s0,-56
    8000464a:	fd040513          	addi	a0,s0,-48
    8000464e:	85cff0ef          	jal	800036aa <pipealloc>
    return -1;
    80004652:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004654:	0a054463          	bltz	a0,800046fc <sys_pipe+0xd0>
  fd0 = -1;
    80004658:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000465c:	fd043503          	ld	a0,-48(s0)
    80004660:	f08ff0ef          	jal	80003d68 <fdalloc>
    80004664:	fca42223          	sw	a0,-60(s0)
    80004668:	08054163          	bltz	a0,800046ea <sys_pipe+0xbe>
    8000466c:	fc843503          	ld	a0,-56(s0)
    80004670:	ef8ff0ef          	jal	80003d68 <fdalloc>
    80004674:	fca42023          	sw	a0,-64(s0)
    80004678:	06054063          	bltz	a0,800046d8 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000467c:	4691                	li	a3,4
    8000467e:	fc440613          	addi	a2,s0,-60
    80004682:	fd843583          	ld	a1,-40(s0)
    80004686:	68a8                	ld	a0,80(s1)
    80004688:	b3efc0ef          	jal	800009c6 <copyout>
    8000468c:	00054e63          	bltz	a0,800046a8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004690:	4691                	li	a3,4
    80004692:	fc040613          	addi	a2,s0,-64
    80004696:	fd843583          	ld	a1,-40(s0)
    8000469a:	0591                	addi	a1,a1,4
    8000469c:	68a8                	ld	a0,80(s1)
    8000469e:	b28fc0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800046a2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046a4:	04055c63          	bgez	a0,800046fc <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800046a8:	fc442783          	lw	a5,-60(s0)
    800046ac:	07e9                	addi	a5,a5,26
    800046ae:	078e                	slli	a5,a5,0x3
    800046b0:	97a6                	add	a5,a5,s1
    800046b2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800046b6:	fc042783          	lw	a5,-64(s0)
    800046ba:	07e9                	addi	a5,a5,26
    800046bc:	078e                	slli	a5,a5,0x3
    800046be:	94be                	add	s1,s1,a5
    800046c0:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800046c4:	fd043503          	ld	a0,-48(s0)
    800046c8:	cd9fe0ef          	jal	800033a0 <fileclose>
    fileclose(wf);
    800046cc:	fc843503          	ld	a0,-56(s0)
    800046d0:	cd1fe0ef          	jal	800033a0 <fileclose>
    return -1;
    800046d4:	57fd                	li	a5,-1
    800046d6:	a01d                	j	800046fc <sys_pipe+0xd0>
    if(fd0 >= 0)
    800046d8:	fc442783          	lw	a5,-60(s0)
    800046dc:	0007c763          	bltz	a5,800046ea <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800046e0:	07e9                	addi	a5,a5,26
    800046e2:	078e                	slli	a5,a5,0x3
    800046e4:	97a6                	add	a5,a5,s1
    800046e6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800046ea:	fd043503          	ld	a0,-48(s0)
    800046ee:	cb3fe0ef          	jal	800033a0 <fileclose>
    fileclose(wf);
    800046f2:	fc843503          	ld	a0,-56(s0)
    800046f6:	cabfe0ef          	jal	800033a0 <fileclose>
    return -1;
    800046fa:	57fd                	li	a5,-1
}
    800046fc:	853e                	mv	a0,a5
    800046fe:	70e2                	ld	ra,56(sp)
    80004700:	7442                	ld	s0,48(sp)
    80004702:	74a2                	ld	s1,40(sp)
    80004704:	6121                	addi	sp,sp,64
    80004706:	8082                	ret
	...

0000000080004710 <kernelvec>:
    80004710:	7111                	addi	sp,sp,-256
    80004712:	e006                	sd	ra,0(sp)
    80004714:	e40a                	sd	sp,8(sp)
    80004716:	e80e                	sd	gp,16(sp)
    80004718:	ec12                	sd	tp,24(sp)
    8000471a:	f016                	sd	t0,32(sp)
    8000471c:	f41a                	sd	t1,40(sp)
    8000471e:	f81e                	sd	t2,48(sp)
    80004720:	e4aa                	sd	a0,72(sp)
    80004722:	e8ae                	sd	a1,80(sp)
    80004724:	ecb2                	sd	a2,88(sp)
    80004726:	f0b6                	sd	a3,96(sp)
    80004728:	f4ba                	sd	a4,104(sp)
    8000472a:	f8be                	sd	a5,112(sp)
    8000472c:	fcc2                	sd	a6,120(sp)
    8000472e:	e146                	sd	a7,128(sp)
    80004730:	edf2                	sd	t3,216(sp)
    80004732:	f1f6                	sd	t4,224(sp)
    80004734:	f5fa                	sd	t5,232(sp)
    80004736:	f9fe                	sd	t6,240(sp)
    80004738:	b64fd0ef          	jal	80001a9c <kerneltrap>
    8000473c:	6082                	ld	ra,0(sp)
    8000473e:	6122                	ld	sp,8(sp)
    80004740:	61c2                	ld	gp,16(sp)
    80004742:	7282                	ld	t0,32(sp)
    80004744:	7322                	ld	t1,40(sp)
    80004746:	73c2                	ld	t2,48(sp)
    80004748:	6526                	ld	a0,72(sp)
    8000474a:	65c6                	ld	a1,80(sp)
    8000474c:	6666                	ld	a2,88(sp)
    8000474e:	7686                	ld	a3,96(sp)
    80004750:	7726                	ld	a4,104(sp)
    80004752:	77c6                	ld	a5,112(sp)
    80004754:	7866                	ld	a6,120(sp)
    80004756:	688a                	ld	a7,128(sp)
    80004758:	6e6e                	ld	t3,216(sp)
    8000475a:	7e8e                	ld	t4,224(sp)
    8000475c:	7f2e                	ld	t5,232(sp)
    8000475e:	7fce                	ld	t6,240(sp)
    80004760:	6111                	addi	sp,sp,256
    80004762:	10200073          	sret
	...

000000008000476e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000476e:	1141                	addi	sp,sp,-16
    80004770:	e422                	sd	s0,8(sp)
    80004772:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004774:	0c0007b7          	lui	a5,0xc000
    80004778:	4705                	li	a4,1
    8000477a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000477c:	0c0007b7          	lui	a5,0xc000
    80004780:	c3d8                	sw	a4,4(a5)
}
    80004782:	6422                	ld	s0,8(sp)
    80004784:	0141                	addi	sp,sp,16
    80004786:	8082                	ret

0000000080004788 <plicinithart>:

void
plicinithart(void)
{
    80004788:	1141                	addi	sp,sp,-16
    8000478a:	e406                	sd	ra,8(sp)
    8000478c:	e022                	sd	s0,0(sp)
    8000478e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004790:	d9afc0ef          	jal	80000d2a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004794:	0085171b          	slliw	a4,a0,0x8
    80004798:	0c0027b7          	lui	a5,0xc002
    8000479c:	97ba                	add	a5,a5,a4
    8000479e:	40200713          	li	a4,1026
    800047a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800047a6:	00d5151b          	slliw	a0,a0,0xd
    800047aa:	0c2017b7          	lui	a5,0xc201
    800047ae:	97aa                	add	a5,a5,a0
    800047b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800047b4:	60a2                	ld	ra,8(sp)
    800047b6:	6402                	ld	s0,0(sp)
    800047b8:	0141                	addi	sp,sp,16
    800047ba:	8082                	ret

00000000800047bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800047bc:	1141                	addi	sp,sp,-16
    800047be:	e406                	sd	ra,8(sp)
    800047c0:	e022                	sd	s0,0(sp)
    800047c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047c4:	d66fc0ef          	jal	80000d2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800047c8:	00d5151b          	slliw	a0,a0,0xd
    800047cc:	0c2017b7          	lui	a5,0xc201
    800047d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800047d2:	43c8                	lw	a0,4(a5)
    800047d4:	60a2                	ld	ra,8(sp)
    800047d6:	6402                	ld	s0,0(sp)
    800047d8:	0141                	addi	sp,sp,16
    800047da:	8082                	ret

00000000800047dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800047dc:	1101                	addi	sp,sp,-32
    800047de:	ec06                	sd	ra,24(sp)
    800047e0:	e822                	sd	s0,16(sp)
    800047e2:	e426                	sd	s1,8(sp)
    800047e4:	1000                	addi	s0,sp,32
    800047e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800047e8:	d42fc0ef          	jal	80000d2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800047ec:	00d5151b          	slliw	a0,a0,0xd
    800047f0:	0c2017b7          	lui	a5,0xc201
    800047f4:	97aa                	add	a5,a5,a0
    800047f6:	c3c4                	sw	s1,4(a5)
}
    800047f8:	60e2                	ld	ra,24(sp)
    800047fa:	6442                	ld	s0,16(sp)
    800047fc:	64a2                	ld	s1,8(sp)
    800047fe:	6105                	addi	sp,sp,32
    80004800:	8082                	ret

0000000080004802 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004802:	1141                	addi	sp,sp,-16
    80004804:	e406                	sd	ra,8(sp)
    80004806:	e022                	sd	s0,0(sp)
    80004808:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000480a:	479d                	li	a5,7
    8000480c:	04a7ca63          	blt	a5,a0,80004860 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004810:	00017797          	auipc	a5,0x17
    80004814:	ed078793          	addi	a5,a5,-304 # 8001b6e0 <disk>
    80004818:	97aa                	add	a5,a5,a0
    8000481a:	0187c783          	lbu	a5,24(a5)
    8000481e:	e7b9                	bnez	a5,8000486c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004820:	00451693          	slli	a3,a0,0x4
    80004824:	00017797          	auipc	a5,0x17
    80004828:	ebc78793          	addi	a5,a5,-324 # 8001b6e0 <disk>
    8000482c:	6398                	ld	a4,0(a5)
    8000482e:	9736                	add	a4,a4,a3
    80004830:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004834:	6398                	ld	a4,0(a5)
    80004836:	9736                	add	a4,a4,a3
    80004838:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000483c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004840:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004844:	97aa                	add	a5,a5,a0
    80004846:	4705                	li	a4,1
    80004848:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000484c:	00017517          	auipc	a0,0x17
    80004850:	eac50513          	addi	a0,a0,-340 # 8001b6f8 <disk+0x18>
    80004854:	b29fc0ef          	jal	8000137c <wakeup>
}
    80004858:	60a2                	ld	ra,8(sp)
    8000485a:	6402                	ld	s0,0(sp)
    8000485c:	0141                	addi	sp,sp,16
    8000485e:	8082                	ret
    panic("free_desc 1");
    80004860:	00003517          	auipc	a0,0x3
    80004864:	e8050513          	addi	a0,a0,-384 # 800076e0 <etext+0x6e0>
    80004868:	43b000ef          	jal	800054a2 <panic>
    panic("free_desc 2");
    8000486c:	00003517          	auipc	a0,0x3
    80004870:	e8450513          	addi	a0,a0,-380 # 800076f0 <etext+0x6f0>
    80004874:	42f000ef          	jal	800054a2 <panic>

0000000080004878 <virtio_disk_init>:
{
    80004878:	1101                	addi	sp,sp,-32
    8000487a:	ec06                	sd	ra,24(sp)
    8000487c:	e822                	sd	s0,16(sp)
    8000487e:	e426                	sd	s1,8(sp)
    80004880:	e04a                	sd	s2,0(sp)
    80004882:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004884:	00003597          	auipc	a1,0x3
    80004888:	e7c58593          	addi	a1,a1,-388 # 80007700 <etext+0x700>
    8000488c:	00017517          	auipc	a0,0x17
    80004890:	f7c50513          	addi	a0,a0,-132 # 8001b808 <disk+0x128>
    80004894:	6bd000ef          	jal	80005750 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004898:	100017b7          	lui	a5,0x10001
    8000489c:	4398                	lw	a4,0(a5)
    8000489e:	2701                	sext.w	a4,a4
    800048a0:	747277b7          	lui	a5,0x74727
    800048a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800048a8:	18f71063          	bne	a4,a5,80004a28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800048ac:	100017b7          	lui	a5,0x10001
    800048b0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800048b2:	439c                	lw	a5,0(a5)
    800048b4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800048b6:	4709                	li	a4,2
    800048b8:	16e79863          	bne	a5,a4,80004a28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048bc:	100017b7          	lui	a5,0x10001
    800048c0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800048c2:	439c                	lw	a5,0(a5)
    800048c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800048c6:	16e79163          	bne	a5,a4,80004a28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800048ca:	100017b7          	lui	a5,0x10001
    800048ce:	47d8                	lw	a4,12(a5)
    800048d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048d2:	554d47b7          	lui	a5,0x554d4
    800048d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800048da:	14f71763          	bne	a4,a5,80004a28 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048de:	100017b7          	lui	a5,0x10001
    800048e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048e6:	4705                	li	a4,1
    800048e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048ea:	470d                	li	a4,3
    800048ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800048ee:	10001737          	lui	a4,0x10001
    800048f2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800048f4:	c7ffe737          	lui	a4,0xc7ffe
    800048f8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdae3f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800048fc:	8ef9                	and	a3,a3,a4
    800048fe:	10001737          	lui	a4,0x10001
    80004902:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004904:	472d                	li	a4,11
    80004906:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004908:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000490c:	439c                	lw	a5,0(a5)
    8000490e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004912:	8ba1                	andi	a5,a5,8
    80004914:	12078063          	beqz	a5,80004a34 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004918:	100017b7          	lui	a5,0x10001
    8000491c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004920:	100017b7          	lui	a5,0x10001
    80004924:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004928:	439c                	lw	a5,0(a5)
    8000492a:	2781                	sext.w	a5,a5
    8000492c:	10079a63          	bnez	a5,80004a40 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004930:	100017b7          	lui	a5,0x10001
    80004934:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004938:	439c                	lw	a5,0(a5)
    8000493a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000493c:	10078863          	beqz	a5,80004a4c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004940:	471d                	li	a4,7
    80004942:	10f77b63          	bgeu	a4,a5,80004a58 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004946:	fb0fb0ef          	jal	800000f6 <kalloc>
    8000494a:	00017497          	auipc	s1,0x17
    8000494e:	d9648493          	addi	s1,s1,-618 # 8001b6e0 <disk>
    80004952:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004954:	fa2fb0ef          	jal	800000f6 <kalloc>
    80004958:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000495a:	f9cfb0ef          	jal	800000f6 <kalloc>
    8000495e:	87aa                	mv	a5,a0
    80004960:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004962:	6088                	ld	a0,0(s1)
    80004964:	10050063          	beqz	a0,80004a64 <virtio_disk_init+0x1ec>
    80004968:	00017717          	auipc	a4,0x17
    8000496c:	d8073703          	ld	a4,-640(a4) # 8001b6e8 <disk+0x8>
    80004970:	0e070a63          	beqz	a4,80004a64 <virtio_disk_init+0x1ec>
    80004974:	0e078863          	beqz	a5,80004a64 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004978:	6605                	lui	a2,0x1
    8000497a:	4581                	li	a1,0
    8000497c:	fb8fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004980:	00017497          	auipc	s1,0x17
    80004984:	d6048493          	addi	s1,s1,-672 # 8001b6e0 <disk>
    80004988:	6605                	lui	a2,0x1
    8000498a:	4581                	li	a1,0
    8000498c:	6488                	ld	a0,8(s1)
    8000498e:	fa6fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    80004992:	6605                	lui	a2,0x1
    80004994:	4581                	li	a1,0
    80004996:	6888                	ld	a0,16(s1)
    80004998:	f9cfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000499c:	100017b7          	lui	a5,0x10001
    800049a0:	4721                	li	a4,8
    800049a2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800049a4:	4098                	lw	a4,0(s1)
    800049a6:	100017b7          	lui	a5,0x10001
    800049aa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800049ae:	40d8                	lw	a4,4(s1)
    800049b0:	100017b7          	lui	a5,0x10001
    800049b4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800049b8:	649c                	ld	a5,8(s1)
    800049ba:	0007869b          	sext.w	a3,a5
    800049be:	10001737          	lui	a4,0x10001
    800049c2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800049c6:	9781                	srai	a5,a5,0x20
    800049c8:	10001737          	lui	a4,0x10001
    800049cc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800049d0:	689c                	ld	a5,16(s1)
    800049d2:	0007869b          	sext.w	a3,a5
    800049d6:	10001737          	lui	a4,0x10001
    800049da:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800049de:	9781                	srai	a5,a5,0x20
    800049e0:	10001737          	lui	a4,0x10001
    800049e4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800049e8:	10001737          	lui	a4,0x10001
    800049ec:	4785                	li	a5,1
    800049ee:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800049f0:	00f48c23          	sb	a5,24(s1)
    800049f4:	00f48ca3          	sb	a5,25(s1)
    800049f8:	00f48d23          	sb	a5,26(s1)
    800049fc:	00f48da3          	sb	a5,27(s1)
    80004a00:	00f48e23          	sb	a5,28(s1)
    80004a04:	00f48ea3          	sb	a5,29(s1)
    80004a08:	00f48f23          	sb	a5,30(s1)
    80004a0c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a10:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a14:	100017b7          	lui	a5,0x10001
    80004a18:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004a1c:	60e2                	ld	ra,24(sp)
    80004a1e:	6442                	ld	s0,16(sp)
    80004a20:	64a2                	ld	s1,8(sp)
    80004a22:	6902                	ld	s2,0(sp)
    80004a24:	6105                	addi	sp,sp,32
    80004a26:	8082                	ret
    panic("could not find virtio disk");
    80004a28:	00003517          	auipc	a0,0x3
    80004a2c:	ce850513          	addi	a0,a0,-792 # 80007710 <etext+0x710>
    80004a30:	273000ef          	jal	800054a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004a34:	00003517          	auipc	a0,0x3
    80004a38:	cfc50513          	addi	a0,a0,-772 # 80007730 <etext+0x730>
    80004a3c:	267000ef          	jal	800054a2 <panic>
    panic("virtio disk should not be ready");
    80004a40:	00003517          	auipc	a0,0x3
    80004a44:	d1050513          	addi	a0,a0,-752 # 80007750 <etext+0x750>
    80004a48:	25b000ef          	jal	800054a2 <panic>
    panic("virtio disk has no queue 0");
    80004a4c:	00003517          	auipc	a0,0x3
    80004a50:	d2450513          	addi	a0,a0,-732 # 80007770 <etext+0x770>
    80004a54:	24f000ef          	jal	800054a2 <panic>
    panic("virtio disk max queue too short");
    80004a58:	00003517          	auipc	a0,0x3
    80004a5c:	d3850513          	addi	a0,a0,-712 # 80007790 <etext+0x790>
    80004a60:	243000ef          	jal	800054a2 <panic>
    panic("virtio disk kalloc");
    80004a64:	00003517          	auipc	a0,0x3
    80004a68:	d4c50513          	addi	a0,a0,-692 # 800077b0 <etext+0x7b0>
    80004a6c:	237000ef          	jal	800054a2 <panic>

0000000080004a70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004a70:	7159                	addi	sp,sp,-112
    80004a72:	f486                	sd	ra,104(sp)
    80004a74:	f0a2                	sd	s0,96(sp)
    80004a76:	eca6                	sd	s1,88(sp)
    80004a78:	e8ca                	sd	s2,80(sp)
    80004a7a:	e4ce                	sd	s3,72(sp)
    80004a7c:	e0d2                	sd	s4,64(sp)
    80004a7e:	fc56                	sd	s5,56(sp)
    80004a80:	f85a                	sd	s6,48(sp)
    80004a82:	f45e                	sd	s7,40(sp)
    80004a84:	f062                	sd	s8,32(sp)
    80004a86:	ec66                	sd	s9,24(sp)
    80004a88:	1880                	addi	s0,sp,112
    80004a8a:	8a2a                	mv	s4,a0
    80004a8c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004a8e:	00c52c83          	lw	s9,12(a0)
    80004a92:	001c9c9b          	slliw	s9,s9,0x1
    80004a96:	1c82                	slli	s9,s9,0x20
    80004a98:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004a9c:	00017517          	auipc	a0,0x17
    80004aa0:	d6c50513          	addi	a0,a0,-660 # 8001b808 <disk+0x128>
    80004aa4:	52d000ef          	jal	800057d0 <acquire>
  for(int i = 0; i < 3; i++){
    80004aa8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004aaa:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004aac:	00017b17          	auipc	s6,0x17
    80004ab0:	c34b0b13          	addi	s6,s6,-972 # 8001b6e0 <disk>
  for(int i = 0; i < 3; i++){
    80004ab4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004ab6:	00017c17          	auipc	s8,0x17
    80004aba:	d52c0c13          	addi	s8,s8,-686 # 8001b808 <disk+0x128>
    80004abe:	a8b9                	j	80004b1c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004ac0:	00fb0733          	add	a4,s6,a5
    80004ac4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004ac8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004aca:	0207c563          	bltz	a5,80004af4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004ace:	2905                	addiw	s2,s2,1
    80004ad0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004ad2:	05590963          	beq	s2,s5,80004b24 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004ad6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004ad8:	00017717          	auipc	a4,0x17
    80004adc:	c0870713          	addi	a4,a4,-1016 # 8001b6e0 <disk>
    80004ae0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004ae2:	01874683          	lbu	a3,24(a4)
    80004ae6:	fee9                	bnez	a3,80004ac0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004ae8:	2785                	addiw	a5,a5,1
    80004aea:	0705                	addi	a4,a4,1
    80004aec:	fe979be3          	bne	a5,s1,80004ae2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004af0:	57fd                	li	a5,-1
    80004af2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004af4:	01205d63          	blez	s2,80004b0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004af8:	f9042503          	lw	a0,-112(s0)
    80004afc:	d07ff0ef          	jal	80004802 <free_desc>
      for(int j = 0; j < i; j++)
    80004b00:	4785                	li	a5,1
    80004b02:	0127d663          	bge	a5,s2,80004b0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b06:	f9442503          	lw	a0,-108(s0)
    80004b0a:	cf9ff0ef          	jal	80004802 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b0e:	85e2                	mv	a1,s8
    80004b10:	00017517          	auipc	a0,0x17
    80004b14:	be850513          	addi	a0,a0,-1048 # 8001b6f8 <disk+0x18>
    80004b18:	819fc0ef          	jal	80001330 <sleep>
  for(int i = 0; i < 3; i++){
    80004b1c:	f9040613          	addi	a2,s0,-112
    80004b20:	894e                	mv	s2,s3
    80004b22:	bf55                	j	80004ad6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b24:	f9042503          	lw	a0,-112(s0)
    80004b28:	00451693          	slli	a3,a0,0x4

  if(write)
    80004b2c:	00017797          	auipc	a5,0x17
    80004b30:	bb478793          	addi	a5,a5,-1100 # 8001b6e0 <disk>
    80004b34:	00a50713          	addi	a4,a0,10
    80004b38:	0712                	slli	a4,a4,0x4
    80004b3a:	973e                	add	a4,a4,a5
    80004b3c:	01703633          	snez	a2,s7
    80004b40:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004b42:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004b46:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b4a:	6398                	ld	a4,0(a5)
    80004b4c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b4e:	0a868613          	addi	a2,a3,168
    80004b52:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b54:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004b56:	6390                	ld	a2,0(a5)
    80004b58:	00d605b3          	add	a1,a2,a3
    80004b5c:	4741                	li	a4,16
    80004b5e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004b60:	4805                	li	a6,1
    80004b62:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004b66:	f9442703          	lw	a4,-108(s0)
    80004b6a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004b6e:	0712                	slli	a4,a4,0x4
    80004b70:	963a                	add	a2,a2,a4
    80004b72:	058a0593          	addi	a1,s4,88
    80004b76:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004b78:	0007b883          	ld	a7,0(a5)
    80004b7c:	9746                	add	a4,a4,a7
    80004b7e:	40000613          	li	a2,1024
    80004b82:	c710                	sw	a2,8(a4)
  if(write)
    80004b84:	001bb613          	seqz	a2,s7
    80004b88:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004b8c:	00166613          	ori	a2,a2,1
    80004b90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004b94:	f9842583          	lw	a1,-104(s0)
    80004b98:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004b9c:	00250613          	addi	a2,a0,2
    80004ba0:	0612                	slli	a2,a2,0x4
    80004ba2:	963e                	add	a2,a2,a5
    80004ba4:	577d                	li	a4,-1
    80004ba6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004baa:	0592                	slli	a1,a1,0x4
    80004bac:	98ae                	add	a7,a7,a1
    80004bae:	03068713          	addi	a4,a3,48
    80004bb2:	973e                	add	a4,a4,a5
    80004bb4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004bb8:	6398                	ld	a4,0(a5)
    80004bba:	972e                	add	a4,a4,a1
    80004bbc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004bc0:	4689                	li	a3,2
    80004bc2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004bc6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004bca:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004bce:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004bd2:	6794                	ld	a3,8(a5)
    80004bd4:	0026d703          	lhu	a4,2(a3)
    80004bd8:	8b1d                	andi	a4,a4,7
    80004bda:	0706                	slli	a4,a4,0x1
    80004bdc:	96ba                	add	a3,a3,a4
    80004bde:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004be2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004be6:	6798                	ld	a4,8(a5)
    80004be8:	00275783          	lhu	a5,2(a4)
    80004bec:	2785                	addiw	a5,a5,1
    80004bee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004bf2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004bf6:	100017b7          	lui	a5,0x10001
    80004bfa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004bfe:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004c02:	00017917          	auipc	s2,0x17
    80004c06:	c0690913          	addi	s2,s2,-1018 # 8001b808 <disk+0x128>
  while(b->disk == 1) {
    80004c0a:	4485                	li	s1,1
    80004c0c:	01079a63          	bne	a5,a6,80004c20 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004c10:	85ca                	mv	a1,s2
    80004c12:	8552                	mv	a0,s4
    80004c14:	f1cfc0ef          	jal	80001330 <sleep>
  while(b->disk == 1) {
    80004c18:	004a2783          	lw	a5,4(s4)
    80004c1c:	fe978ae3          	beq	a5,s1,80004c10 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004c20:	f9042903          	lw	s2,-112(s0)
    80004c24:	00290713          	addi	a4,s2,2
    80004c28:	0712                	slli	a4,a4,0x4
    80004c2a:	00017797          	auipc	a5,0x17
    80004c2e:	ab678793          	addi	a5,a5,-1354 # 8001b6e0 <disk>
    80004c32:	97ba                	add	a5,a5,a4
    80004c34:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004c38:	00017997          	auipc	s3,0x17
    80004c3c:	aa898993          	addi	s3,s3,-1368 # 8001b6e0 <disk>
    80004c40:	00491713          	slli	a4,s2,0x4
    80004c44:	0009b783          	ld	a5,0(s3)
    80004c48:	97ba                	add	a5,a5,a4
    80004c4a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004c4e:	854a                	mv	a0,s2
    80004c50:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004c54:	bafff0ef          	jal	80004802 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004c58:	8885                	andi	s1,s1,1
    80004c5a:	f0fd                	bnez	s1,80004c40 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004c5c:	00017517          	auipc	a0,0x17
    80004c60:	bac50513          	addi	a0,a0,-1108 # 8001b808 <disk+0x128>
    80004c64:	405000ef          	jal	80005868 <release>
}
    80004c68:	70a6                	ld	ra,104(sp)
    80004c6a:	7406                	ld	s0,96(sp)
    80004c6c:	64e6                	ld	s1,88(sp)
    80004c6e:	6946                	ld	s2,80(sp)
    80004c70:	69a6                	ld	s3,72(sp)
    80004c72:	6a06                	ld	s4,64(sp)
    80004c74:	7ae2                	ld	s5,56(sp)
    80004c76:	7b42                	ld	s6,48(sp)
    80004c78:	7ba2                	ld	s7,40(sp)
    80004c7a:	7c02                	ld	s8,32(sp)
    80004c7c:	6ce2                	ld	s9,24(sp)
    80004c7e:	6165                	addi	sp,sp,112
    80004c80:	8082                	ret

0000000080004c82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004c82:	1101                	addi	sp,sp,-32
    80004c84:	ec06                	sd	ra,24(sp)
    80004c86:	e822                	sd	s0,16(sp)
    80004c88:	e426                	sd	s1,8(sp)
    80004c8a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004c8c:	00017497          	auipc	s1,0x17
    80004c90:	a5448493          	addi	s1,s1,-1452 # 8001b6e0 <disk>
    80004c94:	00017517          	auipc	a0,0x17
    80004c98:	b7450513          	addi	a0,a0,-1164 # 8001b808 <disk+0x128>
    80004c9c:	335000ef          	jal	800057d0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004ca0:	100017b7          	lui	a5,0x10001
    80004ca4:	53b8                	lw	a4,96(a5)
    80004ca6:	8b0d                	andi	a4,a4,3
    80004ca8:	100017b7          	lui	a5,0x10001
    80004cac:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004cae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004cb2:	689c                	ld	a5,16(s1)
    80004cb4:	0204d703          	lhu	a4,32(s1)
    80004cb8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004cbc:	04f70663          	beq	a4,a5,80004d08 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004cc0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004cc4:	6898                	ld	a4,16(s1)
    80004cc6:	0204d783          	lhu	a5,32(s1)
    80004cca:	8b9d                	andi	a5,a5,7
    80004ccc:	078e                	slli	a5,a5,0x3
    80004cce:	97ba                	add	a5,a5,a4
    80004cd0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004cd2:	00278713          	addi	a4,a5,2
    80004cd6:	0712                	slli	a4,a4,0x4
    80004cd8:	9726                	add	a4,a4,s1
    80004cda:	01074703          	lbu	a4,16(a4)
    80004cde:	e321                	bnez	a4,80004d1e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004ce0:	0789                	addi	a5,a5,2
    80004ce2:	0792                	slli	a5,a5,0x4
    80004ce4:	97a6                	add	a5,a5,s1
    80004ce6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004ce8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004cec:	e90fc0ef          	jal	8000137c <wakeup>

    disk.used_idx += 1;
    80004cf0:	0204d783          	lhu	a5,32(s1)
    80004cf4:	2785                	addiw	a5,a5,1
    80004cf6:	17c2                	slli	a5,a5,0x30
    80004cf8:	93c1                	srli	a5,a5,0x30
    80004cfa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004cfe:	6898                	ld	a4,16(s1)
    80004d00:	00275703          	lhu	a4,2(a4)
    80004d04:	faf71ee3          	bne	a4,a5,80004cc0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004d08:	00017517          	auipc	a0,0x17
    80004d0c:	b0050513          	addi	a0,a0,-1280 # 8001b808 <disk+0x128>
    80004d10:	359000ef          	jal	80005868 <release>
}
    80004d14:	60e2                	ld	ra,24(sp)
    80004d16:	6442                	ld	s0,16(sp)
    80004d18:	64a2                	ld	s1,8(sp)
    80004d1a:	6105                	addi	sp,sp,32
    80004d1c:	8082                	ret
      panic("virtio_disk_intr status");
    80004d1e:	00003517          	auipc	a0,0x3
    80004d22:	aaa50513          	addi	a0,a0,-1366 # 800077c8 <etext+0x7c8>
    80004d26:	77c000ef          	jal	800054a2 <panic>

0000000080004d2a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d2a:	1141                	addi	sp,sp,-16
    80004d2c:	e422                	sd	s0,8(sp)
    80004d2e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004d30:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004d34:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004d38:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004d3c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004d40:	577d                	li	a4,-1
    80004d42:	177e                	slli	a4,a4,0x3f
    80004d44:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004d46:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004d4a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004d4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004d52:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004d56:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004d5a:	000f4737          	lui	a4,0xf4
    80004d5e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004d62:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004d64:	14d79073          	csrw	stimecmp,a5
}
    80004d68:	6422                	ld	s0,8(sp)
    80004d6a:	0141                	addi	sp,sp,16
    80004d6c:	8082                	ret

0000000080004d6e <start>:
{
    80004d6e:	1141                	addi	sp,sp,-16
    80004d70:	e406                	sd	ra,8(sp)
    80004d72:	e022                	sd	s0,0(sp)
    80004d74:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004d76:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004d7a:	7779                	lui	a4,0xffffe
    80004d7c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaedf>
    80004d80:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004d82:	6705                	lui	a4,0x1
    80004d84:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004d88:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004d8a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004d8e:	ffffb797          	auipc	a5,0xffffb
    80004d92:	54078793          	addi	a5,a5,1344 # 800002ce <main>
    80004d96:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004d9a:	4781                	li	a5,0
    80004d9c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004da0:	67c1                	lui	a5,0x10
    80004da2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004da4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004da8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004dac:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004db0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004db4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004db8:	57fd                	li	a5,-1
    80004dba:	83a9                	srli	a5,a5,0xa
    80004dbc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004dc0:	47bd                	li	a5,15
    80004dc2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004dc6:	f65ff0ef          	jal	80004d2a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004dca:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004dce:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004dd0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004dd2:	30200073          	mret
}
    80004dd6:	60a2                	ld	ra,8(sp)
    80004dd8:	6402                	ld	s0,0(sp)
    80004dda:	0141                	addi	sp,sp,16
    80004ddc:	8082                	ret

0000000080004dde <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004dde:	715d                	addi	sp,sp,-80
    80004de0:	e486                	sd	ra,72(sp)
    80004de2:	e0a2                	sd	s0,64(sp)
    80004de4:	f84a                	sd	s2,48(sp)
    80004de6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004de8:	04c05263          	blez	a2,80004e2c <consolewrite+0x4e>
    80004dec:	fc26                	sd	s1,56(sp)
    80004dee:	f44e                	sd	s3,40(sp)
    80004df0:	f052                	sd	s4,32(sp)
    80004df2:	ec56                	sd	s5,24(sp)
    80004df4:	8a2a                	mv	s4,a0
    80004df6:	84ae                	mv	s1,a1
    80004df8:	89b2                	mv	s3,a2
    80004dfa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004dfc:	5afd                	li	s5,-1
    80004dfe:	4685                	li	a3,1
    80004e00:	8626                	mv	a2,s1
    80004e02:	85d2                	mv	a1,s4
    80004e04:	fbf40513          	addi	a0,s0,-65
    80004e08:	8cffc0ef          	jal	800016d6 <either_copyin>
    80004e0c:	03550263          	beq	a0,s5,80004e30 <consolewrite+0x52>
      break;
    uartputc(c);
    80004e10:	fbf44503          	lbu	a0,-65(s0)
    80004e14:	035000ef          	jal	80005648 <uartputc>
  for(i = 0; i < n; i++){
    80004e18:	2905                	addiw	s2,s2,1
    80004e1a:	0485                	addi	s1,s1,1
    80004e1c:	ff2991e3          	bne	s3,s2,80004dfe <consolewrite+0x20>
    80004e20:	894e                	mv	s2,s3
    80004e22:	74e2                	ld	s1,56(sp)
    80004e24:	79a2                	ld	s3,40(sp)
    80004e26:	7a02                	ld	s4,32(sp)
    80004e28:	6ae2                	ld	s5,24(sp)
    80004e2a:	a039                	j	80004e38 <consolewrite+0x5a>
    80004e2c:	4901                	li	s2,0
    80004e2e:	a029                	j	80004e38 <consolewrite+0x5a>
    80004e30:	74e2                	ld	s1,56(sp)
    80004e32:	79a2                	ld	s3,40(sp)
    80004e34:	7a02                	ld	s4,32(sp)
    80004e36:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004e38:	854a                	mv	a0,s2
    80004e3a:	60a6                	ld	ra,72(sp)
    80004e3c:	6406                	ld	s0,64(sp)
    80004e3e:	7942                	ld	s2,48(sp)
    80004e40:	6161                	addi	sp,sp,80
    80004e42:	8082                	ret

0000000080004e44 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004e44:	711d                	addi	sp,sp,-96
    80004e46:	ec86                	sd	ra,88(sp)
    80004e48:	e8a2                	sd	s0,80(sp)
    80004e4a:	e4a6                	sd	s1,72(sp)
    80004e4c:	e0ca                	sd	s2,64(sp)
    80004e4e:	fc4e                	sd	s3,56(sp)
    80004e50:	f852                	sd	s4,48(sp)
    80004e52:	f456                	sd	s5,40(sp)
    80004e54:	f05a                	sd	s6,32(sp)
    80004e56:	1080                	addi	s0,sp,96
    80004e58:	8aaa                	mv	s5,a0
    80004e5a:	8a2e                	mv	s4,a1
    80004e5c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004e5e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004e62:	0001f517          	auipc	a0,0x1f
    80004e66:	9be50513          	addi	a0,a0,-1602 # 80023820 <cons>
    80004e6a:	167000ef          	jal	800057d0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004e6e:	0001f497          	auipc	s1,0x1f
    80004e72:	9b248493          	addi	s1,s1,-1614 # 80023820 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004e76:	0001f917          	auipc	s2,0x1f
    80004e7a:	a4290913          	addi	s2,s2,-1470 # 800238b8 <cons+0x98>
  while(n > 0){
    80004e7e:	0b305d63          	blez	s3,80004f38 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004e82:	0984a783          	lw	a5,152(s1)
    80004e86:	09c4a703          	lw	a4,156(s1)
    80004e8a:	0af71263          	bne	a4,a5,80004f2e <consoleread+0xea>
      if(killed(myproc())){
    80004e8e:	ec9fb0ef          	jal	80000d56 <myproc>
    80004e92:	ed6fc0ef          	jal	80001568 <killed>
    80004e96:	e12d                	bnez	a0,80004ef8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004e98:	85a6                	mv	a1,s1
    80004e9a:	854a                	mv	a0,s2
    80004e9c:	c94fc0ef          	jal	80001330 <sleep>
    while(cons.r == cons.w){
    80004ea0:	0984a783          	lw	a5,152(s1)
    80004ea4:	09c4a703          	lw	a4,156(s1)
    80004ea8:	fef703e3          	beq	a4,a5,80004e8e <consoleread+0x4a>
    80004eac:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004eae:	0001f717          	auipc	a4,0x1f
    80004eb2:	97270713          	addi	a4,a4,-1678 # 80023820 <cons>
    80004eb6:	0017869b          	addiw	a3,a5,1
    80004eba:	08d72c23          	sw	a3,152(a4)
    80004ebe:	07f7f693          	andi	a3,a5,127
    80004ec2:	9736                	add	a4,a4,a3
    80004ec4:	01874703          	lbu	a4,24(a4)
    80004ec8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004ecc:	4691                	li	a3,4
    80004ece:	04db8663          	beq	s7,a3,80004f1a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004ed2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004ed6:	4685                	li	a3,1
    80004ed8:	faf40613          	addi	a2,s0,-81
    80004edc:	85d2                	mv	a1,s4
    80004ede:	8556                	mv	a0,s5
    80004ee0:	facfc0ef          	jal	8000168c <either_copyout>
    80004ee4:	57fd                	li	a5,-1
    80004ee6:	04f50863          	beq	a0,a5,80004f36 <consoleread+0xf2>
      break;

    dst++;
    80004eea:	0a05                	addi	s4,s4,1
    --n;
    80004eec:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004eee:	47a9                	li	a5,10
    80004ef0:	04fb8d63          	beq	s7,a5,80004f4a <consoleread+0x106>
    80004ef4:	6be2                	ld	s7,24(sp)
    80004ef6:	b761                	j	80004e7e <consoleread+0x3a>
        release(&cons.lock);
    80004ef8:	0001f517          	auipc	a0,0x1f
    80004efc:	92850513          	addi	a0,a0,-1752 # 80023820 <cons>
    80004f00:	169000ef          	jal	80005868 <release>
        return -1;
    80004f04:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004f06:	60e6                	ld	ra,88(sp)
    80004f08:	6446                	ld	s0,80(sp)
    80004f0a:	64a6                	ld	s1,72(sp)
    80004f0c:	6906                	ld	s2,64(sp)
    80004f0e:	79e2                	ld	s3,56(sp)
    80004f10:	7a42                	ld	s4,48(sp)
    80004f12:	7aa2                	ld	s5,40(sp)
    80004f14:	7b02                	ld	s6,32(sp)
    80004f16:	6125                	addi	sp,sp,96
    80004f18:	8082                	ret
      if(n < target){
    80004f1a:	0009871b          	sext.w	a4,s3
    80004f1e:	01677a63          	bgeu	a4,s6,80004f32 <consoleread+0xee>
        cons.r--;
    80004f22:	0001f717          	auipc	a4,0x1f
    80004f26:	98f72b23          	sw	a5,-1642(a4) # 800238b8 <cons+0x98>
    80004f2a:	6be2                	ld	s7,24(sp)
    80004f2c:	a031                	j	80004f38 <consoleread+0xf4>
    80004f2e:	ec5e                	sd	s7,24(sp)
    80004f30:	bfbd                	j	80004eae <consoleread+0x6a>
    80004f32:	6be2                	ld	s7,24(sp)
    80004f34:	a011                	j	80004f38 <consoleread+0xf4>
    80004f36:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004f38:	0001f517          	auipc	a0,0x1f
    80004f3c:	8e850513          	addi	a0,a0,-1816 # 80023820 <cons>
    80004f40:	129000ef          	jal	80005868 <release>
  return target - n;
    80004f44:	413b053b          	subw	a0,s6,s3
    80004f48:	bf7d                	j	80004f06 <consoleread+0xc2>
    80004f4a:	6be2                	ld	s7,24(sp)
    80004f4c:	b7f5                	j	80004f38 <consoleread+0xf4>

0000000080004f4e <consputc>:
{
    80004f4e:	1141                	addi	sp,sp,-16
    80004f50:	e406                	sd	ra,8(sp)
    80004f52:	e022                	sd	s0,0(sp)
    80004f54:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004f56:	10000793          	li	a5,256
    80004f5a:	00f50863          	beq	a0,a5,80004f6a <consputc+0x1c>
    uartputc_sync(c);
    80004f5e:	604000ef          	jal	80005562 <uartputc_sync>
}
    80004f62:	60a2                	ld	ra,8(sp)
    80004f64:	6402                	ld	s0,0(sp)
    80004f66:	0141                	addi	sp,sp,16
    80004f68:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004f6a:	4521                	li	a0,8
    80004f6c:	5f6000ef          	jal	80005562 <uartputc_sync>
    80004f70:	02000513          	li	a0,32
    80004f74:	5ee000ef          	jal	80005562 <uartputc_sync>
    80004f78:	4521                	li	a0,8
    80004f7a:	5e8000ef          	jal	80005562 <uartputc_sync>
    80004f7e:	b7d5                	j	80004f62 <consputc+0x14>

0000000080004f80 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004f80:	1101                	addi	sp,sp,-32
    80004f82:	ec06                	sd	ra,24(sp)
    80004f84:	e822                	sd	s0,16(sp)
    80004f86:	e426                	sd	s1,8(sp)
    80004f88:	1000                	addi	s0,sp,32
    80004f8a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004f8c:	0001f517          	auipc	a0,0x1f
    80004f90:	89450513          	addi	a0,a0,-1900 # 80023820 <cons>
    80004f94:	03d000ef          	jal	800057d0 <acquire>

  switch(c){
    80004f98:	47d5                	li	a5,21
    80004f9a:	08f48f63          	beq	s1,a5,80005038 <consoleintr+0xb8>
    80004f9e:	0297c563          	blt	a5,s1,80004fc8 <consoleintr+0x48>
    80004fa2:	47a1                	li	a5,8
    80004fa4:	0ef48463          	beq	s1,a5,8000508c <consoleintr+0x10c>
    80004fa8:	47c1                	li	a5,16
    80004faa:	10f49563          	bne	s1,a5,800050b4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80004fae:	f72fc0ef          	jal	80001720 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004fb2:	0001f517          	auipc	a0,0x1f
    80004fb6:	86e50513          	addi	a0,a0,-1938 # 80023820 <cons>
    80004fba:	0af000ef          	jal	80005868 <release>
}
    80004fbe:	60e2                	ld	ra,24(sp)
    80004fc0:	6442                	ld	s0,16(sp)
    80004fc2:	64a2                	ld	s1,8(sp)
    80004fc4:	6105                	addi	sp,sp,32
    80004fc6:	8082                	ret
  switch(c){
    80004fc8:	07f00793          	li	a5,127
    80004fcc:	0cf48063          	beq	s1,a5,8000508c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004fd0:	0001f717          	auipc	a4,0x1f
    80004fd4:	85070713          	addi	a4,a4,-1968 # 80023820 <cons>
    80004fd8:	0a072783          	lw	a5,160(a4)
    80004fdc:	09872703          	lw	a4,152(a4)
    80004fe0:	9f99                	subw	a5,a5,a4
    80004fe2:	07f00713          	li	a4,127
    80004fe6:	fcf766e3          	bltu	a4,a5,80004fb2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004fea:	47b5                	li	a5,13
    80004fec:	0cf48763          	beq	s1,a5,800050ba <consoleintr+0x13a>
      consputc(c);
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	f5dff0ef          	jal	80004f4e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004ff6:	0001f797          	auipc	a5,0x1f
    80004ffa:	82a78793          	addi	a5,a5,-2006 # 80023820 <cons>
    80004ffe:	0a07a683          	lw	a3,160(a5)
    80005002:	0016871b          	addiw	a4,a3,1
    80005006:	0007061b          	sext.w	a2,a4
    8000500a:	0ae7a023          	sw	a4,160(a5)
    8000500e:	07f6f693          	andi	a3,a3,127
    80005012:	97b6                	add	a5,a5,a3
    80005014:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005018:	47a9                	li	a5,10
    8000501a:	0cf48563          	beq	s1,a5,800050e4 <consoleintr+0x164>
    8000501e:	4791                	li	a5,4
    80005020:	0cf48263          	beq	s1,a5,800050e4 <consoleintr+0x164>
    80005024:	0001f797          	auipc	a5,0x1f
    80005028:	8947a783          	lw	a5,-1900(a5) # 800238b8 <cons+0x98>
    8000502c:	9f1d                	subw	a4,a4,a5
    8000502e:	08000793          	li	a5,128
    80005032:	f8f710e3          	bne	a4,a5,80004fb2 <consoleintr+0x32>
    80005036:	a07d                	j	800050e4 <consoleintr+0x164>
    80005038:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000503a:	0001e717          	auipc	a4,0x1e
    8000503e:	7e670713          	addi	a4,a4,2022 # 80023820 <cons>
    80005042:	0a072783          	lw	a5,160(a4)
    80005046:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000504a:	0001e497          	auipc	s1,0x1e
    8000504e:	7d648493          	addi	s1,s1,2006 # 80023820 <cons>
    while(cons.e != cons.w &&
    80005052:	4929                	li	s2,10
    80005054:	02f70863          	beq	a4,a5,80005084 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005058:	37fd                	addiw	a5,a5,-1
    8000505a:	07f7f713          	andi	a4,a5,127
    8000505e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005060:	01874703          	lbu	a4,24(a4)
    80005064:	03270263          	beq	a4,s2,80005088 <consoleintr+0x108>
      cons.e--;
    80005068:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000506c:	10000513          	li	a0,256
    80005070:	edfff0ef          	jal	80004f4e <consputc>
    while(cons.e != cons.w &&
    80005074:	0a04a783          	lw	a5,160(s1)
    80005078:	09c4a703          	lw	a4,156(s1)
    8000507c:	fcf71ee3          	bne	a4,a5,80005058 <consoleintr+0xd8>
    80005080:	6902                	ld	s2,0(sp)
    80005082:	bf05                	j	80004fb2 <consoleintr+0x32>
    80005084:	6902                	ld	s2,0(sp)
    80005086:	b735                	j	80004fb2 <consoleintr+0x32>
    80005088:	6902                	ld	s2,0(sp)
    8000508a:	b725                	j	80004fb2 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000508c:	0001e717          	auipc	a4,0x1e
    80005090:	79470713          	addi	a4,a4,1940 # 80023820 <cons>
    80005094:	0a072783          	lw	a5,160(a4)
    80005098:	09c72703          	lw	a4,156(a4)
    8000509c:	f0f70be3          	beq	a4,a5,80004fb2 <consoleintr+0x32>
      cons.e--;
    800050a0:	37fd                	addiw	a5,a5,-1
    800050a2:	0001f717          	auipc	a4,0x1f
    800050a6:	80f72f23          	sw	a5,-2018(a4) # 800238c0 <cons+0xa0>
      consputc(BACKSPACE);
    800050aa:	10000513          	li	a0,256
    800050ae:	ea1ff0ef          	jal	80004f4e <consputc>
    800050b2:	b701                	j	80004fb2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800050b4:	ee048fe3          	beqz	s1,80004fb2 <consoleintr+0x32>
    800050b8:	bf21                	j	80004fd0 <consoleintr+0x50>
      consputc(c);
    800050ba:	4529                	li	a0,10
    800050bc:	e93ff0ef          	jal	80004f4e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050c0:	0001e797          	auipc	a5,0x1e
    800050c4:	76078793          	addi	a5,a5,1888 # 80023820 <cons>
    800050c8:	0a07a703          	lw	a4,160(a5)
    800050cc:	0017069b          	addiw	a3,a4,1
    800050d0:	0006861b          	sext.w	a2,a3
    800050d4:	0ad7a023          	sw	a3,160(a5)
    800050d8:	07f77713          	andi	a4,a4,127
    800050dc:	97ba                	add	a5,a5,a4
    800050de:	4729                	li	a4,10
    800050e0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800050e4:	0001e797          	auipc	a5,0x1e
    800050e8:	7cc7ac23          	sw	a2,2008(a5) # 800238bc <cons+0x9c>
        wakeup(&cons.r);
    800050ec:	0001e517          	auipc	a0,0x1e
    800050f0:	7cc50513          	addi	a0,a0,1996 # 800238b8 <cons+0x98>
    800050f4:	a88fc0ef          	jal	8000137c <wakeup>
    800050f8:	bd6d                	j	80004fb2 <consoleintr+0x32>

00000000800050fa <consoleinit>:

void
consoleinit(void)
{
    800050fa:	1141                	addi	sp,sp,-16
    800050fc:	e406                	sd	ra,8(sp)
    800050fe:	e022                	sd	s0,0(sp)
    80005100:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005102:	00002597          	auipc	a1,0x2
    80005106:	6de58593          	addi	a1,a1,1758 # 800077e0 <etext+0x7e0>
    8000510a:	0001e517          	auipc	a0,0x1e
    8000510e:	71650513          	addi	a0,a0,1814 # 80023820 <cons>
    80005112:	63e000ef          	jal	80005750 <initlock>

  uartinit();
    80005116:	3f4000ef          	jal	8000550a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000511a:	00015797          	auipc	a5,0x15
    8000511e:	56e78793          	addi	a5,a5,1390 # 8001a688 <devsw>
    80005122:	00000717          	auipc	a4,0x0
    80005126:	d2270713          	addi	a4,a4,-734 # 80004e44 <consoleread>
    8000512a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000512c:	00000717          	auipc	a4,0x0
    80005130:	cb270713          	addi	a4,a4,-846 # 80004dde <consolewrite>
    80005134:	ef98                	sd	a4,24(a5)
}
    80005136:	60a2                	ld	ra,8(sp)
    80005138:	6402                	ld	s0,0(sp)
    8000513a:	0141                	addi	sp,sp,16
    8000513c:	8082                	ret

000000008000513e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000513e:	7179                	addi	sp,sp,-48
    80005140:	f406                	sd	ra,40(sp)
    80005142:	f022                	sd	s0,32(sp)
    80005144:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005146:	c219                	beqz	a2,8000514c <printint+0xe>
    80005148:	08054063          	bltz	a0,800051c8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000514c:	4881                	li	a7,0
    8000514e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005152:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005154:	00003617          	auipc	a2,0x3
    80005158:	8ac60613          	addi	a2,a2,-1876 # 80007a00 <digits>
    8000515c:	883e                	mv	a6,a5
    8000515e:	2785                	addiw	a5,a5,1
    80005160:	02b57733          	remu	a4,a0,a1
    80005164:	9732                	add	a4,a4,a2
    80005166:	00074703          	lbu	a4,0(a4)
    8000516a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000516e:	872a                	mv	a4,a0
    80005170:	02b55533          	divu	a0,a0,a1
    80005174:	0685                	addi	a3,a3,1
    80005176:	feb773e3          	bgeu	a4,a1,8000515c <printint+0x1e>

  if(sign)
    8000517a:	00088a63          	beqz	a7,8000518e <printint+0x50>
    buf[i++] = '-';
    8000517e:	1781                	addi	a5,a5,-32
    80005180:	97a2                	add	a5,a5,s0
    80005182:	02d00713          	li	a4,45
    80005186:	fee78823          	sb	a4,-16(a5)
    8000518a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000518e:	02f05963          	blez	a5,800051c0 <printint+0x82>
    80005192:	ec26                	sd	s1,24(sp)
    80005194:	e84a                	sd	s2,16(sp)
    80005196:	fd040713          	addi	a4,s0,-48
    8000519a:	00f704b3          	add	s1,a4,a5
    8000519e:	fff70913          	addi	s2,a4,-1
    800051a2:	993e                	add	s2,s2,a5
    800051a4:	37fd                	addiw	a5,a5,-1
    800051a6:	1782                	slli	a5,a5,0x20
    800051a8:	9381                	srli	a5,a5,0x20
    800051aa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800051ae:	fff4c503          	lbu	a0,-1(s1)
    800051b2:	d9dff0ef          	jal	80004f4e <consputc>
  while(--i >= 0)
    800051b6:	14fd                	addi	s1,s1,-1
    800051b8:	ff249be3          	bne	s1,s2,800051ae <printint+0x70>
    800051bc:	64e2                	ld	s1,24(sp)
    800051be:	6942                	ld	s2,16(sp)
}
    800051c0:	70a2                	ld	ra,40(sp)
    800051c2:	7402                	ld	s0,32(sp)
    800051c4:	6145                	addi	sp,sp,48
    800051c6:	8082                	ret
    x = -xx;
    800051c8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800051cc:	4885                	li	a7,1
    x = -xx;
    800051ce:	b741                	j	8000514e <printint+0x10>

00000000800051d0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800051d0:	7155                	addi	sp,sp,-208
    800051d2:	e506                	sd	ra,136(sp)
    800051d4:	e122                	sd	s0,128(sp)
    800051d6:	f0d2                	sd	s4,96(sp)
    800051d8:	0900                	addi	s0,sp,144
    800051da:	8a2a                	mv	s4,a0
    800051dc:	e40c                	sd	a1,8(s0)
    800051de:	e810                	sd	a2,16(s0)
    800051e0:	ec14                	sd	a3,24(s0)
    800051e2:	f018                	sd	a4,32(s0)
    800051e4:	f41c                	sd	a5,40(s0)
    800051e6:	03043823          	sd	a6,48(s0)
    800051ea:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800051ee:	0001e797          	auipc	a5,0x1e
    800051f2:	6f27a783          	lw	a5,1778(a5) # 800238e0 <pr+0x18>
    800051f6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800051fa:	e3a1                	bnez	a5,8000523a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800051fc:	00840793          	addi	a5,s0,8
    80005200:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005204:	00054503          	lbu	a0,0(a0)
    80005208:	26050763          	beqz	a0,80005476 <printf+0x2a6>
    8000520c:	fca6                	sd	s1,120(sp)
    8000520e:	f8ca                	sd	s2,112(sp)
    80005210:	f4ce                	sd	s3,104(sp)
    80005212:	ecd6                	sd	s5,88(sp)
    80005214:	e8da                	sd	s6,80(sp)
    80005216:	e0e2                	sd	s8,64(sp)
    80005218:	fc66                	sd	s9,56(sp)
    8000521a:	f86a                	sd	s10,48(sp)
    8000521c:	f46e                	sd	s11,40(sp)
    8000521e:	4981                	li	s3,0
    if(cx != '%'){
    80005220:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005224:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005228:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000522c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005230:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005234:	07000d93          	li	s11,112
    80005238:	a815                	j	8000526c <printf+0x9c>
    acquire(&pr.lock);
    8000523a:	0001e517          	auipc	a0,0x1e
    8000523e:	68e50513          	addi	a0,a0,1678 # 800238c8 <pr>
    80005242:	58e000ef          	jal	800057d0 <acquire>
  va_start(ap, fmt);
    80005246:	00840793          	addi	a5,s0,8
    8000524a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000524e:	000a4503          	lbu	a0,0(s4)
    80005252:	fd4d                	bnez	a0,8000520c <printf+0x3c>
    80005254:	a481                	j	80005494 <printf+0x2c4>
      consputc(cx);
    80005256:	cf9ff0ef          	jal	80004f4e <consputc>
      continue;
    8000525a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000525c:	0014899b          	addiw	s3,s1,1
    80005260:	013a07b3          	add	a5,s4,s3
    80005264:	0007c503          	lbu	a0,0(a5)
    80005268:	1e050b63          	beqz	a0,8000545e <printf+0x28e>
    if(cx != '%'){
    8000526c:	ff5515e3          	bne	a0,s5,80005256 <printf+0x86>
    i++;
    80005270:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005274:	009a07b3          	add	a5,s4,s1
    80005278:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000527c:	1e090163          	beqz	s2,8000545e <printf+0x28e>
    80005280:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005284:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005286:	c789                	beqz	a5,80005290 <printf+0xc0>
    80005288:	009a0733          	add	a4,s4,s1
    8000528c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005290:	03690763          	beq	s2,s6,800052be <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005294:	05890163          	beq	s2,s8,800052d6 <printf+0x106>
    } else if(c0 == 'u'){
    80005298:	0d990b63          	beq	s2,s9,8000536e <printf+0x19e>
    } else if(c0 == 'x'){
    8000529c:	13a90163          	beq	s2,s10,800053be <printf+0x1ee>
    } else if(c0 == 'p'){
    800052a0:	13b90b63          	beq	s2,s11,800053d6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800052a4:	07300793          	li	a5,115
    800052a8:	16f90a63          	beq	s2,a5,8000541c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800052ac:	1b590463          	beq	s2,s5,80005454 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800052b0:	8556                	mv	a0,s5
    800052b2:	c9dff0ef          	jal	80004f4e <consputc>
      consputc(c0);
    800052b6:	854a                	mv	a0,s2
    800052b8:	c97ff0ef          	jal	80004f4e <consputc>
    800052bc:	b745                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800052be:	f8843783          	ld	a5,-120(s0)
    800052c2:	00878713          	addi	a4,a5,8
    800052c6:	f8e43423          	sd	a4,-120(s0)
    800052ca:	4605                	li	a2,1
    800052cc:	45a9                	li	a1,10
    800052ce:	4388                	lw	a0,0(a5)
    800052d0:	e6fff0ef          	jal	8000513e <printint>
    800052d4:	b761                	j	8000525c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800052d6:	03678663          	beq	a5,s6,80005302 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800052da:	05878263          	beq	a5,s8,8000531e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800052de:	0b978463          	beq	a5,s9,80005386 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800052e2:	fda797e3          	bne	a5,s10,800052b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800052e6:	f8843783          	ld	a5,-120(s0)
    800052ea:	00878713          	addi	a4,a5,8
    800052ee:	f8e43423          	sd	a4,-120(s0)
    800052f2:	4601                	li	a2,0
    800052f4:	45c1                	li	a1,16
    800052f6:	6388                	ld	a0,0(a5)
    800052f8:	e47ff0ef          	jal	8000513e <printint>
      i += 1;
    800052fc:	0029849b          	addiw	s1,s3,2
    80005300:	bfb1                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005302:	f8843783          	ld	a5,-120(s0)
    80005306:	00878713          	addi	a4,a5,8
    8000530a:	f8e43423          	sd	a4,-120(s0)
    8000530e:	4605                	li	a2,1
    80005310:	45a9                	li	a1,10
    80005312:	6388                	ld	a0,0(a5)
    80005314:	e2bff0ef          	jal	8000513e <printint>
      i += 1;
    80005318:	0029849b          	addiw	s1,s3,2
    8000531c:	b781                	j	8000525c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000531e:	06400793          	li	a5,100
    80005322:	02f68863          	beq	a3,a5,80005352 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005326:	07500793          	li	a5,117
    8000532a:	06f68c63          	beq	a3,a5,800053a2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000532e:	07800793          	li	a5,120
    80005332:	f6f69fe3          	bne	a3,a5,800052b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005336:	f8843783          	ld	a5,-120(s0)
    8000533a:	00878713          	addi	a4,a5,8
    8000533e:	f8e43423          	sd	a4,-120(s0)
    80005342:	4601                	li	a2,0
    80005344:	45c1                	li	a1,16
    80005346:	6388                	ld	a0,0(a5)
    80005348:	df7ff0ef          	jal	8000513e <printint>
      i += 2;
    8000534c:	0039849b          	addiw	s1,s3,3
    80005350:	b731                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005352:	f8843783          	ld	a5,-120(s0)
    80005356:	00878713          	addi	a4,a5,8
    8000535a:	f8e43423          	sd	a4,-120(s0)
    8000535e:	4605                	li	a2,1
    80005360:	45a9                	li	a1,10
    80005362:	6388                	ld	a0,0(a5)
    80005364:	ddbff0ef          	jal	8000513e <printint>
      i += 2;
    80005368:	0039849b          	addiw	s1,s3,3
    8000536c:	bdc5                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000536e:	f8843783          	ld	a5,-120(s0)
    80005372:	00878713          	addi	a4,a5,8
    80005376:	f8e43423          	sd	a4,-120(s0)
    8000537a:	4601                	li	a2,0
    8000537c:	45a9                	li	a1,10
    8000537e:	4388                	lw	a0,0(a5)
    80005380:	dbfff0ef          	jal	8000513e <printint>
    80005384:	bde1                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005386:	f8843783          	ld	a5,-120(s0)
    8000538a:	00878713          	addi	a4,a5,8
    8000538e:	f8e43423          	sd	a4,-120(s0)
    80005392:	4601                	li	a2,0
    80005394:	45a9                	li	a1,10
    80005396:	6388                	ld	a0,0(a5)
    80005398:	da7ff0ef          	jal	8000513e <printint>
      i += 1;
    8000539c:	0029849b          	addiw	s1,s3,2
    800053a0:	bd75                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053a2:	f8843783          	ld	a5,-120(s0)
    800053a6:	00878713          	addi	a4,a5,8
    800053aa:	f8e43423          	sd	a4,-120(s0)
    800053ae:	4601                	li	a2,0
    800053b0:	45a9                	li	a1,10
    800053b2:	6388                	ld	a0,0(a5)
    800053b4:	d8bff0ef          	jal	8000513e <printint>
      i += 2;
    800053b8:	0039849b          	addiw	s1,s3,3
    800053bc:	b545                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800053be:	f8843783          	ld	a5,-120(s0)
    800053c2:	00878713          	addi	a4,a5,8
    800053c6:	f8e43423          	sd	a4,-120(s0)
    800053ca:	4601                	li	a2,0
    800053cc:	45c1                	li	a1,16
    800053ce:	4388                	lw	a0,0(a5)
    800053d0:	d6fff0ef          	jal	8000513e <printint>
    800053d4:	b561                	j	8000525c <printf+0x8c>
    800053d6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800053d8:	f8843783          	ld	a5,-120(s0)
    800053dc:	00878713          	addi	a4,a5,8
    800053e0:	f8e43423          	sd	a4,-120(s0)
    800053e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800053e8:	03000513          	li	a0,48
    800053ec:	b63ff0ef          	jal	80004f4e <consputc>
  consputc('x');
    800053f0:	07800513          	li	a0,120
    800053f4:	b5bff0ef          	jal	80004f4e <consputc>
    800053f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800053fa:	00002b97          	auipc	s7,0x2
    800053fe:	606b8b93          	addi	s7,s7,1542 # 80007a00 <digits>
    80005402:	03c9d793          	srli	a5,s3,0x3c
    80005406:	97de                	add	a5,a5,s7
    80005408:	0007c503          	lbu	a0,0(a5)
    8000540c:	b43ff0ef          	jal	80004f4e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005410:	0992                	slli	s3,s3,0x4
    80005412:	397d                	addiw	s2,s2,-1
    80005414:	fe0917e3          	bnez	s2,80005402 <printf+0x232>
    80005418:	6ba6                	ld	s7,72(sp)
    8000541a:	b589                	j	8000525c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000541c:	f8843783          	ld	a5,-120(s0)
    80005420:	00878713          	addi	a4,a5,8
    80005424:	f8e43423          	sd	a4,-120(s0)
    80005428:	0007b903          	ld	s2,0(a5)
    8000542c:	00090d63          	beqz	s2,80005446 <printf+0x276>
      for(; *s; s++)
    80005430:	00094503          	lbu	a0,0(s2)
    80005434:	e20504e3          	beqz	a0,8000525c <printf+0x8c>
        consputc(*s);
    80005438:	b17ff0ef          	jal	80004f4e <consputc>
      for(; *s; s++)
    8000543c:	0905                	addi	s2,s2,1
    8000543e:	00094503          	lbu	a0,0(s2)
    80005442:	f97d                	bnez	a0,80005438 <printf+0x268>
    80005444:	bd21                	j	8000525c <printf+0x8c>
        s = "(null)";
    80005446:	00002917          	auipc	s2,0x2
    8000544a:	3a290913          	addi	s2,s2,930 # 800077e8 <etext+0x7e8>
      for(; *s; s++)
    8000544e:	02800513          	li	a0,40
    80005452:	b7dd                	j	80005438 <printf+0x268>
      consputc('%');
    80005454:	02500513          	li	a0,37
    80005458:	af7ff0ef          	jal	80004f4e <consputc>
    8000545c:	b501                	j	8000525c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000545e:	f7843783          	ld	a5,-136(s0)
    80005462:	e385                	bnez	a5,80005482 <printf+0x2b2>
    80005464:	74e6                	ld	s1,120(sp)
    80005466:	7946                	ld	s2,112(sp)
    80005468:	79a6                	ld	s3,104(sp)
    8000546a:	6ae6                	ld	s5,88(sp)
    8000546c:	6b46                	ld	s6,80(sp)
    8000546e:	6c06                	ld	s8,64(sp)
    80005470:	7ce2                	ld	s9,56(sp)
    80005472:	7d42                	ld	s10,48(sp)
    80005474:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005476:	4501                	li	a0,0
    80005478:	60aa                	ld	ra,136(sp)
    8000547a:	640a                	ld	s0,128(sp)
    8000547c:	7a06                	ld	s4,96(sp)
    8000547e:	6169                	addi	sp,sp,208
    80005480:	8082                	ret
    80005482:	74e6                	ld	s1,120(sp)
    80005484:	7946                	ld	s2,112(sp)
    80005486:	79a6                	ld	s3,104(sp)
    80005488:	6ae6                	ld	s5,88(sp)
    8000548a:	6b46                	ld	s6,80(sp)
    8000548c:	6c06                	ld	s8,64(sp)
    8000548e:	7ce2                	ld	s9,56(sp)
    80005490:	7d42                	ld	s10,48(sp)
    80005492:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005494:	0001e517          	auipc	a0,0x1e
    80005498:	43450513          	addi	a0,a0,1076 # 800238c8 <pr>
    8000549c:	3cc000ef          	jal	80005868 <release>
    800054a0:	bfd9                	j	80005476 <printf+0x2a6>

00000000800054a2 <panic>:

void
panic(char *s)
{
    800054a2:	1101                	addi	sp,sp,-32
    800054a4:	ec06                	sd	ra,24(sp)
    800054a6:	e822                	sd	s0,16(sp)
    800054a8:	e426                	sd	s1,8(sp)
    800054aa:	1000                	addi	s0,sp,32
    800054ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800054ae:	0001e797          	auipc	a5,0x1e
    800054b2:	4207a923          	sw	zero,1074(a5) # 800238e0 <pr+0x18>
  printf("panic: ");
    800054b6:	00002517          	auipc	a0,0x2
    800054ba:	33a50513          	addi	a0,a0,826 # 800077f0 <etext+0x7f0>
    800054be:	d13ff0ef          	jal	800051d0 <printf>
  printf("%s\n", s);
    800054c2:	85a6                	mv	a1,s1
    800054c4:	00002517          	auipc	a0,0x2
    800054c8:	fdc50513          	addi	a0,a0,-36 # 800074a0 <etext+0x4a0>
    800054cc:	d05ff0ef          	jal	800051d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800054d0:	4785                	li	a5,1
    800054d2:	00005717          	auipc	a4,0x5
    800054d6:	f0f72523          	sw	a5,-246(a4) # 8000a3dc <panicked>
  for(;;)
    800054da:	a001                	j	800054da <panic+0x38>

00000000800054dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800054dc:	1101                	addi	sp,sp,-32
    800054de:	ec06                	sd	ra,24(sp)
    800054e0:	e822                	sd	s0,16(sp)
    800054e2:	e426                	sd	s1,8(sp)
    800054e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800054e6:	0001e497          	auipc	s1,0x1e
    800054ea:	3e248493          	addi	s1,s1,994 # 800238c8 <pr>
    800054ee:	00002597          	auipc	a1,0x2
    800054f2:	30a58593          	addi	a1,a1,778 # 800077f8 <etext+0x7f8>
    800054f6:	8526                	mv	a0,s1
    800054f8:	258000ef          	jal	80005750 <initlock>
  pr.locking = 1;
    800054fc:	4785                	li	a5,1
    800054fe:	cc9c                	sw	a5,24(s1)
}
    80005500:	60e2                	ld	ra,24(sp)
    80005502:	6442                	ld	s0,16(sp)
    80005504:	64a2                	ld	s1,8(sp)
    80005506:	6105                	addi	sp,sp,32
    80005508:	8082                	ret

000000008000550a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000550a:	1141                	addi	sp,sp,-16
    8000550c:	e406                	sd	ra,8(sp)
    8000550e:	e022                	sd	s0,0(sp)
    80005510:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005512:	100007b7          	lui	a5,0x10000
    80005516:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000551a:	10000737          	lui	a4,0x10000
    8000551e:	f8000693          	li	a3,-128
    80005522:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005526:	468d                	li	a3,3
    80005528:	10000637          	lui	a2,0x10000
    8000552c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005530:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005534:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005538:	10000737          	lui	a4,0x10000
    8000553c:	461d                	li	a2,7
    8000553e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005542:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005546:	00002597          	auipc	a1,0x2
    8000554a:	2ba58593          	addi	a1,a1,698 # 80007800 <etext+0x800>
    8000554e:	0001e517          	auipc	a0,0x1e
    80005552:	39a50513          	addi	a0,a0,922 # 800238e8 <uart_tx_lock>
    80005556:	1fa000ef          	jal	80005750 <initlock>
}
    8000555a:	60a2                	ld	ra,8(sp)
    8000555c:	6402                	ld	s0,0(sp)
    8000555e:	0141                	addi	sp,sp,16
    80005560:	8082                	ret

0000000080005562 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005562:	1101                	addi	sp,sp,-32
    80005564:	ec06                	sd	ra,24(sp)
    80005566:	e822                	sd	s0,16(sp)
    80005568:	e426                	sd	s1,8(sp)
    8000556a:	1000                	addi	s0,sp,32
    8000556c:	84aa                	mv	s1,a0
  push_off();
    8000556e:	222000ef          	jal	80005790 <push_off>

  if(panicked){
    80005572:	00005797          	auipc	a5,0x5
    80005576:	e6a7a783          	lw	a5,-406(a5) # 8000a3dc <panicked>
    8000557a:	e795                	bnez	a5,800055a6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000557c:	10000737          	lui	a4,0x10000
    80005580:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005582:	00074783          	lbu	a5,0(a4)
    80005586:	0207f793          	andi	a5,a5,32
    8000558a:	dfe5                	beqz	a5,80005582 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000558c:	0ff4f513          	zext.b	a0,s1
    80005590:	100007b7          	lui	a5,0x10000
    80005594:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005598:	27c000ef          	jal	80005814 <pop_off>
}
    8000559c:	60e2                	ld	ra,24(sp)
    8000559e:	6442                	ld	s0,16(sp)
    800055a0:	64a2                	ld	s1,8(sp)
    800055a2:	6105                	addi	sp,sp,32
    800055a4:	8082                	ret
    for(;;)
    800055a6:	a001                	j	800055a6 <uartputc_sync+0x44>

00000000800055a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800055a8:	00005797          	auipc	a5,0x5
    800055ac:	e387b783          	ld	a5,-456(a5) # 8000a3e0 <uart_tx_r>
    800055b0:	00005717          	auipc	a4,0x5
    800055b4:	e3873703          	ld	a4,-456(a4) # 8000a3e8 <uart_tx_w>
    800055b8:	08f70263          	beq	a4,a5,8000563c <uartstart+0x94>
{
    800055bc:	7139                	addi	sp,sp,-64
    800055be:	fc06                	sd	ra,56(sp)
    800055c0:	f822                	sd	s0,48(sp)
    800055c2:	f426                	sd	s1,40(sp)
    800055c4:	f04a                	sd	s2,32(sp)
    800055c6:	ec4e                	sd	s3,24(sp)
    800055c8:	e852                	sd	s4,16(sp)
    800055ca:	e456                	sd	s5,8(sp)
    800055cc:	e05a                	sd	s6,0(sp)
    800055ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055d0:	10000937          	lui	s2,0x10000
    800055d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055d6:	0001ea97          	auipc	s5,0x1e
    800055da:	312a8a93          	addi	s5,s5,786 # 800238e8 <uart_tx_lock>
    uart_tx_r += 1;
    800055de:	00005497          	auipc	s1,0x5
    800055e2:	e0248493          	addi	s1,s1,-510 # 8000a3e0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800055e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800055ea:	00005997          	auipc	s3,0x5
    800055ee:	dfe98993          	addi	s3,s3,-514 # 8000a3e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055f2:	00094703          	lbu	a4,0(s2)
    800055f6:	02077713          	andi	a4,a4,32
    800055fa:	c71d                	beqz	a4,80005628 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055fc:	01f7f713          	andi	a4,a5,31
    80005600:	9756                	add	a4,a4,s5
    80005602:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005606:	0785                	addi	a5,a5,1
    80005608:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000560a:	8526                	mv	a0,s1
    8000560c:	d71fb0ef          	jal	8000137c <wakeup>
    WriteReg(THR, c);
    80005610:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005614:	609c                	ld	a5,0(s1)
    80005616:	0009b703          	ld	a4,0(s3)
    8000561a:	fcf71ce3          	bne	a4,a5,800055f2 <uartstart+0x4a>
      ReadReg(ISR);
    8000561e:	100007b7          	lui	a5,0x10000
    80005622:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005624:	0007c783          	lbu	a5,0(a5)
  }
}
    80005628:	70e2                	ld	ra,56(sp)
    8000562a:	7442                	ld	s0,48(sp)
    8000562c:	74a2                	ld	s1,40(sp)
    8000562e:	7902                	ld	s2,32(sp)
    80005630:	69e2                	ld	s3,24(sp)
    80005632:	6a42                	ld	s4,16(sp)
    80005634:	6aa2                	ld	s5,8(sp)
    80005636:	6b02                	ld	s6,0(sp)
    80005638:	6121                	addi	sp,sp,64
    8000563a:	8082                	ret
      ReadReg(ISR);
    8000563c:	100007b7          	lui	a5,0x10000
    80005640:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005642:	0007c783          	lbu	a5,0(a5)
      return;
    80005646:	8082                	ret

0000000080005648 <uartputc>:
{
    80005648:	7179                	addi	sp,sp,-48
    8000564a:	f406                	sd	ra,40(sp)
    8000564c:	f022                	sd	s0,32(sp)
    8000564e:	ec26                	sd	s1,24(sp)
    80005650:	e84a                	sd	s2,16(sp)
    80005652:	e44e                	sd	s3,8(sp)
    80005654:	e052                	sd	s4,0(sp)
    80005656:	1800                	addi	s0,sp,48
    80005658:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000565a:	0001e517          	auipc	a0,0x1e
    8000565e:	28e50513          	addi	a0,a0,654 # 800238e8 <uart_tx_lock>
    80005662:	16e000ef          	jal	800057d0 <acquire>
  if(panicked){
    80005666:	00005797          	auipc	a5,0x5
    8000566a:	d767a783          	lw	a5,-650(a5) # 8000a3dc <panicked>
    8000566e:	efbd                	bnez	a5,800056ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005670:	00005717          	auipc	a4,0x5
    80005674:	d7873703          	ld	a4,-648(a4) # 8000a3e8 <uart_tx_w>
    80005678:	00005797          	auipc	a5,0x5
    8000567c:	d687b783          	ld	a5,-664(a5) # 8000a3e0 <uart_tx_r>
    80005680:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005684:	0001e997          	auipc	s3,0x1e
    80005688:	26498993          	addi	s3,s3,612 # 800238e8 <uart_tx_lock>
    8000568c:	00005497          	auipc	s1,0x5
    80005690:	d5448493          	addi	s1,s1,-684 # 8000a3e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005694:	00005917          	auipc	s2,0x5
    80005698:	d5490913          	addi	s2,s2,-684 # 8000a3e8 <uart_tx_w>
    8000569c:	00e79d63          	bne	a5,a4,800056b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800056a0:	85ce                	mv	a1,s3
    800056a2:	8526                	mv	a0,s1
    800056a4:	c8dfb0ef          	jal	80001330 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056a8:	00093703          	ld	a4,0(s2)
    800056ac:	609c                	ld	a5,0(s1)
    800056ae:	02078793          	addi	a5,a5,32
    800056b2:	fee787e3          	beq	a5,a4,800056a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800056b6:	0001e497          	auipc	s1,0x1e
    800056ba:	23248493          	addi	s1,s1,562 # 800238e8 <uart_tx_lock>
    800056be:	01f77793          	andi	a5,a4,31
    800056c2:	97a6                	add	a5,a5,s1
    800056c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800056c8:	0705                	addi	a4,a4,1
    800056ca:	00005797          	auipc	a5,0x5
    800056ce:	d0e7bf23          	sd	a4,-738(a5) # 8000a3e8 <uart_tx_w>
  uartstart();
    800056d2:	ed7ff0ef          	jal	800055a8 <uartstart>
  release(&uart_tx_lock);
    800056d6:	8526                	mv	a0,s1
    800056d8:	190000ef          	jal	80005868 <release>
}
    800056dc:	70a2                	ld	ra,40(sp)
    800056de:	7402                	ld	s0,32(sp)
    800056e0:	64e2                	ld	s1,24(sp)
    800056e2:	6942                	ld	s2,16(sp)
    800056e4:	69a2                	ld	s3,8(sp)
    800056e6:	6a02                	ld	s4,0(sp)
    800056e8:	6145                	addi	sp,sp,48
    800056ea:	8082                	ret
    for(;;)
    800056ec:	a001                	j	800056ec <uartputc+0xa4>

00000000800056ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800056ee:	1141                	addi	sp,sp,-16
    800056f0:	e422                	sd	s0,8(sp)
    800056f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800056f4:	100007b7          	lui	a5,0x10000
    800056f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800056fa:	0007c783          	lbu	a5,0(a5)
    800056fe:	8b85                	andi	a5,a5,1
    80005700:	cb81                	beqz	a5,80005710 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005702:	100007b7          	lui	a5,0x10000
    80005706:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000570a:	6422                	ld	s0,8(sp)
    8000570c:	0141                	addi	sp,sp,16
    8000570e:	8082                	ret
    return -1;
    80005710:	557d                	li	a0,-1
    80005712:	bfe5                	j	8000570a <uartgetc+0x1c>

0000000080005714 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005714:	1101                	addi	sp,sp,-32
    80005716:	ec06                	sd	ra,24(sp)
    80005718:	e822                	sd	s0,16(sp)
    8000571a:	e426                	sd	s1,8(sp)
    8000571c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000571e:	54fd                	li	s1,-1
    80005720:	a019                	j	80005726 <uartintr+0x12>
      break;
    consoleintr(c);
    80005722:	85fff0ef          	jal	80004f80 <consoleintr>
    int c = uartgetc();
    80005726:	fc9ff0ef          	jal	800056ee <uartgetc>
    if(c == -1)
    8000572a:	fe951ce3          	bne	a0,s1,80005722 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000572e:	0001e497          	auipc	s1,0x1e
    80005732:	1ba48493          	addi	s1,s1,442 # 800238e8 <uart_tx_lock>
    80005736:	8526                	mv	a0,s1
    80005738:	098000ef          	jal	800057d0 <acquire>
  uartstart();
    8000573c:	e6dff0ef          	jal	800055a8 <uartstart>
  release(&uart_tx_lock);
    80005740:	8526                	mv	a0,s1
    80005742:	126000ef          	jal	80005868 <release>
}
    80005746:	60e2                	ld	ra,24(sp)
    80005748:	6442                	ld	s0,16(sp)
    8000574a:	64a2                	ld	s1,8(sp)
    8000574c:	6105                	addi	sp,sp,32
    8000574e:	8082                	ret

0000000080005750 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005750:	1141                	addi	sp,sp,-16
    80005752:	e422                	sd	s0,8(sp)
    80005754:	0800                	addi	s0,sp,16
  lk->name = name;
    80005756:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005758:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000575c:	00053823          	sd	zero,16(a0)
}
    80005760:	6422                	ld	s0,8(sp)
    80005762:	0141                	addi	sp,sp,16
    80005764:	8082                	ret

0000000080005766 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005766:	411c                	lw	a5,0(a0)
    80005768:	e399                	bnez	a5,8000576e <holding+0x8>
    8000576a:	4501                	li	a0,0
  return r;
}
    8000576c:	8082                	ret
{
    8000576e:	1101                	addi	sp,sp,-32
    80005770:	ec06                	sd	ra,24(sp)
    80005772:	e822                	sd	s0,16(sp)
    80005774:	e426                	sd	s1,8(sp)
    80005776:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005778:	6904                	ld	s1,16(a0)
    8000577a:	dc0fb0ef          	jal	80000d3a <mycpu>
    8000577e:	40a48533          	sub	a0,s1,a0
    80005782:	00153513          	seqz	a0,a0
}
    80005786:	60e2                	ld	ra,24(sp)
    80005788:	6442                	ld	s0,16(sp)
    8000578a:	64a2                	ld	s1,8(sp)
    8000578c:	6105                	addi	sp,sp,32
    8000578e:	8082                	ret

0000000080005790 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005790:	1101                	addi	sp,sp,-32
    80005792:	ec06                	sd	ra,24(sp)
    80005794:	e822                	sd	s0,16(sp)
    80005796:	e426                	sd	s1,8(sp)
    80005798:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000579a:	100024f3          	csrr	s1,sstatus
    8000579e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800057a2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800057a4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800057a8:	d92fb0ef          	jal	80000d3a <mycpu>
    800057ac:	5d3c                	lw	a5,120(a0)
    800057ae:	cb99                	beqz	a5,800057c4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800057b0:	d8afb0ef          	jal	80000d3a <mycpu>
    800057b4:	5d3c                	lw	a5,120(a0)
    800057b6:	2785                	addiw	a5,a5,1
    800057b8:	dd3c                	sw	a5,120(a0)
}
    800057ba:	60e2                	ld	ra,24(sp)
    800057bc:	6442                	ld	s0,16(sp)
    800057be:	64a2                	ld	s1,8(sp)
    800057c0:	6105                	addi	sp,sp,32
    800057c2:	8082                	ret
    mycpu()->intena = old;
    800057c4:	d76fb0ef          	jal	80000d3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800057c8:	8085                	srli	s1,s1,0x1
    800057ca:	8885                	andi	s1,s1,1
    800057cc:	dd64                	sw	s1,124(a0)
    800057ce:	b7cd                	j	800057b0 <push_off+0x20>

00000000800057d0 <acquire>:
{
    800057d0:	1101                	addi	sp,sp,-32
    800057d2:	ec06                	sd	ra,24(sp)
    800057d4:	e822                	sd	s0,16(sp)
    800057d6:	e426                	sd	s1,8(sp)
    800057d8:	1000                	addi	s0,sp,32
    800057da:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800057dc:	fb5ff0ef          	jal	80005790 <push_off>
  if(holding(lk))
    800057e0:	8526                	mv	a0,s1
    800057e2:	f85ff0ef          	jal	80005766 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057e6:	4705                	li	a4,1
  if(holding(lk))
    800057e8:	e105                	bnez	a0,80005808 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057ea:	87ba                	mv	a5,a4
    800057ec:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800057f0:	2781                	sext.w	a5,a5
    800057f2:	ffe5                	bnez	a5,800057ea <acquire+0x1a>
  __sync_synchronize();
    800057f4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800057f8:	d42fb0ef          	jal	80000d3a <mycpu>
    800057fc:	e888                	sd	a0,16(s1)
}
    800057fe:	60e2                	ld	ra,24(sp)
    80005800:	6442                	ld	s0,16(sp)
    80005802:	64a2                	ld	s1,8(sp)
    80005804:	6105                	addi	sp,sp,32
    80005806:	8082                	ret
    panic("acquire");
    80005808:	00002517          	auipc	a0,0x2
    8000580c:	00050513          	mv	a0,a0
    80005810:	c93ff0ef          	jal	800054a2 <panic>

0000000080005814 <pop_off>:

void
pop_off(void)
{
    80005814:	1141                	addi	sp,sp,-16
    80005816:	e406                	sd	ra,8(sp)
    80005818:	e022                	sd	s0,0(sp)
    8000581a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000581c:	d1efb0ef          	jal	80000d3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005820:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005824:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005826:	e78d                	bnez	a5,80005850 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005828:	5d3c                	lw	a5,120(a0)
    8000582a:	02f05963          	blez	a5,8000585c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000582e:	37fd                	addiw	a5,a5,-1
    80005830:	0007871b          	sext.w	a4,a5
    80005834:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005836:	eb09                	bnez	a4,80005848 <pop_off+0x34>
    80005838:	5d7c                	lw	a5,124(a0)
    8000583a:	c799                	beqz	a5,80005848 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000583c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005840:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005844:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005848:	60a2                	ld	ra,8(sp)
    8000584a:	6402                	ld	s0,0(sp)
    8000584c:	0141                	addi	sp,sp,16
    8000584e:	8082                	ret
    panic("pop_off - interruptible");
    80005850:	00002517          	auipc	a0,0x2
    80005854:	fc050513          	addi	a0,a0,-64 # 80007810 <etext+0x810>
    80005858:	c4bff0ef          	jal	800054a2 <panic>
    panic("pop_off");
    8000585c:	00002517          	auipc	a0,0x2
    80005860:	fcc50513          	addi	a0,a0,-52 # 80007828 <etext+0x828>
    80005864:	c3fff0ef          	jal	800054a2 <panic>

0000000080005868 <release>:
{
    80005868:	1101                	addi	sp,sp,-32
    8000586a:	ec06                	sd	ra,24(sp)
    8000586c:	e822                	sd	s0,16(sp)
    8000586e:	e426                	sd	s1,8(sp)
    80005870:	1000                	addi	s0,sp,32
    80005872:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005874:	ef3ff0ef          	jal	80005766 <holding>
    80005878:	c105                	beqz	a0,80005898 <release+0x30>
  lk->cpu = 0;
    8000587a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000587e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005882:	0310000f          	fence	rw,w
    80005886:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000588a:	f8bff0ef          	jal	80005814 <pop_off>
}
    8000588e:	60e2                	ld	ra,24(sp)
    80005890:	6442                	ld	s0,16(sp)
    80005892:	64a2                	ld	s1,8(sp)
    80005894:	6105                	addi	sp,sp,32
    80005896:	8082                	ret
    panic("release");
    80005898:	00002517          	auipc	a0,0x2
    8000589c:	f9850513          	addi	a0,a0,-104 # 80007830 <etext+0x830>
    800058a0:	c03ff0ef          	jal	800054a2 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
