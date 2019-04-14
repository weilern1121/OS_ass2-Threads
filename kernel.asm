
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp
8010002d:	b8 b0 2e 10 80       	mov    $0x80102eb0,%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100049:	83 ec 0c             	sub    $0xc,%esp
8010004c:	68 c0 73 10 80       	push   $0x801073c0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 55 46 00 00       	call   801046b0 <initlock>
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
80100092:	68 c7 73 10 80       	push   $0x801073c7
80100097:	50                   	push   %eax
80100098:	e8 e3 44 00 00       	call   80104580 <initsleeplock>
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 07 47 00 00       	call   801047f0 <acquire>
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 49 47 00 00       	call   801048b0 <release>
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 44 00 00       	call   801045c0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 1f 00 00       	call   80102140 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 73 10 80       	push   $0x801073ce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ad 44 00 00       	call   80104660 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
801001c4:	e9 77 1f 00 00       	jmp    80102140 <iderw>
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 73 10 80       	push   $0x801073df
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 6c 44 00 00       	call   80104660 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 44 00 00       	call   80104620 <releasesleep>
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 e0 45 00 00       	call   801047f0 <acquire>
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100213:	83 c4 10             	add    $0x10,%esp
80100216:	83 e8 01             	sub    $0x1,%eax
80100219:	85 c0                	test   %eax,%eax
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
8010025c:	e9 4f 46 00 00       	jmp    801048b0 <release>
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 73 10 80       	push   $0x801073e6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 fb 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 5f 45 00 00       	call   801047f0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 d6 3b 00 00       	call   80103ea0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 90 35 00 00       	call   80103870 <myproc>
801002e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 bc 45 00 00       	call   801048b0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 a4 13 00 00       	call   801016a0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 5e 45 00 00       	call   801048b0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 46 13 00 00       	call   801016a0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 92 23 00 00       	call   80102740 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 73 10 80       	push   $0x801073ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 17 7e 10 80 	movl   $0x80107e17,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 42 00 00       	call   801046d0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 74 10 80       	push   $0x80107401
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 71 5b 00 00       	call   80105fb0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 bf 5a 00 00       	call   80105fb0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 b3 5a 00 00       	call   80105fb0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 a7 5a 00 00       	call   80105fb0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 97 44 00 00       	call   801049c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ca 43 00 00       	call   80104910 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 74 10 80       	push   $0x80107405
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 74 10 80 	movzbl -0x7fef8bd0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 6c 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 d0 41 00 00       	call   801047f0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 64 42 00 00       	call   801048b0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 4b 10 00 00       	call   801016a0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 8c 41 00 00       	call   801048b0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 74 10 80       	mov    $0x80107418,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 fb 3f 00 00       	call   801047f0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 74 10 80       	push   $0x8010741f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 c8 3f 00 00       	call   801047f0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 23 40 00 00       	call   801048b0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 45 3a 00 00       	call   80104360 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 04 3b 00 00       	jmp    801044a0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 74 10 80       	push   $0x80107428
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 db 3c 00 00       	call   801046b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 f2 18 00 00       	call   801022f0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3+MAXARG+1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
80100a1c:	e8 4f 2e 00 00       	call   80103870 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
    struct  thread *curthread = mythread();
80100a27:	e8 74 2e 00 00       	call   801038a0 <mythread>
80100a2c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
    //struct  thread *t;
    begin_op();
80100a32:	e8 69 21 00 00       	call   80102ba0 <begin_op>

    if((ip = namei(path)) == 0){
80100a37:	83 ec 0c             	sub    $0xc,%esp
80100a3a:	ff 75 08             	pushl  0x8(%ebp)
80100a3d:	e8 be 14 00 00       	call   80101f00 <namei>
80100a42:	83 c4 10             	add    $0x10,%esp
80100a45:	85 c0                	test   %eax,%eax
80100a47:	0f 84 8e 01 00 00    	je     80100bdb <exec+0x1cb>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100a4d:	83 ec 0c             	sub    $0xc,%esp
80100a50:	89 c3                	mov    %eax,%ebx
80100a52:	50                   	push   %eax
80100a53:	e8 48 0c 00 00       	call   801016a0 <ilock>
    pgdir = 0;

    // Check ELF header
    if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a58:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a5e:	6a 34                	push   $0x34
80100a60:	6a 00                	push   $0x0
80100a62:	50                   	push   %eax
80100a63:	53                   	push   %ebx
80100a64:	e8 17 0f 00 00       	call   80101980 <readi>
80100a69:	83 c4 20             	add    $0x20,%esp
80100a6c:	83 f8 34             	cmp    $0x34,%eax
80100a6f:	74 1f                	je     80100a90 <exec+0x80>

bad:
    if(pgdir)
        freevm(pgdir);
    if(ip){
        iunlockput(ip);
80100a71:	83 ec 0c             	sub    $0xc,%esp
80100a74:	53                   	push   %ebx
80100a75:	e8 b6 0e 00 00       	call   80101930 <iunlockput>
        end_op();
80100a7a:	e8 91 21 00 00       	call   80102c10 <end_op>
80100a7f:	83 c4 10             	add    $0x10,%esp
    }
    return -1;
80100a82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a8a:	5b                   	pop    %ebx
80100a8b:	5e                   	pop    %esi
80100a8c:	5f                   	pop    %edi
80100a8d:	5d                   	pop    %ebp
80100a8e:	c3                   	ret    
80100a8f:	90                   	nop
    if(elf.magic != ELF_MAGIC)
80100a90:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a97:	45 4c 46 
80100a9a:	75 d5                	jne    80100a71 <exec+0x61>
    if((pgdir = setupkvm()) == 0)
80100a9c:	e8 6f 66 00 00       	call   80107110 <setupkvm>
80100aa1:	85 c0                	test   %eax,%eax
80100aa3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100aa9:	74 c6                	je     80100a71 <exec+0x61>
    sz = 0;
80100aab:	31 ff                	xor    %edi,%edi
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aad:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ab4:	00 
80100ab5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100abb:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100ac1:	0f 84 90 02 00 00    	je     80100d57 <exec+0x347>
80100ac7:	31 f6                	xor    %esi,%esi
80100ac9:	eb 7f                	jmp    80100b4a <exec+0x13a>
80100acb:	90                   	nop
80100acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(ph.type != ELF_PROG_LOAD)
80100ad0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ad7:	75 63                	jne    80100b3c <exec+0x12c>
        if(ph.memsz < ph.filesz)
80100ad9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100adf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ae5:	0f 82 86 00 00 00    	jb     80100b71 <exec+0x161>
80100aeb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af1:	72 7e                	jb     80100b71 <exec+0x161>
        if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af3:	83 ec 04             	sub    $0x4,%esp
80100af6:	50                   	push   %eax
80100af7:	57                   	push   %edi
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	e8 2d 64 00 00       	call   80106f30 <allocuvm>
80100b03:	83 c4 10             	add    $0x10,%esp
80100b06:	85 c0                	test   %eax,%eax
80100b08:	89 c7                	mov    %eax,%edi
80100b0a:	74 65                	je     80100b71 <exec+0x161>
        if(ph.vaddr % PGSIZE != 0)
80100b0c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b12:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b17:	75 58                	jne    80100b71 <exec+0x161>
        if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b19:	83 ec 0c             	sub    $0xc,%esp
80100b1c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b22:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b28:	53                   	push   %ebx
80100b29:	50                   	push   %eax
80100b2a:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b30:	e8 3b 63 00 00       	call   80106e70 <loaduvm>
80100b35:	83 c4 20             	add    $0x20,%esp
80100b38:	85 c0                	test   %eax,%eax
80100b3a:	78 35                	js     80100b71 <exec+0x161>
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b3c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b43:	83 c6 01             	add    $0x1,%esi
80100b46:	39 f0                	cmp    %esi,%eax
80100b48:	7e 3d                	jle    80100b87 <exec+0x177>
        if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b4a:	89 f0                	mov    %esi,%eax
80100b4c:	6a 20                	push   $0x20
80100b4e:	c1 e0 05             	shl    $0x5,%eax
80100b51:	03 85 e8 fe ff ff    	add    -0x118(%ebp),%eax
80100b57:	50                   	push   %eax
80100b58:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b5e:	50                   	push   %eax
80100b5f:	53                   	push   %ebx
80100b60:	e8 1b 0e 00 00       	call   80101980 <readi>
80100b65:	83 c4 10             	add    $0x10,%esp
80100b68:	83 f8 20             	cmp    $0x20,%eax
80100b6b:	0f 84 5f ff ff ff    	je     80100ad0 <exec+0xc0>
        freevm(pgdir);
80100b71:	83 ec 0c             	sub    $0xc,%esp
80100b74:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b7a:	e8 11 65 00 00       	call   80107090 <freevm>
80100b7f:	83 c4 10             	add    $0x10,%esp
80100b82:	e9 ea fe ff ff       	jmp    80100a71 <exec+0x61>
80100b87:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b8d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b93:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
    iunlockput(ip);
80100b99:	83 ec 0c             	sub    $0xc,%esp
80100b9c:	53                   	push   %ebx
80100b9d:	e8 8e 0d 00 00       	call   80101930 <iunlockput>
    end_op();
80100ba2:	e8 69 20 00 00       	call   80102c10 <end_op>
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ba7:	83 c4 0c             	add    $0xc,%esp
80100baa:	56                   	push   %esi
80100bab:	57                   	push   %edi
80100bac:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bb2:	e8 79 63 00 00       	call   80106f30 <allocuvm>
80100bb7:	83 c4 10             	add    $0x10,%esp
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	89 c6                	mov    %eax,%esi
80100bbe:	75 3a                	jne    80100bfa <exec+0x1ea>
        freevm(pgdir);
80100bc0:	83 ec 0c             	sub    $0xc,%esp
80100bc3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bc9:	e8 c2 64 00 00       	call   80107090 <freevm>
80100bce:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd6:	e9 ac fe ff ff       	jmp    80100a87 <exec+0x77>
        end_op();
80100bdb:	e8 30 20 00 00       	call   80102c10 <end_op>
        cprintf("exec: fail\n");
80100be0:	83 ec 0c             	sub    $0xc,%esp
80100be3:	68 41 74 10 80       	push   $0x80107441
80100be8:	e8 73 fa ff ff       	call   80100660 <cprintf>
        return -1;
80100bed:	83 c4 10             	add    $0x10,%esp
80100bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bf5:	e9 8d fe ff ff       	jmp    80100a87 <exec+0x77>
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bfa:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c00:	83 ec 08             	sub    $0x8,%esp
    for(argc = 0; argv[argc]; argc++) {
80100c03:	31 ff                	xor    %edi,%edi
80100c05:	89 f3                	mov    %esi,%ebx
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c07:	50                   	push   %eax
80100c08:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100c0e:	e8 9d 65 00 00       	call   801071b0 <clearpteu>
    for(argc = 0; argv[argc]; argc++) {
80100c13:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c16:	83 c4 10             	add    $0x10,%esp
80100c19:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c1f:	8b 00                	mov    (%eax),%eax
80100c21:	85 c0                	test   %eax,%eax
80100c23:	74 70                	je     80100c95 <exec+0x285>
80100c25:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
80100c2b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c31:	eb 0a                	jmp    80100c3d <exec+0x22d>
80100c33:	90                   	nop
80100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(argc >= MAXARG)
80100c38:	83 ff 20             	cmp    $0x20,%edi
80100c3b:	74 83                	je     80100bc0 <exec+0x1b0>
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3d:	83 ec 0c             	sub    $0xc,%esp
80100c40:	50                   	push   %eax
80100c41:	e8 0a 3f 00 00       	call   80104b50 <strlen>
80100c46:	f7 d0                	not    %eax
80100c48:	01 c3                	add    %eax,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4d:	5a                   	pop    %edx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c4e:	83 e3 fc             	and    $0xfffffffc,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c51:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c54:	e8 f7 3e 00 00       	call   80104b50 <strlen>
80100c59:	83 c0 01             	add    $0x1,%eax
80100c5c:	50                   	push   %eax
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c60:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c63:	53                   	push   %ebx
80100c64:	56                   	push   %esi
80100c65:	e8 a6 66 00 00       	call   80107310 <copyout>
80100c6a:	83 c4 20             	add    $0x20,%esp
80100c6d:	85 c0                	test   %eax,%eax
80100c6f:	0f 88 4b ff ff ff    	js     80100bc0 <exec+0x1b0>
    for(argc = 0; argv[argc]; argc++) {
80100c75:	8b 45 0c             	mov    0xc(%ebp),%eax
        ustack[3+argc] = sp;
80100c78:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    for(argc = 0; argv[argc]; argc++) {
80100c7f:	83 c7 01             	add    $0x1,%edi
        ustack[3+argc] = sp;
80100c82:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c8b:	85 c0                	test   %eax,%eax
80100c8d:	75 a9                	jne    80100c38 <exec+0x228>
80100c8f:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c95:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c9c:	89 d9                	mov    %ebx,%ecx
    ustack[3+argc] = 0;
80100c9e:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100ca5:	00 00 00 00 
    ustack[0] = 0xffffffff;  // fake return PC
80100ca9:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cb0:	ff ff ff 
    ustack[1] = argc;
80100cb3:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb9:	29 c1                	sub    %eax,%ecx
    sp -= (3+argc+1) * 4;
80100cbb:	83 c0 0c             	add    $0xc,%eax
80100cbe:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc0:	50                   	push   %eax
80100cc1:	52                   	push   %edx
80100cc2:	53                   	push   %ebx
80100cc3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc9:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ccf:	e8 3c 66 00 00       	call   80107310 <copyout>
80100cd4:	83 c4 10             	add    $0x10,%esp
80100cd7:	85 c0                	test   %eax,%eax
80100cd9:	0f 88 e1 fe ff ff    	js     80100bc0 <exec+0x1b0>
    for(last=s=path; *s; s++)
80100cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80100ce2:	0f b6 00             	movzbl (%eax),%eax
80100ce5:	84 c0                	test   %al,%al
80100ce7:	74 17                	je     80100d00 <exec+0x2f0>
80100ce9:	8b 55 08             	mov    0x8(%ebp),%edx
80100cec:	89 d1                	mov    %edx,%ecx
80100cee:	83 c1 01             	add    $0x1,%ecx
80100cf1:	3c 2f                	cmp    $0x2f,%al
80100cf3:	0f b6 01             	movzbl (%ecx),%eax
80100cf6:	0f 44 d1             	cmove  %ecx,%edx
80100cf9:	84 c0                	test   %al,%al
80100cfb:	75 f1                	jne    80100cee <exec+0x2de>
80100cfd:	89 55 08             	mov    %edx,0x8(%ebp)
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d00:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d06:	50                   	push   %eax
80100d07:	6a 10                	push   $0x10
80100d09:	ff 75 08             	pushl  0x8(%ebp)
80100d0c:	8d 47 60             	lea    0x60(%edi),%eax
80100d0f:	50                   	push   %eax
80100d10:	e8 fb 3d 00 00       	call   80104b10 <safestrcpy>
    oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
    curproc->pgdir = pgdir;
80100d17:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
    oldpgdir = curproc->pgdir;
80100d1d:	8b 7f 04             	mov    0x4(%edi),%edi
    curproc->sz = sz;
80100d20:	89 31                	mov    %esi,(%ecx)
    curthread->tf->eip = elf.entry;  // main
80100d22:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
    curproc->pgdir = pgdir;
80100d28:	89 41 04             	mov    %eax,0x4(%ecx)
    curthread->tf->eip = elf.entry;  // main
80100d2b:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d31:	8b 46 10             	mov    0x10(%esi),%eax
80100d34:	89 50 38             	mov    %edx,0x38(%eax)
    curthread->tf->esp = sp;
80100d37:	8b 46 10             	mov    0x10(%esi),%eax
80100d3a:	89 58 44             	mov    %ebx,0x44(%eax)
    switchuvm(curproc);
80100d3d:	89 0c 24             	mov    %ecx,(%esp)
80100d40:	e8 8b 5f 00 00       	call   80106cd0 <switchuvm>
    freevm(oldpgdir);
80100d45:	89 3c 24             	mov    %edi,(%esp)
80100d48:	e8 43 63 00 00       	call   80107090 <freevm>
    return 0;
80100d4d:	83 c4 10             	add    $0x10,%esp
80100d50:	31 c0                	xor    %eax,%eax
80100d52:	e9 30 fd ff ff       	jmp    80100a87 <exec+0x77>
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d57:	be 00 20 00 00       	mov    $0x2000,%esi
80100d5c:	e9 38 fe ff ff       	jmp    80100b99 <exec+0x189>
80100d61:	66 90                	xchg   %ax,%ax
80100d63:	66 90                	xchg   %ax,%ax
80100d65:	66 90                	xchg   %ax,%ax
80100d67:	66 90                	xchg   %ax,%ax
80100d69:	66 90                	xchg   %ax,%ax
80100d6b:	66 90                	xchg   %ax,%ax
80100d6d:	66 90                	xchg   %ax,%ax
80100d6f:	90                   	nop

80100d70 <fileinit>:
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	83 ec 10             	sub    $0x10,%esp
80100d76:	68 4d 74 10 80       	push   $0x8010744d
80100d7b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d80:	e8 2b 39 00 00       	call   801046b0 <initlock>
80100d85:	83 c4 10             	add    $0x10,%esp
80100d88:	c9                   	leave  
80100d89:	c3                   	ret    
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d90 <filealloc>:
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	53                   	push   %ebx
80100d94:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100d99:	83 ec 10             	sub    $0x10,%esp
80100d9c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100da1:	e8 4a 3a 00 00       	call   801047f0 <acquire>
80100da6:	83 c4 10             	add    $0x10,%esp
80100da9:	eb 10                	jmp    80100dbb <filealloc+0x2b>
80100dab:	90                   	nop
80100dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100db0:	83 c3 18             	add    $0x18,%ebx
80100db3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100db9:	74 25                	je     80100de0 <filealloc+0x50>
80100dbb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	75 ee                	jne    80100db0 <filealloc+0x20>
80100dc2:	83 ec 0c             	sub    $0xc,%esp
80100dc5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
80100dcc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dd1:	e8 da 3a 00 00       	call   801048b0 <release>
80100dd6:	89 d8                	mov    %ebx,%eax
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dde:	c9                   	leave  
80100ddf:	c3                   	ret    
80100de0:	83 ec 0c             	sub    $0xc,%esp
80100de3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100de8:	e8 c3 3a 00 00       	call   801048b0 <release>
80100ded:	83 c4 10             	add    $0x10,%esp
80100df0:	31 c0                	xor    %eax,%eax
80100df2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df5:	c9                   	leave  
80100df6:	c3                   	ret    
80100df7:	89 f6                	mov    %esi,%esi
80100df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e00 <filedup>:
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
80100e04:	83 ec 10             	sub    $0x10,%esp
80100e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100e0a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0f:	e8 dc 39 00 00       	call   801047f0 <acquire>
80100e14:	8b 43 04             	mov    0x4(%ebx),%eax
80100e17:	83 c4 10             	add    $0x10,%esp
80100e1a:	85 c0                	test   %eax,%eax
80100e1c:	7e 1a                	jle    80100e38 <filedup+0x38>
80100e1e:	83 c0 01             	add    $0x1,%eax
80100e21:	83 ec 0c             	sub    $0xc,%esp
80100e24:	89 43 04             	mov    %eax,0x4(%ebx)
80100e27:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e2c:	e8 7f 3a 00 00       	call   801048b0 <release>
80100e31:	89 d8                	mov    %ebx,%eax
80100e33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e36:	c9                   	leave  
80100e37:	c3                   	ret    
80100e38:	83 ec 0c             	sub    $0xc,%esp
80100e3b:	68 54 74 10 80       	push   $0x80107454
80100e40:	e8 4b f5 ff ff       	call   80100390 <panic>
80100e45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e50 <fileclose>:
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	57                   	push   %edi
80100e54:	56                   	push   %esi
80100e55:	53                   	push   %ebx
80100e56:	83 ec 28             	sub    $0x28,%esp
80100e59:	8b 7d 08             	mov    0x8(%ebp),%edi
80100e5c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e61:	e8 8a 39 00 00       	call   801047f0 <acquire>
80100e66:	8b 47 04             	mov    0x4(%edi),%eax
80100e69:	83 c4 10             	add    $0x10,%esp
80100e6c:	85 c0                	test   %eax,%eax
80100e6e:	0f 8e 9b 00 00 00    	jle    80100f0f <fileclose+0xbf>
80100e74:	83 e8 01             	sub    $0x1,%eax
80100e77:	85 c0                	test   %eax,%eax
80100e79:	89 47 04             	mov    %eax,0x4(%edi)
80100e7c:	74 1a                	je     80100e98 <fileclose+0x48>
80100e7e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
80100e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e88:	5b                   	pop    %ebx
80100e89:	5e                   	pop    %esi
80100e8a:	5f                   	pop    %edi
80100e8b:	5d                   	pop    %ebp
80100e8c:	e9 1f 3a 00 00       	jmp    801048b0 <release>
80100e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e98:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e9c:	8b 1f                	mov    (%edi),%ebx
80100e9e:	83 ec 0c             	sub    $0xc,%esp
80100ea1:	8b 77 0c             	mov    0xc(%edi),%esi
80100ea4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80100eaa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ead:	8b 47 10             	mov    0x10(%edi),%eax
80100eb0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100eb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100eb8:	e8 f3 39 00 00       	call   801048b0 <release>
80100ebd:	83 c4 10             	add    $0x10,%esp
80100ec0:	83 fb 01             	cmp    $0x1,%ebx
80100ec3:	74 13                	je     80100ed8 <fileclose+0x88>
80100ec5:	83 fb 02             	cmp    $0x2,%ebx
80100ec8:	74 26                	je     80100ef0 <fileclose+0xa0>
80100eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ecd:	5b                   	pop    %ebx
80100ece:	5e                   	pop    %esi
80100ecf:	5f                   	pop    %edi
80100ed0:	5d                   	pop    %ebp
80100ed1:	c3                   	ret    
80100ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ed8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100edc:	83 ec 08             	sub    $0x8,%esp
80100edf:	53                   	push   %ebx
80100ee0:	56                   	push   %esi
80100ee1:	e8 7a 24 00 00       	call   80103360 <pipeclose>
80100ee6:	83 c4 10             	add    $0x10,%esp
80100ee9:	eb df                	jmp    80100eca <fileclose+0x7a>
80100eeb:	90                   	nop
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ef0:	e8 ab 1c 00 00       	call   80102ba0 <begin_op>
80100ef5:	83 ec 0c             	sub    $0xc,%esp
80100ef8:	ff 75 e0             	pushl  -0x20(%ebp)
80100efb:	e8 d0 08 00 00       	call   801017d0 <iput>
80100f00:	83 c4 10             	add    $0x10,%esp
80100f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f06:	5b                   	pop    %ebx
80100f07:	5e                   	pop    %esi
80100f08:	5f                   	pop    %edi
80100f09:	5d                   	pop    %ebp
80100f0a:	e9 01 1d 00 00       	jmp    80102c10 <end_op>
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	68 5c 74 10 80       	push   $0x8010745c
80100f17:	e8 74 f4 ff ff       	call   80100390 <panic>
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filestat>:
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 04             	sub    $0x4,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f2d:	75 31                	jne    80100f60 <filestat+0x40>
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	ff 73 10             	pushl  0x10(%ebx)
80100f35:	e8 66 07 00 00       	call   801016a0 <ilock>
80100f3a:	58                   	pop    %eax
80100f3b:	5a                   	pop    %edx
80100f3c:	ff 75 0c             	pushl  0xc(%ebp)
80100f3f:	ff 73 10             	pushl  0x10(%ebx)
80100f42:	e8 09 0a 00 00       	call   80101950 <stati>
80100f47:	59                   	pop    %ecx
80100f48:	ff 73 10             	pushl  0x10(%ebx)
80100f4b:	e8 30 08 00 00       	call   80101780 <iunlock>
80100f50:	83 c4 10             	add    $0x10,%esp
80100f53:	31 c0                	xor    %eax,%eax
80100f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f70 <fileread>:
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 0c             	sub    $0xc,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f7f:	8b 7d 10             	mov    0x10(%ebp),%edi
80100f82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f86:	74 60                	je     80100fe8 <fileread+0x78>
80100f88:	8b 03                	mov    (%ebx),%eax
80100f8a:	83 f8 01             	cmp    $0x1,%eax
80100f8d:	74 41                	je     80100fd0 <fileread+0x60>
80100f8f:	83 f8 02             	cmp    $0x2,%eax
80100f92:	75 5b                	jne    80100fef <fileread+0x7f>
80100f94:	83 ec 0c             	sub    $0xc,%esp
80100f97:	ff 73 10             	pushl  0x10(%ebx)
80100f9a:	e8 01 07 00 00       	call   801016a0 <ilock>
80100f9f:	57                   	push   %edi
80100fa0:	ff 73 14             	pushl  0x14(%ebx)
80100fa3:	56                   	push   %esi
80100fa4:	ff 73 10             	pushl  0x10(%ebx)
80100fa7:	e8 d4 09 00 00       	call   80101980 <readi>
80100fac:	83 c4 20             	add    $0x20,%esp
80100faf:	85 c0                	test   %eax,%eax
80100fb1:	89 c6                	mov    %eax,%esi
80100fb3:	7e 03                	jle    80100fb8 <fileread+0x48>
80100fb5:	01 43 14             	add    %eax,0x14(%ebx)
80100fb8:	83 ec 0c             	sub    $0xc,%esp
80100fbb:	ff 73 10             	pushl  0x10(%ebx)
80100fbe:	e8 bd 07 00 00       	call   80101780 <iunlock>
80100fc3:	83 c4 10             	add    $0x10,%esp
80100fc6:	89 f0                	mov    %esi,%eax
80100fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fcb:	5b                   	pop    %ebx
80100fcc:	5e                   	pop    %esi
80100fcd:	5f                   	pop    %edi
80100fce:	5d                   	pop    %ebp
80100fcf:	c3                   	ret    
80100fd0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fd3:	89 45 08             	mov    %eax,0x8(%ebp)
80100fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd9:	5b                   	pop    %ebx
80100fda:	5e                   	pop    %esi
80100fdb:	5f                   	pop    %edi
80100fdc:	5d                   	pop    %ebp
80100fdd:	e9 2e 25 00 00       	jmp    80103510 <piperead>
80100fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fed:	eb d9                	jmp    80100fc8 <fileread+0x58>
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	68 66 74 10 80       	push   $0x80107466
80100ff7:	e8 94 f3 ff ff       	call   80100390 <panic>
80100ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101000 <filewrite>:
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 1c             	sub    $0x1c,%esp
80101009:	8b 75 08             	mov    0x8(%ebp),%esi
8010100c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010100f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80101013:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101016:	8b 45 10             	mov    0x10(%ebp),%eax
80101019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010101c:	0f 84 aa 00 00 00    	je     801010cc <filewrite+0xcc>
80101022:	8b 06                	mov    (%esi),%eax
80101024:	83 f8 01             	cmp    $0x1,%eax
80101027:	0f 84 c2 00 00 00    	je     801010ef <filewrite+0xef>
8010102d:	83 f8 02             	cmp    $0x2,%eax
80101030:	0f 85 d8 00 00 00    	jne    8010110e <filewrite+0x10e>
80101036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101039:	31 ff                	xor    %edi,%edi
8010103b:	85 c0                	test   %eax,%eax
8010103d:	7f 34                	jg     80101073 <filewrite+0x73>
8010103f:	e9 9c 00 00 00       	jmp    801010e0 <filewrite+0xe0>
80101044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101048:	01 46 14             	add    %eax,0x14(%esi)
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
80101051:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101054:	e8 27 07 00 00       	call   80101780 <iunlock>
80101059:	e8 b2 1b 00 00       	call   80102c10 <end_op>
8010105e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101061:	83 c4 10             	add    $0x10,%esp
80101064:	39 d8                	cmp    %ebx,%eax
80101066:	0f 85 95 00 00 00    	jne    80101101 <filewrite+0x101>
8010106c:	01 c7                	add    %eax,%edi
8010106e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101071:	7e 6d                	jle    801010e0 <filewrite+0xe0>
80101073:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101076:	b8 00 06 00 00       	mov    $0x600,%eax
8010107b:	29 fb                	sub    %edi,%ebx
8010107d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101083:	0f 4f d8             	cmovg  %eax,%ebx
80101086:	e8 15 1b 00 00       	call   80102ba0 <begin_op>
8010108b:	83 ec 0c             	sub    $0xc,%esp
8010108e:	ff 76 10             	pushl  0x10(%esi)
80101091:	e8 0a 06 00 00       	call   801016a0 <ilock>
80101096:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101099:	53                   	push   %ebx
8010109a:	ff 76 14             	pushl  0x14(%esi)
8010109d:	01 f8                	add    %edi,%eax
8010109f:	50                   	push   %eax
801010a0:	ff 76 10             	pushl  0x10(%esi)
801010a3:	e8 d8 09 00 00       	call   80101a80 <writei>
801010a8:	83 c4 20             	add    $0x20,%esp
801010ab:	85 c0                	test   %eax,%eax
801010ad:	7f 99                	jg     80101048 <filewrite+0x48>
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	ff 76 10             	pushl  0x10(%esi)
801010b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010b8:	e8 c3 06 00 00       	call   80101780 <iunlock>
801010bd:	e8 4e 1b 00 00       	call   80102c10 <end_op>
801010c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c5:	83 c4 10             	add    $0x10,%esp
801010c8:	85 c0                	test   %eax,%eax
801010ca:	74 98                	je     80101064 <filewrite+0x64>
801010cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010d4:	5b                   	pop    %ebx
801010d5:	5e                   	pop    %esi
801010d6:	5f                   	pop    %edi
801010d7:	5d                   	pop    %ebp
801010d8:	c3                   	ret    
801010d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010e0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010e3:	75 e7                	jne    801010cc <filewrite+0xcc>
801010e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e8:	89 f8                	mov    %edi,%eax
801010ea:	5b                   	pop    %ebx
801010eb:	5e                   	pop    %esi
801010ec:	5f                   	pop    %edi
801010ed:	5d                   	pop    %ebp
801010ee:	c3                   	ret    
801010ef:	8b 46 0c             	mov    0xc(%esi),%eax
801010f2:	89 45 08             	mov    %eax,0x8(%ebp)
801010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f8:	5b                   	pop    %ebx
801010f9:	5e                   	pop    %esi
801010fa:	5f                   	pop    %edi
801010fb:	5d                   	pop    %ebp
801010fc:	e9 ff 22 00 00       	jmp    80103400 <pipewrite>
80101101:	83 ec 0c             	sub    $0xc,%esp
80101104:	68 6f 74 10 80       	push   $0x8010746f
80101109:	e8 82 f2 ff ff       	call   80100390 <panic>
8010110e:	83 ec 0c             	sub    $0xc,%esp
80101111:	68 75 74 10 80       	push   $0x80107475
80101116:	e8 75 f2 ff ff       	call   80100390 <panic>
8010111b:	66 90                	xchg   %ax,%ax
8010111d:	66 90                	xchg   %ax,%ax
8010111f:	90                   	nop

80101120 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101129:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010112f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101132:	85 c9                	test   %ecx,%ecx
80101134:	0f 84 87 00 00 00    	je     801011c1 <balloc+0xa1>
8010113a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101141:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101144:	83 ec 08             	sub    $0x8,%esp
80101147:	89 f0                	mov    %esi,%eax
80101149:	c1 f8 0c             	sar    $0xc,%eax
8010114c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101152:	50                   	push   %eax
80101153:	ff 75 d8             	pushl  -0x28(%ebp)
80101156:	e8 75 ef ff ff       	call   801000d0 <bread>
8010115b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010115e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101163:	83 c4 10             	add    $0x10,%esp
80101166:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101169:	31 c0                	xor    %eax,%eax
8010116b:	eb 2f                	jmp    8010119c <balloc+0x7c>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101170:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101172:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101175:	bb 01 00 00 00       	mov    $0x1,%ebx
8010117a:	83 e1 07             	and    $0x7,%ecx
8010117d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010117f:	89 c1                	mov    %eax,%ecx
80101181:	c1 f9 03             	sar    $0x3,%ecx
80101184:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101189:	85 df                	test   %ebx,%edi
8010118b:	89 fa                	mov    %edi,%edx
8010118d:	74 41                	je     801011d0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010118f:	83 c0 01             	add    $0x1,%eax
80101192:	83 c6 01             	add    $0x1,%esi
80101195:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010119a:	74 05                	je     801011a1 <balloc+0x81>
8010119c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010119f:	77 cf                	ja     80101170 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011a1:	83 ec 0c             	sub    $0xc,%esp
801011a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011a7:	e8 34 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011ac:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011bf:	77 80                	ja     80101141 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	68 7f 74 10 80       	push   $0x8010747f
801011c9:	e8 c2 f1 ff ff       	call   80100390 <panic>
801011ce:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011d3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011d6:	09 da                	or     %ebx,%edx
801011d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011dc:	57                   	push   %edi
801011dd:	e8 9e 1b 00 00       	call   80102d80 <log_write>
        brelse(bp);
801011e2:	89 3c 24             	mov    %edi,(%esp)
801011e5:	e8 f6 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011ea:	58                   	pop    %eax
801011eb:	5a                   	pop    %edx
801011ec:	56                   	push   %esi
801011ed:	ff 75 d8             	pushl  -0x28(%ebp)
801011f0:	e8 db ee ff ff       	call   801000d0 <bread>
801011f5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011fa:	83 c4 0c             	add    $0xc,%esp
801011fd:	68 00 02 00 00       	push   $0x200
80101202:	6a 00                	push   $0x0
80101204:	50                   	push   %eax
80101205:	e8 06 37 00 00       	call   80104910 <memset>
  log_write(bp);
8010120a:	89 1c 24             	mov    %ebx,(%esp)
8010120d:	e8 6e 1b 00 00       	call   80102d80 <log_write>
  brelse(bp);
80101212:	89 1c 24             	mov    %ebx,(%esp)
80101215:	e8 c6 ef ff ff       	call   801001e0 <brelse>
}
8010121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121d:	89 f0                	mov    %esi,%eax
8010121f:	5b                   	pop    %ebx
80101220:	5e                   	pop    %esi
80101221:	5f                   	pop    %edi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
80101224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010122a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101230 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101238:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010123f:	83 ec 28             	sub    $0x28,%esp
80101242:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101245:	68 e0 09 11 80       	push   $0x801109e0
8010124a:	e8 a1 35 00 00       	call   801047f0 <acquire>
8010124f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101252:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101255:	eb 17                	jmp    8010126e <iget+0x3e>
80101257:	89 f6                	mov    %esi,%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101260:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101266:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010126c:	73 22                	jae    80101290 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010126e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101271:	85 c9                	test   %ecx,%ecx
80101273:	7e 04                	jle    80101279 <iget+0x49>
80101275:	39 3b                	cmp    %edi,(%ebx)
80101277:	74 4f                	je     801012c8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101279:	85 f6                	test   %esi,%esi
8010127b:	75 e3                	jne    80101260 <iget+0x30>
8010127d:	85 c9                	test   %ecx,%ecx
8010127f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101282:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101288:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010128e:	72 de                	jb     8010126e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 5b                	je     801012ef <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101294:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101297:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101299:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010129c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012a3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012aa:	68 e0 09 11 80       	push   $0x801109e0
801012af:	e8 fc 35 00 00       	call   801048b0 <release>

  return ip;
801012b4:	83 c4 10             	add    $0x10,%esp
}
801012b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ba:	89 f0                	mov    %esi,%eax
801012bc:	5b                   	pop    %ebx
801012bd:	5e                   	pop    %esi
801012be:	5f                   	pop    %edi
801012bf:	5d                   	pop    %ebp
801012c0:	c3                   	ret    
801012c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012cb:	75 ac                	jne    80101279 <iget+0x49>
      release(&icache.lock);
801012cd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012d0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012d3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012d5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801012da:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012dd:	e8 ce 35 00 00       	call   801048b0 <release>
      return ip;
801012e2:	83 c4 10             	add    $0x10,%esp
}
801012e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e8:	89 f0                	mov    %esi,%eax
801012ea:	5b                   	pop    %ebx
801012eb:	5e                   	pop    %esi
801012ec:	5f                   	pop    %edi
801012ed:	5d                   	pop    %ebp
801012ee:	c3                   	ret    
    panic("iget: no inodes");
801012ef:	83 ec 0c             	sub    $0xc,%esp
801012f2:	68 95 74 10 80       	push   $0x80107495
801012f7:	e8 94 f0 ff ff       	call   80100390 <panic>
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101300 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	89 c6                	mov    %eax,%esi
80101308:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010130b:	83 fa 0b             	cmp    $0xb,%edx
8010130e:	77 18                	ja     80101328 <bmap+0x28>
80101310:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101313:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101316:	85 db                	test   %ebx,%ebx
80101318:	74 76                	je     80101390 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010131a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131d:	89 d8                	mov    %ebx,%eax
8010131f:	5b                   	pop    %ebx
80101320:	5e                   	pop    %esi
80101321:	5f                   	pop    %edi
80101322:	5d                   	pop    %ebp
80101323:	c3                   	ret    
80101324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101328:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010132b:	83 fb 7f             	cmp    $0x7f,%ebx
8010132e:	0f 87 90 00 00 00    	ja     801013c4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101334:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010133a:	8b 00                	mov    (%eax),%eax
8010133c:	85 d2                	test   %edx,%edx
8010133e:	74 70                	je     801013b0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101340:	83 ec 08             	sub    $0x8,%esp
80101343:	52                   	push   %edx
80101344:	50                   	push   %eax
80101345:	e8 86 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010134a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010134e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101351:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101353:	8b 1a                	mov    (%edx),%ebx
80101355:	85 db                	test   %ebx,%ebx
80101357:	75 1d                	jne    80101376 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101359:	8b 06                	mov    (%esi),%eax
8010135b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010135e:	e8 bd fd ff ff       	call   80101120 <balloc>
80101363:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101369:	89 c3                	mov    %eax,%ebx
8010136b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010136d:	57                   	push   %edi
8010136e:	e8 0d 1a 00 00       	call   80102d80 <log_write>
80101373:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101376:	83 ec 0c             	sub    $0xc,%esp
80101379:	57                   	push   %edi
8010137a:	e8 61 ee ff ff       	call   801001e0 <brelse>
8010137f:	83 c4 10             	add    $0x10,%esp
}
80101382:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101385:	89 d8                	mov    %ebx,%eax
80101387:	5b                   	pop    %ebx
80101388:	5e                   	pop    %esi
80101389:	5f                   	pop    %edi
8010138a:	5d                   	pop    %ebp
8010138b:	c3                   	ret    
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101390:	8b 00                	mov    (%eax),%eax
80101392:	e8 89 fd ff ff       	call   80101120 <balloc>
80101397:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010139d:	89 c3                	mov    %eax,%ebx
}
8010139f:	89 d8                	mov    %ebx,%eax
801013a1:	5b                   	pop    %ebx
801013a2:	5e                   	pop    %esi
801013a3:	5f                   	pop    %edi
801013a4:	5d                   	pop    %ebp
801013a5:	c3                   	ret    
801013a6:	8d 76 00             	lea    0x0(%esi),%esi
801013a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013b0:	e8 6b fd ff ff       	call   80101120 <balloc>
801013b5:	89 c2                	mov    %eax,%edx
801013b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013bd:	8b 06                	mov    (%esi),%eax
801013bf:	e9 7c ff ff ff       	jmp    80101340 <bmap+0x40>
  panic("bmap: out of range");
801013c4:	83 ec 0c             	sub    $0xc,%esp
801013c7:	68 a5 74 10 80       	push   $0x801074a5
801013cc:	e8 bf ef ff ff       	call   80100390 <panic>
801013d1:	eb 0d                	jmp    801013e0 <readsb>
801013d3:	90                   	nop
801013d4:	90                   	nop
801013d5:	90                   	nop
801013d6:	90                   	nop
801013d7:	90                   	nop
801013d8:	90                   	nop
801013d9:	90                   	nop
801013da:	90                   	nop
801013db:	90                   	nop
801013dc:	90                   	nop
801013dd:	90                   	nop
801013de:	90                   	nop
801013df:	90                   	nop

801013e0 <readsb>:
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	56                   	push   %esi
801013e4:	53                   	push   %ebx
801013e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013e8:	83 ec 08             	sub    $0x8,%esp
801013eb:	6a 01                	push   $0x1
801013ed:	ff 75 08             	pushl  0x8(%ebp)
801013f0:	e8 db ec ff ff       	call   801000d0 <bread>
801013f5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013fa:	83 c4 0c             	add    $0xc,%esp
801013fd:	6a 1c                	push   $0x1c
801013ff:	50                   	push   %eax
80101400:	56                   	push   %esi
80101401:	e8 ba 35 00 00       	call   801049c0 <memmove>
  brelse(bp);
80101406:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101409:	83 c4 10             	add    $0x10,%esp
}
8010140c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010140f:	5b                   	pop    %ebx
80101410:	5e                   	pop    %esi
80101411:	5d                   	pop    %ebp
  brelse(bp);
80101412:	e9 c9 ed ff ff       	jmp    801001e0 <brelse>
80101417:	89 f6                	mov    %esi,%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	89 d3                	mov    %edx,%ebx
80101427:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101429:	83 ec 08             	sub    $0x8,%esp
8010142c:	68 c0 09 11 80       	push   $0x801109c0
80101431:	50                   	push   %eax
80101432:	e8 a9 ff ff ff       	call   801013e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101437:	58                   	pop    %eax
80101438:	5a                   	pop    %edx
80101439:	89 da                	mov    %ebx,%edx
8010143b:	c1 ea 0c             	shr    $0xc,%edx
8010143e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101444:	52                   	push   %edx
80101445:	56                   	push   %esi
80101446:	e8 85 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010144b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010144d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101450:	ba 01 00 00 00       	mov    $0x1,%edx
80101455:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101458:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010145e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101461:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101463:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101468:	85 d1                	test   %edx,%ecx
8010146a:	74 25                	je     80101491 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010146c:	f7 d2                	not    %edx
8010146e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101470:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101473:	21 ca                	and    %ecx,%edx
80101475:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101479:	56                   	push   %esi
8010147a:	e8 01 19 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010147f:	89 34 24             	mov    %esi,(%esp)
80101482:	e8 59 ed ff ff       	call   801001e0 <brelse>
}
80101487:	83 c4 10             	add    $0x10,%esp
8010148a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148d:	5b                   	pop    %ebx
8010148e:	5e                   	pop    %esi
8010148f:	5d                   	pop    %ebp
80101490:	c3                   	ret    
    panic("freeing free block");
80101491:	83 ec 0c             	sub    $0xc,%esp
80101494:	68 b8 74 10 80       	push   $0x801074b8
80101499:	e8 f2 ee ff ff       	call   80100390 <panic>
8010149e:	66 90                	xchg   %ax,%ax

801014a0 <iinit>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014a9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014ac:	68 cb 74 10 80       	push   $0x801074cb
801014b1:	68 e0 09 11 80       	push   $0x801109e0
801014b6:	e8 f5 31 00 00       	call   801046b0 <initlock>
801014bb:	83 c4 10             	add    $0x10,%esp
801014be:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	83 ec 08             	sub    $0x8,%esp
801014c3:	68 d2 74 10 80       	push   $0x801074d2
801014c8:	53                   	push   %ebx
801014c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014cf:	e8 ac 30 00 00       	call   80104580 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014d4:	83 c4 10             	add    $0x10,%esp
801014d7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014dd:	75 e1                	jne    801014c0 <iinit+0x20>
  readsb(dev, &sb);
801014df:	83 ec 08             	sub    $0x8,%esp
801014e2:	68 c0 09 11 80       	push   $0x801109c0
801014e7:	ff 75 08             	pushl  0x8(%ebp)
801014ea:	e8 f1 fe ff ff       	call   801013e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ef:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014f5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014fb:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101501:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101507:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010150d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101513:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101519:	68 38 75 10 80       	push   $0x80107538
8010151e:	e8 3d f1 ff ff       	call   80100660 <cprintf>
}
80101523:	83 c4 30             	add    $0x30,%esp
80101526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101529:	c9                   	leave  
8010152a:	c3                   	ret    
8010152b:	90                   	nop
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101530 <ialloc>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101540:	8b 45 0c             	mov    0xc(%ebp),%eax
80101543:	8b 75 08             	mov    0x8(%ebp),%esi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 91 00 00 00    	jbe    801015e0 <ialloc+0xb0>
8010154f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101554:	eb 21                	jmp    80101577 <ialloc+0x47>
80101556:	8d 76 00             	lea    0x0(%esi),%esi
80101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101560:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101566:	57                   	push   %edi
80101567:	e8 74 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010156c:	83 c4 10             	add    $0x10,%esp
8010156f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101575:	76 69                	jbe    801015e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101577:	89 d8                	mov    %ebx,%eax
80101579:	83 ec 08             	sub    $0x8,%esp
8010157c:	c1 e8 03             	shr    $0x3,%eax
8010157f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101585:	50                   	push   %eax
80101586:	56                   	push   %esi
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101590:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101593:	83 e0 07             	and    $0x7,%eax
80101596:	c1 e0 06             	shl    $0x6,%eax
80101599:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015a1:	75 bd                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a3:	83 ec 04             	sub    $0x4,%esp
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	6a 40                	push   $0x40
801015ab:	6a 00                	push   $0x0
801015ad:	51                   	push   %ecx
801015ae:	e8 5d 33 00 00       	call   80104910 <memset>
      dip->type = type;
801015b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015bd:	89 3c 24             	mov    %edi,(%esp)
801015c0:	e8 bb 17 00 00       	call   80102d80 <log_write>
      brelse(bp);
801015c5:	89 3c 24             	mov    %edi,(%esp)
801015c8:	e8 13 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015cd:	83 c4 10             	add    $0x10,%esp
}
801015d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015d3:	89 da                	mov    %ebx,%edx
801015d5:	89 f0                	mov    %esi,%eax
}
801015d7:	5b                   	pop    %ebx
801015d8:	5e                   	pop    %esi
801015d9:	5f                   	pop    %edi
801015da:	5d                   	pop    %ebp
      return iget(dev, inum);
801015db:	e9 50 fc ff ff       	jmp    80101230 <iget>
  panic("ialloc: no inodes");
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	68 d8 74 10 80       	push   $0x801074d8
801015e8:	e8 a3 ed ff ff       	call   80100390 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f8:	83 ec 08             	sub    $0x8,%esp
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010160a:	50                   	push   %eax
8010160b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010160e:	e8 bd ea ff ff       	call   801000d0 <bread>
80101613:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101615:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101618:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010161f:	83 e0 07             	and    $0x7,%eax
80101622:	c1 e0 06             	shl    $0x6,%eax
80101625:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101629:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010162c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101630:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101633:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101637:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010163b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010163f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101643:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101647:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010164a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164d:	6a 34                	push   $0x34
8010164f:	53                   	push   %ebx
80101650:	50                   	push   %eax
80101651:	e8 6a 33 00 00       	call   801049c0 <memmove>
  log_write(bp);
80101656:	89 34 24             	mov    %esi,(%esp)
80101659:	e8 22 17 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010165e:	89 75 08             	mov    %esi,0x8(%ebp)
80101661:	83 c4 10             	add    $0x10,%esp
}
80101664:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101667:	5b                   	pop    %ebx
80101668:	5e                   	pop    %esi
80101669:	5d                   	pop    %ebp
  brelse(bp);
8010166a:	e9 71 eb ff ff       	jmp    801001e0 <brelse>
8010166f:	90                   	nop

80101670 <idup>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	83 ec 10             	sub    $0x10,%esp
80101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010167a:	68 e0 09 11 80       	push   $0x801109e0
8010167f:	e8 6c 31 00 00       	call   801047f0 <acquire>
  ip->ref++;
80101684:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101688:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010168f:	e8 1c 32 00 00       	call   801048b0 <release>
}
80101694:	89 d8                	mov    %ebx,%eax
80101696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101699:	c9                   	leave  
8010169a:	c3                   	ret    
8010169b:	90                   	nop
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <ilock>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016a8:	85 db                	test   %ebx,%ebx
801016aa:	0f 84 b7 00 00 00    	je     80101767 <ilock+0xc7>
801016b0:	8b 53 08             	mov    0x8(%ebx),%edx
801016b3:	85 d2                	test   %edx,%edx
801016b5:	0f 8e ac 00 00 00    	jle    80101767 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016bb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016be:	83 ec 0c             	sub    $0xc,%esp
801016c1:	50                   	push   %eax
801016c2:	e8 f9 2e 00 00       	call   801045c0 <acquiresleep>
  if(ip->valid == 0){
801016c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ca:	83 c4 10             	add    $0x10,%esp
801016cd:	85 c0                	test   %eax,%eax
801016cf:	74 0f                	je     801016e0 <ilock+0x40>
}
801016d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d4:	5b                   	pop    %ebx
801016d5:	5e                   	pop    %esi
801016d6:	5d                   	pop    %ebp
801016d7:	c3                   	ret    
801016d8:	90                   	nop
801016d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e0:	8b 43 04             	mov    0x4(%ebx),%eax
801016e3:	83 ec 08             	sub    $0x8,%esp
801016e6:	c1 e8 03             	shr    $0x3,%eax
801016e9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ef:	50                   	push   %eax
801016f0:	ff 33                	pushl  (%ebx)
801016f2:	e8 d9 e9 ff ff       	call   801000d0 <bread>
801016f7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101709:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010170f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101713:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101717:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010171b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010171f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101723:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101727:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010172b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010172e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101731:	6a 34                	push   $0x34
80101733:	50                   	push   %eax
80101734:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101737:	50                   	push   %eax
80101738:	e8 83 32 00 00       	call   801049c0 <memmove>
    brelse(bp);
8010173d:	89 34 24             	mov    %esi,(%esp)
80101740:	e8 9b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101745:	83 c4 10             	add    $0x10,%esp
80101748:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010174d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101754:	0f 85 77 ff ff ff    	jne    801016d1 <ilock+0x31>
      panic("ilock: no type");
8010175a:	83 ec 0c             	sub    $0xc,%esp
8010175d:	68 f0 74 10 80       	push   $0x801074f0
80101762:	e8 29 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101767:	83 ec 0c             	sub    $0xc,%esp
8010176a:	68 ea 74 10 80       	push   $0x801074ea
8010176f:	e8 1c ec ff ff       	call   80100390 <panic>
80101774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010177a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101780 <iunlock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	74 28                	je     801017b4 <iunlock+0x34>
8010178c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	56                   	push   %esi
80101793:	e8 c8 2e 00 00       	call   80104660 <holdingsleep>
80101798:	83 c4 10             	add    $0x10,%esp
8010179b:	85 c0                	test   %eax,%eax
8010179d:	74 15                	je     801017b4 <iunlock+0x34>
8010179f:	8b 43 08             	mov    0x8(%ebx),%eax
801017a2:	85 c0                	test   %eax,%eax
801017a4:	7e 0e                	jle    801017b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017ac:	5b                   	pop    %ebx
801017ad:	5e                   	pop    %esi
801017ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017af:	e9 6c 2e 00 00       	jmp    80104620 <releasesleep>
    panic("iunlock");
801017b4:	83 ec 0c             	sub    $0xc,%esp
801017b7:	68 ff 74 10 80       	push   $0x801074ff
801017bc:	e8 cf eb ff ff       	call   80100390 <panic>
801017c1:	eb 0d                	jmp    801017d0 <iput>
801017c3:	90                   	nop
801017c4:	90                   	nop
801017c5:	90                   	nop
801017c6:	90                   	nop
801017c7:	90                   	nop
801017c8:	90                   	nop
801017c9:	90                   	nop
801017ca:	90                   	nop
801017cb:	90                   	nop
801017cc:	90                   	nop
801017cd:	90                   	nop
801017ce:	90                   	nop
801017cf:	90                   	nop

801017d0 <iput>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 28             	sub    $0x28,%esp
801017d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017df:	57                   	push   %edi
801017e0:	e8 db 2d 00 00       	call   801045c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	85 d2                	test   %edx,%edx
801017ed:	74 07                	je     801017f6 <iput+0x26>
801017ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017f4:	74 32                	je     80101828 <iput+0x58>
  releasesleep(&ip->lock);
801017f6:	83 ec 0c             	sub    $0xc,%esp
801017f9:	57                   	push   %edi
801017fa:	e8 21 2e 00 00       	call   80104620 <releasesleep>
  acquire(&icache.lock);
801017ff:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101806:	e8 e5 2f 00 00       	call   801047f0 <acquire>
  ip->ref--;
8010180b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010180f:	83 c4 10             	add    $0x10,%esp
80101812:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5f                   	pop    %edi
8010181f:	5d                   	pop    %ebp
  release(&icache.lock);
80101820:	e9 8b 30 00 00       	jmp    801048b0 <release>
80101825:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101828:	83 ec 0c             	sub    $0xc,%esp
8010182b:	68 e0 09 11 80       	push   $0x801109e0
80101830:	e8 bb 2f 00 00       	call   801047f0 <acquire>
    int r = ip->ref;
80101835:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101838:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010183f:	e8 6c 30 00 00       	call   801048b0 <release>
    if(r == 1){
80101844:	83 c4 10             	add    $0x10,%esp
80101847:	83 fe 01             	cmp    $0x1,%esi
8010184a:	75 aa                	jne    801017f6 <iput+0x26>
8010184c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101852:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101855:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x97>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fe                	cmp    %edi,%esi
80101865:	74 19                	je     80101880 <iput+0xb0>
    if(ip->addrs[i]){
80101867:	8b 16                	mov    (%esi),%edx
80101869:	85 d2                	test   %edx,%edx
8010186b:	74 f3                	je     80101860 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010186d:	8b 03                	mov    (%ebx),%eax
8010186f:	e8 ac fb ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
80101874:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010187a:	eb e4                	jmp    80101860 <iput+0x90>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 33                	jne    801018c0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010188d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101890:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101897:	53                   	push   %ebx
80101898:	e8 53 fd ff ff       	call   801015f0 <iupdate>
      ip->type = 0;
8010189d:	31 c0                	xor    %eax,%eax
8010189f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018a3:	89 1c 24             	mov    %ebx,(%esp)
801018a6:	e8 45 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
801018ab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018b2:	83 c4 10             	add    $0x10,%esp
801018b5:	e9 3c ff ff ff       	jmp    801017f6 <iput+0x26>
801018ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	83 ec 08             	sub    $0x8,%esp
801018c3:	50                   	push   %eax
801018c4:	ff 33                	pushl  (%ebx)
801018c6:	e8 05 e8 ff ff       	call   801000d0 <bread>
801018cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018d1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018d7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018da:	83 c4 10             	add    $0x10,%esp
801018dd:	89 cf                	mov    %ecx,%edi
801018df:	eb 0e                	jmp    801018ef <iput+0x11f>
801018e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018e8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018eb:	39 fe                	cmp    %edi,%esi
801018ed:	74 0f                	je     801018fe <iput+0x12e>
      if(a[j])
801018ef:	8b 16                	mov    (%esi),%edx
801018f1:	85 d2                	test   %edx,%edx
801018f3:	74 f3                	je     801018e8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018f5:	8b 03                	mov    (%ebx),%eax
801018f7:	e8 24 fb ff ff       	call   80101420 <bfree>
801018fc:	eb ea                	jmp    801018e8 <iput+0x118>
    brelse(bp);
801018fe:	83 ec 0c             	sub    $0xc,%esp
80101901:	ff 75 e4             	pushl  -0x1c(%ebp)
80101904:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101907:	e8 d4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010190c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101912:	8b 03                	mov    (%ebx),%eax
80101914:	e8 07 fb ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101919:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101920:	00 00 00 
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	e9 62 ff ff ff       	jmp    8010188d <iput+0xbd>
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <iunlockput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 10             	sub    $0x10,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010193a:	53                   	push   %ebx
8010193b:	e8 40 fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101940:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101943:	83 c4 10             	add    $0x10,%esp
}
80101946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101949:	c9                   	leave  
  iput(ip);
8010194a:	e9 81 fe ff ff       	jmp    801017d0 <iput>
8010194f:	90                   	nop

80101950 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	8b 55 08             	mov    0x8(%ebp),%edx
80101956:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101959:	8b 0a                	mov    (%edx),%ecx
8010195b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010195e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101961:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101964:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101968:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010196b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010196f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101973:	8b 52 58             	mov    0x58(%edx),%edx
80101976:	89 50 10             	mov    %edx,0x10(%eax)
}
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 1c             	sub    $0x1c,%esp
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010198f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101992:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101997:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010199a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010199d:	8b 75 10             	mov    0x10(%ebp),%esi
801019a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019a3:	0f 84 a7 00 00 00    	je     80101a50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019ac:	8b 40 58             	mov    0x58(%eax),%eax
801019af:	39 c6                	cmp    %eax,%esi
801019b1:	0f 87 ba 00 00 00    	ja     80101a71 <readi+0xf1>
801019b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ba:	89 f9                	mov    %edi,%ecx
801019bc:	01 f1                	add    %esi,%ecx
801019be:	0f 82 ad 00 00 00    	jb     80101a71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019c4:	89 c2                	mov    %eax,%edx
801019c6:	29 f2                	sub    %esi,%edx
801019c8:	39 c8                	cmp    %ecx,%eax
801019ca:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019cd:	31 ff                	xor    %edi,%edi
801019cf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d4:	74 6c                	je     80101a42 <readi+0xc2>
801019d6:	8d 76 00             	lea    0x0(%esi),%esi
801019d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019e3:	89 f2                	mov    %esi,%edx
801019e5:	c1 ea 09             	shr    $0x9,%edx
801019e8:	89 d8                	mov    %ebx,%eax
801019ea:	e8 11 f9 ff ff       	call   80101300 <bmap>
801019ef:	83 ec 08             	sub    $0x8,%esp
801019f2:	50                   	push   %eax
801019f3:	ff 33                	pushl  (%ebx)
801019f5:	e8 d6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019fd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ff:	89 f0                	mov    %esi,%eax
80101a01:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a06:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a0b:	83 c4 0c             	add    $0xc,%esp
80101a0e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a10:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a14:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	29 fb                	sub    %edi,%ebx
80101a19:	39 d9                	cmp    %ebx,%ecx
80101a1b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1e:	53                   	push   %ebx
80101a1f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a20:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a22:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a25:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a27:	e8 94 2f 00 00       	call   801049c0 <memmove>
    brelse(bp);
80101a2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a2f:	89 14 24             	mov    %edx,(%esp)
80101a32:	e8 a9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3a:	83 c4 10             	add    $0x10,%esp
80101a3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a40:	77 9e                	ja     801019e0 <readi+0x60>
  }
  return n;
80101a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5f                   	pop    %edi
80101a4b:	5d                   	pop    %ebp
80101a4c:	c3                   	ret    
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 17                	ja     80101a71 <readi+0xf1>
80101a5a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 0c                	je     80101a71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a6b:	5b                   	pop    %ebx
80101a6c:	5e                   	pop    %esi
80101a6d:	5f                   	pop    %edi
80101a6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a6f:	ff e0                	jmp    *%eax
      return -1;
80101a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a76:	eb cd                	jmp    80101a45 <readi+0xc5>
80101a78:	90                   	nop
80101a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 1c             	sub    $0x1c,%esp
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101aa3:	0f 84 b7 00 00 00    	je     80101b60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aac:	39 70 58             	cmp    %esi,0x58(%eax)
80101aaf:	0f 82 eb 00 00 00    	jb     80101ba0 <writei+0x120>
80101ab5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ab8:	31 d2                	xor    %edx,%edx
80101aba:	89 f8                	mov    %edi,%eax
80101abc:	01 f0                	add    %esi,%eax
80101abe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ac1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ac6:	0f 87 d4 00 00 00    	ja     80101ba0 <writei+0x120>
80101acc:	85 d2                	test   %edx,%edx
80101ace:	0f 85 cc 00 00 00    	jne    80101ba0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad4:	85 ff                	test   %edi,%edi
80101ad6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101add:	74 72                	je     80101b51 <writei+0xd1>
80101adf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ae3:	89 f2                	mov    %esi,%edx
80101ae5:	c1 ea 09             	shr    $0x9,%edx
80101ae8:	89 f8                	mov    %edi,%eax
80101aea:	e8 11 f8 ff ff       	call   80101300 <bmap>
80101aef:	83 ec 08             	sub    $0x8,%esp
80101af2:	50                   	push   %eax
80101af3:	ff 37                	pushl  (%edi)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101afd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b02:	89 f0                	mov    %esi,%eax
80101b04:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b09:	83 c4 0c             	add    $0xc,%esp
80101b0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b11:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b17:	39 d9                	cmp    %ebx,%ecx
80101b19:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b1c:	53                   	push   %ebx
80101b1d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b20:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b22:	50                   	push   %eax
80101b23:	e8 98 2e 00 00       	call   801049c0 <memmove>
    log_write(bp);
80101b28:	89 3c 24             	mov    %edi,(%esp)
80101b2b:	e8 50 12 00 00       	call   80102d80 <log_write>
    brelse(bp);
80101b30:	89 3c 24             	mov    %edi,(%esp)
80101b33:	e8 a8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b3b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b3e:	83 c4 10             	add    $0x10,%esp
80101b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b47:	77 97                	ja     80101ae0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b4f:	77 37                	ja     80101b88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b57:	5b                   	pop    %ebx
80101b58:	5e                   	pop    %esi
80101b59:	5f                   	pop    %edi
80101b5a:	5d                   	pop    %ebp
80101b5b:	c3                   	ret    
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 36                	ja     80101ba0 <writei+0x120>
80101b6a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 2b                	je     80101ba0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b7f:	ff e0                	jmp    *%eax
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b8b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b91:	50                   	push   %eax
80101b92:	e8 59 fa ff ff       	call   801015f0 <iupdate>
80101b97:	83 c4 10             	add    $0x10,%esp
80101b9a:	eb b5                	jmp    80101b51 <writei+0xd1>
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba5:	eb ad                	jmp    80101b54 <writei+0xd4>
80101ba7:	89 f6                	mov    %esi,%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bb6:	6a 0e                	push   $0xe
80101bb8:	ff 75 0c             	pushl  0xc(%ebp)
80101bbb:	ff 75 08             	pushl  0x8(%ebp)
80101bbe:	e8 7d 2e 00 00       	call   80104a40 <strncmp>
}
80101bc3:	c9                   	leave  
80101bc4:	c3                   	ret    
80101bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 1c             	sub    $0x1c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 85 00 00 00    	jne    80101c6c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	74 3e                	je     80101c31 <dirlookup+0x61>
80101bf3:	90                   	nop
80101bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf8:	6a 10                	push   $0x10
80101bfa:	57                   	push   %edi
80101bfb:	56                   	push   %esi
80101bfc:	53                   	push   %ebx
80101bfd:	e8 7e fd ff ff       	call   80101980 <readi>
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	83 f8 10             	cmp    $0x10,%eax
80101c08:	75 55                	jne    80101c5f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c0f:	74 18                	je     80101c29 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c14:	83 ec 04             	sub    $0x4,%esp
80101c17:	6a 0e                	push   $0xe
80101c19:	50                   	push   %eax
80101c1a:	ff 75 0c             	pushl  0xc(%ebp)
80101c1d:	e8 1e 2e 00 00       	call   80104a40 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	85 c0                	test   %eax,%eax
80101c27:	74 17                	je     80101c40 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c29:	83 c7 10             	add    $0x10,%edi
80101c2c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c2f:	72 c7                	jb     80101bf8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c34:	31 c0                	xor    %eax,%eax
}
80101c36:	5b                   	pop    %ebx
80101c37:	5e                   	pop    %esi
80101c38:	5f                   	pop    %edi
80101c39:	5d                   	pop    %ebp
80101c3a:	c3                   	ret    
80101c3b:	90                   	nop
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c40:	8b 45 10             	mov    0x10(%ebp),%eax
80101c43:	85 c0                	test   %eax,%eax
80101c45:	74 05                	je     80101c4c <dirlookup+0x7c>
        *poff = off;
80101c47:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c50:	8b 03                	mov    (%ebx),%eax
80101c52:	e8 d9 f5 ff ff       	call   80101230 <iget>
}
80101c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5a:	5b                   	pop    %ebx
80101c5b:	5e                   	pop    %esi
80101c5c:	5f                   	pop    %edi
80101c5d:	5d                   	pop    %ebp
80101c5e:	c3                   	ret    
      panic("dirlookup read");
80101c5f:	83 ec 0c             	sub    $0xc,%esp
80101c62:	68 19 75 10 80       	push   $0x80107519
80101c67:	e8 24 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c6c:	83 ec 0c             	sub    $0xc,%esp
80101c6f:	68 07 75 10 80       	push   $0x80107507
80101c74:	e8 17 e7 ff ff       	call   80100390 <panic>
80101c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	89 cf                	mov    %ecx,%edi
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c93:	0f 84 67 01 00 00    	je     80101e00 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(mythread()->cwd);
80101c99:	e8 02 1c 00 00       	call   801038a0 <mythread>
  acquire(&icache.lock);
80101c9e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(mythread()->cwd);
80101ca1:	8b 70 20             	mov    0x20(%eax),%esi
  acquire(&icache.lock);
80101ca4:	68 e0 09 11 80       	push   $0x801109e0
80101ca9:	e8 42 2b 00 00       	call   801047f0 <acquire>
  ip->ref++;
80101cae:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb9:	e8 f2 2b 00 00       	call   801048b0 <release>
80101cbe:	83 c4 10             	add    $0x10,%esp
80101cc1:	eb 08                	jmp    80101ccb <namex+0x4b>
80101cc3:	90                   	nop
80101cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cc8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ccb:	0f b6 03             	movzbl (%ebx),%eax
80101cce:	3c 2f                	cmp    $0x2f,%al
80101cd0:	74 f6                	je     80101cc8 <namex+0x48>
  if(*path == 0)
80101cd2:	84 c0                	test   %al,%al
80101cd4:	0f 84 ee 00 00 00    	je     80101dc8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cda:	0f b6 03             	movzbl (%ebx),%eax
80101cdd:	3c 2f                	cmp    $0x2f,%al
80101cdf:	0f 84 b3 00 00 00    	je     80101d98 <namex+0x118>
80101ce5:	84 c0                	test   %al,%al
80101ce7:	89 da                	mov    %ebx,%edx
80101ce9:	75 09                	jne    80101cf4 <namex+0x74>
80101ceb:	e9 a8 00 00 00       	jmp    80101d98 <namex+0x118>
80101cf0:	84 c0                	test   %al,%al
80101cf2:	74 0a                	je     80101cfe <namex+0x7e>
    path++;
80101cf4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cf7:	0f b6 02             	movzbl (%edx),%eax
80101cfa:	3c 2f                	cmp    $0x2f,%al
80101cfc:	75 f2                	jne    80101cf0 <namex+0x70>
80101cfe:	89 d1                	mov    %edx,%ecx
80101d00:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d02:	83 f9 0d             	cmp    $0xd,%ecx
80101d05:	0f 8e 91 00 00 00    	jle    80101d9c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d0b:	83 ec 04             	sub    $0x4,%esp
80101d0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d11:	6a 0e                	push   $0xe
80101d13:	53                   	push   %ebx
80101d14:	57                   	push   %edi
80101d15:	e8 a6 2c 00 00       	call   801049c0 <memmove>
    path++;
80101d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d1d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d20:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d22:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d25:	75 11                	jne    80101d38 <namex+0xb8>
80101d27:	89 f6                	mov    %esi,%esi
80101d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	56                   	push   %esi
80101d3c:	e8 5f f9 ff ff       	call   801016a0 <ilock>
    if(ip->type != T_DIR){
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d49:	0f 85 91 00 00 00    	jne    80101de0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d52:	85 d2                	test   %edx,%edx
80101d54:	74 09                	je     80101d5f <namex+0xdf>
80101d56:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d59:	0f 84 b7 00 00 00    	je     80101e16 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5f:	83 ec 04             	sub    $0x4,%esp
80101d62:	6a 00                	push   $0x0
80101d64:	57                   	push   %edi
80101d65:	56                   	push   %esi
80101d66:	e8 65 fe ff ff       	call   80101bd0 <dirlookup>
80101d6b:	83 c4 10             	add    $0x10,%esp
80101d6e:	85 c0                	test   %eax,%eax
80101d70:	74 6e                	je     80101de0 <namex+0x160>
  iunlock(ip);
80101d72:	83 ec 0c             	sub    $0xc,%esp
80101d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d78:	56                   	push   %esi
80101d79:	e8 02 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	83 c4 10             	add    $0x10,%esp
80101d8c:	89 c6                	mov    %eax,%esi
80101d8e:	e9 38 ff ff ff       	jmp    80101ccb <namex+0x4b>
80101d93:	90                   	nop
80101d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d98:	89 da                	mov    %ebx,%edx
80101d9a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d9c:	83 ec 04             	sub    $0x4,%esp
80101d9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da5:	51                   	push   %ecx
80101da6:	53                   	push   %ebx
80101da7:	57                   	push   %edi
80101da8:	e8 13 2c 00 00       	call   801049c0 <memmove>
    name[len] = 0;
80101dad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db3:	83 c4 10             	add    $0x10,%esp
80101db6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dba:	89 d3                	mov    %edx,%ebx
80101dbc:	e9 61 ff ff ff       	jmp    80101d22 <namex+0xa2>
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dcb:	85 c0                	test   %eax,%eax
80101dcd:	75 5d                	jne    80101e2c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd2:	89 f0                	mov    %esi,%eax
80101dd4:	5b                   	pop    %ebx
80101dd5:	5e                   	pop    %esi
80101dd6:	5f                   	pop    %edi
80101dd7:	5d                   	pop    %ebp
80101dd8:	c3                   	ret    
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101de0:	83 ec 0c             	sub    $0xc,%esp
80101de3:	56                   	push   %esi
80101de4:	e8 97 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101de9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dec:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dee:	e8 dd f9 ff ff       	call   801017d0 <iput>
      return 0;
80101df3:	83 c4 10             	add    $0x10,%esp
}
80101df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df9:	89 f0                	mov    %esi,%eax
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e00:	ba 01 00 00 00       	mov    $0x1,%edx
80101e05:	b8 01 00 00 00       	mov    $0x1,%eax
80101e0a:	e8 21 f4 ff ff       	call   80101230 <iget>
80101e0f:	89 c6                	mov    %eax,%esi
80101e11:	e9 b5 fe ff ff       	jmp    80101ccb <namex+0x4b>
      iunlock(ip);
80101e16:	83 ec 0c             	sub    $0xc,%esp
80101e19:	56                   	push   %esi
80101e1a:	e8 61 f9 ff ff       	call   80101780 <iunlock>
      return ip;
80101e1f:	83 c4 10             	add    $0x10,%esp
}
80101e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e25:	89 f0                	mov    %esi,%eax
80101e27:	5b                   	pop    %ebx
80101e28:	5e                   	pop    %esi
80101e29:	5f                   	pop    %edi
80101e2a:	5d                   	pop    %ebp
80101e2b:	c3                   	ret    
    iput(ip);
80101e2c:	83 ec 0c             	sub    $0xc,%esp
80101e2f:	56                   	push   %esi
    return 0;
80101e30:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e32:	e8 99 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	eb 93                	jmp    80101dcf <namex+0x14f>
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e40 <dirlink>:
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 20             	sub    $0x20,%esp
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e4c:	6a 00                	push   $0x0
80101e4e:	ff 75 0c             	pushl  0xc(%ebp)
80101e51:	53                   	push   %ebx
80101e52:	e8 79 fd ff ff       	call   80101bd0 <dirlookup>
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	75 67                	jne    80101ec5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e61:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e64:	85 ff                	test   %edi,%edi
80101e66:	74 29                	je     80101e91 <dirlink+0x51>
80101e68:	31 ff                	xor    %edi,%edi
80101e6a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e6d:	eb 09                	jmp    80101e78 <dirlink+0x38>
80101e6f:	90                   	nop
80101e70:	83 c7 10             	add    $0x10,%edi
80101e73:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e76:	73 19                	jae    80101e91 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e78:	6a 10                	push   $0x10
80101e7a:	57                   	push   %edi
80101e7b:	56                   	push   %esi
80101e7c:	53                   	push   %ebx
80101e7d:	e8 fe fa ff ff       	call   80101980 <readi>
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	83 f8 10             	cmp    $0x10,%eax
80101e88:	75 4e                	jne    80101ed8 <dirlink+0x98>
    if(de.inum == 0)
80101e8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8f:	75 df                	jne    80101e70 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e94:	83 ec 04             	sub    $0x4,%esp
80101e97:	6a 0e                	push   $0xe
80101e99:	ff 75 0c             	pushl  0xc(%ebp)
80101e9c:	50                   	push   %eax
80101e9d:	e8 0e 2c 00 00       	call   80104ab0 <strncpy>
  de.inum = inum;
80101ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea5:	6a 10                	push   $0x10
80101ea7:	57                   	push   %edi
80101ea8:	56                   	push   %esi
80101ea9:	53                   	push   %ebx
  de.inum = inum;
80101eaa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eae:	e8 cd fb ff ff       	call   80101a80 <writei>
80101eb3:	83 c4 20             	add    $0x20,%esp
80101eb6:	83 f8 10             	cmp    $0x10,%eax
80101eb9:	75 2a                	jne    80101ee5 <dirlink+0xa5>
  return 0;
80101ebb:	31 c0                	xor    %eax,%eax
}
80101ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ec0:	5b                   	pop    %ebx
80101ec1:	5e                   	pop    %esi
80101ec2:	5f                   	pop    %edi
80101ec3:	5d                   	pop    %ebp
80101ec4:	c3                   	ret    
    iput(ip);
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	50                   	push   %eax
80101ec9:	e8 02 f9 ff ff       	call   801017d0 <iput>
    return -1;
80101ece:	83 c4 10             	add    $0x10,%esp
80101ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed6:	eb e5                	jmp    80101ebd <dirlink+0x7d>
      panic("dirlink read");
80101ed8:	83 ec 0c             	sub    $0xc,%esp
80101edb:	68 28 75 10 80       	push   $0x80107528
80101ee0:	e8 ab e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	68 fe 7b 10 80       	push   $0x80107bfe
80101eed:	e8 9e e4 ff ff       	call   80100390 <panic>
80101ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <namei>:

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	57                   	push   %edi
80101f44:	56                   	push   %esi
80101f45:	53                   	push   %ebx
80101f46:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f49:	85 c0                	test   %eax,%eax
80101f4b:	0f 84 b4 00 00 00    	je     80102005 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f51:	8b 58 08             	mov    0x8(%eax),%ebx
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f5c:	0f 87 96 00 00 00    	ja     80101ff8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f62:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f67:	89 f6                	mov    %esi,%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f70:	89 ca                	mov    %ecx,%edx
80101f72:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f73:	83 e0 c0             	and    $0xffffffc0,%eax
80101f76:	3c 40                	cmp    $0x40,%al
80101f78:	75 f6                	jne    80101f70 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f7a:	31 ff                	xor    %edi,%edi
80101f7c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f81:	89 f8                	mov    %edi,%eax
80101f83:	ee                   	out    %al,(%dx)
80101f84:	b8 01 00 00 00       	mov    $0x1,%eax
80101f89:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8e:	ee                   	out    %al,(%dx)
80101f8f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f94:	89 d8                	mov    %ebx,%eax
80101f96:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f97:	89 d8                	mov    %ebx,%eax
80101f99:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f9e:	c1 f8 08             	sar    $0x8,%eax
80101fa1:	ee                   	out    %al,(%dx)
80101fa2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fa7:	89 f8                	mov    %edi,%eax
80101fa9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101faa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fae:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fb3:	c1 e0 04             	shl    $0x4,%eax
80101fb6:	83 e0 10             	and    $0x10,%eax
80101fb9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fbc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fbd:	f6 06 04             	testb  $0x4,(%esi)
80101fc0:	75 16                	jne    80101fd8 <idestart+0x98>
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	89 ca                	mov    %ecx,%edx
80101fc9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcd:	5b                   	pop    %ebx
80101fce:	5e                   	pop    %esi
80101fcf:	5f                   	pop    %edi
80101fd0:	5d                   	pop    %ebp
80101fd1:	c3                   	ret    
80101fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fd8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fdd:	89 ca                	mov    %ecx,%edx
80101fdf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fe0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fe5:	83 c6 5c             	add    $0x5c,%esi
80101fe8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fed:	fc                   	cld    
80101fee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff3:	5b                   	pop    %ebx
80101ff4:	5e                   	pop    %esi
80101ff5:	5f                   	pop    %edi
80101ff6:	5d                   	pop    %ebp
80101ff7:	c3                   	ret    
    panic("incorrect blockno");
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	68 94 75 10 80       	push   $0x80107594
80102000:	e8 8b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	68 8b 75 10 80       	push   $0x8010758b
8010200d:	e8 7e e3 ff ff       	call   80100390 <panic>
80102012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <ideinit>:
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102026:	68 a6 75 10 80       	push   $0x801075a6
8010202b:	68 80 a5 10 80       	push   $0x8010a580
80102030:	e8 7b 26 00 00       	call   801046b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102035:	58                   	pop    %eax
80102036:	a1 20 2d 11 80       	mov    0x80112d20,%eax
8010203b:	5a                   	pop    %edx
8010203c:	83 e8 01             	sub    $0x1,%eax
8010203f:	50                   	push   %eax
80102040:	6a 0e                	push   $0xe
80102042:	e8 a9 02 00 00       	call   801022f0 <ioapicenable>
80102047:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010204a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204f:	90                   	nop
80102050:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102051:	83 e0 c0             	and    $0xffffffc0,%eax
80102054:	3c 40                	cmp    $0x40,%al
80102056:	75 f8                	jne    80102050 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102058:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102062:	ee                   	out    %al,(%dx)
80102063:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102068:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010206d:	eb 06                	jmp    80102075 <ideinit+0x55>
8010206f:	90                   	nop
  for(i=0; i<1000; i++){
80102070:	83 e9 01             	sub    $0x1,%ecx
80102073:	74 0f                	je     80102084 <ideinit+0x64>
80102075:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102076:	84 c0                	test   %al,%al
80102078:	74 f6                	je     80102070 <ideinit+0x50>
      havedisk1 = 1;
8010207a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102081:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102084:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102089:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010208e:	ee                   	out    %al,(%dx)
}
8010208f:	c9                   	leave  
80102090:	c3                   	ret    
80102091:	eb 0d                	jmp    801020a0 <ideintr>
80102093:	90                   	nop
80102094:	90                   	nop
80102095:	90                   	nop
80102096:	90                   	nop
80102097:	90                   	nop
80102098:	90                   	nop
80102099:	90                   	nop
8010209a:	90                   	nop
8010209b:	90                   	nop
8010209c:	90                   	nop
8010209d:	90                   	nop
8010209e:	90                   	nop
8010209f:	90                   	nop

801020a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020a9:	68 80 a5 10 80       	push   $0x8010a580
801020ae:	e8 3d 27 00 00       	call   801047f0 <acquire>

  if((b = idequeue) == 0){
801020b3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020b9:	83 c4 10             	add    $0x10,%esp
801020bc:	85 db                	test   %ebx,%ebx
801020be:	74 67                	je     80102127 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020c0:	8b 43 58             	mov    0x58(%ebx),%eax
801020c3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020c8:	8b 3b                	mov    (%ebx),%edi
801020ca:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020d0:	75 31                	jne    80102103 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020d7:	89 f6                	mov    %esi,%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c6                	mov    %eax,%esi
801020e3:	83 e6 c0             	and    $0xffffffc0,%esi
801020e6:	89 f1                	mov    %esi,%ecx
801020e8:	80 f9 40             	cmp    $0x40,%cl
801020eb:	75 f3                	jne    801020e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020ed:	a8 21                	test   $0x21,%al
801020ef:	75 12                	jne    80102103 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020f1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020f4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fe:	fc                   	cld    
801020ff:	f3 6d                	rep insl (%dx),%es:(%edi)
80102101:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102103:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102106:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102109:	89 f9                	mov    %edi,%ecx
8010210b:	83 c9 02             	or     $0x2,%ecx
8010210e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102110:	53                   	push   %ebx
80102111:	e8 4a 22 00 00       	call   80104360 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102116:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010211b:	83 c4 10             	add    $0x10,%esp
8010211e:	85 c0                	test   %eax,%eax
80102120:	74 05                	je     80102127 <ideintr+0x87>
    idestart(idequeue);
80102122:	e8 19 fe ff ff       	call   80101f40 <idestart>
    release(&idelock);
80102127:	83 ec 0c             	sub    $0xc,%esp
8010212a:	68 80 a5 10 80       	push   $0x8010a580
8010212f:	e8 7c 27 00 00       	call   801048b0 <release>

  release(&idelock);
}
80102134:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102137:	5b                   	pop    %ebx
80102138:	5e                   	pop    %esi
80102139:	5f                   	pop    %edi
8010213a:	5d                   	pop    %ebp
8010213b:	c3                   	ret    
8010213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102140 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	53                   	push   %ebx
80102144:	83 ec 10             	sub    $0x10,%esp
80102147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010214a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010214d:	50                   	push   %eax
8010214e:	e8 0d 25 00 00       	call   80104660 <holdingsleep>
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	85 c0                	test   %eax,%eax
80102158:	0f 84 c6 00 00 00    	je     80102224 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 e0 06             	and    $0x6,%eax
80102163:	83 f8 02             	cmp    $0x2,%eax
80102166:	0f 84 ab 00 00 00    	je     80102217 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010216c:	8b 53 04             	mov    0x4(%ebx),%edx
8010216f:	85 d2                	test   %edx,%edx
80102171:	74 0d                	je     80102180 <iderw+0x40>
80102173:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102178:	85 c0                	test   %eax,%eax
8010217a:	0f 84 b1 00 00 00    	je     80102231 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 80 a5 10 80       	push   $0x8010a580
80102188:	e8 63 26 00 00       	call   801047f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102193:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102196:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	85 d2                	test   %edx,%edx
8010219f:	75 09                	jne    801021aa <iderw+0x6a>
801021a1:	eb 6d                	jmp    80102210 <iderw+0xd0>
801021a3:	90                   	nop
801021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021a8:	89 c2                	mov    %eax,%edx
801021aa:	8b 42 58             	mov    0x58(%edx),%eax
801021ad:	85 c0                	test   %eax,%eax
801021af:	75 f7                	jne    801021a8 <iderw+0x68>
801021b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021b6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021bc:	74 42                	je     80102200 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 e0 06             	and    $0x6,%eax
801021c3:	83 f8 02             	cmp    $0x2,%eax
801021c6:	74 23                	je     801021eb <iderw+0xab>
801021c8:	90                   	nop
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021d0:	83 ec 08             	sub    $0x8,%esp
801021d3:	68 80 a5 10 80       	push   $0x8010a580
801021d8:	53                   	push   %ebx
801021d9:	e8 c2 1c 00 00       	call   80103ea0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 c4 10             	add    $0x10,%esp
801021e3:	83 e0 06             	and    $0x6,%eax
801021e6:	83 f8 02             	cmp    $0x2,%eax
801021e9:	75 e5                	jne    801021d0 <iderw+0x90>
  }


  release(&idelock);
801021eb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021f5:	c9                   	leave  
  release(&idelock);
801021f6:	e9 b5 26 00 00       	jmp    801048b0 <release>
801021fb:	90                   	nop
801021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102200:	89 d8                	mov    %ebx,%eax
80102202:	e8 39 fd ff ff       	call   80101f40 <idestart>
80102207:	eb b5                	jmp    801021be <iderw+0x7e>
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102210:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102215:	eb 9d                	jmp    801021b4 <iderw+0x74>
    panic("iderw: nothing to do");
80102217:	83 ec 0c             	sub    $0xc,%esp
8010221a:	68 c0 75 10 80       	push   $0x801075c0
8010221f:	e8 6c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102224:	83 ec 0c             	sub    $0xc,%esp
80102227:	68 aa 75 10 80       	push   $0x801075aa
8010222c:	e8 5f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102231:	83 ec 0c             	sub    $0xc,%esp
80102234:	68 d5 75 10 80       	push   $0x801075d5
80102239:	e8 52 e1 ff ff       	call   80100390 <panic>
8010223e:	66 90                	xchg   %ax,%ax

80102240 <ioapicinit>:
80102240:	55                   	push   %ebp
80102241:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102248:	00 c0 fe 
8010224b:	89 e5                	mov    %esp,%ebp
8010224d:	56                   	push   %esi
8010224e:	53                   	push   %ebx
8010224f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102256:	00 00 00 
80102259:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010225f:	8b 72 10             	mov    0x10(%edx),%esi
80102262:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80102268:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010226e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80102275:	89 f0                	mov    %esi,%eax
80102277:	c1 e8 10             	shr    $0x10,%eax
8010227a:	0f b6 f0             	movzbl %al,%esi
8010227d:	8b 41 10             	mov    0x10(%ecx),%eax
80102280:	c1 e8 18             	shr    $0x18,%eax
80102283:	39 d0                	cmp    %edx,%eax
80102285:	74 16                	je     8010229d <ioapicinit+0x5d>
80102287:	83 ec 0c             	sub    $0xc,%esp
8010228a:	68 f4 75 10 80       	push   $0x801075f4
8010228f:	e8 cc e3 ff ff       	call   80100660 <cprintf>
80102294:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	83 c6 21             	add    $0x21,%esi
801022a0:	ba 10 00 00 00       	mov    $0x10,%edx
801022a5:	b8 20 00 00 00       	mov    $0x20,%eax
801022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022b0:	89 11                	mov    %edx,(%ecx)
801022b2:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022b8:	89 c3                	mov    %eax,%ebx
801022ba:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801022c0:	83 c0 01             	add    $0x1,%eax
801022c3:	89 59 10             	mov    %ebx,0x10(%ecx)
801022c6:	8d 5a 01             	lea    0x1(%edx),%ebx
801022c9:	83 c2 02             	add    $0x2,%edx
801022cc:	39 f0                	cmp    %esi,%eax
801022ce:	89 19                	mov    %ebx,(%ecx)
801022d0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
801022dd:	75 d1                	jne    801022b0 <ioapicinit+0x70>
801022df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022e2:	5b                   	pop    %ebx
801022e3:	5e                   	pop    %esi
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	8d 76 00             	lea    0x0(%esi),%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022f0 <ioapicenable>:
801022f0:	55                   	push   %ebp
801022f1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022f7:	89 e5                	mov    %esp,%ebp
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	8d 50 20             	lea    0x20(%eax),%edx
801022ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
80102303:	89 01                	mov    %eax,(%ecx)
80102305:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010230b:	83 c0 01             	add    $0x1,%eax
8010230e:	89 51 10             	mov    %edx,0x10(%ecx)
80102311:	8b 55 0c             	mov    0xc(%ebp),%edx
80102314:	89 01                	mov    %eax,(%ecx)
80102316:	a1 34 26 11 80       	mov    0x80112634,%eax
8010231b:	c1 e2 18             	shl    $0x18,%edx
8010231e:	89 50 10             	mov    %edx,0x10(%eax)
80102321:	5d                   	pop    %ebp
80102322:	c3                   	ret    
80102323:	66 90                	xchg   %ax,%ax
80102325:	66 90                	xchg   %ax,%ax
80102327:	66 90                	xchg   %ax,%ax
80102329:	66 90                	xchg   %ax,%ax
8010232b:	66 90                	xchg   %ax,%ax
8010232d:	66 90                	xchg   %ax,%ax
8010232f:	90                   	nop

80102330 <kfree>:
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	53                   	push   %ebx
80102334:	83 ec 04             	sub    $0x4,%esp
80102337:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010233a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102340:	75 70                	jne    801023b2 <kfree+0x82>
80102342:	81 fb c8 34 12 80    	cmp    $0x801234c8,%ebx
80102348:	72 68                	jb     801023b2 <kfree+0x82>
8010234a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102350:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102355:	77 5b                	ja     801023b2 <kfree+0x82>
80102357:	83 ec 04             	sub    $0x4,%esp
8010235a:	68 00 10 00 00       	push   $0x1000
8010235f:	6a 01                	push   $0x1
80102361:	53                   	push   %ebx
80102362:	e8 a9 25 00 00       	call   80104910 <memset>
80102367:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	85 d2                	test   %edx,%edx
80102372:	75 2c                	jne    801023a0 <kfree+0x70>
80102374:	a1 78 26 11 80       	mov    0x80112678,%eax
80102379:	89 03                	mov    %eax,(%ebx)
8010237b:	a1 74 26 11 80       	mov    0x80112674,%eax
80102380:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
80102386:	85 c0                	test   %eax,%eax
80102388:	75 06                	jne    80102390 <kfree+0x60>
8010238a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238d:	c9                   	leave  
8010238e:	c3                   	ret    
8010238f:	90                   	nop
80102390:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
80102397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239a:	c9                   	leave  
8010239b:	e9 10 25 00 00       	jmp    801048b0 <release>
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 40 26 11 80       	push   $0x80112640
801023a8:	e8 43 24 00 00       	call   801047f0 <acquire>
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	eb c2                	jmp    80102374 <kfree+0x44>
801023b2:	83 ec 0c             	sub    $0xc,%esp
801023b5:	68 26 76 10 80       	push   $0x80107626
801023ba:	e8 d1 df ff ff       	call   80100390 <panic>
801023bf:	90                   	nop

801023c0 <freerange>:
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
801023c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801023cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801023d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dd:	39 de                	cmp    %ebx,%esi
801023df:	72 23                	jb     80102404 <freerange+0x44>
801023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ee:	83 ec 0c             	sub    $0xc,%esp
801023f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023f7:	50                   	push   %eax
801023f8:	e8 33 ff ff ff       	call   80102330 <kfree>
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	39 f3                	cmp    %esi,%ebx
80102402:	76 e4                	jbe    801023e8 <freerange+0x28>
80102404:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102407:	5b                   	pop    %ebx
80102408:	5e                   	pop    %esi
80102409:	5d                   	pop    %ebp
8010240a:	c3                   	ret    
8010240b:	90                   	nop
8010240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102410 <kinit1>:
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	8b 75 0c             	mov    0xc(%ebp),%esi
80102418:	83 ec 08             	sub    $0x8,%esp
8010241b:	68 2c 76 10 80       	push   $0x8010762c
80102420:	68 40 26 11 80       	push   $0x80112640
80102425:	e8 86 22 00 00       	call   801046b0 <initlock>
8010242a:	8b 45 08             	mov    0x8(%ebp),%eax
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102437:	00 00 00 
8010243a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102440:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102446:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244c:	39 de                	cmp    %ebx,%esi
8010244e:	72 1c                	jb     8010246c <kinit1+0x5c>
80102450:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102456:	83 ec 0c             	sub    $0xc,%esp
80102459:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245f:	50                   	push   %eax
80102460:	e8 cb fe ff ff       	call   80102330 <kfree>
80102465:	83 c4 10             	add    $0x10,%esp
80102468:	39 de                	cmp    %ebx,%esi
8010246a:	73 e4                	jae    80102450 <kinit1+0x40>
8010246c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010246f:	5b                   	pop    %ebx
80102470:	5e                   	pop    %esi
80102471:	5d                   	pop    %ebp
80102472:	c3                   	ret    
80102473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
80102488:	8b 75 0c             	mov    0xc(%ebp),%esi
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <kinit2+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ae:	83 ec 0c             	sub    $0xc,%esp
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024b7:	50                   	push   %eax
801024b8:	e8 73 fe ff ff       	call   80102330 <kfree>
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 de                	cmp    %ebx,%esi
801024c2:	73 e4                	jae    801024a8 <kinit2+0x28>
801024c4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024cb:	00 00 00 
801024ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d1:	5b                   	pop    %ebx
801024d2:	5e                   	pop    %esi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret    
801024d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024e0 <kalloc>:
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024ec:	85 c0                	test   %eax,%eax
801024ee:	75 30                	jne    80102520 <kalloc+0x40>
801024f0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
801024f6:	85 db                	test   %ebx,%ebx
801024f8:	74 1c                	je     80102516 <kalloc+0x36>
801024fa:	8b 13                	mov    (%ebx),%edx
801024fc:	89 15 78 26 11 80    	mov    %edx,0x80112678
80102502:	85 c0                	test   %eax,%eax
80102504:	74 10                	je     80102516 <kalloc+0x36>
80102506:	83 ec 0c             	sub    $0xc,%esp
80102509:	68 40 26 11 80       	push   $0x80112640
8010250e:	e8 9d 23 00 00       	call   801048b0 <release>
80102513:	83 c4 10             	add    $0x10,%esp
80102516:	89 d8                	mov    %ebx,%eax
80102518:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251b:	c9                   	leave  
8010251c:	c3                   	ret    
8010251d:	8d 76 00             	lea    0x0(%esi),%esi
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 c3 22 00 00       	call   801047f0 <acquire>
8010252d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
80102533:	83 c4 10             	add    $0x10,%esp
80102536:	a1 74 26 11 80       	mov    0x80112674,%eax
8010253b:	85 db                	test   %ebx,%ebx
8010253d:	75 bb                	jne    801024fa <kalloc+0x1a>
8010253f:	eb c1                	jmp    80102502 <kalloc+0x22>
80102541:	66 90                	xchg   %ax,%ax
80102543:	66 90                	xchg   %ax,%ax
80102545:	66 90                	xchg   %ax,%ax
80102547:	66 90                	xchg   %ax,%ax
80102549:	66 90                	xchg   %ax,%ax
8010254b:	66 90                	xchg   %ax,%ax
8010254d:	66 90                	xchg   %ax,%ax
8010254f:	90                   	nop

80102550 <kbdgetc>:
80102550:	55                   	push   %ebp
80102551:	ba 64 00 00 00       	mov    $0x64,%edx
80102556:	89 e5                	mov    %esp,%ebp
80102558:	ec                   	in     (%dx),%al
80102559:	a8 01                	test   $0x1,%al
8010255b:	0f 84 af 00 00 00    	je     80102610 <kbdgetc+0xc0>
80102561:	ba 60 00 00 00       	mov    $0x60,%edx
80102566:	ec                   	in     (%dx),%al
80102567:	0f b6 d0             	movzbl %al,%edx
8010256a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102570:	74 7e                	je     801025f0 <kbdgetc+0xa0>
80102572:	84 c0                	test   %al,%al
80102574:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010257a:	79 24                	jns    801025a0 <kbdgetc+0x50>
8010257c:	f6 c1 40             	test   $0x40,%cl
8010257f:	75 05                	jne    80102586 <kbdgetc+0x36>
80102581:	89 c2                	mov    %eax,%edx
80102583:	83 e2 7f             	and    $0x7f,%edx
80102586:	0f b6 82 60 77 10 80 	movzbl -0x7fef88a0(%edx),%eax
8010258d:	83 c8 40             	or     $0x40,%eax
80102590:	0f b6 c0             	movzbl %al,%eax
80102593:	f7 d0                	not    %eax
80102595:	21 c8                	and    %ecx,%eax
80102597:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
8010259c:	31 c0                	xor    %eax,%eax
8010259e:	5d                   	pop    %ebp
8010259f:	c3                   	ret    
801025a0:	f6 c1 40             	test   $0x40,%cl
801025a3:	74 09                	je     801025ae <kbdgetc+0x5e>
801025a5:	83 c8 80             	or     $0xffffff80,%eax
801025a8:	83 e1 bf             	and    $0xffffffbf,%ecx
801025ab:	0f b6 d0             	movzbl %al,%edx
801025ae:	0f b6 82 60 77 10 80 	movzbl -0x7fef88a0(%edx),%eax
801025b5:	09 c1                	or     %eax,%ecx
801025b7:	0f b6 82 60 76 10 80 	movzbl -0x7fef89a0(%edx),%eax
801025be:	31 c1                	xor    %eax,%ecx
801025c0:	89 c8                	mov    %ecx,%eax
801025c2:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
801025c8:	83 e0 03             	and    $0x3,%eax
801025cb:	83 e1 08             	and    $0x8,%ecx
801025ce:	8b 04 85 40 76 10 80 	mov    -0x7fef89c0(,%eax,4),%eax
801025d5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
801025d9:	74 c3                	je     8010259e <kbdgetc+0x4e>
801025db:	8d 50 9f             	lea    -0x61(%eax),%edx
801025de:	83 fa 19             	cmp    $0x19,%edx
801025e1:	77 1d                	ja     80102600 <kbdgetc+0xb0>
801025e3:	83 e8 20             	sub    $0x20,%eax
801025e6:	5d                   	pop    %ebp
801025e7:	c3                   	ret    
801025e8:	90                   	nop
801025e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025f0:	31 c0                	xor    %eax,%eax
801025f2:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
801025f9:	5d                   	pop    %ebp
801025fa:	c3                   	ret    
801025fb:	90                   	nop
801025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102600:	8d 48 bf             	lea    -0x41(%eax),%ecx
80102603:	8d 50 20             	lea    0x20(%eax),%edx
80102606:	5d                   	pop    %ebp
80102607:	83 f9 19             	cmp    $0x19,%ecx
8010260a:	0f 46 c2             	cmovbe %edx,%eax
8010260d:	c3                   	ret    
8010260e:	66 90                	xchg   %ax,%ax
80102610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102615:	5d                   	pop    %ebp
80102616:	c3                   	ret    
80102617:	89 f6                	mov    %esi,%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kbdintr>:
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 14             	sub    $0x14,%esp
80102626:	68 50 25 10 80       	push   $0x80102550
8010262b:	e8 e0 e1 ff ff       	call   80100810 <consoleintr>
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	c9                   	leave  
80102634:	c3                   	ret    
80102635:	66 90                	xchg   %ax,%ax
80102637:	66 90                	xchg   %ax,%ax
80102639:	66 90                	xchg   %ax,%ax
8010263b:	66 90                	xchg   %ax,%ax
8010263d:	66 90                	xchg   %ax,%ax
8010263f:	90                   	nop

80102640 <lapicinit>:
80102640:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 c8 00 00 00    	je     80102718 <lapicinit+0xd8>
80102650:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102657:	01 00 00 
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
8010265d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102664:	00 00 00 
80102667:	8b 50 20             	mov    0x20(%eax),%edx
8010266a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102671:	00 02 00 
80102674:	8b 50 20             	mov    0x20(%eax),%edx
80102677:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010267e:	96 98 00 
80102681:	8b 50 20             	mov    0x20(%eax),%edx
80102684:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010268b:	00 01 00 
8010268e:	8b 50 20             	mov    0x20(%eax),%edx
80102691:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102698:	00 01 00 
8010269b:	8b 50 20             	mov    0x20(%eax),%edx
8010269e:	8b 50 30             	mov    0x30(%eax),%edx
801026a1:	c1 ea 10             	shr    $0x10,%edx
801026a4:	80 fa 03             	cmp    $0x3,%dl
801026a7:	77 77                	ja     80102720 <lapicinit+0xe0>
801026a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026b0:	00 00 00 
801026b3:	8b 50 20             	mov    0x20(%eax),%edx
801026b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026bd:	00 00 00 
801026c0:	8b 50 20             	mov    0x20(%eax),%edx
801026c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ca:	00 00 00 
801026cd:	8b 50 20             	mov    0x20(%eax),%edx
801026d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d7:	00 00 00 
801026da:	8b 50 20             	mov    0x20(%eax),%edx
801026dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026e4:	00 00 00 
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
801026ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026f1:	85 08 00 
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
801026f7:	89 f6                	mov    %esi,%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102700:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102706:	80 e6 10             	and    $0x10,%dh
80102709:	75 f5                	jne    80102700 <lapicinit+0xc0>
8010270b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102712:	00 00 00 
80102715:	8b 40 20             	mov    0x20(%eax),%eax
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102720:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102727:	00 01 00 
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
8010272d:	e9 77 ff ff ff       	jmp    801026a9 <lapicinit+0x69>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:
80102740:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102745:	55                   	push   %ebp
80102746:	89 e5                	mov    %esp,%ebp
80102748:	85 c0                	test   %eax,%eax
8010274a:	74 0c                	je     80102758 <lapicid+0x18>
8010274c:	8b 40 20             	mov    0x20(%eax),%eax
8010274f:	5d                   	pop    %ebp
80102750:	c1 e8 18             	shr    $0x18,%eax
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102758:	31 c0                	xor    %eax,%eax
8010275a:	5d                   	pop    %ebp
8010275b:	c3                   	ret    
8010275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102760 <lapiceoi>:
80102760:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0d                	je     80102779 <lapiceoi+0x19>
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
80102776:	8b 40 20             	mov    0x20(%eax),%eax
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <microdelay>:
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:
80102790:	55                   	push   %ebp
80102791:	ba 70 00 00 00       	mov    $0x70,%edx
80102796:	b8 0f 00 00 00       	mov    $0xf,%eax
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027a4:	ee                   	out    %al,(%dx)
801027a5:	ba 71 00 00 00       	mov    $0x71,%edx
801027aa:	b8 0a 00 00 00       	mov    $0xa,%eax
801027af:	ee                   	out    %al,(%dx)
801027b0:	31 c0                	xor    %eax,%eax
801027b2:	c1 e3 18             	shl    $0x18,%ebx
801027b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
801027bb:	89 c8                	mov    %ecx,%eax
801027bd:	c1 e9 0c             	shr    $0xc,%ecx
801027c0:	c1 e8 04             	shr    $0x4,%eax
801027c3:	89 da                	mov    %ebx,%edx
801027c5:	80 cd 06             	or     $0x6,%ch
801027c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
801027ce:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
801027d9:	8b 58 20             	mov    0x20(%eax),%ebx
801027dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027e3:	c5 00 00 
801027e6:	8b 58 20             	mov    0x20(%eax),%ebx
801027e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f0:	85 00 00 
801027f3:	8b 58 20             	mov    0x20(%eax),%ebx
801027f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
801027fc:	8b 58 20             	mov    0x20(%eax),%ebx
801027ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
80102805:	8b 58 20             	mov    0x20(%eax),%ebx
80102808:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
80102811:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
80102817:	8b 40 20             	mov    0x20(%eax),%eax
8010281a:	5b                   	pop    %ebx
8010281b:	5d                   	pop    %ebp
8010281c:	c3                   	ret    
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <cmostime>:
80102820:	55                   	push   %ebp
80102821:	ba 70 00 00 00       	mov    $0x70,%edx
80102826:	b8 0b 00 00 00       	mov    $0xb,%eax
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 4c             	sub    $0x4c,%esp
80102833:	ee                   	out    %al,(%dx)
80102834:	ba 71 00 00 00       	mov    $0x71,%edx
80102839:	ec                   	in     (%dx),%al
8010283a:	83 e0 04             	and    $0x4,%eax
8010283d:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102840:	31 db                	xor    %ebx,%ebx
80102842:	88 45 b7             	mov    %al,-0x49(%ebp)
80102845:	bf 70 00 00 00       	mov    $0x70,%edi
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102850:	89 d8                	mov    %ebx,%eax
80102852:	89 fa                	mov    %edi,%edx
80102854:	ee                   	out    %al,(%dx)
80102855:	b9 71 00 00 00       	mov    $0x71,%ecx
8010285a:	89 ca                	mov    %ecx,%edx
8010285c:	ec                   	in     (%dx),%al
8010285d:	0f b6 c0             	movzbl %al,%eax
80102860:	89 fa                	mov    %edi,%edx
80102862:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102865:	b8 02 00 00 00       	mov    $0x2,%eax
8010286a:	ee                   	out    %al,(%dx)
8010286b:	89 ca                	mov    %ecx,%edx
8010286d:	ec                   	in     (%dx),%al
8010286e:	0f b6 c0             	movzbl %al,%eax
80102871:	89 fa                	mov    %edi,%edx
80102873:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102876:	b8 04 00 00 00       	mov    $0x4,%eax
8010287b:	ee                   	out    %al,(%dx)
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
8010287f:	0f b6 c0             	movzbl %al,%eax
80102882:	89 fa                	mov    %edi,%edx
80102884:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102887:	b8 07 00 00 00       	mov    $0x7,%eax
8010288c:	ee                   	out    %al,(%dx)
8010288d:	89 ca                	mov    %ecx,%edx
8010288f:	ec                   	in     (%dx),%al
80102890:	0f b6 c0             	movzbl %al,%eax
80102893:	89 fa                	mov    %edi,%edx
80102895:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102898:	b8 08 00 00 00       	mov    $0x8,%eax
8010289d:	ee                   	out    %al,(%dx)
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
801028a1:	0f b6 c0             	movzbl %al,%eax
801028a4:	89 fa                	mov    %edi,%edx
801028a6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028a9:	b8 09 00 00 00       	mov    $0x9,%eax
801028ae:	ee                   	out    %al,(%dx)
801028af:	89 ca                	mov    %ecx,%edx
801028b1:	ec                   	in     (%dx),%al
801028b2:	0f b6 c0             	movzbl %al,%eax
801028b5:	89 fa                	mov    %edi,%edx
801028b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028ba:	b8 0a 00 00 00       	mov    $0xa,%eax
801028bf:	ee                   	out    %al,(%dx)
801028c0:	89 ca                	mov    %ecx,%edx
801028c2:	ec                   	in     (%dx),%al
801028c3:	84 c0                	test   %al,%al
801028c5:	78 89                	js     80102850 <cmostime+0x30>
801028c7:	89 d8                	mov    %ebx,%eax
801028c9:	89 fa                	mov    %edi,%edx
801028cb:	ee                   	out    %al,(%dx)
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
801028d2:	89 fa                	mov    %edi,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
801028e3:	89 fa                	mov    %edi,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
801028f4:	89 fa                	mov    %edi,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
80102905:	89 fa                	mov    %edi,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
80102916:	89 fa                	mov    %edi,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
80102927:	83 ec 04             	sub    $0x4,%esp
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010292d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	56                   	push   %esi
80102933:	50                   	push   %eax
80102934:	e8 27 20 00 00       	call   80104960 <memcmp>
80102939:	83 c4 10             	add    $0x10,%esp
8010293c:	85 c0                	test   %eax,%eax
8010293e:	0f 85 0c ff ff ff    	jne    80102850 <cmostime+0x30>
80102944:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102948:	75 78                	jne    801029c2 <cmostime+0x1a2>
8010294a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010294d:	89 c2                	mov    %eax,%edx
8010294f:	83 e0 0f             	and    $0xf,%eax
80102952:	c1 ea 04             	shr    $0x4,%edx
80102955:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102958:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295b:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010295e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102961:	89 c2                	mov    %eax,%edx
80102963:	83 e0 0f             	and    $0xf,%eax
80102966:	c1 ea 04             	shr    $0x4,%edx
80102969:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296f:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102972:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102975:	89 c2                	mov    %eax,%edx
80102977:	83 e0 0f             	and    $0xf,%eax
8010297a:	c1 ea 04             	shr    $0x4,%edx
8010297d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102980:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102983:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102986:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102989:	89 c2                	mov    %eax,%edx
8010298b:	83 e0 0f             	and    $0xf,%eax
8010298e:	c1 ea 04             	shr    $0x4,%edx
80102991:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102994:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102997:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010299a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010299d:	89 c2                	mov    %eax,%edx
8010299f:	83 e0 0f             	and    $0xf,%eax
801029a2:	c1 ea 04             	shr    $0x4,%edx
801029a5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
801029ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b1:	89 c2                	mov    %eax,%edx
801029b3:	83 e0 0f             	and    $0xf,%eax
801029b6:	c1 ea 04             	shr    $0x4,%edx
801029b9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
801029c2:	8b 75 08             	mov    0x8(%ebp),%esi
801029c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029c8:	89 06                	mov    %eax,(%esi)
801029ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029cd:	89 46 04             	mov    %eax,0x4(%esi)
801029d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d3:	89 46 08             	mov    %eax,0x8(%esi)
801029d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029d9:	89 46 0c             	mov    %eax,0xc(%esi)
801029dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029df:	89 46 10             	mov    %eax,0x10(%esi)
801029e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e5:	89 46 14             	mov    %eax,0x14(%esi)
801029e8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
801029ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f2:	5b                   	pop    %ebx
801029f3:	5e                   	pop    %esi
801029f4:	5f                   	pop    %edi
801029f5:	5d                   	pop    %ebp
801029f6:	c3                   	ret    
801029f7:	66 90                	xchg   %ax,%ax
801029f9:	66 90                	xchg   %ax,%ax
801029fb:	66 90                	xchg   %ax,%ax
801029fd:	66 90                	xchg   %ax,%ax
801029ff:	90                   	nop

80102a00 <install_trans>:
80102a00:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 85 00 00 00    	jle    80102a93 <install_trans+0x93>
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
80102a14:	31 db                	xor    %ebx,%ebx
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a20:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a44:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a4a:	83 c3 01             	add    $0x1,%ebx
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 57 1f 00 00       	call   801049c0 <memmove>
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	f3 c3                	repz ret 
80102a95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102aa0 <write_head>:
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	53                   	push   %ebx
80102aa4:	83 ec 0c             	sub    $0xc,%esp
80102aa7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102aad:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ab3:	e8 18 d6 ff ff       	call   801000d0 <bread>
80102ab8:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102abe:	83 c4 10             	add    $0x10,%esp
80102ac1:	89 c3                	mov    %eax,%ebx
80102ac3:	85 c9                	test   %ecx,%ecx
80102ac5:	89 48 5c             	mov    %ecx,0x5c(%eax)
80102ac8:	7e 1f                	jle    80102ae9 <write_head+0x49>
80102aca:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ad1:	31 d2                	xor    %edx,%edx
80102ad3:	90                   	nop
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102ade:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ae2:	83 c2 04             	add    $0x4,%edx
80102ae5:	39 c2                	cmp    %eax,%edx
80102ae7:	75 ef                	jne    80102ad8 <write_head+0x38>
80102ae9:	83 ec 0c             	sub    $0xc,%esp
80102aec:	53                   	push   %ebx
80102aed:	e8 ae d6 ff ff       	call   801001a0 <bwrite>
80102af2:	89 1c 24             	mov    %ebx,(%esp)
80102af5:	e8 e6 d6 ff ff       	call   801001e0 <brelse>
80102afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102afd:	c9                   	leave  
80102afe:	c3                   	ret    
80102aff:	90                   	nop

80102b00 <initlog>:
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b0a:	68 60 78 10 80       	push   $0x80107860
80102b0f:	68 80 26 11 80       	push   $0x80112680
80102b14:	e8 97 1b 00 00       	call   801046b0 <initlock>
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 bb e8 ff ff       	call   801013e0 <readsb>
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102b2b:	59                   	pop    %ecx
80102b2c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
80102b32:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
80102b38:	a3 b4 26 11 80       	mov    %eax,0x801126b4
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
80102b45:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 c9                	test   %ecx,%ecx
80102b4d:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b5c:	31 d2                	xor    %edx,%edx
80102b5e:	66 90                	xchg   %ax,%ax
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
80102b6d:	39 da                	cmp    %ebx,%edx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
80102b7f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b86:	00 00 00 
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
80102b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b91:	c9                   	leave  
80102b92:	c3                   	ret    
80102b93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
80102ba6:	68 80 26 11 80       	push   $0x80112680
80102bab:	e8 40 1c 00 00       	call   801047f0 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 80 26 11 80       	push   $0x80112680
80102bc0:	68 80 26 11 80       	push   $0x80112680
80102bc5:	e8 d6 12 00 00       	call   80103ea0 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
80102bcd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
80102bd6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102bdb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
80102bef:	83 ec 0c             	sub    $0xc,%esp
80102bf2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102bf7:	68 80 26 11 80       	push   $0x80112680
80102bfc:	e8 af 1c 00 00       	call   801048b0 <release>
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
80102c19:	68 80 26 11 80       	push   $0x80112680
80102c1e:	e8 cd 1b 00 00       	call   801047f0 <acquire>
80102c23:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c28:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102c2e:	83 c4 10             	add    $0x10,%esp
80102c31:	83 e8 01             	sub    $0x1,%eax
80102c34:	85 db                	test   %ebx,%ebx
80102c36:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102c3b:	0f 85 23 01 00 00    	jne    80102d64 <end_op+0x154>
80102c41:	85 c0                	test   %eax,%eax
80102c43:	0f 85 f7 00 00 00    	jne    80102d40 <end_op+0x130>
80102c49:	83 ec 0c             	sub    $0xc,%esp
80102c4c:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c53:	00 00 00 
80102c56:	31 db                	xor    %ebx,%ebx
80102c58:	68 80 26 11 80       	push   $0x80112680
80102c5d:	e8 4e 1c 00 00       	call   801048b0 <release>
80102c62:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c68:	83 c4 10             	add    $0x10,%esp
80102c6b:	85 c9                	test   %ecx,%ecx
80102c6d:	0f 8e 8a 00 00 00    	jle    80102cfd <end_op+0xed>
80102c73:	90                   	nop
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c78:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c7d:	83 ec 08             	sub    $0x8,%esp
80102c80:	01 d8                	add    %ebx,%eax
80102c82:	83 c0 01             	add    $0x1,%eax
80102c85:	50                   	push   %eax
80102c86:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c8c:	e8 3f d4 ff ff       	call   801000d0 <bread>
80102c91:	89 c6                	mov    %eax,%esi
80102c93:	58                   	pop    %eax
80102c94:	5a                   	pop    %edx
80102c95:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c9c:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ca2:	83 c3 01             	add    $0x1,%ebx
80102ca5:	e8 26 d4 ff ff       	call   801000d0 <bread>
80102caa:	89 c7                	mov    %eax,%edi
80102cac:	8d 40 5c             	lea    0x5c(%eax),%eax
80102caf:	83 c4 0c             	add    $0xc,%esp
80102cb2:	68 00 02 00 00       	push   $0x200
80102cb7:	50                   	push   %eax
80102cb8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cbb:	50                   	push   %eax
80102cbc:	e8 ff 1c 00 00       	call   801049c0 <memmove>
80102cc1:	89 34 24             	mov    %esi,(%esp)
80102cc4:	e8 d7 d4 ff ff       	call   801001a0 <bwrite>
80102cc9:	89 3c 24             	mov    %edi,(%esp)
80102ccc:	e8 0f d5 ff ff       	call   801001e0 <brelse>
80102cd1:	89 34 24             	mov    %esi,(%esp)
80102cd4:	e8 07 d5 ff ff       	call   801001e0 <brelse>
80102cd9:	83 c4 10             	add    $0x10,%esp
80102cdc:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102ce2:	7c 94                	jl     80102c78 <end_op+0x68>
80102ce4:	e8 b7 fd ff ff       	call   80102aa0 <write_head>
80102ce9:	e8 12 fd ff ff       	call   80102a00 <install_trans>
80102cee:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cf5:	00 00 00 
80102cf8:	e8 a3 fd ff ff       	call   80102aa0 <write_head>
80102cfd:	83 ec 0c             	sub    $0xc,%esp
80102d00:	68 80 26 11 80       	push   $0x80112680
80102d05:	e8 e6 1a 00 00       	call   801047f0 <acquire>
80102d0a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d11:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d18:	00 00 00 
80102d1b:	e8 40 16 00 00       	call   80104360 <wakeup>
80102d20:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d27:	e8 84 1b 00 00       	call   801048b0 <release>
80102d2c:	83 c4 10             	add    $0x10,%esp
80102d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d32:	5b                   	pop    %ebx
80102d33:	5e                   	pop    %esi
80102d34:	5f                   	pop    %edi
80102d35:	5d                   	pop    %ebp
80102d36:	c3                   	ret    
80102d37:	89 f6                	mov    %esi,%esi
80102d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102d40:	83 ec 0c             	sub    $0xc,%esp
80102d43:	68 80 26 11 80       	push   $0x80112680
80102d48:	e8 13 16 00 00       	call   80104360 <wakeup>
80102d4d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d54:	e8 57 1b 00 00       	call   801048b0 <release>
80102d59:	83 c4 10             	add    $0x10,%esp
80102d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5f:	5b                   	pop    %ebx
80102d60:	5e                   	pop    %esi
80102d61:	5f                   	pop    %edi
80102d62:	5d                   	pop    %ebp
80102d63:	c3                   	ret    
80102d64:	83 ec 0c             	sub    $0xc,%esp
80102d67:	68 64 78 10 80       	push   $0x80107864
80102d6c:	e8 1f d6 ff ff       	call   80100390 <panic>
80102d71:	eb 0d                	jmp    80102d80 <log_write>
80102d73:	90                   	nop
80102d74:	90                   	nop
80102d75:	90                   	nop
80102d76:	90                   	nop
80102d77:	90                   	nop
80102d78:	90                   	nop
80102d79:	90                   	nop
80102d7a:	90                   	nop
80102d7b:	90                   	nop
80102d7c:	90                   	nop
80102d7d:	90                   	nop
80102d7e:	90                   	nop
80102d7f:	90                   	nop

80102d80 <log_write>:
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 04             	sub    $0x4,%esp
80102d87:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d90:	83 fa 1d             	cmp    $0x1d,%edx
80102d93:	0f 8f 97 00 00 00    	jg     80102e30 <log_write+0xb0>
80102d99:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d9e:	83 e8 01             	sub    $0x1,%eax
80102da1:	39 c2                	cmp    %eax,%edx
80102da3:	0f 8d 87 00 00 00    	jge    80102e30 <log_write+0xb0>
80102da9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102dae:	85 c0                	test   %eax,%eax
80102db0:	0f 8e 87 00 00 00    	jle    80102e3d <log_write+0xbd>
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 80 26 11 80       	push   $0x80112680
80102dbe:	e8 2d 1a 00 00       	call   801047f0 <acquire>
80102dc3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	83 fa 00             	cmp    $0x0,%edx
80102dcf:	7e 50                	jle    80102e21 <log_write+0xa1>
80102dd1:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102dd4:	31 c0                	xor    %eax,%eax
80102dd6:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102ddc:	75 0b                	jne    80102de9 <log_write+0x69>
80102dde:	eb 38                	jmp    80102e18 <log_write+0x98>
80102de0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102de7:	74 2f                	je     80102e18 <log_write+0x98>
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	39 d0                	cmp    %edx,%eax
80102dee:	75 f0                	jne    80102de0 <log_write+0x60>
80102df0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
80102df7:	83 c2 01             	add    $0x1,%edx
80102dfa:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102e00:	83 0b 04             	orl    $0x4,(%ebx)
80102e03:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
80102e0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e0d:	c9                   	leave  
80102e0e:	e9 9d 1a 00 00       	jmp    801048b0 <release>
80102e13:	90                   	nop
80102e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e18:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102e1f:	eb df                	jmp    80102e00 <log_write+0x80>
80102e21:	8b 43 08             	mov    0x8(%ebx),%eax
80102e24:	a3 cc 26 11 80       	mov    %eax,0x801126cc
80102e29:	75 d5                	jne    80102e00 <log_write+0x80>
80102e2b:	eb ca                	jmp    80102df7 <log_write+0x77>
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi
80102e30:	83 ec 0c             	sub    $0xc,%esp
80102e33:	68 73 78 10 80       	push   $0x80107873
80102e38:	e8 53 d5 ff ff       	call   80100390 <panic>
80102e3d:	83 ec 0c             	sub    $0xc,%esp
80102e40:	68 89 78 10 80       	push   $0x80107889
80102e45:	e8 46 d5 ff ff       	call   80100390 <panic>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e57:	e8 f4 09 00 00       	call   80103850 <cpuid>
80102e5c:	89 c3                	mov    %eax,%ebx
80102e5e:	e8 ed 09 00 00       	call   80103850 <cpuid>
80102e63:	83 ec 04             	sub    $0x4,%esp
80102e66:	53                   	push   %ebx
80102e67:	50                   	push   %eax
80102e68:	68 a4 78 10 80       	push   $0x801078a4
80102e6d:	e8 ee d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e72:	e8 49 2d 00 00       	call   80105bc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e77:	e8 54 09 00 00       	call   801037d0 <mycpu>
80102e7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e8a:	e8 d1 0d 00 00       	call   80103c60 <scheduler>
80102e8f:	90                   	nop

80102e90 <mpenter>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e96:	e8 15 3e 00 00       	call   80106cb0 <switchkvm>
  seginit();
80102e9b:	e8 80 3d 00 00       	call   80106c20 <seginit>
  lapicinit();
80102ea0:	e8 9b f7 ff ff       	call   80102640 <lapicinit>
  mpmain();
80102ea5:	e8 a6 ff ff ff       	call   80102e50 <mpmain>
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <main>:
{
80102eb0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102eb4:	83 e4 f0             	and    $0xfffffff0,%esp
80102eb7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eba:	55                   	push   %ebp
80102ebb:	89 e5                	mov    %esp,%ebp
80102ebd:	53                   	push   %ebx
80102ebe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ebf:	83 ec 08             	sub    $0x8,%esp
80102ec2:	68 00 00 40 80       	push   $0x80400000
80102ec7:	68 c8 34 12 80       	push   $0x801234c8
80102ecc:	e8 3f f5 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102ed1:	e8 ba 42 00 00       	call   80107190 <kvmalloc>
  mpinit();        // detect other processors
80102ed6:	e8 75 01 00 00       	call   80103050 <mpinit>
  lapicinit();     // interrupt controller
80102edb:	e8 60 f7 ff ff       	call   80102640 <lapicinit>
  seginit();       // segment descriptors
80102ee0:	e8 3b 3d 00 00       	call   80106c20 <seginit>
  picinit();       // disable pic
80102ee5:	e8 46 03 00 00       	call   80103230 <picinit>
  ioapicinit();    // another interrupt controller
80102eea:	e8 51 f3 ff ff       	call   80102240 <ioapicinit>
  consoleinit();   // console hardware
80102eef:	e8 cc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ef4:	e8 f7 2f 00 00       	call   80105ef0 <uartinit>
  pinit();         // process table
80102ef9:	e8 a2 08 00 00       	call   801037a0 <pinit>
  tvinit();        // trap vectors
80102efe:	e8 3d 2c 00 00       	call   80105b40 <tvinit>
  binit();         // buffer cache
80102f03:	e8 38 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f08:	e8 63 de ff ff       	call   80100d70 <fileinit>
  ideinit();       // disk 
80102f0d:	e8 0e f1 ff ff       	call   80102020 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f12:	83 c4 0c             	add    $0xc,%esp
80102f15:	68 8a 00 00 00       	push   $0x8a
80102f1a:	68 8c a4 10 80       	push   $0x8010a48c
80102f1f:	68 00 70 00 80       	push   $0x80007000
80102f24:	e8 97 1a 00 00       	call   801049c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f29:	69 05 20 2d 11 80 b4 	imul   $0xb4,0x80112d20,%eax
80102f30:	00 00 00 
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	05 80 27 11 80       	add    $0x80112780,%eax
80102f3b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f40:	76 71                	jbe    80102fb3 <main+0x103>
80102f42:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f47:	89 f6                	mov    %esi,%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f50:	e8 7b 08 00 00       	call   801037d0 <mycpu>
80102f55:	39 d8                	cmp    %ebx,%eax
80102f57:	74 41                	je     80102f9a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f59:	e8 82 f5 ff ff       	call   801024e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f5e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f63:	c7 05 f8 6f 00 80 90 	movl   $0x80102e90,0x80006ff8
80102f6a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f6d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f74:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f77:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f7c:	0f b6 03             	movzbl (%ebx),%eax
80102f7f:	83 ec 08             	sub    $0x8,%esp
80102f82:	68 00 70 00 00       	push   $0x7000
80102f87:	50                   	push   %eax
80102f88:	e8 03 f8 ff ff       	call   80102790 <lapicstartap>
80102f8d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f90:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	74 f6                	je     80102f90 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f9a:	69 05 20 2d 11 80 b4 	imul   $0xb4,0x80112d20,%eax
80102fa1:	00 00 00 
80102fa4:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80102faa:	05 80 27 11 80       	add    $0x80112780,%eax
80102faf:	39 c3                	cmp    %eax,%ebx
80102fb1:	72 9d                	jb     80102f50 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fb3:	83 ec 08             	sub    $0x8,%esp
80102fb6:	68 00 00 00 8e       	push   $0x8e000000
80102fbb:	68 00 00 40 80       	push   $0x80400000
80102fc0:	e8 bb f4 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80102fc5:	e8 06 09 00 00       	call   801038d0 <userinit>
  mpmain();        // finish this processor's setup
80102fca:	e8 81 fe ff ff       	call   80102e50 <mpmain>
80102fcf:	90                   	nop

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fd5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fdb:	53                   	push   %ebx
  e = addr+len;
80102fdc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fdf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe2:	39 de                	cmp    %ebx,%esi
80102fe4:	72 10                	jb     80102ff6 <mpsearch1+0x26>
80102fe6:	eb 50                	jmp    80103038 <mpsearch1+0x68>
80102fe8:	90                   	nop
80102fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff0:	39 fb                	cmp    %edi,%ebx
80102ff2:	89 fe                	mov    %edi,%esi
80102ff4:	76 42                	jbe    80103038 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff6:	83 ec 04             	sub    $0x4,%esp
80102ff9:	8d 7e 10             	lea    0x10(%esi),%edi
80102ffc:	6a 04                	push   $0x4
80102ffe:	68 b8 78 10 80       	push   $0x801078b8
80103003:	56                   	push   %esi
80103004:	e8 57 19 00 00       	call   80104960 <memcmp>
80103009:	83 c4 10             	add    $0x10,%esp
8010300c:	85 c0                	test   %eax,%eax
8010300e:	75 e0                	jne    80102ff0 <mpsearch1+0x20>
80103010:	89 f1                	mov    %esi,%ecx
80103012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103018:	0f b6 11             	movzbl (%ecx),%edx
8010301b:	83 c1 01             	add    $0x1,%ecx
8010301e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103020:	39 f9                	cmp    %edi,%ecx
80103022:	75 f4                	jne    80103018 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103024:	84 c0                	test   %al,%al
80103026:	75 c8                	jne    80102ff0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302b:	89 f0                	mov    %esi,%eax
8010302d:	5b                   	pop    %ebx
8010302e:	5e                   	pop    %esi
8010302f:	5f                   	pop    %edi
80103030:	5d                   	pop    %ebp
80103031:	c3                   	ret    
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010303b:	31 f6                	xor    %esi,%esi
}
8010303d:	89 f0                	mov    %esi,%eax
8010303f:	5b                   	pop    %ebx
80103040:	5e                   	pop    %esi
80103041:	5f                   	pop    %edi
80103042:	5d                   	pop    %ebp
80103043:	c3                   	ret    
80103044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010304a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103050 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103059:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103060:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103067:	c1 e0 08             	shl    $0x8,%eax
8010306a:	09 d0                	or     %edx,%eax
8010306c:	c1 e0 04             	shl    $0x4,%eax
8010306f:	85 c0                	test   %eax,%eax
80103071:	75 1b                	jne    8010308e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103073:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010307a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103081:	c1 e0 08             	shl    $0x8,%eax
80103084:	09 d0                	or     %edx,%eax
80103086:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103089:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010308e:	ba 00 04 00 00       	mov    $0x400,%edx
80103093:	e8 38 ff ff ff       	call   80102fd0 <mpsearch1>
80103098:	85 c0                	test   %eax,%eax
8010309a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010309d:	0f 84 3d 01 00 00    	je     801031e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030a6:	8b 58 04             	mov    0x4(%eax),%ebx
801030a9:	85 db                	test   %ebx,%ebx
801030ab:	0f 84 4f 01 00 00    	je     80103200 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030b7:	83 ec 04             	sub    $0x4,%esp
801030ba:	6a 04                	push   $0x4
801030bc:	68 d5 78 10 80       	push   $0x801078d5
801030c1:	56                   	push   %esi
801030c2:	e8 99 18 00 00       	call   80104960 <memcmp>
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	85 c0                	test   %eax,%eax
801030cc:	0f 85 2e 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030d9:	3c 01                	cmp    $0x1,%al
801030db:	0f 95 c2             	setne  %dl
801030de:	3c 04                	cmp    $0x4,%al
801030e0:	0f 95 c0             	setne  %al
801030e3:	20 c2                	and    %al,%dl
801030e5:	0f 85 15 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030eb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030f2:	66 85 ff             	test   %di,%di
801030f5:	74 1a                	je     80103111 <mpinit+0xc1>
801030f7:	89 f0                	mov    %esi,%eax
801030f9:	01 f7                	add    %esi,%edi
  sum = 0;
801030fb:	31 d2                	xor    %edx,%edx
801030fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103100:	0f b6 08             	movzbl (%eax),%ecx
80103103:	83 c0 01             	add    $0x1,%eax
80103106:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103108:	39 c7                	cmp    %eax,%edi
8010310a:	75 f4                	jne    80103100 <mpinit+0xb0>
8010310c:	84 d2                	test   %dl,%dl
8010310e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103111:	85 f6                	test   %esi,%esi
80103113:	0f 84 e7 00 00 00    	je     80103200 <mpinit+0x1b0>
80103119:	84 d2                	test   %dl,%dl
8010311b:	0f 85 df 00 00 00    	jne    80103200 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103121:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103127:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103133:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103139:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010313e:	01 d6                	add    %edx,%esi
80103140:	39 c6                	cmp    %eax,%esi
80103142:	76 23                	jbe    80103167 <mpinit+0x117>
    switch(*p){
80103144:	0f b6 10             	movzbl (%eax),%edx
80103147:	80 fa 04             	cmp    $0x4,%dl
8010314a:	0f 87 ca 00 00 00    	ja     8010321a <mpinit+0x1ca>
80103150:	ff 24 95 fc 78 10 80 	jmp    *-0x7fef8704(,%edx,4)
80103157:	89 f6                	mov    %esi,%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103160:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103163:	39 c6                	cmp    %eax,%esi
80103165:	77 dd                	ja     80103144 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103167:	85 db                	test   %ebx,%ebx
80103169:	0f 84 9e 00 00 00    	je     8010320d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103172:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103176:	74 15                	je     8010318d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103178:	b8 70 00 00 00       	mov    $0x70,%eax
8010317d:	ba 22 00 00 00       	mov    $0x22,%edx
80103182:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103183:	ba 23 00 00 00       	mov    $0x23,%edx
80103188:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103189:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010318c:	ee                   	out    %al,(%dx)
  }
}
8010318d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103190:	5b                   	pop    %ebx
80103191:	5e                   	pop    %esi
80103192:	5f                   	pop    %edi
80103193:	5d                   	pop    %ebp
80103194:	c3                   	ret    
80103195:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103198:	8b 0d 20 2d 11 80    	mov    0x80112d20,%ecx
8010319e:	83 f9 07             	cmp    $0x7,%ecx
801031a1:	7f 19                	jg     801031bc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031a7:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
801031ad:	83 c1 01             	add    $0x1,%ecx
801031b0:	89 0d 20 2d 11 80    	mov    %ecx,0x80112d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801031bc:	83 c0 14             	add    $0x14,%eax
      continue;
801031bf:	e9 7c ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031cf:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
801031d5:	e9 66 ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ea:	e8 e1 fd ff ff       	call   80102fd0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ef:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f4:	0f 85 a9 fe ff ff    	jne    801030a3 <mpinit+0x53>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103200:	83 ec 0c             	sub    $0xc,%esp
80103203:	68 bd 78 10 80       	push   $0x801078bd
80103208:	e8 83 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	68 dc 78 10 80       	push   $0x801078dc
80103215:	e8 76 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010321a:	31 db                	xor    %ebx,%ebx
8010321c:	e9 26 ff ff ff       	jmp    80103147 <mpinit+0xf7>
80103221:	66 90                	xchg   %ax,%ax
80103223:	66 90                	xchg   %ax,%ax
80103225:	66 90                	xchg   %ax,%ax
80103227:	66 90                	xchg   %ax,%ax
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picinit>:
80103230:	55                   	push   %ebp
80103231:	ba 21 00 00 00       	mov    $0x21,%edx
80103236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	ee                   	out    %al,(%dx)
8010323e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103243:	ee                   	out    %al,(%dx)
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010325f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010326b:	e8 20 db ff ff       	call   80100d90 <filealloc>
80103270:	85 c0                	test   %eax,%eax
80103272:	89 03                	mov    %eax,(%ebx)
80103274:	74 22                	je     80103298 <pipealloc+0x48>
80103276:	e8 15 db ff ff       	call   80100d90 <filealloc>
8010327b:	85 c0                	test   %eax,%eax
8010327d:	89 06                	mov    %eax,(%esi)
8010327f:	74 3f                	je     801032c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103281:	e8 5a f2 ff ff       	call   801024e0 <kalloc>
80103286:	85 c0                	test   %eax,%eax
80103288:	89 c7                	mov    %eax,%edi
8010328a:	75 54                	jne    801032e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010328c:	8b 03                	mov    (%ebx),%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	75 34                	jne    801032c6 <pipealloc+0x76>
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103298:	8b 06                	mov    (%esi),%eax
8010329a:	85 c0                	test   %eax,%eax
8010329c:	74 0c                	je     801032aa <pipealloc+0x5a>
    fileclose(*f1);
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	50                   	push   %eax
801032a2:	e8 a9 db ff ff       	call   80100e50 <fileclose>
801032a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032b2:	5b                   	pop    %ebx
801032b3:	5e                   	pop    %esi
801032b4:	5f                   	pop    %edi
801032b5:	5d                   	pop    %ebp
801032b6:	c3                   	ret    
801032b7:	89 f6                	mov    %esi,%esi
801032b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032c0:	8b 03                	mov    (%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 e4                	je     801032aa <pipealloc+0x5a>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 81 db ff ff       	call   80100e50 <fileclose>
  if(*f1)
801032cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d4:	85 c0                	test   %eax,%eax
801032d6:	75 c6                	jne    8010329e <pipealloc+0x4e>
801032d8:	eb d0                	jmp    801032aa <pipealloc+0x5a>
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032ea:	00 00 00 
  p->writeopen = 1;
801032ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032f4:	00 00 00 
  p->nwrite = 0;
801032f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032fe:	00 00 00 
  p->nread = 0;
80103301:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103308:	00 00 00 
  initlock(&p->lock, "pipe");
8010330b:	68 10 79 10 80       	push   $0x80107910
80103310:	50                   	push   %eax
80103311:	e8 9a 13 00 00       	call   801046b0 <initlock>
  (*f0)->type = FD_PIPE;
80103316:	8b 03                	mov    (%ebx),%eax
  return 0;
80103318:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010331b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103321:	8b 03                	mov    (%ebx),%eax
80103323:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103327:	8b 03                	mov    (%ebx),%eax
80103329:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010332d:	8b 03                	mov    (%ebx),%eax
8010332f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103332:	8b 06                	mov    (%esi),%eax
80103334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103346:	8b 06                	mov    (%esi),%eax
80103348:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010334b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010334e:	31 c0                	xor    %eax,%eax
}
80103350:	5b                   	pop    %ebx
80103351:	5e                   	pop    %esi
80103352:	5f                   	pop    %edi
80103353:	5d                   	pop    %ebp
80103354:	c3                   	ret    
80103355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103360 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103368:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010336b:	83 ec 0c             	sub    $0xc,%esp
8010336e:	53                   	push   %ebx
8010336f:	e8 7c 14 00 00       	call   801047f0 <acquire>
  if(writable){
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 f6                	test   %esi,%esi
80103379:	74 45                	je     801033c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010337b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103381:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103384:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010338b:	00 00 00 
    wakeup(&p->nread);
8010338e:	50                   	push   %eax
8010338f:	e8 cc 0f 00 00       	call   80104360 <wakeup>
80103394:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103397:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339d:	85 d2                	test   %edx,%edx
8010339f:	75 0a                	jne    801033ab <pipeclose+0x4b>
801033a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033a7:	85 c0                	test   %eax,%eax
801033a9:	74 35                	je     801033e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b1:	5b                   	pop    %ebx
801033b2:	5e                   	pop    %esi
801033b3:	5d                   	pop    %ebp
    release(&p->lock);
801033b4:	e9 f7 14 00 00       	jmp    801048b0 <release>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033d0:	00 00 00 
    wakeup(&p->nwrite);
801033d3:	50                   	push   %eax
801033d4:	e8 87 0f 00 00       	call   80104360 <wakeup>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	eb b9                	jmp    80103397 <pipeclose+0x37>
801033de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 c7 14 00 00       	call   801048b0 <release>
    kfree((char*)p);
801033e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033ec:	83 c4 10             	add    $0x10,%esp
}
801033ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033f2:	5b                   	pop    %ebx
801033f3:	5e                   	pop    %esi
801033f4:	5d                   	pop    %ebp
    kfree((char*)p);
801033f5:	e9 36 ef ff ff       	jmp    80102330 <kfree>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103400 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 28             	sub    $0x28,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010340c:	53                   	push   %ebx
8010340d:	e8 de 13 00 00       	call   801047f0 <acquire>
  for(i = 0; i < n; i++){
80103412:	8b 45 10             	mov    0x10(%ebp),%eax
80103415:	83 c4 10             	add    $0x10,%esp
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 8e c9 00 00 00    	jle    801034e9 <pipewrite+0xe9>
80103420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103423:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103429:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010342f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103432:	03 4d 10             	add    0x10(%ebp),%ecx
80103435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103438:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010343e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103444:	39 d0                	cmp    %edx,%eax
80103446:	75 71                	jne    801034b9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103448:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 4e                	je     801034a0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103452:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103458:	eb 3a                	jmp    80103494 <pipewrite+0x94>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	57                   	push   %edi
80103464:	e8 f7 0e 00 00       	call   80104360 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103469:	5a                   	pop    %edx
8010346a:	59                   	pop    %ecx
8010346b:	53                   	push   %ebx
8010346c:	56                   	push   %esi
8010346d:	e8 2e 0a 00 00       	call   80103ea0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103472:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103478:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	05 00 02 00 00       	add    $0x200,%eax
80103486:	39 c2                	cmp    %eax,%edx
80103488:	75 36                	jne    801034c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010348a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103490:	85 c0                	test   %eax,%eax
80103492:	74 0c                	je     801034a0 <pipewrite+0xa0>
80103494:	e8 d7 03 00 00       	call   80103870 <myproc>
80103499:	8b 40 1c             	mov    0x1c(%eax),%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	74 c0                	je     80103460 <pipewrite+0x60>
        release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 07 14 00 00       	call   801048b0 <release>
        return -1;
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b4:	5b                   	pop    %ebx
801034b5:	5e                   	pop    %esi
801034b6:	5f                   	pop    %edi
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034b9:	89 c2                	mov    %eax,%edx
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034c3:	8d 42 01             	lea    0x1(%edx),%eax
801034c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034d2:	83 c6 01             	add    $0x1,%esi
801034d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034e3:	0f 85 4f ff ff ff    	jne    80103438 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	50                   	push   %eax
801034f3:	e8 68 0e 00 00       	call   80104360 <wakeup>
  release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 b0 13 00 00       	call   801048b0 <release>
  return n;
80103500:	83 c4 10             	add    $0x10,%esp
80103503:	8b 45 10             	mov    0x10(%ebp),%eax
80103506:	eb a9                	jmp    801034b1 <pipewrite+0xb1>
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103510 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 18             	sub    $0x18,%esp
80103519:	8b 75 08             	mov    0x8(%ebp),%esi
8010351c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010351f:	56                   	push   %esi
80103520:	e8 cb 12 00 00       	call   801047f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010352e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103534:	75 6a                	jne    801035a0 <piperead+0x90>
80103536:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	0f 84 c4 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103544:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010354a:	eb 2d                	jmp    80103579 <piperead+0x69>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	83 ec 08             	sub    $0x8,%esp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	e8 46 09 00 00       	call   80103ea0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103563:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103569:	75 35                	jne    801035a0 <piperead+0x90>
8010356b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 8f 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
80103579:	e8 f2 02 00 00       	call   80103870 <myproc>
8010357e:	8b 48 1c             	mov    0x1c(%eax),%ecx
80103581:	85 c9                	test   %ecx,%ecx
80103583:	74 cb                	je     80103550 <piperead+0x40>
      release(&p->lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103588:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010358d:	56                   	push   %esi
8010358e:	e8 1d 13 00 00       	call   801048b0 <release>
      return -1;
80103593:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103599:	89 d8                	mov    %ebx,%eax
8010359b:	5b                   	pop    %ebx
8010359c:	5e                   	pop    %esi
8010359d:	5f                   	pop    %edi
8010359e:	5d                   	pop    %ebp
8010359f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a0:	8b 45 10             	mov    0x10(%ebp),%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	7e 61                	jle    80103608 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035a7:	31 db                	xor    %ebx,%ebx
801035a9:	eb 13                	jmp    801035be <piperead+0xae>
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035b6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035bc:	74 1f                	je     801035dd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035be:	8d 41 01             	lea    0x1(%ecx),%eax
801035c1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035c7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035cd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035d2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d5:	83 c3 01             	add    $0x1,%ebx
801035d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035db:	75 d3                	jne    801035b0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035dd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035e3:	83 ec 0c             	sub    $0xc,%esp
801035e6:	50                   	push   %eax
801035e7:	e8 74 0d 00 00       	call   80104360 <wakeup>
  release(&p->lock);
801035ec:	89 34 24             	mov    %esi,(%esp)
801035ef:	e8 bc 12 00 00       	call   801048b0 <release>
  return i;
801035f4:	83 c4 10             	add    $0x10,%esp
}
801035f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035fa:	89 d8                	mov    %ebx,%eax
801035fc:	5b                   	pop    %ebx
801035fd:	5e                   	pop    %esi
801035fe:	5f                   	pop    %edi
801035ff:	5d                   	pop    %ebp
80103600:	c3                   	ret    
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	31 db                	xor    %ebx,%ebx
8010360a:	eb d1                	jmp    801035dd <piperead+0xcd>
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	56                   	push   %esi
80103614:	53                   	push   %ebx
    acquire(&ptable.lock);
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc ; p < &ptable.proc[NPROC]; p++  )
80103615:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    cprintf( " ALLOCPROC ");
8010361a:	83 ec 0c             	sub    $0xc,%esp
8010361d:	68 15 79 10 80       	push   $0x80107915
80103622:	e8 39 d0 ff ff       	call   80100660 <cprintf>
    acquire(&ptable.lock);
80103627:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010362e:	e8 bd 11 00 00       	call   801047f0 <acquire>
80103633:	83 c4 10             	add    $0x10,%esp
80103636:	eb 16                	jmp    8010364e <allocproc+0x3e>
80103638:	90                   	nop
80103639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc ; p < &ptable.proc[NPROC]; p++  )
80103640:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
80103646:	81 fb 74 2c 12 80    	cmp    $0x80122c74,%ebx
8010364c:	73 50                	jae    8010369e <allocproc+0x8e>
        if (p->state == UNUSED)
8010364e:	8b 73 08             	mov    0x8(%ebx),%esi
80103651:	85 f6                	test   %esi,%esi
80103653:	75 eb                	jne    80103640 <allocproc+0x30>
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103655:	a1 04 a0 10 80       	mov    0x8010a004,%eax
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
8010365a:	8b 4b 78             	mov    0x78(%ebx),%ecx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010365d:	8d 73 70             	lea    0x70(%ebx),%esi
    p->state = EMBRYO;
80103660:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    p->tidCounter = 1;
80103667:	c7 83 f4 03 00 00 01 	movl   $0x1,0x3f4(%ebx)
8010366e:	00 00 00 
    p->pid = nextpid++;
80103671:	8d 50 01             	lea    0x1(%eax),%edx
        if (t->state == UNUSED)
80103674:	85 c9                	test   %ecx,%ecx
    p->pid = nextpid++;
80103676:	89 43 0c             	mov    %eax,0xc(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80103679:	8d 83 f0 03 00 00    	lea    0x3f0(%ebx),%eax
    p->pid = nextpid++;
8010367f:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
        if (t->state == UNUSED)
80103685:	75 10                	jne    80103697 <allocproc+0x87>
80103687:	eb 37                	jmp    801036c0 <allocproc+0xb0>
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103690:	8b 56 08             	mov    0x8(%esi),%edx
80103693:	85 d2                	test   %edx,%edx
80103695:	74 29                	je     801036c0 <allocproc+0xb0>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80103697:	83 c6 38             	add    $0x38,%esi
8010369a:	39 f0                	cmp    %esi,%eax
8010369c:	77 f2                	ja     80103690 <allocproc+0x80>

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->state = UNUSED;
        t->state = UNUSED;
        release(&ptable.lock);
8010369e:	83 ec 0c             	sub    $0xc,%esp
        return 0;
801036a1:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
801036a3:	68 40 2d 11 80       	push   $0x80112d40
801036a8:	e8 03 12 00 00       	call   801048b0 <release>
        return 0;
801036ad:	83 c4 10             	add    $0x10,%esp
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);
//    release(p->procLock);
    return p;
}
801036b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b3:	89 d8                	mov    %ebx,%eax
801036b5:	5b                   	pop    %ebx
801036b6:	5e                   	pop    %esi
801036b7:	5d                   	pop    %ebp
801036b8:	c3                   	ret    
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    t->state = EMBRYO;
801036c0:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    t->tid = p->tidCounter++;
801036c7:	8b 83 f4 03 00 00    	mov    0x3f4(%ebx),%eax
801036cd:	8d 50 01             	lea    0x1(%eax),%edx
801036d0:	89 93 f4 03 00 00    	mov    %edx,0x3f4(%ebx)
801036d6:	89 46 0c             	mov    %eax,0xc(%esi)
    p->mainThread = t;
801036d9:	89 b3 f0 03 00 00    	mov    %esi,0x3f0(%ebx)
    if ((t->tkstack = kalloc()) == 0) {
801036df:	e8 fc ed ff ff       	call   801024e0 <kalloc>
801036e4:	85 c0                	test   %eax,%eax
801036e6:	89 46 04             	mov    %eax,0x4(%esi)
801036e9:	74 47                	je     80103732 <allocproc+0x122>
    sp -= sizeof *t->tf;
801036eb:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(t->context, 0, sizeof *t->context);
801036f1:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
801036f4:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
801036f9:	89 56 10             	mov    %edx,0x10(%esi)
    *(uint *) sp = (uint) trapret;
801036fc:	c7 40 14 32 5b 10 80 	movl   $0x80105b32,0x14(%eax)
    t->context = (struct context *) sp;
80103703:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
80103706:	6a 14                	push   $0x14
80103708:	6a 00                	push   $0x0
8010370a:	50                   	push   %eax
8010370b:	e8 00 12 00 00       	call   80104910 <memset>
    t->context->eip = (uint) forkret;
80103710:	8b 46 14             	mov    0x14(%esi),%eax
80103713:	c7 40 10 50 37 10 80 	movl   $0x80103750,0x10(%eax)
    release(&ptable.lock);
8010371a:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103721:	e8 8a 11 00 00       	call   801048b0 <release>
    return p;
80103726:	83 c4 10             	add    $0x10,%esp
}
80103729:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010372c:	89 d8                	mov    %ebx,%eax
8010372e:	5b                   	pop    %ebx
8010372f:	5e                   	pop    %esi
80103730:	5d                   	pop    %ebp
80103731:	c3                   	ret    
        p->state = UNUSED;
80103732:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        t->state = UNUSED;
80103739:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
80103740:	e9 59 ff ff ff       	jmp    8010369e <allocproc+0x8e>
80103745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103750 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103756:	68 40 2d 11 80       	push   $0x80112d40
8010375b:	e8 50 11 00 00       	call   801048b0 <release>

    if (first) {
80103760:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	85 c0                	test   %eax,%eax
8010376a:	75 04                	jne    80103770 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
8010376c:	c9                   	leave  
8010376d:	c3                   	ret    
8010376e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103770:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103773:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010377a:	00 00 00 
        iinit(ROOTDEV);
8010377d:	6a 01                	push   $0x1
8010377f:	e8 1c dd ff ff       	call   801014a0 <iinit>
        initlog(ROOTDEV);
80103784:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010378b:	e8 70 f3 ff ff       	call   80102b00 <initlog>
80103790:	83 c4 10             	add    $0x10,%esp
}
80103793:	c9                   	leave  
80103794:	c3                   	ret    
80103795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037a0 <pinit>:
pinit(void) {
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	83 ec 14             	sub    $0x14,%esp
    cprintf( " PINIT ");
801037a6:	68 21 79 10 80       	push   $0x80107921
801037ab:	e8 b0 ce ff ff       	call   80100660 <cprintf>
    initlock(&ptable.lock, "ptable");
801037b0:	58                   	pop    %eax
801037b1:	5a                   	pop    %edx
801037b2:	68 29 79 10 80       	push   $0x80107929
801037b7:	68 40 2d 11 80       	push   $0x80112d40
801037bc:	e8 ef 0e 00 00       	call   801046b0 <initlock>
}
801037c1:	83 c4 10             	add    $0x10,%esp
801037c4:	c9                   	leave  
801037c5:	c3                   	ret    
801037c6:	8d 76 00             	lea    0x0(%esi),%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <mycpu>:
mycpu(void) {
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037d5:	9c                   	pushf  
801037d6:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801037d7:	f6 c4 02             	test   $0x2,%ah
801037da:	75 5e                	jne    8010383a <mycpu+0x6a>
    apicid = lapicid();
801037dc:	e8 5f ef ff ff       	call   80102740 <lapicid>
    for (i = 0; i < ncpu; ++i) {
801037e1:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
801037e7:	85 f6                	test   %esi,%esi
801037e9:	7e 42                	jle    8010382d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
801037eb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801037f2:	39 d0                	cmp    %edx,%eax
801037f4:	74 30                	je     80103826 <mycpu+0x56>
801037f6:	b9 34 28 11 80       	mov    $0x80112834,%ecx
    for (i = 0; i < ncpu; ++i) {
801037fb:	31 d2                	xor    %edx,%edx
801037fd:	8d 76 00             	lea    0x0(%esi),%esi
80103800:	83 c2 01             	add    $0x1,%edx
80103803:	39 f2                	cmp    %esi,%edx
80103805:	74 26                	je     8010382d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103807:	0f b6 19             	movzbl (%ecx),%ebx
8010380a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
80103810:	39 c3                	cmp    %eax,%ebx
80103812:	75 ec                	jne    80103800 <mycpu+0x30>
80103814:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
8010381a:	05 80 27 11 80       	add    $0x80112780,%eax
}
8010381f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103822:	5b                   	pop    %ebx
80103823:	5e                   	pop    %esi
80103824:	5d                   	pop    %ebp
80103825:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103826:	b8 80 27 11 80       	mov    $0x80112780,%eax
            return &cpus[i];
8010382b:	eb f2                	jmp    8010381f <mycpu+0x4f>
    panic("unknown apicid\n");
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 30 79 10 80       	push   $0x80107930
80103835:	e8 56 cb ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
8010383a:	83 ec 0c             	sub    $0xc,%esp
8010383d:	68 a0 7a 10 80       	push   $0x80107aa0
80103842:	e8 49 cb ff ff       	call   80100390 <panic>
80103847:	89 f6                	mov    %esi,%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103850 <cpuid>:
cpuid() {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103856:	e8 75 ff ff ff       	call   801037d0 <mycpu>
8010385b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103860:	c9                   	leave  
    return mycpu() - cpus;
80103861:	c1 f8 02             	sar    $0x2,%eax
80103864:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
8010386a:	c3                   	ret    
8010386b:	90                   	nop
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103870 <myproc>:
myproc(void) {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	53                   	push   %ebx
80103874:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103877:	e8 a4 0e 00 00       	call   80104720 <pushcli>
    c = mycpu();
8010387c:	e8 4f ff ff ff       	call   801037d0 <mycpu>
    p = c->proc;
80103881:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103887:	e8 d4 0e 00 00       	call   80104760 <popcli>
}
8010388c:	83 c4 04             	add    $0x4,%esp
8010388f:	89 d8                	mov    %ebx,%eax
80103891:	5b                   	pop    %ebx
80103892:	5d                   	pop    %ebp
80103893:	c3                   	ret    
80103894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010389a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038a0 <mythread>:
mythread(void) {
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801038a7:	e8 74 0e 00 00       	call   80104720 <pushcli>
    c = mycpu();
801038ac:	e8 1f ff ff ff       	call   801037d0 <mycpu>
    t = c->currThread;
801038b1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801038b7:	e8 a4 0e 00 00       	call   80104760 <popcli>
}
801038bc:	83 c4 04             	add    $0x4,%esp
801038bf:	89 d8                	mov    %ebx,%eax
801038c1:	5b                   	pop    %ebx
801038c2:	5d                   	pop    %ebp
801038c3:	c3                   	ret    
801038c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038d0 <userinit>:
userinit(void) {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	56                   	push   %esi
801038d4:	53                   	push   %ebx
    p = allocproc();
801038d5:	e8 36 fd ff ff       	call   80103610 <allocproc>
801038da:	89 c3                	mov    %eax,%ebx
    initproc = p;
801038dc:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
    if ((p->pgdir = setupkvm()) == 0)
801038e1:	e8 2a 38 00 00       	call   80107110 <setupkvm>
801038e6:	85 c0                	test   %eax,%eax
801038e8:	89 43 04             	mov    %eax,0x4(%ebx)
801038eb:	0f 84 27 01 00 00    	je     80103a18 <userinit+0x148>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
801038f1:	83 ec 04             	sub    $0x4,%esp
801038f4:	68 2c 00 00 00       	push   $0x2c
801038f9:	68 60 a4 10 80       	push   $0x8010a460
801038fe:	50                   	push   %eax
801038ff:	e8 ec 34 00 00       	call   80106df0 <inituvm>
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
80103904:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103907:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
8010390d:	6a 4c                	push   $0x4c
8010390f:	6a 00                	push   $0x0
80103911:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103917:	ff 70 10             	pushl  0x10(%eax)
8010391a:	e8 f1 0f 00 00       	call   80104910 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010391f:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103925:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010392a:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
8010392f:	83 c4 0c             	add    $0xc,%esp
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103932:	8b 40 10             	mov    0x10(%eax),%eax
80103935:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103939:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
8010393f:	8b 40 10             	mov    0x10(%eax),%eax
80103942:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
80103946:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
8010394c:	8b 40 10             	mov    0x10(%eax),%eax
8010394f:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103953:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
80103957:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
8010395d:	8b 40 10             	mov    0x10(%eax),%eax
80103960:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103964:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
80103968:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
8010396e:	8b 40 10             	mov    0x10(%eax),%eax
80103971:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
80103978:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
8010397e:	8b 40 10             	mov    0x10(%eax),%eax
80103981:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
80103988:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
8010398e:	8b 40 10             	mov    0x10(%eax),%eax
80103991:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103998:	8d 43 60             	lea    0x60(%ebx),%eax
8010399b:	6a 10                	push   $0x10
8010399d:	68 59 79 10 80       	push   $0x80107959
801039a2:	50                   	push   %eax
801039a3:	e8 68 11 00 00       	call   80104b10 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
801039a8:	83 c4 0c             	add    $0xc,%esp
801039ab:	6a 10                	push   $0x10
801039ad:	68 62 79 10 80       	push   $0x80107962
801039b2:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039b8:	83 c0 24             	add    $0x24,%eax
801039bb:	50                   	push   %eax
801039bc:	e8 4f 11 00 00       	call   80104b10 <safestrcpy>
    p->mainThread->cwd = namei("/");
801039c1:	8b b3 f0 03 00 00    	mov    0x3f0(%ebx),%esi
801039c7:	c7 04 24 6d 79 10 80 	movl   $0x8010796d,(%esp)
801039ce:	e8 2d e5 ff ff       	call   80101f00 <namei>
801039d3:	89 46 20             	mov    %eax,0x20(%esi)
    acquire(&ptable.lock);
801039d6:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801039dd:	e8 0e 0e 00 00       	call   801047f0 <acquire>
    p->mainThread->state = RUNNABLE;
801039e2:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
    p->state = RUNNABLE;
801039e8:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
801039ef:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
801039f6:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801039fd:	e8 ae 0e 00 00       	call   801048b0 <release>
    cprintf("DONE USERINIT");
80103a02:	c7 04 24 6f 79 10 80 	movl   $0x8010796f,(%esp)
80103a09:	e8 52 cc ff ff       	call   80100660 <cprintf>
}
80103a0e:	83 c4 10             	add    $0x10,%esp
80103a11:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a14:	5b                   	pop    %ebx
80103a15:	5e                   	pop    %esi
80103a16:	5d                   	pop    %ebp
80103a17:	c3                   	ret    
        panic("userinit: out of memory?");
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	68 40 79 10 80       	push   $0x80107940
80103a20:	e8 6b c9 ff ff       	call   80100390 <panic>
80103a25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a30 <growproc>:
growproc(int n) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
80103a35:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103a38:	e8 e3 0c 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103a3d:	e8 8e fd ff ff       	call   801037d0 <mycpu>
    p = c->proc;
80103a42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103a48:	e8 13 0d 00 00       	call   80104760 <popcli>
    cprintf(" GROWPROC APPLYED ");
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	68 7d 79 10 80       	push   $0x8010797d
80103a55:	e8 06 cc ff ff       	call   80100660 <cprintf>
    if (n > 0) {
80103a5a:	83 c4 10             	add    $0x10,%esp
80103a5d:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103a60:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103a62:	7f 1c                	jg     80103a80 <growproc+0x50>
    } else if (n < 0) {
80103a64:	75 3a                	jne    80103aa0 <growproc+0x70>
    switchuvm(curproc);
80103a66:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103a69:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103a6b:	53                   	push   %ebx
80103a6c:	e8 5f 32 00 00       	call   80106cd0 <switchuvm>
    return 0;
80103a71:	83 c4 10             	add    $0x10,%esp
80103a74:	31 c0                	xor    %eax,%eax
}
80103a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a79:	5b                   	pop    %ebx
80103a7a:	5e                   	pop    %esi
80103a7b:	5d                   	pop    %ebp
80103a7c:	c3                   	ret    
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a80:	83 ec 04             	sub    $0x4,%esp
80103a83:	01 c6                	add    %eax,%esi
80103a85:	56                   	push   %esi
80103a86:	50                   	push   %eax
80103a87:	ff 73 04             	pushl  0x4(%ebx)
80103a8a:	e8 a1 34 00 00       	call   80106f30 <allocuvm>
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	85 c0                	test   %eax,%eax
80103a94:	75 d0                	jne    80103a66 <growproc+0x36>
            return -1;
80103a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a9b:	eb d9                	jmp    80103a76 <growproc+0x46>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aa0:	83 ec 04             	sub    $0x4,%esp
80103aa3:	01 c6                	add    %eax,%esi
80103aa5:	56                   	push   %esi
80103aa6:	50                   	push   %eax
80103aa7:	ff 73 04             	pushl  0x4(%ebx)
80103aaa:	e8 b1 35 00 00       	call   80107060 <deallocuvm>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 b0                	jne    80103a66 <growproc+0x36>
80103ab6:	eb de                	jmp    80103a96 <growproc+0x66>
80103ab8:	90                   	nop
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <fork>:
fork(void) {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 28             	sub    $0x28,%esp
    cprintf( " FORK ");
80103ac9:	68 90 79 10 80       	push   $0x80107990
80103ace:	e8 8d cb ff ff       	call   80100660 <cprintf>
    pushcli();
80103ad3:	e8 48 0c 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103ad8:	e8 f3 fc ff ff       	call   801037d0 <mycpu>
    p = c->proc;
80103add:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
80103ae3:	89 7d e0             	mov    %edi,-0x20(%ebp)
    popcli();
80103ae6:	e8 75 0c 00 00       	call   80104760 <popcli>
    pushcli();
80103aeb:	e8 30 0c 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103af0:	e8 db fc ff ff       	call   801037d0 <mycpu>
    t = c->currThread;
80103af5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103afb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103afe:	e8 5d 0c 00 00       	call   80104760 <popcli>
    if ((np = allocproc()) == 0) {
80103b03:	e8 08 fb ff ff       	call   80103610 <allocproc>
80103b08:	83 c4 10             	add    $0x10,%esp
80103b0b:	85 c0                	test   %eax,%eax
80103b0d:	0f 84 fd 00 00 00    	je     80103c10 <fork+0x150>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103b13:	83 ec 08             	sub    $0x8,%esp
80103b16:	ff 37                	pushl  (%edi)
80103b18:	ff 77 04             	pushl  0x4(%edi)
80103b1b:	89 c3                	mov    %eax,%ebx
80103b1d:	e8 be 36 00 00       	call   801071e0 <copyuvm>
80103b22:	83 c4 10             	add    $0x10,%esp
80103b25:	85 c0                	test   %eax,%eax
80103b27:	89 43 04             	mov    %eax,0x4(%ebx)
80103b2a:	0f 84 e7 00 00 00    	je     80103c17 <fork+0x157>
    np->sz = curproc->sz;
80103b30:	8b 55 e0             	mov    -0x20(%ebp),%edx
    *np->mainThread->tf = *curthread->tf;
80103b33:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103b38:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103b3a:	89 53 10             	mov    %edx,0x10(%ebx)
    np->sz = curproc->sz;
80103b3d:	89 03                	mov    %eax,(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b42:	8b 70 10             	mov    0x10(%eax),%esi
80103b45:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103b4b:	8b 40 10             	mov    0x10(%eax),%eax
80103b4e:	89 c7                	mov    %eax,%edi
80103b50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103b52:	31 f6                	xor    %esi,%esi
80103b54:	89 d7                	mov    %edx,%edi
    np->mainThread->tf->eax = 0;
80103b56:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103b5c:	8b 40 10             	mov    0x10(%eax),%eax
80103b5f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103b66:	8d 76 00             	lea    0x0(%esi),%esi
80103b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (curproc->ofile[i])
80103b70:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103b74:	85 c0                	test   %eax,%eax
80103b76:	74 10                	je     80103b88 <fork+0xc8>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103b78:	83 ec 0c             	sub    $0xc,%esp
80103b7b:	50                   	push   %eax
80103b7c:	e8 7f d2 ff ff       	call   80100e00 <filedup>
80103b81:	83 c4 10             	add    $0x10,%esp
80103b84:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103b88:	83 c6 01             	add    $0x1,%esi
80103b8b:	83 fe 10             	cmp    $0x10,%esi
80103b8e:	75 e0                	jne    80103b70 <fork+0xb0>
    np->mainThread->cwd = idup(curthread->cwd);
80103b90:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103b93:	8b b3 f0 03 00 00    	mov    0x3f0(%ebx),%esi
80103b99:	83 ec 0c             	sub    $0xc,%esp
80103b9c:	ff 77 20             	pushl  0x20(%edi)
80103b9f:	e8 cc da ff ff       	call   80101670 <idup>
80103ba4:	89 46 20             	mov    %eax,0x20(%esi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103baa:	83 c4 0c             	add    $0xc,%esp
80103bad:	6a 10                	push   $0x10
80103baf:	83 c0 60             	add    $0x60,%eax
80103bb2:	50                   	push   %eax
80103bb3:	8d 43 60             	lea    0x60(%ebx),%eax
80103bb6:	50                   	push   %eax
80103bb7:	e8 54 0f 00 00       	call   80104b10 <safestrcpy>
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103bbc:	8d 47 24             	lea    0x24(%edi),%eax
80103bbf:	83 c4 0c             	add    $0xc,%esp
80103bc2:	6a 10                	push   $0x10
80103bc4:	50                   	push   %eax
80103bc5:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103bcb:	83 c0 24             	add    $0x24,%eax
80103bce:	50                   	push   %eax
80103bcf:	e8 3c 0f 00 00       	call   80104b10 <safestrcpy>
    pid = np->pid;
80103bd4:	8b 73 0c             	mov    0xc(%ebx),%esi
    acquire(&ptable.lock);
80103bd7:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103bde:	e8 0d 0c 00 00       	call   801047f0 <acquire>
    np->mainThread->state = RUNNABLE;
80103be3:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
    np->state = RUNNABLE;
80103be9:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    np->mainThread->state = RUNNABLE;
80103bf0:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103bf7:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103bfe:	e8 ad 0c 00 00       	call   801048b0 <release>
    return pid;
80103c03:	83 c4 10             	add    $0x10,%esp
}
80103c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c09:	89 f0                	mov    %esi,%eax
80103c0b:	5b                   	pop    %ebx
80103c0c:	5e                   	pop    %esi
80103c0d:	5f                   	pop    %edi
80103c0e:	5d                   	pop    %ebp
80103c0f:	c3                   	ret    
        return -1;
80103c10:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103c15:	eb ef                	jmp    80103c06 <fork+0x146>
        kfree(np->mainThread->tkstack);
80103c17:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103c1d:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103c20:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->mainThread->tkstack);
80103c25:	ff 70 04             	pushl  0x4(%eax)
80103c28:	e8 03 e7 ff ff       	call   80102330 <kfree>
        np->mainThread->tkstack = 0;
80103c2d:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
        return -1;
80103c33:	83 c4 10             	add    $0x10,%esp
        np->mainThread->tkstack = 0;
80103c36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->mainThread->state = UNUSED;
80103c3d:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
        np->state = UNUSED;
80103c43:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103c4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103c51:	eb b3                	jmp    80103c06 <fork+0x146>
80103c53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c60 <scheduler>:
scheduler(void) {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 28             	sub    $0x28,%esp
    cprintf( " SCHEDULER ");
80103c69:	68 97 79 10 80       	push   $0x80107997
80103c6e:	e8 ed c9 ff ff       	call   80100660 <cprintf>
    struct cpu *c = mycpu();
80103c73:	e8 58 fb ff ff       	call   801037d0 <mycpu>
    c->proc = 0;
80103c78:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c7f:	00 00 00 
    struct cpu *c = mycpu();
80103c82:	89 c6                	mov    %eax,%esi
80103c84:	8d 40 04             	lea    0x4(%eax),%eax
    c->proc = 0;
80103c87:	83 c4 10             	add    $0x10,%esp
80103c8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c90:	fb                   	sti    
        acquire(&ptable.lock);
80103c91:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103c94:	bf 74 2d 11 80       	mov    $0x80112d74,%edi
        acquire(&ptable.lock);
80103c99:	68 40 2d 11 80       	push   $0x80112d40
80103c9e:	e8 4d 0b 00 00       	call   801047f0 <acquire>
80103ca3:	83 c4 10             	add    $0x10,%esp
80103ca6:	eb 1a                	jmp    80103cc2 <scheduler+0x62>
80103ca8:	90                   	nop
80103ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103cb0:	81 c7 fc 03 00 00    	add    $0x3fc,%edi
80103cb6:	81 ff 74 2c 12 80    	cmp    $0x80122c74,%edi
80103cbc:	0f 83 af 00 00 00    	jae    80103d71 <scheduler+0x111>
           if ( p->state != RUNNABLE )
80103cc2:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103cc6:	75 e8                	jne    80103cb0 <scheduler+0x50>
            cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
80103cc8:	0f b6 16             	movzbl (%esi),%edx
80103ccb:	83 ec 04             	sub    $0x4,%esp
80103cce:	8d 5f 70             	lea    0x70(%edi),%ebx
80103cd1:	52                   	push   %edx
80103cd2:	ff 77 0c             	pushl  0xc(%edi)
80103cd5:	68 c8 7a 10 80       	push   $0x80107ac8
80103cda:	e8 81 c9 ff ff       	call   80100660 <cprintf>
            c->proc = p;
80103cdf:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
            switchuvm(p);
80103ce5:	89 3c 24             	mov    %edi,(%esp)
80103ce8:	e8 e3 2f 00 00       	call   80106cd0 <switchuvm>
80103ced:	8d 97 f0 03 00 00    	lea    0x3f0(%edi),%edx
80103cf3:	83 c4 10             	add    $0x10,%esp
80103cf6:	8d 76 00             	lea    0x0(%esi),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                if(t->state != RUNNABLE)
80103d00:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103d04:	75 3e                	jne    80103d44 <scheduler+0xe4>
                if(t->killed != 1){
80103d06:	83 7b 1c 01          	cmpl   $0x1,0x1c(%ebx)
80103d0a:	74 38                	je     80103d44 <scheduler+0xe4>
                    cprintf("\n  FOUND TRED TO RUN %d" , t->tid);
80103d0c:	83 ec 08             	sub    $0x8,%esp
80103d0f:	ff 73 0c             	pushl  0xc(%ebx)
80103d12:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103d15:	68 a3 79 10 80       	push   $0x801079a3
80103d1a:	e8 41 c9 ff ff       	call   80100660 <cprintf>
                    t->state = RUNNING;
80103d1f:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)
                    c->currThread=t;
80103d26:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)
                    swtch(&(c->scheduler), t->context);
80103d2c:	58                   	pop    %eax
80103d2d:	5a                   	pop    %edx
80103d2e:	ff 73 14             	pushl  0x14(%ebx)
80103d31:	ff 75 e0             	pushl  -0x20(%ebp)
80103d34:	e8 32 0e 00 00       	call   80104b6b <swtch>
                    switchkvm();
80103d39:	e8 72 2f 00 00       	call   80106cb0 <switchkvm>
80103d3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d41:	83 c4 10             	add    $0x10,%esp
            for (t = p->thread; t < &p->thread[NTHREADS]; t++){
80103d44:	83 c3 38             	add    $0x38,%ebx
80103d47:	39 da                	cmp    %ebx,%edx
80103d49:	77 b5                	ja     80103d00 <scheduler+0xa0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d4b:	81 c7 fc 03 00 00    	add    $0x3fc,%edi
            c->proc = 0;
80103d51:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d58:	00 00 00 
            c->currThread = 0;
80103d5b:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103d62:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d65:	81 ff 74 2c 12 80    	cmp    $0x80122c74,%edi
80103d6b:	0f 82 51 ff ff ff    	jb     80103cc2 <scheduler+0x62>
        release(&ptable.lock);
80103d71:	83 ec 0c             	sub    $0xc,%esp
80103d74:	68 40 2d 11 80       	push   $0x80112d40
80103d79:	e8 32 0b 00 00       	call   801048b0 <release>
        sti();
80103d7e:	83 c4 10             	add    $0x10,%esp
80103d81:	e9 0a ff ff ff       	jmp    80103c90 <scheduler+0x30>
80103d86:	8d 76 00             	lea    0x0(%esi),%esi
80103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d90 <sched>:
sched(void) {
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
    cprintf( " SCHED ");
80103d95:	83 ec 0c             	sub    $0xc,%esp
80103d98:	68 bb 79 10 80       	push   $0x801079bb
80103d9d:	e8 be c8 ff ff       	call   80100660 <cprintf>
    pushcli();
80103da2:	e8 79 09 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103da7:	e8 24 fa ff ff       	call   801037d0 <mycpu>
    t = c->currThread;
80103dac:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103db2:	e8 a9 09 00 00       	call   80104760 <popcli>
    if (!holding(&ptable.lock))
80103db7:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103dbe:	e8 fd 09 00 00       	call   801047c0 <holding>
80103dc3:	83 c4 10             	add    $0x10,%esp
80103dc6:	85 c0                	test   %eax,%eax
80103dc8:	74 4f                	je     80103e19 <sched+0x89>
    if (mycpu()->ncli != 1)
80103dca:	e8 01 fa ff ff       	call   801037d0 <mycpu>
80103dcf:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dd6:	75 68                	jne    80103e40 <sched+0xb0>
    if (t->state == RUNNING)
80103dd8:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103ddc:	74 55                	je     80103e33 <sched+0xa3>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dde:	9c                   	pushf  
80103ddf:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103de0:	f6 c4 02             	test   $0x2,%ah
80103de3:	75 41                	jne    80103e26 <sched+0x96>
    intena = mycpu()->intena;
80103de5:	e8 e6 f9 ff ff       	call   801037d0 <mycpu>
    swtch(&t->context, mycpu()->scheduler);
80103dea:	83 c3 14             	add    $0x14,%ebx
    intena = mycpu()->intena;
80103ded:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&t->context, mycpu()->scheduler);
80103df3:	e8 d8 f9 ff ff       	call   801037d0 <mycpu>
80103df8:	83 ec 08             	sub    $0x8,%esp
80103dfb:	ff 70 04             	pushl  0x4(%eax)
80103dfe:	53                   	push   %ebx
80103dff:	e8 67 0d 00 00       	call   80104b6b <swtch>
    mycpu()->intena = intena;
80103e04:	e8 c7 f9 ff ff       	call   801037d0 <mycpu>
}
80103e09:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80103e0c:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e15:	5b                   	pop    %ebx
80103e16:	5e                   	pop    %esi
80103e17:	5d                   	pop    %ebp
80103e18:	c3                   	ret    
        panic("sched ptable.lock");
80103e19:	83 ec 0c             	sub    $0xc,%esp
80103e1c:	68 c3 79 10 80       	push   $0x801079c3
80103e21:	e8 6a c5 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
80103e26:	83 ec 0c             	sub    $0xc,%esp
80103e29:	68 ef 79 10 80       	push   $0x801079ef
80103e2e:	e8 5d c5 ff ff       	call   80100390 <panic>
        panic("sched running");
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	68 e1 79 10 80       	push   $0x801079e1
80103e3b:	e8 50 c5 ff ff       	call   80100390 <panic>
        panic("sched locks");
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	68 d5 79 10 80       	push   $0x801079d5
80103e48:	e8 43 c5 ff ff       	call   80100390 <panic>
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi

80103e50 <yield>:
yield(void) {
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103e57:	68 40 2d 11 80       	push   $0x80112d40
80103e5c:	e8 8f 09 00 00       	call   801047f0 <acquire>
    pushcli();
80103e61:	e8 ba 08 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103e66:	e8 65 f9 ff ff       	call   801037d0 <mycpu>
    t = c->currThread;
80103e6b:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103e71:	e8 ea 08 00 00       	call   80104760 <popcli>
    mythread()->state = RUNNABLE;
80103e76:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103e7d:	e8 0e ff ff ff       	call   80103d90 <sched>
    release(&ptable.lock);
80103e82:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e89:	e8 22 0a 00 00       	call   801048b0 <release>
}
80103e8e:	83 c4 10             	add    $0x10,%esp
80103e91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e94:	c9                   	leave  
80103e95:	c3                   	ret    
80103e96:	8d 76 00             	lea    0x0(%esi),%esi
80103e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ea0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	57                   	push   %edi
80103ea4:	56                   	push   %esi
80103ea5:	53                   	push   %ebx
80103ea6:	83 ec 28             	sub    $0x28,%esp
80103ea9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103eac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    cprintf( " SLEEP ");
80103eaf:	68 03 7a 10 80       	push   $0x80107a03
80103eb4:	e8 a7 c7 ff ff       	call   80100660 <cprintf>
    pushcli();
80103eb9:	e8 62 08 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103ebe:	e8 0d f9 ff ff       	call   801037d0 <mycpu>
    p = c->proc;
80103ec3:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103ec9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103ecc:	e8 8f 08 00 00       	call   80104760 <popcli>
    pushcli();
80103ed1:	e8 4a 08 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103ed6:	e8 f5 f8 ff ff       	call   801037d0 <mycpu>
    t = c->currThread;
80103edb:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103ee1:	e8 7a 08 00 00       	call   80104760 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103ee6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ee9:	83 c4 10             	add    $0x10,%esp
80103eec:	85 d2                	test   %edx,%edx
80103eee:	0f 84 87 00 00 00    	je     80103f7b <sleep+0xdb>
        panic("sleep");

    if (lk == 0)
80103ef4:	85 db                	test   %ebx,%ebx
80103ef6:	74 76                	je     80103f6e <sleep+0xce>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if( lk != &ptable.lock ){
80103ef8:	81 fb 40 2d 11 80    	cmp    $0x80112d40,%ebx
80103efe:	74 50                	je     80103f50 <sleep+0xb0>
        acquire(&ptable.lock );
80103f00:	83 ec 0c             	sub    $0xc,%esp
80103f03:	68 40 2d 11 80       	push   $0x80112d40
80103f08:	e8 e3 08 00 00       	call   801047f0 <acquire>
        release(lk);
80103f0d:	89 1c 24             	mov    %ebx,(%esp)
80103f10:	e8 9b 09 00 00       	call   801048b0 <release>
    }
     // Go to sleep.
    t->chan = chan;
80103f15:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103f18:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103f1f:	e8 6c fe ff ff       	call   80103d90 <sched>

    // Tidy up.
    t->chan = 0;
80103f24:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80103f2b:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103f32:	e8 79 09 00 00       	call   801048b0 <release>
        acquire(lk);
80103f37:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103f3a:	83 c4 10             	add    $0x10,%esp
    }
}
80103f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f40:	5b                   	pop    %ebx
80103f41:	5e                   	pop    %esi
80103f42:	5f                   	pop    %edi
80103f43:	5d                   	pop    %ebp
        acquire(lk);
80103f44:	e9 a7 08 00 00       	jmp    801047f0 <acquire>
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    t->chan = chan;
80103f50:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103f53:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)
    sched();
80103f5a:	e8 31 fe ff ff       	call   80103d90 <sched>
    t->chan = 0;
80103f5f:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
}
80103f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f69:	5b                   	pop    %ebx
80103f6a:	5e                   	pop    %esi
80103f6b:	5f                   	pop    %edi
80103f6c:	5d                   	pop    %ebp
80103f6d:	c3                   	ret    
        panic("sleep without lk");
80103f6e:	83 ec 0c             	sub    $0xc,%esp
80103f71:	68 11 7a 10 80       	push   $0x80107a11
80103f76:	e8 15 c4 ff ff       	call   80100390 <panic>
        panic("sleep");
80103f7b:	83 ec 0c             	sub    $0xc,%esp
80103f7e:	68 0b 7a 10 80       	push   $0x80107a0b
80103f83:	e8 08 c4 ff ff       	call   80100390 <panic>
80103f88:	90                   	nop
80103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f90 <exit>:
exit(void) {
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	57                   	push   %edi
80103f94:	56                   	push   %esi
80103f95:	53                   	push   %ebx
80103f96:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103f99:	e8 82 07 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103f9e:	e8 2d f8 ff ff       	call   801037d0 <mycpu>
    p = c->proc;
80103fa3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80103fa9:	e8 b2 07 00 00       	call   80104760 <popcli>
    pushcli();
80103fae:	e8 6d 07 00 00       	call   80104720 <pushcli>
    c = mycpu();
80103fb3:	e8 18 f8 ff ff       	call   801037d0 <mycpu>
    t = c->currThread;
80103fb8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103fbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103fc1:	e8 9a 07 00 00       	call   80104760 <popcli>
    cprintf("EXIT");
80103fc6:	83 ec 0c             	sub    $0xc,%esp
80103fc9:	68 22 7a 10 80       	push   $0x80107a22
80103fce:	e8 8d c6 ff ff       	call   80100660 <cprintf>
    if (curproc == initproc)
80103fd3:	83 c4 10             	add    $0x10,%esp
80103fd6:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103fdc:	0f 84 f6 01 00 00    	je     801041d8 <exit+0x248>
    acquire(&ptable.lock);
80103fe2:	83 ec 0c             	sub    $0xc,%esp
    curproc->exited=1;
80103fe5:	c7 86 f8 03 00 00 01 	movl   $0x1,0x3f8(%esi)
80103fec:	00 00 00 
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80103fef:	8d 5e 70             	lea    0x70(%esi),%ebx
    acquire(&ptable.lock);
80103ff2:	68 40 2d 11 80       	push   $0x80112d40
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80103ff7:	8d be f0 03 00 00    	lea    0x3f0(%esi),%edi
    acquire(&ptable.lock);
80103ffd:	e8 ee 07 00 00       	call   801047f0 <acquire>
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80104002:	89 75 e0             	mov    %esi,-0x20(%ebp)
80104005:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	90                   	nop
8010400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(t != curthread) {
80104010:	39 de                	cmp    %ebx,%esi
80104012:	74 1e                	je     80104032 <exit+0xa2>
            if(t->state == RUNNING) {
80104014:	8b 43 08             	mov    0x8(%ebx),%eax
            t->killed = 1;
80104017:	c7 43 1c 01 00 00 00 	movl   $0x1,0x1c(%ebx)
            if(t->state == RUNNING) {
8010401e:	83 f8 04             	cmp    $0x4,%eax
80104021:	0f 84 77 01 00 00    	je     8010419e <exit+0x20e>
            if(t->state != UNUSED)
80104027:	85 c0                	test   %eax,%eax
80104029:	74 07                	je     80104032 <exit+0xa2>
                t->state = ZOMBIE;
8010402b:	c7 43 08 05 00 00 00 	movl   $0x5,0x8(%ebx)
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80104032:	83 c3 38             	add    $0x38,%ebx
80104035:	39 fb                	cmp    %edi,%ebx
80104037:	72 d7                	jb     80104010 <exit+0x80>
80104039:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010403c:	8d 7e 20             	lea    0x20(%esi),%edi
8010403f:	8d 5e 60             	lea    0x60(%esi),%ebx
80104042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (curproc->ofile[fd]) {
80104048:	8b 07                	mov    (%edi),%eax
8010404a:	85 c0                	test   %eax,%eax
8010404c:	74 12                	je     80104060 <exit+0xd0>
            fileclose(curproc->ofile[fd]);
8010404e:	83 ec 0c             	sub    $0xc,%esp
80104051:	50                   	push   %eax
80104052:	e8 f9 cd ff ff       	call   80100e50 <fileclose>
            curproc->ofile[fd] = 0;
80104057:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010405d:	83 c4 10             	add    $0x10,%esp
80104060:	83 c7 04             	add    $0x4,%edi
    for (fd = 0; fd < NOFILE; fd++) {
80104063:	39 fb                	cmp    %edi,%ebx
80104065:	75 e1                	jne    80104048 <exit+0xb8>
    if(holding(&ptable.lock))
80104067:	83 ec 0c             	sub    $0xc,%esp
8010406a:	68 40 2d 11 80       	push   $0x80112d40
8010406f:	e8 4c 07 00 00       	call   801047c0 <holding>
80104074:	83 c4 10             	add    $0x10,%esp
80104077:	85 c0                	test   %eax,%eax
80104079:	0f 85 44 01 00 00    	jne    801041c3 <exit+0x233>
    begin_op();
8010407f:	e8 1c eb ff ff       	call   80102ba0 <begin_op>
    iput(curthread->cwd);
80104084:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104087:	83 ec 0c             	sub    $0xc,%esp
8010408a:	ff 77 20             	pushl  0x20(%edi)
8010408d:	e8 3e d7 ff ff       	call   801017d0 <iput>
    end_op();
80104092:	e8 79 eb ff ff       	call   80102c10 <end_op>
    curthread->cwd = 0;
80104097:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)
    acquire(&ptable.lock);
8010409e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801040a5:	e8 46 07 00 00       	call   801047f0 <acquire>
    wakeup1(curproc->parent);
801040aa:	8b 5e 10             	mov    0x10(%esi),%ebx
801040ad:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct  thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040b0:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
801040b5:	eb 17                	jmp    801040ce <exit+0x13e>
801040b7:	89 f6                	mov    %esi,%esi
801040b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801040c0:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
801040c6:	81 fa 74 2c 12 80    	cmp    $0x80122c74,%edx
801040cc:	73 2d                	jae    801040fb <exit+0x16b>
        if( p->state != RUNNABLE )
801040ce:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801040d2:	75 ec                	jne    801040c0 <exit+0x130>
801040d4:	8d 42 70             	lea    0x70(%edx),%eax
801040d7:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
801040dd:	eb 08                	jmp    801040e7 <exit+0x157>
801040df:	90                   	nop
            continue;
        //acquire( p->procLock );
        for ( t = p->thread ; t < &p->thread[NTHREADS]; t++) {
801040e0:	83 c0 38             	add    $0x38,%eax
801040e3:	39 c1                	cmp    %eax,%ecx
801040e5:	76 d9                	jbe    801040c0 <exit+0x130>
            if (t->state == SLEEPING && t->chan == chan)
801040e7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801040eb:	75 f3                	jne    801040e0 <exit+0x150>
801040ed:	3b 58 18             	cmp    0x18(%eax),%ebx
801040f0:	75 ee                	jne    801040e0 <exit+0x150>
                t->state = RUNNABLE;
801040f2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801040f9:	eb e5                	jmp    801040e0 <exit+0x150>
            p->parent = initproc;
801040fb:	8b 3d b8 a5 10 80    	mov    0x8010a5b8,%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104101:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80104106:	eb 16                	jmp    8010411e <exit+0x18e>
80104108:	90                   	nop
80104109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104110:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
80104116:	81 fb 74 2c 12 80    	cmp    $0x80122c74,%ebx
8010411c:	73 5d                	jae    8010417b <exit+0x1eb>
        if (p->parent == curproc) {
8010411e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104121:	75 ed                	jne    80104110 <exit+0x180>
            if (p->state == ZOMBIE)
80104123:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
            p->parent = initproc;
80104127:	89 7b 10             	mov    %edi,0x10(%ebx)
            if (p->state == ZOMBIE)
8010412a:	75 e4                	jne    80104110 <exit+0x180>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010412c:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80104131:	eb 13                	jmp    80104146 <exit+0x1b6>
80104133:	90                   	nop
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104138:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
8010413e:	81 fa 74 2c 12 80    	cmp    $0x80122c74,%edx
80104144:	73 ca                	jae    80104110 <exit+0x180>
        if( p->state != RUNNABLE )
80104146:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
8010414a:	75 ec                	jne    80104138 <exit+0x1a8>
8010414c:	8d 42 70             	lea    0x70(%edx),%eax
8010414f:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
80104155:	eb 10                	jmp    80104167 <exit+0x1d7>
80104157:	89 f6                	mov    %esi,%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for ( t = p->thread ; t < &p->thread[NTHREADS]; t++) {
80104160:	83 c0 38             	add    $0x38,%eax
80104163:	39 c1                	cmp    %eax,%ecx
80104165:	76 d1                	jbe    80104138 <exit+0x1a8>
            if (t->state == SLEEPING && t->chan == chan)
80104167:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010416b:	75 f3                	jne    80104160 <exit+0x1d0>
8010416d:	3b 78 18             	cmp    0x18(%eax),%edi
80104170:	75 ee                	jne    80104160 <exit+0x1d0>
                t->state = RUNNABLE;
80104172:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104179:	eb e5                	jmp    80104160 <exit+0x1d0>
    curthread->state = ZOMBIE;
8010417b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010417e:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    curproc->state = ZOMBIE;
80104185:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
8010418c:	e8 ff fb ff ff       	call   80103d90 <sched>
    panic("zombie exit");
80104191:	83 ec 0c             	sub    $0xc,%esp
80104194:	68 46 7a 10 80       	push   $0x80107a46
80104199:	e8 f2 c1 ff ff       	call   80100390 <panic>
                cprintf("WAITING IN EXIT  ");
8010419e:	83 ec 0c             	sub    $0xc,%esp
801041a1:	68 34 7a 10 80       	push   $0x80107a34
801041a6:	e8 b5 c4 ff ff       	call   80100660 <cprintf>
                sleep( t , &ptable.lock );
801041ab:	58                   	pop    %eax
801041ac:	5a                   	pop    %edx
801041ad:	68 40 2d 11 80       	push   $0x80112d40
801041b2:	53                   	push   %ebx
801041b3:	e8 e8 fc ff ff       	call   80103ea0 <sleep>
801041b8:	8b 43 08             	mov    0x8(%ebx),%eax
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	e9 64 fe ff ff       	jmp    80104027 <exit+0x97>
        release(&ptable.lock);
801041c3:	83 ec 0c             	sub    $0xc,%esp
801041c6:	68 40 2d 11 80       	push   $0x80112d40
801041cb:	e8 e0 06 00 00       	call   801048b0 <release>
801041d0:	83 c4 10             	add    $0x10,%esp
801041d3:	e9 a7 fe ff ff       	jmp    8010407f <exit+0xef>
        panic("init exiting");
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 27 7a 10 80       	push   $0x80107a27
801041e0:	e8 ab c1 ff ff       	call   80100390 <panic>
801041e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <wait>:
wait(void) {
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	53                   	push   %ebx
801041f6:	83 ec 28             	sub    $0x28,%esp
    cprintf( " WAIT ");
801041f9:	68 52 7a 10 80       	push   $0x80107a52
801041fe:	e8 5d c4 ff ff       	call   80100660 <cprintf>
    pushcli();
80104203:	e8 18 05 00 00       	call   80104720 <pushcli>
    c = mycpu();
80104208:	e8 c3 f5 ff ff       	call   801037d0 <mycpu>
    p = c->proc;
8010420d:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104213:	e8 48 05 00 00       	call   80104760 <popcli>
    acquire(&ptable.lock);
80104218:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010421f:	e8 cc 05 00 00       	call   801047f0 <acquire>
80104224:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
80104227:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104229:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
8010422e:	eb 0e                	jmp    8010423e <wait+0x4e>
80104230:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
80104236:	81 fb 74 2c 12 80    	cmp    $0x80122c74,%ebx
8010423c:	73 1e                	jae    8010425c <wait+0x6c>
            if (p->parent != curproc)
8010423e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104241:	75 ed                	jne    80104230 <wait+0x40>
            if (p->state == ZOMBIE) {
80104243:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80104247:	74 57                	je     801042a0 <wait+0xb0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104249:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
            havekids = 1;
8010424f:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104254:	81 fb 74 2c 12 80    	cmp    $0x80122c74,%ebx
8010425a:	72 e2                	jb     8010423e <wait+0x4e>
        if (!havekids || curproc->killed) {
8010425c:	85 c0                	test   %eax,%eax
8010425e:	0f 84 dc 00 00 00    	je     80104340 <wait+0x150>
80104264:	8b 46 1c             	mov    0x1c(%esi),%eax
80104267:	85 c0                	test   %eax,%eax
80104269:	0f 85 d1 00 00 00    	jne    80104340 <wait+0x150>
    pushcli();
8010426f:	e8 ac 04 00 00       	call   80104720 <pushcli>
    c = mycpu();
80104274:	e8 57 f5 ff ff       	call   801037d0 <mycpu>
    t = c->currThread;
80104279:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
8010427f:	e8 dc 04 00 00       	call   80104760 <popcli>
        sleep(mythread(), &ptable.lock );  //DOC: wait-sleep
80104284:	83 ec 08             	sub    $0x8,%esp
80104287:	68 40 2d 11 80       	push   $0x80112d40
8010428c:	53                   	push   %ebx
8010428d:	e8 0e fc ff ff       	call   80103ea0 <sleep>
        havekids = 0;
80104292:	83 c4 10             	add    $0x10,%esp
80104295:	eb 90                	jmp    80104227 <wait+0x37>
80104297:	89 f6                	mov    %esi,%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                pid = p->pid;
801042a0:	8b 43 0c             	mov    0xc(%ebx),%eax
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801042a3:	8d 73 70             	lea    0x70(%ebx),%esi
801042a6:	8d bb f0 03 00 00    	lea    0x3f0(%ebx),%edi
                pid = p->pid;
801042ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042af:	eb 0e                	jmp    801042bf <wait+0xcf>
801042b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801042b8:	83 c6 38             	add    $0x38,%esi
801042bb:	39 f7                	cmp    %esi,%edi
801042bd:	76 3c                	jbe    801042fb <wait+0x10b>
                    if(t->state != UNUSED){
801042bf:	8b 56 08             	mov    0x8(%esi),%edx
801042c2:	85 d2                	test   %edx,%edx
801042c4:	74 f2                	je     801042b8 <wait+0xc8>
                        kfree(t->tkstack);
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	ff 76 04             	pushl  0x4(%esi)
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801042cc:	83 c6 38             	add    $0x38,%esi
                        kfree(t->tkstack);
801042cf:	e8 5c e0 ff ff       	call   80102330 <kfree>
                        t->tkstack = 0;
801042d4:	c7 46 cc 00 00 00 00 	movl   $0x0,-0x34(%esi)
                        t->state=UNUSED;
801042db:	c7 46 d0 00 00 00 00 	movl   $0x0,-0x30(%esi)
                        t->killed=0;
801042e2:	83 c4 10             	add    $0x10,%esp
                        t->tid=0;
801042e5:	c7 46 d4 00 00 00 00 	movl   $0x0,-0x2c(%esi)
                        t->name[0] = 0;
801042ec:	c6 46 ec 00          	movb   $0x0,-0x14(%esi)
                        t->killed=0;
801042f0:	c7 46 e4 00 00 00 00 	movl   $0x0,-0x1c(%esi)
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801042f7:	39 f7                	cmp    %esi,%edi
801042f9:	77 c4                	ja     801042bf <wait+0xcf>
                freevm(p->pgdir);
801042fb:	83 ec 0c             	sub    $0xc,%esp
801042fe:	ff 73 04             	pushl  0x4(%ebx)
80104301:	e8 8a 2d 00 00       	call   80107090 <freevm>
                p->pid = 0;
80104306:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
8010430d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
80104314:	c6 43 60 00          	movb   $0x0,0x60(%ebx)
                p->killed = 0;
80104318:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
8010431f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
80104326:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010432d:	e8 7e 05 00 00       	call   801048b0 <release>
                return pid;
80104332:	83 c4 10             	add    $0x10,%esp
}
80104335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104338:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010433b:	5b                   	pop    %ebx
8010433c:	5e                   	pop    %esi
8010433d:	5f                   	pop    %edi
8010433e:	5d                   	pop    %ebp
8010433f:	c3                   	ret    
            release(&ptable.lock);
80104340:	83 ec 0c             	sub    $0xc,%esp
80104343:	68 40 2d 11 80       	push   $0x80112d40
80104348:	e8 63 05 00 00       	call   801048b0 <release>
            return -1;
8010434d:	83 c4 10             	add    $0x10,%esp
80104350:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104357:	eb dc                	jmp    80104335 <wait+0x145>
80104359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104360 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf( " WAKEUP ");
8010436a:	68 59 7a 10 80       	push   $0x80107a59
8010436f:	e8 ec c2 ff ff       	call   80100660 <cprintf>
    acquire(&ptable.lock);
80104374:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010437b:	e8 70 04 00 00       	call   801047f0 <acquire>
80104380:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104383:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80104388:	eb 14                	jmp    8010439e <wakeup+0x3e>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104390:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
80104396:	81 fa 74 2c 12 80    	cmp    $0x80122c74,%edx
8010439c:	73 2d                	jae    801043cb <wakeup+0x6b>
        if( p->state != RUNNABLE )
8010439e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801043a2:	75 ec                	jne    80104390 <wakeup+0x30>
801043a4:	8d 42 70             	lea    0x70(%edx),%eax
801043a7:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
801043ad:	eb 08                	jmp    801043b7 <wakeup+0x57>
801043af:	90                   	nop
        for ( t = p->thread ; t < &p->thread[NTHREADS]; t++) {
801043b0:	83 c0 38             	add    $0x38,%eax
801043b3:	39 c1                	cmp    %eax,%ecx
801043b5:	76 d9                	jbe    80104390 <wakeup+0x30>
            if (t->state == SLEEPING && t->chan == chan)
801043b7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801043bb:	75 f3                	jne    801043b0 <wakeup+0x50>
801043bd:	3b 58 18             	cmp    0x18(%eax),%ebx
801043c0:	75 ee                	jne    801043b0 <wakeup+0x50>
                t->state = RUNNABLE;
801043c2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801043c9:	eb e5                	jmp    801043b0 <wakeup+0x50>
    wakeup1(chan);
    release(&ptable.lock);
801043cb:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
801043d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d5:	c9                   	leave  
    release(&ptable.lock);
801043d6:	e9 d5 04 00 00       	jmp    801048b0 <release>
801043db:	90                   	nop
801043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043e0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 10             	sub    $0x10,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx

    cprintf( " KILL ");
801043ea:	68 62 7a 10 80       	push   $0x80107a62
801043ef:	e8 6c c2 ff ff       	call   80100660 <cprintf>
    struct proc *p;
    struct  thread *t;
    acquire(&ptable.lock);
801043f4:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801043fb:	e8 f0 03 00 00       	call   801047f0 <acquire>
80104400:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104403:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80104408:	eb 12                	jmp    8010441c <kill+0x3c>
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104410:	05 fc 03 00 00       	add    $0x3fc,%eax
80104415:	3d 74 2c 12 80       	cmp    $0x80122c74,%eax
8010441a:	73 64                	jae    80104480 <kill+0xa0>
        if (p->pid == pid) {
8010441c:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010441f:	75 ef                	jne    80104410 <kill+0x30>
            p->killed = 1;
            //turn on killed flags of the proc threads
            for ( t = p->thread ; t < &p->thread[NTHREADS]; t++)
80104421:	8d 50 70             	lea    0x70(%eax),%edx
80104424:	8d 88 f0 03 00 00    	lea    0x3f0(%eax),%ecx
            p->killed = 1;
8010442a:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
80104431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                t->killed=1;
80104438:	c7 42 1c 01 00 00 00 	movl   $0x1,0x1c(%edx)
            for ( t = p->thread ; t < &p->thread[NTHREADS]; t++)
8010443f:	83 c2 38             	add    $0x38,%edx
80104442:	39 d1                	cmp    %edx,%ecx
80104444:	77 f2                	ja     80104438 <kill+0x58>
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING){
80104446:	8b 90 f0 03 00 00    	mov    0x3f0(%eax),%edx
8010444c:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
80104450:	75 14                	jne    80104466 <kill+0x86>
                p->mainThread->state = RUNNABLE;
80104452:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
                p->mainThread->killed=0; //turn off this flag so that the main thread will exit the proc
80104459:	8b 80 f0 03 00 00    	mov    0x3f0(%eax),%eax
8010445f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
            }

            //release( p->procLock );
            release(&ptable.lock);
80104466:	83 ec 0c             	sub    $0xc,%esp
80104469:	68 40 2d 11 80       	push   $0x80112d40
8010446e:	e8 3d 04 00 00       	call   801048b0 <release>
            return 0;
80104473:	83 c4 10             	add    $0x10,%esp
80104476:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104478:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010447b:	c9                   	leave  
8010447c:	c3                   	ret    
8010447d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	68 40 2d 11 80       	push   $0x80112d40
80104488:	e8 23 04 00 00       	call   801048b0 <release>
    return -1;
8010448d:	83 c4 10             	add    $0x10,%esp
80104490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104498:	c9                   	leave  
80104499:	c3                   	ret    
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	53                   	push   %ebx
801044a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044a9:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
procdump(void) {
801044ae:	83 ec 3c             	sub    $0x3c,%esp
801044b1:	eb 27                	jmp    801044da <procdump+0x3a>
801044b3:	90                   	nop
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 17 7e 10 80       	push   $0x80107e17
801044c0:	e8 9b c1 ff ff       	call   80100660 <cprintf>
801044c5:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044c8:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
801044ce:	81 fb 74 2c 12 80    	cmp    $0x80122c74,%ebx
801044d4:	0f 83 96 00 00 00    	jae    80104570 <procdump+0xd0>
        if (p->state == UNUSED)
801044da:	8b 43 08             	mov    0x8(%ebx),%eax
801044dd:	85 c0                	test   %eax,%eax
801044df:	74 e7                	je     801044c8 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044e1:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
801044e4:	ba 69 7a 10 80       	mov    $0x80107a69,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044e9:	77 11                	ja     801044fc <procdump+0x5c>
801044eb:	8b 14 85 ec 7a 10 80 	mov    -0x7fef8514(,%eax,4),%edx
            state = "???";
801044f2:	b8 69 7a 10 80       	mov    $0x80107a69,%eax
801044f7:	85 d2                	test   %edx,%edx
801044f9:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
801044fc:	8d 43 60             	lea    0x60(%ebx),%eax
801044ff:	50                   	push   %eax
80104500:	52                   	push   %edx
80104501:	ff 73 0c             	pushl  0xc(%ebx)
80104504:	68 6d 7a 10 80       	push   $0x80107a6d
80104509:	e8 52 c1 ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
8010450e:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80104514:	83 c4 10             	add    $0x10,%esp
80104517:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010451b:	75 9b                	jne    801044b8 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
8010451d:	8d 4d c0             	lea    -0x40(%ebp),%ecx
80104520:	83 ec 08             	sub    $0x8,%esp
80104523:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104526:	51                   	push   %ecx
80104527:	8b 40 14             	mov    0x14(%eax),%eax
8010452a:	8b 40 0c             	mov    0xc(%eax),%eax
8010452d:	83 c0 08             	add    $0x8,%eax
80104530:	50                   	push   %eax
80104531:	e8 9a 01 00 00       	call   801046d0 <getcallerpcs>
80104536:	83 c4 10             	add    $0x10,%esp
80104539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104540:	8b 17                	mov    (%edi),%edx
80104542:	85 d2                	test   %edx,%edx
80104544:	0f 84 6e ff ff ff    	je     801044b8 <procdump+0x18>
                cprintf(" %p", pc[i]);
8010454a:	83 ec 08             	sub    $0x8,%esp
8010454d:	83 c7 04             	add    $0x4,%edi
80104550:	52                   	push   %edx
80104551:	68 01 74 10 80       	push   $0x80107401
80104556:	e8 05 c1 ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
8010455b:	83 c4 10             	add    $0x10,%esp
8010455e:	39 fe                	cmp    %edi,%esi
80104560:	75 de                	jne    80104540 <procdump+0xa0>
80104562:	e9 51 ff ff ff       	jmp    801044b8 <procdump+0x18>
80104567:	89 f6                	mov    %esi,%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
80104570:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104573:	5b                   	pop    %ebx
80104574:	5e                   	pop    %esi
80104575:	5f                   	pop    %edi
80104576:	5d                   	pop    %ebp
80104577:	c3                   	ret    
80104578:	66 90                	xchg   %ax,%ax
8010457a:	66 90                	xchg   %ax,%ax
8010457c:	66 90                	xchg   %ax,%ax
8010457e:	66 90                	xchg   %ax,%ax

80104580 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010458a:	68 04 7b 10 80       	push   $0x80107b04
8010458f:	8d 43 04             	lea    0x4(%ebx),%eax
80104592:	50                   	push   %eax
80104593:	e8 18 01 00 00       	call   801046b0 <initlock>
  lk->name = name;
80104598:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010459b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b1:	c9                   	leave  
801045b2:	c3                   	ret    
801045b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	8d 73 04             	lea    0x4(%ebx),%esi
801045ce:	56                   	push   %esi
801045cf:	e8 1c 02 00 00       	call   801047f0 <acquire>
  while (lk->locked) {
801045d4:	8b 13                	mov    (%ebx),%edx
801045d6:	83 c4 10             	add    $0x10,%esp
801045d9:	85 d2                	test   %edx,%edx
801045db:	74 16                	je     801045f3 <acquiresleep+0x33>
801045dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045e0:	83 ec 08             	sub    $0x8,%esp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	e8 b6 f8 ff ff       	call   80103ea0 <sleep>
  while (lk->locked) {
801045ea:	8b 03                	mov    (%ebx),%eax
801045ec:	83 c4 10             	add    $0x10,%esp
801045ef:	85 c0                	test   %eax,%eax
801045f1:	75 ed                	jne    801045e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045f9:	e8 72 f2 ff ff       	call   80103870 <myproc>
801045fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104601:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104604:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104607:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010460a:	5b                   	pop    %ebx
8010460b:	5e                   	pop    %esi
8010460c:	5d                   	pop    %ebp
  release(&lk->lk);
8010460d:	e9 9e 02 00 00       	jmp    801048b0 <release>
80104612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	8d 73 04             	lea    0x4(%ebx),%esi
8010462e:	56                   	push   %esi
8010462f:	e8 bc 01 00 00       	call   801047f0 <acquire>
  lk->locked = 0;
80104634:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010463a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104641:	89 1c 24             	mov    %ebx,(%esp)
80104644:	e8 17 fd ff ff       	call   80104360 <wakeup>
  release(&lk->lk);
80104649:	89 75 08             	mov    %esi,0x8(%ebp)
8010464c:	83 c4 10             	add    $0x10,%esp
}
8010464f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104652:	5b                   	pop    %ebx
80104653:	5e                   	pop    %esi
80104654:	5d                   	pop    %ebp
  release(&lk->lk);
80104655:	e9 56 02 00 00       	jmp    801048b0 <release>
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	56                   	push   %esi
80104665:	53                   	push   %ebx
80104666:	31 ff                	xor    %edi,%edi
80104668:	83 ec 18             	sub    $0x18,%esp
8010466b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010466e:	8d 73 04             	lea    0x4(%ebx),%esi
80104671:	56                   	push   %esi
80104672:	e8 79 01 00 00       	call   801047f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104677:	8b 03                	mov    (%ebx),%eax
80104679:	83 c4 10             	add    $0x10,%esp
8010467c:	85 c0                	test   %eax,%eax
8010467e:	74 13                	je     80104693 <holdingsleep+0x33>
80104680:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104683:	e8 e8 f1 ff ff       	call   80103870 <myproc>
80104688:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010468b:	0f 94 c0             	sete   %al
8010468e:	0f b6 c0             	movzbl %al,%eax
80104691:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104693:	83 ec 0c             	sub    $0xc,%esp
80104696:	56                   	push   %esi
80104697:	e8 14 02 00 00       	call   801048b0 <release>
  return r;
}
8010469c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010469f:	89 f8                	mov    %edi,%eax
801046a1:	5b                   	pop    %ebx
801046a2:	5e                   	pop    %esi
801046a3:	5f                   	pop    %edi
801046a4:	5d                   	pop    %ebp
801046a5:	c3                   	ret    
801046a6:	66 90                	xchg   %ax,%ax
801046a8:	66 90                	xchg   %ax,%ax
801046aa:	66 90                	xchg   %ax,%ax
801046ac:	66 90                	xchg   %ax,%ax
801046ae:	66 90                	xchg   %ax,%ax

801046b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046c9:	5d                   	pop    %ebp
801046ca:	c3                   	ret    
801046cb:	90                   	nop
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046d1:	31 d2                	xor    %edx,%edx
{
801046d3:	89 e5                	mov    %esp,%ebp
801046d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046dc:	83 e8 08             	sub    $0x8,%eax
801046df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046ec:	77 1a                	ja     80104708 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046ee:	8b 58 04             	mov    0x4(%eax),%ebx
801046f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046f9:	83 fa 0a             	cmp    $0xa,%edx
801046fc:	75 e2                	jne    801046e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046fe:	5b                   	pop    %ebx
801046ff:	5d                   	pop    %ebp
80104700:	c3                   	ret    
80104701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104708:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010470b:	83 c1 28             	add    $0x28,%ecx
8010470e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104716:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104719:	39 c1                	cmp    %eax,%ecx
8010471b:	75 f3                	jne    80104710 <getcallerpcs+0x40>
}
8010471d:	5b                   	pop    %ebx
8010471e:	5d                   	pop    %ebp
8010471f:	c3                   	ret    

80104720 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
80104727:	9c                   	pushf  
80104728:	5b                   	pop    %ebx
  asm volatile("cli");
80104729:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010472a:	e8 a1 f0 ff ff       	call   801037d0 <mycpu>
8010472f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104735:	85 c0                	test   %eax,%eax
80104737:	75 11                	jne    8010474a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104739:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010473f:	e8 8c f0 ff ff       	call   801037d0 <mycpu>
80104744:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010474a:	e8 81 f0 ff ff       	call   801037d0 <mycpu>
8010474f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104756:	83 c4 04             	add    $0x4,%esp
80104759:	5b                   	pop    %ebx
8010475a:	5d                   	pop    %ebp
8010475b:	c3                   	ret    
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <popcli>:

void
popcli(void)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104766:	9c                   	pushf  
80104767:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104768:	f6 c4 02             	test   $0x2,%ah
8010476b:	75 35                	jne    801047a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010476d:	e8 5e f0 ff ff       	call   801037d0 <mycpu>
80104772:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104779:	78 34                	js     801047af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010477b:	e8 50 f0 ff ff       	call   801037d0 <mycpu>
80104780:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104786:	85 d2                	test   %edx,%edx
80104788:	74 06                	je     80104790 <popcli+0x30>
    sti();
}
8010478a:	c9                   	leave  
8010478b:	c3                   	ret    
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104790:	e8 3b f0 ff ff       	call   801037d0 <mycpu>
80104795:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010479b:	85 c0                	test   %eax,%eax
8010479d:	74 eb                	je     8010478a <popcli+0x2a>
  asm volatile("sti");
8010479f:	fb                   	sti    
}
801047a0:	c9                   	leave  
801047a1:	c3                   	ret    
    panic("popcli - interruptible");
801047a2:	83 ec 0c             	sub    $0xc,%esp
801047a5:	68 0f 7b 10 80       	push   $0x80107b0f
801047aa:	e8 e1 bb ff ff       	call   80100390 <panic>
    panic("popcli");
801047af:	83 ec 0c             	sub    $0xc,%esp
801047b2:	68 26 7b 10 80       	push   $0x80107b26
801047b7:	e8 d4 bb ff ff       	call   80100390 <panic>
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <holding>:
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
801047c5:	8b 75 08             	mov    0x8(%ebp),%esi
801047c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047ca:	e8 51 ff ff ff       	call   80104720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047cf:	8b 06                	mov    (%esi),%eax
801047d1:	85 c0                	test   %eax,%eax
801047d3:	74 10                	je     801047e5 <holding+0x25>
801047d5:	8b 5e 08             	mov    0x8(%esi),%ebx
801047d8:	e8 f3 ef ff ff       	call   801037d0 <mycpu>
801047dd:	39 c3                	cmp    %eax,%ebx
801047df:	0f 94 c3             	sete   %bl
801047e2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801047e5:	e8 76 ff ff ff       	call   80104760 <popcli>
}
801047ea:	89 d8                	mov    %ebx,%eax
801047ec:	5b                   	pop    %ebx
801047ed:	5e                   	pop    %esi
801047ee:	5d                   	pop    %ebp
801047ef:	c3                   	ret    

801047f0 <acquire>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801047f5:	e8 26 ff ff ff       	call   80104720 <pushcli>
  if(holding(lk))
801047fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047fd:	83 ec 0c             	sub    $0xc,%esp
80104800:	53                   	push   %ebx
80104801:	e8 ba ff ff ff       	call   801047c0 <holding>
80104806:	83 c4 10             	add    $0x10,%esp
80104809:	85 c0                	test   %eax,%eax
8010480b:	0f 85 83 00 00 00    	jne    80104894 <acquire+0xa4>
80104811:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104813:	ba 01 00 00 00       	mov    $0x1,%edx
80104818:	eb 09                	jmp    80104823 <acquire+0x33>
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104820:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104823:	89 d0                	mov    %edx,%eax
80104825:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104828:	85 c0                	test   %eax,%eax
8010482a:	75 f4                	jne    80104820 <acquire+0x30>
  __sync_synchronize();
8010482c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104831:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104834:	e8 97 ef ff ff       	call   801037d0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104839:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010483c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010483f:	89 e8                	mov    %ebp,%eax
80104841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104848:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010484e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104854:	77 1a                	ja     80104870 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104856:	8b 48 04             	mov    0x4(%eax),%ecx
80104859:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010485c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010485f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104861:	83 fe 0a             	cmp    $0xa,%esi
80104864:	75 e2                	jne    80104848 <acquire+0x58>
}
80104866:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104869:	5b                   	pop    %ebx
8010486a:	5e                   	pop    %esi
8010486b:	5d                   	pop    %ebp
8010486c:	c3                   	ret    
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
80104870:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104873:	83 c2 28             	add    $0x28,%edx
80104876:	8d 76 00             	lea    0x0(%esi),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104886:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104889:	39 d0                	cmp    %edx,%eax
8010488b:	75 f3                	jne    80104880 <acquire+0x90>
}
8010488d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104890:	5b                   	pop    %ebx
80104891:	5e                   	pop    %esi
80104892:	5d                   	pop    %ebp
80104893:	c3                   	ret    
    panic("acquire");
80104894:	83 ec 0c             	sub    $0xc,%esp
80104897:	68 2d 7b 10 80       	push   $0x80107b2d
8010489c:	e8 ef ba ff ff       	call   80100390 <panic>
801048a1:	eb 0d                	jmp    801048b0 <release>
801048a3:	90                   	nop
801048a4:	90                   	nop
801048a5:	90                   	nop
801048a6:	90                   	nop
801048a7:	90                   	nop
801048a8:	90                   	nop
801048a9:	90                   	nop
801048aa:	90                   	nop
801048ab:	90                   	nop
801048ac:	90                   	nop
801048ad:	90                   	nop
801048ae:	90                   	nop
801048af:	90                   	nop

801048b0 <release>:
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 10             	sub    $0x10,%esp
801048b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801048ba:	53                   	push   %ebx
801048bb:	e8 00 ff ff ff       	call   801047c0 <holding>
801048c0:	83 c4 10             	add    $0x10,%esp
801048c3:	85 c0                	test   %eax,%eax
801048c5:	74 22                	je     801048e9 <release+0x39>
  lk->pcs[0] = 0;
801048c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048d5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e3:	c9                   	leave  
  popcli();
801048e4:	e9 77 fe ff ff       	jmp    80104760 <popcli>
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
801048e9:	50                   	push   %eax
801048ea:	50                   	push   %eax
801048eb:	ff 73 04             	pushl  0x4(%ebx)
801048ee:	68 40 7b 10 80       	push   $0x80107b40
801048f3:	e8 68 bd ff ff       	call   80100660 <cprintf>
    panic("release");}
801048f8:	c7 04 24 35 7b 10 80 	movl   $0x80107b35,(%esp)
801048ff:	e8 8c ba ff ff       	call   80100390 <panic>
80104904:	66 90                	xchg   %ax,%ax
80104906:	66 90                	xchg   %ax,%ax
80104908:	66 90                	xchg   %ax,%ax
8010490a:	66 90                	xchg   %ax,%ax
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <memset>:
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	53                   	push   %ebx
80104915:	8b 55 08             	mov    0x8(%ebp),%edx
80104918:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010491b:	f6 c2 03             	test   $0x3,%dl
8010491e:	75 05                	jne    80104925 <memset+0x15>
80104920:	f6 c1 03             	test   $0x3,%cl
80104923:	74 13                	je     80104938 <memset+0x28>
80104925:	89 d7                	mov    %edx,%edi
80104927:	8b 45 0c             	mov    0xc(%ebp),%eax
8010492a:	fc                   	cld    
8010492b:	f3 aa                	rep stos %al,%es:(%edi)
8010492d:	5b                   	pop    %ebx
8010492e:	89 d0                	mov    %edx,%eax
80104930:	5f                   	pop    %edi
80104931:	5d                   	pop    %ebp
80104932:	c3                   	ret    
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104938:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
8010493c:	c1 e9 02             	shr    $0x2,%ecx
8010493f:	89 fb                	mov    %edi,%ebx
80104941:	89 f8                	mov    %edi,%eax
80104943:	c1 e3 18             	shl    $0x18,%ebx
80104946:	c1 e0 10             	shl    $0x10,%eax
80104949:	09 d8                	or     %ebx,%eax
8010494b:	09 f8                	or     %edi,%eax
8010494d:	c1 e7 08             	shl    $0x8,%edi
80104950:	09 f8                	or     %edi,%eax
80104952:	89 d7                	mov    %edx,%edi
80104954:	fc                   	cld    
80104955:	f3 ab                	rep stos %eax,%es:(%edi)
80104957:	5b                   	pop    %ebx
80104958:	89 d0                	mov    %edx,%eax
8010495a:	5f                   	pop    %edi
8010495b:	5d                   	pop    %ebp
8010495c:	c3                   	ret    
8010495d:	8d 76 00             	lea    0x0(%esi),%esi

80104960 <memcmp>:
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	8b 45 10             	mov    0x10(%ebp),%eax
80104968:	53                   	push   %ebx
80104969:	8b 75 0c             	mov    0xc(%ebp),%esi
8010496c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010496f:	85 c0                	test   %eax,%eax
80104971:	74 29                	je     8010499c <memcmp+0x3c>
80104973:	0f b6 13             	movzbl (%ebx),%edx
80104976:	0f b6 0e             	movzbl (%esi),%ecx
80104979:	38 d1                	cmp    %dl,%cl
8010497b:	75 2b                	jne    801049a8 <memcmp+0x48>
8010497d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104980:	31 c0                	xor    %eax,%eax
80104982:	eb 14                	jmp    80104998 <memcmp+0x38>
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104988:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010498d:	83 c0 01             	add    $0x1,%eax
80104990:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104994:	38 ca                	cmp    %cl,%dl
80104996:	75 10                	jne    801049a8 <memcmp+0x48>
80104998:	39 f8                	cmp    %edi,%eax
8010499a:	75 ec                	jne    80104988 <memcmp+0x28>
8010499c:	5b                   	pop    %ebx
8010499d:	31 c0                	xor    %eax,%eax
8010499f:	5e                   	pop    %esi
801049a0:	5f                   	pop    %edi
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
801049a3:	90                   	nop
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049a8:	0f b6 c2             	movzbl %dl,%eax
801049ab:	5b                   	pop    %ebx
801049ac:	29 c8                	sub    %ecx,%eax
801049ae:	5e                   	pop    %esi
801049af:	5f                   	pop    %edi
801049b0:	5d                   	pop    %ebp
801049b1:	c3                   	ret    
801049b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <memmove>:
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 45 08             	mov    0x8(%ebp),%eax
801049c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801049cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049ce:	39 c6                	cmp    %eax,%esi
801049d0:	73 2e                	jae    80104a00 <memmove+0x40>
801049d2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801049d5:	39 c8                	cmp    %ecx,%eax
801049d7:	73 27                	jae    80104a00 <memmove+0x40>
801049d9:	85 db                	test   %ebx,%ebx
801049db:	8d 53 ff             	lea    -0x1(%ebx),%edx
801049de:	74 17                	je     801049f7 <memmove+0x37>
801049e0:	29 d9                	sub    %ebx,%ecx
801049e2:	89 cb                	mov    %ecx,%ebx
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801049ef:	83 ea 01             	sub    $0x1,%edx
801049f2:	83 fa ff             	cmp    $0xffffffff,%edx
801049f5:	75 f1                	jne    801049e8 <memmove+0x28>
801049f7:	5b                   	pop    %ebx
801049f8:	5e                   	pop    %esi
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret    
801049fb:	90                   	nop
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a00:	31 d2                	xor    %edx,%edx
80104a02:	85 db                	test   %ebx,%ebx
80104a04:	74 f1                	je     801049f7 <memmove+0x37>
80104a06:	8d 76 00             	lea    0x0(%esi),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a10:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104a14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a17:	83 c2 01             	add    $0x1,%edx
80104a1a:	39 d3                	cmp    %edx,%ebx
80104a1c:	75 f2                	jne    80104a10 <memmove+0x50>
80104a1e:	5b                   	pop    %ebx
80104a1f:	5e                   	pop    %esi
80104a20:	5d                   	pop    %ebp
80104a21:	c3                   	ret    
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <memcpy>:
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	5d                   	pop    %ebp
80104a34:	eb 8a                	jmp    801049c0 <memmove>
80104a36:	8d 76 00             	lea    0x0(%esi),%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <strncmp>:
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a48:	53                   	push   %ebx
80104a49:	8b 7d 08             	mov    0x8(%ebp),%edi
80104a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a4f:	85 c9                	test   %ecx,%ecx
80104a51:	74 37                	je     80104a8a <strncmp+0x4a>
80104a53:	0f b6 17             	movzbl (%edi),%edx
80104a56:	0f b6 1e             	movzbl (%esi),%ebx
80104a59:	84 d2                	test   %dl,%dl
80104a5b:	74 3f                	je     80104a9c <strncmp+0x5c>
80104a5d:	38 d3                	cmp    %dl,%bl
80104a5f:	75 3b                	jne    80104a9c <strncmp+0x5c>
80104a61:	8d 47 01             	lea    0x1(%edi),%eax
80104a64:	01 cf                	add    %ecx,%edi
80104a66:	eb 1b                	jmp    80104a83 <strncmp+0x43>
80104a68:	90                   	nop
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a70:	0f b6 10             	movzbl (%eax),%edx
80104a73:	84 d2                	test   %dl,%dl
80104a75:	74 21                	je     80104a98 <strncmp+0x58>
80104a77:	0f b6 19             	movzbl (%ecx),%ebx
80104a7a:	83 c0 01             	add    $0x1,%eax
80104a7d:	89 ce                	mov    %ecx,%esi
80104a7f:	38 da                	cmp    %bl,%dl
80104a81:	75 19                	jne    80104a9c <strncmp+0x5c>
80104a83:	39 c7                	cmp    %eax,%edi
80104a85:	8d 4e 01             	lea    0x1(%esi),%ecx
80104a88:	75 e6                	jne    80104a70 <strncmp+0x30>
80104a8a:	5b                   	pop    %ebx
80104a8b:	31 c0                	xor    %eax,%eax
80104a8d:	5e                   	pop    %esi
80104a8e:	5f                   	pop    %edi
80104a8f:	5d                   	pop    %ebp
80104a90:	c3                   	ret    
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a98:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
80104a9c:	0f b6 c2             	movzbl %dl,%eax
80104a9f:	29 d8                	sub    %ebx,%eax
80104aa1:	5b                   	pop    %ebx
80104aa2:	5e                   	pop    %esi
80104aa3:	5f                   	pop    %edi
80104aa4:	5d                   	pop    %ebp
80104aa5:	c3                   	ret    
80104aa6:	8d 76 00             	lea    0x0(%esi),%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <strncpy>:
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ab8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104abb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104abe:	89 c2                	mov    %eax,%edx
80104ac0:	eb 19                	jmp    80104adb <strncpy+0x2b>
80104ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac8:	83 c3 01             	add    $0x1,%ebx
80104acb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104acf:	83 c2 01             	add    $0x1,%edx
80104ad2:	84 c9                	test   %cl,%cl
80104ad4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ad7:	74 09                	je     80104ae2 <strncpy+0x32>
80104ad9:	89 f1                	mov    %esi,%ecx
80104adb:	85 c9                	test   %ecx,%ecx
80104add:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ae0:	7f e6                	jg     80104ac8 <strncpy+0x18>
80104ae2:	31 c9                	xor    %ecx,%ecx
80104ae4:	85 f6                	test   %esi,%esi
80104ae6:	7e 17                	jle    80104aff <strncpy+0x4f>
80104ae8:	90                   	nop
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104af4:	89 f3                	mov    %esi,%ebx
80104af6:	83 c1 01             	add    $0x1,%ecx
80104af9:	29 cb                	sub    %ecx,%ebx
80104afb:	85 db                	test   %ebx,%ebx
80104afd:	7f f1                	jg     80104af0 <strncpy+0x40>
80104aff:	5b                   	pop    %ebx
80104b00:	5e                   	pop    %esi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <safestrcpy>:
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
80104b15:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b18:	8b 45 08             	mov    0x8(%ebp),%eax
80104b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b1e:	85 c9                	test   %ecx,%ecx
80104b20:	7e 26                	jle    80104b48 <safestrcpy+0x38>
80104b22:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b26:	89 c1                	mov    %eax,%ecx
80104b28:	eb 17                	jmp    80104b41 <safestrcpy+0x31>
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b30:	83 c2 01             	add    $0x1,%edx
80104b33:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b37:	83 c1 01             	add    $0x1,%ecx
80104b3a:	84 db                	test   %bl,%bl
80104b3c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b3f:	74 04                	je     80104b45 <safestrcpy+0x35>
80104b41:	39 f2                	cmp    %esi,%edx
80104b43:	75 eb                	jne    80104b30 <safestrcpy+0x20>
80104b45:	c6 01 00             	movb   $0x0,(%ecx)
80104b48:	5b                   	pop    %ebx
80104b49:	5e                   	pop    %esi
80104b4a:	5d                   	pop    %ebp
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <strlen>:
80104b50:	55                   	push   %ebp
80104b51:	31 c0                	xor    %eax,%eax
80104b53:	89 e5                	mov    %esp,%ebp
80104b55:	8b 55 08             	mov    0x8(%ebp),%edx
80104b58:	80 3a 00             	cmpb   $0x0,(%edx)
80104b5b:	74 0c                	je     80104b69 <strlen+0x19>
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
80104b60:	83 c0 01             	add    $0x1,%eax
80104b63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b67:	75 f7                	jne    80104b60 <strlen+0x10>
80104b69:	5d                   	pop    %ebp
80104b6a:	c3                   	ret    

80104b6b <swtch>:
80104b6b:	8b 44 24 04          	mov    0x4(%esp),%eax
80104b6f:	8b 54 24 08          	mov    0x8(%esp),%edx
80104b73:	55                   	push   %ebp
80104b74:	53                   	push   %ebx
80104b75:	56                   	push   %esi
80104b76:	57                   	push   %edi
80104b77:	89 20                	mov    %esp,(%eax)
80104b79:	89 d4                	mov    %edx,%esp
80104b7b:	5f                   	pop    %edi
80104b7c:	5e                   	pop    %esi
80104b7d:	5b                   	pop    %ebx
80104b7e:	5d                   	pop    %ebp
80104b7f:	c3                   	ret    

80104b80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b8a:	e8 e1 ec ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b8f:	8b 00                	mov    (%eax),%eax
80104b91:	39 d8                	cmp    %ebx,%eax
80104b93:	76 1b                	jbe    80104bb0 <fetchint+0x30>
80104b95:	8d 53 04             	lea    0x4(%ebx),%edx
80104b98:	39 d0                	cmp    %edx,%eax
80104b9a:	72 14                	jb     80104bb0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b9f:	8b 13                	mov    (%ebx),%edx
80104ba1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ba3:	31 c0                	xor    %eax,%eax
}
80104ba5:	83 c4 04             	add    $0x4,%esp
80104ba8:	5b                   	pop    %ebx
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    
80104bab:	90                   	nop
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb5:	eb ee                	jmp    80104ba5 <fetchint+0x25>
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 04             	sub    $0x4,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bca:	e8 a1 ec ff ff       	call   80103870 <myproc>

  if(addr >= curproc->sz)
80104bcf:	39 18                	cmp    %ebx,(%eax)
80104bd1:	76 29                	jbe    80104bfc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104bd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104bd6:	89 da                	mov    %ebx,%edx
80104bd8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104bda:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104bdc:	39 c3                	cmp    %eax,%ebx
80104bde:	73 1c                	jae    80104bfc <fetchstr+0x3c>
    if(*s == 0)
80104be0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104be3:	75 10                	jne    80104bf5 <fetchstr+0x35>
80104be5:	eb 39                	jmp    80104c20 <fetchstr+0x60>
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bf0:	80 3a 00             	cmpb   $0x0,(%edx)
80104bf3:	74 1b                	je     80104c10 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104bf5:	83 c2 01             	add    $0x1,%edx
80104bf8:	39 d0                	cmp    %edx,%eax
80104bfa:	77 f4                	ja     80104bf0 <fetchstr+0x30>
    return -1;
80104bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104c01:	83 c4 04             	add    $0x4,%esp
80104c04:	5b                   	pop    %ebx
80104c05:	5d                   	pop    %ebp
80104c06:	c3                   	ret    
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c10:	83 c4 04             	add    $0x4,%esp
80104c13:	89 d0                	mov    %edx,%eax
80104c15:	29 d8                	sub    %ebx,%eax
80104c17:	5b                   	pop    %ebx
80104c18:	5d                   	pop    %ebp
80104c19:	c3                   	ret    
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c20:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c22:	eb dd                	jmp    80104c01 <fetchstr+0x41>
80104c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104c35:	e8 66 ec ff ff       	call   801038a0 <mythread>
80104c3a:	8b 40 10             	mov    0x10(%eax),%eax
80104c3d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c40:	8b 40 44             	mov    0x44(%eax),%eax
80104c43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c46:	e8 25 ec ff ff       	call   80103870 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c4b:	8b 00                	mov    (%eax),%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104c4d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c50:	39 c6                	cmp    %eax,%esi
80104c52:	73 1c                	jae    80104c70 <argint+0x40>
80104c54:	8d 53 08             	lea    0x8(%ebx),%edx
80104c57:	39 d0                	cmp    %edx,%eax
80104c59:	72 15                	jb     80104c70 <argint+0x40>
  *ip = *(int*)(addr);
80104c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c61:	89 10                	mov    %edx,(%eax)
  return 0;
80104c63:	31 c0                	xor    %eax,%eax
}
80104c65:	5b                   	pop    %ebx
80104c66:	5e                   	pop    %esi
80104c67:	5d                   	pop    %ebp
80104c68:	c3                   	ret    
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104c75:	eb ee                	jmp    80104c65 <argint+0x35>
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	83 ec 10             	sub    $0x10,%esp
80104c88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c8b:	e8 e0 eb ff ff       	call   80103870 <myproc>
80104c90:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104c92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c95:	83 ec 08             	sub    $0x8,%esp
80104c98:	50                   	push   %eax
80104c99:	ff 75 08             	pushl  0x8(%ebp)
80104c9c:	e8 8f ff ff ff       	call   80104c30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ca1:	83 c4 10             	add    $0x10,%esp
80104ca4:	85 c0                	test   %eax,%eax
80104ca6:	78 28                	js     80104cd0 <argptr+0x50>
80104ca8:	85 db                	test   %ebx,%ebx
80104caa:	78 24                	js     80104cd0 <argptr+0x50>
80104cac:	8b 16                	mov    (%esi),%edx
80104cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb1:	39 c2                	cmp    %eax,%edx
80104cb3:	76 1b                	jbe    80104cd0 <argptr+0x50>
80104cb5:	01 c3                	add    %eax,%ebx
80104cb7:	39 da                	cmp    %ebx,%edx
80104cb9:	72 15                	jb     80104cd0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cbe:	89 02                	mov    %eax,(%edx)
  return 0;
80104cc0:	31 c0                	xor    %eax,%eax
}
80104cc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc5:	5b                   	pop    %ebx
80104cc6:	5e                   	pop    %esi
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb eb                	jmp    80104cc2 <argptr+0x42>
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce9:	50                   	push   %eax
80104cea:	ff 75 08             	pushl  0x8(%ebp)
80104ced:	e8 3e ff ff ff       	call   80104c30 <argint>
80104cf2:	83 c4 10             	add    $0x10,%esp
80104cf5:	85 c0                	test   %eax,%eax
80104cf7:	78 17                	js     80104d10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104cf9:	83 ec 08             	sub    $0x8,%esp
80104cfc:	ff 75 0c             	pushl  0xc(%ebp)
80104cff:	ff 75 f4             	pushl  -0xc(%ebp)
80104d02:	e8 b9 fe ff ff       	call   80104bc0 <fetchstr>
80104d07:	83 c4 10             	add    $0x10,%esp
}
80104d0a:	c9                   	leave  
80104d0b:	c3                   	ret    
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104d25:	e8 46 eb ff ff       	call   80103870 <myproc>
80104d2a:	89 c6                	mov    %eax,%esi
  struct thread *curthread = mythread();
80104d2c:	e8 6f eb ff ff       	call   801038a0 <mythread>
80104d31:	89 c3                	mov    %eax,%ebx

  num = curthread->tf->eax;
80104d33:	8b 40 10             	mov    0x10(%eax),%eax
80104d36:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d39:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d3c:	83 fa 14             	cmp    $0x14,%edx
80104d3f:	77 1f                	ja     80104d60 <syscall+0x40>
80104d41:	8b 14 85 80 7b 10 80 	mov    -0x7fef8480(,%eax,4),%edx
80104d48:	85 d2                	test   %edx,%edx
80104d4a:	74 14                	je     80104d60 <syscall+0x40>
    curthread->tf->eax = syscalls[num]();
80104d4c:	ff d2                	call   *%edx
80104d4e:	8b 53 10             	mov    0x10(%ebx),%edx
80104d51:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
  }
}
80104d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d57:	5b                   	pop    %ebx
80104d58:	5e                   	pop    %esi
80104d59:	5d                   	pop    %ebp
80104d5a:	c3                   	ret    
80104d5b:	90                   	nop
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d60:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d61:	8d 46 60             	lea    0x60(%esi),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d64:	50                   	push   %eax
80104d65:	ff 76 0c             	pushl  0xc(%esi)
80104d68:	68 62 7b 10 80       	push   $0x80107b62
80104d6d:	e8 ee b8 ff ff       	call   80100660 <cprintf>
    curthread->tf->eax = -1;
80104d72:	8b 43 10             	mov    0x10(%ebx),%eax
80104d75:	83 c4 10             	add    $0x10,%esp
80104d78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	66 90                	xchg   %ax,%ax
80104d88:	66 90                	xchg   %ax,%ax
80104d8a:	66 90                	xchg   %ax,%ax
80104d8c:	66 90                	xchg   %ax,%ax
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	56                   	push   %esi
80104d95:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d96:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104d99:	83 ec 44             	sub    $0x44,%esp
80104d9c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104da2:	56                   	push   %esi
80104da3:	50                   	push   %eax
{
80104da4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104da7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104daa:	e8 71 d1 ff ff       	call   80101f20 <nameiparent>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	85 c0                	test   %eax,%eax
80104db4:	0f 84 46 01 00 00    	je     80104f00 <create+0x170>
    return 0;
  ilock(dp);
80104dba:	83 ec 0c             	sub    $0xc,%esp
80104dbd:	89 c3                	mov    %eax,%ebx
80104dbf:	50                   	push   %eax
80104dc0:	e8 db c8 ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104dc5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104dc8:	83 c4 0c             	add    $0xc,%esp
80104dcb:	50                   	push   %eax
80104dcc:	56                   	push   %esi
80104dcd:	53                   	push   %ebx
80104dce:	e8 fd cd ff ff       	call   80101bd0 <dirlookup>
80104dd3:	83 c4 10             	add    $0x10,%esp
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	89 c7                	mov    %eax,%edi
80104dda:	74 34                	je     80104e10 <create+0x80>
    iunlockput(dp);
80104ddc:	83 ec 0c             	sub    $0xc,%esp
80104ddf:	53                   	push   %ebx
80104de0:	e8 4b cb ff ff       	call   80101930 <iunlockput>
    ilock(ip);
80104de5:	89 3c 24             	mov    %edi,(%esp)
80104de8:	e8 b3 c8 ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ded:	83 c4 10             	add    $0x10,%esp
80104df0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104df5:	0f 85 95 00 00 00    	jne    80104e90 <create+0x100>
80104dfb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104e00:	0f 85 8a 00 00 00    	jne    80104e90 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e09:	89 f8                	mov    %edi,%eax
80104e0b:	5b                   	pop    %ebx
80104e0c:	5e                   	pop    %esi
80104e0d:	5f                   	pop    %edi
80104e0e:	5d                   	pop    %ebp
80104e0f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104e10:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104e14:	83 ec 08             	sub    $0x8,%esp
80104e17:	50                   	push   %eax
80104e18:	ff 33                	pushl  (%ebx)
80104e1a:	e8 11 c7 ff ff       	call   80101530 <ialloc>
80104e1f:	83 c4 10             	add    $0x10,%esp
80104e22:	85 c0                	test   %eax,%eax
80104e24:	89 c7                	mov    %eax,%edi
80104e26:	0f 84 e8 00 00 00    	je     80104f14 <create+0x184>
  ilock(ip);
80104e2c:	83 ec 0c             	sub    $0xc,%esp
80104e2f:	50                   	push   %eax
80104e30:	e8 6b c8 ff ff       	call   801016a0 <ilock>
  ip->major = major;
80104e35:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104e39:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e3d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104e41:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104e45:	b8 01 00 00 00       	mov    $0x1,%eax
80104e4a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104e4e:	89 3c 24             	mov    %edi,(%esp)
80104e51:	e8 9a c7 ff ff       	call   801015f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e56:	83 c4 10             	add    $0x10,%esp
80104e59:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e5e:	74 50                	je     80104eb0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e60:	83 ec 04             	sub    $0x4,%esp
80104e63:	ff 77 04             	pushl  0x4(%edi)
80104e66:	56                   	push   %esi
80104e67:	53                   	push   %ebx
80104e68:	e8 d3 cf ff ff       	call   80101e40 <dirlink>
80104e6d:	83 c4 10             	add    $0x10,%esp
80104e70:	85 c0                	test   %eax,%eax
80104e72:	0f 88 8f 00 00 00    	js     80104f07 <create+0x177>
  iunlockput(dp);
80104e78:	83 ec 0c             	sub    $0xc,%esp
80104e7b:	53                   	push   %ebx
80104e7c:	e8 af ca ff ff       	call   80101930 <iunlockput>
  return ip;
80104e81:	83 c4 10             	add    $0x10,%esp
}
80104e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e87:	89 f8                	mov    %edi,%eax
80104e89:	5b                   	pop    %ebx
80104e8a:	5e                   	pop    %esi
80104e8b:	5f                   	pop    %edi
80104e8c:	5d                   	pop    %ebp
80104e8d:	c3                   	ret    
80104e8e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104e90:	83 ec 0c             	sub    $0xc,%esp
80104e93:	57                   	push   %edi
    return 0;
80104e94:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104e96:	e8 95 ca ff ff       	call   80101930 <iunlockput>
    return 0;
80104e9b:	83 c4 10             	add    $0x10,%esp
}
80104e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ea1:	89 f8                	mov    %edi,%eax
80104ea3:	5b                   	pop    %ebx
80104ea4:	5e                   	pop    %esi
80104ea5:	5f                   	pop    %edi
80104ea6:	5d                   	pop    %ebp
80104ea7:	c3                   	ret    
80104ea8:	90                   	nop
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104eb0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104eb5:	83 ec 0c             	sub    $0xc,%esp
80104eb8:	53                   	push   %ebx
80104eb9:	e8 32 c7 ff ff       	call   801015f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104ebe:	83 c4 0c             	add    $0xc,%esp
80104ec1:	ff 77 04             	pushl  0x4(%edi)
80104ec4:	68 f4 7b 10 80       	push   $0x80107bf4
80104ec9:	57                   	push   %edi
80104eca:	e8 71 cf ff ff       	call   80101e40 <dirlink>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	78 1c                	js     80104ef2 <create+0x162>
80104ed6:	83 ec 04             	sub    $0x4,%esp
80104ed9:	ff 73 04             	pushl  0x4(%ebx)
80104edc:	68 f3 7b 10 80       	push   $0x80107bf3
80104ee1:	57                   	push   %edi
80104ee2:	e8 59 cf ff ff       	call   80101e40 <dirlink>
80104ee7:	83 c4 10             	add    $0x10,%esp
80104eea:	85 c0                	test   %eax,%eax
80104eec:	0f 89 6e ff ff ff    	jns    80104e60 <create+0xd0>
      panic("create dots");
80104ef2:	83 ec 0c             	sub    $0xc,%esp
80104ef5:	68 e7 7b 10 80       	push   $0x80107be7
80104efa:	e8 91 b4 ff ff       	call   80100390 <panic>
80104eff:	90                   	nop
    return 0;
80104f00:	31 ff                	xor    %edi,%edi
80104f02:	e9 ff fe ff ff       	jmp    80104e06 <create+0x76>
    panic("create: dirlink");
80104f07:	83 ec 0c             	sub    $0xc,%esp
80104f0a:	68 f6 7b 10 80       	push   $0x80107bf6
80104f0f:	e8 7c b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104f14:	83 ec 0c             	sub    $0xc,%esp
80104f17:	68 d8 7b 10 80       	push   $0x80107bd8
80104f1c:	e8 6f b4 ff ff       	call   80100390 <panic>
80104f21:	eb 0d                	jmp    80104f30 <argfd.constprop.0>
80104f23:	90                   	nop
80104f24:	90                   	nop
80104f25:	90                   	nop
80104f26:	90                   	nop
80104f27:	90                   	nop
80104f28:	90                   	nop
80104f29:	90                   	nop
80104f2a:	90                   	nop
80104f2b:	90                   	nop
80104f2c:	90                   	nop
80104f2d:	90                   	nop
80104f2e:	90                   	nop
80104f2f:	90                   	nop

80104f30 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
80104f35:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f37:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f3a:	89 d6                	mov    %edx,%esi
80104f3c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f3f:	50                   	push   %eax
80104f40:	6a 00                	push   $0x0
80104f42:	e8 e9 fc ff ff       	call   80104c30 <argint>
80104f47:	83 c4 10             	add    $0x10,%esp
80104f4a:	85 c0                	test   %eax,%eax
80104f4c:	78 2a                	js     80104f78 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f52:	77 24                	ja     80104f78 <argfd.constprop.0+0x48>
80104f54:	e8 17 e9 ff ff       	call   80103870 <myproc>
80104f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f5c:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
80104f60:	85 c0                	test   %eax,%eax
80104f62:	74 14                	je     80104f78 <argfd.constprop.0+0x48>
  if(pfd)
80104f64:	85 db                	test   %ebx,%ebx
80104f66:	74 02                	je     80104f6a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f68:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104f6a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f6c:	31 c0                	xor    %eax,%eax
}
80104f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f71:	5b                   	pop    %ebx
80104f72:	5e                   	pop    %esi
80104f73:	5d                   	pop    %ebp
80104f74:	c3                   	ret    
80104f75:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7d:	eb ef                	jmp    80104f6e <argfd.constprop.0+0x3e>
80104f7f:	90                   	nop

80104f80 <sys_dup>:
{
80104f80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104f81:	31 c0                	xor    %eax,%eax
{
80104f83:	89 e5                	mov    %esp,%ebp
80104f85:	56                   	push   %esi
80104f86:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104f87:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104f8a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104f8d:	e8 9e ff ff ff       	call   80104f30 <argfd.constprop.0>
80104f92:	85 c0                	test   %eax,%eax
80104f94:	78 42                	js     80104fd8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104f96:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f99:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104f9b:	e8 d0 e8 ff ff       	call   80103870 <myproc>
80104fa0:	eb 0e                	jmp    80104fb0 <sys_dup+0x30>
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104fa8:	83 c3 01             	add    $0x1,%ebx
80104fab:	83 fb 10             	cmp    $0x10,%ebx
80104fae:	74 28                	je     80104fd8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104fb0:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80104fb4:	85 d2                	test   %edx,%edx
80104fb6:	75 f0                	jne    80104fa8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104fb8:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
  filedup(f);
80104fbc:	83 ec 0c             	sub    $0xc,%esp
80104fbf:	ff 75 f4             	pushl  -0xc(%ebp)
80104fc2:	e8 39 be ff ff       	call   80100e00 <filedup>
  return fd;
80104fc7:	83 c4 10             	add    $0x10,%esp
}
80104fca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fcd:	89 d8                	mov    %ebx,%eax
80104fcf:	5b                   	pop    %ebx
80104fd0:	5e                   	pop    %esi
80104fd1:	5d                   	pop    %ebp
80104fd2:	c3                   	ret    
80104fd3:	90                   	nop
80104fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fdb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fe0:	89 d8                	mov    %ebx,%eax
80104fe2:	5b                   	pop    %ebx
80104fe3:	5e                   	pop    %esi
80104fe4:	5d                   	pop    %ebp
80104fe5:	c3                   	ret    
80104fe6:	8d 76 00             	lea    0x0(%esi),%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ff0 <sys_read>:
{
80104ff0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ff1:	31 c0                	xor    %eax,%eax
{
80104ff3:	89 e5                	mov    %esp,%ebp
80104ff5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ff8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ffb:	e8 30 ff ff ff       	call   80104f30 <argfd.constprop.0>
80105000:	85 c0                	test   %eax,%eax
80105002:	78 4c                	js     80105050 <sys_read+0x60>
80105004:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105007:	83 ec 08             	sub    $0x8,%esp
8010500a:	50                   	push   %eax
8010500b:	6a 02                	push   $0x2
8010500d:	e8 1e fc ff ff       	call   80104c30 <argint>
80105012:	83 c4 10             	add    $0x10,%esp
80105015:	85 c0                	test   %eax,%eax
80105017:	78 37                	js     80105050 <sys_read+0x60>
80105019:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010501c:	83 ec 04             	sub    $0x4,%esp
8010501f:	ff 75 f0             	pushl  -0x10(%ebp)
80105022:	50                   	push   %eax
80105023:	6a 01                	push   $0x1
80105025:	e8 56 fc ff ff       	call   80104c80 <argptr>
8010502a:	83 c4 10             	add    $0x10,%esp
8010502d:	85 c0                	test   %eax,%eax
8010502f:	78 1f                	js     80105050 <sys_read+0x60>
  return fileread(f, p, n);
80105031:	83 ec 04             	sub    $0x4,%esp
80105034:	ff 75 f0             	pushl  -0x10(%ebp)
80105037:	ff 75 f4             	pushl  -0xc(%ebp)
8010503a:	ff 75 ec             	pushl  -0x14(%ebp)
8010503d:	e8 2e bf ff ff       	call   80100f70 <fileread>
80105042:	83 c4 10             	add    $0x10,%esp
}
80105045:	c9                   	leave  
80105046:	c3                   	ret    
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105055:	c9                   	leave  
80105056:	c3                   	ret    
80105057:	89 f6                	mov    %esi,%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <sys_write>:
{
80105060:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105061:	31 c0                	xor    %eax,%eax
{
80105063:	89 e5                	mov    %esp,%ebp
80105065:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105068:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010506b:	e8 c0 fe ff ff       	call   80104f30 <argfd.constprop.0>
80105070:	85 c0                	test   %eax,%eax
80105072:	78 4c                	js     801050c0 <sys_write+0x60>
80105074:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105077:	83 ec 08             	sub    $0x8,%esp
8010507a:	50                   	push   %eax
8010507b:	6a 02                	push   $0x2
8010507d:	e8 ae fb ff ff       	call   80104c30 <argint>
80105082:	83 c4 10             	add    $0x10,%esp
80105085:	85 c0                	test   %eax,%eax
80105087:	78 37                	js     801050c0 <sys_write+0x60>
80105089:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010508c:	83 ec 04             	sub    $0x4,%esp
8010508f:	ff 75 f0             	pushl  -0x10(%ebp)
80105092:	50                   	push   %eax
80105093:	6a 01                	push   $0x1
80105095:	e8 e6 fb ff ff       	call   80104c80 <argptr>
8010509a:	83 c4 10             	add    $0x10,%esp
8010509d:	85 c0                	test   %eax,%eax
8010509f:	78 1f                	js     801050c0 <sys_write+0x60>
  return filewrite(f, p, n);
801050a1:	83 ec 04             	sub    $0x4,%esp
801050a4:	ff 75 f0             	pushl  -0x10(%ebp)
801050a7:	ff 75 f4             	pushl  -0xc(%ebp)
801050aa:	ff 75 ec             	pushl  -0x14(%ebp)
801050ad:	e8 4e bf ff ff       	call   80101000 <filewrite>
801050b2:	83 c4 10             	add    $0x10,%esp
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <sys_close>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801050d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801050d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050dc:	e8 4f fe ff ff       	call   80104f30 <argfd.constprop.0>
801050e1:	85 c0                	test   %eax,%eax
801050e3:	78 2b                	js     80105110 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801050e5:	e8 86 e7 ff ff       	call   80103870 <myproc>
801050ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801050ed:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050f0:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
801050f7:	00 
  fileclose(f);
801050f8:	ff 75 f4             	pushl  -0xc(%ebp)
801050fb:	e8 50 bd ff ff       	call   80100e50 <fileclose>
  return 0;
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	31 c0                	xor    %eax,%eax
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105115:	c9                   	leave  
80105116:	c3                   	ret    
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_fstat>:
{
80105120:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105121:	31 c0                	xor    %eax,%eax
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105128:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010512b:	e8 00 fe ff ff       	call   80104f30 <argfd.constprop.0>
80105130:	85 c0                	test   %eax,%eax
80105132:	78 2c                	js     80105160 <sys_fstat+0x40>
80105134:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105137:	83 ec 04             	sub    $0x4,%esp
8010513a:	6a 14                	push   $0x14
8010513c:	50                   	push   %eax
8010513d:	6a 01                	push   $0x1
8010513f:	e8 3c fb ff ff       	call   80104c80 <argptr>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	78 15                	js     80105160 <sys_fstat+0x40>
  return filestat(f, st);
8010514b:	83 ec 08             	sub    $0x8,%esp
8010514e:	ff 75 f4             	pushl  -0xc(%ebp)
80105151:	ff 75 f0             	pushl  -0x10(%ebp)
80105154:	e8 c7 bd ff ff       	call   80100f20 <filestat>
80105159:	83 c4 10             	add    $0x10,%esp
}
8010515c:	c9                   	leave  
8010515d:	c3                   	ret    
8010515e:	66 90                	xchg   %ax,%ax
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105170 <sys_link>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
80105175:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105176:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105179:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010517c:	50                   	push   %eax
8010517d:	6a 00                	push   $0x0
8010517f:	e8 5c fb ff ff       	call   80104ce0 <argstr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	0f 88 fb 00 00 00    	js     8010528a <sys_link+0x11a>
8010518f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105192:	83 ec 08             	sub    $0x8,%esp
80105195:	50                   	push   %eax
80105196:	6a 01                	push   $0x1
80105198:	e8 43 fb ff ff       	call   80104ce0 <argstr>
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	0f 88 e2 00 00 00    	js     8010528a <sys_link+0x11a>
  begin_op();
801051a8:	e8 f3 d9 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	ff 75 d4             	pushl  -0x2c(%ebp)
801051b3:	e8 48 cd ff ff       	call   80101f00 <namei>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	85 c0                	test   %eax,%eax
801051bd:	89 c3                	mov    %eax,%ebx
801051bf:	0f 84 ea 00 00 00    	je     801052af <sys_link+0x13f>
  ilock(ip);
801051c5:	83 ec 0c             	sub    $0xc,%esp
801051c8:	50                   	push   %eax
801051c9:	e8 d2 c4 ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d6:	0f 84 bb 00 00 00    	je     80105297 <sys_link+0x127>
  ip->nlink++;
801051dc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801051e1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801051e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051e7:	53                   	push   %ebx
801051e8:	e8 03 c4 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
801051ed:	89 1c 24             	mov    %ebx,(%esp)
801051f0:	e8 8b c5 ff ff       	call   80101780 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051f5:	58                   	pop    %eax
801051f6:	5a                   	pop    %edx
801051f7:	57                   	push   %edi
801051f8:	ff 75 d0             	pushl  -0x30(%ebp)
801051fb:	e8 20 cd ff ff       	call   80101f20 <nameiparent>
80105200:	83 c4 10             	add    $0x10,%esp
80105203:	85 c0                	test   %eax,%eax
80105205:	89 c6                	mov    %eax,%esi
80105207:	74 5b                	je     80105264 <sys_link+0xf4>
  ilock(dp);
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	50                   	push   %eax
8010520d:	e8 8e c4 ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	8b 03                	mov    (%ebx),%eax
80105217:	39 06                	cmp    %eax,(%esi)
80105219:	75 3d                	jne    80105258 <sys_link+0xe8>
8010521b:	83 ec 04             	sub    $0x4,%esp
8010521e:	ff 73 04             	pushl  0x4(%ebx)
80105221:	57                   	push   %edi
80105222:	56                   	push   %esi
80105223:	e8 18 cc ff ff       	call   80101e40 <dirlink>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	78 29                	js     80105258 <sys_link+0xe8>
  iunlockput(dp);
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	56                   	push   %esi
80105233:	e8 f8 c6 ff ff       	call   80101930 <iunlockput>
  iput(ip);
80105238:	89 1c 24             	mov    %ebx,(%esp)
8010523b:	e8 90 c5 ff ff       	call   801017d0 <iput>
  end_op();
80105240:	e8 cb d9 ff ff       	call   80102c10 <end_op>
  return 0;
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	31 c0                	xor    %eax,%eax
}
8010524a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010524d:	5b                   	pop    %ebx
8010524e:	5e                   	pop    %esi
8010524f:	5f                   	pop    %edi
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret    
80105252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	56                   	push   %esi
8010525c:	e8 cf c6 ff ff       	call   80101930 <iunlockput>
    goto bad;
80105261:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	53                   	push   %ebx
80105268:	e8 33 c4 ff ff       	call   801016a0 <ilock>
  ip->nlink--;
8010526d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105272:	89 1c 24             	mov    %ebx,(%esp)
80105275:	e8 76 c3 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
8010527a:	89 1c 24             	mov    %ebx,(%esp)
8010527d:	e8 ae c6 ff ff       	call   80101930 <iunlockput>
  end_op();
80105282:	e8 89 d9 ff ff       	call   80102c10 <end_op>
  return -1;
80105287:	83 c4 10             	add    $0x10,%esp
}
8010528a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010528d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105292:	5b                   	pop    %ebx
80105293:	5e                   	pop    %esi
80105294:	5f                   	pop    %edi
80105295:	5d                   	pop    %ebp
80105296:	c3                   	ret    
    iunlockput(ip);
80105297:	83 ec 0c             	sub    $0xc,%esp
8010529a:	53                   	push   %ebx
8010529b:	e8 90 c6 ff ff       	call   80101930 <iunlockput>
    end_op();
801052a0:	e8 6b d9 ff ff       	call   80102c10 <end_op>
    return -1;
801052a5:	83 c4 10             	add    $0x10,%esp
801052a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ad:	eb 9b                	jmp    8010524a <sys_link+0xda>
    end_op();
801052af:	e8 5c d9 ff ff       	call   80102c10 <end_op>
    return -1;
801052b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b9:	eb 8f                	jmp    8010524a <sys_link+0xda>
801052bb:	90                   	nop
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_unlink>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
801052c5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801052c6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052c9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 0c fa ff ff       	call   80104ce0 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 77 01 00 00    	js     80105456 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801052df:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801052e2:	e8 b9 d8 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	53                   	push   %ebx
801052eb:	ff 75 c0             	pushl  -0x40(%ebp)
801052ee:	e8 2d cc ff ff       	call   80101f20 <nameiparent>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	89 c6                	mov    %eax,%esi
801052fa:	0f 84 60 01 00 00    	je     80105460 <sys_unlink+0x1a0>
  ilock(dp);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	50                   	push   %eax
80105304:	e8 97 c3 ff ff       	call   801016a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105309:	58                   	pop    %eax
8010530a:	5a                   	pop    %edx
8010530b:	68 f4 7b 10 80       	push   $0x80107bf4
80105310:	53                   	push   %ebx
80105311:	e8 9a c8 ff ff       	call   80101bb0 <namecmp>
80105316:	83 c4 10             	add    $0x10,%esp
80105319:	85 c0                	test   %eax,%eax
8010531b:	0f 84 03 01 00 00    	je     80105424 <sys_unlink+0x164>
80105321:	83 ec 08             	sub    $0x8,%esp
80105324:	68 f3 7b 10 80       	push   $0x80107bf3
80105329:	53                   	push   %ebx
8010532a:	e8 81 c8 ff ff       	call   80101bb0 <namecmp>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	0f 84 ea 00 00 00    	je     80105424 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010533a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010533d:	83 ec 04             	sub    $0x4,%esp
80105340:	50                   	push   %eax
80105341:	53                   	push   %ebx
80105342:	56                   	push   %esi
80105343:	e8 88 c8 ff ff       	call   80101bd0 <dirlookup>
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	85 c0                	test   %eax,%eax
8010534d:	89 c3                	mov    %eax,%ebx
8010534f:	0f 84 cf 00 00 00    	je     80105424 <sys_unlink+0x164>
  ilock(ip);
80105355:	83 ec 0c             	sub    $0xc,%esp
80105358:	50                   	push   %eax
80105359:	e8 42 c3 ff ff       	call   801016a0 <ilock>
  if(ip->nlink < 1)
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105366:	0f 8e 10 01 00 00    	jle    8010547c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010536c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105371:	74 6d                	je     801053e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105373:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105376:	83 ec 04             	sub    $0x4,%esp
80105379:	6a 10                	push   $0x10
8010537b:	6a 00                	push   $0x0
8010537d:	50                   	push   %eax
8010537e:	e8 8d f5 ff ff       	call   80104910 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105383:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105386:	6a 10                	push   $0x10
80105388:	ff 75 c4             	pushl  -0x3c(%ebp)
8010538b:	50                   	push   %eax
8010538c:	56                   	push   %esi
8010538d:	e8 ee c6 ff ff       	call   80101a80 <writei>
80105392:	83 c4 20             	add    $0x20,%esp
80105395:	83 f8 10             	cmp    $0x10,%eax
80105398:	0f 85 eb 00 00 00    	jne    80105489 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010539e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053a3:	0f 84 97 00 00 00    	je     80105440 <sys_unlink+0x180>
  iunlockput(dp);
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	56                   	push   %esi
801053ad:	e8 7e c5 ff ff       	call   80101930 <iunlockput>
  ip->nlink--;
801053b2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053b7:	89 1c 24             	mov    %ebx,(%esp)
801053ba:	e8 31 c2 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
801053bf:	89 1c 24             	mov    %ebx,(%esp)
801053c2:	e8 69 c5 ff ff       	call   80101930 <iunlockput>
  end_op();
801053c7:	e8 44 d8 ff ff       	call   80102c10 <end_op>
  return 0;
801053cc:	83 c4 10             	add    $0x10,%esp
801053cf:	31 c0                	xor    %eax,%eax
}
801053d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d4:	5b                   	pop    %ebx
801053d5:	5e                   	pop    %esi
801053d6:	5f                   	pop    %edi
801053d7:	5d                   	pop    %ebp
801053d8:	c3                   	ret    
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053e4:	76 8d                	jbe    80105373 <sys_unlink+0xb3>
801053e6:	bf 20 00 00 00       	mov    $0x20,%edi
801053eb:	eb 0f                	jmp    801053fc <sys_unlink+0x13c>
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
801053f0:	83 c7 10             	add    $0x10,%edi
801053f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801053f6:	0f 83 77 ff ff ff    	jae    80105373 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053fc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053ff:	6a 10                	push   $0x10
80105401:	57                   	push   %edi
80105402:	50                   	push   %eax
80105403:	53                   	push   %ebx
80105404:	e8 77 c5 ff ff       	call   80101980 <readi>
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	83 f8 10             	cmp    $0x10,%eax
8010540f:	75 5e                	jne    8010546f <sys_unlink+0x1af>
    if(de.inum != 0)
80105411:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105416:	74 d8                	je     801053f0 <sys_unlink+0x130>
    iunlockput(ip);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	53                   	push   %ebx
8010541c:	e8 0f c5 ff ff       	call   80101930 <iunlockput>
    goto bad;
80105421:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	56                   	push   %esi
80105428:	e8 03 c5 ff ff       	call   80101930 <iunlockput>
  end_op();
8010542d:	e8 de d7 ff ff       	call   80102c10 <end_op>
  return -1;
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543a:	eb 95                	jmp    801053d1 <sys_unlink+0x111>
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105440:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105445:	83 ec 0c             	sub    $0xc,%esp
80105448:	56                   	push   %esi
80105449:	e8 a2 c1 ff ff       	call   801015f0 <iupdate>
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	e9 53 ff ff ff       	jmp    801053a9 <sys_unlink+0xe9>
    return -1;
80105456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545b:	e9 71 ff ff ff       	jmp    801053d1 <sys_unlink+0x111>
    end_op();
80105460:	e8 ab d7 ff ff       	call   80102c10 <end_op>
    return -1;
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546a:	e9 62 ff ff ff       	jmp    801053d1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010546f:	83 ec 0c             	sub    $0xc,%esp
80105472:	68 18 7c 10 80       	push   $0x80107c18
80105477:	e8 14 af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010547c:	83 ec 0c             	sub    $0xc,%esp
8010547f:	68 06 7c 10 80       	push   $0x80107c06
80105484:	e8 07 af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	68 2a 7c 10 80       	push   $0x80107c2a
80105491:	e8 fa ae ff ff       	call   80100390 <panic>
80105496:	8d 76 00             	lea    0x0(%esi),%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <sys_open>:

int
sys_open(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
801054a5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ac:	50                   	push   %eax
801054ad:	6a 00                	push   $0x0
801054af:	e8 2c f8 ff ff       	call   80104ce0 <argstr>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	0f 88 1d 01 00 00    	js     801055dc <sys_open+0x13c>
801054bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054c2:	83 ec 08             	sub    $0x8,%esp
801054c5:	50                   	push   %eax
801054c6:	6a 01                	push   $0x1
801054c8:	e8 63 f7 ff ff       	call   80104c30 <argint>
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	85 c0                	test   %eax,%eax
801054d2:	0f 88 04 01 00 00    	js     801055dc <sys_open+0x13c>
    return -1;

  begin_op();
801054d8:	e8 c3 d6 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
801054dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054e1:	0f 85 a9 00 00 00    	jne    80105590 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054e7:	83 ec 0c             	sub    $0xc,%esp
801054ea:	ff 75 e0             	pushl  -0x20(%ebp)
801054ed:	e8 0e ca ff ff       	call   80101f00 <namei>
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	85 c0                	test   %eax,%eax
801054f7:	89 c6                	mov    %eax,%esi
801054f9:	0f 84 b2 00 00 00    	je     801055b1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801054ff:	83 ec 0c             	sub    $0xc,%esp
80105502:	50                   	push   %eax
80105503:	e8 98 c1 ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105510:	0f 84 aa 00 00 00    	je     801055c0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105516:	e8 75 b8 ff ff       	call   80100d90 <filealloc>
8010551b:	85 c0                	test   %eax,%eax
8010551d:	89 c7                	mov    %eax,%edi
8010551f:	0f 84 a6 00 00 00    	je     801055cb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105525:	e8 46 e3 ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010552a:	31 db                	xor    %ebx,%ebx
8010552c:	eb 0e                	jmp    8010553c <sys_open+0x9c>
8010552e:	66 90                	xchg   %ax,%ax
80105530:	83 c3 01             	add    $0x1,%ebx
80105533:	83 fb 10             	cmp    $0x10,%ebx
80105536:	0f 84 ac 00 00 00    	je     801055e8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010553c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105540:	85 d2                	test   %edx,%edx
80105542:	75 ec                	jne    80105530 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105544:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105547:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
  iunlock(ip);
8010554b:	56                   	push   %esi
8010554c:	e8 2f c2 ff ff       	call   80101780 <iunlock>
  end_op();
80105551:	e8 ba d6 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105556:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010555c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010555f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105562:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105565:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010556c:	89 d0                	mov    %edx,%eax
8010556e:	f7 d0                	not    %eax
80105570:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105573:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105576:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105579:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010557d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105580:	89 d8                	mov    %ebx,%eax
80105582:	5b                   	pop    %ebx
80105583:	5e                   	pop    %esi
80105584:	5f                   	pop    %edi
80105585:	5d                   	pop    %ebp
80105586:	c3                   	ret    
80105587:	89 f6                	mov    %esi,%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105596:	31 c9                	xor    %ecx,%ecx
80105598:	6a 00                	push   $0x0
8010559a:	ba 02 00 00 00       	mov    $0x2,%edx
8010559f:	e8 ec f7 ff ff       	call   80104d90 <create>
    if(ip == 0){
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801055a9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055ab:	0f 85 65 ff ff ff    	jne    80105516 <sys_open+0x76>
      end_op();
801055b1:	e8 5a d6 ff ff       	call   80102c10 <end_op>
      return -1;
801055b6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055bb:	eb c0                	jmp    8010557d <sys_open+0xdd>
801055bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055c3:	85 c9                	test   %ecx,%ecx
801055c5:	0f 84 4b ff ff ff    	je     80105516 <sys_open+0x76>
    iunlockput(ip);
801055cb:	83 ec 0c             	sub    $0xc,%esp
801055ce:	56                   	push   %esi
801055cf:	e8 5c c3 ff ff       	call   80101930 <iunlockput>
    end_op();
801055d4:	e8 37 d6 ff ff       	call   80102c10 <end_op>
    return -1;
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055e1:	eb 9a                	jmp    8010557d <sys_open+0xdd>
801055e3:	90                   	nop
801055e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801055e8:	83 ec 0c             	sub    $0xc,%esp
801055eb:	57                   	push   %edi
801055ec:	e8 5f b8 ff ff       	call   80100e50 <fileclose>
801055f1:	83 c4 10             	add    $0x10,%esp
801055f4:	eb d5                	jmp    801055cb <sys_open+0x12b>
801055f6:	8d 76 00             	lea    0x0(%esi),%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <sys_mkdir>:

int
sys_mkdir(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105606:	e8 95 d5 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010560b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010560e:	83 ec 08             	sub    $0x8,%esp
80105611:	50                   	push   %eax
80105612:	6a 00                	push   $0x0
80105614:	e8 c7 f6 ff ff       	call   80104ce0 <argstr>
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	85 c0                	test   %eax,%eax
8010561e:	78 30                	js     80105650 <sys_mkdir+0x50>
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105626:	31 c9                	xor    %ecx,%ecx
80105628:	6a 00                	push   $0x0
8010562a:	ba 01 00 00 00       	mov    $0x1,%edx
8010562f:	e8 5c f7 ff ff       	call   80104d90 <create>
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	85 c0                	test   %eax,%eax
80105639:	74 15                	je     80105650 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010563b:	83 ec 0c             	sub    $0xc,%esp
8010563e:	50                   	push   %eax
8010563f:	e8 ec c2 ff ff       	call   80101930 <iunlockput>
  end_op();
80105644:	e8 c7 d5 ff ff       	call   80102c10 <end_op>
  return 0;
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	31 c0                	xor    %eax,%eax
}
8010564e:	c9                   	leave  
8010564f:	c3                   	ret    
    end_op();
80105650:	e8 bb d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010565a:	c9                   	leave  
8010565b:	c3                   	ret    
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_mknod>:

int
sys_mknod(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105666:	e8 35 d5 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010566b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010566e:	83 ec 08             	sub    $0x8,%esp
80105671:	50                   	push   %eax
80105672:	6a 00                	push   $0x0
80105674:	e8 67 f6 ff ff       	call   80104ce0 <argstr>
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	85 c0                	test   %eax,%eax
8010567e:	78 60                	js     801056e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105680:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105683:	83 ec 08             	sub    $0x8,%esp
80105686:	50                   	push   %eax
80105687:	6a 01                	push   $0x1
80105689:	e8 a2 f5 ff ff       	call   80104c30 <argint>
  if((argstr(0, &path)) < 0 ||
8010568e:	83 c4 10             	add    $0x10,%esp
80105691:	85 c0                	test   %eax,%eax
80105693:	78 4b                	js     801056e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105695:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105698:	83 ec 08             	sub    $0x8,%esp
8010569b:	50                   	push   %eax
8010569c:	6a 02                	push   $0x2
8010569e:	e8 8d f5 ff ff       	call   80104c30 <argint>
     argint(1, &major) < 0 ||
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	78 36                	js     801056e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801056ae:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801056b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801056b5:	ba 03 00 00 00       	mov    $0x3,%edx
801056ba:	50                   	push   %eax
801056bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056be:	e8 cd f6 ff ff       	call   80104d90 <create>
801056c3:	83 c4 10             	add    $0x10,%esp
801056c6:	85 c0                	test   %eax,%eax
801056c8:	74 16                	je     801056e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ca:	83 ec 0c             	sub    $0xc,%esp
801056cd:	50                   	push   %eax
801056ce:	e8 5d c2 ff ff       	call   80101930 <iunlockput>
  end_op();
801056d3:	e8 38 d5 ff ff       	call   80102c10 <end_op>
  return 0;
801056d8:	83 c4 10             	add    $0x10,%esp
801056db:	31 c0                	xor    %eax,%eax
}
801056dd:	c9                   	leave  
801056de:	c3                   	ret    
801056df:	90                   	nop
    end_op();
801056e0:	e8 2b d5 ff ff       	call   80102c10 <end_op>
    return -1;
801056e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056f0 <sys_chdir>:

int
sys_chdir(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	56                   	push   %esi
801056f4:	53                   	push   %ebx
801056f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  //struct proc *curproc = myproc();
  struct thread *curthread = mythread();
801056f8:	e8 a3 e1 ff ff       	call   801038a0 <mythread>
801056fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056ff:	e8 9c d4 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105704:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105707:	83 ec 08             	sub    $0x8,%esp
8010570a:	50                   	push   %eax
8010570b:	6a 00                	push   $0x0
8010570d:	e8 ce f5 ff ff       	call   80104ce0 <argstr>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	85 c0                	test   %eax,%eax
80105717:	78 77                	js     80105790 <sys_chdir+0xa0>
80105719:	83 ec 0c             	sub    $0xc,%esp
8010571c:	ff 75 f4             	pushl  -0xc(%ebp)
8010571f:	e8 dc c7 ff ff       	call   80101f00 <namei>
80105724:	83 c4 10             	add    $0x10,%esp
80105727:	85 c0                	test   %eax,%eax
80105729:	89 c3                	mov    %eax,%ebx
8010572b:	74 63                	je     80105790 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010572d:	83 ec 0c             	sub    $0xc,%esp
80105730:	50                   	push   %eax
80105731:	e8 6a bf ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010573e:	75 30                	jne    80105770 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	53                   	push   %ebx
80105744:	e8 37 c0 ff ff       	call   80101780 <iunlock>
  iput(curthread->cwd);
80105749:	58                   	pop    %eax
8010574a:	ff 76 20             	pushl  0x20(%esi)
8010574d:	e8 7e c0 ff ff       	call   801017d0 <iput>
  end_op();
80105752:	e8 b9 d4 ff ff       	call   80102c10 <end_op>
  curthread->cwd = ip;
80105757:	89 5e 20             	mov    %ebx,0x20(%esi)
  return 0;
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	31 c0                	xor    %eax,%eax
}
8010575f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105762:	5b                   	pop    %ebx
80105763:	5e                   	pop    %esi
80105764:	5d                   	pop    %ebp
80105765:	c3                   	ret    
80105766:	8d 76 00             	lea    0x0(%esi),%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	53                   	push   %ebx
80105774:	e8 b7 c1 ff ff       	call   80101930 <iunlockput>
    end_op();
80105779:	e8 92 d4 ff ff       	call   80102c10 <end_op>
    return -1;
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105786:	eb d7                	jmp    8010575f <sys_chdir+0x6f>
80105788:	90                   	nop
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105790:	e8 7b d4 ff ff       	call   80102c10 <end_op>
    return -1;
80105795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579a:	eb c3                	jmp    8010575f <sys_chdir+0x6f>
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_exec>:

int
sys_exec(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	56                   	push   %esi
801057a5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057b2:	50                   	push   %eax
801057b3:	6a 00                	push   $0x0
801057b5:	e8 26 f5 ff ff       	call   80104ce0 <argstr>
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	85 c0                	test   %eax,%eax
801057bf:	0f 88 87 00 00 00    	js     8010584c <sys_exec+0xac>
801057c5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057cb:	83 ec 08             	sub    $0x8,%esp
801057ce:	50                   	push   %eax
801057cf:	6a 01                	push   $0x1
801057d1:	e8 5a f4 ff ff       	call   80104c30 <argint>
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	85 c0                	test   %eax,%eax
801057db:	78 6f                	js     8010584c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057dd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801057e3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801057e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057e8:	68 80 00 00 00       	push   $0x80
801057ed:	6a 00                	push   $0x0
801057ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801057f5:	50                   	push   %eax
801057f6:	e8 15 f1 ff ff       	call   80104910 <memset>
801057fb:	83 c4 10             	add    $0x10,%esp
801057fe:	eb 2c                	jmp    8010582c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105800:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105806:	85 c0                	test   %eax,%eax
80105808:	74 56                	je     80105860 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010580a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105810:	83 ec 08             	sub    $0x8,%esp
80105813:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105816:	52                   	push   %edx
80105817:	50                   	push   %eax
80105818:	e8 a3 f3 ff ff       	call   80104bc0 <fetchstr>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 28                	js     8010584c <sys_exec+0xac>
  for(i=0;; i++){
80105824:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105827:	83 fb 20             	cmp    $0x20,%ebx
8010582a:	74 20                	je     8010584c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010582c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105832:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105839:	83 ec 08             	sub    $0x8,%esp
8010583c:	57                   	push   %edi
8010583d:	01 f0                	add    %esi,%eax
8010583f:	50                   	push   %eax
80105840:	e8 3b f3 ff ff       	call   80104b80 <fetchint>
80105845:	83 c4 10             	add    $0x10,%esp
80105848:	85 c0                	test   %eax,%eax
8010584a:	79 b4                	jns    80105800 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010584c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010584f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105854:	5b                   	pop    %ebx
80105855:	5e                   	pop    %esi
80105856:	5f                   	pop    %edi
80105857:	5d                   	pop    %ebp
80105858:	c3                   	ret    
80105859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105860:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105866:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105869:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105870:	00 00 00 00 
  return exec(path, argv);
80105874:	50                   	push   %eax
80105875:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010587b:	e8 90 b1 ff ff       	call   80100a10 <exec>
80105880:	83 c4 10             	add    $0x10,%esp
}
80105883:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105886:	5b                   	pop    %ebx
80105887:	5e                   	pop    %esi
80105888:	5f                   	pop    %edi
80105889:	5d                   	pop    %ebp
8010588a:	c3                   	ret    
8010588b:	90                   	nop
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_pipe>:

int
sys_pipe(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
80105895:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105896:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105899:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010589c:	6a 08                	push   $0x8
8010589e:	50                   	push   %eax
8010589f:	6a 00                	push   $0x0
801058a1:	e8 da f3 ff ff       	call   80104c80 <argptr>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	85 c0                	test   %eax,%eax
801058ab:	0f 88 ae 00 00 00    	js     8010595f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058b4:	83 ec 08             	sub    $0x8,%esp
801058b7:	50                   	push   %eax
801058b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058bb:	50                   	push   %eax
801058bc:	e8 8f d9 ff ff       	call   80103250 <pipealloc>
801058c1:	83 c4 10             	add    $0x10,%esp
801058c4:	85 c0                	test   %eax,%eax
801058c6:	0f 88 93 00 00 00    	js     8010595f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058cf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058d1:	e8 9a df ff ff       	call   80103870 <myproc>
801058d6:	eb 10                	jmp    801058e8 <sys_pipe+0x58>
801058d8:	90                   	nop
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058e0:	83 c3 01             	add    $0x1,%ebx
801058e3:	83 fb 10             	cmp    $0x10,%ebx
801058e6:	74 60                	je     80105948 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801058e8:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
801058ec:	85 f6                	test   %esi,%esi
801058ee:	75 f0                	jne    801058e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801058f0:	8d 73 08             	lea    0x8(%ebx),%esi
801058f3:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058f9:	e8 72 df ff ff       	call   80103870 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058fe:	31 d2                	xor    %edx,%edx
80105900:	eb 0e                	jmp    80105910 <sys_pipe+0x80>
80105902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105908:	83 c2 01             	add    $0x1,%edx
8010590b:	83 fa 10             	cmp    $0x10,%edx
8010590e:	74 28                	je     80105938 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105910:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
80105914:	85 c9                	test   %ecx,%ecx
80105916:	75 f0                	jne    80105908 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105918:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010591c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010591f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105921:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105924:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105927:	31 c0                	xor    %eax,%eax
}
80105929:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010592c:	5b                   	pop    %ebx
8010592d:	5e                   	pop    %esi
8010592e:	5f                   	pop    %edi
8010592f:	5d                   	pop    %ebp
80105930:	c3                   	ret    
80105931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105938:	e8 33 df ff ff       	call   80103870 <myproc>
8010593d:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(rf);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	ff 75 e0             	pushl  -0x20(%ebp)
8010594e:	e8 fd b4 ff ff       	call   80100e50 <fileclose>
    fileclose(wf);
80105953:	58                   	pop    %eax
80105954:	ff 75 e4             	pushl  -0x1c(%ebp)
80105957:	e8 f4 b4 ff ff       	call   80100e50 <fileclose>
    return -1;
8010595c:	83 c4 10             	add    $0x10,%esp
8010595f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105964:	eb c3                	jmp    80105929 <sys_pipe+0x99>
80105966:	66 90                	xchg   %ax,%ax
80105968:	66 90                	xchg   %ax,%ax
8010596a:	66 90                	xchg   %ax,%ax
8010596c:	66 90                	xchg   %ax,%ax
8010596e:	66 90                	xchg   %ax,%ax

80105970 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105973:	5d                   	pop    %ebp
  return fork();
80105974:	e9 47 e1 ff ff       	jmp    80103ac0 <fork>
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105980 <sys_exit>:

int
sys_exit(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 08             	sub    $0x8,%esp
  exit();
80105986:	e8 05 e6 ff ff       	call   80103f90 <exit>
  return 0;  // not reached
}
8010598b:	31 c0                	xor    %eax,%eax
8010598d:	c9                   	leave  
8010598e:	c3                   	ret    
8010598f:	90                   	nop

80105990 <sys_wait>:

int
sys_wait(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105993:	5d                   	pop    %ebp
  return wait();
80105994:	e9 57 e8 ff ff       	jmp    801041f0 <wait>
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_kill>:

int
sys_kill(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a9:	50                   	push   %eax
801059aa:	6a 00                	push   $0x0
801059ac:	e8 7f f2 ff ff       	call   80104c30 <argint>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	85 c0                	test   %eax,%eax
801059b6:	78 18                	js     801059d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	ff 75 f4             	pushl  -0xc(%ebp)
801059be:	e8 1d ea ff ff       	call   801043e0 <kill>
801059c3:	83 c4 10             	add    $0x10,%esp
}
801059c6:	c9                   	leave  
801059c7:	c3                   	ret    
801059c8:	90                   	nop
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <sys_getpid>:

int
sys_getpid(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059e6:	e8 85 de ff ff       	call   80103870 <myproc>
801059eb:	8b 40 0c             	mov    0xc(%eax),%eax
}
801059ee:	c9                   	leave  
801059ef:	c3                   	ret    

801059f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059fa:	50                   	push   %eax
801059fb:	6a 00                	push   $0x0
801059fd:	e8 2e f2 ff ff       	call   80104c30 <argint>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	78 27                	js     80105a30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a09:	e8 62 de ff ff       	call   80103870 <myproc>
  if(growproc(n) < 0)
80105a0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a13:	ff 75 f4             	pushl  -0xc(%ebp)
80105a16:	e8 15 e0 ff ff       	call   80103a30 <growproc>
80105a1b:	83 c4 10             	add    $0x10,%esp
80105a1e:	85 c0                	test   %eax,%eax
80105a20:	78 0e                	js     80105a30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a22:	89 d8                	mov    %ebx,%eax
80105a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a27:	c9                   	leave  
80105a28:	c3                   	ret    
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a35:	eb eb                	jmp    80105a22 <sys_sbrk+0x32>
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_sleep>:

int
sys_sleep(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a4a:	50                   	push   %eax
80105a4b:	6a 00                	push   $0x0
80105a4d:	e8 de f1 ff ff       	call   80104c30 <argint>
80105a52:	83 c4 10             	add    $0x10,%esp
80105a55:	85 c0                	test   %eax,%eax
80105a57:	0f 88 8a 00 00 00    	js     80105ae7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a5d:	83 ec 0c             	sub    $0xc,%esp
80105a60:	68 80 2c 12 80       	push   $0x80122c80
80105a65:	e8 86 ed ff ff       	call   801047f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a6d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105a70:	8b 1d c0 34 12 80    	mov    0x801234c0,%ebx
  while(ticks - ticks0 < n){
80105a76:	85 d2                	test   %edx,%edx
80105a78:	75 27                	jne    80105aa1 <sys_sleep+0x61>
80105a7a:	eb 54                	jmp    80105ad0 <sys_sleep+0x90>
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a80:	83 ec 08             	sub    $0x8,%esp
80105a83:	68 80 2c 12 80       	push   $0x80122c80
80105a88:	68 c0 34 12 80       	push   $0x801234c0
80105a8d:	e8 0e e4 ff ff       	call   80103ea0 <sleep>
  while(ticks - ticks0 < n){
80105a92:	a1 c0 34 12 80       	mov    0x801234c0,%eax
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	29 d8                	sub    %ebx,%eax
80105a9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a9f:	73 2f                	jae    80105ad0 <sys_sleep+0x90>
    if(myproc()->killed){
80105aa1:	e8 ca dd ff ff       	call   80103870 <myproc>
80105aa6:	8b 40 1c             	mov    0x1c(%eax),%eax
80105aa9:	85 c0                	test   %eax,%eax
80105aab:	74 d3                	je     80105a80 <sys_sleep+0x40>
      release(&tickslock);
80105aad:	83 ec 0c             	sub    $0xc,%esp
80105ab0:	68 80 2c 12 80       	push   $0x80122c80
80105ab5:	e8 f6 ed ff ff       	call   801048b0 <release>
      return -1;
80105aba:	83 c4 10             	add    $0x10,%esp
80105abd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	68 80 2c 12 80       	push   $0x80122c80
80105ad8:	e8 d3 ed ff ff       	call   801048b0 <release>
  return 0;
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	31 c0                	xor    %eax,%eax
}
80105ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae5:	c9                   	leave  
80105ae6:	c3                   	ret    
    return -1;
80105ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aec:	eb f4                	jmp    80105ae2 <sys_sleep+0xa2>
80105aee:	66 90                	xchg   %ax,%ax

80105af0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	53                   	push   %ebx
80105af4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105af7:	68 80 2c 12 80       	push   $0x80122c80
80105afc:	e8 ef ec ff ff       	call   801047f0 <acquire>
  xticks = ticks;
80105b01:	8b 1d c0 34 12 80    	mov    0x801234c0,%ebx
  release(&tickslock);
80105b07:	c7 04 24 80 2c 12 80 	movl   $0x80122c80,(%esp)
80105b0e:	e8 9d ed ff ff       	call   801048b0 <release>
  return xticks;
}
80105b13:	89 d8                	mov    %ebx,%eax
80105b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b18:	c9                   	leave  
80105b19:	c3                   	ret    

80105b1a <alltraps>:
80105b1a:	1e                   	push   %ds
80105b1b:	06                   	push   %es
80105b1c:	0f a0                	push   %fs
80105b1e:	0f a8                	push   %gs
80105b20:	60                   	pusha  
80105b21:	66 b8 10 00          	mov    $0x10,%ax
80105b25:	8e d8                	mov    %eax,%ds
80105b27:	8e c0                	mov    %eax,%es
80105b29:	54                   	push   %esp
80105b2a:	e8 c1 00 00 00       	call   80105bf0 <trap>
80105b2f:	83 c4 04             	add    $0x4,%esp

80105b32 <trapret>:
80105b32:	61                   	popa   
80105b33:	0f a9                	pop    %gs
80105b35:	0f a1                	pop    %fs
80105b37:	07                   	pop    %es
80105b38:	1f                   	pop    %ds
80105b39:	83 c4 08             	add    $0x8,%esp
80105b3c:	cf                   	iret   
80105b3d:	66 90                	xchg   %ax,%ax
80105b3f:	90                   	nop

80105b40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b41:	31 c0                	xor    %eax,%eax
{
80105b43:	89 e5                	mov    %esp,%ebp
80105b45:	83 ec 08             	sub    $0x8,%esp
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b50:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b57:	c7 04 c5 c2 2c 12 80 	movl   $0x8e000008,-0x7fedd33e(,%eax,8)
80105b5e:	08 00 00 8e 
80105b62:	66 89 14 c5 c0 2c 12 	mov    %dx,-0x7fedd340(,%eax,8)
80105b69:	80 
80105b6a:	c1 ea 10             	shr    $0x10,%edx
80105b6d:	66 89 14 c5 c6 2c 12 	mov    %dx,-0x7fedd33a(,%eax,8)
80105b74:	80 
  for(i = 0; i < 256; i++)
80105b75:	83 c0 01             	add    $0x1,%eax
80105b78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b7d:	75 d1                	jne    80105b50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b7f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105b84:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b87:	c7 05 c2 2e 12 80 08 	movl   $0xef000008,0x80122ec2
80105b8e:	00 00 ef 
  initlock(&tickslock, "time");
80105b91:	68 39 7c 10 80       	push   $0x80107c39
80105b96:	68 80 2c 12 80       	push   $0x80122c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b9b:	66 a3 c0 2e 12 80    	mov    %ax,0x80122ec0
80105ba1:	c1 e8 10             	shr    $0x10,%eax
80105ba4:	66 a3 c6 2e 12 80    	mov    %ax,0x80122ec6
  initlock(&tickslock, "time");
80105baa:	e8 01 eb ff ff       	call   801046b0 <initlock>
}
80105baf:	83 c4 10             	add    $0x10,%esp
80105bb2:	c9                   	leave  
80105bb3:	c3                   	ret    
80105bb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105bc0 <idtinit>:

void
idtinit(void)
{
80105bc0:	55                   	push   %ebp
  pd[0] = size-1;
80105bc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bc6:	89 e5                	mov    %esp,%ebp
80105bc8:	83 ec 10             	sub    $0x10,%esp
80105bcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bcf:	b8 c0 2c 12 80       	mov    $0x80122cc0,%eax
80105bd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105bd8:	c1 e8 10             	shr    $0x10,%eax
80105bdb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bdf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105be2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105be5:	c9                   	leave  
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
80105bf5:	53                   	push   %ebx
80105bf6:	83 ec 1c             	sub    $0x1c,%esp
80105bf9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105bfc:	8b 47 30             	mov    0x30(%edi),%eax
80105bff:	83 f8 40             	cmp    $0x40,%eax
80105c02:	0f 84 f0 00 00 00    	je     80105cf8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c08:	83 e8 20             	sub    $0x20,%eax
80105c0b:	83 f8 1f             	cmp    $0x1f,%eax
80105c0e:	77 10                	ja     80105c20 <trap+0x30>
80105c10:	ff 24 85 e0 7c 10 80 	jmp    *-0x7fef8320(,%eax,4)
80105c17:	89 f6                	mov    %esi,%esi
80105c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c20:	e8 4b dc ff ff       	call   80103870 <myproc>
80105c25:	85 c0                	test   %eax,%eax
80105c27:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c2a:	0f 84 14 02 00 00    	je     80105e44 <trap+0x254>
80105c30:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c34:	0f 84 0a 02 00 00    	je     80105e44 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c3a:	0f 20 d1             	mov    %cr2,%ecx
80105c3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c40:	e8 0b dc ff ff       	call   80103850 <cpuid>
80105c45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c48:	8b 47 34             	mov    0x34(%edi),%eax
80105c4b:	8b 77 30             	mov    0x30(%edi),%esi
80105c4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105c51:	e8 1a dc ff ff       	call   80103870 <myproc>
80105c56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c59:	e8 12 dc ff ff       	call   80103870 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c64:	51                   	push   %ecx
80105c65:	53                   	push   %ebx
80105c66:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105c67:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c6a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c6d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c6e:	83 c2 60             	add    $0x60,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c71:	52                   	push   %edx
80105c72:	ff 70 0c             	pushl  0xc(%eax)
80105c75:	68 9c 7c 10 80       	push   $0x80107c9c
80105c7a:	e8 e1 a9 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105c7f:	83 c4 20             	add    $0x20,%esp
80105c82:	e8 e9 db ff ff       	call   80103870 <myproc>
80105c87:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c8e:	e8 dd db ff ff       	call   80103870 <myproc>
80105c93:	85 c0                	test   %eax,%eax
80105c95:	74 1d                	je     80105cb4 <trap+0xc4>
80105c97:	e8 d4 db ff ff       	call   80103870 <myproc>
80105c9c:	8b 50 1c             	mov    0x1c(%eax),%edx
80105c9f:	85 d2                	test   %edx,%edx
80105ca1:	74 11                	je     80105cb4 <trap+0xc4>
80105ca3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ca7:	83 e0 03             	and    $0x3,%eax
80105caa:	66 83 f8 03          	cmp    $0x3,%ax
80105cae:	0f 84 4c 01 00 00    	je     80105e00 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105cb4:	e8 b7 db ff ff       	call   80103870 <myproc>
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	74 0b                	je     80105cc8 <trap+0xd8>
80105cbd:	e8 ae db ff ff       	call   80103870 <myproc>
80105cc2:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80105cc6:	74 68                	je     80105d30 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cc8:	e8 a3 db ff ff       	call   80103870 <myproc>
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	74 19                	je     80105cea <trap+0xfa>
80105cd1:	e8 9a db ff ff       	call   80103870 <myproc>
80105cd6:	8b 40 1c             	mov    0x1c(%eax),%eax
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	74 0d                	je     80105cea <trap+0xfa>
80105cdd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ce1:	83 e0 03             	and    $0x3,%eax
80105ce4:	66 83 f8 03          	cmp    $0x3,%ax
80105ce8:	74 37                	je     80105d21 <trap+0x131>
    exit();
}
80105cea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ced:	5b                   	pop    %ebx
80105cee:	5e                   	pop    %esi
80105cef:	5f                   	pop    %edi
80105cf0:	5d                   	pop    %ebp
80105cf1:	c3                   	ret    
80105cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105cf8:	e8 73 db ff ff       	call   80103870 <myproc>
80105cfd:	8b 58 1c             	mov    0x1c(%eax),%ebx
80105d00:	85 db                	test   %ebx,%ebx
80105d02:	0f 85 e8 00 00 00    	jne    80105df0 <trap+0x200>
    mythread()->tf = tf;
80105d08:	e8 93 db ff ff       	call   801038a0 <mythread>
80105d0d:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
80105d10:	e8 0b f0 ff ff       	call   80104d20 <syscall>
    if(myproc()->killed)
80105d15:	e8 56 db ff ff       	call   80103870 <myproc>
80105d1a:	8b 48 1c             	mov    0x1c(%eax),%ecx
80105d1d:	85 c9                	test   %ecx,%ecx
80105d1f:	74 c9                	je     80105cea <trap+0xfa>
}
80105d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
      exit();
80105d28:	e9 63 e2 ff ff       	jmp    80103f90 <exit>
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d30:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d34:	75 92                	jne    80105cc8 <trap+0xd8>
    yield();
80105d36:	e8 15 e1 ff ff       	call   80103e50 <yield>
80105d3b:	eb 8b                	jmp    80105cc8 <trap+0xd8>
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105d40:	e8 0b db ff ff       	call   80103850 <cpuid>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	0f 84 c3 00 00 00    	je     80105e10 <trap+0x220>
    lapiceoi();
80105d4d:	e8 0e ca ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d52:	e8 19 db ff ff       	call   80103870 <myproc>
80105d57:	85 c0                	test   %eax,%eax
80105d59:	0f 85 38 ff ff ff    	jne    80105c97 <trap+0xa7>
80105d5f:	e9 50 ff ff ff       	jmp    80105cb4 <trap+0xc4>
80105d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d68:	e8 b3 c8 ff ff       	call   80102620 <kbdintr>
    lapiceoi();
80105d6d:	e8 ee c9 ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d72:	e8 f9 da ff ff       	call   80103870 <myproc>
80105d77:	85 c0                	test   %eax,%eax
80105d79:	0f 85 18 ff ff ff    	jne    80105c97 <trap+0xa7>
80105d7f:	e9 30 ff ff ff       	jmp    80105cb4 <trap+0xc4>
80105d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d88:	e8 53 02 00 00       	call   80105fe0 <uartintr>
    lapiceoi();
80105d8d:	e8 ce c9 ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d92:	e8 d9 da ff ff       	call   80103870 <myproc>
80105d97:	85 c0                	test   %eax,%eax
80105d99:	0f 85 f8 fe ff ff    	jne    80105c97 <trap+0xa7>
80105d9f:	e9 10 ff ff ff       	jmp    80105cb4 <trap+0xc4>
80105da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105da8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105dac:	8b 77 38             	mov    0x38(%edi),%esi
80105daf:	e8 9c da ff ff       	call   80103850 <cpuid>
80105db4:	56                   	push   %esi
80105db5:	53                   	push   %ebx
80105db6:	50                   	push   %eax
80105db7:	68 44 7c 10 80       	push   $0x80107c44
80105dbc:	e8 9f a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105dc1:	e8 9a c9 ff ff       	call   80102760 <lapiceoi>
    break;
80105dc6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dc9:	e8 a2 da ff ff       	call   80103870 <myproc>
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	0f 85 c1 fe ff ff    	jne    80105c97 <trap+0xa7>
80105dd6:	e9 d9 fe ff ff       	jmp    80105cb4 <trap+0xc4>
80105ddb:	90                   	nop
80105ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105de0:	e8 bb c2 ff ff       	call   801020a0 <ideintr>
80105de5:	e9 63 ff ff ff       	jmp    80105d4d <trap+0x15d>
80105dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105df0:	e8 9b e1 ff ff       	call   80103f90 <exit>
80105df5:	e9 0e ff ff ff       	jmp    80105d08 <trap+0x118>
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105e00:	e8 8b e1 ff ff       	call   80103f90 <exit>
80105e05:	e9 aa fe ff ff       	jmp    80105cb4 <trap+0xc4>
80105e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	68 80 2c 12 80       	push   $0x80122c80
80105e18:	e8 d3 e9 ff ff       	call   801047f0 <acquire>
      wakeup(&ticks);
80105e1d:	c7 04 24 c0 34 12 80 	movl   $0x801234c0,(%esp)
      ticks++;
80105e24:	83 05 c0 34 12 80 01 	addl   $0x1,0x801234c0
      wakeup(&ticks);
80105e2b:	e8 30 e5 ff ff       	call   80104360 <wakeup>
      release(&tickslock);
80105e30:	c7 04 24 80 2c 12 80 	movl   $0x80122c80,(%esp)
80105e37:	e8 74 ea ff ff       	call   801048b0 <release>
80105e3c:	83 c4 10             	add    $0x10,%esp
80105e3f:	e9 09 ff ff ff       	jmp    80105d4d <trap+0x15d>
80105e44:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e47:	e8 04 da ff ff       	call   80103850 <cpuid>
80105e4c:	83 ec 0c             	sub    $0xc,%esp
80105e4f:	56                   	push   %esi
80105e50:	53                   	push   %ebx
80105e51:	50                   	push   %eax
80105e52:	ff 77 30             	pushl  0x30(%edi)
80105e55:	68 68 7c 10 80       	push   $0x80107c68
80105e5a:	e8 01 a8 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105e5f:	83 c4 14             	add    $0x14,%esp
80105e62:	68 3e 7c 10 80       	push   $0x80107c3e
80105e67:	e8 24 a5 ff ff       	call   80100390 <panic>
80105e6c:	66 90                	xchg   %ax,%ax
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e70:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105e75:	55                   	push   %ebp
80105e76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105e78:	85 c0                	test   %eax,%eax
80105e7a:	74 1c                	je     80105e98 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e82:	a8 01                	test   $0x1,%al
80105e84:	74 12                	je     80105e98 <uartgetc+0x28>
80105e86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e8b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e8c:	0f b6 c0             	movzbl %al,%eax
}
80105e8f:	5d                   	pop    %ebp
80105e90:	c3                   	ret    
80105e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e9d:	5d                   	pop    %ebp
80105e9e:	c3                   	ret    
80105e9f:	90                   	nop

80105ea0 <uartputc.part.0>:
uartputc(int c)
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	57                   	push   %edi
80105ea4:	56                   	push   %esi
80105ea5:	53                   	push   %ebx
80105ea6:	89 c7                	mov    %eax,%edi
80105ea8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ead:	be fd 03 00 00       	mov    $0x3fd,%esi
80105eb2:	83 ec 0c             	sub    $0xc,%esp
80105eb5:	eb 1b                	jmp    80105ed2 <uartputc.part.0+0x32>
80105eb7:	89 f6                	mov    %esi,%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	6a 0a                	push   $0xa
80105ec5:	e8 b6 c8 ff ff       	call   80102780 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	83 eb 01             	sub    $0x1,%ebx
80105ed0:	74 07                	je     80105ed9 <uartputc.part.0+0x39>
80105ed2:	89 f2                	mov    %esi,%edx
80105ed4:	ec                   	in     (%dx),%al
80105ed5:	a8 20                	test   $0x20,%al
80105ed7:	74 e7                	je     80105ec0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ed9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ede:	89 f8                	mov    %edi,%eax
80105ee0:	ee                   	out    %al,(%dx)
}
80105ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee4:	5b                   	pop    %ebx
80105ee5:	5e                   	pop    %esi
80105ee6:	5f                   	pop    %edi
80105ee7:	5d                   	pop    %ebp
80105ee8:	c3                   	ret    
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <uartinit>:
{
80105ef0:	55                   	push   %ebp
80105ef1:	31 c9                	xor    %ecx,%ecx
80105ef3:	89 c8                	mov    %ecx,%eax
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	57                   	push   %edi
80105ef8:	56                   	push   %esi
80105ef9:	53                   	push   %ebx
80105efa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105eff:	89 da                	mov    %ebx,%edx
80105f01:	83 ec 0c             	sub    $0xc,%esp
80105f04:	ee                   	out    %al,(%dx)
80105f05:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f0f:	89 fa                	mov    %edi,%edx
80105f11:	ee                   	out    %al,(%dx)
80105f12:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f1c:	ee                   	out    %al,(%dx)
80105f1d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f22:	89 c8                	mov    %ecx,%eax
80105f24:	89 f2                	mov    %esi,%edx
80105f26:	ee                   	out    %al,(%dx)
80105f27:	b8 03 00 00 00       	mov    $0x3,%eax
80105f2c:	89 fa                	mov    %edi,%edx
80105f2e:	ee                   	out    %al,(%dx)
80105f2f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f34:	89 c8                	mov    %ecx,%eax
80105f36:	ee                   	out    %al,(%dx)
80105f37:	b8 01 00 00 00       	mov    $0x1,%eax
80105f3c:	89 f2                	mov    %esi,%edx
80105f3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f3f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f44:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f45:	3c ff                	cmp    $0xff,%al
80105f47:	74 5a                	je     80105fa3 <uartinit+0xb3>
  uart = 1;
80105f49:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105f50:	00 00 00 
80105f53:	89 da                	mov    %ebx,%edx
80105f55:	ec                   	in     (%dx),%al
80105f56:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f5b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f5c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f5f:	bb 60 7d 10 80       	mov    $0x80107d60,%ebx
  ioapicenable(IRQ_COM1, 0);
80105f64:	6a 00                	push   $0x0
80105f66:	6a 04                	push   $0x4
80105f68:	e8 83 c3 ff ff       	call   801022f0 <ioapicenable>
80105f6d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f70:	b8 78 00 00 00       	mov    $0x78,%eax
80105f75:	eb 13                	jmp    80105f8a <uartinit+0x9a>
80105f77:	89 f6                	mov    %esi,%esi
80105f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f80:	83 c3 01             	add    $0x1,%ebx
80105f83:	0f be 03             	movsbl (%ebx),%eax
80105f86:	84 c0                	test   %al,%al
80105f88:	74 19                	je     80105fa3 <uartinit+0xb3>
  if(!uart)
80105f8a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105f90:	85 d2                	test   %edx,%edx
80105f92:	74 ec                	je     80105f80 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105f94:	83 c3 01             	add    $0x1,%ebx
80105f97:	e8 04 ff ff ff       	call   80105ea0 <uartputc.part.0>
80105f9c:	0f be 03             	movsbl (%ebx),%eax
80105f9f:	84 c0                	test   %al,%al
80105fa1:	75 e7                	jne    80105f8a <uartinit+0x9a>
}
80105fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa6:	5b                   	pop    %ebx
80105fa7:	5e                   	pop    %esi
80105fa8:	5f                   	pop    %edi
80105fa9:	5d                   	pop    %ebp
80105faa:	c3                   	ret    
80105fab:	90                   	nop
80105fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fb0 <uartputc>:
  if(!uart)
80105fb0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105fb6:	55                   	push   %ebp
80105fb7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105fb9:	85 d2                	test   %edx,%edx
{
80105fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105fbe:	74 10                	je     80105fd0 <uartputc+0x20>
}
80105fc0:	5d                   	pop    %ebp
80105fc1:	e9 da fe ff ff       	jmp    80105ea0 <uartputc.part.0>
80105fc6:	8d 76 00             	lea    0x0(%esi),%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fd0:	5d                   	pop    %ebp
80105fd1:	c3                   	ret    
80105fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fe0 <uartintr>:

void
uartintr(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fe6:	68 70 5e 10 80       	push   $0x80105e70
80105feb:	e8 20 a8 ff ff       	call   80100810 <consoleintr>
}
80105ff0:	83 c4 10             	add    $0x10,%esp
80105ff3:	c9                   	leave  
80105ff4:	c3                   	ret    

80105ff5 <vector0>:
80105ff5:	6a 00                	push   $0x0
80105ff7:	6a 00                	push   $0x0
80105ff9:	e9 1c fb ff ff       	jmp    80105b1a <alltraps>

80105ffe <vector1>:
80105ffe:	6a 00                	push   $0x0
80106000:	6a 01                	push   $0x1
80106002:	e9 13 fb ff ff       	jmp    80105b1a <alltraps>

80106007 <vector2>:
80106007:	6a 00                	push   $0x0
80106009:	6a 02                	push   $0x2
8010600b:	e9 0a fb ff ff       	jmp    80105b1a <alltraps>

80106010 <vector3>:
80106010:	6a 00                	push   $0x0
80106012:	6a 03                	push   $0x3
80106014:	e9 01 fb ff ff       	jmp    80105b1a <alltraps>

80106019 <vector4>:
80106019:	6a 00                	push   $0x0
8010601b:	6a 04                	push   $0x4
8010601d:	e9 f8 fa ff ff       	jmp    80105b1a <alltraps>

80106022 <vector5>:
80106022:	6a 00                	push   $0x0
80106024:	6a 05                	push   $0x5
80106026:	e9 ef fa ff ff       	jmp    80105b1a <alltraps>

8010602b <vector6>:
8010602b:	6a 00                	push   $0x0
8010602d:	6a 06                	push   $0x6
8010602f:	e9 e6 fa ff ff       	jmp    80105b1a <alltraps>

80106034 <vector7>:
80106034:	6a 00                	push   $0x0
80106036:	6a 07                	push   $0x7
80106038:	e9 dd fa ff ff       	jmp    80105b1a <alltraps>

8010603d <vector8>:
8010603d:	6a 08                	push   $0x8
8010603f:	e9 d6 fa ff ff       	jmp    80105b1a <alltraps>

80106044 <vector9>:
80106044:	6a 00                	push   $0x0
80106046:	6a 09                	push   $0x9
80106048:	e9 cd fa ff ff       	jmp    80105b1a <alltraps>

8010604d <vector10>:
8010604d:	6a 0a                	push   $0xa
8010604f:	e9 c6 fa ff ff       	jmp    80105b1a <alltraps>

80106054 <vector11>:
80106054:	6a 0b                	push   $0xb
80106056:	e9 bf fa ff ff       	jmp    80105b1a <alltraps>

8010605b <vector12>:
8010605b:	6a 0c                	push   $0xc
8010605d:	e9 b8 fa ff ff       	jmp    80105b1a <alltraps>

80106062 <vector13>:
80106062:	6a 0d                	push   $0xd
80106064:	e9 b1 fa ff ff       	jmp    80105b1a <alltraps>

80106069 <vector14>:
80106069:	6a 0e                	push   $0xe
8010606b:	e9 aa fa ff ff       	jmp    80105b1a <alltraps>

80106070 <vector15>:
80106070:	6a 00                	push   $0x0
80106072:	6a 0f                	push   $0xf
80106074:	e9 a1 fa ff ff       	jmp    80105b1a <alltraps>

80106079 <vector16>:
80106079:	6a 00                	push   $0x0
8010607b:	6a 10                	push   $0x10
8010607d:	e9 98 fa ff ff       	jmp    80105b1a <alltraps>

80106082 <vector17>:
80106082:	6a 11                	push   $0x11
80106084:	e9 91 fa ff ff       	jmp    80105b1a <alltraps>

80106089 <vector18>:
80106089:	6a 00                	push   $0x0
8010608b:	6a 12                	push   $0x12
8010608d:	e9 88 fa ff ff       	jmp    80105b1a <alltraps>

80106092 <vector19>:
80106092:	6a 00                	push   $0x0
80106094:	6a 13                	push   $0x13
80106096:	e9 7f fa ff ff       	jmp    80105b1a <alltraps>

8010609b <vector20>:
8010609b:	6a 00                	push   $0x0
8010609d:	6a 14                	push   $0x14
8010609f:	e9 76 fa ff ff       	jmp    80105b1a <alltraps>

801060a4 <vector21>:
801060a4:	6a 00                	push   $0x0
801060a6:	6a 15                	push   $0x15
801060a8:	e9 6d fa ff ff       	jmp    80105b1a <alltraps>

801060ad <vector22>:
801060ad:	6a 00                	push   $0x0
801060af:	6a 16                	push   $0x16
801060b1:	e9 64 fa ff ff       	jmp    80105b1a <alltraps>

801060b6 <vector23>:
801060b6:	6a 00                	push   $0x0
801060b8:	6a 17                	push   $0x17
801060ba:	e9 5b fa ff ff       	jmp    80105b1a <alltraps>

801060bf <vector24>:
801060bf:	6a 00                	push   $0x0
801060c1:	6a 18                	push   $0x18
801060c3:	e9 52 fa ff ff       	jmp    80105b1a <alltraps>

801060c8 <vector25>:
801060c8:	6a 00                	push   $0x0
801060ca:	6a 19                	push   $0x19
801060cc:	e9 49 fa ff ff       	jmp    80105b1a <alltraps>

801060d1 <vector26>:
801060d1:	6a 00                	push   $0x0
801060d3:	6a 1a                	push   $0x1a
801060d5:	e9 40 fa ff ff       	jmp    80105b1a <alltraps>

801060da <vector27>:
801060da:	6a 00                	push   $0x0
801060dc:	6a 1b                	push   $0x1b
801060de:	e9 37 fa ff ff       	jmp    80105b1a <alltraps>

801060e3 <vector28>:
801060e3:	6a 00                	push   $0x0
801060e5:	6a 1c                	push   $0x1c
801060e7:	e9 2e fa ff ff       	jmp    80105b1a <alltraps>

801060ec <vector29>:
801060ec:	6a 00                	push   $0x0
801060ee:	6a 1d                	push   $0x1d
801060f0:	e9 25 fa ff ff       	jmp    80105b1a <alltraps>

801060f5 <vector30>:
801060f5:	6a 00                	push   $0x0
801060f7:	6a 1e                	push   $0x1e
801060f9:	e9 1c fa ff ff       	jmp    80105b1a <alltraps>

801060fe <vector31>:
801060fe:	6a 00                	push   $0x0
80106100:	6a 1f                	push   $0x1f
80106102:	e9 13 fa ff ff       	jmp    80105b1a <alltraps>

80106107 <vector32>:
80106107:	6a 00                	push   $0x0
80106109:	6a 20                	push   $0x20
8010610b:	e9 0a fa ff ff       	jmp    80105b1a <alltraps>

80106110 <vector33>:
80106110:	6a 00                	push   $0x0
80106112:	6a 21                	push   $0x21
80106114:	e9 01 fa ff ff       	jmp    80105b1a <alltraps>

80106119 <vector34>:
80106119:	6a 00                	push   $0x0
8010611b:	6a 22                	push   $0x22
8010611d:	e9 f8 f9 ff ff       	jmp    80105b1a <alltraps>

80106122 <vector35>:
80106122:	6a 00                	push   $0x0
80106124:	6a 23                	push   $0x23
80106126:	e9 ef f9 ff ff       	jmp    80105b1a <alltraps>

8010612b <vector36>:
8010612b:	6a 00                	push   $0x0
8010612d:	6a 24                	push   $0x24
8010612f:	e9 e6 f9 ff ff       	jmp    80105b1a <alltraps>

80106134 <vector37>:
80106134:	6a 00                	push   $0x0
80106136:	6a 25                	push   $0x25
80106138:	e9 dd f9 ff ff       	jmp    80105b1a <alltraps>

8010613d <vector38>:
8010613d:	6a 00                	push   $0x0
8010613f:	6a 26                	push   $0x26
80106141:	e9 d4 f9 ff ff       	jmp    80105b1a <alltraps>

80106146 <vector39>:
80106146:	6a 00                	push   $0x0
80106148:	6a 27                	push   $0x27
8010614a:	e9 cb f9 ff ff       	jmp    80105b1a <alltraps>

8010614f <vector40>:
8010614f:	6a 00                	push   $0x0
80106151:	6a 28                	push   $0x28
80106153:	e9 c2 f9 ff ff       	jmp    80105b1a <alltraps>

80106158 <vector41>:
80106158:	6a 00                	push   $0x0
8010615a:	6a 29                	push   $0x29
8010615c:	e9 b9 f9 ff ff       	jmp    80105b1a <alltraps>

80106161 <vector42>:
80106161:	6a 00                	push   $0x0
80106163:	6a 2a                	push   $0x2a
80106165:	e9 b0 f9 ff ff       	jmp    80105b1a <alltraps>

8010616a <vector43>:
8010616a:	6a 00                	push   $0x0
8010616c:	6a 2b                	push   $0x2b
8010616e:	e9 a7 f9 ff ff       	jmp    80105b1a <alltraps>

80106173 <vector44>:
80106173:	6a 00                	push   $0x0
80106175:	6a 2c                	push   $0x2c
80106177:	e9 9e f9 ff ff       	jmp    80105b1a <alltraps>

8010617c <vector45>:
8010617c:	6a 00                	push   $0x0
8010617e:	6a 2d                	push   $0x2d
80106180:	e9 95 f9 ff ff       	jmp    80105b1a <alltraps>

80106185 <vector46>:
80106185:	6a 00                	push   $0x0
80106187:	6a 2e                	push   $0x2e
80106189:	e9 8c f9 ff ff       	jmp    80105b1a <alltraps>

8010618e <vector47>:
8010618e:	6a 00                	push   $0x0
80106190:	6a 2f                	push   $0x2f
80106192:	e9 83 f9 ff ff       	jmp    80105b1a <alltraps>

80106197 <vector48>:
80106197:	6a 00                	push   $0x0
80106199:	6a 30                	push   $0x30
8010619b:	e9 7a f9 ff ff       	jmp    80105b1a <alltraps>

801061a0 <vector49>:
801061a0:	6a 00                	push   $0x0
801061a2:	6a 31                	push   $0x31
801061a4:	e9 71 f9 ff ff       	jmp    80105b1a <alltraps>

801061a9 <vector50>:
801061a9:	6a 00                	push   $0x0
801061ab:	6a 32                	push   $0x32
801061ad:	e9 68 f9 ff ff       	jmp    80105b1a <alltraps>

801061b2 <vector51>:
801061b2:	6a 00                	push   $0x0
801061b4:	6a 33                	push   $0x33
801061b6:	e9 5f f9 ff ff       	jmp    80105b1a <alltraps>

801061bb <vector52>:
801061bb:	6a 00                	push   $0x0
801061bd:	6a 34                	push   $0x34
801061bf:	e9 56 f9 ff ff       	jmp    80105b1a <alltraps>

801061c4 <vector53>:
801061c4:	6a 00                	push   $0x0
801061c6:	6a 35                	push   $0x35
801061c8:	e9 4d f9 ff ff       	jmp    80105b1a <alltraps>

801061cd <vector54>:
801061cd:	6a 00                	push   $0x0
801061cf:	6a 36                	push   $0x36
801061d1:	e9 44 f9 ff ff       	jmp    80105b1a <alltraps>

801061d6 <vector55>:
801061d6:	6a 00                	push   $0x0
801061d8:	6a 37                	push   $0x37
801061da:	e9 3b f9 ff ff       	jmp    80105b1a <alltraps>

801061df <vector56>:
801061df:	6a 00                	push   $0x0
801061e1:	6a 38                	push   $0x38
801061e3:	e9 32 f9 ff ff       	jmp    80105b1a <alltraps>

801061e8 <vector57>:
801061e8:	6a 00                	push   $0x0
801061ea:	6a 39                	push   $0x39
801061ec:	e9 29 f9 ff ff       	jmp    80105b1a <alltraps>

801061f1 <vector58>:
801061f1:	6a 00                	push   $0x0
801061f3:	6a 3a                	push   $0x3a
801061f5:	e9 20 f9 ff ff       	jmp    80105b1a <alltraps>

801061fa <vector59>:
801061fa:	6a 00                	push   $0x0
801061fc:	6a 3b                	push   $0x3b
801061fe:	e9 17 f9 ff ff       	jmp    80105b1a <alltraps>

80106203 <vector60>:
80106203:	6a 00                	push   $0x0
80106205:	6a 3c                	push   $0x3c
80106207:	e9 0e f9 ff ff       	jmp    80105b1a <alltraps>

8010620c <vector61>:
8010620c:	6a 00                	push   $0x0
8010620e:	6a 3d                	push   $0x3d
80106210:	e9 05 f9 ff ff       	jmp    80105b1a <alltraps>

80106215 <vector62>:
80106215:	6a 00                	push   $0x0
80106217:	6a 3e                	push   $0x3e
80106219:	e9 fc f8 ff ff       	jmp    80105b1a <alltraps>

8010621e <vector63>:
8010621e:	6a 00                	push   $0x0
80106220:	6a 3f                	push   $0x3f
80106222:	e9 f3 f8 ff ff       	jmp    80105b1a <alltraps>

80106227 <vector64>:
80106227:	6a 00                	push   $0x0
80106229:	6a 40                	push   $0x40
8010622b:	e9 ea f8 ff ff       	jmp    80105b1a <alltraps>

80106230 <vector65>:
80106230:	6a 00                	push   $0x0
80106232:	6a 41                	push   $0x41
80106234:	e9 e1 f8 ff ff       	jmp    80105b1a <alltraps>

80106239 <vector66>:
80106239:	6a 00                	push   $0x0
8010623b:	6a 42                	push   $0x42
8010623d:	e9 d8 f8 ff ff       	jmp    80105b1a <alltraps>

80106242 <vector67>:
80106242:	6a 00                	push   $0x0
80106244:	6a 43                	push   $0x43
80106246:	e9 cf f8 ff ff       	jmp    80105b1a <alltraps>

8010624b <vector68>:
8010624b:	6a 00                	push   $0x0
8010624d:	6a 44                	push   $0x44
8010624f:	e9 c6 f8 ff ff       	jmp    80105b1a <alltraps>

80106254 <vector69>:
80106254:	6a 00                	push   $0x0
80106256:	6a 45                	push   $0x45
80106258:	e9 bd f8 ff ff       	jmp    80105b1a <alltraps>

8010625d <vector70>:
8010625d:	6a 00                	push   $0x0
8010625f:	6a 46                	push   $0x46
80106261:	e9 b4 f8 ff ff       	jmp    80105b1a <alltraps>

80106266 <vector71>:
80106266:	6a 00                	push   $0x0
80106268:	6a 47                	push   $0x47
8010626a:	e9 ab f8 ff ff       	jmp    80105b1a <alltraps>

8010626f <vector72>:
8010626f:	6a 00                	push   $0x0
80106271:	6a 48                	push   $0x48
80106273:	e9 a2 f8 ff ff       	jmp    80105b1a <alltraps>

80106278 <vector73>:
80106278:	6a 00                	push   $0x0
8010627a:	6a 49                	push   $0x49
8010627c:	e9 99 f8 ff ff       	jmp    80105b1a <alltraps>

80106281 <vector74>:
80106281:	6a 00                	push   $0x0
80106283:	6a 4a                	push   $0x4a
80106285:	e9 90 f8 ff ff       	jmp    80105b1a <alltraps>

8010628a <vector75>:
8010628a:	6a 00                	push   $0x0
8010628c:	6a 4b                	push   $0x4b
8010628e:	e9 87 f8 ff ff       	jmp    80105b1a <alltraps>

80106293 <vector76>:
80106293:	6a 00                	push   $0x0
80106295:	6a 4c                	push   $0x4c
80106297:	e9 7e f8 ff ff       	jmp    80105b1a <alltraps>

8010629c <vector77>:
8010629c:	6a 00                	push   $0x0
8010629e:	6a 4d                	push   $0x4d
801062a0:	e9 75 f8 ff ff       	jmp    80105b1a <alltraps>

801062a5 <vector78>:
801062a5:	6a 00                	push   $0x0
801062a7:	6a 4e                	push   $0x4e
801062a9:	e9 6c f8 ff ff       	jmp    80105b1a <alltraps>

801062ae <vector79>:
801062ae:	6a 00                	push   $0x0
801062b0:	6a 4f                	push   $0x4f
801062b2:	e9 63 f8 ff ff       	jmp    80105b1a <alltraps>

801062b7 <vector80>:
801062b7:	6a 00                	push   $0x0
801062b9:	6a 50                	push   $0x50
801062bb:	e9 5a f8 ff ff       	jmp    80105b1a <alltraps>

801062c0 <vector81>:
801062c0:	6a 00                	push   $0x0
801062c2:	6a 51                	push   $0x51
801062c4:	e9 51 f8 ff ff       	jmp    80105b1a <alltraps>

801062c9 <vector82>:
801062c9:	6a 00                	push   $0x0
801062cb:	6a 52                	push   $0x52
801062cd:	e9 48 f8 ff ff       	jmp    80105b1a <alltraps>

801062d2 <vector83>:
801062d2:	6a 00                	push   $0x0
801062d4:	6a 53                	push   $0x53
801062d6:	e9 3f f8 ff ff       	jmp    80105b1a <alltraps>

801062db <vector84>:
801062db:	6a 00                	push   $0x0
801062dd:	6a 54                	push   $0x54
801062df:	e9 36 f8 ff ff       	jmp    80105b1a <alltraps>

801062e4 <vector85>:
801062e4:	6a 00                	push   $0x0
801062e6:	6a 55                	push   $0x55
801062e8:	e9 2d f8 ff ff       	jmp    80105b1a <alltraps>

801062ed <vector86>:
801062ed:	6a 00                	push   $0x0
801062ef:	6a 56                	push   $0x56
801062f1:	e9 24 f8 ff ff       	jmp    80105b1a <alltraps>

801062f6 <vector87>:
801062f6:	6a 00                	push   $0x0
801062f8:	6a 57                	push   $0x57
801062fa:	e9 1b f8 ff ff       	jmp    80105b1a <alltraps>

801062ff <vector88>:
801062ff:	6a 00                	push   $0x0
80106301:	6a 58                	push   $0x58
80106303:	e9 12 f8 ff ff       	jmp    80105b1a <alltraps>

80106308 <vector89>:
80106308:	6a 00                	push   $0x0
8010630a:	6a 59                	push   $0x59
8010630c:	e9 09 f8 ff ff       	jmp    80105b1a <alltraps>

80106311 <vector90>:
80106311:	6a 00                	push   $0x0
80106313:	6a 5a                	push   $0x5a
80106315:	e9 00 f8 ff ff       	jmp    80105b1a <alltraps>

8010631a <vector91>:
8010631a:	6a 00                	push   $0x0
8010631c:	6a 5b                	push   $0x5b
8010631e:	e9 f7 f7 ff ff       	jmp    80105b1a <alltraps>

80106323 <vector92>:
80106323:	6a 00                	push   $0x0
80106325:	6a 5c                	push   $0x5c
80106327:	e9 ee f7 ff ff       	jmp    80105b1a <alltraps>

8010632c <vector93>:
8010632c:	6a 00                	push   $0x0
8010632e:	6a 5d                	push   $0x5d
80106330:	e9 e5 f7 ff ff       	jmp    80105b1a <alltraps>

80106335 <vector94>:
80106335:	6a 00                	push   $0x0
80106337:	6a 5e                	push   $0x5e
80106339:	e9 dc f7 ff ff       	jmp    80105b1a <alltraps>

8010633e <vector95>:
8010633e:	6a 00                	push   $0x0
80106340:	6a 5f                	push   $0x5f
80106342:	e9 d3 f7 ff ff       	jmp    80105b1a <alltraps>

80106347 <vector96>:
80106347:	6a 00                	push   $0x0
80106349:	6a 60                	push   $0x60
8010634b:	e9 ca f7 ff ff       	jmp    80105b1a <alltraps>

80106350 <vector97>:
80106350:	6a 00                	push   $0x0
80106352:	6a 61                	push   $0x61
80106354:	e9 c1 f7 ff ff       	jmp    80105b1a <alltraps>

80106359 <vector98>:
80106359:	6a 00                	push   $0x0
8010635b:	6a 62                	push   $0x62
8010635d:	e9 b8 f7 ff ff       	jmp    80105b1a <alltraps>

80106362 <vector99>:
80106362:	6a 00                	push   $0x0
80106364:	6a 63                	push   $0x63
80106366:	e9 af f7 ff ff       	jmp    80105b1a <alltraps>

8010636b <vector100>:
8010636b:	6a 00                	push   $0x0
8010636d:	6a 64                	push   $0x64
8010636f:	e9 a6 f7 ff ff       	jmp    80105b1a <alltraps>

80106374 <vector101>:
80106374:	6a 00                	push   $0x0
80106376:	6a 65                	push   $0x65
80106378:	e9 9d f7 ff ff       	jmp    80105b1a <alltraps>

8010637d <vector102>:
8010637d:	6a 00                	push   $0x0
8010637f:	6a 66                	push   $0x66
80106381:	e9 94 f7 ff ff       	jmp    80105b1a <alltraps>

80106386 <vector103>:
80106386:	6a 00                	push   $0x0
80106388:	6a 67                	push   $0x67
8010638a:	e9 8b f7 ff ff       	jmp    80105b1a <alltraps>

8010638f <vector104>:
8010638f:	6a 00                	push   $0x0
80106391:	6a 68                	push   $0x68
80106393:	e9 82 f7 ff ff       	jmp    80105b1a <alltraps>

80106398 <vector105>:
80106398:	6a 00                	push   $0x0
8010639a:	6a 69                	push   $0x69
8010639c:	e9 79 f7 ff ff       	jmp    80105b1a <alltraps>

801063a1 <vector106>:
801063a1:	6a 00                	push   $0x0
801063a3:	6a 6a                	push   $0x6a
801063a5:	e9 70 f7 ff ff       	jmp    80105b1a <alltraps>

801063aa <vector107>:
801063aa:	6a 00                	push   $0x0
801063ac:	6a 6b                	push   $0x6b
801063ae:	e9 67 f7 ff ff       	jmp    80105b1a <alltraps>

801063b3 <vector108>:
801063b3:	6a 00                	push   $0x0
801063b5:	6a 6c                	push   $0x6c
801063b7:	e9 5e f7 ff ff       	jmp    80105b1a <alltraps>

801063bc <vector109>:
801063bc:	6a 00                	push   $0x0
801063be:	6a 6d                	push   $0x6d
801063c0:	e9 55 f7 ff ff       	jmp    80105b1a <alltraps>

801063c5 <vector110>:
801063c5:	6a 00                	push   $0x0
801063c7:	6a 6e                	push   $0x6e
801063c9:	e9 4c f7 ff ff       	jmp    80105b1a <alltraps>

801063ce <vector111>:
801063ce:	6a 00                	push   $0x0
801063d0:	6a 6f                	push   $0x6f
801063d2:	e9 43 f7 ff ff       	jmp    80105b1a <alltraps>

801063d7 <vector112>:
801063d7:	6a 00                	push   $0x0
801063d9:	6a 70                	push   $0x70
801063db:	e9 3a f7 ff ff       	jmp    80105b1a <alltraps>

801063e0 <vector113>:
801063e0:	6a 00                	push   $0x0
801063e2:	6a 71                	push   $0x71
801063e4:	e9 31 f7 ff ff       	jmp    80105b1a <alltraps>

801063e9 <vector114>:
801063e9:	6a 00                	push   $0x0
801063eb:	6a 72                	push   $0x72
801063ed:	e9 28 f7 ff ff       	jmp    80105b1a <alltraps>

801063f2 <vector115>:
801063f2:	6a 00                	push   $0x0
801063f4:	6a 73                	push   $0x73
801063f6:	e9 1f f7 ff ff       	jmp    80105b1a <alltraps>

801063fb <vector116>:
801063fb:	6a 00                	push   $0x0
801063fd:	6a 74                	push   $0x74
801063ff:	e9 16 f7 ff ff       	jmp    80105b1a <alltraps>

80106404 <vector117>:
80106404:	6a 00                	push   $0x0
80106406:	6a 75                	push   $0x75
80106408:	e9 0d f7 ff ff       	jmp    80105b1a <alltraps>

8010640d <vector118>:
8010640d:	6a 00                	push   $0x0
8010640f:	6a 76                	push   $0x76
80106411:	e9 04 f7 ff ff       	jmp    80105b1a <alltraps>

80106416 <vector119>:
80106416:	6a 00                	push   $0x0
80106418:	6a 77                	push   $0x77
8010641a:	e9 fb f6 ff ff       	jmp    80105b1a <alltraps>

8010641f <vector120>:
8010641f:	6a 00                	push   $0x0
80106421:	6a 78                	push   $0x78
80106423:	e9 f2 f6 ff ff       	jmp    80105b1a <alltraps>

80106428 <vector121>:
80106428:	6a 00                	push   $0x0
8010642a:	6a 79                	push   $0x79
8010642c:	e9 e9 f6 ff ff       	jmp    80105b1a <alltraps>

80106431 <vector122>:
80106431:	6a 00                	push   $0x0
80106433:	6a 7a                	push   $0x7a
80106435:	e9 e0 f6 ff ff       	jmp    80105b1a <alltraps>

8010643a <vector123>:
8010643a:	6a 00                	push   $0x0
8010643c:	6a 7b                	push   $0x7b
8010643e:	e9 d7 f6 ff ff       	jmp    80105b1a <alltraps>

80106443 <vector124>:
80106443:	6a 00                	push   $0x0
80106445:	6a 7c                	push   $0x7c
80106447:	e9 ce f6 ff ff       	jmp    80105b1a <alltraps>

8010644c <vector125>:
8010644c:	6a 00                	push   $0x0
8010644e:	6a 7d                	push   $0x7d
80106450:	e9 c5 f6 ff ff       	jmp    80105b1a <alltraps>

80106455 <vector126>:
80106455:	6a 00                	push   $0x0
80106457:	6a 7e                	push   $0x7e
80106459:	e9 bc f6 ff ff       	jmp    80105b1a <alltraps>

8010645e <vector127>:
8010645e:	6a 00                	push   $0x0
80106460:	6a 7f                	push   $0x7f
80106462:	e9 b3 f6 ff ff       	jmp    80105b1a <alltraps>

80106467 <vector128>:
80106467:	6a 00                	push   $0x0
80106469:	68 80 00 00 00       	push   $0x80
8010646e:	e9 a7 f6 ff ff       	jmp    80105b1a <alltraps>

80106473 <vector129>:
80106473:	6a 00                	push   $0x0
80106475:	68 81 00 00 00       	push   $0x81
8010647a:	e9 9b f6 ff ff       	jmp    80105b1a <alltraps>

8010647f <vector130>:
8010647f:	6a 00                	push   $0x0
80106481:	68 82 00 00 00       	push   $0x82
80106486:	e9 8f f6 ff ff       	jmp    80105b1a <alltraps>

8010648b <vector131>:
8010648b:	6a 00                	push   $0x0
8010648d:	68 83 00 00 00       	push   $0x83
80106492:	e9 83 f6 ff ff       	jmp    80105b1a <alltraps>

80106497 <vector132>:
80106497:	6a 00                	push   $0x0
80106499:	68 84 00 00 00       	push   $0x84
8010649e:	e9 77 f6 ff ff       	jmp    80105b1a <alltraps>

801064a3 <vector133>:
801064a3:	6a 00                	push   $0x0
801064a5:	68 85 00 00 00       	push   $0x85
801064aa:	e9 6b f6 ff ff       	jmp    80105b1a <alltraps>

801064af <vector134>:
801064af:	6a 00                	push   $0x0
801064b1:	68 86 00 00 00       	push   $0x86
801064b6:	e9 5f f6 ff ff       	jmp    80105b1a <alltraps>

801064bb <vector135>:
801064bb:	6a 00                	push   $0x0
801064bd:	68 87 00 00 00       	push   $0x87
801064c2:	e9 53 f6 ff ff       	jmp    80105b1a <alltraps>

801064c7 <vector136>:
801064c7:	6a 00                	push   $0x0
801064c9:	68 88 00 00 00       	push   $0x88
801064ce:	e9 47 f6 ff ff       	jmp    80105b1a <alltraps>

801064d3 <vector137>:
801064d3:	6a 00                	push   $0x0
801064d5:	68 89 00 00 00       	push   $0x89
801064da:	e9 3b f6 ff ff       	jmp    80105b1a <alltraps>

801064df <vector138>:
801064df:	6a 00                	push   $0x0
801064e1:	68 8a 00 00 00       	push   $0x8a
801064e6:	e9 2f f6 ff ff       	jmp    80105b1a <alltraps>

801064eb <vector139>:
801064eb:	6a 00                	push   $0x0
801064ed:	68 8b 00 00 00       	push   $0x8b
801064f2:	e9 23 f6 ff ff       	jmp    80105b1a <alltraps>

801064f7 <vector140>:
801064f7:	6a 00                	push   $0x0
801064f9:	68 8c 00 00 00       	push   $0x8c
801064fe:	e9 17 f6 ff ff       	jmp    80105b1a <alltraps>

80106503 <vector141>:
80106503:	6a 00                	push   $0x0
80106505:	68 8d 00 00 00       	push   $0x8d
8010650a:	e9 0b f6 ff ff       	jmp    80105b1a <alltraps>

8010650f <vector142>:
8010650f:	6a 00                	push   $0x0
80106511:	68 8e 00 00 00       	push   $0x8e
80106516:	e9 ff f5 ff ff       	jmp    80105b1a <alltraps>

8010651b <vector143>:
8010651b:	6a 00                	push   $0x0
8010651d:	68 8f 00 00 00       	push   $0x8f
80106522:	e9 f3 f5 ff ff       	jmp    80105b1a <alltraps>

80106527 <vector144>:
80106527:	6a 00                	push   $0x0
80106529:	68 90 00 00 00       	push   $0x90
8010652e:	e9 e7 f5 ff ff       	jmp    80105b1a <alltraps>

80106533 <vector145>:
80106533:	6a 00                	push   $0x0
80106535:	68 91 00 00 00       	push   $0x91
8010653a:	e9 db f5 ff ff       	jmp    80105b1a <alltraps>

8010653f <vector146>:
8010653f:	6a 00                	push   $0x0
80106541:	68 92 00 00 00       	push   $0x92
80106546:	e9 cf f5 ff ff       	jmp    80105b1a <alltraps>

8010654b <vector147>:
8010654b:	6a 00                	push   $0x0
8010654d:	68 93 00 00 00       	push   $0x93
80106552:	e9 c3 f5 ff ff       	jmp    80105b1a <alltraps>

80106557 <vector148>:
80106557:	6a 00                	push   $0x0
80106559:	68 94 00 00 00       	push   $0x94
8010655e:	e9 b7 f5 ff ff       	jmp    80105b1a <alltraps>

80106563 <vector149>:
80106563:	6a 00                	push   $0x0
80106565:	68 95 00 00 00       	push   $0x95
8010656a:	e9 ab f5 ff ff       	jmp    80105b1a <alltraps>

8010656f <vector150>:
8010656f:	6a 00                	push   $0x0
80106571:	68 96 00 00 00       	push   $0x96
80106576:	e9 9f f5 ff ff       	jmp    80105b1a <alltraps>

8010657b <vector151>:
8010657b:	6a 00                	push   $0x0
8010657d:	68 97 00 00 00       	push   $0x97
80106582:	e9 93 f5 ff ff       	jmp    80105b1a <alltraps>

80106587 <vector152>:
80106587:	6a 00                	push   $0x0
80106589:	68 98 00 00 00       	push   $0x98
8010658e:	e9 87 f5 ff ff       	jmp    80105b1a <alltraps>

80106593 <vector153>:
80106593:	6a 00                	push   $0x0
80106595:	68 99 00 00 00       	push   $0x99
8010659a:	e9 7b f5 ff ff       	jmp    80105b1a <alltraps>

8010659f <vector154>:
8010659f:	6a 00                	push   $0x0
801065a1:	68 9a 00 00 00       	push   $0x9a
801065a6:	e9 6f f5 ff ff       	jmp    80105b1a <alltraps>

801065ab <vector155>:
801065ab:	6a 00                	push   $0x0
801065ad:	68 9b 00 00 00       	push   $0x9b
801065b2:	e9 63 f5 ff ff       	jmp    80105b1a <alltraps>

801065b7 <vector156>:
801065b7:	6a 00                	push   $0x0
801065b9:	68 9c 00 00 00       	push   $0x9c
801065be:	e9 57 f5 ff ff       	jmp    80105b1a <alltraps>

801065c3 <vector157>:
801065c3:	6a 00                	push   $0x0
801065c5:	68 9d 00 00 00       	push   $0x9d
801065ca:	e9 4b f5 ff ff       	jmp    80105b1a <alltraps>

801065cf <vector158>:
801065cf:	6a 00                	push   $0x0
801065d1:	68 9e 00 00 00       	push   $0x9e
801065d6:	e9 3f f5 ff ff       	jmp    80105b1a <alltraps>

801065db <vector159>:
801065db:	6a 00                	push   $0x0
801065dd:	68 9f 00 00 00       	push   $0x9f
801065e2:	e9 33 f5 ff ff       	jmp    80105b1a <alltraps>

801065e7 <vector160>:
801065e7:	6a 00                	push   $0x0
801065e9:	68 a0 00 00 00       	push   $0xa0
801065ee:	e9 27 f5 ff ff       	jmp    80105b1a <alltraps>

801065f3 <vector161>:
801065f3:	6a 00                	push   $0x0
801065f5:	68 a1 00 00 00       	push   $0xa1
801065fa:	e9 1b f5 ff ff       	jmp    80105b1a <alltraps>

801065ff <vector162>:
801065ff:	6a 00                	push   $0x0
80106601:	68 a2 00 00 00       	push   $0xa2
80106606:	e9 0f f5 ff ff       	jmp    80105b1a <alltraps>

8010660b <vector163>:
8010660b:	6a 00                	push   $0x0
8010660d:	68 a3 00 00 00       	push   $0xa3
80106612:	e9 03 f5 ff ff       	jmp    80105b1a <alltraps>

80106617 <vector164>:
80106617:	6a 00                	push   $0x0
80106619:	68 a4 00 00 00       	push   $0xa4
8010661e:	e9 f7 f4 ff ff       	jmp    80105b1a <alltraps>

80106623 <vector165>:
80106623:	6a 00                	push   $0x0
80106625:	68 a5 00 00 00       	push   $0xa5
8010662a:	e9 eb f4 ff ff       	jmp    80105b1a <alltraps>

8010662f <vector166>:
8010662f:	6a 00                	push   $0x0
80106631:	68 a6 00 00 00       	push   $0xa6
80106636:	e9 df f4 ff ff       	jmp    80105b1a <alltraps>

8010663b <vector167>:
8010663b:	6a 00                	push   $0x0
8010663d:	68 a7 00 00 00       	push   $0xa7
80106642:	e9 d3 f4 ff ff       	jmp    80105b1a <alltraps>

80106647 <vector168>:
80106647:	6a 00                	push   $0x0
80106649:	68 a8 00 00 00       	push   $0xa8
8010664e:	e9 c7 f4 ff ff       	jmp    80105b1a <alltraps>

80106653 <vector169>:
80106653:	6a 00                	push   $0x0
80106655:	68 a9 00 00 00       	push   $0xa9
8010665a:	e9 bb f4 ff ff       	jmp    80105b1a <alltraps>

8010665f <vector170>:
8010665f:	6a 00                	push   $0x0
80106661:	68 aa 00 00 00       	push   $0xaa
80106666:	e9 af f4 ff ff       	jmp    80105b1a <alltraps>

8010666b <vector171>:
8010666b:	6a 00                	push   $0x0
8010666d:	68 ab 00 00 00       	push   $0xab
80106672:	e9 a3 f4 ff ff       	jmp    80105b1a <alltraps>

80106677 <vector172>:
80106677:	6a 00                	push   $0x0
80106679:	68 ac 00 00 00       	push   $0xac
8010667e:	e9 97 f4 ff ff       	jmp    80105b1a <alltraps>

80106683 <vector173>:
80106683:	6a 00                	push   $0x0
80106685:	68 ad 00 00 00       	push   $0xad
8010668a:	e9 8b f4 ff ff       	jmp    80105b1a <alltraps>

8010668f <vector174>:
8010668f:	6a 00                	push   $0x0
80106691:	68 ae 00 00 00       	push   $0xae
80106696:	e9 7f f4 ff ff       	jmp    80105b1a <alltraps>

8010669b <vector175>:
8010669b:	6a 00                	push   $0x0
8010669d:	68 af 00 00 00       	push   $0xaf
801066a2:	e9 73 f4 ff ff       	jmp    80105b1a <alltraps>

801066a7 <vector176>:
801066a7:	6a 00                	push   $0x0
801066a9:	68 b0 00 00 00       	push   $0xb0
801066ae:	e9 67 f4 ff ff       	jmp    80105b1a <alltraps>

801066b3 <vector177>:
801066b3:	6a 00                	push   $0x0
801066b5:	68 b1 00 00 00       	push   $0xb1
801066ba:	e9 5b f4 ff ff       	jmp    80105b1a <alltraps>

801066bf <vector178>:
801066bf:	6a 00                	push   $0x0
801066c1:	68 b2 00 00 00       	push   $0xb2
801066c6:	e9 4f f4 ff ff       	jmp    80105b1a <alltraps>

801066cb <vector179>:
801066cb:	6a 00                	push   $0x0
801066cd:	68 b3 00 00 00       	push   $0xb3
801066d2:	e9 43 f4 ff ff       	jmp    80105b1a <alltraps>

801066d7 <vector180>:
801066d7:	6a 00                	push   $0x0
801066d9:	68 b4 00 00 00       	push   $0xb4
801066de:	e9 37 f4 ff ff       	jmp    80105b1a <alltraps>

801066e3 <vector181>:
801066e3:	6a 00                	push   $0x0
801066e5:	68 b5 00 00 00       	push   $0xb5
801066ea:	e9 2b f4 ff ff       	jmp    80105b1a <alltraps>

801066ef <vector182>:
801066ef:	6a 00                	push   $0x0
801066f1:	68 b6 00 00 00       	push   $0xb6
801066f6:	e9 1f f4 ff ff       	jmp    80105b1a <alltraps>

801066fb <vector183>:
801066fb:	6a 00                	push   $0x0
801066fd:	68 b7 00 00 00       	push   $0xb7
80106702:	e9 13 f4 ff ff       	jmp    80105b1a <alltraps>

80106707 <vector184>:
80106707:	6a 00                	push   $0x0
80106709:	68 b8 00 00 00       	push   $0xb8
8010670e:	e9 07 f4 ff ff       	jmp    80105b1a <alltraps>

80106713 <vector185>:
80106713:	6a 00                	push   $0x0
80106715:	68 b9 00 00 00       	push   $0xb9
8010671a:	e9 fb f3 ff ff       	jmp    80105b1a <alltraps>

8010671f <vector186>:
8010671f:	6a 00                	push   $0x0
80106721:	68 ba 00 00 00       	push   $0xba
80106726:	e9 ef f3 ff ff       	jmp    80105b1a <alltraps>

8010672b <vector187>:
8010672b:	6a 00                	push   $0x0
8010672d:	68 bb 00 00 00       	push   $0xbb
80106732:	e9 e3 f3 ff ff       	jmp    80105b1a <alltraps>

80106737 <vector188>:
80106737:	6a 00                	push   $0x0
80106739:	68 bc 00 00 00       	push   $0xbc
8010673e:	e9 d7 f3 ff ff       	jmp    80105b1a <alltraps>

80106743 <vector189>:
80106743:	6a 00                	push   $0x0
80106745:	68 bd 00 00 00       	push   $0xbd
8010674a:	e9 cb f3 ff ff       	jmp    80105b1a <alltraps>

8010674f <vector190>:
8010674f:	6a 00                	push   $0x0
80106751:	68 be 00 00 00       	push   $0xbe
80106756:	e9 bf f3 ff ff       	jmp    80105b1a <alltraps>

8010675b <vector191>:
8010675b:	6a 00                	push   $0x0
8010675d:	68 bf 00 00 00       	push   $0xbf
80106762:	e9 b3 f3 ff ff       	jmp    80105b1a <alltraps>

80106767 <vector192>:
80106767:	6a 00                	push   $0x0
80106769:	68 c0 00 00 00       	push   $0xc0
8010676e:	e9 a7 f3 ff ff       	jmp    80105b1a <alltraps>

80106773 <vector193>:
80106773:	6a 00                	push   $0x0
80106775:	68 c1 00 00 00       	push   $0xc1
8010677a:	e9 9b f3 ff ff       	jmp    80105b1a <alltraps>

8010677f <vector194>:
8010677f:	6a 00                	push   $0x0
80106781:	68 c2 00 00 00       	push   $0xc2
80106786:	e9 8f f3 ff ff       	jmp    80105b1a <alltraps>

8010678b <vector195>:
8010678b:	6a 00                	push   $0x0
8010678d:	68 c3 00 00 00       	push   $0xc3
80106792:	e9 83 f3 ff ff       	jmp    80105b1a <alltraps>

80106797 <vector196>:
80106797:	6a 00                	push   $0x0
80106799:	68 c4 00 00 00       	push   $0xc4
8010679e:	e9 77 f3 ff ff       	jmp    80105b1a <alltraps>

801067a3 <vector197>:
801067a3:	6a 00                	push   $0x0
801067a5:	68 c5 00 00 00       	push   $0xc5
801067aa:	e9 6b f3 ff ff       	jmp    80105b1a <alltraps>

801067af <vector198>:
801067af:	6a 00                	push   $0x0
801067b1:	68 c6 00 00 00       	push   $0xc6
801067b6:	e9 5f f3 ff ff       	jmp    80105b1a <alltraps>

801067bb <vector199>:
801067bb:	6a 00                	push   $0x0
801067bd:	68 c7 00 00 00       	push   $0xc7
801067c2:	e9 53 f3 ff ff       	jmp    80105b1a <alltraps>

801067c7 <vector200>:
801067c7:	6a 00                	push   $0x0
801067c9:	68 c8 00 00 00       	push   $0xc8
801067ce:	e9 47 f3 ff ff       	jmp    80105b1a <alltraps>

801067d3 <vector201>:
801067d3:	6a 00                	push   $0x0
801067d5:	68 c9 00 00 00       	push   $0xc9
801067da:	e9 3b f3 ff ff       	jmp    80105b1a <alltraps>

801067df <vector202>:
801067df:	6a 00                	push   $0x0
801067e1:	68 ca 00 00 00       	push   $0xca
801067e6:	e9 2f f3 ff ff       	jmp    80105b1a <alltraps>

801067eb <vector203>:
801067eb:	6a 00                	push   $0x0
801067ed:	68 cb 00 00 00       	push   $0xcb
801067f2:	e9 23 f3 ff ff       	jmp    80105b1a <alltraps>

801067f7 <vector204>:
801067f7:	6a 00                	push   $0x0
801067f9:	68 cc 00 00 00       	push   $0xcc
801067fe:	e9 17 f3 ff ff       	jmp    80105b1a <alltraps>

80106803 <vector205>:
80106803:	6a 00                	push   $0x0
80106805:	68 cd 00 00 00       	push   $0xcd
8010680a:	e9 0b f3 ff ff       	jmp    80105b1a <alltraps>

8010680f <vector206>:
8010680f:	6a 00                	push   $0x0
80106811:	68 ce 00 00 00       	push   $0xce
80106816:	e9 ff f2 ff ff       	jmp    80105b1a <alltraps>

8010681b <vector207>:
8010681b:	6a 00                	push   $0x0
8010681d:	68 cf 00 00 00       	push   $0xcf
80106822:	e9 f3 f2 ff ff       	jmp    80105b1a <alltraps>

80106827 <vector208>:
80106827:	6a 00                	push   $0x0
80106829:	68 d0 00 00 00       	push   $0xd0
8010682e:	e9 e7 f2 ff ff       	jmp    80105b1a <alltraps>

80106833 <vector209>:
80106833:	6a 00                	push   $0x0
80106835:	68 d1 00 00 00       	push   $0xd1
8010683a:	e9 db f2 ff ff       	jmp    80105b1a <alltraps>

8010683f <vector210>:
8010683f:	6a 00                	push   $0x0
80106841:	68 d2 00 00 00       	push   $0xd2
80106846:	e9 cf f2 ff ff       	jmp    80105b1a <alltraps>

8010684b <vector211>:
8010684b:	6a 00                	push   $0x0
8010684d:	68 d3 00 00 00       	push   $0xd3
80106852:	e9 c3 f2 ff ff       	jmp    80105b1a <alltraps>

80106857 <vector212>:
80106857:	6a 00                	push   $0x0
80106859:	68 d4 00 00 00       	push   $0xd4
8010685e:	e9 b7 f2 ff ff       	jmp    80105b1a <alltraps>

80106863 <vector213>:
80106863:	6a 00                	push   $0x0
80106865:	68 d5 00 00 00       	push   $0xd5
8010686a:	e9 ab f2 ff ff       	jmp    80105b1a <alltraps>

8010686f <vector214>:
8010686f:	6a 00                	push   $0x0
80106871:	68 d6 00 00 00       	push   $0xd6
80106876:	e9 9f f2 ff ff       	jmp    80105b1a <alltraps>

8010687b <vector215>:
8010687b:	6a 00                	push   $0x0
8010687d:	68 d7 00 00 00       	push   $0xd7
80106882:	e9 93 f2 ff ff       	jmp    80105b1a <alltraps>

80106887 <vector216>:
80106887:	6a 00                	push   $0x0
80106889:	68 d8 00 00 00       	push   $0xd8
8010688e:	e9 87 f2 ff ff       	jmp    80105b1a <alltraps>

80106893 <vector217>:
80106893:	6a 00                	push   $0x0
80106895:	68 d9 00 00 00       	push   $0xd9
8010689a:	e9 7b f2 ff ff       	jmp    80105b1a <alltraps>

8010689f <vector218>:
8010689f:	6a 00                	push   $0x0
801068a1:	68 da 00 00 00       	push   $0xda
801068a6:	e9 6f f2 ff ff       	jmp    80105b1a <alltraps>

801068ab <vector219>:
801068ab:	6a 00                	push   $0x0
801068ad:	68 db 00 00 00       	push   $0xdb
801068b2:	e9 63 f2 ff ff       	jmp    80105b1a <alltraps>

801068b7 <vector220>:
801068b7:	6a 00                	push   $0x0
801068b9:	68 dc 00 00 00       	push   $0xdc
801068be:	e9 57 f2 ff ff       	jmp    80105b1a <alltraps>

801068c3 <vector221>:
801068c3:	6a 00                	push   $0x0
801068c5:	68 dd 00 00 00       	push   $0xdd
801068ca:	e9 4b f2 ff ff       	jmp    80105b1a <alltraps>

801068cf <vector222>:
801068cf:	6a 00                	push   $0x0
801068d1:	68 de 00 00 00       	push   $0xde
801068d6:	e9 3f f2 ff ff       	jmp    80105b1a <alltraps>

801068db <vector223>:
801068db:	6a 00                	push   $0x0
801068dd:	68 df 00 00 00       	push   $0xdf
801068e2:	e9 33 f2 ff ff       	jmp    80105b1a <alltraps>

801068e7 <vector224>:
801068e7:	6a 00                	push   $0x0
801068e9:	68 e0 00 00 00       	push   $0xe0
801068ee:	e9 27 f2 ff ff       	jmp    80105b1a <alltraps>

801068f3 <vector225>:
801068f3:	6a 00                	push   $0x0
801068f5:	68 e1 00 00 00       	push   $0xe1
801068fa:	e9 1b f2 ff ff       	jmp    80105b1a <alltraps>

801068ff <vector226>:
801068ff:	6a 00                	push   $0x0
80106901:	68 e2 00 00 00       	push   $0xe2
80106906:	e9 0f f2 ff ff       	jmp    80105b1a <alltraps>

8010690b <vector227>:
8010690b:	6a 00                	push   $0x0
8010690d:	68 e3 00 00 00       	push   $0xe3
80106912:	e9 03 f2 ff ff       	jmp    80105b1a <alltraps>

80106917 <vector228>:
80106917:	6a 00                	push   $0x0
80106919:	68 e4 00 00 00       	push   $0xe4
8010691e:	e9 f7 f1 ff ff       	jmp    80105b1a <alltraps>

80106923 <vector229>:
80106923:	6a 00                	push   $0x0
80106925:	68 e5 00 00 00       	push   $0xe5
8010692a:	e9 eb f1 ff ff       	jmp    80105b1a <alltraps>

8010692f <vector230>:
8010692f:	6a 00                	push   $0x0
80106931:	68 e6 00 00 00       	push   $0xe6
80106936:	e9 df f1 ff ff       	jmp    80105b1a <alltraps>

8010693b <vector231>:
8010693b:	6a 00                	push   $0x0
8010693d:	68 e7 00 00 00       	push   $0xe7
80106942:	e9 d3 f1 ff ff       	jmp    80105b1a <alltraps>

80106947 <vector232>:
80106947:	6a 00                	push   $0x0
80106949:	68 e8 00 00 00       	push   $0xe8
8010694e:	e9 c7 f1 ff ff       	jmp    80105b1a <alltraps>

80106953 <vector233>:
80106953:	6a 00                	push   $0x0
80106955:	68 e9 00 00 00       	push   $0xe9
8010695a:	e9 bb f1 ff ff       	jmp    80105b1a <alltraps>

8010695f <vector234>:
8010695f:	6a 00                	push   $0x0
80106961:	68 ea 00 00 00       	push   $0xea
80106966:	e9 af f1 ff ff       	jmp    80105b1a <alltraps>

8010696b <vector235>:
8010696b:	6a 00                	push   $0x0
8010696d:	68 eb 00 00 00       	push   $0xeb
80106972:	e9 a3 f1 ff ff       	jmp    80105b1a <alltraps>

80106977 <vector236>:
80106977:	6a 00                	push   $0x0
80106979:	68 ec 00 00 00       	push   $0xec
8010697e:	e9 97 f1 ff ff       	jmp    80105b1a <alltraps>

80106983 <vector237>:
80106983:	6a 00                	push   $0x0
80106985:	68 ed 00 00 00       	push   $0xed
8010698a:	e9 8b f1 ff ff       	jmp    80105b1a <alltraps>

8010698f <vector238>:
8010698f:	6a 00                	push   $0x0
80106991:	68 ee 00 00 00       	push   $0xee
80106996:	e9 7f f1 ff ff       	jmp    80105b1a <alltraps>

8010699b <vector239>:
8010699b:	6a 00                	push   $0x0
8010699d:	68 ef 00 00 00       	push   $0xef
801069a2:	e9 73 f1 ff ff       	jmp    80105b1a <alltraps>

801069a7 <vector240>:
801069a7:	6a 00                	push   $0x0
801069a9:	68 f0 00 00 00       	push   $0xf0
801069ae:	e9 67 f1 ff ff       	jmp    80105b1a <alltraps>

801069b3 <vector241>:
801069b3:	6a 00                	push   $0x0
801069b5:	68 f1 00 00 00       	push   $0xf1
801069ba:	e9 5b f1 ff ff       	jmp    80105b1a <alltraps>

801069bf <vector242>:
801069bf:	6a 00                	push   $0x0
801069c1:	68 f2 00 00 00       	push   $0xf2
801069c6:	e9 4f f1 ff ff       	jmp    80105b1a <alltraps>

801069cb <vector243>:
801069cb:	6a 00                	push   $0x0
801069cd:	68 f3 00 00 00       	push   $0xf3
801069d2:	e9 43 f1 ff ff       	jmp    80105b1a <alltraps>

801069d7 <vector244>:
801069d7:	6a 00                	push   $0x0
801069d9:	68 f4 00 00 00       	push   $0xf4
801069de:	e9 37 f1 ff ff       	jmp    80105b1a <alltraps>

801069e3 <vector245>:
801069e3:	6a 00                	push   $0x0
801069e5:	68 f5 00 00 00       	push   $0xf5
801069ea:	e9 2b f1 ff ff       	jmp    80105b1a <alltraps>

801069ef <vector246>:
801069ef:	6a 00                	push   $0x0
801069f1:	68 f6 00 00 00       	push   $0xf6
801069f6:	e9 1f f1 ff ff       	jmp    80105b1a <alltraps>

801069fb <vector247>:
801069fb:	6a 00                	push   $0x0
801069fd:	68 f7 00 00 00       	push   $0xf7
80106a02:	e9 13 f1 ff ff       	jmp    80105b1a <alltraps>

80106a07 <vector248>:
80106a07:	6a 00                	push   $0x0
80106a09:	68 f8 00 00 00       	push   $0xf8
80106a0e:	e9 07 f1 ff ff       	jmp    80105b1a <alltraps>

80106a13 <vector249>:
80106a13:	6a 00                	push   $0x0
80106a15:	68 f9 00 00 00       	push   $0xf9
80106a1a:	e9 fb f0 ff ff       	jmp    80105b1a <alltraps>

80106a1f <vector250>:
80106a1f:	6a 00                	push   $0x0
80106a21:	68 fa 00 00 00       	push   $0xfa
80106a26:	e9 ef f0 ff ff       	jmp    80105b1a <alltraps>

80106a2b <vector251>:
80106a2b:	6a 00                	push   $0x0
80106a2d:	68 fb 00 00 00       	push   $0xfb
80106a32:	e9 e3 f0 ff ff       	jmp    80105b1a <alltraps>

80106a37 <vector252>:
80106a37:	6a 00                	push   $0x0
80106a39:	68 fc 00 00 00       	push   $0xfc
80106a3e:	e9 d7 f0 ff ff       	jmp    80105b1a <alltraps>

80106a43 <vector253>:
80106a43:	6a 00                	push   $0x0
80106a45:	68 fd 00 00 00       	push   $0xfd
80106a4a:	e9 cb f0 ff ff       	jmp    80105b1a <alltraps>

80106a4f <vector254>:
80106a4f:	6a 00                	push   $0x0
80106a51:	68 fe 00 00 00       	push   $0xfe
80106a56:	e9 bf f0 ff ff       	jmp    80105b1a <alltraps>

80106a5b <vector255>:
80106a5b:	6a 00                	push   $0x0
80106a5d:	68 ff 00 00 00       	push   $0xff
80106a62:	e9 b3 f0 ff ff       	jmp    80105b1a <alltraps>
80106a67:	66 90                	xchg   %ax,%ax
80106a69:	66 90                	xchg   %ax,%ax
80106a6b:	66 90                	xchg   %ax,%ax
80106a6d:	66 90                	xchg   %ax,%ax
80106a6f:	90                   	nop

80106a70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a76:	89 d3                	mov    %edx,%ebx
{
80106a78:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106a7a:	c1 eb 16             	shr    $0x16,%ebx
80106a7d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106a80:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106a83:	8b 06                	mov    (%esi),%eax
80106a85:	a8 01                	test   $0x1,%al
80106a87:	74 27                	je     80106ab0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a8e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a94:	c1 ef 0a             	shr    $0xa,%edi
}
80106a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a9a:	89 fa                	mov    %edi,%edx
80106a9c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106aa2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106aa5:	5b                   	pop    %ebx
80106aa6:	5e                   	pop    %esi
80106aa7:	5f                   	pop    %edi
80106aa8:	5d                   	pop    %ebp
80106aa9:	c3                   	ret    
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ab0:	85 c9                	test   %ecx,%ecx
80106ab2:	74 2c                	je     80106ae0 <walkpgdir+0x70>
80106ab4:	e8 27 ba ff ff       	call   801024e0 <kalloc>
80106ab9:	85 c0                	test   %eax,%eax
80106abb:	89 c3                	mov    %eax,%ebx
80106abd:	74 21                	je     80106ae0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106abf:	83 ec 04             	sub    $0x4,%esp
80106ac2:	68 00 10 00 00       	push   $0x1000
80106ac7:	6a 00                	push   $0x0
80106ac9:	50                   	push   %eax
80106aca:	e8 41 de ff ff       	call   80104910 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106acf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ad5:	83 c4 10             	add    $0x10,%esp
80106ad8:	83 c8 07             	or     $0x7,%eax
80106adb:	89 06                	mov    %eax,(%esi)
80106add:	eb b5                	jmp    80106a94 <walkpgdir+0x24>
80106adf:	90                   	nop
}
80106ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ae3:	31 c0                	xor    %eax,%eax
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106af0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106af6:	89 d3                	mov    %edx,%ebx
80106af8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106afe:	83 ec 1c             	sub    $0x1c,%esp
80106b01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b16:	29 df                	sub    %ebx,%edi
80106b18:	83 c8 01             	or     $0x1,%eax
80106b1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b1e:	eb 15                	jmp    80106b35 <mappages+0x45>
    if(*pte & PTE_P)
80106b20:	f6 00 01             	testb  $0x1,(%eax)
80106b23:	75 45                	jne    80106b6a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b25:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b28:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b2d:	74 31                	je     80106b60 <mappages+0x70>
      break;
    a += PGSIZE;
80106b2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b38:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b3d:	89 da                	mov    %ebx,%edx
80106b3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b42:	e8 29 ff ff ff       	call   80106a70 <walkpgdir>
80106b47:	85 c0                	test   %eax,%eax
80106b49:	75 d5                	jne    80106b20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b53:	5b                   	pop    %ebx
80106b54:	5e                   	pop    %esi
80106b55:	5f                   	pop    %edi
80106b56:	5d                   	pop    %ebp
80106b57:	c3                   	ret    
80106b58:	90                   	nop
80106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b63:	31 c0                	xor    %eax,%eax
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
80106b69:	c3                   	ret    
      panic("remap");
80106b6a:	83 ec 0c             	sub    $0xc,%esp
80106b6d:	68 68 7d 10 80       	push   $0x80107d68
80106b72:	e8 19 98 ff ff       	call   80100390 <panic>
80106b77:	89 f6                	mov    %esi,%esi
80106b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b8c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106b8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b94:	83 ec 1c             	sub    $0x1c,%esp
80106b97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b9a:	39 d3                	cmp    %edx,%ebx
80106b9c:	73 66                	jae    80106c04 <deallocuvm.part.0+0x84>
80106b9e:	89 d6                	mov    %edx,%esi
80106ba0:	eb 3d                	jmp    80106bdf <deallocuvm.part.0+0x5f>
80106ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ba8:	8b 10                	mov    (%eax),%edx
80106baa:	f6 c2 01             	test   $0x1,%dl
80106bad:	74 26                	je     80106bd5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106baf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106bb5:	74 58                	je     80106c0f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106bb7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106bc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106bc3:	52                   	push   %edx
80106bc4:	e8 67 b7 ff ff       	call   80102330 <kfree>
      *pte = 0;
80106bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bcc:	83 c4 10             	add    $0x10,%esp
80106bcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106bd5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bdb:	39 f3                	cmp    %esi,%ebx
80106bdd:	73 25                	jae    80106c04 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106bdf:	31 c9                	xor    %ecx,%ecx
80106be1:	89 da                	mov    %ebx,%edx
80106be3:	89 f8                	mov    %edi,%eax
80106be5:	e8 86 fe ff ff       	call   80106a70 <walkpgdir>
    if(!pte)
80106bea:	85 c0                	test   %eax,%eax
80106bec:	75 ba                	jne    80106ba8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106bee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106bf4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106bfa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c00:	39 f3                	cmp    %esi,%ebx
80106c02:	72 db                	jb     80106bdf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106c04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c0a:	5b                   	pop    %ebx
80106c0b:	5e                   	pop    %esi
80106c0c:	5f                   	pop    %edi
80106c0d:	5d                   	pop    %ebp
80106c0e:	c3                   	ret    
        panic("kfree");
80106c0f:	83 ec 0c             	sub    $0xc,%esp
80106c12:	68 26 76 10 80       	push   $0x80107626
80106c17:	e8 74 97 ff ff       	call   80100390 <panic>
80106c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c20 <seginit>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c26:	e8 25 cc ff ff       	call   80103850 <cpuid>
80106c2b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
80106c31:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c3a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106c41:	ff 00 00 
80106c44:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106c4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c4e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106c55:	ff 00 00 
80106c58:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106c5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c62:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106c69:	ff 00 00 
80106c6c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106c73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c76:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106c7d:	ff 00 00 
80106c80:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106c87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c8a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106c8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c93:	c1 e8 10             	shr    $0x10,%eax
80106c96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c9d:	0f 01 10             	lgdtl  (%eax)
}
80106ca0:	c9                   	leave  
80106ca1:	c3                   	ret    
80106ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cb0:	a1 c4 34 12 80       	mov    0x801234c4,%eax
{
80106cb5:	55                   	push   %ebp
80106cb6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cb8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cbd:	0f 22 d8             	mov    %eax,%cr3
}
80106cc0:	5d                   	pop    %ebp
80106cc1:	c3                   	ret    
80106cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <switchuvm>:
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	83 ec 1c             	sub    $0x1c,%esp
80106cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106cdc:	85 db                	test   %ebx,%ebx
80106cde:	0f 84 d7 00 00 00    	je     80106dbb <switchuvm+0xeb>
  if(p->mainThread->tkstack == 0)
80106ce4:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80106cea:	8b 40 04             	mov    0x4(%eax),%eax
80106ced:	85 c0                	test   %eax,%eax
80106cef:	0f 84 e0 00 00 00    	je     80106dd5 <switchuvm+0x105>
  if(p->pgdir == 0)
80106cf5:	8b 43 04             	mov    0x4(%ebx),%eax
80106cf8:	85 c0                	test   %eax,%eax
80106cfa:	0f 84 c8 00 00 00    	je     80106dc8 <switchuvm+0xf8>
  pushcli();
80106d00:	e8 1b da ff ff       	call   80104720 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d05:	e8 c6 ca ff ff       	call   801037d0 <mycpu>
80106d0a:	89 c6                	mov    %eax,%esi
80106d0c:	e8 bf ca ff ff       	call   801037d0 <mycpu>
80106d11:	89 c7                	mov    %eax,%edi
80106d13:	e8 b8 ca ff ff       	call   801037d0 <mycpu>
80106d18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d1b:	83 c7 08             	add    $0x8,%edi
80106d1e:	e8 ad ca ff ff       	call   801037d0 <mycpu>
80106d23:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d26:	83 c0 08             	add    $0x8,%eax
80106d29:	ba 67 00 00 00       	mov    $0x67,%edx
80106d2e:	c1 e8 18             	shr    $0x18,%eax
80106d31:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d38:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d3f:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d45:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d4a:	83 c1 08             	add    $0x8,%ecx
80106d4d:	c1 e9 10             	shr    $0x10,%ecx
80106d50:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106d56:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d5b:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d62:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106d67:	e8 64 ca ff ff       	call   801037d0 <mycpu>
80106d6c:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d73:	e8 58 ca ff ff       	call   801037d0 <mycpu>
80106d78:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
80106d7c:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80106d82:	8b 70 04             	mov    0x4(%eax),%esi
80106d85:	e8 46 ca ff ff       	call   801037d0 <mycpu>
80106d8a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d90:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d93:	e8 38 ca ff ff       	call   801037d0 <mycpu>
80106d98:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d9c:	b8 28 00 00 00       	mov    $0x28,%eax
80106da1:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106da4:	8b 43 04             	mov    0x4(%ebx),%eax
80106da7:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dac:	0f 22 d8             	mov    %eax,%cr3
}
80106daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db2:	5b                   	pop    %ebx
80106db3:	5e                   	pop    %esi
80106db4:	5f                   	pop    %edi
80106db5:	5d                   	pop    %ebp
  popcli();
80106db6:	e9 a5 d9 ff ff       	jmp    80104760 <popcli>
    panic("switchuvm: no process");
80106dbb:	83 ec 0c             	sub    $0xc,%esp
80106dbe:	68 6e 7d 10 80       	push   $0x80107d6e
80106dc3:	e8 c8 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106dc8:	83 ec 0c             	sub    $0xc,%esp
80106dcb:	68 99 7d 10 80       	push   $0x80107d99
80106dd0:	e8 bb 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106dd5:	83 ec 0c             	sub    $0xc,%esp
80106dd8:	68 84 7d 10 80       	push   $0x80107d84
80106ddd:	e8 ae 95 ff ff       	call   80100390 <panic>
80106de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <inituvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
80106df9:	8b 75 10             	mov    0x10(%ebp),%esi
80106dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80106dff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e02:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e0b:	77 49                	ja     80106e56 <inituvm+0x66>
  mem = kalloc();
80106e0d:	e8 ce b6 ff ff       	call   801024e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106e12:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106e15:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e17:	68 00 10 00 00       	push   $0x1000
80106e1c:	6a 00                	push   $0x0
80106e1e:	50                   	push   %eax
80106e1f:	e8 ec da ff ff       	call   80104910 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e24:	58                   	pop    %eax
80106e25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e2b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e30:	5a                   	pop    %edx
80106e31:	6a 06                	push   $0x6
80106e33:	50                   	push   %eax
80106e34:	31 d2                	xor    %edx,%edx
80106e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e39:	e8 b2 fc ff ff       	call   80106af0 <mappages>
  memmove(mem, init, sz);
80106e3e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e41:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e44:	83 c4 10             	add    $0x10,%esp
80106e47:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e4d:	5b                   	pop    %ebx
80106e4e:	5e                   	pop    %esi
80106e4f:	5f                   	pop    %edi
80106e50:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e51:	e9 6a db ff ff       	jmp    801049c0 <memmove>
    panic("inituvm: more than a page");
80106e56:	83 ec 0c             	sub    $0xc,%esp
80106e59:	68 ad 7d 10 80       	push   $0x80107dad
80106e5e:	e8 2d 95 ff ff       	call   80100390 <panic>
80106e63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e70 <loaduvm>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
80106e76:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106e79:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106e80:	0f 85 91 00 00 00    	jne    80106f17 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106e86:	8b 75 18             	mov    0x18(%ebp),%esi
80106e89:	31 db                	xor    %ebx,%ebx
80106e8b:	85 f6                	test   %esi,%esi
80106e8d:	75 1a                	jne    80106ea9 <loaduvm+0x39>
80106e8f:	eb 6f                	jmp    80106f00 <loaduvm+0x90>
80106e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e9e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ea4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ea7:	76 57                	jbe    80106f00 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eac:	8b 45 08             	mov    0x8(%ebp),%eax
80106eaf:	31 c9                	xor    %ecx,%ecx
80106eb1:	01 da                	add    %ebx,%edx
80106eb3:	e8 b8 fb ff ff       	call   80106a70 <walkpgdir>
80106eb8:	85 c0                	test   %eax,%eax
80106eba:	74 4e                	je     80106f0a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ebc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ebe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ec1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106ec6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106ecb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ed1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ed4:	01 d9                	add    %ebx,%ecx
80106ed6:	05 00 00 00 80       	add    $0x80000000,%eax
80106edb:	57                   	push   %edi
80106edc:	51                   	push   %ecx
80106edd:	50                   	push   %eax
80106ede:	ff 75 10             	pushl  0x10(%ebp)
80106ee1:	e8 9a aa ff ff       	call   80101980 <readi>
80106ee6:	83 c4 10             	add    $0x10,%esp
80106ee9:	39 f8                	cmp    %edi,%eax
80106eeb:	74 ab                	je     80106e98 <loaduvm+0x28>
}
80106eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret    
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f03:	31 c0                	xor    %eax,%eax
}
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f0a:	83 ec 0c             	sub    $0xc,%esp
80106f0d:	68 c7 7d 10 80       	push   $0x80107dc7
80106f12:	e8 79 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f17:	83 ec 0c             	sub    $0xc,%esp
80106f1a:	68 68 7e 10 80       	push   $0x80107e68
80106f1f:	e8 6c 94 ff ff       	call   80100390 <panic>
80106f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f30 <allocuvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
80106f36:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f39:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f3c:	85 ff                	test   %edi,%edi
80106f3e:	0f 88 8e 00 00 00    	js     80106fd2 <allocuvm+0xa2>
  if(newsz < oldsz)
80106f44:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f47:	0f 82 93 00 00 00    	jb     80106fe0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f50:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f56:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f5c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f5f:	0f 86 7e 00 00 00    	jbe    80106fe3 <allocuvm+0xb3>
80106f65:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f6b:	eb 42                	jmp    80106faf <allocuvm+0x7f>
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106f70:	83 ec 04             	sub    $0x4,%esp
80106f73:	68 00 10 00 00       	push   $0x1000
80106f78:	6a 00                	push   $0x0
80106f7a:	50                   	push   %eax
80106f7b:	e8 90 d9 ff ff       	call   80104910 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f80:	58                   	pop    %eax
80106f81:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f87:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f8c:	5a                   	pop    %edx
80106f8d:	6a 06                	push   $0x6
80106f8f:	50                   	push   %eax
80106f90:	89 da                	mov    %ebx,%edx
80106f92:	89 f8                	mov    %edi,%eax
80106f94:	e8 57 fb ff ff       	call   80106af0 <mappages>
80106f99:	83 c4 10             	add    $0x10,%esp
80106f9c:	85 c0                	test   %eax,%eax
80106f9e:	78 50                	js     80106ff0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106fa0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fa6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106fa9:	0f 86 81 00 00 00    	jbe    80107030 <allocuvm+0x100>
    mem = kalloc();
80106faf:	e8 2c b5 ff ff       	call   801024e0 <kalloc>
    if(mem == 0){
80106fb4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106fb6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106fb8:	75 b6                	jne    80106f70 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106fba:	83 ec 0c             	sub    $0xc,%esp
80106fbd:	68 e5 7d 10 80       	push   $0x80107de5
80106fc2:	e8 99 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106fc7:	83 c4 10             	add    $0x10,%esp
80106fca:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fcd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fd0:	77 6e                	ja     80107040 <allocuvm+0x110>
}
80106fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106fd5:	31 ff                	xor    %edi,%edi
}
80106fd7:	89 f8                	mov    %edi,%eax
80106fd9:	5b                   	pop    %ebx
80106fda:	5e                   	pop    %esi
80106fdb:	5f                   	pop    %edi
80106fdc:	5d                   	pop    %ebp
80106fdd:	c3                   	ret    
80106fde:	66 90                	xchg   %ax,%ax
    return oldsz;
80106fe0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe6:	89 f8                	mov    %edi,%eax
80106fe8:	5b                   	pop    %ebx
80106fe9:	5e                   	pop    %esi
80106fea:	5f                   	pop    %edi
80106feb:	5d                   	pop    %ebp
80106fec:	c3                   	ret    
80106fed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ff0:	83 ec 0c             	sub    $0xc,%esp
80106ff3:	68 fd 7d 10 80       	push   $0x80107dfd
80106ff8:	e8 63 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106ffd:	83 c4 10             	add    $0x10,%esp
80107000:	8b 45 0c             	mov    0xc(%ebp),%eax
80107003:	39 45 10             	cmp    %eax,0x10(%ebp)
80107006:	76 0d                	jbe    80107015 <allocuvm+0xe5>
80107008:	89 c1                	mov    %eax,%ecx
8010700a:	8b 55 10             	mov    0x10(%ebp),%edx
8010700d:	8b 45 08             	mov    0x8(%ebp),%eax
80107010:	e8 6b fb ff ff       	call   80106b80 <deallocuvm.part.0>
      kfree(mem);
80107015:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107018:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010701a:	56                   	push   %esi
8010701b:	e8 10 b3 ff ff       	call   80102330 <kfree>
      return 0;
80107020:	83 c4 10             	add    $0x10,%esp
}
80107023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107026:	89 f8                	mov    %edi,%eax
80107028:	5b                   	pop    %ebx
80107029:	5e                   	pop    %esi
8010702a:	5f                   	pop    %edi
8010702b:	5d                   	pop    %ebp
8010702c:	c3                   	ret    
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
80107030:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107033:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107036:	5b                   	pop    %ebx
80107037:	89 f8                	mov    %edi,%eax
80107039:	5e                   	pop    %esi
8010703a:	5f                   	pop    %edi
8010703b:	5d                   	pop    %ebp
8010703c:	c3                   	ret    
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
80107040:	89 c1                	mov    %eax,%ecx
80107042:	8b 55 10             	mov    0x10(%ebp),%edx
80107045:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107048:	31 ff                	xor    %edi,%edi
8010704a:	e8 31 fb ff ff       	call   80106b80 <deallocuvm.part.0>
8010704f:	eb 92                	jmp    80106fe3 <allocuvm+0xb3>
80107051:	eb 0d                	jmp    80107060 <deallocuvm>
80107053:	90                   	nop
80107054:	90                   	nop
80107055:	90                   	nop
80107056:	90                   	nop
80107057:	90                   	nop
80107058:	90                   	nop
80107059:	90                   	nop
8010705a:	90                   	nop
8010705b:	90                   	nop
8010705c:	90                   	nop
8010705d:	90                   	nop
8010705e:	90                   	nop
8010705f:	90                   	nop

80107060 <deallocuvm>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	8b 55 0c             	mov    0xc(%ebp),%edx
80107066:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107069:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010706c:	39 d1                	cmp    %edx,%ecx
8010706e:	73 10                	jae    80107080 <deallocuvm+0x20>
}
80107070:	5d                   	pop    %ebp
80107071:	e9 0a fb ff ff       	jmp    80106b80 <deallocuvm.part.0>
80107076:	8d 76 00             	lea    0x0(%esi),%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107080:	89 d0                	mov    %edx,%eax
80107082:	5d                   	pop    %ebp
80107083:	c3                   	ret    
80107084:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010708a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107090 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
80107096:	83 ec 0c             	sub    $0xc,%esp
80107099:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010709c:	85 f6                	test   %esi,%esi
8010709e:	74 59                	je     801070f9 <freevm+0x69>
801070a0:	31 c9                	xor    %ecx,%ecx
801070a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070a7:	89 f0                	mov    %esi,%eax
801070a9:	e8 d2 fa ff ff       	call   80106b80 <deallocuvm.part.0>
801070ae:	89 f3                	mov    %esi,%ebx
801070b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070b6:	eb 0f                	jmp    801070c7 <freevm+0x37>
801070b8:	90                   	nop
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070c3:	39 fb                	cmp    %edi,%ebx
801070c5:	74 23                	je     801070ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070c7:	8b 03                	mov    (%ebx),%eax
801070c9:	a8 01                	test   $0x1,%al
801070cb:	74 f3                	je     801070c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801070d2:	83 ec 0c             	sub    $0xc,%esp
801070d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801070dd:	50                   	push   %eax
801070de:	e8 4d b2 ff ff       	call   80102330 <kfree>
801070e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070e6:	39 fb                	cmp    %edi,%ebx
801070e8:	75 dd                	jne    801070c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801070ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801070ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f0:	5b                   	pop    %ebx
801070f1:	5e                   	pop    %esi
801070f2:	5f                   	pop    %edi
801070f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070f4:	e9 37 b2 ff ff       	jmp    80102330 <kfree>
    panic("freevm: no pgdir");
801070f9:	83 ec 0c             	sub    $0xc,%esp
801070fc:	68 19 7e 10 80       	push   $0x80107e19
80107101:	e8 8a 92 ff ff       	call   80100390 <panic>
80107106:	8d 76 00             	lea    0x0(%esi),%esi
80107109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107110 <setupkvm>:
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	56                   	push   %esi
80107114:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107115:	e8 c6 b3 ff ff       	call   801024e0 <kalloc>
8010711a:	85 c0                	test   %eax,%eax
8010711c:	89 c6                	mov    %eax,%esi
8010711e:	74 42                	je     80107162 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107120:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107123:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107128:	68 00 10 00 00       	push   $0x1000
8010712d:	6a 00                	push   $0x0
8010712f:	50                   	push   %eax
80107130:	e8 db d7 ff ff       	call   80104910 <memset>
80107135:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107138:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010713b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010713e:	83 ec 08             	sub    $0x8,%esp
80107141:	8b 13                	mov    (%ebx),%edx
80107143:	ff 73 0c             	pushl  0xc(%ebx)
80107146:	50                   	push   %eax
80107147:	29 c1                	sub    %eax,%ecx
80107149:	89 f0                	mov    %esi,%eax
8010714b:	e8 a0 f9 ff ff       	call   80106af0 <mappages>
80107150:	83 c4 10             	add    $0x10,%esp
80107153:	85 c0                	test   %eax,%eax
80107155:	78 19                	js     80107170 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107157:	83 c3 10             	add    $0x10,%ebx
8010715a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107160:	75 d6                	jne    80107138 <setupkvm+0x28>
}
80107162:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107165:	89 f0                	mov    %esi,%eax
80107167:	5b                   	pop    %ebx
80107168:	5e                   	pop    %esi
80107169:	5d                   	pop    %ebp
8010716a:	c3                   	ret    
8010716b:	90                   	nop
8010716c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107170:	83 ec 0c             	sub    $0xc,%esp
80107173:	56                   	push   %esi
      return 0;
80107174:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107176:	e8 15 ff ff ff       	call   80107090 <freevm>
      return 0;
8010717b:	83 c4 10             	add    $0x10,%esp
}
8010717e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107181:	89 f0                	mov    %esi,%eax
80107183:	5b                   	pop    %ebx
80107184:	5e                   	pop    %esi
80107185:	5d                   	pop    %ebp
80107186:	c3                   	ret    
80107187:	89 f6                	mov    %esi,%esi
80107189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107190 <kvmalloc>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107196:	e8 75 ff ff ff       	call   80107110 <setupkvm>
8010719b:	a3 c4 34 12 80       	mov    %eax,0x801234c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071a0:	05 00 00 00 80       	add    $0x80000000,%eax
801071a5:	0f 22 d8             	mov    %eax,%cr3
}
801071a8:	c9                   	leave  
801071a9:	c3                   	ret    
801071aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071b1:	31 c9                	xor    %ecx,%ecx
{
801071b3:	89 e5                	mov    %esp,%ebp
801071b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071bb:	8b 45 08             	mov    0x8(%ebp),%eax
801071be:	e8 ad f8 ff ff       	call   80106a70 <walkpgdir>
  if(pte == 0)
801071c3:	85 c0                	test   %eax,%eax
801071c5:	74 05                	je     801071cc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801071c7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071ca:	c9                   	leave  
801071cb:	c3                   	ret    
    panic("clearpteu");
801071cc:	83 ec 0c             	sub    $0xc,%esp
801071cf:	68 2a 7e 10 80       	push   $0x80107e2a
801071d4:	e8 b7 91 ff ff       	call   80100390 <panic>
801071d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071e9:	e8 22 ff ff ff       	call   80107110 <setupkvm>
801071ee:	85 c0                	test   %eax,%eax
801071f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071f3:	0f 84 9f 00 00 00    	je     80107298 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071fc:	85 c9                	test   %ecx,%ecx
801071fe:	0f 84 94 00 00 00    	je     80107298 <copyuvm+0xb8>
80107204:	31 ff                	xor    %edi,%edi
80107206:	eb 4a                	jmp    80107252 <copyuvm+0x72>
80107208:	90                   	nop
80107209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107210:	83 ec 04             	sub    $0x4,%esp
80107213:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107219:	68 00 10 00 00       	push   $0x1000
8010721e:	53                   	push   %ebx
8010721f:	50                   	push   %eax
80107220:	e8 9b d7 ff ff       	call   801049c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107225:	58                   	pop    %eax
80107226:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010722c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107231:	5a                   	pop    %edx
80107232:	ff 75 e4             	pushl  -0x1c(%ebp)
80107235:	50                   	push   %eax
80107236:	89 fa                	mov    %edi,%edx
80107238:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010723b:	e8 b0 f8 ff ff       	call   80106af0 <mappages>
80107240:	83 c4 10             	add    $0x10,%esp
80107243:	85 c0                	test   %eax,%eax
80107245:	78 61                	js     801072a8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107247:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010724d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107250:	76 46                	jbe    80107298 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107252:	8b 45 08             	mov    0x8(%ebp),%eax
80107255:	31 c9                	xor    %ecx,%ecx
80107257:	89 fa                	mov    %edi,%edx
80107259:	e8 12 f8 ff ff       	call   80106a70 <walkpgdir>
8010725e:	85 c0                	test   %eax,%eax
80107260:	74 61                	je     801072c3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107262:	8b 00                	mov    (%eax),%eax
80107264:	a8 01                	test   $0x1,%al
80107266:	74 4e                	je     801072b6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107268:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010726a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010726f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107278:	e8 63 b2 ff ff       	call   801024e0 <kalloc>
8010727d:	85 c0                	test   %eax,%eax
8010727f:	89 c6                	mov    %eax,%esi
80107281:	75 8d                	jne    80107210 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107283:	83 ec 0c             	sub    $0xc,%esp
80107286:	ff 75 e0             	pushl  -0x20(%ebp)
80107289:	e8 02 fe ff ff       	call   80107090 <freevm>
  return 0;
8010728e:	83 c4 10             	add    $0x10,%esp
80107291:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107298:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010729b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010729e:	5b                   	pop    %ebx
8010729f:	5e                   	pop    %esi
801072a0:	5f                   	pop    %edi
801072a1:	5d                   	pop    %ebp
801072a2:	c3                   	ret    
801072a3:	90                   	nop
801072a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801072a8:	83 ec 0c             	sub    $0xc,%esp
801072ab:	56                   	push   %esi
801072ac:	e8 7f b0 ff ff       	call   80102330 <kfree>
      goto bad;
801072b1:	83 c4 10             	add    $0x10,%esp
801072b4:	eb cd                	jmp    80107283 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801072b6:	83 ec 0c             	sub    $0xc,%esp
801072b9:	68 4e 7e 10 80       	push   $0x80107e4e
801072be:	e8 cd 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801072c3:	83 ec 0c             	sub    $0xc,%esp
801072c6:	68 34 7e 10 80       	push   $0x80107e34
801072cb:	e8 c0 90 ff ff       	call   80100390 <panic>

801072d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072d0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072d1:	31 c9                	xor    %ecx,%ecx
{
801072d3:	89 e5                	mov    %esp,%ebp
801072d5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072db:	8b 45 08             	mov    0x8(%ebp),%eax
801072de:	e8 8d f7 ff ff       	call   80106a70 <walkpgdir>
  if((*pte & PTE_P) == 0)
801072e3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072e5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801072e6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072ed:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072f0:	05 00 00 00 80       	add    $0x80000000,%eax
801072f5:	83 fa 05             	cmp    $0x5,%edx
801072f8:	ba 00 00 00 00       	mov    $0x0,%edx
801072fd:	0f 45 c2             	cmovne %edx,%eax
}
80107300:	c3                   	ret    
80107301:	eb 0d                	jmp    80107310 <copyout>
80107303:	90                   	nop
80107304:	90                   	nop
80107305:	90                   	nop
80107306:	90                   	nop
80107307:	90                   	nop
80107308:	90                   	nop
80107309:	90                   	nop
8010730a:	90                   	nop
8010730b:	90                   	nop
8010730c:	90                   	nop
8010730d:	90                   	nop
8010730e:	90                   	nop
8010730f:	90                   	nop

80107310 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	57                   	push   %edi
80107314:	56                   	push   %esi
80107315:	53                   	push   %ebx
80107316:	83 ec 1c             	sub    $0x1c,%esp
80107319:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010731c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010731f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107322:	85 db                	test   %ebx,%ebx
80107324:	75 40                	jne    80107366 <copyout+0x56>
80107326:	eb 70                	jmp    80107398 <copyout+0x88>
80107328:	90                   	nop
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107333:	89 f1                	mov    %esi,%ecx
80107335:	29 d1                	sub    %edx,%ecx
80107337:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010733d:	39 d9                	cmp    %ebx,%ecx
8010733f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107342:	29 f2                	sub    %esi,%edx
80107344:	83 ec 04             	sub    $0x4,%esp
80107347:	01 d0                	add    %edx,%eax
80107349:	51                   	push   %ecx
8010734a:	57                   	push   %edi
8010734b:	50                   	push   %eax
8010734c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010734f:	e8 6c d6 ff ff       	call   801049c0 <memmove>
    len -= n;
    buf += n;
80107354:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107357:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010735a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107360:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107362:	29 cb                	sub    %ecx,%ebx
80107364:	74 32                	je     80107398 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107366:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107368:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010736b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010736e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107374:	56                   	push   %esi
80107375:	ff 75 08             	pushl  0x8(%ebp)
80107378:	e8 53 ff ff ff       	call   801072d0 <uva2ka>
    if(pa0 == 0)
8010737d:	83 c4 10             	add    $0x10,%esp
80107380:	85 c0                	test   %eax,%eax
80107382:	75 ac                	jne    80107330 <copyout+0x20>
  }
  return 0;
}
80107384:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010738c:	5b                   	pop    %ebx
8010738d:	5e                   	pop    %esi
8010738e:	5f                   	pop    %edi
8010738f:	5d                   	pop    %ebp
80107390:	c3                   	ret    
80107391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107398:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010739b:	31 c0                	xor    %eax,%eax
}
8010739d:	5b                   	pop    %ebx
8010739e:	5e                   	pop    %esi
8010739f:	5f                   	pop    %edi
801073a0:	5d                   	pop    %ebp
801073a1:	c3                   	ret    
