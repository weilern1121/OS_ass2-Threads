
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 2f 10 80       	mov    $0x80102f40,%eax
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
80100044:	bb 18 c6 10 80       	mov    $0x8010c618,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 82 10 80       	push   $0x80108220
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 35 52 00 00       	call   80105290 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 ac 0d 11 80 58 	movl   $0x80110d58,0x80110dac
80100062:	0d 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 b0 0d 11 80 58 	movl   $0x80110d58,0x80110db0
8010006c:	0d 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 58 0d 11 80       	mov    $0x80110d58,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 58             	mov    %edx,0x58(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 54 58 0d 11 80 	movl   $0x80110d58,0x54(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 82 10 80       	push   $0x80108227
80100097:	50                   	push   %eax
80100098:	e8 c3 50 00 00       	call   80105160 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 54             	mov    %ebx,0x54(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 60 02 00 00    	lea    0x260(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d b0 0d 11 80    	mov    %ebx,0x80110db0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 58 0d 11 80       	cmp    $0x80110d58,%eax
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
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 e7 52 00 00       	call   801053d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d b0 0d 11 80    	mov    0x80110db0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 58 0d 11 80    	cmp    $0x80110d58,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 58             	mov    0x58(%ebx),%ebx
80100103:	81 fb 58 0d 11 80    	cmp    $0x80110d58,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 50 01          	addl   $0x1,0x50(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d ac 0d 11 80    	mov    0x80110dac,%ebx
80100126:	81 fb 58 0d 11 80    	cmp    $0x80110d58,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100133:	81 fb 58 0d 11 80    	cmp    $0x80110d58,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 50             	mov    0x50(%ebx),%eax
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
80100153:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 39 53 00 00       	call   801054a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 50 00 00       	call   801051a0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 3d 20 00 00       	call   801021c0 <iderw>
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
80100193:	68 2e 82 10 80       	push   $0x8010822e
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
801001ae:	e8 8d 50 00 00       	call   80105240 <holdingsleep>
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
801001c4:	e9 f7 1f 00 00       	jmp    801021c0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 82 10 80       	push   $0x8010823f
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
801001ef:	e8 4c 50 00 00       	call   80105240 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 4f 00 00       	call   80105200 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 c0 51 00 00       	call   801053d0 <acquire>
  b->refcnt--;
80100210:	8b 43 50             	mov    0x50(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 50             	mov    %eax,0x50(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 58             	mov    0x58(%ebx),%eax
80100223:	8b 53 54             	mov    0x54(%ebx),%edx
80100226:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev->next = b->next;
80100229:	8b 43 54             	mov    0x54(%ebx),%eax
8010022c:	8b 53 58             	mov    0x58(%ebx),%edx
8010022f:	89 50 58             	mov    %edx,0x58(%eax)
    b->next = bcache.head.next;
80100232:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
    b->prev = &bcache.head;
80100237:	c7 43 54 58 0d 11 80 	movl   $0x80110d58,0x54(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 58             	mov    %eax,0x58(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
80100246:	89 58 54             	mov    %ebx,0x54(%eax)
    bcache.head.next = b;
80100249:	89 1d b0 0d 11 80    	mov    %ebx,0x80110db0
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 3f 52 00 00       	jmp    801054a0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 82 10 80       	push   $0x80108246
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
80100280:	e8 7b 15 00 00       	call   80101800 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 3f 51 00 00       	call   801053d0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801002a7:	39 15 44 10 11 80    	cmp    %edx,0x80111044
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
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 40 10 11 80       	push   $0x80111040
801002c5:	e8 16 44 00 00       	call   801046e0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 44 10 11 80    	cmp    0x80111044,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 00 37 00 00       	call   801039e0 <myproc>
801002e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 ac 51 00 00       	call   801054a0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 24 14 00 00       	call   80101720 <ilock>
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
80100313:	a3 40 10 11 80       	mov    %eax,0x80111040
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 c0 0f 11 80 	movsbl -0x7feef040(%eax),%eax
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
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 4e 51 00 00       	call   801054a0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 c6 13 00 00       	call   80101720 <ilock>
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
80100372:	89 15 40 10 11 80    	mov    %edx,0x80111040
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
80100399:	c7 05 58 b5 10 80 00 	movl   $0x0,0x8010b558
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 22 24 00 00       	call   801027d0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 82 10 80       	push   $0x8010824d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 3b 8c 10 80 	movl   $0x80108c3b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 d3 4e 00 00       	call   801052b0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 82 10 80       	push   $0x80108261
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 5c b5 10 80 01 	movl   $0x1,0x8010b55c
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 5c b5 10 80    	mov    0x8010b55c,%ecx
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
8010043a:	e8 e1 69 00 00       	call   80106e20 <uartputc>
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
801004ec:	e8 2f 69 00 00       	call   80106e20 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 23 69 00 00       	call   80106e20 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 17 69 00 00       	call   80106e20 <uartputc>
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
80100524:	e8 77 50 00 00       	call   801055a0 <memmove>
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
80100541:	e8 aa 4f 00 00       	call   801054f0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 82 10 80       	push   $0x80108265
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
801005b1:	0f b6 92 90 82 10 80 	movzbl -0x7fef7d70(%edx),%edx
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
8010060f:	e8 ec 11 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 b0 4d 00 00       	call   801053d0 <acquire>
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
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 54 4e 00 00       	call   801054a0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 cb 10 00 00       	call   80101720 <ilock>

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
80100669:	a1 58 b5 10 80       	mov    0x8010b558,%eax
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
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 7c 4d 00 00       	call   801054a0 <release>
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
801007d0:	ba 78 82 10 80       	mov    $0x80108278,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 db 4b 00 00       	call   801053d0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 82 10 80       	push   $0x8010827f
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
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 a8 4b 00 00       	call   801053d0 <acquire>
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
80100851:	a1 48 10 11 80       	mov    0x80111048,%eax
80100856:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 48 10 11 80       	mov    %eax,0x80111048
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
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 13 4c 00 00       	call   801054a0 <release>
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
801008a9:	a1 48 10 11 80       	mov    0x80111048,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 40 10 11 80    	sub    0x80111040,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 48 10 11 80    	mov    %edx,0x80111048
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 c0 0f 11 80    	mov    %cl,-0x7feef040(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 40 10 11 80       	mov    0x80111040,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 48 10 11 80    	cmp    %eax,0x80111048
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 44 10 11 80       	mov    %eax,0x80111044
          wakeup(&input.r);
80100911:	68 40 10 11 80       	push   $0x80111040
80100916:	e8 a5 36 00 00       	call   80103fc0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 48 10 11 80       	mov    0x80111048,%eax
8010093d:	39 05 44 10 11 80    	cmp    %eax,0x80111044
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 48 10 11 80       	mov    0x80111048,%eax
80100964:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba c0 0f 11 80 0a 	cmpb   $0xa,-0x7feef040(%edx)
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
80100997:	e9 64 37 00 00       	jmp    80104100 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 c0 0f 11 80 0a 	movb   $0xa,-0x7feef040(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 48 10 11 80       	mov    0x80111048,%eax
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
801009c6:	68 88 82 10 80       	push   $0x80108288
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 bb 48 00 00       	call   80105290 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 0c 1a 11 80 00 	movl   $0x80100600,0x80111a0c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 08 1a 11 80 70 	movl   $0x80100270,0x80111a08
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 72 19 00 00       	call   80102370 <ioapicenable>
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
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv) {
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
80100a1c:	e8 bf 2f 00 00       	call   801039e0 <myproc>
80100a21:	89 c7                	mov    %eax,%edi
    struct thread *curthread = mythread();
80100a23:	e8 e8 2f 00 00       	call   80103a10 <mythread>
80100a28:	89 c3                	mov    %eax,%ebx
    struct thread *t;

    //flag-up all other threads' tkilled except curthread
    //After this func: P->mainThread == curthread
    exec_acquire();
80100a2a:	e8 61 2e 00 00       	call   80103890 <exec_acquire>
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80100a2f:	8d 47 74             	lea    0x74(%edi),%eax
80100a32:	8d 97 74 03 00 00    	lea    0x374(%edi),%edx
80100a38:	90                   	nop
80100a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (t->tid != curthread->tid) {
80100a40:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80100a43:	39 48 0c             	cmp    %ecx,0xc(%eax)
80100a46:	74 14                	je     80100a5c <exec+0x4c>
            t->tkilled = 1;
            if (t->state == SLEEPING)
80100a48:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
            t->tkilled = 1;
80100a4c:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
            if (t->state == SLEEPING)
80100a53:	75 07                	jne    80100a5c <exec+0x4c>
                t->state = RUNNABLE;
80100a55:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    for (t = curproc->thread; t < &curproc->thread[NTHREADS]; t++) {
80100a5c:	83 c0 30             	add    $0x30,%eax
80100a5f:	39 c2                	cmp    %eax,%edx
80100a61:	77 dd                	ja     80100a40 <exec+0x30>
        }
    }
    curproc->mainThread = curthread; //because curThread is the only thread that will be alive
80100a63:	89 9f 74 03 00 00    	mov    %ebx,0x374(%edi)
    exec_release();
80100a69:	e8 42 2e 00 00       	call   801038b0 <exec_release>
        for (j = 0, t = curproc->thread; t < &curproc->thread[NTHREADS]; j++, t++)
            cprintf("i=  %d \t t.state= %d\n", j, t->state);
        exec_release();
    }

    begin_op();
80100a6e:	e8 cd 21 00 00       	call   80102c40 <begin_op>
    if ((ip = namei(path)) == 0) {
80100a73:	83 ec 0c             	sub    $0xc,%esp
80100a76:	ff 75 08             	pushl  0x8(%ebp)
80100a79:	e8 02 15 00 00       	call   80101f80 <namei>
80100a7e:	83 c4 10             	add    $0x10,%esp
80100a81:	85 c0                	test   %eax,%eax
80100a83:	89 c6                	mov    %eax,%esi
80100a85:	0f 84 c8 01 00 00    	je     80100c53 <exec+0x243>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100a8b:	83 ec 0c             	sub    $0xc,%esp
80100a8e:	50                   	push   %eax
80100a8f:	e8 8c 0c 00 00       	call   80101720 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char *) &elf, 0, sizeof(elf)) != sizeof(elf))
80100a94:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a9a:	6a 34                	push   $0x34
80100a9c:	6a 00                	push   $0x0
80100a9e:	50                   	push   %eax
80100a9f:	56                   	push   %esi
80100aa0:	e8 5b 0f 00 00       	call   80101a00 <readi>
80100aa5:	83 c4 20             	add    $0x20,%esp
80100aa8:	83 f8 34             	cmp    $0x34,%eax
80100aab:	74 23                	je     80100ad0 <exec+0xc0>

    bad:
    if (pgdir)
        freevm(pgdir);
    if (ip) {
        iunlockput(ip);
80100aad:	83 ec 0c             	sub    $0xc,%esp
80100ab0:	56                   	push   %esi
80100ab1:	e8 fa 0e 00 00       	call   801019b0 <iunlockput>
        end_op();
80100ab6:	e8 f5 21 00 00       	call   80102cb0 <end_op>
80100abb:	83 c4 10             	add    $0x10,%esp
    }
    return -1;
80100abe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ac6:	5b                   	pop    %ebx
80100ac7:	5e                   	pop    %esi
80100ac8:	5f                   	pop    %edi
80100ac9:	5d                   	pop    %ebp
80100aca:	c3                   	ret    
80100acb:	90                   	nop
80100acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (elf.magic != ELF_MAGIC) {
80100ad0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100ad7:	45 4c 46 
80100ada:	75 d1                	jne    80100aad <exec+0x9d>
    if ((pgdir = setupkvm()) == 0) {
80100adc:	e8 9f 74 00 00       	call   80107f80 <setupkvm>
80100ae1:	85 c0                	test   %eax,%eax
80100ae3:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ae9:	74 c2                	je     80100aad <exec+0x9d>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100aeb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100af2:	00 
80100af3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100af9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aff:	0f 84 cb 02 00 00    	je     80100dd0 <exec+0x3c0>
    sz = 0;
80100b05:	31 d2                	xor    %edx,%edx
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100b07:	31 c0                	xor    %eax,%eax
80100b09:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100b0f:	89 9d e8 fe ff ff    	mov    %ebx,-0x118(%ebp)
80100b15:	89 d7                	mov    %edx,%edi
80100b17:	89 c3                	mov    %eax,%ebx
80100b19:	eb 7f                	jmp    80100b9a <exec+0x18a>
80100b1b:	90                   	nop
80100b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ph.type != ELF_PROG_LOAD)
80100b20:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b27:	75 63                	jne    80100b8c <exec+0x17c>
        if (ph.memsz < ph.filesz)
80100b29:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b2f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b35:	0f 82 86 00 00 00    	jb     80100bc1 <exec+0x1b1>
80100b3b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b41:	72 7e                	jb     80100bc1 <exec+0x1b1>
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b43:	83 ec 04             	sub    $0x4,%esp
80100b46:	50                   	push   %eax
80100b47:	57                   	push   %edi
80100b48:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b4e:	e8 4d 72 00 00       	call   80107da0 <allocuvm>
80100b53:	83 c4 10             	add    $0x10,%esp
80100b56:	85 c0                	test   %eax,%eax
80100b58:	89 c7                	mov    %eax,%edi
80100b5a:	74 65                	je     80100bc1 <exec+0x1b1>
        if (ph.vaddr % PGSIZE != 0)
80100b5c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b62:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b67:	75 58                	jne    80100bc1 <exec+0x1b1>
        if (loaduvm(pgdir, (char *) ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b72:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b78:	56                   	push   %esi
80100b79:	50                   	push   %eax
80100b7a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b80:	e8 5b 71 00 00       	call   80107ce0 <loaduvm>
80100b85:	83 c4 20             	add    $0x20,%esp
80100b88:	85 c0                	test   %eax,%eax
80100b8a:	78 35                	js     80100bc1 <exec+0x1b1>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100b8c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b93:	83 c3 01             	add    $0x1,%ebx
80100b96:	39 d8                	cmp    %ebx,%eax
80100b98:	7e 3d                	jle    80100bd7 <exec+0x1c7>
        if (readi(ip, (char *) &ph, off, sizeof(ph)) != sizeof(ph))
80100b9a:	89 d8                	mov    %ebx,%eax
80100b9c:	6a 20                	push   $0x20
80100b9e:	c1 e0 05             	shl    $0x5,%eax
80100ba1:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100ba7:	50                   	push   %eax
80100ba8:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bae:	50                   	push   %eax
80100baf:	56                   	push   %esi
80100bb0:	e8 4b 0e 00 00       	call   80101a00 <readi>
80100bb5:	83 c4 10             	add    $0x10,%esp
80100bb8:	83 f8 20             	cmp    $0x20,%eax
80100bbb:	0f 84 5f ff ff ff    	je     80100b20 <exec+0x110>
        freevm(pgdir);
80100bc1:	83 ec 0c             	sub    $0xc,%esp
80100bc4:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bca:	e8 31 73 00 00       	call   80107f00 <freevm>
80100bcf:	83 c4 10             	add    $0x10,%esp
80100bd2:	e9 d6 fe ff ff       	jmp    80100aad <exec+0x9d>
80100bd7:	89 f8                	mov    %edi,%eax
80100bd9:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bdf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100be5:	05 ff 0f 00 00       	add    $0xfff,%eax
80100bea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100bef:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
    iunlockput(ip);
80100bf5:	83 ec 0c             	sub    $0xc,%esp
80100bf8:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100bfe:	89 95 f0 fe ff ff    	mov    %edx,-0x110(%ebp)
80100c04:	56                   	push   %esi
80100c05:	e8 a6 0d 00 00       	call   801019b0 <iunlockput>
    end_op();
80100c0a:	e8 a1 20 00 00       	call   80102cb0 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100c0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c15:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c1b:	83 c4 0c             	add    $0xc,%esp
80100c1e:	52                   	push   %edx
80100c1f:	50                   	push   %eax
80100c20:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c26:	e8 75 71 00 00       	call   80107da0 <allocuvm>
80100c2b:	83 c4 10             	add    $0x10,%esp
80100c2e:	85 c0                	test   %eax,%eax
80100c30:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c36:	75 3a                	jne    80100c72 <exec+0x262>
        freevm(pgdir);
80100c38:	83 ec 0c             	sub    $0xc,%esp
80100c3b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c41:	e8 ba 72 00 00       	call   80107f00 <freevm>
80100c46:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4e:	e9 70 fe ff ff       	jmp    80100ac3 <exec+0xb3>
        end_op();
80100c53:	e8 58 20 00 00       	call   80102cb0 <end_op>
        cprintf("exec: fail\n");
80100c58:	83 ec 0c             	sub    $0xc,%esp
80100c5b:	68 a1 82 10 80       	push   $0x801082a1
80100c60:	e8 fb f9 ff ff       	call   80100660 <cprintf>
        return -1;
80100c65:	83 c4 10             	add    $0x10,%esp
80100c68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c6d:	e9 51 fe ff ff       	jmp    80100ac3 <exec+0xb3>
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
80100c72:	89 c6                	mov    %eax,%esi
80100c74:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c7a:	83 ec 08             	sub    $0x8,%esp
80100c7d:	50                   	push   %eax
80100c7e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c84:	e8 97 73 00 00       	call   80108020 <clearpteu>
    for (argc = 0; argv[argc]; argc++) {
80100c89:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8c:	83 c4 10             	add    $0x10,%esp
80100c8f:	31 d2                	xor    %edx,%edx
80100c91:	8b 00                	mov    (%eax),%eax
80100c93:	85 c0                	test   %eax,%eax
80100c95:	0f 84 41 01 00 00    	je     80100ddc <exec+0x3cc>
80100c9b:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100ca1:	89 d7                	mov    %edx,%edi
80100ca3:	eb 05                	jmp    80100caa <exec+0x29a>
        if (argc >= MAXARG)
80100ca5:	83 ff 20             	cmp    $0x20,%edi
80100ca8:	74 8e                	je     80100c38 <exec+0x228>
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100caa:	83 ec 0c             	sub    $0xc,%esp
80100cad:	50                   	push   %eax
80100cae:	e8 5d 4a 00 00       	call   80105710 <strlen>
80100cb3:	f7 d0                	not    %eax
80100cb5:	01 c6                	add    %eax,%esi
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb7:	58                   	pop    %eax
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cbb:	83 e6 fc             	and    $0xfffffffc,%esi
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cbe:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc1:	e8 4a 4a 00 00       	call   80105710 <strlen>
80100cc6:	83 c0 01             	add    $0x1,%eax
80100cc9:	50                   	push   %eax
80100cca:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ccd:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cd0:	56                   	push   %esi
80100cd1:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cd7:	e8 a4 74 00 00       	call   80108180 <copyout>
80100cdc:	83 c4 20             	add    $0x20,%esp
80100cdf:	85 c0                	test   %eax,%eax
80100ce1:	0f 88 51 ff ff ff    	js     80100c38 <exec+0x228>
    for (argc = 0; argv[argc]; argc++) {
80100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
        ustack[3 + argc] = sp;
80100cea:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
    for (argc = 0; argv[argc]; argc++) {
80100cf1:	83 c7 01             	add    $0x1,%edi
        ustack[3 + argc] = sp;
80100cf4:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    for (argc = 0; argv[argc]; argc++) {
80100cfa:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cfd:	85 c0                	test   %eax,%eax
80100cff:	75 a4                	jne    80100ca5 <exec+0x295>
80100d01:	89 fa                	mov    %edi,%edx
80100d03:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100d09:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
    ustack[3 + argc] = 0;
80100d10:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100d17:	00 00 00 00 
    ustack[1] = argc;
80100d1b:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100d21:	89 f2                	mov    %esi,%edx
    ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100d2d:	29 c2                	sub    %eax,%edx
    sp -= (3 + argc + 1) * 4;
80100d2f:	83 c0 0c             	add    $0xc,%eax
80100d32:	29 c6                	sub    %eax,%esi
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100d34:	50                   	push   %eax
80100d35:	51                   	push   %ecx
80100d36:	56                   	push   %esi
80100d37:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100d3d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100d43:	e8 38 74 00 00       	call   80108180 <copyout>
80100d48:	83 c4 10             	add    $0x10,%esp
80100d4b:	85 c0                	test   %eax,%eax
80100d4d:	0f 88 e5 fe ff ff    	js     80100c38 <exec+0x228>
    for (last = s = path; *s; s++)
80100d53:	8b 45 08             	mov    0x8(%ebp),%eax
80100d56:	0f b6 00             	movzbl (%eax),%eax
80100d59:	84 c0                	test   %al,%al
80100d5b:	74 17                	je     80100d74 <exec+0x364>
80100d5d:	8b 55 08             	mov    0x8(%ebp),%edx
80100d60:	89 d1                	mov    %edx,%ecx
80100d62:	83 c1 01             	add    $0x1,%ecx
80100d65:	3c 2f                	cmp    $0x2f,%al
80100d67:	0f b6 01             	movzbl (%ecx),%eax
80100d6a:	0f 44 d1             	cmove  %ecx,%edx
80100d6d:	84 c0                	test   %al,%al
80100d6f:	75 f1                	jne    80100d62 <exec+0x352>
80100d71:	89 55 08             	mov    %edx,0x8(%ebp)
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d74:	50                   	push   %eax
80100d75:	8d 47 64             	lea    0x64(%edi),%eax
80100d78:	6a 10                	push   $0x10
80100d7a:	ff 75 08             	pushl  0x8(%ebp)
80100d7d:	50                   	push   %eax
80100d7e:	e8 4d 49 00 00       	call   801056d0 <safestrcpy>
    oldpgdir = curproc->pgdir;
80100d83:	8b 47 04             	mov    0x4(%edi),%eax
80100d86:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
    curproc->pgdir = pgdir;
80100d8c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d92:	89 47 04             	mov    %eax,0x4(%edi)
    curproc->sz = sz;
80100d95:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d9b:	89 07                	mov    %eax,(%edi)
    curthread->tf->eip = elf.entry;  // main
80100d9d:	8b 53 10             	mov    0x10(%ebx),%edx
80100da0:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100da6:	89 4a 38             	mov    %ecx,0x38(%edx)
    curthread->tf->esp = sp;
80100da9:	8b 53 10             	mov    0x10(%ebx),%edx
80100dac:	89 72 44             	mov    %esi,0x44(%edx)
    switchuvm(curproc, curthread); //need to send mainThread, because other are not exists
80100daf:	5a                   	pop    %edx
80100db0:	59                   	pop    %ecx
80100db1:	53                   	push   %ebx
80100db2:	57                   	push   %edi
80100db3:	e8 88 6d 00 00       	call   80107b40 <switchuvm>
    freevm(oldpgdir);
80100db8:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100dbe:	89 04 24             	mov    %eax,(%esp)
80100dc1:	e8 3a 71 00 00       	call   80107f00 <freevm>
    return 0;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	31 c0                	xor    %eax,%eax
80100dcb:	e9 f3 fc ff ff       	jmp    80100ac3 <exec+0xb3>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100dd0:	31 c0                	xor    %eax,%eax
80100dd2:	ba 00 20 00 00       	mov    $0x2000,%edx
80100dd7:	e9 19 fe ff ff       	jmp    80100bf5 <exec+0x1e5>
    for (argc = 0; argv[argc]; argc++) {
80100ddc:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100de2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100de8:	e9 1c ff ff ff       	jmp    80100d09 <exec+0x2f9>
80100ded:	66 90                	xchg   %ax,%ax
80100def:	90                   	nop

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100df6:	68 ad 82 10 80       	push   $0x801082ad
80100dfb:	68 60 10 11 80       	push   $0x80111060
80100e00:	e8 8b 44 00 00       	call   80105290 <initlock>
}
80100e05:	83 c4 10             	add    $0x10,%esp
80100e08:	c9                   	leave  
80100e09:	c3                   	ret    
80100e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e14:	bb 98 10 11 80       	mov    $0x80111098,%ebx
{
80100e19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e1c:	68 60 10 11 80       	push   $0x80111060
80100e21:	e8 aa 45 00 00       	call   801053d0 <acquire>
80100e26:	83 c4 10             	add    $0x10,%esp
80100e29:	eb 10                	jmp    80100e3b <filealloc+0x2b>
80100e2b:	90                   	nop
80100e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb f8 19 11 80    	cmp    $0x801119f8,%ebx
80100e39:	73 25                	jae    80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 60 10 11 80       	push   $0x80111060
80100e51:	e8 4a 46 00 00       	call   801054a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 60 10 11 80       	push   $0x80111060
80100e6a:	e8 31 46 00 00       	call   801054a0 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
80100e84:	83 ec 10             	sub    $0x10,%esp
80100e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8a:	68 60 10 11 80       	push   $0x80111060
80100e8f:	e8 3c 45 00 00       	call   801053d0 <acquire>
  if(f->ref < 1)
80100e94:	8b 43 04             	mov    0x4(%ebx),%eax
80100e97:	83 c4 10             	add    $0x10,%esp
80100e9a:	85 c0                	test   %eax,%eax
80100e9c:	7e 1a                	jle    80100eb8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e9e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ea7:	68 60 10 11 80       	push   $0x80111060
80100eac:	e8 ef 45 00 00       	call   801054a0 <release>
  return f;
}
80100eb1:	89 d8                	mov    %ebx,%eax
80100eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb6:	c9                   	leave  
80100eb7:	c3                   	ret    
    panic("filedup");
80100eb8:	83 ec 0c             	sub    $0xc,%esp
80100ebb:	68 b4 82 10 80       	push   $0x801082b4
80100ec0:	e8 cb f4 ff ff       	call   80100390 <panic>
80100ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	57                   	push   %edi
80100ed4:	56                   	push   %esi
80100ed5:	53                   	push   %ebx
80100ed6:	83 ec 28             	sub    $0x28,%esp
80100ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100edc:	68 60 10 11 80       	push   $0x80111060
80100ee1:	e8 ea 44 00 00       	call   801053d0 <acquire>
  if(f->ref < 1)
80100ee6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ee9:	83 c4 10             	add    $0x10,%esp
80100eec:	85 c0                	test   %eax,%eax
80100eee:	0f 8e 9b 00 00 00    	jle    80100f8f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ef4:	83 e8 01             	sub    $0x1,%eax
80100ef7:	85 c0                	test   %eax,%eax
80100ef9:	89 43 04             	mov    %eax,0x4(%ebx)
80100efc:	74 1a                	je     80100f18 <fileclose+0x48>
    release(&ftable.lock);
80100efe:	c7 45 08 60 10 11 80 	movl   $0x80111060,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f08:	5b                   	pop    %ebx
80100f09:	5e                   	pop    %esi
80100f0a:	5f                   	pop    %edi
80100f0b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f0c:	e9 8f 45 00 00       	jmp    801054a0 <release>
80100f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f18:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f1c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f1e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f21:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f2d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f30:	68 60 10 11 80       	push   $0x80111060
  ff = *f;
80100f35:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f38:	e8 63 45 00 00       	call   801054a0 <release>
  if(ff.type == FD_PIPE)
80100f3d:	83 c4 10             	add    $0x10,%esp
80100f40:	83 ff 01             	cmp    $0x1,%edi
80100f43:	74 13                	je     80100f58 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f45:	83 ff 02             	cmp    $0x2,%edi
80100f48:	74 26                	je     80100f70 <fileclose+0xa0>
}
80100f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4d:	5b                   	pop    %ebx
80100f4e:	5e                   	pop    %esi
80100f4f:	5f                   	pop    %edi
80100f50:	5d                   	pop    %ebp
80100f51:	c3                   	ret    
80100f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f58:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f5c:	83 ec 08             	sub    $0x8,%esp
80100f5f:	53                   	push   %ebx
80100f60:	56                   	push   %esi
80100f61:	e8 8a 24 00 00       	call   801033f0 <pipeclose>
80100f66:	83 c4 10             	add    $0x10,%esp
80100f69:	eb df                	jmp    80100f4a <fileclose+0x7a>
80100f6b:	90                   	nop
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f70:	e8 cb 1c 00 00       	call   80102c40 <begin_op>
    iput(ff.ip);
80100f75:	83 ec 0c             	sub    $0xc,%esp
80100f78:	ff 75 e0             	pushl  -0x20(%ebp)
80100f7b:	e8 d0 08 00 00       	call   80101850 <iput>
    end_op();
80100f80:	83 c4 10             	add    $0x10,%esp
}
80100f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f86:	5b                   	pop    %ebx
80100f87:	5e                   	pop    %esi
80100f88:	5f                   	pop    %edi
80100f89:	5d                   	pop    %ebp
    end_op();
80100f8a:	e9 21 1d 00 00       	jmp    80102cb0 <end_op>
    panic("fileclose");
80100f8f:	83 ec 0c             	sub    $0xc,%esp
80100f92:	68 bc 82 10 80       	push   $0x801082bc
80100f97:	e8 f4 f3 ff ff       	call   80100390 <panic>
80100f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100faa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fad:	75 31                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 73 10             	pushl  0x10(%ebx)
80100fb5:	e8 66 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100fba:	58                   	pop    %eax
80100fbb:	5a                   	pop    %edx
80100fbc:	ff 75 0c             	pushl  0xc(%ebp)
80100fbf:	ff 73 10             	pushl  0x10(%ebx)
80100fc2:	e8 09 0a 00 00       	call   801019d0 <stati>
    iunlock(f->ip);
80100fc7:	59                   	pop    %ecx
80100fc8:	ff 73 10             	pushl  0x10(%ebx)
80100fcb:	e8 30 08 00 00       	call   80101800 <iunlock>
    return 0;
80100fd0:	83 c4 10             	add    $0x10,%esp
80100fd3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fe5:	eb ee                	jmp    80100fd5 <filestat+0x35>
80100fe7:	89 f6                	mov    %esi,%esi
80100fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101002:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101006:	74 60                	je     80101068 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101008:	8b 03                	mov    (%ebx),%eax
8010100a:	83 f8 01             	cmp    $0x1,%eax
8010100d:	74 41                	je     80101050 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100f:	83 f8 02             	cmp    $0x2,%eax
80101012:	75 5b                	jne    8010106f <fileread+0x7f>
    ilock(f->ip);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	ff 73 10             	pushl  0x10(%ebx)
8010101a:	e8 01 07 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010101f:	57                   	push   %edi
80101020:	ff 73 14             	pushl  0x14(%ebx)
80101023:	56                   	push   %esi
80101024:	ff 73 10             	pushl  0x10(%ebx)
80101027:	e8 d4 09 00 00       	call   80101a00 <readi>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	85 c0                	test   %eax,%eax
80101031:	89 c6                	mov    %eax,%esi
80101033:	7e 03                	jle    80101038 <fileread+0x48>
      f->off += r;
80101035:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 bd 07 00 00       	call   80101800 <iunlock>
    return r;
80101043:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	89 f0                	mov    %esi,%eax
8010104b:	5b                   	pop    %ebx
8010104c:	5e                   	pop    %esi
8010104d:	5f                   	pop    %edi
8010104e:	5d                   	pop    %ebp
8010104f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101050:	8b 43 0c             	mov    0xc(%ebx),%eax
80101053:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010105d:	e9 3e 25 00 00       	jmp    801035a0 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 c6 82 10 80       	push   $0x801082c6
80101077:	e8 14 f3 ff ff       	call   80100390 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 1c             	sub    $0x1c,%esp
80101089:	8b 75 08             	mov    0x8(%ebp),%esi
8010108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010108f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101093:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101096:	8b 45 10             	mov    0x10(%ebp),%eax
80101099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010109c:	0f 84 aa 00 00 00    	je     8010114c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010a2:	8b 06                	mov    (%esi),%eax
801010a4:	83 f8 01             	cmp    $0x1,%eax
801010a7:	0f 84 c3 00 00 00    	je     80101170 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ad:	83 f8 02             	cmp    $0x2,%eax
801010b0:	0f 85 d9 00 00 00    	jne    8010118f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010b9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 34                	jg     801010f3 <filewrite+0x73>
801010bf:	e9 9c 00 00 00       	jmp    80101160 <filewrite+0xe0>
801010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010cb:	83 ec 0c             	sub    $0xc,%esp
801010ce:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010d4:	e8 27 07 00 00       	call   80101800 <iunlock>
      end_op();
801010d9:	e8 d2 1b 00 00       	call   80102cb0 <end_op>
801010de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801010e4:	39 c3                	cmp    %eax,%ebx
801010e6:	0f 85 96 00 00 00    	jne    80101182 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801010ec:	01 df                	add    %ebx,%edi
    while(i < n){
801010ee:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010f1:	7e 6d                	jle    80101160 <filewrite+0xe0>
      int n1 = n - i;
801010f3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010f6:	b8 00 06 00 00       	mov    $0x600,%eax
801010fb:	29 fb                	sub    %edi,%ebx
801010fd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101103:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101106:	e8 35 1b 00 00       	call   80102c40 <begin_op>
      ilock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 76 10             	pushl  0x10(%esi)
80101111:	e8 0a 06 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101116:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101119:	53                   	push   %ebx
8010111a:	ff 76 14             	pushl  0x14(%esi)
8010111d:	01 f8                	add    %edi,%eax
8010111f:	50                   	push   %eax
80101120:	ff 76 10             	pushl  0x10(%esi)
80101123:	e8 d8 09 00 00       	call   80101b00 <writei>
80101128:	83 c4 20             	add    $0x20,%esp
8010112b:	85 c0                	test   %eax,%eax
8010112d:	7f 99                	jg     801010c8 <filewrite+0x48>
      iunlock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101138:	e8 c3 06 00 00       	call   80101800 <iunlock>
      end_op();
8010113d:	e8 6e 1b 00 00       	call   80102cb0 <end_op>
      if(r < 0)
80101142:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101145:	83 c4 10             	add    $0x10,%esp
80101148:	85 c0                	test   %eax,%eax
8010114a:	74 98                	je     801010e4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010114c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010114f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101154:	89 f8                	mov    %edi,%eax
80101156:	5b                   	pop    %ebx
80101157:	5e                   	pop    %esi
80101158:	5f                   	pop    %edi
80101159:	5d                   	pop    %ebp
8010115a:	c3                   	ret    
8010115b:	90                   	nop
8010115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101160:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101163:	75 e7                	jne    8010114c <filewrite+0xcc>
}
80101165:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101168:	89 f8                	mov    %edi,%eax
8010116a:	5b                   	pop    %ebx
8010116b:	5e                   	pop    %esi
8010116c:	5f                   	pop    %edi
8010116d:	5d                   	pop    %ebp
8010116e:	c3                   	ret    
8010116f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101170:	8b 46 0c             	mov    0xc(%esi),%eax
80101173:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101179:	5b                   	pop    %ebx
8010117a:	5e                   	pop    %esi
8010117b:	5f                   	pop    %edi
8010117c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010117d:	e9 0e 23 00 00       	jmp    80103490 <pipewrite>
        panic("short filewrite");
80101182:	83 ec 0c             	sub    $0xc,%esp
80101185:	68 cf 82 10 80       	push   $0x801082cf
8010118a:	e8 01 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	68 d5 82 10 80       	push   $0x801082d5
80101197:	e8 f4 f1 ff ff       	call   80100390 <panic>
8010119c:	66 90                	xchg   %ax,%ax
8010119e:	66 90                	xchg   %ax,%ax

801011a0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011a9:	8b 0d 60 1a 11 80    	mov    0x80111a60,%ecx
{
801011af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011b2:	85 c9                	test   %ecx,%ecx
801011b4:	0f 84 87 00 00 00    	je     80101241 <balloc+0xa1>
801011ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	89 f0                	mov    %esi,%eax
801011c9:	c1 f8 0c             	sar    $0xc,%eax
801011cc:	03 05 78 1a 11 80    	add    0x80111a78,%eax
801011d2:	50                   	push   %eax
801011d3:	ff 75 d8             	pushl  -0x28(%ebp)
801011d6:	e8 f5 ee ff ff       	call   801000d0 <bread>
801011db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011de:	a1 60 1a 11 80       	mov    0x80111a60,%eax
801011e3:	83 c4 10             	add    $0x10,%esp
801011e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011e9:	31 c0                	xor    %eax,%eax
801011eb:	eb 2f                	jmp    8010121c <balloc+0x7c>
801011ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011f0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011f5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011fa:	83 e1 07             	and    $0x7,%ecx
801011fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ff:	89 c1                	mov    %eax,%ecx
80101201:	c1 f9 03             	sar    $0x3,%ecx
80101204:	0f b6 7c 0a 60       	movzbl 0x60(%edx,%ecx,1),%edi
80101209:	85 df                	test   %ebx,%edi
8010120b:	89 fa                	mov    %edi,%edx
8010120d:	74 41                	je     80101250 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010120f:	83 c0 01             	add    $0x1,%eax
80101212:	83 c6 01             	add    $0x1,%esi
80101215:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010121a:	74 05                	je     80101221 <balloc+0x81>
8010121c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010121f:	77 cf                	ja     801011f0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	ff 75 e4             	pushl  -0x1c(%ebp)
80101227:	e8 b4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010122c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101233:	83 c4 10             	add    $0x10,%esp
80101236:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101239:	39 05 60 1a 11 80    	cmp    %eax,0x80111a60
8010123f:	77 80                	ja     801011c1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	68 df 82 10 80       	push   $0x801082df
80101249:	e8 42 f1 ff ff       	call   80100390 <panic>
8010124e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101250:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101253:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101256:	09 da                	or     %ebx,%edx
80101258:	88 54 0f 60          	mov    %dl,0x60(%edi,%ecx,1)
        log_write(bp);
8010125c:	57                   	push   %edi
8010125d:	e8 ae 1b 00 00       	call   80102e10 <log_write>
        brelse(bp);
80101262:	89 3c 24             	mov    %edi,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010126a:	58                   	pop    %eax
8010126b:	5a                   	pop    %edx
8010126c:	56                   	push   %esi
8010126d:	ff 75 d8             	pushl  -0x28(%ebp)
80101270:	e8 5b ee ff ff       	call   801000d0 <bread>
80101275:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101277:	8d 40 60             	lea    0x60(%eax),%eax
8010127a:	83 c4 0c             	add    $0xc,%esp
8010127d:	68 00 02 00 00       	push   $0x200
80101282:	6a 00                	push   $0x0
80101284:	50                   	push   %eax
80101285:	e8 66 42 00 00       	call   801054f0 <memset>
  log_write(bp);
8010128a:	89 1c 24             	mov    %ebx,(%esp)
8010128d:	e8 7e 1b 00 00       	call   80102e10 <log_write>
  brelse(bp);
80101292:	89 1c 24             	mov    %ebx,(%esp)
80101295:	e8 46 ef ff ff       	call   801001e0 <brelse>
}
8010129a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129d:	89 f0                	mov    %esi,%eax
8010129f:	5b                   	pop    %ebx
801012a0:	5e                   	pop    %esi
801012a1:	5f                   	pop    %edi
801012a2:	5d                   	pop    %ebp
801012a3:	c3                   	ret    
801012a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012b8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ba:	bb b8 1a 11 80       	mov    $0x80111ab8,%ebx
{
801012bf:	83 ec 28             	sub    $0x28,%esp
801012c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012c5:	68 80 1a 11 80       	push   $0x80111a80
801012ca:	e8 01 41 00 00       	call   801053d0 <acquire>
801012cf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012d5:	eb 17                	jmp    801012ee <iget+0x3e>
801012d7:	89 f6                	mov    %esi,%esi
801012d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012e0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801012e6:	81 fb a0 37 11 80    	cmp    $0x801137a0,%ebx
801012ec:	73 22                	jae    80101310 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012f1:	85 c9                	test   %ecx,%ecx
801012f3:	7e 04                	jle    801012f9 <iget+0x49>
801012f5:	39 3b                	cmp    %edi,(%ebx)
801012f7:	74 4f                	je     80101348 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f9:	85 f6                	test   %esi,%esi
801012fb:	75 e3                	jne    801012e0 <iget+0x30>
801012fd:	85 c9                	test   %ecx,%ecx
801012ff:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101302:	81 c3 94 00 00 00    	add    $0x94,%ebx
80101308:	81 fb a0 37 11 80    	cmp    $0x801137a0,%ebx
8010130e:	72 de                	jb     801012ee <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101310:	85 f6                	test   %esi,%esi
80101312:	74 5b                	je     8010136f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101314:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101317:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101319:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010131c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101323:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
  release(&icache.lock);
8010132a:	68 80 1a 11 80       	push   $0x80111a80
8010132f:	e8 6c 41 00 00       	call   801054a0 <release>

  return ip;
80101334:	83 c4 10             	add    $0x10,%esp
}
80101337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5f                   	pop    %edi
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    
80101341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101348:	39 53 04             	cmp    %edx,0x4(%ebx)
8010134b:	75 ac                	jne    801012f9 <iget+0x49>
      release(&icache.lock);
8010134d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101350:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101353:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101355:	68 80 1a 11 80       	push   $0x80111a80
      ip->ref++;
8010135a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010135d:	e8 3e 41 00 00       	call   801054a0 <release>
      return ip;
80101362:	83 c4 10             	add    $0x10,%esp
}
80101365:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101368:	89 f0                	mov    %esi,%eax
8010136a:	5b                   	pop    %ebx
8010136b:	5e                   	pop    %esi
8010136c:	5f                   	pop    %edi
8010136d:	5d                   	pop    %ebp
8010136e:	c3                   	ret    
    panic("iget: no inodes");
8010136f:	83 ec 0c             	sub    $0xc,%esp
80101372:	68 f5 82 10 80       	push   $0x801082f5
80101377:	e8 14 f0 ff ff       	call   80100390 <panic>
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101380 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	53                   	push   %ebx
80101386:	89 c6                	mov    %eax,%esi
80101388:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010138b:	83 fa 0b             	cmp    $0xb,%edx
8010138e:	77 18                	ja     801013a8 <bmap+0x28>
80101390:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101393:	8b 5f 60             	mov    0x60(%edi),%ebx
80101396:	85 db                	test   %ebx,%ebx
80101398:	74 76                	je     80101410 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5f                   	pop    %edi
801013a2:	5d                   	pop    %ebp
801013a3:	c3                   	ret    
801013a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013a8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013ab:	83 fb 7f             	cmp    $0x7f,%ebx
801013ae:	0f 87 90 00 00 00    	ja     80101444 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013b4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801013ba:	8b 00                	mov    (%eax),%eax
801013bc:	85 d2                	test   %edx,%edx
801013be:	74 70                	je     80101430 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013c0:	83 ec 08             	sub    $0x8,%esp
801013c3:	52                   	push   %edx
801013c4:	50                   	push   %eax
801013c5:	e8 06 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013ca:	8d 54 98 60          	lea    0x60(%eax,%ebx,4),%edx
801013ce:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013d1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013d3:	8b 1a                	mov    (%edx),%ebx
801013d5:	85 db                	test   %ebx,%ebx
801013d7:	75 1d                	jne    801013f6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013d9:	8b 06                	mov    (%esi),%eax
801013db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013de:	e8 bd fd ff ff       	call   801011a0 <balloc>
801013e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013e6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013e9:	89 c3                	mov    %eax,%ebx
801013eb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013ed:	57                   	push   %edi
801013ee:	e8 1d 1a 00 00       	call   80102e10 <log_write>
801013f3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013f6:	83 ec 0c             	sub    $0xc,%esp
801013f9:	57                   	push   %edi
801013fa:	e8 e1 ed ff ff       	call   801001e0 <brelse>
801013ff:	83 c4 10             	add    $0x10,%esp
}
80101402:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101405:	89 d8                	mov    %ebx,%eax
80101407:	5b                   	pop    %ebx
80101408:	5e                   	pop    %esi
80101409:	5f                   	pop    %edi
8010140a:	5d                   	pop    %ebp
8010140b:	c3                   	ret    
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101410:	8b 00                	mov    (%eax),%eax
80101412:	e8 89 fd ff ff       	call   801011a0 <balloc>
80101417:	89 47 60             	mov    %eax,0x60(%edi)
}
8010141a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010141d:	89 c3                	mov    %eax,%ebx
}
8010141f:	89 d8                	mov    %ebx,%eax
80101421:	5b                   	pop    %ebx
80101422:	5e                   	pop    %esi
80101423:	5f                   	pop    %edi
80101424:	5d                   	pop    %ebp
80101425:	c3                   	ret    
80101426:	8d 76 00             	lea    0x0(%esi),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101430:	e8 6b fd ff ff       	call   801011a0 <balloc>
80101435:	89 c2                	mov    %eax,%edx
80101437:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
8010143d:	8b 06                	mov    (%esi),%eax
8010143f:	e9 7c ff ff ff       	jmp    801013c0 <bmap+0x40>
  panic("bmap: out of range");
80101444:	83 ec 0c             	sub    $0xc,%esp
80101447:	68 05 83 10 80       	push   $0x80108305
8010144c:	e8 3f ef ff ff       	call   80100390 <panic>
80101451:	eb 0d                	jmp    80101460 <readsb>
80101453:	90                   	nop
80101454:	90                   	nop
80101455:	90                   	nop
80101456:	90                   	nop
80101457:	90                   	nop
80101458:	90                   	nop
80101459:	90                   	nop
8010145a:	90                   	nop
8010145b:	90                   	nop
8010145c:	90                   	nop
8010145d:	90                   	nop
8010145e:	90                   	nop
8010145f:	90                   	nop

80101460 <readsb>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	56                   	push   %esi
80101464:	53                   	push   %ebx
80101465:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101468:	83 ec 08             	sub    $0x8,%esp
8010146b:	6a 01                	push   $0x1
8010146d:	ff 75 08             	pushl  0x8(%ebp)
80101470:	e8 5b ec ff ff       	call   801000d0 <bread>
80101475:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101477:	8d 40 60             	lea    0x60(%eax),%eax
8010147a:	83 c4 0c             	add    $0xc,%esp
8010147d:	6a 1c                	push   $0x1c
8010147f:	50                   	push   %eax
80101480:	56                   	push   %esi
80101481:	e8 1a 41 00 00       	call   801055a0 <memmove>
  brelse(bp);
80101486:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101489:	83 c4 10             	add    $0x10,%esp
}
8010148c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5d                   	pop    %ebp
  brelse(bp);
80101492:	e9 49 ed ff ff       	jmp    801001e0 <brelse>
80101497:	89 f6                	mov    %esi,%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	56                   	push   %esi
801014a4:	53                   	push   %ebx
801014a5:	89 d3                	mov    %edx,%ebx
801014a7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801014a9:	83 ec 08             	sub    $0x8,%esp
801014ac:	68 60 1a 11 80       	push   $0x80111a60
801014b1:	50                   	push   %eax
801014b2:	e8 a9 ff ff ff       	call   80101460 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014b7:	58                   	pop    %eax
801014b8:	5a                   	pop    %edx
801014b9:	89 da                	mov    %ebx,%edx
801014bb:	c1 ea 0c             	shr    $0xc,%edx
801014be:	03 15 78 1a 11 80    	add    0x80111a78,%edx
801014c4:	52                   	push   %edx
801014c5:	56                   	push   %esi
801014c6:	e8 05 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014cb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014cd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014d0:	ba 01 00 00 00       	mov    $0x1,%edx
801014d5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014d8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014de:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014e1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014e3:	0f b6 4c 18 60       	movzbl 0x60(%eax,%ebx,1),%ecx
801014e8:	85 d1                	test   %edx,%ecx
801014ea:	74 25                	je     80101511 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014ec:	f7 d2                	not    %edx
801014ee:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014f0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014f3:	21 ca                	and    %ecx,%edx
801014f5:	88 54 1e 60          	mov    %dl,0x60(%esi,%ebx,1)
  log_write(bp);
801014f9:	56                   	push   %esi
801014fa:	e8 11 19 00 00       	call   80102e10 <log_write>
  brelse(bp);
801014ff:	89 34 24             	mov    %esi,(%esp)
80101502:	e8 d9 ec ff ff       	call   801001e0 <brelse>
}
80101507:	83 c4 10             	add    $0x10,%esp
8010150a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010150d:	5b                   	pop    %ebx
8010150e:	5e                   	pop    %esi
8010150f:	5d                   	pop    %ebp
80101510:	c3                   	ret    
    panic("freeing free block");
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	68 18 83 10 80       	push   $0x80108318
80101519:	e8 72 ee ff ff       	call   80100390 <panic>
8010151e:	66 90                	xchg   %ax,%ax

80101520 <iinit>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	53                   	push   %ebx
80101524:	bb c4 1a 11 80       	mov    $0x80111ac4,%ebx
80101529:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010152c:	68 2b 83 10 80       	push   $0x8010832b
80101531:	68 80 1a 11 80       	push   $0x80111a80
80101536:	e8 55 3d 00 00       	call   80105290 <initlock>
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	68 32 83 10 80       	push   $0x80108332
80101548:	53                   	push   %ebx
80101549:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010154f:	e8 0c 3c 00 00       	call   80105160 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	81 fb ac 37 11 80    	cmp    $0x801137ac,%ebx
8010155d:	75 e1                	jne    80101540 <iinit+0x20>
  readsb(dev, &sb);
8010155f:	83 ec 08             	sub    $0x8,%esp
80101562:	68 60 1a 11 80       	push   $0x80111a60
80101567:	ff 75 08             	pushl  0x8(%ebp)
8010156a:	e8 f1 fe ff ff       	call   80101460 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010156f:	ff 35 78 1a 11 80    	pushl  0x80111a78
80101575:	ff 35 74 1a 11 80    	pushl  0x80111a74
8010157b:	ff 35 70 1a 11 80    	pushl  0x80111a70
80101581:	ff 35 6c 1a 11 80    	pushl  0x80111a6c
80101587:	ff 35 68 1a 11 80    	pushl  0x80111a68
8010158d:	ff 35 64 1a 11 80    	pushl  0x80111a64
80101593:	ff 35 60 1a 11 80    	pushl  0x80111a60
80101599:	68 98 83 10 80       	push   $0x80108398
8010159e:	e8 bd f0 ff ff       	call   80100660 <cprintf>
}
801015a3:	83 c4 30             	add    $0x30,%esp
801015a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015a9:	c9                   	leave  
801015aa:	c3                   	ret    
801015ab:	90                   	nop
801015ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015b0 <ialloc>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015b9:	83 3d 68 1a 11 80 01 	cmpl   $0x1,0x80111a68
{
801015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c3:	8b 75 08             	mov    0x8(%ebp),%esi
801015c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015c9:	0f 86 91 00 00 00    	jbe    80101660 <ialloc+0xb0>
801015cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015d4:	eb 21                	jmp    801015f7 <ialloc+0x47>
801015d6:	8d 76 00             	lea    0x0(%esi),%esi
801015d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015e3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015e6:	57                   	push   %edi
801015e7:	e8 f4 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	39 1d 68 1a 11 80    	cmp    %ebx,0x80111a68
801015f5:	76 69                	jbe    80101660 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015f7:	89 d8                	mov    %ebx,%eax
801015f9:	83 ec 08             	sub    $0x8,%esp
801015fc:	c1 e8 03             	shr    $0x3,%eax
801015ff:	03 05 74 1a 11 80    	add    0x80111a74,%eax
80101605:	50                   	push   %eax
80101606:	56                   	push   %esi
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
8010160c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010160e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101610:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101613:	83 e0 07             	and    $0x7,%eax
80101616:	c1 e0 06             	shl    $0x6,%eax
80101619:	8d 4c 07 60          	lea    0x60(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010161d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101621:	75 bd                	jne    801015e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101623:	83 ec 04             	sub    $0x4,%esp
80101626:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101629:	6a 40                	push   $0x40
8010162b:	6a 00                	push   $0x0
8010162d:	51                   	push   %ecx
8010162e:	e8 bd 3e 00 00       	call   801054f0 <memset>
      dip->type = type;
80101633:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010163a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010163d:	89 3c 24             	mov    %edi,(%esp)
80101640:	e8 cb 17 00 00       	call   80102e10 <log_write>
      brelse(bp);
80101645:	89 3c 24             	mov    %edi,(%esp)
80101648:	e8 93 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010164d:	83 c4 10             	add    $0x10,%esp
}
80101650:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101653:	89 da                	mov    %ebx,%edx
80101655:	89 f0                	mov    %esi,%eax
}
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5f                   	pop    %edi
8010165a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010165b:	e9 50 fc ff ff       	jmp    801012b0 <iget>
  panic("ialloc: no inodes");
80101660:	83 ec 0c             	sub    $0xc,%esp
80101663:	68 38 83 10 80       	push   $0x80108338
80101668:	e8 23 ed ff ff       	call   80100390 <panic>
8010166d:	8d 76 00             	lea    0x0(%esi),%esi

80101670 <iupdate>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101678:	83 ec 08             	sub    $0x8,%esp
8010167b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167e:	83 c3 60             	add    $0x60,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101681:	c1 e8 03             	shr    $0x3,%eax
80101684:	03 05 74 1a 11 80    	add    0x80111a74,%eax
8010168a:	50                   	push   %eax
8010168b:	ff 73 a0             	pushl  -0x60(%ebx)
8010168e:	e8 3d ea ff ff       	call   801000d0 <bread>
80101693:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101695:	8b 43 a4             	mov    -0x5c(%ebx),%eax
  dip->type = ip->type;
80101698:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010169f:	83 e0 07             	and    $0x7,%eax
801016a2:	c1 e0 06             	shl    $0x6,%eax
801016a5:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
  dip->type = ip->type;
801016a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cd:	6a 34                	push   $0x34
801016cf:	53                   	push   %ebx
801016d0:	50                   	push   %eax
801016d1:	e8 ca 3e 00 00       	call   801055a0 <memmove>
  log_write(bp);
801016d6:	89 34 24             	mov    %esi,(%esp)
801016d9:	e8 32 17 00 00       	call   80102e10 <log_write>
  brelse(bp);
801016de:	89 75 08             	mov    %esi,0x8(%ebp)
801016e1:	83 c4 10             	add    $0x10,%esp
}
801016e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e7:	5b                   	pop    %ebx
801016e8:	5e                   	pop    %esi
801016e9:	5d                   	pop    %ebp
  brelse(bp);
801016ea:	e9 f1 ea ff ff       	jmp    801001e0 <brelse>
801016ef:	90                   	nop

801016f0 <idup>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	53                   	push   %ebx
801016f4:	83 ec 10             	sub    $0x10,%esp
801016f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fa:	68 80 1a 11 80       	push   $0x80111a80
801016ff:	e8 cc 3c 00 00       	call   801053d0 <acquire>
  ip->ref++;
80101704:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101708:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010170f:	e8 8c 3d 00 00       	call   801054a0 <release>
}
80101714:	89 d8                	mov    %ebx,%eax
80101716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101719:	c9                   	leave  
8010171a:	c3                   	ret    
8010171b:	90                   	nop
8010171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101720 <ilock>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101728:	85 db                	test   %ebx,%ebx
8010172a:	0f 84 b7 00 00 00    	je     801017e7 <ilock+0xc7>
80101730:	8b 53 08             	mov    0x8(%ebx),%edx
80101733:	85 d2                	test   %edx,%edx
80101735:	0f 8e ac 00 00 00    	jle    801017e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010173b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010173e:	83 ec 0c             	sub    $0xc,%esp
80101741:	50                   	push   %eax
80101742:	e8 59 3a 00 00       	call   801051a0 <acquiresleep>
  if(ip->valid == 0){
80101747:	8b 43 50             	mov    0x50(%ebx),%eax
8010174a:	83 c4 10             	add    $0x10,%esp
8010174d:	85 c0                	test   %eax,%eax
8010174f:	74 0f                	je     80101760 <ilock+0x40>
}
80101751:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101754:	5b                   	pop    %ebx
80101755:	5e                   	pop    %esi
80101756:	5d                   	pop    %ebp
80101757:	c3                   	ret    
80101758:	90                   	nop
80101759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	8b 43 04             	mov    0x4(%ebx),%eax
80101763:	83 ec 08             	sub    $0x8,%esp
80101766:	c1 e8 03             	shr    $0x3,%eax
80101769:	03 05 74 1a 11 80    	add    0x80111a74,%eax
8010176f:	50                   	push   %eax
80101770:	ff 33                	pushl  (%ebx)
80101772:	e8 59 e9 ff ff       	call   801000d0 <bread>
80101777:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101779:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010177c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
    ip->type = dip->type;
80101789:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010178c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010178f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->major = dip->major;
80101793:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101797:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->minor = dip->minor;
8010179b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010179f:	66 89 53 58          	mov    %dx,0x58(%ebx)
    ip->nlink = dip->nlink;
801017a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017a7:	66 89 53 5a          	mov    %dx,0x5a(%ebx)
    ip->size = dip->size;
801017ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ae:	89 53 5c             	mov    %edx,0x5c(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b1:	6a 34                	push   $0x34
801017b3:	50                   	push   %eax
801017b4:	8d 43 60             	lea    0x60(%ebx),%eax
801017b7:	50                   	push   %eax
801017b8:	e8 e3 3d 00 00       	call   801055a0 <memmove>
    brelse(bp);
801017bd:	89 34 24             	mov    %esi,(%esp)
801017c0:	e8 1b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017c5:	83 c4 10             	add    $0x10,%esp
801017c8:	66 83 7b 54 00       	cmpw   $0x0,0x54(%ebx)
    ip->valid = 1;
801017cd:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
    if(ip->type == 0)
801017d4:	0f 85 77 ff ff ff    	jne    80101751 <ilock+0x31>
      panic("ilock: no type");
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	68 50 83 10 80       	push   $0x80108350
801017e2:	e8 a9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	68 4a 83 10 80       	push   $0x8010834a
801017ef:	e8 9c eb ff ff       	call   80100390 <panic>
801017f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101800 <iunlock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101808:	85 db                	test   %ebx,%ebx
8010180a:	74 28                	je     80101834 <iunlock+0x34>
8010180c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010180f:	83 ec 0c             	sub    $0xc,%esp
80101812:	56                   	push   %esi
80101813:	e8 28 3a 00 00       	call   80105240 <holdingsleep>
80101818:	83 c4 10             	add    $0x10,%esp
8010181b:	85 c0                	test   %eax,%eax
8010181d:	74 15                	je     80101834 <iunlock+0x34>
8010181f:	8b 43 08             	mov    0x8(%ebx),%eax
80101822:	85 c0                	test   %eax,%eax
80101824:	7e 0e                	jle    80101834 <iunlock+0x34>
  releasesleep(&ip->lock);
80101826:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010182f:	e9 cc 39 00 00       	jmp    80105200 <releasesleep>
    panic("iunlock");
80101834:	83 ec 0c             	sub    $0xc,%esp
80101837:	68 5f 83 10 80       	push   $0x8010835f
8010183c:	e8 4f eb ff ff       	call   80100390 <panic>
80101841:	eb 0d                	jmp    80101850 <iput>
80101843:	90                   	nop
80101844:	90                   	nop
80101845:	90                   	nop
80101846:	90                   	nop
80101847:	90                   	nop
80101848:	90                   	nop
80101849:	90                   	nop
8010184a:	90                   	nop
8010184b:	90                   	nop
8010184c:	90                   	nop
8010184d:	90                   	nop
8010184e:	90                   	nop
8010184f:	90                   	nop

80101850 <iput>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	57                   	push   %edi
80101854:	56                   	push   %esi
80101855:	53                   	push   %ebx
80101856:	83 ec 28             	sub    $0x28,%esp
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010185c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010185f:	57                   	push   %edi
80101860:	e8 3b 39 00 00       	call   801051a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101865:	8b 53 50             	mov    0x50(%ebx),%edx
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	85 d2                	test   %edx,%edx
8010186d:	74 07                	je     80101876 <iput+0x26>
8010186f:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
80101874:	74 32                	je     801018a8 <iput+0x58>
  releasesleep(&ip->lock);
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	57                   	push   %edi
8010187a:	e8 81 39 00 00       	call   80105200 <releasesleep>
  acquire(&icache.lock);
8010187f:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101886:	e8 45 3b 00 00       	call   801053d0 <acquire>
  ip->ref--;
8010188b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	c7 45 08 80 1a 11 80 	movl   $0x80111a80,0x8(%ebp)
}
80101899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5f                   	pop    %edi
8010189f:	5d                   	pop    %ebp
  release(&icache.lock);
801018a0:	e9 fb 3b 00 00       	jmp    801054a0 <release>
801018a5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 80 1a 11 80       	push   $0x80111a80
801018b0:	e8 1b 3b 00 00       	call   801053d0 <acquire>
    int r = ip->ref;
801018b5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018b8:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801018bf:	e8 dc 3b 00 00       	call   801054a0 <release>
    if(r == 1){
801018c4:	83 c4 10             	add    $0x10,%esp
801018c7:	83 fe 01             	cmp    $0x1,%esi
801018ca:	75 aa                	jne    80101876 <iput+0x26>
801018cc:	8d 8b 90 00 00 00    	lea    0x90(%ebx),%ecx
801018d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018d5:	8d 73 60             	lea    0x60(%ebx),%esi
801018d8:	89 cf                	mov    %ecx,%edi
801018da:	eb 0b                	jmp    801018e7 <iput+0x97>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018e0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018e3:	39 fe                	cmp    %edi,%esi
801018e5:	74 19                	je     80101900 <iput+0xb0>
    if(ip->addrs[i]){
801018e7:	8b 16                	mov    (%esi),%edx
801018e9:	85 d2                	test   %edx,%edx
801018eb:	74 f3                	je     801018e0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018ed:	8b 03                	mov    (%ebx),%eax
801018ef:	e8 ac fb ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
801018f4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018fa:	eb e4                	jmp    801018e0 <iput+0x90>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101900:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80101906:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101909:	85 c0                	test   %eax,%eax
8010190b:	75 33                	jne    80101940 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010190d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101910:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  iupdate(ip);
80101917:	53                   	push   %ebx
80101918:	e8 53 fd ff ff       	call   80101670 <iupdate>
      ip->type = 0;
8010191d:	31 c0                	xor    %eax,%eax
8010191f:	66 89 43 54          	mov    %ax,0x54(%ebx)
      iupdate(ip);
80101923:	89 1c 24             	mov    %ebx,(%esp)
80101926:	e8 45 fd ff ff       	call   80101670 <iupdate>
      ip->valid = 0;
8010192b:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
80101932:	83 c4 10             	add    $0x10,%esp
80101935:	e9 3c ff ff ff       	jmp    80101876 <iput+0x26>
8010193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	50                   	push   %eax
80101944:	ff 33                	pushl  (%ebx)
80101946:	e8 85 e7 ff ff       	call   801000d0 <bread>
8010194b:	8d 88 60 02 00 00    	lea    0x260(%eax),%ecx
80101951:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101957:	8d 70 60             	lea    0x60(%eax),%esi
8010195a:	83 c4 10             	add    $0x10,%esp
8010195d:	89 cf                	mov    %ecx,%edi
8010195f:	eb 0e                	jmp    8010196f <iput+0x11f>
80101961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101968:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010196b:	39 fe                	cmp    %edi,%esi
8010196d:	74 0f                	je     8010197e <iput+0x12e>
      if(a[j])
8010196f:	8b 16                	mov    (%esi),%edx
80101971:	85 d2                	test   %edx,%edx
80101973:	74 f3                	je     80101968 <iput+0x118>
        bfree(ip->dev, a[j]);
80101975:	8b 03                	mov    (%ebx),%eax
80101977:	e8 24 fb ff ff       	call   801014a0 <bfree>
8010197c:	eb ea                	jmp    80101968 <iput+0x118>
    brelse(bp);
8010197e:	83 ec 0c             	sub    $0xc,%esp
80101981:	ff 75 e4             	pushl  -0x1c(%ebp)
80101984:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101987:	e8 54 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010198c:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
80101992:	8b 03                	mov    (%ebx),%eax
80101994:	e8 07 fb ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101999:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801019a0:	00 00 00 
801019a3:	83 c4 10             	add    $0x10,%esp
801019a6:	e9 62 ff ff ff       	jmp    8010190d <iput+0xbd>
801019ab:	90                   	nop
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019b0 <iunlockput>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	53                   	push   %ebx
801019b4:	83 ec 10             	sub    $0x10,%esp
801019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ba:	53                   	push   %ebx
801019bb:	e8 40 fe ff ff       	call   80101800 <iunlock>
  iput(ip);
801019c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019c3:	83 c4 10             	add    $0x10,%esp
}
801019c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019c9:	c9                   	leave  
  iput(ip);
801019ca:	e9 81 fe ff ff       	jmp    80101850 <iput>
801019cf:	90                   	nop

801019d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	8b 55 08             	mov    0x8(%ebp),%edx
801019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019d9:	8b 0a                	mov    (%edx),%ecx
801019db:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019de:	8b 4a 04             	mov    0x4(%edx),%ecx
801019e1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019e4:	0f b7 4a 54          	movzwl 0x54(%edx),%ecx
801019e8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019eb:	0f b7 4a 5a          	movzwl 0x5a(%edx),%ecx
801019ef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019f3:	8b 52 5c             	mov    0x5c(%edx),%edx
801019f6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	90                   	nop
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 1c             	sub    $0x1c,%esp
80101a09:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a12:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
{
80101a17:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a23:	0f 84 a7 00 00 00    	je     80101ad0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a2c:	8b 40 5c             	mov    0x5c(%eax),%eax
80101a2f:	39 c6                	cmp    %eax,%esi
80101a31:	0f 87 ba 00 00 00    	ja     80101af1 <readi+0xf1>
80101a37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a3a:	89 f9                	mov    %edi,%ecx
80101a3c:	01 f1                	add    %esi,%ecx
80101a3e:	0f 82 ad 00 00 00    	jb     80101af1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a44:	89 c2                	mov    %eax,%edx
80101a46:	29 f2                	sub    %esi,%edx
80101a48:	39 c8                	cmp    %ecx,%eax
80101a4a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a4d:	31 ff                	xor    %edi,%edi
80101a4f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a51:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a54:	74 6c                	je     80101ac2 <readi+0xc2>
80101a56:	8d 76 00             	lea    0x0(%esi),%esi
80101a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a63:	89 f2                	mov    %esi,%edx
80101a65:	c1 ea 09             	shr    $0x9,%edx
80101a68:	89 d8                	mov    %ebx,%eax
80101a6a:	e8 11 f9 ff ff       	call   80101380 <bmap>
80101a6f:	83 ec 08             	sub    $0x8,%esp
80101a72:	50                   	push   %eax
80101a73:	ff 33                	pushl  (%ebx)
80101a75:	e8 56 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a7d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7f:	89 f0                	mov    %esi,%eax
80101a81:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a86:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a8b:	83 c4 0c             	add    $0xc,%esp
80101a8e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a90:	8d 44 02 60          	lea    0x60(%edx,%eax,1),%eax
80101a94:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a97:	29 fb                	sub    %edi,%ebx
80101a99:	39 d9                	cmp    %ebx,%ecx
80101a9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a9e:	53                   	push   %ebx
80101a9f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa7:	e8 f4 3a 00 00       	call   801055a0 <memmove>
    brelse(bp);
80101aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aaf:	89 14 24             	mov    %edx,(%esp)
80101ab2:	e8 29 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ac0:	77 9e                	ja     80101a60 <readi+0x60>
  }
  return n;
80101ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac8:	5b                   	pop    %ebx
80101ac9:	5e                   	pop    %esi
80101aca:	5f                   	pop    %edi
80101acb:	5d                   	pop    %ebp
80101acc:	c3                   	ret    
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 17                	ja     80101af1 <readi+0xf1>
80101ada:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aef:	ff e0                	jmp    *%eax
      return -1;
80101af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af6:	eb cd                	jmp    80101ac5 <readi+0xc5>
80101af8:	90                   	nop
80101af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
{
80101b17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b23:	0f 84 b7 00 00 00    	je     80101be0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	39 70 5c             	cmp    %esi,0x5c(%eax)
80101b2f:	0f 82 eb 00 00 00    	jb     80101c20 <writei+0x120>
80101b35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b38:	31 d2                	xor    %edx,%edx
80101b3a:	89 f8                	mov    %edi,%eax
80101b3c:	01 f0                	add    %esi,%eax
80101b3e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b41:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b46:	0f 87 d4 00 00 00    	ja     80101c20 <writei+0x120>
80101b4c:	85 d2                	test   %edx,%edx
80101b4e:	0f 85 cc 00 00 00    	jne    80101c20 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b54:	85 ff                	test   %edi,%edi
80101b56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b5d:	74 72                	je     80101bd1 <writei+0xd1>
80101b5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 f8                	mov    %edi,%eax
80101b6a:	e8 11 f8 ff ff       	call   80101380 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 37                	pushl  (%edi)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b7d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b82:	89 f0                	mov    %esi,%eax
80101b84:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b89:	83 c4 0c             	add    $0xc,%esp
80101b8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b93:	8d 44 07 60          	lea    0x60(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	39 d9                	cmp    %ebx,%ecx
80101b99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b9c:	53                   	push   %ebx
80101b9d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ba0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ba2:	50                   	push   %eax
80101ba3:	e8 f8 39 00 00       	call   801055a0 <memmove>
    log_write(bp);
80101ba8:	89 3c 24             	mov    %edi,(%esp)
80101bab:	e8 60 12 00 00       	call   80102e10 <log_write>
    brelse(bp);
80101bb0:	89 3c 24             	mov    %edi,(%esp)
80101bb3:	e8 28 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bbb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bbe:	83 c4 10             	add    $0x10,%esp
80101bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bc7:	77 97                	ja     80101b60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 5c             	cmp    0x5c(%eax),%esi
80101bcf:	77 37                	ja     80101c08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd7:	5b                   	pop    %ebx
80101bd8:	5e                   	pop    %esi
80101bd9:	5f                   	pop    %edi
80101bda:	5d                   	pop    %ebp
80101bdb:	c3                   	ret    
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be0:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 36                	ja     80101c20 <writei+0x120>
80101bea:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 2b                	je     80101c20 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bff:	ff e0                	jmp    *%eax
80101c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c0e:	89 70 5c             	mov    %esi,0x5c(%eax)
    iupdate(ip);
80101c11:	50                   	push   %eax
80101c12:	e8 59 fa ff ff       	call   80101670 <iupdate>
80101c17:	83 c4 10             	add    $0x10,%esp
80101c1a:	eb b5                	jmp    80101bd1 <writei+0xd1>
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c25:	eb ad                	jmp    80101bd4 <writei+0xd4>
80101c27:	89 f6                	mov    %esi,%esi
80101c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c36:	6a 0e                	push   $0xe
80101c38:	ff 75 0c             	pushl  0xc(%ebp)
80101c3b:	ff 75 08             	pushl  0x8(%ebp)
80101c3e:	e8 cd 39 00 00       	call   80105610 <strncmp>
}
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    
80101c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c5c:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80101c61:	0f 85 85 00 00 00    	jne    80101cec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c67:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101c6a:	31 ff                	xor    %edi,%edi
80101c6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c6f:	85 d2                	test   %edx,%edx
80101c71:	74 3e                	je     80101cb1 <dirlookup+0x61>
80101c73:	90                   	nop
80101c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c78:	6a 10                	push   $0x10
80101c7a:	57                   	push   %edi
80101c7b:	56                   	push   %esi
80101c7c:	53                   	push   %ebx
80101c7d:	e8 7e fd ff ff       	call   80101a00 <readi>
80101c82:	83 c4 10             	add    $0x10,%esp
80101c85:	83 f8 10             	cmp    $0x10,%eax
80101c88:	75 55                	jne    80101cdf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c8f:	74 18                	je     80101ca9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c94:	83 ec 04             	sub    $0x4,%esp
80101c97:	6a 0e                	push   $0xe
80101c99:	50                   	push   %eax
80101c9a:	ff 75 0c             	pushl  0xc(%ebp)
80101c9d:	e8 6e 39 00 00       	call   80105610 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	85 c0                	test   %eax,%eax
80101ca7:	74 17                	je     80101cc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca9:	83 c7 10             	add    $0x10,%edi
80101cac:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101caf:	72 c7                	jb     80101c78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cb4:	31 c0                	xor    %eax,%eax
}
80101cb6:	5b                   	pop    %ebx
80101cb7:	5e                   	pop    %esi
80101cb8:	5f                   	pop    %edi
80101cb9:	5d                   	pop    %ebp
80101cba:	c3                   	ret    
80101cbb:	90                   	nop
80101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc3:	85 c0                	test   %eax,%eax
80101cc5:	74 05                	je     80101ccc <dirlookup+0x7c>
        *poff = off;
80101cc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ccc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cd0:	8b 03                	mov    (%ebx),%eax
80101cd2:	e8 d9 f5 ff ff       	call   801012b0 <iget>
}
80101cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cda:	5b                   	pop    %ebx
80101cdb:	5e                   	pop    %esi
80101cdc:	5f                   	pop    %edi
80101cdd:	5d                   	pop    %ebp
80101cde:	c3                   	ret    
      panic("dirlookup read");
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 79 83 10 80       	push   $0x80108379
80101ce7:	e8 a4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 67 83 10 80       	push   $0x80108367
80101cf4:	e8 97 e6 ff ff       	call   80100390 <panic>
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	89 cf                	mov    %ecx,%edi
80101d08:	89 c3                	mov    %eax,%ebx
80101d0a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d0d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d10:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d13:	0f 84 67 01 00 00    	je     80101e80 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d19:	e8 c2 1c 00 00       	call   801039e0 <myproc>
  acquire(&icache.lock);
80101d1e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d21:	8b 70 60             	mov    0x60(%eax),%esi
  acquire(&icache.lock);
80101d24:	68 80 1a 11 80       	push   $0x80111a80
80101d29:	e8 a2 36 00 00       	call   801053d0 <acquire>
  ip->ref++;
80101d2e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d32:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101d39:	e8 62 37 00 00       	call   801054a0 <release>
80101d3e:	83 c4 10             	add    $0x10,%esp
80101d41:	eb 08                	jmp    80101d4b <namex+0x4b>
80101d43:	90                   	nop
80101d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d4b:	0f b6 03             	movzbl (%ebx),%eax
80101d4e:	3c 2f                	cmp    $0x2f,%al
80101d50:	74 f6                	je     80101d48 <namex+0x48>
  if(*path == 0)
80101d52:	84 c0                	test   %al,%al
80101d54:	0f 84 ee 00 00 00    	je     80101e48 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d5a:	0f b6 03             	movzbl (%ebx),%eax
80101d5d:	3c 2f                	cmp    $0x2f,%al
80101d5f:	0f 84 b3 00 00 00    	je     80101e18 <namex+0x118>
80101d65:	84 c0                	test   %al,%al
80101d67:	89 da                	mov    %ebx,%edx
80101d69:	75 09                	jne    80101d74 <namex+0x74>
80101d6b:	e9 a8 00 00 00       	jmp    80101e18 <namex+0x118>
80101d70:	84 c0                	test   %al,%al
80101d72:	74 0a                	je     80101d7e <namex+0x7e>
    path++;
80101d74:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d77:	0f b6 02             	movzbl (%edx),%eax
80101d7a:	3c 2f                	cmp    $0x2f,%al
80101d7c:	75 f2                	jne    80101d70 <namex+0x70>
80101d7e:	89 d1                	mov    %edx,%ecx
80101d80:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d82:	83 f9 0d             	cmp    $0xd,%ecx
80101d85:	0f 8e 91 00 00 00    	jle    80101e1c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d8b:	83 ec 04             	sub    $0x4,%esp
80101d8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d91:	6a 0e                	push   $0xe
80101d93:	53                   	push   %ebx
80101d94:	57                   	push   %edi
80101d95:	e8 06 38 00 00       	call   801055a0 <memmove>
    path++;
80101d9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d9d:	83 c4 10             	add    $0x10,%esp
    path++;
80101da0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101da2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101da5:	75 11                	jne    80101db8 <namex+0xb8>
80101da7:	89 f6                	mov    %esi,%esi
80101da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101db0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101db3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101db6:	74 f8                	je     80101db0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101db8:	83 ec 0c             	sub    $0xc,%esp
80101dbb:	56                   	push   %esi
80101dbc:	e8 5f f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
80101dc9:	0f 85 91 00 00 00    	jne    80101e60 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dcf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dd2:	85 d2                	test   %edx,%edx
80101dd4:	74 09                	je     80101ddf <namex+0xdf>
80101dd6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101dd9:	0f 84 b7 00 00 00    	je     80101e96 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ddf:	83 ec 04             	sub    $0x4,%esp
80101de2:	6a 00                	push   $0x0
80101de4:	57                   	push   %edi
80101de5:	56                   	push   %esi
80101de6:	e8 65 fe ff ff       	call   80101c50 <dirlookup>
80101deb:	83 c4 10             	add    $0x10,%esp
80101dee:	85 c0                	test   %eax,%eax
80101df0:	74 6e                	je     80101e60 <namex+0x160>
  iunlock(ip);
80101df2:	83 ec 0c             	sub    $0xc,%esp
80101df5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101df8:	56                   	push   %esi
80101df9:	e8 02 fa ff ff       	call   80101800 <iunlock>
  iput(ip);
80101dfe:	89 34 24             	mov    %esi,(%esp)
80101e01:	e8 4a fa ff ff       	call   80101850 <iput>
80101e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e09:	83 c4 10             	add    $0x10,%esp
80101e0c:	89 c6                	mov    %eax,%esi
80101e0e:	e9 38 ff ff ff       	jmp    80101d4b <namex+0x4b>
80101e13:	90                   	nop
80101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e18:	89 da                	mov    %ebx,%edx
80101e1a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e22:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e25:	51                   	push   %ecx
80101e26:	53                   	push   %ebx
80101e27:	57                   	push   %edi
80101e28:	e8 73 37 00 00       	call   801055a0 <memmove>
    name[len] = 0;
80101e2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e30:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e33:	83 c4 10             	add    $0x10,%esp
80101e36:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e3a:	89 d3                	mov    %edx,%ebx
80101e3c:	e9 61 ff ff ff       	jmp    80101da2 <namex+0xa2>
80101e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e4b:	85 c0                	test   %eax,%eax
80101e4d:	75 5d                	jne    80101eac <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e52:	89 f0                	mov    %esi,%eax
80101e54:	5b                   	pop    %ebx
80101e55:	5e                   	pop    %esi
80101e56:	5f                   	pop    %edi
80101e57:	5d                   	pop    %ebp
80101e58:	c3                   	ret    
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 97 f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e69:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e6c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e6e:	e8 dd f9 ff ff       	call   80101850 <iput>
      return 0;
80101e73:	83 c4 10             	add    $0x10,%esp
}
80101e76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e79:	89 f0                	mov    %esi,%eax
80101e7b:	5b                   	pop    %ebx
80101e7c:	5e                   	pop    %esi
80101e7d:	5f                   	pop    %edi
80101e7e:	5d                   	pop    %ebp
80101e7f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e80:	ba 01 00 00 00       	mov    $0x1,%edx
80101e85:	b8 01 00 00 00       	mov    $0x1,%eax
80101e8a:	e8 21 f4 ff ff       	call   801012b0 <iget>
80101e8f:	89 c6                	mov    %eax,%esi
80101e91:	e9 b5 fe ff ff       	jmp    80101d4b <namex+0x4b>
      iunlock(ip);
80101e96:	83 ec 0c             	sub    $0xc,%esp
80101e99:	56                   	push   %esi
80101e9a:	e8 61 f9 ff ff       	call   80101800 <iunlock>
      return ip;
80101e9f:	83 c4 10             	add    $0x10,%esp
}
80101ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea5:	89 f0                	mov    %esi,%eax
80101ea7:	5b                   	pop    %ebx
80101ea8:	5e                   	pop    %esi
80101ea9:	5f                   	pop    %edi
80101eaa:	5d                   	pop    %ebp
80101eab:	c3                   	ret    
    iput(ip);
80101eac:	83 ec 0c             	sub    $0xc,%esp
80101eaf:	56                   	push   %esi
    return 0;
80101eb0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101eb2:	e8 99 f9 ff ff       	call   80101850 <iput>
    return 0;
80101eb7:	83 c4 10             	add    $0x10,%esp
80101eba:	eb 93                	jmp    80101e4f <namex+0x14f>
80101ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ec0 <dirlink>:
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	83 ec 20             	sub    $0x20,%esp
80101ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ecc:	6a 00                	push   $0x0
80101ece:	ff 75 0c             	pushl  0xc(%ebp)
80101ed1:	53                   	push   %ebx
80101ed2:	e8 79 fd ff ff       	call   80101c50 <dirlookup>
80101ed7:	83 c4 10             	add    $0x10,%esp
80101eda:	85 c0                	test   %eax,%eax
80101edc:	75 67                	jne    80101f45 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ede:	8b 7b 5c             	mov    0x5c(%ebx),%edi
80101ee1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ee4:	85 ff                	test   %edi,%edi
80101ee6:	74 29                	je     80101f11 <dirlink+0x51>
80101ee8:	31 ff                	xor    %edi,%edi
80101eea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eed:	eb 09                	jmp    80101ef8 <dirlink+0x38>
80101eef:	90                   	nop
80101ef0:	83 c7 10             	add    $0x10,%edi
80101ef3:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101ef6:	73 19                	jae    80101f11 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef8:	6a 10                	push   $0x10
80101efa:	57                   	push   %edi
80101efb:	56                   	push   %esi
80101efc:	53                   	push   %ebx
80101efd:	e8 fe fa ff ff       	call   80101a00 <readi>
80101f02:	83 c4 10             	add    $0x10,%esp
80101f05:	83 f8 10             	cmp    $0x10,%eax
80101f08:	75 4e                	jne    80101f58 <dirlink+0x98>
    if(de.inum == 0)
80101f0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f0f:	75 df                	jne    80101ef0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f14:	83 ec 04             	sub    $0x4,%esp
80101f17:	6a 0e                	push   $0xe
80101f19:	ff 75 0c             	pushl  0xc(%ebp)
80101f1c:	50                   	push   %eax
80101f1d:	e8 4e 37 00 00       	call   80105670 <strncpy>
  de.inum = inum;
80101f22:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f25:	6a 10                	push   $0x10
80101f27:	57                   	push   %edi
80101f28:	56                   	push   %esi
80101f29:	53                   	push   %ebx
  de.inum = inum;
80101f2a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f2e:	e8 cd fb ff ff       	call   80101b00 <writei>
80101f33:	83 c4 20             	add    $0x20,%esp
80101f36:	83 f8 10             	cmp    $0x10,%eax
80101f39:	75 2a                	jne    80101f65 <dirlink+0xa5>
  return 0;
80101f3b:	31 c0                	xor    %eax,%eax
}
80101f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f40:	5b                   	pop    %ebx
80101f41:	5e                   	pop    %esi
80101f42:	5f                   	pop    %edi
80101f43:	5d                   	pop    %ebp
80101f44:	c3                   	ret    
    iput(ip);
80101f45:	83 ec 0c             	sub    $0xc,%esp
80101f48:	50                   	push   %eax
80101f49:	e8 02 f9 ff ff       	call   80101850 <iput>
    return -1;
80101f4e:	83 c4 10             	add    $0x10,%esp
80101f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f56:	eb e5                	jmp    80101f3d <dirlink+0x7d>
      panic("dirlink read");
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	68 88 83 10 80       	push   $0x80108388
80101f60:	e8 2b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f65:	83 ec 0c             	sub    $0xc,%esp
80101f68:	68 22 8a 10 80       	push   $0x80108a22
80101f6d:	e8 1e e4 ff ff       	call   80100390 <panic>
80101f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f80 <namei>:

struct inode*
namei(char *path)
{
80101f80:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f81:	31 d2                	xor    %edx,%edx
{
80101f83:	89 e5                	mov    %esp,%ebp
80101f85:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f88:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f8e:	e8 6d fd ff ff       	call   80101d00 <namex>
}
80101f93:	c9                   	leave  
80101f94:	c3                   	ret    
80101f95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fa0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fa1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fa6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fab:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fae:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101faf:	e9 4c fd ff ff       	jmp    80101d00 <namex>
80101fb4:	66 90                	xchg   %ax,%ax
80101fb6:	66 90                	xchg   %ax,%ax
80101fb8:	66 90                	xchg   %ax,%ax
80101fba:	66 90                	xchg   %ax,%ax
80101fbc:	66 90                	xchg   %ax,%ax
80101fbe:	66 90                	xchg   %ax,%ax

80101fc0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101fc9:	85 c0                	test   %eax,%eax
80101fcb:	0f 84 b4 00 00 00    	je     80102085 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fd1:	8b 58 08             	mov    0x8(%eax),%ebx
80101fd4:	89 c6                	mov    %eax,%esi
80101fd6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101fdc:	0f 87 96 00 00 00    	ja     80102078 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fe2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101fe7:	89 f6                	mov    %esi,%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101ff0:	89 ca                	mov    %ecx,%edx
80101ff2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff3:	83 e0 c0             	and    $0xffffffc0,%eax
80101ff6:	3c 40                	cmp    $0x40,%al
80101ff8:	75 f6                	jne    80101ff0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ffa:	31 ff                	xor    %edi,%edi
80101ffc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102001:	89 f8                	mov    %edi,%eax
80102003:	ee                   	out    %al,(%dx)
80102004:	b8 01 00 00 00       	mov    $0x1,%eax
80102009:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010200e:	ee                   	out    %al,(%dx)
8010200f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102014:	89 d8                	mov    %ebx,%eax
80102016:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102017:	89 d8                	mov    %ebx,%eax
80102019:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010201e:	c1 f8 08             	sar    $0x8,%eax
80102021:	ee                   	out    %al,(%dx)
80102022:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102027:	89 f8                	mov    %edi,%eax
80102029:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010202a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010202e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102033:	c1 e0 04             	shl    $0x4,%eax
80102036:	83 e0 10             	and    $0x10,%eax
80102039:	83 c8 e0             	or     $0xffffffe0,%eax
8010203c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010203d:	f6 06 04             	testb  $0x4,(%esi)
80102040:	75 16                	jne    80102058 <idestart+0x98>
80102042:	b8 20 00 00 00       	mov    $0x20,%eax
80102047:	89 ca                	mov    %ecx,%edx
80102049:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010204a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010204d:	5b                   	pop    %ebx
8010204e:	5e                   	pop    %esi
8010204f:	5f                   	pop    %edi
80102050:	5d                   	pop    %ebp
80102051:	c3                   	ret    
80102052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102058:	b8 30 00 00 00       	mov    $0x30,%eax
8010205d:	89 ca                	mov    %ecx,%edx
8010205f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102060:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102065:	83 c6 60             	add    $0x60,%esi
80102068:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010206d:	fc                   	cld    
8010206e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102070:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102073:	5b                   	pop    %ebx
80102074:	5e                   	pop    %esi
80102075:	5f                   	pop    %edi
80102076:	5d                   	pop    %ebp
80102077:	c3                   	ret    
    panic("incorrect blockno");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 f4 83 10 80       	push   $0x801083f4
80102080:	e8 0b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 eb 83 10 80       	push   $0x801083eb
8010208d:	e8 fe e2 ff ff       	call   80100390 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020a0 <ideinit>:
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020a6:	68 06 84 10 80       	push   $0x80108406
801020ab:	68 80 b5 10 80       	push   $0x8010b580
801020b0:	e8 db 31 00 00       	call   80105290 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020b5:	58                   	pop    %eax
801020b6:	a1 c0 3e 11 80       	mov    0x80113ec0,%eax
801020bb:	5a                   	pop    %edx
801020bc:	83 e8 01             	sub    $0x1,%eax
801020bf:	50                   	push   %eax
801020c0:	6a 0e                	push   $0xe
801020c2:	e8 a9 02 00 00       	call   80102370 <ioapicenable>
801020c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020cf:	90                   	nop
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	83 e0 c0             	and    $0xffffffc0,%eax
801020d4:	3c 40                	cmp    $0x40,%al
801020d6:	75 f8                	jne    801020d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e2:	ee                   	out    %al,(%dx)
801020e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	eb 06                	jmp    801020f5 <ideinit+0x55>
801020ef:	90                   	nop
  for(i=0; i<1000; i++){
801020f0:	83 e9 01             	sub    $0x1,%ecx
801020f3:	74 0f                	je     80102104 <ideinit+0x64>
801020f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020f6:	84 c0                	test   %al,%al
801020f8:	74 f6                	je     801020f0 <ideinit+0x50>
      havedisk1 = 1;
801020fa:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102101:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102104:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102109:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010210e:	ee                   	out    %al,(%dx)
}
8010210f:	c9                   	leave  
80102110:	c3                   	ret    
80102111:	eb 0d                	jmp    80102120 <ideintr>
80102113:	90                   	nop
80102114:	90                   	nop
80102115:	90                   	nop
80102116:	90                   	nop
80102117:	90                   	nop
80102118:	90                   	nop
80102119:	90                   	nop
8010211a:	90                   	nop
8010211b:	90                   	nop
8010211c:	90                   	nop
8010211d:	90                   	nop
8010211e:	90                   	nop
8010211f:	90                   	nop

80102120 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	57                   	push   %edi
80102124:	56                   	push   %esi
80102125:	53                   	push   %ebx
80102126:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102129:	68 80 b5 10 80       	push   $0x8010b580
8010212e:	e8 9d 32 00 00       	call   801053d0 <acquire>

  if((b = idequeue) == 0){
80102133:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102139:	83 c4 10             	add    $0x10,%esp
8010213c:	85 db                	test   %ebx,%ebx
8010213e:	74 67                	je     801021a7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102140:	8b 43 5c             	mov    0x5c(%ebx),%eax
80102143:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102148:	8b 3b                	mov    (%ebx),%edi
8010214a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102150:	75 31                	jne    80102183 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102152:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102157:	89 f6                	mov    %esi,%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102160:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102161:	89 c6                	mov    %eax,%esi
80102163:	83 e6 c0             	and    $0xffffffc0,%esi
80102166:	89 f1                	mov    %esi,%ecx
80102168:	80 f9 40             	cmp    $0x40,%cl
8010216b:	75 f3                	jne    80102160 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010216d:	a8 21                	test   $0x21,%al
8010216f:	75 12                	jne    80102183 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102171:	8d 7b 60             	lea    0x60(%ebx),%edi
  asm volatile("cld; rep insl" :
80102174:	b9 80 00 00 00       	mov    $0x80,%ecx
80102179:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010217e:	fc                   	cld    
8010217f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102181:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102183:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102186:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102189:	89 f9                	mov    %edi,%ecx
8010218b:	83 c9 02             	or     $0x2,%ecx
8010218e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102190:	53                   	push   %ebx
80102191:	e8 2a 1e 00 00       	call   80103fc0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102196:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010219b:	83 c4 10             	add    $0x10,%esp
8010219e:	85 c0                	test   %eax,%eax
801021a0:	74 05                	je     801021a7 <ideintr+0x87>
    idestart(idequeue);
801021a2:	e8 19 fe ff ff       	call   80101fc0 <idestart>
    release(&idelock);
801021a7:	83 ec 0c             	sub    $0xc,%esp
801021aa:	68 80 b5 10 80       	push   $0x8010b580
801021af:	e8 ec 32 00 00       	call   801054a0 <release>

  release(&idelock);
}
801021b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b7:	5b                   	pop    %ebx
801021b8:	5e                   	pop    %esi
801021b9:	5f                   	pop    %edi
801021ba:	5d                   	pop    %ebp
801021bb:	c3                   	ret    
801021bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	53                   	push   %ebx
801021c4:	83 ec 10             	sub    $0x10,%esp
801021c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801021cd:	50                   	push   %eax
801021ce:	e8 6d 30 00 00       	call   80105240 <holdingsleep>
801021d3:	83 c4 10             	add    $0x10,%esp
801021d6:	85 c0                	test   %eax,%eax
801021d8:	0f 84 c6 00 00 00    	je     801022a4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 e0 06             	and    $0x6,%eax
801021e3:	83 f8 02             	cmp    $0x2,%eax
801021e6:	0f 84 ab 00 00 00    	je     80102297 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021ec:	8b 53 04             	mov    0x4(%ebx),%edx
801021ef:	85 d2                	test   %edx,%edx
801021f1:	74 0d                	je     80102200 <iderw+0x40>
801021f3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801021f8:	85 c0                	test   %eax,%eax
801021fa:	0f 84 b1 00 00 00    	je     801022b1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	68 80 b5 10 80       	push   $0x8010b580
80102208:	e8 c3 31 00 00       	call   801053d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010220d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102213:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102216:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010221d:	85 d2                	test   %edx,%edx
8010221f:	75 09                	jne    8010222a <iderw+0x6a>
80102221:	eb 6d                	jmp    80102290 <iderw+0xd0>
80102223:	90                   	nop
80102224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102228:	89 c2                	mov    %eax,%edx
8010222a:	8b 42 5c             	mov    0x5c(%edx),%eax
8010222d:	85 c0                	test   %eax,%eax
8010222f:	75 f7                	jne    80102228 <iderw+0x68>
80102231:	83 c2 5c             	add    $0x5c,%edx
    ;
  *pp = b;
80102234:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102236:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010223c:	74 42                	je     80102280 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010223e:	8b 03                	mov    (%ebx),%eax
80102240:	83 e0 06             	and    $0x6,%eax
80102243:	83 f8 02             	cmp    $0x2,%eax
80102246:	74 23                	je     8010226b <iderw+0xab>
80102248:	90                   	nop
80102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102250:	83 ec 08             	sub    $0x8,%esp
80102253:	68 80 b5 10 80       	push   $0x8010b580
80102258:	53                   	push   %ebx
80102259:	e8 82 24 00 00       	call   801046e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010225e:	8b 03                	mov    (%ebx),%eax
80102260:	83 c4 10             	add    $0x10,%esp
80102263:	83 e0 06             	and    $0x6,%eax
80102266:	83 f8 02             	cmp    $0x2,%eax
80102269:	75 e5                	jne    80102250 <iderw+0x90>
  }


  release(&idelock);
8010226b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102275:	c9                   	leave  
  release(&idelock);
80102276:	e9 25 32 00 00       	jmp    801054a0 <release>
8010227b:	90                   	nop
8010227c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102280:	89 d8                	mov    %ebx,%eax
80102282:	e8 39 fd ff ff       	call   80101fc0 <idestart>
80102287:	eb b5                	jmp    8010223e <iderw+0x7e>
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102290:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102295:	eb 9d                	jmp    80102234 <iderw+0x74>
    panic("iderw: nothing to do");
80102297:	83 ec 0c             	sub    $0xc,%esp
8010229a:	68 20 84 10 80       	push   $0x80108420
8010229f:	e8 ec e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	68 0a 84 10 80       	push   $0x8010840a
801022ac:	e8 df e0 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801022b1:	83 ec 0c             	sub    $0xc,%esp
801022b4:	68 35 84 10 80       	push   $0x80108435
801022b9:	e8 d2 e0 ff ff       	call   80100390 <panic>
801022be:	66 90                	xchg   %ax,%ax

801022c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022c1:	c7 05 a0 37 11 80 00 	movl   $0xfec00000,0x801137a0
801022c8:	00 c0 fe 
{
801022cb:	89 e5                	mov    %esp,%ebp
801022cd:	56                   	push   %esi
801022ce:	53                   	push   %ebx
  ioapic->reg = reg;
801022cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022d6:	00 00 00 
  return ioapic->data;
801022d9:	a1 a0 37 11 80       	mov    0x801137a0,%eax
801022de:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801022e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801022e7:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022ed:	0f b6 15 00 39 11 80 	movzbl 0x80113900,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022f4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801022f7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022fa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801022fd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102300:	39 c2                	cmp    %eax,%edx
80102302:	74 16                	je     8010231a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102304:	83 ec 0c             	sub    $0xc,%esp
80102307:	68 54 84 10 80       	push   $0x80108454
8010230c:	e8 4f e3 ff ff       	call   80100660 <cprintf>
80102311:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	83 c3 21             	add    $0x21,%ebx
{
8010231d:	ba 10 00 00 00       	mov    $0x10,%edx
80102322:	b8 20 00 00 00       	mov    $0x20,%eax
80102327:	89 f6                	mov    %esi,%esi
80102329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102330:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102332:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102338:	89 c6                	mov    %eax,%esi
8010233a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102340:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102343:	89 71 10             	mov    %esi,0x10(%ecx)
80102346:	8d 72 01             	lea    0x1(%edx),%esi
80102349:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010234c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010234e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102350:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
80102356:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010235d:	75 d1                	jne    80102330 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010235f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102362:	5b                   	pop    %ebx
80102363:	5e                   	pop    %esi
80102364:	5d                   	pop    %ebp
80102365:	c3                   	ret    
80102366:	8d 76 00             	lea    0x0(%esi),%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102370 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102370:	55                   	push   %ebp
  ioapic->reg = reg;
80102371:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
{
80102377:	89 e5                	mov    %esp,%ebp
80102379:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010237c:	8d 50 20             	lea    0x20(%eax),%edx
8010237f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102383:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102385:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010238b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010238e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102391:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102394:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102396:	a1 a0 37 11 80       	mov    0x801137a0,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010239b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010239e:	89 50 10             	mov    %edx,0x10(%eax)
}
801023a1:	5d                   	pop    %ebp
801023a2:	c3                   	ret    
801023a3:	66 90                	xchg   %ax,%ax
801023a5:	66 90                	xchg   %ax,%ax
801023a7:	66 90                	xchg   %ax,%ax
801023a9:	66 90                	xchg   %ax,%ax
801023ab:	66 90                	xchg   %ax,%ax
801023ad:	66 90                	xchg   %ax,%ax
801023af:	90                   	nop

801023b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	53                   	push   %ebx
801023b4:	83 ec 04             	sub    $0x4,%esp
801023b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023c0:	75 70                	jne    80102432 <kfree+0x82>
801023c2:	81 fb 68 e6 15 80    	cmp    $0x8015e668,%ebx
801023c8:	72 68                	jb     80102432 <kfree+0x82>
801023ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023d5:	77 5b                	ja     80102432 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023d7:	83 ec 04             	sub    $0x4,%esp
801023da:	68 00 10 00 00       	push   $0x1000
801023df:	6a 01                	push   $0x1
801023e1:	53                   	push   %ebx
801023e2:	e8 09 31 00 00       	call   801054f0 <memset>

  if(kmem.use_lock)
801023e7:	8b 15 f8 37 11 80    	mov    0x801137f8,%edx
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	85 d2                	test   %edx,%edx
801023f2:	75 2c                	jne    80102420 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023f4:	a1 fc 37 11 80       	mov    0x801137fc,%eax
801023f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023fb:	a1 f8 37 11 80       	mov    0x801137f8,%eax
  kmem.freelist = r;
80102400:	89 1d fc 37 11 80    	mov    %ebx,0x801137fc
  if(kmem.use_lock)
80102406:	85 c0                	test   %eax,%eax
80102408:	75 06                	jne    80102410 <kfree+0x60>
    release(&kmem.lock);
}
8010240a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010240d:	c9                   	leave  
8010240e:	c3                   	ret    
8010240f:	90                   	nop
    release(&kmem.lock);
80102410:	c7 45 08 c0 37 11 80 	movl   $0x801137c0,0x8(%ebp)
}
80102417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010241a:	c9                   	leave  
    release(&kmem.lock);
8010241b:	e9 80 30 00 00       	jmp    801054a0 <release>
    acquire(&kmem.lock);
80102420:	83 ec 0c             	sub    $0xc,%esp
80102423:	68 c0 37 11 80       	push   $0x801137c0
80102428:	e8 a3 2f 00 00       	call   801053d0 <acquire>
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	eb c2                	jmp    801023f4 <kfree+0x44>
    panic("kfree");
80102432:	83 ec 0c             	sub    $0xc,%esp
80102435:	68 86 84 10 80       	push   $0x80108486
8010243a:	e8 51 df ff ff       	call   80100390 <panic>
8010243f:	90                   	nop

80102440 <freerange>:
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102445:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102448:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010244b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102451:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102457:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245d:	39 de                	cmp    %ebx,%esi
8010245f:	72 23                	jb     80102484 <freerange+0x44>
80102461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102468:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010246e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102471:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102477:	50                   	push   %eax
80102478:	e8 33 ff ff ff       	call   801023b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	39 f3                	cmp    %esi,%ebx
80102482:	76 e4                	jbe    80102468 <freerange+0x28>
}
80102484:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102487:	5b                   	pop    %ebx
80102488:	5e                   	pop    %esi
80102489:	5d                   	pop    %ebp
8010248a:	c3                   	ret    
8010248b:	90                   	nop
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <kinit1>:
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
80102495:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102498:	83 ec 08             	sub    $0x8,%esp
8010249b:	68 8c 84 10 80       	push   $0x8010848c
801024a0:	68 c0 37 11 80       	push   $0x801137c0
801024a5:	e8 e6 2d 00 00       	call   80105290 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801024b0:	c7 05 f8 37 11 80 00 	movl   $0x0,0x801137f8
801024b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801024ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024cc:	39 de                	cmp    %ebx,%esi
801024ce:	72 1c                	jb     801024ec <kinit1+0x5c>
    kfree(p);
801024d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024d6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024df:	50                   	push   %eax
801024e0:	e8 cb fe ff ff       	call   801023b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	39 de                	cmp    %ebx,%esi
801024ea:	73 e4                	jae    801024d0 <kinit1+0x40>
}
801024ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024ef:	5b                   	pop    %ebx
801024f0:	5e                   	pop    %esi
801024f1:	5d                   	pop    %ebp
801024f2:	c3                   	ret    
801024f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kinit2>:
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	56                   	push   %esi
80102504:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102505:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102508:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010250b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102511:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102517:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010251d:	39 de                	cmp    %ebx,%esi
8010251f:	72 23                	jb     80102544 <kinit2+0x44>
80102521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102528:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010252e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102531:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102537:	50                   	push   %eax
80102538:	e8 73 fe ff ff       	call   801023b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	39 de                	cmp    %ebx,%esi
80102542:	73 e4                	jae    80102528 <kinit2+0x28>
  kmem.use_lock = 1;
80102544:	c7 05 f8 37 11 80 01 	movl   $0x1,0x801137f8
8010254b:	00 00 00 
}
8010254e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102551:	5b                   	pop    %ebx
80102552:	5e                   	pop    %esi
80102553:	5d                   	pop    %ebp
80102554:	c3                   	ret    
80102555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102560 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102560:	a1 f8 37 11 80       	mov    0x801137f8,%eax
80102565:	85 c0                	test   %eax,%eax
80102567:	75 1f                	jne    80102588 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102569:	a1 fc 37 11 80       	mov    0x801137fc,%eax
  if(r)
8010256e:	85 c0                	test   %eax,%eax
80102570:	74 0e                	je     80102580 <kalloc+0x20>
    kmem.freelist = r->next;
80102572:	8b 10                	mov    (%eax),%edx
80102574:	89 15 fc 37 11 80    	mov    %edx,0x801137fc
8010257a:	c3                   	ret    
8010257b:	90                   	nop
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102580:	f3 c3                	repz ret 
80102582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102588:	55                   	push   %ebp
80102589:	89 e5                	mov    %esp,%ebp
8010258b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010258e:	68 c0 37 11 80       	push   $0x801137c0
80102593:	e8 38 2e 00 00       	call   801053d0 <acquire>
  r = kmem.freelist;
80102598:	a1 fc 37 11 80       	mov    0x801137fc,%eax
  if(r)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	8b 15 f8 37 11 80    	mov    0x801137f8,%edx
801025a6:	85 c0                	test   %eax,%eax
801025a8:	74 08                	je     801025b2 <kalloc+0x52>
    kmem.freelist = r->next;
801025aa:	8b 08                	mov    (%eax),%ecx
801025ac:	89 0d fc 37 11 80    	mov    %ecx,0x801137fc
  if(kmem.use_lock)
801025b2:	85 d2                	test   %edx,%edx
801025b4:	74 16                	je     801025cc <kalloc+0x6c>
    release(&kmem.lock);
801025b6:	83 ec 0c             	sub    $0xc,%esp
801025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801025bc:	68 c0 37 11 80       	push   $0x801137c0
801025c1:	e8 da 2e 00 00       	call   801054a0 <release>
  return (char*)r;
801025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801025c9:	83 c4 10             	add    $0x10,%esp
}
801025cc:	c9                   	leave  
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025d0:	ba 64 00 00 00       	mov    $0x64,%edx
801025d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025d6:	a8 01                	test   $0x1,%al
801025d8:	0f 84 c2 00 00 00    	je     801026a0 <kbdgetc+0xd0>
801025de:	ba 60 00 00 00       	mov    $0x60,%edx
801025e3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025e4:	0f b6 d0             	movzbl %al,%edx
801025e7:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx

  if(data == 0xE0){
801025ed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025f3:	0f 84 7f 00 00 00    	je     80102678 <kbdgetc+0xa8>
{
801025f9:	55                   	push   %ebp
801025fa:	89 e5                	mov    %esp,%ebp
801025fc:	53                   	push   %ebx
801025fd:	89 cb                	mov    %ecx,%ebx
801025ff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102602:	84 c0                	test   %al,%al
80102604:	78 4a                	js     80102650 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102606:	85 db                	test   %ebx,%ebx
80102608:	74 09                	je     80102613 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010260a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010260d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102610:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102613:	0f b6 82 c0 85 10 80 	movzbl -0x7fef7a40(%edx),%eax
8010261a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010261c:	0f b6 82 c0 84 10 80 	movzbl -0x7fef7b40(%edx),%eax
80102623:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102625:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102627:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
  c = charcode[shift & (CTL | SHIFT)][data];
8010262d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102630:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102633:	8b 04 85 a0 84 10 80 	mov    -0x7fef7b60(,%eax,4),%eax
8010263a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010263e:	74 31                	je     80102671 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102640:	8d 50 9f             	lea    -0x61(%eax),%edx
80102643:	83 fa 19             	cmp    $0x19,%edx
80102646:	77 40                	ja     80102688 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102648:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010264b:	5b                   	pop    %ebx
8010264c:	5d                   	pop    %ebp
8010264d:	c3                   	ret    
8010264e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102650:	83 e0 7f             	and    $0x7f,%eax
80102653:	85 db                	test   %ebx,%ebx
80102655:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102658:	0f b6 82 c0 85 10 80 	movzbl -0x7fef7a40(%edx),%eax
8010265f:	83 c8 40             	or     $0x40,%eax
80102662:	0f b6 c0             	movzbl %al,%eax
80102665:	f7 d0                	not    %eax
80102667:	21 c1                	and    %eax,%ecx
    return 0;
80102669:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010266b:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
}
80102671:	5b                   	pop    %ebx
80102672:	5d                   	pop    %ebp
80102673:	c3                   	ret    
80102674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102678:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010267b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010267d:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
    return 0;
80102683:	c3                   	ret    
80102684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102688:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010268b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010268e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010268f:	83 f9 1a             	cmp    $0x1a,%ecx
80102692:	0f 42 c2             	cmovb  %edx,%eax
}
80102695:	5d                   	pop    %ebp
80102696:	c3                   	ret    
80102697:	89 f6                	mov    %esi,%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801026a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801026a5:	c3                   	ret    
801026a6:	8d 76 00             	lea    0x0(%esi),%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026b0 <kbdintr>:

void
kbdintr(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801026b6:	68 d0 25 10 80       	push   $0x801025d0
801026bb:	e8 50 e1 ff ff       	call   80100810 <consoleintr>
}
801026c0:	83 c4 10             	add    $0x10,%esp
801026c3:	c9                   	leave  
801026c4:	c3                   	ret    
801026c5:	66 90                	xchg   %ax,%ax
801026c7:	66 90                	xchg   %ax,%ax
801026c9:	66 90                	xchg   %ax,%ax
801026cb:	66 90                	xchg   %ax,%ax
801026cd:	66 90                	xchg   %ax,%ax
801026cf:	90                   	nop

801026d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026d0:	a1 00 38 11 80       	mov    0x80113800,%eax
{
801026d5:	55                   	push   %ebp
801026d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026d8:	85 c0                	test   %eax,%eax
801026da:	0f 84 c8 00 00 00    	je     801027a8 <lapicinit+0xd8>
  lapic[index] = value;
801026e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102701:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102704:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102707:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010270e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102711:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102714:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010271b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102721:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102728:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010272e:	8b 50 30             	mov    0x30(%eax),%edx
80102731:	c1 ea 10             	shr    $0x10,%edx
80102734:	80 fa 03             	cmp    $0x3,%dl
80102737:	77 77                	ja     801027b0 <lapicinit+0xe0>
  lapic[index] = value;
80102739:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102740:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102743:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102746:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010274d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102750:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102753:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010275a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102760:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102767:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010276d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102774:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102777:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010277a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102781:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102784:	8b 50 20             	mov    0x20(%eax),%edx
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102790:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102796:	80 e6 10             	and    $0x10,%dh
80102799:	75 f5                	jne    80102790 <lapicinit+0xc0>
  lapic[index] = value;
8010279b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027a8:	5d                   	pop    %ebp
801027a9:	c3                   	ret    
801027aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801027b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ba:	8b 50 20             	mov    0x20(%eax),%edx
801027bd:	e9 77 ff ff ff       	jmp    80102739 <lapicinit+0x69>
801027c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801027d0:	8b 15 00 38 11 80    	mov    0x80113800,%edx
{
801027d6:	55                   	push   %ebp
801027d7:	31 c0                	xor    %eax,%eax
801027d9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027db:	85 d2                	test   %edx,%edx
801027dd:	74 06                	je     801027e5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801027df:	8b 42 20             	mov    0x20(%edx),%eax
801027e2:	c1 e8 18             	shr    $0x18,%eax
}
801027e5:	5d                   	pop    %ebp
801027e6:	c3                   	ret    
801027e7:	89 f6                	mov    %esi,%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027f0:	a1 00 38 11 80       	mov    0x80113800,%eax
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027f8:	85 c0                	test   %eax,%eax
801027fa:	74 0d                	je     80102809 <lapiceoi+0x19>
  lapic[index] = value;
801027fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102803:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
}
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret    
80102815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102820:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	b8 0f 00 00 00       	mov    $0xf,%eax
80102826:	ba 70 00 00 00       	mov    $0x70,%edx
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	53                   	push   %ebx
8010282e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102831:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102834:	ee                   	out    %al,(%dx)
80102835:	b8 0a 00 00 00       	mov    $0xa,%eax
8010283a:	ba 71 00 00 00       	mov    $0x71,%edx
8010283f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102840:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102842:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102845:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010284b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010284d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102850:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102853:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102855:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102858:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010285e:	a1 00 38 11 80       	mov    0x80113800,%eax
80102863:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102869:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010286c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102873:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102876:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102879:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102880:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102883:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102886:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010288c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010288f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102895:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102898:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801028aa:	5b                   	pop    %ebx
801028ab:	5d                   	pop    %ebp
801028ac:	c3                   	ret    
801028ad:	8d 76 00             	lea    0x0(%esi),%esi

801028b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801028b0:	55                   	push   %ebp
801028b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801028b6:	ba 70 00 00 00       	mov    $0x70,%edx
801028bb:	89 e5                	mov    %esp,%ebp
801028bd:	57                   	push   %edi
801028be:	56                   	push   %esi
801028bf:	53                   	push   %ebx
801028c0:	83 ec 4c             	sub    $0x4c,%esp
801028c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	ba 71 00 00 00       	mov    $0x71,%edx
801028c9:	ec                   	in     (%dx),%al
801028ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cd:	bb 70 00 00 00       	mov    $0x70,%ebx
801028d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801028d5:	8d 76 00             	lea    0x0(%esi),%esi
801028d8:	31 c0                	xor    %eax,%eax
801028da:	89 da                	mov    %ebx,%edx
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801028e2:	89 ca                	mov    %ecx,%edx
801028e4:	ec                   	in     (%dx),%al
801028e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e8:	89 da                	mov    %ebx,%edx
801028ea:	b8 02 00 00 00       	mov    $0x2,%eax
801028ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f0:	89 ca                	mov    %ecx,%edx
801028f2:	ec                   	in     (%dx),%al
801028f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f6:	89 da                	mov    %ebx,%edx
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
80102901:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 da                	mov    %ebx,%edx
80102906:	b8 07 00 00 00       	mov    $0x7,%eax
8010290b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
8010290f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102912:	89 da                	mov    %ebx,%edx
80102914:	b8 08 00 00 00       	mov    $0x8,%eax
80102919:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291a:	89 ca                	mov    %ecx,%edx
8010291c:	ec                   	in     (%dx),%al
8010291d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010291f:	89 da                	mov    %ebx,%edx
80102921:	b8 09 00 00 00       	mov    $0x9,%eax
80102926:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102927:	89 ca                	mov    %ecx,%edx
80102929:	ec                   	in     (%dx),%al
8010292a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292c:	89 da                	mov    %ebx,%edx
8010292e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102933:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102934:	89 ca                	mov    %ecx,%edx
80102936:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102937:	84 c0                	test   %al,%al
80102939:	78 9d                	js     801028d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010293b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010293f:	89 fa                	mov    %edi,%edx
80102941:	0f b6 fa             	movzbl %dl,%edi
80102944:	89 f2                	mov    %esi,%edx
80102946:	0f b6 f2             	movzbl %dl,%esi
80102949:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010294c:	89 da                	mov    %ebx,%edx
8010294e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102951:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102954:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102958:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010295b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010295f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102962:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102966:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102969:	31 c0                	xor    %eax,%eax
8010296b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296c:	89 ca                	mov    %ecx,%edx
8010296e:	ec                   	in     (%dx),%al
8010296f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102972:	89 da                	mov    %ebx,%edx
80102974:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102977:	b8 02 00 00 00       	mov    $0x2,%eax
8010297c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297d:	89 ca                	mov    %ecx,%edx
8010297f:	ec                   	in     (%dx),%al
80102980:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102983:	89 da                	mov    %ebx,%edx
80102985:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102988:	b8 04 00 00 00       	mov    $0x4,%eax
8010298d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298e:	89 ca                	mov    %ecx,%edx
80102990:	ec                   	in     (%dx),%al
80102991:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102994:	89 da                	mov    %ebx,%edx
80102996:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102999:	b8 07 00 00 00       	mov    $0x7,%eax
8010299e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299f:	89 ca                	mov    %ecx,%edx
801029a1:	ec                   	in     (%dx),%al
801029a2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a5:	89 da                	mov    %ebx,%edx
801029a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029aa:	b8 08 00 00 00       	mov    $0x8,%eax
801029af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b0:	89 ca                	mov    %ecx,%edx
801029b2:	ec                   	in     (%dx),%al
801029b3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b6:	89 da                	mov    %ebx,%edx
801029b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801029bb:	b8 09 00 00 00       	mov    $0x9,%eax
801029c0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c1:	89 ca                	mov    %ecx,%edx
801029c3:	ec                   	in     (%dx),%al
801029c4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029c7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801029ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029cd:	8d 45 d0             	lea    -0x30(%ebp),%eax
801029d0:	6a 18                	push   $0x18
801029d2:	50                   	push   %eax
801029d3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029d6:	50                   	push   %eax
801029d7:	e8 64 2b 00 00       	call   80105540 <memcmp>
801029dc:	83 c4 10             	add    $0x10,%esp
801029df:	85 c0                	test   %eax,%eax
801029e1:	0f 85 f1 fe ff ff    	jne    801028d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801029e7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801029eb:	75 78                	jne    80102a65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029f0:	89 c2                	mov    %eax,%edx
801029f2:	83 e0 0f             	and    $0xf,%eax
801029f5:	c1 ea 04             	shr    $0x4,%edx
801029f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a04:	89 c2                	mov    %eax,%edx
80102a06:	83 e0 0f             	and    $0xf,%eax
80102a09:	c1 ea 04             	shr    $0x4,%edx
80102a0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a18:	89 c2                	mov    %eax,%edx
80102a1a:	83 e0 0f             	and    $0xf,%eax
80102a1d:	c1 ea 04             	shr    $0x4,%edx
80102a20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a2c:	89 c2                	mov    %eax,%edx
80102a2e:	83 e0 0f             	and    $0xf,%eax
80102a31:	c1 ea 04             	shr    $0x4,%edx
80102a34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a40:	89 c2                	mov    %eax,%edx
80102a42:	83 e0 0f             	and    $0xf,%eax
80102a45:	c1 ea 04             	shr    $0x4,%edx
80102a48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a54:	89 c2                	mov    %eax,%edx
80102a56:	83 e0 0f             	and    $0xf,%eax
80102a59:	c1 ea 04             	shr    $0x4,%edx
80102a5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a65:	8b 75 08             	mov    0x8(%ebp),%esi
80102a68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a6b:	89 06                	mov    %eax,(%esi)
80102a6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a70:	89 46 04             	mov    %eax,0x4(%esi)
80102a73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a76:	89 46 08             	mov    %eax,0x8(%esi)
80102a79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a82:	89 46 10             	mov    %eax,0x10(%esi)
80102a85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a95:	5b                   	pop    %ebx
80102a96:	5e                   	pop    %esi
80102a97:	5f                   	pop    %edi
80102a98:	5d                   	pop    %ebp
80102a99:	c3                   	ret    
80102a9a:	66 90                	xchg   %ax,%ax
80102a9c:	66 90                	xchg   %ax,%ax
80102a9e:	66 90                	xchg   %ax,%ax

80102aa0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102aa0:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
80102aa6:	85 c9                	test   %ecx,%ecx
80102aa8:	0f 8e 8a 00 00 00    	jle    80102b38 <install_trans+0x98>
{
80102aae:	55                   	push   %ebp
80102aaf:	89 e5                	mov    %esp,%ebp
80102ab1:	57                   	push   %edi
80102ab2:	56                   	push   %esi
80102ab3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102ab4:	31 db                	xor    %ebx,%ebx
{
80102ab6:	83 ec 0c             	sub    $0xc,%esp
80102ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ac0:	a1 58 38 11 80       	mov    0x80113858,%eax
80102ac5:	83 ec 08             	sub    $0x8,%esp
80102ac8:	01 d8                	add    %ebx,%eax
80102aca:	83 c0 01             	add    $0x1,%eax
80102acd:	50                   	push   %eax
80102ace:	ff 35 68 38 11 80    	pushl  0x80113868
80102ad4:	e8 f7 d5 ff ff       	call   801000d0 <bread>
80102ad9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102adb:	58                   	pop    %eax
80102adc:	5a                   	pop    %edx
80102add:	ff 34 9d 70 38 11 80 	pushl  -0x7feec790(,%ebx,4)
80102ae4:	ff 35 68 38 11 80    	pushl  0x80113868
  for (tail = 0; tail < log.lh.n; tail++) {
80102aea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102aed:	e8 de d5 ff ff       	call   801000d0 <bread>
80102af2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102af4:	8d 47 60             	lea    0x60(%edi),%eax
80102af7:	83 c4 0c             	add    $0xc,%esp
80102afa:	68 00 02 00 00       	push   $0x200
80102aff:	50                   	push   %eax
80102b00:	8d 46 60             	lea    0x60(%esi),%eax
80102b03:	50                   	push   %eax
80102b04:	e8 97 2a 00 00       	call   801055a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b09:	89 34 24             	mov    %esi,(%esp)
80102b0c:	e8 8f d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102b11:	89 3c 24             	mov    %edi,(%esp)
80102b14:	e8 c7 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102b19:	89 34 24             	mov    %esi,(%esp)
80102b1c:	e8 bf d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b21:	83 c4 10             	add    $0x10,%esp
80102b24:	39 1d 6c 38 11 80    	cmp    %ebx,0x8011386c
80102b2a:	7f 94                	jg     80102ac0 <install_trans+0x20>
  }
}
80102b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b2f:	5b                   	pop    %ebx
80102b30:	5e                   	pop    %esi
80102b31:	5f                   	pop    %edi
80102b32:	5d                   	pop    %ebp
80102b33:	c3                   	ret    
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b38:	f3 c3                	repz ret 
80102b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	56                   	push   %esi
80102b44:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102b45:	83 ec 08             	sub    $0x8,%esp
80102b48:	ff 35 58 38 11 80    	pushl  0x80113858
80102b4e:	ff 35 68 38 11 80    	pushl  0x80113868
80102b54:	e8 77 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b59:	8b 1d 6c 38 11 80    	mov    0x8011386c,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b5f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b62:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b64:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b66:	89 58 60             	mov    %ebx,0x60(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b69:	7e 16                	jle    80102b81 <write_head+0x41>
80102b6b:	c1 e3 02             	shl    $0x2,%ebx
80102b6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b70:	8b 8a 70 38 11 80    	mov    -0x7feec790(%edx),%ecx
80102b76:	89 4c 16 64          	mov    %ecx,0x64(%esi,%edx,1)
80102b7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 da                	cmp    %ebx,%edx
80102b7f:	75 ef                	jne    80102b70 <write_head+0x30>
  }
  bwrite(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	56                   	push   %esi
80102b85:	e8 16 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b8a:	89 34 24             	mov    %esi,(%esp)
80102b8d:	e8 4e d6 ff ff       	call   801001e0 <brelse>
}
80102b92:	83 c4 10             	add    $0x10,%esp
80102b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b98:	5b                   	pop    %ebx
80102b99:	5e                   	pop    %esi
80102b9a:	5d                   	pop    %ebp
80102b9b:	c3                   	ret    
80102b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ba0 <initlog>:
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	53                   	push   %ebx
80102ba4:	83 ec 2c             	sub    $0x2c,%esp
80102ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102baa:	68 c0 86 10 80       	push   $0x801086c0
80102baf:	68 20 38 11 80       	push   $0x80113820
80102bb4:	e8 d7 26 00 00       	call   80105290 <initlock>
  readsb(dev, &sb);
80102bb9:	58                   	pop    %eax
80102bba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102bbd:	5a                   	pop    %edx
80102bbe:	50                   	push   %eax
80102bbf:	53                   	push   %ebx
80102bc0:	e8 9b e8 ff ff       	call   80101460 <readsb>
  log.size = sb.nlog;
80102bc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102bcb:	59                   	pop    %ecx
  log.dev = dev;
80102bcc:	89 1d 68 38 11 80    	mov    %ebx,0x80113868
  log.size = sb.nlog;
80102bd2:	89 15 5c 38 11 80    	mov    %edx,0x8011385c
  log.start = sb.logstart;
80102bd8:	a3 58 38 11 80       	mov    %eax,0x80113858
  struct buf *buf = bread(log.dev, log.start);
80102bdd:	5a                   	pop    %edx
80102bde:	50                   	push   %eax
80102bdf:	53                   	push   %ebx
80102be0:	e8 eb d4 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102be5:	8b 58 60             	mov    0x60(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102be8:	83 c4 10             	add    $0x10,%esp
80102beb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102bed:	89 1d 6c 38 11 80    	mov    %ebx,0x8011386c
  for (i = 0; i < log.lh.n; i++) {
80102bf3:	7e 1c                	jle    80102c11 <initlog+0x71>
80102bf5:	c1 e3 02             	shl    $0x2,%ebx
80102bf8:	31 d2                	xor    %edx,%edx
80102bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102c00:	8b 4c 10 64          	mov    0x64(%eax,%edx,1),%ecx
80102c04:	83 c2 04             	add    $0x4,%edx
80102c07:	89 8a 6c 38 11 80    	mov    %ecx,-0x7feec794(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102c0d:	39 d3                	cmp    %edx,%ebx
80102c0f:	75 ef                	jne    80102c00 <initlog+0x60>
  brelse(buf);
80102c11:	83 ec 0c             	sub    $0xc,%esp
80102c14:	50                   	push   %eax
80102c15:	e8 c6 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c1a:	e8 81 fe ff ff       	call   80102aa0 <install_trans>
  log.lh.n = 0;
80102c1f:	c7 05 6c 38 11 80 00 	movl   $0x0,0x8011386c
80102c26:	00 00 00 
  write_head(); // clear the log
80102c29:	e8 12 ff ff ff       	call   80102b40 <write_head>
}
80102c2e:	83 c4 10             	add    $0x10,%esp
80102c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c46:	68 20 38 11 80       	push   $0x80113820
80102c4b:	e8 80 27 00 00       	call   801053d0 <acquire>
80102c50:	83 c4 10             	add    $0x10,%esp
80102c53:	eb 18                	jmp    80102c6d <begin_op+0x2d>
80102c55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c58:	83 ec 08             	sub    $0x8,%esp
80102c5b:	68 20 38 11 80       	push   $0x80113820
80102c60:	68 20 38 11 80       	push   $0x80113820
80102c65:	e8 76 1a 00 00       	call   801046e0 <sleep>
80102c6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c6d:	a1 64 38 11 80       	mov    0x80113864,%eax
80102c72:	85 c0                	test   %eax,%eax
80102c74:	75 e2                	jne    80102c58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c76:	a1 60 38 11 80       	mov    0x80113860,%eax
80102c7b:	8b 15 6c 38 11 80    	mov    0x8011386c,%edx
80102c81:	83 c0 01             	add    $0x1,%eax
80102c84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c8a:	83 fa 1e             	cmp    $0x1e,%edx
80102c8d:	7f c9                	jg     80102c58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c92:	a3 60 38 11 80       	mov    %eax,0x80113860
      release(&log.lock);
80102c97:	68 20 38 11 80       	push   $0x80113820
80102c9c:	e8 ff 27 00 00       	call   801054a0 <release>
      break;
    }
  }
}
80102ca1:	83 c4 10             	add    $0x10,%esp
80102ca4:	c9                   	leave  
80102ca5:	c3                   	ret    
80102ca6:	8d 76 00             	lea    0x0(%esi),%esi
80102ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	57                   	push   %edi
80102cb4:	56                   	push   %esi
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102cb9:	68 20 38 11 80       	push   $0x80113820
80102cbe:	e8 0d 27 00 00       	call   801053d0 <acquire>
  log.outstanding -= 1;
80102cc3:	a1 60 38 11 80       	mov    0x80113860,%eax
  if(log.committing)
80102cc8:	8b 35 64 38 11 80    	mov    0x80113864,%esi
80102cce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102cd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102cd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102cd6:	89 1d 60 38 11 80    	mov    %ebx,0x80113860
  if(log.committing)
80102cdc:	0f 85 1a 01 00 00    	jne    80102dfc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102ce2:	85 db                	test   %ebx,%ebx
80102ce4:	0f 85 ee 00 00 00    	jne    80102dd8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ced:	c7 05 64 38 11 80 01 	movl   $0x1,0x80113864
80102cf4:	00 00 00 
  release(&log.lock);
80102cf7:	68 20 38 11 80       	push   $0x80113820
80102cfc:	e8 9f 27 00 00       	call   801054a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d01:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
80102d07:	83 c4 10             	add    $0x10,%esp
80102d0a:	85 c9                	test   %ecx,%ecx
80102d0c:	0f 8e 85 00 00 00    	jle    80102d97 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d12:	a1 58 38 11 80       	mov    0x80113858,%eax
80102d17:	83 ec 08             	sub    $0x8,%esp
80102d1a:	01 d8                	add    %ebx,%eax
80102d1c:	83 c0 01             	add    $0x1,%eax
80102d1f:	50                   	push   %eax
80102d20:	ff 35 68 38 11 80    	pushl  0x80113868
80102d26:	e8 a5 d3 ff ff       	call   801000d0 <bread>
80102d2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d2d:	58                   	pop    %eax
80102d2e:	5a                   	pop    %edx
80102d2f:	ff 34 9d 70 38 11 80 	pushl  -0x7feec790(,%ebx,4)
80102d36:	ff 35 68 38 11 80    	pushl  0x80113868
  for (tail = 0; tail < log.lh.n; tail++) {
80102d3c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d3f:	e8 8c d3 ff ff       	call   801000d0 <bread>
80102d44:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d46:	8d 40 60             	lea    0x60(%eax),%eax
80102d49:	83 c4 0c             	add    $0xc,%esp
80102d4c:	68 00 02 00 00       	push   $0x200
80102d51:	50                   	push   %eax
80102d52:	8d 46 60             	lea    0x60(%esi),%eax
80102d55:	50                   	push   %eax
80102d56:	e8 45 28 00 00       	call   801055a0 <memmove>
    bwrite(to);  // write the log
80102d5b:	89 34 24             	mov    %esi,(%esp)
80102d5e:	e8 3d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d63:	89 3c 24             	mov    %edi,(%esp)
80102d66:	e8 75 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d6b:	89 34 24             	mov    %esi,(%esp)
80102d6e:	e8 6d d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d73:	83 c4 10             	add    $0x10,%esp
80102d76:	3b 1d 6c 38 11 80    	cmp    0x8011386c,%ebx
80102d7c:	7c 94                	jl     80102d12 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d7e:	e8 bd fd ff ff       	call   80102b40 <write_head>
    install_trans(); // Now install writes to home locations
80102d83:	e8 18 fd ff ff       	call   80102aa0 <install_trans>
    log.lh.n = 0;
80102d88:	c7 05 6c 38 11 80 00 	movl   $0x0,0x8011386c
80102d8f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d92:	e8 a9 fd ff ff       	call   80102b40 <write_head>
    acquire(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
80102d9a:	68 20 38 11 80       	push   $0x80113820
80102d9f:	e8 2c 26 00 00       	call   801053d0 <acquire>
    wakeup(&log);
80102da4:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
    log.committing = 0;
80102dab:	c7 05 64 38 11 80 00 	movl   $0x0,0x80113864
80102db2:	00 00 00 
    wakeup(&log);
80102db5:	e8 06 12 00 00       	call   80103fc0 <wakeup>
    release(&log.lock);
80102dba:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80102dc1:	e8 da 26 00 00       	call   801054a0 <release>
80102dc6:	83 c4 10             	add    $0x10,%esp
}
80102dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dcc:	5b                   	pop    %ebx
80102dcd:	5e                   	pop    %esi
80102dce:	5f                   	pop    %edi
80102dcf:	5d                   	pop    %ebp
80102dd0:	c3                   	ret    
80102dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102dd8:	83 ec 0c             	sub    $0xc,%esp
80102ddb:	68 20 38 11 80       	push   $0x80113820
80102de0:	e8 db 11 00 00       	call   80103fc0 <wakeup>
  release(&log.lock);
80102de5:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80102dec:	e8 af 26 00 00       	call   801054a0 <release>
80102df1:	83 c4 10             	add    $0x10,%esp
}
80102df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df7:	5b                   	pop    %ebx
80102df8:	5e                   	pop    %esi
80102df9:	5f                   	pop    %edi
80102dfa:	5d                   	pop    %ebp
80102dfb:	c3                   	ret    
    panic("log.committing");
80102dfc:	83 ec 0c             	sub    $0xc,%esp
80102dff:	68 c4 86 10 80       	push   $0x801086c4
80102e04:	e8 87 d5 ff ff       	call   80100390 <panic>
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e17:	8b 15 6c 38 11 80    	mov    0x8011386c,%edx
{
80102e1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e20:	83 fa 1d             	cmp    $0x1d,%edx
80102e23:	0f 8f 9d 00 00 00    	jg     80102ec6 <log_write+0xb6>
80102e29:	a1 5c 38 11 80       	mov    0x8011385c,%eax
80102e2e:	83 e8 01             	sub    $0x1,%eax
80102e31:	39 c2                	cmp    %eax,%edx
80102e33:	0f 8d 8d 00 00 00    	jge    80102ec6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e39:	a1 60 38 11 80       	mov    0x80113860,%eax
80102e3e:	85 c0                	test   %eax,%eax
80102e40:	0f 8e 8d 00 00 00    	jle    80102ed3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	68 20 38 11 80       	push   $0x80113820
80102e4e:	e8 7d 25 00 00       	call   801053d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e53:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
80102e59:	83 c4 10             	add    $0x10,%esp
80102e5c:	83 f9 00             	cmp    $0x0,%ecx
80102e5f:	7e 57                	jle    80102eb8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e61:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e64:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e66:	3b 15 70 38 11 80    	cmp    0x80113870,%edx
80102e6c:	75 0b                	jne    80102e79 <log_write+0x69>
80102e6e:	eb 38                	jmp    80102ea8 <log_write+0x98>
80102e70:	39 14 85 70 38 11 80 	cmp    %edx,-0x7feec790(,%eax,4)
80102e77:	74 2f                	je     80102ea8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e79:	83 c0 01             	add    $0x1,%eax
80102e7c:	39 c1                	cmp    %eax,%ecx
80102e7e:	75 f0                	jne    80102e70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e80:	89 14 85 70 38 11 80 	mov    %edx,-0x7feec790(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e87:	83 c0 01             	add    $0x1,%eax
80102e8a:	a3 6c 38 11 80       	mov    %eax,0x8011386c
  b->flags |= B_DIRTY; // prevent eviction
80102e8f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e92:	c7 45 08 20 38 11 80 	movl   $0x80113820,0x8(%ebp)
}
80102e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e9c:	c9                   	leave  
  release(&log.lock);
80102e9d:	e9 fe 25 00 00       	jmp    801054a0 <release>
80102ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ea8:	89 14 85 70 38 11 80 	mov    %edx,-0x7feec790(,%eax,4)
80102eaf:	eb de                	jmp    80102e8f <log_write+0x7f>
80102eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eb8:	8b 43 08             	mov    0x8(%ebx),%eax
80102ebb:	a3 70 38 11 80       	mov    %eax,0x80113870
  if (i == log.lh.n)
80102ec0:	75 cd                	jne    80102e8f <log_write+0x7f>
80102ec2:	31 c0                	xor    %eax,%eax
80102ec4:	eb c1                	jmp    80102e87 <log_write+0x77>
    panic("too big a transaction");
80102ec6:	83 ec 0c             	sub    $0xc,%esp
80102ec9:	68 d3 86 10 80       	push   $0x801086d3
80102ece:	e8 bd d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102ed3:	83 ec 0c             	sub    $0xc,%esp
80102ed6:	68 e9 86 10 80       	push   $0x801086e9
80102edb:	e8 b0 d4 ff ff       	call   80100390 <panic>

80102ee0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	53                   	push   %ebx
80102ee4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ee7:	e8 d4 0a 00 00       	call   801039c0 <cpuid>
80102eec:	89 c3                	mov    %eax,%ebx
80102eee:	e8 cd 0a 00 00       	call   801039c0 <cpuid>
80102ef3:	83 ec 04             	sub    $0x4,%esp
80102ef6:	53                   	push   %ebx
80102ef7:	50                   	push   %eax
80102ef8:	68 04 87 10 80       	push   $0x80108704
80102efd:	e8 5e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102f02:	e8 49 3a 00 00       	call   80106950 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f07:	e8 34 0a 00 00       	call   80103940 <mycpu>
80102f0c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f0e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f13:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f1a:	e8 91 0e 00 00       	call   80103db0 <scheduler>
80102f1f:	90                   	nop

80102f20 <mpenter>:
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f26:	e8 f5 4b 00 00       	call   80107b20 <switchkvm>
  seginit();
80102f2b:	e8 60 4b 00 00       	call   80107a90 <seginit>
  lapicinit();
80102f30:	e8 9b f7 ff ff       	call   801026d0 <lapicinit>
  mpmain();
80102f35:	e8 a6 ff ff ff       	call   80102ee0 <mpmain>
80102f3a:	66 90                	xchg   %ax,%ax
80102f3c:	66 90                	xchg   %ax,%ax
80102f3e:	66 90                	xchg   %ax,%ax

80102f40 <main>:
{
80102f40:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f44:	83 e4 f0             	and    $0xfffffff0,%esp
80102f47:	ff 71 fc             	pushl  -0x4(%ecx)
80102f4a:	55                   	push   %ebp
80102f4b:	89 e5                	mov    %esp,%ebp
80102f4d:	53                   	push   %ebx
80102f4e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f4f:	83 ec 08             	sub    $0x8,%esp
80102f52:	68 00 00 40 80       	push   $0x80400000
80102f57:	68 68 e6 15 80       	push   $0x8015e668
80102f5c:	e8 2f f5 ff ff       	call   80102490 <kinit1>
  kvmalloc();      // kernel page table
80102f61:	e8 9a 50 00 00       	call   80108000 <kvmalloc>
  mpinit();        // detect other processors
80102f66:	e8 75 01 00 00       	call   801030e0 <mpinit>
  lapicinit();     // interrupt controller
80102f6b:	e8 60 f7 ff ff       	call   801026d0 <lapicinit>
  seginit();       // segment descriptors
80102f70:	e8 1b 4b 00 00       	call   80107a90 <seginit>
  picinit();       // disable pic
80102f75:	e8 46 03 00 00       	call   801032c0 <picinit>
  ioapicinit();    // another interrupt controller
80102f7a:	e8 41 f3 ff ff       	call   801022c0 <ioapicinit>
  consoleinit();   // console hardware
80102f7f:	e8 3c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f84:	e8 d7 3d 00 00       	call   80106d60 <uartinit>
  pinit();         // process table
80102f89:	e8 e2 08 00 00       	call   80103870 <pinit>
  tvinit();        // trap vectors
80102f8e:	e8 3d 39 00 00       	call   801068d0 <tvinit>
  binit();         // buffer cache
80102f93:	e8 a8 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f98:	e8 53 de ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
80102f9d:	e8 fe f0 ff ff       	call   801020a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102fa2:	83 c4 0c             	add    $0xc,%esp
80102fa5:	68 8a 00 00 00       	push   $0x8a
80102faa:	68 8c b4 10 80       	push   $0x8010b48c
80102faf:	68 00 70 00 80       	push   $0x80007000
80102fb4:	e8 e7 25 00 00       	call   801055a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102fb9:	69 05 c0 3e 11 80 b4 	imul   $0xb4,0x80113ec0,%eax
80102fc0:	00 00 00 
80102fc3:	83 c4 10             	add    $0x10,%esp
80102fc6:	05 20 39 11 80       	add    $0x80113920,%eax
80102fcb:	3d 20 39 11 80       	cmp    $0x80113920,%eax
80102fd0:	76 71                	jbe    80103043 <main+0x103>
80102fd2:	bb 20 39 11 80       	mov    $0x80113920,%ebx
80102fd7:	89 f6                	mov    %esi,%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102fe0:	e8 5b 09 00 00       	call   80103940 <mycpu>
80102fe5:	39 d8                	cmp    %ebx,%eax
80102fe7:	74 41                	je     8010302a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fe9:	e8 72 f5 ff ff       	call   80102560 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102ff3:	c7 05 f8 6f 00 80 20 	movl   $0x80102f20,0x80006ff8
80102ffa:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ffd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103004:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103007:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010300c:	0f b6 03             	movzbl (%ebx),%eax
8010300f:	83 ec 08             	sub    $0x8,%esp
80103012:	68 00 70 00 00       	push   $0x7000
80103017:	50                   	push   %eax
80103018:	e8 03 f8 ff ff       	call   80102820 <lapicstartap>
8010301d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103020:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103026:	85 c0                	test   %eax,%eax
80103028:	74 f6                	je     80103020 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010302a:	69 05 c0 3e 11 80 b4 	imul   $0xb4,0x80113ec0,%eax
80103031:	00 00 00 
80103034:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
8010303a:	05 20 39 11 80       	add    $0x80113920,%eax
8010303f:	39 c3                	cmp    %eax,%ebx
80103041:	72 9d                	jb     80102fe0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103043:	83 ec 08             	sub    $0x8,%esp
80103046:	68 00 00 00 8e       	push   $0x8e000000
8010304b:	68 00 00 40 80       	push   $0x80400000
80103050:	e8 ab f4 ff ff       	call   80102500 <kinit2>
  userinit();      // first user process
80103055:	e8 e6 09 00 00       	call   80103a40 <userinit>
  mpmain();        // finish this processor's setup
8010305a:	e8 81 fe ff ff       	call   80102ee0 <mpmain>
8010305f:	90                   	nop

80103060 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	57                   	push   %edi
80103064:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103065:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010306b:	53                   	push   %ebx
  e = addr+len;
8010306c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010306f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103072:	39 de                	cmp    %ebx,%esi
80103074:	72 10                	jb     80103086 <mpsearch1+0x26>
80103076:	eb 50                	jmp    801030c8 <mpsearch1+0x68>
80103078:	90                   	nop
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103080:	39 fb                	cmp    %edi,%ebx
80103082:	89 fe                	mov    %edi,%esi
80103084:	76 42                	jbe    801030c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103086:	83 ec 04             	sub    $0x4,%esp
80103089:	8d 7e 10             	lea    0x10(%esi),%edi
8010308c:	6a 04                	push   $0x4
8010308e:	68 18 87 10 80       	push   $0x80108718
80103093:	56                   	push   %esi
80103094:	e8 a7 24 00 00       	call   80105540 <memcmp>
80103099:	83 c4 10             	add    $0x10,%esp
8010309c:	85 c0                	test   %eax,%eax
8010309e:	75 e0                	jne    80103080 <mpsearch1+0x20>
801030a0:	89 f1                	mov    %esi,%ecx
801030a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801030a8:	0f b6 11             	movzbl (%ecx),%edx
801030ab:	83 c1 01             	add    $0x1,%ecx
801030ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801030b0:	39 f9                	cmp    %edi,%ecx
801030b2:	75 f4                	jne    801030a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030b4:	84 c0                	test   %al,%al
801030b6:	75 c8                	jne    80103080 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801030b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bb:	89 f0                	mov    %esi,%eax
801030bd:	5b                   	pop    %ebx
801030be:	5e                   	pop    %esi
801030bf:	5f                   	pop    %edi
801030c0:	5d                   	pop    %ebp
801030c1:	c3                   	ret    
801030c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801030cb:	31 f6                	xor    %esi,%esi
}
801030cd:	89 f0                	mov    %esi,%eax
801030cf:	5b                   	pop    %ebx
801030d0:	5e                   	pop    %esi
801030d1:	5f                   	pop    %edi
801030d2:	5d                   	pop    %ebp
801030d3:	c3                   	ret    
801030d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801030e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	57                   	push   %edi
801030e4:	56                   	push   %esi
801030e5:	53                   	push   %ebx
801030e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030f7:	c1 e0 08             	shl    $0x8,%eax
801030fa:	09 d0                	or     %edx,%eax
801030fc:	c1 e0 04             	shl    $0x4,%eax
801030ff:	85 c0                	test   %eax,%eax
80103101:	75 1b                	jne    8010311e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103103:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010310a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103111:	c1 e0 08             	shl    $0x8,%eax
80103114:	09 d0                	or     %edx,%eax
80103116:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103119:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010311e:	ba 00 04 00 00       	mov    $0x400,%edx
80103123:	e8 38 ff ff ff       	call   80103060 <mpsearch1>
80103128:	85 c0                	test   %eax,%eax
8010312a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010312d:	0f 84 3d 01 00 00    	je     80103270 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103136:	8b 58 04             	mov    0x4(%eax),%ebx
80103139:	85 db                	test   %ebx,%ebx
8010313b:	0f 84 4f 01 00 00    	je     80103290 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103141:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103147:	83 ec 04             	sub    $0x4,%esp
8010314a:	6a 04                	push   $0x4
8010314c:	68 35 87 10 80       	push   $0x80108735
80103151:	56                   	push   %esi
80103152:	e8 e9 23 00 00       	call   80105540 <memcmp>
80103157:	83 c4 10             	add    $0x10,%esp
8010315a:	85 c0                	test   %eax,%eax
8010315c:	0f 85 2e 01 00 00    	jne    80103290 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103162:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103169:	3c 01                	cmp    $0x1,%al
8010316b:	0f 95 c2             	setne  %dl
8010316e:	3c 04                	cmp    $0x4,%al
80103170:	0f 95 c0             	setne  %al
80103173:	20 c2                	and    %al,%dl
80103175:	0f 85 15 01 00 00    	jne    80103290 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010317b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103182:	66 85 ff             	test   %di,%di
80103185:	74 1a                	je     801031a1 <mpinit+0xc1>
80103187:	89 f0                	mov    %esi,%eax
80103189:	01 f7                	add    %esi,%edi
  sum = 0;
8010318b:	31 d2                	xor    %edx,%edx
8010318d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103190:	0f b6 08             	movzbl (%eax),%ecx
80103193:	83 c0 01             	add    $0x1,%eax
80103196:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103198:	39 c7                	cmp    %eax,%edi
8010319a:	75 f4                	jne    80103190 <mpinit+0xb0>
8010319c:	84 d2                	test   %dl,%dl
8010319e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801031a1:	85 f6                	test   %esi,%esi
801031a3:	0f 84 e7 00 00 00    	je     80103290 <mpinit+0x1b0>
801031a9:	84 d2                	test   %dl,%dl
801031ab:	0f 85 df 00 00 00    	jne    80103290 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801031b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031b7:	a3 00 38 11 80       	mov    %eax,0x80113800
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801031c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801031c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031ce:	01 d6                	add    %edx,%esi
801031d0:	39 c6                	cmp    %eax,%esi
801031d2:	76 23                	jbe    801031f7 <mpinit+0x117>
    switch(*p){
801031d4:	0f b6 10             	movzbl (%eax),%edx
801031d7:	80 fa 04             	cmp    $0x4,%dl
801031da:	0f 87 ca 00 00 00    	ja     801032aa <mpinit+0x1ca>
801031e0:	ff 24 95 5c 87 10 80 	jmp    *-0x7fef78a4(,%edx,4)
801031e7:	89 f6                	mov    %esi,%esi
801031e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031f3:	39 c6                	cmp    %eax,%esi
801031f5:	77 dd                	ja     801031d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801031f7:	85 db                	test   %ebx,%ebx
801031f9:	0f 84 9e 00 00 00    	je     8010329d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103202:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103206:	74 15                	je     8010321d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103208:	b8 70 00 00 00       	mov    $0x70,%eax
8010320d:	ba 22 00 00 00       	mov    $0x22,%edx
80103212:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103213:	ba 23 00 00 00       	mov    $0x23,%edx
80103218:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103219:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010321c:	ee                   	out    %al,(%dx)
  }
}
8010321d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103220:	5b                   	pop    %ebx
80103221:	5e                   	pop    %esi
80103222:	5f                   	pop    %edi
80103223:	5d                   	pop    %ebp
80103224:	c3                   	ret    
80103225:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103228:	8b 0d c0 3e 11 80    	mov    0x80113ec0,%ecx
8010322e:	83 f9 07             	cmp    $0x7,%ecx
80103231:	7f 19                	jg     8010324c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103233:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103237:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
8010323d:	83 c1 01             	add    $0x1,%ecx
80103240:	89 0d c0 3e 11 80    	mov    %ecx,0x80113ec0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103246:	88 97 20 39 11 80    	mov    %dl,-0x7feec6e0(%edi)
      p += sizeof(struct mpproc);
8010324c:	83 c0 14             	add    $0x14,%eax
      continue;
8010324f:	e9 7c ff ff ff       	jmp    801031d0 <mpinit+0xf0>
80103254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103258:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010325c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010325f:	88 15 00 39 11 80    	mov    %dl,0x80113900
      continue;
80103265:	e9 66 ff ff ff       	jmp    801031d0 <mpinit+0xf0>
8010326a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103270:	ba 00 00 01 00       	mov    $0x10000,%edx
80103275:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010327a:	e8 e1 fd ff ff       	call   80103060 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010327f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103284:	0f 85 a9 fe ff ff    	jne    80103133 <mpinit+0x53>
8010328a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103290:	83 ec 0c             	sub    $0xc,%esp
80103293:	68 1d 87 10 80       	push   $0x8010871d
80103298:	e8 f3 d0 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010329d:	83 ec 0c             	sub    $0xc,%esp
801032a0:	68 3c 87 10 80       	push   $0x8010873c
801032a5:	e8 e6 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
801032aa:	31 db                	xor    %ebx,%ebx
801032ac:	e9 26 ff ff ff       	jmp    801031d7 <mpinit+0xf7>
801032b1:	66 90                	xchg   %ax,%ax
801032b3:	66 90                	xchg   %ax,%ax
801032b5:	66 90                	xchg   %ax,%ax
801032b7:	66 90                	xchg   %ax,%ax
801032b9:	66 90                	xchg   %ax,%ax
801032bb:	66 90                	xchg   %ax,%ax
801032bd:	66 90                	xchg   %ax,%ax
801032bf:	90                   	nop

801032c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801032c0:	55                   	push   %ebp
801032c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032c6:	ba 21 00 00 00       	mov    $0x21,%edx
801032cb:	89 e5                	mov    %esp,%ebp
801032cd:	ee                   	out    %al,(%dx)
801032ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801032d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801032d4:	5d                   	pop    %ebp
801032d5:	c3                   	ret    
801032d6:	66 90                	xchg   %ax,%ax
801032d8:	66 90                	xchg   %ax,%ax
801032da:	66 90                	xchg   %ax,%ax
801032dc:	66 90                	xchg   %ax,%ax
801032de:	66 90                	xchg   %ax,%ax

801032e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 0c             	sub    $0xc,%esp
801032e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801032f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032fb:	e8 10 db ff ff       	call   80100e10 <filealloc>
80103300:	85 c0                	test   %eax,%eax
80103302:	89 03                	mov    %eax,(%ebx)
80103304:	74 22                	je     80103328 <pipealloc+0x48>
80103306:	e8 05 db ff ff       	call   80100e10 <filealloc>
8010330b:	85 c0                	test   %eax,%eax
8010330d:	89 06                	mov    %eax,(%esi)
8010330f:	74 3f                	je     80103350 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103311:	e8 4a f2 ff ff       	call   80102560 <kalloc>
80103316:	85 c0                	test   %eax,%eax
80103318:	89 c7                	mov    %eax,%edi
8010331a:	75 54                	jne    80103370 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010331c:	8b 03                	mov    (%ebx),%eax
8010331e:	85 c0                	test   %eax,%eax
80103320:	75 34                	jne    80103356 <pipealloc+0x76>
80103322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103328:	8b 06                	mov    (%esi),%eax
8010332a:	85 c0                	test   %eax,%eax
8010332c:	74 0c                	je     8010333a <pipealloc+0x5a>
    fileclose(*f1);
8010332e:	83 ec 0c             	sub    $0xc,%esp
80103331:	50                   	push   %eax
80103332:	e8 99 db ff ff       	call   80100ed0 <fileclose>
80103337:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010333a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010333d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103342:	5b                   	pop    %ebx
80103343:	5e                   	pop    %esi
80103344:	5f                   	pop    %edi
80103345:	5d                   	pop    %ebp
80103346:	c3                   	ret    
80103347:	89 f6                	mov    %esi,%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103350:	8b 03                	mov    (%ebx),%eax
80103352:	85 c0                	test   %eax,%eax
80103354:	74 e4                	je     8010333a <pipealloc+0x5a>
    fileclose(*f0);
80103356:	83 ec 0c             	sub    $0xc,%esp
80103359:	50                   	push   %eax
8010335a:	e8 71 db ff ff       	call   80100ed0 <fileclose>
  if(*f1)
8010335f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103361:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103364:	85 c0                	test   %eax,%eax
80103366:	75 c6                	jne    8010332e <pipealloc+0x4e>
80103368:	eb d0                	jmp    8010333a <pipealloc+0x5a>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103370:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103373:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010337a:	00 00 00 
  p->writeopen = 1;
8010337d:	c7 80 44 02 00 00 01 	movl   $0x1,0x244(%eax)
80103384:	00 00 00 
  p->nwrite = 0;
80103387:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010338e:	00 00 00 
  p->nread = 0;
80103391:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103398:	00 00 00 
  initlock(&p->lock, "pipe");
8010339b:	68 70 87 10 80       	push   $0x80108770
801033a0:	50                   	push   %eax
801033a1:	e8 ea 1e 00 00       	call   80105290 <initlock>
  (*f0)->type = FD_PIPE;
801033a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801033a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033b1:	8b 03                	mov    (%ebx),%eax
801033b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033b7:	8b 03                	mov    (%ebx),%eax
801033b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033bd:	8b 03                	mov    (%ebx),%eax
801033bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033c2:	8b 06                	mov    (%esi),%eax
801033c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033ca:	8b 06                	mov    (%esi),%eax
801033cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033d0:	8b 06                	mov    (%esi),%eax
801033d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033d6:	8b 06                	mov    (%esi),%eax
801033d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801033db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033de:	31 c0                	xor    %eax,%eax
}
801033e0:	5b                   	pop    %ebx
801033e1:	5e                   	pop    %esi
801033e2:	5f                   	pop    %edi
801033e3:	5d                   	pop    %ebp
801033e4:	c3                   	ret    
801033e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	56                   	push   %esi
801033f4:	53                   	push   %ebx
801033f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033fb:	83 ec 0c             	sub    $0xc,%esp
801033fe:	53                   	push   %ebx
801033ff:	e8 cc 1f 00 00       	call   801053d0 <acquire>
  if(writable){
80103404:	83 c4 10             	add    $0x10,%esp
80103407:	85 f6                	test   %esi,%esi
80103409:	74 45                	je     80103450 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010340b:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103411:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103414:	c7 83 44 02 00 00 00 	movl   $0x0,0x244(%ebx)
8010341b:	00 00 00 
    wakeup(&p->nread);
8010341e:	50                   	push   %eax
8010341f:	e8 9c 0b 00 00       	call   80103fc0 <wakeup>
80103424:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103427:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
8010342d:	85 d2                	test   %edx,%edx
8010342f:	75 0a                	jne    8010343b <pipeclose+0x4b>
80103431:	8b 83 44 02 00 00    	mov    0x244(%ebx),%eax
80103437:	85 c0                	test   %eax,%eax
80103439:	74 35                	je     80103470 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010343b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010343e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103441:	5b                   	pop    %ebx
80103442:	5e                   	pop    %esi
80103443:	5d                   	pop    %ebp
    release(&p->lock);
80103444:	e9 57 20 00 00       	jmp    801054a0 <release>
80103449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103450:	8d 83 3c 02 00 00    	lea    0x23c(%ebx),%eax
80103456:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103459:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103460:	00 00 00 
    wakeup(&p->nwrite);
80103463:	50                   	push   %eax
80103464:	e8 57 0b 00 00       	call   80103fc0 <wakeup>
80103469:	83 c4 10             	add    $0x10,%esp
8010346c:	eb b9                	jmp    80103427 <pipeclose+0x37>
8010346e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103470:	83 ec 0c             	sub    $0xc,%esp
80103473:	53                   	push   %ebx
80103474:	e8 27 20 00 00       	call   801054a0 <release>
    kfree((char*)p);
80103479:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010347c:	83 c4 10             	add    $0x10,%esp
}
8010347f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103482:	5b                   	pop    %ebx
80103483:	5e                   	pop    %esi
80103484:	5d                   	pop    %ebp
    kfree((char*)p);
80103485:	e9 26 ef ff ff       	jmp    801023b0 <kfree>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103490 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 28             	sub    $0x28,%esp
80103499:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010349c:	53                   	push   %ebx
8010349d:	e8 2e 1f 00 00       	call   801053d0 <acquire>
  for(i = 0; i < n; i++){
801034a2:	8b 45 10             	mov    0x10(%ebp),%eax
801034a5:	83 c4 10             	add    $0x10,%esp
801034a8:	85 c0                	test   %eax,%eax
801034aa:	0f 8e c9 00 00 00    	jle    80103579 <pipewrite+0xe9>
801034b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801034b3:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034b9:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
801034bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801034c2:	03 4d 10             	add    0x10(%ebp),%ecx
801034c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034c8:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
801034ce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801034d4:	39 d0                	cmp    %edx,%eax
801034d6:	75 71                	jne    80103549 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801034d8:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034de:	85 c0                	test   %eax,%eax
801034e0:	74 4e                	je     80103530 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034e2:	8d b3 3c 02 00 00    	lea    0x23c(%ebx),%esi
801034e8:	eb 3a                	jmp    80103524 <pipewrite+0x94>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	57                   	push   %edi
801034f4:	e8 c7 0a 00 00       	call   80103fc0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034f9:	5a                   	pop    %edx
801034fa:	59                   	pop    %ecx
801034fb:	53                   	push   %ebx
801034fc:	56                   	push   %esi
801034fd:	e8 de 11 00 00       	call   801046e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103502:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103508:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010350e:	83 c4 10             	add    $0x10,%esp
80103511:	05 00 02 00 00       	add    $0x200,%eax
80103516:	39 c2                	cmp    %eax,%edx
80103518:	75 36                	jne    80103550 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010351a:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103520:	85 c0                	test   %eax,%eax
80103522:	74 0c                	je     80103530 <pipewrite+0xa0>
80103524:	e8 b7 04 00 00       	call   801039e0 <myproc>
80103529:	8b 40 1c             	mov    0x1c(%eax),%eax
8010352c:	85 c0                	test   %eax,%eax
8010352e:	74 c0                	je     801034f0 <pipewrite+0x60>
        release(&p->lock);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	53                   	push   %ebx
80103534:	e8 67 1f 00 00       	call   801054a0 <release>
        return -1;
80103539:	83 c4 10             	add    $0x10,%esp
8010353c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103544:	5b                   	pop    %ebx
80103545:	5e                   	pop    %esi
80103546:	5f                   	pop    %edi
80103547:	5d                   	pop    %ebp
80103548:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103549:	89 c2                	mov    %eax,%edx
8010354b:	90                   	nop
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103550:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103553:	8d 42 01             	lea    0x1(%edx),%eax
80103556:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010355c:	89 83 3c 02 00 00    	mov    %eax,0x23c(%ebx)
80103562:	83 c6 01             	add    $0x1,%esi
80103565:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103569:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010356c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010356f:	88 4c 13 38          	mov    %cl,0x38(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103573:	0f 85 4f ff ff ff    	jne    801034c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103579:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010357f:	83 ec 0c             	sub    $0xc,%esp
80103582:	50                   	push   %eax
80103583:	e8 38 0a 00 00       	call   80103fc0 <wakeup>
  release(&p->lock);
80103588:	89 1c 24             	mov    %ebx,(%esp)
8010358b:	e8 10 1f 00 00       	call   801054a0 <release>
  return n;
80103590:	83 c4 10             	add    $0x10,%esp
80103593:	8b 45 10             	mov    0x10(%ebp),%eax
80103596:	eb a9                	jmp    80103541 <pipewrite+0xb1>
80103598:	90                   	nop
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 18             	sub    $0x18,%esp
801035a9:	8b 75 08             	mov    0x8(%ebp),%esi
801035ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035af:	56                   	push   %esi
801035b0:	e8 1b 1e 00 00       	call   801053d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
801035be:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
801035c4:	75 6a                	jne    80103630 <piperead+0x90>
801035c6:	8b 9e 44 02 00 00    	mov    0x244(%esi),%ebx
801035cc:	85 db                	test   %ebx,%ebx
801035ce:	0f 84 c4 00 00 00    	je     80103698 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035d4:	8d 9e 38 02 00 00    	lea    0x238(%esi),%ebx
801035da:	eb 2d                	jmp    80103609 <piperead+0x69>
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e0:	83 ec 08             	sub    $0x8,%esp
801035e3:	56                   	push   %esi
801035e4:	53                   	push   %ebx
801035e5:	e8 f6 10 00 00       	call   801046e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035ea:	83 c4 10             	add    $0x10,%esp
801035ed:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
801035f3:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
801035f9:	75 35                	jne    80103630 <piperead+0x90>
801035fb:	8b 96 44 02 00 00    	mov    0x244(%esi),%edx
80103601:	85 d2                	test   %edx,%edx
80103603:	0f 84 8f 00 00 00    	je     80103698 <piperead+0xf8>
    if(myproc()->killed){
80103609:	e8 d2 03 00 00       	call   801039e0 <myproc>
8010360e:	8b 48 1c             	mov    0x1c(%eax),%ecx
80103611:	85 c9                	test   %ecx,%ecx
80103613:	74 cb                	je     801035e0 <piperead+0x40>
      release(&p->lock);
80103615:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103618:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010361d:	56                   	push   %esi
8010361e:	e8 7d 1e 00 00       	call   801054a0 <release>
      return -1;
80103623:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103626:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103629:	89 d8                	mov    %ebx,%eax
8010362b:	5b                   	pop    %ebx
8010362c:	5e                   	pop    %esi
8010362d:	5f                   	pop    %edi
8010362e:	5d                   	pop    %ebp
8010362f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103630:	8b 45 10             	mov    0x10(%ebp),%eax
80103633:	85 c0                	test   %eax,%eax
80103635:	7e 61                	jle    80103698 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103637:	31 db                	xor    %ebx,%ebx
80103639:	eb 13                	jmp    8010364e <piperead+0xae>
8010363b:	90                   	nop
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103640:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
80103646:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
8010364c:	74 1f                	je     8010366d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010364e:	8d 41 01             	lea    0x1(%ecx),%eax
80103651:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103657:	89 86 38 02 00 00    	mov    %eax,0x238(%esi)
8010365d:	0f b6 44 0e 38       	movzbl 0x38(%esi,%ecx,1),%eax
80103662:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103665:	83 c3 01             	add    $0x1,%ebx
80103668:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010366b:	75 d3                	jne    80103640 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010366d:	8d 86 3c 02 00 00    	lea    0x23c(%esi),%eax
80103673:	83 ec 0c             	sub    $0xc,%esp
80103676:	50                   	push   %eax
80103677:	e8 44 09 00 00       	call   80103fc0 <wakeup>
  release(&p->lock);
8010367c:	89 34 24             	mov    %esi,(%esp)
8010367f:	e8 1c 1e 00 00       	call   801054a0 <release>
  return i;
80103684:	83 c4 10             	add    $0x10,%esp
}
80103687:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368a:	89 d8                	mov    %ebx,%eax
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret    
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103698:	31 db                	xor    %ebx,%ebx
8010369a:	eb d1                	jmp    8010366d <piperead+0xcd>
8010369c:	66 90                	xchg   %ax,%ax
8010369e:	66 90                	xchg   %ax,%ax

801036a0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
801036a0:	55                   	push   %ebp
        cprintf(" ALLOCPROC ");
    struct proc *p;
    struct thread *t;
    struct kthread_mutex_t *m;
    char *sp;
    ptable.lock.name = "ALLOC";
801036a1:	c7 05 e4 3e 11 80 75 	movl   $0x80108775,0x80113ee4
801036a8:	87 10 80 
allocproc(void) {
801036ab:	89 e5                	mov    %esp,%ebp
801036ad:	56                   	push   %esi
801036ae:	53                   	push   %ebx
    acquire(&ptable.lock);


    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036af:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx
    acquire(&ptable.lock);
801036b4:	83 ec 0c             	sub    $0xc,%esp
801036b7:	68 e0 3e 11 80       	push   $0x80113ee0
801036bc:	e8 0f 1d 00 00       	call   801053d0 <acquire>
801036c1:	83 c4 10             	add    $0x10,%esp
801036c4:	eb 18                	jmp    801036de <allocproc+0x3e>
801036c6:	8d 76 00             	lea    0x0(%esi),%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036d0:	81 c3 7c 12 00 00    	add    $0x127c,%ebx
801036d6:	81 fb 18 de 15 80    	cmp    $0x8015de18,%ebx
801036dc:	73 4e                	jae    8010372c <allocproc+0x8c>
        if (p->state == UNUSED)
801036de:	8b 73 08             	mov    0x8(%ebx),%esi
801036e1:	85 f6                	test   %esi,%esi
801036e3:	75 eb                	jne    801036d0 <allocproc+0x30>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
801036e5:	a1 08 b0 10 80       	mov    0x8010b008,%eax


    //from here- thread alloc
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t->state == UNUSED)
801036ea:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801036ed:	8d 73 74             	lea    0x74(%ebx),%esi
    p->state = EMBRYO;
801036f0:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    p->pid = nextpid++;
801036f7:	8d 50 01             	lea    0x1(%eax),%edx
        if (t->state == UNUSED)
801036fa:	85 c9                	test   %ecx,%ecx
    p->pid = nextpid++;
801036fc:	89 43 0c             	mov    %eax,0xc(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801036ff:	8d 83 74 03 00 00    	lea    0x374(%ebx),%eax
    p->pid = nextpid++;
80103705:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
        if (t->state == UNUSED)
8010370b:	75 0a                	jne    80103717 <allocproc+0x77>
8010370d:	eb 41                	jmp    80103750 <allocproc+0xb0>
8010370f:	90                   	nop
80103710:	8b 56 08             	mov    0x8(%esi),%edx
80103713:	85 d2                	test   %edx,%edx
80103715:	74 39                	je     80103750 <allocproc+0xb0>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103717:	83 c6 30             	add    $0x30,%esi
8010371a:	39 c6                	cmp    %eax,%esi
8010371c:	72 f2                	jb     80103710 <allocproc+0x70>
            goto foundThread;
    }

    p->pid = 0;
8010371e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    p->state = UNUSED;
80103725:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pid = -1;
        p->state = UNUSED;
        t->tid = -1;
        t->tkilled = 0;
        t->state = UNUSED;
        release(&ptable.lock);
8010372c:	83 ec 0c             	sub    $0xc,%esp
        return 0;
8010372f:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
80103731:	68 e0 3e 11 80       	push   $0x80113ee0
80103736:	e8 65 1d 00 00       	call   801054a0 <release>
        return 0;
8010373b:	83 c4 10             	add    $0x10,%esp
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);

    return p;
}
8010373e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103741:	89 d8                	mov    %ebx,%eax
80103743:	5b                   	pop    %ebx
80103744:	5e                   	pop    %esi
80103745:	5d                   	pop    %ebp
80103746:	c3                   	ret    
80103747:	89 f6                	mov    %esi,%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    t->tid = tidCounter++;
80103750:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    t->state = EMBRYO;
80103755:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    t->tid = tidCounter++;
8010375c:	8d 50 01             	lea    0x1(%eax),%edx
8010375f:	89 46 0c             	mov    %eax,0xc(%esi)
    for (m = p->kthread_mutex_t; m < &p->kthread_mutex_t[MAX_MUTEXES]; m++)
80103762:	8d 83 78 03 00 00    	lea    0x378(%ebx),%eax
    p->mainThread = t;
80103768:	89 b3 74 03 00 00    	mov    %esi,0x374(%ebx)
    t->tkilled = 0;
8010376e:	c7 46 1c 00 00 00 00 	movl   $0x0,0x1c(%esi)
    t->tid = tidCounter++;
80103775:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    for (m = p->kthread_mutex_t; m < &p->kthread_mutex_t[MAX_MUTEXES]; m++)
8010377b:	8d 93 78 12 00 00    	lea    0x1278(%ebx),%edx
80103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        m->active = 0;
80103788:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    for (m = p->kthread_mutex_t; m < &p->kthread_mutex_t[MAX_MUTEXES]; m++)
8010378f:	83 c0 3c             	add    $0x3c,%eax
80103792:	39 c2                	cmp    %eax,%edx
80103794:	77 f2                	ja     80103788 <allocproc+0xe8>
    if ((t->tkstack = kalloc()) == 0) {
80103796:	e8 c5 ed ff ff       	call   80102560 <kalloc>
8010379b:	85 c0                	test   %eax,%eax
8010379d:	89 46 04             	mov    %eax,0x4(%esi)
801037a0:	74 47                	je     801037e9 <allocproc+0x149>
    sp -= sizeof *t->tf;
801037a2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(t->context, 0, sizeof *t->context);
801037a8:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
801037ab:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
801037b0:	89 56 10             	mov    %edx,0x10(%esi)
    *(uint *) sp = (uint) trapret;
801037b3:	c7 40 14 bf 68 10 80 	movl   $0x801068bf,0x14(%eax)
    t->context = (struct context *) sp;
801037ba:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
801037bd:	6a 14                	push   $0x14
801037bf:	6a 00                	push   $0x0
801037c1:	50                   	push   %eax
801037c2:	e8 29 1d 00 00       	call   801054f0 <memset>
    t->context->eip = (uint) forkret;
801037c7:	8b 46 14             	mov    0x14(%esi),%eax
801037ca:	c7 40 10 20 38 10 80 	movl   $0x80103820,0x10(%eax)
    release(&ptable.lock);
801037d1:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
801037d8:	e8 c3 1c 00 00       	call   801054a0 <release>
    return p;
801037dd:	83 c4 10             	add    $0x10,%esp
}
801037e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037e3:	89 d8                	mov    %ebx,%eax
801037e5:	5b                   	pop    %ebx
801037e6:	5e                   	pop    %esi
801037e7:	5d                   	pop    %ebp
801037e8:	c3                   	ret    
        p->pid = -1;
801037e9:	c7 43 0c ff ff ff ff 	movl   $0xffffffff,0xc(%ebx)
        p->state = UNUSED;
801037f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        t->tid = -1;
801037f7:	c7 46 0c ff ff ff ff 	movl   $0xffffffff,0xc(%esi)
        t->tkilled = 0;
801037fe:	c7 46 1c 00 00 00 00 	movl   $0x0,0x1c(%esi)
        t->state = UNUSED;
80103805:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
8010380c:	e9 1b ff ff ff       	jmp    8010372c <allocproc+0x8c>
80103811:	eb 0d                	jmp    80103820 <forkret>
80103813:	90                   	nop
80103814:	90                   	nop
80103815:	90                   	nop
80103816:	90                   	nop
80103817:	90                   	nop
80103818:	90                   	nop
80103819:	90                   	nop
8010381a:	90                   	nop
8010381b:	90                   	nop
8010381c:	90                   	nop
8010381d:	90                   	nop
8010381e:	90                   	nop
8010381f:	90                   	nop

80103820 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103826:	68 e0 3e 11 80       	push   $0x80113ee0
8010382b:	e8 70 1c 00 00       	call   801054a0 <release>

    if (first) {
80103830:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103835:	83 c4 10             	add    $0x10,%esp
80103838:	85 c0                	test   %eax,%eax
8010383a:	75 04                	jne    80103840 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
8010383c:	c9                   	leave  
8010383d:	c3                   	ret    
8010383e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103840:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103843:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010384a:	00 00 00 
        iinit(ROOTDEV);
8010384d:	6a 01                	push   $0x1
8010384f:	e8 cc dc ff ff       	call   80101520 <iinit>
        initlog(ROOTDEV);
80103854:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010385b:	e8 40 f3 ff ff       	call   80102ba0 <initlog>
80103860:	83 c4 10             	add    $0x10,%esp
}
80103863:	c9                   	leave  
80103864:	c3                   	ret    
80103865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103870 <pinit>:
pinit(void) {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103876:	68 7b 87 10 80       	push   $0x8010877b
8010387b:	68 e0 3e 11 80       	push   $0x80113ee0
80103880:	e8 0b 1a 00 00       	call   80105290 <initlock>
}
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	c9                   	leave  
80103889:	c3                   	ret    
8010388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103890 <exec_acquire>:
exec_acquire(void) {
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock);
80103896:	68 e0 3e 11 80       	push   $0x80113ee0
8010389b:	e8 30 1b 00 00       	call   801053d0 <acquire>
}
801038a0:	83 c4 10             	add    $0x10,%esp
801038a3:	c9                   	leave  
801038a4:	c3                   	ret    
801038a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038b0 <exec_release>:
exec_release(void) {
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
    release(&ptable.lock);
801038b6:	68 e0 3e 11 80       	push   $0x80113ee0
801038bb:	e8 e0 1b 00 00       	call   801054a0 <release>
}
801038c0:	83 c4 10             	add    $0x10,%esp
801038c3:	c9                   	leave  
801038c4:	c3                   	ret    
801038c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <cleanThread>:
cleanThread(struct thread *t) {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 04             	sub    $0x4,%esp
801038d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (t->tkstack != 0) {
801038da:	8b 43 04             	mov    0x4(%ebx),%eax
801038dd:	85 c0                	test   %eax,%eax
801038df:	74 13                	je     801038f4 <cleanThread+0x24>
        kfree(t->tkstack);
801038e1:	83 ec 0c             	sub    $0xc,%esp
801038e4:	50                   	push   %eax
801038e5:	e8 c6 ea ff ff       	call   801023b0 <kfree>
        t->tkstack = 0;
801038ea:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
801038f1:	83 c4 10             	add    $0x10,%esp
    memset(t->tf, 0, sizeof(*t->tf));
801038f4:	83 ec 04             	sub    $0x4,%esp
    t->state = UNUSED;
801038f7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    t->tid = 0;
801038fe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    t->name[0] = 0;
80103905:	c6 43 20 00          	movb   $0x0,0x20(%ebx)
    t->tkilled = 0;
80103909:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    memset(t->tf, 0, sizeof(*t->tf));
80103910:	6a 4c                	push   $0x4c
80103912:	6a 00                	push   $0x0
80103914:	ff 73 10             	pushl  0x10(%ebx)
80103917:	e8 d4 1b 00 00       	call   801054f0 <memset>
    memset(t->context, 0, sizeof(*t->context));
8010391c:	83 c4 0c             	add    $0xc,%esp
8010391f:	6a 14                	push   $0x14
80103921:	6a 00                	push   $0x0
80103923:	ff 73 14             	pushl  0x14(%ebx)
80103926:	e8 c5 1b 00 00       	call   801054f0 <memset>
}
8010392b:	83 c4 10             	add    $0x10,%esp
8010392e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103931:	c9                   	leave  
80103932:	c3                   	ret    
80103933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103940 <mycpu>:
mycpu(void) {
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103945:	9c                   	pushf  
80103946:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103947:	f6 c4 02             	test   $0x2,%ah
8010394a:	75 5e                	jne    801039aa <mycpu+0x6a>
    apicid = lapicid();
8010394c:	e8 7f ee ff ff       	call   801027d0 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103951:	8b 35 c0 3e 11 80    	mov    0x80113ec0,%esi
80103957:	85 f6                	test   %esi,%esi
80103959:	7e 42                	jle    8010399d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010395b:	0f b6 15 20 39 11 80 	movzbl 0x80113920,%edx
80103962:	39 d0                	cmp    %edx,%eax
80103964:	74 30                	je     80103996 <mycpu+0x56>
80103966:	b9 d4 39 11 80       	mov    $0x801139d4,%ecx
    for (i = 0; i < ncpu; ++i) {
8010396b:	31 d2                	xor    %edx,%edx
8010396d:	8d 76 00             	lea    0x0(%esi),%esi
80103970:	83 c2 01             	add    $0x1,%edx
80103973:	39 f2                	cmp    %esi,%edx
80103975:	74 26                	je     8010399d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103977:	0f b6 19             	movzbl (%ecx),%ebx
8010397a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
80103980:	39 c3                	cmp    %eax,%ebx
80103982:	75 ec                	jne    80103970 <mycpu+0x30>
80103984:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
8010398a:	05 20 39 11 80       	add    $0x80113920,%eax
}
8010398f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103992:	5b                   	pop    %ebx
80103993:	5e                   	pop    %esi
80103994:	5d                   	pop    %ebp
80103995:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103996:	b8 20 39 11 80       	mov    $0x80113920,%eax
            return &cpus[i];
8010399b:	eb f2                	jmp    8010398f <mycpu+0x4f>
    panic("unknown apicid\n");
8010399d:	83 ec 0c             	sub    $0xc,%esp
801039a0:	68 82 87 10 80       	push   $0x80108782
801039a5:	e8 e6 c9 ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
801039aa:	83 ec 0c             	sub    $0xc,%esp
801039ad:	68 d0 88 10 80       	push   $0x801088d0
801039b2:	e8 d9 c9 ff ff       	call   80100390 <panic>
801039b7:	89 f6                	mov    %esi,%esi
801039b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039c0 <cpuid>:
cpuid() {
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
801039c6:	e8 75 ff ff ff       	call   80103940 <mycpu>
801039cb:	2d 20 39 11 80       	sub    $0x80113920,%eax
}
801039d0:	c9                   	leave  
    return mycpu() - cpus;
801039d1:	c1 f8 02             	sar    $0x2,%eax
801039d4:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
801039da:	c3                   	ret    
801039db:	90                   	nop
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039e0 <myproc>:
myproc(void) {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801039e7:	e8 14 19 00 00       	call   80105300 <pushcli>
    c = mycpu();
801039ec:	e8 4f ff ff ff       	call   80103940 <mycpu>
    p = c->proc;
801039f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801039f7:	e8 44 19 00 00       	call   80105340 <popcli>
}
801039fc:	83 c4 04             	add    $0x4,%esp
801039ff:	89 d8                	mov    %ebx,%eax
80103a01:	5b                   	pop    %ebx
80103a02:	5d                   	pop    %ebp
80103a03:	c3                   	ret    
80103a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a10 <mythread>:
mythread(void) {
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	53                   	push   %ebx
80103a14:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103a17:	e8 e4 18 00 00       	call   80105300 <pushcli>
    c = mycpu();
80103a1c:	e8 1f ff ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80103a21:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103a27:	e8 14 19 00 00       	call   80105340 <popcli>
}
80103a2c:	83 c4 04             	add    $0x4,%esp
80103a2f:	89 d8                	mov    %ebx,%eax
80103a31:	5b                   	pop    %ebx
80103a32:	5d                   	pop    %ebp
80103a33:	c3                   	ret    
80103a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a40 <userinit>:
userinit(void) {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103a47:	e8 54 fc ff ff       	call   801036a0 <allocproc>
80103a4c:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103a4e:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
    if ((p->pgdir = setupkvm()) == 0)
80103a53:	e8 28 45 00 00       	call   80107f80 <setupkvm>
80103a58:	85 c0                	test   %eax,%eax
80103a5a:	89 43 04             	mov    %eax,0x4(%ebx)
80103a5d:	0f 84 1d 01 00 00    	je     80103b80 <userinit+0x140>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103a63:	83 ec 04             	sub    $0x4,%esp
80103a66:	68 2c 00 00 00       	push   $0x2c
80103a6b:	68 60 b4 10 80       	push   $0x8010b460
80103a70:	50                   	push   %eax
80103a71:	e8 ea 41 00 00       	call   80107c60 <inituvm>
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
80103a76:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103a79:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
80103a7f:	6a 4c                	push   $0x4c
80103a81:	6a 00                	push   $0x0
80103a83:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103a89:	ff 70 10             	pushl  0x10(%eax)
80103a8c:	e8 5f 1a 00 00       	call   801054f0 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a91:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103a97:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a9c:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103aa1:	83 c4 0c             	add    $0xc,%esp
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aa4:	8b 40 10             	mov    0x10(%eax),%eax
80103aa7:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aab:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103ab1:	8b 40 10             	mov    0x10(%eax),%eax
80103ab4:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
80103ab8:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103abe:	8b 40 10             	mov    0x10(%eax),%eax
80103ac1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ac5:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
80103ac9:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103acf:	8b 40 10             	mov    0x10(%eax),%eax
80103ad2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ad6:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
80103ada:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103ae0:	8b 40 10             	mov    0x10(%eax),%eax
80103ae3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
80103aea:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103af0:	8b 40 10             	mov    0x10(%eax),%eax
80103af3:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
80103afa:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103b00:	8b 40 10             	mov    0x10(%eax),%eax
80103b03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103b0a:	8d 43 64             	lea    0x64(%ebx),%eax
80103b0d:	6a 10                	push   $0x10
80103b0f:	68 ab 87 10 80       	push   $0x801087ab
80103b14:	50                   	push   %eax
80103b15:	e8 b6 1b 00 00       	call   801056d0 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
80103b1a:	83 c4 0c             	add    $0xc,%esp
80103b1d:	6a 10                	push   $0x10
80103b1f:	68 b4 87 10 80       	push   $0x801087b4
80103b24:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103b2a:	83 c0 20             	add    $0x20,%eax
80103b2d:	50                   	push   %eax
80103b2e:	e8 9d 1b 00 00       	call   801056d0 <safestrcpy>
    p->cwd = namei("/");
80103b33:	c7 04 24 bf 87 10 80 	movl   $0x801087bf,(%esp)
80103b3a:	e8 41 e4 ff ff       	call   80101f80 <namei>
80103b3f:	89 43 60             	mov    %eax,0x60(%ebx)
    ptable.lock.name = "INIT";
80103b42:	c7 05 e4 3e 11 80 c1 	movl   $0x801087c1,0x80113ee4
80103b49:	87 10 80 
    acquire(&ptable.lock);
80103b4c:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
80103b53:	e8 78 18 00 00       	call   801053d0 <acquire>
    p->mainThread->state = RUNNABLE;
80103b58:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
    p->state = RUNNABLE;
80103b5e:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103b65:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103b6c:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
80103b73:	e8 28 19 00 00       	call   801054a0 <release>
}
80103b78:	83 c4 10             	add    $0x10,%esp
80103b7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b7e:	c9                   	leave  
80103b7f:	c3                   	ret    
        panic("userinit: out of memory?");
80103b80:	83 ec 0c             	sub    $0xc,%esp
80103b83:	68 92 87 10 80       	push   $0x80108792
80103b88:	e8 03 c8 ff ff       	call   80100390 <panic>
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi

80103b90 <growproc>:
growproc(int n) {
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
80103b95:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103b98:	e8 63 17 00 00       	call   80105300 <pushcli>
    c = mycpu();
80103b9d:	e8 9e fd ff ff       	call   80103940 <mycpu>
    p = c->proc;
80103ba2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ba8:	e8 93 17 00 00       	call   80105340 <popcli>
    if (n > 0) {
80103bad:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103bb0:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103bb2:	7f 34                	jg     80103be8 <growproc+0x58>
    } else if (n < 0) {
80103bb4:	75 52                	jne    80103c08 <growproc+0x78>
    curproc->sz = sz;
80103bb6:	89 03                	mov    %eax,(%ebx)
    pushcli();
80103bb8:	e8 43 17 00 00       	call   80105300 <pushcli>
    c = mycpu();
80103bbd:	e8 7e fd ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80103bc2:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103bc8:	e8 73 17 00 00       	call   80105340 <popcli>
    switchuvm(curproc, mythread());
80103bcd:	83 ec 08             	sub    $0x8,%esp
80103bd0:	56                   	push   %esi
80103bd1:	53                   	push   %ebx
80103bd2:	e8 69 3f 00 00       	call   80107b40 <switchuvm>
    return 0;
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	31 c0                	xor    %eax,%eax
}
80103bdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bdf:	5b                   	pop    %ebx
80103be0:	5e                   	pop    %esi
80103be1:	5d                   	pop    %ebp
80103be2:	c3                   	ret    
80103be3:	90                   	nop
80103be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103be8:	83 ec 04             	sub    $0x4,%esp
80103beb:	01 c6                	add    %eax,%esi
80103bed:	56                   	push   %esi
80103bee:	50                   	push   %eax
80103bef:	ff 73 04             	pushl  0x4(%ebx)
80103bf2:	e8 a9 41 00 00       	call   80107da0 <allocuvm>
80103bf7:	83 c4 10             	add    $0x10,%esp
80103bfa:	85 c0                	test   %eax,%eax
80103bfc:	75 b8                	jne    80103bb6 <growproc+0x26>
            return -1;
80103bfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c03:	eb d7                	jmp    80103bdc <growproc+0x4c>
80103c05:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c08:	83 ec 04             	sub    $0x4,%esp
80103c0b:	01 c6                	add    %eax,%esi
80103c0d:	56                   	push   %esi
80103c0e:	50                   	push   %eax
80103c0f:	ff 73 04             	pushl  0x4(%ebx)
80103c12:	e8 b9 42 00 00       	call   80107ed0 <deallocuvm>
80103c17:	83 c4 10             	add    $0x10,%esp
80103c1a:	85 c0                	test   %eax,%eax
80103c1c:	75 98                	jne    80103bb6 <growproc+0x26>
80103c1e:	eb de                	jmp    80103bfe <growproc+0x6e>

80103c20 <fork>:
fork(void) {
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103c29:	e8 d2 16 00 00       	call   80105300 <pushcli>
    c = mycpu();
80103c2e:	e8 0d fd ff ff       	call   80103940 <mycpu>
    p = c->proc;
80103c33:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103c39:	89 55 e0             	mov    %edx,-0x20(%ebp)
    popcli();
80103c3c:	e8 ff 16 00 00       	call   80105340 <popcli>
    pushcli();
80103c41:	e8 ba 16 00 00       	call   80105300 <pushcli>
    c = mycpu();
80103c46:	e8 f5 fc ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80103c4b:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103c51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103c54:	e8 e7 16 00 00       	call   80105340 <popcli>
    if ((np = allocproc()) == 0) {
80103c59:	e8 42 fa ff ff       	call   801036a0 <allocproc>
80103c5e:	85 c0                	test   %eax,%eax
80103c60:	0f 84 01 01 00 00    	je     80103d67 <fork+0x147>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103c66:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103c69:	83 ec 08             	sub    $0x8,%esp
80103c6c:	89 c3                	mov    %eax,%ebx
80103c6e:	ff 32                	pushl  (%edx)
80103c70:	ff 72 04             	pushl  0x4(%edx)
80103c73:	e8 d8 43 00 00       	call   80108050 <copyuvm>
80103c78:	83 c4 10             	add    $0x10,%esp
80103c7b:	85 c0                	test   %eax,%eax
80103c7d:	89 43 04             	mov    %eax,0x4(%ebx)
80103c80:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103c83:	0f 84 e5 00 00 00    	je     80103d6e <fork+0x14e>
    np->sz = curproc->sz;
80103c89:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103c8b:	89 53 10             	mov    %edx,0x10(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103c8e:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103c93:	89 03                	mov    %eax,(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c98:	8b 70 10             	mov    0x10(%eax),%esi
80103c9b:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103ca1:	8b 40 10             	mov    0x10(%eax),%eax
80103ca4:	89 c7                	mov    %eax,%edi
80103ca6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103ca8:	31 f6                	xor    %esi,%esi
80103caa:	89 d7                	mov    %edx,%edi
    np->mainThread->tf->eax = 0;
80103cac:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103cb2:	8b 40 10             	mov    0x10(%eax),%eax
80103cb5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[i])
80103cc0:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103cc4:	85 c0                	test   %eax,%eax
80103cc6:	74 10                	je     80103cd8 <fork+0xb8>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	50                   	push   %eax
80103ccc:	e8 af d1 ff ff       	call   80100e80 <filedup>
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103cd8:	83 c6 01             	add    $0x1,%esi
80103cdb:	83 fe 10             	cmp    $0x10,%esi
80103cde:	75 e0                	jne    80103cc0 <fork+0xa0>
    np->cwd = idup(curproc->cwd);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	ff 77 60             	pushl  0x60(%edi)
80103ce6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80103ce9:	e8 02 da ff ff       	call   801016f0 <idup>
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cee:	8b 55 e0             	mov    -0x20(%ebp),%edx
    np->cwd = idup(curproc->cwd);
80103cf1:	89 43 60             	mov    %eax,0x60(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf4:	8d 43 64             	lea    0x64(%ebx),%eax
80103cf7:	83 c4 0c             	add    $0xc,%esp
80103cfa:	6a 10                	push   $0x10
80103cfc:	83 c2 64             	add    $0x64,%edx
80103cff:	52                   	push   %edx
80103d00:	50                   	push   %eax
80103d01:	e8 ca 19 00 00       	call   801056d0 <safestrcpy>
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d09:	83 c4 0c             	add    $0xc,%esp
80103d0c:	6a 10                	push   $0x10
80103d0e:	83 c0 20             	add    $0x20,%eax
80103d11:	50                   	push   %eax
80103d12:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103d18:	83 c0 20             	add    $0x20,%eax
80103d1b:	50                   	push   %eax
80103d1c:	e8 af 19 00 00       	call   801056d0 <safestrcpy>
    pid = np->pid;
80103d21:	8b 73 0c             	mov    0xc(%ebx),%esi
    ptable.lock.name = "FORK";
80103d24:	c7 05 e4 3e 11 80 c6 	movl   $0x801087c6,0x80113ee4
80103d2b:	87 10 80 
    acquire(&ptable.lock);
80103d2e:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
80103d35:	e8 96 16 00 00       	call   801053d0 <acquire>
    np->mainThread->state = RUNNABLE;
80103d3a:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
    np->state = RUNNABLE;
80103d40:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    np->mainThread->state = RUNNABLE;
80103d47:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103d4e:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
80103d55:	e8 46 17 00 00       	call   801054a0 <release>
    return pid;
80103d5a:	83 c4 10             	add    $0x10,%esp
}
80103d5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d60:	89 f0                	mov    %esi,%eax
80103d62:	5b                   	pop    %ebx
80103d63:	5e                   	pop    %esi
80103d64:	5f                   	pop    %edi
80103d65:	5d                   	pop    %ebp
80103d66:	c3                   	ret    
        return -1;
80103d67:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103d6c:	eb ef                	jmp    80103d5d <fork+0x13d>
        kfree(np->mainThread->tkstack);
80103d6e:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103d74:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103d77:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->mainThread->tkstack);
80103d7c:	ff 70 04             	pushl  0x4(%eax)
80103d7f:	e8 2c e6 ff ff       	call   801023b0 <kfree>
        np->mainThread->tkstack = 0;
80103d84:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
        return -1;
80103d8a:	83 c4 10             	add    $0x10,%esp
        np->mainThread->tkstack = 0;
80103d8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->mainThread->state = UNUSED;
80103d94:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
        np->state = UNUSED;
80103d9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103da1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103da8:	eb b3                	jmp    80103d5d <fork+0x13d>
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103db0 <scheduler>:
scheduler(void) {
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 1c             	sub    $0x1c,%esp
    struct cpu *c = mycpu();
80103db9:	e8 82 fb ff ff       	call   80103940 <mycpu>
    c->proc = 0;
80103dbe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103dc5:	00 00 00 
    struct cpu *c = mycpu();
80103dc8:	89 c7                	mov    %eax,%edi
80103dca:	8d 40 04             	lea    0x4(%eax),%eax
80103dcd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("sti");
80103dd0:	fb                   	sti    
        acquire(&ptable.lock);
80103dd1:	83 ec 0c             	sub    $0xc,%esp
        ptable.lock.name = "SCHEDUALER";
80103dd4:	c7 05 e4 3e 11 80 cb 	movl   $0x801087cb,0x80113ee4
80103ddb:	87 10 80 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dde:	be 18 3f 11 80       	mov    $0x80113f18,%esi
        acquire(&ptable.lock);
80103de3:	68 e0 3e 11 80       	push   $0x80113ee0
80103de8:	e8 e3 15 00 00       	call   801053d0 <acquire>
80103ded:	83 c4 10             	add    $0x10,%esp
80103df0:	eb 18                	jmp    80103e0a <scheduler+0x5a>
80103df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103df8:	81 c6 7c 12 00 00    	add    $0x127c,%esi
80103dfe:	81 fe 18 de 15 80    	cmp    $0x8015de18,%esi
80103e04:	0f 83 85 00 00 00    	jae    80103e8f <scheduler+0xdf>
            if (p->state != RUNNABLE)
80103e0a:	83 7e 08 03          	cmpl   $0x3,0x8(%esi)
80103e0e:	75 e8                	jne    80103df8 <scheduler+0x48>
80103e10:	8d 5e 74             	lea    0x74(%esi),%ebx
80103e13:	8d 96 74 03 00 00    	lea    0x374(%esi),%edx
            c->proc = p;
80103e19:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
80103e1f:	90                   	nop
                if (t->state != RUNNABLE)
80103e20:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103e24:	75 37                	jne    80103e5d <scheduler+0xad>
                switchuvm(p, t);
80103e26:	83 ec 08             	sub    $0x8,%esp
                t->state = RUNNING;
80103e29:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)
                c->currThread = t;
80103e30:	89 9f b0 00 00 00    	mov    %ebx,0xb0(%edi)
                switchuvm(p, t);
80103e36:	53                   	push   %ebx
80103e37:	56                   	push   %esi
80103e38:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103e3b:	e8 00 3d 00 00       	call   80107b40 <switchuvm>
                swtch(&(c->scheduler), t->context);
80103e40:	58                   	pop    %eax
80103e41:	5a                   	pop    %edx
80103e42:	ff 73 14             	pushl  0x14(%ebx)
80103e45:	ff 75 e0             	pushl  -0x20(%ebp)
80103e48:	e8 de 18 00 00       	call   8010572b <swtch>
                c->currThread = 0;
80103e4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e50:	c7 87 b0 00 00 00 00 	movl   $0x0,0xb0(%edi)
80103e57:	00 00 00 
80103e5a:	83 c4 10             	add    $0x10,%esp
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103e5d:	83 c3 30             	add    $0x30,%ebx
80103e60:	39 da                	cmp    %ebx,%edx
80103e62:	77 bc                	ja     80103e20 <scheduler+0x70>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e64:	81 c6 7c 12 00 00    	add    $0x127c,%esi
            switchkvm();
80103e6a:	e8 b1 3c 00 00       	call   80107b20 <switchkvm>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e6f:	81 fe 18 de 15 80    	cmp    $0x8015de18,%esi
            c->proc = 0;
80103e75:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103e7c:	00 00 00 
            c->currThread = 0;
80103e7f:	c7 87 b0 00 00 00 00 	movl   $0x0,0xb0(%edi)
80103e86:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e89:	0f 82 7b ff ff ff    	jb     80103e0a <scheduler+0x5a>
        release(&ptable.lock);
80103e8f:	83 ec 0c             	sub    $0xc,%esp
80103e92:	68 e0 3e 11 80       	push   $0x80113ee0
80103e97:	e8 04 16 00 00       	call   801054a0 <release>
        sti();
80103e9c:	83 c4 10             	add    $0x10,%esp
80103e9f:	e9 2c ff ff ff       	jmp    80103dd0 <scheduler+0x20>
80103ea4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103eaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103eb0 <sched>:
sched(void) {
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
    pushcli();
80103eb5:	e8 46 14 00 00       	call   80105300 <pushcli>
    c = mycpu();
80103eba:	e8 81 fa ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80103ebf:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103ec5:	e8 76 14 00 00       	call   80105340 <popcli>
    if (!holding(&ptable.lock))
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 e0 3e 11 80       	push   $0x80113ee0
80103ed2:	e8 c9 14 00 00       	call   801053a0 <holding>
80103ed7:	83 c4 10             	add    $0x10,%esp
80103eda:	85 c0                	test   %eax,%eax
80103edc:	74 4f                	je     80103f2d <sched+0x7d>
    if (mycpu()->ncli != 1)
80103ede:	e8 5d fa ff ff       	call   80103940 <mycpu>
80103ee3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eea:	75 68                	jne    80103f54 <sched+0xa4>
    if (t->state == RUNNING)
80103eec:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103ef0:	74 55                	je     80103f47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ef2:	9c                   	pushf  
80103ef3:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103ef4:	f6 c4 02             	test   $0x2,%ah
80103ef7:	75 41                	jne    80103f3a <sched+0x8a>
    intena = mycpu()->intena;
80103ef9:	e8 42 fa ff ff       	call   80103940 <mycpu>
    swtch(&t->context, mycpu()->scheduler);
80103efe:	83 c3 14             	add    $0x14,%ebx
    intena = mycpu()->intena;
80103f01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&t->context, mycpu()->scheduler);
80103f07:	e8 34 fa ff ff       	call   80103940 <mycpu>
80103f0c:	83 ec 08             	sub    $0x8,%esp
80103f0f:	ff 70 04             	pushl  0x4(%eax)
80103f12:	53                   	push   %ebx
80103f13:	e8 13 18 00 00       	call   8010572b <swtch>
    mycpu()->intena = intena;
80103f18:	e8 23 fa ff ff       	call   80103940 <mycpu>
}
80103f1d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80103f20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f29:	5b                   	pop    %ebx
80103f2a:	5e                   	pop    %esi
80103f2b:	5d                   	pop    %ebp
80103f2c:	c3                   	ret    
        panic("sched ptable.lock");
80103f2d:	83 ec 0c             	sub    $0xc,%esp
80103f30:	68 d6 87 10 80       	push   $0x801087d6
80103f35:	e8 56 c4 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 02 88 10 80       	push   $0x80108802
80103f42:	e8 49 c4 ff ff       	call   80100390 <panic>
        panic("sched running");
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 f4 87 10 80       	push   $0x801087f4
80103f4f:	e8 3c c4 ff ff       	call   80100390 <panic>
        panic("sched locks");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 e8 87 10 80       	push   $0x801087e8
80103f5c:	e8 2f c4 ff ff       	call   80100390 <panic>
80103f61:	eb 0d                	jmp    80103f70 <yield>
80103f63:	90                   	nop
80103f64:	90                   	nop
80103f65:	90                   	nop
80103f66:	90                   	nop
80103f67:	90                   	nop
80103f68:	90                   	nop
80103f69:	90                   	nop
80103f6a:	90                   	nop
80103f6b:	90                   	nop
80103f6c:	90                   	nop
80103f6d:	90                   	nop
80103f6e:	90                   	nop
80103f6f:	90                   	nop

80103f70 <yield>:
yield(void) {
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
80103f74:	83 ec 10             	sub    $0x10,%esp
    ptable.lock.name = "YIELD";
80103f77:	c7 05 e4 3e 11 80 16 	movl   $0x80108816,0x80113ee4
80103f7e:	88 10 80 
    acquire(&ptable.lock);
80103f81:	68 e0 3e 11 80       	push   $0x80113ee0
80103f86:	e8 45 14 00 00       	call   801053d0 <acquire>
    pushcli();
80103f8b:	e8 70 13 00 00       	call   80105300 <pushcli>
    c = mycpu();
80103f90:	e8 ab f9 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80103f95:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103f9b:	e8 a0 13 00 00       	call   80105340 <popcli>
    mythread()->state = RUNNABLE;
80103fa0:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103fa7:	e8 04 ff ff ff       	call   80103eb0 <sched>
    release(&ptable.lock);
80103fac:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
80103fb3:	e8 e8 14 00 00       	call   801054a0 <release>
}
80103fb8:	83 c4 10             	add    $0x10,%esp
80103fbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fbe:	c9                   	leave  
80103fbf:	c3                   	ret    

80103fc0 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	53                   	push   %ebx
80103fc4:	83 ec 10             	sub    $0x10,%esp
    if (DEBUGMODE > 1)
        cprintf(" WAKEUP ");
    char *aa = ptable.lock.name;
80103fc7:	a1 e4 3e 11 80       	mov    0x80113ee4,%eax
wakeup(void *chan) {
80103fcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    ptable.lock.name = "WAKEUP"; //used for debugging
    ptable.lock.namee = aa;
    acquire(&ptable.lock);
80103fcf:	68 e0 3e 11 80       	push   $0x80113ee0
    ptable.lock.name = "WAKEUP"; //used for debugging
80103fd4:	c7 05 e4 3e 11 80 1c 	movl   $0x8010881c,0x80113ee4
80103fdb:	88 10 80 
    ptable.lock.namee = aa;
80103fde:	a3 e8 3e 11 80       	mov    %eax,0x80113ee8
    acquire(&ptable.lock);
80103fe3:	e8 e8 13 00 00       	call   801053d0 <acquire>
80103fe8:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103feb:	ba 18 3f 11 80       	mov    $0x80113f18,%edx
80103ff0:	eb 14                	jmp    80104006 <wakeup+0x46>
80103ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ff8:	81 c2 7c 12 00 00    	add    $0x127c,%edx
80103ffe:	81 fa 18 de 15 80    	cmp    $0x8015de18,%edx
80104004:	73 35                	jae    8010403b <wakeup+0x7b>
        if (p->state != RUNNABLE)
80104006:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
8010400a:	75 ec                	jne    80103ff8 <wakeup+0x38>
8010400c:	8d 42 74             	lea    0x74(%edx),%eax
8010400f:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
80104015:	eb 10                	jmp    80104027 <wakeup+0x67>
80104017:	89 f6                	mov    %esi,%esi
80104019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104020:	83 c0 30             	add    $0x30,%eax
80104023:	39 c1                	cmp    %eax,%ecx
80104025:	76 d1                	jbe    80103ff8 <wakeup+0x38>
            if (t->state == SLEEPING && t->chan == chan)
80104027:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010402b:	75 f3                	jne    80104020 <wakeup+0x60>
8010402d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104030:	75 ee                	jne    80104020 <wakeup+0x60>
                t->state = RUNNABLE;
80104032:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104039:	eb e5                	jmp    80104020 <wakeup+0x60>
    wakeup1(chan);
    release(&ptable.lock);
8010403b:	c7 45 08 e0 3e 11 80 	movl   $0x80113ee0,0x8(%ebp)
}
80104042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104045:	c9                   	leave  
    release(&ptable.lock);
80104046:	e9 55 14 00 00       	jmp    801054a0 <release>
8010404b:	90                   	nop
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104050 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 10             	sub    $0x10,%esp
    if (DEBUGMODE > 0)
        cprintf(" KILL ");
    struct proc *p;

    ptable.lock.name = "KILL";
80104057:	c7 05 e4 3e 11 80 23 	movl   $0x80108823,0x80113ee4
8010405e:	88 10 80 
kill(int pid) {
80104061:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80104064:	68 e0 3e 11 80       	push   $0x80113ee0
80104069:	e8 62 13 00 00       	call   801053d0 <acquire>
8010406e:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104071:	b8 18 3f 11 80       	mov    $0x80113f18,%eax
80104076:	eb 14                	jmp    8010408c <kill+0x3c>
80104078:	90                   	nop
80104079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104080:	05 7c 12 00 00       	add    $0x127c,%eax
80104085:	3d 18 de 15 80       	cmp    $0x8015de18,%eax
8010408a:	73 4c                	jae    801040d8 <kill+0x88>
        if (p->pid == pid) {
8010408c:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010408f:	75 ef                	jne    80104080 <kill+0x30>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING) {
80104091:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
            p->killed = 1;
80104095:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
            if (p->state == SLEEPING) {
8010409c:	74 1a                	je     801040b8 <kill+0x68>
                p->state = RUNNABLE;
                if (p->mainThread->state == SLEEPING)
                    p->mainThread->state = RUNNABLE;
            }
            release(&ptable.lock);
8010409e:	83 ec 0c             	sub    $0xc,%esp
801040a1:	68 e0 3e 11 80       	push   $0x80113ee0
801040a6:	e8 f5 13 00 00       	call   801054a0 <release>
            return 0;
801040ab:	83 c4 10             	add    $0x10,%esp
801040ae:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801040b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b3:	c9                   	leave  
801040b4:	c3                   	ret    
801040b5:	8d 76 00             	lea    0x0(%esi),%esi
                p->state = RUNNABLE;
801040b8:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
                if (p->mainThread->state == SLEEPING)
801040bf:	8b 80 74 03 00 00    	mov    0x374(%eax),%eax
801040c5:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801040c9:	75 d3                	jne    8010409e <kill+0x4e>
                    p->mainThread->state = RUNNABLE;
801040cb:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801040d2:	eb ca                	jmp    8010409e <kill+0x4e>
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801040d8:	83 ec 0c             	sub    $0xc,%esp
801040db:	68 e0 3e 11 80       	push   $0x80113ee0
801040e0:	e8 bb 13 00 00       	call   801054a0 <release>
    return -1;
801040e5:	83 c4 10             	add    $0x10,%esp
801040e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f0:	c9                   	leave  
801040f1:	c3                   	ret    
801040f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104100 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104109:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx
procdump(void) {
8010410e:	83 ec 3c             	sub    $0x3c,%esp
80104111:	eb 27                	jmp    8010413a <procdump+0x3a>
80104113:	90                   	nop
80104114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104118:	83 ec 0c             	sub    $0xc,%esp
8010411b:	68 3b 8c 10 80       	push   $0x80108c3b
80104120:	e8 3b c5 ff ff       	call   80100660 <cprintf>
80104125:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104128:	81 c3 7c 12 00 00    	add    $0x127c,%ebx
8010412e:	81 fb 18 de 15 80    	cmp    $0x8015de18,%ebx
80104134:	0f 83 96 00 00 00    	jae    801041d0 <procdump+0xd0>
        if (p->state == UNUSED)
8010413a:	8b 43 08             	mov    0x8(%ebx),%eax
8010413d:	85 c0                	test   %eax,%eax
8010413f:	74 e7                	je     80104128 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104141:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104144:	ba 28 88 10 80       	mov    $0x80108828,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104149:	77 11                	ja     8010415c <procdump+0x5c>
8010414b:	8b 14 85 f8 88 10 80 	mov    -0x7fef7708(,%eax,4),%edx
            state = "???";
80104152:	b8 28 88 10 80       	mov    $0x80108828,%eax
80104157:	85 d2                	test   %edx,%edx
80104159:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010415c:	8d 43 64             	lea    0x64(%ebx),%eax
8010415f:	50                   	push   %eax
80104160:	52                   	push   %edx
80104161:	ff 73 0c             	pushl  0xc(%ebx)
80104164:	68 2c 88 10 80       	push   $0x8010882c
80104169:	e8 f2 c4 ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
8010416e:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80104174:	83 c4 10             	add    $0x10,%esp
80104177:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010417b:	75 9b                	jne    80104118 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
8010417d:	8d 4d c0             	lea    -0x40(%ebp),%ecx
80104180:	83 ec 08             	sub    $0x8,%esp
80104183:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104186:	51                   	push   %ecx
80104187:	8b 40 14             	mov    0x14(%eax),%eax
8010418a:	8b 40 0c             	mov    0xc(%eax),%eax
8010418d:	83 c0 08             	add    $0x8,%eax
80104190:	50                   	push   %eax
80104191:	e8 1a 11 00 00       	call   801052b0 <getcallerpcs>
80104196:	83 c4 10             	add    $0x10,%esp
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801041a0:	8b 17                	mov    (%edi),%edx
801041a2:	85 d2                	test   %edx,%edx
801041a4:	0f 84 6e ff ff ff    	je     80104118 <procdump+0x18>
                cprintf(" %p", pc[i]);
801041aa:	83 ec 08             	sub    $0x8,%esp
801041ad:	83 c7 04             	add    $0x4,%edi
801041b0:	52                   	push   %edx
801041b1:	68 61 82 10 80       	push   $0x80108261
801041b6:	e8 a5 c4 ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	39 fe                	cmp    %edi,%esi
801041c0:	75 de                	jne    801041a0 <procdump+0xa0>
801041c2:	e9 51 ff ff ff       	jmp    80104118 <procdump+0x18>
801041c7:	89 f6                	mov    %esi,%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
}
801041d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041d3:	5b                   	pop    %ebx
801041d4:	5e                   	pop    %esi
801041d5:	5f                   	pop    %edi
801041d6:	5d                   	pop    %ebp
801041d7:	c3                   	ret    
801041d8:	90                   	nop
801041d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041e0 <kthread_create>:

/********************************
        kthread
 ********************************/

int kthread_create(void (*start_func)(), void *stack) {
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
801041e9:	e8 12 11 00 00       	call   80105300 <pushcli>
    c = mycpu();
801041ee:	e8 4d f7 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
801041f3:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
801041f9:	e8 42 11 00 00       	call   80105340 <popcli>
    pushcli();
801041fe:	e8 fd 10 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104203:	e8 38 f7 ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104208:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010420e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80104211:	e8 2a 11 00 00       	call   80105340 <popcli>
    struct proc *p = myproc();
    char *sp;
    int i;

    ptable.lock.name = "KTHREADCREATE";
    acquire(&ptable.lock); //find UNUSED thread in curproc
80104216:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "KTHREADCREATE";
80104219:	c7 05 e4 3e 11 80 35 	movl   $0x80108835,0x80113ee4
80104220:	88 10 80 
    acquire(&ptable.lock); //find UNUSED thread in curproc
80104223:	68 e0 3e 11 80       	push   $0x80113ee0
80104228:	e8 a3 11 00 00       	call   801053d0 <acquire>
    for (t = p->thread, i = 0; t < &p->thread[NTHREADS]; i++, t++) {
8010422d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104230:	83 c4 10             	add    $0x10,%esp
80104233:	8d 5a 74             	lea    0x74(%edx),%ebx
80104236:	8d ba 74 03 00 00    	lea    0x374(%edx),%edi
8010423c:	eb 11                	jmp    8010424f <kthread_create+0x6f>
8010423e:	66 90                	xchg   %ax,%ax
        if( t->state == ZOMBIE && t->tkilled && t != p->mainThread && t != curthread ) {
            cleanThread(t);
        }
        if (t->state == UNUSED) {
80104240:	85 c0                	test   %eax,%eax
80104242:	74 44                	je     80104288 <kthread_create+0xa8>
    for (t = p->thread, i = 0; t < &p->thread[NTHREADS]; i++, t++) {
80104244:	83 c3 30             	add    $0x30,%ebx
80104247:	39 fb                	cmp    %edi,%ebx
80104249:	0f 83 38 02 00 00    	jae    80104487 <kthread_create+0x2a7>
        if( t->state == ZOMBIE && t->tkilled && t != p->mainThread && t != curthread ) {
8010424f:	8b 43 08             	mov    0x8(%ebx),%eax
80104252:	83 f8 05             	cmp    $0x5,%eax
80104255:	75 e9                	jne    80104240 <kthread_create+0x60>
80104257:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010425a:	85 c0                	test   %eax,%eax
8010425c:	74 e6                	je     80104244 <kthread_create+0x64>
8010425e:	39 9a 74 03 00 00    	cmp    %ebx,0x374(%edx)
80104264:	74 de                	je     80104244 <kthread_create+0x64>
80104266:	39 de                	cmp    %ebx,%esi
80104268:	74 da                	je     80104244 <kthread_create+0x64>
            cleanThread(t);
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104270:	53                   	push   %ebx
80104271:	e8 5a f6 ff ff       	call   801038d0 <cleanThread>
80104276:	8b 43 08             	mov    0x8(%ebx),%eax
80104279:	83 c4 10             	add    $0x10,%esp
8010427c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        if (t->state == UNUSED) {
8010427f:	85 c0                	test   %eax,%eax
80104281:	75 c1                	jne    80104244 <kthread_create+0x64>
80104283:	90                   	nop
80104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
    t->tid = tidCounter++;
80104288:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    t->state = EMBRYO;
8010428d:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    t->tkilled = 0;
80104294:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    t->tid = tidCounter++;
8010429b:	8d 50 01             	lea    0x1(%eax),%edx
8010429e:	89 43 0c             	mov    %eax,0xc(%ebx)
801042a1:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
801042a7:	e8 b4 e2 ff ff       	call   80102560 <kalloc>
801042ac:	85 c0                	test   %eax,%eax
801042ae:	89 43 04             	mov    %eax,0x4(%ebx)
801042b1:	0f 84 c9 01 00 00    	je     80104480 <kthread_create+0x2a0>
        return -1;
    }
    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
801042b7:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
801042bd:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
801042c0:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
801042c5:	89 53 10             	mov    %edx,0x10(%ebx)
    *(uint *) sp = (uint) trapret;
801042c8:	c7 40 14 bf 68 10 80 	movl   $0x801068bf,0x14(%eax)
    t->context = (struct context *) sp;
801042cf:	89 43 14             	mov    %eax,0x14(%ebx)
    memset(t->context, 0, sizeof *t->context);
801042d2:	6a 14                	push   $0x14
801042d4:	6a 00                	push   $0x0
801042d6:	50                   	push   %eax
801042d7:	e8 14 12 00 00       	call   801054f0 <memset>
    t->context->eip = (uint) forkret;
801042dc:	8b 43 14             	mov    0x14(%ebx),%eax
    //copy trapframe from the current thread (like fork)
    memset(t->tf, 0, sizeof(*t->tf));
801042df:	83 c4 0c             	add    $0xc,%esp
    t->context->eip = (uint) forkret;
801042e2:	c7 40 10 20 38 10 80 	movl   $0x80103820,0x10(%eax)
    memset(t->tf, 0, sizeof(*t->tf));
801042e9:	6a 4c                	push   $0x4c
801042eb:	6a 00                	push   $0x0
801042ed:	ff 73 10             	pushl  0x10(%ebx)
801042f0:	e8 fb 11 00 00       	call   801054f0 <memset>
    //copy all fields except eip, esp
    t->tf->gs = curthread->tf->gs;
801042f5:	8b 56 10             	mov    0x10(%esi),%edx
801042f8:	8b 43 10             	mov    0x10(%ebx),%eax
801042fb:	0f b7 52 20          	movzwl 0x20(%edx),%edx
801042ff:	66 89 50 20          	mov    %dx,0x20(%eax)
    t->tf->fs = curthread->tf->fs;
80104303:	8b 56 10             	mov    0x10(%esi),%edx
80104306:	8b 43 10             	mov    0x10(%ebx),%eax
80104309:	0f b7 52 24          	movzwl 0x24(%edx),%edx
8010430d:	66 89 50 24          	mov    %dx,0x24(%eax)
    t->tf->ss = curthread->tf->ss;
80104311:	8b 56 10             	mov    0x10(%esi),%edx
80104314:	8b 43 10             	mov    0x10(%ebx),%eax
80104317:	0f b7 52 48          	movzwl 0x48(%edx),%edx
8010431b:	66 89 50 48          	mov    %dx,0x48(%eax)
    t->tf->trapno = curthread->tf->trapno;
8010431f:	8b 56 10             	mov    0x10(%esi),%edx
80104322:	8b 43 10             	mov    0x10(%ebx),%eax
80104325:	8b 52 30             	mov    0x30(%edx),%edx
80104328:	89 50 30             	mov    %edx,0x30(%eax)
    t->tf->err = curthread->tf->err;
8010432b:	8b 56 10             	mov    0x10(%esi),%edx
8010432e:	8b 43 10             	mov    0x10(%ebx),%eax
80104331:	8b 52 34             	mov    0x34(%edx),%edx
80104334:	89 50 34             	mov    %edx,0x34(%eax)
    t->tf->eflags = curthread->tf->eflags;
80104337:	8b 56 10             	mov    0x10(%esi),%edx
8010433a:	8b 43 10             	mov    0x10(%ebx),%eax
8010433d:	8b 52 40             	mov    0x40(%edx),%edx
80104340:	89 50 40             	mov    %edx,0x40(%eax)
    t->tf->edx = curthread->tf->edx;
80104343:	8b 56 10             	mov    0x10(%esi),%edx
80104346:	8b 43 10             	mov    0x10(%ebx),%eax
80104349:	8b 52 14             	mov    0x14(%edx),%edx
8010434c:	89 50 14             	mov    %edx,0x14(%eax)
    t->tf->edi = curthread->tf->edi;
8010434f:	8b 56 10             	mov    0x10(%esi),%edx
80104352:	8b 43 10             	mov    0x10(%ebx),%eax
80104355:	8b 12                	mov    (%edx),%edx
80104357:	89 10                	mov    %edx,(%eax)
    t->tf->ebx = curthread->tf->ebx;
80104359:	8b 43 10             	mov    0x10(%ebx),%eax
8010435c:	8b 56 10             	mov    0x10(%esi),%edx
8010435f:	8b 52 10             	mov    0x10(%edx),%edx
80104362:	89 50 10             	mov    %edx,0x10(%eax)
    t->tf->ecx = curthread->tf->ecx;
80104365:	8b 56 10             	mov    0x10(%esi),%edx
80104368:	8b 43 10             	mov    0x10(%ebx),%eax
8010436b:	8b 52 18             	mov    0x18(%edx),%edx
8010436e:	89 50 18             	mov    %edx,0x18(%eax)
    t->tf->ebp = curthread->tf->ebp;
80104371:	8b 56 10             	mov    0x10(%esi),%edx
80104374:	8b 43 10             	mov    0x10(%ebx),%eax
80104377:	8b 52 08             	mov    0x8(%edx),%edx
8010437a:	89 50 08             	mov    %edx,0x8(%eax)
    t->tf->eax = curthread->tf->eax;
8010437d:	8b 56 10             	mov    0x10(%esi),%edx
80104380:	8b 43 10             	mov    0x10(%ebx),%eax
80104383:	8b 52 1c             	mov    0x1c(%edx),%edx
80104386:	89 50 1c             	mov    %edx,0x1c(%eax)
    t->tf->ds = curthread->tf->ds;
80104389:	8b 56 10             	mov    0x10(%esi),%edx
8010438c:	8b 43 10             	mov    0x10(%ebx),%eax
8010438f:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104393:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    t->tf->cs = curthread->tf->cs;
80104397:	8b 56 10             	mov    0x10(%esi),%edx
8010439a:	8b 43 10             	mov    0x10(%ebx),%eax
8010439d:	0f b7 52 3c          	movzwl 0x3c(%edx),%edx
801043a1:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    t->tf->es = curthread->tf->es;
801043a5:	8b 56 10             	mov    0x10(%esi),%edx
801043a8:	8b 43 10             	mov    0x10(%ebx),%eax
801043ab:	0f b7 52 28          	movzwl 0x28(%edx),%edx
801043af:	66 89 50 28          	mov    %dx,0x28(%eax)
    t->tf->esi = curthread->tf->esi;
801043b3:	8b 56 10             	mov    0x10(%esi),%edx
801043b6:	8b 43 10             	mov    0x10(%ebx),%eax
801043b9:	8b 52 04             	mov    0x4(%edx),%edx
801043bc:	89 50 04             	mov    %edx,0x4(%eax)
    t->tf->oesp = curthread->tf->oesp;
801043bf:	8b 43 10             	mov    0x10(%ebx),%eax
801043c2:	8b 56 10             	mov    0x10(%esi),%edx
801043c5:	8b 52 0c             	mov    0xc(%edx),%edx
801043c8:	89 50 0c             	mov    %edx,0xc(%eax)
    t->tf->padding1 = curthread->tf->padding1;
801043cb:	8b 56 10             	mov    0x10(%esi),%edx
801043ce:	8b 43 10             	mov    0x10(%ebx),%eax
801043d1:	0f b7 52 22          	movzwl 0x22(%edx),%edx
801043d5:	66 89 50 22          	mov    %dx,0x22(%eax)
    t->tf->padding2 = curthread->tf->padding2;
801043d9:	8b 56 10             	mov    0x10(%esi),%edx
801043dc:	8b 43 10             	mov    0x10(%ebx),%eax
801043df:	0f b7 52 26          	movzwl 0x26(%edx),%edx
801043e3:	66 89 50 26          	mov    %dx,0x26(%eax)
    t->tf->padding3 = curthread->tf->padding3;
801043e7:	8b 56 10             	mov    0x10(%esi),%edx
801043ea:	8b 43 10             	mov    0x10(%ebx),%eax
801043ed:	0f b7 52 2a          	movzwl 0x2a(%edx),%edx
801043f1:	66 89 50 2a          	mov    %dx,0x2a(%eax)
    t->tf->padding4 = curthread->tf->padding4;
801043f5:	8b 56 10             	mov    0x10(%esi),%edx
801043f8:	8b 43 10             	mov    0x10(%ebx),%eax
801043fb:	0f b7 52 2e          	movzwl 0x2e(%edx),%edx
801043ff:	66 89 50 2e          	mov    %dx,0x2e(%eax)
    t->tf->padding5 = curthread->tf->padding5;
80104403:	8b 56 10             	mov    0x10(%esi),%edx
80104406:	8b 43 10             	mov    0x10(%ebx),%eax
80104409:	0f b7 52 3e          	movzwl 0x3e(%edx),%edx
8010440d:	66 89 50 3e          	mov    %dx,0x3e(%eax)
    t->tf->padding6 = curthread->tf->padding6;
80104411:	8b 56 10             	mov    0x10(%esi),%edx
80104414:	8b 43 10             	mov    0x10(%ebx),%eax
80104417:	0f b7 52 4a          	movzwl 0x4a(%edx),%edx
8010441b:	66 89 50 4a          	mov    %dx,0x4a(%eax)

    t->tf->eip = (uint) start_func;  // beginning of run func
8010441f:	8b 55 08             	mov    0x8(%ebp),%edx
80104422:	8b 43 10             	mov    0x10(%ebx),%eax
80104425:	89 50 38             	mov    %edx,0x38(%eax)
    t->tf->esp = (uint) stack; //beginning of user stack
80104428:	8b 43 10             	mov    0x10(%ebx),%eax
8010442b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010442e:	89 50 44             	mov    %edx,0x44(%eax)
    pushcli();
80104431:	e8 ca 0e 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104436:	e8 05 f5 ff ff       	call   80103940 <mycpu>
    p = c->proc;
8010443b:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104441:	e8 fa 0e 00 00       	call   80105340 <popcli>

    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
80104446:	8d 43 20             	lea    0x20(%ebx),%eax
80104449:	83 c4 0c             	add    $0xc,%esp
8010444c:	83 c6 64             	add    $0x64,%esi
8010444f:	6a 10                	push   $0x10
80104451:	56                   	push   %esi
80104452:	50                   	push   %eax
80104453:	e8 78 12 00 00       	call   801056d0 <safestrcpy>
    t->chan = 0;
80104458:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    t->state = RUNNABLE;
8010445f:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)

    release(&ptable.lock);
80104466:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
8010446d:	e8 2e 10 00 00       	call   801054a0 <release>
    return t->tid;
80104472:	8b 43 0c             	mov    0xc(%ebx),%eax
80104475:	83 c4 10             	add    $0x10,%esp
}
80104478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447b:	5b                   	pop    %ebx
8010447c:	5e                   	pop    %esi
8010447d:	5f                   	pop    %edi
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    
        t->state = UNUSED;
80104480:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        release(&ptable.lock);
80104487:	83 ec 0c             	sub    $0xc,%esp
8010448a:	68 e0 3e 11 80       	push   $0x80113ee0
8010448f:	e8 0c 10 00 00       	call   801054a0 <release>
        return -1;
80104494:	83 c4 10             	add    $0x10,%esp
}
80104497:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010449a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010449f:	5b                   	pop    %ebx
801044a0:	5e                   	pop    %esi
801044a1:	5f                   	pop    %edi
801044a2:	5d                   	pop    %ebp
801044a3:	c3                   	ret    
801044a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801044b0 <kthread_id>:

int kthread_id() {
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801044b7:	e8 44 0e 00 00       	call   80105300 <pushcli>
    c = mycpu();
801044bc:	e8 7f f4 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
801044c1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801044c7:	e8 74 0e 00 00       	call   80105340 <popcli>
    if (DEBUGMODE > 0)
        cprintf(" KTHREAD_ID ");
    return mythread()->tid;
801044cc:	8b 43 0c             	mov    0xc(%ebx),%eax
}
801044cf:	83 c4 04             	add    $0x4,%esp
801044d2:	5b                   	pop    %ebx
801044d3:	5d                   	pop    %ebp
801044d4:	c3                   	ret    
801044d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <kthread_exit>:


void kthread_exit() {
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	53                   	push   %ebx
801044e6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
801044e9:	e8 12 0e 00 00       	call   80105300 <pushcli>
    c = mycpu();
801044ee:	e8 4d f4 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
801044f3:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801044f9:	e8 42 0e 00 00       	call   80105340 <popcli>
    pushcli();
801044fe:	e8 fd 0d 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104503:	e8 38 f4 ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104508:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
8010450e:	e8 2d 0e 00 00       	call   80105340 <popcli>
        cprintf(" KTHREAD_EXIT ");
    struct thread *t, *t1;
    struct thread *curthread = mythread();
    struct proc *p = myproc();
    ptable.lock.name = "KTHREADEXIT";
    acquire(&ptable.lock);
80104513:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "KTHREADEXIT";
80104516:	c7 05 e4 3e 11 80 43 	movl   $0x80108843,0x80113ee4
8010451d:	88 10 80 
    acquire(&ptable.lock);
80104520:	68 e0 3e 11 80       	push   $0x80113ee0
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104525:	8d be 74 03 00 00    	lea    0x374(%esi),%edi
    acquire(&ptable.lock);
8010452b:	e8 a0 0e 00 00       	call   801053d0 <acquire>
        if (t->state != UNUSED && t->state != ZOMBIE && t != curthread) {
80104530:	8b 46 7c             	mov    0x7c(%esi),%eax
80104533:	83 c4 10             	add    $0x10,%esp
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104536:	8d 4e 74             	lea    0x74(%esi),%ecx
80104539:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        if (t->state != UNUSED && t->state != ZOMBIE && t != curthread) {
8010453c:	83 f8 05             	cmp    $0x5,%eax
8010453f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104542:	0f 95 c2             	setne  %dl
80104545:	85 c0                	test   %eax,%eax
80104547:	0f 95 c0             	setne  %al
8010454a:	84 c2                	test   %al,%dl
8010454c:	74 04                	je     80104552 <kthread_exit+0x72>
8010454e:	39 d9                	cmp    %ebx,%ecx
80104550:	75 23                	jne    80104575 <kthread_exit+0x95>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104555:	8d 76 00             	lea    0x0(%esi),%esi
80104558:	83 c0 30             	add    $0x30,%eax
8010455b:	39 f8                	cmp    %edi,%eax
8010455d:	73 71                	jae    801045d0 <kthread_exit+0xf0>
        if (t->state != UNUSED && t->state != ZOMBIE && t != curthread) {
8010455f:	8b 50 08             	mov    0x8(%eax),%edx
80104562:	85 d2                	test   %edx,%edx
80104564:	0f 95 c1             	setne  %cl
80104567:	83 fa 05             	cmp    $0x5,%edx
8010456a:	0f 95 c2             	setne  %dl
8010456d:	84 d1                	test   %dl,%cl
8010456f:	74 e7                	je     80104558 <kthread_exit+0x78>
80104571:	39 d8                	cmp    %ebx,%eax
80104573:	74 e3                	je     80104558 <kthread_exit+0x78>
            //found other thread ->close mythread
            if (curthread == p->mainThread) { //if (curthread == p->mainThread) -> set new mainThread
80104575:	39 9e 74 03 00 00    	cmp    %ebx,0x374(%esi)
8010457b:	0f 84 2e 01 00 00    	je     801046af <kthread_exit+0x1cf>
void kthread_exit() {
80104581:	ba 18 3f 11 80       	mov    $0x80113f18,%edx
80104586:	eb 16                	jmp    8010459e <kthread_exit+0xbe>
80104588:	90                   	nop
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104590:	81 c2 7c 12 00 00    	add    $0x127c,%edx
80104596:	81 fa 18 de 15 80    	cmp    $0x8015de18,%edx
8010459c:	73 4e                	jae    801045ec <kthread_exit+0x10c>
        if (p->state != RUNNABLE)
8010459e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801045a2:	75 ec                	jne    80104590 <kthread_exit+0xb0>
801045a4:	8d 42 74             	lea    0x74(%edx),%eax
801045a7:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
801045ad:	eb 08                	jmp    801045b7 <kthread_exit+0xd7>
801045af:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801045b0:	83 c0 30             	add    $0x30,%eax
801045b3:	39 c8                	cmp    %ecx,%eax
801045b5:	73 d9                	jae    80104590 <kthread_exit+0xb0>
            if (t->state == SLEEPING && t->chan == chan)
801045b7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801045bb:	75 f3                	jne    801045b0 <kthread_exit+0xd0>
801045bd:	3b 58 18             	cmp    0x18(%eax),%ebx
801045c0:	75 ee                	jne    801045b0 <kthread_exit+0xd0>
                t->state = RUNNABLE;
801045c2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801045c9:	eb e5                	jmp    801045b0 <kthread_exit+0xd0>
801045cb:	90                   	nop
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            release(&ptable.lock);
            return;
        }
    }
    //if got here- curThread is the only thread ->exit
    release(&ptable.lock);
801045d0:	83 ec 0c             	sub    $0xc,%esp
801045d3:	68 e0 3e 11 80       	push   $0x80113ee0
801045d8:	e8 c3 0e 00 00       	call   801054a0 <release>
    exit();
801045dd:	83 c4 10             	add    $0x10,%esp
}
801045e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045e3:	5b                   	pop    %ebx
801045e4:	5e                   	pop    %esi
801045e5:	5f                   	pop    %edi
801045e6:	5d                   	pop    %ebp
    exit();
801045e7:	e9 24 03 00 00       	jmp    80104910 <exit>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045ec:	ba 18 3f 11 80       	mov    $0x80113f18,%edx
801045f1:	eb 13                	jmp    80104606 <kthread_exit+0x126>
801045f3:	90                   	nop
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f8:	81 c2 7c 12 00 00    	add    $0x127c,%edx
801045fe:	81 fa 18 de 15 80    	cmp    $0x8015de18,%edx
80104604:	73 35                	jae    8010463b <kthread_exit+0x15b>
        if (p->state != RUNNABLE)
80104606:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
8010460a:	75 ec                	jne    801045f8 <kthread_exit+0x118>
8010460c:	8d 42 74             	lea    0x74(%edx),%eax
8010460f:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
80104615:	eb 10                	jmp    80104627 <kthread_exit+0x147>
80104617:	89 f6                	mov    %esi,%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104620:	83 c0 30             	add    $0x30,%eax
80104623:	39 c1                	cmp    %eax,%ecx
80104625:	76 d1                	jbe    801045f8 <kthread_exit+0x118>
            if (t->state == SLEEPING && t->chan == chan)
80104627:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010462b:	75 f3                	jne    80104620 <kthread_exit+0x140>
8010462d:	3b 70 18             	cmp    0x18(%eax),%esi
80104630:	75 ee                	jne    80104620 <kthread_exit+0x140>
                t->state = RUNNABLE;
80104632:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104639:	eb e5                	jmp    80104620 <kthread_exit+0x140>
            wakeup1(p->parent);
8010463b:	8b 76 10             	mov    0x10(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010463e:	ba 18 3f 11 80       	mov    $0x80113f18,%edx
80104643:	eb 11                	jmp    80104656 <kthread_exit+0x176>
80104645:	8d 76 00             	lea    0x0(%esi),%esi
80104648:	81 c2 7c 12 00 00    	add    $0x127c,%edx
8010464e:	81 fa 18 de 15 80    	cmp    $0x8015de18,%edx
80104654:	73 35                	jae    8010468b <kthread_exit+0x1ab>
        if (p->state != RUNNABLE)
80104656:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
8010465a:	75 ec                	jne    80104648 <kthread_exit+0x168>
8010465c:	8d 42 74             	lea    0x74(%edx),%eax
8010465f:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
80104665:	eb 10                	jmp    80104677 <kthread_exit+0x197>
80104667:	89 f6                	mov    %esi,%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104670:	83 c0 30             	add    $0x30,%eax
80104673:	39 c8                	cmp    %ecx,%eax
80104675:	73 d1                	jae    80104648 <kthread_exit+0x168>
            if (t->state == SLEEPING && t->chan == chan)
80104677:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010467b:	75 f3                	jne    80104670 <kthread_exit+0x190>
8010467d:	3b 70 18             	cmp    0x18(%eax),%esi
80104680:	75 ee                	jne    80104670 <kthread_exit+0x190>
                t->state = RUNNABLE;
80104682:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104689:	eb e5                	jmp    80104670 <kthread_exit+0x190>
            curthread->state = ZOMBIE;
8010468b:	c7 43 08 05 00 00 00 	movl   $0x5,0x8(%ebx)
            sched(); //need to call this func while holding ptable.lock
80104692:	e8 19 f8 ff ff       	call   80103eb0 <sched>
            release(&ptable.lock);
80104697:	83 ec 0c             	sub    $0xc,%esp
8010469a:	68 e0 3e 11 80       	push   $0x80113ee0
8010469f:	e8 fc 0d 00 00       	call   801054a0 <release>
            return;
801046a4:	83 c4 10             	add    $0x10,%esp
}
801046a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046aa:	5b                   	pop    %ebx
801046ab:	5e                   	pop    %esi
801046ac:	5f                   	pop    %edi
801046ad:	5d                   	pop    %ebp
801046ae:	c3                   	ret    
801046af:	8b 55 e0             	mov    -0x20(%ebp),%edx
801046b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046b5:	eb 0c                	jmp    801046c3 <kthread_exit+0x1e3>
801046b7:	89 f6                	mov    %esi,%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801046c0:	8b 50 08             	mov    0x8(%eax),%edx
                    if (t1->state == RUNNABLE && t1 != curthread)
801046c3:	39 c3                	cmp    %eax,%ebx
801046c5:	74 0b                	je     801046d2 <kthread_exit+0x1f2>
801046c7:	83 fa 03             	cmp    $0x3,%edx
801046ca:	75 06                	jne    801046d2 <kthread_exit+0x1f2>
                        p->mainThread = t1;
801046cc:	89 86 74 03 00 00    	mov    %eax,0x374(%esi)
                for (t1 = p->thread; t1 < &p->thread[NTHREADS]; t1++) {
801046d2:	83 c0 30             	add    $0x30,%eax
801046d5:	39 f8                	cmp    %edi,%eax
801046d7:	72 e7                	jb     801046c0 <kthread_exit+0x1e0>
801046d9:	e9 a3 fe ff ff       	jmp    80104581 <kthread_exit+0xa1>
801046de:	66 90                	xchg   %ax,%ax

801046e0 <sleep>:
sleep(void *chan, struct spinlock *lk) {
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	56                   	push   %esi
801046e5:	53                   	push   %ebx
801046e6:	83 ec 1c             	sub    $0x1c,%esp
801046e9:	8b 45 08             	mov    0x8(%ebp),%eax
801046ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801046ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pushcli();
801046f2:	e8 09 0c 00 00       	call   80105300 <pushcli>
    c = mycpu();
801046f7:	e8 44 f2 ff ff       	call   80103940 <mycpu>
    p = c->proc;
801046fc:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
    popcli();
80104702:	e8 39 0c 00 00       	call   80105340 <popcli>
    pushcli();
80104707:	e8 f4 0b 00 00       	call   80105300 <pushcli>
    c = mycpu();
8010470c:	e8 2f f2 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80104711:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104717:	e8 24 0c 00 00       	call   80105340 <popcli>
    if (p == 0)
8010471c:	85 ff                	test   %edi,%edi
8010471e:	0f 84 f0 00 00 00    	je     80104814 <sleep+0x134>
    if (lk == 0)
80104724:	85 f6                	test   %esi,%esi
80104726:	0f 84 f5 00 00 00    	je     80104821 <sleep+0x141>
    if (lk != &ptable.lock) {
8010472c:	81 fe e0 3e 11 80    	cmp    $0x80113ee0,%esi
80104732:	74 6c                	je     801047a0 <sleep+0xc0>
        acquire(&ptable.lock);
80104734:	83 ec 0c             	sub    $0xc,%esp
        ptable.lock.name = "SLEEP";
80104737:	c7 05 e4 3e 11 80 66 	movl   $0x80108866,0x80113ee4
8010473e:	88 10 80 
        acquire(&ptable.lock);
80104741:	68 e0 3e 11 80       	push   $0x80113ee0
80104746:	e8 85 0c 00 00       	call   801053d0 <acquire>
        release(lk);
8010474b:	89 34 24             	mov    %esi,(%esp)
8010474e:	e8 4d 0d 00 00       	call   801054a0 <release>
    t->chan = chan;
80104753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    t->state = SLEEPING;
80104756:	c7 43 08 02 00 00 00 	movl   $0x2,0x8(%ebx)
    t->chan = chan;
8010475d:	89 43 18             	mov    %eax,0x18(%ebx)
    sched();
80104760:	e8 4b f7 ff ff       	call   80103eb0 <sched>
    if(t->tkilled)
80104765:	8b 53 1c             	mov    0x1c(%ebx),%edx
80104768:	83 c4 10             	add    $0x10,%esp
8010476b:	85 d2                	test   %edx,%edx
8010476d:	75 61                	jne    801047d0 <sleep+0xf0>
    t->chan = 0;
8010476f:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        release(&ptable.lock);
80104776:	83 ec 0c             	sub    $0xc,%esp
80104779:	68 e0 3e 11 80       	push   $0x80113ee0
8010477e:	e8 1d 0d 00 00       	call   801054a0 <release>
        lk->name = "SLEEP2";
80104783:	c7 46 04 6c 88 10 80 	movl   $0x8010886c,0x4(%esi)
        acquire(lk);
8010478a:	83 c4 10             	add    $0x10,%esp
8010478d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104790:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104793:	5b                   	pop    %ebx
80104794:	5e                   	pop    %esi
80104795:	5f                   	pop    %edi
80104796:	5d                   	pop    %ebp
        acquire(lk);
80104797:	e9 34 0c 00 00       	jmp    801053d0 <acquire>
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    t->chan = chan;
801047a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    t->state = SLEEPING;
801047a3:	c7 43 08 02 00 00 00 	movl   $0x2,0x8(%ebx)
    t->chan = chan;
801047aa:	89 43 18             	mov    %eax,0x18(%ebx)
    sched();
801047ad:	e8 fe f6 ff ff       	call   80103eb0 <sched>
    if(t->tkilled)
801047b2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801047b5:	85 c0                	test   %eax,%eax
801047b7:	75 37                	jne    801047f0 <sleep+0x110>
    t->chan = 0;
801047b9:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
}
801047c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047c3:	5b                   	pop    %ebx
801047c4:	5e                   	pop    %esi
801047c5:	5f                   	pop    %edi
801047c6:	5d                   	pop    %ebp
801047c7:	c3                   	ret    
801047c8:	90                   	nop
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        release(&ptable.lock);
801047d0:	83 ec 0c             	sub    $0xc,%esp
801047d3:	68 e0 3e 11 80       	push   $0x80113ee0
801047d8:	e8 c3 0c 00 00       	call   801054a0 <release>
        kthread_exit();
801047dd:	e8 fe fc ff ff       	call   801044e0 <kthread_exit>
    t->chan = 0;
801047e2:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
801047e9:	83 c4 10             	add    $0x10,%esp
801047ec:	eb 88                	jmp    80104776 <sleep+0x96>
801047ee:	66 90                	xchg   %ax,%ax
        release(&ptable.lock);
801047f0:	83 ec 0c             	sub    $0xc,%esp
801047f3:	68 e0 3e 11 80       	push   $0x80113ee0
801047f8:	e8 a3 0c 00 00       	call   801054a0 <release>
        kthread_exit();
801047fd:	e8 de fc ff ff       	call   801044e0 <kthread_exit>
    t->chan = 0;
80104802:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
80104809:	83 c4 10             	add    $0x10,%esp
}
8010480c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010480f:	5b                   	pop    %ebx
80104810:	5e                   	pop    %esi
80104811:	5f                   	pop    %edi
80104812:	5d                   	pop    %ebp
80104813:	c3                   	ret    
        panic("sleep");
80104814:	83 ec 0c             	sub    $0xc,%esp
80104817:	68 4f 88 10 80       	push   $0x8010884f
8010481c:	e8 6f bb ff ff       	call   80100390 <panic>
        panic("sleep without lk");
80104821:	83 ec 0c             	sub    $0xc,%esp
80104824:	68 55 88 10 80       	push   $0x80108855
80104829:	e8 62 bb ff ff       	call   80100390 <panic>
8010482e:	66 90                	xchg   %ax,%ax

80104830 <cleanProcOneThread>:
cleanProcOneThread(struct thread *curthread, struct proc *p) {
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	56                   	push   %esi
80104835:	53                   	push   %ebx
80104836:	83 ec 18             	sub    $0x18,%esp
80104839:	8b 75 0c             	mov    0xc(%ebp),%esi
8010483c:	8b 7d 08             	mov    0x8(%ebp),%edi
    acquire(&ptable.lock);
8010483f:	68 e0 3e 11 80       	push   $0x80113ee0
    ptable.lock.name = "CLEANPROCONETHREAD";
80104844:	c7 05 e4 3e 11 80 73 	movl   $0x80108873,0x80113ee4
8010484b:	88 10 80 
    for (t = p->thread; t < &p->thread[NTHREADS];t++) {
8010484e:	8d 5e 74             	lea    0x74(%esi),%ebx
80104851:	81 c6 74 03 00 00    	add    $0x374,%esi
    acquire(&ptable.lock);
80104857:	e8 74 0b 00 00       	call   801053d0 <acquire>
    p->mainThread = curthread;
8010485c:	89 3e                	mov    %edi,(%esi)
    for (t = p->thread; t < &p->thread[NTHREADS];t++) {
8010485e:	83 c4 10             	add    $0x10,%esp
80104861:	eb 0c                	jmp    8010486f <cleanProcOneThread+0x3f>
80104863:	90                   	nop
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104868:	83 c3 30             	add    $0x30,%ebx
8010486b:	39 f3                	cmp    %esi,%ebx
8010486d:	73 6f                	jae    801048de <cleanProcOneThread+0xae>
        if (t != curthread && t->state != UNUSED) {
8010486f:	39 df                	cmp    %ebx,%edi
80104871:	74 f5                	je     80104868 <cleanProcOneThread+0x38>
80104873:	8b 43 08             	mov    0x8(%ebx),%eax
80104876:	85 c0                	test   %eax,%eax
80104878:	74 ee                	je     80104868 <cleanProcOneThread+0x38>
                if (t->state == RUNNING)
8010487a:	83 f8 04             	cmp    $0x4,%eax
8010487d:	74 72                	je     801048f1 <cleanProcOneThread+0xc1>
cleanProcOneThread(struct thread *curthread, struct proc *p) {
8010487f:	ba 18 3f 11 80       	mov    $0x80113f18,%edx
80104884:	eb 18                	jmp    8010489e <cleanProcOneThread+0x6e>
80104886:	8d 76 00             	lea    0x0(%esi),%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104890:	81 c2 7c 12 00 00    	add    $0x127c,%edx
80104896:	81 fa 18 de 15 80    	cmp    $0x8015de18,%edx
8010489c:	73 2d                	jae    801048cb <cleanProcOneThread+0x9b>
        if (p->state != RUNNABLE)
8010489e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801048a2:	75 ec                	jne    80104890 <cleanProcOneThread+0x60>
801048a4:	8d 42 74             	lea    0x74(%edx),%eax
801048a7:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
801048ad:	eb 08                	jmp    801048b7 <cleanProcOneThread+0x87>
801048af:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801048b0:	83 c0 30             	add    $0x30,%eax
801048b3:	39 c8                	cmp    %ecx,%eax
801048b5:	73 d9                	jae    80104890 <cleanProcOneThread+0x60>
            if (t->state == SLEEPING && t->chan == chan)
801048b7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801048bb:	75 f3                	jne    801048b0 <cleanProcOneThread+0x80>
801048bd:	39 58 18             	cmp    %ebx,0x18(%eax)
801048c0:	75 ee                	jne    801048b0 <cleanProcOneThread+0x80>
                t->state = RUNNABLE;
801048c2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801048c9:	eb e5                	jmp    801048b0 <cleanProcOneThread+0x80>
                cleanThread(t);
801048cb:	83 ec 0c             	sub    $0xc,%esp
801048ce:	53                   	push   %ebx
    for (t = p->thread; t < &p->thread[NTHREADS];t++) {
801048cf:	83 c3 30             	add    $0x30,%ebx
                cleanThread(t);
801048d2:	e8 f9 ef ff ff       	call   801038d0 <cleanThread>
801048d7:	83 c4 10             	add    $0x10,%esp
    for (t = p->thread; t < &p->thread[NTHREADS];t++) {
801048da:	39 f3                	cmp    %esi,%ebx
801048dc:	72 91                	jb     8010486f <cleanProcOneThread+0x3f>
    release(&ptable.lock);
801048de:	c7 45 08 e0 3e 11 80 	movl   $0x80113ee0,0x8(%ebp)
}
801048e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048e8:	5b                   	pop    %ebx
801048e9:	5e                   	pop    %esi
801048ea:	5f                   	pop    %edi
801048eb:	5d                   	pop    %ebp
    release(&ptable.lock);
801048ec:	e9 af 0b 00 00       	jmp    801054a0 <release>
                    sleep(t, &ptable.lock);
801048f1:	83 ec 08             	sub    $0x8,%esp
801048f4:	68 e0 3e 11 80       	push   $0x80113ee0
801048f9:	53                   	push   %ebx
801048fa:	e8 e1 fd ff ff       	call   801046e0 <sleep>
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	e9 78 ff ff ff       	jmp    8010487f <cleanProcOneThread+0x4f>
80104907:	89 f6                	mov    %esi,%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104910 <exit>:
exit(void) {
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	56                   	push   %esi
80104915:	53                   	push   %ebx
80104916:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104919:	e8 e2 09 00 00       	call   80105300 <pushcli>
    c = mycpu();
8010491e:	e8 1d f0 ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104923:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104929:	e8 12 0a 00 00       	call   80105340 <popcli>
    pushcli();
8010492e:	e8 cd 09 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104933:	e8 08 f0 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80104938:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010493e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
80104941:	e8 fa 09 00 00       	call   80105340 <popcli>
    if (curproc == initproc)
80104946:	39 35 c0 b5 10 80    	cmp    %esi,0x8010b5c0
8010494c:	0f 84 6c 01 00 00    	je     80104abe <exit+0x1ae>
    cleanProcOneThread(curthread, curproc);
80104952:	83 ec 08             	sub    $0x8,%esp
80104955:	8d 7e 20             	lea    0x20(%esi),%edi
80104958:	8d 5e 60             	lea    0x60(%esi),%ebx
8010495b:	56                   	push   %esi
8010495c:	ff 75 e0             	pushl  -0x20(%ebp)
8010495f:	e8 cc fe ff ff       	call   80104830 <cleanProcOneThread>
80104964:	83 c4 10             	add    $0x10,%esp
80104967:	89 f6                	mov    %esi,%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (curproc->ofile[fd]) {
80104970:	8b 07                	mov    (%edi),%eax
80104972:	85 c0                	test   %eax,%eax
80104974:	74 12                	je     80104988 <exit+0x78>
            fileclose(curproc->ofile[fd]);
80104976:	83 ec 0c             	sub    $0xc,%esp
80104979:	50                   	push   %eax
8010497a:	e8 51 c5 ff ff       	call   80100ed0 <fileclose>
            curproc->ofile[fd] = 0;
8010497f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80104985:	83 c4 10             	add    $0x10,%esp
80104988:	83 c7 04             	add    $0x4,%edi
    for (fd = 0; fd < NOFILE; fd++) {
8010498b:	39 df                	cmp    %ebx,%edi
8010498d:	75 e1                	jne    80104970 <exit+0x60>
    begin_op();
8010498f:	e8 ac e2 ff ff       	call   80102c40 <begin_op>
    iput(curproc->cwd);
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	ff 76 60             	pushl  0x60(%esi)
8010499a:	e8 b1 ce ff ff       	call   80101850 <iput>
    end_op();
8010499f:	e8 0c e3 ff ff       	call   80102cb0 <end_op>
    curproc->cwd = 0;
801049a4:	c7 46 60 00 00 00 00 	movl   $0x0,0x60(%esi)
    ptable.lock.name = "EXIT"; //for debugging
801049ab:	c7 05 e4 3e 11 80 4a 	movl   $0x8010884a,0x80113ee4
801049b2:	88 10 80 
    acquire(&ptable.lock);
801049b5:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
801049bc:	e8 0f 0a 00 00       	call   801053d0 <acquire>
    wakeup1(curproc->parent->mainThread);
801049c1:	8b 46 10             	mov    0x10(%esi),%eax
801049c4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801049c7:	ba 18 3f 11 80       	mov    $0x80113f18,%edx
    wakeup1(curproc->parent->mainThread);
801049cc:	8b 98 74 03 00 00    	mov    0x374(%eax),%ebx
801049d2:	eb 12                	jmp    801049e6 <exit+0xd6>
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801049d8:	81 c2 7c 12 00 00    	add    $0x127c,%edx
801049de:	81 fa 18 de 15 80    	cmp    $0x8015de18,%edx
801049e4:	73 35                	jae    80104a1b <exit+0x10b>
        if (p->state != RUNNABLE)
801049e6:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801049ea:	75 ec                	jne    801049d8 <exit+0xc8>
801049ec:	8d 42 74             	lea    0x74(%edx),%eax
801049ef:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
801049f5:	eb 10                	jmp    80104a07 <exit+0xf7>
801049f7:	89 f6                	mov    %esi,%esi
801049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104a00:	83 c0 30             	add    $0x30,%eax
80104a03:	39 c8                	cmp    %ecx,%eax
80104a05:	73 d1                	jae    801049d8 <exit+0xc8>
            if (t->state == SLEEPING && t->chan == chan)
80104a07:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
80104a0b:	75 f3                	jne    80104a00 <exit+0xf0>
80104a0d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104a10:	75 ee                	jne    80104a00 <exit+0xf0>
                t->state = RUNNABLE;
80104a12:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104a19:	eb e5                	jmp    80104a00 <exit+0xf0>
            p->parent = initproc;
80104a1b:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a20:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx
            p->parent = initproc;
80104a25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104a28:	eb 14                	jmp    80104a3e <exit+0x12e>
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a30:	81 c3 7c 12 00 00    	add    $0x127c,%ebx
80104a36:	81 fb 18 de 15 80    	cmp    $0x8015de18,%ebx
80104a3c:	73 5d                	jae    80104a9b <exit+0x18b>
        if (p->parent == curproc) {
80104a3e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104a41:	75 ed                	jne    80104a30 <exit+0x120>
            if (p->state == ZOMBIE)
80104a43:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
            p->parent = initproc;
80104a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a4a:	89 43 10             	mov    %eax,0x10(%ebx)
            if (p->state == ZOMBIE)
80104a4d:	75 e1                	jne    80104a30 <exit+0x120>
                wakeup1(initproc->mainThread);
80104a4f:	8b b8 74 03 00 00    	mov    0x374(%eax),%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a55:	ba 18 3f 11 80       	mov    $0x80113f18,%edx
80104a5a:	eb 12                	jmp    80104a6e <exit+0x15e>
80104a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a60:	81 c2 7c 12 00 00    	add    $0x127c,%edx
80104a66:	81 fa 18 de 15 80    	cmp    $0x8015de18,%edx
80104a6c:	73 c2                	jae    80104a30 <exit+0x120>
        if (p->state != RUNNABLE)
80104a6e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104a72:	75 ec                	jne    80104a60 <exit+0x150>
80104a74:	8d 42 74             	lea    0x74(%edx),%eax
80104a77:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
80104a7d:	eb 08                	jmp    80104a87 <exit+0x177>
80104a7f:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104a80:	83 c0 30             	add    $0x30,%eax
80104a83:	39 c1                	cmp    %eax,%ecx
80104a85:	76 d9                	jbe    80104a60 <exit+0x150>
            if (t->state == SLEEPING && t->chan == chan)
80104a87:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
80104a8b:	75 f3                	jne    80104a80 <exit+0x170>
80104a8d:	3b 78 18             	cmp    0x18(%eax),%edi
80104a90:	75 ee                	jne    80104a80 <exit+0x170>
                t->state = RUNNABLE;
80104a92:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104a99:	eb e5                	jmp    80104a80 <exit+0x170>
    curthread->state = ZOMBIE;
80104a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a9e:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    curproc->state = ZOMBIE;
80104aa5:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
80104aac:	e8 ff f3 ff ff       	call   80103eb0 <sched>
    panic("zombie exit");
80104ab1:	83 ec 0c             	sub    $0xc,%esp
80104ab4:	68 93 88 10 80       	push   $0x80108893
80104ab9:	e8 d2 b8 ff ff       	call   80100390 <panic>
        panic("init exiting");
80104abe:	83 ec 0c             	sub    $0xc,%esp
80104ac1:	68 86 88 10 80       	push   $0x80108886
80104ac6:	e8 c5 b8 ff ff       	call   80100390 <panic>
80104acb:	90                   	nop
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <wait>:
wait(void) {
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	56                   	push   %esi
80104ad5:	53                   	push   %ebx
80104ad6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104ad9:	e8 22 08 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104ade:	e8 5d ee ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104ae3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104ae9:	e8 52 08 00 00       	call   80105340 <popcli>
    acquire(&ptable.lock);
80104aee:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "WAIT";
80104af1:	c7 05 e4 3e 11 80 9f 	movl   $0x8010889f,0x80113ee4
80104af8:	88 10 80 
    acquire(&ptable.lock);
80104afb:	68 e0 3e 11 80       	push   $0x80113ee0
80104b00:	e8 cb 08 00 00       	call   801053d0 <acquire>
80104b05:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
80104b08:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b0a:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx
80104b0f:	eb 15                	jmp    80104b26 <wait+0x56>
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b18:	81 c3 7c 12 00 00    	add    $0x127c,%ebx
80104b1e:	81 fb 18 de 15 80    	cmp    $0x8015de18,%ebx
80104b24:	73 22                	jae    80104b48 <wait+0x78>
            if (p->parent != curproc)
80104b26:	39 73 10             	cmp    %esi,0x10(%ebx)
80104b29:	75 ed                	jne    80104b18 <wait+0x48>
            if (p->state == ZOMBIE) {
80104b2b:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80104b2f:	0f 84 8b 00 00 00    	je     80104bc0 <wait+0xf0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b35:	81 c3 7c 12 00 00    	add    $0x127c,%ebx
            havekids = 1;
80104b3b:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b40:	81 fb 18 de 15 80    	cmp    $0x8015de18,%ebx
80104b46:	72 de                	jb     80104b26 <wait+0x56>
        if (!havekids || myproc()->killed) {
80104b48:	85 c0                	test   %eax,%eax
80104b4a:	0f 84 ed 00 00 00    	je     80104c3d <wait+0x16d>
    pushcli();
80104b50:	e8 ab 07 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104b55:	e8 e6 ed ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104b5a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104b60:	e8 db 07 00 00       	call   80105340 <popcli>
        if (!havekids || myproc()->killed) {
80104b65:	8b 53 1c             	mov    0x1c(%ebx),%edx
80104b68:	85 d2                	test   %edx,%edx
80104b6a:	0f 85 cd 00 00 00    	jne    80104c3d <wait+0x16d>
    pushcli();
80104b70:	e8 8b 07 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104b75:	e8 c6 ed ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80104b7a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104b80:	e8 bb 07 00 00       	call   80105340 <popcli>
        if (mythread()->tkilled) {
80104b85:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104b88:	85 c0                	test   %eax,%eax
80104b8a:	0f 85 c6 00 00 00    	jne    80104c56 <wait+0x186>
    pushcli();
80104b90:	e8 6b 07 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104b95:	e8 a6 ed ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80104b9a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104ba0:	e8 9b 07 00 00       	call   80105340 <popcli>
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
80104ba5:	83 ec 08             	sub    $0x8,%esp
80104ba8:	68 e0 3e 11 80       	push   $0x80113ee0
80104bad:	53                   	push   %ebx
80104bae:	e8 2d fb ff ff       	call   801046e0 <sleep>
        havekids = 0;
80104bb3:	83 c4 10             	add    $0x10,%esp
80104bb6:	e9 4d ff ff ff       	jmp    80104b08 <wait+0x38>
80104bbb:	90                   	nop
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                pid = p->pid;
80104bc0:	8b 43 0c             	mov    0xc(%ebx),%eax
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104bc3:	8d 73 74             	lea    0x74(%ebx),%esi
80104bc6:	8d bb 74 03 00 00    	lea    0x374(%ebx),%edi
                pid = p->pid;
80104bcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104bcf:	eb 0e                	jmp    80104bdf <wait+0x10f>
80104bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104bd8:	83 c6 30             	add    $0x30,%esi
80104bdb:	39 f7                	cmp    %esi,%edi
80104bdd:	76 19                	jbe    80104bf8 <wait+0x128>
                    if (t->state == ZOMBIE)
80104bdf:	83 7e 08 05          	cmpl   $0x5,0x8(%esi)
80104be3:	75 f3                	jne    80104bd8 <wait+0x108>
                        cleanThread(t);
80104be5:	83 ec 0c             	sub    $0xc,%esp
80104be8:	56                   	push   %esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104be9:	83 c6 30             	add    $0x30,%esi
                        cleanThread(t);
80104bec:	e8 df ec ff ff       	call   801038d0 <cleanThread>
80104bf1:	83 c4 10             	add    $0x10,%esp
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104bf4:	39 f7                	cmp    %esi,%edi
80104bf6:	77 e7                	ja     80104bdf <wait+0x10f>
                freevm(p->pgdir);
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	ff 73 04             	pushl  0x4(%ebx)
80104bfe:	e8 fd 32 00 00       	call   80107f00 <freevm>
                p->pid = 0;
80104c03:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
80104c0a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
80104c11:	c6 43 64 00          	movb   $0x0,0x64(%ebx)
                p->killed = 0;
80104c15:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
80104c1c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
80104c23:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
80104c2a:	e8 71 08 00 00       	call   801054a0 <release>
                return pid;
80104c2f:	83 c4 10             	add    $0x10,%esp
}
80104c32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c38:	5b                   	pop    %ebx
80104c39:	5e                   	pop    %esi
80104c3a:	5f                   	pop    %edi
80104c3b:	5d                   	pop    %ebp
80104c3c:	c3                   	ret    
            release(&ptable.lock);
80104c3d:	83 ec 0c             	sub    $0xc,%esp
80104c40:	68 e0 3e 11 80       	push   $0x80113ee0
80104c45:	e8 56 08 00 00       	call   801054a0 <release>
            return -1;
80104c4a:	83 c4 10             	add    $0x10,%esp
80104c4d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104c54:	eb dc                	jmp    80104c32 <wait+0x162>
            release(&ptable.lock);
80104c56:	83 ec 0c             	sub    $0xc,%esp
80104c59:	68 e0 3e 11 80       	push   $0x80113ee0
80104c5e:	e8 3d 08 00 00       	call   801054a0 <release>
            kthread_exit();
80104c63:	e8 78 f8 ff ff       	call   801044e0 <kthread_exit>
            return -1;
80104c68:	83 c4 10             	add    $0x10,%esp
80104c6b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104c72:	eb be                	jmp    80104c32 <wait+0x162>
80104c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c80 <kthread_join>:


int kthread_join(int thread_id) {
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
80104c85:	53                   	push   %ebx
80104c86:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104c89:	e8 72 06 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104c8e:	e8 ad ec ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104c93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104c99:	e8 a2 06 00 00       	call   80105340 <popcli>
    if (DEBUGMODE > 0)
        cprintf(" KTHREAD_JOIN ");
    struct thread *t;
    struct proc *p = myproc();
    int foundFlag = 0;
    acquire(&ptable.lock);
80104c9e:	83 ec 0c             	sub    $0xc,%esp
80104ca1:	68 e0 3e 11 80       	push   $0x80113ee0
            release(&ptable.lock);
            kthread_exit();
        }
        if (foundFlag) //if true- no need to search again- goto foundTid
            goto foundTid;
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104ca6:	8d 9e 74 03 00 00    	lea    0x374(%esi),%ebx
    acquire(&ptable.lock);
80104cac:	e8 1f 07 00 00       	call   801053d0 <acquire>
80104cb1:	83 c4 10             	add    $0x10,%esp
    int foundFlag = 0;
80104cb4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    pushcli();
80104cbb:	e8 40 06 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104cc0:	e8 7b ec ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80104cc5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104ccb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
80104cce:	e8 6d 06 00 00       	call   80105340 <popcli>
        if( mythread()->tkilled ){
80104cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cd6:	8b 50 1c             	mov    0x1c(%eax),%edx
80104cd9:	85 d2                	test   %edx,%edx
80104cdb:	0f 85 bf 00 00 00    	jne    80104da0 <kthread_join+0x120>
        if (foundFlag) //if true- no need to search again- goto foundTid
80104ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104ce4:	85 c0                	test   %eax,%eax
80104ce6:	74 58                	je     80104d40 <kthread_join+0xc0>
        //if got here - exit the loop and didn't find the thread tid
        release(&ptable.lock);
        return -1;

        foundTid:
        switch (t->state) {
80104ce8:	8b 47 08             	mov    0x8(%edi),%eax
80104ceb:	85 c0                	test   %eax,%eax
80104ced:	74 70                	je     80104d5f <kthread_join+0xdf>
80104cef:	83 f8 05             	cmp    $0x5,%eax
80104cf2:	0f 85 88 00 00 00    	jne    80104d80 <kthread_join+0x100>
            case ZOMBIE: //clean t and return 0
                t->state = UNUSED;
                t->tkilled = 0;
                release(&ptable.lock);
80104cf8:	83 ec 0c             	sub    $0xc,%esp
                t->state = UNUSED;
80104cfb:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
                t->tkilled = 0;
80104d02:	c7 47 1c 00 00 00 00 	movl   $0x0,0x1c(%edi)
                release(&ptable.lock);
80104d09:	68 e0 3e 11 80       	push   $0x80113ee0
80104d0e:	e8 8d 07 00 00       	call   801054a0 <release>
                if (t->tkstack != 0) {
80104d13:	8b 4f 04             	mov    0x4(%edi),%ecx
80104d16:	83 c4 10             	add    $0x10,%esp
                    kfree(t->tkstack);
                    t->tkstack = 0;
                }
                return 0;
80104d19:	31 c0                	xor    %eax,%eax
                if (t->tkstack != 0) {
80104d1b:	85 c9                	test   %ecx,%ecx
80104d1d:	74 55                	je     80104d74 <kthread_join+0xf4>
                    kfree(t->tkstack);
80104d1f:	83 ec 0c             	sub    $0xc,%esp
80104d22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104d25:	51                   	push   %ecx
80104d26:	e8 85 d6 ff ff       	call   801023b0 <kfree>
                    t->tkstack = 0;
80104d2b:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
80104d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104d35:	83 c4 10             	add    $0x10,%esp
            default: //all other options- thread not exited yet
                sleep(t, &ptable.lock);

        }
    }
}
80104d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d3b:	5b                   	pop    %ebx
80104d3c:	5e                   	pop    %esi
80104d3d:	5f                   	pop    %edi
80104d3e:	5d                   	pop    %ebp
80104d3f:	c3                   	ret    
            if (t->tid == thread_id) {
80104d40:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104d46:	39 45 08             	cmp    %eax,0x8(%ebp)
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104d49:	8d 7e 74             	lea    0x74(%esi),%edi
            if (t->tid == thread_id) {
80104d4c:	75 0a                	jne    80104d58 <kthread_join+0xd8>
80104d4e:	eb 98                	jmp    80104ce8 <kthread_join+0x68>
80104d50:	8b 45 08             	mov    0x8(%ebp),%eax
80104d53:	39 47 0c             	cmp    %eax,0xc(%edi)
80104d56:	74 90                	je     80104ce8 <kthread_join+0x68>
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104d58:	83 c7 30             	add    $0x30,%edi
80104d5b:	39 df                	cmp    %ebx,%edi
80104d5d:	72 f1                	jb     80104d50 <kthread_join+0xd0>
                release(&ptable.lock);
80104d5f:	83 ec 0c             	sub    $0xc,%esp
80104d62:	68 e0 3e 11 80       	push   $0x80113ee0
80104d67:	e8 34 07 00 00       	call   801054a0 <release>
                return -1;
80104d6c:	83 c4 10             	add    $0x10,%esp
80104d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d77:	5b                   	pop    %ebx
80104d78:	5e                   	pop    %esi
80104d79:	5f                   	pop    %edi
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                sleep(t, &ptable.lock);
80104d80:	83 ec 08             	sub    $0x8,%esp
80104d83:	68 e0 3e 11 80       	push   $0x80113ee0
80104d88:	57                   	push   %edi
80104d89:	e8 52 f9 ff ff       	call   801046e0 <sleep>
80104d8e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
        if( mythread()->tkilled ){
80104d95:	83 c4 10             	add    $0x10,%esp
80104d98:	e9 1e ff ff ff       	jmp    80104cbb <kthread_join+0x3b>
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
            release(&ptable.lock);
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	68 e0 3e 11 80       	push   $0x80113ee0
80104da8:	e8 f3 06 00 00       	call   801054a0 <release>
            kthread_exit();
80104dad:	e8 2e f7 ff ff       	call   801044e0 <kthread_exit>
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	e9 27 ff ff ff       	jmp    80104ce1 <kthread_join+0x61>
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dc0 <kthread_mutex_alloc>:
/********************************
        kthread_mutex
 ********************************/

int
kthread_mutex_alloc() {
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
    pushcli();
80104dc5:	e8 36 05 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104dca:	e8 71 eb ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104dcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104dd5:	e8 66 05 00 00       	call   80105340 <popcli>
    struct kthread_mutex_t *m;
    //search a not active mutex
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104dda:	81 c3 78 03 00 00    	add    $0x378,%ebx
80104de0:	eb 10                	jmp    80104df2 <kthread_mutex_alloc+0x32>
80104de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!m->active)
80104de8:	8b 43 04             	mov    0x4(%ebx),%eax
80104deb:	85 c0                	test   %eax,%eax
80104ded:	74 31                	je     80104e20 <kthread_mutex_alloc+0x60>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104def:	83 c3 3c             	add    $0x3c,%ebx
    pushcli();
80104df2:	e8 09 05 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104df7:	e8 44 eb ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104dfc:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104e02:	e8 39 05 00 00       	call   80105340 <popcli>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104e07:	81 c6 78 12 00 00    	add    $0x1278,%esi
80104e0d:	39 f3                	cmp    %esi,%ebx
80104e0f:	72 d7                	jb     80104de8 <kthread_mutex_alloc+0x28>
    m->thread = 0;
    mutexCounter += 1;
    if (DEBUGMODE > 0)
        cprintf("DONE ALLOC");
    return m->mid;
}
80104e11:	5b                   	pop    %ebx
    return -1; //if not found- return -1
80104e12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e17:	5e                   	pop    %esi
80104e18:	5d                   	pop    %ebp
80104e19:	c3                   	ret    
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    m->mid = mutexCounter;
80104e20:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
    m->waitingCounter = 0;
80104e25:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    m->locked = 0;
80104e2c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    m->active = 1;
80104e32:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
    m->thread = 0;
80104e39:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    mutexCounter += 1;
80104e40:	83 05 bc b5 10 80 01 	addl   $0x1,0x8010b5bc
    m->mid = mutexCounter;
80104e47:	89 43 08             	mov    %eax,0x8(%ebx)
}
80104e4a:	5b                   	pop    %ebx
80104e4b:	5e                   	pop    %esi
80104e4c:	5d                   	pop    %ebp
80104e4d:	c3                   	ret    
80104e4e:	66 90                	xchg   %ax,%ax

80104e50 <safe_tree_dealloc>:

int
safe_tree_dealloc(int mutex_id) {
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	56                   	push   %esi
80104e55:	53                   	push   %ebx
80104e56:	83 ec 0c             	sub    $0xc,%esp
80104e59:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80104e5c:	e8 9f 04 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104e61:	e8 da ea ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104e66:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104e6c:	e8 cf 04 00 00       	call   80105340 <popcli>
    struct kthread_mutex_t *m;
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104e71:	81 c3 78 03 00 00    	add    $0x378,%ebx
80104e77:	eb 0f                	jmp    80104e88 <safe_tree_dealloc+0x38>
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (m->mid == mutex_id) { //search for specific mutex_id
80104e80:	39 73 08             	cmp    %esi,0x8(%ebx)
80104e83:	74 33                	je     80104eb8 <safe_tree_dealloc+0x68>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104e85:	83 c3 3c             	add    $0x3c,%ebx
    pushcli();
80104e88:	e8 73 04 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104e8d:	e8 ae ea ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104e92:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
    popcli();
80104e98:	e8 a3 04 00 00       	call   80105340 <popcli>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104e9d:	81 c7 78 12 00 00    	add    $0x1278,%edi
80104ea3:	39 fb                	cmp    %edi,%ebx
80104ea5:	72 d9                	jb     80104e80 <safe_tree_dealloc+0x30>
            else
                return 1;
        }
    }
    return 0;
}
80104ea7:	83 c4 0c             	add    $0xc,%esp
    return 0;
80104eaa:	31 c0                	xor    %eax,%eax
}
80104eac:	5b                   	pop    %ebx
80104ead:	5e                   	pop    %esi
80104eae:	5f                   	pop    %edi
80104eaf:	5d                   	pop    %ebp
80104eb0:	c3                   	ret    
80104eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (m->locked)
80104eb8:	8b 13                	mov    (%ebx),%edx
80104eba:	31 c0                	xor    %eax,%eax
80104ebc:	85 d2                	test   %edx,%edx
80104ebe:	0f 94 c0             	sete   %al
}
80104ec1:	83 c4 0c             	add    $0xc,%esp
80104ec4:	5b                   	pop    %ebx
80104ec5:	5e                   	pop    %esi
80104ec6:	5f                   	pop    %edi
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret    
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ed0 <kthread_mutex_dealloc>:

int
kthread_mutex_dealloc(int mutex_id) {
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
80104ed5:	53                   	push   %ebx
80104ed6:	83 ec 0c             	sub    $0xc,%esp
80104ed9:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80104edc:	e8 1f 04 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104ee1:	e8 5a ea ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104ee6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104eec:	e8 4f 04 00 00       	call   80105340 <popcli>
    struct kthread_mutex_t *m;
    if (DEBUGMODE > 0)
        cprintf("MUTEX THAT WILL GET DEALLOC WITH ID %d   \n",mutex_id);
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104ef1:	81 c3 78 03 00 00    	add    $0x378,%ebx
80104ef7:	eb 0f                	jmp    80104f08 <kthread_mutex_dealloc+0x38>
80104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (m->mid == mutex_id) {
80104f00:	39 73 08             	cmp    %esi,0x8(%ebx)
80104f03:	74 33                	je     80104f38 <kthread_mutex_dealloc+0x68>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104f05:	83 c3 3c             	add    $0x3c,%ebx
    pushcli();
80104f08:	e8 f3 03 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104f0d:	e8 2e ea ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104f12:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
    popcli();
80104f18:	e8 23 04 00 00       	call   80105340 <popcli>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104f1d:	81 c7 78 12 00 00    	add    $0x1278,%edi
80104f23:	39 fb                	cmp    %edi,%ebx
80104f25:	72 d9                	jb     80104f00 <kthread_mutex_dealloc+0x30>
    m->active = 0;
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    return 0;
}
80104f27:	83 c4 0c             	add    $0xc,%esp
                return -1;
80104f2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f2f:	5b                   	pop    %ebx
80104f30:	5e                   	pop    %esi
80104f31:	5f                   	pop    %edi
80104f32:	5d                   	pop    %ebp
80104f33:	c3                   	ret    
80104f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if (m->locked  || m->waitingCounter > 0 || !m->active ) {
80104f38:	8b 0b                	mov    (%ebx),%ecx
80104f3a:	85 c9                	test   %ecx,%ecx
80104f3c:	75 e9                	jne    80104f27 <kthread_mutex_dealloc+0x57>
80104f3e:	8b 53 0c             	mov    0xc(%ebx),%edx
80104f41:	85 d2                	test   %edx,%edx
80104f43:	7f e2                	jg     80104f27 <kthread_mutex_dealloc+0x57>
80104f45:	8b 43 04             	mov    0x4(%ebx),%eax
80104f48:	85 c0                	test   %eax,%eax
80104f4a:	74 db                	je     80104f27 <kthread_mutex_dealloc+0x57>
    m->active = 0;
80104f4c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    m->mid = -1;
80104f53:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
    return 0;
80104f5a:	31 c0                	xor    %eax,%eax
    m->thread = 0;
80104f5c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
}
80104f63:	83 c4 0c             	add    $0xc,%esp
80104f66:	5b                   	pop    %ebx
80104f67:	5e                   	pop    %esi
80104f68:	5f                   	pop    %edi
80104f69:	5d                   	pop    %ebp
80104f6a:	c3                   	ret    
80104f6b:	90                   	nop
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f70 <kthread_mutex_lock>:

int
kthread_mutex_lock(int mutex_id) {
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	56                   	push   %esi
80104f75:	53                   	push   %ebx
80104f76:	83 ec 0c             	sub    $0xc,%esp
80104f79:	8b 7d 08             	mov    0x8(%ebp),%edi
    pushcli();
80104f7c:	e8 7f 03 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104f81:	e8 ba e9 ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104f86:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104f8c:	e8 af 03 00 00       	call   80105340 <popcli>
    struct kthread_mutex_t *m;
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104f91:	81 c3 78 03 00 00    	add    $0x378,%ebx
80104f97:	eb 16                	jmp    80104faf <kthread_mutex_lock+0x3f>
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (m->active && m->mid == mutex_id) {
80104fa0:	8b 43 04             	mov    0x4(%ebx),%eax
80104fa3:	85 c0                	test   %eax,%eax
80104fa5:	74 05                	je     80104fac <kthread_mutex_lock+0x3c>
80104fa7:	39 7b 08             	cmp    %edi,0x8(%ebx)
80104faa:	74 34                	je     80104fe0 <kthread_mutex_lock+0x70>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104fac:	83 c3 3c             	add    $0x3c,%ebx
    pushcli();
80104faf:	e8 4c 03 00 00       	call   80105300 <pushcli>
    c = mycpu();
80104fb4:	e8 87 e9 ff ff       	call   80103940 <mycpu>
    p = c->proc;
80104fb9:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104fbf:	e8 7c 03 00 00       	call   80105340 <popcli>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
80104fc4:	81 c6 78 12 00 00    	add    $0x1278,%esi
80104fca:	39 f3                	cmp    %esi,%ebx
80104fcc:	72 d2                	jb     80104fa0 <kthread_mutex_lock+0x30>
    __sync_synchronize();   // << TODO - not our line!!!

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    return 0;
}
80104fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
                    return -1;
80104fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fd6:	5b                   	pop    %ebx
80104fd7:	5e                   	pop    %esi
80104fd8:	5f                   	pop    %edi
80104fd9:	5d                   	pop    %ebp
80104fda:	c3                   	ret    
80104fdb:	90                   	nop
80104fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            while (m->locked) {
80104fe0:	8b 33                	mov    (%ebx),%esi
80104fe2:	85 f6                	test   %esi,%esi
80104fe4:	75 43                	jne    80105029 <kthread_mutex_lock+0xb9>
80104fe6:	eb 60                	jmp    80105048 <kthread_mutex_lock+0xd8>
80104fe8:	90                   	nop
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                m->waitingCounter++;
80104ff0:	83 43 0c 01          	addl   $0x1,0xc(%ebx)
                acquire(&ptable.lock);
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	68 e0 3e 11 80       	push   $0x80113ee0
80104ffc:	e8 cf 03 00 00       	call   801053d0 <acquire>
                sleep(m->thread, &ptable.lock); //go to sleep on this lock via sleep(m->thread
80105001:	58                   	pop    %eax
80105002:	5a                   	pop    %edx
80105003:	68 e0 3e 11 80       	push   $0x80113ee0
80105008:	ff 73 10             	pushl  0x10(%ebx)
8010500b:	e8 d0 f6 ff ff       	call   801046e0 <sleep>
                release(&ptable.lock);
80105010:	c7 04 24 e0 3e 11 80 	movl   $0x80113ee0,(%esp)
80105017:	e8 84 04 00 00       	call   801054a0 <release>
            while (m->locked) {
8010501c:	8b 0b                	mov    (%ebx),%ecx
                m->waitingCounter--;
8010501e:	83 6b 0c 01          	subl   $0x1,0xc(%ebx)
            while (m->locked) {
80105022:	83 c4 10             	add    $0x10,%esp
80105025:	85 c9                	test   %ecx,%ecx
80105027:	74 1f                	je     80105048 <kthread_mutex_lock+0xd8>
    pushcli();
80105029:	e8 d2 02 00 00       	call   80105300 <pushcli>
    c = mycpu();
8010502e:	e8 0d e9 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80105033:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80105039:	e8 02 03 00 00       	call   80105340 <popcli>
                if(mythread() == m->thread)
8010503e:	39 73 10             	cmp    %esi,0x10(%ebx)
80105041:	75 ad                	jne    80104ff0 <kthread_mutex_lock+0x80>
80105043:	eb 89                	jmp    80104fce <kthread_mutex_lock+0x5e>
80105045:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("lock; xchgl %0, %1" :
80105048:	ba 01 00 00 00       	mov    $0x1,%edx
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
80105050:	89 d0                	mov    %edx,%eax
80105052:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&m->locked, 1) != 0);
80105055:	85 c0                	test   %eax,%eax
80105057:	75 f7                	jne    80105050 <kthread_mutex_lock+0xe0>
    __sync_synchronize();   // << TODO - not our line!!!
80105059:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    pushcli();
8010505e:	e8 9d 02 00 00       	call   80105300 <pushcli>
    c = mycpu();
80105063:	e8 d8 e8 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80105068:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
8010506e:	e8 cd 02 00 00       	call   80105340 <popcli>
    return 0;
80105073:	31 c0                	xor    %eax,%eax
    m->thread = mythread();
80105075:	89 73 10             	mov    %esi,0x10(%ebx)
}
80105078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010507b:	5b                   	pop    %ebx
8010507c:	5e                   	pop    %esi
8010507d:	5f                   	pop    %edi
8010507e:	5d                   	pop    %ebp
8010507f:	c3                   	ret    

80105080 <kthread_mutex_unlock>:

// Release the lock.
int
kthread_mutex_unlock(int mutex_id) {
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
80105085:	53                   	push   %ebx
80105086:	83 ec 1c             	sub    $0x1c,%esp
80105089:	8b 5d 08             	mov    0x8(%ebp),%ebx
    pushcli();
8010508c:	e8 6f 02 00 00       	call   80105300 <pushcli>
    c = mycpu();
80105091:	e8 aa e8 ff ff       	call   80103940 <mycpu>
    p = c->proc;
80105096:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
    popcli();
8010509c:	e8 9f 02 00 00       	call   80105340 <popcli>
    struct kthread_mutex_t *m;
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
801050a1:	81 c7 78 03 00 00    	add    $0x378,%edi
801050a7:	eb 0a                	jmp    801050b3 <kthread_mutex_unlock+0x33>
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b0:	83 c7 3c             	add    $0x3c,%edi
    pushcli();
801050b3:	e8 48 02 00 00       	call   80105300 <pushcli>
    c = mycpu();
801050b8:	e8 83 e8 ff ff       	call   80103940 <mycpu>
    p = c->proc;
801050bd:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801050c3:	e8 78 02 00 00       	call   80105340 <popcli>
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
801050c8:	81 c6 78 12 00 00    	add    $0x1278,%esi
801050ce:	39 f7                	cmp    %esi,%edi
801050d0:	73 76                	jae    80105148 <kthread_mutex_unlock+0xc8>
        if (m->active && m->mid == mutex_id && m->locked && m->thread == mythread())
801050d2:	8b 57 04             	mov    0x4(%edi),%edx
801050d5:	85 d2                	test   %edx,%edx
801050d7:	74 d7                	je     801050b0 <kthread_mutex_unlock+0x30>
801050d9:	39 5f 08             	cmp    %ebx,0x8(%edi)
801050dc:	75 d2                	jne    801050b0 <kthread_mutex_unlock+0x30>
801050de:	8b 07                	mov    (%edi),%eax
801050e0:	85 c0                	test   %eax,%eax
801050e2:	74 cc                	je     801050b0 <kthread_mutex_unlock+0x30>
801050e4:	8b 47 10             	mov    0x10(%edi),%eax
801050e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pushcli();
801050ea:	e8 11 02 00 00       	call   80105300 <pushcli>
    c = mycpu();
801050ef:	e8 4c e8 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
801050f4:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
801050fa:	e8 41 02 00 00       	call   80105340 <popcli>
        if (m->active && m->mid == mutex_id && m->locked && m->thread == mythread())
801050ff:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80105102:	75 ac                	jne    801050b0 <kthread_mutex_unlock+0x30>
    }
    return -1; //didn't find the mutex_id

    unlock_mutex://mutex_id was found

    m->pcs[0] = 0;
80105104:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    m->thread = 0;
8010510b:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that all the stores in the critical
    // section are visible to other cores before the lock is released.
    // Both the C compiler and the hardware may re-order loads and
    // stores; __sync_synchronize() tells them both not to.
    __sync_synchronize();
80105112:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    // Release the lock, equivalent to lk->locked = 0.
    // This code can't use a C assignment, since it might
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );
80105117:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    pushcli();
8010511d:	e8 de 01 00 00       	call   80105300 <pushcli>
    c = mycpu();
80105122:	e8 19 e8 ff ff       	call   80103940 <mycpu>
    t = c->currThread;
80105127:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
8010512d:	e8 0e 02 00 00       	call   80105340 <popcli>

    wakeup(mythread());
80105132:	83 ec 0c             	sub    $0xc,%esp
80105135:	53                   	push   %ebx
80105136:	e8 85 ee ff ff       	call   80103fc0 <wakeup>
    return 0;
8010513b:	83 c4 10             	add    $0x10,%esp
8010513e:	31 c0                	xor    %eax,%eax
80105140:	eb 0b                	jmp    8010514d <kthread_mutex_unlock+0xcd>
80105142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1; //didn't find the mutex_id
80105148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010514d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105150:	5b                   	pop    %ebx
80105151:	5e                   	pop    %esi
80105152:	5f                   	pop    %edi
80105153:	5d                   	pop    %ebp
80105154:	c3                   	ret    
80105155:	66 90                	xchg   %ax,%ax
80105157:	66 90                	xchg   %ax,%ax
80105159:	66 90                	xchg   %ax,%ax
8010515b:	66 90                	xchg   %ax,%ax
8010515d:	66 90                	xchg   %ax,%ax
8010515f:	90                   	nop

80105160 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	53                   	push   %ebx
80105164:	83 ec 0c             	sub    $0xc,%esp
80105167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010516a:	68 10 89 10 80       	push   $0x80108910
8010516f:	8d 43 04             	lea    0x4(%ebx),%eax
80105172:	50                   	push   %eax
80105173:	e8 18 01 00 00       	call   80105290 <initlock>
  lk->name = name;
80105178:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010517b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105181:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105184:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  lk->name = name;
8010518b:	89 43 3c             	mov    %eax,0x3c(%ebx)
}
8010518e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105191:	c9                   	leave  
80105192:	c3                   	ret    
80105193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
801051a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	8d 73 04             	lea    0x4(%ebx),%esi
801051ae:	56                   	push   %esi
801051af:	e8 1c 02 00 00       	call   801053d0 <acquire>
  while (lk->locked) {
801051b4:	8b 13                	mov    (%ebx),%edx
801051b6:	83 c4 10             	add    $0x10,%esp
801051b9:	85 d2                	test   %edx,%edx
801051bb:	74 16                	je     801051d3 <acquiresleep+0x33>
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801051c0:	83 ec 08             	sub    $0x8,%esp
801051c3:	56                   	push   %esi
801051c4:	53                   	push   %ebx
801051c5:	e8 16 f5 ff ff       	call   801046e0 <sleep>
  while (lk->locked) {
801051ca:	8b 03                	mov    (%ebx),%eax
801051cc:	83 c4 10             	add    $0x10,%esp
801051cf:	85 c0                	test   %eax,%eax
801051d1:	75 ed                	jne    801051c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801051d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801051d9:	e8 02 e8 ff ff       	call   801039e0 <myproc>
801051de:	8b 40 0c             	mov    0xc(%eax),%eax
801051e1:	89 43 40             	mov    %eax,0x40(%ebx)
  release(&lk->lk);
801051e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801051e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ea:	5b                   	pop    %ebx
801051eb:	5e                   	pop    %esi
801051ec:	5d                   	pop    %ebp
  release(&lk->lk);
801051ed:	e9 ae 02 00 00       	jmp    801054a0 <release>
801051f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	53                   	push   %ebx
80105205:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105208:	83 ec 0c             	sub    $0xc,%esp
8010520b:	8d 73 04             	lea    0x4(%ebx),%esi
8010520e:	56                   	push   %esi
8010520f:	e8 bc 01 00 00       	call   801053d0 <acquire>
  lk->locked = 0;
80105214:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010521a:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  wakeup(lk);
80105221:	89 1c 24             	mov    %ebx,(%esp)
80105224:	e8 97 ed ff ff       	call   80103fc0 <wakeup>
  release(&lk->lk);
80105229:	89 75 08             	mov    %esi,0x8(%ebp)
8010522c:	83 c4 10             	add    $0x10,%esp
}
8010522f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105232:	5b                   	pop    %ebx
80105233:	5e                   	pop    %esi
80105234:	5d                   	pop    %ebp
  release(&lk->lk);
80105235:	e9 66 02 00 00       	jmp    801054a0 <release>
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105240 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
80105245:	53                   	push   %ebx
80105246:	31 ff                	xor    %edi,%edi
80105248:	83 ec 18             	sub    $0x18,%esp
8010524b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010524e:	8d 73 04             	lea    0x4(%ebx),%esi
80105251:	56                   	push   %esi
80105252:	e8 79 01 00 00       	call   801053d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105257:	8b 03                	mov    (%ebx),%eax
80105259:	83 c4 10             	add    $0x10,%esp
8010525c:	85 c0                	test   %eax,%eax
8010525e:	74 13                	je     80105273 <holdingsleep+0x33>
80105260:	8b 5b 40             	mov    0x40(%ebx),%ebx
80105263:	e8 78 e7 ff ff       	call   801039e0 <myproc>
80105268:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010526b:	0f 94 c0             	sete   %al
8010526e:	0f b6 c0             	movzbl %al,%eax
80105271:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80105273:	83 ec 0c             	sub    $0xc,%esp
80105276:	56                   	push   %esi
80105277:	e8 24 02 00 00       	call   801054a0 <release>
  return r;
}
8010527c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010527f:	89 f8                	mov    %edi,%eax
80105281:	5b                   	pop    %ebx
80105282:	5e                   	pop    %esi
80105283:	5f                   	pop    %edi
80105284:	5d                   	pop    %ebp
80105285:	c3                   	ret    
80105286:	66 90                	xchg   %ax,%ax
80105288:	66 90                	xchg   %ax,%ax
8010528a:	66 90                	xchg   %ax,%ax
8010528c:	66 90                	xchg   %ax,%ax
8010528e:	66 90                	xchg   %ax,%ax

80105290 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105296:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010529f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801052a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
801052a9:	5d                   	pop    %ebp
801052aa:	c3                   	ret    
801052ab:	90                   	nop
801052ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801052b0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801052b1:	31 d2                	xor    %edx,%edx
{
801052b3:	89 e5                	mov    %esp,%ebp
801052b5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801052b6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801052b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801052bc:	83 e8 08             	sub    $0x8,%eax
801052bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052c0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801052c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801052cc:	77 1a                	ja     801052e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801052ce:	8b 58 04             	mov    0x4(%eax),%ebx
801052d1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801052d4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801052d7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801052d9:	83 fa 0a             	cmp    $0xa,%edx
801052dc:	75 e2                	jne    801052c0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801052de:	5b                   	pop    %ebx
801052df:	5d                   	pop    %ebp
801052e0:	c3                   	ret    
801052e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052e8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801052eb:	83 c1 28             	add    $0x28,%ecx
801052ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801052f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801052f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801052f9:	39 c1                	cmp    %eax,%ecx
801052fb:	75 f3                	jne    801052f0 <getcallerpcs+0x40>
}
801052fd:	5b                   	pop    %ebx
801052fe:	5d                   	pop    %ebp
801052ff:	c3                   	ret    

80105300 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	53                   	push   %ebx
80105304:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105307:	9c                   	pushf  
80105308:	5b                   	pop    %ebx
  asm volatile("cli");
80105309:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010530a:	e8 31 e6 ff ff       	call   80103940 <mycpu>
8010530f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105315:	85 c0                	test   %eax,%eax
80105317:	75 11                	jne    8010532a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105319:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010531f:	e8 1c e6 ff ff       	call   80103940 <mycpu>
80105324:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010532a:	e8 11 e6 ff ff       	call   80103940 <mycpu>
8010532f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105336:	83 c4 04             	add    $0x4,%esp
80105339:	5b                   	pop    %ebx
8010533a:	5d                   	pop    %ebp
8010533b:	c3                   	ret    
8010533c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105340 <popcli>:

void
popcli(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105346:	9c                   	pushf  
80105347:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105348:	f6 c4 02             	test   $0x2,%ah
8010534b:	75 35                	jne    80105382 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010534d:	e8 ee e5 ff ff       	call   80103940 <mycpu>
80105352:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105359:	78 34                	js     8010538f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010535b:	e8 e0 e5 ff ff       	call   80103940 <mycpu>
80105360:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105366:	85 d2                	test   %edx,%edx
80105368:	74 06                	je     80105370 <popcli+0x30>
    sti();
}
8010536a:	c9                   	leave  
8010536b:	c3                   	ret    
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105370:	e8 cb e5 ff ff       	call   80103940 <mycpu>
80105375:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010537b:	85 c0                	test   %eax,%eax
8010537d:	74 eb                	je     8010536a <popcli+0x2a>
  asm volatile("sti");
8010537f:	fb                   	sti    
}
80105380:	c9                   	leave  
80105381:	c3                   	ret    
    panic("popcli - interruptible");
80105382:	83 ec 0c             	sub    $0xc,%esp
80105385:	68 1b 89 10 80       	push   $0x8010891b
8010538a:	e8 01 b0 ff ff       	call   80100390 <panic>
    panic("popcli");
8010538f:	83 ec 0c             	sub    $0xc,%esp
80105392:	68 32 89 10 80       	push   $0x80108932
80105397:	e8 f4 af ff ff       	call   80100390 <panic>
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053a0 <holding>:
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	56                   	push   %esi
801053a4:	53                   	push   %ebx
801053a5:	8b 75 08             	mov    0x8(%ebp),%esi
801053a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801053aa:	e8 51 ff ff ff       	call   80105300 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801053af:	8b 06                	mov    (%esi),%eax
801053b1:	85 c0                	test   %eax,%eax
801053b3:	74 10                	je     801053c5 <holding+0x25>
801053b5:	8b 5e 0c             	mov    0xc(%esi),%ebx
801053b8:	e8 83 e5 ff ff       	call   80103940 <mycpu>
801053bd:	39 c3                	cmp    %eax,%ebx
801053bf:	0f 94 c3             	sete   %bl
801053c2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801053c5:	e8 76 ff ff ff       	call   80105340 <popcli>
}
801053ca:	89 d8                	mov    %ebx,%eax
801053cc:	5b                   	pop    %ebx
801053cd:	5e                   	pop    %esi
801053ce:	5d                   	pop    %ebp
801053cf:	c3                   	ret    

801053d0 <acquire>:
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	56                   	push   %esi
801053d4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801053d5:	e8 26 ff ff ff       	call   80105300 <pushcli>
  if(holding(lk)) {
801053da:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	53                   	push   %ebx
801053e1:	e8 ba ff ff ff       	call   801053a0 <holding>
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	85 c0                	test   %eax,%eax
801053eb:	0f 85 83 00 00 00    	jne    80105474 <acquire+0xa4>
801053f1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801053f3:	ba 01 00 00 00       	mov    $0x1,%edx
801053f8:	eb 09                	jmp    80105403 <acquire+0x33>
801053fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105400:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105403:	89 d0                	mov    %edx,%eax
80105405:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105408:	85 c0                	test   %eax,%eax
8010540a:	75 f4                	jne    80105400 <acquire+0x30>
  __sync_synchronize();
8010540c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105411:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105414:	e8 27 e5 ff ff       	call   80103940 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105419:	8d 53 10             	lea    0x10(%ebx),%edx
  lk->cpu = mycpu();
8010541c:	89 43 0c             	mov    %eax,0xc(%ebx)
  ebp = (uint*)v - 2;
8010541f:	89 e8                	mov    %ebp,%eax
80105421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105428:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010542e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105434:	77 1a                	ja     80105450 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105436:	8b 48 04             	mov    0x4(%eax),%ecx
80105439:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010543c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010543f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105441:	83 fe 0a             	cmp    $0xa,%esi
80105444:	75 e2                	jne    80105428 <acquire+0x58>
}
80105446:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105449:	5b                   	pop    %ebx
8010544a:	5e                   	pop    %esi
8010544b:	5d                   	pop    %ebp
8010544c:	c3                   	ret    
8010544d:	8d 76 00             	lea    0x0(%esi),%esi
80105450:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105453:	83 c2 28             	add    $0x28,%edx
80105456:	8d 76 00             	lea    0x0(%esi),%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105466:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105469:	39 d0                	cmp    %edx,%eax
8010546b:	75 f3                	jne    80105460 <acquire+0x90>
}
8010546d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105470:	5b                   	pop    %ebx
80105471:	5e                   	pop    %esi
80105472:	5d                   	pop    %ebp
80105473:	c3                   	ret    
    cprintf(" PANIC, %s \t %s \t %s", lk->name , lk->namee , mythread()->name  );
80105474:	e8 97 e5 ff ff       	call   80103a10 <mythread>
80105479:	83 c0 20             	add    $0x20,%eax
8010547c:	50                   	push   %eax
8010547d:	ff 73 08             	pushl  0x8(%ebx)
80105480:	ff 73 04             	pushl  0x4(%ebx)
80105483:	68 39 89 10 80       	push   $0x80108939
80105488:	e8 d3 b1 ff ff       	call   80100660 <cprintf>
    panic("acquire");
8010548d:	c7 04 24 4e 89 10 80 	movl   $0x8010894e,(%esp)
80105494:	e8 f7 ae ff ff       	call   80100390 <panic>
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054a0 <release>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	53                   	push   %ebx
801054a4:	83 ec 10             	sub    $0x10,%esp
801054a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801054aa:	53                   	push   %ebx
801054ab:	e8 f0 fe ff ff       	call   801053a0 <holding>
801054b0:	83 c4 10             	add    $0x10,%esp
801054b3:	85 c0                	test   %eax,%eax
801054b5:	74 22                	je     801054d9 <release+0x39>
  lk->pcs[0] = 0;
801054b7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  lk->cpu = 0;
801054be:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  __sync_synchronize();
801054c5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801054ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801054d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054d3:	c9                   	leave  
  popcli();
801054d4:	e9 67 fe ff ff       	jmp    80105340 <popcli>
    panic("release");
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	68 56 89 10 80       	push   $0x80108956
801054e1:	e8 aa ae ff ff       	call   80100390 <panic>
801054e6:	66 90                	xchg   %ax,%ax
801054e8:	66 90                	xchg   %ax,%ax
801054ea:	66 90                	xchg   %ax,%ax
801054ec:	66 90                	xchg   %ax,%ax
801054ee:	66 90                	xchg   %ax,%ax

801054f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	53                   	push   %ebx
801054f5:	8b 55 08             	mov    0x8(%ebp),%edx
801054f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801054fb:	f6 c2 03             	test   $0x3,%dl
801054fe:	75 05                	jne    80105505 <memset+0x15>
80105500:	f6 c1 03             	test   $0x3,%cl
80105503:	74 13                	je     80105518 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105505:	89 d7                	mov    %edx,%edi
80105507:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550a:	fc                   	cld    
8010550b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010550d:	5b                   	pop    %ebx
8010550e:	89 d0                	mov    %edx,%eax
80105510:	5f                   	pop    %edi
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    
80105513:	90                   	nop
80105514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105518:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010551c:	c1 e9 02             	shr    $0x2,%ecx
8010551f:	89 f8                	mov    %edi,%eax
80105521:	89 fb                	mov    %edi,%ebx
80105523:	c1 e0 18             	shl    $0x18,%eax
80105526:	c1 e3 10             	shl    $0x10,%ebx
80105529:	09 d8                	or     %ebx,%eax
8010552b:	09 f8                	or     %edi,%eax
8010552d:	c1 e7 08             	shl    $0x8,%edi
80105530:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105532:	89 d7                	mov    %edx,%edi
80105534:	fc                   	cld    
80105535:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105537:	5b                   	pop    %ebx
80105538:	89 d0                	mov    %edx,%eax
8010553a:	5f                   	pop    %edi
8010553b:	5d                   	pop    %ebp
8010553c:	c3                   	ret    
8010553d:	8d 76 00             	lea    0x0(%esi),%esi

80105540 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
80105545:	53                   	push   %ebx
80105546:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105549:	8b 75 08             	mov    0x8(%ebp),%esi
8010554c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010554f:	85 db                	test   %ebx,%ebx
80105551:	74 29                	je     8010557c <memcmp+0x3c>
    if(*s1 != *s2)
80105553:	0f b6 16             	movzbl (%esi),%edx
80105556:	0f b6 0f             	movzbl (%edi),%ecx
80105559:	38 d1                	cmp    %dl,%cl
8010555b:	75 2b                	jne    80105588 <memcmp+0x48>
8010555d:	b8 01 00 00 00       	mov    $0x1,%eax
80105562:	eb 14                	jmp    80105578 <memcmp+0x38>
80105564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105568:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010556c:	83 c0 01             	add    $0x1,%eax
8010556f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105574:	38 ca                	cmp    %cl,%dl
80105576:	75 10                	jne    80105588 <memcmp+0x48>
  while(n-- > 0){
80105578:	39 d8                	cmp    %ebx,%eax
8010557a:	75 ec                	jne    80105568 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010557c:	5b                   	pop    %ebx
  return 0;
8010557d:	31 c0                	xor    %eax,%eax
}
8010557f:	5e                   	pop    %esi
80105580:	5f                   	pop    %edi
80105581:	5d                   	pop    %ebp
80105582:	c3                   	ret    
80105583:	90                   	nop
80105584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105588:	0f b6 c2             	movzbl %dl,%eax
}
8010558b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010558c:	29 c8                	sub    %ecx,%eax
}
8010558e:	5e                   	pop    %esi
8010558f:	5f                   	pop    %edi
80105590:	5d                   	pop    %ebp
80105591:	c3                   	ret    
80105592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	56                   	push   %esi
801055a4:	53                   	push   %ebx
801055a5:	8b 45 08             	mov    0x8(%ebp),%eax
801055a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801055ab:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801055ae:	39 c3                	cmp    %eax,%ebx
801055b0:	73 26                	jae    801055d8 <memmove+0x38>
801055b2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801055b5:	39 c8                	cmp    %ecx,%eax
801055b7:	73 1f                	jae    801055d8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801055b9:	85 f6                	test   %esi,%esi
801055bb:	8d 56 ff             	lea    -0x1(%esi),%edx
801055be:	74 0f                	je     801055cf <memmove+0x2f>
      *--d = *--s;
801055c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801055c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801055c7:	83 ea 01             	sub    $0x1,%edx
801055ca:	83 fa ff             	cmp    $0xffffffff,%edx
801055cd:	75 f1                	jne    801055c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801055cf:	5b                   	pop    %ebx
801055d0:	5e                   	pop    %esi
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    
801055d3:	90                   	nop
801055d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801055d8:	31 d2                	xor    %edx,%edx
801055da:	85 f6                	test   %esi,%esi
801055dc:	74 f1                	je     801055cf <memmove+0x2f>
801055de:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801055e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801055e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801055e7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801055ea:	39 d6                	cmp    %edx,%esi
801055ec:	75 f2                	jne    801055e0 <memmove+0x40>
}
801055ee:	5b                   	pop    %ebx
801055ef:	5e                   	pop    %esi
801055f0:	5d                   	pop    %ebp
801055f1:	c3                   	ret    
801055f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105603:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105604:	eb 9a                	jmp    801055a0 <memmove>
80105606:	8d 76 00             	lea    0x0(%esi),%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	8b 7d 10             	mov    0x10(%ebp),%edi
80105618:	53                   	push   %ebx
80105619:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010561c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010561f:	85 ff                	test   %edi,%edi
80105621:	74 2f                	je     80105652 <strncmp+0x42>
80105623:	0f b6 01             	movzbl (%ecx),%eax
80105626:	0f b6 1e             	movzbl (%esi),%ebx
80105629:	84 c0                	test   %al,%al
8010562b:	74 37                	je     80105664 <strncmp+0x54>
8010562d:	38 c3                	cmp    %al,%bl
8010562f:	75 33                	jne    80105664 <strncmp+0x54>
80105631:	01 f7                	add    %esi,%edi
80105633:	eb 13                	jmp    80105648 <strncmp+0x38>
80105635:	8d 76 00             	lea    0x0(%esi),%esi
80105638:	0f b6 01             	movzbl (%ecx),%eax
8010563b:	84 c0                	test   %al,%al
8010563d:	74 21                	je     80105660 <strncmp+0x50>
8010563f:	0f b6 1a             	movzbl (%edx),%ebx
80105642:	89 d6                	mov    %edx,%esi
80105644:	38 d8                	cmp    %bl,%al
80105646:	75 1c                	jne    80105664 <strncmp+0x54>
    n--, p++, q++;
80105648:	8d 56 01             	lea    0x1(%esi),%edx
8010564b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010564e:	39 fa                	cmp    %edi,%edx
80105650:	75 e6                	jne    80105638 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105652:	5b                   	pop    %ebx
    return 0;
80105653:	31 c0                	xor    %eax,%eax
}
80105655:	5e                   	pop    %esi
80105656:	5f                   	pop    %edi
80105657:	5d                   	pop    %ebp
80105658:	c3                   	ret    
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105660:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105664:	29 d8                	sub    %ebx,%eax
}
80105666:	5b                   	pop    %ebx
80105667:	5e                   	pop    %esi
80105668:	5f                   	pop    %edi
80105669:	5d                   	pop    %ebp
8010566a:	c3                   	ret    
8010566b:	90                   	nop
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	56                   	push   %esi
80105674:	53                   	push   %ebx
80105675:	8b 45 08             	mov    0x8(%ebp),%eax
80105678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010567b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010567e:	89 c2                	mov    %eax,%edx
80105680:	eb 19                	jmp    8010569b <strncpy+0x2b>
80105682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105688:	83 c3 01             	add    $0x1,%ebx
8010568b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010568f:	83 c2 01             	add    $0x1,%edx
80105692:	84 c9                	test   %cl,%cl
80105694:	88 4a ff             	mov    %cl,-0x1(%edx)
80105697:	74 09                	je     801056a2 <strncpy+0x32>
80105699:	89 f1                	mov    %esi,%ecx
8010569b:	85 c9                	test   %ecx,%ecx
8010569d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801056a0:	7f e6                	jg     80105688 <strncpy+0x18>
    ;
  while(n-- > 0)
801056a2:	31 c9                	xor    %ecx,%ecx
801056a4:	85 f6                	test   %esi,%esi
801056a6:	7e 17                	jle    801056bf <strncpy+0x4f>
801056a8:	90                   	nop
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801056b0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801056b4:	89 f3                	mov    %esi,%ebx
801056b6:	83 c1 01             	add    $0x1,%ecx
801056b9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801056bb:	85 db                	test   %ebx,%ebx
801056bd:	7f f1                	jg     801056b0 <strncpy+0x40>
  return os;
}
801056bf:	5b                   	pop    %ebx
801056c0:	5e                   	pop    %esi
801056c1:	5d                   	pop    %ebp
801056c2:	c3                   	ret    
801056c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	56                   	push   %esi
801056d4:	53                   	push   %ebx
801056d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801056d8:	8b 45 08             	mov    0x8(%ebp),%eax
801056db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801056de:	85 c9                	test   %ecx,%ecx
801056e0:	7e 26                	jle    80105708 <safestrcpy+0x38>
801056e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801056e6:	89 c1                	mov    %eax,%ecx
801056e8:	eb 17                	jmp    80105701 <safestrcpy+0x31>
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801056f0:	83 c2 01             	add    $0x1,%edx
801056f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801056f7:	83 c1 01             	add    $0x1,%ecx
801056fa:	84 db                	test   %bl,%bl
801056fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801056ff:	74 04                	je     80105705 <safestrcpy+0x35>
80105701:	39 f2                	cmp    %esi,%edx
80105703:	75 eb                	jne    801056f0 <safestrcpy+0x20>
    ;
  *s = 0;
80105705:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105708:	5b                   	pop    %ebx
80105709:	5e                   	pop    %esi
8010570a:	5d                   	pop    %ebp
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <strlen>:

int
strlen(const char *s)
{
80105710:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105711:	31 c0                	xor    %eax,%eax
{
80105713:	89 e5                	mov    %esp,%ebp
80105715:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105718:	80 3a 00             	cmpb   $0x0,(%edx)
8010571b:	74 0c                	je     80105729 <strlen+0x19>
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
80105720:	83 c0 01             	add    $0x1,%eax
80105723:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105727:	75 f7                	jne    80105720 <strlen+0x10>
    ;
  return n;
}
80105729:	5d                   	pop    %ebp
8010572a:	c3                   	ret    

8010572b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010572b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010572f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105733:	55                   	push   %ebp
  pushl %ebx
80105734:	53                   	push   %ebx
  pushl %esi
80105735:	56                   	push   %esi
  pushl %edi
80105736:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105737:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105739:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010573b:	5f                   	pop    %edi
  popl %esi
8010573c:	5e                   	pop    %esi
  popl %ebx
8010573d:	5b                   	pop    %ebx
  popl %ebp
8010573e:	5d                   	pop    %ebp
  ret
8010573f:	c3                   	ret    

80105740 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	53                   	push   %ebx
80105744:	83 ec 04             	sub    $0x4,%esp
80105747:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
8010574a:	e8 91 e2 ff ff       	call   801039e0 <myproc>

    if(addr >= curproc->sz || addr+4 > curproc->sz)
8010574f:	8b 00                	mov    (%eax),%eax
80105751:	39 d8                	cmp    %ebx,%eax
80105753:	76 1b                	jbe    80105770 <fetchint+0x30>
80105755:	8d 53 04             	lea    0x4(%ebx),%edx
80105758:	39 d0                	cmp    %edx,%eax
8010575a:	72 14                	jb     80105770 <fetchint+0x30>
        return -1;
    *ip = *(int*)(addr);
8010575c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010575f:	8b 13                	mov    (%ebx),%edx
80105761:	89 10                	mov    %edx,(%eax)
    return 0;
80105763:	31 c0                	xor    %eax,%eax
}
80105765:	83 c4 04             	add    $0x4,%esp
80105768:	5b                   	pop    %ebx
80105769:	5d                   	pop    %ebp
8010576a:	c3                   	ret    
8010576b:	90                   	nop
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105775:	eb ee                	jmp    80105765 <fetchint+0x25>
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 04             	sub    $0x4,%esp
80105787:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
8010578a:	e8 51 e2 ff ff       	call   801039e0 <myproc>

    if(addr >= curproc->sz)
8010578f:	39 18                	cmp    %ebx,(%eax)
80105791:	76 29                	jbe    801057bc <fetchstr+0x3c>
        return -1;
    *pp = (char*)addr;
80105793:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105796:	89 da                	mov    %ebx,%edx
80105798:	89 19                	mov    %ebx,(%ecx)
    ep = (char*)curproc->sz;
8010579a:	8b 00                	mov    (%eax),%eax
    for(s = *pp; s < ep; s++){
8010579c:	39 c3                	cmp    %eax,%ebx
8010579e:	73 1c                	jae    801057bc <fetchstr+0x3c>
        if(*s == 0)
801057a0:	80 3b 00             	cmpb   $0x0,(%ebx)
801057a3:	75 10                	jne    801057b5 <fetchstr+0x35>
801057a5:	eb 39                	jmp    801057e0 <fetchstr+0x60>
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801057b0:	80 3a 00             	cmpb   $0x0,(%edx)
801057b3:	74 1b                	je     801057d0 <fetchstr+0x50>
    for(s = *pp; s < ep; s++){
801057b5:	83 c2 01             	add    $0x1,%edx
801057b8:	39 d0                	cmp    %edx,%eax
801057ba:	77 f4                	ja     801057b0 <fetchstr+0x30>
        return -1;
801057bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return s - *pp;
    }
    return -1;
}
801057c1:	83 c4 04             	add    $0x4,%esp
801057c4:	5b                   	pop    %ebx
801057c5:	5d                   	pop    %ebp
801057c6:	c3                   	ret    
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801057d0:	83 c4 04             	add    $0x4,%esp
801057d3:	89 d0                	mov    %edx,%eax
801057d5:	29 d8                	sub    %ebx,%eax
801057d7:	5b                   	pop    %ebx
801057d8:	5d                   	pop    %ebp
801057d9:	c3                   	ret    
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(*s == 0)
801057e0:	31 c0                	xor    %eax,%eax
            return s - *pp;
801057e2:	eb dd                	jmp    801057c1 <fetchstr+0x41>
801057e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801057f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	56                   	push   %esi
801057f4:	53                   	push   %ebx
    return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
801057f5:	e8 16 e2 ff ff       	call   80103a10 <mythread>
801057fa:	8b 40 10             	mov    0x10(%eax),%eax
801057fd:	8b 55 08             	mov    0x8(%ebp),%edx
80105800:	8b 40 44             	mov    0x44(%eax),%eax
80105803:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
80105806:	e8 d5 e1 ff ff       	call   801039e0 <myproc>
    if(addr >= curproc->sz || addr+4 > curproc->sz)
8010580b:	8b 00                	mov    (%eax),%eax
    return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
8010580d:	8d 73 04             	lea    0x4(%ebx),%esi
    if(addr >= curproc->sz || addr+4 > curproc->sz)
80105810:	39 c6                	cmp    %eax,%esi
80105812:	73 1c                	jae    80105830 <argint+0x40>
80105814:	8d 53 08             	lea    0x8(%ebx),%edx
80105817:	39 d0                	cmp    %edx,%eax
80105819:	72 15                	jb     80105830 <argint+0x40>
    *ip = *(int*)(addr);
8010581b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010581e:	8b 53 04             	mov    0x4(%ebx),%edx
80105821:	89 10                	mov    %edx,(%eax)
    return 0;
80105823:	31 c0                	xor    %eax,%eax
}
80105825:	5b                   	pop    %ebx
80105826:	5e                   	pop    %esi
80105827:	5d                   	pop    %ebp
80105828:	c3                   	ret    
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80105835:	eb ee                	jmp    80105825 <argint+0x35>
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	56                   	push   %esi
80105844:	53                   	push   %ebx
80105845:	83 ec 10             	sub    $0x10,%esp
80105848:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
8010584b:	e8 90 e1 ff ff       	call   801039e0 <myproc>
80105850:	89 c6                	mov    %eax,%esi

    if(argint(n, &i) < 0)
80105852:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105855:	83 ec 08             	sub    $0x8,%esp
80105858:	50                   	push   %eax
80105859:	ff 75 08             	pushl  0x8(%ebp)
8010585c:	e8 8f ff ff ff       	call   801057f0 <argint>
        return -1;
    if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105861:	83 c4 10             	add    $0x10,%esp
80105864:	85 c0                	test   %eax,%eax
80105866:	78 28                	js     80105890 <argptr+0x50>
80105868:	85 db                	test   %ebx,%ebx
8010586a:	78 24                	js     80105890 <argptr+0x50>
8010586c:	8b 16                	mov    (%esi),%edx
8010586e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105871:	39 c2                	cmp    %eax,%edx
80105873:	76 1b                	jbe    80105890 <argptr+0x50>
80105875:	01 c3                	add    %eax,%ebx
80105877:	39 da                	cmp    %ebx,%edx
80105879:	72 15                	jb     80105890 <argptr+0x50>
        return -1;
    *pp = (char*)i;
8010587b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010587e:	89 02                	mov    %eax,(%edx)
    return 0;
80105880:	31 c0                	xor    %eax,%eax
}
80105882:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105885:	5b                   	pop    %ebx
80105886:	5e                   	pop    %esi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105895:	eb eb                	jmp    80105882 <argptr+0x42>
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if(argint(n, &addr) < 0)
801058a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a9:	50                   	push   %eax
801058aa:	ff 75 08             	pushl  0x8(%ebp)
801058ad:	e8 3e ff ff ff       	call   801057f0 <argint>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 17                	js     801058d0 <argstr+0x30>
        return -1;
    return fetchstr(addr, pp);
801058b9:	83 ec 08             	sub    $0x8,%esp
801058bc:	ff 75 0c             	pushl  0xc(%ebp)
801058bf:	ff 75 f4             	pushl  -0xc(%ebp)
801058c2:	e8 b9 fe ff ff       	call   80105780 <fetchstr>
801058c7:	83 c4 10             	add    $0x10,%esp
}
801058ca:	c9                   	leave  
801058cb:	c3                   	ret    
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <syscall>:
         */
};

void
syscall(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	56                   	push   %esi
801058e4:	53                   	push   %ebx
    int num;
    struct proc *curproc = myproc();
801058e5:	e8 f6 e0 ff ff       	call   801039e0 <myproc>
801058ea:	89 c6                	mov    %eax,%esi
    struct thread *curthread = mythread();
801058ec:	e8 1f e1 ff ff       	call   80103a10 <mythread>
801058f1:	89 c3                	mov    %eax,%ebx

    num = curthread->tf->eax;
801058f3:	8b 40 10             	mov    0x10(%eax),%eax
801058f6:	8b 40 1c             	mov    0x1c(%eax),%eax
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801058f9:	8d 50 ff             	lea    -0x1(%eax),%edx
801058fc:	83 fa 1d             	cmp    $0x1d,%edx
801058ff:	77 1f                	ja     80105920 <syscall+0x40>
80105901:	8b 14 85 80 89 10 80 	mov    -0x7fef7680(,%eax,4),%edx
80105908:	85 d2                	test   %edx,%edx
8010590a:	74 14                	je     80105920 <syscall+0x40>
        curthread->tf->eax = syscalls[num]();
8010590c:	ff d2                	call   *%edx
8010590e:	8b 53 10             	mov    0x10(%ebx),%edx
80105911:	89 42 1c             	mov    %eax,0x1c(%edx)
    } else {
        cprintf("%d %s: unknown sys call %d\n",
                curproc->pid, curproc->name, num);
        curthread->tf->eax = -1;
    }
}
80105914:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105917:	5b                   	pop    %ebx
80105918:	5e                   	pop    %esi
80105919:	5d                   	pop    %ebp
8010591a:	c3                   	ret    
8010591b:	90                   	nop
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%d %s: unknown sys call %d\n",
80105920:	50                   	push   %eax
                curproc->pid, curproc->name, num);
80105921:	8d 46 64             	lea    0x64(%esi),%eax
        cprintf("%d %s: unknown sys call %d\n",
80105924:	50                   	push   %eax
80105925:	ff 76 0c             	pushl  0xc(%esi)
80105928:	68 5e 89 10 80       	push   $0x8010895e
8010592d:	e8 2e ad ff ff       	call   80100660 <cprintf>
        curthread->tf->eax = -1;
80105932:	8b 43 10             	mov    0x10(%ebx),%eax
80105935:	83 c4 10             	add    $0x10,%esp
80105938:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010593f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105942:	5b                   	pop    %ebx
80105943:	5e                   	pop    %esi
80105944:	5d                   	pop    %ebp
80105945:	c3                   	ret    
80105946:	66 90                	xchg   %ax,%ax
80105948:	66 90                	xchg   %ax,%ax
8010594a:	66 90                	xchg   %ax,%ax
8010594c:	66 90                	xchg   %ax,%ax
8010594e:	66 90                	xchg   %ax,%ax

80105950 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	57                   	push   %edi
80105954:	56                   	push   %esi
80105955:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105956:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105959:	83 ec 44             	sub    $0x44,%esp
8010595c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010595f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105962:	56                   	push   %esi
80105963:	50                   	push   %eax
{
80105964:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105967:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010596a:	e8 31 c6 ff ff       	call   80101fa0 <nameiparent>
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	85 c0                	test   %eax,%eax
80105974:	0f 84 46 01 00 00    	je     80105ac0 <create+0x170>
    return 0;
  ilock(dp);
8010597a:	83 ec 0c             	sub    $0xc,%esp
8010597d:	89 c3                	mov    %eax,%ebx
8010597f:	50                   	push   %eax
80105980:	e8 9b bd ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105985:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105988:	83 c4 0c             	add    $0xc,%esp
8010598b:	50                   	push   %eax
8010598c:	56                   	push   %esi
8010598d:	53                   	push   %ebx
8010598e:	e8 bd c2 ff ff       	call   80101c50 <dirlookup>
80105993:	83 c4 10             	add    $0x10,%esp
80105996:	85 c0                	test   %eax,%eax
80105998:	89 c7                	mov    %eax,%edi
8010599a:	74 34                	je     801059d0 <create+0x80>
    iunlockput(dp);
8010599c:	83 ec 0c             	sub    $0xc,%esp
8010599f:	53                   	push   %ebx
801059a0:	e8 0b c0 ff ff       	call   801019b0 <iunlockput>
    ilock(ip);
801059a5:	89 3c 24             	mov    %edi,(%esp)
801059a8:	e8 73 bd ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801059b5:	0f 85 95 00 00 00    	jne    80105a50 <create+0x100>
801059bb:	66 83 7f 54 02       	cmpw   $0x2,0x54(%edi)
801059c0:	0f 85 8a 00 00 00    	jne    80105a50 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801059c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059c9:	89 f8                	mov    %edi,%eax
801059cb:	5b                   	pop    %ebx
801059cc:	5e                   	pop    %esi
801059cd:	5f                   	pop    %edi
801059ce:	5d                   	pop    %ebp
801059cf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801059d0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801059d4:	83 ec 08             	sub    $0x8,%esp
801059d7:	50                   	push   %eax
801059d8:	ff 33                	pushl  (%ebx)
801059da:	e8 d1 bb ff ff       	call   801015b0 <ialloc>
801059df:	83 c4 10             	add    $0x10,%esp
801059e2:	85 c0                	test   %eax,%eax
801059e4:	89 c7                	mov    %eax,%edi
801059e6:	0f 84 e8 00 00 00    	je     80105ad4 <create+0x184>
  ilock(ip);
801059ec:	83 ec 0c             	sub    $0xc,%esp
801059ef:	50                   	push   %eax
801059f0:	e8 2b bd ff ff       	call   80101720 <ilock>
  ip->major = major;
801059f5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801059f9:	66 89 47 56          	mov    %ax,0x56(%edi)
  ip->minor = minor;
801059fd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105a01:	66 89 47 58          	mov    %ax,0x58(%edi)
  ip->nlink = 1;
80105a05:	b8 01 00 00 00       	mov    $0x1,%eax
80105a0a:	66 89 47 5a          	mov    %ax,0x5a(%edi)
  iupdate(ip);
80105a0e:	89 3c 24             	mov    %edi,(%esp)
80105a11:	e8 5a bc ff ff       	call   80101670 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80105a1e:	74 50                	je     80105a70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105a20:	83 ec 04             	sub    $0x4,%esp
80105a23:	ff 77 04             	pushl  0x4(%edi)
80105a26:	56                   	push   %esi
80105a27:	53                   	push   %ebx
80105a28:	e8 93 c4 ff ff       	call   80101ec0 <dirlink>
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	85 c0                	test   %eax,%eax
80105a32:	0f 88 8f 00 00 00    	js     80105ac7 <create+0x177>
  iunlockput(dp);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	53                   	push   %ebx
80105a3c:	e8 6f bf ff ff       	call   801019b0 <iunlockput>
  return ip;
80105a41:	83 c4 10             	add    $0x10,%esp
}
80105a44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a47:	89 f8                	mov    %edi,%eax
80105a49:	5b                   	pop    %ebx
80105a4a:	5e                   	pop    %esi
80105a4b:	5f                   	pop    %edi
80105a4c:	5d                   	pop    %ebp
80105a4d:	c3                   	ret    
80105a4e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	57                   	push   %edi
    return 0;
80105a54:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105a56:	e8 55 bf ff ff       	call   801019b0 <iunlockput>
    return 0;
80105a5b:	83 c4 10             	add    $0x10,%esp
}
80105a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a61:	89 f8                	mov    %edi,%eax
80105a63:	5b                   	pop    %ebx
80105a64:	5e                   	pop    %esi
80105a65:	5f                   	pop    %edi
80105a66:	5d                   	pop    %ebp
80105a67:	c3                   	ret    
80105a68:	90                   	nop
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105a70:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
    iupdate(dp);
80105a75:	83 ec 0c             	sub    $0xc,%esp
80105a78:	53                   	push   %ebx
80105a79:	e8 f2 bb ff ff       	call   80101670 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105a7e:	83 c4 0c             	add    $0xc,%esp
80105a81:	ff 77 04             	pushl  0x4(%edi)
80105a84:	68 18 8a 10 80       	push   $0x80108a18
80105a89:	57                   	push   %edi
80105a8a:	e8 31 c4 ff ff       	call   80101ec0 <dirlink>
80105a8f:	83 c4 10             	add    $0x10,%esp
80105a92:	85 c0                	test   %eax,%eax
80105a94:	78 1c                	js     80105ab2 <create+0x162>
80105a96:	83 ec 04             	sub    $0x4,%esp
80105a99:	ff 73 04             	pushl  0x4(%ebx)
80105a9c:	68 17 8a 10 80       	push   $0x80108a17
80105aa1:	57                   	push   %edi
80105aa2:	e8 19 c4 ff ff       	call   80101ec0 <dirlink>
80105aa7:	83 c4 10             	add    $0x10,%esp
80105aaa:	85 c0                	test   %eax,%eax
80105aac:	0f 89 6e ff ff ff    	jns    80105a20 <create+0xd0>
      panic("create dots");
80105ab2:	83 ec 0c             	sub    $0xc,%esp
80105ab5:	68 0b 8a 10 80       	push   $0x80108a0b
80105aba:	e8 d1 a8 ff ff       	call   80100390 <panic>
80105abf:	90                   	nop
    return 0;
80105ac0:	31 ff                	xor    %edi,%edi
80105ac2:	e9 ff fe ff ff       	jmp    801059c6 <create+0x76>
    panic("create: dirlink");
80105ac7:	83 ec 0c             	sub    $0xc,%esp
80105aca:	68 1a 8a 10 80       	push   $0x80108a1a
80105acf:	e8 bc a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105ad4:	83 ec 0c             	sub    $0xc,%esp
80105ad7:	68 fc 89 10 80       	push   $0x801089fc
80105adc:	e8 af a8 ff ff       	call   80100390 <panic>
80105ae1:	eb 0d                	jmp    80105af0 <argfd.constprop.0>
80105ae3:	90                   	nop
80105ae4:	90                   	nop
80105ae5:	90                   	nop
80105ae6:	90                   	nop
80105ae7:	90                   	nop
80105ae8:	90                   	nop
80105ae9:	90                   	nop
80105aea:	90                   	nop
80105aeb:	90                   	nop
80105aec:	90                   	nop
80105aed:	90                   	nop
80105aee:	90                   	nop
80105aef:	90                   	nop

80105af0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	56                   	push   %esi
80105af4:	53                   	push   %ebx
80105af5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105af7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105afa:	89 d6                	mov    %edx,%esi
80105afc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105aff:	50                   	push   %eax
80105b00:	6a 00                	push   $0x0
80105b02:	e8 e9 fc ff ff       	call   801057f0 <argint>
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	78 2a                	js     80105b38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105b0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105b12:	77 24                	ja     80105b38 <argfd.constprop.0+0x48>
80105b14:	e8 c7 de ff ff       	call   801039e0 <myproc>
80105b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b1c:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
80105b20:	85 c0                	test   %eax,%eax
80105b22:	74 14                	je     80105b38 <argfd.constprop.0+0x48>
  if(pfd)
80105b24:	85 db                	test   %ebx,%ebx
80105b26:	74 02                	je     80105b2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105b28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105b2a:	89 06                	mov    %eax,(%esi)
  return 0;
80105b2c:	31 c0                	xor    %eax,%eax
}
80105b2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b31:	5b                   	pop    %ebx
80105b32:	5e                   	pop    %esi
80105b33:	5d                   	pop    %ebp
80105b34:	c3                   	ret    
80105b35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3d:	eb ef                	jmp    80105b2e <argfd.constprop.0+0x3e>
80105b3f:	90                   	nop

80105b40 <sys_dup>:
{
80105b40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105b41:	31 c0                	xor    %eax,%eax
{
80105b43:	89 e5                	mov    %esp,%ebp
80105b45:	56                   	push   %esi
80105b46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105b47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105b4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105b4d:	e8 9e ff ff ff       	call   80105af0 <argfd.constprop.0>
80105b52:	85 c0                	test   %eax,%eax
80105b54:	78 42                	js     80105b98 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105b56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b5b:	e8 80 de ff ff       	call   801039e0 <myproc>
80105b60:	eb 0e                	jmp    80105b70 <sys_dup+0x30>
80105b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b68:	83 c3 01             	add    $0x1,%ebx
80105b6b:	83 fb 10             	cmp    $0x10,%ebx
80105b6e:	74 28                	je     80105b98 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105b70:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105b74:	85 d2                	test   %edx,%edx
80105b76:	75 f0                	jne    80105b68 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105b78:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
  filedup(f);
80105b7c:	83 ec 0c             	sub    $0xc,%esp
80105b7f:	ff 75 f4             	pushl  -0xc(%ebp)
80105b82:	e8 f9 b2 ff ff       	call   80100e80 <filedup>
  return fd;
80105b87:	83 c4 10             	add    $0x10,%esp
}
80105b8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b8d:	89 d8                	mov    %ebx,%eax
80105b8f:	5b                   	pop    %ebx
80105b90:	5e                   	pop    %esi
80105b91:	5d                   	pop    %ebp
80105b92:	c3                   	ret    
80105b93:	90                   	nop
80105b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b98:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105b9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105ba0:	89 d8                	mov    %ebx,%eax
80105ba2:	5b                   	pop    %ebx
80105ba3:	5e                   	pop    %esi
80105ba4:	5d                   	pop    %ebp
80105ba5:	c3                   	ret    
80105ba6:	8d 76 00             	lea    0x0(%esi),%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bb0 <sys_read>:
{
80105bb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bb1:	31 c0                	xor    %eax,%eax
{
80105bb3:	89 e5                	mov    %esp,%ebp
80105bb5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105bbb:	e8 30 ff ff ff       	call   80105af0 <argfd.constprop.0>
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	78 4c                	js     80105c10 <sys_read+0x60>
80105bc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bc7:	83 ec 08             	sub    $0x8,%esp
80105bca:	50                   	push   %eax
80105bcb:	6a 02                	push   $0x2
80105bcd:	e8 1e fc ff ff       	call   801057f0 <argint>
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	78 37                	js     80105c10 <sys_read+0x60>
80105bd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bdc:	83 ec 04             	sub    $0x4,%esp
80105bdf:	ff 75 f0             	pushl  -0x10(%ebp)
80105be2:	50                   	push   %eax
80105be3:	6a 01                	push   $0x1
80105be5:	e8 56 fc ff ff       	call   80105840 <argptr>
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	85 c0                	test   %eax,%eax
80105bef:	78 1f                	js     80105c10 <sys_read+0x60>
  return fileread(f, p, n);
80105bf1:	83 ec 04             	sub    $0x4,%esp
80105bf4:	ff 75 f0             	pushl  -0x10(%ebp)
80105bf7:	ff 75 f4             	pushl  -0xc(%ebp)
80105bfa:	ff 75 ec             	pushl  -0x14(%ebp)
80105bfd:	e8 ee b3 ff ff       	call   80100ff0 <fileread>
80105c02:	83 c4 10             	add    $0x10,%esp
}
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    
80105c17:	89 f6                	mov    %esi,%esi
80105c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c20 <sys_write>:
{
80105c20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c21:	31 c0                	xor    %eax,%eax
{
80105c23:	89 e5                	mov    %esp,%ebp
80105c25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105c2b:	e8 c0 fe ff ff       	call   80105af0 <argfd.constprop.0>
80105c30:	85 c0                	test   %eax,%eax
80105c32:	78 4c                	js     80105c80 <sys_write+0x60>
80105c34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c37:	83 ec 08             	sub    $0x8,%esp
80105c3a:	50                   	push   %eax
80105c3b:	6a 02                	push   $0x2
80105c3d:	e8 ae fb ff ff       	call   801057f0 <argint>
80105c42:	83 c4 10             	add    $0x10,%esp
80105c45:	85 c0                	test   %eax,%eax
80105c47:	78 37                	js     80105c80 <sys_write+0x60>
80105c49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c4c:	83 ec 04             	sub    $0x4,%esp
80105c4f:	ff 75 f0             	pushl  -0x10(%ebp)
80105c52:	50                   	push   %eax
80105c53:	6a 01                	push   $0x1
80105c55:	e8 e6 fb ff ff       	call   80105840 <argptr>
80105c5a:	83 c4 10             	add    $0x10,%esp
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	78 1f                	js     80105c80 <sys_write+0x60>
  return filewrite(f, p, n);
80105c61:	83 ec 04             	sub    $0x4,%esp
80105c64:	ff 75 f0             	pushl  -0x10(%ebp)
80105c67:	ff 75 f4             	pushl  -0xc(%ebp)
80105c6a:	ff 75 ec             	pushl  -0x14(%ebp)
80105c6d:	e8 0e b4 ff ff       	call   80101080 <filewrite>
80105c72:	83 c4 10             	add    $0x10,%esp
}
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c85:	c9                   	leave  
80105c86:	c3                   	ret    
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c90 <sys_close>:
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105c96:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105c99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c9c:	e8 4f fe ff ff       	call   80105af0 <argfd.constprop.0>
80105ca1:	85 c0                	test   %eax,%eax
80105ca3:	78 2b                	js     80105cd0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105ca5:	e8 36 dd ff ff       	call   801039e0 <myproc>
80105caa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105cad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105cb0:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
80105cb7:	00 
  fileclose(f);
80105cb8:	ff 75 f4             	pushl  -0xc(%ebp)
80105cbb:	e8 10 b2 ff ff       	call   80100ed0 <fileclose>
  return 0;
80105cc0:	83 c4 10             	add    $0x10,%esp
80105cc3:	31 c0                	xor    %eax,%eax
}
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    
80105cc7:	89 f6                	mov    %esi,%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cd5:	c9                   	leave  
80105cd6:	c3                   	ret    
80105cd7:	89 f6                	mov    %esi,%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ce0 <sys_fstat>:
{
80105ce0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ce1:	31 c0                	xor    %eax,%eax
{
80105ce3:	89 e5                	mov    %esp,%ebp
80105ce5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ce8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105ceb:	e8 00 fe ff ff       	call   80105af0 <argfd.constprop.0>
80105cf0:	85 c0                	test   %eax,%eax
80105cf2:	78 2c                	js     80105d20 <sys_fstat+0x40>
80105cf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cf7:	83 ec 04             	sub    $0x4,%esp
80105cfa:	6a 14                	push   $0x14
80105cfc:	50                   	push   %eax
80105cfd:	6a 01                	push   $0x1
80105cff:	e8 3c fb ff ff       	call   80105840 <argptr>
80105d04:	83 c4 10             	add    $0x10,%esp
80105d07:	85 c0                	test   %eax,%eax
80105d09:	78 15                	js     80105d20 <sys_fstat+0x40>
  return filestat(f, st);
80105d0b:	83 ec 08             	sub    $0x8,%esp
80105d0e:	ff 75 f4             	pushl  -0xc(%ebp)
80105d11:	ff 75 f0             	pushl  -0x10(%ebp)
80105d14:	e8 87 b2 ff ff       	call   80100fa0 <filestat>
80105d19:	83 c4 10             	add    $0x10,%esp
}
80105d1c:	c9                   	leave  
80105d1d:	c3                   	ret    
80105d1e:	66 90                	xchg   %ax,%ax
    return -1;
80105d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <sys_link>:
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
80105d35:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d36:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105d39:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d3c:	50                   	push   %eax
80105d3d:	6a 00                	push   $0x0
80105d3f:	e8 5c fb ff ff       	call   801058a0 <argstr>
80105d44:	83 c4 10             	add    $0x10,%esp
80105d47:	85 c0                	test   %eax,%eax
80105d49:	0f 88 fb 00 00 00    	js     80105e4a <sys_link+0x11a>
80105d4f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105d52:	83 ec 08             	sub    $0x8,%esp
80105d55:	50                   	push   %eax
80105d56:	6a 01                	push   $0x1
80105d58:	e8 43 fb ff ff       	call   801058a0 <argstr>
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	85 c0                	test   %eax,%eax
80105d62:	0f 88 e2 00 00 00    	js     80105e4a <sys_link+0x11a>
  begin_op();
80105d68:	e8 d3 ce ff ff       	call   80102c40 <begin_op>
  if((ip = namei(old)) == 0){
80105d6d:	83 ec 0c             	sub    $0xc,%esp
80105d70:	ff 75 d4             	pushl  -0x2c(%ebp)
80105d73:	e8 08 c2 ff ff       	call   80101f80 <namei>
80105d78:	83 c4 10             	add    $0x10,%esp
80105d7b:	85 c0                	test   %eax,%eax
80105d7d:	89 c3                	mov    %eax,%ebx
80105d7f:	0f 84 ea 00 00 00    	je     80105e6f <sys_link+0x13f>
  ilock(ip);
80105d85:	83 ec 0c             	sub    $0xc,%esp
80105d88:	50                   	push   %eax
80105d89:	e8 92 b9 ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80105d8e:	83 c4 10             	add    $0x10,%esp
80105d91:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105d96:	0f 84 bb 00 00 00    	je     80105e57 <sys_link+0x127>
  ip->nlink++;
80105d9c:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105da1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105da4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105da7:	53                   	push   %ebx
80105da8:	e8 c3 b8 ff ff       	call   80101670 <iupdate>
  iunlock(ip);
80105dad:	89 1c 24             	mov    %ebx,(%esp)
80105db0:	e8 4b ba ff ff       	call   80101800 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105db5:	58                   	pop    %eax
80105db6:	5a                   	pop    %edx
80105db7:	57                   	push   %edi
80105db8:	ff 75 d0             	pushl  -0x30(%ebp)
80105dbb:	e8 e0 c1 ff ff       	call   80101fa0 <nameiparent>
80105dc0:	83 c4 10             	add    $0x10,%esp
80105dc3:	85 c0                	test   %eax,%eax
80105dc5:	89 c6                	mov    %eax,%esi
80105dc7:	74 5b                	je     80105e24 <sys_link+0xf4>
  ilock(dp);
80105dc9:	83 ec 0c             	sub    $0xc,%esp
80105dcc:	50                   	push   %eax
80105dcd:	e8 4e b9 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	8b 03                	mov    (%ebx),%eax
80105dd7:	39 06                	cmp    %eax,(%esi)
80105dd9:	75 3d                	jne    80105e18 <sys_link+0xe8>
80105ddb:	83 ec 04             	sub    $0x4,%esp
80105dde:	ff 73 04             	pushl  0x4(%ebx)
80105de1:	57                   	push   %edi
80105de2:	56                   	push   %esi
80105de3:	e8 d8 c0 ff ff       	call   80101ec0 <dirlink>
80105de8:	83 c4 10             	add    $0x10,%esp
80105deb:	85 c0                	test   %eax,%eax
80105ded:	78 29                	js     80105e18 <sys_link+0xe8>
  iunlockput(dp);
80105def:	83 ec 0c             	sub    $0xc,%esp
80105df2:	56                   	push   %esi
80105df3:	e8 b8 bb ff ff       	call   801019b0 <iunlockput>
  iput(ip);
80105df8:	89 1c 24             	mov    %ebx,(%esp)
80105dfb:	e8 50 ba ff ff       	call   80101850 <iput>
  end_op();
80105e00:	e8 ab ce ff ff       	call   80102cb0 <end_op>
  return 0;
80105e05:	83 c4 10             	add    $0x10,%esp
80105e08:	31 c0                	xor    %eax,%eax
}
80105e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e0d:	5b                   	pop    %ebx
80105e0e:	5e                   	pop    %esi
80105e0f:	5f                   	pop    %edi
80105e10:	5d                   	pop    %ebp
80105e11:	c3                   	ret    
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105e18:	83 ec 0c             	sub    $0xc,%esp
80105e1b:	56                   	push   %esi
80105e1c:	e8 8f bb ff ff       	call   801019b0 <iunlockput>
    goto bad;
80105e21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105e24:	83 ec 0c             	sub    $0xc,%esp
80105e27:	53                   	push   %ebx
80105e28:	e8 f3 b8 ff ff       	call   80101720 <ilock>
  ip->nlink--;
80105e2d:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105e32:	89 1c 24             	mov    %ebx,(%esp)
80105e35:	e8 36 b8 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
80105e3a:	89 1c 24             	mov    %ebx,(%esp)
80105e3d:	e8 6e bb ff ff       	call   801019b0 <iunlockput>
  end_op();
80105e42:	e8 69 ce ff ff       	call   80102cb0 <end_op>
  return -1;
80105e47:	83 c4 10             	add    $0x10,%esp
}
80105e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e52:	5b                   	pop    %ebx
80105e53:	5e                   	pop    %esi
80105e54:	5f                   	pop    %edi
80105e55:	5d                   	pop    %ebp
80105e56:	c3                   	ret    
    iunlockput(ip);
80105e57:	83 ec 0c             	sub    $0xc,%esp
80105e5a:	53                   	push   %ebx
80105e5b:	e8 50 bb ff ff       	call   801019b0 <iunlockput>
    end_op();
80105e60:	e8 4b ce ff ff       	call   80102cb0 <end_op>
    return -1;
80105e65:	83 c4 10             	add    $0x10,%esp
80105e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6d:	eb 9b                	jmp    80105e0a <sys_link+0xda>
    end_op();
80105e6f:	e8 3c ce ff ff       	call   80102cb0 <end_op>
    return -1;
80105e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e79:	eb 8f                	jmp    80105e0a <sys_link+0xda>
80105e7b:	90                   	nop
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e80 <sys_unlink>:
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	57                   	push   %edi
80105e84:	56                   	push   %esi
80105e85:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105e86:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105e89:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105e8c:	50                   	push   %eax
80105e8d:	6a 00                	push   $0x0
80105e8f:	e8 0c fa ff ff       	call   801058a0 <argstr>
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	85 c0                	test   %eax,%eax
80105e99:	0f 88 77 01 00 00    	js     80106016 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105e9f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105ea2:	e8 99 cd ff ff       	call   80102c40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ea7:	83 ec 08             	sub    $0x8,%esp
80105eaa:	53                   	push   %ebx
80105eab:	ff 75 c0             	pushl  -0x40(%ebp)
80105eae:	e8 ed c0 ff ff       	call   80101fa0 <nameiparent>
80105eb3:	83 c4 10             	add    $0x10,%esp
80105eb6:	85 c0                	test   %eax,%eax
80105eb8:	89 c6                	mov    %eax,%esi
80105eba:	0f 84 60 01 00 00    	je     80106020 <sys_unlink+0x1a0>
  ilock(dp);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	50                   	push   %eax
80105ec4:	e8 57 b8 ff ff       	call   80101720 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105ec9:	58                   	pop    %eax
80105eca:	5a                   	pop    %edx
80105ecb:	68 18 8a 10 80       	push   $0x80108a18
80105ed0:	53                   	push   %ebx
80105ed1:	e8 5a bd ff ff       	call   80101c30 <namecmp>
80105ed6:	83 c4 10             	add    $0x10,%esp
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	0f 84 03 01 00 00    	je     80105fe4 <sys_unlink+0x164>
80105ee1:	83 ec 08             	sub    $0x8,%esp
80105ee4:	68 17 8a 10 80       	push   $0x80108a17
80105ee9:	53                   	push   %ebx
80105eea:	e8 41 bd ff ff       	call   80101c30 <namecmp>
80105eef:	83 c4 10             	add    $0x10,%esp
80105ef2:	85 c0                	test   %eax,%eax
80105ef4:	0f 84 ea 00 00 00    	je     80105fe4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105efa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105efd:	83 ec 04             	sub    $0x4,%esp
80105f00:	50                   	push   %eax
80105f01:	53                   	push   %ebx
80105f02:	56                   	push   %esi
80105f03:	e8 48 bd ff ff       	call   80101c50 <dirlookup>
80105f08:	83 c4 10             	add    $0x10,%esp
80105f0b:	85 c0                	test   %eax,%eax
80105f0d:	89 c3                	mov    %eax,%ebx
80105f0f:	0f 84 cf 00 00 00    	je     80105fe4 <sys_unlink+0x164>
  ilock(ip);
80105f15:	83 ec 0c             	sub    $0xc,%esp
80105f18:	50                   	push   %eax
80105f19:	e8 02 b8 ff ff       	call   80101720 <ilock>
  if(ip->nlink < 1)
80105f1e:	83 c4 10             	add    $0x10,%esp
80105f21:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
80105f26:	0f 8e 10 01 00 00    	jle    8010603c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f2c:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105f31:	74 6d                	je     80105fa0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105f33:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f36:	83 ec 04             	sub    $0x4,%esp
80105f39:	6a 10                	push   $0x10
80105f3b:	6a 00                	push   $0x0
80105f3d:	50                   	push   %eax
80105f3e:	e8 ad f5 ff ff       	call   801054f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f43:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f46:	6a 10                	push   $0x10
80105f48:	ff 75 c4             	pushl  -0x3c(%ebp)
80105f4b:	50                   	push   %eax
80105f4c:	56                   	push   %esi
80105f4d:	e8 ae bb ff ff       	call   80101b00 <writei>
80105f52:	83 c4 20             	add    $0x20,%esp
80105f55:	83 f8 10             	cmp    $0x10,%eax
80105f58:	0f 85 eb 00 00 00    	jne    80106049 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105f5e:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105f63:	0f 84 97 00 00 00    	je     80106000 <sys_unlink+0x180>
  iunlockput(dp);
80105f69:	83 ec 0c             	sub    $0xc,%esp
80105f6c:	56                   	push   %esi
80105f6d:	e8 3e ba ff ff       	call   801019b0 <iunlockput>
  ip->nlink--;
80105f72:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105f77:	89 1c 24             	mov    %ebx,(%esp)
80105f7a:	e8 f1 b6 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
80105f7f:	89 1c 24             	mov    %ebx,(%esp)
80105f82:	e8 29 ba ff ff       	call   801019b0 <iunlockput>
  end_op();
80105f87:	e8 24 cd ff ff       	call   80102cb0 <end_op>
  return 0;
80105f8c:	83 c4 10             	add    $0x10,%esp
80105f8f:	31 c0                	xor    %eax,%eax
}
80105f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f94:	5b                   	pop    %ebx
80105f95:	5e                   	pop    %esi
80105f96:	5f                   	pop    %edi
80105f97:	5d                   	pop    %ebp
80105f98:	c3                   	ret    
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105fa0:	83 7b 5c 20          	cmpl   $0x20,0x5c(%ebx)
80105fa4:	76 8d                	jbe    80105f33 <sys_unlink+0xb3>
80105fa6:	bf 20 00 00 00       	mov    $0x20,%edi
80105fab:	eb 0f                	jmp    80105fbc <sys_unlink+0x13c>
80105fad:	8d 76 00             	lea    0x0(%esi),%esi
80105fb0:	83 c7 10             	add    $0x10,%edi
80105fb3:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80105fb6:	0f 83 77 ff ff ff    	jae    80105f33 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fbc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105fbf:	6a 10                	push   $0x10
80105fc1:	57                   	push   %edi
80105fc2:	50                   	push   %eax
80105fc3:	53                   	push   %ebx
80105fc4:	e8 37 ba ff ff       	call   80101a00 <readi>
80105fc9:	83 c4 10             	add    $0x10,%esp
80105fcc:	83 f8 10             	cmp    $0x10,%eax
80105fcf:	75 5e                	jne    8010602f <sys_unlink+0x1af>
    if(de.inum != 0)
80105fd1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105fd6:	74 d8                	je     80105fb0 <sys_unlink+0x130>
    iunlockput(ip);
80105fd8:	83 ec 0c             	sub    $0xc,%esp
80105fdb:	53                   	push   %ebx
80105fdc:	e8 cf b9 ff ff       	call   801019b0 <iunlockput>
    goto bad;
80105fe1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105fe4:	83 ec 0c             	sub    $0xc,%esp
80105fe7:	56                   	push   %esi
80105fe8:	e8 c3 b9 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105fed:	e8 be cc ff ff       	call   80102cb0 <end_op>
  return -1;
80105ff2:	83 c4 10             	add    $0x10,%esp
80105ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffa:	eb 95                	jmp    80105f91 <sys_unlink+0x111>
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80106000:	66 83 6e 5a 01       	subw   $0x1,0x5a(%esi)
    iupdate(dp);
80106005:	83 ec 0c             	sub    $0xc,%esp
80106008:	56                   	push   %esi
80106009:	e8 62 b6 ff ff       	call   80101670 <iupdate>
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	e9 53 ff ff ff       	jmp    80105f69 <sys_unlink+0xe9>
    return -1;
80106016:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601b:	e9 71 ff ff ff       	jmp    80105f91 <sys_unlink+0x111>
    end_op();
80106020:	e8 8b cc ff ff       	call   80102cb0 <end_op>
    return -1;
80106025:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602a:	e9 62 ff ff ff       	jmp    80105f91 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010602f:	83 ec 0c             	sub    $0xc,%esp
80106032:	68 3c 8a 10 80       	push   $0x80108a3c
80106037:	e8 54 a3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010603c:	83 ec 0c             	sub    $0xc,%esp
8010603f:	68 2a 8a 10 80       	push   $0x80108a2a
80106044:	e8 47 a3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106049:	83 ec 0c             	sub    $0xc,%esp
8010604c:	68 4e 8a 10 80       	push   $0x80108a4e
80106051:	e8 3a a3 ff ff       	call   80100390 <panic>
80106056:	8d 76 00             	lea    0x0(%esi),%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106060 <sys_open>:

int
sys_open(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	57                   	push   %edi
80106064:	56                   	push   %esi
80106065:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106066:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106069:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010606c:	50                   	push   %eax
8010606d:	6a 00                	push   $0x0
8010606f:	e8 2c f8 ff ff       	call   801058a0 <argstr>
80106074:	83 c4 10             	add    $0x10,%esp
80106077:	85 c0                	test   %eax,%eax
80106079:	0f 88 1d 01 00 00    	js     8010619c <sys_open+0x13c>
8010607f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106082:	83 ec 08             	sub    $0x8,%esp
80106085:	50                   	push   %eax
80106086:	6a 01                	push   $0x1
80106088:	e8 63 f7 ff ff       	call   801057f0 <argint>
8010608d:	83 c4 10             	add    $0x10,%esp
80106090:	85 c0                	test   %eax,%eax
80106092:	0f 88 04 01 00 00    	js     8010619c <sys_open+0x13c>
    return -1;

  begin_op();
80106098:	e8 a3 cb ff ff       	call   80102c40 <begin_op>

  if(omode & O_CREATE){
8010609d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801060a1:	0f 85 a9 00 00 00    	jne    80106150 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801060a7:	83 ec 0c             	sub    $0xc,%esp
801060aa:	ff 75 e0             	pushl  -0x20(%ebp)
801060ad:	e8 ce be ff ff       	call   80101f80 <namei>
801060b2:	83 c4 10             	add    $0x10,%esp
801060b5:	85 c0                	test   %eax,%eax
801060b7:	89 c6                	mov    %eax,%esi
801060b9:	0f 84 b2 00 00 00    	je     80106171 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801060bf:	83 ec 0c             	sub    $0xc,%esp
801060c2:	50                   	push   %eax
801060c3:	e8 58 b6 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801060c8:	83 c4 10             	add    $0x10,%esp
801060cb:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
801060d0:	0f 84 aa 00 00 00    	je     80106180 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060d6:	e8 35 ad ff ff       	call   80100e10 <filealloc>
801060db:	85 c0                	test   %eax,%eax
801060dd:	89 c7                	mov    %eax,%edi
801060df:	0f 84 a6 00 00 00    	je     8010618b <sys_open+0x12b>
  struct proc *curproc = myproc();
801060e5:	e8 f6 d8 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060ea:	31 db                	xor    %ebx,%ebx
801060ec:	eb 0e                	jmp    801060fc <sys_open+0x9c>
801060ee:	66 90                	xchg   %ax,%ax
801060f0:	83 c3 01             	add    $0x1,%ebx
801060f3:	83 fb 10             	cmp    $0x10,%ebx
801060f6:	0f 84 ac 00 00 00    	je     801061a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801060fc:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80106100:	85 d2                	test   %edx,%edx
80106102:	75 ec                	jne    801060f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106104:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106107:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
  iunlock(ip);
8010610b:	56                   	push   %esi
8010610c:	e8 ef b6 ff ff       	call   80101800 <iunlock>
  end_op();
80106111:	e8 9a cb ff ff       	call   80102cb0 <end_op>

  f->type = FD_INODE;
80106116:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010611c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010611f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106122:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106125:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010612c:	89 d0                	mov    %edx,%eax
8010612e:	f7 d0                	not    %eax
80106130:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106133:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106136:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106139:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010613d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106140:	89 d8                	mov    %ebx,%eax
80106142:	5b                   	pop    %ebx
80106143:	5e                   	pop    %esi
80106144:	5f                   	pop    %edi
80106145:	5d                   	pop    %ebp
80106146:	c3                   	ret    
80106147:	89 f6                	mov    %esi,%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106156:	31 c9                	xor    %ecx,%ecx
80106158:	6a 00                	push   $0x0
8010615a:	ba 02 00 00 00       	mov    $0x2,%edx
8010615f:	e8 ec f7 ff ff       	call   80105950 <create>
    if(ip == 0){
80106164:	83 c4 10             	add    $0x10,%esp
80106167:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106169:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010616b:	0f 85 65 ff ff ff    	jne    801060d6 <sys_open+0x76>
      end_op();
80106171:	e8 3a cb ff ff       	call   80102cb0 <end_op>
      return -1;
80106176:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010617b:	eb c0                	jmp    8010613d <sys_open+0xdd>
8010617d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106180:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106183:	85 c9                	test   %ecx,%ecx
80106185:	0f 84 4b ff ff ff    	je     801060d6 <sys_open+0x76>
    iunlockput(ip);
8010618b:	83 ec 0c             	sub    $0xc,%esp
8010618e:	56                   	push   %esi
8010618f:	e8 1c b8 ff ff       	call   801019b0 <iunlockput>
    end_op();
80106194:	e8 17 cb ff ff       	call   80102cb0 <end_op>
    return -1;
80106199:	83 c4 10             	add    $0x10,%esp
8010619c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801061a1:	eb 9a                	jmp    8010613d <sys_open+0xdd>
801061a3:	90                   	nop
801061a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801061a8:	83 ec 0c             	sub    $0xc,%esp
801061ab:	57                   	push   %edi
801061ac:	e8 1f ad ff ff       	call   80100ed0 <fileclose>
801061b1:	83 c4 10             	add    $0x10,%esp
801061b4:	eb d5                	jmp    8010618b <sys_open+0x12b>
801061b6:	8d 76 00             	lea    0x0(%esi),%esi
801061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801061c6:	e8 75 ca ff ff       	call   80102c40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801061cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061ce:	83 ec 08             	sub    $0x8,%esp
801061d1:	50                   	push   %eax
801061d2:	6a 00                	push   $0x0
801061d4:	e8 c7 f6 ff ff       	call   801058a0 <argstr>
801061d9:	83 c4 10             	add    $0x10,%esp
801061dc:	85 c0                	test   %eax,%eax
801061de:	78 30                	js     80106210 <sys_mkdir+0x50>
801061e0:	83 ec 0c             	sub    $0xc,%esp
801061e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e6:	31 c9                	xor    %ecx,%ecx
801061e8:	6a 00                	push   $0x0
801061ea:	ba 01 00 00 00       	mov    $0x1,%edx
801061ef:	e8 5c f7 ff ff       	call   80105950 <create>
801061f4:	83 c4 10             	add    $0x10,%esp
801061f7:	85 c0                	test   %eax,%eax
801061f9:	74 15                	je     80106210 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801061fb:	83 ec 0c             	sub    $0xc,%esp
801061fe:	50                   	push   %eax
801061ff:	e8 ac b7 ff ff       	call   801019b0 <iunlockput>
  end_op();
80106204:	e8 a7 ca ff ff       	call   80102cb0 <end_op>
  return 0;
80106209:	83 c4 10             	add    $0x10,%esp
8010620c:	31 c0                	xor    %eax,%eax
}
8010620e:	c9                   	leave  
8010620f:	c3                   	ret    
    end_op();
80106210:	e8 9b ca ff ff       	call   80102cb0 <end_op>
    return -1;
80106215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010621a:	c9                   	leave  
8010621b:	c3                   	ret    
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_mknod>:

int
sys_mknod(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106226:	e8 15 ca ff ff       	call   80102c40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010622b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010622e:	83 ec 08             	sub    $0x8,%esp
80106231:	50                   	push   %eax
80106232:	6a 00                	push   $0x0
80106234:	e8 67 f6 ff ff       	call   801058a0 <argstr>
80106239:	83 c4 10             	add    $0x10,%esp
8010623c:	85 c0                	test   %eax,%eax
8010623e:	78 60                	js     801062a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106240:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106243:	83 ec 08             	sub    $0x8,%esp
80106246:	50                   	push   %eax
80106247:	6a 01                	push   $0x1
80106249:	e8 a2 f5 ff ff       	call   801057f0 <argint>
  if((argstr(0, &path)) < 0 ||
8010624e:	83 c4 10             	add    $0x10,%esp
80106251:	85 c0                	test   %eax,%eax
80106253:	78 4b                	js     801062a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106255:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106258:	83 ec 08             	sub    $0x8,%esp
8010625b:	50                   	push   %eax
8010625c:	6a 02                	push   $0x2
8010625e:	e8 8d f5 ff ff       	call   801057f0 <argint>
     argint(1, &major) < 0 ||
80106263:	83 c4 10             	add    $0x10,%esp
80106266:	85 c0                	test   %eax,%eax
80106268:	78 36                	js     801062a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010626a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010626e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80106271:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106275:	ba 03 00 00 00       	mov    $0x3,%edx
8010627a:	50                   	push   %eax
8010627b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010627e:	e8 cd f6 ff ff       	call   80105950 <create>
80106283:	83 c4 10             	add    $0x10,%esp
80106286:	85 c0                	test   %eax,%eax
80106288:	74 16                	je     801062a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010628a:	83 ec 0c             	sub    $0xc,%esp
8010628d:	50                   	push   %eax
8010628e:	e8 1d b7 ff ff       	call   801019b0 <iunlockput>
  end_op();
80106293:	e8 18 ca ff ff       	call   80102cb0 <end_op>
  return 0;
80106298:	83 c4 10             	add    $0x10,%esp
8010629b:	31 c0                	xor    %eax,%eax
}
8010629d:	c9                   	leave  
8010629e:	c3                   	ret    
8010629f:	90                   	nop
    end_op();
801062a0:	e8 0b ca ff ff       	call   80102cb0 <end_op>
    return -1;
801062a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062aa:	c9                   	leave  
801062ab:	c3                   	ret    
801062ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062b0 <sys_chdir>:

int
sys_chdir(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	56                   	push   %esi
801062b4:	53                   	push   %ebx
801062b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801062b8:	e8 23 d7 ff ff       	call   801039e0 <myproc>
801062bd:	89 c6                	mov    %eax,%esi
  //struct thread *curthread = mythread();
  
  begin_op();
801062bf:	e8 7c c9 ff ff       	call   80102c40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801062c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062c7:	83 ec 08             	sub    $0x8,%esp
801062ca:	50                   	push   %eax
801062cb:	6a 00                	push   $0x0
801062cd:	e8 ce f5 ff ff       	call   801058a0 <argstr>
801062d2:	83 c4 10             	add    $0x10,%esp
801062d5:	85 c0                	test   %eax,%eax
801062d7:	78 77                	js     80106350 <sys_chdir+0xa0>
801062d9:	83 ec 0c             	sub    $0xc,%esp
801062dc:	ff 75 f4             	pushl  -0xc(%ebp)
801062df:	e8 9c bc ff ff       	call   80101f80 <namei>
801062e4:	83 c4 10             	add    $0x10,%esp
801062e7:	85 c0                	test   %eax,%eax
801062e9:	89 c3                	mov    %eax,%ebx
801062eb:	74 63                	je     80106350 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801062ed:	83 ec 0c             	sub    $0xc,%esp
801062f0:	50                   	push   %eax
801062f1:	e8 2a b4 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
801062f6:	83 c4 10             	add    $0x10,%esp
801062f9:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
801062fe:	75 30                	jne    80106330 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106300:	83 ec 0c             	sub    $0xc,%esp
80106303:	53                   	push   %ebx
80106304:	e8 f7 b4 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
80106309:	58                   	pop    %eax
8010630a:	ff 76 60             	pushl  0x60(%esi)
8010630d:	e8 3e b5 ff ff       	call   80101850 <iput>
  end_op();
80106312:	e8 99 c9 ff ff       	call   80102cb0 <end_op>
  curproc->cwd = ip;
80106317:	89 5e 60             	mov    %ebx,0x60(%esi)
  return 0;
8010631a:	83 c4 10             	add    $0x10,%esp
8010631d:	31 c0                	xor    %eax,%eax
}
8010631f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106322:	5b                   	pop    %ebx
80106323:	5e                   	pop    %esi
80106324:	5d                   	pop    %ebp
80106325:	c3                   	ret    
80106326:	8d 76 00             	lea    0x0(%esi),%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	53                   	push   %ebx
80106334:	e8 77 b6 ff ff       	call   801019b0 <iunlockput>
    end_op();
80106339:	e8 72 c9 ff ff       	call   80102cb0 <end_op>
    return -1;
8010633e:	83 c4 10             	add    $0x10,%esp
80106341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106346:	eb d7                	jmp    8010631f <sys_chdir+0x6f>
80106348:	90                   	nop
80106349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106350:	e8 5b c9 ff ff       	call   80102cb0 <end_op>
    return -1;
80106355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635a:	eb c3                	jmp    8010631f <sys_chdir+0x6f>
8010635c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106360 <sys_exec>:

int
sys_exec(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	57                   	push   %edi
80106364:	56                   	push   %esi
80106365:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106366:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010636c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106372:	50                   	push   %eax
80106373:	6a 00                	push   $0x0
80106375:	e8 26 f5 ff ff       	call   801058a0 <argstr>
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	85 c0                	test   %eax,%eax
8010637f:	0f 88 87 00 00 00    	js     8010640c <sys_exec+0xac>
80106385:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010638b:	83 ec 08             	sub    $0x8,%esp
8010638e:	50                   	push   %eax
8010638f:	6a 01                	push   $0x1
80106391:	e8 5a f4 ff ff       	call   801057f0 <argint>
80106396:	83 c4 10             	add    $0x10,%esp
80106399:	85 c0                	test   %eax,%eax
8010639b:	78 6f                	js     8010640c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010639d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063a3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801063a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801063a8:	68 80 00 00 00       	push   $0x80
801063ad:	6a 00                	push   $0x0
801063af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801063b5:	50                   	push   %eax
801063b6:	e8 35 f1 ff ff       	call   801054f0 <memset>
801063bb:	83 c4 10             	add    $0x10,%esp
801063be:	eb 2c                	jmp    801063ec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801063c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801063c6:	85 c0                	test   %eax,%eax
801063c8:	74 56                	je     80106420 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801063ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801063d0:	83 ec 08             	sub    $0x8,%esp
801063d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801063d6:	52                   	push   %edx
801063d7:	50                   	push   %eax
801063d8:	e8 a3 f3 ff ff       	call   80105780 <fetchstr>
801063dd:	83 c4 10             	add    $0x10,%esp
801063e0:	85 c0                	test   %eax,%eax
801063e2:	78 28                	js     8010640c <sys_exec+0xac>
  for(i=0;; i++){
801063e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801063e7:	83 fb 20             	cmp    $0x20,%ebx
801063ea:	74 20                	je     8010640c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801063f2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801063f9:	83 ec 08             	sub    $0x8,%esp
801063fc:	57                   	push   %edi
801063fd:	01 f0                	add    %esi,%eax
801063ff:	50                   	push   %eax
80106400:	e8 3b f3 ff ff       	call   80105740 <fetchint>
80106405:	83 c4 10             	add    $0x10,%esp
80106408:	85 c0                	test   %eax,%eax
8010640a:	79 b4                	jns    801063c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010640c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010640f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106414:	5b                   	pop    %ebx
80106415:	5e                   	pop    %esi
80106416:	5f                   	pop    %edi
80106417:	5d                   	pop    %ebp
80106418:	c3                   	ret    
80106419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106420:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106426:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106429:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106430:	00 00 00 00 
  return exec(path, argv);
80106434:	50                   	push   %eax
80106435:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010643b:	e8 d0 a5 ff ff       	call   80100a10 <exec>
80106440:	83 c4 10             	add    $0x10,%esp
}
80106443:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106446:	5b                   	pop    %ebx
80106447:	5e                   	pop    %esi
80106448:	5f                   	pop    %edi
80106449:	5d                   	pop    %ebp
8010644a:	c3                   	ret    
8010644b:	90                   	nop
8010644c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106450 <sys_pipe>:

int
sys_pipe(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	57                   	push   %edi
80106454:	56                   	push   %esi
80106455:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106456:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106459:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010645c:	6a 08                	push   $0x8
8010645e:	50                   	push   %eax
8010645f:	6a 00                	push   $0x0
80106461:	e8 da f3 ff ff       	call   80105840 <argptr>
80106466:	83 c4 10             	add    $0x10,%esp
80106469:	85 c0                	test   %eax,%eax
8010646b:	0f 88 ae 00 00 00    	js     8010651f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106471:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106474:	83 ec 08             	sub    $0x8,%esp
80106477:	50                   	push   %eax
80106478:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010647b:	50                   	push   %eax
8010647c:	e8 5f ce ff ff       	call   801032e0 <pipealloc>
80106481:	83 c4 10             	add    $0x10,%esp
80106484:	85 c0                	test   %eax,%eax
80106486:	0f 88 93 00 00 00    	js     8010651f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010648c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010648f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106491:	e8 4a d5 ff ff       	call   801039e0 <myproc>
80106496:	eb 10                	jmp    801064a8 <sys_pipe+0x58>
80106498:	90                   	nop
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801064a0:	83 c3 01             	add    $0x1,%ebx
801064a3:	83 fb 10             	cmp    $0x10,%ebx
801064a6:	74 60                	je     80106508 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801064a8:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
801064ac:	85 f6                	test   %esi,%esi
801064ae:	75 f0                	jne    801064a0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801064b0:	8d 73 08             	lea    0x8(%ebx),%esi
801064b3:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801064b9:	e8 22 d5 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064be:	31 d2                	xor    %edx,%edx
801064c0:	eb 0e                	jmp    801064d0 <sys_pipe+0x80>
801064c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801064c8:	83 c2 01             	add    $0x1,%edx
801064cb:	83 fa 10             	cmp    $0x10,%edx
801064ce:	74 28                	je     801064f8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801064d0:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
801064d4:	85 c9                	test   %ecx,%ecx
801064d6:	75 f0                	jne    801064c8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801064d8:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801064dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064df:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801064e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064e4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801064e7:	31 c0                	xor    %eax,%eax
}
801064e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064ec:	5b                   	pop    %ebx
801064ed:	5e                   	pop    %esi
801064ee:	5f                   	pop    %edi
801064ef:	5d                   	pop    %ebp
801064f0:	c3                   	ret    
801064f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801064f8:	e8 e3 d4 ff ff       	call   801039e0 <myproc>
801064fd:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
80106504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(rf);
80106508:	83 ec 0c             	sub    $0xc,%esp
8010650b:	ff 75 e0             	pushl  -0x20(%ebp)
8010650e:	e8 bd a9 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80106513:	58                   	pop    %eax
80106514:	ff 75 e4             	pushl  -0x1c(%ebp)
80106517:	e8 b4 a9 ff ff       	call   80100ed0 <fileclose>
    return -1;
8010651c:	83 c4 10             	add    $0x10,%esp
8010651f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106524:	eb c3                	jmp    801064e9 <sys_pipe+0x99>
80106526:	66 90                	xchg   %ax,%ax
80106528:	66 90                	xchg   %ax,%ax
8010652a:	66 90                	xchg   %ax,%ax
8010652c:	66 90                	xchg   %ax,%ax
8010652e:	66 90                	xchg   %ax,%ax

80106530 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void) {
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
    return fork();
}
80106533:	5d                   	pop    %ebp
    return fork();
80106534:	e9 e7 d6 ff ff       	jmp    80103c20 <fork>
80106539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106540 <sys_exit>:

int
sys_exit(void) {
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	83 ec 08             	sub    $0x8,%esp
    exit();
80106546:	e8 c5 e3 ff ff       	call   80104910 <exit>
    return 0;  // not reached
}
8010654b:	31 c0                	xor    %eax,%eax
8010654d:	c9                   	leave  
8010654e:	c3                   	ret    
8010654f:	90                   	nop

80106550 <sys_wait>:

int
sys_wait(void) {
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
    return wait();
}
80106553:	5d                   	pop    %ebp
    return wait();
80106554:	e9 77 e5 ff ff       	jmp    80104ad0 <wait>
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106560 <sys_kill>:

int
sys_kill(void) {
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0)
80106566:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106569:	50                   	push   %eax
8010656a:	6a 00                	push   $0x0
8010656c:	e8 7f f2 ff ff       	call   801057f0 <argint>
80106571:	83 c4 10             	add    $0x10,%esp
80106574:	85 c0                	test   %eax,%eax
80106576:	78 18                	js     80106590 <sys_kill+0x30>
        return -1;
    return kill(pid);
80106578:	83 ec 0c             	sub    $0xc,%esp
8010657b:	ff 75 f4             	pushl  -0xc(%ebp)
8010657e:	e8 cd da ff ff       	call   80104050 <kill>
80106583:	83 c4 10             	add    $0x10,%esp
}
80106586:	c9                   	leave  
80106587:	c3                   	ret    
80106588:	90                   	nop
80106589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106595:	c9                   	leave  
80106596:	c3                   	ret    
80106597:	89 f6                	mov    %esi,%esi
80106599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065a0 <sys_getpid>:

int
sys_getpid(void) {
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
801065a6:	e8 35 d4 ff ff       	call   801039e0 <myproc>
801065ab:	8b 40 0c             	mov    0xc(%eax),%eax
}
801065ae:	c9                   	leave  
801065af:	c3                   	ret    

801065b0 <sys_sbrk>:

int
sys_sbrk(void) {
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0)
801065b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
sys_sbrk(void) {
801065b7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
801065ba:	50                   	push   %eax
801065bb:	6a 00                	push   $0x0
801065bd:	e8 2e f2 ff ff       	call   801057f0 <argint>
801065c2:	83 c4 10             	add    $0x10,%esp
801065c5:	85 c0                	test   %eax,%eax
801065c7:	78 27                	js     801065f0 <sys_sbrk+0x40>
        return -1;
    addr = myproc()->sz;
801065c9:	e8 12 d4 ff ff       	call   801039e0 <myproc>
    if (growproc(n) < 0)
801065ce:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
801065d1:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0)
801065d3:	ff 75 f4             	pushl  -0xc(%ebp)
801065d6:	e8 b5 d5 ff ff       	call   80103b90 <growproc>
801065db:	83 c4 10             	add    $0x10,%esp
801065de:	85 c0                	test   %eax,%eax
801065e0:	78 0e                	js     801065f0 <sys_sbrk+0x40>
        return -1;
    return addr;
}
801065e2:	89 d8                	mov    %ebx,%eax
801065e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065e7:	c9                   	leave  
801065e8:	c3                   	ret    
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801065f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065f5:	eb eb                	jmp    801065e2 <sys_sbrk+0x32>
801065f7:	89 f6                	mov    %esi,%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106600 <sys_sleep>:

int
sys_sleep(void) {
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
80106604:	8d 45 f4             	lea    -0xc(%ebp),%eax
sys_sleep(void) {
80106607:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
8010660a:	50                   	push   %eax
8010660b:	6a 00                	push   $0x0
8010660d:	e8 de f1 ff ff       	call   801057f0 <argint>
80106612:	83 c4 10             	add    $0x10,%esp
80106615:	85 c0                	test   %eax,%eax
80106617:	0f 88 8a 00 00 00    	js     801066a7 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
8010661d:	83 ec 0c             	sub    $0xc,%esp
80106620:	68 20 de 15 80       	push   $0x8015de20
80106625:	e8 a6 ed ff ff       	call   801053d0 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
8010662a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010662d:	83 c4 10             	add    $0x10,%esp
    ticks0 = ticks;
80106630:	8b 1d 60 e6 15 80    	mov    0x8015e660,%ebx
    while (ticks - ticks0 < n) {
80106636:	85 d2                	test   %edx,%edx
80106638:	75 27                	jne    80106661 <sys_sleep+0x61>
8010663a:	eb 54                	jmp    80106690 <sys_sleep+0x90>
8010663c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80106640:	83 ec 08             	sub    $0x8,%esp
80106643:	68 20 de 15 80       	push   $0x8015de20
80106648:	68 60 e6 15 80       	push   $0x8015e660
8010664d:	e8 8e e0 ff ff       	call   801046e0 <sleep>
    while (ticks - ticks0 < n) {
80106652:	a1 60 e6 15 80       	mov    0x8015e660,%eax
80106657:	83 c4 10             	add    $0x10,%esp
8010665a:	29 d8                	sub    %ebx,%eax
8010665c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010665f:	73 2f                	jae    80106690 <sys_sleep+0x90>
        if (myproc()->killed) {
80106661:	e8 7a d3 ff ff       	call   801039e0 <myproc>
80106666:	8b 40 1c             	mov    0x1c(%eax),%eax
80106669:	85 c0                	test   %eax,%eax
8010666b:	74 d3                	je     80106640 <sys_sleep+0x40>
            release(&tickslock);
8010666d:	83 ec 0c             	sub    $0xc,%esp
80106670:	68 20 de 15 80       	push   $0x8015de20
80106675:	e8 26 ee ff ff       	call   801054a0 <release>
            return -1;
8010667a:	83 c4 10             	add    $0x10,%esp
8010667d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    release(&tickslock);
    return 0;
}
80106682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106685:	c9                   	leave  
80106686:	c3                   	ret    
80106687:	89 f6                	mov    %esi,%esi
80106689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&tickslock);
80106690:	83 ec 0c             	sub    $0xc,%esp
80106693:	68 20 de 15 80       	push   $0x8015de20
80106698:	e8 03 ee ff ff       	call   801054a0 <release>
    return 0;
8010669d:	83 c4 10             	add    $0x10,%esp
801066a0:	31 c0                	xor    %eax,%eax
}
801066a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066a5:	c9                   	leave  
801066a6:	c3                   	ret    
        return -1;
801066a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ac:	eb f4                	jmp    801066a2 <sys_sleep+0xa2>
801066ae:	66 90                	xchg   %ax,%ax

801066b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void) {
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	53                   	push   %ebx
801066b4:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
801066b7:	68 20 de 15 80       	push   $0x8015de20
801066bc:	e8 0f ed ff ff       	call   801053d0 <acquire>
    xticks = ticks;
801066c1:	8b 1d 60 e6 15 80    	mov    0x8015e660,%ebx
    release(&tickslock);
801066c7:	c7 04 24 20 de 15 80 	movl   $0x8015de20,(%esp)
801066ce:	e8 cd ed ff ff       	call   801054a0 <release>
    return xticks;
}
801066d3:	89 d8                	mov    %ebx,%eax
801066d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066d8:	c9                   	leave  
801066d9:	c3                   	ret    
801066da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066e0 <sys_kthread_create>:

//kthread syscalls
int
sys_kthread_create(void) {
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	83 ec 20             	sub    $0x20,%esp
    void *stack = 0;
//    if (argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
//        return -1;
//    if (argptr(0, stack, sizeof(*stack)) < 0)
//        return -1;
    if (argint(0, (int *) &start_func) < 0)
801066e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
    void (*start_func)() = 0;
801066e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    void *stack = 0;
801066f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (argint(0, (int *) &start_func) < 0)
801066f7:	50                   	push   %eax
801066f8:	6a 00                	push   $0x0
801066fa:	e8 f1 f0 ff ff       	call   801057f0 <argint>
801066ff:	83 c4 10             	add    $0x10,%esp
80106702:	85 c0                	test   %eax,%eax
80106704:	78 2a                	js     80106730 <sys_kthread_create+0x50>
        return -1;
    if (argint(1, (int *) &stack) < 0)
80106706:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106709:	83 ec 08             	sub    $0x8,%esp
8010670c:	50                   	push   %eax
8010670d:	6a 01                	push   $0x1
8010670f:	e8 dc f0 ff ff       	call   801057f0 <argint>
80106714:	83 c4 10             	add    $0x10,%esp
80106717:	85 c0                	test   %eax,%eax
80106719:	78 15                	js     80106730 <sys_kthread_create+0x50>
        return -1;
    return kthread_create(start_func, stack);
8010671b:	83 ec 08             	sub    $0x8,%esp
8010671e:	ff 75 f4             	pushl  -0xc(%ebp)
80106721:	ff 75 f0             	pushl  -0x10(%ebp)
80106724:	e8 b7 da ff ff       	call   801041e0 <kthread_create>
80106729:	83 c4 10             	add    $0x10,%esp
}
8010672c:	c9                   	leave  
8010672d:	c3                   	ret    
8010672e:	66 90                	xchg   %ax,%ax
        return -1;
80106730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106735:	c9                   	leave  
80106736:	c3                   	ret    
80106737:	89 f6                	mov    %esi,%esi
80106739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106740 <sys_kthread_id>:

int
sys_kthread_id(void) {
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	83 ec 08             	sub    $0x8,%esp
    return mythread()->tid;
80106746:	e8 c5 d2 ff ff       	call   80103a10 <mythread>
8010674b:	8b 40 0c             	mov    0xc(%eax),%eax
}
8010674e:	c9                   	leave  
8010674f:	c3                   	ret    

80106750 <sys_kthread_exit>:

int
sys_kthread_exit(void) {
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	83 ec 08             	sub    $0x8,%esp
    kthread_exit();
80106756:	e8 85 dd ff ff       	call   801044e0 <kthread_exit>
    return 0;
}
8010675b:	31 c0                	xor    %eax,%eax
8010675d:	c9                   	leave  
8010675e:	c3                   	ret    
8010675f:	90                   	nop

80106760 <sys_kthread_join>:

int
sys_kthread_join(void) {
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if (argint(0, &tid) < 0)
80106766:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106769:	50                   	push   %eax
8010676a:	6a 00                	push   $0x0
8010676c:	e8 7f f0 ff ff       	call   801057f0 <argint>
80106771:	83 c4 10             	add    $0x10,%esp
80106774:	85 c0                	test   %eax,%eax
80106776:	78 18                	js     80106790 <sys_kthread_join+0x30>
        return -1;
    return kthread_join(tid);
80106778:	83 ec 0c             	sub    $0xc,%esp
8010677b:	ff 75 f4             	pushl  -0xc(%ebp)
8010677e:	e8 fd e4 ff ff       	call   80104c80 <kthread_join>
80106783:	83 c4 10             	add    $0x10,%esp
}
80106786:	c9                   	leave  
80106787:	c3                   	ret    
80106788:	90                   	nop
80106789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106795:	c9                   	leave  
80106796:	c3                   	ret    
80106797:	89 f6                	mov    %esi,%esi
80106799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067a0 <sys_kthread_mutex_alloc>:

//kthread_mutex syscalls
int
sys_kthread_mutex_alloc(void) {
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
    return kthread_mutex_alloc();
}
801067a3:	5d                   	pop    %ebp
    return kthread_mutex_alloc();
801067a4:	e9 17 e6 ff ff       	jmp    80104dc0 <kthread_mutex_alloc>
801067a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067b0 <sys_kthread_mutex_dealloc>:

int
sys_kthread_mutex_dealloc(void) {
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if (argint(0, &tid) < 0)
801067b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067b9:	50                   	push   %eax
801067ba:	6a 00                	push   $0x0
801067bc:	e8 2f f0 ff ff       	call   801057f0 <argint>
801067c1:	83 c4 10             	add    $0x10,%esp
801067c4:	85 c0                	test   %eax,%eax
801067c6:	78 18                	js     801067e0 <sys_kthread_mutex_dealloc+0x30>
        return -1;
    return kthread_mutex_dealloc(tid);
801067c8:	83 ec 0c             	sub    $0xc,%esp
801067cb:	ff 75 f4             	pushl  -0xc(%ebp)
801067ce:	e8 fd e6 ff ff       	call   80104ed0 <kthread_mutex_dealloc>
801067d3:	83 c4 10             	add    $0x10,%esp
}
801067d6:	c9                   	leave  
801067d7:	c3                   	ret    
801067d8:	90                   	nop
801067d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801067e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067e5:	c9                   	leave  
801067e6:	c3                   	ret    
801067e7:	89 f6                	mov    %esi,%esi
801067e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067f0 <sys_kthread_mutex_lock>:

int
sys_kthread_mutex_lock(void) {
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if (argint(0, &tid) < 0)
801067f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067f9:	50                   	push   %eax
801067fa:	6a 00                	push   $0x0
801067fc:	e8 ef ef ff ff       	call   801057f0 <argint>
80106801:	83 c4 10             	add    $0x10,%esp
80106804:	85 c0                	test   %eax,%eax
80106806:	78 18                	js     80106820 <sys_kthread_mutex_lock+0x30>
        return -1;
    return kthread_mutex_lock(tid);
80106808:	83 ec 0c             	sub    $0xc,%esp
8010680b:	ff 75 f4             	pushl  -0xc(%ebp)
8010680e:	e8 5d e7 ff ff       	call   80104f70 <kthread_mutex_lock>
80106813:	83 c4 10             	add    $0x10,%esp
}
80106816:	c9                   	leave  
80106817:	c3                   	ret    
80106818:	90                   	nop
80106819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106825:	c9                   	leave  
80106826:	c3                   	ret    
80106827:	89 f6                	mov    %esi,%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106830 <sys_kthread_mutex_unlock>:

int
sys_kthread_mutex_unlock(void) {
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if (argint(0, &tid) < 0)
80106836:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106839:	50                   	push   %eax
8010683a:	6a 00                	push   $0x0
8010683c:	e8 af ef ff ff       	call   801057f0 <argint>
80106841:	83 c4 10             	add    $0x10,%esp
80106844:	85 c0                	test   %eax,%eax
80106846:	78 18                	js     80106860 <sys_kthread_mutex_unlock+0x30>
        return -1;
    return kthread_mutex_unlock(tid);
80106848:	83 ec 0c             	sub    $0xc,%esp
8010684b:	ff 75 f4             	pushl  -0xc(%ebp)
8010684e:	e8 2d e8 ff ff       	call   80105080 <kthread_mutex_unlock>
80106853:	83 c4 10             	add    $0x10,%esp
}
80106856:	c9                   	leave  
80106857:	c3                   	ret    
80106858:	90                   	nop
80106859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106865:	c9                   	leave  
80106866:	c3                   	ret    
80106867:	89 f6                	mov    %esi,%esi
80106869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106870 <sys_safe_tree_dealloc>:

int
sys_safe_tree_dealloc(void) {
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if (argint(0, &tid) < 0)
80106876:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106879:	50                   	push   %eax
8010687a:	6a 00                	push   $0x0
8010687c:	e8 6f ef ff ff       	call   801057f0 <argint>
80106881:	83 c4 10             	add    $0x10,%esp
80106884:	85 c0                	test   %eax,%eax
80106886:	78 18                	js     801068a0 <sys_safe_tree_dealloc+0x30>
        return -1;
    return safe_tree_dealloc(tid);
80106888:	83 ec 0c             	sub    $0xc,%esp
8010688b:	ff 75 f4             	pushl  -0xc(%ebp)
8010688e:	e8 bd e5 ff ff       	call   80104e50 <safe_tree_dealloc>
80106893:	83 c4 10             	add    $0x10,%esp
}
80106896:	c9                   	leave  
80106897:	c3                   	ret    
80106898:	90                   	nop
80106899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801068a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068a5:	c9                   	leave  
801068a6:	c3                   	ret    

801068a7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801068a7:	1e                   	push   %ds
  pushl %es
801068a8:	06                   	push   %es
  pushl %fs
801068a9:	0f a0                	push   %fs
  pushl %gs
801068ab:	0f a8                	push   %gs
  pushal
801068ad:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801068ae:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801068b2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801068b4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801068b6:	54                   	push   %esp
  call trap
801068b7:	e8 c4 00 00 00       	call   80106980 <trap>
  addl $4, %esp
801068bc:	83 c4 04             	add    $0x4,%esp

801068bf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801068bf:	61                   	popa   
  popl %gs
801068c0:	0f a9                	pop    %gs
  popl %fs
801068c2:	0f a1                	pop    %fs
  popl %es
801068c4:	07                   	pop    %es
  popl %ds
801068c5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801068c6:	83 c4 08             	add    $0x8,%esp
  iret
801068c9:	cf                   	iret   
801068ca:	66 90                	xchg   %ax,%ax
801068cc:	66 90                	xchg   %ax,%ax
801068ce:	66 90                	xchg   %ax,%ax

801068d0 <tvinit>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void) {
801068d0:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801068d1:	31 c0                	xor    %eax,%eax
tvinit(void) {
801068d3:	89 e5                	mov    %esp,%ebp
801068d5:	83 ec 08             	sub    $0x8,%esp
801068d8:	90                   	nop
801068d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801068e0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
801068e7:	c7 04 c5 62 de 15 80 	movl   $0x8e000008,-0x7fea219e(,%eax,8)
801068ee:	08 00 00 8e 
801068f2:	66 89 14 c5 60 de 15 	mov    %dx,-0x7fea21a0(,%eax,8)
801068f9:	80 
801068fa:	c1 ea 10             	shr    $0x10,%edx
801068fd:	66 89 14 c5 66 de 15 	mov    %dx,-0x7fea219a(,%eax,8)
80106904:	80 
80106905:	83 c0 01             	add    $0x1,%eax
80106908:	3d 00 01 00 00       	cmp    $0x100,%eax
8010690d:	75 d1                	jne    801068e0 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010690f:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

    initlock(&tickslock, "time");
80106914:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106917:	c7 05 62 e0 15 80 08 	movl   $0xef000008,0x8015e062
8010691e:	00 00 ef 
    initlock(&tickslock, "time");
80106921:	68 5d 8a 10 80       	push   $0x80108a5d
80106926:	68 20 de 15 80       	push   $0x8015de20
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010692b:	66 a3 60 e0 15 80    	mov    %ax,0x8015e060
80106931:	c1 e8 10             	shr    $0x10,%eax
80106934:	66 a3 66 e0 15 80    	mov    %ax,0x8015e066
    initlock(&tickslock, "time");
8010693a:	e8 51 e9 ff ff       	call   80105290 <initlock>
}
8010693f:	83 c4 10             	add    $0x10,%esp
80106942:	c9                   	leave  
80106943:	c3                   	ret    
80106944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010694a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106950 <idtinit>:

void
idtinit(void) {
80106950:	55                   	push   %ebp
  pd[0] = size-1;
80106951:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106956:	89 e5                	mov    %esp,%ebp
80106958:	83 ec 10             	sub    $0x10,%esp
8010695b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010695f:	b8 60 de 15 80       	mov    $0x8015de60,%eax
80106964:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106968:	c1 e8 10             	shr    $0x10,%eax
8010696b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010696f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106972:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80106975:	c9                   	leave  
80106976:	c3                   	ret    
80106977:	89 f6                	mov    %esi,%esi
80106979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106980 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	57                   	push   %edi
80106984:	56                   	push   %esi
80106985:	53                   	push   %ebx
80106986:	83 ec 1c             	sub    $0x1c,%esp
80106989:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
8010698c:	8b 47 30             	mov    0x30(%edi),%eax
8010698f:	83 f8 40             	cmp    $0x40,%eax
80106992:	0f 84 50 01 00 00    	je     80106ae8 <trap+0x168>
        return;
    }



    switch (tf->trapno) {
80106998:	83 e8 20             	sub    $0x20,%eax
8010699b:	83 f8 1f             	cmp    $0x1f,%eax
8010699e:	77 10                	ja     801069b0 <trap+0x30>
801069a0:	ff 24 85 04 8b 10 80 	jmp    *-0x7fef74fc(,%eax,4)
801069a7:	89 f6                	mov    %esi,%esi
801069a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                if(DEBUGMODE > 0)
                    cprintf("mythread()->tkilled == 1 --> kthread_exit()  #2\n");
                kthread_exit();
                return;
            }*/
            if (myproc() == 0 || (tf->cs & 3) == 0) {
801069b0:	e8 2b d0 ff ff       	call   801039e0 <myproc>
801069b5:	85 c0                	test   %eax,%eax
801069b7:	8b 5f 38             	mov    0x38(%edi),%ebx
801069ba:	0f 84 ec 02 00 00    	je     80106cac <trap+0x32c>
801069c0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801069c4:	0f 84 e2 02 00 00    	je     80106cac <trap+0x32c>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801069ca:	0f 20 d1             	mov    %cr2,%ecx
801069cd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801069d0:	e8 eb cf ff ff       	call   801039c0 <cpuid>
801069d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069d8:	8b 47 34             	mov    0x34(%edi),%eax
801069db:	8b 77 30             	mov    0x30(%edi),%esi
801069de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
801069e1:	e8 fa cf ff ff       	call   801039e0 <myproc>
801069e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801069e9:	e8 f2 cf ff ff       	call   801039e0 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801069ee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801069f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801069f4:	51                   	push   %ecx
801069f5:	53                   	push   %ebx
801069f6:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
801069f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801069fa:	ff 75 e4             	pushl  -0x1c(%ebp)
801069fd:	56                   	push   %esi
                    myproc()->pid, myproc()->name, tf->trapno,
801069fe:	83 c2 64             	add    $0x64,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a01:	52                   	push   %edx
80106a02:	ff 70 0c             	pushl  0xc(%eax)
80106a05:	68 c0 8a 10 80       	push   $0x80108ac0
80106a0a:	e8 51 9c ff ff       	call   80100660 <cprintf>
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
80106a0f:	83 c4 20             	add    $0x20,%esp
80106a12:	e8 c9 cf ff ff       	call   801039e0 <myproc>
80106a17:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
            mythread()->tkilled=1;
80106a1e:	e8 ed cf ff ff       	call   80103a10 <mythread>
80106a23:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106a2a:	e8 b1 cf ff ff       	call   801039e0 <myproc>
80106a2f:	85 c0                	test   %eax,%eax
80106a31:	74 1d                	je     80106a50 <trap+0xd0>
80106a33:	e8 a8 cf ff ff       	call   801039e0 <myproc>
80106a38:	8b 58 1c             	mov    0x1c(%eax),%ebx
80106a3b:	85 db                	test   %ebx,%ebx
80106a3d:	74 11                	je     80106a50 <trap+0xd0>
80106a3f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106a43:	83 e0 03             	and    $0x3,%eax
80106a46:	66 83 f8 03          	cmp    $0x3,%ax
80106a4a:	0f 84 08 02 00 00    	je     80106c58 <trap+0x2d8>
        exit();


    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && mythread() && mythread()->state == RUNNING &&
80106a50:	e8 8b cf ff ff       	call   801039e0 <myproc>
80106a55:	85 c0                	test   %eax,%eax
80106a57:	74 1f                	je     80106a78 <trap+0xf8>
80106a59:	e8 b2 cf ff ff       	call   80103a10 <mythread>
80106a5e:	85 c0                	test   %eax,%eax
80106a60:	74 16                	je     80106a78 <trap+0xf8>
80106a62:	e8 a9 cf ff ff       	call   80103a10 <mythread>
80106a67:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80106a6b:	0f 84 9f 01 00 00    	je     80106c10 <trap+0x290>
80106a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        tf->trapno == T_IRQ0 + IRQ_TIMER) {
        yield();
    }

    if(mythread() && mythread()->tkilled){
80106a78:	e8 93 cf ff ff       	call   80103a10 <mythread>
80106a7d:	85 c0                	test   %eax,%eax
80106a7f:	74 10                	je     80106a91 <trap+0x111>
80106a81:	e8 8a cf ff ff       	call   80103a10 <mythread>
80106a86:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106a89:	85 c9                	test   %ecx,%ecx
80106a8b:	0f 85 af 00 00 00    	jne    80106b40 <trap+0x1c0>
        kthread_exit();

    }

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106a91:	e8 4a cf ff ff       	call   801039e0 <myproc>
80106a96:	85 c0                	test   %eax,%eax
80106a98:	74 1d                	je     80106ab7 <trap+0x137>
80106a9a:	e8 41 cf ff ff       	call   801039e0 <myproc>
80106a9f:	8b 50 1c             	mov    0x1c(%eax),%edx
80106aa2:	85 d2                	test   %edx,%edx
80106aa4:	74 11                	je     80106ab7 <trap+0x137>
80106aa6:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106aaa:	83 e0 03             	and    $0x3,%eax
80106aad:	66 83 f8 03          	cmp    $0x3,%ax
80106ab1:	0f 84 b1 01 00 00    	je     80106c68 <trap+0x2e8>
        exit();

    // Check if the thread has been killed since we yielded
    if (mythread() && mythread()->tkilled && (tf->cs & 3) == DPL_USER){
80106ab7:	e8 54 cf ff ff       	call   80103a10 <mythread>
80106abc:	85 c0                	test   %eax,%eax
80106abe:	74 19                	je     80106ad9 <trap+0x159>
80106ac0:	e8 4b cf ff ff       	call   80103a10 <mythread>
80106ac5:	8b 40 1c             	mov    0x1c(%eax),%eax
80106ac8:	85 c0                	test   %eax,%eax
80106aca:	74 0d                	je     80106ad9 <trap+0x159>
80106acc:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106ad0:	83 e0 03             	and    $0x3,%eax
80106ad3:	66 83 f8 03          	cmp    $0x3,%ax
80106ad7:	74 58                	je     80106b31 <trap+0x1b1>
        if(DEBUGMODE > 0)
            cprintf("the thread has been killed since we yielded -> kthread_exit()\n");
        kthread_exit();
    }
}
80106ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106adc:	5b                   	pop    %ebx
80106add:	5e                   	pop    %esi
80106ade:	5f                   	pop    %edi
80106adf:	5d                   	pop    %ebp
80106ae0:	c3                   	ret    
80106ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed)
80106ae8:	e8 f3 ce ff ff       	call   801039e0 <myproc>
80106aed:	8b 40 1c             	mov    0x1c(%eax),%eax
80106af0:	85 c0                	test   %eax,%eax
80106af2:	0f 85 50 01 00 00    	jne    80106c48 <trap+0x2c8>
        if (mythread()->tkilled) {
80106af8:	e8 13 cf ff ff       	call   80103a10 <mythread>
80106afd:	8b 40 1c             	mov    0x1c(%eax),%eax
80106b00:	85 c0                	test   %eax,%eax
80106b02:	0f 85 30 01 00 00    	jne    80106c38 <trap+0x2b8>
        mythread()->tf = tf;
80106b08:	e8 03 cf ff ff       	call   80103a10 <mythread>
80106b0d:	89 78 10             	mov    %edi,0x10(%eax)
        syscall();
80106b10:	e8 cb ed ff ff       	call   801058e0 <syscall>
        if (myproc()->killed)
80106b15:	e8 c6 ce ff ff       	call   801039e0 <myproc>
80106b1a:	8b 78 1c             	mov    0x1c(%eax),%edi
80106b1d:	85 ff                	test   %edi,%edi
80106b1f:	0f 85 03 01 00 00    	jne    80106c28 <trap+0x2a8>
        if (mythread()->tkilled) {
80106b25:	e8 e6 ce ff ff       	call   80103a10 <mythread>
80106b2a:	8b 70 1c             	mov    0x1c(%eax),%esi
80106b2d:	85 f6                	test   %esi,%esi
80106b2f:	74 a8                	je     80106ad9 <trap+0x159>
}
80106b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b34:	5b                   	pop    %ebx
80106b35:	5e                   	pop    %esi
80106b36:	5f                   	pop    %edi
80106b37:	5d                   	pop    %ebp
            kthread_exit();
80106b38:	e9 a3 d9 ff ff       	jmp    801044e0 <kthread_exit>
80106b3d:	8d 76 00             	lea    0x0(%esi),%esi
        kthread_exit();
80106b40:	e8 9b d9 ff ff       	call   801044e0 <kthread_exit>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106b45:	e8 96 ce ff ff       	call   801039e0 <myproc>
80106b4a:	85 c0                	test   %eax,%eax
80106b4c:	0f 85 48 ff ff ff    	jne    80106a9a <trap+0x11a>
80106b52:	e9 60 ff ff ff       	jmp    80106ab7 <trap+0x137>
80106b57:	89 f6                	mov    %esi,%esi
80106b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (cpuid() == 0) {
80106b60:	e8 5b ce ff ff       	call   801039c0 <cpuid>
80106b65:	85 c0                	test   %eax,%eax
80106b67:	0f 84 0b 01 00 00    	je     80106c78 <trap+0x2f8>
            lapiceoi();
80106b6d:	e8 7e bc ff ff       	call   801027f0 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106b72:	e8 69 ce ff ff       	call   801039e0 <myproc>
80106b77:	85 c0                	test   %eax,%eax
80106b79:	0f 85 b4 fe ff ff    	jne    80106a33 <trap+0xb3>
80106b7f:	e9 cc fe ff ff       	jmp    80106a50 <trap+0xd0>
80106b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106b88:	e8 23 bb ff ff       	call   801026b0 <kbdintr>
            lapiceoi();
80106b8d:	e8 5e bc ff ff       	call   801027f0 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106b92:	e8 49 ce ff ff       	call   801039e0 <myproc>
80106b97:	85 c0                	test   %eax,%eax
80106b99:	0f 85 94 fe ff ff    	jne    80106a33 <trap+0xb3>
80106b9f:	e9 ac fe ff ff       	jmp    80106a50 <trap+0xd0>
80106ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80106ba8:	e8 a3 02 00 00       	call   80106e50 <uartintr>
            lapiceoi();
80106bad:	e8 3e bc ff ff       	call   801027f0 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106bb2:	e8 29 ce ff ff       	call   801039e0 <myproc>
80106bb7:	85 c0                	test   %eax,%eax
80106bb9:	0f 85 74 fe ff ff    	jne    80106a33 <trap+0xb3>
80106bbf:	e9 8c fe ff ff       	jmp    80106a50 <trap+0xd0>
80106bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106bc8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106bcc:	8b 77 38             	mov    0x38(%edi),%esi
80106bcf:	e8 ec cd ff ff       	call   801039c0 <cpuid>
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
80106bd6:	50                   	push   %eax
80106bd7:	68 68 8a 10 80       	push   $0x80108a68
80106bdc:	e8 7f 9a ff ff       	call   80100660 <cprintf>
            lapiceoi();
80106be1:	e8 0a bc ff ff       	call   801027f0 <lapiceoi>
            break;
80106be6:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106be9:	e8 f2 cd ff ff       	call   801039e0 <myproc>
80106bee:	85 c0                	test   %eax,%eax
80106bf0:	0f 85 3d fe ff ff    	jne    80106a33 <trap+0xb3>
80106bf6:	e9 55 fe ff ff       	jmp    80106a50 <trap+0xd0>
80106bfb:	90                   	nop
80106bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
80106c00:	e8 1b b5 ff ff       	call   80102120 <ideintr>
80106c05:	e9 63 ff ff ff       	jmp    80106b6d <trap+0x1ed>
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (myproc() && mythread() && mythread()->state == RUNNING &&
80106c10:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106c14:	0f 85 5e fe ff ff    	jne    80106a78 <trap+0xf8>
        yield();
80106c1a:	e8 51 d3 ff ff       	call   80103f70 <yield>
80106c1f:	e9 54 fe ff ff       	jmp    80106a78 <trap+0xf8>
80106c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            exit();
80106c28:	e8 e3 dc ff ff       	call   80104910 <exit>
80106c2d:	e9 f3 fe ff ff       	jmp    80106b25 <trap+0x1a5>
80106c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            kthread_exit();
80106c38:	e8 a3 d8 ff ff       	call   801044e0 <kthread_exit>
80106c3d:	e9 c6 fe ff ff       	jmp    80106b08 <trap+0x188>
80106c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
80106c48:	e8 c3 dc ff ff       	call   80104910 <exit>
80106c4d:	e9 a6 fe ff ff       	jmp    80106af8 <trap+0x178>
80106c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
80106c58:	e8 b3 dc ff ff       	call   80104910 <exit>
80106c5d:	e9 ee fd ff ff       	jmp    80106a50 <trap+0xd0>
80106c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
80106c68:	e8 a3 dc ff ff       	call   80104910 <exit>
80106c6d:	e9 45 fe ff ff       	jmp    80106ab7 <trap+0x137>
80106c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                acquire(&tickslock);
80106c78:	83 ec 0c             	sub    $0xc,%esp
80106c7b:	68 20 de 15 80       	push   $0x8015de20
80106c80:	e8 4b e7 ff ff       	call   801053d0 <acquire>
                wakeup(&ticks);
80106c85:	c7 04 24 60 e6 15 80 	movl   $0x8015e660,(%esp)
                ticks++;
80106c8c:	83 05 60 e6 15 80 01 	addl   $0x1,0x8015e660
                wakeup(&ticks);
80106c93:	e8 28 d3 ff ff       	call   80103fc0 <wakeup>
                release(&tickslock);
80106c98:	c7 04 24 20 de 15 80 	movl   $0x8015de20,(%esp)
80106c9f:	e8 fc e7 ff ff       	call   801054a0 <release>
80106ca4:	83 c4 10             	add    $0x10,%esp
80106ca7:	e9 c1 fe ff ff       	jmp    80106b6d <trap+0x1ed>
80106cac:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106caf:	e8 0c cd ff ff       	call   801039c0 <cpuid>
80106cb4:	83 ec 0c             	sub    $0xc,%esp
80106cb7:	56                   	push   %esi
80106cb8:	53                   	push   %ebx
80106cb9:	50                   	push   %eax
80106cba:	ff 77 30             	pushl  0x30(%edi)
80106cbd:	68 8c 8a 10 80       	push   $0x80108a8c
80106cc2:	e8 99 99 ff ff       	call   80100660 <cprintf>
                panic("trap");
80106cc7:	83 c4 14             	add    $0x14,%esp
80106cca:	68 62 8a 10 80       	push   $0x80108a62
80106ccf:	e8 bc 96 ff ff       	call   80100390 <panic>
80106cd4:	66 90                	xchg   %ax,%ax
80106cd6:	66 90                	xchg   %ax,%ax
80106cd8:	66 90                	xchg   %ax,%ax
80106cda:	66 90                	xchg   %ax,%ax
80106cdc:	66 90                	xchg   %ax,%ax
80106cde:	66 90                	xchg   %ax,%ax

80106ce0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106ce0:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
{
80106ce5:	55                   	push   %ebp
80106ce6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106ce8:	85 c0                	test   %eax,%eax
80106cea:	74 1c                	je     80106d08 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106cec:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106cf1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106cf2:	a8 01                	test   $0x1,%al
80106cf4:	74 12                	je     80106d08 <uartgetc+0x28>
80106cf6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106cfb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106cfc:	0f b6 c0             	movzbl %al,%eax
}
80106cff:	5d                   	pop    %ebp
80106d00:	c3                   	ret    
80106d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d0d:	5d                   	pop    %ebp
80106d0e:	c3                   	ret    
80106d0f:	90                   	nop

80106d10 <uartputc.part.0>:
uartputc(int c)
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	89 c7                	mov    %eax,%edi
80106d18:	bb 80 00 00 00       	mov    $0x80,%ebx
80106d1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106d22:	83 ec 0c             	sub    $0xc,%esp
80106d25:	eb 1b                	jmp    80106d42 <uartputc.part.0+0x32>
80106d27:	89 f6                	mov    %esi,%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106d30:	83 ec 0c             	sub    $0xc,%esp
80106d33:	6a 0a                	push   $0xa
80106d35:	e8 d6 ba ff ff       	call   80102810 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d3a:	83 c4 10             	add    $0x10,%esp
80106d3d:	83 eb 01             	sub    $0x1,%ebx
80106d40:	74 07                	je     80106d49 <uartputc.part.0+0x39>
80106d42:	89 f2                	mov    %esi,%edx
80106d44:	ec                   	in     (%dx),%al
80106d45:	a8 20                	test   $0x20,%al
80106d47:	74 e7                	je     80106d30 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d4e:	89 f8                	mov    %edi,%eax
80106d50:	ee                   	out    %al,(%dx)
}
80106d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d54:	5b                   	pop    %ebx
80106d55:	5e                   	pop    %esi
80106d56:	5f                   	pop    %edi
80106d57:	5d                   	pop    %ebp
80106d58:	c3                   	ret    
80106d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d60 <uartinit>:
{
80106d60:	55                   	push   %ebp
80106d61:	31 c9                	xor    %ecx,%ecx
80106d63:	89 c8                	mov    %ecx,%eax
80106d65:	89 e5                	mov    %esp,%ebp
80106d67:	57                   	push   %edi
80106d68:	56                   	push   %esi
80106d69:	53                   	push   %ebx
80106d6a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106d6f:	89 da                	mov    %ebx,%edx
80106d71:	83 ec 0c             	sub    $0xc,%esp
80106d74:	ee                   	out    %al,(%dx)
80106d75:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106d7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106d7f:	89 fa                	mov    %edi,%edx
80106d81:	ee                   	out    %al,(%dx)
80106d82:	b8 0c 00 00 00       	mov    $0xc,%eax
80106d87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d8c:	ee                   	out    %al,(%dx)
80106d8d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106d92:	89 c8                	mov    %ecx,%eax
80106d94:	89 f2                	mov    %esi,%edx
80106d96:	ee                   	out    %al,(%dx)
80106d97:	b8 03 00 00 00       	mov    $0x3,%eax
80106d9c:	89 fa                	mov    %edi,%edx
80106d9e:	ee                   	out    %al,(%dx)
80106d9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106da4:	89 c8                	mov    %ecx,%eax
80106da6:	ee                   	out    %al,(%dx)
80106da7:	b8 01 00 00 00       	mov    $0x1,%eax
80106dac:	89 f2                	mov    %esi,%edx
80106dae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106daf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106db4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106db5:	3c ff                	cmp    $0xff,%al
80106db7:	74 5a                	je     80106e13 <uartinit+0xb3>
  uart = 1;
80106db9:	c7 05 c4 b5 10 80 01 	movl   $0x1,0x8010b5c4
80106dc0:	00 00 00 
80106dc3:	89 da                	mov    %ebx,%edx
80106dc5:	ec                   	in     (%dx),%al
80106dc6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106dcb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106dcc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106dcf:	bb 84 8b 10 80       	mov    $0x80108b84,%ebx
  ioapicenable(IRQ_COM1, 0);
80106dd4:	6a 00                	push   $0x0
80106dd6:	6a 04                	push   $0x4
80106dd8:	e8 93 b5 ff ff       	call   80102370 <ioapicenable>
80106ddd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106de0:	b8 78 00 00 00       	mov    $0x78,%eax
80106de5:	eb 13                	jmp    80106dfa <uartinit+0x9a>
80106de7:	89 f6                	mov    %esi,%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106df0:	83 c3 01             	add    $0x1,%ebx
80106df3:	0f be 03             	movsbl (%ebx),%eax
80106df6:	84 c0                	test   %al,%al
80106df8:	74 19                	je     80106e13 <uartinit+0xb3>
  if(!uart)
80106dfa:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
80106e00:	85 d2                	test   %edx,%edx
80106e02:	74 ec                	je     80106df0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106e04:	83 c3 01             	add    $0x1,%ebx
80106e07:	e8 04 ff ff ff       	call   80106d10 <uartputc.part.0>
80106e0c:	0f be 03             	movsbl (%ebx),%eax
80106e0f:	84 c0                	test   %al,%al
80106e11:	75 e7                	jne    80106dfa <uartinit+0x9a>
}
80106e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e16:	5b                   	pop    %ebx
80106e17:	5e                   	pop    %esi
80106e18:	5f                   	pop    %edi
80106e19:	5d                   	pop    %ebp
80106e1a:	c3                   	ret    
80106e1b:	90                   	nop
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e20 <uartputc>:
  if(!uart)
80106e20:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
{
80106e26:	55                   	push   %ebp
80106e27:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106e29:	85 d2                	test   %edx,%edx
{
80106e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106e2e:	74 10                	je     80106e40 <uartputc+0x20>
}
80106e30:	5d                   	pop    %ebp
80106e31:	e9 da fe ff ff       	jmp    80106d10 <uartputc.part.0>
80106e36:	8d 76 00             	lea    0x0(%esi),%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e40:	5d                   	pop    %ebp
80106e41:	c3                   	ret    
80106e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e50 <uartintr>:

void
uartintr(void)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106e56:	68 e0 6c 10 80       	push   $0x80106ce0
80106e5b:	e8 b0 99 ff ff       	call   80100810 <consoleintr>
}
80106e60:	83 c4 10             	add    $0x10,%esp
80106e63:	c9                   	leave  
80106e64:	c3                   	ret    

80106e65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $0
80106e67:	6a 00                	push   $0x0
  jmp alltraps
80106e69:	e9 39 fa ff ff       	jmp    801068a7 <alltraps>

80106e6e <vector1>:
.globl vector1
vector1:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $1
80106e70:	6a 01                	push   $0x1
  jmp alltraps
80106e72:	e9 30 fa ff ff       	jmp    801068a7 <alltraps>

80106e77 <vector2>:
.globl vector2
vector2:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $2
80106e79:	6a 02                	push   $0x2
  jmp alltraps
80106e7b:	e9 27 fa ff ff       	jmp    801068a7 <alltraps>

80106e80 <vector3>:
.globl vector3
vector3:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $3
80106e82:	6a 03                	push   $0x3
  jmp alltraps
80106e84:	e9 1e fa ff ff       	jmp    801068a7 <alltraps>

80106e89 <vector4>:
.globl vector4
vector4:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $4
80106e8b:	6a 04                	push   $0x4
  jmp alltraps
80106e8d:	e9 15 fa ff ff       	jmp    801068a7 <alltraps>

80106e92 <vector5>:
.globl vector5
vector5:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $5
80106e94:	6a 05                	push   $0x5
  jmp alltraps
80106e96:	e9 0c fa ff ff       	jmp    801068a7 <alltraps>

80106e9b <vector6>:
.globl vector6
vector6:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $6
80106e9d:	6a 06                	push   $0x6
  jmp alltraps
80106e9f:	e9 03 fa ff ff       	jmp    801068a7 <alltraps>

80106ea4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $7
80106ea6:	6a 07                	push   $0x7
  jmp alltraps
80106ea8:	e9 fa f9 ff ff       	jmp    801068a7 <alltraps>

80106ead <vector8>:
.globl vector8
vector8:
  pushl $8
80106ead:	6a 08                	push   $0x8
  jmp alltraps
80106eaf:	e9 f3 f9 ff ff       	jmp    801068a7 <alltraps>

80106eb4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $9
80106eb6:	6a 09                	push   $0x9
  jmp alltraps
80106eb8:	e9 ea f9 ff ff       	jmp    801068a7 <alltraps>

80106ebd <vector10>:
.globl vector10
vector10:
  pushl $10
80106ebd:	6a 0a                	push   $0xa
  jmp alltraps
80106ebf:	e9 e3 f9 ff ff       	jmp    801068a7 <alltraps>

80106ec4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ec4:	6a 0b                	push   $0xb
  jmp alltraps
80106ec6:	e9 dc f9 ff ff       	jmp    801068a7 <alltraps>

80106ecb <vector12>:
.globl vector12
vector12:
  pushl $12
80106ecb:	6a 0c                	push   $0xc
  jmp alltraps
80106ecd:	e9 d5 f9 ff ff       	jmp    801068a7 <alltraps>

80106ed2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ed2:	6a 0d                	push   $0xd
  jmp alltraps
80106ed4:	e9 ce f9 ff ff       	jmp    801068a7 <alltraps>

80106ed9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ed9:	6a 0e                	push   $0xe
  jmp alltraps
80106edb:	e9 c7 f9 ff ff       	jmp    801068a7 <alltraps>

80106ee0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $15
80106ee2:	6a 0f                	push   $0xf
  jmp alltraps
80106ee4:	e9 be f9 ff ff       	jmp    801068a7 <alltraps>

80106ee9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $16
80106eeb:	6a 10                	push   $0x10
  jmp alltraps
80106eed:	e9 b5 f9 ff ff       	jmp    801068a7 <alltraps>

80106ef2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ef2:	6a 11                	push   $0x11
  jmp alltraps
80106ef4:	e9 ae f9 ff ff       	jmp    801068a7 <alltraps>

80106ef9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $18
80106efb:	6a 12                	push   $0x12
  jmp alltraps
80106efd:	e9 a5 f9 ff ff       	jmp    801068a7 <alltraps>

80106f02 <vector19>:
.globl vector19
vector19:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $19
80106f04:	6a 13                	push   $0x13
  jmp alltraps
80106f06:	e9 9c f9 ff ff       	jmp    801068a7 <alltraps>

80106f0b <vector20>:
.globl vector20
vector20:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $20
80106f0d:	6a 14                	push   $0x14
  jmp alltraps
80106f0f:	e9 93 f9 ff ff       	jmp    801068a7 <alltraps>

80106f14 <vector21>:
.globl vector21
vector21:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $21
80106f16:	6a 15                	push   $0x15
  jmp alltraps
80106f18:	e9 8a f9 ff ff       	jmp    801068a7 <alltraps>

80106f1d <vector22>:
.globl vector22
vector22:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $22
80106f1f:	6a 16                	push   $0x16
  jmp alltraps
80106f21:	e9 81 f9 ff ff       	jmp    801068a7 <alltraps>

80106f26 <vector23>:
.globl vector23
vector23:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $23
80106f28:	6a 17                	push   $0x17
  jmp alltraps
80106f2a:	e9 78 f9 ff ff       	jmp    801068a7 <alltraps>

80106f2f <vector24>:
.globl vector24
vector24:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $24
80106f31:	6a 18                	push   $0x18
  jmp alltraps
80106f33:	e9 6f f9 ff ff       	jmp    801068a7 <alltraps>

80106f38 <vector25>:
.globl vector25
vector25:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $25
80106f3a:	6a 19                	push   $0x19
  jmp alltraps
80106f3c:	e9 66 f9 ff ff       	jmp    801068a7 <alltraps>

80106f41 <vector26>:
.globl vector26
vector26:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $26
80106f43:	6a 1a                	push   $0x1a
  jmp alltraps
80106f45:	e9 5d f9 ff ff       	jmp    801068a7 <alltraps>

80106f4a <vector27>:
.globl vector27
vector27:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $27
80106f4c:	6a 1b                	push   $0x1b
  jmp alltraps
80106f4e:	e9 54 f9 ff ff       	jmp    801068a7 <alltraps>

80106f53 <vector28>:
.globl vector28
vector28:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $28
80106f55:	6a 1c                	push   $0x1c
  jmp alltraps
80106f57:	e9 4b f9 ff ff       	jmp    801068a7 <alltraps>

80106f5c <vector29>:
.globl vector29
vector29:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $29
80106f5e:	6a 1d                	push   $0x1d
  jmp alltraps
80106f60:	e9 42 f9 ff ff       	jmp    801068a7 <alltraps>

80106f65 <vector30>:
.globl vector30
vector30:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $30
80106f67:	6a 1e                	push   $0x1e
  jmp alltraps
80106f69:	e9 39 f9 ff ff       	jmp    801068a7 <alltraps>

80106f6e <vector31>:
.globl vector31
vector31:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $31
80106f70:	6a 1f                	push   $0x1f
  jmp alltraps
80106f72:	e9 30 f9 ff ff       	jmp    801068a7 <alltraps>

80106f77 <vector32>:
.globl vector32
vector32:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $32
80106f79:	6a 20                	push   $0x20
  jmp alltraps
80106f7b:	e9 27 f9 ff ff       	jmp    801068a7 <alltraps>

80106f80 <vector33>:
.globl vector33
vector33:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $33
80106f82:	6a 21                	push   $0x21
  jmp alltraps
80106f84:	e9 1e f9 ff ff       	jmp    801068a7 <alltraps>

80106f89 <vector34>:
.globl vector34
vector34:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $34
80106f8b:	6a 22                	push   $0x22
  jmp alltraps
80106f8d:	e9 15 f9 ff ff       	jmp    801068a7 <alltraps>

80106f92 <vector35>:
.globl vector35
vector35:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $35
80106f94:	6a 23                	push   $0x23
  jmp alltraps
80106f96:	e9 0c f9 ff ff       	jmp    801068a7 <alltraps>

80106f9b <vector36>:
.globl vector36
vector36:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $36
80106f9d:	6a 24                	push   $0x24
  jmp alltraps
80106f9f:	e9 03 f9 ff ff       	jmp    801068a7 <alltraps>

80106fa4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $37
80106fa6:	6a 25                	push   $0x25
  jmp alltraps
80106fa8:	e9 fa f8 ff ff       	jmp    801068a7 <alltraps>

80106fad <vector38>:
.globl vector38
vector38:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $38
80106faf:	6a 26                	push   $0x26
  jmp alltraps
80106fb1:	e9 f1 f8 ff ff       	jmp    801068a7 <alltraps>

80106fb6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $39
80106fb8:	6a 27                	push   $0x27
  jmp alltraps
80106fba:	e9 e8 f8 ff ff       	jmp    801068a7 <alltraps>

80106fbf <vector40>:
.globl vector40
vector40:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $40
80106fc1:	6a 28                	push   $0x28
  jmp alltraps
80106fc3:	e9 df f8 ff ff       	jmp    801068a7 <alltraps>

80106fc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $41
80106fca:	6a 29                	push   $0x29
  jmp alltraps
80106fcc:	e9 d6 f8 ff ff       	jmp    801068a7 <alltraps>

80106fd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $42
80106fd3:	6a 2a                	push   $0x2a
  jmp alltraps
80106fd5:	e9 cd f8 ff ff       	jmp    801068a7 <alltraps>

80106fda <vector43>:
.globl vector43
vector43:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $43
80106fdc:	6a 2b                	push   $0x2b
  jmp alltraps
80106fde:	e9 c4 f8 ff ff       	jmp    801068a7 <alltraps>

80106fe3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $44
80106fe5:	6a 2c                	push   $0x2c
  jmp alltraps
80106fe7:	e9 bb f8 ff ff       	jmp    801068a7 <alltraps>

80106fec <vector45>:
.globl vector45
vector45:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $45
80106fee:	6a 2d                	push   $0x2d
  jmp alltraps
80106ff0:	e9 b2 f8 ff ff       	jmp    801068a7 <alltraps>

80106ff5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $46
80106ff7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ff9:	e9 a9 f8 ff ff       	jmp    801068a7 <alltraps>

80106ffe <vector47>:
.globl vector47
vector47:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $47
80107000:	6a 2f                	push   $0x2f
  jmp alltraps
80107002:	e9 a0 f8 ff ff       	jmp    801068a7 <alltraps>

80107007 <vector48>:
.globl vector48
vector48:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $48
80107009:	6a 30                	push   $0x30
  jmp alltraps
8010700b:	e9 97 f8 ff ff       	jmp    801068a7 <alltraps>

80107010 <vector49>:
.globl vector49
vector49:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $49
80107012:	6a 31                	push   $0x31
  jmp alltraps
80107014:	e9 8e f8 ff ff       	jmp    801068a7 <alltraps>

80107019 <vector50>:
.globl vector50
vector50:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $50
8010701b:	6a 32                	push   $0x32
  jmp alltraps
8010701d:	e9 85 f8 ff ff       	jmp    801068a7 <alltraps>

80107022 <vector51>:
.globl vector51
vector51:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $51
80107024:	6a 33                	push   $0x33
  jmp alltraps
80107026:	e9 7c f8 ff ff       	jmp    801068a7 <alltraps>

8010702b <vector52>:
.globl vector52
vector52:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $52
8010702d:	6a 34                	push   $0x34
  jmp alltraps
8010702f:	e9 73 f8 ff ff       	jmp    801068a7 <alltraps>

80107034 <vector53>:
.globl vector53
vector53:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $53
80107036:	6a 35                	push   $0x35
  jmp alltraps
80107038:	e9 6a f8 ff ff       	jmp    801068a7 <alltraps>

8010703d <vector54>:
.globl vector54
vector54:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $54
8010703f:	6a 36                	push   $0x36
  jmp alltraps
80107041:	e9 61 f8 ff ff       	jmp    801068a7 <alltraps>

80107046 <vector55>:
.globl vector55
vector55:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $55
80107048:	6a 37                	push   $0x37
  jmp alltraps
8010704a:	e9 58 f8 ff ff       	jmp    801068a7 <alltraps>

8010704f <vector56>:
.globl vector56
vector56:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $56
80107051:	6a 38                	push   $0x38
  jmp alltraps
80107053:	e9 4f f8 ff ff       	jmp    801068a7 <alltraps>

80107058 <vector57>:
.globl vector57
vector57:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $57
8010705a:	6a 39                	push   $0x39
  jmp alltraps
8010705c:	e9 46 f8 ff ff       	jmp    801068a7 <alltraps>

80107061 <vector58>:
.globl vector58
vector58:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $58
80107063:	6a 3a                	push   $0x3a
  jmp alltraps
80107065:	e9 3d f8 ff ff       	jmp    801068a7 <alltraps>

8010706a <vector59>:
.globl vector59
vector59:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $59
8010706c:	6a 3b                	push   $0x3b
  jmp alltraps
8010706e:	e9 34 f8 ff ff       	jmp    801068a7 <alltraps>

80107073 <vector60>:
.globl vector60
vector60:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $60
80107075:	6a 3c                	push   $0x3c
  jmp alltraps
80107077:	e9 2b f8 ff ff       	jmp    801068a7 <alltraps>

8010707c <vector61>:
.globl vector61
vector61:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $61
8010707e:	6a 3d                	push   $0x3d
  jmp alltraps
80107080:	e9 22 f8 ff ff       	jmp    801068a7 <alltraps>

80107085 <vector62>:
.globl vector62
vector62:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $62
80107087:	6a 3e                	push   $0x3e
  jmp alltraps
80107089:	e9 19 f8 ff ff       	jmp    801068a7 <alltraps>

8010708e <vector63>:
.globl vector63
vector63:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $63
80107090:	6a 3f                	push   $0x3f
  jmp alltraps
80107092:	e9 10 f8 ff ff       	jmp    801068a7 <alltraps>

80107097 <vector64>:
.globl vector64
vector64:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $64
80107099:	6a 40                	push   $0x40
  jmp alltraps
8010709b:	e9 07 f8 ff ff       	jmp    801068a7 <alltraps>

801070a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $65
801070a2:	6a 41                	push   $0x41
  jmp alltraps
801070a4:	e9 fe f7 ff ff       	jmp    801068a7 <alltraps>

801070a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $66
801070ab:	6a 42                	push   $0x42
  jmp alltraps
801070ad:	e9 f5 f7 ff ff       	jmp    801068a7 <alltraps>

801070b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $67
801070b4:	6a 43                	push   $0x43
  jmp alltraps
801070b6:	e9 ec f7 ff ff       	jmp    801068a7 <alltraps>

801070bb <vector68>:
.globl vector68
vector68:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $68
801070bd:	6a 44                	push   $0x44
  jmp alltraps
801070bf:	e9 e3 f7 ff ff       	jmp    801068a7 <alltraps>

801070c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $69
801070c6:	6a 45                	push   $0x45
  jmp alltraps
801070c8:	e9 da f7 ff ff       	jmp    801068a7 <alltraps>

801070cd <vector70>:
.globl vector70
vector70:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $70
801070cf:	6a 46                	push   $0x46
  jmp alltraps
801070d1:	e9 d1 f7 ff ff       	jmp    801068a7 <alltraps>

801070d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $71
801070d8:	6a 47                	push   $0x47
  jmp alltraps
801070da:	e9 c8 f7 ff ff       	jmp    801068a7 <alltraps>

801070df <vector72>:
.globl vector72
vector72:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $72
801070e1:	6a 48                	push   $0x48
  jmp alltraps
801070e3:	e9 bf f7 ff ff       	jmp    801068a7 <alltraps>

801070e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $73
801070ea:	6a 49                	push   $0x49
  jmp alltraps
801070ec:	e9 b6 f7 ff ff       	jmp    801068a7 <alltraps>

801070f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $74
801070f3:	6a 4a                	push   $0x4a
  jmp alltraps
801070f5:	e9 ad f7 ff ff       	jmp    801068a7 <alltraps>

801070fa <vector75>:
.globl vector75
vector75:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $75
801070fc:	6a 4b                	push   $0x4b
  jmp alltraps
801070fe:	e9 a4 f7 ff ff       	jmp    801068a7 <alltraps>

80107103 <vector76>:
.globl vector76
vector76:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $76
80107105:	6a 4c                	push   $0x4c
  jmp alltraps
80107107:	e9 9b f7 ff ff       	jmp    801068a7 <alltraps>

8010710c <vector77>:
.globl vector77
vector77:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $77
8010710e:	6a 4d                	push   $0x4d
  jmp alltraps
80107110:	e9 92 f7 ff ff       	jmp    801068a7 <alltraps>

80107115 <vector78>:
.globl vector78
vector78:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $78
80107117:	6a 4e                	push   $0x4e
  jmp alltraps
80107119:	e9 89 f7 ff ff       	jmp    801068a7 <alltraps>

8010711e <vector79>:
.globl vector79
vector79:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $79
80107120:	6a 4f                	push   $0x4f
  jmp alltraps
80107122:	e9 80 f7 ff ff       	jmp    801068a7 <alltraps>

80107127 <vector80>:
.globl vector80
vector80:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $80
80107129:	6a 50                	push   $0x50
  jmp alltraps
8010712b:	e9 77 f7 ff ff       	jmp    801068a7 <alltraps>

80107130 <vector81>:
.globl vector81
vector81:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $81
80107132:	6a 51                	push   $0x51
  jmp alltraps
80107134:	e9 6e f7 ff ff       	jmp    801068a7 <alltraps>

80107139 <vector82>:
.globl vector82
vector82:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $82
8010713b:	6a 52                	push   $0x52
  jmp alltraps
8010713d:	e9 65 f7 ff ff       	jmp    801068a7 <alltraps>

80107142 <vector83>:
.globl vector83
vector83:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $83
80107144:	6a 53                	push   $0x53
  jmp alltraps
80107146:	e9 5c f7 ff ff       	jmp    801068a7 <alltraps>

8010714b <vector84>:
.globl vector84
vector84:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $84
8010714d:	6a 54                	push   $0x54
  jmp alltraps
8010714f:	e9 53 f7 ff ff       	jmp    801068a7 <alltraps>

80107154 <vector85>:
.globl vector85
vector85:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $85
80107156:	6a 55                	push   $0x55
  jmp alltraps
80107158:	e9 4a f7 ff ff       	jmp    801068a7 <alltraps>

8010715d <vector86>:
.globl vector86
vector86:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $86
8010715f:	6a 56                	push   $0x56
  jmp alltraps
80107161:	e9 41 f7 ff ff       	jmp    801068a7 <alltraps>

80107166 <vector87>:
.globl vector87
vector87:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $87
80107168:	6a 57                	push   $0x57
  jmp alltraps
8010716a:	e9 38 f7 ff ff       	jmp    801068a7 <alltraps>

8010716f <vector88>:
.globl vector88
vector88:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $88
80107171:	6a 58                	push   $0x58
  jmp alltraps
80107173:	e9 2f f7 ff ff       	jmp    801068a7 <alltraps>

80107178 <vector89>:
.globl vector89
vector89:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $89
8010717a:	6a 59                	push   $0x59
  jmp alltraps
8010717c:	e9 26 f7 ff ff       	jmp    801068a7 <alltraps>

80107181 <vector90>:
.globl vector90
vector90:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $90
80107183:	6a 5a                	push   $0x5a
  jmp alltraps
80107185:	e9 1d f7 ff ff       	jmp    801068a7 <alltraps>

8010718a <vector91>:
.globl vector91
vector91:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $91
8010718c:	6a 5b                	push   $0x5b
  jmp alltraps
8010718e:	e9 14 f7 ff ff       	jmp    801068a7 <alltraps>

80107193 <vector92>:
.globl vector92
vector92:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $92
80107195:	6a 5c                	push   $0x5c
  jmp alltraps
80107197:	e9 0b f7 ff ff       	jmp    801068a7 <alltraps>

8010719c <vector93>:
.globl vector93
vector93:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $93
8010719e:	6a 5d                	push   $0x5d
  jmp alltraps
801071a0:	e9 02 f7 ff ff       	jmp    801068a7 <alltraps>

801071a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $94
801071a7:	6a 5e                	push   $0x5e
  jmp alltraps
801071a9:	e9 f9 f6 ff ff       	jmp    801068a7 <alltraps>

801071ae <vector95>:
.globl vector95
vector95:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $95
801071b0:	6a 5f                	push   $0x5f
  jmp alltraps
801071b2:	e9 f0 f6 ff ff       	jmp    801068a7 <alltraps>

801071b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $96
801071b9:	6a 60                	push   $0x60
  jmp alltraps
801071bb:	e9 e7 f6 ff ff       	jmp    801068a7 <alltraps>

801071c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $97
801071c2:	6a 61                	push   $0x61
  jmp alltraps
801071c4:	e9 de f6 ff ff       	jmp    801068a7 <alltraps>

801071c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $98
801071cb:	6a 62                	push   $0x62
  jmp alltraps
801071cd:	e9 d5 f6 ff ff       	jmp    801068a7 <alltraps>

801071d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $99
801071d4:	6a 63                	push   $0x63
  jmp alltraps
801071d6:	e9 cc f6 ff ff       	jmp    801068a7 <alltraps>

801071db <vector100>:
.globl vector100
vector100:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $100
801071dd:	6a 64                	push   $0x64
  jmp alltraps
801071df:	e9 c3 f6 ff ff       	jmp    801068a7 <alltraps>

801071e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $101
801071e6:	6a 65                	push   $0x65
  jmp alltraps
801071e8:	e9 ba f6 ff ff       	jmp    801068a7 <alltraps>

801071ed <vector102>:
.globl vector102
vector102:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $102
801071ef:	6a 66                	push   $0x66
  jmp alltraps
801071f1:	e9 b1 f6 ff ff       	jmp    801068a7 <alltraps>

801071f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $103
801071f8:	6a 67                	push   $0x67
  jmp alltraps
801071fa:	e9 a8 f6 ff ff       	jmp    801068a7 <alltraps>

801071ff <vector104>:
.globl vector104
vector104:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $104
80107201:	6a 68                	push   $0x68
  jmp alltraps
80107203:	e9 9f f6 ff ff       	jmp    801068a7 <alltraps>

80107208 <vector105>:
.globl vector105
vector105:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $105
8010720a:	6a 69                	push   $0x69
  jmp alltraps
8010720c:	e9 96 f6 ff ff       	jmp    801068a7 <alltraps>

80107211 <vector106>:
.globl vector106
vector106:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $106
80107213:	6a 6a                	push   $0x6a
  jmp alltraps
80107215:	e9 8d f6 ff ff       	jmp    801068a7 <alltraps>

8010721a <vector107>:
.globl vector107
vector107:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $107
8010721c:	6a 6b                	push   $0x6b
  jmp alltraps
8010721e:	e9 84 f6 ff ff       	jmp    801068a7 <alltraps>

80107223 <vector108>:
.globl vector108
vector108:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $108
80107225:	6a 6c                	push   $0x6c
  jmp alltraps
80107227:	e9 7b f6 ff ff       	jmp    801068a7 <alltraps>

8010722c <vector109>:
.globl vector109
vector109:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $109
8010722e:	6a 6d                	push   $0x6d
  jmp alltraps
80107230:	e9 72 f6 ff ff       	jmp    801068a7 <alltraps>

80107235 <vector110>:
.globl vector110
vector110:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $110
80107237:	6a 6e                	push   $0x6e
  jmp alltraps
80107239:	e9 69 f6 ff ff       	jmp    801068a7 <alltraps>

8010723e <vector111>:
.globl vector111
vector111:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $111
80107240:	6a 6f                	push   $0x6f
  jmp alltraps
80107242:	e9 60 f6 ff ff       	jmp    801068a7 <alltraps>

80107247 <vector112>:
.globl vector112
vector112:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $112
80107249:	6a 70                	push   $0x70
  jmp alltraps
8010724b:	e9 57 f6 ff ff       	jmp    801068a7 <alltraps>

80107250 <vector113>:
.globl vector113
vector113:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $113
80107252:	6a 71                	push   $0x71
  jmp alltraps
80107254:	e9 4e f6 ff ff       	jmp    801068a7 <alltraps>

80107259 <vector114>:
.globl vector114
vector114:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $114
8010725b:	6a 72                	push   $0x72
  jmp alltraps
8010725d:	e9 45 f6 ff ff       	jmp    801068a7 <alltraps>

80107262 <vector115>:
.globl vector115
vector115:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $115
80107264:	6a 73                	push   $0x73
  jmp alltraps
80107266:	e9 3c f6 ff ff       	jmp    801068a7 <alltraps>

8010726b <vector116>:
.globl vector116
vector116:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $116
8010726d:	6a 74                	push   $0x74
  jmp alltraps
8010726f:	e9 33 f6 ff ff       	jmp    801068a7 <alltraps>

80107274 <vector117>:
.globl vector117
vector117:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $117
80107276:	6a 75                	push   $0x75
  jmp alltraps
80107278:	e9 2a f6 ff ff       	jmp    801068a7 <alltraps>

8010727d <vector118>:
.globl vector118
vector118:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $118
8010727f:	6a 76                	push   $0x76
  jmp alltraps
80107281:	e9 21 f6 ff ff       	jmp    801068a7 <alltraps>

80107286 <vector119>:
.globl vector119
vector119:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $119
80107288:	6a 77                	push   $0x77
  jmp alltraps
8010728a:	e9 18 f6 ff ff       	jmp    801068a7 <alltraps>

8010728f <vector120>:
.globl vector120
vector120:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $120
80107291:	6a 78                	push   $0x78
  jmp alltraps
80107293:	e9 0f f6 ff ff       	jmp    801068a7 <alltraps>

80107298 <vector121>:
.globl vector121
vector121:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $121
8010729a:	6a 79                	push   $0x79
  jmp alltraps
8010729c:	e9 06 f6 ff ff       	jmp    801068a7 <alltraps>

801072a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $122
801072a3:	6a 7a                	push   $0x7a
  jmp alltraps
801072a5:	e9 fd f5 ff ff       	jmp    801068a7 <alltraps>

801072aa <vector123>:
.globl vector123
vector123:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $123
801072ac:	6a 7b                	push   $0x7b
  jmp alltraps
801072ae:	e9 f4 f5 ff ff       	jmp    801068a7 <alltraps>

801072b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $124
801072b5:	6a 7c                	push   $0x7c
  jmp alltraps
801072b7:	e9 eb f5 ff ff       	jmp    801068a7 <alltraps>

801072bc <vector125>:
.globl vector125
vector125:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $125
801072be:	6a 7d                	push   $0x7d
  jmp alltraps
801072c0:	e9 e2 f5 ff ff       	jmp    801068a7 <alltraps>

801072c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $126
801072c7:	6a 7e                	push   $0x7e
  jmp alltraps
801072c9:	e9 d9 f5 ff ff       	jmp    801068a7 <alltraps>

801072ce <vector127>:
.globl vector127
vector127:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $127
801072d0:	6a 7f                	push   $0x7f
  jmp alltraps
801072d2:	e9 d0 f5 ff ff       	jmp    801068a7 <alltraps>

801072d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $128
801072d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801072de:	e9 c4 f5 ff ff       	jmp    801068a7 <alltraps>

801072e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $129
801072e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801072ea:	e9 b8 f5 ff ff       	jmp    801068a7 <alltraps>

801072ef <vector130>:
.globl vector130
vector130:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $130
801072f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801072f6:	e9 ac f5 ff ff       	jmp    801068a7 <alltraps>

801072fb <vector131>:
.globl vector131
vector131:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $131
801072fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107302:	e9 a0 f5 ff ff       	jmp    801068a7 <alltraps>

80107307 <vector132>:
.globl vector132
vector132:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $132
80107309:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010730e:	e9 94 f5 ff ff       	jmp    801068a7 <alltraps>

80107313 <vector133>:
.globl vector133
vector133:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $133
80107315:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010731a:	e9 88 f5 ff ff       	jmp    801068a7 <alltraps>

8010731f <vector134>:
.globl vector134
vector134:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $134
80107321:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107326:	e9 7c f5 ff ff       	jmp    801068a7 <alltraps>

8010732b <vector135>:
.globl vector135
vector135:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $135
8010732d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107332:	e9 70 f5 ff ff       	jmp    801068a7 <alltraps>

80107337 <vector136>:
.globl vector136
vector136:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $136
80107339:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010733e:	e9 64 f5 ff ff       	jmp    801068a7 <alltraps>

80107343 <vector137>:
.globl vector137
vector137:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $137
80107345:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010734a:	e9 58 f5 ff ff       	jmp    801068a7 <alltraps>

8010734f <vector138>:
.globl vector138
vector138:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $138
80107351:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107356:	e9 4c f5 ff ff       	jmp    801068a7 <alltraps>

8010735b <vector139>:
.globl vector139
vector139:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $139
8010735d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107362:	e9 40 f5 ff ff       	jmp    801068a7 <alltraps>

80107367 <vector140>:
.globl vector140
vector140:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $140
80107369:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010736e:	e9 34 f5 ff ff       	jmp    801068a7 <alltraps>

80107373 <vector141>:
.globl vector141
vector141:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $141
80107375:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010737a:	e9 28 f5 ff ff       	jmp    801068a7 <alltraps>

8010737f <vector142>:
.globl vector142
vector142:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $142
80107381:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107386:	e9 1c f5 ff ff       	jmp    801068a7 <alltraps>

8010738b <vector143>:
.globl vector143
vector143:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $143
8010738d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107392:	e9 10 f5 ff ff       	jmp    801068a7 <alltraps>

80107397 <vector144>:
.globl vector144
vector144:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $144
80107399:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010739e:	e9 04 f5 ff ff       	jmp    801068a7 <alltraps>

801073a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $145
801073a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801073aa:	e9 f8 f4 ff ff       	jmp    801068a7 <alltraps>

801073af <vector146>:
.globl vector146
vector146:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $146
801073b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801073b6:	e9 ec f4 ff ff       	jmp    801068a7 <alltraps>

801073bb <vector147>:
.globl vector147
vector147:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $147
801073bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801073c2:	e9 e0 f4 ff ff       	jmp    801068a7 <alltraps>

801073c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $148
801073c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801073ce:	e9 d4 f4 ff ff       	jmp    801068a7 <alltraps>

801073d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $149
801073d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801073da:	e9 c8 f4 ff ff       	jmp    801068a7 <alltraps>

801073df <vector150>:
.globl vector150
vector150:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $150
801073e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801073e6:	e9 bc f4 ff ff       	jmp    801068a7 <alltraps>

801073eb <vector151>:
.globl vector151
vector151:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $151
801073ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801073f2:	e9 b0 f4 ff ff       	jmp    801068a7 <alltraps>

801073f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $152
801073f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801073fe:	e9 a4 f4 ff ff       	jmp    801068a7 <alltraps>

80107403 <vector153>:
.globl vector153
vector153:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $153
80107405:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010740a:	e9 98 f4 ff ff       	jmp    801068a7 <alltraps>

8010740f <vector154>:
.globl vector154
vector154:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $154
80107411:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107416:	e9 8c f4 ff ff       	jmp    801068a7 <alltraps>

8010741b <vector155>:
.globl vector155
vector155:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $155
8010741d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107422:	e9 80 f4 ff ff       	jmp    801068a7 <alltraps>

80107427 <vector156>:
.globl vector156
vector156:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $156
80107429:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010742e:	e9 74 f4 ff ff       	jmp    801068a7 <alltraps>

80107433 <vector157>:
.globl vector157
vector157:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $157
80107435:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010743a:	e9 68 f4 ff ff       	jmp    801068a7 <alltraps>

8010743f <vector158>:
.globl vector158
vector158:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $158
80107441:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107446:	e9 5c f4 ff ff       	jmp    801068a7 <alltraps>

8010744b <vector159>:
.globl vector159
vector159:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $159
8010744d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107452:	e9 50 f4 ff ff       	jmp    801068a7 <alltraps>

80107457 <vector160>:
.globl vector160
vector160:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $160
80107459:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010745e:	e9 44 f4 ff ff       	jmp    801068a7 <alltraps>

80107463 <vector161>:
.globl vector161
vector161:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $161
80107465:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010746a:	e9 38 f4 ff ff       	jmp    801068a7 <alltraps>

8010746f <vector162>:
.globl vector162
vector162:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $162
80107471:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107476:	e9 2c f4 ff ff       	jmp    801068a7 <alltraps>

8010747b <vector163>:
.globl vector163
vector163:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $163
8010747d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107482:	e9 20 f4 ff ff       	jmp    801068a7 <alltraps>

80107487 <vector164>:
.globl vector164
vector164:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $164
80107489:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010748e:	e9 14 f4 ff ff       	jmp    801068a7 <alltraps>

80107493 <vector165>:
.globl vector165
vector165:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $165
80107495:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010749a:	e9 08 f4 ff ff       	jmp    801068a7 <alltraps>

8010749f <vector166>:
.globl vector166
vector166:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $166
801074a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801074a6:	e9 fc f3 ff ff       	jmp    801068a7 <alltraps>

801074ab <vector167>:
.globl vector167
vector167:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $167
801074ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801074b2:	e9 f0 f3 ff ff       	jmp    801068a7 <alltraps>

801074b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $168
801074b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801074be:	e9 e4 f3 ff ff       	jmp    801068a7 <alltraps>

801074c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $169
801074c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801074ca:	e9 d8 f3 ff ff       	jmp    801068a7 <alltraps>

801074cf <vector170>:
.globl vector170
vector170:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $170
801074d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801074d6:	e9 cc f3 ff ff       	jmp    801068a7 <alltraps>

801074db <vector171>:
.globl vector171
vector171:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $171
801074dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801074e2:	e9 c0 f3 ff ff       	jmp    801068a7 <alltraps>

801074e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $172
801074e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801074ee:	e9 b4 f3 ff ff       	jmp    801068a7 <alltraps>

801074f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $173
801074f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801074fa:	e9 a8 f3 ff ff       	jmp    801068a7 <alltraps>

801074ff <vector174>:
.globl vector174
vector174:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $174
80107501:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107506:	e9 9c f3 ff ff       	jmp    801068a7 <alltraps>

8010750b <vector175>:
.globl vector175
vector175:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $175
8010750d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107512:	e9 90 f3 ff ff       	jmp    801068a7 <alltraps>

80107517 <vector176>:
.globl vector176
vector176:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $176
80107519:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010751e:	e9 84 f3 ff ff       	jmp    801068a7 <alltraps>

80107523 <vector177>:
.globl vector177
vector177:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $177
80107525:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010752a:	e9 78 f3 ff ff       	jmp    801068a7 <alltraps>

8010752f <vector178>:
.globl vector178
vector178:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $178
80107531:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107536:	e9 6c f3 ff ff       	jmp    801068a7 <alltraps>

8010753b <vector179>:
.globl vector179
vector179:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $179
8010753d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107542:	e9 60 f3 ff ff       	jmp    801068a7 <alltraps>

80107547 <vector180>:
.globl vector180
vector180:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $180
80107549:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010754e:	e9 54 f3 ff ff       	jmp    801068a7 <alltraps>

80107553 <vector181>:
.globl vector181
vector181:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $181
80107555:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010755a:	e9 48 f3 ff ff       	jmp    801068a7 <alltraps>

8010755f <vector182>:
.globl vector182
vector182:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $182
80107561:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107566:	e9 3c f3 ff ff       	jmp    801068a7 <alltraps>

8010756b <vector183>:
.globl vector183
vector183:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $183
8010756d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107572:	e9 30 f3 ff ff       	jmp    801068a7 <alltraps>

80107577 <vector184>:
.globl vector184
vector184:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $184
80107579:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010757e:	e9 24 f3 ff ff       	jmp    801068a7 <alltraps>

80107583 <vector185>:
.globl vector185
vector185:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $185
80107585:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010758a:	e9 18 f3 ff ff       	jmp    801068a7 <alltraps>

8010758f <vector186>:
.globl vector186
vector186:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $186
80107591:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107596:	e9 0c f3 ff ff       	jmp    801068a7 <alltraps>

8010759b <vector187>:
.globl vector187
vector187:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $187
8010759d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801075a2:	e9 00 f3 ff ff       	jmp    801068a7 <alltraps>

801075a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $188
801075a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801075ae:	e9 f4 f2 ff ff       	jmp    801068a7 <alltraps>

801075b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $189
801075b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801075ba:	e9 e8 f2 ff ff       	jmp    801068a7 <alltraps>

801075bf <vector190>:
.globl vector190
vector190:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $190
801075c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801075c6:	e9 dc f2 ff ff       	jmp    801068a7 <alltraps>

801075cb <vector191>:
.globl vector191
vector191:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $191
801075cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801075d2:	e9 d0 f2 ff ff       	jmp    801068a7 <alltraps>

801075d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $192
801075d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801075de:	e9 c4 f2 ff ff       	jmp    801068a7 <alltraps>

801075e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $193
801075e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801075ea:	e9 b8 f2 ff ff       	jmp    801068a7 <alltraps>

801075ef <vector194>:
.globl vector194
vector194:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $194
801075f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801075f6:	e9 ac f2 ff ff       	jmp    801068a7 <alltraps>

801075fb <vector195>:
.globl vector195
vector195:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $195
801075fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107602:	e9 a0 f2 ff ff       	jmp    801068a7 <alltraps>

80107607 <vector196>:
.globl vector196
vector196:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $196
80107609:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010760e:	e9 94 f2 ff ff       	jmp    801068a7 <alltraps>

80107613 <vector197>:
.globl vector197
vector197:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $197
80107615:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010761a:	e9 88 f2 ff ff       	jmp    801068a7 <alltraps>

8010761f <vector198>:
.globl vector198
vector198:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $198
80107621:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107626:	e9 7c f2 ff ff       	jmp    801068a7 <alltraps>

8010762b <vector199>:
.globl vector199
vector199:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $199
8010762d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107632:	e9 70 f2 ff ff       	jmp    801068a7 <alltraps>

80107637 <vector200>:
.globl vector200
vector200:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $200
80107639:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010763e:	e9 64 f2 ff ff       	jmp    801068a7 <alltraps>

80107643 <vector201>:
.globl vector201
vector201:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $201
80107645:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010764a:	e9 58 f2 ff ff       	jmp    801068a7 <alltraps>

8010764f <vector202>:
.globl vector202
vector202:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $202
80107651:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107656:	e9 4c f2 ff ff       	jmp    801068a7 <alltraps>

8010765b <vector203>:
.globl vector203
vector203:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $203
8010765d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107662:	e9 40 f2 ff ff       	jmp    801068a7 <alltraps>

80107667 <vector204>:
.globl vector204
vector204:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $204
80107669:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010766e:	e9 34 f2 ff ff       	jmp    801068a7 <alltraps>

80107673 <vector205>:
.globl vector205
vector205:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $205
80107675:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010767a:	e9 28 f2 ff ff       	jmp    801068a7 <alltraps>

8010767f <vector206>:
.globl vector206
vector206:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $206
80107681:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107686:	e9 1c f2 ff ff       	jmp    801068a7 <alltraps>

8010768b <vector207>:
.globl vector207
vector207:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $207
8010768d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107692:	e9 10 f2 ff ff       	jmp    801068a7 <alltraps>

80107697 <vector208>:
.globl vector208
vector208:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $208
80107699:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010769e:	e9 04 f2 ff ff       	jmp    801068a7 <alltraps>

801076a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $209
801076a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801076aa:	e9 f8 f1 ff ff       	jmp    801068a7 <alltraps>

801076af <vector210>:
.globl vector210
vector210:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $210
801076b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801076b6:	e9 ec f1 ff ff       	jmp    801068a7 <alltraps>

801076bb <vector211>:
.globl vector211
vector211:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $211
801076bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801076c2:	e9 e0 f1 ff ff       	jmp    801068a7 <alltraps>

801076c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $212
801076c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801076ce:	e9 d4 f1 ff ff       	jmp    801068a7 <alltraps>

801076d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $213
801076d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801076da:	e9 c8 f1 ff ff       	jmp    801068a7 <alltraps>

801076df <vector214>:
.globl vector214
vector214:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $214
801076e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801076e6:	e9 bc f1 ff ff       	jmp    801068a7 <alltraps>

801076eb <vector215>:
.globl vector215
vector215:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $215
801076ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801076f2:	e9 b0 f1 ff ff       	jmp    801068a7 <alltraps>

801076f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $216
801076f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801076fe:	e9 a4 f1 ff ff       	jmp    801068a7 <alltraps>

80107703 <vector217>:
.globl vector217
vector217:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $217
80107705:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010770a:	e9 98 f1 ff ff       	jmp    801068a7 <alltraps>

8010770f <vector218>:
.globl vector218
vector218:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $218
80107711:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107716:	e9 8c f1 ff ff       	jmp    801068a7 <alltraps>

8010771b <vector219>:
.globl vector219
vector219:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $219
8010771d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107722:	e9 80 f1 ff ff       	jmp    801068a7 <alltraps>

80107727 <vector220>:
.globl vector220
vector220:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $220
80107729:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010772e:	e9 74 f1 ff ff       	jmp    801068a7 <alltraps>

80107733 <vector221>:
.globl vector221
vector221:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $221
80107735:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010773a:	e9 68 f1 ff ff       	jmp    801068a7 <alltraps>

8010773f <vector222>:
.globl vector222
vector222:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $222
80107741:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107746:	e9 5c f1 ff ff       	jmp    801068a7 <alltraps>

8010774b <vector223>:
.globl vector223
vector223:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $223
8010774d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107752:	e9 50 f1 ff ff       	jmp    801068a7 <alltraps>

80107757 <vector224>:
.globl vector224
vector224:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $224
80107759:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010775e:	e9 44 f1 ff ff       	jmp    801068a7 <alltraps>

80107763 <vector225>:
.globl vector225
vector225:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $225
80107765:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010776a:	e9 38 f1 ff ff       	jmp    801068a7 <alltraps>

8010776f <vector226>:
.globl vector226
vector226:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $226
80107771:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107776:	e9 2c f1 ff ff       	jmp    801068a7 <alltraps>

8010777b <vector227>:
.globl vector227
vector227:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $227
8010777d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107782:	e9 20 f1 ff ff       	jmp    801068a7 <alltraps>

80107787 <vector228>:
.globl vector228
vector228:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $228
80107789:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010778e:	e9 14 f1 ff ff       	jmp    801068a7 <alltraps>

80107793 <vector229>:
.globl vector229
vector229:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $229
80107795:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010779a:	e9 08 f1 ff ff       	jmp    801068a7 <alltraps>

8010779f <vector230>:
.globl vector230
vector230:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $230
801077a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801077a6:	e9 fc f0 ff ff       	jmp    801068a7 <alltraps>

801077ab <vector231>:
.globl vector231
vector231:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $231
801077ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801077b2:	e9 f0 f0 ff ff       	jmp    801068a7 <alltraps>

801077b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $232
801077b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801077be:	e9 e4 f0 ff ff       	jmp    801068a7 <alltraps>

801077c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $233
801077c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801077ca:	e9 d8 f0 ff ff       	jmp    801068a7 <alltraps>

801077cf <vector234>:
.globl vector234
vector234:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $234
801077d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801077d6:	e9 cc f0 ff ff       	jmp    801068a7 <alltraps>

801077db <vector235>:
.globl vector235
vector235:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $235
801077dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801077e2:	e9 c0 f0 ff ff       	jmp    801068a7 <alltraps>

801077e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $236
801077e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801077ee:	e9 b4 f0 ff ff       	jmp    801068a7 <alltraps>

801077f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $237
801077f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801077fa:	e9 a8 f0 ff ff       	jmp    801068a7 <alltraps>

801077ff <vector238>:
.globl vector238
vector238:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $238
80107801:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107806:	e9 9c f0 ff ff       	jmp    801068a7 <alltraps>

8010780b <vector239>:
.globl vector239
vector239:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $239
8010780d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107812:	e9 90 f0 ff ff       	jmp    801068a7 <alltraps>

80107817 <vector240>:
.globl vector240
vector240:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $240
80107819:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010781e:	e9 84 f0 ff ff       	jmp    801068a7 <alltraps>

80107823 <vector241>:
.globl vector241
vector241:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $241
80107825:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010782a:	e9 78 f0 ff ff       	jmp    801068a7 <alltraps>

8010782f <vector242>:
.globl vector242
vector242:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $242
80107831:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107836:	e9 6c f0 ff ff       	jmp    801068a7 <alltraps>

8010783b <vector243>:
.globl vector243
vector243:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $243
8010783d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107842:	e9 60 f0 ff ff       	jmp    801068a7 <alltraps>

80107847 <vector244>:
.globl vector244
vector244:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $244
80107849:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010784e:	e9 54 f0 ff ff       	jmp    801068a7 <alltraps>

80107853 <vector245>:
.globl vector245
vector245:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $245
80107855:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010785a:	e9 48 f0 ff ff       	jmp    801068a7 <alltraps>

8010785f <vector246>:
.globl vector246
vector246:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $246
80107861:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107866:	e9 3c f0 ff ff       	jmp    801068a7 <alltraps>

8010786b <vector247>:
.globl vector247
vector247:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $247
8010786d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107872:	e9 30 f0 ff ff       	jmp    801068a7 <alltraps>

80107877 <vector248>:
.globl vector248
vector248:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $248
80107879:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010787e:	e9 24 f0 ff ff       	jmp    801068a7 <alltraps>

80107883 <vector249>:
.globl vector249
vector249:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $249
80107885:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010788a:	e9 18 f0 ff ff       	jmp    801068a7 <alltraps>

8010788f <vector250>:
.globl vector250
vector250:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $250
80107891:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107896:	e9 0c f0 ff ff       	jmp    801068a7 <alltraps>

8010789b <vector251>:
.globl vector251
vector251:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $251
8010789d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801078a2:	e9 00 f0 ff ff       	jmp    801068a7 <alltraps>

801078a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $252
801078a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801078ae:	e9 f4 ef ff ff       	jmp    801068a7 <alltraps>

801078b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $253
801078b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801078ba:	e9 e8 ef ff ff       	jmp    801068a7 <alltraps>

801078bf <vector254>:
.globl vector254
vector254:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $254
801078c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801078c6:	e9 dc ef ff ff       	jmp    801068a7 <alltraps>

801078cb <vector255>:
.globl vector255
vector255:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $255
801078cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801078d2:	e9 d0 ef ff ff       	jmp    801068a7 <alltraps>
801078d7:	66 90                	xchg   %ax,%ax
801078d9:	66 90                	xchg   %ax,%ax
801078db:	66 90                	xchg   %ax,%ax
801078dd:	66 90                	xchg   %ax,%ax
801078df:	90                   	nop

801078e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801078e6:	89 d3                	mov    %edx,%ebx
{
801078e8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801078ea:	c1 eb 16             	shr    $0x16,%ebx
801078ed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801078f0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801078f3:	8b 06                	mov    (%esi),%eax
801078f5:	a8 01                	test   $0x1,%al
801078f7:	74 27                	je     80107920 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078fe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107904:	c1 ef 0a             	shr    $0xa,%edi
}
80107907:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010790a:	89 fa                	mov    %edi,%edx
8010790c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107912:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107915:	5b                   	pop    %ebx
80107916:	5e                   	pop    %esi
80107917:	5f                   	pop    %edi
80107918:	5d                   	pop    %ebp
80107919:	c3                   	ret    
8010791a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107920:	85 c9                	test   %ecx,%ecx
80107922:	74 2c                	je     80107950 <walkpgdir+0x70>
80107924:	e8 37 ac ff ff       	call   80102560 <kalloc>
80107929:	85 c0                	test   %eax,%eax
8010792b:	89 c3                	mov    %eax,%ebx
8010792d:	74 21                	je     80107950 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010792f:	83 ec 04             	sub    $0x4,%esp
80107932:	68 00 10 00 00       	push   $0x1000
80107937:	6a 00                	push   $0x0
80107939:	50                   	push   %eax
8010793a:	e8 b1 db ff ff       	call   801054f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010793f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107945:	83 c4 10             	add    $0x10,%esp
80107948:	83 c8 07             	or     $0x7,%eax
8010794b:	89 06                	mov    %eax,(%esi)
8010794d:	eb b5                	jmp    80107904 <walkpgdir+0x24>
8010794f:	90                   	nop
}
80107950:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107953:	31 c0                	xor    %eax,%eax
}
80107955:	5b                   	pop    %ebx
80107956:	5e                   	pop    %esi
80107957:	5f                   	pop    %edi
80107958:	5d                   	pop    %ebp
80107959:	c3                   	ret    
8010795a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107960 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107960:	55                   	push   %ebp
80107961:	89 e5                	mov    %esp,%ebp
80107963:	57                   	push   %edi
80107964:	56                   	push   %esi
80107965:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107966:	89 d3                	mov    %edx,%ebx
80107968:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010796e:	83 ec 1c             	sub    $0x1c,%esp
80107971:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107974:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107978:	8b 7d 08             	mov    0x8(%ebp),%edi
8010797b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107980:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107983:	8b 45 0c             	mov    0xc(%ebp),%eax
80107986:	29 df                	sub    %ebx,%edi
80107988:	83 c8 01             	or     $0x1,%eax
8010798b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010798e:	eb 15                	jmp    801079a5 <mappages+0x45>
    if(*pte & PTE_P)
80107990:	f6 00 01             	testb  $0x1,(%eax)
80107993:	75 45                	jne    801079da <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107995:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107998:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010799b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010799d:	74 31                	je     801079d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010799f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801079a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801079ad:	89 da                	mov    %ebx,%edx
801079af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801079b2:	e8 29 ff ff ff       	call   801078e0 <walkpgdir>
801079b7:	85 c0                	test   %eax,%eax
801079b9:	75 d5                	jne    80107990 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801079bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079c3:	5b                   	pop    %ebx
801079c4:	5e                   	pop    %esi
801079c5:	5f                   	pop    %edi
801079c6:	5d                   	pop    %ebp
801079c7:	c3                   	ret    
801079c8:	90                   	nop
801079c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079d3:	31 c0                	xor    %eax,%eax
}
801079d5:	5b                   	pop    %ebx
801079d6:	5e                   	pop    %esi
801079d7:	5f                   	pop    %edi
801079d8:	5d                   	pop    %ebp
801079d9:	c3                   	ret    
      panic("remap");
801079da:	83 ec 0c             	sub    $0xc,%esp
801079dd:	68 8c 8b 10 80       	push   $0x80108b8c
801079e2:	e8 a9 89 ff ff       	call   80100390 <panic>
801079e7:	89 f6                	mov    %esi,%esi
801079e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801079f0:	55                   	push   %ebp
801079f1:	89 e5                	mov    %esp,%ebp
801079f3:	57                   	push   %edi
801079f4:	56                   	push   %esi
801079f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801079f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801079fc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801079fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a04:	83 ec 1c             	sub    $0x1c,%esp
80107a07:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a0a:	39 d3                	cmp    %edx,%ebx
80107a0c:	73 66                	jae    80107a74 <deallocuvm.part.0+0x84>
80107a0e:	89 d6                	mov    %edx,%esi
80107a10:	eb 3d                	jmp    80107a4f <deallocuvm.part.0+0x5f>
80107a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107a18:	8b 10                	mov    (%eax),%edx
80107a1a:	f6 c2 01             	test   $0x1,%dl
80107a1d:	74 26                	je     80107a45 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107a1f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107a25:	74 58                	je     80107a7f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107a27:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107a2a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107a30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107a33:	52                   	push   %edx
80107a34:	e8 77 a9 ff ff       	call   801023b0 <kfree>
      *pte = 0;
80107a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a3c:	83 c4 10             	add    $0x10,%esp
80107a3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107a45:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a4b:	39 f3                	cmp    %esi,%ebx
80107a4d:	73 25                	jae    80107a74 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107a4f:	31 c9                	xor    %ecx,%ecx
80107a51:	89 da                	mov    %ebx,%edx
80107a53:	89 f8                	mov    %edi,%eax
80107a55:	e8 86 fe ff ff       	call   801078e0 <walkpgdir>
    if(!pte)
80107a5a:	85 c0                	test   %eax,%eax
80107a5c:	75 ba                	jne    80107a18 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a5e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107a64:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107a6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a70:	39 f3                	cmp    %esi,%ebx
80107a72:	72 db                	jb     80107a4f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a7a:	5b                   	pop    %ebx
80107a7b:	5e                   	pop    %esi
80107a7c:	5f                   	pop    %edi
80107a7d:	5d                   	pop    %ebp
80107a7e:	c3                   	ret    
        panic("kfree");
80107a7f:	83 ec 0c             	sub    $0xc,%esp
80107a82:	68 86 84 10 80       	push   $0x80108486
80107a87:	e8 04 89 ff ff       	call   80100390 <panic>
80107a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a90 <seginit>:
{
80107a90:	55                   	push   %ebp
80107a91:	89 e5                	mov    %esp,%ebp
80107a93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107a96:	e8 25 bf ff ff       	call   801039c0 <cpuid>
80107a9b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
80107aa1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107aa6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107aaa:	c7 80 98 39 11 80 ff 	movl   $0xffff,-0x7feec668(%eax)
80107ab1:	ff 00 00 
80107ab4:	c7 80 9c 39 11 80 00 	movl   $0xcf9a00,-0x7feec664(%eax)
80107abb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107abe:	c7 80 a0 39 11 80 ff 	movl   $0xffff,-0x7feec660(%eax)
80107ac5:	ff 00 00 
80107ac8:	c7 80 a4 39 11 80 00 	movl   $0xcf9200,-0x7feec65c(%eax)
80107acf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107ad2:	c7 80 a8 39 11 80 ff 	movl   $0xffff,-0x7feec658(%eax)
80107ad9:	ff 00 00 
80107adc:	c7 80 ac 39 11 80 00 	movl   $0xcffa00,-0x7feec654(%eax)
80107ae3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ae6:	c7 80 b0 39 11 80 ff 	movl   $0xffff,-0x7feec650(%eax)
80107aed:	ff 00 00 
80107af0:	c7 80 b4 39 11 80 00 	movl   $0xcff200,-0x7feec64c(%eax)
80107af7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107afa:	05 90 39 11 80       	add    $0x80113990,%eax
  pd[1] = (uint)p;
80107aff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107b03:	c1 e8 10             	shr    $0x10,%eax
80107b06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107b0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107b0d:	0f 01 10             	lgdtl  (%eax)
}
80107b10:	c9                   	leave  
80107b11:	c3                   	ret    
80107b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b20:	a1 64 e6 15 80       	mov    0x8015e664,%eax
{
80107b25:	55                   	push   %ebp
80107b26:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b28:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b2d:	0f 22 d8             	mov    %eax,%cr3
}
80107b30:	5d                   	pop    %ebp
80107b31:	c3                   	ret    
80107b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b40 <switchuvm>:
{
80107b40:	55                   	push   %ebp
80107b41:	89 e5                	mov    %esp,%ebp
80107b43:	57                   	push   %edi
80107b44:	56                   	push   %esi
80107b45:	53                   	push   %ebx
80107b46:	83 ec 1c             	sub    $0x1c,%esp
80107b49:	8b 55 08             	mov    0x8(%ebp),%edx
80107b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if(p == 0)
80107b4f:	85 d2                	test   %edx,%edx
80107b51:	0f 84 d5 00 00 00    	je     80107c2c <switchuvm+0xec>
  if(t->tkstack == 0)
80107b57:	8b 41 04             	mov    0x4(%ecx),%eax
80107b5a:	85 c0                	test   %eax,%eax
80107b5c:	0f 84 e4 00 00 00    	je     80107c46 <switchuvm+0x106>
  if(p->pgdir == 0)
80107b62:	8b 7a 04             	mov    0x4(%edx),%edi
80107b65:	85 ff                	test   %edi,%edi
80107b67:	0f 84 cc 00 00 00    	je     80107c39 <switchuvm+0xf9>
80107b6d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107b70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  pushcli();
80107b73:	e8 88 d7 ff ff       	call   80105300 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b78:	e8 c3 bd ff ff       	call   80103940 <mycpu>
80107b7d:	89 c3                	mov    %eax,%ebx
80107b7f:	e8 bc bd ff ff       	call   80103940 <mycpu>
80107b84:	89 c7                	mov    %eax,%edi
80107b86:	e8 b5 bd ff ff       	call   80103940 <mycpu>
80107b8b:	89 c6                	mov    %eax,%esi
80107b8d:	83 c7 08             	add    $0x8,%edi
80107b90:	83 c6 08             	add    $0x8,%esi
80107b93:	c1 ee 10             	shr    $0x10,%esi
80107b96:	e8 a5 bd ff ff       	call   80103940 <mycpu>
80107b9b:	89 f1                	mov    %esi,%ecx
80107b9d:	83 c0 08             	add    $0x8,%eax
80107ba0:	ba 67 00 00 00       	mov    $0x67,%edx
80107ba5:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107bab:	c1 e8 18             	shr    $0x18,%eax
80107bae:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107bb3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107bba:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107bc1:	be ff ff ff ff       	mov    $0xffffffff,%esi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107bc6:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107bcd:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107bd3:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107bd8:	e8 63 bd ff ff       	call   80103940 <mycpu>
80107bdd:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107be4:	e8 57 bd ff ff       	call   80103940 <mycpu>
  mycpu()->ts.esp0 = (uint)t->tkstack + KSTACKSIZE;
80107be9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107bec:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)t->tkstack + KSTACKSIZE;
80107bf0:	8b 59 04             	mov    0x4(%ecx),%ebx
80107bf3:	e8 48 bd ff ff       	call   80103940 <mycpu>
80107bf8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bfe:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c01:	e8 3a bd ff ff       	call   80103940 <mycpu>
80107c06:	66 89 70 6e          	mov    %si,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107c0a:	b8 28 00 00 00       	mov    $0x28,%eax
80107c0f:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107c12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c15:	8b 42 04             	mov    0x4(%edx),%eax
80107c18:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c1d:	0f 22 d8             	mov    %eax,%cr3
}
80107c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c23:	5b                   	pop    %ebx
80107c24:	5e                   	pop    %esi
80107c25:	5f                   	pop    %edi
80107c26:	5d                   	pop    %ebp
  popcli();
80107c27:	e9 14 d7 ff ff       	jmp    80105340 <popcli>
    panic("switchuvm: no process");
80107c2c:	83 ec 0c             	sub    $0xc,%esp
80107c2f:	68 92 8b 10 80       	push   $0x80108b92
80107c34:	e8 57 87 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107c39:	83 ec 0c             	sub    $0xc,%esp
80107c3c:	68 bd 8b 10 80       	push   $0x80108bbd
80107c41:	e8 4a 87 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107c46:	83 ec 0c             	sub    $0xc,%esp
80107c49:	68 a8 8b 10 80       	push   $0x80108ba8
80107c4e:	e8 3d 87 ff ff       	call   80100390 <panic>
80107c53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c60 <inituvm>:
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	83 ec 1c             	sub    $0x1c,%esp
80107c69:	8b 75 10             	mov    0x10(%ebp),%esi
80107c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107c72:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107c78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107c7b:	77 49                	ja     80107cc6 <inituvm+0x66>
  mem = kalloc();
80107c7d:	e8 de a8 ff ff       	call   80102560 <kalloc>
  memset(mem, 0, PGSIZE);
80107c82:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107c85:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107c87:	68 00 10 00 00       	push   $0x1000
80107c8c:	6a 00                	push   $0x0
80107c8e:	50                   	push   %eax
80107c8f:	e8 5c d8 ff ff       	call   801054f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107c94:	58                   	pop    %eax
80107c95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ca0:	5a                   	pop    %edx
80107ca1:	6a 06                	push   $0x6
80107ca3:	50                   	push   %eax
80107ca4:	31 d2                	xor    %edx,%edx
80107ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ca9:	e8 b2 fc ff ff       	call   80107960 <mappages>
  memmove(mem, init, sz);
80107cae:	89 75 10             	mov    %esi,0x10(%ebp)
80107cb1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107cb4:	83 c4 10             	add    $0x10,%esp
80107cb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cbd:	5b                   	pop    %ebx
80107cbe:	5e                   	pop    %esi
80107cbf:	5f                   	pop    %edi
80107cc0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107cc1:	e9 da d8 ff ff       	jmp    801055a0 <memmove>
    panic("inituvm: more than a page");
80107cc6:	83 ec 0c             	sub    $0xc,%esp
80107cc9:	68 d1 8b 10 80       	push   $0x80108bd1
80107cce:	e8 bd 86 ff ff       	call   80100390 <panic>
80107cd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ce0 <loaduvm>:
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	57                   	push   %edi
80107ce4:	56                   	push   %esi
80107ce5:	53                   	push   %ebx
80107ce6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107ce9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107cf0:	0f 85 91 00 00 00    	jne    80107d87 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107cf6:	8b 75 18             	mov    0x18(%ebp),%esi
80107cf9:	31 db                	xor    %ebx,%ebx
80107cfb:	85 f6                	test   %esi,%esi
80107cfd:	75 1a                	jne    80107d19 <loaduvm+0x39>
80107cff:	eb 6f                	jmp    80107d70 <loaduvm+0x90>
80107d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d0e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107d14:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107d17:	76 57                	jbe    80107d70 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107d19:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107d1f:	31 c9                	xor    %ecx,%ecx
80107d21:	01 da                	add    %ebx,%edx
80107d23:	e8 b8 fb ff ff       	call   801078e0 <walkpgdir>
80107d28:	85 c0                	test   %eax,%eax
80107d2a:	74 4e                	je     80107d7a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107d2c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107d31:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107d36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107d3b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107d41:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d44:	01 d9                	add    %ebx,%ecx
80107d46:	05 00 00 00 80       	add    $0x80000000,%eax
80107d4b:	57                   	push   %edi
80107d4c:	51                   	push   %ecx
80107d4d:	50                   	push   %eax
80107d4e:	ff 75 10             	pushl  0x10(%ebp)
80107d51:	e8 aa 9c ff ff       	call   80101a00 <readi>
80107d56:	83 c4 10             	add    $0x10,%esp
80107d59:	39 f8                	cmp    %edi,%eax
80107d5b:	74 ab                	je     80107d08 <loaduvm+0x28>
}
80107d5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d65:	5b                   	pop    %ebx
80107d66:	5e                   	pop    %esi
80107d67:	5f                   	pop    %edi
80107d68:	5d                   	pop    %ebp
80107d69:	c3                   	ret    
80107d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d73:	31 c0                	xor    %eax,%eax
}
80107d75:	5b                   	pop    %ebx
80107d76:	5e                   	pop    %esi
80107d77:	5f                   	pop    %edi
80107d78:	5d                   	pop    %ebp
80107d79:	c3                   	ret    
      panic("loaduvm: address should exist");
80107d7a:	83 ec 0c             	sub    $0xc,%esp
80107d7d:	68 eb 8b 10 80       	push   $0x80108beb
80107d82:	e8 09 86 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107d87:	83 ec 0c             	sub    $0xc,%esp
80107d8a:	68 8c 8c 10 80       	push   $0x80108c8c
80107d8f:	e8 fc 85 ff ff       	call   80100390 <panic>
80107d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107da0 <allocuvm>:
{
80107da0:	55                   	push   %ebp
80107da1:	89 e5                	mov    %esp,%ebp
80107da3:	57                   	push   %edi
80107da4:	56                   	push   %esi
80107da5:	53                   	push   %ebx
80107da6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107da9:	8b 7d 10             	mov    0x10(%ebp),%edi
80107dac:	85 ff                	test   %edi,%edi
80107dae:	0f 88 8e 00 00 00    	js     80107e42 <allocuvm+0xa2>
  if(newsz < oldsz)
80107db4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107db7:	0f 82 93 00 00 00    	jb     80107e50 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dc0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107dc6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107dcc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107dcf:	0f 86 7e 00 00 00    	jbe    80107e53 <allocuvm+0xb3>
80107dd5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107dd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107ddb:	eb 42                	jmp    80107e1f <allocuvm+0x7f>
80107ddd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107de0:	83 ec 04             	sub    $0x4,%esp
80107de3:	68 00 10 00 00       	push   $0x1000
80107de8:	6a 00                	push   $0x0
80107dea:	50                   	push   %eax
80107deb:	e8 00 d7 ff ff       	call   801054f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107df0:	58                   	pop    %eax
80107df1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107df7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107dfc:	5a                   	pop    %edx
80107dfd:	6a 06                	push   $0x6
80107dff:	50                   	push   %eax
80107e00:	89 da                	mov    %ebx,%edx
80107e02:	89 f8                	mov    %edi,%eax
80107e04:	e8 57 fb ff ff       	call   80107960 <mappages>
80107e09:	83 c4 10             	add    $0x10,%esp
80107e0c:	85 c0                	test   %eax,%eax
80107e0e:	78 50                	js     80107e60 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107e10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e16:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107e19:	0f 86 81 00 00 00    	jbe    80107ea0 <allocuvm+0x100>
    mem = kalloc();
80107e1f:	e8 3c a7 ff ff       	call   80102560 <kalloc>
    if(mem == 0){
80107e24:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107e26:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107e28:	75 b6                	jne    80107de0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107e2a:	83 ec 0c             	sub    $0xc,%esp
80107e2d:	68 09 8c 10 80       	push   $0x80108c09
80107e32:	e8 29 88 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107e37:	83 c4 10             	add    $0x10,%esp
80107e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e3d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e40:	77 6e                	ja     80107eb0 <allocuvm+0x110>
}
80107e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107e45:	31 ff                	xor    %edi,%edi
}
80107e47:	89 f8                	mov    %edi,%eax
80107e49:	5b                   	pop    %ebx
80107e4a:	5e                   	pop    %esi
80107e4b:	5f                   	pop    %edi
80107e4c:	5d                   	pop    %ebp
80107e4d:	c3                   	ret    
80107e4e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107e50:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e56:	89 f8                	mov    %edi,%eax
80107e58:	5b                   	pop    %ebx
80107e59:	5e                   	pop    %esi
80107e5a:	5f                   	pop    %edi
80107e5b:	5d                   	pop    %ebp
80107e5c:	c3                   	ret    
80107e5d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107e60:	83 ec 0c             	sub    $0xc,%esp
80107e63:	68 21 8c 10 80       	push   $0x80108c21
80107e68:	e8 f3 87 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107e6d:	83 c4 10             	add    $0x10,%esp
80107e70:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e73:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e76:	76 0d                	jbe    80107e85 <allocuvm+0xe5>
80107e78:	89 c1                	mov    %eax,%ecx
80107e7a:	8b 55 10             	mov    0x10(%ebp),%edx
80107e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e80:	e8 6b fb ff ff       	call   801079f0 <deallocuvm.part.0>
      kfree(mem);
80107e85:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107e88:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107e8a:	56                   	push   %esi
80107e8b:	e8 20 a5 ff ff       	call   801023b0 <kfree>
      return 0;
80107e90:	83 c4 10             	add    $0x10,%esp
}
80107e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e96:	89 f8                	mov    %edi,%eax
80107e98:	5b                   	pop    %ebx
80107e99:	5e                   	pop    %esi
80107e9a:	5f                   	pop    %edi
80107e9b:	5d                   	pop    %ebp
80107e9c:	c3                   	ret    
80107e9d:	8d 76 00             	lea    0x0(%esi),%esi
80107ea0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ea6:	5b                   	pop    %ebx
80107ea7:	89 f8                	mov    %edi,%eax
80107ea9:	5e                   	pop    %esi
80107eaa:	5f                   	pop    %edi
80107eab:	5d                   	pop    %ebp
80107eac:	c3                   	ret    
80107ead:	8d 76 00             	lea    0x0(%esi),%esi
80107eb0:	89 c1                	mov    %eax,%ecx
80107eb2:	8b 55 10             	mov    0x10(%ebp),%edx
80107eb5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107eb8:	31 ff                	xor    %edi,%edi
80107eba:	e8 31 fb ff ff       	call   801079f0 <deallocuvm.part.0>
80107ebf:	eb 92                	jmp    80107e53 <allocuvm+0xb3>
80107ec1:	eb 0d                	jmp    80107ed0 <deallocuvm>
80107ec3:	90                   	nop
80107ec4:	90                   	nop
80107ec5:	90                   	nop
80107ec6:	90                   	nop
80107ec7:	90                   	nop
80107ec8:	90                   	nop
80107ec9:	90                   	nop
80107eca:	90                   	nop
80107ecb:	90                   	nop
80107ecc:	90                   	nop
80107ecd:	90                   	nop
80107ece:	90                   	nop
80107ecf:	90                   	nop

80107ed0 <deallocuvm>:
{
80107ed0:	55                   	push   %ebp
80107ed1:	89 e5                	mov    %esp,%ebp
80107ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ed6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107edc:	39 d1                	cmp    %edx,%ecx
80107ede:	73 10                	jae    80107ef0 <deallocuvm+0x20>
}
80107ee0:	5d                   	pop    %ebp
80107ee1:	e9 0a fb ff ff       	jmp    801079f0 <deallocuvm.part.0>
80107ee6:	8d 76 00             	lea    0x0(%esi),%esi
80107ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107ef0:	89 d0                	mov    %edx,%eax
80107ef2:	5d                   	pop    %ebp
80107ef3:	c3                   	ret    
80107ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107f00 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	57                   	push   %edi
80107f04:	56                   	push   %esi
80107f05:	53                   	push   %ebx
80107f06:	83 ec 0c             	sub    $0xc,%esp
80107f09:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107f0c:	85 f6                	test   %esi,%esi
80107f0e:	74 59                	je     80107f69 <freevm+0x69>
80107f10:	31 c9                	xor    %ecx,%ecx
80107f12:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107f17:	89 f0                	mov    %esi,%eax
80107f19:	e8 d2 fa ff ff       	call   801079f0 <deallocuvm.part.0>
80107f1e:	89 f3                	mov    %esi,%ebx
80107f20:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107f26:	eb 0f                	jmp    80107f37 <freevm+0x37>
80107f28:	90                   	nop
80107f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f30:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107f33:	39 fb                	cmp    %edi,%ebx
80107f35:	74 23                	je     80107f5a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107f37:	8b 03                	mov    (%ebx),%eax
80107f39:	a8 01                	test   $0x1,%al
80107f3b:	74 f3                	je     80107f30 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107f42:	83 ec 0c             	sub    $0xc,%esp
80107f45:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f48:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107f4d:	50                   	push   %eax
80107f4e:	e8 5d a4 ff ff       	call   801023b0 <kfree>
80107f53:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107f56:	39 fb                	cmp    %edi,%ebx
80107f58:	75 dd                	jne    80107f37 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107f5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f60:	5b                   	pop    %ebx
80107f61:	5e                   	pop    %esi
80107f62:	5f                   	pop    %edi
80107f63:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107f64:	e9 47 a4 ff ff       	jmp    801023b0 <kfree>
    panic("freevm: no pgdir");
80107f69:	83 ec 0c             	sub    $0xc,%esp
80107f6c:	68 3d 8c 10 80       	push   $0x80108c3d
80107f71:	e8 1a 84 ff ff       	call   80100390 <panic>
80107f76:	8d 76 00             	lea    0x0(%esi),%esi
80107f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f80 <setupkvm>:
{
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	56                   	push   %esi
80107f84:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107f85:	e8 d6 a5 ff ff       	call   80102560 <kalloc>
80107f8a:	85 c0                	test   %eax,%eax
80107f8c:	89 c6                	mov    %eax,%esi
80107f8e:	74 42                	je     80107fd2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107f90:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f93:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107f98:	68 00 10 00 00       	push   $0x1000
80107f9d:	6a 00                	push   $0x0
80107f9f:	50                   	push   %eax
80107fa0:	e8 4b d5 ff ff       	call   801054f0 <memset>
80107fa5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107fa8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107fab:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107fae:	83 ec 08             	sub    $0x8,%esp
80107fb1:	8b 13                	mov    (%ebx),%edx
80107fb3:	ff 73 0c             	pushl  0xc(%ebx)
80107fb6:	50                   	push   %eax
80107fb7:	29 c1                	sub    %eax,%ecx
80107fb9:	89 f0                	mov    %esi,%eax
80107fbb:	e8 a0 f9 ff ff       	call   80107960 <mappages>
80107fc0:	83 c4 10             	add    $0x10,%esp
80107fc3:	85 c0                	test   %eax,%eax
80107fc5:	78 19                	js     80107fe0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107fc7:	83 c3 10             	add    $0x10,%ebx
80107fca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107fd0:	75 d6                	jne    80107fa8 <setupkvm+0x28>
}
80107fd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107fd5:	89 f0                	mov    %esi,%eax
80107fd7:	5b                   	pop    %ebx
80107fd8:	5e                   	pop    %esi
80107fd9:	5d                   	pop    %ebp
80107fda:	c3                   	ret    
80107fdb:	90                   	nop
80107fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107fe0:	83 ec 0c             	sub    $0xc,%esp
80107fe3:	56                   	push   %esi
      return 0;
80107fe4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107fe6:	e8 15 ff ff ff       	call   80107f00 <freevm>
      return 0;
80107feb:	83 c4 10             	add    $0x10,%esp
}
80107fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ff1:	89 f0                	mov    %esi,%eax
80107ff3:	5b                   	pop    %ebx
80107ff4:	5e                   	pop    %esi
80107ff5:	5d                   	pop    %ebp
80107ff6:	c3                   	ret    
80107ff7:	89 f6                	mov    %esi,%esi
80107ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108000 <kvmalloc>:
{
80108000:	55                   	push   %ebp
80108001:	89 e5                	mov    %esp,%ebp
80108003:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108006:	e8 75 ff ff ff       	call   80107f80 <setupkvm>
8010800b:	a3 64 e6 15 80       	mov    %eax,0x8015e664
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108010:	05 00 00 00 80       	add    $0x80000000,%eax
80108015:	0f 22 d8             	mov    %eax,%cr3
}
80108018:	c9                   	leave  
80108019:	c3                   	ret    
8010801a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108020 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108020:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108021:	31 c9                	xor    %ecx,%ecx
{
80108023:	89 e5                	mov    %esp,%ebp
80108025:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108028:	8b 55 0c             	mov    0xc(%ebp),%edx
8010802b:	8b 45 08             	mov    0x8(%ebp),%eax
8010802e:	e8 ad f8 ff ff       	call   801078e0 <walkpgdir>
  if(pte == 0)
80108033:	85 c0                	test   %eax,%eax
80108035:	74 05                	je     8010803c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108037:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010803a:	c9                   	leave  
8010803b:	c3                   	ret    
    panic("clearpteu");
8010803c:	83 ec 0c             	sub    $0xc,%esp
8010803f:	68 4e 8c 10 80       	push   $0x80108c4e
80108044:	e8 47 83 ff ff       	call   80100390 <panic>
80108049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108050 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108050:	55                   	push   %ebp
80108051:	89 e5                	mov    %esp,%ebp
80108053:	57                   	push   %edi
80108054:	56                   	push   %esi
80108055:	53                   	push   %ebx
80108056:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108059:	e8 22 ff ff ff       	call   80107f80 <setupkvm>
8010805e:	85 c0                	test   %eax,%eax
80108060:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108063:	0f 84 9f 00 00 00    	je     80108108 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108069:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010806c:	85 c9                	test   %ecx,%ecx
8010806e:	0f 84 94 00 00 00    	je     80108108 <copyuvm+0xb8>
80108074:	31 ff                	xor    %edi,%edi
80108076:	eb 4a                	jmp    801080c2 <copyuvm+0x72>
80108078:	90                   	nop
80108079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108080:	83 ec 04             	sub    $0x4,%esp
80108083:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80108089:	68 00 10 00 00       	push   $0x1000
8010808e:	53                   	push   %ebx
8010808f:	50                   	push   %eax
80108090:	e8 0b d5 ff ff       	call   801055a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108095:	58                   	pop    %eax
80108096:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010809c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801080a1:	5a                   	pop    %edx
801080a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801080a5:	50                   	push   %eax
801080a6:	89 fa                	mov    %edi,%edx
801080a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080ab:	e8 b0 f8 ff ff       	call   80107960 <mappages>
801080b0:	83 c4 10             	add    $0x10,%esp
801080b3:	85 c0                	test   %eax,%eax
801080b5:	78 61                	js     80108118 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801080b7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801080bd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801080c0:	76 46                	jbe    80108108 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080c2:	8b 45 08             	mov    0x8(%ebp),%eax
801080c5:	31 c9                	xor    %ecx,%ecx
801080c7:	89 fa                	mov    %edi,%edx
801080c9:	e8 12 f8 ff ff       	call   801078e0 <walkpgdir>
801080ce:	85 c0                	test   %eax,%eax
801080d0:	74 61                	je     80108133 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801080d2:	8b 00                	mov    (%eax),%eax
801080d4:	a8 01                	test   $0x1,%al
801080d6:	74 4e                	je     80108126 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801080d8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801080da:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801080df:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801080e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801080e8:	e8 73 a4 ff ff       	call   80102560 <kalloc>
801080ed:	85 c0                	test   %eax,%eax
801080ef:	89 c6                	mov    %eax,%esi
801080f1:	75 8d                	jne    80108080 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801080f3:	83 ec 0c             	sub    $0xc,%esp
801080f6:	ff 75 e0             	pushl  -0x20(%ebp)
801080f9:	e8 02 fe ff ff       	call   80107f00 <freevm>
  return 0;
801080fe:	83 c4 10             	add    $0x10,%esp
80108101:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80108108:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010810b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010810e:	5b                   	pop    %ebx
8010810f:	5e                   	pop    %esi
80108110:	5f                   	pop    %edi
80108111:	5d                   	pop    %ebp
80108112:	c3                   	ret    
80108113:	90                   	nop
80108114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108118:	83 ec 0c             	sub    $0xc,%esp
8010811b:	56                   	push   %esi
8010811c:	e8 8f a2 ff ff       	call   801023b0 <kfree>
      goto bad;
80108121:	83 c4 10             	add    $0x10,%esp
80108124:	eb cd                	jmp    801080f3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108126:	83 ec 0c             	sub    $0xc,%esp
80108129:	68 72 8c 10 80       	push   $0x80108c72
8010812e:	e8 5d 82 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108133:	83 ec 0c             	sub    $0xc,%esp
80108136:	68 58 8c 10 80       	push   $0x80108c58
8010813b:	e8 50 82 ff ff       	call   80100390 <panic>

80108140 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108140:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108141:	31 c9                	xor    %ecx,%ecx
{
80108143:	89 e5                	mov    %esp,%ebp
80108145:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108148:	8b 55 0c             	mov    0xc(%ebp),%edx
8010814b:	8b 45 08             	mov    0x8(%ebp),%eax
8010814e:	e8 8d f7 ff ff       	call   801078e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108153:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108155:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108156:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108158:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010815d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108160:	05 00 00 00 80       	add    $0x80000000,%eax
80108165:	83 fa 05             	cmp    $0x5,%edx
80108168:	ba 00 00 00 00       	mov    $0x0,%edx
8010816d:	0f 45 c2             	cmovne %edx,%eax
}
80108170:	c3                   	ret    
80108171:	eb 0d                	jmp    80108180 <copyout>
80108173:	90                   	nop
80108174:	90                   	nop
80108175:	90                   	nop
80108176:	90                   	nop
80108177:	90                   	nop
80108178:	90                   	nop
80108179:	90                   	nop
8010817a:	90                   	nop
8010817b:	90                   	nop
8010817c:	90                   	nop
8010817d:	90                   	nop
8010817e:	90                   	nop
8010817f:	90                   	nop

80108180 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108180:	55                   	push   %ebp
80108181:	89 e5                	mov    %esp,%ebp
80108183:	57                   	push   %edi
80108184:	56                   	push   %esi
80108185:	53                   	push   %ebx
80108186:	83 ec 1c             	sub    $0x1c,%esp
80108189:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010818c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010818f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108192:	85 db                	test   %ebx,%ebx
80108194:	75 40                	jne    801081d6 <copyout+0x56>
80108196:	eb 70                	jmp    80108208 <copyout+0x88>
80108198:	90                   	nop
80108199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801081a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801081a3:	89 f1                	mov    %esi,%ecx
801081a5:	29 d1                	sub    %edx,%ecx
801081a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801081ad:	39 d9                	cmp    %ebx,%ecx
801081af:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801081b2:	29 f2                	sub    %esi,%edx
801081b4:	83 ec 04             	sub    $0x4,%esp
801081b7:	01 d0                	add    %edx,%eax
801081b9:	51                   	push   %ecx
801081ba:	57                   	push   %edi
801081bb:	50                   	push   %eax
801081bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801081bf:	e8 dc d3 ff ff       	call   801055a0 <memmove>
    len -= n;
    buf += n;
801081c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801081c7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801081ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801081d0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801081d2:	29 cb                	sub    %ecx,%ebx
801081d4:	74 32                	je     80108208 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801081d6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801081d8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801081db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801081de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801081e4:	56                   	push   %esi
801081e5:	ff 75 08             	pushl  0x8(%ebp)
801081e8:	e8 53 ff ff ff       	call   80108140 <uva2ka>
    if(pa0 == 0)
801081ed:	83 c4 10             	add    $0x10,%esp
801081f0:	85 c0                	test   %eax,%eax
801081f2:	75 ac                	jne    801081a0 <copyout+0x20>
  }
  return 0;
}
801081f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801081f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801081fc:	5b                   	pop    %ebx
801081fd:	5e                   	pop    %esi
801081fe:	5f                   	pop    %edi
801081ff:	5d                   	pop    %ebp
80108200:	c3                   	ret    
80108201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010820b:	31 c0                	xor    %eax,%eax
}
8010820d:	5b                   	pop    %ebx
8010820e:	5e                   	pop    %esi
8010820f:	5f                   	pop    %edi
80108210:	5d                   	pop    %ebp
80108211:	c3                   	ret    
