
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
    80000016:	539040ef          	jal	80004d4e <start>

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
    8000004e:	762050ef          	jal	800057b0 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	7ea050ef          	jal	80005848 <release>
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
    80000076:	40c050ef          	jal	80005482 <panic>

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
    800000da:	656050ef          	jal	80005730 <initlock>
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
    8000010a:	6a6050ef          	jal	800057b0 <acquire>
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
    80000124:	724050ef          	jal	80005848 <release>
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
    800002fc:	6b5040ef          	jal	800051b0 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	54e010ef          	jal	80001852 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	460040ef          	jal	80004768 <plicinithart>
  }

  scheduler();        
    8000030c:	68b000ef          	jal	80001196 <scheduler>
    consoleinit();
    80000310:	5cb040ef          	jal	800050da <consoleinit>
    printfinit();
    80000314:	1a8050ef          	jal	800054bc <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	691040ef          	jal	800051b0 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	685040ef          	jal	800051b0 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	679040ef          	jal	800051b0 <printf>
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
    80000354:	3fa040ef          	jal	8000474e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	410040ef          	jal	80004768 <plicinithart>
    binit();         // buffer cache
    8000035c:	3b9010ef          	jal	80001f14 <binit>
    iinit();         // inode table
    80000360:	1aa020ef          	jal	8000250a <iinit>
    fileinit();      // file table
    80000364:	757020ef          	jal	800032ba <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	4f0040ef          	jal	80004858 <virtio_disk_init>
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
    800003d6:	0ac050ef          	jal	80005482 <panic>
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
    800004ec:	797040ef          	jal	80005482 <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	78b040ef          	jal	80005482 <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	77f040ef          	jal	80005482 <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	773040ef          	jal	80005482 <panic>
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
    80000554:	72f040ef          	jal	80005482 <panic>

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
    8000066e:	615040ef          	jal	80005482 <panic>
      panic("uvmunmap: walk");
    80000672:	00007517          	auipc	a0,0x7
    80000676:	a6650513          	addi	a0,a0,-1434 # 800070d8 <etext+0xd8>
    8000067a:	609040ef          	jal	80005482 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000067e:	85ca                	mv	a1,s2
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a6850513          	addi	a0,a0,-1432 # 800070e8 <etext+0xe8>
    80000688:	329040ef          	jal	800051b0 <printf>
      panic("uvmunmap: not mapped");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a6c50513          	addi	a0,a0,-1428 # 800070f8 <etext+0xf8>
    80000694:	5ef040ef          	jal	80005482 <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a7850513          	addi	a0,a0,-1416 # 80007110 <etext+0x110>
    800006a0:	5e3040ef          	jal	80005482 <panic>
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
    80000772:	511040ef          	jal	80005482 <panic>

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
    8000089e:	3e5040ef          	jal	80005482 <panic>
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
    8000095c:	327040ef          	jal	80005482 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	81850513          	addi	a0,a0,-2024 # 80007178 <etext+0x178>
    80000968:	31b040ef          	jal	80005482 <panic>
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
    800009c2:	2c1040ef          	jal	80005482 <panic>

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
    80000c70:	013040ef          	jal	80005482 <panic>

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
    80000c98:	299040ef          	jal	80005730 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	00009517          	auipc	a0,0x9
    80000ca8:	78450513          	addi	a0,a0,1924 # 8000a428 <wait_lock>
    80000cac:	285040ef          	jal	80005730 <initlock>
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
    80000cf0:	241040ef          	jal	80005730 <initlock>
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
    80000d60:	211040ef          	jal	80005770 <push_off>
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
    80000d76:	27f040ef          	jal	800057f4 <pop_off>
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
    80000d92:	2b7040ef          	jal	80005848 <release>

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
    80000dae:	6f0010ef          	jal	8000249e <fsinit>
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
    80000dd6:	1db040ef          	jal	800057b0 <acquire>
  pid = nextpid;
    80000dda:	00009797          	auipc	a5,0x9
    80000dde:	57a78793          	addi	a5,a5,1402 # 8000a354 <nextpid>
    80000de2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de4:	0014871b          	addiw	a4,s1,1
    80000de8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dea:	854a                	mv	a0,s2
    80000dec:	25d040ef          	jal	80005848 <release>
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
    80000f36:	07b040ef          	jal	800057b0 <acquire>
    if(p->state == UNUSED) {
    80000f3a:	4c9c                	lw	a5,24(s1)
    80000f3c:	cb91                	beqz	a5,80000f50 <allocproc+0x38>
      release(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	109040ef          	jal	80005848 <release>
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
    80000faa:	09f040ef          	jal	80005848 <release>
    return 0;
    80000fae:	84ca                	mv	s1,s2
    80000fb0:	b7d5                	j	80000f94 <allocproc+0x7c>
    freeproc(p);
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	f15ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fb8:	8526                	mv	a0,s1
    80000fba:	08f040ef          	jal	80005848 <release>
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
    80001014:	599010ef          	jal	80002dac <namei>
    80001018:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101c:	478d                	li	a5,3
    8000101e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001020:	8526                	mv	a0,s1
    80001022:	027040ef          	jal	80005848 <release>
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
    80001108:	740040ef          	jal	80005848 <release>
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
    8000111e:	21e020ef          	jal	8000333c <filedup>
    80001122:	00a93023          	sd	a0,0(s2)
    80001126:	b7f5                	j	80001112 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001128:	150ab503          	ld	a0,336(s5)
    8000112c:	570010ef          	jal	8000269c <idup>
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
    80001150:	6f8040ef          	jal	80005848 <release>
  acquire(&wait_lock);
    80001154:	00009497          	auipc	s1,0x9
    80001158:	2d448493          	addi	s1,s1,724 # 8000a428 <wait_lock>
    8000115c:	8526                	mv	a0,s1
    8000115e:	652040ef          	jal	800057b0 <acquire>
  np->parent = p;
    80001162:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001166:	8526                	mv	a0,s1
    80001168:	6e0040ef          	jal	80005848 <release>
  acquire(&np->lock);
    8000116c:	854e                	mv	a0,s3
    8000116e:	642040ef          	jal	800057b0 <acquire>
  np->state = RUNNABLE;
    80001172:	478d                	li	a5,3
    80001174:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001178:	854e                	mv	a0,s3
    8000117a:	6ce040ef          	jal	80005848 <release>
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
    800011ea:	65e040ef          	jal	80005848 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ee:	17048493          	addi	s1,s1,368
    800011f2:	03348563          	beq	s1,s3,8000121c <scheduler+0x86>
      acquire(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	5b8040ef          	jal	800057b0 <acquire>
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
    8000125e:	4e8040ef          	jal	80005746 <holding>
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
    800012dc:	1a6040ef          	jal	80005482 <panic>
    panic("sched locks");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f1850513          	addi	a0,a0,-232 # 800071f8 <etext+0x1f8>
    800012e8:	19a040ef          	jal	80005482 <panic>
    panic("sched running");
    800012ec:	00006517          	auipc	a0,0x6
    800012f0:	f1c50513          	addi	a0,a0,-228 # 80007208 <etext+0x208>
    800012f4:	18e040ef          	jal	80005482 <panic>
    panic("sched interruptible");
    800012f8:	00006517          	auipc	a0,0x6
    800012fc:	f2050513          	addi	a0,a0,-224 # 80007218 <etext+0x218>
    80001300:	182040ef          	jal	80005482 <panic>

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
    80001314:	49c040ef          	jal	800057b0 <acquire>
  p->state = RUNNABLE;
    80001318:	478d                	li	a5,3
    8000131a:	cc9c                	sw	a5,24(s1)
  sched();
    8000131c:	f2fff0ef          	jal	8000124a <sched>
  release(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	526040ef          	jal	80005848 <release>
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
    80001348:	468040ef          	jal	800057b0 <acquire>
  release(lk);
    8000134c:	854a                	mv	a0,s2
    8000134e:	4fa040ef          	jal	80005848 <release>

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
    80001364:	4e4040ef          	jal	80005848 <release>
  acquire(lk);
    80001368:	854a                	mv	a0,s2
    8000136a:	446040ef          	jal	800057b0 <acquire>
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
    800013a8:	4a0040ef          	jal	80005848 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	17048493          	addi	s1,s1,368
    800013b0:	03248263          	beq	s1,s2,800013d4 <wakeup+0x58>
    if(p != myproc()){
    800013b4:	9a3ff0ef          	jal	80000d56 <myproc>
    800013b8:	fea48ae3          	beq	s1,a0,800013ac <wakeup+0x30>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	3f2040ef          	jal	800057b0 <acquire>
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
    80001470:	012040ef          	jal	80005482 <panic>
      fileclose(f);
    80001474:	70f010ef          	jal	80003382 <fileclose>
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
    80001488:	2e1010ef          	jal	80002f68 <begin_op>
  iput(p->cwd);
    8000148c:	1509b503          	ld	a0,336(s3)
    80001490:	3c4010ef          	jal	80002854 <iput>
  end_op();
    80001494:	33f010ef          	jal	80002fd2 <end_op>
  p->cwd = 0;
    80001498:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149c:	00009497          	auipc	s1,0x9
    800014a0:	f8c48493          	addi	s1,s1,-116 # 8000a428 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	30a040ef          	jal	800057b0 <acquire>
  reparent(p);
    800014aa:	854e                	mv	a0,s3
    800014ac:	f3bff0ef          	jal	800013e6 <reparent>
  wakeup(p->parent);
    800014b0:	0389b503          	ld	a0,56(s3)
    800014b4:	ec9ff0ef          	jal	8000137c <wakeup>
  acquire(&p->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	2f6040ef          	jal	800057b0 <acquire>
  p->xstate = status;
    800014be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c2:	4795                	li	a5,5
    800014c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c8:	8526                	mv	a0,s1
    800014ca:	37e040ef          	jal	80005848 <release>
  sched();
    800014ce:	d7dff0ef          	jal	8000124a <sched>
  panic("zombie exit");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	d6e50513          	addi	a0,a0,-658 # 80007240 <etext+0x240>
    800014da:	7a9030ef          	jal	80005482 <panic>

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
    80001500:	2b0040ef          	jal	800057b0 <acquire>
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
    8000150c:	33c040ef          	jal	80005848 <release>
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
    8000152a:	31e040ef          	jal	80005848 <release>
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
    80001550:	260040ef          	jal	800057b0 <acquire>
  p->killed = 1;
    80001554:	4785                	li	a5,1
    80001556:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	2ee040ef          	jal	80005848 <release>
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
    80001576:	23a040ef          	jal	800057b0 <acquire>
  k = p->killed;
    8000157a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	2c8040ef          	jal	80005848 <release>
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
    800015ba:	1f6040ef          	jal	800057b0 <acquire>
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
    800015fa:	24e040ef          	jal	80005848 <release>
          release(&wait_lock);
    800015fe:	00009517          	auipc	a0,0x9
    80001602:	e2a50513          	addi	a0,a0,-470 # 8000a428 <wait_lock>
    80001606:	242040ef          	jal	80005848 <release>
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
    80001626:	222040ef          	jal	80005848 <release>
            release(&wait_lock);
    8000162a:	00009517          	auipc	a0,0x9
    8000162e:	dfe50513          	addi	a0,a0,-514 # 8000a428 <wait_lock>
    80001632:	216040ef          	jal	80005848 <release>
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
    8000164a:	166040ef          	jal	800057b0 <acquire>
        if(pp->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94783e3          	beq	a5,s4,800015d6 <wait+0x44>
        release(&pp->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	1f2040ef          	jal	80005848 <release>
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
    80001684:	1c4040ef          	jal	80005848 <release>
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
    8000173e:	273030ef          	jal	800051b0 <printf>
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
    8000177c:	235030ef          	jal	800051b0 <printf>
    printf("\n");
    80001780:	8552                	mv	a0,s4
    80001782:	22f030ef          	jal	800051b0 <printf>
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
    80001846:	6eb030ef          	jal	80005730 <initlock>
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
    8000185c:	e9878793          	addi	a5,a5,-360 # 800046f0 <kernelvec>
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
    80001930:	681030ef          	jal	800057b0 <acquire>
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
    80001948:	701030ef          	jal	80005848 <release>
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
    8000197c:	621020ef          	jal	8000479c <plic_claim>
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
    80001996:	55f030ef          	jal	800056f4 <uartintr>
    if(irq)
    8000199a:	a819                	j	800019b0 <devintr+0x60>
      virtio_disk_intr();
    8000199c:	2c6030ef          	jal	80004c62 <virtio_disk_intr>
    if(irq)
    800019a0:	a801                	j	800019b0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a2:	85a6                	mv	a1,s1
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	8fc50513          	addi	a0,a0,-1796 # 800072a0 <etext+0x2a0>
    800019ac:	005030ef          	jal	800051b0 <printf>
      plic_complete(irq);
    800019b0:	8526                	mv	a0,s1
    800019b2:	60b020ef          	jal	800047bc <plic_complete>
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
    800019de:	d1678793          	addi	a5,a5,-746 # 800046f0 <kernelvec>
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
    80001a18:	26b030ef          	jal	80005482 <panic>
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
    80001a76:	73a030ef          	jal	800051b0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a7e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	88e50513          	addi	a0,a0,-1906 # 80007310 <etext+0x310>
    80001a8a:	726030ef          	jal	800051b0 <printf>
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
    80001aee:	195030ef          	jal	80005482 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af2:	00006517          	auipc	a0,0x6
    80001af6:	86e50513          	addi	a0,a0,-1938 # 80007360 <etext+0x360>
    80001afa:	189030ef          	jal	80005482 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afe:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b02:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b06:	85ce                	mv	a1,s3
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	87850513          	addi	a0,a0,-1928 # 80007380 <etext+0x380>
    80001b10:	6a0030ef          	jal	800051b0 <printf>
    panic("kerneltrap");
    80001b14:	00006517          	auipc	a0,0x6
    80001b18:	89450513          	addi	a0,a0,-1900 # 800073a8 <etext+0x3a8>
    80001b1c:	167030ef          	jal	80005482 <panic>
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
    80001b88:	0fb030ef          	jal	80005482 <panic>

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
    80001ce6:	4ca030ef          	jal	800051b0 <printf>
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
    80001cfc:	4b4030ef          	jal	800051b0 <printf>
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
    80001dde:	1d3030ef          	jal	800057b0 <acquire>
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
    80001e30:	219030ef          	jal	80005848 <release>
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
    80001e4e:	1fb030ef          	jal	80005848 <release>
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
    80001e8e:	123030ef          	jal	800057b0 <acquire>
  xticks = ticks;
    80001e92:	00008497          	auipc	s1,0x8
    80001e96:	5464a483          	lw	s1,1350(s1) # 8000a3d8 <ticks>
  release(&tickslock);
    80001e9a:	0000e517          	auipc	a0,0xe
    80001e9e:	5a650513          	addi	a0,a0,1446 # 80010440 <tickslock>
    80001ea2:	1a7030ef          	jal	80005848 <release>
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

uint64
sys_explode(void) {
    80001eb6:	1101                	addi	sp,sp,-32
    80001eb8:	ec06                	sd	ra,24(sp)
    80001eba:	e822                	sd	s0,16(sp)
    80001ebc:	1000                	addi	s0,sp,32
  char *s;
  argaddr(0, (uint64*)&s);
    80001ebe:	fe840593          	addi	a1,s0,-24
    80001ec2:	4501                	li	a0,0
    80001ec4:	d6fff0ef          	jal	80001c32 <argaddr>
  printf("%s\n", s);  // usa ponteiro diretamente → inseguro
    80001ec8:	fe843583          	ld	a1,-24(s0)
    80001ecc:	00005517          	auipc	a0,0x5
    80001ed0:	5d450513          	addi	a0,a0,1492 # 800074a0 <etext+0x4a0>
    80001ed4:	2dc030ef          	jal	800051b0 <printf>
  return 0;
}
    80001ed8:	4501                	li	a0,0
    80001eda:	60e2                	ld	ra,24(sp)
    80001edc:	6442                	ld	s0,16(sp)
    80001ede:	6105                	addi	sp,sp,32
    80001ee0:	8082                	ret

0000000080001ee2 <sys_trace>:
}
*/

uint64
sys_trace(void)
{
    80001ee2:	1101                	addi	sp,sp,-32
    80001ee4:	ec06                	sd	ra,24(sp)
    80001ee6:	e822                	sd	s0,16(sp)
    80001ee8:	1000                	addi	s0,sp,32
  int mask;
  
  argint(0, &mask);
    80001eea:	fec40593          	addi	a1,s0,-20
    80001eee:	4501                	li	a0,0
    80001ef0:	d27ff0ef          	jal	80001c16 <argint>
  
  // Validação opcional: verificar se a máscara é válida
  if(mask < 0) {
    80001ef4:	fec42783          	lw	a5,-20(s0)
    return -1;
    80001ef8:	557d                	li	a0,-1
  if(mask < 0) {
    80001efa:	0007c963          	bltz	a5,80001f0c <sys_trace+0x2a>
  }
  
  myproc()->trace_mask = mask;
    80001efe:	e59fe0ef          	jal	80000d56 <myproc>
    80001f02:	fec42783          	lw	a5,-20(s0)
    80001f06:	16f52423          	sw	a5,360(a0)
  return 0;
    80001f0a:	4501                	li	a0,0
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	6105                	addi	sp,sp,32
    80001f12:	8082                	ret

0000000080001f14 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f14:	7179                	addi	sp,sp,-48
    80001f16:	f406                	sd	ra,40(sp)
    80001f18:	f022                	sd	s0,32(sp)
    80001f1a:	ec26                	sd	s1,24(sp)
    80001f1c:	e84a                	sd	s2,16(sp)
    80001f1e:	e44e                	sd	s3,8(sp)
    80001f20:	e052                	sd	s4,0(sp)
    80001f22:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f24:	00005597          	auipc	a1,0x5
    80001f28:	58458593          	addi	a1,a1,1412 # 800074a8 <etext+0x4a8>
    80001f2c:	0000e517          	auipc	a0,0xe
    80001f30:	52c50513          	addi	a0,a0,1324 # 80010458 <bcache>
    80001f34:	7fc030ef          	jal	80005730 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f38:	00016797          	auipc	a5,0x16
    80001f3c:	52078793          	addi	a5,a5,1312 # 80018458 <bcache+0x8000>
    80001f40:	00016717          	auipc	a4,0x16
    80001f44:	78070713          	addi	a4,a4,1920 # 800186c0 <bcache+0x8268>
    80001f48:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f4c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f50:	0000e497          	auipc	s1,0xe
    80001f54:	52048493          	addi	s1,s1,1312 # 80010470 <bcache+0x18>
    b->next = bcache.head.next;
    80001f58:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f5a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f5c:	00005a17          	auipc	s4,0x5
    80001f60:	554a0a13          	addi	s4,s4,1364 # 800074b0 <etext+0x4b0>
    b->next = bcache.head.next;
    80001f64:	2b893783          	ld	a5,696(s2)
    80001f68:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f6a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f6e:	85d2                	mv	a1,s4
    80001f70:	01048513          	addi	a0,s1,16
    80001f74:	248010ef          	jal	800031bc <initsleeplock>
    bcache.head.next->prev = b;
    80001f78:	2b893783          	ld	a5,696(s2)
    80001f7c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001f7e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f82:	45848493          	addi	s1,s1,1112
    80001f86:	fd349fe3          	bne	s1,s3,80001f64 <binit+0x50>
  }
}
    80001f8a:	70a2                	ld	ra,40(sp)
    80001f8c:	7402                	ld	s0,32(sp)
    80001f8e:	64e2                	ld	s1,24(sp)
    80001f90:	6942                	ld	s2,16(sp)
    80001f92:	69a2                	ld	s3,8(sp)
    80001f94:	6a02                	ld	s4,0(sp)
    80001f96:	6145                	addi	sp,sp,48
    80001f98:	8082                	ret

0000000080001f9a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001f9a:	7179                	addi	sp,sp,-48
    80001f9c:	f406                	sd	ra,40(sp)
    80001f9e:	f022                	sd	s0,32(sp)
    80001fa0:	ec26                	sd	s1,24(sp)
    80001fa2:	e84a                	sd	s2,16(sp)
    80001fa4:	e44e                	sd	s3,8(sp)
    80001fa6:	1800                	addi	s0,sp,48
    80001fa8:	892a                	mv	s2,a0
    80001faa:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fac:	0000e517          	auipc	a0,0xe
    80001fb0:	4ac50513          	addi	a0,a0,1196 # 80010458 <bcache>
    80001fb4:	7fc030ef          	jal	800057b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001fb8:	00016497          	auipc	s1,0x16
    80001fbc:	7584b483          	ld	s1,1880(s1) # 80018710 <bcache+0x82b8>
    80001fc0:	00016797          	auipc	a5,0x16
    80001fc4:	70078793          	addi	a5,a5,1792 # 800186c0 <bcache+0x8268>
    80001fc8:	02f48b63          	beq	s1,a5,80001ffe <bread+0x64>
    80001fcc:	873e                	mv	a4,a5
    80001fce:	a021                	j	80001fd6 <bread+0x3c>
    80001fd0:	68a4                	ld	s1,80(s1)
    80001fd2:	02e48663          	beq	s1,a4,80001ffe <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001fd6:	449c                	lw	a5,8(s1)
    80001fd8:	ff279ce3          	bne	a5,s2,80001fd0 <bread+0x36>
    80001fdc:	44dc                	lw	a5,12(s1)
    80001fde:	ff3799e3          	bne	a5,s3,80001fd0 <bread+0x36>
      b->refcnt++;
    80001fe2:	40bc                	lw	a5,64(s1)
    80001fe4:	2785                	addiw	a5,a5,1
    80001fe6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001fe8:	0000e517          	auipc	a0,0xe
    80001fec:	47050513          	addi	a0,a0,1136 # 80010458 <bcache>
    80001ff0:	059030ef          	jal	80005848 <release>
      acquiresleep(&b->lock);
    80001ff4:	01048513          	addi	a0,s1,16
    80001ff8:	1fa010ef          	jal	800031f2 <acquiresleep>
      return b;
    80001ffc:	a889                	j	8000204e <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001ffe:	00016497          	auipc	s1,0x16
    80002002:	70a4b483          	ld	s1,1802(s1) # 80018708 <bcache+0x82b0>
    80002006:	00016797          	auipc	a5,0x16
    8000200a:	6ba78793          	addi	a5,a5,1722 # 800186c0 <bcache+0x8268>
    8000200e:	00f48863          	beq	s1,a5,8000201e <bread+0x84>
    80002012:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002014:	40bc                	lw	a5,64(s1)
    80002016:	cb91                	beqz	a5,8000202a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002018:	64a4                	ld	s1,72(s1)
    8000201a:	fee49de3          	bne	s1,a4,80002014 <bread+0x7a>
  panic("bget: no buffers");
    8000201e:	00005517          	auipc	a0,0x5
    80002022:	49a50513          	addi	a0,a0,1178 # 800074b8 <etext+0x4b8>
    80002026:	45c030ef          	jal	80005482 <panic>
      b->dev = dev;
    8000202a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000202e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002032:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002036:	4785                	li	a5,1
    80002038:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000203a:	0000e517          	auipc	a0,0xe
    8000203e:	41e50513          	addi	a0,a0,1054 # 80010458 <bcache>
    80002042:	007030ef          	jal	80005848 <release>
      acquiresleep(&b->lock);
    80002046:	01048513          	addi	a0,s1,16
    8000204a:	1a8010ef          	jal	800031f2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000204e:	409c                	lw	a5,0(s1)
    80002050:	cb89                	beqz	a5,80002062 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002052:	8526                	mv	a0,s1
    80002054:	70a2                	ld	ra,40(sp)
    80002056:	7402                	ld	s0,32(sp)
    80002058:	64e2                	ld	s1,24(sp)
    8000205a:	6942                	ld	s2,16(sp)
    8000205c:	69a2                	ld	s3,8(sp)
    8000205e:	6145                	addi	sp,sp,48
    80002060:	8082                	ret
    virtio_disk_rw(b, 0);
    80002062:	4581                	li	a1,0
    80002064:	8526                	mv	a0,s1
    80002066:	1eb020ef          	jal	80004a50 <virtio_disk_rw>
    b->valid = 1;
    8000206a:	4785                	li	a5,1
    8000206c:	c09c                	sw	a5,0(s1)
  return b;
    8000206e:	b7d5                	j	80002052 <bread+0xb8>

0000000080002070 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002070:	1101                	addi	sp,sp,-32
    80002072:	ec06                	sd	ra,24(sp)
    80002074:	e822                	sd	s0,16(sp)
    80002076:	e426                	sd	s1,8(sp)
    80002078:	1000                	addi	s0,sp,32
    8000207a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000207c:	0541                	addi	a0,a0,16
    8000207e:	1f2010ef          	jal	80003270 <holdingsleep>
    80002082:	c911                	beqz	a0,80002096 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002084:	4585                	li	a1,1
    80002086:	8526                	mv	a0,s1
    80002088:	1c9020ef          	jal	80004a50 <virtio_disk_rw>
}
    8000208c:	60e2                	ld	ra,24(sp)
    8000208e:	6442                	ld	s0,16(sp)
    80002090:	64a2                	ld	s1,8(sp)
    80002092:	6105                	addi	sp,sp,32
    80002094:	8082                	ret
    panic("bwrite");
    80002096:	00005517          	auipc	a0,0x5
    8000209a:	43a50513          	addi	a0,a0,1082 # 800074d0 <etext+0x4d0>
    8000209e:	3e4030ef          	jal	80005482 <panic>

00000000800020a2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	e04a                	sd	s2,0(sp)
    800020ac:	1000                	addi	s0,sp,32
    800020ae:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020b0:	01050913          	addi	s2,a0,16
    800020b4:	854a                	mv	a0,s2
    800020b6:	1ba010ef          	jal	80003270 <holdingsleep>
    800020ba:	c135                	beqz	a0,8000211e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800020bc:	854a                	mv	a0,s2
    800020be:	17a010ef          	jal	80003238 <releasesleep>

  acquire(&bcache.lock);
    800020c2:	0000e517          	auipc	a0,0xe
    800020c6:	39650513          	addi	a0,a0,918 # 80010458 <bcache>
    800020ca:	6e6030ef          	jal	800057b0 <acquire>
  b->refcnt--;
    800020ce:	40bc                	lw	a5,64(s1)
    800020d0:	37fd                	addiw	a5,a5,-1
    800020d2:	0007871b          	sext.w	a4,a5
    800020d6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800020d8:	e71d                	bnez	a4,80002106 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800020da:	68b8                	ld	a4,80(s1)
    800020dc:	64bc                	ld	a5,72(s1)
    800020de:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800020e0:	68b8                	ld	a4,80(s1)
    800020e2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800020e4:	00016797          	auipc	a5,0x16
    800020e8:	37478793          	addi	a5,a5,884 # 80018458 <bcache+0x8000>
    800020ec:	2b87b703          	ld	a4,696(a5)
    800020f0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800020f2:	00016717          	auipc	a4,0x16
    800020f6:	5ce70713          	addi	a4,a4,1486 # 800186c0 <bcache+0x8268>
    800020fa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800020fc:	2b87b703          	ld	a4,696(a5)
    80002100:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002102:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002106:	0000e517          	auipc	a0,0xe
    8000210a:	35250513          	addi	a0,a0,850 # 80010458 <bcache>
    8000210e:	73a030ef          	jal	80005848 <release>
}
    80002112:	60e2                	ld	ra,24(sp)
    80002114:	6442                	ld	s0,16(sp)
    80002116:	64a2                	ld	s1,8(sp)
    80002118:	6902                	ld	s2,0(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret
    panic("brelse");
    8000211e:	00005517          	auipc	a0,0x5
    80002122:	3ba50513          	addi	a0,a0,954 # 800074d8 <etext+0x4d8>
    80002126:	35c030ef          	jal	80005482 <panic>

000000008000212a <bpin>:

void
bpin(struct buf *b) {
    8000212a:	1101                	addi	sp,sp,-32
    8000212c:	ec06                	sd	ra,24(sp)
    8000212e:	e822                	sd	s0,16(sp)
    80002130:	e426                	sd	s1,8(sp)
    80002132:	1000                	addi	s0,sp,32
    80002134:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002136:	0000e517          	auipc	a0,0xe
    8000213a:	32250513          	addi	a0,a0,802 # 80010458 <bcache>
    8000213e:	672030ef          	jal	800057b0 <acquire>
  b->refcnt++;
    80002142:	40bc                	lw	a5,64(s1)
    80002144:	2785                	addiw	a5,a5,1
    80002146:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002148:	0000e517          	auipc	a0,0xe
    8000214c:	31050513          	addi	a0,a0,784 # 80010458 <bcache>
    80002150:	6f8030ef          	jal	80005848 <release>
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6105                	addi	sp,sp,32
    8000215c:	8082                	ret

000000008000215e <bunpin>:

void
bunpin(struct buf *b) {
    8000215e:	1101                	addi	sp,sp,-32
    80002160:	ec06                	sd	ra,24(sp)
    80002162:	e822                	sd	s0,16(sp)
    80002164:	e426                	sd	s1,8(sp)
    80002166:	1000                	addi	s0,sp,32
    80002168:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000216a:	0000e517          	auipc	a0,0xe
    8000216e:	2ee50513          	addi	a0,a0,750 # 80010458 <bcache>
    80002172:	63e030ef          	jal	800057b0 <acquire>
  b->refcnt--;
    80002176:	40bc                	lw	a5,64(s1)
    80002178:	37fd                	addiw	a5,a5,-1
    8000217a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000217c:	0000e517          	auipc	a0,0xe
    80002180:	2dc50513          	addi	a0,a0,732 # 80010458 <bcache>
    80002184:	6c4030ef          	jal	80005848 <release>
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	64a2                	ld	s1,8(sp)
    8000218e:	6105                	addi	sp,sp,32
    80002190:	8082                	ret

0000000080002192 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002192:	1101                	addi	sp,sp,-32
    80002194:	ec06                	sd	ra,24(sp)
    80002196:	e822                	sd	s0,16(sp)
    80002198:	e426                	sd	s1,8(sp)
    8000219a:	e04a                	sd	s2,0(sp)
    8000219c:	1000                	addi	s0,sp,32
    8000219e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021a0:	00d5d59b          	srliw	a1,a1,0xd
    800021a4:	00017797          	auipc	a5,0x17
    800021a8:	9907a783          	lw	a5,-1648(a5) # 80018b34 <sb+0x1c>
    800021ac:	9dbd                	addw	a1,a1,a5
    800021ae:	dedff0ef          	jal	80001f9a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021b2:	0074f713          	andi	a4,s1,7
    800021b6:	4785                	li	a5,1
    800021b8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800021bc:	14ce                	slli	s1,s1,0x33
    800021be:	90d9                	srli	s1,s1,0x36
    800021c0:	00950733          	add	a4,a0,s1
    800021c4:	05874703          	lbu	a4,88(a4)
    800021c8:	00e7f6b3          	and	a3,a5,a4
    800021cc:	c29d                	beqz	a3,800021f2 <bfree+0x60>
    800021ce:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800021d0:	94aa                	add	s1,s1,a0
    800021d2:	fff7c793          	not	a5,a5
    800021d6:	8f7d                	and	a4,a4,a5
    800021d8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800021dc:	711000ef          	jal	800030ec <log_write>
  brelse(bp);
    800021e0:	854a                	mv	a0,s2
    800021e2:	ec1ff0ef          	jal	800020a2 <brelse>
}
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6902                	ld	s2,0(sp)
    800021ee:	6105                	addi	sp,sp,32
    800021f0:	8082                	ret
    panic("freeing free block");
    800021f2:	00005517          	auipc	a0,0x5
    800021f6:	2ee50513          	addi	a0,a0,750 # 800074e0 <etext+0x4e0>
    800021fa:	288030ef          	jal	80005482 <panic>

00000000800021fe <balloc>:
{
    800021fe:	711d                	addi	sp,sp,-96
    80002200:	ec86                	sd	ra,88(sp)
    80002202:	e8a2                	sd	s0,80(sp)
    80002204:	e4a6                	sd	s1,72(sp)
    80002206:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002208:	00017797          	auipc	a5,0x17
    8000220c:	9147a783          	lw	a5,-1772(a5) # 80018b1c <sb+0x4>
    80002210:	0e078f63          	beqz	a5,8000230e <balloc+0x110>
    80002214:	e0ca                	sd	s2,64(sp)
    80002216:	fc4e                	sd	s3,56(sp)
    80002218:	f852                	sd	s4,48(sp)
    8000221a:	f456                	sd	s5,40(sp)
    8000221c:	f05a                	sd	s6,32(sp)
    8000221e:	ec5e                	sd	s7,24(sp)
    80002220:	e862                	sd	s8,16(sp)
    80002222:	e466                	sd	s9,8(sp)
    80002224:	8baa                	mv	s7,a0
    80002226:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002228:	00017b17          	auipc	s6,0x17
    8000222c:	8f0b0b13          	addi	s6,s6,-1808 # 80018b18 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002230:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002232:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002234:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002236:	6c89                	lui	s9,0x2
    80002238:	a0b5                	j	800022a4 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000223a:	97ca                	add	a5,a5,s2
    8000223c:	8e55                	or	a2,a2,a3
    8000223e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002242:	854a                	mv	a0,s2
    80002244:	6a9000ef          	jal	800030ec <log_write>
        brelse(bp);
    80002248:	854a                	mv	a0,s2
    8000224a:	e59ff0ef          	jal	800020a2 <brelse>
  bp = bread(dev, bno);
    8000224e:	85a6                	mv	a1,s1
    80002250:	855e                	mv	a0,s7
    80002252:	d49ff0ef          	jal	80001f9a <bread>
    80002256:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002258:	40000613          	li	a2,1024
    8000225c:	4581                	li	a1,0
    8000225e:	05850513          	addi	a0,a0,88
    80002262:	ed3fd0ef          	jal	80000134 <memset>
  log_write(bp);
    80002266:	854a                	mv	a0,s2
    80002268:	685000ef          	jal	800030ec <log_write>
  brelse(bp);
    8000226c:	854a                	mv	a0,s2
    8000226e:	e35ff0ef          	jal	800020a2 <brelse>
}
    80002272:	6906                	ld	s2,64(sp)
    80002274:	79e2                	ld	s3,56(sp)
    80002276:	7a42                	ld	s4,48(sp)
    80002278:	7aa2                	ld	s5,40(sp)
    8000227a:	7b02                	ld	s6,32(sp)
    8000227c:	6be2                	ld	s7,24(sp)
    8000227e:	6c42                	ld	s8,16(sp)
    80002280:	6ca2                	ld	s9,8(sp)
}
    80002282:	8526                	mv	a0,s1
    80002284:	60e6                	ld	ra,88(sp)
    80002286:	6446                	ld	s0,80(sp)
    80002288:	64a6                	ld	s1,72(sp)
    8000228a:	6125                	addi	sp,sp,96
    8000228c:	8082                	ret
    brelse(bp);
    8000228e:	854a                	mv	a0,s2
    80002290:	e13ff0ef          	jal	800020a2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002294:	015c87bb          	addw	a5,s9,s5
    80002298:	00078a9b          	sext.w	s5,a5
    8000229c:	004b2703          	lw	a4,4(s6)
    800022a0:	04eaff63          	bgeu	s5,a4,800022fe <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800022a4:	41fad79b          	sraiw	a5,s5,0x1f
    800022a8:	0137d79b          	srliw	a5,a5,0x13
    800022ac:	015787bb          	addw	a5,a5,s5
    800022b0:	40d7d79b          	sraiw	a5,a5,0xd
    800022b4:	01cb2583          	lw	a1,28(s6)
    800022b8:	9dbd                	addw	a1,a1,a5
    800022ba:	855e                	mv	a0,s7
    800022bc:	cdfff0ef          	jal	80001f9a <bread>
    800022c0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022c2:	004b2503          	lw	a0,4(s6)
    800022c6:	000a849b          	sext.w	s1,s5
    800022ca:	8762                	mv	a4,s8
    800022cc:	fca4f1e3          	bgeu	s1,a0,8000228e <balloc+0x90>
      m = 1 << (bi % 8);
    800022d0:	00777693          	andi	a3,a4,7
    800022d4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800022d8:	41f7579b          	sraiw	a5,a4,0x1f
    800022dc:	01d7d79b          	srliw	a5,a5,0x1d
    800022e0:	9fb9                	addw	a5,a5,a4
    800022e2:	4037d79b          	sraiw	a5,a5,0x3
    800022e6:	00f90633          	add	a2,s2,a5
    800022ea:	05864603          	lbu	a2,88(a2)
    800022ee:	00c6f5b3          	and	a1,a3,a2
    800022f2:	d5a1                	beqz	a1,8000223a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022f4:	2705                	addiw	a4,a4,1
    800022f6:	2485                	addiw	s1,s1,1
    800022f8:	fd471ae3          	bne	a4,s4,800022cc <balloc+0xce>
    800022fc:	bf49                	j	8000228e <balloc+0x90>
    800022fe:	6906                	ld	s2,64(sp)
    80002300:	79e2                	ld	s3,56(sp)
    80002302:	7a42                	ld	s4,48(sp)
    80002304:	7aa2                	ld	s5,40(sp)
    80002306:	7b02                	ld	s6,32(sp)
    80002308:	6be2                	ld	s7,24(sp)
    8000230a:	6c42                	ld	s8,16(sp)
    8000230c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000230e:	00005517          	auipc	a0,0x5
    80002312:	1ea50513          	addi	a0,a0,490 # 800074f8 <etext+0x4f8>
    80002316:	69b020ef          	jal	800051b0 <printf>
  return 0;
    8000231a:	4481                	li	s1,0
    8000231c:	b79d                	j	80002282 <balloc+0x84>

000000008000231e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000231e:	7179                	addi	sp,sp,-48
    80002320:	f406                	sd	ra,40(sp)
    80002322:	f022                	sd	s0,32(sp)
    80002324:	ec26                	sd	s1,24(sp)
    80002326:	e84a                	sd	s2,16(sp)
    80002328:	e44e                	sd	s3,8(sp)
    8000232a:	1800                	addi	s0,sp,48
    8000232c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000232e:	47ad                	li	a5,11
    80002330:	02b7e663          	bltu	a5,a1,8000235c <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002334:	02059793          	slli	a5,a1,0x20
    80002338:	01e7d593          	srli	a1,a5,0x1e
    8000233c:	00b504b3          	add	s1,a0,a1
    80002340:	0504a903          	lw	s2,80(s1)
    80002344:	06091a63          	bnez	s2,800023b8 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002348:	4108                	lw	a0,0(a0)
    8000234a:	eb5ff0ef          	jal	800021fe <balloc>
    8000234e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002352:	06090363          	beqz	s2,800023b8 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002356:	0524a823          	sw	s2,80(s1)
    8000235a:	a8b9                	j	800023b8 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000235c:	ff45849b          	addiw	s1,a1,-12
    80002360:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002364:	0ff00793          	li	a5,255
    80002368:	06e7ee63          	bltu	a5,a4,800023e4 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000236c:	08052903          	lw	s2,128(a0)
    80002370:	00091d63          	bnez	s2,8000238a <bmap+0x6c>
      addr = balloc(ip->dev);
    80002374:	4108                	lw	a0,0(a0)
    80002376:	e89ff0ef          	jal	800021fe <balloc>
    8000237a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000237e:	02090d63          	beqz	s2,800023b8 <bmap+0x9a>
    80002382:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002384:	0929a023          	sw	s2,128(s3)
    80002388:	a011                	j	8000238c <bmap+0x6e>
    8000238a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000238c:	85ca                	mv	a1,s2
    8000238e:	0009a503          	lw	a0,0(s3)
    80002392:	c09ff0ef          	jal	80001f9a <bread>
    80002396:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002398:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000239c:	02049713          	slli	a4,s1,0x20
    800023a0:	01e75593          	srli	a1,a4,0x1e
    800023a4:	00b784b3          	add	s1,a5,a1
    800023a8:	0004a903          	lw	s2,0(s1)
    800023ac:	00090e63          	beqz	s2,800023c8 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023b0:	8552                	mv	a0,s4
    800023b2:	cf1ff0ef          	jal	800020a2 <brelse>
    return addr;
    800023b6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023b8:	854a                	mv	a0,s2
    800023ba:	70a2                	ld	ra,40(sp)
    800023bc:	7402                	ld	s0,32(sp)
    800023be:	64e2                	ld	s1,24(sp)
    800023c0:	6942                	ld	s2,16(sp)
    800023c2:	69a2                	ld	s3,8(sp)
    800023c4:	6145                	addi	sp,sp,48
    800023c6:	8082                	ret
      addr = balloc(ip->dev);
    800023c8:	0009a503          	lw	a0,0(s3)
    800023cc:	e33ff0ef          	jal	800021fe <balloc>
    800023d0:	0005091b          	sext.w	s2,a0
      if(addr){
    800023d4:	fc090ee3          	beqz	s2,800023b0 <bmap+0x92>
        a[bn] = addr;
    800023d8:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800023dc:	8552                	mv	a0,s4
    800023de:	50f000ef          	jal	800030ec <log_write>
    800023e2:	b7f9                	j	800023b0 <bmap+0x92>
    800023e4:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800023e6:	00005517          	auipc	a0,0x5
    800023ea:	12a50513          	addi	a0,a0,298 # 80007510 <etext+0x510>
    800023ee:	094030ef          	jal	80005482 <panic>

00000000800023f2 <iget>:
{
    800023f2:	7179                	addi	sp,sp,-48
    800023f4:	f406                	sd	ra,40(sp)
    800023f6:	f022                	sd	s0,32(sp)
    800023f8:	ec26                	sd	s1,24(sp)
    800023fa:	e84a                	sd	s2,16(sp)
    800023fc:	e44e                	sd	s3,8(sp)
    800023fe:	e052                	sd	s4,0(sp)
    80002400:	1800                	addi	s0,sp,48
    80002402:	89aa                	mv	s3,a0
    80002404:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002406:	00016517          	auipc	a0,0x16
    8000240a:	73250513          	addi	a0,a0,1842 # 80018b38 <itable>
    8000240e:	3a2030ef          	jal	800057b0 <acquire>
  empty = 0;
    80002412:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002414:	00016497          	auipc	s1,0x16
    80002418:	73c48493          	addi	s1,s1,1852 # 80018b50 <itable+0x18>
    8000241c:	00018697          	auipc	a3,0x18
    80002420:	1c468693          	addi	a3,a3,452 # 8001a5e0 <log>
    80002424:	a039                	j	80002432 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002426:	02090963          	beqz	s2,80002458 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000242a:	08848493          	addi	s1,s1,136
    8000242e:	02d48863          	beq	s1,a3,8000245e <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002432:	449c                	lw	a5,8(s1)
    80002434:	fef059e3          	blez	a5,80002426 <iget+0x34>
    80002438:	4098                	lw	a4,0(s1)
    8000243a:	ff3716e3          	bne	a4,s3,80002426 <iget+0x34>
    8000243e:	40d8                	lw	a4,4(s1)
    80002440:	ff4713e3          	bne	a4,s4,80002426 <iget+0x34>
      ip->ref++;
    80002444:	2785                	addiw	a5,a5,1
    80002446:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002448:	00016517          	auipc	a0,0x16
    8000244c:	6f050513          	addi	a0,a0,1776 # 80018b38 <itable>
    80002450:	3f8030ef          	jal	80005848 <release>
      return ip;
    80002454:	8926                	mv	s2,s1
    80002456:	a02d                	j	80002480 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002458:	fbe9                	bnez	a5,8000242a <iget+0x38>
      empty = ip;
    8000245a:	8926                	mv	s2,s1
    8000245c:	b7f9                	j	8000242a <iget+0x38>
  if(empty == 0)
    8000245e:	02090a63          	beqz	s2,80002492 <iget+0xa0>
  ip->dev = dev;
    80002462:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002466:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000246a:	4785                	li	a5,1
    8000246c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002470:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002474:	00016517          	auipc	a0,0x16
    80002478:	6c450513          	addi	a0,a0,1732 # 80018b38 <itable>
    8000247c:	3cc030ef          	jal	80005848 <release>
}
    80002480:	854a                	mv	a0,s2
    80002482:	70a2                	ld	ra,40(sp)
    80002484:	7402                	ld	s0,32(sp)
    80002486:	64e2                	ld	s1,24(sp)
    80002488:	6942                	ld	s2,16(sp)
    8000248a:	69a2                	ld	s3,8(sp)
    8000248c:	6a02                	ld	s4,0(sp)
    8000248e:	6145                	addi	sp,sp,48
    80002490:	8082                	ret
    panic("iget: no inodes");
    80002492:	00005517          	auipc	a0,0x5
    80002496:	09650513          	addi	a0,a0,150 # 80007528 <etext+0x528>
    8000249a:	7e9020ef          	jal	80005482 <panic>

000000008000249e <fsinit>:
fsinit(int dev) {
    8000249e:	7179                	addi	sp,sp,-48
    800024a0:	f406                	sd	ra,40(sp)
    800024a2:	f022                	sd	s0,32(sp)
    800024a4:	ec26                	sd	s1,24(sp)
    800024a6:	e84a                	sd	s2,16(sp)
    800024a8:	e44e                	sd	s3,8(sp)
    800024aa:	1800                	addi	s0,sp,48
    800024ac:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800024ae:	4585                	li	a1,1
    800024b0:	aebff0ef          	jal	80001f9a <bread>
    800024b4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800024b6:	00016997          	auipc	s3,0x16
    800024ba:	66298993          	addi	s3,s3,1634 # 80018b18 <sb>
    800024be:	02000613          	li	a2,32
    800024c2:	05850593          	addi	a1,a0,88
    800024c6:	854e                	mv	a0,s3
    800024c8:	cc9fd0ef          	jal	80000190 <memmove>
  brelse(bp);
    800024cc:	8526                	mv	a0,s1
    800024ce:	bd5ff0ef          	jal	800020a2 <brelse>
  if(sb.magic != FSMAGIC)
    800024d2:	0009a703          	lw	a4,0(s3)
    800024d6:	102037b7          	lui	a5,0x10203
    800024da:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800024de:	02f71063          	bne	a4,a5,800024fe <fsinit+0x60>
  initlog(dev, &sb);
    800024e2:	00016597          	auipc	a1,0x16
    800024e6:	63658593          	addi	a1,a1,1590 # 80018b18 <sb>
    800024ea:	854a                	mv	a0,s2
    800024ec:	1f9000ef          	jal	80002ee4 <initlog>
}
    800024f0:	70a2                	ld	ra,40(sp)
    800024f2:	7402                	ld	s0,32(sp)
    800024f4:	64e2                	ld	s1,24(sp)
    800024f6:	6942                	ld	s2,16(sp)
    800024f8:	69a2                	ld	s3,8(sp)
    800024fa:	6145                	addi	sp,sp,48
    800024fc:	8082                	ret
    panic("invalid file system");
    800024fe:	00005517          	auipc	a0,0x5
    80002502:	03a50513          	addi	a0,a0,58 # 80007538 <etext+0x538>
    80002506:	77d020ef          	jal	80005482 <panic>

000000008000250a <iinit>:
{
    8000250a:	7179                	addi	sp,sp,-48
    8000250c:	f406                	sd	ra,40(sp)
    8000250e:	f022                	sd	s0,32(sp)
    80002510:	ec26                	sd	s1,24(sp)
    80002512:	e84a                	sd	s2,16(sp)
    80002514:	e44e                	sd	s3,8(sp)
    80002516:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002518:	00005597          	auipc	a1,0x5
    8000251c:	03858593          	addi	a1,a1,56 # 80007550 <etext+0x550>
    80002520:	00016517          	auipc	a0,0x16
    80002524:	61850513          	addi	a0,a0,1560 # 80018b38 <itable>
    80002528:	208030ef          	jal	80005730 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000252c:	00016497          	auipc	s1,0x16
    80002530:	63448493          	addi	s1,s1,1588 # 80018b60 <itable+0x28>
    80002534:	00018997          	auipc	s3,0x18
    80002538:	0bc98993          	addi	s3,s3,188 # 8001a5f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000253c:	00005917          	auipc	s2,0x5
    80002540:	01c90913          	addi	s2,s2,28 # 80007558 <etext+0x558>
    80002544:	85ca                	mv	a1,s2
    80002546:	8526                	mv	a0,s1
    80002548:	475000ef          	jal	800031bc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000254c:	08848493          	addi	s1,s1,136
    80002550:	ff349ae3          	bne	s1,s3,80002544 <iinit+0x3a>
}
    80002554:	70a2                	ld	ra,40(sp)
    80002556:	7402                	ld	s0,32(sp)
    80002558:	64e2                	ld	s1,24(sp)
    8000255a:	6942                	ld	s2,16(sp)
    8000255c:	69a2                	ld	s3,8(sp)
    8000255e:	6145                	addi	sp,sp,48
    80002560:	8082                	ret

0000000080002562 <ialloc>:
{
    80002562:	7139                	addi	sp,sp,-64
    80002564:	fc06                	sd	ra,56(sp)
    80002566:	f822                	sd	s0,48(sp)
    80002568:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000256a:	00016717          	auipc	a4,0x16
    8000256e:	5ba72703          	lw	a4,1466(a4) # 80018b24 <sb+0xc>
    80002572:	4785                	li	a5,1
    80002574:	06e7f063          	bgeu	a5,a4,800025d4 <ialloc+0x72>
    80002578:	f426                	sd	s1,40(sp)
    8000257a:	f04a                	sd	s2,32(sp)
    8000257c:	ec4e                	sd	s3,24(sp)
    8000257e:	e852                	sd	s4,16(sp)
    80002580:	e456                	sd	s5,8(sp)
    80002582:	e05a                	sd	s6,0(sp)
    80002584:	8aaa                	mv	s5,a0
    80002586:	8b2e                	mv	s6,a1
    80002588:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000258a:	00016a17          	auipc	s4,0x16
    8000258e:	58ea0a13          	addi	s4,s4,1422 # 80018b18 <sb>
    80002592:	00495593          	srli	a1,s2,0x4
    80002596:	018a2783          	lw	a5,24(s4)
    8000259a:	9dbd                	addw	a1,a1,a5
    8000259c:	8556                	mv	a0,s5
    8000259e:	9fdff0ef          	jal	80001f9a <bread>
    800025a2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025a4:	05850993          	addi	s3,a0,88
    800025a8:	00f97793          	andi	a5,s2,15
    800025ac:	079a                	slli	a5,a5,0x6
    800025ae:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025b0:	00099783          	lh	a5,0(s3)
    800025b4:	cb9d                	beqz	a5,800025ea <ialloc+0x88>
    brelse(bp);
    800025b6:	aedff0ef          	jal	800020a2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025ba:	0905                	addi	s2,s2,1
    800025bc:	00ca2703          	lw	a4,12(s4)
    800025c0:	0009079b          	sext.w	a5,s2
    800025c4:	fce7e7e3          	bltu	a5,a4,80002592 <ialloc+0x30>
    800025c8:	74a2                	ld	s1,40(sp)
    800025ca:	7902                	ld	s2,32(sp)
    800025cc:	69e2                	ld	s3,24(sp)
    800025ce:	6a42                	ld	s4,16(sp)
    800025d0:	6aa2                	ld	s5,8(sp)
    800025d2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025d4:	00005517          	auipc	a0,0x5
    800025d8:	f8c50513          	addi	a0,a0,-116 # 80007560 <etext+0x560>
    800025dc:	3d5020ef          	jal	800051b0 <printf>
  return 0;
    800025e0:	4501                	li	a0,0
}
    800025e2:	70e2                	ld	ra,56(sp)
    800025e4:	7442                	ld	s0,48(sp)
    800025e6:	6121                	addi	sp,sp,64
    800025e8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800025ea:	04000613          	li	a2,64
    800025ee:	4581                	li	a1,0
    800025f0:	854e                	mv	a0,s3
    800025f2:	b43fd0ef          	jal	80000134 <memset>
      dip->type = type;
    800025f6:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800025fa:	8526                	mv	a0,s1
    800025fc:	2f1000ef          	jal	800030ec <log_write>
      brelse(bp);
    80002600:	8526                	mv	a0,s1
    80002602:	aa1ff0ef          	jal	800020a2 <brelse>
      return iget(dev, inum);
    80002606:	0009059b          	sext.w	a1,s2
    8000260a:	8556                	mv	a0,s5
    8000260c:	de7ff0ef          	jal	800023f2 <iget>
    80002610:	74a2                	ld	s1,40(sp)
    80002612:	7902                	ld	s2,32(sp)
    80002614:	69e2                	ld	s3,24(sp)
    80002616:	6a42                	ld	s4,16(sp)
    80002618:	6aa2                	ld	s5,8(sp)
    8000261a:	6b02                	ld	s6,0(sp)
    8000261c:	b7d9                	j	800025e2 <ialloc+0x80>

000000008000261e <iupdate>:
{
    8000261e:	1101                	addi	sp,sp,-32
    80002620:	ec06                	sd	ra,24(sp)
    80002622:	e822                	sd	s0,16(sp)
    80002624:	e426                	sd	s1,8(sp)
    80002626:	e04a                	sd	s2,0(sp)
    80002628:	1000                	addi	s0,sp,32
    8000262a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000262c:	415c                	lw	a5,4(a0)
    8000262e:	0047d79b          	srliw	a5,a5,0x4
    80002632:	00016597          	auipc	a1,0x16
    80002636:	4fe5a583          	lw	a1,1278(a1) # 80018b30 <sb+0x18>
    8000263a:	9dbd                	addw	a1,a1,a5
    8000263c:	4108                	lw	a0,0(a0)
    8000263e:	95dff0ef          	jal	80001f9a <bread>
    80002642:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002644:	05850793          	addi	a5,a0,88
    80002648:	40d8                	lw	a4,4(s1)
    8000264a:	8b3d                	andi	a4,a4,15
    8000264c:	071a                	slli	a4,a4,0x6
    8000264e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002650:	04449703          	lh	a4,68(s1)
    80002654:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002658:	04649703          	lh	a4,70(s1)
    8000265c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002660:	04849703          	lh	a4,72(s1)
    80002664:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002668:	04a49703          	lh	a4,74(s1)
    8000266c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002670:	44f8                	lw	a4,76(s1)
    80002672:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002674:	03400613          	li	a2,52
    80002678:	05048593          	addi	a1,s1,80
    8000267c:	00c78513          	addi	a0,a5,12
    80002680:	b11fd0ef          	jal	80000190 <memmove>
  log_write(bp);
    80002684:	854a                	mv	a0,s2
    80002686:	267000ef          	jal	800030ec <log_write>
  brelse(bp);
    8000268a:	854a                	mv	a0,s2
    8000268c:	a17ff0ef          	jal	800020a2 <brelse>
}
    80002690:	60e2                	ld	ra,24(sp)
    80002692:	6442                	ld	s0,16(sp)
    80002694:	64a2                	ld	s1,8(sp)
    80002696:	6902                	ld	s2,0(sp)
    80002698:	6105                	addi	sp,sp,32
    8000269a:	8082                	ret

000000008000269c <idup>:
{
    8000269c:	1101                	addi	sp,sp,-32
    8000269e:	ec06                	sd	ra,24(sp)
    800026a0:	e822                	sd	s0,16(sp)
    800026a2:	e426                	sd	s1,8(sp)
    800026a4:	1000                	addi	s0,sp,32
    800026a6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026a8:	00016517          	auipc	a0,0x16
    800026ac:	49050513          	addi	a0,a0,1168 # 80018b38 <itable>
    800026b0:	100030ef          	jal	800057b0 <acquire>
  ip->ref++;
    800026b4:	449c                	lw	a5,8(s1)
    800026b6:	2785                	addiw	a5,a5,1
    800026b8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026ba:	00016517          	auipc	a0,0x16
    800026be:	47e50513          	addi	a0,a0,1150 # 80018b38 <itable>
    800026c2:	186030ef          	jal	80005848 <release>
}
    800026c6:	8526                	mv	a0,s1
    800026c8:	60e2                	ld	ra,24(sp)
    800026ca:	6442                	ld	s0,16(sp)
    800026cc:	64a2                	ld	s1,8(sp)
    800026ce:	6105                	addi	sp,sp,32
    800026d0:	8082                	ret

00000000800026d2 <ilock>:
{
    800026d2:	1101                	addi	sp,sp,-32
    800026d4:	ec06                	sd	ra,24(sp)
    800026d6:	e822                	sd	s0,16(sp)
    800026d8:	e426                	sd	s1,8(sp)
    800026da:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026dc:	cd19                	beqz	a0,800026fa <ilock+0x28>
    800026de:	84aa                	mv	s1,a0
    800026e0:	451c                	lw	a5,8(a0)
    800026e2:	00f05c63          	blez	a5,800026fa <ilock+0x28>
  acquiresleep(&ip->lock);
    800026e6:	0541                	addi	a0,a0,16
    800026e8:	30b000ef          	jal	800031f2 <acquiresleep>
  if(ip->valid == 0){
    800026ec:	40bc                	lw	a5,64(s1)
    800026ee:	cf89                	beqz	a5,80002708 <ilock+0x36>
}
    800026f0:	60e2                	ld	ra,24(sp)
    800026f2:	6442                	ld	s0,16(sp)
    800026f4:	64a2                	ld	s1,8(sp)
    800026f6:	6105                	addi	sp,sp,32
    800026f8:	8082                	ret
    800026fa:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800026fc:	00005517          	auipc	a0,0x5
    80002700:	e7c50513          	addi	a0,a0,-388 # 80007578 <etext+0x578>
    80002704:	57f020ef          	jal	80005482 <panic>
    80002708:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000270a:	40dc                	lw	a5,4(s1)
    8000270c:	0047d79b          	srliw	a5,a5,0x4
    80002710:	00016597          	auipc	a1,0x16
    80002714:	4205a583          	lw	a1,1056(a1) # 80018b30 <sb+0x18>
    80002718:	9dbd                	addw	a1,a1,a5
    8000271a:	4088                	lw	a0,0(s1)
    8000271c:	87fff0ef          	jal	80001f9a <bread>
    80002720:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002722:	05850593          	addi	a1,a0,88
    80002726:	40dc                	lw	a5,4(s1)
    80002728:	8bbd                	andi	a5,a5,15
    8000272a:	079a                	slli	a5,a5,0x6
    8000272c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000272e:	00059783          	lh	a5,0(a1)
    80002732:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002736:	00259783          	lh	a5,2(a1)
    8000273a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000273e:	00459783          	lh	a5,4(a1)
    80002742:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002746:	00659783          	lh	a5,6(a1)
    8000274a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000274e:	459c                	lw	a5,8(a1)
    80002750:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002752:	03400613          	li	a2,52
    80002756:	05b1                	addi	a1,a1,12
    80002758:	05048513          	addi	a0,s1,80
    8000275c:	a35fd0ef          	jal	80000190 <memmove>
    brelse(bp);
    80002760:	854a                	mv	a0,s2
    80002762:	941ff0ef          	jal	800020a2 <brelse>
    ip->valid = 1;
    80002766:	4785                	li	a5,1
    80002768:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000276a:	04449783          	lh	a5,68(s1)
    8000276e:	c399                	beqz	a5,80002774 <ilock+0xa2>
    80002770:	6902                	ld	s2,0(sp)
    80002772:	bfbd                	j	800026f0 <ilock+0x1e>
      panic("ilock: no type");
    80002774:	00005517          	auipc	a0,0x5
    80002778:	e0c50513          	addi	a0,a0,-500 # 80007580 <etext+0x580>
    8000277c:	507020ef          	jal	80005482 <panic>

0000000080002780 <iunlock>:
{
    80002780:	1101                	addi	sp,sp,-32
    80002782:	ec06                	sd	ra,24(sp)
    80002784:	e822                	sd	s0,16(sp)
    80002786:	e426                	sd	s1,8(sp)
    80002788:	e04a                	sd	s2,0(sp)
    8000278a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000278c:	c505                	beqz	a0,800027b4 <iunlock+0x34>
    8000278e:	84aa                	mv	s1,a0
    80002790:	01050913          	addi	s2,a0,16
    80002794:	854a                	mv	a0,s2
    80002796:	2db000ef          	jal	80003270 <holdingsleep>
    8000279a:	cd09                	beqz	a0,800027b4 <iunlock+0x34>
    8000279c:	449c                	lw	a5,8(s1)
    8000279e:	00f05b63          	blez	a5,800027b4 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027a2:	854a                	mv	a0,s2
    800027a4:	295000ef          	jal	80003238 <releasesleep>
}
    800027a8:	60e2                	ld	ra,24(sp)
    800027aa:	6442                	ld	s0,16(sp)
    800027ac:	64a2                	ld	s1,8(sp)
    800027ae:	6902                	ld	s2,0(sp)
    800027b0:	6105                	addi	sp,sp,32
    800027b2:	8082                	ret
    panic("iunlock");
    800027b4:	00005517          	auipc	a0,0x5
    800027b8:	ddc50513          	addi	a0,a0,-548 # 80007590 <etext+0x590>
    800027bc:	4c7020ef          	jal	80005482 <panic>

00000000800027c0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027c0:	7179                	addi	sp,sp,-48
    800027c2:	f406                	sd	ra,40(sp)
    800027c4:	f022                	sd	s0,32(sp)
    800027c6:	ec26                	sd	s1,24(sp)
    800027c8:	e84a                	sd	s2,16(sp)
    800027ca:	e44e                	sd	s3,8(sp)
    800027cc:	1800                	addi	s0,sp,48
    800027ce:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027d0:	05050493          	addi	s1,a0,80
    800027d4:	08050913          	addi	s2,a0,128
    800027d8:	a021                	j	800027e0 <itrunc+0x20>
    800027da:	0491                	addi	s1,s1,4
    800027dc:	01248b63          	beq	s1,s2,800027f2 <itrunc+0x32>
    if(ip->addrs[i]){
    800027e0:	408c                	lw	a1,0(s1)
    800027e2:	dde5                	beqz	a1,800027da <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800027e4:	0009a503          	lw	a0,0(s3)
    800027e8:	9abff0ef          	jal	80002192 <bfree>
      ip->addrs[i] = 0;
    800027ec:	0004a023          	sw	zero,0(s1)
    800027f0:	b7ed                	j	800027da <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800027f2:	0809a583          	lw	a1,128(s3)
    800027f6:	ed89                	bnez	a1,80002810 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800027f8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800027fc:	854e                	mv	a0,s3
    800027fe:	e21ff0ef          	jal	8000261e <iupdate>
}
    80002802:	70a2                	ld	ra,40(sp)
    80002804:	7402                	ld	s0,32(sp)
    80002806:	64e2                	ld	s1,24(sp)
    80002808:	6942                	ld	s2,16(sp)
    8000280a:	69a2                	ld	s3,8(sp)
    8000280c:	6145                	addi	sp,sp,48
    8000280e:	8082                	ret
    80002810:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002812:	0009a503          	lw	a0,0(s3)
    80002816:	f84ff0ef          	jal	80001f9a <bread>
    8000281a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000281c:	05850493          	addi	s1,a0,88
    80002820:	45850913          	addi	s2,a0,1112
    80002824:	a021                	j	8000282c <itrunc+0x6c>
    80002826:	0491                	addi	s1,s1,4
    80002828:	01248963          	beq	s1,s2,8000283a <itrunc+0x7a>
      if(a[j])
    8000282c:	408c                	lw	a1,0(s1)
    8000282e:	dde5                	beqz	a1,80002826 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002830:	0009a503          	lw	a0,0(s3)
    80002834:	95fff0ef          	jal	80002192 <bfree>
    80002838:	b7fd                	j	80002826 <itrunc+0x66>
    brelse(bp);
    8000283a:	8552                	mv	a0,s4
    8000283c:	867ff0ef          	jal	800020a2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002840:	0809a583          	lw	a1,128(s3)
    80002844:	0009a503          	lw	a0,0(s3)
    80002848:	94bff0ef          	jal	80002192 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000284c:	0809a023          	sw	zero,128(s3)
    80002850:	6a02                	ld	s4,0(sp)
    80002852:	b75d                	j	800027f8 <itrunc+0x38>

0000000080002854 <iput>:
{
    80002854:	1101                	addi	sp,sp,-32
    80002856:	ec06                	sd	ra,24(sp)
    80002858:	e822                	sd	s0,16(sp)
    8000285a:	e426                	sd	s1,8(sp)
    8000285c:	1000                	addi	s0,sp,32
    8000285e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002860:	00016517          	auipc	a0,0x16
    80002864:	2d850513          	addi	a0,a0,728 # 80018b38 <itable>
    80002868:	749020ef          	jal	800057b0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000286c:	4498                	lw	a4,8(s1)
    8000286e:	4785                	li	a5,1
    80002870:	02f70063          	beq	a4,a5,80002890 <iput+0x3c>
  ip->ref--;
    80002874:	449c                	lw	a5,8(s1)
    80002876:	37fd                	addiw	a5,a5,-1
    80002878:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000287a:	00016517          	auipc	a0,0x16
    8000287e:	2be50513          	addi	a0,a0,702 # 80018b38 <itable>
    80002882:	7c7020ef          	jal	80005848 <release>
}
    80002886:	60e2                	ld	ra,24(sp)
    80002888:	6442                	ld	s0,16(sp)
    8000288a:	64a2                	ld	s1,8(sp)
    8000288c:	6105                	addi	sp,sp,32
    8000288e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002890:	40bc                	lw	a5,64(s1)
    80002892:	d3ed                	beqz	a5,80002874 <iput+0x20>
    80002894:	04a49783          	lh	a5,74(s1)
    80002898:	fff1                	bnez	a5,80002874 <iput+0x20>
    8000289a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000289c:	01048913          	addi	s2,s1,16
    800028a0:	854a                	mv	a0,s2
    800028a2:	151000ef          	jal	800031f2 <acquiresleep>
    release(&itable.lock);
    800028a6:	00016517          	auipc	a0,0x16
    800028aa:	29250513          	addi	a0,a0,658 # 80018b38 <itable>
    800028ae:	79b020ef          	jal	80005848 <release>
    itrunc(ip);
    800028b2:	8526                	mv	a0,s1
    800028b4:	f0dff0ef          	jal	800027c0 <itrunc>
    ip->type = 0;
    800028b8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028bc:	8526                	mv	a0,s1
    800028be:	d61ff0ef          	jal	8000261e <iupdate>
    ip->valid = 0;
    800028c2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028c6:	854a                	mv	a0,s2
    800028c8:	171000ef          	jal	80003238 <releasesleep>
    acquire(&itable.lock);
    800028cc:	00016517          	auipc	a0,0x16
    800028d0:	26c50513          	addi	a0,a0,620 # 80018b38 <itable>
    800028d4:	6dd020ef          	jal	800057b0 <acquire>
    800028d8:	6902                	ld	s2,0(sp)
    800028da:	bf69                	j	80002874 <iput+0x20>

00000000800028dc <iunlockput>:
{
    800028dc:	1101                	addi	sp,sp,-32
    800028de:	ec06                	sd	ra,24(sp)
    800028e0:	e822                	sd	s0,16(sp)
    800028e2:	e426                	sd	s1,8(sp)
    800028e4:	1000                	addi	s0,sp,32
    800028e6:	84aa                	mv	s1,a0
  iunlock(ip);
    800028e8:	e99ff0ef          	jal	80002780 <iunlock>
  iput(ip);
    800028ec:	8526                	mv	a0,s1
    800028ee:	f67ff0ef          	jal	80002854 <iput>
}
    800028f2:	60e2                	ld	ra,24(sp)
    800028f4:	6442                	ld	s0,16(sp)
    800028f6:	64a2                	ld	s1,8(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret

00000000800028fc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800028fc:	1141                	addi	sp,sp,-16
    800028fe:	e422                	sd	s0,8(sp)
    80002900:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002902:	411c                	lw	a5,0(a0)
    80002904:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002906:	415c                	lw	a5,4(a0)
    80002908:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000290a:	04451783          	lh	a5,68(a0)
    8000290e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002912:	04a51783          	lh	a5,74(a0)
    80002916:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000291a:	04c56783          	lwu	a5,76(a0)
    8000291e:	e99c                	sd	a5,16(a1)
}
    80002920:	6422                	ld	s0,8(sp)
    80002922:	0141                	addi	sp,sp,16
    80002924:	8082                	ret

0000000080002926 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002926:	457c                	lw	a5,76(a0)
    80002928:	0ed7eb63          	bltu	a5,a3,80002a1e <readi+0xf8>
{
    8000292c:	7159                	addi	sp,sp,-112
    8000292e:	f486                	sd	ra,104(sp)
    80002930:	f0a2                	sd	s0,96(sp)
    80002932:	eca6                	sd	s1,88(sp)
    80002934:	e0d2                	sd	s4,64(sp)
    80002936:	fc56                	sd	s5,56(sp)
    80002938:	f85a                	sd	s6,48(sp)
    8000293a:	f45e                	sd	s7,40(sp)
    8000293c:	1880                	addi	s0,sp,112
    8000293e:	8b2a                	mv	s6,a0
    80002940:	8bae                	mv	s7,a1
    80002942:	8a32                	mv	s4,a2
    80002944:	84b6                	mv	s1,a3
    80002946:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002948:	9f35                	addw	a4,a4,a3
    return 0;
    8000294a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000294c:	0cd76063          	bltu	a4,a3,80002a0c <readi+0xe6>
    80002950:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002952:	00e7f463          	bgeu	a5,a4,8000295a <readi+0x34>
    n = ip->size - off;
    80002956:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000295a:	080a8f63          	beqz	s5,800029f8 <readi+0xd2>
    8000295e:	e8ca                	sd	s2,80(sp)
    80002960:	f062                	sd	s8,32(sp)
    80002962:	ec66                	sd	s9,24(sp)
    80002964:	e86a                	sd	s10,16(sp)
    80002966:	e46e                	sd	s11,8(sp)
    80002968:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000296a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000296e:	5c7d                	li	s8,-1
    80002970:	a80d                	j	800029a2 <readi+0x7c>
    80002972:	020d1d93          	slli	s11,s10,0x20
    80002976:	020ddd93          	srli	s11,s11,0x20
    8000297a:	05890613          	addi	a2,s2,88
    8000297e:	86ee                	mv	a3,s11
    80002980:	963a                	add	a2,a2,a4
    80002982:	85d2                	mv	a1,s4
    80002984:	855e                	mv	a0,s7
    80002986:	d07fe0ef          	jal	8000168c <either_copyout>
    8000298a:	05850763          	beq	a0,s8,800029d8 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000298e:	854a                	mv	a0,s2
    80002990:	f12ff0ef          	jal	800020a2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002994:	013d09bb          	addw	s3,s10,s3
    80002998:	009d04bb          	addw	s1,s10,s1
    8000299c:	9a6e                	add	s4,s4,s11
    8000299e:	0559f763          	bgeu	s3,s5,800029ec <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800029a2:	00a4d59b          	srliw	a1,s1,0xa
    800029a6:	855a                	mv	a0,s6
    800029a8:	977ff0ef          	jal	8000231e <bmap>
    800029ac:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800029b0:	c5b1                	beqz	a1,800029fc <readi+0xd6>
    bp = bread(ip->dev, addr);
    800029b2:	000b2503          	lw	a0,0(s6)
    800029b6:	de4ff0ef          	jal	80001f9a <bread>
    800029ba:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800029bc:	3ff4f713          	andi	a4,s1,1023
    800029c0:	40ec87bb          	subw	a5,s9,a4
    800029c4:	413a86bb          	subw	a3,s5,s3
    800029c8:	8d3e                	mv	s10,a5
    800029ca:	2781                	sext.w	a5,a5
    800029cc:	0006861b          	sext.w	a2,a3
    800029d0:	faf671e3          	bgeu	a2,a5,80002972 <readi+0x4c>
    800029d4:	8d36                	mv	s10,a3
    800029d6:	bf71                	j	80002972 <readi+0x4c>
      brelse(bp);
    800029d8:	854a                	mv	a0,s2
    800029da:	ec8ff0ef          	jal	800020a2 <brelse>
      tot = -1;
    800029de:	59fd                	li	s3,-1
      break;
    800029e0:	6946                	ld	s2,80(sp)
    800029e2:	7c02                	ld	s8,32(sp)
    800029e4:	6ce2                	ld	s9,24(sp)
    800029e6:	6d42                	ld	s10,16(sp)
    800029e8:	6da2                	ld	s11,8(sp)
    800029ea:	a831                	j	80002a06 <readi+0xe0>
    800029ec:	6946                	ld	s2,80(sp)
    800029ee:	7c02                	ld	s8,32(sp)
    800029f0:	6ce2                	ld	s9,24(sp)
    800029f2:	6d42                	ld	s10,16(sp)
    800029f4:	6da2                	ld	s11,8(sp)
    800029f6:	a801                	j	80002a06 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029f8:	89d6                	mv	s3,s5
    800029fa:	a031                	j	80002a06 <readi+0xe0>
    800029fc:	6946                	ld	s2,80(sp)
    800029fe:	7c02                	ld	s8,32(sp)
    80002a00:	6ce2                	ld	s9,24(sp)
    80002a02:	6d42                	ld	s10,16(sp)
    80002a04:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a06:	0009851b          	sext.w	a0,s3
    80002a0a:	69a6                	ld	s3,72(sp)
}
    80002a0c:	70a6                	ld	ra,104(sp)
    80002a0e:	7406                	ld	s0,96(sp)
    80002a10:	64e6                	ld	s1,88(sp)
    80002a12:	6a06                	ld	s4,64(sp)
    80002a14:	7ae2                	ld	s5,56(sp)
    80002a16:	7b42                	ld	s6,48(sp)
    80002a18:	7ba2                	ld	s7,40(sp)
    80002a1a:	6165                	addi	sp,sp,112
    80002a1c:	8082                	ret
    return 0;
    80002a1e:	4501                	li	a0,0
}
    80002a20:	8082                	ret

0000000080002a22 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a22:	457c                	lw	a5,76(a0)
    80002a24:	10d7e063          	bltu	a5,a3,80002b24 <writei+0x102>
{
    80002a28:	7159                	addi	sp,sp,-112
    80002a2a:	f486                	sd	ra,104(sp)
    80002a2c:	f0a2                	sd	s0,96(sp)
    80002a2e:	e8ca                	sd	s2,80(sp)
    80002a30:	e0d2                	sd	s4,64(sp)
    80002a32:	fc56                	sd	s5,56(sp)
    80002a34:	f85a                	sd	s6,48(sp)
    80002a36:	f45e                	sd	s7,40(sp)
    80002a38:	1880                	addi	s0,sp,112
    80002a3a:	8aaa                	mv	s5,a0
    80002a3c:	8bae                	mv	s7,a1
    80002a3e:	8a32                	mv	s4,a2
    80002a40:	8936                	mv	s2,a3
    80002a42:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002a44:	00e687bb          	addw	a5,a3,a4
    80002a48:	0ed7e063          	bltu	a5,a3,80002b28 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002a4c:	00043737          	lui	a4,0x43
    80002a50:	0cf76e63          	bltu	a4,a5,80002b2c <writei+0x10a>
    80002a54:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a56:	0a0b0f63          	beqz	s6,80002b14 <writei+0xf2>
    80002a5a:	eca6                	sd	s1,88(sp)
    80002a5c:	f062                	sd	s8,32(sp)
    80002a5e:	ec66                	sd	s9,24(sp)
    80002a60:	e86a                	sd	s10,16(sp)
    80002a62:	e46e                	sd	s11,8(sp)
    80002a64:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a66:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002a6a:	5c7d                	li	s8,-1
    80002a6c:	a825                	j	80002aa4 <writei+0x82>
    80002a6e:	020d1d93          	slli	s11,s10,0x20
    80002a72:	020ddd93          	srli	s11,s11,0x20
    80002a76:	05848513          	addi	a0,s1,88
    80002a7a:	86ee                	mv	a3,s11
    80002a7c:	8652                	mv	a2,s4
    80002a7e:	85de                	mv	a1,s7
    80002a80:	953a                	add	a0,a0,a4
    80002a82:	c55fe0ef          	jal	800016d6 <either_copyin>
    80002a86:	05850a63          	beq	a0,s8,80002ada <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002a8a:	8526                	mv	a0,s1
    80002a8c:	660000ef          	jal	800030ec <log_write>
    brelse(bp);
    80002a90:	8526                	mv	a0,s1
    80002a92:	e10ff0ef          	jal	800020a2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a96:	013d09bb          	addw	s3,s10,s3
    80002a9a:	012d093b          	addw	s2,s10,s2
    80002a9e:	9a6e                	add	s4,s4,s11
    80002aa0:	0569f063          	bgeu	s3,s6,80002ae0 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002aa4:	00a9559b          	srliw	a1,s2,0xa
    80002aa8:	8556                	mv	a0,s5
    80002aaa:	875ff0ef          	jal	8000231e <bmap>
    80002aae:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ab2:	c59d                	beqz	a1,80002ae0 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002ab4:	000aa503          	lw	a0,0(s5)
    80002ab8:	ce2ff0ef          	jal	80001f9a <bread>
    80002abc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002abe:	3ff97713          	andi	a4,s2,1023
    80002ac2:	40ec87bb          	subw	a5,s9,a4
    80002ac6:	413b06bb          	subw	a3,s6,s3
    80002aca:	8d3e                	mv	s10,a5
    80002acc:	2781                	sext.w	a5,a5
    80002ace:	0006861b          	sext.w	a2,a3
    80002ad2:	f8f67ee3          	bgeu	a2,a5,80002a6e <writei+0x4c>
    80002ad6:	8d36                	mv	s10,a3
    80002ad8:	bf59                	j	80002a6e <writei+0x4c>
      brelse(bp);
    80002ada:	8526                	mv	a0,s1
    80002adc:	dc6ff0ef          	jal	800020a2 <brelse>
  }

  if(off > ip->size)
    80002ae0:	04caa783          	lw	a5,76(s5)
    80002ae4:	0327fa63          	bgeu	a5,s2,80002b18 <writei+0xf6>
    ip->size = off;
    80002ae8:	052aa623          	sw	s2,76(s5)
    80002aec:	64e6                	ld	s1,88(sp)
    80002aee:	7c02                	ld	s8,32(sp)
    80002af0:	6ce2                	ld	s9,24(sp)
    80002af2:	6d42                	ld	s10,16(sp)
    80002af4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002af6:	8556                	mv	a0,s5
    80002af8:	b27ff0ef          	jal	8000261e <iupdate>

  return tot;
    80002afc:	0009851b          	sext.w	a0,s3
    80002b00:	69a6                	ld	s3,72(sp)
}
    80002b02:	70a6                	ld	ra,104(sp)
    80002b04:	7406                	ld	s0,96(sp)
    80002b06:	6946                	ld	s2,80(sp)
    80002b08:	6a06                	ld	s4,64(sp)
    80002b0a:	7ae2                	ld	s5,56(sp)
    80002b0c:	7b42                	ld	s6,48(sp)
    80002b0e:	7ba2                	ld	s7,40(sp)
    80002b10:	6165                	addi	sp,sp,112
    80002b12:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b14:	89da                	mv	s3,s6
    80002b16:	b7c5                	j	80002af6 <writei+0xd4>
    80002b18:	64e6                	ld	s1,88(sp)
    80002b1a:	7c02                	ld	s8,32(sp)
    80002b1c:	6ce2                	ld	s9,24(sp)
    80002b1e:	6d42                	ld	s10,16(sp)
    80002b20:	6da2                	ld	s11,8(sp)
    80002b22:	bfd1                	j	80002af6 <writei+0xd4>
    return -1;
    80002b24:	557d                	li	a0,-1
}
    80002b26:	8082                	ret
    return -1;
    80002b28:	557d                	li	a0,-1
    80002b2a:	bfe1                	j	80002b02 <writei+0xe0>
    return -1;
    80002b2c:	557d                	li	a0,-1
    80002b2e:	bfd1                	j	80002b02 <writei+0xe0>

0000000080002b30 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b30:	1141                	addi	sp,sp,-16
    80002b32:	e406                	sd	ra,8(sp)
    80002b34:	e022                	sd	s0,0(sp)
    80002b36:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b38:	4639                	li	a2,14
    80002b3a:	ec6fd0ef          	jal	80000200 <strncmp>
}
    80002b3e:	60a2                	ld	ra,8(sp)
    80002b40:	6402                	ld	s0,0(sp)
    80002b42:	0141                	addi	sp,sp,16
    80002b44:	8082                	ret

0000000080002b46 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002b46:	7139                	addi	sp,sp,-64
    80002b48:	fc06                	sd	ra,56(sp)
    80002b4a:	f822                	sd	s0,48(sp)
    80002b4c:	f426                	sd	s1,40(sp)
    80002b4e:	f04a                	sd	s2,32(sp)
    80002b50:	ec4e                	sd	s3,24(sp)
    80002b52:	e852                	sd	s4,16(sp)
    80002b54:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002b56:	04451703          	lh	a4,68(a0)
    80002b5a:	4785                	li	a5,1
    80002b5c:	00f71a63          	bne	a4,a5,80002b70 <dirlookup+0x2a>
    80002b60:	892a                	mv	s2,a0
    80002b62:	89ae                	mv	s3,a1
    80002b64:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b66:	457c                	lw	a5,76(a0)
    80002b68:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002b6a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b6c:	e39d                	bnez	a5,80002b92 <dirlookup+0x4c>
    80002b6e:	a095                	j	80002bd2 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002b70:	00005517          	auipc	a0,0x5
    80002b74:	a2850513          	addi	a0,a0,-1496 # 80007598 <etext+0x598>
    80002b78:	10b020ef          	jal	80005482 <panic>
      panic("dirlookup read");
    80002b7c:	00005517          	auipc	a0,0x5
    80002b80:	a3450513          	addi	a0,a0,-1484 # 800075b0 <etext+0x5b0>
    80002b84:	0ff020ef          	jal	80005482 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b88:	24c1                	addiw	s1,s1,16
    80002b8a:	04c92783          	lw	a5,76(s2)
    80002b8e:	04f4f163          	bgeu	s1,a5,80002bd0 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002b92:	4741                	li	a4,16
    80002b94:	86a6                	mv	a3,s1
    80002b96:	fc040613          	addi	a2,s0,-64
    80002b9a:	4581                	li	a1,0
    80002b9c:	854a                	mv	a0,s2
    80002b9e:	d89ff0ef          	jal	80002926 <readi>
    80002ba2:	47c1                	li	a5,16
    80002ba4:	fcf51ce3          	bne	a0,a5,80002b7c <dirlookup+0x36>
    if(de.inum == 0)
    80002ba8:	fc045783          	lhu	a5,-64(s0)
    80002bac:	dff1                	beqz	a5,80002b88 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002bae:	fc240593          	addi	a1,s0,-62
    80002bb2:	854e                	mv	a0,s3
    80002bb4:	f7dff0ef          	jal	80002b30 <namecmp>
    80002bb8:	f961                	bnez	a0,80002b88 <dirlookup+0x42>
      if(poff)
    80002bba:	000a0463          	beqz	s4,80002bc2 <dirlookup+0x7c>
        *poff = off;
    80002bbe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002bc2:	fc045583          	lhu	a1,-64(s0)
    80002bc6:	00092503          	lw	a0,0(s2)
    80002bca:	829ff0ef          	jal	800023f2 <iget>
    80002bce:	a011                	j	80002bd2 <dirlookup+0x8c>
  return 0;
    80002bd0:	4501                	li	a0,0
}
    80002bd2:	70e2                	ld	ra,56(sp)
    80002bd4:	7442                	ld	s0,48(sp)
    80002bd6:	74a2                	ld	s1,40(sp)
    80002bd8:	7902                	ld	s2,32(sp)
    80002bda:	69e2                	ld	s3,24(sp)
    80002bdc:	6a42                	ld	s4,16(sp)
    80002bde:	6121                	addi	sp,sp,64
    80002be0:	8082                	ret

0000000080002be2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002be2:	711d                	addi	sp,sp,-96
    80002be4:	ec86                	sd	ra,88(sp)
    80002be6:	e8a2                	sd	s0,80(sp)
    80002be8:	e4a6                	sd	s1,72(sp)
    80002bea:	e0ca                	sd	s2,64(sp)
    80002bec:	fc4e                	sd	s3,56(sp)
    80002bee:	f852                	sd	s4,48(sp)
    80002bf0:	f456                	sd	s5,40(sp)
    80002bf2:	f05a                	sd	s6,32(sp)
    80002bf4:	ec5e                	sd	s7,24(sp)
    80002bf6:	e862                	sd	s8,16(sp)
    80002bf8:	e466                	sd	s9,8(sp)
    80002bfa:	1080                	addi	s0,sp,96
    80002bfc:	84aa                	mv	s1,a0
    80002bfe:	8b2e                	mv	s6,a1
    80002c00:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c02:	00054703          	lbu	a4,0(a0)
    80002c06:	02f00793          	li	a5,47
    80002c0a:	00f70e63          	beq	a4,a5,80002c26 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c0e:	948fe0ef          	jal	80000d56 <myproc>
    80002c12:	15053503          	ld	a0,336(a0)
    80002c16:	a87ff0ef          	jal	8000269c <idup>
    80002c1a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002c1c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002c20:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c22:	4b85                	li	s7,1
    80002c24:	a871                	j	80002cc0 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002c26:	4585                	li	a1,1
    80002c28:	4505                	li	a0,1
    80002c2a:	fc8ff0ef          	jal	800023f2 <iget>
    80002c2e:	8a2a                	mv	s4,a0
    80002c30:	b7f5                	j	80002c1c <namex+0x3a>
      iunlockput(ip);
    80002c32:	8552                	mv	a0,s4
    80002c34:	ca9ff0ef          	jal	800028dc <iunlockput>
      return 0;
    80002c38:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002c3a:	8552                	mv	a0,s4
    80002c3c:	60e6                	ld	ra,88(sp)
    80002c3e:	6446                	ld	s0,80(sp)
    80002c40:	64a6                	ld	s1,72(sp)
    80002c42:	6906                	ld	s2,64(sp)
    80002c44:	79e2                	ld	s3,56(sp)
    80002c46:	7a42                	ld	s4,48(sp)
    80002c48:	7aa2                	ld	s5,40(sp)
    80002c4a:	7b02                	ld	s6,32(sp)
    80002c4c:	6be2                	ld	s7,24(sp)
    80002c4e:	6c42                	ld	s8,16(sp)
    80002c50:	6ca2                	ld	s9,8(sp)
    80002c52:	6125                	addi	sp,sp,96
    80002c54:	8082                	ret
      iunlock(ip);
    80002c56:	8552                	mv	a0,s4
    80002c58:	b29ff0ef          	jal	80002780 <iunlock>
      return ip;
    80002c5c:	bff9                	j	80002c3a <namex+0x58>
      iunlockput(ip);
    80002c5e:	8552                	mv	a0,s4
    80002c60:	c7dff0ef          	jal	800028dc <iunlockput>
      return 0;
    80002c64:	8a4e                	mv	s4,s3
    80002c66:	bfd1                	j	80002c3a <namex+0x58>
  len = path - s;
    80002c68:	40998633          	sub	a2,s3,s1
    80002c6c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002c70:	099c5063          	bge	s8,s9,80002cf0 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002c74:	4639                	li	a2,14
    80002c76:	85a6                	mv	a1,s1
    80002c78:	8556                	mv	a0,s5
    80002c7a:	d16fd0ef          	jal	80000190 <memmove>
    80002c7e:	84ce                	mv	s1,s3
  while(*path == '/')
    80002c80:	0004c783          	lbu	a5,0(s1)
    80002c84:	01279763          	bne	a5,s2,80002c92 <namex+0xb0>
    path++;
    80002c88:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c8a:	0004c783          	lbu	a5,0(s1)
    80002c8e:	ff278de3          	beq	a5,s2,80002c88 <namex+0xa6>
    ilock(ip);
    80002c92:	8552                	mv	a0,s4
    80002c94:	a3fff0ef          	jal	800026d2 <ilock>
    if(ip->type != T_DIR){
    80002c98:	044a1783          	lh	a5,68(s4)
    80002c9c:	f9779be3          	bne	a5,s7,80002c32 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002ca0:	000b0563          	beqz	s6,80002caa <namex+0xc8>
    80002ca4:	0004c783          	lbu	a5,0(s1)
    80002ca8:	d7dd                	beqz	a5,80002c56 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002caa:	4601                	li	a2,0
    80002cac:	85d6                	mv	a1,s5
    80002cae:	8552                	mv	a0,s4
    80002cb0:	e97ff0ef          	jal	80002b46 <dirlookup>
    80002cb4:	89aa                	mv	s3,a0
    80002cb6:	d545                	beqz	a0,80002c5e <namex+0x7c>
    iunlockput(ip);
    80002cb8:	8552                	mv	a0,s4
    80002cba:	c23ff0ef          	jal	800028dc <iunlockput>
    ip = next;
    80002cbe:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002cc0:	0004c783          	lbu	a5,0(s1)
    80002cc4:	01279763          	bne	a5,s2,80002cd2 <namex+0xf0>
    path++;
    80002cc8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002cca:	0004c783          	lbu	a5,0(s1)
    80002cce:	ff278de3          	beq	a5,s2,80002cc8 <namex+0xe6>
  if(*path == 0)
    80002cd2:	cb8d                	beqz	a5,80002d04 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002cd4:	0004c783          	lbu	a5,0(s1)
    80002cd8:	89a6                	mv	s3,s1
  len = path - s;
    80002cda:	4c81                	li	s9,0
    80002cdc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002cde:	01278963          	beq	a5,s2,80002cf0 <namex+0x10e>
    80002ce2:	d3d9                	beqz	a5,80002c68 <namex+0x86>
    path++;
    80002ce4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002ce6:	0009c783          	lbu	a5,0(s3)
    80002cea:	ff279ce3          	bne	a5,s2,80002ce2 <namex+0x100>
    80002cee:	bfad                	j	80002c68 <namex+0x86>
    memmove(name, s, len);
    80002cf0:	2601                	sext.w	a2,a2
    80002cf2:	85a6                	mv	a1,s1
    80002cf4:	8556                	mv	a0,s5
    80002cf6:	c9afd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    80002cfa:	9cd6                	add	s9,s9,s5
    80002cfc:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d00:	84ce                	mv	s1,s3
    80002d02:	bfbd                	j	80002c80 <namex+0x9e>
  if(nameiparent){
    80002d04:	f20b0be3          	beqz	s6,80002c3a <namex+0x58>
    iput(ip);
    80002d08:	8552                	mv	a0,s4
    80002d0a:	b4bff0ef          	jal	80002854 <iput>
    return 0;
    80002d0e:	4a01                	li	s4,0
    80002d10:	b72d                	j	80002c3a <namex+0x58>

0000000080002d12 <dirlink>:
{
    80002d12:	7139                	addi	sp,sp,-64
    80002d14:	fc06                	sd	ra,56(sp)
    80002d16:	f822                	sd	s0,48(sp)
    80002d18:	f04a                	sd	s2,32(sp)
    80002d1a:	ec4e                	sd	s3,24(sp)
    80002d1c:	e852                	sd	s4,16(sp)
    80002d1e:	0080                	addi	s0,sp,64
    80002d20:	892a                	mv	s2,a0
    80002d22:	8a2e                	mv	s4,a1
    80002d24:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d26:	4601                	li	a2,0
    80002d28:	e1fff0ef          	jal	80002b46 <dirlookup>
    80002d2c:	e535                	bnez	a0,80002d98 <dirlink+0x86>
    80002d2e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d30:	04c92483          	lw	s1,76(s2)
    80002d34:	c48d                	beqz	s1,80002d5e <dirlink+0x4c>
    80002d36:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d38:	4741                	li	a4,16
    80002d3a:	86a6                	mv	a3,s1
    80002d3c:	fc040613          	addi	a2,s0,-64
    80002d40:	4581                	li	a1,0
    80002d42:	854a                	mv	a0,s2
    80002d44:	be3ff0ef          	jal	80002926 <readi>
    80002d48:	47c1                	li	a5,16
    80002d4a:	04f51b63          	bne	a0,a5,80002da0 <dirlink+0x8e>
    if(de.inum == 0)
    80002d4e:	fc045783          	lhu	a5,-64(s0)
    80002d52:	c791                	beqz	a5,80002d5e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d54:	24c1                	addiw	s1,s1,16
    80002d56:	04c92783          	lw	a5,76(s2)
    80002d5a:	fcf4efe3          	bltu	s1,a5,80002d38 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002d5e:	4639                	li	a2,14
    80002d60:	85d2                	mv	a1,s4
    80002d62:	fc240513          	addi	a0,s0,-62
    80002d66:	cd0fd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    80002d6a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d6e:	4741                	li	a4,16
    80002d70:	86a6                	mv	a3,s1
    80002d72:	fc040613          	addi	a2,s0,-64
    80002d76:	4581                	li	a1,0
    80002d78:	854a                	mv	a0,s2
    80002d7a:	ca9ff0ef          	jal	80002a22 <writei>
    80002d7e:	1541                	addi	a0,a0,-16
    80002d80:	00a03533          	snez	a0,a0
    80002d84:	40a00533          	neg	a0,a0
    80002d88:	74a2                	ld	s1,40(sp)
}
    80002d8a:	70e2                	ld	ra,56(sp)
    80002d8c:	7442                	ld	s0,48(sp)
    80002d8e:	7902                	ld	s2,32(sp)
    80002d90:	69e2                	ld	s3,24(sp)
    80002d92:	6a42                	ld	s4,16(sp)
    80002d94:	6121                	addi	sp,sp,64
    80002d96:	8082                	ret
    iput(ip);
    80002d98:	abdff0ef          	jal	80002854 <iput>
    return -1;
    80002d9c:	557d                	li	a0,-1
    80002d9e:	b7f5                	j	80002d8a <dirlink+0x78>
      panic("dirlink read");
    80002da0:	00005517          	auipc	a0,0x5
    80002da4:	82050513          	addi	a0,a0,-2016 # 800075c0 <etext+0x5c0>
    80002da8:	6da020ef          	jal	80005482 <panic>

0000000080002dac <namei>:

struct inode*
namei(char *path)
{
    80002dac:	1101                	addi	sp,sp,-32
    80002dae:	ec06                	sd	ra,24(sp)
    80002db0:	e822                	sd	s0,16(sp)
    80002db2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002db4:	fe040613          	addi	a2,s0,-32
    80002db8:	4581                	li	a1,0
    80002dba:	e29ff0ef          	jal	80002be2 <namex>
}
    80002dbe:	60e2                	ld	ra,24(sp)
    80002dc0:	6442                	ld	s0,16(sp)
    80002dc2:	6105                	addi	sp,sp,32
    80002dc4:	8082                	ret

0000000080002dc6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002dc6:	1141                	addi	sp,sp,-16
    80002dc8:	e406                	sd	ra,8(sp)
    80002dca:	e022                	sd	s0,0(sp)
    80002dcc:	0800                	addi	s0,sp,16
    80002dce:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002dd0:	4585                	li	a1,1
    80002dd2:	e11ff0ef          	jal	80002be2 <namex>
}
    80002dd6:	60a2                	ld	ra,8(sp)
    80002dd8:	6402                	ld	s0,0(sp)
    80002dda:	0141                	addi	sp,sp,16
    80002ddc:	8082                	ret

0000000080002dde <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002dde:	1101                	addi	sp,sp,-32
    80002de0:	ec06                	sd	ra,24(sp)
    80002de2:	e822                	sd	s0,16(sp)
    80002de4:	e426                	sd	s1,8(sp)
    80002de6:	e04a                	sd	s2,0(sp)
    80002de8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002dea:	00017917          	auipc	s2,0x17
    80002dee:	7f690913          	addi	s2,s2,2038 # 8001a5e0 <log>
    80002df2:	01892583          	lw	a1,24(s2)
    80002df6:	02892503          	lw	a0,40(s2)
    80002dfa:	9a0ff0ef          	jal	80001f9a <bread>
    80002dfe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e00:	02c92603          	lw	a2,44(s2)
    80002e04:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e06:	00c05f63          	blez	a2,80002e24 <write_head+0x46>
    80002e0a:	00018717          	auipc	a4,0x18
    80002e0e:	80670713          	addi	a4,a4,-2042 # 8001a610 <log+0x30>
    80002e12:	87aa                	mv	a5,a0
    80002e14:	060a                	slli	a2,a2,0x2
    80002e16:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002e18:	4314                	lw	a3,0(a4)
    80002e1a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002e1c:	0711                	addi	a4,a4,4
    80002e1e:	0791                	addi	a5,a5,4
    80002e20:	fec79ce3          	bne	a5,a2,80002e18 <write_head+0x3a>
  }
  bwrite(buf);
    80002e24:	8526                	mv	a0,s1
    80002e26:	a4aff0ef          	jal	80002070 <bwrite>
  brelse(buf);
    80002e2a:	8526                	mv	a0,s1
    80002e2c:	a76ff0ef          	jal	800020a2 <brelse>
}
    80002e30:	60e2                	ld	ra,24(sp)
    80002e32:	6442                	ld	s0,16(sp)
    80002e34:	64a2                	ld	s1,8(sp)
    80002e36:	6902                	ld	s2,0(sp)
    80002e38:	6105                	addi	sp,sp,32
    80002e3a:	8082                	ret

0000000080002e3c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e3c:	00017797          	auipc	a5,0x17
    80002e40:	7d07a783          	lw	a5,2000(a5) # 8001a60c <log+0x2c>
    80002e44:	08f05f63          	blez	a5,80002ee2 <install_trans+0xa6>
{
    80002e48:	7139                	addi	sp,sp,-64
    80002e4a:	fc06                	sd	ra,56(sp)
    80002e4c:	f822                	sd	s0,48(sp)
    80002e4e:	f426                	sd	s1,40(sp)
    80002e50:	f04a                	sd	s2,32(sp)
    80002e52:	ec4e                	sd	s3,24(sp)
    80002e54:	e852                	sd	s4,16(sp)
    80002e56:	e456                	sd	s5,8(sp)
    80002e58:	e05a                	sd	s6,0(sp)
    80002e5a:	0080                	addi	s0,sp,64
    80002e5c:	8b2a                	mv	s6,a0
    80002e5e:	00017a97          	auipc	s5,0x17
    80002e62:	7b2a8a93          	addi	s5,s5,1970 # 8001a610 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e66:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002e68:	00017997          	auipc	s3,0x17
    80002e6c:	77898993          	addi	s3,s3,1912 # 8001a5e0 <log>
    80002e70:	a829                	j	80002e8a <install_trans+0x4e>
    brelse(lbuf);
    80002e72:	854a                	mv	a0,s2
    80002e74:	a2eff0ef          	jal	800020a2 <brelse>
    brelse(dbuf);
    80002e78:	8526                	mv	a0,s1
    80002e7a:	a28ff0ef          	jal	800020a2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e7e:	2a05                	addiw	s4,s4,1
    80002e80:	0a91                	addi	s5,s5,4
    80002e82:	02c9a783          	lw	a5,44(s3)
    80002e86:	04fa5463          	bge	s4,a5,80002ece <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002e8a:	0189a583          	lw	a1,24(s3)
    80002e8e:	014585bb          	addw	a1,a1,s4
    80002e92:	2585                	addiw	a1,a1,1
    80002e94:	0289a503          	lw	a0,40(s3)
    80002e98:	902ff0ef          	jal	80001f9a <bread>
    80002e9c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002e9e:	000aa583          	lw	a1,0(s5)
    80002ea2:	0289a503          	lw	a0,40(s3)
    80002ea6:	8f4ff0ef          	jal	80001f9a <bread>
    80002eaa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002eac:	40000613          	li	a2,1024
    80002eb0:	05890593          	addi	a1,s2,88
    80002eb4:	05850513          	addi	a0,a0,88
    80002eb8:	ad8fd0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002ebc:	8526                	mv	a0,s1
    80002ebe:	9b2ff0ef          	jal	80002070 <bwrite>
    if(recovering == 0)
    80002ec2:	fa0b18e3          	bnez	s6,80002e72 <install_trans+0x36>
      bunpin(dbuf);
    80002ec6:	8526                	mv	a0,s1
    80002ec8:	a96ff0ef          	jal	8000215e <bunpin>
    80002ecc:	b75d                	j	80002e72 <install_trans+0x36>
}
    80002ece:	70e2                	ld	ra,56(sp)
    80002ed0:	7442                	ld	s0,48(sp)
    80002ed2:	74a2                	ld	s1,40(sp)
    80002ed4:	7902                	ld	s2,32(sp)
    80002ed6:	69e2                	ld	s3,24(sp)
    80002ed8:	6a42                	ld	s4,16(sp)
    80002eda:	6aa2                	ld	s5,8(sp)
    80002edc:	6b02                	ld	s6,0(sp)
    80002ede:	6121                	addi	sp,sp,64
    80002ee0:	8082                	ret
    80002ee2:	8082                	ret

0000000080002ee4 <initlog>:
{
    80002ee4:	7179                	addi	sp,sp,-48
    80002ee6:	f406                	sd	ra,40(sp)
    80002ee8:	f022                	sd	s0,32(sp)
    80002eea:	ec26                	sd	s1,24(sp)
    80002eec:	e84a                	sd	s2,16(sp)
    80002eee:	e44e                	sd	s3,8(sp)
    80002ef0:	1800                	addi	s0,sp,48
    80002ef2:	892a                	mv	s2,a0
    80002ef4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002ef6:	00017497          	auipc	s1,0x17
    80002efa:	6ea48493          	addi	s1,s1,1770 # 8001a5e0 <log>
    80002efe:	00004597          	auipc	a1,0x4
    80002f02:	6d258593          	addi	a1,a1,1746 # 800075d0 <etext+0x5d0>
    80002f06:	8526                	mv	a0,s1
    80002f08:	029020ef          	jal	80005730 <initlock>
  log.start = sb->logstart;
    80002f0c:	0149a583          	lw	a1,20(s3)
    80002f10:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f12:	0109a783          	lw	a5,16(s3)
    80002f16:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002f18:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f1c:	854a                	mv	a0,s2
    80002f1e:	87cff0ef          	jal	80001f9a <bread>
  log.lh.n = lh->n;
    80002f22:	4d30                	lw	a2,88(a0)
    80002f24:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002f26:	00c05f63          	blez	a2,80002f44 <initlog+0x60>
    80002f2a:	87aa                	mv	a5,a0
    80002f2c:	00017717          	auipc	a4,0x17
    80002f30:	6e470713          	addi	a4,a4,1764 # 8001a610 <log+0x30>
    80002f34:	060a                	slli	a2,a2,0x2
    80002f36:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002f38:	4ff4                	lw	a3,92(a5)
    80002f3a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002f3c:	0791                	addi	a5,a5,4
    80002f3e:	0711                	addi	a4,a4,4
    80002f40:	fec79ce3          	bne	a5,a2,80002f38 <initlog+0x54>
  brelse(buf);
    80002f44:	95eff0ef          	jal	800020a2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002f48:	4505                	li	a0,1
    80002f4a:	ef3ff0ef          	jal	80002e3c <install_trans>
  log.lh.n = 0;
    80002f4e:	00017797          	auipc	a5,0x17
    80002f52:	6a07af23          	sw	zero,1726(a5) # 8001a60c <log+0x2c>
  write_head(); // clear the log
    80002f56:	e89ff0ef          	jal	80002dde <write_head>
}
    80002f5a:	70a2                	ld	ra,40(sp)
    80002f5c:	7402                	ld	s0,32(sp)
    80002f5e:	64e2                	ld	s1,24(sp)
    80002f60:	6942                	ld	s2,16(sp)
    80002f62:	69a2                	ld	s3,8(sp)
    80002f64:	6145                	addi	sp,sp,48
    80002f66:	8082                	ret

0000000080002f68 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002f68:	1101                	addi	sp,sp,-32
    80002f6a:	ec06                	sd	ra,24(sp)
    80002f6c:	e822                	sd	s0,16(sp)
    80002f6e:	e426                	sd	s1,8(sp)
    80002f70:	e04a                	sd	s2,0(sp)
    80002f72:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002f74:	00017517          	auipc	a0,0x17
    80002f78:	66c50513          	addi	a0,a0,1644 # 8001a5e0 <log>
    80002f7c:	035020ef          	jal	800057b0 <acquire>
  while(1){
    if(log.committing){
    80002f80:	00017497          	auipc	s1,0x17
    80002f84:	66048493          	addi	s1,s1,1632 # 8001a5e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002f88:	4979                	li	s2,30
    80002f8a:	a029                	j	80002f94 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002f8c:	85a6                	mv	a1,s1
    80002f8e:	8526                	mv	a0,s1
    80002f90:	ba0fe0ef          	jal	80001330 <sleep>
    if(log.committing){
    80002f94:	50dc                	lw	a5,36(s1)
    80002f96:	fbfd                	bnez	a5,80002f8c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002f98:	5098                	lw	a4,32(s1)
    80002f9a:	2705                	addiw	a4,a4,1
    80002f9c:	0027179b          	slliw	a5,a4,0x2
    80002fa0:	9fb9                	addw	a5,a5,a4
    80002fa2:	0017979b          	slliw	a5,a5,0x1
    80002fa6:	54d4                	lw	a3,44(s1)
    80002fa8:	9fb5                	addw	a5,a5,a3
    80002faa:	00f95763          	bge	s2,a5,80002fb8 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002fae:	85a6                	mv	a1,s1
    80002fb0:	8526                	mv	a0,s1
    80002fb2:	b7efe0ef          	jal	80001330 <sleep>
    80002fb6:	bff9                	j	80002f94 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002fb8:	00017517          	auipc	a0,0x17
    80002fbc:	62850513          	addi	a0,a0,1576 # 8001a5e0 <log>
    80002fc0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002fc2:	087020ef          	jal	80005848 <release>
      break;
    }
  }
}
    80002fc6:	60e2                	ld	ra,24(sp)
    80002fc8:	6442                	ld	s0,16(sp)
    80002fca:	64a2                	ld	s1,8(sp)
    80002fcc:	6902                	ld	s2,0(sp)
    80002fce:	6105                	addi	sp,sp,32
    80002fd0:	8082                	ret

0000000080002fd2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002fd2:	7139                	addi	sp,sp,-64
    80002fd4:	fc06                	sd	ra,56(sp)
    80002fd6:	f822                	sd	s0,48(sp)
    80002fd8:	f426                	sd	s1,40(sp)
    80002fda:	f04a                	sd	s2,32(sp)
    80002fdc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002fde:	00017497          	auipc	s1,0x17
    80002fe2:	60248493          	addi	s1,s1,1538 # 8001a5e0 <log>
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	7c8020ef          	jal	800057b0 <acquire>
  log.outstanding -= 1;
    80002fec:	509c                	lw	a5,32(s1)
    80002fee:	37fd                	addiw	a5,a5,-1
    80002ff0:	0007891b          	sext.w	s2,a5
    80002ff4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002ff6:	50dc                	lw	a5,36(s1)
    80002ff8:	ef9d                	bnez	a5,80003036 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80002ffa:	04091763          	bnez	s2,80003048 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002ffe:	00017497          	auipc	s1,0x17
    80003002:	5e248493          	addi	s1,s1,1506 # 8001a5e0 <log>
    80003006:	4785                	li	a5,1
    80003008:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000300a:	8526                	mv	a0,s1
    8000300c:	03d020ef          	jal	80005848 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003010:	54dc                	lw	a5,44(s1)
    80003012:	04f04b63          	bgtz	a5,80003068 <end_op+0x96>
    acquire(&log.lock);
    80003016:	00017497          	auipc	s1,0x17
    8000301a:	5ca48493          	addi	s1,s1,1482 # 8001a5e0 <log>
    8000301e:	8526                	mv	a0,s1
    80003020:	790020ef          	jal	800057b0 <acquire>
    log.committing = 0;
    80003024:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003028:	8526                	mv	a0,s1
    8000302a:	b52fe0ef          	jal	8000137c <wakeup>
    release(&log.lock);
    8000302e:	8526                	mv	a0,s1
    80003030:	019020ef          	jal	80005848 <release>
}
    80003034:	a025                	j	8000305c <end_op+0x8a>
    80003036:	ec4e                	sd	s3,24(sp)
    80003038:	e852                	sd	s4,16(sp)
    8000303a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000303c:	00004517          	auipc	a0,0x4
    80003040:	59c50513          	addi	a0,a0,1436 # 800075d8 <etext+0x5d8>
    80003044:	43e020ef          	jal	80005482 <panic>
    wakeup(&log);
    80003048:	00017497          	auipc	s1,0x17
    8000304c:	59848493          	addi	s1,s1,1432 # 8001a5e0 <log>
    80003050:	8526                	mv	a0,s1
    80003052:	b2afe0ef          	jal	8000137c <wakeup>
  release(&log.lock);
    80003056:	8526                	mv	a0,s1
    80003058:	7f0020ef          	jal	80005848 <release>
}
    8000305c:	70e2                	ld	ra,56(sp)
    8000305e:	7442                	ld	s0,48(sp)
    80003060:	74a2                	ld	s1,40(sp)
    80003062:	7902                	ld	s2,32(sp)
    80003064:	6121                	addi	sp,sp,64
    80003066:	8082                	ret
    80003068:	ec4e                	sd	s3,24(sp)
    8000306a:	e852                	sd	s4,16(sp)
    8000306c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000306e:	00017a97          	auipc	s5,0x17
    80003072:	5a2a8a93          	addi	s5,s5,1442 # 8001a610 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003076:	00017a17          	auipc	s4,0x17
    8000307a:	56aa0a13          	addi	s4,s4,1386 # 8001a5e0 <log>
    8000307e:	018a2583          	lw	a1,24(s4)
    80003082:	012585bb          	addw	a1,a1,s2
    80003086:	2585                	addiw	a1,a1,1
    80003088:	028a2503          	lw	a0,40(s4)
    8000308c:	f0ffe0ef          	jal	80001f9a <bread>
    80003090:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003092:	000aa583          	lw	a1,0(s5)
    80003096:	028a2503          	lw	a0,40(s4)
    8000309a:	f01fe0ef          	jal	80001f9a <bread>
    8000309e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800030a0:	40000613          	li	a2,1024
    800030a4:	05850593          	addi	a1,a0,88
    800030a8:	05848513          	addi	a0,s1,88
    800030ac:	8e4fd0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    800030b0:	8526                	mv	a0,s1
    800030b2:	fbffe0ef          	jal	80002070 <bwrite>
    brelse(from);
    800030b6:	854e                	mv	a0,s3
    800030b8:	febfe0ef          	jal	800020a2 <brelse>
    brelse(to);
    800030bc:	8526                	mv	a0,s1
    800030be:	fe5fe0ef          	jal	800020a2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030c2:	2905                	addiw	s2,s2,1
    800030c4:	0a91                	addi	s5,s5,4
    800030c6:	02ca2783          	lw	a5,44(s4)
    800030ca:	faf94ae3          	blt	s2,a5,8000307e <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800030ce:	d11ff0ef          	jal	80002dde <write_head>
    install_trans(0); // Now install writes to home locations
    800030d2:	4501                	li	a0,0
    800030d4:	d69ff0ef          	jal	80002e3c <install_trans>
    log.lh.n = 0;
    800030d8:	00017797          	auipc	a5,0x17
    800030dc:	5207aa23          	sw	zero,1332(a5) # 8001a60c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800030e0:	cffff0ef          	jal	80002dde <write_head>
    800030e4:	69e2                	ld	s3,24(sp)
    800030e6:	6a42                	ld	s4,16(sp)
    800030e8:	6aa2                	ld	s5,8(sp)
    800030ea:	b735                	j	80003016 <end_op+0x44>

00000000800030ec <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800030ec:	1101                	addi	sp,sp,-32
    800030ee:	ec06                	sd	ra,24(sp)
    800030f0:	e822                	sd	s0,16(sp)
    800030f2:	e426                	sd	s1,8(sp)
    800030f4:	e04a                	sd	s2,0(sp)
    800030f6:	1000                	addi	s0,sp,32
    800030f8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800030fa:	00017917          	auipc	s2,0x17
    800030fe:	4e690913          	addi	s2,s2,1254 # 8001a5e0 <log>
    80003102:	854a                	mv	a0,s2
    80003104:	6ac020ef          	jal	800057b0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003108:	02c92603          	lw	a2,44(s2)
    8000310c:	47f5                	li	a5,29
    8000310e:	06c7c363          	blt	a5,a2,80003174 <log_write+0x88>
    80003112:	00017797          	auipc	a5,0x17
    80003116:	4ea7a783          	lw	a5,1258(a5) # 8001a5fc <log+0x1c>
    8000311a:	37fd                	addiw	a5,a5,-1
    8000311c:	04f65c63          	bge	a2,a5,80003174 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003120:	00017797          	auipc	a5,0x17
    80003124:	4e07a783          	lw	a5,1248(a5) # 8001a600 <log+0x20>
    80003128:	04f05c63          	blez	a5,80003180 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000312c:	4781                	li	a5,0
    8000312e:	04c05f63          	blez	a2,8000318c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003132:	44cc                	lw	a1,12(s1)
    80003134:	00017717          	auipc	a4,0x17
    80003138:	4dc70713          	addi	a4,a4,1244 # 8001a610 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000313c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000313e:	4314                	lw	a3,0(a4)
    80003140:	04b68663          	beq	a3,a1,8000318c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003144:	2785                	addiw	a5,a5,1
    80003146:	0711                	addi	a4,a4,4
    80003148:	fef61be3          	bne	a2,a5,8000313e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000314c:	0621                	addi	a2,a2,8
    8000314e:	060a                	slli	a2,a2,0x2
    80003150:	00017797          	auipc	a5,0x17
    80003154:	49078793          	addi	a5,a5,1168 # 8001a5e0 <log>
    80003158:	97b2                	add	a5,a5,a2
    8000315a:	44d8                	lw	a4,12(s1)
    8000315c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000315e:	8526                	mv	a0,s1
    80003160:	fcbfe0ef          	jal	8000212a <bpin>
    log.lh.n++;
    80003164:	00017717          	auipc	a4,0x17
    80003168:	47c70713          	addi	a4,a4,1148 # 8001a5e0 <log>
    8000316c:	575c                	lw	a5,44(a4)
    8000316e:	2785                	addiw	a5,a5,1
    80003170:	d75c                	sw	a5,44(a4)
    80003172:	a80d                	j	800031a4 <log_write+0xb8>
    panic("too big a transaction");
    80003174:	00004517          	auipc	a0,0x4
    80003178:	47450513          	addi	a0,a0,1140 # 800075e8 <etext+0x5e8>
    8000317c:	306020ef          	jal	80005482 <panic>
    panic("log_write outside of trans");
    80003180:	00004517          	auipc	a0,0x4
    80003184:	48050513          	addi	a0,a0,1152 # 80007600 <etext+0x600>
    80003188:	2fa020ef          	jal	80005482 <panic>
  log.lh.block[i] = b->blockno;
    8000318c:	00878693          	addi	a3,a5,8
    80003190:	068a                	slli	a3,a3,0x2
    80003192:	00017717          	auipc	a4,0x17
    80003196:	44e70713          	addi	a4,a4,1102 # 8001a5e0 <log>
    8000319a:	9736                	add	a4,a4,a3
    8000319c:	44d4                	lw	a3,12(s1)
    8000319e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800031a0:	faf60fe3          	beq	a2,a5,8000315e <log_write+0x72>
  }
  release(&log.lock);
    800031a4:	00017517          	auipc	a0,0x17
    800031a8:	43c50513          	addi	a0,a0,1084 # 8001a5e0 <log>
    800031ac:	69c020ef          	jal	80005848 <release>
}
    800031b0:	60e2                	ld	ra,24(sp)
    800031b2:	6442                	ld	s0,16(sp)
    800031b4:	64a2                	ld	s1,8(sp)
    800031b6:	6902                	ld	s2,0(sp)
    800031b8:	6105                	addi	sp,sp,32
    800031ba:	8082                	ret

00000000800031bc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800031bc:	1101                	addi	sp,sp,-32
    800031be:	ec06                	sd	ra,24(sp)
    800031c0:	e822                	sd	s0,16(sp)
    800031c2:	e426                	sd	s1,8(sp)
    800031c4:	e04a                	sd	s2,0(sp)
    800031c6:	1000                	addi	s0,sp,32
    800031c8:	84aa                	mv	s1,a0
    800031ca:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800031cc:	00004597          	auipc	a1,0x4
    800031d0:	45458593          	addi	a1,a1,1108 # 80007620 <etext+0x620>
    800031d4:	0521                	addi	a0,a0,8
    800031d6:	55a020ef          	jal	80005730 <initlock>
  lk->name = name;
    800031da:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800031de:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031e2:	0204a423          	sw	zero,40(s1)
}
    800031e6:	60e2                	ld	ra,24(sp)
    800031e8:	6442                	ld	s0,16(sp)
    800031ea:	64a2                	ld	s1,8(sp)
    800031ec:	6902                	ld	s2,0(sp)
    800031ee:	6105                	addi	sp,sp,32
    800031f0:	8082                	ret

00000000800031f2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800031f2:	1101                	addi	sp,sp,-32
    800031f4:	ec06                	sd	ra,24(sp)
    800031f6:	e822                	sd	s0,16(sp)
    800031f8:	e426                	sd	s1,8(sp)
    800031fa:	e04a                	sd	s2,0(sp)
    800031fc:	1000                	addi	s0,sp,32
    800031fe:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003200:	00850913          	addi	s2,a0,8
    80003204:	854a                	mv	a0,s2
    80003206:	5aa020ef          	jal	800057b0 <acquire>
  while (lk->locked) {
    8000320a:	409c                	lw	a5,0(s1)
    8000320c:	c799                	beqz	a5,8000321a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000320e:	85ca                	mv	a1,s2
    80003210:	8526                	mv	a0,s1
    80003212:	91efe0ef          	jal	80001330 <sleep>
  while (lk->locked) {
    80003216:	409c                	lw	a5,0(s1)
    80003218:	fbfd                	bnez	a5,8000320e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000321a:	4785                	li	a5,1
    8000321c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000321e:	b39fd0ef          	jal	80000d56 <myproc>
    80003222:	591c                	lw	a5,48(a0)
    80003224:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003226:	854a                	mv	a0,s2
    80003228:	620020ef          	jal	80005848 <release>
}
    8000322c:	60e2                	ld	ra,24(sp)
    8000322e:	6442                	ld	s0,16(sp)
    80003230:	64a2                	ld	s1,8(sp)
    80003232:	6902                	ld	s2,0(sp)
    80003234:	6105                	addi	sp,sp,32
    80003236:	8082                	ret

0000000080003238 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003238:	1101                	addi	sp,sp,-32
    8000323a:	ec06                	sd	ra,24(sp)
    8000323c:	e822                	sd	s0,16(sp)
    8000323e:	e426                	sd	s1,8(sp)
    80003240:	e04a                	sd	s2,0(sp)
    80003242:	1000                	addi	s0,sp,32
    80003244:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003246:	00850913          	addi	s2,a0,8
    8000324a:	854a                	mv	a0,s2
    8000324c:	564020ef          	jal	800057b0 <acquire>
  lk->locked = 0;
    80003250:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003254:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003258:	8526                	mv	a0,s1
    8000325a:	922fe0ef          	jal	8000137c <wakeup>
  release(&lk->lk);
    8000325e:	854a                	mv	a0,s2
    80003260:	5e8020ef          	jal	80005848 <release>
}
    80003264:	60e2                	ld	ra,24(sp)
    80003266:	6442                	ld	s0,16(sp)
    80003268:	64a2                	ld	s1,8(sp)
    8000326a:	6902                	ld	s2,0(sp)
    8000326c:	6105                	addi	sp,sp,32
    8000326e:	8082                	ret

0000000080003270 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003270:	7179                	addi	sp,sp,-48
    80003272:	f406                	sd	ra,40(sp)
    80003274:	f022                	sd	s0,32(sp)
    80003276:	ec26                	sd	s1,24(sp)
    80003278:	e84a                	sd	s2,16(sp)
    8000327a:	1800                	addi	s0,sp,48
    8000327c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000327e:	00850913          	addi	s2,a0,8
    80003282:	854a                	mv	a0,s2
    80003284:	52c020ef          	jal	800057b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003288:	409c                	lw	a5,0(s1)
    8000328a:	ef81                	bnez	a5,800032a2 <holdingsleep+0x32>
    8000328c:	4481                	li	s1,0
  release(&lk->lk);
    8000328e:	854a                	mv	a0,s2
    80003290:	5b8020ef          	jal	80005848 <release>
  return r;
}
    80003294:	8526                	mv	a0,s1
    80003296:	70a2                	ld	ra,40(sp)
    80003298:	7402                	ld	s0,32(sp)
    8000329a:	64e2                	ld	s1,24(sp)
    8000329c:	6942                	ld	s2,16(sp)
    8000329e:	6145                	addi	sp,sp,48
    800032a0:	8082                	ret
    800032a2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800032a4:	0284a983          	lw	s3,40(s1)
    800032a8:	aaffd0ef          	jal	80000d56 <myproc>
    800032ac:	5904                	lw	s1,48(a0)
    800032ae:	413484b3          	sub	s1,s1,s3
    800032b2:	0014b493          	seqz	s1,s1
    800032b6:	69a2                	ld	s3,8(sp)
    800032b8:	bfd9                	j	8000328e <holdingsleep+0x1e>

00000000800032ba <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800032ba:	1141                	addi	sp,sp,-16
    800032bc:	e406                	sd	ra,8(sp)
    800032be:	e022                	sd	s0,0(sp)
    800032c0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800032c2:	00004597          	auipc	a1,0x4
    800032c6:	36e58593          	addi	a1,a1,878 # 80007630 <etext+0x630>
    800032ca:	00017517          	auipc	a0,0x17
    800032ce:	45e50513          	addi	a0,a0,1118 # 8001a728 <ftable>
    800032d2:	45e020ef          	jal	80005730 <initlock>
}
    800032d6:	60a2                	ld	ra,8(sp)
    800032d8:	6402                	ld	s0,0(sp)
    800032da:	0141                	addi	sp,sp,16
    800032dc:	8082                	ret

00000000800032de <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800032de:	1101                	addi	sp,sp,-32
    800032e0:	ec06                	sd	ra,24(sp)
    800032e2:	e822                	sd	s0,16(sp)
    800032e4:	e426                	sd	s1,8(sp)
    800032e6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800032e8:	00017517          	auipc	a0,0x17
    800032ec:	44050513          	addi	a0,a0,1088 # 8001a728 <ftable>
    800032f0:	4c0020ef          	jal	800057b0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800032f4:	00017497          	auipc	s1,0x17
    800032f8:	44c48493          	addi	s1,s1,1100 # 8001a740 <ftable+0x18>
    800032fc:	00018717          	auipc	a4,0x18
    80003300:	3e470713          	addi	a4,a4,996 # 8001b6e0 <disk>
    if(f->ref == 0){
    80003304:	40dc                	lw	a5,4(s1)
    80003306:	cf89                	beqz	a5,80003320 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003308:	02848493          	addi	s1,s1,40
    8000330c:	fee49ce3          	bne	s1,a4,80003304 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003310:	00017517          	auipc	a0,0x17
    80003314:	41850513          	addi	a0,a0,1048 # 8001a728 <ftable>
    80003318:	530020ef          	jal	80005848 <release>
  return 0;
    8000331c:	4481                	li	s1,0
    8000331e:	a809                	j	80003330 <filealloc+0x52>
      f->ref = 1;
    80003320:	4785                	li	a5,1
    80003322:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003324:	00017517          	auipc	a0,0x17
    80003328:	40450513          	addi	a0,a0,1028 # 8001a728 <ftable>
    8000332c:	51c020ef          	jal	80005848 <release>
}
    80003330:	8526                	mv	a0,s1
    80003332:	60e2                	ld	ra,24(sp)
    80003334:	6442                	ld	s0,16(sp)
    80003336:	64a2                	ld	s1,8(sp)
    80003338:	6105                	addi	sp,sp,32
    8000333a:	8082                	ret

000000008000333c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000333c:	1101                	addi	sp,sp,-32
    8000333e:	ec06                	sd	ra,24(sp)
    80003340:	e822                	sd	s0,16(sp)
    80003342:	e426                	sd	s1,8(sp)
    80003344:	1000                	addi	s0,sp,32
    80003346:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003348:	00017517          	auipc	a0,0x17
    8000334c:	3e050513          	addi	a0,a0,992 # 8001a728 <ftable>
    80003350:	460020ef          	jal	800057b0 <acquire>
  if(f->ref < 1)
    80003354:	40dc                	lw	a5,4(s1)
    80003356:	02f05063          	blez	a5,80003376 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000335a:	2785                	addiw	a5,a5,1
    8000335c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000335e:	00017517          	auipc	a0,0x17
    80003362:	3ca50513          	addi	a0,a0,970 # 8001a728 <ftable>
    80003366:	4e2020ef          	jal	80005848 <release>
  return f;
}
    8000336a:	8526                	mv	a0,s1
    8000336c:	60e2                	ld	ra,24(sp)
    8000336e:	6442                	ld	s0,16(sp)
    80003370:	64a2                	ld	s1,8(sp)
    80003372:	6105                	addi	sp,sp,32
    80003374:	8082                	ret
    panic("filedup");
    80003376:	00004517          	auipc	a0,0x4
    8000337a:	2c250513          	addi	a0,a0,706 # 80007638 <etext+0x638>
    8000337e:	104020ef          	jal	80005482 <panic>

0000000080003382 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003382:	7139                	addi	sp,sp,-64
    80003384:	fc06                	sd	ra,56(sp)
    80003386:	f822                	sd	s0,48(sp)
    80003388:	f426                	sd	s1,40(sp)
    8000338a:	0080                	addi	s0,sp,64
    8000338c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000338e:	00017517          	auipc	a0,0x17
    80003392:	39a50513          	addi	a0,a0,922 # 8001a728 <ftable>
    80003396:	41a020ef          	jal	800057b0 <acquire>
  if(f->ref < 1)
    8000339a:	40dc                	lw	a5,4(s1)
    8000339c:	04f05a63          	blez	a5,800033f0 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800033a0:	37fd                	addiw	a5,a5,-1
    800033a2:	0007871b          	sext.w	a4,a5
    800033a6:	c0dc                	sw	a5,4(s1)
    800033a8:	04e04e63          	bgtz	a4,80003404 <fileclose+0x82>
    800033ac:	f04a                	sd	s2,32(sp)
    800033ae:	ec4e                	sd	s3,24(sp)
    800033b0:	e852                	sd	s4,16(sp)
    800033b2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800033b4:	0004a903          	lw	s2,0(s1)
    800033b8:	0094ca83          	lbu	s5,9(s1)
    800033bc:	0104ba03          	ld	s4,16(s1)
    800033c0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800033c4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800033c8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800033cc:	00017517          	auipc	a0,0x17
    800033d0:	35c50513          	addi	a0,a0,860 # 8001a728 <ftable>
    800033d4:	474020ef          	jal	80005848 <release>

  if(ff.type == FD_PIPE){
    800033d8:	4785                	li	a5,1
    800033da:	04f90063          	beq	s2,a5,8000341a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800033de:	3979                	addiw	s2,s2,-2
    800033e0:	4785                	li	a5,1
    800033e2:	0527f563          	bgeu	a5,s2,8000342c <fileclose+0xaa>
    800033e6:	7902                	ld	s2,32(sp)
    800033e8:	69e2                	ld	s3,24(sp)
    800033ea:	6a42                	ld	s4,16(sp)
    800033ec:	6aa2                	ld	s5,8(sp)
    800033ee:	a00d                	j	80003410 <fileclose+0x8e>
    800033f0:	f04a                	sd	s2,32(sp)
    800033f2:	ec4e                	sd	s3,24(sp)
    800033f4:	e852                	sd	s4,16(sp)
    800033f6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800033f8:	00004517          	auipc	a0,0x4
    800033fc:	24850513          	addi	a0,a0,584 # 80007640 <etext+0x640>
    80003400:	082020ef          	jal	80005482 <panic>
    release(&ftable.lock);
    80003404:	00017517          	auipc	a0,0x17
    80003408:	32450513          	addi	a0,a0,804 # 8001a728 <ftable>
    8000340c:	43c020ef          	jal	80005848 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003410:	70e2                	ld	ra,56(sp)
    80003412:	7442                	ld	s0,48(sp)
    80003414:	74a2                	ld	s1,40(sp)
    80003416:	6121                	addi	sp,sp,64
    80003418:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000341a:	85d6                	mv	a1,s5
    8000341c:	8552                	mv	a0,s4
    8000341e:	336000ef          	jal	80003754 <pipeclose>
    80003422:	7902                	ld	s2,32(sp)
    80003424:	69e2                	ld	s3,24(sp)
    80003426:	6a42                	ld	s4,16(sp)
    80003428:	6aa2                	ld	s5,8(sp)
    8000342a:	b7dd                	j	80003410 <fileclose+0x8e>
    begin_op();
    8000342c:	b3dff0ef          	jal	80002f68 <begin_op>
    iput(ff.ip);
    80003430:	854e                	mv	a0,s3
    80003432:	c22ff0ef          	jal	80002854 <iput>
    end_op();
    80003436:	b9dff0ef          	jal	80002fd2 <end_op>
    8000343a:	7902                	ld	s2,32(sp)
    8000343c:	69e2                	ld	s3,24(sp)
    8000343e:	6a42                	ld	s4,16(sp)
    80003440:	6aa2                	ld	s5,8(sp)
    80003442:	b7f9                	j	80003410 <fileclose+0x8e>

0000000080003444 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003444:	715d                	addi	sp,sp,-80
    80003446:	e486                	sd	ra,72(sp)
    80003448:	e0a2                	sd	s0,64(sp)
    8000344a:	fc26                	sd	s1,56(sp)
    8000344c:	f44e                	sd	s3,40(sp)
    8000344e:	0880                	addi	s0,sp,80
    80003450:	84aa                	mv	s1,a0
    80003452:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003454:	903fd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003458:	409c                	lw	a5,0(s1)
    8000345a:	37f9                	addiw	a5,a5,-2
    8000345c:	4705                	li	a4,1
    8000345e:	04f76063          	bltu	a4,a5,8000349e <filestat+0x5a>
    80003462:	f84a                	sd	s2,48(sp)
    80003464:	892a                	mv	s2,a0
    ilock(f->ip);
    80003466:	6c88                	ld	a0,24(s1)
    80003468:	a6aff0ef          	jal	800026d2 <ilock>
    stati(f->ip, &st);
    8000346c:	fb840593          	addi	a1,s0,-72
    80003470:	6c88                	ld	a0,24(s1)
    80003472:	c8aff0ef          	jal	800028fc <stati>
    iunlock(f->ip);
    80003476:	6c88                	ld	a0,24(s1)
    80003478:	b08ff0ef          	jal	80002780 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000347c:	46e1                	li	a3,24
    8000347e:	fb840613          	addi	a2,s0,-72
    80003482:	85ce                	mv	a1,s3
    80003484:	05093503          	ld	a0,80(s2)
    80003488:	d3efd0ef          	jal	800009c6 <copyout>
    8000348c:	41f5551b          	sraiw	a0,a0,0x1f
    80003490:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003492:	60a6                	ld	ra,72(sp)
    80003494:	6406                	ld	s0,64(sp)
    80003496:	74e2                	ld	s1,56(sp)
    80003498:	79a2                	ld	s3,40(sp)
    8000349a:	6161                	addi	sp,sp,80
    8000349c:	8082                	ret
  return -1;
    8000349e:	557d                	li	a0,-1
    800034a0:	bfcd                	j	80003492 <filestat+0x4e>

00000000800034a2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800034a2:	7179                	addi	sp,sp,-48
    800034a4:	f406                	sd	ra,40(sp)
    800034a6:	f022                	sd	s0,32(sp)
    800034a8:	e84a                	sd	s2,16(sp)
    800034aa:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800034ac:	00854783          	lbu	a5,8(a0)
    800034b0:	cfd1                	beqz	a5,8000354c <fileread+0xaa>
    800034b2:	ec26                	sd	s1,24(sp)
    800034b4:	e44e                	sd	s3,8(sp)
    800034b6:	84aa                	mv	s1,a0
    800034b8:	89ae                	mv	s3,a1
    800034ba:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800034bc:	411c                	lw	a5,0(a0)
    800034be:	4705                	li	a4,1
    800034c0:	04e78363          	beq	a5,a4,80003506 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034c4:	470d                	li	a4,3
    800034c6:	04e78763          	beq	a5,a4,80003514 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800034ca:	4709                	li	a4,2
    800034cc:	06e79a63          	bne	a5,a4,80003540 <fileread+0x9e>
    ilock(f->ip);
    800034d0:	6d08                	ld	a0,24(a0)
    800034d2:	a00ff0ef          	jal	800026d2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800034d6:	874a                	mv	a4,s2
    800034d8:	5094                	lw	a3,32(s1)
    800034da:	864e                	mv	a2,s3
    800034dc:	4585                	li	a1,1
    800034de:	6c88                	ld	a0,24(s1)
    800034e0:	c46ff0ef          	jal	80002926 <readi>
    800034e4:	892a                	mv	s2,a0
    800034e6:	00a05563          	blez	a0,800034f0 <fileread+0x4e>
      f->off += r;
    800034ea:	509c                	lw	a5,32(s1)
    800034ec:	9fa9                	addw	a5,a5,a0
    800034ee:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800034f0:	6c88                	ld	a0,24(s1)
    800034f2:	a8eff0ef          	jal	80002780 <iunlock>
    800034f6:	64e2                	ld	s1,24(sp)
    800034f8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800034fa:	854a                	mv	a0,s2
    800034fc:	70a2                	ld	ra,40(sp)
    800034fe:	7402                	ld	s0,32(sp)
    80003500:	6942                	ld	s2,16(sp)
    80003502:	6145                	addi	sp,sp,48
    80003504:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003506:	6908                	ld	a0,16(a0)
    80003508:	388000ef          	jal	80003890 <piperead>
    8000350c:	892a                	mv	s2,a0
    8000350e:	64e2                	ld	s1,24(sp)
    80003510:	69a2                	ld	s3,8(sp)
    80003512:	b7e5                	j	800034fa <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003514:	02451783          	lh	a5,36(a0)
    80003518:	03079693          	slli	a3,a5,0x30
    8000351c:	92c1                	srli	a3,a3,0x30
    8000351e:	4725                	li	a4,9
    80003520:	02d76863          	bltu	a4,a3,80003550 <fileread+0xae>
    80003524:	0792                	slli	a5,a5,0x4
    80003526:	00017717          	auipc	a4,0x17
    8000352a:	16270713          	addi	a4,a4,354 # 8001a688 <devsw>
    8000352e:	97ba                	add	a5,a5,a4
    80003530:	639c                	ld	a5,0(a5)
    80003532:	c39d                	beqz	a5,80003558 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003534:	4505                	li	a0,1
    80003536:	9782                	jalr	a5
    80003538:	892a                	mv	s2,a0
    8000353a:	64e2                	ld	s1,24(sp)
    8000353c:	69a2                	ld	s3,8(sp)
    8000353e:	bf75                	j	800034fa <fileread+0x58>
    panic("fileread");
    80003540:	00004517          	auipc	a0,0x4
    80003544:	11050513          	addi	a0,a0,272 # 80007650 <etext+0x650>
    80003548:	73b010ef          	jal	80005482 <panic>
    return -1;
    8000354c:	597d                	li	s2,-1
    8000354e:	b775                	j	800034fa <fileread+0x58>
      return -1;
    80003550:	597d                	li	s2,-1
    80003552:	64e2                	ld	s1,24(sp)
    80003554:	69a2                	ld	s3,8(sp)
    80003556:	b755                	j	800034fa <fileread+0x58>
    80003558:	597d                	li	s2,-1
    8000355a:	64e2                	ld	s1,24(sp)
    8000355c:	69a2                	ld	s3,8(sp)
    8000355e:	bf71                	j	800034fa <fileread+0x58>

0000000080003560 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003560:	00954783          	lbu	a5,9(a0)
    80003564:	10078b63          	beqz	a5,8000367a <filewrite+0x11a>
{
    80003568:	715d                	addi	sp,sp,-80
    8000356a:	e486                	sd	ra,72(sp)
    8000356c:	e0a2                	sd	s0,64(sp)
    8000356e:	f84a                	sd	s2,48(sp)
    80003570:	f052                	sd	s4,32(sp)
    80003572:	e85a                	sd	s6,16(sp)
    80003574:	0880                	addi	s0,sp,80
    80003576:	892a                	mv	s2,a0
    80003578:	8b2e                	mv	s6,a1
    8000357a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000357c:	411c                	lw	a5,0(a0)
    8000357e:	4705                	li	a4,1
    80003580:	02e78763          	beq	a5,a4,800035ae <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003584:	470d                	li	a4,3
    80003586:	02e78863          	beq	a5,a4,800035b6 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000358a:	4709                	li	a4,2
    8000358c:	0ce79c63          	bne	a5,a4,80003664 <filewrite+0x104>
    80003590:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003592:	0ac05863          	blez	a2,80003642 <filewrite+0xe2>
    80003596:	fc26                	sd	s1,56(sp)
    80003598:	ec56                	sd	s5,24(sp)
    8000359a:	e45e                	sd	s7,8(sp)
    8000359c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000359e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800035a0:	6b85                	lui	s7,0x1
    800035a2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800035a6:	6c05                	lui	s8,0x1
    800035a8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800035ac:	a8b5                	j	80003628 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800035ae:	6908                	ld	a0,16(a0)
    800035b0:	1fc000ef          	jal	800037ac <pipewrite>
    800035b4:	a04d                	j	80003656 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800035b6:	02451783          	lh	a5,36(a0)
    800035ba:	03079693          	slli	a3,a5,0x30
    800035be:	92c1                	srli	a3,a3,0x30
    800035c0:	4725                	li	a4,9
    800035c2:	0ad76e63          	bltu	a4,a3,8000367e <filewrite+0x11e>
    800035c6:	0792                	slli	a5,a5,0x4
    800035c8:	00017717          	auipc	a4,0x17
    800035cc:	0c070713          	addi	a4,a4,192 # 8001a688 <devsw>
    800035d0:	97ba                	add	a5,a5,a4
    800035d2:	679c                	ld	a5,8(a5)
    800035d4:	c7dd                	beqz	a5,80003682 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800035d6:	4505                	li	a0,1
    800035d8:	9782                	jalr	a5
    800035da:	a8b5                	j	80003656 <filewrite+0xf6>
      if(n1 > max)
    800035dc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800035e0:	989ff0ef          	jal	80002f68 <begin_op>
      ilock(f->ip);
    800035e4:	01893503          	ld	a0,24(s2)
    800035e8:	8eaff0ef          	jal	800026d2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800035ec:	8756                	mv	a4,s5
    800035ee:	02092683          	lw	a3,32(s2)
    800035f2:	01698633          	add	a2,s3,s6
    800035f6:	4585                	li	a1,1
    800035f8:	01893503          	ld	a0,24(s2)
    800035fc:	c26ff0ef          	jal	80002a22 <writei>
    80003600:	84aa                	mv	s1,a0
    80003602:	00a05763          	blez	a0,80003610 <filewrite+0xb0>
        f->off += r;
    80003606:	02092783          	lw	a5,32(s2)
    8000360a:	9fa9                	addw	a5,a5,a0
    8000360c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003610:	01893503          	ld	a0,24(s2)
    80003614:	96cff0ef          	jal	80002780 <iunlock>
      end_op();
    80003618:	9bbff0ef          	jal	80002fd2 <end_op>

      if(r != n1){
    8000361c:	029a9563          	bne	s5,s1,80003646 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003620:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003624:	0149da63          	bge	s3,s4,80003638 <filewrite+0xd8>
      int n1 = n - i;
    80003628:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000362c:	0004879b          	sext.w	a5,s1
    80003630:	fafbd6e3          	bge	s7,a5,800035dc <filewrite+0x7c>
    80003634:	84e2                	mv	s1,s8
    80003636:	b75d                	j	800035dc <filewrite+0x7c>
    80003638:	74e2                	ld	s1,56(sp)
    8000363a:	6ae2                	ld	s5,24(sp)
    8000363c:	6ba2                	ld	s7,8(sp)
    8000363e:	6c02                	ld	s8,0(sp)
    80003640:	a039                	j	8000364e <filewrite+0xee>
    int i = 0;
    80003642:	4981                	li	s3,0
    80003644:	a029                	j	8000364e <filewrite+0xee>
    80003646:	74e2                	ld	s1,56(sp)
    80003648:	6ae2                	ld	s5,24(sp)
    8000364a:	6ba2                	ld	s7,8(sp)
    8000364c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000364e:	033a1c63          	bne	s4,s3,80003686 <filewrite+0x126>
    80003652:	8552                	mv	a0,s4
    80003654:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003656:	60a6                	ld	ra,72(sp)
    80003658:	6406                	ld	s0,64(sp)
    8000365a:	7942                	ld	s2,48(sp)
    8000365c:	7a02                	ld	s4,32(sp)
    8000365e:	6b42                	ld	s6,16(sp)
    80003660:	6161                	addi	sp,sp,80
    80003662:	8082                	ret
    80003664:	fc26                	sd	s1,56(sp)
    80003666:	f44e                	sd	s3,40(sp)
    80003668:	ec56                	sd	s5,24(sp)
    8000366a:	e45e                	sd	s7,8(sp)
    8000366c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000366e:	00004517          	auipc	a0,0x4
    80003672:	ff250513          	addi	a0,a0,-14 # 80007660 <etext+0x660>
    80003676:	60d010ef          	jal	80005482 <panic>
    return -1;
    8000367a:	557d                	li	a0,-1
}
    8000367c:	8082                	ret
      return -1;
    8000367e:	557d                	li	a0,-1
    80003680:	bfd9                	j	80003656 <filewrite+0xf6>
    80003682:	557d                	li	a0,-1
    80003684:	bfc9                	j	80003656 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003686:	557d                	li	a0,-1
    80003688:	79a2                	ld	s3,40(sp)
    8000368a:	b7f1                	j	80003656 <filewrite+0xf6>

000000008000368c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000368c:	7179                	addi	sp,sp,-48
    8000368e:	f406                	sd	ra,40(sp)
    80003690:	f022                	sd	s0,32(sp)
    80003692:	ec26                	sd	s1,24(sp)
    80003694:	e052                	sd	s4,0(sp)
    80003696:	1800                	addi	s0,sp,48
    80003698:	84aa                	mv	s1,a0
    8000369a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000369c:	0005b023          	sd	zero,0(a1)
    800036a0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800036a4:	c3bff0ef          	jal	800032de <filealloc>
    800036a8:	e088                	sd	a0,0(s1)
    800036aa:	c549                	beqz	a0,80003734 <pipealloc+0xa8>
    800036ac:	c33ff0ef          	jal	800032de <filealloc>
    800036b0:	00aa3023          	sd	a0,0(s4)
    800036b4:	cd25                	beqz	a0,8000372c <pipealloc+0xa0>
    800036b6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800036b8:	a3ffc0ef          	jal	800000f6 <kalloc>
    800036bc:	892a                	mv	s2,a0
    800036be:	c12d                	beqz	a0,80003720 <pipealloc+0x94>
    800036c0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800036c2:	4985                	li	s3,1
    800036c4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800036c8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800036cc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800036d0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800036d4:	00004597          	auipc	a1,0x4
    800036d8:	d3c58593          	addi	a1,a1,-708 # 80007410 <etext+0x410>
    800036dc:	054020ef          	jal	80005730 <initlock>
  (*f0)->type = FD_PIPE;
    800036e0:	609c                	ld	a5,0(s1)
    800036e2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800036e6:	609c                	ld	a5,0(s1)
    800036e8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800036ec:	609c                	ld	a5,0(s1)
    800036ee:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800036f2:	609c                	ld	a5,0(s1)
    800036f4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800036f8:	000a3783          	ld	a5,0(s4)
    800036fc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003700:	000a3783          	ld	a5,0(s4)
    80003704:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003708:	000a3783          	ld	a5,0(s4)
    8000370c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003710:	000a3783          	ld	a5,0(s4)
    80003714:	0127b823          	sd	s2,16(a5)
  return 0;
    80003718:	4501                	li	a0,0
    8000371a:	6942                	ld	s2,16(sp)
    8000371c:	69a2                	ld	s3,8(sp)
    8000371e:	a01d                	j	80003744 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003720:	6088                	ld	a0,0(s1)
    80003722:	c119                	beqz	a0,80003728 <pipealloc+0x9c>
    80003724:	6942                	ld	s2,16(sp)
    80003726:	a029                	j	80003730 <pipealloc+0xa4>
    80003728:	6942                	ld	s2,16(sp)
    8000372a:	a029                	j	80003734 <pipealloc+0xa8>
    8000372c:	6088                	ld	a0,0(s1)
    8000372e:	c10d                	beqz	a0,80003750 <pipealloc+0xc4>
    fileclose(*f0);
    80003730:	c53ff0ef          	jal	80003382 <fileclose>
  if(*f1)
    80003734:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003738:	557d                	li	a0,-1
  if(*f1)
    8000373a:	c789                	beqz	a5,80003744 <pipealloc+0xb8>
    fileclose(*f1);
    8000373c:	853e                	mv	a0,a5
    8000373e:	c45ff0ef          	jal	80003382 <fileclose>
  return -1;
    80003742:	557d                	li	a0,-1
}
    80003744:	70a2                	ld	ra,40(sp)
    80003746:	7402                	ld	s0,32(sp)
    80003748:	64e2                	ld	s1,24(sp)
    8000374a:	6a02                	ld	s4,0(sp)
    8000374c:	6145                	addi	sp,sp,48
    8000374e:	8082                	ret
  return -1;
    80003750:	557d                	li	a0,-1
    80003752:	bfcd                	j	80003744 <pipealloc+0xb8>

0000000080003754 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003754:	1101                	addi	sp,sp,-32
    80003756:	ec06                	sd	ra,24(sp)
    80003758:	e822                	sd	s0,16(sp)
    8000375a:	e426                	sd	s1,8(sp)
    8000375c:	e04a                	sd	s2,0(sp)
    8000375e:	1000                	addi	s0,sp,32
    80003760:	84aa                	mv	s1,a0
    80003762:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003764:	04c020ef          	jal	800057b0 <acquire>
  if(writable){
    80003768:	02090763          	beqz	s2,80003796 <pipeclose+0x42>
    pi->writeopen = 0;
    8000376c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003770:	21848513          	addi	a0,s1,536
    80003774:	c09fd0ef          	jal	8000137c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003778:	2204b783          	ld	a5,544(s1)
    8000377c:	e785                	bnez	a5,800037a4 <pipeclose+0x50>
    release(&pi->lock);
    8000377e:	8526                	mv	a0,s1
    80003780:	0c8020ef          	jal	80005848 <release>
    kfree((char*)pi);
    80003784:	8526                	mv	a0,s1
    80003786:	897fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000378a:	60e2                	ld	ra,24(sp)
    8000378c:	6442                	ld	s0,16(sp)
    8000378e:	64a2                	ld	s1,8(sp)
    80003790:	6902                	ld	s2,0(sp)
    80003792:	6105                	addi	sp,sp,32
    80003794:	8082                	ret
    pi->readopen = 0;
    80003796:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000379a:	21c48513          	addi	a0,s1,540
    8000379e:	bdffd0ef          	jal	8000137c <wakeup>
    800037a2:	bfd9                	j	80003778 <pipeclose+0x24>
    release(&pi->lock);
    800037a4:	8526                	mv	a0,s1
    800037a6:	0a2020ef          	jal	80005848 <release>
}
    800037aa:	b7c5                	j	8000378a <pipeclose+0x36>

00000000800037ac <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800037ac:	711d                	addi	sp,sp,-96
    800037ae:	ec86                	sd	ra,88(sp)
    800037b0:	e8a2                	sd	s0,80(sp)
    800037b2:	e4a6                	sd	s1,72(sp)
    800037b4:	e0ca                	sd	s2,64(sp)
    800037b6:	fc4e                	sd	s3,56(sp)
    800037b8:	f852                	sd	s4,48(sp)
    800037ba:	f456                	sd	s5,40(sp)
    800037bc:	1080                	addi	s0,sp,96
    800037be:	84aa                	mv	s1,a0
    800037c0:	8aae                	mv	s5,a1
    800037c2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800037c4:	d92fd0ef          	jal	80000d56 <myproc>
    800037c8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800037ca:	8526                	mv	a0,s1
    800037cc:	7e5010ef          	jal	800057b0 <acquire>
  while(i < n){
    800037d0:	0b405a63          	blez	s4,80003884 <pipewrite+0xd8>
    800037d4:	f05a                	sd	s6,32(sp)
    800037d6:	ec5e                	sd	s7,24(sp)
    800037d8:	e862                	sd	s8,16(sp)
  int i = 0;
    800037da:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037dc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800037de:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800037e2:	21c48b93          	addi	s7,s1,540
    800037e6:	a81d                	j	8000381c <pipewrite+0x70>
      release(&pi->lock);
    800037e8:	8526                	mv	a0,s1
    800037ea:	05e020ef          	jal	80005848 <release>
      return -1;
    800037ee:	597d                	li	s2,-1
    800037f0:	7b02                	ld	s6,32(sp)
    800037f2:	6be2                	ld	s7,24(sp)
    800037f4:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800037f6:	854a                	mv	a0,s2
    800037f8:	60e6                	ld	ra,88(sp)
    800037fa:	6446                	ld	s0,80(sp)
    800037fc:	64a6                	ld	s1,72(sp)
    800037fe:	6906                	ld	s2,64(sp)
    80003800:	79e2                	ld	s3,56(sp)
    80003802:	7a42                	ld	s4,48(sp)
    80003804:	7aa2                	ld	s5,40(sp)
    80003806:	6125                	addi	sp,sp,96
    80003808:	8082                	ret
      wakeup(&pi->nread);
    8000380a:	8562                	mv	a0,s8
    8000380c:	b71fd0ef          	jal	8000137c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003810:	85a6                	mv	a1,s1
    80003812:	855e                	mv	a0,s7
    80003814:	b1dfd0ef          	jal	80001330 <sleep>
  while(i < n){
    80003818:	05495b63          	bge	s2,s4,8000386e <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000381c:	2204a783          	lw	a5,544(s1)
    80003820:	d7e1                	beqz	a5,800037e8 <pipewrite+0x3c>
    80003822:	854e                	mv	a0,s3
    80003824:	d45fd0ef          	jal	80001568 <killed>
    80003828:	f161                	bnez	a0,800037e8 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000382a:	2184a783          	lw	a5,536(s1)
    8000382e:	21c4a703          	lw	a4,540(s1)
    80003832:	2007879b          	addiw	a5,a5,512
    80003836:	fcf70ae3          	beq	a4,a5,8000380a <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000383a:	4685                	li	a3,1
    8000383c:	01590633          	add	a2,s2,s5
    80003840:	faf40593          	addi	a1,s0,-81
    80003844:	0509b503          	ld	a0,80(s3)
    80003848:	a56fd0ef          	jal	80000a9e <copyin>
    8000384c:	03650e63          	beq	a0,s6,80003888 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003850:	21c4a783          	lw	a5,540(s1)
    80003854:	0017871b          	addiw	a4,a5,1
    80003858:	20e4ae23          	sw	a4,540(s1)
    8000385c:	1ff7f793          	andi	a5,a5,511
    80003860:	97a6                	add	a5,a5,s1
    80003862:	faf44703          	lbu	a4,-81(s0)
    80003866:	00e78c23          	sb	a4,24(a5)
      i++;
    8000386a:	2905                	addiw	s2,s2,1
    8000386c:	b775                	j	80003818 <pipewrite+0x6c>
    8000386e:	7b02                	ld	s6,32(sp)
    80003870:	6be2                	ld	s7,24(sp)
    80003872:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003874:	21848513          	addi	a0,s1,536
    80003878:	b05fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    8000387c:	8526                	mv	a0,s1
    8000387e:	7cb010ef          	jal	80005848 <release>
  return i;
    80003882:	bf95                	j	800037f6 <pipewrite+0x4a>
  int i = 0;
    80003884:	4901                	li	s2,0
    80003886:	b7fd                	j	80003874 <pipewrite+0xc8>
    80003888:	7b02                	ld	s6,32(sp)
    8000388a:	6be2                	ld	s7,24(sp)
    8000388c:	6c42                	ld	s8,16(sp)
    8000388e:	b7dd                	j	80003874 <pipewrite+0xc8>

0000000080003890 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003890:	715d                	addi	sp,sp,-80
    80003892:	e486                	sd	ra,72(sp)
    80003894:	e0a2                	sd	s0,64(sp)
    80003896:	fc26                	sd	s1,56(sp)
    80003898:	f84a                	sd	s2,48(sp)
    8000389a:	f44e                	sd	s3,40(sp)
    8000389c:	f052                	sd	s4,32(sp)
    8000389e:	ec56                	sd	s5,24(sp)
    800038a0:	0880                	addi	s0,sp,80
    800038a2:	84aa                	mv	s1,a0
    800038a4:	892e                	mv	s2,a1
    800038a6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800038a8:	caefd0ef          	jal	80000d56 <myproc>
    800038ac:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800038ae:	8526                	mv	a0,s1
    800038b0:	701010ef          	jal	800057b0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038b4:	2184a703          	lw	a4,536(s1)
    800038b8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038bc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038c0:	02f71563          	bne	a4,a5,800038ea <piperead+0x5a>
    800038c4:	2244a783          	lw	a5,548(s1)
    800038c8:	cb85                	beqz	a5,800038f8 <piperead+0x68>
    if(killed(pr)){
    800038ca:	8552                	mv	a0,s4
    800038cc:	c9dfd0ef          	jal	80001568 <killed>
    800038d0:	ed19                	bnez	a0,800038ee <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038d2:	85a6                	mv	a1,s1
    800038d4:	854e                	mv	a0,s3
    800038d6:	a5bfd0ef          	jal	80001330 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038da:	2184a703          	lw	a4,536(s1)
    800038de:	21c4a783          	lw	a5,540(s1)
    800038e2:	fef701e3          	beq	a4,a5,800038c4 <piperead+0x34>
    800038e6:	e85a                	sd	s6,16(sp)
    800038e8:	a809                	j	800038fa <piperead+0x6a>
    800038ea:	e85a                	sd	s6,16(sp)
    800038ec:	a039                	j	800038fa <piperead+0x6a>
      release(&pi->lock);
    800038ee:	8526                	mv	a0,s1
    800038f0:	759010ef          	jal	80005848 <release>
      return -1;
    800038f4:	59fd                	li	s3,-1
    800038f6:	a8b1                	j	80003952 <piperead+0xc2>
    800038f8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038fa:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800038fc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038fe:	05505263          	blez	s5,80003942 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003902:	2184a783          	lw	a5,536(s1)
    80003906:	21c4a703          	lw	a4,540(s1)
    8000390a:	02f70c63          	beq	a4,a5,80003942 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000390e:	0017871b          	addiw	a4,a5,1
    80003912:	20e4ac23          	sw	a4,536(s1)
    80003916:	1ff7f793          	andi	a5,a5,511
    8000391a:	97a6                	add	a5,a5,s1
    8000391c:	0187c783          	lbu	a5,24(a5)
    80003920:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003924:	4685                	li	a3,1
    80003926:	fbf40613          	addi	a2,s0,-65
    8000392a:	85ca                	mv	a1,s2
    8000392c:	050a3503          	ld	a0,80(s4)
    80003930:	896fd0ef          	jal	800009c6 <copyout>
    80003934:	01650763          	beq	a0,s6,80003942 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003938:	2985                	addiw	s3,s3,1
    8000393a:	0905                	addi	s2,s2,1
    8000393c:	fd3a93e3          	bne	s5,s3,80003902 <piperead+0x72>
    80003940:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003942:	21c48513          	addi	a0,s1,540
    80003946:	a37fd0ef          	jal	8000137c <wakeup>
  release(&pi->lock);
    8000394a:	8526                	mv	a0,s1
    8000394c:	6fd010ef          	jal	80005848 <release>
    80003950:	6b42                	ld	s6,16(sp)
  return i;
}
    80003952:	854e                	mv	a0,s3
    80003954:	60a6                	ld	ra,72(sp)
    80003956:	6406                	ld	s0,64(sp)
    80003958:	74e2                	ld	s1,56(sp)
    8000395a:	7942                	ld	s2,48(sp)
    8000395c:	79a2                	ld	s3,40(sp)
    8000395e:	7a02                	ld	s4,32(sp)
    80003960:	6ae2                	ld	s5,24(sp)
    80003962:	6161                	addi	sp,sp,80
    80003964:	8082                	ret

0000000080003966 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003966:	1141                	addi	sp,sp,-16
    80003968:	e422                	sd	s0,8(sp)
    8000396a:	0800                	addi	s0,sp,16
    8000396c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000396e:	8905                	andi	a0,a0,1
    80003970:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003972:	8b89                	andi	a5,a5,2
    80003974:	c399                	beqz	a5,8000397a <flags2perm+0x14>
      perm |= PTE_W;
    80003976:	00456513          	ori	a0,a0,4
    return perm;
}
    8000397a:	6422                	ld	s0,8(sp)
    8000397c:	0141                	addi	sp,sp,16
    8000397e:	8082                	ret

0000000080003980 <exec>:

int
exec(char *path, char **argv)
{
    80003980:	df010113          	addi	sp,sp,-528
    80003984:	20113423          	sd	ra,520(sp)
    80003988:	20813023          	sd	s0,512(sp)
    8000398c:	ffa6                	sd	s1,504(sp)
    8000398e:	fbca                	sd	s2,496(sp)
    80003990:	0c00                	addi	s0,sp,528
    80003992:	892a                	mv	s2,a0
    80003994:	dea43c23          	sd	a0,-520(s0)
    80003998:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000399c:	bbafd0ef          	jal	80000d56 <myproc>
    800039a0:	84aa                	mv	s1,a0

  begin_op();
    800039a2:	dc6ff0ef          	jal	80002f68 <begin_op>

  if((ip = namei(path)) == 0){
    800039a6:	854a                	mv	a0,s2
    800039a8:	c04ff0ef          	jal	80002dac <namei>
    800039ac:	c931                	beqz	a0,80003a00 <exec+0x80>
    800039ae:	f3d2                	sd	s4,480(sp)
    800039b0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800039b2:	d21fe0ef          	jal	800026d2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800039b6:	04000713          	li	a4,64
    800039ba:	4681                	li	a3,0
    800039bc:	e5040613          	addi	a2,s0,-432
    800039c0:	4581                	li	a1,0
    800039c2:	8552                	mv	a0,s4
    800039c4:	f63fe0ef          	jal	80002926 <readi>
    800039c8:	04000793          	li	a5,64
    800039cc:	00f51a63          	bne	a0,a5,800039e0 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800039d0:	e5042703          	lw	a4,-432(s0)
    800039d4:	464c47b7          	lui	a5,0x464c4
    800039d8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800039dc:	02f70663          	beq	a4,a5,80003a08 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800039e0:	8552                	mv	a0,s4
    800039e2:	efbfe0ef          	jal	800028dc <iunlockput>
    end_op();
    800039e6:	decff0ef          	jal	80002fd2 <end_op>
  }
  return -1;
    800039ea:	557d                	li	a0,-1
    800039ec:	7a1e                	ld	s4,480(sp)
}
    800039ee:	20813083          	ld	ra,520(sp)
    800039f2:	20013403          	ld	s0,512(sp)
    800039f6:	74fe                	ld	s1,504(sp)
    800039f8:	795e                	ld	s2,496(sp)
    800039fa:	21010113          	addi	sp,sp,528
    800039fe:	8082                	ret
    end_op();
    80003a00:	dd2ff0ef          	jal	80002fd2 <end_op>
    return -1;
    80003a04:	557d                	li	a0,-1
    80003a06:	b7e5                	j	800039ee <exec+0x6e>
    80003a08:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	bf2fd0ef          	jal	80000dfe <proc_pagetable>
    80003a10:	8b2a                	mv	s6,a0
    80003a12:	2c050b63          	beqz	a0,80003ce8 <exec+0x368>
    80003a16:	f7ce                	sd	s3,488(sp)
    80003a18:	efd6                	sd	s5,472(sp)
    80003a1a:	e7de                	sd	s7,456(sp)
    80003a1c:	e3e2                	sd	s8,448(sp)
    80003a1e:	ff66                	sd	s9,440(sp)
    80003a20:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a22:	e7042d03          	lw	s10,-400(s0)
    80003a26:	e8845783          	lhu	a5,-376(s0)
    80003a2a:	12078963          	beqz	a5,80003b5c <exec+0x1dc>
    80003a2e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003a30:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a32:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003a34:	6c85                	lui	s9,0x1
    80003a36:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003a3a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003a3e:	6a85                	lui	s5,0x1
    80003a40:	a085                	j	80003aa0 <exec+0x120>
      panic("loadseg: address should exist");
    80003a42:	00004517          	auipc	a0,0x4
    80003a46:	c2e50513          	addi	a0,a0,-978 # 80007670 <etext+0x670>
    80003a4a:	239010ef          	jal	80005482 <panic>
    if(sz - i < PGSIZE)
    80003a4e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003a50:	8726                	mv	a4,s1
    80003a52:	012c06bb          	addw	a3,s8,s2
    80003a56:	4581                	li	a1,0
    80003a58:	8552                	mv	a0,s4
    80003a5a:	ecdfe0ef          	jal	80002926 <readi>
    80003a5e:	2501                	sext.w	a0,a0
    80003a60:	24a49a63          	bne	s1,a0,80003cb4 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003a64:	012a893b          	addw	s2,s5,s2
    80003a68:	03397363          	bgeu	s2,s3,80003a8e <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003a6c:	02091593          	slli	a1,s2,0x20
    80003a70:	9181                	srli	a1,a1,0x20
    80003a72:	95de                	add	a1,a1,s7
    80003a74:	855a                	mv	a0,s6
    80003a76:	9cdfc0ef          	jal	80000442 <walkaddr>
    80003a7a:	862a                	mv	a2,a0
    if(pa == 0)
    80003a7c:	d179                	beqz	a0,80003a42 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003a7e:	412984bb          	subw	s1,s3,s2
    80003a82:	0004879b          	sext.w	a5,s1
    80003a86:	fcfcf4e3          	bgeu	s9,a5,80003a4e <exec+0xce>
    80003a8a:	84d6                	mv	s1,s5
    80003a8c:	b7c9                	j	80003a4e <exec+0xce>
    sz = sz1;
    80003a8e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a92:	2d85                	addiw	s11,s11,1
    80003a94:	038d0d1b          	addiw	s10,s10,56
    80003a98:	e8845783          	lhu	a5,-376(s0)
    80003a9c:	08fdd063          	bge	s11,a5,80003b1c <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003aa0:	2d01                	sext.w	s10,s10
    80003aa2:	03800713          	li	a4,56
    80003aa6:	86ea                	mv	a3,s10
    80003aa8:	e1840613          	addi	a2,s0,-488
    80003aac:	4581                	li	a1,0
    80003aae:	8552                	mv	a0,s4
    80003ab0:	e77fe0ef          	jal	80002926 <readi>
    80003ab4:	03800793          	li	a5,56
    80003ab8:	1cf51663          	bne	a0,a5,80003c84 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003abc:	e1842783          	lw	a5,-488(s0)
    80003ac0:	4705                	li	a4,1
    80003ac2:	fce798e3          	bne	a5,a4,80003a92 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003ac6:	e4043483          	ld	s1,-448(s0)
    80003aca:	e3843783          	ld	a5,-456(s0)
    80003ace:	1af4ef63          	bltu	s1,a5,80003c8c <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003ad2:	e2843783          	ld	a5,-472(s0)
    80003ad6:	94be                	add	s1,s1,a5
    80003ad8:	1af4ee63          	bltu	s1,a5,80003c94 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003adc:	df043703          	ld	a4,-528(s0)
    80003ae0:	8ff9                	and	a5,a5,a4
    80003ae2:	1a079d63          	bnez	a5,80003c9c <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003ae6:	e1c42503          	lw	a0,-484(s0)
    80003aea:	e7dff0ef          	jal	80003966 <flags2perm>
    80003aee:	86aa                	mv	a3,a0
    80003af0:	8626                	mv	a2,s1
    80003af2:	85ca                	mv	a1,s2
    80003af4:	855a                	mv	a0,s6
    80003af6:	cc5fc0ef          	jal	800007ba <uvmalloc>
    80003afa:	e0a43423          	sd	a0,-504(s0)
    80003afe:	1a050363          	beqz	a0,80003ca4 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b02:	e2843b83          	ld	s7,-472(s0)
    80003b06:	e2042c03          	lw	s8,-480(s0)
    80003b0a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003b0e:	00098463          	beqz	s3,80003b16 <exec+0x196>
    80003b12:	4901                	li	s2,0
    80003b14:	bfa1                	j	80003a6c <exec+0xec>
    sz = sz1;
    80003b16:	e0843903          	ld	s2,-504(s0)
    80003b1a:	bfa5                	j	80003a92 <exec+0x112>
    80003b1c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003b1e:	8552                	mv	a0,s4
    80003b20:	dbdfe0ef          	jal	800028dc <iunlockput>
  end_op();
    80003b24:	caeff0ef          	jal	80002fd2 <end_op>
  p = myproc();
    80003b28:	a2efd0ef          	jal	80000d56 <myproc>
    80003b2c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003b2e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003b32:	6985                	lui	s3,0x1
    80003b34:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003b36:	99ca                	add	s3,s3,s2
    80003b38:	77fd                	lui	a5,0xfffff
    80003b3a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003b3e:	4691                	li	a3,4
    80003b40:	6609                	lui	a2,0x2
    80003b42:	964e                	add	a2,a2,s3
    80003b44:	85ce                	mv	a1,s3
    80003b46:	855a                	mv	a0,s6
    80003b48:	c73fc0ef          	jal	800007ba <uvmalloc>
    80003b4c:	892a                	mv	s2,a0
    80003b4e:	e0a43423          	sd	a0,-504(s0)
    80003b52:	e519                	bnez	a0,80003b60 <exec+0x1e0>
  if(pagetable)
    80003b54:	e1343423          	sd	s3,-504(s0)
    80003b58:	4a01                	li	s4,0
    80003b5a:	aab1                	j	80003cb6 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b5c:	4901                	li	s2,0
    80003b5e:	b7c1                	j	80003b1e <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003b60:	75f9                	lui	a1,0xffffe
    80003b62:	95aa                	add	a1,a1,a0
    80003b64:	855a                	mv	a0,s6
    80003b66:	e37fc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003b6a:	7bfd                	lui	s7,0xfffff
    80003b6c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003b6e:	e0043783          	ld	a5,-512(s0)
    80003b72:	6388                	ld	a0,0(a5)
    80003b74:	cd39                	beqz	a0,80003bd2 <exec+0x252>
    80003b76:	e9040993          	addi	s3,s0,-368
    80003b7a:	f9040c13          	addi	s8,s0,-112
    80003b7e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003b80:	f24fc0ef          	jal	800002a4 <strlen>
    80003b84:	0015079b          	addiw	a5,a0,1
    80003b88:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003b8c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003b90:	11796e63          	bltu	s2,s7,80003cac <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003b94:	e0043d03          	ld	s10,-512(s0)
    80003b98:	000d3a03          	ld	s4,0(s10)
    80003b9c:	8552                	mv	a0,s4
    80003b9e:	f06fc0ef          	jal	800002a4 <strlen>
    80003ba2:	0015069b          	addiw	a3,a0,1
    80003ba6:	8652                	mv	a2,s4
    80003ba8:	85ca                	mv	a1,s2
    80003baa:	855a                	mv	a0,s6
    80003bac:	e1bfc0ef          	jal	800009c6 <copyout>
    80003bb0:	10054063          	bltz	a0,80003cb0 <exec+0x330>
    ustack[argc] = sp;
    80003bb4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003bb8:	0485                	addi	s1,s1,1
    80003bba:	008d0793          	addi	a5,s10,8
    80003bbe:	e0f43023          	sd	a5,-512(s0)
    80003bc2:	008d3503          	ld	a0,8(s10)
    80003bc6:	c909                	beqz	a0,80003bd8 <exec+0x258>
    if(argc >= MAXARG)
    80003bc8:	09a1                	addi	s3,s3,8
    80003bca:	fb899be3          	bne	s3,s8,80003b80 <exec+0x200>
  ip = 0;
    80003bce:	4a01                	li	s4,0
    80003bd0:	a0dd                	j	80003cb6 <exec+0x336>
  sp = sz;
    80003bd2:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003bd6:	4481                	li	s1,0
  ustack[argc] = 0;
    80003bd8:	00349793          	slli	a5,s1,0x3
    80003bdc:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb670>
    80003be0:	97a2                	add	a5,a5,s0
    80003be2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003be6:	00148693          	addi	a3,s1,1
    80003bea:	068e                	slli	a3,a3,0x3
    80003bec:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003bf0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003bf4:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003bf8:	f5796ee3          	bltu	s2,s7,80003b54 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003bfc:	e9040613          	addi	a2,s0,-368
    80003c00:	85ca                	mv	a1,s2
    80003c02:	855a                	mv	a0,s6
    80003c04:	dc3fc0ef          	jal	800009c6 <copyout>
    80003c08:	0e054263          	bltz	a0,80003cec <exec+0x36c>
  p->trapframe->a1 = sp;
    80003c0c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003c10:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c14:	df843783          	ld	a5,-520(s0)
    80003c18:	0007c703          	lbu	a4,0(a5)
    80003c1c:	cf11                	beqz	a4,80003c38 <exec+0x2b8>
    80003c1e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003c20:	02f00693          	li	a3,47
    80003c24:	a039                	j	80003c32 <exec+0x2b2>
      last = s+1;
    80003c26:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003c2a:	0785                	addi	a5,a5,1
    80003c2c:	fff7c703          	lbu	a4,-1(a5)
    80003c30:	c701                	beqz	a4,80003c38 <exec+0x2b8>
    if(*s == '/')
    80003c32:	fed71ce3          	bne	a4,a3,80003c2a <exec+0x2aa>
    80003c36:	bfc5                	j	80003c26 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003c38:	4641                	li	a2,16
    80003c3a:	df843583          	ld	a1,-520(s0)
    80003c3e:	158a8513          	addi	a0,s5,344
    80003c42:	e30fc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    80003c46:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003c4a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003c4e:	e0843783          	ld	a5,-504(s0)
    80003c52:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003c56:	058ab783          	ld	a5,88(s5)
    80003c5a:	e6843703          	ld	a4,-408(s0)
    80003c5e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003c60:	058ab783          	ld	a5,88(s5)
    80003c64:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003c68:	85e6                	mv	a1,s9
    80003c6a:	a18fd0ef          	jal	80000e82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003c6e:	0004851b          	sext.w	a0,s1
    80003c72:	79be                	ld	s3,488(sp)
    80003c74:	7a1e                	ld	s4,480(sp)
    80003c76:	6afe                	ld	s5,472(sp)
    80003c78:	6b5e                	ld	s6,464(sp)
    80003c7a:	6bbe                	ld	s7,456(sp)
    80003c7c:	6c1e                	ld	s8,448(sp)
    80003c7e:	7cfa                	ld	s9,440(sp)
    80003c80:	7d5a                	ld	s10,432(sp)
    80003c82:	b3b5                	j	800039ee <exec+0x6e>
    80003c84:	e1243423          	sd	s2,-504(s0)
    80003c88:	7dba                	ld	s11,424(sp)
    80003c8a:	a035                	j	80003cb6 <exec+0x336>
    80003c8c:	e1243423          	sd	s2,-504(s0)
    80003c90:	7dba                	ld	s11,424(sp)
    80003c92:	a015                	j	80003cb6 <exec+0x336>
    80003c94:	e1243423          	sd	s2,-504(s0)
    80003c98:	7dba                	ld	s11,424(sp)
    80003c9a:	a831                	j	80003cb6 <exec+0x336>
    80003c9c:	e1243423          	sd	s2,-504(s0)
    80003ca0:	7dba                	ld	s11,424(sp)
    80003ca2:	a811                	j	80003cb6 <exec+0x336>
    80003ca4:	e1243423          	sd	s2,-504(s0)
    80003ca8:	7dba                	ld	s11,424(sp)
    80003caa:	a031                	j	80003cb6 <exec+0x336>
  ip = 0;
    80003cac:	4a01                	li	s4,0
    80003cae:	a021                	j	80003cb6 <exec+0x336>
    80003cb0:	4a01                	li	s4,0
  if(pagetable)
    80003cb2:	a011                	j	80003cb6 <exec+0x336>
    80003cb4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003cb6:	e0843583          	ld	a1,-504(s0)
    80003cba:	855a                	mv	a0,s6
    80003cbc:	9c6fd0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    80003cc0:	557d                	li	a0,-1
  if(ip){
    80003cc2:	000a1b63          	bnez	s4,80003cd8 <exec+0x358>
    80003cc6:	79be                	ld	s3,488(sp)
    80003cc8:	7a1e                	ld	s4,480(sp)
    80003cca:	6afe                	ld	s5,472(sp)
    80003ccc:	6b5e                	ld	s6,464(sp)
    80003cce:	6bbe                	ld	s7,456(sp)
    80003cd0:	6c1e                	ld	s8,448(sp)
    80003cd2:	7cfa                	ld	s9,440(sp)
    80003cd4:	7d5a                	ld	s10,432(sp)
    80003cd6:	bb21                	j	800039ee <exec+0x6e>
    80003cd8:	79be                	ld	s3,488(sp)
    80003cda:	6afe                	ld	s5,472(sp)
    80003cdc:	6b5e                	ld	s6,464(sp)
    80003cde:	6bbe                	ld	s7,456(sp)
    80003ce0:	6c1e                	ld	s8,448(sp)
    80003ce2:	7cfa                	ld	s9,440(sp)
    80003ce4:	7d5a                	ld	s10,432(sp)
    80003ce6:	b9ed                	j	800039e0 <exec+0x60>
    80003ce8:	6b5e                	ld	s6,464(sp)
    80003cea:	b9dd                	j	800039e0 <exec+0x60>
  sz = sz1;
    80003cec:	e0843983          	ld	s3,-504(s0)
    80003cf0:	b595                	j	80003b54 <exec+0x1d4>

0000000080003cf2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003cf2:	7179                	addi	sp,sp,-48
    80003cf4:	f406                	sd	ra,40(sp)
    80003cf6:	f022                	sd	s0,32(sp)
    80003cf8:	ec26                	sd	s1,24(sp)
    80003cfa:	e84a                	sd	s2,16(sp)
    80003cfc:	1800                	addi	s0,sp,48
    80003cfe:	892e                	mv	s2,a1
    80003d00:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d02:	fdc40593          	addi	a1,s0,-36
    80003d06:	f11fd0ef          	jal	80001c16 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003d0a:	fdc42703          	lw	a4,-36(s0)
    80003d0e:	47bd                	li	a5,15
    80003d10:	02e7e963          	bltu	a5,a4,80003d42 <argfd+0x50>
    80003d14:	842fd0ef          	jal	80000d56 <myproc>
    80003d18:	fdc42703          	lw	a4,-36(s0)
    80003d1c:	01a70793          	addi	a5,a4,26
    80003d20:	078e                	slli	a5,a5,0x3
    80003d22:	953e                	add	a0,a0,a5
    80003d24:	611c                	ld	a5,0(a0)
    80003d26:	c385                	beqz	a5,80003d46 <argfd+0x54>
    return -1;
  if(pfd)
    80003d28:	00090463          	beqz	s2,80003d30 <argfd+0x3e>
    *pfd = fd;
    80003d2c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003d30:	4501                	li	a0,0
  if(pf)
    80003d32:	c091                	beqz	s1,80003d36 <argfd+0x44>
    *pf = f;
    80003d34:	e09c                	sd	a5,0(s1)
}
    80003d36:	70a2                	ld	ra,40(sp)
    80003d38:	7402                	ld	s0,32(sp)
    80003d3a:	64e2                	ld	s1,24(sp)
    80003d3c:	6942                	ld	s2,16(sp)
    80003d3e:	6145                	addi	sp,sp,48
    80003d40:	8082                	ret
    return -1;
    80003d42:	557d                	li	a0,-1
    80003d44:	bfcd                	j	80003d36 <argfd+0x44>
    80003d46:	557d                	li	a0,-1
    80003d48:	b7fd                	j	80003d36 <argfd+0x44>

0000000080003d4a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003d4a:	1101                	addi	sp,sp,-32
    80003d4c:	ec06                	sd	ra,24(sp)
    80003d4e:	e822                	sd	s0,16(sp)
    80003d50:	e426                	sd	s1,8(sp)
    80003d52:	1000                	addi	s0,sp,32
    80003d54:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003d56:	800fd0ef          	jal	80000d56 <myproc>
    80003d5a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003d5c:	0d050793          	addi	a5,a0,208
    80003d60:	4501                	li	a0,0
    80003d62:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003d64:	6398                	ld	a4,0(a5)
    80003d66:	cb19                	beqz	a4,80003d7c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003d68:	2505                	addiw	a0,a0,1
    80003d6a:	07a1                	addi	a5,a5,8
    80003d6c:	fed51ce3          	bne	a0,a3,80003d64 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003d70:	557d                	li	a0,-1
}
    80003d72:	60e2                	ld	ra,24(sp)
    80003d74:	6442                	ld	s0,16(sp)
    80003d76:	64a2                	ld	s1,8(sp)
    80003d78:	6105                	addi	sp,sp,32
    80003d7a:	8082                	ret
      p->ofile[fd] = f;
    80003d7c:	01a50793          	addi	a5,a0,26
    80003d80:	078e                	slli	a5,a5,0x3
    80003d82:	963e                	add	a2,a2,a5
    80003d84:	e204                	sd	s1,0(a2)
      return fd;
    80003d86:	b7f5                	j	80003d72 <fdalloc+0x28>

0000000080003d88 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003d88:	715d                	addi	sp,sp,-80
    80003d8a:	e486                	sd	ra,72(sp)
    80003d8c:	e0a2                	sd	s0,64(sp)
    80003d8e:	fc26                	sd	s1,56(sp)
    80003d90:	f84a                	sd	s2,48(sp)
    80003d92:	f44e                	sd	s3,40(sp)
    80003d94:	ec56                	sd	s5,24(sp)
    80003d96:	e85a                	sd	s6,16(sp)
    80003d98:	0880                	addi	s0,sp,80
    80003d9a:	8b2e                	mv	s6,a1
    80003d9c:	89b2                	mv	s3,a2
    80003d9e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003da0:	fb040593          	addi	a1,s0,-80
    80003da4:	822ff0ef          	jal	80002dc6 <nameiparent>
    80003da8:	84aa                	mv	s1,a0
    80003daa:	10050a63          	beqz	a0,80003ebe <create+0x136>
    return 0;

  ilock(dp);
    80003dae:	925fe0ef          	jal	800026d2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003db2:	4601                	li	a2,0
    80003db4:	fb040593          	addi	a1,s0,-80
    80003db8:	8526                	mv	a0,s1
    80003dba:	d8dfe0ef          	jal	80002b46 <dirlookup>
    80003dbe:	8aaa                	mv	s5,a0
    80003dc0:	c129                	beqz	a0,80003e02 <create+0x7a>
    iunlockput(dp);
    80003dc2:	8526                	mv	a0,s1
    80003dc4:	b19fe0ef          	jal	800028dc <iunlockput>
    ilock(ip);
    80003dc8:	8556                	mv	a0,s5
    80003dca:	909fe0ef          	jal	800026d2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003dce:	4789                	li	a5,2
    80003dd0:	02fb1463          	bne	s6,a5,80003df8 <create+0x70>
    80003dd4:	044ad783          	lhu	a5,68(s5)
    80003dd8:	37f9                	addiw	a5,a5,-2
    80003dda:	17c2                	slli	a5,a5,0x30
    80003ddc:	93c1                	srli	a5,a5,0x30
    80003dde:	4705                	li	a4,1
    80003de0:	00f76c63          	bltu	a4,a5,80003df8 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003de4:	8556                	mv	a0,s5
    80003de6:	60a6                	ld	ra,72(sp)
    80003de8:	6406                	ld	s0,64(sp)
    80003dea:	74e2                	ld	s1,56(sp)
    80003dec:	7942                	ld	s2,48(sp)
    80003dee:	79a2                	ld	s3,40(sp)
    80003df0:	6ae2                	ld	s5,24(sp)
    80003df2:	6b42                	ld	s6,16(sp)
    80003df4:	6161                	addi	sp,sp,80
    80003df6:	8082                	ret
    iunlockput(ip);
    80003df8:	8556                	mv	a0,s5
    80003dfa:	ae3fe0ef          	jal	800028dc <iunlockput>
    return 0;
    80003dfe:	4a81                	li	s5,0
    80003e00:	b7d5                	j	80003de4 <create+0x5c>
    80003e02:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e04:	85da                	mv	a1,s6
    80003e06:	4088                	lw	a0,0(s1)
    80003e08:	f5afe0ef          	jal	80002562 <ialloc>
    80003e0c:	8a2a                	mv	s4,a0
    80003e0e:	cd15                	beqz	a0,80003e4a <create+0xc2>
  ilock(ip);
    80003e10:	8c3fe0ef          	jal	800026d2 <ilock>
  ip->major = major;
    80003e14:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003e18:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003e1c:	4905                	li	s2,1
    80003e1e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003e22:	8552                	mv	a0,s4
    80003e24:	ffafe0ef          	jal	8000261e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003e28:	032b0763          	beq	s6,s2,80003e56 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e2c:	004a2603          	lw	a2,4(s4)
    80003e30:	fb040593          	addi	a1,s0,-80
    80003e34:	8526                	mv	a0,s1
    80003e36:	eddfe0ef          	jal	80002d12 <dirlink>
    80003e3a:	06054563          	bltz	a0,80003ea4 <create+0x11c>
  iunlockput(dp);
    80003e3e:	8526                	mv	a0,s1
    80003e40:	a9dfe0ef          	jal	800028dc <iunlockput>
  return ip;
    80003e44:	8ad2                	mv	s5,s4
    80003e46:	7a02                	ld	s4,32(sp)
    80003e48:	bf71                	j	80003de4 <create+0x5c>
    iunlockput(dp);
    80003e4a:	8526                	mv	a0,s1
    80003e4c:	a91fe0ef          	jal	800028dc <iunlockput>
    return 0;
    80003e50:	8ad2                	mv	s5,s4
    80003e52:	7a02                	ld	s4,32(sp)
    80003e54:	bf41                	j	80003de4 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003e56:	004a2603          	lw	a2,4(s4)
    80003e5a:	00004597          	auipc	a1,0x4
    80003e5e:	83658593          	addi	a1,a1,-1994 # 80007690 <etext+0x690>
    80003e62:	8552                	mv	a0,s4
    80003e64:	eaffe0ef          	jal	80002d12 <dirlink>
    80003e68:	02054e63          	bltz	a0,80003ea4 <create+0x11c>
    80003e6c:	40d0                	lw	a2,4(s1)
    80003e6e:	00004597          	auipc	a1,0x4
    80003e72:	82a58593          	addi	a1,a1,-2006 # 80007698 <etext+0x698>
    80003e76:	8552                	mv	a0,s4
    80003e78:	e9bfe0ef          	jal	80002d12 <dirlink>
    80003e7c:	02054463          	bltz	a0,80003ea4 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e80:	004a2603          	lw	a2,4(s4)
    80003e84:	fb040593          	addi	a1,s0,-80
    80003e88:	8526                	mv	a0,s1
    80003e8a:	e89fe0ef          	jal	80002d12 <dirlink>
    80003e8e:	00054b63          	bltz	a0,80003ea4 <create+0x11c>
    dp->nlink++;  // for ".."
    80003e92:	04a4d783          	lhu	a5,74(s1)
    80003e96:	2785                	addiw	a5,a5,1
    80003e98:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	f80fe0ef          	jal	8000261e <iupdate>
    80003ea2:	bf71                	j	80003e3e <create+0xb6>
  ip->nlink = 0;
    80003ea4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003ea8:	8552                	mv	a0,s4
    80003eaa:	f74fe0ef          	jal	8000261e <iupdate>
  iunlockput(ip);
    80003eae:	8552                	mv	a0,s4
    80003eb0:	a2dfe0ef          	jal	800028dc <iunlockput>
  iunlockput(dp);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	a27fe0ef          	jal	800028dc <iunlockput>
  return 0;
    80003eba:	7a02                	ld	s4,32(sp)
    80003ebc:	b725                	j	80003de4 <create+0x5c>
    return 0;
    80003ebe:	8aaa                	mv	s5,a0
    80003ec0:	b715                	j	80003de4 <create+0x5c>

0000000080003ec2 <sys_dup>:
{
    80003ec2:	7179                	addi	sp,sp,-48
    80003ec4:	f406                	sd	ra,40(sp)
    80003ec6:	f022                	sd	s0,32(sp)
    80003ec8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003eca:	fd840613          	addi	a2,s0,-40
    80003ece:	4581                	li	a1,0
    80003ed0:	4501                	li	a0,0
    80003ed2:	e21ff0ef          	jal	80003cf2 <argfd>
    return -1;
    80003ed6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003ed8:	02054363          	bltz	a0,80003efe <sys_dup+0x3c>
    80003edc:	ec26                	sd	s1,24(sp)
    80003ede:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003ee0:	fd843903          	ld	s2,-40(s0)
    80003ee4:	854a                	mv	a0,s2
    80003ee6:	e65ff0ef          	jal	80003d4a <fdalloc>
    80003eea:	84aa                	mv	s1,a0
    return -1;
    80003eec:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003eee:	00054d63          	bltz	a0,80003f08 <sys_dup+0x46>
  filedup(f);
    80003ef2:	854a                	mv	a0,s2
    80003ef4:	c48ff0ef          	jal	8000333c <filedup>
  return fd;
    80003ef8:	87a6                	mv	a5,s1
    80003efa:	64e2                	ld	s1,24(sp)
    80003efc:	6942                	ld	s2,16(sp)
}
    80003efe:	853e                	mv	a0,a5
    80003f00:	70a2                	ld	ra,40(sp)
    80003f02:	7402                	ld	s0,32(sp)
    80003f04:	6145                	addi	sp,sp,48
    80003f06:	8082                	ret
    80003f08:	64e2                	ld	s1,24(sp)
    80003f0a:	6942                	ld	s2,16(sp)
    80003f0c:	bfcd                	j	80003efe <sys_dup+0x3c>

0000000080003f0e <sys_read>:
{
    80003f0e:	7179                	addi	sp,sp,-48
    80003f10:	f406                	sd	ra,40(sp)
    80003f12:	f022                	sd	s0,32(sp)
    80003f14:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f16:	fd840593          	addi	a1,s0,-40
    80003f1a:	4505                	li	a0,1
    80003f1c:	d17fd0ef          	jal	80001c32 <argaddr>
  argint(2, &n);
    80003f20:	fe440593          	addi	a1,s0,-28
    80003f24:	4509                	li	a0,2
    80003f26:	cf1fd0ef          	jal	80001c16 <argint>
  if(argfd(0, 0, &f) < 0)
    80003f2a:	fe840613          	addi	a2,s0,-24
    80003f2e:	4581                	li	a1,0
    80003f30:	4501                	li	a0,0
    80003f32:	dc1ff0ef          	jal	80003cf2 <argfd>
    80003f36:	87aa                	mv	a5,a0
    return -1;
    80003f38:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f3a:	0007ca63          	bltz	a5,80003f4e <sys_read+0x40>
  return fileread(f, p, n);
    80003f3e:	fe442603          	lw	a2,-28(s0)
    80003f42:	fd843583          	ld	a1,-40(s0)
    80003f46:	fe843503          	ld	a0,-24(s0)
    80003f4a:	d58ff0ef          	jal	800034a2 <fileread>
}
    80003f4e:	70a2                	ld	ra,40(sp)
    80003f50:	7402                	ld	s0,32(sp)
    80003f52:	6145                	addi	sp,sp,48
    80003f54:	8082                	ret

0000000080003f56 <sys_write>:
{
    80003f56:	7179                	addi	sp,sp,-48
    80003f58:	f406                	sd	ra,40(sp)
    80003f5a:	f022                	sd	s0,32(sp)
    80003f5c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f5e:	fd840593          	addi	a1,s0,-40
    80003f62:	4505                	li	a0,1
    80003f64:	ccffd0ef          	jal	80001c32 <argaddr>
  argint(2, &n);
    80003f68:	fe440593          	addi	a1,s0,-28
    80003f6c:	4509                	li	a0,2
    80003f6e:	ca9fd0ef          	jal	80001c16 <argint>
  if(argfd(0, 0, &f) < 0)
    80003f72:	fe840613          	addi	a2,s0,-24
    80003f76:	4581                	li	a1,0
    80003f78:	4501                	li	a0,0
    80003f7a:	d79ff0ef          	jal	80003cf2 <argfd>
    80003f7e:	87aa                	mv	a5,a0
    return -1;
    80003f80:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f82:	0007ca63          	bltz	a5,80003f96 <sys_write+0x40>
  return filewrite(f, p, n);
    80003f86:	fe442603          	lw	a2,-28(s0)
    80003f8a:	fd843583          	ld	a1,-40(s0)
    80003f8e:	fe843503          	ld	a0,-24(s0)
    80003f92:	dceff0ef          	jal	80003560 <filewrite>
}
    80003f96:	70a2                	ld	ra,40(sp)
    80003f98:	7402                	ld	s0,32(sp)
    80003f9a:	6145                	addi	sp,sp,48
    80003f9c:	8082                	ret

0000000080003f9e <sys_close>:
{
    80003f9e:	1101                	addi	sp,sp,-32
    80003fa0:	ec06                	sd	ra,24(sp)
    80003fa2:	e822                	sd	s0,16(sp)
    80003fa4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003fa6:	fe040613          	addi	a2,s0,-32
    80003faa:	fec40593          	addi	a1,s0,-20
    80003fae:	4501                	li	a0,0
    80003fb0:	d43ff0ef          	jal	80003cf2 <argfd>
    return -1;
    80003fb4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003fb6:	02054063          	bltz	a0,80003fd6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003fba:	d9dfc0ef          	jal	80000d56 <myproc>
    80003fbe:	fec42783          	lw	a5,-20(s0)
    80003fc2:	07e9                	addi	a5,a5,26
    80003fc4:	078e                	slli	a5,a5,0x3
    80003fc6:	953e                	add	a0,a0,a5
    80003fc8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003fcc:	fe043503          	ld	a0,-32(s0)
    80003fd0:	bb2ff0ef          	jal	80003382 <fileclose>
  return 0;
    80003fd4:	4781                	li	a5,0
}
    80003fd6:	853e                	mv	a0,a5
    80003fd8:	60e2                	ld	ra,24(sp)
    80003fda:	6442                	ld	s0,16(sp)
    80003fdc:	6105                	addi	sp,sp,32
    80003fde:	8082                	ret

0000000080003fe0 <sys_fstat>:
{
    80003fe0:	1101                	addi	sp,sp,-32
    80003fe2:	ec06                	sd	ra,24(sp)
    80003fe4:	e822                	sd	s0,16(sp)
    80003fe6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003fe8:	fe040593          	addi	a1,s0,-32
    80003fec:	4505                	li	a0,1
    80003fee:	c45fd0ef          	jal	80001c32 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003ff2:	fe840613          	addi	a2,s0,-24
    80003ff6:	4581                	li	a1,0
    80003ff8:	4501                	li	a0,0
    80003ffa:	cf9ff0ef          	jal	80003cf2 <argfd>
    80003ffe:	87aa                	mv	a5,a0
    return -1;
    80004000:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004002:	0007c863          	bltz	a5,80004012 <sys_fstat+0x32>
  return filestat(f, st);
    80004006:	fe043583          	ld	a1,-32(s0)
    8000400a:	fe843503          	ld	a0,-24(s0)
    8000400e:	c36ff0ef          	jal	80003444 <filestat>
}
    80004012:	60e2                	ld	ra,24(sp)
    80004014:	6442                	ld	s0,16(sp)
    80004016:	6105                	addi	sp,sp,32
    80004018:	8082                	ret

000000008000401a <sys_link>:
{
    8000401a:	7169                	addi	sp,sp,-304
    8000401c:	f606                	sd	ra,296(sp)
    8000401e:	f222                	sd	s0,288(sp)
    80004020:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004022:	08000613          	li	a2,128
    80004026:	ed040593          	addi	a1,s0,-304
    8000402a:	4501                	li	a0,0
    8000402c:	c23fd0ef          	jal	80001c4e <argstr>
    return -1;
    80004030:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004032:	0c054e63          	bltz	a0,8000410e <sys_link+0xf4>
    80004036:	08000613          	li	a2,128
    8000403a:	f5040593          	addi	a1,s0,-176
    8000403e:	4505                	li	a0,1
    80004040:	c0ffd0ef          	jal	80001c4e <argstr>
    return -1;
    80004044:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004046:	0c054463          	bltz	a0,8000410e <sys_link+0xf4>
    8000404a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000404c:	f1dfe0ef          	jal	80002f68 <begin_op>
  if((ip = namei(old)) == 0){
    80004050:	ed040513          	addi	a0,s0,-304
    80004054:	d59fe0ef          	jal	80002dac <namei>
    80004058:	84aa                	mv	s1,a0
    8000405a:	c53d                	beqz	a0,800040c8 <sys_link+0xae>
  ilock(ip);
    8000405c:	e76fe0ef          	jal	800026d2 <ilock>
  if(ip->type == T_DIR){
    80004060:	04449703          	lh	a4,68(s1)
    80004064:	4785                	li	a5,1
    80004066:	06f70663          	beq	a4,a5,800040d2 <sys_link+0xb8>
    8000406a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000406c:	04a4d783          	lhu	a5,74(s1)
    80004070:	2785                	addiw	a5,a5,1
    80004072:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004076:	8526                	mv	a0,s1
    80004078:	da6fe0ef          	jal	8000261e <iupdate>
  iunlock(ip);
    8000407c:	8526                	mv	a0,s1
    8000407e:	f02fe0ef          	jal	80002780 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004082:	fd040593          	addi	a1,s0,-48
    80004086:	f5040513          	addi	a0,s0,-176
    8000408a:	d3dfe0ef          	jal	80002dc6 <nameiparent>
    8000408e:	892a                	mv	s2,a0
    80004090:	cd21                	beqz	a0,800040e8 <sys_link+0xce>
  ilock(dp);
    80004092:	e40fe0ef          	jal	800026d2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004096:	00092703          	lw	a4,0(s2)
    8000409a:	409c                	lw	a5,0(s1)
    8000409c:	04f71363          	bne	a4,a5,800040e2 <sys_link+0xc8>
    800040a0:	40d0                	lw	a2,4(s1)
    800040a2:	fd040593          	addi	a1,s0,-48
    800040a6:	854a                	mv	a0,s2
    800040a8:	c6bfe0ef          	jal	80002d12 <dirlink>
    800040ac:	02054b63          	bltz	a0,800040e2 <sys_link+0xc8>
  iunlockput(dp);
    800040b0:	854a                	mv	a0,s2
    800040b2:	82bfe0ef          	jal	800028dc <iunlockput>
  iput(ip);
    800040b6:	8526                	mv	a0,s1
    800040b8:	f9cfe0ef          	jal	80002854 <iput>
  end_op();
    800040bc:	f17fe0ef          	jal	80002fd2 <end_op>
  return 0;
    800040c0:	4781                	li	a5,0
    800040c2:	64f2                	ld	s1,280(sp)
    800040c4:	6952                	ld	s2,272(sp)
    800040c6:	a0a1                	j	8000410e <sys_link+0xf4>
    end_op();
    800040c8:	f0bfe0ef          	jal	80002fd2 <end_op>
    return -1;
    800040cc:	57fd                	li	a5,-1
    800040ce:	64f2                	ld	s1,280(sp)
    800040d0:	a83d                	j	8000410e <sys_link+0xf4>
    iunlockput(ip);
    800040d2:	8526                	mv	a0,s1
    800040d4:	809fe0ef          	jal	800028dc <iunlockput>
    end_op();
    800040d8:	efbfe0ef          	jal	80002fd2 <end_op>
    return -1;
    800040dc:	57fd                	li	a5,-1
    800040de:	64f2                	ld	s1,280(sp)
    800040e0:	a03d                	j	8000410e <sys_link+0xf4>
    iunlockput(dp);
    800040e2:	854a                	mv	a0,s2
    800040e4:	ff8fe0ef          	jal	800028dc <iunlockput>
  ilock(ip);
    800040e8:	8526                	mv	a0,s1
    800040ea:	de8fe0ef          	jal	800026d2 <ilock>
  ip->nlink--;
    800040ee:	04a4d783          	lhu	a5,74(s1)
    800040f2:	37fd                	addiw	a5,a5,-1
    800040f4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800040f8:	8526                	mv	a0,s1
    800040fa:	d24fe0ef          	jal	8000261e <iupdate>
  iunlockput(ip);
    800040fe:	8526                	mv	a0,s1
    80004100:	fdcfe0ef          	jal	800028dc <iunlockput>
  end_op();
    80004104:	ecffe0ef          	jal	80002fd2 <end_op>
  return -1;
    80004108:	57fd                	li	a5,-1
    8000410a:	64f2                	ld	s1,280(sp)
    8000410c:	6952                	ld	s2,272(sp)
}
    8000410e:	853e                	mv	a0,a5
    80004110:	70b2                	ld	ra,296(sp)
    80004112:	7412                	ld	s0,288(sp)
    80004114:	6155                	addi	sp,sp,304
    80004116:	8082                	ret

0000000080004118 <sys_unlink>:
{
    80004118:	7151                	addi	sp,sp,-240
    8000411a:	f586                	sd	ra,232(sp)
    8000411c:	f1a2                	sd	s0,224(sp)
    8000411e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004120:	08000613          	li	a2,128
    80004124:	f3040593          	addi	a1,s0,-208
    80004128:	4501                	li	a0,0
    8000412a:	b25fd0ef          	jal	80001c4e <argstr>
    8000412e:	16054063          	bltz	a0,8000428e <sys_unlink+0x176>
    80004132:	eda6                	sd	s1,216(sp)
  begin_op();
    80004134:	e35fe0ef          	jal	80002f68 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004138:	fb040593          	addi	a1,s0,-80
    8000413c:	f3040513          	addi	a0,s0,-208
    80004140:	c87fe0ef          	jal	80002dc6 <nameiparent>
    80004144:	84aa                	mv	s1,a0
    80004146:	c945                	beqz	a0,800041f6 <sys_unlink+0xde>
  ilock(dp);
    80004148:	d8afe0ef          	jal	800026d2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000414c:	00003597          	auipc	a1,0x3
    80004150:	54458593          	addi	a1,a1,1348 # 80007690 <etext+0x690>
    80004154:	fb040513          	addi	a0,s0,-80
    80004158:	9d9fe0ef          	jal	80002b30 <namecmp>
    8000415c:	10050e63          	beqz	a0,80004278 <sys_unlink+0x160>
    80004160:	00003597          	auipc	a1,0x3
    80004164:	53858593          	addi	a1,a1,1336 # 80007698 <etext+0x698>
    80004168:	fb040513          	addi	a0,s0,-80
    8000416c:	9c5fe0ef          	jal	80002b30 <namecmp>
    80004170:	10050463          	beqz	a0,80004278 <sys_unlink+0x160>
    80004174:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004176:	f2c40613          	addi	a2,s0,-212
    8000417a:	fb040593          	addi	a1,s0,-80
    8000417e:	8526                	mv	a0,s1
    80004180:	9c7fe0ef          	jal	80002b46 <dirlookup>
    80004184:	892a                	mv	s2,a0
    80004186:	0e050863          	beqz	a0,80004276 <sys_unlink+0x15e>
  ilock(ip);
    8000418a:	d48fe0ef          	jal	800026d2 <ilock>
  if(ip->nlink < 1)
    8000418e:	04a91783          	lh	a5,74(s2)
    80004192:	06f05763          	blez	a5,80004200 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004196:	04491703          	lh	a4,68(s2)
    8000419a:	4785                	li	a5,1
    8000419c:	06f70963          	beq	a4,a5,8000420e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800041a0:	4641                	li	a2,16
    800041a2:	4581                	li	a1,0
    800041a4:	fc040513          	addi	a0,s0,-64
    800041a8:	f8dfb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041ac:	4741                	li	a4,16
    800041ae:	f2c42683          	lw	a3,-212(s0)
    800041b2:	fc040613          	addi	a2,s0,-64
    800041b6:	4581                	li	a1,0
    800041b8:	8526                	mv	a0,s1
    800041ba:	869fe0ef          	jal	80002a22 <writei>
    800041be:	47c1                	li	a5,16
    800041c0:	08f51b63          	bne	a0,a5,80004256 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800041c4:	04491703          	lh	a4,68(s2)
    800041c8:	4785                	li	a5,1
    800041ca:	08f70d63          	beq	a4,a5,80004264 <sys_unlink+0x14c>
  iunlockput(dp);
    800041ce:	8526                	mv	a0,s1
    800041d0:	f0cfe0ef          	jal	800028dc <iunlockput>
  ip->nlink--;
    800041d4:	04a95783          	lhu	a5,74(s2)
    800041d8:	37fd                	addiw	a5,a5,-1
    800041da:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800041de:	854a                	mv	a0,s2
    800041e0:	c3efe0ef          	jal	8000261e <iupdate>
  iunlockput(ip);
    800041e4:	854a                	mv	a0,s2
    800041e6:	ef6fe0ef          	jal	800028dc <iunlockput>
  end_op();
    800041ea:	de9fe0ef          	jal	80002fd2 <end_op>
  return 0;
    800041ee:	4501                	li	a0,0
    800041f0:	64ee                	ld	s1,216(sp)
    800041f2:	694e                	ld	s2,208(sp)
    800041f4:	a849                	j	80004286 <sys_unlink+0x16e>
    end_op();
    800041f6:	dddfe0ef          	jal	80002fd2 <end_op>
    return -1;
    800041fa:	557d                	li	a0,-1
    800041fc:	64ee                	ld	s1,216(sp)
    800041fe:	a061                	j	80004286 <sys_unlink+0x16e>
    80004200:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004202:	00003517          	auipc	a0,0x3
    80004206:	49e50513          	addi	a0,a0,1182 # 800076a0 <etext+0x6a0>
    8000420a:	278010ef          	jal	80005482 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000420e:	04c92703          	lw	a4,76(s2)
    80004212:	02000793          	li	a5,32
    80004216:	f8e7f5e3          	bgeu	a5,a4,800041a0 <sys_unlink+0x88>
    8000421a:	e5ce                	sd	s3,200(sp)
    8000421c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004220:	4741                	li	a4,16
    80004222:	86ce                	mv	a3,s3
    80004224:	f1840613          	addi	a2,s0,-232
    80004228:	4581                	li	a1,0
    8000422a:	854a                	mv	a0,s2
    8000422c:	efafe0ef          	jal	80002926 <readi>
    80004230:	47c1                	li	a5,16
    80004232:	00f51c63          	bne	a0,a5,8000424a <sys_unlink+0x132>
    if(de.inum != 0)
    80004236:	f1845783          	lhu	a5,-232(s0)
    8000423a:	efa1                	bnez	a5,80004292 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000423c:	29c1                	addiw	s3,s3,16
    8000423e:	04c92783          	lw	a5,76(s2)
    80004242:	fcf9efe3          	bltu	s3,a5,80004220 <sys_unlink+0x108>
    80004246:	69ae                	ld	s3,200(sp)
    80004248:	bfa1                	j	800041a0 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000424a:	00003517          	auipc	a0,0x3
    8000424e:	46e50513          	addi	a0,a0,1134 # 800076b8 <etext+0x6b8>
    80004252:	230010ef          	jal	80005482 <panic>
    80004256:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004258:	00003517          	auipc	a0,0x3
    8000425c:	47850513          	addi	a0,a0,1144 # 800076d0 <etext+0x6d0>
    80004260:	222010ef          	jal	80005482 <panic>
    dp->nlink--;
    80004264:	04a4d783          	lhu	a5,74(s1)
    80004268:	37fd                	addiw	a5,a5,-1
    8000426a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000426e:	8526                	mv	a0,s1
    80004270:	baefe0ef          	jal	8000261e <iupdate>
    80004274:	bfa9                	j	800041ce <sys_unlink+0xb6>
    80004276:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004278:	8526                	mv	a0,s1
    8000427a:	e62fe0ef          	jal	800028dc <iunlockput>
  end_op();
    8000427e:	d55fe0ef          	jal	80002fd2 <end_op>
  return -1;
    80004282:	557d                	li	a0,-1
    80004284:	64ee                	ld	s1,216(sp)
}
    80004286:	70ae                	ld	ra,232(sp)
    80004288:	740e                	ld	s0,224(sp)
    8000428a:	616d                	addi	sp,sp,240
    8000428c:	8082                	ret
    return -1;
    8000428e:	557d                	li	a0,-1
    80004290:	bfdd                	j	80004286 <sys_unlink+0x16e>
    iunlockput(ip);
    80004292:	854a                	mv	a0,s2
    80004294:	e48fe0ef          	jal	800028dc <iunlockput>
    goto bad;
    80004298:	694e                	ld	s2,208(sp)
    8000429a:	69ae                	ld	s3,200(sp)
    8000429c:	bff1                	j	80004278 <sys_unlink+0x160>

000000008000429e <sys_open>:

uint64
sys_open(void)
{
    8000429e:	7131                	addi	sp,sp,-192
    800042a0:	fd06                	sd	ra,184(sp)
    800042a2:	f922                	sd	s0,176(sp)
    800042a4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800042a6:	f4c40593          	addi	a1,s0,-180
    800042aa:	4505                	li	a0,1
    800042ac:	96bfd0ef          	jal	80001c16 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042b0:	08000613          	li	a2,128
    800042b4:	f5040593          	addi	a1,s0,-176
    800042b8:	4501                	li	a0,0
    800042ba:	995fd0ef          	jal	80001c4e <argstr>
    800042be:	87aa                	mv	a5,a0
    return -1;
    800042c0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042c2:	0a07c263          	bltz	a5,80004366 <sys_open+0xc8>
    800042c6:	f526                	sd	s1,168(sp)

  begin_op();
    800042c8:	ca1fe0ef          	jal	80002f68 <begin_op>

  if(omode & O_CREATE){
    800042cc:	f4c42783          	lw	a5,-180(s0)
    800042d0:	2007f793          	andi	a5,a5,512
    800042d4:	c3d5                	beqz	a5,80004378 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800042d6:	4681                	li	a3,0
    800042d8:	4601                	li	a2,0
    800042da:	4589                	li	a1,2
    800042dc:	f5040513          	addi	a0,s0,-176
    800042e0:	aa9ff0ef          	jal	80003d88 <create>
    800042e4:	84aa                	mv	s1,a0
    if(ip == 0){
    800042e6:	c541                	beqz	a0,8000436e <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800042e8:	04449703          	lh	a4,68(s1)
    800042ec:	478d                	li	a5,3
    800042ee:	00f71763          	bne	a4,a5,800042fc <sys_open+0x5e>
    800042f2:	0464d703          	lhu	a4,70(s1)
    800042f6:	47a5                	li	a5,9
    800042f8:	0ae7ed63          	bltu	a5,a4,800043b2 <sys_open+0x114>
    800042fc:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800042fe:	fe1fe0ef          	jal	800032de <filealloc>
    80004302:	892a                	mv	s2,a0
    80004304:	c179                	beqz	a0,800043ca <sys_open+0x12c>
    80004306:	ed4e                	sd	s3,152(sp)
    80004308:	a43ff0ef          	jal	80003d4a <fdalloc>
    8000430c:	89aa                	mv	s3,a0
    8000430e:	0a054a63          	bltz	a0,800043c2 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004312:	04449703          	lh	a4,68(s1)
    80004316:	478d                	li	a5,3
    80004318:	0cf70263          	beq	a4,a5,800043dc <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000431c:	4789                	li	a5,2
    8000431e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004322:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004326:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000432a:	f4c42783          	lw	a5,-180(s0)
    8000432e:	0017c713          	xori	a4,a5,1
    80004332:	8b05                	andi	a4,a4,1
    80004334:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004338:	0037f713          	andi	a4,a5,3
    8000433c:	00e03733          	snez	a4,a4
    80004340:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004344:	4007f793          	andi	a5,a5,1024
    80004348:	c791                	beqz	a5,80004354 <sys_open+0xb6>
    8000434a:	04449703          	lh	a4,68(s1)
    8000434e:	4789                	li	a5,2
    80004350:	08f70d63          	beq	a4,a5,800043ea <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004354:	8526                	mv	a0,s1
    80004356:	c2afe0ef          	jal	80002780 <iunlock>
  end_op();
    8000435a:	c79fe0ef          	jal	80002fd2 <end_op>

  return fd;
    8000435e:	854e                	mv	a0,s3
    80004360:	74aa                	ld	s1,168(sp)
    80004362:	790a                	ld	s2,160(sp)
    80004364:	69ea                	ld	s3,152(sp)
}
    80004366:	70ea                	ld	ra,184(sp)
    80004368:	744a                	ld	s0,176(sp)
    8000436a:	6129                	addi	sp,sp,192
    8000436c:	8082                	ret
      end_op();
    8000436e:	c65fe0ef          	jal	80002fd2 <end_op>
      return -1;
    80004372:	557d                	li	a0,-1
    80004374:	74aa                	ld	s1,168(sp)
    80004376:	bfc5                	j	80004366 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004378:	f5040513          	addi	a0,s0,-176
    8000437c:	a31fe0ef          	jal	80002dac <namei>
    80004380:	84aa                	mv	s1,a0
    80004382:	c11d                	beqz	a0,800043a8 <sys_open+0x10a>
    ilock(ip);
    80004384:	b4efe0ef          	jal	800026d2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004388:	04449703          	lh	a4,68(s1)
    8000438c:	4785                	li	a5,1
    8000438e:	f4f71de3          	bne	a4,a5,800042e8 <sys_open+0x4a>
    80004392:	f4c42783          	lw	a5,-180(s0)
    80004396:	d3bd                	beqz	a5,800042fc <sys_open+0x5e>
      iunlockput(ip);
    80004398:	8526                	mv	a0,s1
    8000439a:	d42fe0ef          	jal	800028dc <iunlockput>
      end_op();
    8000439e:	c35fe0ef          	jal	80002fd2 <end_op>
      return -1;
    800043a2:	557d                	li	a0,-1
    800043a4:	74aa                	ld	s1,168(sp)
    800043a6:	b7c1                	j	80004366 <sys_open+0xc8>
      end_op();
    800043a8:	c2bfe0ef          	jal	80002fd2 <end_op>
      return -1;
    800043ac:	557d                	li	a0,-1
    800043ae:	74aa                	ld	s1,168(sp)
    800043b0:	bf5d                	j	80004366 <sys_open+0xc8>
    iunlockput(ip);
    800043b2:	8526                	mv	a0,s1
    800043b4:	d28fe0ef          	jal	800028dc <iunlockput>
    end_op();
    800043b8:	c1bfe0ef          	jal	80002fd2 <end_op>
    return -1;
    800043bc:	557d                	li	a0,-1
    800043be:	74aa                	ld	s1,168(sp)
    800043c0:	b75d                	j	80004366 <sys_open+0xc8>
      fileclose(f);
    800043c2:	854a                	mv	a0,s2
    800043c4:	fbffe0ef          	jal	80003382 <fileclose>
    800043c8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800043ca:	8526                	mv	a0,s1
    800043cc:	d10fe0ef          	jal	800028dc <iunlockput>
    end_op();
    800043d0:	c03fe0ef          	jal	80002fd2 <end_op>
    return -1;
    800043d4:	557d                	li	a0,-1
    800043d6:	74aa                	ld	s1,168(sp)
    800043d8:	790a                	ld	s2,160(sp)
    800043da:	b771                	j	80004366 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800043dc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800043e0:	04649783          	lh	a5,70(s1)
    800043e4:	02f91223          	sh	a5,36(s2)
    800043e8:	bf3d                	j	80004326 <sys_open+0x88>
    itrunc(ip);
    800043ea:	8526                	mv	a0,s1
    800043ec:	bd4fe0ef          	jal	800027c0 <itrunc>
    800043f0:	b795                	j	80004354 <sys_open+0xb6>

00000000800043f2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800043f2:	7175                	addi	sp,sp,-144
    800043f4:	e506                	sd	ra,136(sp)
    800043f6:	e122                	sd	s0,128(sp)
    800043f8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800043fa:	b6ffe0ef          	jal	80002f68 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800043fe:	08000613          	li	a2,128
    80004402:	f7040593          	addi	a1,s0,-144
    80004406:	4501                	li	a0,0
    80004408:	847fd0ef          	jal	80001c4e <argstr>
    8000440c:	02054363          	bltz	a0,80004432 <sys_mkdir+0x40>
    80004410:	4681                	li	a3,0
    80004412:	4601                	li	a2,0
    80004414:	4585                	li	a1,1
    80004416:	f7040513          	addi	a0,s0,-144
    8000441a:	96fff0ef          	jal	80003d88 <create>
    8000441e:	c911                	beqz	a0,80004432 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004420:	cbcfe0ef          	jal	800028dc <iunlockput>
  end_op();
    80004424:	baffe0ef          	jal	80002fd2 <end_op>
  return 0;
    80004428:	4501                	li	a0,0
}
    8000442a:	60aa                	ld	ra,136(sp)
    8000442c:	640a                	ld	s0,128(sp)
    8000442e:	6149                	addi	sp,sp,144
    80004430:	8082                	ret
    end_op();
    80004432:	ba1fe0ef          	jal	80002fd2 <end_op>
    return -1;
    80004436:	557d                	li	a0,-1
    80004438:	bfcd                	j	8000442a <sys_mkdir+0x38>

000000008000443a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000443a:	7135                	addi	sp,sp,-160
    8000443c:	ed06                	sd	ra,152(sp)
    8000443e:	e922                	sd	s0,144(sp)
    80004440:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004442:	b27fe0ef          	jal	80002f68 <begin_op>
  argint(1, &major);
    80004446:	f6c40593          	addi	a1,s0,-148
    8000444a:	4505                	li	a0,1
    8000444c:	fcafd0ef          	jal	80001c16 <argint>
  argint(2, &minor);
    80004450:	f6840593          	addi	a1,s0,-152
    80004454:	4509                	li	a0,2
    80004456:	fc0fd0ef          	jal	80001c16 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000445a:	08000613          	li	a2,128
    8000445e:	f7040593          	addi	a1,s0,-144
    80004462:	4501                	li	a0,0
    80004464:	feafd0ef          	jal	80001c4e <argstr>
    80004468:	02054563          	bltz	a0,80004492 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000446c:	f6841683          	lh	a3,-152(s0)
    80004470:	f6c41603          	lh	a2,-148(s0)
    80004474:	458d                	li	a1,3
    80004476:	f7040513          	addi	a0,s0,-144
    8000447a:	90fff0ef          	jal	80003d88 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000447e:	c911                	beqz	a0,80004492 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004480:	c5cfe0ef          	jal	800028dc <iunlockput>
  end_op();
    80004484:	b4ffe0ef          	jal	80002fd2 <end_op>
  return 0;
    80004488:	4501                	li	a0,0
}
    8000448a:	60ea                	ld	ra,152(sp)
    8000448c:	644a                	ld	s0,144(sp)
    8000448e:	610d                	addi	sp,sp,160
    80004490:	8082                	ret
    end_op();
    80004492:	b41fe0ef          	jal	80002fd2 <end_op>
    return -1;
    80004496:	557d                	li	a0,-1
    80004498:	bfcd                	j	8000448a <sys_mknod+0x50>

000000008000449a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000449a:	7135                	addi	sp,sp,-160
    8000449c:	ed06                	sd	ra,152(sp)
    8000449e:	e922                	sd	s0,144(sp)
    800044a0:	e14a                	sd	s2,128(sp)
    800044a2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800044a4:	8b3fc0ef          	jal	80000d56 <myproc>
    800044a8:	892a                	mv	s2,a0
  
  begin_op();
    800044aa:	abffe0ef          	jal	80002f68 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800044ae:	08000613          	li	a2,128
    800044b2:	f6040593          	addi	a1,s0,-160
    800044b6:	4501                	li	a0,0
    800044b8:	f96fd0ef          	jal	80001c4e <argstr>
    800044bc:	04054363          	bltz	a0,80004502 <sys_chdir+0x68>
    800044c0:	e526                	sd	s1,136(sp)
    800044c2:	f6040513          	addi	a0,s0,-160
    800044c6:	8e7fe0ef          	jal	80002dac <namei>
    800044ca:	84aa                	mv	s1,a0
    800044cc:	c915                	beqz	a0,80004500 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800044ce:	a04fe0ef          	jal	800026d2 <ilock>
  if(ip->type != T_DIR){
    800044d2:	04449703          	lh	a4,68(s1)
    800044d6:	4785                	li	a5,1
    800044d8:	02f71963          	bne	a4,a5,8000450a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800044dc:	8526                	mv	a0,s1
    800044de:	aa2fe0ef          	jal	80002780 <iunlock>
  iput(p->cwd);
    800044e2:	15093503          	ld	a0,336(s2)
    800044e6:	b6efe0ef          	jal	80002854 <iput>
  end_op();
    800044ea:	ae9fe0ef          	jal	80002fd2 <end_op>
  p->cwd = ip;
    800044ee:	14993823          	sd	s1,336(s2)
  return 0;
    800044f2:	4501                	li	a0,0
    800044f4:	64aa                	ld	s1,136(sp)
}
    800044f6:	60ea                	ld	ra,152(sp)
    800044f8:	644a                	ld	s0,144(sp)
    800044fa:	690a                	ld	s2,128(sp)
    800044fc:	610d                	addi	sp,sp,160
    800044fe:	8082                	ret
    80004500:	64aa                	ld	s1,136(sp)
    end_op();
    80004502:	ad1fe0ef          	jal	80002fd2 <end_op>
    return -1;
    80004506:	557d                	li	a0,-1
    80004508:	b7fd                	j	800044f6 <sys_chdir+0x5c>
    iunlockput(ip);
    8000450a:	8526                	mv	a0,s1
    8000450c:	bd0fe0ef          	jal	800028dc <iunlockput>
    end_op();
    80004510:	ac3fe0ef          	jal	80002fd2 <end_op>
    return -1;
    80004514:	557d                	li	a0,-1
    80004516:	64aa                	ld	s1,136(sp)
    80004518:	bff9                	j	800044f6 <sys_chdir+0x5c>

000000008000451a <sys_exec>:

uint64
sys_exec(void)
{
    8000451a:	7121                	addi	sp,sp,-448
    8000451c:	ff06                	sd	ra,440(sp)
    8000451e:	fb22                	sd	s0,432(sp)
    80004520:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004522:	e4840593          	addi	a1,s0,-440
    80004526:	4505                	li	a0,1
    80004528:	f0afd0ef          	jal	80001c32 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000452c:	08000613          	li	a2,128
    80004530:	f5040593          	addi	a1,s0,-176
    80004534:	4501                	li	a0,0
    80004536:	f18fd0ef          	jal	80001c4e <argstr>
    8000453a:	87aa                	mv	a5,a0
    return -1;
    8000453c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000453e:	0c07c463          	bltz	a5,80004606 <sys_exec+0xec>
    80004542:	f726                	sd	s1,424(sp)
    80004544:	f34a                	sd	s2,416(sp)
    80004546:	ef4e                	sd	s3,408(sp)
    80004548:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000454a:	10000613          	li	a2,256
    8000454e:	4581                	li	a1,0
    80004550:	e5040513          	addi	a0,s0,-432
    80004554:	be1fb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004558:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000455c:	89a6                	mv	s3,s1
    8000455e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004560:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004564:	00391513          	slli	a0,s2,0x3
    80004568:	e4040593          	addi	a1,s0,-448
    8000456c:	e4843783          	ld	a5,-440(s0)
    80004570:	953e                	add	a0,a0,a5
    80004572:	e1afd0ef          	jal	80001b8c <fetchaddr>
    80004576:	02054663          	bltz	a0,800045a2 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000457a:	e4043783          	ld	a5,-448(s0)
    8000457e:	c3a9                	beqz	a5,800045c0 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004580:	b77fb0ef          	jal	800000f6 <kalloc>
    80004584:	85aa                	mv	a1,a0
    80004586:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000458a:	cd01                	beqz	a0,800045a2 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000458c:	6605                	lui	a2,0x1
    8000458e:	e4043503          	ld	a0,-448(s0)
    80004592:	e44fd0ef          	jal	80001bd6 <fetchstr>
    80004596:	00054663          	bltz	a0,800045a2 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000459a:	0905                	addi	s2,s2,1
    8000459c:	09a1                	addi	s3,s3,8
    8000459e:	fd4913e3          	bne	s2,s4,80004564 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045a2:	f5040913          	addi	s2,s0,-176
    800045a6:	6088                	ld	a0,0(s1)
    800045a8:	c931                	beqz	a0,800045fc <sys_exec+0xe2>
    kfree(argv[i]);
    800045aa:	a73fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045ae:	04a1                	addi	s1,s1,8
    800045b0:	ff249be3          	bne	s1,s2,800045a6 <sys_exec+0x8c>
  return -1;
    800045b4:	557d                	li	a0,-1
    800045b6:	74ba                	ld	s1,424(sp)
    800045b8:	791a                	ld	s2,416(sp)
    800045ba:	69fa                	ld	s3,408(sp)
    800045bc:	6a5a                	ld	s4,400(sp)
    800045be:	a0a1                	j	80004606 <sys_exec+0xec>
      argv[i] = 0;
    800045c0:	0009079b          	sext.w	a5,s2
    800045c4:	078e                	slli	a5,a5,0x3
    800045c6:	fd078793          	addi	a5,a5,-48
    800045ca:	97a2                	add	a5,a5,s0
    800045cc:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800045d0:	e5040593          	addi	a1,s0,-432
    800045d4:	f5040513          	addi	a0,s0,-176
    800045d8:	ba8ff0ef          	jal	80003980 <exec>
    800045dc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045de:	f5040993          	addi	s3,s0,-176
    800045e2:	6088                	ld	a0,0(s1)
    800045e4:	c511                	beqz	a0,800045f0 <sys_exec+0xd6>
    kfree(argv[i]);
    800045e6:	a37fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045ea:	04a1                	addi	s1,s1,8
    800045ec:	ff349be3          	bne	s1,s3,800045e2 <sys_exec+0xc8>
  return ret;
    800045f0:	854a                	mv	a0,s2
    800045f2:	74ba                	ld	s1,424(sp)
    800045f4:	791a                	ld	s2,416(sp)
    800045f6:	69fa                	ld	s3,408(sp)
    800045f8:	6a5a                	ld	s4,400(sp)
    800045fa:	a031                	j	80004606 <sys_exec+0xec>
  return -1;
    800045fc:	557d                	li	a0,-1
    800045fe:	74ba                	ld	s1,424(sp)
    80004600:	791a                	ld	s2,416(sp)
    80004602:	69fa                	ld	s3,408(sp)
    80004604:	6a5a                	ld	s4,400(sp)
}
    80004606:	70fa                	ld	ra,440(sp)
    80004608:	745a                	ld	s0,432(sp)
    8000460a:	6139                	addi	sp,sp,448
    8000460c:	8082                	ret

000000008000460e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000460e:	7139                	addi	sp,sp,-64
    80004610:	fc06                	sd	ra,56(sp)
    80004612:	f822                	sd	s0,48(sp)
    80004614:	f426                	sd	s1,40(sp)
    80004616:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004618:	f3efc0ef          	jal	80000d56 <myproc>
    8000461c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000461e:	fd840593          	addi	a1,s0,-40
    80004622:	4501                	li	a0,0
    80004624:	e0efd0ef          	jal	80001c32 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004628:	fc840593          	addi	a1,s0,-56
    8000462c:	fd040513          	addi	a0,s0,-48
    80004630:	85cff0ef          	jal	8000368c <pipealloc>
    return -1;
    80004634:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004636:	0a054463          	bltz	a0,800046de <sys_pipe+0xd0>
  fd0 = -1;
    8000463a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000463e:	fd043503          	ld	a0,-48(s0)
    80004642:	f08ff0ef          	jal	80003d4a <fdalloc>
    80004646:	fca42223          	sw	a0,-60(s0)
    8000464a:	08054163          	bltz	a0,800046cc <sys_pipe+0xbe>
    8000464e:	fc843503          	ld	a0,-56(s0)
    80004652:	ef8ff0ef          	jal	80003d4a <fdalloc>
    80004656:	fca42023          	sw	a0,-64(s0)
    8000465a:	06054063          	bltz	a0,800046ba <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000465e:	4691                	li	a3,4
    80004660:	fc440613          	addi	a2,s0,-60
    80004664:	fd843583          	ld	a1,-40(s0)
    80004668:	68a8                	ld	a0,80(s1)
    8000466a:	b5cfc0ef          	jal	800009c6 <copyout>
    8000466e:	00054e63          	bltz	a0,8000468a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004672:	4691                	li	a3,4
    80004674:	fc040613          	addi	a2,s0,-64
    80004678:	fd843583          	ld	a1,-40(s0)
    8000467c:	0591                	addi	a1,a1,4
    8000467e:	68a8                	ld	a0,80(s1)
    80004680:	b46fc0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004684:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004686:	04055c63          	bgez	a0,800046de <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000468a:	fc442783          	lw	a5,-60(s0)
    8000468e:	07e9                	addi	a5,a5,26
    80004690:	078e                	slli	a5,a5,0x3
    80004692:	97a6                	add	a5,a5,s1
    80004694:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004698:	fc042783          	lw	a5,-64(s0)
    8000469c:	07e9                	addi	a5,a5,26
    8000469e:	078e                	slli	a5,a5,0x3
    800046a0:	94be                	add	s1,s1,a5
    800046a2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800046a6:	fd043503          	ld	a0,-48(s0)
    800046aa:	cd9fe0ef          	jal	80003382 <fileclose>
    fileclose(wf);
    800046ae:	fc843503          	ld	a0,-56(s0)
    800046b2:	cd1fe0ef          	jal	80003382 <fileclose>
    return -1;
    800046b6:	57fd                	li	a5,-1
    800046b8:	a01d                	j	800046de <sys_pipe+0xd0>
    if(fd0 >= 0)
    800046ba:	fc442783          	lw	a5,-60(s0)
    800046be:	0007c763          	bltz	a5,800046cc <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800046c2:	07e9                	addi	a5,a5,26
    800046c4:	078e                	slli	a5,a5,0x3
    800046c6:	97a6                	add	a5,a5,s1
    800046c8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800046cc:	fd043503          	ld	a0,-48(s0)
    800046d0:	cb3fe0ef          	jal	80003382 <fileclose>
    fileclose(wf);
    800046d4:	fc843503          	ld	a0,-56(s0)
    800046d8:	cabfe0ef          	jal	80003382 <fileclose>
    return -1;
    800046dc:	57fd                	li	a5,-1
}
    800046de:	853e                	mv	a0,a5
    800046e0:	70e2                	ld	ra,56(sp)
    800046e2:	7442                	ld	s0,48(sp)
    800046e4:	74a2                	ld	s1,40(sp)
    800046e6:	6121                	addi	sp,sp,64
    800046e8:	8082                	ret
    800046ea:	0000                	unimp
    800046ec:	0000                	unimp
	...

00000000800046f0 <kernelvec>:
    800046f0:	7111                	addi	sp,sp,-256
    800046f2:	e006                	sd	ra,0(sp)
    800046f4:	e40a                	sd	sp,8(sp)
    800046f6:	e80e                	sd	gp,16(sp)
    800046f8:	ec12                	sd	tp,24(sp)
    800046fa:	f016                	sd	t0,32(sp)
    800046fc:	f41a                	sd	t1,40(sp)
    800046fe:	f81e                	sd	t2,48(sp)
    80004700:	e4aa                	sd	a0,72(sp)
    80004702:	e8ae                	sd	a1,80(sp)
    80004704:	ecb2                	sd	a2,88(sp)
    80004706:	f0b6                	sd	a3,96(sp)
    80004708:	f4ba                	sd	a4,104(sp)
    8000470a:	f8be                	sd	a5,112(sp)
    8000470c:	fcc2                	sd	a6,120(sp)
    8000470e:	e146                	sd	a7,128(sp)
    80004710:	edf2                	sd	t3,216(sp)
    80004712:	f1f6                	sd	t4,224(sp)
    80004714:	f5fa                	sd	t5,232(sp)
    80004716:	f9fe                	sd	t6,240(sp)
    80004718:	b84fd0ef          	jal	80001a9c <kerneltrap>
    8000471c:	6082                	ld	ra,0(sp)
    8000471e:	6122                	ld	sp,8(sp)
    80004720:	61c2                	ld	gp,16(sp)
    80004722:	7282                	ld	t0,32(sp)
    80004724:	7322                	ld	t1,40(sp)
    80004726:	73c2                	ld	t2,48(sp)
    80004728:	6526                	ld	a0,72(sp)
    8000472a:	65c6                	ld	a1,80(sp)
    8000472c:	6666                	ld	a2,88(sp)
    8000472e:	7686                	ld	a3,96(sp)
    80004730:	7726                	ld	a4,104(sp)
    80004732:	77c6                	ld	a5,112(sp)
    80004734:	7866                	ld	a6,120(sp)
    80004736:	688a                	ld	a7,128(sp)
    80004738:	6e6e                	ld	t3,216(sp)
    8000473a:	7e8e                	ld	t4,224(sp)
    8000473c:	7f2e                	ld	t5,232(sp)
    8000473e:	7fce                	ld	t6,240(sp)
    80004740:	6111                	addi	sp,sp,256
    80004742:	10200073          	sret
	...

000000008000474e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000474e:	1141                	addi	sp,sp,-16
    80004750:	e422                	sd	s0,8(sp)
    80004752:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004754:	0c0007b7          	lui	a5,0xc000
    80004758:	4705                	li	a4,1
    8000475a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000475c:	0c0007b7          	lui	a5,0xc000
    80004760:	c3d8                	sw	a4,4(a5)
}
    80004762:	6422                	ld	s0,8(sp)
    80004764:	0141                	addi	sp,sp,16
    80004766:	8082                	ret

0000000080004768 <plicinithart>:

void
plicinithart(void)
{
    80004768:	1141                	addi	sp,sp,-16
    8000476a:	e406                	sd	ra,8(sp)
    8000476c:	e022                	sd	s0,0(sp)
    8000476e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004770:	dbafc0ef          	jal	80000d2a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004774:	0085171b          	slliw	a4,a0,0x8
    80004778:	0c0027b7          	lui	a5,0xc002
    8000477c:	97ba                	add	a5,a5,a4
    8000477e:	40200713          	li	a4,1026
    80004782:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004786:	00d5151b          	slliw	a0,a0,0xd
    8000478a:	0c2017b7          	lui	a5,0xc201
    8000478e:	97aa                	add	a5,a5,a0
    80004790:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004794:	60a2                	ld	ra,8(sp)
    80004796:	6402                	ld	s0,0(sp)
    80004798:	0141                	addi	sp,sp,16
    8000479a:	8082                	ret

000000008000479c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000479c:	1141                	addi	sp,sp,-16
    8000479e:	e406                	sd	ra,8(sp)
    800047a0:	e022                	sd	s0,0(sp)
    800047a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047a4:	d86fc0ef          	jal	80000d2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800047a8:	00d5151b          	slliw	a0,a0,0xd
    800047ac:	0c2017b7          	lui	a5,0xc201
    800047b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800047b2:	43c8                	lw	a0,4(a5)
    800047b4:	60a2                	ld	ra,8(sp)
    800047b6:	6402                	ld	s0,0(sp)
    800047b8:	0141                	addi	sp,sp,16
    800047ba:	8082                	ret

00000000800047bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800047bc:	1101                	addi	sp,sp,-32
    800047be:	ec06                	sd	ra,24(sp)
    800047c0:	e822                	sd	s0,16(sp)
    800047c2:	e426                	sd	s1,8(sp)
    800047c4:	1000                	addi	s0,sp,32
    800047c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800047c8:	d62fc0ef          	jal	80000d2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800047cc:	00d5151b          	slliw	a0,a0,0xd
    800047d0:	0c2017b7          	lui	a5,0xc201
    800047d4:	97aa                	add	a5,a5,a0
    800047d6:	c3c4                	sw	s1,4(a5)
}
    800047d8:	60e2                	ld	ra,24(sp)
    800047da:	6442                	ld	s0,16(sp)
    800047dc:	64a2                	ld	s1,8(sp)
    800047de:	6105                	addi	sp,sp,32
    800047e0:	8082                	ret

00000000800047e2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800047e2:	1141                	addi	sp,sp,-16
    800047e4:	e406                	sd	ra,8(sp)
    800047e6:	e022                	sd	s0,0(sp)
    800047e8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800047ea:	479d                	li	a5,7
    800047ec:	04a7ca63          	blt	a5,a0,80004840 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800047f0:	00017797          	auipc	a5,0x17
    800047f4:	ef078793          	addi	a5,a5,-272 # 8001b6e0 <disk>
    800047f8:	97aa                	add	a5,a5,a0
    800047fa:	0187c783          	lbu	a5,24(a5)
    800047fe:	e7b9                	bnez	a5,8000484c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004800:	00451693          	slli	a3,a0,0x4
    80004804:	00017797          	auipc	a5,0x17
    80004808:	edc78793          	addi	a5,a5,-292 # 8001b6e0 <disk>
    8000480c:	6398                	ld	a4,0(a5)
    8000480e:	9736                	add	a4,a4,a3
    80004810:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004814:	6398                	ld	a4,0(a5)
    80004816:	9736                	add	a4,a4,a3
    80004818:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000481c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004820:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004824:	97aa                	add	a5,a5,a0
    80004826:	4705                	li	a4,1
    80004828:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000482c:	00017517          	auipc	a0,0x17
    80004830:	ecc50513          	addi	a0,a0,-308 # 8001b6f8 <disk+0x18>
    80004834:	b49fc0ef          	jal	8000137c <wakeup>
}
    80004838:	60a2                	ld	ra,8(sp)
    8000483a:	6402                	ld	s0,0(sp)
    8000483c:	0141                	addi	sp,sp,16
    8000483e:	8082                	ret
    panic("free_desc 1");
    80004840:	00003517          	auipc	a0,0x3
    80004844:	ea050513          	addi	a0,a0,-352 # 800076e0 <etext+0x6e0>
    80004848:	43b000ef          	jal	80005482 <panic>
    panic("free_desc 2");
    8000484c:	00003517          	auipc	a0,0x3
    80004850:	ea450513          	addi	a0,a0,-348 # 800076f0 <etext+0x6f0>
    80004854:	42f000ef          	jal	80005482 <panic>

0000000080004858 <virtio_disk_init>:
{
    80004858:	1101                	addi	sp,sp,-32
    8000485a:	ec06                	sd	ra,24(sp)
    8000485c:	e822                	sd	s0,16(sp)
    8000485e:	e426                	sd	s1,8(sp)
    80004860:	e04a                	sd	s2,0(sp)
    80004862:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004864:	00003597          	auipc	a1,0x3
    80004868:	e9c58593          	addi	a1,a1,-356 # 80007700 <etext+0x700>
    8000486c:	00017517          	auipc	a0,0x17
    80004870:	f9c50513          	addi	a0,a0,-100 # 8001b808 <disk+0x128>
    80004874:	6bd000ef          	jal	80005730 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004878:	100017b7          	lui	a5,0x10001
    8000487c:	4398                	lw	a4,0(a5)
    8000487e:	2701                	sext.w	a4,a4
    80004880:	747277b7          	lui	a5,0x74727
    80004884:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004888:	18f71063          	bne	a4,a5,80004a08 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000488c:	100017b7          	lui	a5,0x10001
    80004890:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004892:	439c                	lw	a5,0(a5)
    80004894:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004896:	4709                	li	a4,2
    80004898:	16e79863          	bne	a5,a4,80004a08 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000489c:	100017b7          	lui	a5,0x10001
    800048a0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800048a2:	439c                	lw	a5,0(a5)
    800048a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800048a6:	16e79163          	bne	a5,a4,80004a08 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800048aa:	100017b7          	lui	a5,0x10001
    800048ae:	47d8                	lw	a4,12(a5)
    800048b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048b2:	554d47b7          	lui	a5,0x554d4
    800048b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800048ba:	14f71763          	bne	a4,a5,80004a08 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048be:	100017b7          	lui	a5,0x10001
    800048c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048c6:	4705                	li	a4,1
    800048c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048ca:	470d                	li	a4,3
    800048cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800048ce:	10001737          	lui	a4,0x10001
    800048d2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800048d4:	c7ffe737          	lui	a4,0xc7ffe
    800048d8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdae3f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800048dc:	8ef9                	and	a3,a3,a4
    800048de:	10001737          	lui	a4,0x10001
    800048e2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048e4:	472d                	li	a4,11
    800048e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048e8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800048ec:	439c                	lw	a5,0(a5)
    800048ee:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800048f2:	8ba1                	andi	a5,a5,8
    800048f4:	12078063          	beqz	a5,80004a14 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800048f8:	100017b7          	lui	a5,0x10001
    800048fc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004900:	100017b7          	lui	a5,0x10001
    80004904:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004908:	439c                	lw	a5,0(a5)
    8000490a:	2781                	sext.w	a5,a5
    8000490c:	10079a63          	bnez	a5,80004a20 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004910:	100017b7          	lui	a5,0x10001
    80004914:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004918:	439c                	lw	a5,0(a5)
    8000491a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000491c:	10078863          	beqz	a5,80004a2c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004920:	471d                	li	a4,7
    80004922:	10f77b63          	bgeu	a4,a5,80004a38 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004926:	fd0fb0ef          	jal	800000f6 <kalloc>
    8000492a:	00017497          	auipc	s1,0x17
    8000492e:	db648493          	addi	s1,s1,-586 # 8001b6e0 <disk>
    80004932:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004934:	fc2fb0ef          	jal	800000f6 <kalloc>
    80004938:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000493a:	fbcfb0ef          	jal	800000f6 <kalloc>
    8000493e:	87aa                	mv	a5,a0
    80004940:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004942:	6088                	ld	a0,0(s1)
    80004944:	10050063          	beqz	a0,80004a44 <virtio_disk_init+0x1ec>
    80004948:	00017717          	auipc	a4,0x17
    8000494c:	da073703          	ld	a4,-608(a4) # 8001b6e8 <disk+0x8>
    80004950:	0e070a63          	beqz	a4,80004a44 <virtio_disk_init+0x1ec>
    80004954:	0e078863          	beqz	a5,80004a44 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004958:	6605                	lui	a2,0x1
    8000495a:	4581                	li	a1,0
    8000495c:	fd8fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004960:	00017497          	auipc	s1,0x17
    80004964:	d8048493          	addi	s1,s1,-640 # 8001b6e0 <disk>
    80004968:	6605                	lui	a2,0x1
    8000496a:	4581                	li	a1,0
    8000496c:	6488                	ld	a0,8(s1)
    8000496e:	fc6fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    80004972:	6605                	lui	a2,0x1
    80004974:	4581                	li	a1,0
    80004976:	6888                	ld	a0,16(s1)
    80004978:	fbcfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000497c:	100017b7          	lui	a5,0x10001
    80004980:	4721                	li	a4,8
    80004982:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004984:	4098                	lw	a4,0(s1)
    80004986:	100017b7          	lui	a5,0x10001
    8000498a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000498e:	40d8                	lw	a4,4(s1)
    80004990:	100017b7          	lui	a5,0x10001
    80004994:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004998:	649c                	ld	a5,8(s1)
    8000499a:	0007869b          	sext.w	a3,a5
    8000499e:	10001737          	lui	a4,0x10001
    800049a2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800049a6:	9781                	srai	a5,a5,0x20
    800049a8:	10001737          	lui	a4,0x10001
    800049ac:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800049b0:	689c                	ld	a5,16(s1)
    800049b2:	0007869b          	sext.w	a3,a5
    800049b6:	10001737          	lui	a4,0x10001
    800049ba:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800049be:	9781                	srai	a5,a5,0x20
    800049c0:	10001737          	lui	a4,0x10001
    800049c4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800049c8:	10001737          	lui	a4,0x10001
    800049cc:	4785                	li	a5,1
    800049ce:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800049d0:	00f48c23          	sb	a5,24(s1)
    800049d4:	00f48ca3          	sb	a5,25(s1)
    800049d8:	00f48d23          	sb	a5,26(s1)
    800049dc:	00f48da3          	sb	a5,27(s1)
    800049e0:	00f48e23          	sb	a5,28(s1)
    800049e4:	00f48ea3          	sb	a5,29(s1)
    800049e8:	00f48f23          	sb	a5,30(s1)
    800049ec:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800049f0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800049f4:	100017b7          	lui	a5,0x10001
    800049f8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800049fc:	60e2                	ld	ra,24(sp)
    800049fe:	6442                	ld	s0,16(sp)
    80004a00:	64a2                	ld	s1,8(sp)
    80004a02:	6902                	ld	s2,0(sp)
    80004a04:	6105                	addi	sp,sp,32
    80004a06:	8082                	ret
    panic("could not find virtio disk");
    80004a08:	00003517          	auipc	a0,0x3
    80004a0c:	d0850513          	addi	a0,a0,-760 # 80007710 <etext+0x710>
    80004a10:	273000ef          	jal	80005482 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004a14:	00003517          	auipc	a0,0x3
    80004a18:	d1c50513          	addi	a0,a0,-740 # 80007730 <etext+0x730>
    80004a1c:	267000ef          	jal	80005482 <panic>
    panic("virtio disk should not be ready");
    80004a20:	00003517          	auipc	a0,0x3
    80004a24:	d3050513          	addi	a0,a0,-720 # 80007750 <etext+0x750>
    80004a28:	25b000ef          	jal	80005482 <panic>
    panic("virtio disk has no queue 0");
    80004a2c:	00003517          	auipc	a0,0x3
    80004a30:	d4450513          	addi	a0,a0,-700 # 80007770 <etext+0x770>
    80004a34:	24f000ef          	jal	80005482 <panic>
    panic("virtio disk max queue too short");
    80004a38:	00003517          	auipc	a0,0x3
    80004a3c:	d5850513          	addi	a0,a0,-680 # 80007790 <etext+0x790>
    80004a40:	243000ef          	jal	80005482 <panic>
    panic("virtio disk kalloc");
    80004a44:	00003517          	auipc	a0,0x3
    80004a48:	d6c50513          	addi	a0,a0,-660 # 800077b0 <etext+0x7b0>
    80004a4c:	237000ef          	jal	80005482 <panic>

0000000080004a50 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004a50:	7159                	addi	sp,sp,-112
    80004a52:	f486                	sd	ra,104(sp)
    80004a54:	f0a2                	sd	s0,96(sp)
    80004a56:	eca6                	sd	s1,88(sp)
    80004a58:	e8ca                	sd	s2,80(sp)
    80004a5a:	e4ce                	sd	s3,72(sp)
    80004a5c:	e0d2                	sd	s4,64(sp)
    80004a5e:	fc56                	sd	s5,56(sp)
    80004a60:	f85a                	sd	s6,48(sp)
    80004a62:	f45e                	sd	s7,40(sp)
    80004a64:	f062                	sd	s8,32(sp)
    80004a66:	ec66                	sd	s9,24(sp)
    80004a68:	1880                	addi	s0,sp,112
    80004a6a:	8a2a                	mv	s4,a0
    80004a6c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004a6e:	00c52c83          	lw	s9,12(a0)
    80004a72:	001c9c9b          	slliw	s9,s9,0x1
    80004a76:	1c82                	slli	s9,s9,0x20
    80004a78:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004a7c:	00017517          	auipc	a0,0x17
    80004a80:	d8c50513          	addi	a0,a0,-628 # 8001b808 <disk+0x128>
    80004a84:	52d000ef          	jal	800057b0 <acquire>
  for(int i = 0; i < 3; i++){
    80004a88:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004a8a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004a8c:	00017b17          	auipc	s6,0x17
    80004a90:	c54b0b13          	addi	s6,s6,-940 # 8001b6e0 <disk>
  for(int i = 0; i < 3; i++){
    80004a94:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a96:	00017c17          	auipc	s8,0x17
    80004a9a:	d72c0c13          	addi	s8,s8,-654 # 8001b808 <disk+0x128>
    80004a9e:	a8b9                	j	80004afc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004aa0:	00fb0733          	add	a4,s6,a5
    80004aa4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004aa8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004aaa:	0207c563          	bltz	a5,80004ad4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004aae:	2905                	addiw	s2,s2,1
    80004ab0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004ab2:	05590963          	beq	s2,s5,80004b04 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004ab6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004ab8:	00017717          	auipc	a4,0x17
    80004abc:	c2870713          	addi	a4,a4,-984 # 8001b6e0 <disk>
    80004ac0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004ac2:	01874683          	lbu	a3,24(a4)
    80004ac6:	fee9                	bnez	a3,80004aa0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004ac8:	2785                	addiw	a5,a5,1
    80004aca:	0705                	addi	a4,a4,1
    80004acc:	fe979be3          	bne	a5,s1,80004ac2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004ad0:	57fd                	li	a5,-1
    80004ad2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004ad4:	01205d63          	blez	s2,80004aee <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004ad8:	f9042503          	lw	a0,-112(s0)
    80004adc:	d07ff0ef          	jal	800047e2 <free_desc>
      for(int j = 0; j < i; j++)
    80004ae0:	4785                	li	a5,1
    80004ae2:	0127d663          	bge	a5,s2,80004aee <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004ae6:	f9442503          	lw	a0,-108(s0)
    80004aea:	cf9ff0ef          	jal	800047e2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004aee:	85e2                	mv	a1,s8
    80004af0:	00017517          	auipc	a0,0x17
    80004af4:	c0850513          	addi	a0,a0,-1016 # 8001b6f8 <disk+0x18>
    80004af8:	839fc0ef          	jal	80001330 <sleep>
  for(int i = 0; i < 3; i++){
    80004afc:	f9040613          	addi	a2,s0,-112
    80004b00:	894e                	mv	s2,s3
    80004b02:	bf55                	j	80004ab6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b04:	f9042503          	lw	a0,-112(s0)
    80004b08:	00451693          	slli	a3,a0,0x4

  if(write)
    80004b0c:	00017797          	auipc	a5,0x17
    80004b10:	bd478793          	addi	a5,a5,-1068 # 8001b6e0 <disk>
    80004b14:	00a50713          	addi	a4,a0,10
    80004b18:	0712                	slli	a4,a4,0x4
    80004b1a:	973e                	add	a4,a4,a5
    80004b1c:	01703633          	snez	a2,s7
    80004b20:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004b22:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004b26:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b2a:	6398                	ld	a4,0(a5)
    80004b2c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b2e:	0a868613          	addi	a2,a3,168
    80004b32:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b34:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004b36:	6390                	ld	a2,0(a5)
    80004b38:	00d605b3          	add	a1,a2,a3
    80004b3c:	4741                	li	a4,16
    80004b3e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004b40:	4805                	li	a6,1
    80004b42:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004b46:	f9442703          	lw	a4,-108(s0)
    80004b4a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004b4e:	0712                	slli	a4,a4,0x4
    80004b50:	963a                	add	a2,a2,a4
    80004b52:	058a0593          	addi	a1,s4,88
    80004b56:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004b58:	0007b883          	ld	a7,0(a5)
    80004b5c:	9746                	add	a4,a4,a7
    80004b5e:	40000613          	li	a2,1024
    80004b62:	c710                	sw	a2,8(a4)
  if(write)
    80004b64:	001bb613          	seqz	a2,s7
    80004b68:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004b6c:	00166613          	ori	a2,a2,1
    80004b70:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004b74:	f9842583          	lw	a1,-104(s0)
    80004b78:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004b7c:	00250613          	addi	a2,a0,2
    80004b80:	0612                	slli	a2,a2,0x4
    80004b82:	963e                	add	a2,a2,a5
    80004b84:	577d                	li	a4,-1
    80004b86:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004b8a:	0592                	slli	a1,a1,0x4
    80004b8c:	98ae                	add	a7,a7,a1
    80004b8e:	03068713          	addi	a4,a3,48
    80004b92:	973e                	add	a4,a4,a5
    80004b94:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004b98:	6398                	ld	a4,0(a5)
    80004b9a:	972e                	add	a4,a4,a1
    80004b9c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004ba0:	4689                	li	a3,2
    80004ba2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004ba6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004baa:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004bae:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004bb2:	6794                	ld	a3,8(a5)
    80004bb4:	0026d703          	lhu	a4,2(a3)
    80004bb8:	8b1d                	andi	a4,a4,7
    80004bba:	0706                	slli	a4,a4,0x1
    80004bbc:	96ba                	add	a3,a3,a4
    80004bbe:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004bc2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004bc6:	6798                	ld	a4,8(a5)
    80004bc8:	00275783          	lhu	a5,2(a4)
    80004bcc:	2785                	addiw	a5,a5,1
    80004bce:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004bd2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004bd6:	100017b7          	lui	a5,0x10001
    80004bda:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004bde:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004be2:	00017917          	auipc	s2,0x17
    80004be6:	c2690913          	addi	s2,s2,-986 # 8001b808 <disk+0x128>
  while(b->disk == 1) {
    80004bea:	4485                	li	s1,1
    80004bec:	01079a63          	bne	a5,a6,80004c00 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004bf0:	85ca                	mv	a1,s2
    80004bf2:	8552                	mv	a0,s4
    80004bf4:	f3cfc0ef          	jal	80001330 <sleep>
  while(b->disk == 1) {
    80004bf8:	004a2783          	lw	a5,4(s4)
    80004bfc:	fe978ae3          	beq	a5,s1,80004bf0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004c00:	f9042903          	lw	s2,-112(s0)
    80004c04:	00290713          	addi	a4,s2,2
    80004c08:	0712                	slli	a4,a4,0x4
    80004c0a:	00017797          	auipc	a5,0x17
    80004c0e:	ad678793          	addi	a5,a5,-1322 # 8001b6e0 <disk>
    80004c12:	97ba                	add	a5,a5,a4
    80004c14:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004c18:	00017997          	auipc	s3,0x17
    80004c1c:	ac898993          	addi	s3,s3,-1336 # 8001b6e0 <disk>
    80004c20:	00491713          	slli	a4,s2,0x4
    80004c24:	0009b783          	ld	a5,0(s3)
    80004c28:	97ba                	add	a5,a5,a4
    80004c2a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004c2e:	854a                	mv	a0,s2
    80004c30:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004c34:	bafff0ef          	jal	800047e2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004c38:	8885                	andi	s1,s1,1
    80004c3a:	f0fd                	bnez	s1,80004c20 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004c3c:	00017517          	auipc	a0,0x17
    80004c40:	bcc50513          	addi	a0,a0,-1076 # 8001b808 <disk+0x128>
    80004c44:	405000ef          	jal	80005848 <release>
}
    80004c48:	70a6                	ld	ra,104(sp)
    80004c4a:	7406                	ld	s0,96(sp)
    80004c4c:	64e6                	ld	s1,88(sp)
    80004c4e:	6946                	ld	s2,80(sp)
    80004c50:	69a6                	ld	s3,72(sp)
    80004c52:	6a06                	ld	s4,64(sp)
    80004c54:	7ae2                	ld	s5,56(sp)
    80004c56:	7b42                	ld	s6,48(sp)
    80004c58:	7ba2                	ld	s7,40(sp)
    80004c5a:	7c02                	ld	s8,32(sp)
    80004c5c:	6ce2                	ld	s9,24(sp)
    80004c5e:	6165                	addi	sp,sp,112
    80004c60:	8082                	ret

0000000080004c62 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004c62:	1101                	addi	sp,sp,-32
    80004c64:	ec06                	sd	ra,24(sp)
    80004c66:	e822                	sd	s0,16(sp)
    80004c68:	e426                	sd	s1,8(sp)
    80004c6a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004c6c:	00017497          	auipc	s1,0x17
    80004c70:	a7448493          	addi	s1,s1,-1420 # 8001b6e0 <disk>
    80004c74:	00017517          	auipc	a0,0x17
    80004c78:	b9450513          	addi	a0,a0,-1132 # 8001b808 <disk+0x128>
    80004c7c:	335000ef          	jal	800057b0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004c80:	100017b7          	lui	a5,0x10001
    80004c84:	53b8                	lw	a4,96(a5)
    80004c86:	8b0d                	andi	a4,a4,3
    80004c88:	100017b7          	lui	a5,0x10001
    80004c8c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004c8e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004c92:	689c                	ld	a5,16(s1)
    80004c94:	0204d703          	lhu	a4,32(s1)
    80004c98:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004c9c:	04f70663          	beq	a4,a5,80004ce8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004ca0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004ca4:	6898                	ld	a4,16(s1)
    80004ca6:	0204d783          	lhu	a5,32(s1)
    80004caa:	8b9d                	andi	a5,a5,7
    80004cac:	078e                	slli	a5,a5,0x3
    80004cae:	97ba                	add	a5,a5,a4
    80004cb0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004cb2:	00278713          	addi	a4,a5,2
    80004cb6:	0712                	slli	a4,a4,0x4
    80004cb8:	9726                	add	a4,a4,s1
    80004cba:	01074703          	lbu	a4,16(a4)
    80004cbe:	e321                	bnez	a4,80004cfe <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004cc0:	0789                	addi	a5,a5,2
    80004cc2:	0792                	slli	a5,a5,0x4
    80004cc4:	97a6                	add	a5,a5,s1
    80004cc6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004cc8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004ccc:	eb0fc0ef          	jal	8000137c <wakeup>

    disk.used_idx += 1;
    80004cd0:	0204d783          	lhu	a5,32(s1)
    80004cd4:	2785                	addiw	a5,a5,1
    80004cd6:	17c2                	slli	a5,a5,0x30
    80004cd8:	93c1                	srli	a5,a5,0x30
    80004cda:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004cde:	6898                	ld	a4,16(s1)
    80004ce0:	00275703          	lhu	a4,2(a4)
    80004ce4:	faf71ee3          	bne	a4,a5,80004ca0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004ce8:	00017517          	auipc	a0,0x17
    80004cec:	b2050513          	addi	a0,a0,-1248 # 8001b808 <disk+0x128>
    80004cf0:	359000ef          	jal	80005848 <release>
}
    80004cf4:	60e2                	ld	ra,24(sp)
    80004cf6:	6442                	ld	s0,16(sp)
    80004cf8:	64a2                	ld	s1,8(sp)
    80004cfa:	6105                	addi	sp,sp,32
    80004cfc:	8082                	ret
      panic("virtio_disk_intr status");
    80004cfe:	00003517          	auipc	a0,0x3
    80004d02:	aca50513          	addi	a0,a0,-1334 # 800077c8 <etext+0x7c8>
    80004d06:	77c000ef          	jal	80005482 <panic>

0000000080004d0a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d0a:	1141                	addi	sp,sp,-16
    80004d0c:	e422                	sd	s0,8(sp)
    80004d0e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004d10:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004d14:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004d18:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004d1c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004d20:	577d                	li	a4,-1
    80004d22:	177e                	slli	a4,a4,0x3f
    80004d24:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004d26:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004d2a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004d2e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004d32:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004d36:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004d3a:	000f4737          	lui	a4,0xf4
    80004d3e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004d42:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004d44:	14d79073          	csrw	stimecmp,a5
}
    80004d48:	6422                	ld	s0,8(sp)
    80004d4a:	0141                	addi	sp,sp,16
    80004d4c:	8082                	ret

0000000080004d4e <start>:
{
    80004d4e:	1141                	addi	sp,sp,-16
    80004d50:	e406                	sd	ra,8(sp)
    80004d52:	e022                	sd	s0,0(sp)
    80004d54:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004d56:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004d5a:	7779                	lui	a4,0xffffe
    80004d5c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaedf>
    80004d60:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004d62:	6705                	lui	a4,0x1
    80004d64:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004d68:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004d6a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004d6e:	ffffb797          	auipc	a5,0xffffb
    80004d72:	56078793          	addi	a5,a5,1376 # 800002ce <main>
    80004d76:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004d7a:	4781                	li	a5,0
    80004d7c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004d80:	67c1                	lui	a5,0x10
    80004d82:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004d84:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004d88:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004d8c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004d90:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004d94:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004d98:	57fd                	li	a5,-1
    80004d9a:	83a9                	srli	a5,a5,0xa
    80004d9c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004da0:	47bd                	li	a5,15
    80004da2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004da6:	f65ff0ef          	jal	80004d0a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004daa:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004dae:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004db0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004db2:	30200073          	mret
}
    80004db6:	60a2                	ld	ra,8(sp)
    80004db8:	6402                	ld	s0,0(sp)
    80004dba:	0141                	addi	sp,sp,16
    80004dbc:	8082                	ret

0000000080004dbe <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004dbe:	715d                	addi	sp,sp,-80
    80004dc0:	e486                	sd	ra,72(sp)
    80004dc2:	e0a2                	sd	s0,64(sp)
    80004dc4:	f84a                	sd	s2,48(sp)
    80004dc6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004dc8:	04c05263          	blez	a2,80004e0c <consolewrite+0x4e>
    80004dcc:	fc26                	sd	s1,56(sp)
    80004dce:	f44e                	sd	s3,40(sp)
    80004dd0:	f052                	sd	s4,32(sp)
    80004dd2:	ec56                	sd	s5,24(sp)
    80004dd4:	8a2a                	mv	s4,a0
    80004dd6:	84ae                	mv	s1,a1
    80004dd8:	89b2                	mv	s3,a2
    80004dda:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004ddc:	5afd                	li	s5,-1
    80004dde:	4685                	li	a3,1
    80004de0:	8626                	mv	a2,s1
    80004de2:	85d2                	mv	a1,s4
    80004de4:	fbf40513          	addi	a0,s0,-65
    80004de8:	8effc0ef          	jal	800016d6 <either_copyin>
    80004dec:	03550263          	beq	a0,s5,80004e10 <consolewrite+0x52>
      break;
    uartputc(c);
    80004df0:	fbf44503          	lbu	a0,-65(s0)
    80004df4:	035000ef          	jal	80005628 <uartputc>
  for(i = 0; i < n; i++){
    80004df8:	2905                	addiw	s2,s2,1
    80004dfa:	0485                	addi	s1,s1,1
    80004dfc:	ff2991e3          	bne	s3,s2,80004dde <consolewrite+0x20>
    80004e00:	894e                	mv	s2,s3
    80004e02:	74e2                	ld	s1,56(sp)
    80004e04:	79a2                	ld	s3,40(sp)
    80004e06:	7a02                	ld	s4,32(sp)
    80004e08:	6ae2                	ld	s5,24(sp)
    80004e0a:	a039                	j	80004e18 <consolewrite+0x5a>
    80004e0c:	4901                	li	s2,0
    80004e0e:	a029                	j	80004e18 <consolewrite+0x5a>
    80004e10:	74e2                	ld	s1,56(sp)
    80004e12:	79a2                	ld	s3,40(sp)
    80004e14:	7a02                	ld	s4,32(sp)
    80004e16:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004e18:	854a                	mv	a0,s2
    80004e1a:	60a6                	ld	ra,72(sp)
    80004e1c:	6406                	ld	s0,64(sp)
    80004e1e:	7942                	ld	s2,48(sp)
    80004e20:	6161                	addi	sp,sp,80
    80004e22:	8082                	ret

0000000080004e24 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004e24:	711d                	addi	sp,sp,-96
    80004e26:	ec86                	sd	ra,88(sp)
    80004e28:	e8a2                	sd	s0,80(sp)
    80004e2a:	e4a6                	sd	s1,72(sp)
    80004e2c:	e0ca                	sd	s2,64(sp)
    80004e2e:	fc4e                	sd	s3,56(sp)
    80004e30:	f852                	sd	s4,48(sp)
    80004e32:	f456                	sd	s5,40(sp)
    80004e34:	f05a                	sd	s6,32(sp)
    80004e36:	1080                	addi	s0,sp,96
    80004e38:	8aaa                	mv	s5,a0
    80004e3a:	8a2e                	mv	s4,a1
    80004e3c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004e3e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004e42:	0001f517          	auipc	a0,0x1f
    80004e46:	9de50513          	addi	a0,a0,-1570 # 80023820 <cons>
    80004e4a:	167000ef          	jal	800057b0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004e4e:	0001f497          	auipc	s1,0x1f
    80004e52:	9d248493          	addi	s1,s1,-1582 # 80023820 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004e56:	0001f917          	auipc	s2,0x1f
    80004e5a:	a6290913          	addi	s2,s2,-1438 # 800238b8 <cons+0x98>
  while(n > 0){
    80004e5e:	0b305d63          	blez	s3,80004f18 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004e62:	0984a783          	lw	a5,152(s1)
    80004e66:	09c4a703          	lw	a4,156(s1)
    80004e6a:	0af71263          	bne	a4,a5,80004f0e <consoleread+0xea>
      if(killed(myproc())){
    80004e6e:	ee9fb0ef          	jal	80000d56 <myproc>
    80004e72:	ef6fc0ef          	jal	80001568 <killed>
    80004e76:	e12d                	bnez	a0,80004ed8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004e78:	85a6                	mv	a1,s1
    80004e7a:	854a                	mv	a0,s2
    80004e7c:	cb4fc0ef          	jal	80001330 <sleep>
    while(cons.r == cons.w){
    80004e80:	0984a783          	lw	a5,152(s1)
    80004e84:	09c4a703          	lw	a4,156(s1)
    80004e88:	fef703e3          	beq	a4,a5,80004e6e <consoleread+0x4a>
    80004e8c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004e8e:	0001f717          	auipc	a4,0x1f
    80004e92:	99270713          	addi	a4,a4,-1646 # 80023820 <cons>
    80004e96:	0017869b          	addiw	a3,a5,1
    80004e9a:	08d72c23          	sw	a3,152(a4)
    80004e9e:	07f7f693          	andi	a3,a5,127
    80004ea2:	9736                	add	a4,a4,a3
    80004ea4:	01874703          	lbu	a4,24(a4)
    80004ea8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004eac:	4691                	li	a3,4
    80004eae:	04db8663          	beq	s7,a3,80004efa <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004eb2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004eb6:	4685                	li	a3,1
    80004eb8:	faf40613          	addi	a2,s0,-81
    80004ebc:	85d2                	mv	a1,s4
    80004ebe:	8556                	mv	a0,s5
    80004ec0:	fccfc0ef          	jal	8000168c <either_copyout>
    80004ec4:	57fd                	li	a5,-1
    80004ec6:	04f50863          	beq	a0,a5,80004f16 <consoleread+0xf2>
      break;

    dst++;
    80004eca:	0a05                	addi	s4,s4,1
    --n;
    80004ecc:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004ece:	47a9                	li	a5,10
    80004ed0:	04fb8d63          	beq	s7,a5,80004f2a <consoleread+0x106>
    80004ed4:	6be2                	ld	s7,24(sp)
    80004ed6:	b761                	j	80004e5e <consoleread+0x3a>
        release(&cons.lock);
    80004ed8:	0001f517          	auipc	a0,0x1f
    80004edc:	94850513          	addi	a0,a0,-1720 # 80023820 <cons>
    80004ee0:	169000ef          	jal	80005848 <release>
        return -1;
    80004ee4:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004ee6:	60e6                	ld	ra,88(sp)
    80004ee8:	6446                	ld	s0,80(sp)
    80004eea:	64a6                	ld	s1,72(sp)
    80004eec:	6906                	ld	s2,64(sp)
    80004eee:	79e2                	ld	s3,56(sp)
    80004ef0:	7a42                	ld	s4,48(sp)
    80004ef2:	7aa2                	ld	s5,40(sp)
    80004ef4:	7b02                	ld	s6,32(sp)
    80004ef6:	6125                	addi	sp,sp,96
    80004ef8:	8082                	ret
      if(n < target){
    80004efa:	0009871b          	sext.w	a4,s3
    80004efe:	01677a63          	bgeu	a4,s6,80004f12 <consoleread+0xee>
        cons.r--;
    80004f02:	0001f717          	auipc	a4,0x1f
    80004f06:	9af72b23          	sw	a5,-1610(a4) # 800238b8 <cons+0x98>
    80004f0a:	6be2                	ld	s7,24(sp)
    80004f0c:	a031                	j	80004f18 <consoleread+0xf4>
    80004f0e:	ec5e                	sd	s7,24(sp)
    80004f10:	bfbd                	j	80004e8e <consoleread+0x6a>
    80004f12:	6be2                	ld	s7,24(sp)
    80004f14:	a011                	j	80004f18 <consoleread+0xf4>
    80004f16:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004f18:	0001f517          	auipc	a0,0x1f
    80004f1c:	90850513          	addi	a0,a0,-1784 # 80023820 <cons>
    80004f20:	129000ef          	jal	80005848 <release>
  return target - n;
    80004f24:	413b053b          	subw	a0,s6,s3
    80004f28:	bf7d                	j	80004ee6 <consoleread+0xc2>
    80004f2a:	6be2                	ld	s7,24(sp)
    80004f2c:	b7f5                	j	80004f18 <consoleread+0xf4>

0000000080004f2e <consputc>:
{
    80004f2e:	1141                	addi	sp,sp,-16
    80004f30:	e406                	sd	ra,8(sp)
    80004f32:	e022                	sd	s0,0(sp)
    80004f34:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004f36:	10000793          	li	a5,256
    80004f3a:	00f50863          	beq	a0,a5,80004f4a <consputc+0x1c>
    uartputc_sync(c);
    80004f3e:	604000ef          	jal	80005542 <uartputc_sync>
}
    80004f42:	60a2                	ld	ra,8(sp)
    80004f44:	6402                	ld	s0,0(sp)
    80004f46:	0141                	addi	sp,sp,16
    80004f48:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004f4a:	4521                	li	a0,8
    80004f4c:	5f6000ef          	jal	80005542 <uartputc_sync>
    80004f50:	02000513          	li	a0,32
    80004f54:	5ee000ef          	jal	80005542 <uartputc_sync>
    80004f58:	4521                	li	a0,8
    80004f5a:	5e8000ef          	jal	80005542 <uartputc_sync>
    80004f5e:	b7d5                	j	80004f42 <consputc+0x14>

0000000080004f60 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004f60:	1101                	addi	sp,sp,-32
    80004f62:	ec06                	sd	ra,24(sp)
    80004f64:	e822                	sd	s0,16(sp)
    80004f66:	e426                	sd	s1,8(sp)
    80004f68:	1000                	addi	s0,sp,32
    80004f6a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004f6c:	0001f517          	auipc	a0,0x1f
    80004f70:	8b450513          	addi	a0,a0,-1868 # 80023820 <cons>
    80004f74:	03d000ef          	jal	800057b0 <acquire>

  switch(c){
    80004f78:	47d5                	li	a5,21
    80004f7a:	08f48f63          	beq	s1,a5,80005018 <consoleintr+0xb8>
    80004f7e:	0297c563          	blt	a5,s1,80004fa8 <consoleintr+0x48>
    80004f82:	47a1                	li	a5,8
    80004f84:	0ef48463          	beq	s1,a5,8000506c <consoleintr+0x10c>
    80004f88:	47c1                	li	a5,16
    80004f8a:	10f49563          	bne	s1,a5,80005094 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80004f8e:	f92fc0ef          	jal	80001720 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004f92:	0001f517          	auipc	a0,0x1f
    80004f96:	88e50513          	addi	a0,a0,-1906 # 80023820 <cons>
    80004f9a:	0af000ef          	jal	80005848 <release>
}
    80004f9e:	60e2                	ld	ra,24(sp)
    80004fa0:	6442                	ld	s0,16(sp)
    80004fa2:	64a2                	ld	s1,8(sp)
    80004fa4:	6105                	addi	sp,sp,32
    80004fa6:	8082                	ret
  switch(c){
    80004fa8:	07f00793          	li	a5,127
    80004fac:	0cf48063          	beq	s1,a5,8000506c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004fb0:	0001f717          	auipc	a4,0x1f
    80004fb4:	87070713          	addi	a4,a4,-1936 # 80023820 <cons>
    80004fb8:	0a072783          	lw	a5,160(a4)
    80004fbc:	09872703          	lw	a4,152(a4)
    80004fc0:	9f99                	subw	a5,a5,a4
    80004fc2:	07f00713          	li	a4,127
    80004fc6:	fcf766e3          	bltu	a4,a5,80004f92 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004fca:	47b5                	li	a5,13
    80004fcc:	0cf48763          	beq	s1,a5,8000509a <consoleintr+0x13a>
      consputc(c);
    80004fd0:	8526                	mv	a0,s1
    80004fd2:	f5dff0ef          	jal	80004f2e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004fd6:	0001f797          	auipc	a5,0x1f
    80004fda:	84a78793          	addi	a5,a5,-1974 # 80023820 <cons>
    80004fde:	0a07a683          	lw	a3,160(a5)
    80004fe2:	0016871b          	addiw	a4,a3,1
    80004fe6:	0007061b          	sext.w	a2,a4
    80004fea:	0ae7a023          	sw	a4,160(a5)
    80004fee:	07f6f693          	andi	a3,a3,127
    80004ff2:	97b6                	add	a5,a5,a3
    80004ff4:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004ff8:	47a9                	li	a5,10
    80004ffa:	0cf48563          	beq	s1,a5,800050c4 <consoleintr+0x164>
    80004ffe:	4791                	li	a5,4
    80005000:	0cf48263          	beq	s1,a5,800050c4 <consoleintr+0x164>
    80005004:	0001f797          	auipc	a5,0x1f
    80005008:	8b47a783          	lw	a5,-1868(a5) # 800238b8 <cons+0x98>
    8000500c:	9f1d                	subw	a4,a4,a5
    8000500e:	08000793          	li	a5,128
    80005012:	f8f710e3          	bne	a4,a5,80004f92 <consoleintr+0x32>
    80005016:	a07d                	j	800050c4 <consoleintr+0x164>
    80005018:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000501a:	0001f717          	auipc	a4,0x1f
    8000501e:	80670713          	addi	a4,a4,-2042 # 80023820 <cons>
    80005022:	0a072783          	lw	a5,160(a4)
    80005026:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000502a:	0001e497          	auipc	s1,0x1e
    8000502e:	7f648493          	addi	s1,s1,2038 # 80023820 <cons>
    while(cons.e != cons.w &&
    80005032:	4929                	li	s2,10
    80005034:	02f70863          	beq	a4,a5,80005064 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005038:	37fd                	addiw	a5,a5,-1
    8000503a:	07f7f713          	andi	a4,a5,127
    8000503e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005040:	01874703          	lbu	a4,24(a4)
    80005044:	03270263          	beq	a4,s2,80005068 <consoleintr+0x108>
      cons.e--;
    80005048:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000504c:	10000513          	li	a0,256
    80005050:	edfff0ef          	jal	80004f2e <consputc>
    while(cons.e != cons.w &&
    80005054:	0a04a783          	lw	a5,160(s1)
    80005058:	09c4a703          	lw	a4,156(s1)
    8000505c:	fcf71ee3          	bne	a4,a5,80005038 <consoleintr+0xd8>
    80005060:	6902                	ld	s2,0(sp)
    80005062:	bf05                	j	80004f92 <consoleintr+0x32>
    80005064:	6902                	ld	s2,0(sp)
    80005066:	b735                	j	80004f92 <consoleintr+0x32>
    80005068:	6902                	ld	s2,0(sp)
    8000506a:	b725                	j	80004f92 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000506c:	0001e717          	auipc	a4,0x1e
    80005070:	7b470713          	addi	a4,a4,1972 # 80023820 <cons>
    80005074:	0a072783          	lw	a5,160(a4)
    80005078:	09c72703          	lw	a4,156(a4)
    8000507c:	f0f70be3          	beq	a4,a5,80004f92 <consoleintr+0x32>
      cons.e--;
    80005080:	37fd                	addiw	a5,a5,-1
    80005082:	0001f717          	auipc	a4,0x1f
    80005086:	82f72f23          	sw	a5,-1986(a4) # 800238c0 <cons+0xa0>
      consputc(BACKSPACE);
    8000508a:	10000513          	li	a0,256
    8000508e:	ea1ff0ef          	jal	80004f2e <consputc>
    80005092:	b701                	j	80004f92 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005094:	ee048fe3          	beqz	s1,80004f92 <consoleintr+0x32>
    80005098:	bf21                	j	80004fb0 <consoleintr+0x50>
      consputc(c);
    8000509a:	4529                	li	a0,10
    8000509c:	e93ff0ef          	jal	80004f2e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050a0:	0001e797          	auipc	a5,0x1e
    800050a4:	78078793          	addi	a5,a5,1920 # 80023820 <cons>
    800050a8:	0a07a703          	lw	a4,160(a5)
    800050ac:	0017069b          	addiw	a3,a4,1
    800050b0:	0006861b          	sext.w	a2,a3
    800050b4:	0ad7a023          	sw	a3,160(a5)
    800050b8:	07f77713          	andi	a4,a4,127
    800050bc:	97ba                	add	a5,a5,a4
    800050be:	4729                	li	a4,10
    800050c0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800050c4:	0001e797          	auipc	a5,0x1e
    800050c8:	7ec7ac23          	sw	a2,2040(a5) # 800238bc <cons+0x9c>
        wakeup(&cons.r);
    800050cc:	0001e517          	auipc	a0,0x1e
    800050d0:	7ec50513          	addi	a0,a0,2028 # 800238b8 <cons+0x98>
    800050d4:	aa8fc0ef          	jal	8000137c <wakeup>
    800050d8:	bd6d                	j	80004f92 <consoleintr+0x32>

00000000800050da <consoleinit>:

void
consoleinit(void)
{
    800050da:	1141                	addi	sp,sp,-16
    800050dc:	e406                	sd	ra,8(sp)
    800050de:	e022                	sd	s0,0(sp)
    800050e0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800050e2:	00002597          	auipc	a1,0x2
    800050e6:	6fe58593          	addi	a1,a1,1790 # 800077e0 <etext+0x7e0>
    800050ea:	0001e517          	auipc	a0,0x1e
    800050ee:	73650513          	addi	a0,a0,1846 # 80023820 <cons>
    800050f2:	63e000ef          	jal	80005730 <initlock>

  uartinit();
    800050f6:	3f4000ef          	jal	800054ea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800050fa:	00015797          	auipc	a5,0x15
    800050fe:	58e78793          	addi	a5,a5,1422 # 8001a688 <devsw>
    80005102:	00000717          	auipc	a4,0x0
    80005106:	d2270713          	addi	a4,a4,-734 # 80004e24 <consoleread>
    8000510a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000510c:	00000717          	auipc	a4,0x0
    80005110:	cb270713          	addi	a4,a4,-846 # 80004dbe <consolewrite>
    80005114:	ef98                	sd	a4,24(a5)
}
    80005116:	60a2                	ld	ra,8(sp)
    80005118:	6402                	ld	s0,0(sp)
    8000511a:	0141                	addi	sp,sp,16
    8000511c:	8082                	ret

000000008000511e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000511e:	7179                	addi	sp,sp,-48
    80005120:	f406                	sd	ra,40(sp)
    80005122:	f022                	sd	s0,32(sp)
    80005124:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005126:	c219                	beqz	a2,8000512c <printint+0xe>
    80005128:	08054063          	bltz	a0,800051a8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000512c:	4881                	li	a7,0
    8000512e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005132:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005134:	00003617          	auipc	a2,0x3
    80005138:	8cc60613          	addi	a2,a2,-1844 # 80007a00 <digits>
    8000513c:	883e                	mv	a6,a5
    8000513e:	2785                	addiw	a5,a5,1
    80005140:	02b57733          	remu	a4,a0,a1
    80005144:	9732                	add	a4,a4,a2
    80005146:	00074703          	lbu	a4,0(a4)
    8000514a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000514e:	872a                	mv	a4,a0
    80005150:	02b55533          	divu	a0,a0,a1
    80005154:	0685                	addi	a3,a3,1
    80005156:	feb773e3          	bgeu	a4,a1,8000513c <printint+0x1e>

  if(sign)
    8000515a:	00088a63          	beqz	a7,8000516e <printint+0x50>
    buf[i++] = '-';
    8000515e:	1781                	addi	a5,a5,-32
    80005160:	97a2                	add	a5,a5,s0
    80005162:	02d00713          	li	a4,45
    80005166:	fee78823          	sb	a4,-16(a5)
    8000516a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000516e:	02f05963          	blez	a5,800051a0 <printint+0x82>
    80005172:	ec26                	sd	s1,24(sp)
    80005174:	e84a                	sd	s2,16(sp)
    80005176:	fd040713          	addi	a4,s0,-48
    8000517a:	00f704b3          	add	s1,a4,a5
    8000517e:	fff70913          	addi	s2,a4,-1
    80005182:	993e                	add	s2,s2,a5
    80005184:	37fd                	addiw	a5,a5,-1
    80005186:	1782                	slli	a5,a5,0x20
    80005188:	9381                	srli	a5,a5,0x20
    8000518a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000518e:	fff4c503          	lbu	a0,-1(s1)
    80005192:	d9dff0ef          	jal	80004f2e <consputc>
  while(--i >= 0)
    80005196:	14fd                	addi	s1,s1,-1
    80005198:	ff249be3          	bne	s1,s2,8000518e <printint+0x70>
    8000519c:	64e2                	ld	s1,24(sp)
    8000519e:	6942                	ld	s2,16(sp)
}
    800051a0:	70a2                	ld	ra,40(sp)
    800051a2:	7402                	ld	s0,32(sp)
    800051a4:	6145                	addi	sp,sp,48
    800051a6:	8082                	ret
    x = -xx;
    800051a8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800051ac:	4885                	li	a7,1
    x = -xx;
    800051ae:	b741                	j	8000512e <printint+0x10>

00000000800051b0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800051b0:	7155                	addi	sp,sp,-208
    800051b2:	e506                	sd	ra,136(sp)
    800051b4:	e122                	sd	s0,128(sp)
    800051b6:	f0d2                	sd	s4,96(sp)
    800051b8:	0900                	addi	s0,sp,144
    800051ba:	8a2a                	mv	s4,a0
    800051bc:	e40c                	sd	a1,8(s0)
    800051be:	e810                	sd	a2,16(s0)
    800051c0:	ec14                	sd	a3,24(s0)
    800051c2:	f018                	sd	a4,32(s0)
    800051c4:	f41c                	sd	a5,40(s0)
    800051c6:	03043823          	sd	a6,48(s0)
    800051ca:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800051ce:	0001e797          	auipc	a5,0x1e
    800051d2:	7127a783          	lw	a5,1810(a5) # 800238e0 <pr+0x18>
    800051d6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800051da:	e3a1                	bnez	a5,8000521a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800051dc:	00840793          	addi	a5,s0,8
    800051e0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051e4:	00054503          	lbu	a0,0(a0)
    800051e8:	26050763          	beqz	a0,80005456 <printf+0x2a6>
    800051ec:	fca6                	sd	s1,120(sp)
    800051ee:	f8ca                	sd	s2,112(sp)
    800051f0:	f4ce                	sd	s3,104(sp)
    800051f2:	ecd6                	sd	s5,88(sp)
    800051f4:	e8da                	sd	s6,80(sp)
    800051f6:	e0e2                	sd	s8,64(sp)
    800051f8:	fc66                	sd	s9,56(sp)
    800051fa:	f86a                	sd	s10,48(sp)
    800051fc:	f46e                	sd	s11,40(sp)
    800051fe:	4981                	li	s3,0
    if(cx != '%'){
    80005200:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005204:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005208:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000520c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005210:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005214:	07000d93          	li	s11,112
    80005218:	a815                	j	8000524c <printf+0x9c>
    acquire(&pr.lock);
    8000521a:	0001e517          	auipc	a0,0x1e
    8000521e:	6ae50513          	addi	a0,a0,1710 # 800238c8 <pr>
    80005222:	58e000ef          	jal	800057b0 <acquire>
  va_start(ap, fmt);
    80005226:	00840793          	addi	a5,s0,8
    8000522a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000522e:	000a4503          	lbu	a0,0(s4)
    80005232:	fd4d                	bnez	a0,800051ec <printf+0x3c>
    80005234:	a481                	j	80005474 <printf+0x2c4>
      consputc(cx);
    80005236:	cf9ff0ef          	jal	80004f2e <consputc>
      continue;
    8000523a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000523c:	0014899b          	addiw	s3,s1,1
    80005240:	013a07b3          	add	a5,s4,s3
    80005244:	0007c503          	lbu	a0,0(a5)
    80005248:	1e050b63          	beqz	a0,8000543e <printf+0x28e>
    if(cx != '%'){
    8000524c:	ff5515e3          	bne	a0,s5,80005236 <printf+0x86>
    i++;
    80005250:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005254:	009a07b3          	add	a5,s4,s1
    80005258:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000525c:	1e090163          	beqz	s2,8000543e <printf+0x28e>
    80005260:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005264:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005266:	c789                	beqz	a5,80005270 <printf+0xc0>
    80005268:	009a0733          	add	a4,s4,s1
    8000526c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005270:	03690763          	beq	s2,s6,8000529e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005274:	05890163          	beq	s2,s8,800052b6 <printf+0x106>
    } else if(c0 == 'u'){
    80005278:	0d990b63          	beq	s2,s9,8000534e <printf+0x19e>
    } else if(c0 == 'x'){
    8000527c:	13a90163          	beq	s2,s10,8000539e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005280:	13b90b63          	beq	s2,s11,800053b6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005284:	07300793          	li	a5,115
    80005288:	16f90a63          	beq	s2,a5,800053fc <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000528c:	1b590463          	beq	s2,s5,80005434 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005290:	8556                	mv	a0,s5
    80005292:	c9dff0ef          	jal	80004f2e <consputc>
      consputc(c0);
    80005296:	854a                	mv	a0,s2
    80005298:	c97ff0ef          	jal	80004f2e <consputc>
    8000529c:	b745                	j	8000523c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000529e:	f8843783          	ld	a5,-120(s0)
    800052a2:	00878713          	addi	a4,a5,8
    800052a6:	f8e43423          	sd	a4,-120(s0)
    800052aa:	4605                	li	a2,1
    800052ac:	45a9                	li	a1,10
    800052ae:	4388                	lw	a0,0(a5)
    800052b0:	e6fff0ef          	jal	8000511e <printint>
    800052b4:	b761                	j	8000523c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800052b6:	03678663          	beq	a5,s6,800052e2 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800052ba:	05878263          	beq	a5,s8,800052fe <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800052be:	0b978463          	beq	a5,s9,80005366 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800052c2:	fda797e3          	bne	a5,s10,80005290 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800052c6:	f8843783          	ld	a5,-120(s0)
    800052ca:	00878713          	addi	a4,a5,8
    800052ce:	f8e43423          	sd	a4,-120(s0)
    800052d2:	4601                	li	a2,0
    800052d4:	45c1                	li	a1,16
    800052d6:	6388                	ld	a0,0(a5)
    800052d8:	e47ff0ef          	jal	8000511e <printint>
      i += 1;
    800052dc:	0029849b          	addiw	s1,s3,2
    800052e0:	bfb1                	j	8000523c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800052e2:	f8843783          	ld	a5,-120(s0)
    800052e6:	00878713          	addi	a4,a5,8
    800052ea:	f8e43423          	sd	a4,-120(s0)
    800052ee:	4605                	li	a2,1
    800052f0:	45a9                	li	a1,10
    800052f2:	6388                	ld	a0,0(a5)
    800052f4:	e2bff0ef          	jal	8000511e <printint>
      i += 1;
    800052f8:	0029849b          	addiw	s1,s3,2
    800052fc:	b781                	j	8000523c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800052fe:	06400793          	li	a5,100
    80005302:	02f68863          	beq	a3,a5,80005332 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005306:	07500793          	li	a5,117
    8000530a:	06f68c63          	beq	a3,a5,80005382 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000530e:	07800793          	li	a5,120
    80005312:	f6f69fe3          	bne	a3,a5,80005290 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005316:	f8843783          	ld	a5,-120(s0)
    8000531a:	00878713          	addi	a4,a5,8
    8000531e:	f8e43423          	sd	a4,-120(s0)
    80005322:	4601                	li	a2,0
    80005324:	45c1                	li	a1,16
    80005326:	6388                	ld	a0,0(a5)
    80005328:	df7ff0ef          	jal	8000511e <printint>
      i += 2;
    8000532c:	0039849b          	addiw	s1,s3,3
    80005330:	b731                	j	8000523c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005332:	f8843783          	ld	a5,-120(s0)
    80005336:	00878713          	addi	a4,a5,8
    8000533a:	f8e43423          	sd	a4,-120(s0)
    8000533e:	4605                	li	a2,1
    80005340:	45a9                	li	a1,10
    80005342:	6388                	ld	a0,0(a5)
    80005344:	ddbff0ef          	jal	8000511e <printint>
      i += 2;
    80005348:	0039849b          	addiw	s1,s3,3
    8000534c:	bdc5                	j	8000523c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000534e:	f8843783          	ld	a5,-120(s0)
    80005352:	00878713          	addi	a4,a5,8
    80005356:	f8e43423          	sd	a4,-120(s0)
    8000535a:	4601                	li	a2,0
    8000535c:	45a9                	li	a1,10
    8000535e:	4388                	lw	a0,0(a5)
    80005360:	dbfff0ef          	jal	8000511e <printint>
    80005364:	bde1                	j	8000523c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005366:	f8843783          	ld	a5,-120(s0)
    8000536a:	00878713          	addi	a4,a5,8
    8000536e:	f8e43423          	sd	a4,-120(s0)
    80005372:	4601                	li	a2,0
    80005374:	45a9                	li	a1,10
    80005376:	6388                	ld	a0,0(a5)
    80005378:	da7ff0ef          	jal	8000511e <printint>
      i += 1;
    8000537c:	0029849b          	addiw	s1,s3,2
    80005380:	bd75                	j	8000523c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005382:	f8843783          	ld	a5,-120(s0)
    80005386:	00878713          	addi	a4,a5,8
    8000538a:	f8e43423          	sd	a4,-120(s0)
    8000538e:	4601                	li	a2,0
    80005390:	45a9                	li	a1,10
    80005392:	6388                	ld	a0,0(a5)
    80005394:	d8bff0ef          	jal	8000511e <printint>
      i += 2;
    80005398:	0039849b          	addiw	s1,s3,3
    8000539c:	b545                	j	8000523c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000539e:	f8843783          	ld	a5,-120(s0)
    800053a2:	00878713          	addi	a4,a5,8
    800053a6:	f8e43423          	sd	a4,-120(s0)
    800053aa:	4601                	li	a2,0
    800053ac:	45c1                	li	a1,16
    800053ae:	4388                	lw	a0,0(a5)
    800053b0:	d6fff0ef          	jal	8000511e <printint>
    800053b4:	b561                	j	8000523c <printf+0x8c>
    800053b6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800053b8:	f8843783          	ld	a5,-120(s0)
    800053bc:	00878713          	addi	a4,a5,8
    800053c0:	f8e43423          	sd	a4,-120(s0)
    800053c4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800053c8:	03000513          	li	a0,48
    800053cc:	b63ff0ef          	jal	80004f2e <consputc>
  consputc('x');
    800053d0:	07800513          	li	a0,120
    800053d4:	b5bff0ef          	jal	80004f2e <consputc>
    800053d8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800053da:	00002b97          	auipc	s7,0x2
    800053de:	626b8b93          	addi	s7,s7,1574 # 80007a00 <digits>
    800053e2:	03c9d793          	srli	a5,s3,0x3c
    800053e6:	97de                	add	a5,a5,s7
    800053e8:	0007c503          	lbu	a0,0(a5)
    800053ec:	b43ff0ef          	jal	80004f2e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800053f0:	0992                	slli	s3,s3,0x4
    800053f2:	397d                	addiw	s2,s2,-1
    800053f4:	fe0917e3          	bnez	s2,800053e2 <printf+0x232>
    800053f8:	6ba6                	ld	s7,72(sp)
    800053fa:	b589                	j	8000523c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    800053fc:	f8843783          	ld	a5,-120(s0)
    80005400:	00878713          	addi	a4,a5,8
    80005404:	f8e43423          	sd	a4,-120(s0)
    80005408:	0007b903          	ld	s2,0(a5)
    8000540c:	00090d63          	beqz	s2,80005426 <printf+0x276>
      for(; *s; s++)
    80005410:	00094503          	lbu	a0,0(s2)
    80005414:	e20504e3          	beqz	a0,8000523c <printf+0x8c>
        consputc(*s);
    80005418:	b17ff0ef          	jal	80004f2e <consputc>
      for(; *s; s++)
    8000541c:	0905                	addi	s2,s2,1
    8000541e:	00094503          	lbu	a0,0(s2)
    80005422:	f97d                	bnez	a0,80005418 <printf+0x268>
    80005424:	bd21                	j	8000523c <printf+0x8c>
        s = "(null)";
    80005426:	00002917          	auipc	s2,0x2
    8000542a:	3c290913          	addi	s2,s2,962 # 800077e8 <etext+0x7e8>
      for(; *s; s++)
    8000542e:	02800513          	li	a0,40
    80005432:	b7dd                	j	80005418 <printf+0x268>
      consputc('%');
    80005434:	02500513          	li	a0,37
    80005438:	af7ff0ef          	jal	80004f2e <consputc>
    8000543c:	b501                	j	8000523c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000543e:	f7843783          	ld	a5,-136(s0)
    80005442:	e385                	bnez	a5,80005462 <printf+0x2b2>
    80005444:	74e6                	ld	s1,120(sp)
    80005446:	7946                	ld	s2,112(sp)
    80005448:	79a6                	ld	s3,104(sp)
    8000544a:	6ae6                	ld	s5,88(sp)
    8000544c:	6b46                	ld	s6,80(sp)
    8000544e:	6c06                	ld	s8,64(sp)
    80005450:	7ce2                	ld	s9,56(sp)
    80005452:	7d42                	ld	s10,48(sp)
    80005454:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005456:	4501                	li	a0,0
    80005458:	60aa                	ld	ra,136(sp)
    8000545a:	640a                	ld	s0,128(sp)
    8000545c:	7a06                	ld	s4,96(sp)
    8000545e:	6169                	addi	sp,sp,208
    80005460:	8082                	ret
    80005462:	74e6                	ld	s1,120(sp)
    80005464:	7946                	ld	s2,112(sp)
    80005466:	79a6                	ld	s3,104(sp)
    80005468:	6ae6                	ld	s5,88(sp)
    8000546a:	6b46                	ld	s6,80(sp)
    8000546c:	6c06                	ld	s8,64(sp)
    8000546e:	7ce2                	ld	s9,56(sp)
    80005470:	7d42                	ld	s10,48(sp)
    80005472:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005474:	0001e517          	auipc	a0,0x1e
    80005478:	45450513          	addi	a0,a0,1108 # 800238c8 <pr>
    8000547c:	3cc000ef          	jal	80005848 <release>
    80005480:	bfd9                	j	80005456 <printf+0x2a6>

0000000080005482 <panic>:

void
panic(char *s)
{
    80005482:	1101                	addi	sp,sp,-32
    80005484:	ec06                	sd	ra,24(sp)
    80005486:	e822                	sd	s0,16(sp)
    80005488:	e426                	sd	s1,8(sp)
    8000548a:	1000                	addi	s0,sp,32
    8000548c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000548e:	0001e797          	auipc	a5,0x1e
    80005492:	4407a923          	sw	zero,1106(a5) # 800238e0 <pr+0x18>
  printf("panic: ");
    80005496:	00002517          	auipc	a0,0x2
    8000549a:	35a50513          	addi	a0,a0,858 # 800077f0 <etext+0x7f0>
    8000549e:	d13ff0ef          	jal	800051b0 <printf>
  printf("%s\n", s);
    800054a2:	85a6                	mv	a1,s1
    800054a4:	00002517          	auipc	a0,0x2
    800054a8:	ffc50513          	addi	a0,a0,-4 # 800074a0 <etext+0x4a0>
    800054ac:	d05ff0ef          	jal	800051b0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800054b0:	4785                	li	a5,1
    800054b2:	00005717          	auipc	a4,0x5
    800054b6:	f2f72523          	sw	a5,-214(a4) # 8000a3dc <panicked>
  for(;;)
    800054ba:	a001                	j	800054ba <panic+0x38>

00000000800054bc <printfinit>:
    ;
}

void
printfinit(void)
{
    800054bc:	1101                	addi	sp,sp,-32
    800054be:	ec06                	sd	ra,24(sp)
    800054c0:	e822                	sd	s0,16(sp)
    800054c2:	e426                	sd	s1,8(sp)
    800054c4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800054c6:	0001e497          	auipc	s1,0x1e
    800054ca:	40248493          	addi	s1,s1,1026 # 800238c8 <pr>
    800054ce:	00002597          	auipc	a1,0x2
    800054d2:	32a58593          	addi	a1,a1,810 # 800077f8 <etext+0x7f8>
    800054d6:	8526                	mv	a0,s1
    800054d8:	258000ef          	jal	80005730 <initlock>
  pr.locking = 1;
    800054dc:	4785                	li	a5,1
    800054de:	cc9c                	sw	a5,24(s1)
}
    800054e0:	60e2                	ld	ra,24(sp)
    800054e2:	6442                	ld	s0,16(sp)
    800054e4:	64a2                	ld	s1,8(sp)
    800054e6:	6105                	addi	sp,sp,32
    800054e8:	8082                	ret

00000000800054ea <uartinit>:

void uartstart();

void
uartinit(void)
{
    800054ea:	1141                	addi	sp,sp,-16
    800054ec:	e406                	sd	ra,8(sp)
    800054ee:	e022                	sd	s0,0(sp)
    800054f0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800054f2:	100007b7          	lui	a5,0x10000
    800054f6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800054fa:	10000737          	lui	a4,0x10000
    800054fe:	f8000693          	li	a3,-128
    80005502:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005506:	468d                	li	a3,3
    80005508:	10000637          	lui	a2,0x10000
    8000550c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005510:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005514:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005518:	10000737          	lui	a4,0x10000
    8000551c:	461d                	li	a2,7
    8000551e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005522:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005526:	00002597          	auipc	a1,0x2
    8000552a:	2da58593          	addi	a1,a1,730 # 80007800 <etext+0x800>
    8000552e:	0001e517          	auipc	a0,0x1e
    80005532:	3ba50513          	addi	a0,a0,954 # 800238e8 <uart_tx_lock>
    80005536:	1fa000ef          	jal	80005730 <initlock>
}
    8000553a:	60a2                	ld	ra,8(sp)
    8000553c:	6402                	ld	s0,0(sp)
    8000553e:	0141                	addi	sp,sp,16
    80005540:	8082                	ret

0000000080005542 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005542:	1101                	addi	sp,sp,-32
    80005544:	ec06                	sd	ra,24(sp)
    80005546:	e822                	sd	s0,16(sp)
    80005548:	e426                	sd	s1,8(sp)
    8000554a:	1000                	addi	s0,sp,32
    8000554c:	84aa                	mv	s1,a0
  push_off();
    8000554e:	222000ef          	jal	80005770 <push_off>

  if(panicked){
    80005552:	00005797          	auipc	a5,0x5
    80005556:	e8a7a783          	lw	a5,-374(a5) # 8000a3dc <panicked>
    8000555a:	e795                	bnez	a5,80005586 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000555c:	10000737          	lui	a4,0x10000
    80005560:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005562:	00074783          	lbu	a5,0(a4)
    80005566:	0207f793          	andi	a5,a5,32
    8000556a:	dfe5                	beqz	a5,80005562 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000556c:	0ff4f513          	zext.b	a0,s1
    80005570:	100007b7          	lui	a5,0x10000
    80005574:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005578:	27c000ef          	jal	800057f4 <pop_off>
}
    8000557c:	60e2                	ld	ra,24(sp)
    8000557e:	6442                	ld	s0,16(sp)
    80005580:	64a2                	ld	s1,8(sp)
    80005582:	6105                	addi	sp,sp,32
    80005584:	8082                	ret
    for(;;)
    80005586:	a001                	j	80005586 <uartputc_sync+0x44>

0000000080005588 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005588:	00005797          	auipc	a5,0x5
    8000558c:	e587b783          	ld	a5,-424(a5) # 8000a3e0 <uart_tx_r>
    80005590:	00005717          	auipc	a4,0x5
    80005594:	e5873703          	ld	a4,-424(a4) # 8000a3e8 <uart_tx_w>
    80005598:	08f70263          	beq	a4,a5,8000561c <uartstart+0x94>
{
    8000559c:	7139                	addi	sp,sp,-64
    8000559e:	fc06                	sd	ra,56(sp)
    800055a0:	f822                	sd	s0,48(sp)
    800055a2:	f426                	sd	s1,40(sp)
    800055a4:	f04a                	sd	s2,32(sp)
    800055a6:	ec4e                	sd	s3,24(sp)
    800055a8:	e852                	sd	s4,16(sp)
    800055aa:	e456                	sd	s5,8(sp)
    800055ac:	e05a                	sd	s6,0(sp)
    800055ae:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055b0:	10000937          	lui	s2,0x10000
    800055b4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055b6:	0001ea97          	auipc	s5,0x1e
    800055ba:	332a8a93          	addi	s5,s5,818 # 800238e8 <uart_tx_lock>
    uart_tx_r += 1;
    800055be:	00005497          	auipc	s1,0x5
    800055c2:	e2248493          	addi	s1,s1,-478 # 8000a3e0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800055c6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800055ca:	00005997          	auipc	s3,0x5
    800055ce:	e1e98993          	addi	s3,s3,-482 # 8000a3e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055d2:	00094703          	lbu	a4,0(s2)
    800055d6:	02077713          	andi	a4,a4,32
    800055da:	c71d                	beqz	a4,80005608 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055dc:	01f7f713          	andi	a4,a5,31
    800055e0:	9756                	add	a4,a4,s5
    800055e2:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800055e6:	0785                	addi	a5,a5,1
    800055e8:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800055ea:	8526                	mv	a0,s1
    800055ec:	d91fb0ef          	jal	8000137c <wakeup>
    WriteReg(THR, c);
    800055f0:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800055f4:	609c                	ld	a5,0(s1)
    800055f6:	0009b703          	ld	a4,0(s3)
    800055fa:	fcf71ce3          	bne	a4,a5,800055d2 <uartstart+0x4a>
      ReadReg(ISR);
    800055fe:	100007b7          	lui	a5,0x10000
    80005602:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005604:	0007c783          	lbu	a5,0(a5)
  }
}
    80005608:	70e2                	ld	ra,56(sp)
    8000560a:	7442                	ld	s0,48(sp)
    8000560c:	74a2                	ld	s1,40(sp)
    8000560e:	7902                	ld	s2,32(sp)
    80005610:	69e2                	ld	s3,24(sp)
    80005612:	6a42                	ld	s4,16(sp)
    80005614:	6aa2                	ld	s5,8(sp)
    80005616:	6b02                	ld	s6,0(sp)
    80005618:	6121                	addi	sp,sp,64
    8000561a:	8082                	ret
      ReadReg(ISR);
    8000561c:	100007b7          	lui	a5,0x10000
    80005620:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005622:	0007c783          	lbu	a5,0(a5)
      return;
    80005626:	8082                	ret

0000000080005628 <uartputc>:
{
    80005628:	7179                	addi	sp,sp,-48
    8000562a:	f406                	sd	ra,40(sp)
    8000562c:	f022                	sd	s0,32(sp)
    8000562e:	ec26                	sd	s1,24(sp)
    80005630:	e84a                	sd	s2,16(sp)
    80005632:	e44e                	sd	s3,8(sp)
    80005634:	e052                	sd	s4,0(sp)
    80005636:	1800                	addi	s0,sp,48
    80005638:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000563a:	0001e517          	auipc	a0,0x1e
    8000563e:	2ae50513          	addi	a0,a0,686 # 800238e8 <uart_tx_lock>
    80005642:	16e000ef          	jal	800057b0 <acquire>
  if(panicked){
    80005646:	00005797          	auipc	a5,0x5
    8000564a:	d967a783          	lw	a5,-618(a5) # 8000a3dc <panicked>
    8000564e:	efbd                	bnez	a5,800056cc <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005650:	00005717          	auipc	a4,0x5
    80005654:	d9873703          	ld	a4,-616(a4) # 8000a3e8 <uart_tx_w>
    80005658:	00005797          	auipc	a5,0x5
    8000565c:	d887b783          	ld	a5,-632(a5) # 8000a3e0 <uart_tx_r>
    80005660:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005664:	0001e997          	auipc	s3,0x1e
    80005668:	28498993          	addi	s3,s3,644 # 800238e8 <uart_tx_lock>
    8000566c:	00005497          	auipc	s1,0x5
    80005670:	d7448493          	addi	s1,s1,-652 # 8000a3e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005674:	00005917          	auipc	s2,0x5
    80005678:	d7490913          	addi	s2,s2,-652 # 8000a3e8 <uart_tx_w>
    8000567c:	00e79d63          	bne	a5,a4,80005696 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005680:	85ce                	mv	a1,s3
    80005682:	8526                	mv	a0,s1
    80005684:	cadfb0ef          	jal	80001330 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005688:	00093703          	ld	a4,0(s2)
    8000568c:	609c                	ld	a5,0(s1)
    8000568e:	02078793          	addi	a5,a5,32
    80005692:	fee787e3          	beq	a5,a4,80005680 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005696:	0001e497          	auipc	s1,0x1e
    8000569a:	25248493          	addi	s1,s1,594 # 800238e8 <uart_tx_lock>
    8000569e:	01f77793          	andi	a5,a4,31
    800056a2:	97a6                	add	a5,a5,s1
    800056a4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800056a8:	0705                	addi	a4,a4,1
    800056aa:	00005797          	auipc	a5,0x5
    800056ae:	d2e7bf23          	sd	a4,-706(a5) # 8000a3e8 <uart_tx_w>
  uartstart();
    800056b2:	ed7ff0ef          	jal	80005588 <uartstart>
  release(&uart_tx_lock);
    800056b6:	8526                	mv	a0,s1
    800056b8:	190000ef          	jal	80005848 <release>
}
    800056bc:	70a2                	ld	ra,40(sp)
    800056be:	7402                	ld	s0,32(sp)
    800056c0:	64e2                	ld	s1,24(sp)
    800056c2:	6942                	ld	s2,16(sp)
    800056c4:	69a2                	ld	s3,8(sp)
    800056c6:	6a02                	ld	s4,0(sp)
    800056c8:	6145                	addi	sp,sp,48
    800056ca:	8082                	ret
    for(;;)
    800056cc:	a001                	j	800056cc <uartputc+0xa4>

00000000800056ce <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800056ce:	1141                	addi	sp,sp,-16
    800056d0:	e422                	sd	s0,8(sp)
    800056d2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800056d4:	100007b7          	lui	a5,0x10000
    800056d8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800056da:	0007c783          	lbu	a5,0(a5)
    800056de:	8b85                	andi	a5,a5,1
    800056e0:	cb81                	beqz	a5,800056f0 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800056e2:	100007b7          	lui	a5,0x10000
    800056e6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800056ea:	6422                	ld	s0,8(sp)
    800056ec:	0141                	addi	sp,sp,16
    800056ee:	8082                	ret
    return -1;
    800056f0:	557d                	li	a0,-1
    800056f2:	bfe5                	j	800056ea <uartgetc+0x1c>

00000000800056f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800056f4:	1101                	addi	sp,sp,-32
    800056f6:	ec06                	sd	ra,24(sp)
    800056f8:	e822                	sd	s0,16(sp)
    800056fa:	e426                	sd	s1,8(sp)
    800056fc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800056fe:	54fd                	li	s1,-1
    80005700:	a019                	j	80005706 <uartintr+0x12>
      break;
    consoleintr(c);
    80005702:	85fff0ef          	jal	80004f60 <consoleintr>
    int c = uartgetc();
    80005706:	fc9ff0ef          	jal	800056ce <uartgetc>
    if(c == -1)
    8000570a:	fe951ce3          	bne	a0,s1,80005702 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000570e:	0001e497          	auipc	s1,0x1e
    80005712:	1da48493          	addi	s1,s1,474 # 800238e8 <uart_tx_lock>
    80005716:	8526                	mv	a0,s1
    80005718:	098000ef          	jal	800057b0 <acquire>
  uartstart();
    8000571c:	e6dff0ef          	jal	80005588 <uartstart>
  release(&uart_tx_lock);
    80005720:	8526                	mv	a0,s1
    80005722:	126000ef          	jal	80005848 <release>
}
    80005726:	60e2                	ld	ra,24(sp)
    80005728:	6442                	ld	s0,16(sp)
    8000572a:	64a2                	ld	s1,8(sp)
    8000572c:	6105                	addi	sp,sp,32
    8000572e:	8082                	ret

0000000080005730 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005730:	1141                	addi	sp,sp,-16
    80005732:	e422                	sd	s0,8(sp)
    80005734:	0800                	addi	s0,sp,16
  lk->name = name;
    80005736:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005738:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000573c:	00053823          	sd	zero,16(a0)
}
    80005740:	6422                	ld	s0,8(sp)
    80005742:	0141                	addi	sp,sp,16
    80005744:	8082                	ret

0000000080005746 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005746:	411c                	lw	a5,0(a0)
    80005748:	e399                	bnez	a5,8000574e <holding+0x8>
    8000574a:	4501                	li	a0,0
  return r;
}
    8000574c:	8082                	ret
{
    8000574e:	1101                	addi	sp,sp,-32
    80005750:	ec06                	sd	ra,24(sp)
    80005752:	e822                	sd	s0,16(sp)
    80005754:	e426                	sd	s1,8(sp)
    80005756:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005758:	6904                	ld	s1,16(a0)
    8000575a:	de0fb0ef          	jal	80000d3a <mycpu>
    8000575e:	40a48533          	sub	a0,s1,a0
    80005762:	00153513          	seqz	a0,a0
}
    80005766:	60e2                	ld	ra,24(sp)
    80005768:	6442                	ld	s0,16(sp)
    8000576a:	64a2                	ld	s1,8(sp)
    8000576c:	6105                	addi	sp,sp,32
    8000576e:	8082                	ret

0000000080005770 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005770:	1101                	addi	sp,sp,-32
    80005772:	ec06                	sd	ra,24(sp)
    80005774:	e822                	sd	s0,16(sp)
    80005776:	e426                	sd	s1,8(sp)
    80005778:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000577a:	100024f3          	csrr	s1,sstatus
    8000577e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005782:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005784:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005788:	db2fb0ef          	jal	80000d3a <mycpu>
    8000578c:	5d3c                	lw	a5,120(a0)
    8000578e:	cb99                	beqz	a5,800057a4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005790:	daafb0ef          	jal	80000d3a <mycpu>
    80005794:	5d3c                	lw	a5,120(a0)
    80005796:	2785                	addiw	a5,a5,1
    80005798:	dd3c                	sw	a5,120(a0)
}
    8000579a:	60e2                	ld	ra,24(sp)
    8000579c:	6442                	ld	s0,16(sp)
    8000579e:	64a2                	ld	s1,8(sp)
    800057a0:	6105                	addi	sp,sp,32
    800057a2:	8082                	ret
    mycpu()->intena = old;
    800057a4:	d96fb0ef          	jal	80000d3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800057a8:	8085                	srli	s1,s1,0x1
    800057aa:	8885                	andi	s1,s1,1
    800057ac:	dd64                	sw	s1,124(a0)
    800057ae:	b7cd                	j	80005790 <push_off+0x20>

00000000800057b0 <acquire>:
{
    800057b0:	1101                	addi	sp,sp,-32
    800057b2:	ec06                	sd	ra,24(sp)
    800057b4:	e822                	sd	s0,16(sp)
    800057b6:	e426                	sd	s1,8(sp)
    800057b8:	1000                	addi	s0,sp,32
    800057ba:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800057bc:	fb5ff0ef          	jal	80005770 <push_off>
  if(holding(lk))
    800057c0:	8526                	mv	a0,s1
    800057c2:	f85ff0ef          	jal	80005746 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057c6:	4705                	li	a4,1
  if(holding(lk))
    800057c8:	e105                	bnez	a0,800057e8 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057ca:	87ba                	mv	a5,a4
    800057cc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800057d0:	2781                	sext.w	a5,a5
    800057d2:	ffe5                	bnez	a5,800057ca <acquire+0x1a>
  __sync_synchronize();
    800057d4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800057d8:	d62fb0ef          	jal	80000d3a <mycpu>
    800057dc:	e888                	sd	a0,16(s1)
}
    800057de:	60e2                	ld	ra,24(sp)
    800057e0:	6442                	ld	s0,16(sp)
    800057e2:	64a2                	ld	s1,8(sp)
    800057e4:	6105                	addi	sp,sp,32
    800057e6:	8082                	ret
    panic("acquire");
    800057e8:	00002517          	auipc	a0,0x2
    800057ec:	02050513          	addi	a0,a0,32 # 80007808 <etext+0x808>
    800057f0:	c93ff0ef          	jal	80005482 <panic>

00000000800057f4 <pop_off>:

void
pop_off(void)
{
    800057f4:	1141                	addi	sp,sp,-16
    800057f6:	e406                	sd	ra,8(sp)
    800057f8:	e022                	sd	s0,0(sp)
    800057fa:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800057fc:	d3efb0ef          	jal	80000d3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005800:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005804:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005806:	e78d                	bnez	a5,80005830 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005808:	5d3c                	lw	a5,120(a0)
    8000580a:	02f05963          	blez	a5,8000583c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000580e:	37fd                	addiw	a5,a5,-1
    80005810:	0007871b          	sext.w	a4,a5
    80005814:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005816:	eb09                	bnez	a4,80005828 <pop_off+0x34>
    80005818:	5d7c                	lw	a5,124(a0)
    8000581a:	c799                	beqz	a5,80005828 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000581c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005820:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005824:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005828:	60a2                	ld	ra,8(sp)
    8000582a:	6402                	ld	s0,0(sp)
    8000582c:	0141                	addi	sp,sp,16
    8000582e:	8082                	ret
    panic("pop_off - interruptible");
    80005830:	00002517          	auipc	a0,0x2
    80005834:	fe050513          	addi	a0,a0,-32 # 80007810 <etext+0x810>
    80005838:	c4bff0ef          	jal	80005482 <panic>
    panic("pop_off");
    8000583c:	00002517          	auipc	a0,0x2
    80005840:	fec50513          	addi	a0,a0,-20 # 80007828 <etext+0x828>
    80005844:	c3fff0ef          	jal	80005482 <panic>

0000000080005848 <release>:
{
    80005848:	1101                	addi	sp,sp,-32
    8000584a:	ec06                	sd	ra,24(sp)
    8000584c:	e822                	sd	s0,16(sp)
    8000584e:	e426                	sd	s1,8(sp)
    80005850:	1000                	addi	s0,sp,32
    80005852:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005854:	ef3ff0ef          	jal	80005746 <holding>
    80005858:	c105                	beqz	a0,80005878 <release+0x30>
  lk->cpu = 0;
    8000585a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000585e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005862:	0310000f          	fence	rw,w
    80005866:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000586a:	f8bff0ef          	jal	800057f4 <pop_off>
}
    8000586e:	60e2                	ld	ra,24(sp)
    80005870:	6442                	ld	s0,16(sp)
    80005872:	64a2                	ld	s1,8(sp)
    80005874:	6105                	addi	sp,sp,32
    80005876:	8082                	ret
    panic("release");
    80005878:	00002517          	auipc	a0,0x2
    8000587c:	fb850513          	addi	a0,a0,-72 # 80007830 <etext+0x830>
    80005880:	c03ff0ef          	jal	80005482 <panic>
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
