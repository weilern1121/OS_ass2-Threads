
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 24                	jle    41 <main+0x41>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 cb 00 00 00       	call   100 <ls>
  for(i=1; i<argc; i++)
  35:	83 c4 10             	add    $0x10,%esp
  38:	39 f3                	cmp    %esi,%ebx
  3a:	75 ec                	jne    28 <main+0x28>
  exit();
  3c:	e8 41 05 00 00       	call   582 <exit>
    ls(".");
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	68 4c 0d 00 00       	push   $0xd4c
  49:	e8 b2 00 00 00       	call   100 <ls>
    exit();
  4e:	e8 2f 05 00 00       	call   582 <exit>
  53:	66 90                	xchg   %ax,%ax
  55:	66 90                	xchg   %ax,%ax
  57:	66 90                	xchg   %ax,%ax
  59:	66 90                	xchg   %ax,%ax
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	53                   	push   %ebx
  6c:	e8 3f 03 00 00       	call   3b0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 d8                	add    %ebx,%eax
  76:	73 0f                	jae    87 <fmtname+0x27>
  78:	eb 12                	jmp    8c <fmtname+0x2c>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  80:	83 e8 01             	sub    $0x1,%eax
  83:	39 c3                	cmp    %eax,%ebx
  85:	77 05                	ja     8c <fmtname+0x2c>
  87:	80 38 2f             	cmpb   $0x2f,(%eax)
  8a:	75 f4                	jne    80 <fmtname+0x20>
  p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx
  if(strlen(p) >= DIRSIZ)
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	53                   	push   %ebx
  93:	e8 18 03 00 00       	call   3b0 <strlen>
  98:	83 c4 10             	add    $0x10,%esp
  9b:	83 f8 0d             	cmp    $0xd,%eax
  9e:	77 4a                	ja     ea <fmtname+0x8a>
  memmove(buf, p, strlen(p));
  a0:	83 ec 0c             	sub    $0xc,%esp
  a3:	53                   	push   %ebx
  a4:	e8 07 03 00 00       	call   3b0 <strlen>
  a9:	83 c4 0c             	add    $0xc,%esp
  ac:	50                   	push   %eax
  ad:	53                   	push   %ebx
  ae:	68 c0 11 00 00       	push   $0x11c0
  b3:	e8 98 04 00 00       	call   550 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 f0 02 00 00       	call   3b0 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
  c3:	89 c6                	mov    %eax,%esi
  return buf;
  c5:	bb c0 11 00 00       	mov    $0x11c0,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	e8 e1 02 00 00       	call   3b0 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	83 c4 0c             	add    $0xc,%esp
  d7:	05 c0 11 00 00       	add    $0x11c0,%eax
  dc:	29 f2                	sub    %esi,%edx
  de:	52                   	push   %edx
  df:	6a 20                	push   $0x20
  e1:	50                   	push   %eax
  e2:	e8 f9 02 00 00       	call   3e0 <memset>
  return buf;
  e7:	83 c4 10             	add    $0x10,%esp
}
  ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ed:	89 d8                	mov    %ebx,%eax
  ef:	5b                   	pop    %ebx
  f0:	5e                   	pop    %esi
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    
  f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <ls>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 ab 04 00 00       	call   5c2 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	78 52                	js     170 <ls+0x70>
  if(fstat(fd, &st) < 0){
 11e:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 124:	83 ec 08             	sub    $0x8,%esp
 127:	89 c3                	mov    %eax,%ebx
 129:	56                   	push   %esi
 12a:	50                   	push   %eax
 12b:	e8 aa 04 00 00       	call   5da <fstat>
 130:	83 c4 10             	add    $0x10,%esp
 133:	85 c0                	test   %eax,%eax
 135:	0f 88 c5 00 00 00    	js     200 <ls+0x100>
  switch(st.type){
 13b:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 142:	66 83 f8 01          	cmp    $0x1,%ax
 146:	0f 84 84 00 00 00    	je     1d0 <ls+0xd0>
 14c:	66 83 f8 02          	cmp    $0x2,%ax
 150:	74 3e                	je     190 <ls+0x90>
  close(fd);
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	53                   	push   %ebx
 156:	e8 4f 04 00 00       	call   5aa <close>
 15b:	83 c4 10             	add    $0x10,%esp
}
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
 166:	8d 76 00             	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    printf(2, "ls: cannot open %s\n", path);
 170:	83 ec 04             	sub    $0x4,%esp
 173:	57                   	push   %edi
 174:	68 04 0d 00 00       	push   $0xd04
 179:	6a 02                	push   $0x2
 17b:	e8 90 05 00 00       	call   710 <printf>
    return;
 180:	83 c4 10             	add    $0x10,%esp
}
 183:	8d 65 f4             	lea    -0xc(%ebp),%esp
 186:	5b                   	pop    %ebx
 187:	5e                   	pop    %esi
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    
 18b:	90                   	nop
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 190:	83 ec 0c             	sub    $0xc,%esp
 193:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 199:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 19f:	57                   	push   %edi
 1a0:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 1a6:	e8 b5 fe ff ff       	call   60 <fmtname>
 1ab:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1b1:	59                   	pop    %ecx
 1b2:	5f                   	pop    %edi
 1b3:	52                   	push   %edx
 1b4:	56                   	push   %esi
 1b5:	6a 02                	push   $0x2
 1b7:	50                   	push   %eax
 1b8:	68 2c 0d 00 00       	push   $0xd2c
 1bd:	6a 01                	push   $0x1
 1bf:	e8 4c 05 00 00       	call   710 <printf>
    break;
 1c4:	83 c4 20             	add    $0x20,%esp
 1c7:	eb 89                	jmp    152 <ls+0x52>
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1d0:	83 ec 0c             	sub    $0xc,%esp
 1d3:	57                   	push   %edi
 1d4:	e8 d7 01 00 00       	call   3b0 <strlen>
 1d9:	83 c0 10             	add    $0x10,%eax
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	3d 00 02 00 00       	cmp    $0x200,%eax
 1e4:	76 42                	jbe    228 <ls+0x128>
      printf(1, "ls: path too long\n");
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	68 39 0d 00 00       	push   $0xd39
 1ee:	6a 01                	push   $0x1
 1f0:	e8 1b 05 00 00       	call   710 <printf>
      break;
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	e9 55 ff ff ff       	jmp    152 <ls+0x52>
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot stat %s\n", path);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	57                   	push   %edi
 204:	68 18 0d 00 00       	push   $0xd18
 209:	6a 02                	push   $0x2
 20b:	e8 00 05 00 00       	call   710 <printf>
    close(fd);
 210:	89 1c 24             	mov    %ebx,(%esp)
 213:	e8 92 03 00 00       	call   5aa <close>
    return;
 218:	83 c4 10             	add    $0x10,%esp
}
 21b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5f                   	pop    %edi
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    
 223:	90                   	nop
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    strcpy(buf, path);
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	57                   	push   %edi
 22c:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 232:	57                   	push   %edi
 233:	e8 f8 00 00 00       	call   330 <strcpy>
    p = buf+strlen(buf);
 238:	89 3c 24             	mov    %edi,(%esp)
 23b:	e8 70 01 00 00       	call   3b0 <strlen>
 240:	01 f8                	add    %edi,%eax
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 242:	83 c4 10             	add    $0x10,%esp
    *p++ = '/';
 245:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 248:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 24e:	c6 00 2f             	movb   $0x2f,(%eax)
 251:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 260:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 266:	83 ec 04             	sub    $0x4,%esp
 269:	6a 10                	push   $0x10
 26b:	50                   	push   %eax
 26c:	53                   	push   %ebx
 26d:	e8 28 03 00 00       	call   59a <read>
 272:	83 c4 10             	add    $0x10,%esp
 275:	83 f8 10             	cmp    $0x10,%eax
 278:	0f 85 d4 fe ff ff    	jne    152 <ls+0x52>
      if(de.inum == 0)
 27e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 285:	00 
 286:	74 d8                	je     260 <ls+0x160>
      memmove(p, de.name, DIRSIZ);
 288:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 28e:	83 ec 04             	sub    $0x4,%esp
 291:	6a 0e                	push   $0xe
 293:	50                   	push   %eax
 294:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 29a:	e8 b1 02 00 00       	call   550 <memmove>
      p[DIRSIZ] = 0;
 29f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 2a5:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 2a9:	58                   	pop    %eax
 2aa:	5a                   	pop    %edx
 2ab:	56                   	push   %esi
 2ac:	57                   	push   %edi
 2ad:	e8 0e 02 00 00       	call   4c0 <stat>
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	85 c0                	test   %eax,%eax
 2b7:	78 5f                	js     318 <ls+0x218>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 2b9:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 2c0:	83 ec 0c             	sub    $0xc,%esp
 2c3:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 2c9:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 2cf:	57                   	push   %edi
 2d0:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 2d6:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 2dc:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 2e2:	e8 79 fd ff ff       	call   60 <fmtname>
 2e7:	5a                   	pop    %edx
 2e8:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 2ee:	59                   	pop    %ecx
 2ef:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 2f5:	51                   	push   %ecx
 2f6:	52                   	push   %edx
 2f7:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 2fd:	50                   	push   %eax
 2fe:	68 2c 0d 00 00       	push   $0xd2c
 303:	6a 01                	push   $0x1
 305:	e8 06 04 00 00       	call   710 <printf>
 30a:	83 c4 20             	add    $0x20,%esp
 30d:	e9 4e ff ff ff       	jmp    260 <ls+0x160>
 312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 318:	83 ec 04             	sub    $0x4,%esp
 31b:	57                   	push   %edi
 31c:	68 18 0d 00 00       	push   $0xd18
 321:	6a 01                	push   $0x1
 323:	e8 e8 03 00 00       	call   710 <printf>
        continue;
 328:	83 c4 10             	add    $0x10,%esp
 32b:	e9 30 ff ff ff       	jmp    260 <ls+0x160>

00000330 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 33a:	89 c2                	mov    %eax,%edx
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 340:	83 c1 01             	add    $0x1,%ecx
 343:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 347:	83 c2 01             	add    $0x1,%edx
 34a:	84 db                	test   %bl,%bl
 34c:	88 5a ff             	mov    %bl,-0x1(%edx)
 34f:	75 ef                	jne    340 <strcpy+0x10>
    ;
  return os;
}
 351:	5b                   	pop    %ebx
 352:	5d                   	pop    %ebp
 353:	c3                   	ret    
 354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 35a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
 367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 36a:	0f b6 02             	movzbl (%edx),%eax
 36d:	0f b6 19             	movzbl (%ecx),%ebx
 370:	84 c0                	test   %al,%al
 372:	75 1c                	jne    390 <strcmp+0x30>
 374:	eb 2a                	jmp    3a0 <strcmp+0x40>
 376:	8d 76 00             	lea    0x0(%esi),%esi
 379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 380:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 383:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 386:	83 c1 01             	add    $0x1,%ecx
 389:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 38c:	84 c0                	test   %al,%al
 38e:	74 10                	je     3a0 <strcmp+0x40>
 390:	38 d8                	cmp    %bl,%al
 392:	74 ec                	je     380 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 394:	29 d8                	sub    %ebx,%eax
}
 396:	5b                   	pop    %ebx
 397:	5d                   	pop    %ebp
 398:	c3                   	ret    
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3a2:	29 d8                	sub    %ebx,%eax
}
 3a4:	5b                   	pop    %ebx
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    
 3a7:	89 f6                	mov    %esi,%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <strlen>:

uint
strlen(const char *s)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3b6:	80 39 00             	cmpb   $0x0,(%ecx)
 3b9:	74 15                	je     3d0 <strlen+0x20>
 3bb:	31 d2                	xor    %edx,%edx
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	83 c2 01             	add    $0x1,%edx
 3c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3c7:	89 d0                	mov    %edx,%eax
 3c9:	75 f5                	jne    3c0 <strlen+0x10>
    ;
  return n;
}
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 3d0:	31 c0                	xor    %eax,%eax
}
 3d2:	5d                   	pop    %ebp
 3d3:	c3                   	ret    
 3d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 d7                	mov    %edx,%edi
 3ef:	fc                   	cld    
 3f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3f2:	89 d0                	mov    %edx,%eax
 3f4:	5f                   	pop    %edi
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret    
 3f7:	89 f6                	mov    %esi,%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <strchr>:

char*
strchr(const char *s, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	53                   	push   %ebx
 404:	8b 45 08             	mov    0x8(%ebp),%eax
 407:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 40a:	0f b6 10             	movzbl (%eax),%edx
 40d:	84 d2                	test   %dl,%dl
 40f:	74 1d                	je     42e <strchr+0x2e>
    if(*s == c)
 411:	38 d3                	cmp    %dl,%bl
 413:	89 d9                	mov    %ebx,%ecx
 415:	75 0d                	jne    424 <strchr+0x24>
 417:	eb 17                	jmp    430 <strchr+0x30>
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 420:	38 ca                	cmp    %cl,%dl
 422:	74 0c                	je     430 <strchr+0x30>
  for(; *s; s++)
 424:	83 c0 01             	add    $0x1,%eax
 427:	0f b6 10             	movzbl (%eax),%edx
 42a:	84 d2                	test   %dl,%dl
 42c:	75 f2                	jne    420 <strchr+0x20>
      return (char*)s;
  return 0;
 42e:	31 c0                	xor    %eax,%eax
}
 430:	5b                   	pop    %ebx
 431:	5d                   	pop    %ebp
 432:	c3                   	ret    
 433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <gets>:

char*
gets(char *buf, int max)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 446:	31 f6                	xor    %esi,%esi
 448:	89 f3                	mov    %esi,%ebx
{
 44a:	83 ec 1c             	sub    $0x1c,%esp
 44d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 450:	eb 2f                	jmp    481 <gets+0x41>
 452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 458:	8d 45 e7             	lea    -0x19(%ebp),%eax
 45b:	83 ec 04             	sub    $0x4,%esp
 45e:	6a 01                	push   $0x1
 460:	50                   	push   %eax
 461:	6a 00                	push   $0x0
 463:	e8 32 01 00 00       	call   59a <read>
    if(cc < 1)
 468:	83 c4 10             	add    $0x10,%esp
 46b:	85 c0                	test   %eax,%eax
 46d:	7e 1c                	jle    48b <gets+0x4b>
      break;
    buf[i++] = c;
 46f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 473:	83 c7 01             	add    $0x1,%edi
 476:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 479:	3c 0a                	cmp    $0xa,%al
 47b:	74 23                	je     4a0 <gets+0x60>
 47d:	3c 0d                	cmp    $0xd,%al
 47f:	74 1f                	je     4a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 481:	83 c3 01             	add    $0x1,%ebx
 484:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 487:	89 fe                	mov    %edi,%esi
 489:	7c cd                	jl     458 <gets+0x18>
 48b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 490:	c6 03 00             	movb   $0x0,(%ebx)
}
 493:	8d 65 f4             	lea    -0xc(%ebp),%esp
 496:	5b                   	pop    %ebx
 497:	5e                   	pop    %esi
 498:	5f                   	pop    %edi
 499:	5d                   	pop    %ebp
 49a:	c3                   	ret    
 49b:	90                   	nop
 49c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a0:	8b 75 08             	mov    0x8(%ebp),%esi
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	01 de                	add    %ebx,%esi
 4a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 4ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b0:	5b                   	pop    %ebx
 4b1:	5e                   	pop    %esi
 4b2:	5f                   	pop    %edi
 4b3:	5d                   	pop    %ebp
 4b4:	c3                   	ret    
 4b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c5:	83 ec 08             	sub    $0x8,%esp
 4c8:	6a 00                	push   $0x0
 4ca:	ff 75 08             	pushl  0x8(%ebp)
 4cd:	e8 f0 00 00 00       	call   5c2 <open>
  if(fd < 0)
 4d2:	83 c4 10             	add    $0x10,%esp
 4d5:	85 c0                	test   %eax,%eax
 4d7:	78 27                	js     500 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4d9:	83 ec 08             	sub    $0x8,%esp
 4dc:	ff 75 0c             	pushl  0xc(%ebp)
 4df:	89 c3                	mov    %eax,%ebx
 4e1:	50                   	push   %eax
 4e2:	e8 f3 00 00 00       	call   5da <fstat>
  close(fd);
 4e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ea:	89 c6                	mov    %eax,%esi
  close(fd);
 4ec:	e8 b9 00 00 00       	call   5aa <close>
  return r;
 4f1:	83 c4 10             	add    $0x10,%esp
}
 4f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4f7:	89 f0                	mov    %esi,%eax
 4f9:	5b                   	pop    %ebx
 4fa:	5e                   	pop    %esi
 4fb:	5d                   	pop    %ebp
 4fc:	c3                   	ret    
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 500:	be ff ff ff ff       	mov    $0xffffffff,%esi
 505:	eb ed                	jmp    4f4 <stat+0x34>
 507:	89 f6                	mov    %esi,%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000510 <atoi>:

int
atoi(const char *s)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	53                   	push   %ebx
 514:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 517:	0f be 11             	movsbl (%ecx),%edx
 51a:	8d 42 d0             	lea    -0x30(%edx),%eax
 51d:	3c 09                	cmp    $0x9,%al
  n = 0;
 51f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 524:	77 1f                	ja     545 <atoi+0x35>
 526:	8d 76 00             	lea    0x0(%esi),%esi
 529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 530:	8d 04 80             	lea    (%eax,%eax,4),%eax
 533:	83 c1 01             	add    $0x1,%ecx
 536:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 53a:	0f be 11             	movsbl (%ecx),%edx
 53d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 540:	80 fb 09             	cmp    $0x9,%bl
 543:	76 eb                	jbe    530 <atoi+0x20>
  return n;
}
 545:	5b                   	pop    %ebx
 546:	5d                   	pop    %ebp
 547:	c3                   	ret    
 548:	90                   	nop
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000550 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	56                   	push   %esi
 554:	53                   	push   %ebx
 555:	8b 5d 10             	mov    0x10(%ebp),%ebx
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 55e:	85 db                	test   %ebx,%ebx
 560:	7e 14                	jle    576 <memmove+0x26>
 562:	31 d2                	xor    %edx,%edx
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 568:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 56c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 56f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 572:	39 d3                	cmp    %edx,%ebx
 574:	75 f2                	jne    568 <memmove+0x18>
  return vdst;
}
 576:	5b                   	pop    %ebx
 577:	5e                   	pop    %esi
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    

0000057a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57a:	b8 01 00 00 00       	mov    $0x1,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <exit>:
SYSCALL(exit)
 582:	b8 02 00 00 00       	mov    $0x2,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <wait>:
SYSCALL(wait)
 58a:	b8 03 00 00 00       	mov    $0x3,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <pipe>:
SYSCALL(pipe)
 592:	b8 04 00 00 00       	mov    $0x4,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <read>:
SYSCALL(read)
 59a:	b8 05 00 00 00       	mov    $0x5,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <write>:
SYSCALL(write)
 5a2:	b8 10 00 00 00       	mov    $0x10,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <close>:
SYSCALL(close)
 5aa:	b8 15 00 00 00       	mov    $0x15,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <kill>:
SYSCALL(kill)
 5b2:	b8 06 00 00 00       	mov    $0x6,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <exec>:
SYSCALL(exec)
 5ba:	b8 07 00 00 00       	mov    $0x7,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <open>:
SYSCALL(open)
 5c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <mknod>:
SYSCALL(mknod)
 5ca:	b8 11 00 00 00       	mov    $0x11,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <unlink>:
SYSCALL(unlink)
 5d2:	b8 12 00 00 00       	mov    $0x12,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <fstat>:
SYSCALL(fstat)
 5da:	b8 08 00 00 00       	mov    $0x8,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <link>:
SYSCALL(link)
 5e2:	b8 13 00 00 00       	mov    $0x13,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <mkdir>:
SYSCALL(mkdir)
 5ea:	b8 14 00 00 00       	mov    $0x14,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <chdir>:
SYSCALL(chdir)
 5f2:	b8 09 00 00 00       	mov    $0x9,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <dup>:
SYSCALL(dup)
 5fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <getpid>:
SYSCALL(getpid)
 602:	b8 0b 00 00 00       	mov    $0xb,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <sbrk>:
SYSCALL(sbrk)
 60a:	b8 0c 00 00 00       	mov    $0xc,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <sleep>:
SYSCALL(sleep)
 612:	b8 0d 00 00 00       	mov    $0xd,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <uptime>:
SYSCALL(uptime)
 61a:	b8 0e 00 00 00       	mov    $0xe,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <kthread_create>:
//kthread
SYSCALL(kthread_create)
 622:	b8 16 00 00 00       	mov    $0x16,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <kthread_id>:
SYSCALL(kthread_id)
 62a:	b8 17 00 00 00       	mov    $0x17,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <kthread_exit>:
SYSCALL(kthread_exit)
 632:	b8 18 00 00 00       	mov    $0x18,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <kthread_join>:
SYSCALL(kthread_join)
 63a:	b8 19 00 00 00       	mov    $0x19,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <kthread_mutex_alloc>:

//kthread_mutex
SYSCALL(kthread_mutex_alloc)
 642:	b8 1a 00 00 00       	mov    $0x1a,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <kthread_mutex_dealloc>:
SYSCALL(kthread_mutex_dealloc)
 64a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <kthread_mutex_lock>:
SYSCALL(kthread_mutex_lock)
 652:	b8 1c 00 00 00       	mov    $0x1c,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <kthread_mutex_unlock>:
SYSCALL(kthread_mutex_unlock)
 65a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <safe_tree_dealloc>:
SYSCALL(safe_tree_dealloc)
 662:	b8 1e 00 00 00       	mov    $0x1e,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 679:	85 d2                	test   %edx,%edx
{
 67b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 67e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 680:	79 76                	jns    6f8 <printint+0x88>
 682:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 686:	74 70                	je     6f8 <printint+0x88>
    x = -xx;
 688:	f7 d8                	neg    %eax
    neg = 1;
 68a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 691:	31 f6                	xor    %esi,%esi
 693:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 696:	eb 0a                	jmp    6a2 <printint+0x32>
 698:	90                   	nop
 699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 6a0:	89 fe                	mov    %edi,%esi
 6a2:	31 d2                	xor    %edx,%edx
 6a4:	8d 7e 01             	lea    0x1(%esi),%edi
 6a7:	f7 f1                	div    %ecx
 6a9:	0f b6 92 58 0d 00 00 	movzbl 0xd58(%edx),%edx
  }while((x /= base) != 0);
 6b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 6b2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 6b5:	75 e9                	jne    6a0 <printint+0x30>
  if(neg)
 6b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6ba:	85 c0                	test   %eax,%eax
 6bc:	74 08                	je     6c6 <printint+0x56>
    buf[i++] = '-';
 6be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 6c3:	8d 7e 02             	lea    0x2(%esi),%edi
 6c6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 6ca:	8b 7d c0             	mov    -0x40(%ebp),%edi
 6cd:	8d 76 00             	lea    0x0(%esi),%esi
 6d0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 6d3:	83 ec 04             	sub    $0x4,%esp
 6d6:	83 ee 01             	sub    $0x1,%esi
 6d9:	6a 01                	push   $0x1
 6db:	53                   	push   %ebx
 6dc:	57                   	push   %edi
 6dd:	88 45 d7             	mov    %al,-0x29(%ebp)
 6e0:	e8 bd fe ff ff       	call   5a2 <write>

  while(--i >= 0)
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	39 de                	cmp    %ebx,%esi
 6ea:	75 e4                	jne    6d0 <printint+0x60>
    putc(fd, buf[i]);
}
 6ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ef:	5b                   	pop    %ebx
 6f0:	5e                   	pop    %esi
 6f1:	5f                   	pop    %edi
 6f2:	5d                   	pop    %ebp
 6f3:	c3                   	ret    
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6f8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6ff:	eb 90                	jmp    691 <printint+0x21>
 701:	eb 0d                	jmp    710 <printf>
 703:	90                   	nop
 704:	90                   	nop
 705:	90                   	nop
 706:	90                   	nop
 707:	90                   	nop
 708:	90                   	nop
 709:	90                   	nop
 70a:	90                   	nop
 70b:	90                   	nop
 70c:	90                   	nop
 70d:	90                   	nop
 70e:	90                   	nop
 70f:	90                   	nop

00000710 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 719:	8b 75 0c             	mov    0xc(%ebp),%esi
 71c:	0f b6 1e             	movzbl (%esi),%ebx
 71f:	84 db                	test   %bl,%bl
 721:	0f 84 b3 00 00 00    	je     7da <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 727:	8d 45 10             	lea    0x10(%ebp),%eax
 72a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 72d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 72f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 732:	eb 2f                	jmp    763 <printf+0x53>
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 738:	83 f8 25             	cmp    $0x25,%eax
 73b:	0f 84 a7 00 00 00    	je     7e8 <printf+0xd8>
  write(fd, &c, 1);
 741:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 744:	83 ec 04             	sub    $0x4,%esp
 747:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 74a:	6a 01                	push   $0x1
 74c:	50                   	push   %eax
 74d:	ff 75 08             	pushl  0x8(%ebp)
 750:	e8 4d fe ff ff       	call   5a2 <write>
 755:	83 c4 10             	add    $0x10,%esp
 758:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 75b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 75f:	84 db                	test   %bl,%bl
 761:	74 77                	je     7da <printf+0xca>
    if(state == 0){
 763:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 765:	0f be cb             	movsbl %bl,%ecx
 768:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 76b:	74 cb                	je     738 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 76d:	83 ff 25             	cmp    $0x25,%edi
 770:	75 e6                	jne    758 <printf+0x48>
      if(c == 'd'){
 772:	83 f8 64             	cmp    $0x64,%eax
 775:	0f 84 05 01 00 00    	je     880 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 77b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 781:	83 f9 70             	cmp    $0x70,%ecx
 784:	74 72                	je     7f8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 786:	83 f8 73             	cmp    $0x73,%eax
 789:	0f 84 99 00 00 00    	je     828 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78f:	83 f8 63             	cmp    $0x63,%eax
 792:	0f 84 08 01 00 00    	je     8a0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 798:	83 f8 25             	cmp    $0x25,%eax
 79b:	0f 84 ef 00 00 00    	je     890 <printf+0x180>
  write(fd, &c, 1);
 7a1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7a4:	83 ec 04             	sub    $0x4,%esp
 7a7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7ab:	6a 01                	push   $0x1
 7ad:	50                   	push   %eax
 7ae:	ff 75 08             	pushl  0x8(%ebp)
 7b1:	e8 ec fd ff ff       	call   5a2 <write>
 7b6:	83 c4 0c             	add    $0xc,%esp
 7b9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7bc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7bf:	6a 01                	push   $0x1
 7c1:	50                   	push   %eax
 7c2:	ff 75 08             	pushl  0x8(%ebp)
 7c5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7c8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 7ca:	e8 d3 fd ff ff       	call   5a2 <write>
  for(i = 0; fmt[i]; i++){
 7cf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 7d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7d6:	84 db                	test   %bl,%bl
 7d8:	75 89                	jne    763 <printf+0x53>
    }
  }
}
 7da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7dd:	5b                   	pop    %ebx
 7de:	5e                   	pop    %esi
 7df:	5f                   	pop    %edi
 7e0:	5d                   	pop    %ebp
 7e1:	c3                   	ret    
 7e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 7e8:	bf 25 00 00 00       	mov    $0x25,%edi
 7ed:	e9 66 ff ff ff       	jmp    758 <printf+0x48>
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7f8:	83 ec 0c             	sub    $0xc,%esp
 7fb:	b9 10 00 00 00       	mov    $0x10,%ecx
 800:	6a 00                	push   $0x0
 802:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 805:	8b 45 08             	mov    0x8(%ebp),%eax
 808:	8b 17                	mov    (%edi),%edx
 80a:	e8 61 fe ff ff       	call   670 <printint>
        ap++;
 80f:	89 f8                	mov    %edi,%eax
 811:	83 c4 10             	add    $0x10,%esp
      state = 0;
 814:	31 ff                	xor    %edi,%edi
        ap++;
 816:	83 c0 04             	add    $0x4,%eax
 819:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 81c:	e9 37 ff ff ff       	jmp    758 <printf+0x48>
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 828:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 82b:	8b 08                	mov    (%eax),%ecx
        ap++;
 82d:	83 c0 04             	add    $0x4,%eax
 830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 833:	85 c9                	test   %ecx,%ecx
 835:	0f 84 8e 00 00 00    	je     8c9 <printf+0x1b9>
        while(*s != 0){
 83b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 83e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 840:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 842:	84 c0                	test   %al,%al
 844:	0f 84 0e ff ff ff    	je     758 <printf+0x48>
 84a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 84d:	89 de                	mov    %ebx,%esi
 84f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 852:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 855:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 858:	83 ec 04             	sub    $0x4,%esp
          s++;
 85b:	83 c6 01             	add    $0x1,%esi
 85e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 861:	6a 01                	push   $0x1
 863:	57                   	push   %edi
 864:	53                   	push   %ebx
 865:	e8 38 fd ff ff       	call   5a2 <write>
        while(*s != 0){
 86a:	0f b6 06             	movzbl (%esi),%eax
 86d:	83 c4 10             	add    $0x10,%esp
 870:	84 c0                	test   %al,%al
 872:	75 e4                	jne    858 <printf+0x148>
 874:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 877:	31 ff                	xor    %edi,%edi
 879:	e9 da fe ff ff       	jmp    758 <printf+0x48>
 87e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	b9 0a 00 00 00       	mov    $0xa,%ecx
 888:	6a 01                	push   $0x1
 88a:	e9 73 ff ff ff       	jmp    802 <printf+0xf2>
 88f:	90                   	nop
  write(fd, &c, 1);
 890:	83 ec 04             	sub    $0x4,%esp
 893:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 896:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 899:	6a 01                	push   $0x1
 89b:	e9 21 ff ff ff       	jmp    7c1 <printf+0xb1>
        putc(fd, *ap);
 8a0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 8a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8a6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 8a8:	6a 01                	push   $0x1
        ap++;
 8aa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 8ad:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 8b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8b3:	50                   	push   %eax
 8b4:	ff 75 08             	pushl  0x8(%ebp)
 8b7:	e8 e6 fc ff ff       	call   5a2 <write>
        ap++;
 8bc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 8bf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8c2:	31 ff                	xor    %edi,%edi
 8c4:	e9 8f fe ff ff       	jmp    758 <printf+0x48>
          s = "(null)";
 8c9:	bb 4e 0d 00 00       	mov    $0xd4e,%ebx
        while(*s != 0){
 8ce:	b8 28 00 00 00       	mov    $0x28,%eax
 8d3:	e9 72 ff ff ff       	jmp    84a <printf+0x13a>
 8d8:	66 90                	xchg   %ax,%ax
 8da:	66 90                	xchg   %ax,%ax
 8dc:	66 90                	xchg   %ax,%ax
 8de:	66 90                	xchg   %ax,%ax

000008e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e1:	a1 d0 11 00 00       	mov    0x11d0,%eax
{
 8e6:	89 e5                	mov    %esp,%ebp
 8e8:	57                   	push   %edi
 8e9:	56                   	push   %esi
 8ea:	53                   	push   %ebx
 8eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 8f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f8:	39 c8                	cmp    %ecx,%eax
 8fa:	8b 10                	mov    (%eax),%edx
 8fc:	73 32                	jae    930 <free+0x50>
 8fe:	39 d1                	cmp    %edx,%ecx
 900:	72 04                	jb     906 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 902:	39 d0                	cmp    %edx,%eax
 904:	72 32                	jb     938 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 906:	8b 73 fc             	mov    -0x4(%ebx),%esi
 909:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 90c:	39 fa                	cmp    %edi,%edx
 90e:	74 30                	je     940 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 910:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 913:	8b 50 04             	mov    0x4(%eax),%edx
 916:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 919:	39 f1                	cmp    %esi,%ecx
 91b:	74 3a                	je     957 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 91d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 91f:	a3 d0 11 00 00       	mov    %eax,0x11d0
}
 924:	5b                   	pop    %ebx
 925:	5e                   	pop    %esi
 926:	5f                   	pop    %edi
 927:	5d                   	pop    %ebp
 928:	c3                   	ret    
 929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 930:	39 d0                	cmp    %edx,%eax
 932:	72 04                	jb     938 <free+0x58>
 934:	39 d1                	cmp    %edx,%ecx
 936:	72 ce                	jb     906 <free+0x26>
{
 938:	89 d0                	mov    %edx,%eax
 93a:	eb bc                	jmp    8f8 <free+0x18>
 93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 940:	03 72 04             	add    0x4(%edx),%esi
 943:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	8b 10                	mov    (%eax),%edx
 948:	8b 12                	mov    (%edx),%edx
 94a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 94d:	8b 50 04             	mov    0x4(%eax),%edx
 950:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 953:	39 f1                	cmp    %esi,%ecx
 955:	75 c6                	jne    91d <free+0x3d>
    p->s.size += bp->s.size;
 957:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 95a:	a3 d0 11 00 00       	mov    %eax,0x11d0
    p->s.size += bp->s.size;
 95f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 962:	8b 53 f8             	mov    -0x8(%ebx),%edx
 965:	89 10                	mov    %edx,(%eax)
}
 967:	5b                   	pop    %ebx
 968:	5e                   	pop    %esi
 969:	5f                   	pop    %edi
 96a:	5d                   	pop    %ebp
 96b:	c3                   	ret    
 96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000970 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
 973:	57                   	push   %edi
 974:	56                   	push   %esi
 975:	53                   	push   %ebx
 976:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 979:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 97c:	8b 15 d0 11 00 00    	mov    0x11d0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 982:	8d 78 07             	lea    0x7(%eax),%edi
 985:	c1 ef 03             	shr    $0x3,%edi
 988:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 98b:	85 d2                	test   %edx,%edx
 98d:	0f 84 9d 00 00 00    	je     a30 <malloc+0xc0>
 993:	8b 02                	mov    (%edx),%eax
 995:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 998:	39 cf                	cmp    %ecx,%edi
 99a:	76 6c                	jbe    a08 <malloc+0x98>
 99c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9a2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9a7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 9aa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9b1:	eb 0e                	jmp    9c1 <malloc+0x51>
 9b3:	90                   	nop
 9b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9ba:	8b 48 04             	mov    0x4(%eax),%ecx
 9bd:	39 f9                	cmp    %edi,%ecx
 9bf:	73 47                	jae    a08 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c1:	39 05 d0 11 00 00    	cmp    %eax,0x11d0
 9c7:	89 c2                	mov    %eax,%edx
 9c9:	75 ed                	jne    9b8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 9cb:	83 ec 0c             	sub    $0xc,%esp
 9ce:	56                   	push   %esi
 9cf:	e8 36 fc ff ff       	call   60a <sbrk>
  if(p == (char*)-1)
 9d4:	83 c4 10             	add    $0x10,%esp
 9d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9da:	74 1c                	je     9f8 <malloc+0x88>
  hp->s.size = nu;
 9dc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9df:	83 ec 0c             	sub    $0xc,%esp
 9e2:	83 c0 08             	add    $0x8,%eax
 9e5:	50                   	push   %eax
 9e6:	e8 f5 fe ff ff       	call   8e0 <free>
  return freep;
 9eb:	8b 15 d0 11 00 00    	mov    0x11d0,%edx
      if((p = morecore(nunits)) == 0)
 9f1:	83 c4 10             	add    $0x10,%esp
 9f4:	85 d2                	test   %edx,%edx
 9f6:	75 c0                	jne    9b8 <malloc+0x48>
        return 0;
  }
}
 9f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9fb:	31 c0                	xor    %eax,%eax
}
 9fd:	5b                   	pop    %ebx
 9fe:	5e                   	pop    %esi
 9ff:	5f                   	pop    %edi
 a00:	5d                   	pop    %ebp
 a01:	c3                   	ret    
 a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a08:	39 cf                	cmp    %ecx,%edi
 a0a:	74 54                	je     a60 <malloc+0xf0>
        p->s.size -= nunits;
 a0c:	29 f9                	sub    %edi,%ecx
 a0e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a11:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a14:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a17:	89 15 d0 11 00 00    	mov    %edx,0x11d0
}
 a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a20:	83 c0 08             	add    $0x8,%eax
}
 a23:	5b                   	pop    %ebx
 a24:	5e                   	pop    %esi
 a25:	5f                   	pop    %edi
 a26:	5d                   	pop    %ebp
 a27:	c3                   	ret    
 a28:	90                   	nop
 a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 a30:	c7 05 d0 11 00 00 d4 	movl   $0x11d4,0x11d0
 a37:	11 00 00 
 a3a:	c7 05 d4 11 00 00 d4 	movl   $0x11d4,0x11d4
 a41:	11 00 00 
    base.s.size = 0;
 a44:	b8 d4 11 00 00       	mov    $0x11d4,%eax
 a49:	c7 05 d8 11 00 00 00 	movl   $0x0,0x11d8
 a50:	00 00 00 
 a53:	e9 44 ff ff ff       	jmp    99c <malloc+0x2c>
 a58:	90                   	nop
 a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 a60:	8b 08                	mov    (%eax),%ecx
 a62:	89 0a                	mov    %ecx,(%edx)
 a64:	eb b1                	jmp    a17 <malloc+0xa7>
 a66:	66 90                	xchg   %ax,%ax
 a68:	66 90                	xchg   %ax,%ax
 a6a:	66 90                	xchg   %ax,%ax
 a6c:	66 90                	xchg   %ax,%ax
 a6e:	66 90                	xchg   %ax,%ax

00000a70 <ourpower.part.0>:
struct {
    //struct spinlock lock;
    trnmnt_tree trnmnt_tree[NPROC];
} treetable;

int ourpower(int num) {
 a70:	55                   	push   %ebp
    if (num < 0) {
        //cprintf("Illegal input: for a^b: a= %d, b= %d \n", a, b);
        return -1;
    }
    int output = 1;
    for (int i = 0; i < num; i++)
 a71:	85 c0                	test   %eax,%eax
int ourpower(int num) {
 a73:	89 e5                	mov    %esp,%ebp
    for (int i = 0; i < num; i++)
 a75:	7e 19                	jle    a90 <ourpower.part.0+0x20>
 a77:	31 d2                	xor    %edx,%edx
    int output = 1;
 a79:	b9 01 00 00 00       	mov    $0x1,%ecx
 a7e:	66 90                	xchg   %ax,%ax
    for (int i = 0; i < num; i++)
 a80:	83 c2 01             	add    $0x1,%edx
        output *= 2;
 a83:	01 c9                	add    %ecx,%ecx
    for (int i = 0; i < num; i++)
 a85:	39 c2                	cmp    %eax,%edx
 a87:	75 f7                	jne    a80 <ourpower.part.0+0x10>
    return output;
}
 a89:	89 c8                	mov    %ecx,%eax
 a8b:	5d                   	pop    %ebp
 a8c:	c3                   	ret    
 a8d:	8d 76 00             	lea    0x0(%esi),%esi
    int output = 1;
 a90:	b9 01 00 00 00       	mov    $0x1,%ecx
}
 a95:	89 c8                	mov    %ecx,%eax
 a97:	5d                   	pop    %ebp
 a98:	c3                   	ret    
 a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000aa0 <ourpower>:
int ourpower(int num) {
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	8b 45 08             	mov    0x8(%ebp),%eax
    if (num < 0) {
 aa6:	85 c0                	test   %eax,%eax
 aa8:	78 03                	js     aad <ourpower+0xd>
}
 aaa:	5d                   	pop    %ebp
 aab:	eb c3                	jmp    a70 <ourpower.part.0>
 aad:	83 c8 ff             	or     $0xffffffff,%eax
 ab0:	5d                   	pop    %ebp
 ab1:	c3                   	ret    
 ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ac0 <trnmnt_tree_alloc>:

struct trnmnt_tree*
trnmnt_tree_alloc(int depth){
 ac0:	55                   	push   %ebp
 ac1:	89 e5                	mov    %esp,%ebp
 ac3:	57                   	push   %edi
 ac4:	56                   	push   %esi
 ac5:	53                   	push   %ebx
    trnmnt_tree *t;

    for (t = treetable.trnmnt_tree ; t < &treetable.trnmnt_tree[NPROC] ; t++) {
 ac6:	bb e0 11 00 00       	mov    $0x11e0,%ebx
trnmnt_tree_alloc(int depth){
 acb:	83 ec 0c             	sub    $0xc,%esp
 ace:	8b 45 08             	mov    0x8(%ebp),%eax
 ad1:	eb 13                	jmp    ae6 <trnmnt_tree_alloc+0x26>
 ad3:	90                   	nop
 ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (t = treetable.trnmnt_tree ; t < &treetable.trnmnt_tree[NPROC] ; t++) {
 ad8:	81 c3 08 01 00 00    	add    $0x108,%ebx
 ade:	81 fb e0 53 00 00    	cmp    $0x53e0,%ebx
 ae4:	73 42                	jae    b28 <trnmnt_tree_alloc+0x68>
        if (t->active == INACTIVE)
 ae6:	8b 13                	mov    (%ebx),%edx
 ae8:	85 d2                	test   %edx,%edx
 aea:	75 ec                	jne    ad8 <trnmnt_tree_alloc+0x18>
    if (num < 0) {
 aec:	85 c0                	test   %eax,%eax
            goto found_tree;
    }
    return 0;

    found_tree:
    t->active = ACTIVE;
 aee:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    t->depth = depth;
 af4:	89 43 04             	mov    %eax,0x4(%ebx)
    if (num < 0) {
 af7:	78 1f                	js     b18 <trnmnt_tree_alloc+0x58>
 af9:	e8 72 ff ff ff       	call   a70 <ourpower.part.0>

    for(int i=0; i<(ourpower(depth)-1); i++)
 afe:	31 f6                	xor    %esi,%esi
 b00:	8d 78 ff             	lea    -0x1(%eax),%edi
 b03:	eb 0f                	jmp    b14 <trnmnt_tree_alloc+0x54>
 b05:	8d 76 00             	lea    0x0(%esi),%esi
        t->trnmntMutex[i] = kthread_mutex_alloc();
 b08:	e8 35 fb ff ff       	call   642 <kthread_mutex_alloc>
 b0d:	89 44 b3 08          	mov    %eax,0x8(%ebx,%esi,4)
    for(int i=0; i<(ourpower(depth)-1); i++)
 b11:	83 c6 01             	add    $0x1,%esi
 b14:	39 f7                	cmp    %esi,%edi
 b16:	7f f0                	jg     b08 <trnmnt_tree_alloc+0x48>

    return t;
}
 b18:	83 c4 0c             	add    $0xc,%esp
 b1b:	89 d8                	mov    %ebx,%eax
 b1d:	5b                   	pop    %ebx
 b1e:	5e                   	pop    %esi
 b1f:	5f                   	pop    %edi
 b20:	5d                   	pop    %ebp
 b21:	c3                   	ret    
 b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 b28:	83 c4 0c             	add    $0xc,%esp
    return 0;
 b2b:	31 db                	xor    %ebx,%ebx
}
 b2d:	89 d8                	mov    %ebx,%eax
 b2f:	5b                   	pop    %ebx
 b30:	5e                   	pop    %esi
 b31:	5f                   	pop    %edi
 b32:	5d                   	pop    %ebp
 b33:	c3                   	ret    
 b34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 b3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000b40 <trnmnt_tree_dealloc>:

int
trnmnt_tree_dealloc(trnmnt_tree* tree){
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	57                   	push   %edi
 b44:	56                   	push   %esi
 b45:	53                   	push   %ebx
 b46:	83 ec 0c             	sub    $0xc,%esp
 b49:	8b 75 08             	mov    0x8(%ebp),%esi
    if(tree->active == INACTIVE )
 b4c:	8b 06                	mov    (%esi),%eax
 b4e:	85 c0                	test   %eax,%eax
 b50:	74 56                	je     ba8 <trnmnt_tree_dealloc+0x68>
        return -1;



    for(int j=0; j<(ourpower(tree->depth)-1); j++){
 b52:	31 ff                	xor    %edi,%edi
 b54:	eb 2e                	jmp    b84 <trnmnt_tree_dealloc+0x44>
 b56:	8d 76 00             	lea    0x0(%esi),%esi
 b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 b60:	89 d8                	mov    %ebx,%eax
 b62:	e8 09 ff ff ff       	call   a70 <ourpower.part.0>
 b67:	83 e8 01             	sub    $0x1,%eax
 b6a:	39 c7                	cmp    %eax,%edi
 b6c:	7d 47                	jge    bb5 <trnmnt_tree_dealloc+0x75>
        if(safe_tree_dealloc(tree->trnmntMutex[j]) == 0 )
 b6e:	83 ec 0c             	sub    $0xc,%esp
 b71:	ff 74 be 08          	pushl  0x8(%esi,%edi,4)
 b75:	e8 e8 fa ff ff       	call   662 <safe_tree_dealloc>
 b7a:	83 c4 10             	add    $0x10,%esp
 b7d:	85 c0                	test   %eax,%eax
 b7f:	74 27                	je     ba8 <trnmnt_tree_dealloc+0x68>
    for(int j=0; j<(ourpower(tree->depth)-1); j++){
 b81:	83 c7 01             	add    $0x1,%edi
 b84:	8b 5e 04             	mov    0x4(%esi),%ebx
    if (num < 0) {
 b87:	85 db                	test   %ebx,%ebx
 b89:	79 d5                	jns    b60 <trnmnt_tree_dealloc+0x20>
            //printf(1," WERE ARE FUCKED %d  \n" , i);
            return -1;
        }
    }

    tree->depth=0;
 b8b:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    tree->active = INACTIVE;
 b92:	c7 06 00 00 00 00    	movl   $0x0,(%esi)

    return 0;
}
 b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
 b9b:	31 c0                	xor    %eax,%eax
}
 b9d:	5b                   	pop    %ebx
 b9e:	5e                   	pop    %esi
 b9f:	5f                   	pop    %edi
 ba0:	5d                   	pop    %ebp
 ba1:	c3                   	ret    
 ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
 bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 bb0:	5b                   	pop    %ebx
 bb1:	5e                   	pop    %esi
 bb2:	5f                   	pop    %edi
 bb3:	5d                   	pop    %ebp
 bb4:	c3                   	ret    
    for(int i=0; i<(ourpower(tree->depth)-1); i++){
 bb5:	31 ff                	xor    %edi,%edi
 bb7:	89 f6                	mov    %esi,%esi
 bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 bc0:	89 d8                	mov    %ebx,%eax
 bc2:	e8 a9 fe ff ff       	call   a70 <ourpower.part.0>
 bc7:	83 e8 01             	sub    $0x1,%eax
 bca:	39 f8                	cmp    %edi,%eax
 bcc:	7e bd                	jle    b8b <trnmnt_tree_dealloc+0x4b>
        if(kthread_mutex_dealloc(tree->trnmntMutex[i]) == -1 ){
 bce:	83 ec 0c             	sub    $0xc,%esp
 bd1:	ff 74 be 08          	pushl  0x8(%esi,%edi,4)
 bd5:	e8 70 fa ff ff       	call   64a <kthread_mutex_dealloc>
 bda:	83 c4 10             	add    $0x10,%esp
 bdd:	83 f8 ff             	cmp    $0xffffffff,%eax
 be0:	74 c6                	je     ba8 <trnmnt_tree_dealloc+0x68>
    for(int i=0; i<(ourpower(tree->depth)-1); i++){
 be2:	8b 5e 04             	mov    0x4(%esi),%ebx
 be5:	83 c7 01             	add    $0x1,%edi
    if (num < 0) {
 be8:	85 db                	test   %ebx,%ebx
 bea:	79 d4                	jns    bc0 <trnmnt_tree_dealloc+0x80>
 bec:	eb 9d                	jmp    b8b <trnmnt_tree_dealloc+0x4b>
 bee:	66 90                	xchg   %ax,%ax

00000bf0 <trnmnt_tree_acquire>:

int
trnmnt_tree_acquire(trnmnt_tree* tree,int ID){
 bf0:	55                   	push   %ebp
 bf1:	89 e5                	mov    %esp,%ebp
 bf3:	57                   	push   %edi
 bf4:	56                   	push   %esi
 bf5:	53                   	push   %ebx
 bf6:	83 ec 1c             	sub    $0x1c,%esp
 bf9:	8b 75 08             	mov    0x8(%ebp),%esi
 bfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    int x=0, localID=ID;
    for(int lvl=1; lvl<=tree->depth; lvl++){
 bff:	8b 46 04             	mov    0x4(%esi),%eax
 c02:	85 c0                	test   %eax,%eax
 c04:	7e 62                	jle    c68 <trnmnt_tree_acquire+0x78>
 c06:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    int x=0, localID=ID;
 c0d:	31 ff                	xor    %edi,%edi
 c0f:	90                   	nop
        localID= localID/2;     //wich lock try to lock in current level
 c10:	89 d8                	mov    %ebx,%eax
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
 c12:	83 ec 0c             	sub    $0xc,%esp
        localID= localID/2;     //wich lock try to lock in current level
 c15:	c1 e8 1f             	shr    $0x1f,%eax
 c18:	01 c3                	add    %eax,%ebx
 c1a:	d1 fb                	sar    %ebx
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
 c1c:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
 c1f:	ff 74 86 08          	pushl  0x8(%esi,%eax,4)
 c23:	e8 2a fa ff ff       	call   652 <kthread_mutex_lock>
 c28:	83 c4 10             	add    $0x10,%esp
 c2b:	83 f8 ff             	cmp    $0xffffffff,%eax
 c2e:	74 3a                	je     c6a <trnmnt_tree_acquire+0x7a>
            return -1; //lock ->if not succeed sleep (in mutex implementation)
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 c30:	8b 4e 04             	mov    0x4(%esi),%ecx
    if (num < 0) {
 c33:	85 c9                	test   %ecx,%ecx
 c35:	78 31                	js     c68 <trnmnt_tree_acquire+0x78>
 c37:	89 c8                	mov    %ecx,%eax
 c39:	89 4d dc             	mov    %ecx,-0x24(%ebp)
 c3c:	e8 2f fe ff ff       	call   a70 <ourpower.part.0>
 c41:	89 45 e0             	mov    %eax,-0x20(%ebp)
 c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c47:	e8 24 fe ff ff       	call   a70 <ourpower.part.0>
 c4c:	89 c1                	mov    %eax,%ecx
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 c4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
    for(int lvl=1; lvl<=tree->depth; lvl++){
 c51:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 c55:	99                   	cltd   
 c56:	f7 f9                	idiv   %ecx
    for(int lvl=1; lvl<=tree->depth; lvl++){
 c58:	8b 4d dc             	mov    -0x24(%ebp),%ecx
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
 c5b:	01 c7                	add    %eax,%edi
    for(int lvl=1; lvl<=tree->depth; lvl++){
 c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c60:	39 c1                	cmp    %eax,%ecx
 c62:	7d ac                	jge    c10 <trnmnt_tree_acquire+0x20>
 c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    return 0;
 c68:	31 c0                	xor    %eax,%eax
}
 c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c6d:	5b                   	pop    %ebx
 c6e:	5e                   	pop    %esi
 c6f:	5f                   	pop    %edi
 c70:	5d                   	pop    %ebp
 c71:	c3                   	ret    
 c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c80 <trnmnt_tree_release>:

int
trnmnt_tree_release(trnmnt_tree* tree,int ID){
 c80:	55                   	push   %ebp
 c81:	89 e5                	mov    %esp,%ebp
 c83:	57                   	push   %edi
 c84:	56                   	push   %esi
 c85:	53                   	push   %ebx
 c86:	83 ec 0c             	sub    $0xc,%esp
 c89:	8b 7d 08             	mov    0x8(%ebp),%edi
    int x=ourpower(tree->depth)-2, localID;
 c8c:	8b 5f 04             	mov    0x4(%edi),%ebx
    if (num < 0) {
 c8f:	85 db                	test   %ebx,%ebx
 c91:	78 65                	js     cf8 <trnmnt_tree_release+0x78>
 c93:	89 d8                	mov    %ebx,%eax
 c95:	e8 d6 fd ff ff       	call   a70 <ourpower.part.0>
    for(int lvl=tree->depth; lvl>=1; lvl--){
 c9a:	85 db                	test   %ebx,%ebx
 c9c:	8d 70 fe             	lea    -0x2(%eax),%esi
 c9f:	7f 24                	jg     cc5 <trnmnt_tree_release+0x45>
 ca1:	eb 55                	jmp    cf8 <trnmnt_tree_release+0x78>
 ca3:	90                   	nop
 ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //unlock ->if not curthead holds this lock -> return -1 (in mutex implementation)
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 ca8:	8b 57 04             	mov    0x4(%edi),%edx
        return -1;
 cab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 cb0:	29 da                	sub    %ebx,%edx
    if (num < 0) {
 cb2:	83 c2 01             	add    $0x1,%edx
 cb5:	78 07                	js     cbe <trnmnt_tree_release+0x3e>
 cb7:	89 d0                	mov    %edx,%eax
 cb9:	e8 b2 fd ff ff       	call   a70 <ourpower.part.0>
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
 cbe:	29 c6                	sub    %eax,%esi
    for(int lvl=tree->depth; lvl>=1; lvl--){
 cc0:	83 eb 01             	sub    $0x1,%ebx
 cc3:	74 33                	je     cf8 <trnmnt_tree_release+0x78>
 cc5:	89 d8                	mov    %ebx,%eax
 cc7:	e8 a4 fd ff ff       	call   a70 <ourpower.part.0>
 ccc:	89 c1                	mov    %eax,%ecx
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
 cce:	8b 45 0c             	mov    0xc(%ebp),%eax
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
 cd1:	83 ec 0c             	sub    $0xc,%esp
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
 cd4:	99                   	cltd   
 cd5:	f7 f9                	idiv   %ecx
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
 cd7:	01 f0                	add    %esi,%eax
 cd9:	ff 74 87 08          	pushl  0x8(%edi,%eax,4)
 cdd:	e8 78 f9 ff ff       	call   65a <kthread_mutex_unlock>
 ce2:	83 c4 10             	add    $0x10,%esp
 ce5:	83 f8 ff             	cmp    $0xffffffff,%eax
 ce8:	75 be                	jne    ca8 <trnmnt_tree_release+0x28>
    }
    return 0;
}
 cea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 ced:	5b                   	pop    %ebx
 cee:	5e                   	pop    %esi
 cef:	5f                   	pop    %edi
 cf0:	5d                   	pop    %ebp
 cf1:	c3                   	ret    
 cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
 cfb:	31 c0                	xor    %eax,%eax
}
 cfd:	5b                   	pop    %ebx
 cfe:	5e                   	pop    %esi
 cff:	5f                   	pop    %edi
 d00:	5d                   	pop    %ebp
 d01:	c3                   	ret    
