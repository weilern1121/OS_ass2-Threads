
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
8010002d:	b8 d0 2e 10 80       	mov    $0x80102ed0,%eax
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
8010004c:	68 00 7d 10 80       	push   $0x80107d00
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 15 4f 00 00       	call   80104f70 <initlock>
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
80100092:	68 07 7d 10 80       	push   $0x80107d07
80100097:	50                   	push   %eax
80100098:	e8 a3 4d 00 00       	call   80104e40 <initsleeplock>
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
801000e4:	e8 c7 4f 00 00       	call   801050b0 <acquire>
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
80100162:	e8 19 50 00 00       	call   80105180 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 4d 00 00       	call   80104e80 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 1f 00 00       	call   80102150 <iderw>
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
80100193:	68 0e 7d 10 80       	push   $0x80107d0e
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
801001ae:	e8 6d 4d 00 00       	call   80104f20 <holdingsleep>
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
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 7d 10 80       	push   $0x80107d1f
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
801001ef:	e8 2c 4d 00 00       	call   80104f20 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 4c 00 00       	call   80104ee0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 a0 4e 00 00       	call   801050b0 <acquire>
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
8010025c:	e9 1f 4f 00 00       	jmp    80105180 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 7d 10 80       	push   $0x80107d26
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
80100280:	e8 0b 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 1f 4e 00 00       	call   801050b0 <acquire>
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
801002c5:	e8 d6 3c 00 00       	call   80103fa0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 44 10 11 80    	cmp    0x80111044,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 30 36 00 00       	call   80103910 <myproc>
801002e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 8c 4e 00 00       	call   80105180 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 13 00 00       	call   801016b0 <ilock>
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
8010034d:	e8 2e 4e 00 00       	call   80105180 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 13 00 00       	call   801016b0 <ilock>
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
801003a9:	e8 b2 23 00 00       	call   80102760 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 7d 10 80       	push   $0x80107d2d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 a7 87 10 80 	movl   $0x801087a7,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 b3 4b 00 00       	call   80104f90 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 7d 10 80       	push   $0x80107d41
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
8010043a:	e8 c1 64 00 00       	call   80106900 <uartputc>
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
801004ec:	e8 0f 64 00 00       	call   80106900 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 03 64 00 00       	call   80106900 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 f7 63 00 00       	call   80106900 <uartputc>
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
80100524:	e8 57 4d 00 00       	call   80105280 <memmove>
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
80100541:	e8 8a 4c 00 00       	call   801051d0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 7d 10 80       	push   $0x80107d45
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
801005b1:	0f b6 92 70 7d 10 80 	movzbl -0x7fef8290(%edx),%edx
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
8010060f:	e8 7c 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 90 4a 00 00       	call   801050b0 <acquire>
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
80100647:	e8 34 4b 00 00       	call   80105180 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 10 00 00       	call   801016b0 <ilock>

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
8010071f:	e8 5c 4a 00 00       	call   80105180 <release>
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
801007d0:	ba 58 7d 10 80       	mov    $0x80107d58,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 bb 48 00 00       	call   801050b0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 7d 10 80       	push   $0x80107d5f
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
80100823:	e8 88 48 00 00       	call   801050b0 <acquire>
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
80100888:	e8 f3 48 00 00       	call   80105180 <release>
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
80100916:	e8 85 3b 00 00       	call   801044a0 <wakeup>
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
80100997:	e9 64 3c 00 00       	jmp    80104600 <procdump>
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
801009c6:	68 68 7d 10 80       	push   $0x80107d68
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 9b 45 00 00       	call   80104f70 <initlock>

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
801009f9:	e8 02 19 00 00       	call   80102300 <ioapicenable>
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
80100a1c:	e8 ef 2e 00 00       	call   80103910 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
    struct  thread *curthread = mythread();
80100a27:	e8 14 2f 00 00       	call   80103940 <mythread>
80100a2c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
    //struct  thread *t;
    begin_op();
80100a32:	e8 99 21 00 00       	call   80102bd0 <begin_op>

    if((ip = namei(path)) == 0){
80100a37:	83 ec 0c             	sub    $0xc,%esp
80100a3a:	ff 75 08             	pushl  0x8(%ebp)
80100a3d:	e8 ce 14 00 00       	call   80101f10 <namei>
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
80100a53:	e8 58 0c 00 00       	call   801016b0 <ilock>
    pgdir = 0;

    // Check ELF header
    if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a58:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a5e:	6a 34                	push   $0x34
80100a60:	6a 00                	push   $0x0
80100a62:	50                   	push   %eax
80100a63:	53                   	push   %ebx
80100a64:	e8 27 0f 00 00       	call   80101990 <readi>
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
80100a75:	e8 c6 0e 00 00       	call   80101940 <iunlockput>
        end_op();
80100a7a:	e8 c1 21 00 00       	call   80102c40 <end_op>
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
80100a9c:	e8 bf 6f 00 00       	call   80107a60 <setupkvm>
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
80100ac1:	0f 84 a0 02 00 00    	je     80100d67 <exec+0x357>
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
80100afe:	e8 7d 6d 00 00       	call   80107880 <allocuvm>
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
80100b30:	e8 8b 6c 00 00       	call   801077c0 <loaduvm>
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
80100b60:	e8 2b 0e 00 00       	call   80101990 <readi>
80100b65:	83 c4 10             	add    $0x10,%esp
80100b68:	83 f8 20             	cmp    $0x20,%eax
80100b6b:	0f 84 5f ff ff ff    	je     80100ad0 <exec+0xc0>
        freevm(pgdir);
80100b71:	83 ec 0c             	sub    $0xc,%esp
80100b74:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b7a:	e8 61 6e 00 00       	call   801079e0 <freevm>
80100b7f:	83 c4 10             	add    $0x10,%esp
80100b82:	e9 ea fe ff ff       	jmp    80100a71 <exec+0x61>
80100b87:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b8d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b93:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
    iunlockput(ip);
80100b99:	83 ec 0c             	sub    $0xc,%esp
80100b9c:	53                   	push   %ebx
80100b9d:	e8 9e 0d 00 00       	call   80101940 <iunlockput>
    end_op();
80100ba2:	e8 99 20 00 00       	call   80102c40 <end_op>
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ba7:	83 c4 0c             	add    $0xc,%esp
80100baa:	56                   	push   %esi
80100bab:	57                   	push   %edi
80100bac:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bb2:	e8 c9 6c 00 00       	call   80107880 <allocuvm>
80100bb7:	83 c4 10             	add    $0x10,%esp
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	89 c6                	mov    %eax,%esi
80100bbe:	75 3a                	jne    80100bfa <exec+0x1ea>
        freevm(pgdir);
80100bc0:	83 ec 0c             	sub    $0xc,%esp
80100bc3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bc9:	e8 12 6e 00 00       	call   801079e0 <freevm>
80100bce:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd6:	e9 ac fe ff ff       	jmp    80100a87 <exec+0x77>
        end_op();
80100bdb:	e8 60 20 00 00       	call   80102c40 <end_op>
        cprintf("exec: fail\n");
80100be0:	83 ec 0c             	sub    $0xc,%esp
80100be3:	68 81 7d 10 80       	push   $0x80107d81
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
80100c0e:	e8 ed 6e 00 00       	call   80107b00 <clearpteu>
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
80100c41:	e8 aa 47 00 00       	call   801053f0 <strlen>
80100c46:	f7 d0                	not    %eax
80100c48:	01 c3                	add    %eax,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4d:	59                   	pop    %ecx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c4e:	83 e3 fc             	and    $0xfffffffc,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c51:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c54:	e8 97 47 00 00       	call   801053f0 <strlen>
80100c59:	83 c0 01             	add    $0x1,%eax
80100c5c:	50                   	push   %eax
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c60:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c63:	53                   	push   %ebx
80100c64:	56                   	push   %esi
80100c65:	e8 f6 6f 00 00       	call   80107c60 <copyout>
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
80100ccf:	e8 8c 6f 00 00       	call   80107c60 <copyout>
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
80100d0c:	8d 47 64             	lea    0x64(%edi),%eax
80100d0f:	50                   	push   %eax
80100d10:	e8 9b 46 00 00       	call   801053b0 <safestrcpy>
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
80100d3a:	89 f2                	mov    %esi,%edx
80100d3c:	89 58 44             	mov    %ebx,0x44(%eax)
    cleanProcOneThread(curthread,curproc);
80100d3f:	5b                   	pop    %ebx
80100d40:	5e                   	pop    %esi
80100d41:	51                   	push   %ecx
80100d42:	52                   	push   %edx
80100d43:	89 ce                	mov    %ecx,%esi
80100d45:	89 d3                	mov    %edx,%ebx
80100d47:	e8 64 33 00 00       	call   801040b0 <cleanProcOneThread>
    switchuvm(curproc,curthread);
80100d4c:	58                   	pop    %eax
80100d4d:	5a                   	pop    %edx
80100d4e:	53                   	push   %ebx
80100d4f:	56                   	push   %esi
80100d50:	e8 cb 68 00 00       	call   80107620 <switchuvm>
    freevm(oldpgdir);
80100d55:	89 3c 24             	mov    %edi,(%esp)
80100d58:	e8 83 6c 00 00       	call   801079e0 <freevm>
    return 0;
80100d5d:	83 c4 10             	add    $0x10,%esp
80100d60:	31 c0                	xor    %eax,%eax
80100d62:	e9 20 fd ff ff       	jmp    80100a87 <exec+0x77>
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d67:	be 00 20 00 00       	mov    $0x2000,%esi
80100d6c:	e9 28 fe ff ff       	jmp    80100b99 <exec+0x189>
80100d71:	66 90                	xchg   %ax,%ax
80100d73:	66 90                	xchg   %ax,%ax
80100d75:	66 90                	xchg   %ax,%ax
80100d77:	66 90                	xchg   %ax,%ax
80100d79:	66 90                	xchg   %ax,%ax
80100d7b:	66 90                	xchg   %ax,%ax
80100d7d:	66 90                	xchg   %ax,%ax
80100d7f:	90                   	nop

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	68 8d 7d 10 80       	push   $0x80107d8d
80100d8b:	68 60 10 11 80       	push   $0x80111060
80100d90:	e8 db 41 00 00       	call   80104f70 <initlock>
}
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	c9                   	leave  
80100d99:	c3                   	ret    
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da4:	bb 98 10 11 80       	mov    $0x80111098,%ebx
{
80100da9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dac:	68 60 10 11 80       	push   $0x80111060
80100db1:	e8 fa 42 00 00       	call   801050b0 <acquire>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 10                	jmp    80100dcb <filealloc+0x2b>
80100dbb:	90                   	nop
80100dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb f8 19 11 80    	cmp    $0x801119f8,%ebx
80100dc9:	73 25                	jae    80100df0 <filealloc+0x50>
    if(f->ref == 0){
80100dcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	75 ee                	jne    80100dc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dd2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100dd5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ddc:	68 60 10 11 80       	push   $0x80111060
80100de1:	e8 9a 43 00 00       	call   80105180 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de6:	89 d8                	mov    %ebx,%eax
      return f;
80100de8:	83 c4 10             	add    $0x10,%esp
}
80100deb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dee:	c9                   	leave  
80100def:	c3                   	ret    
  release(&ftable.lock);
80100df0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100df3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100df5:	68 60 10 11 80       	push   $0x80111060
80100dfa:	e8 81 43 00 00       	call   80105180 <release>
}
80100dff:	89 d8                	mov    %ebx,%eax
  return 0;
80100e01:	83 c4 10             	add    $0x10,%esp
}
80100e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e07:	c9                   	leave  
80100e08:	c3                   	ret    
80100e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
80100e14:	83 ec 10             	sub    $0x10,%esp
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e1a:	68 60 10 11 80       	push   $0x80111060
80100e1f:	e8 8c 42 00 00       	call   801050b0 <acquire>
  if(f->ref < 1)
80100e24:	8b 43 04             	mov    0x4(%ebx),%eax
80100e27:	83 c4 10             	add    $0x10,%esp
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	7e 1a                	jle    80100e48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e37:	68 60 10 11 80       	push   $0x80111060
80100e3c:	e8 3f 43 00 00       	call   80105180 <release>
  return f;
}
80100e41:	89 d8                	mov    %ebx,%eax
80100e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e46:	c9                   	leave  
80100e47:	c3                   	ret    
    panic("filedup");
80100e48:	83 ec 0c             	sub    $0xc,%esp
80100e4b:	68 94 7d 10 80       	push   $0x80107d94
80100e50:	e8 3b f5 ff ff       	call   80100390 <panic>
80100e55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	83 ec 28             	sub    $0x28,%esp
80100e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e6c:	68 60 10 11 80       	push   $0x80111060
80100e71:	e8 3a 42 00 00       	call   801050b0 <acquire>
  if(f->ref < 1)
80100e76:	8b 43 04             	mov    0x4(%ebx),%eax
80100e79:	83 c4 10             	add    $0x10,%esp
80100e7c:	85 c0                	test   %eax,%eax
80100e7e:	0f 8e 9b 00 00 00    	jle    80100f1f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e84:	83 e8 01             	sub    $0x1,%eax
80100e87:	85 c0                	test   %eax,%eax
80100e89:	89 43 04             	mov    %eax,0x4(%ebx)
80100e8c:	74 1a                	je     80100ea8 <fileclose+0x48>
    release(&ftable.lock);
80100e8e:	c7 45 08 60 10 11 80 	movl   $0x80111060,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e98:	5b                   	pop    %ebx
80100e99:	5e                   	pop    %esi
80100e9a:	5f                   	pop    %edi
80100e9b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e9c:	e9 df 42 00 00       	jmp    80105180 <release>
80100ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ea8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100eac:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100eae:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100eb1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100eb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eba:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ebd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ec0:	68 60 10 11 80       	push   $0x80111060
  ff = *f;
80100ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ec8:	e8 b3 42 00 00       	call   80105180 <release>
  if(ff.type == FD_PIPE)
80100ecd:	83 c4 10             	add    $0x10,%esp
80100ed0:	83 ff 01             	cmp    $0x1,%edi
80100ed3:	74 13                	je     80100ee8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ed5:	83 ff 02             	cmp    $0x2,%edi
80100ed8:	74 26                	je     80100f00 <fileclose+0xa0>
}
80100eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100edd:	5b                   	pop    %ebx
80100ede:	5e                   	pop    %esi
80100edf:	5f                   	pop    %edi
80100ee0:	5d                   	pop    %ebp
80100ee1:	c3                   	ret    
80100ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ee8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eec:	83 ec 08             	sub    $0x8,%esp
80100eef:	53                   	push   %ebx
80100ef0:	56                   	push   %esi
80100ef1:	e8 8a 24 00 00       	call   80103380 <pipeclose>
80100ef6:	83 c4 10             	add    $0x10,%esp
80100ef9:	eb df                	jmp    80100eda <fileclose+0x7a>
80100efb:	90                   	nop
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f00:	e8 cb 1c 00 00       	call   80102bd0 <begin_op>
    iput(ff.ip);
80100f05:	83 ec 0c             	sub    $0xc,%esp
80100f08:	ff 75 e0             	pushl  -0x20(%ebp)
80100f0b:	e8 d0 08 00 00       	call   801017e0 <iput>
    end_op();
80100f10:	83 c4 10             	add    $0x10,%esp
}
80100f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f16:	5b                   	pop    %ebx
80100f17:	5e                   	pop    %esi
80100f18:	5f                   	pop    %edi
80100f19:	5d                   	pop    %ebp
    end_op();
80100f1a:	e9 21 1d 00 00       	jmp    80102c40 <end_op>
    panic("fileclose");
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	68 9c 7d 10 80       	push   $0x80107d9c
80100f27:	e8 64 f4 ff ff       	call   80100390 <panic>
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f3a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f3d:	75 31                	jne    80100f70 <filestat+0x40>
    ilock(f->ip);
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	ff 73 10             	pushl  0x10(%ebx)
80100f45:	e8 66 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f4a:	58                   	pop    %eax
80100f4b:	5a                   	pop    %edx
80100f4c:	ff 75 0c             	pushl  0xc(%ebp)
80100f4f:	ff 73 10             	pushl  0x10(%ebx)
80100f52:	e8 09 0a 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f57:	59                   	pop    %ecx
80100f58:	ff 73 10             	pushl  0x10(%ebx)
80100f5b:	e8 30 08 00 00       	call   80101790 <iunlock>
    return 0;
80100f60:	83 c4 10             	add    $0x10,%esp
80100f63:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f75:	eb ee                	jmp    80100f65 <filestat+0x35>
80100f77:	89 f6                	mov    %esi,%esi
80100f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f80 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 0c             	sub    $0xc,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f92:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f96:	74 60                	je     80100ff8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f98:	8b 03                	mov    (%ebx),%eax
80100f9a:	83 f8 01             	cmp    $0x1,%eax
80100f9d:	74 41                	je     80100fe0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f9f:	83 f8 02             	cmp    $0x2,%eax
80100fa2:	75 5b                	jne    80100fff <fileread+0x7f>
    ilock(f->ip);
80100fa4:	83 ec 0c             	sub    $0xc,%esp
80100fa7:	ff 73 10             	pushl  0x10(%ebx)
80100faa:	e8 01 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100faf:	57                   	push   %edi
80100fb0:	ff 73 14             	pushl  0x14(%ebx)
80100fb3:	56                   	push   %esi
80100fb4:	ff 73 10             	pushl  0x10(%ebx)
80100fb7:	e8 d4 09 00 00       	call   80101990 <readi>
80100fbc:	83 c4 20             	add    $0x20,%esp
80100fbf:	85 c0                	test   %eax,%eax
80100fc1:	89 c6                	mov    %eax,%esi
80100fc3:	7e 03                	jle    80100fc8 <fileread+0x48>
      f->off += r;
80100fc5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	ff 73 10             	pushl  0x10(%ebx)
80100fce:	e8 bd 07 00 00       	call   80101790 <iunlock>
    return r;
80100fd3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd9:	89 f0                	mov    %esi,%eax
80100fdb:	5b                   	pop    %ebx
80100fdc:	5e                   	pop    %esi
80100fdd:	5f                   	pop    %edi
80100fde:	5d                   	pop    %ebp
80100fdf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fe0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fe3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	5b                   	pop    %ebx
80100fea:	5e                   	pop    %esi
80100feb:	5f                   	pop    %edi
80100fec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fed:	e9 3e 25 00 00       	jmp    80103530 <piperead>
80100ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100ff8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100ffd:	eb d7                	jmp    80100fd6 <fileread+0x56>
  panic("fileread");
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	68 a6 7d 10 80       	push   $0x80107da6
80101007:	e8 84 f3 ff ff       	call   80100390 <panic>
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 1c             	sub    $0x1c,%esp
80101019:	8b 75 08             	mov    0x8(%ebp),%esi
8010101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010101f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101023:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101026:	8b 45 10             	mov    0x10(%ebp),%eax
80101029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010102c:	0f 84 aa 00 00 00    	je     801010dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101032:	8b 06                	mov    (%esi),%eax
80101034:	83 f8 01             	cmp    $0x1,%eax
80101037:	0f 84 c3 00 00 00    	je     80101100 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103d:	83 f8 02             	cmp    $0x2,%eax
80101040:	0f 85 d9 00 00 00    	jne    8010111f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101049:	31 ff                	xor    %edi,%edi
    while(i < n){
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 34                	jg     80101083 <filewrite+0x73>
8010104f:	e9 9c 00 00 00       	jmp    801010f0 <filewrite+0xe0>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101058:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101061:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101064:	e8 27 07 00 00       	call   80101790 <iunlock>
      end_op();
80101069:	e8 d2 1b 00 00       	call   80102c40 <end_op>
8010106e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101071:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101074:	39 c3                	cmp    %eax,%ebx
80101076:	0f 85 96 00 00 00    	jne    80101112 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010107c:	01 df                	add    %ebx,%edi
    while(i < n){
8010107e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101081:	7e 6d                	jle    801010f0 <filewrite+0xe0>
      int n1 = n - i;
80101083:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101086:	b8 00 06 00 00       	mov    $0x600,%eax
8010108b:	29 fb                	sub    %edi,%ebx
8010108d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101093:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101096:	e8 35 1b 00 00       	call   80102bd0 <begin_op>
      ilock(f->ip);
8010109b:	83 ec 0c             	sub    $0xc,%esp
8010109e:	ff 76 10             	pushl  0x10(%esi)
801010a1:	e8 0a 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010a9:	53                   	push   %ebx
801010aa:	ff 76 14             	pushl  0x14(%esi)
801010ad:	01 f8                	add    %edi,%eax
801010af:	50                   	push   %eax
801010b0:	ff 76 10             	pushl  0x10(%esi)
801010b3:	e8 d8 09 00 00       	call   80101a90 <writei>
801010b8:	83 c4 20             	add    $0x20,%esp
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 99                	jg     80101058 <filewrite+0x48>
      iunlock(f->ip);
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	ff 76 10             	pushl  0x10(%esi)
801010c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010c8:	e8 c3 06 00 00       	call   80101790 <iunlock>
      end_op();
801010cd:	e8 6e 1b 00 00       	call   80102c40 <end_op>
      if(r < 0)
801010d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d5:	83 c4 10             	add    $0x10,%esp
801010d8:	85 c0                	test   %eax,%eax
801010da:	74 98                	je     80101074 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010e4:	89 f8                	mov    %edi,%eax
801010e6:	5b                   	pop    %ebx
801010e7:	5e                   	pop    %esi
801010e8:	5f                   	pop    %edi
801010e9:	5d                   	pop    %ebp
801010ea:	c3                   	ret    
801010eb:	90                   	nop
801010ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010f0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010f3:	75 e7                	jne    801010dc <filewrite+0xcc>
}
801010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f8:	89 f8                	mov    %edi,%eax
801010fa:	5b                   	pop    %ebx
801010fb:	5e                   	pop    %esi
801010fc:	5f                   	pop    %edi
801010fd:	5d                   	pop    %ebp
801010fe:	c3                   	ret    
801010ff:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101100:	8b 46 0c             	mov    0xc(%esi),%eax
80101103:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	5b                   	pop    %ebx
8010110a:	5e                   	pop    %esi
8010110b:	5f                   	pop    %edi
8010110c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010110d:	e9 0e 23 00 00       	jmp    80103420 <pipewrite>
        panic("short filewrite");
80101112:	83 ec 0c             	sub    $0xc,%esp
80101115:	68 af 7d 10 80       	push   $0x80107daf
8010111a:	e8 71 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 b5 7d 10 80       	push   $0x80107db5
80101127:	e8 64 f2 ff ff       	call   80100390 <panic>
8010112c:	66 90                	xchg   %ax,%ax
8010112e:	66 90                	xchg   %ax,%ax

80101130 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101139:	8b 0d 60 1a 11 80    	mov    0x80111a60,%ecx
{
8010113f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101142:	85 c9                	test   %ecx,%ecx
80101144:	0f 84 87 00 00 00    	je     801011d1 <balloc+0xa1>
8010114a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101151:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101154:	83 ec 08             	sub    $0x8,%esp
80101157:	89 f0                	mov    %esi,%eax
80101159:	c1 f8 0c             	sar    $0xc,%eax
8010115c:	03 05 78 1a 11 80    	add    0x80111a78,%eax
80101162:	50                   	push   %eax
80101163:	ff 75 d8             	pushl  -0x28(%ebp)
80101166:	e8 65 ef ff ff       	call   801000d0 <bread>
8010116b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116e:	a1 60 1a 11 80       	mov    0x80111a60,%eax
80101173:	83 c4 10             	add    $0x10,%esp
80101176:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101179:	31 c0                	xor    %eax,%eax
8010117b:	eb 2f                	jmp    801011ac <balloc+0x7c>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101180:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101182:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101185:	bb 01 00 00 00       	mov    $0x1,%ebx
8010118a:	83 e1 07             	and    $0x7,%ecx
8010118d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010118f:	89 c1                	mov    %eax,%ecx
80101191:	c1 f9 03             	sar    $0x3,%ecx
80101194:	0f b6 7c 0a 60       	movzbl 0x60(%edx,%ecx,1),%edi
80101199:	85 df                	test   %ebx,%edi
8010119b:	89 fa                	mov    %edi,%edx
8010119d:	74 41                	je     801011e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010119f:	83 c0 01             	add    $0x1,%eax
801011a2:	83 c6 01             	add    $0x1,%esi
801011a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011aa:	74 05                	je     801011b1 <balloc+0x81>
801011ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011af:	77 cf                	ja     80101180 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011b7:	e8 24 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011c9:	39 05 60 1a 11 80    	cmp    %eax,0x80111a60
801011cf:	77 80                	ja     80101151 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011d1:	83 ec 0c             	sub    $0xc,%esp
801011d4:	68 bf 7d 10 80       	push   $0x80107dbf
801011d9:	e8 b2 f1 ff ff       	call   80100390 <panic>
801011de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011e6:	09 da                	or     %ebx,%edx
801011e8:	88 54 0f 60          	mov    %dl,0x60(%edi,%ecx,1)
        log_write(bp);
801011ec:	57                   	push   %edi
801011ed:	e8 ae 1b 00 00       	call   80102da0 <log_write>
        brelse(bp);
801011f2:	89 3c 24             	mov    %edi,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011fa:	58                   	pop    %eax
801011fb:	5a                   	pop    %edx
801011fc:	56                   	push   %esi
801011fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101200:	e8 cb ee ff ff       	call   801000d0 <bread>
80101205:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101207:	8d 40 60             	lea    0x60(%eax),%eax
8010120a:	83 c4 0c             	add    $0xc,%esp
8010120d:	68 00 02 00 00       	push   $0x200
80101212:	6a 00                	push   $0x0
80101214:	50                   	push   %eax
80101215:	e8 b6 3f 00 00       	call   801051d0 <memset>
  log_write(bp);
8010121a:	89 1c 24             	mov    %ebx,(%esp)
8010121d:	e8 7e 1b 00 00       	call   80102da0 <log_write>
  brelse(bp);
80101222:	89 1c 24             	mov    %ebx,(%esp)
80101225:	e8 b6 ef ff ff       	call   801001e0 <brelse>
}
8010122a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122d:	89 f0                	mov    %esi,%eax
8010122f:	5b                   	pop    %ebx
80101230:	5e                   	pop    %esi
80101231:	5f                   	pop    %edi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
80101234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010123a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101240 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101248:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124a:	bb b8 1a 11 80       	mov    $0x80111ab8,%ebx
{
8010124f:	83 ec 28             	sub    $0x28,%esp
80101252:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101255:	68 80 1a 11 80       	push   $0x80111a80
8010125a:	e8 51 3e 00 00       	call   801050b0 <acquire>
8010125f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101265:	eb 17                	jmp    8010127e <iget+0x3e>
80101267:	89 f6                	mov    %esi,%esi
80101269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101270:	81 c3 94 00 00 00    	add    $0x94,%ebx
80101276:	81 fb a0 37 11 80    	cmp    $0x801137a0,%ebx
8010127c:	73 22                	jae    801012a0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010127e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101281:	85 c9                	test   %ecx,%ecx
80101283:	7e 04                	jle    80101289 <iget+0x49>
80101285:	39 3b                	cmp    %edi,(%ebx)
80101287:	74 4f                	je     801012d8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101289:	85 f6                	test   %esi,%esi
8010128b:	75 e3                	jne    80101270 <iget+0x30>
8010128d:	85 c9                	test   %ecx,%ecx
8010128f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101292:	81 c3 94 00 00 00    	add    $0x94,%ebx
80101298:	81 fb a0 37 11 80    	cmp    $0x801137a0,%ebx
8010129e:	72 de                	jb     8010127e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 5b                	je     801012ff <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
  release(&icache.lock);
801012ba:	68 80 1a 11 80       	push   $0x80111a80
801012bf:	e8 bc 3e 00 00       	call   80105180 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
801012d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012d8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012db:	75 ac                	jne    80101289 <iget+0x49>
      release(&icache.lock);
801012dd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012e0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012e3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012e5:	68 80 1a 11 80       	push   $0x80111a80
      ip->ref++;
801012ea:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012ed:	e8 8e 3e 00 00       	call   80105180 <release>
      return ip;
801012f2:	83 c4 10             	add    $0x10,%esp
}
801012f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f8:	89 f0                	mov    %esi,%eax
801012fa:	5b                   	pop    %ebx
801012fb:	5e                   	pop    %esi
801012fc:	5f                   	pop    %edi
801012fd:	5d                   	pop    %ebp
801012fe:	c3                   	ret    
    panic("iget: no inodes");
801012ff:	83 ec 0c             	sub    $0xc,%esp
80101302:	68 d5 7d 10 80       	push   $0x80107dd5
80101307:	e8 84 f0 ff ff       	call   80100390 <panic>
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101310 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	56                   	push   %esi
80101315:	53                   	push   %ebx
80101316:	89 c6                	mov    %eax,%esi
80101318:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010131b:	83 fa 0b             	cmp    $0xb,%edx
8010131e:	77 18                	ja     80101338 <bmap+0x28>
80101320:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101323:	8b 5f 60             	mov    0x60(%edi),%ebx
80101326:	85 db                	test   %ebx,%ebx
80101328:	74 76                	je     801013a0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 d8                	mov    %ebx,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101338:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010133b:	83 fb 7f             	cmp    $0x7f,%ebx
8010133e:	0f 87 90 00 00 00    	ja     801013d4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101344:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
8010134a:	8b 00                	mov    (%eax),%eax
8010134c:	85 d2                	test   %edx,%edx
8010134e:	74 70                	je     801013c0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101350:	83 ec 08             	sub    $0x8,%esp
80101353:	52                   	push   %edx
80101354:	50                   	push   %eax
80101355:	e8 76 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010135a:	8d 54 98 60          	lea    0x60(%eax,%ebx,4),%edx
8010135e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101361:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101363:	8b 1a                	mov    (%edx),%ebx
80101365:	85 db                	test   %ebx,%ebx
80101367:	75 1d                	jne    80101386 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101369:	8b 06                	mov    (%esi),%eax
8010136b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010136e:	e8 bd fd ff ff       	call   80101130 <balloc>
80101373:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101376:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101379:	89 c3                	mov    %eax,%ebx
8010137b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010137d:	57                   	push   %edi
8010137e:	e8 1d 1a 00 00       	call   80102da0 <log_write>
80101383:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101386:	83 ec 0c             	sub    $0xc,%esp
80101389:	57                   	push   %edi
8010138a:	e8 51 ee ff ff       	call   801001e0 <brelse>
8010138f:	83 c4 10             	add    $0x10,%esp
}
80101392:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101395:	89 d8                	mov    %ebx,%eax
80101397:	5b                   	pop    %ebx
80101398:	5e                   	pop    %esi
80101399:	5f                   	pop    %edi
8010139a:	5d                   	pop    %ebp
8010139b:	c3                   	ret    
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013a0:	8b 00                	mov    (%eax),%eax
801013a2:	e8 89 fd ff ff       	call   80101130 <balloc>
801013a7:	89 47 60             	mov    %eax,0x60(%edi)
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013ad:	89 c3                	mov    %eax,%ebx
}
801013af:	89 d8                	mov    %ebx,%eax
801013b1:	5b                   	pop    %ebx
801013b2:	5e                   	pop    %esi
801013b3:	5f                   	pop    %edi
801013b4:	5d                   	pop    %ebp
801013b5:	c3                   	ret    
801013b6:	8d 76 00             	lea    0x0(%esi),%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013c0:	e8 6b fd ff ff       	call   80101130 <balloc>
801013c5:	89 c2                	mov    %eax,%edx
801013c7:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
801013cd:	8b 06                	mov    (%esi),%eax
801013cf:	e9 7c ff ff ff       	jmp    80101350 <bmap+0x40>
  panic("bmap: out of range");
801013d4:	83 ec 0c             	sub    $0xc,%esp
801013d7:	68 e5 7d 10 80       	push   $0x80107de5
801013dc:	e8 af ef ff ff       	call   80100390 <panic>
801013e1:	eb 0d                	jmp    801013f0 <readsb>
801013e3:	90                   	nop
801013e4:	90                   	nop
801013e5:	90                   	nop
801013e6:	90                   	nop
801013e7:	90                   	nop
801013e8:	90                   	nop
801013e9:	90                   	nop
801013ea:	90                   	nop
801013eb:	90                   	nop
801013ec:	90                   	nop
801013ed:	90                   	nop
801013ee:	90                   	nop
801013ef:	90                   	nop

801013f0 <readsb>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013f8:	83 ec 08             	sub    $0x8,%esp
801013fb:	6a 01                	push   $0x1
801013fd:	ff 75 08             	pushl  0x8(%ebp)
80101400:	e8 cb ec ff ff       	call   801000d0 <bread>
80101405:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101407:	8d 40 60             	lea    0x60(%eax),%eax
8010140a:	83 c4 0c             	add    $0xc,%esp
8010140d:	6a 1c                	push   $0x1c
8010140f:	50                   	push   %eax
80101410:	56                   	push   %esi
80101411:	e8 6a 3e 00 00       	call   80105280 <memmove>
  brelse(bp);
80101416:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101419:	83 c4 10             	add    $0x10,%esp
}
8010141c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010141f:	5b                   	pop    %ebx
80101420:	5e                   	pop    %esi
80101421:	5d                   	pop    %ebp
  brelse(bp);
80101422:	e9 b9 ed ff ff       	jmp    801001e0 <brelse>
80101427:	89 f6                	mov    %esi,%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <bfree>:
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	56                   	push   %esi
80101434:	53                   	push   %ebx
80101435:	89 d3                	mov    %edx,%ebx
80101437:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101439:	83 ec 08             	sub    $0x8,%esp
8010143c:	68 60 1a 11 80       	push   $0x80111a60
80101441:	50                   	push   %eax
80101442:	e8 a9 ff ff ff       	call   801013f0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101447:	58                   	pop    %eax
80101448:	5a                   	pop    %edx
80101449:	89 da                	mov    %ebx,%edx
8010144b:	c1 ea 0c             	shr    $0xc,%edx
8010144e:	03 15 78 1a 11 80    	add    0x80111a78,%edx
80101454:	52                   	push   %edx
80101455:	56                   	push   %esi
80101456:	e8 75 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010145b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010145d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101460:	ba 01 00 00 00       	mov    $0x1,%edx
80101465:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101468:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010146e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101471:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101473:	0f b6 4c 18 60       	movzbl 0x60(%eax,%ebx,1),%ecx
80101478:	85 d1                	test   %edx,%ecx
8010147a:	74 25                	je     801014a1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010147c:	f7 d2                	not    %edx
8010147e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101480:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101483:	21 ca                	and    %ecx,%edx
80101485:	88 54 1e 60          	mov    %dl,0x60(%esi,%ebx,1)
  log_write(bp);
80101489:	56                   	push   %esi
8010148a:	e8 11 19 00 00       	call   80102da0 <log_write>
  brelse(bp);
8010148f:	89 34 24             	mov    %esi,(%esp)
80101492:	e8 49 ed ff ff       	call   801001e0 <brelse>
}
80101497:	83 c4 10             	add    $0x10,%esp
8010149a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010149d:	5b                   	pop    %ebx
8010149e:	5e                   	pop    %esi
8010149f:	5d                   	pop    %ebp
801014a0:	c3                   	ret    
    panic("freeing free block");
801014a1:	83 ec 0c             	sub    $0xc,%esp
801014a4:	68 f8 7d 10 80       	push   $0x80107df8
801014a9:	e8 e2 ee ff ff       	call   80100390 <panic>
801014ae:	66 90                	xchg   %ax,%ax

801014b0 <iinit>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb c4 1a 11 80       	mov    $0x80111ac4,%ebx
801014b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014bc:	68 0b 7e 10 80       	push   $0x80107e0b
801014c1:	68 80 1a 11 80       	push   $0x80111a80
801014c6:	e8 a5 3a 00 00       	call   80104f70 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 12 7e 10 80       	push   $0x80107e12
801014d8:	53                   	push   %ebx
801014d9:	81 c3 94 00 00 00    	add    $0x94,%ebx
801014df:	e8 5c 39 00 00       	call   80104e40 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014e4:	83 c4 10             	add    $0x10,%esp
801014e7:	81 fb ac 37 11 80    	cmp    $0x801137ac,%ebx
801014ed:	75 e1                	jne    801014d0 <iinit+0x20>
  readsb(dev, &sb);
801014ef:	83 ec 08             	sub    $0x8,%esp
801014f2:	68 60 1a 11 80       	push   $0x80111a60
801014f7:	ff 75 08             	pushl  0x8(%ebp)
801014fa:	e8 f1 fe ff ff       	call   801013f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ff:	ff 35 78 1a 11 80    	pushl  0x80111a78
80101505:	ff 35 74 1a 11 80    	pushl  0x80111a74
8010150b:	ff 35 70 1a 11 80    	pushl  0x80111a70
80101511:	ff 35 6c 1a 11 80    	pushl  0x80111a6c
80101517:	ff 35 68 1a 11 80    	pushl  0x80111a68
8010151d:	ff 35 64 1a 11 80    	pushl  0x80111a64
80101523:	ff 35 60 1a 11 80    	pushl  0x80111a60
80101529:	68 78 7e 10 80       	push   $0x80107e78
8010152e:	e8 2d f1 ff ff       	call   80100660 <cprintf>
}
80101533:	83 c4 30             	add    $0x30,%esp
80101536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101539:	c9                   	leave  
8010153a:	c3                   	ret    
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <ialloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	83 3d 68 1a 11 80 01 	cmpl   $0x1,0x80111a68
{
80101550:	8b 45 0c             	mov    0xc(%ebp),%eax
80101553:	8b 75 08             	mov    0x8(%ebp),%esi
80101556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	0f 86 91 00 00 00    	jbe    801015f0 <ialloc+0xb0>
8010155f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101564:	eb 21                	jmp    80101587 <ialloc+0x47>
80101566:	8d 76 00             	lea    0x0(%esi),%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101570:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101573:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101576:	57                   	push   %edi
80101577:	e8 64 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	39 1d 68 1a 11 80    	cmp    %ebx,0x80111a68
80101585:	76 69                	jbe    801015f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101587:	89 d8                	mov    %ebx,%eax
80101589:	83 ec 08             	sub    $0x8,%esp
8010158c:	c1 e8 03             	shr    $0x3,%eax
8010158f:	03 05 74 1a 11 80    	add    0x80111a74,%eax
80101595:	50                   	push   %eax
80101596:	56                   	push   %esi
80101597:	e8 34 eb ff ff       	call   801000d0 <bread>
8010159c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010159e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015a0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015a3:	83 e0 07             	and    $0x7,%eax
801015a6:	c1 e0 06             	shl    $0x6,%eax
801015a9:	8d 4c 07 60          	lea    0x60(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015b1:	75 bd                	jne    80101570 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015b3:	83 ec 04             	sub    $0x4,%esp
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	6a 40                	push   $0x40
801015bb:	6a 00                	push   $0x0
801015bd:	51                   	push   %ecx
801015be:	e8 0d 3c 00 00       	call   801051d0 <memset>
      dip->type = type;
801015c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015cd:	89 3c 24             	mov    %edi,(%esp)
801015d0:	e8 cb 17 00 00       	call   80102da0 <log_write>
      brelse(bp);
801015d5:	89 3c 24             	mov    %edi,(%esp)
801015d8:	e8 03 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015dd:	83 c4 10             	add    $0x10,%esp
}
801015e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015e3:	89 da                	mov    %ebx,%edx
801015e5:	89 f0                	mov    %esi,%eax
}
801015e7:	5b                   	pop    %ebx
801015e8:	5e                   	pop    %esi
801015e9:	5f                   	pop    %edi
801015ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801015eb:	e9 50 fc ff ff       	jmp    80101240 <iget>
  panic("ialloc: no inodes");
801015f0:	83 ec 0c             	sub    $0xc,%esp
801015f3:	68 18 7e 10 80       	push   $0x80107e18
801015f8:	e8 93 ed ff ff       	call   80100390 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101608:	83 ec 08             	sub    $0x8,%esp
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 60             	add    $0x60,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 74 1a 11 80    	add    0x80111a74,%eax
8010161a:	50                   	push   %eax
8010161b:	ff 73 a0             	pushl  -0x60(%ebx)
8010161e:	e8 ad ea ff ff       	call   801000d0 <bread>
80101623:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101625:	8b 43 a4             	mov    -0x5c(%ebx),%eax
  dip->type = ip->type;
80101628:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010162f:	83 e0 07             	and    $0x7,%eax
80101632:	c1 e0 06             	shl    $0x6,%eax
80101635:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
  dip->type = ip->type;
80101639:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010163c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101640:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101643:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101647:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010164b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010164f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101653:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101657:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010165a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165d:	6a 34                	push   $0x34
8010165f:	53                   	push   %ebx
80101660:	50                   	push   %eax
80101661:	e8 1a 3c 00 00       	call   80105280 <memmove>
  log_write(bp);
80101666:	89 34 24             	mov    %esi,(%esp)
80101669:	e8 32 17 00 00       	call   80102da0 <log_write>
  brelse(bp);
8010166e:	89 75 08             	mov    %esi,0x8(%ebp)
80101671:	83 c4 10             	add    $0x10,%esp
}
80101674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5d                   	pop    %ebp
  brelse(bp);
8010167a:	e9 61 eb ff ff       	jmp    801001e0 <brelse>
8010167f:	90                   	nop

80101680 <idup>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 10             	sub    $0x10,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	68 80 1a 11 80       	push   $0x80111a80
8010168f:	e8 1c 3a 00 00       	call   801050b0 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010169f:	e8 dc 3a 00 00       	call   80105180 <release>
}
801016a4:	89 d8                	mov    %ebx,%eax
801016a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016a9:	c9                   	leave  
801016aa:	c3                   	ret    
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <ilock>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016b8:	85 db                	test   %ebx,%ebx
801016ba:	0f 84 b7 00 00 00    	je     80101777 <ilock+0xc7>
801016c0:	8b 53 08             	mov    0x8(%ebx),%edx
801016c3:	85 d2                	test   %edx,%edx
801016c5:	0f 8e ac 00 00 00    	jle    80101777 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ce:	83 ec 0c             	sub    $0xc,%esp
801016d1:	50                   	push   %eax
801016d2:	e8 a9 37 00 00       	call   80104e80 <acquiresleep>
  if(ip->valid == 0){
801016d7:	8b 43 50             	mov    0x50(%ebx),%eax
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	85 c0                	test   %eax,%eax
801016df:	74 0f                	je     801016f0 <ilock+0x40>
}
801016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e4:	5b                   	pop    %ebx
801016e5:	5e                   	pop    %esi
801016e6:	5d                   	pop    %ebp
801016e7:	c3                   	ret    
801016e8:	90                   	nop
801016e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f0:	8b 43 04             	mov    0x4(%ebx),%eax
801016f3:	83 ec 08             	sub    $0x8,%esp
801016f6:	c1 e8 03             	shr    $0x3,%eax
801016f9:	03 05 74 1a 11 80    	add    0x80111a74,%eax
801016ff:	50                   	push   %eax
80101700:	ff 33                	pushl  (%ebx)
80101702:	e8 c9 e9 ff ff       	call   801000d0 <bread>
80101707:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101709:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
    ip->type = dip->type;
80101719:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010171f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->major = dip->major;
80101723:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101727:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->minor = dip->minor;
8010172b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010172f:	66 89 53 58          	mov    %dx,0x58(%ebx)
    ip->nlink = dip->nlink;
80101733:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101737:	66 89 53 5a          	mov    %dx,0x5a(%ebx)
    ip->size = dip->size;
8010173b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010173e:	89 53 5c             	mov    %edx,0x5c(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101741:	6a 34                	push   $0x34
80101743:	50                   	push   %eax
80101744:	8d 43 60             	lea    0x60(%ebx),%eax
80101747:	50                   	push   %eax
80101748:	e8 33 3b 00 00       	call   80105280 <memmove>
    brelse(bp);
8010174d:	89 34 24             	mov    %esi,(%esp)
80101750:	e8 8b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101755:	83 c4 10             	add    $0x10,%esp
80101758:	66 83 7b 54 00       	cmpw   $0x0,0x54(%ebx)
    ip->valid = 1;
8010175d:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
    if(ip->type == 0)
80101764:	0f 85 77 ff ff ff    	jne    801016e1 <ilock+0x31>
      panic("ilock: no type");
8010176a:	83 ec 0c             	sub    $0xc,%esp
8010176d:	68 30 7e 10 80       	push   $0x80107e30
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 2a 7e 10 80       	push   $0x80107e2a
8010177f:	e8 0c ec ff ff       	call   80100390 <panic>
80101784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010178a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101790 <iunlock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	74 28                	je     801017c4 <iunlock+0x34>
8010179c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010179f:	83 ec 0c             	sub    $0xc,%esp
801017a2:	56                   	push   %esi
801017a3:	e8 78 37 00 00       	call   80104f20 <holdingsleep>
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 c0                	test   %eax,%eax
801017ad:	74 15                	je     801017c4 <iunlock+0x34>
801017af:	8b 43 08             	mov    0x8(%ebx),%eax
801017b2:	85 c0                	test   %eax,%eax
801017b4:	7e 0e                	jle    801017c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017bc:	5b                   	pop    %ebx
801017bd:	5e                   	pop    %esi
801017be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017bf:	e9 1c 37 00 00       	jmp    80104ee0 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 3f 7e 10 80       	push   $0x80107e3f
801017cc:	e8 bf eb ff ff       	call   80100390 <panic>
801017d1:	eb 0d                	jmp    801017e0 <iput>
801017d3:	90                   	nop
801017d4:	90                   	nop
801017d5:	90                   	nop
801017d6:	90                   	nop
801017d7:	90                   	nop
801017d8:	90                   	nop
801017d9:	90                   	nop
801017da:	90                   	nop
801017db:	90                   	nop
801017dc:	90                   	nop
801017dd:	90                   	nop
801017de:	90                   	nop
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 28             	sub    $0x28,%esp
801017e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ef:	57                   	push   %edi
801017f0:	e8 8b 36 00 00       	call   80104e80 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f5:	8b 53 50             	mov    0x50(%ebx),%edx
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	85 d2                	test   %edx,%edx
801017fd:	74 07                	je     80101806 <iput+0x26>
801017ff:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
80101804:	74 32                	je     80101838 <iput+0x58>
  releasesleep(&ip->lock);
80101806:	83 ec 0c             	sub    $0xc,%esp
80101809:	57                   	push   %edi
8010180a:	e8 d1 36 00 00       	call   80104ee0 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101816:	e8 95 38 00 00       	call   801050b0 <acquire>
  ip->ref--;
8010181b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010181f:	83 c4 10             	add    $0x10,%esp
80101822:	c7 45 08 80 1a 11 80 	movl   $0x80111a80,0x8(%ebp)
}
80101829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5f                   	pop    %edi
8010182f:	5d                   	pop    %ebp
  release(&icache.lock);
80101830:	e9 4b 39 00 00       	jmp    80105180 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 80 1a 11 80       	push   $0x80111a80
80101840:	e8 6b 38 00 00       	call   801050b0 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010184f:	e8 2c 39 00 00       	call   80105180 <release>
    if(r == 1){
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	83 fe 01             	cmp    $0x1,%esi
8010185a:	75 aa                	jne    80101806 <iput+0x26>
8010185c:	8d 8b 90 00 00 00    	lea    0x90(%ebx),%ecx
80101862:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101865:	8d 73 60             	lea    0x60(%ebx),%esi
80101868:	89 cf                	mov    %ecx,%edi
8010186a:	eb 0b                	jmp    80101877 <iput+0x97>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101870:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fe                	cmp    %edi,%esi
80101875:	74 19                	je     80101890 <iput+0xb0>
    if(ip->addrs[i]){
80101877:	8b 16                	mov    (%esi),%edx
80101879:	85 d2                	test   %edx,%edx
8010187b:	74 f3                	je     80101870 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010187d:	8b 03                	mov    (%ebx),%eax
8010187f:	e8 ac fb ff ff       	call   80101430 <bfree>
      ip->addrs[i] = 0;
80101884:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010188a:	eb e4                	jmp    80101870 <iput+0x90>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80101896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101899:	85 c0                	test   %eax,%eax
8010189b:	75 33                	jne    801018d0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010189d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018a0:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  iupdate(ip);
801018a7:	53                   	push   %ebx
801018a8:	e8 53 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
801018ad:	31 c0                	xor    %eax,%eax
801018af:	66 89 43 54          	mov    %ax,0x54(%ebx)
      iupdate(ip);
801018b3:	89 1c 24             	mov    %ebx,(%esp)
801018b6:	e8 45 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018bb:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	e9 3c ff ff ff       	jmp    80101806 <iput+0x26>
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	83 ec 08             	sub    $0x8,%esp
801018d3:	50                   	push   %eax
801018d4:	ff 33                	pushl  (%ebx)
801018d6:	e8 f5 e7 ff ff       	call   801000d0 <bread>
801018db:	8d 88 60 02 00 00    	lea    0x260(%eax),%ecx
801018e1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018e7:	8d 70 60             	lea    0x60(%eax),%esi
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	89 cf                	mov    %ecx,%edi
801018ef:	eb 0e                	jmp    801018ff <iput+0x11f>
801018f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018fb:	39 fe                	cmp    %edi,%esi
801018fd:	74 0f                	je     8010190e <iput+0x12e>
      if(a[j])
801018ff:	8b 16                	mov    (%esi),%edx
80101901:	85 d2                	test   %edx,%edx
80101903:	74 f3                	je     801018f8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101905:	8b 03                	mov    (%ebx),%eax
80101907:	e8 24 fb ff ff       	call   80101430 <bfree>
8010190c:	eb ea                	jmp    801018f8 <iput+0x118>
    brelse(bp);
8010190e:	83 ec 0c             	sub    $0xc,%esp
80101911:	ff 75 e4             	pushl  -0x1c(%ebp)
80101914:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101917:	e8 c4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010191c:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
80101922:	8b 03                	mov    (%ebx),%eax
80101924:	e8 07 fb ff ff       	call   80101430 <bfree>
    ip->addrs[NDIRECT] = 0;
80101929:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80101930:	00 00 00 
80101933:	83 c4 10             	add    $0x10,%esp
80101936:	e9 62 ff ff ff       	jmp    8010189d <iput+0xbd>
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <iunlockput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 10             	sub    $0x10,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	53                   	push   %ebx
8010194b:	e8 40 fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101950:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101953:	83 c4 10             	add    $0x10,%esp
}
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
  iput(ip);
8010195a:	e9 81 fe ff ff       	jmp    801017e0 <iput>
8010195f:	90                   	nop

80101960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 54          	movzwl 0x54(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 5a          	movzwl 0x5a(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 5c             	mov    0x5c(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 1c             	sub    $0x1c,%esp
80101999:	8b 45 08             	mov    0x8(%ebp),%eax
8010199c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010199f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a2:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
{
801019a7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019ad:	8b 75 10             	mov    0x10(%ebp),%esi
801019b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019b3:	0f 84 a7 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019bc:	8b 40 5c             	mov    0x5c(%eax),%eax
801019bf:	39 c6                	cmp    %eax,%esi
801019c1:	0f 87 ba 00 00 00    	ja     80101a81 <readi+0xf1>
801019c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ca:	89 f9                	mov    %edi,%ecx
801019cc:	01 f1                	add    %esi,%ecx
801019ce:	0f 82 ad 00 00 00    	jb     80101a81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019d4:	89 c2                	mov    %eax,%edx
801019d6:	29 f2                	sub    %esi,%edx
801019d8:	39 c8                	cmp    %ecx,%eax
801019da:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019dd:	31 ff                	xor    %edi,%edi
801019df:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e4:	74 6c                	je     80101a52 <readi+0xc2>
801019e6:	8d 76 00             	lea    0x0(%esi),%esi
801019e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019f3:	89 f2                	mov    %esi,%edx
801019f5:	c1 ea 09             	shr    $0x9,%edx
801019f8:	89 d8                	mov    %ebx,%eax
801019fa:	e8 11 f9 ff ff       	call   80101310 <bmap>
801019ff:	83 ec 08             	sub    $0x8,%esp
80101a02:	50                   	push   %eax
80101a03:	ff 33                	pushl  (%ebx)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0f:	89 f0                	mov    %esi,%eax
80101a11:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a16:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a1b:	83 c4 0c             	add    $0xc,%esp
80101a1e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	8d 44 02 60          	lea    0x60(%edx,%eax,1),%eax
80101a24:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	29 fb                	sub    %edi,%ebx
80101a29:	39 d9                	cmp    %ebx,%ecx
80101a2b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2e:	53                   	push   %ebx
80101a2f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a30:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a35:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a37:	e8 44 38 00 00       	call   80105280 <memmove>
    brelse(bp);
80101a3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a3f:	89 14 24             	mov    %edx,(%esp)
80101a42:	e8 99 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a50:	77 9e                	ja     801019f0 <readi+0x60>
  }
  return n;
80101a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5f                   	pop    %edi
80101a5b:	5d                   	pop    %ebp
80101a5c:	c3                   	ret    
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 17                	ja     80101a81 <readi+0xf1>
80101a6a:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 0c                	je     80101a81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7b:	5b                   	pop    %ebx
80101a7c:	5e                   	pop    %esi
80101a7d:	5f                   	pop    %edi
80101a7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a7f:	ff e0                	jmp    *%eax
      return -1;
80101a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a86:	eb cd                	jmp    80101a55 <readi+0xc5>
80101a88:	90                   	nop
80101a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aad:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 5c             	cmp    %esi,0x5c(%eax)
80101abf:	0f 82 eb 00 00 00    	jb     80101bb0 <writei+0x120>
80101ac5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ac8:	31 d2                	xor    %edx,%edx
80101aca:	89 f8                	mov    %edi,%eax
80101acc:	01 f0                	add    %esi,%eax
80101ace:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad6:	0f 87 d4 00 00 00    	ja     80101bb0 <writei+0x120>
80101adc:	85 d2                	test   %edx,%edx
80101ade:	0f 85 cc 00 00 00    	jne    80101bb0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae4:	85 ff                	test   %edi,%edi
80101ae6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aed:	74 72                	je     80101b61 <writei+0xd1>
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 f8                	mov    %edi,%eax
80101afa:	e8 11 f8 ff ff       	call   80101310 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 37                	pushl  (%edi)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b0d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b12:	89 f0                	mov    %esi,%eax
80101b14:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b19:	83 c4 0c             	add    $0xc,%esp
80101b1c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b21:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 60          	lea    0x60(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b27:	39 d9                	cmp    %ebx,%ecx
80101b29:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b2c:	53                   	push   %ebx
80101b2d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b30:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b32:	50                   	push   %eax
80101b33:	e8 48 37 00 00       	call   80105280 <memmove>
    log_write(bp);
80101b38:	89 3c 24             	mov    %edi,(%esp)
80101b3b:	e8 60 12 00 00       	call   80102da0 <log_write>
    brelse(bp);
80101b40:	89 3c 24             	mov    %edi,(%esp)
80101b43:	e8 98 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b4e:	83 c4 10             	add    $0x10,%esp
80101b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b57:	77 97                	ja     80101af0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5c:	3b 70 5c             	cmp    0x5c(%eax),%esi
80101b5f:	77 37                	ja     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b67:	5b                   	pop    %ebx
80101b68:	5e                   	pop    %esi
80101b69:	5f                   	pop    %edi
80101b6a:	5d                   	pop    %ebp
80101b6b:	c3                   	ret    
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 36                	ja     80101bb0 <writei+0x120>
80101b7a:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 2b                	je     80101bb0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b9e:	89 70 5c             	mov    %esi,0x5c(%eax)
    iupdate(ip);
80101ba1:	50                   	push   %eax
80101ba2:	e8 59 fa ff ff       	call   80101600 <iupdate>
80101ba7:	83 c4 10             	add    $0x10,%esp
80101baa:	eb b5                	jmp    80101b61 <writei+0xd1>
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bb5:	eb ad                	jmp    80101b64 <writei+0xd4>
80101bb7:	89 f6                	mov    %esi,%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	6a 0e                	push   $0xe
80101bc8:	ff 75 0c             	pushl  0xc(%ebp)
80101bcb:	ff 75 08             	pushl  0x8(%ebp)
80101bce:	e8 1d 37 00 00       	call   801052f0 <strncmp>
}
80101bd3:	c9                   	leave  
80101bd4:	c3                   	ret    
80101bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80101bf1:	0f 85 85 00 00 00    	jne    80101c7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	74 3e                	je     80101c41 <dirlookup+0x61>
80101c03:	90                   	nop
80101c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c08:	6a 10                	push   $0x10
80101c0a:	57                   	push   %edi
80101c0b:	56                   	push   %esi
80101c0c:	53                   	push   %ebx
80101c0d:	e8 7e fd ff ff       	call   80101990 <readi>
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	83 f8 10             	cmp    $0x10,%eax
80101c18:	75 55                	jne    80101c6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c1f:	74 18                	je     80101c39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c24:	83 ec 04             	sub    $0x4,%esp
80101c27:	6a 0e                	push   $0xe
80101c29:	50                   	push   %eax
80101c2a:	ff 75 0c             	pushl  0xc(%ebp)
80101c2d:	e8 be 36 00 00       	call   801052f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 17                	je     80101c50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c39:	83 c7 10             	add    $0x10,%edi
80101c3c:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101c3f:	72 c7                	jb     80101c08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c44:	31 c0                	xor    %eax,%eax
}
80101c46:	5b                   	pop    %ebx
80101c47:	5e                   	pop    %esi
80101c48:	5f                   	pop    %edi
80101c49:	5d                   	pop    %ebp
80101c4a:	c3                   	ret    
80101c4b:	90                   	nop
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c50:	8b 45 10             	mov    0x10(%ebp),%eax
80101c53:	85 c0                	test   %eax,%eax
80101c55:	74 05                	je     80101c5c <dirlookup+0x7c>
        *poff = off;
80101c57:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c60:	8b 03                	mov    (%ebx),%eax
80101c62:	e8 d9 f5 ff ff       	call   80101240 <iget>
}
80101c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6a:	5b                   	pop    %ebx
80101c6b:	5e                   	pop    %esi
80101c6c:	5f                   	pop    %edi
80101c6d:	5d                   	pop    %ebp
80101c6e:	c3                   	ret    
      panic("dirlookup read");
80101c6f:	83 ec 0c             	sub    $0xc,%esp
80101c72:	68 59 7e 10 80       	push   $0x80107e59
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 47 7e 10 80       	push   $0x80107e47
80101c84:	e8 07 e7 ff ff       	call   80100390 <panic>
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	89 cf                	mov    %ecx,%edi
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 67 01 00 00    	je     80101e10 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 62 1c 00 00       	call   80103910 <myproc>
  acquire(&icache.lock);
80101cae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cb1:	8b 70 60             	mov    0x60(%eax),%esi
  acquire(&icache.lock);
80101cb4:	68 80 1a 11 80       	push   $0x80111a80
80101cb9:	e8 f2 33 00 00       	call   801050b0 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101cc9:	e8 b2 34 00 00       	call   80105180 <release>
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	eb 08                	jmp    80101cdb <namex+0x4b>
80101cd3:	90                   	nop
80101cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cdb:	0f b6 03             	movzbl (%ebx),%eax
80101cde:	3c 2f                	cmp    $0x2f,%al
80101ce0:	74 f6                	je     80101cd8 <namex+0x48>
  if(*path == 0)
80101ce2:	84 c0                	test   %al,%al
80101ce4:	0f 84 ee 00 00 00    	je     80101dd8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cea:	0f b6 03             	movzbl (%ebx),%eax
80101ced:	3c 2f                	cmp    $0x2f,%al
80101cef:	0f 84 b3 00 00 00    	je     80101da8 <namex+0x118>
80101cf5:	84 c0                	test   %al,%al
80101cf7:	89 da                	mov    %ebx,%edx
80101cf9:	75 09                	jne    80101d04 <namex+0x74>
80101cfb:	e9 a8 00 00 00       	jmp    80101da8 <namex+0x118>
80101d00:	84 c0                	test   %al,%al
80101d02:	74 0a                	je     80101d0e <namex+0x7e>
    path++;
80101d04:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d07:	0f b6 02             	movzbl (%edx),%eax
80101d0a:	3c 2f                	cmp    $0x2f,%al
80101d0c:	75 f2                	jne    80101d00 <namex+0x70>
80101d0e:	89 d1                	mov    %edx,%ecx
80101d10:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d12:	83 f9 0d             	cmp    $0xd,%ecx
80101d15:	0f 8e 91 00 00 00    	jle    80101dac <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d1b:	83 ec 04             	sub    $0x4,%esp
80101d1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d21:	6a 0e                	push   $0xe
80101d23:	53                   	push   %ebx
80101d24:	57                   	push   %edi
80101d25:	e8 56 35 00 00       	call   80105280 <memmove>
    path++;
80101d2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d2d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d30:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d32:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d35:	75 11                	jne    80101d48 <namex+0xb8>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	83 ec 0c             	sub    $0xc,%esp
80101d4b:	56                   	push   %esi
80101d4c:	e8 5f f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
80101d59:	0f 85 91 00 00 00    	jne    80101df0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d62:	85 d2                	test   %edx,%edx
80101d64:	74 09                	je     80101d6f <namex+0xdf>
80101d66:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d69:	0f 84 b7 00 00 00    	je     80101e26 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6f:	83 ec 04             	sub    $0x4,%esp
80101d72:	6a 00                	push   $0x0
80101d74:	57                   	push   %edi
80101d75:	56                   	push   %esi
80101d76:	e8 65 fe ff ff       	call   80101be0 <dirlookup>
80101d7b:	83 c4 10             	add    $0x10,%esp
80101d7e:	85 c0                	test   %eax,%eax
80101d80:	74 6e                	je     80101df0 <namex+0x160>
  iunlock(ip);
80101d82:	83 ec 0c             	sub    $0xc,%esp
80101d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d88:	56                   	push   %esi
80101d89:	e8 02 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	83 c4 10             	add    $0x10,%esp
80101d9c:	89 c6                	mov    %eax,%esi
80101d9e:	e9 38 ff ff ff       	jmp    80101cdb <namex+0x4b>
80101da3:	90                   	nop
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101da8:	89 da                	mov    %ebx,%edx
80101daa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dac:	83 ec 04             	sub    $0x4,%esp
80101daf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db5:	51                   	push   %ecx
80101db6:	53                   	push   %ebx
80101db7:	57                   	push   %edi
80101db8:	e8 c3 34 00 00       	call   80105280 <memmove>
    name[len] = 0;
80101dbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc3:	83 c4 10             	add    $0x10,%esp
80101dc6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dca:	89 d3                	mov    %edx,%ebx
80101dcc:	e9 61 ff ff ff       	jmp    80101d32 <namex+0xa2>
80101dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ddb:	85 c0                	test   %eax,%eax
80101ddd:	75 5d                	jne    80101e3c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de2:	89 f0                	mov    %esi,%eax
80101de4:	5b                   	pop    %ebx
80101de5:	5e                   	pop    %esi
80101de6:	5f                   	pop    %edi
80101de7:	5d                   	pop    %ebp
80101de8:	c3                   	ret    
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101df0:	83 ec 0c             	sub    $0xc,%esp
80101df3:	56                   	push   %esi
80101df4:	e8 97 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101df9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dfc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dfe:	e8 dd f9 ff ff       	call   801017e0 <iput>
      return 0;
80101e03:	83 c4 10             	add    $0x10,%esp
}
80101e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e09:	89 f0                	mov    %esi,%eax
80101e0b:	5b                   	pop    %ebx
80101e0c:	5e                   	pop    %esi
80101e0d:	5f                   	pop    %edi
80101e0e:	5d                   	pop    %ebp
80101e0f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e10:	ba 01 00 00 00       	mov    $0x1,%edx
80101e15:	b8 01 00 00 00       	mov    $0x1,%eax
80101e1a:	e8 21 f4 ff ff       	call   80101240 <iget>
80101e1f:	89 c6                	mov    %eax,%esi
80101e21:	e9 b5 fe ff ff       	jmp    80101cdb <namex+0x4b>
      iunlock(ip);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	56                   	push   %esi
80101e2a:	e8 61 f9 ff ff       	call   80101790 <iunlock>
      return ip;
80101e2f:	83 c4 10             	add    $0x10,%esp
}
80101e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e35:	89 f0                	mov    %esi,%eax
80101e37:	5b                   	pop    %ebx
80101e38:	5e                   	pop    %esi
80101e39:	5f                   	pop    %edi
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    
    iput(ip);
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	56                   	push   %esi
    return 0;
80101e40:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e42:	e8 99 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	eb 93                	jmp    80101ddf <namex+0x14f>
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e50 <dirlink>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 20             	sub    $0x20,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	6a 00                	push   $0x0
80101e5e:	ff 75 0c             	pushl  0xc(%ebp)
80101e61:	53                   	push   %ebx
80101e62:	e8 79 fd ff ff       	call   80101be0 <dirlookup>
80101e67:	83 c4 10             	add    $0x10,%esp
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	75 67                	jne    80101ed5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6e:	8b 7b 5c             	mov    0x5c(%ebx),%edi
80101e71:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e74:	85 ff                	test   %edi,%edi
80101e76:	74 29                	je     80101ea1 <dirlink+0x51>
80101e78:	31 ff                	xor    %edi,%edi
80101e7a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e7d:	eb 09                	jmp    80101e88 <dirlink+0x38>
80101e7f:	90                   	nop
80101e80:	83 c7 10             	add    $0x10,%edi
80101e83:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101e86:	73 19                	jae    80101ea1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e88:	6a 10                	push   $0x10
80101e8a:	57                   	push   %edi
80101e8b:	56                   	push   %esi
80101e8c:	53                   	push   %ebx
80101e8d:	e8 fe fa ff ff       	call   80101990 <readi>
80101e92:	83 c4 10             	add    $0x10,%esp
80101e95:	83 f8 10             	cmp    $0x10,%eax
80101e98:	75 4e                	jne    80101ee8 <dirlink+0x98>
    if(de.inum == 0)
80101e9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9f:	75 df                	jne    80101e80 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ea1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea4:	83 ec 04             	sub    $0x4,%esp
80101ea7:	6a 0e                	push   $0xe
80101ea9:	ff 75 0c             	pushl  0xc(%ebp)
80101eac:	50                   	push   %eax
80101ead:	e8 9e 34 00 00       	call   80105350 <strncpy>
  de.inum = inum;
80101eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb5:	6a 10                	push   $0x10
80101eb7:	57                   	push   %edi
80101eb8:	56                   	push   %esi
80101eb9:	53                   	push   %ebx
  de.inum = inum;
80101eba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebe:	e8 cd fb ff ff       	call   80101a90 <writei>
80101ec3:	83 c4 20             	add    $0x20,%esp
80101ec6:	83 f8 10             	cmp    $0x10,%eax
80101ec9:	75 2a                	jne    80101ef5 <dirlink+0xa5>
  return 0;
80101ecb:	31 c0                	xor    %eax,%eax
}
80101ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
    iput(ip);
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	50                   	push   %eax
80101ed9:	e8 02 f9 ff ff       	call   801017e0 <iput>
    return -1;
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee6:	eb e5                	jmp    80101ecd <dirlink+0x7d>
      panic("dirlink read");
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	68 68 7e 10 80       	push   $0x80107e68
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 8e 85 10 80       	push   $0x8010858e
80101efd:	e8 8e e4 ff ff       	call   80100390 <panic>
80101f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f59:	85 c0                	test   %eax,%eax
80101f5b:	0f 84 b4 00 00 00    	je     80102015 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f61:	8b 58 08             	mov    0x8(%eax),%ebx
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f6c:	0f 87 96 00 00 00    	ja     80102008 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f72:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f77:	89 f6                	mov    %esi,%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f80:	89 ca                	mov    %ecx,%edx
80101f82:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f83:	83 e0 c0             	and    $0xffffffc0,%eax
80101f86:	3c 40                	cmp    $0x40,%al
80101f88:	75 f6                	jne    80101f80 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f8a:	31 ff                	xor    %edi,%edi
80101f8c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f91:	89 f8                	mov    %edi,%eax
80101f93:	ee                   	out    %al,(%dx)
80101f94:	b8 01 00 00 00       	mov    $0x1,%eax
80101f99:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9e:	ee                   	out    %al,(%dx)
80101f9f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fa4:	89 d8                	mov    %ebx,%eax
80101fa6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fae:	c1 f8 08             	sar    $0x8,%eax
80101fb1:	ee                   	out    %al,(%dx)
80101fb2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fb7:	89 f8                	mov    %edi,%eax
80101fb9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fc3:	c1 e0 04             	shl    $0x4,%eax
80101fc6:	83 e0 10             	and    $0x10,%eax
80101fc9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fcc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fcd:	f6 06 04             	testb  $0x4,(%esi)
80101fd0:	75 16                	jne    80101fe8 <idestart+0x98>
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	89 ca                	mov    %ecx,%edx
80101fd9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fdd:	5b                   	pop    %ebx
80101fde:	5e                   	pop    %esi
80101fdf:	5f                   	pop    %edi
80101fe0:	5d                   	pop    %ebp
80101fe1:	c3                   	ret    
80101fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fe8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fed:	89 ca                	mov    %ecx,%edx
80101fef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101ff0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101ff5:	83 c6 60             	add    $0x60,%esi
80101ff8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ffd:	fc                   	cld    
80101ffe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102003:	5b                   	pop    %ebx
80102004:	5e                   	pop    %esi
80102005:	5f                   	pop    %edi
80102006:	5d                   	pop    %ebp
80102007:	c3                   	ret    
    panic("incorrect blockno");
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	68 d4 7e 10 80       	push   $0x80107ed4
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 cb 7e 10 80       	push   $0x80107ecb
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 e6 7e 10 80       	push   $0x80107ee6
8010203b:	68 80 b5 10 80       	push   $0x8010b580
80102040:	e8 2b 2f 00 00       	call   80104f70 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102045:	58                   	pop    %eax
80102046:	a1 c0 3e 11 80       	mov    0x80113ec0,%eax
8010204b:	5a                   	pop    %edx
8010204c:	83 e8 01             	sub    $0x1,%eax
8010204f:	50                   	push   %eax
80102050:	6a 0e                	push   $0xe
80102052:	e8 a9 02 00 00       	call   80102300 <ioapicenable>
80102057:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010205a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205f:	90                   	nop
80102060:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102061:	83 e0 c0             	and    $0xffffffc0,%eax
80102064:	3c 40                	cmp    $0x40,%al
80102066:	75 f8                	jne    80102060 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102068:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010206d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102072:	ee                   	out    %al,(%dx)
80102073:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102078:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010207d:	eb 06                	jmp    80102085 <ideinit+0x55>
8010207f:	90                   	nop
  for(i=0; i<1000; i++){
80102080:	83 e9 01             	sub    $0x1,%ecx
80102083:	74 0f                	je     80102094 <ideinit+0x64>
80102085:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102086:	84 c0                	test   %al,%al
80102088:	74 f6                	je     80102080 <ideinit+0x50>
      havedisk1 = 1;
8010208a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102091:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102094:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102099:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010209e:	ee                   	out    %al,(%dx)
}
8010209f:	c9                   	leave  
801020a0:	c3                   	ret    
801020a1:	eb 0d                	jmp    801020b0 <ideintr>
801020a3:	90                   	nop
801020a4:	90                   	nop
801020a5:	90                   	nop
801020a6:	90                   	nop
801020a7:	90                   	nop
801020a8:	90                   	nop
801020a9:	90                   	nop
801020aa:	90                   	nop
801020ab:	90                   	nop
801020ac:	90                   	nop
801020ad:	90                   	nop
801020ae:	90                   	nop
801020af:	90                   	nop

801020b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	68 80 b5 10 80       	push   $0x8010b580
801020be:	e8 ed 2f 00 00       	call   801050b0 <acquire>

  if((b = idequeue) == 0){
801020c3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	85 db                	test   %ebx,%ebx
801020ce:	74 67                	je     80102137 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020d0:	8b 43 5c             	mov    0x5c(%ebx),%eax
801020d3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d8:	8b 3b                	mov    (%ebx),%edi
801020da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020e0:	75 31                	jne    80102113 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020e7:	89 f6                	mov    %esi,%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c6                	mov    %eax,%esi
801020f3:	83 e6 c0             	and    $0xffffffc0,%esi
801020f6:	89 f1                	mov    %esi,%ecx
801020f8:	80 f9 40             	cmp    $0x40,%cl
801020fb:	75 f3                	jne    801020f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fd:	a8 21                	test   $0x21,%al
801020ff:	75 12                	jne    80102113 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102101:	8d 7b 60             	lea    0x60(%ebx),%edi
  asm volatile("cld; rep insl" :
80102104:	b9 80 00 00 00       	mov    $0x80,%ecx
80102109:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210e:	fc                   	cld    
8010210f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102111:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102113:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102116:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102119:	89 f9                	mov    %edi,%ecx
8010211b:	83 c9 02             	or     $0x2,%ecx
8010211e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102120:	53                   	push   %ebx
80102121:	e8 7a 23 00 00       	call   801044a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102126:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010212b:	83 c4 10             	add    $0x10,%esp
8010212e:	85 c0                	test   %eax,%eax
80102130:	74 05                	je     80102137 <ideintr+0x87>
    idestart(idequeue);
80102132:	e8 19 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
80102137:	83 ec 0c             	sub    $0xc,%esp
8010213a:	68 80 b5 10 80       	push   $0x8010b580
8010213f:	e8 3c 30 00 00       	call   80105180 <release>

  release(&idelock);
}
80102144:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102147:	5b                   	pop    %ebx
80102148:	5e                   	pop    %esi
80102149:	5f                   	pop    %edi
8010214a:	5d                   	pop    %ebp
8010214b:	c3                   	ret    
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 10             	sub    $0x10,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	50                   	push   %eax
8010215e:	e8 bd 2d 00 00       	call   80104f20 <holdingsleep>
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	85 c0                	test   %eax,%eax
80102168:	0f 84 c6 00 00 00    	je     80102234 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	0f 84 ab 00 00 00    	je     80102227 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217c:	8b 53 04             	mov    0x4(%ebx),%edx
8010217f:	85 d2                	test   %edx,%edx
80102181:	74 0d                	je     80102190 <iderw+0x40>
80102183:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102188:	85 c0                	test   %eax,%eax
8010218a:	0f 84 b1 00 00 00    	je     80102241 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102190:	83 ec 0c             	sub    $0xc,%esp
80102193:	68 80 b5 10 80       	push   $0x8010b580
80102198:	e8 13 2f 00 00       	call   801050b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801021a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021a6:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	85 d2                	test   %edx,%edx
801021af:	75 09                	jne    801021ba <iderw+0x6a>
801021b1:	eb 6d                	jmp    80102220 <iderw+0xd0>
801021b3:	90                   	nop
801021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b8:	89 c2                	mov    %eax,%edx
801021ba:	8b 42 5c             	mov    0x5c(%edx),%eax
801021bd:	85 c0                	test   %eax,%eax
801021bf:	75 f7                	jne    801021b8 <iderw+0x68>
801021c1:	83 c2 5c             	add    $0x5c,%edx
    ;
  *pp = b;
801021c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021c6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021cc:	74 42                	je     80102210 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 e0 06             	and    $0x6,%eax
801021d3:	83 f8 02             	cmp    $0x2,%eax
801021d6:	74 23                	je     801021fb <iderw+0xab>
801021d8:	90                   	nop
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021e0:	83 ec 08             	sub    $0x8,%esp
801021e3:	68 80 b5 10 80       	push   $0x8010b580
801021e8:	53                   	push   %ebx
801021e9:	e8 b2 1d 00 00       	call   80103fa0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ee:	8b 03                	mov    (%ebx),%eax
801021f0:	83 c4 10             	add    $0x10,%esp
801021f3:	83 e0 06             	and    $0x6,%eax
801021f6:	83 f8 02             	cmp    $0x2,%eax
801021f9:	75 e5                	jne    801021e0 <iderw+0x90>
  }


  release(&idelock);
801021fb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102205:	c9                   	leave  
  release(&idelock);
80102206:	e9 75 2f 00 00       	jmp    80105180 <release>
8010220b:	90                   	nop
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102210:	89 d8                	mov    %ebx,%eax
80102212:	e8 39 fd ff ff       	call   80101f50 <idestart>
80102217:	eb b5                	jmp    801021ce <iderw+0x7e>
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102220:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102225:	eb 9d                	jmp    801021c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 00 7f 10 80       	push   $0x80107f00
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 ea 7e 10 80       	push   $0x80107eea
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 15 7f 10 80       	push   $0x80107f15
80102249:	e8 42 e1 ff ff       	call   80100390 <panic>
8010224e:	66 90                	xchg   %ax,%ax

80102250 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102251:	c7 05 a0 37 11 80 00 	movl   $0xfec00000,0x801137a0
80102258:	00 c0 fe 
{
8010225b:	89 e5                	mov    %esp,%ebp
8010225d:	56                   	push   %esi
8010225e:	53                   	push   %ebx
  ioapic->reg = reg;
8010225f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102266:	00 00 00 
  return ioapic->data;
80102269:	a1 a0 37 11 80       	mov    0x801137a0,%eax
8010226e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102277:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010227d:	0f b6 15 00 39 11 80 	movzbl 0x80113900,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102284:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102287:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010228a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010228d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102290:	39 c2                	cmp    %eax,%edx
80102292:	74 16                	je     801022aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102294:	83 ec 0c             	sub    $0xc,%esp
80102297:	68 34 7f 10 80       	push   $0x80107f34
8010229c:	e8 bf e3 ff ff       	call   80100660 <cprintf>
801022a1:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	83 c3 21             	add    $0x21,%ebx
{
801022ad:	ba 10 00 00 00       	mov    $0x10,%edx
801022b2:	b8 20 00 00 00       	mov    $0x20,%eax
801022b7:	89 f6                	mov    %esi,%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022c2:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022c8:	89 c6                	mov    %eax,%esi
801022ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022d3:	89 71 10             	mov    %esi,0x10(%ecx)
801022d6:	8d 72 01             	lea    0x1(%edx),%esi
801022d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022e0:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
801022e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022ed:	75 d1                	jne    801022c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022f2:	5b                   	pop    %ebx
801022f3:	5e                   	pop    %esi
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	8d 76 00             	lea    0x0(%esi),%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102300 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102300:	55                   	push   %ebp
  ioapic->reg = reg;
80102301:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
{
80102307:	89 e5                	mov    %esp,%ebp
80102309:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010230c:	8d 50 20             	lea    0x20(%eax),%edx
8010230f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102313:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102315:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010231b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010231e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102321:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102324:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102326:	a1 a0 37 11 80       	mov    0x801137a0,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010232e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102331:	5d                   	pop    %ebp
80102332:	c3                   	ret    
80102333:	66 90                	xchg   %ax,%ax
80102335:	66 90                	xchg   %ax,%ax
80102337:	66 90                	xchg   %ax,%ax
80102339:	66 90                	xchg   %ax,%ax
8010233b:	66 90                	xchg   %ax,%ax
8010233d:	66 90                	xchg   %ax,%ax
8010233f:	90                   	nop

80102340 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 04             	sub    $0x4,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010234a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102350:	75 70                	jne    801023c2 <kfree+0x82>
80102352:	81 fb a8 35 12 80    	cmp    $0x801235a8,%ebx
80102358:	72 68                	jb     801023c2 <kfree+0x82>
8010235a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102360:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102365:	77 5b                	ja     801023c2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102367:	83 ec 04             	sub    $0x4,%esp
8010236a:	68 00 10 00 00       	push   $0x1000
8010236f:	6a 01                	push   $0x1
80102371:	53                   	push   %ebx
80102372:	e8 59 2e 00 00       	call   801051d0 <memset>

  if(kmem.use_lock)
80102377:	8b 15 f8 37 11 80    	mov    0x801137f8,%edx
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	85 d2                	test   %edx,%edx
80102382:	75 2c                	jne    801023b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102384:	a1 fc 37 11 80       	mov    0x801137fc,%eax
80102389:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010238b:	a1 f8 37 11 80       	mov    0x801137f8,%eax
  kmem.freelist = r;
80102390:	89 1d fc 37 11 80    	mov    %ebx,0x801137fc
  if(kmem.use_lock)
80102396:	85 c0                	test   %eax,%eax
80102398:	75 06                	jne    801023a0 <kfree+0x60>
    release(&kmem.lock);
}
8010239a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239d:	c9                   	leave  
8010239e:	c3                   	ret    
8010239f:	90                   	nop
    release(&kmem.lock);
801023a0:	c7 45 08 c0 37 11 80 	movl   $0x801137c0,0x8(%ebp)
}
801023a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023aa:	c9                   	leave  
    release(&kmem.lock);
801023ab:	e9 d0 2d 00 00       	jmp    80105180 <release>
    acquire(&kmem.lock);
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 c0 37 11 80       	push   $0x801137c0
801023b8:	e8 f3 2c 00 00       	call   801050b0 <acquire>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	eb c2                	jmp    80102384 <kfree+0x44>
    panic("kfree");
801023c2:	83 ec 0c             	sub    $0xc,%esp
801023c5:	68 66 7f 10 80       	push   $0x80107f66
801023ca:	e8 c1 df ff ff       	call   80100390 <panic>
801023cf:	90                   	nop

801023d0 <freerange>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ed:	39 de                	cmp    %ebx,%esi
801023ef:	72 23                	jb     80102414 <freerange+0x44>
801023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102401:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102407:	50                   	push   %eax
80102408:	e8 33 ff ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	39 f3                	cmp    %esi,%ebx
80102412:	76 e4                	jbe    801023f8 <freerange+0x28>
}
80102414:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102417:	5b                   	pop    %ebx
80102418:	5e                   	pop    %esi
80102419:	5d                   	pop    %ebp
8010241a:	c3                   	ret    
8010241b:	90                   	nop
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102420 <kinit1>:
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
80102425:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102428:	83 ec 08             	sub    $0x8,%esp
8010242b:	68 6c 7f 10 80       	push   $0x80107f6c
80102430:	68 c0 37 11 80       	push   $0x801137c0
80102435:	e8 36 2b 00 00       	call   80104f70 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102440:	c7 05 f8 37 11 80 00 	movl   $0x0,0x801137f8
80102447:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102450:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102456:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245c:	39 de                	cmp    %ebx,%esi
8010245e:	72 1c                	jb     8010247c <kinit1+0x5c>
    kfree(p);
80102460:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102466:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102469:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010246f:	50                   	push   %eax
80102470:	e8 cb fe ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102475:	83 c4 10             	add    $0x10,%esp
80102478:	39 de                	cmp    %ebx,%esi
8010247a:	73 e4                	jae    80102460 <kinit1+0x40>
}
8010247c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010247f:	5b                   	pop    %ebx
80102480:	5e                   	pop    %esi
80102481:	5d                   	pop    %ebp
80102482:	c3                   	ret    
80102483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kinit2>:
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102495:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102498:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010249b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ad:	39 de                	cmp    %ebx,%esi
801024af:	72 23                	jb     801024d4 <kinit2+0x44>
801024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024be:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024c7:	50                   	push   %eax
801024c8:	e8 73 fe ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	39 de                	cmp    %ebx,%esi
801024d2:	73 e4                	jae    801024b8 <kinit2+0x28>
  kmem.use_lock = 1;
801024d4:	c7 05 f8 37 11 80 01 	movl   $0x1,0x801137f8
801024db:	00 00 00 
}
801024de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e1:	5b                   	pop    %ebx
801024e2:	5e                   	pop    %esi
801024e3:	5d                   	pop    %ebp
801024e4:	c3                   	ret    
801024e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024f0:	a1 f8 37 11 80       	mov    0x801137f8,%eax
801024f5:	85 c0                	test   %eax,%eax
801024f7:	75 1f                	jne    80102518 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024f9:	a1 fc 37 11 80       	mov    0x801137fc,%eax
  if(r)
801024fe:	85 c0                	test   %eax,%eax
80102500:	74 0e                	je     80102510 <kalloc+0x20>
    kmem.freelist = r->next;
80102502:	8b 10                	mov    (%eax),%edx
80102504:	89 15 fc 37 11 80    	mov    %edx,0x801137fc
8010250a:	c3                   	ret    
8010250b:	90                   	nop
8010250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102510:	f3 c3                	repz ret 
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102518:	55                   	push   %ebp
80102519:	89 e5                	mov    %esp,%ebp
8010251b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010251e:	68 c0 37 11 80       	push   $0x801137c0
80102523:	e8 88 2b 00 00       	call   801050b0 <acquire>
  r = kmem.freelist;
80102528:	a1 fc 37 11 80       	mov    0x801137fc,%eax
  if(r)
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	8b 15 f8 37 11 80    	mov    0x801137f8,%edx
80102536:	85 c0                	test   %eax,%eax
80102538:	74 08                	je     80102542 <kalloc+0x52>
    kmem.freelist = r->next;
8010253a:	8b 08                	mov    (%eax),%ecx
8010253c:	89 0d fc 37 11 80    	mov    %ecx,0x801137fc
  if(kmem.use_lock)
80102542:	85 d2                	test   %edx,%edx
80102544:	74 16                	je     8010255c <kalloc+0x6c>
    release(&kmem.lock);
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010254c:	68 c0 37 11 80       	push   $0x801137c0
80102551:	e8 2a 2c 00 00       	call   80105180 <release>
  return (char*)r;
80102556:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102559:	83 c4 10             	add    $0x10,%esp
}
8010255c:	c9                   	leave  
8010255d:	c3                   	ret    
8010255e:	66 90                	xchg   %ax,%ax

80102560 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102560:	ba 64 00 00 00       	mov    $0x64,%edx
80102565:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102566:	a8 01                	test   $0x1,%al
80102568:	0f 84 c2 00 00 00    	je     80102630 <kbdgetc+0xd0>
8010256e:	ba 60 00 00 00       	mov    $0x60,%edx
80102573:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102574:	0f b6 d0             	movzbl %al,%edx
80102577:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx

  if(data == 0xE0){
8010257d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102583:	0f 84 7f 00 00 00    	je     80102608 <kbdgetc+0xa8>
{
80102589:	55                   	push   %ebp
8010258a:	89 e5                	mov    %esp,%ebp
8010258c:	53                   	push   %ebx
8010258d:	89 cb                	mov    %ecx,%ebx
8010258f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102592:	84 c0                	test   %al,%al
80102594:	78 4a                	js     801025e0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102596:	85 db                	test   %ebx,%ebx
80102598:	74 09                	je     801025a3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010259a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010259d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025a0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025a3:	0f b6 82 a0 80 10 80 	movzbl -0x7fef7f60(%edx),%eax
801025aa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ac:	0f b6 82 a0 7f 10 80 	movzbl -0x7fef8060(%edx),%eax
801025b3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025b5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025b7:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
  c = charcode[shift & (CTL | SHIFT)][data];
801025bd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025c0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c3:	8b 04 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%eax
801025ca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ce:	74 31                	je     80102601 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025d0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025d3:	83 fa 19             	cmp    $0x19,%edx
801025d6:	77 40                	ja     80102618 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025d8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025db:	5b                   	pop    %ebx
801025dc:	5d                   	pop    %ebp
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025e0:	83 e0 7f             	and    $0x7f,%eax
801025e3:	85 db                	test   %ebx,%ebx
801025e5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025e8:	0f b6 82 a0 80 10 80 	movzbl -0x7fef7f60(%edx),%eax
801025ef:	83 c8 40             	or     $0x40,%eax
801025f2:	0f b6 c0             	movzbl %al,%eax
801025f5:	f7 d0                	not    %eax
801025f7:	21 c1                	and    %eax,%ecx
    return 0;
801025f9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025fb:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
}
80102601:	5b                   	pop    %ebx
80102602:	5d                   	pop    %ebp
80102603:	c3                   	ret    
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102608:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010260b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010260d:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
    return 0;
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102618:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010261b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010261e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010261f:	83 f9 1a             	cmp    $0x1a,%ecx
80102622:	0f 42 c2             	cmovb  %edx,%eax
}
80102625:	5d                   	pop    %ebp
80102626:	c3                   	ret    
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102635:	c3                   	ret    
80102636:	8d 76 00             	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <kbdintr>:

void
kbdintr(void)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102646:	68 60 25 10 80       	push   $0x80102560
8010264b:	e8 c0 e1 ff ff       	call   80100810 <consoleintr>
}
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	c9                   	leave  
80102654:	c3                   	ret    
80102655:	66 90                	xchg   %ax,%ax
80102657:	66 90                	xchg   %ax,%ax
80102659:	66 90                	xchg   %ax,%ax
8010265b:	66 90                	xchg   %ax,%ax
8010265d:	66 90                	xchg   %ax,%ax
8010265f:	90                   	nop

80102660 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 00 38 11 80       	mov    0x80113800,%eax
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c8 00 00 00    	je     80102738 <lapicinit+0xd8>
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 77                	ja     80102740 <lapicinit+0xe0>
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	89 f6                	mov    %esi,%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102720:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102726:	80 e6 10             	and    $0x10,%dh
80102729:	75 f5                	jne    80102720 <lapicinit+0xc0>
  lapic[index] = value;
8010272b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102732:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102735:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102738:	5d                   	pop    %ebp
80102739:	c3                   	ret    
8010273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102740:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102747:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
8010274d:	e9 77 ff ff ff       	jmp    801026c9 <lapicinit+0x69>
80102752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102760:	8b 15 00 38 11 80    	mov    0x80113800,%edx
{
80102766:	55                   	push   %ebp
80102767:	31 c0                	xor    %eax,%eax
80102769:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010276b:	85 d2                	test   %edx,%edx
8010276d:	74 06                	je     80102775 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010276f:	8b 42 20             	mov    0x20(%edx),%eax
80102772:	c1 e8 18             	shr    $0x18,%eax
}
80102775:	5d                   	pop    %ebp
80102776:	c3                   	ret    
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102780:	a1 00 38 11 80       	mov    0x80113800,%eax
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027b6:	ba 70 00 00 00       	mov    $0x70,%edx
801027bb:	89 e5                	mov    %esp,%ebp
801027bd:	53                   	push   %ebx
801027be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	ba 71 00 00 00       	mov    $0x71,%edx
801027cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027d0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027dd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027e0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027e3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ee:	a1 00 38 11 80       	mov    0x80113800,%eax
801027f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102803:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102809:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102810:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102813:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102816:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010281f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102828:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010283a:	5b                   	pop    %ebx
8010283b:	5d                   	pop    %ebp
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	b8 0b 00 00 00       	mov    $0xb,%eax
80102846:	ba 70 00 00 00       	mov    $0x70,%edx
8010284b:	89 e5                	mov    %esp,%ebp
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	ba 71 00 00 00       	mov    $0x71,%edx
80102859:	ec                   	in     (%dx),%al
8010285a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010285d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102862:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102865:	8d 76 00             	lea    0x0(%esi),%esi
80102868:	31 c0                	xor    %eax,%eax
8010286a:	89 da                	mov    %ebx,%edx
8010286c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102872:	89 ca                	mov    %ecx,%edx
80102874:	ec                   	in     (%dx),%al
80102875:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	89 da                	mov    %ebx,%edx
8010287a:	b8 02 00 00 00       	mov    $0x2,%eax
8010287f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102880:	89 ca                	mov    %ecx,%edx
80102882:	ec                   	in     (%dx),%al
80102883:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102886:	89 da                	mov    %ebx,%edx
80102888:	b8 04 00 00 00       	mov    $0x4,%eax
8010288d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288e:	89 ca                	mov    %ecx,%edx
80102890:	ec                   	in     (%dx),%al
80102891:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102894:	89 da                	mov    %ebx,%edx
80102896:	b8 07 00 00 00       	mov    $0x7,%eax
8010289b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	89 ca                	mov    %ecx,%edx
8010289e:	ec                   	in     (%dx),%al
8010289f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a2:	89 da                	mov    %ebx,%edx
801028a4:	b8 08 00 00 00       	mov    $0x8,%eax
801028a9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028aa:	89 ca                	mov    %ecx,%edx
801028ac:	ec                   	in     (%dx),%al
801028ad:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028af:	89 da                	mov    %ebx,%edx
801028b1:	b8 09 00 00 00       	mov    $0x9,%eax
801028b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b7:	89 ca                	mov    %ecx,%edx
801028b9:	ec                   	in     (%dx),%al
801028ba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	b8 0a 00 00 00       	mov    $0xa,%eax
801028c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	89 ca                	mov    %ecx,%edx
801028c6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028c7:	84 c0                	test   %al,%al
801028c9:	78 9d                	js     80102868 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028cb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028cf:	89 fa                	mov    %edi,%edx
801028d1:	0f b6 fa             	movzbl %dl,%edi
801028d4:	89 f2                	mov    %esi,%edx
801028d6:	0f b6 f2             	movzbl %dl,%esi
801028d9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028dc:	89 da                	mov    %ebx,%edx
801028de:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028e1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028e4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028e8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028eb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ef:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028f2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028f9:	31 c0                	xor    %eax,%eax
801028fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fc:	89 ca                	mov    %ecx,%edx
801028fe:	ec                   	in     (%dx),%al
801028ff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102902:	89 da                	mov    %ebx,%edx
80102904:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102907:	b8 02 00 00 00       	mov    $0x2,%eax
8010290c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290d:	89 ca                	mov    %ecx,%edx
8010290f:	ec                   	in     (%dx),%al
80102910:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102913:	89 da                	mov    %ebx,%edx
80102915:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102918:	b8 04 00 00 00       	mov    $0x4,%eax
8010291d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291e:	89 ca                	mov    %ecx,%edx
80102920:	ec                   	in     (%dx),%al
80102921:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102924:	89 da                	mov    %ebx,%edx
80102926:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102929:	b8 07 00 00 00       	mov    $0x7,%eax
8010292e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292f:	89 ca                	mov    %ecx,%edx
80102931:	ec                   	in     (%dx),%al
80102932:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102935:	89 da                	mov    %ebx,%edx
80102937:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010293a:	b8 08 00 00 00       	mov    $0x8,%eax
8010293f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102940:	89 ca                	mov    %ecx,%edx
80102942:	ec                   	in     (%dx),%al
80102943:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102946:	89 da                	mov    %ebx,%edx
80102948:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010294b:	b8 09 00 00 00       	mov    $0x9,%eax
80102950:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102951:	89 ca                	mov    %ecx,%edx
80102953:	ec                   	in     (%dx),%al
80102954:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102957:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010295a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010295d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102960:	6a 18                	push   $0x18
80102962:	50                   	push   %eax
80102963:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102966:	50                   	push   %eax
80102967:	e8 b4 28 00 00       	call   80105220 <memcmp>
8010296c:	83 c4 10             	add    $0x10,%esp
8010296f:	85 c0                	test   %eax,%eax
80102971:	0f 85 f1 fe ff ff    	jne    80102868 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102977:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010297b:	75 78                	jne    801029f5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010297d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102980:	89 c2                	mov    %eax,%edx
80102982:	83 e0 0f             	and    $0xf,%eax
80102985:	c1 ea 04             	shr    $0x4,%edx
80102988:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102991:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102994:	89 c2                	mov    %eax,%edx
80102996:	83 e0 0f             	and    $0xf,%eax
80102999:	c1 ea 04             	shr    $0x4,%edx
8010299c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a8:	89 c2                	mov    %eax,%edx
801029aa:	83 e0 0f             	and    $0xf,%eax
801029ad:	c1 ea 04             	shr    $0x4,%edx
801029b0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029bc:	89 c2                	mov    %eax,%edx
801029be:	83 e0 0f             	and    $0xf,%eax
801029c1:	c1 ea 04             	shr    $0x4,%edx
801029c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029d0:	89 c2                	mov    %eax,%edx
801029d2:	83 e0 0f             	and    $0xf,%eax
801029d5:	c1 ea 04             	shr    $0x4,%edx
801029d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029db:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029de:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e4:	89 c2                	mov    %eax,%edx
801029e6:	83 e0 0f             	and    $0xf,%eax
801029e9:	c1 ea 04             	shr    $0x4,%edx
801029ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ef:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029f5:	8b 75 08             	mov    0x8(%ebp),%esi
801029f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029fb:	89 06                	mov    %eax,(%esi)
801029fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a00:	89 46 04             	mov    %eax,0x4(%esi)
80102a03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a06:	89 46 08             	mov    %eax,0x8(%esi)
80102a09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a12:	89 46 10             	mov    %eax,0x10(%esi)
80102a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a18:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a25:	5b                   	pop    %ebx
80102a26:	5e                   	pop    %esi
80102a27:	5f                   	pop    %edi
80102a28:	5d                   	pop    %ebp
80102a29:	c3                   	ret    
80102a2a:	66 90                	xchg   %ax,%ax
80102a2c:	66 90                	xchg   %ax,%ax
80102a2e:	66 90                	xchg   %ax,%ax

80102a30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a30:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
80102a36:	85 c9                	test   %ecx,%ecx
80102a38:	0f 8e 8a 00 00 00    	jle    80102ac8 <install_trans+0x98>
{
80102a3e:	55                   	push   %ebp
80102a3f:	89 e5                	mov    %esp,%ebp
80102a41:	57                   	push   %edi
80102a42:	56                   	push   %esi
80102a43:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a44:	31 db                	xor    %ebx,%ebx
{
80102a46:	83 ec 0c             	sub    $0xc,%esp
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a50:	a1 58 38 11 80       	mov    0x80113858,%eax
80102a55:	83 ec 08             	sub    $0x8,%esp
80102a58:	01 d8                	add    %ebx,%eax
80102a5a:	83 c0 01             	add    $0x1,%eax
80102a5d:	50                   	push   %eax
80102a5e:	ff 35 68 38 11 80    	pushl  0x80113868
80102a64:	e8 67 d6 ff ff       	call   801000d0 <bread>
80102a69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6b:	58                   	pop    %eax
80102a6c:	5a                   	pop    %edx
80102a6d:	ff 34 9d 70 38 11 80 	pushl  -0x7feec790(,%ebx,4)
80102a74:	ff 35 68 38 11 80    	pushl  0x80113868
  for (tail = 0; tail < log.lh.n; tail++) {
80102a7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7d:	e8 4e d6 ff ff       	call   801000d0 <bread>
80102a82:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a84:	8d 47 60             	lea    0x60(%edi),%eax
80102a87:	83 c4 0c             	add    $0xc,%esp
80102a8a:	68 00 02 00 00       	push   $0x200
80102a8f:	50                   	push   %eax
80102a90:	8d 46 60             	lea    0x60(%esi),%eax
80102a93:	50                   	push   %eax
80102a94:	e8 e7 27 00 00       	call   80105280 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 ff d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102aa1:	89 3c 24             	mov    %edi,(%esp)
80102aa4:	e8 37 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 2f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ab1:	83 c4 10             	add    $0x10,%esp
80102ab4:	39 1d 6c 38 11 80    	cmp    %ebx,0x8011386c
80102aba:	7f 94                	jg     80102a50 <install_trans+0x20>
  }
}
80102abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102abf:	5b                   	pop    %ebx
80102ac0:	5e                   	pop    %esi
80102ac1:	5f                   	pop    %edi
80102ac2:	5d                   	pop    %ebp
80102ac3:	c3                   	ret    
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ac8:	f3 c3                	repz ret 
80102aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ad0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ad5:	83 ec 08             	sub    $0x8,%esp
80102ad8:	ff 35 58 38 11 80    	pushl  0x80113858
80102ade:	ff 35 68 38 11 80    	pushl  0x80113868
80102ae4:	e8 e7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ae9:	8b 1d 6c 38 11 80    	mov    0x8011386c,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aef:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102af2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102af4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102af6:	89 58 60             	mov    %ebx,0x60(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102af9:	7e 16                	jle    80102b11 <write_head+0x41>
80102afb:	c1 e3 02             	shl    $0x2,%ebx
80102afe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b00:	8b 8a 70 38 11 80    	mov    -0x7feec790(%edx),%ecx
80102b06:	89 4c 16 64          	mov    %ecx,0x64(%esi,%edx,1)
80102b0a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b0d:	39 da                	cmp    %ebx,%edx
80102b0f:	75 ef                	jne    80102b00 <write_head+0x30>
  }
  bwrite(buf);
80102b11:	83 ec 0c             	sub    $0xc,%esp
80102b14:	56                   	push   %esi
80102b15:	e8 86 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b1a:	89 34 24             	mov    %esi,(%esp)
80102b1d:	e8 be d6 ff ff       	call   801001e0 <brelse>
}
80102b22:	83 c4 10             	add    $0x10,%esp
80102b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b28:	5b                   	pop    %ebx
80102b29:	5e                   	pop    %esi
80102b2a:	5d                   	pop    %ebp
80102b2b:	c3                   	ret    
80102b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b30 <initlog>:
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	53                   	push   %ebx
80102b34:	83 ec 2c             	sub    $0x2c,%esp
80102b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b3a:	68 a0 81 10 80       	push   $0x801081a0
80102b3f:	68 20 38 11 80       	push   $0x80113820
80102b44:	e8 27 24 00 00       	call   80104f70 <initlock>
  readsb(dev, &sb);
80102b49:	58                   	pop    %eax
80102b4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 9b e8 ff ff       	call   801013f0 <readsb>
  log.size = sb.nlog;
80102b55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b5b:	59                   	pop    %ecx
  log.dev = dev;
80102b5c:	89 1d 68 38 11 80    	mov    %ebx,0x80113868
  log.size = sb.nlog;
80102b62:	89 15 5c 38 11 80    	mov    %edx,0x8011385c
  log.start = sb.logstart;
80102b68:	a3 58 38 11 80       	mov    %eax,0x80113858
  struct buf *buf = bread(log.dev, log.start);
80102b6d:	5a                   	pop    %edx
80102b6e:	50                   	push   %eax
80102b6f:	53                   	push   %ebx
80102b70:	e8 5b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b75:	8b 58 60             	mov    0x60(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b78:	83 c4 10             	add    $0x10,%esp
80102b7b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b7d:	89 1d 6c 38 11 80    	mov    %ebx,0x8011386c
  for (i = 0; i < log.lh.n; i++) {
80102b83:	7e 1c                	jle    80102ba1 <initlog+0x71>
80102b85:	c1 e3 02             	shl    $0x2,%ebx
80102b88:	31 d2                	xor    %edx,%edx
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b90:	8b 4c 10 64          	mov    0x64(%eax,%edx,1),%ecx
80102b94:	83 c2 04             	add    $0x4,%edx
80102b97:	89 8a 6c 38 11 80    	mov    %ecx,-0x7feec794(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b9d:	39 d3                	cmp    %edx,%ebx
80102b9f:	75 ef                	jne    80102b90 <initlog+0x60>
  brelse(buf);
80102ba1:	83 ec 0c             	sub    $0xc,%esp
80102ba4:	50                   	push   %eax
80102ba5:	e8 36 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102baa:	e8 81 fe ff ff       	call   80102a30 <install_trans>
  log.lh.n = 0;
80102baf:	c7 05 6c 38 11 80 00 	movl   $0x0,0x8011386c
80102bb6:	00 00 00 
  write_head(); // clear the log
80102bb9:	e8 12 ff ff ff       	call   80102ad0 <write_head>
}
80102bbe:	83 c4 10             	add    $0x10,%esp
80102bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc4:	c9                   	leave  
80102bc5:	c3                   	ret    
80102bc6:	8d 76 00             	lea    0x0(%esi),%esi
80102bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bd6:	68 20 38 11 80       	push   $0x80113820
80102bdb:	e8 d0 24 00 00       	call   801050b0 <acquire>
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	eb 18                	jmp    80102bfd <begin_op+0x2d>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	83 ec 08             	sub    $0x8,%esp
80102beb:	68 20 38 11 80       	push   $0x80113820
80102bf0:	68 20 38 11 80       	push   $0x80113820
80102bf5:	e8 a6 13 00 00       	call   80103fa0 <sleep>
80102bfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bfd:	a1 64 38 11 80       	mov    0x80113864,%eax
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 e2                	jne    80102be8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c06:	a1 60 38 11 80       	mov    0x80113860,%eax
80102c0b:	8b 15 6c 38 11 80    	mov    0x8011386c,%edx
80102c11:	83 c0 01             	add    $0x1,%eax
80102c14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c1a:	83 fa 1e             	cmp    $0x1e,%edx
80102c1d:	7f c9                	jg     80102be8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c22:	a3 60 38 11 80       	mov    %eax,0x80113860
      release(&log.lock);
80102c27:	68 20 38 11 80       	push   $0x80113820
80102c2c:	e8 4f 25 00 00       	call   80105180 <release>
      break;
    }
  }
}
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	57                   	push   %edi
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c49:	68 20 38 11 80       	push   $0x80113820
80102c4e:	e8 5d 24 00 00       	call   801050b0 <acquire>
  log.outstanding -= 1;
80102c53:	a1 60 38 11 80       	mov    0x80113860,%eax
  if(log.committing)
80102c58:	8b 35 64 38 11 80    	mov    0x80113864,%esi
80102c5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c61:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c64:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c66:	89 1d 60 38 11 80    	mov    %ebx,0x80113860
  if(log.committing)
80102c6c:	0f 85 1a 01 00 00    	jne    80102d8c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c72:	85 db                	test   %ebx,%ebx
80102c74:	0f 85 ee 00 00 00    	jne    80102d68 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c7a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c7d:	c7 05 64 38 11 80 01 	movl   $0x1,0x80113864
80102c84:	00 00 00 
  release(&log.lock);
80102c87:	68 20 38 11 80       	push   $0x80113820
80102c8c:	e8 ef 24 00 00       	call   80105180 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c91:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
80102c97:	83 c4 10             	add    $0x10,%esp
80102c9a:	85 c9                	test   %ecx,%ecx
80102c9c:	0f 8e 85 00 00 00    	jle    80102d27 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca2:	a1 58 38 11 80       	mov    0x80113858,%eax
80102ca7:	83 ec 08             	sub    $0x8,%esp
80102caa:	01 d8                	add    %ebx,%eax
80102cac:	83 c0 01             	add    $0x1,%eax
80102caf:	50                   	push   %eax
80102cb0:	ff 35 68 38 11 80    	pushl  0x80113868
80102cb6:	e8 15 d4 ff ff       	call   801000d0 <bread>
80102cbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbd:	58                   	pop    %eax
80102cbe:	5a                   	pop    %edx
80102cbf:	ff 34 9d 70 38 11 80 	pushl  -0x7feec790(,%ebx,4)
80102cc6:	ff 35 68 38 11 80    	pushl  0x80113868
  for (tail = 0; tail < log.lh.n; tail++) {
80102ccc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccf:	e8 fc d3 ff ff       	call   801000d0 <bread>
80102cd4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cd6:	8d 40 60             	lea    0x60(%eax),%eax
80102cd9:	83 c4 0c             	add    $0xc,%esp
80102cdc:	68 00 02 00 00       	push   $0x200
80102ce1:	50                   	push   %eax
80102ce2:	8d 46 60             	lea    0x60(%esi),%eax
80102ce5:	50                   	push   %eax
80102ce6:	e8 95 25 00 00       	call   80105280 <memmove>
    bwrite(to);  // write the log
80102ceb:	89 34 24             	mov    %esi,(%esp)
80102cee:	e8 ad d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cf3:	89 3c 24             	mov    %edi,(%esp)
80102cf6:	e8 e5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 dd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d03:	83 c4 10             	add    $0x10,%esp
80102d06:	3b 1d 6c 38 11 80    	cmp    0x8011386c,%ebx
80102d0c:	7c 94                	jl     80102ca2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d0e:	e8 bd fd ff ff       	call   80102ad0 <write_head>
    install_trans(); // Now install writes to home locations
80102d13:	e8 18 fd ff ff       	call   80102a30 <install_trans>
    log.lh.n = 0;
80102d18:	c7 05 6c 38 11 80 00 	movl   $0x0,0x8011386c
80102d1f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d22:	e8 a9 fd ff ff       	call   80102ad0 <write_head>
    acquire(&log.lock);
80102d27:	83 ec 0c             	sub    $0xc,%esp
80102d2a:	68 20 38 11 80       	push   $0x80113820
80102d2f:	e8 7c 23 00 00       	call   801050b0 <acquire>
    wakeup(&log);
80102d34:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
    log.committing = 0;
80102d3b:	c7 05 64 38 11 80 00 	movl   $0x0,0x80113864
80102d42:	00 00 00 
    wakeup(&log);
80102d45:	e8 56 17 00 00       	call   801044a0 <wakeup>
    release(&log.lock);
80102d4a:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80102d51:	e8 2a 24 00 00       	call   80105180 <release>
80102d56:	83 c4 10             	add    $0x10,%esp
}
80102d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5c:	5b                   	pop    %ebx
80102d5d:	5e                   	pop    %esi
80102d5e:	5f                   	pop    %edi
80102d5f:	5d                   	pop    %ebp
80102d60:	c3                   	ret    
80102d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d68:	83 ec 0c             	sub    $0xc,%esp
80102d6b:	68 20 38 11 80       	push   $0x80113820
80102d70:	e8 2b 17 00 00       	call   801044a0 <wakeup>
  release(&log.lock);
80102d75:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80102d7c:	e8 ff 23 00 00       	call   80105180 <release>
80102d81:	83 c4 10             	add    $0x10,%esp
}
80102d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d87:	5b                   	pop    %ebx
80102d88:	5e                   	pop    %esi
80102d89:	5f                   	pop    %edi
80102d8a:	5d                   	pop    %ebp
80102d8b:	c3                   	ret    
    panic("log.committing");
80102d8c:	83 ec 0c             	sub    $0xc,%esp
80102d8f:	68 a4 81 10 80       	push   $0x801081a4
80102d94:	e8 f7 d5 ff ff       	call   80100390 <panic>
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102da0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da7:	8b 15 6c 38 11 80    	mov    0x8011386c,%edx
{
80102dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db0:	83 fa 1d             	cmp    $0x1d,%edx
80102db3:	0f 8f 9d 00 00 00    	jg     80102e56 <log_write+0xb6>
80102db9:	a1 5c 38 11 80       	mov    0x8011385c,%eax
80102dbe:	83 e8 01             	sub    $0x1,%eax
80102dc1:	39 c2                	cmp    %eax,%edx
80102dc3:	0f 8d 8d 00 00 00    	jge    80102e56 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dc9:	a1 60 38 11 80       	mov    0x80113860,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	0f 8e 8d 00 00 00    	jle    80102e63 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	68 20 38 11 80       	push   $0x80113820
80102dde:	e8 cd 22 00 00       	call   801050b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102de3:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	83 f9 00             	cmp    $0x0,%ecx
80102def:	7e 57                	jle    80102e48 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102df4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df6:	3b 15 70 38 11 80    	cmp    0x80113870,%edx
80102dfc:	75 0b                	jne    80102e09 <log_write+0x69>
80102dfe:	eb 38                	jmp    80102e38 <log_write+0x98>
80102e00:	39 14 85 70 38 11 80 	cmp    %edx,-0x7feec790(,%eax,4)
80102e07:	74 2f                	je     80102e38 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e09:	83 c0 01             	add    $0x1,%eax
80102e0c:	39 c1                	cmp    %eax,%ecx
80102e0e:	75 f0                	jne    80102e00 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e10:	89 14 85 70 38 11 80 	mov    %edx,-0x7feec790(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e17:	83 c0 01             	add    $0x1,%eax
80102e1a:	a3 6c 38 11 80       	mov    %eax,0x8011386c
  b->flags |= B_DIRTY; // prevent eviction
80102e1f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e22:	c7 45 08 20 38 11 80 	movl   $0x80113820,0x8(%ebp)
}
80102e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2c:	c9                   	leave  
  release(&log.lock);
80102e2d:	e9 4e 23 00 00       	jmp    80105180 <release>
80102e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e38:	89 14 85 70 38 11 80 	mov    %edx,-0x7feec790(,%eax,4)
80102e3f:	eb de                	jmp    80102e1f <log_write+0x7f>
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e48:	8b 43 08             	mov    0x8(%ebx),%eax
80102e4b:	a3 70 38 11 80       	mov    %eax,0x80113870
  if (i == log.lh.n)
80102e50:	75 cd                	jne    80102e1f <log_write+0x7f>
80102e52:	31 c0                	xor    %eax,%eax
80102e54:	eb c1                	jmp    80102e17 <log_write+0x77>
    panic("too big a transaction");
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	68 b3 81 10 80       	push   $0x801081b3
80102e5e:	e8 2d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e63:	83 ec 0c             	sub    $0xc,%esp
80102e66:	68 c9 81 10 80       	push   $0x801081c9
80102e6b:	e8 20 d5 ff ff       	call   80100390 <panic>

80102e70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e77:	e8 74 0a 00 00       	call   801038f0 <cpuid>
80102e7c:	89 c3                	mov    %eax,%ebx
80102e7e:	e8 6d 0a 00 00       	call   801038f0 <cpuid>
80102e83:	83 ec 04             	sub    $0x4,%esp
80102e86:	53                   	push   %ebx
80102e87:	50                   	push   %eax
80102e88:	68 e4 81 10 80       	push   $0x801081e4
80102e8d:	e8 ce d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e92:	e8 79 36 00 00       	call   80106510 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e97:	e8 d4 09 00 00       	call   80103870 <mycpu>
80102e9c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e9e:	b8 01 00 00 00       	mov    $0x1,%eax
80102ea3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eaa:	e8 b1 0e 00 00       	call   80103d60 <scheduler>
80102eaf:	90                   	nop

80102eb0 <mpenter>:
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102eb6:	e8 45 47 00 00       	call   80107600 <switchkvm>
  seginit();
80102ebb:	e8 b0 46 00 00       	call   80107570 <seginit>
  lapicinit();
80102ec0:	e8 9b f7 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102ec5:	e8 a6 ff ff ff       	call   80102e70 <mpmain>
80102eca:	66 90                	xchg   %ax,%ax
80102ecc:	66 90                	xchg   %ax,%ax
80102ece:	66 90                	xchg   %ax,%ax

80102ed0 <main>:
{
80102ed0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ed4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ed7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eda:	55                   	push   %ebp
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	53                   	push   %ebx
80102ede:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102edf:	83 ec 08             	sub    $0x8,%esp
80102ee2:	68 00 00 40 80       	push   $0x80400000
80102ee7:	68 a8 35 12 80       	push   $0x801235a8
80102eec:	e8 2f f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102ef1:	e8 ea 4b 00 00       	call   80107ae0 <kvmalloc>
  mpinit();        // detect other processors
80102ef6:	e8 75 01 00 00       	call   80103070 <mpinit>
  lapicinit();     // interrupt controller
80102efb:	e8 60 f7 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102f00:	e8 6b 46 00 00       	call   80107570 <seginit>
  picinit();       // disable pic
80102f05:	e8 46 03 00 00       	call   80103250 <picinit>
  ioapicinit();    // another interrupt controller
80102f0a:	e8 41 f3 ff ff       	call   80102250 <ioapicinit>
  consoleinit();   // console hardware
80102f0f:	e8 ac da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f14:	e8 27 39 00 00       	call   80106840 <uartinit>
  pinit();         // process table
80102f19:	e8 a2 08 00 00       	call   801037c0 <pinit>
  tvinit();        // trap vectors
80102f1e:	e8 6d 35 00 00       	call   80106490 <tvinit>
  binit();         // buffer cache
80102f23:	e8 18 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f28:	e8 53 de ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
80102f2d:	e8 fe f0 ff ff       	call   80102030 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f32:	83 c4 0c             	add    $0xc,%esp
80102f35:	68 8a 00 00 00       	push   $0x8a
80102f3a:	68 8c b4 10 80       	push   $0x8010b48c
80102f3f:	68 00 70 00 80       	push   $0x80007000
80102f44:	e8 37 23 00 00       	call   80105280 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f49:	69 05 c0 3e 11 80 b4 	imul   $0xb4,0x80113ec0,%eax
80102f50:	00 00 00 
80102f53:	83 c4 10             	add    $0x10,%esp
80102f56:	05 20 39 11 80       	add    $0x80113920,%eax
80102f5b:	3d 20 39 11 80       	cmp    $0x80113920,%eax
80102f60:	76 71                	jbe    80102fd3 <main+0x103>
80102f62:	bb 20 39 11 80       	mov    $0x80113920,%ebx
80102f67:	89 f6                	mov    %esi,%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f70:	e8 fb 08 00 00       	call   80103870 <mycpu>
80102f75:	39 d8                	cmp    %ebx,%eax
80102f77:	74 41                	je     80102fba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f79:	e8 72 f5 ff ff       	call   801024f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f7e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f83:	c7 05 f8 6f 00 80 b0 	movl   $0x80102eb0,0x80006ff8
80102f8a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f8d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f94:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f97:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f9c:	0f b6 03             	movzbl (%ebx),%eax
80102f9f:	83 ec 08             	sub    $0x8,%esp
80102fa2:	68 00 70 00 00       	push   $0x7000
80102fa7:	50                   	push   %eax
80102fa8:	e8 03 f8 ff ff       	call   801027b0 <lapicstartap>
80102fad:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fb0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	74 f6                	je     80102fb0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fba:	69 05 c0 3e 11 80 b4 	imul   $0xb4,0x80113ec0,%eax
80102fc1:	00 00 00 
80102fc4:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80102fca:	05 20 39 11 80       	add    $0x80113920,%eax
80102fcf:	39 c3                	cmp    %eax,%ebx
80102fd1:	72 9d                	jb     80102f70 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fd3:	83 ec 08             	sub    $0x8,%esp
80102fd6:	68 00 00 00 8e       	push   $0x8e000000
80102fdb:	68 00 00 40 80       	push   $0x80400000
80102fe0:	e8 ab f4 ff ff       	call   80102490 <kinit2>
  userinit();      // first user process
80102fe5:	e8 86 09 00 00       	call   80103970 <userinit>
  mpmain();        // finish this processor's setup
80102fea:	e8 81 fe ff ff       	call   80102e70 <mpmain>
80102fef:	90                   	nop

80102ff0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ff5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102ffb:	53                   	push   %ebx
  e = addr+len;
80102ffc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103002:	39 de                	cmp    %ebx,%esi
80103004:	72 10                	jb     80103016 <mpsearch1+0x26>
80103006:	eb 50                	jmp    80103058 <mpsearch1+0x68>
80103008:	90                   	nop
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103010:	39 fb                	cmp    %edi,%ebx
80103012:	89 fe                	mov    %edi,%esi
80103014:	76 42                	jbe    80103058 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103016:	83 ec 04             	sub    $0x4,%esp
80103019:	8d 7e 10             	lea    0x10(%esi),%edi
8010301c:	6a 04                	push   $0x4
8010301e:	68 f8 81 10 80       	push   $0x801081f8
80103023:	56                   	push   %esi
80103024:	e8 f7 21 00 00       	call   80105220 <memcmp>
80103029:	83 c4 10             	add    $0x10,%esp
8010302c:	85 c0                	test   %eax,%eax
8010302e:	75 e0                	jne    80103010 <mpsearch1+0x20>
80103030:	89 f1                	mov    %esi,%ecx
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103038:	0f b6 11             	movzbl (%ecx),%edx
8010303b:	83 c1 01             	add    $0x1,%ecx
8010303e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103040:	39 f9                	cmp    %edi,%ecx
80103042:	75 f4                	jne    80103038 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103044:	84 c0                	test   %al,%al
80103046:	75 c8                	jne    80103010 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304b:	89 f0                	mov    %esi,%eax
8010304d:	5b                   	pop    %ebx
8010304e:	5e                   	pop    %esi
8010304f:	5f                   	pop    %edi
80103050:	5d                   	pop    %ebp
80103051:	c3                   	ret    
80103052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010305b:	31 f6                	xor    %esi,%esi
}
8010305d:	89 f0                	mov    %esi,%eax
8010305f:	5b                   	pop    %ebx
80103060:	5e                   	pop    %esi
80103061:	5f                   	pop    %edi
80103062:	5d                   	pop    %ebp
80103063:	c3                   	ret    
80103064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010306a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103070 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103079:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103080:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103087:	c1 e0 08             	shl    $0x8,%eax
8010308a:	09 d0                	or     %edx,%eax
8010308c:	c1 e0 04             	shl    $0x4,%eax
8010308f:	85 c0                	test   %eax,%eax
80103091:	75 1b                	jne    801030ae <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103093:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010309a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030a1:	c1 e0 08             	shl    $0x8,%eax
801030a4:	09 d0                	or     %edx,%eax
801030a6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030a9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030ae:	ba 00 04 00 00       	mov    $0x400,%edx
801030b3:	e8 38 ff ff ff       	call   80102ff0 <mpsearch1>
801030b8:	85 c0                	test   %eax,%eax
801030ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030bd:	0f 84 3d 01 00 00    	je     80103200 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030c6:	8b 58 04             	mov    0x4(%eax),%ebx
801030c9:	85 db                	test   %ebx,%ebx
801030cb:	0f 84 4f 01 00 00    	je     80103220 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030d1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030d7:	83 ec 04             	sub    $0x4,%esp
801030da:	6a 04                	push   $0x4
801030dc:	68 15 82 10 80       	push   $0x80108215
801030e1:	56                   	push   %esi
801030e2:	e8 39 21 00 00       	call   80105220 <memcmp>
801030e7:	83 c4 10             	add    $0x10,%esp
801030ea:	85 c0                	test   %eax,%eax
801030ec:	0f 85 2e 01 00 00    	jne    80103220 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030f2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030f9:	3c 01                	cmp    $0x1,%al
801030fb:	0f 95 c2             	setne  %dl
801030fe:	3c 04                	cmp    $0x4,%al
80103100:	0f 95 c0             	setne  %al
80103103:	20 c2                	and    %al,%dl
80103105:	0f 85 15 01 00 00    	jne    80103220 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010310b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103112:	66 85 ff             	test   %di,%di
80103115:	74 1a                	je     80103131 <mpinit+0xc1>
80103117:	89 f0                	mov    %esi,%eax
80103119:	01 f7                	add    %esi,%edi
  sum = 0;
8010311b:	31 d2                	xor    %edx,%edx
8010311d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103120:	0f b6 08             	movzbl (%eax),%ecx
80103123:	83 c0 01             	add    $0x1,%eax
80103126:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103128:	39 c7                	cmp    %eax,%edi
8010312a:	75 f4                	jne    80103120 <mpinit+0xb0>
8010312c:	84 d2                	test   %dl,%dl
8010312e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103131:	85 f6                	test   %esi,%esi
80103133:	0f 84 e7 00 00 00    	je     80103220 <mpinit+0x1b0>
80103139:	84 d2                	test   %dl,%dl
8010313b:	0f 85 df 00 00 00    	jne    80103220 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103141:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103147:	a3 00 38 11 80       	mov    %eax,0x80113800
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010314c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103153:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103159:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315e:	01 d6                	add    %edx,%esi
80103160:	39 c6                	cmp    %eax,%esi
80103162:	76 23                	jbe    80103187 <mpinit+0x117>
    switch(*p){
80103164:	0f b6 10             	movzbl (%eax),%edx
80103167:	80 fa 04             	cmp    $0x4,%dl
8010316a:	0f 87 ca 00 00 00    	ja     8010323a <mpinit+0x1ca>
80103170:	ff 24 95 3c 82 10 80 	jmp    *-0x7fef7dc4(,%edx,4)
80103177:	89 f6                	mov    %esi,%esi
80103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103180:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103183:	39 c6                	cmp    %eax,%esi
80103185:	77 dd                	ja     80103164 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103187:	85 db                	test   %ebx,%ebx
80103189:	0f 84 9e 00 00 00    	je     8010322d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010318f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103192:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103196:	74 15                	je     801031ad <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103198:	b8 70 00 00 00       	mov    $0x70,%eax
8010319d:	ba 22 00 00 00       	mov    $0x22,%edx
801031a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031a3:	ba 23 00 00 00       	mov    $0x23,%edx
801031a8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031a9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ac:	ee                   	out    %al,(%dx)
  }
}
801031ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031b0:	5b                   	pop    %ebx
801031b1:	5e                   	pop    %esi
801031b2:	5f                   	pop    %edi
801031b3:	5d                   	pop    %ebp
801031b4:	c3                   	ret    
801031b5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031b8:	8b 0d c0 3e 11 80    	mov    0x80113ec0,%ecx
801031be:	83 f9 07             	cmp    $0x7,%ecx
801031c1:	7f 19                	jg     801031dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031c7:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
801031cd:	83 c1 01             	add    $0x1,%ecx
801031d0:	89 0d c0 3e 11 80    	mov    %ecx,0x80113ec0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d6:	88 97 20 39 11 80    	mov    %dl,-0x7feec6e0(%edi)
      p += sizeof(struct mpproc);
801031dc:	83 c0 14             	add    $0x14,%eax
      continue;
801031df:	e9 7c ff ff ff       	jmp    80103160 <mpinit+0xf0>
801031e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031ec:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ef:	88 15 00 39 11 80    	mov    %dl,0x80113900
      continue;
801031f5:	e9 66 ff ff ff       	jmp    80103160 <mpinit+0xf0>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103200:	ba 00 00 01 00       	mov    $0x10000,%edx
80103205:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010320a:	e8 e1 fd ff ff       	call   80102ff0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010320f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103211:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103214:	0f 85 a9 fe ff ff    	jne    801030c3 <mpinit+0x53>
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103220:	83 ec 0c             	sub    $0xc,%esp
80103223:	68 fd 81 10 80       	push   $0x801081fd
80103228:	e8 63 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 1c 82 10 80       	push   $0x8010821c
80103235:	e8 56 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010323a:	31 db                	xor    %ebx,%ebx
8010323c:	e9 26 ff ff ff       	jmp    80103167 <mpinit+0xf7>
80103241:	66 90                	xchg   %ax,%ax
80103243:	66 90                	xchg   %ax,%ax
80103245:	66 90                	xchg   %ax,%ax
80103247:	66 90                	xchg   %ax,%ax
80103249:	66 90                	xchg   %ax,%ax
8010324b:	66 90                	xchg   %ax,%ax
8010324d:	66 90                	xchg   %ax,%ax
8010324f:	90                   	nop

80103250 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103250:	55                   	push   %ebp
80103251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103256:	ba 21 00 00 00       	mov    $0x21,%edx
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	ee                   	out    %al,(%dx)
8010325e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103263:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103264:	5d                   	pop    %ebp
80103265:	c3                   	ret    
80103266:	66 90                	xchg   %ax,%ax
80103268:	66 90                	xchg   %ax,%ax
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010327f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010328b:	e8 10 db ff ff       	call   80100da0 <filealloc>
80103290:	85 c0                	test   %eax,%eax
80103292:	89 03                	mov    %eax,(%ebx)
80103294:	74 22                	je     801032b8 <pipealloc+0x48>
80103296:	e8 05 db ff ff       	call   80100da0 <filealloc>
8010329b:	85 c0                	test   %eax,%eax
8010329d:	89 06                	mov    %eax,(%esi)
8010329f:	74 3f                	je     801032e0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032a1:	e8 4a f2 ff ff       	call   801024f0 <kalloc>
801032a6:	85 c0                	test   %eax,%eax
801032a8:	89 c7                	mov    %eax,%edi
801032aa:	75 54                	jne    80103300 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032ac:	8b 03                	mov    (%ebx),%eax
801032ae:	85 c0                	test   %eax,%eax
801032b0:	75 34                	jne    801032e6 <pipealloc+0x76>
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032b8:	8b 06                	mov    (%esi),%eax
801032ba:	85 c0                	test   %eax,%eax
801032bc:	74 0c                	je     801032ca <pipealloc+0x5a>
    fileclose(*f1);
801032be:	83 ec 0c             	sub    $0xc,%esp
801032c1:	50                   	push   %eax
801032c2:	e8 99 db ff ff       	call   80100e60 <fileclose>
801032c7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032d2:	5b                   	pop    %ebx
801032d3:	5e                   	pop    %esi
801032d4:	5f                   	pop    %edi
801032d5:	5d                   	pop    %ebp
801032d6:	c3                   	ret    
801032d7:	89 f6                	mov    %esi,%esi
801032d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032e0:	8b 03                	mov    (%ebx),%eax
801032e2:	85 c0                	test   %eax,%eax
801032e4:	74 e4                	je     801032ca <pipealloc+0x5a>
    fileclose(*f0);
801032e6:	83 ec 0c             	sub    $0xc,%esp
801032e9:	50                   	push   %eax
801032ea:	e8 71 db ff ff       	call   80100e60 <fileclose>
  if(*f1)
801032ef:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032f1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032f4:	85 c0                	test   %eax,%eax
801032f6:	75 c6                	jne    801032be <pipealloc+0x4e>
801032f8:	eb d0                	jmp    801032ca <pipealloc+0x5a>
801032fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103300:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103303:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010330a:	00 00 00 
  p->writeopen = 1;
8010330d:	c7 80 44 02 00 00 01 	movl   $0x1,0x244(%eax)
80103314:	00 00 00 
  p->nwrite = 0;
80103317:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010331e:	00 00 00 
  p->nread = 0;
80103321:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103328:	00 00 00 
  initlock(&p->lock, "pipe");
8010332b:	68 50 82 10 80       	push   $0x80108250
80103330:	50                   	push   %eax
80103331:	e8 3a 1c 00 00       	call   80104f70 <initlock>
  (*f0)->type = FD_PIPE;
80103336:	8b 03                	mov    (%ebx),%eax
  return 0;
80103338:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010333b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103341:	8b 03                	mov    (%ebx),%eax
80103343:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103347:	8b 03                	mov    (%ebx),%eax
80103349:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010334d:	8b 03                	mov    (%ebx),%eax
8010334f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103352:	8b 06                	mov    (%esi),%eax
80103354:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010335a:	8b 06                	mov    (%esi),%eax
8010335c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103360:	8b 06                	mov    (%esi),%eax
80103362:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103366:	8b 06                	mov    (%esi),%eax
80103368:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010336b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010336e:	31 c0                	xor    %eax,%eax
}
80103370:	5b                   	pop    %ebx
80103371:	5e                   	pop    %esi
80103372:	5f                   	pop    %edi
80103373:	5d                   	pop    %ebp
80103374:	c3                   	ret    
80103375:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103380 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	56                   	push   %esi
80103384:	53                   	push   %ebx
80103385:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103388:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010338b:	83 ec 0c             	sub    $0xc,%esp
8010338e:	53                   	push   %ebx
8010338f:	e8 1c 1d 00 00       	call   801050b0 <acquire>
  if(writable){
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 f6                	test   %esi,%esi
80103399:	74 45                	je     801033e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010339b:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033a1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033a4:	c7 83 44 02 00 00 00 	movl   $0x0,0x244(%ebx)
801033ab:	00 00 00 
    wakeup(&p->nread);
801033ae:	50                   	push   %eax
801033af:	e8 ec 10 00 00       	call   801044a0 <wakeup>
801033b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033b7:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801033bd:	85 d2                	test   %edx,%edx
801033bf:	75 0a                	jne    801033cb <pipeclose+0x4b>
801033c1:	8b 83 44 02 00 00    	mov    0x244(%ebx),%eax
801033c7:	85 c0                	test   %eax,%eax
801033c9:	74 35                	je     80103400 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033d1:	5b                   	pop    %ebx
801033d2:	5e                   	pop    %esi
801033d3:	5d                   	pop    %ebp
    release(&p->lock);
801033d4:	e9 a7 1d 00 00       	jmp    80105180 <release>
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033e0:	8d 83 3c 02 00 00    	lea    0x23c(%ebx),%eax
801033e6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033e9:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033f0:	00 00 00 
    wakeup(&p->nwrite);
801033f3:	50                   	push   %eax
801033f4:	e8 a7 10 00 00       	call   801044a0 <wakeup>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	eb b9                	jmp    801033b7 <pipeclose+0x37>
801033fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	53                   	push   %ebx
80103404:	e8 77 1d 00 00       	call   80105180 <release>
    kfree((char*)p);
80103409:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010340c:	83 c4 10             	add    $0x10,%esp
}
8010340f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103412:	5b                   	pop    %ebx
80103413:	5e                   	pop    %esi
80103414:	5d                   	pop    %ebp
    kfree((char*)p);
80103415:	e9 26 ef ff ff       	jmp    80102340 <kfree>
8010341a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103420 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 28             	sub    $0x28,%esp
80103429:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010342c:	53                   	push   %ebx
8010342d:	e8 7e 1c 00 00       	call   801050b0 <acquire>
  for(i = 0; i < n; i++){
80103432:	8b 45 10             	mov    0x10(%ebp),%eax
80103435:	83 c4 10             	add    $0x10,%esp
80103438:	85 c0                	test   %eax,%eax
8010343a:	0f 8e c9 00 00 00    	jle    80103509 <pipewrite+0xe9>
80103440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103443:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103449:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
8010344f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103452:	03 4d 10             	add    0x10(%ebp),%ecx
80103455:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103458:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
8010345e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103464:	39 d0                	cmp    %edx,%eax
80103466:	75 71                	jne    801034d9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103468:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010346e:	85 c0                	test   %eax,%eax
80103470:	74 4e                	je     801034c0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103472:	8d b3 3c 02 00 00    	lea    0x23c(%ebx),%esi
80103478:	eb 3a                	jmp    801034b4 <pipewrite+0x94>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	57                   	push   %edi
80103484:	e8 17 10 00 00       	call   801044a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103489:	5a                   	pop    %edx
8010348a:	59                   	pop    %ecx
8010348b:	53                   	push   %ebx
8010348c:	56                   	push   %esi
8010348d:	e8 0e 0b 00 00       	call   80103fa0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103492:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103498:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010349e:	83 c4 10             	add    $0x10,%esp
801034a1:	05 00 02 00 00       	add    $0x200,%eax
801034a6:	39 c2                	cmp    %eax,%edx
801034a8:	75 36                	jne    801034e0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034aa:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034b0:	85 c0                	test   %eax,%eax
801034b2:	74 0c                	je     801034c0 <pipewrite+0xa0>
801034b4:	e8 57 04 00 00       	call   80103910 <myproc>
801034b9:	8b 40 1c             	mov    0x1c(%eax),%eax
801034bc:	85 c0                	test   %eax,%eax
801034be:	74 c0                	je     80103480 <pipewrite+0x60>
        release(&p->lock);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	53                   	push   %ebx
801034c4:	e8 b7 1c 00 00       	call   80105180 <release>
        return -1;
801034c9:	83 c4 10             	add    $0x10,%esp
801034cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034d4:	5b                   	pop    %ebx
801034d5:	5e                   	pop    %esi
801034d6:	5f                   	pop    %edi
801034d7:	5d                   	pop    %ebp
801034d8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d9:	89 c2                	mov    %eax,%edx
801034db:	90                   	nop
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034e3:	8d 42 01             	lea    0x1(%edx),%eax
801034e6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034ec:	89 83 3c 02 00 00    	mov    %eax,0x23c(%ebx)
801034f2:	83 c6 01             	add    $0x1,%esi
801034f5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034f9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034fc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034ff:	88 4c 13 38          	mov    %cl,0x38(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103503:	0f 85 4f ff ff ff    	jne    80103458 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103509:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	50                   	push   %eax
80103513:	e8 88 0f 00 00       	call   801044a0 <wakeup>
  release(&p->lock);
80103518:	89 1c 24             	mov    %ebx,(%esp)
8010351b:	e8 60 1c 00 00       	call   80105180 <release>
  return n;
80103520:	83 c4 10             	add    $0x10,%esp
80103523:	8b 45 10             	mov    0x10(%ebp),%eax
80103526:	eb a9                	jmp    801034d1 <pipewrite+0xb1>
80103528:	90                   	nop
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103530 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 18             	sub    $0x18,%esp
80103539:	8b 75 08             	mov    0x8(%ebp),%esi
8010353c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010353f:	56                   	push   %esi
80103540:	e8 6b 1b 00 00       	call   801050b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103545:	83 c4 10             	add    $0x10,%esp
80103548:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
8010354e:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
80103554:	75 6a                	jne    801035c0 <piperead+0x90>
80103556:	8b 9e 44 02 00 00    	mov    0x244(%esi),%ebx
8010355c:	85 db                	test   %ebx,%ebx
8010355e:	0f 84 c4 00 00 00    	je     80103628 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103564:	8d 9e 38 02 00 00    	lea    0x238(%esi),%ebx
8010356a:	eb 2d                	jmp    80103599 <piperead+0x69>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103570:	83 ec 08             	sub    $0x8,%esp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	e8 26 0a 00 00       	call   80103fa0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010357a:	83 c4 10             	add    $0x10,%esp
8010357d:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
80103583:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
80103589:	75 35                	jne    801035c0 <piperead+0x90>
8010358b:	8b 96 44 02 00 00    	mov    0x244(%esi),%edx
80103591:	85 d2                	test   %edx,%edx
80103593:	0f 84 8f 00 00 00    	je     80103628 <piperead+0xf8>
    if(myproc()->killed){
80103599:	e8 72 03 00 00       	call   80103910 <myproc>
8010359e:	8b 48 1c             	mov    0x1c(%eax),%ecx
801035a1:	85 c9                	test   %ecx,%ecx
801035a3:	74 cb                	je     80103570 <piperead+0x40>
      release(&p->lock);
801035a5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035a8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035ad:	56                   	push   %esi
801035ae:	e8 cd 1b 00 00       	call   80105180 <release>
      return -1;
801035b3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b9:	89 d8                	mov    %ebx,%eax
801035bb:	5b                   	pop    %ebx
801035bc:	5e                   	pop    %esi
801035bd:	5f                   	pop    %edi
801035be:	5d                   	pop    %ebp
801035bf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c0:	8b 45 10             	mov    0x10(%ebp),%eax
801035c3:	85 c0                	test   %eax,%eax
801035c5:	7e 61                	jle    80103628 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035c7:	31 db                	xor    %ebx,%ebx
801035c9:	eb 13                	jmp    801035de <piperead+0xae>
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035d0:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
801035d6:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
801035dc:	74 1f                	je     801035fd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035de:	8d 41 01             	lea    0x1(%ecx),%eax
801035e1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035e7:	89 86 38 02 00 00    	mov    %eax,0x238(%esi)
801035ed:	0f b6 44 0e 38       	movzbl 0x38(%esi,%ecx,1),%eax
801035f2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f5:	83 c3 01             	add    $0x1,%ebx
801035f8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035fb:	75 d3                	jne    801035d0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035fd:	8d 86 3c 02 00 00    	lea    0x23c(%esi),%eax
80103603:	83 ec 0c             	sub    $0xc,%esp
80103606:	50                   	push   %eax
80103607:	e8 94 0e 00 00       	call   801044a0 <wakeup>
  release(&p->lock);
8010360c:	89 34 24             	mov    %esi,(%esp)
8010360f:	e8 6c 1b 00 00       	call   80105180 <release>
  return i;
80103614:	83 c4 10             	add    $0x10,%esp
}
80103617:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010361a:	89 d8                	mov    %ebx,%eax
8010361c:	5b                   	pop    %ebx
8010361d:	5e                   	pop    %esi
8010361e:	5f                   	pop    %edi
8010361f:	5d                   	pop    %ebp
80103620:	c3                   	ret    
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103628:	31 db                	xor    %ebx,%ebx
8010362a:	eb d1                	jmp    801035fd <piperead+0xcd>
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
    if (DEBUGMODE > 0)
80103630:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
allocproc(void) {
80103635:	55                   	push   %ebp
80103636:	89 e5                	mov    %esp,%ebp
80103638:	56                   	push   %esi
80103639:	53                   	push   %ebx
    if (DEBUGMODE > 0)
8010363a:	85 c0                	test   %eax,%eax
8010363c:	7e 10                	jle    8010364e <allocproc+0x1e>
        cprintf(" ALLOCPROC ");
8010363e:	83 ec 0c             	sub    $0xc,%esp
80103641:	68 55 82 10 80       	push   $0x80108255
80103646:	e8 15 d0 ff ff       	call   80100660 <cprintf>
8010364b:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    char *sp;
    ptable.lock.name = "ALLOC";
    acquire(&ptable.lock);
8010364e:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "ALLOC";
80103651:	c7 05 24 4e 11 80 61 	movl   $0x80108261,0x80114e24
80103658:	82 10 80 
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010365b:	bb 58 4e 11 80       	mov    $0x80114e58,%ebx
    acquire(&ptable.lock);
80103660:	68 20 4e 11 80       	push   $0x80114e20
80103665:	e8 46 1a 00 00       	call   801050b0 <acquire>
8010366a:	83 c4 10             	add    $0x10,%esp
8010366d:	eb 0f                	jmp    8010367e <allocproc+0x4e>
8010366f:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103670:	81 c3 7c 03 00 00    	add    $0x37c,%ebx
80103676:	81 fb 58 2d 12 80    	cmp    $0x80122d58,%ebx
8010367c:	73 40                	jae    801036be <allocproc+0x8e>
        if (p->state == UNUSED)
8010367e:	8b 73 08             	mov    0x8(%ebx),%esi
80103681:	85 f6                	test   %esi,%esi
80103683:	75 eb                	jne    80103670 <allocproc+0x40>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103685:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
8010368a:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010368d:	8d 73 74             	lea    0x74(%ebx),%esi
    p->state = EMBRYO;
80103690:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    p->pid = nextpid++;
80103697:	8d 50 01             	lea    0x1(%eax),%edx
        if (t->state == UNUSED)
8010369a:	85 c9                	test   %ecx,%ecx
    p->pid = nextpid++;
8010369c:	89 43 0c             	mov    %eax,0xc(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010369f:	8d 83 74 03 00 00    	lea    0x374(%ebx),%eax
    p->pid = nextpid++;
801036a5:	89 15 0c b0 10 80    	mov    %edx,0x8010b00c
        if (t->state == UNUSED)
801036ab:	75 0a                	jne    801036b7 <allocproc+0x87>
801036ad:	eb 31                	jmp    801036e0 <allocproc+0xb0>
801036af:	90                   	nop
801036b0:	8b 56 08             	mov    0x8(%esi),%edx
801036b3:	85 d2                	test   %edx,%edx
801036b5:	74 29                	je     801036e0 <allocproc+0xb0>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801036b7:	83 c6 30             	add    $0x30,%esi
801036ba:	39 f0                	cmp    %esi,%eax
801036bc:	77 f2                	ja     801036b0 <allocproc+0x80>

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->state = UNUSED;
        t->state = UNUSED;
        release(&ptable.lock);
801036be:	83 ec 0c             	sub    $0xc,%esp
        return 0;
801036c1:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
801036c3:	68 20 4e 11 80       	push   $0x80114e20
801036c8:	e8 b3 1a 00 00       	call   80105180 <release>
        return 0;
801036cd:	83 c4 10             	add    $0x10,%esp
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);
//    release(p->procLock);
    return p;
}
801036d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d3:	89 d8                	mov    %ebx,%eax
801036d5:	5b                   	pop    %ebx
801036d6:	5e                   	pop    %esi
801036d7:	5d                   	pop    %ebp
801036d8:	c3                   	ret    
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    t->tid = tidCounter++;
801036e0:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    t->state = EMBRYO;
801036e5:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    t->tid = tidCounter++;
801036ec:	8d 50 01             	lea    0x1(%eax),%edx
801036ef:	89 46 0c             	mov    %eax,0xc(%esi)
    p->mainThread = t;
801036f2:	89 b3 74 03 00 00    	mov    %esi,0x374(%ebx)
    t->tid = tidCounter++;
801036f8:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
    if ((t->tkstack = kalloc()) == 0) {
801036fe:	e8 ed ed ff ff       	call   801024f0 <kalloc>
80103703:	85 c0                	test   %eax,%eax
80103705:	89 46 04             	mov    %eax,0x4(%esi)
80103708:	74 47                	je     80103751 <allocproc+0x121>
    sp -= sizeof *t->tf;
8010370a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(t->context, 0, sizeof *t->context);
80103710:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
80103713:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
80103718:	89 56 10             	mov    %edx,0x10(%esi)
    *(uint *) sp = (uint) trapret;
8010371b:	c7 40 14 7f 64 10 80 	movl   $0x8010647f,0x14(%eax)
    t->context = (struct context *) sp;
80103722:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
80103725:	6a 14                	push   $0x14
80103727:	6a 00                	push   $0x0
80103729:	50                   	push   %eax
8010372a:	e8 a1 1a 00 00       	call   801051d0 <memset>
    t->context->eip = (uint) forkret;
8010372f:	8b 46 14             	mov    0x14(%esi),%eax
80103732:	c7 40 10 70 37 10 80 	movl   $0x80103770,0x10(%eax)
    release(&ptable.lock);
80103739:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103740:	e8 3b 1a 00 00       	call   80105180 <release>
    return p;
80103745:	83 c4 10             	add    $0x10,%esp
}
80103748:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010374b:	89 d8                	mov    %ebx,%eax
8010374d:	5b                   	pop    %ebx
8010374e:	5e                   	pop    %esi
8010374f:	5d                   	pop    %ebp
80103750:	c3                   	ret    
        p->state = UNUSED;
80103751:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        t->state = UNUSED;
80103758:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
8010375f:	e9 5a ff ff ff       	jmp    801036be <allocproc+0x8e>
80103764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010376a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103770 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103776:	68 20 4e 11 80       	push   $0x80114e20
8010377b:	e8 00 1a 00 00       	call   80105180 <release>

    if (first) {
80103780:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103785:	83 c4 10             	add    $0x10,%esp
80103788:	85 c0                	test   %eax,%eax
8010378a:	75 04                	jne    80103790 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
8010378c:	c9                   	leave  
8010378d:	c3                   	ret    
8010378e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103790:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103793:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010379a:	00 00 00 
        iinit(ROOTDEV);
8010379d:	6a 01                	push   $0x1
8010379f:	e8 0c dd ff ff       	call   801014b0 <iinit>
        initlog(ROOTDEV);
801037a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037ab:	e8 80 f3 ff ff       	call   80102b30 <initlog>
801037b0:	83 c4 10             	add    $0x10,%esp
}
801037b3:	c9                   	leave  
801037b4:	c3                   	ret    
801037b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037c0 <pinit>:
pinit(void) {
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 08             	sub    $0x8,%esp
    if (DEBUGMODE > 0)
801037c6:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
801037cc:	85 c9                	test   %ecx,%ecx
801037ce:	7e 10                	jle    801037e0 <pinit+0x20>
        cprintf(" PINIT ");
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	68 67 82 10 80       	push   $0x80108267
801037d8:	e8 83 ce ff ff       	call   80100660 <cprintf>
801037dd:	83 c4 10             	add    $0x10,%esp
    initlock(&ptable.lock, "ptable");
801037e0:	83 ec 08             	sub    $0x8,%esp
801037e3:	68 6f 82 10 80       	push   $0x8010826f
801037e8:	68 20 4e 11 80       	push   $0x80114e20
801037ed:	e8 7e 17 00 00       	call   80104f70 <initlock>
    initlock(&mtable.lock, "mtable");
801037f2:	58                   	pop    %eax
801037f3:	5a                   	pop    %edx
801037f4:	68 76 82 10 80       	push   $0x80108276
801037f9:	68 e0 3e 11 80       	push   $0x80113ee0
801037fe:	e8 6d 17 00 00       	call   80104f70 <initlock>
}
80103803:	83 c4 10             	add    $0x10,%esp
80103806:	c9                   	leave  
80103807:	c3                   	ret    
80103808:	90                   	nop
80103809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103810 <cleanThread>:
cleanThread(struct thread *t) {
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
80103814:	83 ec 10             	sub    $0x10,%esp
80103817:	8b 5d 08             	mov    0x8(%ebp),%ebx
    kfree(t->tkstack);
8010381a:	ff 73 04             	pushl  0x4(%ebx)
8010381d:	e8 1e eb ff ff       	call   80102340 <kfree>
    memset(t->tf, 0, sizeof(*t->tf));
80103822:	83 c4 0c             	add    $0xc,%esp
    t->tkstack = 0;
80103825:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    t->state = UNUSED;
8010382c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    t->tid = 0;
80103833:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    t->name[0] = 0;
8010383a:	c6 43 1c 00          	movb   $0x0,0x1c(%ebx)
    memset(t->tf, 0, sizeof(*t->tf));
8010383e:	6a 4c                	push   $0x4c
80103840:	6a 00                	push   $0x0
80103842:	ff 73 10             	pushl  0x10(%ebx)
80103845:	e8 86 19 00 00       	call   801051d0 <memset>
    memset(t->context, 0, sizeof(*t->context));
8010384a:	83 c4 0c             	add    $0xc,%esp
8010384d:	6a 14                	push   $0x14
8010384f:	6a 00                	push   $0x0
80103851:	ff 73 14             	pushl  0x14(%ebx)
80103854:	e8 77 19 00 00       	call   801051d0 <memset>
}
80103859:	83 c4 10             	add    $0x10,%esp
8010385c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385f:	c9                   	leave  
80103860:	c3                   	ret    
80103861:	eb 0d                	jmp    80103870 <mycpu>
80103863:	90                   	nop
80103864:	90                   	nop
80103865:	90                   	nop
80103866:	90                   	nop
80103867:	90                   	nop
80103868:	90                   	nop
80103869:	90                   	nop
8010386a:	90                   	nop
8010386b:	90                   	nop
8010386c:	90                   	nop
8010386d:	90                   	nop
8010386e:	90                   	nop
8010386f:	90                   	nop

80103870 <mycpu>:
mycpu(void) {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103875:	9c                   	pushf  
80103876:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103877:	f6 c4 02             	test   $0x2,%ah
8010387a:	75 5e                	jne    801038da <mycpu+0x6a>
    apicid = lapicid();
8010387c:	e8 df ee ff ff       	call   80102760 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103881:	8b 35 c0 3e 11 80    	mov    0x80113ec0,%esi
80103887:	85 f6                	test   %esi,%esi
80103889:	7e 42                	jle    801038cd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010388b:	0f b6 15 20 39 11 80 	movzbl 0x80113920,%edx
80103892:	39 d0                	cmp    %edx,%eax
80103894:	74 30                	je     801038c6 <mycpu+0x56>
80103896:	b9 d4 39 11 80       	mov    $0x801139d4,%ecx
    for (i = 0; i < ncpu; ++i) {
8010389b:	31 d2                	xor    %edx,%edx
8010389d:	8d 76 00             	lea    0x0(%esi),%esi
801038a0:	83 c2 01             	add    $0x1,%edx
801038a3:	39 f2                	cmp    %esi,%edx
801038a5:	74 26                	je     801038cd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
801038a7:	0f b6 19             	movzbl (%ecx),%ebx
801038aa:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
801038b0:	39 c3                	cmp    %eax,%ebx
801038b2:	75 ec                	jne    801038a0 <mycpu+0x30>
801038b4:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
801038ba:	05 20 39 11 80       	add    $0x80113920,%eax
}
801038bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c2:	5b                   	pop    %ebx
801038c3:	5e                   	pop    %esi
801038c4:	5d                   	pop    %ebp
801038c5:	c3                   	ret    
        if (cpus[i].apicid == apicid)
801038c6:	b8 20 39 11 80       	mov    $0x80113920,%eax
            return &cpus[i];
801038cb:	eb f2                	jmp    801038bf <mycpu+0x4f>
    panic("unknown apicid\n");
801038cd:	83 ec 0c             	sub    $0xc,%esp
801038d0:	68 7d 82 10 80       	push   $0x8010827d
801038d5:	e8 b6 ca ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	68 58 84 10 80       	push   $0x80108458
801038e2:	e8 a9 ca ff ff       	call   80100390 <panic>
801038e7:	89 f6                	mov    %esi,%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038f0 <cpuid>:
cpuid() {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
801038f6:	e8 75 ff ff ff       	call   80103870 <mycpu>
801038fb:	2d 20 39 11 80       	sub    $0x80113920,%eax
}
80103900:	c9                   	leave  
    return mycpu() - cpus;
80103901:	c1 f8 02             	sar    $0x2,%eax
80103904:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
8010390a:	c3                   	ret    
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103910 <myproc>:
myproc(void) {
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
80103914:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103917:	e8 c4 16 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
8010391c:	e8 4f ff ff ff       	call   80103870 <mycpu>
    p = c->proc;
80103921:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103927:	e8 f4 16 00 00       	call   80105020 <popcli>
}
8010392c:	83 c4 04             	add    $0x4,%esp
8010392f:	89 d8                	mov    %ebx,%eax
80103931:	5b                   	pop    %ebx
80103932:	5d                   	pop    %ebp
80103933:	c3                   	ret    
80103934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010393a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103940 <mythread>:
mythread(void) {
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
80103944:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103947:	e8 94 16 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
8010394c:	e8 1f ff ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103951:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103957:	e8 c4 16 00 00       	call   80105020 <popcli>
}
8010395c:	83 c4 04             	add    $0x4,%esp
8010395f:	89 d8                	mov    %ebx,%eax
80103961:	5b                   	pop    %ebx
80103962:	5d                   	pop    %ebp
80103963:	c3                   	ret    
80103964:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010396a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103970 <userinit>:
userinit(void) {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
80103974:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103977:	e8 b4 fc ff ff       	call   80103630 <allocproc>
8010397c:	89 c3                	mov    %eax,%ebx
    initproc = p;
8010397e:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
    if ((p->pgdir = setupkvm()) == 0)
80103983:	e8 d8 40 00 00       	call   80107a60 <setupkvm>
80103988:	85 c0                	test   %eax,%eax
8010398a:	89 43 04             	mov    %eax,0x4(%ebx)
8010398d:	0f 84 37 01 00 00    	je     80103aca <userinit+0x15a>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103993:	83 ec 04             	sub    $0x4,%esp
80103996:	68 2c 00 00 00       	push   $0x2c
8010399b:	68 60 b4 10 80       	push   $0x8010b460
801039a0:	50                   	push   %eax
801039a1:	e8 9a 3d 00 00       	call   80107740 <inituvm>
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
801039a6:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
801039a9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
801039af:	6a 4c                	push   $0x4c
801039b1:	6a 00                	push   $0x0
801039b3:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
801039b9:	ff 70 10             	pushl  0x10(%eax)
801039bc:	e8 0f 18 00 00       	call   801051d0 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039c1:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
801039c7:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039cc:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
801039d1:	83 c4 0c             	add    $0xc,%esp
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039d4:	8b 40 10             	mov    0x10(%eax),%eax
801039d7:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039db:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
801039e1:	8b 40 10             	mov    0x10(%eax),%eax
801039e4:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
801039e8:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
801039ee:	8b 40 10             	mov    0x10(%eax),%eax
801039f1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039f5:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
801039f9:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
801039ff:	8b 40 10             	mov    0x10(%eax),%eax
80103a02:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a06:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
80103a0a:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103a10:	8b 40 10             	mov    0x10(%eax),%eax
80103a13:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
80103a1a:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103a20:	8b 40 10             	mov    0x10(%eax),%eax
80103a23:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
80103a2a:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103a30:	8b 40 10             	mov    0x10(%eax),%eax
80103a33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103a3a:	8d 43 64             	lea    0x64(%ebx),%eax
80103a3d:	6a 10                	push   $0x10
80103a3f:	68 a6 82 10 80       	push   $0x801082a6
80103a44:	50                   	push   %eax
80103a45:	e8 66 19 00 00       	call   801053b0 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
80103a4a:	83 c4 0c             	add    $0xc,%esp
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 af 82 10 80       	push   $0x801082af
80103a54:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103a5a:	83 c0 1c             	add    $0x1c,%eax
80103a5d:	50                   	push   %eax
80103a5e:	e8 4d 19 00 00       	call   801053b0 <safestrcpy>
    p->cwd = namei("/");
80103a63:	c7 04 24 ba 82 10 80 	movl   $0x801082ba,(%esp)
80103a6a:	e8 a1 e4 ff ff       	call   80101f10 <namei>
80103a6f:	89 43 60             	mov    %eax,0x60(%ebx)
    ptable.lock.name = "INIT";
80103a72:	c7 05 24 4e 11 80 c5 	movl   $0x801082c5,0x80114e24
80103a79:	82 10 80 
    acquire(&ptable.lock);
80103a7c:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103a83:	e8 28 16 00 00       	call   801050b0 <acquire>
    p->mainThread->state = RUNNABLE;
80103a88:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
    p->state = RUNNABLE;
80103a8e:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103a95:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103a9c:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103aa3:	e8 d8 16 00 00       	call   80105180 <release>
    if (DEBUGMODE > 0)
80103aa8:	8b 1d bc b5 10 80    	mov    0x8010b5bc,%ebx
80103aae:	83 c4 10             	add    $0x10,%esp
80103ab1:	85 db                	test   %ebx,%ebx
80103ab3:	7e 10                	jle    80103ac5 <userinit+0x155>
        cprintf("DONE USERINIT");
80103ab5:	83 ec 0c             	sub    $0xc,%esp
80103ab8:	68 bc 82 10 80       	push   $0x801082bc
80103abd:	e8 9e cb ff ff       	call   80100660 <cprintf>
80103ac2:	83 c4 10             	add    $0x10,%esp
}
80103ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac8:	c9                   	leave  
80103ac9:	c3                   	ret    
        panic("userinit: out of memory?");
80103aca:	83 ec 0c             	sub    $0xc,%esp
80103acd:	68 8d 82 10 80       	push   $0x8010828d
80103ad2:	e8 b9 c8 ff ff       	call   80100390 <panic>
80103ad7:	89 f6                	mov    %esi,%esi
80103ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ae0 <growproc>:
growproc(int n) {
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
80103ae5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103ae8:	e8 f3 14 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80103aed:	e8 7e fd ff ff       	call   80103870 <mycpu>
    p = c->proc;
80103af2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103af8:	e8 23 15 00 00       	call   80105020 <popcli>
    if (DEBUGMODE > 0)
80103afd:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80103b03:	85 d2                	test   %edx,%edx
80103b05:	7e 10                	jle    80103b17 <growproc+0x37>
        cprintf(" GROWPROC APPLYED ");
80103b07:	83 ec 0c             	sub    $0xc,%esp
80103b0a:	68 ca 82 10 80       	push   $0x801082ca
80103b0f:	e8 4c cb ff ff       	call   80100660 <cprintf>
80103b14:	83 c4 10             	add    $0x10,%esp
    if (n > 0) {
80103b17:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103b1a:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103b1c:	7f 52                	jg     80103b70 <growproc+0x90>
    } else if (n < 0) {
80103b1e:	75 70                	jne    80103b90 <growproc+0xb0>
    curproc->sz = sz;
80103b20:	89 03                	mov    %eax,(%ebx)
    if (DEBUGMODE > 0)
80103b22:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103b27:	85 c0                	test   %eax,%eax
80103b29:	7e 10                	jle    80103b3b <growproc+0x5b>
        cprintf(" \n GROWPROC DONE ");
80103b2b:	83 ec 0c             	sub    $0xc,%esp
80103b2e:	68 dd 82 10 80       	push   $0x801082dd
80103b33:	e8 28 cb ff ff       	call   80100660 <cprintf>
80103b38:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103b3b:	e8 a0 14 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80103b40:	e8 2b fd ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103b45:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103b4b:	e8 d0 14 00 00       	call   80105020 <popcli>
    switchuvm(curproc, mythread());
80103b50:	83 ec 08             	sub    $0x8,%esp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx
80103b55:	e8 c6 3a 00 00       	call   80107620 <switchuvm>
    return 0;
80103b5a:	83 c4 10             	add    $0x10,%esp
80103b5d:	31 c0                	xor    %eax,%eax
}
80103b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b62:	5b                   	pop    %ebx
80103b63:	5e                   	pop    %esi
80103b64:	5d                   	pop    %ebp
80103b65:	c3                   	ret    
80103b66:	8d 76 00             	lea    0x0(%esi),%esi
80103b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b70:	83 ec 04             	sub    $0x4,%esp
80103b73:	01 c6                	add    %eax,%esi
80103b75:	56                   	push   %esi
80103b76:	50                   	push   %eax
80103b77:	ff 73 04             	pushl  0x4(%ebx)
80103b7a:	e8 01 3d 00 00       	call   80107880 <allocuvm>
80103b7f:	83 c4 10             	add    $0x10,%esp
80103b82:	85 c0                	test   %eax,%eax
80103b84:	75 9a                	jne    80103b20 <growproc+0x40>
            return -1;
80103b86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b8b:	eb d2                	jmp    80103b5f <growproc+0x7f>
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b90:	83 ec 04             	sub    $0x4,%esp
80103b93:	01 c6                	add    %eax,%esi
80103b95:	56                   	push   %esi
80103b96:	50                   	push   %eax
80103b97:	ff 73 04             	pushl  0x4(%ebx)
80103b9a:	e8 11 3e 00 00       	call   801079b0 <deallocuvm>
80103b9f:	83 c4 10             	add    $0x10,%esp
80103ba2:	85 c0                	test   %eax,%eax
80103ba4:	0f 85 76 ff ff ff    	jne    80103b20 <growproc+0x40>
80103baa:	eb da                	jmp    80103b86 <growproc+0xa6>
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bb0 <fork>:
fork(void) {
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	57                   	push   %edi
80103bb4:	56                   	push   %esi
80103bb5:	53                   	push   %ebx
80103bb6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103bb9:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103bbe:	85 c0                	test   %eax,%eax
80103bc0:	7e 10                	jle    80103bd2 <fork+0x22>
        cprintf(" FORK ");
80103bc2:	83 ec 0c             	sub    $0xc,%esp
80103bc5:	68 ef 82 10 80       	push   $0x801082ef
80103bca:	e8 91 ca ff ff       	call   80100660 <cprintf>
80103bcf:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103bd2:	e8 09 14 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80103bd7:	e8 94 fc ff ff       	call   80103870 <mycpu>
    p = c->proc;
80103bdc:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103be2:	89 55 e0             	mov    %edx,-0x20(%ebp)
    popcli();
80103be5:	e8 36 14 00 00       	call   80105020 <popcli>
    pushcli();
80103bea:	e8 f1 13 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80103bef:	e8 7c fc ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103bf4:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103bfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103bfd:	e8 1e 14 00 00       	call   80105020 <popcli>
    if ((np = allocproc()) == 0) {
80103c02:	e8 29 fa ff ff       	call   80103630 <allocproc>
80103c07:	85 c0                	test   %eax,%eax
80103c09:	89 c3                	mov    %eax,%ebx
80103c0b:	0f 84 fe 00 00 00    	je     80103d0f <fork+0x15f>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103c11:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103c14:	83 ec 08             	sub    $0x8,%esp
80103c17:	ff 32                	pushl  (%edx)
80103c19:	ff 72 04             	pushl  0x4(%edx)
80103c1c:	e8 0f 3f 00 00       	call   80107b30 <copyuvm>
80103c21:	83 c4 10             	add    $0x10,%esp
80103c24:	85 c0                	test   %eax,%eax
80103c26:	89 43 04             	mov    %eax,0x4(%ebx)
80103c29:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103c2c:	0f 84 e4 00 00 00    	je     80103d16 <fork+0x166>
    np->sz = curproc->sz;
80103c32:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103c34:	89 53 10             	mov    %edx,0x10(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103c37:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103c3c:	89 03                	mov    %eax,(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c41:	8b 70 10             	mov    0x10(%eax),%esi
80103c44:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103c4a:	8b 40 10             	mov    0x10(%eax),%eax
80103c4d:	89 c7                	mov    %eax,%edi
80103c4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103c51:	31 f6                	xor    %esi,%esi
80103c53:	89 d7                	mov    %edx,%edi
    np->mainThread->tf->eax = 0;
80103c55:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103c5b:	8b 40 10             	mov    0x10(%eax),%eax
80103c5e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103c65:	8d 76 00             	lea    0x0(%esi),%esi
        if (curproc->ofile[i])
80103c68:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103c6c:	85 c0                	test   %eax,%eax
80103c6e:	74 10                	je     80103c80 <fork+0xd0>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103c70:	83 ec 0c             	sub    $0xc,%esp
80103c73:	50                   	push   %eax
80103c74:	e8 97 d1 ff ff       	call   80100e10 <filedup>
80103c79:	83 c4 10             	add    $0x10,%esp
80103c7c:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103c80:	83 c6 01             	add    $0x1,%esi
80103c83:	83 fe 10             	cmp    $0x10,%esi
80103c86:	75 e0                	jne    80103c68 <fork+0xb8>
    np->cwd = idup(curproc->cwd);
80103c88:	83 ec 0c             	sub    $0xc,%esp
80103c8b:	ff 77 60             	pushl  0x60(%edi)
80103c8e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80103c91:	e8 ea d9 ff ff       	call   80101680 <idup>
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c96:	8b 55 e0             	mov    -0x20(%ebp),%edx
    np->cwd = idup(curproc->cwd);
80103c99:	89 43 60             	mov    %eax,0x60(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c9c:	8d 43 64             	lea    0x64(%ebx),%eax
80103c9f:	83 c4 0c             	add    $0xc,%esp
80103ca2:	6a 10                	push   $0x10
80103ca4:	83 c2 64             	add    $0x64,%edx
80103ca7:	52                   	push   %edx
80103ca8:	50                   	push   %eax
80103ca9:	e8 02 17 00 00       	call   801053b0 <safestrcpy>
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cb1:	83 c4 0c             	add    $0xc,%esp
80103cb4:	6a 10                	push   $0x10
80103cb6:	83 c0 1c             	add    $0x1c,%eax
80103cb9:	50                   	push   %eax
80103cba:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103cc0:	83 c0 1c             	add    $0x1c,%eax
80103cc3:	50                   	push   %eax
80103cc4:	e8 e7 16 00 00       	call   801053b0 <safestrcpy>
    pid = np->pid;
80103cc9:	8b 73 0c             	mov    0xc(%ebx),%esi
    ptable.lock.name = "FORK";
80103ccc:	c7 05 24 4e 11 80 f6 	movl   $0x801082f6,0x80114e24
80103cd3:	82 10 80 
    acquire(&ptable.lock);
80103cd6:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103cdd:	e8 ce 13 00 00       	call   801050b0 <acquire>
    np->mainThread->state = RUNNABLE;
80103ce2:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
    np->state = RUNNABLE;
80103ce8:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    np->mainThread->state = RUNNABLE;
80103cef:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103cf6:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103cfd:	e8 7e 14 00 00       	call   80105180 <release>
    return pid;
80103d02:	83 c4 10             	add    $0x10,%esp
}
80103d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d08:	89 f0                	mov    %esi,%eax
80103d0a:	5b                   	pop    %ebx
80103d0b:	5e                   	pop    %esi
80103d0c:	5f                   	pop    %edi
80103d0d:	5d                   	pop    %ebp
80103d0e:	c3                   	ret    
        return -1;
80103d0f:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103d14:	eb ef                	jmp    80103d05 <fork+0x155>
        kfree(np->mainThread->tkstack);
80103d16:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80103d1c:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103d1f:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->mainThread->tkstack);
80103d24:	ff 70 04             	pushl  0x4(%eax)
80103d27:	e8 14 e6 ff ff       	call   80102340 <kfree>
        np->mainThread->tkstack = 0;
80103d2c:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
        return -1;
80103d32:	83 c4 10             	add    $0x10,%esp
        np->mainThread->tkstack = 0;
80103d35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->mainThread->state = UNUSED;
80103d3c:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
        np->state = UNUSED;
80103d42:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103d49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103d50:	eb b3                	jmp    80103d05 <fork+0x155>
80103d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d60 <scheduler>:
scheduler(void) {
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103d69:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
80103d6f:	85 c9                	test   %ecx,%ecx
80103d71:	7e 10                	jle    80103d83 <scheduler+0x23>
        cprintf(" SCHEDULER ");
80103d73:	83 ec 0c             	sub    $0xc,%esp
80103d76:	68 fb 82 10 80       	push   $0x801082fb
80103d7b:	e8 e0 c8 ff ff       	call   80100660 <cprintf>
80103d80:	83 c4 10             	add    $0x10,%esp
    struct cpu *c = mycpu();
80103d83:	e8 e8 fa ff ff       	call   80103870 <mycpu>
    c->proc = 0;
80103d88:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d8f:	00 00 00 
    struct cpu *c = mycpu();
80103d92:	89 c7                	mov    %eax,%edi
80103d94:	8d 40 04             	lea    0x4(%eax),%eax
80103d97:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("sti");
80103d9a:	fb                   	sti    
        acquire(&ptable.lock);
80103d9b:	83 ec 0c             	sub    $0xc,%esp
        ptable.lock.name = "SCHEDUALER";
80103d9e:	c7 05 24 4e 11 80 07 	movl   $0x80108307,0x80114e24
80103da5:	83 10 80 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103da8:	be 58 4e 11 80       	mov    $0x80114e58,%esi
        acquire(&ptable.lock);
80103dad:	68 20 4e 11 80       	push   $0x80114e20
80103db2:	e8 f9 12 00 00       	call   801050b0 <acquire>
80103db7:	83 c4 10             	add    $0x10,%esp
80103dba:	eb 16                	jmp    80103dd2 <scheduler+0x72>
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dc0:	81 c6 7c 03 00 00    	add    $0x37c,%esi
80103dc6:	81 fe 58 2d 12 80    	cmp    $0x80122d58,%esi
80103dcc:	0f 83 8d 00 00 00    	jae    80103e5f <scheduler+0xff>
            if (p->state != RUNNABLE)
80103dd2:	83 7e 08 03          	cmpl   $0x3,0x8(%esi)
80103dd6:	75 e8                	jne    80103dc0 <scheduler+0x60>
80103dd8:	8d 5e 74             	lea    0x74(%esi),%ebx
80103ddb:	8d 96 74 03 00 00    	lea    0x374(%esi),%edx
            c->proc = p;
80103de1:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
80103de7:	89 f6                	mov    %esi,%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                if (t->state != RUNNABLE)
80103df0:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103df4:	75 37                	jne    80103e2d <scheduler+0xcd>
                switchuvm(p, t);
80103df6:	83 ec 08             	sub    $0x8,%esp
                t->state = RUNNING;
80103df9:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)
                c->currThread = t;
80103e00:	89 9f b0 00 00 00    	mov    %ebx,0xb0(%edi)
                switchuvm(p, t);
80103e06:	53                   	push   %ebx
80103e07:	56                   	push   %esi
80103e08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103e0b:	e8 10 38 00 00       	call   80107620 <switchuvm>
                swtch(&(c->scheduler), t->context);
80103e10:	58                   	pop    %eax
80103e11:	5a                   	pop    %edx
80103e12:	ff 73 14             	pushl  0x14(%ebx)
80103e15:	ff 75 e0             	pushl  -0x20(%ebp)
80103e18:	e8 ee 15 00 00       	call   8010540b <swtch>
                c->currThread = 0;
80103e1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e20:	c7 87 b0 00 00 00 00 	movl   $0x0,0xb0(%edi)
80103e27:	00 00 00 
80103e2a:	83 c4 10             	add    $0x10,%esp
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103e2d:	83 c3 30             	add    $0x30,%ebx
80103e30:	39 da                	cmp    %ebx,%edx
80103e32:	77 bc                	ja     80103df0 <scheduler+0x90>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e34:	81 c6 7c 03 00 00    	add    $0x37c,%esi
            switchkvm();
80103e3a:	e8 c1 37 00 00       	call   80107600 <switchkvm>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e3f:	81 fe 58 2d 12 80    	cmp    $0x80122d58,%esi
            c->proc = 0;
80103e45:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103e4c:	00 00 00 
            c->currThread = 0;
80103e4f:	c7 87 b0 00 00 00 00 	movl   $0x0,0xb0(%edi)
80103e56:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e59:	0f 82 73 ff ff ff    	jb     80103dd2 <scheduler+0x72>
        release(&ptable.lock);
80103e5f:	83 ec 0c             	sub    $0xc,%esp
80103e62:	68 20 4e 11 80       	push   $0x80114e20
80103e67:	e8 14 13 00 00       	call   80105180 <release>
        sti();
80103e6c:	83 c4 10             	add    $0x10,%esp
80103e6f:	e9 26 ff ff ff       	jmp    80103d9a <scheduler+0x3a>
80103e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e80 <sched>:
    if (DEBUGMODE > 1)
80103e80:	83 3d bc b5 10 80 01 	cmpl   $0x1,0x8010b5bc
sched(void) {
80103e87:	55                   	push   %ebp
80103e88:	89 e5                	mov    %esp,%ebp
80103e8a:	56                   	push   %esi
80103e8b:	53                   	push   %ebx
    if (DEBUGMODE > 1)
80103e8c:	7e 10                	jle    80103e9e <sched+0x1e>
        cprintf(" SCHED ");
80103e8e:	83 ec 0c             	sub    $0xc,%esp
80103e91:	68 12 83 10 80       	push   $0x80108312
80103e96:	e8 c5 c7 ff ff       	call   80100660 <cprintf>
80103e9b:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103e9e:	e8 3d 11 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80103ea3:	e8 c8 f9 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103ea8:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103eae:	e8 6d 11 00 00       	call   80105020 <popcli>
    if (!holding(&ptable.lock))
80103eb3:	83 ec 0c             	sub    $0xc,%esp
80103eb6:	68 20 4e 11 80       	push   $0x80114e20
80103ebb:	e8 c0 11 00 00       	call   80105080 <holding>
80103ec0:	83 c4 10             	add    $0x10,%esp
80103ec3:	85 c0                	test   %eax,%eax
80103ec5:	74 4f                	je     80103f16 <sched+0x96>
    if (mycpu()->ncli != 1)
80103ec7:	e8 a4 f9 ff ff       	call   80103870 <mycpu>
80103ecc:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103ed3:	75 68                	jne    80103f3d <sched+0xbd>
    if (t->state == RUNNING)
80103ed5:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103ed9:	74 55                	je     80103f30 <sched+0xb0>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103edb:	9c                   	pushf  
80103edc:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103edd:	f6 c4 02             	test   $0x2,%ah
80103ee0:	75 41                	jne    80103f23 <sched+0xa3>
    intena = mycpu()->intena;
80103ee2:	e8 89 f9 ff ff       	call   80103870 <mycpu>
    swtch(&t->context, mycpu()->scheduler);
80103ee7:	83 c3 14             	add    $0x14,%ebx
    intena = mycpu()->intena;
80103eea:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&t->context, mycpu()->scheduler);
80103ef0:	e8 7b f9 ff ff       	call   80103870 <mycpu>
80103ef5:	83 ec 08             	sub    $0x8,%esp
80103ef8:	ff 70 04             	pushl  0x4(%eax)
80103efb:	53                   	push   %ebx
80103efc:	e8 0a 15 00 00       	call   8010540b <swtch>
    mycpu()->intena = intena;
80103f01:	e8 6a f9 ff ff       	call   80103870 <mycpu>
}
80103f06:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80103f09:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f12:	5b                   	pop    %ebx
80103f13:	5e                   	pop    %esi
80103f14:	5d                   	pop    %ebp
80103f15:	c3                   	ret    
        panic("sched ptable.lock");
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	68 1a 83 10 80       	push   $0x8010831a
80103f1e:	e8 6d c4 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
80103f23:	83 ec 0c             	sub    $0xc,%esp
80103f26:	68 46 83 10 80       	push   $0x80108346
80103f2b:	e8 60 c4 ff ff       	call   80100390 <panic>
        panic("sched running");
80103f30:	83 ec 0c             	sub    $0xc,%esp
80103f33:	68 38 83 10 80       	push   $0x80108338
80103f38:	e8 53 c4 ff ff       	call   80100390 <panic>
        panic("sched locks");
80103f3d:	83 ec 0c             	sub    $0xc,%esp
80103f40:	68 2c 83 10 80       	push   $0x8010832c
80103f45:	e8 46 c4 ff ff       	call   80100390 <panic>
80103f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f50 <yield>:
yield(void) {
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	53                   	push   %ebx
80103f54:	83 ec 10             	sub    $0x10,%esp
    ptable.lock.name = "YIELD";
80103f57:	c7 05 24 4e 11 80 5a 	movl   $0x8010835a,0x80114e24
80103f5e:	83 10 80 
    acquire(&ptable.lock);
80103f61:	68 20 4e 11 80       	push   $0x80114e20
80103f66:	e8 45 11 00 00       	call   801050b0 <acquire>
    pushcli();
80103f6b:	e8 70 10 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80103f70:	e8 fb f8 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103f75:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103f7b:	e8 a0 10 00 00       	call   80105020 <popcli>
    mythread()->state = RUNNABLE;
80103f80:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103f87:	e8 f4 fe ff ff       	call   80103e80 <sched>
    release(&ptable.lock);
80103f8c:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103f93:	e8 e8 11 00 00       	call   80105180 <release>
}
80103f98:	83 c4 10             	add    $0x10,%esp
80103f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f9e:	c9                   	leave  
80103f9f:	c3                   	ret    

80103fa0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80103fa9:	83 3d bc b5 10 80 01 	cmpl   $0x1,0x8010b5bc
sleep(void *chan, struct spinlock *lk) {
80103fb0:	8b 7d 08             	mov    0x8(%ebp),%edi
80103fb3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (DEBUGMODE > 1)
80103fb6:	7e 10                	jle    80103fc8 <sleep+0x28>
        cprintf(" SLEEP ");
80103fb8:	83 ec 0c             	sub    $0xc,%esp
80103fbb:	68 60 83 10 80       	push   $0x80108360
80103fc0:	e8 9b c6 ff ff       	call   80100660 <cprintf>
80103fc5:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103fc8:	e8 13 10 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80103fcd:	e8 9e f8 ff ff       	call   80103870 <mycpu>
    p = c->proc;
80103fd2:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103fd8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103fdb:	e8 40 10 00 00       	call   80105020 <popcli>
    pushcli();
80103fe0:	e8 fb 0f 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80103fe5:	e8 86 f8 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103fea:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103ff0:	e8 2b 10 00 00       	call   80105020 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103ff5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ff8:	85 d2                	test   %edx,%edx
80103ffa:	0f 84 9b 00 00 00    	je     8010409b <sleep+0xfb>
        panic("sleep");

    if (lk == 0)
80104000:	85 db                	test   %ebx,%ebx
80104002:	0f 84 86 00 00 00    	je     8010408e <sleep+0xee>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {
80104008:	81 fb 20 4e 11 80    	cmp    $0x80114e20,%ebx
8010400e:	74 60                	je     80104070 <sleep+0xd0>

        ptable.lock.name = "SLEEP";
        acquire(&ptable.lock);
80104010:	83 ec 0c             	sub    $0xc,%esp
        ptable.lock.name = "SLEEP";
80104013:	c7 05 24 4e 11 80 7f 	movl   $0x8010837f,0x80114e24
8010401a:	83 10 80 
        acquire(&ptable.lock);
8010401d:	68 20 4e 11 80       	push   $0x80114e20
80104022:	e8 89 10 00 00       	call   801050b0 <acquire>
        release(lk);
80104027:	89 1c 24             	mov    %ebx,(%esp)
8010402a:	e8 51 11 00 00       	call   80105180 <release>
    }
    // Go to sleep.
    t->chan = chan;
8010402f:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80104032:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80104039:	e8 42 fe ff ff       	call   80103e80 <sched>

    // Tidy up.
    t->chan = 0;
8010403e:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80104045:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
8010404c:	e8 2f 11 00 00       	call   80105180 <release>
        ptable.lock.name = "SLEEP2";
        acquire(lk);
80104051:	89 5d 08             	mov    %ebx,0x8(%ebp)
        ptable.lock.name = "SLEEP2";
80104054:	c7 05 24 4e 11 80 85 	movl   $0x80108385,0x80114e24
8010405b:	83 10 80 
        acquire(lk);
8010405e:	83 c4 10             	add    $0x10,%esp
    }
}
80104061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104064:	5b                   	pop    %ebx
80104065:	5e                   	pop    %esi
80104066:	5f                   	pop    %edi
80104067:	5d                   	pop    %ebp
        acquire(lk);
80104068:	e9 43 10 00 00       	jmp    801050b0 <acquire>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi
    t->chan = chan;
80104070:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80104073:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)
    sched();
8010407a:	e8 01 fe ff ff       	call   80103e80 <sched>
    t->chan = 0;
8010407f:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
}
80104086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5f                   	pop    %edi
8010408c:	5d                   	pop    %ebp
8010408d:	c3                   	ret    
        panic("sleep without lk");
8010408e:	83 ec 0c             	sub    $0xc,%esp
80104091:	68 6e 83 10 80       	push   $0x8010836e
80104096:	e8 f5 c2 ff ff       	call   80100390 <panic>
        panic("sleep");
8010409b:	83 ec 0c             	sub    $0xc,%esp
8010409e:	68 68 83 10 80       	push   $0x80108368
801040a3:	e8 e8 c2 ff ff       	call   80100390 <panic>
801040a8:	90                   	nop
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040b0 <cleanProcOneThread>:
cleanProcOneThread(struct thread *curthread, struct proc *p) {
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 28             	sub    $0x28,%esp
801040b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040bc:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&ptable.lock);
801040bf:	68 20 4e 11 80       	push   $0x80114e20
    ptable.lock.name = "CLEANPROCONETHREAD";
801040c4:	c7 05 24 4e 11 80 8c 	movl   $0x8010838c,0x80114e24
801040cb:	83 10 80 
cleanProcOneThread(struct thread *curthread, struct proc *p) {
801040ce:	89 c7                	mov    %eax,%edi
801040d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801040d3:	8d 5f 74             	lea    0x74(%edi),%ebx
801040d6:	8d bf 74 03 00 00    	lea    0x374(%edi),%edi
    acquire(&ptable.lock);
801040dc:	e8 cf 0f 00 00       	call   801050b0 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801040e1:	83 c4 10             	add    $0x10,%esp
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (t != curthread && t->state != UNUSED) {
801040e8:	39 de                	cmp    %ebx,%esi
801040ea:	74 18                	je     80104104 <cleanProcOneThread+0x54>
801040ec:	8b 43 08             	mov    0x8(%ebx),%eax
801040ef:	85 c0                	test   %eax,%eax
801040f1:	74 11                	je     80104104 <cleanProcOneThread+0x54>
            if (t->state == RUNNING)
801040f3:	83 f8 04             	cmp    $0x4,%eax
801040f6:	74 38                	je     80104130 <cleanProcOneThread+0x80>
            cleanThread(t);
801040f8:	83 ec 0c             	sub    $0xc,%esp
801040fb:	53                   	push   %ebx
801040fc:	e8 0f f7 ff ff       	call   80103810 <cleanThread>
80104101:	83 c4 10             	add    $0x10,%esp
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104104:	83 c3 30             	add    $0x30,%ebx
80104107:	39 fb                	cmp    %edi,%ebx
80104109:	72 dd                	jb     801040e8 <cleanProcOneThread+0x38>
    p->mainThread = curthread;
8010410b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010410e:	89 b0 74 03 00 00    	mov    %esi,0x374(%eax)
    release(&ptable.lock);
80104114:	c7 45 08 20 4e 11 80 	movl   $0x80114e20,0x8(%ebp)
}
8010411b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010411e:	5b                   	pop    %ebx
8010411f:	5e                   	pop    %esi
80104120:	5f                   	pop    %edi
80104121:	5d                   	pop    %ebp
    release(&ptable.lock);
80104122:	e9 59 10 00 00       	jmp    80105180 <release>
80104127:	89 f6                	mov    %esi,%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                sleep(t, &ptable.lock);
80104130:	83 ec 08             	sub    $0x8,%esp
80104133:	68 20 4e 11 80       	push   $0x80114e20
80104138:	53                   	push   %ebx
80104139:	e8 62 fe ff ff       	call   80103fa0 <sleep>
8010413e:	83 c4 10             	add    $0x10,%esp
80104141:	eb b5                	jmp    801040f8 <cleanProcOneThread+0x48>
80104143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104150 <exit>:
exit(void) {
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
80104156:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104159:	e8 82 0e 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
8010415e:	e8 0d f7 ff ff       	call   80103870 <mycpu>
    p = c->proc;
80104163:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104169:	e8 b2 0e 00 00       	call   80105020 <popcli>
    pushcli();
8010416e:	e8 6d 0e 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80104173:	e8 f8 f6 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104178:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010417e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
80104181:	e8 9a 0e 00 00       	call   80105020 <popcli>
    if (DEBUGMODE > 0)
80104186:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
8010418b:	85 c0                	test   %eax,%eax
8010418d:	7e 10                	jle    8010419f <exit+0x4f>
        cprintf("EXIT");
8010418f:	83 ec 0c             	sub    $0xc,%esp
80104192:	68 08 84 10 80       	push   $0x80108408
80104197:	e8 c4 c4 ff ff       	call   80100660 <cprintf>
8010419c:	83 c4 10             	add    $0x10,%esp
    if (curproc == initproc)
8010419f:	39 35 c0 b5 10 80    	cmp    %esi,0x8010b5c0
801041a5:	0f 84 63 01 00 00    	je     8010430e <exit+0x1be>
    cleanProcOneThread(curthread, curproc);
801041ab:	83 ec 08             	sub    $0x8,%esp
801041ae:	8d 7e 20             	lea    0x20(%esi),%edi
801041b1:	8d 5e 60             	lea    0x60(%esi),%ebx
801041b4:	56                   	push   %esi
801041b5:	ff 75 e0             	pushl  -0x20(%ebp)
801041b8:	e8 f3 fe ff ff       	call   801040b0 <cleanProcOneThread>
801041bd:	83 c4 10             	add    $0x10,%esp
        if (curproc->ofile[fd]) {
801041c0:	8b 07                	mov    (%edi),%eax
801041c2:	85 c0                	test   %eax,%eax
801041c4:	74 12                	je     801041d8 <exit+0x88>
            fileclose(curproc->ofile[fd]);
801041c6:	83 ec 0c             	sub    $0xc,%esp
801041c9:	50                   	push   %eax
801041ca:	e8 91 cc ff ff       	call   80100e60 <fileclose>
            curproc->ofile[fd] = 0;
801041cf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801041d5:	83 c4 10             	add    $0x10,%esp
801041d8:	83 c7 04             	add    $0x4,%edi
    for (fd = 0; fd < NOFILE; fd++) {
801041db:	39 df                	cmp    %ebx,%edi
801041dd:	75 e1                	jne    801041c0 <exit+0x70>
    begin_op();
801041df:	e8 ec e9 ff ff       	call   80102bd0 <begin_op>
    iput(curproc->cwd);
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	ff 76 60             	pushl  0x60(%esi)
801041ea:	e8 f1 d5 ff ff       	call   801017e0 <iput>
    end_op();
801041ef:	e8 4c ea ff ff       	call   80102c40 <end_op>
    curproc->cwd = 0;
801041f4:	c7 46 60 00 00 00 00 	movl   $0x0,0x60(%esi)
    ptable.lock.name = "EXIT2";
801041fb:	c7 05 24 4e 11 80 ac 	movl   $0x801083ac,0x80114e24
80104202:	83 10 80 
    acquire(&ptable.lock);
80104205:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
8010420c:	e8 9f 0e 00 00       	call   801050b0 <acquire>
    wakeup1(curproc->parent->mainThread);
80104211:	8b 46 10             	mov    0x10(%esi),%eax
80104214:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104217:	ba 58 4e 11 80       	mov    $0x80114e58,%edx
    wakeup1(curproc->parent->mainThread);
8010421c:	8b 98 74 03 00 00    	mov    0x374(%eax),%ebx
80104222:	eb 12                	jmp    80104236 <exit+0xe6>
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104228:	81 c2 7c 03 00 00    	add    $0x37c,%edx
8010422e:	81 fa 58 2d 12 80    	cmp    $0x80122d58,%edx
80104234:	73 35                	jae    8010426b <exit+0x11b>
        if (p->state != RUNNABLE)
80104236:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
8010423a:	75 ec                	jne    80104228 <exit+0xd8>
8010423c:	8d 42 74             	lea    0x74(%edx),%eax
8010423f:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
80104245:	eb 10                	jmp    80104257 <exit+0x107>
80104247:	89 f6                	mov    %esi,%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104250:	83 c0 30             	add    $0x30,%eax
80104253:	39 c8                	cmp    %ecx,%eax
80104255:	73 d1                	jae    80104228 <exit+0xd8>
            if (t->state == SLEEPING && t->chan == chan)
80104257:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010425b:	75 f3                	jne    80104250 <exit+0x100>
8010425d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104260:	75 ee                	jne    80104250 <exit+0x100>
                t->state = RUNNABLE;
80104262:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104269:	eb e5                	jmp    80104250 <exit+0x100>
            p->parent = initproc;
8010426b:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104270:	bb 58 4e 11 80       	mov    $0x80114e58,%ebx
            p->parent = initproc;
80104275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104278:	eb 14                	jmp    8010428e <exit+0x13e>
8010427a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104280:	81 c3 7c 03 00 00    	add    $0x37c,%ebx
80104286:	81 fb 58 2d 12 80    	cmp    $0x80122d58,%ebx
8010428c:	73 5d                	jae    801042eb <exit+0x19b>
        if (p->parent == curproc) {
8010428e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104291:	75 ed                	jne    80104280 <exit+0x130>
            if (p->state == ZOMBIE)
80104293:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
            p->parent = initproc;
80104297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010429a:	89 43 10             	mov    %eax,0x10(%ebx)
            if (p->state == ZOMBIE)
8010429d:	75 e1                	jne    80104280 <exit+0x130>
                wakeup1(initproc->mainThread);
8010429f:	8b b8 74 03 00 00    	mov    0x374(%eax),%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042a5:	ba 58 4e 11 80       	mov    $0x80114e58,%edx
801042aa:	eb 12                	jmp    801042be <exit+0x16e>
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b0:	81 c2 7c 03 00 00    	add    $0x37c,%edx
801042b6:	81 fa 58 2d 12 80    	cmp    $0x80122d58,%edx
801042bc:	73 c2                	jae    80104280 <exit+0x130>
        if (p->state != RUNNABLE)
801042be:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801042c2:	75 ec                	jne    801042b0 <exit+0x160>
801042c4:	8d 42 74             	lea    0x74(%edx),%eax
801042c7:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
801042cd:	eb 08                	jmp    801042d7 <exit+0x187>
801042cf:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801042d0:	83 c0 30             	add    $0x30,%eax
801042d3:	39 c1                	cmp    %eax,%ecx
801042d5:	76 d9                	jbe    801042b0 <exit+0x160>
            if (t->state == SLEEPING && t->chan == chan)
801042d7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801042db:	75 f3                	jne    801042d0 <exit+0x180>
801042dd:	3b 78 18             	cmp    0x18(%eax),%edi
801042e0:	75 ee                	jne    801042d0 <exit+0x180>
                t->state = RUNNABLE;
801042e2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801042e9:	eb e5                	jmp    801042d0 <exit+0x180>
    curthread->state = ZOMBIE;
801042eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ee:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    curproc->state = ZOMBIE;
801042f5:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
801042fc:	e8 7f fb ff ff       	call   80103e80 <sched>
    panic("zombie exit");
80104301:	83 ec 0c             	sub    $0xc,%esp
80104304:	68 b2 83 10 80       	push   $0x801083b2
80104309:	e8 82 c0 ff ff       	call   80100390 <panic>
        panic("init exiting");
8010430e:	83 ec 0c             	sub    $0xc,%esp
80104311:	68 9f 83 10 80       	push   $0x8010839f
80104316:	e8 75 c0 ff ff       	call   80100390 <panic>
8010431b:	90                   	nop
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104320 <wait>:
wait(void) {
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	53                   	push   %ebx
80104326:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80104329:	83 3d bc b5 10 80 01 	cmpl   $0x1,0x8010b5bc
80104330:	7e 10                	jle    80104342 <wait+0x22>
        cprintf(" WAIT ");
80104332:	83 ec 0c             	sub    $0xc,%esp
80104335:	68 be 83 10 80       	push   $0x801083be
8010433a:	e8 21 c3 ff ff       	call   80100660 <cprintf>
8010433f:	83 c4 10             	add    $0x10,%esp
    pushcli();
80104342:	e8 99 0c 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80104347:	e8 24 f5 ff ff       	call   80103870 <mycpu>
    p = c->proc;
8010434c:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104352:	e8 c9 0c 00 00       	call   80105020 <popcli>
    acquire(&ptable.lock);
80104357:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "WAIT";
8010435a:	c7 05 24 4e 11 80 c5 	movl   $0x801083c5,0x80114e24
80104361:	83 10 80 
    acquire(&ptable.lock);
80104364:	68 20 4e 11 80       	push   $0x80114e20
80104369:	e8 42 0d 00 00       	call   801050b0 <acquire>
8010436e:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
80104371:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104373:	bb 58 4e 11 80       	mov    $0x80114e58,%ebx
80104378:	eb 14                	jmp    8010438e <wait+0x6e>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104380:	81 c3 7c 03 00 00    	add    $0x37c,%ebx
80104386:	81 fb 58 2d 12 80    	cmp    $0x80122d58,%ebx
8010438c:	73 1e                	jae    801043ac <wait+0x8c>
            if (p->parent != curproc)
8010438e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104391:	75 ed                	jne    80104380 <wait+0x60>
            if (p->state == ZOMBIE) {
80104393:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80104397:	74 67                	je     80104400 <wait+0xe0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104399:	81 c3 7c 03 00 00    	add    $0x37c,%ebx
            havekids = 1;
8010439f:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043a4:	81 fb 58 2d 12 80    	cmp    $0x80122d58,%ebx
801043aa:	72 e2                	jb     8010438e <wait+0x6e>
        if (!havekids || myproc()->killed) {
801043ac:	85 c0                	test   %eax,%eax
801043ae:	0f 84 ca 00 00 00    	je     8010447e <wait+0x15e>
    pushcli();
801043b4:	e8 27 0c 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
801043b9:	e8 b2 f4 ff ff       	call   80103870 <mycpu>
    p = c->proc;
801043be:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801043c4:	e8 57 0c 00 00       	call   80105020 <popcli>
        if (!havekids || myproc()->killed) {
801043c9:	8b 43 1c             	mov    0x1c(%ebx),%eax
801043cc:	85 c0                	test   %eax,%eax
801043ce:	0f 85 aa 00 00 00    	jne    8010447e <wait+0x15e>
    pushcli();
801043d4:	e8 07 0c 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
801043d9:	e8 92 f4 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
801043de:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801043e4:	e8 37 0c 00 00       	call   80105020 <popcli>
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
801043e9:	83 ec 08             	sub    $0x8,%esp
801043ec:	68 20 4e 11 80       	push   $0x80114e20
801043f1:	53                   	push   %ebx
801043f2:	e8 a9 fb ff ff       	call   80103fa0 <sleep>
        havekids = 0;
801043f7:	83 c4 10             	add    $0x10,%esp
801043fa:	e9 72 ff ff ff       	jmp    80104371 <wait+0x51>
801043ff:	90                   	nop
                pid = p->pid;
80104400:	8b 43 0c             	mov    0xc(%ebx),%eax
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104403:	8d 73 74             	lea    0x74(%ebx),%esi
80104406:	8d bb 74 03 00 00    	lea    0x374(%ebx),%edi
                pid = p->pid;
8010440c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010440f:	eb 0e                	jmp    8010441f <wait+0xff>
80104411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104418:	83 c6 30             	add    $0x30,%esi
8010441b:	39 f7                	cmp    %esi,%edi
8010441d:	76 1a                	jbe    80104439 <wait+0x119>
                    if (t->state != UNUSED)
8010441f:	8b 56 08             	mov    0x8(%esi),%edx
80104422:	85 d2                	test   %edx,%edx
80104424:	74 f2                	je     80104418 <wait+0xf8>
                        cleanThread(t);
80104426:	83 ec 0c             	sub    $0xc,%esp
80104429:	56                   	push   %esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010442a:	83 c6 30             	add    $0x30,%esi
                        cleanThread(t);
8010442d:	e8 de f3 ff ff       	call   80103810 <cleanThread>
80104432:	83 c4 10             	add    $0x10,%esp
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104435:	39 f7                	cmp    %esi,%edi
80104437:	77 e6                	ja     8010441f <wait+0xff>
                freevm(p->pgdir);
80104439:	83 ec 0c             	sub    $0xc,%esp
8010443c:	ff 73 04             	pushl  0x4(%ebx)
8010443f:	e8 9c 35 00 00       	call   801079e0 <freevm>
                p->pid = 0;
80104444:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
8010444b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
80104452:	c6 43 64 00          	movb   $0x0,0x64(%ebx)
                p->killed = 0;
80104456:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
8010445d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
80104464:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
8010446b:	e8 10 0d 00 00       	call   80105180 <release>
                return pid;
80104470:	83 c4 10             	add    $0x10,%esp
}
80104473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104476:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104479:	5b                   	pop    %ebx
8010447a:	5e                   	pop    %esi
8010447b:	5f                   	pop    %edi
8010447c:	5d                   	pop    %ebp
8010447d:	c3                   	ret    
            release(&ptable.lock);
8010447e:	83 ec 0c             	sub    $0xc,%esp
80104481:	68 20 4e 11 80       	push   $0x80114e20
80104486:	e8 f5 0c 00 00       	call   80105180 <release>
            return -1;
8010448b:	83 c4 10             	add    $0x10,%esp
8010448e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104495:	eb dc                	jmp    80104473 <wait+0x153>
80104497:	89 f6                	mov    %esi,%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 1)
801044a7:	83 3d bc b5 10 80 01 	cmpl   $0x1,0x8010b5bc
wakeup(void *chan) {
801044ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 1)
801044b1:	7e 10                	jle    801044c3 <wakeup+0x23>
        cprintf(" WAKEUP ");
801044b3:	83 ec 0c             	sub    $0xc,%esp
801044b6:	68 ca 83 10 80       	push   $0x801083ca
801044bb:	e8 a0 c1 ff ff       	call   80100660 <cprintf>
801044c0:	83 c4 10             	add    $0x10,%esp
    char *aa = ptable.lock.name;
801044c3:	a1 24 4e 11 80       	mov    0x80114e24,%eax
    ptable.lock.name = "WAKEUP";
    ptable.lock.namee = aa;
    acquire(&ptable.lock);
801044c8:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "WAKEUP";
801044cb:	c7 05 24 4e 11 80 d3 	movl   $0x801083d3,0x80114e24
801044d2:	83 10 80 
    acquire(&ptable.lock);
801044d5:	68 20 4e 11 80       	push   $0x80114e20
    ptable.lock.namee = aa;
801044da:	a3 28 4e 11 80       	mov    %eax,0x80114e28
    acquire(&ptable.lock);
801044df:	e8 cc 0b 00 00       	call   801050b0 <acquire>
801044e4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044e7:	ba 58 4e 11 80       	mov    $0x80114e58,%edx
801044ec:	eb 10                	jmp    801044fe <wakeup+0x5e>
801044ee:	66 90                	xchg   %ax,%ax
801044f0:	81 c2 7c 03 00 00    	add    $0x37c,%edx
801044f6:	81 fa 58 2d 12 80    	cmp    $0x80122d58,%edx
801044fc:	73 2d                	jae    8010452b <wakeup+0x8b>
        if (p->state != RUNNABLE)
801044fe:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104502:	75 ec                	jne    801044f0 <wakeup+0x50>
80104504:	8d 42 74             	lea    0x74(%edx),%eax
80104507:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
8010450d:	eb 08                	jmp    80104517 <wakeup+0x77>
8010450f:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104510:	83 c0 30             	add    $0x30,%eax
80104513:	39 c1                	cmp    %eax,%ecx
80104515:	76 d9                	jbe    801044f0 <wakeup+0x50>
            if (t->state == SLEEPING && t->chan == chan)
80104517:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010451b:	75 f3                	jne    80104510 <wakeup+0x70>
8010451d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104520:	75 ee                	jne    80104510 <wakeup+0x70>
                t->state = RUNNABLE;
80104522:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104529:	eb e5                	jmp    80104510 <wakeup+0x70>
    wakeup1(chan);
    release(&ptable.lock);
8010452b:	c7 45 08 20 4e 11 80 	movl   $0x80114e20,0x8(%ebp)
}
80104532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104535:	c9                   	leave  
    release(&ptable.lock);
80104536:	e9 45 0c 00 00       	jmp    80105180 <release>
8010453b:	90                   	nop
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 0)
80104547:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
kill(int pid) {
8010454c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 0)
8010454f:	85 c0                	test   %eax,%eax
80104551:	7e 10                	jle    80104563 <kill+0x23>
        cprintf(" KILL ");
80104553:	83 ec 0c             	sub    $0xc,%esp
80104556:	68 da 83 10 80       	push   $0x801083da
8010455b:	e8 00 c1 ff ff       	call   80100660 <cprintf>
80104560:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
//    struct thread *t;
    ptable.lock.name = "KILL";
    acquire(&ptable.lock);
80104563:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "KILL";
80104566:	c7 05 24 4e 11 80 e1 	movl   $0x801083e1,0x80114e24
8010456d:	83 10 80 
    acquire(&ptable.lock);
80104570:	68 20 4e 11 80       	push   $0x80114e20
80104575:	e8 36 0b 00 00       	call   801050b0 <acquire>
8010457a:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010457d:	b8 58 4e 11 80       	mov    $0x80114e58,%eax
80104582:	eb 10                	jmp    80104594 <kill+0x54>
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104588:	05 7c 03 00 00       	add    $0x37c,%eax
8010458d:	3d 58 2d 12 80       	cmp    $0x80122d58,%eax
80104592:	73 4c                	jae    801045e0 <kill+0xa0>
        if (p->pid == pid) {
80104594:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104597:	75 ef                	jne    80104588 <kill+0x48>
            //turn on killed flags of the proc threads
//            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
//                t->killed = 1;
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->state == SLEEPING) {
80104599:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
            p->killed = 1;
8010459d:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
            if (p->state == SLEEPING) {
801045a4:	74 1a                	je     801045c0 <kill+0x80>
                    p->mainThread->state = RUNNABLE;
//                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
            }

            //release( p->procLock );
            release(&ptable.lock);
801045a6:	83 ec 0c             	sub    $0xc,%esp
801045a9:	68 20 4e 11 80       	push   $0x80114e20
801045ae:	e8 cd 0b 00 00       	call   80105180 <release>
            return 0;
801045b3:	83 c4 10             	add    $0x10,%esp
801045b6:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801045b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045bb:	c9                   	leave  
801045bc:	c3                   	ret    
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
                p->state = RUNNABLE;
801045c0:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
                if (p->mainThread->state == SLEEPING)
801045c7:	8b 80 74 03 00 00    	mov    0x374(%eax),%eax
801045cd:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801045d1:	75 d3                	jne    801045a6 <kill+0x66>
                    p->mainThread->state = RUNNABLE;
801045d3:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801045da:	eb ca                	jmp    801045a6 <kill+0x66>
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801045e0:	83 ec 0c             	sub    $0xc,%esp
801045e3:	68 20 4e 11 80       	push   $0x80114e20
801045e8:	e8 93 0b 00 00       	call   80105180 <release>
    return -1;
801045ed:	83 c4 10             	add    $0x10,%esp
801045f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f8:	c9                   	leave  
801045f9:	c3                   	ret    
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	56                   	push   %esi
80104605:	53                   	push   %ebx
80104606:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104609:	bb 58 4e 11 80       	mov    $0x80114e58,%ebx
procdump(void) {
8010460e:	83 ec 3c             	sub    $0x3c,%esp
80104611:	eb 27                	jmp    8010463a <procdump+0x3a>
80104613:	90                   	nop
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	68 a7 87 10 80       	push   $0x801087a7
80104620:	e8 3b c0 ff ff       	call   80100660 <cprintf>
80104625:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104628:	81 c3 7c 03 00 00    	add    $0x37c,%ebx
8010462e:	81 fb 58 2d 12 80    	cmp    $0x80122d58,%ebx
80104634:	0f 83 96 00 00 00    	jae    801046d0 <procdump+0xd0>
        if (p->state == UNUSED)
8010463a:	8b 43 08             	mov    0x8(%ebx),%eax
8010463d:	85 c0                	test   %eax,%eax
8010463f:	74 e7                	je     80104628 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104641:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104644:	ba e6 83 10 80       	mov    $0x801083e6,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104649:	77 11                	ja     8010465c <procdump+0x5c>
8010464b:	8b 14 85 80 84 10 80 	mov    -0x7fef7b80(,%eax,4),%edx
            state = "???";
80104652:	b8 e6 83 10 80       	mov    $0x801083e6,%eax
80104657:	85 d2                	test   %edx,%edx
80104659:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010465c:	8d 43 64             	lea    0x64(%ebx),%eax
8010465f:	50                   	push   %eax
80104660:	52                   	push   %edx
80104661:	ff 73 0c             	pushl  0xc(%ebx)
80104664:	68 ea 83 10 80       	push   $0x801083ea
80104669:	e8 f2 bf ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
8010466e:	8b 83 74 03 00 00    	mov    0x374(%ebx),%eax
80104674:	83 c4 10             	add    $0x10,%esp
80104677:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010467b:	75 9b                	jne    80104618 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
8010467d:	8d 4d c0             	lea    -0x40(%ebp),%ecx
80104680:	83 ec 08             	sub    $0x8,%esp
80104683:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104686:	51                   	push   %ecx
80104687:	8b 40 14             	mov    0x14(%eax),%eax
8010468a:	8b 40 0c             	mov    0xc(%eax),%eax
8010468d:	83 c0 08             	add    $0x8,%eax
80104690:	50                   	push   %eax
80104691:	e8 fa 08 00 00       	call   80104f90 <getcallerpcs>
80104696:	83 c4 10             	add    $0x10,%esp
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801046a0:	8b 17                	mov    (%edi),%edx
801046a2:	85 d2                	test   %edx,%edx
801046a4:	0f 84 6e ff ff ff    	je     80104618 <procdump+0x18>
                cprintf(" %p", pc[i]);
801046aa:	83 ec 08             	sub    $0x8,%esp
801046ad:	83 c7 04             	add    $0x4,%edi
801046b0:	52                   	push   %edx
801046b1:	68 41 7d 10 80       	push   $0x80107d41
801046b6:	e8 a5 bf ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801046bb:	83 c4 10             	add    $0x10,%esp
801046be:	39 fe                	cmp    %edi,%esi
801046c0:	75 de                	jne    801046a0 <procdump+0xa0>
801046c2:	e9 51 ff ff ff       	jmp    80104618 <procdump+0x18>
801046c7:	89 f6                	mov    %esi,%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
}
801046d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046d3:	5b                   	pop    %ebx
801046d4:	5e                   	pop    %esi
801046d5:	5f                   	pop    %edi
801046d6:	5d                   	pop    %ebp
801046d7:	c3                   	ret    
801046d8:	90                   	nop
801046d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046e0 <kthread_create>:

//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
    pushcli();
801046e5:	e8 f6 08 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
801046ea:	e8 81 f1 ff ff       	call   80103870 <mycpu>
    p = c->proc;
801046ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801046f5:	e8 26 09 00 00       	call   80105020 <popcli>
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    ptable.lock.name = "KTHREADCREATE";
    acquire(&ptable.lock);
801046fa:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "KTHREADCREATE";
801046fd:	c7 05 24 4e 11 80 f3 	movl   $0x801083f3,0x80114e24
80104704:	83 10 80 
    acquire(&ptable.lock);
80104707:	68 20 4e 11 80       	push   $0x80114e20
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010470c:	8d 5e 74             	lea    0x74(%esi),%ebx
    acquire(&ptable.lock);
8010470f:	e8 9c 09 00 00       	call   801050b0 <acquire>
        if (t->state == UNUSED)
80104714:	8b 46 7c             	mov    0x7c(%esi),%eax
80104717:	83 c4 10             	add    $0x10,%esp
8010471a:	85 c0                	test   %eax,%eax
8010471c:	74 42                	je     80104760 <kthread_create+0x80>
8010471e:	8d 86 74 03 00 00    	lea    0x374(%esi),%eax
80104724:	eb 11                	jmp    80104737 <kthread_create+0x57>
80104726:	8d 76 00             	lea    0x0(%esi),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104730:	8b 73 08             	mov    0x8(%ebx),%esi
80104733:	85 f6                	test   %esi,%esi
80104735:	74 29                	je     80104760 <kthread_create+0x80>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104737:	83 c3 30             	add    $0x30,%ebx
8010473a:	39 c3                	cmp    %eax,%ebx
8010473c:	72 f2                	jb     80104730 <kthread_create+0x50>
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
8010473e:	83 ec 0c             	sub    $0xc,%esp
80104741:	68 20 4e 11 80       	push   $0x80114e20
80104746:	e8 35 0a 00 00       	call   80105180 <release>
        return -1;
8010474b:	83 c4 10             	add    $0x10,%esp
//    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
8010474e:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
80104751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104756:	5b                   	pop    %ebx
80104757:	5e                   	pop    %esi
80104758:	5d                   	pop    %ebp
80104759:	c3                   	ret    
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    t->tid = tidCounter++;
80104760:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    t->state = EMBRYO;
80104765:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    t->tid = tidCounter++;
8010476c:	8d 50 01             	lea    0x1(%eax),%edx
8010476f:	89 43 0c             	mov    %eax,0xc(%ebx)
80104772:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
    if ((t->tkstack = kalloc()) == 0) {
80104778:	e8 73 dd ff ff       	call   801024f0 <kalloc>
8010477d:	85 c0                	test   %eax,%eax
8010477f:	89 43 04             	mov    %eax,0x4(%ebx)
80104782:	0f 84 d6 00 00 00    	je     8010485e <kthread_create+0x17e>
    sp -= sizeof *t->tf;
80104788:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(t->context, 0, sizeof *t->context);
8010478e:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
80104791:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
80104796:	89 53 10             	mov    %edx,0x10(%ebx)
    *(uint *) sp = (uint) trapret;
80104799:	c7 40 14 7f 64 10 80 	movl   $0x8010647f,0x14(%eax)
    t->context = (struct context *) sp;
801047a0:	89 43 14             	mov    %eax,0x14(%ebx)
    memset(t->context, 0, sizeof *t->context);
801047a3:	6a 14                	push   $0x14
801047a5:	6a 00                	push   $0x0
801047a7:	50                   	push   %eax
801047a8:	e8 23 0a 00 00       	call   801051d0 <memset>
    t->context->eip = (uint) forkret;
801047ad:	8b 43 14             	mov    0x14(%ebx),%eax
    memset(t->tf, 0, sizeof(*t->tf));
801047b0:	83 c4 0c             	add    $0xc,%esp
    t->context->eip = (uint) forkret;
801047b3:	c7 40 10 70 37 10 80 	movl   $0x80103770,0x10(%eax)
    memset(t->tf, 0, sizeof(*t->tf));
801047ba:	6a 4c                	push   $0x4c
801047bc:	6a 00                	push   $0x0
801047be:	ff 73 10             	pushl  0x10(%ebx)
801047c1:	e8 0a 0a 00 00       	call   801051d0 <memset>
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047c6:	8b 43 10             	mov    0x10(%ebx),%eax
801047c9:	ba 1b 00 00 00       	mov    $0x1b,%edx
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047ce:	b9 23 00 00 00       	mov    $0x23,%ecx
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047d3:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047d7:	8b 43 10             	mov    0x10(%ebx),%eax
801047da:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    t->tf->es = t->tf->ds;
801047de:	8b 43 10             	mov    0x10(%ebx),%eax
801047e1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801047e5:	66 89 50 28          	mov    %dx,0x28(%eax)
    t->tf->ss = t->tf->ds;
801047e9:	8b 43 10             	mov    0x10(%ebx),%eax
801047ec:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801047f0:	66 89 50 48          	mov    %dx,0x48(%eax)
    t->tf->eflags = FL_IF;
801047f4:	8b 43 10             	mov    0x10(%ebx),%eax
    t->tf->eip = (uint) start_func;  // beginning of run func
801047f7:	8b 55 08             	mov    0x8(%ebp),%edx
    t->tf->eflags = FL_IF;
801047fa:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    t->tf->esp = PGSIZE;
80104801:	8b 43 10             	mov    0x10(%ebx),%eax
80104804:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    t->tf->eip = (uint) start_func;  // beginning of run func
8010480b:	8b 43 10             	mov    0x10(%ebx),%eax
8010480e:	89 50 38             	mov    %edx,0x38(%eax)
    pushcli();
80104811:	e8 ca 07 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80104816:	e8 55 f0 ff ff       	call   80103870 <mycpu>
    p = c->proc;
8010481b:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104821:	e8 fa 07 00 00       	call   80105020 <popcli>
    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
80104826:	8d 43 1c             	lea    0x1c(%ebx),%eax
80104829:	83 c4 0c             	add    $0xc,%esp
8010482c:	83 c6 64             	add    $0x64,%esi
8010482f:	6a 10                	push   $0x10
80104831:	56                   	push   %esi
80104832:	50                   	push   %eax
80104833:	e8 78 0b 00 00       	call   801053b0 <safestrcpy>
    t->chan = 0;
80104838:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    t->state = RUNNABLE;
8010483f:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    release(&ptable.lock);
80104846:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
8010484d:	e8 2e 09 00 00       	call   80105180 <release>
    return 0;
80104852:	83 c4 10             	add    $0x10,%esp
}
80104855:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80104858:	31 c0                	xor    %eax,%eax
}
8010485a:	5b                   	pop    %ebx
8010485b:	5e                   	pop    %esi
8010485c:	5d                   	pop    %ebp
8010485d:	c3                   	ret    
        t->state = UNUSED;
8010485e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80104865:	e9 d4 fe ff ff       	jmp    8010473e <kthread_create+0x5e>
8010486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104870 <kthread_id>:

//this func haven't been used - it's implementation is in sysproc
int kthread_id() {
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104877:	e8 64 07 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
8010487c:	e8 ef ef ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104881:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104887:	e8 94 07 00 00       	call   80105020 <popcli>
    return mythread()->tid;
8010488c:	8b 43 0c             	mov    0xc(%ebx),%eax
}
8010488f:	83 c4 04             	add    $0x4,%esp
80104892:	5b                   	pop    %ebx
80104893:	5d                   	pop    %ebp
80104894:	c3                   	ret    
80104895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <kthread_exit>:

void kthread_exit() {
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801048a7:	e8 34 07 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
801048ac:	e8 bf ef ff ff       	call   80103870 <mycpu>
    p = c->proc;
801048b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801048b7:	e8 64 07 00 00       	call   80105020 <popcli>
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    ptable.lock.name = "KTHREADEXIT";
    acquire(&ptable.lock);
801048bc:	83 ec 0c             	sub    $0xc,%esp
    ptable.lock.name = "KTHREADEXIT";
801048bf:	c7 05 24 4e 11 80 01 	movl   $0x80108401,0x80114e24
801048c6:	84 10 80 
    acquire(&ptable.lock);
801048c9:	68 20 4e 11 80       	push   $0x80114e20
801048ce:	e8 dd 07 00 00       	call   801050b0 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801048d3:	8d 43 74             	lea    0x74(%ebx),%eax
801048d6:	8d 8b 74 03 00 00    	lea    0x374(%ebx),%ecx
801048dc:	83 c4 10             	add    $0x10,%esp
    int counter = 0;
801048df:	31 db                	xor    %ebx,%ebx
801048e1:	eb 11                	jmp    801048f4 <kthread_exit+0x54>
801048e3:	90                   	nop
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (t->state == UNUSED || t->state == ZOMBIE)
801048e8:	83 fa 05             	cmp    $0x5,%edx
801048eb:	74 0e                	je     801048fb <kthread_exit+0x5b>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801048ed:	83 c0 30             	add    $0x30,%eax
801048f0:	39 c8                	cmp    %ecx,%eax
801048f2:	73 11                	jae    80104905 <kthread_exit+0x65>
        if (t->state == UNUSED || t->state == ZOMBIE)
801048f4:	8b 50 08             	mov    0x8(%eax),%edx
801048f7:	85 d2                	test   %edx,%edx
801048f9:	75 ed                	jne    801048e8 <kthread_exit+0x48>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801048fb:	83 c0 30             	add    $0x30,%eax
            counter++;
801048fe:	83 c3 01             	add    $0x1,%ebx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104901:	39 c8                	cmp    %ecx,%eax
80104903:	72 ef                	jb     801048f4 <kthread_exit+0x54>
    }
    if (counter == (NTHREADS - 1)) { //all other threads aren't available -> close proc
80104905:	83 fb 0f             	cmp    $0xf,%ebx
80104908:	74 1d                	je     80104927 <kthread_exit+0x87>
        release(&ptable.lock);
        exit();
    } else {   //there are other threads in the same proc - close just the specific thread
        cleanThread(t);
8010490a:	83 ec 0c             	sub    $0xc,%esp
8010490d:	50                   	push   %eax
8010490e:	e8 fd ee ff ff       	call   80103810 <cleanThread>
        release(&ptable.lock);
80104913:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
8010491a:	e8 61 08 00 00       	call   80105180 <release>
    }
}
8010491f:	83 c4 10             	add    $0x10,%esp
80104922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104925:	c9                   	leave  
80104926:	c3                   	ret    
        release(&ptable.lock);
80104927:	83 ec 0c             	sub    $0xc,%esp
8010492a:	68 20 4e 11 80       	push   $0x80114e20
8010492f:	e8 4c 08 00 00       	call   80105180 <release>
        exit();
80104934:	e8 17 f8 ff ff       	call   80104150 <exit>
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104940 <kthread_join>:

int kthread_join(int thread_id) {
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 10             	sub    $0x10,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
8010494a:	68 20 4e 11 80       	push   $0x80114e20
8010494f:	e8 5c 07 00 00       	call   801050b0 <acquire>
80104954:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104957:	ba 58 4e 11 80       	mov    $0x80114e58,%edx
8010495c:	eb 10                	jmp    8010496e <kthread_join+0x2e>
8010495e:	66 90                	xchg   %ax,%ax
80104960:	81 c2 7c 03 00 00    	add    $0x37c,%edx
80104966:	81 fa 58 2d 12 80    	cmp    $0x80122d58,%edx
8010496c:	73 72                	jae    801049e0 <kthread_join+0xa0>
        if (p->state != UNUSED) {
8010496e:	8b 42 08             	mov    0x8(%edx),%eax
80104971:	85 c0                	test   %eax,%eax
80104973:	74 eb                	je     80104960 <kthread_join+0x20>
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->tid == thread_id)
80104975:	39 9a 80 00 00 00    	cmp    %ebx,0x80(%edx)
8010497b:	8d 42 74             	lea    0x74(%edx),%eax
8010497e:	8d 8a 74 03 00 00    	lea    0x374(%edx),%ecx
80104984:	74 16                	je     8010499c <kthread_join+0x5c>
80104986:	8d 76 00             	lea    0x0(%esi),%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104990:	83 c0 30             	add    $0x30,%eax
80104993:	39 c8                	cmp    %ecx,%eax
80104995:	73 c9                	jae    80104960 <kthread_join+0x20>
                if (t->tid == thread_id)
80104997:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010499a:	75 f4                	jne    80104990 <kthread_join+0x50>
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
    return -1;
    found2:
    if (t->state == UNUSED || t->state == ZOMBIE) {
8010499c:	8b 50 08             	mov    0x8(%eax),%edx
8010499f:	85 d2                	test   %edx,%edx
801049a1:	74 3d                	je     801049e0 <kthread_join+0xa0>
801049a3:	83 fa 05             	cmp    $0x5,%edx
801049a6:	74 38                	je     801049e0 <kthread_join+0xa0>
        release(&ptable.lock);
        return -1;
    }
    sleep(t, &ptable.lock);
801049a8:	83 ec 08             	sub    $0x8,%esp
801049ab:	68 20 4e 11 80       	push   $0x80114e20
801049b0:	50                   	push   %eax
801049b1:	e8 ea f5 ff ff       	call   80103fa0 <sleep>
    //TODO - not sure about release
    if (holding(&ptable.lock))
801049b6:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
801049bd:	e8 be 06 00 00       	call   80105080 <holding>
801049c2:	83 c4 10             	add    $0x10,%esp
801049c5:	85 c0                	test   %eax,%eax
801049c7:	74 12                	je     801049db <kthread_join+0x9b>
        release(&ptable.lock);
801049c9:	83 ec 0c             	sub    $0xc,%esp
801049cc:	68 20 4e 11 80       	push   $0x80114e20
801049d1:	e8 aa 07 00 00       	call   80105180 <release>
801049d6:	83 c4 10             	add    $0x10,%esp
    return 0;
801049d9:	31 c0                	xor    %eax,%eax
}
801049db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049de:	c9                   	leave  
801049df:	c3                   	ret    
    release(&ptable.lock);
801049e0:	83 ec 0c             	sub    $0xc,%esp
801049e3:	68 20 4e 11 80       	push   $0x80114e20
801049e8:	e8 93 07 00 00       	call   80105180 <release>
    return -1;
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f8:	c9                   	leave  
801049f9:	c3                   	ret    
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a00 <kthread_mutex_alloc>:


int
kthread_mutex_alloc() {
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
80104a04:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx
kthread_mutex_alloc() {
80104a09:	83 ec 10             	sub    $0x10,%esp
    acquire(&mtable.lock);
80104a0c:	68 e0 3e 11 80       	push   $0x80113ee0
80104a11:	e8 9a 06 00 00       	call   801050b0 <acquire>
80104a16:	83 c4 10             	add    $0x10,%esp
80104a19:	eb 10                	jmp    80104a2b <kthread_mutex_alloc+0x2b>
80104a1b:	90                   	nop
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
80104a20:	83 c3 3c             	add    $0x3c,%ebx
80104a23:	81 fb 18 4e 11 80    	cmp    $0x80114e18,%ebx
80104a29:	73 55                	jae    80104a80 <kthread_mutex_alloc+0x80>
        if (!m->active)
80104a2b:	8b 43 04             	mov    0x4(%ebx),%eax
80104a2e:	85 c0                	test   %eax,%eax
80104a30:	75 ee                	jne    80104a20 <kthread_mutex_alloc+0x20>
    return -1;

    alloc_mutex:
    m->waitingCounter = 0;
    m->active = 1;
    m->mid = mutexCounter++;
80104a32:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
80104a37:	83 ec 0c             	sub    $0xc,%esp
    m->waitingCounter = 0;
80104a3a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    release(&mtable.lock);
80104a41:	68 e0 3e 11 80       	push   $0x80113ee0
    m->active = 1;
80104a46:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
    m->locked = 0;
80104a4d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    m->thread = 0;
80104a53:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    m->mid = mutexCounter++;
80104a5a:	8d 50 01             	lea    0x1(%eax),%edx
80104a5d:	89 43 08             	mov    %eax,0x8(%ebx)
80104a60:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&mtable.lock);
80104a66:	e8 15 07 00 00       	call   80105180 <release>
    return m->mid;
80104a6b:	8b 43 08             	mov    0x8(%ebx),%eax
80104a6e:	83 c4 10             	add    $0x10,%esp


}
80104a71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a74:	c9                   	leave  
80104a75:	c3                   	ret    
80104a76:	8d 76 00             	lea    0x0(%esi),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&mtable.lock);
80104a80:	83 ec 0c             	sub    $0xc,%esp
80104a83:	68 e0 3e 11 80       	push   $0x80113ee0
80104a88:	e8 f3 06 00 00       	call   80105180 <release>
    return -1;
80104a8d:	83 c4 10             	add    $0x10,%esp
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a98:	c9                   	leave  
80104a99:	c3                   	ret    
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <kthread_mutex_dealloc>:


int
kthread_mutex_dealloc(int mutex_id) {
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 10             	sub    $0x10,%esp
80104aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);
80104aaa:	68 e0 3e 11 80       	push   $0x80113ee0
80104aaf:	e8 fc 05 00 00       	call   801050b0 <acquire>
80104ab4:	83 c4 10             	add    $0x10,%esp

    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
80104ab7:	b8 18 3f 11 80       	mov    $0x80113f18,%eax
80104abc:	eb 0c                	jmp    80104aca <kthread_mutex_dealloc+0x2a>
80104abe:	66 90                	xchg   %ax,%ax
80104ac0:	83 c0 3c             	add    $0x3c,%eax
80104ac3:	3d 18 4e 11 80       	cmp    $0x80114e18,%eax
80104ac8:	73 46                	jae    80104b10 <kthread_mutex_dealloc+0x70>
        if (m->mid == mutex_id) {
80104aca:	39 58 08             	cmp    %ebx,0x8(%eax)
80104acd:	75 f1                	jne    80104ac0 <kthread_mutex_dealloc+0x20>
            if (m->locked || m->waitingCounter > 0) {
80104acf:	8b 08                	mov    (%eax),%ecx
80104ad1:	85 c9                	test   %ecx,%ecx
80104ad3:	75 3b                	jne    80104b10 <kthread_mutex_dealloc+0x70>
80104ad5:	8b 50 0c             	mov    0xc(%eax),%edx
80104ad8:	85 d2                	test   %edx,%edx
80104ada:	7f 34                	jg     80104b10 <kthread_mutex_dealloc+0x70>
    dealloc_mutex:
    m->active = 0;
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
80104adc:	83 ec 0c             	sub    $0xc,%esp
    m->active = 0;
80104adf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    m->mid = -1;
80104ae6:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
    m->thread = 0;
80104aed:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    release(&mtable.lock);
80104af4:	68 e0 3e 11 80       	push   $0x80113ee0
80104af9:	e8 82 06 00 00       	call   80105180 <release>
    return 0;
80104afe:	83 c4 10             	add    $0x10,%esp
80104b01:	31 c0                	xor    %eax,%eax
}
80104b03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b06:	c9                   	leave  
80104b07:	c3                   	ret    
80104b08:	90                   	nop
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                release(&mtable.lock);
80104b10:	83 ec 0c             	sub    $0xc,%esp
80104b13:	68 e0 3e 11 80       	push   $0x80113ee0
80104b18:	e8 63 06 00 00       	call   80105180 <release>
                return -1;
80104b1d:	83 c4 10             	add    $0x10,%esp
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b28:	c9                   	leave  
80104b29:	c3                   	ret    
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b30 <mgetcallerpcs>:


// Record the current call stack in pcs[] by following the %ebp chain.
// TODO NOT OUR CODE MIGHT BE REMOVED
void
mgetcallerpcs(void *v, uint pcs[]) {
80104b30:	55                   	push   %ebp
    uint *ebp;
    int i;

    ebp = (uint *) v - 2;
    for (i = 0; i < 10; i++) {
80104b31:	31 d2                	xor    %edx,%edx
mgetcallerpcs(void *v, uint pcs[]) {
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	53                   	push   %ebx
    ebp = (uint *) v - 2;
80104b36:	8b 45 08             	mov    0x8(%ebp),%eax
mgetcallerpcs(void *v, uint pcs[]) {
80104b39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    ebp = (uint *) v - 2;
80104b3c:	83 e8 08             	sub    $0x8,%eax
80104b3f:	90                   	nop
        if (ebp == 0 || ebp < (uint *) KERNBASE || ebp == (uint *) 0xffffffff)
80104b40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b4c:	77 1a                	ja     80104b68 <mgetcallerpcs+0x38>
            break;
        pcs[i] = ebp[1];     // saved %eip
80104b4e:	8b 58 04             	mov    0x4(%eax),%ebx
80104b51:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for (i = 0; i < 10; i++) {
80104b54:	83 c2 01             	add    $0x1,%edx
        ebp = (uint *) ebp[0]; // saved %ebp
80104b57:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104b59:	83 fa 0a             	cmp    $0xa,%edx
80104b5c:	75 e2                	jne    80104b40 <mgetcallerpcs+0x10>
    }
    for (; i < 10; i++)
        pcs[i] = 0;
}
80104b5e:	5b                   	pop    %ebx
80104b5f:	5d                   	pop    %ebp
80104b60:	c3                   	ret    
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b68:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b6b:	83 c1 28             	add    $0x28,%ecx
80104b6e:	66 90                	xchg   %ax,%ax
        pcs[i] = 0;
80104b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b76:	83 c0 04             	add    $0x4,%eax
    for (; i < 10; i++)
80104b79:	39 c1                	cmp    %eax,%ecx
80104b7b:	75 f3                	jne    80104b70 <mgetcallerpcs+0x40>
}
80104b7d:	5b                   	pop    %ebx
80104b7e:	5d                   	pop    %ebp
80104b7f:	c3                   	ret    

80104b80 <mpushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
mpushcli(void) {
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
80104b87:	9c                   	pushf  
80104b88:	5b                   	pop    %ebx
  asm volatile("cli");
80104b89:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if (mycpu()->ncli == 0)
80104b8a:	e8 e1 ec ff ff       	call   80103870 <mycpu>
80104b8f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b95:	85 c0                	test   %eax,%eax
80104b97:	75 11                	jne    80104baa <mpushcli+0x2a>
        mycpu()->intena = eflags & FL_IF;
80104b99:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b9f:	e8 cc ec ff ff       	call   80103870 <mycpu>
80104ba4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
    mycpu()->ncli += 1;
80104baa:	e8 c1 ec ff ff       	call   80103870 <mycpu>
80104baf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104bb6:	83 c4 04             	add    $0x4,%esp
80104bb9:	5b                   	pop    %ebx
80104bba:	5d                   	pop    %ebp
80104bbb:	c3                   	ret    
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <mpopcli>:

void
mpopcli(void) {
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bc6:	9c                   	pushf  
80104bc7:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80104bc8:	f6 c4 02             	test   $0x2,%ah
80104bcb:	75 35                	jne    80104c02 <mpopcli+0x42>
        panic("popcli - interruptible");
    if (--mycpu()->ncli < 0)
80104bcd:	e8 9e ec ff ff       	call   80103870 <mycpu>
80104bd2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104bd9:	78 34                	js     80104c0f <mpopcli+0x4f>
        panic("popcli");
    if (mycpu()->ncli == 0 && mycpu()->intena)
80104bdb:	e8 90 ec ff ff       	call   80103870 <mycpu>
80104be0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104be6:	85 d2                	test   %edx,%edx
80104be8:	74 06                	je     80104bf0 <mpopcli+0x30>
        sti();
}
80104bea:	c9                   	leave  
80104beb:	c3                   	ret    
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (mycpu()->ncli == 0 && mycpu()->intena)
80104bf0:	e8 7b ec ff ff       	call   80103870 <mycpu>
80104bf5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bfb:	85 c0                	test   %eax,%eax
80104bfd:	74 eb                	je     80104bea <mpopcli+0x2a>
  asm volatile("sti");
80104bff:	fb                   	sti    
}
80104c00:	c9                   	leave  
80104c01:	c3                   	ret    
        panic("popcli - interruptible");
80104c02:	83 ec 0c             	sub    $0xc,%esp
80104c05:	68 0d 84 10 80       	push   $0x8010840d
80104c0a:	e8 81 b7 ff ff       	call   80100390 <panic>
        panic("popcli");
80104c0f:	83 ec 0c             	sub    $0xc,%esp
80104c12:	68 24 84 10 80       	push   $0x80108424
80104c17:	e8 74 b7 ff ff       	call   80100390 <panic>
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c20 <kthread_mutex_lock>:


int
kthread_mutex_lock(int mutex_id) {
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
    acquire(&mtable.lock);

    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
80104c25:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx
kthread_mutex_lock(int mutex_id) {
80104c2a:	83 ec 10             	sub    $0x10,%esp
80104c2d:	8b 75 08             	mov    0x8(%ebp),%esi
    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
80104c30:	e8 4b ff ff ff       	call   80104b80 <mpushcli>
    acquire(&mtable.lock);
80104c35:	83 ec 0c             	sub    $0xc,%esp
80104c38:	68 e0 3e 11 80       	push   $0x80113ee0
80104c3d:	e8 6e 04 00 00       	call   801050b0 <acquire>
    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
80104c42:	c7 45 f4 18 3f 11 80 	movl   $0x80113f18,-0xc(%ebp)
80104c49:	83 c4 10             	add    $0x10,%esp
80104c4c:	31 c0                	xor    %eax,%eax
80104c4e:	66 90                	xchg   %ax,%ax
        if (m->active && m->mid == mutex_id) {
80104c50:	8b 53 04             	mov    0x4(%ebx),%edx
80104c53:	85 d2                	test   %edx,%edx
80104c55:	74 05                	je     80104c5c <kthread_mutex_lock+0x3c>
80104c57:	39 73 08             	cmp    %esi,0x8(%ebx)
80104c5a:	74 34                	je     80104c90 <kthread_mutex_lock+0x70>
    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
80104c5c:	83 c3 3c             	add    $0x3c,%ebx
80104c5f:	b8 01 00 00 00       	mov    $0x1,%eax
80104c64:	81 fb 18 4e 11 80    	cmp    $0x80114e18,%ebx
80104c6a:	72 e4                	jb     80104c50 <kthread_mutex_lock+0x30>
            }
            goto lock_mutex;
        }
    }

    release(&mtable.lock);
80104c6c:	83 ec 0c             	sub    $0xc,%esp
80104c6f:	68 e0 3e 11 80       	push   $0x80113ee0
80104c74:	e8 07 05 00 00       	call   80105180 <release>
    return -1;
80104c79:	83 c4 10             	add    $0x10,%esp
    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
}
80104c7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c84:	5b                   	pop    %ebx
80104c85:	5e                   	pop    %esi
80104c86:	5d                   	pop    %ebp
80104c87:	c3                   	ret    
80104c88:	90                   	nop
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c90:	84 c0                	test   %al,%al
80104c92:	0f 85 c8 00 00 00    	jne    80104d60 <kthread_mutex_lock+0x140>
        if (m->active && m->mid == mutex_id) {
80104c98:	be 18 3f 11 80       	mov    $0x80113f18,%esi
            if (m->locked) {
80104c9d:	8b 03                	mov    (%ebx),%eax
80104c9f:	85 c0                	test   %eax,%eax
80104ca1:	0f 85 99 00 00 00    	jne    80104d40 <kthread_mutex_lock+0x120>
  asm volatile("lock; xchgl %0, %1" :
80104ca7:	ba 01 00 00 00       	mov    $0x1,%edx
80104cac:	eb 05                	jmp    80104cb3 <kthread_mutex_lock+0x93>
80104cae:	66 90                	xchg   %ax,%ax
80104cb0:	8b 75 f4             	mov    -0xc(%ebp),%esi
80104cb3:	89 d0                	mov    %edx,%eax
80104cb5:	f0 87 06             	lock xchg %eax,(%esi)
    while (xchg(&m->locked, 1) != 0);
80104cb8:	85 c0                	test   %eax,%eax
80104cba:	75 f4                	jne    80104cb0 <kthread_mutex_lock+0x90>
    __sync_synchronize();   // << TODO - not our line!!!
80104cbc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    m->thread = mythread();
80104cc1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    pushcli();
80104cc4:	e8 17 03 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80104cc9:	e8 a2 eb ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104cce:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80104cd4:	e8 47 03 00 00       	call   80105020 <popcli>
    mgetcallerpcs(&m, m->pcs);
80104cd9:	8d 4b 14             	lea    0x14(%ebx),%ecx
    ebp = (uint *) v - 2;
80104cdc:	8d 45 ec             	lea    -0x14(%ebp),%eax
    for (i = 0; i < 10; i++) {
80104cdf:	31 d2                	xor    %edx,%edx
    m->thread = mythread();
80104ce1:	89 73 10             	mov    %esi,0x10(%ebx)
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ebp == 0 || ebp < (uint *) KERNBASE || ebp == (uint *) 0xffffffff)
80104ce8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cf4:	77 2a                	ja     80104d20 <kthread_mutex_lock+0x100>
        pcs[i] = ebp[1];     // saved %eip
80104cf6:	8b 58 04             	mov    0x4(%eax),%ebx
80104cf9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for (i = 0; i < 10; i++) {
80104cfc:	83 c2 01             	add    $0x1,%edx
        ebp = (uint *) ebp[0]; // saved %ebp
80104cff:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104d01:	83 fa 0a             	cmp    $0xa,%edx
80104d04:	75 e2                	jne    80104ce8 <kthread_mutex_lock+0xc8>
    release(&mtable.lock);
80104d06:	83 ec 0c             	sub    $0xc,%esp
80104d09:	68 e0 3e 11 80       	push   $0x80113ee0
80104d0e:	e8 6d 04 00 00       	call   80105180 <release>
    return 0;
80104d13:	83 c4 10             	add    $0x10,%esp
}
80104d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80104d19:	31 c0                	xor    %eax,%eax
}
80104d1b:	5b                   	pop    %ebx
80104d1c:	5e                   	pop    %esi
80104d1d:	5d                   	pop    %ebp
80104d1e:	c3                   	ret    
80104d1f:	90                   	nop
80104d20:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d23:	83 c1 28             	add    $0x28,%ecx
80104d26:	8d 76 00             	lea    0x0(%esi),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        pcs[i] = 0;
80104d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d36:	83 c0 04             	add    $0x4,%eax
    for (; i < 10; i++)
80104d39:	39 c1                	cmp    %eax,%ecx
80104d3b:	75 f3                	jne    80104d30 <kthread_mutex_lock+0x110>
80104d3d:	eb c7                	jmp    80104d06 <kthread_mutex_lock+0xe6>
80104d3f:	90                   	nop
                m->waitingCounter++;
80104d40:	83 43 0c 01          	addl   $0x1,0xc(%ebx)
                sleep(m->thread, &mtable.lock);
80104d44:	83 ec 08             	sub    $0x8,%esp
80104d47:	68 e0 3e 11 80       	push   $0x80113ee0
80104d4c:	ff 73 10             	pushl  0x10(%ebx)
80104d4f:	e8 4c f2 ff ff       	call   80103fa0 <sleep>
                m->waitingCounter--;
80104d54:	83 6b 0c 01          	subl   $0x1,0xc(%ebx)
80104d58:	83 c4 10             	add    $0x10,%esp
80104d5b:	e9 47 ff ff ff       	jmp    80104ca7 <kthread_mutex_lock+0x87>
80104d60:	89 5d f4             	mov    %ebx,-0xc(%ebp)
        if (m->active && m->mid == mutex_id) {
80104d63:	89 de                	mov    %ebx,%esi
80104d65:	e9 33 ff ff ff       	jmp    80104c9d <kthread_mutex_lock+0x7d>
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <kthread_mutex_unlock>:

// Release the lock.
int
kthread_mutex_unlock(int mutex_id) {
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
80104d75:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
80104d76:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx
kthread_mutex_unlock(int mutex_id) {
80104d7b:	83 ec 28             	sub    $0x28,%esp
80104d7e:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&mtable.lock);
80104d81:	68 e0 3e 11 80       	push   $0x80113ee0
80104d86:	e8 25 03 00 00       	call   801050b0 <acquire>
80104d8b:	83 c4 10             	add    $0x10,%esp
80104d8e:	eb 0f                	jmp    80104d9f <kthread_mutex_unlock+0x2f>
    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
80104d90:	83 c3 3c             	add    $0x3c,%ebx
80104d93:	81 fb 18 4e 11 80    	cmp    $0x80114e18,%ebx
80104d99:	0f 83 81 00 00 00    	jae    80104e20 <kthread_mutex_unlock+0xb0>
        if (m->active && m->mid == mutex_id && m->locked && m->thread == mythread())
80104d9f:	8b 53 04             	mov    0x4(%ebx),%edx
80104da2:	85 d2                	test   %edx,%edx
80104da4:	74 ea                	je     80104d90 <kthread_mutex_unlock+0x20>
80104da6:	39 73 08             	cmp    %esi,0x8(%ebx)
80104da9:	75 e5                	jne    80104d90 <kthread_mutex_unlock+0x20>
80104dab:	8b 03                	mov    (%ebx),%eax
80104dad:	85 c0                	test   %eax,%eax
80104daf:	74 df                	je     80104d90 <kthread_mutex_unlock+0x20>
80104db1:	8b 7b 10             	mov    0x10(%ebx),%edi
    pushcli();
80104db4:	e8 27 02 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80104db9:	e8 b2 ea ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104dbe:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104dc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80104dc7:	e8 54 02 00 00       	call   80105020 <popcli>
        if (m->active && m->mid == mutex_id && m->locked && m->thread == mythread())
80104dcc:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80104dcf:	75 bf                	jne    80104d90 <kthread_mutex_unlock+0x20>
    release(&mtable.lock);
    return -1;

    unlock_mutex:

    m->pcs[0] = 0;
80104dd1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    m->thread = 0;
80104dd8:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that all the stores in the critical
    // section are visible to other cores before the lock is released.
    // Both the C compiler and the hardware may re-order loads and
    // stores; __sync_synchronize() tells them both not to.
    __sync_synchronize();
80104ddf:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    // Release the lock, equivalent to lk->locked = 0.
    // This code can't use a C assignment, since it might
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );
80104de4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    pushcli();
80104dea:	e8 f1 01 00 00       	call   80104fe0 <pushcli>
    c = mycpu();
80104def:	e8 7c ea ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104df4:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104dfa:	e8 21 02 00 00       	call   80105020 <popcli>

    wakeup(mythread());
80104dff:	83 ec 0c             	sub    $0xc,%esp
80104e02:	53                   	push   %ebx
80104e03:	e8 98 f6 ff ff       	call   801044a0 <wakeup>
    mpopcli();
80104e08:	e8 b3 fd ff ff       	call   80104bc0 <mpopcli>
    return 0;
80104e0d:	83 c4 10             	add    $0x10,%esp
}
80104e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e13:	31 c0                	xor    %eax,%eax
}
80104e15:	5b                   	pop    %ebx
80104e16:	5e                   	pop    %esi
80104e17:	5f                   	pop    %edi
80104e18:	5d                   	pop    %ebp
80104e19:	c3                   	ret    
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&mtable.lock);
80104e20:	83 ec 0c             	sub    $0xc,%esp
80104e23:	68 e0 3e 11 80       	push   $0x80113ee0
80104e28:	e8 53 03 00 00       	call   80105180 <release>
    return -1;
80104e2d:	83 c4 10             	add    $0x10,%esp
}
80104e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80104e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e38:	5b                   	pop    %ebx
80104e39:	5e                   	pop    %esi
80104e3a:	5f                   	pop    %edi
80104e3b:	5d                   	pop    %ebp
80104e3c:	c3                   	ret    
80104e3d:	66 90                	xchg   %ax,%ax
80104e3f:	90                   	nop

80104e40 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	53                   	push   %ebx
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104e4a:	68 98 84 10 80       	push   $0x80108498
80104e4f:	8d 43 04             	lea    0x4(%ebx),%eax
80104e52:	50                   	push   %eax
80104e53:	e8 18 01 00 00       	call   80104f70 <initlock>
  lk->name = name;
80104e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104e5b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104e61:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104e64:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  lk->name = name;
80104e6b:	89 43 3c             	mov    %eax,0x3c(%ebx)
}
80104e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e71:	c9                   	leave  
80104e72:	c3                   	ret    
80104e73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e88:	83 ec 0c             	sub    $0xc,%esp
80104e8b:	8d 73 04             	lea    0x4(%ebx),%esi
80104e8e:	56                   	push   %esi
80104e8f:	e8 1c 02 00 00       	call   801050b0 <acquire>
  while (lk->locked) {
80104e94:	8b 13                	mov    (%ebx),%edx
80104e96:	83 c4 10             	add    $0x10,%esp
80104e99:	85 d2                	test   %edx,%edx
80104e9b:	74 16                	je     80104eb3 <acquiresleep+0x33>
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ea0:	83 ec 08             	sub    $0x8,%esp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	e8 f6 f0 ff ff       	call   80103fa0 <sleep>
  while (lk->locked) {
80104eaa:	8b 03                	mov    (%ebx),%eax
80104eac:	83 c4 10             	add    $0x10,%esp
80104eaf:	85 c0                	test   %eax,%eax
80104eb1:	75 ed                	jne    80104ea0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104eb3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104eb9:	e8 52 ea ff ff       	call   80103910 <myproc>
80104ebe:	8b 40 0c             	mov    0xc(%eax),%eax
80104ec1:	89 43 40             	mov    %eax,0x40(%ebx)
  release(&lk->lk);
80104ec4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ec7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eca:	5b                   	pop    %ebx
80104ecb:	5e                   	pop    %esi
80104ecc:	5d                   	pop    %ebp
  release(&lk->lk);
80104ecd:	e9 ae 02 00 00       	jmp    80105180 <release>
80104ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ee8:	83 ec 0c             	sub    $0xc,%esp
80104eeb:	8d 73 04             	lea    0x4(%ebx),%esi
80104eee:	56                   	push   %esi
80104eef:	e8 bc 01 00 00       	call   801050b0 <acquire>
  lk->locked = 0;
80104ef4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104efa:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  wakeup(lk);
80104f01:	89 1c 24             	mov    %ebx,(%esp)
80104f04:	e8 97 f5 ff ff       	call   801044a0 <wakeup>
  release(&lk->lk);
80104f09:	89 75 08             	mov    %esi,0x8(%ebp)
80104f0c:	83 c4 10             	add    $0x10,%esp
}
80104f0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f12:	5b                   	pop    %ebx
80104f13:	5e                   	pop    %esi
80104f14:	5d                   	pop    %ebp
  release(&lk->lk);
80104f15:	e9 66 02 00 00       	jmp    80105180 <release>
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
80104f26:	31 ff                	xor    %edi,%edi
80104f28:	83 ec 18             	sub    $0x18,%esp
80104f2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104f2e:	8d 73 04             	lea    0x4(%ebx),%esi
80104f31:	56                   	push   %esi
80104f32:	e8 79 01 00 00       	call   801050b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104f37:	8b 03                	mov    (%ebx),%eax
80104f39:	83 c4 10             	add    $0x10,%esp
80104f3c:	85 c0                	test   %eax,%eax
80104f3e:	74 13                	je     80104f53 <holdingsleep+0x33>
80104f40:	8b 5b 40             	mov    0x40(%ebx),%ebx
80104f43:	e8 c8 e9 ff ff       	call   80103910 <myproc>
80104f48:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104f4b:	0f 94 c0             	sete   %al
80104f4e:	0f b6 c0             	movzbl %al,%eax
80104f51:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104f53:	83 ec 0c             	sub    $0xc,%esp
80104f56:	56                   	push   %esi
80104f57:	e8 24 02 00 00       	call   80105180 <release>
  return r;
}
80104f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f5f:	89 f8                	mov    %edi,%eax
80104f61:	5b                   	pop    %ebx
80104f62:	5e                   	pop    %esi
80104f63:	5f                   	pop    %edi
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    
80104f66:	66 90                	xchg   %ax,%ax
80104f68:	66 90                	xchg   %ax,%ax
80104f6a:	66 90                	xchg   %ax,%ax
80104f6c:	66 90                	xchg   %ax,%ax
80104f6e:	66 90                	xchg   %ax,%ax

80104f70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104f79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104f7f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104f82:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
80104f89:	5d                   	pop    %ebp
80104f8a:	c3                   	ret    
80104f8b:	90                   	nop
80104f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f90:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f91:	31 d2                	xor    %edx,%edx
{
80104f93:	89 e5                	mov    %esp,%ebp
80104f95:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104f96:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104f99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104f9c:	83 e8 08             	sub    $0x8,%eax
80104f9f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fa0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104fa6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104fac:	77 1a                	ja     80104fc8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104fae:	8b 58 04             	mov    0x4(%eax),%ebx
80104fb1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104fb4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104fb7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104fb9:	83 fa 0a             	cmp    $0xa,%edx
80104fbc:	75 e2                	jne    80104fa0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104fbe:	5b                   	pop    %ebx
80104fbf:	5d                   	pop    %ebp
80104fc0:	c3                   	ret    
80104fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104fcb:	83 c1 28             	add    $0x28,%ecx
80104fce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104fd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104fd6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104fd9:	39 c1                	cmp    %eax,%ecx
80104fdb:	75 f3                	jne    80104fd0 <getcallerpcs+0x40>
}
80104fdd:	5b                   	pop    %ebx
80104fde:	5d                   	pop    %ebp
80104fdf:	c3                   	ret    

80104fe0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	53                   	push   %ebx
80104fe4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104fe7:	9c                   	pushf  
80104fe8:	5b                   	pop    %ebx
  asm volatile("cli");
80104fe9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104fea:	e8 81 e8 ff ff       	call   80103870 <mycpu>
80104fef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	75 11                	jne    8010500a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104ff9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104fff:	e8 6c e8 ff ff       	call   80103870 <mycpu>
80105004:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010500a:	e8 61 e8 ff ff       	call   80103870 <mycpu>
8010500f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105016:	83 c4 04             	add    $0x4,%esp
80105019:	5b                   	pop    %ebx
8010501a:	5d                   	pop    %ebp
8010501b:	c3                   	ret    
8010501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105020 <popcli>:

void
popcli(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105026:	9c                   	pushf  
80105027:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105028:	f6 c4 02             	test   $0x2,%ah
8010502b:	75 35                	jne    80105062 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010502d:	e8 3e e8 ff ff       	call   80103870 <mycpu>
80105032:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105039:	78 34                	js     8010506f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010503b:	e8 30 e8 ff ff       	call   80103870 <mycpu>
80105040:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105046:	85 d2                	test   %edx,%edx
80105048:	74 06                	je     80105050 <popcli+0x30>
    sti();
}
8010504a:	c9                   	leave  
8010504b:	c3                   	ret    
8010504c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105050:	e8 1b e8 ff ff       	call   80103870 <mycpu>
80105055:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010505b:	85 c0                	test   %eax,%eax
8010505d:	74 eb                	je     8010504a <popcli+0x2a>
  asm volatile("sti");
8010505f:	fb                   	sti    
}
80105060:	c9                   	leave  
80105061:	c3                   	ret    
    panic("popcli - interruptible");
80105062:	83 ec 0c             	sub    $0xc,%esp
80105065:	68 0d 84 10 80       	push   $0x8010840d
8010506a:	e8 21 b3 ff ff       	call   80100390 <panic>
    panic("popcli");
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	68 24 84 10 80       	push   $0x80108424
80105077:	e8 14 b3 ff ff       	call   80100390 <panic>
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <holding>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
80105085:	8b 75 08             	mov    0x8(%ebp),%esi
80105088:	31 db                	xor    %ebx,%ebx
  pushcli();
8010508a:	e8 51 ff ff ff       	call   80104fe0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010508f:	8b 06                	mov    (%esi),%eax
80105091:	85 c0                	test   %eax,%eax
80105093:	74 10                	je     801050a5 <holding+0x25>
80105095:	8b 5e 0c             	mov    0xc(%esi),%ebx
80105098:	e8 d3 e7 ff ff       	call   80103870 <mycpu>
8010509d:	39 c3                	cmp    %eax,%ebx
8010509f:	0f 94 c3             	sete   %bl
801050a2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801050a5:	e8 76 ff ff ff       	call   80105020 <popcli>
}
801050aa:	89 d8                	mov    %ebx,%eax
801050ac:	5b                   	pop    %ebx
801050ad:	5e                   	pop    %esi
801050ae:	5d                   	pop    %ebp
801050af:	c3                   	ret    

801050b0 <acquire>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801050b5:	e8 26 ff ff ff       	call   80104fe0 <pushcli>
  if(holding(lk)) {
801050ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050bd:	83 ec 0c             	sub    $0xc,%esp
801050c0:	53                   	push   %ebx
801050c1:	e8 ba ff ff ff       	call   80105080 <holding>
801050c6:	83 c4 10             	add    $0x10,%esp
801050c9:	85 c0                	test   %eax,%eax
801050cb:	0f 85 83 00 00 00    	jne    80105154 <acquire+0xa4>
801050d1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801050d3:	ba 01 00 00 00       	mov    $0x1,%edx
801050d8:	eb 09                	jmp    801050e3 <acquire+0x33>
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050e3:	89 d0                	mov    %edx,%eax
801050e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801050e8:	85 c0                	test   %eax,%eax
801050ea:	75 f4                	jne    801050e0 <acquire+0x30>
  __sync_synchronize();
801050ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801050f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050f4:	e8 77 e7 ff ff       	call   80103870 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801050f9:	8d 53 10             	lea    0x10(%ebx),%edx
  lk->cpu = mycpu();
801050fc:	89 43 0c             	mov    %eax,0xc(%ebx)
  ebp = (uint*)v - 2;
801050ff:	89 e8                	mov    %ebp,%eax
80105101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105108:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010510e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105114:	77 1a                	ja     80105130 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105116:	8b 48 04             	mov    0x4(%eax),%ecx
80105119:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010511c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010511f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105121:	83 fe 0a             	cmp    $0xa,%esi
80105124:	75 e2                	jne    80105108 <acquire+0x58>
}
80105126:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105129:	5b                   	pop    %ebx
8010512a:	5e                   	pop    %esi
8010512b:	5d                   	pop    %ebp
8010512c:	c3                   	ret    
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
80105130:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105133:	83 c2 28             	add    $0x28,%edx
80105136:	8d 76 00             	lea    0x0(%esi),%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105146:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105149:	39 d0                	cmp    %edx,%eax
8010514b:	75 f3                	jne    80105140 <acquire+0x90>
}
8010514d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105150:	5b                   	pop    %ebx
80105151:	5e                   	pop    %esi
80105152:	5d                   	pop    %ebp
80105153:	c3                   	ret    
    cprintf(" PANIC, %s \t %s \t %s", lk->name , lk->namee , mythread()->name  );
80105154:	e8 e7 e7 ff ff       	call   80103940 <mythread>
80105159:	83 c0 1c             	add    $0x1c,%eax
8010515c:	50                   	push   %eax
8010515d:	ff 73 08             	pushl  0x8(%ebx)
80105160:	ff 73 04             	pushl  0x4(%ebx)
80105163:	68 a3 84 10 80       	push   $0x801084a3
80105168:	e8 f3 b4 ff ff       	call   80100660 <cprintf>
    panic("acquire");
8010516d:	c7 04 24 b8 84 10 80 	movl   $0x801084b8,(%esp)
80105174:	e8 17 b2 ff ff       	call   80100390 <panic>
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105180 <release>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 10             	sub    $0x10,%esp
80105187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010518a:	53                   	push   %ebx
8010518b:	e8 f0 fe ff ff       	call   80105080 <holding>
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	85 c0                	test   %eax,%eax
80105195:	74 22                	je     801051b9 <release+0x39>
  lk->pcs[0] = 0;
80105197:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  lk->cpu = 0;
8010519e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  __sync_synchronize();
801051a5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801051aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801051b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051b3:	c9                   	leave  
  popcli();
801051b4:	e9 67 fe ff ff       	jmp    80105020 <popcli>
    panic("release");
801051b9:	83 ec 0c             	sub    $0xc,%esp
801051bc:	68 c0 84 10 80       	push   $0x801084c0
801051c1:	e8 ca b1 ff ff       	call   80100390 <panic>
801051c6:	66 90                	xchg   %ax,%ax
801051c8:	66 90                	xchg   %ax,%ax
801051ca:	66 90                	xchg   %ax,%ax
801051cc:	66 90                	xchg   %ax,%ax
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	53                   	push   %ebx
801051d5:	8b 55 08             	mov    0x8(%ebp),%edx
801051d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801051db:	f6 c2 03             	test   $0x3,%dl
801051de:	75 05                	jne    801051e5 <memset+0x15>
801051e0:	f6 c1 03             	test   $0x3,%cl
801051e3:	74 13                	je     801051f8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801051e5:	89 d7                	mov    %edx,%edi
801051e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ea:	fc                   	cld    
801051eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801051ed:	5b                   	pop    %ebx
801051ee:	89 d0                	mov    %edx,%eax
801051f0:	5f                   	pop    %edi
801051f1:	5d                   	pop    %ebp
801051f2:	c3                   	ret    
801051f3:	90                   	nop
801051f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801051f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051fc:	c1 e9 02             	shr    $0x2,%ecx
801051ff:	89 f8                	mov    %edi,%eax
80105201:	89 fb                	mov    %edi,%ebx
80105203:	c1 e0 18             	shl    $0x18,%eax
80105206:	c1 e3 10             	shl    $0x10,%ebx
80105209:	09 d8                	or     %ebx,%eax
8010520b:	09 f8                	or     %edi,%eax
8010520d:	c1 e7 08             	shl    $0x8,%edi
80105210:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105212:	89 d7                	mov    %edx,%edi
80105214:	fc                   	cld    
80105215:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105217:	5b                   	pop    %ebx
80105218:	89 d0                	mov    %edx,%eax
8010521a:	5f                   	pop    %edi
8010521b:	5d                   	pop    %ebp
8010521c:	c3                   	ret    
8010521d:	8d 76 00             	lea    0x0(%esi),%esi

80105220 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	57                   	push   %edi
80105224:	56                   	push   %esi
80105225:	53                   	push   %ebx
80105226:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105229:	8b 75 08             	mov    0x8(%ebp),%esi
8010522c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010522f:	85 db                	test   %ebx,%ebx
80105231:	74 29                	je     8010525c <memcmp+0x3c>
    if(*s1 != *s2)
80105233:	0f b6 16             	movzbl (%esi),%edx
80105236:	0f b6 0f             	movzbl (%edi),%ecx
80105239:	38 d1                	cmp    %dl,%cl
8010523b:	75 2b                	jne    80105268 <memcmp+0x48>
8010523d:	b8 01 00 00 00       	mov    $0x1,%eax
80105242:	eb 14                	jmp    80105258 <memcmp+0x38>
80105244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105248:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010524c:	83 c0 01             	add    $0x1,%eax
8010524f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105254:	38 ca                	cmp    %cl,%dl
80105256:	75 10                	jne    80105268 <memcmp+0x48>
  while(n-- > 0){
80105258:	39 d8                	cmp    %ebx,%eax
8010525a:	75 ec                	jne    80105248 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010525c:	5b                   	pop    %ebx
  return 0;
8010525d:	31 c0                	xor    %eax,%eax
}
8010525f:	5e                   	pop    %esi
80105260:	5f                   	pop    %edi
80105261:	5d                   	pop    %ebp
80105262:	c3                   	ret    
80105263:	90                   	nop
80105264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105268:	0f b6 c2             	movzbl %dl,%eax
}
8010526b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010526c:	29 c8                	sub    %ecx,%eax
}
8010526e:	5e                   	pop    %esi
8010526f:	5f                   	pop    %edi
80105270:	5d                   	pop    %ebp
80105271:	c3                   	ret    
80105272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	56                   	push   %esi
80105284:	53                   	push   %ebx
80105285:	8b 45 08             	mov    0x8(%ebp),%eax
80105288:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010528b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010528e:	39 c3                	cmp    %eax,%ebx
80105290:	73 26                	jae    801052b8 <memmove+0x38>
80105292:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105295:	39 c8                	cmp    %ecx,%eax
80105297:	73 1f                	jae    801052b8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105299:	85 f6                	test   %esi,%esi
8010529b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010529e:	74 0f                	je     801052af <memmove+0x2f>
      *--d = *--s;
801052a0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801052a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801052a7:	83 ea 01             	sub    $0x1,%edx
801052aa:	83 fa ff             	cmp    $0xffffffff,%edx
801052ad:	75 f1                	jne    801052a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801052af:	5b                   	pop    %ebx
801052b0:	5e                   	pop    %esi
801052b1:	5d                   	pop    %ebp
801052b2:	c3                   	ret    
801052b3:	90                   	nop
801052b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801052b8:	31 d2                	xor    %edx,%edx
801052ba:	85 f6                	test   %esi,%esi
801052bc:	74 f1                	je     801052af <memmove+0x2f>
801052be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801052c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801052c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801052c7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801052ca:	39 d6                	cmp    %edx,%esi
801052cc:	75 f2                	jne    801052c0 <memmove+0x40>
}
801052ce:	5b                   	pop    %ebx
801052cf:	5e                   	pop    %esi
801052d0:	5d                   	pop    %ebp
801052d1:	c3                   	ret    
801052d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801052e3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801052e4:	eb 9a                	jmp    80105280 <memmove>
801052e6:	8d 76 00             	lea    0x0(%esi),%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	8b 7d 10             	mov    0x10(%ebp),%edi
801052f8:	53                   	push   %ebx
801052f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801052ff:	85 ff                	test   %edi,%edi
80105301:	74 2f                	je     80105332 <strncmp+0x42>
80105303:	0f b6 01             	movzbl (%ecx),%eax
80105306:	0f b6 1e             	movzbl (%esi),%ebx
80105309:	84 c0                	test   %al,%al
8010530b:	74 37                	je     80105344 <strncmp+0x54>
8010530d:	38 c3                	cmp    %al,%bl
8010530f:	75 33                	jne    80105344 <strncmp+0x54>
80105311:	01 f7                	add    %esi,%edi
80105313:	eb 13                	jmp    80105328 <strncmp+0x38>
80105315:	8d 76 00             	lea    0x0(%esi),%esi
80105318:	0f b6 01             	movzbl (%ecx),%eax
8010531b:	84 c0                	test   %al,%al
8010531d:	74 21                	je     80105340 <strncmp+0x50>
8010531f:	0f b6 1a             	movzbl (%edx),%ebx
80105322:	89 d6                	mov    %edx,%esi
80105324:	38 d8                	cmp    %bl,%al
80105326:	75 1c                	jne    80105344 <strncmp+0x54>
    n--, p++, q++;
80105328:	8d 56 01             	lea    0x1(%esi),%edx
8010532b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010532e:	39 fa                	cmp    %edi,%edx
80105330:	75 e6                	jne    80105318 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105332:	5b                   	pop    %ebx
    return 0;
80105333:	31 c0                	xor    %eax,%eax
}
80105335:	5e                   	pop    %esi
80105336:	5f                   	pop    %edi
80105337:	5d                   	pop    %ebp
80105338:	c3                   	ret    
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105340:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105344:	29 d8                	sub    %ebx,%eax
}
80105346:	5b                   	pop    %ebx
80105347:	5e                   	pop    %esi
80105348:	5f                   	pop    %edi
80105349:	5d                   	pop    %ebp
8010534a:	c3                   	ret    
8010534b:	90                   	nop
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105350 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
80105355:	8b 45 08             	mov    0x8(%ebp),%eax
80105358:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010535b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010535e:	89 c2                	mov    %eax,%edx
80105360:	eb 19                	jmp    8010537b <strncpy+0x2b>
80105362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105368:	83 c3 01             	add    $0x1,%ebx
8010536b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010536f:	83 c2 01             	add    $0x1,%edx
80105372:	84 c9                	test   %cl,%cl
80105374:	88 4a ff             	mov    %cl,-0x1(%edx)
80105377:	74 09                	je     80105382 <strncpy+0x32>
80105379:	89 f1                	mov    %esi,%ecx
8010537b:	85 c9                	test   %ecx,%ecx
8010537d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105380:	7f e6                	jg     80105368 <strncpy+0x18>
    ;
  while(n-- > 0)
80105382:	31 c9                	xor    %ecx,%ecx
80105384:	85 f6                	test   %esi,%esi
80105386:	7e 17                	jle    8010539f <strncpy+0x4f>
80105388:	90                   	nop
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105390:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105394:	89 f3                	mov    %esi,%ebx
80105396:	83 c1 01             	add    $0x1,%ecx
80105399:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010539b:	85 db                	test   %ebx,%ebx
8010539d:	7f f1                	jg     80105390 <strncpy+0x40>
  return os;
}
8010539f:	5b                   	pop    %ebx
801053a0:	5e                   	pop    %esi
801053a1:	5d                   	pop    %ebp
801053a2:	c3                   	ret    
801053a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	56                   	push   %esi
801053b4:	53                   	push   %ebx
801053b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801053b8:	8b 45 08             	mov    0x8(%ebp),%eax
801053bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801053be:	85 c9                	test   %ecx,%ecx
801053c0:	7e 26                	jle    801053e8 <safestrcpy+0x38>
801053c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801053c6:	89 c1                	mov    %eax,%ecx
801053c8:	eb 17                	jmp    801053e1 <safestrcpy+0x31>
801053ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801053d0:	83 c2 01             	add    $0x1,%edx
801053d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801053d7:	83 c1 01             	add    $0x1,%ecx
801053da:	84 db                	test   %bl,%bl
801053dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801053df:	74 04                	je     801053e5 <safestrcpy+0x35>
801053e1:	39 f2                	cmp    %esi,%edx
801053e3:	75 eb                	jne    801053d0 <safestrcpy+0x20>
    ;
  *s = 0;
801053e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801053e8:	5b                   	pop    %ebx
801053e9:	5e                   	pop    %esi
801053ea:	5d                   	pop    %ebp
801053eb:	c3                   	ret    
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <strlen>:

int
strlen(const char *s)
{
801053f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801053f1:	31 c0                	xor    %eax,%eax
{
801053f3:	89 e5                	mov    %esp,%ebp
801053f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801053f8:	80 3a 00             	cmpb   $0x0,(%edx)
801053fb:	74 0c                	je     80105409 <strlen+0x19>
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
80105400:	83 c0 01             	add    $0x1,%eax
80105403:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105407:	75 f7                	jne    80105400 <strlen+0x10>
    ;
  return n;
}
80105409:	5d                   	pop    %ebp
8010540a:	c3                   	ret    

8010540b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010540b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010540f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105413:	55                   	push   %ebp
  pushl %ebx
80105414:	53                   	push   %ebx
  pushl %esi
80105415:	56                   	push   %esi
  pushl %edi
80105416:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105417:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105419:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010541b:	5f                   	pop    %edi
  popl %esi
8010541c:	5e                   	pop    %esi
  popl %ebx
8010541d:	5b                   	pop    %ebx
  popl %ebp
8010541e:	5d                   	pop    %ebp
  ret
8010541f:	c3                   	ret    

80105420 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	53                   	push   %ebx
80105424:	83 ec 04             	sub    $0x4,%esp
80105427:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
8010542a:	e8 e1 e4 ff ff       	call   80103910 <myproc>

    if(addr >= curproc->sz || addr+4 > curproc->sz)
8010542f:	8b 00                	mov    (%eax),%eax
80105431:	39 d8                	cmp    %ebx,%eax
80105433:	76 1b                	jbe    80105450 <fetchint+0x30>
80105435:	8d 53 04             	lea    0x4(%ebx),%edx
80105438:	39 d0                	cmp    %edx,%eax
8010543a:	72 14                	jb     80105450 <fetchint+0x30>
        return -1;
    *ip = *(int*)(addr);
8010543c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010543f:	8b 13                	mov    (%ebx),%edx
80105441:	89 10                	mov    %edx,(%eax)
    return 0;
80105443:	31 c0                	xor    %eax,%eax
}
80105445:	83 c4 04             	add    $0x4,%esp
80105448:	5b                   	pop    %ebx
80105449:	5d                   	pop    %ebp
8010544a:	c3                   	ret    
8010544b:	90                   	nop
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105455:	eb ee                	jmp    80105445 <fetchint+0x25>
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105460 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	53                   	push   %ebx
80105464:	83 ec 04             	sub    $0x4,%esp
80105467:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
8010546a:	e8 a1 e4 ff ff       	call   80103910 <myproc>

    if(addr >= curproc->sz)
8010546f:	39 18                	cmp    %ebx,(%eax)
80105471:	76 29                	jbe    8010549c <fetchstr+0x3c>
        return -1;
    *pp = (char*)addr;
80105473:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105476:	89 da                	mov    %ebx,%edx
80105478:	89 19                	mov    %ebx,(%ecx)
    ep = (char*)curproc->sz;
8010547a:	8b 00                	mov    (%eax),%eax
    for(s = *pp; s < ep; s++){
8010547c:	39 c3                	cmp    %eax,%ebx
8010547e:	73 1c                	jae    8010549c <fetchstr+0x3c>
        if(*s == 0)
80105480:	80 3b 00             	cmpb   $0x0,(%ebx)
80105483:	75 10                	jne    80105495 <fetchstr+0x35>
80105485:	eb 39                	jmp    801054c0 <fetchstr+0x60>
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105490:	80 3a 00             	cmpb   $0x0,(%edx)
80105493:	74 1b                	je     801054b0 <fetchstr+0x50>
    for(s = *pp; s < ep; s++){
80105495:	83 c2 01             	add    $0x1,%edx
80105498:	39 d0                	cmp    %edx,%eax
8010549a:	77 f4                	ja     80105490 <fetchstr+0x30>
        return -1;
8010549c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return s - *pp;
    }
    return -1;
}
801054a1:	83 c4 04             	add    $0x4,%esp
801054a4:	5b                   	pop    %ebx
801054a5:	5d                   	pop    %ebp
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801054b0:	83 c4 04             	add    $0x4,%esp
801054b3:	89 d0                	mov    %edx,%eax
801054b5:	29 d8                	sub    %ebx,%eax
801054b7:	5b                   	pop    %ebx
801054b8:	5d                   	pop    %ebp
801054b9:	c3                   	ret    
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(*s == 0)
801054c0:	31 c0                	xor    %eax,%eax
            return s - *pp;
801054c2:	eb dd                	jmp    801054a1 <fetchstr+0x41>
801054c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801054d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	56                   	push   %esi
801054d4:	53                   	push   %ebx
    return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
801054d5:	e8 66 e4 ff ff       	call   80103940 <mythread>
801054da:	8b 40 10             	mov    0x10(%eax),%eax
801054dd:	8b 55 08             	mov    0x8(%ebp),%edx
801054e0:	8b 40 44             	mov    0x44(%eax),%eax
801054e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
801054e6:	e8 25 e4 ff ff       	call   80103910 <myproc>
    if(addr >= curproc->sz || addr+4 > curproc->sz)
801054eb:	8b 00                	mov    (%eax),%eax
    return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
801054ed:	8d 73 04             	lea    0x4(%ebx),%esi
    if(addr >= curproc->sz || addr+4 > curproc->sz)
801054f0:	39 c6                	cmp    %eax,%esi
801054f2:	73 1c                	jae    80105510 <argint+0x40>
801054f4:	8d 53 08             	lea    0x8(%ebx),%edx
801054f7:	39 d0                	cmp    %edx,%eax
801054f9:	72 15                	jb     80105510 <argint+0x40>
    *ip = *(int*)(addr);
801054fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801054fe:	8b 53 04             	mov    0x4(%ebx),%edx
80105501:	89 10                	mov    %edx,(%eax)
    return 0;
80105503:	31 c0                	xor    %eax,%eax
}
80105505:	5b                   	pop    %ebx
80105506:	5e                   	pop    %esi
80105507:	5d                   	pop    %ebp
80105508:	c3                   	ret    
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80105515:	eb ee                	jmp    80105505 <argint+0x35>
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	56                   	push   %esi
80105524:	53                   	push   %ebx
80105525:	83 ec 10             	sub    $0x10,%esp
80105528:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
8010552b:	e8 e0 e3 ff ff       	call   80103910 <myproc>
80105530:	89 c6                	mov    %eax,%esi

    if(argint(n, &i) < 0)
80105532:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105535:	83 ec 08             	sub    $0x8,%esp
80105538:	50                   	push   %eax
80105539:	ff 75 08             	pushl  0x8(%ebp)
8010553c:	e8 8f ff ff ff       	call   801054d0 <argint>
        return -1;
    if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105541:	83 c4 10             	add    $0x10,%esp
80105544:	85 c0                	test   %eax,%eax
80105546:	78 28                	js     80105570 <argptr+0x50>
80105548:	85 db                	test   %ebx,%ebx
8010554a:	78 24                	js     80105570 <argptr+0x50>
8010554c:	8b 16                	mov    (%esi),%edx
8010554e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105551:	39 c2                	cmp    %eax,%edx
80105553:	76 1b                	jbe    80105570 <argptr+0x50>
80105555:	01 c3                	add    %eax,%ebx
80105557:	39 da                	cmp    %ebx,%edx
80105559:	72 15                	jb     80105570 <argptr+0x50>
        return -1;
    *pp = (char*)i;
8010555b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010555e:	89 02                	mov    %eax,(%edx)
    return 0;
80105560:	31 c0                	xor    %eax,%eax
}
80105562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105565:	5b                   	pop    %ebx
80105566:	5e                   	pop    %esi
80105567:	5d                   	pop    %ebp
80105568:	c3                   	ret    
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105575:	eb eb                	jmp    80105562 <argptr+0x42>
80105577:	89 f6                	mov    %esi,%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if(argint(n, &addr) < 0)
80105586:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105589:	50                   	push   %eax
8010558a:	ff 75 08             	pushl  0x8(%ebp)
8010558d:	e8 3e ff ff ff       	call   801054d0 <argint>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	78 17                	js     801055b0 <argstr+0x30>
        return -1;
    return fetchstr(addr, pp);
80105599:	83 ec 08             	sub    $0x8,%esp
8010559c:	ff 75 0c             	pushl  0xc(%ebp)
8010559f:	ff 75 f4             	pushl  -0xc(%ebp)
801055a2:	e8 b9 fe ff ff       	call   80105460 <fetchstr>
801055a7:	83 c4 10             	add    $0x10,%esp
}
801055aa:	c9                   	leave  
801055ab:	c3                   	ret    
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b5:	c9                   	leave  
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <syscall>:
        [SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	56                   	push   %esi
801055c4:	53                   	push   %ebx
    int num;
    struct proc *curproc = myproc();
801055c5:	e8 46 e3 ff ff       	call   80103910 <myproc>
801055ca:	89 c6                	mov    %eax,%esi
    struct thread *curthread = mythread();
801055cc:	e8 6f e3 ff ff       	call   80103940 <mythread>
801055d1:	89 c3                	mov    %eax,%ebx

    num = curthread->tf->eax;
801055d3:	8b 40 10             	mov    0x10(%eax),%eax
801055d6:	8b 40 1c             	mov    0x1c(%eax),%eax
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055d9:	8d 50 ff             	lea    -0x1(%eax),%edx
801055dc:	83 fa 18             	cmp    $0x18,%edx
801055df:	77 1f                	ja     80105600 <syscall+0x40>
801055e1:	8b 14 85 00 85 10 80 	mov    -0x7fef7b00(,%eax,4),%edx
801055e8:	85 d2                	test   %edx,%edx
801055ea:	74 14                	je     80105600 <syscall+0x40>
        curthread->tf->eax = syscalls[num]();
801055ec:	ff d2                	call   *%edx
801055ee:	8b 53 10             	mov    0x10(%ebx),%edx
801055f1:	89 42 1c             	mov    %eax,0x1c(%edx)
    } else {
        cprintf("%d %s: unknown sys call %d\n",
                curproc->pid, curproc->name, num);
        curthread->tf->eax = -1;
    }
}
801055f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055f7:	5b                   	pop    %ebx
801055f8:	5e                   	pop    %esi
801055f9:	5d                   	pop    %ebp
801055fa:	c3                   	ret    
801055fb:	90                   	nop
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%d %s: unknown sys call %d\n",
80105600:	50                   	push   %eax
                curproc->pid, curproc->name, num);
80105601:	8d 46 64             	lea    0x64(%esi),%eax
        cprintf("%d %s: unknown sys call %d\n",
80105604:	50                   	push   %eax
80105605:	ff 76 0c             	pushl  0xc(%esi)
80105608:	68 c8 84 10 80       	push   $0x801084c8
8010560d:	e8 4e b0 ff ff       	call   80100660 <cprintf>
        curthread->tf->eax = -1;
80105612:	8b 43 10             	mov    0x10(%ebx),%eax
80105615:	83 c4 10             	add    $0x10,%esp
80105618:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010561f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105622:	5b                   	pop    %ebx
80105623:	5e                   	pop    %esi
80105624:	5d                   	pop    %ebp
80105625:	c3                   	ret    
80105626:	66 90                	xchg   %ax,%ax
80105628:	66 90                	xchg   %ax,%ax
8010562a:	66 90                	xchg   %ax,%ax
8010562c:	66 90                	xchg   %ax,%ax
8010562e:	66 90                	xchg   %ax,%ax

80105630 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
80105635:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105636:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105639:	83 ec 44             	sub    $0x44,%esp
8010563c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010563f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105642:	56                   	push   %esi
80105643:	50                   	push   %eax
{
80105644:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105647:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010564a:	e8 e1 c8 ff ff       	call   80101f30 <nameiparent>
8010564f:	83 c4 10             	add    $0x10,%esp
80105652:	85 c0                	test   %eax,%eax
80105654:	0f 84 46 01 00 00    	je     801057a0 <create+0x170>
    return 0;
  ilock(dp);
8010565a:	83 ec 0c             	sub    $0xc,%esp
8010565d:	89 c3                	mov    %eax,%ebx
8010565f:	50                   	push   %eax
80105660:	e8 4b c0 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105665:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105668:	83 c4 0c             	add    $0xc,%esp
8010566b:	50                   	push   %eax
8010566c:	56                   	push   %esi
8010566d:	53                   	push   %ebx
8010566e:	e8 6d c5 ff ff       	call   80101be0 <dirlookup>
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	89 c7                	mov    %eax,%edi
8010567a:	74 34                	je     801056b0 <create+0x80>
    iunlockput(dp);
8010567c:	83 ec 0c             	sub    $0xc,%esp
8010567f:	53                   	push   %ebx
80105680:	e8 bb c2 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
80105685:	89 3c 24             	mov    %edi,(%esp)
80105688:	e8 23 c0 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010568d:	83 c4 10             	add    $0x10,%esp
80105690:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105695:	0f 85 95 00 00 00    	jne    80105730 <create+0x100>
8010569b:	66 83 7f 54 02       	cmpw   $0x2,0x54(%edi)
801056a0:	0f 85 8a 00 00 00    	jne    80105730 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a9:	89 f8                	mov    %edi,%eax
801056ab:	5b                   	pop    %ebx
801056ac:	5e                   	pop    %esi
801056ad:	5f                   	pop    %edi
801056ae:	5d                   	pop    %ebp
801056af:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801056b0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801056b4:	83 ec 08             	sub    $0x8,%esp
801056b7:	50                   	push   %eax
801056b8:	ff 33                	pushl  (%ebx)
801056ba:	e8 81 be ff ff       	call   80101540 <ialloc>
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	85 c0                	test   %eax,%eax
801056c4:	89 c7                	mov    %eax,%edi
801056c6:	0f 84 e8 00 00 00    	je     801057b4 <create+0x184>
  ilock(ip);
801056cc:	83 ec 0c             	sub    $0xc,%esp
801056cf:	50                   	push   %eax
801056d0:	e8 db bf ff ff       	call   801016b0 <ilock>
  ip->major = major;
801056d5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801056d9:	66 89 47 56          	mov    %ax,0x56(%edi)
  ip->minor = minor;
801056dd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801056e1:	66 89 47 58          	mov    %ax,0x58(%edi)
  ip->nlink = 1;
801056e5:	b8 01 00 00 00       	mov    $0x1,%eax
801056ea:	66 89 47 5a          	mov    %ax,0x5a(%edi)
  iupdate(ip);
801056ee:	89 3c 24             	mov    %edi,(%esp)
801056f1:	e8 0a bf ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801056fe:	74 50                	je     80105750 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105700:	83 ec 04             	sub    $0x4,%esp
80105703:	ff 77 04             	pushl  0x4(%edi)
80105706:	56                   	push   %esi
80105707:	53                   	push   %ebx
80105708:	e8 43 c7 ff ff       	call   80101e50 <dirlink>
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	85 c0                	test   %eax,%eax
80105712:	0f 88 8f 00 00 00    	js     801057a7 <create+0x177>
  iunlockput(dp);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	53                   	push   %ebx
8010571c:	e8 1f c2 ff ff       	call   80101940 <iunlockput>
  return ip;
80105721:	83 c4 10             	add    $0x10,%esp
}
80105724:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105727:	89 f8                	mov    %edi,%eax
80105729:	5b                   	pop    %ebx
8010572a:	5e                   	pop    %esi
8010572b:	5f                   	pop    %edi
8010572c:	5d                   	pop    %ebp
8010572d:	c3                   	ret    
8010572e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	57                   	push   %edi
    return 0;
80105734:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105736:	e8 05 c2 ff ff       	call   80101940 <iunlockput>
    return 0;
8010573b:	83 c4 10             	add    $0x10,%esp
}
8010573e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105741:	89 f8                	mov    %edi,%eax
80105743:	5b                   	pop    %ebx
80105744:	5e                   	pop    %esi
80105745:	5f                   	pop    %edi
80105746:	5d                   	pop    %ebp
80105747:	c3                   	ret    
80105748:	90                   	nop
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105750:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
    iupdate(dp);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	53                   	push   %ebx
80105759:	e8 a2 be ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010575e:	83 c4 0c             	add    $0xc,%esp
80105761:	ff 77 04             	pushl  0x4(%edi)
80105764:	68 84 85 10 80       	push   $0x80108584
80105769:	57                   	push   %edi
8010576a:	e8 e1 c6 ff ff       	call   80101e50 <dirlink>
8010576f:	83 c4 10             	add    $0x10,%esp
80105772:	85 c0                	test   %eax,%eax
80105774:	78 1c                	js     80105792 <create+0x162>
80105776:	83 ec 04             	sub    $0x4,%esp
80105779:	ff 73 04             	pushl  0x4(%ebx)
8010577c:	68 83 85 10 80       	push   $0x80108583
80105781:	57                   	push   %edi
80105782:	e8 c9 c6 ff ff       	call   80101e50 <dirlink>
80105787:	83 c4 10             	add    $0x10,%esp
8010578a:	85 c0                	test   %eax,%eax
8010578c:	0f 89 6e ff ff ff    	jns    80105700 <create+0xd0>
      panic("create dots");
80105792:	83 ec 0c             	sub    $0xc,%esp
80105795:	68 77 85 10 80       	push   $0x80108577
8010579a:	e8 f1 ab ff ff       	call   80100390 <panic>
8010579f:	90                   	nop
    return 0;
801057a0:	31 ff                	xor    %edi,%edi
801057a2:	e9 ff fe ff ff       	jmp    801056a6 <create+0x76>
    panic("create: dirlink");
801057a7:	83 ec 0c             	sub    $0xc,%esp
801057aa:	68 86 85 10 80       	push   $0x80108586
801057af:	e8 dc ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801057b4:	83 ec 0c             	sub    $0xc,%esp
801057b7:	68 68 85 10 80       	push   $0x80108568
801057bc:	e8 cf ab ff ff       	call   80100390 <panic>
801057c1:	eb 0d                	jmp    801057d0 <argfd.constprop.0>
801057c3:	90                   	nop
801057c4:	90                   	nop
801057c5:	90                   	nop
801057c6:	90                   	nop
801057c7:	90                   	nop
801057c8:	90                   	nop
801057c9:	90                   	nop
801057ca:	90                   	nop
801057cb:	90                   	nop
801057cc:	90                   	nop
801057cd:	90                   	nop
801057ce:	90                   	nop
801057cf:	90                   	nop

801057d0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	56                   	push   %esi
801057d4:	53                   	push   %ebx
801057d5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801057d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801057da:	89 d6                	mov    %edx,%esi
801057dc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801057df:	50                   	push   %eax
801057e0:	6a 00                	push   $0x0
801057e2:	e8 e9 fc ff ff       	call   801054d0 <argint>
801057e7:	83 c4 10             	add    $0x10,%esp
801057ea:	85 c0                	test   %eax,%eax
801057ec:	78 2a                	js     80105818 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057ee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057f2:	77 24                	ja     80105818 <argfd.constprop.0+0x48>
801057f4:	e8 17 e1 ff ff       	call   80103910 <myproc>
801057f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057fc:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
80105800:	85 c0                	test   %eax,%eax
80105802:	74 14                	je     80105818 <argfd.constprop.0+0x48>
  if(pfd)
80105804:	85 db                	test   %ebx,%ebx
80105806:	74 02                	je     8010580a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105808:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010580a:	89 06                	mov    %eax,(%esi)
  return 0;
8010580c:	31 c0                	xor    %eax,%eax
}
8010580e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105811:	5b                   	pop    %ebx
80105812:	5e                   	pop    %esi
80105813:	5d                   	pop    %ebp
80105814:	c3                   	ret    
80105815:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105818:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581d:	eb ef                	jmp    8010580e <argfd.constprop.0+0x3e>
8010581f:	90                   	nop

80105820 <sys_dup>:
{
80105820:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105821:	31 c0                	xor    %eax,%eax
{
80105823:	89 e5                	mov    %esp,%ebp
80105825:	56                   	push   %esi
80105826:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105827:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010582a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010582d:	e8 9e ff ff ff       	call   801057d0 <argfd.constprop.0>
80105832:	85 c0                	test   %eax,%eax
80105834:	78 42                	js     80105878 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105836:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105839:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010583b:	e8 d0 e0 ff ff       	call   80103910 <myproc>
80105840:	eb 0e                	jmp    80105850 <sys_dup+0x30>
80105842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105848:	83 c3 01             	add    $0x1,%ebx
8010584b:	83 fb 10             	cmp    $0x10,%ebx
8010584e:	74 28                	je     80105878 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105850:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105854:	85 d2                	test   %edx,%edx
80105856:	75 f0                	jne    80105848 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105858:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
  filedup(f);
8010585c:	83 ec 0c             	sub    $0xc,%esp
8010585f:	ff 75 f4             	pushl  -0xc(%ebp)
80105862:	e8 a9 b5 ff ff       	call   80100e10 <filedup>
  return fd;
80105867:	83 c4 10             	add    $0x10,%esp
}
8010586a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010586d:	89 d8                	mov    %ebx,%eax
8010586f:	5b                   	pop    %ebx
80105870:	5e                   	pop    %esi
80105871:	5d                   	pop    %ebp
80105872:	c3                   	ret    
80105873:	90                   	nop
80105874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105878:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010587b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105880:	89 d8                	mov    %ebx,%eax
80105882:	5b                   	pop    %ebx
80105883:	5e                   	pop    %esi
80105884:	5d                   	pop    %ebp
80105885:	c3                   	ret    
80105886:	8d 76 00             	lea    0x0(%esi),%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <sys_read>:
{
80105890:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105891:	31 c0                	xor    %eax,%eax
{
80105893:	89 e5                	mov    %esp,%ebp
80105895:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105898:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010589b:	e8 30 ff ff ff       	call   801057d0 <argfd.constprop.0>
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 4c                	js     801058f0 <sys_read+0x60>
801058a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a7:	83 ec 08             	sub    $0x8,%esp
801058aa:	50                   	push   %eax
801058ab:	6a 02                	push   $0x2
801058ad:	e8 1e fc ff ff       	call   801054d0 <argint>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 37                	js     801058f0 <sys_read+0x60>
801058b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058bc:	83 ec 04             	sub    $0x4,%esp
801058bf:	ff 75 f0             	pushl  -0x10(%ebp)
801058c2:	50                   	push   %eax
801058c3:	6a 01                	push   $0x1
801058c5:	e8 56 fc ff ff       	call   80105520 <argptr>
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	85 c0                	test   %eax,%eax
801058cf:	78 1f                	js     801058f0 <sys_read+0x60>
  return fileread(f, p, n);
801058d1:	83 ec 04             	sub    $0x4,%esp
801058d4:	ff 75 f0             	pushl  -0x10(%ebp)
801058d7:	ff 75 f4             	pushl  -0xc(%ebp)
801058da:	ff 75 ec             	pushl  -0x14(%ebp)
801058dd:	e8 9e b6 ff ff       	call   80100f80 <fileread>
801058e2:	83 c4 10             	add    $0x10,%esp
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <sys_write>:
{
80105900:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105901:	31 c0                	xor    %eax,%eax
{
80105903:	89 e5                	mov    %esp,%ebp
80105905:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105908:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010590b:	e8 c0 fe ff ff       	call   801057d0 <argfd.constprop.0>
80105910:	85 c0                	test   %eax,%eax
80105912:	78 4c                	js     80105960 <sys_write+0x60>
80105914:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105917:	83 ec 08             	sub    $0x8,%esp
8010591a:	50                   	push   %eax
8010591b:	6a 02                	push   $0x2
8010591d:	e8 ae fb ff ff       	call   801054d0 <argint>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	78 37                	js     80105960 <sys_write+0x60>
80105929:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010592c:	83 ec 04             	sub    $0x4,%esp
8010592f:	ff 75 f0             	pushl  -0x10(%ebp)
80105932:	50                   	push   %eax
80105933:	6a 01                	push   $0x1
80105935:	e8 e6 fb ff ff       	call   80105520 <argptr>
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	85 c0                	test   %eax,%eax
8010593f:	78 1f                	js     80105960 <sys_write+0x60>
  return filewrite(f, p, n);
80105941:	83 ec 04             	sub    $0x4,%esp
80105944:	ff 75 f0             	pushl  -0x10(%ebp)
80105947:	ff 75 f4             	pushl  -0xc(%ebp)
8010594a:	ff 75 ec             	pushl  -0x14(%ebp)
8010594d:	e8 be b6 ff ff       	call   80101010 <filewrite>
80105952:	83 c4 10             	add    $0x10,%esp
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <sys_close>:
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105976:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105979:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010597c:	e8 4f fe ff ff       	call   801057d0 <argfd.constprop.0>
80105981:	85 c0                	test   %eax,%eax
80105983:	78 2b                	js     801059b0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105985:	e8 86 df ff ff       	call   80103910 <myproc>
8010598a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010598d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105990:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
80105997:	00 
  fileclose(f);
80105998:	ff 75 f4             	pushl  -0xc(%ebp)
8010599b:	e8 c0 b4 ff ff       	call   80100e60 <fileclose>
  return 0;
801059a0:	83 c4 10             	add    $0x10,%esp
801059a3:	31 c0                	xor    %eax,%eax
}
801059a5:	c9                   	leave  
801059a6:	c3                   	ret    
801059a7:	89 f6                	mov    %esi,%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b5:	c9                   	leave  
801059b6:	c3                   	ret    
801059b7:	89 f6                	mov    %esi,%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_fstat>:
{
801059c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059c1:	31 c0                	xor    %eax,%eax
{
801059c3:	89 e5                	mov    %esp,%ebp
801059c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801059cb:	e8 00 fe ff ff       	call   801057d0 <argfd.constprop.0>
801059d0:	85 c0                	test   %eax,%eax
801059d2:	78 2c                	js     80105a00 <sys_fstat+0x40>
801059d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d7:	83 ec 04             	sub    $0x4,%esp
801059da:	6a 14                	push   $0x14
801059dc:	50                   	push   %eax
801059dd:	6a 01                	push   $0x1
801059df:	e8 3c fb ff ff       	call   80105520 <argptr>
801059e4:	83 c4 10             	add    $0x10,%esp
801059e7:	85 c0                	test   %eax,%eax
801059e9:	78 15                	js     80105a00 <sys_fstat+0x40>
  return filestat(f, st);
801059eb:	83 ec 08             	sub    $0x8,%esp
801059ee:	ff 75 f4             	pushl  -0xc(%ebp)
801059f1:	ff 75 f0             	pushl  -0x10(%ebp)
801059f4:	e8 37 b5 ff ff       	call   80100f30 <filestat>
801059f9:	83 c4 10             	add    $0x10,%esp
}
801059fc:	c9                   	leave  
801059fd:	c3                   	ret    
801059fe:	66 90                	xchg   %ax,%ax
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <sys_link>:
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a16:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105a19:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a1c:	50                   	push   %eax
80105a1d:	6a 00                	push   $0x0
80105a1f:	e8 5c fb ff ff       	call   80105580 <argstr>
80105a24:	83 c4 10             	add    $0x10,%esp
80105a27:	85 c0                	test   %eax,%eax
80105a29:	0f 88 fb 00 00 00    	js     80105b2a <sys_link+0x11a>
80105a2f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105a32:	83 ec 08             	sub    $0x8,%esp
80105a35:	50                   	push   %eax
80105a36:	6a 01                	push   $0x1
80105a38:	e8 43 fb ff ff       	call   80105580 <argstr>
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	85 c0                	test   %eax,%eax
80105a42:	0f 88 e2 00 00 00    	js     80105b2a <sys_link+0x11a>
  begin_op();
80105a48:	e8 83 d1 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
80105a4d:	83 ec 0c             	sub    $0xc,%esp
80105a50:	ff 75 d4             	pushl  -0x2c(%ebp)
80105a53:	e8 b8 c4 ff ff       	call   80101f10 <namei>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	89 c3                	mov    %eax,%ebx
80105a5f:	0f 84 ea 00 00 00    	je     80105b4f <sys_link+0x13f>
  ilock(ip);
80105a65:	83 ec 0c             	sub    $0xc,%esp
80105a68:	50                   	push   %eax
80105a69:	e8 42 bc ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105a76:	0f 84 bb 00 00 00    	je     80105b37 <sys_link+0x127>
  ip->nlink++;
80105a7c:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105a81:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105a84:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a87:	53                   	push   %ebx
80105a88:	e8 73 bb ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80105a8d:	89 1c 24             	mov    %ebx,(%esp)
80105a90:	e8 fb bc ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a95:	58                   	pop    %eax
80105a96:	5a                   	pop    %edx
80105a97:	57                   	push   %edi
80105a98:	ff 75 d0             	pushl  -0x30(%ebp)
80105a9b:	e8 90 c4 ff ff       	call   80101f30 <nameiparent>
80105aa0:	83 c4 10             	add    $0x10,%esp
80105aa3:	85 c0                	test   %eax,%eax
80105aa5:	89 c6                	mov    %eax,%esi
80105aa7:	74 5b                	je     80105b04 <sys_link+0xf4>
  ilock(dp);
80105aa9:	83 ec 0c             	sub    $0xc,%esp
80105aac:	50                   	push   %eax
80105aad:	e8 fe bb ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	8b 03                	mov    (%ebx),%eax
80105ab7:	39 06                	cmp    %eax,(%esi)
80105ab9:	75 3d                	jne    80105af8 <sys_link+0xe8>
80105abb:	83 ec 04             	sub    $0x4,%esp
80105abe:	ff 73 04             	pushl  0x4(%ebx)
80105ac1:	57                   	push   %edi
80105ac2:	56                   	push   %esi
80105ac3:	e8 88 c3 ff ff       	call   80101e50 <dirlink>
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	85 c0                	test   %eax,%eax
80105acd:	78 29                	js     80105af8 <sys_link+0xe8>
  iunlockput(dp);
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	56                   	push   %esi
80105ad3:	e8 68 be ff ff       	call   80101940 <iunlockput>
  iput(ip);
80105ad8:	89 1c 24             	mov    %ebx,(%esp)
80105adb:	e8 00 bd ff ff       	call   801017e0 <iput>
  end_op();
80105ae0:	e8 5b d1 ff ff       	call   80102c40 <end_op>
  return 0;
80105ae5:	83 c4 10             	add    $0x10,%esp
80105ae8:	31 c0                	xor    %eax,%eax
}
80105aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aed:	5b                   	pop    %ebx
80105aee:	5e                   	pop    %esi
80105aef:	5f                   	pop    %edi
80105af0:	5d                   	pop    %ebp
80105af1:	c3                   	ret    
80105af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105af8:	83 ec 0c             	sub    $0xc,%esp
80105afb:	56                   	push   %esi
80105afc:	e8 3f be ff ff       	call   80101940 <iunlockput>
    goto bad;
80105b01:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105b04:	83 ec 0c             	sub    $0xc,%esp
80105b07:	53                   	push   %ebx
80105b08:	e8 a3 bb ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80105b0d:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105b12:	89 1c 24             	mov    %ebx,(%esp)
80105b15:	e8 e6 ba ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80105b1a:	89 1c 24             	mov    %ebx,(%esp)
80105b1d:	e8 1e be ff ff       	call   80101940 <iunlockput>
  end_op();
80105b22:	e8 19 d1 ff ff       	call   80102c40 <end_op>
  return -1;
80105b27:	83 c4 10             	add    $0x10,%esp
}
80105b2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b32:	5b                   	pop    %ebx
80105b33:	5e                   	pop    %esi
80105b34:	5f                   	pop    %edi
80105b35:	5d                   	pop    %ebp
80105b36:	c3                   	ret    
    iunlockput(ip);
80105b37:	83 ec 0c             	sub    $0xc,%esp
80105b3a:	53                   	push   %ebx
80105b3b:	e8 00 be ff ff       	call   80101940 <iunlockput>
    end_op();
80105b40:	e8 fb d0 ff ff       	call   80102c40 <end_op>
    return -1;
80105b45:	83 c4 10             	add    $0x10,%esp
80105b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b4d:	eb 9b                	jmp    80105aea <sys_link+0xda>
    end_op();
80105b4f:	e8 ec d0 ff ff       	call   80102c40 <end_op>
    return -1;
80105b54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b59:	eb 8f                	jmp    80105aea <sys_link+0xda>
80105b5b:	90                   	nop
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_unlink>:
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105b66:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b69:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105b6c:	50                   	push   %eax
80105b6d:	6a 00                	push   $0x0
80105b6f:	e8 0c fa ff ff       	call   80105580 <argstr>
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	85 c0                	test   %eax,%eax
80105b79:	0f 88 77 01 00 00    	js     80105cf6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105b7f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105b82:	e8 49 d0 ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b87:	83 ec 08             	sub    $0x8,%esp
80105b8a:	53                   	push   %ebx
80105b8b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b8e:	e8 9d c3 ff ff       	call   80101f30 <nameiparent>
80105b93:	83 c4 10             	add    $0x10,%esp
80105b96:	85 c0                	test   %eax,%eax
80105b98:	89 c6                	mov    %eax,%esi
80105b9a:	0f 84 60 01 00 00    	je     80105d00 <sys_unlink+0x1a0>
  ilock(dp);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	50                   	push   %eax
80105ba4:	e8 07 bb ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105ba9:	58                   	pop    %eax
80105baa:	5a                   	pop    %edx
80105bab:	68 84 85 10 80       	push   $0x80108584
80105bb0:	53                   	push   %ebx
80105bb1:	e8 0a c0 ff ff       	call   80101bc0 <namecmp>
80105bb6:	83 c4 10             	add    $0x10,%esp
80105bb9:	85 c0                	test   %eax,%eax
80105bbb:	0f 84 03 01 00 00    	je     80105cc4 <sys_unlink+0x164>
80105bc1:	83 ec 08             	sub    $0x8,%esp
80105bc4:	68 83 85 10 80       	push   $0x80108583
80105bc9:	53                   	push   %ebx
80105bca:	e8 f1 bf ff ff       	call   80101bc0 <namecmp>
80105bcf:	83 c4 10             	add    $0x10,%esp
80105bd2:	85 c0                	test   %eax,%eax
80105bd4:	0f 84 ea 00 00 00    	je     80105cc4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105bda:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105bdd:	83 ec 04             	sub    $0x4,%esp
80105be0:	50                   	push   %eax
80105be1:	53                   	push   %ebx
80105be2:	56                   	push   %esi
80105be3:	e8 f8 bf ff ff       	call   80101be0 <dirlookup>
80105be8:	83 c4 10             	add    $0x10,%esp
80105beb:	85 c0                	test   %eax,%eax
80105bed:	89 c3                	mov    %eax,%ebx
80105bef:	0f 84 cf 00 00 00    	je     80105cc4 <sys_unlink+0x164>
  ilock(ip);
80105bf5:	83 ec 0c             	sub    $0xc,%esp
80105bf8:	50                   	push   %eax
80105bf9:	e8 b2 ba ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
80105c06:	0f 8e 10 01 00 00    	jle    80105d1c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c0c:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105c11:	74 6d                	je     80105c80 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105c13:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c16:	83 ec 04             	sub    $0x4,%esp
80105c19:	6a 10                	push   $0x10
80105c1b:	6a 00                	push   $0x0
80105c1d:	50                   	push   %eax
80105c1e:	e8 ad f5 ff ff       	call   801051d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c23:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c26:	6a 10                	push   $0x10
80105c28:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c2b:	50                   	push   %eax
80105c2c:	56                   	push   %esi
80105c2d:	e8 5e be ff ff       	call   80101a90 <writei>
80105c32:	83 c4 20             	add    $0x20,%esp
80105c35:	83 f8 10             	cmp    $0x10,%eax
80105c38:	0f 85 eb 00 00 00    	jne    80105d29 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105c3e:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105c43:	0f 84 97 00 00 00    	je     80105ce0 <sys_unlink+0x180>
  iunlockput(dp);
80105c49:	83 ec 0c             	sub    $0xc,%esp
80105c4c:	56                   	push   %esi
80105c4d:	e8 ee bc ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80105c52:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105c57:	89 1c 24             	mov    %ebx,(%esp)
80105c5a:	e8 a1 b9 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80105c5f:	89 1c 24             	mov    %ebx,(%esp)
80105c62:	e8 d9 bc ff ff       	call   80101940 <iunlockput>
  end_op();
80105c67:	e8 d4 cf ff ff       	call   80102c40 <end_op>
  return 0;
80105c6c:	83 c4 10             	add    $0x10,%esp
80105c6f:	31 c0                	xor    %eax,%eax
}
80105c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c74:	5b                   	pop    %ebx
80105c75:	5e                   	pop    %esi
80105c76:	5f                   	pop    %edi
80105c77:	5d                   	pop    %ebp
80105c78:	c3                   	ret    
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c80:	83 7b 5c 20          	cmpl   $0x20,0x5c(%ebx)
80105c84:	76 8d                	jbe    80105c13 <sys_unlink+0xb3>
80105c86:	bf 20 00 00 00       	mov    $0x20,%edi
80105c8b:	eb 0f                	jmp    80105c9c <sys_unlink+0x13c>
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
80105c90:	83 c7 10             	add    $0x10,%edi
80105c93:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80105c96:	0f 83 77 ff ff ff    	jae    80105c13 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c9c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c9f:	6a 10                	push   $0x10
80105ca1:	57                   	push   %edi
80105ca2:	50                   	push   %eax
80105ca3:	53                   	push   %ebx
80105ca4:	e8 e7 bc ff ff       	call   80101990 <readi>
80105ca9:	83 c4 10             	add    $0x10,%esp
80105cac:	83 f8 10             	cmp    $0x10,%eax
80105caf:	75 5e                	jne    80105d0f <sys_unlink+0x1af>
    if(de.inum != 0)
80105cb1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105cb6:	74 d8                	je     80105c90 <sys_unlink+0x130>
    iunlockput(ip);
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	53                   	push   %ebx
80105cbc:	e8 7f bc ff ff       	call   80101940 <iunlockput>
    goto bad;
80105cc1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105cc4:	83 ec 0c             	sub    $0xc,%esp
80105cc7:	56                   	push   %esi
80105cc8:	e8 73 bc ff ff       	call   80101940 <iunlockput>
  end_op();
80105ccd:	e8 6e cf ff ff       	call   80102c40 <end_op>
  return -1;
80105cd2:	83 c4 10             	add    $0x10,%esp
80105cd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cda:	eb 95                	jmp    80105c71 <sys_unlink+0x111>
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105ce0:	66 83 6e 5a 01       	subw   $0x1,0x5a(%esi)
    iupdate(dp);
80105ce5:	83 ec 0c             	sub    $0xc,%esp
80105ce8:	56                   	push   %esi
80105ce9:	e8 12 b9 ff ff       	call   80101600 <iupdate>
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	e9 53 ff ff ff       	jmp    80105c49 <sys_unlink+0xe9>
    return -1;
80105cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfb:	e9 71 ff ff ff       	jmp    80105c71 <sys_unlink+0x111>
    end_op();
80105d00:	e8 3b cf ff ff       	call   80102c40 <end_op>
    return -1;
80105d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0a:	e9 62 ff ff ff       	jmp    80105c71 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105d0f:	83 ec 0c             	sub    $0xc,%esp
80105d12:	68 a8 85 10 80       	push   $0x801085a8
80105d17:	e8 74 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105d1c:	83 ec 0c             	sub    $0xc,%esp
80105d1f:	68 96 85 10 80       	push   $0x80108596
80105d24:	e8 67 a6 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105d29:	83 ec 0c             	sub    $0xc,%esp
80105d2c:	68 ba 85 10 80       	push   $0x801085ba
80105d31:	e8 5a a6 ff ff       	call   80100390 <panic>
80105d36:	8d 76 00             	lea    0x0(%esi),%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d40 <sys_open>:

int
sys_open(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	57                   	push   %edi
80105d44:	56                   	push   %esi
80105d45:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d46:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105d49:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d4c:	50                   	push   %eax
80105d4d:	6a 00                	push   $0x0
80105d4f:	e8 2c f8 ff ff       	call   80105580 <argstr>
80105d54:	83 c4 10             	add    $0x10,%esp
80105d57:	85 c0                	test   %eax,%eax
80105d59:	0f 88 1d 01 00 00    	js     80105e7c <sys_open+0x13c>
80105d5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d62:	83 ec 08             	sub    $0x8,%esp
80105d65:	50                   	push   %eax
80105d66:	6a 01                	push   $0x1
80105d68:	e8 63 f7 ff ff       	call   801054d0 <argint>
80105d6d:	83 c4 10             	add    $0x10,%esp
80105d70:	85 c0                	test   %eax,%eax
80105d72:	0f 88 04 01 00 00    	js     80105e7c <sys_open+0x13c>
    return -1;

  begin_op();
80105d78:	e8 53 ce ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
80105d7d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105d81:	0f 85 a9 00 00 00    	jne    80105e30 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105d87:	83 ec 0c             	sub    $0xc,%esp
80105d8a:	ff 75 e0             	pushl  -0x20(%ebp)
80105d8d:	e8 7e c1 ff ff       	call   80101f10 <namei>
80105d92:	83 c4 10             	add    $0x10,%esp
80105d95:	85 c0                	test   %eax,%eax
80105d97:	89 c6                	mov    %eax,%esi
80105d99:	0f 84 b2 00 00 00    	je     80105e51 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105d9f:	83 ec 0c             	sub    $0xc,%esp
80105da2:	50                   	push   %eax
80105da3:	e8 08 b9 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105da8:	83 c4 10             	add    $0x10,%esp
80105dab:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
80105db0:	0f 84 aa 00 00 00    	je     80105e60 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105db6:	e8 e5 af ff ff       	call   80100da0 <filealloc>
80105dbb:	85 c0                	test   %eax,%eax
80105dbd:	89 c7                	mov    %eax,%edi
80105dbf:	0f 84 a6 00 00 00    	je     80105e6b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105dc5:	e8 46 db ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dca:	31 db                	xor    %ebx,%ebx
80105dcc:	eb 0e                	jmp    80105ddc <sys_open+0x9c>
80105dce:	66 90                	xchg   %ax,%ax
80105dd0:	83 c3 01             	add    $0x1,%ebx
80105dd3:	83 fb 10             	cmp    $0x10,%ebx
80105dd6:	0f 84 ac 00 00 00    	je     80105e88 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105ddc:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105de0:	85 d2                	test   %edx,%edx
80105de2:	75 ec                	jne    80105dd0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105de4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105de7:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
  iunlock(ip);
80105deb:	56                   	push   %esi
80105dec:	e8 9f b9 ff ff       	call   80101790 <iunlock>
  end_op();
80105df1:	e8 4a ce ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80105df6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105dfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105dff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e02:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105e05:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e0c:	89 d0                	mov    %edx,%eax
80105e0e:	f7 d0                	not    %eax
80105e10:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e13:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e16:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e19:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e20:	89 d8                	mov    %ebx,%eax
80105e22:	5b                   	pop    %ebx
80105e23:	5e                   	pop    %esi
80105e24:	5f                   	pop    %edi
80105e25:	5d                   	pop    %ebp
80105e26:	c3                   	ret    
80105e27:	89 f6                	mov    %esi,%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e36:	31 c9                	xor    %ecx,%ecx
80105e38:	6a 00                	push   $0x0
80105e3a:	ba 02 00 00 00       	mov    $0x2,%edx
80105e3f:	e8 ec f7 ff ff       	call   80105630 <create>
    if(ip == 0){
80105e44:	83 c4 10             	add    $0x10,%esp
80105e47:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105e49:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105e4b:	0f 85 65 ff ff ff    	jne    80105db6 <sys_open+0x76>
      end_op();
80105e51:	e8 ea cd ff ff       	call   80102c40 <end_op>
      return -1;
80105e56:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e5b:	eb c0                	jmp    80105e1d <sys_open+0xdd>
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105e63:	85 c9                	test   %ecx,%ecx
80105e65:	0f 84 4b ff ff ff    	je     80105db6 <sys_open+0x76>
    iunlockput(ip);
80105e6b:	83 ec 0c             	sub    $0xc,%esp
80105e6e:	56                   	push   %esi
80105e6f:	e8 cc ba ff ff       	call   80101940 <iunlockput>
    end_op();
80105e74:	e8 c7 cd ff ff       	call   80102c40 <end_op>
    return -1;
80105e79:	83 c4 10             	add    $0x10,%esp
80105e7c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e81:	eb 9a                	jmp    80105e1d <sys_open+0xdd>
80105e83:	90                   	nop
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105e88:	83 ec 0c             	sub    $0xc,%esp
80105e8b:	57                   	push   %edi
80105e8c:	e8 cf af ff ff       	call   80100e60 <fileclose>
80105e91:	83 c4 10             	add    $0x10,%esp
80105e94:	eb d5                	jmp    80105e6b <sys_open+0x12b>
80105e96:	8d 76 00             	lea    0x0(%esi),%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ea0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ea6:	e8 25 cd ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105eab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eae:	83 ec 08             	sub    $0x8,%esp
80105eb1:	50                   	push   %eax
80105eb2:	6a 00                	push   $0x0
80105eb4:	e8 c7 f6 ff ff       	call   80105580 <argstr>
80105eb9:	83 c4 10             	add    $0x10,%esp
80105ebc:	85 c0                	test   %eax,%eax
80105ebe:	78 30                	js     80105ef0 <sys_mkdir+0x50>
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec6:	31 c9                	xor    %ecx,%ecx
80105ec8:	6a 00                	push   $0x0
80105eca:	ba 01 00 00 00       	mov    $0x1,%edx
80105ecf:	e8 5c f7 ff ff       	call   80105630 <create>
80105ed4:	83 c4 10             	add    $0x10,%esp
80105ed7:	85 c0                	test   %eax,%eax
80105ed9:	74 15                	je     80105ef0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105edb:	83 ec 0c             	sub    $0xc,%esp
80105ede:	50                   	push   %eax
80105edf:	e8 5c ba ff ff       	call   80101940 <iunlockput>
  end_op();
80105ee4:	e8 57 cd ff ff       	call   80102c40 <end_op>
  return 0;
80105ee9:	83 c4 10             	add    $0x10,%esp
80105eec:	31 c0                	xor    %eax,%eax
}
80105eee:	c9                   	leave  
80105eef:	c3                   	ret    
    end_op();
80105ef0:	e8 4b cd ff ff       	call   80102c40 <end_op>
    return -1;
80105ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105efa:	c9                   	leave  
80105efb:	c3                   	ret    
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f00 <sys_mknod>:

int
sys_mknod(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f06:	e8 c5 cc ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f0e:	83 ec 08             	sub    $0x8,%esp
80105f11:	50                   	push   %eax
80105f12:	6a 00                	push   $0x0
80105f14:	e8 67 f6 ff ff       	call   80105580 <argstr>
80105f19:	83 c4 10             	add    $0x10,%esp
80105f1c:	85 c0                	test   %eax,%eax
80105f1e:	78 60                	js     80105f80 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f20:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f23:	83 ec 08             	sub    $0x8,%esp
80105f26:	50                   	push   %eax
80105f27:	6a 01                	push   $0x1
80105f29:	e8 a2 f5 ff ff       	call   801054d0 <argint>
  if((argstr(0, &path)) < 0 ||
80105f2e:	83 c4 10             	add    $0x10,%esp
80105f31:	85 c0                	test   %eax,%eax
80105f33:	78 4b                	js     80105f80 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f38:	83 ec 08             	sub    $0x8,%esp
80105f3b:	50                   	push   %eax
80105f3c:	6a 02                	push   $0x2
80105f3e:	e8 8d f5 ff ff       	call   801054d0 <argint>
     argint(1, &major) < 0 ||
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	85 c0                	test   %eax,%eax
80105f48:	78 36                	js     80105f80 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105f4a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105f4e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105f51:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105f55:	ba 03 00 00 00       	mov    $0x3,%edx
80105f5a:	50                   	push   %eax
80105f5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f5e:	e8 cd f6 ff ff       	call   80105630 <create>
80105f63:	83 c4 10             	add    $0x10,%esp
80105f66:	85 c0                	test   %eax,%eax
80105f68:	74 16                	je     80105f80 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f6a:	83 ec 0c             	sub    $0xc,%esp
80105f6d:	50                   	push   %eax
80105f6e:	e8 cd b9 ff ff       	call   80101940 <iunlockput>
  end_op();
80105f73:	e8 c8 cc ff ff       	call   80102c40 <end_op>
  return 0;
80105f78:	83 c4 10             	add    $0x10,%esp
80105f7b:	31 c0                	xor    %eax,%eax
}
80105f7d:	c9                   	leave  
80105f7e:	c3                   	ret    
80105f7f:	90                   	nop
    end_op();
80105f80:	e8 bb cc ff ff       	call   80102c40 <end_op>
    return -1;
80105f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f8a:	c9                   	leave  
80105f8b:	c3                   	ret    
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_chdir>:

int
sys_chdir(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	56                   	push   %esi
80105f94:	53                   	push   %ebx
80105f95:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105f98:	e8 73 d9 ff ff       	call   80103910 <myproc>
80105f9d:	89 c6                	mov    %eax,%esi
  //struct thread *curthread = mythread();
  
  begin_op();
80105f9f:	e8 2c cc ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fa7:	83 ec 08             	sub    $0x8,%esp
80105faa:	50                   	push   %eax
80105fab:	6a 00                	push   $0x0
80105fad:	e8 ce f5 ff ff       	call   80105580 <argstr>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	78 77                	js     80106030 <sys_chdir+0xa0>
80105fb9:	83 ec 0c             	sub    $0xc,%esp
80105fbc:	ff 75 f4             	pushl  -0xc(%ebp)
80105fbf:	e8 4c bf ff ff       	call   80101f10 <namei>
80105fc4:	83 c4 10             	add    $0x10,%esp
80105fc7:	85 c0                	test   %eax,%eax
80105fc9:	89 c3                	mov    %eax,%ebx
80105fcb:	74 63                	je     80106030 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105fcd:	83 ec 0c             	sub    $0xc,%esp
80105fd0:	50                   	push   %eax
80105fd1:	e8 da b6 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105fd6:	83 c4 10             	add    $0x10,%esp
80105fd9:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105fde:	75 30                	jne    80106010 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	53                   	push   %ebx
80105fe4:	e8 a7 b7 ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105fe9:	58                   	pop    %eax
80105fea:	ff 76 60             	pushl  0x60(%esi)
80105fed:	e8 ee b7 ff ff       	call   801017e0 <iput>
  end_op();
80105ff2:	e8 49 cc ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
80105ff7:	89 5e 60             	mov    %ebx,0x60(%esi)
  return 0;
80105ffa:	83 c4 10             	add    $0x10,%esp
80105ffd:	31 c0                	xor    %eax,%eax
}
80105fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106002:	5b                   	pop    %ebx
80106003:	5e                   	pop    %esi
80106004:	5d                   	pop    %ebp
80106005:	c3                   	ret    
80106006:	8d 76 00             	lea    0x0(%esi),%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	53                   	push   %ebx
80106014:	e8 27 b9 ff ff       	call   80101940 <iunlockput>
    end_op();
80106019:	e8 22 cc ff ff       	call   80102c40 <end_op>
    return -1;
8010601e:	83 c4 10             	add    $0x10,%esp
80106021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106026:	eb d7                	jmp    80105fff <sys_chdir+0x6f>
80106028:	90                   	nop
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106030:	e8 0b cc ff ff       	call   80102c40 <end_op>
    return -1;
80106035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603a:	eb c3                	jmp    80105fff <sys_chdir+0x6f>
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106040 <sys_exec>:

int
sys_exec(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	57                   	push   %edi
80106044:	56                   	push   %esi
80106045:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106046:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010604c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106052:	50                   	push   %eax
80106053:	6a 00                	push   $0x0
80106055:	e8 26 f5 ff ff       	call   80105580 <argstr>
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	85 c0                	test   %eax,%eax
8010605f:	0f 88 87 00 00 00    	js     801060ec <sys_exec+0xac>
80106065:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010606b:	83 ec 08             	sub    $0x8,%esp
8010606e:	50                   	push   %eax
8010606f:	6a 01                	push   $0x1
80106071:	e8 5a f4 ff ff       	call   801054d0 <argint>
80106076:	83 c4 10             	add    $0x10,%esp
80106079:	85 c0                	test   %eax,%eax
8010607b:	78 6f                	js     801060ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010607d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106083:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106086:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106088:	68 80 00 00 00       	push   $0x80
8010608d:	6a 00                	push   $0x0
8010608f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106095:	50                   	push   %eax
80106096:	e8 35 f1 ff ff       	call   801051d0 <memset>
8010609b:	83 c4 10             	add    $0x10,%esp
8010609e:	eb 2c                	jmp    801060cc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801060a0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801060a6:	85 c0                	test   %eax,%eax
801060a8:	74 56                	je     80106100 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801060aa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801060b0:	83 ec 08             	sub    $0x8,%esp
801060b3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801060b6:	52                   	push   %edx
801060b7:	50                   	push   %eax
801060b8:	e8 a3 f3 ff ff       	call   80105460 <fetchstr>
801060bd:	83 c4 10             	add    $0x10,%esp
801060c0:	85 c0                	test   %eax,%eax
801060c2:	78 28                	js     801060ec <sys_exec+0xac>
  for(i=0;; i++){
801060c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801060c7:	83 fb 20             	cmp    $0x20,%ebx
801060ca:	74 20                	je     801060ec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801060cc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801060d2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801060d9:	83 ec 08             	sub    $0x8,%esp
801060dc:	57                   	push   %edi
801060dd:	01 f0                	add    %esi,%eax
801060df:	50                   	push   %eax
801060e0:	e8 3b f3 ff ff       	call   80105420 <fetchint>
801060e5:	83 c4 10             	add    $0x10,%esp
801060e8:	85 c0                	test   %eax,%eax
801060ea:	79 b4                	jns    801060a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801060ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801060ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060f4:	5b                   	pop    %ebx
801060f5:	5e                   	pop    %esi
801060f6:	5f                   	pop    %edi
801060f7:	5d                   	pop    %ebp
801060f8:	c3                   	ret    
801060f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106100:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106106:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106109:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106110:	00 00 00 00 
  return exec(path, argv);
80106114:	50                   	push   %eax
80106115:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010611b:	e8 f0 a8 ff ff       	call   80100a10 <exec>
80106120:	83 c4 10             	add    $0x10,%esp
}
80106123:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106126:	5b                   	pop    %ebx
80106127:	5e                   	pop    %esi
80106128:	5f                   	pop    %edi
80106129:	5d                   	pop    %ebp
8010612a:	c3                   	ret    
8010612b:	90                   	nop
8010612c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106130 <sys_pipe>:

int
sys_pipe(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	57                   	push   %edi
80106134:	56                   	push   %esi
80106135:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106136:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106139:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010613c:	6a 08                	push   $0x8
8010613e:	50                   	push   %eax
8010613f:	6a 00                	push   $0x0
80106141:	e8 da f3 ff ff       	call   80105520 <argptr>
80106146:	83 c4 10             	add    $0x10,%esp
80106149:	85 c0                	test   %eax,%eax
8010614b:	0f 88 ae 00 00 00    	js     801061ff <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106151:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106154:	83 ec 08             	sub    $0x8,%esp
80106157:	50                   	push   %eax
80106158:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010615b:	50                   	push   %eax
8010615c:	e8 0f d1 ff ff       	call   80103270 <pipealloc>
80106161:	83 c4 10             	add    $0x10,%esp
80106164:	85 c0                	test   %eax,%eax
80106166:	0f 88 93 00 00 00    	js     801061ff <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010616c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010616f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106171:	e8 9a d7 ff ff       	call   80103910 <myproc>
80106176:	eb 10                	jmp    80106188 <sys_pipe+0x58>
80106178:	90                   	nop
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106180:	83 c3 01             	add    $0x1,%ebx
80106183:	83 fb 10             	cmp    $0x10,%ebx
80106186:	74 60                	je     801061e8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106188:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
8010618c:	85 f6                	test   %esi,%esi
8010618e:	75 f0                	jne    80106180 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106190:	8d 73 08             	lea    0x8(%ebx),%esi
80106193:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106196:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106199:	e8 72 d7 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010619e:	31 d2                	xor    %edx,%edx
801061a0:	eb 0e                	jmp    801061b0 <sys_pipe+0x80>
801061a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061a8:	83 c2 01             	add    $0x1,%edx
801061ab:	83 fa 10             	cmp    $0x10,%edx
801061ae:	74 28                	je     801061d8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801061b0:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
801061b4:	85 c9                	test   %ecx,%ecx
801061b6:	75 f0                	jne    801061a8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801061b8:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801061bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061bf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801061c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061c4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801061c7:	31 c0                	xor    %eax,%eax
}
801061c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061cc:	5b                   	pop    %ebx
801061cd:	5e                   	pop    %esi
801061ce:	5f                   	pop    %edi
801061cf:	5d                   	pop    %ebp
801061d0:	c3                   	ret    
801061d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801061d8:	e8 33 d7 ff ff       	call   80103910 <myproc>
801061dd:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
801061e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(rf);
801061e8:	83 ec 0c             	sub    $0xc,%esp
801061eb:	ff 75 e0             	pushl  -0x20(%ebp)
801061ee:	e8 6d ac ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
801061f3:	58                   	pop    %eax
801061f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801061f7:	e8 64 ac ff ff       	call   80100e60 <fileclose>
    return -1;
801061fc:	83 c4 10             	add    $0x10,%esp
801061ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106204:	eb c3                	jmp    801061c9 <sys_pipe+0x99>
80106206:	66 90                	xchg   %ax,%ax
80106208:	66 90                	xchg   %ax,%ax
8010620a:	66 90                	xchg   %ax,%ax
8010620c:	66 90                	xchg   %ax,%ax
8010620e:	66 90                	xchg   %ax,%ax

80106210 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106213:	5d                   	pop    %ebp
  return fork();
80106214:	e9 97 d9 ff ff       	jmp    80103bb0 <fork>
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_exit>:

int
sys_exit(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 08             	sub    $0x8,%esp
  exit();
80106226:	e8 25 df ff ff       	call   80104150 <exit>
  return 0;  // not reached
}
8010622b:	31 c0                	xor    %eax,%eax
8010622d:	c9                   	leave  
8010622e:	c3                   	ret    
8010622f:	90                   	nop

80106230 <sys_wait>:

int
sys_wait(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106233:	5d                   	pop    %ebp
  return wait();
80106234:	e9 e7 e0 ff ff       	jmp    80104320 <wait>
80106239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106240 <sys_kill>:

int
sys_kill(void)
{
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106246:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106249:	50                   	push   %eax
8010624a:	6a 00                	push   $0x0
8010624c:	e8 7f f2 ff ff       	call   801054d0 <argint>
80106251:	83 c4 10             	add    $0x10,%esp
80106254:	85 c0                	test   %eax,%eax
80106256:	78 18                	js     80106270 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106258:	83 ec 0c             	sub    $0xc,%esp
8010625b:	ff 75 f4             	pushl  -0xc(%ebp)
8010625e:	e8 dd e2 ff ff       	call   80104540 <kill>
80106263:	83 c4 10             	add    $0x10,%esp
}
80106266:	c9                   	leave  
80106267:	c3                   	ret    
80106268:	90                   	nop
80106269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106275:	c9                   	leave  
80106276:	c3                   	ret    
80106277:	89 f6                	mov    %esi,%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106280 <sys_getpid>:

int
sys_getpid(void)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106286:	e8 85 d6 ff ff       	call   80103910 <myproc>
8010628b:	8b 40 0c             	mov    0xc(%eax),%eax
}
8010628e:	c9                   	leave  
8010628f:	c3                   	ret    

80106290 <sys_sbrk>:

int
sys_sbrk(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106294:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106297:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010629a:	50                   	push   %eax
8010629b:	6a 00                	push   $0x0
8010629d:	e8 2e f2 ff ff       	call   801054d0 <argint>
801062a2:	83 c4 10             	add    $0x10,%esp
801062a5:	85 c0                	test   %eax,%eax
801062a7:	78 27                	js     801062d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801062a9:	e8 62 d6 ff ff       	call   80103910 <myproc>
  if(growproc(n) < 0)
801062ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801062b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801062b3:	ff 75 f4             	pushl  -0xc(%ebp)
801062b6:	e8 25 d8 ff ff       	call   80103ae0 <growproc>
801062bb:	83 c4 10             	add    $0x10,%esp
801062be:	85 c0                	test   %eax,%eax
801062c0:	78 0e                	js     801062d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801062c2:	89 d8                	mov    %ebx,%eax
801062c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062c7:	c9                   	leave  
801062c8:	c3                   	ret    
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062d5:	eb eb                	jmp    801062c2 <sys_sbrk+0x32>
801062d7:	89 f6                	mov    %esi,%esi
801062d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062e0 <sys_sleep>:

int
sys_sleep(void)
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801062e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801062e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801062ea:	50                   	push   %eax
801062eb:	6a 00                	push   $0x0
801062ed:	e8 de f1 ff ff       	call   801054d0 <argint>
801062f2:	83 c4 10             	add    $0x10,%esp
801062f5:	85 c0                	test   %eax,%eax
801062f7:	0f 88 8a 00 00 00    	js     80106387 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801062fd:	83 ec 0c             	sub    $0xc,%esp
80106300:	68 60 2d 12 80       	push   $0x80122d60
80106305:	e8 a6 ed ff ff       	call   801050b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010630a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010630d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106310:	8b 1d a0 35 12 80    	mov    0x801235a0,%ebx
  while(ticks - ticks0 < n){
80106316:	85 d2                	test   %edx,%edx
80106318:	75 27                	jne    80106341 <sys_sleep+0x61>
8010631a:	eb 54                	jmp    80106370 <sys_sleep+0x90>
8010631c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106320:	83 ec 08             	sub    $0x8,%esp
80106323:	68 60 2d 12 80       	push   $0x80122d60
80106328:	68 a0 35 12 80       	push   $0x801235a0
8010632d:	e8 6e dc ff ff       	call   80103fa0 <sleep>
  while(ticks - ticks0 < n){
80106332:	a1 a0 35 12 80       	mov    0x801235a0,%eax
80106337:	83 c4 10             	add    $0x10,%esp
8010633a:	29 d8                	sub    %ebx,%eax
8010633c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010633f:	73 2f                	jae    80106370 <sys_sleep+0x90>
    if(myproc()->killed){
80106341:	e8 ca d5 ff ff       	call   80103910 <myproc>
80106346:	8b 40 1c             	mov    0x1c(%eax),%eax
80106349:	85 c0                	test   %eax,%eax
8010634b:	74 d3                	je     80106320 <sys_sleep+0x40>
      release(&tickslock);
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	68 60 2d 12 80       	push   $0x80122d60
80106355:	e8 26 ee ff ff       	call   80105180 <release>
      return -1;
8010635a:	83 c4 10             	add    $0x10,%esp
8010635d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106365:	c9                   	leave  
80106366:	c3                   	ret    
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106370:	83 ec 0c             	sub    $0xc,%esp
80106373:	68 60 2d 12 80       	push   $0x80122d60
80106378:	e8 03 ee ff ff       	call   80105180 <release>
  return 0;
8010637d:	83 c4 10             	add    $0x10,%esp
80106380:	31 c0                	xor    %eax,%eax
}
80106382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106385:	c9                   	leave  
80106386:	c3                   	ret    
    return -1;
80106387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010638c:	eb f4                	jmp    80106382 <sys_sleep+0xa2>
8010638e:	66 90                	xchg   %ax,%ax

80106390 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	53                   	push   %ebx
80106394:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106397:	68 60 2d 12 80       	push   $0x80122d60
8010639c:	e8 0f ed ff ff       	call   801050b0 <acquire>
  xticks = ticks;
801063a1:	8b 1d a0 35 12 80    	mov    0x801235a0,%ebx
  release(&tickslock);
801063a7:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
801063ae:	e8 cd ed ff ff       	call   80105180 <release>
  return xticks;
}
801063b3:	89 d8                	mov    %ebx,%eax
801063b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063b8:	c9                   	leave  
801063b9:	c3                   	ret    
801063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801063c0 <sys_kthread_create>:

int
sys_kthread_create(void){
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 0c             	sub    $0xc,%esp
    void (*start_func)()=0;
    void* stack=0;
    if(argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
801063c6:	6a 01                	push   $0x1
801063c8:	6a 00                	push   $0x0
801063ca:	6a 00                	push   $0x0
801063cc:	e8 4f f1 ff ff       	call   80105520 <argptr>
801063d1:	83 c4 10             	add    $0x10,%esp
801063d4:	85 c0                	test   %eax,%eax
801063d6:	78 28                	js     80106400 <sys_kthread_create+0x40>
        return -1;
    if(argptr(0, stack, sizeof(*stack)) < 0)
801063d8:	83 ec 04             	sub    $0x4,%esp
801063db:	6a 01                	push   $0x1
801063dd:	6a 00                	push   $0x0
801063df:	6a 00                	push   $0x0
801063e1:	e8 3a f1 ff ff       	call   80105520 <argptr>
801063e6:	83 c4 10             	add    $0x10,%esp
801063e9:	85 c0                	test   %eax,%eax
801063eb:	78 13                	js     80106400 <sys_kthread_create+0x40>
        return -1;
    return kthread_create(start_func, stack);
801063ed:	83 ec 08             	sub    $0x8,%esp
801063f0:	6a 00                	push   $0x0
801063f2:	6a 00                	push   $0x0
801063f4:	e8 e7 e2 ff ff       	call   801046e0 <kthread_create>
801063f9:	83 c4 10             	add    $0x10,%esp
}
801063fc:	c9                   	leave  
801063fd:	c3                   	ret    
801063fe:	66 90                	xchg   %ax,%ax
        return -1;
80106400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106405:	c9                   	leave  
80106406:	c3                   	ret    
80106407:	89 f6                	mov    %esi,%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106410 <sys_kthread_id>:

int
sys_kthread_id(void){
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 08             	sub    $0x8,%esp
    return mythread()->tid;
80106416:	e8 25 d5 ff ff       	call   80103940 <mythread>
8010641b:	8b 40 0c             	mov    0xc(%eax),%eax
}
8010641e:	c9                   	leave  
8010641f:	c3                   	ret    

80106420 <sys_kthread_exit>:

int
sys_kthread_exit(void){
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	83 ec 08             	sub    $0x8,%esp
    kthread_exit();
80106426:	e8 75 e4 ff ff       	call   801048a0 <kthread_exit>
    return 0;
}
8010642b:	31 c0                	xor    %eax,%eax
8010642d:	c9                   	leave  
8010642e:	c3                   	ret    
8010642f:	90                   	nop

80106430 <sys_kthread_join>:

int
sys_kthread_join(void){
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if(argint(0, &tid) < 0)
80106436:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106439:	50                   	push   %eax
8010643a:	6a 00                	push   $0x0
8010643c:	e8 8f f0 ff ff       	call   801054d0 <argint>
80106441:	83 c4 10             	add    $0x10,%esp
80106444:	85 c0                	test   %eax,%eax
80106446:	78 18                	js     80106460 <sys_kthread_join+0x30>
        return -1;
    return kthread_join(tid);
80106448:	83 ec 0c             	sub    $0xc,%esp
8010644b:	ff 75 f4             	pushl  -0xc(%ebp)
8010644e:	e8 ed e4 ff ff       	call   80104940 <kthread_join>
80106453:	83 c4 10             	add    $0x10,%esp
}
80106456:	c9                   	leave  
80106457:	c3                   	ret    
80106458:	90                   	nop
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106465:	c9                   	leave  
80106466:	c3                   	ret    

80106467 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106467:	1e                   	push   %ds
  pushl %es
80106468:	06                   	push   %es
  pushl %fs
80106469:	0f a0                	push   %fs
  pushl %gs
8010646b:	0f a8                	push   %gs
  pushal
8010646d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010646e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106472:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106474:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106476:	54                   	push   %esp
  call trap
80106477:	e8 c4 00 00 00       	call   80106540 <trap>
  addl $4, %esp
8010647c:	83 c4 04             	add    $0x4,%esp

8010647f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010647f:	61                   	popa   
  popl %gs
80106480:	0f a9                	pop    %gs
  popl %fs
80106482:	0f a1                	pop    %fs
  popl %es
80106484:	07                   	pop    %es
  popl %ds
80106485:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106486:	83 c4 08             	add    $0x8,%esp
  iret
80106489:	cf                   	iret   
8010648a:	66 90                	xchg   %ax,%ax
8010648c:	66 90                	xchg   %ax,%ax
8010648e:	66 90                	xchg   %ax,%ax

80106490 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106490:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106491:	31 c0                	xor    %eax,%eax
{
80106493:	89 e5                	mov    %esp,%ebp
80106495:	83 ec 08             	sub    $0x8,%esp
80106498:	90                   	nop
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801064a0:	8b 14 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%edx
801064a7:	c7 04 c5 a2 2d 12 80 	movl   $0x8e000008,-0x7fedd25e(,%eax,8)
801064ae:	08 00 00 8e 
801064b2:	66 89 14 c5 a0 2d 12 	mov    %dx,-0x7fedd260(,%eax,8)
801064b9:	80 
801064ba:	c1 ea 10             	shr    $0x10,%edx
801064bd:	66 89 14 c5 a6 2d 12 	mov    %dx,-0x7fedd25a(,%eax,8)
801064c4:	80 
  for(i = 0; i < 256; i++)
801064c5:	83 c0 01             	add    $0x1,%eax
801064c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801064cd:	75 d1                	jne    801064a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064cf:	a1 10 b1 10 80       	mov    0x8010b110,%eax

  initlock(&tickslock, "time");
801064d4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064d7:	c7 05 a2 2f 12 80 08 	movl   $0xef000008,0x80122fa2
801064de:	00 00 ef 
  initlock(&tickslock, "time");
801064e1:	68 c9 85 10 80       	push   $0x801085c9
801064e6:	68 60 2d 12 80       	push   $0x80122d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064eb:	66 a3 a0 2f 12 80    	mov    %ax,0x80122fa0
801064f1:	c1 e8 10             	shr    $0x10,%eax
801064f4:	66 a3 a6 2f 12 80    	mov    %ax,0x80122fa6
  initlock(&tickslock, "time");
801064fa:	e8 71 ea ff ff       	call   80104f70 <initlock>
}
801064ff:	83 c4 10             	add    $0x10,%esp
80106502:	c9                   	leave  
80106503:	c3                   	ret    
80106504:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010650a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106510 <idtinit>:

void
idtinit(void)
{
80106510:	55                   	push   %ebp
  pd[0] = size-1;
80106511:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106516:	89 e5                	mov    %esp,%ebp
80106518:	83 ec 10             	sub    $0x10,%esp
8010651b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010651f:	b8 a0 2d 12 80       	mov    $0x80122da0,%eax
80106524:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106528:	c1 e8 10             	shr    $0x10,%eax
8010652b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010652f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106532:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106535:	c9                   	leave  
80106536:	c3                   	ret    
80106537:	89 f6                	mov    %esi,%esi
80106539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106540 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	57                   	push   %edi
80106544:	56                   	push   %esi
80106545:	53                   	push   %ebx
80106546:	83 ec 1c             	sub    $0x1c,%esp
80106549:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010654c:	8b 47 30             	mov    0x30(%edi),%eax
8010654f:	83 f8 40             	cmp    $0x40,%eax
80106552:	0f 84 f0 00 00 00    	je     80106648 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106558:	83 e8 20             	sub    $0x20,%eax
8010655b:	83 f8 1f             	cmp    $0x1f,%eax
8010655e:	77 10                	ja     80106570 <trap+0x30>
80106560:	ff 24 85 70 86 10 80 	jmp    *-0x7fef7990(,%eax,4)
80106567:	89 f6                	mov    %esi,%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106570:	e8 9b d3 ff ff       	call   80103910 <myproc>
80106575:	85 c0                	test   %eax,%eax
80106577:	8b 5f 38             	mov    0x38(%edi),%ebx
8010657a:	0f 84 14 02 00 00    	je     80106794 <trap+0x254>
80106580:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106584:	0f 84 0a 02 00 00    	je     80106794 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010658a:	0f 20 d1             	mov    %cr2,%ecx
8010658d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106590:	e8 5b d3 ff ff       	call   801038f0 <cpuid>
80106595:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106598:	8b 47 34             	mov    0x34(%edi),%eax
8010659b:	8b 77 30             	mov    0x30(%edi),%esi
8010659e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801065a1:	e8 6a d3 ff ff       	call   80103910 <myproc>
801065a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801065a9:	e8 62 d3 ff ff       	call   80103910 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801065b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801065b4:	51                   	push   %ecx
801065b5:	53                   	push   %ebx
801065b6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801065b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065ba:	ff 75 e4             	pushl  -0x1c(%ebp)
801065bd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801065be:	83 c2 64             	add    $0x64,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065c1:	52                   	push   %edx
801065c2:	ff 70 0c             	pushl  0xc(%eax)
801065c5:	68 2c 86 10 80       	push   $0x8010862c
801065ca:	e8 91 a0 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801065cf:	83 c4 20             	add    $0x20,%esp
801065d2:	e8 39 d3 ff ff       	call   80103910 <myproc>
801065d7:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065de:	e8 2d d3 ff ff       	call   80103910 <myproc>
801065e3:	85 c0                	test   %eax,%eax
801065e5:	74 1d                	je     80106604 <trap+0xc4>
801065e7:	e8 24 d3 ff ff       	call   80103910 <myproc>
801065ec:	8b 50 1c             	mov    0x1c(%eax),%edx
801065ef:	85 d2                	test   %edx,%edx
801065f1:	74 11                	je     80106604 <trap+0xc4>
801065f3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801065f7:	83 e0 03             	and    $0x3,%eax
801065fa:	66 83 f8 03          	cmp    $0x3,%ax
801065fe:	0f 84 4c 01 00 00    	je     80106750 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106604:	e8 07 d3 ff ff       	call   80103910 <myproc>
80106609:	85 c0                	test   %eax,%eax
8010660b:	74 0b                	je     80106618 <trap+0xd8>
8010660d:	e8 fe d2 ff ff       	call   80103910 <myproc>
80106612:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80106616:	74 68                	je     80106680 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106618:	e8 f3 d2 ff ff       	call   80103910 <myproc>
8010661d:	85 c0                	test   %eax,%eax
8010661f:	74 19                	je     8010663a <trap+0xfa>
80106621:	e8 ea d2 ff ff       	call   80103910 <myproc>
80106626:	8b 40 1c             	mov    0x1c(%eax),%eax
80106629:	85 c0                	test   %eax,%eax
8010662b:	74 0d                	je     8010663a <trap+0xfa>
8010662d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106631:	83 e0 03             	and    $0x3,%eax
80106634:	66 83 f8 03          	cmp    $0x3,%ax
80106638:	74 37                	je     80106671 <trap+0x131>
    exit();
}
8010663a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010663d:	5b                   	pop    %ebx
8010663e:	5e                   	pop    %esi
8010663f:	5f                   	pop    %edi
80106640:	5d                   	pop    %ebp
80106641:	c3                   	ret    
80106642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106648:	e8 c3 d2 ff ff       	call   80103910 <myproc>
8010664d:	8b 58 1c             	mov    0x1c(%eax),%ebx
80106650:	85 db                	test   %ebx,%ebx
80106652:	0f 85 e8 00 00 00    	jne    80106740 <trap+0x200>
    mythread()->tf = tf;
80106658:	e8 e3 d2 ff ff       	call   80103940 <mythread>
8010665d:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
80106660:	e8 5b ef ff ff       	call   801055c0 <syscall>
    if(myproc()->killed)
80106665:	e8 a6 d2 ff ff       	call   80103910 <myproc>
8010666a:	8b 48 1c             	mov    0x1c(%eax),%ecx
8010666d:	85 c9                	test   %ecx,%ecx
8010666f:	74 c9                	je     8010663a <trap+0xfa>
}
80106671:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106674:	5b                   	pop    %ebx
80106675:	5e                   	pop    %esi
80106676:	5f                   	pop    %edi
80106677:	5d                   	pop    %ebp
      exit();
80106678:	e9 d3 da ff ff       	jmp    80104150 <exit>
8010667d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106680:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106684:	75 92                	jne    80106618 <trap+0xd8>
    yield();
80106686:	e8 c5 d8 ff ff       	call   80103f50 <yield>
8010668b:	eb 8b                	jmp    80106618 <trap+0xd8>
8010668d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106690:	e8 5b d2 ff ff       	call   801038f0 <cpuid>
80106695:	85 c0                	test   %eax,%eax
80106697:	0f 84 c3 00 00 00    	je     80106760 <trap+0x220>
    lapiceoi();
8010669d:	e8 de c0 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066a2:	e8 69 d2 ff ff       	call   80103910 <myproc>
801066a7:	85 c0                	test   %eax,%eax
801066a9:	0f 85 38 ff ff ff    	jne    801065e7 <trap+0xa7>
801066af:	e9 50 ff ff ff       	jmp    80106604 <trap+0xc4>
801066b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801066b8:	e8 83 bf ff ff       	call   80102640 <kbdintr>
    lapiceoi();
801066bd:	e8 be c0 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066c2:	e8 49 d2 ff ff       	call   80103910 <myproc>
801066c7:	85 c0                	test   %eax,%eax
801066c9:	0f 85 18 ff ff ff    	jne    801065e7 <trap+0xa7>
801066cf:	e9 30 ff ff ff       	jmp    80106604 <trap+0xc4>
801066d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801066d8:	e8 53 02 00 00       	call   80106930 <uartintr>
    lapiceoi();
801066dd:	e8 9e c0 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066e2:	e8 29 d2 ff ff       	call   80103910 <myproc>
801066e7:	85 c0                	test   %eax,%eax
801066e9:	0f 85 f8 fe ff ff    	jne    801065e7 <trap+0xa7>
801066ef:	e9 10 ff ff ff       	jmp    80106604 <trap+0xc4>
801066f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801066f8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801066fc:	8b 77 38             	mov    0x38(%edi),%esi
801066ff:	e8 ec d1 ff ff       	call   801038f0 <cpuid>
80106704:	56                   	push   %esi
80106705:	53                   	push   %ebx
80106706:	50                   	push   %eax
80106707:	68 d4 85 10 80       	push   $0x801085d4
8010670c:	e8 4f 9f ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106711:	e8 6a c0 ff ff       	call   80102780 <lapiceoi>
    break;
80106716:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106719:	e8 f2 d1 ff ff       	call   80103910 <myproc>
8010671e:	85 c0                	test   %eax,%eax
80106720:	0f 85 c1 fe ff ff    	jne    801065e7 <trap+0xa7>
80106726:	e9 d9 fe ff ff       	jmp    80106604 <trap+0xc4>
8010672b:	90                   	nop
8010672c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106730:	e8 7b b9 ff ff       	call   801020b0 <ideintr>
80106735:	e9 63 ff ff ff       	jmp    8010669d <trap+0x15d>
8010673a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106740:	e8 0b da ff ff       	call   80104150 <exit>
80106745:	e9 0e ff ff ff       	jmp    80106658 <trap+0x118>
8010674a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106750:	e8 fb d9 ff ff       	call   80104150 <exit>
80106755:	e9 aa fe ff ff       	jmp    80106604 <trap+0xc4>
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106760:	83 ec 0c             	sub    $0xc,%esp
80106763:	68 60 2d 12 80       	push   $0x80122d60
80106768:	e8 43 e9 ff ff       	call   801050b0 <acquire>
      wakeup(&ticks);
8010676d:	c7 04 24 a0 35 12 80 	movl   $0x801235a0,(%esp)
      ticks++;
80106774:	83 05 a0 35 12 80 01 	addl   $0x1,0x801235a0
      wakeup(&ticks);
8010677b:	e8 20 dd ff ff       	call   801044a0 <wakeup>
      release(&tickslock);
80106780:	c7 04 24 60 2d 12 80 	movl   $0x80122d60,(%esp)
80106787:	e8 f4 e9 ff ff       	call   80105180 <release>
8010678c:	83 c4 10             	add    $0x10,%esp
8010678f:	e9 09 ff ff ff       	jmp    8010669d <trap+0x15d>
80106794:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106797:	e8 54 d1 ff ff       	call   801038f0 <cpuid>
8010679c:	83 ec 0c             	sub    $0xc,%esp
8010679f:	56                   	push   %esi
801067a0:	53                   	push   %ebx
801067a1:	50                   	push   %eax
801067a2:	ff 77 30             	pushl  0x30(%edi)
801067a5:	68 f8 85 10 80       	push   $0x801085f8
801067aa:	e8 b1 9e ff ff       	call   80100660 <cprintf>
      panic("trap");
801067af:	83 c4 14             	add    $0x14,%esp
801067b2:	68 ce 85 10 80       	push   $0x801085ce
801067b7:	e8 d4 9b ff ff       	call   80100390 <panic>
801067bc:	66 90                	xchg   %ax,%ax
801067be:	66 90                	xchg   %ax,%ax

801067c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801067c0:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
{
801067c5:	55                   	push   %ebp
801067c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801067c8:	85 c0                	test   %eax,%eax
801067ca:	74 1c                	je     801067e8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801067d2:	a8 01                	test   $0x1,%al
801067d4:	74 12                	je     801067e8 <uartgetc+0x28>
801067d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067db:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801067dc:	0f b6 c0             	movzbl %al,%eax
}
801067df:	5d                   	pop    %ebp
801067e0:	c3                   	ret    
801067e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801067e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067ed:	5d                   	pop    %ebp
801067ee:	c3                   	ret    
801067ef:	90                   	nop

801067f0 <uartputc.part.0>:
uartputc(int c)
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	56                   	push   %esi
801067f5:	53                   	push   %ebx
801067f6:	89 c7                	mov    %eax,%edi
801067f8:	bb 80 00 00 00       	mov    $0x80,%ebx
801067fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106802:	83 ec 0c             	sub    $0xc,%esp
80106805:	eb 1b                	jmp    80106822 <uartputc.part.0+0x32>
80106807:	89 f6                	mov    %esi,%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106810:	83 ec 0c             	sub    $0xc,%esp
80106813:	6a 0a                	push   $0xa
80106815:	e8 86 bf ff ff       	call   801027a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010681a:	83 c4 10             	add    $0x10,%esp
8010681d:	83 eb 01             	sub    $0x1,%ebx
80106820:	74 07                	je     80106829 <uartputc.part.0+0x39>
80106822:	89 f2                	mov    %esi,%edx
80106824:	ec                   	in     (%dx),%al
80106825:	a8 20                	test   $0x20,%al
80106827:	74 e7                	je     80106810 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106829:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010682e:	89 f8                	mov    %edi,%eax
80106830:	ee                   	out    %al,(%dx)
}
80106831:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106834:	5b                   	pop    %ebx
80106835:	5e                   	pop    %esi
80106836:	5f                   	pop    %edi
80106837:	5d                   	pop    %ebp
80106838:	c3                   	ret    
80106839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106840 <uartinit>:
{
80106840:	55                   	push   %ebp
80106841:	31 c9                	xor    %ecx,%ecx
80106843:	89 c8                	mov    %ecx,%eax
80106845:	89 e5                	mov    %esp,%ebp
80106847:	57                   	push   %edi
80106848:	56                   	push   %esi
80106849:	53                   	push   %ebx
8010684a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010684f:	89 da                	mov    %ebx,%edx
80106851:	83 ec 0c             	sub    $0xc,%esp
80106854:	ee                   	out    %al,(%dx)
80106855:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010685a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010685f:	89 fa                	mov    %edi,%edx
80106861:	ee                   	out    %al,(%dx)
80106862:	b8 0c 00 00 00       	mov    $0xc,%eax
80106867:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010686c:	ee                   	out    %al,(%dx)
8010686d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106872:	89 c8                	mov    %ecx,%eax
80106874:	89 f2                	mov    %esi,%edx
80106876:	ee                   	out    %al,(%dx)
80106877:	b8 03 00 00 00       	mov    $0x3,%eax
8010687c:	89 fa                	mov    %edi,%edx
8010687e:	ee                   	out    %al,(%dx)
8010687f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106884:	89 c8                	mov    %ecx,%eax
80106886:	ee                   	out    %al,(%dx)
80106887:	b8 01 00 00 00       	mov    $0x1,%eax
8010688c:	89 f2                	mov    %esi,%edx
8010688e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010688f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106894:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106895:	3c ff                	cmp    $0xff,%al
80106897:	74 5a                	je     801068f3 <uartinit+0xb3>
  uart = 1;
80106899:	c7 05 c4 b5 10 80 01 	movl   $0x1,0x8010b5c4
801068a0:	00 00 00 
801068a3:	89 da                	mov    %ebx,%edx
801068a5:	ec                   	in     (%dx),%al
801068a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068ab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801068ac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801068af:	bb f0 86 10 80       	mov    $0x801086f0,%ebx
  ioapicenable(IRQ_COM1, 0);
801068b4:	6a 00                	push   $0x0
801068b6:	6a 04                	push   $0x4
801068b8:	e8 43 ba ff ff       	call   80102300 <ioapicenable>
801068bd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801068c0:	b8 78 00 00 00       	mov    $0x78,%eax
801068c5:	eb 13                	jmp    801068da <uartinit+0x9a>
801068c7:	89 f6                	mov    %esi,%esi
801068c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801068d0:	83 c3 01             	add    $0x1,%ebx
801068d3:	0f be 03             	movsbl (%ebx),%eax
801068d6:	84 c0                	test   %al,%al
801068d8:	74 19                	je     801068f3 <uartinit+0xb3>
  if(!uart)
801068da:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
801068e0:	85 d2                	test   %edx,%edx
801068e2:	74 ec                	je     801068d0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801068e4:	83 c3 01             	add    $0x1,%ebx
801068e7:	e8 04 ff ff ff       	call   801067f0 <uartputc.part.0>
801068ec:	0f be 03             	movsbl (%ebx),%eax
801068ef:	84 c0                	test   %al,%al
801068f1:	75 e7                	jne    801068da <uartinit+0x9a>
}
801068f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068f6:	5b                   	pop    %ebx
801068f7:	5e                   	pop    %esi
801068f8:	5f                   	pop    %edi
801068f9:	5d                   	pop    %ebp
801068fa:	c3                   	ret    
801068fb:	90                   	nop
801068fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106900 <uartputc>:
  if(!uart)
80106900:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
{
80106906:	55                   	push   %ebp
80106907:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106909:	85 d2                	test   %edx,%edx
{
8010690b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010690e:	74 10                	je     80106920 <uartputc+0x20>
}
80106910:	5d                   	pop    %ebp
80106911:	e9 da fe ff ff       	jmp    801067f0 <uartputc.part.0>
80106916:	8d 76 00             	lea    0x0(%esi),%esi
80106919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106920:	5d                   	pop    %ebp
80106921:	c3                   	ret    
80106922:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106930 <uartintr>:

void
uartintr(void)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106936:	68 c0 67 10 80       	push   $0x801067c0
8010693b:	e8 d0 9e ff ff       	call   80100810 <consoleintr>
}
80106940:	83 c4 10             	add    $0x10,%esp
80106943:	c9                   	leave  
80106944:	c3                   	ret    

80106945 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106945:	6a 00                	push   $0x0
  pushl $0
80106947:	6a 00                	push   $0x0
  jmp alltraps
80106949:	e9 19 fb ff ff       	jmp    80106467 <alltraps>

8010694e <vector1>:
.globl vector1
vector1:
  pushl $0
8010694e:	6a 00                	push   $0x0
  pushl $1
80106950:	6a 01                	push   $0x1
  jmp alltraps
80106952:	e9 10 fb ff ff       	jmp    80106467 <alltraps>

80106957 <vector2>:
.globl vector2
vector2:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $2
80106959:	6a 02                	push   $0x2
  jmp alltraps
8010695b:	e9 07 fb ff ff       	jmp    80106467 <alltraps>

80106960 <vector3>:
.globl vector3
vector3:
  pushl $0
80106960:	6a 00                	push   $0x0
  pushl $3
80106962:	6a 03                	push   $0x3
  jmp alltraps
80106964:	e9 fe fa ff ff       	jmp    80106467 <alltraps>

80106969 <vector4>:
.globl vector4
vector4:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $4
8010696b:	6a 04                	push   $0x4
  jmp alltraps
8010696d:	e9 f5 fa ff ff       	jmp    80106467 <alltraps>

80106972 <vector5>:
.globl vector5
vector5:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $5
80106974:	6a 05                	push   $0x5
  jmp alltraps
80106976:	e9 ec fa ff ff       	jmp    80106467 <alltraps>

8010697b <vector6>:
.globl vector6
vector6:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $6
8010697d:	6a 06                	push   $0x6
  jmp alltraps
8010697f:	e9 e3 fa ff ff       	jmp    80106467 <alltraps>

80106984 <vector7>:
.globl vector7
vector7:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $7
80106986:	6a 07                	push   $0x7
  jmp alltraps
80106988:	e9 da fa ff ff       	jmp    80106467 <alltraps>

8010698d <vector8>:
.globl vector8
vector8:
  pushl $8
8010698d:	6a 08                	push   $0x8
  jmp alltraps
8010698f:	e9 d3 fa ff ff       	jmp    80106467 <alltraps>

80106994 <vector9>:
.globl vector9
vector9:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $9
80106996:	6a 09                	push   $0x9
  jmp alltraps
80106998:	e9 ca fa ff ff       	jmp    80106467 <alltraps>

8010699d <vector10>:
.globl vector10
vector10:
  pushl $10
8010699d:	6a 0a                	push   $0xa
  jmp alltraps
8010699f:	e9 c3 fa ff ff       	jmp    80106467 <alltraps>

801069a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801069a4:	6a 0b                	push   $0xb
  jmp alltraps
801069a6:	e9 bc fa ff ff       	jmp    80106467 <alltraps>

801069ab <vector12>:
.globl vector12
vector12:
  pushl $12
801069ab:	6a 0c                	push   $0xc
  jmp alltraps
801069ad:	e9 b5 fa ff ff       	jmp    80106467 <alltraps>

801069b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801069b2:	6a 0d                	push   $0xd
  jmp alltraps
801069b4:	e9 ae fa ff ff       	jmp    80106467 <alltraps>

801069b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801069b9:	6a 0e                	push   $0xe
  jmp alltraps
801069bb:	e9 a7 fa ff ff       	jmp    80106467 <alltraps>

801069c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $15
801069c2:	6a 0f                	push   $0xf
  jmp alltraps
801069c4:	e9 9e fa ff ff       	jmp    80106467 <alltraps>

801069c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $16
801069cb:	6a 10                	push   $0x10
  jmp alltraps
801069cd:	e9 95 fa ff ff       	jmp    80106467 <alltraps>

801069d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801069d2:	6a 11                	push   $0x11
  jmp alltraps
801069d4:	e9 8e fa ff ff       	jmp    80106467 <alltraps>

801069d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $18
801069db:	6a 12                	push   $0x12
  jmp alltraps
801069dd:	e9 85 fa ff ff       	jmp    80106467 <alltraps>

801069e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $19
801069e4:	6a 13                	push   $0x13
  jmp alltraps
801069e6:	e9 7c fa ff ff       	jmp    80106467 <alltraps>

801069eb <vector20>:
.globl vector20
vector20:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $20
801069ed:	6a 14                	push   $0x14
  jmp alltraps
801069ef:	e9 73 fa ff ff       	jmp    80106467 <alltraps>

801069f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $21
801069f6:	6a 15                	push   $0x15
  jmp alltraps
801069f8:	e9 6a fa ff ff       	jmp    80106467 <alltraps>

801069fd <vector22>:
.globl vector22
vector22:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $22
801069ff:	6a 16                	push   $0x16
  jmp alltraps
80106a01:	e9 61 fa ff ff       	jmp    80106467 <alltraps>

80106a06 <vector23>:
.globl vector23
vector23:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $23
80106a08:	6a 17                	push   $0x17
  jmp alltraps
80106a0a:	e9 58 fa ff ff       	jmp    80106467 <alltraps>

80106a0f <vector24>:
.globl vector24
vector24:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $24
80106a11:	6a 18                	push   $0x18
  jmp alltraps
80106a13:	e9 4f fa ff ff       	jmp    80106467 <alltraps>

80106a18 <vector25>:
.globl vector25
vector25:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $25
80106a1a:	6a 19                	push   $0x19
  jmp alltraps
80106a1c:	e9 46 fa ff ff       	jmp    80106467 <alltraps>

80106a21 <vector26>:
.globl vector26
vector26:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $26
80106a23:	6a 1a                	push   $0x1a
  jmp alltraps
80106a25:	e9 3d fa ff ff       	jmp    80106467 <alltraps>

80106a2a <vector27>:
.globl vector27
vector27:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $27
80106a2c:	6a 1b                	push   $0x1b
  jmp alltraps
80106a2e:	e9 34 fa ff ff       	jmp    80106467 <alltraps>

80106a33 <vector28>:
.globl vector28
vector28:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $28
80106a35:	6a 1c                	push   $0x1c
  jmp alltraps
80106a37:	e9 2b fa ff ff       	jmp    80106467 <alltraps>

80106a3c <vector29>:
.globl vector29
vector29:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $29
80106a3e:	6a 1d                	push   $0x1d
  jmp alltraps
80106a40:	e9 22 fa ff ff       	jmp    80106467 <alltraps>

80106a45 <vector30>:
.globl vector30
vector30:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $30
80106a47:	6a 1e                	push   $0x1e
  jmp alltraps
80106a49:	e9 19 fa ff ff       	jmp    80106467 <alltraps>

80106a4e <vector31>:
.globl vector31
vector31:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $31
80106a50:	6a 1f                	push   $0x1f
  jmp alltraps
80106a52:	e9 10 fa ff ff       	jmp    80106467 <alltraps>

80106a57 <vector32>:
.globl vector32
vector32:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $32
80106a59:	6a 20                	push   $0x20
  jmp alltraps
80106a5b:	e9 07 fa ff ff       	jmp    80106467 <alltraps>

80106a60 <vector33>:
.globl vector33
vector33:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $33
80106a62:	6a 21                	push   $0x21
  jmp alltraps
80106a64:	e9 fe f9 ff ff       	jmp    80106467 <alltraps>

80106a69 <vector34>:
.globl vector34
vector34:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $34
80106a6b:	6a 22                	push   $0x22
  jmp alltraps
80106a6d:	e9 f5 f9 ff ff       	jmp    80106467 <alltraps>

80106a72 <vector35>:
.globl vector35
vector35:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $35
80106a74:	6a 23                	push   $0x23
  jmp alltraps
80106a76:	e9 ec f9 ff ff       	jmp    80106467 <alltraps>

80106a7b <vector36>:
.globl vector36
vector36:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $36
80106a7d:	6a 24                	push   $0x24
  jmp alltraps
80106a7f:	e9 e3 f9 ff ff       	jmp    80106467 <alltraps>

80106a84 <vector37>:
.globl vector37
vector37:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $37
80106a86:	6a 25                	push   $0x25
  jmp alltraps
80106a88:	e9 da f9 ff ff       	jmp    80106467 <alltraps>

80106a8d <vector38>:
.globl vector38
vector38:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $38
80106a8f:	6a 26                	push   $0x26
  jmp alltraps
80106a91:	e9 d1 f9 ff ff       	jmp    80106467 <alltraps>

80106a96 <vector39>:
.globl vector39
vector39:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $39
80106a98:	6a 27                	push   $0x27
  jmp alltraps
80106a9a:	e9 c8 f9 ff ff       	jmp    80106467 <alltraps>

80106a9f <vector40>:
.globl vector40
vector40:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $40
80106aa1:	6a 28                	push   $0x28
  jmp alltraps
80106aa3:	e9 bf f9 ff ff       	jmp    80106467 <alltraps>

80106aa8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $41
80106aaa:	6a 29                	push   $0x29
  jmp alltraps
80106aac:	e9 b6 f9 ff ff       	jmp    80106467 <alltraps>

80106ab1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $42
80106ab3:	6a 2a                	push   $0x2a
  jmp alltraps
80106ab5:	e9 ad f9 ff ff       	jmp    80106467 <alltraps>

80106aba <vector43>:
.globl vector43
vector43:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $43
80106abc:	6a 2b                	push   $0x2b
  jmp alltraps
80106abe:	e9 a4 f9 ff ff       	jmp    80106467 <alltraps>

80106ac3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $44
80106ac5:	6a 2c                	push   $0x2c
  jmp alltraps
80106ac7:	e9 9b f9 ff ff       	jmp    80106467 <alltraps>

80106acc <vector45>:
.globl vector45
vector45:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $45
80106ace:	6a 2d                	push   $0x2d
  jmp alltraps
80106ad0:	e9 92 f9 ff ff       	jmp    80106467 <alltraps>

80106ad5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $46
80106ad7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ad9:	e9 89 f9 ff ff       	jmp    80106467 <alltraps>

80106ade <vector47>:
.globl vector47
vector47:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $47
80106ae0:	6a 2f                	push   $0x2f
  jmp alltraps
80106ae2:	e9 80 f9 ff ff       	jmp    80106467 <alltraps>

80106ae7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $48
80106ae9:	6a 30                	push   $0x30
  jmp alltraps
80106aeb:	e9 77 f9 ff ff       	jmp    80106467 <alltraps>

80106af0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106af0:	6a 00                	push   $0x0
  pushl $49
80106af2:	6a 31                	push   $0x31
  jmp alltraps
80106af4:	e9 6e f9 ff ff       	jmp    80106467 <alltraps>

80106af9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $50
80106afb:	6a 32                	push   $0x32
  jmp alltraps
80106afd:	e9 65 f9 ff ff       	jmp    80106467 <alltraps>

80106b02 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $51
80106b04:	6a 33                	push   $0x33
  jmp alltraps
80106b06:	e9 5c f9 ff ff       	jmp    80106467 <alltraps>

80106b0b <vector52>:
.globl vector52
vector52:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $52
80106b0d:	6a 34                	push   $0x34
  jmp alltraps
80106b0f:	e9 53 f9 ff ff       	jmp    80106467 <alltraps>

80106b14 <vector53>:
.globl vector53
vector53:
  pushl $0
80106b14:	6a 00                	push   $0x0
  pushl $53
80106b16:	6a 35                	push   $0x35
  jmp alltraps
80106b18:	e9 4a f9 ff ff       	jmp    80106467 <alltraps>

80106b1d <vector54>:
.globl vector54
vector54:
  pushl $0
80106b1d:	6a 00                	push   $0x0
  pushl $54
80106b1f:	6a 36                	push   $0x36
  jmp alltraps
80106b21:	e9 41 f9 ff ff       	jmp    80106467 <alltraps>

80106b26 <vector55>:
.globl vector55
vector55:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $55
80106b28:	6a 37                	push   $0x37
  jmp alltraps
80106b2a:	e9 38 f9 ff ff       	jmp    80106467 <alltraps>

80106b2f <vector56>:
.globl vector56
vector56:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $56
80106b31:	6a 38                	push   $0x38
  jmp alltraps
80106b33:	e9 2f f9 ff ff       	jmp    80106467 <alltraps>

80106b38 <vector57>:
.globl vector57
vector57:
  pushl $0
80106b38:	6a 00                	push   $0x0
  pushl $57
80106b3a:	6a 39                	push   $0x39
  jmp alltraps
80106b3c:	e9 26 f9 ff ff       	jmp    80106467 <alltraps>

80106b41 <vector58>:
.globl vector58
vector58:
  pushl $0
80106b41:	6a 00                	push   $0x0
  pushl $58
80106b43:	6a 3a                	push   $0x3a
  jmp alltraps
80106b45:	e9 1d f9 ff ff       	jmp    80106467 <alltraps>

80106b4a <vector59>:
.globl vector59
vector59:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $59
80106b4c:	6a 3b                	push   $0x3b
  jmp alltraps
80106b4e:	e9 14 f9 ff ff       	jmp    80106467 <alltraps>

80106b53 <vector60>:
.globl vector60
vector60:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $60
80106b55:	6a 3c                	push   $0x3c
  jmp alltraps
80106b57:	e9 0b f9 ff ff       	jmp    80106467 <alltraps>

80106b5c <vector61>:
.globl vector61
vector61:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $61
80106b5e:	6a 3d                	push   $0x3d
  jmp alltraps
80106b60:	e9 02 f9 ff ff       	jmp    80106467 <alltraps>

80106b65 <vector62>:
.globl vector62
vector62:
  pushl $0
80106b65:	6a 00                	push   $0x0
  pushl $62
80106b67:	6a 3e                	push   $0x3e
  jmp alltraps
80106b69:	e9 f9 f8 ff ff       	jmp    80106467 <alltraps>

80106b6e <vector63>:
.globl vector63
vector63:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $63
80106b70:	6a 3f                	push   $0x3f
  jmp alltraps
80106b72:	e9 f0 f8 ff ff       	jmp    80106467 <alltraps>

80106b77 <vector64>:
.globl vector64
vector64:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $64
80106b79:	6a 40                	push   $0x40
  jmp alltraps
80106b7b:	e9 e7 f8 ff ff       	jmp    80106467 <alltraps>

80106b80 <vector65>:
.globl vector65
vector65:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $65
80106b82:	6a 41                	push   $0x41
  jmp alltraps
80106b84:	e9 de f8 ff ff       	jmp    80106467 <alltraps>

80106b89 <vector66>:
.globl vector66
vector66:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $66
80106b8b:	6a 42                	push   $0x42
  jmp alltraps
80106b8d:	e9 d5 f8 ff ff       	jmp    80106467 <alltraps>

80106b92 <vector67>:
.globl vector67
vector67:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $67
80106b94:	6a 43                	push   $0x43
  jmp alltraps
80106b96:	e9 cc f8 ff ff       	jmp    80106467 <alltraps>

80106b9b <vector68>:
.globl vector68
vector68:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $68
80106b9d:	6a 44                	push   $0x44
  jmp alltraps
80106b9f:	e9 c3 f8 ff ff       	jmp    80106467 <alltraps>

80106ba4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $69
80106ba6:	6a 45                	push   $0x45
  jmp alltraps
80106ba8:	e9 ba f8 ff ff       	jmp    80106467 <alltraps>

80106bad <vector70>:
.globl vector70
vector70:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $70
80106baf:	6a 46                	push   $0x46
  jmp alltraps
80106bb1:	e9 b1 f8 ff ff       	jmp    80106467 <alltraps>

80106bb6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $71
80106bb8:	6a 47                	push   $0x47
  jmp alltraps
80106bba:	e9 a8 f8 ff ff       	jmp    80106467 <alltraps>

80106bbf <vector72>:
.globl vector72
vector72:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $72
80106bc1:	6a 48                	push   $0x48
  jmp alltraps
80106bc3:	e9 9f f8 ff ff       	jmp    80106467 <alltraps>

80106bc8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $73
80106bca:	6a 49                	push   $0x49
  jmp alltraps
80106bcc:	e9 96 f8 ff ff       	jmp    80106467 <alltraps>

80106bd1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106bd1:	6a 00                	push   $0x0
  pushl $74
80106bd3:	6a 4a                	push   $0x4a
  jmp alltraps
80106bd5:	e9 8d f8 ff ff       	jmp    80106467 <alltraps>

80106bda <vector75>:
.globl vector75
vector75:
  pushl $0
80106bda:	6a 00                	push   $0x0
  pushl $75
80106bdc:	6a 4b                	push   $0x4b
  jmp alltraps
80106bde:	e9 84 f8 ff ff       	jmp    80106467 <alltraps>

80106be3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $76
80106be5:	6a 4c                	push   $0x4c
  jmp alltraps
80106be7:	e9 7b f8 ff ff       	jmp    80106467 <alltraps>

80106bec <vector77>:
.globl vector77
vector77:
  pushl $0
80106bec:	6a 00                	push   $0x0
  pushl $77
80106bee:	6a 4d                	push   $0x4d
  jmp alltraps
80106bf0:	e9 72 f8 ff ff       	jmp    80106467 <alltraps>

80106bf5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106bf5:	6a 00                	push   $0x0
  pushl $78
80106bf7:	6a 4e                	push   $0x4e
  jmp alltraps
80106bf9:	e9 69 f8 ff ff       	jmp    80106467 <alltraps>

80106bfe <vector79>:
.globl vector79
vector79:
  pushl $0
80106bfe:	6a 00                	push   $0x0
  pushl $79
80106c00:	6a 4f                	push   $0x4f
  jmp alltraps
80106c02:	e9 60 f8 ff ff       	jmp    80106467 <alltraps>

80106c07 <vector80>:
.globl vector80
vector80:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $80
80106c09:	6a 50                	push   $0x50
  jmp alltraps
80106c0b:	e9 57 f8 ff ff       	jmp    80106467 <alltraps>

80106c10 <vector81>:
.globl vector81
vector81:
  pushl $0
80106c10:	6a 00                	push   $0x0
  pushl $81
80106c12:	6a 51                	push   $0x51
  jmp alltraps
80106c14:	e9 4e f8 ff ff       	jmp    80106467 <alltraps>

80106c19 <vector82>:
.globl vector82
vector82:
  pushl $0
80106c19:	6a 00                	push   $0x0
  pushl $82
80106c1b:	6a 52                	push   $0x52
  jmp alltraps
80106c1d:	e9 45 f8 ff ff       	jmp    80106467 <alltraps>

80106c22 <vector83>:
.globl vector83
vector83:
  pushl $0
80106c22:	6a 00                	push   $0x0
  pushl $83
80106c24:	6a 53                	push   $0x53
  jmp alltraps
80106c26:	e9 3c f8 ff ff       	jmp    80106467 <alltraps>

80106c2b <vector84>:
.globl vector84
vector84:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $84
80106c2d:	6a 54                	push   $0x54
  jmp alltraps
80106c2f:	e9 33 f8 ff ff       	jmp    80106467 <alltraps>

80106c34 <vector85>:
.globl vector85
vector85:
  pushl $0
80106c34:	6a 00                	push   $0x0
  pushl $85
80106c36:	6a 55                	push   $0x55
  jmp alltraps
80106c38:	e9 2a f8 ff ff       	jmp    80106467 <alltraps>

80106c3d <vector86>:
.globl vector86
vector86:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $86
80106c3f:	6a 56                	push   $0x56
  jmp alltraps
80106c41:	e9 21 f8 ff ff       	jmp    80106467 <alltraps>

80106c46 <vector87>:
.globl vector87
vector87:
  pushl $0
80106c46:	6a 00                	push   $0x0
  pushl $87
80106c48:	6a 57                	push   $0x57
  jmp alltraps
80106c4a:	e9 18 f8 ff ff       	jmp    80106467 <alltraps>

80106c4f <vector88>:
.globl vector88
vector88:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $88
80106c51:	6a 58                	push   $0x58
  jmp alltraps
80106c53:	e9 0f f8 ff ff       	jmp    80106467 <alltraps>

80106c58 <vector89>:
.globl vector89
vector89:
  pushl $0
80106c58:	6a 00                	push   $0x0
  pushl $89
80106c5a:	6a 59                	push   $0x59
  jmp alltraps
80106c5c:	e9 06 f8 ff ff       	jmp    80106467 <alltraps>

80106c61 <vector90>:
.globl vector90
vector90:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $90
80106c63:	6a 5a                	push   $0x5a
  jmp alltraps
80106c65:	e9 fd f7 ff ff       	jmp    80106467 <alltraps>

80106c6a <vector91>:
.globl vector91
vector91:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $91
80106c6c:	6a 5b                	push   $0x5b
  jmp alltraps
80106c6e:	e9 f4 f7 ff ff       	jmp    80106467 <alltraps>

80106c73 <vector92>:
.globl vector92
vector92:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $92
80106c75:	6a 5c                	push   $0x5c
  jmp alltraps
80106c77:	e9 eb f7 ff ff       	jmp    80106467 <alltraps>

80106c7c <vector93>:
.globl vector93
vector93:
  pushl $0
80106c7c:	6a 00                	push   $0x0
  pushl $93
80106c7e:	6a 5d                	push   $0x5d
  jmp alltraps
80106c80:	e9 e2 f7 ff ff       	jmp    80106467 <alltraps>

80106c85 <vector94>:
.globl vector94
vector94:
  pushl $0
80106c85:	6a 00                	push   $0x0
  pushl $94
80106c87:	6a 5e                	push   $0x5e
  jmp alltraps
80106c89:	e9 d9 f7 ff ff       	jmp    80106467 <alltraps>

80106c8e <vector95>:
.globl vector95
vector95:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $95
80106c90:	6a 5f                	push   $0x5f
  jmp alltraps
80106c92:	e9 d0 f7 ff ff       	jmp    80106467 <alltraps>

80106c97 <vector96>:
.globl vector96
vector96:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $96
80106c99:	6a 60                	push   $0x60
  jmp alltraps
80106c9b:	e9 c7 f7 ff ff       	jmp    80106467 <alltraps>

80106ca0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ca0:	6a 00                	push   $0x0
  pushl $97
80106ca2:	6a 61                	push   $0x61
  jmp alltraps
80106ca4:	e9 be f7 ff ff       	jmp    80106467 <alltraps>

80106ca9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $98
80106cab:	6a 62                	push   $0x62
  jmp alltraps
80106cad:	e9 b5 f7 ff ff       	jmp    80106467 <alltraps>

80106cb2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $99
80106cb4:	6a 63                	push   $0x63
  jmp alltraps
80106cb6:	e9 ac f7 ff ff       	jmp    80106467 <alltraps>

80106cbb <vector100>:
.globl vector100
vector100:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $100
80106cbd:	6a 64                	push   $0x64
  jmp alltraps
80106cbf:	e9 a3 f7 ff ff       	jmp    80106467 <alltraps>

80106cc4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106cc4:	6a 00                	push   $0x0
  pushl $101
80106cc6:	6a 65                	push   $0x65
  jmp alltraps
80106cc8:	e9 9a f7 ff ff       	jmp    80106467 <alltraps>

80106ccd <vector102>:
.globl vector102
vector102:
  pushl $0
80106ccd:	6a 00                	push   $0x0
  pushl $102
80106ccf:	6a 66                	push   $0x66
  jmp alltraps
80106cd1:	e9 91 f7 ff ff       	jmp    80106467 <alltraps>

80106cd6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $103
80106cd8:	6a 67                	push   $0x67
  jmp alltraps
80106cda:	e9 88 f7 ff ff       	jmp    80106467 <alltraps>

80106cdf <vector104>:
.globl vector104
vector104:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $104
80106ce1:	6a 68                	push   $0x68
  jmp alltraps
80106ce3:	e9 7f f7 ff ff       	jmp    80106467 <alltraps>

80106ce8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ce8:	6a 00                	push   $0x0
  pushl $105
80106cea:	6a 69                	push   $0x69
  jmp alltraps
80106cec:	e9 76 f7 ff ff       	jmp    80106467 <alltraps>

80106cf1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106cf1:	6a 00                	push   $0x0
  pushl $106
80106cf3:	6a 6a                	push   $0x6a
  jmp alltraps
80106cf5:	e9 6d f7 ff ff       	jmp    80106467 <alltraps>

80106cfa <vector107>:
.globl vector107
vector107:
  pushl $0
80106cfa:	6a 00                	push   $0x0
  pushl $107
80106cfc:	6a 6b                	push   $0x6b
  jmp alltraps
80106cfe:	e9 64 f7 ff ff       	jmp    80106467 <alltraps>

80106d03 <vector108>:
.globl vector108
vector108:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $108
80106d05:	6a 6c                	push   $0x6c
  jmp alltraps
80106d07:	e9 5b f7 ff ff       	jmp    80106467 <alltraps>

80106d0c <vector109>:
.globl vector109
vector109:
  pushl $0
80106d0c:	6a 00                	push   $0x0
  pushl $109
80106d0e:	6a 6d                	push   $0x6d
  jmp alltraps
80106d10:	e9 52 f7 ff ff       	jmp    80106467 <alltraps>

80106d15 <vector110>:
.globl vector110
vector110:
  pushl $0
80106d15:	6a 00                	push   $0x0
  pushl $110
80106d17:	6a 6e                	push   $0x6e
  jmp alltraps
80106d19:	e9 49 f7 ff ff       	jmp    80106467 <alltraps>

80106d1e <vector111>:
.globl vector111
vector111:
  pushl $0
80106d1e:	6a 00                	push   $0x0
  pushl $111
80106d20:	6a 6f                	push   $0x6f
  jmp alltraps
80106d22:	e9 40 f7 ff ff       	jmp    80106467 <alltraps>

80106d27 <vector112>:
.globl vector112
vector112:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $112
80106d29:	6a 70                	push   $0x70
  jmp alltraps
80106d2b:	e9 37 f7 ff ff       	jmp    80106467 <alltraps>

80106d30 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d30:	6a 00                	push   $0x0
  pushl $113
80106d32:	6a 71                	push   $0x71
  jmp alltraps
80106d34:	e9 2e f7 ff ff       	jmp    80106467 <alltraps>

80106d39 <vector114>:
.globl vector114
vector114:
  pushl $0
80106d39:	6a 00                	push   $0x0
  pushl $114
80106d3b:	6a 72                	push   $0x72
  jmp alltraps
80106d3d:	e9 25 f7 ff ff       	jmp    80106467 <alltraps>

80106d42 <vector115>:
.globl vector115
vector115:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $115
80106d44:	6a 73                	push   $0x73
  jmp alltraps
80106d46:	e9 1c f7 ff ff       	jmp    80106467 <alltraps>

80106d4b <vector116>:
.globl vector116
vector116:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $116
80106d4d:	6a 74                	push   $0x74
  jmp alltraps
80106d4f:	e9 13 f7 ff ff       	jmp    80106467 <alltraps>

80106d54 <vector117>:
.globl vector117
vector117:
  pushl $0
80106d54:	6a 00                	push   $0x0
  pushl $117
80106d56:	6a 75                	push   $0x75
  jmp alltraps
80106d58:	e9 0a f7 ff ff       	jmp    80106467 <alltraps>

80106d5d <vector118>:
.globl vector118
vector118:
  pushl $0
80106d5d:	6a 00                	push   $0x0
  pushl $118
80106d5f:	6a 76                	push   $0x76
  jmp alltraps
80106d61:	e9 01 f7 ff ff       	jmp    80106467 <alltraps>

80106d66 <vector119>:
.globl vector119
vector119:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $119
80106d68:	6a 77                	push   $0x77
  jmp alltraps
80106d6a:	e9 f8 f6 ff ff       	jmp    80106467 <alltraps>

80106d6f <vector120>:
.globl vector120
vector120:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $120
80106d71:	6a 78                	push   $0x78
  jmp alltraps
80106d73:	e9 ef f6 ff ff       	jmp    80106467 <alltraps>

80106d78 <vector121>:
.globl vector121
vector121:
  pushl $0
80106d78:	6a 00                	push   $0x0
  pushl $121
80106d7a:	6a 79                	push   $0x79
  jmp alltraps
80106d7c:	e9 e6 f6 ff ff       	jmp    80106467 <alltraps>

80106d81 <vector122>:
.globl vector122
vector122:
  pushl $0
80106d81:	6a 00                	push   $0x0
  pushl $122
80106d83:	6a 7a                	push   $0x7a
  jmp alltraps
80106d85:	e9 dd f6 ff ff       	jmp    80106467 <alltraps>

80106d8a <vector123>:
.globl vector123
vector123:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $123
80106d8c:	6a 7b                	push   $0x7b
  jmp alltraps
80106d8e:	e9 d4 f6 ff ff       	jmp    80106467 <alltraps>

80106d93 <vector124>:
.globl vector124
vector124:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $124
80106d95:	6a 7c                	push   $0x7c
  jmp alltraps
80106d97:	e9 cb f6 ff ff       	jmp    80106467 <alltraps>

80106d9c <vector125>:
.globl vector125
vector125:
  pushl $0
80106d9c:	6a 00                	push   $0x0
  pushl $125
80106d9e:	6a 7d                	push   $0x7d
  jmp alltraps
80106da0:	e9 c2 f6 ff ff       	jmp    80106467 <alltraps>

80106da5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106da5:	6a 00                	push   $0x0
  pushl $126
80106da7:	6a 7e                	push   $0x7e
  jmp alltraps
80106da9:	e9 b9 f6 ff ff       	jmp    80106467 <alltraps>

80106dae <vector127>:
.globl vector127
vector127:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $127
80106db0:	6a 7f                	push   $0x7f
  jmp alltraps
80106db2:	e9 b0 f6 ff ff       	jmp    80106467 <alltraps>

80106db7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $128
80106db9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106dbe:	e9 a4 f6 ff ff       	jmp    80106467 <alltraps>

80106dc3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $129
80106dc5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106dca:	e9 98 f6 ff ff       	jmp    80106467 <alltraps>

80106dcf <vector130>:
.globl vector130
vector130:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $130
80106dd1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106dd6:	e9 8c f6 ff ff       	jmp    80106467 <alltraps>

80106ddb <vector131>:
.globl vector131
vector131:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $131
80106ddd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106de2:	e9 80 f6 ff ff       	jmp    80106467 <alltraps>

80106de7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $132
80106de9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106dee:	e9 74 f6 ff ff       	jmp    80106467 <alltraps>

80106df3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $133
80106df5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106dfa:	e9 68 f6 ff ff       	jmp    80106467 <alltraps>

80106dff <vector134>:
.globl vector134
vector134:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $134
80106e01:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e06:	e9 5c f6 ff ff       	jmp    80106467 <alltraps>

80106e0b <vector135>:
.globl vector135
vector135:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $135
80106e0d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e12:	e9 50 f6 ff ff       	jmp    80106467 <alltraps>

80106e17 <vector136>:
.globl vector136
vector136:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $136
80106e19:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e1e:	e9 44 f6 ff ff       	jmp    80106467 <alltraps>

80106e23 <vector137>:
.globl vector137
vector137:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $137
80106e25:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e2a:	e9 38 f6 ff ff       	jmp    80106467 <alltraps>

80106e2f <vector138>:
.globl vector138
vector138:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $138
80106e31:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e36:	e9 2c f6 ff ff       	jmp    80106467 <alltraps>

80106e3b <vector139>:
.globl vector139
vector139:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $139
80106e3d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e42:	e9 20 f6 ff ff       	jmp    80106467 <alltraps>

80106e47 <vector140>:
.globl vector140
vector140:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $140
80106e49:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e4e:	e9 14 f6 ff ff       	jmp    80106467 <alltraps>

80106e53 <vector141>:
.globl vector141
vector141:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $141
80106e55:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e5a:	e9 08 f6 ff ff       	jmp    80106467 <alltraps>

80106e5f <vector142>:
.globl vector142
vector142:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $142
80106e61:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e66:	e9 fc f5 ff ff       	jmp    80106467 <alltraps>

80106e6b <vector143>:
.globl vector143
vector143:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $143
80106e6d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106e72:	e9 f0 f5 ff ff       	jmp    80106467 <alltraps>

80106e77 <vector144>:
.globl vector144
vector144:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $144
80106e79:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106e7e:	e9 e4 f5 ff ff       	jmp    80106467 <alltraps>

80106e83 <vector145>:
.globl vector145
vector145:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $145
80106e85:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106e8a:	e9 d8 f5 ff ff       	jmp    80106467 <alltraps>

80106e8f <vector146>:
.globl vector146
vector146:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $146
80106e91:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106e96:	e9 cc f5 ff ff       	jmp    80106467 <alltraps>

80106e9b <vector147>:
.globl vector147
vector147:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $147
80106e9d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ea2:	e9 c0 f5 ff ff       	jmp    80106467 <alltraps>

80106ea7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $148
80106ea9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106eae:	e9 b4 f5 ff ff       	jmp    80106467 <alltraps>

80106eb3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $149
80106eb5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106eba:	e9 a8 f5 ff ff       	jmp    80106467 <alltraps>

80106ebf <vector150>:
.globl vector150
vector150:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $150
80106ec1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ec6:	e9 9c f5 ff ff       	jmp    80106467 <alltraps>

80106ecb <vector151>:
.globl vector151
vector151:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $151
80106ecd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ed2:	e9 90 f5 ff ff       	jmp    80106467 <alltraps>

80106ed7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $152
80106ed9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ede:	e9 84 f5 ff ff       	jmp    80106467 <alltraps>

80106ee3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $153
80106ee5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106eea:	e9 78 f5 ff ff       	jmp    80106467 <alltraps>

80106eef <vector154>:
.globl vector154
vector154:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $154
80106ef1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ef6:	e9 6c f5 ff ff       	jmp    80106467 <alltraps>

80106efb <vector155>:
.globl vector155
vector155:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $155
80106efd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f02:	e9 60 f5 ff ff       	jmp    80106467 <alltraps>

80106f07 <vector156>:
.globl vector156
vector156:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $156
80106f09:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f0e:	e9 54 f5 ff ff       	jmp    80106467 <alltraps>

80106f13 <vector157>:
.globl vector157
vector157:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $157
80106f15:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f1a:	e9 48 f5 ff ff       	jmp    80106467 <alltraps>

80106f1f <vector158>:
.globl vector158
vector158:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $158
80106f21:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f26:	e9 3c f5 ff ff       	jmp    80106467 <alltraps>

80106f2b <vector159>:
.globl vector159
vector159:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $159
80106f2d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f32:	e9 30 f5 ff ff       	jmp    80106467 <alltraps>

80106f37 <vector160>:
.globl vector160
vector160:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $160
80106f39:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f3e:	e9 24 f5 ff ff       	jmp    80106467 <alltraps>

80106f43 <vector161>:
.globl vector161
vector161:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $161
80106f45:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f4a:	e9 18 f5 ff ff       	jmp    80106467 <alltraps>

80106f4f <vector162>:
.globl vector162
vector162:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $162
80106f51:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f56:	e9 0c f5 ff ff       	jmp    80106467 <alltraps>

80106f5b <vector163>:
.globl vector163
vector163:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $163
80106f5d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f62:	e9 00 f5 ff ff       	jmp    80106467 <alltraps>

80106f67 <vector164>:
.globl vector164
vector164:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $164
80106f69:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106f6e:	e9 f4 f4 ff ff       	jmp    80106467 <alltraps>

80106f73 <vector165>:
.globl vector165
vector165:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $165
80106f75:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106f7a:	e9 e8 f4 ff ff       	jmp    80106467 <alltraps>

80106f7f <vector166>:
.globl vector166
vector166:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $166
80106f81:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106f86:	e9 dc f4 ff ff       	jmp    80106467 <alltraps>

80106f8b <vector167>:
.globl vector167
vector167:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $167
80106f8d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106f92:	e9 d0 f4 ff ff       	jmp    80106467 <alltraps>

80106f97 <vector168>:
.globl vector168
vector168:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $168
80106f99:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106f9e:	e9 c4 f4 ff ff       	jmp    80106467 <alltraps>

80106fa3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $169
80106fa5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106faa:	e9 b8 f4 ff ff       	jmp    80106467 <alltraps>

80106faf <vector170>:
.globl vector170
vector170:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $170
80106fb1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106fb6:	e9 ac f4 ff ff       	jmp    80106467 <alltraps>

80106fbb <vector171>:
.globl vector171
vector171:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $171
80106fbd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106fc2:	e9 a0 f4 ff ff       	jmp    80106467 <alltraps>

80106fc7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $172
80106fc9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106fce:	e9 94 f4 ff ff       	jmp    80106467 <alltraps>

80106fd3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $173
80106fd5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106fda:	e9 88 f4 ff ff       	jmp    80106467 <alltraps>

80106fdf <vector174>:
.globl vector174
vector174:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $174
80106fe1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106fe6:	e9 7c f4 ff ff       	jmp    80106467 <alltraps>

80106feb <vector175>:
.globl vector175
vector175:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $175
80106fed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ff2:	e9 70 f4 ff ff       	jmp    80106467 <alltraps>

80106ff7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $176
80106ff9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ffe:	e9 64 f4 ff ff       	jmp    80106467 <alltraps>

80107003 <vector177>:
.globl vector177
vector177:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $177
80107005:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010700a:	e9 58 f4 ff ff       	jmp    80106467 <alltraps>

8010700f <vector178>:
.globl vector178
vector178:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $178
80107011:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107016:	e9 4c f4 ff ff       	jmp    80106467 <alltraps>

8010701b <vector179>:
.globl vector179
vector179:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $179
8010701d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107022:	e9 40 f4 ff ff       	jmp    80106467 <alltraps>

80107027 <vector180>:
.globl vector180
vector180:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $180
80107029:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010702e:	e9 34 f4 ff ff       	jmp    80106467 <alltraps>

80107033 <vector181>:
.globl vector181
vector181:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $181
80107035:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010703a:	e9 28 f4 ff ff       	jmp    80106467 <alltraps>

8010703f <vector182>:
.globl vector182
vector182:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $182
80107041:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107046:	e9 1c f4 ff ff       	jmp    80106467 <alltraps>

8010704b <vector183>:
.globl vector183
vector183:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $183
8010704d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107052:	e9 10 f4 ff ff       	jmp    80106467 <alltraps>

80107057 <vector184>:
.globl vector184
vector184:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $184
80107059:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010705e:	e9 04 f4 ff ff       	jmp    80106467 <alltraps>

80107063 <vector185>:
.globl vector185
vector185:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $185
80107065:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010706a:	e9 f8 f3 ff ff       	jmp    80106467 <alltraps>

8010706f <vector186>:
.globl vector186
vector186:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $186
80107071:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107076:	e9 ec f3 ff ff       	jmp    80106467 <alltraps>

8010707b <vector187>:
.globl vector187
vector187:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $187
8010707d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107082:	e9 e0 f3 ff ff       	jmp    80106467 <alltraps>

80107087 <vector188>:
.globl vector188
vector188:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $188
80107089:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010708e:	e9 d4 f3 ff ff       	jmp    80106467 <alltraps>

80107093 <vector189>:
.globl vector189
vector189:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $189
80107095:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010709a:	e9 c8 f3 ff ff       	jmp    80106467 <alltraps>

8010709f <vector190>:
.globl vector190
vector190:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $190
801070a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801070a6:	e9 bc f3 ff ff       	jmp    80106467 <alltraps>

801070ab <vector191>:
.globl vector191
vector191:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $191
801070ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801070b2:	e9 b0 f3 ff ff       	jmp    80106467 <alltraps>

801070b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $192
801070b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801070be:	e9 a4 f3 ff ff       	jmp    80106467 <alltraps>

801070c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $193
801070c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801070ca:	e9 98 f3 ff ff       	jmp    80106467 <alltraps>

801070cf <vector194>:
.globl vector194
vector194:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $194
801070d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801070d6:	e9 8c f3 ff ff       	jmp    80106467 <alltraps>

801070db <vector195>:
.globl vector195
vector195:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $195
801070dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801070e2:	e9 80 f3 ff ff       	jmp    80106467 <alltraps>

801070e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $196
801070e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801070ee:	e9 74 f3 ff ff       	jmp    80106467 <alltraps>

801070f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $197
801070f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801070fa:	e9 68 f3 ff ff       	jmp    80106467 <alltraps>

801070ff <vector198>:
.globl vector198
vector198:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $198
80107101:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107106:	e9 5c f3 ff ff       	jmp    80106467 <alltraps>

8010710b <vector199>:
.globl vector199
vector199:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $199
8010710d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107112:	e9 50 f3 ff ff       	jmp    80106467 <alltraps>

80107117 <vector200>:
.globl vector200
vector200:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $200
80107119:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010711e:	e9 44 f3 ff ff       	jmp    80106467 <alltraps>

80107123 <vector201>:
.globl vector201
vector201:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $201
80107125:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010712a:	e9 38 f3 ff ff       	jmp    80106467 <alltraps>

8010712f <vector202>:
.globl vector202
vector202:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $202
80107131:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107136:	e9 2c f3 ff ff       	jmp    80106467 <alltraps>

8010713b <vector203>:
.globl vector203
vector203:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $203
8010713d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107142:	e9 20 f3 ff ff       	jmp    80106467 <alltraps>

80107147 <vector204>:
.globl vector204
vector204:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $204
80107149:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010714e:	e9 14 f3 ff ff       	jmp    80106467 <alltraps>

80107153 <vector205>:
.globl vector205
vector205:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $205
80107155:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010715a:	e9 08 f3 ff ff       	jmp    80106467 <alltraps>

8010715f <vector206>:
.globl vector206
vector206:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $206
80107161:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107166:	e9 fc f2 ff ff       	jmp    80106467 <alltraps>

8010716b <vector207>:
.globl vector207
vector207:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $207
8010716d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107172:	e9 f0 f2 ff ff       	jmp    80106467 <alltraps>

80107177 <vector208>:
.globl vector208
vector208:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $208
80107179:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010717e:	e9 e4 f2 ff ff       	jmp    80106467 <alltraps>

80107183 <vector209>:
.globl vector209
vector209:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $209
80107185:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010718a:	e9 d8 f2 ff ff       	jmp    80106467 <alltraps>

8010718f <vector210>:
.globl vector210
vector210:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $210
80107191:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107196:	e9 cc f2 ff ff       	jmp    80106467 <alltraps>

8010719b <vector211>:
.globl vector211
vector211:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $211
8010719d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801071a2:	e9 c0 f2 ff ff       	jmp    80106467 <alltraps>

801071a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $212
801071a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801071ae:	e9 b4 f2 ff ff       	jmp    80106467 <alltraps>

801071b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $213
801071b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801071ba:	e9 a8 f2 ff ff       	jmp    80106467 <alltraps>

801071bf <vector214>:
.globl vector214
vector214:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $214
801071c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801071c6:	e9 9c f2 ff ff       	jmp    80106467 <alltraps>

801071cb <vector215>:
.globl vector215
vector215:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $215
801071cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801071d2:	e9 90 f2 ff ff       	jmp    80106467 <alltraps>

801071d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $216
801071d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801071de:	e9 84 f2 ff ff       	jmp    80106467 <alltraps>

801071e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $217
801071e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801071ea:	e9 78 f2 ff ff       	jmp    80106467 <alltraps>

801071ef <vector218>:
.globl vector218
vector218:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $218
801071f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801071f6:	e9 6c f2 ff ff       	jmp    80106467 <alltraps>

801071fb <vector219>:
.globl vector219
vector219:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $219
801071fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107202:	e9 60 f2 ff ff       	jmp    80106467 <alltraps>

80107207 <vector220>:
.globl vector220
vector220:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $220
80107209:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010720e:	e9 54 f2 ff ff       	jmp    80106467 <alltraps>

80107213 <vector221>:
.globl vector221
vector221:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $221
80107215:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010721a:	e9 48 f2 ff ff       	jmp    80106467 <alltraps>

8010721f <vector222>:
.globl vector222
vector222:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $222
80107221:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107226:	e9 3c f2 ff ff       	jmp    80106467 <alltraps>

8010722b <vector223>:
.globl vector223
vector223:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $223
8010722d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107232:	e9 30 f2 ff ff       	jmp    80106467 <alltraps>

80107237 <vector224>:
.globl vector224
vector224:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $224
80107239:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010723e:	e9 24 f2 ff ff       	jmp    80106467 <alltraps>

80107243 <vector225>:
.globl vector225
vector225:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $225
80107245:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010724a:	e9 18 f2 ff ff       	jmp    80106467 <alltraps>

8010724f <vector226>:
.globl vector226
vector226:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $226
80107251:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107256:	e9 0c f2 ff ff       	jmp    80106467 <alltraps>

8010725b <vector227>:
.globl vector227
vector227:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $227
8010725d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107262:	e9 00 f2 ff ff       	jmp    80106467 <alltraps>

80107267 <vector228>:
.globl vector228
vector228:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $228
80107269:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010726e:	e9 f4 f1 ff ff       	jmp    80106467 <alltraps>

80107273 <vector229>:
.globl vector229
vector229:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $229
80107275:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010727a:	e9 e8 f1 ff ff       	jmp    80106467 <alltraps>

8010727f <vector230>:
.globl vector230
vector230:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $230
80107281:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107286:	e9 dc f1 ff ff       	jmp    80106467 <alltraps>

8010728b <vector231>:
.globl vector231
vector231:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $231
8010728d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107292:	e9 d0 f1 ff ff       	jmp    80106467 <alltraps>

80107297 <vector232>:
.globl vector232
vector232:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $232
80107299:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010729e:	e9 c4 f1 ff ff       	jmp    80106467 <alltraps>

801072a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $233
801072a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801072aa:	e9 b8 f1 ff ff       	jmp    80106467 <alltraps>

801072af <vector234>:
.globl vector234
vector234:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $234
801072b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801072b6:	e9 ac f1 ff ff       	jmp    80106467 <alltraps>

801072bb <vector235>:
.globl vector235
vector235:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $235
801072bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801072c2:	e9 a0 f1 ff ff       	jmp    80106467 <alltraps>

801072c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $236
801072c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801072ce:	e9 94 f1 ff ff       	jmp    80106467 <alltraps>

801072d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $237
801072d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801072da:	e9 88 f1 ff ff       	jmp    80106467 <alltraps>

801072df <vector238>:
.globl vector238
vector238:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $238
801072e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801072e6:	e9 7c f1 ff ff       	jmp    80106467 <alltraps>

801072eb <vector239>:
.globl vector239
vector239:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $239
801072ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801072f2:	e9 70 f1 ff ff       	jmp    80106467 <alltraps>

801072f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $240
801072f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801072fe:	e9 64 f1 ff ff       	jmp    80106467 <alltraps>

80107303 <vector241>:
.globl vector241
vector241:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $241
80107305:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010730a:	e9 58 f1 ff ff       	jmp    80106467 <alltraps>

8010730f <vector242>:
.globl vector242
vector242:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $242
80107311:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107316:	e9 4c f1 ff ff       	jmp    80106467 <alltraps>

8010731b <vector243>:
.globl vector243
vector243:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $243
8010731d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107322:	e9 40 f1 ff ff       	jmp    80106467 <alltraps>

80107327 <vector244>:
.globl vector244
vector244:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $244
80107329:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010732e:	e9 34 f1 ff ff       	jmp    80106467 <alltraps>

80107333 <vector245>:
.globl vector245
vector245:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $245
80107335:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010733a:	e9 28 f1 ff ff       	jmp    80106467 <alltraps>

8010733f <vector246>:
.globl vector246
vector246:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $246
80107341:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107346:	e9 1c f1 ff ff       	jmp    80106467 <alltraps>

8010734b <vector247>:
.globl vector247
vector247:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $247
8010734d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107352:	e9 10 f1 ff ff       	jmp    80106467 <alltraps>

80107357 <vector248>:
.globl vector248
vector248:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $248
80107359:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010735e:	e9 04 f1 ff ff       	jmp    80106467 <alltraps>

80107363 <vector249>:
.globl vector249
vector249:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $249
80107365:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010736a:	e9 f8 f0 ff ff       	jmp    80106467 <alltraps>

8010736f <vector250>:
.globl vector250
vector250:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $250
80107371:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107376:	e9 ec f0 ff ff       	jmp    80106467 <alltraps>

8010737b <vector251>:
.globl vector251
vector251:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $251
8010737d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107382:	e9 e0 f0 ff ff       	jmp    80106467 <alltraps>

80107387 <vector252>:
.globl vector252
vector252:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $252
80107389:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010738e:	e9 d4 f0 ff ff       	jmp    80106467 <alltraps>

80107393 <vector253>:
.globl vector253
vector253:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $253
80107395:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010739a:	e9 c8 f0 ff ff       	jmp    80106467 <alltraps>

8010739f <vector254>:
.globl vector254
vector254:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $254
801073a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801073a6:	e9 bc f0 ff ff       	jmp    80106467 <alltraps>

801073ab <vector255>:
.globl vector255
vector255:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $255
801073ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801073b2:	e9 b0 f0 ff ff       	jmp    80106467 <alltraps>
801073b7:	66 90                	xchg   %ax,%ax
801073b9:	66 90                	xchg   %ax,%ax
801073bb:	66 90                	xchg   %ax,%ax
801073bd:	66 90                	xchg   %ax,%ax
801073bf:	90                   	nop

801073c0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801073c6:	89 d3                	mov    %edx,%ebx
{
801073c8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801073ca:	c1 eb 16             	shr    $0x16,%ebx
801073cd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801073d0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801073d3:	8b 06                	mov    (%esi),%eax
801073d5:	a8 01                	test   $0x1,%al
801073d7:	74 27                	je     80107400 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073de:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801073e4:	c1 ef 0a             	shr    $0xa,%edi
}
801073e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801073ea:	89 fa                	mov    %edi,%edx
801073ec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801073f2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801073f5:	5b                   	pop    %ebx
801073f6:	5e                   	pop    %esi
801073f7:	5f                   	pop    %edi
801073f8:	5d                   	pop    %ebp
801073f9:	c3                   	ret    
801073fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107400:	85 c9                	test   %ecx,%ecx
80107402:	74 2c                	je     80107430 <walkpgdir+0x70>
80107404:	e8 e7 b0 ff ff       	call   801024f0 <kalloc>
80107409:	85 c0                	test   %eax,%eax
8010740b:	89 c3                	mov    %eax,%ebx
8010740d:	74 21                	je     80107430 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010740f:	83 ec 04             	sub    $0x4,%esp
80107412:	68 00 10 00 00       	push   $0x1000
80107417:	6a 00                	push   $0x0
80107419:	50                   	push   %eax
8010741a:	e8 b1 dd ff ff       	call   801051d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010741f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107425:	83 c4 10             	add    $0x10,%esp
80107428:	83 c8 07             	or     $0x7,%eax
8010742b:	89 06                	mov    %eax,(%esi)
8010742d:	eb b5                	jmp    801073e4 <walkpgdir+0x24>
8010742f:	90                   	nop
}
80107430:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107433:	31 c0                	xor    %eax,%eax
}
80107435:	5b                   	pop    %ebx
80107436:	5e                   	pop    %esi
80107437:	5f                   	pop    %edi
80107438:	5d                   	pop    %ebp
80107439:	c3                   	ret    
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107440 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107446:	89 d3                	mov    %edx,%ebx
80107448:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010744e:	83 ec 1c             	sub    $0x1c,%esp
80107451:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107454:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107458:	8b 7d 08             	mov    0x8(%ebp),%edi
8010745b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107460:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107463:	8b 45 0c             	mov    0xc(%ebp),%eax
80107466:	29 df                	sub    %ebx,%edi
80107468:	83 c8 01             	or     $0x1,%eax
8010746b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010746e:	eb 15                	jmp    80107485 <mappages+0x45>
    if(*pte & PTE_P)
80107470:	f6 00 01             	testb  $0x1,(%eax)
80107473:	75 45                	jne    801074ba <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107475:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107478:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010747b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010747d:	74 31                	je     801074b0 <mappages+0x70>
      break;
    a += PGSIZE;
8010747f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107488:	b9 01 00 00 00       	mov    $0x1,%ecx
8010748d:	89 da                	mov    %ebx,%edx
8010748f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107492:	e8 29 ff ff ff       	call   801073c0 <walkpgdir>
80107497:	85 c0                	test   %eax,%eax
80107499:	75 d5                	jne    80107470 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010749b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010749e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074a3:	5b                   	pop    %ebx
801074a4:	5e                   	pop    %esi
801074a5:	5f                   	pop    %edi
801074a6:	5d                   	pop    %ebp
801074a7:	c3                   	ret    
801074a8:	90                   	nop
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074b3:	31 c0                	xor    %eax,%eax
}
801074b5:	5b                   	pop    %ebx
801074b6:	5e                   	pop    %esi
801074b7:	5f                   	pop    %edi
801074b8:	5d                   	pop    %ebp
801074b9:	c3                   	ret    
      panic("remap");
801074ba:	83 ec 0c             	sub    $0xc,%esp
801074bd:	68 f8 86 10 80       	push   $0x801086f8
801074c2:	e8 c9 8e ff ff       	call   80100390 <panic>
801074c7:	89 f6                	mov    %esi,%esi
801074c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801074d6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801074dc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801074de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801074e4:	83 ec 1c             	sub    $0x1c,%esp
801074e7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801074ea:	39 d3                	cmp    %edx,%ebx
801074ec:	73 66                	jae    80107554 <deallocuvm.part.0+0x84>
801074ee:	89 d6                	mov    %edx,%esi
801074f0:	eb 3d                	jmp    8010752f <deallocuvm.part.0+0x5f>
801074f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801074f8:	8b 10                	mov    (%eax),%edx
801074fa:	f6 c2 01             	test   $0x1,%dl
801074fd:	74 26                	je     80107525 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801074ff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107505:	74 58                	je     8010755f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107507:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010750a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107510:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107513:	52                   	push   %edx
80107514:	e8 27 ae ff ff       	call   80102340 <kfree>
      *pte = 0;
80107519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010751c:	83 c4 10             	add    $0x10,%esp
8010751f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107525:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010752b:	39 f3                	cmp    %esi,%ebx
8010752d:	73 25                	jae    80107554 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010752f:	31 c9                	xor    %ecx,%ecx
80107531:	89 da                	mov    %ebx,%edx
80107533:	89 f8                	mov    %edi,%eax
80107535:	e8 86 fe ff ff       	call   801073c0 <walkpgdir>
    if(!pte)
8010753a:	85 c0                	test   %eax,%eax
8010753c:	75 ba                	jne    801074f8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010753e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107544:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010754a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107550:	39 f3                	cmp    %esi,%ebx
80107552:	72 db                	jb     8010752f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107554:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107557:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010755a:	5b                   	pop    %ebx
8010755b:	5e                   	pop    %esi
8010755c:	5f                   	pop    %edi
8010755d:	5d                   	pop    %ebp
8010755e:	c3                   	ret    
        panic("kfree");
8010755f:	83 ec 0c             	sub    $0xc,%esp
80107562:	68 66 7f 10 80       	push   $0x80107f66
80107567:	e8 24 8e ff ff       	call   80100390 <panic>
8010756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107570 <seginit>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107576:	e8 75 c3 ff ff       	call   801038f0 <cpuid>
8010757b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
80107581:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107586:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010758a:	c7 80 98 39 11 80 ff 	movl   $0xffff,-0x7feec668(%eax)
80107591:	ff 00 00 
80107594:	c7 80 9c 39 11 80 00 	movl   $0xcf9a00,-0x7feec664(%eax)
8010759b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010759e:	c7 80 a0 39 11 80 ff 	movl   $0xffff,-0x7feec660(%eax)
801075a5:	ff 00 00 
801075a8:	c7 80 a4 39 11 80 00 	movl   $0xcf9200,-0x7feec65c(%eax)
801075af:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801075b2:	c7 80 a8 39 11 80 ff 	movl   $0xffff,-0x7feec658(%eax)
801075b9:	ff 00 00 
801075bc:	c7 80 ac 39 11 80 00 	movl   $0xcffa00,-0x7feec654(%eax)
801075c3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801075c6:	c7 80 b0 39 11 80 ff 	movl   $0xffff,-0x7feec650(%eax)
801075cd:	ff 00 00 
801075d0:	c7 80 b4 39 11 80 00 	movl   $0xcff200,-0x7feec64c(%eax)
801075d7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801075da:	05 90 39 11 80       	add    $0x80113990,%eax
  pd[1] = (uint)p;
801075df:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801075e3:	c1 e8 10             	shr    $0x10,%eax
801075e6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801075ea:	8d 45 f2             	lea    -0xe(%ebp),%eax
801075ed:	0f 01 10             	lgdtl  (%eax)
}
801075f0:	c9                   	leave  
801075f1:	c3                   	ret    
801075f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107600 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107600:	a1 a4 35 12 80       	mov    0x801235a4,%eax
{
80107605:	55                   	push   %ebp
80107606:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107608:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010760d:	0f 22 d8             	mov    %eax,%cr3
}
80107610:	5d                   	pop    %ebp
80107611:	c3                   	ret    
80107612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107620 <switchuvm>:
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 1c             	sub    $0x1c,%esp
80107629:	8b 55 08             	mov    0x8(%ebp),%edx
8010762c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if(p == 0)
8010762f:	85 d2                	test   %edx,%edx
80107631:	0f 84 d5 00 00 00    	je     8010770c <switchuvm+0xec>
  if(t->tkstack == 0)
80107637:	8b 41 04             	mov    0x4(%ecx),%eax
8010763a:	85 c0                	test   %eax,%eax
8010763c:	0f 84 e4 00 00 00    	je     80107726 <switchuvm+0x106>
  if(p->pgdir == 0)
80107642:	8b 7a 04             	mov    0x4(%edx),%edi
80107645:	85 ff                	test   %edi,%edi
80107647:	0f 84 cc 00 00 00    	je     80107719 <switchuvm+0xf9>
8010764d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107650:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  pushcli();
80107653:	e8 88 d9 ff ff       	call   80104fe0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107658:	e8 13 c2 ff ff       	call   80103870 <mycpu>
8010765d:	89 c3                	mov    %eax,%ebx
8010765f:	e8 0c c2 ff ff       	call   80103870 <mycpu>
80107664:	89 c7                	mov    %eax,%edi
80107666:	e8 05 c2 ff ff       	call   80103870 <mycpu>
8010766b:	89 c6                	mov    %eax,%esi
8010766d:	83 c7 08             	add    $0x8,%edi
80107670:	83 c6 08             	add    $0x8,%esi
80107673:	c1 ee 10             	shr    $0x10,%esi
80107676:	e8 f5 c1 ff ff       	call   80103870 <mycpu>
8010767b:	89 f1                	mov    %esi,%ecx
8010767d:	83 c0 08             	add    $0x8,%eax
80107680:	ba 67 00 00 00       	mov    $0x67,%edx
80107685:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010768b:	c1 e8 18             	shr    $0x18,%eax
8010768e:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107693:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010769a:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801076a6:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801076ad:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801076b3:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801076b8:	e8 b3 c1 ff ff       	call   80103870 <mycpu>
801076bd:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801076c4:	e8 a7 c1 ff ff       	call   80103870 <mycpu>
  mycpu()->ts.esp0 = (uint)t->tkstack + KSTACKSIZE;
801076c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801076cc:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)t->tkstack + KSTACKSIZE;
801076d0:	8b 59 04             	mov    0x4(%ecx),%ebx
801076d3:	e8 98 c1 ff ff       	call   80103870 <mycpu>
801076d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076de:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076e1:	e8 8a c1 ff ff       	call   80103870 <mycpu>
801076e6:	66 89 70 6e          	mov    %si,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801076ea:	b8 28 00 00 00       	mov    $0x28,%eax
801076ef:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801076f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076f5:	8b 42 04             	mov    0x4(%edx),%eax
801076f8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076fd:	0f 22 d8             	mov    %eax,%cr3
}
80107700:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107703:	5b                   	pop    %ebx
80107704:	5e                   	pop    %esi
80107705:	5f                   	pop    %edi
80107706:	5d                   	pop    %ebp
  popcli();
80107707:	e9 14 d9 ff ff       	jmp    80105020 <popcli>
    panic("switchuvm: no process");
8010770c:	83 ec 0c             	sub    $0xc,%esp
8010770f:	68 fe 86 10 80       	push   $0x801086fe
80107714:	e8 77 8c ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107719:	83 ec 0c             	sub    $0xc,%esp
8010771c:	68 29 87 10 80       	push   $0x80108729
80107721:	e8 6a 8c ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107726:	83 ec 0c             	sub    $0xc,%esp
80107729:	68 14 87 10 80       	push   $0x80108714
8010772e:	e8 5d 8c ff ff       	call   80100390 <panic>
80107733:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107740 <inituvm>:
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	57                   	push   %edi
80107744:	56                   	push   %esi
80107745:	53                   	push   %ebx
80107746:	83 ec 1c             	sub    $0x1c,%esp
80107749:	8b 75 10             	mov    0x10(%ebp),%esi
8010774c:	8b 45 08             	mov    0x8(%ebp),%eax
8010774f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107752:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010775b:	77 49                	ja     801077a6 <inituvm+0x66>
  mem = kalloc();
8010775d:	e8 8e ad ff ff       	call   801024f0 <kalloc>
  memset(mem, 0, PGSIZE);
80107762:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107765:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107767:	68 00 10 00 00       	push   $0x1000
8010776c:	6a 00                	push   $0x0
8010776e:	50                   	push   %eax
8010776f:	e8 5c da ff ff       	call   801051d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107774:	58                   	pop    %eax
80107775:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010777b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107780:	5a                   	pop    %edx
80107781:	6a 06                	push   $0x6
80107783:	50                   	push   %eax
80107784:	31 d2                	xor    %edx,%edx
80107786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107789:	e8 b2 fc ff ff       	call   80107440 <mappages>
  memmove(mem, init, sz);
8010778e:	89 75 10             	mov    %esi,0x10(%ebp)
80107791:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107794:	83 c4 10             	add    $0x10,%esp
80107797:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010779a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010779d:	5b                   	pop    %ebx
8010779e:	5e                   	pop    %esi
8010779f:	5f                   	pop    %edi
801077a0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801077a1:	e9 da da ff ff       	jmp    80105280 <memmove>
    panic("inituvm: more than a page");
801077a6:	83 ec 0c             	sub    $0xc,%esp
801077a9:	68 3d 87 10 80       	push   $0x8010873d
801077ae:	e8 dd 8b ff ff       	call   80100390 <panic>
801077b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077c0 <loaduvm>:
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
801077c6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801077c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801077d0:	0f 85 91 00 00 00    	jne    80107867 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801077d6:	8b 75 18             	mov    0x18(%ebp),%esi
801077d9:	31 db                	xor    %ebx,%ebx
801077db:	85 f6                	test   %esi,%esi
801077dd:	75 1a                	jne    801077f9 <loaduvm+0x39>
801077df:	eb 6f                	jmp    80107850 <loaduvm+0x90>
801077e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801077f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801077f7:	76 57                	jbe    80107850 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801077f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801077fc:	8b 45 08             	mov    0x8(%ebp),%eax
801077ff:	31 c9                	xor    %ecx,%ecx
80107801:	01 da                	add    %ebx,%edx
80107803:	e8 b8 fb ff ff       	call   801073c0 <walkpgdir>
80107808:	85 c0                	test   %eax,%eax
8010780a:	74 4e                	je     8010785a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010780c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010780e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107811:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107816:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010781b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107821:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107824:	01 d9                	add    %ebx,%ecx
80107826:	05 00 00 00 80       	add    $0x80000000,%eax
8010782b:	57                   	push   %edi
8010782c:	51                   	push   %ecx
8010782d:	50                   	push   %eax
8010782e:	ff 75 10             	pushl  0x10(%ebp)
80107831:	e8 5a a1 ff ff       	call   80101990 <readi>
80107836:	83 c4 10             	add    $0x10,%esp
80107839:	39 f8                	cmp    %edi,%eax
8010783b:	74 ab                	je     801077e8 <loaduvm+0x28>
}
8010783d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107845:	5b                   	pop    %ebx
80107846:	5e                   	pop    %esi
80107847:	5f                   	pop    %edi
80107848:	5d                   	pop    %ebp
80107849:	c3                   	ret    
8010784a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107853:	31 c0                	xor    %eax,%eax
}
80107855:	5b                   	pop    %ebx
80107856:	5e                   	pop    %esi
80107857:	5f                   	pop    %edi
80107858:	5d                   	pop    %ebp
80107859:	c3                   	ret    
      panic("loaduvm: address should exist");
8010785a:	83 ec 0c             	sub    $0xc,%esp
8010785d:	68 57 87 10 80       	push   $0x80108757
80107862:	e8 29 8b ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107867:	83 ec 0c             	sub    $0xc,%esp
8010786a:	68 f8 87 10 80       	push   $0x801087f8
8010786f:	e8 1c 8b ff ff       	call   80100390 <panic>
80107874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010787a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107880 <allocuvm>:
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107889:	8b 7d 10             	mov    0x10(%ebp),%edi
8010788c:	85 ff                	test   %edi,%edi
8010788e:	0f 88 8e 00 00 00    	js     80107922 <allocuvm+0xa2>
  if(newsz < oldsz)
80107894:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107897:	0f 82 93 00 00 00    	jb     80107930 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010789d:	8b 45 0c             	mov    0xc(%ebp),%eax
801078a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801078a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801078ac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801078af:	0f 86 7e 00 00 00    	jbe    80107933 <allocuvm+0xb3>
801078b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801078b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801078bb:	eb 42                	jmp    801078ff <allocuvm+0x7f>
801078bd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801078c0:	83 ec 04             	sub    $0x4,%esp
801078c3:	68 00 10 00 00       	push   $0x1000
801078c8:	6a 00                	push   $0x0
801078ca:	50                   	push   %eax
801078cb:	e8 00 d9 ff ff       	call   801051d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801078d0:	58                   	pop    %eax
801078d1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801078d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078dc:	5a                   	pop    %edx
801078dd:	6a 06                	push   $0x6
801078df:	50                   	push   %eax
801078e0:	89 da                	mov    %ebx,%edx
801078e2:	89 f8                	mov    %edi,%eax
801078e4:	e8 57 fb ff ff       	call   80107440 <mappages>
801078e9:	83 c4 10             	add    $0x10,%esp
801078ec:	85 c0                	test   %eax,%eax
801078ee:	78 50                	js     80107940 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801078f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078f6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801078f9:	0f 86 81 00 00 00    	jbe    80107980 <allocuvm+0x100>
    mem = kalloc();
801078ff:	e8 ec ab ff ff       	call   801024f0 <kalloc>
    if(mem == 0){
80107904:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107906:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107908:	75 b6                	jne    801078c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010790a:	83 ec 0c             	sub    $0xc,%esp
8010790d:	68 75 87 10 80       	push   $0x80108775
80107912:	e8 49 8d ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107917:	83 c4 10             	add    $0x10,%esp
8010791a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010791d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107920:	77 6e                	ja     80107990 <allocuvm+0x110>
}
80107922:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107925:	31 ff                	xor    %edi,%edi
}
80107927:	89 f8                	mov    %edi,%eax
80107929:	5b                   	pop    %ebx
8010792a:	5e                   	pop    %esi
8010792b:	5f                   	pop    %edi
8010792c:	5d                   	pop    %ebp
8010792d:	c3                   	ret    
8010792e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107930:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107933:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107936:	89 f8                	mov    %edi,%eax
80107938:	5b                   	pop    %ebx
80107939:	5e                   	pop    %esi
8010793a:	5f                   	pop    %edi
8010793b:	5d                   	pop    %ebp
8010793c:	c3                   	ret    
8010793d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107940:	83 ec 0c             	sub    $0xc,%esp
80107943:	68 8d 87 10 80       	push   $0x8010878d
80107948:	e8 13 8d ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010794d:	83 c4 10             	add    $0x10,%esp
80107950:	8b 45 0c             	mov    0xc(%ebp),%eax
80107953:	39 45 10             	cmp    %eax,0x10(%ebp)
80107956:	76 0d                	jbe    80107965 <allocuvm+0xe5>
80107958:	89 c1                	mov    %eax,%ecx
8010795a:	8b 55 10             	mov    0x10(%ebp),%edx
8010795d:	8b 45 08             	mov    0x8(%ebp),%eax
80107960:	e8 6b fb ff ff       	call   801074d0 <deallocuvm.part.0>
      kfree(mem);
80107965:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107968:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010796a:	56                   	push   %esi
8010796b:	e8 d0 a9 ff ff       	call   80102340 <kfree>
      return 0;
80107970:	83 c4 10             	add    $0x10,%esp
}
80107973:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107976:	89 f8                	mov    %edi,%eax
80107978:	5b                   	pop    %ebx
80107979:	5e                   	pop    %esi
8010797a:	5f                   	pop    %edi
8010797b:	5d                   	pop    %ebp
8010797c:	c3                   	ret    
8010797d:	8d 76 00             	lea    0x0(%esi),%esi
80107980:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107983:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107986:	5b                   	pop    %ebx
80107987:	89 f8                	mov    %edi,%eax
80107989:	5e                   	pop    %esi
8010798a:	5f                   	pop    %edi
8010798b:	5d                   	pop    %ebp
8010798c:	c3                   	ret    
8010798d:	8d 76 00             	lea    0x0(%esi),%esi
80107990:	89 c1                	mov    %eax,%ecx
80107992:	8b 55 10             	mov    0x10(%ebp),%edx
80107995:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107998:	31 ff                	xor    %edi,%edi
8010799a:	e8 31 fb ff ff       	call   801074d0 <deallocuvm.part.0>
8010799f:	eb 92                	jmp    80107933 <allocuvm+0xb3>
801079a1:	eb 0d                	jmp    801079b0 <deallocuvm>
801079a3:	90                   	nop
801079a4:	90                   	nop
801079a5:	90                   	nop
801079a6:	90                   	nop
801079a7:	90                   	nop
801079a8:	90                   	nop
801079a9:	90                   	nop
801079aa:	90                   	nop
801079ab:	90                   	nop
801079ac:	90                   	nop
801079ad:	90                   	nop
801079ae:	90                   	nop
801079af:	90                   	nop

801079b0 <deallocuvm>:
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801079b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801079b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801079bc:	39 d1                	cmp    %edx,%ecx
801079be:	73 10                	jae    801079d0 <deallocuvm+0x20>
}
801079c0:	5d                   	pop    %ebp
801079c1:	e9 0a fb ff ff       	jmp    801074d0 <deallocuvm.part.0>
801079c6:	8d 76 00             	lea    0x0(%esi),%esi
801079c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801079d0:	89 d0                	mov    %edx,%eax
801079d2:	5d                   	pop    %ebp
801079d3:	c3                   	ret    
801079d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801079e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	57                   	push   %edi
801079e4:	56                   	push   %esi
801079e5:	53                   	push   %ebx
801079e6:	83 ec 0c             	sub    $0xc,%esp
801079e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801079ec:	85 f6                	test   %esi,%esi
801079ee:	74 59                	je     80107a49 <freevm+0x69>
801079f0:	31 c9                	xor    %ecx,%ecx
801079f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801079f7:	89 f0                	mov    %esi,%eax
801079f9:	e8 d2 fa ff ff       	call   801074d0 <deallocuvm.part.0>
801079fe:	89 f3                	mov    %esi,%ebx
80107a00:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a06:	eb 0f                	jmp    80107a17 <freevm+0x37>
80107a08:	90                   	nop
80107a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a10:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107a13:	39 fb                	cmp    %edi,%ebx
80107a15:	74 23                	je     80107a3a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107a17:	8b 03                	mov    (%ebx),%eax
80107a19:	a8 01                	test   $0x1,%al
80107a1b:	74 f3                	je     80107a10 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107a22:	83 ec 0c             	sub    $0xc,%esp
80107a25:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a28:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107a2d:	50                   	push   %eax
80107a2e:	e8 0d a9 ff ff       	call   80102340 <kfree>
80107a33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a36:	39 fb                	cmp    %edi,%ebx
80107a38:	75 dd                	jne    80107a17 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107a3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107a3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a40:	5b                   	pop    %ebx
80107a41:	5e                   	pop    %esi
80107a42:	5f                   	pop    %edi
80107a43:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107a44:	e9 f7 a8 ff ff       	jmp    80102340 <kfree>
    panic("freevm: no pgdir");
80107a49:	83 ec 0c             	sub    $0xc,%esp
80107a4c:	68 a9 87 10 80       	push   $0x801087a9
80107a51:	e8 3a 89 ff ff       	call   80100390 <panic>
80107a56:	8d 76 00             	lea    0x0(%esi),%esi
80107a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a60 <setupkvm>:
{
80107a60:	55                   	push   %ebp
80107a61:	89 e5                	mov    %esp,%ebp
80107a63:	56                   	push   %esi
80107a64:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107a65:	e8 86 aa ff ff       	call   801024f0 <kalloc>
80107a6a:	85 c0                	test   %eax,%eax
80107a6c:	89 c6                	mov    %eax,%esi
80107a6e:	74 42                	je     80107ab2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107a70:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a73:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107a78:	68 00 10 00 00       	push   $0x1000
80107a7d:	6a 00                	push   $0x0
80107a7f:	50                   	push   %eax
80107a80:	e8 4b d7 ff ff       	call   801051d0 <memset>
80107a85:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107a88:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a8b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107a8e:	83 ec 08             	sub    $0x8,%esp
80107a91:	8b 13                	mov    (%ebx),%edx
80107a93:	ff 73 0c             	pushl  0xc(%ebx)
80107a96:	50                   	push   %eax
80107a97:	29 c1                	sub    %eax,%ecx
80107a99:	89 f0                	mov    %esi,%eax
80107a9b:	e8 a0 f9 ff ff       	call   80107440 <mappages>
80107aa0:	83 c4 10             	add    $0x10,%esp
80107aa3:	85 c0                	test   %eax,%eax
80107aa5:	78 19                	js     80107ac0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107aa7:	83 c3 10             	add    $0x10,%ebx
80107aaa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107ab0:	75 d6                	jne    80107a88 <setupkvm+0x28>
}
80107ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ab5:	89 f0                	mov    %esi,%eax
80107ab7:	5b                   	pop    %ebx
80107ab8:	5e                   	pop    %esi
80107ab9:	5d                   	pop    %ebp
80107aba:	c3                   	ret    
80107abb:	90                   	nop
80107abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107ac0:	83 ec 0c             	sub    $0xc,%esp
80107ac3:	56                   	push   %esi
      return 0;
80107ac4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107ac6:	e8 15 ff ff ff       	call   801079e0 <freevm>
      return 0;
80107acb:	83 c4 10             	add    $0x10,%esp
}
80107ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ad1:	89 f0                	mov    %esi,%eax
80107ad3:	5b                   	pop    %ebx
80107ad4:	5e                   	pop    %esi
80107ad5:	5d                   	pop    %ebp
80107ad6:	c3                   	ret    
80107ad7:	89 f6                	mov    %esi,%esi
80107ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ae0 <kvmalloc>:
{
80107ae0:	55                   	push   %ebp
80107ae1:	89 e5                	mov    %esp,%ebp
80107ae3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ae6:	e8 75 ff ff ff       	call   80107a60 <setupkvm>
80107aeb:	a3 a4 35 12 80       	mov    %eax,0x801235a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107af0:	05 00 00 00 80       	add    $0x80000000,%eax
80107af5:	0f 22 d8             	mov    %eax,%cr3
}
80107af8:	c9                   	leave  
80107af9:	c3                   	ret    
80107afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b01:	31 c9                	xor    %ecx,%ecx
{
80107b03:	89 e5                	mov    %esp,%ebp
80107b05:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b08:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b0e:	e8 ad f8 ff ff       	call   801073c0 <walkpgdir>
  if(pte == 0)
80107b13:	85 c0                	test   %eax,%eax
80107b15:	74 05                	je     80107b1c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107b17:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107b1a:	c9                   	leave  
80107b1b:	c3                   	ret    
    panic("clearpteu");
80107b1c:	83 ec 0c             	sub    $0xc,%esp
80107b1f:	68 ba 87 10 80       	push   $0x801087ba
80107b24:	e8 67 88 ff ff       	call   80100390 <panic>
80107b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b30 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	57                   	push   %edi
80107b34:	56                   	push   %esi
80107b35:	53                   	push   %ebx
80107b36:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107b39:	e8 22 ff ff ff       	call   80107a60 <setupkvm>
80107b3e:	85 c0                	test   %eax,%eax
80107b40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b43:	0f 84 9f 00 00 00    	je     80107be8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b4c:	85 c9                	test   %ecx,%ecx
80107b4e:	0f 84 94 00 00 00    	je     80107be8 <copyuvm+0xb8>
80107b54:	31 ff                	xor    %edi,%edi
80107b56:	eb 4a                	jmp    80107ba2 <copyuvm+0x72>
80107b58:	90                   	nop
80107b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107b60:	83 ec 04             	sub    $0x4,%esp
80107b63:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107b69:	68 00 10 00 00       	push   $0x1000
80107b6e:	53                   	push   %ebx
80107b6f:	50                   	push   %eax
80107b70:	e8 0b d7 ff ff       	call   80105280 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107b75:	58                   	pop    %eax
80107b76:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107b7c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b81:	5a                   	pop    %edx
80107b82:	ff 75 e4             	pushl  -0x1c(%ebp)
80107b85:	50                   	push   %eax
80107b86:	89 fa                	mov    %edi,%edx
80107b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b8b:	e8 b0 f8 ff ff       	call   80107440 <mappages>
80107b90:	83 c4 10             	add    $0x10,%esp
80107b93:	85 c0                	test   %eax,%eax
80107b95:	78 61                	js     80107bf8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107b97:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107b9d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107ba0:	76 46                	jbe    80107be8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba5:	31 c9                	xor    %ecx,%ecx
80107ba7:	89 fa                	mov    %edi,%edx
80107ba9:	e8 12 f8 ff ff       	call   801073c0 <walkpgdir>
80107bae:	85 c0                	test   %eax,%eax
80107bb0:	74 61                	je     80107c13 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107bb2:	8b 00                	mov    (%eax),%eax
80107bb4:	a8 01                	test   $0x1,%al
80107bb6:	74 4e                	je     80107c06 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107bb8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107bba:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107bbf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107bc8:	e8 23 a9 ff ff       	call   801024f0 <kalloc>
80107bcd:	85 c0                	test   %eax,%eax
80107bcf:	89 c6                	mov    %eax,%esi
80107bd1:	75 8d                	jne    80107b60 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107bd3:	83 ec 0c             	sub    $0xc,%esp
80107bd6:	ff 75 e0             	pushl  -0x20(%ebp)
80107bd9:	e8 02 fe ff ff       	call   801079e0 <freevm>
  return 0;
80107bde:	83 c4 10             	add    $0x10,%esp
80107be1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107be8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bee:	5b                   	pop    %ebx
80107bef:	5e                   	pop    %esi
80107bf0:	5f                   	pop    %edi
80107bf1:	5d                   	pop    %ebp
80107bf2:	c3                   	ret    
80107bf3:	90                   	nop
80107bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107bf8:	83 ec 0c             	sub    $0xc,%esp
80107bfb:	56                   	push   %esi
80107bfc:	e8 3f a7 ff ff       	call   80102340 <kfree>
      goto bad;
80107c01:	83 c4 10             	add    $0x10,%esp
80107c04:	eb cd                	jmp    80107bd3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107c06:	83 ec 0c             	sub    $0xc,%esp
80107c09:	68 de 87 10 80       	push   $0x801087de
80107c0e:	e8 7d 87 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107c13:	83 ec 0c             	sub    $0xc,%esp
80107c16:	68 c4 87 10 80       	push   $0x801087c4
80107c1b:	e8 70 87 ff ff       	call   80100390 <panic>

80107c20 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c21:	31 c9                	xor    %ecx,%ecx
{
80107c23:	89 e5                	mov    %esp,%ebp
80107c25:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107c28:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c2e:	e8 8d f7 ff ff       	call   801073c0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107c33:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107c35:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107c36:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107c38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107c3d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107c40:	05 00 00 00 80       	add    $0x80000000,%eax
80107c45:	83 fa 05             	cmp    $0x5,%edx
80107c48:	ba 00 00 00 00       	mov    $0x0,%edx
80107c4d:	0f 45 c2             	cmovne %edx,%eax
}
80107c50:	c3                   	ret    
80107c51:	eb 0d                	jmp    80107c60 <copyout>
80107c53:	90                   	nop
80107c54:	90                   	nop
80107c55:	90                   	nop
80107c56:	90                   	nop
80107c57:	90                   	nop
80107c58:	90                   	nop
80107c59:	90                   	nop
80107c5a:	90                   	nop
80107c5b:	90                   	nop
80107c5c:	90                   	nop
80107c5d:	90                   	nop
80107c5e:	90                   	nop
80107c5f:	90                   	nop

80107c60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	83 ec 1c             	sub    $0x1c,%esp
80107c69:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107c72:	85 db                	test   %ebx,%ebx
80107c74:	75 40                	jne    80107cb6 <copyout+0x56>
80107c76:	eb 70                	jmp    80107ce8 <copyout+0x88>
80107c78:	90                   	nop
80107c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107c80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c83:	89 f1                	mov    %esi,%ecx
80107c85:	29 d1                	sub    %edx,%ecx
80107c87:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107c8d:	39 d9                	cmp    %ebx,%ecx
80107c8f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107c92:	29 f2                	sub    %esi,%edx
80107c94:	83 ec 04             	sub    $0x4,%esp
80107c97:	01 d0                	add    %edx,%eax
80107c99:	51                   	push   %ecx
80107c9a:	57                   	push   %edi
80107c9b:	50                   	push   %eax
80107c9c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107c9f:	e8 dc d5 ff ff       	call   80105280 <memmove>
    len -= n;
    buf += n;
80107ca4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107ca7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107caa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107cb0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107cb2:	29 cb                	sub    %ecx,%ebx
80107cb4:	74 32                	je     80107ce8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107cb6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107cb8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107cbb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107cbe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107cc4:	56                   	push   %esi
80107cc5:	ff 75 08             	pushl  0x8(%ebp)
80107cc8:	e8 53 ff ff ff       	call   80107c20 <uva2ka>
    if(pa0 == 0)
80107ccd:	83 c4 10             	add    $0x10,%esp
80107cd0:	85 c0                	test   %eax,%eax
80107cd2:	75 ac                	jne    80107c80 <copyout+0x20>
  }
  return 0;
}
80107cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107cdc:	5b                   	pop    %ebx
80107cdd:	5e                   	pop    %esi
80107cde:	5f                   	pop    %edi
80107cdf:	5d                   	pop    %ebp
80107ce0:	c3                   	ret    
80107ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ceb:	31 c0                	xor    %eax,%eax
}
80107ced:	5b                   	pop    %ebx
80107cee:	5e                   	pop    %esi
80107cef:	5f                   	pop    %edi
80107cf0:	5d                   	pop    %ebp
80107cf1:	c3                   	ret    
