
user/_trace3: formato do arquivo elf64-littleriscv


Desmontagem da seção .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"

int main() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("=== TESTE 3: Rastreamento de FORK e heranca ===\n");
   8:	00001517          	auipc	a0,0x1
   c:	95850513          	addi	a0,a0,-1704 # 960 <malloc+0xf8>
  10:	7a4000ef          	jal	7b4 <printf>
    printf("Equivalente a: trace 2 usertests forkforkfork\n");
  14:	00001517          	auipc	a0,0x1
  18:	98450513          	addi	a0,a0,-1660 # 998 <malloc+0x130>
  1c:	798000ef          	jal	7b4 <printf>
    printf("Mascara: 2 = 1<<1 (SYS_fork)\n\n");
  20:	00001517          	auipc	a0,0x1
  24:	9a850513          	addi	a0,a0,-1624 # 9c8 <malloc+0x160>
  28:	78c000ef          	jal	7b4 <printf>
    
    // Ativar trace apenas para fork
    trace(2);
  2c:	4509                	li	a0,2
  2e:	406000ef          	jal	434 <trace>
    
    printf("Processo pai (PID %d) iniciando teste de fork...\n", getpid());
  32:	3da000ef          	jal	40c <getpid>
  36:	85aa                	mv	a1,a0
  38:	00001517          	auipc	a0,0x1
  3c:	9b050513          	addi	a0,a0,-1616 # 9e8 <malloc+0x180>
  40:	774000ef          	jal	7b4 <printf>
    
    // Fazer múltiplos forks para demonstrar herança
    printf("\n--- Criando processo filho 1 ---\n");
  44:	00001517          	auipc	a0,0x1
  48:	9dc50513          	addi	a0,a0,-1572 # a20 <malloc+0x1b8>
  4c:	768000ef          	jal	7b4 <printf>
    int pid1 = fork();
  50:	334000ef          	jal	384 <fork>
    if(pid1 == 0) {
  54:	e939                	bnez	a0,aa <main+0xaa>
        // Processo filho 1
        printf("Filho 1 (PID %d) executando...\n", getpid());
  56:	3b6000ef          	jal	40c <getpid>
  5a:	85aa                	mv	a1,a0
  5c:	00001517          	auipc	a0,0x1
  60:	9ec50513          	addi	a0,a0,-1556 # a48 <malloc+0x1e0>
  64:	750000ef          	jal	7b4 <printf>
        
        // Filho também pode fazer fork (herda o trace_mask)
        printf("Filho 1 criando neto...\n");
  68:	00001517          	auipc	a0,0x1
  6c:	a0050513          	addi	a0,a0,-1536 # a68 <malloc+0x200>
  70:	744000ef          	jal	7b4 <printf>
        int pid_neto = fork();
  74:	310000ef          	jal	384 <fork>
        if(pid_neto == 0) {
  78:	ed09                	bnez	a0,92 <main+0x92>
            // Processo neto
            printf("Neto (PID %d) executando e terminando...\n", getpid());
  7a:	392000ef          	jal	40c <getpid>
  7e:	85aa                	mv	a1,a0
  80:	00001517          	auipc	a0,0x1
  84:	a0850513          	addi	a0,a0,-1528 # a88 <malloc+0x220>
  88:	72c000ef          	jal	7b4 <printf>
            exit(0);
  8c:	4501                	li	a0,0
  8e:	2fe000ef          	jal	38c <exit>
        }
        wait(0); // Esperar o neto
  92:	4501                	li	a0,0
  94:	300000ef          	jal	394 <wait>
        printf("Filho 1 terminando...\n");
  98:	00001517          	auipc	a0,0x1
  9c:	a2050513          	addi	a0,a0,-1504 # ab8 <malloc+0x250>
  a0:	714000ef          	jal	7b4 <printf>
        exit(0);
  a4:	4501                	li	a0,0
  a6:	2e6000ef          	jal	38c <exit>
    }
    
    printf("\n--- Criando processo filho 2 ---\n");  
  aa:	00001517          	auipc	a0,0x1
  ae:	a2650513          	addi	a0,a0,-1498 # ad0 <malloc+0x268>
  b2:	702000ef          	jal	7b4 <printf>
    int pid2 = fork();
  b6:	2ce000ef          	jal	384 <fork>
    if(pid2 == 0) {
  ba:	ed09                	bnez	a0,d4 <main+0xd4>
        // Processo filho 2
        printf("Filho 2 (PID %d) executando e terminando...\n", getpid());
  bc:	350000ef          	jal	40c <getpid>
  c0:	85aa                	mv	a1,a0
  c2:	00001517          	auipc	a0,0x1
  c6:	a3650513          	addi	a0,a0,-1482 # af8 <malloc+0x290>
  ca:	6ea000ef          	jal	7b4 <printf>
        exit(0);
  ce:	4501                	li	a0,0
  d0:	2bc000ef          	jal	38c <exit>
    }
    
    // Processo pai espera pelos filhos
    wait(0); // Esperar filho 1
  d4:	4501                	li	a0,0
  d6:	2be000ef          	jal	394 <wait>
    wait(0); // Esperar filho 2
  da:	4501                	li	a0,0
  dc:	2b8000ef          	jal	394 <wait>
    
    printf("\nTeste 3 concluido!\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	a4850513          	addi	a0,a0,-1464 # b28 <malloc+0x2c0>
  e8:	6cc000ef          	jal	7b4 <printf>
    printf("Observe que:\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	a5450513          	addi	a0,a0,-1452 # b40 <malloc+0x2d8>
  f4:	6c0000ef          	jal	7b4 <printf>
    printf("- Todas as chamadas fork foram rastreadas\n");
  f8:	00001517          	auipc	a0,0x1
  fc:	a5850513          	addi	a0,a0,-1448 # b50 <malloc+0x2e8>
 100:	6b4000ef          	jal	7b4 <printf>
    printf("- Filhos herdaram o trace_mask do pai\n");
 104:	00001517          	auipc	a0,0x1
 108:	a7c50513          	addi	a0,a0,-1412 # b80 <malloc+0x318>
 10c:	6a8000ef          	jal	7b4 <printf>
    printf("- Netos também conseguem fazer fork rastreado\n");
 110:	00001517          	auipc	a0,0x1
 114:	a9850513          	addi	a0,a0,-1384 # ba8 <malloc+0x340>
 118:	69c000ef          	jal	7b4 <printf>
    exit(0);
 11c:	4501                	li	a0,0
 11e:	26e000ef          	jal	38c <exit>

0000000000000122 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12a:	ed7ff0ef          	jal	0 <main>
  exit(0);
 12e:	4501                	li	a0,0
 130:	25c000ef          	jal	38c <exit>

0000000000000134 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13a:	87aa                	mv	a5,a0
 13c:	0585                	addi	a1,a1,1
 13e:	0785                	addi	a5,a5,1
 140:	fff5c703          	lbu	a4,-1(a1)
 144:	fee78fa3          	sb	a4,-1(a5)
 148:	fb75                	bnez	a4,13c <strcpy+0x8>
    ;
  return os;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cb91                	beqz	a5,16e <strcmp+0x1e>
 15c:	0005c703          	lbu	a4,0(a1)
 160:	00f71763          	bne	a4,a5,16e <strcmp+0x1e>
    p++, q++;
 164:	0505                	addi	a0,a0,1
 166:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbe5                	bnez	a5,15c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16e:	0005c503          	lbu	a0,0(a1)
}
 172:	40a7853b          	subw	a0,a5,a0
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strlen>:

uint
strlen(const char *s)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf91                	beqz	a5,1a2 <strlen+0x26>
 188:	0505                	addi	a0,a0,1
 18a:	87aa                	mv	a5,a0
 18c:	86be                	mv	a3,a5
 18e:	0785                	addi	a5,a5,1
 190:	fff7c703          	lbu	a4,-1(a5)
 194:	ff65                	bnez	a4,18c <strlen+0x10>
 196:	40a6853b          	subw	a0,a3,a0
 19a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  for(n = 0; s[n]; n++)
 1a2:	4501                	li	a0,0
 1a4:	bfe5                	j	19c <strlen+0x20>

00000000000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ac:	ca19                	beqz	a2,1c2 <memset+0x1c>
 1ae:	87aa                	mv	a5,a0
 1b0:	1602                	slli	a2,a2,0x20
 1b2:	9201                	srli	a2,a2,0x20
 1b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1bc:	0785                	addi	a5,a5,1
 1be:	fee79de3          	bne	a5,a4,1b8 <memset+0x12>
  }
  return dst;
}
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret

00000000000001c8 <strchr>:

char*
strchr(const char *s, char c)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cb99                	beqz	a5,1e8 <strchr+0x20>
    if(*s == c)
 1d4:	00f58763          	beq	a1,a5,1e2 <strchr+0x1a>
  for(; *s; s++)
 1d8:	0505                	addi	a0,a0,1
 1da:	00054783          	lbu	a5,0(a0)
 1de:	fbfd                	bnez	a5,1d4 <strchr+0xc>
      return (char*)s;
  return 0;
 1e0:	4501                	li	a0,0
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  return 0;
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <strchr+0x1a>

00000000000001ec <gets>:

char*
gets(char *buf, int max)
{
 1ec:	711d                	addi	sp,sp,-96
 1ee:	ec86                	sd	ra,88(sp)
 1f0:	e8a2                	sd	s0,80(sp)
 1f2:	e4a6                	sd	s1,72(sp)
 1f4:	e0ca                	sd	s2,64(sp)
 1f6:	fc4e                	sd	s3,56(sp)
 1f8:	f852                	sd	s4,48(sp)
 1fa:	f456                	sd	s5,40(sp)
 1fc:	f05a                	sd	s6,32(sp)
 1fe:	ec5e                	sd	s7,24(sp)
 200:	1080                	addi	s0,sp,96
 202:	8baa                	mv	s7,a0
 204:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	892a                	mv	s2,a0
 208:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20a:	4aa9                	li	s5,10
 20c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 20e:	89a6                	mv	s3,s1
 210:	2485                	addiw	s1,s1,1
 212:	0344d663          	bge	s1,s4,23e <gets+0x52>
    cc = read(0, &c, 1);
 216:	4605                	li	a2,1
 218:	faf40593          	addi	a1,s0,-81
 21c:	4501                	li	a0,0
 21e:	186000ef          	jal	3a4 <read>
    if(cc < 1)
 222:	00a05e63          	blez	a0,23e <gets+0x52>
    buf[i++] = c;
 226:	faf44783          	lbu	a5,-81(s0)
 22a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22e:	01578763          	beq	a5,s5,23c <gets+0x50>
 232:	0905                	addi	s2,s2,1
 234:	fd679de3          	bne	a5,s6,20e <gets+0x22>
    buf[i++] = c;
 238:	89a6                	mv	s3,s1
 23a:	a011                	j	23e <gets+0x52>
 23c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 23e:	99de                	add	s3,s3,s7
 240:	00098023          	sb	zero,0(s3)
  return buf;
}
 244:	855e                	mv	a0,s7
 246:	60e6                	ld	ra,88(sp)
 248:	6446                	ld	s0,80(sp)
 24a:	64a6                	ld	s1,72(sp)
 24c:	6906                	ld	s2,64(sp)
 24e:	79e2                	ld	s3,56(sp)
 250:	7a42                	ld	s4,48(sp)
 252:	7aa2                	ld	s5,40(sp)
 254:	7b02                	ld	s6,32(sp)
 256:	6be2                	ld	s7,24(sp)
 258:	6125                	addi	sp,sp,96
 25a:	8082                	ret

000000000000025c <stat>:

int
stat(const char *n, struct stat *st)
{
 25c:	1101                	addi	sp,sp,-32
 25e:	ec06                	sd	ra,24(sp)
 260:	e822                	sd	s0,16(sp)
 262:	e04a                	sd	s2,0(sp)
 264:	1000                	addi	s0,sp,32
 266:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 268:	4581                	li	a1,0
 26a:	162000ef          	jal	3cc <open>
  if(fd < 0)
 26e:	02054263          	bltz	a0,292 <stat+0x36>
 272:	e426                	sd	s1,8(sp)
 274:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 276:	85ca                	mv	a1,s2
 278:	16c000ef          	jal	3e4 <fstat>
 27c:	892a                	mv	s2,a0
  close(fd);
 27e:	8526                	mv	a0,s1
 280:	134000ef          	jal	3b4 <close>
  return r;
 284:	64a2                	ld	s1,8(sp)
}
 286:	854a                	mv	a0,s2
 288:	60e2                	ld	ra,24(sp)
 28a:	6442                	ld	s0,16(sp)
 28c:	6902                	ld	s2,0(sp)
 28e:	6105                	addi	sp,sp,32
 290:	8082                	ret
    return -1;
 292:	597d                	li	s2,-1
 294:	bfcd                	j	286 <stat+0x2a>

0000000000000296 <atoi>:

int
atoi(const char *s)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29c:	00054683          	lbu	a3,0(a0)
 2a0:	fd06879b          	addiw	a5,a3,-48
 2a4:	0ff7f793          	zext.b	a5,a5
 2a8:	4625                	li	a2,9
 2aa:	02f66863          	bltu	a2,a5,2da <atoi+0x44>
 2ae:	872a                	mv	a4,a0
  n = 0;
 2b0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b2:	0705                	addi	a4,a4,1
 2b4:	0025179b          	slliw	a5,a0,0x2
 2b8:	9fa9                	addw	a5,a5,a0
 2ba:	0017979b          	slliw	a5,a5,0x1
 2be:	9fb5                	addw	a5,a5,a3
 2c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c4:	00074683          	lbu	a3,0(a4)
 2c8:	fd06879b          	addiw	a5,a3,-48
 2cc:	0ff7f793          	zext.b	a5,a5
 2d0:	fef671e3          	bgeu	a2,a5,2b2 <atoi+0x1c>
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <atoi+0x3e>

00000000000002de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e4:	02b57463          	bgeu	a0,a1,30c <memmove+0x2e>
    while(n-- > 0)
 2e8:	00c05f63          	blez	a2,306 <memmove+0x28>
 2ec:	1602                	slli	a2,a2,0x20
 2ee:	9201                	srli	a2,a2,0x20
 2f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f6:	0585                	addi	a1,a1,1
 2f8:	0705                	addi	a4,a4,1
 2fa:	fff5c683          	lbu	a3,-1(a1)
 2fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 302:	fef71ae3          	bne	a4,a5,2f6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
    dst += n;
 30c:	00c50733          	add	a4,a0,a2
    src += n;
 310:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 312:	fec05ae3          	blez	a2,306 <memmove+0x28>
 316:	fff6079b          	addiw	a5,a2,-1
 31a:	1782                	slli	a5,a5,0x20
 31c:	9381                	srli	a5,a5,0x20
 31e:	fff7c793          	not	a5,a5
 322:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 324:	15fd                	addi	a1,a1,-1
 326:	177d                	addi	a4,a4,-1
 328:	0005c683          	lbu	a3,0(a1)
 32c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 330:	fee79ae3          	bne	a5,a4,324 <memmove+0x46>
 334:	bfc9                	j	306 <memmove+0x28>

0000000000000336 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33c:	ca05                	beqz	a2,36c <memcmp+0x36>
 33e:	fff6069b          	addiw	a3,a2,-1
 342:	1682                	slli	a3,a3,0x20
 344:	9281                	srli	a3,a3,0x20
 346:	0685                	addi	a3,a3,1
 348:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34a:	00054783          	lbu	a5,0(a0)
 34e:	0005c703          	lbu	a4,0(a1)
 352:	00e79863          	bne	a5,a4,362 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 356:	0505                	addi	a0,a0,1
    p2++;
 358:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35a:	fed518e3          	bne	a0,a3,34a <memcmp+0x14>
  }
  return 0;
 35e:	4501                	li	a0,0
 360:	a019                	j	366 <memcmp+0x30>
      return *p1 - *p2;
 362:	40e7853b          	subw	a0,a5,a4
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <memcmp+0x30>

0000000000000370 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 378:	f67ff0ef          	jal	2de <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 384:	4885                	li	a7,1
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exit>:
.global exit
exit:
 li a7, SYS_exit
 38c:	4889                	li	a7,2
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <wait>:
.global wait
wait:
 li a7, SYS_wait
 394:	488d                	li	a7,3
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39c:	4891                	li	a7,4
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <read>:
.global read
read:
 li a7, SYS_read
 3a4:	4895                	li	a7,5
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <write>:
.global write
write:
 li a7, SYS_write
 3ac:	48c1                	li	a7,16
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <close>:
.global close
close:
 li a7, SYS_close
 3b4:	48d5                	li	a7,21
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3bc:	4899                	li	a7,6
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c4:	489d                	li	a7,7
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <open>:
.global open
open:
 li a7, SYS_open
 3cc:	48bd                	li	a7,15
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d4:	48c5                	li	a7,17
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3dc:	48c9                	li	a7,18
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e4:	48a1                	li	a7,8
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <link>:
.global link
link:
 li a7, SYS_link
 3ec:	48cd                	li	a7,19
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f4:	48d1                	li	a7,20
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fc:	48a5                	li	a7,9
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <dup>:
.global dup
dup:
 li a7, SYS_dup
 404:	48a9                	li	a7,10
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40c:	48ad                	li	a7,11
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 414:	48b1                	li	a7,12
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41c:	48b5                	li	a7,13
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 424:	48b9                	li	a7,14
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <explode>:
.global explode
explode:
 li a7, SYS_explode
 42c:	48d9                	li	a7,22
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <trace>:
.global trace
trace:
 li a7, SYS_trace
 434:	48dd                	li	a7,23
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43c:	1101                	addi	sp,sp,-32
 43e:	ec06                	sd	ra,24(sp)
 440:	e822                	sd	s0,16(sp)
 442:	1000                	addi	s0,sp,32
 444:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 448:	4605                	li	a2,1
 44a:	fef40593          	addi	a1,s0,-17
 44e:	f5fff0ef          	jal	3ac <write>
}
 452:	60e2                	ld	ra,24(sp)
 454:	6442                	ld	s0,16(sp)
 456:	6105                	addi	sp,sp,32
 458:	8082                	ret

000000000000045a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45a:	7139                	addi	sp,sp,-64
 45c:	fc06                	sd	ra,56(sp)
 45e:	f822                	sd	s0,48(sp)
 460:	f426                	sd	s1,40(sp)
 462:	0080                	addi	s0,sp,64
 464:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 466:	c299                	beqz	a3,46c <printint+0x12>
 468:	0805c963          	bltz	a1,4fa <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46c:	2581                	sext.w	a1,a1
  neg = 0;
 46e:	4881                	li	a7,0
 470:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 474:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 476:	2601                	sext.w	a2,a2
 478:	00000517          	auipc	a0,0x0
 47c:	76850513          	addi	a0,a0,1896 # be0 <digits>
 480:	883a                	mv	a6,a4
 482:	2705                	addiw	a4,a4,1
 484:	02c5f7bb          	remuw	a5,a1,a2
 488:	1782                	slli	a5,a5,0x20
 48a:	9381                	srli	a5,a5,0x20
 48c:	97aa                	add	a5,a5,a0
 48e:	0007c783          	lbu	a5,0(a5)
 492:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 496:	0005879b          	sext.w	a5,a1
 49a:	02c5d5bb          	divuw	a1,a1,a2
 49e:	0685                	addi	a3,a3,1
 4a0:	fec7f0e3          	bgeu	a5,a2,480 <printint+0x26>
  if(neg)
 4a4:	00088c63          	beqz	a7,4bc <printint+0x62>
    buf[i++] = '-';
 4a8:	fd070793          	addi	a5,a4,-48
 4ac:	00878733          	add	a4,a5,s0
 4b0:	02d00793          	li	a5,45
 4b4:	fef70823          	sb	a5,-16(a4)
 4b8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4bc:	02e05a63          	blez	a4,4f0 <printint+0x96>
 4c0:	f04a                	sd	s2,32(sp)
 4c2:	ec4e                	sd	s3,24(sp)
 4c4:	fc040793          	addi	a5,s0,-64
 4c8:	00e78933          	add	s2,a5,a4
 4cc:	fff78993          	addi	s3,a5,-1
 4d0:	99ba                	add	s3,s3,a4
 4d2:	377d                	addiw	a4,a4,-1
 4d4:	1702                	slli	a4,a4,0x20
 4d6:	9301                	srli	a4,a4,0x20
 4d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4dc:	fff94583          	lbu	a1,-1(s2)
 4e0:	8526                	mv	a0,s1
 4e2:	f5bff0ef          	jal	43c <putc>
  while(--i >= 0)
 4e6:	197d                	addi	s2,s2,-1
 4e8:	ff391ae3          	bne	s2,s3,4dc <printint+0x82>
 4ec:	7902                	ld	s2,32(sp)
 4ee:	69e2                	ld	s3,24(sp)
}
 4f0:	70e2                	ld	ra,56(sp)
 4f2:	7442                	ld	s0,48(sp)
 4f4:	74a2                	ld	s1,40(sp)
 4f6:	6121                	addi	sp,sp,64
 4f8:	8082                	ret
    x = -xx;
 4fa:	40b005bb          	negw	a1,a1
    neg = 1;
 4fe:	4885                	li	a7,1
    x = -xx;
 500:	bf85                	j	470 <printint+0x16>

0000000000000502 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 502:	711d                	addi	sp,sp,-96
 504:	ec86                	sd	ra,88(sp)
 506:	e8a2                	sd	s0,80(sp)
 508:	e0ca                	sd	s2,64(sp)
 50a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 50c:	0005c903          	lbu	s2,0(a1)
 510:	26090863          	beqz	s2,780 <vprintf+0x27e>
 514:	e4a6                	sd	s1,72(sp)
 516:	fc4e                	sd	s3,56(sp)
 518:	f852                	sd	s4,48(sp)
 51a:	f456                	sd	s5,40(sp)
 51c:	f05a                	sd	s6,32(sp)
 51e:	ec5e                	sd	s7,24(sp)
 520:	e862                	sd	s8,16(sp)
 522:	e466                	sd	s9,8(sp)
 524:	8b2a                	mv	s6,a0
 526:	8a2e                	mv	s4,a1
 528:	8bb2                	mv	s7,a2
  state = 0;
 52a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 52c:	4481                	li	s1,0
 52e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 530:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 534:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 538:	06c00c93          	li	s9,108
 53c:	a005                	j	55c <vprintf+0x5a>
        putc(fd, c0);
 53e:	85ca                	mv	a1,s2
 540:	855a                	mv	a0,s6
 542:	efbff0ef          	jal	43c <putc>
 546:	a019                	j	54c <vprintf+0x4a>
    } else if(state == '%'){
 548:	03598263          	beq	s3,s5,56c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 54c:	2485                	addiw	s1,s1,1
 54e:	8726                	mv	a4,s1
 550:	009a07b3          	add	a5,s4,s1
 554:	0007c903          	lbu	s2,0(a5)
 558:	20090c63          	beqz	s2,770 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 55c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 560:	fe0994e3          	bnez	s3,548 <vprintf+0x46>
      if(c0 == '%'){
 564:	fd579de3          	bne	a5,s5,53e <vprintf+0x3c>
        state = '%';
 568:	89be                	mv	s3,a5
 56a:	b7cd                	j	54c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 56c:	00ea06b3          	add	a3,s4,a4
 570:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 574:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 576:	c681                	beqz	a3,57e <vprintf+0x7c>
 578:	9752                	add	a4,a4,s4
 57a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 57e:	03878f63          	beq	a5,s8,5bc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 582:	05978963          	beq	a5,s9,5d4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 586:	07500713          	li	a4,117
 58a:	0ee78363          	beq	a5,a4,670 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 58e:	07800713          	li	a4,120
 592:	12e78563          	beq	a5,a4,6bc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 596:	07000713          	li	a4,112
 59a:	14e78a63          	beq	a5,a4,6ee <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 59e:	07300713          	li	a4,115
 5a2:	18e78a63          	beq	a5,a4,736 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a6:	02500713          	li	a4,37
 5aa:	04e79563          	bne	a5,a4,5f4 <vprintf+0xf2>
        putc(fd, '%');
 5ae:	02500593          	li	a1,37
 5b2:	855a                	mv	a0,s6
 5b4:	e89ff0ef          	jal	43c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bf49                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e91ff0ef          	jal	45a <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bfad                	j	54c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d4:	06400793          	li	a5,100
 5d8:	02f68963          	beq	a3,a5,60a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5dc:	06c00793          	li	a5,108
 5e0:	04f68263          	beq	a3,a5,624 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5e4:	07500793          	li	a5,117
 5e8:	0af68063          	beq	a3,a5,688 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5ec:	07800793          	li	a5,120
 5f0:	0ef68263          	beq	a3,a5,6d4 <vprintf+0x1d2>
        putc(fd, '%');
 5f4:	02500593          	li	a1,37
 5f8:	855a                	mv	a0,s6
 5fa:	e43ff0ef          	jal	43c <putc>
        putc(fd, c0);
 5fe:	85ca                	mv	a1,s2
 600:	855a                	mv	a0,s6
 602:	e3bff0ef          	jal	43c <putc>
      state = 0;
 606:	4981                	li	s3,0
 608:	b791                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	008b8913          	addi	s2,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000ba583          	lw	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e43ff0ef          	jal	45a <printint>
        i += 1;
 61c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
        i += 1;
 622:	b72d                	j	54c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 624:	06400793          	li	a5,100
 628:	02f60763          	beq	a2,a5,656 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 62c:	07500793          	li	a5,117
 630:	06f60963          	beq	a2,a5,6a2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 634:	07800793          	li	a5,120
 638:	faf61ee3          	bne	a2,a5,5f4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000ba583          	lw	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e11ff0ef          	jal	45a <printint>
        i += 2;
 64e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	bde5                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 656:	008b8913          	addi	s2,s7,8
 65a:	4685                	li	a3,1
 65c:	4629                	li	a2,10
 65e:	000ba583          	lw	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	df7ff0ef          	jal	45a <printint>
        i += 2;
 668:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66a:	8bca                	mv	s7,s2
      state = 0;
 66c:	4981                	li	s3,0
        i += 2;
 66e:	bdf9                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 670:	008b8913          	addi	s2,s7,8
 674:	4681                	li	a3,0
 676:	4629                	li	a2,10
 678:	000ba583          	lw	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	dddff0ef          	jal	45a <printint>
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	b5d9                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000ba583          	lw	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	dc5ff0ef          	jal	45a <printint>
        i += 1;
 69a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 1;
 6a0:	b575                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4629                	li	a2,10
 6aa:	000ba583          	lw	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	dabff0ef          	jal	45a <printint>
        i += 2;
 6b4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
        i += 2;
 6ba:	bd49                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000ba583          	lw	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	d91ff0ef          	jal	45a <printint>
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bdad                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	d79ff0ef          	jal	45a <printint>
        i += 1;
 6e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
        i += 1;
 6ec:	b585                	j	54c <vprintf+0x4a>
 6ee:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f0:	008b8d13          	addi	s10,s7,8
 6f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f8:	03000593          	li	a1,48
 6fc:	855a                	mv	a0,s6
 6fe:	d3fff0ef          	jal	43c <putc>
  putc(fd, 'x');
 702:	07800593          	li	a1,120
 706:	855a                	mv	a0,s6
 708:	d35ff0ef          	jal	43c <putc>
 70c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70e:	00000b97          	auipc	s7,0x0
 712:	4d2b8b93          	addi	s7,s7,1234 # be0 <digits>
 716:	03c9d793          	srli	a5,s3,0x3c
 71a:	97de                	add	a5,a5,s7
 71c:	0007c583          	lbu	a1,0(a5)
 720:	855a                	mv	a0,s6
 722:	d1bff0ef          	jal	43c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 726:	0992                	slli	s3,s3,0x4
 728:	397d                	addiw	s2,s2,-1
 72a:	fe0916e3          	bnez	s2,716 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 72e:	8bea                	mv	s7,s10
      state = 0;
 730:	4981                	li	s3,0
 732:	6d02                	ld	s10,0(sp)
 734:	bd21                	j	54c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 736:	008b8993          	addi	s3,s7,8
 73a:	000bb903          	ld	s2,0(s7)
 73e:	00090f63          	beqz	s2,75c <vprintf+0x25a>
        for(; *s; s++)
 742:	00094583          	lbu	a1,0(s2)
 746:	c195                	beqz	a1,76a <vprintf+0x268>
          putc(fd, *s);
 748:	855a                	mv	a0,s6
 74a:	cf3ff0ef          	jal	43c <putc>
        for(; *s; s++)
 74e:	0905                	addi	s2,s2,1
 750:	00094583          	lbu	a1,0(s2)
 754:	f9f5                	bnez	a1,748 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 756:	8bce                	mv	s7,s3
      state = 0;
 758:	4981                	li	s3,0
 75a:	bbcd                	j	54c <vprintf+0x4a>
          s = "(null)";
 75c:	00000917          	auipc	s2,0x0
 760:	47c90913          	addi	s2,s2,1148 # bd8 <malloc+0x370>
        for(; *s; s++)
 764:	02800593          	li	a1,40
 768:	b7c5                	j	748 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 76a:	8bce                	mv	s7,s3
      state = 0;
 76c:	4981                	li	s3,0
 76e:	bbf9                	j	54c <vprintf+0x4a>
 770:	64a6                	ld	s1,72(sp)
 772:	79e2                	ld	s3,56(sp)
 774:	7a42                	ld	s4,48(sp)
 776:	7aa2                	ld	s5,40(sp)
 778:	7b02                	ld	s6,32(sp)
 77a:	6be2                	ld	s7,24(sp)
 77c:	6c42                	ld	s8,16(sp)
 77e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 780:	60e6                	ld	ra,88(sp)
 782:	6446                	ld	s0,80(sp)
 784:	6906                	ld	s2,64(sp)
 786:	6125                	addi	sp,sp,96
 788:	8082                	ret

000000000000078a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78a:	715d                	addi	sp,sp,-80
 78c:	ec06                	sd	ra,24(sp)
 78e:	e822                	sd	s0,16(sp)
 790:	1000                	addi	s0,sp,32
 792:	e010                	sd	a2,0(s0)
 794:	e414                	sd	a3,8(s0)
 796:	e818                	sd	a4,16(s0)
 798:	ec1c                	sd	a5,24(s0)
 79a:	03043023          	sd	a6,32(s0)
 79e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a6:	8622                	mv	a2,s0
 7a8:	d5bff0ef          	jal	502 <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6161                	addi	sp,sp,80
 7b2:	8082                	ret

00000000000007b4 <printf>:

void
printf(const char *fmt, ...)
{
 7b4:	711d                	addi	sp,sp,-96
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e40c                	sd	a1,8(s0)
 7be:	e810                	sd	a2,16(s0)
 7c0:	ec14                	sd	a3,24(s0)
 7c2:	f018                	sd	a4,32(s0)
 7c4:	f41c                	sd	a5,40(s0)
 7c6:	03043823          	sd	a6,48(s0)
 7ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ce:	00840613          	addi	a2,s0,8
 7d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d6:	85aa                	mv	a1,a0
 7d8:	4505                	li	a0,1
 7da:	d29ff0ef          	jal	502 <vprintf>
}
 7de:	60e2                	ld	ra,24(sp)
 7e0:	6442                	ld	s0,16(sp)
 7e2:	6125                	addi	sp,sp,96
 7e4:	8082                	ret

00000000000007e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e6:	1141                	addi	sp,sp,-16
 7e8:	e422                	sd	s0,8(sp)
 7ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	00001797          	auipc	a5,0x1
 7f4:	8107b783          	ld	a5,-2032(a5) # 1000 <freep>
 7f8:	a02d                	j	822 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fa:	4618                	lw	a4,8(a2)
 7fc:	9f2d                	addw	a4,a4,a1
 7fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	6310                	ld	a2,0(a4)
 806:	a83d                	j	844 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 808:	ff852703          	lw	a4,-8(a0)
 80c:	9f31                	addw	a4,a4,a2
 80e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 810:	ff053683          	ld	a3,-16(a0)
 814:	a091                	j	858 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 816:	6398                	ld	a4,0(a5)
 818:	00e7e463          	bltu	a5,a4,820 <free+0x3a>
 81c:	00e6ea63          	bltu	a3,a4,830 <free+0x4a>
{
 820:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	fed7fae3          	bgeu	a5,a3,816 <free+0x30>
 826:	6398                	ld	a4,0(a5)
 828:	00e6e463          	bltu	a3,a4,830 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82c:	fee7eae3          	bltu	a5,a4,820 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 830:	ff852583          	lw	a1,-8(a0)
 834:	6390                	ld	a2,0(a5)
 836:	02059813          	slli	a6,a1,0x20
 83a:	01c85713          	srli	a4,a6,0x1c
 83e:	9736                	add	a4,a4,a3
 840:	fae60de3          	beq	a2,a4,7fa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 844:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 848:	4790                	lw	a2,8(a5)
 84a:	02061593          	slli	a1,a2,0x20
 84e:	01c5d713          	srli	a4,a1,0x1c
 852:	973e                	add	a4,a4,a5
 854:	fae68ae3          	beq	a3,a4,808 <free+0x22>
    p->s.ptr = bp->s.ptr;
 858:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85a:	00000717          	auipc	a4,0x0
 85e:	7af73323          	sd	a5,1958(a4) # 1000 <freep>
}
 862:	6422                	ld	s0,8(sp)
 864:	0141                	addi	sp,sp,16
 866:	8082                	ret

0000000000000868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f426                	sd	s1,40(sp)
 870:	ec4e                	sd	s3,24(sp)
 872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 874:	02051493          	slli	s1,a0,0x20
 878:	9081                	srli	s1,s1,0x20
 87a:	04bd                	addi	s1,s1,15
 87c:	8091                	srli	s1,s1,0x4
 87e:	0014899b          	addiw	s3,s1,1
 882:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 884:	00000517          	auipc	a0,0x0
 888:	77c53503          	ld	a0,1916(a0) # 1000 <freep>
 88c:	c915                	beqz	a0,8c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	08977a63          	bgeu	a4,s1,926 <malloc+0xbe>
 896:	f04a                	sd	s2,32(sp)
 898:	e852                	sd	s4,16(sp)
 89a:	e456                	sd	s5,8(sp)
 89c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 89e:	8a4e                	mv	s4,s3
 8a0:	0009871b          	sext.w	a4,s3
 8a4:	6685                	lui	a3,0x1
 8a6:	00d77363          	bgeu	a4,a3,8ac <malloc+0x44>
 8aa:	6a05                	lui	s4,0x1
 8ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b4:	00000917          	auipc	s2,0x0
 8b8:	74c90913          	addi	s2,s2,1868 # 1000 <freep>
  if(p == (char*)-1)
 8bc:	5afd                	li	s5,-1
 8be:	a081                	j	8fe <malloc+0x96>
 8c0:	f04a                	sd	s2,32(sp)
 8c2:	e852                	sd	s4,16(sp)
 8c4:	e456                	sd	s5,8(sp)
 8c6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c8:	00000797          	auipc	a5,0x0
 8cc:	74878793          	addi	a5,a5,1864 # 1010 <base>
 8d0:	00000717          	auipc	a4,0x0
 8d4:	72f73823          	sd	a5,1840(a4) # 1000 <freep>
 8d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8de:	b7c1                	j	89e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8e0:	6398                	ld	a4,0(a5)
 8e2:	e118                	sd	a4,0(a0)
 8e4:	a8a9                	j	93e <malloc+0xd6>
  hp->s.size = nu;
 8e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ea:	0541                	addi	a0,a0,16
 8ec:	efbff0ef          	jal	7e6 <free>
  return freep;
 8f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f4:	c12d                	beqz	a0,956 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	02977263          	bgeu	a4,s1,91e <malloc+0xb6>
    if(p == freep)
 8fe:	00093703          	ld	a4,0(s2)
 902:	853e                	mv	a0,a5
 904:	fef719e3          	bne	a4,a5,8f6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 908:	8552                	mv	a0,s4
 90a:	b0bff0ef          	jal	414 <sbrk>
  if(p == (char*)-1)
 90e:	fd551ce3          	bne	a0,s5,8e6 <malloc+0x7e>
        return 0;
 912:	4501                	li	a0,0
 914:	7902                	ld	s2,32(sp)
 916:	6a42                	ld	s4,16(sp)
 918:	6aa2                	ld	s5,8(sp)
 91a:	6b02                	ld	s6,0(sp)
 91c:	a03d                	j	94a <malloc+0xe2>
 91e:	7902                	ld	s2,32(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 926:	fae48de3          	beq	s1,a4,8e0 <malloc+0x78>
        p->s.size -= nunits;
 92a:	4137073b          	subw	a4,a4,s3
 92e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 930:	02071693          	slli	a3,a4,0x20
 934:	01c6d713          	srli	a4,a3,0x1c
 938:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93e:	00000717          	auipc	a4,0x0
 942:	6ca73123          	sd	a0,1730(a4) # 1000 <freep>
      return (void*)(p + 1);
 946:	01078513          	addi	a0,a5,16
  }
}
 94a:	70e2                	ld	ra,56(sp)
 94c:	7442                	ld	s0,48(sp)
 94e:	74a2                	ld	s1,40(sp)
 950:	69e2                	ld	s3,24(sp)
 952:	6121                	addi	sp,sp,64
 954:	8082                	ret
 956:	7902                	ld	s2,32(sp)
 958:	6a42                	ld	s4,16(sp)
 95a:	6aa2                	ld	s5,8(sp)
 95c:	6b02                	ld	s6,0(sp)
 95e:	b7f5                	j	94a <malloc+0xe2>
