
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return randstate;
}

int
main(int argc, char *argv[])
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
      11:	68 47 4e 00 00       	push   $0x4e47
      16:	6a 01                	push   $0x1
      18:	e8 53 3a 00 00       	call   3a70 <printf>

  if(open("usertests.ran", 0) >= 0){
      1d:	59                   	pop    %ecx
      1e:	58                   	pop    %eax
      1f:	6a 00                	push   $0x0
      21:	68 5b 4e 00 00       	push   $0x4e5b
      26:	e8 17 39 00 00       	call   3942 <open>
      2b:	83 c4 10             	add    $0x10,%esp
      2e:	85 c0                	test   %eax,%eax
      30:	78 13                	js     45 <main+0x45>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      32:	52                   	push   %edx
      33:	52                   	push   %edx
      34:	68 c4 55 00 00       	push   $0x55c4
      39:	6a 01                	push   $0x1
      3b:	e8 30 3a 00 00       	call   3a70 <printf>
    exit();
      40:	e8 bd 38 00 00       	call   3902 <exit>
  }
  close(open("usertests.ran", O_CREATE));
      45:	50                   	push   %eax
      46:	50                   	push   %eax
      47:	68 00 02 00 00       	push   $0x200
      4c:	68 5b 4e 00 00       	push   $0x4e5b
      51:	e8 ec 38 00 00       	call   3942 <open>
      56:	89 04 24             	mov    %eax,(%esp)
      59:	e8 cc 38 00 00       	call   392a <close>

  argptest();
      5e:	e8 bd 35 00 00       	call   3620 <argptest>
  createdelete();
      63:	e8 28 11 00 00       	call   1190 <createdelete>
  linkunlink();
      68:	e8 e3 19 00 00       	call   1a50 <linkunlink>
  concreate();
      6d:	e8 de 16 00 00       	call   1750 <concreate>
  fourfiles();
      72:	e8 19 0f 00 00       	call   f90 <fourfiles>
  sharedfd();
      77:	e8 54 0d 00 00       	call   dd0 <sharedfd>

  bigargtest();
      7c:	e8 5f 32 00 00       	call   32e0 <bigargtest>
  bigwrite();
      81:	e8 ea 22 00 00       	call   2370 <bigwrite>
  bigargtest();
      86:	e8 55 32 00 00       	call   32e0 <bigargtest>
  bsstest();
      8b:	e8 d0 31 00 00       	call   3260 <bsstest>

  uio();

  exectest();*/

  exit();
      90:	e8 6d 38 00 00       	call   3902 <exit>
      95:	66 90                	xchg   %ax,%ax
      97:	66 90                	xchg   %ax,%ax
      99:	66 90                	xchg   %ax,%ax
      9b:	66 90                	xchg   %ax,%ax
      9d:	66 90                	xchg   %ax,%ax
      9f:	90                   	nop

000000a0 <iputtest>:
{
      a0:	55                   	push   %ebp
      a1:	89 e5                	mov    %esp,%ebp
      a3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
      a6:	68 5c 3e 00 00       	push   $0x3e5c
      ab:	ff 35 08 5f 00 00    	pushl  0x5f08
      b1:	e8 ba 39 00 00       	call   3a70 <printf>
  if(mkdir("iputdir") < 0){
      b6:	c7 04 24 ef 3d 00 00 	movl   $0x3def,(%esp)
      bd:	e8 a8 38 00 00       	call   396a <mkdir>
      c2:	83 c4 10             	add    $0x10,%esp
      c5:	85 c0                	test   %eax,%eax
      c7:	78 58                	js     121 <iputtest+0x81>
  if(chdir("iputdir") < 0){
      c9:	83 ec 0c             	sub    $0xc,%esp
      cc:	68 ef 3d 00 00       	push   $0x3def
      d1:	e8 9c 38 00 00       	call   3972 <chdir>
      d6:	83 c4 10             	add    $0x10,%esp
      d9:	85 c0                	test   %eax,%eax
      db:	0f 88 85 00 00 00    	js     166 <iputtest+0xc6>
  if(unlink("../iputdir") < 0){
      e1:	83 ec 0c             	sub    $0xc,%esp
      e4:	68 ec 3d 00 00       	push   $0x3dec
      e9:	e8 64 38 00 00       	call   3952 <unlink>
      ee:	83 c4 10             	add    $0x10,%esp
      f1:	85 c0                	test   %eax,%eax
      f3:	78 5a                	js     14f <iputtest+0xaf>
  if(chdir("/") < 0){
      f5:	83 ec 0c             	sub    $0xc,%esp
      f8:	68 11 3e 00 00       	push   $0x3e11
      fd:	e8 70 38 00 00       	call   3972 <chdir>
     102:	83 c4 10             	add    $0x10,%esp
     105:	85 c0                	test   %eax,%eax
     107:	78 2f                	js     138 <iputtest+0x98>
  printf(stdout, "iput test ok\n");
     109:	83 ec 08             	sub    $0x8,%esp
     10c:	68 94 3e 00 00       	push   $0x3e94
     111:	ff 35 08 5f 00 00    	pushl  0x5f08
     117:	e8 54 39 00 00       	call   3a70 <printf>
}
     11c:	83 c4 10             	add    $0x10,%esp
     11f:	c9                   	leave  
     120:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     121:	50                   	push   %eax
     122:	50                   	push   %eax
     123:	68 c8 3d 00 00       	push   $0x3dc8
     128:	ff 35 08 5f 00 00    	pushl  0x5f08
     12e:	e8 3d 39 00 00       	call   3a70 <printf>
    exit();
     133:	e8 ca 37 00 00       	call   3902 <exit>
    printf(stdout, "chdir / failed\n");
     138:	50                   	push   %eax
     139:	50                   	push   %eax
     13a:	68 13 3e 00 00       	push   $0x3e13
     13f:	ff 35 08 5f 00 00    	pushl  0x5f08
     145:	e8 26 39 00 00       	call   3a70 <printf>
    exit();
     14a:	e8 b3 37 00 00       	call   3902 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     14f:	52                   	push   %edx
     150:	52                   	push   %edx
     151:	68 f7 3d 00 00       	push   $0x3df7
     156:	ff 35 08 5f 00 00    	pushl  0x5f08
     15c:	e8 0f 39 00 00       	call   3a70 <printf>
    exit();
     161:	e8 9c 37 00 00       	call   3902 <exit>
    printf(stdout, "chdir iputdir failed\n");
     166:	51                   	push   %ecx
     167:	51                   	push   %ecx
     168:	68 d6 3d 00 00       	push   $0x3dd6
     16d:	ff 35 08 5f 00 00    	pushl  0x5f08
     173:	e8 f8 38 00 00       	call   3a70 <printf>
    exit();
     178:	e8 85 37 00 00       	call   3902 <exit>
     17d:	8d 76 00             	lea    0x0(%esi),%esi

00000180 <exitiputtest>:
{
     180:	55                   	push   %ebp
     181:	89 e5                	mov    %esp,%ebp
     183:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     186:	68 23 3e 00 00       	push   $0x3e23
     18b:	ff 35 08 5f 00 00    	pushl  0x5f08
     191:	e8 da 38 00 00       	call   3a70 <printf>
  pid = fork();
     196:	e8 5f 37 00 00       	call   38fa <fork>
  if(pid < 0){
     19b:	83 c4 10             	add    $0x10,%esp
     19e:	85 c0                	test   %eax,%eax
     1a0:	0f 88 82 00 00 00    	js     228 <exitiputtest+0xa8>
  if(pid == 0){
     1a6:	75 48                	jne    1f0 <exitiputtest+0x70>
    if(mkdir("iputdir") < 0){
     1a8:	83 ec 0c             	sub    $0xc,%esp
     1ab:	68 ef 3d 00 00       	push   $0x3def
     1b0:	e8 b5 37 00 00       	call   396a <mkdir>
     1b5:	83 c4 10             	add    $0x10,%esp
     1b8:	85 c0                	test   %eax,%eax
     1ba:	0f 88 96 00 00 00    	js     256 <exitiputtest+0xd6>
    if(chdir("iputdir") < 0){
     1c0:	83 ec 0c             	sub    $0xc,%esp
     1c3:	68 ef 3d 00 00       	push   $0x3def
     1c8:	e8 a5 37 00 00       	call   3972 <chdir>
     1cd:	83 c4 10             	add    $0x10,%esp
     1d0:	85 c0                	test   %eax,%eax
     1d2:	78 6b                	js     23f <exitiputtest+0xbf>
    if(unlink("../iputdir") < 0){
     1d4:	83 ec 0c             	sub    $0xc,%esp
     1d7:	68 ec 3d 00 00       	push   $0x3dec
     1dc:	e8 71 37 00 00       	call   3952 <unlink>
     1e1:	83 c4 10             	add    $0x10,%esp
     1e4:	85 c0                	test   %eax,%eax
     1e6:	78 28                	js     210 <exitiputtest+0x90>
    exit();
     1e8:	e8 15 37 00 00       	call   3902 <exit>
     1ed:	8d 76 00             	lea    0x0(%esi),%esi
  wait();
     1f0:	e8 15 37 00 00       	call   390a <wait>
  printf(stdout, "exitiput test ok\n");
     1f5:	83 ec 08             	sub    $0x8,%esp
     1f8:	68 46 3e 00 00       	push   $0x3e46
     1fd:	ff 35 08 5f 00 00    	pushl  0x5f08
     203:	e8 68 38 00 00       	call   3a70 <printf>
}
     208:	83 c4 10             	add    $0x10,%esp
     20b:	c9                   	leave  
     20c:	c3                   	ret    
     20d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     210:	83 ec 08             	sub    $0x8,%esp
     213:	68 f7 3d 00 00       	push   $0x3df7
     218:	ff 35 08 5f 00 00    	pushl  0x5f08
     21e:	e8 4d 38 00 00       	call   3a70 <printf>
      exit();
     223:	e8 da 36 00 00       	call   3902 <exit>
    printf(stdout, "fork failed\n");
     228:	51                   	push   %ecx
     229:	51                   	push   %ecx
     22a:	68 9a 4d 00 00       	push   $0x4d9a
     22f:	ff 35 08 5f 00 00    	pushl  0x5f08
     235:	e8 36 38 00 00       	call   3a70 <printf>
    exit();
     23a:	e8 c3 36 00 00       	call   3902 <exit>
      printf(stdout, "child chdir failed\n");
     23f:	50                   	push   %eax
     240:	50                   	push   %eax
     241:	68 32 3e 00 00       	push   $0x3e32
     246:	ff 35 08 5f 00 00    	pushl  0x5f08
     24c:	e8 1f 38 00 00       	call   3a70 <printf>
      exit();
     251:	e8 ac 36 00 00       	call   3902 <exit>
      printf(stdout, "mkdir failed\n");
     256:	52                   	push   %edx
     257:	52                   	push   %edx
     258:	68 c8 3d 00 00       	push   $0x3dc8
     25d:	ff 35 08 5f 00 00    	pushl  0x5f08
     263:	e8 08 38 00 00       	call   3a70 <printf>
      exit();
     268:	e8 95 36 00 00       	call   3902 <exit>
     26d:	8d 76 00             	lea    0x0(%esi),%esi

00000270 <openiputtest>:
{
     270:	55                   	push   %ebp
     271:	89 e5                	mov    %esp,%ebp
     273:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     276:	68 58 3e 00 00       	push   $0x3e58
     27b:	ff 35 08 5f 00 00    	pushl  0x5f08
     281:	e8 ea 37 00 00       	call   3a70 <printf>
  if(mkdir("oidir") < 0){
     286:	c7 04 24 67 3e 00 00 	movl   $0x3e67,(%esp)
     28d:	e8 d8 36 00 00       	call   396a <mkdir>
     292:	83 c4 10             	add    $0x10,%esp
     295:	85 c0                	test   %eax,%eax
     297:	0f 88 88 00 00 00    	js     325 <openiputtest+0xb5>
  pid = fork();
     29d:	e8 58 36 00 00       	call   38fa <fork>
  if(pid < 0){
     2a2:	85 c0                	test   %eax,%eax
     2a4:	0f 88 92 00 00 00    	js     33c <openiputtest+0xcc>
  if(pid == 0){
     2aa:	75 34                	jne    2e0 <openiputtest+0x70>
    int fd = open("oidir", O_RDWR);
     2ac:	83 ec 08             	sub    $0x8,%esp
     2af:	6a 02                	push   $0x2
     2b1:	68 67 3e 00 00       	push   $0x3e67
     2b6:	e8 87 36 00 00       	call   3942 <open>
    if(fd >= 0){
     2bb:	83 c4 10             	add    $0x10,%esp
     2be:	85 c0                	test   %eax,%eax
     2c0:	78 5e                	js     320 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     2c2:	83 ec 08             	sub    $0x8,%esp
     2c5:	68 7c 4e 00 00       	push   $0x4e7c
     2ca:	ff 35 08 5f 00 00    	pushl  0x5f08
     2d0:	e8 9b 37 00 00       	call   3a70 <printf>
      exit();
     2d5:	e8 28 36 00 00       	call   3902 <exit>
     2da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sleep(1);
     2e0:	83 ec 0c             	sub    $0xc,%esp
     2e3:	6a 01                	push   $0x1
     2e5:	e8 a8 36 00 00       	call   3992 <sleep>
  if(unlink("oidir") != 0){
     2ea:	c7 04 24 67 3e 00 00 	movl   $0x3e67,(%esp)
     2f1:	e8 5c 36 00 00       	call   3952 <unlink>
     2f6:	83 c4 10             	add    $0x10,%esp
     2f9:	85 c0                	test   %eax,%eax
     2fb:	75 56                	jne    353 <openiputtest+0xe3>
  wait();
     2fd:	e8 08 36 00 00       	call   390a <wait>
  printf(stdout, "openiput test ok\n");
     302:	83 ec 08             	sub    $0x8,%esp
     305:	68 90 3e 00 00       	push   $0x3e90
     30a:	ff 35 08 5f 00 00    	pushl  0x5f08
     310:	e8 5b 37 00 00       	call   3a70 <printf>
}
     315:	83 c4 10             	add    $0x10,%esp
     318:	c9                   	leave  
     319:	c3                   	ret    
     31a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
     320:	e8 dd 35 00 00       	call   3902 <exit>
    printf(stdout, "mkdir oidir failed\n");
     325:	51                   	push   %ecx
     326:	51                   	push   %ecx
     327:	68 6d 3e 00 00       	push   $0x3e6d
     32c:	ff 35 08 5f 00 00    	pushl  0x5f08
     332:	e8 39 37 00 00       	call   3a70 <printf>
    exit();
     337:	e8 c6 35 00 00       	call   3902 <exit>
    printf(stdout, "fork failed\n");
     33c:	52                   	push   %edx
     33d:	52                   	push   %edx
     33e:	68 9a 4d 00 00       	push   $0x4d9a
     343:	ff 35 08 5f 00 00    	pushl  0x5f08
     349:	e8 22 37 00 00       	call   3a70 <printf>
    exit();
     34e:	e8 af 35 00 00       	call   3902 <exit>
    printf(stdout, "unlink failed\n");
     353:	50                   	push   %eax
     354:	50                   	push   %eax
     355:	68 81 3e 00 00       	push   $0x3e81
     35a:	ff 35 08 5f 00 00    	pushl  0x5f08
     360:	e8 0b 37 00 00       	call   3a70 <printf>
    exit();
     365:	e8 98 35 00 00       	call   3902 <exit>
     36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000370 <opentest>:
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     376:	68 a2 3e 00 00       	push   $0x3ea2
     37b:	ff 35 08 5f 00 00    	pushl  0x5f08
     381:	e8 ea 36 00 00       	call   3a70 <printf>
  fd = open("echo", 0);
     386:	58                   	pop    %eax
     387:	5a                   	pop    %edx
     388:	6a 00                	push   $0x0
     38a:	68 ad 3e 00 00       	push   $0x3ead
     38f:	e8 ae 35 00 00       	call   3942 <open>
  if(fd < 0){
     394:	83 c4 10             	add    $0x10,%esp
     397:	85 c0                	test   %eax,%eax
     399:	78 36                	js     3d1 <opentest+0x61>
  close(fd);
     39b:	83 ec 0c             	sub    $0xc,%esp
     39e:	50                   	push   %eax
     39f:	e8 86 35 00 00       	call   392a <close>
  fd = open("doesnotexist", 0);
     3a4:	5a                   	pop    %edx
     3a5:	59                   	pop    %ecx
     3a6:	6a 00                	push   $0x0
     3a8:	68 c5 3e 00 00       	push   $0x3ec5
     3ad:	e8 90 35 00 00       	call   3942 <open>
  if(fd >= 0){
     3b2:	83 c4 10             	add    $0x10,%esp
     3b5:	85 c0                	test   %eax,%eax
     3b7:	79 2f                	jns    3e8 <opentest+0x78>
  printf(stdout, "open test ok\n");
     3b9:	83 ec 08             	sub    $0x8,%esp
     3bc:	68 f0 3e 00 00       	push   $0x3ef0
     3c1:	ff 35 08 5f 00 00    	pushl  0x5f08
     3c7:	e8 a4 36 00 00       	call   3a70 <printf>
}
     3cc:	83 c4 10             	add    $0x10,%esp
     3cf:	c9                   	leave  
     3d0:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     3d1:	50                   	push   %eax
     3d2:	50                   	push   %eax
     3d3:	68 b2 3e 00 00       	push   $0x3eb2
     3d8:	ff 35 08 5f 00 00    	pushl  0x5f08
     3de:	e8 8d 36 00 00       	call   3a70 <printf>
    exit();
     3e3:	e8 1a 35 00 00       	call   3902 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     3e8:	50                   	push   %eax
     3e9:	50                   	push   %eax
     3ea:	68 d2 3e 00 00       	push   $0x3ed2
     3ef:	ff 35 08 5f 00 00    	pushl  0x5f08
     3f5:	e8 76 36 00 00       	call   3a70 <printf>
    exit();
     3fa:	e8 03 35 00 00       	call   3902 <exit>
     3ff:	90                   	nop

00000400 <writetest>:
{
     400:	55                   	push   %ebp
     401:	89 e5                	mov    %esp,%ebp
     403:	56                   	push   %esi
     404:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     405:	83 ec 08             	sub    $0x8,%esp
     408:	68 fe 3e 00 00       	push   $0x3efe
     40d:	ff 35 08 5f 00 00    	pushl  0x5f08
     413:	e8 58 36 00 00       	call   3a70 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     418:	58                   	pop    %eax
     419:	5a                   	pop    %edx
     41a:	68 02 02 00 00       	push   $0x202
     41f:	68 0f 3f 00 00       	push   $0x3f0f
     424:	e8 19 35 00 00       	call   3942 <open>
  if(fd >= 0){
     429:	83 c4 10             	add    $0x10,%esp
     42c:	85 c0                	test   %eax,%eax
     42e:	0f 88 88 01 00 00    	js     5bc <writetest+0x1bc>
    printf(stdout, "creat small succeeded; ok\n");
     434:	83 ec 08             	sub    $0x8,%esp
     437:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
     439:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
     43b:	68 15 3f 00 00       	push   $0x3f15
     440:	ff 35 08 5f 00 00    	pushl  0x5f08
     446:	e8 25 36 00 00       	call   3a70 <printf>
     44b:	83 c4 10             	add    $0x10,%esp
     44e:	66 90                	xchg   %ax,%ax
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     450:	83 ec 04             	sub    $0x4,%esp
     453:	6a 0a                	push   $0xa
     455:	68 4c 3f 00 00       	push   $0x3f4c
     45a:	56                   	push   %esi
     45b:	e8 c2 34 00 00       	call   3922 <write>
     460:	83 c4 10             	add    $0x10,%esp
     463:	83 f8 0a             	cmp    $0xa,%eax
     466:	0f 85 d9 00 00 00    	jne    545 <writetest+0x145>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     46c:	83 ec 04             	sub    $0x4,%esp
     46f:	6a 0a                	push   $0xa
     471:	68 57 3f 00 00       	push   $0x3f57
     476:	56                   	push   %esi
     477:	e8 a6 34 00 00       	call   3922 <write>
     47c:	83 c4 10             	add    $0x10,%esp
     47f:	83 f8 0a             	cmp    $0xa,%eax
     482:	0f 85 d6 00 00 00    	jne    55e <writetest+0x15e>
  for(i = 0; i < 100; i++){
     488:	83 c3 01             	add    $0x1,%ebx
     48b:	83 fb 64             	cmp    $0x64,%ebx
     48e:	75 c0                	jne    450 <writetest+0x50>
  printf(stdout, "writes ok\n");
     490:	83 ec 08             	sub    $0x8,%esp
     493:	68 62 3f 00 00       	push   $0x3f62
     498:	ff 35 08 5f 00 00    	pushl  0x5f08
     49e:	e8 cd 35 00 00       	call   3a70 <printf>
  close(fd);
     4a3:	89 34 24             	mov    %esi,(%esp)
     4a6:	e8 7f 34 00 00       	call   392a <close>
  fd = open("small", O_RDONLY);
     4ab:	5b                   	pop    %ebx
     4ac:	5e                   	pop    %esi
     4ad:	6a 00                	push   $0x0
     4af:	68 0f 3f 00 00       	push   $0x3f0f
     4b4:	e8 89 34 00 00       	call   3942 <open>
  if(fd >= 0){
     4b9:	83 c4 10             	add    $0x10,%esp
     4bc:	85 c0                	test   %eax,%eax
  fd = open("small", O_RDONLY);
     4be:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     4c0:	0f 88 b1 00 00 00    	js     577 <writetest+0x177>
    printf(stdout, "open small succeeded ok\n");
     4c6:	83 ec 08             	sub    $0x8,%esp
     4c9:	68 6d 3f 00 00       	push   $0x3f6d
     4ce:	ff 35 08 5f 00 00    	pushl  0x5f08
     4d4:	e8 97 35 00 00       	call   3a70 <printf>
  i = read(fd, buf, 2000);
     4d9:	83 c4 0c             	add    $0xc,%esp
     4dc:	68 d0 07 00 00       	push   $0x7d0
     4e1:	68 e0 86 00 00       	push   $0x86e0
     4e6:	53                   	push   %ebx
     4e7:	e8 2e 34 00 00       	call   391a <read>
  if(i == 2000){
     4ec:	83 c4 10             	add    $0x10,%esp
     4ef:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     4f4:	0f 85 94 00 00 00    	jne    58e <writetest+0x18e>
    printf(stdout, "read succeeded ok\n");
     4fa:	83 ec 08             	sub    $0x8,%esp
     4fd:	68 a1 3f 00 00       	push   $0x3fa1
     502:	ff 35 08 5f 00 00    	pushl  0x5f08
     508:	e8 63 35 00 00       	call   3a70 <printf>
  close(fd);
     50d:	89 1c 24             	mov    %ebx,(%esp)
     510:	e8 15 34 00 00       	call   392a <close>
  if(unlink("small") < 0){
     515:	c7 04 24 0f 3f 00 00 	movl   $0x3f0f,(%esp)
     51c:	e8 31 34 00 00       	call   3952 <unlink>
     521:	83 c4 10             	add    $0x10,%esp
     524:	85 c0                	test   %eax,%eax
     526:	78 7d                	js     5a5 <writetest+0x1a5>
  printf(stdout, "small file test ok\n");
     528:	83 ec 08             	sub    $0x8,%esp
     52b:	68 c9 3f 00 00       	push   $0x3fc9
     530:	ff 35 08 5f 00 00    	pushl  0x5f08
     536:	e8 35 35 00 00       	call   3a70 <printf>
}
     53b:	83 c4 10             	add    $0x10,%esp
     53e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     541:	5b                   	pop    %ebx
     542:	5e                   	pop    %esi
     543:	5d                   	pop    %ebp
     544:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     545:	83 ec 04             	sub    $0x4,%esp
     548:	53                   	push   %ebx
     549:	68 a0 4e 00 00       	push   $0x4ea0
     54e:	ff 35 08 5f 00 00    	pushl  0x5f08
     554:	e8 17 35 00 00       	call   3a70 <printf>
      exit();
     559:	e8 a4 33 00 00       	call   3902 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     55e:	83 ec 04             	sub    $0x4,%esp
     561:	53                   	push   %ebx
     562:	68 c4 4e 00 00       	push   $0x4ec4
     567:	ff 35 08 5f 00 00    	pushl  0x5f08
     56d:	e8 fe 34 00 00       	call   3a70 <printf>
      exit();
     572:	e8 8b 33 00 00       	call   3902 <exit>
    printf(stdout, "error: open small failed!\n");
     577:	51                   	push   %ecx
     578:	51                   	push   %ecx
     579:	68 86 3f 00 00       	push   $0x3f86
     57e:	ff 35 08 5f 00 00    	pushl  0x5f08
     584:	e8 e7 34 00 00       	call   3a70 <printf>
    exit();
     589:	e8 74 33 00 00       	call   3902 <exit>
    printf(stdout, "read failed\n");
     58e:	52                   	push   %edx
     58f:	52                   	push   %edx
     590:	68 cd 42 00 00       	push   $0x42cd
     595:	ff 35 08 5f 00 00    	pushl  0x5f08
     59b:	e8 d0 34 00 00       	call   3a70 <printf>
    exit();
     5a0:	e8 5d 33 00 00       	call   3902 <exit>
    printf(stdout, "unlink small failed\n");
     5a5:	50                   	push   %eax
     5a6:	50                   	push   %eax
     5a7:	68 b4 3f 00 00       	push   $0x3fb4
     5ac:	ff 35 08 5f 00 00    	pushl  0x5f08
     5b2:	e8 b9 34 00 00       	call   3a70 <printf>
    exit();
     5b7:	e8 46 33 00 00       	call   3902 <exit>
    printf(stdout, "error: creat small failed!\n");
     5bc:	50                   	push   %eax
     5bd:	50                   	push   %eax
     5be:	68 30 3f 00 00       	push   $0x3f30
     5c3:	ff 35 08 5f 00 00    	pushl  0x5f08
     5c9:	e8 a2 34 00 00       	call   3a70 <printf>
    exit();
     5ce:	e8 2f 33 00 00       	call   3902 <exit>
     5d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     5d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005e0 <writetest1>:
{
     5e0:	55                   	push   %ebp
     5e1:	89 e5                	mov    %esp,%ebp
     5e3:	56                   	push   %esi
     5e4:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     5e5:	83 ec 08             	sub    $0x8,%esp
     5e8:	68 dd 3f 00 00       	push   $0x3fdd
     5ed:	ff 35 08 5f 00 00    	pushl  0x5f08
     5f3:	e8 78 34 00 00       	call   3a70 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     5f8:	58                   	pop    %eax
     5f9:	5a                   	pop    %edx
     5fa:	68 02 02 00 00       	push   $0x202
     5ff:	68 57 40 00 00       	push   $0x4057
     604:	e8 39 33 00 00       	call   3942 <open>
  if(fd < 0){
     609:	83 c4 10             	add    $0x10,%esp
     60c:	85 c0                	test   %eax,%eax
     60e:	0f 88 61 01 00 00    	js     775 <writetest1+0x195>
     614:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     616:	31 db                	xor    %ebx,%ebx
     618:	90                   	nop
     619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(write(fd, buf, 512) != 512){
     620:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
     623:	89 1d e0 86 00 00    	mov    %ebx,0x86e0
    if(write(fd, buf, 512) != 512){
     629:	68 00 02 00 00       	push   $0x200
     62e:	68 e0 86 00 00       	push   $0x86e0
     633:	56                   	push   %esi
     634:	e8 e9 32 00 00       	call   3922 <write>
     639:	83 c4 10             	add    $0x10,%esp
     63c:	3d 00 02 00 00       	cmp    $0x200,%eax
     641:	0f 85 b3 00 00 00    	jne    6fa <writetest1+0x11a>
  for(i = 0; i < MAXFILE; i++){
     647:	83 c3 01             	add    $0x1,%ebx
     64a:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     650:	75 ce                	jne    620 <writetest1+0x40>
  close(fd);
     652:	83 ec 0c             	sub    $0xc,%esp
     655:	56                   	push   %esi
     656:	e8 cf 32 00 00       	call   392a <close>
  fd = open("big", O_RDONLY);
     65b:	5b                   	pop    %ebx
     65c:	5e                   	pop    %esi
     65d:	6a 00                	push   $0x0
     65f:	68 57 40 00 00       	push   $0x4057
     664:	e8 d9 32 00 00       	call   3942 <open>
  if(fd < 0){
     669:	83 c4 10             	add    $0x10,%esp
     66c:	85 c0                	test   %eax,%eax
  fd = open("big", O_RDONLY);
     66e:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     670:	0f 88 e8 00 00 00    	js     75e <writetest1+0x17e>
  n = 0;
     676:	31 db                	xor    %ebx,%ebx
     678:	eb 1d                	jmp    697 <writetest1+0xb7>
     67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
     680:	3d 00 02 00 00       	cmp    $0x200,%eax
     685:	0f 85 9f 00 00 00    	jne    72a <writetest1+0x14a>
    if(((int*)buf)[0] != n){
     68b:	a1 e0 86 00 00       	mov    0x86e0,%eax
     690:	39 d8                	cmp    %ebx,%eax
     692:	75 7f                	jne    713 <writetest1+0x133>
    n++;
     694:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     697:	83 ec 04             	sub    $0x4,%esp
     69a:	68 00 02 00 00       	push   $0x200
     69f:	68 e0 86 00 00       	push   $0x86e0
     6a4:	56                   	push   %esi
     6a5:	e8 70 32 00 00       	call   391a <read>
    if(i == 0){
     6aa:	83 c4 10             	add    $0x10,%esp
     6ad:	85 c0                	test   %eax,%eax
     6af:	75 cf                	jne    680 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     6b1:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     6b7:	0f 84 86 00 00 00    	je     743 <writetest1+0x163>
  close(fd);
     6bd:	83 ec 0c             	sub    $0xc,%esp
     6c0:	56                   	push   %esi
     6c1:	e8 64 32 00 00       	call   392a <close>
  if(unlink("big") < 0){
     6c6:	c7 04 24 57 40 00 00 	movl   $0x4057,(%esp)
     6cd:	e8 80 32 00 00       	call   3952 <unlink>
     6d2:	83 c4 10             	add    $0x10,%esp
     6d5:	85 c0                	test   %eax,%eax
     6d7:	0f 88 af 00 00 00    	js     78c <writetest1+0x1ac>
  printf(stdout, "big files ok\n");
     6dd:	83 ec 08             	sub    $0x8,%esp
     6e0:	68 7e 40 00 00       	push   $0x407e
     6e5:	ff 35 08 5f 00 00    	pushl  0x5f08
     6eb:	e8 80 33 00 00       	call   3a70 <printf>
}
     6f0:	83 c4 10             	add    $0x10,%esp
     6f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
     6f6:	5b                   	pop    %ebx
     6f7:	5e                   	pop    %esi
     6f8:	5d                   	pop    %ebp
     6f9:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     6fa:	83 ec 04             	sub    $0x4,%esp
     6fd:	53                   	push   %ebx
     6fe:	68 07 40 00 00       	push   $0x4007
     703:	ff 35 08 5f 00 00    	pushl  0x5f08
     709:	e8 62 33 00 00       	call   3a70 <printf>
      exit();
     70e:	e8 ef 31 00 00       	call   3902 <exit>
      printf(stdout, "read content of block %d is %d\n",
     713:	50                   	push   %eax
     714:	53                   	push   %ebx
     715:	68 e8 4e 00 00       	push   $0x4ee8
     71a:	ff 35 08 5f 00 00    	pushl  0x5f08
     720:	e8 4b 33 00 00       	call   3a70 <printf>
      exit();
     725:	e8 d8 31 00 00       	call   3902 <exit>
      printf(stdout, "read failed %d\n", i);
     72a:	83 ec 04             	sub    $0x4,%esp
     72d:	50                   	push   %eax
     72e:	68 5b 40 00 00       	push   $0x405b
     733:	ff 35 08 5f 00 00    	pushl  0x5f08
     739:	e8 32 33 00 00       	call   3a70 <printf>
      exit();
     73e:	e8 bf 31 00 00       	call   3902 <exit>
        printf(stdout, "read only %d blocks from big", n);
     743:	52                   	push   %edx
     744:	68 8b 00 00 00       	push   $0x8b
     749:	68 3e 40 00 00       	push   $0x403e
     74e:	ff 35 08 5f 00 00    	pushl  0x5f08
     754:	e8 17 33 00 00       	call   3a70 <printf>
        exit();
     759:	e8 a4 31 00 00       	call   3902 <exit>
    printf(stdout, "error: open big failed!\n");
     75e:	51                   	push   %ecx
     75f:	51                   	push   %ecx
     760:	68 25 40 00 00       	push   $0x4025
     765:	ff 35 08 5f 00 00    	pushl  0x5f08
     76b:	e8 00 33 00 00       	call   3a70 <printf>
    exit();
     770:	e8 8d 31 00 00       	call   3902 <exit>
    printf(stdout, "error: creat big failed!\n");
     775:	50                   	push   %eax
     776:	50                   	push   %eax
     777:	68 ed 3f 00 00       	push   $0x3fed
     77c:	ff 35 08 5f 00 00    	pushl  0x5f08
     782:	e8 e9 32 00 00       	call   3a70 <printf>
    exit();
     787:	e8 76 31 00 00       	call   3902 <exit>
    printf(stdout, "unlink big failed\n");
     78c:	50                   	push   %eax
     78d:	50                   	push   %eax
     78e:	68 6b 40 00 00       	push   $0x406b
     793:	ff 35 08 5f 00 00    	pushl  0x5f08
     799:	e8 d2 32 00 00       	call   3a70 <printf>
    exit();
     79e:	e8 5f 31 00 00       	call   3902 <exit>
     7a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     7a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007b0 <createtest>:
{
     7b0:	55                   	push   %ebp
     7b1:	89 e5                	mov    %esp,%ebp
     7b3:	53                   	push   %ebx
  name[2] = '\0';
     7b4:	bb 30 00 00 00       	mov    $0x30,%ebx
{
     7b9:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     7bc:	68 08 4f 00 00       	push   $0x4f08
     7c1:	ff 35 08 5f 00 00    	pushl  0x5f08
     7c7:	e8 a4 32 00 00       	call   3a70 <printf>
  name[0] = 'a';
     7cc:	c6 05 e0 a6 00 00 61 	movb   $0x61,0xa6e0
  name[2] = '\0';
     7d3:	c6 05 e2 a6 00 00 00 	movb   $0x0,0xa6e2
     7da:	83 c4 10             	add    $0x10,%esp
     7dd:	8d 76 00             	lea    0x0(%esi),%esi
    fd = open(name, O_CREATE|O_RDWR);
     7e0:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
     7e3:	88 1d e1 a6 00 00    	mov    %bl,0xa6e1
     7e9:	83 c3 01             	add    $0x1,%ebx
    fd = open(name, O_CREATE|O_RDWR);
     7ec:	68 02 02 00 00       	push   $0x202
     7f1:	68 e0 a6 00 00       	push   $0xa6e0
     7f6:	e8 47 31 00 00       	call   3942 <open>
    close(fd);
     7fb:	89 04 24             	mov    %eax,(%esp)
     7fe:	e8 27 31 00 00       	call   392a <close>
  for(i = 0; i < 52; i++){
     803:	83 c4 10             	add    $0x10,%esp
     806:	80 fb 64             	cmp    $0x64,%bl
     809:	75 d5                	jne    7e0 <createtest+0x30>
  name[0] = 'a';
     80b:	c6 05 e0 a6 00 00 61 	movb   $0x61,0xa6e0
  name[2] = '\0';
     812:	c6 05 e2 a6 00 00 00 	movb   $0x0,0xa6e2
     819:	bb 30 00 00 00       	mov    $0x30,%ebx
     81e:	66 90                	xchg   %ax,%ax
    unlink(name);
     820:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
     823:	88 1d e1 a6 00 00    	mov    %bl,0xa6e1
     829:	83 c3 01             	add    $0x1,%ebx
    unlink(name);
     82c:	68 e0 a6 00 00       	push   $0xa6e0
     831:	e8 1c 31 00 00       	call   3952 <unlink>
  for(i = 0; i < 52; i++){
     836:	83 c4 10             	add    $0x10,%esp
     839:	80 fb 64             	cmp    $0x64,%bl
     83c:	75 e2                	jne    820 <createtest+0x70>
  printf(stdout, "many creates, followed by unlink; ok\n");
     83e:	83 ec 08             	sub    $0x8,%esp
     841:	68 30 4f 00 00       	push   $0x4f30
     846:	ff 35 08 5f 00 00    	pushl  0x5f08
     84c:	e8 1f 32 00 00       	call   3a70 <printf>
}
     851:	83 c4 10             	add    $0x10,%esp
     854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     857:	c9                   	leave  
     858:	c3                   	ret    
     859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000860 <dirtest>:
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     866:	68 8c 40 00 00       	push   $0x408c
     86b:	ff 35 08 5f 00 00    	pushl  0x5f08
     871:	e8 fa 31 00 00       	call   3a70 <printf>
  if(mkdir("dir0") < 0){
     876:	c7 04 24 98 40 00 00 	movl   $0x4098,(%esp)
     87d:	e8 e8 30 00 00       	call   396a <mkdir>
     882:	83 c4 10             	add    $0x10,%esp
     885:	85 c0                	test   %eax,%eax
     887:	78 58                	js     8e1 <dirtest+0x81>
  if(chdir("dir0") < 0){
     889:	83 ec 0c             	sub    $0xc,%esp
     88c:	68 98 40 00 00       	push   $0x4098
     891:	e8 dc 30 00 00       	call   3972 <chdir>
     896:	83 c4 10             	add    $0x10,%esp
     899:	85 c0                	test   %eax,%eax
     89b:	0f 88 85 00 00 00    	js     926 <dirtest+0xc6>
  if(chdir("..") < 0){
     8a1:	83 ec 0c             	sub    $0xc,%esp
     8a4:	68 3d 46 00 00       	push   $0x463d
     8a9:	e8 c4 30 00 00       	call   3972 <chdir>
     8ae:	83 c4 10             	add    $0x10,%esp
     8b1:	85 c0                	test   %eax,%eax
     8b3:	78 5a                	js     90f <dirtest+0xaf>
  if(unlink("dir0") < 0){
     8b5:	83 ec 0c             	sub    $0xc,%esp
     8b8:	68 98 40 00 00       	push   $0x4098
     8bd:	e8 90 30 00 00       	call   3952 <unlink>
     8c2:	83 c4 10             	add    $0x10,%esp
     8c5:	85 c0                	test   %eax,%eax
     8c7:	78 2f                	js     8f8 <dirtest+0x98>
  printf(stdout, "mkdir test ok\n");
     8c9:	83 ec 08             	sub    $0x8,%esp
     8cc:	68 d5 40 00 00       	push   $0x40d5
     8d1:	ff 35 08 5f 00 00    	pushl  0x5f08
     8d7:	e8 94 31 00 00       	call   3a70 <printf>
}
     8dc:	83 c4 10             	add    $0x10,%esp
     8df:	c9                   	leave  
     8e0:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     8e1:	50                   	push   %eax
     8e2:	50                   	push   %eax
     8e3:	68 c8 3d 00 00       	push   $0x3dc8
     8e8:	ff 35 08 5f 00 00    	pushl  0x5f08
     8ee:	e8 7d 31 00 00       	call   3a70 <printf>
    exit();
     8f3:	e8 0a 30 00 00       	call   3902 <exit>
    printf(stdout, "unlink dir0 failed\n");
     8f8:	50                   	push   %eax
     8f9:	50                   	push   %eax
     8fa:	68 c1 40 00 00       	push   $0x40c1
     8ff:	ff 35 08 5f 00 00    	pushl  0x5f08
     905:	e8 66 31 00 00       	call   3a70 <printf>
    exit();
     90a:	e8 f3 2f 00 00       	call   3902 <exit>
    printf(stdout, "chdir .. failed\n");
     90f:	52                   	push   %edx
     910:	52                   	push   %edx
     911:	68 b0 40 00 00       	push   $0x40b0
     916:	ff 35 08 5f 00 00    	pushl  0x5f08
     91c:	e8 4f 31 00 00       	call   3a70 <printf>
    exit();
     921:	e8 dc 2f 00 00       	call   3902 <exit>
    printf(stdout, "chdir dir0 failed\n");
     926:	51                   	push   %ecx
     927:	51                   	push   %ecx
     928:	68 9d 40 00 00       	push   $0x409d
     92d:	ff 35 08 5f 00 00    	pushl  0x5f08
     933:	e8 38 31 00 00       	call   3a70 <printf>
    exit();
     938:	e8 c5 2f 00 00       	call   3902 <exit>
     93d:	8d 76 00             	lea    0x0(%esi),%esi

00000940 <exectest>:
{
     940:	55                   	push   %ebp
     941:	89 e5                	mov    %esp,%ebp
     943:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     946:	68 e4 40 00 00       	push   $0x40e4
     94b:	ff 35 08 5f 00 00    	pushl  0x5f08
     951:	e8 1a 31 00 00       	call   3a70 <printf>
  if(exec("echo", echoargv) < 0){
     956:	5a                   	pop    %edx
     957:	59                   	pop    %ecx
     958:	68 0c 5f 00 00       	push   $0x5f0c
     95d:	68 ad 3e 00 00       	push   $0x3ead
     962:	e8 d3 2f 00 00       	call   393a <exec>
     967:	83 c4 10             	add    $0x10,%esp
     96a:	85 c0                	test   %eax,%eax
     96c:	78 02                	js     970 <exectest+0x30>
}
     96e:	c9                   	leave  
     96f:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     970:	50                   	push   %eax
     971:	50                   	push   %eax
     972:	68 ef 40 00 00       	push   $0x40ef
     977:	ff 35 08 5f 00 00    	pushl  0x5f08
     97d:	e8 ee 30 00 00       	call   3a70 <printf>
    exit();
     982:	e8 7b 2f 00 00       	call   3902 <exit>
     987:	89 f6                	mov    %esi,%esi
     989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000990 <pipe1>:
{
     990:	55                   	push   %ebp
     991:	89 e5                	mov    %esp,%ebp
     993:	57                   	push   %edi
     994:	56                   	push   %esi
     995:	53                   	push   %ebx
  if(pipe(fds) != 0){
     996:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
     999:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     99c:	50                   	push   %eax
     99d:	e8 70 2f 00 00       	call   3912 <pipe>
     9a2:	83 c4 10             	add    $0x10,%esp
     9a5:	85 c0                	test   %eax,%eax
     9a7:	0f 85 3e 01 00 00    	jne    aeb <pipe1+0x15b>
     9ad:	89 c3                	mov    %eax,%ebx
  pid = fork();
     9af:	e8 46 2f 00 00       	call   38fa <fork>
  if(pid == 0){
     9b4:	83 f8 00             	cmp    $0x0,%eax
     9b7:	0f 84 84 00 00 00    	je     a41 <pipe1+0xb1>
  } else if(pid > 0){
     9bd:	0f 8e 3b 01 00 00    	jle    afe <pipe1+0x16e>
    close(fds[1]);
     9c3:	83 ec 0c             	sub    $0xc,%esp
     9c6:	ff 75 e4             	pushl  -0x1c(%ebp)
    cc = 1;
     9c9:	bf 01 00 00 00       	mov    $0x1,%edi
    close(fds[1]);
     9ce:	e8 57 2f 00 00       	call   392a <close>
    while((n = read(fds[0], buf, cc)) > 0){
     9d3:	83 c4 10             	add    $0x10,%esp
    total = 0;
     9d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     9dd:	83 ec 04             	sub    $0x4,%esp
     9e0:	57                   	push   %edi
     9e1:	68 e0 86 00 00       	push   $0x86e0
     9e6:	ff 75 e0             	pushl  -0x20(%ebp)
     9e9:	e8 2c 2f 00 00       	call   391a <read>
     9ee:	83 c4 10             	add    $0x10,%esp
     9f1:	85 c0                	test   %eax,%eax
     9f3:	0f 8e ab 00 00 00    	jle    aa4 <pipe1+0x114>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     9f9:	89 d9                	mov    %ebx,%ecx
     9fb:	8d 34 18             	lea    (%eax,%ebx,1),%esi
     9fe:	f7 d9                	neg    %ecx
     a00:	38 9c 0b e0 86 00 00 	cmp    %bl,0x86e0(%ebx,%ecx,1)
     a07:	8d 53 01             	lea    0x1(%ebx),%edx
     a0a:	75 1b                	jne    a27 <pipe1+0x97>
      for(i = 0; i < n; i++){
     a0c:	39 f2                	cmp    %esi,%edx
     a0e:	89 d3                	mov    %edx,%ebx
     a10:	75 ee                	jne    a00 <pipe1+0x70>
      cc = cc * 2;
     a12:	01 ff                	add    %edi,%edi
      total += n;
     a14:	01 45 d4             	add    %eax,-0x2c(%ebp)
     a17:	b8 00 20 00 00       	mov    $0x2000,%eax
     a1c:	81 ff 00 20 00 00    	cmp    $0x2000,%edi
     a22:	0f 4f f8             	cmovg  %eax,%edi
     a25:	eb b6                	jmp    9dd <pipe1+0x4d>
          printf(1, "pipe1 oops 2\n");
     a27:	83 ec 08             	sub    $0x8,%esp
     a2a:	68 1e 41 00 00       	push   $0x411e
     a2f:	6a 01                	push   $0x1
     a31:	e8 3a 30 00 00       	call   3a70 <printf>
          return;
     a36:	83 c4 10             	add    $0x10,%esp
}
     a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a3c:	5b                   	pop    %ebx
     a3d:	5e                   	pop    %esi
     a3e:	5f                   	pop    %edi
     a3f:	5d                   	pop    %ebp
     a40:	c3                   	ret    
    close(fds[0]);
     a41:	83 ec 0c             	sub    $0xc,%esp
     a44:	ff 75 e0             	pushl  -0x20(%ebp)
     a47:	31 db                	xor    %ebx,%ebx
     a49:	be 09 04 00 00       	mov    $0x409,%esi
     a4e:	e8 d7 2e 00 00       	call   392a <close>
     a53:	83 c4 10             	add    $0x10,%esp
     a56:	89 d8                	mov    %ebx,%eax
     a58:	89 f2                	mov    %esi,%edx
     a5a:	f7 d8                	neg    %eax
     a5c:	29 da                	sub    %ebx,%edx
     a5e:	66 90                	xchg   %ax,%ax
        buf[i] = seq++;
     a60:	88 84 03 e0 86 00 00 	mov    %al,0x86e0(%ebx,%eax,1)
     a67:	83 c0 01             	add    $0x1,%eax
      for(i = 0; i < 1033; i++)
     a6a:	39 d0                	cmp    %edx,%eax
     a6c:	75 f2                	jne    a60 <pipe1+0xd0>
      if(write(fds[1], buf, 1033) != 1033){
     a6e:	83 ec 04             	sub    $0x4,%esp
     a71:	68 09 04 00 00       	push   $0x409
     a76:	68 e0 86 00 00       	push   $0x86e0
     a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
     a7e:	e8 9f 2e 00 00       	call   3922 <write>
     a83:	83 c4 10             	add    $0x10,%esp
     a86:	3d 09 04 00 00       	cmp    $0x409,%eax
     a8b:	0f 85 80 00 00 00    	jne    b11 <pipe1+0x181>
     a91:	81 eb 09 04 00 00    	sub    $0x409,%ebx
    for(n = 0; n < 5; n++){
     a97:	81 fb d3 eb ff ff    	cmp    $0xffffebd3,%ebx
     a9d:	75 b7                	jne    a56 <pipe1+0xc6>
    exit();
     a9f:	e8 5e 2e 00 00       	call   3902 <exit>
    if(total != 5 * 1033){
     aa4:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     aab:	75 29                	jne    ad6 <pipe1+0x146>
    close(fds[0]);
     aad:	83 ec 0c             	sub    $0xc,%esp
     ab0:	ff 75 e0             	pushl  -0x20(%ebp)
     ab3:	e8 72 2e 00 00       	call   392a <close>
    wait();
     ab8:	e8 4d 2e 00 00       	call   390a <wait>
  printf(1, "pipe1 ok\n");
     abd:	5a                   	pop    %edx
     abe:	59                   	pop    %ecx
     abf:	68 43 41 00 00       	push   $0x4143
     ac4:	6a 01                	push   $0x1
     ac6:	e8 a5 2f 00 00       	call   3a70 <printf>
     acb:	83 c4 10             	add    $0x10,%esp
}
     ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ad1:	5b                   	pop    %ebx
     ad2:	5e                   	pop    %esi
     ad3:	5f                   	pop    %edi
     ad4:	5d                   	pop    %ebp
     ad5:	c3                   	ret    
      printf(1, "pipe1 oops 3 total %d\n", total);
     ad6:	53                   	push   %ebx
     ad7:	ff 75 d4             	pushl  -0x2c(%ebp)
     ada:	68 2c 41 00 00       	push   $0x412c
     adf:	6a 01                	push   $0x1
     ae1:	e8 8a 2f 00 00       	call   3a70 <printf>
      exit();
     ae6:	e8 17 2e 00 00       	call   3902 <exit>
    printf(1, "pipe() failed\n");
     aeb:	57                   	push   %edi
     aec:	57                   	push   %edi
     aed:	68 01 41 00 00       	push   $0x4101
     af2:	6a 01                	push   $0x1
     af4:	e8 77 2f 00 00       	call   3a70 <printf>
    exit();
     af9:	e8 04 2e 00 00       	call   3902 <exit>
    printf(1, "fork() failed\n");
     afe:	50                   	push   %eax
     aff:	50                   	push   %eax
     b00:	68 4d 41 00 00       	push   $0x414d
     b05:	6a 01                	push   $0x1
     b07:	e8 64 2f 00 00       	call   3a70 <printf>
    exit();
     b0c:	e8 f1 2d 00 00       	call   3902 <exit>
        printf(1, "pipe1 oops 1\n");
     b11:	56                   	push   %esi
     b12:	56                   	push   %esi
     b13:	68 10 41 00 00       	push   $0x4110
     b18:	6a 01                	push   $0x1
     b1a:	e8 51 2f 00 00       	call   3a70 <printf>
        exit();
     b1f:	e8 de 2d 00 00       	call   3902 <exit>
     b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000b30 <preempt>:
{
     b30:	55                   	push   %ebp
     b31:	89 e5                	mov    %esp,%ebp
     b33:	57                   	push   %edi
     b34:	56                   	push   %esi
     b35:	53                   	push   %ebx
     b36:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     b39:	68 5c 41 00 00       	push   $0x415c
     b3e:	6a 01                	push   $0x1
     b40:	e8 2b 2f 00 00       	call   3a70 <printf>
  pid1 = fork();
     b45:	e8 b0 2d 00 00       	call   38fa <fork>
  if(pid1 == 0)
     b4a:	83 c4 10             	add    $0x10,%esp
     b4d:	85 c0                	test   %eax,%eax
     b4f:	75 02                	jne    b53 <preempt+0x23>
     b51:	eb fe                	jmp    b51 <preempt+0x21>
     b53:	89 c7                	mov    %eax,%edi
  pid2 = fork();
     b55:	e8 a0 2d 00 00       	call   38fa <fork>
  if(pid2 == 0)
     b5a:	85 c0                	test   %eax,%eax
  pid2 = fork();
     b5c:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     b5e:	75 02                	jne    b62 <preempt+0x32>
     b60:	eb fe                	jmp    b60 <preempt+0x30>
  pipe(pfds);
     b62:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b65:	83 ec 0c             	sub    $0xc,%esp
     b68:	50                   	push   %eax
     b69:	e8 a4 2d 00 00       	call   3912 <pipe>
  pid3 = fork();
     b6e:	e8 87 2d 00 00       	call   38fa <fork>
  if(pid3 == 0){
     b73:	83 c4 10             	add    $0x10,%esp
     b76:	85 c0                	test   %eax,%eax
  pid3 = fork();
     b78:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     b7a:	75 46                	jne    bc2 <preempt+0x92>
    close(pfds[0]);
     b7c:	83 ec 0c             	sub    $0xc,%esp
     b7f:	ff 75 e0             	pushl  -0x20(%ebp)
     b82:	e8 a3 2d 00 00       	call   392a <close>
    if(write(pfds[1], "x", 1) != 1)
     b87:	83 c4 0c             	add    $0xc,%esp
     b8a:	6a 01                	push   $0x1
     b8c:	68 21 47 00 00       	push   $0x4721
     b91:	ff 75 e4             	pushl  -0x1c(%ebp)
     b94:	e8 89 2d 00 00       	call   3922 <write>
     b99:	83 c4 10             	add    $0x10,%esp
     b9c:	83 e8 01             	sub    $0x1,%eax
     b9f:	74 11                	je     bb2 <preempt+0x82>
      printf(1, "preempt write error");
     ba1:	50                   	push   %eax
     ba2:	50                   	push   %eax
     ba3:	68 66 41 00 00       	push   $0x4166
     ba8:	6a 01                	push   $0x1
     baa:	e8 c1 2e 00 00       	call   3a70 <printf>
     baf:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     bb2:	83 ec 0c             	sub    $0xc,%esp
     bb5:	ff 75 e4             	pushl  -0x1c(%ebp)
     bb8:	e8 6d 2d 00 00       	call   392a <close>
     bbd:	83 c4 10             	add    $0x10,%esp
     bc0:	eb fe                	jmp    bc0 <preempt+0x90>
  close(pfds[1]);
     bc2:	83 ec 0c             	sub    $0xc,%esp
     bc5:	ff 75 e4             	pushl  -0x1c(%ebp)
     bc8:	e8 5d 2d 00 00       	call   392a <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     bcd:	83 c4 0c             	add    $0xc,%esp
     bd0:	68 00 20 00 00       	push   $0x2000
     bd5:	68 e0 86 00 00       	push   $0x86e0
     bda:	ff 75 e0             	pushl  -0x20(%ebp)
     bdd:	e8 38 2d 00 00       	call   391a <read>
     be2:	83 c4 10             	add    $0x10,%esp
     be5:	83 e8 01             	sub    $0x1,%eax
     be8:	74 19                	je     c03 <preempt+0xd3>
    printf(1, "preempt read error");
     bea:	50                   	push   %eax
     beb:	50                   	push   %eax
     bec:	68 7a 41 00 00       	push   $0x417a
     bf1:	6a 01                	push   $0x1
     bf3:	e8 78 2e 00 00       	call   3a70 <printf>
    return;
     bf8:	83 c4 10             	add    $0x10,%esp
}
     bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bfe:	5b                   	pop    %ebx
     bff:	5e                   	pop    %esi
     c00:	5f                   	pop    %edi
     c01:	5d                   	pop    %ebp
     c02:	c3                   	ret    
  close(pfds[0]);
     c03:	83 ec 0c             	sub    $0xc,%esp
     c06:	ff 75 e0             	pushl  -0x20(%ebp)
     c09:	e8 1c 2d 00 00       	call   392a <close>
  printf(1, "kill... ");
     c0e:	58                   	pop    %eax
     c0f:	5a                   	pop    %edx
     c10:	68 8d 41 00 00       	push   $0x418d
     c15:	6a 01                	push   $0x1
     c17:	e8 54 2e 00 00       	call   3a70 <printf>
  kill(pid1);
     c1c:	89 3c 24             	mov    %edi,(%esp)
     c1f:	e8 0e 2d 00 00       	call   3932 <kill>
  kill(pid2);
     c24:	89 34 24             	mov    %esi,(%esp)
     c27:	e8 06 2d 00 00       	call   3932 <kill>
  kill(pid3);
     c2c:	89 1c 24             	mov    %ebx,(%esp)
     c2f:	e8 fe 2c 00 00       	call   3932 <kill>
  printf(1, "wait... ");
     c34:	59                   	pop    %ecx
     c35:	5b                   	pop    %ebx
     c36:	68 96 41 00 00       	push   $0x4196
     c3b:	6a 01                	push   $0x1
     c3d:	e8 2e 2e 00 00       	call   3a70 <printf>
  wait();
     c42:	e8 c3 2c 00 00       	call   390a <wait>
  wait();
     c47:	e8 be 2c 00 00       	call   390a <wait>
  wait();
     c4c:	e8 b9 2c 00 00       	call   390a <wait>
  printf(1, "preempt ok\n");
     c51:	5e                   	pop    %esi
     c52:	5f                   	pop    %edi
     c53:	68 9f 41 00 00       	push   $0x419f
     c58:	6a 01                	push   $0x1
     c5a:	e8 11 2e 00 00       	call   3a70 <printf>
     c5f:	83 c4 10             	add    $0x10,%esp
     c62:	eb 97                	jmp    bfb <preempt+0xcb>
     c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000c70 <exitwait>:
{
     c70:	55                   	push   %ebp
     c71:	89 e5                	mov    %esp,%ebp
     c73:	56                   	push   %esi
     c74:	be 64 00 00 00       	mov    $0x64,%esi
     c79:	53                   	push   %ebx
     c7a:	eb 14                	jmp    c90 <exitwait+0x20>
     c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid){
     c80:	74 6f                	je     cf1 <exitwait+0x81>
      if(wait() != pid){
     c82:	e8 83 2c 00 00       	call   390a <wait>
     c87:	39 d8                	cmp    %ebx,%eax
     c89:	75 2d                	jne    cb8 <exitwait+0x48>
  for(i = 0; i < 100; i++){
     c8b:	83 ee 01             	sub    $0x1,%esi
     c8e:	74 48                	je     cd8 <exitwait+0x68>
    pid = fork();
     c90:	e8 65 2c 00 00       	call   38fa <fork>
    if(pid < 0){
     c95:	85 c0                	test   %eax,%eax
    pid = fork();
     c97:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     c99:	79 e5                	jns    c80 <exitwait+0x10>
      printf(1, "fork failed\n");
     c9b:	83 ec 08             	sub    $0x8,%esp
     c9e:	68 9a 4d 00 00       	push   $0x4d9a
     ca3:	6a 01                	push   $0x1
     ca5:	e8 c6 2d 00 00       	call   3a70 <printf>
      return;
     caa:	83 c4 10             	add    $0x10,%esp
}
     cad:	8d 65 f8             	lea    -0x8(%ebp),%esp
     cb0:	5b                   	pop    %ebx
     cb1:	5e                   	pop    %esi
     cb2:	5d                   	pop    %ebp
     cb3:	c3                   	ret    
     cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
     cb8:	83 ec 08             	sub    $0x8,%esp
     cbb:	68 ab 41 00 00       	push   $0x41ab
     cc0:	6a 01                	push   $0x1
     cc2:	e8 a9 2d 00 00       	call   3a70 <printf>
        return;
     cc7:	83 c4 10             	add    $0x10,%esp
}
     cca:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ccd:	5b                   	pop    %ebx
     cce:	5e                   	pop    %esi
     ccf:	5d                   	pop    %ebp
     cd0:	c3                   	ret    
     cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  printf(1, "exitwait ok\n");
     cd8:	83 ec 08             	sub    $0x8,%esp
     cdb:	68 bb 41 00 00       	push   $0x41bb
     ce0:	6a 01                	push   $0x1
     ce2:	e8 89 2d 00 00       	call   3a70 <printf>
     ce7:	83 c4 10             	add    $0x10,%esp
}
     cea:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ced:	5b                   	pop    %ebx
     cee:	5e                   	pop    %esi
     cef:	5d                   	pop    %ebp
     cf0:	c3                   	ret    
      exit();
     cf1:	e8 0c 2c 00 00       	call   3902 <exit>
     cf6:	8d 76 00             	lea    0x0(%esi),%esi
     cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d00 <mem>:
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	57                   	push   %edi
     d04:	56                   	push   %esi
     d05:	53                   	push   %ebx
     d06:	31 db                	xor    %ebx,%ebx
     d08:	83 ec 14             	sub    $0x14,%esp
  printf(1, "mem test\n");
     d0b:	68 c8 41 00 00       	push   $0x41c8
     d10:	6a 01                	push   $0x1
     d12:	e8 59 2d 00 00       	call   3a70 <printf>
  ppid = getpid();
     d17:	e8 66 2c 00 00       	call   3982 <getpid>
     d1c:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     d1e:	e8 d7 2b 00 00       	call   38fa <fork>
     d23:	83 c4 10             	add    $0x10,%esp
     d26:	85 c0                	test   %eax,%eax
     d28:	74 0a                	je     d34 <mem+0x34>
     d2a:	e9 89 00 00 00       	jmp    db8 <mem+0xb8>
     d2f:	90                   	nop
      *(char**)m2 = m1;
     d30:	89 18                	mov    %ebx,(%eax)
     d32:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     d34:	83 ec 0c             	sub    $0xc,%esp
     d37:	68 11 27 00 00       	push   $0x2711
     d3c:	e8 8f 2f 00 00       	call   3cd0 <malloc>
     d41:	83 c4 10             	add    $0x10,%esp
     d44:	85 c0                	test   %eax,%eax
     d46:	75 e8                	jne    d30 <mem+0x30>
    while(m1){
     d48:	85 db                	test   %ebx,%ebx
     d4a:	74 18                	je     d64 <mem+0x64>
     d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m2 = *(char**)m1;
     d50:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     d52:	83 ec 0c             	sub    $0xc,%esp
     d55:	53                   	push   %ebx
     d56:	89 fb                	mov    %edi,%ebx
     d58:	e8 e3 2e 00 00       	call   3c40 <free>
    while(m1){
     d5d:	83 c4 10             	add    $0x10,%esp
     d60:	85 db                	test   %ebx,%ebx
     d62:	75 ec                	jne    d50 <mem+0x50>
    m1 = malloc(1024*20);
     d64:	83 ec 0c             	sub    $0xc,%esp
     d67:	68 00 50 00 00       	push   $0x5000
     d6c:	e8 5f 2f 00 00       	call   3cd0 <malloc>
    if(m1 == 0){
     d71:	83 c4 10             	add    $0x10,%esp
     d74:	85 c0                	test   %eax,%eax
     d76:	74 20                	je     d98 <mem+0x98>
    free(m1);
     d78:	83 ec 0c             	sub    $0xc,%esp
     d7b:	50                   	push   %eax
     d7c:	e8 bf 2e 00 00       	call   3c40 <free>
    printf(1, "mem ok\n");
     d81:	58                   	pop    %eax
     d82:	5a                   	pop    %edx
     d83:	68 ec 41 00 00       	push   $0x41ec
     d88:	6a 01                	push   $0x1
     d8a:	e8 e1 2c 00 00       	call   3a70 <printf>
    exit();
     d8f:	e8 6e 2b 00 00       	call   3902 <exit>
     d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "couldn't allocate mem?!!\n");
     d98:	83 ec 08             	sub    $0x8,%esp
     d9b:	68 d2 41 00 00       	push   $0x41d2
     da0:	6a 01                	push   $0x1
     da2:	e8 c9 2c 00 00       	call   3a70 <printf>
      kill(ppid);
     da7:	89 34 24             	mov    %esi,(%esp)
     daa:	e8 83 2b 00 00       	call   3932 <kill>
      exit();
     daf:	e8 4e 2b 00 00       	call   3902 <exit>
     db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
     db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     dbb:	5b                   	pop    %ebx
     dbc:	5e                   	pop    %esi
     dbd:	5f                   	pop    %edi
     dbe:	5d                   	pop    %ebp
    wait();
     dbf:	e9 46 2b 00 00       	jmp    390a <wait>
     dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000dd0 <sharedfd>:
{
     dd0:	55                   	push   %ebp
     dd1:	89 e5                	mov    %esp,%ebp
     dd3:	57                   	push   %edi
     dd4:	56                   	push   %esi
     dd5:	53                   	push   %ebx
     dd6:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
     dd9:	68 f4 41 00 00       	push   $0x41f4
     dde:	6a 01                	push   $0x1
     de0:	e8 8b 2c 00 00       	call   3a70 <printf>
  unlink("sharedfd");
     de5:	c7 04 24 03 42 00 00 	movl   $0x4203,(%esp)
     dec:	e8 61 2b 00 00       	call   3952 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     df1:	59                   	pop    %ecx
     df2:	5b                   	pop    %ebx
     df3:	68 02 02 00 00       	push   $0x202
     df8:	68 03 42 00 00       	push   $0x4203
     dfd:	e8 40 2b 00 00       	call   3942 <open>
  if(fd < 0){
     e02:	83 c4 10             	add    $0x10,%esp
     e05:	85 c0                	test   %eax,%eax
     e07:	0f 88 33 01 00 00    	js     f40 <sharedfd+0x170>
     e0d:	89 c6                	mov    %eax,%esi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e0f:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
     e14:	e8 e1 2a 00 00       	call   38fa <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e19:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
     e1c:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e1e:	19 c0                	sbb    %eax,%eax
     e20:	83 ec 04             	sub    $0x4,%esp
     e23:	83 e0 f3             	and    $0xfffffff3,%eax
     e26:	6a 0a                	push   $0xa
     e28:	83 c0 70             	add    $0x70,%eax
     e2b:	50                   	push   %eax
     e2c:	8d 45 de             	lea    -0x22(%ebp),%eax
     e2f:	50                   	push   %eax
     e30:	e8 2b 29 00 00       	call   3760 <memset>
     e35:	83 c4 10             	add    $0x10,%esp
     e38:	eb 0b                	jmp    e45 <sharedfd+0x75>
     e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; i < 1000; i++){
     e40:	83 eb 01             	sub    $0x1,%ebx
     e43:	74 29                	je     e6e <sharedfd+0x9e>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     e45:	8d 45 de             	lea    -0x22(%ebp),%eax
     e48:	83 ec 04             	sub    $0x4,%esp
     e4b:	6a 0a                	push   $0xa
     e4d:	50                   	push   %eax
     e4e:	56                   	push   %esi
     e4f:	e8 ce 2a 00 00       	call   3922 <write>
     e54:	83 c4 10             	add    $0x10,%esp
     e57:	83 f8 0a             	cmp    $0xa,%eax
     e5a:	74 e4                	je     e40 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
     e5c:	83 ec 08             	sub    $0x8,%esp
     e5f:	68 84 4f 00 00       	push   $0x4f84
     e64:	6a 01                	push   $0x1
     e66:	e8 05 2c 00 00       	call   3a70 <printf>
      break;
     e6b:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
     e6e:	85 ff                	test   %edi,%edi
     e70:	0f 84 fe 00 00 00    	je     f74 <sharedfd+0x1a4>
    wait();
     e76:	e8 8f 2a 00 00       	call   390a <wait>
  close(fd);
     e7b:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
     e7e:	31 db                	xor    %ebx,%ebx
     e80:	31 ff                	xor    %edi,%edi
  close(fd);
     e82:	56                   	push   %esi
     e83:	8d 75 e8             	lea    -0x18(%ebp),%esi
     e86:	e8 9f 2a 00 00       	call   392a <close>
  fd = open("sharedfd", 0);
     e8b:	58                   	pop    %eax
     e8c:	5a                   	pop    %edx
     e8d:	6a 00                	push   $0x0
     e8f:	68 03 42 00 00       	push   $0x4203
     e94:	e8 a9 2a 00 00       	call   3942 <open>
  if(fd < 0){
     e99:	83 c4 10             	add    $0x10,%esp
     e9c:	85 c0                	test   %eax,%eax
  fd = open("sharedfd", 0);
     e9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
     ea1:	0f 88 b3 00 00 00    	js     f5a <sharedfd+0x18a>
     ea7:	89 f8                	mov    %edi,%eax
     ea9:	89 df                	mov    %ebx,%edi
     eab:	89 c3                	mov    %eax,%ebx
     ead:	8d 76 00             	lea    0x0(%esi),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0){
     eb0:	8d 45 de             	lea    -0x22(%ebp),%eax
     eb3:	83 ec 04             	sub    $0x4,%esp
     eb6:	6a 0a                	push   $0xa
     eb8:	50                   	push   %eax
     eb9:	ff 75 d4             	pushl  -0x2c(%ebp)
     ebc:	e8 59 2a 00 00       	call   391a <read>
     ec1:	83 c4 10             	add    $0x10,%esp
     ec4:	85 c0                	test   %eax,%eax
     ec6:	7e 28                	jle    ef0 <sharedfd+0x120>
     ec8:	8d 45 de             	lea    -0x22(%ebp),%eax
     ecb:	eb 15                	jmp    ee2 <sharedfd+0x112>
     ecd:	8d 76 00             	lea    0x0(%esi),%esi
        np++;
     ed0:	80 fa 70             	cmp    $0x70,%dl
     ed3:	0f 94 c2             	sete   %dl
     ed6:	0f b6 d2             	movzbl %dl,%edx
     ed9:	01 d7                	add    %edx,%edi
     edb:	83 c0 01             	add    $0x1,%eax
    for(i = 0; i < sizeof(buf); i++){
     ede:	39 f0                	cmp    %esi,%eax
     ee0:	74 ce                	je     eb0 <sharedfd+0xe0>
      if(buf[i] == 'c')
     ee2:	0f b6 10             	movzbl (%eax),%edx
     ee5:	80 fa 63             	cmp    $0x63,%dl
     ee8:	75 e6                	jne    ed0 <sharedfd+0x100>
        nc++;
     eea:	83 c3 01             	add    $0x1,%ebx
     eed:	eb ec                	jmp    edb <sharedfd+0x10b>
     eef:	90                   	nop
  close(fd);
     ef0:	83 ec 0c             	sub    $0xc,%esp
     ef3:	89 d8                	mov    %ebx,%eax
     ef5:	ff 75 d4             	pushl  -0x2c(%ebp)
     ef8:	89 fb                	mov    %edi,%ebx
     efa:	89 c7                	mov    %eax,%edi
     efc:	e8 29 2a 00 00       	call   392a <close>
  unlink("sharedfd");
     f01:	c7 04 24 03 42 00 00 	movl   $0x4203,(%esp)
     f08:	e8 45 2a 00 00       	call   3952 <unlink>
  if(nc == 10000 && np == 10000){
     f0d:	83 c4 10             	add    $0x10,%esp
     f10:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     f16:	75 61                	jne    f79 <sharedfd+0x1a9>
     f18:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     f1e:	75 59                	jne    f79 <sharedfd+0x1a9>
    printf(1, "sharedfd ok\n");
     f20:	83 ec 08             	sub    $0x8,%esp
     f23:	68 0c 42 00 00       	push   $0x420c
     f28:	6a 01                	push   $0x1
     f2a:	e8 41 2b 00 00       	call   3a70 <printf>
     f2f:	83 c4 10             	add    $0x10,%esp
}
     f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f35:	5b                   	pop    %ebx
     f36:	5e                   	pop    %esi
     f37:	5f                   	pop    %edi
     f38:	5d                   	pop    %ebp
     f39:	c3                   	ret    
     f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "fstests: cannot open sharedfd for writing");
     f40:	83 ec 08             	sub    $0x8,%esp
     f43:	68 58 4f 00 00       	push   $0x4f58
     f48:	6a 01                	push   $0x1
     f4a:	e8 21 2b 00 00       	call   3a70 <printf>
    return;
     f4f:	83 c4 10             	add    $0x10,%esp
}
     f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f55:	5b                   	pop    %ebx
     f56:	5e                   	pop    %esi
     f57:	5f                   	pop    %edi
     f58:	5d                   	pop    %ebp
     f59:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f5a:	83 ec 08             	sub    $0x8,%esp
     f5d:	68 a4 4f 00 00       	push   $0x4fa4
     f62:	6a 01                	push   $0x1
     f64:	e8 07 2b 00 00       	call   3a70 <printf>
    return;
     f69:	83 c4 10             	add    $0x10,%esp
}
     f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f6f:	5b                   	pop    %ebx
     f70:	5e                   	pop    %esi
     f71:	5f                   	pop    %edi
     f72:	5d                   	pop    %ebp
     f73:	c3                   	ret    
    exit();
     f74:	e8 89 29 00 00       	call   3902 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
     f79:	53                   	push   %ebx
     f7a:	57                   	push   %edi
     f7b:	68 19 42 00 00       	push   $0x4219
     f80:	6a 01                	push   $0x1
     f82:	e8 e9 2a 00 00       	call   3a70 <printf>
    exit();
     f87:	e8 76 29 00 00       	call   3902 <exit>
     f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f90 <fourfiles>:
{
     f90:	55                   	push   %ebp
     f91:	89 e5                	mov    %esp,%ebp
     f93:	57                   	push   %edi
     f94:	56                   	push   %esi
     f95:	53                   	push   %ebx
  printf(1, "fourfiles test\n");
     f96:	be 2e 42 00 00       	mov    $0x422e,%esi
  for(pi = 0; pi < 4; pi++){
     f9b:	31 db                	xor    %ebx,%ebx
{
     f9d:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
     fa0:	c7 45 d8 2e 42 00 00 	movl   $0x422e,-0x28(%ebp)
     fa7:	c7 45 dc 77 43 00 00 	movl   $0x4377,-0x24(%ebp)
  printf(1, "fourfiles test\n");
     fae:	68 34 42 00 00       	push   $0x4234
     fb3:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
     fb5:	c7 45 e0 7b 43 00 00 	movl   $0x437b,-0x20(%ebp)
     fbc:	c7 45 e4 31 42 00 00 	movl   $0x4231,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
     fc3:	e8 a8 2a 00 00       	call   3a70 <printf>
     fc8:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
     fcb:	83 ec 0c             	sub    $0xc,%esp
     fce:	56                   	push   %esi
     fcf:	e8 7e 29 00 00       	call   3952 <unlink>
    pid = fork();
     fd4:	e8 21 29 00 00       	call   38fa <fork>
    if(pid < 0){
     fd9:	83 c4 10             	add    $0x10,%esp
     fdc:	85 c0                	test   %eax,%eax
     fde:	0f 88 68 01 00 00    	js     114c <fourfiles+0x1bc>
    if(pid == 0){
     fe4:	0f 84 df 00 00 00    	je     10c9 <fourfiles+0x139>
  for(pi = 0; pi < 4; pi++){
     fea:	83 c3 01             	add    $0x1,%ebx
     fed:	83 fb 04             	cmp    $0x4,%ebx
     ff0:	74 06                	je     ff8 <fourfiles+0x68>
     ff2:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
     ff6:	eb d3                	jmp    fcb <fourfiles+0x3b>
    wait();
     ff8:	e8 0d 29 00 00       	call   390a <wait>
  for(i = 0; i < 2; i++){
     ffd:	31 ff                	xor    %edi,%edi
    wait();
     fff:	e8 06 29 00 00       	call   390a <wait>
    1004:	e8 01 29 00 00       	call   390a <wait>
    1009:	e8 fc 28 00 00       	call   390a <wait>
    100e:	c7 45 d0 2e 42 00 00 	movl   $0x422e,-0x30(%ebp)
    fd = open(fname, 0);
    1015:	83 ec 08             	sub    $0x8,%esp
    total = 0;
    1018:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
    101a:	6a 00                	push   $0x0
    101c:	ff 75 d0             	pushl  -0x30(%ebp)
    101f:	e8 1e 29 00 00       	call   3942 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1024:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
    1027:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1030:	83 ec 04             	sub    $0x4,%esp
    1033:	68 00 20 00 00       	push   $0x2000
    1038:	68 e0 86 00 00       	push   $0x86e0
    103d:	ff 75 d4             	pushl  -0x2c(%ebp)
    1040:	e8 d5 28 00 00       	call   391a <read>
    1045:	83 c4 10             	add    $0x10,%esp
    1048:	85 c0                	test   %eax,%eax
    104a:	7e 26                	jle    1072 <fourfiles+0xe2>
      for(j = 0; j < n; j++){
    104c:	31 d2                	xor    %edx,%edx
    104e:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
    1050:	0f be b2 e0 86 00 00 	movsbl 0x86e0(%edx),%esi
    1057:	83 ff 01             	cmp    $0x1,%edi
    105a:	19 c9                	sbb    %ecx,%ecx
    105c:	83 c1 31             	add    $0x31,%ecx
    105f:	39 ce                	cmp    %ecx,%esi
    1061:	0f 85 be 00 00 00    	jne    1125 <fourfiles+0x195>
      for(j = 0; j < n; j++){
    1067:	83 c2 01             	add    $0x1,%edx
    106a:	39 d0                	cmp    %edx,%eax
    106c:	75 e2                	jne    1050 <fourfiles+0xc0>
      total += n;
    106e:	01 c3                	add    %eax,%ebx
    1070:	eb be                	jmp    1030 <fourfiles+0xa0>
    close(fd);
    1072:	83 ec 0c             	sub    $0xc,%esp
    1075:	ff 75 d4             	pushl  -0x2c(%ebp)
    1078:	e8 ad 28 00 00       	call   392a <close>
    if(total != 12*500){
    107d:	83 c4 10             	add    $0x10,%esp
    1080:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    1086:	0f 85 d3 00 00 00    	jne    115f <fourfiles+0x1cf>
    unlink(fname);
    108c:	83 ec 0c             	sub    $0xc,%esp
    108f:	ff 75 d0             	pushl  -0x30(%ebp)
    1092:	e8 bb 28 00 00       	call   3952 <unlink>
  for(i = 0; i < 2; i++){
    1097:	83 c4 10             	add    $0x10,%esp
    109a:	83 ff 01             	cmp    $0x1,%edi
    109d:	75 1a                	jne    10b9 <fourfiles+0x129>
  printf(1, "fourfiles ok\n");
    109f:	83 ec 08             	sub    $0x8,%esp
    10a2:	68 72 42 00 00       	push   $0x4272
    10a7:	6a 01                	push   $0x1
    10a9:	e8 c2 29 00 00       	call   3a70 <printf>
}
    10ae:	83 c4 10             	add    $0x10,%esp
    10b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10b4:	5b                   	pop    %ebx
    10b5:	5e                   	pop    %esi
    10b6:	5f                   	pop    %edi
    10b7:	5d                   	pop    %ebp
    10b8:	c3                   	ret    
    10b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
    10bc:	bf 01 00 00 00       	mov    $0x1,%edi
    10c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    10c4:	e9 4c ff ff ff       	jmp    1015 <fourfiles+0x85>
      fd = open(fname, O_CREATE | O_RDWR);
    10c9:	83 ec 08             	sub    $0x8,%esp
    10cc:	68 02 02 00 00       	push   $0x202
    10d1:	56                   	push   %esi
    10d2:	e8 6b 28 00 00       	call   3942 <open>
      if(fd < 0){
    10d7:	83 c4 10             	add    $0x10,%esp
    10da:	85 c0                	test   %eax,%eax
      fd = open(fname, O_CREATE | O_RDWR);
    10dc:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    10de:	78 59                	js     1139 <fourfiles+0x1a9>
      memset(buf, '0'+pi, 512);
    10e0:	83 ec 04             	sub    $0x4,%esp
    10e3:	83 c3 30             	add    $0x30,%ebx
    10e6:	68 00 02 00 00       	push   $0x200
    10eb:	53                   	push   %ebx
    10ec:	bb 0c 00 00 00       	mov    $0xc,%ebx
    10f1:	68 e0 86 00 00       	push   $0x86e0
    10f6:	e8 65 26 00 00       	call   3760 <memset>
    10fb:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    10fe:	83 ec 04             	sub    $0x4,%esp
    1101:	68 f4 01 00 00       	push   $0x1f4
    1106:	68 e0 86 00 00       	push   $0x86e0
    110b:	56                   	push   %esi
    110c:	e8 11 28 00 00       	call   3922 <write>
    1111:	83 c4 10             	add    $0x10,%esp
    1114:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1119:	75 57                	jne    1172 <fourfiles+0x1e2>
      for(i = 0; i < 12; i++){
    111b:	83 eb 01             	sub    $0x1,%ebx
    111e:	75 de                	jne    10fe <fourfiles+0x16e>
      exit();
    1120:	e8 dd 27 00 00       	call   3902 <exit>
          printf(1, "wrong char\n");
    1125:	83 ec 08             	sub    $0x8,%esp
    1128:	68 55 42 00 00       	push   $0x4255
    112d:	6a 01                	push   $0x1
    112f:	e8 3c 29 00 00       	call   3a70 <printf>
          exit();
    1134:	e8 c9 27 00 00       	call   3902 <exit>
        printf(1, "create failed\n");
    1139:	51                   	push   %ecx
    113a:	51                   	push   %ecx
    113b:	68 cf 44 00 00       	push   $0x44cf
    1140:	6a 01                	push   $0x1
    1142:	e8 29 29 00 00       	call   3a70 <printf>
        exit();
    1147:	e8 b6 27 00 00       	call   3902 <exit>
      printf(1, "fork failed\n");
    114c:	53                   	push   %ebx
    114d:	53                   	push   %ebx
    114e:	68 9a 4d 00 00       	push   $0x4d9a
    1153:	6a 01                	push   $0x1
    1155:	e8 16 29 00 00       	call   3a70 <printf>
      exit();
    115a:	e8 a3 27 00 00       	call   3902 <exit>
      printf(1, "wrong length %d\n", total);
    115f:	50                   	push   %eax
    1160:	53                   	push   %ebx
    1161:	68 61 42 00 00       	push   $0x4261
    1166:	6a 01                	push   $0x1
    1168:	e8 03 29 00 00       	call   3a70 <printf>
      exit();
    116d:	e8 90 27 00 00       	call   3902 <exit>
          printf(1, "write failed %d\n", n);
    1172:	52                   	push   %edx
    1173:	50                   	push   %eax
    1174:	68 44 42 00 00       	push   $0x4244
    1179:	6a 01                	push   $0x1
    117b:	e8 f0 28 00 00       	call   3a70 <printf>
          exit();
    1180:	e8 7d 27 00 00       	call   3902 <exit>
    1185:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001190 <createdelete>:
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	57                   	push   %edi
    1194:	56                   	push   %esi
    1195:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    1196:	31 db                	xor    %ebx,%ebx
{
    1198:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    119b:	68 80 42 00 00       	push   $0x4280
    11a0:	6a 01                	push   $0x1
    11a2:	e8 c9 28 00 00       	call   3a70 <printf>
    11a7:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    11aa:	e8 4b 27 00 00       	call   38fa <fork>
    if(pid < 0){
    11af:	85 c0                	test   %eax,%eax
    11b1:	0f 88 be 01 00 00    	js     1375 <createdelete+0x1e5>
    if(pid == 0){
    11b7:	0f 84 0b 01 00 00    	je     12c8 <createdelete+0x138>
  for(pi = 0; pi < 4; pi++){
    11bd:	83 c3 01             	add    $0x1,%ebx
    11c0:	83 fb 04             	cmp    $0x4,%ebx
    11c3:	75 e5                	jne    11aa <createdelete+0x1a>
    11c5:	8d 7d c8             	lea    -0x38(%ebp),%edi
  name[0] = name[1] = name[2] = 0;
    11c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
    wait();
    11cd:	e8 38 27 00 00       	call   390a <wait>
    11d2:	e8 33 27 00 00       	call   390a <wait>
    11d7:	e8 2e 27 00 00       	call   390a <wait>
    11dc:	e8 29 27 00 00       	call   390a <wait>
  name[0] = name[1] = name[2] = 0;
    11e1:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    11e5:	8d 76 00             	lea    0x0(%esi),%esi
    11e8:	8d 46 31             	lea    0x31(%esi),%eax
    11eb:	88 45 c7             	mov    %al,-0x39(%ebp)
    11ee:	8d 46 01             	lea    0x1(%esi),%eax
    11f1:	83 f8 09             	cmp    $0x9,%eax
    11f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    11f7:	0f 9f c3             	setg   %bl
    11fa:	85 c0                	test   %eax,%eax
    11fc:	0f 94 c0             	sete   %al
    11ff:	09 c3                	or     %eax,%ebx
    1201:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    1204:	bb 70 00 00 00       	mov    $0x70,%ebx
      name[1] = '0' + i;
    1209:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      fd = open(name, 0);
    120d:	83 ec 08             	sub    $0x8,%esp
      name[0] = 'p' + pi;
    1210:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    1213:	6a 00                	push   $0x0
    1215:	57                   	push   %edi
      name[1] = '0' + i;
    1216:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1219:	e8 24 27 00 00       	call   3942 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    121e:	83 c4 10             	add    $0x10,%esp
    1221:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    1225:	0f 84 85 00 00 00    	je     12b0 <createdelete+0x120>
    122b:	85 c0                	test   %eax,%eax
    122d:	0f 88 1a 01 00 00    	js     134d <createdelete+0x1bd>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1233:	83 fe 08             	cmp    $0x8,%esi
    1236:	0f 86 54 01 00 00    	jbe    1390 <createdelete+0x200>
        close(fd);
    123c:	83 ec 0c             	sub    $0xc,%esp
    123f:	50                   	push   %eax
    1240:	e8 e5 26 00 00       	call   392a <close>
    1245:	83 c4 10             	add    $0x10,%esp
    1248:	83 c3 01             	add    $0x1,%ebx
    for(pi = 0; pi < 4; pi++){
    124b:	80 fb 74             	cmp    $0x74,%bl
    124e:	75 b9                	jne    1209 <createdelete+0x79>
    1250:	8b 75 c0             	mov    -0x40(%ebp),%esi
  for(i = 0; i < N; i++){
    1253:	83 fe 13             	cmp    $0x13,%esi
    1256:	75 90                	jne    11e8 <createdelete+0x58>
    1258:	be 70 00 00 00       	mov    $0x70,%esi
    125d:	8d 76 00             	lea    0x0(%esi),%esi
    1260:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    1263:	bb 04 00 00 00       	mov    $0x4,%ebx
    1268:	88 45 c7             	mov    %al,-0x39(%ebp)
      name[0] = 'p' + i;
    126b:	89 f0                	mov    %esi,%eax
      unlink(name);
    126d:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    1270:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1273:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      unlink(name);
    1277:	57                   	push   %edi
      name[1] = '0' + i;
    1278:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    127b:	e8 d2 26 00 00       	call   3952 <unlink>
    for(pi = 0; pi < 4; pi++){
    1280:	83 c4 10             	add    $0x10,%esp
    1283:	83 eb 01             	sub    $0x1,%ebx
    1286:	75 e3                	jne    126b <createdelete+0xdb>
    1288:	83 c6 01             	add    $0x1,%esi
  for(i = 0; i < N; i++){
    128b:	89 f0                	mov    %esi,%eax
    128d:	3c 84                	cmp    $0x84,%al
    128f:	75 cf                	jne    1260 <createdelete+0xd0>
  printf(1, "createdelete ok\n");
    1291:	83 ec 08             	sub    $0x8,%esp
    1294:	68 93 42 00 00       	push   $0x4293
    1299:	6a 01                	push   $0x1
    129b:	e8 d0 27 00 00       	call   3a70 <printf>
}
    12a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12a3:	5b                   	pop    %ebx
    12a4:	5e                   	pop    %esi
    12a5:	5f                   	pop    %edi
    12a6:	5d                   	pop    %ebp
    12a7:	c3                   	ret    
    12a8:	90                   	nop
    12a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12b0:	83 fe 08             	cmp    $0x8,%esi
    12b3:	0f 86 cf 00 00 00    	jbe    1388 <createdelete+0x1f8>
      if(fd >= 0)
    12b9:	85 c0                	test   %eax,%eax
    12bb:	78 8b                	js     1248 <createdelete+0xb8>
    12bd:	e9 7a ff ff ff       	jmp    123c <createdelete+0xac>
    12c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    12c8:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    12cb:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    12cf:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    12d2:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    12d5:	31 db                	xor    %ebx,%ebx
    12d7:	eb 0f                	jmp    12e8 <createdelete+0x158>
    12d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    12e0:	83 fb 13             	cmp    $0x13,%ebx
    12e3:	74 63                	je     1348 <createdelete+0x1b8>
    12e5:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    12e8:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    12eb:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    12ee:	68 02 02 00 00       	push   $0x202
    12f3:	57                   	push   %edi
        name[1] = '0' + i;
    12f4:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12f7:	e8 46 26 00 00       	call   3942 <open>
        if(fd < 0){
    12fc:	83 c4 10             	add    $0x10,%esp
    12ff:	85 c0                	test   %eax,%eax
    1301:	78 5f                	js     1362 <createdelete+0x1d2>
        close(fd);
    1303:	83 ec 0c             	sub    $0xc,%esp
    1306:	50                   	push   %eax
    1307:	e8 1e 26 00 00       	call   392a <close>
        if(i > 0 && (i % 2 ) == 0){
    130c:	83 c4 10             	add    $0x10,%esp
    130f:	85 db                	test   %ebx,%ebx
    1311:	74 d2                	je     12e5 <createdelete+0x155>
    1313:	f6 c3 01             	test   $0x1,%bl
    1316:	75 c8                	jne    12e0 <createdelete+0x150>
          if(unlink(name) < 0){
    1318:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    131b:	89 d8                	mov    %ebx,%eax
    131d:	d1 f8                	sar    %eax
          if(unlink(name) < 0){
    131f:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    1320:	83 c0 30             	add    $0x30,%eax
    1323:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1326:	e8 27 26 00 00       	call   3952 <unlink>
    132b:	83 c4 10             	add    $0x10,%esp
    132e:	85 c0                	test   %eax,%eax
    1330:	79 ae                	jns    12e0 <createdelete+0x150>
            printf(1, "unlink failed\n");
    1332:	52                   	push   %edx
    1333:	52                   	push   %edx
    1334:	68 81 3e 00 00       	push   $0x3e81
    1339:	6a 01                	push   $0x1
    133b:	e8 30 27 00 00       	call   3a70 <printf>
            exit();
    1340:	e8 bd 25 00 00       	call   3902 <exit>
    1345:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    1348:	e8 b5 25 00 00       	call   3902 <exit>
        printf(1, "oops createdelete %s didn't exist\n", name);
    134d:	83 ec 04             	sub    $0x4,%esp
    1350:	57                   	push   %edi
    1351:	68 d0 4f 00 00       	push   $0x4fd0
    1356:	6a 01                	push   $0x1
    1358:	e8 13 27 00 00       	call   3a70 <printf>
        exit();
    135d:	e8 a0 25 00 00       	call   3902 <exit>
          printf(1, "create failed\n");
    1362:	51                   	push   %ecx
    1363:	51                   	push   %ecx
    1364:	68 cf 44 00 00       	push   $0x44cf
    1369:	6a 01                	push   $0x1
    136b:	e8 00 27 00 00       	call   3a70 <printf>
          exit();
    1370:	e8 8d 25 00 00       	call   3902 <exit>
      printf(1, "fork failed\n");
    1375:	53                   	push   %ebx
    1376:	53                   	push   %ebx
    1377:	68 9a 4d 00 00       	push   $0x4d9a
    137c:	6a 01                	push   $0x1
    137e:	e8 ed 26 00 00       	call   3a70 <printf>
      exit();
    1383:	e8 7a 25 00 00       	call   3902 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1388:	85 c0                	test   %eax,%eax
    138a:	0f 88 b8 fe ff ff    	js     1248 <createdelete+0xb8>
        printf(1, "oops createdelete %s did exist\n", name);
    1390:	50                   	push   %eax
    1391:	57                   	push   %edi
    1392:	68 f4 4f 00 00       	push   $0x4ff4
    1397:	6a 01                	push   $0x1
    1399:	e8 d2 26 00 00       	call   3a70 <printf>
        exit();
    139e:	e8 5f 25 00 00       	call   3902 <exit>
    13a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    13a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000013b0 <unlinkread>:
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
    13b3:	56                   	push   %esi
    13b4:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    13b5:	83 ec 08             	sub    $0x8,%esp
    13b8:	68 a4 42 00 00       	push   $0x42a4
    13bd:	6a 01                	push   $0x1
    13bf:	e8 ac 26 00 00       	call   3a70 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    13c4:	5b                   	pop    %ebx
    13c5:	5e                   	pop    %esi
    13c6:	68 02 02 00 00       	push   $0x202
    13cb:	68 b5 42 00 00       	push   $0x42b5
    13d0:	e8 6d 25 00 00       	call   3942 <open>
  if(fd < 0){
    13d5:	83 c4 10             	add    $0x10,%esp
    13d8:	85 c0                	test   %eax,%eax
    13da:	0f 88 e6 00 00 00    	js     14c6 <unlinkread+0x116>
  write(fd, "hello", 5);
    13e0:	83 ec 04             	sub    $0x4,%esp
    13e3:	89 c3                	mov    %eax,%ebx
    13e5:	6a 05                	push   $0x5
    13e7:	68 da 42 00 00       	push   $0x42da
    13ec:	50                   	push   %eax
    13ed:	e8 30 25 00 00       	call   3922 <write>
  close(fd);
    13f2:	89 1c 24             	mov    %ebx,(%esp)
    13f5:	e8 30 25 00 00       	call   392a <close>
  fd = open("unlinkread", O_RDWR);
    13fa:	58                   	pop    %eax
    13fb:	5a                   	pop    %edx
    13fc:	6a 02                	push   $0x2
    13fe:	68 b5 42 00 00       	push   $0x42b5
    1403:	e8 3a 25 00 00       	call   3942 <open>
  if(fd < 0){
    1408:	83 c4 10             	add    $0x10,%esp
    140b:	85 c0                	test   %eax,%eax
  fd = open("unlinkread", O_RDWR);
    140d:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    140f:	0f 88 10 01 00 00    	js     1525 <unlinkread+0x175>
  if(unlink("unlinkread") != 0){
    1415:	83 ec 0c             	sub    $0xc,%esp
    1418:	68 b5 42 00 00       	push   $0x42b5
    141d:	e8 30 25 00 00       	call   3952 <unlink>
    1422:	83 c4 10             	add    $0x10,%esp
    1425:	85 c0                	test   %eax,%eax
    1427:	0f 85 e5 00 00 00    	jne    1512 <unlinkread+0x162>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    142d:	83 ec 08             	sub    $0x8,%esp
    1430:	68 02 02 00 00       	push   $0x202
    1435:	68 b5 42 00 00       	push   $0x42b5
    143a:	e8 03 25 00 00       	call   3942 <open>
  write(fd1, "yyy", 3);
    143f:	83 c4 0c             	add    $0xc,%esp
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1442:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    1444:	6a 03                	push   $0x3
    1446:	68 12 43 00 00       	push   $0x4312
    144b:	50                   	push   %eax
    144c:	e8 d1 24 00 00       	call   3922 <write>
  close(fd1);
    1451:	89 34 24             	mov    %esi,(%esp)
    1454:	e8 d1 24 00 00       	call   392a <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    1459:	83 c4 0c             	add    $0xc,%esp
    145c:	68 00 20 00 00       	push   $0x2000
    1461:	68 e0 86 00 00       	push   $0x86e0
    1466:	53                   	push   %ebx
    1467:	e8 ae 24 00 00       	call   391a <read>
    146c:	83 c4 10             	add    $0x10,%esp
    146f:	83 f8 05             	cmp    $0x5,%eax
    1472:	0f 85 87 00 00 00    	jne    14ff <unlinkread+0x14f>
  if(buf[0] != 'h'){
    1478:	80 3d e0 86 00 00 68 	cmpb   $0x68,0x86e0
    147f:	75 6b                	jne    14ec <unlinkread+0x13c>
  if(write(fd, buf, 10) != 10){
    1481:	83 ec 04             	sub    $0x4,%esp
    1484:	6a 0a                	push   $0xa
    1486:	68 e0 86 00 00       	push   $0x86e0
    148b:	53                   	push   %ebx
    148c:	e8 91 24 00 00       	call   3922 <write>
    1491:	83 c4 10             	add    $0x10,%esp
    1494:	83 f8 0a             	cmp    $0xa,%eax
    1497:	75 40                	jne    14d9 <unlinkread+0x129>
  close(fd);
    1499:	83 ec 0c             	sub    $0xc,%esp
    149c:	53                   	push   %ebx
    149d:	e8 88 24 00 00       	call   392a <close>
  unlink("unlinkread");
    14a2:	c7 04 24 b5 42 00 00 	movl   $0x42b5,(%esp)
    14a9:	e8 a4 24 00 00       	call   3952 <unlink>
  printf(1, "unlinkread ok\n");
    14ae:	58                   	pop    %eax
    14af:	5a                   	pop    %edx
    14b0:	68 5d 43 00 00       	push   $0x435d
    14b5:	6a 01                	push   $0x1
    14b7:	e8 b4 25 00 00       	call   3a70 <printf>
}
    14bc:	83 c4 10             	add    $0x10,%esp
    14bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
    14c2:	5b                   	pop    %ebx
    14c3:	5e                   	pop    %esi
    14c4:	5d                   	pop    %ebp
    14c5:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    14c6:	51                   	push   %ecx
    14c7:	51                   	push   %ecx
    14c8:	68 c0 42 00 00       	push   $0x42c0
    14cd:	6a 01                	push   $0x1
    14cf:	e8 9c 25 00 00       	call   3a70 <printf>
    exit();
    14d4:	e8 29 24 00 00       	call   3902 <exit>
    printf(1, "unlinkread write failed\n");
    14d9:	51                   	push   %ecx
    14da:	51                   	push   %ecx
    14db:	68 44 43 00 00       	push   $0x4344
    14e0:	6a 01                	push   $0x1
    14e2:	e8 89 25 00 00       	call   3a70 <printf>
    exit();
    14e7:	e8 16 24 00 00       	call   3902 <exit>
    printf(1, "unlinkread wrong data\n");
    14ec:	53                   	push   %ebx
    14ed:	53                   	push   %ebx
    14ee:	68 2d 43 00 00       	push   $0x432d
    14f3:	6a 01                	push   $0x1
    14f5:	e8 76 25 00 00       	call   3a70 <printf>
    exit();
    14fa:	e8 03 24 00 00       	call   3902 <exit>
    printf(1, "unlinkread read failed");
    14ff:	56                   	push   %esi
    1500:	56                   	push   %esi
    1501:	68 16 43 00 00       	push   $0x4316
    1506:	6a 01                	push   $0x1
    1508:	e8 63 25 00 00       	call   3a70 <printf>
    exit();
    150d:	e8 f0 23 00 00       	call   3902 <exit>
    printf(1, "unlink unlinkread failed\n");
    1512:	50                   	push   %eax
    1513:	50                   	push   %eax
    1514:	68 f8 42 00 00       	push   $0x42f8
    1519:	6a 01                	push   $0x1
    151b:	e8 50 25 00 00       	call   3a70 <printf>
    exit();
    1520:	e8 dd 23 00 00       	call   3902 <exit>
    printf(1, "open unlinkread failed\n");
    1525:	50                   	push   %eax
    1526:	50                   	push   %eax
    1527:	68 e0 42 00 00       	push   $0x42e0
    152c:	6a 01                	push   $0x1
    152e:	e8 3d 25 00 00       	call   3a70 <printf>
    exit();
    1533:	e8 ca 23 00 00       	call   3902 <exit>
    1538:	90                   	nop
    1539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001540 <linktest>:
{
    1540:	55                   	push   %ebp
    1541:	89 e5                	mov    %esp,%ebp
    1543:	53                   	push   %ebx
    1544:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    1547:	68 6c 43 00 00       	push   $0x436c
    154c:	6a 01                	push   $0x1
    154e:	e8 1d 25 00 00       	call   3a70 <printf>
  unlink("lf1");
    1553:	c7 04 24 76 43 00 00 	movl   $0x4376,(%esp)
    155a:	e8 f3 23 00 00       	call   3952 <unlink>
  unlink("lf2");
    155f:	c7 04 24 7a 43 00 00 	movl   $0x437a,(%esp)
    1566:	e8 e7 23 00 00       	call   3952 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    156b:	58                   	pop    %eax
    156c:	5a                   	pop    %edx
    156d:	68 02 02 00 00       	push   $0x202
    1572:	68 76 43 00 00       	push   $0x4376
    1577:	e8 c6 23 00 00       	call   3942 <open>
  if(fd < 0){
    157c:	83 c4 10             	add    $0x10,%esp
    157f:	85 c0                	test   %eax,%eax
    1581:	0f 88 1e 01 00 00    	js     16a5 <linktest+0x165>
  if(write(fd, "hello", 5) != 5){
    1587:	83 ec 04             	sub    $0x4,%esp
    158a:	89 c3                	mov    %eax,%ebx
    158c:	6a 05                	push   $0x5
    158e:	68 da 42 00 00       	push   $0x42da
    1593:	50                   	push   %eax
    1594:	e8 89 23 00 00       	call   3922 <write>
    1599:	83 c4 10             	add    $0x10,%esp
    159c:	83 f8 05             	cmp    $0x5,%eax
    159f:	0f 85 98 01 00 00    	jne    173d <linktest+0x1fd>
  close(fd);
    15a5:	83 ec 0c             	sub    $0xc,%esp
    15a8:	53                   	push   %ebx
    15a9:	e8 7c 23 00 00       	call   392a <close>
  if(link("lf1", "lf2") < 0){
    15ae:	5b                   	pop    %ebx
    15af:	58                   	pop    %eax
    15b0:	68 7a 43 00 00       	push   $0x437a
    15b5:	68 76 43 00 00       	push   $0x4376
    15ba:	e8 a3 23 00 00       	call   3962 <link>
    15bf:	83 c4 10             	add    $0x10,%esp
    15c2:	85 c0                	test   %eax,%eax
    15c4:	0f 88 60 01 00 00    	js     172a <linktest+0x1ea>
  unlink("lf1");
    15ca:	83 ec 0c             	sub    $0xc,%esp
    15cd:	68 76 43 00 00       	push   $0x4376
    15d2:	e8 7b 23 00 00       	call   3952 <unlink>
  if(open("lf1", 0) >= 0){
    15d7:	58                   	pop    %eax
    15d8:	5a                   	pop    %edx
    15d9:	6a 00                	push   $0x0
    15db:	68 76 43 00 00       	push   $0x4376
    15e0:	e8 5d 23 00 00       	call   3942 <open>
    15e5:	83 c4 10             	add    $0x10,%esp
    15e8:	85 c0                	test   %eax,%eax
    15ea:	0f 89 27 01 00 00    	jns    1717 <linktest+0x1d7>
  fd = open("lf2", 0);
    15f0:	83 ec 08             	sub    $0x8,%esp
    15f3:	6a 00                	push   $0x0
    15f5:	68 7a 43 00 00       	push   $0x437a
    15fa:	e8 43 23 00 00       	call   3942 <open>
  if(fd < 0){
    15ff:	83 c4 10             	add    $0x10,%esp
    1602:	85 c0                	test   %eax,%eax
  fd = open("lf2", 0);
    1604:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1606:	0f 88 f8 00 00 00    	js     1704 <linktest+0x1c4>
  if(read(fd, buf, sizeof(buf)) != 5){
    160c:	83 ec 04             	sub    $0x4,%esp
    160f:	68 00 20 00 00       	push   $0x2000
    1614:	68 e0 86 00 00       	push   $0x86e0
    1619:	50                   	push   %eax
    161a:	e8 fb 22 00 00       	call   391a <read>
    161f:	83 c4 10             	add    $0x10,%esp
    1622:	83 f8 05             	cmp    $0x5,%eax
    1625:	0f 85 c6 00 00 00    	jne    16f1 <linktest+0x1b1>
  close(fd);
    162b:	83 ec 0c             	sub    $0xc,%esp
    162e:	53                   	push   %ebx
    162f:	e8 f6 22 00 00       	call   392a <close>
  if(link("lf2", "lf2") >= 0){
    1634:	58                   	pop    %eax
    1635:	5a                   	pop    %edx
    1636:	68 7a 43 00 00       	push   $0x437a
    163b:	68 7a 43 00 00       	push   $0x437a
    1640:	e8 1d 23 00 00       	call   3962 <link>
    1645:	83 c4 10             	add    $0x10,%esp
    1648:	85 c0                	test   %eax,%eax
    164a:	0f 89 8e 00 00 00    	jns    16de <linktest+0x19e>
  unlink("lf2");
    1650:	83 ec 0c             	sub    $0xc,%esp
    1653:	68 7a 43 00 00       	push   $0x437a
    1658:	e8 f5 22 00 00       	call   3952 <unlink>
  if(link("lf2", "lf1") >= 0){
    165d:	59                   	pop    %ecx
    165e:	5b                   	pop    %ebx
    165f:	68 76 43 00 00       	push   $0x4376
    1664:	68 7a 43 00 00       	push   $0x437a
    1669:	e8 f4 22 00 00       	call   3962 <link>
    166e:	83 c4 10             	add    $0x10,%esp
    1671:	85 c0                	test   %eax,%eax
    1673:	79 56                	jns    16cb <linktest+0x18b>
  if(link(".", "lf1") >= 0){
    1675:	83 ec 08             	sub    $0x8,%esp
    1678:	68 76 43 00 00       	push   $0x4376
    167d:	68 3e 46 00 00       	push   $0x463e
    1682:	e8 db 22 00 00       	call   3962 <link>
    1687:	83 c4 10             	add    $0x10,%esp
    168a:	85 c0                	test   %eax,%eax
    168c:	79 2a                	jns    16b8 <linktest+0x178>
  printf(1, "linktest ok\n");
    168e:	83 ec 08             	sub    $0x8,%esp
    1691:	68 14 44 00 00       	push   $0x4414
    1696:	6a 01                	push   $0x1
    1698:	e8 d3 23 00 00       	call   3a70 <printf>
}
    169d:	83 c4 10             	add    $0x10,%esp
    16a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    16a3:	c9                   	leave  
    16a4:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    16a5:	50                   	push   %eax
    16a6:	50                   	push   %eax
    16a7:	68 7e 43 00 00       	push   $0x437e
    16ac:	6a 01                	push   $0x1
    16ae:	e8 bd 23 00 00       	call   3a70 <printf>
    exit();
    16b3:	e8 4a 22 00 00       	call   3902 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    16b8:	50                   	push   %eax
    16b9:	50                   	push   %eax
    16ba:	68 f8 43 00 00       	push   $0x43f8
    16bf:	6a 01                	push   $0x1
    16c1:	e8 aa 23 00 00       	call   3a70 <printf>
    exit();
    16c6:	e8 37 22 00 00       	call   3902 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    16cb:	52                   	push   %edx
    16cc:	52                   	push   %edx
    16cd:	68 3c 50 00 00       	push   $0x503c
    16d2:	6a 01                	push   $0x1
    16d4:	e8 97 23 00 00       	call   3a70 <printf>
    exit();
    16d9:	e8 24 22 00 00       	call   3902 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    16de:	50                   	push   %eax
    16df:	50                   	push   %eax
    16e0:	68 da 43 00 00       	push   $0x43da
    16e5:	6a 01                	push   $0x1
    16e7:	e8 84 23 00 00       	call   3a70 <printf>
    exit();
    16ec:	e8 11 22 00 00       	call   3902 <exit>
    printf(1, "read lf2 failed\n");
    16f1:	51                   	push   %ecx
    16f2:	51                   	push   %ecx
    16f3:	68 c9 43 00 00       	push   $0x43c9
    16f8:	6a 01                	push   $0x1
    16fa:	e8 71 23 00 00       	call   3a70 <printf>
    exit();
    16ff:	e8 fe 21 00 00       	call   3902 <exit>
    printf(1, "open lf2 failed\n");
    1704:	53                   	push   %ebx
    1705:	53                   	push   %ebx
    1706:	68 b8 43 00 00       	push   $0x43b8
    170b:	6a 01                	push   $0x1
    170d:	e8 5e 23 00 00       	call   3a70 <printf>
    exit();
    1712:	e8 eb 21 00 00       	call   3902 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1717:	50                   	push   %eax
    1718:	50                   	push   %eax
    1719:	68 14 50 00 00       	push   $0x5014
    171e:	6a 01                	push   $0x1
    1720:	e8 4b 23 00 00       	call   3a70 <printf>
    exit();
    1725:	e8 d8 21 00 00       	call   3902 <exit>
    printf(1, "link lf1 lf2 failed\n");
    172a:	51                   	push   %ecx
    172b:	51                   	push   %ecx
    172c:	68 a3 43 00 00       	push   $0x43a3
    1731:	6a 01                	push   $0x1
    1733:	e8 38 23 00 00       	call   3a70 <printf>
    exit();
    1738:	e8 c5 21 00 00       	call   3902 <exit>
    printf(1, "write lf1 failed\n");
    173d:	50                   	push   %eax
    173e:	50                   	push   %eax
    173f:	68 91 43 00 00       	push   $0x4391
    1744:	6a 01                	push   $0x1
    1746:	e8 25 23 00 00       	call   3a70 <printf>
    exit();
    174b:	e8 b2 21 00 00       	call   3902 <exit>

00001750 <concreate>:
{
    1750:	55                   	push   %ebp
    1751:	89 e5                	mov    %esp,%ebp
    1753:	57                   	push   %edi
    1754:	56                   	push   %esi
    1755:	53                   	push   %ebx
  for(i = 0; i < 40; i++){
    1756:	31 f6                	xor    %esi,%esi
    1758:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    if(pid && (i % 3) == 1){
    175b:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
{
    1760:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    1763:	68 21 44 00 00       	push   $0x4421
    1768:	6a 01                	push   $0x1
    176a:	e8 01 23 00 00       	call   3a70 <printf>
  file[0] = 'C';
    176f:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1773:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
    1777:	83 c4 10             	add    $0x10,%esp
    177a:	eb 4c                	jmp    17c8 <concreate+0x78>
    177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid && (i % 3) == 1){
    1780:	89 f0                	mov    %esi,%eax
    1782:	89 f1                	mov    %esi,%ecx
    1784:	f7 e7                	mul    %edi
    1786:	d1 ea                	shr    %edx
    1788:	8d 04 52             	lea    (%edx,%edx,2),%eax
    178b:	29 c1                	sub    %eax,%ecx
    178d:	83 f9 01             	cmp    $0x1,%ecx
    1790:	0f 84 ba 00 00 00    	je     1850 <concreate+0x100>
      fd = open(file, O_CREATE | O_RDWR);
    1796:	83 ec 08             	sub    $0x8,%esp
    1799:	68 02 02 00 00       	push   $0x202
    179e:	53                   	push   %ebx
    179f:	e8 9e 21 00 00       	call   3942 <open>
      if(fd < 0){
    17a4:	83 c4 10             	add    $0x10,%esp
    17a7:	85 c0                	test   %eax,%eax
    17a9:	78 67                	js     1812 <concreate+0xc2>
      close(fd);
    17ab:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    17ae:	83 c6 01             	add    $0x1,%esi
      close(fd);
    17b1:	50                   	push   %eax
    17b2:	e8 73 21 00 00       	call   392a <close>
    17b7:	83 c4 10             	add    $0x10,%esp
      wait();
    17ba:	e8 4b 21 00 00       	call   390a <wait>
  for(i = 0; i < 40; i++){
    17bf:	83 fe 28             	cmp    $0x28,%esi
    17c2:	0f 84 aa 00 00 00    	je     1872 <concreate+0x122>
    unlink(file);
    17c8:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    17cb:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    17ce:	53                   	push   %ebx
    file[1] = '0' + i;
    17cf:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    17d2:	e8 7b 21 00 00       	call   3952 <unlink>
    pid = fork();
    17d7:	e8 1e 21 00 00       	call   38fa <fork>
    if(pid && (i % 3) == 1){
    17dc:	83 c4 10             	add    $0x10,%esp
    17df:	85 c0                	test   %eax,%eax
    17e1:	75 9d                	jne    1780 <concreate+0x30>
    } else if(pid == 0 && (i % 5) == 1){
    17e3:	89 f0                	mov    %esi,%eax
    17e5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    17ea:	f7 e2                	mul    %edx
    17ec:	c1 ea 02             	shr    $0x2,%edx
    17ef:	8d 04 92             	lea    (%edx,%edx,4),%eax
    17f2:	29 c6                	sub    %eax,%esi
    17f4:	83 fe 01             	cmp    $0x1,%esi
    17f7:	74 37                	je     1830 <concreate+0xe0>
      fd = open(file, O_CREATE | O_RDWR);
    17f9:	83 ec 08             	sub    $0x8,%esp
    17fc:	68 02 02 00 00       	push   $0x202
    1801:	53                   	push   %ebx
    1802:	e8 3b 21 00 00       	call   3942 <open>
      if(fd < 0){
    1807:	83 c4 10             	add    $0x10,%esp
    180a:	85 c0                	test   %eax,%eax
    180c:	0f 89 28 02 00 00    	jns    1a3a <concreate+0x2ea>
        printf(1, "concreate create %s failed\n", file);
    1812:	83 ec 04             	sub    $0x4,%esp
    1815:	53                   	push   %ebx
    1816:	68 34 44 00 00       	push   $0x4434
    181b:	6a 01                	push   $0x1
    181d:	e8 4e 22 00 00       	call   3a70 <printf>
        exit();
    1822:	e8 db 20 00 00       	call   3902 <exit>
    1827:	89 f6                	mov    %esi,%esi
    1829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      link("C0", file);
    1830:	83 ec 08             	sub    $0x8,%esp
    1833:	53                   	push   %ebx
    1834:	68 31 44 00 00       	push   $0x4431
    1839:	e8 24 21 00 00       	call   3962 <link>
    183e:	83 c4 10             	add    $0x10,%esp
      exit();
    1841:	e8 bc 20 00 00       	call   3902 <exit>
    1846:	8d 76 00             	lea    0x0(%esi),%esi
    1849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      link("C0", file);
    1850:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 40; i++){
    1853:	83 c6 01             	add    $0x1,%esi
      link("C0", file);
    1856:	53                   	push   %ebx
    1857:	68 31 44 00 00       	push   $0x4431
    185c:	e8 01 21 00 00       	call   3962 <link>
    1861:	83 c4 10             	add    $0x10,%esp
      wait();
    1864:	e8 a1 20 00 00       	call   390a <wait>
  for(i = 0; i < 40; i++){
    1869:	83 fe 28             	cmp    $0x28,%esi
    186c:	0f 85 56 ff ff ff    	jne    17c8 <concreate+0x78>
  memset(fa, 0, sizeof(fa));
    1872:	8d 45 c0             	lea    -0x40(%ebp),%eax
    1875:	83 ec 04             	sub    $0x4,%esp
    1878:	6a 28                	push   $0x28
    187a:	6a 00                	push   $0x0
    187c:	50                   	push   %eax
    187d:	e8 de 1e 00 00       	call   3760 <memset>
  fd = open(".", 0);
    1882:	5f                   	pop    %edi
    1883:	58                   	pop    %eax
    1884:	6a 00                	push   $0x0
    1886:	68 3e 46 00 00       	push   $0x463e
    188b:	8d 7d b0             	lea    -0x50(%ebp),%edi
    188e:	e8 af 20 00 00       	call   3942 <open>
  while(read(fd, &de, sizeof(de)) > 0){
    1893:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1896:	89 c6                	mov    %eax,%esi
  n = 0;
    1898:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    189f:	90                   	nop
  while(read(fd, &de, sizeof(de)) > 0){
    18a0:	83 ec 04             	sub    $0x4,%esp
    18a3:	6a 10                	push   $0x10
    18a5:	57                   	push   %edi
    18a6:	56                   	push   %esi
    18a7:	e8 6e 20 00 00       	call   391a <read>
    18ac:	83 c4 10             	add    $0x10,%esp
    18af:	85 c0                	test   %eax,%eax
    18b1:	7e 3d                	jle    18f0 <concreate+0x1a0>
    if(de.inum == 0)
    18b3:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    18b8:	74 e6                	je     18a0 <concreate+0x150>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    18ba:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    18be:	75 e0                	jne    18a0 <concreate+0x150>
    18c0:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    18c4:	75 da                	jne    18a0 <concreate+0x150>
      i = de.name[1] - '0';
    18c6:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    18ca:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    18cd:	83 f8 27             	cmp    $0x27,%eax
    18d0:	0f 87 4e 01 00 00    	ja     1a24 <concreate+0x2d4>
      if(fa[i]){
    18d6:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    18db:	0f 85 2d 01 00 00    	jne    1a0e <concreate+0x2be>
      fa[i] = 1;
    18e1:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    18e6:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
    18ea:	eb b4                	jmp    18a0 <concreate+0x150>
    18ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    18f0:	83 ec 0c             	sub    $0xc,%esp
    18f3:	56                   	push   %esi
    18f4:	e8 31 20 00 00       	call   392a <close>
  if(n != 40){
    18f9:	83 c4 10             	add    $0x10,%esp
    18fc:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    1900:	0f 85 f5 00 00 00    	jne    19fb <concreate+0x2ab>
  for(i = 0; i < 40; i++){
    1906:	31 f6                	xor    %esi,%esi
    1908:	eb 48                	jmp    1952 <concreate+0x202>
    190a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    1910:	85 ff                	test   %edi,%edi
    1912:	74 05                	je     1919 <concreate+0x1c9>
    1914:	83 fa 01             	cmp    $0x1,%edx
    1917:	74 64                	je     197d <concreate+0x22d>
      unlink(file);
    1919:	83 ec 0c             	sub    $0xc,%esp
    191c:	53                   	push   %ebx
    191d:	e8 30 20 00 00       	call   3952 <unlink>
      unlink(file);
    1922:	89 1c 24             	mov    %ebx,(%esp)
    1925:	e8 28 20 00 00       	call   3952 <unlink>
      unlink(file);
    192a:	89 1c 24             	mov    %ebx,(%esp)
    192d:	e8 20 20 00 00       	call   3952 <unlink>
      unlink(file);
    1932:	89 1c 24             	mov    %ebx,(%esp)
    1935:	e8 18 20 00 00       	call   3952 <unlink>
    193a:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    193d:	85 ff                	test   %edi,%edi
    193f:	0f 84 fc fe ff ff    	je     1841 <concreate+0xf1>
  for(i = 0; i < 40; i++){
    1945:	83 c6 01             	add    $0x1,%esi
      wait();
    1948:	e8 bd 1f 00 00       	call   390a <wait>
  for(i = 0; i < 40; i++){
    194d:	83 fe 28             	cmp    $0x28,%esi
    1950:	74 7e                	je     19d0 <concreate+0x280>
    file[1] = '0' + i;
    1952:	8d 46 30             	lea    0x30(%esi),%eax
    1955:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    1958:	e8 9d 1f 00 00       	call   38fa <fork>
    if(pid < 0){
    195d:	85 c0                	test   %eax,%eax
    pid = fork();
    195f:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    1961:	0f 88 80 00 00 00    	js     19e7 <concreate+0x297>
    if(((i % 3) == 0 && pid == 0) ||
    1967:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    196c:	f7 e6                	mul    %esi
    196e:	d1 ea                	shr    %edx
    1970:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1973:	89 f2                	mov    %esi,%edx
    1975:	29 c2                	sub    %eax,%edx
    1977:	89 d0                	mov    %edx,%eax
    1979:	09 f8                	or     %edi,%eax
    197b:	75 93                	jne    1910 <concreate+0x1c0>
      close(open(file, 0));
    197d:	83 ec 08             	sub    $0x8,%esp
    1980:	6a 00                	push   $0x0
    1982:	53                   	push   %ebx
    1983:	e8 ba 1f 00 00       	call   3942 <open>
    1988:	89 04 24             	mov    %eax,(%esp)
    198b:	e8 9a 1f 00 00       	call   392a <close>
      close(open(file, 0));
    1990:	58                   	pop    %eax
    1991:	5a                   	pop    %edx
    1992:	6a 00                	push   $0x0
    1994:	53                   	push   %ebx
    1995:	e8 a8 1f 00 00       	call   3942 <open>
    199a:	89 04 24             	mov    %eax,(%esp)
    199d:	e8 88 1f 00 00       	call   392a <close>
      close(open(file, 0));
    19a2:	59                   	pop    %ecx
    19a3:	58                   	pop    %eax
    19a4:	6a 00                	push   $0x0
    19a6:	53                   	push   %ebx
    19a7:	e8 96 1f 00 00       	call   3942 <open>
    19ac:	89 04 24             	mov    %eax,(%esp)
    19af:	e8 76 1f 00 00       	call   392a <close>
      close(open(file, 0));
    19b4:	58                   	pop    %eax
    19b5:	5a                   	pop    %edx
    19b6:	6a 00                	push   $0x0
    19b8:	53                   	push   %ebx
    19b9:	e8 84 1f 00 00       	call   3942 <open>
    19be:	89 04 24             	mov    %eax,(%esp)
    19c1:	e8 64 1f 00 00       	call   392a <close>
    19c6:	83 c4 10             	add    $0x10,%esp
    19c9:	e9 6f ff ff ff       	jmp    193d <concreate+0x1ed>
    19ce:	66 90                	xchg   %ax,%ax
  printf(1, "concreate ok\n");
    19d0:	83 ec 08             	sub    $0x8,%esp
    19d3:	68 86 44 00 00       	push   $0x4486
    19d8:	6a 01                	push   $0x1
    19da:	e8 91 20 00 00       	call   3a70 <printf>
}
    19df:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19e2:	5b                   	pop    %ebx
    19e3:	5e                   	pop    %esi
    19e4:	5f                   	pop    %edi
    19e5:	5d                   	pop    %ebp
    19e6:	c3                   	ret    
      printf(1, "fork failed\n");
    19e7:	83 ec 08             	sub    $0x8,%esp
    19ea:	68 9a 4d 00 00       	push   $0x4d9a
    19ef:	6a 01                	push   $0x1
    19f1:	e8 7a 20 00 00       	call   3a70 <printf>
      exit();
    19f6:	e8 07 1f 00 00       	call   3902 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    19fb:	51                   	push   %ecx
    19fc:	51                   	push   %ecx
    19fd:	68 60 50 00 00       	push   $0x5060
    1a02:	6a 01                	push   $0x1
    1a04:	e8 67 20 00 00       	call   3a70 <printf>
    exit();
    1a09:	e8 f4 1e 00 00       	call   3902 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1a0e:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1a11:	53                   	push   %ebx
    1a12:	50                   	push   %eax
    1a13:	68 69 44 00 00       	push   $0x4469
    1a18:	6a 01                	push   $0x1
    1a1a:	e8 51 20 00 00       	call   3a70 <printf>
        exit();
    1a1f:	e8 de 1e 00 00       	call   3902 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1a24:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1a27:	56                   	push   %esi
    1a28:	50                   	push   %eax
    1a29:	68 50 44 00 00       	push   $0x4450
    1a2e:	6a 01                	push   $0x1
    1a30:	e8 3b 20 00 00       	call   3a70 <printf>
        exit();
    1a35:	e8 c8 1e 00 00       	call   3902 <exit>
      close(fd);
    1a3a:	83 ec 0c             	sub    $0xc,%esp
    1a3d:	50                   	push   %eax
    1a3e:	e8 e7 1e 00 00       	call   392a <close>
    1a43:	83 c4 10             	add    $0x10,%esp
    1a46:	e9 f6 fd ff ff       	jmp    1841 <concreate+0xf1>
    1a4b:	90                   	nop
    1a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001a50 <linkunlink>:
{
    1a50:	55                   	push   %ebp
    1a51:	89 e5                	mov    %esp,%ebp
    1a53:	57                   	push   %edi
    1a54:	56                   	push   %esi
    1a55:	53                   	push   %ebx
    1a56:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    1a59:	68 94 44 00 00       	push   $0x4494
    1a5e:	6a 01                	push   $0x1
    1a60:	e8 0b 20 00 00       	call   3a70 <printf>
  unlink("x");
    1a65:	c7 04 24 21 47 00 00 	movl   $0x4721,(%esp)
    1a6c:	e8 e1 1e 00 00       	call   3952 <unlink>
  pid = fork();
    1a71:	e8 84 1e 00 00       	call   38fa <fork>
  if(pid < 0){
    1a76:	83 c4 10             	add    $0x10,%esp
    1a79:	85 c0                	test   %eax,%eax
  pid = fork();
    1a7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1a7e:	0f 88 b6 00 00 00    	js     1b3a <linkunlink+0xea>
  unsigned int x = (pid ? 1 : 97);
    1a84:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1a88:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1a8d:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    1a92:	19 ff                	sbb    %edi,%edi
    1a94:	83 e7 60             	and    $0x60,%edi
    1a97:	83 c7 01             	add    $0x1,%edi
    1a9a:	eb 1e                	jmp    1aba <linkunlink+0x6a>
    1a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if((x % 3) == 1){
    1aa0:	83 fa 01             	cmp    $0x1,%edx
    1aa3:	74 7b                	je     1b20 <linkunlink+0xd0>
      unlink("x");
    1aa5:	83 ec 0c             	sub    $0xc,%esp
    1aa8:	68 21 47 00 00       	push   $0x4721
    1aad:	e8 a0 1e 00 00       	call   3952 <unlink>
    1ab2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1ab5:	83 eb 01             	sub    $0x1,%ebx
    1ab8:	74 3d                	je     1af7 <linkunlink+0xa7>
    x = x * 1103515245 + 12345;
    1aba:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    1ac0:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    1ac6:	89 f8                	mov    %edi,%eax
    1ac8:	f7 e6                	mul    %esi
    1aca:	d1 ea                	shr    %edx
    1acc:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1acf:	89 fa                	mov    %edi,%edx
    1ad1:	29 c2                	sub    %eax,%edx
    1ad3:	75 cb                	jne    1aa0 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1ad5:	83 ec 08             	sub    $0x8,%esp
    1ad8:	68 02 02 00 00       	push   $0x202
    1add:	68 21 47 00 00       	push   $0x4721
    1ae2:	e8 5b 1e 00 00       	call   3942 <open>
    1ae7:	89 04 24             	mov    %eax,(%esp)
    1aea:	e8 3b 1e 00 00       	call   392a <close>
    1aef:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1af2:	83 eb 01             	sub    $0x1,%ebx
    1af5:	75 c3                	jne    1aba <linkunlink+0x6a>
  if(pid)
    1af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1afa:	85 c0                	test   %eax,%eax
    1afc:	74 4f                	je     1b4d <linkunlink+0xfd>
    wait();
    1afe:	e8 07 1e 00 00       	call   390a <wait>
  printf(1, "linkunlink ok\n");
    1b03:	83 ec 08             	sub    $0x8,%esp
    1b06:	68 a9 44 00 00       	push   $0x44a9
    1b0b:	6a 01                	push   $0x1
    1b0d:	e8 5e 1f 00 00       	call   3a70 <printf>
}
    1b12:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1b15:	5b                   	pop    %ebx
    1b16:	5e                   	pop    %esi
    1b17:	5f                   	pop    %edi
    1b18:	5d                   	pop    %ebp
    1b19:	c3                   	ret    
    1b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      link("cat", "x");
    1b20:	83 ec 08             	sub    $0x8,%esp
    1b23:	68 21 47 00 00       	push   $0x4721
    1b28:	68 a5 44 00 00       	push   $0x44a5
    1b2d:	e8 30 1e 00 00       	call   3962 <link>
    1b32:	83 c4 10             	add    $0x10,%esp
    1b35:	e9 7b ff ff ff       	jmp    1ab5 <linkunlink+0x65>
    printf(1, "fork failed\n");
    1b3a:	52                   	push   %edx
    1b3b:	52                   	push   %edx
    1b3c:	68 9a 4d 00 00       	push   $0x4d9a
    1b41:	6a 01                	push   $0x1
    1b43:	e8 28 1f 00 00       	call   3a70 <printf>
    exit();
    1b48:	e8 b5 1d 00 00       	call   3902 <exit>
    exit();
    1b4d:	e8 b0 1d 00 00       	call   3902 <exit>
    1b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001b60 <bigdir>:
{
    1b60:	55                   	push   %ebp
    1b61:	89 e5                	mov    %esp,%ebp
    1b63:	57                   	push   %edi
    1b64:	56                   	push   %esi
    1b65:	53                   	push   %ebx
    1b66:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1b69:	68 b8 44 00 00       	push   $0x44b8
    1b6e:	6a 01                	push   $0x1
    1b70:	e8 fb 1e 00 00       	call   3a70 <printf>
  unlink("bd");
    1b75:	c7 04 24 c5 44 00 00 	movl   $0x44c5,(%esp)
    1b7c:	e8 d1 1d 00 00       	call   3952 <unlink>
  fd = open("bd", O_CREATE);
    1b81:	5a                   	pop    %edx
    1b82:	59                   	pop    %ecx
    1b83:	68 00 02 00 00       	push   $0x200
    1b88:	68 c5 44 00 00       	push   $0x44c5
    1b8d:	e8 b0 1d 00 00       	call   3942 <open>
  if(fd < 0){
    1b92:	83 c4 10             	add    $0x10,%esp
    1b95:	85 c0                	test   %eax,%eax
    1b97:	0f 88 de 00 00 00    	js     1c7b <bigdir+0x11b>
  close(fd);
    1b9d:	83 ec 0c             	sub    $0xc,%esp
    1ba0:	8d 7d de             	lea    -0x22(%ebp),%edi
  for(i = 0; i < 500; i++){
    1ba3:	31 f6                	xor    %esi,%esi
  close(fd);
    1ba5:	50                   	push   %eax
    1ba6:	e8 7f 1d 00 00       	call   392a <close>
    1bab:	83 c4 10             	add    $0x10,%esp
    1bae:	66 90                	xchg   %ax,%ax
    name[1] = '0' + (i / 64);
    1bb0:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    1bb2:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    1bb5:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1bb9:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    1bbc:	57                   	push   %edi
    1bbd:	68 c5 44 00 00       	push   $0x44c5
    name[1] = '0' + (i / 64);
    1bc2:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    1bc5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1bc9:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1bcc:	89 f0                	mov    %esi,%eax
    1bce:	83 e0 3f             	and    $0x3f,%eax
    1bd1:	83 c0 30             	add    $0x30,%eax
    1bd4:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    1bd7:	e8 86 1d 00 00       	call   3962 <link>
    1bdc:	83 c4 10             	add    $0x10,%esp
    1bdf:	85 c0                	test   %eax,%eax
    1be1:	89 c3                	mov    %eax,%ebx
    1be3:	75 6e                	jne    1c53 <bigdir+0xf3>
  for(i = 0; i < 500; i++){
    1be5:	83 c6 01             	add    $0x1,%esi
    1be8:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1bee:	75 c0                	jne    1bb0 <bigdir+0x50>
  unlink("bd");
    1bf0:	83 ec 0c             	sub    $0xc,%esp
    1bf3:	68 c5 44 00 00       	push   $0x44c5
    1bf8:	e8 55 1d 00 00       	call   3952 <unlink>
    1bfd:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + (i / 64);
    1c00:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    1c02:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    1c05:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1c09:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    1c0c:	57                   	push   %edi
    name[3] = '\0';
    1c0d:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1c11:	83 c0 30             	add    $0x30,%eax
    1c14:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1c17:	89 d8                	mov    %ebx,%eax
    1c19:	83 e0 3f             	and    $0x3f,%eax
    1c1c:	83 c0 30             	add    $0x30,%eax
    1c1f:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    1c22:	e8 2b 1d 00 00       	call   3952 <unlink>
    1c27:	83 c4 10             	add    $0x10,%esp
    1c2a:	85 c0                	test   %eax,%eax
    1c2c:	75 39                	jne    1c67 <bigdir+0x107>
  for(i = 0; i < 500; i++){
    1c2e:	83 c3 01             	add    $0x1,%ebx
    1c31:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1c37:	75 c7                	jne    1c00 <bigdir+0xa0>
  printf(1, "bigdir ok\n");
    1c39:	83 ec 08             	sub    $0x8,%esp
    1c3c:	68 07 45 00 00       	push   $0x4507
    1c41:	6a 01                	push   $0x1
    1c43:	e8 28 1e 00 00       	call   3a70 <printf>
}
    1c48:	83 c4 10             	add    $0x10,%esp
    1c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1c4e:	5b                   	pop    %ebx
    1c4f:	5e                   	pop    %esi
    1c50:	5f                   	pop    %edi
    1c51:	5d                   	pop    %ebp
    1c52:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    1c53:	83 ec 08             	sub    $0x8,%esp
    1c56:	68 de 44 00 00       	push   $0x44de
    1c5b:	6a 01                	push   $0x1
    1c5d:	e8 0e 1e 00 00       	call   3a70 <printf>
      exit();
    1c62:	e8 9b 1c 00 00       	call   3902 <exit>
      printf(1, "bigdir unlink failed");
    1c67:	83 ec 08             	sub    $0x8,%esp
    1c6a:	68 f2 44 00 00       	push   $0x44f2
    1c6f:	6a 01                	push   $0x1
    1c71:	e8 fa 1d 00 00       	call   3a70 <printf>
      exit();
    1c76:	e8 87 1c 00 00       	call   3902 <exit>
    printf(1, "bigdir create failed\n");
    1c7b:	50                   	push   %eax
    1c7c:	50                   	push   %eax
    1c7d:	68 c8 44 00 00       	push   $0x44c8
    1c82:	6a 01                	push   $0x1
    1c84:	e8 e7 1d 00 00       	call   3a70 <printf>
    exit();
    1c89:	e8 74 1c 00 00       	call   3902 <exit>
    1c8e:	66 90                	xchg   %ax,%ax

00001c90 <subdir>:
{
    1c90:	55                   	push   %ebp
    1c91:	89 e5                	mov    %esp,%ebp
    1c93:	53                   	push   %ebx
    1c94:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    1c97:	68 12 45 00 00       	push   $0x4512
    1c9c:	6a 01                	push   $0x1
    1c9e:	e8 cd 1d 00 00       	call   3a70 <printf>
  unlink("ff");
    1ca3:	c7 04 24 9b 45 00 00 	movl   $0x459b,(%esp)
    1caa:	e8 a3 1c 00 00       	call   3952 <unlink>
  if(mkdir("dd") != 0){
    1caf:	c7 04 24 38 46 00 00 	movl   $0x4638,(%esp)
    1cb6:	e8 af 1c 00 00       	call   396a <mkdir>
    1cbb:	83 c4 10             	add    $0x10,%esp
    1cbe:	85 c0                	test   %eax,%eax
    1cc0:	0f 85 b3 05 00 00    	jne    2279 <subdir+0x5e9>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1cc6:	83 ec 08             	sub    $0x8,%esp
    1cc9:	68 02 02 00 00       	push   $0x202
    1cce:	68 71 45 00 00       	push   $0x4571
    1cd3:	e8 6a 1c 00 00       	call   3942 <open>
  if(fd < 0){
    1cd8:	83 c4 10             	add    $0x10,%esp
    1cdb:	85 c0                	test   %eax,%eax
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1cdd:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1cdf:	0f 88 81 05 00 00    	js     2266 <subdir+0x5d6>
  write(fd, "ff", 2);
    1ce5:	83 ec 04             	sub    $0x4,%esp
    1ce8:	6a 02                	push   $0x2
    1cea:	68 9b 45 00 00       	push   $0x459b
    1cef:	50                   	push   %eax
    1cf0:	e8 2d 1c 00 00       	call   3922 <write>
  close(fd);
    1cf5:	89 1c 24             	mov    %ebx,(%esp)
    1cf8:	e8 2d 1c 00 00       	call   392a <close>
  if(unlink("dd") >= 0){
    1cfd:	c7 04 24 38 46 00 00 	movl   $0x4638,(%esp)
    1d04:	e8 49 1c 00 00       	call   3952 <unlink>
    1d09:	83 c4 10             	add    $0x10,%esp
    1d0c:	85 c0                	test   %eax,%eax
    1d0e:	0f 89 3f 05 00 00    	jns    2253 <subdir+0x5c3>
  if(mkdir("/dd/dd") != 0){
    1d14:	83 ec 0c             	sub    $0xc,%esp
    1d17:	68 4c 45 00 00       	push   $0x454c
    1d1c:	e8 49 1c 00 00       	call   396a <mkdir>
    1d21:	83 c4 10             	add    $0x10,%esp
    1d24:	85 c0                	test   %eax,%eax
    1d26:	0f 85 14 05 00 00    	jne    2240 <subdir+0x5b0>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1d2c:	83 ec 08             	sub    $0x8,%esp
    1d2f:	68 02 02 00 00       	push   $0x202
    1d34:	68 6e 45 00 00       	push   $0x456e
    1d39:	e8 04 1c 00 00       	call   3942 <open>
  if(fd < 0){
    1d3e:	83 c4 10             	add    $0x10,%esp
    1d41:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1d43:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d45:	0f 88 24 04 00 00    	js     216f <subdir+0x4df>
  write(fd, "FF", 2);
    1d4b:	83 ec 04             	sub    $0x4,%esp
    1d4e:	6a 02                	push   $0x2
    1d50:	68 8f 45 00 00       	push   $0x458f
    1d55:	50                   	push   %eax
    1d56:	e8 c7 1b 00 00       	call   3922 <write>
  close(fd);
    1d5b:	89 1c 24             	mov    %ebx,(%esp)
    1d5e:	e8 c7 1b 00 00       	call   392a <close>
  fd = open("dd/dd/../ff", 0);
    1d63:	58                   	pop    %eax
    1d64:	5a                   	pop    %edx
    1d65:	6a 00                	push   $0x0
    1d67:	68 92 45 00 00       	push   $0x4592
    1d6c:	e8 d1 1b 00 00       	call   3942 <open>
  if(fd < 0){
    1d71:	83 c4 10             	add    $0x10,%esp
    1d74:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/../ff", 0);
    1d76:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d78:	0f 88 de 03 00 00    	js     215c <subdir+0x4cc>
  cc = read(fd, buf, sizeof(buf));
    1d7e:	83 ec 04             	sub    $0x4,%esp
    1d81:	68 00 20 00 00       	push   $0x2000
    1d86:	68 e0 86 00 00       	push   $0x86e0
    1d8b:	50                   	push   %eax
    1d8c:	e8 89 1b 00 00       	call   391a <read>
  if(cc != 2 || buf[0] != 'f'){
    1d91:	83 c4 10             	add    $0x10,%esp
    1d94:	83 f8 02             	cmp    $0x2,%eax
    1d97:	0f 85 3a 03 00 00    	jne    20d7 <subdir+0x447>
    1d9d:	80 3d e0 86 00 00 66 	cmpb   $0x66,0x86e0
    1da4:	0f 85 2d 03 00 00    	jne    20d7 <subdir+0x447>
  close(fd);
    1daa:	83 ec 0c             	sub    $0xc,%esp
    1dad:	53                   	push   %ebx
    1dae:	e8 77 1b 00 00       	call   392a <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1db3:	5b                   	pop    %ebx
    1db4:	58                   	pop    %eax
    1db5:	68 d2 45 00 00       	push   $0x45d2
    1dba:	68 6e 45 00 00       	push   $0x456e
    1dbf:	e8 9e 1b 00 00       	call   3962 <link>
    1dc4:	83 c4 10             	add    $0x10,%esp
    1dc7:	85 c0                	test   %eax,%eax
    1dc9:	0f 85 c6 03 00 00    	jne    2195 <subdir+0x505>
  if(unlink("dd/dd/ff") != 0){
    1dcf:	83 ec 0c             	sub    $0xc,%esp
    1dd2:	68 6e 45 00 00       	push   $0x456e
    1dd7:	e8 76 1b 00 00       	call   3952 <unlink>
    1ddc:	83 c4 10             	add    $0x10,%esp
    1ddf:	85 c0                	test   %eax,%eax
    1de1:	0f 85 16 03 00 00    	jne    20fd <subdir+0x46d>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1de7:	83 ec 08             	sub    $0x8,%esp
    1dea:	6a 00                	push   $0x0
    1dec:	68 6e 45 00 00       	push   $0x456e
    1df1:	e8 4c 1b 00 00       	call   3942 <open>
    1df6:	83 c4 10             	add    $0x10,%esp
    1df9:	85 c0                	test   %eax,%eax
    1dfb:	0f 89 2c 04 00 00    	jns    222d <subdir+0x59d>
  if(chdir("dd") != 0){
    1e01:	83 ec 0c             	sub    $0xc,%esp
    1e04:	68 38 46 00 00       	push   $0x4638
    1e09:	e8 64 1b 00 00       	call   3972 <chdir>
    1e0e:	83 c4 10             	add    $0x10,%esp
    1e11:	85 c0                	test   %eax,%eax
    1e13:	0f 85 01 04 00 00    	jne    221a <subdir+0x58a>
  if(chdir("dd/../../dd") != 0){
    1e19:	83 ec 0c             	sub    $0xc,%esp
    1e1c:	68 06 46 00 00       	push   $0x4606
    1e21:	e8 4c 1b 00 00       	call   3972 <chdir>
    1e26:	83 c4 10             	add    $0x10,%esp
    1e29:	85 c0                	test   %eax,%eax
    1e2b:	0f 85 b9 02 00 00    	jne    20ea <subdir+0x45a>
  if(chdir("dd/../../../dd") != 0){
    1e31:	83 ec 0c             	sub    $0xc,%esp
    1e34:	68 2c 46 00 00       	push   $0x462c
    1e39:	e8 34 1b 00 00       	call   3972 <chdir>
    1e3e:	83 c4 10             	add    $0x10,%esp
    1e41:	85 c0                	test   %eax,%eax
    1e43:	0f 85 a1 02 00 00    	jne    20ea <subdir+0x45a>
  if(chdir("./..") != 0){
    1e49:	83 ec 0c             	sub    $0xc,%esp
    1e4c:	68 3b 46 00 00       	push   $0x463b
    1e51:	e8 1c 1b 00 00       	call   3972 <chdir>
    1e56:	83 c4 10             	add    $0x10,%esp
    1e59:	85 c0                	test   %eax,%eax
    1e5b:	0f 85 21 03 00 00    	jne    2182 <subdir+0x4f2>
  fd = open("dd/dd/ffff", 0);
    1e61:	83 ec 08             	sub    $0x8,%esp
    1e64:	6a 00                	push   $0x0
    1e66:	68 d2 45 00 00       	push   $0x45d2
    1e6b:	e8 d2 1a 00 00       	call   3942 <open>
  if(fd < 0){
    1e70:	83 c4 10             	add    $0x10,%esp
    1e73:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/ffff", 0);
    1e75:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e77:	0f 88 e0 04 00 00    	js     235d <subdir+0x6cd>
  if(read(fd, buf, sizeof(buf)) != 2){
    1e7d:	83 ec 04             	sub    $0x4,%esp
    1e80:	68 00 20 00 00       	push   $0x2000
    1e85:	68 e0 86 00 00       	push   $0x86e0
    1e8a:	50                   	push   %eax
    1e8b:	e8 8a 1a 00 00       	call   391a <read>
    1e90:	83 c4 10             	add    $0x10,%esp
    1e93:	83 f8 02             	cmp    $0x2,%eax
    1e96:	0f 85 ae 04 00 00    	jne    234a <subdir+0x6ba>
  close(fd);
    1e9c:	83 ec 0c             	sub    $0xc,%esp
    1e9f:	53                   	push   %ebx
    1ea0:	e8 85 1a 00 00       	call   392a <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1ea5:	59                   	pop    %ecx
    1ea6:	5b                   	pop    %ebx
    1ea7:	6a 00                	push   $0x0
    1ea9:	68 6e 45 00 00       	push   $0x456e
    1eae:	e8 8f 1a 00 00       	call   3942 <open>
    1eb3:	83 c4 10             	add    $0x10,%esp
    1eb6:	85 c0                	test   %eax,%eax
    1eb8:	0f 89 65 02 00 00    	jns    2123 <subdir+0x493>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1ebe:	83 ec 08             	sub    $0x8,%esp
    1ec1:	68 02 02 00 00       	push   $0x202
    1ec6:	68 86 46 00 00       	push   $0x4686
    1ecb:	e8 72 1a 00 00       	call   3942 <open>
    1ed0:	83 c4 10             	add    $0x10,%esp
    1ed3:	85 c0                	test   %eax,%eax
    1ed5:	0f 89 35 02 00 00    	jns    2110 <subdir+0x480>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1edb:	83 ec 08             	sub    $0x8,%esp
    1ede:	68 02 02 00 00       	push   $0x202
    1ee3:	68 ab 46 00 00       	push   $0x46ab
    1ee8:	e8 55 1a 00 00       	call   3942 <open>
    1eed:	83 c4 10             	add    $0x10,%esp
    1ef0:	85 c0                	test   %eax,%eax
    1ef2:	0f 89 0f 03 00 00    	jns    2207 <subdir+0x577>
  if(open("dd", O_CREATE) >= 0){
    1ef8:	83 ec 08             	sub    $0x8,%esp
    1efb:	68 00 02 00 00       	push   $0x200
    1f00:	68 38 46 00 00       	push   $0x4638
    1f05:	e8 38 1a 00 00       	call   3942 <open>
    1f0a:	83 c4 10             	add    $0x10,%esp
    1f0d:	85 c0                	test   %eax,%eax
    1f0f:	0f 89 df 02 00 00    	jns    21f4 <subdir+0x564>
  if(open("dd", O_RDWR) >= 0){
    1f15:	83 ec 08             	sub    $0x8,%esp
    1f18:	6a 02                	push   $0x2
    1f1a:	68 38 46 00 00       	push   $0x4638
    1f1f:	e8 1e 1a 00 00       	call   3942 <open>
    1f24:	83 c4 10             	add    $0x10,%esp
    1f27:	85 c0                	test   %eax,%eax
    1f29:	0f 89 b2 02 00 00    	jns    21e1 <subdir+0x551>
  if(open("dd", O_WRONLY) >= 0){
    1f2f:	83 ec 08             	sub    $0x8,%esp
    1f32:	6a 01                	push   $0x1
    1f34:	68 38 46 00 00       	push   $0x4638
    1f39:	e8 04 1a 00 00       	call   3942 <open>
    1f3e:	83 c4 10             	add    $0x10,%esp
    1f41:	85 c0                	test   %eax,%eax
    1f43:	0f 89 85 02 00 00    	jns    21ce <subdir+0x53e>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1f49:	83 ec 08             	sub    $0x8,%esp
    1f4c:	68 1a 47 00 00       	push   $0x471a
    1f51:	68 86 46 00 00       	push   $0x4686
    1f56:	e8 07 1a 00 00       	call   3962 <link>
    1f5b:	83 c4 10             	add    $0x10,%esp
    1f5e:	85 c0                	test   %eax,%eax
    1f60:	0f 84 55 02 00 00    	je     21bb <subdir+0x52b>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1f66:	83 ec 08             	sub    $0x8,%esp
    1f69:	68 1a 47 00 00       	push   $0x471a
    1f6e:	68 ab 46 00 00       	push   $0x46ab
    1f73:	e8 ea 19 00 00       	call   3962 <link>
    1f78:	83 c4 10             	add    $0x10,%esp
    1f7b:	85 c0                	test   %eax,%eax
    1f7d:	0f 84 25 02 00 00    	je     21a8 <subdir+0x518>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1f83:	83 ec 08             	sub    $0x8,%esp
    1f86:	68 d2 45 00 00       	push   $0x45d2
    1f8b:	68 71 45 00 00       	push   $0x4571
    1f90:	e8 cd 19 00 00       	call   3962 <link>
    1f95:	83 c4 10             	add    $0x10,%esp
    1f98:	85 c0                	test   %eax,%eax
    1f9a:	0f 84 a9 01 00 00    	je     2149 <subdir+0x4b9>
  if(mkdir("dd/ff/ff") == 0){
    1fa0:	83 ec 0c             	sub    $0xc,%esp
    1fa3:	68 86 46 00 00       	push   $0x4686
    1fa8:	e8 bd 19 00 00       	call   396a <mkdir>
    1fad:	83 c4 10             	add    $0x10,%esp
    1fb0:	85 c0                	test   %eax,%eax
    1fb2:	0f 84 7e 01 00 00    	je     2136 <subdir+0x4a6>
  if(mkdir("dd/xx/ff") == 0){
    1fb8:	83 ec 0c             	sub    $0xc,%esp
    1fbb:	68 ab 46 00 00       	push   $0x46ab
    1fc0:	e8 a5 19 00 00       	call   396a <mkdir>
    1fc5:	83 c4 10             	add    $0x10,%esp
    1fc8:	85 c0                	test   %eax,%eax
    1fca:	0f 84 67 03 00 00    	je     2337 <subdir+0x6a7>
  if(mkdir("dd/dd/ffff") == 0){
    1fd0:	83 ec 0c             	sub    $0xc,%esp
    1fd3:	68 d2 45 00 00       	push   $0x45d2
    1fd8:	e8 8d 19 00 00       	call   396a <mkdir>
    1fdd:	83 c4 10             	add    $0x10,%esp
    1fe0:	85 c0                	test   %eax,%eax
    1fe2:	0f 84 3c 03 00 00    	je     2324 <subdir+0x694>
  if(unlink("dd/xx/ff") == 0){
    1fe8:	83 ec 0c             	sub    $0xc,%esp
    1feb:	68 ab 46 00 00       	push   $0x46ab
    1ff0:	e8 5d 19 00 00       	call   3952 <unlink>
    1ff5:	83 c4 10             	add    $0x10,%esp
    1ff8:	85 c0                	test   %eax,%eax
    1ffa:	0f 84 11 03 00 00    	je     2311 <subdir+0x681>
  if(unlink("dd/ff/ff") == 0){
    2000:	83 ec 0c             	sub    $0xc,%esp
    2003:	68 86 46 00 00       	push   $0x4686
    2008:	e8 45 19 00 00       	call   3952 <unlink>
    200d:	83 c4 10             	add    $0x10,%esp
    2010:	85 c0                	test   %eax,%eax
    2012:	0f 84 e6 02 00 00    	je     22fe <subdir+0x66e>
  if(chdir("dd/ff") == 0){
    2018:	83 ec 0c             	sub    $0xc,%esp
    201b:	68 71 45 00 00       	push   $0x4571
    2020:	e8 4d 19 00 00       	call   3972 <chdir>
    2025:	83 c4 10             	add    $0x10,%esp
    2028:	85 c0                	test   %eax,%eax
    202a:	0f 84 bb 02 00 00    	je     22eb <subdir+0x65b>
  if(chdir("dd/xx") == 0){
    2030:	83 ec 0c             	sub    $0xc,%esp
    2033:	68 1d 47 00 00       	push   $0x471d
    2038:	e8 35 19 00 00       	call   3972 <chdir>
    203d:	83 c4 10             	add    $0x10,%esp
    2040:	85 c0                	test   %eax,%eax
    2042:	0f 84 90 02 00 00    	je     22d8 <subdir+0x648>
  if(unlink("dd/dd/ffff") != 0){
    2048:	83 ec 0c             	sub    $0xc,%esp
    204b:	68 d2 45 00 00       	push   $0x45d2
    2050:	e8 fd 18 00 00       	call   3952 <unlink>
    2055:	83 c4 10             	add    $0x10,%esp
    2058:	85 c0                	test   %eax,%eax
    205a:	0f 85 9d 00 00 00    	jne    20fd <subdir+0x46d>
  if(unlink("dd/ff") != 0){
    2060:	83 ec 0c             	sub    $0xc,%esp
    2063:	68 71 45 00 00       	push   $0x4571
    2068:	e8 e5 18 00 00       	call   3952 <unlink>
    206d:	83 c4 10             	add    $0x10,%esp
    2070:	85 c0                	test   %eax,%eax
    2072:	0f 85 4d 02 00 00    	jne    22c5 <subdir+0x635>
  if(unlink("dd") == 0){
    2078:	83 ec 0c             	sub    $0xc,%esp
    207b:	68 38 46 00 00       	push   $0x4638
    2080:	e8 cd 18 00 00       	call   3952 <unlink>
    2085:	83 c4 10             	add    $0x10,%esp
    2088:	85 c0                	test   %eax,%eax
    208a:	0f 84 22 02 00 00    	je     22b2 <subdir+0x622>
  if(unlink("dd/dd") < 0){
    2090:	83 ec 0c             	sub    $0xc,%esp
    2093:	68 4d 45 00 00       	push   $0x454d
    2098:	e8 b5 18 00 00       	call   3952 <unlink>
    209d:	83 c4 10             	add    $0x10,%esp
    20a0:	85 c0                	test   %eax,%eax
    20a2:	0f 88 f7 01 00 00    	js     229f <subdir+0x60f>
  if(unlink("dd") < 0){
    20a8:	83 ec 0c             	sub    $0xc,%esp
    20ab:	68 38 46 00 00       	push   $0x4638
    20b0:	e8 9d 18 00 00       	call   3952 <unlink>
    20b5:	83 c4 10             	add    $0x10,%esp
    20b8:	85 c0                	test   %eax,%eax
    20ba:	0f 88 cc 01 00 00    	js     228c <subdir+0x5fc>
  printf(1, "subdir ok\n");
    20c0:	83 ec 08             	sub    $0x8,%esp
    20c3:	68 1a 48 00 00       	push   $0x481a
    20c8:	6a 01                	push   $0x1
    20ca:	e8 a1 19 00 00       	call   3a70 <printf>
}
    20cf:	83 c4 10             	add    $0x10,%esp
    20d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    20d5:	c9                   	leave  
    20d6:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    20d7:	50                   	push   %eax
    20d8:	50                   	push   %eax
    20d9:	68 b7 45 00 00       	push   $0x45b7
    20de:	6a 01                	push   $0x1
    20e0:	e8 8b 19 00 00       	call   3a70 <printf>
    exit();
    20e5:	e8 18 18 00 00       	call   3902 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    20ea:	50                   	push   %eax
    20eb:	50                   	push   %eax
    20ec:	68 12 46 00 00       	push   $0x4612
    20f1:	6a 01                	push   $0x1
    20f3:	e8 78 19 00 00       	call   3a70 <printf>
    exit();
    20f8:	e8 05 18 00 00       	call   3902 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    20fd:	52                   	push   %edx
    20fe:	52                   	push   %edx
    20ff:	68 dd 45 00 00       	push   $0x45dd
    2104:	6a 01                	push   $0x1
    2106:	e8 65 19 00 00       	call   3a70 <printf>
    exit();
    210b:	e8 f2 17 00 00       	call   3902 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2110:	50                   	push   %eax
    2111:	50                   	push   %eax
    2112:	68 8f 46 00 00       	push   $0x468f
    2117:	6a 01                	push   $0x1
    2119:	e8 52 19 00 00       	call   3a70 <printf>
    exit();
    211e:	e8 df 17 00 00       	call   3902 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2123:	52                   	push   %edx
    2124:	52                   	push   %edx
    2125:	68 04 51 00 00       	push   $0x5104
    212a:	6a 01                	push   $0x1
    212c:	e8 3f 19 00 00       	call   3a70 <printf>
    exit();
    2131:	e8 cc 17 00 00       	call   3902 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2136:	52                   	push   %edx
    2137:	52                   	push   %edx
    2138:	68 23 47 00 00       	push   $0x4723
    213d:	6a 01                	push   $0x1
    213f:	e8 2c 19 00 00       	call   3a70 <printf>
    exit();
    2144:	e8 b9 17 00 00       	call   3902 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2149:	51                   	push   %ecx
    214a:	51                   	push   %ecx
    214b:	68 74 51 00 00       	push   $0x5174
    2150:	6a 01                	push   $0x1
    2152:	e8 19 19 00 00       	call   3a70 <printf>
    exit();
    2157:	e8 a6 17 00 00       	call   3902 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    215c:	50                   	push   %eax
    215d:	50                   	push   %eax
    215e:	68 9e 45 00 00       	push   $0x459e
    2163:	6a 01                	push   $0x1
    2165:	e8 06 19 00 00       	call   3a70 <printf>
    exit();
    216a:	e8 93 17 00 00       	call   3902 <exit>
    printf(1, "create dd/dd/ff failed\n");
    216f:	51                   	push   %ecx
    2170:	51                   	push   %ecx
    2171:	68 77 45 00 00       	push   $0x4577
    2176:	6a 01                	push   $0x1
    2178:	e8 f3 18 00 00       	call   3a70 <printf>
    exit();
    217d:	e8 80 17 00 00       	call   3902 <exit>
    printf(1, "chdir ./.. failed\n");
    2182:	50                   	push   %eax
    2183:	50                   	push   %eax
    2184:	68 40 46 00 00       	push   $0x4640
    2189:	6a 01                	push   $0x1
    218b:	e8 e0 18 00 00       	call   3a70 <printf>
    exit();
    2190:	e8 6d 17 00 00       	call   3902 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2195:	51                   	push   %ecx
    2196:	51                   	push   %ecx
    2197:	68 bc 50 00 00       	push   $0x50bc
    219c:	6a 01                	push   $0x1
    219e:	e8 cd 18 00 00       	call   3a70 <printf>
    exit();
    21a3:	e8 5a 17 00 00       	call   3902 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    21a8:	53                   	push   %ebx
    21a9:	53                   	push   %ebx
    21aa:	68 50 51 00 00       	push   $0x5150
    21af:	6a 01                	push   $0x1
    21b1:	e8 ba 18 00 00       	call   3a70 <printf>
    exit();
    21b6:	e8 47 17 00 00       	call   3902 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    21bb:	50                   	push   %eax
    21bc:	50                   	push   %eax
    21bd:	68 2c 51 00 00       	push   $0x512c
    21c2:	6a 01                	push   $0x1
    21c4:	e8 a7 18 00 00       	call   3a70 <printf>
    exit();
    21c9:	e8 34 17 00 00       	call   3902 <exit>
    printf(1, "open dd wronly succeeded!\n");
    21ce:	50                   	push   %eax
    21cf:	50                   	push   %eax
    21d0:	68 ff 46 00 00       	push   $0x46ff
    21d5:	6a 01                	push   $0x1
    21d7:	e8 94 18 00 00       	call   3a70 <printf>
    exit();
    21dc:	e8 21 17 00 00       	call   3902 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    21e1:	50                   	push   %eax
    21e2:	50                   	push   %eax
    21e3:	68 e6 46 00 00       	push   $0x46e6
    21e8:	6a 01                	push   $0x1
    21ea:	e8 81 18 00 00       	call   3a70 <printf>
    exit();
    21ef:	e8 0e 17 00 00       	call   3902 <exit>
    printf(1, "create dd succeeded!\n");
    21f4:	50                   	push   %eax
    21f5:	50                   	push   %eax
    21f6:	68 d0 46 00 00       	push   $0x46d0
    21fb:	6a 01                	push   $0x1
    21fd:	e8 6e 18 00 00       	call   3a70 <printf>
    exit();
    2202:	e8 fb 16 00 00       	call   3902 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    2207:	50                   	push   %eax
    2208:	50                   	push   %eax
    2209:	68 b4 46 00 00       	push   $0x46b4
    220e:	6a 01                	push   $0x1
    2210:	e8 5b 18 00 00       	call   3a70 <printf>
    exit();
    2215:	e8 e8 16 00 00       	call   3902 <exit>
    printf(1, "chdir dd failed\n");
    221a:	50                   	push   %eax
    221b:	50                   	push   %eax
    221c:	68 f5 45 00 00       	push   $0x45f5
    2221:	6a 01                	push   $0x1
    2223:	e8 48 18 00 00       	call   3a70 <printf>
    exit();
    2228:	e8 d5 16 00 00       	call   3902 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    222d:	50                   	push   %eax
    222e:	50                   	push   %eax
    222f:	68 e0 50 00 00       	push   $0x50e0
    2234:	6a 01                	push   $0x1
    2236:	e8 35 18 00 00       	call   3a70 <printf>
    exit();
    223b:	e8 c2 16 00 00       	call   3902 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    2240:	53                   	push   %ebx
    2241:	53                   	push   %ebx
    2242:	68 53 45 00 00       	push   $0x4553
    2247:	6a 01                	push   $0x1
    2249:	e8 22 18 00 00       	call   3a70 <printf>
    exit();
    224e:	e8 af 16 00 00       	call   3902 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2253:	50                   	push   %eax
    2254:	50                   	push   %eax
    2255:	68 94 50 00 00       	push   $0x5094
    225a:	6a 01                	push   $0x1
    225c:	e8 0f 18 00 00       	call   3a70 <printf>
    exit();
    2261:	e8 9c 16 00 00       	call   3902 <exit>
    printf(1, "create dd/ff failed\n");
    2266:	50                   	push   %eax
    2267:	50                   	push   %eax
    2268:	68 37 45 00 00       	push   $0x4537
    226d:	6a 01                	push   $0x1
    226f:	e8 fc 17 00 00       	call   3a70 <printf>
    exit();
    2274:	e8 89 16 00 00       	call   3902 <exit>
    printf(1, "subdir mkdir dd failed\n");
    2279:	50                   	push   %eax
    227a:	50                   	push   %eax
    227b:	68 1f 45 00 00       	push   $0x451f
    2280:	6a 01                	push   $0x1
    2282:	e8 e9 17 00 00       	call   3a70 <printf>
    exit();
    2287:	e8 76 16 00 00       	call   3902 <exit>
    printf(1, "unlink dd failed\n");
    228c:	50                   	push   %eax
    228d:	50                   	push   %eax
    228e:	68 08 48 00 00       	push   $0x4808
    2293:	6a 01                	push   $0x1
    2295:	e8 d6 17 00 00       	call   3a70 <printf>
    exit();
    229a:	e8 63 16 00 00       	call   3902 <exit>
    printf(1, "unlink dd/dd failed\n");
    229f:	52                   	push   %edx
    22a0:	52                   	push   %edx
    22a1:	68 f3 47 00 00       	push   $0x47f3
    22a6:	6a 01                	push   $0x1
    22a8:	e8 c3 17 00 00       	call   3a70 <printf>
    exit();
    22ad:	e8 50 16 00 00       	call   3902 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    22b2:	51                   	push   %ecx
    22b3:	51                   	push   %ecx
    22b4:	68 98 51 00 00       	push   $0x5198
    22b9:	6a 01                	push   $0x1
    22bb:	e8 b0 17 00 00       	call   3a70 <printf>
    exit();
    22c0:	e8 3d 16 00 00       	call   3902 <exit>
    printf(1, "unlink dd/ff failed\n");
    22c5:	53                   	push   %ebx
    22c6:	53                   	push   %ebx
    22c7:	68 de 47 00 00       	push   $0x47de
    22cc:	6a 01                	push   $0x1
    22ce:	e8 9d 17 00 00       	call   3a70 <printf>
    exit();
    22d3:	e8 2a 16 00 00       	call   3902 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    22d8:	50                   	push   %eax
    22d9:	50                   	push   %eax
    22da:	68 c6 47 00 00       	push   $0x47c6
    22df:	6a 01                	push   $0x1
    22e1:	e8 8a 17 00 00       	call   3a70 <printf>
    exit();
    22e6:	e8 17 16 00 00       	call   3902 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    22eb:	50                   	push   %eax
    22ec:	50                   	push   %eax
    22ed:	68 ae 47 00 00       	push   $0x47ae
    22f2:	6a 01                	push   $0x1
    22f4:	e8 77 17 00 00       	call   3a70 <printf>
    exit();
    22f9:	e8 04 16 00 00       	call   3902 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    22fe:	50                   	push   %eax
    22ff:	50                   	push   %eax
    2300:	68 92 47 00 00       	push   $0x4792
    2305:	6a 01                	push   $0x1
    2307:	e8 64 17 00 00       	call   3a70 <printf>
    exit();
    230c:	e8 f1 15 00 00       	call   3902 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2311:	50                   	push   %eax
    2312:	50                   	push   %eax
    2313:	68 76 47 00 00       	push   $0x4776
    2318:	6a 01                	push   $0x1
    231a:	e8 51 17 00 00       	call   3a70 <printf>
    exit();
    231f:	e8 de 15 00 00       	call   3902 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2324:	50                   	push   %eax
    2325:	50                   	push   %eax
    2326:	68 59 47 00 00       	push   $0x4759
    232b:	6a 01                	push   $0x1
    232d:	e8 3e 17 00 00       	call   3a70 <printf>
    exit();
    2332:	e8 cb 15 00 00       	call   3902 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2337:	50                   	push   %eax
    2338:	50                   	push   %eax
    2339:	68 3e 47 00 00       	push   $0x473e
    233e:	6a 01                	push   $0x1
    2340:	e8 2b 17 00 00       	call   3a70 <printf>
    exit();
    2345:	e8 b8 15 00 00       	call   3902 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    234a:	50                   	push   %eax
    234b:	50                   	push   %eax
    234c:	68 6b 46 00 00       	push   $0x466b
    2351:	6a 01                	push   $0x1
    2353:	e8 18 17 00 00       	call   3a70 <printf>
    exit();
    2358:	e8 a5 15 00 00       	call   3902 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    235d:	50                   	push   %eax
    235e:	50                   	push   %eax
    235f:	68 53 46 00 00       	push   $0x4653
    2364:	6a 01                	push   $0x1
    2366:	e8 05 17 00 00       	call   3a70 <printf>
    exit();
    236b:	e8 92 15 00 00       	call   3902 <exit>

00002370 <bigwrite>:
{
    2370:	55                   	push   %ebp
    2371:	89 e5                	mov    %esp,%ebp
    2373:	56                   	push   %esi
    2374:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    2375:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    237a:	83 ec 08             	sub    $0x8,%esp
    237d:	68 25 48 00 00       	push   $0x4825
    2382:	6a 01                	push   $0x1
    2384:	e8 e7 16 00 00       	call   3a70 <printf>
  unlink("bigwrite");
    2389:	c7 04 24 34 48 00 00 	movl   $0x4834,(%esp)
    2390:	e8 bd 15 00 00       	call   3952 <unlink>
    2395:	83 c4 10             	add    $0x10,%esp
    2398:	90                   	nop
    2399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    23a0:	83 ec 08             	sub    $0x8,%esp
    23a3:	68 02 02 00 00       	push   $0x202
    23a8:	68 34 48 00 00       	push   $0x4834
    23ad:	e8 90 15 00 00       	call   3942 <open>
    if(fd < 0){
    23b2:	83 c4 10             	add    $0x10,%esp
    23b5:	85 c0                	test   %eax,%eax
    fd = open("bigwrite", O_CREATE | O_RDWR);
    23b7:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    23b9:	78 7e                	js     2439 <bigwrite+0xc9>
      int cc = write(fd, buf, sz);
    23bb:	83 ec 04             	sub    $0x4,%esp
    23be:	53                   	push   %ebx
    23bf:	68 e0 86 00 00       	push   $0x86e0
    23c4:	50                   	push   %eax
    23c5:	e8 58 15 00 00       	call   3922 <write>
      if(cc != sz){
    23ca:	83 c4 10             	add    $0x10,%esp
    23cd:	39 d8                	cmp    %ebx,%eax
    23cf:	75 55                	jne    2426 <bigwrite+0xb6>
      int cc = write(fd, buf, sz);
    23d1:	83 ec 04             	sub    $0x4,%esp
    23d4:	53                   	push   %ebx
    23d5:	68 e0 86 00 00       	push   $0x86e0
    23da:	56                   	push   %esi
    23db:	e8 42 15 00 00       	call   3922 <write>
      if(cc != sz){
    23e0:	83 c4 10             	add    $0x10,%esp
    23e3:	39 d8                	cmp    %ebx,%eax
    23e5:	75 3f                	jne    2426 <bigwrite+0xb6>
    close(fd);
    23e7:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    23ea:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    23f0:	56                   	push   %esi
    23f1:	e8 34 15 00 00       	call   392a <close>
    unlink("bigwrite");
    23f6:	c7 04 24 34 48 00 00 	movl   $0x4834,(%esp)
    23fd:	e8 50 15 00 00       	call   3952 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2402:	83 c4 10             	add    $0x10,%esp
    2405:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    240b:	75 93                	jne    23a0 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    240d:	83 ec 08             	sub    $0x8,%esp
    2410:	68 67 48 00 00       	push   $0x4867
    2415:	6a 01                	push   $0x1
    2417:	e8 54 16 00 00       	call   3a70 <printf>
}
    241c:	83 c4 10             	add    $0x10,%esp
    241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2422:	5b                   	pop    %ebx
    2423:	5e                   	pop    %esi
    2424:	5d                   	pop    %ebp
    2425:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    2426:	50                   	push   %eax
    2427:	53                   	push   %ebx
    2428:	68 55 48 00 00       	push   $0x4855
    242d:	6a 01                	push   $0x1
    242f:	e8 3c 16 00 00       	call   3a70 <printf>
        exit();
    2434:	e8 c9 14 00 00       	call   3902 <exit>
      printf(1, "cannot create bigwrite\n");
    2439:	83 ec 08             	sub    $0x8,%esp
    243c:	68 3d 48 00 00       	push   $0x483d
    2441:	6a 01                	push   $0x1
    2443:	e8 28 16 00 00       	call   3a70 <printf>
      exit();
    2448:	e8 b5 14 00 00       	call   3902 <exit>
    244d:	8d 76 00             	lea    0x0(%esi),%esi

00002450 <bigfile>:
{
    2450:	55                   	push   %ebp
    2451:	89 e5                	mov    %esp,%ebp
    2453:	57                   	push   %edi
    2454:	56                   	push   %esi
    2455:	53                   	push   %ebx
    2456:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    2459:	68 74 48 00 00       	push   $0x4874
    245e:	6a 01                	push   $0x1
    2460:	e8 0b 16 00 00       	call   3a70 <printf>
  unlink("bigfile");
    2465:	c7 04 24 90 48 00 00 	movl   $0x4890,(%esp)
    246c:	e8 e1 14 00 00       	call   3952 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2471:	58                   	pop    %eax
    2472:	5a                   	pop    %edx
    2473:	68 02 02 00 00       	push   $0x202
    2478:	68 90 48 00 00       	push   $0x4890
    247d:	e8 c0 14 00 00       	call   3942 <open>
  if(fd < 0){
    2482:	83 c4 10             	add    $0x10,%esp
    2485:	85 c0                	test   %eax,%eax
    2487:	0f 88 5e 01 00 00    	js     25eb <bigfile+0x19b>
    248d:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    248f:	31 db                	xor    %ebx,%ebx
    2491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(buf, i, 600);
    2498:	83 ec 04             	sub    $0x4,%esp
    249b:	68 58 02 00 00       	push   $0x258
    24a0:	53                   	push   %ebx
    24a1:	68 e0 86 00 00       	push   $0x86e0
    24a6:	e8 b5 12 00 00       	call   3760 <memset>
    if(write(fd, buf, 600) != 600){
    24ab:	83 c4 0c             	add    $0xc,%esp
    24ae:	68 58 02 00 00       	push   $0x258
    24b3:	68 e0 86 00 00       	push   $0x86e0
    24b8:	56                   	push   %esi
    24b9:	e8 64 14 00 00       	call   3922 <write>
    24be:	83 c4 10             	add    $0x10,%esp
    24c1:	3d 58 02 00 00       	cmp    $0x258,%eax
    24c6:	0f 85 f8 00 00 00    	jne    25c4 <bigfile+0x174>
  for(i = 0; i < 20; i++){
    24cc:	83 c3 01             	add    $0x1,%ebx
    24cf:	83 fb 14             	cmp    $0x14,%ebx
    24d2:	75 c4                	jne    2498 <bigfile+0x48>
  close(fd);
    24d4:	83 ec 0c             	sub    $0xc,%esp
    24d7:	56                   	push   %esi
    24d8:	e8 4d 14 00 00       	call   392a <close>
  fd = open("bigfile", 0);
    24dd:	5e                   	pop    %esi
    24de:	5f                   	pop    %edi
    24df:	6a 00                	push   $0x0
    24e1:	68 90 48 00 00       	push   $0x4890
    24e6:	e8 57 14 00 00       	call   3942 <open>
  if(fd < 0){
    24eb:	83 c4 10             	add    $0x10,%esp
    24ee:	85 c0                	test   %eax,%eax
  fd = open("bigfile", 0);
    24f0:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    24f2:	0f 88 e0 00 00 00    	js     25d8 <bigfile+0x188>
  total = 0;
    24f8:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    24fa:	31 ff                	xor    %edi,%edi
    24fc:	eb 30                	jmp    252e <bigfile+0xde>
    24fe:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    2500:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2505:	0f 85 91 00 00 00    	jne    259c <bigfile+0x14c>
    if(buf[0] != i/2 || buf[299] != i/2){
    250b:	0f be 05 e0 86 00 00 	movsbl 0x86e0,%eax
    2512:	89 fa                	mov    %edi,%edx
    2514:	d1 fa                	sar    %edx
    2516:	39 d0                	cmp    %edx,%eax
    2518:	75 6e                	jne    2588 <bigfile+0x138>
    251a:	0f be 15 0b 88 00 00 	movsbl 0x880b,%edx
    2521:	39 d0                	cmp    %edx,%eax
    2523:	75 63                	jne    2588 <bigfile+0x138>
    total += cc;
    2525:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    252b:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    252e:	83 ec 04             	sub    $0x4,%esp
    2531:	68 2c 01 00 00       	push   $0x12c
    2536:	68 e0 86 00 00       	push   $0x86e0
    253b:	56                   	push   %esi
    253c:	e8 d9 13 00 00       	call   391a <read>
    if(cc < 0){
    2541:	83 c4 10             	add    $0x10,%esp
    2544:	85 c0                	test   %eax,%eax
    2546:	78 68                	js     25b0 <bigfile+0x160>
    if(cc == 0)
    2548:	75 b6                	jne    2500 <bigfile+0xb0>
  close(fd);
    254a:	83 ec 0c             	sub    $0xc,%esp
    254d:	56                   	push   %esi
    254e:	e8 d7 13 00 00       	call   392a <close>
  if(total != 20*600){
    2553:	83 c4 10             	add    $0x10,%esp
    2556:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    255c:	0f 85 9c 00 00 00    	jne    25fe <bigfile+0x1ae>
  unlink("bigfile");
    2562:	83 ec 0c             	sub    $0xc,%esp
    2565:	68 90 48 00 00       	push   $0x4890
    256a:	e8 e3 13 00 00       	call   3952 <unlink>
  printf(1, "bigfile test ok\n");
    256f:	58                   	pop    %eax
    2570:	5a                   	pop    %edx
    2571:	68 1f 49 00 00       	push   $0x491f
    2576:	6a 01                	push   $0x1
    2578:	e8 f3 14 00 00       	call   3a70 <printf>
}
    257d:	83 c4 10             	add    $0x10,%esp
    2580:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2583:	5b                   	pop    %ebx
    2584:	5e                   	pop    %esi
    2585:	5f                   	pop    %edi
    2586:	5d                   	pop    %ebp
    2587:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    2588:	83 ec 08             	sub    $0x8,%esp
    258b:	68 ec 48 00 00       	push   $0x48ec
    2590:	6a 01                	push   $0x1
    2592:	e8 d9 14 00 00       	call   3a70 <printf>
      exit();
    2597:	e8 66 13 00 00       	call   3902 <exit>
      printf(1, "short read bigfile\n");
    259c:	83 ec 08             	sub    $0x8,%esp
    259f:	68 d8 48 00 00       	push   $0x48d8
    25a4:	6a 01                	push   $0x1
    25a6:	e8 c5 14 00 00       	call   3a70 <printf>
      exit();
    25ab:	e8 52 13 00 00       	call   3902 <exit>
      printf(1, "read bigfile failed\n");
    25b0:	83 ec 08             	sub    $0x8,%esp
    25b3:	68 c3 48 00 00       	push   $0x48c3
    25b8:	6a 01                	push   $0x1
    25ba:	e8 b1 14 00 00       	call   3a70 <printf>
      exit();
    25bf:	e8 3e 13 00 00       	call   3902 <exit>
      printf(1, "write bigfile failed\n");
    25c4:	83 ec 08             	sub    $0x8,%esp
    25c7:	68 98 48 00 00       	push   $0x4898
    25cc:	6a 01                	push   $0x1
    25ce:	e8 9d 14 00 00       	call   3a70 <printf>
      exit();
    25d3:	e8 2a 13 00 00       	call   3902 <exit>
    printf(1, "cannot open bigfile\n");
    25d8:	53                   	push   %ebx
    25d9:	53                   	push   %ebx
    25da:	68 ae 48 00 00       	push   $0x48ae
    25df:	6a 01                	push   $0x1
    25e1:	e8 8a 14 00 00       	call   3a70 <printf>
    exit();
    25e6:	e8 17 13 00 00       	call   3902 <exit>
    printf(1, "cannot create bigfile");
    25eb:	50                   	push   %eax
    25ec:	50                   	push   %eax
    25ed:	68 82 48 00 00       	push   $0x4882
    25f2:	6a 01                	push   $0x1
    25f4:	e8 77 14 00 00       	call   3a70 <printf>
    exit();
    25f9:	e8 04 13 00 00       	call   3902 <exit>
    printf(1, "read bigfile wrong total\n");
    25fe:	51                   	push   %ecx
    25ff:	51                   	push   %ecx
    2600:	68 05 49 00 00       	push   $0x4905
    2605:	6a 01                	push   $0x1
    2607:	e8 64 14 00 00       	call   3a70 <printf>
    exit();
    260c:	e8 f1 12 00 00       	call   3902 <exit>
    2611:	eb 0d                	jmp    2620 <fourteen>
    2613:	90                   	nop
    2614:	90                   	nop
    2615:	90                   	nop
    2616:	90                   	nop
    2617:	90                   	nop
    2618:	90                   	nop
    2619:	90                   	nop
    261a:	90                   	nop
    261b:	90                   	nop
    261c:	90                   	nop
    261d:	90                   	nop
    261e:	90                   	nop
    261f:	90                   	nop

00002620 <fourteen>:
{
    2620:	55                   	push   %ebp
    2621:	89 e5                	mov    %esp,%ebp
    2623:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    2626:	68 30 49 00 00       	push   $0x4930
    262b:	6a 01                	push   $0x1
    262d:	e8 3e 14 00 00       	call   3a70 <printf>
  if(mkdir("12345678901234") != 0){
    2632:	c7 04 24 6b 49 00 00 	movl   $0x496b,(%esp)
    2639:	e8 2c 13 00 00       	call   396a <mkdir>
    263e:	83 c4 10             	add    $0x10,%esp
    2641:	85 c0                	test   %eax,%eax
    2643:	0f 85 97 00 00 00    	jne    26e0 <fourteen+0xc0>
  if(mkdir("12345678901234/123456789012345") != 0){
    2649:	83 ec 0c             	sub    $0xc,%esp
    264c:	68 b8 51 00 00       	push   $0x51b8
    2651:	e8 14 13 00 00       	call   396a <mkdir>
    2656:	83 c4 10             	add    $0x10,%esp
    2659:	85 c0                	test   %eax,%eax
    265b:	0f 85 de 00 00 00    	jne    273f <fourteen+0x11f>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2661:	83 ec 08             	sub    $0x8,%esp
    2664:	68 00 02 00 00       	push   $0x200
    2669:	68 08 52 00 00       	push   $0x5208
    266e:	e8 cf 12 00 00       	call   3942 <open>
  if(fd < 0){
    2673:	83 c4 10             	add    $0x10,%esp
    2676:	85 c0                	test   %eax,%eax
    2678:	0f 88 ae 00 00 00    	js     272c <fourteen+0x10c>
  close(fd);
    267e:	83 ec 0c             	sub    $0xc,%esp
    2681:	50                   	push   %eax
    2682:	e8 a3 12 00 00       	call   392a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2687:	58                   	pop    %eax
    2688:	5a                   	pop    %edx
    2689:	6a 00                	push   $0x0
    268b:	68 78 52 00 00       	push   $0x5278
    2690:	e8 ad 12 00 00       	call   3942 <open>
  if(fd < 0){
    2695:	83 c4 10             	add    $0x10,%esp
    2698:	85 c0                	test   %eax,%eax
    269a:	78 7d                	js     2719 <fourteen+0xf9>
  close(fd);
    269c:	83 ec 0c             	sub    $0xc,%esp
    269f:	50                   	push   %eax
    26a0:	e8 85 12 00 00       	call   392a <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    26a5:	c7 04 24 5c 49 00 00 	movl   $0x495c,(%esp)
    26ac:	e8 b9 12 00 00       	call   396a <mkdir>
    26b1:	83 c4 10             	add    $0x10,%esp
    26b4:	85 c0                	test   %eax,%eax
    26b6:	74 4e                	je     2706 <fourteen+0xe6>
  if(mkdir("123456789012345/12345678901234") == 0){
    26b8:	83 ec 0c             	sub    $0xc,%esp
    26bb:	68 14 53 00 00       	push   $0x5314
    26c0:	e8 a5 12 00 00       	call   396a <mkdir>
    26c5:	83 c4 10             	add    $0x10,%esp
    26c8:	85 c0                	test   %eax,%eax
    26ca:	74 27                	je     26f3 <fourteen+0xd3>
  printf(1, "fourteen ok\n");
    26cc:	83 ec 08             	sub    $0x8,%esp
    26cf:	68 7a 49 00 00       	push   $0x497a
    26d4:	6a 01                	push   $0x1
    26d6:	e8 95 13 00 00       	call   3a70 <printf>
}
    26db:	83 c4 10             	add    $0x10,%esp
    26de:	c9                   	leave  
    26df:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    26e0:	50                   	push   %eax
    26e1:	50                   	push   %eax
    26e2:	68 3f 49 00 00       	push   $0x493f
    26e7:	6a 01                	push   $0x1
    26e9:	e8 82 13 00 00       	call   3a70 <printf>
    exit();
    26ee:	e8 0f 12 00 00       	call   3902 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    26f3:	50                   	push   %eax
    26f4:	50                   	push   %eax
    26f5:	68 34 53 00 00       	push   $0x5334
    26fa:	6a 01                	push   $0x1
    26fc:	e8 6f 13 00 00       	call   3a70 <printf>
    exit();
    2701:	e8 fc 11 00 00       	call   3902 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2706:	52                   	push   %edx
    2707:	52                   	push   %edx
    2708:	68 e4 52 00 00       	push   $0x52e4
    270d:	6a 01                	push   $0x1
    270f:	e8 5c 13 00 00       	call   3a70 <printf>
    exit();
    2714:	e8 e9 11 00 00       	call   3902 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2719:	51                   	push   %ecx
    271a:	51                   	push   %ecx
    271b:	68 a8 52 00 00       	push   $0x52a8
    2720:	6a 01                	push   $0x1
    2722:	e8 49 13 00 00       	call   3a70 <printf>
    exit();
    2727:	e8 d6 11 00 00       	call   3902 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    272c:	51                   	push   %ecx
    272d:	51                   	push   %ecx
    272e:	68 38 52 00 00       	push   $0x5238
    2733:	6a 01                	push   $0x1
    2735:	e8 36 13 00 00       	call   3a70 <printf>
    exit();
    273a:	e8 c3 11 00 00       	call   3902 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    273f:	50                   	push   %eax
    2740:	50                   	push   %eax
    2741:	68 d8 51 00 00       	push   $0x51d8
    2746:	6a 01                	push   $0x1
    2748:	e8 23 13 00 00       	call   3a70 <printf>
    exit();
    274d:	e8 b0 11 00 00       	call   3902 <exit>
    2752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002760 <rmdot>:
{
    2760:	55                   	push   %ebp
    2761:	89 e5                	mov    %esp,%ebp
    2763:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    2766:	68 87 49 00 00       	push   $0x4987
    276b:	6a 01                	push   $0x1
    276d:	e8 fe 12 00 00       	call   3a70 <printf>
  if(mkdir("dots") != 0){
    2772:	c7 04 24 93 49 00 00 	movl   $0x4993,(%esp)
    2779:	e8 ec 11 00 00       	call   396a <mkdir>
    277e:	83 c4 10             	add    $0x10,%esp
    2781:	85 c0                	test   %eax,%eax
    2783:	0f 85 b0 00 00 00    	jne    2839 <rmdot+0xd9>
  if(chdir("dots") != 0){
    2789:	83 ec 0c             	sub    $0xc,%esp
    278c:	68 93 49 00 00       	push   $0x4993
    2791:	e8 dc 11 00 00       	call   3972 <chdir>
    2796:	83 c4 10             	add    $0x10,%esp
    2799:	85 c0                	test   %eax,%eax
    279b:	0f 85 1d 01 00 00    	jne    28be <rmdot+0x15e>
  if(unlink(".") == 0){
    27a1:	83 ec 0c             	sub    $0xc,%esp
    27a4:	68 3e 46 00 00       	push   $0x463e
    27a9:	e8 a4 11 00 00       	call   3952 <unlink>
    27ae:	83 c4 10             	add    $0x10,%esp
    27b1:	85 c0                	test   %eax,%eax
    27b3:	0f 84 f2 00 00 00    	je     28ab <rmdot+0x14b>
  if(unlink("..") == 0){
    27b9:	83 ec 0c             	sub    $0xc,%esp
    27bc:	68 3d 46 00 00       	push   $0x463d
    27c1:	e8 8c 11 00 00       	call   3952 <unlink>
    27c6:	83 c4 10             	add    $0x10,%esp
    27c9:	85 c0                	test   %eax,%eax
    27cb:	0f 84 c7 00 00 00    	je     2898 <rmdot+0x138>
  if(chdir("/") != 0){
    27d1:	83 ec 0c             	sub    $0xc,%esp
    27d4:	68 11 3e 00 00       	push   $0x3e11
    27d9:	e8 94 11 00 00       	call   3972 <chdir>
    27de:	83 c4 10             	add    $0x10,%esp
    27e1:	85 c0                	test   %eax,%eax
    27e3:	0f 85 9c 00 00 00    	jne    2885 <rmdot+0x125>
  if(unlink("dots/.") == 0){
    27e9:	83 ec 0c             	sub    $0xc,%esp
    27ec:	68 db 49 00 00       	push   $0x49db
    27f1:	e8 5c 11 00 00       	call   3952 <unlink>
    27f6:	83 c4 10             	add    $0x10,%esp
    27f9:	85 c0                	test   %eax,%eax
    27fb:	74 75                	je     2872 <rmdot+0x112>
  if(unlink("dots/..") == 0){
    27fd:	83 ec 0c             	sub    $0xc,%esp
    2800:	68 f9 49 00 00       	push   $0x49f9
    2805:	e8 48 11 00 00       	call   3952 <unlink>
    280a:	83 c4 10             	add    $0x10,%esp
    280d:	85 c0                	test   %eax,%eax
    280f:	74 4e                	je     285f <rmdot+0xff>
  if(unlink("dots") != 0){
    2811:	83 ec 0c             	sub    $0xc,%esp
    2814:	68 93 49 00 00       	push   $0x4993
    2819:	e8 34 11 00 00       	call   3952 <unlink>
    281e:	83 c4 10             	add    $0x10,%esp
    2821:	85 c0                	test   %eax,%eax
    2823:	75 27                	jne    284c <rmdot+0xec>
  printf(1, "rmdot ok\n");
    2825:	83 ec 08             	sub    $0x8,%esp
    2828:	68 2e 4a 00 00       	push   $0x4a2e
    282d:	6a 01                	push   $0x1
    282f:	e8 3c 12 00 00       	call   3a70 <printf>
}
    2834:	83 c4 10             	add    $0x10,%esp
    2837:	c9                   	leave  
    2838:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    2839:	50                   	push   %eax
    283a:	50                   	push   %eax
    283b:	68 98 49 00 00       	push   $0x4998
    2840:	6a 01                	push   $0x1
    2842:	e8 29 12 00 00       	call   3a70 <printf>
    exit();
    2847:	e8 b6 10 00 00       	call   3902 <exit>
    printf(1, "unlink dots failed!\n");
    284c:	50                   	push   %eax
    284d:	50                   	push   %eax
    284e:	68 19 4a 00 00       	push   $0x4a19
    2853:	6a 01                	push   $0x1
    2855:	e8 16 12 00 00       	call   3a70 <printf>
    exit();
    285a:	e8 a3 10 00 00       	call   3902 <exit>
    printf(1, "unlink dots/.. worked!\n");
    285f:	52                   	push   %edx
    2860:	52                   	push   %edx
    2861:	68 01 4a 00 00       	push   $0x4a01
    2866:	6a 01                	push   $0x1
    2868:	e8 03 12 00 00       	call   3a70 <printf>
    exit();
    286d:	e8 90 10 00 00       	call   3902 <exit>
    printf(1, "unlink dots/. worked!\n");
    2872:	51                   	push   %ecx
    2873:	51                   	push   %ecx
    2874:	68 e2 49 00 00       	push   $0x49e2
    2879:	6a 01                	push   $0x1
    287b:	e8 f0 11 00 00       	call   3a70 <printf>
    exit();
    2880:	e8 7d 10 00 00       	call   3902 <exit>
    printf(1, "chdir / failed\n");
    2885:	50                   	push   %eax
    2886:	50                   	push   %eax
    2887:	68 13 3e 00 00       	push   $0x3e13
    288c:	6a 01                	push   $0x1
    288e:	e8 dd 11 00 00       	call   3a70 <printf>
    exit();
    2893:	e8 6a 10 00 00       	call   3902 <exit>
    printf(1, "rm .. worked!\n");
    2898:	50                   	push   %eax
    2899:	50                   	push   %eax
    289a:	68 cc 49 00 00       	push   $0x49cc
    289f:	6a 01                	push   $0x1
    28a1:	e8 ca 11 00 00       	call   3a70 <printf>
    exit();
    28a6:	e8 57 10 00 00       	call   3902 <exit>
    printf(1, "rm . worked!\n");
    28ab:	50                   	push   %eax
    28ac:	50                   	push   %eax
    28ad:	68 be 49 00 00       	push   $0x49be
    28b2:	6a 01                	push   $0x1
    28b4:	e8 b7 11 00 00       	call   3a70 <printf>
    exit();
    28b9:	e8 44 10 00 00       	call   3902 <exit>
    printf(1, "chdir dots failed\n");
    28be:	50                   	push   %eax
    28bf:	50                   	push   %eax
    28c0:	68 ab 49 00 00       	push   $0x49ab
    28c5:	6a 01                	push   $0x1
    28c7:	e8 a4 11 00 00       	call   3a70 <printf>
    exit();
    28cc:	e8 31 10 00 00       	call   3902 <exit>
    28d1:	eb 0d                	jmp    28e0 <dirfile>
    28d3:	90                   	nop
    28d4:	90                   	nop
    28d5:	90                   	nop
    28d6:	90                   	nop
    28d7:	90                   	nop
    28d8:	90                   	nop
    28d9:	90                   	nop
    28da:	90                   	nop
    28db:	90                   	nop
    28dc:	90                   	nop
    28dd:	90                   	nop
    28de:	90                   	nop
    28df:	90                   	nop

000028e0 <dirfile>:
{
    28e0:	55                   	push   %ebp
    28e1:	89 e5                	mov    %esp,%ebp
    28e3:	53                   	push   %ebx
    28e4:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    28e7:	68 38 4a 00 00       	push   $0x4a38
    28ec:	6a 01                	push   $0x1
    28ee:	e8 7d 11 00 00       	call   3a70 <printf>
  fd = open("dirfile", O_CREATE);
    28f3:	59                   	pop    %ecx
    28f4:	5b                   	pop    %ebx
    28f5:	68 00 02 00 00       	push   $0x200
    28fa:	68 45 4a 00 00       	push   $0x4a45
    28ff:	e8 3e 10 00 00       	call   3942 <open>
  if(fd < 0){
    2904:	83 c4 10             	add    $0x10,%esp
    2907:	85 c0                	test   %eax,%eax
    2909:	0f 88 43 01 00 00    	js     2a52 <dirfile+0x172>
  close(fd);
    290f:	83 ec 0c             	sub    $0xc,%esp
    2912:	50                   	push   %eax
    2913:	e8 12 10 00 00       	call   392a <close>
  if(chdir("dirfile") == 0){
    2918:	c7 04 24 45 4a 00 00 	movl   $0x4a45,(%esp)
    291f:	e8 4e 10 00 00       	call   3972 <chdir>
    2924:	83 c4 10             	add    $0x10,%esp
    2927:	85 c0                	test   %eax,%eax
    2929:	0f 84 10 01 00 00    	je     2a3f <dirfile+0x15f>
  fd = open("dirfile/xx", 0);
    292f:	83 ec 08             	sub    $0x8,%esp
    2932:	6a 00                	push   $0x0
    2934:	68 7e 4a 00 00       	push   $0x4a7e
    2939:	e8 04 10 00 00       	call   3942 <open>
  if(fd >= 0){
    293e:	83 c4 10             	add    $0x10,%esp
    2941:	85 c0                	test   %eax,%eax
    2943:	0f 89 e3 00 00 00    	jns    2a2c <dirfile+0x14c>
  fd = open("dirfile/xx", O_CREATE);
    2949:	83 ec 08             	sub    $0x8,%esp
    294c:	68 00 02 00 00       	push   $0x200
    2951:	68 7e 4a 00 00       	push   $0x4a7e
    2956:	e8 e7 0f 00 00       	call   3942 <open>
  if(fd >= 0){
    295b:	83 c4 10             	add    $0x10,%esp
    295e:	85 c0                	test   %eax,%eax
    2960:	0f 89 c6 00 00 00    	jns    2a2c <dirfile+0x14c>
  if(mkdir("dirfile/xx") == 0){
    2966:	83 ec 0c             	sub    $0xc,%esp
    2969:	68 7e 4a 00 00       	push   $0x4a7e
    296e:	e8 f7 0f 00 00       	call   396a <mkdir>
    2973:	83 c4 10             	add    $0x10,%esp
    2976:	85 c0                	test   %eax,%eax
    2978:	0f 84 46 01 00 00    	je     2ac4 <dirfile+0x1e4>
  if(unlink("dirfile/xx") == 0){
    297e:	83 ec 0c             	sub    $0xc,%esp
    2981:	68 7e 4a 00 00       	push   $0x4a7e
    2986:	e8 c7 0f 00 00       	call   3952 <unlink>
    298b:	83 c4 10             	add    $0x10,%esp
    298e:	85 c0                	test   %eax,%eax
    2990:	0f 84 1b 01 00 00    	je     2ab1 <dirfile+0x1d1>
  if(link("README", "dirfile/xx") == 0){
    2996:	83 ec 08             	sub    $0x8,%esp
    2999:	68 7e 4a 00 00       	push   $0x4a7e
    299e:	68 e2 4a 00 00       	push   $0x4ae2
    29a3:	e8 ba 0f 00 00       	call   3962 <link>
    29a8:	83 c4 10             	add    $0x10,%esp
    29ab:	85 c0                	test   %eax,%eax
    29ad:	0f 84 eb 00 00 00    	je     2a9e <dirfile+0x1be>
  if(unlink("dirfile") != 0){
    29b3:	83 ec 0c             	sub    $0xc,%esp
    29b6:	68 45 4a 00 00       	push   $0x4a45
    29bb:	e8 92 0f 00 00       	call   3952 <unlink>
    29c0:	83 c4 10             	add    $0x10,%esp
    29c3:	85 c0                	test   %eax,%eax
    29c5:	0f 85 c0 00 00 00    	jne    2a8b <dirfile+0x1ab>
  fd = open(".", O_RDWR);
    29cb:	83 ec 08             	sub    $0x8,%esp
    29ce:	6a 02                	push   $0x2
    29d0:	68 3e 46 00 00       	push   $0x463e
    29d5:	e8 68 0f 00 00       	call   3942 <open>
  if(fd >= 0){
    29da:	83 c4 10             	add    $0x10,%esp
    29dd:	85 c0                	test   %eax,%eax
    29df:	0f 89 93 00 00 00    	jns    2a78 <dirfile+0x198>
  fd = open(".", 0);
    29e5:	83 ec 08             	sub    $0x8,%esp
    29e8:	6a 00                	push   $0x0
    29ea:	68 3e 46 00 00       	push   $0x463e
    29ef:	e8 4e 0f 00 00       	call   3942 <open>
  if(write(fd, "x", 1) > 0){
    29f4:	83 c4 0c             	add    $0xc,%esp
  fd = open(".", 0);
    29f7:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    29f9:	6a 01                	push   $0x1
    29fb:	68 21 47 00 00       	push   $0x4721
    2a00:	50                   	push   %eax
    2a01:	e8 1c 0f 00 00       	call   3922 <write>
    2a06:	83 c4 10             	add    $0x10,%esp
    2a09:	85 c0                	test   %eax,%eax
    2a0b:	7f 58                	jg     2a65 <dirfile+0x185>
  close(fd);
    2a0d:	83 ec 0c             	sub    $0xc,%esp
    2a10:	53                   	push   %ebx
    2a11:	e8 14 0f 00 00       	call   392a <close>
  printf(1, "dir vs file OK\n");
    2a16:	58                   	pop    %eax
    2a17:	5a                   	pop    %edx
    2a18:	68 15 4b 00 00       	push   $0x4b15
    2a1d:	6a 01                	push   $0x1
    2a1f:	e8 4c 10 00 00       	call   3a70 <printf>
}
    2a24:	83 c4 10             	add    $0x10,%esp
    2a27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2a2a:	c9                   	leave  
    2a2b:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2a2c:	50                   	push   %eax
    2a2d:	50                   	push   %eax
    2a2e:	68 89 4a 00 00       	push   $0x4a89
    2a33:	6a 01                	push   $0x1
    2a35:	e8 36 10 00 00       	call   3a70 <printf>
    exit();
    2a3a:	e8 c3 0e 00 00       	call   3902 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2a3f:	50                   	push   %eax
    2a40:	50                   	push   %eax
    2a41:	68 64 4a 00 00       	push   $0x4a64
    2a46:	6a 01                	push   $0x1
    2a48:	e8 23 10 00 00       	call   3a70 <printf>
    exit();
    2a4d:	e8 b0 0e 00 00       	call   3902 <exit>
    printf(1, "create dirfile failed\n");
    2a52:	52                   	push   %edx
    2a53:	52                   	push   %edx
    2a54:	68 4d 4a 00 00       	push   $0x4a4d
    2a59:	6a 01                	push   $0x1
    2a5b:	e8 10 10 00 00       	call   3a70 <printf>
    exit();
    2a60:	e8 9d 0e 00 00       	call   3902 <exit>
    printf(1, "write . succeeded!\n");
    2a65:	51                   	push   %ecx
    2a66:	51                   	push   %ecx
    2a67:	68 01 4b 00 00       	push   $0x4b01
    2a6c:	6a 01                	push   $0x1
    2a6e:	e8 fd 0f 00 00       	call   3a70 <printf>
    exit();
    2a73:	e8 8a 0e 00 00       	call   3902 <exit>
    printf(1, "open . for writing succeeded!\n");
    2a78:	53                   	push   %ebx
    2a79:	53                   	push   %ebx
    2a7a:	68 88 53 00 00       	push   $0x5388
    2a7f:	6a 01                	push   $0x1
    2a81:	e8 ea 0f 00 00       	call   3a70 <printf>
    exit();
    2a86:	e8 77 0e 00 00       	call   3902 <exit>
    printf(1, "unlink dirfile failed!\n");
    2a8b:	50                   	push   %eax
    2a8c:	50                   	push   %eax
    2a8d:	68 e9 4a 00 00       	push   $0x4ae9
    2a92:	6a 01                	push   $0x1
    2a94:	e8 d7 0f 00 00       	call   3a70 <printf>
    exit();
    2a99:	e8 64 0e 00 00       	call   3902 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2a9e:	50                   	push   %eax
    2a9f:	50                   	push   %eax
    2aa0:	68 68 53 00 00       	push   $0x5368
    2aa5:	6a 01                	push   $0x1
    2aa7:	e8 c4 0f 00 00       	call   3a70 <printf>
    exit();
    2aac:	e8 51 0e 00 00       	call   3902 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2ab1:	50                   	push   %eax
    2ab2:	50                   	push   %eax
    2ab3:	68 c4 4a 00 00       	push   $0x4ac4
    2ab8:	6a 01                	push   $0x1
    2aba:	e8 b1 0f 00 00       	call   3a70 <printf>
    exit();
    2abf:	e8 3e 0e 00 00       	call   3902 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2ac4:	50                   	push   %eax
    2ac5:	50                   	push   %eax
    2ac6:	68 a7 4a 00 00       	push   $0x4aa7
    2acb:	6a 01                	push   $0x1
    2acd:	e8 9e 0f 00 00       	call   3a70 <printf>
    exit();
    2ad2:	e8 2b 0e 00 00       	call   3902 <exit>
    2ad7:	89 f6                	mov    %esi,%esi
    2ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002ae0 <iref>:
{
    2ae0:	55                   	push   %ebp
    2ae1:	89 e5                	mov    %esp,%ebp
    2ae3:	53                   	push   %ebx
  printf(1, "empty file name\n");
    2ae4:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    2ae9:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    2aec:	68 25 4b 00 00       	push   $0x4b25
    2af1:	6a 01                	push   $0x1
    2af3:	e8 78 0f 00 00       	call   3a70 <printf>
    2af8:	83 c4 10             	add    $0x10,%esp
    2afb:	90                   	nop
    2afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mkdir("irefd") != 0){
    2b00:	83 ec 0c             	sub    $0xc,%esp
    2b03:	68 36 4b 00 00       	push   $0x4b36
    2b08:	e8 5d 0e 00 00       	call   396a <mkdir>
    2b0d:	83 c4 10             	add    $0x10,%esp
    2b10:	85 c0                	test   %eax,%eax
    2b12:	0f 85 bb 00 00 00    	jne    2bd3 <iref+0xf3>
    if(chdir("irefd") != 0){
    2b18:	83 ec 0c             	sub    $0xc,%esp
    2b1b:	68 36 4b 00 00       	push   $0x4b36
    2b20:	e8 4d 0e 00 00       	call   3972 <chdir>
    2b25:	83 c4 10             	add    $0x10,%esp
    2b28:	85 c0                	test   %eax,%eax
    2b2a:	0f 85 b7 00 00 00    	jne    2be7 <iref+0x107>
    mkdir("");
    2b30:	83 ec 0c             	sub    $0xc,%esp
    2b33:	68 eb 41 00 00       	push   $0x41eb
    2b38:	e8 2d 0e 00 00       	call   396a <mkdir>
    link("README", "");
    2b3d:	59                   	pop    %ecx
    2b3e:	58                   	pop    %eax
    2b3f:	68 eb 41 00 00       	push   $0x41eb
    2b44:	68 e2 4a 00 00       	push   $0x4ae2
    2b49:	e8 14 0e 00 00       	call   3962 <link>
    fd = open("", O_CREATE);
    2b4e:	58                   	pop    %eax
    2b4f:	5a                   	pop    %edx
    2b50:	68 00 02 00 00       	push   $0x200
    2b55:	68 eb 41 00 00       	push   $0x41eb
    2b5a:	e8 e3 0d 00 00       	call   3942 <open>
    if(fd >= 0)
    2b5f:	83 c4 10             	add    $0x10,%esp
    2b62:	85 c0                	test   %eax,%eax
    2b64:	78 0c                	js     2b72 <iref+0x92>
      close(fd);
    2b66:	83 ec 0c             	sub    $0xc,%esp
    2b69:	50                   	push   %eax
    2b6a:	e8 bb 0d 00 00       	call   392a <close>
    2b6f:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2b72:	83 ec 08             	sub    $0x8,%esp
    2b75:	68 00 02 00 00       	push   $0x200
    2b7a:	68 20 47 00 00       	push   $0x4720
    2b7f:	e8 be 0d 00 00       	call   3942 <open>
    if(fd >= 0)
    2b84:	83 c4 10             	add    $0x10,%esp
    2b87:	85 c0                	test   %eax,%eax
    2b89:	78 0c                	js     2b97 <iref+0xb7>
      close(fd);
    2b8b:	83 ec 0c             	sub    $0xc,%esp
    2b8e:	50                   	push   %eax
    2b8f:	e8 96 0d 00 00       	call   392a <close>
    2b94:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2b97:	83 ec 0c             	sub    $0xc,%esp
    2b9a:	68 20 47 00 00       	push   $0x4720
    2b9f:	e8 ae 0d 00 00       	call   3952 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2ba4:	83 c4 10             	add    $0x10,%esp
    2ba7:	83 eb 01             	sub    $0x1,%ebx
    2baa:	0f 85 50 ff ff ff    	jne    2b00 <iref+0x20>
  chdir("/");
    2bb0:	83 ec 0c             	sub    $0xc,%esp
    2bb3:	68 11 3e 00 00       	push   $0x3e11
    2bb8:	e8 b5 0d 00 00       	call   3972 <chdir>
  printf(1, "empty file name OK\n");
    2bbd:	58                   	pop    %eax
    2bbe:	5a                   	pop    %edx
    2bbf:	68 64 4b 00 00       	push   $0x4b64
    2bc4:	6a 01                	push   $0x1
    2bc6:	e8 a5 0e 00 00       	call   3a70 <printf>
}
    2bcb:	83 c4 10             	add    $0x10,%esp
    2bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2bd1:	c9                   	leave  
    2bd2:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    2bd3:	83 ec 08             	sub    $0x8,%esp
    2bd6:	68 3c 4b 00 00       	push   $0x4b3c
    2bdb:	6a 01                	push   $0x1
    2bdd:	e8 8e 0e 00 00       	call   3a70 <printf>
      exit();
    2be2:	e8 1b 0d 00 00       	call   3902 <exit>
      printf(1, "chdir irefd failed\n");
    2be7:	83 ec 08             	sub    $0x8,%esp
    2bea:	68 50 4b 00 00       	push   $0x4b50
    2bef:	6a 01                	push   $0x1
    2bf1:	e8 7a 0e 00 00       	call   3a70 <printf>
      exit();
    2bf6:	e8 07 0d 00 00       	call   3902 <exit>
    2bfb:	90                   	nop
    2bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00002c00 <forktest>:
{
    2c00:	55                   	push   %ebp
    2c01:	89 e5                	mov    %esp,%ebp
    2c03:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    2c04:	31 db                	xor    %ebx,%ebx
{
    2c06:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    2c09:	68 78 4b 00 00       	push   $0x4b78
    2c0e:	6a 01                	push   $0x1
    2c10:	e8 5b 0e 00 00       	call   3a70 <printf>
    2c15:	83 c4 10             	add    $0x10,%esp
    2c18:	eb 13                	jmp    2c2d <forktest+0x2d>
    2c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pid == 0)
    2c20:	74 62                	je     2c84 <forktest+0x84>
  for(n=0; n<1000; n++){
    2c22:	83 c3 01             	add    $0x1,%ebx
    2c25:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2c2b:	74 43                	je     2c70 <forktest+0x70>
    pid = fork();
    2c2d:	e8 c8 0c 00 00       	call   38fa <fork>
    if(pid < 0)
    2c32:	85 c0                	test   %eax,%eax
    2c34:	79 ea                	jns    2c20 <forktest+0x20>
  for(; n > 0; n--){
    2c36:	85 db                	test   %ebx,%ebx
    2c38:	74 14                	je     2c4e <forktest+0x4e>
    2c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
    2c40:	e8 c5 0c 00 00       	call   390a <wait>
    2c45:	85 c0                	test   %eax,%eax
    2c47:	78 40                	js     2c89 <forktest+0x89>
  for(; n > 0; n--){
    2c49:	83 eb 01             	sub    $0x1,%ebx
    2c4c:	75 f2                	jne    2c40 <forktest+0x40>
  if(wait() != -1){
    2c4e:	e8 b7 0c 00 00       	call   390a <wait>
    2c53:	83 f8 ff             	cmp    $0xffffffff,%eax
    2c56:	75 45                	jne    2c9d <forktest+0x9d>
  printf(1, "fork test OK\n");
    2c58:	83 ec 08             	sub    $0x8,%esp
    2c5b:	68 aa 4b 00 00       	push   $0x4baa
    2c60:	6a 01                	push   $0x1
    2c62:	e8 09 0e 00 00       	call   3a70 <printf>
}
    2c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2c6a:	c9                   	leave  
    2c6b:	c3                   	ret    
    2c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "fork claimed to work 1000 times!\n");
    2c70:	83 ec 08             	sub    $0x8,%esp
    2c73:	68 a8 53 00 00       	push   $0x53a8
    2c78:	6a 01                	push   $0x1
    2c7a:	e8 f1 0d 00 00       	call   3a70 <printf>
    exit();
    2c7f:	e8 7e 0c 00 00       	call   3902 <exit>
      exit();
    2c84:	e8 79 0c 00 00       	call   3902 <exit>
      printf(1, "wait stopped early\n");
    2c89:	83 ec 08             	sub    $0x8,%esp
    2c8c:	68 83 4b 00 00       	push   $0x4b83
    2c91:	6a 01                	push   $0x1
    2c93:	e8 d8 0d 00 00       	call   3a70 <printf>
      exit();
    2c98:	e8 65 0c 00 00       	call   3902 <exit>
    printf(1, "wait got too many\n");
    2c9d:	50                   	push   %eax
    2c9e:	50                   	push   %eax
    2c9f:	68 97 4b 00 00       	push   $0x4b97
    2ca4:	6a 01                	push   $0x1
    2ca6:	e8 c5 0d 00 00       	call   3a70 <printf>
    exit();
    2cab:	e8 52 0c 00 00       	call   3902 <exit>

00002cb0 <sbrktest>:
{
    2cb0:	55                   	push   %ebp
    2cb1:	89 e5                	mov    %esp,%ebp
    2cb3:	57                   	push   %edi
    2cb4:	56                   	push   %esi
    2cb5:	53                   	push   %ebx
  for(i = 0; i < 5000; i++){
    2cb6:	31 ff                	xor    %edi,%edi
{
    2cb8:	83 ec 64             	sub    $0x64,%esp
  printf(stdout, "sbrk test\n");
    2cbb:	68 b8 4b 00 00       	push   $0x4bb8
    2cc0:	ff 35 08 5f 00 00    	pushl  0x5f08
    2cc6:	e8 a5 0d 00 00       	call   3a70 <printf>
  oldbrk = sbrk(0);
    2ccb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2cd2:	e8 b3 0c 00 00       	call   398a <sbrk>
  a = sbrk(0);
    2cd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    2cde:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    2ce0:	e8 a5 0c 00 00       	call   398a <sbrk>
    2ce5:	83 c4 10             	add    $0x10,%esp
    2ce8:	89 c6                	mov    %eax,%esi
    2cea:	eb 06                	jmp    2cf2 <sbrktest+0x42>
    2cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    a = b + 1;
    2cf0:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    2cf2:	83 ec 0c             	sub    $0xc,%esp
    2cf5:	6a 01                	push   $0x1
    2cf7:	e8 8e 0c 00 00       	call   398a <sbrk>
    if(b != a){
    2cfc:	83 c4 10             	add    $0x10,%esp
    2cff:	39 f0                	cmp    %esi,%eax
    2d01:	0f 85 41 03 00 00    	jne    3048 <sbrktest+0x398>
  for(i = 0; i < 5000; i++){
    2d07:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    2d0a:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    2d0d:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    2d10:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    2d16:	75 d8                	jne    2cf0 <sbrktest+0x40>
  printf(stdout, "CHECKPOINT1\n");
    2d18:	83 ec 08             	sub    $0x8,%esp
    2d1b:	68 de 4b 00 00       	push   $0x4bde
    2d20:	ff 35 08 5f 00 00    	pushl  0x5f08
    2d26:	e8 45 0d 00 00       	call   3a70 <printf>
  pid = fork();
    2d2b:	e8 ca 0b 00 00       	call   38fa <fork>
  if(pid < 0){
    2d30:	83 c4 10             	add    $0x10,%esp
    2d33:	85 c0                	test   %eax,%eax
  pid = fork();
    2d35:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    2d37:	0f 88 46 04 00 00    	js     3183 <sbrktest+0x4d3>
  c = sbrk(1);
    2d3d:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    2d40:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    2d43:	6a 01                	push   $0x1
    2d45:	e8 40 0c 00 00       	call   398a <sbrk>
  c = sbrk(1);
    2d4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d51:	e8 34 0c 00 00       	call   398a <sbrk>
  if(c != a + 1){
    2d56:	83 c4 10             	add    $0x10,%esp
    2d59:	39 f0                	cmp    %esi,%eax
    2d5b:	0f 85 0b 04 00 00    	jne    316c <sbrktest+0x4bc>
  if(pid == 0)
    2d61:	85 ff                	test   %edi,%edi
    2d63:	0f 84 fe 03 00 00    	je     3167 <sbrktest+0x4b7>
  wait();
    2d69:	e8 9c 0b 00 00       	call   390a <wait>
  printf(stdout, "CHECKPOINT2\n");
    2d6e:	83 ec 08             	sub    $0x8,%esp
    2d71:	68 1e 4c 00 00       	push   $0x4c1e
    2d76:	ff 35 08 5f 00 00    	pushl  0x5f08
    2d7c:	e8 ef 0c 00 00       	call   3a70 <printf>
  a = sbrk(0);
    2d81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d88:	e8 fd 0b 00 00       	call   398a <sbrk>
    2d8d:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    2d8f:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2d94:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    2d96:	89 04 24             	mov    %eax,(%esp)
    2d99:	e8 ec 0b 00 00       	call   398a <sbrk>
    2d9e:	89 c7                	mov    %eax,%edi
  printf(stdout, "CHECKPOINT3\n");
    2da0:	58                   	pop    %eax
    2da1:	5a                   	pop    %edx
    2da2:	68 2b 4c 00 00       	push   $0x4c2b
    2da7:	ff 35 08 5f 00 00    	pushl  0x5f08
    2dad:	e8 be 0c 00 00       	call   3a70 <printf>
  if (p != a) {
    2db2:	83 c4 10             	add    $0x10,%esp
    2db5:	39 fe                	cmp    %edi,%esi
    2db7:	0f 85 93 03 00 00    	jne    3150 <sbrktest+0x4a0>
  a = sbrk(0);
    2dbd:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    2dc0:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2dc7:	6a 00                	push   $0x0
    2dc9:	e8 bc 0b 00 00       	call   398a <sbrk>
  c = sbrk(-4096);
    2dce:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    2dd5:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    2dd7:	e8 ae 0b 00 00       	call   398a <sbrk>
  if(c == (char*)0xffffffff){
    2ddc:	83 c4 10             	add    $0x10,%esp
    2ddf:	83 f8 ff             	cmp    $0xffffffff,%eax
    2de2:	0f 84 51 03 00 00    	je     3139 <sbrktest+0x489>
  printf(stdout, "CHECKPOINT4\n");
    2de8:	83 ec 08             	sub    $0x8,%esp
    2deb:	68 53 4c 00 00       	push   $0x4c53
    2df0:	ff 35 08 5f 00 00    	pushl  0x5f08
    2df6:	e8 75 0c 00 00       	call   3a70 <printf>
  c = sbrk(0);
    2dfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e02:	e8 83 0b 00 00       	call   398a <sbrk>
  if(c != a - 4096){
    2e07:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    2e0d:	83 c4 10             	add    $0x10,%esp
    2e10:	39 d0                	cmp    %edx,%eax
    2e12:	0f 85 0a 03 00 00    	jne    3122 <sbrktest+0x472>
  a = sbrk(0);
    2e18:	83 ec 0c             	sub    $0xc,%esp
    2e1b:	6a 00                	push   $0x0
    2e1d:	e8 68 0b 00 00       	call   398a <sbrk>
    2e22:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2e24:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2e2b:	e8 5a 0b 00 00       	call   398a <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    2e30:	83 c4 10             	add    $0x10,%esp
    2e33:	39 c6                	cmp    %eax,%esi
  c = sbrk(4096);
    2e35:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    2e37:	0f 85 ce 02 00 00    	jne    310b <sbrktest+0x45b>
    2e3d:	83 ec 0c             	sub    $0xc,%esp
    2e40:	6a 00                	push   $0x0
    2e42:	e8 43 0b 00 00       	call   398a <sbrk>
    2e47:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    2e4d:	83 c4 10             	add    $0x10,%esp
    2e50:	39 d0                	cmp    %edx,%eax
    2e52:	0f 85 b3 02 00 00    	jne    310b <sbrktest+0x45b>
  if(*lastaddr == 99){
    2e58:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2e5f:	a1 08 5f 00 00       	mov    0x5f08,%eax
    2e64:	0f 84 8f 02 00 00    	je     30f9 <sbrktest+0x449>
  printf(stdout, "CHECKPOINT5\n");
    2e6a:	83 ec 08             	sub    $0x8,%esp
    2e6d:	68 60 4c 00 00       	push   $0x4c60
    2e72:	50                   	push   %eax
    2e73:	e8 f8 0b 00 00       	call   3a70 <printf>
  a = sbrk(0);
    2e78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e7f:	e8 06 0b 00 00       	call   398a <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    2e84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    2e8b:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    2e8d:	e8 f8 0a 00 00       	call   398a <sbrk>
    2e92:	89 d9                	mov    %ebx,%ecx
    2e94:	29 c1                	sub    %eax,%ecx
    2e96:	89 0c 24             	mov    %ecx,(%esp)
    2e99:	e8 ec 0a 00 00       	call   398a <sbrk>
  if(c != a){
    2e9e:	83 c4 10             	add    $0x10,%esp
    2ea1:	39 c6                	cmp    %eax,%esi
    2ea3:	0f 85 39 02 00 00    	jne    30e2 <sbrktest+0x432>
  printf(stdout, "CHECKPOINT6\n");
    2ea9:	83 ec 08             	sub    $0x8,%esp
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2eac:	be 00 00 00 80       	mov    $0x80000000,%esi
  printf(stdout, "CHECKPOINT6\n");
    2eb1:	68 6d 4c 00 00       	push   $0x4c6d
    2eb6:	ff 35 08 5f 00 00    	pushl  0x5f08
    2ebc:	e8 af 0b 00 00       	call   3a70 <printf>
    2ec1:	83 c4 10             	add    $0x10,%esp
    ppid = getpid();
    2ec4:	e8 b9 0a 00 00       	call   3982 <getpid>
    2ec9:	89 c7                	mov    %eax,%edi
    pid = fork();
    2ecb:	e8 2a 0a 00 00       	call   38fa <fork>
    if(pid < 0){
    2ed0:	85 c0                	test   %eax,%eax
    2ed2:	0f 88 f3 01 00 00    	js     30cb <sbrktest+0x41b>
    if(pid == 0){
    2ed8:	0f 84 cb 01 00 00    	je     30a9 <sbrktest+0x3f9>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2ede:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    wait();
    2ee4:	e8 21 0a 00 00       	call   390a <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2ee9:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    2eef:	75 d3                	jne    2ec4 <sbrktest+0x214>
  printf(stdout, "CHECKPOINT7\n");
    2ef1:	83 ec 08             	sub    $0x8,%esp
    2ef4:	68 93 4c 00 00       	push   $0x4c93
    2ef9:	ff 35 08 5f 00 00    	pushl  0x5f08
    2eff:	e8 6c 0b 00 00       	call   3a70 <printf>
  if(pipe(fds) != 0){
    2f04:	8d 45 b8             	lea    -0x48(%ebp),%eax
    2f07:	89 04 24             	mov    %eax,(%esp)
    2f0a:	e8 03 0a 00 00       	call   3912 <pipe>
    2f0f:	83 c4 10             	add    $0x10,%esp
    2f12:	85 c0                	test   %eax,%eax
    2f14:	0f 85 7c 01 00 00    	jne    3096 <sbrktest+0x3e6>
    2f1a:	8d 75 c0             	lea    -0x40(%ebp),%esi
    2f1d:	89 f7                	mov    %esi,%edi
    2f1f:	eb 23                	jmp    2f44 <sbrktest+0x294>
    if(pids[i] != -1)
    2f21:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f24:	74 14                	je     2f3a <sbrktest+0x28a>
      read(fds[0], &scratch, 1);
    2f26:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2f29:	83 ec 04             	sub    $0x4,%esp
    2f2c:	6a 01                	push   $0x1
    2f2e:	50                   	push   %eax
    2f2f:	ff 75 b8             	pushl  -0x48(%ebp)
    2f32:	e8 e3 09 00 00       	call   391a <read>
    2f37:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f3a:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2f3d:	83 c7 04             	add    $0x4,%edi
    2f40:	39 c7                	cmp    %eax,%edi
    2f42:	74 4e                	je     2f92 <sbrktest+0x2e2>
    if((pids[i] = fork()) == 0){
    2f44:	e8 b1 09 00 00       	call   38fa <fork>
    2f49:	85 c0                	test   %eax,%eax
    2f4b:	89 07                	mov    %eax,(%edi)
    2f4d:	75 d2                	jne    2f21 <sbrktest+0x271>
      sbrk(BIG - (uint)sbrk(0));
    2f4f:	83 ec 0c             	sub    $0xc,%esp
    2f52:	6a 00                	push   $0x0
    2f54:	e8 31 0a 00 00       	call   398a <sbrk>
    2f59:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2f5e:	29 c2                	sub    %eax,%edx
    2f60:	89 14 24             	mov    %edx,(%esp)
    2f63:	e8 22 0a 00 00       	call   398a <sbrk>
      write(fds[1], "x", 1);
    2f68:	83 c4 0c             	add    $0xc,%esp
    2f6b:	6a 01                	push   $0x1
    2f6d:	68 21 47 00 00       	push   $0x4721
    2f72:	ff 75 bc             	pushl  -0x44(%ebp)
    2f75:	e8 a8 09 00 00       	call   3922 <write>
    2f7a:	83 c4 10             	add    $0x10,%esp
    2f7d:	8d 76 00             	lea    0x0(%esi),%esi
      for(;;) sleep(1000);
    2f80:	83 ec 0c             	sub    $0xc,%esp
    2f83:	68 e8 03 00 00       	push   $0x3e8
    2f88:	e8 05 0a 00 00       	call   3992 <sleep>
    2f8d:	83 c4 10             	add    $0x10,%esp
    2f90:	eb ee                	jmp    2f80 <sbrktest+0x2d0>
  printf(stdout, "CHECKPOINT8\n");
    2f92:	83 ec 08             	sub    $0x8,%esp
    2f95:	68 a0 4c 00 00       	push   $0x4ca0
    2f9a:	ff 35 08 5f 00 00    	pushl  0x5f08
    2fa0:	e8 cb 0a 00 00       	call   3a70 <printf>
  c = sbrk(4096);
    2fa5:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2fac:	e8 d9 09 00 00       	call   398a <sbrk>
  printf(stdout, "CHECKPOINT9\n");
    2fb1:	5a                   	pop    %edx
    2fb2:	59                   	pop    %ecx
    2fb3:	68 ad 4c 00 00       	push   $0x4cad
    2fb8:	ff 35 08 5f 00 00    	pushl  0x5f08
  c = sbrk(4096);
    2fbe:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  printf(stdout, "CHECKPOINT9\n");
    2fc1:	e8 aa 0a 00 00       	call   3a70 <printf>
    2fc6:	83 c4 10             	add    $0x10,%esp
    if(pids[i] == -1)
    2fc9:	8b 06                	mov    (%esi),%eax
    2fcb:	83 f8 ff             	cmp    $0xffffffff,%eax
    2fce:	74 11                	je     2fe1 <sbrktest+0x331>
    kill(pids[i]);
    2fd0:	83 ec 0c             	sub    $0xc,%esp
    2fd3:	50                   	push   %eax
    2fd4:	e8 59 09 00 00       	call   3932 <kill>
    wait();
    2fd9:	e8 2c 09 00 00       	call   390a <wait>
    2fde:	83 c4 10             	add    $0x10,%esp
    2fe1:	83 c6 04             	add    $0x4,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2fe4:	39 f7                	cmp    %esi,%edi
    2fe6:	75 e1                	jne    2fc9 <sbrktest+0x319>
  printf(stdout, "CHECKPOINT10\n");
    2fe8:	83 ec 08             	sub    $0x8,%esp
    2feb:	68 ba 4c 00 00       	push   $0x4cba
    2ff0:	ff 35 08 5f 00 00    	pushl  0x5f08
    2ff6:	e8 75 0a 00 00       	call   3a70 <printf>
  if(c == (char*)0xffffffff){
    2ffb:	83 c4 10             	add    $0x10,%esp
    2ffe:	83 7d a4 ff          	cmpl   $0xffffffff,-0x5c(%ebp)
    3002:	74 7b                	je     307f <sbrktest+0x3cf>
  printf(stdout, "CHECKPOINT11\n");
    3004:	83 ec 08             	sub    $0x8,%esp
    3007:	68 e3 4c 00 00       	push   $0x4ce3
    300c:	ff 35 08 5f 00 00    	pushl  0x5f08
    3012:	e8 59 0a 00 00       	call   3a70 <printf>
  if(sbrk(0) > oldbrk)
    3017:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    301e:	e8 67 09 00 00       	call   398a <sbrk>
    3023:	83 c4 10             	add    $0x10,%esp
    3026:	39 d8                	cmp    %ebx,%eax
    3028:	77 3c                	ja     3066 <sbrktest+0x3b6>
  printf(stdout, "sbrk test OK\n");
    302a:	83 ec 08             	sub    $0x8,%esp
    302d:	68 f1 4c 00 00       	push   $0x4cf1
    3032:	ff 35 08 5f 00 00    	pushl  0x5f08
    3038:	e8 33 0a 00 00       	call   3a70 <printf>
}
    303d:	83 c4 10             	add    $0x10,%esp
    3040:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3043:	5b                   	pop    %ebx
    3044:	5e                   	pop    %esi
    3045:	5f                   	pop    %edi
    3046:	5d                   	pop    %ebp
    3047:	c3                   	ret    
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3048:	83 ec 0c             	sub    $0xc,%esp
    304b:	50                   	push   %eax
    304c:	56                   	push   %esi
    304d:	57                   	push   %edi
    304e:	68 c3 4b 00 00       	push   $0x4bc3
    3053:	ff 35 08 5f 00 00    	pushl  0x5f08
    3059:	e8 12 0a 00 00       	call   3a70 <printf>
      exit();
    305e:	83 c4 20             	add    $0x20,%esp
    3061:	e8 9c 08 00 00       	call   3902 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    3066:	83 ec 0c             	sub    $0xc,%esp
    3069:	6a 00                	push   $0x0
    306b:	e8 1a 09 00 00       	call   398a <sbrk>
    3070:	29 c3                	sub    %eax,%ebx
    3072:	89 1c 24             	mov    %ebx,(%esp)
    3075:	e8 10 09 00 00       	call   398a <sbrk>
    307a:	83 c4 10             	add    $0x10,%esp
    307d:	eb ab                	jmp    302a <sbrktest+0x37a>
    printf(stdout, "failed sbrk leaked memory\n");
    307f:	50                   	push   %eax
    3080:	50                   	push   %eax
    3081:	68 c8 4c 00 00       	push   $0x4cc8
    3086:	ff 35 08 5f 00 00    	pushl  0x5f08
    308c:	e8 df 09 00 00       	call   3a70 <printf>
    exit();
    3091:	e8 6c 08 00 00       	call   3902 <exit>
    printf(1, "pipe() failed\n");
    3096:	53                   	push   %ebx
    3097:	53                   	push   %ebx
    3098:	68 01 41 00 00       	push   $0x4101
    309d:	6a 01                	push   $0x1
    309f:	e8 cc 09 00 00       	call   3a70 <printf>
    exit();
    30a4:	e8 59 08 00 00       	call   3902 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    30a9:	0f be 06             	movsbl (%esi),%eax
    30ac:	50                   	push   %eax
    30ad:	56                   	push   %esi
    30ae:	68 7a 4c 00 00       	push   $0x4c7a
    30b3:	ff 35 08 5f 00 00    	pushl  0x5f08
    30b9:	e8 b2 09 00 00       	call   3a70 <printf>
      kill(ppid);
    30be:	89 3c 24             	mov    %edi,(%esp)
    30c1:	e8 6c 08 00 00       	call   3932 <kill>
      exit();
    30c6:	e8 37 08 00 00       	call   3902 <exit>
      printf(stdout, "fork failed\n");
    30cb:	56                   	push   %esi
    30cc:	56                   	push   %esi
    30cd:	68 9a 4d 00 00       	push   $0x4d9a
    30d2:	ff 35 08 5f 00 00    	pushl  0x5f08
    30d8:	e8 93 09 00 00       	call   3a70 <printf>
      exit();
    30dd:	e8 20 08 00 00       	call   3902 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    30e2:	50                   	push   %eax
    30e3:	56                   	push   %esi
    30e4:	68 9c 54 00 00       	push   $0x549c
    30e9:	ff 35 08 5f 00 00    	pushl  0x5f08
    30ef:	e8 7c 09 00 00       	call   3a70 <printf>
    exit();
    30f4:	e8 09 08 00 00       	call   3902 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    30f9:	57                   	push   %edi
    30fa:	57                   	push   %edi
    30fb:	68 6c 54 00 00       	push   $0x546c
    3100:	50                   	push   %eax
    3101:	e8 6a 09 00 00       	call   3a70 <printf>
    exit();
    3106:	e8 f7 07 00 00       	call   3902 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    310b:	57                   	push   %edi
    310c:	56                   	push   %esi
    310d:	68 44 54 00 00       	push   $0x5444
    3112:	ff 35 08 5f 00 00    	pushl  0x5f08
    3118:	e8 53 09 00 00       	call   3a70 <printf>
    exit();
    311d:	e8 e0 07 00 00       	call   3902 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3122:	50                   	push   %eax
    3123:	56                   	push   %esi
    3124:	68 0c 54 00 00       	push   $0x540c
    3129:	ff 35 08 5f 00 00    	pushl  0x5f08
    312f:	e8 3c 09 00 00       	call   3a70 <printf>
    exit();
    3134:	e8 c9 07 00 00       	call   3902 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    3139:	50                   	push   %eax
    313a:	50                   	push   %eax
    313b:	68 38 4c 00 00       	push   $0x4c38
    3140:	ff 35 08 5f 00 00    	pushl  0x5f08
    3146:	e8 25 09 00 00       	call   3a70 <printf>
    exit();
    314b:	e8 b2 07 00 00       	call   3902 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3150:	50                   	push   %eax
    3151:	50                   	push   %eax
    3152:	68 cc 53 00 00       	push   $0x53cc
    3157:	ff 35 08 5f 00 00    	pushl  0x5f08
    315d:	e8 0e 09 00 00       	call   3a70 <printf>
    exit();
    3162:	e8 9b 07 00 00       	call   3902 <exit>
    exit();
    3167:	e8 96 07 00 00       	call   3902 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    316c:	51                   	push   %ecx
    316d:	51                   	push   %ecx
    316e:	68 02 4c 00 00       	push   $0x4c02
    3173:	ff 35 08 5f 00 00    	pushl  0x5f08
    3179:	e8 f2 08 00 00       	call   3a70 <printf>
    exit();
    317e:	e8 7f 07 00 00       	call   3902 <exit>
    printf(stdout, "sbrk test fork failed\n");
    3183:	53                   	push   %ebx
    3184:	53                   	push   %ebx
    3185:	68 eb 4b 00 00       	push   $0x4beb
    318a:	ff 35 08 5f 00 00    	pushl  0x5f08
    3190:	e8 db 08 00 00       	call   3a70 <printf>
    exit();
    3195:	e8 68 07 00 00       	call   3902 <exit>
    319a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000031a0 <validateint>:
{
    31a0:	55                   	push   %ebp
    31a1:	89 e5                	mov    %esp,%ebp
}
    31a3:	5d                   	pop    %ebp
    31a4:	c3                   	ret    
    31a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    31a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000031b0 <validatetest>:
{
    31b0:	55                   	push   %ebp
    31b1:	89 e5                	mov    %esp,%ebp
    31b3:	56                   	push   %esi
    31b4:	53                   	push   %ebx
  for(p = 0; p <= (uint)hi; p += 4096){
    31b5:	31 db                	xor    %ebx,%ebx
  printf(stdout, "validate test\n");
    31b7:	83 ec 08             	sub    $0x8,%esp
    31ba:	68 ff 4c 00 00       	push   $0x4cff
    31bf:	ff 35 08 5f 00 00    	pushl  0x5f08
    31c5:	e8 a6 08 00 00       	call   3a70 <printf>
    31ca:	83 c4 10             	add    $0x10,%esp
    31cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((pid = fork()) == 0){
    31d0:	e8 25 07 00 00       	call   38fa <fork>
    31d5:	85 c0                	test   %eax,%eax
    31d7:	89 c6                	mov    %eax,%esi
    31d9:	74 63                	je     323e <validatetest+0x8e>
    sleep(0);
    31db:	83 ec 0c             	sub    $0xc,%esp
    31de:	6a 00                	push   $0x0
    31e0:	e8 ad 07 00 00       	call   3992 <sleep>
    sleep(0);
    31e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31ec:	e8 a1 07 00 00       	call   3992 <sleep>
    kill(pid);
    31f1:	89 34 24             	mov    %esi,(%esp)
    31f4:	e8 39 07 00 00       	call   3932 <kill>
    wait();
    31f9:	e8 0c 07 00 00       	call   390a <wait>
    if(link("nosuchfile", (char*)p) != -1){
    31fe:	58                   	pop    %eax
    31ff:	5a                   	pop    %edx
    3200:	53                   	push   %ebx
    3201:	68 0e 4d 00 00       	push   $0x4d0e
    3206:	e8 57 07 00 00       	call   3962 <link>
    320b:	83 c4 10             	add    $0x10,%esp
    320e:	83 f8 ff             	cmp    $0xffffffff,%eax
    3211:	75 30                	jne    3243 <validatetest+0x93>
  for(p = 0; p <= (uint)hi; p += 4096){
    3213:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    3219:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    321f:	75 af                	jne    31d0 <validatetest+0x20>
  printf(stdout, "validate ok\n");
    3221:	83 ec 08             	sub    $0x8,%esp
    3224:	68 32 4d 00 00       	push   $0x4d32
    3229:	ff 35 08 5f 00 00    	pushl  0x5f08
    322f:	e8 3c 08 00 00       	call   3a70 <printf>
}
    3234:	83 c4 10             	add    $0x10,%esp
    3237:	8d 65 f8             	lea    -0x8(%ebp),%esp
    323a:	5b                   	pop    %ebx
    323b:	5e                   	pop    %esi
    323c:	5d                   	pop    %ebp
    323d:	c3                   	ret    
      exit();
    323e:	e8 bf 06 00 00       	call   3902 <exit>
      printf(stdout, "link should not succeed\n");
    3243:	83 ec 08             	sub    $0x8,%esp
    3246:	68 19 4d 00 00       	push   $0x4d19
    324b:	ff 35 08 5f 00 00    	pushl  0x5f08
    3251:	e8 1a 08 00 00       	call   3a70 <printf>
      exit();
    3256:	e8 a7 06 00 00       	call   3902 <exit>
    325b:	90                   	nop
    325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003260 <bsstest>:
{
    3260:	55                   	push   %ebp
    3261:	89 e5                	mov    %esp,%ebp
    3263:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    3266:	68 3f 4d 00 00       	push   $0x4d3f
    326b:	ff 35 08 5f 00 00    	pushl  0x5f08
    3271:	e8 fa 07 00 00       	call   3a70 <printf>
    if(uninit[i] != '\0'){
    3276:	83 c4 10             	add    $0x10,%esp
    3279:	80 3d c0 5f 00 00 00 	cmpb   $0x0,0x5fc0
    3280:	75 39                	jne    32bb <bsstest+0x5b>
  for(i = 0; i < sizeof(uninit); i++){
    3282:	b8 01 00 00 00       	mov    $0x1,%eax
    3287:	89 f6                	mov    %esi,%esi
    3289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(uninit[i] != '\0'){
    3290:	80 b8 c0 5f 00 00 00 	cmpb   $0x0,0x5fc0(%eax)
    3297:	75 22                	jne    32bb <bsstest+0x5b>
  for(i = 0; i < sizeof(uninit); i++){
    3299:	83 c0 01             	add    $0x1,%eax
    329c:	3d 10 27 00 00       	cmp    $0x2710,%eax
    32a1:	75 ed                	jne    3290 <bsstest+0x30>
  printf(stdout, "bss test ok\n");
    32a3:	83 ec 08             	sub    $0x8,%esp
    32a6:	68 5a 4d 00 00       	push   $0x4d5a
    32ab:	ff 35 08 5f 00 00    	pushl  0x5f08
    32b1:	e8 ba 07 00 00       	call   3a70 <printf>
}
    32b6:	83 c4 10             	add    $0x10,%esp
    32b9:	c9                   	leave  
    32ba:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    32bb:	83 ec 08             	sub    $0x8,%esp
    32be:	68 49 4d 00 00       	push   $0x4d49
    32c3:	ff 35 08 5f 00 00    	pushl  0x5f08
    32c9:	e8 a2 07 00 00       	call   3a70 <printf>
      exit();
    32ce:	e8 2f 06 00 00       	call   3902 <exit>
    32d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    32d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000032e0 <bigargtest>:
{
    32e0:	55                   	push   %ebp
    32e1:	89 e5                	mov    %esp,%ebp
    32e3:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    32e6:	68 67 4d 00 00       	push   $0x4d67
    32eb:	e8 62 06 00 00       	call   3952 <unlink>
  pid = fork();
    32f0:	e8 05 06 00 00       	call   38fa <fork>
  if(pid == 0){
    32f5:	83 c4 10             	add    $0x10,%esp
    32f8:	85 c0                	test   %eax,%eax
    32fa:	74 3f                	je     333b <bigargtest+0x5b>
  } else if(pid < 0){
    32fc:	0f 88 c2 00 00 00    	js     33c4 <bigargtest+0xe4>
  wait();
    3302:	e8 03 06 00 00       	call   390a <wait>
  fd = open("bigarg-ok", 0);
    3307:	83 ec 08             	sub    $0x8,%esp
    330a:	6a 00                	push   $0x0
    330c:	68 67 4d 00 00       	push   $0x4d67
    3311:	e8 2c 06 00 00       	call   3942 <open>
  if(fd < 0){
    3316:	83 c4 10             	add    $0x10,%esp
    3319:	85 c0                	test   %eax,%eax
    331b:	0f 88 8c 00 00 00    	js     33ad <bigargtest+0xcd>
  close(fd);
    3321:	83 ec 0c             	sub    $0xc,%esp
    3324:	50                   	push   %eax
    3325:	e8 00 06 00 00       	call   392a <close>
  unlink("bigarg-ok");
    332a:	c7 04 24 67 4d 00 00 	movl   $0x4d67,(%esp)
    3331:	e8 1c 06 00 00       	call   3952 <unlink>
}
    3336:	83 c4 10             	add    $0x10,%esp
    3339:	c9                   	leave  
    333a:	c3                   	ret    
    333b:	b8 20 5f 00 00       	mov    $0x5f20,%eax
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3340:	c7 00 c0 54 00 00    	movl   $0x54c0,(%eax)
    3346:	83 c0 04             	add    $0x4,%eax
    for(i = 0; i < MAXARG-1; i++)
    3349:	3d 9c 5f 00 00       	cmp    $0x5f9c,%eax
    334e:	75 f0                	jne    3340 <bigargtest+0x60>
    printf(stdout, "bigarg test\n");
    3350:	51                   	push   %ecx
    3351:	51                   	push   %ecx
    3352:	68 71 4d 00 00       	push   $0x4d71
    3357:	ff 35 08 5f 00 00    	pushl  0x5f08
    args[MAXARG-1] = 0;
    335d:	c7 05 9c 5f 00 00 00 	movl   $0x0,0x5f9c
    3364:	00 00 00 
    printf(stdout, "bigarg test\n");
    3367:	e8 04 07 00 00       	call   3a70 <printf>
    exec("echo", args);
    336c:	58                   	pop    %eax
    336d:	5a                   	pop    %edx
    336e:	68 20 5f 00 00       	push   $0x5f20
    3373:	68 ad 3e 00 00       	push   $0x3ead
    3378:	e8 bd 05 00 00       	call   393a <exec>
    printf(stdout, "bigarg test ok\n");
    337d:	59                   	pop    %ecx
    337e:	58                   	pop    %eax
    337f:	68 7e 4d 00 00       	push   $0x4d7e
    3384:	ff 35 08 5f 00 00    	pushl  0x5f08
    338a:	e8 e1 06 00 00       	call   3a70 <printf>
    fd = open("bigarg-ok", O_CREATE);
    338f:	58                   	pop    %eax
    3390:	5a                   	pop    %edx
    3391:	68 00 02 00 00       	push   $0x200
    3396:	68 67 4d 00 00       	push   $0x4d67
    339b:	e8 a2 05 00 00       	call   3942 <open>
    close(fd);
    33a0:	89 04 24             	mov    %eax,(%esp)
    33a3:	e8 82 05 00 00       	call   392a <close>
    exit();
    33a8:	e8 55 05 00 00       	call   3902 <exit>
    printf(stdout, "bigarg test failed!\n");
    33ad:	50                   	push   %eax
    33ae:	50                   	push   %eax
    33af:	68 a7 4d 00 00       	push   $0x4da7
    33b4:	ff 35 08 5f 00 00    	pushl  0x5f08
    33ba:	e8 b1 06 00 00       	call   3a70 <printf>
    exit();
    33bf:	e8 3e 05 00 00       	call   3902 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    33c4:	52                   	push   %edx
    33c5:	52                   	push   %edx
    33c6:	68 8e 4d 00 00       	push   $0x4d8e
    33cb:	ff 35 08 5f 00 00    	pushl  0x5f08
    33d1:	e8 9a 06 00 00       	call   3a70 <printf>
    exit();
    33d6:	e8 27 05 00 00       	call   3902 <exit>
    33db:	90                   	nop
    33dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000033e0 <fsfull>:
{
    33e0:	55                   	push   %ebp
    33e1:	89 e5                	mov    %esp,%ebp
    33e3:	57                   	push   %edi
    33e4:	56                   	push   %esi
    33e5:	53                   	push   %ebx
  for(nfiles = 0; ; nfiles++){
    33e6:	31 db                	xor    %ebx,%ebx
{
    33e8:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    33eb:	68 bc 4d 00 00       	push   $0x4dbc
    33f0:	6a 01                	push   $0x1
    33f2:	e8 79 06 00 00       	call   3a70 <printf>
    33f7:	83 c4 10             	add    $0x10,%esp
    33fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    3400:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3405:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    340a:	83 ec 04             	sub    $0x4,%esp
    name[1] = '0' + nfiles / 1000;
    340d:	f7 e3                	mul    %ebx
    name[0] = 'f';
    340f:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[5] = '\0';
    3413:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3417:	c1 ea 06             	shr    $0x6,%edx
    341a:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    341d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3423:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3426:	89 d8                	mov    %ebx,%eax
    3428:	29 d0                	sub    %edx,%eax
    342a:	89 c2                	mov    %eax,%edx
    342c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3431:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    3433:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    3438:	c1 ea 05             	shr    $0x5,%edx
    343b:	83 c2 30             	add    $0x30,%edx
    343e:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3441:	f7 e3                	mul    %ebx
    3443:	89 d8                	mov    %ebx,%eax
    3445:	c1 ea 05             	shr    $0x5,%edx
    3448:	6b d2 64             	imul   $0x64,%edx,%edx
    344b:	29 d0                	sub    %edx,%eax
    344d:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    344f:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3451:	c1 ea 03             	shr    $0x3,%edx
    3454:	83 c2 30             	add    $0x30,%edx
    3457:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    345a:	f7 e1                	mul    %ecx
    345c:	89 d9                	mov    %ebx,%ecx
    345e:	c1 ea 03             	shr    $0x3,%edx
    3461:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3464:	01 c0                	add    %eax,%eax
    3466:	29 c1                	sub    %eax,%ecx
    3468:	89 c8                	mov    %ecx,%eax
    346a:	83 c0 30             	add    $0x30,%eax
    346d:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    3470:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3473:	50                   	push   %eax
    3474:	68 c9 4d 00 00       	push   $0x4dc9
    3479:	6a 01                	push   $0x1
    347b:	e8 f0 05 00 00       	call   3a70 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3480:	58                   	pop    %eax
    3481:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3484:	5a                   	pop    %edx
    3485:	68 02 02 00 00       	push   $0x202
    348a:	50                   	push   %eax
    348b:	e8 b2 04 00 00       	call   3942 <open>
    if(fd < 0){
    3490:	83 c4 10             	add    $0x10,%esp
    3493:	85 c0                	test   %eax,%eax
    int fd = open(name, O_CREATE|O_RDWR);
    3495:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    3497:	78 57                	js     34f0 <fsfull+0x110>
    int total = 0;
    3499:	31 f6                	xor    %esi,%esi
    349b:	eb 05                	jmp    34a2 <fsfull+0xc2>
    349d:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    34a0:	01 c6                	add    %eax,%esi
      int cc = write(fd, buf, 512);
    34a2:	83 ec 04             	sub    $0x4,%esp
    34a5:	68 00 02 00 00       	push   $0x200
    34aa:	68 e0 86 00 00       	push   $0x86e0
    34af:	57                   	push   %edi
    34b0:	e8 6d 04 00 00       	call   3922 <write>
      if(cc < 512)
    34b5:	83 c4 10             	add    $0x10,%esp
    34b8:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    34bd:	7f e1                	jg     34a0 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    34bf:	83 ec 04             	sub    $0x4,%esp
    34c2:	56                   	push   %esi
    34c3:	68 e5 4d 00 00       	push   $0x4de5
    34c8:	6a 01                	push   $0x1
    34ca:	e8 a1 05 00 00       	call   3a70 <printf>
    close(fd);
    34cf:	89 3c 24             	mov    %edi,(%esp)
    34d2:	e8 53 04 00 00       	call   392a <close>
    if(total == 0)
    34d7:	83 c4 10             	add    $0x10,%esp
    34da:	85 f6                	test   %esi,%esi
    34dc:	74 28                	je     3506 <fsfull+0x126>
  for(nfiles = 0; ; nfiles++){
    34de:	83 c3 01             	add    $0x1,%ebx
    34e1:	e9 1a ff ff ff       	jmp    3400 <fsfull+0x20>
    34e6:	8d 76 00             	lea    0x0(%esi),%esi
    34e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "open %s failed\n", name);
    34f0:	8d 45 a8             	lea    -0x58(%ebp),%eax
    34f3:	83 ec 04             	sub    $0x4,%esp
    34f6:	50                   	push   %eax
    34f7:	68 d5 4d 00 00       	push   $0x4dd5
    34fc:	6a 01                	push   $0x1
    34fe:	e8 6d 05 00 00       	call   3a70 <printf>
      break;
    3503:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    3506:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    350b:	be 1f 85 eb 51       	mov    $0x51eb851f,%esi
    name[1] = '0' + nfiles / 1000;
    3510:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3512:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    unlink(name);
    3517:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + nfiles / 1000;
    351a:	f7 e7                	mul    %edi
    name[0] = 'f';
    351c:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[5] = '\0';
    3520:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3524:	c1 ea 06             	shr    $0x6,%edx
    3527:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    352a:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3530:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3533:	89 d8                	mov    %ebx,%eax
    3535:	29 d0                	sub    %edx,%eax
    3537:	f7 e6                	mul    %esi
    name[3] = '0' + (nfiles % 100) / 10;
    3539:	89 d8                	mov    %ebx,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    353b:	c1 ea 05             	shr    $0x5,%edx
    353e:	83 c2 30             	add    $0x30,%edx
    3541:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3544:	f7 e6                	mul    %esi
    3546:	89 d8                	mov    %ebx,%eax
    3548:	c1 ea 05             	shr    $0x5,%edx
    354b:	6b d2 64             	imul   $0x64,%edx,%edx
    354e:	29 d0                	sub    %edx,%eax
    3550:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    3552:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3554:	c1 ea 03             	shr    $0x3,%edx
    3557:	83 c2 30             	add    $0x30,%edx
    355a:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    355d:	f7 e1                	mul    %ecx
    355f:	89 d9                	mov    %ebx,%ecx
    nfiles--;
    3561:	83 eb 01             	sub    $0x1,%ebx
    name[4] = '0' + (nfiles % 10);
    3564:	c1 ea 03             	shr    $0x3,%edx
    3567:	8d 04 92             	lea    (%edx,%edx,4),%eax
    356a:	01 c0                	add    %eax,%eax
    356c:	29 c1                	sub    %eax,%ecx
    356e:	89 c8                	mov    %ecx,%eax
    3570:	83 c0 30             	add    $0x30,%eax
    3573:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    3576:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3579:	50                   	push   %eax
    357a:	e8 d3 03 00 00       	call   3952 <unlink>
  while(nfiles >= 0){
    357f:	83 c4 10             	add    $0x10,%esp
    3582:	83 fb ff             	cmp    $0xffffffff,%ebx
    3585:	75 89                	jne    3510 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    3587:	83 ec 08             	sub    $0x8,%esp
    358a:	68 f5 4d 00 00       	push   $0x4df5
    358f:	6a 01                	push   $0x1
    3591:	e8 da 04 00 00       	call   3a70 <printf>
}
    3596:	83 c4 10             	add    $0x10,%esp
    3599:	8d 65 f4             	lea    -0xc(%ebp),%esp
    359c:	5b                   	pop    %ebx
    359d:	5e                   	pop    %esi
    359e:	5f                   	pop    %edi
    359f:	5d                   	pop    %ebp
    35a0:	c3                   	ret    
    35a1:	eb 0d                	jmp    35b0 <uio>
    35a3:	90                   	nop
    35a4:	90                   	nop
    35a5:	90                   	nop
    35a6:	90                   	nop
    35a7:	90                   	nop
    35a8:	90                   	nop
    35a9:	90                   	nop
    35aa:	90                   	nop
    35ab:	90                   	nop
    35ac:	90                   	nop
    35ad:	90                   	nop
    35ae:	90                   	nop
    35af:	90                   	nop

000035b0 <uio>:
{
    35b0:	55                   	push   %ebp
    35b1:	89 e5                	mov    %esp,%ebp
    35b3:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    35b6:	68 0b 4e 00 00       	push   $0x4e0b
    35bb:	6a 01                	push   $0x1
    35bd:	e8 ae 04 00 00       	call   3a70 <printf>
  pid = fork();
    35c2:	e8 33 03 00 00       	call   38fa <fork>
  if(pid == 0){
    35c7:	83 c4 10             	add    $0x10,%esp
    35ca:	85 c0                	test   %eax,%eax
    35cc:	74 1b                	je     35e9 <uio+0x39>
  } else if(pid < 0){
    35ce:	78 3d                	js     360d <uio+0x5d>
  wait();
    35d0:	e8 35 03 00 00       	call   390a <wait>
  printf(1, "uio test done\n");
    35d5:	83 ec 08             	sub    $0x8,%esp
    35d8:	68 15 4e 00 00       	push   $0x4e15
    35dd:	6a 01                	push   $0x1
    35df:	e8 8c 04 00 00       	call   3a70 <printf>
}
    35e4:	83 c4 10             	add    $0x10,%esp
    35e7:	c9                   	leave  
    35e8:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    35e9:	b8 09 00 00 00       	mov    $0x9,%eax
    35ee:	ba 70 00 00 00       	mov    $0x70,%edx
    35f3:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    35f4:	ba 71 00 00 00       	mov    $0x71,%edx
    35f9:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    35fa:	52                   	push   %edx
    35fb:	52                   	push   %edx
    35fc:	68 a0 55 00 00       	push   $0x55a0
    3601:	6a 01                	push   $0x1
    3603:	e8 68 04 00 00       	call   3a70 <printf>
    exit();
    3608:	e8 f5 02 00 00       	call   3902 <exit>
    printf (1, "fork failed\n");
    360d:	50                   	push   %eax
    360e:	50                   	push   %eax
    360f:	68 9a 4d 00 00       	push   $0x4d9a
    3614:	6a 01                	push   $0x1
    3616:	e8 55 04 00 00       	call   3a70 <printf>
    exit();
    361b:	e8 e2 02 00 00       	call   3902 <exit>

00003620 <argptest>:
{
    3620:	55                   	push   %ebp
    3621:	89 e5                	mov    %esp,%ebp
    3623:	53                   	push   %ebx
    3624:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    3627:	6a 00                	push   $0x0
    3629:	68 24 4e 00 00       	push   $0x4e24
    362e:	e8 0f 03 00 00       	call   3942 <open>
  if (fd < 0) {
    3633:	83 c4 10             	add    $0x10,%esp
    3636:	85 c0                	test   %eax,%eax
    3638:	78 39                	js     3673 <argptest+0x53>
  read(fd, sbrk(0) - 1, -1);
    363a:	83 ec 0c             	sub    $0xc,%esp
    363d:	89 c3                	mov    %eax,%ebx
    363f:	6a 00                	push   $0x0
    3641:	e8 44 03 00 00       	call   398a <sbrk>
    3646:	83 c4 0c             	add    $0xc,%esp
    3649:	83 e8 01             	sub    $0x1,%eax
    364c:	6a ff                	push   $0xffffffff
    364e:	50                   	push   %eax
    364f:	53                   	push   %ebx
    3650:	e8 c5 02 00 00       	call   391a <read>
  close(fd);
    3655:	89 1c 24             	mov    %ebx,(%esp)
    3658:	e8 cd 02 00 00       	call   392a <close>
  printf(1, "arg test passed\n");
    365d:	58                   	pop    %eax
    365e:	5a                   	pop    %edx
    365f:	68 36 4e 00 00       	push   $0x4e36
    3664:	6a 01                	push   $0x1
    3666:	e8 05 04 00 00       	call   3a70 <printf>
}
    366b:	83 c4 10             	add    $0x10,%esp
    366e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3671:	c9                   	leave  
    3672:	c3                   	ret    
    printf(2, "open failed\n");
    3673:	51                   	push   %ecx
    3674:	51                   	push   %ecx
    3675:	68 29 4e 00 00       	push   $0x4e29
    367a:	6a 02                	push   $0x2
    367c:	e8 ef 03 00 00       	call   3a70 <printf>
    exit();
    3681:	e8 7c 02 00 00       	call   3902 <exit>
    3686:	8d 76 00             	lea    0x0(%esi),%esi
    3689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003690 <rand>:
  randstate = randstate * 1664525 + 1013904223;
    3690:	69 05 04 5f 00 00 0d 	imul   $0x19660d,0x5f04,%eax
    3697:	66 19 00 
{
    369a:	55                   	push   %ebp
    369b:	89 e5                	mov    %esp,%ebp
}
    369d:	5d                   	pop    %ebp
  randstate = randstate * 1664525 + 1013904223;
    369e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    36a3:	a3 04 5f 00 00       	mov    %eax,0x5f04
}
    36a8:	c3                   	ret    
    36a9:	66 90                	xchg   %ax,%ax
    36ab:	66 90                	xchg   %ax,%ax
    36ad:	66 90                	xchg   %ax,%ax
    36af:	90                   	nop

000036b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    36b0:	55                   	push   %ebp
    36b1:	89 e5                	mov    %esp,%ebp
    36b3:	53                   	push   %ebx
    36b4:	8b 45 08             	mov    0x8(%ebp),%eax
    36b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    36ba:	89 c2                	mov    %eax,%edx
    36bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    36c0:	83 c1 01             	add    $0x1,%ecx
    36c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    36c7:	83 c2 01             	add    $0x1,%edx
    36ca:	84 db                	test   %bl,%bl
    36cc:	88 5a ff             	mov    %bl,-0x1(%edx)
    36cf:	75 ef                	jne    36c0 <strcpy+0x10>
    ;
  return os;
}
    36d1:	5b                   	pop    %ebx
    36d2:	5d                   	pop    %ebp
    36d3:	c3                   	ret    
    36d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    36da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000036e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    36e0:	55                   	push   %ebp
    36e1:	89 e5                	mov    %esp,%ebp
    36e3:	53                   	push   %ebx
    36e4:	8b 55 08             	mov    0x8(%ebp),%edx
    36e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    36ea:	0f b6 02             	movzbl (%edx),%eax
    36ed:	0f b6 19             	movzbl (%ecx),%ebx
    36f0:	84 c0                	test   %al,%al
    36f2:	75 1c                	jne    3710 <strcmp+0x30>
    36f4:	eb 2a                	jmp    3720 <strcmp+0x40>
    36f6:	8d 76 00             	lea    0x0(%esi),%esi
    36f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
    3700:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    3703:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    3706:	83 c1 01             	add    $0x1,%ecx
    3709:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
    370c:	84 c0                	test   %al,%al
    370e:	74 10                	je     3720 <strcmp+0x40>
    3710:	38 d8                	cmp    %bl,%al
    3712:	74 ec                	je     3700 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    3714:	29 d8                	sub    %ebx,%eax
}
    3716:	5b                   	pop    %ebx
    3717:	5d                   	pop    %ebp
    3718:	c3                   	ret    
    3719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3720:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    3722:	29 d8                	sub    %ebx,%eax
}
    3724:	5b                   	pop    %ebx
    3725:	5d                   	pop    %ebp
    3726:	c3                   	ret    
    3727:	89 f6                	mov    %esi,%esi
    3729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003730 <strlen>:

uint
strlen(const char *s)
{
    3730:	55                   	push   %ebp
    3731:	89 e5                	mov    %esp,%ebp
    3733:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    3736:	80 39 00             	cmpb   $0x0,(%ecx)
    3739:	74 15                	je     3750 <strlen+0x20>
    373b:	31 d2                	xor    %edx,%edx
    373d:	8d 76 00             	lea    0x0(%esi),%esi
    3740:	83 c2 01             	add    $0x1,%edx
    3743:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    3747:	89 d0                	mov    %edx,%eax
    3749:	75 f5                	jne    3740 <strlen+0x10>
    ;
  return n;
}
    374b:	5d                   	pop    %ebp
    374c:	c3                   	ret    
    374d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    3750:	31 c0                	xor    %eax,%eax
}
    3752:	5d                   	pop    %ebp
    3753:	c3                   	ret    
    3754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    375a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00003760 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3760:	55                   	push   %ebp
    3761:	89 e5                	mov    %esp,%ebp
    3763:	57                   	push   %edi
    3764:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3767:	8b 4d 10             	mov    0x10(%ebp),%ecx
    376a:	8b 45 0c             	mov    0xc(%ebp),%eax
    376d:	89 d7                	mov    %edx,%edi
    376f:	fc                   	cld    
    3770:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3772:	89 d0                	mov    %edx,%eax
    3774:	5f                   	pop    %edi
    3775:	5d                   	pop    %ebp
    3776:	c3                   	ret    
    3777:	89 f6                	mov    %esi,%esi
    3779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003780 <strchr>:

char*
strchr(const char *s, char c)
{
    3780:	55                   	push   %ebp
    3781:	89 e5                	mov    %esp,%ebp
    3783:	53                   	push   %ebx
    3784:	8b 45 08             	mov    0x8(%ebp),%eax
    3787:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    378a:	0f b6 10             	movzbl (%eax),%edx
    378d:	84 d2                	test   %dl,%dl
    378f:	74 1d                	je     37ae <strchr+0x2e>
    if(*s == c)
    3791:	38 d3                	cmp    %dl,%bl
    3793:	89 d9                	mov    %ebx,%ecx
    3795:	75 0d                	jne    37a4 <strchr+0x24>
    3797:	eb 17                	jmp    37b0 <strchr+0x30>
    3799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37a0:	38 ca                	cmp    %cl,%dl
    37a2:	74 0c                	je     37b0 <strchr+0x30>
  for(; *s; s++)
    37a4:	83 c0 01             	add    $0x1,%eax
    37a7:	0f b6 10             	movzbl (%eax),%edx
    37aa:	84 d2                	test   %dl,%dl
    37ac:	75 f2                	jne    37a0 <strchr+0x20>
      return (char*)s;
  return 0;
    37ae:	31 c0                	xor    %eax,%eax
}
    37b0:	5b                   	pop    %ebx
    37b1:	5d                   	pop    %ebp
    37b2:	c3                   	ret    
    37b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    37b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000037c0 <gets>:

char*
gets(char *buf, int max)
{
    37c0:	55                   	push   %ebp
    37c1:	89 e5                	mov    %esp,%ebp
    37c3:	57                   	push   %edi
    37c4:	56                   	push   %esi
    37c5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    37c6:	31 f6                	xor    %esi,%esi
    37c8:	89 f3                	mov    %esi,%ebx
{
    37ca:	83 ec 1c             	sub    $0x1c,%esp
    37cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    37d0:	eb 2f                	jmp    3801 <gets+0x41>
    37d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    37d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
    37db:	83 ec 04             	sub    $0x4,%esp
    37de:	6a 01                	push   $0x1
    37e0:	50                   	push   %eax
    37e1:	6a 00                	push   $0x0
    37e3:	e8 32 01 00 00       	call   391a <read>
    if(cc < 1)
    37e8:	83 c4 10             	add    $0x10,%esp
    37eb:	85 c0                	test   %eax,%eax
    37ed:	7e 1c                	jle    380b <gets+0x4b>
      break;
    buf[i++] = c;
    37ef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    37f3:	83 c7 01             	add    $0x1,%edi
    37f6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    37f9:	3c 0a                	cmp    $0xa,%al
    37fb:	74 23                	je     3820 <gets+0x60>
    37fd:	3c 0d                	cmp    $0xd,%al
    37ff:	74 1f                	je     3820 <gets+0x60>
  for(i=0; i+1 < max; ){
    3801:	83 c3 01             	add    $0x1,%ebx
    3804:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3807:	89 fe                	mov    %edi,%esi
    3809:	7c cd                	jl     37d8 <gets+0x18>
    380b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    380d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    3810:	c6 03 00             	movb   $0x0,(%ebx)
}
    3813:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3816:	5b                   	pop    %ebx
    3817:	5e                   	pop    %esi
    3818:	5f                   	pop    %edi
    3819:	5d                   	pop    %ebp
    381a:	c3                   	ret    
    381b:	90                   	nop
    381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3820:	8b 75 08             	mov    0x8(%ebp),%esi
    3823:	8b 45 08             	mov    0x8(%ebp),%eax
    3826:	01 de                	add    %ebx,%esi
    3828:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    382a:	c6 03 00             	movb   $0x0,(%ebx)
}
    382d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3830:	5b                   	pop    %ebx
    3831:	5e                   	pop    %esi
    3832:	5f                   	pop    %edi
    3833:	5d                   	pop    %ebp
    3834:	c3                   	ret    
    3835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003840 <stat>:

int
stat(const char *n, struct stat *st)
{
    3840:	55                   	push   %ebp
    3841:	89 e5                	mov    %esp,%ebp
    3843:	56                   	push   %esi
    3844:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3845:	83 ec 08             	sub    $0x8,%esp
    3848:	6a 00                	push   $0x0
    384a:	ff 75 08             	pushl  0x8(%ebp)
    384d:	e8 f0 00 00 00       	call   3942 <open>
  if(fd < 0)
    3852:	83 c4 10             	add    $0x10,%esp
    3855:	85 c0                	test   %eax,%eax
    3857:	78 27                	js     3880 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    3859:	83 ec 08             	sub    $0x8,%esp
    385c:	ff 75 0c             	pushl  0xc(%ebp)
    385f:	89 c3                	mov    %eax,%ebx
    3861:	50                   	push   %eax
    3862:	e8 f3 00 00 00       	call   395a <fstat>
  close(fd);
    3867:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    386a:	89 c6                	mov    %eax,%esi
  close(fd);
    386c:	e8 b9 00 00 00       	call   392a <close>
  return r;
    3871:	83 c4 10             	add    $0x10,%esp
}
    3874:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3877:	89 f0                	mov    %esi,%eax
    3879:	5b                   	pop    %ebx
    387a:	5e                   	pop    %esi
    387b:	5d                   	pop    %ebp
    387c:	c3                   	ret    
    387d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    3880:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3885:	eb ed                	jmp    3874 <stat+0x34>
    3887:	89 f6                	mov    %esi,%esi
    3889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003890 <atoi>:

int
atoi(const char *s)
{
    3890:	55                   	push   %ebp
    3891:	89 e5                	mov    %esp,%ebp
    3893:	53                   	push   %ebx
    3894:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3897:	0f be 11             	movsbl (%ecx),%edx
    389a:	8d 42 d0             	lea    -0x30(%edx),%eax
    389d:	3c 09                	cmp    $0x9,%al
  n = 0;
    389f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    38a4:	77 1f                	ja     38c5 <atoi+0x35>
    38a6:	8d 76 00             	lea    0x0(%esi),%esi
    38a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    38b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
    38b3:	83 c1 01             	add    $0x1,%ecx
    38b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    38ba:	0f be 11             	movsbl (%ecx),%edx
    38bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
    38c0:	80 fb 09             	cmp    $0x9,%bl
    38c3:	76 eb                	jbe    38b0 <atoi+0x20>
  return n;
}
    38c5:	5b                   	pop    %ebx
    38c6:	5d                   	pop    %ebp
    38c7:	c3                   	ret    
    38c8:	90                   	nop
    38c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000038d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    38d0:	55                   	push   %ebp
    38d1:	89 e5                	mov    %esp,%ebp
    38d3:	56                   	push   %esi
    38d4:	53                   	push   %ebx
    38d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    38d8:	8b 45 08             	mov    0x8(%ebp),%eax
    38db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    38de:	85 db                	test   %ebx,%ebx
    38e0:	7e 14                	jle    38f6 <memmove+0x26>
    38e2:	31 d2                	xor    %edx,%edx
    38e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    38e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    38ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    38ef:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    38f2:	39 d3                	cmp    %edx,%ebx
    38f4:	75 f2                	jne    38e8 <memmove+0x18>
  return vdst;
}
    38f6:	5b                   	pop    %ebx
    38f7:	5e                   	pop    %esi
    38f8:	5d                   	pop    %ebp
    38f9:	c3                   	ret    

000038fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    38fa:	b8 01 00 00 00       	mov    $0x1,%eax
    38ff:	cd 40                	int    $0x40
    3901:	c3                   	ret    

00003902 <exit>:
SYSCALL(exit)
    3902:	b8 02 00 00 00       	mov    $0x2,%eax
    3907:	cd 40                	int    $0x40
    3909:	c3                   	ret    

0000390a <wait>:
SYSCALL(wait)
    390a:	b8 03 00 00 00       	mov    $0x3,%eax
    390f:	cd 40                	int    $0x40
    3911:	c3                   	ret    

00003912 <pipe>:
SYSCALL(pipe)
    3912:	b8 04 00 00 00       	mov    $0x4,%eax
    3917:	cd 40                	int    $0x40
    3919:	c3                   	ret    

0000391a <read>:
SYSCALL(read)
    391a:	b8 05 00 00 00       	mov    $0x5,%eax
    391f:	cd 40                	int    $0x40
    3921:	c3                   	ret    

00003922 <write>:
SYSCALL(write)
    3922:	b8 10 00 00 00       	mov    $0x10,%eax
    3927:	cd 40                	int    $0x40
    3929:	c3                   	ret    

0000392a <close>:
SYSCALL(close)
    392a:	b8 15 00 00 00       	mov    $0x15,%eax
    392f:	cd 40                	int    $0x40
    3931:	c3                   	ret    

00003932 <kill>:
SYSCALL(kill)
    3932:	b8 06 00 00 00       	mov    $0x6,%eax
    3937:	cd 40                	int    $0x40
    3939:	c3                   	ret    

0000393a <exec>:
SYSCALL(exec)
    393a:	b8 07 00 00 00       	mov    $0x7,%eax
    393f:	cd 40                	int    $0x40
    3941:	c3                   	ret    

00003942 <open>:
SYSCALL(open)
    3942:	b8 0f 00 00 00       	mov    $0xf,%eax
    3947:	cd 40                	int    $0x40
    3949:	c3                   	ret    

0000394a <mknod>:
SYSCALL(mknod)
    394a:	b8 11 00 00 00       	mov    $0x11,%eax
    394f:	cd 40                	int    $0x40
    3951:	c3                   	ret    

00003952 <unlink>:
SYSCALL(unlink)
    3952:	b8 12 00 00 00       	mov    $0x12,%eax
    3957:	cd 40                	int    $0x40
    3959:	c3                   	ret    

0000395a <fstat>:
SYSCALL(fstat)
    395a:	b8 08 00 00 00       	mov    $0x8,%eax
    395f:	cd 40                	int    $0x40
    3961:	c3                   	ret    

00003962 <link>:
SYSCALL(link)
    3962:	b8 13 00 00 00       	mov    $0x13,%eax
    3967:	cd 40                	int    $0x40
    3969:	c3                   	ret    

0000396a <mkdir>:
SYSCALL(mkdir)
    396a:	b8 14 00 00 00       	mov    $0x14,%eax
    396f:	cd 40                	int    $0x40
    3971:	c3                   	ret    

00003972 <chdir>:
SYSCALL(chdir)
    3972:	b8 09 00 00 00       	mov    $0x9,%eax
    3977:	cd 40                	int    $0x40
    3979:	c3                   	ret    

0000397a <dup>:
SYSCALL(dup)
    397a:	b8 0a 00 00 00       	mov    $0xa,%eax
    397f:	cd 40                	int    $0x40
    3981:	c3                   	ret    

00003982 <getpid>:
SYSCALL(getpid)
    3982:	b8 0b 00 00 00       	mov    $0xb,%eax
    3987:	cd 40                	int    $0x40
    3989:	c3                   	ret    

0000398a <sbrk>:
SYSCALL(sbrk)
    398a:	b8 0c 00 00 00       	mov    $0xc,%eax
    398f:	cd 40                	int    $0x40
    3991:	c3                   	ret    

00003992 <sleep>:
SYSCALL(sleep)
    3992:	b8 0d 00 00 00       	mov    $0xd,%eax
    3997:	cd 40                	int    $0x40
    3999:	c3                   	ret    

0000399a <uptime>:
SYSCALL(uptime)
    399a:	b8 0e 00 00 00       	mov    $0xe,%eax
    399f:	cd 40                	int    $0x40
    39a1:	c3                   	ret    

000039a2 <kthread_create>:
//kthread
SYSCALL(kthread_create)
    39a2:	b8 16 00 00 00       	mov    $0x16,%eax
    39a7:	cd 40                	int    $0x40
    39a9:	c3                   	ret    

000039aa <kthread_id>:
SYSCALL(kthread_id)
    39aa:	b8 17 00 00 00       	mov    $0x17,%eax
    39af:	cd 40                	int    $0x40
    39b1:	c3                   	ret    

000039b2 <kthread_exit>:
SYSCALL(kthread_exit)
    39b2:	b8 18 00 00 00       	mov    $0x18,%eax
    39b7:	cd 40                	int    $0x40
    39b9:	c3                   	ret    

000039ba <kthread_join>:
SYSCALL(kthread_join)
    39ba:	b8 19 00 00 00       	mov    $0x19,%eax
    39bf:	cd 40                	int    $0x40
    39c1:	c3                   	ret    
    39c2:	66 90                	xchg   %ax,%ax
    39c4:	66 90                	xchg   %ax,%ax
    39c6:	66 90                	xchg   %ax,%ax
    39c8:	66 90                	xchg   %ax,%ax
    39ca:	66 90                	xchg   %ax,%ax
    39cc:	66 90                	xchg   %ax,%ax
    39ce:	66 90                	xchg   %ax,%ax

000039d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    39d0:	55                   	push   %ebp
    39d1:	89 e5                	mov    %esp,%ebp
    39d3:	57                   	push   %edi
    39d4:	56                   	push   %esi
    39d5:	53                   	push   %ebx
    39d6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    39d9:	85 d2                	test   %edx,%edx
{
    39db:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
    39de:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    39e0:	79 76                	jns    3a58 <printint+0x88>
    39e2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    39e6:	74 70                	je     3a58 <printint+0x88>
    x = -xx;
    39e8:	f7 d8                	neg    %eax
    neg = 1;
    39ea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    39f1:	31 f6                	xor    %esi,%esi
    39f3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    39f6:	eb 0a                	jmp    3a02 <printint+0x32>
    39f8:	90                   	nop
    39f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
    3a00:	89 fe                	mov    %edi,%esi
    3a02:	31 d2                	xor    %edx,%edx
    3a04:	8d 7e 01             	lea    0x1(%esi),%edi
    3a07:	f7 f1                	div    %ecx
    3a09:	0f b6 92 f8 55 00 00 	movzbl 0x55f8(%edx),%edx
  }while((x /= base) != 0);
    3a10:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    3a12:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    3a15:	75 e9                	jne    3a00 <printint+0x30>
  if(neg)
    3a17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    3a1a:	85 c0                	test   %eax,%eax
    3a1c:	74 08                	je     3a26 <printint+0x56>
    buf[i++] = '-';
    3a1e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    3a23:	8d 7e 02             	lea    0x2(%esi),%edi
    3a26:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    3a2a:	8b 7d c0             	mov    -0x40(%ebp),%edi
    3a2d:	8d 76 00             	lea    0x0(%esi),%esi
    3a30:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
    3a33:	83 ec 04             	sub    $0x4,%esp
    3a36:	83 ee 01             	sub    $0x1,%esi
    3a39:	6a 01                	push   $0x1
    3a3b:	53                   	push   %ebx
    3a3c:	57                   	push   %edi
    3a3d:	88 45 d7             	mov    %al,-0x29(%ebp)
    3a40:	e8 dd fe ff ff       	call   3922 <write>

  while(--i >= 0)
    3a45:	83 c4 10             	add    $0x10,%esp
    3a48:	39 de                	cmp    %ebx,%esi
    3a4a:	75 e4                	jne    3a30 <printint+0x60>
    putc(fd, buf[i]);
}
    3a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3a4f:	5b                   	pop    %ebx
    3a50:	5e                   	pop    %esi
    3a51:	5f                   	pop    %edi
    3a52:	5d                   	pop    %ebp
    3a53:	c3                   	ret    
    3a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    3a58:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    3a5f:	eb 90                	jmp    39f1 <printint+0x21>
    3a61:	eb 0d                	jmp    3a70 <printf>
    3a63:	90                   	nop
    3a64:	90                   	nop
    3a65:	90                   	nop
    3a66:	90                   	nop
    3a67:	90                   	nop
    3a68:	90                   	nop
    3a69:	90                   	nop
    3a6a:	90                   	nop
    3a6b:	90                   	nop
    3a6c:	90                   	nop
    3a6d:	90                   	nop
    3a6e:	90                   	nop
    3a6f:	90                   	nop

00003a70 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3a70:	55                   	push   %ebp
    3a71:	89 e5                	mov    %esp,%ebp
    3a73:	57                   	push   %edi
    3a74:	56                   	push   %esi
    3a75:	53                   	push   %ebx
    3a76:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3a79:	8b 75 0c             	mov    0xc(%ebp),%esi
    3a7c:	0f b6 1e             	movzbl (%esi),%ebx
    3a7f:	84 db                	test   %bl,%bl
    3a81:	0f 84 b3 00 00 00    	je     3b3a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
    3a87:	8d 45 10             	lea    0x10(%ebp),%eax
    3a8a:	83 c6 01             	add    $0x1,%esi
  state = 0;
    3a8d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
    3a8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3a92:	eb 2f                	jmp    3ac3 <printf+0x53>
    3a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    3a98:	83 f8 25             	cmp    $0x25,%eax
    3a9b:	0f 84 a7 00 00 00    	je     3b48 <printf+0xd8>
  write(fd, &c, 1);
    3aa1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    3aa4:	83 ec 04             	sub    $0x4,%esp
    3aa7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    3aaa:	6a 01                	push   $0x1
    3aac:	50                   	push   %eax
    3aad:	ff 75 08             	pushl  0x8(%ebp)
    3ab0:	e8 6d fe ff ff       	call   3922 <write>
    3ab5:	83 c4 10             	add    $0x10,%esp
    3ab8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    3abb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    3abf:	84 db                	test   %bl,%bl
    3ac1:	74 77                	je     3b3a <printf+0xca>
    if(state == 0){
    3ac3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    3ac5:	0f be cb             	movsbl %bl,%ecx
    3ac8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    3acb:	74 cb                	je     3a98 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    3acd:	83 ff 25             	cmp    $0x25,%edi
    3ad0:	75 e6                	jne    3ab8 <printf+0x48>
      if(c == 'd'){
    3ad2:	83 f8 64             	cmp    $0x64,%eax
    3ad5:	0f 84 05 01 00 00    	je     3be0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3adb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    3ae1:	83 f9 70             	cmp    $0x70,%ecx
    3ae4:	74 72                	je     3b58 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3ae6:	83 f8 73             	cmp    $0x73,%eax
    3ae9:	0f 84 99 00 00 00    	je     3b88 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3aef:	83 f8 63             	cmp    $0x63,%eax
    3af2:	0f 84 08 01 00 00    	je     3c00 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3af8:	83 f8 25             	cmp    $0x25,%eax
    3afb:	0f 84 ef 00 00 00    	je     3bf0 <printf+0x180>
  write(fd, &c, 1);
    3b01:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3b04:	83 ec 04             	sub    $0x4,%esp
    3b07:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3b0b:	6a 01                	push   $0x1
    3b0d:	50                   	push   %eax
    3b0e:	ff 75 08             	pushl  0x8(%ebp)
    3b11:	e8 0c fe ff ff       	call   3922 <write>
    3b16:	83 c4 0c             	add    $0xc,%esp
    3b19:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    3b1c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    3b1f:	6a 01                	push   $0x1
    3b21:	50                   	push   %eax
    3b22:	ff 75 08             	pushl  0x8(%ebp)
    3b25:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    3b28:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    3b2a:	e8 f3 fd ff ff       	call   3922 <write>
  for(i = 0; fmt[i]; i++){
    3b2f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    3b33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    3b36:	84 db                	test   %bl,%bl
    3b38:	75 89                	jne    3ac3 <printf+0x53>
    }
  }
}
    3b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3b3d:	5b                   	pop    %ebx
    3b3e:	5e                   	pop    %esi
    3b3f:	5f                   	pop    %edi
    3b40:	5d                   	pop    %ebp
    3b41:	c3                   	ret    
    3b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    3b48:	bf 25 00 00 00       	mov    $0x25,%edi
    3b4d:	e9 66 ff ff ff       	jmp    3ab8 <printf+0x48>
    3b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    3b58:	83 ec 0c             	sub    $0xc,%esp
    3b5b:	b9 10 00 00 00       	mov    $0x10,%ecx
    3b60:	6a 00                	push   $0x0
    3b62:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3b65:	8b 45 08             	mov    0x8(%ebp),%eax
    3b68:	8b 17                	mov    (%edi),%edx
    3b6a:	e8 61 fe ff ff       	call   39d0 <printint>
        ap++;
    3b6f:	89 f8                	mov    %edi,%eax
    3b71:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3b74:	31 ff                	xor    %edi,%edi
        ap++;
    3b76:	83 c0 04             	add    $0x4,%eax
    3b79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3b7c:	e9 37 ff ff ff       	jmp    3ab8 <printf+0x48>
    3b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    3b88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3b8b:	8b 08                	mov    (%eax),%ecx
        ap++;
    3b8d:	83 c0 04             	add    $0x4,%eax
    3b90:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    3b93:	85 c9                	test   %ecx,%ecx
    3b95:	0f 84 8e 00 00 00    	je     3c29 <printf+0x1b9>
        while(*s != 0){
    3b9b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    3b9e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    3ba0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    3ba2:	84 c0                	test   %al,%al
    3ba4:	0f 84 0e ff ff ff    	je     3ab8 <printf+0x48>
    3baa:	89 75 d0             	mov    %esi,-0x30(%ebp)
    3bad:	89 de                	mov    %ebx,%esi
    3baf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3bb2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    3bb5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    3bb8:	83 ec 04             	sub    $0x4,%esp
          s++;
    3bbb:	83 c6 01             	add    $0x1,%esi
    3bbe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    3bc1:	6a 01                	push   $0x1
    3bc3:	57                   	push   %edi
    3bc4:	53                   	push   %ebx
    3bc5:	e8 58 fd ff ff       	call   3922 <write>
        while(*s != 0){
    3bca:	0f b6 06             	movzbl (%esi),%eax
    3bcd:	83 c4 10             	add    $0x10,%esp
    3bd0:	84 c0                	test   %al,%al
    3bd2:	75 e4                	jne    3bb8 <printf+0x148>
    3bd4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    3bd7:	31 ff                	xor    %edi,%edi
    3bd9:	e9 da fe ff ff       	jmp    3ab8 <printf+0x48>
    3bde:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    3be0:	83 ec 0c             	sub    $0xc,%esp
    3be3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3be8:	6a 01                	push   $0x1
    3bea:	e9 73 ff ff ff       	jmp    3b62 <printf+0xf2>
    3bef:	90                   	nop
  write(fd, &c, 1);
    3bf0:	83 ec 04             	sub    $0x4,%esp
    3bf3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    3bf6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    3bf9:	6a 01                	push   $0x1
    3bfb:	e9 21 ff ff ff       	jmp    3b21 <printf+0xb1>
        putc(fd, *ap);
    3c00:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    3c03:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    3c06:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    3c08:	6a 01                	push   $0x1
        ap++;
    3c0a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    3c0d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    3c10:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3c13:	50                   	push   %eax
    3c14:	ff 75 08             	pushl  0x8(%ebp)
    3c17:	e8 06 fd ff ff       	call   3922 <write>
        ap++;
    3c1c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    3c1f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3c22:	31 ff                	xor    %edi,%edi
    3c24:	e9 8f fe ff ff       	jmp    3ab8 <printf+0x48>
          s = "(null)";
    3c29:	bb f0 55 00 00       	mov    $0x55f0,%ebx
        while(*s != 0){
    3c2e:	b8 28 00 00 00       	mov    $0x28,%eax
    3c33:	e9 72 ff ff ff       	jmp    3baa <printf+0x13a>
    3c38:	66 90                	xchg   %ax,%ax
    3c3a:	66 90                	xchg   %ax,%ax
    3c3c:	66 90                	xchg   %ax,%ax
    3c3e:	66 90                	xchg   %ax,%ax

00003c40 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3c40:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3c41:	a1 a0 5f 00 00       	mov    0x5fa0,%eax
{
    3c46:	89 e5                	mov    %esp,%ebp
    3c48:	57                   	push   %edi
    3c49:	56                   	push   %esi
    3c4a:	53                   	push   %ebx
    3c4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    3c4e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    3c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3c58:	39 c8                	cmp    %ecx,%eax
    3c5a:	8b 10                	mov    (%eax),%edx
    3c5c:	73 32                	jae    3c90 <free+0x50>
    3c5e:	39 d1                	cmp    %edx,%ecx
    3c60:	72 04                	jb     3c66 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3c62:	39 d0                	cmp    %edx,%eax
    3c64:	72 32                	jb     3c98 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3c66:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3c69:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3c6c:	39 fa                	cmp    %edi,%edx
    3c6e:	74 30                	je     3ca0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3c70:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3c73:	8b 50 04             	mov    0x4(%eax),%edx
    3c76:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3c79:	39 f1                	cmp    %esi,%ecx
    3c7b:	74 3a                	je     3cb7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3c7d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3c7f:	a3 a0 5f 00 00       	mov    %eax,0x5fa0
}
    3c84:	5b                   	pop    %ebx
    3c85:	5e                   	pop    %esi
    3c86:	5f                   	pop    %edi
    3c87:	5d                   	pop    %ebp
    3c88:	c3                   	ret    
    3c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3c90:	39 d0                	cmp    %edx,%eax
    3c92:	72 04                	jb     3c98 <free+0x58>
    3c94:	39 d1                	cmp    %edx,%ecx
    3c96:	72 ce                	jb     3c66 <free+0x26>
{
    3c98:	89 d0                	mov    %edx,%eax
    3c9a:	eb bc                	jmp    3c58 <free+0x18>
    3c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    3ca0:	03 72 04             	add    0x4(%edx),%esi
    3ca3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3ca6:	8b 10                	mov    (%eax),%edx
    3ca8:	8b 12                	mov    (%edx),%edx
    3caa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3cad:	8b 50 04             	mov    0x4(%eax),%edx
    3cb0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3cb3:	39 f1                	cmp    %esi,%ecx
    3cb5:	75 c6                	jne    3c7d <free+0x3d>
    p->s.size += bp->s.size;
    3cb7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    3cba:	a3 a0 5f 00 00       	mov    %eax,0x5fa0
    p->s.size += bp->s.size;
    3cbf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3cc2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3cc5:	89 10                	mov    %edx,(%eax)
}
    3cc7:	5b                   	pop    %ebx
    3cc8:	5e                   	pop    %esi
    3cc9:	5f                   	pop    %edi
    3cca:	5d                   	pop    %ebp
    3ccb:	c3                   	ret    
    3ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003cd0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3cd0:	55                   	push   %ebp
    3cd1:	89 e5                	mov    %esp,%ebp
    3cd3:	57                   	push   %edi
    3cd4:	56                   	push   %esi
    3cd5:	53                   	push   %ebx
    3cd6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    3cdc:	8b 15 a0 5f 00 00    	mov    0x5fa0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3ce2:	8d 78 07             	lea    0x7(%eax),%edi
    3ce5:	c1 ef 03             	shr    $0x3,%edi
    3ce8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    3ceb:	85 d2                	test   %edx,%edx
    3ced:	0f 84 9d 00 00 00    	je     3d90 <malloc+0xc0>
    3cf3:	8b 02                	mov    (%edx),%eax
    3cf5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    3cf8:	39 cf                	cmp    %ecx,%edi
    3cfa:	76 6c                	jbe    3d68 <malloc+0x98>
    3cfc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    3d02:	bb 00 10 00 00       	mov    $0x1000,%ebx
    3d07:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    3d0a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    3d11:	eb 0e                	jmp    3d21 <malloc+0x51>
    3d13:	90                   	nop
    3d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3d18:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3d1a:	8b 48 04             	mov    0x4(%eax),%ecx
    3d1d:	39 f9                	cmp    %edi,%ecx
    3d1f:	73 47                	jae    3d68 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3d21:	39 05 a0 5f 00 00    	cmp    %eax,0x5fa0
    3d27:	89 c2                	mov    %eax,%edx
    3d29:	75 ed                	jne    3d18 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    3d2b:	83 ec 0c             	sub    $0xc,%esp
    3d2e:	56                   	push   %esi
    3d2f:	e8 56 fc ff ff       	call   398a <sbrk>
  if(p == (char*)-1)
    3d34:	83 c4 10             	add    $0x10,%esp
    3d37:	83 f8 ff             	cmp    $0xffffffff,%eax
    3d3a:	74 1c                	je     3d58 <malloc+0x88>
  hp->s.size = nu;
    3d3c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3d3f:	83 ec 0c             	sub    $0xc,%esp
    3d42:	83 c0 08             	add    $0x8,%eax
    3d45:	50                   	push   %eax
    3d46:	e8 f5 fe ff ff       	call   3c40 <free>
  return freep;
    3d4b:	8b 15 a0 5f 00 00    	mov    0x5fa0,%edx
      if((p = morecore(nunits)) == 0)
    3d51:	83 c4 10             	add    $0x10,%esp
    3d54:	85 d2                	test   %edx,%edx
    3d56:	75 c0                	jne    3d18 <malloc+0x48>
        return 0;
  }
}
    3d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    3d5b:	31 c0                	xor    %eax,%eax
}
    3d5d:	5b                   	pop    %ebx
    3d5e:	5e                   	pop    %esi
    3d5f:	5f                   	pop    %edi
    3d60:	5d                   	pop    %ebp
    3d61:	c3                   	ret    
    3d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    3d68:	39 cf                	cmp    %ecx,%edi
    3d6a:	74 54                	je     3dc0 <malloc+0xf0>
        p->s.size -= nunits;
    3d6c:	29 f9                	sub    %edi,%ecx
    3d6e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3d71:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    3d74:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    3d77:	89 15 a0 5f 00 00    	mov    %edx,0x5fa0
}
    3d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    3d80:	83 c0 08             	add    $0x8,%eax
}
    3d83:	5b                   	pop    %ebx
    3d84:	5e                   	pop    %esi
    3d85:	5f                   	pop    %edi
    3d86:	5d                   	pop    %ebp
    3d87:	c3                   	ret    
    3d88:	90                   	nop
    3d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    3d90:	c7 05 a0 5f 00 00 a4 	movl   $0x5fa4,0x5fa0
    3d97:	5f 00 00 
    3d9a:	c7 05 a4 5f 00 00 a4 	movl   $0x5fa4,0x5fa4
    3da1:	5f 00 00 
    base.s.size = 0;
    3da4:	b8 a4 5f 00 00       	mov    $0x5fa4,%eax
    3da9:	c7 05 a8 5f 00 00 00 	movl   $0x0,0x5fa8
    3db0:	00 00 00 
    3db3:	e9 44 ff ff ff       	jmp    3cfc <malloc+0x2c>
    3db8:	90                   	nop
    3db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    3dc0:	8b 08                	mov    (%eax),%ecx
    3dc2:	89 0a                	mov    %ecx,(%edx)
    3dc4:	eb b1                	jmp    3d77 <malloc+0xa7>
