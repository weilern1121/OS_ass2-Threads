
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
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 74 10 80       	push   $0x801074e0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 95 47 00 00       	call   801047f0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
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
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 74 10 80       	push   $0x801074e7
80100097:	50                   	push   %eax
80100098:	e8 23 46 00 00       	call   801046c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
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
801000e4:	e8 47 48 00 00       	call   80104930 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 89 48 00 00       	call   801049f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 45 00 00       	call   80104700 <acquiresleep>
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
80100193:	68 ee 74 10 80       	push   $0x801074ee
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
801001ae:	e8 ed 45 00 00       	call   801047a0 <holdingsleep>
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
801001cc:	68 ff 74 10 80       	push   $0x801074ff
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
801001ef:	e8 ac 45 00 00       	call   801047a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 45 00 00       	call   80104760 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 20 47 00 00       	call   80104930 <acquire>
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
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 47 00 00       	jmp    801049f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 75 10 80       	push   $0x80107506
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
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 9f 46 00 00       	call   80104930 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
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
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 56 3c 00 00       	call   80103f20 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 10 36 00 00       	call   801038f0 <myproc>
801002e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 fc 46 00 00       	call   801049f0 <release>
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
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
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
8010034d:	e8 9e 46 00 00       	call   801049f0 <release>
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
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
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
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 23 00 00       	call   80102770 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 75 10 80       	push   $0x8010750d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 71 75 10 80 	movl   $0x80107571,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 44 00 00       	call   80104810 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 75 10 80       	push   $0x80107521
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
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
8010043a:	e8 91 5c 00 00       	call   801060d0 <uartputc>
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
801004ec:	e8 df 5b 00 00       	call   801060d0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 5b 00 00       	call   801060d0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 5b 00 00       	call   801060d0 <uartputc>
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
80100524:	e8 d7 45 00 00       	call   80104b00 <memmove>
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
80100541:	e8 0a 45 00 00       	call   80104a50 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 75 10 80       	push   $0x80107525
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
801005b1:	0f b6 92 50 75 10 80 	movzbl -0x7fef8ab0(%edx),%edx
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
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 10 43 00 00       	call   80104930 <acquire>
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
80100647:	e8 a4 43 00 00       	call   801049f0 <release>
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
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
8010071f:	e8 cc 42 00 00       	call   801049f0 <release>
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
801007d0:	ba 38 75 10 80       	mov    $0x80107538,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 3b 41 00 00       	call   80104930 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 75 10 80       	push   $0x8010753f
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
80100823:	e8 08 41 00 00       	call   80104930 <acquire>
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
80100851:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100856:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
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
80100888:	e8 63 41 00 00       	call   801049f0 <release>
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
801008a9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100911:	68 c0 0f 11 80       	push   $0x80110fc0
80100916:	e8 65 3b 00 00       	call   80104480 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010093d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100964:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
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
80100997:	e9 44 3c 00 00       	jmp    801045e0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
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
801009c6:	68 48 75 10 80       	push   $0x80107548
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 1b 3e 00 00       	call   801047f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
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
80100a1c:	68 61 75 10 80       	push   $0x80107561
80100a21:	e8 3a fc ff ff       	call   80100660 <cprintf>
    uint argc, sz, sp, ustack[3+MAXARG+1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
80100a26:	e8 c5 2e 00 00       	call   801038f0 <myproc>
80100a2b:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
    struct  thread *curthread = mythread();
80100a31:	e8 ea 2e 00 00       	call   80103920 <mythread>
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
80100aac:	e8 7f 67 00 00       	call   80107230 <setupkvm>
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
80100b0e:	e8 3d 65 00 00       	call   80107050 <allocuvm>
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
80100b40:	e8 4b 64 00 00       	call   80106f90 <loaduvm>
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
80100b8a:	e8 21 66 00 00       	call   801071b0 <freevm>
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
80100bc2:	e8 89 64 00 00       	call   80107050 <allocuvm>
80100bc7:	83 c4 10             	add    $0x10,%esp
80100bca:	85 c0                	test   %eax,%eax
80100bcc:	89 c6                	mov    %eax,%esi
80100bce:	75 3a                	jne    80100c0a <exec+0x1fa>
        freevm(pgdir);
80100bd0:	83 ec 0c             	sub    $0xc,%esp
80100bd3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bd9:	e8 d2 65 00 00       	call   801071b0 <freevm>
80100bde:	83 c4 10             	add    $0x10,%esp
    return -1;
80100be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be6:	e9 a4 fe ff ff       	jmp    80100a8f <exec+0x7f>
        end_op();
80100beb:	e8 60 20 00 00       	call   80102c50 <end_op>
        cprintf("exec: fail\n");
80100bf0:	83 ec 0c             	sub    $0xc,%esp
80100bf3:	68 73 75 10 80       	push   $0x80107573
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
80100c1e:	e8 ad 66 00 00       	call   801072d0 <clearpteu>
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
80100c51:	e8 1a 40 00 00       	call   80104c70 <strlen>
80100c56:	f7 d0                	not    %eax
80100c58:	01 c3                	add    %eax,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c5a:	58                   	pop    %eax
80100c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c5e:	83 e3 fc             	and    $0xfffffffc,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c61:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c64:	e8 07 40 00 00       	call   80104c70 <strlen>
80100c69:	83 c0 01             	add    $0x1,%eax
80100c6c:	50                   	push   %eax
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c70:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c73:	53                   	push   %ebx
80100c74:	56                   	push   %esi
80100c75:	e8 b6 67 00 00       	call   80107430 <copyout>
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
80100cdf:	e8 4c 67 00 00       	call   80107430 <copyout>
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
80100d20:	e8 0b 3f 00 00       	call   80104c30 <safestrcpy>
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
80100d57:	e8 b4 32 00 00       	call   80104010 <cleanProcOneThread>
    curproc->mainThread=curthread;
80100d5c:	89 f1                	mov    %esi,%ecx
80100d5e:	89 99 f0 03 00 00    	mov    %ebx,0x3f0(%ecx)
    switchuvm(curproc);
80100d64:	89 34 24             	mov    %esi,(%esp)
80100d67:	e8 84 60 00 00       	call   80106df0 <switchuvm>
    freevm(oldpgdir);
80100d6c:	89 3c 24             	mov    %edi,(%esp)
80100d6f:	e8 3c 64 00 00       	call   801071b0 <freevm>
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
80100d96:	68 7f 75 10 80       	push   $0x8010757f
80100d9b:	68 e0 0f 11 80       	push   $0x80110fe0
80100da0:	e8 4b 3a 00 00       	call   801047f0 <initlock>
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
80100db4:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dbc:	68 e0 0f 11 80       	push   $0x80110fe0
80100dc1:	e8 6a 3b 00 00       	call   80104930 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
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
80100dec:	68 e0 0f 11 80       	push   $0x80110fe0
80100df1:	e8 fa 3b 00 00       	call   801049f0 <release>
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
80100e05:	68 e0 0f 11 80       	push   $0x80110fe0
80100e0a:	e8 e1 3b 00 00       	call   801049f0 <release>
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
80100e2a:	68 e0 0f 11 80       	push   $0x80110fe0
80100e2f:	e8 fc 3a 00 00       	call   80104930 <acquire>
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
80100e47:	68 e0 0f 11 80       	push   $0x80110fe0
80100e4c:	e8 9f 3b 00 00       	call   801049f0 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 86 75 10 80       	push   $0x80107586
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
80100e7c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e81:	e8 aa 3a 00 00       	call   80104930 <acquire>
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
80100e9e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
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
80100eac:	e9 3f 3b 00 00       	jmp    801049f0 <release>
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
80100ed0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ed8:	e8 13 3b 00 00       	call   801049f0 <release>
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
80100f32:	68 8e 75 10 80       	push   $0x8010758e
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
80101012:	68 98 75 10 80       	push   $0x80107598
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
80101125:	68 a1 75 10 80       	push   $0x801075a1
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 a7 75 10 80       	push   $0x801075a7
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
80101149:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
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
8010116c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101172:	50                   	push   %eax
80101173:	ff 75 d8             	pushl  -0x28(%ebp)
80101176:	e8 55 ef ff ff       	call   801000d0 <bread>
8010117b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
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
801011d9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801011df:	77 80                	ja     80101161 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011e1:	83 ec 0c             	sub    $0xc,%esp
801011e4:	68 b1 75 10 80       	push   $0x801075b1
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
80101225:	e8 26 38 00 00       	call   80104a50 <memset>
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
8010125a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010125f:	83 ec 28             	sub    $0x28,%esp
80101262:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101265:	68 00 1a 11 80       	push   $0x80111a00
8010126a:	e8 c1 36 00 00       	call   80104930 <acquire>
8010126f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101275:	eb 17                	jmp    8010128e <iget+0x3e>
80101277:	89 f6                	mov    %esi,%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101280:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101286:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
801012a8:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
801012ca:	68 00 1a 11 80       	push   $0x80111a00
801012cf:	e8 1c 37 00 00       	call   801049f0 <release>

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
801012f5:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801012fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012fd:	e8 ee 36 00 00       	call   801049f0 <release>
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
80101312:	68 c7 75 10 80       	push   $0x801075c7
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
801013e7:	68 d7 75 10 80       	push   $0x801075d7
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
80101421:	e8 da 36 00 00       	call   80104b00 <memmove>
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
8010144c:	68 e0 19 11 80       	push   $0x801119e0
80101451:	50                   	push   %eax
80101452:	e8 a9 ff ff ff       	call   80101400 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101457:	58                   	pop    %eax
80101458:	5a                   	pop    %edx
80101459:	89 da                	mov    %ebx,%edx
8010145b:	c1 ea 0c             	shr    $0xc,%edx
8010145e:	03 15 f8 19 11 80    	add    0x801119f8,%edx
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
801014b4:	68 ea 75 10 80       	push   $0x801075ea
801014b9:	e8 d2 ee ff ff       	call   80100390 <panic>
801014be:	66 90                	xchg   %ax,%ax

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
801014c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014cc:	68 fd 75 10 80       	push   $0x801075fd
801014d1:	68 00 1a 11 80       	push   $0x80111a00
801014d6:	e8 15 33 00 00       	call   801047f0 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 04 76 10 80       	push   $0x80107604
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 cc 31 00 00       	call   801046c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014f4:	83 c4 10             	add    $0x10,%esp
801014f7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014fd:	75 e1                	jne    801014e0 <iinit+0x20>
  readsb(dev, &sb);
801014ff:	83 ec 08             	sub    $0x8,%esp
80101502:	68 e0 19 11 80       	push   $0x801119e0
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 f1 fe ff ff       	call   80101400 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010150f:	ff 35 f8 19 11 80    	pushl  0x801119f8
80101515:	ff 35 f4 19 11 80    	pushl  0x801119f4
8010151b:	ff 35 f0 19 11 80    	pushl  0x801119f0
80101521:	ff 35 ec 19 11 80    	pushl  0x801119ec
80101527:	ff 35 e8 19 11 80    	pushl  0x801119e8
8010152d:	ff 35 e4 19 11 80    	pushl  0x801119e4
80101533:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101539:	68 68 76 10 80       	push   $0x80107668
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
80101559:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
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
8010158f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101595:	76 69                	jbe    80101600 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101597:	89 d8                	mov    %ebx,%eax
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	c1 e8 03             	shr    $0x3,%eax
8010159f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
801015ce:	e8 7d 34 00 00       	call   80104a50 <memset>
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
80101603:	68 0a 76 10 80       	push   $0x8010760a
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
80101624:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101671:	e8 8a 34 00 00       	call   80104b00 <memmove>
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
8010169a:	68 00 1a 11 80       	push   $0x80111a00
8010169f:	e8 8c 32 00 00       	call   80104930 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801016af:	e8 3c 33 00 00       	call   801049f0 <release>
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
801016e2:	e8 19 30 00 00       	call   80104700 <acquiresleep>
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
80101709:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101758:	e8 a3 33 00 00       	call   80104b00 <memmove>
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
8010177d:	68 22 76 10 80       	push   $0x80107622
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 1c 76 10 80       	push   $0x8010761c
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
801017b3:	e8 e8 2f 00 00       	call   801047a0 <holdingsleep>
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
801017cf:	e9 8c 2f 00 00       	jmp    80104760 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 31 76 10 80       	push   $0x80107631
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
80101800:	e8 fb 2e 00 00       	call   80104700 <acquiresleep>
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
8010181a:	e8 41 2f 00 00       	call   80104760 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101826:	e8 05 31 00 00       	call   80104930 <acquire>
  ip->ref--;
8010182b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5f                   	pop    %edi
8010183f:	5d                   	pop    %ebp
  release(&icache.lock);
80101840:	e9 ab 31 00 00       	jmp    801049f0 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 00 1a 11 80       	push   $0x80111a00
80101850:	e8 db 30 00 00       	call   80104930 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010185f:	e8 8c 31 00 00       	call   801049f0 <release>
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
80101a47:	e8 b4 30 00 00       	call   80104b00 <memmove>
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
80101a7a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
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
80101b43:	e8 b8 2f 00 00       	call   80104b00 <memmove>
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
80101b8a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
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
80101bde:	e8 8d 2f 00 00       	call   80104b70 <strncmp>
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
80101c3d:	e8 2e 2f 00 00       	call   80104b70 <strncmp>
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
80101c82:	68 4b 76 10 80       	push   $0x8010764b
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 39 76 10 80       	push   $0x80107639
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
80101cb9:	e8 62 1c 00 00       	call   80103920 <mythread>
  acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(mythread()->cwd);
80101cc1:	8b 70 20             	mov    0x20(%eax),%esi
  acquire(&icache.lock);
80101cc4:	68 00 1a 11 80       	push   $0x80111a00
80101cc9:	e8 62 2c 00 00       	call   80104930 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cd9:	e8 12 2d 00 00       	call   801049f0 <release>
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
80101d35:	e8 c6 2d 00 00       	call   80104b00 <memmove>
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
80101dc8:	e8 33 2d 00 00       	call   80104b00 <memmove>
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
80101ebd:	e8 0e 2d 00 00       	call   80104bd0 <strncpy>
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
80101efb:	68 5a 76 10 80       	push   $0x8010765a
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 9e 7d 10 80       	push   $0x80107d9e
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
8010201b:	68 c4 76 10 80       	push   $0x801076c4
80102020:	e8 6b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	68 bb 76 10 80       	push   $0x801076bb
8010202d:	e8 5e e3 ff ff       	call   80100390 <panic>
80102032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102040 <ideinit>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102046:	68 d6 76 10 80       	push   $0x801076d6
8010204b:	68 80 b5 10 80       	push   $0x8010b580
80102050:	e8 9b 27 00 00       	call   801047f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102055:	58                   	pop    %eax
80102056:	a1 40 3d 11 80       	mov    0x80113d40,%eax
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
8010209a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
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
801020c9:	68 80 b5 10 80       	push   $0x8010b580
801020ce:	e8 5d 28 00 00       	call   80104930 <acquire>

  if((b = idequeue) == 0){
801020d3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020d9:	83 c4 10             	add    $0x10,%esp
801020dc:	85 db                	test   %ebx,%ebx
801020de:	74 67                	je     80102147 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020e0:	8b 43 58             	mov    0x58(%ebx),%eax
801020e3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

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
80102131:	e8 4a 23 00 00       	call   80104480 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102136:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	85 c0                	test   %eax,%eax
80102140:	74 05                	je     80102147 <ideintr+0x87>
    idestart(idequeue);
80102142:	e8 19 fe ff ff       	call   80101f60 <idestart>
    release(&idelock);
80102147:	83 ec 0c             	sub    $0xc,%esp
8010214a:	68 80 b5 10 80       	push   $0x8010b580
8010214f:	e8 9c 28 00 00       	call   801049f0 <release>

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
8010216e:	e8 2d 26 00 00       	call   801047a0 <holdingsleep>
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
80102193:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102198:	85 c0                	test   %eax,%eax
8010219a:	0f 84 b1 00 00 00    	je     80102251 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	68 80 b5 10 80       	push   $0x8010b580
801021a8:	e8 83 27 00 00       	call   80104930 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
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
801021d6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
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
801021f3:	68 80 b5 10 80       	push   $0x8010b580
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
8010220b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102212:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102215:	c9                   	leave  
  release(&idelock);
80102216:	e9 d5 27 00 00       	jmp    801049f0 <release>
8010221b:	90                   	nop
8010221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102220:	89 d8                	mov    %ebx,%eax
80102222:	e8 39 fd ff ff       	call   80101f60 <idestart>
80102227:	eb b5                	jmp    801021de <iderw+0x7e>
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102230:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102235:	eb 9d                	jmp    801021d4 <iderw+0x74>
    panic("iderw: nothing to do");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 f0 76 10 80       	push   $0x801076f0
8010223f:	e8 4c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 da 76 10 80       	push   $0x801076da
8010224c:	e8 3f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102251:	83 ec 0c             	sub    $0xc,%esp
80102254:	68 05 77 10 80       	push   $0x80107705
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
80102261:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102268:	00 c0 fe 
{
8010226b:	89 e5                	mov    %esp,%ebp
8010226d:	56                   	push   %esi
8010226e:	53                   	push   %ebx
  ioapic->reg = reg;
8010226f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102276:	00 00 00 
  return ioapic->data;
80102279:	a1 54 36 11 80       	mov    0x80113654,%eax
8010227e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102287:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010228d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
801022a7:	68 24 77 10 80       	push   $0x80107724
801022ac:	e8 af e3 ff ff       	call   80100660 <cprintf>
801022b1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
801022d2:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

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
801022f0:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102311:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102325:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010232e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102331:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102334:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102336:	a1 54 36 11 80       	mov    0x80113654,%eax
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
80102362:	81 fb e8 44 12 80    	cmp    $0x801244e8,%ebx
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
80102382:	e8 c9 26 00 00       	call   80104a50 <memset>

  if(kmem.use_lock)
80102387:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	85 d2                	test   %edx,%edx
80102392:	75 2c                	jne    801023c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102394:	a1 98 36 11 80       	mov    0x80113698,%eax
80102399:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010239b:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
801023a0:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
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
801023b0:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
801023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ba:	c9                   	leave  
    release(&kmem.lock);
801023bb:	e9 30 26 00 00       	jmp    801049f0 <release>
    acquire(&kmem.lock);
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	68 60 36 11 80       	push   $0x80113660
801023c8:	e8 63 25 00 00       	call   80104930 <acquire>
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	eb c2                	jmp    80102394 <kfree+0x44>
    panic("kfree");
801023d2:	83 ec 0c             	sub    $0xc,%esp
801023d5:	68 56 77 10 80       	push   $0x80107756
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
8010243b:	68 5c 77 10 80       	push   $0x8010775c
80102440:	68 60 36 11 80       	push   $0x80113660
80102445:	e8 a6 23 00 00       	call   801047f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102450:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
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
801024e4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
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
80102500:	a1 94 36 11 80       	mov    0x80113694,%eax
80102505:	85 c0                	test   %eax,%eax
80102507:	75 1f                	jne    80102528 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102509:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010250e:	85 c0                	test   %eax,%eax
80102510:	74 0e                	je     80102520 <kalloc+0x20>
    kmem.freelist = r->next;
80102512:	8b 10                	mov    (%eax),%edx
80102514:	89 15 98 36 11 80    	mov    %edx,0x80113698
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
8010252e:	68 60 36 11 80       	push   $0x80113660
80102533:	e8 f8 23 00 00       	call   80104930 <acquire>
  r = kmem.freelist;
80102538:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102546:	85 c0                	test   %eax,%eax
80102548:	74 08                	je     80102552 <kalloc+0x52>
    kmem.freelist = r->next;
8010254a:	8b 08                	mov    (%eax),%ecx
8010254c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102552:	85 d2                	test   %edx,%edx
80102554:	74 16                	je     8010256c <kalloc+0x6c>
    release(&kmem.lock);
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010255c:	68 60 36 11 80       	push   $0x80113660
80102561:	e8 8a 24 00 00       	call   801049f0 <release>
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
80102587:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

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
801025b3:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
801025ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025bc:	0f b6 82 a0 77 10 80 	movzbl -0x7fef8860(%edx),%eax
801025c3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025c7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025cd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025d0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025d3:	8b 04 85 80 77 10 80 	mov    -0x7fef8880(,%eax,4),%eax
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
801025f8:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
801025ff:	83 c8 40             	or     $0x40,%eax
80102602:	0f b6 c0             	movzbl %al,%eax
80102605:	f7 d0                	not    %eax
80102607:	21 c1                	and    %eax,%ecx
    return 0;
80102609:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010260b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
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
8010261d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
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
80102670:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
80102770:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
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
80102790:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
801027fe:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
80102977:	e8 24 21 00 00       	call   80104aa0 <memcmp>
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
80102a40:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
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
80102a60:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	01 d8                	add    %ebx,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	50                   	push   %eax
80102a6e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102a74:	e8 57 d6 ff ff       	call   801000d0 <bread>
80102a79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7b:	58                   	pop    %eax
80102a7c:	5a                   	pop    %edx
80102a7d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102a84:	ff 35 e4 36 11 80    	pushl  0x801136e4
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
80102aa4:	e8 57 20 00 00       	call   80104b00 <memmove>
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
80102ac4:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
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
80102ae8:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102aee:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102af4:	e8 d7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102af9:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
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
80102b10:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
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
80102b4a:	68 a0 79 10 80       	push   $0x801079a0
80102b4f:	68 a0 36 11 80       	push   $0x801136a0
80102b54:	e8 97 1c 00 00       	call   801047f0 <initlock>
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
80102b6c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102b72:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102b78:	a3 d4 36 11 80       	mov    %eax,0x801136d4
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
80102b8d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102b93:	7e 1c                	jle    80102bb1 <initlog+0x71>
80102b95:	c1 e3 02             	shl    $0x2,%ebx
80102b98:	31 d2                	xor    %edx,%edx
80102b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ba0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ba4:	83 c2 04             	add    $0x4,%edx
80102ba7:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
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
80102bbf:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
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
80102be6:	68 a0 36 11 80       	push   $0x801136a0
80102beb:	e8 40 1d 00 00       	call   80104930 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 a0 36 11 80       	push   $0x801136a0
80102c00:	68 a0 36 11 80       	push   $0x801136a0
80102c05:	e8 16 13 00 00       	call   80103f20 <sleep>
80102c0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c0d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 e2                	jne    80102bf8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c16:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102c1b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80102c32:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102c37:	68 a0 36 11 80       	push   $0x801136a0
80102c3c:	e8 af 1d 00 00       	call   801049f0 <release>
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
80102c59:	68 a0 36 11 80       	push   $0x801136a0
80102c5e:	e8 cd 1c 00 00       	call   80104930 <acquire>
  log.outstanding -= 1;
80102c63:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102c68:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102c6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c71:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c74:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c76:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
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
80102c8d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102c94:	00 00 00 
  release(&log.lock);
80102c97:	68 a0 36 11 80       	push   $0x801136a0
80102c9c:	e8 4f 1d 00 00       	call   801049f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ca1:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102ca7:	83 c4 10             	add    $0x10,%esp
80102caa:	85 c9                	test   %ecx,%ecx
80102cac:	0f 8e 85 00 00 00    	jle    80102d37 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cb2:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102cb7:	83 ec 08             	sub    $0x8,%esp
80102cba:	01 d8                	add    %ebx,%eax
80102cbc:	83 c0 01             	add    $0x1,%eax
80102cbf:	50                   	push   %eax
80102cc0:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102cc6:	e8 05 d4 ff ff       	call   801000d0 <bread>
80102ccb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccd:	58                   	pop    %eax
80102cce:	5a                   	pop    %edx
80102ccf:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102cd6:	ff 35 e4 36 11 80    	pushl  0x801136e4
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
80102cf6:	e8 05 1e 00 00       	call   80104b00 <memmove>
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
80102d16:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102d1c:	7c 94                	jl     80102cb2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d1e:	e8 bd fd ff ff       	call   80102ae0 <write_head>
    install_trans(); // Now install writes to home locations
80102d23:	e8 18 fd ff ff       	call   80102a40 <install_trans>
    log.lh.n = 0;
80102d28:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d2f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d32:	e8 a9 fd ff ff       	call   80102ae0 <write_head>
    acquire(&log.lock);
80102d37:	83 ec 0c             	sub    $0xc,%esp
80102d3a:	68 a0 36 11 80       	push   $0x801136a0
80102d3f:	e8 ec 1b 00 00       	call   80104930 <acquire>
    wakeup(&log);
80102d44:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102d4b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102d52:	00 00 00 
    wakeup(&log);
80102d55:	e8 26 17 00 00       	call   80104480 <wakeup>
    release(&log.lock);
80102d5a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d61:	e8 8a 1c 00 00       	call   801049f0 <release>
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
80102d7b:	68 a0 36 11 80       	push   $0x801136a0
80102d80:	e8 fb 16 00 00       	call   80104480 <wakeup>
  release(&log.lock);
80102d85:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d8c:	e8 5f 1c 00 00       	call   801049f0 <release>
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
80102d9f:	68 a4 79 10 80       	push   $0x801079a4
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
80102db7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dc0:	83 fa 1d             	cmp    $0x1d,%edx
80102dc3:	0f 8f 9d 00 00 00    	jg     80102e66 <log_write+0xb6>
80102dc9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102dce:	83 e8 01             	sub    $0x1,%eax
80102dd1:	39 c2                	cmp    %eax,%edx
80102dd3:	0f 8d 8d 00 00 00    	jge    80102e66 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dd9:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	0f 8e 8d 00 00 00    	jle    80102e73 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	68 a0 36 11 80       	push   $0x801136a0
80102dee:	e8 3d 1b 00 00       	call   80104930 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102df3:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	83 f9 00             	cmp    $0x0,%ecx
80102dff:	7e 57                	jle    80102e58 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e01:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e04:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e06:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
80102e0c:	75 0b                	jne    80102e19 <log_write+0x69>
80102e0e:	eb 38                	jmp    80102e48 <log_write+0x98>
80102e10:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80102e17:	74 2f                	je     80102e48 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e19:	83 c0 01             	add    $0x1,%eax
80102e1c:	39 c1                	cmp    %eax,%ecx
80102e1e:	75 f0                	jne    80102e10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e20:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e27:	83 c0 01             	add    $0x1,%eax
80102e2a:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102e2f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e32:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3c:	c9                   	leave  
  release(&log.lock);
80102e3d:	e9 ae 1b 00 00       	jmp    801049f0 <release>
80102e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e48:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
80102e4f:	eb de                	jmp    80102e2f <log_write+0x7f>
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8b 43 08             	mov    0x8(%ebx),%eax
80102e5b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102e60:	75 cd                	jne    80102e2f <log_write+0x7f>
80102e62:	31 c0                	xor    %eax,%eax
80102e64:	eb c1                	jmp    80102e27 <log_write+0x77>
    panic("too big a transaction");
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	68 b3 79 10 80       	push   $0x801079b3
80102e6e:	e8 1d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e73:	83 ec 0c             	sub    $0xc,%esp
80102e76:	68 c9 79 10 80       	push   $0x801079c9
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
80102e87:	e8 44 0a 00 00       	call   801038d0 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 3d 0a 00 00       	call   801038d0 <cpuid>
80102e93:	83 ec 04             	sub    $0x4,%esp
80102e96:	53                   	push   %ebx
80102e97:	50                   	push   %eax
80102e98:	68 e4 79 10 80       	push   $0x801079e4
80102e9d:	e8 be d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea2:	e8 39 2e 00 00       	call   80105ce0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ea7:	e8 a4 09 00 00       	call   80103850 <mycpu>
80102eac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eae:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eba:	e8 41 0e 00 00       	call   80103d00 <scheduler>
80102ebf:	90                   	nop

80102ec0 <mpenter>:
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ec6:	e8 05 3f 00 00       	call   80106dd0 <switchkvm>
  seginit();
80102ecb:	e8 70 3e 00 00       	call   80106d40 <seginit>
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
80102ef7:	68 e8 44 12 80       	push   $0x801244e8
80102efc:	e8 2f f5 ff ff       	call   80102430 <kinit1>
  kvmalloc();      // kernel page table
80102f01:	e8 aa 43 00 00       	call   801072b0 <kvmalloc>
  mpinit();        // detect other processors
80102f06:	e8 75 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f0b:	e8 60 f7 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102f10:	e8 2b 3e 00 00       	call   80106d40 <seginit>
  picinit();       // disable pic
80102f15:	e8 46 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f1a:	e8 41 f3 ff ff       	call   80102260 <ioapicinit>
  consoleinit();   // console hardware
80102f1f:	e8 9c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f24:	e8 e7 30 00 00       	call   80106010 <uartinit>
  pinit();         // process table
80102f29:	e8 a2 08 00 00       	call   801037d0 <pinit>
  tvinit();        // trap vectors
80102f2e:	e8 2d 2d 00 00       	call   80105c60 <tvinit>
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
80102f4a:	68 8c b4 10 80       	push   $0x8010b48c
80102f4f:	68 00 70 00 80       	push   $0x80007000
80102f54:	e8 a7 1b 00 00       	call   80104b00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f59:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80102f60:	00 00 00 
80102f63:	83 c4 10             	add    $0x10,%esp
80102f66:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f6b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80102f70:	76 71                	jbe    80102fe3 <main+0x103>
80102f72:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80102f77:	89 f6                	mov    %esi,%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f80:	e8 cb 08 00 00       	call   80103850 <mycpu>
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
80102f9d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102fa4:	a0 10 00 
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
80102fca:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80102fda:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 9d                	jb     80102f80 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 ab f4 ff ff       	call   801024a0 <kinit2>
  userinit();      // first user process
80102ff5:	e8 56 09 00 00       	call   80103950 <userinit>
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
8010302e:	68 f8 79 10 80       	push   $0x801079f8
80103033:	56                   	push   %esi
80103034:	e8 67 1a 00 00       	call   80104aa0 <memcmp>
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
801030ec:	68 15 7a 10 80       	push   $0x80107a15
801030f1:	56                   	push   %esi
801030f2:	e8 a9 19 00 00       	call   80104aa0 <memcmp>
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
80103157:	a3 9c 36 11 80       	mov    %eax,0x8011369c
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
80103180:	ff 24 95 3c 7a 10 80 	jmp    *-0x7fef85c4(,%edx,4)
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
801031c8:	8b 0d 40 3d 11 80    	mov    0x80113d40,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 40 3d 11 80    	mov    %ecx,0x80113d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
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
801031ff:	88 15 80 37 11 80    	mov    %dl,0x80113780
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
80103233:	68 fd 79 10 80       	push   $0x801079fd
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 1c 7a 10 80       	push   $0x80107a1c
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
8010333b:	68 50 7a 10 80       	push   $0x80107a50
80103340:	50                   	push   %eax
80103341:	e8 aa 14 00 00       	call   801047f0 <initlock>
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
8010339f:	e8 8c 15 00 00       	call   80104930 <acquire>
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
801033bf:	e8 bc 10 00 00       	call   80104480 <wakeup>
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
801033e4:	e9 07 16 00 00       	jmp    801049f0 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 77 10 00 00       	call   80104480 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 d7 15 00 00       	call   801049f0 <release>
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
8010343d:	e8 ee 14 00 00       	call   80104930 <acquire>
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
80103494:	e8 e7 0f 00 00       	call   80104480 <wakeup>
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
801034c4:	e8 27 04 00 00       	call   801038f0 <myproc>
801034c9:	8b 40 1c             	mov    0x1c(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 17 15 00 00       	call   801049f0 <release>
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
80103523:	e8 58 0f 00 00       	call   80104480 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 c0 14 00 00       	call   801049f0 <release>
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
80103550:	e8 db 13 00 00       	call   80104930 <acquire>
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
801035a9:	e8 42 03 00 00       	call   801038f0 <myproc>
801035ae:	8b 48 1c             	mov    0x1c(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 2d 14 00 00       	call   801049f0 <release>
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
80103617:	e8 64 0e 00 00       	call   80104480 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 cc 13 00 00       	call   801049f0 <release>
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
    if (DEBUGMODE > 0)
80103640:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
allocproc(void) {
80103645:	55                   	push   %ebp
80103646:	89 e5                	mov    %esp,%ebp
80103648:	56                   	push   %esi
80103649:	53                   	push   %ebx
    if (DEBUGMODE > 0)
8010364a:	85 c0                	test   %eax,%eax
8010364c:	7e 10                	jle    8010365e <allocproc+0x1e>
        cprintf(" ALLOCPROC ");
8010364e:	83 ec 0c             	sub    $0xc,%esp
80103651:	68 55 7a 10 80       	push   $0x80107a55
80103656:	e8 05 d0 ff ff       	call   80100660 <cprintf>
8010365b:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    char *sp;
    acquire(&ptable.lock);
8010365e:	83 ec 0c             	sub    $0xc,%esp
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103661:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
    acquire(&ptable.lock);
80103666:	68 60 3d 11 80       	push   $0x80113d60
8010366b:	e8 c0 12 00 00       	call   80104930 <acquire>
80103670:	83 c4 10             	add    $0x10,%esp
80103673:	eb 11                	jmp    80103686 <allocproc+0x46>
80103675:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103678:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
8010367e:	81 fb 94 3c 12 80    	cmp    $0x80123c94,%ebx
80103684:	73 50                	jae    801036d6 <allocproc+0x96>
        if (p->state == UNUSED)
80103686:	8b 73 08             	mov    0x8(%ebx),%esi
80103689:	85 f6                	test   %esi,%esi
8010368b:	75 eb                	jne    80103678 <allocproc+0x38>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
8010368d:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
80103692:	8b 4b 78             	mov    0x78(%ebx),%ecx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80103695:	8d 73 70             	lea    0x70(%ebx),%esi
    p->state = EMBRYO;
80103698:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    p->tidCounter = 1;
8010369f:	c7 83 f4 03 00 00 01 	movl   $0x1,0x3f4(%ebx)
801036a6:	00 00 00 
    p->pid = nextpid++;
801036a9:	8d 50 01             	lea    0x1(%eax),%edx
        if (t->state == UNUSED)
801036ac:	85 c9                	test   %ecx,%ecx
    p->pid = nextpid++;
801036ae:	89 43 0c             	mov    %eax,0xc(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801036b1:	8d 83 f0 03 00 00    	lea    0x3f0(%ebx),%eax
    p->pid = nextpid++;
801036b7:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
        if (t->state == UNUSED)
801036bd:	75 10                	jne    801036cf <allocproc+0x8f>
801036bf:	eb 37                	jmp    801036f8 <allocproc+0xb8>
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c8:	8b 56 08             	mov    0x8(%esi),%edx
801036cb:	85 d2                	test   %edx,%edx
801036cd:	74 29                	je     801036f8 <allocproc+0xb8>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801036cf:	83 c6 38             	add    $0x38,%esi
801036d2:	39 f0                	cmp    %esi,%eax
801036d4:	77 f2                	ja     801036c8 <allocproc+0x88>

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->state = UNUSED;
        t->state = UNUSED;
        release(&ptable.lock);
801036d6:	83 ec 0c             	sub    $0xc,%esp
        return 0;
801036d9:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
801036db:	68 60 3d 11 80       	push   $0x80113d60
801036e0:	e8 0b 13 00 00       	call   801049f0 <release>
        return 0;
801036e5:	83 c4 10             	add    $0x10,%esp
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);
//    release(p->procLock);
    return p;
}
801036e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036eb:	89 d8                	mov    %ebx,%eax
801036ed:	5b                   	pop    %ebx
801036ee:	5e                   	pop    %esi
801036ef:	5d                   	pop    %ebp
801036f0:	c3                   	ret    
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    t->state = EMBRYO;
801036f8:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    t->tid = p->tidCounter++;
801036ff:	8b 83 f4 03 00 00    	mov    0x3f4(%ebx),%eax
80103705:	8d 50 01             	lea    0x1(%eax),%edx
80103708:	89 93 f4 03 00 00    	mov    %edx,0x3f4(%ebx)
8010370e:	89 46 0c             	mov    %eax,0xc(%esi)
    p->mainThread = t;
80103711:	89 b3 f0 03 00 00    	mov    %esi,0x3f0(%ebx)
    if ((t->tkstack = kalloc()) == 0) {
80103717:	e8 e4 ed ff ff       	call   80102500 <kalloc>
8010371c:	85 c0                	test   %eax,%eax
8010371e:	89 46 04             	mov    %eax,0x4(%esi)
80103721:	74 47                	je     8010376a <allocproc+0x12a>
    sp -= sizeof *t->tf;
80103723:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(t->context, 0, sizeof *t->context);
80103729:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
8010372c:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
80103731:	89 56 10             	mov    %edx,0x10(%esi)
    *(uint *) sp = (uint) trapret;
80103734:	c7 40 14 52 5c 10 80 	movl   $0x80105c52,0x14(%eax)
    t->context = (struct context *) sp;
8010373b:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
8010373e:	6a 14                	push   $0x14
80103740:	6a 00                	push   $0x0
80103742:	50                   	push   %eax
80103743:	e8 08 13 00 00       	call   80104a50 <memset>
    t->context->eip = (uint) forkret;
80103748:	8b 46 14             	mov    0x14(%esi),%eax
8010374b:	c7 40 10 80 37 10 80 	movl   $0x80103780,0x10(%eax)
    release(&ptable.lock);
80103752:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103759:	e8 92 12 00 00       	call   801049f0 <release>
    return p;
8010375e:	83 c4 10             	add    $0x10,%esp
}
80103761:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103764:	89 d8                	mov    %ebx,%eax
80103766:	5b                   	pop    %ebx
80103767:	5e                   	pop    %esi
80103768:	5d                   	pop    %ebp
80103769:	c3                   	ret    
        p->state = UNUSED;
8010376a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        t->state = UNUSED;
80103771:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
80103778:	e9 59 ff ff ff       	jmp    801036d6 <allocproc+0x96>
8010377d:	8d 76 00             	lea    0x0(%esi),%esi

80103780 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103786:	68 60 3d 11 80       	push   $0x80113d60
8010378b:	e8 60 12 00 00       	call   801049f0 <release>

    if (first) {
80103790:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 c0                	test   %eax,%eax
8010379a:	75 04                	jne    801037a0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
8010379c:	c9                   	leave  
8010379d:	c3                   	ret    
8010379e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
801037a0:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
801037a3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801037aa:	00 00 00 
        iinit(ROOTDEV);
801037ad:	6a 01                	push   $0x1
801037af:	e8 0c dd ff ff       	call   801014c0 <iinit>
        initlog(ROOTDEV);
801037b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037bb:	e8 80 f3 ff ff       	call   80102b40 <initlog>
801037c0:	83 c4 10             	add    $0x10,%esp
}
801037c3:	c9                   	leave  
801037c4:	c3                   	ret    
801037c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <pinit>:
pinit(void) {
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 08             	sub    $0x8,%esp
    if (DEBUGMODE > 0)
801037d6:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
801037db:	85 c0                	test   %eax,%eax
801037dd:	7e 10                	jle    801037ef <pinit+0x1f>
        cprintf(" PINIT ");
801037df:	83 ec 0c             	sub    $0xc,%esp
801037e2:	68 61 7a 10 80       	push   $0x80107a61
801037e7:	e8 74 ce ff ff       	call   80100660 <cprintf>
801037ec:	83 c4 10             	add    $0x10,%esp
    initlock(&ptable.lock, "ptable");
801037ef:	83 ec 08             	sub    $0x8,%esp
801037f2:	68 69 7a 10 80       	push   $0x80107a69
801037f7:	68 60 3d 11 80       	push   $0x80113d60
801037fc:	e8 ef 0f 00 00       	call   801047f0 <initlock>
}
80103801:	83 c4 10             	add    $0x10,%esp
80103804:	c9                   	leave  
80103805:	c3                   	ret    
80103806:	8d 76 00             	lea    0x0(%esi),%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103810 <cleanThread>:
cleanThread(struct thread *t) {
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
80103814:	83 ec 10             	sub    $0x10,%esp
80103817:	8b 5d 08             	mov    0x8(%ebp),%ebx
    kfree(t->tkstack);
8010381a:	ff 73 04             	pushl  0x4(%ebx)
8010381d:	e8 2e eb ff ff       	call   80102350 <kfree>
    t->tkstack = 0;
80103822:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    t->state = UNUSED;
80103829:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
}
80103830:	83 c4 10             	add    $0x10,%esp
    t->tid = 0;
80103833:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    t->name[0] = 0;
8010383a:	c6 43 24 00          	movb   $0x0,0x24(%ebx)
    t->killed = 0;
8010383e:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
}
80103845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103848:	c9                   	leave  
80103849:	c3                   	ret    
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103850 <mycpu>:
mycpu(void) {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	56                   	push   %esi
80103854:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103855:	9c                   	pushf  
80103856:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103857:	f6 c4 02             	test   $0x2,%ah
8010385a:	75 5e                	jne    801038ba <mycpu+0x6a>
    apicid = lapicid();
8010385c:	e8 0f ef ff ff       	call   80102770 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103861:	8b 35 40 3d 11 80    	mov    0x80113d40,%esi
80103867:	85 f6                	test   %esi,%esi
80103869:	7e 42                	jle    801038ad <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010386b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103872:	39 d0                	cmp    %edx,%eax
80103874:	74 30                	je     801038a6 <mycpu+0x56>
80103876:	b9 54 38 11 80       	mov    $0x80113854,%ecx
    for (i = 0; i < ncpu; ++i) {
8010387b:	31 d2                	xor    %edx,%edx
8010387d:	8d 76 00             	lea    0x0(%esi),%esi
80103880:	83 c2 01             	add    $0x1,%edx
80103883:	39 f2                	cmp    %esi,%edx
80103885:	74 26                	je     801038ad <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103887:	0f b6 19             	movzbl (%ecx),%ebx
8010388a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
80103890:	39 c3                	cmp    %eax,%ebx
80103892:	75 ec                	jne    80103880 <mycpu+0x30>
80103894:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
8010389a:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
8010389f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a2:	5b                   	pop    %ebx
801038a3:	5e                   	pop    %esi
801038a4:	5d                   	pop    %ebp
801038a5:	c3                   	ret    
        if (cpus[i].apicid == apicid)
801038a6:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
            return &cpus[i];
801038ab:	eb f2                	jmp    8010389f <mycpu+0x4f>
    panic("unknown apicid\n");
801038ad:	83 ec 0c             	sub    $0xc,%esp
801038b0:	68 70 7a 10 80       	push   $0x80107a70
801038b5:	e8 d6 ca ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	68 f0 7b 10 80       	push   $0x80107bf0
801038c2:	e8 c9 ca ff ff       	call   80100390 <panic>
801038c7:	89 f6                	mov    %esi,%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <cpuid>:
cpuid() {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
801038d6:	e8 75 ff ff ff       	call   80103850 <mycpu>
801038db:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
801038e0:	c9                   	leave  
    return mycpu() - cpus;
801038e1:	c1 f8 02             	sar    $0x2,%eax
801038e4:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
801038ea:	c3                   	ret    
801038eb:	90                   	nop
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <myproc>:
myproc(void) {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801038f7:	e8 64 0f 00 00       	call   80104860 <pushcli>
    c = mycpu();
801038fc:	e8 4f ff ff ff       	call   80103850 <mycpu>
    p = c->proc;
80103901:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103907:	e8 94 0f 00 00       	call   801048a0 <popcli>
}
8010390c:	83 c4 04             	add    $0x4,%esp
8010390f:	89 d8                	mov    %ebx,%eax
80103911:	5b                   	pop    %ebx
80103912:	5d                   	pop    %ebp
80103913:	c3                   	ret    
80103914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010391a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103920 <mythread>:
mythread(void) {
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	53                   	push   %ebx
80103924:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103927:	e8 34 0f 00 00       	call   80104860 <pushcli>
    c = mycpu();
8010392c:	e8 1f ff ff ff       	call   80103850 <mycpu>
    t = c->currThread;
80103931:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103937:	e8 64 0f 00 00       	call   801048a0 <popcli>
}
8010393c:	83 c4 04             	add    $0x4,%esp
8010393f:	89 d8                	mov    %ebx,%eax
80103941:	5b                   	pop    %ebx
80103942:	5d                   	pop    %ebp
80103943:	c3                   	ret    
80103944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010394a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103950 <userinit>:
userinit(void) {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	56                   	push   %esi
80103954:	53                   	push   %ebx
    p = allocproc();
80103955:	e8 e6 fc ff ff       	call   80103640 <allocproc>
8010395a:	89 c3                	mov    %eax,%ebx
    initproc = p;
8010395c:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
    if ((p->pgdir = setupkvm()) == 0)
80103961:	e8 ca 38 00 00       	call   80107230 <setupkvm>
80103966:	85 c0                	test   %eax,%eax
80103968:	89 43 04             	mov    %eax,0x4(%ebx)
8010396b:	0f 84 35 01 00 00    	je     80103aa6 <userinit+0x156>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103971:	83 ec 04             	sub    $0x4,%esp
80103974:	68 2c 00 00 00       	push   $0x2c
80103979:	68 60 b4 10 80       	push   $0x8010b460
8010397e:	50                   	push   %eax
8010397f:	e8 8c 35 00 00       	call   80106f10 <inituvm>
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
80103984:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103987:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
8010398d:	6a 4c                	push   $0x4c
8010398f:	6a 00                	push   $0x0
80103991:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103997:	ff 70 10             	pushl  0x10(%eax)
8010399a:	e8 b1 10 00 00       	call   80104a50 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010399f:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039a5:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039aa:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
801039af:	83 c4 0c             	add    $0xc,%esp
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039b2:	8b 40 10             	mov    0x10(%eax),%eax
801039b5:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039b9:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039bf:	8b 40 10             	mov    0x10(%eax),%eax
801039c2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
801039c6:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039cc:	8b 40 10             	mov    0x10(%eax),%eax
801039cf:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039d3:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
801039d7:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039dd:	8b 40 10             	mov    0x10(%eax),%eax
801039e0:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039e4:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
801039e8:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039ee:	8b 40 10             	mov    0x10(%eax),%eax
801039f1:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
801039f8:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
801039fe:	8b 40 10             	mov    0x10(%eax),%eax
80103a01:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
80103a08:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103a0e:	8b 40 10             	mov    0x10(%eax),%eax
80103a11:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103a18:	8d 43 60             	lea    0x60(%ebx),%eax
80103a1b:	6a 10                	push   $0x10
80103a1d:	68 99 7a 10 80       	push   $0x80107a99
80103a22:	50                   	push   %eax
80103a23:	e8 08 12 00 00       	call   80104c30 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
80103a28:	83 c4 0c             	add    $0xc,%esp
80103a2b:	6a 10                	push   $0x10
80103a2d:	68 a2 7a 10 80       	push   $0x80107aa2
80103a32:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103a38:	83 c0 24             	add    $0x24,%eax
80103a3b:	50                   	push   %eax
80103a3c:	e8 ef 11 00 00       	call   80104c30 <safestrcpy>
    p->mainThread->cwd = namei("/");
80103a41:	8b b3 f0 03 00 00    	mov    0x3f0(%ebx),%esi
80103a47:	c7 04 24 ad 7a 10 80 	movl   $0x80107aad,(%esp)
80103a4e:	e8 cd e4 ff ff       	call   80101f20 <namei>
80103a53:	89 46 20             	mov    %eax,0x20(%esi)
    acquire(&ptable.lock);
80103a56:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103a5d:	e8 ce 0e 00 00       	call   80104930 <acquire>
    p->mainThread->state = RUNNABLE;
80103a62:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
    p->state = RUNNABLE;
80103a68:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103a6f:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103a76:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103a7d:	e8 6e 0f 00 00       	call   801049f0 <release>
    if (DEBUGMODE > 0)
80103a82:	8b 1d b8 b5 10 80    	mov    0x8010b5b8,%ebx
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	85 db                	test   %ebx,%ebx
80103a8d:	7e 10                	jle    80103a9f <userinit+0x14f>
        cprintf("DONE USERINIT");
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	68 af 7a 10 80       	push   $0x80107aaf
80103a97:	e8 c4 cb ff ff       	call   80100660 <cprintf>
80103a9c:	83 c4 10             	add    $0x10,%esp
}
80103a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aa2:	5b                   	pop    %ebx
80103aa3:	5e                   	pop    %esi
80103aa4:	5d                   	pop    %ebp
80103aa5:	c3                   	ret    
        panic("userinit: out of memory?");
80103aa6:	83 ec 0c             	sub    $0xc,%esp
80103aa9:	68 80 7a 10 80       	push   $0x80107a80
80103aae:	e8 dd c8 ff ff       	call   80100390 <panic>
80103ab3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <growproc>:
growproc(int n) {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103ac8:	e8 93 0d 00 00       	call   80104860 <pushcli>
    c = mycpu();
80103acd:	e8 7e fd ff ff       	call   80103850 <mycpu>
    p = c->proc;
80103ad2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ad8:	e8 c3 0d 00 00       	call   801048a0 <popcli>
    if (DEBUGMODE > 0)
80103add:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	7e 10                	jle    80103af6 <growproc+0x36>
        cprintf(" GROWPROC APPLYED ");
80103ae6:	83 ec 0c             	sub    $0xc,%esp
80103ae9:	68 bd 7a 10 80       	push   $0x80107abd
80103aee:	e8 6d cb ff ff       	call   80100660 <cprintf>
80103af3:	83 c4 10             	add    $0x10,%esp
    if (n > 0) {
80103af6:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103af9:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103afb:	7f 23                	jg     80103b20 <growproc+0x60>
    } else if (n < 0) {
80103afd:	75 41                	jne    80103b40 <growproc+0x80>
    switchuvm(curproc);
80103aff:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103b02:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103b04:	53                   	push   %ebx
80103b05:	e8 e6 32 00 00       	call   80106df0 <switchuvm>
    return 0;
80103b0a:	83 c4 10             	add    $0x10,%esp
80103b0d:	31 c0                	xor    %eax,%eax
}
80103b0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b12:	5b                   	pop    %ebx
80103b13:	5e                   	pop    %esi
80103b14:	5d                   	pop    %ebp
80103b15:	c3                   	ret    
80103b16:	8d 76 00             	lea    0x0(%esi),%esi
80103b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	pushl  0x4(%ebx)
80103b2a:	e8 21 35 00 00       	call   80107050 <allocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 c9                	jne    80103aff <growproc+0x3f>
            return -1;
80103b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3b:	eb d2                	jmp    80103b0f <growproc+0x4f>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	pushl  0x4(%ebx)
80103b4a:	e8 31 36 00 00       	call   80107180 <deallocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 a9                	jne    80103aff <growproc+0x3f>
80103b56:	eb de                	jmp    80103b36 <growproc+0x76>
80103b58:	90                   	nop
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b60 <fork>:
fork(void) {
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	57                   	push   %edi
80103b64:	56                   	push   %esi
80103b65:	53                   	push   %ebx
80103b66:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103b69:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103b6e:	85 c0                	test   %eax,%eax
80103b70:	7e 10                	jle    80103b82 <fork+0x22>
        cprintf(" FORK ");
80103b72:	83 ec 0c             	sub    $0xc,%esp
80103b75:	68 d0 7a 10 80       	push   $0x80107ad0
80103b7a:	e8 e1 ca ff ff       	call   80100660 <cprintf>
80103b7f:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103b82:	e8 d9 0c 00 00       	call   80104860 <pushcli>
    c = mycpu();
80103b87:	e8 c4 fc ff ff       	call   80103850 <mycpu>
    p = c->proc;
80103b8c:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
80103b92:	89 7d e0             	mov    %edi,-0x20(%ebp)
    popcli();
80103b95:	e8 06 0d 00 00       	call   801048a0 <popcli>
    pushcli();
80103b9a:	e8 c1 0c 00 00       	call   80104860 <pushcli>
    c = mycpu();
80103b9f:	e8 ac fc ff ff       	call   80103850 <mycpu>
    t = c->currThread;
80103ba4:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103baa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103bad:	e8 ee 0c 00 00       	call   801048a0 <popcli>
    if ((np = allocproc()) == 0) {
80103bb2:	e8 89 fa ff ff       	call   80103640 <allocproc>
80103bb7:	85 c0                	test   %eax,%eax
80103bb9:	89 c3                	mov    %eax,%ebx
80103bbb:	0f 84 f7 00 00 00    	je     80103cb8 <fork+0x158>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103bc1:	83 ec 08             	sub    $0x8,%esp
80103bc4:	ff 37                	pushl  (%edi)
80103bc6:	ff 77 04             	pushl  0x4(%edi)
80103bc9:	e8 32 37 00 00       	call   80107300 <copyuvm>
80103bce:	83 c4 10             	add    $0x10,%esp
80103bd1:	85 c0                	test   %eax,%eax
80103bd3:	89 43 04             	mov    %eax,0x4(%ebx)
80103bd6:	0f 84 e3 00 00 00    	je     80103cbf <fork+0x15f>
    np->sz = curproc->sz;
80103bdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
    *np->mainThread->tf = *curthread->tf;
80103bdf:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103be4:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103be6:	89 53 10             	mov    %edx,0x10(%ebx)
    np->sz = curproc->sz;
80103be9:	89 03                	mov    %eax,(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bee:	8b 70 10             	mov    0x10(%eax),%esi
80103bf1:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103bf7:	8b 40 10             	mov    0x10(%eax),%eax
80103bfa:	89 c7                	mov    %eax,%edi
80103bfc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103bfe:	31 f6                	xor    %esi,%esi
80103c00:	89 d7                	mov    %edx,%edi
    np->mainThread->tf->eax = 0;
80103c02:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103c08:	8b 40 10             	mov    0x10(%eax),%eax
80103c0b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (curproc->ofile[i])
80103c18:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	74 10                	je     80103c30 <fork+0xd0>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	50                   	push   %eax
80103c24:	e8 f7 d1 ff ff       	call   80100e20 <filedup>
80103c29:	83 c4 10             	add    $0x10,%esp
80103c2c:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103c30:	83 c6 01             	add    $0x1,%esi
80103c33:	83 fe 10             	cmp    $0x10,%esi
80103c36:	75 e0                	jne    80103c18 <fork+0xb8>
    np->mainThread->cwd = idup(curthread->cwd);
80103c38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103c3b:	8b b3 f0 03 00 00    	mov    0x3f0(%ebx),%esi
80103c41:	83 ec 0c             	sub    $0xc,%esp
80103c44:	ff 77 20             	pushl  0x20(%edi)
80103c47:	e8 44 da ff ff       	call   80101690 <idup>
80103c4c:	89 46 20             	mov    %eax,0x20(%esi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103c52:	83 c4 0c             	add    $0xc,%esp
80103c55:	6a 10                	push   $0x10
80103c57:	83 c0 60             	add    $0x60,%eax
80103c5a:	50                   	push   %eax
80103c5b:	8d 43 60             	lea    0x60(%ebx),%eax
80103c5e:	50                   	push   %eax
80103c5f:	e8 cc 0f 00 00       	call   80104c30 <safestrcpy>
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103c64:	8d 47 24             	lea    0x24(%edi),%eax
80103c67:	83 c4 0c             	add    $0xc,%esp
80103c6a:	6a 10                	push   $0x10
80103c6c:	50                   	push   %eax
80103c6d:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103c73:	83 c0 24             	add    $0x24,%eax
80103c76:	50                   	push   %eax
80103c77:	e8 b4 0f 00 00       	call   80104c30 <safestrcpy>
    pid = np->pid;
80103c7c:	8b 73 0c             	mov    0xc(%ebx),%esi
    acquire(&ptable.lock);
80103c7f:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103c86:	e8 a5 0c 00 00       	call   80104930 <acquire>
    np->mainThread->state = RUNNABLE;
80103c8b:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
    np->state = RUNNABLE;
80103c91:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    np->mainThread->state = RUNNABLE;
80103c98:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103c9f:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103ca6:	e8 45 0d 00 00       	call   801049f0 <release>
    return pid;
80103cab:	83 c4 10             	add    $0x10,%esp
}
80103cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cb1:	89 f0                	mov    %esi,%eax
80103cb3:	5b                   	pop    %ebx
80103cb4:	5e                   	pop    %esi
80103cb5:	5f                   	pop    %edi
80103cb6:	5d                   	pop    %ebp
80103cb7:	c3                   	ret    
        return -1;
80103cb8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103cbd:	eb ef                	jmp    80103cae <fork+0x14e>
        kfree(np->mainThread->tkstack);
80103cbf:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80103cc5:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103cc8:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->mainThread->tkstack);
80103ccd:	ff 70 04             	pushl  0x4(%eax)
80103cd0:	e8 7b e6 ff ff       	call   80102350 <kfree>
        np->mainThread->tkstack = 0;
80103cd5:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
        return -1;
80103cdb:	83 c4 10             	add    $0x10,%esp
        np->mainThread->tkstack = 0;
80103cde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->mainThread->state = UNUSED;
80103ce5:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
        np->state = UNUSED;
80103ceb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103cf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103cf9:	eb b3                	jmp    80103cae <fork+0x14e>
80103cfb:	90                   	nop
80103cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d00 <scheduler>:
scheduler(void) {
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103d09:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103d0e:	85 c0                	test   %eax,%eax
80103d10:	7e 10                	jle    80103d22 <scheduler+0x22>
        cprintf(" SCHEDULER ");
80103d12:	83 ec 0c             	sub    $0xc,%esp
80103d15:	68 d7 7a 10 80       	push   $0x80107ad7
80103d1a:	e8 41 c9 ff ff       	call   80100660 <cprintf>
80103d1f:	83 c4 10             	add    $0x10,%esp
    struct cpu *c = mycpu();
80103d22:	e8 29 fb ff ff       	call   80103850 <mycpu>
    c->proc = 0;
80103d27:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d2e:	00 00 00 
    struct cpu *c = mycpu();
80103d31:	89 c6                	mov    %eax,%esi
80103d33:	8d 40 04             	lea    0x4(%eax),%eax
80103d36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103d40:	fb                   	sti    
        acquire(&ptable.lock);
80103d41:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d44:	bf 94 3d 11 80       	mov    $0x80113d94,%edi
        acquire(&ptable.lock);
80103d49:	68 60 3d 11 80       	push   $0x80113d60
80103d4e:	e8 dd 0b 00 00       	call   80104930 <acquire>
80103d53:	83 c4 10             	add    $0x10,%esp
80103d56:	eb 16                	jmp    80103d6e <scheduler+0x6e>
80103d58:	90                   	nop
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d60:	81 c7 fc 03 00 00    	add    $0x3fc,%edi
80103d66:	81 ff 94 3c 12 80    	cmp    $0x80123c94,%edi
80103d6c:	73 7a                	jae    80103de8 <scheduler+0xe8>
            if (p->state != RUNNABLE)
80103d6e:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d72:	75 ec                	jne    80103d60 <scheduler+0x60>
            switchuvm(p);
80103d74:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80103d77:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
80103d7d:	8d 5f 70             	lea    0x70(%edi),%ebx
            switchuvm(p);
80103d80:	57                   	push   %edi
80103d81:	e8 6a 30 00 00       	call   80106df0 <switchuvm>
80103d86:	8d 97 f0 03 00 00    	lea    0x3f0(%edi),%edx
80103d8c:	83 c4 10             	add    $0x10,%esp
80103d8f:	90                   	nop
                if (t->state != RUNNABLE)
80103d90:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103d94:	75 29                	jne    80103dbf <scheduler+0xbf>
                swtch(&(c->scheduler), t->context);
80103d96:	83 ec 08             	sub    $0x8,%esp
                t->state = RUNNING;
80103d99:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)
                c->currThread = t;
80103da0:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)
                swtch(&(c->scheduler), t->context);
80103da6:	ff 73 14             	pushl  0x14(%ebx)
80103da9:	ff 75 e0             	pushl  -0x20(%ebp)
80103dac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103daf:	e8 d7 0e 00 00       	call   80104c8b <swtch>
                switchkvm();
80103db4:	e8 17 30 00 00       	call   80106dd0 <switchkvm>
80103db9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dbc:	83 c4 10             	add    $0x10,%esp
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103dbf:	83 c3 38             	add    $0x38,%ebx
80103dc2:	39 da                	cmp    %ebx,%edx
80103dc4:	77 ca                	ja     80103d90 <scheduler+0x90>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dc6:	81 c7 fc 03 00 00    	add    $0x3fc,%edi
            c->proc = 0;
80103dcc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103dd3:	00 00 00 
            c->currThread = 0;
80103dd6:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103ddd:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103de0:	81 ff 94 3c 12 80    	cmp    $0x80123c94,%edi
80103de6:	72 86                	jb     80103d6e <scheduler+0x6e>
        release(&ptable.lock);
80103de8:	83 ec 0c             	sub    $0xc,%esp
80103deb:	68 60 3d 11 80       	push   $0x80113d60
80103df0:	e8 fb 0b 00 00       	call   801049f0 <release>
        sti();
80103df5:	83 c4 10             	add    $0x10,%esp
80103df8:	e9 43 ff ff ff       	jmp    80103d40 <scheduler+0x40>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi

80103e00 <sched>:
    if (DEBUGMODE > 1)
80103e00:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
sched(void) {
80103e07:	55                   	push   %ebp
80103e08:	89 e5                	mov    %esp,%ebp
80103e0a:	56                   	push   %esi
80103e0b:	53                   	push   %ebx
    if (DEBUGMODE > 1)
80103e0c:	7e 10                	jle    80103e1e <sched+0x1e>
        cprintf(" SCHED ");
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	68 e3 7a 10 80       	push   $0x80107ae3
80103e16:	e8 45 c8 ff ff       	call   80100660 <cprintf>
80103e1b:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103e1e:	e8 3d 0a 00 00       	call   80104860 <pushcli>
    c = mycpu();
80103e23:	e8 28 fa ff ff       	call   80103850 <mycpu>
    t = c->currThread;
80103e28:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103e2e:	e8 6d 0a 00 00       	call   801048a0 <popcli>
    if (!holding(&ptable.lock))
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	68 60 3d 11 80       	push   $0x80113d60
80103e3b:	e8 c0 0a 00 00       	call   80104900 <holding>
80103e40:	83 c4 10             	add    $0x10,%esp
80103e43:	85 c0                	test   %eax,%eax
80103e45:	74 4f                	je     80103e96 <sched+0x96>
    if (mycpu()->ncli != 1)
80103e47:	e8 04 fa ff ff       	call   80103850 <mycpu>
80103e4c:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e53:	75 68                	jne    80103ebd <sched+0xbd>
    if (t->state == RUNNING)
80103e55:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103e59:	74 55                	je     80103eb0 <sched+0xb0>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e5b:	9c                   	pushf  
80103e5c:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103e5d:	f6 c4 02             	test   $0x2,%ah
80103e60:	75 41                	jne    80103ea3 <sched+0xa3>
    intena = mycpu()->intena;
80103e62:	e8 e9 f9 ff ff       	call   80103850 <mycpu>
    swtch(&t->context, mycpu()->scheduler);
80103e67:	83 c3 14             	add    $0x14,%ebx
    intena = mycpu()->intena;
80103e6a:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&t->context, mycpu()->scheduler);
80103e70:	e8 db f9 ff ff       	call   80103850 <mycpu>
80103e75:	83 ec 08             	sub    $0x8,%esp
80103e78:	ff 70 04             	pushl  0x4(%eax)
80103e7b:	53                   	push   %ebx
80103e7c:	e8 0a 0e 00 00       	call   80104c8b <swtch>
    mycpu()->intena = intena;
80103e81:	e8 ca f9 ff ff       	call   80103850 <mycpu>
}
80103e86:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80103e89:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e92:	5b                   	pop    %ebx
80103e93:	5e                   	pop    %esi
80103e94:	5d                   	pop    %ebp
80103e95:	c3                   	ret    
        panic("sched ptable.lock");
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	68 eb 7a 10 80       	push   $0x80107aeb
80103e9e:	e8 ed c4 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
80103ea3:	83 ec 0c             	sub    $0xc,%esp
80103ea6:	68 17 7b 10 80       	push   $0x80107b17
80103eab:	e8 e0 c4 ff ff       	call   80100390 <panic>
        panic("sched running");
80103eb0:	83 ec 0c             	sub    $0xc,%esp
80103eb3:	68 09 7b 10 80       	push   $0x80107b09
80103eb8:	e8 d3 c4 ff ff       	call   80100390 <panic>
        panic("sched locks");
80103ebd:	83 ec 0c             	sub    $0xc,%esp
80103ec0:	68 fd 7a 10 80       	push   $0x80107afd
80103ec5:	e8 c6 c4 ff ff       	call   80100390 <panic>
80103eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ed0 <yield>:
yield(void) {
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
80103ed4:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103ed7:	68 60 3d 11 80       	push   $0x80113d60
80103edc:	e8 4f 0a 00 00       	call   80104930 <acquire>
    pushcli();
80103ee1:	e8 7a 09 00 00       	call   80104860 <pushcli>
    c = mycpu();
80103ee6:	e8 65 f9 ff ff       	call   80103850 <mycpu>
    t = c->currThread;
80103eeb:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103ef1:	e8 aa 09 00 00       	call   801048a0 <popcli>
    mythread()->state = RUNNABLE;
80103ef6:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103efd:	e8 fe fe ff ff       	call   80103e00 <sched>
    release(&ptable.lock);
80103f02:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103f09:	e8 e2 0a 00 00       	call   801049f0 <release>
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
    if (DEBUGMODE > 1)
80103f29:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
sleep(void *chan, struct spinlock *lk) {
80103f30:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (DEBUGMODE > 1)
80103f36:	7e 10                	jle    80103f48 <sleep+0x28>
        cprintf(" SLEEP ");
80103f38:	83 ec 0c             	sub    $0xc,%esp
80103f3b:	68 2b 7b 10 80       	push   $0x80107b2b
80103f40:	e8 1b c7 ff ff       	call   80100660 <cprintf>
80103f45:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103f48:	e8 13 09 00 00       	call   80104860 <pushcli>
    c = mycpu();
80103f4d:	e8 fe f8 ff ff       	call   80103850 <mycpu>
    p = c->proc;
80103f52:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103f58:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103f5b:	e8 40 09 00 00       	call   801048a0 <popcli>
    pushcli();
80103f60:	e8 fb 08 00 00       	call   80104860 <pushcli>
    c = mycpu();
80103f65:	e8 e6 f8 ff ff       	call   80103850 <mycpu>
    t = c->currThread;
80103f6a:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103f70:	e8 2b 09 00 00       	call   801048a0 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103f75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f78:	85 d2                	test   %edx,%edx
80103f7a:	0f 84 83 00 00 00    	je     80104003 <sleep+0xe3>
        panic("sleep");

    if (lk == 0)
80103f80:	85 db                	test   %ebx,%ebx
80103f82:	74 72                	je     80103ff6 <sleep+0xd6>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {
80103f84:	81 fb 60 3d 11 80    	cmp    $0x80113d60,%ebx
80103f8a:	74 4c                	je     80103fd8 <sleep+0xb8>
        acquire(&ptable.lock);
80103f8c:	83 ec 0c             	sub    $0xc,%esp
80103f8f:	68 60 3d 11 80       	push   $0x80113d60
80103f94:	e8 97 09 00 00       	call   80104930 <acquire>
        release(lk);
80103f99:	89 1c 24             	mov    %ebx,(%esp)
80103f9c:	e8 4f 0a 00 00       	call   801049f0 <release>
    }
    // Go to sleep.
    t->chan = chan;
80103fa1:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103fa4:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103fab:	e8 50 fe ff ff       	call   80103e00 <sched>

    // Tidy up.
    t->chan = 0;
80103fb0:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80103fb7:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103fbe:	e8 2d 0a 00 00       	call   801049f0 <release>
        acquire(lk);
80103fc3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103fc6:	83 c4 10             	add    $0x10,%esp
    }
}
80103fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fcc:	5b                   	pop    %ebx
80103fcd:	5e                   	pop    %esi
80103fce:	5f                   	pop    %edi
80103fcf:	5d                   	pop    %ebp
        acquire(lk);
80103fd0:	e9 5b 09 00 00       	jmp    80104930 <acquire>
80103fd5:	8d 76 00             	lea    0x0(%esi),%esi
    t->chan = chan;
80103fd8:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103fdb:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)
    sched();
80103fe2:	e8 19 fe ff ff       	call   80103e00 <sched>
    t->chan = 0;
80103fe7:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
}
80103fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ff1:	5b                   	pop    %ebx
80103ff2:	5e                   	pop    %esi
80103ff3:	5f                   	pop    %edi
80103ff4:	5d                   	pop    %ebp
80103ff5:	c3                   	ret    
        panic("sleep without lk");
80103ff6:	83 ec 0c             	sub    $0xc,%esp
80103ff9:	68 39 7b 10 80       	push   $0x80107b39
80103ffe:	e8 8d c3 ff ff       	call   80100390 <panic>
        panic("sleep");
80104003:	83 ec 0c             	sub    $0xc,%esp
80104006:	68 33 7b 10 80       	push   $0x80107b33
8010400b:	e8 80 c3 ff ff       	call   80100390 <panic>

80104010 <cleanProcOneThread>:
cleanProcOneThread(struct thread *curthread, struct proc *p) {
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	57                   	push   %edi
80104014:	56                   	push   %esi
80104015:	53                   	push   %ebx
80104016:	83 ec 18             	sub    $0x18,%esp
80104019:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010401c:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&ptable.lock);
8010401f:	68 60 3d 11 80       	push   $0x80113d60
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104024:	8d 5f 70             	lea    0x70(%edi),%ebx
80104027:	81 c7 f0 03 00 00    	add    $0x3f0,%edi
    acquire(&ptable.lock);
8010402d:	e8 fe 08 00 00       	call   80104930 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104032:	83 c4 10             	add    $0x10,%esp
80104035:	eb 10                	jmp    80104047 <cleanProcOneThread+0x37>
80104037:	89 f6                	mov    %esi,%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104040:	83 c3 38             	add    $0x38,%ebx
80104043:	39 fb                	cmp    %edi,%ebx
80104045:	73 49                	jae    80104090 <cleanProcOneThread+0x80>
        if (t != curthread) {
80104047:	39 de                	cmp    %ebx,%esi
80104049:	74 f5                	je     80104040 <cleanProcOneThread+0x30>
            if (t->state == RUNNING)
8010404b:	8b 43 08             	mov    0x8(%ebx),%eax
8010404e:	83 f8 04             	cmp    $0x4,%eax
80104051:	74 55                	je     801040a8 <cleanProcOneThread+0x98>
            if (t->state == RUNNING || t->state == RUNNABLE) {
80104053:	83 e8 03             	sub    $0x3,%eax
80104056:	83 f8 01             	cmp    $0x1,%eax
80104059:	77 e5                	ja     80104040 <cleanProcOneThread+0x30>
    kfree(t->tkstack);
8010405b:	83 ec 0c             	sub    $0xc,%esp
8010405e:	ff 73 04             	pushl  0x4(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104061:	83 c3 38             	add    $0x38,%ebx
    kfree(t->tkstack);
80104064:	e8 e7 e2 ff ff       	call   80102350 <kfree>
    t->tkstack = 0;
80104069:	c7 43 cc 00 00 00 00 	movl   $0x0,-0x34(%ebx)
    t->state = UNUSED;
80104070:	c7 43 d0 00 00 00 00 	movl   $0x0,-0x30(%ebx)
    t->killed = 0;
80104077:	83 c4 10             	add    $0x10,%esp
    t->tid = 0;
8010407a:	c7 43 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebx)
    t->name[0] = 0;
80104081:	c6 43 ec 00          	movb   $0x0,-0x14(%ebx)
    t->killed = 0;
80104085:	c7 43 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010408c:	39 fb                	cmp    %edi,%ebx
8010408e:	72 b7                	jb     80104047 <cleanProcOneThread+0x37>
    release(&ptable.lock);
80104090:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
80104097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010409a:	5b                   	pop    %ebx
8010409b:	5e                   	pop    %esi
8010409c:	5f                   	pop    %edi
8010409d:	5d                   	pop    %ebp
    release(&ptable.lock);
8010409e:	e9 4d 09 00 00       	jmp    801049f0 <release>
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                sleep(t, &ptable.lock);
801040a8:	83 ec 08             	sub    $0x8,%esp
801040ab:	68 60 3d 11 80       	push   $0x80113d60
801040b0:	53                   	push   %ebx
801040b1:	e8 6a fe ff ff       	call   80103f20 <sleep>
801040b6:	8b 43 08             	mov    0x8(%ebx),%eax
801040b9:	83 c4 10             	add    $0x10,%esp
801040bc:	eb 95                	jmp    80104053 <cleanProcOneThread+0x43>
801040be:	66 90                	xchg   %ax,%ax

801040c0 <exit>:
exit(void) {
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
801040c9:	e8 92 07 00 00       	call   80104860 <pushcli>
    c = mycpu();
801040ce:	e8 7d f7 ff ff       	call   80103850 <mycpu>
    p = c->proc;
801040d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801040d9:	e8 c2 07 00 00       	call   801048a0 <popcli>
    pushcli();
801040de:	e8 7d 07 00 00       	call   80104860 <pushcli>
    c = mycpu();
801040e3:	e8 68 f7 ff ff       	call   80103850 <mycpu>
    t = c->currThread;
801040e8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801040ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
801040f1:	e8 aa 07 00 00       	call   801048a0 <popcli>
        cprintf("EXIT");
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	68 4a 7b 10 80       	push   $0x80107b4a
801040fe:	e8 5d c5 ff ff       	call   80100660 <cprintf>
    if (curproc == initproc)
80104103:	83 c4 10             	add    $0x10,%esp
80104106:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
8010410c:	0f 84 cd 01 00 00    	je     801042df <exit+0x21f>
   cprintf(" BEFORE cleanProcOneThread\n");
80104112:	83 ec 0c             	sub    $0xc,%esp
80104115:	8d 5e 60             	lea    0x60(%esi),%ebx
80104118:	68 5c 7b 10 80       	push   $0x80107b5c
8010411d:	e8 3e c5 ff ff       	call   80100660 <cprintf>
    cleanProcOneThread(curthread, curproc);
80104122:	8b 7d e0             	mov    -0x20(%ebp),%edi
80104125:	58                   	pop    %eax
80104126:	5a                   	pop    %edx
80104127:	56                   	push   %esi
80104128:	57                   	push   %edi
80104129:	e8 e2 fe ff ff       	call   80104010 <cleanProcOneThread>
   cprintf(" AFTER cleanProcOneThread\n");
8010412e:	c7 04 24 78 7b 10 80 	movl   $0x80107b78,(%esp)
80104135:	e8 26 c5 ff ff       	call   80100660 <cprintf>
    acquire(&ptable.lock);
8010413a:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80104141:	e8 ea 07 00 00       	call   80104930 <acquire>
    curproc->mainThread = curthread;
80104146:	89 be f0 03 00 00    	mov    %edi,0x3f0(%esi)
8010414c:	8d 7e 20             	lea    0x20(%esi),%edi
8010414f:	83 c4 10             	add    $0x10,%esp
80104152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (curproc->ofile[fd]) {
80104158:	8b 07                	mov    (%edi),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	74 12                	je     80104170 <exit+0xb0>
            fileclose(curproc->ofile[fd]);
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	50                   	push   %eax
80104162:	e8 09 cd ff ff       	call   80100e70 <fileclose>
            curproc->ofile[fd] = 0;
80104167:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	83 c7 04             	add    $0x4,%edi
    for (fd = 0; fd < NOFILE; fd++) {
80104173:	39 df                	cmp    %ebx,%edi
80104175:	75 e1                	jne    80104158 <exit+0x98>
    if (holding(&ptable.lock))
80104177:	83 ec 0c             	sub    $0xc,%esp
8010417a:	68 60 3d 11 80       	push   $0x80113d60
8010417f:	e8 7c 07 00 00       	call   80104900 <holding>
80104184:	83 c4 10             	add    $0x10,%esp
80104187:	85 c0                	test   %eax,%eax
80104189:	0f 85 3b 01 00 00    	jne    801042ca <exit+0x20a>
    begin_op();
8010418f:	e8 4c ea ff ff       	call   80102be0 <begin_op>
    iput(curthread->cwd);
80104194:	8b 7d e0             	mov    -0x20(%ebp),%edi
80104197:	83 ec 0c             	sub    $0xc,%esp
8010419a:	ff 77 20             	pushl  0x20(%edi)
8010419d:	e8 4e d6 ff ff       	call   801017f0 <iput>
    end_op();
801041a2:	e8 a9 ea ff ff       	call   80102c50 <end_op>
    curthread->cwd = 0;
801041a7:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)
    acquire(&ptable.lock);
801041ae:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801041b5:	e8 76 07 00 00       	call   80104930 <acquire>
    wakeup1(curproc->parent->mainThread);
801041ba:	8b 46 10             	mov    0x10(%esi),%eax
801041bd:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041c0:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
    wakeup1(curproc->parent->mainThread);
801041c5:	8b 98 f0 03 00 00    	mov    0x3f0(%eax),%ebx
801041cb:	eb 11                	jmp    801041de <exit+0x11e>
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041d0:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
801041d6:	81 fa 94 3c 12 80    	cmp    $0x80123c94,%edx
801041dc:	73 2d                	jae    8010420b <exit+0x14b>
        if (p->state != RUNNABLE)
801041de:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801041e2:	75 ec                	jne    801041d0 <exit+0x110>
801041e4:	8d 42 70             	lea    0x70(%edx),%eax
801041e7:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
801041ed:	eb 08                	jmp    801041f7 <exit+0x137>
801041ef:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801041f0:	83 c0 38             	add    $0x38,%eax
801041f3:	39 c8                	cmp    %ecx,%eax
801041f5:	73 d9                	jae    801041d0 <exit+0x110>
            if (t->state == SLEEPING && t->chan == chan)
801041f7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801041fb:	75 f3                	jne    801041f0 <exit+0x130>
801041fd:	3b 58 18             	cmp    0x18(%eax),%ebx
80104200:	75 ee                	jne    801041f0 <exit+0x130>
                t->state = RUNNABLE;
80104202:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104209:	eb e5                	jmp    801041f0 <exit+0x130>
    cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");
8010420b:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010420e:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
    cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");
80104213:	68 18 7c 10 80       	push   $0x80107c18
80104218:	e8 43 c4 ff ff       	call   80100660 <cprintf>
            p->parent = initproc;
8010421d:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80104222:	83 c4 10             	add    $0x10,%esp
80104225:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104228:	eb 14                	jmp    8010423e <exit+0x17e>
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104230:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
80104236:	81 fb 94 3c 12 80    	cmp    $0x80123c94,%ebx
8010423c:	73 5d                	jae    8010429b <exit+0x1db>
        if (p->parent == curproc) {
8010423e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104241:	75 ed                	jne    80104230 <exit+0x170>
            if (p->state == ZOMBIE)
80104243:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
            p->parent = initproc;
80104247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010424a:	89 43 10             	mov    %eax,0x10(%ebx)
            if (p->state == ZOMBIE)
8010424d:	75 e1                	jne    80104230 <exit+0x170>
                wakeup1(initproc->mainThread);
8010424f:	8b b8 f0 03 00 00    	mov    0x3f0(%eax),%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104255:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
8010425a:	eb 12                	jmp    8010426e <exit+0x1ae>
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104260:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
80104266:	81 fa 94 3c 12 80    	cmp    $0x80123c94,%edx
8010426c:	73 c2                	jae    80104230 <exit+0x170>
        if (p->state != RUNNABLE)
8010426e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104272:	75 ec                	jne    80104260 <exit+0x1a0>
80104274:	8d 42 70             	lea    0x70(%edx),%eax
80104277:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
8010427d:	eb 08                	jmp    80104287 <exit+0x1c7>
8010427f:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104280:	83 c0 38             	add    $0x38,%eax
80104283:	39 c1                	cmp    %eax,%ecx
80104285:	76 d9                	jbe    80104260 <exit+0x1a0>
            if (t->state == SLEEPING && t->chan == chan)
80104287:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010428b:	75 f3                	jne    80104280 <exit+0x1c0>
8010428d:	3b 78 18             	cmp    0x18(%eax),%edi
80104290:	75 ee                	jne    80104280 <exit+0x1c0>
                t->state = RUNNABLE;
80104292:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104299:	eb e5                	jmp    80104280 <exit+0x1c0>
    cprintf(" AFTER Pass abandoned children to init.\n");
8010429b:	83 ec 0c             	sub    $0xc,%esp
8010429e:	68 48 7c 10 80       	push   $0x80107c48
801042a3:	e8 b8 c3 ff ff       	call   80100660 <cprintf>
    curthread->state = ZOMBIE;
801042a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ab:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    curproc->state = ZOMBIE;
801042b2:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
801042b9:	e8 42 fb ff ff       	call   80103e00 <sched>
    panic("zombie exit");
801042be:	c7 04 24 93 7b 10 80 	movl   $0x80107b93,(%esp)
801042c5:	e8 c6 c0 ff ff       	call   80100390 <panic>
        release(&ptable.lock);
801042ca:	83 ec 0c             	sub    $0xc,%esp
801042cd:	68 60 3d 11 80       	push   $0x80113d60
801042d2:	e8 19 07 00 00       	call   801049f0 <release>
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	e9 b0 fe ff ff       	jmp    8010418f <exit+0xcf>
        panic("init exiting");
801042df:	83 ec 0c             	sub    $0xc,%esp
801042e2:	68 4f 7b 10 80       	push   $0x80107b4f
801042e7:	e8 a4 c0 ff ff       	call   80100390 <panic>
801042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042f0 <wait>:
wait(void) {
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
801042f9:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
80104300:	7e 10                	jle    80104312 <wait+0x22>
        cprintf(" WAIT ");
80104302:	83 ec 0c             	sub    $0xc,%esp
80104305:	68 9f 7b 10 80       	push   $0x80107b9f
8010430a:	e8 51 c3 ff ff       	call   80100660 <cprintf>
8010430f:	83 c4 10             	add    $0x10,%esp
    pushcli();
80104312:	e8 49 05 00 00       	call   80104860 <pushcli>
    c = mycpu();
80104317:	e8 34 f5 ff ff       	call   80103850 <mycpu>
    p = c->proc;
8010431c:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104322:	e8 79 05 00 00       	call   801048a0 <popcli>
    acquire(&ptable.lock);
80104327:	83 ec 0c             	sub    $0xc,%esp
8010432a:	68 60 3d 11 80       	push   $0x80113d60
8010432f:	e8 fc 05 00 00       	call   80104930 <acquire>
80104334:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
80104337:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104339:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
8010433e:	eb 0e                	jmp    8010434e <wait+0x5e>
80104340:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
80104346:	81 fb 94 3c 12 80    	cmp    $0x80123c94,%ebx
8010434c:	73 1e                	jae    8010436c <wait+0x7c>
            if (p->parent != curproc)
8010434e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104351:	75 ed                	jne    80104340 <wait+0x50>
            if (p->state == ZOMBIE) {
80104353:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80104357:	74 67                	je     801043c0 <wait+0xd0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104359:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
            havekids = 1;
8010435f:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104364:	81 fb 94 3c 12 80    	cmp    $0x80123c94,%ebx
8010436a:	72 e2                	jb     8010434e <wait+0x5e>
        if (!havekids || myproc()->killed) {
8010436c:	85 c0                	test   %eax,%eax
8010436e:	0f 84 ec 00 00 00    	je     80104460 <wait+0x170>
    pushcli();
80104374:	e8 e7 04 00 00       	call   80104860 <pushcli>
    c = mycpu();
80104379:	e8 d2 f4 ff ff       	call   80103850 <mycpu>
    p = c->proc;
8010437e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104384:	e8 17 05 00 00       	call   801048a0 <popcli>
        if (!havekids || myproc()->killed) {
80104389:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010438c:	85 c0                	test   %eax,%eax
8010438e:	0f 85 cc 00 00 00    	jne    80104460 <wait+0x170>
    pushcli();
80104394:	e8 c7 04 00 00       	call   80104860 <pushcli>
    c = mycpu();
80104399:	e8 b2 f4 ff ff       	call   80103850 <mycpu>
    t = c->currThread;
8010439e:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801043a4:	e8 f7 04 00 00       	call   801048a0 <popcli>
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
801043a9:	83 ec 08             	sub    $0x8,%esp
801043ac:	68 60 3d 11 80       	push   $0x80113d60
801043b1:	53                   	push   %ebx
801043b2:	e8 69 fb ff ff       	call   80103f20 <sleep>
        havekids = 0;
801043b7:	83 c4 10             	add    $0x10,%esp
801043ba:	e9 78 ff ff ff       	jmp    80104337 <wait+0x47>
801043bf:	90                   	nop
                pid = p->pid;
801043c0:	8b 43 0c             	mov    0xc(%ebx),%eax
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043c3:	8d 73 70             	lea    0x70(%ebx),%esi
801043c6:	8d bb f0 03 00 00    	lea    0x3f0(%ebx),%edi
                pid = p->pid;
801043cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043cf:	eb 0e                	jmp    801043df <wait+0xef>
801043d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043d8:	83 c6 38             	add    $0x38,%esi
801043db:	39 f7                	cmp    %esi,%edi
801043dd:	76 3c                	jbe    8010441b <wait+0x12b>
                    if (t->state != UNUSED)
801043df:	8b 56 08             	mov    0x8(%esi),%edx
801043e2:	85 d2                	test   %edx,%edx
801043e4:	74 f2                	je     801043d8 <wait+0xe8>
    kfree(t->tkstack);
801043e6:	83 ec 0c             	sub    $0xc,%esp
801043e9:	ff 76 04             	pushl  0x4(%esi)
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043ec:	83 c6 38             	add    $0x38,%esi
    kfree(t->tkstack);
801043ef:	e8 5c df ff ff       	call   80102350 <kfree>
    t->tkstack = 0;
801043f4:	c7 46 cc 00 00 00 00 	movl   $0x0,-0x34(%esi)
    t->state = UNUSED;
801043fb:	c7 46 d0 00 00 00 00 	movl   $0x0,-0x30(%esi)
    t->killed = 0;
80104402:	83 c4 10             	add    $0x10,%esp
    t->tid = 0;
80104405:	c7 46 d4 00 00 00 00 	movl   $0x0,-0x2c(%esi)
    t->name[0] = 0;
8010440c:	c6 46 ec 00          	movb   $0x0,-0x14(%esi)
    t->killed = 0;
80104410:	c7 46 e4 00 00 00 00 	movl   $0x0,-0x1c(%esi)
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104417:	39 f7                	cmp    %esi,%edi
80104419:	77 c4                	ja     801043df <wait+0xef>
                freevm(p->pgdir);
8010441b:	83 ec 0c             	sub    $0xc,%esp
8010441e:	ff 73 04             	pushl  0x4(%ebx)
80104421:	e8 8a 2d 00 00       	call   801071b0 <freevm>
                p->pid = 0;
80104426:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
8010442d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
80104434:	c6 43 60 00          	movb   $0x0,0x60(%ebx)
                p->killed = 0;
80104438:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
8010443f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
80104446:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
8010444d:	e8 9e 05 00 00       	call   801049f0 <release>
                return pid;
80104452:	83 c4 10             	add    $0x10,%esp
}
80104455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104458:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010445b:	5b                   	pop    %ebx
8010445c:	5e                   	pop    %esi
8010445d:	5f                   	pop    %edi
8010445e:	5d                   	pop    %ebp
8010445f:	c3                   	ret    
            release(&ptable.lock);
80104460:	83 ec 0c             	sub    $0xc,%esp
80104463:	68 60 3d 11 80       	push   $0x80113d60
80104468:	e8 83 05 00 00       	call   801049f0 <release>
            return -1;
8010446d:	83 c4 10             	add    $0x10,%esp
80104470:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104477:	eb dc                	jmp    80104455 <wait+0x165>
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 1)
80104487:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
wakeup(void *chan) {
8010448e:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 1)
80104491:	7e 10                	jle    801044a3 <wakeup+0x23>
        cprintf(" WAKEUP ");
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	68 a6 7b 10 80       	push   $0x80107ba6
8010449b:	e8 c0 c1 ff ff       	call   80100660 <cprintf>
801044a0:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 60 3d 11 80       	push   $0x80113d60
801044ab:	e8 80 04 00 00       	call   80104930 <acquire>
801044b0:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044b3:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
801044b8:	eb 14                	jmp    801044ce <wakeup+0x4e>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044c0:	81 c2 fc 03 00 00    	add    $0x3fc,%edx
801044c6:	81 fa 94 3c 12 80    	cmp    $0x80123c94,%edx
801044cc:	73 2d                	jae    801044fb <wakeup+0x7b>
        if (p->state != RUNNABLE)
801044ce:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801044d2:	75 ec                	jne    801044c0 <wakeup+0x40>
801044d4:	8d 42 70             	lea    0x70(%edx),%eax
801044d7:	8d 8a f0 03 00 00    	lea    0x3f0(%edx),%ecx
801044dd:	eb 08                	jmp    801044e7 <wakeup+0x67>
801044df:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801044e0:	83 c0 38             	add    $0x38,%eax
801044e3:	39 c1                	cmp    %eax,%ecx
801044e5:	76 d9                	jbe    801044c0 <wakeup+0x40>
            if (t->state == SLEEPING && t->chan == chan)
801044e7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801044eb:	75 f3                	jne    801044e0 <wakeup+0x60>
801044ed:	3b 58 18             	cmp    0x18(%eax),%ebx
801044f0:	75 ee                	jne    801044e0 <wakeup+0x60>
                t->state = RUNNABLE;
801044f2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801044f9:	eb e5                	jmp    801044e0 <wakeup+0x60>
    wakeup1(chan);
    release(&ptable.lock);
801044fb:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
80104502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104505:	c9                   	leave  
    release(&ptable.lock);
80104506:	e9 e5 04 00 00       	jmp    801049f0 <release>
8010450b:	90                   	nop
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104510 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	53                   	push   %ebx
80104514:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 0)
80104517:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
kill(int pid) {
8010451c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 0)
8010451f:	85 c0                	test   %eax,%eax
80104521:	7e 10                	jle    80104533 <kill+0x23>
        cprintf(" KILL ");
80104523:	83 ec 0c             	sub    $0xc,%esp
80104526:	68 af 7b 10 80       	push   $0x80107baf
8010452b:	e8 30 c1 ff ff       	call   80100660 <cprintf>
80104530:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    acquire(&ptable.lock);
80104533:	83 ec 0c             	sub    $0xc,%esp
80104536:	68 60 3d 11 80       	push   $0x80113d60
8010453b:	e8 f0 03 00 00       	call   80104930 <acquire>
80104540:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104543:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80104548:	eb 12                	jmp    8010455c <kill+0x4c>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104550:	05 fc 03 00 00       	add    $0x3fc,%eax
80104555:	3d 94 3c 12 80       	cmp    $0x80123c94,%eax
8010455a:	73 5c                	jae    801045b8 <kill+0xa8>
        if (p->pid == pid) {
8010455c:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010455f:	75 ef                	jne    80104550 <kill+0x40>
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104561:	8d 50 70             	lea    0x70(%eax),%edx
80104564:	8d 88 f0 03 00 00    	lea    0x3f0(%eax),%ecx
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                t->killed = 1;
80104570:	c7 42 1c 01 00 00 00 	movl   $0x1,0x1c(%edx)
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104577:	83 c2 38             	add    $0x38,%edx
8010457a:	39 d1                	cmp    %edx,%ecx
8010457c:	77 f2                	ja     80104570 <kill+0x60>
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
8010457e:	8b 90 f0 03 00 00    	mov    0x3f0(%eax),%edx
80104584:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
80104588:	75 14                	jne    8010459e <kill+0x8e>
                p->mainThread->state = RUNNABLE;
8010458a:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
80104591:	8b 80 f0 03 00 00    	mov    0x3f0(%eax),%eax
80104597:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
            }

            //release( p->procLock );
            release(&ptable.lock);
8010459e:	83 ec 0c             	sub    $0xc,%esp
801045a1:	68 60 3d 11 80       	push   $0x80113d60
801045a6:	e8 45 04 00 00       	call   801049f0 <release>
            return 0;
801045ab:	83 c4 10             	add    $0x10,%esp
801045ae:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801045b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b3:	c9                   	leave  
801045b4:	c3                   	ret    
801045b5:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 60 3d 11 80       	push   $0x80113d60
801045c0:	e8 2b 04 00 00       	call   801049f0 <release>
    return -1;
801045c5:	83 c4 10             	add    $0x10,%esp
801045c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d0:	c9                   	leave  
801045d1:	c3                   	ret    
801045d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045e9:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
procdump(void) {
801045ee:	83 ec 3c             	sub    $0x3c,%esp
801045f1:	eb 27                	jmp    8010461a <procdump+0x3a>
801045f3:	90                   	nop
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 71 75 10 80       	push   $0x80107571
80104600:	e8 5b c0 ff ff       	call   80100660 <cprintf>
80104605:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104608:	81 c3 fc 03 00 00    	add    $0x3fc,%ebx
8010460e:	81 fb 94 3c 12 80    	cmp    $0x80123c94,%ebx
80104614:	0f 83 96 00 00 00    	jae    801046b0 <procdump+0xd0>
        if (p->state == UNUSED)
8010461a:	8b 43 08             	mov    0x8(%ebx),%eax
8010461d:	85 c0                	test   %eax,%eax
8010461f:	74 e7                	je     80104608 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104621:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104624:	ba b6 7b 10 80       	mov    $0x80107bb6,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104629:	77 11                	ja     8010463c <procdump+0x5c>
8010462b:	8b 14 85 74 7c 10 80 	mov    -0x7fef838c(,%eax,4),%edx
            state = "???";
80104632:	b8 b6 7b 10 80       	mov    $0x80107bb6,%eax
80104637:	85 d2                	test   %edx,%edx
80104639:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010463c:	8d 43 60             	lea    0x60(%ebx),%eax
8010463f:	50                   	push   %eax
80104640:	52                   	push   %edx
80104641:	ff 73 0c             	pushl  0xc(%ebx)
80104644:	68 ba 7b 10 80       	push   $0x80107bba
80104649:	e8 12 c0 ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
8010464e:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80104654:	83 c4 10             	add    $0x10,%esp
80104657:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010465b:	75 9b                	jne    801045f8 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
8010465d:	8d 4d c0             	lea    -0x40(%ebp),%ecx
80104660:	83 ec 08             	sub    $0x8,%esp
80104663:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104666:	51                   	push   %ecx
80104667:	8b 40 14             	mov    0x14(%eax),%eax
8010466a:	8b 40 0c             	mov    0xc(%eax),%eax
8010466d:	83 c0 08             	add    $0x8,%eax
80104670:	50                   	push   %eax
80104671:	e8 9a 01 00 00       	call   80104810 <getcallerpcs>
80104676:	83 c4 10             	add    $0x10,%esp
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104680:	8b 17                	mov    (%edi),%edx
80104682:	85 d2                	test   %edx,%edx
80104684:	0f 84 6e ff ff ff    	je     801045f8 <procdump+0x18>
                cprintf(" %p", pc[i]);
8010468a:	83 ec 08             	sub    $0x8,%esp
8010468d:	83 c7 04             	add    $0x4,%edi
80104690:	52                   	push   %edx
80104691:	68 21 75 10 80       	push   $0x80107521
80104696:	e8 c5 bf ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
8010469b:	83 c4 10             	add    $0x10,%esp
8010469e:	39 fe                	cmp    %edi,%esi
801046a0:	75 de                	jne    80104680 <procdump+0xa0>
801046a2:	e9 51 ff ff ff       	jmp    801045f8 <procdump+0x18>
801046a7:	89 f6                	mov    %esi,%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
801046b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046b3:	5b                   	pop    %ebx
801046b4:	5e                   	pop    %esi
801046b5:	5f                   	pop    %edi
801046b6:	5d                   	pop    %ebp
801046b7:	c3                   	ret    
801046b8:	66 90                	xchg   %ax,%ax
801046ba:	66 90                	xchg   %ax,%ax
801046bc:	66 90                	xchg   %ax,%ax
801046be:	66 90                	xchg   %ax,%ax

801046c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	83 ec 0c             	sub    $0xc,%esp
801046c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046ca:	68 8c 7c 10 80       	push   $0x80107c8c
801046cf:	8d 43 04             	lea    0x4(%ebx),%eax
801046d2:	50                   	push   %eax
801046d3:	e8 18 01 00 00       	call   801047f0 <initlock>
  lk->name = name;
801046d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801046db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801046e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801046e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801046eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801046ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f1:	c9                   	leave  
801046f2:	c3                   	ret    
801046f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	8d 73 04             	lea    0x4(%ebx),%esi
8010470e:	56                   	push   %esi
8010470f:	e8 1c 02 00 00       	call   80104930 <acquire>
  while (lk->locked) {
80104714:	8b 13                	mov    (%ebx),%edx
80104716:	83 c4 10             	add    $0x10,%esp
80104719:	85 d2                	test   %edx,%edx
8010471b:	74 16                	je     80104733 <acquiresleep+0x33>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104720:	83 ec 08             	sub    $0x8,%esp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	e8 f6 f7 ff ff       	call   80103f20 <sleep>
  while (lk->locked) {
8010472a:	8b 03                	mov    (%ebx),%eax
8010472c:	83 c4 10             	add    $0x10,%esp
8010472f:	85 c0                	test   %eax,%eax
80104731:	75 ed                	jne    80104720 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104733:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104739:	e8 b2 f1 ff ff       	call   801038f0 <myproc>
8010473e:	8b 40 0c             	mov    0xc(%eax),%eax
80104741:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104744:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104747:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010474a:	5b                   	pop    %ebx
8010474b:	5e                   	pop    %esi
8010474c:	5d                   	pop    %ebp
  release(&lk->lk);
8010474d:	e9 9e 02 00 00       	jmp    801049f0 <release>
80104752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
80104765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	8d 73 04             	lea    0x4(%ebx),%esi
8010476e:	56                   	push   %esi
8010476f:	e8 bc 01 00 00       	call   80104930 <acquire>
  lk->locked = 0;
80104774:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010477a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104781:	89 1c 24             	mov    %ebx,(%esp)
80104784:	e8 f7 fc ff ff       	call   80104480 <wakeup>
  release(&lk->lk);
80104789:	89 75 08             	mov    %esi,0x8(%ebp)
8010478c:	83 c4 10             	add    $0x10,%esp
}
8010478f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104792:	5b                   	pop    %ebx
80104793:	5e                   	pop    %esi
80104794:	5d                   	pop    %ebp
  release(&lk->lk);
80104795:	e9 56 02 00 00       	jmp    801049f0 <release>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	53                   	push   %ebx
801047a6:	31 ff                	xor    %edi,%edi
801047a8:	83 ec 18             	sub    $0x18,%esp
801047ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047ae:	8d 73 04             	lea    0x4(%ebx),%esi
801047b1:	56                   	push   %esi
801047b2:	e8 79 01 00 00       	call   80104930 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801047b7:	8b 03                	mov    (%ebx),%eax
801047b9:	83 c4 10             	add    $0x10,%esp
801047bc:	85 c0                	test   %eax,%eax
801047be:	74 13                	je     801047d3 <holdingsleep+0x33>
801047c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047c3:	e8 28 f1 ff ff       	call   801038f0 <myproc>
801047c8:	39 58 0c             	cmp    %ebx,0xc(%eax)
801047cb:	0f 94 c0             	sete   %al
801047ce:	0f b6 c0             	movzbl %al,%eax
801047d1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801047d3:	83 ec 0c             	sub    $0xc,%esp
801047d6:	56                   	push   %esi
801047d7:	e8 14 02 00 00       	call   801049f0 <release>
  return r;
}
801047dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047df:	89 f8                	mov    %edi,%eax
801047e1:	5b                   	pop    %ebx
801047e2:	5e                   	pop    %esi
801047e3:	5f                   	pop    %edi
801047e4:	5d                   	pop    %ebp
801047e5:	c3                   	ret    
801047e6:	66 90                	xchg   %ax,%ax
801047e8:	66 90                	xchg   %ax,%ax
801047ea:	66 90                	xchg   %ax,%ax
801047ec:	66 90                	xchg   %ax,%ax
801047ee:	66 90                	xchg   %ax,%ax

801047f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801047ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104802:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    
8010480b:	90                   	nop
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104810 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104810:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104811:	31 d2                	xor    %edx,%edx
{
80104813:	89 e5                	mov    %esp,%ebp
80104815:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104816:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010481c:	83 e8 08             	sub    $0x8,%eax
8010481f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104820:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104826:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010482c:	77 1a                	ja     80104848 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010482e:	8b 58 04             	mov    0x4(%eax),%ebx
80104831:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104834:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104837:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104839:	83 fa 0a             	cmp    $0xa,%edx
8010483c:	75 e2                	jne    80104820 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010483e:	5b                   	pop    %ebx
8010483f:	5d                   	pop    %ebp
80104840:	c3                   	ret    
80104841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104848:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010484b:	83 c1 28             	add    $0x28,%ecx
8010484e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104856:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104859:	39 c1                	cmp    %eax,%ecx
8010485b:	75 f3                	jne    80104850 <getcallerpcs+0x40>
}
8010485d:	5b                   	pop    %ebx
8010485e:	5d                   	pop    %ebp
8010485f:	c3                   	ret    

80104860 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	9c                   	pushf  
80104868:	5b                   	pop    %ebx
  asm volatile("cli");
80104869:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010486a:	e8 e1 ef ff ff       	call   80103850 <mycpu>
8010486f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104875:	85 c0                	test   %eax,%eax
80104877:	75 11                	jne    8010488a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104879:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010487f:	e8 cc ef ff ff       	call   80103850 <mycpu>
80104884:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010488a:	e8 c1 ef ff ff       	call   80103850 <mycpu>
8010488f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104896:	83 c4 04             	add    $0x4,%esp
80104899:	5b                   	pop    %ebx
8010489a:	5d                   	pop    %ebp
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <popcli>:

void
popcli(void)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048a6:	9c                   	pushf  
801048a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048a8:	f6 c4 02             	test   $0x2,%ah
801048ab:	75 35                	jne    801048e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048ad:	e8 9e ef ff ff       	call   80103850 <mycpu>
801048b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801048b9:	78 34                	js     801048ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048bb:	e8 90 ef ff ff       	call   80103850 <mycpu>
801048c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048c6:	85 d2                	test   %edx,%edx
801048c8:	74 06                	je     801048d0 <popcli+0x30>
    sti();
}
801048ca:	c9                   	leave  
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048d0:	e8 7b ef ff ff       	call   80103850 <mycpu>
801048d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048db:	85 c0                	test   %eax,%eax
801048dd:	74 eb                	je     801048ca <popcli+0x2a>
  asm volatile("sti");
801048df:	fb                   	sti    
}
801048e0:	c9                   	leave  
801048e1:	c3                   	ret    
    panic("popcli - interruptible");
801048e2:	83 ec 0c             	sub    $0xc,%esp
801048e5:	68 97 7c 10 80       	push   $0x80107c97
801048ea:	e8 a1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
801048ef:	83 ec 0c             	sub    $0xc,%esp
801048f2:	68 ae 7c 10 80       	push   $0x80107cae
801048f7:	e8 94 ba ff ff       	call   80100390 <panic>
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104900 <holding>:
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	8b 75 08             	mov    0x8(%ebp),%esi
80104908:	31 db                	xor    %ebx,%ebx
  pushcli();
8010490a:	e8 51 ff ff ff       	call   80104860 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010490f:	8b 06                	mov    (%esi),%eax
80104911:	85 c0                	test   %eax,%eax
80104913:	74 10                	je     80104925 <holding+0x25>
80104915:	8b 5e 08             	mov    0x8(%esi),%ebx
80104918:	e8 33 ef ff ff       	call   80103850 <mycpu>
8010491d:	39 c3                	cmp    %eax,%ebx
8010491f:	0f 94 c3             	sete   %bl
80104922:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104925:	e8 76 ff ff ff       	call   801048a0 <popcli>
}
8010492a:	89 d8                	mov    %ebx,%eax
8010492c:	5b                   	pop    %ebx
8010492d:	5e                   	pop    %esi
8010492e:	5d                   	pop    %ebp
8010492f:	c3                   	ret    

80104930 <acquire>:
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104935:	e8 26 ff ff ff       	call   80104860 <pushcli>
  if(holding(lk))
8010493a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010493d:	83 ec 0c             	sub    $0xc,%esp
80104940:	53                   	push   %ebx
80104941:	e8 ba ff ff ff       	call   80104900 <holding>
80104946:	83 c4 10             	add    $0x10,%esp
80104949:	85 c0                	test   %eax,%eax
8010494b:	0f 85 83 00 00 00    	jne    801049d4 <acquire+0xa4>
80104951:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104953:	ba 01 00 00 00       	mov    $0x1,%edx
80104958:	eb 09                	jmp    80104963 <acquire+0x33>
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104960:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104963:	89 d0                	mov    %edx,%eax
80104965:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104968:	85 c0                	test   %eax,%eax
8010496a:	75 f4                	jne    80104960 <acquire+0x30>
  __sync_synchronize();
8010496c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104971:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104974:	e8 d7 ee ff ff       	call   80103850 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104979:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010497c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010497f:	89 e8                	mov    %ebp,%eax
80104981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104988:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010498e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104994:	77 1a                	ja     801049b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104996:	8b 48 04             	mov    0x4(%eax),%ecx
80104999:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010499c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010499f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049a1:	83 fe 0a             	cmp    $0xa,%esi
801049a4:	75 e2                	jne    80104988 <acquire+0x58>
}
801049a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049a9:	5b                   	pop    %ebx
801049aa:	5e                   	pop    %esi
801049ab:	5d                   	pop    %ebp
801049ac:	c3                   	ret    
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
801049b0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801049b3:	83 c2 28             	add    $0x28,%edx
801049b6:	8d 76 00             	lea    0x0(%esi),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801049c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049c9:	39 d0                	cmp    %edx,%eax
801049cb:	75 f3                	jne    801049c0 <acquire+0x90>
}
801049cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d0:	5b                   	pop    %ebx
801049d1:	5e                   	pop    %esi
801049d2:	5d                   	pop    %ebp
801049d3:	c3                   	ret    
    panic("acquire");
801049d4:	83 ec 0c             	sub    $0xc,%esp
801049d7:	68 b5 7c 10 80       	push   $0x80107cb5
801049dc:	e8 af b9 ff ff       	call   80100390 <panic>
801049e1:	eb 0d                	jmp    801049f0 <release>
801049e3:	90                   	nop
801049e4:	90                   	nop
801049e5:	90                   	nop
801049e6:	90                   	nop
801049e7:	90                   	nop
801049e8:	90                   	nop
801049e9:	90                   	nop
801049ea:	90                   	nop
801049eb:	90                   	nop
801049ec:	90                   	nop
801049ed:	90                   	nop
801049ee:	90                   	nop
801049ef:	90                   	nop

801049f0 <release>:
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	53                   	push   %ebx
801049f4:	83 ec 10             	sub    $0x10,%esp
801049f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801049fa:	53                   	push   %ebx
801049fb:	e8 00 ff ff ff       	call   80104900 <holding>
80104a00:	83 c4 10             	add    $0x10,%esp
80104a03:	85 c0                	test   %eax,%eax
80104a05:	74 22                	je     80104a29 <release+0x39>
  lk->pcs[0] = 0;
80104a07:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a15:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a1a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a23:	c9                   	leave  
  popcli();
80104a24:	e9 77 fe ff ff       	jmp    801048a0 <popcli>
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
80104a29:	50                   	push   %eax
80104a2a:	50                   	push   %eax
80104a2b:	ff 73 04             	pushl  0x4(%ebx)
80104a2e:	68 c8 7c 10 80       	push   $0x80107cc8
80104a33:	e8 28 bc ff ff       	call   80100660 <cprintf>
    panic("release");}
80104a38:	c7 04 24 bd 7c 10 80 	movl   $0x80107cbd,(%esp)
80104a3f:	e8 4c b9 ff ff       	call   80100390 <panic>
80104a44:	66 90                	xchg   %ax,%ax
80104a46:	66 90                	xchg   %ax,%ax
80104a48:	66 90                	xchg   %ax,%ax
80104a4a:	66 90                	xchg   %ax,%ax
80104a4c:	66 90                	xchg   %ax,%ax
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	53                   	push   %ebx
80104a55:	8b 55 08             	mov    0x8(%ebp),%edx
80104a58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a5b:	f6 c2 03             	test   $0x3,%dl
80104a5e:	75 05                	jne    80104a65 <memset+0x15>
80104a60:	f6 c1 03             	test   $0x3,%cl
80104a63:	74 13                	je     80104a78 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104a65:	89 d7                	mov    %edx,%edi
80104a67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a6a:	fc                   	cld    
80104a6b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a6d:	5b                   	pop    %ebx
80104a6e:	89 d0                	mov    %edx,%eax
80104a70:	5f                   	pop    %edi
80104a71:	5d                   	pop    %ebp
80104a72:	c3                   	ret    
80104a73:	90                   	nop
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a78:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a7c:	c1 e9 02             	shr    $0x2,%ecx
80104a7f:	89 f8                	mov    %edi,%eax
80104a81:	89 fb                	mov    %edi,%ebx
80104a83:	c1 e0 18             	shl    $0x18,%eax
80104a86:	c1 e3 10             	shl    $0x10,%ebx
80104a89:	09 d8                	or     %ebx,%eax
80104a8b:	09 f8                	or     %edi,%eax
80104a8d:	c1 e7 08             	shl    $0x8,%edi
80104a90:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a92:	89 d7                	mov    %edx,%edi
80104a94:	fc                   	cld    
80104a95:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104a97:	5b                   	pop    %ebx
80104a98:	89 d0                	mov    %edx,%eax
80104a9a:	5f                   	pop    %edi
80104a9b:	5d                   	pop    %ebp
80104a9c:	c3                   	ret    
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	53                   	push   %ebx
80104aa6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104aa9:	8b 75 08             	mov    0x8(%ebp),%esi
80104aac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104aaf:	85 db                	test   %ebx,%ebx
80104ab1:	74 29                	je     80104adc <memcmp+0x3c>
    if(*s1 != *s2)
80104ab3:	0f b6 16             	movzbl (%esi),%edx
80104ab6:	0f b6 0f             	movzbl (%edi),%ecx
80104ab9:	38 d1                	cmp    %dl,%cl
80104abb:	75 2b                	jne    80104ae8 <memcmp+0x48>
80104abd:	b8 01 00 00 00       	mov    $0x1,%eax
80104ac2:	eb 14                	jmp    80104ad8 <memcmp+0x38>
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ac8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104acc:	83 c0 01             	add    $0x1,%eax
80104acf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104ad4:	38 ca                	cmp    %cl,%dl
80104ad6:	75 10                	jne    80104ae8 <memcmp+0x48>
  while(n-- > 0){
80104ad8:	39 d8                	cmp    %ebx,%eax
80104ada:	75 ec                	jne    80104ac8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104adc:	5b                   	pop    %ebx
  return 0;
80104add:	31 c0                	xor    %eax,%eax
}
80104adf:	5e                   	pop    %esi
80104ae0:	5f                   	pop    %edi
80104ae1:	5d                   	pop    %ebp
80104ae2:	c3                   	ret    
80104ae3:	90                   	nop
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104ae8:	0f b6 c2             	movzbl %dl,%eax
}
80104aeb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104aec:	29 c8                	sub    %ecx,%eax
}
80104aee:	5e                   	pop    %esi
80104aef:	5f                   	pop    %edi
80104af0:	5d                   	pop    %ebp
80104af1:	c3                   	ret    
80104af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	8b 45 08             	mov    0x8(%ebp),%eax
80104b08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b0b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b0e:	39 c3                	cmp    %eax,%ebx
80104b10:	73 26                	jae    80104b38 <memmove+0x38>
80104b12:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b15:	39 c8                	cmp    %ecx,%eax
80104b17:	73 1f                	jae    80104b38 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b19:	85 f6                	test   %esi,%esi
80104b1b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b1e:	74 0f                	je     80104b2f <memmove+0x2f>
      *--d = *--s;
80104b20:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b24:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b27:	83 ea 01             	sub    $0x1,%edx
80104b2a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b2d:	75 f1                	jne    80104b20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b2f:	5b                   	pop    %ebx
80104b30:	5e                   	pop    %esi
80104b31:	5d                   	pop    %ebp
80104b32:	c3                   	ret    
80104b33:	90                   	nop
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b38:	31 d2                	xor    %edx,%edx
80104b3a:	85 f6                	test   %esi,%esi
80104b3c:	74 f1                	je     80104b2f <memmove+0x2f>
80104b3e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b47:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b4a:	39 d6                	cmp    %edx,%esi
80104b4c:	75 f2                	jne    80104b40 <memmove+0x40>
}
80104b4e:	5b                   	pop    %ebx
80104b4f:	5e                   	pop    %esi
80104b50:	5d                   	pop    %ebp
80104b51:	c3                   	ret    
80104b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b63:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104b64:	eb 9a                	jmp    80104b00 <memmove>
80104b66:	8d 76 00             	lea    0x0(%esi),%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b78:	53                   	push   %ebx
80104b79:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b7f:	85 ff                	test   %edi,%edi
80104b81:	74 2f                	je     80104bb2 <strncmp+0x42>
80104b83:	0f b6 01             	movzbl (%ecx),%eax
80104b86:	0f b6 1e             	movzbl (%esi),%ebx
80104b89:	84 c0                	test   %al,%al
80104b8b:	74 37                	je     80104bc4 <strncmp+0x54>
80104b8d:	38 c3                	cmp    %al,%bl
80104b8f:	75 33                	jne    80104bc4 <strncmp+0x54>
80104b91:	01 f7                	add    %esi,%edi
80104b93:	eb 13                	jmp    80104ba8 <strncmp+0x38>
80104b95:	8d 76 00             	lea    0x0(%esi),%esi
80104b98:	0f b6 01             	movzbl (%ecx),%eax
80104b9b:	84 c0                	test   %al,%al
80104b9d:	74 21                	je     80104bc0 <strncmp+0x50>
80104b9f:	0f b6 1a             	movzbl (%edx),%ebx
80104ba2:	89 d6                	mov    %edx,%esi
80104ba4:	38 d8                	cmp    %bl,%al
80104ba6:	75 1c                	jne    80104bc4 <strncmp+0x54>
    n--, p++, q++;
80104ba8:	8d 56 01             	lea    0x1(%esi),%edx
80104bab:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104bae:	39 fa                	cmp    %edi,%edx
80104bb0:	75 e6                	jne    80104b98 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104bb2:	5b                   	pop    %ebx
    return 0;
80104bb3:	31 c0                	xor    %eax,%eax
}
80104bb5:	5e                   	pop    %esi
80104bb6:	5f                   	pop    %edi
80104bb7:	5d                   	pop    %ebp
80104bb8:	c3                   	ret    
80104bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bc0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104bc4:	29 d8                	sub    %ebx,%eax
}
80104bc6:	5b                   	pop    %ebx
80104bc7:	5e                   	pop    %esi
80104bc8:	5f                   	pop    %edi
80104bc9:	5d                   	pop    %ebp
80104bca:	c3                   	ret    
80104bcb:	90                   	nop
80104bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bd0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bde:	89 c2                	mov    %eax,%edx
80104be0:	eb 19                	jmp    80104bfb <strncpy+0x2b>
80104be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104be8:	83 c3 01             	add    $0x1,%ebx
80104beb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104bef:	83 c2 01             	add    $0x1,%edx
80104bf2:	84 c9                	test   %cl,%cl
80104bf4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bf7:	74 09                	je     80104c02 <strncpy+0x32>
80104bf9:	89 f1                	mov    %esi,%ecx
80104bfb:	85 c9                	test   %ecx,%ecx
80104bfd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c00:	7f e6                	jg     80104be8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c02:	31 c9                	xor    %ecx,%ecx
80104c04:	85 f6                	test   %esi,%esi
80104c06:	7e 17                	jle    80104c1f <strncpy+0x4f>
80104c08:	90                   	nop
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c10:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c14:	89 f3                	mov    %esi,%ebx
80104c16:	83 c1 01             	add    $0x1,%ecx
80104c19:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c1b:	85 db                	test   %ebx,%ebx
80104c1d:	7f f1                	jg     80104c10 <strncpy+0x40>
  return os;
}
80104c1f:	5b                   	pop    %ebx
80104c20:	5e                   	pop    %esi
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret    
80104c23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c38:	8b 45 08             	mov    0x8(%ebp),%eax
80104c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c3e:	85 c9                	test   %ecx,%ecx
80104c40:	7e 26                	jle    80104c68 <safestrcpy+0x38>
80104c42:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c46:	89 c1                	mov    %eax,%ecx
80104c48:	eb 17                	jmp    80104c61 <safestrcpy+0x31>
80104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c50:	83 c2 01             	add    $0x1,%edx
80104c53:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c57:	83 c1 01             	add    $0x1,%ecx
80104c5a:	84 db                	test   %bl,%bl
80104c5c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c5f:	74 04                	je     80104c65 <safestrcpy+0x35>
80104c61:	39 f2                	cmp    %esi,%edx
80104c63:	75 eb                	jne    80104c50 <safestrcpy+0x20>
    ;
  *s = 0;
80104c65:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c68:	5b                   	pop    %ebx
80104c69:	5e                   	pop    %esi
80104c6a:	5d                   	pop    %ebp
80104c6b:	c3                   	ret    
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c70 <strlen>:

int
strlen(const char *s)
{
80104c70:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c71:	31 c0                	xor    %eax,%eax
{
80104c73:	89 e5                	mov    %esp,%ebp
80104c75:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c78:	80 3a 00             	cmpb   $0x0,(%edx)
80104c7b:	74 0c                	je     80104c89 <strlen+0x19>
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
80104c80:	83 c0 01             	add    $0x1,%eax
80104c83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c87:	75 f7                	jne    80104c80 <strlen+0x10>
    ;
  return n;
}
80104c89:	5d                   	pop    %ebp
80104c8a:	c3                   	ret    

80104c8b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c8b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c8f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c93:	55                   	push   %ebp
  pushl %ebx
80104c94:	53                   	push   %ebx
  pushl %esi
80104c95:	56                   	push   %esi
  pushl %edi
80104c96:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c97:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c99:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c9b:	5f                   	pop    %edi
  popl %esi
80104c9c:	5e                   	pop    %esi
  popl %ebx
80104c9d:	5b                   	pop    %ebx
  popl %ebp
80104c9e:	5d                   	pop    %ebp
  ret
80104c9f:	c3                   	ret    

80104ca0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	53                   	push   %ebx
80104ca4:	83 ec 04             	sub    $0x4,%esp
80104ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104caa:	e8 41 ec ff ff       	call   801038f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104caf:	8b 00                	mov    (%eax),%eax
80104cb1:	39 d8                	cmp    %ebx,%eax
80104cb3:	76 1b                	jbe    80104cd0 <fetchint+0x30>
80104cb5:	8d 53 04             	lea    0x4(%ebx),%edx
80104cb8:	39 d0                	cmp    %edx,%eax
80104cba:	72 14                	jb     80104cd0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cbf:	8b 13                	mov    (%ebx),%edx
80104cc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cc3:	31 c0                	xor    %eax,%eax
}
80104cc5:	83 c4 04             	add    $0x4,%esp
80104cc8:	5b                   	pop    %ebx
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
80104ccb:	90                   	nop
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb ee                	jmp    80104cc5 <fetchint+0x25>
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 04             	sub    $0x4,%esp
80104ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104cea:	e8 01 ec ff ff       	call   801038f0 <myproc>

  if(addr >= curproc->sz)
80104cef:	39 18                	cmp    %ebx,(%eax)
80104cf1:	76 29                	jbe    80104d1c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104cf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104cf6:	89 da                	mov    %ebx,%edx
80104cf8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104cfa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104cfc:	39 c3                	cmp    %eax,%ebx
80104cfe:	73 1c                	jae    80104d1c <fetchstr+0x3c>
    if(*s == 0)
80104d00:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d03:	75 10                	jne    80104d15 <fetchstr+0x35>
80104d05:	eb 39                	jmp    80104d40 <fetchstr+0x60>
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d10:	80 3a 00             	cmpb   $0x0,(%edx)
80104d13:	74 1b                	je     80104d30 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d15:	83 c2 01             	add    $0x1,%edx
80104d18:	39 d0                	cmp    %edx,%eax
80104d1a:	77 f4                	ja     80104d10 <fetchstr+0x30>
    return -1;
80104d1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d21:	83 c4 04             	add    $0x4,%esp
80104d24:	5b                   	pop    %ebx
80104d25:	5d                   	pop    %ebp
80104d26:	c3                   	ret    
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d30:	83 c4 04             	add    $0x4,%esp
80104d33:	89 d0                	mov    %edx,%eax
80104d35:	29 d8                	sub    %ebx,%eax
80104d37:	5b                   	pop    %ebx
80104d38:	5d                   	pop    %ebp
80104d39:	c3                   	ret    
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104d40:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104d42:	eb dd                	jmp    80104d21 <fetchstr+0x41>
80104d44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104d55:	e8 c6 eb ff ff       	call   80103920 <mythread>
80104d5a:	8b 40 10             	mov    0x10(%eax),%eax
80104d5d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d60:	8b 40 44             	mov    0x44(%eax),%eax
80104d63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d66:	e8 85 eb ff ff       	call   801038f0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d6b:	8b 00                	mov    (%eax),%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104d6d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d70:	39 c6                	cmp    %eax,%esi
80104d72:	73 1c                	jae    80104d90 <argint+0x40>
80104d74:	8d 53 08             	lea    0x8(%ebx),%edx
80104d77:	39 d0                	cmp    %edx,%eax
80104d79:	72 15                	jb     80104d90 <argint+0x40>
  *ip = *(int*)(addr);
80104d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d81:	89 10                	mov    %edx,(%eax)
  return 0;
80104d83:	31 c0                	xor    %eax,%eax
}
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret    
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104d95:	eb ee                	jmp    80104d85 <argint+0x35>
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
80104da5:	83 ec 10             	sub    $0x10,%esp
80104da8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104dab:	e8 40 eb ff ff       	call   801038f0 <myproc>
80104db0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104db2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104db5:	83 ec 08             	sub    $0x8,%esp
80104db8:	50                   	push   %eax
80104db9:	ff 75 08             	pushl  0x8(%ebp)
80104dbc:	e8 8f ff ff ff       	call   80104d50 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104dc1:	83 c4 10             	add    $0x10,%esp
80104dc4:	85 c0                	test   %eax,%eax
80104dc6:	78 28                	js     80104df0 <argptr+0x50>
80104dc8:	85 db                	test   %ebx,%ebx
80104dca:	78 24                	js     80104df0 <argptr+0x50>
80104dcc:	8b 16                	mov    (%esi),%edx
80104dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd1:	39 c2                	cmp    %eax,%edx
80104dd3:	76 1b                	jbe    80104df0 <argptr+0x50>
80104dd5:	01 c3                	add    %eax,%ebx
80104dd7:	39 da                	cmp    %ebx,%edx
80104dd9:	72 15                	jb     80104df0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dde:	89 02                	mov    %eax,(%edx)
  return 0;
80104de0:	31 c0                	xor    %eax,%eax
}
80104de2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104de5:	5b                   	pop    %ebx
80104de6:	5e                   	pop    %esi
80104de7:	5d                   	pop    %ebp
80104de8:	c3                   	ret    
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df5:	eb eb                	jmp    80104de2 <argptr+0x42>
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e09:	50                   	push   %eax
80104e0a:	ff 75 08             	pushl  0x8(%ebp)
80104e0d:	e8 3e ff ff ff       	call   80104d50 <argint>
80104e12:	83 c4 10             	add    $0x10,%esp
80104e15:	85 c0                	test   %eax,%eax
80104e17:	78 17                	js     80104e30 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e19:	83 ec 08             	sub    $0x8,%esp
80104e1c:	ff 75 0c             	pushl  0xc(%ebp)
80104e1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e22:	e8 b9 fe ff ff       	call   80104ce0 <fetchstr>
80104e27:	83 c4 10             	add    $0x10,%esp
}
80104e2a:	c9                   	leave  
80104e2b:	c3                   	ret    
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104e45:	e8 a6 ea ff ff       	call   801038f0 <myproc>
80104e4a:	89 c6                	mov    %eax,%esi
  struct thread *curthread = mythread();
80104e4c:	e8 cf ea ff ff       	call   80103920 <mythread>
80104e51:	89 c3                	mov    %eax,%ebx

  num = curthread->tf->eax;
80104e53:	8b 40 10             	mov    0x10(%eax),%eax
80104e56:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e59:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e5c:	83 fa 14             	cmp    $0x14,%edx
80104e5f:	77 1f                	ja     80104e80 <syscall+0x40>
80104e61:	8b 14 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%edx
80104e68:	85 d2                	test   %edx,%edx
80104e6a:	74 14                	je     80104e80 <syscall+0x40>
    curthread->tf->eax = syscalls[num]();
80104e6c:	ff d2                	call   *%edx
80104e6e:	8b 53 10             	mov    0x10(%ebx),%edx
80104e71:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
  }
}
80104e74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e77:	5b                   	pop    %ebx
80104e78:	5e                   	pop    %esi
80104e79:	5d                   	pop    %ebp
80104e7a:	c3                   	ret    
80104e7b:	90                   	nop
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e80:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e81:	8d 46 60             	lea    0x60(%esi),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e84:	50                   	push   %eax
80104e85:	ff 76 0c             	pushl  0xc(%esi)
80104e88:	68 ea 7c 10 80       	push   $0x80107cea
80104e8d:	e8 ce b7 ff ff       	call   80100660 <cprintf>
    curthread->tf->eax = -1;
80104e92:	8b 43 10             	mov    0x10(%ebx),%eax
80104e95:	83 c4 10             	add    $0x10,%esp
80104e98:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea2:	5b                   	pop    %ebx
80104ea3:	5e                   	pop    %esi
80104ea4:	5d                   	pop    %ebp
80104ea5:	c3                   	ret    
80104ea6:	66 90                	xchg   %ax,%ax
80104ea8:	66 90                	xchg   %ax,%ax
80104eaa:	66 90                	xchg   %ax,%ax
80104eac:	66 90                	xchg   %ax,%ax
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
80104eb5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104eb6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104eb9:	83 ec 44             	sub    $0x44,%esp
80104ebc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104ebf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ec2:	56                   	push   %esi
80104ec3:	50                   	push   %eax
{
80104ec4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104ec7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104eca:	e8 71 d0 ff ff       	call   80101f40 <nameiparent>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	0f 84 46 01 00 00    	je     80105020 <create+0x170>
    return 0;
  ilock(dp);
80104eda:	83 ec 0c             	sub    $0xc,%esp
80104edd:	89 c3                	mov    %eax,%ebx
80104edf:	50                   	push   %eax
80104ee0:	e8 db c7 ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104ee5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104ee8:	83 c4 0c             	add    $0xc,%esp
80104eeb:	50                   	push   %eax
80104eec:	56                   	push   %esi
80104eed:	53                   	push   %ebx
80104eee:	e8 fd cc ff ff       	call   80101bf0 <dirlookup>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	89 c7                	mov    %eax,%edi
80104efa:	74 34                	je     80104f30 <create+0x80>
    iunlockput(dp);
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	53                   	push   %ebx
80104f00:	e8 4b ca ff ff       	call   80101950 <iunlockput>
    ilock(ip);
80104f05:	89 3c 24             	mov    %edi,(%esp)
80104f08:	e8 b3 c7 ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104f15:	0f 85 95 00 00 00    	jne    80104fb0 <create+0x100>
80104f1b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f20:	0f 85 8a 00 00 00    	jne    80104fb0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f29:	89 f8                	mov    %edi,%eax
80104f2b:	5b                   	pop    %ebx
80104f2c:	5e                   	pop    %esi
80104f2d:	5f                   	pop    %edi
80104f2e:	5d                   	pop    %ebp
80104f2f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104f30:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104f34:	83 ec 08             	sub    $0x8,%esp
80104f37:	50                   	push   %eax
80104f38:	ff 33                	pushl  (%ebx)
80104f3a:	e8 11 c6 ff ff       	call   80101550 <ialloc>
80104f3f:	83 c4 10             	add    $0x10,%esp
80104f42:	85 c0                	test   %eax,%eax
80104f44:	89 c7                	mov    %eax,%edi
80104f46:	0f 84 e8 00 00 00    	je     80105034 <create+0x184>
  ilock(ip);
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	50                   	push   %eax
80104f50:	e8 6b c7 ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104f55:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104f59:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104f5d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104f61:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104f65:	b8 01 00 00 00       	mov    $0x1,%eax
80104f6a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104f6e:	89 3c 24             	mov    %edi,(%esp)
80104f71:	e8 9a c6 ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f7e:	74 50                	je     80104fd0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f80:	83 ec 04             	sub    $0x4,%esp
80104f83:	ff 77 04             	pushl  0x4(%edi)
80104f86:	56                   	push   %esi
80104f87:	53                   	push   %ebx
80104f88:	e8 d3 ce ff ff       	call   80101e60 <dirlink>
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	0f 88 8f 00 00 00    	js     80105027 <create+0x177>
  iunlockput(dp);
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	53                   	push   %ebx
80104f9c:	e8 af c9 ff ff       	call   80101950 <iunlockput>
  return ip;
80104fa1:	83 c4 10             	add    $0x10,%esp
}
80104fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fa7:	89 f8                	mov    %edi,%eax
80104fa9:	5b                   	pop    %ebx
80104faa:	5e                   	pop    %esi
80104fab:	5f                   	pop    %edi
80104fac:	5d                   	pop    %ebp
80104fad:	c3                   	ret    
80104fae:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
80104fb3:	57                   	push   %edi
    return 0;
80104fb4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104fb6:	e8 95 c9 ff ff       	call   80101950 <iunlockput>
    return 0;
80104fbb:	83 c4 10             	add    $0x10,%esp
}
80104fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fc1:	89 f8                	mov    %edi,%eax
80104fc3:	5b                   	pop    %ebx
80104fc4:	5e                   	pop    %esi
80104fc5:	5f                   	pop    %edi
80104fc6:	5d                   	pop    %ebp
80104fc7:	c3                   	ret    
80104fc8:	90                   	nop
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104fd0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fd5:	83 ec 0c             	sub    $0xc,%esp
80104fd8:	53                   	push   %ebx
80104fd9:	e8 32 c6 ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fde:	83 c4 0c             	add    $0xc,%esp
80104fe1:	ff 77 04             	pushl  0x4(%edi)
80104fe4:	68 94 7d 10 80       	push   $0x80107d94
80104fe9:	57                   	push   %edi
80104fea:	e8 71 ce ff ff       	call   80101e60 <dirlink>
80104fef:	83 c4 10             	add    $0x10,%esp
80104ff2:	85 c0                	test   %eax,%eax
80104ff4:	78 1c                	js     80105012 <create+0x162>
80104ff6:	83 ec 04             	sub    $0x4,%esp
80104ff9:	ff 73 04             	pushl  0x4(%ebx)
80104ffc:	68 93 7d 10 80       	push   $0x80107d93
80105001:	57                   	push   %edi
80105002:	e8 59 ce ff ff       	call   80101e60 <dirlink>
80105007:	83 c4 10             	add    $0x10,%esp
8010500a:	85 c0                	test   %eax,%eax
8010500c:	0f 89 6e ff ff ff    	jns    80104f80 <create+0xd0>
      panic("create dots");
80105012:	83 ec 0c             	sub    $0xc,%esp
80105015:	68 87 7d 10 80       	push   $0x80107d87
8010501a:	e8 71 b3 ff ff       	call   80100390 <panic>
8010501f:	90                   	nop
    return 0;
80105020:	31 ff                	xor    %edi,%edi
80105022:	e9 ff fe ff ff       	jmp    80104f26 <create+0x76>
    panic("create: dirlink");
80105027:	83 ec 0c             	sub    $0xc,%esp
8010502a:	68 96 7d 10 80       	push   $0x80107d96
8010502f:	e8 5c b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105034:	83 ec 0c             	sub    $0xc,%esp
80105037:	68 78 7d 10 80       	push   $0x80107d78
8010503c:	e8 4f b3 ff ff       	call   80100390 <panic>
80105041:	eb 0d                	jmp    80105050 <argfd.constprop.0>
80105043:	90                   	nop
80105044:	90                   	nop
80105045:	90                   	nop
80105046:	90                   	nop
80105047:	90                   	nop
80105048:	90                   	nop
80105049:	90                   	nop
8010504a:	90                   	nop
8010504b:	90                   	nop
8010504c:	90                   	nop
8010504d:	90                   	nop
8010504e:	90                   	nop
8010504f:	90                   	nop

80105050 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
80105055:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105057:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010505a:	89 d6                	mov    %edx,%esi
8010505c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010505f:	50                   	push   %eax
80105060:	6a 00                	push   $0x0
80105062:	e8 e9 fc ff ff       	call   80104d50 <argint>
80105067:	83 c4 10             	add    $0x10,%esp
8010506a:	85 c0                	test   %eax,%eax
8010506c:	78 2a                	js     80105098 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010506e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105072:	77 24                	ja     80105098 <argfd.constprop.0+0x48>
80105074:	e8 77 e8 ff ff       	call   801038f0 <myproc>
80105079:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010507c:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
80105080:	85 c0                	test   %eax,%eax
80105082:	74 14                	je     80105098 <argfd.constprop.0+0x48>
  if(pfd)
80105084:	85 db                	test   %ebx,%ebx
80105086:	74 02                	je     8010508a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105088:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010508a:	89 06                	mov    %eax,(%esi)
  return 0;
8010508c:	31 c0                	xor    %eax,%eax
}
8010508e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105091:	5b                   	pop    %ebx
80105092:	5e                   	pop    %esi
80105093:	5d                   	pop    %ebp
80105094:	c3                   	ret    
80105095:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb ef                	jmp    8010508e <argfd.constprop.0+0x3e>
8010509f:	90                   	nop

801050a0 <sys_dup>:
{
801050a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801050a1:	31 c0                	xor    %eax,%eax
{
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	56                   	push   %esi
801050a6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801050a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801050aa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050ad:	e8 9e ff ff ff       	call   80105050 <argfd.constprop.0>
801050b2:	85 c0                	test   %eax,%eax
801050b4:	78 42                	js     801050f8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801050b6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050b9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801050bb:	e8 30 e8 ff ff       	call   801038f0 <myproc>
801050c0:	eb 0e                	jmp    801050d0 <sys_dup+0x30>
801050c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050c8:	83 c3 01             	add    $0x1,%ebx
801050cb:	83 fb 10             	cmp    $0x10,%ebx
801050ce:	74 28                	je     801050f8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801050d0:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
801050d4:	85 d2                	test   %edx,%edx
801050d6:	75 f0                	jne    801050c8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801050d8:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
  filedup(f);
801050dc:	83 ec 0c             	sub    $0xc,%esp
801050df:	ff 75 f4             	pushl  -0xc(%ebp)
801050e2:	e8 39 bd ff ff       	call   80100e20 <filedup>
  return fd;
801050e7:	83 c4 10             	add    $0x10,%esp
}
801050ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ed:	89 d8                	mov    %ebx,%eax
801050ef:	5b                   	pop    %ebx
801050f0:	5e                   	pop    %esi
801050f1:	5d                   	pop    %ebp
801050f2:	c3                   	ret    
801050f3:	90                   	nop
801050f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801050fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105100:	89 d8                	mov    %ebx,%eax
80105102:	5b                   	pop    %ebx
80105103:	5e                   	pop    %esi
80105104:	5d                   	pop    %ebp
80105105:	c3                   	ret    
80105106:	8d 76 00             	lea    0x0(%esi),%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <sys_read>:
{
80105110:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105111:	31 c0                	xor    %eax,%eax
{
80105113:	89 e5                	mov    %esp,%ebp
80105115:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105118:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010511b:	e8 30 ff ff ff       	call   80105050 <argfd.constprop.0>
80105120:	85 c0                	test   %eax,%eax
80105122:	78 4c                	js     80105170 <sys_read+0x60>
80105124:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105127:	83 ec 08             	sub    $0x8,%esp
8010512a:	50                   	push   %eax
8010512b:	6a 02                	push   $0x2
8010512d:	e8 1e fc ff ff       	call   80104d50 <argint>
80105132:	83 c4 10             	add    $0x10,%esp
80105135:	85 c0                	test   %eax,%eax
80105137:	78 37                	js     80105170 <sys_read+0x60>
80105139:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513c:	83 ec 04             	sub    $0x4,%esp
8010513f:	ff 75 f0             	pushl  -0x10(%ebp)
80105142:	50                   	push   %eax
80105143:	6a 01                	push   $0x1
80105145:	e8 56 fc ff ff       	call   80104da0 <argptr>
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	85 c0                	test   %eax,%eax
8010514f:	78 1f                	js     80105170 <sys_read+0x60>
  return fileread(f, p, n);
80105151:	83 ec 04             	sub    $0x4,%esp
80105154:	ff 75 f0             	pushl  -0x10(%ebp)
80105157:	ff 75 f4             	pushl  -0xc(%ebp)
8010515a:	ff 75 ec             	pushl  -0x14(%ebp)
8010515d:	e8 2e be ff ff       	call   80100f90 <fileread>
80105162:	83 c4 10             	add    $0x10,%esp
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_write>:
{
80105180:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105181:	31 c0                	xor    %eax,%eax
{
80105183:	89 e5                	mov    %esp,%ebp
80105185:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105188:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010518b:	e8 c0 fe ff ff       	call   80105050 <argfd.constprop.0>
80105190:	85 c0                	test   %eax,%eax
80105192:	78 4c                	js     801051e0 <sys_write+0x60>
80105194:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105197:	83 ec 08             	sub    $0x8,%esp
8010519a:	50                   	push   %eax
8010519b:	6a 02                	push   $0x2
8010519d:	e8 ae fb ff ff       	call   80104d50 <argint>
801051a2:	83 c4 10             	add    $0x10,%esp
801051a5:	85 c0                	test   %eax,%eax
801051a7:	78 37                	js     801051e0 <sys_write+0x60>
801051a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ac:	83 ec 04             	sub    $0x4,%esp
801051af:	ff 75 f0             	pushl  -0x10(%ebp)
801051b2:	50                   	push   %eax
801051b3:	6a 01                	push   $0x1
801051b5:	e8 e6 fb ff ff       	call   80104da0 <argptr>
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	85 c0                	test   %eax,%eax
801051bf:	78 1f                	js     801051e0 <sys_write+0x60>
  return filewrite(f, p, n);
801051c1:	83 ec 04             	sub    $0x4,%esp
801051c4:	ff 75 f0             	pushl  -0x10(%ebp)
801051c7:	ff 75 f4             	pushl  -0xc(%ebp)
801051ca:	ff 75 ec             	pushl  -0x14(%ebp)
801051cd:	e8 4e be ff ff       	call   80101020 <filewrite>
801051d2:	83 c4 10             	add    $0x10,%esp
}
801051d5:	c9                   	leave  
801051d6:	c3                   	ret    
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051f0 <sys_close>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801051f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801051f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051fc:	e8 4f fe ff ff       	call   80105050 <argfd.constprop.0>
80105201:	85 c0                	test   %eax,%eax
80105203:	78 2b                	js     80105230 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105205:	e8 e6 e6 ff ff       	call   801038f0 <myproc>
8010520a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010520d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105210:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
80105217:	00 
  fileclose(f);
80105218:	ff 75 f4             	pushl  -0xc(%ebp)
8010521b:	e8 50 bc ff ff       	call   80100e70 <fileclose>
  return 0;
80105220:	83 c4 10             	add    $0x10,%esp
80105223:	31 c0                	xor    %eax,%eax
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

80105240 <sys_fstat>:
{
80105240:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105241:	31 c0                	xor    %eax,%eax
{
80105243:	89 e5                	mov    %esp,%ebp
80105245:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105248:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010524b:	e8 00 fe ff ff       	call   80105050 <argfd.constprop.0>
80105250:	85 c0                	test   %eax,%eax
80105252:	78 2c                	js     80105280 <sys_fstat+0x40>
80105254:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105257:	83 ec 04             	sub    $0x4,%esp
8010525a:	6a 14                	push   $0x14
8010525c:	50                   	push   %eax
8010525d:	6a 01                	push   $0x1
8010525f:	e8 3c fb ff ff       	call   80104da0 <argptr>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	78 15                	js     80105280 <sys_fstat+0x40>
  return filestat(f, st);
8010526b:	83 ec 08             	sub    $0x8,%esp
8010526e:	ff 75 f4             	pushl  -0xc(%ebp)
80105271:	ff 75 f0             	pushl  -0x10(%ebp)
80105274:	e8 c7 bc ff ff       	call   80100f40 <filestat>
80105279:	83 c4 10             	add    $0x10,%esp
}
8010527c:	c9                   	leave  
8010527d:	c3                   	ret    
8010527e:	66 90                	xchg   %ax,%ax
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_link>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	57                   	push   %edi
80105294:	56                   	push   %esi
80105295:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105296:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105299:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010529c:	50                   	push   %eax
8010529d:	6a 00                	push   $0x0
8010529f:	e8 5c fb ff ff       	call   80104e00 <argstr>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	0f 88 fb 00 00 00    	js     801053aa <sys_link+0x11a>
801052af:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052b2:	83 ec 08             	sub    $0x8,%esp
801052b5:	50                   	push   %eax
801052b6:	6a 01                	push   $0x1
801052b8:	e8 43 fb ff ff       	call   80104e00 <argstr>
801052bd:	83 c4 10             	add    $0x10,%esp
801052c0:	85 c0                	test   %eax,%eax
801052c2:	0f 88 e2 00 00 00    	js     801053aa <sys_link+0x11a>
  begin_op();
801052c8:	e8 13 d9 ff ff       	call   80102be0 <begin_op>
  if((ip = namei(old)) == 0){
801052cd:	83 ec 0c             	sub    $0xc,%esp
801052d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801052d3:	e8 48 cc ff ff       	call   80101f20 <namei>
801052d8:	83 c4 10             	add    $0x10,%esp
801052db:	85 c0                	test   %eax,%eax
801052dd:	89 c3                	mov    %eax,%ebx
801052df:	0f 84 ea 00 00 00    	je     801053cf <sys_link+0x13f>
  ilock(ip);
801052e5:	83 ec 0c             	sub    $0xc,%esp
801052e8:	50                   	push   %eax
801052e9:	e8 d2 c3 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052f6:	0f 84 bb 00 00 00    	je     801053b7 <sys_link+0x127>
  ip->nlink++;
801052fc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105301:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105304:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105307:	53                   	push   %ebx
80105308:	e8 03 c3 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
8010530d:	89 1c 24             	mov    %ebx,(%esp)
80105310:	e8 8b c4 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105315:	58                   	pop    %eax
80105316:	5a                   	pop    %edx
80105317:	57                   	push   %edi
80105318:	ff 75 d0             	pushl  -0x30(%ebp)
8010531b:	e8 20 cc ff ff       	call   80101f40 <nameiparent>
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	85 c0                	test   %eax,%eax
80105325:	89 c6                	mov    %eax,%esi
80105327:	74 5b                	je     80105384 <sys_link+0xf4>
  ilock(dp);
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	50                   	push   %eax
8010532d:	e8 8e c3 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	8b 03                	mov    (%ebx),%eax
80105337:	39 06                	cmp    %eax,(%esi)
80105339:	75 3d                	jne    80105378 <sys_link+0xe8>
8010533b:	83 ec 04             	sub    $0x4,%esp
8010533e:	ff 73 04             	pushl  0x4(%ebx)
80105341:	57                   	push   %edi
80105342:	56                   	push   %esi
80105343:	e8 18 cb ff ff       	call   80101e60 <dirlink>
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	85 c0                	test   %eax,%eax
8010534d:	78 29                	js     80105378 <sys_link+0xe8>
  iunlockput(dp);
8010534f:	83 ec 0c             	sub    $0xc,%esp
80105352:	56                   	push   %esi
80105353:	e8 f8 c5 ff ff       	call   80101950 <iunlockput>
  iput(ip);
80105358:	89 1c 24             	mov    %ebx,(%esp)
8010535b:	e8 90 c4 ff ff       	call   801017f0 <iput>
  end_op();
80105360:	e8 eb d8 ff ff       	call   80102c50 <end_op>
  return 0;
80105365:	83 c4 10             	add    $0x10,%esp
80105368:	31 c0                	xor    %eax,%eax
}
8010536a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010536d:	5b                   	pop    %ebx
8010536e:	5e                   	pop    %esi
8010536f:	5f                   	pop    %edi
80105370:	5d                   	pop    %ebp
80105371:	c3                   	ret    
80105372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	56                   	push   %esi
8010537c:	e8 cf c5 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105381:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105384:	83 ec 0c             	sub    $0xc,%esp
80105387:	53                   	push   %ebx
80105388:	e8 33 c3 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
8010538d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105392:	89 1c 24             	mov    %ebx,(%esp)
80105395:	e8 76 c2 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
8010539a:	89 1c 24             	mov    %ebx,(%esp)
8010539d:	e8 ae c5 ff ff       	call   80101950 <iunlockput>
  end_op();
801053a2:	e8 a9 d8 ff ff       	call   80102c50 <end_op>
  return -1;
801053a7:	83 c4 10             	add    $0x10,%esp
}
801053aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801053ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b2:	5b                   	pop    %ebx
801053b3:	5e                   	pop    %esi
801053b4:	5f                   	pop    %edi
801053b5:	5d                   	pop    %ebp
801053b6:	c3                   	ret    
    iunlockput(ip);
801053b7:	83 ec 0c             	sub    $0xc,%esp
801053ba:	53                   	push   %ebx
801053bb:	e8 90 c5 ff ff       	call   80101950 <iunlockput>
    end_op();
801053c0:	e8 8b d8 ff ff       	call   80102c50 <end_op>
    return -1;
801053c5:	83 c4 10             	add    $0x10,%esp
801053c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cd:	eb 9b                	jmp    8010536a <sys_link+0xda>
    end_op();
801053cf:	e8 7c d8 ff ff       	call   80102c50 <end_op>
    return -1;
801053d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d9:	eb 8f                	jmp    8010536a <sys_link+0xda>
801053db:	90                   	nop
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_unlink>:
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	57                   	push   %edi
801053e4:	56                   	push   %esi
801053e5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801053e6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053e9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801053ec:	50                   	push   %eax
801053ed:	6a 00                	push   $0x0
801053ef:	e8 0c fa ff ff       	call   80104e00 <argstr>
801053f4:	83 c4 10             	add    $0x10,%esp
801053f7:	85 c0                	test   %eax,%eax
801053f9:	0f 88 77 01 00 00    	js     80105576 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801053ff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105402:	e8 d9 d7 ff ff       	call   80102be0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105407:	83 ec 08             	sub    $0x8,%esp
8010540a:	53                   	push   %ebx
8010540b:	ff 75 c0             	pushl  -0x40(%ebp)
8010540e:	e8 2d cb ff ff       	call   80101f40 <nameiparent>
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	89 c6                	mov    %eax,%esi
8010541a:	0f 84 60 01 00 00    	je     80105580 <sys_unlink+0x1a0>
  ilock(dp);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	50                   	push   %eax
80105424:	e8 97 c2 ff ff       	call   801016c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105429:	58                   	pop    %eax
8010542a:	5a                   	pop    %edx
8010542b:	68 94 7d 10 80       	push   $0x80107d94
80105430:	53                   	push   %ebx
80105431:	e8 9a c7 ff ff       	call   80101bd0 <namecmp>
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	85 c0                	test   %eax,%eax
8010543b:	0f 84 03 01 00 00    	je     80105544 <sys_unlink+0x164>
80105441:	83 ec 08             	sub    $0x8,%esp
80105444:	68 93 7d 10 80       	push   $0x80107d93
80105449:	53                   	push   %ebx
8010544a:	e8 81 c7 ff ff       	call   80101bd0 <namecmp>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	85 c0                	test   %eax,%eax
80105454:	0f 84 ea 00 00 00    	je     80105544 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010545a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010545d:	83 ec 04             	sub    $0x4,%esp
80105460:	50                   	push   %eax
80105461:	53                   	push   %ebx
80105462:	56                   	push   %esi
80105463:	e8 88 c7 ff ff       	call   80101bf0 <dirlookup>
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	85 c0                	test   %eax,%eax
8010546d:	89 c3                	mov    %eax,%ebx
8010546f:	0f 84 cf 00 00 00    	je     80105544 <sys_unlink+0x164>
  ilock(ip);
80105475:	83 ec 0c             	sub    $0xc,%esp
80105478:	50                   	push   %eax
80105479:	e8 42 c2 ff ff       	call   801016c0 <ilock>
  if(ip->nlink < 1)
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105486:	0f 8e 10 01 00 00    	jle    8010559c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010548c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105491:	74 6d                	je     80105500 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105493:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105496:	83 ec 04             	sub    $0x4,%esp
80105499:	6a 10                	push   $0x10
8010549b:	6a 00                	push   $0x0
8010549d:	50                   	push   %eax
8010549e:	e8 ad f5 ff ff       	call   80104a50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054a6:	6a 10                	push   $0x10
801054a8:	ff 75 c4             	pushl  -0x3c(%ebp)
801054ab:	50                   	push   %eax
801054ac:	56                   	push   %esi
801054ad:	e8 ee c5 ff ff       	call   80101aa0 <writei>
801054b2:	83 c4 20             	add    $0x20,%esp
801054b5:	83 f8 10             	cmp    $0x10,%eax
801054b8:	0f 85 eb 00 00 00    	jne    801055a9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801054be:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054c3:	0f 84 97 00 00 00    	je     80105560 <sys_unlink+0x180>
  iunlockput(dp);
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	56                   	push   %esi
801054cd:	e8 7e c4 ff ff       	call   80101950 <iunlockput>
  ip->nlink--;
801054d2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054d7:	89 1c 24             	mov    %ebx,(%esp)
801054da:	e8 31 c1 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
801054df:	89 1c 24             	mov    %ebx,(%esp)
801054e2:	e8 69 c4 ff ff       	call   80101950 <iunlockput>
  end_op();
801054e7:	e8 64 d7 ff ff       	call   80102c50 <end_op>
  return 0;
801054ec:	83 c4 10             	add    $0x10,%esp
801054ef:	31 c0                	xor    %eax,%eax
}
801054f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054f4:	5b                   	pop    %ebx
801054f5:	5e                   	pop    %esi
801054f6:	5f                   	pop    %edi
801054f7:	5d                   	pop    %ebp
801054f8:	c3                   	ret    
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105500:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105504:	76 8d                	jbe    80105493 <sys_unlink+0xb3>
80105506:	bf 20 00 00 00       	mov    $0x20,%edi
8010550b:	eb 0f                	jmp    8010551c <sys_unlink+0x13c>
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
80105510:	83 c7 10             	add    $0x10,%edi
80105513:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105516:	0f 83 77 ff ff ff    	jae    80105493 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010551c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010551f:	6a 10                	push   $0x10
80105521:	57                   	push   %edi
80105522:	50                   	push   %eax
80105523:	53                   	push   %ebx
80105524:	e8 77 c4 ff ff       	call   801019a0 <readi>
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	83 f8 10             	cmp    $0x10,%eax
8010552f:	75 5e                	jne    8010558f <sys_unlink+0x1af>
    if(de.inum != 0)
80105531:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105536:	74 d8                	je     80105510 <sys_unlink+0x130>
    iunlockput(ip);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	53                   	push   %ebx
8010553c:	e8 0f c4 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105541:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	56                   	push   %esi
80105548:	e8 03 c4 ff ff       	call   80101950 <iunlockput>
  end_op();
8010554d:	e8 fe d6 ff ff       	call   80102c50 <end_op>
  return -1;
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555a:	eb 95                	jmp    801054f1 <sys_unlink+0x111>
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105560:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105565:	83 ec 0c             	sub    $0xc,%esp
80105568:	56                   	push   %esi
80105569:	e8 a2 c0 ff ff       	call   80101610 <iupdate>
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	e9 53 ff ff ff       	jmp    801054c9 <sys_unlink+0xe9>
    return -1;
80105576:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557b:	e9 71 ff ff ff       	jmp    801054f1 <sys_unlink+0x111>
    end_op();
80105580:	e8 cb d6 ff ff       	call   80102c50 <end_op>
    return -1;
80105585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558a:	e9 62 ff ff ff       	jmp    801054f1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010558f:	83 ec 0c             	sub    $0xc,%esp
80105592:	68 b8 7d 10 80       	push   $0x80107db8
80105597:	e8 f4 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010559c:	83 ec 0c             	sub    $0xc,%esp
8010559f:	68 a6 7d 10 80       	push   $0x80107da6
801055a4:	e8 e7 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801055a9:	83 ec 0c             	sub    $0xc,%esp
801055ac:	68 ca 7d 10 80       	push   $0x80107dca
801055b1:	e8 da ad ff ff       	call   80100390 <panic>
801055b6:	8d 76 00             	lea    0x0(%esi),%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_open>:

int
sys_open(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
801055c5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055cc:	50                   	push   %eax
801055cd:	6a 00                	push   $0x0
801055cf:	e8 2c f8 ff ff       	call   80104e00 <argstr>
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
801055d9:	0f 88 1d 01 00 00    	js     801056fc <sys_open+0x13c>
801055df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055e2:	83 ec 08             	sub    $0x8,%esp
801055e5:	50                   	push   %eax
801055e6:	6a 01                	push   $0x1
801055e8:	e8 63 f7 ff ff       	call   80104d50 <argint>
801055ed:	83 c4 10             	add    $0x10,%esp
801055f0:	85 c0                	test   %eax,%eax
801055f2:	0f 88 04 01 00 00    	js     801056fc <sys_open+0x13c>
    return -1;

  begin_op();
801055f8:	e8 e3 d5 ff ff       	call   80102be0 <begin_op>

  if(omode & O_CREATE){
801055fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105601:	0f 85 a9 00 00 00    	jne    801056b0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105607:	83 ec 0c             	sub    $0xc,%esp
8010560a:	ff 75 e0             	pushl  -0x20(%ebp)
8010560d:	e8 0e c9 ff ff       	call   80101f20 <namei>
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	85 c0                	test   %eax,%eax
80105617:	89 c6                	mov    %eax,%esi
80105619:	0f 84 b2 00 00 00    	je     801056d1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010561f:	83 ec 0c             	sub    $0xc,%esp
80105622:	50                   	push   %eax
80105623:	e8 98 c0 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105630:	0f 84 aa 00 00 00    	je     801056e0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105636:	e8 75 b7 ff ff       	call   80100db0 <filealloc>
8010563b:	85 c0                	test   %eax,%eax
8010563d:	89 c7                	mov    %eax,%edi
8010563f:	0f 84 a6 00 00 00    	je     801056eb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105645:	e8 a6 e2 ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010564a:	31 db                	xor    %ebx,%ebx
8010564c:	eb 0e                	jmp    8010565c <sys_open+0x9c>
8010564e:	66 90                	xchg   %ax,%ax
80105650:	83 c3 01             	add    $0x1,%ebx
80105653:	83 fb 10             	cmp    $0x10,%ebx
80105656:	0f 84 ac 00 00 00    	je     80105708 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010565c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105660:	85 d2                	test   %edx,%edx
80105662:	75 ec                	jne    80105650 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105664:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105667:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
  iunlock(ip);
8010566b:	56                   	push   %esi
8010566c:	e8 2f c1 ff ff       	call   801017a0 <iunlock>
  end_op();
80105671:	e8 da d5 ff ff       	call   80102c50 <end_op>

  f->type = FD_INODE;
80105676:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010567c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010567f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105682:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105685:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010568c:	89 d0                	mov    %edx,%eax
8010568e:	f7 d0                	not    %eax
80105690:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105693:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105696:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105699:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010569d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a0:	89 d8                	mov    %ebx,%eax
801056a2:	5b                   	pop    %ebx
801056a3:	5e                   	pop    %esi
801056a4:	5f                   	pop    %edi
801056a5:	5d                   	pop    %ebp
801056a6:	c3                   	ret    
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056b6:	31 c9                	xor    %ecx,%ecx
801056b8:	6a 00                	push   $0x0
801056ba:	ba 02 00 00 00       	mov    $0x2,%edx
801056bf:	e8 ec f7 ff ff       	call   80104eb0 <create>
    if(ip == 0){
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801056c9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056cb:	0f 85 65 ff ff ff    	jne    80105636 <sys_open+0x76>
      end_op();
801056d1:	e8 7a d5 ff ff       	call   80102c50 <end_op>
      return -1;
801056d6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056db:	eb c0                	jmp    8010569d <sys_open+0xdd>
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801056e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056e3:	85 c9                	test   %ecx,%ecx
801056e5:	0f 84 4b ff ff ff    	je     80105636 <sys_open+0x76>
    iunlockput(ip);
801056eb:	83 ec 0c             	sub    $0xc,%esp
801056ee:	56                   	push   %esi
801056ef:	e8 5c c2 ff ff       	call   80101950 <iunlockput>
    end_op();
801056f4:	e8 57 d5 ff ff       	call   80102c50 <end_op>
    return -1;
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105701:	eb 9a                	jmp    8010569d <sys_open+0xdd>
80105703:	90                   	nop
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105708:	83 ec 0c             	sub    $0xc,%esp
8010570b:	57                   	push   %edi
8010570c:	e8 5f b7 ff ff       	call   80100e70 <fileclose>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	eb d5                	jmp    801056eb <sys_open+0x12b>
80105716:	8d 76 00             	lea    0x0(%esi),%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <sys_mkdir>:

int
sys_mkdir(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105726:	e8 b5 d4 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010572b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010572e:	83 ec 08             	sub    $0x8,%esp
80105731:	50                   	push   %eax
80105732:	6a 00                	push   $0x0
80105734:	e8 c7 f6 ff ff       	call   80104e00 <argstr>
80105739:	83 c4 10             	add    $0x10,%esp
8010573c:	85 c0                	test   %eax,%eax
8010573e:	78 30                	js     80105770 <sys_mkdir+0x50>
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105746:	31 c9                	xor    %ecx,%ecx
80105748:	6a 00                	push   $0x0
8010574a:	ba 01 00 00 00       	mov    $0x1,%edx
8010574f:	e8 5c f7 ff ff       	call   80104eb0 <create>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	74 15                	je     80105770 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010575b:	83 ec 0c             	sub    $0xc,%esp
8010575e:	50                   	push   %eax
8010575f:	e8 ec c1 ff ff       	call   80101950 <iunlockput>
  end_op();
80105764:	e8 e7 d4 ff ff       	call   80102c50 <end_op>
  return 0;
80105769:	83 c4 10             	add    $0x10,%esp
8010576c:	31 c0                	xor    %eax,%eax
}
8010576e:	c9                   	leave  
8010576f:	c3                   	ret    
    end_op();
80105770:	e8 db d4 ff ff       	call   80102c50 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010577a:	c9                   	leave  
8010577b:	c3                   	ret    
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_mknod>:

int
sys_mknod(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105786:	e8 55 d4 ff ff       	call   80102be0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010578b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010578e:	83 ec 08             	sub    $0x8,%esp
80105791:	50                   	push   %eax
80105792:	6a 00                	push   $0x0
80105794:	e8 67 f6 ff ff       	call   80104e00 <argstr>
80105799:	83 c4 10             	add    $0x10,%esp
8010579c:	85 c0                	test   %eax,%eax
8010579e:	78 60                	js     80105800 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a3:	83 ec 08             	sub    $0x8,%esp
801057a6:	50                   	push   %eax
801057a7:	6a 01                	push   $0x1
801057a9:	e8 a2 f5 ff ff       	call   80104d50 <argint>
  if((argstr(0, &path)) < 0 ||
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	85 c0                	test   %eax,%eax
801057b3:	78 4b                	js     80105800 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801057b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b8:	83 ec 08             	sub    $0x8,%esp
801057bb:	50                   	push   %eax
801057bc:	6a 02                	push   $0x2
801057be:	e8 8d f5 ff ff       	call   80104d50 <argint>
     argint(1, &major) < 0 ||
801057c3:	83 c4 10             	add    $0x10,%esp
801057c6:	85 c0                	test   %eax,%eax
801057c8:	78 36                	js     80105800 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801057ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801057ce:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801057d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801057d5:	ba 03 00 00 00       	mov    $0x3,%edx
801057da:	50                   	push   %eax
801057db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057de:	e8 cd f6 ff ff       	call   80104eb0 <create>
801057e3:	83 c4 10             	add    $0x10,%esp
801057e6:	85 c0                	test   %eax,%eax
801057e8:	74 16                	je     80105800 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057ea:	83 ec 0c             	sub    $0xc,%esp
801057ed:	50                   	push   %eax
801057ee:	e8 5d c1 ff ff       	call   80101950 <iunlockput>
  end_op();
801057f3:	e8 58 d4 ff ff       	call   80102c50 <end_op>
  return 0;
801057f8:	83 c4 10             	add    $0x10,%esp
801057fb:	31 c0                	xor    %eax,%eax
}
801057fd:	c9                   	leave  
801057fe:	c3                   	ret    
801057ff:	90                   	nop
    end_op();
80105800:	e8 4b d4 ff ff       	call   80102c50 <end_op>
    return -1;
80105805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010580a:	c9                   	leave  
8010580b:	c3                   	ret    
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_chdir>:

int
sys_chdir(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	56                   	push   %esi
80105814:	53                   	push   %ebx
80105815:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  //struct proc *curproc = myproc();
  struct thread *curthread = mythread();
80105818:	e8 03 e1 ff ff       	call   80103920 <mythread>
8010581d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010581f:	e8 bc d3 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105824:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105827:	83 ec 08             	sub    $0x8,%esp
8010582a:	50                   	push   %eax
8010582b:	6a 00                	push   $0x0
8010582d:	e8 ce f5 ff ff       	call   80104e00 <argstr>
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	85 c0                	test   %eax,%eax
80105837:	78 77                	js     801058b0 <sys_chdir+0xa0>
80105839:	83 ec 0c             	sub    $0xc,%esp
8010583c:	ff 75 f4             	pushl  -0xc(%ebp)
8010583f:	e8 dc c6 ff ff       	call   80101f20 <namei>
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	85 c0                	test   %eax,%eax
80105849:	89 c3                	mov    %eax,%ebx
8010584b:	74 63                	je     801058b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	50                   	push   %eax
80105851:	e8 6a be ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010585e:	75 30                	jne    80105890 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	53                   	push   %ebx
80105864:	e8 37 bf ff ff       	call   801017a0 <iunlock>
  iput(curthread->cwd);
80105869:	58                   	pop    %eax
8010586a:	ff 76 20             	pushl  0x20(%esi)
8010586d:	e8 7e bf ff ff       	call   801017f0 <iput>
  end_op();
80105872:	e8 d9 d3 ff ff       	call   80102c50 <end_op>
  curthread->cwd = ip;
80105877:	89 5e 20             	mov    %ebx,0x20(%esi)
  return 0;
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	31 c0                	xor    %eax,%eax
}
8010587f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105882:	5b                   	pop    %ebx
80105883:	5e                   	pop    %esi
80105884:	5d                   	pop    %ebp
80105885:	c3                   	ret    
80105886:	8d 76 00             	lea    0x0(%esi),%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	53                   	push   %ebx
80105894:	e8 b7 c0 ff ff       	call   80101950 <iunlockput>
    end_op();
80105899:	e8 b2 d3 ff ff       	call   80102c50 <end_op>
    return -1;
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a6:	eb d7                	jmp    8010587f <sys_chdir+0x6f>
801058a8:	90                   	nop
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801058b0:	e8 9b d3 ff ff       	call   80102c50 <end_op>
    return -1;
801058b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ba:	eb c3                	jmp    8010587f <sys_chdir+0x6f>
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_exec>:

int
sys_exec(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
801058c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058d2:	50                   	push   %eax
801058d3:	6a 00                	push   $0x0
801058d5:	e8 26 f5 ff ff       	call   80104e00 <argstr>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	85 c0                	test   %eax,%eax
801058df:	0f 88 87 00 00 00    	js     8010596c <sys_exec+0xac>
801058e5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058eb:	83 ec 08             	sub    $0x8,%esp
801058ee:	50                   	push   %eax
801058ef:	6a 01                	push   $0x1
801058f1:	e8 5a f4 ff ff       	call   80104d50 <argint>
801058f6:	83 c4 10             	add    $0x10,%esp
801058f9:	85 c0                	test   %eax,%eax
801058fb:	78 6f                	js     8010596c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058fd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105903:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105906:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105908:	68 80 00 00 00       	push   $0x80
8010590d:	6a 00                	push   $0x0
8010590f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105915:	50                   	push   %eax
80105916:	e8 35 f1 ff ff       	call   80104a50 <memset>
8010591b:	83 c4 10             	add    $0x10,%esp
8010591e:	eb 2c                	jmp    8010594c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105920:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105926:	85 c0                	test   %eax,%eax
80105928:	74 56                	je     80105980 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010592a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105930:	83 ec 08             	sub    $0x8,%esp
80105933:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105936:	52                   	push   %edx
80105937:	50                   	push   %eax
80105938:	e8 a3 f3 ff ff       	call   80104ce0 <fetchstr>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 28                	js     8010596c <sys_exec+0xac>
  for(i=0;; i++){
80105944:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105947:	83 fb 20             	cmp    $0x20,%ebx
8010594a:	74 20                	je     8010596c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010594c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105952:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105959:	83 ec 08             	sub    $0x8,%esp
8010595c:	57                   	push   %edi
8010595d:	01 f0                	add    %esi,%eax
8010595f:	50                   	push   %eax
80105960:	e8 3b f3 ff ff       	call   80104ca0 <fetchint>
80105965:	83 c4 10             	add    $0x10,%esp
80105968:	85 c0                	test   %eax,%eax
8010596a:	79 b4                	jns    80105920 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010596c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010596f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105974:	5b                   	pop    %ebx
80105975:	5e                   	pop    %esi
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105980:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105986:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105989:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105990:	00 00 00 00 
  return exec(path, argv);
80105994:	50                   	push   %eax
80105995:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010599b:	e8 70 b0 ff ff       	call   80100a10 <exec>
801059a0:	83 c4 10             	add    $0x10,%esp
}
801059a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a6:	5b                   	pop    %ebx
801059a7:	5e                   	pop    %esi
801059a8:	5f                   	pop    %edi
801059a9:	5d                   	pop    %ebp
801059aa:	c3                   	ret    
801059ab:	90                   	nop
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_pipe>:

int
sys_pipe(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059bc:	6a 08                	push   $0x8
801059be:	50                   	push   %eax
801059bf:	6a 00                	push   $0x0
801059c1:	e8 da f3 ff ff       	call   80104da0 <argptr>
801059c6:	83 c4 10             	add    $0x10,%esp
801059c9:	85 c0                	test   %eax,%eax
801059cb:	0f 88 ae 00 00 00    	js     80105a7f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059d4:	83 ec 08             	sub    $0x8,%esp
801059d7:	50                   	push   %eax
801059d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059db:	50                   	push   %eax
801059dc:	e8 9f d8 ff ff       	call   80103280 <pipealloc>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	85 c0                	test   %eax,%eax
801059e6:	0f 88 93 00 00 00    	js     80105a7f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059ef:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801059f1:	e8 fa de ff ff       	call   801038f0 <myproc>
801059f6:	eb 10                	jmp    80105a08 <sys_pipe+0x58>
801059f8:	90                   	nop
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a00:	83 c3 01             	add    $0x1,%ebx
80105a03:	83 fb 10             	cmp    $0x10,%ebx
80105a06:	74 60                	je     80105a68 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a08:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
80105a0c:	85 f6                	test   %esi,%esi
80105a0e:	75 f0                	jne    80105a00 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a10:	8d 73 08             	lea    0x8(%ebx),%esi
80105a13:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a19:	e8 d2 de ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a1e:	31 d2                	xor    %edx,%edx
80105a20:	eb 0e                	jmp    80105a30 <sys_pipe+0x80>
80105a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a28:	83 c2 01             	add    $0x1,%edx
80105a2b:	83 fa 10             	cmp    $0x10,%edx
80105a2e:	74 28                	je     80105a58 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105a30:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
80105a34:	85 c9                	test   %ecx,%ecx
80105a36:	75 f0                	jne    80105a28 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105a38:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a3f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a41:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a44:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a47:	31 c0                	xor    %eax,%eax
}
80105a49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a4c:	5b                   	pop    %ebx
80105a4d:	5e                   	pop    %esi
80105a4e:	5f                   	pop    %edi
80105a4f:	5d                   	pop    %ebp
80105a50:	c3                   	ret    
80105a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105a58:	e8 93 de ff ff       	call   801038f0 <myproc>
80105a5d:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
80105a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(rf);
80105a68:	83 ec 0c             	sub    $0xc,%esp
80105a6b:	ff 75 e0             	pushl  -0x20(%ebp)
80105a6e:	e8 fd b3 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105a73:	58                   	pop    %eax
80105a74:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a77:	e8 f4 b3 ff ff       	call   80100e70 <fileclose>
    return -1;
80105a7c:	83 c4 10             	add    $0x10,%esp
80105a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a84:	eb c3                	jmp    80105a49 <sys_pipe+0x99>
80105a86:	66 90                	xchg   %ax,%ax
80105a88:	66 90                	xchg   %ax,%ax
80105a8a:	66 90                	xchg   %ax,%ax
80105a8c:	66 90                	xchg   %ax,%ax
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105a93:	5d                   	pop    %ebp
  return fork();
80105a94:	e9 c7 e0 ff ff       	jmp    80103b60 <fork>
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105aa0 <sys_exit>:

int
sys_exit(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105aa6:	e8 15 e6 ff ff       	call   801040c0 <exit>
  return 0;  // not reached
}
80105aab:	31 c0                	xor    %eax,%eax
80105aad:	c9                   	leave  
80105aae:	c3                   	ret    
80105aaf:	90                   	nop

80105ab0 <sys_wait>:

int
sys_wait(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ab3:	5d                   	pop    %ebp
  return wait();
80105ab4:	e9 37 e8 ff ff       	jmp    801042f0 <wait>
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_kill>:

int
sys_kill(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac9:	50                   	push   %eax
80105aca:	6a 00                	push   $0x0
80105acc:	e8 7f f2 ff ff       	call   80104d50 <argint>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	78 18                	js     80105af0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ade:	e8 2d ea ff ff       	call   80104510 <kill>
80105ae3:	83 c4 10             	add    $0x10,%esp
}
80105ae6:	c9                   	leave  
80105ae7:	c3                   	ret    
80105ae8:	90                   	nop
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b00 <sys_getpid>:

int
sys_getpid(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b06:	e8 e5 dd ff ff       	call   801038f0 <myproc>
80105b0b:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105b0e:	c9                   	leave  
80105b0f:	c3                   	ret    

80105b10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 2e f2 ff ff       	call   80104d50 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 27                	js     80105b50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b29:	e8 c2 dd ff ff       	call   801038f0 <myproc>
  if(growproc(n) < 0)
80105b2e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b31:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b33:	ff 75 f4             	pushl  -0xc(%ebp)
80105b36:	e8 85 df ff ff       	call   80103ac0 <growproc>
80105b3b:	83 c4 10             	add    $0x10,%esp
80105b3e:	85 c0                	test   %eax,%eax
80105b40:	78 0e                	js     80105b50 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b42:	89 d8                	mov    %ebx,%eax
80105b44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b47:	c9                   	leave  
80105b48:	c3                   	ret    
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b55:	eb eb                	jmp    80105b42 <sys_sbrk+0x32>
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <sys_sleep>:

int
sys_sleep(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b6a:	50                   	push   %eax
80105b6b:	6a 00                	push   $0x0
80105b6d:	e8 de f1 ff ff       	call   80104d50 <argint>
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	85 c0                	test   %eax,%eax
80105b77:	0f 88 8a 00 00 00    	js     80105c07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 a0 3c 12 80       	push   $0x80123ca0
80105b85:	e8 a6 ed ff ff       	call   80104930 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b8d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105b90:	8b 1d e0 44 12 80    	mov    0x801244e0,%ebx
  while(ticks - ticks0 < n){
80105b96:	85 d2                	test   %edx,%edx
80105b98:	75 27                	jne    80105bc1 <sys_sleep+0x61>
80105b9a:	eb 54                	jmp    80105bf0 <sys_sleep+0x90>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ba0:	83 ec 08             	sub    $0x8,%esp
80105ba3:	68 a0 3c 12 80       	push   $0x80123ca0
80105ba8:	68 e0 44 12 80       	push   $0x801244e0
80105bad:	e8 6e e3 ff ff       	call   80103f20 <sleep>
  while(ticks - ticks0 < n){
80105bb2:	a1 e0 44 12 80       	mov    0x801244e0,%eax
80105bb7:	83 c4 10             	add    $0x10,%esp
80105bba:	29 d8                	sub    %ebx,%eax
80105bbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105bbf:	73 2f                	jae    80105bf0 <sys_sleep+0x90>
    if(myproc()->killed){
80105bc1:	e8 2a dd ff ff       	call   801038f0 <myproc>
80105bc6:	8b 40 1c             	mov    0x1c(%eax),%eax
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	74 d3                	je     80105ba0 <sys_sleep+0x40>
      release(&tickslock);
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	68 a0 3c 12 80       	push   $0x80123ca0
80105bd5:	e8 16 ee ff ff       	call   801049f0 <release>
      return -1;
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be5:	c9                   	leave  
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	68 a0 3c 12 80       	push   $0x80123ca0
80105bf8:	e8 f3 ed ff ff       	call   801049f0 <release>
  return 0;
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	31 c0                	xor    %eax,%eax
}
80105c02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    
    return -1;
80105c07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0c:	eb f4                	jmp    80105c02 <sys_sleep+0xa2>
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	53                   	push   %ebx
80105c14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c17:	68 a0 3c 12 80       	push   $0x80123ca0
80105c1c:	e8 0f ed ff ff       	call   80104930 <acquire>
  xticks = ticks;
80105c21:	8b 1d e0 44 12 80    	mov    0x801244e0,%ebx
  release(&tickslock);
80105c27:	c7 04 24 a0 3c 12 80 	movl   $0x80123ca0,(%esp)
80105c2e:	e8 bd ed ff ff       	call   801049f0 <release>
  return xticks;
}
80105c33:	89 d8                	mov    %ebx,%eax
80105c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c38:	c9                   	leave  
80105c39:	c3                   	ret    

80105c3a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c3a:	1e                   	push   %ds
  pushl %es
80105c3b:	06                   	push   %es
  pushl %fs
80105c3c:	0f a0                	push   %fs
  pushl %gs
80105c3e:	0f a8                	push   %gs
  pushal
80105c40:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c41:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c45:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c47:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c49:	54                   	push   %esp
  call trap
80105c4a:	e8 c1 00 00 00       	call   80105d10 <trap>
  addl $4, %esp
80105c4f:	83 c4 04             	add    $0x4,%esp

80105c52 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c52:	61                   	popa   
  popl %gs
80105c53:	0f a9                	pop    %gs
  popl %fs
80105c55:	0f a1                	pop    %fs
  popl %es
80105c57:	07                   	pop    %es
  popl %ds
80105c58:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c59:	83 c4 08             	add    $0x8,%esp
  iret
80105c5c:	cf                   	iret   
80105c5d:	66 90                	xchg   %ax,%ax
80105c5f:	90                   	nop

80105c60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c60:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c61:	31 c0                	xor    %eax,%eax
{
80105c63:	89 e5                	mov    %esp,%ebp
80105c65:	83 ec 08             	sub    $0x8,%esp
80105c68:	90                   	nop
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c70:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c77:	c7 04 c5 e2 3c 12 80 	movl   $0x8e000008,-0x7fedc31e(,%eax,8)
80105c7e:	08 00 00 8e 
80105c82:	66 89 14 c5 e0 3c 12 	mov    %dx,-0x7fedc320(,%eax,8)
80105c89:	80 
80105c8a:	c1 ea 10             	shr    $0x10,%edx
80105c8d:	66 89 14 c5 e6 3c 12 	mov    %dx,-0x7fedc31a(,%eax,8)
80105c94:	80 
  for(i = 0; i < 256; i++)
80105c95:	83 c0 01             	add    $0x1,%eax
80105c98:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c9d:	75 d1                	jne    80105c70 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c9f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105ca4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ca7:	c7 05 e2 3e 12 80 08 	movl   $0xef000008,0x80123ee2
80105cae:	00 00 ef 
  initlock(&tickslock, "time");
80105cb1:	68 d9 7d 10 80       	push   $0x80107dd9
80105cb6:	68 a0 3c 12 80       	push   $0x80123ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cbb:	66 a3 e0 3e 12 80    	mov    %ax,0x80123ee0
80105cc1:	c1 e8 10             	shr    $0x10,%eax
80105cc4:	66 a3 e6 3e 12 80    	mov    %ax,0x80123ee6
  initlock(&tickslock, "time");
80105cca:	e8 21 eb ff ff       	call   801047f0 <initlock>
}
80105ccf:	83 c4 10             	add    $0x10,%esp
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    
80105cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ce0 <idtinit>:

void
idtinit(void)
{
80105ce0:	55                   	push   %ebp
  pd[0] = size-1;
80105ce1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ce6:	89 e5                	mov    %esp,%ebp
80105ce8:	83 ec 10             	sub    $0x10,%esp
80105ceb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cef:	b8 e0 3c 12 80       	mov    $0x80123ce0,%eax
80105cf4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cf8:	c1 e8 10             	shr    $0x10,%eax
80105cfb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
80105d15:	53                   	push   %ebx
80105d16:	83 ec 1c             	sub    $0x1c,%esp
80105d19:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d1c:	8b 47 30             	mov    0x30(%edi),%eax
80105d1f:	83 f8 40             	cmp    $0x40,%eax
80105d22:	0f 84 f0 00 00 00    	je     80105e18 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d28:	83 e8 20             	sub    $0x20,%eax
80105d2b:	83 f8 1f             	cmp    $0x1f,%eax
80105d2e:	77 10                	ja     80105d40 <trap+0x30>
80105d30:	ff 24 85 80 7e 10 80 	jmp    *-0x7fef8180(,%eax,4)
80105d37:	89 f6                	mov    %esi,%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d40:	e8 ab db ff ff       	call   801038f0 <myproc>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d4a:	0f 84 14 02 00 00    	je     80105f64 <trap+0x254>
80105d50:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d54:	0f 84 0a 02 00 00    	je     80105f64 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d5a:	0f 20 d1             	mov    %cr2,%ecx
80105d5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d60:	e8 6b db ff ff       	call   801038d0 <cpuid>
80105d65:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d68:	8b 47 34             	mov    0x34(%edi),%eax
80105d6b:	8b 77 30             	mov    0x30(%edi),%esi
80105d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d71:	e8 7a db ff ff       	call   801038f0 <myproc>
80105d76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d79:	e8 72 db ff ff       	call   801038f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d84:	51                   	push   %ecx
80105d85:	53                   	push   %ebx
80105d86:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105d87:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d8a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d8d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d8e:	83 c2 60             	add    $0x60,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d91:	52                   	push   %edx
80105d92:	ff 70 0c             	pushl  0xc(%eax)
80105d95:	68 3c 7e 10 80       	push   $0x80107e3c
80105d9a:	e8 c1 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d9f:	83 c4 20             	add    $0x20,%esp
80105da2:	e8 49 db ff ff       	call   801038f0 <myproc>
80105da7:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dae:	e8 3d db ff ff       	call   801038f0 <myproc>
80105db3:	85 c0                	test   %eax,%eax
80105db5:	74 1d                	je     80105dd4 <trap+0xc4>
80105db7:	e8 34 db ff ff       	call   801038f0 <myproc>
80105dbc:	8b 50 1c             	mov    0x1c(%eax),%edx
80105dbf:	85 d2                	test   %edx,%edx
80105dc1:	74 11                	je     80105dd4 <trap+0xc4>
80105dc3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105dc7:	83 e0 03             	and    $0x3,%eax
80105dca:	66 83 f8 03          	cmp    $0x3,%ax
80105dce:	0f 84 4c 01 00 00    	je     80105f20 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105dd4:	e8 17 db ff ff       	call   801038f0 <myproc>
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	74 0b                	je     80105de8 <trap+0xd8>
80105ddd:	e8 0e db ff ff       	call   801038f0 <myproc>
80105de2:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80105de6:	74 68                	je     80105e50 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105de8:	e8 03 db ff ff       	call   801038f0 <myproc>
80105ded:	85 c0                	test   %eax,%eax
80105def:	74 19                	je     80105e0a <trap+0xfa>
80105df1:	e8 fa da ff ff       	call   801038f0 <myproc>
80105df6:	8b 40 1c             	mov    0x1c(%eax),%eax
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	74 0d                	je     80105e0a <trap+0xfa>
80105dfd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e01:	83 e0 03             	and    $0x3,%eax
80105e04:	66 83 f8 03          	cmp    $0x3,%ax
80105e08:	74 37                	je     80105e41 <trap+0x131>
    exit();
}
80105e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e0d:	5b                   	pop    %ebx
80105e0e:	5e                   	pop    %esi
80105e0f:	5f                   	pop    %edi
80105e10:	5d                   	pop    %ebp
80105e11:	c3                   	ret    
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e18:	e8 d3 da ff ff       	call   801038f0 <myproc>
80105e1d:	8b 58 1c             	mov    0x1c(%eax),%ebx
80105e20:	85 db                	test   %ebx,%ebx
80105e22:	0f 85 e8 00 00 00    	jne    80105f10 <trap+0x200>
    mythread()->tf = tf;
80105e28:	e8 f3 da ff ff       	call   80103920 <mythread>
80105e2d:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
80105e30:	e8 0b f0 ff ff       	call   80104e40 <syscall>
    if(myproc()->killed)
80105e35:	e8 b6 da ff ff       	call   801038f0 <myproc>
80105e3a:	8b 48 1c             	mov    0x1c(%eax),%ecx
80105e3d:	85 c9                	test   %ecx,%ecx
80105e3f:	74 c9                	je     80105e0a <trap+0xfa>
}
80105e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e44:	5b                   	pop    %ebx
80105e45:	5e                   	pop    %esi
80105e46:	5f                   	pop    %edi
80105e47:	5d                   	pop    %ebp
      exit();
80105e48:	e9 73 e2 ff ff       	jmp    801040c0 <exit>
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105e50:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e54:	75 92                	jne    80105de8 <trap+0xd8>
    yield();
80105e56:	e8 75 e0 ff ff       	call   80103ed0 <yield>
80105e5b:	eb 8b                	jmp    80105de8 <trap+0xd8>
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105e60:	e8 6b da ff ff       	call   801038d0 <cpuid>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	0f 84 c3 00 00 00    	je     80105f30 <trap+0x220>
    lapiceoi();
80105e6d:	e8 1e c9 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e72:	e8 79 da ff ff       	call   801038f0 <myproc>
80105e77:	85 c0                	test   %eax,%eax
80105e79:	0f 85 38 ff ff ff    	jne    80105db7 <trap+0xa7>
80105e7f:	e9 50 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e88:	e8 c3 c7 ff ff       	call   80102650 <kbdintr>
    lapiceoi();
80105e8d:	e8 fe c8 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e92:	e8 59 da ff ff       	call   801038f0 <myproc>
80105e97:	85 c0                	test   %eax,%eax
80105e99:	0f 85 18 ff ff ff    	jne    80105db7 <trap+0xa7>
80105e9f:	e9 30 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ea8:	e8 53 02 00 00       	call   80106100 <uartintr>
    lapiceoi();
80105ead:	e8 de c8 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eb2:	e8 39 da ff ff       	call   801038f0 <myproc>
80105eb7:	85 c0                	test   %eax,%eax
80105eb9:	0f 85 f8 fe ff ff    	jne    80105db7 <trap+0xa7>
80105ebf:	e9 10 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ec8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105ecc:	8b 77 38             	mov    0x38(%edi),%esi
80105ecf:	e8 fc d9 ff ff       	call   801038d0 <cpuid>
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	50                   	push   %eax
80105ed7:	68 e4 7d 10 80       	push   $0x80107de4
80105edc:	e8 7f a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105ee1:	e8 aa c8 ff ff       	call   80102790 <lapiceoi>
    break;
80105ee6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ee9:	e8 02 da ff ff       	call   801038f0 <myproc>
80105eee:	85 c0                	test   %eax,%eax
80105ef0:	0f 85 c1 fe ff ff    	jne    80105db7 <trap+0xa7>
80105ef6:	e9 d9 fe ff ff       	jmp    80105dd4 <trap+0xc4>
80105efb:	90                   	nop
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f00:	e8 bb c1 ff ff       	call   801020c0 <ideintr>
80105f05:	e9 63 ff ff ff       	jmp    80105e6d <trap+0x15d>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f10:	e8 ab e1 ff ff       	call   801040c0 <exit>
80105f15:	e9 0e ff ff ff       	jmp    80105e28 <trap+0x118>
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f20:	e8 9b e1 ff ff       	call   801040c0 <exit>
80105f25:	e9 aa fe ff ff       	jmp    80105dd4 <trap+0xc4>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	68 a0 3c 12 80       	push   $0x80123ca0
80105f38:	e8 f3 e9 ff ff       	call   80104930 <acquire>
      wakeup(&ticks);
80105f3d:	c7 04 24 e0 44 12 80 	movl   $0x801244e0,(%esp)
      ticks++;
80105f44:	83 05 e0 44 12 80 01 	addl   $0x1,0x801244e0
      wakeup(&ticks);
80105f4b:	e8 30 e5 ff ff       	call   80104480 <wakeup>
      release(&tickslock);
80105f50:	c7 04 24 a0 3c 12 80 	movl   $0x80123ca0,(%esp)
80105f57:	e8 94 ea ff ff       	call   801049f0 <release>
80105f5c:	83 c4 10             	add    $0x10,%esp
80105f5f:	e9 09 ff ff ff       	jmp    80105e6d <trap+0x15d>
80105f64:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f67:	e8 64 d9 ff ff       	call   801038d0 <cpuid>
80105f6c:	83 ec 0c             	sub    $0xc,%esp
80105f6f:	56                   	push   %esi
80105f70:	53                   	push   %ebx
80105f71:	50                   	push   %eax
80105f72:	ff 77 30             	pushl  0x30(%edi)
80105f75:	68 08 7e 10 80       	push   $0x80107e08
80105f7a:	e8 e1 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105f7f:	83 c4 14             	add    $0x14,%esp
80105f82:	68 de 7d 10 80       	push   $0x80107dde
80105f87:	e8 04 a4 ff ff       	call   80100390 <panic>
80105f8c:	66 90                	xchg   %ax,%ax
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f90:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
{
80105f95:	55                   	push   %ebp
80105f96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f98:	85 c0                	test   %eax,%eax
80105f9a:	74 1c                	je     80105fb8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fa1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fa2:	a8 01                	test   $0x1,%al
80105fa4:	74 12                	je     80105fb8 <uartgetc+0x28>
80105fa6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fac:	0f b6 c0             	movzbl %al,%eax
}
80105faf:	5d                   	pop    %ebp
80105fb0:	c3                   	ret    
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fbd:	5d                   	pop    %ebp
80105fbe:	c3                   	ret    
80105fbf:	90                   	nop

80105fc0 <uartputc.part.0>:
uartputc(int c)
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
80105fc6:	89 c7                	mov    %eax,%edi
80105fc8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fcd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fd2:	83 ec 0c             	sub    $0xc,%esp
80105fd5:	eb 1b                	jmp    80105ff2 <uartputc.part.0+0x32>
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	6a 0a                	push   $0xa
80105fe5:	e8 c6 c7 ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	83 eb 01             	sub    $0x1,%ebx
80105ff0:	74 07                	je     80105ff9 <uartputc.part.0+0x39>
80105ff2:	89 f2                	mov    %esi,%edx
80105ff4:	ec                   	in     (%dx),%al
80105ff5:	a8 20                	test   $0x20,%al
80105ff7:	74 e7                	je     80105fe0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ff9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffe:	89 f8                	mov    %edi,%eax
80106000:	ee                   	out    %al,(%dx)
}
80106001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106004:	5b                   	pop    %ebx
80106005:	5e                   	pop    %esi
80106006:	5f                   	pop    %edi
80106007:	5d                   	pop    %ebp
80106008:	c3                   	ret    
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106010 <uartinit>:
{
80106010:	55                   	push   %ebp
80106011:	31 c9                	xor    %ecx,%ecx
80106013:	89 c8                	mov    %ecx,%eax
80106015:	89 e5                	mov    %esp,%ebp
80106017:	57                   	push   %edi
80106018:	56                   	push   %esi
80106019:	53                   	push   %ebx
8010601a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010601f:	89 da                	mov    %ebx,%edx
80106021:	83 ec 0c             	sub    $0xc,%esp
80106024:	ee                   	out    %al,(%dx)
80106025:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010602a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010602f:	89 fa                	mov    %edi,%edx
80106031:	ee                   	out    %al,(%dx)
80106032:	b8 0c 00 00 00       	mov    $0xc,%eax
80106037:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010603c:	ee                   	out    %al,(%dx)
8010603d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106042:	89 c8                	mov    %ecx,%eax
80106044:	89 f2                	mov    %esi,%edx
80106046:	ee                   	out    %al,(%dx)
80106047:	b8 03 00 00 00       	mov    $0x3,%eax
8010604c:	89 fa                	mov    %edi,%edx
8010604e:	ee                   	out    %al,(%dx)
8010604f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106054:	89 c8                	mov    %ecx,%eax
80106056:	ee                   	out    %al,(%dx)
80106057:	b8 01 00 00 00       	mov    $0x1,%eax
8010605c:	89 f2                	mov    %esi,%edx
8010605e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010605f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106064:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106065:	3c ff                	cmp    $0xff,%al
80106067:	74 5a                	je     801060c3 <uartinit+0xb3>
  uart = 1;
80106069:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106070:	00 00 00 
80106073:	89 da                	mov    %ebx,%edx
80106075:	ec                   	in     (%dx),%al
80106076:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010607b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010607c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010607f:	bb 00 7f 10 80       	mov    $0x80107f00,%ebx
  ioapicenable(IRQ_COM1, 0);
80106084:	6a 00                	push   $0x0
80106086:	6a 04                	push   $0x4
80106088:	e8 83 c2 ff ff       	call   80102310 <ioapicenable>
8010608d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106090:	b8 78 00 00 00       	mov    $0x78,%eax
80106095:	eb 13                	jmp    801060aa <uartinit+0x9a>
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060a0:	83 c3 01             	add    $0x1,%ebx
801060a3:	0f be 03             	movsbl (%ebx),%eax
801060a6:	84 c0                	test   %al,%al
801060a8:	74 19                	je     801060c3 <uartinit+0xb3>
  if(!uart)
801060aa:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
801060b0:	85 d2                	test   %edx,%edx
801060b2:	74 ec                	je     801060a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801060b4:	83 c3 01             	add    $0x1,%ebx
801060b7:	e8 04 ff ff ff       	call   80105fc0 <uartputc.part.0>
801060bc:	0f be 03             	movsbl (%ebx),%eax
801060bf:	84 c0                	test   %al,%al
801060c1:	75 e7                	jne    801060aa <uartinit+0x9a>
}
801060c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c6:	5b                   	pop    %ebx
801060c7:	5e                   	pop    %esi
801060c8:	5f                   	pop    %edi
801060c9:	5d                   	pop    %ebp
801060ca:	c3                   	ret    
801060cb:	90                   	nop
801060cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060d0 <uartputc>:
  if(!uart)
801060d0:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
801060d6:	55                   	push   %ebp
801060d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060d9:	85 d2                	test   %edx,%edx
{
801060db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801060de:	74 10                	je     801060f0 <uartputc+0x20>
}
801060e0:	5d                   	pop    %ebp
801060e1:	e9 da fe ff ff       	jmp    80105fc0 <uartputc.part.0>
801060e6:	8d 76 00             	lea    0x0(%esi),%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060f0:	5d                   	pop    %ebp
801060f1:	c3                   	ret    
801060f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106100 <uartintr>:

void
uartintr(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106106:	68 90 5f 10 80       	push   $0x80105f90
8010610b:	e8 00 a7 ff ff       	call   80100810 <consoleintr>
}
80106110:	83 c4 10             	add    $0x10,%esp
80106113:	c9                   	leave  
80106114:	c3                   	ret    

80106115 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $0
80106117:	6a 00                	push   $0x0
  jmp alltraps
80106119:	e9 1c fb ff ff       	jmp    80105c3a <alltraps>

8010611e <vector1>:
.globl vector1
vector1:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $1
80106120:	6a 01                	push   $0x1
  jmp alltraps
80106122:	e9 13 fb ff ff       	jmp    80105c3a <alltraps>

80106127 <vector2>:
.globl vector2
vector2:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $2
80106129:	6a 02                	push   $0x2
  jmp alltraps
8010612b:	e9 0a fb ff ff       	jmp    80105c3a <alltraps>

80106130 <vector3>:
.globl vector3
vector3:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $3
80106132:	6a 03                	push   $0x3
  jmp alltraps
80106134:	e9 01 fb ff ff       	jmp    80105c3a <alltraps>

80106139 <vector4>:
.globl vector4
vector4:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $4
8010613b:	6a 04                	push   $0x4
  jmp alltraps
8010613d:	e9 f8 fa ff ff       	jmp    80105c3a <alltraps>

80106142 <vector5>:
.globl vector5
vector5:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $5
80106144:	6a 05                	push   $0x5
  jmp alltraps
80106146:	e9 ef fa ff ff       	jmp    80105c3a <alltraps>

8010614b <vector6>:
.globl vector6
vector6:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $6
8010614d:	6a 06                	push   $0x6
  jmp alltraps
8010614f:	e9 e6 fa ff ff       	jmp    80105c3a <alltraps>

80106154 <vector7>:
.globl vector7
vector7:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $7
80106156:	6a 07                	push   $0x7
  jmp alltraps
80106158:	e9 dd fa ff ff       	jmp    80105c3a <alltraps>

8010615d <vector8>:
.globl vector8
vector8:
  pushl $8
8010615d:	6a 08                	push   $0x8
  jmp alltraps
8010615f:	e9 d6 fa ff ff       	jmp    80105c3a <alltraps>

80106164 <vector9>:
.globl vector9
vector9:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $9
80106166:	6a 09                	push   $0x9
  jmp alltraps
80106168:	e9 cd fa ff ff       	jmp    80105c3a <alltraps>

8010616d <vector10>:
.globl vector10
vector10:
  pushl $10
8010616d:	6a 0a                	push   $0xa
  jmp alltraps
8010616f:	e9 c6 fa ff ff       	jmp    80105c3a <alltraps>

80106174 <vector11>:
.globl vector11
vector11:
  pushl $11
80106174:	6a 0b                	push   $0xb
  jmp alltraps
80106176:	e9 bf fa ff ff       	jmp    80105c3a <alltraps>

8010617b <vector12>:
.globl vector12
vector12:
  pushl $12
8010617b:	6a 0c                	push   $0xc
  jmp alltraps
8010617d:	e9 b8 fa ff ff       	jmp    80105c3a <alltraps>

80106182 <vector13>:
.globl vector13
vector13:
  pushl $13
80106182:	6a 0d                	push   $0xd
  jmp alltraps
80106184:	e9 b1 fa ff ff       	jmp    80105c3a <alltraps>

80106189 <vector14>:
.globl vector14
vector14:
  pushl $14
80106189:	6a 0e                	push   $0xe
  jmp alltraps
8010618b:	e9 aa fa ff ff       	jmp    80105c3a <alltraps>

80106190 <vector15>:
.globl vector15
vector15:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $15
80106192:	6a 0f                	push   $0xf
  jmp alltraps
80106194:	e9 a1 fa ff ff       	jmp    80105c3a <alltraps>

80106199 <vector16>:
.globl vector16
vector16:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $16
8010619b:	6a 10                	push   $0x10
  jmp alltraps
8010619d:	e9 98 fa ff ff       	jmp    80105c3a <alltraps>

801061a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061a2:	6a 11                	push   $0x11
  jmp alltraps
801061a4:	e9 91 fa ff ff       	jmp    80105c3a <alltraps>

801061a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $18
801061ab:	6a 12                	push   $0x12
  jmp alltraps
801061ad:	e9 88 fa ff ff       	jmp    80105c3a <alltraps>

801061b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $19
801061b4:	6a 13                	push   $0x13
  jmp alltraps
801061b6:	e9 7f fa ff ff       	jmp    80105c3a <alltraps>

801061bb <vector20>:
.globl vector20
vector20:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $20
801061bd:	6a 14                	push   $0x14
  jmp alltraps
801061bf:	e9 76 fa ff ff       	jmp    80105c3a <alltraps>

801061c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $21
801061c6:	6a 15                	push   $0x15
  jmp alltraps
801061c8:	e9 6d fa ff ff       	jmp    80105c3a <alltraps>

801061cd <vector22>:
.globl vector22
vector22:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $22
801061cf:	6a 16                	push   $0x16
  jmp alltraps
801061d1:	e9 64 fa ff ff       	jmp    80105c3a <alltraps>

801061d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $23
801061d8:	6a 17                	push   $0x17
  jmp alltraps
801061da:	e9 5b fa ff ff       	jmp    80105c3a <alltraps>

801061df <vector24>:
.globl vector24
vector24:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $24
801061e1:	6a 18                	push   $0x18
  jmp alltraps
801061e3:	e9 52 fa ff ff       	jmp    80105c3a <alltraps>

801061e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $25
801061ea:	6a 19                	push   $0x19
  jmp alltraps
801061ec:	e9 49 fa ff ff       	jmp    80105c3a <alltraps>

801061f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $26
801061f3:	6a 1a                	push   $0x1a
  jmp alltraps
801061f5:	e9 40 fa ff ff       	jmp    80105c3a <alltraps>

801061fa <vector27>:
.globl vector27
vector27:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $27
801061fc:	6a 1b                	push   $0x1b
  jmp alltraps
801061fe:	e9 37 fa ff ff       	jmp    80105c3a <alltraps>

80106203 <vector28>:
.globl vector28
vector28:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $28
80106205:	6a 1c                	push   $0x1c
  jmp alltraps
80106207:	e9 2e fa ff ff       	jmp    80105c3a <alltraps>

8010620c <vector29>:
.globl vector29
vector29:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $29
8010620e:	6a 1d                	push   $0x1d
  jmp alltraps
80106210:	e9 25 fa ff ff       	jmp    80105c3a <alltraps>

80106215 <vector30>:
.globl vector30
vector30:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $30
80106217:	6a 1e                	push   $0x1e
  jmp alltraps
80106219:	e9 1c fa ff ff       	jmp    80105c3a <alltraps>

8010621e <vector31>:
.globl vector31
vector31:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $31
80106220:	6a 1f                	push   $0x1f
  jmp alltraps
80106222:	e9 13 fa ff ff       	jmp    80105c3a <alltraps>

80106227 <vector32>:
.globl vector32
vector32:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $32
80106229:	6a 20                	push   $0x20
  jmp alltraps
8010622b:	e9 0a fa ff ff       	jmp    80105c3a <alltraps>

80106230 <vector33>:
.globl vector33
vector33:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $33
80106232:	6a 21                	push   $0x21
  jmp alltraps
80106234:	e9 01 fa ff ff       	jmp    80105c3a <alltraps>

80106239 <vector34>:
.globl vector34
vector34:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $34
8010623b:	6a 22                	push   $0x22
  jmp alltraps
8010623d:	e9 f8 f9 ff ff       	jmp    80105c3a <alltraps>

80106242 <vector35>:
.globl vector35
vector35:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $35
80106244:	6a 23                	push   $0x23
  jmp alltraps
80106246:	e9 ef f9 ff ff       	jmp    80105c3a <alltraps>

8010624b <vector36>:
.globl vector36
vector36:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $36
8010624d:	6a 24                	push   $0x24
  jmp alltraps
8010624f:	e9 e6 f9 ff ff       	jmp    80105c3a <alltraps>

80106254 <vector37>:
.globl vector37
vector37:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $37
80106256:	6a 25                	push   $0x25
  jmp alltraps
80106258:	e9 dd f9 ff ff       	jmp    80105c3a <alltraps>

8010625d <vector38>:
.globl vector38
vector38:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $38
8010625f:	6a 26                	push   $0x26
  jmp alltraps
80106261:	e9 d4 f9 ff ff       	jmp    80105c3a <alltraps>

80106266 <vector39>:
.globl vector39
vector39:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $39
80106268:	6a 27                	push   $0x27
  jmp alltraps
8010626a:	e9 cb f9 ff ff       	jmp    80105c3a <alltraps>

8010626f <vector40>:
.globl vector40
vector40:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $40
80106271:	6a 28                	push   $0x28
  jmp alltraps
80106273:	e9 c2 f9 ff ff       	jmp    80105c3a <alltraps>

80106278 <vector41>:
.globl vector41
vector41:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $41
8010627a:	6a 29                	push   $0x29
  jmp alltraps
8010627c:	e9 b9 f9 ff ff       	jmp    80105c3a <alltraps>

80106281 <vector42>:
.globl vector42
vector42:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $42
80106283:	6a 2a                	push   $0x2a
  jmp alltraps
80106285:	e9 b0 f9 ff ff       	jmp    80105c3a <alltraps>

8010628a <vector43>:
.globl vector43
vector43:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $43
8010628c:	6a 2b                	push   $0x2b
  jmp alltraps
8010628e:	e9 a7 f9 ff ff       	jmp    80105c3a <alltraps>

80106293 <vector44>:
.globl vector44
vector44:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $44
80106295:	6a 2c                	push   $0x2c
  jmp alltraps
80106297:	e9 9e f9 ff ff       	jmp    80105c3a <alltraps>

8010629c <vector45>:
.globl vector45
vector45:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $45
8010629e:	6a 2d                	push   $0x2d
  jmp alltraps
801062a0:	e9 95 f9 ff ff       	jmp    80105c3a <alltraps>

801062a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $46
801062a7:	6a 2e                	push   $0x2e
  jmp alltraps
801062a9:	e9 8c f9 ff ff       	jmp    80105c3a <alltraps>

801062ae <vector47>:
.globl vector47
vector47:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $47
801062b0:	6a 2f                	push   $0x2f
  jmp alltraps
801062b2:	e9 83 f9 ff ff       	jmp    80105c3a <alltraps>

801062b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $48
801062b9:	6a 30                	push   $0x30
  jmp alltraps
801062bb:	e9 7a f9 ff ff       	jmp    80105c3a <alltraps>

801062c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $49
801062c2:	6a 31                	push   $0x31
  jmp alltraps
801062c4:	e9 71 f9 ff ff       	jmp    80105c3a <alltraps>

801062c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $50
801062cb:	6a 32                	push   $0x32
  jmp alltraps
801062cd:	e9 68 f9 ff ff       	jmp    80105c3a <alltraps>

801062d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $51
801062d4:	6a 33                	push   $0x33
  jmp alltraps
801062d6:	e9 5f f9 ff ff       	jmp    80105c3a <alltraps>

801062db <vector52>:
.globl vector52
vector52:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $52
801062dd:	6a 34                	push   $0x34
  jmp alltraps
801062df:	e9 56 f9 ff ff       	jmp    80105c3a <alltraps>

801062e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $53
801062e6:	6a 35                	push   $0x35
  jmp alltraps
801062e8:	e9 4d f9 ff ff       	jmp    80105c3a <alltraps>

801062ed <vector54>:
.globl vector54
vector54:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $54
801062ef:	6a 36                	push   $0x36
  jmp alltraps
801062f1:	e9 44 f9 ff ff       	jmp    80105c3a <alltraps>

801062f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $55
801062f8:	6a 37                	push   $0x37
  jmp alltraps
801062fa:	e9 3b f9 ff ff       	jmp    80105c3a <alltraps>

801062ff <vector56>:
.globl vector56
vector56:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $56
80106301:	6a 38                	push   $0x38
  jmp alltraps
80106303:	e9 32 f9 ff ff       	jmp    80105c3a <alltraps>

80106308 <vector57>:
.globl vector57
vector57:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $57
8010630a:	6a 39                	push   $0x39
  jmp alltraps
8010630c:	e9 29 f9 ff ff       	jmp    80105c3a <alltraps>

80106311 <vector58>:
.globl vector58
vector58:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $58
80106313:	6a 3a                	push   $0x3a
  jmp alltraps
80106315:	e9 20 f9 ff ff       	jmp    80105c3a <alltraps>

8010631a <vector59>:
.globl vector59
vector59:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $59
8010631c:	6a 3b                	push   $0x3b
  jmp alltraps
8010631e:	e9 17 f9 ff ff       	jmp    80105c3a <alltraps>

80106323 <vector60>:
.globl vector60
vector60:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $60
80106325:	6a 3c                	push   $0x3c
  jmp alltraps
80106327:	e9 0e f9 ff ff       	jmp    80105c3a <alltraps>

8010632c <vector61>:
.globl vector61
vector61:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $61
8010632e:	6a 3d                	push   $0x3d
  jmp alltraps
80106330:	e9 05 f9 ff ff       	jmp    80105c3a <alltraps>

80106335 <vector62>:
.globl vector62
vector62:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $62
80106337:	6a 3e                	push   $0x3e
  jmp alltraps
80106339:	e9 fc f8 ff ff       	jmp    80105c3a <alltraps>

8010633e <vector63>:
.globl vector63
vector63:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $63
80106340:	6a 3f                	push   $0x3f
  jmp alltraps
80106342:	e9 f3 f8 ff ff       	jmp    80105c3a <alltraps>

80106347 <vector64>:
.globl vector64
vector64:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $64
80106349:	6a 40                	push   $0x40
  jmp alltraps
8010634b:	e9 ea f8 ff ff       	jmp    80105c3a <alltraps>

80106350 <vector65>:
.globl vector65
vector65:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $65
80106352:	6a 41                	push   $0x41
  jmp alltraps
80106354:	e9 e1 f8 ff ff       	jmp    80105c3a <alltraps>

80106359 <vector66>:
.globl vector66
vector66:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $66
8010635b:	6a 42                	push   $0x42
  jmp alltraps
8010635d:	e9 d8 f8 ff ff       	jmp    80105c3a <alltraps>

80106362 <vector67>:
.globl vector67
vector67:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $67
80106364:	6a 43                	push   $0x43
  jmp alltraps
80106366:	e9 cf f8 ff ff       	jmp    80105c3a <alltraps>

8010636b <vector68>:
.globl vector68
vector68:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $68
8010636d:	6a 44                	push   $0x44
  jmp alltraps
8010636f:	e9 c6 f8 ff ff       	jmp    80105c3a <alltraps>

80106374 <vector69>:
.globl vector69
vector69:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $69
80106376:	6a 45                	push   $0x45
  jmp alltraps
80106378:	e9 bd f8 ff ff       	jmp    80105c3a <alltraps>

8010637d <vector70>:
.globl vector70
vector70:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $70
8010637f:	6a 46                	push   $0x46
  jmp alltraps
80106381:	e9 b4 f8 ff ff       	jmp    80105c3a <alltraps>

80106386 <vector71>:
.globl vector71
vector71:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $71
80106388:	6a 47                	push   $0x47
  jmp alltraps
8010638a:	e9 ab f8 ff ff       	jmp    80105c3a <alltraps>

8010638f <vector72>:
.globl vector72
vector72:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $72
80106391:	6a 48                	push   $0x48
  jmp alltraps
80106393:	e9 a2 f8 ff ff       	jmp    80105c3a <alltraps>

80106398 <vector73>:
.globl vector73
vector73:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $73
8010639a:	6a 49                	push   $0x49
  jmp alltraps
8010639c:	e9 99 f8 ff ff       	jmp    80105c3a <alltraps>

801063a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $74
801063a3:	6a 4a                	push   $0x4a
  jmp alltraps
801063a5:	e9 90 f8 ff ff       	jmp    80105c3a <alltraps>

801063aa <vector75>:
.globl vector75
vector75:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $75
801063ac:	6a 4b                	push   $0x4b
  jmp alltraps
801063ae:	e9 87 f8 ff ff       	jmp    80105c3a <alltraps>

801063b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $76
801063b5:	6a 4c                	push   $0x4c
  jmp alltraps
801063b7:	e9 7e f8 ff ff       	jmp    80105c3a <alltraps>

801063bc <vector77>:
.globl vector77
vector77:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $77
801063be:	6a 4d                	push   $0x4d
  jmp alltraps
801063c0:	e9 75 f8 ff ff       	jmp    80105c3a <alltraps>

801063c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $78
801063c7:	6a 4e                	push   $0x4e
  jmp alltraps
801063c9:	e9 6c f8 ff ff       	jmp    80105c3a <alltraps>

801063ce <vector79>:
.globl vector79
vector79:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $79
801063d0:	6a 4f                	push   $0x4f
  jmp alltraps
801063d2:	e9 63 f8 ff ff       	jmp    80105c3a <alltraps>

801063d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $80
801063d9:	6a 50                	push   $0x50
  jmp alltraps
801063db:	e9 5a f8 ff ff       	jmp    80105c3a <alltraps>

801063e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $81
801063e2:	6a 51                	push   $0x51
  jmp alltraps
801063e4:	e9 51 f8 ff ff       	jmp    80105c3a <alltraps>

801063e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $82
801063eb:	6a 52                	push   $0x52
  jmp alltraps
801063ed:	e9 48 f8 ff ff       	jmp    80105c3a <alltraps>

801063f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $83
801063f4:	6a 53                	push   $0x53
  jmp alltraps
801063f6:	e9 3f f8 ff ff       	jmp    80105c3a <alltraps>

801063fb <vector84>:
.globl vector84
vector84:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $84
801063fd:	6a 54                	push   $0x54
  jmp alltraps
801063ff:	e9 36 f8 ff ff       	jmp    80105c3a <alltraps>

80106404 <vector85>:
.globl vector85
vector85:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $85
80106406:	6a 55                	push   $0x55
  jmp alltraps
80106408:	e9 2d f8 ff ff       	jmp    80105c3a <alltraps>

8010640d <vector86>:
.globl vector86
vector86:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $86
8010640f:	6a 56                	push   $0x56
  jmp alltraps
80106411:	e9 24 f8 ff ff       	jmp    80105c3a <alltraps>

80106416 <vector87>:
.globl vector87
vector87:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $87
80106418:	6a 57                	push   $0x57
  jmp alltraps
8010641a:	e9 1b f8 ff ff       	jmp    80105c3a <alltraps>

8010641f <vector88>:
.globl vector88
vector88:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $88
80106421:	6a 58                	push   $0x58
  jmp alltraps
80106423:	e9 12 f8 ff ff       	jmp    80105c3a <alltraps>

80106428 <vector89>:
.globl vector89
vector89:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $89
8010642a:	6a 59                	push   $0x59
  jmp alltraps
8010642c:	e9 09 f8 ff ff       	jmp    80105c3a <alltraps>

80106431 <vector90>:
.globl vector90
vector90:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $90
80106433:	6a 5a                	push   $0x5a
  jmp alltraps
80106435:	e9 00 f8 ff ff       	jmp    80105c3a <alltraps>

8010643a <vector91>:
.globl vector91
vector91:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $91
8010643c:	6a 5b                	push   $0x5b
  jmp alltraps
8010643e:	e9 f7 f7 ff ff       	jmp    80105c3a <alltraps>

80106443 <vector92>:
.globl vector92
vector92:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $92
80106445:	6a 5c                	push   $0x5c
  jmp alltraps
80106447:	e9 ee f7 ff ff       	jmp    80105c3a <alltraps>

8010644c <vector93>:
.globl vector93
vector93:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $93
8010644e:	6a 5d                	push   $0x5d
  jmp alltraps
80106450:	e9 e5 f7 ff ff       	jmp    80105c3a <alltraps>

80106455 <vector94>:
.globl vector94
vector94:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $94
80106457:	6a 5e                	push   $0x5e
  jmp alltraps
80106459:	e9 dc f7 ff ff       	jmp    80105c3a <alltraps>

8010645e <vector95>:
.globl vector95
vector95:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $95
80106460:	6a 5f                	push   $0x5f
  jmp alltraps
80106462:	e9 d3 f7 ff ff       	jmp    80105c3a <alltraps>

80106467 <vector96>:
.globl vector96
vector96:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $96
80106469:	6a 60                	push   $0x60
  jmp alltraps
8010646b:	e9 ca f7 ff ff       	jmp    80105c3a <alltraps>

80106470 <vector97>:
.globl vector97
vector97:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $97
80106472:	6a 61                	push   $0x61
  jmp alltraps
80106474:	e9 c1 f7 ff ff       	jmp    80105c3a <alltraps>

80106479 <vector98>:
.globl vector98
vector98:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $98
8010647b:	6a 62                	push   $0x62
  jmp alltraps
8010647d:	e9 b8 f7 ff ff       	jmp    80105c3a <alltraps>

80106482 <vector99>:
.globl vector99
vector99:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $99
80106484:	6a 63                	push   $0x63
  jmp alltraps
80106486:	e9 af f7 ff ff       	jmp    80105c3a <alltraps>

8010648b <vector100>:
.globl vector100
vector100:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $100
8010648d:	6a 64                	push   $0x64
  jmp alltraps
8010648f:	e9 a6 f7 ff ff       	jmp    80105c3a <alltraps>

80106494 <vector101>:
.globl vector101
vector101:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $101
80106496:	6a 65                	push   $0x65
  jmp alltraps
80106498:	e9 9d f7 ff ff       	jmp    80105c3a <alltraps>

8010649d <vector102>:
.globl vector102
vector102:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $102
8010649f:	6a 66                	push   $0x66
  jmp alltraps
801064a1:	e9 94 f7 ff ff       	jmp    80105c3a <alltraps>

801064a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $103
801064a8:	6a 67                	push   $0x67
  jmp alltraps
801064aa:	e9 8b f7 ff ff       	jmp    80105c3a <alltraps>

801064af <vector104>:
.globl vector104
vector104:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $104
801064b1:	6a 68                	push   $0x68
  jmp alltraps
801064b3:	e9 82 f7 ff ff       	jmp    80105c3a <alltraps>

801064b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $105
801064ba:	6a 69                	push   $0x69
  jmp alltraps
801064bc:	e9 79 f7 ff ff       	jmp    80105c3a <alltraps>

801064c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $106
801064c3:	6a 6a                	push   $0x6a
  jmp alltraps
801064c5:	e9 70 f7 ff ff       	jmp    80105c3a <alltraps>

801064ca <vector107>:
.globl vector107
vector107:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $107
801064cc:	6a 6b                	push   $0x6b
  jmp alltraps
801064ce:	e9 67 f7 ff ff       	jmp    80105c3a <alltraps>

801064d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $108
801064d5:	6a 6c                	push   $0x6c
  jmp alltraps
801064d7:	e9 5e f7 ff ff       	jmp    80105c3a <alltraps>

801064dc <vector109>:
.globl vector109
vector109:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $109
801064de:	6a 6d                	push   $0x6d
  jmp alltraps
801064e0:	e9 55 f7 ff ff       	jmp    80105c3a <alltraps>

801064e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $110
801064e7:	6a 6e                	push   $0x6e
  jmp alltraps
801064e9:	e9 4c f7 ff ff       	jmp    80105c3a <alltraps>

801064ee <vector111>:
.globl vector111
vector111:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $111
801064f0:	6a 6f                	push   $0x6f
  jmp alltraps
801064f2:	e9 43 f7 ff ff       	jmp    80105c3a <alltraps>

801064f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $112
801064f9:	6a 70                	push   $0x70
  jmp alltraps
801064fb:	e9 3a f7 ff ff       	jmp    80105c3a <alltraps>

80106500 <vector113>:
.globl vector113
vector113:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $113
80106502:	6a 71                	push   $0x71
  jmp alltraps
80106504:	e9 31 f7 ff ff       	jmp    80105c3a <alltraps>

80106509 <vector114>:
.globl vector114
vector114:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $114
8010650b:	6a 72                	push   $0x72
  jmp alltraps
8010650d:	e9 28 f7 ff ff       	jmp    80105c3a <alltraps>

80106512 <vector115>:
.globl vector115
vector115:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $115
80106514:	6a 73                	push   $0x73
  jmp alltraps
80106516:	e9 1f f7 ff ff       	jmp    80105c3a <alltraps>

8010651b <vector116>:
.globl vector116
vector116:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $116
8010651d:	6a 74                	push   $0x74
  jmp alltraps
8010651f:	e9 16 f7 ff ff       	jmp    80105c3a <alltraps>

80106524 <vector117>:
.globl vector117
vector117:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $117
80106526:	6a 75                	push   $0x75
  jmp alltraps
80106528:	e9 0d f7 ff ff       	jmp    80105c3a <alltraps>

8010652d <vector118>:
.globl vector118
vector118:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $118
8010652f:	6a 76                	push   $0x76
  jmp alltraps
80106531:	e9 04 f7 ff ff       	jmp    80105c3a <alltraps>

80106536 <vector119>:
.globl vector119
vector119:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $119
80106538:	6a 77                	push   $0x77
  jmp alltraps
8010653a:	e9 fb f6 ff ff       	jmp    80105c3a <alltraps>

8010653f <vector120>:
.globl vector120
vector120:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $120
80106541:	6a 78                	push   $0x78
  jmp alltraps
80106543:	e9 f2 f6 ff ff       	jmp    80105c3a <alltraps>

80106548 <vector121>:
.globl vector121
vector121:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $121
8010654a:	6a 79                	push   $0x79
  jmp alltraps
8010654c:	e9 e9 f6 ff ff       	jmp    80105c3a <alltraps>

80106551 <vector122>:
.globl vector122
vector122:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $122
80106553:	6a 7a                	push   $0x7a
  jmp alltraps
80106555:	e9 e0 f6 ff ff       	jmp    80105c3a <alltraps>

8010655a <vector123>:
.globl vector123
vector123:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $123
8010655c:	6a 7b                	push   $0x7b
  jmp alltraps
8010655e:	e9 d7 f6 ff ff       	jmp    80105c3a <alltraps>

80106563 <vector124>:
.globl vector124
vector124:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $124
80106565:	6a 7c                	push   $0x7c
  jmp alltraps
80106567:	e9 ce f6 ff ff       	jmp    80105c3a <alltraps>

8010656c <vector125>:
.globl vector125
vector125:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $125
8010656e:	6a 7d                	push   $0x7d
  jmp alltraps
80106570:	e9 c5 f6 ff ff       	jmp    80105c3a <alltraps>

80106575 <vector126>:
.globl vector126
vector126:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $126
80106577:	6a 7e                	push   $0x7e
  jmp alltraps
80106579:	e9 bc f6 ff ff       	jmp    80105c3a <alltraps>

8010657e <vector127>:
.globl vector127
vector127:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $127
80106580:	6a 7f                	push   $0x7f
  jmp alltraps
80106582:	e9 b3 f6 ff ff       	jmp    80105c3a <alltraps>

80106587 <vector128>:
.globl vector128
vector128:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $128
80106589:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010658e:	e9 a7 f6 ff ff       	jmp    80105c3a <alltraps>

80106593 <vector129>:
.globl vector129
vector129:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $129
80106595:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010659a:	e9 9b f6 ff ff       	jmp    80105c3a <alltraps>

8010659f <vector130>:
.globl vector130
vector130:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $130
801065a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065a6:	e9 8f f6 ff ff       	jmp    80105c3a <alltraps>

801065ab <vector131>:
.globl vector131
vector131:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $131
801065ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065b2:	e9 83 f6 ff ff       	jmp    80105c3a <alltraps>

801065b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $132
801065b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065be:	e9 77 f6 ff ff       	jmp    80105c3a <alltraps>

801065c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $133
801065c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065ca:	e9 6b f6 ff ff       	jmp    80105c3a <alltraps>

801065cf <vector134>:
.globl vector134
vector134:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $134
801065d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065d6:	e9 5f f6 ff ff       	jmp    80105c3a <alltraps>

801065db <vector135>:
.globl vector135
vector135:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $135
801065dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065e2:	e9 53 f6 ff ff       	jmp    80105c3a <alltraps>

801065e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $136
801065e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ee:	e9 47 f6 ff ff       	jmp    80105c3a <alltraps>

801065f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $137
801065f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065fa:	e9 3b f6 ff ff       	jmp    80105c3a <alltraps>

801065ff <vector138>:
.globl vector138
vector138:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $138
80106601:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106606:	e9 2f f6 ff ff       	jmp    80105c3a <alltraps>

8010660b <vector139>:
.globl vector139
vector139:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $139
8010660d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106612:	e9 23 f6 ff ff       	jmp    80105c3a <alltraps>

80106617 <vector140>:
.globl vector140
vector140:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $140
80106619:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010661e:	e9 17 f6 ff ff       	jmp    80105c3a <alltraps>

80106623 <vector141>:
.globl vector141
vector141:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $141
80106625:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010662a:	e9 0b f6 ff ff       	jmp    80105c3a <alltraps>

8010662f <vector142>:
.globl vector142
vector142:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $142
80106631:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106636:	e9 ff f5 ff ff       	jmp    80105c3a <alltraps>

8010663b <vector143>:
.globl vector143
vector143:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $143
8010663d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106642:	e9 f3 f5 ff ff       	jmp    80105c3a <alltraps>

80106647 <vector144>:
.globl vector144
vector144:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $144
80106649:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010664e:	e9 e7 f5 ff ff       	jmp    80105c3a <alltraps>

80106653 <vector145>:
.globl vector145
vector145:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $145
80106655:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010665a:	e9 db f5 ff ff       	jmp    80105c3a <alltraps>

8010665f <vector146>:
.globl vector146
vector146:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $146
80106661:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106666:	e9 cf f5 ff ff       	jmp    80105c3a <alltraps>

8010666b <vector147>:
.globl vector147
vector147:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $147
8010666d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106672:	e9 c3 f5 ff ff       	jmp    80105c3a <alltraps>

80106677 <vector148>:
.globl vector148
vector148:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $148
80106679:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010667e:	e9 b7 f5 ff ff       	jmp    80105c3a <alltraps>

80106683 <vector149>:
.globl vector149
vector149:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $149
80106685:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010668a:	e9 ab f5 ff ff       	jmp    80105c3a <alltraps>

8010668f <vector150>:
.globl vector150
vector150:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $150
80106691:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106696:	e9 9f f5 ff ff       	jmp    80105c3a <alltraps>

8010669b <vector151>:
.globl vector151
vector151:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $151
8010669d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066a2:	e9 93 f5 ff ff       	jmp    80105c3a <alltraps>

801066a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $152
801066a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066ae:	e9 87 f5 ff ff       	jmp    80105c3a <alltraps>

801066b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $153
801066b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ba:	e9 7b f5 ff ff       	jmp    80105c3a <alltraps>

801066bf <vector154>:
.globl vector154
vector154:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $154
801066c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066c6:	e9 6f f5 ff ff       	jmp    80105c3a <alltraps>

801066cb <vector155>:
.globl vector155
vector155:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $155
801066cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066d2:	e9 63 f5 ff ff       	jmp    80105c3a <alltraps>

801066d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $156
801066d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066de:	e9 57 f5 ff ff       	jmp    80105c3a <alltraps>

801066e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $157
801066e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066ea:	e9 4b f5 ff ff       	jmp    80105c3a <alltraps>

801066ef <vector158>:
.globl vector158
vector158:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $158
801066f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066f6:	e9 3f f5 ff ff       	jmp    80105c3a <alltraps>

801066fb <vector159>:
.globl vector159
vector159:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $159
801066fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106702:	e9 33 f5 ff ff       	jmp    80105c3a <alltraps>

80106707 <vector160>:
.globl vector160
vector160:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $160
80106709:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010670e:	e9 27 f5 ff ff       	jmp    80105c3a <alltraps>

80106713 <vector161>:
.globl vector161
vector161:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $161
80106715:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010671a:	e9 1b f5 ff ff       	jmp    80105c3a <alltraps>

8010671f <vector162>:
.globl vector162
vector162:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $162
80106721:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106726:	e9 0f f5 ff ff       	jmp    80105c3a <alltraps>

8010672b <vector163>:
.globl vector163
vector163:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $163
8010672d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106732:	e9 03 f5 ff ff       	jmp    80105c3a <alltraps>

80106737 <vector164>:
.globl vector164
vector164:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $164
80106739:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010673e:	e9 f7 f4 ff ff       	jmp    80105c3a <alltraps>

80106743 <vector165>:
.globl vector165
vector165:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $165
80106745:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010674a:	e9 eb f4 ff ff       	jmp    80105c3a <alltraps>

8010674f <vector166>:
.globl vector166
vector166:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $166
80106751:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106756:	e9 df f4 ff ff       	jmp    80105c3a <alltraps>

8010675b <vector167>:
.globl vector167
vector167:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $167
8010675d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106762:	e9 d3 f4 ff ff       	jmp    80105c3a <alltraps>

80106767 <vector168>:
.globl vector168
vector168:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $168
80106769:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010676e:	e9 c7 f4 ff ff       	jmp    80105c3a <alltraps>

80106773 <vector169>:
.globl vector169
vector169:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $169
80106775:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010677a:	e9 bb f4 ff ff       	jmp    80105c3a <alltraps>

8010677f <vector170>:
.globl vector170
vector170:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $170
80106781:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106786:	e9 af f4 ff ff       	jmp    80105c3a <alltraps>

8010678b <vector171>:
.globl vector171
vector171:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $171
8010678d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106792:	e9 a3 f4 ff ff       	jmp    80105c3a <alltraps>

80106797 <vector172>:
.globl vector172
vector172:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $172
80106799:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010679e:	e9 97 f4 ff ff       	jmp    80105c3a <alltraps>

801067a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $173
801067a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067aa:	e9 8b f4 ff ff       	jmp    80105c3a <alltraps>

801067af <vector174>:
.globl vector174
vector174:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $174
801067b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067b6:	e9 7f f4 ff ff       	jmp    80105c3a <alltraps>

801067bb <vector175>:
.globl vector175
vector175:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $175
801067bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067c2:	e9 73 f4 ff ff       	jmp    80105c3a <alltraps>

801067c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $176
801067c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067ce:	e9 67 f4 ff ff       	jmp    80105c3a <alltraps>

801067d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $177
801067d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067da:	e9 5b f4 ff ff       	jmp    80105c3a <alltraps>

801067df <vector178>:
.globl vector178
vector178:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $178
801067e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067e6:	e9 4f f4 ff ff       	jmp    80105c3a <alltraps>

801067eb <vector179>:
.globl vector179
vector179:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $179
801067ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067f2:	e9 43 f4 ff ff       	jmp    80105c3a <alltraps>

801067f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $180
801067f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067fe:	e9 37 f4 ff ff       	jmp    80105c3a <alltraps>

80106803 <vector181>:
.globl vector181
vector181:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $181
80106805:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010680a:	e9 2b f4 ff ff       	jmp    80105c3a <alltraps>

8010680f <vector182>:
.globl vector182
vector182:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $182
80106811:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106816:	e9 1f f4 ff ff       	jmp    80105c3a <alltraps>

8010681b <vector183>:
.globl vector183
vector183:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $183
8010681d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106822:	e9 13 f4 ff ff       	jmp    80105c3a <alltraps>

80106827 <vector184>:
.globl vector184
vector184:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $184
80106829:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010682e:	e9 07 f4 ff ff       	jmp    80105c3a <alltraps>

80106833 <vector185>:
.globl vector185
vector185:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $185
80106835:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010683a:	e9 fb f3 ff ff       	jmp    80105c3a <alltraps>

8010683f <vector186>:
.globl vector186
vector186:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $186
80106841:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106846:	e9 ef f3 ff ff       	jmp    80105c3a <alltraps>

8010684b <vector187>:
.globl vector187
vector187:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $187
8010684d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106852:	e9 e3 f3 ff ff       	jmp    80105c3a <alltraps>

80106857 <vector188>:
.globl vector188
vector188:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $188
80106859:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010685e:	e9 d7 f3 ff ff       	jmp    80105c3a <alltraps>

80106863 <vector189>:
.globl vector189
vector189:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $189
80106865:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010686a:	e9 cb f3 ff ff       	jmp    80105c3a <alltraps>

8010686f <vector190>:
.globl vector190
vector190:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $190
80106871:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106876:	e9 bf f3 ff ff       	jmp    80105c3a <alltraps>

8010687b <vector191>:
.globl vector191
vector191:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $191
8010687d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106882:	e9 b3 f3 ff ff       	jmp    80105c3a <alltraps>

80106887 <vector192>:
.globl vector192
vector192:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $192
80106889:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010688e:	e9 a7 f3 ff ff       	jmp    80105c3a <alltraps>

80106893 <vector193>:
.globl vector193
vector193:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $193
80106895:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010689a:	e9 9b f3 ff ff       	jmp    80105c3a <alltraps>

8010689f <vector194>:
.globl vector194
vector194:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $194
801068a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068a6:	e9 8f f3 ff ff       	jmp    80105c3a <alltraps>

801068ab <vector195>:
.globl vector195
vector195:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $195
801068ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068b2:	e9 83 f3 ff ff       	jmp    80105c3a <alltraps>

801068b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $196
801068b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068be:	e9 77 f3 ff ff       	jmp    80105c3a <alltraps>

801068c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $197
801068c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068ca:	e9 6b f3 ff ff       	jmp    80105c3a <alltraps>

801068cf <vector198>:
.globl vector198
vector198:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $198
801068d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068d6:	e9 5f f3 ff ff       	jmp    80105c3a <alltraps>

801068db <vector199>:
.globl vector199
vector199:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $199
801068dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068e2:	e9 53 f3 ff ff       	jmp    80105c3a <alltraps>

801068e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $200
801068e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ee:	e9 47 f3 ff ff       	jmp    80105c3a <alltraps>

801068f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $201
801068f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068fa:	e9 3b f3 ff ff       	jmp    80105c3a <alltraps>

801068ff <vector202>:
.globl vector202
vector202:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $202
80106901:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106906:	e9 2f f3 ff ff       	jmp    80105c3a <alltraps>

8010690b <vector203>:
.globl vector203
vector203:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $203
8010690d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106912:	e9 23 f3 ff ff       	jmp    80105c3a <alltraps>

80106917 <vector204>:
.globl vector204
vector204:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $204
80106919:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010691e:	e9 17 f3 ff ff       	jmp    80105c3a <alltraps>

80106923 <vector205>:
.globl vector205
vector205:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $205
80106925:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010692a:	e9 0b f3 ff ff       	jmp    80105c3a <alltraps>

8010692f <vector206>:
.globl vector206
vector206:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $206
80106931:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106936:	e9 ff f2 ff ff       	jmp    80105c3a <alltraps>

8010693b <vector207>:
.globl vector207
vector207:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $207
8010693d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106942:	e9 f3 f2 ff ff       	jmp    80105c3a <alltraps>

80106947 <vector208>:
.globl vector208
vector208:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $208
80106949:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010694e:	e9 e7 f2 ff ff       	jmp    80105c3a <alltraps>

80106953 <vector209>:
.globl vector209
vector209:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $209
80106955:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010695a:	e9 db f2 ff ff       	jmp    80105c3a <alltraps>

8010695f <vector210>:
.globl vector210
vector210:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $210
80106961:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106966:	e9 cf f2 ff ff       	jmp    80105c3a <alltraps>

8010696b <vector211>:
.globl vector211
vector211:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $211
8010696d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106972:	e9 c3 f2 ff ff       	jmp    80105c3a <alltraps>

80106977 <vector212>:
.globl vector212
vector212:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $212
80106979:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010697e:	e9 b7 f2 ff ff       	jmp    80105c3a <alltraps>

80106983 <vector213>:
.globl vector213
vector213:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $213
80106985:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010698a:	e9 ab f2 ff ff       	jmp    80105c3a <alltraps>

8010698f <vector214>:
.globl vector214
vector214:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $214
80106991:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106996:	e9 9f f2 ff ff       	jmp    80105c3a <alltraps>

8010699b <vector215>:
.globl vector215
vector215:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $215
8010699d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069a2:	e9 93 f2 ff ff       	jmp    80105c3a <alltraps>

801069a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $216
801069a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069ae:	e9 87 f2 ff ff       	jmp    80105c3a <alltraps>

801069b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $217
801069b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ba:	e9 7b f2 ff ff       	jmp    80105c3a <alltraps>

801069bf <vector218>:
.globl vector218
vector218:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $218
801069c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069c6:	e9 6f f2 ff ff       	jmp    80105c3a <alltraps>

801069cb <vector219>:
.globl vector219
vector219:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $219
801069cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069d2:	e9 63 f2 ff ff       	jmp    80105c3a <alltraps>

801069d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $220
801069d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069de:	e9 57 f2 ff ff       	jmp    80105c3a <alltraps>

801069e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $221
801069e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069ea:	e9 4b f2 ff ff       	jmp    80105c3a <alltraps>

801069ef <vector222>:
.globl vector222
vector222:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $222
801069f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069f6:	e9 3f f2 ff ff       	jmp    80105c3a <alltraps>

801069fb <vector223>:
.globl vector223
vector223:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $223
801069fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a02:	e9 33 f2 ff ff       	jmp    80105c3a <alltraps>

80106a07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $224
80106a09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a0e:	e9 27 f2 ff ff       	jmp    80105c3a <alltraps>

80106a13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $225
80106a15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a1a:	e9 1b f2 ff ff       	jmp    80105c3a <alltraps>

80106a1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $226
80106a21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a26:	e9 0f f2 ff ff       	jmp    80105c3a <alltraps>

80106a2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $227
80106a2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a32:	e9 03 f2 ff ff       	jmp    80105c3a <alltraps>

80106a37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $228
80106a39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a3e:	e9 f7 f1 ff ff       	jmp    80105c3a <alltraps>

80106a43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $229
80106a45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a4a:	e9 eb f1 ff ff       	jmp    80105c3a <alltraps>

80106a4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $230
80106a51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a56:	e9 df f1 ff ff       	jmp    80105c3a <alltraps>

80106a5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $231
80106a5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a62:	e9 d3 f1 ff ff       	jmp    80105c3a <alltraps>

80106a67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $232
80106a69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a6e:	e9 c7 f1 ff ff       	jmp    80105c3a <alltraps>

80106a73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $233
80106a75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a7a:	e9 bb f1 ff ff       	jmp    80105c3a <alltraps>

80106a7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $234
80106a81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a86:	e9 af f1 ff ff       	jmp    80105c3a <alltraps>

80106a8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $235
80106a8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a92:	e9 a3 f1 ff ff       	jmp    80105c3a <alltraps>

80106a97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $236
80106a99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a9e:	e9 97 f1 ff ff       	jmp    80105c3a <alltraps>

80106aa3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $237
80106aa5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106aaa:	e9 8b f1 ff ff       	jmp    80105c3a <alltraps>

80106aaf <vector238>:
.globl vector238
vector238:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $238
80106ab1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ab6:	e9 7f f1 ff ff       	jmp    80105c3a <alltraps>

80106abb <vector239>:
.globl vector239
vector239:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $239
80106abd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ac2:	e9 73 f1 ff ff       	jmp    80105c3a <alltraps>

80106ac7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $240
80106ac9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ace:	e9 67 f1 ff ff       	jmp    80105c3a <alltraps>

80106ad3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $241
80106ad5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106ada:	e9 5b f1 ff ff       	jmp    80105c3a <alltraps>

80106adf <vector242>:
.globl vector242
vector242:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $242
80106ae1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ae6:	e9 4f f1 ff ff       	jmp    80105c3a <alltraps>

80106aeb <vector243>:
.globl vector243
vector243:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $243
80106aed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106af2:	e9 43 f1 ff ff       	jmp    80105c3a <alltraps>

80106af7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $244
80106af9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106afe:	e9 37 f1 ff ff       	jmp    80105c3a <alltraps>

80106b03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $245
80106b05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b0a:	e9 2b f1 ff ff       	jmp    80105c3a <alltraps>

80106b0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $246
80106b11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b16:	e9 1f f1 ff ff       	jmp    80105c3a <alltraps>

80106b1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $247
80106b1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b22:	e9 13 f1 ff ff       	jmp    80105c3a <alltraps>

80106b27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $248
80106b29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b2e:	e9 07 f1 ff ff       	jmp    80105c3a <alltraps>

80106b33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $249
80106b35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b3a:	e9 fb f0 ff ff       	jmp    80105c3a <alltraps>

80106b3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $250
80106b41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b46:	e9 ef f0 ff ff       	jmp    80105c3a <alltraps>

80106b4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $251
80106b4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b52:	e9 e3 f0 ff ff       	jmp    80105c3a <alltraps>

80106b57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $252
80106b59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b5e:	e9 d7 f0 ff ff       	jmp    80105c3a <alltraps>

80106b63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $253
80106b65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b6a:	e9 cb f0 ff ff       	jmp    80105c3a <alltraps>

80106b6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $254
80106b71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b76:	e9 bf f0 ff ff       	jmp    80105c3a <alltraps>

80106b7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $255
80106b7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b82:	e9 b3 f0 ff ff       	jmp    80105c3a <alltraps>
80106b87:	66 90                	xchg   %ax,%ax
80106b89:	66 90                	xchg   %ax,%ax
80106b8b:	66 90                	xchg   %ax,%ax
80106b8d:	66 90                	xchg   %ax,%ax
80106b8f:	90                   	nop

80106b90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b96:	89 d3                	mov    %edx,%ebx
{
80106b98:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106b9a:	c1 eb 16             	shr    $0x16,%ebx
80106b9d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ba0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ba3:	8b 06                	mov    (%esi),%eax
80106ba5:	a8 01                	test   $0x1,%al
80106ba7:	74 27                	je     80106bd0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ba9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106bb4:	c1 ef 0a             	shr    $0xa,%edi
}
80106bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106bba:	89 fa                	mov    %edi,%edx
80106bbc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bc2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bd0:	85 c9                	test   %ecx,%ecx
80106bd2:	74 2c                	je     80106c00 <walkpgdir+0x70>
80106bd4:	e8 27 b9 ff ff       	call   80102500 <kalloc>
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	89 c3                	mov    %eax,%ebx
80106bdd:	74 21                	je     80106c00 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106bdf:	83 ec 04             	sub    $0x4,%esp
80106be2:	68 00 10 00 00       	push   $0x1000
80106be7:	6a 00                	push   $0x0
80106be9:	50                   	push   %eax
80106bea:	e8 61 de ff ff       	call   80104a50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bf5:	83 c4 10             	add    $0x10,%esp
80106bf8:	83 c8 07             	or     $0x7,%eax
80106bfb:	89 06                	mov    %eax,(%esi)
80106bfd:	eb b5                	jmp    80106bb4 <walkpgdir+0x24>
80106bff:	90                   	nop
}
80106c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c03:	31 c0                	xor    %eax,%eax
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret    
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c16:	89 d3                	mov    %edx,%ebx
80106c18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c1e:	83 ec 1c             	sub    $0x1c,%esp
80106c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c28:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c33:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c36:	29 df                	sub    %ebx,%edi
80106c38:	83 c8 01             	or     $0x1,%eax
80106c3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c3e:	eb 15                	jmp    80106c55 <mappages+0x45>
    if(*pte & PTE_P)
80106c40:	f6 00 01             	testb  $0x1,(%eax)
80106c43:	75 45                	jne    80106c8a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c45:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c48:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c4b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c4d:	74 31                	je     80106c80 <mappages+0x70>
      break;
    a += PGSIZE;
80106c4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c58:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c5d:	89 da                	mov    %ebx,%edx
80106c5f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c62:	e8 29 ff ff ff       	call   80106b90 <walkpgdir>
80106c67:	85 c0                	test   %eax,%eax
80106c69:	75 d5                	jne    80106c40 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c73:	5b                   	pop    %ebx
80106c74:	5e                   	pop    %esi
80106c75:	5f                   	pop    %edi
80106c76:	5d                   	pop    %ebp
80106c77:	c3                   	ret    
80106c78:	90                   	nop
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c83:	31 c0                	xor    %eax,%eax
}
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
      panic("remap");
80106c8a:	83 ec 0c             	sub    $0xc,%esp
80106c8d:	68 08 7f 10 80       	push   $0x80107f08
80106c92:	e8 f9 96 ff ff       	call   80100390 <panic>
80106c97:	89 f6                	mov    %esi,%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ca6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106cae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cb4:	83 ec 1c             	sub    $0x1c,%esp
80106cb7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cba:	39 d3                	cmp    %edx,%ebx
80106cbc:	73 66                	jae    80106d24 <deallocuvm.part.0+0x84>
80106cbe:	89 d6                	mov    %edx,%esi
80106cc0:	eb 3d                	jmp    80106cff <deallocuvm.part.0+0x5f>
80106cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106cc8:	8b 10                	mov    (%eax),%edx
80106cca:	f6 c2 01             	test   $0x1,%dl
80106ccd:	74 26                	je     80106cf5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106ccf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cd5:	74 58                	je     80106d2f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106cd7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cda:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ce3:	52                   	push   %edx
80106ce4:	e8 67 b6 ff ff       	call   80102350 <kfree>
      *pte = 0;
80106ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cec:	83 c4 10             	add    $0x10,%esp
80106cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106cf5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cfb:	39 f3                	cmp    %esi,%ebx
80106cfd:	73 25                	jae    80106d24 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106cff:	31 c9                	xor    %ecx,%ecx
80106d01:	89 da                	mov    %ebx,%edx
80106d03:	89 f8                	mov    %edi,%eax
80106d05:	e8 86 fe ff ff       	call   80106b90 <walkpgdir>
    if(!pte)
80106d0a:	85 c0                	test   %eax,%eax
80106d0c:	75 ba                	jne    80106cc8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d20:	39 f3                	cmp    %esi,%ebx
80106d22:	72 db                	jb     80106cff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d2a:	5b                   	pop    %ebx
80106d2b:	5e                   	pop    %esi
80106d2c:	5f                   	pop    %edi
80106d2d:	5d                   	pop    %ebp
80106d2e:	c3                   	ret    
        panic("kfree");
80106d2f:	83 ec 0c             	sub    $0xc,%esp
80106d32:	68 56 77 10 80       	push   $0x80107756
80106d37:	e8 54 96 ff ff       	call   80100390 <panic>
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <seginit>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d46:	e8 85 cb ff ff       	call   801038d0 <cpuid>
80106d4b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
80106d51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d5a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80106d61:	ff 00 00 
80106d64:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
80106d6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d6e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80106d75:	ff 00 00 
80106d78:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80106d7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d82:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80106d89:	ff 00 00 
80106d8c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80106d93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d96:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80106d9d:	ff 00 00 
80106da0:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80106da7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106daa:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80106daf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106db3:	c1 e8 10             	shr    $0x10,%eax
80106db6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dbd:	0f 01 10             	lgdtl  (%eax)
}
80106dc0:	c9                   	leave  
80106dc1:	c3                   	ret    
80106dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd0:	a1 e4 44 12 80       	mov    0x801244e4,%eax
{
80106dd5:	55                   	push   %ebp
80106dd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ddd:	0f 22 d8             	mov    %eax,%cr3
}
80106de0:	5d                   	pop    %ebp
80106de1:	c3                   	ret    
80106de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <switchuvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
80106df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106dfc:	85 db                	test   %ebx,%ebx
80106dfe:	0f 84 d7 00 00 00    	je     80106edb <switchuvm+0xeb>
  if(p->mainThread->tkstack == 0)
80106e04:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80106e0a:	8b 40 04             	mov    0x4(%eax),%eax
80106e0d:	85 c0                	test   %eax,%eax
80106e0f:	0f 84 e0 00 00 00    	je     80106ef5 <switchuvm+0x105>
  if(p->pgdir == 0)
80106e15:	8b 43 04             	mov    0x4(%ebx),%eax
80106e18:	85 c0                	test   %eax,%eax
80106e1a:	0f 84 c8 00 00 00    	je     80106ee8 <switchuvm+0xf8>
  pushcli();
80106e20:	e8 3b da ff ff       	call   80104860 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e25:	e8 26 ca ff ff       	call   80103850 <mycpu>
80106e2a:	89 c6                	mov    %eax,%esi
80106e2c:	e8 1f ca ff ff       	call   80103850 <mycpu>
80106e31:	89 c7                	mov    %eax,%edi
80106e33:	e8 18 ca ff ff       	call   80103850 <mycpu>
80106e38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e3b:	83 c7 08             	add    $0x8,%edi
80106e3e:	e8 0d ca ff ff       	call   80103850 <mycpu>
80106e43:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e46:	83 c0 08             	add    $0x8,%eax
80106e49:	ba 67 00 00 00       	mov    $0x67,%edx
80106e4e:	c1 e8 18             	shr    $0x18,%eax
80106e51:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e58:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e5f:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e65:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e6a:	83 c1 08             	add    $0x8,%ecx
80106e6d:	c1 e9 10             	shr    $0x10,%ecx
80106e70:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106e76:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e7b:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e82:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e87:	e8 c4 c9 ff ff       	call   80103850 <mycpu>
80106e8c:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e93:	e8 b8 c9 ff ff       	call   80103850 <mycpu>
80106e98:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
80106e9c:	8b 83 f0 03 00 00    	mov    0x3f0(%ebx),%eax
80106ea2:	8b 70 04             	mov    0x4(%eax),%esi
80106ea5:	e8 a6 c9 ff ff       	call   80103850 <mycpu>
80106eaa:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106eb0:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106eb3:	e8 98 c9 ff ff       	call   80103850 <mycpu>
80106eb8:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ebc:	b8 28 00 00 00       	mov    $0x28,%eax
80106ec1:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80106ec7:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ecc:	0f 22 d8             	mov    %eax,%cr3
}
80106ecf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ed2:	5b                   	pop    %ebx
80106ed3:	5e                   	pop    %esi
80106ed4:	5f                   	pop    %edi
80106ed5:	5d                   	pop    %ebp
  popcli();
80106ed6:	e9 c5 d9 ff ff       	jmp    801048a0 <popcli>
    panic("switchuvm: no process");
80106edb:	83 ec 0c             	sub    $0xc,%esp
80106ede:	68 0e 7f 10 80       	push   $0x80107f0e
80106ee3:	e8 a8 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106ee8:	83 ec 0c             	sub    $0xc,%esp
80106eeb:	68 39 7f 10 80       	push   $0x80107f39
80106ef0:	e8 9b 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106ef5:	83 ec 0c             	sub    $0xc,%esp
80106ef8:	68 24 7f 10 80       	push   $0x80107f24
80106efd:	e8 8e 94 ff ff       	call   80100390 <panic>
80106f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f10 <inituvm>:
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
80106f19:	8b 75 10             	mov    0x10(%ebp),%esi
80106f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f2b:	77 49                	ja     80106f76 <inituvm+0x66>
  mem = kalloc();
80106f2d:	e8 ce b5 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80106f32:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f35:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f37:	68 00 10 00 00       	push   $0x1000
80106f3c:	6a 00                	push   $0x0
80106f3e:	50                   	push   %eax
80106f3f:	e8 0c db ff ff       	call   80104a50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f44:	58                   	pop    %eax
80106f45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f50:	5a                   	pop    %edx
80106f51:	6a 06                	push   $0x6
80106f53:	50                   	push   %eax
80106f54:	31 d2                	xor    %edx,%edx
80106f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f59:	e8 b2 fc ff ff       	call   80106c10 <mappages>
  memmove(mem, init, sz);
80106f5e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f61:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f64:	83 c4 10             	add    $0x10,%esp
80106f67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f6d:	5b                   	pop    %ebx
80106f6e:	5e                   	pop    %esi
80106f6f:	5f                   	pop    %edi
80106f70:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f71:	e9 8a db ff ff       	jmp    80104b00 <memmove>
    panic("inituvm: more than a page");
80106f76:	83 ec 0c             	sub    $0xc,%esp
80106f79:	68 4d 7f 10 80       	push   $0x80107f4d
80106f7e:	e8 0d 94 ff ff       	call   80100390 <panic>
80106f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f90 <loaduvm>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106f99:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106fa0:	0f 85 91 00 00 00    	jne    80107037 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106fa6:	8b 75 18             	mov    0x18(%ebp),%esi
80106fa9:	31 db                	xor    %ebx,%ebx
80106fab:	85 f6                	test   %esi,%esi
80106fad:	75 1a                	jne    80106fc9 <loaduvm+0x39>
80106faf:	eb 6f                	jmp    80107020 <loaduvm+0x90>
80106fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fbe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fc4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106fc7:	76 57                	jbe    80107020 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fcf:	31 c9                	xor    %ecx,%ecx
80106fd1:	01 da                	add    %ebx,%edx
80106fd3:	e8 b8 fb ff ff       	call   80106b90 <walkpgdir>
80106fd8:	85 c0                	test   %eax,%eax
80106fda:	74 4e                	je     8010702a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106fdc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fde:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106fe1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fe6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106feb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ff1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ff4:	01 d9                	add    %ebx,%ecx
80106ff6:	05 00 00 00 80       	add    $0x80000000,%eax
80106ffb:	57                   	push   %edi
80106ffc:	51                   	push   %ecx
80106ffd:	50                   	push   %eax
80106ffe:	ff 75 10             	pushl  0x10(%ebp)
80107001:	e8 9a a9 ff ff       	call   801019a0 <readi>
80107006:	83 c4 10             	add    $0x10,%esp
80107009:	39 f8                	cmp    %edi,%eax
8010700b:	74 ab                	je     80106fb8 <loaduvm+0x28>
}
8010700d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    
8010701a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107020:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107023:	31 c0                	xor    %eax,%eax
}
80107025:	5b                   	pop    %ebx
80107026:	5e                   	pop    %esi
80107027:	5f                   	pop    %edi
80107028:	5d                   	pop    %ebp
80107029:	c3                   	ret    
      panic("loaduvm: address should exist");
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	68 67 7f 10 80       	push   $0x80107f67
80107032:	e8 59 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107037:	83 ec 0c             	sub    $0xc,%esp
8010703a:	68 08 80 10 80       	push   $0x80108008
8010703f:	e8 4c 93 ff ff       	call   80100390 <panic>
80107044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010704a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107050 <allocuvm>:
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
80107056:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107059:	8b 7d 10             	mov    0x10(%ebp),%edi
8010705c:	85 ff                	test   %edi,%edi
8010705e:	0f 88 8e 00 00 00    	js     801070f2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107064:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107067:	0f 82 93 00 00 00    	jb     80107100 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010706d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107070:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107076:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010707c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010707f:	0f 86 7e 00 00 00    	jbe    80107103 <allocuvm+0xb3>
80107085:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107088:	8b 7d 08             	mov    0x8(%ebp),%edi
8010708b:	eb 42                	jmp    801070cf <allocuvm+0x7f>
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107090:	83 ec 04             	sub    $0x4,%esp
80107093:	68 00 10 00 00       	push   $0x1000
80107098:	6a 00                	push   $0x0
8010709a:	50                   	push   %eax
8010709b:	e8 b0 d9 ff ff       	call   80104a50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070a0:	58                   	pop    %eax
801070a1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070a7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070ac:	5a                   	pop    %edx
801070ad:	6a 06                	push   $0x6
801070af:	50                   	push   %eax
801070b0:	89 da                	mov    %ebx,%edx
801070b2:	89 f8                	mov    %edi,%eax
801070b4:	e8 57 fb ff ff       	call   80106c10 <mappages>
801070b9:	83 c4 10             	add    $0x10,%esp
801070bc:	85 c0                	test   %eax,%eax
801070be:	78 50                	js     80107110 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801070c0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070c6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070c9:	0f 86 81 00 00 00    	jbe    80107150 <allocuvm+0x100>
    mem = kalloc();
801070cf:	e8 2c b4 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
801070d4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801070d6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801070d8:	75 b6                	jne    80107090 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070da:	83 ec 0c             	sub    $0xc,%esp
801070dd:	68 85 7f 10 80       	push   $0x80107f85
801070e2:	e8 79 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801070e7:	83 c4 10             	add    $0x10,%esp
801070ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801070ed:	39 45 10             	cmp    %eax,0x10(%ebp)
801070f0:	77 6e                	ja     80107160 <allocuvm+0x110>
}
801070f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801070f5:	31 ff                	xor    %edi,%edi
}
801070f7:	89 f8                	mov    %edi,%eax
801070f9:	5b                   	pop    %ebx
801070fa:	5e                   	pop    %esi
801070fb:	5f                   	pop    %edi
801070fc:	5d                   	pop    %ebp
801070fd:	c3                   	ret    
801070fe:	66 90                	xchg   %ax,%ax
    return oldsz;
80107100:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107103:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107106:	89 f8                	mov    %edi,%eax
80107108:	5b                   	pop    %ebx
80107109:	5e                   	pop    %esi
8010710a:	5f                   	pop    %edi
8010710b:	5d                   	pop    %ebp
8010710c:	c3                   	ret    
8010710d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	68 9d 7f 10 80       	push   $0x80107f9d
80107118:	e8 43 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010711d:	83 c4 10             	add    $0x10,%esp
80107120:	8b 45 0c             	mov    0xc(%ebp),%eax
80107123:	39 45 10             	cmp    %eax,0x10(%ebp)
80107126:	76 0d                	jbe    80107135 <allocuvm+0xe5>
80107128:	89 c1                	mov    %eax,%ecx
8010712a:	8b 55 10             	mov    0x10(%ebp),%edx
8010712d:	8b 45 08             	mov    0x8(%ebp),%eax
80107130:	e8 6b fb ff ff       	call   80106ca0 <deallocuvm.part.0>
      kfree(mem);
80107135:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107138:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010713a:	56                   	push   %esi
8010713b:	e8 10 b2 ff ff       	call   80102350 <kfree>
      return 0;
80107140:	83 c4 10             	add    $0x10,%esp
}
80107143:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107146:	89 f8                	mov    %edi,%eax
80107148:	5b                   	pop    %ebx
80107149:	5e                   	pop    %esi
8010714a:	5f                   	pop    %edi
8010714b:	5d                   	pop    %ebp
8010714c:	c3                   	ret    
8010714d:	8d 76 00             	lea    0x0(%esi),%esi
80107150:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107153:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107156:	5b                   	pop    %ebx
80107157:	89 f8                	mov    %edi,%eax
80107159:	5e                   	pop    %esi
8010715a:	5f                   	pop    %edi
8010715b:	5d                   	pop    %ebp
8010715c:	c3                   	ret    
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
80107160:	89 c1                	mov    %eax,%ecx
80107162:	8b 55 10             	mov    0x10(%ebp),%edx
80107165:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107168:	31 ff                	xor    %edi,%edi
8010716a:	e8 31 fb ff ff       	call   80106ca0 <deallocuvm.part.0>
8010716f:	eb 92                	jmp    80107103 <allocuvm+0xb3>
80107171:	eb 0d                	jmp    80107180 <deallocuvm>
80107173:	90                   	nop
80107174:	90                   	nop
80107175:	90                   	nop
80107176:	90                   	nop
80107177:	90                   	nop
80107178:	90                   	nop
80107179:	90                   	nop
8010717a:	90                   	nop
8010717b:	90                   	nop
8010717c:	90                   	nop
8010717d:	90                   	nop
8010717e:	90                   	nop
8010717f:	90                   	nop

80107180 <deallocuvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	8b 55 0c             	mov    0xc(%ebp),%edx
80107186:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107189:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010718c:	39 d1                	cmp    %edx,%ecx
8010718e:	73 10                	jae    801071a0 <deallocuvm+0x20>
}
80107190:	5d                   	pop    %ebp
80107191:	e9 0a fb ff ff       	jmp    80106ca0 <deallocuvm.part.0>
80107196:	8d 76 00             	lea    0x0(%esi),%esi
80107199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071a0:	89 d0                	mov    %edx,%eax
801071a2:	5d                   	pop    %ebp
801071a3:	c3                   	ret    
801071a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 0c             	sub    $0xc,%esp
801071b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071bc:	85 f6                	test   %esi,%esi
801071be:	74 59                	je     80107219 <freevm+0x69>
801071c0:	31 c9                	xor    %ecx,%ecx
801071c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071c7:	89 f0                	mov    %esi,%eax
801071c9:	e8 d2 fa ff ff       	call   80106ca0 <deallocuvm.part.0>
801071ce:	89 f3                	mov    %esi,%ebx
801071d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071d6:	eb 0f                	jmp    801071e7 <freevm+0x37>
801071d8:	90                   	nop
801071d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071e0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071e3:	39 fb                	cmp    %edi,%ebx
801071e5:	74 23                	je     8010720a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071e7:	8b 03                	mov    (%ebx),%eax
801071e9:	a8 01                	test   $0x1,%al
801071eb:	74 f3                	je     801071e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071f2:	83 ec 0c             	sub    $0xc,%esp
801071f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071fd:	50                   	push   %eax
801071fe:	e8 4d b1 ff ff       	call   80102350 <kfree>
80107203:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107206:	39 fb                	cmp    %edi,%ebx
80107208:	75 dd                	jne    801071e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010720a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010720d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107210:	5b                   	pop    %ebx
80107211:	5e                   	pop    %esi
80107212:	5f                   	pop    %edi
80107213:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107214:	e9 37 b1 ff ff       	jmp    80102350 <kfree>
    panic("freevm: no pgdir");
80107219:	83 ec 0c             	sub    $0xc,%esp
8010721c:	68 b9 7f 10 80       	push   $0x80107fb9
80107221:	e8 6a 91 ff ff       	call   80100390 <panic>
80107226:	8d 76 00             	lea    0x0(%esi),%esi
80107229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107230 <setupkvm>:
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	56                   	push   %esi
80107234:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107235:	e8 c6 b2 ff ff       	call   80102500 <kalloc>
8010723a:	85 c0                	test   %eax,%eax
8010723c:	89 c6                	mov    %eax,%esi
8010723e:	74 42                	je     80107282 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107240:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107243:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107248:	68 00 10 00 00       	push   $0x1000
8010724d:	6a 00                	push   $0x0
8010724f:	50                   	push   %eax
80107250:	e8 fb d7 ff ff       	call   80104a50 <memset>
80107255:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107258:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010725b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010725e:	83 ec 08             	sub    $0x8,%esp
80107261:	8b 13                	mov    (%ebx),%edx
80107263:	ff 73 0c             	pushl  0xc(%ebx)
80107266:	50                   	push   %eax
80107267:	29 c1                	sub    %eax,%ecx
80107269:	89 f0                	mov    %esi,%eax
8010726b:	e8 a0 f9 ff ff       	call   80106c10 <mappages>
80107270:	83 c4 10             	add    $0x10,%esp
80107273:	85 c0                	test   %eax,%eax
80107275:	78 19                	js     80107290 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107277:	83 c3 10             	add    $0x10,%ebx
8010727a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107280:	75 d6                	jne    80107258 <setupkvm+0x28>
}
80107282:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107285:	89 f0                	mov    %esi,%eax
80107287:	5b                   	pop    %ebx
80107288:	5e                   	pop    %esi
80107289:	5d                   	pop    %ebp
8010728a:	c3                   	ret    
8010728b:	90                   	nop
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107290:	83 ec 0c             	sub    $0xc,%esp
80107293:	56                   	push   %esi
      return 0;
80107294:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107296:	e8 15 ff ff ff       	call   801071b0 <freevm>
      return 0;
8010729b:	83 c4 10             	add    $0x10,%esp
}
8010729e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072a1:	89 f0                	mov    %esi,%eax
801072a3:	5b                   	pop    %ebx
801072a4:	5e                   	pop    %esi
801072a5:	5d                   	pop    %ebp
801072a6:	c3                   	ret    
801072a7:	89 f6                	mov    %esi,%esi
801072a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072b0 <kvmalloc>:
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072b6:	e8 75 ff ff ff       	call   80107230 <setupkvm>
801072bb:	a3 e4 44 12 80       	mov    %eax,0x801244e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072c0:	05 00 00 00 80       	add    $0x80000000,%eax
801072c5:	0f 22 d8             	mov    %eax,%cr3
}
801072c8:	c9                   	leave  
801072c9:	c3                   	ret    
801072ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
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
801072de:	e8 ad f8 ff ff       	call   80106b90 <walkpgdir>
  if(pte == 0)
801072e3:	85 c0                	test   %eax,%eax
801072e5:	74 05                	je     801072ec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801072e7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072ea:	c9                   	leave  
801072eb:	c3                   	ret    
    panic("clearpteu");
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	68 ca 7f 10 80       	push   $0x80107fca
801072f4:	e8 97 90 ff ff       	call   80100390 <panic>
801072f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107300 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107309:	e8 22 ff ff ff       	call   80107230 <setupkvm>
8010730e:	85 c0                	test   %eax,%eax
80107310:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107313:	0f 84 9f 00 00 00    	je     801073b8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010731c:	85 c9                	test   %ecx,%ecx
8010731e:	0f 84 94 00 00 00    	je     801073b8 <copyuvm+0xb8>
80107324:	31 ff                	xor    %edi,%edi
80107326:	eb 4a                	jmp    80107372 <copyuvm+0x72>
80107328:	90                   	nop
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107330:	83 ec 04             	sub    $0x4,%esp
80107333:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107339:	68 00 10 00 00       	push   $0x1000
8010733e:	53                   	push   %ebx
8010733f:	50                   	push   %eax
80107340:	e8 bb d7 ff ff       	call   80104b00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107345:	58                   	pop    %eax
80107346:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010734c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107351:	5a                   	pop    %edx
80107352:	ff 75 e4             	pushl  -0x1c(%ebp)
80107355:	50                   	push   %eax
80107356:	89 fa                	mov    %edi,%edx
80107358:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010735b:	e8 b0 f8 ff ff       	call   80106c10 <mappages>
80107360:	83 c4 10             	add    $0x10,%esp
80107363:	85 c0                	test   %eax,%eax
80107365:	78 61                	js     801073c8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107367:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010736d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107370:	76 46                	jbe    801073b8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107372:	8b 45 08             	mov    0x8(%ebp),%eax
80107375:	31 c9                	xor    %ecx,%ecx
80107377:	89 fa                	mov    %edi,%edx
80107379:	e8 12 f8 ff ff       	call   80106b90 <walkpgdir>
8010737e:	85 c0                	test   %eax,%eax
80107380:	74 61                	je     801073e3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107382:	8b 00                	mov    (%eax),%eax
80107384:	a8 01                	test   $0x1,%al
80107386:	74 4e                	je     801073d6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107388:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010738a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010738f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107395:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107398:	e8 63 b1 ff ff       	call   80102500 <kalloc>
8010739d:	85 c0                	test   %eax,%eax
8010739f:	89 c6                	mov    %eax,%esi
801073a1:	75 8d                	jne    80107330 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801073a3:	83 ec 0c             	sub    $0xc,%esp
801073a6:	ff 75 e0             	pushl  -0x20(%ebp)
801073a9:	e8 02 fe ff ff       	call   801071b0 <freevm>
  return 0;
801073ae:	83 c4 10             	add    $0x10,%esp
801073b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801073b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073be:	5b                   	pop    %ebx
801073bf:	5e                   	pop    %esi
801073c0:	5f                   	pop    %edi
801073c1:	5d                   	pop    %ebp
801073c2:	c3                   	ret    
801073c3:	90                   	nop
801073c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073c8:	83 ec 0c             	sub    $0xc,%esp
801073cb:	56                   	push   %esi
801073cc:	e8 7f af ff ff       	call   80102350 <kfree>
      goto bad;
801073d1:	83 c4 10             	add    $0x10,%esp
801073d4:	eb cd                	jmp    801073a3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801073d6:	83 ec 0c             	sub    $0xc,%esp
801073d9:	68 ee 7f 10 80       	push   $0x80107fee
801073de:	e8 ad 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801073e3:	83 ec 0c             	sub    $0xc,%esp
801073e6:	68 d4 7f 10 80       	push   $0x80107fd4
801073eb:	e8 a0 8f ff ff       	call   80100390 <panic>

801073f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073f1:	31 c9                	xor    %ecx,%ecx
{
801073f3:	89 e5                	mov    %esp,%ebp
801073f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073fb:	8b 45 08             	mov    0x8(%ebp),%eax
801073fe:	e8 8d f7 ff ff       	call   80106b90 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107403:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107405:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107406:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107408:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010740d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107410:	05 00 00 00 80       	add    $0x80000000,%eax
80107415:	83 fa 05             	cmp    $0x5,%edx
80107418:	ba 00 00 00 00       	mov    $0x0,%edx
8010741d:	0f 45 c2             	cmovne %edx,%eax
}
80107420:	c3                   	ret    
80107421:	eb 0d                	jmp    80107430 <copyout>
80107423:	90                   	nop
80107424:	90                   	nop
80107425:	90                   	nop
80107426:	90                   	nop
80107427:	90                   	nop
80107428:	90                   	nop
80107429:	90                   	nop
8010742a:	90                   	nop
8010742b:	90                   	nop
8010742c:	90                   	nop
8010742d:	90                   	nop
8010742e:	90                   	nop
8010742f:	90                   	nop

80107430 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 1c             	sub    $0x1c,%esp
80107439:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010743c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010743f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107442:	85 db                	test   %ebx,%ebx
80107444:	75 40                	jne    80107486 <copyout+0x56>
80107446:	eb 70                	jmp    801074b8 <copyout+0x88>
80107448:	90                   	nop
80107449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107450:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107453:	89 f1                	mov    %esi,%ecx
80107455:	29 d1                	sub    %edx,%ecx
80107457:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010745d:	39 d9                	cmp    %ebx,%ecx
8010745f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107462:	29 f2                	sub    %esi,%edx
80107464:	83 ec 04             	sub    $0x4,%esp
80107467:	01 d0                	add    %edx,%eax
80107469:	51                   	push   %ecx
8010746a:	57                   	push   %edi
8010746b:	50                   	push   %eax
8010746c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010746f:	e8 8c d6 ff ff       	call   80104b00 <memmove>
    len -= n;
    buf += n;
80107474:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107477:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010747a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107480:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107482:	29 cb                	sub    %ecx,%ebx
80107484:	74 32                	je     801074b8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107486:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107488:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010748b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010748e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107494:	56                   	push   %esi
80107495:	ff 75 08             	pushl  0x8(%ebp)
80107498:	e8 53 ff ff ff       	call   801073f0 <uva2ka>
    if(pa0 == 0)
8010749d:	83 c4 10             	add    $0x10,%esp
801074a0:	85 c0                	test   %eax,%eax
801074a2:	75 ac                	jne    80107450 <copyout+0x20>
  }
  return 0;
}
801074a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074ac:	5b                   	pop    %ebx
801074ad:	5e                   	pop    %esi
801074ae:	5f                   	pop    %edi
801074af:	5d                   	pop    %ebp
801074b0:	c3                   	ret    
801074b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074bb:	31 c0                	xor    %eax,%eax
}
801074bd:	5b                   	pop    %ebx
801074be:	5e                   	pop    %esi
801074bf:	5f                   	pop    %edi
801074c0:	5d                   	pop    %ebp
801074c1:	c3                   	ret    
