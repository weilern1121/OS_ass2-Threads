
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 c4 0a 00 00       	push   $0xac4
  19:	e8 64 03 00 00       	call   382 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 9f 00 00 00    	js     c8 <main+0xc8>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 87 03 00 00       	call   3ba <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 7b 03 00 00       	call   3ba <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 cc 0a 00 00       	push   $0xacc
  50:	6a 01                	push   $0x1
  52:	e8 79 04 00 00       	call   4d0 <printf>
    pid = fork();
  57:	e8 de 02 00 00       	call   33a <fork>
    if(pid < 0){
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	85 c0                	test   %eax,%eax
    pid = fork();
  61:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  63:	78 2c                	js     91 <main+0x91>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  65:	74 3d                	je     a4 <main+0xa4>
  67:	89 f6                	mov    %esi,%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  70:	e8 d5 02 00 00       	call   34a <wait>
  75:	85 c0                	test   %eax,%eax
  77:	78 cf                	js     48 <main+0x48>
  79:	39 c3                	cmp    %eax,%ebx
  7b:	74 cb                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  7d:	83 ec 08             	sub    $0x8,%esp
  80:	68 0b 0b 00 00       	push   $0xb0b
  85:	6a 01                	push   $0x1
  87:	e8 44 04 00 00       	call   4d0 <printf>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	eb df                	jmp    70 <main+0x70>
      printf(1, "init: fork failed\n");
  91:	53                   	push   %ebx
  92:	53                   	push   %ebx
  93:	68 df 0a 00 00       	push   $0xadf
  98:	6a 01                	push   $0x1
  9a:	e8 31 04 00 00       	call   4d0 <printf>
      exit();
  9f:	e8 9e 02 00 00       	call   342 <exit>
      exec("sh", argv);
  a4:	50                   	push   %eax
  a5:	50                   	push   %eax
  a6:	68 f8 0e 00 00       	push   $0xef8
  ab:	68 f2 0a 00 00       	push   $0xaf2
  b0:	e8 c5 02 00 00       	call   37a <exec>
      printf(1, "init: exec sh failed\n");
  b5:	5a                   	pop    %edx
  b6:	59                   	pop    %ecx
  b7:	68 f5 0a 00 00       	push   $0xaf5
  bc:	6a 01                	push   $0x1
  be:	e8 0d 04 00 00       	call   4d0 <printf>
      exit();
  c3:	e8 7a 02 00 00       	call   342 <exit>
    mknod("console", 1, 1);
  c8:	50                   	push   %eax
  c9:	6a 01                	push   $0x1
  cb:	6a 01                	push   $0x1
  cd:	68 c4 0a 00 00       	push   $0xac4
  d2:	e8 b3 02 00 00       	call   38a <mknod>
    open("console", O_RDWR);
  d7:	58                   	pop    %eax
  d8:	5a                   	pop    %edx
  d9:	6a 02                	push   $0x2
  db:	68 c4 0a 00 00       	push   $0xac4
  e0:	e8 9d 02 00 00       	call   382 <open>
  e5:	83 c4 10             	add    $0x10,%esp
  e8:	e9 3c ff ff ff       	jmp    29 <main+0x29>
  ed:	66 90                	xchg   %ax,%ax
  ef:	90                   	nop

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	89 c2                	mov    %eax,%edx
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 100:	83 c1 01             	add    $0x1,%ecx
 103:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 107:	83 c2 01             	add    $0x1,%edx
 10a:	84 db                	test   %bl,%bl
 10c:	88 5a ff             	mov    %bl,-0x1(%edx)
 10f:	75 ef                	jne    100 <strcpy+0x10>
    ;
  return os;
}
 111:	5b                   	pop    %ebx
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    
 114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 11a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 55 08             	mov    0x8(%ebp),%edx
 127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 12a:	0f b6 02             	movzbl (%edx),%eax
 12d:	0f b6 19             	movzbl (%ecx),%ebx
 130:	84 c0                	test   %al,%al
 132:	75 1c                	jne    150 <strcmp+0x30>
 134:	eb 2a                	jmp    160 <strcmp+0x40>
 136:	8d 76 00             	lea    0x0(%esi),%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 140:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 143:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 146:	83 c1 01             	add    $0x1,%ecx
 149:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 14c:	84 c0                	test   %al,%al
 14e:	74 10                	je     160 <strcmp+0x40>
 150:	38 d8                	cmp    %bl,%al
 152:	74 ec                	je     140 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 154:	29 d8                	sub    %ebx,%eax
}
 156:	5b                   	pop    %ebx
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 160:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 162:	29 d8                	sub    %ebx,%eax
}
 164:	5b                   	pop    %ebx
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
 167:	89 f6                	mov    %esi,%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <strlen>:

uint
strlen(const char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 176:	80 39 00             	cmpb   $0x0,(%ecx)
 179:	74 15                	je     190 <strlen+0x20>
 17b:	31 d2                	xor    %edx,%edx
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	83 c2 01             	add    $0x1,%edx
 183:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 187:	89 d0                	mov    %edx,%eax
 189:	75 f5                	jne    180 <strlen+0x10>
    ;
  return n;
}
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret    
 18d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 190:	31 c0                	xor    %eax,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    
 194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 19a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	89 d7                	mov    %edx,%edi
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	5f                   	pop    %edi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	89 f6                	mov    %esi,%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1ca:	0f b6 10             	movzbl (%eax),%edx
 1cd:	84 d2                	test   %dl,%dl
 1cf:	74 1d                	je     1ee <strchr+0x2e>
    if(*s == c)
 1d1:	38 d3                	cmp    %dl,%bl
 1d3:	89 d9                	mov    %ebx,%ecx
 1d5:	75 0d                	jne    1e4 <strchr+0x24>
 1d7:	eb 17                	jmp    1f0 <strchr+0x30>
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e0:	38 ca                	cmp    %cl,%dl
 1e2:	74 0c                	je     1f0 <strchr+0x30>
  for(; *s; s++)
 1e4:	83 c0 01             	add    $0x1,%eax
 1e7:	0f b6 10             	movzbl (%eax),%edx
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strchr+0x20>
      return (char*)s;
  return 0;
 1ee:	31 c0                	xor    %eax,%eax
}
 1f0:	5b                   	pop    %ebx
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	31 f6                	xor    %esi,%esi
 208:	89 f3                	mov    %esi,%ebx
{
 20a:	83 ec 1c             	sub    $0x1c,%esp
 20d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 210:	eb 2f                	jmp    241 <gets+0x41>
 212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 218:	8d 45 e7             	lea    -0x19(%ebp),%eax
 21b:	83 ec 04             	sub    $0x4,%esp
 21e:	6a 01                	push   $0x1
 220:	50                   	push   %eax
 221:	6a 00                	push   $0x0
 223:	e8 32 01 00 00       	call   35a <read>
    if(cc < 1)
 228:	83 c4 10             	add    $0x10,%esp
 22b:	85 c0                	test   %eax,%eax
 22d:	7e 1c                	jle    24b <gets+0x4b>
      break;
    buf[i++] = c;
 22f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 233:	83 c7 01             	add    $0x1,%edi
 236:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 239:	3c 0a                	cmp    $0xa,%al
 23b:	74 23                	je     260 <gets+0x60>
 23d:	3c 0d                	cmp    $0xd,%al
 23f:	74 1f                	je     260 <gets+0x60>
  for(i=0; i+1 < max; ){
 241:	83 c3 01             	add    $0x1,%ebx
 244:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 247:	89 fe                	mov    %edi,%esi
 249:	7c cd                	jl     218 <gets+0x18>
 24b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 250:	c6 03 00             	movb   $0x0,(%ebx)
}
 253:	8d 65 f4             	lea    -0xc(%ebp),%esp
 256:	5b                   	pop    %ebx
 257:	5e                   	pop    %esi
 258:	5f                   	pop    %edi
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret    
 25b:	90                   	nop
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 260:	8b 75 08             	mov    0x8(%ebp),%esi
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	01 de                	add    %ebx,%esi
 268:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 26a:	c6 03 00             	movb   $0x0,(%ebx)
}
 26d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5f                   	pop    %edi
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    
 275:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <stat>:

int
stat(const char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	6a 00                	push   $0x0
 28a:	ff 75 08             	pushl  0x8(%ebp)
 28d:	e8 f0 00 00 00       	call   382 <open>
  if(fd < 0)
 292:	83 c4 10             	add    $0x10,%esp
 295:	85 c0                	test   %eax,%eax
 297:	78 27                	js     2c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	ff 75 0c             	pushl  0xc(%ebp)
 29f:	89 c3                	mov    %eax,%ebx
 2a1:	50                   	push   %eax
 2a2:	e8 f3 00 00 00       	call   39a <fstat>
  close(fd);
 2a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2aa:	89 c6                	mov    %eax,%esi
  close(fd);
 2ac:	e8 b9 00 00 00       	call   36a <close>
  return r;
 2b1:	83 c4 10             	add    $0x10,%esp
}
 2b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b7:	89 f0                	mov    %esi,%eax
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2c5:	eb ed                	jmp    2b4 <stat+0x34>
 2c7:	89 f6                	mov    %esi,%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d7:	0f be 11             	movsbl (%ecx),%edx
 2da:	8d 42 d0             	lea    -0x30(%edx),%eax
 2dd:	3c 09                	cmp    $0x9,%al
  n = 0;
 2df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2e4:	77 1f                	ja     305 <atoi+0x35>
 2e6:	8d 76 00             	lea    0x0(%esi),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2f3:	83 c1 01             	add    $0x1,%ecx
 2f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2fa:	0f be 11             	movsbl (%ecx),%edx
 2fd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 300:	80 fb 09             	cmp    $0x9,%bl
 303:	76 eb                	jbe    2f0 <atoi+0x20>
  return n;
}
 305:	5b                   	pop    %ebx
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    
 308:	90                   	nop
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000310 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
 315:	8b 5d 10             	mov    0x10(%ebp),%ebx
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31e:	85 db                	test   %ebx,%ebx
 320:	7e 14                	jle    336 <memmove+0x26>
 322:	31 d2                	xor    %edx,%edx
 324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 328:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 32c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 32f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 332:	39 d3                	cmp    %edx,%ebx
 334:	75 f2                	jne    328 <memmove+0x18>
  return vdst;
}
 336:	5b                   	pop    %ebx
 337:	5e                   	pop    %esi
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    

0000033a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33a:	b8 01 00 00 00       	mov    $0x1,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <exit>:
SYSCALL(exit)
 342:	b8 02 00 00 00       	mov    $0x2,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <wait>:
SYSCALL(wait)
 34a:	b8 03 00 00 00       	mov    $0x3,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <pipe>:
SYSCALL(pipe)
 352:	b8 04 00 00 00       	mov    $0x4,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <read>:
SYSCALL(read)
 35a:	b8 05 00 00 00       	mov    $0x5,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <write>:
SYSCALL(write)
 362:	b8 10 00 00 00       	mov    $0x10,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <close>:
SYSCALL(close)
 36a:	b8 15 00 00 00       	mov    $0x15,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <kill>:
SYSCALL(kill)
 372:	b8 06 00 00 00       	mov    $0x6,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <exec>:
SYSCALL(exec)
 37a:	b8 07 00 00 00       	mov    $0x7,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <open>:
SYSCALL(open)
 382:	b8 0f 00 00 00       	mov    $0xf,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <mknod>:
SYSCALL(mknod)
 38a:	b8 11 00 00 00       	mov    $0x11,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <unlink>:
SYSCALL(unlink)
 392:	b8 12 00 00 00       	mov    $0x12,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <fstat>:
SYSCALL(fstat)
 39a:	b8 08 00 00 00       	mov    $0x8,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <link>:
SYSCALL(link)
 3a2:	b8 13 00 00 00       	mov    $0x13,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <mkdir>:
SYSCALL(mkdir)
 3aa:	b8 14 00 00 00       	mov    $0x14,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <chdir>:
SYSCALL(chdir)
 3b2:	b8 09 00 00 00       	mov    $0x9,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <dup>:
SYSCALL(dup)
 3ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <getpid>:
SYSCALL(getpid)
 3c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <sbrk>:
SYSCALL(sbrk)
 3ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <sleep>:
SYSCALL(sleep)
 3d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <uptime>:
SYSCALL(uptime)
 3da:	b8 0e 00 00 00       	mov    $0xe,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <kthread_create>:
//kthread
SYSCALL(kthread_create)
 3e2:	b8 16 00 00 00       	mov    $0x16,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <kthread_id>:
SYSCALL(kthread_id)
 3ea:	b8 17 00 00 00       	mov    $0x17,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <kthread_exit>:
SYSCALL(kthread_exit)
 3f2:	b8 18 00 00 00       	mov    $0x18,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <kthread_join>:
SYSCALL(kthread_join)
 3fa:	b8 19 00 00 00       	mov    $0x19,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <kthread_mutex_alloc>:

//kthread_mutex
SYSCALL(kthread_mutex_alloc)
 402:	b8 1a 00 00 00       	mov    $0x1a,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
 40a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
 412:	b8 1c 00 00 00       	mov    $0x1c,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
 41a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <safe_tree_dealloc>:
SYSCALL(safe_tree_dealloc)
 422:	b8 1e 00 00 00       	mov    $0x1e,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    
 42a:	66 90                	xchg   %ax,%ax
 42c:	66 90                	xchg   %ax,%ax
 42e:	66 90                	xchg   %ax,%ax

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 439:	85 d2                	test   %edx,%edx
{
 43b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 43e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 440:	79 76                	jns    4b8 <printint+0x88>
 442:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 446:	74 70                	je     4b8 <printint+0x88>
    x = -xx;
 448:	f7 d8                	neg    %eax
    neg = 1;
 44a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 451:	31 f6                	xor    %esi,%esi
 453:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 456:	eb 0a                	jmp    462 <printint+0x32>
 458:	90                   	nop
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 460:	89 fe                	mov    %edi,%esi
 462:	31 d2                	xor    %edx,%edx
 464:	8d 7e 01             	lea    0x1(%esi),%edi
 467:	f7 f1                	div    %ecx
 469:	0f b6 92 1c 0b 00 00 	movzbl 0xb1c(%edx),%edx
  }while((x /= base) != 0);
 470:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 472:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 475:	75 e9                	jne    460 <printint+0x30>
  if(neg)
 477:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 47a:	85 c0                	test   %eax,%eax
 47c:	74 08                	je     486 <printint+0x56>
    buf[i++] = '-';
 47e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 483:	8d 7e 02             	lea    0x2(%esi),%edi
 486:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 48a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 48d:	8d 76 00             	lea    0x0(%esi),%esi
 490:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 493:	83 ec 04             	sub    $0x4,%esp
 496:	83 ee 01             	sub    $0x1,%esi
 499:	6a 01                	push   $0x1
 49b:	53                   	push   %ebx
 49c:	57                   	push   %edi
 49d:	88 45 d7             	mov    %al,-0x29(%ebp)
 4a0:	e8 bd fe ff ff       	call   362 <write>

  while(--i >= 0)
 4a5:	83 c4 10             	add    $0x10,%esp
 4a8:	39 de                	cmp    %ebx,%esi
 4aa:	75 e4                	jne    490 <printint+0x60>
    putc(fd, buf[i]);
}
 4ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4af:	5b                   	pop    %ebx
 4b0:	5e                   	pop    %esi
 4b1:	5f                   	pop    %edi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4b8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4bf:	eb 90                	jmp    451 <printint+0x21>
 4c1:	eb 0d                	jmp    4d0 <printf>
 4c3:	90                   	nop
 4c4:	90                   	nop
 4c5:	90                   	nop
 4c6:	90                   	nop
 4c7:	90                   	nop
 4c8:	90                   	nop
 4c9:	90                   	nop
 4ca:	90                   	nop
 4cb:	90                   	nop
 4cc:	90                   	nop
 4cd:	90                   	nop
 4ce:	90                   	nop
 4cf:	90                   	nop

000004d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d9:	8b 75 0c             	mov    0xc(%ebp),%esi
 4dc:	0f b6 1e             	movzbl (%esi),%ebx
 4df:	84 db                	test   %bl,%bl
 4e1:	0f 84 b3 00 00 00    	je     59a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 4e7:	8d 45 10             	lea    0x10(%ebp),%eax
 4ea:	83 c6 01             	add    $0x1,%esi
  state = 0;
 4ed:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 4ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4f2:	eb 2f                	jmp    523 <printf+0x53>
 4f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4f8:	83 f8 25             	cmp    $0x25,%eax
 4fb:	0f 84 a7 00 00 00    	je     5a8 <printf+0xd8>
  write(fd, &c, 1);
 501:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 504:	83 ec 04             	sub    $0x4,%esp
 507:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 50a:	6a 01                	push   $0x1
 50c:	50                   	push   %eax
 50d:	ff 75 08             	pushl  0x8(%ebp)
 510:	e8 4d fe ff ff       	call   362 <write>
 515:	83 c4 10             	add    $0x10,%esp
 518:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 51b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 51f:	84 db                	test   %bl,%bl
 521:	74 77                	je     59a <printf+0xca>
    if(state == 0){
 523:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 525:	0f be cb             	movsbl %bl,%ecx
 528:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 52b:	74 cb                	je     4f8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 52d:	83 ff 25             	cmp    $0x25,%edi
 530:	75 e6                	jne    518 <printf+0x48>
      if(c == 'd'){
 532:	83 f8 64             	cmp    $0x64,%eax
 535:	0f 84 05 01 00 00    	je     640 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 53b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 541:	83 f9 70             	cmp    $0x70,%ecx
 544:	74 72                	je     5b8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 546:	83 f8 73             	cmp    $0x73,%eax
 549:	0f 84 99 00 00 00    	je     5e8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54f:	83 f8 63             	cmp    $0x63,%eax
 552:	0f 84 08 01 00 00    	je     660 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 558:	83 f8 25             	cmp    $0x25,%eax
 55b:	0f 84 ef 00 00 00    	je     650 <printf+0x180>
  write(fd, &c, 1);
 561:	8d 45 e7             	lea    -0x19(%ebp),%eax
 564:	83 ec 04             	sub    $0x4,%esp
 567:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 56b:	6a 01                	push   $0x1
 56d:	50                   	push   %eax
 56e:	ff 75 08             	pushl  0x8(%ebp)
 571:	e8 ec fd ff ff       	call   362 <write>
 576:	83 c4 0c             	add    $0xc,%esp
 579:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 57c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 57f:	6a 01                	push   $0x1
 581:	50                   	push   %eax
 582:	ff 75 08             	pushl  0x8(%ebp)
 585:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 588:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 58a:	e8 d3 fd ff ff       	call   362 <write>
  for(i = 0; fmt[i]; i++){
 58f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 593:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 596:	84 db                	test   %bl,%bl
 598:	75 89                	jne    523 <printf+0x53>
    }
  }
}
 59a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59d:	5b                   	pop    %ebx
 59e:	5e                   	pop    %esi
 59f:	5f                   	pop    %edi
 5a0:	5d                   	pop    %ebp
 5a1:	c3                   	ret    
 5a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 5a8:	bf 25 00 00 00       	mov    $0x25,%edi
 5ad:	e9 66 ff ff ff       	jmp    518 <printf+0x48>
 5b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5b8:	83 ec 0c             	sub    $0xc,%esp
 5bb:	b9 10 00 00 00       	mov    $0x10,%ecx
 5c0:	6a 00                	push   $0x0
 5c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	8b 17                	mov    (%edi),%edx
 5ca:	e8 61 fe ff ff       	call   430 <printint>
        ap++;
 5cf:	89 f8                	mov    %edi,%eax
 5d1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5d4:	31 ff                	xor    %edi,%edi
        ap++;
 5d6:	83 c0 04             	add    $0x4,%eax
 5d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5dc:	e9 37 ff ff ff       	jmp    518 <printf+0x48>
 5e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5eb:	8b 08                	mov    (%eax),%ecx
        ap++;
 5ed:	83 c0 04             	add    $0x4,%eax
 5f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 5f3:	85 c9                	test   %ecx,%ecx
 5f5:	0f 84 8e 00 00 00    	je     689 <printf+0x1b9>
        while(*s != 0){
 5fb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 5fe:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 600:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 602:	84 c0                	test   %al,%al
 604:	0f 84 0e ff ff ff    	je     518 <printf+0x48>
 60a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 60d:	89 de                	mov    %ebx,%esi
 60f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 612:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 615:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 618:	83 ec 04             	sub    $0x4,%esp
          s++;
 61b:	83 c6 01             	add    $0x1,%esi
 61e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 621:	6a 01                	push   $0x1
 623:	57                   	push   %edi
 624:	53                   	push   %ebx
 625:	e8 38 fd ff ff       	call   362 <write>
        while(*s != 0){
 62a:	0f b6 06             	movzbl (%esi),%eax
 62d:	83 c4 10             	add    $0x10,%esp
 630:	84 c0                	test   %al,%al
 632:	75 e4                	jne    618 <printf+0x148>
 634:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 637:	31 ff                	xor    %edi,%edi
 639:	e9 da fe ff ff       	jmp    518 <printf+0x48>
 63e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	b9 0a 00 00 00       	mov    $0xa,%ecx
 648:	6a 01                	push   $0x1
 64a:	e9 73 ff ff ff       	jmp    5c2 <printf+0xf2>
 64f:	90                   	nop
  write(fd, &c, 1);
 650:	83 ec 04             	sub    $0x4,%esp
 653:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 656:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 659:	6a 01                	push   $0x1
 65b:	e9 21 ff ff ff       	jmp    581 <printf+0xb1>
        putc(fd, *ap);
 660:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 663:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 666:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 668:	6a 01                	push   $0x1
        ap++;
 66a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 66d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 670:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 673:	50                   	push   %eax
 674:	ff 75 08             	pushl  0x8(%ebp)
 677:	e8 e6 fc ff ff       	call   362 <write>
        ap++;
 67c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 67f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 682:	31 ff                	xor    %edi,%edi
 684:	e9 8f fe ff ff       	jmp    518 <printf+0x48>
          s = "(null)";
 689:	bb 14 0b 00 00       	mov    $0xb14,%ebx
        while(*s != 0){
 68e:	b8 28 00 00 00       	mov    $0x28,%eax
 693:	e9 72 ff ff ff       	jmp    60a <printf+0x13a>
 698:	66 90                	xchg   %ax,%ax
 69a:	66 90                	xchg   %ax,%ax
 69c:	66 90                	xchg   %ax,%ax
 69e:	66 90                	xchg   %ax,%ax

000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	a1 00 0f 00 00       	mov    0xf00,%eax
{
 6a6:	89 e5                	mov    %esp,%ebp
 6a8:	57                   	push   %edi
 6a9:	56                   	push   %esi
 6aa:	53                   	push   %ebx
 6ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 6b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b8:	39 c8                	cmp    %ecx,%eax
 6ba:	8b 10                	mov    (%eax),%edx
 6bc:	73 32                	jae    6f0 <free+0x50>
 6be:	39 d1                	cmp    %edx,%ecx
 6c0:	72 04                	jb     6c6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c2:	39 d0                	cmp    %edx,%eax
 6c4:	72 32                	jb     6f8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6cc:	39 fa                	cmp    %edi,%edx
 6ce:	74 30                	je     700 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6d0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6d3:	8b 50 04             	mov    0x4(%eax),%edx
 6d6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6d9:	39 f1                	cmp    %esi,%ecx
 6db:	74 3a                	je     717 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6dd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6df:	a3 00 0f 00 00       	mov    %eax,0xf00
}
 6e4:	5b                   	pop    %ebx
 6e5:	5e                   	pop    %esi
 6e6:	5f                   	pop    %edi
 6e7:	5d                   	pop    %ebp
 6e8:	c3                   	ret    
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	39 d0                	cmp    %edx,%eax
 6f2:	72 04                	jb     6f8 <free+0x58>
 6f4:	39 d1                	cmp    %edx,%ecx
 6f6:	72 ce                	jb     6c6 <free+0x26>
{
 6f8:	89 d0                	mov    %edx,%eax
 6fa:	eb bc                	jmp    6b8 <free+0x18>
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 700:	03 72 04             	add    0x4(%edx),%esi
 703:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 706:	8b 10                	mov    (%eax),%edx
 708:	8b 12                	mov    (%edx),%edx
 70a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 713:	39 f1                	cmp    %esi,%ecx
 715:	75 c6                	jne    6dd <free+0x3d>
    p->s.size += bp->s.size;
 717:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 71a:	a3 00 0f 00 00       	mov    %eax,0xf00
    p->s.size += bp->s.size;
 71f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 722:	8b 53 f8             	mov    -0x8(%ebx),%edx
 725:	89 10                	mov    %edx,(%eax)
}
 727:	5b                   	pop    %ebx
 728:	5e                   	pop    %esi
 729:	5f                   	pop    %edi
 72a:	5d                   	pop    %ebp
 72b:	c3                   	ret    
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 73c:	8b 15 00 0f 00 00    	mov    0xf00,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 742:	8d 78 07             	lea    0x7(%eax),%edi
 745:	c1 ef 03             	shr    $0x3,%edi
 748:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 74b:	85 d2                	test   %edx,%edx
 74d:	0f 84 9d 00 00 00    	je     7f0 <malloc+0xc0>
 753:	8b 02                	mov    (%edx),%eax
 755:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 758:	39 cf                	cmp    %ecx,%edi
 75a:	76 6c                	jbe    7c8 <malloc+0x98>
 75c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 762:	bb 00 10 00 00       	mov    $0x1000,%ebx
 767:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 76a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 771:	eb 0e                	jmp    781 <malloc+0x51>
 773:	90                   	nop
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 778:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 77a:	8b 48 04             	mov    0x4(%eax),%ecx
 77d:	39 f9                	cmp    %edi,%ecx
 77f:	73 47                	jae    7c8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 781:	39 05 00 0f 00 00    	cmp    %eax,0xf00
 787:	89 c2                	mov    %eax,%edx
 789:	75 ed                	jne    778 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 78b:	83 ec 0c             	sub    $0xc,%esp
 78e:	56                   	push   %esi
 78f:	e8 36 fc ff ff       	call   3ca <sbrk>
  if(p == (char*)-1)
 794:	83 c4 10             	add    $0x10,%esp
 797:	83 f8 ff             	cmp    $0xffffffff,%eax
 79a:	74 1c                	je     7b8 <malloc+0x88>
  hp->s.size = nu;
 79c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 79f:	83 ec 0c             	sub    $0xc,%esp
 7a2:	83 c0 08             	add    $0x8,%eax
 7a5:	50                   	push   %eax
 7a6:	e8 f5 fe ff ff       	call   6a0 <free>
  return freep;
 7ab:	8b 15 00 0f 00 00    	mov    0xf00,%edx
      if((p = morecore(nunits)) == 0)
 7b1:	83 c4 10             	add    $0x10,%esp
 7b4:	85 d2                	test   %edx,%edx
 7b6:	75 c0                	jne    778 <malloc+0x48>
        return 0;
  }
}
 7b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7bb:	31 c0                	xor    %eax,%eax
}
 7bd:	5b                   	pop    %ebx
 7be:	5e                   	pop    %esi
 7bf:	5f                   	pop    %edi
 7c0:	5d                   	pop    %ebp
 7c1:	c3                   	ret    
 7c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7c8:	39 cf                	cmp    %ecx,%edi
 7ca:	74 54                	je     820 <malloc+0xf0>
        p->s.size -= nunits;
 7cc:	29 f9                	sub    %edi,%ecx
 7ce:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7d1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7d4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7d7:	89 15 00 0f 00 00    	mov    %edx,0xf00
}
 7dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7e0:	83 c0 08             	add    $0x8,%eax
}
 7e3:	5b                   	pop    %ebx
 7e4:	5e                   	pop    %esi
 7e5:	5f                   	pop    %edi
 7e6:	5d                   	pop    %ebp
 7e7:	c3                   	ret    
 7e8:	90                   	nop
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 7f0:	c7 05 00 0f 00 00 04 	movl   $0xf04,0xf00
 7f7:	0f 00 00 
 7fa:	c7 05 04 0f 00 00 04 	movl   $0xf04,0xf04
 801:	0f 00 00 
    base.s.size = 0;
 804:	b8 04 0f 00 00       	mov    $0xf04,%eax
 809:	c7 05 08 0f 00 00 00 	movl   $0x0,0xf08
 810:	00 00 00 
 813:	e9 44 ff ff ff       	jmp    75c <malloc+0x2c>
 818:	90                   	nop
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 820:	8b 08                	mov    (%eax),%ecx
 822:	89 0a                	mov    %ecx,(%edx)
 824:	eb b1                	jmp    7d7 <malloc+0xa7>
 826:	66 90                	xchg   %ax,%ax
 828:	66 90                	xchg   %ax,%ax
 82a:	66 90                	xchg   %ax,%ax
 82c:	66 90                	xchg   %ax,%ax
 82e:	66 90                	xchg   %ax,%ax

00000830 <ourpower.part.0>:
struct {
    //struct spinlock lock;
    trnmnt_tree trnmnt_tree[NPROC];
} treetable;

int ourpower(int num) {
 830:	55                   	push   %ebp
    if (num < 0) {
        //cprintf("Illegal input: for a^b: a= %d, b= %d \n", a, b);
        return -1;
    }
    int output = 1;
    for (int i = 0; i < num; i++)
 831:	85 c0                	test   %eax,%eax
int ourpower(int num) {
 833:	89 e5                	mov    %esp,%ebp
    for (int i = 0; i < num; i++)
 835:	7e 19                	jle    850 <ourpower.part.0+0x20>
 837:	31 d2                	xor    %edx,%edx
    int output = 1;
 839:	b9 01 00 00 00       	mov    $0x1,%ecx
 83e:	66 90                	xchg   %ax,%ax
    for (int i = 0; i < num; i++)
 840:	83 c2 01             	add    $0x1,%edx
        output *= 2;
 843:	01 c9                	add    %ecx,%ecx
    for (int i = 0; i < num; i++)
 845:	39 c2                	cmp    %eax,%edx
 847:	75 f7                	jne    840 <ourpower.part.0+0x10>
    return output;
}
 849:	89 c8                	mov    %ecx,%eax
 84b:	5d                   	pop    %ebp
 84c:	c3                   	ret    
 84d:	8d 76 00             	lea    0x0(%esi),%esi
    int output = 1;
 850:	b9 01 00 00 00       	mov    $0x1,%ecx
}
 855:	89 c8                	mov    %ecx,%eax
 857:	5d                   	pop    %ebp
 858:	c3                   	ret    
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000860 <ourpower>:
int ourpower(int num) {
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	8b 45 08             	mov    0x8(%ebp),%eax
    if (num < 0) {
 866:	85 c0                	test   %eax,%eax
 868:	78 03                	js     86d <ourpower+0xd>
}
 86a:	5d                   	pop    %ebp
 86b:	eb c3                	jmp    830 <ourpower.part.0>
 86d:	83 c8 ff             	or     $0xffffffff,%eax
 870:	5d                   	pop    %ebp
 871:	c3                   	ret    
 872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000880 <trnmnt_tree_alloc>:

struct trnmnt_tree*
trnmnt_tree_alloc(int depth){
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	57                   	push   %edi
 884:	56                   	push   %esi
 885:	53                   	push   %ebx
    trnmnt_tree *t;

    for (t = treetable.trnmnt_tree ; t < &treetable.trnmnt_tree[NPROC] ; t++) {
 886:	bb 20 0f 00 00       	mov    $0xf20,%ebx
trnmnt_tree_alloc(int depth){
 88b:	83 ec 0c             	sub    $0xc,%esp
 88e:	8b 45 08             	mov    0x8(%ebp),%eax
 891:	eb 13                	jmp    8a6 <trnmnt_tree_alloc+0x26>
 893:	90                   	nop
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (t = treetable.trnmnt_tree ; t < &treetable.trnmnt_tree[NPROC] ; t++) {
 898:	81 c3 08 01 00 00    	add    $0x108,%ebx
 89e:	81 fb 20 51 00 00    	cmp    $0x5120,%ebx
 8a4:	73 42                	jae    8e8 <trnmnt_tree_alloc+0x68>
        if (t->active == INACTIVE)
 8a6:	8b 13                	mov    (%ebx),%edx
 8a8:	85 d2                	test   %edx,%edx
 8aa:	75 ec                	jne    898 <trnmnt_tree_alloc+0x18>
    if (num < 0) {
 8ac:	85 c0                	test   %eax,%eax
            goto found_tree;
    }
    return 0;

    found_tree:
    t->active = ACTIVE;
 8ae:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    t->depth = depth;
 8b4:	89 43 04             	mov    %eax,0x4(%ebx)
    if (num < 0) {
 8b7:	78 1f                	js     8d8 <trnmnt_tree_alloc+0x58>
 8b9:	e8 72 ff ff ff       	call   830 <ourpower.part.0>

    for(int i=0; i<(ourpower(depth)-1); i++)
 8be:	31 f6                	xor    %esi,%esi
 8c0:	8d 78 ff             	lea    -0x1(%eax),%edi
 8c3:	eb 0f                	jmp    8d4 <trnmnt_tree_alloc+0x54>
 8c5:	8d 76 00             	lea    0x0(%esi),%esi
        t->trnmntMutex[i] = kthread_mutex_alloc();
 8c8:	e8 35 fb ff ff       	call   402 <kthread_mutex_alloc>
 8cd:	89 44 b3 08          	mov    %eax,0x8(%ebx,%esi,4)
    for(int i=0; i<(ourpower(depth)-1); i++)
 8d1:	83 c6 01             	add    $0x1,%esi
 8d4:	39 f7                	cmp    %esi,%edi
 8d6:	7f f0                	jg     8c8 <trnmnt_tree_alloc+0x48>

    return t;
}
 8d8:	83 c4 0c             	add    $0xc,%esp
 8db:	89 d8                	mov    %ebx,%eax
 8dd:	5b                   	pop    %ebx
 8de:	5e                   	pop    %esi
 8df:	5f                   	pop    %edi
 8e0:	5d                   	pop    %ebp
 8e1:	c3                   	ret    
 8e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8e8:	83 c4 0c             	add    $0xc,%esp
    return 0;
 8eb:	31 db                	xor    %ebx,%ebx
}
 8ed:	89 d8                	mov    %ebx,%eax
 8ef:	5b                   	pop    %ebx
 8f0:	5e                   	pop    %esi
 8f1:	5f                   	pop    %edi
 8f2:	5d                   	pop    %ebp
 8f3:	c3                   	ret    
 8f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000900 <trnmnt_tree_dealloc>:

int
trnmnt_tree_dealloc(trnmnt_tree* tree){
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	57                   	push   %edi
 904:	56                   	push   %esi
 905:	53                   	push   %ebx
 906:	83 ec 0c             	sub    $0xc,%esp
 909:	8b 75 08             	mov    0x8(%ebp),%esi
    if(tree->active == INACTIVE )
 90c:	8b 06                	mov    (%esi),%eax
 90e:	85 c0                	test   %eax,%eax
 910:	74 56                	je     968 <trnmnt_tree_dealloc+0x68>
        return -1;



    for(int j=0; j<(ourpower(tree->depth)-1); j++){
 912:	31 ff                	xor    %edi,%edi
 914:	eb 2e                	jmp    944 <trnmnt_tree_dealloc+0x44>
 916:	8d 76 00             	lea    0x0(%esi),%esi
 919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 920:	89 d8                	mov    %ebx,%eax
 922:	e8 09 ff ff ff       	call   830 <ourpower.part.0>
 927:	83 e8 01             	sub    $0x1,%eax
 92a:	39 c7                	cmp    %eax,%edi
 92c:	7d 47                	jge    975 <trnmnt_tree_dealloc+0x75>
        if(safe_tree_dealloc(tree->trnmntMutex[j]) == 0 )
 92e:	83 ec 0c             	sub    $0xc,%esp
 931:	ff 74 be 08          	pushl  0x8(%esi,%edi,4)
 935:	e8 e8 fa ff ff       	call   422 <safe_tree_dealloc>
 93a:	83 c4 10             	add    $0x10,%esp
 93d:	85 c0                	test   %eax,%eax
 93f:	74 27                	je     968 <trnmnt_tree_dealloc+0x68>
    for(int j=0; j<(ourpower(tree->depth)-1); j++){
 941:	83 c7 01             	add    $0x1,%edi
 944:	8b 5e 04             	mov    0x4(%esi),%ebx
    if (num < 0) {
 947:	85 db                	test   %ebx,%ebx
 949:	79 d5                	jns    920 <trnmnt_tree_dealloc+0x20>
            //printf(1," WERE ARE FUCKED %d  \n" , i);
            return -1;
        }
    }

    tree->depth=0;
 94b:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    tree->active = INACTIVE;
 952:	c7 06 00 00 00 00    	movl   $0x0,(%esi)

    return 0;
}
 958:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
 95b:	31 c0                	xor    %eax,%eax
}
 95d:	5b                   	pop    %ebx
 95e:	5e                   	pop    %esi
 95f:	5f                   	pop    %edi
 960:	5d                   	pop    %ebp
 961:	c3                   	ret    
 962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 968:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
 96b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 970:	5b                   	pop    %ebx
 971:	5e                   	pop    %esi
 972:	5f                   	pop    %edi
 973:	5d                   	pop    %ebp
 974:	c3                   	ret    
    for(int i=0; i<(ourpower(tree->depth)-1); i++){
 975:	31 ff                	xor    %edi,%edi
 977:	89 f6                	mov    %esi,%esi
 979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 980:	89 d8                	mov    %ebx,%eax
 982:	e8 a9 fe ff ff       	call   830 <ourpower.part.0>
 987:	83 e8 01             	sub    $0x1,%eax
 98a:	39 f8                	cmp    %edi,%eax
 98c:	7e bd                	jle    94b <trnmnt_tree_dealloc+0x4b>
        if(kthread_mutex_dealloc(tree->trnmntMutex[i]) == -1 ){
 98e:	83 ec 0c             	sub    $0xc,%esp
 991:	ff 74 be 08          	pushl  0x8(%esi,%edi,4)
 995:	e8 70 fa ff ff       	call   40a <kthread_mutex_dealloc>
 99a:	83 c4 10             	add    $0x10,%esp
 99d:	83 f8 ff             	cmp    $0xffffffff,%eax
 9a0:	74 c6                	je     968 <trnmnt_tree_dealloc+0x68>
    for(int i=0; i<(ourpower(tree->depth)-1); i++){
 9a2:	8b 5e 04             	mov    0x4(%esi),%ebx
 9a5:	83 c7 01             	add    $0x1,%edi
    if (num < 0) {
 9a8:	85 db                	test   %ebx,%ebx
 9aa:	79 d4                	jns    980 <trnmnt_tree_dealloc+0x80>
 9ac:	eb 9d                	jmp    94b <trnmnt_tree_dealloc+0x4b>
 9ae:	66 90                	xchg   %ax,%ax

000009b0 <trnmnt_tree_acquire>:

int
trnmnt_tree_acquire(trnmnt_tree* tree,int ID){
 9b0:	55                   	push   %ebp
 9b1:	89 e5                	mov    %esp,%ebp
 9b3:	57                   	push   %edi
 9b4:	56                   	push   %esi
 9b5:	53                   	push   %ebx
 9b6:	83 ec 1c             	sub    $0x1c,%esp
 9b9:	8b 75 08             	mov    0x8(%ebp),%esi
 9bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    int x=0, localID=ID;
    for(int lvl=1; lvl<=tree->depth; lvl++){
 9bf:	8b 46 04             	mov    0x4(%esi),%eax
 9c2:	85 c0                	test   %eax,%eax
 9c4:	7e 62                	jle    a28 <trnmnt_tree_acquire+0x78>
 9c6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    int x=0, localID=ID;
 9cd:	31 ff                	xor    %edi,%edi
 9cf:	90                   	nop
        localID= localID/2;     //wich lock try to lock in current level
 9d0:	89 d8                	mov    %ebx,%eax
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
 9d2:	83 ec 0c             	sub    $0xc,%esp
        localID= localID/2;     //wich lock try to lock in current level
 9d5:	c1 e8 1f             	shr    $0x1f,%eax
 9d8:	01 c3                	add    %eax,%ebx
 9da:	d1 fb                	sar    %ebx
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
 9dc:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
 9df:	ff 74 86 08          	pushl  0x8(%esi,%eax,4)
 9e3:	e8 2a fa ff ff       	call   412 <kthread_mutex_lock>
 9e8:	83 c4 10             	add    $0x10,%esp
 9eb:	83 f8 ff             	cmp    $0xffffffff,%eax
 9ee:	74 3a                	je     a2a <trnmnt_tree_acquire+0x7a>
            return -1; //lock ->if not succeed sleep (in mutex implementation)
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 9f0:	8b 4e 04             	mov    0x4(%esi),%ecx
    if (num < 0) {
 9f3:	85 c9                	test   %ecx,%ecx
 9f5:	78 31                	js     a28 <trnmnt_tree_acquire+0x78>
 9f7:	89 c8                	mov    %ecx,%eax
 9f9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
 9fc:	e8 2f fe ff ff       	call   830 <ourpower.part.0>
 a01:	89 45 e0             	mov    %eax,-0x20(%ebp)
 a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a07:	e8 24 fe ff ff       	call   830 <ourpower.part.0>
 a0c:	89 c1                	mov    %eax,%ecx
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
    for(int lvl=1; lvl<=tree->depth; lvl++){
 a11:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 a15:	99                   	cltd   
 a16:	f7 f9                	idiv   %ecx
    for(int lvl=1; lvl<=tree->depth; lvl++){
 a18:	8b 4d dc             	mov    -0x24(%ebp),%ecx
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 a1b:	01 c7                	add    %eax,%edi
    for(int lvl=1; lvl<=tree->depth; lvl++){
 a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a20:	39 c1                	cmp    %eax,%ecx
 a22:	7d ac                	jge    9d0 <trnmnt_tree_acquire+0x20>
 a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    return 0;
 a28:	31 c0                	xor    %eax,%eax
}
 a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a2d:	5b                   	pop    %ebx
 a2e:	5e                   	pop    %esi
 a2f:	5f                   	pop    %edi
 a30:	5d                   	pop    %ebp
 a31:	c3                   	ret    
 a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a40 <trnmnt_tree_release>:

int
trnmnt_tree_release(trnmnt_tree* tree,int ID){
 a40:	55                   	push   %ebp
 a41:	89 e5                	mov    %esp,%ebp
 a43:	57                   	push   %edi
 a44:	56                   	push   %esi
 a45:	53                   	push   %ebx
 a46:	83 ec 0c             	sub    $0xc,%esp
 a49:	8b 7d 08             	mov    0x8(%ebp),%edi
    int x=ourpower(tree->depth)-2, localID;
 a4c:	8b 5f 04             	mov    0x4(%edi),%ebx
    if (num < 0) {
 a4f:	85 db                	test   %ebx,%ebx
 a51:	78 65                	js     ab8 <trnmnt_tree_release+0x78>
 a53:	89 d8                	mov    %ebx,%eax
 a55:	e8 d6 fd ff ff       	call   830 <ourpower.part.0>
    for(int lvl=tree->depth; lvl>=1; lvl--){
 a5a:	85 db                	test   %ebx,%ebx
 a5c:	8d 70 fe             	lea    -0x2(%eax),%esi
 a5f:	7f 24                	jg     a85 <trnmnt_tree_release+0x45>
 a61:	eb 55                	jmp    ab8 <trnmnt_tree_release+0x78>
 a63:	90                   	nop
 a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //unlock ->if not curthead holds this lock -> return -1 (in mutex implementation)
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 a68:	8b 57 04             	mov    0x4(%edi),%edx
        return -1;
 a6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 a70:	29 da                	sub    %ebx,%edx
    if (num < 0) {
 a72:	83 c2 01             	add    $0x1,%edx
 a75:	78 07                	js     a7e <trnmnt_tree_release+0x3e>
 a77:	89 d0                	mov    %edx,%eax
 a79:	e8 b2 fd ff ff       	call   830 <ourpower.part.0>
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 a7e:	29 c6                	sub    %eax,%esi
    for(int lvl=tree->depth; lvl>=1; lvl--){
 a80:	83 eb 01             	sub    $0x1,%ebx
 a83:	74 33                	je     ab8 <trnmnt_tree_release+0x78>
 a85:	89 d8                	mov    %ebx,%eax
 a87:	e8 a4 fd ff ff       	call   830 <ourpower.part.0>
 a8c:	89 c1                	mov    %eax,%ecx
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
 a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
 a91:	83 ec 0c             	sub    $0xc,%esp
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
 a94:	99                   	cltd   
 a95:	f7 f9                	idiv   %ecx
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
 a97:	01 f0                	add    %esi,%eax
 a99:	ff 74 87 08          	pushl  0x8(%edi,%eax,4)
 a9d:	e8 78 f9 ff ff       	call   41a <kthread_mutex_unlock>
 aa2:	83 c4 10             	add    $0x10,%esp
 aa5:	83 f8 ff             	cmp    $0xffffffff,%eax
 aa8:	75 be                	jne    a68 <trnmnt_tree_release+0x28>
    }
    return 0;
}
 aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 aad:	5b                   	pop    %ebx
 aae:	5e                   	pop    %esi
 aaf:	5f                   	pop    %edi
 ab0:	5d                   	pop    %ebp
 ab1:	c3                   	ret    
 ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
 abb:	31 c0                	xor    %eax,%eax
}
 abd:	5b                   	pop    %ebx
 abe:	5e                   	pop    %esi
 abf:	5f                   	pop    %edi
 ac0:	5d                   	pop    %ebp
 ac1:	c3                   	ret    
