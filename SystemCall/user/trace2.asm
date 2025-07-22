
user/_trace2: formato do arquivo elf64-littleriscv


Desmontagem da seção .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"

int main() {
   0:	7175                	addi	sp,sp,-144
   2:	e506                	sd	ra,136(sp)
   4:	e122                	sd	s0,128(sp)
   6:	fca6                	sd	s1,120(sp)
   8:	0900                	addi	s0,sp,144
    printf("=== TESTE 2: Rastreamento de TODAS as syscalls ===\n");
   a:	00001517          	auipc	a0,0x1
   e:	8f650513          	addi	a0,a0,-1802 # 900 <malloc+0x102>
  12:	738000ef          	jal	74a <printf>
    printf("Equivalente a: trace 2147483647 grep hello README\n");
  16:	00001517          	auipc	a0,0x1
  1a:	92250513          	addi	a0,a0,-1758 # 938 <malloc+0x13a>
  1e:	72c000ef          	jal	74a <printf>
    printf("Mascara: 2147483647 (todos os 31 bits baixos definidos)\n\n");
  22:	00001517          	auipc	a0,0x1
  26:	94e50513          	addi	a0,a0,-1714 # 970 <malloc+0x172>
  2a:	720000ef          	jal	74a <printf>
    
    // Ativar trace para todas as syscalls
    trace(2147483647);
  2e:	80000537          	lui	a0,0x80000
  32:	fff54513          	not	a0,a0
  36:	394000ef          	jal	3ca <trace>
    
    printf("Iniciando operacoes com trace ativo...\n");
  3a:	00001517          	auipc	a0,0x1
  3e:	97650513          	addi	a0,a0,-1674 # 9b0 <malloc+0x1b2>
  42:	708000ef          	jal	74a <printf>
    
    // Fazer várias operações diferentes para demonstrar rastreamento
    int fd = open("README", 0);
  46:	4581                	li	a1,0
  48:	00001517          	auipc	a0,0x1
  4c:	99050513          	addi	a0,a0,-1648 # 9d8 <malloc+0x1da>
  50:	312000ef          	jal	362 <open>
    if(fd >= 0) {
  54:	04055063          	bgez	a0,94 <main+0x94>
        printf("Lidos %d bytes do arquivo\n", bytes);
        close(fd);
    }
    
    // Fazer uma operação adicional
    int pid = getpid();
  58:	34a000ef          	jal	3a2 <getpid>
  5c:	85aa                	mv	a1,a0
    printf("PID atual: %d\n", pid);
  5e:	00001517          	auipc	a0,0x1
  62:	9a250513          	addi	a0,a0,-1630 # a00 <malloc+0x202>
  66:	6e4000ef          	jal	74a <printf>
    
    printf("\nTeste 2 concluido!\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	9a650513          	addi	a0,a0,-1626 # a10 <malloc+0x212>
  72:	6d8000ef          	jal	74a <printf>
    printf("Observe que TODAS as syscalls foram rastreadas:\n");
  76:	00001517          	auipc	a0,0x1
  7a:	9b250513          	addi	a0,a0,-1614 # a28 <malloc+0x22a>
  7e:	6cc000ef          	jal	74a <printf>
    printf("- trace, open, read, close, getpid, write (do printf)\n");
  82:	00001517          	auipc	a0,0x1
  86:	9de50513          	addi	a0,a0,-1570 # a60 <malloc+0x262>
  8a:	6c0000ef          	jal	74a <printf>
    exit(0);
  8e:	4501                	li	a0,0
  90:	292000ef          	jal	322 <exit>
  94:	84aa                	mv	s1,a0
        int bytes = read(fd, buf, sizeof(buf));
  96:	06400613          	li	a2,100
  9a:	f7840593          	addi	a1,s0,-136
  9e:	29c000ef          	jal	33a <read>
  a2:	85aa                	mv	a1,a0
        printf("Lidos %d bytes do arquivo\n", bytes);
  a4:	00001517          	auipc	a0,0x1
  a8:	93c50513          	addi	a0,a0,-1732 # 9e0 <malloc+0x1e2>
  ac:	69e000ef          	jal	74a <printf>
        close(fd);
  b0:	8526                	mv	a0,s1
  b2:	298000ef          	jal	34a <close>
  b6:	b74d                	j	58 <main+0x58>

00000000000000b8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e406                	sd	ra,8(sp)
  bc:	e022                	sd	s0,0(sp)
  be:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c0:	f41ff0ef          	jal	0 <main>
  exit(0);
  c4:	4501                	li	a0,0
  c6:	25c000ef          	jal	322 <exit>

00000000000000ca <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d0:	87aa                	mv	a5,a0
  d2:	0585                	addi	a1,a1,1
  d4:	0785                	addi	a5,a5,1
  d6:	fff5c703          	lbu	a4,-1(a1)
  da:	fee78fa3          	sb	a4,-1(a5)
  de:	fb75                	bnez	a4,d2 <strcpy+0x8>
    ;
  return os;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cb91                	beqz	a5,104 <strcmp+0x1e>
  f2:	0005c703          	lbu	a4,0(a1)
  f6:	00f71763          	bne	a4,a5,104 <strcmp+0x1e>
    p++, q++;
  fa:	0505                	addi	a0,a0,1
  fc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  fe:	00054783          	lbu	a5,0(a0)
 102:	fbe5                	bnez	a5,f2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 104:	0005c503          	lbu	a0,0(a1)
}
 108:	40a7853b          	subw	a0,a5,a0
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strlen>:

uint
strlen(const char *s)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cf91                	beqz	a5,138 <strlen+0x26>
 11e:	0505                	addi	a0,a0,1
 120:	87aa                	mv	a5,a0
 122:	86be                	mv	a3,a5
 124:	0785                	addi	a5,a5,1
 126:	fff7c703          	lbu	a4,-1(a5)
 12a:	ff65                	bnez	a4,122 <strlen+0x10>
 12c:	40a6853b          	subw	a0,a3,a0
 130:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret
  for(n = 0; s[n]; n++)
 138:	4501                	li	a0,0
 13a:	bfe5                	j	132 <strlen+0x20>

000000000000013c <memset>:

void*
memset(void *dst, int c, uint n)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 142:	ca19                	beqz	a2,158 <memset+0x1c>
 144:	87aa                	mv	a5,a0
 146:	1602                	slli	a2,a2,0x20
 148:	9201                	srli	a2,a2,0x20
 14a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 14e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 152:	0785                	addi	a5,a5,1
 154:	fee79de3          	bne	a5,a4,14e <memset+0x12>
  }
  return dst;
}
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret

000000000000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
  for(; *s; s++)
 164:	00054783          	lbu	a5,0(a0)
 168:	cb99                	beqz	a5,17e <strchr+0x20>
    if(*s == c)
 16a:	00f58763          	beq	a1,a5,178 <strchr+0x1a>
  for(; *s; s++)
 16e:	0505                	addi	a0,a0,1
 170:	00054783          	lbu	a5,0(a0)
 174:	fbfd                	bnez	a5,16a <strchr+0xc>
      return (char*)s;
  return 0;
 176:	4501                	li	a0,0
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  return 0;
 17e:	4501                	li	a0,0
 180:	bfe5                	j	178 <strchr+0x1a>

0000000000000182 <gets>:

char*
gets(char *buf, int max)
{
 182:	711d                	addi	sp,sp,-96
 184:	ec86                	sd	ra,88(sp)
 186:	e8a2                	sd	s0,80(sp)
 188:	e4a6                	sd	s1,72(sp)
 18a:	e0ca                	sd	s2,64(sp)
 18c:	fc4e                	sd	s3,56(sp)
 18e:	f852                	sd	s4,48(sp)
 190:	f456                	sd	s5,40(sp)
 192:	f05a                	sd	s6,32(sp)
 194:	ec5e                	sd	s7,24(sp)
 196:	1080                	addi	s0,sp,96
 198:	8baa                	mv	s7,a0
 19a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19c:	892a                	mv	s2,a0
 19e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a0:	4aa9                	li	s5,10
 1a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1a4:	89a6                	mv	s3,s1
 1a6:	2485                	addiw	s1,s1,1
 1a8:	0344d663          	bge	s1,s4,1d4 <gets+0x52>
    cc = read(0, &c, 1);
 1ac:	4605                	li	a2,1
 1ae:	faf40593          	addi	a1,s0,-81
 1b2:	4501                	li	a0,0
 1b4:	186000ef          	jal	33a <read>
    if(cc < 1)
 1b8:	00a05e63          	blez	a0,1d4 <gets+0x52>
    buf[i++] = c;
 1bc:	faf44783          	lbu	a5,-81(s0)
 1c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c4:	01578763          	beq	a5,s5,1d2 <gets+0x50>
 1c8:	0905                	addi	s2,s2,1
 1ca:	fd679de3          	bne	a5,s6,1a4 <gets+0x22>
    buf[i++] = c;
 1ce:	89a6                	mv	s3,s1
 1d0:	a011                	j	1d4 <gets+0x52>
 1d2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d4:	99de                	add	s3,s3,s7
 1d6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1da:	855e                	mv	a0,s7
 1dc:	60e6                	ld	ra,88(sp)
 1de:	6446                	ld	s0,80(sp)
 1e0:	64a6                	ld	s1,72(sp)
 1e2:	6906                	ld	s2,64(sp)
 1e4:	79e2                	ld	s3,56(sp)
 1e6:	7a42                	ld	s4,48(sp)
 1e8:	7aa2                	ld	s5,40(sp)
 1ea:	7b02                	ld	s6,32(sp)
 1ec:	6be2                	ld	s7,24(sp)
 1ee:	6125                	addi	sp,sp,96
 1f0:	8082                	ret

00000000000001f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f2:	1101                	addi	sp,sp,-32
 1f4:	ec06                	sd	ra,24(sp)
 1f6:	e822                	sd	s0,16(sp)
 1f8:	e04a                	sd	s2,0(sp)
 1fa:	1000                	addi	s0,sp,32
 1fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fe:	4581                	li	a1,0
 200:	162000ef          	jal	362 <open>
  if(fd < 0)
 204:	02054263          	bltz	a0,228 <stat+0x36>
 208:	e426                	sd	s1,8(sp)
 20a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20c:	85ca                	mv	a1,s2
 20e:	16c000ef          	jal	37a <fstat>
 212:	892a                	mv	s2,a0
  close(fd);
 214:	8526                	mv	a0,s1
 216:	134000ef          	jal	34a <close>
  return r;
 21a:	64a2                	ld	s1,8(sp)
}
 21c:	854a                	mv	a0,s2
 21e:	60e2                	ld	ra,24(sp)
 220:	6442                	ld	s0,16(sp)
 222:	6902                	ld	s2,0(sp)
 224:	6105                	addi	sp,sp,32
 226:	8082                	ret
    return -1;
 228:	597d                	li	s2,-1
 22a:	bfcd                	j	21c <stat+0x2a>

000000000000022c <atoi>:

int
atoi(const char *s)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 232:	00054683          	lbu	a3,0(a0)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	4625                	li	a2,9
 240:	02f66863          	bltu	a2,a5,270 <atoi+0x44>
 244:	872a                	mv	a4,a0
  n = 0;
 246:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 248:	0705                	addi	a4,a4,1
 24a:	0025179b          	slliw	a5,a0,0x2
 24e:	9fa9                	addw	a5,a5,a0
 250:	0017979b          	slliw	a5,a5,0x1
 254:	9fb5                	addw	a5,a5,a3
 256:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25a:	00074683          	lbu	a3,0(a4)
 25e:	fd06879b          	addiw	a5,a3,-48
 262:	0ff7f793          	zext.b	a5,a5
 266:	fef671e3          	bgeu	a2,a5,248 <atoi+0x1c>
  return n;
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  n = 0;
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <atoi+0x3e>

0000000000000274 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27a:	02b57463          	bgeu	a0,a1,2a2 <memmove+0x2e>
    while(n-- > 0)
 27e:	00c05f63          	blez	a2,29c <memmove+0x28>
 282:	1602                	slli	a2,a2,0x20
 284:	9201                	srli	a2,a2,0x20
 286:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28a:	872a                	mv	a4,a0
      *dst++ = *src++;
 28c:	0585                	addi	a1,a1,1
 28e:	0705                	addi	a4,a4,1
 290:	fff5c683          	lbu	a3,-1(a1)
 294:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 298:	fef71ae3          	bne	a4,a5,28c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
    dst += n;
 2a2:	00c50733          	add	a4,a0,a2
    src += n;
 2a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a8:	fec05ae3          	blez	a2,29c <memmove+0x28>
 2ac:	fff6079b          	addiw	a5,a2,-1
 2b0:	1782                	slli	a5,a5,0x20
 2b2:	9381                	srli	a5,a5,0x20
 2b4:	fff7c793          	not	a5,a5
 2b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ba:	15fd                	addi	a1,a1,-1
 2bc:	177d                	addi	a4,a4,-1
 2be:	0005c683          	lbu	a3,0(a1)
 2c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c6:	fee79ae3          	bne	a5,a4,2ba <memmove+0x46>
 2ca:	bfc9                	j	29c <memmove+0x28>

00000000000002cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d2:	ca05                	beqz	a2,302 <memcmp+0x36>
 2d4:	fff6069b          	addiw	a3,a2,-1
 2d8:	1682                	slli	a3,a3,0x20
 2da:	9281                	srli	a3,a3,0x20
 2dc:	0685                	addi	a3,a3,1
 2de:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	0005c703          	lbu	a4,0(a1)
 2e8:	00e79863          	bne	a5,a4,2f8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ec:	0505                	addi	a0,a0,1
    p2++;
 2ee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f0:	fed518e3          	bne	a0,a3,2e0 <memcmp+0x14>
  }
  return 0;
 2f4:	4501                	li	a0,0
 2f6:	a019                	j	2fc <memcmp+0x30>
      return *p1 - *p2;
 2f8:	40e7853b          	subw	a0,a5,a4
}
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  return 0;
 302:	4501                	li	a0,0
 304:	bfe5                	j	2fc <memcmp+0x30>

0000000000000306 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30e:	f67ff0ef          	jal	274 <memmove>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exit>:
.global exit
exit:
 li a7, SYS_exit
 322:	4889                	li	a7,2
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <wait>:
.global wait
wait:
 li a7, SYS_wait
 32a:	488d                	li	a7,3
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 332:	4891                	li	a7,4
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <read>:
.global read
read:
 li a7, SYS_read
 33a:	4895                	li	a7,5
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <write>:
.global write
write:
 li a7, SYS_write
 342:	48c1                	li	a7,16
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <close>:
.global close
close:
 li a7, SYS_close
 34a:	48d5                	li	a7,21
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <kill>:
.global kill
kill:
 li a7, SYS_kill
 352:	4899                	li	a7,6
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exec>:
.global exec
exec:
 li a7, SYS_exec
 35a:	489d                	li	a7,7
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <open>:
.global open
open:
 li a7, SYS_open
 362:	48bd                	li	a7,15
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36a:	48c5                	li	a7,17
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 372:	48c9                	li	a7,18
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37a:	48a1                	li	a7,8
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <link>:
.global link
link:
 li a7, SYS_link
 382:	48cd                	li	a7,19
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38a:	48d1                	li	a7,20
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 392:	48a5                	li	a7,9
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <dup>:
.global dup
dup:
 li a7, SYS_dup
 39a:	48a9                	li	a7,10
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a2:	48ad                	li	a7,11
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3aa:	48b1                	li	a7,12
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b2:	48b5                	li	a7,13
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ba:	48b9                	li	a7,14
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <explode>:
.global explode
explode:
 li a7, SYS_explode
 3c2:	48d9                	li	a7,22
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <trace>:
.global trace
trace:
 li a7, SYS_trace
 3ca:	48dd                	li	a7,23
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	f5fff0ef          	jal	342 <write>
}
 3e8:	60e2                	ld	ra,24(sp)
 3ea:	6442                	ld	s0,16(sp)
 3ec:	6105                	addi	sp,sp,32
 3ee:	8082                	ret

00000000000003f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	7139                	addi	sp,sp,-64
 3f2:	fc06                	sd	ra,56(sp)
 3f4:	f822                	sd	s0,48(sp)
 3f6:	f426                	sd	s1,40(sp)
 3f8:	0080                	addi	s0,sp,64
 3fa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fc:	c299                	beqz	a3,402 <printint+0x12>
 3fe:	0805c963          	bltz	a1,490 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 402:	2581                	sext.w	a1,a1
  neg = 0;
 404:	4881                	li	a7,0
 406:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 40a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40c:	2601                	sext.w	a2,a2
 40e:	00000517          	auipc	a0,0x0
 412:	69250513          	addi	a0,a0,1682 # aa0 <digits>
 416:	883a                	mv	a6,a4
 418:	2705                	addiw	a4,a4,1
 41a:	02c5f7bb          	remuw	a5,a1,a2
 41e:	1782                	slli	a5,a5,0x20
 420:	9381                	srli	a5,a5,0x20
 422:	97aa                	add	a5,a5,a0
 424:	0007c783          	lbu	a5,0(a5)
 428:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 42c:	0005879b          	sext.w	a5,a1
 430:	02c5d5bb          	divuw	a1,a1,a2
 434:	0685                	addi	a3,a3,1
 436:	fec7f0e3          	bgeu	a5,a2,416 <printint+0x26>
  if(neg)
 43a:	00088c63          	beqz	a7,452 <printint+0x62>
    buf[i++] = '-';
 43e:	fd070793          	addi	a5,a4,-48
 442:	00878733          	add	a4,a5,s0
 446:	02d00793          	li	a5,45
 44a:	fef70823          	sb	a5,-16(a4)
 44e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 452:	02e05a63          	blez	a4,486 <printint+0x96>
 456:	f04a                	sd	s2,32(sp)
 458:	ec4e                	sd	s3,24(sp)
 45a:	fc040793          	addi	a5,s0,-64
 45e:	00e78933          	add	s2,a5,a4
 462:	fff78993          	addi	s3,a5,-1
 466:	99ba                	add	s3,s3,a4
 468:	377d                	addiw	a4,a4,-1
 46a:	1702                	slli	a4,a4,0x20
 46c:	9301                	srli	a4,a4,0x20
 46e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 472:	fff94583          	lbu	a1,-1(s2)
 476:	8526                	mv	a0,s1
 478:	f5bff0ef          	jal	3d2 <putc>
  while(--i >= 0)
 47c:	197d                	addi	s2,s2,-1
 47e:	ff391ae3          	bne	s2,s3,472 <printint+0x82>
 482:	7902                	ld	s2,32(sp)
 484:	69e2                	ld	s3,24(sp)
}
 486:	70e2                	ld	ra,56(sp)
 488:	7442                	ld	s0,48(sp)
 48a:	74a2                	ld	s1,40(sp)
 48c:	6121                	addi	sp,sp,64
 48e:	8082                	ret
    x = -xx;
 490:	40b005bb          	negw	a1,a1
    neg = 1;
 494:	4885                	li	a7,1
    x = -xx;
 496:	bf85                	j	406 <printint+0x16>

0000000000000498 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 498:	711d                	addi	sp,sp,-96
 49a:	ec86                	sd	ra,88(sp)
 49c:	e8a2                	sd	s0,80(sp)
 49e:	e0ca                	sd	s2,64(sp)
 4a0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a2:	0005c903          	lbu	s2,0(a1)
 4a6:	26090863          	beqz	s2,716 <vprintf+0x27e>
 4aa:	e4a6                	sd	s1,72(sp)
 4ac:	fc4e                	sd	s3,56(sp)
 4ae:	f852                	sd	s4,48(sp)
 4b0:	f456                	sd	s5,40(sp)
 4b2:	f05a                	sd	s6,32(sp)
 4b4:	ec5e                	sd	s7,24(sp)
 4b6:	e862                	sd	s8,16(sp)
 4b8:	e466                	sd	s9,8(sp)
 4ba:	8b2a                	mv	s6,a0
 4bc:	8a2e                	mv	s4,a1
 4be:	8bb2                	mv	s7,a2
  state = 0;
 4c0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4c2:	4481                	li	s1,0
 4c4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ca:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ce:	06c00c93          	li	s9,108
 4d2:	a005                	j	4f2 <vprintf+0x5a>
        putc(fd, c0);
 4d4:	85ca                	mv	a1,s2
 4d6:	855a                	mv	a0,s6
 4d8:	efbff0ef          	jal	3d2 <putc>
 4dc:	a019                	j	4e2 <vprintf+0x4a>
    } else if(state == '%'){
 4de:	03598263          	beq	s3,s5,502 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4e2:	2485                	addiw	s1,s1,1
 4e4:	8726                	mv	a4,s1
 4e6:	009a07b3          	add	a5,s4,s1
 4ea:	0007c903          	lbu	s2,0(a5)
 4ee:	20090c63          	beqz	s2,706 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4f2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f6:	fe0994e3          	bnez	s3,4de <vprintf+0x46>
      if(c0 == '%'){
 4fa:	fd579de3          	bne	a5,s5,4d4 <vprintf+0x3c>
        state = '%';
 4fe:	89be                	mv	s3,a5
 500:	b7cd                	j	4e2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 502:	00ea06b3          	add	a3,s4,a4
 506:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 50a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 50c:	c681                	beqz	a3,514 <vprintf+0x7c>
 50e:	9752                	add	a4,a4,s4
 510:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 514:	03878f63          	beq	a5,s8,552 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 518:	05978963          	beq	a5,s9,56a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 51c:	07500713          	li	a4,117
 520:	0ee78363          	beq	a5,a4,606 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 524:	07800713          	li	a4,120
 528:	12e78563          	beq	a5,a4,652 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 52c:	07000713          	li	a4,112
 530:	14e78a63          	beq	a5,a4,684 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 534:	07300713          	li	a4,115
 538:	18e78a63          	beq	a5,a4,6cc <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 53c:	02500713          	li	a4,37
 540:	04e79563          	bne	a5,a4,58a <vprintf+0xf2>
        putc(fd, '%');
 544:	02500593          	li	a1,37
 548:	855a                	mv	a0,s6
 54a:	e89ff0ef          	jal	3d2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 54e:	4981                	li	s3,0
 550:	bf49                	j	4e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 552:	008b8913          	addi	s2,s7,8
 556:	4685                	li	a3,1
 558:	4629                	li	a2,10
 55a:	000ba583          	lw	a1,0(s7)
 55e:	855a                	mv	a0,s6
 560:	e91ff0ef          	jal	3f0 <printint>
 564:	8bca                	mv	s7,s2
      state = 0;
 566:	4981                	li	s3,0
 568:	bfad                	j	4e2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 56a:	06400793          	li	a5,100
 56e:	02f68963          	beq	a3,a5,5a0 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 572:	06c00793          	li	a5,108
 576:	04f68263          	beq	a3,a5,5ba <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 57a:	07500793          	li	a5,117
 57e:	0af68063          	beq	a3,a5,61e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 582:	07800793          	li	a5,120
 586:	0ef68263          	beq	a3,a5,66a <vprintf+0x1d2>
        putc(fd, '%');
 58a:	02500593          	li	a1,37
 58e:	855a                	mv	a0,s6
 590:	e43ff0ef          	jal	3d2 <putc>
        putc(fd, c0);
 594:	85ca                	mv	a1,s2
 596:	855a                	mv	a0,s6
 598:	e3bff0ef          	jal	3d2 <putc>
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b791                	j	4e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	e43ff0ef          	jal	3f0 <printint>
        i += 1;
 5b2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b4:	8bca                	mv	s7,s2
      state = 0;
 5b6:	4981                	li	s3,0
        i += 1;
 5b8:	b72d                	j	4e2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ba:	06400793          	li	a5,100
 5be:	02f60763          	beq	a2,a5,5ec <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5c2:	07500793          	li	a5,117
 5c6:	06f60963          	beq	a2,a5,638 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ca:	07800793          	li	a5,120
 5ce:	faf61ee3          	bne	a2,a5,58a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4641                	li	a2,16
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	e11ff0ef          	jal	3f0 <printint>
        i += 2;
 5e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
        i += 2;
 5ea:	bde5                	j	4e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4685                	li	a3,1
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	df7ff0ef          	jal	3f0 <printint>
        i += 2;
 5fe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	bdf9                	j	4e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 606:	008b8913          	addi	s2,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	dddff0ef          	jal	3f0 <printint>
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b5d9                	j	4e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	008b8913          	addi	s2,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000ba583          	lw	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	dc5ff0ef          	jal	3f0 <printint>
        i += 1;
 630:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
        i += 1;
 636:	b575                	j	4e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	008b8913          	addi	s2,s7,8
 63c:	4681                	li	a3,0
 63e:	4629                	li	a2,10
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	dabff0ef          	jal	3f0 <printint>
        i += 2;
 64a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
        i += 2;
 650:	bd49                	j	4e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 652:	008b8913          	addi	s2,s7,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000ba583          	lw	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d91ff0ef          	jal	3f0 <printint>
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
 668:	bdad                	j	4e2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4641                	li	a2,16
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	d79ff0ef          	jal	3f0 <printint>
        i += 1;
 67c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
        i += 1;
 682:	b585                	j	4e2 <vprintf+0x4a>
 684:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 686:	008b8d13          	addi	s10,s7,8
 68a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 68e:	03000593          	li	a1,48
 692:	855a                	mv	a0,s6
 694:	d3fff0ef          	jal	3d2 <putc>
  putc(fd, 'x');
 698:	07800593          	li	a1,120
 69c:	855a                	mv	a0,s6
 69e:	d35ff0ef          	jal	3d2 <putc>
 6a2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a4:	00000b97          	auipc	s7,0x0
 6a8:	3fcb8b93          	addi	s7,s7,1020 # aa0 <digits>
 6ac:	03c9d793          	srli	a5,s3,0x3c
 6b0:	97de                	add	a5,a5,s7
 6b2:	0007c583          	lbu	a1,0(a5)
 6b6:	855a                	mv	a0,s6
 6b8:	d1bff0ef          	jal	3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6bc:	0992                	slli	s3,s3,0x4
 6be:	397d                	addiw	s2,s2,-1
 6c0:	fe0916e3          	bnez	s2,6ac <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6c4:	8bea                	mv	s7,s10
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	6d02                	ld	s10,0(sp)
 6ca:	bd21                	j	4e2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6cc:	008b8993          	addi	s3,s7,8
 6d0:	000bb903          	ld	s2,0(s7)
 6d4:	00090f63          	beqz	s2,6f2 <vprintf+0x25a>
        for(; *s; s++)
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	c195                	beqz	a1,700 <vprintf+0x268>
          putc(fd, *s);
 6de:	855a                	mv	a0,s6
 6e0:	cf3ff0ef          	jal	3d2 <putc>
        for(; *s; s++)
 6e4:	0905                	addi	s2,s2,1
 6e6:	00094583          	lbu	a1,0(s2)
 6ea:	f9f5                	bnez	a1,6de <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bbcd                	j	4e2 <vprintf+0x4a>
          s = "(null)";
 6f2:	00000917          	auipc	s2,0x0
 6f6:	3a690913          	addi	s2,s2,934 # a98 <malloc+0x29a>
        for(; *s; s++)
 6fa:	02800593          	li	a1,40
 6fe:	b7c5                	j	6de <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 700:	8bce                	mv	s7,s3
      state = 0;
 702:	4981                	li	s3,0
 704:	bbf9                	j	4e2 <vprintf+0x4a>
 706:	64a6                	ld	s1,72(sp)
 708:	79e2                	ld	s3,56(sp)
 70a:	7a42                	ld	s4,48(sp)
 70c:	7aa2                	ld	s5,40(sp)
 70e:	7b02                	ld	s6,32(sp)
 710:	6be2                	ld	s7,24(sp)
 712:	6c42                	ld	s8,16(sp)
 714:	6ca2                	ld	s9,8(sp)
    }
  }
}
 716:	60e6                	ld	ra,88(sp)
 718:	6446                	ld	s0,80(sp)
 71a:	6906                	ld	s2,64(sp)
 71c:	6125                	addi	sp,sp,96
 71e:	8082                	ret

0000000000000720 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 720:	715d                	addi	sp,sp,-80
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e010                	sd	a2,0(s0)
 72a:	e414                	sd	a3,8(s0)
 72c:	e818                	sd	a4,16(s0)
 72e:	ec1c                	sd	a5,24(s0)
 730:	03043023          	sd	a6,32(s0)
 734:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73c:	8622                	mv	a2,s0
 73e:	d5bff0ef          	jal	498 <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <printf>:

void
printf(const char *fmt, ...)
{
 74a:	711d                	addi	sp,sp,-96
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e40c                	sd	a1,8(s0)
 754:	e810                	sd	a2,16(s0)
 756:	ec14                	sd	a3,24(s0)
 758:	f018                	sd	a4,32(s0)
 75a:	f41c                	sd	a5,40(s0)
 75c:	03043823          	sd	a6,48(s0)
 760:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 764:	00840613          	addi	a2,s0,8
 768:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76c:	85aa                	mv	a1,a0
 76e:	4505                	li	a0,1
 770:	d29ff0ef          	jal	498 <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6125                	addi	sp,sp,96
 77a:	8082                	ret

000000000000077c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77c:	1141                	addi	sp,sp,-16
 77e:	e422                	sd	s0,8(sp)
 780:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 782:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	00001797          	auipc	a5,0x1
 78a:	87a7b783          	ld	a5,-1926(a5) # 1000 <freep>
 78e:	a02d                	j	7b8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 790:	4618                	lw	a4,8(a2)
 792:	9f2d                	addw	a4,a4,a1
 794:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	6398                	ld	a4,0(a5)
 79a:	6310                	ld	a2,0(a4)
 79c:	a83d                	j	7da <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79e:	ff852703          	lw	a4,-8(a0)
 7a2:	9f31                	addw	a4,a4,a2
 7a4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a6:	ff053683          	ld	a3,-16(a0)
 7aa:	a091                	j	7ee <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ac:	6398                	ld	a4,0(a5)
 7ae:	00e7e463          	bltu	a5,a4,7b6 <free+0x3a>
 7b2:	00e6ea63          	bltu	a3,a4,7c6 <free+0x4a>
{
 7b6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	fed7fae3          	bgeu	a5,a3,7ac <free+0x30>
 7bc:	6398                	ld	a4,0(a5)
 7be:	00e6e463          	bltu	a3,a4,7c6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	fee7eae3          	bltu	a5,a4,7b6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c6:	ff852583          	lw	a1,-8(a0)
 7ca:	6390                	ld	a2,0(a5)
 7cc:	02059813          	slli	a6,a1,0x20
 7d0:	01c85713          	srli	a4,a6,0x1c
 7d4:	9736                	add	a4,a4,a3
 7d6:	fae60de3          	beq	a2,a4,790 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7da:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7de:	4790                	lw	a2,8(a5)
 7e0:	02061593          	slli	a1,a2,0x20
 7e4:	01c5d713          	srli	a4,a1,0x1c
 7e8:	973e                	add	a4,a4,a5
 7ea:	fae68ae3          	beq	a3,a4,79e <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ee:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f0:	00001717          	auipc	a4,0x1
 7f4:	80f73823          	sd	a5,-2032(a4) # 1000 <freep>
}
 7f8:	6422                	ld	s0,8(sp)
 7fa:	0141                	addi	sp,sp,16
 7fc:	8082                	ret

00000000000007fe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fe:	7139                	addi	sp,sp,-64
 800:	fc06                	sd	ra,56(sp)
 802:	f822                	sd	s0,48(sp)
 804:	f426                	sd	s1,40(sp)
 806:	ec4e                	sd	s3,24(sp)
 808:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80a:	02051493          	slli	s1,a0,0x20
 80e:	9081                	srli	s1,s1,0x20
 810:	04bd                	addi	s1,s1,15
 812:	8091                	srli	s1,s1,0x4
 814:	0014899b          	addiw	s3,s1,1
 818:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 81a:	00000517          	auipc	a0,0x0
 81e:	7e653503          	ld	a0,2022(a0) # 1000 <freep>
 822:	c915                	beqz	a0,856 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 824:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 826:	4798                	lw	a4,8(a5)
 828:	08977a63          	bgeu	a4,s1,8bc <malloc+0xbe>
 82c:	f04a                	sd	s2,32(sp)
 82e:	e852                	sd	s4,16(sp)
 830:	e456                	sd	s5,8(sp)
 832:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 834:	8a4e                	mv	s4,s3
 836:	0009871b          	sext.w	a4,s3
 83a:	6685                	lui	a3,0x1
 83c:	00d77363          	bgeu	a4,a3,842 <malloc+0x44>
 840:	6a05                	lui	s4,0x1
 842:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 846:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 84a:	00000917          	auipc	s2,0x0
 84e:	7b690913          	addi	s2,s2,1974 # 1000 <freep>
  if(p == (char*)-1)
 852:	5afd                	li	s5,-1
 854:	a081                	j	894 <malloc+0x96>
 856:	f04a                	sd	s2,32(sp)
 858:	e852                	sd	s4,16(sp)
 85a:	e456                	sd	s5,8(sp)
 85c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 85e:	00000797          	auipc	a5,0x0
 862:	7b278793          	addi	a5,a5,1970 # 1010 <base>
 866:	00000717          	auipc	a4,0x0
 86a:	78f73d23          	sd	a5,1946(a4) # 1000 <freep>
 86e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 870:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 874:	b7c1                	j	834 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	e118                	sd	a4,0(a0)
 87a:	a8a9                	j	8d4 <malloc+0xd6>
  hp->s.size = nu;
 87c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 880:	0541                	addi	a0,a0,16
 882:	efbff0ef          	jal	77c <free>
  return freep;
 886:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 88a:	c12d                	beqz	a0,8ec <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88e:	4798                	lw	a4,8(a5)
 890:	02977263          	bgeu	a4,s1,8b4 <malloc+0xb6>
    if(p == freep)
 894:	00093703          	ld	a4,0(s2)
 898:	853e                	mv	a0,a5
 89a:	fef719e3          	bne	a4,a5,88c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 89e:	8552                	mv	a0,s4
 8a0:	b0bff0ef          	jal	3aa <sbrk>
  if(p == (char*)-1)
 8a4:	fd551ce3          	bne	a0,s5,87c <malloc+0x7e>
        return 0;
 8a8:	4501                	li	a0,0
 8aa:	7902                	ld	s2,32(sp)
 8ac:	6a42                	ld	s4,16(sp)
 8ae:	6aa2                	ld	s5,8(sp)
 8b0:	6b02                	ld	s6,0(sp)
 8b2:	a03d                	j	8e0 <malloc+0xe2>
 8b4:	7902                	ld	s2,32(sp)
 8b6:	6a42                	ld	s4,16(sp)
 8b8:	6aa2                	ld	s5,8(sp)
 8ba:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8bc:	fae48de3          	beq	s1,a4,876 <malloc+0x78>
        p->s.size -= nunits;
 8c0:	4137073b          	subw	a4,a4,s3
 8c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c6:	02071693          	slli	a3,a4,0x20
 8ca:	01c6d713          	srli	a4,a3,0x1c
 8ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d4:	00000717          	auipc	a4,0x0
 8d8:	72a73623          	sd	a0,1836(a4) # 1000 <freep>
      return (void*)(p + 1);
 8dc:	01078513          	addi	a0,a5,16
  }
}
 8e0:	70e2                	ld	ra,56(sp)
 8e2:	7442                	ld	s0,48(sp)
 8e4:	74a2                	ld	s1,40(sp)
 8e6:	69e2                	ld	s3,24(sp)
 8e8:	6121                	addi	sp,sp,64
 8ea:	8082                	ret
 8ec:	7902                	ld	s2,32(sp)
 8ee:	6a42                	ld	s4,16(sp)
 8f0:	6aa2                	ld	s5,8(sp)
 8f2:	6b02                	ld	s6,0(sp)
 8f4:	b7f5                	j	8e0 <malloc+0xe2>
