
_sanity:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
            printf(2, "ERROR- wrong test_ID %d \n", testNum);
            return;
    }
}

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 10             	sub    $0x10,%esp
    run_test(21);
  11:	6a 15                	push   $0x15
  13:	e8 38 01 00 00       	call   150 <run_test>
    run_test(22);
  18:	c7 04 24 16 00 00 00 	movl   $0x16,(%esp)
  1f:	e8 2c 01 00 00       	call   150 <run_test>

    exit();
  24:	e8 09 04 00 00       	call   432 <exit>
  29:	66 90                	xchg   %ax,%ax
  2b:	66 90                	xchg   %ax,%ax
  2d:	66 90                	xchg   %ax,%ax
  2f:	90                   	nop

00000030 <test_21_1>:
int test_21_1(void) {
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  34:	bb 32 00 00 00       	mov    $0x32,%ebx
  39:	83 ec 04             	sub    $0x4,%esp
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        pid = fork();
  40:	e8 e5 03 00 00       	call   42a <fork>
        if (pid < 0) {
  45:	85 c0                	test   %eax,%eax
  47:	78 65                	js     ae <test_21_1+0x7e>
        } else if (pid == 0)
  49:	74 5e                	je     a9 <test_21_1+0x79>
    for (; i < 50; i++) {
  4b:	83 eb 01             	sub    $0x1,%ebx
  4e:	75 f0                	jne    40 <test_21_1+0x10>
  50:	bb 32 00 00 00       	mov    $0x32,%ebx
  55:	8d 76 00             	lea    0x0(%esi),%esi
        if (wait() < 0) {
  58:	e8 dd 03 00 00       	call   43a <wait>
  5d:	85 c0                	test   %eax,%eax
  5f:	78 34                	js     95 <test_21_1+0x65>
    for (i = 0; i < 50; i++) {
  61:	83 eb 01             	sub    $0x1,%ebx
  64:	75 f2                	jne    58 <test_21_1+0x28>
    if (wait() != -1) { //there are not more procs to wait for
  66:	e8 cf 03 00 00       	call   43a <wait>
  6b:	83 f8 ff             	cmp    $0xffffffff,%eax
  6e:	75 0c                	jne    7c <test_21_1+0x4c>
    return counter == 0; //return 1 if closed well
  70:	bb 01 00 00 00       	mov    $0x1,%ebx
}
  75:	89 d8                	mov    %ebx,%eax
  77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  7a:	c9                   	leave  
  7b:	c3                   	ret    
        printf(1, "ERROR- wait - can't wait without proc\n");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 4c 0c 00 00       	push   $0xc4c
  84:	6a 01                	push   $0x1
  86:	e8 35 05 00 00       	call   5c0 <printf>
}
  8b:	89 d8                	mov    %ebx,%eax
        return 0;
  8d:	83 c4 10             	add    $0x10,%esp
}
  90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  93:	c9                   	leave  
  94:	c3                   	ret    
            printf(1, "ERROR- wait\n");
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 c1 0b 00 00       	push   $0xbc1
  9d:	6a 01                	push   $0x1
  9f:	e8 1c 05 00 00       	call   5c0 <printf>
            exit();
  a4:	e8 89 03 00 00       	call   432 <exit>
            exit();
  a9:	e8 84 03 00 00       	call   432 <exit>
            printf(1, "ERROR- fork\n");
  ae:	83 ec 08             	sub    $0x8,%esp
  b1:	68 b4 0b 00 00       	push   $0xbb4
  b6:	6a 01                	push   $0x1
  b8:	e8 03 05 00 00       	call   5c0 <printf>
            exit();
  bd:	e8 70 03 00 00       	call   432 <exit>
  c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000d0 <test_21_2>:
void test_21_2(void) {
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	83 ec 18             	sub    $0x18,%esp
    char *args[] = {"Test", "2.1", "Passed!", 0}; //final print of test 2.1
  d6:	c7 45 e8 ce 0b 00 00 	movl   $0xbce,-0x18(%ebp)
  dd:	c7 45 ec d3 0b 00 00 	movl   $0xbd3,-0x14(%ebp)
  e4:	c7 45 f0 d7 0b 00 00 	movl   $0xbd7,-0x10(%ebp)
  eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if ((pid = fork()) == 0) {
  f2:	e8 33 03 00 00       	call   42a <fork>
  f7:	83 f8 00             	cmp    $0x0,%eax
  fa:	74 0c                	je     108 <test_21_2+0x38>
    else if (pid > 0) { //wait for children to finish execution
  fc:	7e 35                	jle    133 <test_21_2+0x63>
        wait();
  fe:	e8 37 03 00 00       	call   43a <wait>
}
 103:	c9                   	leave  
 104:	c3                   	ret    
 105:	8d 76 00             	lea    0x0(%esi),%esi
        if (exec(command, args) < 0) { //exec return -1 if failed
 108:	8d 45 e8             	lea    -0x18(%ebp),%eax
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	50                   	push   %eax
 10f:	68 df 0b 00 00       	push   $0xbdf
 114:	e8 51 03 00 00       	call   46a <exec>
 119:	83 c4 10             	add    $0x10,%esp
 11c:	85 c0                	test   %eax,%eax
 11e:	79 e3                	jns    103 <test_21_2+0x33>
            printf(1, "ERROR- exec\n");
 120:	52                   	push   %edx
 121:	52                   	push   %edx
 122:	68 e4 0b 00 00       	push   $0xbe4
 127:	6a 01                	push   $0x1
 129:	e8 92 04 00 00       	call   5c0 <printf>
            exit();
 12e:	e8 ff 02 00 00       	call   432 <exit>
        printf(1, "fork failed\n");
 133:	50                   	push   %eax
 134:	50                   	push   %eax
 135:	68 f1 0b 00 00       	push   $0xbf1
 13a:	6a 01                	push   $0x1
 13c:	e8 7f 04 00 00       	call   5c0 <printf>
        exit();
 141:	e8 ec 02 00 00       	call   432 <exit>
 146:	8d 76 00             	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <run_test>:
void run_test(int testNum) {
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 08             	sub    $0x8,%esp
 156:	8b 45 08             	mov    0x8(%ebp),%eax
    switch (testNum) {
 159:	83 f8 15             	cmp    $0x15,%eax
 15c:	74 3a                	je     198 <run_test+0x48>
 15e:	83 f8 16             	cmp    $0x16,%eax
 161:	75 1d                	jne    180 <run_test+0x30>
            printf(1, "Start test 2.2\n");
 163:	83 ec 08             	sub    $0x8,%esp
 166:	68 22 0c 00 00       	push   $0xc22
 16b:	6a 01                	push   $0x1
 16d:	e8 4e 04 00 00       	call   5c0 <printf>
            break;
 172:	83 c4 10             	add    $0x10,%esp
}
 175:	c9                   	leave  
 176:	c3                   	ret    
 177:	89 f6                	mov    %esi,%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            printf(2, "ERROR- wrong test_ID %d \n", testNum);
 180:	83 ec 04             	sub    $0x4,%esp
 183:	50                   	push   %eax
 184:	68 32 0c 00 00       	push   $0xc32
 189:	6a 02                	push   $0x2
 18b:	e8 30 04 00 00       	call   5c0 <printf>
            return;
 190:	83 c4 10             	add    $0x10,%esp
}
 193:	c9                   	leave  
 194:	c3                   	ret    
 195:	8d 76 00             	lea    0x0(%esi),%esi
            printf(1, "Start test 2.1\n");
 198:	83 ec 08             	sub    $0x8,%esp
 19b:	68 fe 0b 00 00       	push   $0xbfe
 1a0:	6a 01                	push   $0x1
 1a2:	e8 19 04 00 00       	call   5c0 <printf>
            if (test_21_1())
 1a7:	e8 84 fe ff ff       	call   30 <test_21_1>
 1ac:	83 c4 10             	add    $0x10,%esp
 1af:	85 c0                	test   %eax,%eax
 1b1:	74 0d                	je     1c0 <run_test+0x70>
}
 1b3:	c9                   	leave  
                test_21_2();
 1b4:	e9 17 ff ff ff       	jmp    d0 <test_21_2>
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                printf(1, "Failed in test 2.1\n");
 1c0:	83 ec 08             	sub    $0x8,%esp
 1c3:	68 0e 0c 00 00       	push   $0xc0e
 1c8:	6a 01                	push   $0x1
 1ca:	e8 f1 03 00 00       	call   5c0 <printf>
 1cf:	83 c4 10             	add    $0x10,%esp
}
 1d2:	c9                   	leave  
 1d3:	c3                   	ret    
 1d4:	66 90                	xchg   %ax,%ax
 1d6:	66 90                	xchg   %ax,%ax
 1d8:	66 90                	xchg   %ax,%ax
 1da:	66 90                	xchg   %ax,%ax
 1dc:	66 90                	xchg   %ax,%ax
 1de:	66 90                	xchg   %ax,%ax

000001e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ea:	89 c2                	mov    %eax,%edx
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f0:	83 c1 01             	add    $0x1,%ecx
 1f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1f7:	83 c2 01             	add    $0x1,%edx
 1fa:	84 db                	test   %bl,%bl
 1fc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1ff:	75 ef                	jne    1f0 <strcpy+0x10>
    ;
  return os;
}
 201:	5b                   	pop    %ebx
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 20a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 55 08             	mov    0x8(%ebp),%edx
 217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 21a:	0f b6 02             	movzbl (%edx),%eax
 21d:	0f b6 19             	movzbl (%ecx),%ebx
 220:	84 c0                	test   %al,%al
 222:	75 1c                	jne    240 <strcmp+0x30>
 224:	eb 2a                	jmp    250 <strcmp+0x40>
 226:	8d 76 00             	lea    0x0(%esi),%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 230:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 233:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 236:	83 c1 01             	add    $0x1,%ecx
 239:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 23c:	84 c0                	test   %al,%al
 23e:	74 10                	je     250 <strcmp+0x40>
 240:	38 d8                	cmp    %bl,%al
 242:	74 ec                	je     230 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 244:	29 d8                	sub    %ebx,%eax
}
 246:	5b                   	pop    %ebx
 247:	5d                   	pop    %ebp
 248:	c3                   	ret    
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 250:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 252:	29 d8                	sub    %ebx,%eax
}
 254:	5b                   	pop    %ebx
 255:	5d                   	pop    %ebp
 256:	c3                   	ret    
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <strlen>:

uint
strlen(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 266:	80 39 00             	cmpb   $0x0,(%ecx)
 269:	74 15                	je     280 <strlen+0x20>
 26b:	31 d2                	xor    %edx,%edx
 26d:	8d 76 00             	lea    0x0(%esi),%esi
 270:	83 c2 01             	add    $0x1,%edx
 273:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 277:	89 d0                	mov    %edx,%eax
 279:	75 f5                	jne    270 <strlen+0x10>
    ;
  return n;
}
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 280:	31 c0                	xor    %eax,%eax
}
 282:	5d                   	pop    %ebp
 283:	c3                   	ret    
 284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 28a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 297:	8b 4d 10             	mov    0x10(%ebp),%ecx
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	89 d7                	mov    %edx,%edi
 29f:	fc                   	cld    
 2a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2a2:	89 d0                	mov    %edx,%eax
 2a4:	5f                   	pop    %edi
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    
 2a7:	89 f6                	mov    %esi,%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	84 d2                	test   %dl,%dl
 2bf:	74 1d                	je     2de <strchr+0x2e>
    if(*s == c)
 2c1:	38 d3                	cmp    %dl,%bl
 2c3:	89 d9                	mov    %ebx,%ecx
 2c5:	75 0d                	jne    2d4 <strchr+0x24>
 2c7:	eb 17                	jmp    2e0 <strchr+0x30>
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2d0:	38 ca                	cmp    %cl,%dl
 2d2:	74 0c                	je     2e0 <strchr+0x30>
  for(; *s; s++)
 2d4:	83 c0 01             	add    $0x1,%eax
 2d7:	0f b6 10             	movzbl (%eax),%edx
 2da:	84 d2                	test   %dl,%dl
 2dc:	75 f2                	jne    2d0 <strchr+0x20>
      return (char*)s;
  return 0;
 2de:	31 c0                	xor    %eax,%eax
}
 2e0:	5b                   	pop    %ebx
 2e1:	5d                   	pop    %ebp
 2e2:	c3                   	ret    
 2e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <gets>:

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f6:	31 f6                	xor    %esi,%esi
 2f8:	89 f3                	mov    %esi,%ebx
{
 2fa:	83 ec 1c             	sub    $0x1c,%esp
 2fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 300:	eb 2f                	jmp    331 <gets+0x41>
 302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 308:	8d 45 e7             	lea    -0x19(%ebp),%eax
 30b:	83 ec 04             	sub    $0x4,%esp
 30e:	6a 01                	push   $0x1
 310:	50                   	push   %eax
 311:	6a 00                	push   $0x0
 313:	e8 32 01 00 00       	call   44a <read>
    if(cc < 1)
 318:	83 c4 10             	add    $0x10,%esp
 31b:	85 c0                	test   %eax,%eax
 31d:	7e 1c                	jle    33b <gets+0x4b>
      break;
    buf[i++] = c;
 31f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 323:	83 c7 01             	add    $0x1,%edi
 326:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 329:	3c 0a                	cmp    $0xa,%al
 32b:	74 23                	je     350 <gets+0x60>
 32d:	3c 0d                	cmp    $0xd,%al
 32f:	74 1f                	je     350 <gets+0x60>
  for(i=0; i+1 < max; ){
 331:	83 c3 01             	add    $0x1,%ebx
 334:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 337:	89 fe                	mov    %edi,%esi
 339:	7c cd                	jl     308 <gets+0x18>
 33b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 340:	c6 03 00             	movb   $0x0,(%ebx)
}
 343:	8d 65 f4             	lea    -0xc(%ebp),%esp
 346:	5b                   	pop    %ebx
 347:	5e                   	pop    %esi
 348:	5f                   	pop    %edi
 349:	5d                   	pop    %ebp
 34a:	c3                   	ret    
 34b:	90                   	nop
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 350:	8b 75 08             	mov    0x8(%ebp),%esi
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	01 de                	add    %ebx,%esi
 358:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 35a:	c6 03 00             	movb   $0x0,(%ebx)
}
 35d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 360:	5b                   	pop    %ebx
 361:	5e                   	pop    %esi
 362:	5f                   	pop    %edi
 363:	5d                   	pop    %ebp
 364:	c3                   	ret    
 365:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <stat>:

int
stat(const char *n, struct stat *st)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 375:	83 ec 08             	sub    $0x8,%esp
 378:	6a 00                	push   $0x0
 37a:	ff 75 08             	pushl  0x8(%ebp)
 37d:	e8 f0 00 00 00       	call   472 <open>
  if(fd < 0)
 382:	83 c4 10             	add    $0x10,%esp
 385:	85 c0                	test   %eax,%eax
 387:	78 27                	js     3b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 389:	83 ec 08             	sub    $0x8,%esp
 38c:	ff 75 0c             	pushl  0xc(%ebp)
 38f:	89 c3                	mov    %eax,%ebx
 391:	50                   	push   %eax
 392:	e8 f3 00 00 00       	call   48a <fstat>
  close(fd);
 397:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 39a:	89 c6                	mov    %eax,%esi
  close(fd);
 39c:	e8 b9 00 00 00       	call   45a <close>
  return r;
 3a1:	83 c4 10             	add    $0x10,%esp
}
 3a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3a7:	89 f0                	mov    %esi,%eax
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3b5:	eb ed                	jmp    3a4 <stat+0x34>
 3b7:	89 f6                	mov    %esi,%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c7:	0f be 11             	movsbl (%ecx),%edx
 3ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 3cd:	3c 09                	cmp    $0x9,%al
  n = 0;
 3cf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 3d4:	77 1f                	ja     3f5 <atoi+0x35>
 3d6:	8d 76 00             	lea    0x0(%esi),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 3e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3e3:	83 c1 01             	add    $0x1,%ecx
 3e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 3ea:	0f be 11             	movsbl (%ecx),%edx
 3ed:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
  return n;
}
 3f5:	5b                   	pop    %ebx
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    
 3f8:	90                   	nop
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
 405:	8b 5d 10             	mov    0x10(%ebp),%ebx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40e:	85 db                	test   %ebx,%ebx
 410:	7e 14                	jle    426 <memmove+0x26>
 412:	31 d2                	xor    %edx,%edx
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 418:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 41c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 41f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 422:	39 d3                	cmp    %edx,%ebx
 424:	75 f2                	jne    418 <memmove+0x18>
  return vdst;
}
 426:	5b                   	pop    %ebx
 427:	5e                   	pop    %esi
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    

0000042a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42a:	b8 01 00 00 00       	mov    $0x1,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <exit>:
SYSCALL(exit)
 432:	b8 02 00 00 00       	mov    $0x2,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <wait>:
SYSCALL(wait)
 43a:	b8 03 00 00 00       	mov    $0x3,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <pipe>:
SYSCALL(pipe)
 442:	b8 04 00 00 00       	mov    $0x4,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <read>:
SYSCALL(read)
 44a:	b8 05 00 00 00       	mov    $0x5,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <write>:
SYSCALL(write)
 452:	b8 10 00 00 00       	mov    $0x10,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <close>:
SYSCALL(close)
 45a:	b8 15 00 00 00       	mov    $0x15,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <kill>:
SYSCALL(kill)
 462:	b8 06 00 00 00       	mov    $0x6,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <exec>:
SYSCALL(exec)
 46a:	b8 07 00 00 00       	mov    $0x7,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <open>:
SYSCALL(open)
 472:	b8 0f 00 00 00       	mov    $0xf,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <mknod>:
SYSCALL(mknod)
 47a:	b8 11 00 00 00       	mov    $0x11,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <unlink>:
SYSCALL(unlink)
 482:	b8 12 00 00 00       	mov    $0x12,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <fstat>:
SYSCALL(fstat)
 48a:	b8 08 00 00 00       	mov    $0x8,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <link>:
SYSCALL(link)
 492:	b8 13 00 00 00       	mov    $0x13,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mkdir>:
SYSCALL(mkdir)
 49a:	b8 14 00 00 00       	mov    $0x14,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <chdir>:
SYSCALL(chdir)
 4a2:	b8 09 00 00 00       	mov    $0x9,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <dup>:
SYSCALL(dup)
 4aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <getpid>:
SYSCALL(getpid)
 4b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <sbrk>:
SYSCALL(sbrk)
 4ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <sleep>:
SYSCALL(sleep)
 4c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <uptime>:
SYSCALL(uptime)
 4ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <kthread_create>:
//kthread
SYSCALL(kthread_create)
 4d2:	b8 16 00 00 00       	mov    $0x16,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <kthread_id>:
SYSCALL(kthread_id)
 4da:	b8 17 00 00 00       	mov    $0x17,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <kthread_exit>:
SYSCALL(kthread_exit)
 4e2:	b8 18 00 00 00       	mov    $0x18,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <kthread_join>:
SYSCALL(kthread_join)
 4ea:	b8 19 00 00 00       	mov    $0x19,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <kthread_mutex_alloc>:

//kthread_mutex
SYSCALL(kthread_mutex_alloc)
 4f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
 4fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
 502:	b8 1c 00 00 00       	mov    $0x1c,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
 50a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <safe_tree_dealloc>:
SYSCALL(safe_tree_dealloc)
 512:	b8 1e 00 00 00       	mov    $0x1e,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    
 51a:	66 90                	xchg   %ax,%ax
 51c:	66 90                	xchg   %ax,%ax
 51e:	66 90                	xchg   %ax,%ax

00000520 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 529:	85 d2                	test   %edx,%edx
{
 52b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 52e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 530:	79 76                	jns    5a8 <printint+0x88>
 532:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 536:	74 70                	je     5a8 <printint+0x88>
    x = -xx;
 538:	f7 d8                	neg    %eax
    neg = 1;
 53a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 541:	31 f6                	xor    %esi,%esi
 543:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 546:	eb 0a                	jmp    552 <printint+0x32>
 548:	90                   	nop
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 550:	89 fe                	mov    %edi,%esi
 552:	31 d2                	xor    %edx,%edx
 554:	8d 7e 01             	lea    0x1(%esi),%edi
 557:	f7 f1                	div    %ecx
 559:	0f b6 92 7c 0c 00 00 	movzbl 0xc7c(%edx),%edx
  }while((x /= base) != 0);
 560:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 562:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 565:	75 e9                	jne    550 <printint+0x30>
  if(neg)
 567:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 56a:	85 c0                	test   %eax,%eax
 56c:	74 08                	je     576 <printint+0x56>
    buf[i++] = '-';
 56e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 573:	8d 7e 02             	lea    0x2(%esi),%edi
 576:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 57a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
 580:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 583:	83 ec 04             	sub    $0x4,%esp
 586:	83 ee 01             	sub    $0x1,%esi
 589:	6a 01                	push   $0x1
 58b:	53                   	push   %ebx
 58c:	57                   	push   %edi
 58d:	88 45 d7             	mov    %al,-0x29(%ebp)
 590:	e8 bd fe ff ff       	call   452 <write>

  while(--i >= 0)
 595:	83 c4 10             	add    $0x10,%esp
 598:	39 de                	cmp    %ebx,%esi
 59a:	75 e4                	jne    580 <printint+0x60>
    putc(fd, buf[i]);
}
 59c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59f:	5b                   	pop    %ebx
 5a0:	5e                   	pop    %esi
 5a1:	5f                   	pop    %edi
 5a2:	5d                   	pop    %ebp
 5a3:	c3                   	ret    
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5a8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5af:	eb 90                	jmp    541 <printint+0x21>
 5b1:	eb 0d                	jmp    5c0 <printf>
 5b3:	90                   	nop
 5b4:	90                   	nop
 5b5:	90                   	nop
 5b6:	90                   	nop
 5b7:	90                   	nop
 5b8:	90                   	nop
 5b9:	90                   	nop
 5ba:	90                   	nop
 5bb:	90                   	nop
 5bc:	90                   	nop
 5bd:	90                   	nop
 5be:	90                   	nop
 5bf:	90                   	nop

000005c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5cc:	0f b6 1e             	movzbl (%esi),%ebx
 5cf:	84 db                	test   %bl,%bl
 5d1:	0f 84 b3 00 00 00    	je     68a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 5d7:	8d 45 10             	lea    0x10(%ebp),%eax
 5da:	83 c6 01             	add    $0x1,%esi
  state = 0;
 5dd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 5df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5e2:	eb 2f                	jmp    613 <printf+0x53>
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5e8:	83 f8 25             	cmp    $0x25,%eax
 5eb:	0f 84 a7 00 00 00    	je     698 <printf+0xd8>
  write(fd, &c, 1);
 5f1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5f4:	83 ec 04             	sub    $0x4,%esp
 5f7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5fa:	6a 01                	push   $0x1
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 4d fe ff ff       	call   452 <write>
 605:	83 c4 10             	add    $0x10,%esp
 608:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 60b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 60f:	84 db                	test   %bl,%bl
 611:	74 77                	je     68a <printf+0xca>
    if(state == 0){
 613:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 615:	0f be cb             	movsbl %bl,%ecx
 618:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 61b:	74 cb                	je     5e8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 61d:	83 ff 25             	cmp    $0x25,%edi
 620:	75 e6                	jne    608 <printf+0x48>
      if(c == 'd'){
 622:	83 f8 64             	cmp    $0x64,%eax
 625:	0f 84 05 01 00 00    	je     730 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 62b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 631:	83 f9 70             	cmp    $0x70,%ecx
 634:	74 72                	je     6a8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 636:	83 f8 73             	cmp    $0x73,%eax
 639:	0f 84 99 00 00 00    	je     6d8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63f:	83 f8 63             	cmp    $0x63,%eax
 642:	0f 84 08 01 00 00    	je     750 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 648:	83 f8 25             	cmp    $0x25,%eax
 64b:	0f 84 ef 00 00 00    	je     740 <printf+0x180>
  write(fd, &c, 1);
 651:	8d 45 e7             	lea    -0x19(%ebp),%eax
 654:	83 ec 04             	sub    $0x4,%esp
 657:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 65b:	6a 01                	push   $0x1
 65d:	50                   	push   %eax
 65e:	ff 75 08             	pushl  0x8(%ebp)
 661:	e8 ec fd ff ff       	call   452 <write>
 666:	83 c4 0c             	add    $0xc,%esp
 669:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 66c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 66f:	6a 01                	push   $0x1
 671:	50                   	push   %eax
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 678:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 67a:	e8 d3 fd ff ff       	call   452 <write>
  for(i = 0; fmt[i]; i++){
 67f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 683:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 686:	84 db                	test   %bl,%bl
 688:	75 89                	jne    613 <printf+0x53>
    }
  }
}
 68a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68d:	5b                   	pop    %ebx
 68e:	5e                   	pop    %esi
 68f:	5f                   	pop    %edi
 690:	5d                   	pop    %ebp
 691:	c3                   	ret    
 692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 698:	bf 25 00 00 00       	mov    $0x25,%edi
 69d:	e9 66 ff ff ff       	jmp    608 <printf+0x48>
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6a8:	83 ec 0c             	sub    $0xc,%esp
 6ab:	b9 10 00 00 00       	mov    $0x10,%ecx
 6b0:	6a 00                	push   $0x0
 6b2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6b5:	8b 45 08             	mov    0x8(%ebp),%eax
 6b8:	8b 17                	mov    (%edi),%edx
 6ba:	e8 61 fe ff ff       	call   520 <printint>
        ap++;
 6bf:	89 f8                	mov    %edi,%eax
 6c1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6c4:	31 ff                	xor    %edi,%edi
        ap++;
 6c6:	83 c0 04             	add    $0x4,%eax
 6c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6cc:	e9 37 ff ff ff       	jmp    608 <printf+0x48>
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6db:	8b 08                	mov    (%eax),%ecx
        ap++;
 6dd:	83 c0 04             	add    $0x4,%eax
 6e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 6e3:	85 c9                	test   %ecx,%ecx
 6e5:	0f 84 8e 00 00 00    	je     779 <printf+0x1b9>
        while(*s != 0){
 6eb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 6ee:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 6f0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 6f2:	84 c0                	test   %al,%al
 6f4:	0f 84 0e ff ff ff    	je     608 <printf+0x48>
 6fa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6fd:	89 de                	mov    %ebx,%esi
 6ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
 702:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 705:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 708:	83 ec 04             	sub    $0x4,%esp
          s++;
 70b:	83 c6 01             	add    $0x1,%esi
 70e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 711:	6a 01                	push   $0x1
 713:	57                   	push   %edi
 714:	53                   	push   %ebx
 715:	e8 38 fd ff ff       	call   452 <write>
        while(*s != 0){
 71a:	0f b6 06             	movzbl (%esi),%eax
 71d:	83 c4 10             	add    $0x10,%esp
 720:	84 c0                	test   %al,%al
 722:	75 e4                	jne    708 <printf+0x148>
 724:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 727:	31 ff                	xor    %edi,%edi
 729:	e9 da fe ff ff       	jmp    608 <printf+0x48>
 72e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 730:	83 ec 0c             	sub    $0xc,%esp
 733:	b9 0a 00 00 00       	mov    $0xa,%ecx
 738:	6a 01                	push   $0x1
 73a:	e9 73 ff ff ff       	jmp    6b2 <printf+0xf2>
 73f:	90                   	nop
  write(fd, &c, 1);
 740:	83 ec 04             	sub    $0x4,%esp
 743:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 746:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 749:	6a 01                	push   $0x1
 74b:	e9 21 ff ff ff       	jmp    671 <printf+0xb1>
        putc(fd, *ap);
 750:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 753:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 756:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 758:	6a 01                	push   $0x1
        ap++;
 75a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 75d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 760:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 763:	50                   	push   %eax
 764:	ff 75 08             	pushl  0x8(%ebp)
 767:	e8 e6 fc ff ff       	call   452 <write>
        ap++;
 76c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 76f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 772:	31 ff                	xor    %edi,%edi
 774:	e9 8f fe ff ff       	jmp    608 <printf+0x48>
          s = "(null)";
 779:	bb 74 0c 00 00       	mov    $0xc74,%ebx
        while(*s != 0){
 77e:	b8 28 00 00 00       	mov    $0x28,%eax
 783:	e9 72 ff ff ff       	jmp    6fa <printf+0x13a>
 788:	66 90                	xchg   %ax,%ax
 78a:	66 90                	xchg   %ax,%ax
 78c:	66 90                	xchg   %ax,%ax
 78e:	66 90                	xchg   %ax,%ax

00000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 791:	a1 e0 10 00 00       	mov    0x10e0,%eax
{
 796:	89 e5                	mov    %esp,%ebp
 798:	57                   	push   %edi
 799:	56                   	push   %esi
 79a:	53                   	push   %ebx
 79b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 79e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	39 c8                	cmp    %ecx,%eax
 7aa:	8b 10                	mov    (%eax),%edx
 7ac:	73 32                	jae    7e0 <free+0x50>
 7ae:	39 d1                	cmp    %edx,%ecx
 7b0:	72 04                	jb     7b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	39 d0                	cmp    %edx,%eax
 7b4:	72 32                	jb     7e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7bc:	39 fa                	cmp    %edi,%edx
 7be:	74 30                	je     7f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7c3:	8b 50 04             	mov    0x4(%eax),%edx
 7c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c9:	39 f1                	cmp    %esi,%ecx
 7cb:	74 3a                	je     807 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7cd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7cf:	a3 e0 10 00 00       	mov    %eax,0x10e0
}
 7d4:	5b                   	pop    %ebx
 7d5:	5e                   	pop    %esi
 7d6:	5f                   	pop    %edi
 7d7:	5d                   	pop    %ebp
 7d8:	c3                   	ret    
 7d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	39 d0                	cmp    %edx,%eax
 7e2:	72 04                	jb     7e8 <free+0x58>
 7e4:	39 d1                	cmp    %edx,%ecx
 7e6:	72 ce                	jb     7b6 <free+0x26>
{
 7e8:	89 d0                	mov    %edx,%eax
 7ea:	eb bc                	jmp    7a8 <free+0x18>
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7f0:	03 72 04             	add    0x4(%edx),%esi
 7f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 12                	mov    (%edx),%edx
 7fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7fd:	8b 50 04             	mov    0x4(%eax),%edx
 800:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 803:	39 f1                	cmp    %esi,%ecx
 805:	75 c6                	jne    7cd <free+0x3d>
    p->s.size += bp->s.size;
 807:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 80a:	a3 e0 10 00 00       	mov    %eax,0x10e0
    p->s.size += bp->s.size;
 80f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 812:	8b 53 f8             	mov    -0x8(%ebx),%edx
 815:	89 10                	mov    %edx,(%eax)
}
 817:	5b                   	pop    %ebx
 818:	5e                   	pop    %esi
 819:	5f                   	pop    %edi
 81a:	5d                   	pop    %ebp
 81b:	c3                   	ret    
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
 826:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 829:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 82c:	8b 15 e0 10 00 00    	mov    0x10e0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	8d 78 07             	lea    0x7(%eax),%edi
 835:	c1 ef 03             	shr    $0x3,%edi
 838:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 83b:	85 d2                	test   %edx,%edx
 83d:	0f 84 9d 00 00 00    	je     8e0 <malloc+0xc0>
 843:	8b 02                	mov    (%edx),%eax
 845:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 848:	39 cf                	cmp    %ecx,%edi
 84a:	76 6c                	jbe    8b8 <malloc+0x98>
 84c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 852:	bb 00 10 00 00       	mov    $0x1000,%ebx
 857:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 85a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 861:	eb 0e                	jmp    871 <malloc+0x51>
 863:	90                   	nop
 864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 86a:	8b 48 04             	mov    0x4(%eax),%ecx
 86d:	39 f9                	cmp    %edi,%ecx
 86f:	73 47                	jae    8b8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 871:	39 05 e0 10 00 00    	cmp    %eax,0x10e0
 877:	89 c2                	mov    %eax,%edx
 879:	75 ed                	jne    868 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 87b:	83 ec 0c             	sub    $0xc,%esp
 87e:	56                   	push   %esi
 87f:	e8 36 fc ff ff       	call   4ba <sbrk>
  if(p == (char*)-1)
 884:	83 c4 10             	add    $0x10,%esp
 887:	83 f8 ff             	cmp    $0xffffffff,%eax
 88a:	74 1c                	je     8a8 <malloc+0x88>
  hp->s.size = nu;
 88c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 88f:	83 ec 0c             	sub    $0xc,%esp
 892:	83 c0 08             	add    $0x8,%eax
 895:	50                   	push   %eax
 896:	e8 f5 fe ff ff       	call   790 <free>
  return freep;
 89b:	8b 15 e0 10 00 00    	mov    0x10e0,%edx
      if((p = morecore(nunits)) == 0)
 8a1:	83 c4 10             	add    $0x10,%esp
 8a4:	85 d2                	test   %edx,%edx
 8a6:	75 c0                	jne    868 <malloc+0x48>
        return 0;
  }
}
 8a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8ab:	31 c0                	xor    %eax,%eax
}
 8ad:	5b                   	pop    %ebx
 8ae:	5e                   	pop    %esi
 8af:	5f                   	pop    %edi
 8b0:	5d                   	pop    %ebp
 8b1:	c3                   	ret    
 8b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8b8:	39 cf                	cmp    %ecx,%edi
 8ba:	74 54                	je     910 <malloc+0xf0>
        p->s.size -= nunits;
 8bc:	29 f9                	sub    %edi,%ecx
 8be:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8c1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8c4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8c7:	89 15 e0 10 00 00    	mov    %edx,0x10e0
}
 8cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8d0:	83 c0 08             	add    $0x8,%eax
}
 8d3:	5b                   	pop    %ebx
 8d4:	5e                   	pop    %esi
 8d5:	5f                   	pop    %edi
 8d6:	5d                   	pop    %ebp
 8d7:	c3                   	ret    
 8d8:	90                   	nop
 8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 8e0:	c7 05 e0 10 00 00 e4 	movl   $0x10e4,0x10e0
 8e7:	10 00 00 
 8ea:	c7 05 e4 10 00 00 e4 	movl   $0x10e4,0x10e4
 8f1:	10 00 00 
    base.s.size = 0;
 8f4:	b8 e4 10 00 00       	mov    $0x10e4,%eax
 8f9:	c7 05 e8 10 00 00 00 	movl   $0x0,0x10e8
 900:	00 00 00 
 903:	e9 44 ff ff ff       	jmp    84c <malloc+0x2c>
 908:	90                   	nop
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 910:	8b 08                	mov    (%eax),%ecx
 912:	89 0a                	mov    %ecx,(%edx)
 914:	eb b1                	jmp    8c7 <malloc+0xa7>
 916:	66 90                	xchg   %ax,%ax
 918:	66 90                	xchg   %ax,%ax
 91a:	66 90                	xchg   %ax,%ax
 91c:	66 90                	xchg   %ax,%ax
 91e:	66 90                	xchg   %ax,%ax

00000920 <ourpower.part.0>:
struct {
    //struct spinlock lock;
    trnmnt_tree trnmnt_tree[NPROC];
} treetable;

int ourpower(int num) {
 920:	55                   	push   %ebp
    if (num < 0) {
        //cprintf("Illegal input: for a^b: a= %d, b= %d \n", a, b);
        return -1;
    }
    int output = 1;
    for (int i = 0; i < num; i++)
 921:	85 c0                	test   %eax,%eax
int ourpower(int num) {
 923:	89 e5                	mov    %esp,%ebp
    for (int i = 0; i < num; i++)
 925:	7e 19                	jle    940 <ourpower.part.0+0x20>
 927:	31 d2                	xor    %edx,%edx
    int output = 1;
 929:	b9 01 00 00 00       	mov    $0x1,%ecx
 92e:	66 90                	xchg   %ax,%ax
    for (int i = 0; i < num; i++)
 930:	83 c2 01             	add    $0x1,%edx
        output *= 2;
 933:	01 c9                	add    %ecx,%ecx
    for (int i = 0; i < num; i++)
 935:	39 c2                	cmp    %eax,%edx
 937:	75 f7                	jne    930 <ourpower.part.0+0x10>
    return output;
}
 939:	89 c8                	mov    %ecx,%eax
 93b:	5d                   	pop    %ebp
 93c:	c3                   	ret    
 93d:	8d 76 00             	lea    0x0(%esi),%esi
    int output = 1;
 940:	b9 01 00 00 00       	mov    $0x1,%ecx
}
 945:	89 c8                	mov    %ecx,%eax
 947:	5d                   	pop    %ebp
 948:	c3                   	ret    
 949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000950 <ourpower>:
int ourpower(int num) {
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	8b 45 08             	mov    0x8(%ebp),%eax
    if (num < 0) {
 956:	85 c0                	test   %eax,%eax
 958:	78 03                	js     95d <ourpower+0xd>
}
 95a:	5d                   	pop    %ebp
 95b:	eb c3                	jmp    920 <ourpower.part.0>
 95d:	83 c8 ff             	or     $0xffffffff,%eax
 960:	5d                   	pop    %ebp
 961:	c3                   	ret    
 962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000970 <trnmnt_tree_alloc>:

struct trnmnt_tree*
trnmnt_tree_alloc(int depth){
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
 973:	57                   	push   %edi
 974:	56                   	push   %esi
 975:	53                   	push   %ebx
    trnmnt_tree *t;

    for (t = treetable.trnmnt_tree ; t < &treetable.trnmnt_tree[NPROC] ; t++) {
 976:	bb 00 11 00 00       	mov    $0x1100,%ebx
trnmnt_tree_alloc(int depth){
 97b:	83 ec 0c             	sub    $0xc,%esp
 97e:	8b 45 08             	mov    0x8(%ebp),%eax
 981:	eb 13                	jmp    996 <trnmnt_tree_alloc+0x26>
 983:	90                   	nop
 984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (t = treetable.trnmnt_tree ; t < &treetable.trnmnt_tree[NPROC] ; t++) {
 988:	81 c3 08 01 00 00    	add    $0x108,%ebx
 98e:	81 fb 00 53 00 00    	cmp    $0x5300,%ebx
 994:	73 42                	jae    9d8 <trnmnt_tree_alloc+0x68>
        if (t->active == INACTIVE)
 996:	8b 13                	mov    (%ebx),%edx
 998:	85 d2                	test   %edx,%edx
 99a:	75 ec                	jne    988 <trnmnt_tree_alloc+0x18>
    if (num < 0) {
 99c:	85 c0                	test   %eax,%eax
            goto found_tree;
    }
    return 0;

    found_tree:
    t->active = ACTIVE;
 99e:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    t->depth = depth;
 9a4:	89 43 04             	mov    %eax,0x4(%ebx)
    if (num < 0) {
 9a7:	78 1f                	js     9c8 <trnmnt_tree_alloc+0x58>
 9a9:	e8 72 ff ff ff       	call   920 <ourpower.part.0>

    for(int i=0; i<(ourpower(depth)-1); i++)
 9ae:	31 f6                	xor    %esi,%esi
 9b0:	8d 78 ff             	lea    -0x1(%eax),%edi
 9b3:	eb 0f                	jmp    9c4 <trnmnt_tree_alloc+0x54>
 9b5:	8d 76 00             	lea    0x0(%esi),%esi
        t->trnmntMutex[i] = kthread_mutex_alloc();
 9b8:	e8 35 fb ff ff       	call   4f2 <kthread_mutex_alloc>
 9bd:	89 44 b3 08          	mov    %eax,0x8(%ebx,%esi,4)
    for(int i=0; i<(ourpower(depth)-1); i++)
 9c1:	83 c6 01             	add    $0x1,%esi
 9c4:	39 f7                	cmp    %esi,%edi
 9c6:	7f f0                	jg     9b8 <trnmnt_tree_alloc+0x48>

    return t;
}
 9c8:	83 c4 0c             	add    $0xc,%esp
 9cb:	89 d8                	mov    %ebx,%eax
 9cd:	5b                   	pop    %ebx
 9ce:	5e                   	pop    %esi
 9cf:	5f                   	pop    %edi
 9d0:	5d                   	pop    %ebp
 9d1:	c3                   	ret    
 9d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9d8:	83 c4 0c             	add    $0xc,%esp
    return 0;
 9db:	31 db                	xor    %ebx,%ebx
}
 9dd:	89 d8                	mov    %ebx,%eax
 9df:	5b                   	pop    %ebx
 9e0:	5e                   	pop    %esi
 9e1:	5f                   	pop    %edi
 9e2:	5d                   	pop    %ebp
 9e3:	c3                   	ret    
 9e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000009f0 <trnmnt_tree_dealloc>:

int
trnmnt_tree_dealloc(trnmnt_tree* tree){
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	57                   	push   %edi
 9f4:	56                   	push   %esi
 9f5:	53                   	push   %ebx
 9f6:	83 ec 0c             	sub    $0xc,%esp
 9f9:	8b 75 08             	mov    0x8(%ebp),%esi
    if(tree->active == INACTIVE )
 9fc:	8b 06                	mov    (%esi),%eax
 9fe:	85 c0                	test   %eax,%eax
 a00:	74 56                	je     a58 <trnmnt_tree_dealloc+0x68>
        return -1;



    for(int j=0; j<(ourpower(tree->depth)-1); j++){
 a02:	31 ff                	xor    %edi,%edi
 a04:	eb 2e                	jmp    a34 <trnmnt_tree_dealloc+0x44>
 a06:	8d 76 00             	lea    0x0(%esi),%esi
 a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 a10:	89 d8                	mov    %ebx,%eax
 a12:	e8 09 ff ff ff       	call   920 <ourpower.part.0>
 a17:	83 e8 01             	sub    $0x1,%eax
 a1a:	39 c7                	cmp    %eax,%edi
 a1c:	7d 47                	jge    a65 <trnmnt_tree_dealloc+0x75>
        if(safe_tree_dealloc(tree->trnmntMutex[j]) == 0 )
 a1e:	83 ec 0c             	sub    $0xc,%esp
 a21:	ff 74 be 08          	pushl  0x8(%esi,%edi,4)
 a25:	e8 e8 fa ff ff       	call   512 <safe_tree_dealloc>
 a2a:	83 c4 10             	add    $0x10,%esp
 a2d:	85 c0                	test   %eax,%eax
 a2f:	74 27                	je     a58 <trnmnt_tree_dealloc+0x68>
    for(int j=0; j<(ourpower(tree->depth)-1); j++){
 a31:	83 c7 01             	add    $0x1,%edi
 a34:	8b 5e 04             	mov    0x4(%esi),%ebx
    if (num < 0) {
 a37:	85 db                	test   %ebx,%ebx
 a39:	79 d5                	jns    a10 <trnmnt_tree_dealloc+0x20>
            //printf(1," WERE ARE FUCKED %d  \n" , i);
            return -1;
        }
    }

    tree->depth=0;
 a3b:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    tree->active = INACTIVE;
 a42:	c7 06 00 00 00 00    	movl   $0x0,(%esi)

    return 0;
}
 a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
 a4b:	31 c0                	xor    %eax,%eax
}
 a4d:	5b                   	pop    %ebx
 a4e:	5e                   	pop    %esi
 a4f:	5f                   	pop    %edi
 a50:	5d                   	pop    %ebp
 a51:	c3                   	ret    
 a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
 a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a60:	5b                   	pop    %ebx
 a61:	5e                   	pop    %esi
 a62:	5f                   	pop    %edi
 a63:	5d                   	pop    %ebp
 a64:	c3                   	ret    
    for(int i=0; i<(ourpower(tree->depth)-1); i++){
 a65:	31 ff                	xor    %edi,%edi
 a67:	89 f6                	mov    %esi,%esi
 a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 a70:	89 d8                	mov    %ebx,%eax
 a72:	e8 a9 fe ff ff       	call   920 <ourpower.part.0>
 a77:	83 e8 01             	sub    $0x1,%eax
 a7a:	39 f8                	cmp    %edi,%eax
 a7c:	7e bd                	jle    a3b <trnmnt_tree_dealloc+0x4b>
        if(kthread_mutex_dealloc(tree->trnmntMutex[i]) == -1 ){
 a7e:	83 ec 0c             	sub    $0xc,%esp
 a81:	ff 74 be 08          	pushl  0x8(%esi,%edi,4)
 a85:	e8 70 fa ff ff       	call   4fa <kthread_mutex_dealloc>
 a8a:	83 c4 10             	add    $0x10,%esp
 a8d:	83 f8 ff             	cmp    $0xffffffff,%eax
 a90:	74 c6                	je     a58 <trnmnt_tree_dealloc+0x68>
    for(int i=0; i<(ourpower(tree->depth)-1); i++){
 a92:	8b 5e 04             	mov    0x4(%esi),%ebx
 a95:	83 c7 01             	add    $0x1,%edi
    if (num < 0) {
 a98:	85 db                	test   %ebx,%ebx
 a9a:	79 d4                	jns    a70 <trnmnt_tree_dealloc+0x80>
 a9c:	eb 9d                	jmp    a3b <trnmnt_tree_dealloc+0x4b>
 a9e:	66 90                	xchg   %ax,%ax

00000aa0 <trnmnt_tree_acquire>:

int
trnmnt_tree_acquire(trnmnt_tree* tree,int ID){
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	57                   	push   %edi
 aa4:	56                   	push   %esi
 aa5:	53                   	push   %ebx
 aa6:	83 ec 1c             	sub    $0x1c,%esp
 aa9:	8b 75 08             	mov    0x8(%ebp),%esi
 aac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    int x=0, localID=ID;
    for(int lvl=1; lvl<=tree->depth; lvl++){
 aaf:	8b 46 04             	mov    0x4(%esi),%eax
 ab2:	85 c0                	test   %eax,%eax
 ab4:	7e 62                	jle    b18 <trnmnt_tree_acquire+0x78>
 ab6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    int x=0, localID=ID;
 abd:	31 ff                	xor    %edi,%edi
 abf:	90                   	nop
        localID= localID/2;     //wich lock try to lock in current level
 ac0:	89 d8                	mov    %ebx,%eax
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
 ac2:	83 ec 0c             	sub    $0xc,%esp
        localID= localID/2;     //wich lock try to lock in current level
 ac5:	c1 e8 1f             	shr    $0x1f,%eax
 ac8:	01 c3                	add    %eax,%ebx
 aca:	d1 fb                	sar    %ebx
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
 acc:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
 acf:	ff 74 86 08          	pushl  0x8(%esi,%eax,4)
 ad3:	e8 2a fa ff ff       	call   502 <kthread_mutex_lock>
 ad8:	83 c4 10             	add    $0x10,%esp
 adb:	83 f8 ff             	cmp    $0xffffffff,%eax
 ade:	74 3a                	je     b1a <trnmnt_tree_acquire+0x7a>
            return -1; //lock ->if not succeed sleep (in mutex implementation)
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 ae0:	8b 4e 04             	mov    0x4(%esi),%ecx
    if (num < 0) {
 ae3:	85 c9                	test   %ecx,%ecx
 ae5:	78 31                	js     b18 <trnmnt_tree_acquire+0x78>
 ae7:	89 c8                	mov    %ecx,%eax
 ae9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
 aec:	e8 2f fe ff ff       	call   920 <ourpower.part.0>
 af1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 af4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 af7:	e8 24 fe ff ff       	call   920 <ourpower.part.0>
 afc:	89 c1                	mov    %eax,%ecx
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 afe:	8b 45 e0             	mov    -0x20(%ebp),%eax
    for(int lvl=1; lvl<=tree->depth; lvl++){
 b01:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 b05:	99                   	cltd   
 b06:	f7 f9                	idiv   %ecx
    for(int lvl=1; lvl<=tree->depth; lvl++){
 b08:	8b 4d dc             	mov    -0x24(%ebp),%ecx
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 b0b:	01 c7                	add    %eax,%edi
    for(int lvl=1; lvl<=tree->depth; lvl++){
 b0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b10:	39 c1                	cmp    %eax,%ecx
 b12:	7d ac                	jge    ac0 <trnmnt_tree_acquire+0x20>
 b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    return 0;
 b18:	31 c0                	xor    %eax,%eax
}
 b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b1d:	5b                   	pop    %ebx
 b1e:	5e                   	pop    %esi
 b1f:	5f                   	pop    %edi
 b20:	5d                   	pop    %ebp
 b21:	c3                   	ret    
 b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b30 <trnmnt_tree_release>:

int
trnmnt_tree_release(trnmnt_tree* tree,int ID){
 b30:	55                   	push   %ebp
 b31:	89 e5                	mov    %esp,%ebp
 b33:	57                   	push   %edi
 b34:	56                   	push   %esi
 b35:	53                   	push   %ebx
 b36:	83 ec 0c             	sub    $0xc,%esp
 b39:	8b 7d 08             	mov    0x8(%ebp),%edi
    int x=ourpower(tree->depth)-2, localID;
 b3c:	8b 5f 04             	mov    0x4(%edi),%ebx
    if (num < 0) {
 b3f:	85 db                	test   %ebx,%ebx
 b41:	78 65                	js     ba8 <trnmnt_tree_release+0x78>
 b43:	89 d8                	mov    %ebx,%eax
 b45:	e8 d6 fd ff ff       	call   920 <ourpower.part.0>
    for(int lvl=tree->depth; lvl>=1; lvl--){
 b4a:	85 db                	test   %ebx,%ebx
 b4c:	8d 70 fe             	lea    -0x2(%eax),%esi
 b4f:	7f 24                	jg     b75 <trnmnt_tree_release+0x45>
 b51:	eb 55                	jmp    ba8 <trnmnt_tree_release+0x78>
 b53:	90                   	nop
 b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //unlock ->if not curthead holds this lock -> return -1 (in mutex implementation)
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 b58:	8b 57 04             	mov    0x4(%edi),%edx
        return -1;
 b5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 b60:	29 da                	sub    %ebx,%edx
    if (num < 0) {
 b62:	83 c2 01             	add    $0x1,%edx
 b65:	78 07                	js     b6e <trnmnt_tree_release+0x3e>
 b67:	89 d0                	mov    %edx,%eax
 b69:	e8 b2 fd ff ff       	call   920 <ourpower.part.0>
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 b6e:	29 c6                	sub    %eax,%esi
    for(int lvl=tree->depth; lvl>=1; lvl--){
 b70:	83 eb 01             	sub    $0x1,%ebx
 b73:	74 33                	je     ba8 <trnmnt_tree_release+0x78>
 b75:	89 d8                	mov    %ebx,%eax
 b77:	e8 a4 fd ff ff       	call   920 <ourpower.part.0>
 b7c:	89 c1                	mov    %eax,%ecx
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
 b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
 b81:	83 ec 0c             	sub    $0xc,%esp
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
 b84:	99                   	cltd   
 b85:	f7 f9                	idiv   %ecx
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
 b87:	01 f0                	add    %esi,%eax
 b89:	ff 74 87 08          	pushl  0x8(%edi,%eax,4)
 b8d:	e8 78 f9 ff ff       	call   50a <kthread_mutex_unlock>
 b92:	83 c4 10             	add    $0x10,%esp
 b95:	83 f8 ff             	cmp    $0xffffffff,%eax
 b98:	75 be                	jne    b58 <trnmnt_tree_release+0x28>
    }
    return 0;
}
 b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b9d:	5b                   	pop    %ebx
 b9e:	5e                   	pop    %esi
 b9f:	5f                   	pop    %edi
 ba0:	5d                   	pop    %ebp
 ba1:	c3                   	ret    
 ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
 bab:	31 c0                	xor    %eax,%eax
}
 bad:	5b                   	pop    %ebx
 bae:	5e                   	pop    %esi
 baf:	5f                   	pop    %edi
 bb0:	5d                   	pop    %ebp
 bb1:	c3                   	ret    
