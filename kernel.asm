
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2e 10 80       	mov    $0x80102ee0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 75 10 80       	push   $0x80107520
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 e5 47 00 00       	call   80104840 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 75 10 80       	push   $0x80107527
80100097:	50                   	push   %eax
80100098:	e8 73 46 00 00       	call   80104710 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 97 48 00 00       	call   80104980 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 d9 48 00 00       	call   80104a40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 45 00 00       	call   80104750 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 1f 00 00       	call   80102160 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 75 10 80       	push   $0x8010752e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 3d 46 00 00       	call   801047f0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 97 1f 00 00       	jmp    80102160 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 75 10 80       	push   $0x8010753f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 fc 45 00 00       	call   801047f0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 45 00 00       	call   801047b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 70 47 00 00       	call   80104980 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 df 47 00 00       	jmp    80104a40 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 75 10 80       	push   $0x80107546
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
80100280:	e8 1b 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 ef 46 00 00       	call   80104980 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002a7:	39 15 c4 ff 10 80    	cmp    %edx,0x8010ffc4
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
801002c0:	68 c0 ff 10 80       	push   $0x8010ffc0
801002c5:	e8 56 3c 00 00       	call   80103f20 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 ff 10 80    	cmp    0x8010ffc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 e0 35 00 00       	call   801038c0 <myproc>
801002e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 4c 47 00 00       	call   80104a40 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 13 00 00       	call   801016c0 <ilock>
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
80100313:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 ff 10 80 	movsbl -0x7fef00c0(%eax),%eax
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
8010034d:	e8 ee 46 00 00       	call   80104a40 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 13 00 00       	call   801016c0 <ilock>
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
80100372:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
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
801003a9:	e8 c2 23 00 00       	call   80102770 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 75 10 80       	push   $0x8010754d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 b1 75 10 80 	movl   $0x801075b1,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 83 44 00 00       	call   80104860 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 75 10 80       	push   $0x80107561
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
8010043a:	e8 e1 5c 00 00       	call   80106120 <uartputc>
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
801004ec:	e8 2f 5c 00 00       	call   80106120 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 23 5c 00 00       	call   80106120 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 17 5c 00 00       	call   80106120 <uartputc>
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
80100524:	e8 27 46 00 00       	call   80104b50 <memmove>
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
80100541:	e8 5a 45 00 00       	call   80104aa0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 75 10 80       	push   $0x80107565
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
801005b1:	0f b6 92 90 75 10 80 	movzbl -0x7fef8a70(%edx),%edx
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
8010060f:	e8 8c 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 60 43 00 00       	call   80104980 <acquire>
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
80100647:	e8 f4 43 00 00       	call   80104a40 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 10 00 00       	call   801016c0 <ilock>

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
8010071f:	e8 1c 43 00 00       	call   80104a40 <release>
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
801007d0:	ba 78 75 10 80       	mov    $0x80107578,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 8b 41 00 00       	call   80104980 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 75 10 80       	push   $0x8010757f
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
80100823:	e8 58 41 00 00       	call   80104980 <acquire>
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
80100851:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100856:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
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
80100888:	e8 b3 41 00 00       	call   80104a40 <release>
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
801008a9:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
80100911:	68 c0 ff 10 80       	push   $0x8010ffc0
80100916:	e8 a5 3b 00 00       	call   801044c0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010093d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100964:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
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
80100997:	e9 94 3c 00 00       	jmp    80104630 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
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
801009c6:	68 88 75 10 80       	push   $0x80107588
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 6b 3e 00 00       	call   80104840 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 12 19 00 00       	call   80102310 <ioapicenable>
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
80100a16:	81 ec 18 01 00 00    	sub    $0x118,%esp
    cprintf("\n\n ---EXEC---- \n\n");
80100a1c:	68 a1 75 10 80       	push   $0x801075a1
80100a21:	e8 3a fc ff ff       	call   80100660 <cprintf>
    uint argc, sz, sp, ustack[3+MAXARG+1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
80100a26:	e8 95 2e 00 00       	call   801038c0 <myproc>
80100a2b:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
    struct  thread *curthread = mythread();
80100a31:	e8 ba 2e 00 00       	call   801038f0 <mythread>
80100a36:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
    //struct  thread *t;
    begin_op();
80100a3c:	e8 9f 21 00 00       	call   80102be0 <begin_op>

    if((ip = namei(path)) == 0){
80100a41:	58                   	pop    %eax
80100a42:	ff 75 08             	pushl  0x8(%ebp)
80100a45:	e8 d6 14 00 00       	call   80101f20 <namei>
80100a4a:	83 c4 10             	add    $0x10,%esp
80100a4d:	85 c0                	test   %eax,%eax
80100a4f:	0f 84 96 01 00 00    	je     80100beb <exec+0x1db>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100a55:	83 ec 0c             	sub    $0xc,%esp
80100a58:	89 c3                	mov    %eax,%ebx
80100a5a:	50                   	push   %eax
80100a5b:	e8 60 0c 00 00       	call   801016c0 <ilock>
    pgdir = 0;

    // Check ELF header
    if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a60:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a66:	6a 34                	push   $0x34
80100a68:	6a 00                	push   $0x0
80100a6a:	50                   	push   %eax
80100a6b:	53                   	push   %ebx
80100a6c:	e8 2f 0f 00 00       	call   801019a0 <readi>
80100a71:	83 c4 20             	add    $0x20,%esp
80100a74:	83 f8 34             	cmp    $0x34,%eax
80100a77:	74 27                	je     80100aa0 <exec+0x90>

bad:
    if(pgdir)
        freevm(pgdir);
    if(ip){
        iunlockput(ip);
80100a79:	83 ec 0c             	sub    $0xc,%esp
80100a7c:	53                   	push   %ebx
80100a7d:	e8 ce 0e 00 00       	call   80101950 <iunlockput>
        end_op();
80100a82:	e8 c9 21 00 00       	call   80102c50 <end_op>
80100a87:	83 c4 10             	add    $0x10,%esp
    }
    return -1;
80100a8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a92:	5b                   	pop    %ebx
80100a93:	5e                   	pop    %esi
80100a94:	5f                   	pop    %edi
80100a95:	5d                   	pop    %ebp
80100a96:	c3                   	ret    
80100a97:	89 f6                	mov    %esi,%esi
80100a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(elf.magic != ELF_MAGIC)
80100aa0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aa7:	45 4c 46 
80100aaa:	75 cd                	jne    80100a79 <exec+0x69>
    if((pgdir = setupkvm()) == 0)
80100aac:	e8 cf 67 00 00       	call   80107280 <setupkvm>
80100ab1:	85 c0                	test   %eax,%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	74 be                	je     80100a79 <exec+0x69>
    sz = 0;
80100abb:	31 ff                	xor    %edi,%edi
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100abd:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ac4:	00 
80100ac5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100acb:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100ad1:	0f 84 a7 02 00 00    	je     80100d7e <exec+0x36e>
80100ad7:	31 f6                	xor    %esi,%esi
80100ad9:	eb 7f                	jmp    80100b5a <exec+0x14a>
80100adb:	90                   	nop
80100adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(ph.type != ELF_PROG_LOAD)
80100ae0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ae7:	75 63                	jne    80100b4c <exec+0x13c>
        if(ph.memsz < ph.filesz)
80100ae9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aef:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100af5:	0f 82 86 00 00 00    	jb     80100b81 <exec+0x171>
80100afb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b01:	72 7e                	jb     80100b81 <exec+0x171>
        if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b03:	83 ec 04             	sub    $0x4,%esp
80100b06:	50                   	push   %eax
80100b07:	57                   	push   %edi
80100b08:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b0e:	e8 8d 65 00 00       	call   801070a0 <allocuvm>
80100b13:	83 c4 10             	add    $0x10,%esp
80100b16:	85 c0                	test   %eax,%eax
80100b18:	89 c7                	mov    %eax,%edi
80100b1a:	74 65                	je     80100b81 <exec+0x171>
        if(ph.vaddr % PGSIZE != 0)
80100b1c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b22:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b27:	75 58                	jne    80100b81 <exec+0x171>
        if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b29:	83 ec 0c             	sub    $0xc,%esp
80100b2c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b32:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b38:	53                   	push   %ebx
80100b39:	50                   	push   %eax
80100b3a:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b40:	e8 9b 64 00 00       	call   80106fe0 <loaduvm>
80100b45:	83 c4 20             	add    $0x20,%esp
80100b48:	85 c0                	test   %eax,%eax
80100b4a:	78 35                	js     80100b81 <exec+0x171>
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b53:	83 c6 01             	add    $0x1,%esi
80100b56:	39 f0                	cmp    %esi,%eax
80100b58:	7e 3d                	jle    80100b97 <exec+0x187>
        if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b5a:	89 f0                	mov    %esi,%eax
80100b5c:	6a 20                	push   $0x20
80100b5e:	c1 e0 05             	shl    $0x5,%eax
80100b61:	03 85 e8 fe ff ff    	add    -0x118(%ebp),%eax
80100b67:	50                   	push   %eax
80100b68:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b6e:	50                   	push   %eax
80100b6f:	53                   	push   %ebx
80100b70:	e8 2b 0e 00 00       	call   801019a0 <readi>
80100b75:	83 c4 10             	add    $0x10,%esp
80100b78:	83 f8 20             	cmp    $0x20,%eax
80100b7b:	0f 84 5f ff ff ff    	je     80100ae0 <exec+0xd0>
        freevm(pgdir);
80100b81:	83 ec 0c             	sub    $0xc,%esp
80100b84:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b8a:	e8 71 66 00 00       	call   80107200 <freevm>
80100b8f:	83 c4 10             	add    $0x10,%esp
80100b92:	e9 e2 fe ff ff       	jmp    80100a79 <exec+0x69>
80100b97:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b9d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100ba3:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
    iunlockput(ip);
80100ba9:	83 ec 0c             	sub    $0xc,%esp
80100bac:	53                   	push   %ebx
80100bad:	e8 9e 0d 00 00       	call   80101950 <iunlockput>
    end_op();
80100bb2:	e8 99 20 00 00       	call   80102c50 <end_op>
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bb7:	83 c4 0c             	add    $0xc,%esp
80100bba:	56                   	push   %esi
80100bbb:	57                   	push   %edi
80100bbc:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bc2:	e8 d9 64 00 00       	call   801070a0 <allocuvm>
80100bc7:	83 c4 10             	add    $0x10,%esp
80100bca:	85 c0                	test   %eax,%eax
80100bcc:	89 c6                	mov    %eax,%esi
80100bce:	75 3a                	jne    80100c0a <exec+0x1fa>
        freevm(pgdir);
80100bd0:	83 ec 0c             	sub    $0xc,%esp
80100bd3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bd9:	e8 22 66 00 00       	call   80107200 <freevm>
80100bde:	83 c4 10             	add    $0x10,%esp
    return -1;
80100be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be6:	e9 a4 fe ff ff       	jmp    80100a8f <exec+0x7f>
        end_op();
80100beb:	e8 60 20 00 00       	call   80102c50 <end_op>
        cprintf("exec: fail\n");
80100bf0:	83 ec 0c             	sub    $0xc,%esp
80100bf3:	68 b3 75 10 80       	push   $0x801075b3
80100bf8:	e8 63 fa ff ff       	call   80100660 <cprintf>
        return -1;
80100bfd:	83 c4 10             	add    $0x10,%esp
80100c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c05:	e9 85 fe ff ff       	jmp    80100a8f <exec+0x7f>
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c0a:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c10:	83 ec 08             	sub    $0x8,%esp
    for(argc = 0; argv[argc]; argc++) {
80100c13:	31 ff                	xor    %edi,%edi
80100c15:	89 f3                	mov    %esi,%ebx
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c17:	50                   	push   %eax
80100c18:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100c1e:	e8 fd 66 00 00       	call   80107320 <clearpteu>
    for(argc = 0; argv[argc]; argc++) {
80100c23:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c26:	83 c4 10             	add    $0x10,%esp
80100c29:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c2f:	8b 00                	mov    (%eax),%eax
80100c31:	85 c0                	test   %eax,%eax
80100c33:	74 70                	je     80100ca5 <exec+0x295>
80100c35:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
80100c3b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c41:	eb 0a                	jmp    80100c4d <exec+0x23d>
80100c43:	90                   	nop
80100c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(argc >= MAXARG)
80100c48:	83 ff 20             	cmp    $0x20,%edi
80100c4b:	74 83                	je     80100bd0 <exec+0x1c0>
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c4d:	83 ec 0c             	sub    $0xc,%esp
80100c50:	50                   	push   %eax
80100c51:	e8 6a 40 00 00       	call   80104cc0 <strlen>
80100c56:	f7 d0                	not    %eax
80100c58:	01 c3                	add    %eax,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c5a:	58                   	pop    %eax
80100c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c5e:	83 e3 fc             	and    $0xfffffffc,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c61:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c64:	e8 57 40 00 00       	call   80104cc0 <strlen>
80100c69:	83 c0 01             	add    $0x1,%eax
80100c6c:	50                   	push   %eax
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c70:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c73:	53                   	push   %ebx
80100c74:	56                   	push   %esi
80100c75:	e8 06 68 00 00       	call   80107480 <copyout>
80100c7a:	83 c4 20             	add    $0x20,%esp
80100c7d:	85 c0                	test   %eax,%eax
80100c7f:	0f 88 4b ff ff ff    	js     80100bd0 <exec+0x1c0>
    for(argc = 0; argv[argc]; argc++) {
80100c85:	8b 45 0c             	mov    0xc(%ebp),%eax
        ustack[3+argc] = sp;
80100c88:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    for(argc = 0; argv[argc]; argc++) {
80100c8f:	83 c7 01             	add    $0x1,%edi
        ustack[3+argc] = sp;
80100c92:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    for(argc = 0; argv[argc]; argc++) {
80100c98:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c9b:	85 c0                	test   %eax,%eax
80100c9d:	75 a9                	jne    80100c48 <exec+0x238>
80100c9f:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cac:	89 d9                	mov    %ebx,%ecx
    ustack[3+argc] = 0;
80100cae:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cb5:	00 00 00 00 
    ustack[0] = 0xffffffff;  // fake return PC
80100cb9:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cc0:	ff ff ff 
    ustack[1] = argc;
80100cc3:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc9:	29 c1                	sub    %eax,%ecx
    sp -= (3+argc+1) * 4;
80100ccb:	83 c0 0c             	add    $0xc,%eax
80100cce:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cd0:	50                   	push   %eax
80100cd1:	52                   	push   %edx
80100cd2:	53                   	push   %ebx
80100cd3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cd9:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cdf:	e8 9c 67 00 00       	call   80107480 <copyout>
80100ce4:	83 c4 10             	add    $0x10,%esp
80100ce7:	85 c0                	test   %eax,%eax
80100ce9:	0f 88 e1 fe ff ff    	js     80100bd0 <exec+0x1c0>
    for(last=s=path; *s; s++)
80100cef:	8b 45 08             	mov    0x8(%ebp),%eax
80100cf2:	0f b6 00             	movzbl (%eax),%eax
80100cf5:	84 c0                	test   %al,%al
80100cf7:	74 17                	je     80100d10 <exec+0x300>
80100cf9:	8b 55 08             	mov    0x8(%ebp),%edx
80100cfc:	89 d1                	mov    %edx,%ecx
80100cfe:	83 c1 01             	add    $0x1,%ecx
80100d01:	3c 2f                	cmp    $0x2f,%al
80100d03:	0f b6 01             	movzbl (%ecx),%eax
80100d06:	0f 44 d1             	cmove  %ecx,%edx
80100d09:	84 c0                	test   %al,%al
80100d0b:	75 f1                	jne    80100cfe <exec+0x2ee>
80100d0d:	89 55 08             	mov    %edx,0x8(%ebp)
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d10:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d16:	50                   	push   %eax
80100d17:	6a 10                	push   $0x10
80100d19:	ff 75 08             	pushl  0x8(%ebp)
80100d1c:	8d 47 60             	lea    0x60(%edi),%eax
80100d1f:	50                   	push   %eax
80100d20:	e8 5b 3f 00 00       	call   80104c80 <safestrcpy>
    oldpgdir = curproc->pgdir;
80100d25:	89 f9                	mov    %edi,%ecx
    curproc->pgdir = pgdir;
80100d27:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
    oldpgdir = curproc->pgdir;
80100d2d:	8b 7f 04             	mov    0x4(%edi),%edi
    curproc->sz = sz;
80100d30:	89 31                	mov    %esi,(%ecx)
    curthread->tf->eip = elf.entry;  // main
80100d32:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
    curproc->pgdir = pgdir;
80100d38:	89 41 04             	mov    %eax,0x4(%ecx)
    curthread->tf->eip = elf.entry;  // main
80100d3b:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d41:	8b 46 10             	mov    0x10(%esi),%eax
80100d44:	89 50 38             	mov    %edx,0x38(%eax)
    curthread->tf->esp = sp;
80100d47:	8b 46 10             	mov    0x10(%esi),%eax
80100d4a:	89 f2                	mov    %esi,%edx
80100d4c:	89 58 44             	mov    %ebx,0x44(%eax)
    cleanProcOneThread(curthread,curproc);
80100d4f:	5b                   	pop    %ebx
80100d50:	5e                   	pop    %esi
80100d51:	51                   	push   %ecx
80100d52:	52                   	push   %edx
80100d53:	89 ce                	mov    %ecx,%esi
80100d55:	89 d3                	mov    %edx,%ebx
80100d57:	e8 c4 32 00 00       	call   80104020 <cleanProcOneThread>
    curproc->mainThread=curthread;
80100d5c:	89 f1                	mov    %esi,%ecx
80100d5e:	89 99 f0 03 00 00    	mov    %ebx,0x3f0(%ecx)
    switchuvm(curproc);
80100d64:	89 34 24             	mov    %esi,(%esp)
80100d67:	e8 d4 60 00 00       	call   80106e40 <switchuvm>
    freevm(oldpgdir);
80100d6c:	89 3c 24             	mov    %edi,(%esp)
80100d6f:	e8 8c 64 00 00       	call   80107200 <freevm>
    return 0;
80100d74:	83 c4 10             	add    $0x10,%esp
80100d77:	31 c0                	xor    %eax,%eax
80100d79:	e9 11 fd ff ff       	jmp    80100a8f <exec+0x7f>
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d7e:	be 00 20 00 00       	mov    $0x2000,%esi
80100d83:	e9 21 fe ff ff       	jmp    80100ba9 <exec+0x199>
80100d88:	66 90                	xchg   %ax,%ax
80100d8a:	66 90                	xchg   %ax,%ax
80100d8c:	66 90                	xchg   %ax,%ax
80100d8e:	66 90                	xchg   %ax,%ax

80100d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d96:	68 bf 75 10 80       	push   $0x801075bf
80100d9b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100da0:	e8 9b 3a 00 00       	call   80104840 <initlock>
}
80100da5:	83 c4 10             	add    $0x10,%esp
80100da8:	c9                   	leave  
80100da9:	c3                   	ret    
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb 14 00 11 80       	mov    $0x80110014,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dbc:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dc1:	e8 ba 3b 00 00       	call   80104980 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100dd9:	73 25                	jae    80100e00 <filealloc+0x50>
    if(f->ref == 0){
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100de2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100de5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dec:	68 e0 ff 10 80       	push   $0x8010ffe0
80100df1:	e8 4a 3c 00 00       	call   80104a40 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100df6:	89 d8                	mov    %ebx,%eax
      return f;
80100df8:	83 c4 10             	add    $0x10,%esp
}
80100dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dfe:	c9                   	leave  
80100dff:	c3                   	ret    
  release(&ftable.lock);
80100e00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e05:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e0a:	e8 31 3c 00 00       	call   80104a40 <release>
}
80100e0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e11:	83 c4 10             	add    $0x10,%esp
}
80100e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e17:	c9                   	leave  
80100e18:	c3                   	ret    
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 10             	sub    $0x10,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e2a:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e2f:	e8 4c 3b 00 00       	call   80104980 <acquire>
  if(f->ref < 1)
80100e34:	8b 43 04             	mov    0x4(%ebx),%eax
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	7e 1a                	jle    80100e58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e47:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e4c:	e8 ef 3b 00 00       	call   80104a40 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 c6 75 10 80       	push   $0x801075c6
80100e60:	e8 2b f5 ff ff       	call   80100390 <panic>
80100e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 28             	sub    $0x28,%esp
80100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e7c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e81:	e8 fa 3a 00 00       	call   80104980 <acquire>
  if(f->ref < 1)
80100e86:	8b 43 04             	mov    0x4(%ebx),%eax
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	85 c0                	test   %eax,%eax
80100e8e:	0f 8e 9b 00 00 00    	jle    80100f2f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e94:	83 e8 01             	sub    $0x1,%eax
80100e97:	85 c0                	test   %eax,%eax
80100e99:	89 43 04             	mov    %eax,0x4(%ebx)
80100e9c:	74 1a                	je     80100eb8 <fileclose+0x48>
    release(&ftable.lock);
80100e9e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea8:	5b                   	pop    %ebx
80100ea9:	5e                   	pop    %esi
80100eaa:	5f                   	pop    %edi
80100eab:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eac:	e9 8f 3b 00 00       	jmp    80104a40 <release>
80100eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100eb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ebc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ebe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ec1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ec4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ecd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ed0:	68 e0 ff 10 80       	push   $0x8010ffe0
  ff = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ed8:	e8 63 3b 00 00       	call   80104a40 <release>
  if(ff.type == FD_PIPE)
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	83 ff 01             	cmp    $0x1,%edi
80100ee3:	74 13                	je     80100ef8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ee5:	83 ff 02             	cmp    $0x2,%edi
80100ee8:	74 26                	je     80100f10 <fileclose+0xa0>
}
80100eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eed:	5b                   	pop    %ebx
80100eee:	5e                   	pop    %esi
80100eef:	5f                   	pop    %edi
80100ef0:	5d                   	pop    %ebp
80100ef1:	c3                   	ret    
80100ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ef8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100efc:	83 ec 08             	sub    $0x8,%esp
80100eff:	53                   	push   %ebx
80100f00:	56                   	push   %esi
80100f01:	e8 8a 24 00 00       	call   80103390 <pipeclose>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb df                	jmp    80100eea <fileclose+0x7a>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f10:	e8 cb 1c 00 00       	call   80102be0 <begin_op>
    iput(ff.ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 75 e0             	pushl  -0x20(%ebp)
80100f1b:	e8 d0 08 00 00       	call   801017f0 <iput>
    end_op();
80100f20:	83 c4 10             	add    $0x10,%esp
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
    end_op();
80100f2a:	e9 21 1d 00 00       	jmp    80102c50 <end_op>
    panic("fileclose");
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	68 ce 75 10 80       	push   $0x801075ce
80100f37:	e8 54 f4 ff ff       	call   80100390 <panic>
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f4a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f4d:	75 31                	jne    80100f80 <filestat+0x40>
    ilock(f->ip);
80100f4f:	83 ec 0c             	sub    $0xc,%esp
80100f52:	ff 73 10             	pushl  0x10(%ebx)
80100f55:	e8 66 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f5a:	58                   	pop    %eax
80100f5b:	5a                   	pop    %edx
80100f5c:	ff 75 0c             	pushl  0xc(%ebp)
80100f5f:	ff 73 10             	pushl  0x10(%ebx)
80100f62:	e8 09 0a 00 00       	call   80101970 <stati>
    iunlock(f->ip);
80100f67:	59                   	pop    %ecx
80100f68:	ff 73 10             	pushl  0x10(%ebx)
80100f6b:	e8 30 08 00 00       	call   801017a0 <iunlock>
    return 0;
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f85:	eb ee                	jmp    80100f75 <filestat+0x35>
80100f87:	89 f6                	mov    %esi,%esi
80100f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f90 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 0c             	sub    $0xc,%esp
80100f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fa2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fa6:	74 60                	je     80101008 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fa8:	8b 03                	mov    (%ebx),%eax
80100faa:	83 f8 01             	cmp    $0x1,%eax
80100fad:	74 41                	je     80100ff0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100faf:	83 f8 02             	cmp    $0x2,%eax
80100fb2:	75 5b                	jne    8010100f <fileread+0x7f>
    ilock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 73 10             	pushl  0x10(%ebx)
80100fba:	e8 01 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fbf:	57                   	push   %edi
80100fc0:	ff 73 14             	pushl  0x14(%ebx)
80100fc3:	56                   	push   %esi
80100fc4:	ff 73 10             	pushl  0x10(%ebx)
80100fc7:	e8 d4 09 00 00       	call   801019a0 <readi>
80100fcc:	83 c4 20             	add    $0x20,%esp
80100fcf:	85 c0                	test   %eax,%eax
80100fd1:	89 c6                	mov    %eax,%esi
80100fd3:	7e 03                	jle    80100fd8 <fileread+0x48>
      f->off += r;
80100fd5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 73 10             	pushl  0x10(%ebx)
80100fde:	e8 bd 07 00 00       	call   801017a0 <iunlock>
    return r;
80100fe3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	89 f0                	mov    %esi,%eax
80100feb:	5b                   	pop    %ebx
80100fec:	5e                   	pop    %esi
80100fed:	5f                   	pop    %edi
80100fee:	5d                   	pop    %ebp
80100fef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ff0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100ff3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	5b                   	pop    %ebx
80100ffa:	5e                   	pop    %esi
80100ffb:	5f                   	pop    %edi
80100ffc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100ffd:	e9 3e 25 00 00       	jmp    80103540 <piperead>
80101002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010100d:	eb d7                	jmp    80100fe6 <fileread+0x56>
  panic("fileread");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 d8 75 10 80       	push   $0x801075d8
80101017:	e8 74 f3 ff ff       	call   80100390 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 1c             	sub    $0x1c,%esp
80101029:	8b 75 08             	mov    0x8(%ebp),%esi
8010102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010102f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101033:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101036:	8b 45 10             	mov    0x10(%ebp),%eax
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010103c:	0f 84 aa 00 00 00    	je     801010ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 06                	mov    (%esi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c3 00 00 00    	je     80101110 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d9 00 00 00    	jne    8010112f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101059:	31 ff                	xor    %edi,%edi
    while(i < n){
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 34                	jg     80101093 <filewrite+0x73>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101068:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101071:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101074:	e8 27 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101079:	e8 d2 1b 00 00       	call   80102c50 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101081:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101084:	39 c3                	cmp    %eax,%ebx
80101086:	0f 85 96 00 00 00    	jne    80101122 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010108c:	01 df                	add    %ebx,%edi
    while(i < n){
8010108e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101091:	7e 6d                	jle    80101100 <filewrite+0xe0>
      int n1 = n - i;
80101093:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101096:	b8 00 06 00 00       	mov    $0x600,%eax
8010109b:	29 fb                	sub    %edi,%ebx
8010109d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010a6:	e8 35 1b 00 00       	call   80102be0 <begin_op>
      ilock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
801010b1:	e8 0a 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b9:	53                   	push   %ebx
801010ba:	ff 76 14             	pushl  0x14(%esi)
801010bd:	01 f8                	add    %edi,%eax
801010bf:	50                   	push   %eax
801010c0:	ff 76 10             	pushl  0x10(%esi)
801010c3:	e8 d8 09 00 00       	call   80101aa0 <writei>
801010c8:	83 c4 20             	add    $0x20,%esp
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 99                	jg     80101068 <filewrite+0x48>
      iunlock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 76 10             	pushl  0x10(%esi)
801010d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010d8:	e8 c3 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010dd:	e8 6e 1b 00 00       	call   80102c50 <end_op>
      if(r < 0)
801010e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	85 c0                	test   %eax,%eax
801010ea:	74 98                	je     80101084 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010f4:	89 f8                	mov    %edi,%eax
801010f6:	5b                   	pop    %ebx
801010f7:	5e                   	pop    %esi
801010f8:	5f                   	pop    %edi
801010f9:	5d                   	pop    %ebp
801010fa:	c3                   	ret    
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101100:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101103:	75 e7                	jne    801010ec <filewrite+0xcc>
}
80101105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101108:	89 f8                	mov    %edi,%eax
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
8010110f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101110:	8b 46 0c             	mov    0xc(%esi),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010111d:	e9 0e 23 00 00       	jmp    80103430 <pipewrite>
        panic("short filewrite");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 e1 75 10 80       	push   $0x801075e1
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 e7 75 10 80       	push   $0x801075e7
80101137:	e8 54 f2 ff ff       	call   80100390 <panic>
8010113c:	66 90                	xchg   %ax,%ax
8010113e:	66 90                	xchg   %ax,%ax

80101140 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101149:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
{
8010114f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101152:	85 c9                	test   %ecx,%ecx
80101154:	0f 84 87 00 00 00    	je     801011e1 <balloc+0xa1>
8010115a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101161:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101164:	83 ec 08             	sub    $0x8,%esp
80101167:	89 f0                	mov    %esi,%eax
80101169:	c1 f8 0c             	sar    $0xc,%eax
8010116c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101172:	50                   	push   %eax
80101173:	ff 75 d8             	pushl  -0x28(%ebp)
80101176:	e8 55 ef ff ff       	call   801000d0 <bread>
8010117b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101183:	83 c4 10             	add    $0x10,%esp
80101186:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101189:	31 c0                	xor    %eax,%eax
8010118b:	eb 2f                	jmp    801011bc <balloc+0x7c>
8010118d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101190:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101192:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101195:	bb 01 00 00 00       	mov    $0x1,%ebx
8010119a:	83 e1 07             	and    $0x7,%ecx
8010119d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010119f:	89 c1                	mov    %eax,%ecx
801011a1:	c1 f9 03             	sar    $0x3,%ecx
801011a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011a9:	85 df                	test   %ebx,%edi
801011ab:	89 fa                	mov    %edi,%edx
801011ad:	74 41                	je     801011f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011af:	83 c0 01             	add    $0x1,%eax
801011b2:	83 c6 01             	add    $0x1,%esi
801011b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011ba:	74 05                	je     801011c1 <balloc+0x81>
801011bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011bf:	77 cf                	ja     80101190 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011c7:	e8 14 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011d3:	83 c4 10             	add    $0x10,%esp
801011d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d9:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
801011df:	77 80                	ja     80101161 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011e1:	83 ec 0c             	sub    $0xc,%esp
801011e4:	68 f1 75 10 80       	push   $0x801075f1
801011e9:	e8 a2 f1 ff ff       	call   80100390 <panic>
801011ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011f6:	09 da                	or     %ebx,%edx
801011f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011fc:	57                   	push   %edi
801011fd:	e8 ae 1b 00 00       	call   80102db0 <log_write>
        brelse(bp);
80101202:	89 3c 24             	mov    %edi,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010120a:	58                   	pop    %eax
8010120b:	5a                   	pop    %edx
8010120c:	56                   	push   %esi
8010120d:	ff 75 d8             	pushl  -0x28(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101217:	8d 40 5c             	lea    0x5c(%eax),%eax
8010121a:	83 c4 0c             	add    $0xc,%esp
8010121d:	68 00 02 00 00       	push   $0x200
80101222:	6a 00                	push   $0x0
80101224:	50                   	push   %eax
80101225:	e8 76 38 00 00       	call   80104aa0 <memset>
  log_write(bp);
8010122a:	89 1c 24             	mov    %ebx,(%esp)
8010122d:	e8 7e 1b 00 00       	call   80102db0 <log_write>
  brelse(bp);
80101232:	89 1c 24             	mov    %ebx,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
}
8010123a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010123d:	89 f0                	mov    %esi,%eax
8010123f:	5b                   	pop    %ebx
80101240:	5e                   	pop    %esi
80101241:	5f                   	pop    %edi
80101242:	5d                   	pop    %ebp
80101243:	c3                   	ret    
80101244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010124a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101250 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101258:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010125f:	83 ec 28             	sub    $0x28,%esp
80101262:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101265:	68 00 0a 11 80       	push   $0x80110a00
8010126a:	e8 11 37 00 00       	call   80104980 <acquire>
8010126f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101275:	eb 17                	jmp    8010128e <iget+0x3e>
80101277:	89 f6                	mov    %esi,%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101280:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101286:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010128c:	73 22                	jae    801012b0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010128e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101291:	85 c9                	test   %ecx,%ecx
80101293:	7e 04                	jle    80101299 <iget+0x49>
80101295:	39 3b                	cmp    %edi,(%ebx)
80101297:	74 4f                	je     801012e8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101299:	85 f6                	test   %esi,%esi
8010129b:	75 e3                	jne    80101280 <iget+0x30>
8010129d:	85 c9                	test   %ecx,%ecx
8010129f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012a8:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801012ae:	72 de                	jb     8010128e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 5b                	je     8010130f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012b4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012b7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012b9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ca:	68 00 0a 11 80       	push   $0x80110a00
801012cf:	e8 6c 37 00 00       	call   80104a40 <release>

  return ip;
801012d4:	83 c4 10             	add    $0x10,%esp
}
801012d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012da:	89 f0                	mov    %esi,%eax
801012dc:	5b                   	pop    %ebx
801012dd:	5e                   	pop    %esi
801012de:	5f                   	pop    %edi
801012df:	5d                   	pop    %ebp
801012e0:	c3                   	ret    
801012e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012eb:	75 ac                	jne    80101299 <iget+0x49>
      release(&icache.lock);
801012ed:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012f0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012f3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012f5:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
801012fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012fd:	e8 3e 37 00 00       	call   80104a40 <release>
      return ip;
80101302:	83 c4 10             	add    $0x10,%esp
}
80101305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101308:	89 f0                	mov    %esi,%eax
8010130a:	5b                   	pop    %ebx
8010130b:	5e                   	pop    %esi
8010130c:	5f                   	pop    %edi
8010130d:	5d                   	pop    %ebp
8010130e:	c3                   	ret    
    panic("iget: no inodes");
8010130f:	83 ec 0c             	sub    $0xc,%esp
80101312:	68 07 76 10 80       	push   $0x80107607
80101317:	e8 74 f0 ff ff       	call   80100390 <panic>
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	56                   	push   %esi
80101325:	53                   	push   %ebx
80101326:	89 c6                	mov    %eax,%esi
80101328:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010132b:	83 fa 0b             	cmp    $0xb,%edx
8010132e:	77 18                	ja     80101348 <bmap+0x28>
80101330:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101333:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101336:	85 db                	test   %ebx,%ebx
80101338:	74 76                	je     801013b0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 d8                	mov    %ebx,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101348:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010134b:	83 fb 7f             	cmp    $0x7f,%ebx
8010134e:	0f 87 90 00 00 00    	ja     801013e4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101354:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010135a:	8b 00                	mov    (%eax),%eax
8010135c:	85 d2                	test   %edx,%edx
8010135e:	74 70                	je     801013d0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101360:	83 ec 08             	sub    $0x8,%esp
80101363:	52                   	push   %edx
80101364:	50                   	push   %eax
80101365:	e8 66 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010136a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010136e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101371:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101373:	8b 1a                	mov    (%edx),%ebx
80101375:	85 db                	test   %ebx,%ebx
80101377:	75 1d                	jne    80101396 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101379:	8b 06                	mov    (%esi),%eax
8010137b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010137e:	e8 bd fd ff ff       	call   80101140 <balloc>
80101383:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101386:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101389:	89 c3                	mov    %eax,%ebx
8010138b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010138d:	57                   	push   %edi
8010138e:	e8 1d 1a 00 00       	call   80102db0 <log_write>
80101393:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101396:	83 ec 0c             	sub    $0xc,%esp
80101399:	57                   	push   %edi
8010139a:	e8 41 ee ff ff       	call   801001e0 <brelse>
8010139f:	83 c4 10             	add    $0x10,%esp
}
801013a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a5:	89 d8                	mov    %ebx,%eax
801013a7:	5b                   	pop    %ebx
801013a8:	5e                   	pop    %esi
801013a9:	5f                   	pop    %edi
801013aa:	5d                   	pop    %ebp
801013ab:	c3                   	ret    
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013b0:	8b 00                	mov    (%eax),%eax
801013b2:	e8 89 fd ff ff       	call   80101140 <balloc>
801013b7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013bd:	89 c3                	mov    %eax,%ebx
}
801013bf:	89 d8                	mov    %ebx,%eax
801013c1:	5b                   	pop    %ebx
801013c2:	5e                   	pop    %esi
801013c3:	5f                   	pop    %edi
801013c4:	5d                   	pop    %ebp
801013c5:	c3                   	ret    
801013c6:	8d 76 00             	lea    0x0(%esi),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013d0:	e8 6b fd ff ff       	call   80101140 <balloc>
801013d5:	89 c2                	mov    %eax,%edx
801013d7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013dd:	8b 06                	mov    (%esi),%eax
801013df:	e9 7c ff ff ff       	jmp    80101360 <bmap+0x40>
  panic("bmap: out of range");
801013e4:	83 ec 0c             	sub    $0xc,%esp
801013e7:	68 17 76 10 80       	push   $0x80107617
801013ec:	e8 9f ef ff ff       	call   80100390 <panic>
801013f1:	eb 0d                	jmp    80101400 <readsb>
801013f3:	90                   	nop
801013f4:	90                   	nop
801013f5:	90                   	nop
801013f6:	90                   	nop
801013f7:	90                   	nop
801013f8:	90                   	nop
801013f9:	90                   	nop
801013fa:	90                   	nop
801013fb:	90                   	nop
801013fc:	90                   	nop
801013fd:	90                   	nop
801013fe:	90                   	nop
801013ff:	90                   	nop

80101400 <readsb>:
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	56                   	push   %esi
80101404:	53                   	push   %ebx
80101405:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101408:	83 ec 08             	sub    $0x8,%esp
8010140b:	6a 01                	push   $0x1
8010140d:	ff 75 08             	pushl  0x8(%ebp)
80101410:	e8 bb ec ff ff       	call   801000d0 <bread>
80101415:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101417:	8d 40 5c             	lea    0x5c(%eax),%eax
8010141a:	83 c4 0c             	add    $0xc,%esp
8010141d:	6a 1c                	push   $0x1c
8010141f:	50                   	push   %eax
80101420:	56                   	push   %esi
80101421:	e8 2a 37 00 00       	call   80104b50 <memmove>
  brelse(bp);
80101426:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101429:	83 c4 10             	add    $0x10,%esp
}
8010142c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010142f:	5b                   	pop    %ebx
80101430:	5e                   	pop    %esi
80101431:	5d                   	pop    %ebp
  brelse(bp);
80101432:	e9 a9 ed ff ff       	jmp    801001e0 <brelse>
80101437:	89 f6                	mov    %esi,%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101440 <bfree>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	89 d3                	mov    %edx,%ebx
80101447:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101449:	83 ec 08             	sub    $0x8,%esp
8010144c:	68 e0 09 11 80       	push   $0x801109e0
80101451:	50                   	push   %eax
80101452:	e8 a9 ff ff ff       	call   80101400 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101457:	58                   	pop    %eax
80101458:	5a                   	pop    %edx
80101459:	89 da                	mov    %ebx,%edx
8010145b:	c1 ea 0c             	shr    $0xc,%edx
8010145e:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101464:	52                   	push   %edx
80101465:	56                   	push   %esi
80101466:	e8 65 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010146b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010146d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101470:	ba 01 00 00 00       	mov    $0x1,%edx
80101475:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101478:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010147e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101481:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101483:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101488:	85 d1                	test   %edx,%ecx
8010148a:	74 25                	je     801014b1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010148c:	f7 d2                	not    %edx
8010148e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101490:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101493:	21 ca                	and    %ecx,%edx
80101495:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101499:	56                   	push   %esi
8010149a:	e8 11 19 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010149f:	89 34 24             	mov    %esi,(%esp)
801014a2:	e8 39 ed ff ff       	call   801001e0 <brelse>
}
801014a7:	83 c4 10             	add    $0x10,%esp
801014aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ad:	5b                   	pop    %ebx
801014ae:	5e                   	pop    %esi
801014af:	5d                   	pop    %ebp
801014b0:	c3                   	ret    
    panic("freeing free block");
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	68 2a 76 10 80       	push   $0x8010762a
801014b9:	e8 d2 ee ff ff       	call   80100390 <panic>
801014be:	66 90                	xchg   %ax,%ax

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
801014c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014cc:	68 3d 76 10 80       	push   $0x8010763d
801014d1:	68 00 0a 11 80       	push   $0x80110a00
801014d6:	e8 65 33 00 00       	call   80104840 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 44 76 10 80       	push   $0x80107644
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 1c 32 00 00       	call   80104710 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014f4:	83 c4 10             	add    $0x10,%esp
801014f7:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014fd:	75 e1                	jne    801014e0 <iinit+0x20>
  readsb(dev, &sb);
801014ff:	83 ec 08             	sub    $0x8,%esp
80101502:	68 e0 09 11 80       	push   $0x801109e0
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 f1 fe ff ff       	call   80101400 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010150f:	ff 35 f8 09 11 80    	pushl  0x801109f8
80101515:	ff 35 f4 09 11 80    	pushl  0x801109f4
8010151b:	ff 35 f0 09 11 80    	pushl  0x801109f0
80101521:	ff 35 ec 09 11 80    	pushl  0x801109ec
80101527:	ff 35 e8 09 11 80    	pushl  0x801109e8
8010152d:	ff 35 e4 09 11 80    	pushl  0x801109e4
80101533:	ff 35 e0 09 11 80    	pushl  0x801109e0
80101539:	68 a8 76 10 80       	push   $0x801076a8
8010153e:	e8 1d f1 ff ff       	call   80100660 <cprintf>
}
80101543:	83 c4 30             	add    $0x30,%esp
80101546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101549:	c9                   	leave  
8010154a:	c3                   	ret    
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <ialloc>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
{
80101560:	8b 45 0c             	mov    0xc(%ebp),%eax
80101563:	8b 75 08             	mov    0x8(%ebp),%esi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 91 00 00 00    	jbe    80101600 <ialloc+0xb0>
8010156f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101574:	eb 21                	jmp    80101597 <ialloc+0x47>
80101576:	8d 76 00             	lea    0x0(%esi),%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101580:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101586:	57                   	push   %edi
80101587:	e8 54 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101595:	76 69                	jbe    80101600 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101597:	89 d8                	mov    %ebx,%eax
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	c1 e8 03             	shr    $0x3,%eax
8010159f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015a5:	50                   	push   %eax
801015a6:	56                   	push   %esi
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015b0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015b3:	83 e0 07             	and    $0x7,%eax
801015b6:	c1 e0 06             	shl    $0x6,%eax
801015b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015c1:	75 bd                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c3:	83 ec 04             	sub    $0x4,%esp
801015c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015c9:	6a 40                	push   $0x40
801015cb:	6a 00                	push   $0x0
801015cd:	51                   	push   %ecx
801015ce:	e8 cd 34 00 00       	call   80104aa0 <memset>
      dip->type = type;
801015d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015dd:	89 3c 24             	mov    %edi,(%esp)
801015e0:	e8 cb 17 00 00       	call   80102db0 <log_write>
      brelse(bp);
801015e5:	89 3c 24             	mov    %edi,(%esp)
801015e8:	e8 f3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ed:	83 c4 10             	add    $0x10,%esp
}
801015f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015f3:	89 da                	mov    %ebx,%edx
801015f5:	89 f0                	mov    %esi,%eax
}
801015f7:	5b                   	pop    %ebx
801015f8:	5e                   	pop    %esi
801015f9:	5f                   	pop    %edi
801015fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801015fb:	e9 50 fc ff ff       	jmp    80101250 <iget>
  panic("ialloc: no inodes");
80101600:	83 ec 0c             	sub    $0xc,%esp
80101603:	68 4a 76 10 80       	push   $0x8010764a
80101608:	e8 83 ed ff ff       	call   80100390 <panic>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <iupdate>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101621:	c1 e8 03             	shr    $0x3,%eax
80101624:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010162a:	50                   	push   %eax
8010162b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010162e:	e8 9d ea ff ff       	call   801000d0 <bread>
80101633:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101635:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101638:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010163f:	83 e0 07             	and    $0x7,%eax
80101642:	c1 e0 06             	shl    $0x6,%eax
80101645:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101649:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010164c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101650:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101653:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101657:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010165b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010165f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101663:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101667:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010166a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166d:	6a 34                	push   $0x34
8010166f:	53                   	push   %ebx
80101670:	50                   	push   %eax
80101671:	e8 da 34 00 00       	call   80104b50 <memmove>
  log_write(bp);
80101676:	89 34 24             	mov    %esi,(%esp)
80101679:	e8 32 17 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010167e:	89 75 08             	mov    %esi,0x8(%ebp)
80101681:	83 c4 10             	add    $0x10,%esp
}
80101684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5d                   	pop    %ebp
  brelse(bp);
8010168a:	e9 51 eb ff ff       	jmp    801001e0 <brelse>
8010168f:	90                   	nop

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 10             	sub    $0x10,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	68 00 0a 11 80       	push   $0x80110a00
8010169f:	e8 dc 32 00 00       	call   80104980 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016af:	e8 8c 33 00 00       	call   80104a40 <release>
}
801016b4:	89 d8                	mov    %ebx,%eax
801016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016c8:	85 db                	test   %ebx,%ebx
801016ca:	0f 84 b7 00 00 00    	je     80101787 <ilock+0xc7>
801016d0:	8b 53 08             	mov    0x8(%ebx),%edx
801016d3:	85 d2                	test   %edx,%edx
801016d5:	0f 8e ac 00 00 00    	jle    80101787 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016db:	8d 43 0c             	lea    0xc(%ebx),%eax
801016de:	83 ec 0c             	sub    $0xc,%esp
801016e1:	50                   	push   %eax
801016e2:	e8 69 30 00 00       	call   80104750 <acquiresleep>
  if(ip->valid == 0){
801016e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ea:	83 c4 10             	add    $0x10,%esp
801016ed:	85 c0                	test   %eax,%eax
801016ef:	74 0f                	je     80101700 <ilock+0x40>
}
801016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5d                   	pop    %ebp
801016f7:	c3                   	ret    
801016f8:	90                   	nop
801016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101700:	8b 43 04             	mov    0x4(%ebx),%eax
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	c1 e8 03             	shr    $0x3,%eax
80101709:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010170f:	50                   	push   %eax
80101710:	ff 33                	pushl  (%ebx)
80101712:	e8 b9 e9 ff ff       	call   801000d0 <bread>
80101717:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101719:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101729:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010172c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010172f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101733:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101737:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010173b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010173f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101743:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101747:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010174b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010174e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101751:	6a 34                	push   $0x34
80101753:	50                   	push   %eax
80101754:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101757:	50                   	push   %eax
80101758:	e8 f3 33 00 00       	call   80104b50 <memmove>
    brelse(bp);
8010175d:	89 34 24             	mov    %esi,(%esp)
80101760:	e8 7b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101765:	83 c4 10             	add    $0x10,%esp
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 77 ff ff ff    	jne    801016f1 <ilock+0x31>
      panic("ilock: no type");
8010177a:	83 ec 0c             	sub    $0xc,%esp
8010177d:	68 62 76 10 80       	push   $0x80107662
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 5c 76 10 80       	push   $0x8010765c
8010178f:	e8 fc eb ff ff       	call   80100390 <panic>
80101794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010179a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	74 28                	je     801017d4 <iunlock+0x34>
801017ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	56                   	push   %esi
801017b3:	e8 38 30 00 00       	call   801047f0 <holdingsleep>
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 c0                	test   %eax,%eax
801017bd:	74 15                	je     801017d4 <iunlock+0x34>
801017bf:	8b 43 08             	mov    0x8(%ebx),%eax
801017c2:	85 c0                	test   %eax,%eax
801017c4:	7e 0e                	jle    801017d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017cc:	5b                   	pop    %ebx
801017cd:	5e                   	pop    %esi
801017ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017cf:	e9 dc 2f 00 00       	jmp    801047b0 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 71 76 10 80       	push   $0x80107671
801017dc:	e8 af eb ff ff       	call   80100390 <panic>
801017e1:	eb 0d                	jmp    801017f0 <iput>
801017e3:	90                   	nop
801017e4:	90                   	nop
801017e5:	90                   	nop
801017e6:	90                   	nop
801017e7:	90                   	nop
801017e8:	90                   	nop
801017e9:	90                   	nop
801017ea:	90                   	nop
801017eb:	90                   	nop
801017ec:	90                   	nop
801017ed:	90                   	nop
801017ee:	90                   	nop
801017ef:	90                   	nop

801017f0 <iput>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 28             	sub    $0x28,%esp
801017f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ff:	57                   	push   %edi
80101800:	e8 4b 2f 00 00       	call   80104750 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101805:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 d2                	test   %edx,%edx
8010180d:	74 07                	je     80101816 <iput+0x26>
8010180f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101814:	74 32                	je     80101848 <iput+0x58>
  releasesleep(&ip->lock);
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	57                   	push   %edi
8010181a:	e8 91 2f 00 00       	call   801047b0 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101826:	e8 55 31 00 00       	call   80104980 <acquire>
  ip->ref--;
8010182b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5f                   	pop    %edi
8010183f:	5d                   	pop    %ebp
  release(&icache.lock);
80101840:	e9 fb 31 00 00       	jmp    80104a40 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 00 0a 11 80       	push   $0x80110a00
80101850:	e8 2b 31 00 00       	call   80104980 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010185f:	e8 dc 31 00 00       	call   80104a40 <release>
    if(r == 1){
80101864:	83 c4 10             	add    $0x10,%esp
80101867:	83 fe 01             	cmp    $0x1,%esi
8010186a:	75 aa                	jne    80101816 <iput+0x26>
8010186c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101872:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101875:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x97>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fe                	cmp    %edi,%esi
80101885:	74 19                	je     801018a0 <iput+0xb0>
    if(ip->addrs[i]){
80101887:	8b 16                	mov    (%esi),%edx
80101889:	85 d2                	test   %edx,%edx
8010188b:	74 f3                	je     80101880 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010188d:	8b 03                	mov    (%ebx),%eax
8010188f:	e8 ac fb ff ff       	call   80101440 <bfree>
      ip->addrs[i] = 0;
80101894:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010189a:	eb e4                	jmp    80101880 <iput+0x90>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 33                	jne    801018e0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018ad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018b7:	53                   	push   %ebx
801018b8:	e8 53 fd ff ff       	call   80101610 <iupdate>
      ip->type = 0;
801018bd:	31 c0                	xor    %eax,%eax
801018bf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018c3:	89 1c 24             	mov    %ebx,(%esp)
801018c6:	e8 45 fd ff ff       	call   80101610 <iupdate>
      ip->valid = 0;
801018cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018d2:	83 c4 10             	add    $0x10,%esp
801018d5:	e9 3c ff ff ff       	jmp    80101816 <iput+0x26>
801018da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	ff 33                	pushl  (%ebx)
801018e6:	e8 e5 e7 ff ff       	call   801000d0 <bread>
801018eb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018f1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018f7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	89 cf                	mov    %ecx,%edi
801018ff:	eb 0e                	jmp    8010190f <iput+0x11f>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010190b:	39 fe                	cmp    %edi,%esi
8010190d:	74 0f                	je     8010191e <iput+0x12e>
      if(a[j])
8010190f:	8b 16                	mov    (%esi),%edx
80101911:	85 d2                	test   %edx,%edx
80101913:	74 f3                	je     80101908 <iput+0x118>
        bfree(ip->dev, a[j]);
80101915:	8b 03                	mov    (%ebx),%eax
80101917:	e8 24 fb ff ff       	call   80101440 <bfree>
8010191c:	eb ea                	jmp    80101908 <iput+0x118>
    brelse(bp);
8010191e:	83 ec 0c             	sub    $0xc,%esp
80101921:	ff 75 e4             	pushl  -0x1c(%ebp)
80101924:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101927:	e8 b4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010192c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101932:	8b 03                	mov    (%ebx),%eax
80101934:	e8 07 fb ff ff       	call   80101440 <bfree>
    ip->addrs[NDIRECT] = 0;
80101939:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101940:	00 00 00 
80101943:	83 c4 10             	add    $0x10,%esp
80101946:	e9 62 ff ff ff       	jmp    801018ad <iput+0xbd>
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <iunlockput>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	53                   	push   %ebx
80101954:	83 ec 10             	sub    $0x10,%esp
80101957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010195a:	53                   	push   %ebx
8010195b:	e8 40 fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101960:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101963:	83 c4 10             	add    $0x10,%esp
}
80101966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101969:	c9                   	leave  
  iput(ip);
8010196a:	e9 81 fe ff ff       	jmp    801017f0 <iput>
8010196f:	90                   	nop

80101970 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	8b 55 08             	mov    0x8(%ebp),%edx
80101976:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101979:	8b 0a                	mov    (%edx),%ecx
8010197b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010197e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101981:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101984:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101988:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010198b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010198f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101993:	8b 52 58             	mov    0x58(%edx),%edx
80101996:	89 50 10             	mov    %edx,0x10(%eax)
}
80101999:	5d                   	pop    %ebp
8010199a:	c3                   	ret    
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 1c             	sub    $0x1c,%esp
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801019af:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019b7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019bd:	8b 75 10             	mov    0x10(%ebp),%esi
801019c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019c3:	0f 84 a7 00 00 00    	je     80101a70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019cc:	8b 40 58             	mov    0x58(%eax),%eax
801019cf:	39 c6                	cmp    %eax,%esi
801019d1:	0f 87 ba 00 00 00    	ja     80101a91 <readi+0xf1>
801019d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019da:	89 f9                	mov    %edi,%ecx
801019dc:	01 f1                	add    %esi,%ecx
801019de:	0f 82 ad 00 00 00    	jb     80101a91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019e4:	89 c2                	mov    %eax,%edx
801019e6:	29 f2                	sub    %esi,%edx
801019e8:	39 c8                	cmp    %ecx,%eax
801019ea:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ed:	31 ff                	xor    %edi,%edi
801019ef:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f4:	74 6c                	je     80101a62 <readi+0xc2>
801019f6:	8d 76 00             	lea    0x0(%esi),%esi
801019f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a03:	89 f2                	mov    %esi,%edx
80101a05:	c1 ea 09             	shr    $0x9,%edx
80101a08:	89 d8                	mov    %ebx,%eax
80101a0a:	e8 11 f9 ff ff       	call   80101320 <bmap>
80101a0f:	83 ec 08             	sub    $0x8,%esp
80101a12:	50                   	push   %eax
80101a13:	ff 33                	pushl  (%ebx)
80101a15:	e8 b6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a1d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1f:	89 f0                	mov    %esi,%eax
80101a21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a2b:	83 c4 0c             	add    $0xc,%esp
80101a2e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a37:	29 fb                	sub    %edi,%ebx
80101a39:	39 d9                	cmp    %ebx,%ecx
80101a3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a3e:	53                   	push   %ebx
80101a3f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a40:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a42:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a45:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a47:	e8 04 31 00 00       	call   80104b50 <memmove>
    brelse(bp);
80101a4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a4f:	89 14 24             	mov    %edx,(%esp)
80101a52:	e8 89 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a60:	77 9e                	ja     80101a00 <readi+0x60>
  }
  return n;
80101a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5f                   	pop    %edi
80101a6b:	5d                   	pop    %ebp
80101a6c:	c3                   	ret    
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a74:	66 83 f8 09          	cmp    $0x9,%ax
80101a78:	77 17                	ja     80101a91 <readi+0xf1>
80101a7a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a81:	85 c0                	test   %eax,%eax
80101a83:	74 0c                	je     80101a91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a8b:	5b                   	pop    %ebx
80101a8c:	5e                   	pop    %esi
80101a8d:	5f                   	pop    %edi
80101a8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a8f:	ff e0                	jmp    *%eax
      return -1;
80101a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a96:	eb cd                	jmp    80101a65 <readi+0xc5>
80101a98:	90                   	nop
80101a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101abd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 b7 00 00 00    	je     80101b80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	39 70 58             	cmp    %esi,0x58(%eax)
80101acf:	0f 82 eb 00 00 00    	jb     80101bc0 <writei+0x120>
80101ad5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ad8:	31 d2                	xor    %edx,%edx
80101ada:	89 f8                	mov    %edi,%eax
80101adc:	01 f0                	add    %esi,%eax
80101ade:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ae1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ae6:	0f 87 d4 00 00 00    	ja     80101bc0 <writei+0x120>
80101aec:	85 d2                	test   %edx,%edx
80101aee:	0f 85 cc 00 00 00    	jne    80101bc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af4:	85 ff                	test   %edi,%edi
80101af6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101afd:	74 72                	je     80101b71 <writei+0xd1>
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 f8                	mov    %edi,%eax
80101b0a:	e8 11 f8 ff ff       	call   80101320 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 37                	pushl  (%edi)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b20:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b22:	89 f0                	mov    %esi,%eax
80101b24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b29:	83 c4 0c             	add    $0xc,%esp
80101b2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b37:	39 d9                	cmp    %ebx,%ecx
80101b39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b3c:	53                   	push   %ebx
80101b3d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b40:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b42:	50                   	push   %eax
80101b43:	e8 08 30 00 00       	call   80104b50 <memmove>
    log_write(bp);
80101b48:	89 3c 24             	mov    %edi,(%esp)
80101b4b:	e8 60 12 00 00       	call   80102db0 <log_write>
    brelse(bp);
80101b50:	89 3c 24             	mov    %edi,(%esp)
80101b53:	e8 88 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b5e:	83 c4 10             	add    $0x10,%esp
80101b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b67:	77 97                	ja     80101b00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b6f:	77 37                	ja     80101ba8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b77:	5b                   	pop    %ebx
80101b78:	5e                   	pop    %esi
80101b79:	5f                   	pop    %edi
80101b7a:	5d                   	pop    %ebp
80101b7b:	c3                   	ret    
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 36                	ja     80101bc0 <writei+0x120>
80101b8a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 2b                	je     80101bc0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b9f:	ff e0                	jmp    *%eax
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bb1:	50                   	push   %eax
80101bb2:	e8 59 fa ff ff       	call   80101610 <iupdate>
80101bb7:	83 c4 10             	add    $0x10,%esp
80101bba:	eb b5                	jmp    80101b71 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bc5:	eb ad                	jmp    80101b74 <writei+0xd4>
80101bc7:	89 f6                	mov    %esi,%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bd6:	6a 0e                	push   $0xe
80101bd8:	ff 75 0c             	pushl  0xc(%ebp)
80101bdb:	ff 75 08             	pushl  0x8(%ebp)
80101bde:	e8 dd 2f 00 00       	call   80104bc0 <strncmp>
}
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    
80101be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 85 00 00 00    	jne    80101c8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	74 3e                	je     80101c51 <dirlookup+0x61>
80101c13:	90                   	nop
80101c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c18:	6a 10                	push   $0x10
80101c1a:	57                   	push   %edi
80101c1b:	56                   	push   %esi
80101c1c:	53                   	push   %ebx
80101c1d:	e8 7e fd ff ff       	call   801019a0 <readi>
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	83 f8 10             	cmp    $0x10,%eax
80101c28:	75 55                	jne    80101c7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c2f:	74 18                	je     80101c49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c34:	83 ec 04             	sub    $0x4,%esp
80101c37:	6a 0e                	push   $0xe
80101c39:	50                   	push   %eax
80101c3a:	ff 75 0c             	pushl  0xc(%ebp)
80101c3d:	e8 7e 2f 00 00       	call   80104bc0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 17                	je     80101c60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c49:	83 c7 10             	add    $0x10,%edi
80101c4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c4f:	72 c7                	jb     80101c18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c54:	31 c0                	xor    %eax,%eax
}
80101c56:	5b                   	pop    %ebx
80101c57:	5e                   	pop    %esi
80101c58:	5f                   	pop    %edi
80101c59:	5d                   	pop    %ebp
80101c5a:	c3                   	ret    
80101c5b:	90                   	nop
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c60:	8b 45 10             	mov    0x10(%ebp),%eax
80101c63:	85 c0                	test   %eax,%eax
80101c65:	74 05                	je     80101c6c <dirlookup+0x7c>
        *poff = off;
80101c67:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c70:	8b 03                	mov    (%ebx),%eax
80101c72:	e8 d9 f5 ff ff       	call   80101250 <iget>
}
80101c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7a:	5b                   	pop    %ebx
80101c7b:	5e                   	pop    %esi
80101c7c:	5f                   	pop    %edi
80101c7d:	5d                   	pop    %ebp
80101c7e:	c3                   	ret    
      panic("dirlookup read");
80101c7f:	83 ec 0c             	sub    $0xc,%esp
80101c82:	68 8b 76 10 80       	push   $0x8010768b
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 79 76 10 80       	push   $0x80107679
80101c94:	e8 f7 e6 ff ff       	call   80100390 <panic>
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	89 cf                	mov    %ecx,%edi
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cb3:	0f 84 67 01 00 00    	je     80101e20 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(mythread()->cwd);
80101cb9:	e8 32 1c 00 00       	call   801038f0 <mythread>
  acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(mythread()->cwd);
80101cc1:	8b 70 20             	mov    0x20(%eax),%esi
  acquire(&icache.lock);
80101cc4:	68 00 0a 11 80       	push   $0x80110a00
80101cc9:	e8 b2 2c 00 00       	call   80104980 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101cd9:	e8 62 2d 00 00       	call   80104a40 <release>
80101cde:	83 c4 10             	add    $0x10,%esp
80101ce1:	eb 08                	jmp    80101ceb <namex+0x4b>
80101ce3:	90                   	nop
80101ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ce8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ceb:	0f b6 03             	movzbl (%ebx),%eax
80101cee:	3c 2f                	cmp    $0x2f,%al
80101cf0:	74 f6                	je     80101ce8 <namex+0x48>
  if(*path == 0)
80101cf2:	84 c0                	test   %al,%al
80101cf4:	0f 84 ee 00 00 00    	je     80101de8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cfa:	0f b6 03             	movzbl (%ebx),%eax
80101cfd:	3c 2f                	cmp    $0x2f,%al
80101cff:	0f 84 b3 00 00 00    	je     80101db8 <namex+0x118>
80101d05:	84 c0                	test   %al,%al
80101d07:	89 da                	mov    %ebx,%edx
80101d09:	75 09                	jne    80101d14 <namex+0x74>
80101d0b:	e9 a8 00 00 00       	jmp    80101db8 <namex+0x118>
80101d10:	84 c0                	test   %al,%al
80101d12:	74 0a                	je     80101d1e <namex+0x7e>
    path++;
80101d14:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d17:	0f b6 02             	movzbl (%edx),%eax
80101d1a:	3c 2f                	cmp    $0x2f,%al
80101d1c:	75 f2                	jne    80101d10 <namex+0x70>
80101d1e:	89 d1                	mov    %edx,%ecx
80101d20:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d22:	83 f9 0d             	cmp    $0xd,%ecx
80101d25:	0f 8e 91 00 00 00    	jle    80101dbc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d2b:	83 ec 04             	sub    $0x4,%esp
80101d2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d31:	6a 0e                	push   $0xe
80101d33:	53                   	push   %ebx
80101d34:	57                   	push   %edi
80101d35:	e8 16 2e 00 00       	call   80104b50 <memmove>
    path++;
80101d3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d3d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d40:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d45:	75 11                	jne    80101d58 <namex+0xb8>
80101d47:	89 f6                	mov    %esi,%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	56                   	push   %esi
80101d5c:	e8 5f f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d61:	83 c4 10             	add    $0x10,%esp
80101d64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d69:	0f 85 91 00 00 00    	jne    80101e00 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d72:	85 d2                	test   %edx,%edx
80101d74:	74 09                	je     80101d7f <namex+0xdf>
80101d76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d79:	0f 84 b7 00 00 00    	je     80101e36 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7f:	83 ec 04             	sub    $0x4,%esp
80101d82:	6a 00                	push   $0x0
80101d84:	57                   	push   %edi
80101d85:	56                   	push   %esi
80101d86:	e8 65 fe ff ff       	call   80101bf0 <dirlookup>
80101d8b:	83 c4 10             	add    $0x10,%esp
80101d8e:	85 c0                	test   %eax,%eax
80101d90:	74 6e                	je     80101e00 <namex+0x160>
  iunlock(ip);
80101d92:	83 ec 0c             	sub    $0xc,%esp
80101d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d98:	56                   	push   %esi
80101d99:	e8 02 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	83 c4 10             	add    $0x10,%esp
80101dac:	89 c6                	mov    %eax,%esi
80101dae:	e9 38 ff ff ff       	jmp    80101ceb <namex+0x4b>
80101db3:	90                   	nop
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101db8:	89 da                	mov    %ebx,%edx
80101dba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dbc:	83 ec 04             	sub    $0x4,%esp
80101dbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc5:	51                   	push   %ecx
80101dc6:	53                   	push   %ebx
80101dc7:	57                   	push   %edi
80101dc8:	e8 83 2d 00 00       	call   80104b50 <memmove>
    name[len] = 0;
80101dcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dda:	89 d3                	mov    %edx,%ebx
80101ddc:	e9 61 ff ff ff       	jmp    80101d42 <namex+0xa2>
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	75 5d                	jne    80101e4c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101def:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df2:	89 f0                	mov    %esi,%eax
80101df4:	5b                   	pop    %ebx
80101df5:	5e                   	pop    %esi
80101df6:	5f                   	pop    %edi
80101df7:	5d                   	pop    %ebp
80101df8:	c3                   	ret    
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	56                   	push   %esi
80101e04:	e8 97 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101e09:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e0c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e0e:	e8 dd f9 ff ff       	call   801017f0 <iput>
      return 0;
80101e13:	83 c4 10             	add    $0x10,%esp
}
80101e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e19:	89 f0                	mov    %esi,%eax
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
80101e1f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e20:	ba 01 00 00 00       	mov    $0x1,%edx
80101e25:	b8 01 00 00 00       	mov    $0x1,%eax
80101e2a:	e8 21 f4 ff ff       	call   80101250 <iget>
80101e2f:	89 c6                	mov    %eax,%esi
80101e31:	e9 b5 fe ff ff       	jmp    80101ceb <namex+0x4b>
      iunlock(ip);
80101e36:	83 ec 0c             	sub    $0xc,%esp
80101e39:	56                   	push   %esi
80101e3a:	e8 61 f9 ff ff       	call   801017a0 <iunlock>
      return ip;
80101e3f:	83 c4 10             	add    $0x10,%esp
}
80101e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e45:	89 f0                	mov    %esi,%eax
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
    iput(ip);
80101e4c:	83 ec 0c             	sub    $0xc,%esp
80101e4f:	56                   	push   %esi
    return 0;
80101e50:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e52:	e8 99 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	eb 93                	jmp    80101def <namex+0x14f>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e60 <dirlink>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 20             	sub    $0x20,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e6c:	6a 00                	push   $0x0
80101e6e:	ff 75 0c             	pushl  0xc(%ebp)
80101e71:	53                   	push   %ebx
80101e72:	e8 79 fd ff ff       	call   80101bf0 <dirlookup>
80101e77:	83 c4 10             	add    $0x10,%esp
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	75 67                	jne    80101ee5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e84:	85 ff                	test   %edi,%edi
80101e86:	74 29                	je     80101eb1 <dirlink+0x51>
80101e88:	31 ff                	xor    %edi,%edi
80101e8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8d:	eb 09                	jmp    80101e98 <dirlink+0x38>
80101e8f:	90                   	nop
80101e90:	83 c7 10             	add    $0x10,%edi
80101e93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e96:	73 19                	jae    80101eb1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 fe fa ff ff       	call   801019a0 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 4e                	jne    80101ef8 <dirlink+0x98>
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	75 df                	jne    80101e90 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	ff 75 0c             	pushl  0xc(%ebp)
80101ebc:	50                   	push   %eax
80101ebd:	e8 5e 2d 00 00       	call   80104c20 <strncpy>
  de.inum = inum;
80101ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec5:	6a 10                	push   $0x10
80101ec7:	57                   	push   %edi
80101ec8:	56                   	push   %esi
80101ec9:	53                   	push   %ebx
  de.inum = inum;
80101eca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ece:	e8 cd fb ff ff       	call   80101aa0 <writei>
80101ed3:	83 c4 20             	add    $0x20,%esp
80101ed6:	83 f8 10             	cmp    $0x10,%eax
80101ed9:	75 2a                	jne    80101f05 <dirlink+0xa5>
  return 0;
80101edb:	31 c0                	xor    %eax,%eax
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
    iput(ip);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	50                   	push   %eax
80101ee9:	e8 02 f9 ff ff       	call   801017f0 <iput>
    return -1;
80101eee:	83 c4 10             	add    $0x10,%esp
80101ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef6:	eb e5                	jmp    80101edd <dirlink+0x7d>
      panic("dirlink read");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 9a 76 10 80       	push   $0x8010769a
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 5e 7d 10 80       	push   $0x80107d5e
80101f0d:	e8 7e e4 ff ff       	call   80100390 <panic>
80101f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <namei>:

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	66 90                	xchg   %ax,%ax
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	66 90                	xchg   %ax,%ax
80101f5a:	66 90                	xchg   %ax,%ax
80101f5c:	66 90                	xchg   %ax,%ax
80101f5e:	66 90                	xchg   %ax,%ax

80101f60 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	57                   	push   %edi
80101f64:	56                   	push   %esi
80101f65:	53                   	push   %ebx
80101f66:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f69:	85 c0                	test   %eax,%eax
80101f6b:	0f 84 b4 00 00 00    	je     80102025 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f71:	8b 58 08             	mov    0x8(%eax),%ebx
80101f74:	89 c6                	mov    %eax,%esi
80101f76:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f7c:	0f 87 96 00 00 00    	ja     80102018 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f82:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f87:	89 f6                	mov    %esi,%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f90:	89 ca                	mov    %ecx,%edx
80101f92:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f93:	83 e0 c0             	and    $0xffffffc0,%eax
80101f96:	3c 40                	cmp    $0x40,%al
80101f98:	75 f6                	jne    80101f90 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f9a:	31 ff                	xor    %edi,%edi
80101f9c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fa1:	89 f8                	mov    %edi,%eax
80101fa3:	ee                   	out    %al,(%dx)
80101fa4:	b8 01 00 00 00       	mov    $0x1,%eax
80101fa9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fae:	ee                   	out    %al,(%dx)
80101faf:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fb4:	89 d8                	mov    %ebx,%eax
80101fb6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fb7:	89 d8                	mov    %ebx,%eax
80101fb9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fbe:	c1 f8 08             	sar    $0x8,%eax
80101fc1:	ee                   	out    %al,(%dx)
80101fc2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fc7:	89 f8                	mov    %edi,%eax
80101fc9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fce:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fd3:	c1 e0 04             	shl    $0x4,%eax
80101fd6:	83 e0 10             	and    $0x10,%eax
80101fd9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fdc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fdd:	f6 06 04             	testb  $0x4,(%esi)
80101fe0:	75 16                	jne    80101ff8 <idestart+0x98>
80101fe2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fe7:	89 ca                	mov    %ecx,%edx
80101fe9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fed:	5b                   	pop    %ebx
80101fee:	5e                   	pop    %esi
80101fef:	5f                   	pop    %edi
80101ff0:	5d                   	pop    %ebp
80101ff1:	c3                   	ret    
80101ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ff8:	b8 30 00 00 00       	mov    $0x30,%eax
80101ffd:	89 ca                	mov    %ecx,%edx
80101fff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102000:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102005:	83 c6 5c             	add    $0x5c,%esi
80102008:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010200d:	fc                   	cld    
8010200e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102013:	5b                   	pop    %ebx
80102014:	5e                   	pop    %esi
80102015:	5f                   	pop    %edi
80102016:	5d                   	pop    %ebp
80102017:	c3                   	ret    
    panic("incorrect blockno");
80102018:	83 ec 0c             	sub    $0xc,%esp
8010201b:	68 04 77 10 80       	push   $0x80107704
80102020:	e8 6b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	68 fb 76 10 80       	push   $0x801076fb
8010202d:	e8 5e e3 ff ff       	call   80100390 <panic>
80102032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102040 <ideinit>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102046:	68 16 77 10 80       	push   $0x80107716
8010204b:	68 80 a5 10 80       	push   $0x8010a580
80102050:	e8 eb 27 00 00       	call   80104840 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102055:	58                   	pop    %eax
80102056:	a1 40 2d 11 80       	mov    0x80112d40,%eax
8010205b:	5a                   	pop    %edx
8010205c:	83 e8 01             	sub    $0x1,%eax
8010205f:	50                   	push   %eax
80102060:	6a 0e                	push   $0xe
80102062:	e8 a9 02 00 00       	call   80102310 <ioapicenable>
80102067:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010206a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010206f:	90                   	nop
80102070:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102071:	83 e0 c0             	and    $0xffffffc0,%eax
80102074:	3c 40                	cmp    $0x40,%al
80102076:	75 f8                	jne    80102070 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102078:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010207d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102082:	ee                   	out    %al,(%dx)
80102083:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102088:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010208d:	eb 06                	jmp    80102095 <ideinit+0x55>
8010208f:	90                   	nop
  for(i=0; i<1000; i++){
80102090:	83 e9 01             	sub    $0x1,%ecx
80102093:	74 0f                	je     801020a4 <ideinit+0x64>
80102095:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102096:	84 c0                	test   %al,%al
80102098:	74 f6                	je     80102090 <ideinit+0x50>
      havedisk1 = 1;
8010209a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020ae:	ee                   	out    %al,(%dx)
}
801020af:	c9                   	leave  
801020b0:	c3                   	ret    
801020b1:	eb 0d                	jmp    801020c0 <ideintr>
801020b3:	90                   	nop
801020b4:	90                   	nop
801020b5:	90                   	nop
801020b6:	90                   	nop
801020b7:	90                   	nop
801020b8:	90                   	nop
801020b9:	90                   	nop
801020ba:	90                   	nop
801020bb:	90                   	nop
801020bc:	90                   	nop
801020bd:	90                   	nop
801020be:	90                   	nop
801020bf:	90                   	nop

801020c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020c9:	68 80 a5 10 80       	push   $0x8010a580
801020ce:	e8 ad 28 00 00       	call   80104980 <acquire>

  if((b = idequeue) == 0){
801020d3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020d9:	83 c4 10             	add    $0x10,%esp
801020dc:	85 db                	test   %ebx,%ebx
801020de:	74 67                	je     80102147 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020e0:	8b 43 58             	mov    0x58(%ebx),%eax
801020e3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020e8:	8b 3b                	mov    (%ebx),%edi
801020ea:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020f0:	75 31                	jne    80102123 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020f7:	89 f6                	mov    %esi,%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	89 c6                	mov    %eax,%esi
80102103:	83 e6 c0             	and    $0xffffffc0,%esi
80102106:	89 f1                	mov    %esi,%ecx
80102108:	80 f9 40             	cmp    $0x40,%cl
8010210b:	75 f3                	jne    80102100 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210d:	a8 21                	test   $0x21,%al
8010210f:	75 12                	jne    80102123 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102111:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102114:	b9 80 00 00 00       	mov    $0x80,%ecx
80102119:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211e:	fc                   	cld    
8010211f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102121:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102123:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102126:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102129:	89 f9                	mov    %edi,%ecx
8010212b:	83 c9 02             	or     $0x2,%ecx
8010212e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102130:	53                   	push   %ebx
80102131:	e8 8a 23 00 00       	call   801044c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102136:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	85 c0                	test   %eax,%eax
80102140:	74 05                	je     80102147 <ideintr+0x87>
    idestart(idequeue);
80102142:	e8 19 fe ff ff       	call   80101f60 <idestart>
    release(&idelock);
80102147:	83 ec 0c             	sub    $0xc,%esp
8010214a:	68 80 a5 10 80       	push   $0x8010a580
8010214f:	e8 ec 28 00 00       	call   80104a40 <release>

  release(&idelock);
}
80102154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102157:	5b                   	pop    %ebx
80102158:	5e                   	pop    %esi
80102159:	5f                   	pop    %edi
8010215a:	5d                   	pop    %ebp
8010215b:	c3                   	ret    
8010215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102160 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	53                   	push   %ebx
80102164:	83 ec 10             	sub    $0x10,%esp
80102167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010216a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010216d:	50                   	push   %eax
8010216e:	e8 7d 26 00 00       	call   801047f0 <holdingsleep>
80102173:	83 c4 10             	add    $0x10,%esp
80102176:	85 c0                	test   %eax,%eax
80102178:	0f 84 c6 00 00 00    	je     80102244 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 e0 06             	and    $0x6,%eax
80102183:	83 f8 02             	cmp    $0x2,%eax
80102186:	0f 84 ab 00 00 00    	je     80102237 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010218c:	8b 53 04             	mov    0x4(%ebx),%edx
8010218f:	85 d2                	test   %edx,%edx
80102191:	74 0d                	je     801021a0 <iderw+0x40>
80102193:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102198:	85 c0                	test   %eax,%eax
8010219a:	0f 84 b1 00 00 00    	je     80102251 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	68 80 a5 10 80       	push   $0x8010a580
801021a8:	e8 d3 27 00 00       	call   80104980 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801021b3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bd:	85 d2                	test   %edx,%edx
801021bf:	75 09                	jne    801021ca <iderw+0x6a>
801021c1:	eb 6d                	jmp    80102230 <iderw+0xd0>
801021c3:	90                   	nop
801021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c8:	89 c2                	mov    %eax,%edx
801021ca:	8b 42 58             	mov    0x58(%edx),%eax
801021cd:	85 c0                	test   %eax,%eax
801021cf:	75 f7                	jne    801021c8 <iderw+0x68>
801021d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021d6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021dc:	74 42                	je     80102220 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 e0 06             	and    $0x6,%eax
801021e3:	83 f8 02             	cmp    $0x2,%eax
801021e6:	74 23                	je     8010220b <iderw+0xab>
801021e8:	90                   	nop
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021f0:	83 ec 08             	sub    $0x8,%esp
801021f3:	68 80 a5 10 80       	push   $0x8010a580
801021f8:	53                   	push   %ebx
801021f9:	e8 22 1d 00 00       	call   80103f20 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021fe:	8b 03                	mov    (%ebx),%eax
80102200:	83 c4 10             	add    $0x10,%esp
80102203:	83 e0 06             	and    $0x6,%eax
80102206:	83 f8 02             	cmp    $0x2,%eax
80102209:	75 e5                	jne    801021f0 <iderw+0x90>
  }


  release(&idelock);
8010220b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102212:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102215:	c9                   	leave  
  release(&idelock);
80102216:	e9 25 28 00 00       	jmp    80104a40 <release>
8010221b:	90                   	nop
8010221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102220:	89 d8                	mov    %ebx,%eax
80102222:	e8 39 fd ff ff       	call   80101f60 <idestart>
80102227:	eb b5                	jmp    801021de <iderw+0x7e>
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102230:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102235:	eb 9d                	jmp    801021d4 <iderw+0x74>
    panic("iderw: nothing to do");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 30 77 10 80       	push   $0x80107730
8010223f:	e8 4c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 1a 77 10 80       	push   $0x8010771a
8010224c:	e8 3f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102251:	83 ec 0c             	sub    $0xc,%esp
80102254:	68 45 77 10 80       	push   $0x80107745
80102259:	e8 32 e1 ff ff       	call   80100390 <panic>
8010225e:	66 90                	xchg   %ax,%ax

80102260 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102260:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102261:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
80102268:	00 c0 fe 
{
8010226b:	89 e5                	mov    %esp,%ebp
8010226d:	56                   	push   %esi
8010226e:	53                   	push   %ebx
  ioapic->reg = reg;
8010226f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102276:	00 00 00 
  return ioapic->data;
80102279:	a1 54 26 11 80       	mov    0x80112654,%eax
8010227e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102287:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010228d:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102294:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102297:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010229a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010229d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022a0:	39 c2                	cmp    %eax,%edx
801022a2:	74 16                	je     801022ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	68 64 77 10 80       	push   $0x80107764
801022ac:	e8 af e3 ff ff       	call   80100660 <cprintf>
801022b1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	83 c3 21             	add    $0x21,%ebx
{
801022bd:	ba 10 00 00 00       	mov    $0x10,%edx
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	89 f6                	mov    %esi,%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022d2:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022d8:	89 c6                	mov    %eax,%esi
801022da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022e3:	89 71 10             	mov    %esi,0x10(%ecx)
801022e6:	8d 72 01             	lea    0x1(%edx),%esi
801022e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022f0:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801022f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022fd:	75 d1                	jne    801022d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102302:	5b                   	pop    %ebx
80102303:	5e                   	pop    %esi
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	8d 76 00             	lea    0x0(%esi),%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102310 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102310:	55                   	push   %ebp
  ioapic->reg = reg;
80102311:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102317:	89 e5                	mov    %esp,%ebp
80102319:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010231c:	8d 50 20             	lea    0x20(%eax),%edx
8010231f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102323:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102325:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010232e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102331:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102334:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102336:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010233b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010233e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102341:	5d                   	pop    %ebp
80102342:	c3                   	ret    
80102343:	66 90                	xchg   %ax,%ax
80102345:	66 90                	xchg   %ax,%ax
80102347:	66 90                	xchg   %ax,%ax
80102349:	66 90                	xchg   %ax,%ax
8010234b:	66 90                	xchg   %ax,%ax
8010234d:	66 90                	xchg   %ax,%ax
8010234f:	90                   	nop

80102350 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 04             	sub    $0x4,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010235a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102360:	75 70                	jne    801023d2 <kfree+0x82>
80102362:	81 fb e8 34 12 80    	cmp    $0x801234e8,%ebx
80102368:	72 68                	jb     801023d2 <kfree+0x82>
8010236a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102370:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102375:	77 5b                	ja     801023d2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102377:	83 ec 04             	sub    $0x4,%esp
8010237a:	68 00 10 00 00       	push   $0x1000
8010237f:	6a 01                	push   $0x1
80102381:	53                   	push   %ebx
80102382:	e8 19 27 00 00       	call   80104aa0 <memset>

  if(kmem.use_lock)
80102387:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	85 d2                	test   %edx,%edx
80102392:	75 2c                	jne    801023c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102394:	a1 98 26 11 80       	mov    0x80112698,%eax
80102399:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010239b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
801023a0:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
801023a6:	85 c0                	test   %eax,%eax
801023a8:	75 06                	jne    801023b0 <kfree+0x60>
    release(&kmem.lock);
}
801023aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ad:	c9                   	leave  
801023ae:	c3                   	ret    
801023af:	90                   	nop
    release(&kmem.lock);
801023b0:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ba:	c9                   	leave  
    release(&kmem.lock);
801023bb:	e9 80 26 00 00       	jmp    80104a40 <release>
    acquire(&kmem.lock);
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	68 60 26 11 80       	push   $0x80112660
801023c8:	e8 b3 25 00 00       	call   80104980 <acquire>
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	eb c2                	jmp    80102394 <kfree+0x44>
    panic("kfree");
801023d2:	83 ec 0c             	sub    $0xc,%esp
801023d5:	68 96 77 10 80       	push   $0x80107796
801023da:	e8 b1 df ff ff       	call   80100390 <panic>
801023df:	90                   	nop

801023e0 <freerange>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fd:	39 de                	cmp    %ebx,%esi
801023ff:	72 23                	jb     80102424 <freerange+0x44>
80102401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102408:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010240e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102417:	50                   	push   %eax
80102418:	e8 33 ff ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	39 f3                	cmp    %esi,%ebx
80102422:	76 e4                	jbe    80102408 <freerange+0x28>
}
80102424:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102427:	5b                   	pop    %ebx
80102428:	5e                   	pop    %esi
80102429:	5d                   	pop    %ebp
8010242a:	c3                   	ret    
8010242b:	90                   	nop
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <kinit1>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
80102435:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102438:	83 ec 08             	sub    $0x8,%esp
8010243b:	68 9c 77 10 80       	push   $0x8010779c
80102440:	68 60 26 11 80       	push   $0x80112660
80102445:	e8 f6 23 00 00       	call   80104840 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102450:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102457:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010245a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102460:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102466:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010246c:	39 de                	cmp    %ebx,%esi
8010246e:	72 1c                	jb     8010248c <kinit1+0x5c>
    kfree(p);
80102470:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102476:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102479:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010247f:	50                   	push   %eax
80102480:	e8 cb fe ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	39 de                	cmp    %ebx,%esi
8010248a:	73 e4                	jae    80102470 <kinit1+0x40>
}
8010248c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248f:	5b                   	pop    %ebx
80102490:	5e                   	pop    %esi
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret    
80102493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024bd:	39 de                	cmp    %ebx,%esi
801024bf:	72 23                	jb     801024e4 <kinit2+0x44>
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024d7:	50                   	push   %eax
801024d8:	e8 73 fe ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	39 de                	cmp    %ebx,%esi
801024e2:	73 e4                	jae    801024c8 <kinit2+0x28>
  kmem.use_lock = 1;
801024e4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024eb:	00 00 00 
}
801024ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f1:	5b                   	pop    %ebx
801024f2:	5e                   	pop    %esi
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    
801024f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102500:	a1 94 26 11 80       	mov    0x80112694,%eax
80102505:	85 c0                	test   %eax,%eax
80102507:	75 1f                	jne    80102528 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102509:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
8010250e:	85 c0                	test   %eax,%eax
80102510:	74 0e                	je     80102520 <kalloc+0x20>
    kmem.freelist = r->next;
80102512:	8b 10                	mov    (%eax),%edx
80102514:	89 15 98 26 11 80    	mov    %edx,0x80112698
8010251a:	c3                   	ret    
8010251b:	90                   	nop
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102520:	f3 c3                	repz ret 
80102522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102528:	55                   	push   %ebp
80102529:	89 e5                	mov    %esp,%ebp
8010252b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010252e:	68 60 26 11 80       	push   $0x80112660
80102533:	e8 48 24 00 00       	call   80104980 <acquire>
  r = kmem.freelist;
80102538:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102546:	85 c0                	test   %eax,%eax
80102548:	74 08                	je     80102552 <kalloc+0x52>
    kmem.freelist = r->next;
8010254a:	8b 08                	mov    (%eax),%ecx
8010254c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(kmem.use_lock)
80102552:	85 d2                	test   %edx,%edx
80102554:	74 16                	je     8010256c <kalloc+0x6c>
    release(&kmem.lock);
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010255c:	68 60 26 11 80       	push   $0x80112660
80102561:	e8 da 24 00 00       	call   80104a40 <release>
  return (char*)r;
80102566:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102569:	83 c4 10             	add    $0x10,%esp
}
8010256c:	c9                   	leave  
8010256d:	c3                   	ret    
8010256e:	66 90                	xchg   %ax,%ax

80102570 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102570:	ba 64 00 00 00       	mov    $0x64,%edx
80102575:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102576:	a8 01                	test   $0x1,%al
80102578:	0f 84 c2 00 00 00    	je     80102640 <kbdgetc+0xd0>
8010257e:	ba 60 00 00 00       	mov    $0x60,%edx
80102583:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102584:	0f b6 d0             	movzbl %al,%edx
80102587:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010258d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102593:	0f 84 7f 00 00 00    	je     80102618 <kbdgetc+0xa8>
{
80102599:	55                   	push   %ebp
8010259a:	89 e5                	mov    %esp,%ebp
8010259c:	53                   	push   %ebx
8010259d:	89 cb                	mov    %ecx,%ebx
8010259f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025a2:	84 c0                	test   %al,%al
801025a4:	78 4a                	js     801025f0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025a6:	85 db                	test   %ebx,%ebx
801025a8:	74 09                	je     801025b3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025aa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025ad:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025b0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025b3:	0f b6 82 e0 78 10 80 	movzbl -0x7fef8720(%edx),%eax
801025ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025bc:	0f b6 82 e0 77 10 80 	movzbl -0x7fef8820(%edx),%eax
801025c3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025c7:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025cd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025d0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025d3:	8b 04 85 c0 77 10 80 	mov    -0x7fef8840(,%eax,4),%eax
801025da:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025de:	74 31                	je     80102611 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025e0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025e3:	83 fa 19             	cmp    $0x19,%edx
801025e6:	77 40                	ja     80102628 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025e8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025eb:	5b                   	pop    %ebx
801025ec:	5d                   	pop    %ebp
801025ed:	c3                   	ret    
801025ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025f0:	83 e0 7f             	and    $0x7f,%eax
801025f3:	85 db                	test   %ebx,%ebx
801025f5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025f8:	0f b6 82 e0 78 10 80 	movzbl -0x7fef8720(%edx),%eax
801025ff:	83 c8 40             	or     $0x40,%eax
80102602:	0f b6 c0             	movzbl %al,%eax
80102605:	f7 d0                	not    %eax
80102607:	21 c1                	and    %eax,%ecx
    return 0;
80102609:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010260b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102611:	5b                   	pop    %ebx
80102612:	5d                   	pop    %ebp
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102618:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010261b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010261d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102623:	c3                   	ret    
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102628:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010262b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010262e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010262f:	83 f9 1a             	cmp    $0x1a,%ecx
80102632:	0f 42 c2             	cmovb  %edx,%eax
}
80102635:	5d                   	pop    %ebp
80102636:	c3                   	ret    
80102637:	89 f6                	mov    %esi,%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102645:	c3                   	ret    
80102646:	8d 76 00             	lea    0x0(%esi),%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <kbdintr>:

void
kbdintr(void)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102656:	68 70 25 10 80       	push   $0x80102570
8010265b:	e8 b0 e1 ff ff       	call   80100810 <consoleintr>
}
80102660:	83 c4 10             	add    $0x10,%esp
80102663:	c9                   	leave  
80102664:	c3                   	ret    
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c8 00 00 00    	je     80102748 <lapicinit+0xd8>
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 77                	ja     80102750 <lapicinit+0xe0>
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102730:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102736:	80 e6 10             	and    $0x10,%dh
80102739:	75 f5                	jne    80102730 <lapicinit+0xc0>
  lapic[index] = value;
8010273b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102742:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102745:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102748:	5d                   	pop    %ebp
80102749:	c3                   	ret    
8010274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102750:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102757:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx
8010275d:	e9 77 ff ff ff       	jmp    801026d9 <lapicinit+0x69>
80102762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102770:	8b 15 9c 26 11 80    	mov    0x8011269c,%edx
{
80102776:	55                   	push   %ebp
80102777:	31 c0                	xor    %eax,%eax
80102779:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010277b:	85 d2                	test   %edx,%edx
8010277d:	74 06                	je     80102785 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010277f:	8b 42 20             	mov    0x20(%edx),%eax
80102782:	c1 e8 18             	shr    $0x18,%eax
}
80102785:	5d                   	pop    %ebp
80102786:	c3                   	ret    
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102790:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027c6:	ba 70 00 00 00       	mov    $0x70,%edx
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	ba 71 00 00 00       	mov    $0x71,%edx
801027df:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027e0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027e2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027eb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ed:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027f0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027f3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027fe:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102803:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102809:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010280c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102813:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102816:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102819:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102820:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102823:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102826:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010282f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102838:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010284a:	5b                   	pop    %ebx
8010284b:	5d                   	pop    %ebp
8010284c:	c3                   	ret    
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	b8 0b 00 00 00       	mov    $0xb,%eax
80102856:	ba 70 00 00 00       	mov    $0x70,%edx
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	ba 71 00 00 00       	mov    $0x71,%edx
80102869:	ec                   	in     (%dx),%al
8010286a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010286d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102872:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102875:	8d 76 00             	lea    0x0(%esi),%esi
80102878:	31 c0                	xor    %eax,%eax
8010287a:	89 da                	mov    %ebx,%edx
8010287c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102882:	89 ca                	mov    %ecx,%edx
80102884:	ec                   	in     (%dx),%al
80102885:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102888:	89 da                	mov    %ebx,%edx
8010288a:	b8 02 00 00 00       	mov    $0x2,%eax
8010288f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102890:	89 ca                	mov    %ecx,%edx
80102892:	ec                   	in     (%dx),%al
80102893:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102896:	89 da                	mov    %ebx,%edx
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
801028a1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	89 da                	mov    %ebx,%edx
801028a6:	b8 07 00 00 00       	mov    $0x7,%eax
801028ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
801028af:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b2:	89 da                	mov    %ebx,%edx
801028b4:	b8 08 00 00 00       	mov    $0x8,%eax
801028b9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ba:	89 ca                	mov    %ecx,%edx
801028bc:	ec                   	in     (%dx),%al
801028bd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bf:	89 da                	mov    %ebx,%edx
801028c1:	b8 09 00 00 00       	mov    $0x9,%eax
801028c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c7:	89 ca                	mov    %ecx,%edx
801028c9:	ec                   	in     (%dx),%al
801028ca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cc:	89 da                	mov    %ebx,%edx
801028ce:	b8 0a 00 00 00       	mov    $0xa,%eax
801028d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d4:	89 ca                	mov    %ecx,%edx
801028d6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d7:	84 c0                	test   %al,%al
801028d9:	78 9d                	js     80102878 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028db:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028df:	89 fa                	mov    %edi,%edx
801028e1:	0f b6 fa             	movzbl %dl,%edi
801028e4:	89 f2                	mov    %esi,%edx
801028e6:	0f b6 f2             	movzbl %dl,%esi
801028e9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ec:	89 da                	mov    %ebx,%edx
801028ee:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028f4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028fb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102902:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102906:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102909:	31 c0                	xor    %eax,%eax
8010290b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
8010290f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102912:	89 da                	mov    %ebx,%edx
80102914:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102917:	b8 02 00 00 00       	mov    $0x2,%eax
8010291c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291d:	89 ca                	mov    %ecx,%edx
8010291f:	ec                   	in     (%dx),%al
80102920:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102923:	89 da                	mov    %ebx,%edx
80102925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102928:	b8 04 00 00 00       	mov    $0x4,%eax
8010292d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292e:	89 ca                	mov    %ecx,%edx
80102930:	ec                   	in     (%dx),%al
80102931:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102934:	89 da                	mov    %ebx,%edx
80102936:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102939:	b8 07 00 00 00       	mov    $0x7,%eax
8010293e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293f:	89 ca                	mov    %ecx,%edx
80102941:	ec                   	in     (%dx),%al
80102942:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102945:	89 da                	mov    %ebx,%edx
80102947:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010294a:	b8 08 00 00 00       	mov    $0x8,%eax
8010294f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
80102953:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102956:	89 da                	mov    %ebx,%edx
80102958:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010295b:	b8 09 00 00 00       	mov    $0x9,%eax
80102960:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102961:	89 ca                	mov    %ecx,%edx
80102963:	ec                   	in     (%dx),%al
80102964:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102967:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010296a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010296d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102970:	6a 18                	push   $0x18
80102972:	50                   	push   %eax
80102973:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102976:	50                   	push   %eax
80102977:	e8 74 21 00 00       	call   80104af0 <memcmp>
8010297c:	83 c4 10             	add    $0x10,%esp
8010297f:	85 c0                	test   %eax,%eax
80102981:	0f 85 f1 fe ff ff    	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102987:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010298b:	75 78                	jne    80102a05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010298d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102990:	89 c2                	mov    %eax,%edx
80102992:	83 e0 0f             	and    $0xf,%eax
80102995:	c1 ea 04             	shr    $0x4,%edx
80102998:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a4:	89 c2                	mov    %eax,%edx
801029a6:	83 e0 0f             	and    $0xf,%eax
801029a9:	c1 ea 04             	shr    $0x4,%edx
801029ac:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029af:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b8:	89 c2                	mov    %eax,%edx
801029ba:	83 e0 0f             	and    $0xf,%eax
801029bd:	c1 ea 04             	shr    $0x4,%edx
801029c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029cc:	89 c2                	mov    %eax,%edx
801029ce:	83 e0 0f             	and    $0xf,%eax
801029d1:	c1 ea 04             	shr    $0x4,%edx
801029d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e0:	89 c2                	mov    %eax,%edx
801029e2:	83 e0 0f             	and    $0xf,%eax
801029e5:	c1 ea 04             	shr    $0x4,%edx
801029e8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029eb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f4:	89 c2                	mov    %eax,%edx
801029f6:	83 e0 0f             	and    $0xf,%eax
801029f9:	c1 ea 04             	shr    $0x4,%edx
801029fc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a05:	8b 75 08             	mov    0x8(%ebp),%esi
80102a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a0b:	89 06                	mov    %eax,(%esi)
80102a0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a10:	89 46 04             	mov    %eax,0x4(%esi)
80102a13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a16:	89 46 08             	mov    %eax,0x8(%esi)
80102a19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a22:	89 46 10             	mov    %eax,0x10(%esi)
80102a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a35:	5b                   	pop    %ebx
80102a36:	5e                   	pop    %esi
80102a37:	5f                   	pop    %edi
80102a38:	5d                   	pop    %ebp
80102a39:	c3                   	ret    
80102a3a:	66 90                	xchg   %ax,%ax
80102a3c:	66 90                	xchg   %ax,%ax
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a40:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102a46:	85 c9                	test   %ecx,%ecx
80102a48:	0f 8e 8a 00 00 00    	jle    80102ad8 <install_trans+0x98>
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	57                   	push   %edi
80102a52:	56                   	push   %esi
80102a53:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	31 db                	xor    %ebx,%ebx
{
80102a56:	83 ec 0c             	sub    $0xc,%esp
80102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a60:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	01 d8                	add    %ebx,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	50                   	push   %eax
80102a6e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102a74:	e8 57 d6 ff ff       	call   801000d0 <bread>
80102a79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7b:	58                   	pop    %eax
80102a7c:	5a                   	pop    %edx
80102a7d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102a84:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a8d:	e8 3e d6 ff ff       	call   801000d0 <bread>
80102a92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a97:	83 c4 0c             	add    $0xc,%esp
80102a9a:	68 00 02 00 00       	push   $0x200
80102a9f:	50                   	push   %eax
80102aa0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa3:	50                   	push   %eax
80102aa4:	e8 a7 20 00 00       	call   80104b50 <memmove>
    bwrite(dbuf);  // write dst to disk
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 ef d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ab1:	89 3c 24             	mov    %edi,(%esp)
80102ab4:	e8 27 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ab9:	89 34 24             	mov    %esi,(%esp)
80102abc:	e8 1f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ac1:	83 c4 10             	add    $0x10,%esp
80102ac4:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102aca:	7f 94                	jg     80102a60 <install_trans+0x20>
  }
}
80102acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102acf:	5b                   	pop    %ebx
80102ad0:	5e                   	pop    %esi
80102ad1:	5f                   	pop    %edi
80102ad2:	5d                   	pop    %ebp
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	f3 c3                	repz ret 
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ae0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ae5:	83 ec 08             	sub    $0x8,%esp
80102ae8:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102aee:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102af4:	e8 d7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102af9:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aff:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b02:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b04:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b06:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b09:	7e 16                	jle    80102b21 <write_head+0x41>
80102b0b:	c1 e3 02             	shl    $0x2,%ebx
80102b0e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b10:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102b16:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b1a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <write_head+0x30>
  }
  bwrite(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	56                   	push   %esi
80102b25:	e8 76 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b2a:	89 34 24             	mov    %esi,(%esp)
80102b2d:	e8 ae d6 ff ff       	call   801001e0 <brelse>
}
80102b32:	83 c4 10             	add    $0x10,%esp
80102b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b38:	5b                   	pop    %ebx
80102b39:	5e                   	pop    %esi
80102b3a:	5d                   	pop    %ebp
80102b3b:	c3                   	ret    
80102b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b40 <initlog>:
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 2c             	sub    $0x2c,%esp
80102b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b4a:	68 e0 79 10 80       	push   $0x801079e0
80102b4f:	68 a0 26 11 80       	push   $0x801126a0
80102b54:	e8 e7 1c 00 00       	call   80104840 <initlock>
  readsb(dev, &sb);
80102b59:	58                   	pop    %eax
80102b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 9b e8 ff ff       	call   80101400 <readsb>
  log.size = sb.nlog;
80102b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b6b:	59                   	pop    %ecx
  log.dev = dev;
80102b6c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102b72:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  log.start = sb.logstart;
80102b78:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  struct buf *buf = bread(log.dev, log.start);
80102b7d:	5a                   	pop    %edx
80102b7e:	50                   	push   %eax
80102b7f:	53                   	push   %ebx
80102b80:	e8 4b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b85:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b8d:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b93:	7e 1c                	jle    80102bb1 <initlog+0x71>
80102b95:	c1 e3 02             	shl    $0x2,%ebx
80102b98:	31 d2                	xor    %edx,%edx
80102b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ba0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ba4:	83 c2 04             	add    $0x4,%edx
80102ba7:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bad:	39 d3                	cmp    %edx,%ebx
80102baf:	75 ef                	jne    80102ba0 <initlog+0x60>
  brelse(buf);
80102bb1:	83 ec 0c             	sub    $0xc,%esp
80102bb4:	50                   	push   %eax
80102bb5:	e8 26 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bba:	e8 81 fe ff ff       	call   80102a40 <install_trans>
  log.lh.n = 0;
80102bbf:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102bc6:	00 00 00 
  write_head(); // clear the log
80102bc9:	e8 12 ff ff ff       	call   80102ae0 <write_head>
}
80102bce:	83 c4 10             	add    $0x10,%esp
80102bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    
80102bd6:	8d 76 00             	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102be6:	68 a0 26 11 80       	push   $0x801126a0
80102beb:	e8 90 1d 00 00       	call   80104980 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 a0 26 11 80       	push   $0x801126a0
80102c00:	68 a0 26 11 80       	push   $0x801126a0
80102c05:	e8 16 13 00 00       	call   80103f20 <sleep>
80102c0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c0d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 e2                	jne    80102bf8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c16:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102c1b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102c21:	83 c0 01             	add    $0x1,%eax
80102c24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c2a:	83 fa 1e             	cmp    $0x1e,%edx
80102c2d:	7f c9                	jg     80102bf8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c32:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102c37:	68 a0 26 11 80       	push   $0x801126a0
80102c3c:	e8 ff 1d 00 00       	call   80104a40 <release>
      break;
    }
  }
}
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	c9                   	leave  
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	57                   	push   %edi
80102c54:	56                   	push   %esi
80102c55:	53                   	push   %ebx
80102c56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c59:	68 a0 26 11 80       	push   $0x801126a0
80102c5e:	e8 1d 1d 00 00       	call   80104980 <acquire>
  log.outstanding -= 1;
80102c63:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c68:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102c6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c71:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c74:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c76:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102c7c:	0f 85 1a 01 00 00    	jne    80102d9c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c82:	85 db                	test   %ebx,%ebx
80102c84:	0f 85 ee 00 00 00    	jne    80102d78 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c8a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c8d:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c94:	00 00 00 
  release(&log.lock);
80102c97:	68 a0 26 11 80       	push   $0x801126a0
80102c9c:	e8 9f 1d 00 00       	call   80104a40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ca1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102ca7:	83 c4 10             	add    $0x10,%esp
80102caa:	85 c9                	test   %ecx,%ecx
80102cac:	0f 8e 85 00 00 00    	jle    80102d37 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cb2:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102cb7:	83 ec 08             	sub    $0x8,%esp
80102cba:	01 d8                	add    %ebx,%eax
80102cbc:	83 c0 01             	add    $0x1,%eax
80102cbf:	50                   	push   %eax
80102cc0:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102cc6:	e8 05 d4 ff ff       	call   801000d0 <bread>
80102ccb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccd:	58                   	pop    %eax
80102cce:	5a                   	pop    %edx
80102ccf:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102cd6:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cdc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cdf:	e8 ec d3 ff ff       	call   801000d0 <bread>
80102ce4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ce6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ce9:	83 c4 0c             	add    $0xc,%esp
80102cec:	68 00 02 00 00       	push   $0x200
80102cf1:	50                   	push   %eax
80102cf2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cf5:	50                   	push   %eax
80102cf6:	e8 55 1e 00 00       	call   80104b50 <memmove>
    bwrite(to);  // write the log
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 9d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d03:	89 3c 24             	mov    %edi,(%esp)
80102d06:	e8 d5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d0b:	89 34 24             	mov    %esi,(%esp)
80102d0e:	e8 cd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d13:	83 c4 10             	add    $0x10,%esp
80102d16:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102d1c:	7c 94                	jl     80102cb2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d1e:	e8 bd fd ff ff       	call   80102ae0 <write_head>
    install_trans(); // Now install writes to home locations
80102d23:	e8 18 fd ff ff       	call   80102a40 <install_trans>
    log.lh.n = 0;
80102d28:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d2f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d32:	e8 a9 fd ff ff       	call   80102ae0 <write_head>
    acquire(&log.lock);
80102d37:	83 ec 0c             	sub    $0xc,%esp
80102d3a:	68 a0 26 11 80       	push   $0x801126a0
80102d3f:	e8 3c 1c 00 00       	call   80104980 <acquire>
    wakeup(&log);
80102d44:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102d4b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d52:	00 00 00 
    wakeup(&log);
80102d55:	e8 66 17 00 00       	call   801044c0 <wakeup>
    release(&log.lock);
80102d5a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d61:	e8 da 1c 00 00       	call   80104a40 <release>
80102d66:	83 c4 10             	add    $0x10,%esp
}
80102d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6c:	5b                   	pop    %ebx
80102d6d:	5e                   	pop    %esi
80102d6e:	5f                   	pop    %edi
80102d6f:	5d                   	pop    %ebp
80102d70:	c3                   	ret    
80102d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d78:	83 ec 0c             	sub    $0xc,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	e8 3b 17 00 00       	call   801044c0 <wakeup>
  release(&log.lock);
80102d85:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d8c:	e8 af 1c 00 00       	call   80104a40 <release>
80102d91:	83 c4 10             	add    $0x10,%esp
}
80102d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d97:	5b                   	pop    %ebx
80102d98:	5e                   	pop    %esi
80102d99:	5f                   	pop    %edi
80102d9a:	5d                   	pop    %ebp
80102d9b:	c3                   	ret    
    panic("log.committing");
80102d9c:	83 ec 0c             	sub    $0xc,%esp
80102d9f:	68 e4 79 10 80       	push   $0x801079e4
80102da4:	e8 e7 d5 ff ff       	call   80100390 <panic>
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102db0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dc0:	83 fa 1d             	cmp    $0x1d,%edx
80102dc3:	0f 8f 9d 00 00 00    	jg     80102e66 <log_write+0xb6>
80102dc9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102dce:	83 e8 01             	sub    $0x1,%eax
80102dd1:	39 c2                	cmp    %eax,%edx
80102dd3:	0f 8d 8d 00 00 00    	jge    80102e66 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dd9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	0f 8e 8d 00 00 00    	jle    80102e73 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	68 a0 26 11 80       	push   $0x801126a0
80102dee:	e8 8d 1b 00 00       	call   80104980 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102df3:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	83 f9 00             	cmp    $0x0,%ecx
80102dff:	7e 57                	jle    80102e58 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e01:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e04:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e06:	3b 15 ec 26 11 80    	cmp    0x801126ec,%edx
80102e0c:	75 0b                	jne    80102e19 <log_write+0x69>
80102e0e:	eb 38                	jmp    80102e48 <log_write+0x98>
80102e10:	39 14 85 ec 26 11 80 	cmp    %edx,-0x7feed914(,%eax,4)
80102e17:	74 2f                	je     80102e48 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e19:	83 c0 01             	add    $0x1,%eax
80102e1c:	39 c1                	cmp    %eax,%ecx
80102e1e:	75 f0                	jne    80102e10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e20:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e27:	83 c0 01             	add    $0x1,%eax
80102e2a:	a3 e8 26 11 80       	mov    %eax,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102e2f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e32:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3c:	c9                   	leave  
  release(&log.lock);
80102e3d:	e9 fe 1b 00 00       	jmp    80104a40 <release>
80102e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e48:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
80102e4f:	eb de                	jmp    80102e2f <log_write+0x7f>
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8b 43 08             	mov    0x8(%ebx),%eax
80102e5b:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e60:	75 cd                	jne    80102e2f <log_write+0x7f>
80102e62:	31 c0                	xor    %eax,%eax
80102e64:	eb c1                	jmp    80102e27 <log_write+0x77>
    panic("too big a transaction");
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	68 f3 79 10 80       	push   $0x801079f3
80102e6e:	e8 1d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e73:	83 ec 0c             	sub    $0xc,%esp
80102e76:	68 09 7a 10 80       	push   $0x80107a09
80102e7b:	e8 10 d5 ff ff       	call   80100390 <panic>

80102e80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e87:	e8 14 0a 00 00       	call   801038a0 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 0d 0a 00 00       	call   801038a0 <cpuid>
80102e93:	83 ec 04             	sub    $0x4,%esp
80102e96:	53                   	push   %ebx
80102e97:	50                   	push   %eax
80102e98:	68 24 7a 10 80       	push   $0x80107a24
80102e9d:	e8 be d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea2:	e8 89 2e 00 00       	call   80105d30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ea7:	e8 74 09 00 00       	call   80103820 <mycpu>
80102eac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eae:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eba:	e8 21 0e 00 00       	call   80103ce0 <scheduler>
80102ebf:	90                   	nop

80102ec0 <mpenter>:
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ec6:	e8 55 3f 00 00       	call   80106e20 <switchkvm>
  seginit();
80102ecb:	e8 c0 3e 00 00       	call   80106d90 <seginit>
  lapicinit();
80102ed0:	e8 9b f7 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102ed5:	e8 a6 ff ff ff       	call   80102e80 <mpmain>
80102eda:	66 90                	xchg   %ax,%ax
80102edc:	66 90                	xchg   %ax,%ax
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <main>:
{
80102ee0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ee4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ee7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eea:	55                   	push   %ebp
80102eeb:	89 e5                	mov    %esp,%ebp
80102eed:	53                   	push   %ebx
80102eee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eef:	83 ec 08             	sub    $0x8,%esp
80102ef2:	68 00 00 40 80       	push   $0x80400000
80102ef7:	68 e8 34 12 80       	push   $0x801234e8
80102efc:	e8 2f f5 ff ff       	call   80102430 <kinit1>
  kvmalloc();      // kernel page table
80102f01:	e8 fa 43 00 00       	call   80107300 <kvmalloc>
  mpinit();        // detect other processors
80102f06:	e8 75 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f0b:	e8 60 f7 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102f10:	e8 7b 3e 00 00       	call   80106d90 <seginit>
  picinit();       // disable pic
80102f15:	e8 46 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f1a:	e8 41 f3 ff ff       	call   80102260 <ioapicinit>
  consoleinit();   // console hardware
80102f1f:	e8 9c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f24:	e8 37 31 00 00       	call   80106060 <uartinit>
  pinit();         // process table
80102f29:	e8 b2 08 00 00       	call   801037e0 <pinit>
  tvinit();        // trap vectors
80102f2e:	e8 7d 2d 00 00       	call   80105cb0 <tvinit>
  binit();         // buffer cache
80102f33:	e8 08 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f38:	e8 53 de ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk 
80102f3d:	e8 fe f0 ff ff       	call   80102040 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f42:	83 c4 0c             	add    $0xc,%esp
80102f45:	68 8a 00 00 00       	push   $0x8a
80102f4a:	68 8c a4 10 80       	push   $0x8010a48c
80102f4f:	68 00 70 00 80       	push   $0x80007000
80102f54:	e8 f7 1b 00 00       	call   80104b50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f59:	69 05 40 2d 11 80 b4 	imul   $0xb4,0x80112d40,%eax
80102f60:	00 00 00 
80102f63:	83 c4 10             	add    $0x10,%esp
80102f66:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f6b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80102f70:	76 71                	jbe    80102fe3 <main+0x103>
80102f72:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80102f77:	89 f6                	mov    %esi,%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f80:	e8 9b 08 00 00       	call   80103820 <mycpu>
80102f85:	39 d8                	cmp    %ebx,%eax
80102f87:	74 41                	je     80102fca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f89:	e8 72 f5 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f8e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f93:	c7 05 f8 6f 00 80 c0 	movl   $0x80102ec0,0x80006ff8
80102f9a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f9d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fa4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fa7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fac:	0f b6 03             	movzbl (%ebx),%eax
80102faf:	83 ec 08             	sub    $0x8,%esp
80102fb2:	68 00 70 00 00       	push   $0x7000
80102fb7:	50                   	push   %eax
80102fb8:	e8 03 f8 ff ff       	call   801027c0 <lapicstartap>
80102fbd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fc0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	74 f6                	je     80102fc0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fca:	69 05 40 2d 11 80 b4 	imul   $0xb4,0x80112d40,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80102fda:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 9d                	jb     80102f80 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 ab f4 ff ff       	call   801024a0 <kinit2>
  userinit();      // first user process
80102ff5:	e8 26 09 00 00       	call   80103920 <userinit>
  mpmain();        // finish this processor's setup
80102ffa:	e8 81 fe ff ff       	call   80102e80 <mpmain>
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103005:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010300b:	53                   	push   %ebx
  e = addr+len;
8010300c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010300f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103012:	39 de                	cmp    %ebx,%esi
80103014:	72 10                	jb     80103026 <mpsearch1+0x26>
80103016:	eb 50                	jmp    80103068 <mpsearch1+0x68>
80103018:	90                   	nop
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	39 fb                	cmp    %edi,%ebx
80103022:	89 fe                	mov    %edi,%esi
80103024:	76 42                	jbe    80103068 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103026:	83 ec 04             	sub    $0x4,%esp
80103029:	8d 7e 10             	lea    0x10(%esi),%edi
8010302c:	6a 04                	push   $0x4
8010302e:	68 38 7a 10 80       	push   $0x80107a38
80103033:	56                   	push   %esi
80103034:	e8 b7 1a 00 00       	call   80104af0 <memcmp>
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	85 c0                	test   %eax,%eax
8010303e:	75 e0                	jne    80103020 <mpsearch1+0x20>
80103040:	89 f1                	mov    %esi,%ecx
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103048:	0f b6 11             	movzbl (%ecx),%edx
8010304b:	83 c1 01             	add    $0x1,%ecx
8010304e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103050:	39 f9                	cmp    %edi,%ecx
80103052:	75 f4                	jne    80103048 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103054:	84 c0                	test   %al,%al
80103056:	75 c8                	jne    80103020 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305b:	89 f0                	mov    %esi,%eax
8010305d:	5b                   	pop    %ebx
8010305e:	5e                   	pop    %esi
8010305f:	5f                   	pop    %edi
80103060:	5d                   	pop    %ebp
80103061:	c3                   	ret    
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010306b:	31 f6                	xor    %esi,%esi
}
8010306d:	89 f0                	mov    %esi,%eax
8010306f:	5b                   	pop    %ebx
80103070:	5e                   	pop    %esi
80103071:	5f                   	pop    %edi
80103072:	5d                   	pop    %ebp
80103073:	c3                   	ret    
80103074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010307a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103080 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103089:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103090:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103097:	c1 e0 08             	shl    $0x8,%eax
8010309a:	09 d0                	or     %edx,%eax
8010309c:	c1 e0 04             	shl    $0x4,%eax
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 1b                	jne    801030be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030b1:	c1 e0 08             	shl    $0x8,%eax
801030b4:	09 d0                	or     %edx,%eax
801030b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030be:	ba 00 04 00 00       	mov    $0x400,%edx
801030c3:	e8 38 ff ff ff       	call   80103000 <mpsearch1>
801030c8:	85 c0                	test   %eax,%eax
801030ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030cd:	0f 84 3d 01 00 00    	je     80103210 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d6:	8b 58 04             	mov    0x4(%eax),%ebx
801030d9:	85 db                	test   %ebx,%ebx
801030db:	0f 84 4f 01 00 00    	je     80103230 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030e7:	83 ec 04             	sub    $0x4,%esp
801030ea:	6a 04                	push   $0x4
801030ec:	68 55 7a 10 80       	push   $0x80107a55
801030f1:	56                   	push   %esi
801030f2:	e8 f9 19 00 00       	call   80104af0 <memcmp>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	85 c0                	test   %eax,%eax
801030fc:	0f 85 2e 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103102:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103109:	3c 01                	cmp    $0x1,%al
8010310b:	0f 95 c2             	setne  %dl
8010310e:	3c 04                	cmp    $0x4,%al
80103110:	0f 95 c0             	setne  %al
80103113:	20 c2                	and    %al,%dl
80103115:	0f 85 15 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010311b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103122:	66 85 ff             	test   %di,%di
80103125:	74 1a                	je     80103141 <mpinit+0xc1>
80103127:	89 f0                	mov    %esi,%eax
80103129:	01 f7                	add    %esi,%edi
  sum = 0;
8010312b:	31 d2                	xor    %edx,%edx
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103130:	0f b6 08             	movzbl (%eax),%ecx
80103133:	83 c0 01             	add    $0x1,%eax
80103136:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103138:	39 c7                	cmp    %eax,%edi
8010313a:	75 f4                	jne    80103130 <mpinit+0xb0>
8010313c:	84 d2                	test   %dl,%dl
8010313e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103141:	85 f6                	test   %esi,%esi
80103143:	0f 84 e7 00 00 00    	je     80103230 <mpinit+0x1b0>
80103149:	84 d2                	test   %dl,%dl
8010314b:	0f 85 df 00 00 00    	jne    80103230 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103151:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103157:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103163:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103169:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010316e:	01 d6                	add    %edx,%esi
80103170:	39 c6                	cmp    %eax,%esi
80103172:	76 23                	jbe    80103197 <mpinit+0x117>
    switch(*p){
80103174:	0f b6 10             	movzbl (%eax),%edx
80103177:	80 fa 04             	cmp    $0x4,%dl
8010317a:	0f 87 ca 00 00 00    	ja     8010324a <mpinit+0x1ca>
80103180:	ff 24 95 7c 7a 10 80 	jmp    *-0x7fef8584(,%edx,4)
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103190:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103193:	39 c6                	cmp    %eax,%esi
80103195:	77 dd                	ja     80103174 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103197:	85 db                	test   %ebx,%ebx
80103199:	0f 84 9e 00 00 00    	je     8010323d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031a6:	74 15                	je     801031bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ad:	ba 22 00 00 00       	mov    $0x22,%edx
801031b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b3:	ba 23 00 00 00       	mov    $0x23,%edx
801031b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bc:	ee                   	out    %al,(%dx)
  }
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031c8:	8b 0d 40 2d 11 80    	mov    0x80112d40,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 40 2d 11 80    	mov    %ecx,0x80112d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e6:	88 97 a0 27 11 80    	mov    %dl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801031ec:	83 c0 14             	add    $0x14,%eax
      continue;
801031ef:	e9 7c ff ff ff       	jmp    80103170 <mpinit+0xf0>
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ff:	88 15 80 27 11 80    	mov    %dl,0x80112780
      continue;
80103205:	e9 66 ff ff ff       	jmp    80103170 <mpinit+0xf0>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103210:	ba 00 00 01 00       	mov    $0x10000,%edx
80103215:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010321a:	e8 e1 fd ff ff       	call   80103000 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103224:	0f 85 a9 fe ff ff    	jne    801030d3 <mpinit+0x53>
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103230:	83 ec 0c             	sub    $0xc,%esp
80103233:	68 3d 7a 10 80       	push   $0x80107a3d
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 5c 7a 10 80       	push   $0x80107a5c
80103245:	e8 46 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010324a:	31 db                	xor    %ebx,%ebx
8010324c:	e9 26 ff ff ff       	jmp    80103177 <mpinit+0xf7>
80103251:	66 90                	xchg   %ax,%ax
80103253:	66 90                	xchg   %ax,%ax
80103255:	66 90                	xchg   %ax,%ax
80103257:	66 90                	xchg   %ax,%ax
80103259:	66 90                	xchg   %ax,%ax
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103260:	55                   	push   %ebp
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	ba 21 00 00 00       	mov    $0x21,%edx
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	ee                   	out    %al,(%dx)
8010326e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103273:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103274:	5d                   	pop    %ebp
80103275:	c3                   	ret    
80103276:	66 90                	xchg   %ax,%ax
80103278:	66 90                	xchg   %ax,%ax
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010328f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010329b:	e8 10 db ff ff       	call   80100db0 <filealloc>
801032a0:	85 c0                	test   %eax,%eax
801032a2:	89 03                	mov    %eax,(%ebx)
801032a4:	74 22                	je     801032c8 <pipealloc+0x48>
801032a6:	e8 05 db ff ff       	call   80100db0 <filealloc>
801032ab:	85 c0                	test   %eax,%eax
801032ad:	89 06                	mov    %eax,(%esi)
801032af:	74 3f                	je     801032f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032b1:	e8 4a f2 ff ff       	call   80102500 <kalloc>
801032b6:	85 c0                	test   %eax,%eax
801032b8:	89 c7                	mov    %eax,%edi
801032ba:	75 54                	jne    80103310 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032bc:	8b 03                	mov    (%ebx),%eax
801032be:	85 c0                	test   %eax,%eax
801032c0:	75 34                	jne    801032f6 <pipealloc+0x76>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032c8:	8b 06                	mov    (%esi),%eax
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 0c                	je     801032da <pipealloc+0x5a>
    fileclose(*f1);
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	50                   	push   %eax
801032d2:	e8 99 db ff ff       	call   80100e70 <fileclose>
801032d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032e2:	5b                   	pop    %ebx
801032e3:	5e                   	pop    %esi
801032e4:	5f                   	pop    %edi
801032e5:	5d                   	pop    %ebp
801032e6:	c3                   	ret    
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032f0:	8b 03                	mov    (%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 e4                	je     801032da <pipealloc+0x5a>
    fileclose(*f0);
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	50                   	push   %eax
801032fa:	e8 71 db ff ff       	call   80100e70 <fileclose>
  if(*f1)
801032ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103301:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103304:	85 c0                	test   %eax,%eax
80103306:	75 c6                	jne    801032ce <pipealloc+0x4e>
80103308:	eb d0                	jmp    801032da <pipealloc+0x5a>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103310:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103313:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010331a:	00 00 00 
  p->writeopen = 1;
8010331d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103324:	00 00 00 
  p->nwrite = 0;
80103327:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010332e:	00 00 00 
  p->nread = 0;
80103331:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103338:	00 00 00 
  initlock(&p->lock, "pipe");
8010333b:	68 90 7a 10 80       	push   $0x80107a90
80103340:	50                   	push   %eax
80103341:	e8 fa 14 00 00       	call   80104840 <initlock>
  (*f0)->type = FD_PIPE;
80103346:	8b 03                	mov    (%ebx),%eax
  return 0;
80103348:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010334b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103351:	8b 03                	mov    (%ebx),%eax
80103353:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103357:	8b 03                	mov    (%ebx),%eax
80103359:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103362:	8b 06                	mov    (%esi),%eax
80103364:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010336a:	8b 06                	mov    (%esi),%eax
8010336c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103370:	8b 06                	mov    (%esi),%eax
80103372:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103376:	8b 06                	mov    (%esi),%eax
80103378:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010337b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010337e:	31 c0                	xor    %eax,%eax
}
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret    
80103385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	56                   	push   %esi
80103394:	53                   	push   %ebx
80103395:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103398:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	53                   	push   %ebx
8010339f:	e8 dc 15 00 00       	call   80104980 <acquire>
  if(writable){
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 f6                	test   %esi,%esi
801033a9:	74 45                	je     801033f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033bb:	00 00 00 
    wakeup(&p->nread);
801033be:	50                   	push   %eax
801033bf:	e8 fc 10 00 00       	call   801044c0 <wakeup>
801033c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cd:	85 d2                	test   %edx,%edx
801033cf:	75 0a                	jne    801033db <pipeclose+0x4b>
801033d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033d7:	85 c0                	test   %eax,%eax
801033d9:	74 35                	je     80103410 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e1:	5b                   	pop    %ebx
801033e2:	5e                   	pop    %esi
801033e3:	5d                   	pop    %ebp
    release(&p->lock);
801033e4:	e9 57 16 00 00       	jmp    80104a40 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 b7 10 00 00       	call   801044c0 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 27 16 00 00       	call   80104a40 <release>
    kfree((char*)p);
80103419:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010341c:	83 c4 10             	add    $0x10,%esp
}
8010341f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5d                   	pop    %ebp
    kfree((char*)p);
80103425:	e9 26 ef ff ff       	jmp    80102350 <kfree>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103430 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 28             	sub    $0x28,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010343c:	53                   	push   %ebx
8010343d:	e8 3e 15 00 00       	call   80104980 <acquire>
  for(i = 0; i < n; i++){
80103442:	8b 45 10             	mov    0x10(%ebp),%eax
80103445:	83 c4 10             	add    $0x10,%esp
80103448:	85 c0                	test   %eax,%eax
8010344a:	0f 8e c9 00 00 00    	jle    80103519 <pipewrite+0xe9>
80103450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103453:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103459:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010345f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103462:	03 4d 10             	add    0x10(%ebp),%ecx
80103465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103468:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010346e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103474:	39 d0                	cmp    %edx,%eax
80103476:	75 71                	jne    801034e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103478:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	74 4e                	je     801034d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103482:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103488:	eb 3a                	jmp    801034c4 <pipewrite+0x94>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	57                   	push   %edi
80103494:	e8 27 10 00 00       	call   801044c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 7e 0a 00 00       	call   80103f20 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ae:	83 c4 10             	add    $0x10,%esp
801034b1:	05 00 02 00 00       	add    $0x200,%eax
801034b6:	39 c2                	cmp    %eax,%edx
801034b8:	75 36                	jne    801034f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034c0:	85 c0                	test   %eax,%eax
801034c2:	74 0c                	je     801034d0 <pipewrite+0xa0>
801034c4:	e8 f7 03 00 00       	call   801038c0 <myproc>
801034c9:	8b 40 1c             	mov    0x1c(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 67 15 00 00       	call   80104a40 <release>
        return -1;
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034f3:	8d 42 01             	lea    0x1(%edx),%eax
801034f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103502:	83 c6 01             	add    $0x1,%esi
80103505:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103509:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010350c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010350f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103513:	0f 85 4f ff ff ff    	jne    80103468 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103519:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	50                   	push   %eax
80103523:	e8 98 0f 00 00       	call   801044c0 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 10 15 00 00       	call   80104a40 <release>
  return n;
80103530:	83 c4 10             	add    $0x10,%esp
80103533:	8b 45 10             	mov    0x10(%ebp),%eax
80103536:	eb a9                	jmp    801034e1 <pipewrite+0xb1>
80103538:	90                   	nop
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103540 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 18             	sub    $0x18,%esp
80103549:	8b 75 08             	mov    0x8(%ebp),%esi
8010354c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010354f:	56                   	push   %esi
80103550:	e8 2b 14 00 00       	call   80104980 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010355e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103564:	75 6a                	jne    801035d0 <piperead+0x90>
80103566:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010356c:	85 db                	test   %ebx,%ebx
8010356e:	0f 84 c4 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103574:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010357a:	eb 2d                	jmp    801035a9 <piperead+0x69>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103580:	83 ec 08             	sub    $0x8,%esp
80103583:	56                   	push   %esi
80103584:	53                   	push   %ebx
80103585:	e8 96 09 00 00       	call   80103f20 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
801035a9:	e8 12 03 00 00       	call   801038c0 <myproc>
801035ae:	8b 48 1c             	mov    0x1c(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 7d 14 00 00       	call   80104a40 <release>
      return -1;
801035c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c9:	89 d8                	mov    %ebx,%eax
801035cb:	5b                   	pop    %ebx
801035cc:	5e                   	pop    %esi
801035cd:	5f                   	pop    %edi
801035ce:	5d                   	pop    %ebp
801035cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 45 10             	mov    0x10(%ebp),%eax
801035d3:	85 c0                	test   %eax,%eax
801035d5:	7e 61                	jle    80103638 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035d7:	31 db                	xor    %ebx,%ebx
801035d9:	eb 13                	jmp    801035ee <piperead+0xae>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ec:	74 1f                	je     8010360d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ee:	8d 41 01             	lea    0x1(%ecx),%eax
801035f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103602:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103605:	83 c3 01             	add    $0x1,%ebx
80103608:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010360b:	75 d3                	jne    801035e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	50                   	push   %eax
80103617:	e8 a4 0e 00 00       	call   801044c0 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 1c 14 00 00       	call   80104a40 <release>
  return i;
80103624:	83 c4 10             	add    $0x10,%esp
}
80103627:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362a:	89 d8                	mov    %ebx,%eax
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	31 db                	xor    %ebx,%ebx
8010363a:	eb d1                	jmp    8010360d <piperead+0xcd>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
    if(DEBUGMODE)
80103640:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
allocproc(void) {
80103645:	55                   	push   %ebp
80103646:	89 e5                	mov    %esp,%ebp
80103648:	56                   	push   %esi
80103649:	53                   	push   %ebx
    if(DEBUGMODE)
8010364a:	85 c0                	test   %eax,%eax
8010364c:	0f 85 16 01 00 00    	jne    80103768 <allocproc+0x128>
        cprintf( " ALLOCPROC ");
    struct proc *p;
    struct thread *t;
    char *sp;
    acquire(&ptable.lock);
80103652:	83 ec 0c             	sub    $0xc,%esp
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc ; p < &ptable.proc[NPROC]; p++  )
80103655:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
    acquire(&ptable.lock);
8010365a:	68 60 2d 11 80       	push   $0x80112d60
8010365f:	e8 1c 13 00 00       	call   80104980 <acquire>
80103664:	83 c4 10             	add    $0x10,%esp
80103667:	eb 15                	jmp    8010367e <allocproc+0x3e>
80103669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc ; p < &ptable.proc[NPROC]; p++  )
80103670:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
80103676:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
8010367c:	73 50                	jae    801036ce <allocproc+0x8e>
        if (p->state == UNUSED)
8010367e:	8b 73 08             	mov    0x8(%ebx),%esi
80103681:	85 f6                	test   %esi,%esi
80103683:	75 eb                	jne    80103670 <allocproc+0x30>
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103685:	a1 04 a0 10 80       	mov    0x8010a004,%eax
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
8010368a:	8b 4b 78             	mov    0x78(%ebx),%ecx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010368d:	8d 73 70             	lea    0x70(%ebx),%esi
    p->state = EMBRYO;
80103690:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    p->tidCounter = 1;
80103697:	c7 83 f4 03 00 00 01 	movl   $0x1,0x3f4(%ebx)
8010369e:	00 00 00 
    p->pid = nextpid++;
801036a1:	8d 50 01             	lea    0x1(%eax),%edx
        if (t->state == UNUSED)
801036a4:	85 c9                	test   %ecx,%ecx
    p->pid = nextpid++;
801036a6:	89 43 0c             	mov    %eax,0xc(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801036a9:	8d 83 f0 03 00 00    	lea    0x3f0(%ebx),%eax
    p->pid = nextpid++;
801036af:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
        if (t->state == UNUSED)
801036b5:	75 10                	jne    801036c7 <allocproc+0x87>
801036b7:	eb 37                	jmp    801036f0 <allocproc+0xb0>
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c0:	8b 56 08             	mov    0x8(%esi),%edx
801036c3:	85 d2                	test   %edx,%edx
801036c5:	74 29                	je     801036f0 <allocproc+0xb0>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801036c7:	83 c6 38             	add    $0x38,%esi
801036ca:	39 f0                	cmp    %esi,%eax
801036cc:	77 f2                	ja     801036c0 <allocproc+0x80>

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->state = UNUSED;
        t->state = UNUSED;
        release(&ptable.lock);
801036ce:	83 ec 0c             	sub    $0xc,%esp
        return 0;
801036d1:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
801036d3:	68 60 2d 11 80       	push   $0x80112d60
801036d8:	e8 63 13 00 00       	call   80104a40 <release>
        return 0;
801036dd:	83 c4 10             	add    $0x10,%esp
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);
//    release(p->procLock);
    return p;
}
801036e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036e3:	89 d8                	mov    %ebx,%eax
801036e5:	5b                   	pop    %ebx
801036e6:	5e                   	pop    %esi
801036e7:	5d                   	pop    %ebp
801036e8:	c3                   	ret    
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    t->state = EMBRYO;
801036f0:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    t->tid = p->tidCounter++;
801036f7:	8b 83 f4 03 00 00    	mov    0x3f4(%ebx),%eax
801036fd:	8d 50 01             	lea    0x1(%eax),%edx
80103700:	89 93 f4 03 00 00    	mov    %edx,0x3f4(%ebx)
80103706:	89 46 0c             	mov    %eax,0xc(%esi)
    p->mainThread = t;
80103709:	89 b3 f0 03 00 00    	mov    %esi,0x3f0(%ebx)
    if ((t->tkstack = kalloc()) == 0) {
8010370f:	e8 ec ed ff ff       	call   80102500 <kalloc>
80103714:	85 c0                	test   %eax,%eax
80103716:	89 46 04             	mov    %eax,0x4(%esi)
80103719:	74 62                	je     8010377d <allocproc+0x13d>
    sp -= sizeof *t->tf;
8010371b:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(t->context, 0, sizeof *t->context);
80103721:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
80103724:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
80103729:	89 56 10             	mov    %edx,0x10(%esi)
    *(uint *) sp = (uint) trapret;
8010372c:	c7 40 14 a2 5c 10 80 	movl   $0x80105ca2,0x14(%eax)
    t->context = (struct context *) sp;
80103733:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
80103736:	6a 14                	push   $0x14
80103738:	6a 00                	push   $0x0
8010373a:	50                   	push   %eax
8010373b:	e8 60 13 00 00       	call   80104aa0 <memset>
    t->context->eip = (uint) forkret;
80103740:	8b 46 14             	mov    0x14(%esi),%eax
80103743:	c7 40 10 90 37 10 80 	movl   $0x80103790,0x10(%eax)
    release(&ptable.lock);
8010374a:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103751:	e8 ea 12 00 00       	call   80104a40 <release>
    return p;
80103756:	83 c4 10             	add    $0x10,%esp
}
80103759:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010375c:	89 d8                	mov    %ebx,%eax
8010375e:	5b                   	pop    %ebx
8010375f:	5e                   	pop    %esi
80103760:	5d                   	pop    %ebp
80103761:	c3                   	ret    
80103762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cprintf( " ALLOCPROC ");
80103768:	83 ec 0c             	sub    $0xc,%esp
8010376b:	68 95 7a 10 80       	push   $0x80107a95
80103770:	e8 eb ce ff ff       	call   80100660 <cprintf>
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	e9 d5 fe ff ff       	jmp    80103652 <allocproc+0x12>
        p->state = UNUSED;
8010377d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        t->state = UNUSED;
80103784:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
8010378b:	e9 3e ff ff ff       	jmp    801036ce <allocproc+0x8e>

80103790 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103796:	68 60 2d 11 80       	push   $0x80112d60
8010379b:	e8 a0 12 00 00       	call   80104a40 <release>

    if (first) {
801037a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	75 04                	jne    801037b0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
801037ac:	c9                   	leave  
801037ad:	c3                   	ret    
801037ae:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
801037b0:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
801037b3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037ba:	00 00 00 
        iinit(ROOTDEV);
801037bd:	6a 01                	push   $0x1
801037bf:	e8 fc dc ff ff       	call   801014c0 <iinit>
        initlog(ROOTDEV);
801037c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037cb:	e8 70 f3 ff ff       	call   80102b40 <initlog>
801037d0:	83 c4 10             	add    $0x10,%esp
}
801037d3:	c9                   	leave  
801037d4:	c3                   	ret    
801037d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <pinit>:
pinit(void) {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
        if(DEBUGMODE)
801037e6:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801037eb:	85 c0                	test   %eax,%eax
801037ed:	74 10                	je     801037ff <pinit+0x1f>
            cprintf( " PINIT ");
801037ef:	83 ec 0c             	sub    $0xc,%esp
801037f2:	68 a1 7a 10 80       	push   $0x80107aa1
801037f7:	e8 64 ce ff ff       	call   80100660 <cprintf>
801037fc:	83 c4 10             	add    $0x10,%esp
        initlock(&ptable.lock, "ptable");
801037ff:	83 ec 08             	sub    $0x8,%esp
80103802:	68 a9 7a 10 80       	push   $0x80107aa9
80103807:	68 60 2d 11 80       	push   $0x80112d60
8010380c:	e8 2f 10 00 00       	call   80104840 <initlock>
}
80103811:	83 c4 10             	add    $0x10,%esp
80103814:	c9                   	leave  
80103815:	c3                   	ret    
80103816:	8d 76 00             	lea    0x0(%esi),%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103820 <mycpu>:
mycpu(void) {
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103825:	9c                   	pushf  
80103826:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103827:	f6 c4 02             	test   $0x2,%ah
8010382a:	75 5e                	jne    8010388a <mycpu+0x6a>
    apicid = lapicid();
8010382c:	e8 3f ef ff ff       	call   80102770 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103831:	8b 35 40 2d 11 80    	mov    0x80112d40,%esi
80103837:	85 f6                	test   %esi,%esi
80103839:	7e 42                	jle    8010387d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010383b:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103842:	39 d0                	cmp    %edx,%eax
80103844:	74 30                	je     80103876 <mycpu+0x56>
80103846:	b9 54 28 11 80       	mov    $0x80112854,%ecx
    for (i = 0; i < ncpu; ++i) {
8010384b:	31 d2                	xor    %edx,%edx
8010384d:	8d 76 00             	lea    0x0(%esi),%esi
80103850:	83 c2 01             	add    $0x1,%edx
80103853:	39 f2                	cmp    %esi,%edx
80103855:	74 26                	je     8010387d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103857:	0f b6 19             	movzbl (%ecx),%ebx
8010385a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
80103860:	39 c3                	cmp    %eax,%ebx
80103862:	75 ec                	jne    80103850 <mycpu+0x30>
80103864:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
8010386a:	05 a0 27 11 80       	add    $0x801127a0,%eax
}
8010386f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103872:	5b                   	pop    %ebx
80103873:	5e                   	pop    %esi
80103874:	5d                   	pop    %ebp
80103875:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103876:	b8 a0 27 11 80       	mov    $0x801127a0,%eax
            return &cpus[i];
8010387b:	eb f2                	jmp    8010386f <mycpu+0x4f>
    panic("unknown apicid\n");
8010387d:	83 ec 0c             	sub    $0xc,%esp
80103880:	68 b0 7a 10 80       	push   $0x80107ab0
80103885:	e8 06 cb ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
8010388a:	83 ec 0c             	sub    $0xc,%esp
8010388d:	68 08 7c 10 80       	push   $0x80107c08
80103892:	e8 f9 ca ff ff       	call   80100390 <panic>
80103897:	89 f6                	mov    %esi,%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038a0 <cpuid>:
cpuid() {
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
801038a6:	e8 75 ff ff ff       	call   80103820 <mycpu>
801038ab:	2d a0 27 11 80       	sub    $0x801127a0,%eax
}
801038b0:	c9                   	leave  
    return mycpu() - cpus;
801038b1:	c1 f8 02             	sar    $0x2,%eax
801038b4:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
801038ba:	c3                   	ret    
801038bb:	90                   	nop
801038bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038c0 <myproc>:
myproc(void) {
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
801038c4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801038c7:	e8 e4 0f 00 00       	call   801048b0 <pushcli>
    c = mycpu();
801038cc:	e8 4f ff ff ff       	call   80103820 <mycpu>
    p = c->proc;
801038d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801038d7:	e8 14 10 00 00       	call   801048f0 <popcli>
}
801038dc:	83 c4 04             	add    $0x4,%esp
801038df:	89 d8                	mov    %ebx,%eax
801038e1:	5b                   	pop    %ebx
801038e2:	5d                   	pop    %ebp
801038e3:	c3                   	ret    
801038e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038f0 <mythread>:
mythread(void) {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801038f7:	e8 b4 0f 00 00       	call   801048b0 <pushcli>
    c = mycpu();
801038fc:	e8 1f ff ff ff       	call   80103820 <mycpu>
    t = c->currThread;
80103901:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103907:	e8 e4 0f 00 00       	call   801048f0 <popcli>
}
8010390c:	83 c4 04             	add    $0x4,%esp
8010390f:	89 d8                	mov    %ebx,%eax
80103911:	5b                   	pop    %ebx
80103912:	5d                   	pop    %ebp
80103913:	c3                   	ret    
80103914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010391a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103920 <userinit>:
userinit(void) {
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
    p = allocproc();
80103925:	e8 16 fd ff ff       	call   80103640 <allocproc>
8010392a:	89 c3                	mov    %eax,%ebx
    initproc = p;
8010392c:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
    if ((p->pgdir = setupkvm()) == 0)
80103931:	e8 4a 39 00 00       	call   80107280 <setupkvm>
80103936:	85 c0                	test   %eax,%eax
80103938:	89 43 04             	mov    %eax,0x4(%ebx)
8010393b:	0f 84 35 01 00 00    	je     80103a76 <userinit+0x156>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103941:	83 ec 04             	sub    $0x4,%esp
80103944:	68 2c 00 00 00       	push   $0x2c
80103949:	68 60 a4 10 80       	push   $0x8010a460
8010394e:	50                   	push   %eax
8010394f:	e8 0c 36 00 00       	call   80106f60 <inituvm>
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
80103954:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103957:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
8010395d:	6a 4c                	push   $0x4c
8010395f:	6a 00                	push   $0x0
80103961:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103967:	ff 70 10             	pushl  0x10(%eax)
8010396a:	e8 31 11 00 00       	call   80104aa0 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010396f:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103975:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010397a:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
8010397f:	83 c4 0c             	add    $0xc,%esp
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103982:	8b 40 10             	mov    0x10(%eax),%eax
80103985:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103989:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
8010398f:	8b 40 10             	mov    0x10(%eax),%eax
80103992:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
80103996:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
8010399c:	8b 40 10             	mov    0x10(%eax),%eax
8010399f:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039a3:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
801039a7:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039ad:	8b 40 10             	mov    0x10(%eax),%eax
801039b0:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039b4:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
801039b8:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039be:	8b 40 10             	mov    0x10(%eax),%eax
801039c1:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
801039c8:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039ce:	8b 40 10             	mov    0x10(%eax),%eax
801039d1:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
801039d8:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039de:	8b 40 10             	mov    0x10(%eax),%eax
801039e1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
801039e8:	8d 43 60             	lea    0x60(%ebx),%eax
801039eb:	6a 10                	push   $0x10
801039ed:	68 d9 7a 10 80       	push   $0x80107ad9
801039f2:	50                   	push   %eax
801039f3:	e8 88 12 00 00       	call   80104c80 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
801039f8:	83 c4 0c             	add    $0xc,%esp
801039fb:	6a 10                	push   $0x10
801039fd:	68 e2 7a 10 80       	push   $0x80107ae2
80103a02:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103a08:	83 c0 24             	add    $0x24,%eax
80103a0b:	50                   	push   %eax
80103a0c:	e8 6f 12 00 00       	call   80104c80 <safestrcpy>
    p->mainThread->cwd = namei("/");
80103a11:	8b b3 f0 03 00 00    	mov    0x3f0(%ebx),%esi
80103a17:	c7 04 24 ed 7a 10 80 	movl   $0x80107aed,(%esp)
80103a1e:	e8 fd e4 ff ff       	call   80101f20 <namei>
80103a23:	89 46 20             	mov    %eax,0x20(%esi)
    acquire(&ptable.lock);
80103a26:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103a2d:	e8 4e 0f 00 00       	call   80104980 <acquire>
    p->mainThread->state = RUNNABLE;
80103a32:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
    p->state = RUNNABLE;
80103a38:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103a3f:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103a46:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103a4d:	e8 ee 0f 00 00       	call   80104a40 <release>
    if(DEBUGMODE)
80103a52:	8b 1d b8 a5 10 80    	mov    0x8010a5b8,%ebx
80103a58:	83 c4 10             	add    $0x10,%esp
80103a5b:	85 db                	test   %ebx,%ebx
80103a5d:	74 10                	je     80103a6f <userinit+0x14f>
        cprintf("DONE USERINIT");
80103a5f:	83 ec 0c             	sub    $0xc,%esp
80103a62:	68 ef 7a 10 80       	push   $0x80107aef
80103a67:	e8 f4 cb ff ff       	call   80100660 <cprintf>
80103a6c:	83 c4 10             	add    $0x10,%esp
}
80103a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a72:	5b                   	pop    %ebx
80103a73:	5e                   	pop    %esi
80103a74:	5d                   	pop    %ebp
80103a75:	c3                   	ret    
        panic("userinit: out of memory?");
80103a76:	83 ec 0c             	sub    $0xc,%esp
80103a79:	68 c0 7a 10 80       	push   $0x80107ac0
80103a7e:	e8 0d c9 ff ff       	call   80100390 <panic>
80103a83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a90 <growproc>:
growproc(int n) {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103a98:	e8 13 0e 00 00       	call   801048b0 <pushcli>
    c = mycpu();
80103a9d:	e8 7e fd ff ff       	call   80103820 <mycpu>
    p = c->proc;
80103aa2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103aa8:	e8 43 0e 00 00       	call   801048f0 <popcli>
    if(DEBUGMODE)
80103aad:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 4a                	jne    80103b00 <growproc+0x70>
    if (n > 0) {
80103ab6:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103ab9:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103abb:	7f 23                	jg     80103ae0 <growproc+0x50>
    } else if (n < 0) {
80103abd:	75 59                	jne    80103b18 <growproc+0x88>
    switchuvm(curproc);
80103abf:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103ac2:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103ac4:	53                   	push   %ebx
80103ac5:	e8 76 33 00 00       	call   80106e40 <switchuvm>
    return 0;
80103aca:	83 c4 10             	add    $0x10,%esp
80103acd:	31 c0                	xor    %eax,%eax
}
80103acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad2:	5b                   	pop    %ebx
80103ad3:	5e                   	pop    %esi
80103ad4:	5d                   	pop    %ebp
80103ad5:	c3                   	ret    
80103ad6:	8d 76 00             	lea    0x0(%esi),%esi
80103ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	pushl  0x4(%ebx)
80103aea:	e8 b1 35 00 00       	call   801070a0 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 c9                	jne    80103abf <growproc+0x2f>
            return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d2                	jmp    80103acf <growproc+0x3f>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf(" GROWPROC APPLYED ");
80103b00:	83 ec 0c             	sub    $0xc,%esp
80103b03:	68 fd 7a 10 80       	push   $0x80107afd
80103b08:	e8 53 cb ff ff       	call   80100660 <cprintf>
80103b0d:	83 c4 10             	add    $0x10,%esp
80103b10:	eb a4                	jmp    80103ab6 <growproc+0x26>
80103b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b18:	83 ec 04             	sub    $0x4,%esp
80103b1b:	01 c6                	add    %eax,%esi
80103b1d:	56                   	push   %esi
80103b1e:	50                   	push   %eax
80103b1f:	ff 73 04             	pushl  0x4(%ebx)
80103b22:	e8 a9 36 00 00       	call   801071d0 <deallocuvm>
80103b27:	83 c4 10             	add    $0x10,%esp
80103b2a:	85 c0                	test   %eax,%eax
80103b2c:	75 91                	jne    80103abf <growproc+0x2f>
80103b2e:	eb c6                	jmp    80103af6 <growproc+0x66>

80103b30 <fork>:
fork(void) {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 1c             	sub    $0x1c,%esp
    if(DEBUGMODE)
80103b39:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b3e:	85 c0                	test   %eax,%eax
80103b40:	0f 85 3a 01 00 00    	jne    80103c80 <fork+0x150>
    pushcli();
80103b46:	e8 65 0d 00 00       	call   801048b0 <pushcli>
    c = mycpu();
80103b4b:	e8 d0 fc ff ff       	call   80103820 <mycpu>
    p = c->proc;
80103b50:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
80103b56:	89 7d e0             	mov    %edi,-0x20(%ebp)
    popcli();
80103b59:	e8 92 0d 00 00       	call   801048f0 <popcli>
    pushcli();
80103b5e:	e8 4d 0d 00 00       	call   801048b0 <pushcli>
    c = mycpu();
80103b63:	e8 b8 fc ff ff       	call   80103820 <mycpu>
    t = c->currThread;
80103b68:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103b6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103b71:	e8 7a 0d 00 00       	call   801048f0 <popcli>
    if ((np = allocproc()) == 0) {
80103b76:	e8 c5 fa ff ff       	call   80103640 <allocproc>
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	89 c3                	mov    %eax,%ebx
80103b7f:	0f 84 10 01 00 00    	je     80103c95 <fork+0x165>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103b85:	83 ec 08             	sub    $0x8,%esp
80103b88:	ff 37                	pushl  (%edi)
80103b8a:	ff 77 04             	pushl  0x4(%edi)
80103b8d:	e8 be 37 00 00       	call   80107350 <copyuvm>
80103b92:	83 c4 10             	add    $0x10,%esp
80103b95:	85 c0                	test   %eax,%eax
80103b97:	89 43 04             	mov    %eax,0x4(%ebx)
80103b9a:	0f 84 fc 00 00 00    	je     80103c9c <fork+0x16c>
    np->sz = curproc->sz;
80103ba0:	8b 55 e0             	mov    -0x20(%ebp),%edx
    *np->mainThread->tf = *curthread->tf;
80103ba3:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103ba8:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103baa:	89 53 10             	mov    %edx,0x10(%ebx)
    np->sz = curproc->sz;
80103bad:	89 03                	mov    %eax,(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bb2:	8b 70 10             	mov    0x10(%eax),%esi
80103bb5:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103bbb:	8b 40 10             	mov    0x10(%eax),%eax
80103bbe:	89 c7                	mov    %eax,%edi
80103bc0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103bc2:	31 f6                	xor    %esi,%esi
80103bc4:	89 d7                	mov    %edx,%edi
    np->mainThread->tf->eax = 0;
80103bc6:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103bcc:	8b 40 10             	mov    0x10(%eax),%eax
80103bcf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103bd6:	8d 76 00             	lea    0x0(%esi),%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (curproc->ofile[i])
80103be0:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 10                	je     80103bf8 <fork+0xc8>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	50                   	push   %eax
80103bec:	e8 2f d2 ff ff       	call   80100e20 <filedup>
80103bf1:	83 c4 10             	add    $0x10,%esp
80103bf4:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103bf8:	83 c6 01             	add    $0x1,%esi
80103bfb:	83 fe 10             	cmp    $0x10,%esi
80103bfe:	75 e0                	jne    80103be0 <fork+0xb0>
    np->mainThread->cwd = idup(curthread->cwd);
80103c00:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103c03:	8b b3 f0 03 00 00    	mov    0x3f0(%ebx),%esi
80103c09:	83 ec 0c             	sub    $0xc,%esp
80103c0c:	ff 77 20             	pushl  0x20(%edi)
80103c0f:	e8 7c da ff ff       	call   80101690 <idup>
80103c14:	89 46 20             	mov    %eax,0x20(%esi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103c1a:	83 c4 0c             	add    $0xc,%esp
80103c1d:	6a 10                	push   $0x10
80103c1f:	83 c0 60             	add    $0x60,%eax
80103c22:	50                   	push   %eax
80103c23:	8d 43 60             	lea    0x60(%ebx),%eax
80103c26:	50                   	push   %eax
80103c27:	e8 54 10 00 00       	call   80104c80 <safestrcpy>
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103c2c:	8d 47 24             	lea    0x24(%edi),%eax
80103c2f:	83 c4 0c             	add    $0xc,%esp
80103c32:	6a 10                	push   $0x10
80103c34:	50                   	push   %eax
80103c35:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103c3b:	83 c0 24             	add    $0x24,%eax
80103c3e:	50                   	push   %eax
80103c3f:	e8 3c 10 00 00       	call   80104c80 <safestrcpy>
    pid = np->pid;
80103c44:	8b 73 0c             	mov    0xc(%ebx),%esi
    acquire(&ptable.lock);
80103c47:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103c4e:	e8 2d 0d 00 00       	call   80104980 <acquire>
    np->mainThread->state = RUNNABLE;
80103c53:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
    np->state = RUNNABLE;
80103c59:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    np->mainThread->state = RUNNABLE;
80103c60:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103c67:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103c6e:	e8 cd 0d 00 00       	call   80104a40 <release>
    return pid;
80103c73:	83 c4 10             	add    $0x10,%esp
}
80103c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c79:	89 f0                	mov    %esi,%eax
80103c7b:	5b                   	pop    %ebx
80103c7c:	5e                   	pop    %esi
80103c7d:	5f                   	pop    %edi
80103c7e:	5d                   	pop    %ebp
80103c7f:	c3                   	ret    
        cprintf( " FORK ");
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	68 10 7b 10 80       	push   $0x80107b10
80103c88:	e8 d3 c9 ff ff       	call   80100660 <cprintf>
80103c8d:	83 c4 10             	add    $0x10,%esp
80103c90:	e9 b1 fe ff ff       	jmp    80103b46 <fork+0x16>
        return -1;
80103c95:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103c9a:	eb da                	jmp    80103c76 <fork+0x146>
        kfree(np->mainThread->tkstack);
80103c9c:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103ca2:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103ca5:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->mainThread->tkstack);
80103caa:	ff 70 04             	pushl  0x4(%eax)
80103cad:	e8 9e e6 ff ff       	call   80102350 <kfree>
        np->mainThread->tkstack = 0;
80103cb2:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
        return -1;
80103cb8:	83 c4 10             	add    $0x10,%esp
        np->mainThread->tkstack = 0;
80103cbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->mainThread->state = UNUSED;
80103cc2:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
        np->state = UNUSED;
80103cc8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103ccf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103cd6:	eb 9e                	jmp    80103c76 <fork+0x146>
80103cd8:	90                   	nop
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <scheduler>:
scheduler(void) {
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
80103ce5:	53                   	push   %ebx
80103ce6:	83 ec 1c             	sub    $0x1c,%esp
    if(DEBUGMODE)
80103ce9:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103cee:	85 c0                	test   %eax,%eax
80103cf0:	74 10                	je     80103d02 <scheduler+0x22>
        cprintf( " SCHEDULER ");
80103cf2:	83 ec 0c             	sub    $0xc,%esp
80103cf5:	68 17 7b 10 80       	push   $0x80107b17
80103cfa:	e8 61 c9 ff ff       	call   80100660 <cprintf>
80103cff:	83 c4 10             	add    $0x10,%esp
    struct cpu *c = mycpu();
80103d02:	e8 19 fb ff ff       	call   80103820 <mycpu>
    c->proc = 0;
80103d07:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d0e:	00 00 00 
    struct cpu *c = mycpu();
80103d11:	89 c6                	mov    %eax,%esi
80103d13:	8d 40 04             	lea    0x4(%eax),%eax
80103d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103d20:	fb                   	sti    
        acquire(&ptable.lock);
80103d21:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d24:	bf 94 2d 11 80       	mov    $0x80112d94,%edi
        acquire(&ptable.lock);
80103d29:	68 60 2d 11 80       	push   $0x80112d60
80103d2e:	e8 4d 0c 00 00       	call   80104980 <acquire>
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	eb 1a                	jmp    80103d52 <scheduler+0x72>
80103d38:	90                   	nop
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d40:	81 c7 fc 03 00 00    	add    $0x3fc,%edi
80103d46:	81 ff 94 2c 12 80    	cmp    $0x80122c94,%edi
80103d4c:	0f 83 88 00 00 00    	jae    80103dda <scheduler+0xfa>
           if ( p->state != RUNNABLE )
80103d52:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d56:	75 e8                	jne    80103d40 <scheduler+0x60>
            switchuvm(p);
80103d58:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80103d5b:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
80103d61:	8d 5f 70             	lea    0x70(%edi),%ebx
            switchuvm(p);
80103d64:	57                   	push   %edi
80103d65:	e8 d6 30 00 00       	call   80106e40 <switchuvm>
80103d6a:	8d 97 f0 03 00 00    	lea    0x3f0(%edi),%edx
80103d70:	83 c4 10             	add    $0x10,%esp
80103d73:	90                   	nop
80103d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if(t->state != RUNNABLE)
80103d78:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103d7c:	75 2f                	jne    80103dad <scheduler+0xcd>
                if(t->killed != 1){
80103d7e:	83 7b 1c 01          	cmpl   $0x1,0x1c(%ebx)
80103d82:	74 29                	je     80103dad <scheduler+0xcd>
                    swtch(&(c->scheduler), t->context);
80103d84:	83 ec 08             	sub    $0x8,%esp
                    t->state = RUNNING;
80103d87:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)
                    c->currThread=t;
80103d8e:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)
                    swtch(&(c->scheduler), t->context);
80103d94:	ff 73 14             	pushl  0x14(%ebx)
80103d97:	ff 75 e0             	pushl  -0x20(%ebp)
80103d9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103d9d:	e8 39 0f 00 00       	call   80104cdb <swtch>
                    switchkvm();
80103da2:	e8 79 30 00 00       	call   80106e20 <switchkvm>
80103da7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103daa:	83 c4 10             	add    $0x10,%esp
            for (t = p->thread; t < &p->thread[NTHREADS]; t++){
80103dad:	83 c3 38             	add    $0x38,%ebx
80103db0:	39 da                	cmp    %ebx,%edx
80103db2:	77 c4                	ja     80103d78 <scheduler+0x98>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103db4:	81 c7 fc 03 00 00    	add    $0x3fc,%edi
            c->proc = 0;
80103dba:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103dc1:	00 00 00 
            c->currThread = 0;
80103dc4:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103dcb:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dce:	81 ff 94 2c 12 80    	cmp    $0x80122c94,%edi
80103dd4:	0f 82 78 ff ff ff    	jb     80103d52 <scheduler+0x72>
        release(&ptable.lock);
80103dda:	83 ec 0c             	sub    $0xc,%esp
80103ddd:	68 60 2d 11 80       	push   $0x80112d60
80103de2:	e8 59 0c 00 00       	call   80104a40 <release>
        sti();
80103de7:	83 c4 10             	add    $0x10,%esp
80103dea:	e9 31 ff ff ff       	jmp    80103d20 <scheduler+0x40>
80103def:	90                   	nop

80103df0 <sched>:
    if(DEBUGMODE)
80103df0:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
sched(void) {
80103df5:	55                   	push   %ebp
80103df6:	89 e5                	mov    %esp,%ebp
80103df8:	56                   	push   %esi
80103df9:	53                   	push   %ebx
    if(DEBUGMODE)
80103dfa:	85 c0                	test   %eax,%eax
80103dfc:	0f 85 7e 00 00 00    	jne    80103e80 <sched+0x90>
    pushcli();
80103e02:	e8 a9 0a 00 00       	call   801048b0 <pushcli>
    c = mycpu();
80103e07:	e8 14 fa ff ff       	call   80103820 <mycpu>
    t = c->currThread;
80103e0c:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103e12:	e8 d9 0a 00 00       	call   801048f0 <popcli>
    if (!holding(&ptable.lock))
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 60 2d 11 80       	push   $0x80112d60
80103e1f:	e8 2c 0b 00 00       	call   80104950 <holding>
80103e24:	83 c4 10             	add    $0x10,%esp
80103e27:	85 c0                	test   %eax,%eax
80103e29:	0f 84 8d 00 00 00    	je     80103ebc <sched+0xcc>
    if (mycpu()->ncli != 1)
80103e2f:	e8 ec f9 ff ff       	call   80103820 <mycpu>
80103e34:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e3b:	75 72                	jne    80103eaf <sched+0xbf>
    if (t->state == RUNNING)
80103e3d:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103e41:	74 5f                	je     80103ea2 <sched+0xb2>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e43:	9c                   	pushf  
80103e44:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103e45:	f6 c4 02             	test   $0x2,%ah
80103e48:	75 4b                	jne    80103e95 <sched+0xa5>
    intena = mycpu()->intena;
80103e4a:	e8 d1 f9 ff ff       	call   80103820 <mycpu>
    swtch(&t->context, mycpu()->scheduler);
80103e4f:	83 c3 14             	add    $0x14,%ebx
    intena = mycpu()->intena;
80103e52:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&t->context, mycpu()->scheduler);
80103e58:	e8 c3 f9 ff ff       	call   80103820 <mycpu>
80103e5d:	83 ec 08             	sub    $0x8,%esp
80103e60:	ff 70 04             	pushl  0x4(%eax)
80103e63:	53                   	push   %ebx
80103e64:	e8 72 0e 00 00       	call   80104cdb <swtch>
    mycpu()->intena = intena;
80103e69:	e8 b2 f9 ff ff       	call   80103820 <mycpu>
}
80103e6e:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80103e71:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e7a:	5b                   	pop    %ebx
80103e7b:	5e                   	pop    %esi
80103e7c:	5d                   	pop    %ebp
80103e7d:	c3                   	ret    
80103e7e:	66 90                	xchg   %ax,%ax
        cprintf( " SCHED ");
80103e80:	83 ec 0c             	sub    $0xc,%esp
80103e83:	68 23 7b 10 80       	push   $0x80107b23
80103e88:	e8 d3 c7 ff ff       	call   80100660 <cprintf>
80103e8d:	83 c4 10             	add    $0x10,%esp
80103e90:	e9 6d ff ff ff       	jmp    80103e02 <sched+0x12>
        panic("sched interruptible");
80103e95:	83 ec 0c             	sub    $0xc,%esp
80103e98:	68 57 7b 10 80       	push   $0x80107b57
80103e9d:	e8 ee c4 ff ff       	call   80100390 <panic>
        panic("sched running");
80103ea2:	83 ec 0c             	sub    $0xc,%esp
80103ea5:	68 49 7b 10 80       	push   $0x80107b49
80103eaa:	e8 e1 c4 ff ff       	call   80100390 <panic>
        panic("sched locks");
80103eaf:	83 ec 0c             	sub    $0xc,%esp
80103eb2:	68 3d 7b 10 80       	push   $0x80107b3d
80103eb7:	e8 d4 c4 ff ff       	call   80100390 <panic>
        panic("sched ptable.lock");
80103ebc:	83 ec 0c             	sub    $0xc,%esp
80103ebf:	68 2b 7b 10 80       	push   $0x80107b2b
80103ec4:	e8 c7 c4 ff ff       	call   80100390 <panic>
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <yield>:
yield(void) {
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
80103ed4:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103ed7:	68 60 2d 11 80       	push   $0x80112d60
80103edc:	e8 9f 0a 00 00       	call   80104980 <acquire>
    pushcli();
80103ee1:	e8 ca 09 00 00       	call   801048b0 <pushcli>
    c = mycpu();
80103ee6:	e8 35 f9 ff ff       	call   80103820 <mycpu>
    t = c->currThread;
80103eeb:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103ef1:	e8 fa 09 00 00       	call   801048f0 <popcli>
    mythread()->state = RUNNABLE;
80103ef6:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103efd:	e8 ee fe ff ff       	call   80103df0 <sched>
    release(&ptable.lock);
80103f02:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103f09:	e8 32 0b 00 00       	call   80104a40 <release>
}
80103f0e:	83 c4 10             	add    $0x10,%esp
80103f11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f14:	c9                   	leave  
80103f15:	c3                   	ret    
80103f16:	8d 76 00             	lea    0x0(%esi),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 1c             	sub    $0x1c,%esp
    if(DEBUGMODE)
80103f29:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
sleep(void *chan, struct spinlock *lk) {
80103f2e:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if(DEBUGMODE)
80103f34:	85 c0                	test   %eax,%eax
80103f36:	0f 85 b4 00 00 00    	jne    80103ff0 <sleep+0xd0>
    pushcli();
80103f3c:	e8 6f 09 00 00       	call   801048b0 <pushcli>
    c = mycpu();
80103f41:	e8 da f8 ff ff       	call   80103820 <mycpu>
    p = c->proc;
80103f46:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103f4c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103f4f:	e8 9c 09 00 00       	call   801048f0 <popcli>
    pushcli();
80103f54:	e8 57 09 00 00       	call   801048b0 <pushcli>
    c = mycpu();
80103f59:	e8 c2 f8 ff ff       	call   80103820 <mycpu>
    t = c->currThread;
80103f5e:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103f64:	e8 87 09 00 00       	call   801048f0 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103f69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f6c:	85 d2                	test   %edx,%edx
80103f6e:	0f 84 9e 00 00 00    	je     80104012 <sleep+0xf2>
        panic("sleep");

    if (lk == 0)
80103f74:	85 db                	test   %ebx,%ebx
80103f76:	0f 84 89 00 00 00    	je     80104005 <sleep+0xe5>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if( lk != &ptable.lock ){
80103f7c:	81 fb 60 2d 11 80    	cmp    $0x80112d60,%ebx
80103f82:	74 4c                	je     80103fd0 <sleep+0xb0>
        acquire(&ptable.lock );
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 60 2d 11 80       	push   $0x80112d60
80103f8c:	e8 ef 09 00 00       	call   80104980 <acquire>
        release(lk);
80103f91:	89 1c 24             	mov    %ebx,(%esp)
80103f94:	e8 a7 0a 00 00       	call   80104a40 <release>
    }
     // Go to sleep.
    t->chan = chan;
80103f99:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103f9c:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103fa3:	e8 48 fe ff ff       	call   80103df0 <sched>

    // Tidy up.
    t->chan = 0;
80103fa8:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80103faf:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103fb6:	e8 85 0a 00 00       	call   80104a40 <release>
        acquire(lk);
80103fbb:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103fbe:	83 c4 10             	add    $0x10,%esp
    }
}
80103fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc4:	5b                   	pop    %ebx
80103fc5:	5e                   	pop    %esi
80103fc6:	5f                   	pop    %edi
80103fc7:	5d                   	pop    %ebp
        acquire(lk);
80103fc8:	e9 b3 09 00 00       	jmp    80104980 <acquire>
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi
    t->chan = chan;
80103fd0:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103fd3:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)
    sched();
80103fda:	e8 11 fe ff ff       	call   80103df0 <sched>
    t->chan = 0;
80103fdf:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
}
80103fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe9:	5b                   	pop    %ebx
80103fea:	5e                   	pop    %esi
80103feb:	5f                   	pop    %edi
80103fec:	5d                   	pop    %ebp
80103fed:	c3                   	ret    
80103fee:	66 90                	xchg   %ax,%ax
        cprintf( " SLEEP ");
80103ff0:	83 ec 0c             	sub    $0xc,%esp
80103ff3:	68 6b 7b 10 80       	push   $0x80107b6b
80103ff8:	e8 63 c6 ff ff       	call   80100660 <cprintf>
80103ffd:	83 c4 10             	add    $0x10,%esp
80104000:	e9 37 ff ff ff       	jmp    80103f3c <sleep+0x1c>
        panic("sleep without lk");
80104005:	83 ec 0c             	sub    $0xc,%esp
80104008:	68 79 7b 10 80       	push   $0x80107b79
8010400d:	e8 7e c3 ff ff       	call   80100390 <panic>
        panic("sleep");
80104012:	83 ec 0c             	sub    $0xc,%esp
80104015:	68 73 7b 10 80       	push   $0x80107b73
8010401a:	e8 71 c3 ff ff       	call   80100390 <panic>
8010401f:	90                   	nop

80104020 <cleanProcOneThread>:
cleanProcOneThread(struct thread *curthread, struct proc *p){
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 18             	sub    $0x18,%esp
80104029:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010402c:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&ptable.lock);
8010402f:	68 60 2d 11 80       	push   $0x80112d60
    for (t = p->thread; t < &p->thread[NTHREADS]; t++){
80104034:	8d 5f 70             	lea    0x70(%edi),%ebx
80104037:	81 c7 f0 03 00 00    	add    $0x3f0,%edi
    acquire(&ptable.lock);
8010403d:	e8 3e 09 00 00       	call   80104980 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++){
80104042:	83 c4 10             	add    $0x10,%esp
80104045:	eb 10                	jmp    80104057 <cleanProcOneThread+0x37>
80104047:	89 f6                	mov    %esi,%esi
80104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104050:	83 c3 38             	add    $0x38,%ebx
80104053:	39 fb                	cmp    %edi,%ebx
80104055:	73 49                	jae    801040a0 <cleanProcOneThread+0x80>
        if(t != curthread){
80104057:	39 de                	cmp    %ebx,%esi
80104059:	74 f5                	je     80104050 <cleanProcOneThread+0x30>
            if(t->state ==RUNNING)
8010405b:	8b 43 08             	mov    0x8(%ebx),%eax
8010405e:	83 f8 04             	cmp    $0x4,%eax
80104061:	74 55                	je     801040b8 <cleanProcOneThread+0x98>
            if(t->state == RUNNING || t->state == RUNNABLE){
80104063:	83 e8 03             	sub    $0x3,%eax
80104066:	83 f8 01             	cmp    $0x1,%eax
80104069:	77 e5                	ja     80104050 <cleanProcOneThread+0x30>
                kfree(t->tkstack);
8010406b:	83 ec 0c             	sub    $0xc,%esp
8010406e:	ff 73 04             	pushl  0x4(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++){
80104071:	83 c3 38             	add    $0x38,%ebx
                kfree(t->tkstack);
80104074:	e8 d7 e2 ff ff       	call   80102350 <kfree>
                t->tkstack = 0;
80104079:	c7 43 cc 00 00 00 00 	movl   $0x0,-0x34(%ebx)
                t->state=UNUSED;
80104080:	c7 43 d0 00 00 00 00 	movl   $0x0,-0x30(%ebx)
                t->killed=0;
80104087:	83 c4 10             	add    $0x10,%esp
                t->tid=0;
8010408a:	c7 43 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebx)
                t->name[0] = 0;
80104091:	c6 43 ec 00          	movb   $0x0,-0x14(%ebx)
                t->killed=0;
80104095:	c7 43 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++){
8010409c:	39 fb                	cmp    %edi,%ebx
8010409e:	72 b7                	jb     80104057 <cleanProcOneThread+0x37>
    release(&ptable.lock);
801040a0:	c7 45 08 60 2d 11 80 	movl   $0x80112d60,0x8(%ebp)
}
801040a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040aa:	5b                   	pop    %ebx
801040ab:	5e                   	pop    %esi
801040ac:	5f                   	pop    %edi
801040ad:	5d                   	pop    %ebp
    release(&ptable.lock);
801040ae:	e9 8d 09 00 00       	jmp    80104a40 <release>
801040b3:	90                   	nop
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                sleep( t , &ptable.lock );
801040b8:	83 ec 08             	sub    $0x8,%esp
801040bb:	68 60 2d 11 80       	push   $0x80112d60
801040c0:	53                   	push   %ebx
801040c1:	e8 5a fe ff ff       	call   80103f20 <sleep>
801040c6:	8b 43 08             	mov    0x8(%ebx),%eax
801040c9:	83 c4 10             	add    $0x10,%esp
801040cc:	eb 95                	jmp    80104063 <cleanProcOneThread+0x43>
801040ce:	66 90                	xchg   %ax,%ax

801040d0 <exit>:
exit(void) {
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	57                   	push   %edi
801040d4:	56                   	push   %esi
801040d5:	53                   	push   %ebx
801040d6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
801040d9:	e8 d2 07 00 00       	call   801048b0 <pushcli>
    c = mycpu();
801040de:	e8 3d f7 ff ff       	call   80103820 <mycpu>
    p = c->proc;
801040e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801040e9:	e8 02 08 00 00       	call   801048f0 <popcli>
    pushcli();
801040ee:	e8 bd 07 00 00       	call   801048b0 <pushcli>
    c = mycpu();
801040f3:	e8 28 f7 ff ff       	call   80103820 <mycpu>
    t = c->currThread;
801040f8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801040fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80104101:	e8 ea 07 00 00       	call   801048f0 <popcli>
    if(DEBUGMODE)
80104106:	8b 15 b8 a5 10 80    	mov    0x8010a5b8,%edx
8010410c:	85 d2                	test   %edx,%edx
8010410e:	74 10                	je     80104120 <exit+0x50>
        cprintf("EXIT");
80104110:	83 ec 0c             	sub    $0xc,%esp
80104113:	68 8a 7b 10 80       	push   $0x80107b8a
80104118:	e8 43 c5 ff ff       	call   80100660 <cprintf>
8010411d:	83 c4 10             	add    $0x10,%esp
    if (curproc == initproc)
80104120:	39 35 bc a5 10 80    	cmp    %esi,0x8010a5bc
80104126:	0f 84 fc 01 00 00    	je     80104328 <exit+0x258>
    acquire(&ptable.lock);
8010412c:	83 ec 0c             	sub    $0xc,%esp
    curproc->exited=1;
8010412f:	c7 86 f8 03 00 00 01 	movl   $0x1,0x3f8(%esi)
80104136:	00 00 00 
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80104139:	8d 5e 70             	lea    0x70(%esi),%ebx
    acquire(&ptable.lock);
8010413c:	68 60 2d 11 80       	push   $0x80112d60
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80104141:	8d be f0 03 00 00    	lea    0x3f0(%esi),%edi
    acquire(&ptable.lock);
80104147:	e8 34 08 00 00       	call   80104980 <acquire>
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
8010414c:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010414f:	83 c4 10             	add    $0x10,%esp
80104152:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104155:	eb 12                	jmp    80104169 <exit+0x99>
            if(t->state != UNUSED)
80104157:	85 c0                	test   %eax,%eax
80104159:	74 07                	je     80104162 <exit+0x92>
                t->state = ZOMBIE;
8010415b:	c7 43 08 05 00 00 00 	movl   $0x5,0x8(%ebx)
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80104162:	83 c3 38             	add    $0x38,%ebx
80104165:	39 fb                	cmp    %edi,%ebx
80104167:	73 36                	jae    8010419f <exit+0xcf>
        if(t != curthread) {
80104169:	39 de                	cmp    %ebx,%esi
8010416b:	74 f5                	je     80104162 <exit+0x92>
            if(t->state == RUNNING) {
8010416d:	8b 43 08             	mov    0x8(%ebx),%eax
            t->killed = 1;
80104170:	c7 43 1c 01 00 00 00 	movl   $0x1,0x1c(%ebx)
            if(t->state == RUNNING) {
80104177:	83 f8 04             	cmp    $0x4,%eax
8010417a:	75 db                	jne    80104157 <exit+0x87>
                if(DEBUGMODE)
8010417c:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80104181:	85 c0                	test   %eax,%eax
80104183:	0f 85 8a 01 00 00    	jne    80104313 <exit+0x243>
                sleep( t , &ptable.lock );
80104189:	83 ec 08             	sub    $0x8,%esp
8010418c:	68 60 2d 11 80       	push   $0x80112d60
80104191:	53                   	push   %ebx
80104192:	e8 89 fd ff ff       	call   80103f20 <sleep>
80104197:	8b 43 08             	mov    0x8(%ebx),%eax
8010419a:	83 c4 10             	add    $0x10,%esp
8010419d:	eb b8                	jmp    80104157 <exit+0x87>
8010419f:	8b 75 e0             	mov    -0x20(%ebp),%esi
801041a2:	8d 7e 20             	lea    0x20(%esi),%edi
801041a5:	8d 5e 60             	lea    0x60(%esi),%ebx
801041a8:	90                   	nop
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[fd]) {
801041b0:	8b 07                	mov    (%edi),%eax
801041b2:	85 c0                	test   %eax,%eax
801041b4:	74 12                	je     801041c8 <exit+0xf8>
            fileclose(curproc->ofile[fd]);
801041b6:	83 ec 0c             	sub    $0xc,%esp
801041b9:	50                   	push   %eax
801041ba:	e8 b1 cc ff ff       	call   80100e70 <fileclose>
            curproc->ofile[fd] = 0;
801041bf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801041c5:	83 c4 10             	add    $0x10,%esp
801041c8:	83 c7 04             	add    $0x4,%edi
    for (fd = 0; fd < NOFILE; fd++) {
801041cb:	39 fb                	cmp    %edi,%ebx
801041cd:	75 e1                	jne    801041b0 <exit+0xe0>
    if(holding(&ptable.lock))
801041cf:	83 ec 0c             	sub    $0xc,%esp
801041d2:	68 60 2d 11 80       	push   $0x80112d60
801041d7:	e8 74 07 00 00       	call   80104950 <holding>
801041dc:	83 c4 10             	add    $0x10,%esp
801041df:	85 c0                	test   %eax,%eax
801041e1:	0f 85 17 01 00 00    	jne    801042fe <exit+0x22e>
    begin_op();
801041e7:	e8 f4 e9 ff ff       	call   80102be0 <begin_op>
    iput(curthread->cwd);
801041ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801041ef:	83 ec 0c             	sub    $0xc,%esp
801041f2:	ff 77 20             	pushl  0x20(%edi)
801041f5:	e8 f6 d5 ff ff       	call   801017f0 <iput>
    end_op();
801041fa:	e8 51 ea ff ff       	call   80102c50 <end_op>
    curthread->cwd = 0;
801041ff:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)
    acquire(&ptable.lock);
80104206:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
8010420d:	e8 6e 07 00 00       	call   80104980 <acquire>
    wakeup1(curproc->parent);
80104212:	8b 5e 10             	mov    0x10(%esi),%ebx
80104215:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct  thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104218:	ba 94 2d 11 80       	mov    $0x80112d94,%edx
8010421d:	eb 0f                	jmp    8010422e <exit+0x15e>
8010421f:	90                   	nop
80104220:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
80104226:	81 fa 94 2c 12 80    	cmp    $0x80122c94,%edx
8010422c:	73 2d                	jae    8010425b <exit+0x18b>
        if( p->state != RUNNABLE )
8010422e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104232:	75 ec                	jne    80104220 <exit+0x150>
80104234:	8d 42 70             	lea    0x70(%edx),%eax
80104237:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
8010423d:	eb 08                	jmp    80104247 <exit+0x177>
8010423f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for ( t = p->thread ; t < &p->thread[NTHREADS]; t++) {
80104240:	83 c0 38             	add    $0x38,%eax
80104243:	39 c1                	cmp    %eax,%ecx
80104245:	76 d9                	jbe    80104220 <exit+0x150>
            if (t->state == SLEEPING && t->chan == chan)
80104247:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010424b:	75 f3                	jne    80104240 <exit+0x170>
8010424d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104250:	75 ee                	jne    80104240 <exit+0x170>
                t->state = RUNNABLE;
80104252:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104259:	eb e5                	jmp    80104240 <exit+0x170>
            p->parent = initproc;
8010425b:	8b 3d bc a5 10 80    	mov    0x8010a5bc,%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104261:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
80104266:	eb 16                	jmp    8010427e <exit+0x1ae>
80104268:	90                   	nop
80104269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104270:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
80104276:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
8010427c:	73 5d                	jae    801042db <exit+0x20b>
        if (p->parent == curproc) {
8010427e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104281:	75 ed                	jne    80104270 <exit+0x1a0>
            if (p->state == ZOMBIE)
80104283:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
            p->parent = initproc;
80104287:	89 7b 10             	mov    %edi,0x10(%ebx)
            if (p->state == ZOMBIE)
8010428a:	75 e4                	jne    80104270 <exit+0x1a0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010428c:	ba 94 2d 11 80       	mov    $0x80112d94,%edx
80104291:	eb 13                	jmp    801042a6 <exit+0x1d6>
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104298:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
8010429e:	81 fa 94 2c 12 80    	cmp    $0x80122c94,%edx
801042a4:	73 ca                	jae    80104270 <exit+0x1a0>
        if( p->state != RUNNABLE )
801042a6:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801042aa:	75 ec                	jne    80104298 <exit+0x1c8>
801042ac:	8d 42 70             	lea    0x70(%edx),%eax
801042af:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
801042b5:	eb 10                	jmp    801042c7 <exit+0x1f7>
801042b7:	89 f6                	mov    %esi,%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for ( t = p->thread ; t < &p->thread[NTHREADS]; t++) {
801042c0:	83 c0 38             	add    $0x38,%eax
801042c3:	39 c1                	cmp    %eax,%ecx
801042c5:	76 d1                	jbe    80104298 <exit+0x1c8>
            if (t->state == SLEEPING && t->chan == chan)
801042c7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801042cb:	75 f3                	jne    801042c0 <exit+0x1f0>
801042cd:	3b 78 18             	cmp    0x18(%eax),%edi
801042d0:	75 ee                	jne    801042c0 <exit+0x1f0>
                t->state = RUNNABLE;
801042d2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801042d9:	eb e5                	jmp    801042c0 <exit+0x1f0>
    curthread->state = ZOMBIE;
801042db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801042de:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    curproc->state = ZOMBIE;
801042e5:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
801042ec:	e8 ff fa ff ff       	call   80103df0 <sched>
    panic("zombie exit");
801042f1:	83 ec 0c             	sub    $0xc,%esp
801042f4:	68 ae 7b 10 80       	push   $0x80107bae
801042f9:	e8 92 c0 ff ff       	call   80100390 <panic>
        release(&ptable.lock);
801042fe:	83 ec 0c             	sub    $0xc,%esp
80104301:	68 60 2d 11 80       	push   $0x80112d60
80104306:	e8 35 07 00 00       	call   80104a40 <release>
8010430b:	83 c4 10             	add    $0x10,%esp
8010430e:	e9 d4 fe ff ff       	jmp    801041e7 <exit+0x117>
                    cprintf("WAITING IN EXIT  ");
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	68 9c 7b 10 80       	push   $0x80107b9c
8010431b:	e8 40 c3 ff ff       	call   80100660 <cprintf>
80104320:	83 c4 10             	add    $0x10,%esp
80104323:	e9 61 fe ff ff       	jmp    80104189 <exit+0xb9>
        panic("init exiting");
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 8f 7b 10 80       	push   $0x80107b8f
80104330:	e8 5b c0 ff ff       	call   80100390 <panic>
80104335:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104340 <wait>:
wait(void) {
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 1c             	sub    $0x1c,%esp
    if(DEBUGMODE)
80104349:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
8010434f:	85 c9                	test   %ecx,%ecx
80104351:	0f 85 39 01 00 00    	jne    80104490 <wait+0x150>
    pushcli();
80104357:	e8 54 05 00 00       	call   801048b0 <pushcli>
    c = mycpu();
8010435c:	e8 bf f4 ff ff       	call   80103820 <mycpu>
    p = c->proc;
80104361:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104367:	e8 84 05 00 00       	call   801048f0 <popcli>
    acquire(&ptable.lock);
8010436c:	83 ec 0c             	sub    $0xc,%esp
8010436f:	68 60 2d 11 80       	push   $0x80112d60
80104374:	e8 07 06 00 00       	call   80104980 <acquire>
80104379:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
8010437c:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010437e:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
80104383:	eb 11                	jmp    80104396 <wait+0x56>
80104385:	8d 76 00             	lea    0x0(%esi),%esi
80104388:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
8010438e:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
80104394:	73 1e                	jae    801043b4 <wait+0x74>
            if (p->parent != curproc)
80104396:	39 73 10             	cmp    %esi,0x10(%ebx)
80104399:	75 ed                	jne    80104388 <wait+0x48>
            if (p->state == ZOMBIE) {
8010439b:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
8010439f:	74 4f                	je     801043f0 <wait+0xb0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043a1:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
            havekids = 1;
801043a7:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043ac:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
801043b2:	72 e2                	jb     80104396 <wait+0x56>
        if (!havekids || curproc->killed) {
801043b4:	85 c0                	test   %eax,%eax
801043b6:	0f 84 e9 00 00 00    	je     801044a5 <wait+0x165>
801043bc:	8b 46 1c             	mov    0x1c(%esi),%eax
801043bf:	85 c0                	test   %eax,%eax
801043c1:	0f 85 de 00 00 00    	jne    801044a5 <wait+0x165>
    pushcli();
801043c7:	e8 e4 04 00 00       	call   801048b0 <pushcli>
    c = mycpu();
801043cc:	e8 4f f4 ff ff       	call   80103820 <mycpu>
    t = c->currThread;
801043d1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801043d7:	e8 14 05 00 00       	call   801048f0 <popcli>
        sleep(mythread(), &ptable.lock );  //DOC: wait-sleep
801043dc:	83 ec 08             	sub    $0x8,%esp
801043df:	68 60 2d 11 80       	push   $0x80112d60
801043e4:	53                   	push   %ebx
801043e5:	e8 36 fb ff ff       	call   80103f20 <sleep>
        havekids = 0;
801043ea:	83 c4 10             	add    $0x10,%esp
801043ed:	eb 8d                	jmp    8010437c <wait+0x3c>
801043ef:	90                   	nop
                pid = p->pid;
801043f0:	8b 43 0c             	mov    0xc(%ebx),%eax
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043f3:	8d 73 70             	lea    0x70(%ebx),%esi
801043f6:	8d bb f0 03 00 00    	lea    0x3f0(%ebx),%edi
                pid = p->pid;
801043fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043ff:	eb 0e                	jmp    8010440f <wait+0xcf>
80104401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104408:	83 c6 38             	add    $0x38,%esi
8010440b:	39 f7                	cmp    %esi,%edi
8010440d:	76 3c                	jbe    8010444b <wait+0x10b>
                    if(t->state != UNUSED){
8010440f:	8b 56 08             	mov    0x8(%esi),%edx
80104412:	85 d2                	test   %edx,%edx
80104414:	74 f2                	je     80104408 <wait+0xc8>
                        kfree(t->tkstack);
80104416:	83 ec 0c             	sub    $0xc,%esp
80104419:	ff 76 04             	pushl  0x4(%esi)
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010441c:	83 c6 38             	add    $0x38,%esi
                        kfree(t->tkstack);
8010441f:	e8 2c df ff ff       	call   80102350 <kfree>
                        t->tkstack = 0;
80104424:	c7 46 cc 00 00 00 00 	movl   $0x0,-0x34(%esi)
                        t->state=UNUSED;
8010442b:	c7 46 d0 00 00 00 00 	movl   $0x0,-0x30(%esi)
                        t->killed=0;
80104432:	83 c4 10             	add    $0x10,%esp
                        t->tid=0;
80104435:	c7 46 d4 00 00 00 00 	movl   $0x0,-0x2c(%esi)
                        t->name[0] = 0;
8010443c:	c6 46 ec 00          	movb   $0x0,-0x14(%esi)
                        t->killed=0;
80104440:	c7 46 e4 00 00 00 00 	movl   $0x0,-0x1c(%esi)
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104447:	39 f7                	cmp    %esi,%edi
80104449:	77 c4                	ja     8010440f <wait+0xcf>
                freevm(p->pgdir);
8010444b:	83 ec 0c             	sub    $0xc,%esp
8010444e:	ff 73 04             	pushl  0x4(%ebx)
80104451:	e8 aa 2d 00 00       	call   80107200 <freevm>
                p->pid = 0;
80104456:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
8010445d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
80104464:	c6 43 60 00          	movb   $0x0,0x60(%ebx)
                p->killed = 0;
80104468:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
8010446f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
80104476:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
8010447d:	e8 be 05 00 00       	call   80104a40 <release>
                return pid;
80104482:	83 c4 10             	add    $0x10,%esp
}
80104485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104488:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010448b:	5b                   	pop    %ebx
8010448c:	5e                   	pop    %esi
8010448d:	5f                   	pop    %edi
8010448e:	5d                   	pop    %ebp
8010448f:	c3                   	ret    
        cprintf( " WAIT ");
80104490:	83 ec 0c             	sub    $0xc,%esp
80104493:	68 ba 7b 10 80       	push   $0x80107bba
80104498:	e8 c3 c1 ff ff       	call   80100660 <cprintf>
8010449d:	83 c4 10             	add    $0x10,%esp
801044a0:	e9 b2 fe ff ff       	jmp    80104357 <wait+0x17>
            release(&ptable.lock);
801044a5:	83 ec 0c             	sub    $0xc,%esp
801044a8:	68 60 2d 11 80       	push   $0x80112d60
801044ad:	e8 8e 05 00 00       	call   80104a40 <release>
            return -1;
801044b2:	83 c4 10             	add    $0x10,%esp
801044b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
801044bc:	eb c7                	jmp    80104485 <wait+0x145>
801044be:	66 90                	xchg   %ax,%ax

801044c0 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 04             	sub    $0x4,%esp
    if(DEBUGMODE)
801044c7:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
wakeup(void *chan) {
801044cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(DEBUGMODE)
801044cf:	85 c0                	test   %eax,%eax
801044d1:	75 68                	jne    8010453b <wakeup+0x7b>
        cprintf( " WAKEUP ");
    acquire(&ptable.lock);
801044d3:	83 ec 0c             	sub    $0xc,%esp
801044d6:	68 60 2d 11 80       	push   $0x80112d60
801044db:	e8 a0 04 00 00       	call   80104980 <acquire>
801044e0:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044e3:	ba 94 2d 11 80       	mov    $0x80112d94,%edx
801044e8:	eb 14                	jmp    801044fe <wakeup+0x3e>
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044f0:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
801044f6:	81 fa 94 2c 12 80    	cmp    $0x80122c94,%edx
801044fc:	73 2d                	jae    8010452b <wakeup+0x6b>
        if( p->state != RUNNABLE )
801044fe:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104502:	75 ec                	jne    801044f0 <wakeup+0x30>
80104504:	8d 42 70             	lea    0x70(%edx),%eax
80104507:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
8010450d:	eb 08                	jmp    80104517 <wakeup+0x57>
8010450f:	90                   	nop
        for ( t = p->thread ; t < &p->thread[NTHREADS]; t++) {
80104510:	83 c0 38             	add    $0x38,%eax
80104513:	39 c1                	cmp    %eax,%ecx
80104515:	76 d9                	jbe    801044f0 <wakeup+0x30>
            if (t->state == SLEEPING && t->chan == chan)
80104517:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010451b:	75 f3                	jne    80104510 <wakeup+0x50>
8010451d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104520:	75 ee                	jne    80104510 <wakeup+0x50>
                t->state = RUNNABLE;
80104522:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104529:	eb e5                	jmp    80104510 <wakeup+0x50>
    wakeup1(chan);
    release(&ptable.lock);
8010452b:	c7 45 08 60 2d 11 80 	movl   $0x80112d60,0x8(%ebp)
}
80104532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104535:	c9                   	leave  
    release(&ptable.lock);
80104536:	e9 05 05 00 00       	jmp    80104a40 <release>
        cprintf( " WAKEUP ");
8010453b:	83 ec 0c             	sub    $0xc,%esp
8010453e:	68 c1 7b 10 80       	push   $0x80107bc1
80104543:	e8 18 c1 ff ff       	call   80100660 <cprintf>
80104548:	83 c4 10             	add    $0x10,%esp
8010454b:	eb 86                	jmp    801044d3 <wakeup+0x13>
8010454d:	8d 76 00             	lea    0x0(%esi),%esi

80104550 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 04             	sub    $0x4,%esp
    if(DEBUGMODE)
80104557:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
kill(int pid) {
8010455c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(DEBUGMODE)
8010455f:	85 c0                	test   %eax,%eax
80104561:	0f 85 89 00 00 00    	jne    801045f0 <kill+0xa0>
        cprintf( " KILL ");
    struct proc *p;
    struct  thread *t;
    acquire(&ptable.lock);
80104567:	83 ec 0c             	sub    $0xc,%esp
8010456a:	68 60 2d 11 80       	push   $0x80112d60
8010456f:	e8 0c 04 00 00       	call   80104980 <acquire>
80104574:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104577:	b8 94 2d 11 80       	mov    $0x80112d94,%eax
8010457c:	eb 0e                	jmp    8010458c <kill+0x3c>
8010457e:	66 90                	xchg   %ax,%ax
80104580:	05 fc 03 00 00       	add    $0x3fc,%eax
80104585:	3d 94 2c 12 80       	cmp    $0x80122c94,%eax
8010458a:	73 7c                	jae    80104608 <kill+0xb8>
        if (p->pid == pid) {
8010458c:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010458f:	75 ef                	jne    80104580 <kill+0x30>
            p->killed = 1;
            //turn on killed flags of the proc threads
            for ( t = p->thread ; t < &p->thread[NTHREADS]; t++)
80104591:	8d 50 70             	lea    0x70(%eax),%edx
80104594:	8d 88 f0 03 00 00    	lea    0x3f0(%eax),%ecx
            p->killed = 1;
8010459a:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
801045a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                t->killed=1;
801045a8:	c7 42 1c 01 00 00 00 	movl   $0x1,0x1c(%edx)
            for ( t = p->thread ; t < &p->thread[NTHREADS]; t++)
801045af:	83 c2 38             	add    $0x38,%edx
801045b2:	39 d1                	cmp    %edx,%ecx
801045b4:	77 f2                	ja     801045a8 <kill+0x58>
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING){
801045b6:	8b 90 f0 03 00 00    	mov    0x3f0(%eax),%edx
801045bc:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
801045c0:	75 14                	jne    801045d6 <kill+0x86>
                p->mainThread->state = RUNNABLE;
801045c2:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
                p->mainThread->killed=0; //turn off this flag so that the main thread will exit the proc
801045c9:	8b 80 f0 03 00 00    	mov    0x3f0(%eax),%eax
801045cf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
            }

            //release( p->procLock );
            release(&ptable.lock);
801045d6:	83 ec 0c             	sub    $0xc,%esp
801045d9:	68 60 2d 11 80       	push   $0x80112d60
801045de:	e8 5d 04 00 00       	call   80104a40 <release>
            return 0;
801045e3:	83 c4 10             	add    $0x10,%esp
801045e6:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801045e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045eb:	c9                   	leave  
801045ec:	c3                   	ret    
801045ed:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf( " KILL ");
801045f0:	83 ec 0c             	sub    $0xc,%esp
801045f3:	68 ca 7b 10 80       	push   $0x80107bca
801045f8:	e8 63 c0 ff ff       	call   80100660 <cprintf>
801045fd:	83 c4 10             	add    $0x10,%esp
80104600:	e9 62 ff ff ff       	jmp    80104567 <kill+0x17>
80104605:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104608:	83 ec 0c             	sub    $0xc,%esp
8010460b:	68 60 2d 11 80       	push   $0x80112d60
80104610:	e8 2b 04 00 00       	call   80104a40 <release>
    return -1;
80104615:	83 c4 10             	add    $0x10,%esp
80104618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010461d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104620:	c9                   	leave  
80104621:	c3                   	ret    
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	57                   	push   %edi
80104634:	56                   	push   %esi
80104635:	53                   	push   %ebx
80104636:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104639:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
procdump(void) {
8010463e:	83 ec 3c             	sub    $0x3c,%esp
80104641:	eb 27                	jmp    8010466a <procdump+0x3a>
80104643:	90                   	nop
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 b1 75 10 80       	push   $0x801075b1
80104650:	e8 0b c0 ff ff       	call   80100660 <cprintf>
80104655:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104658:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
8010465e:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
80104664:	0f 83 96 00 00 00    	jae    80104700 <procdump+0xd0>
        if (p->state == UNUSED)
8010466a:	8b 43 08             	mov    0x8(%ebx),%eax
8010466d:	85 c0                	test   %eax,%eax
8010466f:	74 e7                	je     80104658 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104671:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104674:	ba d1 7b 10 80       	mov    $0x80107bd1,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104679:	77 11                	ja     8010468c <procdump+0x5c>
8010467b:	8b 14 85 30 7c 10 80 	mov    -0x7fef83d0(,%eax,4),%edx
            state = "???";
80104682:	b8 d1 7b 10 80       	mov    $0x80107bd1,%eax
80104687:	85 d2                	test   %edx,%edx
80104689:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010468c:	8d 43 60             	lea    0x60(%ebx),%eax
8010468f:	50                   	push   %eax
80104690:	52                   	push   %edx
80104691:	ff 73 0c             	pushl  0xc(%ebx)
80104694:	68 d5 7b 10 80       	push   $0x80107bd5
80104699:	e8 c2 bf ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
8010469e:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801046a4:	83 c4 10             	add    $0x10,%esp
801046a7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801046ab:	75 9b                	jne    80104648 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
801046ad:	8d 4d c0             	lea    -0x40(%ebp),%ecx
801046b0:	83 ec 08             	sub    $0x8,%esp
801046b3:	8d 7d c0             	lea    -0x40(%ebp),%edi
801046b6:	51                   	push   %ecx
801046b7:	8b 40 14             	mov    0x14(%eax),%eax
801046ba:	8b 40 0c             	mov    0xc(%eax),%eax
801046bd:	83 c0 08             	add    $0x8,%eax
801046c0:	50                   	push   %eax
801046c1:	e8 9a 01 00 00       	call   80104860 <getcallerpcs>
801046c6:	83 c4 10             	add    $0x10,%esp
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801046d0:	8b 17                	mov    (%edi),%edx
801046d2:	85 d2                	test   %edx,%edx
801046d4:	0f 84 6e ff ff ff    	je     80104648 <procdump+0x18>
                cprintf(" %p", pc[i]);
801046da:	83 ec 08             	sub    $0x8,%esp
801046dd:	83 c7 04             	add    $0x4,%edi
801046e0:	52                   	push   %edx
801046e1:	68 61 75 10 80       	push   $0x80107561
801046e6:	e8 75 bf ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801046eb:	83 c4 10             	add    $0x10,%esp
801046ee:	39 fe                	cmp    %edi,%esi
801046f0:	75 de                	jne    801046d0 <procdump+0xa0>
801046f2:	e9 51 ff ff ff       	jmp    80104648 <procdump+0x18>
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
80104700:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104703:	5b                   	pop    %ebx
80104704:	5e                   	pop    %esi
80104705:	5f                   	pop    %edi
80104706:	5d                   	pop    %ebp
80104707:	c3                   	ret    
80104708:	66 90                	xchg   %ax,%ax
8010470a:	66 90                	xchg   %ax,%ax
8010470c:	66 90                	xchg   %ax,%ax
8010470e:	66 90                	xchg   %ax,%ax

80104710 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 0c             	sub    $0xc,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010471a:	68 48 7c 10 80       	push   $0x80107c48
8010471f:	8d 43 04             	lea    0x4(%ebx),%eax
80104722:	50                   	push   %eax
80104723:	e8 18 01 00 00       	call   80104840 <initlock>
  lk->name = name;
80104728:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010472b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104731:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104734:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010473b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010473e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104741:	c9                   	leave  
80104742:	c3                   	ret    
80104743:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104750 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104758:	83 ec 0c             	sub    $0xc,%esp
8010475b:	8d 73 04             	lea    0x4(%ebx),%esi
8010475e:	56                   	push   %esi
8010475f:	e8 1c 02 00 00       	call   80104980 <acquire>
  while (lk->locked) {
80104764:	8b 13                	mov    (%ebx),%edx
80104766:	83 c4 10             	add    $0x10,%esp
80104769:	85 d2                	test   %edx,%edx
8010476b:	74 16                	je     80104783 <acquiresleep+0x33>
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104770:	83 ec 08             	sub    $0x8,%esp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	e8 a6 f7 ff ff       	call   80103f20 <sleep>
  while (lk->locked) {
8010477a:	8b 03                	mov    (%ebx),%eax
8010477c:	83 c4 10             	add    $0x10,%esp
8010477f:	85 c0                	test   %eax,%eax
80104781:	75 ed                	jne    80104770 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104783:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104789:	e8 32 f1 ff ff       	call   801038c0 <myproc>
8010478e:	8b 40 0c             	mov    0xc(%eax),%eax
80104791:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104794:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104797:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010479a:	5b                   	pop    %ebx
8010479b:	5e                   	pop    %esi
8010479c:	5d                   	pop    %ebp
  release(&lk->lk);
8010479d:	e9 9e 02 00 00       	jmp    80104a40 <release>
801047a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047b8:	83 ec 0c             	sub    $0xc,%esp
801047bb:	8d 73 04             	lea    0x4(%ebx),%esi
801047be:	56                   	push   %esi
801047bf:	e8 bc 01 00 00       	call   80104980 <acquire>
  lk->locked = 0;
801047c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047d1:	89 1c 24             	mov    %ebx,(%esp)
801047d4:	e8 e7 fc ff ff       	call   801044c0 <wakeup>
  release(&lk->lk);
801047d9:	89 75 08             	mov    %esi,0x8(%ebp)
801047dc:	83 c4 10             	add    $0x10,%esp
}
801047df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047e2:	5b                   	pop    %ebx
801047e3:	5e                   	pop    %esi
801047e4:	5d                   	pop    %ebp
  release(&lk->lk);
801047e5:	e9 56 02 00 00       	jmp    80104a40 <release>
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	56                   	push   %esi
801047f5:	53                   	push   %ebx
801047f6:	31 ff                	xor    %edi,%edi
801047f8:	83 ec 18             	sub    $0x18,%esp
801047fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104801:	56                   	push   %esi
80104802:	e8 79 01 00 00       	call   80104980 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104807:	8b 03                	mov    (%ebx),%eax
80104809:	83 c4 10             	add    $0x10,%esp
8010480c:	85 c0                	test   %eax,%eax
8010480e:	74 13                	je     80104823 <holdingsleep+0x33>
80104810:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104813:	e8 a8 f0 ff ff       	call   801038c0 <myproc>
80104818:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010481b:	0f 94 c0             	sete   %al
8010481e:	0f b6 c0             	movzbl %al,%eax
80104821:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104823:	83 ec 0c             	sub    $0xc,%esp
80104826:	56                   	push   %esi
80104827:	e8 14 02 00 00       	call   80104a40 <release>
  return r;
}
8010482c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010482f:	89 f8                	mov    %edi,%eax
80104831:	5b                   	pop    %ebx
80104832:	5e                   	pop    %esi
80104833:	5f                   	pop    %edi
80104834:	5d                   	pop    %ebp
80104835:	c3                   	ret    
80104836:	66 90                	xchg   %ax,%ax
80104838:	66 90                	xchg   %ax,%ax
8010483a:	66 90                	xchg   %ax,%ax
8010483c:	66 90                	xchg   %ax,%ax
8010483e:	66 90                	xchg   %ax,%ax

80104840 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104846:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104849:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010484f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104852:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104859:	5d                   	pop    %ebp
8010485a:	c3                   	ret    
8010485b:	90                   	nop
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104860:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104861:	31 d2                	xor    %edx,%edx
{
80104863:	89 e5                	mov    %esp,%ebp
80104865:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104866:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104869:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010486c:	83 e8 08             	sub    $0x8,%eax
8010486f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104870:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104876:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010487c:	77 1a                	ja     80104898 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010487e:	8b 58 04             	mov    0x4(%eax),%ebx
80104881:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104884:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104887:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104889:	83 fa 0a             	cmp    $0xa,%edx
8010488c:	75 e2                	jne    80104870 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010488e:	5b                   	pop    %ebx
8010488f:	5d                   	pop    %ebp
80104890:	c3                   	ret    
80104891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104898:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010489b:	83 c1 28             	add    $0x28,%ecx
8010489e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801048a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801048a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801048a9:	39 c1                	cmp    %eax,%ecx
801048ab:	75 f3                	jne    801048a0 <getcallerpcs+0x40>
}
801048ad:	5b                   	pop    %ebx
801048ae:	5d                   	pop    %ebp
801048af:	c3                   	ret    

801048b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
801048b7:	9c                   	pushf  
801048b8:	5b                   	pop    %ebx
  asm volatile("cli");
801048b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048ba:	e8 61 ef ff ff       	call   80103820 <mycpu>
801048bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048c5:	85 c0                	test   %eax,%eax
801048c7:	75 11                	jne    801048da <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048c9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048cf:	e8 4c ef ff ff       	call   80103820 <mycpu>
801048d4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801048da:	e8 41 ef ff ff       	call   80103820 <mycpu>
801048df:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048e6:	83 c4 04             	add    $0x4,%esp
801048e9:	5b                   	pop    %ebx
801048ea:	5d                   	pop    %ebp
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <popcli>:

void
popcli(void)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048f6:	9c                   	pushf  
801048f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048f8:	f6 c4 02             	test   $0x2,%ah
801048fb:	75 35                	jne    80104932 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048fd:	e8 1e ef ff ff       	call   80103820 <mycpu>
80104902:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104909:	78 34                	js     8010493f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010490b:	e8 10 ef ff ff       	call   80103820 <mycpu>
80104910:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104916:	85 d2                	test   %edx,%edx
80104918:	74 06                	je     80104920 <popcli+0x30>
    sti();
}
8010491a:	c9                   	leave  
8010491b:	c3                   	ret    
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104920:	e8 fb ee ff ff       	call   80103820 <mycpu>
80104925:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010492b:	85 c0                	test   %eax,%eax
8010492d:	74 eb                	je     8010491a <popcli+0x2a>
  asm volatile("sti");
8010492f:	fb                   	sti    
}
80104930:	c9                   	leave  
80104931:	c3                   	ret    
    panic("popcli - interruptible");
80104932:	83 ec 0c             	sub    $0xc,%esp
80104935:	68 53 7c 10 80       	push   $0x80107c53
8010493a:	e8 51 ba ff ff       	call   80100390 <panic>
    panic("popcli");
8010493f:	83 ec 0c             	sub    $0xc,%esp
80104942:	68 6a 7c 10 80       	push   $0x80107c6a
80104947:	e8 44 ba ff ff       	call   80100390 <panic>
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104950 <holding>:
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
80104955:	8b 75 08             	mov    0x8(%ebp),%esi
80104958:	31 db                	xor    %ebx,%ebx
  pushcli();
8010495a:	e8 51 ff ff ff       	call   801048b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010495f:	8b 06                	mov    (%esi),%eax
80104961:	85 c0                	test   %eax,%eax
80104963:	74 10                	je     80104975 <holding+0x25>
80104965:	8b 5e 08             	mov    0x8(%esi),%ebx
80104968:	e8 b3 ee ff ff       	call   80103820 <mycpu>
8010496d:	39 c3                	cmp    %eax,%ebx
8010496f:	0f 94 c3             	sete   %bl
80104972:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104975:	e8 76 ff ff ff       	call   801048f0 <popcli>
}
8010497a:	89 d8                	mov    %ebx,%eax
8010497c:	5b                   	pop    %ebx
8010497d:	5e                   	pop    %esi
8010497e:	5d                   	pop    %ebp
8010497f:	c3                   	ret    

80104980 <acquire>:
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104985:	e8 26 ff ff ff       	call   801048b0 <pushcli>
  if(holding(lk))
8010498a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010498d:	83 ec 0c             	sub    $0xc,%esp
80104990:	53                   	push   %ebx
80104991:	e8 ba ff ff ff       	call   80104950 <holding>
80104996:	83 c4 10             	add    $0x10,%esp
80104999:	85 c0                	test   %eax,%eax
8010499b:	0f 85 83 00 00 00    	jne    80104a24 <acquire+0xa4>
801049a1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801049a3:	ba 01 00 00 00       	mov    $0x1,%edx
801049a8:	eb 09                	jmp    801049b3 <acquire+0x33>
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049b3:	89 d0                	mov    %edx,%eax
801049b5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801049b8:	85 c0                	test   %eax,%eax
801049ba:	75 f4                	jne    801049b0 <acquire+0x30>
  __sync_synchronize();
801049bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801049c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049c4:	e8 57 ee ff ff       	call   80103820 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801049c9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801049cc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801049cf:	89 e8                	mov    %ebp,%eax
801049d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049d8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801049de:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801049e4:	77 1a                	ja     80104a00 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801049e6:	8b 48 04             	mov    0x4(%eax),%ecx
801049e9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801049ec:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801049ef:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049f1:	83 fe 0a             	cmp    $0xa,%esi
801049f4:	75 e2                	jne    801049d8 <acquire+0x58>
}
801049f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049f9:	5b                   	pop    %ebx
801049fa:	5e                   	pop    %esi
801049fb:	5d                   	pop    %ebp
801049fc:	c3                   	ret    
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
80104a00:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104a03:	83 c2 28             	add    $0x28,%edx
80104a06:	8d 76 00             	lea    0x0(%esi),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a16:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a19:	39 d0                	cmp    %edx,%eax
80104a1b:	75 f3                	jne    80104a10 <acquire+0x90>
}
80104a1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a20:	5b                   	pop    %ebx
80104a21:	5e                   	pop    %esi
80104a22:	5d                   	pop    %ebp
80104a23:	c3                   	ret    
    panic("acquire");
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	68 71 7c 10 80       	push   $0x80107c71
80104a2c:	e8 5f b9 ff ff       	call   80100390 <panic>
80104a31:	eb 0d                	jmp    80104a40 <release>
80104a33:	90                   	nop
80104a34:	90                   	nop
80104a35:	90                   	nop
80104a36:	90                   	nop
80104a37:	90                   	nop
80104a38:	90                   	nop
80104a39:	90                   	nop
80104a3a:	90                   	nop
80104a3b:	90                   	nop
80104a3c:	90                   	nop
80104a3d:	90                   	nop
80104a3e:	90                   	nop
80104a3f:	90                   	nop

80104a40 <release>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 10             	sub    $0x10,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a4a:	53                   	push   %ebx
80104a4b:	e8 00 ff ff ff       	call   80104950 <holding>
80104a50:	83 c4 10             	add    $0x10,%esp
80104a53:	85 c0                	test   %eax,%eax
80104a55:	74 22                	je     80104a79 <release+0x39>
  lk->pcs[0] = 0;
80104a57:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a5e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a65:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a6a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a73:	c9                   	leave  
  popcli();
80104a74:	e9 77 fe ff ff       	jmp    801048f0 <popcli>
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
80104a79:	50                   	push   %eax
80104a7a:	50                   	push   %eax
80104a7b:	ff 73 04             	pushl  0x4(%ebx)
80104a7e:	68 84 7c 10 80       	push   $0x80107c84
80104a83:	e8 d8 bb ff ff       	call   80100660 <cprintf>
    panic("release");}
80104a88:	c7 04 24 79 7c 10 80 	movl   $0x80107c79,(%esp)
80104a8f:	e8 fc b8 ff ff       	call   80100390 <panic>
80104a94:	66 90                	xchg   %ax,%ax
80104a96:	66 90                	xchg   %ax,%ax
80104a98:	66 90                	xchg   %ax,%ax
80104a9a:	66 90                	xchg   %ax,%ax
80104a9c:	66 90                	xchg   %ax,%ax
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	53                   	push   %ebx
80104aa5:	8b 55 08             	mov    0x8(%ebp),%edx
80104aa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104aab:	f6 c2 03             	test   $0x3,%dl
80104aae:	75 05                	jne    80104ab5 <memset+0x15>
80104ab0:	f6 c1 03             	test   $0x3,%cl
80104ab3:	74 13                	je     80104ac8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ab5:	89 d7                	mov    %edx,%edi
80104ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aba:	fc                   	cld    
80104abb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104abd:	5b                   	pop    %ebx
80104abe:	89 d0                	mov    %edx,%eax
80104ac0:	5f                   	pop    %edi
80104ac1:	5d                   	pop    %ebp
80104ac2:	c3                   	ret    
80104ac3:	90                   	nop
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104ac8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104acc:	c1 e9 02             	shr    $0x2,%ecx
80104acf:	89 f8                	mov    %edi,%eax
80104ad1:	89 fb                	mov    %edi,%ebx
80104ad3:	c1 e0 18             	shl    $0x18,%eax
80104ad6:	c1 e3 10             	shl    $0x10,%ebx
80104ad9:	09 d8                	or     %ebx,%eax
80104adb:	09 f8                	or     %edi,%eax
80104add:	c1 e7 08             	shl    $0x8,%edi
80104ae0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ae2:	89 d7                	mov    %edx,%edi
80104ae4:	fc                   	cld    
80104ae5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ae7:	5b                   	pop    %ebx
80104ae8:	89 d0                	mov    %edx,%eax
80104aea:	5f                   	pop    %edi
80104aeb:	5d                   	pop    %ebp
80104aec:	c3                   	ret    
80104aed:	8d 76 00             	lea    0x0(%esi),%esi

80104af0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	53                   	push   %ebx
80104af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104af9:	8b 75 08             	mov    0x8(%ebp),%esi
80104afc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104aff:	85 db                	test   %ebx,%ebx
80104b01:	74 29                	je     80104b2c <memcmp+0x3c>
    if(*s1 != *s2)
80104b03:	0f b6 16             	movzbl (%esi),%edx
80104b06:	0f b6 0f             	movzbl (%edi),%ecx
80104b09:	38 d1                	cmp    %dl,%cl
80104b0b:	75 2b                	jne    80104b38 <memcmp+0x48>
80104b0d:	b8 01 00 00 00       	mov    $0x1,%eax
80104b12:	eb 14                	jmp    80104b28 <memcmp+0x38>
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b18:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104b1c:	83 c0 01             	add    $0x1,%eax
80104b1f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104b24:	38 ca                	cmp    %cl,%dl
80104b26:	75 10                	jne    80104b38 <memcmp+0x48>
  while(n-- > 0){
80104b28:	39 d8                	cmp    %ebx,%eax
80104b2a:	75 ec                	jne    80104b18 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104b2c:	5b                   	pop    %ebx
  return 0;
80104b2d:	31 c0                	xor    %eax,%eax
}
80104b2f:	5e                   	pop    %esi
80104b30:	5f                   	pop    %edi
80104b31:	5d                   	pop    %ebp
80104b32:	c3                   	ret    
80104b33:	90                   	nop
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b38:	0f b6 c2             	movzbl %dl,%eax
}
80104b3b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b3c:	29 c8                	sub    %ecx,%eax
}
80104b3e:	5e                   	pop    %esi
80104b3f:	5f                   	pop    %edi
80104b40:	5d                   	pop    %ebp
80104b41:	c3                   	ret    
80104b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
80104b55:	8b 45 08             	mov    0x8(%ebp),%eax
80104b58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b5b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b5e:	39 c3                	cmp    %eax,%ebx
80104b60:	73 26                	jae    80104b88 <memmove+0x38>
80104b62:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b65:	39 c8                	cmp    %ecx,%eax
80104b67:	73 1f                	jae    80104b88 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b69:	85 f6                	test   %esi,%esi
80104b6b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b6e:	74 0f                	je     80104b7f <memmove+0x2f>
      *--d = *--s;
80104b70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b77:	83 ea 01             	sub    $0x1,%edx
80104b7a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b7d:	75 f1                	jne    80104b70 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b7f:	5b                   	pop    %ebx
80104b80:	5e                   	pop    %esi
80104b81:	5d                   	pop    %ebp
80104b82:	c3                   	ret    
80104b83:	90                   	nop
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b88:	31 d2                	xor    %edx,%edx
80104b8a:	85 f6                	test   %esi,%esi
80104b8c:	74 f1                	je     80104b7f <memmove+0x2f>
80104b8e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b97:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b9a:	39 d6                	cmp    %edx,%esi
80104b9c:	75 f2                	jne    80104b90 <memmove+0x40>
}
80104b9e:	5b                   	pop    %ebx
80104b9f:	5e                   	pop    %esi
80104ba0:	5d                   	pop    %ebp
80104ba1:	c3                   	ret    
80104ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104bb3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104bb4:	eb 9a                	jmp    80104b50 <memmove>
80104bb6:	8d 76 00             	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104bc8:	53                   	push   %ebx
80104bc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104bcf:	85 ff                	test   %edi,%edi
80104bd1:	74 2f                	je     80104c02 <strncmp+0x42>
80104bd3:	0f b6 01             	movzbl (%ecx),%eax
80104bd6:	0f b6 1e             	movzbl (%esi),%ebx
80104bd9:	84 c0                	test   %al,%al
80104bdb:	74 37                	je     80104c14 <strncmp+0x54>
80104bdd:	38 c3                	cmp    %al,%bl
80104bdf:	75 33                	jne    80104c14 <strncmp+0x54>
80104be1:	01 f7                	add    %esi,%edi
80104be3:	eb 13                	jmp    80104bf8 <strncmp+0x38>
80104be5:	8d 76 00             	lea    0x0(%esi),%esi
80104be8:	0f b6 01             	movzbl (%ecx),%eax
80104beb:	84 c0                	test   %al,%al
80104bed:	74 21                	je     80104c10 <strncmp+0x50>
80104bef:	0f b6 1a             	movzbl (%edx),%ebx
80104bf2:	89 d6                	mov    %edx,%esi
80104bf4:	38 d8                	cmp    %bl,%al
80104bf6:	75 1c                	jne    80104c14 <strncmp+0x54>
    n--, p++, q++;
80104bf8:	8d 56 01             	lea    0x1(%esi),%edx
80104bfb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104bfe:	39 fa                	cmp    %edi,%edx
80104c00:	75 e6                	jne    80104be8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104c02:	5b                   	pop    %ebx
    return 0;
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	5e                   	pop    %esi
80104c06:	5f                   	pop    %edi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c10:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104c14:	29 d8                	sub    %ebx,%eax
}
80104c16:	5b                   	pop    %ebx
80104c17:	5e                   	pop    %esi
80104c18:	5f                   	pop    %edi
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    
80104c1b:	90                   	nop
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 45 08             	mov    0x8(%ebp),%eax
80104c28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c2e:	89 c2                	mov    %eax,%edx
80104c30:	eb 19                	jmp    80104c4b <strncpy+0x2b>
80104c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c38:	83 c3 01             	add    $0x1,%ebx
80104c3b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c3f:	83 c2 01             	add    $0x1,%edx
80104c42:	84 c9                	test   %cl,%cl
80104c44:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c47:	74 09                	je     80104c52 <strncpy+0x32>
80104c49:	89 f1                	mov    %esi,%ecx
80104c4b:	85 c9                	test   %ecx,%ecx
80104c4d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c50:	7f e6                	jg     80104c38 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c52:	31 c9                	xor    %ecx,%ecx
80104c54:	85 f6                	test   %esi,%esi
80104c56:	7e 17                	jle    80104c6f <strncpy+0x4f>
80104c58:	90                   	nop
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c60:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c64:	89 f3                	mov    %esi,%ebx
80104c66:	83 c1 01             	add    $0x1,%ecx
80104c69:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c6b:	85 db                	test   %ebx,%ebx
80104c6d:	7f f1                	jg     80104c60 <strncpy+0x40>
  return os;
}
80104c6f:	5b                   	pop    %ebx
80104c70:	5e                   	pop    %esi
80104c71:	5d                   	pop    %ebp
80104c72:	c3                   	ret    
80104c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c88:	8b 45 08             	mov    0x8(%ebp),%eax
80104c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c8e:	85 c9                	test   %ecx,%ecx
80104c90:	7e 26                	jle    80104cb8 <safestrcpy+0x38>
80104c92:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c96:	89 c1                	mov    %eax,%ecx
80104c98:	eb 17                	jmp    80104cb1 <safestrcpy+0x31>
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ca0:	83 c2 01             	add    $0x1,%edx
80104ca3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ca7:	83 c1 01             	add    $0x1,%ecx
80104caa:	84 db                	test   %bl,%bl
80104cac:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104caf:	74 04                	je     80104cb5 <safestrcpy+0x35>
80104cb1:	39 f2                	cmp    %esi,%edx
80104cb3:	75 eb                	jne    80104ca0 <safestrcpy+0x20>
    ;
  *s = 0;
80104cb5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104cb8:	5b                   	pop    %ebx
80104cb9:	5e                   	pop    %esi
80104cba:	5d                   	pop    %ebp
80104cbb:	c3                   	ret    
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <strlen>:

int
strlen(const char *s)
{
80104cc0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104cc1:	31 c0                	xor    %eax,%eax
{
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104cc8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ccb:	74 0c                	je     80104cd9 <strlen+0x19>
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
80104cd0:	83 c0 01             	add    $0x1,%eax
80104cd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104cd7:	75 f7                	jne    80104cd0 <strlen+0x10>
    ;
  return n;
}
80104cd9:	5d                   	pop    %ebp
80104cda:	c3                   	ret    

80104cdb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104cdb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104cdf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ce3:	55                   	push   %ebp
  pushl %ebx
80104ce4:	53                   	push   %ebx
  pushl %esi
80104ce5:	56                   	push   %esi
  pushl %edi
80104ce6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ce7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ce9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104ceb:	5f                   	pop    %edi
  popl %esi
80104cec:	5e                   	pop    %esi
  popl %ebx
80104ced:	5b                   	pop    %ebx
  popl %ebp
80104cee:	5d                   	pop    %ebp
  ret
80104cef:	c3                   	ret    

80104cf0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 04             	sub    $0x4,%esp
80104cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104cfa:	e8 c1 eb ff ff       	call   801038c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cff:	8b 00                	mov    (%eax),%eax
80104d01:	39 d8                	cmp    %ebx,%eax
80104d03:	76 1b                	jbe    80104d20 <fetchint+0x30>
80104d05:	8d 53 04             	lea    0x4(%ebx),%edx
80104d08:	39 d0                	cmp    %edx,%eax
80104d0a:	72 14                	jb     80104d20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d0f:	8b 13                	mov    (%ebx),%edx
80104d11:	89 10                	mov    %edx,(%eax)
  return 0;
80104d13:	31 c0                	xor    %eax,%eax
}
80104d15:	83 c4 04             	add    $0x4,%esp
80104d18:	5b                   	pop    %ebx
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret    
80104d1b:	90                   	nop
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d25:	eb ee                	jmp    80104d15 <fetchint+0x25>
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 04             	sub    $0x4,%esp
80104d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d3a:	e8 81 eb ff ff       	call   801038c0 <myproc>

  if(addr >= curproc->sz)
80104d3f:	39 18                	cmp    %ebx,(%eax)
80104d41:	76 29                	jbe    80104d6c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d46:	89 da                	mov    %ebx,%edx
80104d48:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d4a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d4c:	39 c3                	cmp    %eax,%ebx
80104d4e:	73 1c                	jae    80104d6c <fetchstr+0x3c>
    if(*s == 0)
80104d50:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d53:	75 10                	jne    80104d65 <fetchstr+0x35>
80104d55:	eb 39                	jmp    80104d90 <fetchstr+0x60>
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d60:	80 3a 00             	cmpb   $0x0,(%edx)
80104d63:	74 1b                	je     80104d80 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d65:	83 c2 01             	add    $0x1,%edx
80104d68:	39 d0                	cmp    %edx,%eax
80104d6a:	77 f4                	ja     80104d60 <fetchstr+0x30>
    return -1;
80104d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d71:	83 c4 04             	add    $0x4,%esp
80104d74:	5b                   	pop    %ebx
80104d75:	5d                   	pop    %ebp
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d80:	83 c4 04             	add    $0x4,%esp
80104d83:	89 d0                	mov    %edx,%eax
80104d85:	29 d8                	sub    %ebx,%eax
80104d87:	5b                   	pop    %ebx
80104d88:	5d                   	pop    %ebp
80104d89:	c3                   	ret    
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104d90:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104d92:	eb dd                	jmp    80104d71 <fetchstr+0x41>
80104d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104da0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104da5:	e8 46 eb ff ff       	call   801038f0 <mythread>
80104daa:	8b 40 10             	mov    0x10(%eax),%eax
80104dad:	8b 55 08             	mov    0x8(%ebp),%edx
80104db0:	8b 40 44             	mov    0x44(%eax),%eax
80104db3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104db6:	e8 05 eb ff ff       	call   801038c0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dbb:	8b 00                	mov    (%eax),%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104dbd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dc0:	39 c6                	cmp    %eax,%esi
80104dc2:	73 1c                	jae    80104de0 <argint+0x40>
80104dc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104dc7:	39 d0                	cmp    %edx,%eax
80104dc9:	72 15                	jb     80104de0 <argint+0x40>
  *ip = *(int*)(addr);
80104dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dce:	8b 53 04             	mov    0x4(%ebx),%edx
80104dd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dd3:	31 c0                	xor    %eax,%eax
}
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
80104dd8:	c3                   	ret    
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104de5:	eb ee                	jmp    80104dd5 <argint+0x35>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
80104df5:	83 ec 10             	sub    $0x10,%esp
80104df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104dfb:	e8 c0 ea ff ff       	call   801038c0 <myproc>
80104e00:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104e02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e05:	83 ec 08             	sub    $0x8,%esp
80104e08:	50                   	push   %eax
80104e09:	ff 75 08             	pushl  0x8(%ebp)
80104e0c:	e8 8f ff ff ff       	call   80104da0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e11:	83 c4 10             	add    $0x10,%esp
80104e14:	85 c0                	test   %eax,%eax
80104e16:	78 28                	js     80104e40 <argptr+0x50>
80104e18:	85 db                	test   %ebx,%ebx
80104e1a:	78 24                	js     80104e40 <argptr+0x50>
80104e1c:	8b 16                	mov    (%esi),%edx
80104e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e21:	39 c2                	cmp    %eax,%edx
80104e23:	76 1b                	jbe    80104e40 <argptr+0x50>
80104e25:	01 c3                	add    %eax,%ebx
80104e27:	39 da                	cmp    %ebx,%edx
80104e29:	72 15                	jb     80104e40 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e2e:	89 02                	mov    %eax,(%edx)
  return 0;
80104e30:	31 c0                	xor    %eax,%eax
}
80104e32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e35:	5b                   	pop    %ebx
80104e36:	5e                   	pop    %esi
80104e37:	5d                   	pop    %ebp
80104e38:	c3                   	ret    
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e45:	eb eb                	jmp    80104e32 <argptr+0x42>
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e59:	50                   	push   %eax
80104e5a:	ff 75 08             	pushl  0x8(%ebp)
80104e5d:	e8 3e ff ff ff       	call   80104da0 <argint>
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	85 c0                	test   %eax,%eax
80104e67:	78 17                	js     80104e80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e69:	83 ec 08             	sub    $0x8,%esp
80104e6c:	ff 75 0c             	pushl  0xc(%ebp)
80104e6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e72:	e8 b9 fe ff ff       	call   80104d30 <fetchstr>
80104e77:	83 c4 10             	add    $0x10,%esp
}
80104e7a:	c9                   	leave  
80104e7b:	c3                   	ret    
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104e95:	e8 26 ea ff ff       	call   801038c0 <myproc>
80104e9a:	89 c6                	mov    %eax,%esi
  struct thread *curthread = mythread();
80104e9c:	e8 4f ea ff ff       	call   801038f0 <mythread>
80104ea1:	89 c3                	mov    %eax,%ebx

  num = curthread->tf->eax;
80104ea3:	8b 40 10             	mov    0x10(%eax),%eax
80104ea6:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
80104eac:	83 fa 14             	cmp    $0x14,%edx
80104eaf:	77 1f                	ja     80104ed0 <syscall+0x40>
80104eb1:	8b 14 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%edx
80104eb8:	85 d2                	test   %edx,%edx
80104eba:	74 14                	je     80104ed0 <syscall+0x40>
    curthread->tf->eax = syscalls[num]();
80104ebc:	ff d2                	call   *%edx
80104ebe:	8b 53 10             	mov    0x10(%ebx),%edx
80104ec1:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
  }
}
80104ec4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec7:	5b                   	pop    %ebx
80104ec8:	5e                   	pop    %esi
80104ec9:	5d                   	pop    %ebp
80104eca:	c3                   	ret    
80104ecb:	90                   	nop
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ed0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ed1:	8d 46 60             	lea    0x60(%esi),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ed4:	50                   	push   %eax
80104ed5:	ff 76 0c             	pushl  0xc(%esi)
80104ed8:	68 a6 7c 10 80       	push   $0x80107ca6
80104edd:	e8 7e b7 ff ff       	call   80100660 <cprintf>
    curthread->tf->eax = -1;
80104ee2:	8b 43 10             	mov    0x10(%ebx),%eax
80104ee5:	83 c4 10             	add    $0x10,%esp
80104ee8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104eef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ef2:	5b                   	pop    %ebx
80104ef3:	5e                   	pop    %esi
80104ef4:	5d                   	pop    %ebp
80104ef5:	c3                   	ret    
80104ef6:	66 90                	xchg   %ax,%ax
80104ef8:	66 90                	xchg   %ax,%ax
80104efa:	66 90                	xchg   %ax,%ax
80104efc:	66 90                	xchg   %ax,%ax
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	56                   	push   %esi
80104f05:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f06:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104f09:	83 ec 44             	sub    $0x44,%esp
80104f0c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104f12:	56                   	push   %esi
80104f13:	50                   	push   %eax
{
80104f14:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104f17:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f1a:	e8 21 d0 ff ff       	call   80101f40 <nameiparent>
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	85 c0                	test   %eax,%eax
80104f24:	0f 84 46 01 00 00    	je     80105070 <create+0x170>
    return 0;
  ilock(dp);
80104f2a:	83 ec 0c             	sub    $0xc,%esp
80104f2d:	89 c3                	mov    %eax,%ebx
80104f2f:	50                   	push   %eax
80104f30:	e8 8b c7 ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104f35:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104f38:	83 c4 0c             	add    $0xc,%esp
80104f3b:	50                   	push   %eax
80104f3c:	56                   	push   %esi
80104f3d:	53                   	push   %ebx
80104f3e:	e8 ad cc ff ff       	call   80101bf0 <dirlookup>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	85 c0                	test   %eax,%eax
80104f48:	89 c7                	mov    %eax,%edi
80104f4a:	74 34                	je     80104f80 <create+0x80>
    iunlockput(dp);
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	53                   	push   %ebx
80104f50:	e8 fb c9 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
80104f55:	89 3c 24             	mov    %edi,(%esp)
80104f58:	e8 63 c7 ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104f65:	0f 85 95 00 00 00    	jne    80105000 <create+0x100>
80104f6b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f70:	0f 85 8a 00 00 00    	jne    80105000 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f79:	89 f8                	mov    %edi,%eax
80104f7b:	5b                   	pop    %ebx
80104f7c:	5e                   	pop    %esi
80104f7d:	5f                   	pop    %edi
80104f7e:	5d                   	pop    %ebp
80104f7f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104f80:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104f84:	83 ec 08             	sub    $0x8,%esp
80104f87:	50                   	push   %eax
80104f88:	ff 33                	pushl  (%ebx)
80104f8a:	e8 c1 c5 ff ff       	call   80101550 <ialloc>
80104f8f:	83 c4 10             	add    $0x10,%esp
80104f92:	85 c0                	test   %eax,%eax
80104f94:	89 c7                	mov    %eax,%edi
80104f96:	0f 84 e8 00 00 00    	je     80105084 <create+0x184>
  ilock(ip);
80104f9c:	83 ec 0c             	sub    $0xc,%esp
80104f9f:	50                   	push   %eax
80104fa0:	e8 1b c7 ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104fa5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104fa9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104fad:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104fb1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104fb5:	b8 01 00 00 00       	mov    $0x1,%eax
80104fba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104fbe:	89 3c 24             	mov    %edi,(%esp)
80104fc1:	e8 4a c6 ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104fc6:	83 c4 10             	add    $0x10,%esp
80104fc9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104fce:	74 50                	je     80105020 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104fd0:	83 ec 04             	sub    $0x4,%esp
80104fd3:	ff 77 04             	pushl  0x4(%edi)
80104fd6:	56                   	push   %esi
80104fd7:	53                   	push   %ebx
80104fd8:	e8 83 ce ff ff       	call   80101e60 <dirlink>
80104fdd:	83 c4 10             	add    $0x10,%esp
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	0f 88 8f 00 00 00    	js     80105077 <create+0x177>
  iunlockput(dp);
80104fe8:	83 ec 0c             	sub    $0xc,%esp
80104feb:	53                   	push   %ebx
80104fec:	e8 5f c9 ff ff       	call   80101950 <iunlockput>
  return ip;
80104ff1:	83 c4 10             	add    $0x10,%esp
}
80104ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ff7:	89 f8                	mov    %edi,%eax
80104ff9:	5b                   	pop    %ebx
80104ffa:	5e                   	pop    %esi
80104ffb:	5f                   	pop    %edi
80104ffc:	5d                   	pop    %ebp
80104ffd:	c3                   	ret    
80104ffe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105000:	83 ec 0c             	sub    $0xc,%esp
80105003:	57                   	push   %edi
    return 0;
80105004:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105006:	e8 45 c9 ff ff       	call   80101950 <iunlockput>
    return 0;
8010500b:	83 c4 10             	add    $0x10,%esp
}
8010500e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105011:	89 f8                	mov    %edi,%eax
80105013:	5b                   	pop    %ebx
80105014:	5e                   	pop    %esi
80105015:	5f                   	pop    %edi
80105016:	5d                   	pop    %ebp
80105017:	c3                   	ret    
80105018:	90                   	nop
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105020:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105025:	83 ec 0c             	sub    $0xc,%esp
80105028:	53                   	push   %ebx
80105029:	e8 e2 c5 ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010502e:	83 c4 0c             	add    $0xc,%esp
80105031:	ff 77 04             	pushl  0x4(%edi)
80105034:	68 54 7d 10 80       	push   $0x80107d54
80105039:	57                   	push   %edi
8010503a:	e8 21 ce ff ff       	call   80101e60 <dirlink>
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	85 c0                	test   %eax,%eax
80105044:	78 1c                	js     80105062 <create+0x162>
80105046:	83 ec 04             	sub    $0x4,%esp
80105049:	ff 73 04             	pushl  0x4(%ebx)
8010504c:	68 53 7d 10 80       	push   $0x80107d53
80105051:	57                   	push   %edi
80105052:	e8 09 ce ff ff       	call   80101e60 <dirlink>
80105057:	83 c4 10             	add    $0x10,%esp
8010505a:	85 c0                	test   %eax,%eax
8010505c:	0f 89 6e ff ff ff    	jns    80104fd0 <create+0xd0>
      panic("create dots");
80105062:	83 ec 0c             	sub    $0xc,%esp
80105065:	68 47 7d 10 80       	push   $0x80107d47
8010506a:	e8 21 b3 ff ff       	call   80100390 <panic>
8010506f:	90                   	nop
    return 0;
80105070:	31 ff                	xor    %edi,%edi
80105072:	e9 ff fe ff ff       	jmp    80104f76 <create+0x76>
    panic("create: dirlink");
80105077:	83 ec 0c             	sub    $0xc,%esp
8010507a:	68 56 7d 10 80       	push   $0x80107d56
8010507f:	e8 0c b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	68 38 7d 10 80       	push   $0x80107d38
8010508c:	e8 ff b2 ff ff       	call   80100390 <panic>
80105091:	eb 0d                	jmp    801050a0 <argfd.constprop.0>
80105093:	90                   	nop
80105094:	90                   	nop
80105095:	90                   	nop
80105096:	90                   	nop
80105097:	90                   	nop
80105098:	90                   	nop
80105099:	90                   	nop
8010509a:	90                   	nop
8010509b:	90                   	nop
8010509c:	90                   	nop
8010509d:	90                   	nop
8010509e:	90                   	nop
8010509f:	90                   	nop

801050a0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
801050a5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801050a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801050aa:	89 d6                	mov    %edx,%esi
801050ac:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050af:	50                   	push   %eax
801050b0:	6a 00                	push   $0x0
801050b2:	e8 e9 fc ff ff       	call   80104da0 <argint>
801050b7:	83 c4 10             	add    $0x10,%esp
801050ba:	85 c0                	test   %eax,%eax
801050bc:	78 2a                	js     801050e8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050be:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050c2:	77 24                	ja     801050e8 <argfd.constprop.0+0x48>
801050c4:	e8 f7 e7 ff ff       	call   801038c0 <myproc>
801050c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050cc:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
801050d0:	85 c0                	test   %eax,%eax
801050d2:	74 14                	je     801050e8 <argfd.constprop.0+0x48>
  if(pfd)
801050d4:	85 db                	test   %ebx,%ebx
801050d6:	74 02                	je     801050da <argfd.constprop.0+0x3a>
    *pfd = fd;
801050d8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801050da:	89 06                	mov    %eax,(%esi)
  return 0;
801050dc:	31 c0                	xor    %eax,%eax
}
801050de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e1:	5b                   	pop    %ebx
801050e2:	5e                   	pop    %esi
801050e3:	5d                   	pop    %ebp
801050e4:	c3                   	ret    
801050e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb ef                	jmp    801050de <argfd.constprop.0+0x3e>
801050ef:	90                   	nop

801050f0 <sys_dup>:
{
801050f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801050f1:	31 c0                	xor    %eax,%eax
{
801050f3:	89 e5                	mov    %esp,%ebp
801050f5:	56                   	push   %esi
801050f6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801050f7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801050fa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050fd:	e8 9e ff ff ff       	call   801050a0 <argfd.constprop.0>
80105102:	85 c0                	test   %eax,%eax
80105104:	78 42                	js     80105148 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105106:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105109:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010510b:	e8 b0 e7 ff ff       	call   801038c0 <myproc>
80105110:	eb 0e                	jmp    80105120 <sys_dup+0x30>
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105118:	83 c3 01             	add    $0x1,%ebx
8010511b:	83 fb 10             	cmp    $0x10,%ebx
8010511e:	74 28                	je     80105148 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105120:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105124:	85 d2                	test   %edx,%edx
80105126:	75 f0                	jne    80105118 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105128:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
  filedup(f);
8010512c:	83 ec 0c             	sub    $0xc,%esp
8010512f:	ff 75 f4             	pushl  -0xc(%ebp)
80105132:	e8 e9 bc ff ff       	call   80100e20 <filedup>
  return fd;
80105137:	83 c4 10             	add    $0x10,%esp
}
8010513a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010513d:	89 d8                	mov    %ebx,%eax
8010513f:	5b                   	pop    %ebx
80105140:	5e                   	pop    %esi
80105141:	5d                   	pop    %ebp
80105142:	c3                   	ret    
80105143:	90                   	nop
80105144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105148:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010514b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105150:	89 d8                	mov    %ebx,%eax
80105152:	5b                   	pop    %ebx
80105153:	5e                   	pop    %esi
80105154:	5d                   	pop    %ebp
80105155:	c3                   	ret    
80105156:	8d 76 00             	lea    0x0(%esi),%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_read>:
{
80105160:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105161:	31 c0                	xor    %eax,%eax
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105168:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010516b:	e8 30 ff ff ff       	call   801050a0 <argfd.constprop.0>
80105170:	85 c0                	test   %eax,%eax
80105172:	78 4c                	js     801051c0 <sys_read+0x60>
80105174:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105177:	83 ec 08             	sub    $0x8,%esp
8010517a:	50                   	push   %eax
8010517b:	6a 02                	push   $0x2
8010517d:	e8 1e fc ff ff       	call   80104da0 <argint>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	78 37                	js     801051c0 <sys_read+0x60>
80105189:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518c:	83 ec 04             	sub    $0x4,%esp
8010518f:	ff 75 f0             	pushl  -0x10(%ebp)
80105192:	50                   	push   %eax
80105193:	6a 01                	push   $0x1
80105195:	e8 56 fc ff ff       	call   80104df0 <argptr>
8010519a:	83 c4 10             	add    $0x10,%esp
8010519d:	85 c0                	test   %eax,%eax
8010519f:	78 1f                	js     801051c0 <sys_read+0x60>
  return fileread(f, p, n);
801051a1:	83 ec 04             	sub    $0x4,%esp
801051a4:	ff 75 f0             	pushl  -0x10(%ebp)
801051a7:	ff 75 f4             	pushl  -0xc(%ebp)
801051aa:	ff 75 ec             	pushl  -0x14(%ebp)
801051ad:	e8 de bd ff ff       	call   80100f90 <fileread>
801051b2:	83 c4 10             	add    $0x10,%esp
}
801051b5:	c9                   	leave  
801051b6:	c3                   	ret    
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_write>:
{
801051d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d1:	31 c0                	xor    %eax,%eax
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051db:	e8 c0 fe ff ff       	call   801050a0 <argfd.constprop.0>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 4c                	js     80105230 <sys_write+0x60>
801051e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	50                   	push   %eax
801051eb:	6a 02                	push   $0x2
801051ed:	e8 ae fb ff ff       	call   80104da0 <argint>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 37                	js     80105230 <sys_write+0x60>
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fc:	83 ec 04             	sub    $0x4,%esp
801051ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105202:	50                   	push   %eax
80105203:	6a 01                	push   $0x1
80105205:	e8 e6 fb ff ff       	call   80104df0 <argptr>
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	85 c0                	test   %eax,%eax
8010520f:	78 1f                	js     80105230 <sys_write+0x60>
  return filewrite(f, p, n);
80105211:	83 ec 04             	sub    $0x4,%esp
80105214:	ff 75 f0             	pushl  -0x10(%ebp)
80105217:	ff 75 f4             	pushl  -0xc(%ebp)
8010521a:	ff 75 ec             	pushl  -0x14(%ebp)
8010521d:	e8 fe bd ff ff       	call   80101020 <filewrite>
80105222:	83 c4 10             	add    $0x10,%esp
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_close>:
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105246:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105249:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010524c:	e8 4f fe ff ff       	call   801050a0 <argfd.constprop.0>
80105251:	85 c0                	test   %eax,%eax
80105253:	78 2b                	js     80105280 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105255:	e8 66 e6 ff ff       	call   801038c0 <myproc>
8010525a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010525d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105260:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
80105267:	00 
  fileclose(f);
80105268:	ff 75 f4             	pushl  -0xc(%ebp)
8010526b:	e8 00 bc ff ff       	call   80100e70 <fileclose>
  return 0;
80105270:	83 c4 10             	add    $0x10,%esp
80105273:	31 c0                	xor    %eax,%eax
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_fstat>:
{
80105290:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105291:	31 c0                	xor    %eax,%eax
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105298:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010529b:	e8 00 fe ff ff       	call   801050a0 <argfd.constprop.0>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 2c                	js     801052d0 <sys_fstat+0x40>
801052a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a7:	83 ec 04             	sub    $0x4,%esp
801052aa:	6a 14                	push   $0x14
801052ac:	50                   	push   %eax
801052ad:	6a 01                	push   $0x1
801052af:	e8 3c fb ff ff       	call   80104df0 <argptr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	78 15                	js     801052d0 <sys_fstat+0x40>
  return filestat(f, st);
801052bb:	83 ec 08             	sub    $0x8,%esp
801052be:	ff 75 f4             	pushl  -0xc(%ebp)
801052c1:	ff 75 f0             	pushl  -0x10(%ebp)
801052c4:	e8 77 bc ff ff       	call   80100f40 <filestat>
801052c9:	83 c4 10             	add    $0x10,%esp
}
801052cc:	c9                   	leave  
801052cd:	c3                   	ret    
801052ce:	66 90                	xchg   %ax,%ax
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_link>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052e6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052e9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052ec:	50                   	push   %eax
801052ed:	6a 00                	push   $0x0
801052ef:	e8 5c fb ff ff       	call   80104e50 <argstr>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	0f 88 fb 00 00 00    	js     801053fa <sys_link+0x11a>
801052ff:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105302:	83 ec 08             	sub    $0x8,%esp
80105305:	50                   	push   %eax
80105306:	6a 01                	push   $0x1
80105308:	e8 43 fb ff ff       	call   80104e50 <argstr>
8010530d:	83 c4 10             	add    $0x10,%esp
80105310:	85 c0                	test   %eax,%eax
80105312:	0f 88 e2 00 00 00    	js     801053fa <sys_link+0x11a>
  begin_op();
80105318:	e8 c3 d8 ff ff       	call   80102be0 <begin_op>
  if((ip = namei(old)) == 0){
8010531d:	83 ec 0c             	sub    $0xc,%esp
80105320:	ff 75 d4             	pushl  -0x2c(%ebp)
80105323:	e8 f8 cb ff ff       	call   80101f20 <namei>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	85 c0                	test   %eax,%eax
8010532d:	89 c3                	mov    %eax,%ebx
8010532f:	0f 84 ea 00 00 00    	je     8010541f <sys_link+0x13f>
  ilock(ip);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	50                   	push   %eax
80105339:	e8 82 c3 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105346:	0f 84 bb 00 00 00    	je     80105407 <sys_link+0x127>
  ip->nlink++;
8010534c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105351:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105354:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105357:	53                   	push   %ebx
80105358:	e8 b3 c2 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
8010535d:	89 1c 24             	mov    %ebx,(%esp)
80105360:	e8 3b c4 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105365:	58                   	pop    %eax
80105366:	5a                   	pop    %edx
80105367:	57                   	push   %edi
80105368:	ff 75 d0             	pushl  -0x30(%ebp)
8010536b:	e8 d0 cb ff ff       	call   80101f40 <nameiparent>
80105370:	83 c4 10             	add    $0x10,%esp
80105373:	85 c0                	test   %eax,%eax
80105375:	89 c6                	mov    %eax,%esi
80105377:	74 5b                	je     801053d4 <sys_link+0xf4>
  ilock(dp);
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	50                   	push   %eax
8010537d:	e8 3e c3 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	8b 03                	mov    (%ebx),%eax
80105387:	39 06                	cmp    %eax,(%esi)
80105389:	75 3d                	jne    801053c8 <sys_link+0xe8>
8010538b:	83 ec 04             	sub    $0x4,%esp
8010538e:	ff 73 04             	pushl  0x4(%ebx)
80105391:	57                   	push   %edi
80105392:	56                   	push   %esi
80105393:	e8 c8 ca ff ff       	call   80101e60 <dirlink>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	85 c0                	test   %eax,%eax
8010539d:	78 29                	js     801053c8 <sys_link+0xe8>
  iunlockput(dp);
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	56                   	push   %esi
801053a3:	e8 a8 c5 ff ff       	call   80101950 <iunlockput>
  iput(ip);
801053a8:	89 1c 24             	mov    %ebx,(%esp)
801053ab:	e8 40 c4 ff ff       	call   801017f0 <iput>
  end_op();
801053b0:	e8 9b d8 ff ff       	call   80102c50 <end_op>
  return 0;
801053b5:	83 c4 10             	add    $0x10,%esp
801053b8:	31 c0                	xor    %eax,%eax
}
801053ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053bd:	5b                   	pop    %ebx
801053be:	5e                   	pop    %esi
801053bf:	5f                   	pop    %edi
801053c0:	5d                   	pop    %ebp
801053c1:	c3                   	ret    
801053c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	56                   	push   %esi
801053cc:	e8 7f c5 ff ff       	call   80101950 <iunlockput>
    goto bad;
801053d1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	53                   	push   %ebx
801053d8:	e8 e3 c2 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
801053dd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053e2:	89 1c 24             	mov    %ebx,(%esp)
801053e5:	e8 26 c2 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
801053ea:	89 1c 24             	mov    %ebx,(%esp)
801053ed:	e8 5e c5 ff ff       	call   80101950 <iunlockput>
  end_op();
801053f2:	e8 59 d8 ff ff       	call   80102c50 <end_op>
  return -1;
801053f7:	83 c4 10             	add    $0x10,%esp
}
801053fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801053fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5f                   	pop    %edi
80105405:	5d                   	pop    %ebp
80105406:	c3                   	ret    
    iunlockput(ip);
80105407:	83 ec 0c             	sub    $0xc,%esp
8010540a:	53                   	push   %ebx
8010540b:	e8 40 c5 ff ff       	call   80101950 <iunlockput>
    end_op();
80105410:	e8 3b d8 ff ff       	call   80102c50 <end_op>
    return -1;
80105415:	83 c4 10             	add    $0x10,%esp
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb 9b                	jmp    801053ba <sys_link+0xda>
    end_op();
8010541f:	e8 2c d8 ff ff       	call   80102c50 <end_op>
    return -1;
80105424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105429:	eb 8f                	jmp    801053ba <sys_link+0xda>
8010542b:	90                   	nop
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_unlink>:
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
80105435:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105436:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105439:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010543c:	50                   	push   %eax
8010543d:	6a 00                	push   $0x0
8010543f:	e8 0c fa ff ff       	call   80104e50 <argstr>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	0f 88 77 01 00 00    	js     801055c6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010544f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105452:	e8 89 d7 ff ff       	call   80102be0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105457:	83 ec 08             	sub    $0x8,%esp
8010545a:	53                   	push   %ebx
8010545b:	ff 75 c0             	pushl  -0x40(%ebp)
8010545e:	e8 dd ca ff ff       	call   80101f40 <nameiparent>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	89 c6                	mov    %eax,%esi
8010546a:	0f 84 60 01 00 00    	je     801055d0 <sys_unlink+0x1a0>
  ilock(dp);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	50                   	push   %eax
80105474:	e8 47 c2 ff ff       	call   801016c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105479:	58                   	pop    %eax
8010547a:	5a                   	pop    %edx
8010547b:	68 54 7d 10 80       	push   $0x80107d54
80105480:	53                   	push   %ebx
80105481:	e8 4a c7 ff ff       	call   80101bd0 <namecmp>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	0f 84 03 01 00 00    	je     80105594 <sys_unlink+0x164>
80105491:	83 ec 08             	sub    $0x8,%esp
80105494:	68 53 7d 10 80       	push   $0x80107d53
80105499:	53                   	push   %ebx
8010549a:	e8 31 c7 ff ff       	call   80101bd0 <namecmp>
8010549f:	83 c4 10             	add    $0x10,%esp
801054a2:	85 c0                	test   %eax,%eax
801054a4:	0f 84 ea 00 00 00    	je     80105594 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801054aa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054ad:	83 ec 04             	sub    $0x4,%esp
801054b0:	50                   	push   %eax
801054b1:	53                   	push   %ebx
801054b2:	56                   	push   %esi
801054b3:	e8 38 c7 ff ff       	call   80101bf0 <dirlookup>
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	85 c0                	test   %eax,%eax
801054bd:	89 c3                	mov    %eax,%ebx
801054bf:	0f 84 cf 00 00 00    	je     80105594 <sys_unlink+0x164>
  ilock(ip);
801054c5:	83 ec 0c             	sub    $0xc,%esp
801054c8:	50                   	push   %eax
801054c9:	e8 f2 c1 ff ff       	call   801016c0 <ilock>
  if(ip->nlink < 1)
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054d6:	0f 8e 10 01 00 00    	jle    801055ec <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054dc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054e1:	74 6d                	je     80105550 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801054e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054e6:	83 ec 04             	sub    $0x4,%esp
801054e9:	6a 10                	push   $0x10
801054eb:	6a 00                	push   $0x0
801054ed:	50                   	push   %eax
801054ee:	e8 ad f5 ff ff       	call   80104aa0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054f6:	6a 10                	push   $0x10
801054f8:	ff 75 c4             	pushl  -0x3c(%ebp)
801054fb:	50                   	push   %eax
801054fc:	56                   	push   %esi
801054fd:	e8 9e c5 ff ff       	call   80101aa0 <writei>
80105502:	83 c4 20             	add    $0x20,%esp
80105505:	83 f8 10             	cmp    $0x10,%eax
80105508:	0f 85 eb 00 00 00    	jne    801055f9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010550e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105513:	0f 84 97 00 00 00    	je     801055b0 <sys_unlink+0x180>
  iunlockput(dp);
80105519:	83 ec 0c             	sub    $0xc,%esp
8010551c:	56                   	push   %esi
8010551d:	e8 2e c4 ff ff       	call   80101950 <iunlockput>
  ip->nlink--;
80105522:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105527:	89 1c 24             	mov    %ebx,(%esp)
8010552a:	e8 e1 c0 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
8010552f:	89 1c 24             	mov    %ebx,(%esp)
80105532:	e8 19 c4 ff ff       	call   80101950 <iunlockput>
  end_op();
80105537:	e8 14 d7 ff ff       	call   80102c50 <end_op>
  return 0;
8010553c:	83 c4 10             	add    $0x10,%esp
8010553f:	31 c0                	xor    %eax,%eax
}
80105541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105544:	5b                   	pop    %ebx
80105545:	5e                   	pop    %esi
80105546:	5f                   	pop    %edi
80105547:	5d                   	pop    %ebp
80105548:	c3                   	ret    
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105550:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105554:	76 8d                	jbe    801054e3 <sys_unlink+0xb3>
80105556:	bf 20 00 00 00       	mov    $0x20,%edi
8010555b:	eb 0f                	jmp    8010556c <sys_unlink+0x13c>
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
80105560:	83 c7 10             	add    $0x10,%edi
80105563:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105566:	0f 83 77 ff ff ff    	jae    801054e3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010556c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010556f:	6a 10                	push   $0x10
80105571:	57                   	push   %edi
80105572:	50                   	push   %eax
80105573:	53                   	push   %ebx
80105574:	e8 27 c4 ff ff       	call   801019a0 <readi>
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	83 f8 10             	cmp    $0x10,%eax
8010557f:	75 5e                	jne    801055df <sys_unlink+0x1af>
    if(de.inum != 0)
80105581:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105586:	74 d8                	je     80105560 <sys_unlink+0x130>
    iunlockput(ip);
80105588:	83 ec 0c             	sub    $0xc,%esp
8010558b:	53                   	push   %ebx
8010558c:	e8 bf c3 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105591:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105594:	83 ec 0c             	sub    $0xc,%esp
80105597:	56                   	push   %esi
80105598:	e8 b3 c3 ff ff       	call   80101950 <iunlockput>
  end_op();
8010559d:	e8 ae d6 ff ff       	call   80102c50 <end_op>
  return -1;
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055aa:	eb 95                	jmp    80105541 <sys_unlink+0x111>
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801055b0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801055b5:	83 ec 0c             	sub    $0xc,%esp
801055b8:	56                   	push   %esi
801055b9:	e8 52 c0 ff ff       	call   80101610 <iupdate>
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	e9 53 ff ff ff       	jmp    80105519 <sys_unlink+0xe9>
    return -1;
801055c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055cb:	e9 71 ff ff ff       	jmp    80105541 <sys_unlink+0x111>
    end_op();
801055d0:	e8 7b d6 ff ff       	call   80102c50 <end_op>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055da:	e9 62 ff ff ff       	jmp    80105541 <sys_unlink+0x111>
      panic("isdirempty: readi");
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	68 78 7d 10 80       	push   $0x80107d78
801055e7:	e8 a4 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	68 66 7d 10 80       	push   $0x80107d66
801055f4:	e8 97 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801055f9:	83 ec 0c             	sub    $0xc,%esp
801055fc:	68 8a 7d 10 80       	push   $0x80107d8a
80105601:	e8 8a ad ff ff       	call   80100390 <panic>
80105606:	8d 76 00             	lea    0x0(%esi),%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <sys_open>:

int
sys_open(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105616:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105619:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010561c:	50                   	push   %eax
8010561d:	6a 00                	push   $0x0
8010561f:	e8 2c f8 ff ff       	call   80104e50 <argstr>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	0f 88 1d 01 00 00    	js     8010574c <sys_open+0x13c>
8010562f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105632:	83 ec 08             	sub    $0x8,%esp
80105635:	50                   	push   %eax
80105636:	6a 01                	push   $0x1
80105638:	e8 63 f7 ff ff       	call   80104da0 <argint>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	0f 88 04 01 00 00    	js     8010574c <sys_open+0x13c>
    return -1;

  begin_op();
80105648:	e8 93 d5 ff ff       	call   80102be0 <begin_op>

  if(omode & O_CREATE){
8010564d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105651:	0f 85 a9 00 00 00    	jne    80105700 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105657:	83 ec 0c             	sub    $0xc,%esp
8010565a:	ff 75 e0             	pushl  -0x20(%ebp)
8010565d:	e8 be c8 ff ff       	call   80101f20 <namei>
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	85 c0                	test   %eax,%eax
80105667:	89 c6                	mov    %eax,%esi
80105669:	0f 84 b2 00 00 00    	je     80105721 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010566f:	83 ec 0c             	sub    $0xc,%esp
80105672:	50                   	push   %eax
80105673:	e8 48 c0 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105680:	0f 84 aa 00 00 00    	je     80105730 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105686:	e8 25 b7 ff ff       	call   80100db0 <filealloc>
8010568b:	85 c0                	test   %eax,%eax
8010568d:	89 c7                	mov    %eax,%edi
8010568f:	0f 84 a6 00 00 00    	je     8010573b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105695:	e8 26 e2 ff ff       	call   801038c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010569a:	31 db                	xor    %ebx,%ebx
8010569c:	eb 0e                	jmp    801056ac <sys_open+0x9c>
8010569e:	66 90                	xchg   %ax,%ax
801056a0:	83 c3 01             	add    $0x1,%ebx
801056a3:	83 fb 10             	cmp    $0x10,%ebx
801056a6:	0f 84 ac 00 00 00    	je     80105758 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801056ac:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
801056b0:	85 d2                	test   %edx,%edx
801056b2:	75 ec                	jne    801056a0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056b4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801056b7:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
  iunlock(ip);
801056bb:	56                   	push   %esi
801056bc:	e8 df c0 ff ff       	call   801017a0 <iunlock>
  end_op();
801056c1:	e8 8a d5 ff ff       	call   80102c50 <end_op>

  f->type = FD_INODE;
801056c6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056cf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056d2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801056d5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056dc:	89 d0                	mov    %edx,%eax
801056de:	f7 d0                	not    %eax
801056e0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056e3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056e6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056e9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f0:	89 d8                	mov    %ebx,%eax
801056f2:	5b                   	pop    %ebx
801056f3:	5e                   	pop    %esi
801056f4:	5f                   	pop    %edi
801056f5:	5d                   	pop    %ebp
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105706:	31 c9                	xor    %ecx,%ecx
80105708:	6a 00                	push   $0x0
8010570a:	ba 02 00 00 00       	mov    $0x2,%edx
8010570f:	e8 ec f7 ff ff       	call   80104f00 <create>
    if(ip == 0){
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105719:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010571b:	0f 85 65 ff ff ff    	jne    80105686 <sys_open+0x76>
      end_op();
80105721:	e8 2a d5 ff ff       	call   80102c50 <end_op>
      return -1;
80105726:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010572b:	eb c0                	jmp    801056ed <sys_open+0xdd>
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105730:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105733:	85 c9                	test   %ecx,%ecx
80105735:	0f 84 4b ff ff ff    	je     80105686 <sys_open+0x76>
    iunlockput(ip);
8010573b:	83 ec 0c             	sub    $0xc,%esp
8010573e:	56                   	push   %esi
8010573f:	e8 0c c2 ff ff       	call   80101950 <iunlockput>
    end_op();
80105744:	e8 07 d5 ff ff       	call   80102c50 <end_op>
    return -1;
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105751:	eb 9a                	jmp    801056ed <sys_open+0xdd>
80105753:	90                   	nop
80105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	57                   	push   %edi
8010575c:	e8 0f b7 ff ff       	call   80100e70 <fileclose>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	eb d5                	jmp    8010573b <sys_open+0x12b>
80105766:	8d 76 00             	lea    0x0(%esi),%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105770 <sys_mkdir>:

int
sys_mkdir(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105776:	e8 65 d4 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010577b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577e:	83 ec 08             	sub    $0x8,%esp
80105781:	50                   	push   %eax
80105782:	6a 00                	push   $0x0
80105784:	e8 c7 f6 ff ff       	call   80104e50 <argstr>
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	85 c0                	test   %eax,%eax
8010578e:	78 30                	js     801057c0 <sys_mkdir+0x50>
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105796:	31 c9                	xor    %ecx,%ecx
80105798:	6a 00                	push   $0x0
8010579a:	ba 01 00 00 00       	mov    $0x1,%edx
8010579f:	e8 5c f7 ff ff       	call   80104f00 <create>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	74 15                	je     801057c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057ab:	83 ec 0c             	sub    $0xc,%esp
801057ae:	50                   	push   %eax
801057af:	e8 9c c1 ff ff       	call   80101950 <iunlockput>
  end_op();
801057b4:	e8 97 d4 ff ff       	call   80102c50 <end_op>
  return 0;
801057b9:	83 c4 10             	add    $0x10,%esp
801057bc:	31 c0                	xor    %eax,%eax
}
801057be:	c9                   	leave  
801057bf:	c3                   	ret    
    end_op();
801057c0:	e8 8b d4 ff ff       	call   80102c50 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ca:	c9                   	leave  
801057cb:	c3                   	ret    
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_mknod>:

int
sys_mknod(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057d6:	e8 05 d4 ff ff       	call   80102be0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057de:	83 ec 08             	sub    $0x8,%esp
801057e1:	50                   	push   %eax
801057e2:	6a 00                	push   $0x0
801057e4:	e8 67 f6 ff ff       	call   80104e50 <argstr>
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	85 c0                	test   %eax,%eax
801057ee:	78 60                	js     80105850 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057f3:	83 ec 08             	sub    $0x8,%esp
801057f6:	50                   	push   %eax
801057f7:	6a 01                	push   $0x1
801057f9:	e8 a2 f5 ff ff       	call   80104da0 <argint>
  if((argstr(0, &path)) < 0 ||
801057fe:	83 c4 10             	add    $0x10,%esp
80105801:	85 c0                	test   %eax,%eax
80105803:	78 4b                	js     80105850 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105805:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105808:	83 ec 08             	sub    $0x8,%esp
8010580b:	50                   	push   %eax
8010580c:	6a 02                	push   $0x2
8010580e:	e8 8d f5 ff ff       	call   80104da0 <argint>
     argint(1, &major) < 0 ||
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 c0                	test   %eax,%eax
80105818:	78 36                	js     80105850 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010581a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010581e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105821:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105825:	ba 03 00 00 00       	mov    $0x3,%edx
8010582a:	50                   	push   %eax
8010582b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010582e:	e8 cd f6 ff ff       	call   80104f00 <create>
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	74 16                	je     80105850 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010583a:	83 ec 0c             	sub    $0xc,%esp
8010583d:	50                   	push   %eax
8010583e:	e8 0d c1 ff ff       	call   80101950 <iunlockput>
  end_op();
80105843:	e8 08 d4 ff ff       	call   80102c50 <end_op>
  return 0;
80105848:	83 c4 10             	add    $0x10,%esp
8010584b:	31 c0                	xor    %eax,%eax
}
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    
8010584f:	90                   	nop
    end_op();
80105850:	e8 fb d3 ff ff       	call   80102c50 <end_op>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_chdir>:

int
sys_chdir(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
80105865:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  //struct proc *curproc = myproc();
  struct thread *curthread = mythread();
80105868:	e8 83 e0 ff ff       	call   801038f0 <mythread>
8010586d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010586f:	e8 6c d3 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105874:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105877:	83 ec 08             	sub    $0x8,%esp
8010587a:	50                   	push   %eax
8010587b:	6a 00                	push   $0x0
8010587d:	e8 ce f5 ff ff       	call   80104e50 <argstr>
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	85 c0                	test   %eax,%eax
80105887:	78 77                	js     80105900 <sys_chdir+0xa0>
80105889:	83 ec 0c             	sub    $0xc,%esp
8010588c:	ff 75 f4             	pushl  -0xc(%ebp)
8010588f:	e8 8c c6 ff ff       	call   80101f20 <namei>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	89 c3                	mov    %eax,%ebx
8010589b:	74 63                	je     80105900 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010589d:	83 ec 0c             	sub    $0xc,%esp
801058a0:	50                   	push   %eax
801058a1:	e8 1a be ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058ae:	75 30                	jne    801058e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	53                   	push   %ebx
801058b4:	e8 e7 be ff ff       	call   801017a0 <iunlock>
  iput(curthread->cwd);
801058b9:	58                   	pop    %eax
801058ba:	ff 76 20             	pushl  0x20(%esi)
801058bd:	e8 2e bf ff ff       	call   801017f0 <iput>
  end_op();
801058c2:	e8 89 d3 ff ff       	call   80102c50 <end_op>
  curthread->cwd = ip;
801058c7:	89 5e 20             	mov    %ebx,0x20(%esi)
  return 0;
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	31 c0                	xor    %eax,%eax
}
801058cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058d2:	5b                   	pop    %ebx
801058d3:	5e                   	pop    %esi
801058d4:	5d                   	pop    %ebp
801058d5:	c3                   	ret    
801058d6:	8d 76 00             	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	53                   	push   %ebx
801058e4:	e8 67 c0 ff ff       	call   80101950 <iunlockput>
    end_op();
801058e9:	e8 62 d3 ff ff       	call   80102c50 <end_op>
    return -1;
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f6:	eb d7                	jmp    801058cf <sys_chdir+0x6f>
801058f8:	90                   	nop
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105900:	e8 4b d3 ff ff       	call   80102c50 <end_op>
    return -1;
80105905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590a:	eb c3                	jmp    801058cf <sys_chdir+0x6f>
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_exec>:

int
sys_exec(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105916:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010591c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105922:	50                   	push   %eax
80105923:	6a 00                	push   $0x0
80105925:	e8 26 f5 ff ff       	call   80104e50 <argstr>
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	85 c0                	test   %eax,%eax
8010592f:	0f 88 87 00 00 00    	js     801059bc <sys_exec+0xac>
80105935:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010593b:	83 ec 08             	sub    $0x8,%esp
8010593e:	50                   	push   %eax
8010593f:	6a 01                	push   $0x1
80105941:	e8 5a f4 ff ff       	call   80104da0 <argint>
80105946:	83 c4 10             	add    $0x10,%esp
80105949:	85 c0                	test   %eax,%eax
8010594b:	78 6f                	js     801059bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010594d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105953:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105956:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105958:	68 80 00 00 00       	push   $0x80
8010595d:	6a 00                	push   $0x0
8010595f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105965:	50                   	push   %eax
80105966:	e8 35 f1 ff ff       	call   80104aa0 <memset>
8010596b:	83 c4 10             	add    $0x10,%esp
8010596e:	eb 2c                	jmp    8010599c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105970:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105976:	85 c0                	test   %eax,%eax
80105978:	74 56                	je     801059d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010597a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105980:	83 ec 08             	sub    $0x8,%esp
80105983:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105986:	52                   	push   %edx
80105987:	50                   	push   %eax
80105988:	e8 a3 f3 ff ff       	call   80104d30 <fetchstr>
8010598d:	83 c4 10             	add    $0x10,%esp
80105990:	85 c0                	test   %eax,%eax
80105992:	78 28                	js     801059bc <sys_exec+0xac>
  for(i=0;; i++){
80105994:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105997:	83 fb 20             	cmp    $0x20,%ebx
8010599a:	74 20                	je     801059bc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010599c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059a2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801059a9:	83 ec 08             	sub    $0x8,%esp
801059ac:	57                   	push   %edi
801059ad:	01 f0                	add    %esi,%eax
801059af:	50                   	push   %eax
801059b0:	e8 3b f3 ff ff       	call   80104cf0 <fetchint>
801059b5:	83 c4 10             	add    $0x10,%esp
801059b8:	85 c0                	test   %eax,%eax
801059ba:	79 b4                	jns    80105970 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c4:	5b                   	pop    %ebx
801059c5:	5e                   	pop    %esi
801059c6:	5f                   	pop    %edi
801059c7:	5d                   	pop    %ebp
801059c8:	c3                   	ret    
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801059d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801059d6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801059d9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059e0:	00 00 00 00 
  return exec(path, argv);
801059e4:	50                   	push   %eax
801059e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801059eb:	e8 20 b0 ff ff       	call   80100a10 <exec>
801059f0:	83 c4 10             	add    $0x10,%esp
}
801059f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059f6:	5b                   	pop    %ebx
801059f7:	5e                   	pop    %esi
801059f8:	5f                   	pop    %edi
801059f9:	5d                   	pop    %ebp
801059fa:	c3                   	ret    
801059fb:	90                   	nop
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_pipe>:

int
sys_pipe(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	56                   	push   %esi
80105a05:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a06:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a09:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a0c:	6a 08                	push   $0x8
80105a0e:	50                   	push   %eax
80105a0f:	6a 00                	push   $0x0
80105a11:	e8 da f3 ff ff       	call   80104df0 <argptr>
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	0f 88 ae 00 00 00    	js     80105acf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a21:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a24:	83 ec 08             	sub    $0x8,%esp
80105a27:	50                   	push   %eax
80105a28:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a2b:	50                   	push   %eax
80105a2c:	e8 4f d8 ff ff       	call   80103280 <pipealloc>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	85 c0                	test   %eax,%eax
80105a36:	0f 88 93 00 00 00    	js     80105acf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a3c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a3f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a41:	e8 7a de ff ff       	call   801038c0 <myproc>
80105a46:	eb 10                	jmp    80105a58 <sys_pipe+0x58>
80105a48:	90                   	nop
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a50:	83 c3 01             	add    $0x1,%ebx
80105a53:	83 fb 10             	cmp    $0x10,%ebx
80105a56:	74 60                	je     80105ab8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a58:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
80105a5c:	85 f6                	test   %esi,%esi
80105a5e:	75 f0                	jne    80105a50 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a60:	8d 73 08             	lea    0x8(%ebx),%esi
80105a63:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a66:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a69:	e8 52 de ff ff       	call   801038c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a6e:	31 d2                	xor    %edx,%edx
80105a70:	eb 0e                	jmp    80105a80 <sys_pipe+0x80>
80105a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a78:	83 c2 01             	add    $0x1,%edx
80105a7b:	83 fa 10             	cmp    $0x10,%edx
80105a7e:	74 28                	je     80105aa8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105a80:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
80105a84:	85 c9                	test   %ecx,%ecx
80105a86:	75 f0                	jne    80105a78 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105a88:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a8f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a94:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a97:	31 c0                	xor    %eax,%eax
}
80105a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a9c:	5b                   	pop    %ebx
80105a9d:	5e                   	pop    %esi
80105a9e:	5f                   	pop    %edi
80105a9f:	5d                   	pop    %ebp
80105aa0:	c3                   	ret    
80105aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105aa8:	e8 13 de ff ff       	call   801038c0 <myproc>
80105aad:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(rf);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	ff 75 e0             	pushl  -0x20(%ebp)
80105abe:	e8 ad b3 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105ac3:	58                   	pop    %eax
80105ac4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ac7:	e8 a4 b3 ff ff       	call   80100e70 <fileclose>
    return -1;
80105acc:	83 c4 10             	add    $0x10,%esp
80105acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad4:	eb c3                	jmp    80105a99 <sys_pipe+0x99>
80105ad6:	66 90                	xchg   %ax,%ax
80105ad8:	66 90                	xchg   %ax,%ax
80105ada:	66 90                	xchg   %ax,%ax
80105adc:	66 90                	xchg   %ax,%ax
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ae3:	5d                   	pop    %ebp
  return fork();
80105ae4:	e9 47 e0 ff ff       	jmp    80103b30 <fork>
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105af0 <sys_exit>:

int
sys_exit(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105af6:	e8 d5 e5 ff ff       	call   801040d0 <exit>
  return 0;  // not reached
}
80105afb:	31 c0                	xor    %eax,%eax
80105afd:	c9                   	leave  
80105afe:	c3                   	ret    
80105aff:	90                   	nop

80105b00 <sys_wait>:

int
sys_wait(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b03:	5d                   	pop    %ebp
  return wait();
80105b04:	e9 37 e8 ff ff       	jmp    80104340 <wait>
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b10 <sys_kill>:

int
sys_kill(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b19:	50                   	push   %eax
80105b1a:	6a 00                	push   $0x0
80105b1c:	e8 7f f2 ff ff       	call   80104da0 <argint>
80105b21:	83 c4 10             	add    $0x10,%esp
80105b24:	85 c0                	test   %eax,%eax
80105b26:	78 18                	js     80105b40 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b28:	83 ec 0c             	sub    $0xc,%esp
80105b2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b2e:	e8 1d ea ff ff       	call   80104550 <kill>
80105b33:	83 c4 10             	add    $0x10,%esp
}
80105b36:	c9                   	leave  
80105b37:	c3                   	ret    
80105b38:	90                   	nop
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b45:	c9                   	leave  
80105b46:	c3                   	ret    
80105b47:	89 f6                	mov    %esi,%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b50 <sys_getpid>:

int
sys_getpid(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b56:	e8 65 dd ff ff       	call   801038c0 <myproc>
80105b5b:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105b5e:	c9                   	leave  
80105b5f:	c3                   	ret    

80105b60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b6a:	50                   	push   %eax
80105b6b:	6a 00                	push   $0x0
80105b6d:	e8 2e f2 ff ff       	call   80104da0 <argint>
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	85 c0                	test   %eax,%eax
80105b77:	78 27                	js     80105ba0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b79:	e8 42 dd ff ff       	call   801038c0 <myproc>
  if(growproc(n) < 0)
80105b7e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b81:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b83:	ff 75 f4             	pushl  -0xc(%ebp)
80105b86:	e8 05 df ff ff       	call   80103a90 <growproc>
80105b8b:	83 c4 10             	add    $0x10,%esp
80105b8e:	85 c0                	test   %eax,%eax
80105b90:	78 0e                	js     80105ba0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b92:	89 d8                	mov    %ebx,%eax
80105b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b97:	c9                   	leave  
80105b98:	c3                   	ret    
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ba0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ba5:	eb eb                	jmp    80105b92 <sys_sbrk+0x32>
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bb0 <sys_sleep>:

int
sys_sleep(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bb7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bba:	50                   	push   %eax
80105bbb:	6a 00                	push   $0x0
80105bbd:	e8 de f1 ff ff       	call   80104da0 <argint>
80105bc2:	83 c4 10             	add    $0x10,%esp
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	0f 88 8a 00 00 00    	js     80105c57 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	68 a0 2c 12 80       	push   $0x80122ca0
80105bd5:	e8 a6 ed ff ff       	call   80104980 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bdd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105be0:	8b 1d e0 34 12 80    	mov    0x801234e0,%ebx
  while(ticks - ticks0 < n){
80105be6:	85 d2                	test   %edx,%edx
80105be8:	75 27                	jne    80105c11 <sys_sleep+0x61>
80105bea:	eb 54                	jmp    80105c40 <sys_sleep+0x90>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105bf0:	83 ec 08             	sub    $0x8,%esp
80105bf3:	68 a0 2c 12 80       	push   $0x80122ca0
80105bf8:	68 e0 34 12 80       	push   $0x801234e0
80105bfd:	e8 1e e3 ff ff       	call   80103f20 <sleep>
  while(ticks - ticks0 < n){
80105c02:	a1 e0 34 12 80       	mov    0x801234e0,%eax
80105c07:	83 c4 10             	add    $0x10,%esp
80105c0a:	29 d8                	sub    %ebx,%eax
80105c0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c0f:	73 2f                	jae    80105c40 <sys_sleep+0x90>
    if(myproc()->killed){
80105c11:	e8 aa dc ff ff       	call   801038c0 <myproc>
80105c16:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c19:	85 c0                	test   %eax,%eax
80105c1b:	74 d3                	je     80105bf0 <sys_sleep+0x40>
      release(&tickslock);
80105c1d:	83 ec 0c             	sub    $0xc,%esp
80105c20:	68 a0 2c 12 80       	push   $0x80122ca0
80105c25:	e8 16 ee ff ff       	call   80104a40 <release>
      return -1;
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105c32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c35:	c9                   	leave  
80105c36:	c3                   	ret    
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	68 a0 2c 12 80       	push   $0x80122ca0
80105c48:	e8 f3 ed ff ff       	call   80104a40 <release>
  return 0;
80105c4d:	83 c4 10             	add    $0x10,%esp
80105c50:	31 c0                	xor    %eax,%eax
}
80105c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    
    return -1;
80105c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5c:	eb f4                	jmp    80105c52 <sys_sleep+0xa2>
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	53                   	push   %ebx
80105c64:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c67:	68 a0 2c 12 80       	push   $0x80122ca0
80105c6c:	e8 0f ed ff ff       	call   80104980 <acquire>
  xticks = ticks;
80105c71:	8b 1d e0 34 12 80    	mov    0x801234e0,%ebx
  release(&tickslock);
80105c77:	c7 04 24 a0 2c 12 80 	movl   $0x80122ca0,(%esp)
80105c7e:	e8 bd ed ff ff       	call   80104a40 <release>
  return xticks;
}
80105c83:	89 d8                	mov    %ebx,%eax
80105c85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c88:	c9                   	leave  
80105c89:	c3                   	ret    

80105c8a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c8a:	1e                   	push   %ds
  pushl %es
80105c8b:	06                   	push   %es
  pushl %fs
80105c8c:	0f a0                	push   %fs
  pushl %gs
80105c8e:	0f a8                	push   %gs
  pushal
80105c90:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c91:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c95:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c97:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c99:	54                   	push   %esp
  call trap
80105c9a:	e8 c1 00 00 00       	call   80105d60 <trap>
  addl $4, %esp
80105c9f:	83 c4 04             	add    $0x4,%esp

80105ca2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ca2:	61                   	popa   
  popl %gs
80105ca3:	0f a9                	pop    %gs
  popl %fs
80105ca5:	0f a1                	pop    %fs
  popl %es
80105ca7:	07                   	pop    %es
  popl %ds
80105ca8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ca9:	83 c4 08             	add    $0x8,%esp
  iret
80105cac:	cf                   	iret   
80105cad:	66 90                	xchg   %ax,%ax
80105caf:	90                   	nop

80105cb0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105cb0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105cb1:	31 c0                	xor    %eax,%eax
{
80105cb3:	89 e5                	mov    %esp,%ebp
80105cb5:	83 ec 08             	sub    $0x8,%esp
80105cb8:	90                   	nop
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105cc0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105cc7:	c7 04 c5 e2 2c 12 80 	movl   $0x8e000008,-0x7fedd31e(,%eax,8)
80105cce:	08 00 00 8e 
80105cd2:	66 89 14 c5 e0 2c 12 	mov    %dx,-0x7fedd320(,%eax,8)
80105cd9:	80 
80105cda:	c1 ea 10             	shr    $0x10,%edx
80105cdd:	66 89 14 c5 e6 2c 12 	mov    %dx,-0x7fedd31a(,%eax,8)
80105ce4:	80 
  for(i = 0; i < 256; i++)
80105ce5:	83 c0 01             	add    $0x1,%eax
80105ce8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ced:	75 d1                	jne    80105cc0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cef:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105cf4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cf7:	c7 05 e2 2e 12 80 08 	movl   $0xef000008,0x80122ee2
80105cfe:	00 00 ef 
  initlock(&tickslock, "time");
80105d01:	68 99 7d 10 80       	push   $0x80107d99
80105d06:	68 a0 2c 12 80       	push   $0x80122ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d0b:	66 a3 e0 2e 12 80    	mov    %ax,0x80122ee0
80105d11:	c1 e8 10             	shr    $0x10,%eax
80105d14:	66 a3 e6 2e 12 80    	mov    %ax,0x80122ee6
  initlock(&tickslock, "time");
80105d1a:	e8 21 eb ff ff       	call   80104840 <initlock>
}
80105d1f:	83 c4 10             	add    $0x10,%esp
80105d22:	c9                   	leave  
80105d23:	c3                   	ret    
80105d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105d30 <idtinit>:

void
idtinit(void)
{
80105d30:	55                   	push   %ebp
  pd[0] = size-1;
80105d31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d36:	89 e5                	mov    %esp,%ebp
80105d38:	83 ec 10             	sub    $0x10,%esp
80105d3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d3f:	b8 e0 2c 12 80       	mov    $0x80122ce0,%eax
80105d44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d48:	c1 e8 10             	shr    $0x10,%eax
80105d4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d55:	c9                   	leave  
80105d56:	c3                   	ret    
80105d57:	89 f6                	mov    %esi,%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	57                   	push   %edi
80105d64:	56                   	push   %esi
80105d65:	53                   	push   %ebx
80105d66:	83 ec 1c             	sub    $0x1c,%esp
80105d69:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d6c:	8b 47 30             	mov    0x30(%edi),%eax
80105d6f:	83 f8 40             	cmp    $0x40,%eax
80105d72:	0f 84 f0 00 00 00    	je     80105e68 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d78:	83 e8 20             	sub    $0x20,%eax
80105d7b:	83 f8 1f             	cmp    $0x1f,%eax
80105d7e:	77 10                	ja     80105d90 <trap+0x30>
80105d80:	ff 24 85 40 7e 10 80 	jmp    *-0x7fef81c0(,%eax,4)
80105d87:	89 f6                	mov    %esi,%esi
80105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d90:	e8 2b db ff ff       	call   801038c0 <myproc>
80105d95:	85 c0                	test   %eax,%eax
80105d97:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d9a:	0f 84 14 02 00 00    	je     80105fb4 <trap+0x254>
80105da0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105da4:	0f 84 0a 02 00 00    	je     80105fb4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105daa:	0f 20 d1             	mov    %cr2,%ecx
80105dad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105db0:	e8 eb da ff ff       	call   801038a0 <cpuid>
80105db5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105db8:	8b 47 34             	mov    0x34(%edi),%eax
80105dbb:	8b 77 30             	mov    0x30(%edi),%esi
80105dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105dc1:	e8 fa da ff ff       	call   801038c0 <myproc>
80105dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105dc9:	e8 f2 da ff ff       	call   801038c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105dd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105dd4:	51                   	push   %ecx
80105dd5:	53                   	push   %ebx
80105dd6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105dd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dda:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ddd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105dde:	83 c2 60             	add    $0x60,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105de1:	52                   	push   %edx
80105de2:	ff 70 0c             	pushl  0xc(%eax)
80105de5:	68 fc 7d 10 80       	push   $0x80107dfc
80105dea:	e8 71 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105def:	83 c4 20             	add    $0x20,%esp
80105df2:	e8 c9 da ff ff       	call   801038c0 <myproc>
80105df7:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dfe:	e8 bd da ff ff       	call   801038c0 <myproc>
80105e03:	85 c0                	test   %eax,%eax
80105e05:	74 1d                	je     80105e24 <trap+0xc4>
80105e07:	e8 b4 da ff ff       	call   801038c0 <myproc>
80105e0c:	8b 50 1c             	mov    0x1c(%eax),%edx
80105e0f:	85 d2                	test   %edx,%edx
80105e11:	74 11                	je     80105e24 <trap+0xc4>
80105e13:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e17:	83 e0 03             	and    $0x3,%eax
80105e1a:	66 83 f8 03          	cmp    $0x3,%ax
80105e1e:	0f 84 4c 01 00 00    	je     80105f70 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e24:	e8 97 da ff ff       	call   801038c0 <myproc>
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	74 0b                	je     80105e38 <trap+0xd8>
80105e2d:	e8 8e da ff ff       	call   801038c0 <myproc>
80105e32:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80105e36:	74 68                	je     80105ea0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e38:	e8 83 da ff ff       	call   801038c0 <myproc>
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	74 19                	je     80105e5a <trap+0xfa>
80105e41:	e8 7a da ff ff       	call   801038c0 <myproc>
80105e46:	8b 40 1c             	mov    0x1c(%eax),%eax
80105e49:	85 c0                	test   %eax,%eax
80105e4b:	74 0d                	je     80105e5a <trap+0xfa>
80105e4d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e51:	83 e0 03             	and    $0x3,%eax
80105e54:	66 83 f8 03          	cmp    $0x3,%ax
80105e58:	74 37                	je     80105e91 <trap+0x131>
    exit();
}
80105e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e5d:	5b                   	pop    %ebx
80105e5e:	5e                   	pop    %esi
80105e5f:	5f                   	pop    %edi
80105e60:	5d                   	pop    %ebp
80105e61:	c3                   	ret    
80105e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e68:	e8 53 da ff ff       	call   801038c0 <myproc>
80105e6d:	8b 58 1c             	mov    0x1c(%eax),%ebx
80105e70:	85 db                	test   %ebx,%ebx
80105e72:	0f 85 e8 00 00 00    	jne    80105f60 <trap+0x200>
    mythread()->tf = tf;
80105e78:	e8 73 da ff ff       	call   801038f0 <mythread>
80105e7d:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
80105e80:	e8 0b f0 ff ff       	call   80104e90 <syscall>
    if(myproc()->killed)
80105e85:	e8 36 da ff ff       	call   801038c0 <myproc>
80105e8a:	8b 48 1c             	mov    0x1c(%eax),%ecx
80105e8d:	85 c9                	test   %ecx,%ecx
80105e8f:	74 c9                	je     80105e5a <trap+0xfa>
}
80105e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e94:	5b                   	pop    %ebx
80105e95:	5e                   	pop    %esi
80105e96:	5f                   	pop    %edi
80105e97:	5d                   	pop    %ebp
      exit();
80105e98:	e9 33 e2 ff ff       	jmp    801040d0 <exit>
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105ea0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105ea4:	75 92                	jne    80105e38 <trap+0xd8>
    yield();
80105ea6:	e8 25 e0 ff ff       	call   80103ed0 <yield>
80105eab:	eb 8b                	jmp    80105e38 <trap+0xd8>
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105eb0:	e8 eb d9 ff ff       	call   801038a0 <cpuid>
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	0f 84 c3 00 00 00    	je     80105f80 <trap+0x220>
    lapiceoi();
80105ebd:	e8 ce c8 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ec2:	e8 f9 d9 ff ff       	call   801038c0 <myproc>
80105ec7:	85 c0                	test   %eax,%eax
80105ec9:	0f 85 38 ff ff ff    	jne    80105e07 <trap+0xa7>
80105ecf:	e9 50 ff ff ff       	jmp    80105e24 <trap+0xc4>
80105ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ed8:	e8 73 c7 ff ff       	call   80102650 <kbdintr>
    lapiceoi();
80105edd:	e8 ae c8 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ee2:	e8 d9 d9 ff ff       	call   801038c0 <myproc>
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	0f 85 18 ff ff ff    	jne    80105e07 <trap+0xa7>
80105eef:	e9 30 ff ff ff       	jmp    80105e24 <trap+0xc4>
80105ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ef8:	e8 53 02 00 00       	call   80106150 <uartintr>
    lapiceoi();
80105efd:	e8 8e c8 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f02:	e8 b9 d9 ff ff       	call   801038c0 <myproc>
80105f07:	85 c0                	test   %eax,%eax
80105f09:	0f 85 f8 fe ff ff    	jne    80105e07 <trap+0xa7>
80105f0f:	e9 10 ff ff ff       	jmp    80105e24 <trap+0xc4>
80105f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f18:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105f1c:	8b 77 38             	mov    0x38(%edi),%esi
80105f1f:	e8 7c d9 ff ff       	call   801038a0 <cpuid>
80105f24:	56                   	push   %esi
80105f25:	53                   	push   %ebx
80105f26:	50                   	push   %eax
80105f27:	68 a4 7d 10 80       	push   $0x80107da4
80105f2c:	e8 2f a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105f31:	e8 5a c8 ff ff       	call   80102790 <lapiceoi>
    break;
80105f36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f39:	e8 82 d9 ff ff       	call   801038c0 <myproc>
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	0f 85 c1 fe ff ff    	jne    80105e07 <trap+0xa7>
80105f46:	e9 d9 fe ff ff       	jmp    80105e24 <trap+0xc4>
80105f4b:	90                   	nop
80105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f50:	e8 6b c1 ff ff       	call   801020c0 <ideintr>
80105f55:	e9 63 ff ff ff       	jmp    80105ebd <trap+0x15d>
80105f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f60:	e8 6b e1 ff ff       	call   801040d0 <exit>
80105f65:	e9 0e ff ff ff       	jmp    80105e78 <trap+0x118>
80105f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f70:	e8 5b e1 ff ff       	call   801040d0 <exit>
80105f75:	e9 aa fe ff ff       	jmp    80105e24 <trap+0xc4>
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	68 a0 2c 12 80       	push   $0x80122ca0
80105f88:	e8 f3 e9 ff ff       	call   80104980 <acquire>
      wakeup(&ticks);
80105f8d:	c7 04 24 e0 34 12 80 	movl   $0x801234e0,(%esp)
      ticks++;
80105f94:	83 05 e0 34 12 80 01 	addl   $0x1,0x801234e0
      wakeup(&ticks);
80105f9b:	e8 20 e5 ff ff       	call   801044c0 <wakeup>
      release(&tickslock);
80105fa0:	c7 04 24 a0 2c 12 80 	movl   $0x80122ca0,(%esp)
80105fa7:	e8 94 ea ff ff       	call   80104a40 <release>
80105fac:	83 c4 10             	add    $0x10,%esp
80105faf:	e9 09 ff ff ff       	jmp    80105ebd <trap+0x15d>
80105fb4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fb7:	e8 e4 d8 ff ff       	call   801038a0 <cpuid>
80105fbc:	83 ec 0c             	sub    $0xc,%esp
80105fbf:	56                   	push   %esi
80105fc0:	53                   	push   %ebx
80105fc1:	50                   	push   %eax
80105fc2:	ff 77 30             	pushl  0x30(%edi)
80105fc5:	68 c8 7d 10 80       	push   $0x80107dc8
80105fca:	e8 91 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105fcf:	83 c4 14             	add    $0x14,%esp
80105fd2:	68 9e 7d 10 80       	push   $0x80107d9e
80105fd7:	e8 b4 a3 ff ff       	call   80100390 <panic>
80105fdc:	66 90                	xchg   %ax,%ax
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fe0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
{
80105fe5:	55                   	push   %ebp
80105fe6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105fe8:	85 c0                	test   %eax,%eax
80105fea:	74 1c                	je     80106008 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fec:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ff1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ff2:	a8 01                	test   $0x1,%al
80105ff4:	74 12                	je     80106008 <uartgetc+0x28>
80105ff6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ffc:	0f b6 c0             	movzbl %al,%eax
}
80105fff:	5d                   	pop    %ebp
80106000:	c3                   	ret    
80106001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010600d:	5d                   	pop    %ebp
8010600e:	c3                   	ret    
8010600f:	90                   	nop

80106010 <uartputc.part.0>:
uartputc(int c)
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	57                   	push   %edi
80106014:	56                   	push   %esi
80106015:	53                   	push   %ebx
80106016:	89 c7                	mov    %eax,%edi
80106018:	bb 80 00 00 00       	mov    $0x80,%ebx
8010601d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106022:	83 ec 0c             	sub    $0xc,%esp
80106025:	eb 1b                	jmp    80106042 <uartputc.part.0+0x32>
80106027:	89 f6                	mov    %esi,%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	6a 0a                	push   $0xa
80106035:	e8 76 c7 ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010603a:	83 c4 10             	add    $0x10,%esp
8010603d:	83 eb 01             	sub    $0x1,%ebx
80106040:	74 07                	je     80106049 <uartputc.part.0+0x39>
80106042:	89 f2                	mov    %esi,%edx
80106044:	ec                   	in     (%dx),%al
80106045:	a8 20                	test   $0x20,%al
80106047:	74 e7                	je     80106030 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106049:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010604e:	89 f8                	mov    %edi,%eax
80106050:	ee                   	out    %al,(%dx)
}
80106051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106054:	5b                   	pop    %ebx
80106055:	5e                   	pop    %esi
80106056:	5f                   	pop    %edi
80106057:	5d                   	pop    %ebp
80106058:	c3                   	ret    
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106060 <uartinit>:
{
80106060:	55                   	push   %ebp
80106061:	31 c9                	xor    %ecx,%ecx
80106063:	89 c8                	mov    %ecx,%eax
80106065:	89 e5                	mov    %esp,%ebp
80106067:	57                   	push   %edi
80106068:	56                   	push   %esi
80106069:	53                   	push   %ebx
8010606a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010606f:	89 da                	mov    %ebx,%edx
80106071:	83 ec 0c             	sub    $0xc,%esp
80106074:	ee                   	out    %al,(%dx)
80106075:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010607a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010607f:	89 fa                	mov    %edi,%edx
80106081:	ee                   	out    %al,(%dx)
80106082:	b8 0c 00 00 00       	mov    $0xc,%eax
80106087:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010608c:	ee                   	out    %al,(%dx)
8010608d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106092:	89 c8                	mov    %ecx,%eax
80106094:	89 f2                	mov    %esi,%edx
80106096:	ee                   	out    %al,(%dx)
80106097:	b8 03 00 00 00       	mov    $0x3,%eax
8010609c:	89 fa                	mov    %edi,%edx
8010609e:	ee                   	out    %al,(%dx)
8010609f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060a4:	89 c8                	mov    %ecx,%eax
801060a6:	ee                   	out    %al,(%dx)
801060a7:	b8 01 00 00 00       	mov    $0x1,%eax
801060ac:	89 f2                	mov    %esi,%edx
801060ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060b4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060b5:	3c ff                	cmp    $0xff,%al
801060b7:	74 5a                	je     80106113 <uartinit+0xb3>
  uart = 1;
801060b9:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
801060c0:	00 00 00 
801060c3:	89 da                	mov    %ebx,%edx
801060c5:	ec                   	in     (%dx),%al
801060c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060cb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060cc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060cf:	bb c0 7e 10 80       	mov    $0x80107ec0,%ebx
  ioapicenable(IRQ_COM1, 0);
801060d4:	6a 00                	push   $0x0
801060d6:	6a 04                	push   $0x4
801060d8:	e8 33 c2 ff ff       	call   80102310 <ioapicenable>
801060dd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801060e0:	b8 78 00 00 00       	mov    $0x78,%eax
801060e5:	eb 13                	jmp    801060fa <uartinit+0x9a>
801060e7:	89 f6                	mov    %esi,%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060f0:	83 c3 01             	add    $0x1,%ebx
801060f3:	0f be 03             	movsbl (%ebx),%eax
801060f6:	84 c0                	test   %al,%al
801060f8:	74 19                	je     80106113 <uartinit+0xb3>
  if(!uart)
801060fa:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80106100:	85 d2                	test   %edx,%edx
80106102:	74 ec                	je     801060f0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106104:	83 c3 01             	add    $0x1,%ebx
80106107:	e8 04 ff ff ff       	call   80106010 <uartputc.part.0>
8010610c:	0f be 03             	movsbl (%ebx),%eax
8010610f:	84 c0                	test   %al,%al
80106111:	75 e7                	jne    801060fa <uartinit+0x9a>
}
80106113:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106116:	5b                   	pop    %ebx
80106117:	5e                   	pop    %esi
80106118:	5f                   	pop    %edi
80106119:	5d                   	pop    %ebp
8010611a:	c3                   	ret    
8010611b:	90                   	nop
8010611c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106120 <uartputc>:
  if(!uart)
80106120:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80106126:	55                   	push   %ebp
80106127:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106129:	85 d2                	test   %edx,%edx
{
8010612b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010612e:	74 10                	je     80106140 <uartputc+0x20>
}
80106130:	5d                   	pop    %ebp
80106131:	e9 da fe ff ff       	jmp    80106010 <uartputc.part.0>
80106136:	8d 76 00             	lea    0x0(%esi),%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106140:	5d                   	pop    %ebp
80106141:	c3                   	ret    
80106142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106150 <uartintr>:

void
uartintr(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106156:	68 e0 5f 10 80       	push   $0x80105fe0
8010615b:	e8 b0 a6 ff ff       	call   80100810 <consoleintr>
}
80106160:	83 c4 10             	add    $0x10,%esp
80106163:	c9                   	leave  
80106164:	c3                   	ret    

80106165 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $0
80106167:	6a 00                	push   $0x0
  jmp alltraps
80106169:	e9 1c fb ff ff       	jmp    80105c8a <alltraps>

8010616e <vector1>:
.globl vector1
vector1:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $1
80106170:	6a 01                	push   $0x1
  jmp alltraps
80106172:	e9 13 fb ff ff       	jmp    80105c8a <alltraps>

80106177 <vector2>:
.globl vector2
vector2:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $2
80106179:	6a 02                	push   $0x2
  jmp alltraps
8010617b:	e9 0a fb ff ff       	jmp    80105c8a <alltraps>

80106180 <vector3>:
.globl vector3
vector3:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $3
80106182:	6a 03                	push   $0x3
  jmp alltraps
80106184:	e9 01 fb ff ff       	jmp    80105c8a <alltraps>

80106189 <vector4>:
.globl vector4
vector4:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $4
8010618b:	6a 04                	push   $0x4
  jmp alltraps
8010618d:	e9 f8 fa ff ff       	jmp    80105c8a <alltraps>

80106192 <vector5>:
.globl vector5
vector5:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $5
80106194:	6a 05                	push   $0x5
  jmp alltraps
80106196:	e9 ef fa ff ff       	jmp    80105c8a <alltraps>

8010619b <vector6>:
.globl vector6
vector6:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $6
8010619d:	6a 06                	push   $0x6
  jmp alltraps
8010619f:	e9 e6 fa ff ff       	jmp    80105c8a <alltraps>

801061a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $7
801061a6:	6a 07                	push   $0x7
  jmp alltraps
801061a8:	e9 dd fa ff ff       	jmp    80105c8a <alltraps>

801061ad <vector8>:
.globl vector8
vector8:
  pushl $8
801061ad:	6a 08                	push   $0x8
  jmp alltraps
801061af:	e9 d6 fa ff ff       	jmp    80105c8a <alltraps>

801061b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $9
801061b6:	6a 09                	push   $0x9
  jmp alltraps
801061b8:	e9 cd fa ff ff       	jmp    80105c8a <alltraps>

801061bd <vector10>:
.globl vector10
vector10:
  pushl $10
801061bd:	6a 0a                	push   $0xa
  jmp alltraps
801061bf:	e9 c6 fa ff ff       	jmp    80105c8a <alltraps>

801061c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061c4:	6a 0b                	push   $0xb
  jmp alltraps
801061c6:	e9 bf fa ff ff       	jmp    80105c8a <alltraps>

801061cb <vector12>:
.globl vector12
vector12:
  pushl $12
801061cb:	6a 0c                	push   $0xc
  jmp alltraps
801061cd:	e9 b8 fa ff ff       	jmp    80105c8a <alltraps>

801061d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061d2:	6a 0d                	push   $0xd
  jmp alltraps
801061d4:	e9 b1 fa ff ff       	jmp    80105c8a <alltraps>

801061d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061d9:	6a 0e                	push   $0xe
  jmp alltraps
801061db:	e9 aa fa ff ff       	jmp    80105c8a <alltraps>

801061e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $15
801061e2:	6a 0f                	push   $0xf
  jmp alltraps
801061e4:	e9 a1 fa ff ff       	jmp    80105c8a <alltraps>

801061e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $16
801061eb:	6a 10                	push   $0x10
  jmp alltraps
801061ed:	e9 98 fa ff ff       	jmp    80105c8a <alltraps>

801061f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061f2:	6a 11                	push   $0x11
  jmp alltraps
801061f4:	e9 91 fa ff ff       	jmp    80105c8a <alltraps>

801061f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $18
801061fb:	6a 12                	push   $0x12
  jmp alltraps
801061fd:	e9 88 fa ff ff       	jmp    80105c8a <alltraps>

80106202 <vector19>:
.globl vector19
vector19:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $19
80106204:	6a 13                	push   $0x13
  jmp alltraps
80106206:	e9 7f fa ff ff       	jmp    80105c8a <alltraps>

8010620b <vector20>:
.globl vector20
vector20:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $20
8010620d:	6a 14                	push   $0x14
  jmp alltraps
8010620f:	e9 76 fa ff ff       	jmp    80105c8a <alltraps>

80106214 <vector21>:
.globl vector21
vector21:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $21
80106216:	6a 15                	push   $0x15
  jmp alltraps
80106218:	e9 6d fa ff ff       	jmp    80105c8a <alltraps>

8010621d <vector22>:
.globl vector22
vector22:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $22
8010621f:	6a 16                	push   $0x16
  jmp alltraps
80106221:	e9 64 fa ff ff       	jmp    80105c8a <alltraps>

80106226 <vector23>:
.globl vector23
vector23:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $23
80106228:	6a 17                	push   $0x17
  jmp alltraps
8010622a:	e9 5b fa ff ff       	jmp    80105c8a <alltraps>

8010622f <vector24>:
.globl vector24
vector24:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $24
80106231:	6a 18                	push   $0x18
  jmp alltraps
80106233:	e9 52 fa ff ff       	jmp    80105c8a <alltraps>

80106238 <vector25>:
.globl vector25
vector25:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $25
8010623a:	6a 19                	push   $0x19
  jmp alltraps
8010623c:	e9 49 fa ff ff       	jmp    80105c8a <alltraps>

80106241 <vector26>:
.globl vector26
vector26:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $26
80106243:	6a 1a                	push   $0x1a
  jmp alltraps
80106245:	e9 40 fa ff ff       	jmp    80105c8a <alltraps>

8010624a <vector27>:
.globl vector27
vector27:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $27
8010624c:	6a 1b                	push   $0x1b
  jmp alltraps
8010624e:	e9 37 fa ff ff       	jmp    80105c8a <alltraps>

80106253 <vector28>:
.globl vector28
vector28:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $28
80106255:	6a 1c                	push   $0x1c
  jmp alltraps
80106257:	e9 2e fa ff ff       	jmp    80105c8a <alltraps>

8010625c <vector29>:
.globl vector29
vector29:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $29
8010625e:	6a 1d                	push   $0x1d
  jmp alltraps
80106260:	e9 25 fa ff ff       	jmp    80105c8a <alltraps>

80106265 <vector30>:
.globl vector30
vector30:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $30
80106267:	6a 1e                	push   $0x1e
  jmp alltraps
80106269:	e9 1c fa ff ff       	jmp    80105c8a <alltraps>

8010626e <vector31>:
.globl vector31
vector31:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $31
80106270:	6a 1f                	push   $0x1f
  jmp alltraps
80106272:	e9 13 fa ff ff       	jmp    80105c8a <alltraps>

80106277 <vector32>:
.globl vector32
vector32:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $32
80106279:	6a 20                	push   $0x20
  jmp alltraps
8010627b:	e9 0a fa ff ff       	jmp    80105c8a <alltraps>

80106280 <vector33>:
.globl vector33
vector33:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $33
80106282:	6a 21                	push   $0x21
  jmp alltraps
80106284:	e9 01 fa ff ff       	jmp    80105c8a <alltraps>

80106289 <vector34>:
.globl vector34
vector34:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $34
8010628b:	6a 22                	push   $0x22
  jmp alltraps
8010628d:	e9 f8 f9 ff ff       	jmp    80105c8a <alltraps>

80106292 <vector35>:
.globl vector35
vector35:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $35
80106294:	6a 23                	push   $0x23
  jmp alltraps
80106296:	e9 ef f9 ff ff       	jmp    80105c8a <alltraps>

8010629b <vector36>:
.globl vector36
vector36:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $36
8010629d:	6a 24                	push   $0x24
  jmp alltraps
8010629f:	e9 e6 f9 ff ff       	jmp    80105c8a <alltraps>

801062a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $37
801062a6:	6a 25                	push   $0x25
  jmp alltraps
801062a8:	e9 dd f9 ff ff       	jmp    80105c8a <alltraps>

801062ad <vector38>:
.globl vector38
vector38:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $38
801062af:	6a 26                	push   $0x26
  jmp alltraps
801062b1:	e9 d4 f9 ff ff       	jmp    80105c8a <alltraps>

801062b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $39
801062b8:	6a 27                	push   $0x27
  jmp alltraps
801062ba:	e9 cb f9 ff ff       	jmp    80105c8a <alltraps>

801062bf <vector40>:
.globl vector40
vector40:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $40
801062c1:	6a 28                	push   $0x28
  jmp alltraps
801062c3:	e9 c2 f9 ff ff       	jmp    80105c8a <alltraps>

801062c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $41
801062ca:	6a 29                	push   $0x29
  jmp alltraps
801062cc:	e9 b9 f9 ff ff       	jmp    80105c8a <alltraps>

801062d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $42
801062d3:	6a 2a                	push   $0x2a
  jmp alltraps
801062d5:	e9 b0 f9 ff ff       	jmp    80105c8a <alltraps>

801062da <vector43>:
.globl vector43
vector43:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $43
801062dc:	6a 2b                	push   $0x2b
  jmp alltraps
801062de:	e9 a7 f9 ff ff       	jmp    80105c8a <alltraps>

801062e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $44
801062e5:	6a 2c                	push   $0x2c
  jmp alltraps
801062e7:	e9 9e f9 ff ff       	jmp    80105c8a <alltraps>

801062ec <vector45>:
.globl vector45
vector45:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $45
801062ee:	6a 2d                	push   $0x2d
  jmp alltraps
801062f0:	e9 95 f9 ff ff       	jmp    80105c8a <alltraps>

801062f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $46
801062f7:	6a 2e                	push   $0x2e
  jmp alltraps
801062f9:	e9 8c f9 ff ff       	jmp    80105c8a <alltraps>

801062fe <vector47>:
.globl vector47
vector47:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $47
80106300:	6a 2f                	push   $0x2f
  jmp alltraps
80106302:	e9 83 f9 ff ff       	jmp    80105c8a <alltraps>

80106307 <vector48>:
.globl vector48
vector48:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $48
80106309:	6a 30                	push   $0x30
  jmp alltraps
8010630b:	e9 7a f9 ff ff       	jmp    80105c8a <alltraps>

80106310 <vector49>:
.globl vector49
vector49:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $49
80106312:	6a 31                	push   $0x31
  jmp alltraps
80106314:	e9 71 f9 ff ff       	jmp    80105c8a <alltraps>

80106319 <vector50>:
.globl vector50
vector50:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $50
8010631b:	6a 32                	push   $0x32
  jmp alltraps
8010631d:	e9 68 f9 ff ff       	jmp    80105c8a <alltraps>

80106322 <vector51>:
.globl vector51
vector51:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $51
80106324:	6a 33                	push   $0x33
  jmp alltraps
80106326:	e9 5f f9 ff ff       	jmp    80105c8a <alltraps>

8010632b <vector52>:
.globl vector52
vector52:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $52
8010632d:	6a 34                	push   $0x34
  jmp alltraps
8010632f:	e9 56 f9 ff ff       	jmp    80105c8a <alltraps>

80106334 <vector53>:
.globl vector53
vector53:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $53
80106336:	6a 35                	push   $0x35
  jmp alltraps
80106338:	e9 4d f9 ff ff       	jmp    80105c8a <alltraps>

8010633d <vector54>:
.globl vector54
vector54:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $54
8010633f:	6a 36                	push   $0x36
  jmp alltraps
80106341:	e9 44 f9 ff ff       	jmp    80105c8a <alltraps>

80106346 <vector55>:
.globl vector55
vector55:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $55
80106348:	6a 37                	push   $0x37
  jmp alltraps
8010634a:	e9 3b f9 ff ff       	jmp    80105c8a <alltraps>

8010634f <vector56>:
.globl vector56
vector56:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $56
80106351:	6a 38                	push   $0x38
  jmp alltraps
80106353:	e9 32 f9 ff ff       	jmp    80105c8a <alltraps>

80106358 <vector57>:
.globl vector57
vector57:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $57
8010635a:	6a 39                	push   $0x39
  jmp alltraps
8010635c:	e9 29 f9 ff ff       	jmp    80105c8a <alltraps>

80106361 <vector58>:
.globl vector58
vector58:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $58
80106363:	6a 3a                	push   $0x3a
  jmp alltraps
80106365:	e9 20 f9 ff ff       	jmp    80105c8a <alltraps>

8010636a <vector59>:
.globl vector59
vector59:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $59
8010636c:	6a 3b                	push   $0x3b
  jmp alltraps
8010636e:	e9 17 f9 ff ff       	jmp    80105c8a <alltraps>

80106373 <vector60>:
.globl vector60
vector60:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $60
80106375:	6a 3c                	push   $0x3c
  jmp alltraps
80106377:	e9 0e f9 ff ff       	jmp    80105c8a <alltraps>

8010637c <vector61>:
.globl vector61
vector61:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $61
8010637e:	6a 3d                	push   $0x3d
  jmp alltraps
80106380:	e9 05 f9 ff ff       	jmp    80105c8a <alltraps>

80106385 <vector62>:
.globl vector62
vector62:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $62
80106387:	6a 3e                	push   $0x3e
  jmp alltraps
80106389:	e9 fc f8 ff ff       	jmp    80105c8a <alltraps>

8010638e <vector63>:
.globl vector63
vector63:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $63
80106390:	6a 3f                	push   $0x3f
  jmp alltraps
80106392:	e9 f3 f8 ff ff       	jmp    80105c8a <alltraps>

80106397 <vector64>:
.globl vector64
vector64:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $64
80106399:	6a 40                	push   $0x40
  jmp alltraps
8010639b:	e9 ea f8 ff ff       	jmp    80105c8a <alltraps>

801063a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $65
801063a2:	6a 41                	push   $0x41
  jmp alltraps
801063a4:	e9 e1 f8 ff ff       	jmp    80105c8a <alltraps>

801063a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $66
801063ab:	6a 42                	push   $0x42
  jmp alltraps
801063ad:	e9 d8 f8 ff ff       	jmp    80105c8a <alltraps>

801063b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $67
801063b4:	6a 43                	push   $0x43
  jmp alltraps
801063b6:	e9 cf f8 ff ff       	jmp    80105c8a <alltraps>

801063bb <vector68>:
.globl vector68
vector68:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $68
801063bd:	6a 44                	push   $0x44
  jmp alltraps
801063bf:	e9 c6 f8 ff ff       	jmp    80105c8a <alltraps>

801063c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $69
801063c6:	6a 45                	push   $0x45
  jmp alltraps
801063c8:	e9 bd f8 ff ff       	jmp    80105c8a <alltraps>

801063cd <vector70>:
.globl vector70
vector70:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $70
801063cf:	6a 46                	push   $0x46
  jmp alltraps
801063d1:	e9 b4 f8 ff ff       	jmp    80105c8a <alltraps>

801063d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $71
801063d8:	6a 47                	push   $0x47
  jmp alltraps
801063da:	e9 ab f8 ff ff       	jmp    80105c8a <alltraps>

801063df <vector72>:
.globl vector72
vector72:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $72
801063e1:	6a 48                	push   $0x48
  jmp alltraps
801063e3:	e9 a2 f8 ff ff       	jmp    80105c8a <alltraps>

801063e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $73
801063ea:	6a 49                	push   $0x49
  jmp alltraps
801063ec:	e9 99 f8 ff ff       	jmp    80105c8a <alltraps>

801063f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $74
801063f3:	6a 4a                	push   $0x4a
  jmp alltraps
801063f5:	e9 90 f8 ff ff       	jmp    80105c8a <alltraps>

801063fa <vector75>:
.globl vector75
vector75:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $75
801063fc:	6a 4b                	push   $0x4b
  jmp alltraps
801063fe:	e9 87 f8 ff ff       	jmp    80105c8a <alltraps>

80106403 <vector76>:
.globl vector76
vector76:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $76
80106405:	6a 4c                	push   $0x4c
  jmp alltraps
80106407:	e9 7e f8 ff ff       	jmp    80105c8a <alltraps>

8010640c <vector77>:
.globl vector77
vector77:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $77
8010640e:	6a 4d                	push   $0x4d
  jmp alltraps
80106410:	e9 75 f8 ff ff       	jmp    80105c8a <alltraps>

80106415 <vector78>:
.globl vector78
vector78:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $78
80106417:	6a 4e                	push   $0x4e
  jmp alltraps
80106419:	e9 6c f8 ff ff       	jmp    80105c8a <alltraps>

8010641e <vector79>:
.globl vector79
vector79:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $79
80106420:	6a 4f                	push   $0x4f
  jmp alltraps
80106422:	e9 63 f8 ff ff       	jmp    80105c8a <alltraps>

80106427 <vector80>:
.globl vector80
vector80:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $80
80106429:	6a 50                	push   $0x50
  jmp alltraps
8010642b:	e9 5a f8 ff ff       	jmp    80105c8a <alltraps>

80106430 <vector81>:
.globl vector81
vector81:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $81
80106432:	6a 51                	push   $0x51
  jmp alltraps
80106434:	e9 51 f8 ff ff       	jmp    80105c8a <alltraps>

80106439 <vector82>:
.globl vector82
vector82:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $82
8010643b:	6a 52                	push   $0x52
  jmp alltraps
8010643d:	e9 48 f8 ff ff       	jmp    80105c8a <alltraps>

80106442 <vector83>:
.globl vector83
vector83:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $83
80106444:	6a 53                	push   $0x53
  jmp alltraps
80106446:	e9 3f f8 ff ff       	jmp    80105c8a <alltraps>

8010644b <vector84>:
.globl vector84
vector84:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $84
8010644d:	6a 54                	push   $0x54
  jmp alltraps
8010644f:	e9 36 f8 ff ff       	jmp    80105c8a <alltraps>

80106454 <vector85>:
.globl vector85
vector85:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $85
80106456:	6a 55                	push   $0x55
  jmp alltraps
80106458:	e9 2d f8 ff ff       	jmp    80105c8a <alltraps>

8010645d <vector86>:
.globl vector86
vector86:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $86
8010645f:	6a 56                	push   $0x56
  jmp alltraps
80106461:	e9 24 f8 ff ff       	jmp    80105c8a <alltraps>

80106466 <vector87>:
.globl vector87
vector87:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $87
80106468:	6a 57                	push   $0x57
  jmp alltraps
8010646a:	e9 1b f8 ff ff       	jmp    80105c8a <alltraps>

8010646f <vector88>:
.globl vector88
vector88:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $88
80106471:	6a 58                	push   $0x58
  jmp alltraps
80106473:	e9 12 f8 ff ff       	jmp    80105c8a <alltraps>

80106478 <vector89>:
.globl vector89
vector89:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $89
8010647a:	6a 59                	push   $0x59
  jmp alltraps
8010647c:	e9 09 f8 ff ff       	jmp    80105c8a <alltraps>

80106481 <vector90>:
.globl vector90
vector90:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $90
80106483:	6a 5a                	push   $0x5a
  jmp alltraps
80106485:	e9 00 f8 ff ff       	jmp    80105c8a <alltraps>

8010648a <vector91>:
.globl vector91
vector91:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $91
8010648c:	6a 5b                	push   $0x5b
  jmp alltraps
8010648e:	e9 f7 f7 ff ff       	jmp    80105c8a <alltraps>

80106493 <vector92>:
.globl vector92
vector92:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $92
80106495:	6a 5c                	push   $0x5c
  jmp alltraps
80106497:	e9 ee f7 ff ff       	jmp    80105c8a <alltraps>

8010649c <vector93>:
.globl vector93
vector93:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $93
8010649e:	6a 5d                	push   $0x5d
  jmp alltraps
801064a0:	e9 e5 f7 ff ff       	jmp    80105c8a <alltraps>

801064a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $94
801064a7:	6a 5e                	push   $0x5e
  jmp alltraps
801064a9:	e9 dc f7 ff ff       	jmp    80105c8a <alltraps>

801064ae <vector95>:
.globl vector95
vector95:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $95
801064b0:	6a 5f                	push   $0x5f
  jmp alltraps
801064b2:	e9 d3 f7 ff ff       	jmp    80105c8a <alltraps>

801064b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $96
801064b9:	6a 60                	push   $0x60
  jmp alltraps
801064bb:	e9 ca f7 ff ff       	jmp    80105c8a <alltraps>

801064c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $97
801064c2:	6a 61                	push   $0x61
  jmp alltraps
801064c4:	e9 c1 f7 ff ff       	jmp    80105c8a <alltraps>

801064c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $98
801064cb:	6a 62                	push   $0x62
  jmp alltraps
801064cd:	e9 b8 f7 ff ff       	jmp    80105c8a <alltraps>

801064d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $99
801064d4:	6a 63                	push   $0x63
  jmp alltraps
801064d6:	e9 af f7 ff ff       	jmp    80105c8a <alltraps>

801064db <vector100>:
.globl vector100
vector100:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $100
801064dd:	6a 64                	push   $0x64
  jmp alltraps
801064df:	e9 a6 f7 ff ff       	jmp    80105c8a <alltraps>

801064e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $101
801064e6:	6a 65                	push   $0x65
  jmp alltraps
801064e8:	e9 9d f7 ff ff       	jmp    80105c8a <alltraps>

801064ed <vector102>:
.globl vector102
vector102:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $102
801064ef:	6a 66                	push   $0x66
  jmp alltraps
801064f1:	e9 94 f7 ff ff       	jmp    80105c8a <alltraps>

801064f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $103
801064f8:	6a 67                	push   $0x67
  jmp alltraps
801064fa:	e9 8b f7 ff ff       	jmp    80105c8a <alltraps>

801064ff <vector104>:
.globl vector104
vector104:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $104
80106501:	6a 68                	push   $0x68
  jmp alltraps
80106503:	e9 82 f7 ff ff       	jmp    80105c8a <alltraps>

80106508 <vector105>:
.globl vector105
vector105:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $105
8010650a:	6a 69                	push   $0x69
  jmp alltraps
8010650c:	e9 79 f7 ff ff       	jmp    80105c8a <alltraps>

80106511 <vector106>:
.globl vector106
vector106:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $106
80106513:	6a 6a                	push   $0x6a
  jmp alltraps
80106515:	e9 70 f7 ff ff       	jmp    80105c8a <alltraps>

8010651a <vector107>:
.globl vector107
vector107:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $107
8010651c:	6a 6b                	push   $0x6b
  jmp alltraps
8010651e:	e9 67 f7 ff ff       	jmp    80105c8a <alltraps>

80106523 <vector108>:
.globl vector108
vector108:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $108
80106525:	6a 6c                	push   $0x6c
  jmp alltraps
80106527:	e9 5e f7 ff ff       	jmp    80105c8a <alltraps>

8010652c <vector109>:
.globl vector109
vector109:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $109
8010652e:	6a 6d                	push   $0x6d
  jmp alltraps
80106530:	e9 55 f7 ff ff       	jmp    80105c8a <alltraps>

80106535 <vector110>:
.globl vector110
vector110:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $110
80106537:	6a 6e                	push   $0x6e
  jmp alltraps
80106539:	e9 4c f7 ff ff       	jmp    80105c8a <alltraps>

8010653e <vector111>:
.globl vector111
vector111:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $111
80106540:	6a 6f                	push   $0x6f
  jmp alltraps
80106542:	e9 43 f7 ff ff       	jmp    80105c8a <alltraps>

80106547 <vector112>:
.globl vector112
vector112:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $112
80106549:	6a 70                	push   $0x70
  jmp alltraps
8010654b:	e9 3a f7 ff ff       	jmp    80105c8a <alltraps>

80106550 <vector113>:
.globl vector113
vector113:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $113
80106552:	6a 71                	push   $0x71
  jmp alltraps
80106554:	e9 31 f7 ff ff       	jmp    80105c8a <alltraps>

80106559 <vector114>:
.globl vector114
vector114:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $114
8010655b:	6a 72                	push   $0x72
  jmp alltraps
8010655d:	e9 28 f7 ff ff       	jmp    80105c8a <alltraps>

80106562 <vector115>:
.globl vector115
vector115:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $115
80106564:	6a 73                	push   $0x73
  jmp alltraps
80106566:	e9 1f f7 ff ff       	jmp    80105c8a <alltraps>

8010656b <vector116>:
.globl vector116
vector116:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $116
8010656d:	6a 74                	push   $0x74
  jmp alltraps
8010656f:	e9 16 f7 ff ff       	jmp    80105c8a <alltraps>

80106574 <vector117>:
.globl vector117
vector117:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $117
80106576:	6a 75                	push   $0x75
  jmp alltraps
80106578:	e9 0d f7 ff ff       	jmp    80105c8a <alltraps>

8010657d <vector118>:
.globl vector118
vector118:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $118
8010657f:	6a 76                	push   $0x76
  jmp alltraps
80106581:	e9 04 f7 ff ff       	jmp    80105c8a <alltraps>

80106586 <vector119>:
.globl vector119
vector119:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $119
80106588:	6a 77                	push   $0x77
  jmp alltraps
8010658a:	e9 fb f6 ff ff       	jmp    80105c8a <alltraps>

8010658f <vector120>:
.globl vector120
vector120:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $120
80106591:	6a 78                	push   $0x78
  jmp alltraps
80106593:	e9 f2 f6 ff ff       	jmp    80105c8a <alltraps>

80106598 <vector121>:
.globl vector121
vector121:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $121
8010659a:	6a 79                	push   $0x79
  jmp alltraps
8010659c:	e9 e9 f6 ff ff       	jmp    80105c8a <alltraps>

801065a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $122
801065a3:	6a 7a                	push   $0x7a
  jmp alltraps
801065a5:	e9 e0 f6 ff ff       	jmp    80105c8a <alltraps>

801065aa <vector123>:
.globl vector123
vector123:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $123
801065ac:	6a 7b                	push   $0x7b
  jmp alltraps
801065ae:	e9 d7 f6 ff ff       	jmp    80105c8a <alltraps>

801065b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $124
801065b5:	6a 7c                	push   $0x7c
  jmp alltraps
801065b7:	e9 ce f6 ff ff       	jmp    80105c8a <alltraps>

801065bc <vector125>:
.globl vector125
vector125:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $125
801065be:	6a 7d                	push   $0x7d
  jmp alltraps
801065c0:	e9 c5 f6 ff ff       	jmp    80105c8a <alltraps>

801065c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $126
801065c7:	6a 7e                	push   $0x7e
  jmp alltraps
801065c9:	e9 bc f6 ff ff       	jmp    80105c8a <alltraps>

801065ce <vector127>:
.globl vector127
vector127:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $127
801065d0:	6a 7f                	push   $0x7f
  jmp alltraps
801065d2:	e9 b3 f6 ff ff       	jmp    80105c8a <alltraps>

801065d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $128
801065d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065de:	e9 a7 f6 ff ff       	jmp    80105c8a <alltraps>

801065e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $129
801065e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065ea:	e9 9b f6 ff ff       	jmp    80105c8a <alltraps>

801065ef <vector130>:
.globl vector130
vector130:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $130
801065f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065f6:	e9 8f f6 ff ff       	jmp    80105c8a <alltraps>

801065fb <vector131>:
.globl vector131
vector131:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $131
801065fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106602:	e9 83 f6 ff ff       	jmp    80105c8a <alltraps>

80106607 <vector132>:
.globl vector132
vector132:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $132
80106609:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010660e:	e9 77 f6 ff ff       	jmp    80105c8a <alltraps>

80106613 <vector133>:
.globl vector133
vector133:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $133
80106615:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010661a:	e9 6b f6 ff ff       	jmp    80105c8a <alltraps>

8010661f <vector134>:
.globl vector134
vector134:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $134
80106621:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106626:	e9 5f f6 ff ff       	jmp    80105c8a <alltraps>

8010662b <vector135>:
.globl vector135
vector135:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $135
8010662d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106632:	e9 53 f6 ff ff       	jmp    80105c8a <alltraps>

80106637 <vector136>:
.globl vector136
vector136:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $136
80106639:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010663e:	e9 47 f6 ff ff       	jmp    80105c8a <alltraps>

80106643 <vector137>:
.globl vector137
vector137:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $137
80106645:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010664a:	e9 3b f6 ff ff       	jmp    80105c8a <alltraps>

8010664f <vector138>:
.globl vector138
vector138:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $138
80106651:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106656:	e9 2f f6 ff ff       	jmp    80105c8a <alltraps>

8010665b <vector139>:
.globl vector139
vector139:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $139
8010665d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106662:	e9 23 f6 ff ff       	jmp    80105c8a <alltraps>

80106667 <vector140>:
.globl vector140
vector140:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $140
80106669:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010666e:	e9 17 f6 ff ff       	jmp    80105c8a <alltraps>

80106673 <vector141>:
.globl vector141
vector141:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $141
80106675:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010667a:	e9 0b f6 ff ff       	jmp    80105c8a <alltraps>

8010667f <vector142>:
.globl vector142
vector142:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $142
80106681:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106686:	e9 ff f5 ff ff       	jmp    80105c8a <alltraps>

8010668b <vector143>:
.globl vector143
vector143:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $143
8010668d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106692:	e9 f3 f5 ff ff       	jmp    80105c8a <alltraps>

80106697 <vector144>:
.globl vector144
vector144:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $144
80106699:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010669e:	e9 e7 f5 ff ff       	jmp    80105c8a <alltraps>

801066a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $145
801066a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066aa:	e9 db f5 ff ff       	jmp    80105c8a <alltraps>

801066af <vector146>:
.globl vector146
vector146:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $146
801066b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801066b6:	e9 cf f5 ff ff       	jmp    80105c8a <alltraps>

801066bb <vector147>:
.globl vector147
vector147:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $147
801066bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066c2:	e9 c3 f5 ff ff       	jmp    80105c8a <alltraps>

801066c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $148
801066c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ce:	e9 b7 f5 ff ff       	jmp    80105c8a <alltraps>

801066d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $149
801066d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066da:	e9 ab f5 ff ff       	jmp    80105c8a <alltraps>

801066df <vector150>:
.globl vector150
vector150:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $150
801066e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066e6:	e9 9f f5 ff ff       	jmp    80105c8a <alltraps>

801066eb <vector151>:
.globl vector151
vector151:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $151
801066ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066f2:	e9 93 f5 ff ff       	jmp    80105c8a <alltraps>

801066f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $152
801066f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066fe:	e9 87 f5 ff ff       	jmp    80105c8a <alltraps>

80106703 <vector153>:
.globl vector153
vector153:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $153
80106705:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010670a:	e9 7b f5 ff ff       	jmp    80105c8a <alltraps>

8010670f <vector154>:
.globl vector154
vector154:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $154
80106711:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106716:	e9 6f f5 ff ff       	jmp    80105c8a <alltraps>

8010671b <vector155>:
.globl vector155
vector155:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $155
8010671d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106722:	e9 63 f5 ff ff       	jmp    80105c8a <alltraps>

80106727 <vector156>:
.globl vector156
vector156:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $156
80106729:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010672e:	e9 57 f5 ff ff       	jmp    80105c8a <alltraps>

80106733 <vector157>:
.globl vector157
vector157:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $157
80106735:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010673a:	e9 4b f5 ff ff       	jmp    80105c8a <alltraps>

8010673f <vector158>:
.globl vector158
vector158:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $158
80106741:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106746:	e9 3f f5 ff ff       	jmp    80105c8a <alltraps>

8010674b <vector159>:
.globl vector159
vector159:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $159
8010674d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106752:	e9 33 f5 ff ff       	jmp    80105c8a <alltraps>

80106757 <vector160>:
.globl vector160
vector160:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $160
80106759:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010675e:	e9 27 f5 ff ff       	jmp    80105c8a <alltraps>

80106763 <vector161>:
.globl vector161
vector161:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $161
80106765:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010676a:	e9 1b f5 ff ff       	jmp    80105c8a <alltraps>

8010676f <vector162>:
.globl vector162
vector162:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $162
80106771:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106776:	e9 0f f5 ff ff       	jmp    80105c8a <alltraps>

8010677b <vector163>:
.globl vector163
vector163:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $163
8010677d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106782:	e9 03 f5 ff ff       	jmp    80105c8a <alltraps>

80106787 <vector164>:
.globl vector164
vector164:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $164
80106789:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010678e:	e9 f7 f4 ff ff       	jmp    80105c8a <alltraps>

80106793 <vector165>:
.globl vector165
vector165:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $165
80106795:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010679a:	e9 eb f4 ff ff       	jmp    80105c8a <alltraps>

8010679f <vector166>:
.globl vector166
vector166:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $166
801067a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067a6:	e9 df f4 ff ff       	jmp    80105c8a <alltraps>

801067ab <vector167>:
.globl vector167
vector167:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $167
801067ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801067b2:	e9 d3 f4 ff ff       	jmp    80105c8a <alltraps>

801067b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $168
801067b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801067be:	e9 c7 f4 ff ff       	jmp    80105c8a <alltraps>

801067c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $169
801067c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067ca:	e9 bb f4 ff ff       	jmp    80105c8a <alltraps>

801067cf <vector170>:
.globl vector170
vector170:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $170
801067d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067d6:	e9 af f4 ff ff       	jmp    80105c8a <alltraps>

801067db <vector171>:
.globl vector171
vector171:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $171
801067dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067e2:	e9 a3 f4 ff ff       	jmp    80105c8a <alltraps>

801067e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $172
801067e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067ee:	e9 97 f4 ff ff       	jmp    80105c8a <alltraps>

801067f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $173
801067f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067fa:	e9 8b f4 ff ff       	jmp    80105c8a <alltraps>

801067ff <vector174>:
.globl vector174
vector174:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $174
80106801:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106806:	e9 7f f4 ff ff       	jmp    80105c8a <alltraps>

8010680b <vector175>:
.globl vector175
vector175:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $175
8010680d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106812:	e9 73 f4 ff ff       	jmp    80105c8a <alltraps>

80106817 <vector176>:
.globl vector176
vector176:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $176
80106819:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010681e:	e9 67 f4 ff ff       	jmp    80105c8a <alltraps>

80106823 <vector177>:
.globl vector177
vector177:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $177
80106825:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010682a:	e9 5b f4 ff ff       	jmp    80105c8a <alltraps>

8010682f <vector178>:
.globl vector178
vector178:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $178
80106831:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106836:	e9 4f f4 ff ff       	jmp    80105c8a <alltraps>

8010683b <vector179>:
.globl vector179
vector179:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $179
8010683d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106842:	e9 43 f4 ff ff       	jmp    80105c8a <alltraps>

80106847 <vector180>:
.globl vector180
vector180:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $180
80106849:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010684e:	e9 37 f4 ff ff       	jmp    80105c8a <alltraps>

80106853 <vector181>:
.globl vector181
vector181:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $181
80106855:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010685a:	e9 2b f4 ff ff       	jmp    80105c8a <alltraps>

8010685f <vector182>:
.globl vector182
vector182:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $182
80106861:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106866:	e9 1f f4 ff ff       	jmp    80105c8a <alltraps>

8010686b <vector183>:
.globl vector183
vector183:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $183
8010686d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106872:	e9 13 f4 ff ff       	jmp    80105c8a <alltraps>

80106877 <vector184>:
.globl vector184
vector184:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $184
80106879:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010687e:	e9 07 f4 ff ff       	jmp    80105c8a <alltraps>

80106883 <vector185>:
.globl vector185
vector185:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $185
80106885:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010688a:	e9 fb f3 ff ff       	jmp    80105c8a <alltraps>

8010688f <vector186>:
.globl vector186
vector186:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $186
80106891:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106896:	e9 ef f3 ff ff       	jmp    80105c8a <alltraps>

8010689b <vector187>:
.globl vector187
vector187:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $187
8010689d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068a2:	e9 e3 f3 ff ff       	jmp    80105c8a <alltraps>

801068a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $188
801068a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068ae:	e9 d7 f3 ff ff       	jmp    80105c8a <alltraps>

801068b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $189
801068b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801068ba:	e9 cb f3 ff ff       	jmp    80105c8a <alltraps>

801068bf <vector190>:
.globl vector190
vector190:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $190
801068c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068c6:	e9 bf f3 ff ff       	jmp    80105c8a <alltraps>

801068cb <vector191>:
.globl vector191
vector191:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $191
801068cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068d2:	e9 b3 f3 ff ff       	jmp    80105c8a <alltraps>

801068d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $192
801068d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068de:	e9 a7 f3 ff ff       	jmp    80105c8a <alltraps>

801068e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $193
801068e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068ea:	e9 9b f3 ff ff       	jmp    80105c8a <alltraps>

801068ef <vector194>:
.globl vector194
vector194:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $194
801068f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068f6:	e9 8f f3 ff ff       	jmp    80105c8a <alltraps>

801068fb <vector195>:
.globl vector195
vector195:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $195
801068fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106902:	e9 83 f3 ff ff       	jmp    80105c8a <alltraps>

80106907 <vector196>:
.globl vector196
vector196:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $196
80106909:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010690e:	e9 77 f3 ff ff       	jmp    80105c8a <alltraps>

80106913 <vector197>:
.globl vector197
vector197:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $197
80106915:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010691a:	e9 6b f3 ff ff       	jmp    80105c8a <alltraps>

8010691f <vector198>:
.globl vector198
vector198:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $198
80106921:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106926:	e9 5f f3 ff ff       	jmp    80105c8a <alltraps>

8010692b <vector199>:
.globl vector199
vector199:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $199
8010692d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106932:	e9 53 f3 ff ff       	jmp    80105c8a <alltraps>

80106937 <vector200>:
.globl vector200
vector200:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $200
80106939:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010693e:	e9 47 f3 ff ff       	jmp    80105c8a <alltraps>

80106943 <vector201>:
.globl vector201
vector201:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $201
80106945:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010694a:	e9 3b f3 ff ff       	jmp    80105c8a <alltraps>

8010694f <vector202>:
.globl vector202
vector202:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $202
80106951:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106956:	e9 2f f3 ff ff       	jmp    80105c8a <alltraps>

8010695b <vector203>:
.globl vector203
vector203:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $203
8010695d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106962:	e9 23 f3 ff ff       	jmp    80105c8a <alltraps>

80106967 <vector204>:
.globl vector204
vector204:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $204
80106969:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010696e:	e9 17 f3 ff ff       	jmp    80105c8a <alltraps>

80106973 <vector205>:
.globl vector205
vector205:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $205
80106975:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010697a:	e9 0b f3 ff ff       	jmp    80105c8a <alltraps>

8010697f <vector206>:
.globl vector206
vector206:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $206
80106981:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106986:	e9 ff f2 ff ff       	jmp    80105c8a <alltraps>

8010698b <vector207>:
.globl vector207
vector207:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $207
8010698d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106992:	e9 f3 f2 ff ff       	jmp    80105c8a <alltraps>

80106997 <vector208>:
.globl vector208
vector208:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $208
80106999:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010699e:	e9 e7 f2 ff ff       	jmp    80105c8a <alltraps>

801069a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $209
801069a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069aa:	e9 db f2 ff ff       	jmp    80105c8a <alltraps>

801069af <vector210>:
.globl vector210
vector210:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $210
801069b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801069b6:	e9 cf f2 ff ff       	jmp    80105c8a <alltraps>

801069bb <vector211>:
.globl vector211
vector211:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $211
801069bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069c2:	e9 c3 f2 ff ff       	jmp    80105c8a <alltraps>

801069c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $212
801069c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ce:	e9 b7 f2 ff ff       	jmp    80105c8a <alltraps>

801069d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $213
801069d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069da:	e9 ab f2 ff ff       	jmp    80105c8a <alltraps>

801069df <vector214>:
.globl vector214
vector214:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $214
801069e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069e6:	e9 9f f2 ff ff       	jmp    80105c8a <alltraps>

801069eb <vector215>:
.globl vector215
vector215:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $215
801069ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069f2:	e9 93 f2 ff ff       	jmp    80105c8a <alltraps>

801069f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $216
801069f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069fe:	e9 87 f2 ff ff       	jmp    80105c8a <alltraps>

80106a03 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $217
80106a05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a0a:	e9 7b f2 ff ff       	jmp    80105c8a <alltraps>

80106a0f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $218
80106a11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a16:	e9 6f f2 ff ff       	jmp    80105c8a <alltraps>

80106a1b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $219
80106a1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a22:	e9 63 f2 ff ff       	jmp    80105c8a <alltraps>

80106a27 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $220
80106a29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a2e:	e9 57 f2 ff ff       	jmp    80105c8a <alltraps>

80106a33 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $221
80106a35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a3a:	e9 4b f2 ff ff       	jmp    80105c8a <alltraps>

80106a3f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $222
80106a41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a46:	e9 3f f2 ff ff       	jmp    80105c8a <alltraps>

80106a4b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $223
80106a4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a52:	e9 33 f2 ff ff       	jmp    80105c8a <alltraps>

80106a57 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $224
80106a59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a5e:	e9 27 f2 ff ff       	jmp    80105c8a <alltraps>

80106a63 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $225
80106a65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a6a:	e9 1b f2 ff ff       	jmp    80105c8a <alltraps>

80106a6f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $226
80106a71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a76:	e9 0f f2 ff ff       	jmp    80105c8a <alltraps>

80106a7b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $227
80106a7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a82:	e9 03 f2 ff ff       	jmp    80105c8a <alltraps>

80106a87 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $228
80106a89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a8e:	e9 f7 f1 ff ff       	jmp    80105c8a <alltraps>

80106a93 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $229
80106a95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a9a:	e9 eb f1 ff ff       	jmp    80105c8a <alltraps>

80106a9f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $230
80106aa1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106aa6:	e9 df f1 ff ff       	jmp    80105c8a <alltraps>

80106aab <vector231>:
.globl vector231
vector231:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $231
80106aad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ab2:	e9 d3 f1 ff ff       	jmp    80105c8a <alltraps>

80106ab7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $232
80106ab9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106abe:	e9 c7 f1 ff ff       	jmp    80105c8a <alltraps>

80106ac3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $233
80106ac5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aca:	e9 bb f1 ff ff       	jmp    80105c8a <alltraps>

80106acf <vector234>:
.globl vector234
vector234:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $234
80106ad1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ad6:	e9 af f1 ff ff       	jmp    80105c8a <alltraps>

80106adb <vector235>:
.globl vector235
vector235:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $235
80106add:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ae2:	e9 a3 f1 ff ff       	jmp    80105c8a <alltraps>

80106ae7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $236
80106ae9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106aee:	e9 97 f1 ff ff       	jmp    80105c8a <alltraps>

80106af3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $237
80106af5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106afa:	e9 8b f1 ff ff       	jmp    80105c8a <alltraps>

80106aff <vector238>:
.globl vector238
vector238:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $238
80106b01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b06:	e9 7f f1 ff ff       	jmp    80105c8a <alltraps>

80106b0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $239
80106b0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b12:	e9 73 f1 ff ff       	jmp    80105c8a <alltraps>

80106b17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $240
80106b19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b1e:	e9 67 f1 ff ff       	jmp    80105c8a <alltraps>

80106b23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $241
80106b25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b2a:	e9 5b f1 ff ff       	jmp    80105c8a <alltraps>

80106b2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $242
80106b31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b36:	e9 4f f1 ff ff       	jmp    80105c8a <alltraps>

80106b3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $243
80106b3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b42:	e9 43 f1 ff ff       	jmp    80105c8a <alltraps>

80106b47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $244
80106b49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b4e:	e9 37 f1 ff ff       	jmp    80105c8a <alltraps>

80106b53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $245
80106b55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b5a:	e9 2b f1 ff ff       	jmp    80105c8a <alltraps>

80106b5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $246
80106b61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b66:	e9 1f f1 ff ff       	jmp    80105c8a <alltraps>

80106b6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $247
80106b6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b72:	e9 13 f1 ff ff       	jmp    80105c8a <alltraps>

80106b77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $248
80106b79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b7e:	e9 07 f1 ff ff       	jmp    80105c8a <alltraps>

80106b83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $249
80106b85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b8a:	e9 fb f0 ff ff       	jmp    80105c8a <alltraps>

80106b8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $250
80106b91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b96:	e9 ef f0 ff ff       	jmp    80105c8a <alltraps>

80106b9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $251
80106b9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ba2:	e9 e3 f0 ff ff       	jmp    80105c8a <alltraps>

80106ba7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $252
80106ba9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bae:	e9 d7 f0 ff ff       	jmp    80105c8a <alltraps>

80106bb3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $253
80106bb5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106bba:	e9 cb f0 ff ff       	jmp    80105c8a <alltraps>

80106bbf <vector254>:
.globl vector254
vector254:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $254
80106bc1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106bc6:	e9 bf f0 ff ff       	jmp    80105c8a <alltraps>

80106bcb <vector255>:
.globl vector255
vector255:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $255
80106bcd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bd2:	e9 b3 f0 ff ff       	jmp    80105c8a <alltraps>
80106bd7:	66 90                	xchg   %ax,%ax
80106bd9:	66 90                	xchg   %ax,%ax
80106bdb:	66 90                	xchg   %ax,%ax
80106bdd:	66 90                	xchg   %ax,%ax
80106bdf:	90                   	nop

80106be0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106be6:	89 d3                	mov    %edx,%ebx
{
80106be8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106bea:	c1 eb 16             	shr    $0x16,%ebx
80106bed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106bf0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106bf3:	8b 06                	mov    (%esi),%eax
80106bf5:	a8 01                	test   $0x1,%al
80106bf7:	74 27                	je     80106c20 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bf9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bfe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c04:	c1 ef 0a             	shr    $0xa,%edi
}
80106c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c0a:	89 fa                	mov    %edi,%edx
80106c0c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c12:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106c15:	5b                   	pop    %ebx
80106c16:	5e                   	pop    %esi
80106c17:	5f                   	pop    %edi
80106c18:	5d                   	pop    %ebp
80106c19:	c3                   	ret    
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c20:	85 c9                	test   %ecx,%ecx
80106c22:	74 2c                	je     80106c50 <walkpgdir+0x70>
80106c24:	e8 d7 b8 ff ff       	call   80102500 <kalloc>
80106c29:	85 c0                	test   %eax,%eax
80106c2b:	89 c3                	mov    %eax,%ebx
80106c2d:	74 21                	je     80106c50 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c2f:	83 ec 04             	sub    $0x4,%esp
80106c32:	68 00 10 00 00       	push   $0x1000
80106c37:	6a 00                	push   $0x0
80106c39:	50                   	push   %eax
80106c3a:	e8 61 de ff ff       	call   80104aa0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c3f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c45:	83 c4 10             	add    $0x10,%esp
80106c48:	83 c8 07             	or     $0x7,%eax
80106c4b:	89 06                	mov    %eax,(%esi)
80106c4d:	eb b5                	jmp    80106c04 <walkpgdir+0x24>
80106c4f:	90                   	nop
}
80106c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c53:	31 c0                	xor    %eax,%eax
}
80106c55:	5b                   	pop    %ebx
80106c56:	5e                   	pop    %esi
80106c57:	5f                   	pop    %edi
80106c58:	5d                   	pop    %ebp
80106c59:	c3                   	ret    
80106c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c60 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c66:	89 d3                	mov    %edx,%ebx
80106c68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c6e:	83 ec 1c             	sub    $0x1c,%esp
80106c71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c74:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c78:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c80:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c83:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c86:	29 df                	sub    %ebx,%edi
80106c88:	83 c8 01             	or     $0x1,%eax
80106c8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c8e:	eb 15                	jmp    80106ca5 <mappages+0x45>
    if(*pte & PTE_P)
80106c90:	f6 00 01             	testb  $0x1,(%eax)
80106c93:	75 45                	jne    80106cda <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c95:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c98:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c9b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c9d:	74 31                	je     80106cd0 <mappages+0x70>
      break;
    a += PGSIZE;
80106c9f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ca5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ca8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106cad:	89 da                	mov    %ebx,%edx
80106caf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106cb2:	e8 29 ff ff ff       	call   80106be0 <walkpgdir>
80106cb7:	85 c0                	test   %eax,%eax
80106cb9:	75 d5                	jne    80106c90 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc3:	5b                   	pop    %ebx
80106cc4:	5e                   	pop    %esi
80106cc5:	5f                   	pop    %edi
80106cc6:	5d                   	pop    %ebp
80106cc7:	c3                   	ret    
80106cc8:	90                   	nop
80106cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cd3:	31 c0                	xor    %eax,%eax
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret    
      panic("remap");
80106cda:	83 ec 0c             	sub    $0xc,%esp
80106cdd:	68 c8 7e 10 80       	push   $0x80107ec8
80106ce2:	e8 a9 96 ff ff       	call   80100390 <panic>
80106ce7:	89 f6                	mov    %esi,%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cf0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106cf6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cfc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106cfe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d04:	83 ec 1c             	sub    $0x1c,%esp
80106d07:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d0a:	39 d3                	cmp    %edx,%ebx
80106d0c:	73 66                	jae    80106d74 <deallocuvm.part.0+0x84>
80106d0e:	89 d6                	mov    %edx,%esi
80106d10:	eb 3d                	jmp    80106d4f <deallocuvm.part.0+0x5f>
80106d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106d18:	8b 10                	mov    (%eax),%edx
80106d1a:	f6 c2 01             	test   $0x1,%dl
80106d1d:	74 26                	je     80106d45 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106d1f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d25:	74 58                	je     80106d7f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106d27:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d2a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106d33:	52                   	push   %edx
80106d34:	e8 17 b6 ff ff       	call   80102350 <kfree>
      *pte = 0;
80106d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d3c:	83 c4 10             	add    $0x10,%esp
80106d3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106d45:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d4b:	39 f3                	cmp    %esi,%ebx
80106d4d:	73 25                	jae    80106d74 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106d4f:	31 c9                	xor    %ecx,%ecx
80106d51:	89 da                	mov    %ebx,%edx
80106d53:	89 f8                	mov    %edi,%eax
80106d55:	e8 86 fe ff ff       	call   80106be0 <walkpgdir>
    if(!pte)
80106d5a:	85 c0                	test   %eax,%eax
80106d5c:	75 ba                	jne    80106d18 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d5e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d64:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d70:	39 f3                	cmp    %esi,%ebx
80106d72:	72 db                	jb     80106d4f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d7a:	5b                   	pop    %ebx
80106d7b:	5e                   	pop    %esi
80106d7c:	5f                   	pop    %edi
80106d7d:	5d                   	pop    %ebp
80106d7e:	c3                   	ret    
        panic("kfree");
80106d7f:	83 ec 0c             	sub    $0xc,%esp
80106d82:	68 96 77 10 80       	push   $0x80107796
80106d87:	e8 04 96 ff ff       	call   80100390 <panic>
80106d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d90 <seginit>:
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d96:	e8 05 cb ff ff       	call   801038a0 <cpuid>
80106d9b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
80106da1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106da6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106daa:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106db1:	ff 00 00 
80106db4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106dbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106dbe:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106dc5:	ff 00 00 
80106dc8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106dcf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106dd2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106dd9:	ff 00 00 
80106ddc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106de3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106de6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106ded:	ff 00 00 
80106df0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106df7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dfa:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106dff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e03:	c1 e8 10             	shr    $0x10,%eax
80106e06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e0d:	0f 01 10             	lgdtl  (%eax)
}
80106e10:	c9                   	leave  
80106e11:	c3                   	ret    
80106e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e20:	a1 e4 34 12 80       	mov    0x801234e4,%eax
{
80106e25:	55                   	push   %ebp
80106e26:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e28:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e2d:	0f 22 d8             	mov    %eax,%cr3
}
80106e30:	5d                   	pop    %ebp
80106e31:	c3                   	ret    
80106e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <switchuvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106e4c:	85 db                	test   %ebx,%ebx
80106e4e:	0f 84 d7 00 00 00    	je     80106f2b <switchuvm+0xeb>
  if(p->mainThread->tkstack == 0)
80106e54:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80106e5a:	8b 40 04             	mov    0x4(%eax),%eax
80106e5d:	85 c0                	test   %eax,%eax
80106e5f:	0f 84 e0 00 00 00    	je     80106f45 <switchuvm+0x105>
  if(p->pgdir == 0)
80106e65:	8b 43 04             	mov    0x4(%ebx),%eax
80106e68:	85 c0                	test   %eax,%eax
80106e6a:	0f 84 c8 00 00 00    	je     80106f38 <switchuvm+0xf8>
  pushcli();
80106e70:	e8 3b da ff ff       	call   801048b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e75:	e8 a6 c9 ff ff       	call   80103820 <mycpu>
80106e7a:	89 c6                	mov    %eax,%esi
80106e7c:	e8 9f c9 ff ff       	call   80103820 <mycpu>
80106e81:	89 c7                	mov    %eax,%edi
80106e83:	e8 98 c9 ff ff       	call   80103820 <mycpu>
80106e88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e8b:	83 c7 08             	add    $0x8,%edi
80106e8e:	e8 8d c9 ff ff       	call   80103820 <mycpu>
80106e93:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e96:	83 c0 08             	add    $0x8,%eax
80106e99:	ba 67 00 00 00       	mov    $0x67,%edx
80106e9e:	c1 e8 18             	shr    $0x18,%eax
80106ea1:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106ea8:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106eaf:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106eb5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eba:	83 c1 08             	add    $0x8,%ecx
80106ebd:	c1 e9 10             	shr    $0x10,%ecx
80106ec0:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106ec6:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ecb:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ed2:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106ed7:	e8 44 c9 ff ff       	call   80103820 <mycpu>
80106edc:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ee3:	e8 38 c9 ff ff       	call   80103820 <mycpu>
80106ee8:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
80106eec:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80106ef2:	8b 70 04             	mov    0x4(%eax),%esi
80106ef5:	e8 26 c9 ff ff       	call   80103820 <mycpu>
80106efa:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f00:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f03:	e8 18 c9 ff ff       	call   80103820 <mycpu>
80106f08:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f0c:	b8 28 00 00 00       	mov    $0x28,%eax
80106f11:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f14:	8b 43 04             	mov    0x4(%ebx),%eax
80106f17:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f1c:	0f 22 d8             	mov    %eax,%cr3
}
80106f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f22:	5b                   	pop    %ebx
80106f23:	5e                   	pop    %esi
80106f24:	5f                   	pop    %edi
80106f25:	5d                   	pop    %ebp
  popcli();
80106f26:	e9 c5 d9 ff ff       	jmp    801048f0 <popcli>
    panic("switchuvm: no process");
80106f2b:	83 ec 0c             	sub    $0xc,%esp
80106f2e:	68 ce 7e 10 80       	push   $0x80107ece
80106f33:	e8 58 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106f38:	83 ec 0c             	sub    $0xc,%esp
80106f3b:	68 f9 7e 10 80       	push   $0x80107ef9
80106f40:	e8 4b 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106f45:	83 ec 0c             	sub    $0xc,%esp
80106f48:	68 e4 7e 10 80       	push   $0x80107ee4
80106f4d:	e8 3e 94 ff ff       	call   80100390 <panic>
80106f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f60 <inituvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 75 10             	mov    0x10(%ebp),%esi
80106f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f72:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f7b:	77 49                	ja     80106fc6 <inituvm+0x66>
  mem = kalloc();
80106f7d:	e8 7e b5 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80106f82:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f85:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f87:	68 00 10 00 00       	push   $0x1000
80106f8c:	6a 00                	push   $0x0
80106f8e:	50                   	push   %eax
80106f8f:	e8 0c db ff ff       	call   80104aa0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f94:	58                   	pop    %eax
80106f95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fa0:	5a                   	pop    %edx
80106fa1:	6a 06                	push   $0x6
80106fa3:	50                   	push   %eax
80106fa4:	31 d2                	xor    %edx,%edx
80106fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fa9:	e8 b2 fc ff ff       	call   80106c60 <mappages>
  memmove(mem, init, sz);
80106fae:	89 75 10             	mov    %esi,0x10(%ebp)
80106fb1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106fb4:	83 c4 10             	add    $0x10,%esp
80106fb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fbd:	5b                   	pop    %ebx
80106fbe:	5e                   	pop    %esi
80106fbf:	5f                   	pop    %edi
80106fc0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106fc1:	e9 8a db ff ff       	jmp    80104b50 <memmove>
    panic("inituvm: more than a page");
80106fc6:	83 ec 0c             	sub    $0xc,%esp
80106fc9:	68 0d 7f 10 80       	push   $0x80107f0d
80106fce:	e8 bd 93 ff ff       	call   80100390 <panic>
80106fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fe0 <loaduvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106fe9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ff0:	0f 85 91 00 00 00    	jne    80107087 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106ff6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ff9:	31 db                	xor    %ebx,%ebx
80106ffb:	85 f6                	test   %esi,%esi
80106ffd:	75 1a                	jne    80107019 <loaduvm+0x39>
80106fff:	eb 6f                	jmp    80107070 <loaduvm+0x90>
80107001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107008:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010700e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107014:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107017:	76 57                	jbe    80107070 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107019:	8b 55 0c             	mov    0xc(%ebp),%edx
8010701c:	8b 45 08             	mov    0x8(%ebp),%eax
8010701f:	31 c9                	xor    %ecx,%ecx
80107021:	01 da                	add    %ebx,%edx
80107023:	e8 b8 fb ff ff       	call   80106be0 <walkpgdir>
80107028:	85 c0                	test   %eax,%eax
8010702a:	74 4e                	je     8010707a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010702c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010702e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107031:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107036:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010703b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107041:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107044:	01 d9                	add    %ebx,%ecx
80107046:	05 00 00 00 80       	add    $0x80000000,%eax
8010704b:	57                   	push   %edi
8010704c:	51                   	push   %ecx
8010704d:	50                   	push   %eax
8010704e:	ff 75 10             	pushl  0x10(%ebp)
80107051:	e8 4a a9 ff ff       	call   801019a0 <readi>
80107056:	83 c4 10             	add    $0x10,%esp
80107059:	39 f8                	cmp    %edi,%eax
8010705b:	74 ab                	je     80107008 <loaduvm+0x28>
}
8010705d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107065:	5b                   	pop    %ebx
80107066:	5e                   	pop    %esi
80107067:	5f                   	pop    %edi
80107068:	5d                   	pop    %ebp
80107069:	c3                   	ret    
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107073:	31 c0                	xor    %eax,%eax
}
80107075:	5b                   	pop    %ebx
80107076:	5e                   	pop    %esi
80107077:	5f                   	pop    %edi
80107078:	5d                   	pop    %ebp
80107079:	c3                   	ret    
      panic("loaduvm: address should exist");
8010707a:	83 ec 0c             	sub    $0xc,%esp
8010707d:	68 27 7f 10 80       	push   $0x80107f27
80107082:	e8 09 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107087:	83 ec 0c             	sub    $0xc,%esp
8010708a:	68 c8 7f 10 80       	push   $0x80107fc8
8010708f:	e8 fc 92 ff ff       	call   80100390 <panic>
80107094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010709a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070a0 <allocuvm>:
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
801070a6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801070a9:	8b 7d 10             	mov    0x10(%ebp),%edi
801070ac:	85 ff                	test   %edi,%edi
801070ae:	0f 88 8e 00 00 00    	js     80107142 <allocuvm+0xa2>
  if(newsz < oldsz)
801070b4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801070b7:	0f 82 93 00 00 00    	jb     80107150 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801070bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801070c0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801070c6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801070cc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070cf:	0f 86 7e 00 00 00    	jbe    80107153 <allocuvm+0xb3>
801070d5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801070d8:	8b 7d 08             	mov    0x8(%ebp),%edi
801070db:	eb 42                	jmp    8010711f <allocuvm+0x7f>
801070dd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801070e0:	83 ec 04             	sub    $0x4,%esp
801070e3:	68 00 10 00 00       	push   $0x1000
801070e8:	6a 00                	push   $0x0
801070ea:	50                   	push   %eax
801070eb:	e8 b0 d9 ff ff       	call   80104aa0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070f0:	58                   	pop    %eax
801070f1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070f7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070fc:	5a                   	pop    %edx
801070fd:	6a 06                	push   $0x6
801070ff:	50                   	push   %eax
80107100:	89 da                	mov    %ebx,%edx
80107102:	89 f8                	mov    %edi,%eax
80107104:	e8 57 fb ff ff       	call   80106c60 <mappages>
80107109:	83 c4 10             	add    $0x10,%esp
8010710c:	85 c0                	test   %eax,%eax
8010710e:	78 50                	js     80107160 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107110:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107116:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107119:	0f 86 81 00 00 00    	jbe    801071a0 <allocuvm+0x100>
    mem = kalloc();
8010711f:	e8 dc b3 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80107124:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107126:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107128:	75 b6                	jne    801070e0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010712a:	83 ec 0c             	sub    $0xc,%esp
8010712d:	68 45 7f 10 80       	push   $0x80107f45
80107132:	e8 29 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107137:	83 c4 10             	add    $0x10,%esp
8010713a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010713d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107140:	77 6e                	ja     801071b0 <allocuvm+0x110>
}
80107142:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107145:	31 ff                	xor    %edi,%edi
}
80107147:	89 f8                	mov    %edi,%eax
80107149:	5b                   	pop    %ebx
8010714a:	5e                   	pop    %esi
8010714b:	5f                   	pop    %edi
8010714c:	5d                   	pop    %ebp
8010714d:	c3                   	ret    
8010714e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107150:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107153:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107156:	89 f8                	mov    %edi,%eax
80107158:	5b                   	pop    %ebx
80107159:	5e                   	pop    %esi
8010715a:	5f                   	pop    %edi
8010715b:	5d                   	pop    %ebp
8010715c:	c3                   	ret    
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107160:	83 ec 0c             	sub    $0xc,%esp
80107163:	68 5d 7f 10 80       	push   $0x80107f5d
80107168:	e8 f3 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010716d:	83 c4 10             	add    $0x10,%esp
80107170:	8b 45 0c             	mov    0xc(%ebp),%eax
80107173:	39 45 10             	cmp    %eax,0x10(%ebp)
80107176:	76 0d                	jbe    80107185 <allocuvm+0xe5>
80107178:	89 c1                	mov    %eax,%ecx
8010717a:	8b 55 10             	mov    0x10(%ebp),%edx
8010717d:	8b 45 08             	mov    0x8(%ebp),%eax
80107180:	e8 6b fb ff ff       	call   80106cf0 <deallocuvm.part.0>
      kfree(mem);
80107185:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107188:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010718a:	56                   	push   %esi
8010718b:	e8 c0 b1 ff ff       	call   80102350 <kfree>
      return 0;
80107190:	83 c4 10             	add    $0x10,%esp
}
80107193:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107196:	89 f8                	mov    %edi,%eax
80107198:	5b                   	pop    %ebx
80107199:	5e                   	pop    %esi
8010719a:	5f                   	pop    %edi
8010719b:	5d                   	pop    %ebp
8010719c:	c3                   	ret    
8010719d:	8d 76 00             	lea    0x0(%esi),%esi
801071a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801071a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071a6:	5b                   	pop    %ebx
801071a7:	89 f8                	mov    %edi,%eax
801071a9:	5e                   	pop    %esi
801071aa:	5f                   	pop    %edi
801071ab:	5d                   	pop    %ebp
801071ac:	c3                   	ret    
801071ad:	8d 76 00             	lea    0x0(%esi),%esi
801071b0:	89 c1                	mov    %eax,%ecx
801071b2:	8b 55 10             	mov    0x10(%ebp),%edx
801071b5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801071b8:	31 ff                	xor    %edi,%edi
801071ba:	e8 31 fb ff ff       	call   80106cf0 <deallocuvm.part.0>
801071bf:	eb 92                	jmp    80107153 <allocuvm+0xb3>
801071c1:	eb 0d                	jmp    801071d0 <deallocuvm>
801071c3:	90                   	nop
801071c4:	90                   	nop
801071c5:	90                   	nop
801071c6:	90                   	nop
801071c7:	90                   	nop
801071c8:	90                   	nop
801071c9:	90                   	nop
801071ca:	90                   	nop
801071cb:	90                   	nop
801071cc:	90                   	nop
801071cd:	90                   	nop
801071ce:	90                   	nop
801071cf:	90                   	nop

801071d0 <deallocuvm>:
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801071d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801071dc:	39 d1                	cmp    %edx,%ecx
801071de:	73 10                	jae    801071f0 <deallocuvm+0x20>
}
801071e0:	5d                   	pop    %ebp
801071e1:	e9 0a fb ff ff       	jmp    80106cf0 <deallocuvm.part.0>
801071e6:	8d 76 00             	lea    0x0(%esi),%esi
801071e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071f0:	89 d0                	mov    %edx,%eax
801071f2:	5d                   	pop    %ebp
801071f3:	c3                   	ret    
801071f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107200 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010720c:	85 f6                	test   %esi,%esi
8010720e:	74 59                	je     80107269 <freevm+0x69>
80107210:	31 c9                	xor    %ecx,%ecx
80107212:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107217:	89 f0                	mov    %esi,%eax
80107219:	e8 d2 fa ff ff       	call   80106cf0 <deallocuvm.part.0>
8010721e:	89 f3                	mov    %esi,%ebx
80107220:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107226:	eb 0f                	jmp    80107237 <freevm+0x37>
80107228:	90                   	nop
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107230:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107233:	39 fb                	cmp    %edi,%ebx
80107235:	74 23                	je     8010725a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107237:	8b 03                	mov    (%ebx),%eax
80107239:	a8 01                	test   $0x1,%al
8010723b:	74 f3                	je     80107230 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010723d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107242:	83 ec 0c             	sub    $0xc,%esp
80107245:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107248:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010724d:	50                   	push   %eax
8010724e:	e8 fd b0 ff ff       	call   80102350 <kfree>
80107253:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107256:	39 fb                	cmp    %edi,%ebx
80107258:	75 dd                	jne    80107237 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010725a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010725d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107260:	5b                   	pop    %ebx
80107261:	5e                   	pop    %esi
80107262:	5f                   	pop    %edi
80107263:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107264:	e9 e7 b0 ff ff       	jmp    80102350 <kfree>
    panic("freevm: no pgdir");
80107269:	83 ec 0c             	sub    $0xc,%esp
8010726c:	68 79 7f 10 80       	push   $0x80107f79
80107271:	e8 1a 91 ff ff       	call   80100390 <panic>
80107276:	8d 76 00             	lea    0x0(%esi),%esi
80107279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107280 <setupkvm>:
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	56                   	push   %esi
80107284:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107285:	e8 76 b2 ff ff       	call   80102500 <kalloc>
8010728a:	85 c0                	test   %eax,%eax
8010728c:	89 c6                	mov    %eax,%esi
8010728e:	74 42                	je     801072d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107290:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107293:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107298:	68 00 10 00 00       	push   $0x1000
8010729d:	6a 00                	push   $0x0
8010729f:	50                   	push   %eax
801072a0:	e8 fb d7 ff ff       	call   80104aa0 <memset>
801072a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801072a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801072ab:	8b 4b 08             	mov    0x8(%ebx),%ecx
801072ae:	83 ec 08             	sub    $0x8,%esp
801072b1:	8b 13                	mov    (%ebx),%edx
801072b3:	ff 73 0c             	pushl  0xc(%ebx)
801072b6:	50                   	push   %eax
801072b7:	29 c1                	sub    %eax,%ecx
801072b9:	89 f0                	mov    %esi,%eax
801072bb:	e8 a0 f9 ff ff       	call   80106c60 <mappages>
801072c0:	83 c4 10             	add    $0x10,%esp
801072c3:	85 c0                	test   %eax,%eax
801072c5:	78 19                	js     801072e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072c7:	83 c3 10             	add    $0x10,%ebx
801072ca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801072d0:	75 d6                	jne    801072a8 <setupkvm+0x28>
}
801072d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072d5:	89 f0                	mov    %esi,%eax
801072d7:	5b                   	pop    %ebx
801072d8:	5e                   	pop    %esi
801072d9:	5d                   	pop    %ebp
801072da:	c3                   	ret    
801072db:	90                   	nop
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801072e0:	83 ec 0c             	sub    $0xc,%esp
801072e3:	56                   	push   %esi
      return 0;
801072e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801072e6:	e8 15 ff ff ff       	call   80107200 <freevm>
      return 0;
801072eb:	83 c4 10             	add    $0x10,%esp
}
801072ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072f1:	89 f0                	mov    %esi,%eax
801072f3:	5b                   	pop    %ebx
801072f4:	5e                   	pop    %esi
801072f5:	5d                   	pop    %ebp
801072f6:	c3                   	ret    
801072f7:	89 f6                	mov    %esi,%esi
801072f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107300 <kvmalloc>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107306:	e8 75 ff ff ff       	call   80107280 <setupkvm>
8010730b:	a3 e4 34 12 80       	mov    %eax,0x801234e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107310:	05 00 00 00 80       	add    $0x80000000,%eax
80107315:	0f 22 d8             	mov    %eax,%cr3
}
80107318:	c9                   	leave  
80107319:	c3                   	ret    
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107320 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107320:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107321:	31 c9                	xor    %ecx,%ecx
{
80107323:	89 e5                	mov    %esp,%ebp
80107325:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107328:	8b 55 0c             	mov    0xc(%ebp),%edx
8010732b:	8b 45 08             	mov    0x8(%ebp),%eax
8010732e:	e8 ad f8 ff ff       	call   80106be0 <walkpgdir>
  if(pte == 0)
80107333:	85 c0                	test   %eax,%eax
80107335:	74 05                	je     8010733c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107337:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010733a:	c9                   	leave  
8010733b:	c3                   	ret    
    panic("clearpteu");
8010733c:	83 ec 0c             	sub    $0xc,%esp
8010733f:	68 8a 7f 10 80       	push   $0x80107f8a
80107344:	e8 47 90 ff ff       	call   80100390 <panic>
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107350 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
80107356:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107359:	e8 22 ff ff ff       	call   80107280 <setupkvm>
8010735e:	85 c0                	test   %eax,%eax
80107360:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107363:	0f 84 9f 00 00 00    	je     80107408 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010736c:	85 c9                	test   %ecx,%ecx
8010736e:	0f 84 94 00 00 00    	je     80107408 <copyuvm+0xb8>
80107374:	31 ff                	xor    %edi,%edi
80107376:	eb 4a                	jmp    801073c2 <copyuvm+0x72>
80107378:	90                   	nop
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107380:	83 ec 04             	sub    $0x4,%esp
80107383:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107389:	68 00 10 00 00       	push   $0x1000
8010738e:	53                   	push   %ebx
8010738f:	50                   	push   %eax
80107390:	e8 bb d7 ff ff       	call   80104b50 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107395:	58                   	pop    %eax
80107396:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010739c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073a1:	5a                   	pop    %edx
801073a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801073a5:	50                   	push   %eax
801073a6:	89 fa                	mov    %edi,%edx
801073a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ab:	e8 b0 f8 ff ff       	call   80106c60 <mappages>
801073b0:	83 c4 10             	add    $0x10,%esp
801073b3:	85 c0                	test   %eax,%eax
801073b5:	78 61                	js     80107418 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801073b7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073bd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801073c0:	76 46                	jbe    80107408 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801073c2:	8b 45 08             	mov    0x8(%ebp),%eax
801073c5:	31 c9                	xor    %ecx,%ecx
801073c7:	89 fa                	mov    %edi,%edx
801073c9:	e8 12 f8 ff ff       	call   80106be0 <walkpgdir>
801073ce:	85 c0                	test   %eax,%eax
801073d0:	74 61                	je     80107433 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801073d2:	8b 00                	mov    (%eax),%eax
801073d4:	a8 01                	test   $0x1,%al
801073d6:	74 4e                	je     80107426 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801073d8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801073da:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801073df:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801073e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801073e8:	e8 13 b1 ff ff       	call   80102500 <kalloc>
801073ed:	85 c0                	test   %eax,%eax
801073ef:	89 c6                	mov    %eax,%esi
801073f1:	75 8d                	jne    80107380 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801073f3:	83 ec 0c             	sub    $0xc,%esp
801073f6:	ff 75 e0             	pushl  -0x20(%ebp)
801073f9:	e8 02 fe ff ff       	call   80107200 <freevm>
  return 0;
801073fe:	83 c4 10             	add    $0x10,%esp
80107401:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107408:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010740b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010740e:	5b                   	pop    %ebx
8010740f:	5e                   	pop    %esi
80107410:	5f                   	pop    %edi
80107411:	5d                   	pop    %ebp
80107412:	c3                   	ret    
80107413:	90                   	nop
80107414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107418:	83 ec 0c             	sub    $0xc,%esp
8010741b:	56                   	push   %esi
8010741c:	e8 2f af ff ff       	call   80102350 <kfree>
      goto bad;
80107421:	83 c4 10             	add    $0x10,%esp
80107424:	eb cd                	jmp    801073f3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107426:	83 ec 0c             	sub    $0xc,%esp
80107429:	68 ae 7f 10 80       	push   $0x80107fae
8010742e:	e8 5d 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107433:	83 ec 0c             	sub    $0xc,%esp
80107436:	68 94 7f 10 80       	push   $0x80107f94
8010743b:	e8 50 8f ff ff       	call   80100390 <panic>

80107440 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107440:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107441:	31 c9                	xor    %ecx,%ecx
{
80107443:	89 e5                	mov    %esp,%ebp
80107445:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107448:	8b 55 0c             	mov    0xc(%ebp),%edx
8010744b:	8b 45 08             	mov    0x8(%ebp),%eax
8010744e:	e8 8d f7 ff ff       	call   80106be0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107453:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107455:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107456:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107458:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010745d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107460:	05 00 00 00 80       	add    $0x80000000,%eax
80107465:	83 fa 05             	cmp    $0x5,%edx
80107468:	ba 00 00 00 00       	mov    $0x0,%edx
8010746d:	0f 45 c2             	cmovne %edx,%eax
}
80107470:	c3                   	ret    
80107471:	eb 0d                	jmp    80107480 <copyout>
80107473:	90                   	nop
80107474:	90                   	nop
80107475:	90                   	nop
80107476:	90                   	nop
80107477:	90                   	nop
80107478:	90                   	nop
80107479:	90                   	nop
8010747a:	90                   	nop
8010747b:	90                   	nop
8010747c:	90                   	nop
8010747d:	90                   	nop
8010747e:	90                   	nop
8010747f:	90                   	nop

80107480 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 1c             	sub    $0x1c,%esp
80107489:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010748c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010748f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107492:	85 db                	test   %ebx,%ebx
80107494:	75 40                	jne    801074d6 <copyout+0x56>
80107496:	eb 70                	jmp    80107508 <copyout+0x88>
80107498:	90                   	nop
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801074a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074a3:	89 f1                	mov    %esi,%ecx
801074a5:	29 d1                	sub    %edx,%ecx
801074a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801074ad:	39 d9                	cmp    %ebx,%ecx
801074af:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074b2:	29 f2                	sub    %esi,%edx
801074b4:	83 ec 04             	sub    $0x4,%esp
801074b7:	01 d0                	add    %edx,%eax
801074b9:	51                   	push   %ecx
801074ba:	57                   	push   %edi
801074bb:	50                   	push   %eax
801074bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801074bf:	e8 8c d6 ff ff       	call   80104b50 <memmove>
    len -= n;
    buf += n;
801074c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801074c7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801074ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801074d0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801074d2:	29 cb                	sub    %ecx,%ebx
801074d4:	74 32                	je     80107508 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801074d6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074d8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801074db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801074de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074e4:	56                   	push   %esi
801074e5:	ff 75 08             	pushl  0x8(%ebp)
801074e8:	e8 53 ff ff ff       	call   80107440 <uva2ka>
    if(pa0 == 0)
801074ed:	83 c4 10             	add    $0x10,%esp
801074f0:	85 c0                	test   %eax,%eax
801074f2:	75 ac                	jne    801074a0 <copyout+0x20>
  }
  return 0;
}
801074f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074fc:	5b                   	pop    %ebx
801074fd:	5e                   	pop    %esi
801074fe:	5f                   	pop    %edi
801074ff:	5d                   	pop    %ebp
80107500:	c3                   	ret    
80107501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107508:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010750b:	31 c0                	xor    %eax,%eax
}
8010750d:	5b                   	pop    %ebx
8010750e:	5e                   	pop    %esi
8010750f:	5f                   	pop    %edi
80107510:	5d                   	pop    %ebp
80107511:	c3                   	ret    
