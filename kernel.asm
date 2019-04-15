
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
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 78 10 80       	push   $0x80107860
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 65 4a 00 00       	call   80104ac0 <initlock>
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
80100092:	68 67 78 10 80       	push   $0x80107867
80100097:	50                   	push   %eax
80100098:	e8 f3 48 00 00       	call   80104990 <initsleeplock>
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
801000e4:	e8 17 4b 00 00       	call   80104c00 <acquire>
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
80100162:	e8 59 4b 00 00       	call   80104cc0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 48 00 00       	call   801049d0 <acquiresleep>
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
80100193:	68 6e 78 10 80       	push   $0x8010786e
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
801001ae:	e8 bd 48 00 00       	call   80104a70 <holdingsleep>
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
801001cc:	68 7f 78 10 80       	push   $0x8010787f
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
801001ef:	e8 7c 48 00 00       	call   80104a70 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 48 00 00       	call   80104a30 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 f0 49 00 00       	call   80104c00 <acquire>
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
8010025c:	e9 5f 4a 00 00       	jmp    80104cc0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 78 10 80       	push   $0x80107886
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
8010028c:	e8 6f 49 00 00       	call   80104c00 <acquire>
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
801002c5:	e8 76 3c 00 00       	call   80103f40 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 20 36 00 00       	call   80103900 <myproc>
801002e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 cc 49 00 00       	call   80104cc0 <release>
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
8010034d:	e8 6e 49 00 00       	call   80104cc0 <release>
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
801003a9:	e8 b2 23 00 00       	call   80102760 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 78 10 80       	push   $0x8010788d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 87 82 10 80 	movl   $0x80108287,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 47 00 00       	call   80104ae0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 78 10 80       	push   $0x801078a1
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
8010043a:	e8 11 60 00 00       	call   80106450 <uartputc>
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
801004ec:	e8 5f 5f 00 00       	call   80106450 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 53 5f 00 00       	call   80106450 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 47 5f 00 00       	call   80106450 <uartputc>
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
80100524:	e8 a7 48 00 00       	call   80104dd0 <memmove>
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
80100541:	e8 da 47 00 00       	call   80104d20 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 78 10 80       	push   $0x801078a5
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
801005b1:	0f b6 92 d0 78 10 80 	movzbl -0x7fef8730(%edx),%edx
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
8010061b:	e8 e0 45 00 00       	call   80104c00 <acquire>
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
80100647:	e8 74 46 00 00       	call   80104cc0 <release>
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
8010071f:	e8 9c 45 00 00       	call   80104cc0 <release>
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
801007d0:	ba b8 78 10 80       	mov    $0x801078b8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 0b 44 00 00       	call   80104c00 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 78 10 80       	push   $0x801078bf
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
80100823:	e8 d8 43 00 00       	call   80104c00 <acquire>
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
80100888:	e8 33 44 00 00       	call   80104cc0 <release>
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
80100916:	e8 15 3b 00 00       	call   80104430 <wakeup>
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
80100997:	e9 f4 3b 00 00       	jmp    80104590 <procdump>
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
801009c6:	68 c8 78 10 80       	push   $0x801078c8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 eb 40 00 00       	call   80104ac0 <initlock>

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
80100a1c:	e8 df 2e 00 00       	call   80103900 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
    struct  thread *curthread = mythread();
80100a27:	e8 04 2f 00 00       	call   80103930 <mythread>
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
80100a9c:	e8 0f 6b 00 00       	call   801075b0 <setupkvm>
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
80100ac1:	0f 84 a7 02 00 00    	je     80100d6e <exec+0x35e>
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
80100afe:	e8 cd 68 00 00       	call   801073d0 <allocuvm>
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
80100b30:	e8 db 67 00 00       	call   80107310 <loaduvm>
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
80100b7a:	e8 b1 69 00 00       	call   80107530 <freevm>
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
80100bb2:	e8 19 68 00 00       	call   801073d0 <allocuvm>
80100bb7:	83 c4 10             	add    $0x10,%esp
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	89 c6                	mov    %eax,%esi
80100bbe:	75 3a                	jne    80100bfa <exec+0x1ea>
        freevm(pgdir);
80100bc0:	83 ec 0c             	sub    $0xc,%esp
80100bc3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bc9:	e8 62 69 00 00       	call   80107530 <freevm>
80100bce:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd6:	e9 ac fe ff ff       	jmp    80100a87 <exec+0x77>
        end_op();
80100bdb:	e8 60 20 00 00       	call   80102c40 <end_op>
        cprintf("exec: fail\n");
80100be0:	83 ec 0c             	sub    $0xc,%esp
80100be3:	68 e1 78 10 80       	push   $0x801078e1
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
80100c0e:	e8 3d 6a 00 00       	call   80107650 <clearpteu>
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
80100c41:	e8 fa 42 00 00       	call   80104f40 <strlen>
80100c46:	f7 d0                	not    %eax
80100c48:	01 c3                	add    %eax,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c4a:	58                   	pop    %eax
80100c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c4e:	83 e3 fc             	and    $0xfffffffc,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c51:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c54:	e8 e7 42 00 00       	call   80104f40 <strlen>
80100c59:	83 c0 01             	add    $0x1,%eax
80100c5c:	50                   	push   %eax
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c60:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c63:	53                   	push   %ebx
80100c64:	56                   	push   %esi
80100c65:	e8 46 6b 00 00       	call   801077b0 <copyout>
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
80100ccf:	e8 dc 6a 00 00       	call   801077b0 <copyout>
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
80100d10:	e8 eb 41 00 00       	call   80104f00 <safestrcpy>
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
80100d47:	e8 e4 32 00 00       	call   80104030 <cleanProcOneThread>
    curproc->mainThread=curthread;
80100d4c:	89 f1                	mov    %esi,%ecx
80100d4e:	89 99 b4 03 00 00    	mov    %ebx,0x3b4(%ecx)
    switchuvm(curproc);
80100d54:	89 34 24             	mov    %esi,(%esp)
80100d57:	e8 14 64 00 00       	call   80107170 <switchuvm>
    freevm(oldpgdir);
80100d5c:	89 3c 24             	mov    %edi,(%esp)
80100d5f:	e8 cc 67 00 00       	call   80107530 <freevm>
    return 0;
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	31 c0                	xor    %eax,%eax
80100d69:	e9 19 fd ff ff       	jmp    80100a87 <exec+0x77>
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d6e:	be 00 20 00 00       	mov    $0x2000,%esi
80100d73:	e9 21 fe ff ff       	jmp    80100b99 <exec+0x189>
80100d78:	66 90                	xchg   %ax,%ax
80100d7a:	66 90                	xchg   %ax,%ax
80100d7c:	66 90                	xchg   %ax,%ax
80100d7e:	66 90                	xchg   %ax,%ax

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
80100d86:	68 ed 78 10 80       	push   $0x801078ed
80100d8b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d90:	e8 2b 3d 00 00       	call   80104ac0 <initlock>
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
80100da4:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100da9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dac:	68 e0 0f 11 80       	push   $0x80110fe0
80100db1:	e8 4a 3e 00 00       	call   80104c00 <acquire>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 10                	jmp    80100dcb <filealloc+0x2b>
80100dbb:	90                   	nop
80100dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
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
80100ddc:	68 e0 0f 11 80       	push   $0x80110fe0
80100de1:	e8 da 3e 00 00       	call   80104cc0 <release>
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
80100df5:	68 e0 0f 11 80       	push   $0x80110fe0
80100dfa:	e8 c1 3e 00 00       	call   80104cc0 <release>
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
80100e1a:	68 e0 0f 11 80       	push   $0x80110fe0
80100e1f:	e8 dc 3d 00 00       	call   80104c00 <acquire>
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
80100e37:	68 e0 0f 11 80       	push   $0x80110fe0
80100e3c:	e8 7f 3e 00 00       	call   80104cc0 <release>
  return f;
}
80100e41:	89 d8                	mov    %ebx,%eax
80100e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e46:	c9                   	leave  
80100e47:	c3                   	ret    
    panic("filedup");
80100e48:	83 ec 0c             	sub    $0xc,%esp
80100e4b:	68 f4 78 10 80       	push   $0x801078f4
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
80100e6c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e71:	e8 8a 3d 00 00       	call   80104c00 <acquire>
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
80100e8e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
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
80100e9c:	e9 1f 3e 00 00       	jmp    80104cc0 <release>
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
80100ec0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ec8:	e8 f3 3d 00 00       	call   80104cc0 <release>
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
80100f22:	68 fc 78 10 80       	push   $0x801078fc
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
80101002:	68 06 79 10 80       	push   $0x80107906
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
80101115:	68 0f 79 10 80       	push   $0x8010790f
8010111a:	e8 71 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 15 79 10 80       	push   $0x80107915
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
80101139:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
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
8010115c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101162:	50                   	push   %eax
80101163:	ff 75 d8             	pushl  -0x28(%ebp)
80101166:	e8 65 ef ff ff       	call   801000d0 <bread>
8010116b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
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
80101194:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
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
801011c9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801011cf:	77 80                	ja     80101151 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011d1:	83 ec 0c             	sub    $0xc,%esp
801011d4:	68 1f 79 10 80       	push   $0x8010791f
801011d9:	e8 b2 f1 ff ff       	call   80100390 <panic>
801011de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011e6:	09 da                	or     %ebx,%edx
801011e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
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
80101207:	8d 40 5c             	lea    0x5c(%eax),%eax
8010120a:	83 c4 0c             	add    $0xc,%esp
8010120d:	68 00 02 00 00       	push   $0x200
80101212:	6a 00                	push   $0x0
80101214:	50                   	push   %eax
80101215:	e8 06 3b 00 00       	call   80104d20 <memset>
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
8010124a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010124f:	83 ec 28             	sub    $0x28,%esp
80101252:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101255:	68 00 1a 11 80       	push   $0x80111a00
8010125a:	e8 a1 39 00 00       	call   80104c00 <acquire>
8010125f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101265:	eb 17                	jmp    8010127e <iget+0x3e>
80101267:	89 f6                	mov    %esi,%esi
80101269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101270:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101276:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
80101292:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101298:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 00 1a 11 80       	push   $0x80111a00
801012bf:	e8 fc 39 00 00       	call   80104cc0 <release>

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
801012e5:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801012ea:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012ed:	e8 ce 39 00 00       	call   80104cc0 <release>
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
80101302:	68 35 79 10 80       	push   $0x80107935
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
80101323:	8b 5f 5c             	mov    0x5c(%edi),%ebx
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
80101344:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010134a:	8b 00                	mov    (%eax),%eax
8010134c:	85 d2                	test   %edx,%edx
8010134e:	74 70                	je     801013c0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101350:	83 ec 08             	sub    $0x8,%esp
80101353:	52                   	push   %edx
80101354:	50                   	push   %eax
80101355:	e8 76 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010135a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
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
801013a7:	89 47 5c             	mov    %eax,0x5c(%edi)
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
801013c7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013cd:	8b 06                	mov    (%esi),%eax
801013cf:	e9 7c ff ff ff       	jmp    80101350 <bmap+0x40>
  panic("bmap: out of range");
801013d4:	83 ec 0c             	sub    $0xc,%esp
801013d7:	68 45 79 10 80       	push   $0x80107945
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
80101407:	8d 40 5c             	lea    0x5c(%eax),%eax
8010140a:	83 c4 0c             	add    $0xc,%esp
8010140d:	6a 1c                	push   $0x1c
8010140f:	50                   	push   %eax
80101410:	56                   	push   %esi
80101411:	e8 ba 39 00 00       	call   80104dd0 <memmove>
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
8010143c:	68 e0 19 11 80       	push   $0x801119e0
80101441:	50                   	push   %eax
80101442:	e8 a9 ff ff ff       	call   801013f0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101447:	58                   	pop    %eax
80101448:	5a                   	pop    %edx
80101449:	89 da                	mov    %ebx,%edx
8010144b:	c1 ea 0c             	shr    $0xc,%edx
8010144e:	03 15 f8 19 11 80    	add    0x801119f8,%edx
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
80101473:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101478:	85 d1                	test   %edx,%ecx
8010147a:	74 25                	je     801014a1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010147c:	f7 d2                	not    %edx
8010147e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101480:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101483:	21 ca                	and    %ecx,%edx
80101485:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
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
801014a4:	68 58 79 10 80       	push   $0x80107958
801014a9:	e8 e2 ee ff ff       	call   80100390 <panic>
801014ae:	66 90                	xchg   %ax,%ax

801014b0 <iinit>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
801014b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014bc:	68 6b 79 10 80       	push   $0x8010796b
801014c1:	68 00 1a 11 80       	push   $0x80111a00
801014c6:	e8 f5 35 00 00       	call   80104ac0 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 72 79 10 80       	push   $0x80107972
801014d8:	53                   	push   %ebx
801014d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014df:	e8 ac 34 00 00       	call   80104990 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014e4:	83 c4 10             	add    $0x10,%esp
801014e7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014ed:	75 e1                	jne    801014d0 <iinit+0x20>
  readsb(dev, &sb);
801014ef:	83 ec 08             	sub    $0x8,%esp
801014f2:	68 e0 19 11 80       	push   $0x801119e0
801014f7:	ff 75 08             	pushl  0x8(%ebp)
801014fa:	e8 f1 fe ff ff       	call   801013f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ff:	ff 35 f8 19 11 80    	pushl  0x801119f8
80101505:	ff 35 f4 19 11 80    	pushl  0x801119f4
8010150b:	ff 35 f0 19 11 80    	pushl  0x801119f0
80101511:	ff 35 ec 19 11 80    	pushl  0x801119ec
80101517:	ff 35 e8 19 11 80    	pushl  0x801119e8
8010151d:	ff 35 e4 19 11 80    	pushl  0x801119e4
80101523:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101529:	68 d8 79 10 80       	push   $0x801079d8
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
80101549:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
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
8010157f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101585:	76 69                	jbe    801015f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101587:	89 d8                	mov    %ebx,%eax
80101589:	83 ec 08             	sub    $0x8,%esp
8010158c:	c1 e8 03             	shr    $0x3,%eax
8010158f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
801015a9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015b1:	75 bd                	jne    80101570 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015b3:	83 ec 04             	sub    $0x4,%esp
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	6a 40                	push   $0x40
801015bb:	6a 00                	push   $0x0
801015bd:	51                   	push   %ecx
801015be:	e8 5d 37 00 00       	call   80104d20 <memset>
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
801015f3:	68 78 79 10 80       	push   $0x80107978
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
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 f4 19 11 80    	add    0x801119f4,%eax
8010161a:	50                   	push   %eax
8010161b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010161e:	e8 ad ea ff ff       	call   801000d0 <bread>
80101623:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101625:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101628:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010162f:	83 e0 07             	and    $0x7,%eax
80101632:	c1 e0 06             	shl    $0x6,%eax
80101635:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
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
80101661:	e8 6a 37 00 00       	call   80104dd0 <memmove>
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
8010168a:	68 00 1a 11 80       	push   $0x80111a00
8010168f:	e8 6c 35 00 00       	call   80104c00 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010169f:	e8 1c 36 00 00       	call   80104cc0 <release>
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
801016d2:	e8 f9 32 00 00       	call   801049d0 <acquiresleep>
  if(ip->valid == 0){
801016d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
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
801016f9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101719:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010171f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101723:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101727:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010172b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010172f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101733:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101737:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010173b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010173e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101741:	6a 34                	push   $0x34
80101743:	50                   	push   %eax
80101744:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101747:	50                   	push   %eax
80101748:	e8 83 36 00 00       	call   80104dd0 <memmove>
    brelse(bp);
8010174d:	89 34 24             	mov    %esi,(%esp)
80101750:	e8 8b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101755:	83 c4 10             	add    $0x10,%esp
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 77 ff ff ff    	jne    801016e1 <ilock+0x31>
      panic("ilock: no type");
8010176a:	83 ec 0c             	sub    $0xc,%esp
8010176d:	68 90 79 10 80       	push   $0x80107990
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 8a 79 10 80       	push   $0x8010798a
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
801017a3:	e8 c8 32 00 00       	call   80104a70 <holdingsleep>
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
801017bf:	e9 6c 32 00 00       	jmp    80104a30 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 9f 79 10 80       	push   $0x8010799f
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
801017f0:	e8 db 31 00 00       	call   801049d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	85 d2                	test   %edx,%edx
801017fd:	74 07                	je     80101806 <iput+0x26>
801017ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101804:	74 32                	je     80101838 <iput+0x58>
  releasesleep(&ip->lock);
80101806:	83 ec 0c             	sub    $0xc,%esp
80101809:	57                   	push   %edi
8010180a:	e8 21 32 00 00       	call   80104a30 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101816:	e8 e5 33 00 00       	call   80104c00 <acquire>
  ip->ref--;
8010181b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010181f:	83 c4 10             	add    $0x10,%esp
80101822:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5f                   	pop    %edi
8010182f:	5d                   	pop    %ebp
  release(&icache.lock);
80101830:	e9 8b 34 00 00       	jmp    80104cc0 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 00 1a 11 80       	push   $0x80111a00
80101840:	e8 bb 33 00 00       	call   80104c00 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010184f:	e8 6c 34 00 00       	call   80104cc0 <release>
    if(r == 1){
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	83 fe 01             	cmp    $0x1,%esi
8010185a:	75 aa                	jne    80101806 <iput+0x26>
8010185c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101862:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101865:	8d 73 5c             	lea    0x5c(%ebx),%esi
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
80101890:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
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
801018a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018a7:	53                   	push   %ebx
801018a8:	e8 53 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
801018ad:	31 c0                	xor    %eax,%eax
801018af:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018b3:	89 1c 24             	mov    %ebx,(%esp)
801018b6:	e8 45 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018bb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	e9 3c ff ff ff       	jmp    80101806 <iput+0x26>
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	83 ec 08             	sub    $0x8,%esp
801018d3:	50                   	push   %eax
801018d4:	ff 33                	pushl  (%ebx)
801018d6:	e8 f5 e7 ff ff       	call   801000d0 <bread>
801018db:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018e1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018e7:	8d 70 5c             	lea    0x5c(%eax),%esi
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
8010191c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101922:	8b 03                	mov    (%ebx),%eax
80101924:	e8 07 fb ff ff       	call   80101430 <bfree>
    ip->addrs[NDIRECT] = 0;
80101929:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
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
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
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
801019a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
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
801019bc:	8b 40 58             	mov    0x58(%eax),%eax
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
80101a20:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
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
80101a37:	e8 94 33 00 00       	call   80104dd0 <memmove>
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
80101a60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 17                	ja     80101a81 <readi+0xf1>
80101a6a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
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
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
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
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
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
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
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
80101b33:	e8 98 32 00 00       	call   80104dd0 <memmove>
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
80101b5c:	3b 70 58             	cmp    0x58(%eax),%esi
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
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 36                	ja     80101bb0 <writei+0x120>
80101b7a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
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
80101b9e:	89 70 58             	mov    %esi,0x58(%eax)
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
80101bce:	e8 6d 32 00 00       	call   80104e40 <strncmp>
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
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 85 00 00 00    	jne    80101c7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
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
80101c2d:	e8 0e 32 00 00       	call   80104e40 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 17                	je     80101c50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c39:	83 c7 10             	add    $0x10,%edi
80101c3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
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
80101c72:	68 b9 79 10 80       	push   $0x801079b9
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 a7 79 10 80       	push   $0x801079a7
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
80101ca9:	e8 52 1c 00 00       	call   80103900 <myproc>
  acquire(&icache.lock);
80101cae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cb1:	8b 70 60             	mov    0x60(%eax),%esi
  acquire(&icache.lock);
80101cb4:	68 00 1a 11 80       	push   $0x80111a00
80101cb9:	e8 42 2f 00 00       	call   80104c00 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cc9:	e8 f2 2f 00 00       	call   80104cc0 <release>
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
80101d25:	e8 a6 30 00 00       	call   80104dd0 <memmove>
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
80101d54:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
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
80101db8:	e8 13 30 00 00       	call   80104dd0 <memmove>
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
80101e6e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e71:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e74:	85 ff                	test   %edi,%edi
80101e76:	74 29                	je     80101ea1 <dirlink+0x51>
80101e78:	31 ff                	xor    %edi,%edi
80101e7a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e7d:	eb 09                	jmp    80101e88 <dirlink+0x38>
80101e7f:	90                   	nop
80101e80:	83 c7 10             	add    $0x10,%edi
80101e83:	3b 7b 58             	cmp    0x58(%ebx),%edi
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
80101ead:	e8 ee 2f 00 00       	call   80104ea0 <strncpy>
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
80101eeb:	68 c8 79 10 80       	push   $0x801079c8
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 6e 80 10 80       	push   $0x8010806e
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
80101ff5:	83 c6 5c             	add    $0x5c,%esi
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
8010200b:	68 34 7a 10 80       	push   $0x80107a34
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 2b 7a 10 80       	push   $0x80107a2b
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 46 7a 10 80       	push   $0x80107a46
8010203b:	68 80 b5 10 80       	push   $0x8010b580
80102040:	e8 7b 2a 00 00       	call   80104ac0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102045:	58                   	pop    %eax
80102046:	a1 40 3d 11 80       	mov    0x80113d40,%eax
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
801020be:	e8 3d 2b 00 00       	call   80104c00 <acquire>

  if((b = idequeue) == 0){
801020c3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	85 db                	test   %ebx,%ebx
801020ce:	74 67                	je     80102137 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020d0:	8b 43 58             	mov    0x58(%ebx),%eax
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
80102101:	8d 7b 5c             	lea    0x5c(%ebx),%edi
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
80102121:	e8 0a 23 00 00       	call   80104430 <wakeup>

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
8010213f:	e8 7c 2b 00 00       	call   80104cc0 <release>

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
8010215e:	e8 0d 29 00 00       	call   80104a70 <holdingsleep>
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
80102198:	e8 63 2a 00 00       	call   80104c00 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801021a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	85 d2                	test   %edx,%edx
801021af:	75 09                	jne    801021ba <iderw+0x6a>
801021b1:	eb 6d                	jmp    80102220 <iderw+0xd0>
801021b3:	90                   	nop
801021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b8:	89 c2                	mov    %eax,%edx
801021ba:	8b 42 58             	mov    0x58(%edx),%eax
801021bd:	85 c0                	test   %eax,%eax
801021bf:	75 f7                	jne    801021b8 <iderw+0x68>
801021c1:	83 c2 58             	add    $0x58,%edx
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
801021e9:	e8 52 1d 00 00       	call   80103f40 <sleep>
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
80102206:	e9 b5 2a 00 00       	jmp    80104cc0 <release>
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
8010222a:	68 60 7a 10 80       	push   $0x80107a60
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 4a 7a 10 80       	push   $0x80107a4a
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 75 7a 10 80       	push   $0x80107a75
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
80102251:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102258:	00 c0 fe 
{
8010225b:	89 e5                	mov    %esp,%ebp
8010225d:	56                   	push   %esi
8010225e:	53                   	push   %ebx
  ioapic->reg = reg;
8010225f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102266:	00 00 00 
  return ioapic->data;
80102269:	a1 54 36 11 80       	mov    0x80113654,%eax
8010226e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102277:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010227d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
80102297:	68 94 7a 10 80       	push   $0x80107a94
8010229c:	e8 bf e3 ff ff       	call   80100660 <cprintf>
801022a1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
801022c2:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

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
801022e0:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102301:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102315:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010231b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010231e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102321:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102324:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102326:	a1 54 36 11 80       	mov    0x80113654,%eax
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
80102352:	81 fb e8 34 12 80    	cmp    $0x801234e8,%ebx
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
80102372:	e8 a9 29 00 00       	call   80104d20 <memset>

  if(kmem.use_lock)
80102377:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	85 d2                	test   %edx,%edx
80102382:	75 2c                	jne    801023b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102384:	a1 98 36 11 80       	mov    0x80113698,%eax
80102389:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010238b:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
80102390:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
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
801023a0:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
801023a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023aa:	c9                   	leave  
    release(&kmem.lock);
801023ab:	e9 10 29 00 00       	jmp    80104cc0 <release>
    acquire(&kmem.lock);
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 60 36 11 80       	push   $0x80113660
801023b8:	e8 43 28 00 00       	call   80104c00 <acquire>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	eb c2                	jmp    80102384 <kfree+0x44>
    panic("kfree");
801023c2:	83 ec 0c             	sub    $0xc,%esp
801023c5:	68 c6 7a 10 80       	push   $0x80107ac6
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
8010242b:	68 cc 7a 10 80       	push   $0x80107acc
80102430:	68 60 36 11 80       	push   $0x80113660
80102435:	e8 86 26 00 00       	call   80104ac0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102440:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
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
801024d4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
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
801024f0:	a1 94 36 11 80       	mov    0x80113694,%eax
801024f5:	85 c0                	test   %eax,%eax
801024f7:	75 1f                	jne    80102518 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024f9:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
801024fe:	85 c0                	test   %eax,%eax
80102500:	74 0e                	je     80102510 <kalloc+0x20>
    kmem.freelist = r->next;
80102502:	8b 10                	mov    (%eax),%edx
80102504:	89 15 98 36 11 80    	mov    %edx,0x80113698
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
8010251e:	68 60 36 11 80       	push   $0x80113660
80102523:	e8 d8 26 00 00       	call   80104c00 <acquire>
  r = kmem.freelist;
80102528:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102536:	85 c0                	test   %eax,%eax
80102538:	74 08                	je     80102542 <kalloc+0x52>
    kmem.freelist = r->next;
8010253a:	8b 08                	mov    (%eax),%ecx
8010253c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102542:	85 d2                	test   %edx,%edx
80102544:	74 16                	je     8010255c <kalloc+0x6c>
    release(&kmem.lock);
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010254c:	68 60 36 11 80       	push   $0x80113660
80102551:	e8 6a 27 00 00       	call   80104cc0 <release>
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
80102577:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

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
801025a3:	0f b6 82 00 7c 10 80 	movzbl -0x7fef8400(%edx),%eax
801025aa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ac:	0f b6 82 00 7b 10 80 	movzbl -0x7fef8500(%edx),%eax
801025b3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025b5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025b7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025bd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025c0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c3:	8b 04 85 e0 7a 10 80 	mov    -0x7fef8520(,%eax,4),%eax
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
801025e8:	0f b6 82 00 7c 10 80 	movzbl -0x7fef8400(%edx),%eax
801025ef:	83 c8 40             	or     $0x40,%eax
801025f2:	0f b6 c0             	movzbl %al,%eax
801025f5:	f7 d0                	not    %eax
801025f7:	21 c1                	and    %eax,%ecx
    return 0;
801025f9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025fb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
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
8010260d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
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
80102660:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
80102760:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
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
80102780:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
801027ee:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
80102967:	e8 04 24 00 00       	call   80104d70 <memcmp>
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
80102a30:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
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
80102a50:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a55:	83 ec 08             	sub    $0x8,%esp
80102a58:	01 d8                	add    %ebx,%eax
80102a5a:	83 c0 01             	add    $0x1,%eax
80102a5d:	50                   	push   %eax
80102a5e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102a64:	e8 67 d6 ff ff       	call   801000d0 <bread>
80102a69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6b:	58                   	pop    %eax
80102a6c:	5a                   	pop    %edx
80102a6d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102a74:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7d:	e8 4e d6 ff ff       	call   801000d0 <bread>
80102a82:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a84:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a87:	83 c4 0c             	add    $0xc,%esp
80102a8a:	68 00 02 00 00       	push   $0x200
80102a8f:	50                   	push   %eax
80102a90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a93:	50                   	push   %eax
80102a94:	e8 37 23 00 00       	call   80104dd0 <memmove>
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
80102ab4:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
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
80102ad8:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102ade:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ae4:	e8 e7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ae9:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aef:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102af2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102af4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102af6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102af9:	7e 16                	jle    80102b11 <write_head+0x41>
80102afb:	c1 e3 02             	shl    $0x2,%ebx
80102afe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b00:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102b06:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
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
80102b3a:	68 00 7d 10 80       	push   $0x80107d00
80102b3f:	68 a0 36 11 80       	push   $0x801136a0
80102b44:	e8 77 1f 00 00       	call   80104ac0 <initlock>
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
80102b5c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102b62:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102b68:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102b6d:	5a                   	pop    %edx
80102b6e:	50                   	push   %eax
80102b6f:	53                   	push   %ebx
80102b70:	e8 5b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b75:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b78:	83 c4 10             	add    $0x10,%esp
80102b7b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b7d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102b83:	7e 1c                	jle    80102ba1 <initlog+0x71>
80102b85:	c1 e3 02             	shl    $0x2,%ebx
80102b88:	31 d2                	xor    %edx,%edx
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b90:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b94:	83 c2 04             	add    $0x4,%edx
80102b97:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
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
80102baf:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
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
80102bd6:	68 a0 36 11 80       	push   $0x801136a0
80102bdb:	e8 20 20 00 00       	call   80104c00 <acquire>
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	eb 18                	jmp    80102bfd <begin_op+0x2d>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	83 ec 08             	sub    $0x8,%esp
80102beb:	68 a0 36 11 80       	push   $0x801136a0
80102bf0:	68 a0 36 11 80       	push   $0x801136a0
80102bf5:	e8 46 13 00 00       	call   80103f40 <sleep>
80102bfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bfd:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 e2                	jne    80102be8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c06:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102c0b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80102c22:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102c27:	68 a0 36 11 80       	push   $0x801136a0
80102c2c:	e8 8f 20 00 00       	call   80104cc0 <release>
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
80102c49:	68 a0 36 11 80       	push   $0x801136a0
80102c4e:	e8 ad 1f 00 00       	call   80104c00 <acquire>
  log.outstanding -= 1;
80102c53:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102c58:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102c5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c61:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c64:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c66:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
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
80102c7d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102c84:	00 00 00 
  release(&log.lock);
80102c87:	68 a0 36 11 80       	push   $0x801136a0
80102c8c:	e8 2f 20 00 00       	call   80104cc0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c91:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102c97:	83 c4 10             	add    $0x10,%esp
80102c9a:	85 c9                	test   %ecx,%ecx
80102c9c:	0f 8e 85 00 00 00    	jle    80102d27 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca2:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102ca7:	83 ec 08             	sub    $0x8,%esp
80102caa:	01 d8                	add    %ebx,%eax
80102cac:	83 c0 01             	add    $0x1,%eax
80102caf:	50                   	push   %eax
80102cb0:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102cb6:	e8 15 d4 ff ff       	call   801000d0 <bread>
80102cbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbd:	58                   	pop    %eax
80102cbe:	5a                   	pop    %edx
80102cbf:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102cc6:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102ccc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccf:	e8 fc d3 ff ff       	call   801000d0 <bread>
80102cd4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cd6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cd9:	83 c4 0c             	add    $0xc,%esp
80102cdc:	68 00 02 00 00       	push   $0x200
80102ce1:	50                   	push   %eax
80102ce2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ce5:	50                   	push   %eax
80102ce6:	e8 e5 20 00 00       	call   80104dd0 <memmove>
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
80102d06:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102d0c:	7c 94                	jl     80102ca2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d0e:	e8 bd fd ff ff       	call   80102ad0 <write_head>
    install_trans(); // Now install writes to home locations
80102d13:	e8 18 fd ff ff       	call   80102a30 <install_trans>
    log.lh.n = 0;
80102d18:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d1f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d22:	e8 a9 fd ff ff       	call   80102ad0 <write_head>
    acquire(&log.lock);
80102d27:	83 ec 0c             	sub    $0xc,%esp
80102d2a:	68 a0 36 11 80       	push   $0x801136a0
80102d2f:	e8 cc 1e 00 00       	call   80104c00 <acquire>
    wakeup(&log);
80102d34:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102d3b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102d42:	00 00 00 
    wakeup(&log);
80102d45:	e8 e6 16 00 00       	call   80104430 <wakeup>
    release(&log.lock);
80102d4a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d51:	e8 6a 1f 00 00       	call   80104cc0 <release>
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
80102d6b:	68 a0 36 11 80       	push   $0x801136a0
80102d70:	e8 bb 16 00 00       	call   80104430 <wakeup>
  release(&log.lock);
80102d75:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d7c:	e8 3f 1f 00 00       	call   80104cc0 <release>
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
80102d8f:	68 04 7d 10 80       	push   $0x80107d04
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
80102da7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db0:	83 fa 1d             	cmp    $0x1d,%edx
80102db3:	0f 8f 9d 00 00 00    	jg     80102e56 <log_write+0xb6>
80102db9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102dbe:	83 e8 01             	sub    $0x1,%eax
80102dc1:	39 c2                	cmp    %eax,%edx
80102dc3:	0f 8d 8d 00 00 00    	jge    80102e56 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dc9:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	0f 8e 8d 00 00 00    	jle    80102e63 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	68 a0 36 11 80       	push   $0x801136a0
80102dde:	e8 1d 1e 00 00       	call   80104c00 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102de3:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	83 f9 00             	cmp    $0x0,%ecx
80102def:	7e 57                	jle    80102e48 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102df4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df6:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
80102dfc:	75 0b                	jne    80102e09 <log_write+0x69>
80102dfe:	eb 38                	jmp    80102e38 <log_write+0x98>
80102e00:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80102e07:	74 2f                	je     80102e38 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e09:	83 c0 01             	add    $0x1,%eax
80102e0c:	39 c1                	cmp    %eax,%ecx
80102e0e:	75 f0                	jne    80102e00 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e10:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e17:	83 c0 01             	add    $0x1,%eax
80102e1a:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102e1f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e22:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2c:	c9                   	leave  
  release(&log.lock);
80102e2d:	e9 8e 1e 00 00       	jmp    80104cc0 <release>
80102e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e38:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
80102e3f:	eb de                	jmp    80102e1f <log_write+0x7f>
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e48:	8b 43 08             	mov    0x8(%ebx),%eax
80102e4b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102e50:	75 cd                	jne    80102e1f <log_write+0x7f>
80102e52:	31 c0                	xor    %eax,%eax
80102e54:	eb c1                	jmp    80102e17 <log_write+0x77>
    panic("too big a transaction");
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	68 13 7d 10 80       	push   $0x80107d13
80102e5e:	e8 2d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e63:	83 ec 0c             	sub    $0xc,%esp
80102e66:	68 29 7d 10 80       	push   $0x80107d29
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
80102e77:	e8 64 0a 00 00       	call   801038e0 <cpuid>
80102e7c:	89 c3                	mov    %eax,%ebx
80102e7e:	e8 5d 0a 00 00       	call   801038e0 <cpuid>
80102e83:	83 ec 04             	sub    $0x4,%esp
80102e86:	53                   	push   %ebx
80102e87:	50                   	push   %eax
80102e88:	68 44 7d 10 80       	push   $0x80107d44
80102e8d:	e8 ce d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e92:	e8 c9 31 00 00       	call   80106060 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e97:	e8 c4 09 00 00       	call   80103860 <mycpu>
80102e9c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e9e:	b8 01 00 00 00       	mov    $0x1,%eax
80102ea3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eaa:	e8 51 0e 00 00       	call   80103d00 <scheduler>
80102eaf:	90                   	nop

80102eb0 <mpenter>:
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102eb6:	e8 95 42 00 00       	call   80107150 <switchkvm>
  seginit();
80102ebb:	e8 00 42 00 00       	call   801070c0 <seginit>
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
80102ee7:	68 e8 34 12 80       	push   $0x801234e8
80102eec:	e8 2f f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102ef1:	e8 3a 47 00 00       	call   80107630 <kvmalloc>
  mpinit();        // detect other processors
80102ef6:	e8 75 01 00 00       	call   80103070 <mpinit>
  lapicinit();     // interrupt controller
80102efb:	e8 60 f7 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102f00:	e8 bb 41 00 00       	call   801070c0 <seginit>
  picinit();       // disable pic
80102f05:	e8 46 03 00 00       	call   80103250 <picinit>
  ioapicinit();    // another interrupt controller
80102f0a:	e8 41 f3 ff ff       	call   80102250 <ioapicinit>
  consoleinit();   // console hardware
80102f0f:	e8 ac da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f14:	e8 77 34 00 00       	call   80106390 <uartinit>
  pinit();         // process table
80102f19:	e8 a2 08 00 00       	call   801037c0 <pinit>
  tvinit();        // trap vectors
80102f1e:	e8 bd 30 00 00       	call   80105fe0 <tvinit>
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
80102f44:	e8 87 1e 00 00       	call   80104dd0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f49:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80102f50:	00 00 00 
80102f53:	83 c4 10             	add    $0x10,%esp
80102f56:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f5b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80102f60:	76 71                	jbe    80102fd3 <main+0x103>
80102f62:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80102f67:	89 f6                	mov    %esi,%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f70:	e8 eb 08 00 00       	call   80103860 <mycpu>
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
80102fba:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80102fc1:	00 00 00 
80102fc4:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80102fca:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102fcf:	39 c3                	cmp    %eax,%ebx
80102fd1:	72 9d                	jb     80102f70 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fd3:	83 ec 08             	sub    $0x8,%esp
80102fd6:	68 00 00 00 8e       	push   $0x8e000000
80102fdb:	68 00 00 40 80       	push   $0x80400000
80102fe0:	e8 ab f4 ff ff       	call   80102490 <kinit2>
  userinit();      // first user process
80102fe5:	e8 76 09 00 00       	call   80103960 <userinit>
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
8010301e:	68 58 7d 10 80       	push   $0x80107d58
80103023:	56                   	push   %esi
80103024:	e8 47 1d 00 00       	call   80104d70 <memcmp>
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
801030dc:	68 75 7d 10 80       	push   $0x80107d75
801030e1:	56                   	push   %esi
801030e2:	e8 89 1c 00 00       	call   80104d70 <memcmp>
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
80103147:	a3 9c 36 11 80       	mov    %eax,0x8011369c
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
80103170:	ff 24 95 9c 7d 10 80 	jmp    *-0x7fef8264(,%edx,4)
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
801031b8:	8b 0d 40 3d 11 80    	mov    0x80113d40,%ecx
801031be:	83 f9 07             	cmp    $0x7,%ecx
801031c1:	7f 19                	jg     801031dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031c7:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
801031cd:	83 c1 01             	add    $0x1,%ecx
801031d0:	89 0d 40 3d 11 80    	mov    %ecx,0x80113d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
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
801031ef:	88 15 80 37 11 80    	mov    %dl,0x80113780
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
80103223:	68 5d 7d 10 80       	push   $0x80107d5d
80103228:	e8 63 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 7c 7d 10 80       	push   $0x80107d7c
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
80103303:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010330a:	00 00 00 
  p->writeopen = 1;
8010330d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103314:	00 00 00 
  p->nwrite = 0;
80103317:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010331e:	00 00 00 
  p->nread = 0;
80103321:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103328:	00 00 00 
  initlock(&p->lock, "pipe");
8010332b:	68 b0 7d 10 80       	push   $0x80107db0
80103330:	50                   	push   %eax
80103331:	e8 8a 17 00 00       	call   80104ac0 <initlock>
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
8010338f:	e8 6c 18 00 00       	call   80104c00 <acquire>
  if(writable){
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 f6                	test   %esi,%esi
80103399:	74 45                	je     801033e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010339b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033a1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033ab:	00 00 00 
    wakeup(&p->nread);
801033ae:	50                   	push   %eax
801033af:	e8 7c 10 00 00       	call   80104430 <wakeup>
801033b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033bd:	85 d2                	test   %edx,%edx
801033bf:	75 0a                	jne    801033cb <pipeclose+0x4b>
801033c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
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
801033d4:	e9 e7 18 00 00       	jmp    80104cc0 <release>
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033e6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033f0:	00 00 00 
    wakeup(&p->nwrite);
801033f3:	50                   	push   %eax
801033f4:	e8 37 10 00 00       	call   80104430 <wakeup>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	eb b9                	jmp    801033b7 <pipeclose+0x37>
801033fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	53                   	push   %ebx
80103404:	e8 b7 18 00 00       	call   80104cc0 <release>
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
8010342d:	e8 ce 17 00 00       	call   80104c00 <acquire>
  for(i = 0; i < n; i++){
80103432:	8b 45 10             	mov    0x10(%ebp),%eax
80103435:	83 c4 10             	add    $0x10,%esp
80103438:	85 c0                	test   %eax,%eax
8010343a:	0f 8e c9 00 00 00    	jle    80103509 <pipewrite+0xe9>
80103440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103443:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103449:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010344f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103452:	03 4d 10             	add    0x10(%ebp),%ecx
80103455:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103458:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010345e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103464:	39 d0                	cmp    %edx,%eax
80103466:	75 71                	jne    801034d9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103468:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010346e:	85 c0                	test   %eax,%eax
80103470:	74 4e                	je     801034c0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103472:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103478:	eb 3a                	jmp    801034b4 <pipewrite+0x94>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	57                   	push   %edi
80103484:	e8 a7 0f 00 00       	call   80104430 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103489:	5a                   	pop    %edx
8010348a:	59                   	pop    %ecx
8010348b:	53                   	push   %ebx
8010348c:	56                   	push   %esi
8010348d:	e8 ae 0a 00 00       	call   80103f40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103492:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103498:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010349e:	83 c4 10             	add    $0x10,%esp
801034a1:	05 00 02 00 00       	add    $0x200,%eax
801034a6:	39 c2                	cmp    %eax,%edx
801034a8:	75 36                	jne    801034e0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034aa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034b0:	85 c0                	test   %eax,%eax
801034b2:	74 0c                	je     801034c0 <pipewrite+0xa0>
801034b4:	e8 47 04 00 00       	call   80103900 <myproc>
801034b9:	8b 40 1c             	mov    0x1c(%eax),%eax
801034bc:	85 c0                	test   %eax,%eax
801034be:	74 c0                	je     80103480 <pipewrite+0x60>
        release(&p->lock);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	53                   	push   %ebx
801034c4:	e8 f7 17 00 00       	call   80104cc0 <release>
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
801034ec:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034f2:	83 c6 01             	add    $0x1,%esi
801034f5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034f9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034fc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034ff:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103503:	0f 85 4f ff ff ff    	jne    80103458 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103509:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	50                   	push   %eax
80103513:	e8 18 0f 00 00       	call   80104430 <wakeup>
  release(&p->lock);
80103518:	89 1c 24             	mov    %ebx,(%esp)
8010351b:	e8 a0 17 00 00       	call   80104cc0 <release>
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
80103540:	e8 bb 16 00 00       	call   80104c00 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103545:	83 c4 10             	add    $0x10,%esp
80103548:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010354e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103554:	75 6a                	jne    801035c0 <piperead+0x90>
80103556:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010355c:	85 db                	test   %ebx,%ebx
8010355e:	0f 84 c4 00 00 00    	je     80103628 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103564:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010356a:	eb 2d                	jmp    80103599 <piperead+0x69>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103570:	83 ec 08             	sub    $0x8,%esp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	e8 c6 09 00 00       	call   80103f40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010357a:	83 c4 10             	add    $0x10,%esp
8010357d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103583:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103589:	75 35                	jne    801035c0 <piperead+0x90>
8010358b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103591:	85 d2                	test   %edx,%edx
80103593:	0f 84 8f 00 00 00    	je     80103628 <piperead+0xf8>
    if(myproc()->killed){
80103599:	e8 62 03 00 00       	call   80103900 <myproc>
8010359e:	8b 48 1c             	mov    0x1c(%eax),%ecx
801035a1:	85 c9                	test   %ecx,%ecx
801035a3:	74 cb                	je     80103570 <piperead+0x40>
      release(&p->lock);
801035a5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035a8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035ad:	56                   	push   %esi
801035ae:	e8 0d 17 00 00       	call   80104cc0 <release>
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
801035d0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035d6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035dc:	74 1f                	je     801035fd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035de:	8d 41 01             	lea    0x1(%ecx),%eax
801035e1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035e7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035ed:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035f2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f5:	83 c3 01             	add    $0x1,%ebx
801035f8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035fb:	75 d3                	jne    801035d0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035fd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103603:	83 ec 0c             	sub    $0xc,%esp
80103606:	50                   	push   %eax
80103607:	e8 24 0e 00 00       	call   80104430 <wakeup>
  release(&p->lock);
8010360c:	89 34 24             	mov    %esi,(%esp)
8010360f:	e8 ac 16 00 00       	call   80104cc0 <release>
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
80103630:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
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
80103641:	68 b5 7d 10 80       	push   $0x80107db5
80103646:	e8 15 d0 ff ff       	call   80100660 <cprintf>
8010364b:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    char *sp;
    acquire(&ptable.lock);
8010364e:	83 ec 0c             	sub    $0xc,%esp
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103651:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
    acquire(&ptable.lock);
80103656:	68 60 3d 11 80       	push   $0x80113d60
8010365b:	e8 a0 15 00 00       	call   80104c00 <acquire>
80103660:	83 c4 10             	add    $0x10,%esp
80103663:	eb 11                	jmp    80103676 <allocproc+0x46>
80103665:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103668:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
8010366e:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
80103674:	73 48                	jae    801036be <allocproc+0x8e>
        if (p->state == UNUSED)
80103676:	8b 73 08             	mov    0x8(%ebx),%esi
80103679:	85 f6                	test   %esi,%esi
8010367b:	75 eb                	jne    80103668 <allocproc+0x38>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
8010367d:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
80103682:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80103685:	8d 73 74             	lea    0x74(%ebx),%esi
    p->state = EMBRYO;
80103688:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    p->pid = nextpid++;
8010368f:	8d 50 01             	lea    0x1(%eax),%edx
        if (t->state == UNUSED)
80103692:	85 c9                	test   %ecx,%ecx
    p->pid = nextpid++;
80103694:	89 43 0c             	mov    %eax,0xc(%ebx)
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80103697:	8d 83 b4 03 00 00    	lea    0x3b4(%ebx),%eax
    p->pid = nextpid++;
8010369d:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
        if (t->state == UNUSED)
801036a3:	75 12                	jne    801036b7 <allocproc+0x87>
801036a5:	eb 39                	jmp    801036e0 <allocproc+0xb0>
801036a7:	89 f6                	mov    %esi,%esi
801036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801036b0:	8b 56 08             	mov    0x8(%esi),%edx
801036b3:	85 d2                	test   %edx,%edx
801036b5:	74 29                	je     801036e0 <allocproc+0xb0>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801036b7:	83 c6 34             	add    $0x34,%esi
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
801036c3:	68 60 3d 11 80       	push   $0x80113d60
801036c8:	e8 f3 15 00 00       	call   80104cc0 <release>
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
801036e0:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    t->state = EMBRYO;
801036e5:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    t->tid = tidCounter++;
801036ec:	8d 50 01             	lea    0x1(%eax),%edx
801036ef:	89 46 0c             	mov    %eax,0xc(%esi)
    p->mainThread = t;
801036f2:	89 b3 b4 03 00 00    	mov    %esi,0x3b4(%ebx)
    t->tid = tidCounter++;
801036f8:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
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
8010371b:	c7 40 14 cf 5f 10 80 	movl   $0x80105fcf,0x14(%eax)
    t->context = (struct context *) sp;
80103722:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
80103725:	6a 14                	push   $0x14
80103727:	6a 00                	push   $0x0
80103729:	50                   	push   %eax
8010372a:	e8 f1 15 00 00       	call   80104d20 <memset>
    t->context->eip = (uint) forkret;
8010372f:	8b 46 14             	mov    0x14(%esi),%eax
80103732:	c7 40 10 70 37 10 80 	movl   $0x80103770,0x10(%eax)
    release(&ptable.lock);
80103739:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103740:	e8 7b 15 00 00       	call   80104cc0 <release>
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
80103776:	68 60 3d 11 80       	push   $0x80113d60
8010377b:	e8 40 15 00 00       	call   80104cc0 <release>

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
801037c6:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
801037cb:	85 c0                	test   %eax,%eax
801037cd:	7e 10                	jle    801037df <pinit+0x1f>
        cprintf(" PINIT ");
801037cf:	83 ec 0c             	sub    $0xc,%esp
801037d2:	68 c1 7d 10 80       	push   $0x80107dc1
801037d7:	e8 84 ce ff ff       	call   80100660 <cprintf>
801037dc:	83 c4 10             	add    $0x10,%esp
    initlock(&ptable.lock, "ptable");
801037df:	83 ec 08             	sub    $0x8,%esp
801037e2:	68 c9 7d 10 80       	push   $0x80107dc9
801037e7:	68 60 3d 11 80       	push   $0x80113d60
801037ec:	e8 cf 12 00 00       	call   80104ac0 <initlock>
}
801037f1:	83 c4 10             	add    $0x10,%esp
801037f4:	c9                   	leave  
801037f5:	c3                   	ret    
801037f6:	8d 76 00             	lea    0x0(%esi),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <cleanThread>:
cleanThread(struct thread *t) {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
80103804:	83 ec 10             	sub    $0x10,%esp
80103807:	8b 5d 08             	mov    0x8(%ebp),%ebx
    kfree(t->tkstack);
8010380a:	ff 73 04             	pushl  0x4(%ebx)
8010380d:	e8 2e eb ff ff       	call   80102340 <kfree>
    memset(t->tf, 0, sizeof(*t->tf));
80103812:	83 c4 0c             	add    $0xc,%esp
    t->tkstack = 0;
80103815:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    t->state = UNUSED;
8010381c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    t->tid = 0;
80103823:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    t->name[0] = 0;
8010382a:	c6 43 20 00          	movb   $0x0,0x20(%ebx)
    t->killed = 0;
8010382e:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    memset(t->tf, 0, sizeof(*t->tf));
80103835:	6a 4c                	push   $0x4c
80103837:	6a 00                	push   $0x0
80103839:	ff 73 10             	pushl  0x10(%ebx)
8010383c:	e8 df 14 00 00       	call   80104d20 <memset>
    memset(t->context, 0, sizeof(*t->context));
80103841:	83 c4 0c             	add    $0xc,%esp
80103844:	6a 14                	push   $0x14
80103846:	6a 00                	push   $0x0
80103848:	ff 73 14             	pushl  0x14(%ebx)
8010384b:	e8 d0 14 00 00       	call   80104d20 <memset>
}
80103850:	83 c4 10             	add    $0x10,%esp
80103853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103856:	c9                   	leave  
80103857:	c3                   	ret    
80103858:	90                   	nop
80103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103860 <mycpu>:
mycpu(void) {
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103865:	9c                   	pushf  
80103866:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103867:	f6 c4 02             	test   $0x2,%ah
8010386a:	75 5e                	jne    801038ca <mycpu+0x6a>
    apicid = lapicid();
8010386c:	e8 ef ee ff ff       	call   80102760 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103871:	8b 35 40 3d 11 80    	mov    0x80113d40,%esi
80103877:	85 f6                	test   %esi,%esi
80103879:	7e 42                	jle    801038bd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010387b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103882:	39 d0                	cmp    %edx,%eax
80103884:	74 30                	je     801038b6 <mycpu+0x56>
80103886:	b9 54 38 11 80       	mov    $0x80113854,%ecx
    for (i = 0; i < ncpu; ++i) {
8010388b:	31 d2                	xor    %edx,%edx
8010388d:	8d 76 00             	lea    0x0(%esi),%esi
80103890:	83 c2 01             	add    $0x1,%edx
80103893:	39 f2                	cmp    %esi,%edx
80103895:	74 26                	je     801038bd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103897:	0f b6 19             	movzbl (%ecx),%ebx
8010389a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
801038a0:	39 c3                	cmp    %eax,%ebx
801038a2:	75 ec                	jne    80103890 <mycpu+0x30>
801038a4:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
801038aa:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
801038af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038b2:	5b                   	pop    %ebx
801038b3:	5e                   	pop    %esi
801038b4:	5d                   	pop    %ebp
801038b5:	c3                   	ret    
        if (cpus[i].apicid == apicid)
801038b6:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
            return &cpus[i];
801038bb:	eb f2                	jmp    801038af <mycpu+0x4f>
    panic("unknown apicid\n");
801038bd:	83 ec 0c             	sub    $0xc,%esp
801038c0:	68 d0 7d 10 80       	push   $0x80107dd0
801038c5:	e8 c6 ca ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	68 18 7f 10 80       	push   $0x80107f18
801038d2:	e8 b9 ca ff ff       	call   80100390 <panic>
801038d7:	89 f6                	mov    %esi,%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038e0 <cpuid>:
cpuid() {
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
801038e6:	e8 75 ff ff ff       	call   80103860 <mycpu>
801038eb:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
801038f0:	c9                   	leave  
    return mycpu() - cpus;
801038f1:	c1 f8 02             	sar    $0x2,%eax
801038f4:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
801038fa:	c3                   	ret    
801038fb:	90                   	nop
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <myproc>:
myproc(void) {
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	53                   	push   %ebx
80103904:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103907:	e8 24 12 00 00       	call   80104b30 <pushcli>
    c = mycpu();
8010390c:	e8 4f ff ff ff       	call   80103860 <mycpu>
    p = c->proc;
80103911:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103917:	e8 54 12 00 00       	call   80104b70 <popcli>
}
8010391c:	83 c4 04             	add    $0x4,%esp
8010391f:	89 d8                	mov    %ebx,%eax
80103921:	5b                   	pop    %ebx
80103922:	5d                   	pop    %ebp
80103923:	c3                   	ret    
80103924:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010392a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103930 <mythread>:
mythread(void) {
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
80103934:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103937:	e8 f4 11 00 00       	call   80104b30 <pushcli>
    c = mycpu();
8010393c:	e8 1f ff ff ff       	call   80103860 <mycpu>
    t = c->currThread;
80103941:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103947:	e8 24 12 00 00       	call   80104b70 <popcli>
}
8010394c:	83 c4 04             	add    $0x4,%esp
8010394f:	89 d8                	mov    %ebx,%eax
80103951:	5b                   	pop    %ebx
80103952:	5d                   	pop    %ebp
80103953:	c3                   	ret    
80103954:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010395a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103960 <userinit>:
userinit(void) {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
80103964:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103967:	e8 c4 fc ff ff       	call   80103630 <allocproc>
8010396c:	89 c3                	mov    %eax,%ebx
    initproc = p;
8010396e:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
    if ((p->pgdir = setupkvm()) == 0)
80103973:	e8 38 3c 00 00       	call   801075b0 <setupkvm>
80103978:	85 c0                	test   %eax,%eax
8010397a:	89 43 04             	mov    %eax,0x4(%ebx)
8010397d:	0f 84 2d 01 00 00    	je     80103ab0 <userinit+0x150>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103983:	83 ec 04             	sub    $0x4,%esp
80103986:	68 2c 00 00 00       	push   $0x2c
8010398b:	68 60 b4 10 80       	push   $0x8010b460
80103990:	50                   	push   %eax
80103991:	e8 fa 38 00 00       	call   80107290 <inituvm>
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
80103996:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103999:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
8010399f:	6a 4c                	push   $0x4c
801039a1:	6a 00                	push   $0x0
801039a3:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039a9:	ff 70 10             	pushl  0x10(%eax)
801039ac:	e8 6f 13 00 00       	call   80104d20 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039b1:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039b7:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039bc:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
801039c1:	83 c4 0c             	add    $0xc,%esp
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039c4:	8b 40 10             	mov    0x10(%eax),%eax
801039c7:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039cb:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039d1:	8b 40 10             	mov    0x10(%eax),%eax
801039d4:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
801039d8:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039de:	8b 40 10             	mov    0x10(%eax),%eax
801039e1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039e5:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
801039e9:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039ef:	8b 40 10             	mov    0x10(%eax),%eax
801039f2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039f6:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
801039fa:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103a00:	8b 40 10             	mov    0x10(%eax),%eax
80103a03:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
80103a0a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103a10:	8b 40 10             	mov    0x10(%eax),%eax
80103a13:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
80103a1a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103a20:	8b 40 10             	mov    0x10(%eax),%eax
80103a23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103a2a:	8d 43 64             	lea    0x64(%ebx),%eax
80103a2d:	6a 10                	push   $0x10
80103a2f:	68 f9 7d 10 80       	push   $0x80107df9
80103a34:	50                   	push   %eax
80103a35:	e8 c6 14 00 00       	call   80104f00 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
80103a3a:	83 c4 0c             	add    $0xc,%esp
80103a3d:	6a 10                	push   $0x10
80103a3f:	68 02 7e 10 80       	push   $0x80107e02
80103a44:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103a4a:	83 c0 20             	add    $0x20,%eax
80103a4d:	50                   	push   %eax
80103a4e:	e8 ad 14 00 00       	call   80104f00 <safestrcpy>
    p->cwd = namei("/");
80103a53:	c7 04 24 0d 7e 10 80 	movl   $0x80107e0d,(%esp)
80103a5a:	e8 b1 e4 ff ff       	call   80101f10 <namei>
80103a5f:	89 43 60             	mov    %eax,0x60(%ebx)
    acquire(&ptable.lock);
80103a62:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103a69:	e8 92 11 00 00       	call   80104c00 <acquire>
    p->mainThread->state = RUNNABLE;
80103a6e:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
    p->state = RUNNABLE;
80103a74:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103a7b:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103a82:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103a89:	e8 32 12 00 00       	call   80104cc0 <release>
    if (DEBUGMODE > 0)
80103a8e:	8b 1d b8 b5 10 80    	mov    0x8010b5b8,%ebx
80103a94:	83 c4 10             	add    $0x10,%esp
80103a97:	85 db                	test   %ebx,%ebx
80103a99:	7e 10                	jle    80103aab <userinit+0x14b>
        cprintf("DONE USERINIT");
80103a9b:	83 ec 0c             	sub    $0xc,%esp
80103a9e:	68 0f 7e 10 80       	push   $0x80107e0f
80103aa3:	e8 b8 cb ff ff       	call   80100660 <cprintf>
80103aa8:	83 c4 10             	add    $0x10,%esp
}
80103aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aae:	c9                   	leave  
80103aaf:	c3                   	ret    
        panic("userinit: out of memory?");
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	68 e0 7d 10 80       	push   $0x80107de0
80103ab8:	e8 d3 c8 ff ff       	call   80100390 <panic>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi

80103ac0 <growproc>:
growproc(int n) {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103ac8:	e8 63 10 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80103acd:	e8 8e fd ff ff       	call   80103860 <mycpu>
    p = c->proc;
80103ad2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ad8:	e8 93 10 00 00       	call   80104b70 <popcli>
    if (DEBUGMODE > 0)
80103add:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	7e 10                	jle    80103af6 <growproc+0x36>
        cprintf(" GROWPROC APPLYED ");
80103ae6:	83 ec 0c             	sub    $0xc,%esp
80103ae9:	68 1d 7e 10 80       	push   $0x80107e1d
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
80103b05:	e8 66 36 00 00       	call   80107170 <switchuvm>
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
80103b2a:	e8 a1 38 00 00       	call   801073d0 <allocuvm>
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
80103b4a:	e8 b1 39 00 00       	call   80107500 <deallocuvm>
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
80103b75:	68 30 7e 10 80       	push   $0x80107e30
80103b7a:	e8 e1 ca ff ff       	call   80100660 <cprintf>
80103b7f:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103b82:	e8 a9 0f 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80103b87:	e8 d4 fc ff ff       	call   80103860 <mycpu>
    p = c->proc;
80103b8c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103b92:	89 55 e0             	mov    %edx,-0x20(%ebp)
    popcli();
80103b95:	e8 d6 0f 00 00       	call   80104b70 <popcli>
    pushcli();
80103b9a:	e8 91 0f 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80103b9f:	e8 bc fc ff ff       	call   80103860 <mycpu>
    t = c->currThread;
80103ba4:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103baa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103bad:	e8 be 0f 00 00       	call   80104b70 <popcli>
    if ((np = allocproc()) == 0) {
80103bb2:	e8 79 fa ff ff       	call   80103630 <allocproc>
80103bb7:	85 c0                	test   %eax,%eax
80103bb9:	89 c3                	mov    %eax,%ebx
80103bbb:	0f 84 f4 00 00 00    	je     80103cb5 <fork+0x155>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103bc1:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103bc4:	83 ec 08             	sub    $0x8,%esp
80103bc7:	ff 32                	pushl  (%edx)
80103bc9:	ff 72 04             	pushl  0x4(%edx)
80103bcc:	e8 af 3a 00 00       	call   80107680 <copyuvm>
80103bd1:	83 c4 10             	add    $0x10,%esp
80103bd4:	85 c0                	test   %eax,%eax
80103bd6:	89 43 04             	mov    %eax,0x4(%ebx)
80103bd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103bdc:	0f 84 da 00 00 00    	je     80103cbc <fork+0x15c>
    np->sz = curproc->sz;
80103be2:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103be4:	89 53 10             	mov    %edx,0x10(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103be7:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103bec:	89 03                	mov    %eax,(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bf1:	8b 70 10             	mov    0x10(%eax),%esi
80103bf4:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103bfa:	8b 40 10             	mov    0x10(%eax),%eax
80103bfd:	89 c7                	mov    %eax,%edi
80103bff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103c01:	31 f6                	xor    %esi,%esi
80103c03:	89 d7                	mov    %edx,%edi
    np->mainThread->tf->eax = 0;
80103c05:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c0b:	8b 40 10             	mov    0x10(%eax),%eax
80103c0e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103c15:	8d 76 00             	lea    0x0(%esi),%esi
        if (curproc->ofile[i])
80103c18:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	74 10                	je     80103c30 <fork+0xd0>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	50                   	push   %eax
80103c24:	e8 e7 d1 ff ff       	call   80100e10 <filedup>
80103c29:	83 c4 10             	add    $0x10,%esp
80103c2c:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103c30:	83 c6 01             	add    $0x1,%esi
80103c33:	83 fe 10             	cmp    $0x10,%esi
80103c36:	75 e0                	jne    80103c18 <fork+0xb8>
    np->cwd = idup(curproc->cwd);
80103c38:	83 ec 0c             	sub    $0xc,%esp
80103c3b:	ff 77 60             	pushl  0x60(%edi)
80103c3e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80103c41:	e8 3a da ff ff       	call   80101680 <idup>
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c46:	8b 55 e0             	mov    -0x20(%ebp),%edx
    np->cwd = idup(curproc->cwd);
80103c49:	89 43 60             	mov    %eax,0x60(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c4c:	8d 43 64             	lea    0x64(%ebx),%eax
80103c4f:	83 c4 0c             	add    $0xc,%esp
80103c52:	6a 10                	push   $0x10
80103c54:	83 c2 64             	add    $0x64,%edx
80103c57:	52                   	push   %edx
80103c58:	50                   	push   %eax
80103c59:	e8 a2 12 00 00       	call   80104f00 <safestrcpy>
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c61:	83 c4 0c             	add    $0xc,%esp
80103c64:	6a 10                	push   $0x10
80103c66:	83 c0 20             	add    $0x20,%eax
80103c69:	50                   	push   %eax
80103c6a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c70:	83 c0 20             	add    $0x20,%eax
80103c73:	50                   	push   %eax
80103c74:	e8 87 12 00 00       	call   80104f00 <safestrcpy>
    pid = np->pid;
80103c79:	8b 73 0c             	mov    0xc(%ebx),%esi
    acquire(&ptable.lock);
80103c7c:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103c83:	e8 78 0f 00 00       	call   80104c00 <acquire>
    np->mainThread->state = RUNNABLE;
80103c88:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
    np->state = RUNNABLE;
80103c8e:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    np->mainThread->state = RUNNABLE;
80103c95:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103c9c:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103ca3:	e8 18 10 00 00       	call   80104cc0 <release>
    return pid;
80103ca8:	83 c4 10             	add    $0x10,%esp
}
80103cab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cae:	89 f0                	mov    %esi,%eax
80103cb0:	5b                   	pop    %ebx
80103cb1:	5e                   	pop    %esi
80103cb2:	5f                   	pop    %edi
80103cb3:	5d                   	pop    %ebp
80103cb4:	c3                   	ret    
        return -1;
80103cb5:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103cba:	eb ef                	jmp    80103cab <fork+0x14b>
        kfree(np->mainThread->tkstack);
80103cbc:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103cc2:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103cc5:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->mainThread->tkstack);
80103cca:	ff 70 04             	pushl  0x4(%eax)
80103ccd:	e8 6e e6 ff ff       	call   80102340 <kfree>
        np->mainThread->tkstack = 0;
80103cd2:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
        return -1;
80103cd8:	83 c4 10             	add    $0x10,%esp
        np->mainThread->tkstack = 0;
80103cdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->mainThread->state = UNUSED;
80103ce2:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
        np->state = UNUSED;
80103ce8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103cef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103cf6:	eb b3                	jmp    80103cab <fork+0x14b>
80103cf8:	90                   	nop
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
80103d15:	68 37 7e 10 80       	push   $0x80107e37
80103d1a:	e8 41 c9 ff ff       	call   80100660 <cprintf>
80103d1f:	83 c4 10             	add    $0x10,%esp
    struct cpu *c = mycpu();
80103d22:	e8 39 fb ff ff       	call   80103860 <mycpu>
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
80103d4e:	e8 ad 0e 00 00       	call   80104c00 <acquire>
80103d53:	83 c4 10             	add    $0x10,%esp
80103d56:	eb 1a                	jmp    80103d72 <scheduler+0x72>
80103d58:	90                   	nop
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d60:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
80103d66:	81 ff 94 2c 12 80    	cmp    $0x80122c94,%edi
80103d6c:	0f 83 8c 00 00 00    	jae    80103dfe <scheduler+0xfe>
            if (p->state != RUNNABLE)
80103d72:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d76:	75 e8                	jne    80103d60 <scheduler+0x60>
            switchuvm(p);
80103d78:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80103d7b:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
80103d81:	8d 5f 74             	lea    0x74(%edi),%ebx
            switchuvm(p);
80103d84:	57                   	push   %edi
80103d85:	e8 e6 33 00 00       	call   80107170 <switchuvm>
80103d8a:	8d 97 b4 03 00 00    	lea    0x3b4(%edi),%edx
80103d90:	83 c4 10             	add    $0x10,%esp
80103d93:	90                   	nop
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if (t->state != RUNNABLE)
80103d98:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103d9c:	75 2e                	jne    80103dcc <scheduler+0xcc>
                t->state = RUNNING;
80103d9e:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)
                swtch(&(c->scheduler), t->context);
80103da5:	83 ec 08             	sub    $0x8,%esp
                c->currThread = t;
80103da8:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)
                swtch(&(c->scheduler), t->context);
80103dae:	ff 73 14             	pushl  0x14(%ebx)
80103db1:	ff 75 e0             	pushl  -0x20(%ebp)
80103db4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103db7:	e8 9f 11 00 00       	call   80104f5b <swtch>
                c->currThread = 0;
80103dbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dbf:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103dc6:	00 00 00 
80103dc9:	83 c4 10             	add    $0x10,%esp
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103dcc:	83 c3 34             	add    $0x34,%ebx
80103dcf:	39 da                	cmp    %ebx,%edx
80103dd1:	77 c5                	ja     80103d98 <scheduler+0x98>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dd3:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
            switchkvm();
80103dd9:	e8 72 33 00 00       	call   80107150 <switchkvm>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dde:	81 ff 94 2c 12 80    	cmp    $0x80122c94,%edi
            c->proc = 0;
80103de4:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103deb:	00 00 00 
            c->currThread = 0;
80103dee:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103df5:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103df8:	0f 82 74 ff ff ff    	jb     80103d72 <scheduler+0x72>
        release(&ptable.lock);
80103dfe:	83 ec 0c             	sub    $0xc,%esp
80103e01:	68 60 3d 11 80       	push   $0x80113d60
80103e06:	e8 b5 0e 00 00       	call   80104cc0 <release>
        sti();
80103e0b:	83 c4 10             	add    $0x10,%esp
80103e0e:	e9 2d ff ff ff       	jmp    80103d40 <scheduler+0x40>
80103e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <sched>:
    if (DEBUGMODE > 1)
80103e20:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
sched(void) {
80103e27:	55                   	push   %ebp
80103e28:	89 e5                	mov    %esp,%ebp
80103e2a:	56                   	push   %esi
80103e2b:	53                   	push   %ebx
    if (DEBUGMODE > 1)
80103e2c:	7e 10                	jle    80103e3e <sched+0x1e>
        cprintf(" SCHED ");
80103e2e:	83 ec 0c             	sub    $0xc,%esp
80103e31:	68 43 7e 10 80       	push   $0x80107e43
80103e36:	e8 25 c8 ff ff       	call   80100660 <cprintf>
80103e3b:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103e3e:	e8 ed 0c 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80103e43:	e8 18 fa ff ff       	call   80103860 <mycpu>
    t = c->currThread;
80103e48:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103e4e:	e8 1d 0d 00 00       	call   80104b70 <popcli>
    if (!holding(&ptable.lock))
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	68 60 3d 11 80       	push   $0x80113d60
80103e5b:	e8 70 0d 00 00       	call   80104bd0 <holding>
80103e60:	83 c4 10             	add    $0x10,%esp
80103e63:	85 c0                	test   %eax,%eax
80103e65:	74 4f                	je     80103eb6 <sched+0x96>
    if (mycpu()->ncli != 1)
80103e67:	e8 f4 f9 ff ff       	call   80103860 <mycpu>
80103e6c:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e73:	75 68                	jne    80103edd <sched+0xbd>
    if (t->state == RUNNING)
80103e75:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103e79:	74 55                	je     80103ed0 <sched+0xb0>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e7b:	9c                   	pushf  
80103e7c:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103e7d:	f6 c4 02             	test   $0x2,%ah
80103e80:	75 41                	jne    80103ec3 <sched+0xa3>
    intena = mycpu()->intena;
80103e82:	e8 d9 f9 ff ff       	call   80103860 <mycpu>
    swtch(&t->context, mycpu()->scheduler);
80103e87:	83 c3 14             	add    $0x14,%ebx
    intena = mycpu()->intena;
80103e8a:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&t->context, mycpu()->scheduler);
80103e90:	e8 cb f9 ff ff       	call   80103860 <mycpu>
80103e95:	83 ec 08             	sub    $0x8,%esp
80103e98:	ff 70 04             	pushl  0x4(%eax)
80103e9b:	53                   	push   %ebx
80103e9c:	e8 ba 10 00 00       	call   80104f5b <swtch>
    mycpu()->intena = intena;
80103ea1:	e8 ba f9 ff ff       	call   80103860 <mycpu>
}
80103ea6:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80103ea9:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103eaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103eb2:	5b                   	pop    %ebx
80103eb3:	5e                   	pop    %esi
80103eb4:	5d                   	pop    %ebp
80103eb5:	c3                   	ret    
        panic("sched ptable.lock");
80103eb6:	83 ec 0c             	sub    $0xc,%esp
80103eb9:	68 4b 7e 10 80       	push   $0x80107e4b
80103ebe:	e8 cd c4 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
80103ec3:	83 ec 0c             	sub    $0xc,%esp
80103ec6:	68 77 7e 10 80       	push   $0x80107e77
80103ecb:	e8 c0 c4 ff ff       	call   80100390 <panic>
        panic("sched running");
80103ed0:	83 ec 0c             	sub    $0xc,%esp
80103ed3:	68 69 7e 10 80       	push   $0x80107e69
80103ed8:	e8 b3 c4 ff ff       	call   80100390 <panic>
        panic("sched locks");
80103edd:	83 ec 0c             	sub    $0xc,%esp
80103ee0:	68 5d 7e 10 80       	push   $0x80107e5d
80103ee5:	e8 a6 c4 ff ff       	call   80100390 <panic>
80103eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ef0 <yield>:
yield(void) {
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	53                   	push   %ebx
80103ef4:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103ef7:	68 60 3d 11 80       	push   $0x80113d60
80103efc:	e8 ff 0c 00 00       	call   80104c00 <acquire>
    pushcli();
80103f01:	e8 2a 0c 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80103f06:	e8 55 f9 ff ff       	call   80103860 <mycpu>
    t = c->currThread;
80103f0b:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103f11:	e8 5a 0c 00 00       	call   80104b70 <popcli>
    mythread()->state = RUNNABLE;
80103f16:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103f1d:	e8 fe fe ff ff       	call   80103e20 <sched>
    release(&ptable.lock);
80103f22:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103f29:	e8 92 0d 00 00       	call   80104cc0 <release>
}
80103f2e:	83 c4 10             	add    $0x10,%esp
80103f31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f34:	c9                   	leave  
80103f35:	c3                   	ret    
80103f36:	8d 76 00             	lea    0x0(%esi),%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f40 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	57                   	push   %edi
80103f44:	56                   	push   %esi
80103f45:	53                   	push   %ebx
80103f46:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80103f49:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
sleep(void *chan, struct spinlock *lk) {
80103f50:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f53:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (DEBUGMODE > 1)
80103f56:	7e 10                	jle    80103f68 <sleep+0x28>
        cprintf(" SLEEP ");
80103f58:	83 ec 0c             	sub    $0xc,%esp
80103f5b:	68 8b 7e 10 80       	push   $0x80107e8b
80103f60:	e8 fb c6 ff ff       	call   80100660 <cprintf>
80103f65:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103f68:	e8 c3 0b 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80103f6d:	e8 ee f8 ff ff       	call   80103860 <mycpu>
    p = c->proc;
80103f72:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103f78:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103f7b:	e8 f0 0b 00 00       	call   80104b70 <popcli>
    pushcli();
80103f80:	e8 ab 0b 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80103f85:	e8 d6 f8 ff ff       	call   80103860 <mycpu>
    t = c->currThread;
80103f8a:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103f90:	e8 db 0b 00 00       	call   80104b70 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103f95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f98:	85 d2                	test   %edx,%edx
80103f9a:	0f 84 83 00 00 00    	je     80104023 <sleep+0xe3>
        panic("sleep");

    if (lk == 0)
80103fa0:	85 db                	test   %ebx,%ebx
80103fa2:	74 72                	je     80104016 <sleep+0xd6>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {
80103fa4:	81 fb 60 3d 11 80    	cmp    $0x80113d60,%ebx
80103faa:	74 4c                	je     80103ff8 <sleep+0xb8>
        acquire(&ptable.lock);
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	68 60 3d 11 80       	push   $0x80113d60
80103fb4:	e8 47 0c 00 00       	call   80104c00 <acquire>
        release(lk);
80103fb9:	89 1c 24             	mov    %ebx,(%esp)
80103fbc:	e8 ff 0c 00 00       	call   80104cc0 <release>
    }
    // Go to sleep.
    t->chan = chan;
80103fc1:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103fc4:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103fcb:	e8 50 fe ff ff       	call   80103e20 <sched>

    // Tidy up.
    t->chan = 0;
80103fd0:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80103fd7:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103fde:	e8 dd 0c 00 00       	call   80104cc0 <release>
        acquire(lk);
80103fe3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103fe6:	83 c4 10             	add    $0x10,%esp
    }
}
80103fe9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fec:	5b                   	pop    %ebx
80103fed:	5e                   	pop    %esi
80103fee:	5f                   	pop    %edi
80103fef:	5d                   	pop    %ebp
        acquire(lk);
80103ff0:	e9 0b 0c 00 00       	jmp    80104c00 <acquire>
80103ff5:	8d 76 00             	lea    0x0(%esi),%esi
    t->chan = chan;
80103ff8:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103ffb:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)
    sched();
80104002:	e8 19 fe ff ff       	call   80103e20 <sched>
    t->chan = 0;
80104007:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
}
8010400e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104011:	5b                   	pop    %ebx
80104012:	5e                   	pop    %esi
80104013:	5f                   	pop    %edi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret    
        panic("sleep without lk");
80104016:	83 ec 0c             	sub    $0xc,%esp
80104019:	68 99 7e 10 80       	push   $0x80107e99
8010401e:	e8 6d c3 ff ff       	call   80100390 <panic>
        panic("sleep");
80104023:	83 ec 0c             	sub    $0xc,%esp
80104026:	68 93 7e 10 80       	push   $0x80107e93
8010402b:	e8 60 c3 ff ff       	call   80100390 <panic>

80104030 <cleanProcOneThread>:
cleanProcOneThread(struct thread *curthread, struct proc *p) {
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	57                   	push   %edi
80104034:	56                   	push   %esi
80104035:	53                   	push   %ebx
80104036:	83 ec 18             	sub    $0x18,%esp
80104039:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010403c:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&ptable.lock);
8010403f:	68 60 3d 11 80       	push   $0x80113d60
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104044:	8d 5f 74             	lea    0x74(%edi),%ebx
80104047:	81 c7 b4 03 00 00    	add    $0x3b4,%edi
    acquire(&ptable.lock);
8010404d:	e8 ae 0b 00 00       	call   80104c00 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104052:	83 c4 10             	add    $0x10,%esp
80104055:	eb 10                	jmp    80104067 <cleanProcOneThread+0x37>
80104057:	89 f6                	mov    %esi,%esi
80104059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104060:	83 c3 34             	add    $0x34,%ebx
80104063:	39 fb                	cmp    %edi,%ebx
80104065:	73 27                	jae    8010408e <cleanProcOneThread+0x5e>
        if (t != curthread) {
80104067:	39 de                	cmp    %ebx,%esi
80104069:	74 f5                	je     80104060 <cleanProcOneThread+0x30>
            if (t->state == RUNNING)
8010406b:	8b 43 08             	mov    0x8(%ebx),%eax
8010406e:	83 f8 04             	cmp    $0x4,%eax
80104071:	74 35                	je     801040a8 <cleanProcOneThread+0x78>
            if (t->state == RUNNING || t->state == RUNNABLE) {
80104073:	83 e8 03             	sub    $0x3,%eax
80104076:	83 f8 01             	cmp    $0x1,%eax
80104079:	77 e5                	ja     80104060 <cleanProcOneThread+0x30>
                cleanThread(t);
8010407b:	83 ec 0c             	sub    $0xc,%esp
8010407e:	53                   	push   %ebx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010407f:	83 c3 34             	add    $0x34,%ebx
                cleanThread(t);
80104082:	e8 79 f7 ff ff       	call   80103800 <cleanThread>
80104087:	83 c4 10             	add    $0x10,%esp
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010408a:	39 fb                	cmp    %edi,%ebx
8010408c:	72 d9                	jb     80104067 <cleanProcOneThread+0x37>
    release(&ptable.lock);
8010408e:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
80104095:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104098:	5b                   	pop    %ebx
80104099:	5e                   	pop    %esi
8010409a:	5f                   	pop    %edi
8010409b:	5d                   	pop    %ebp
    release(&ptable.lock);
8010409c:	e9 1f 0c 00 00       	jmp    80104cc0 <release>
801040a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                sleep(t, &ptable.lock);
801040a8:	83 ec 08             	sub    $0x8,%esp
801040ab:	68 60 3d 11 80       	push   $0x80113d60
801040b0:	53                   	push   %ebx
801040b1:	e8 8a fe ff ff       	call   80103f40 <sleep>
801040b6:	8b 43 08             	mov    0x8(%ebx),%eax
801040b9:	83 c4 10             	add    $0x10,%esp
801040bc:	eb b5                	jmp    80104073 <cleanProcOneThread+0x43>
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
801040c9:	e8 62 0a 00 00       	call   80104b30 <pushcli>
    c = mycpu();
801040ce:	e8 8d f7 ff ff       	call   80103860 <mycpu>
    p = c->proc;
801040d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801040d9:	e8 92 0a 00 00       	call   80104b70 <popcli>
    pushcli();
801040de:	e8 4d 0a 00 00       	call   80104b30 <pushcli>
    c = mycpu();
801040e3:	e8 78 f7 ff ff       	call   80103860 <mycpu>
    t = c->currThread;
801040e8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801040ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
801040f1:	e8 7a 0a 00 00       	call   80104b70 <popcli>
    if (DEBUGMODE > 0)
801040f6:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
801040fb:	85 c0                	test   %eax,%eax
801040fd:	7e 10                	jle    8010410f <exit+0x4f>
        cprintf("EXIT");
801040ff:	83 ec 0c             	sub    $0xc,%esp
80104102:	68 aa 7e 10 80       	push   $0x80107eaa
80104107:	e8 54 c5 ff ff       	call   80100660 <cprintf>
8010410c:	83 c4 10             	add    $0x10,%esp
    if (curproc == initproc)
8010410f:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
80104115:	0f 84 98 01 00 00    	je     801042b3 <exit+0x1f3>
    cleanProcOneThread(curthread, curproc);
8010411b:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010411e:	83 ec 08             	sub    $0x8,%esp
80104121:	8d 5e 60             	lea    0x60(%esi),%ebx
80104124:	56                   	push   %esi
80104125:	57                   	push   %edi
80104126:	e8 05 ff ff ff       	call   80104030 <cleanProcOneThread>
    acquire(&ptable.lock);
8010412b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80104132:	e8 c9 0a 00 00       	call   80104c00 <acquire>
    curproc->mainThread = curthread;
80104137:	89 be b4 03 00 00    	mov    %edi,0x3b4(%esi)
8010413d:	8d 7e 20             	lea    0x20(%esi),%edi
80104140:	83 c4 10             	add    $0x10,%esp
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[fd]) {
80104148:	8b 07                	mov    (%edi),%eax
8010414a:	85 c0                	test   %eax,%eax
8010414c:	74 12                	je     80104160 <exit+0xa0>
            fileclose(curproc->ofile[fd]);
8010414e:	83 ec 0c             	sub    $0xc,%esp
80104151:	50                   	push   %eax
80104152:	e8 09 cd ff ff       	call   80100e60 <fileclose>
            curproc->ofile[fd] = 0;
80104157:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010415d:	83 c4 10             	add    $0x10,%esp
80104160:	83 c7 04             	add    $0x4,%edi
    for (fd = 0; fd < NOFILE; fd++) {
80104163:	39 df                	cmp    %ebx,%edi
80104165:	75 e1                	jne    80104148 <exit+0x88>
    if (holding(&ptable.lock))
80104167:	83 ec 0c             	sub    $0xc,%esp
8010416a:	68 60 3d 11 80       	push   $0x80113d60
8010416f:	e8 5c 0a 00 00       	call   80104bd0 <holding>
80104174:	83 c4 10             	add    $0x10,%esp
80104177:	85 c0                	test   %eax,%eax
80104179:	0f 85 1f 01 00 00    	jne    8010429e <exit+0x1de>
    begin_op();
8010417f:	e8 4c ea ff ff       	call   80102bd0 <begin_op>
    iput(curproc->cwd);
80104184:	83 ec 0c             	sub    $0xc,%esp
80104187:	ff 76 60             	pushl  0x60(%esi)
8010418a:	e8 51 d6 ff ff       	call   801017e0 <iput>
    end_op();
8010418f:	e8 ac ea ff ff       	call   80102c40 <end_op>
    curproc->cwd = 0;
80104194:	c7 46 60 00 00 00 00 	movl   $0x0,0x60(%esi)
    acquire(&ptable.lock);
8010419b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801041a2:	e8 59 0a 00 00       	call   80104c00 <acquire>
    wakeup1(curproc->parent->mainThread);
801041a7:	8b 46 10             	mov    0x10(%esi),%eax
801041aa:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041ad:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
    wakeup1(curproc->parent->mainThread);
801041b2:	8b 98 b4 03 00 00    	mov    0x3b4(%eax),%ebx
801041b8:	eb 14                	jmp    801041ce <exit+0x10e>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041c0:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
801041c6:	81 fa 94 2c 12 80    	cmp    $0x80122c94,%edx
801041cc:	73 2d                	jae    801041fb <exit+0x13b>
        if (p->state != RUNNABLE)
801041ce:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801041d2:	75 ec                	jne    801041c0 <exit+0x100>
801041d4:	8d 42 74             	lea    0x74(%edx),%eax
801041d7:	8d 8a b4 03 00 00    	lea    0x3b4(%edx),%ecx
801041dd:	eb 08                	jmp    801041e7 <exit+0x127>
801041df:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801041e0:	83 c0 34             	add    $0x34,%eax
801041e3:	39 c8                	cmp    %ecx,%eax
801041e5:	73 d9                	jae    801041c0 <exit+0x100>
            if (t->state == SLEEPING && t->chan == chan)
801041e7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801041eb:	75 f3                	jne    801041e0 <exit+0x120>
801041ed:	3b 58 18             	cmp    0x18(%eax),%ebx
801041f0:	75 ee                	jne    801041e0 <exit+0x120>
                t->state = RUNNABLE;
801041f2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801041f9:	eb e5                	jmp    801041e0 <exit+0x120>
            p->parent = initproc;
801041fb:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104200:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
            p->parent = initproc;
80104205:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104208:	eb 14                	jmp    8010421e <exit+0x15e>
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104210:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
80104216:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
8010421c:	73 5d                	jae    8010427b <exit+0x1bb>
        if (p->parent == curproc) {
8010421e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104221:	75 ed                	jne    80104210 <exit+0x150>
            if (p->state == ZOMBIE)
80104223:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
            p->parent = initproc;
80104227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010422a:	89 43 10             	mov    %eax,0x10(%ebx)
            if (p->state == ZOMBIE)
8010422d:	75 e1                	jne    80104210 <exit+0x150>
                wakeup1(initproc->mainThread);
8010422f:	8b b8 b4 03 00 00    	mov    0x3b4(%eax),%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104235:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
8010423a:	eb 12                	jmp    8010424e <exit+0x18e>
8010423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104240:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
80104246:	81 fa 94 2c 12 80    	cmp    $0x80122c94,%edx
8010424c:	73 c2                	jae    80104210 <exit+0x150>
        if (p->state != RUNNABLE)
8010424e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104252:	75 ec                	jne    80104240 <exit+0x180>
80104254:	8d 42 74             	lea    0x74(%edx),%eax
80104257:	8d 8a b4 03 00 00    	lea    0x3b4(%edx),%ecx
8010425d:	eb 08                	jmp    80104267 <exit+0x1a7>
8010425f:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104260:	83 c0 34             	add    $0x34,%eax
80104263:	39 c1                	cmp    %eax,%ecx
80104265:	76 d9                	jbe    80104240 <exit+0x180>
            if (t->state == SLEEPING && t->chan == chan)
80104267:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010426b:	75 f3                	jne    80104260 <exit+0x1a0>
8010426d:	3b 78 18             	cmp    0x18(%eax),%edi
80104270:	75 ee                	jne    80104260 <exit+0x1a0>
                t->state = RUNNABLE;
80104272:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104279:	eb e5                	jmp    80104260 <exit+0x1a0>
    curthread->state = ZOMBIE;
8010427b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010427e:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    curproc->state = ZOMBIE;
80104285:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
8010428c:	e8 8f fb ff ff       	call   80103e20 <sched>
    panic("zombie exit");
80104291:	83 ec 0c             	sub    $0xc,%esp
80104294:	68 bc 7e 10 80       	push   $0x80107ebc
80104299:	e8 f2 c0 ff ff       	call   80100390 <panic>
        release(&ptable.lock);
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	68 60 3d 11 80       	push   $0x80113d60
801042a6:	e8 15 0a 00 00       	call   80104cc0 <release>
801042ab:	83 c4 10             	add    $0x10,%esp
801042ae:	e9 cc fe ff ff       	jmp    8010417f <exit+0xbf>
        panic("init exiting");
801042b3:	83 ec 0c             	sub    $0xc,%esp
801042b6:	68 af 7e 10 80       	push   $0x80107eaf
801042bb:	e8 d0 c0 ff ff       	call   80100390 <panic>

801042c0 <wait>:
wait(void) {
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	57                   	push   %edi
801042c4:	56                   	push   %esi
801042c5:	53                   	push   %ebx
801042c6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
801042c9:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
801042d0:	7e 10                	jle    801042e2 <wait+0x22>
        cprintf(" WAIT ");
801042d2:	83 ec 0c             	sub    $0xc,%esp
801042d5:	68 c8 7e 10 80       	push   $0x80107ec8
801042da:	e8 81 c3 ff ff       	call   80100660 <cprintf>
801042df:	83 c4 10             	add    $0x10,%esp
    pushcli();
801042e2:	e8 49 08 00 00       	call   80104b30 <pushcli>
    c = mycpu();
801042e7:	e8 74 f5 ff ff       	call   80103860 <mycpu>
    p = c->proc;
801042ec:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801042f2:	e8 79 08 00 00       	call   80104b70 <popcli>
    acquire(&ptable.lock);
801042f7:	83 ec 0c             	sub    $0xc,%esp
801042fa:	68 60 3d 11 80       	push   $0x80113d60
801042ff:	e8 fc 08 00 00       	call   80104c00 <acquire>
80104304:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
80104307:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104309:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
8010430e:	eb 0e                	jmp    8010431e <wait+0x5e>
80104310:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
80104316:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
8010431c:	73 1e                	jae    8010433c <wait+0x7c>
            if (p->parent != curproc)
8010431e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104321:	75 ed                	jne    80104310 <wait+0x50>
            if (p->state == ZOMBIE) {
80104323:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80104327:	74 67                	je     80104390 <wait+0xd0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104329:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
            havekids = 1;
8010432f:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104334:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
8010433a:	72 e2                	jb     8010431e <wait+0x5e>
        if (!havekids || myproc()->killed) {
8010433c:	85 c0                	test   %eax,%eax
8010433e:	0f 84 ca 00 00 00    	je     8010440e <wait+0x14e>
    pushcli();
80104344:	e8 e7 07 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80104349:	e8 12 f5 ff ff       	call   80103860 <mycpu>
    p = c->proc;
8010434e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104354:	e8 17 08 00 00       	call   80104b70 <popcli>
        if (!havekids || myproc()->killed) {
80104359:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010435c:	85 c0                	test   %eax,%eax
8010435e:	0f 85 aa 00 00 00    	jne    8010440e <wait+0x14e>
    pushcli();
80104364:	e8 c7 07 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80104369:	e8 f2 f4 ff ff       	call   80103860 <mycpu>
    t = c->currThread;
8010436e:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104374:	e8 f7 07 00 00       	call   80104b70 <popcli>
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
80104379:	83 ec 08             	sub    $0x8,%esp
8010437c:	68 60 3d 11 80       	push   $0x80113d60
80104381:	53                   	push   %ebx
80104382:	e8 b9 fb ff ff       	call   80103f40 <sleep>
        havekids = 0;
80104387:	83 c4 10             	add    $0x10,%esp
8010438a:	e9 78 ff ff ff       	jmp    80104307 <wait+0x47>
8010438f:	90                   	nop
                pid = p->pid;
80104390:	8b 43 0c             	mov    0xc(%ebx),%eax
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104393:	8d 73 74             	lea    0x74(%ebx),%esi
80104396:	8d bb b4 03 00 00    	lea    0x3b4(%ebx),%edi
                pid = p->pid;
8010439c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010439f:	eb 0e                	jmp    801043af <wait+0xef>
801043a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043a8:	83 c6 34             	add    $0x34,%esi
801043ab:	39 f7                	cmp    %esi,%edi
801043ad:	76 1a                	jbe    801043c9 <wait+0x109>
                    if (t->state != UNUSED)
801043af:	8b 56 08             	mov    0x8(%esi),%edx
801043b2:	85 d2                	test   %edx,%edx
801043b4:	74 f2                	je     801043a8 <wait+0xe8>
                        cleanThread(t);
801043b6:	83 ec 0c             	sub    $0xc,%esp
801043b9:	56                   	push   %esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043ba:	83 c6 34             	add    $0x34,%esi
                        cleanThread(t);
801043bd:	e8 3e f4 ff ff       	call   80103800 <cleanThread>
801043c2:	83 c4 10             	add    $0x10,%esp
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043c5:	39 f7                	cmp    %esi,%edi
801043c7:	77 e6                	ja     801043af <wait+0xef>
                freevm(p->pgdir);
801043c9:	83 ec 0c             	sub    $0xc,%esp
801043cc:	ff 73 04             	pushl  0x4(%ebx)
801043cf:	e8 5c 31 00 00       	call   80107530 <freevm>
                p->pid = 0;
801043d4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
801043db:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
801043e2:	c6 43 64 00          	movb   $0x0,0x64(%ebx)
                p->killed = 0;
801043e6:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
801043ed:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
801043f4:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801043fb:	e8 c0 08 00 00       	call   80104cc0 <release>
                return pid;
80104400:	83 c4 10             	add    $0x10,%esp
}
80104403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104409:	5b                   	pop    %ebx
8010440a:	5e                   	pop    %esi
8010440b:	5f                   	pop    %edi
8010440c:	5d                   	pop    %ebp
8010440d:	c3                   	ret    
            release(&ptable.lock);
8010440e:	83 ec 0c             	sub    $0xc,%esp
80104411:	68 60 3d 11 80       	push   $0x80113d60
80104416:	e8 a5 08 00 00       	call   80104cc0 <release>
            return -1;
8010441b:	83 c4 10             	add    $0x10,%esp
8010441e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104425:	eb dc                	jmp    80104403 <wait+0x143>
80104427:	89 f6                	mov    %esi,%esi
80104429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104430 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 1)
80104437:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
wakeup(void *chan) {
8010443e:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 1)
80104441:	7e 10                	jle    80104453 <wakeup+0x23>
        cprintf(" WAKEUP ");
80104443:	83 ec 0c             	sub    $0xc,%esp
80104446:	68 cf 7e 10 80       	push   $0x80107ecf
8010444b:	e8 10 c2 ff ff       	call   80100660 <cprintf>
80104450:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 60 3d 11 80       	push   $0x80113d60
8010445b:	e8 a0 07 00 00       	call   80104c00 <acquire>
80104460:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104463:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
80104468:	eb 14                	jmp    8010447e <wakeup+0x4e>
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104470:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
80104476:	81 fa 94 2c 12 80    	cmp    $0x80122c94,%edx
8010447c:	73 2d                	jae    801044ab <wakeup+0x7b>
        if (p->state != RUNNABLE)
8010447e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104482:	75 ec                	jne    80104470 <wakeup+0x40>
80104484:	8d 42 74             	lea    0x74(%edx),%eax
80104487:	8d 8a b4 03 00 00    	lea    0x3b4(%edx),%ecx
8010448d:	eb 08                	jmp    80104497 <wakeup+0x67>
8010448f:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104490:	83 c0 34             	add    $0x34,%eax
80104493:	39 c1                	cmp    %eax,%ecx
80104495:	76 d9                	jbe    80104470 <wakeup+0x40>
            if (t->state == SLEEPING && t->chan == chan)
80104497:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010449b:	75 f3                	jne    80104490 <wakeup+0x60>
8010449d:	3b 58 18             	cmp    0x18(%eax),%ebx
801044a0:	75 ee                	jne    80104490 <wakeup+0x60>
                t->state = RUNNABLE;
801044a2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801044a9:	eb e5                	jmp    80104490 <wakeup+0x60>
    wakeup1(chan);
    release(&ptable.lock);
801044ab:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
801044b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b5:	c9                   	leave  
    release(&ptable.lock);
801044b6:	e9 05 08 00 00       	jmp    80104cc0 <release>
801044bb:	90                   	nop
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 0)
801044c7:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
kill(int pid) {
801044cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 0)
801044cf:	85 c0                	test   %eax,%eax
801044d1:	7e 10                	jle    801044e3 <kill+0x23>
        cprintf(" KILL ");
801044d3:	83 ec 0c             	sub    $0xc,%esp
801044d6:	68 d8 7e 10 80       	push   $0x80107ed8
801044db:	e8 80 c1 ff ff       	call   80100660 <cprintf>
801044e0:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    acquire(&ptable.lock);
801044e3:	83 ec 0c             	sub    $0xc,%esp
801044e6:	68 60 3d 11 80       	push   $0x80113d60
801044eb:	e8 10 07 00 00       	call   80104c00 <acquire>
801044f0:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044f3:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
801044f8:	eb 12                	jmp    8010450c <kill+0x4c>
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104500:	05 bc 03 00 00       	add    $0x3bc,%eax
80104505:	3d 94 2c 12 80       	cmp    $0x80122c94,%eax
8010450a:	73 5c                	jae    80104568 <kill+0xa8>
        if (p->pid == pid) {
8010450c:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010450f:	75 ef                	jne    80104500 <kill+0x40>
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104511:	8d 50 74             	lea    0x74(%eax),%edx
80104514:	8d 88 b4 03 00 00    	lea    0x3b4(%eax),%ecx
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                t->killed = 1;
80104520:	c7 42 1c 01 00 00 00 	movl   $0x1,0x1c(%edx)
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104527:	83 c2 34             	add    $0x34,%edx
8010452a:	39 d1                	cmp    %edx,%ecx
8010452c:	77 f2                	ja     80104520 <kill+0x60>
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
8010452e:	8b 90 b4 03 00 00    	mov    0x3b4(%eax),%edx
80104534:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
80104538:	75 14                	jne    8010454e <kill+0x8e>
                p->mainThread->state = RUNNABLE;
8010453a:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
80104541:	8b 80 b4 03 00 00    	mov    0x3b4(%eax),%eax
80104547:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
            }

            //release( p->procLock );
            release(&ptable.lock);
8010454e:	83 ec 0c             	sub    $0xc,%esp
80104551:	68 60 3d 11 80       	push   $0x80113d60
80104556:	e8 65 07 00 00       	call   80104cc0 <release>
            return 0;
8010455b:	83 c4 10             	add    $0x10,%esp
8010455e:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104563:	c9                   	leave  
80104564:	c3                   	ret    
80104565:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	68 60 3d 11 80       	push   $0x80113d60
80104570:	e8 4b 07 00 00       	call   80104cc0 <release>
    return -1;
80104575:	83 c4 10             	add    $0x10,%esp
80104578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010457d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104580:	c9                   	leave  
80104581:	c3                   	ret    
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
80104595:	53                   	push   %ebx
80104596:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104599:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
procdump(void) {
8010459e:	83 ec 3c             	sub    $0x3c,%esp
801045a1:	eb 27                	jmp    801045ca <procdump+0x3a>
801045a3:	90                   	nop
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	68 87 82 10 80       	push   $0x80108287
801045b0:	e8 ab c0 ff ff       	call   80100660 <cprintf>
801045b5:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045b8:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
801045be:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
801045c4:	0f 83 96 00 00 00    	jae    80104660 <procdump+0xd0>
        if (p->state == UNUSED)
801045ca:	8b 43 08             	mov    0x8(%ebx),%eax
801045cd:	85 c0                	test   %eax,%eax
801045cf:	74 e7                	je     801045b8 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045d1:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
801045d4:	ba df 7e 10 80       	mov    $0x80107edf,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045d9:	77 11                	ja     801045ec <procdump+0x5c>
801045db:	8b 14 85 40 7f 10 80 	mov    -0x7fef80c0(,%eax,4),%edx
            state = "???";
801045e2:	b8 df 7e 10 80       	mov    $0x80107edf,%eax
801045e7:	85 d2                	test   %edx,%edx
801045e9:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
801045ec:	8d 43 64             	lea    0x64(%ebx),%eax
801045ef:	50                   	push   %eax
801045f0:	52                   	push   %edx
801045f1:	ff 73 0c             	pushl  0xc(%ebx)
801045f4:	68 e3 7e 10 80       	push   $0x80107ee3
801045f9:	e8 62 c0 ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
801045fe:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80104604:	83 c4 10             	add    $0x10,%esp
80104607:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010460b:	75 9b                	jne    801045a8 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
8010460d:	8d 4d c0             	lea    -0x40(%ebp),%ecx
80104610:	83 ec 08             	sub    $0x8,%esp
80104613:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104616:	51                   	push   %ecx
80104617:	8b 40 14             	mov    0x14(%eax),%eax
8010461a:	8b 40 0c             	mov    0xc(%eax),%eax
8010461d:	83 c0 08             	add    $0x8,%eax
80104620:	50                   	push   %eax
80104621:	e8 ba 04 00 00       	call   80104ae0 <getcallerpcs>
80104626:	83 c4 10             	add    $0x10,%esp
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104630:	8b 17                	mov    (%edi),%edx
80104632:	85 d2                	test   %edx,%edx
80104634:	0f 84 6e ff ff ff    	je     801045a8 <procdump+0x18>
                cprintf(" %p", pc[i]);
8010463a:	83 ec 08             	sub    $0x8,%esp
8010463d:	83 c7 04             	add    $0x4,%edi
80104640:	52                   	push   %edx
80104641:	68 a1 78 10 80       	push   $0x801078a1
80104646:	e8 15 c0 ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
8010464b:	83 c4 10             	add    $0x10,%esp
8010464e:	39 fe                	cmp    %edi,%esi
80104650:	75 de                	jne    80104630 <procdump+0xa0>
80104652:	e9 51 ff ff ff       	jmp    801045a8 <procdump+0x18>
80104657:	89 f6                	mov    %esi,%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
}
80104660:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104663:	5b                   	pop    %ebx
80104664:	5e                   	pop    %esi
80104665:	5f                   	pop    %edi
80104666:	5d                   	pop    %ebp
80104667:	c3                   	ret    
80104668:	90                   	nop
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <kthread_create>:

//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
    pushcli();
80104675:	e8 b6 04 00 00       	call   80104b30 <pushcli>
    c = mycpu();
8010467a:	e8 e1 f1 ff ff       	call   80103860 <mycpu>
    p = c->proc;
8010467f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104685:	e8 e6 04 00 00       	call   80104b70 <popcli>
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    acquire(&ptable.lock);
8010468a:	83 ec 0c             	sub    $0xc,%esp
8010468d:	68 60 3d 11 80       	push   $0x80113d60
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104692:	8d 5e 74             	lea    0x74(%esi),%ebx
    acquire(&ptable.lock);
80104695:	e8 66 05 00 00       	call   80104c00 <acquire>
        if (t->state == UNUSED)
8010469a:	8b 46 7c             	mov    0x7c(%esi),%eax
8010469d:	83 c4 10             	add    $0x10,%esp
801046a0:	85 c0                	test   %eax,%eax
801046a2:	74 3c                	je     801046e0 <kthread_create+0x70>
801046a4:	8d 86 b4 03 00 00    	lea    0x3b4(%esi),%eax
801046aa:	eb 0b                	jmp    801046b7 <kthread_create+0x47>
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b0:	8b 73 08             	mov    0x8(%ebx),%esi
801046b3:	85 f6                	test   %esi,%esi
801046b5:	74 29                	je     801046e0 <kthread_create+0x70>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801046b7:	83 c3 34             	add    $0x34,%ebx
801046ba:	39 c3                	cmp    %eax,%ebx
801046bc:	72 f2                	jb     801046b0 <kthread_create+0x40>
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
801046be:	83 ec 0c             	sub    $0xc,%esp
801046c1:	68 60 3d 11 80       	push   $0x80113d60
801046c6:	e8 f5 05 00 00       	call   80104cc0 <release>
        return -1;
801046cb:	83 c4 10             	add    $0x10,%esp
    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
801046ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
801046d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046d6:	5b                   	pop    %ebx
801046d7:	5e                   	pop    %esi
801046d8:	5d                   	pop    %ebp
801046d9:	c3                   	ret    
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    t->tid = tidCounter++;
801046e0:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    t->state = EMBRYO;
801046e5:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    t->tid = tidCounter++;
801046ec:	8d 50 01             	lea    0x1(%eax),%edx
801046ef:	89 43 0c             	mov    %eax,0xc(%ebx)
801046f2:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    if ((t->tkstack = kalloc()) == 0) {
801046f8:	e8 f3 dd ff ff       	call   801024f0 <kalloc>
801046fd:	85 c0                	test   %eax,%eax
801046ff:	89 43 04             	mov    %eax,0x4(%ebx)
80104702:	0f 84 dd 00 00 00    	je     801047e5 <kthread_create+0x175>
    sp -= sizeof *t->tf;
80104708:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(t->context, 0, sizeof *t->context);
8010470e:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
80104711:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
80104716:	89 53 10             	mov    %edx,0x10(%ebx)
    *(uint *) sp = (uint) trapret;
80104719:	c7 40 14 cf 5f 10 80 	movl   $0x80105fcf,0x14(%eax)
    t->context = (struct context *) sp;
80104720:	89 43 14             	mov    %eax,0x14(%ebx)
    memset(t->context, 0, sizeof *t->context);
80104723:	6a 14                	push   $0x14
80104725:	6a 00                	push   $0x0
80104727:	50                   	push   %eax
80104728:	e8 f3 05 00 00       	call   80104d20 <memset>
    t->context->eip = (uint) forkret;
8010472d:	8b 43 14             	mov    0x14(%ebx),%eax
    memset(t->tf, 0, sizeof(*t->tf));
80104730:	83 c4 0c             	add    $0xc,%esp
    t->context->eip = (uint) forkret;
80104733:	c7 40 10 70 37 10 80 	movl   $0x80103770,0x10(%eax)
    memset(t->tf, 0, sizeof(*t->tf));
8010473a:	6a 4c                	push   $0x4c
8010473c:	6a 00                	push   $0x0
8010473e:	ff 73 10             	pushl  0x10(%ebx)
80104741:	e8 da 05 00 00       	call   80104d20 <memset>
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104746:	8b 43 10             	mov    0x10(%ebx),%eax
80104749:	ba 1b 00 00 00       	mov    $0x1b,%edx
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010474e:	b9 23 00 00 00       	mov    $0x23,%ecx
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104753:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104757:	8b 43 10             	mov    0x10(%ebx),%eax
8010475a:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    t->tf->es = t->tf->ds;
8010475e:	8b 43 10             	mov    0x10(%ebx),%eax
80104761:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104765:	66 89 50 28          	mov    %dx,0x28(%eax)
    t->tf->ss = t->tf->ds;
80104769:	8b 43 10             	mov    0x10(%ebx),%eax
8010476c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104770:	66 89 50 48          	mov    %dx,0x48(%eax)
    t->tf->eflags = FL_IF;
80104774:	8b 43 10             	mov    0x10(%ebx),%eax
    t->tf->eip = (uint) start_func;  // beginning of run func
80104777:	8b 55 08             	mov    0x8(%ebp),%edx
    t->tf->eflags = FL_IF;
8010477a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    t->tf->esp = PGSIZE;
80104781:	8b 43 10             	mov    0x10(%ebx),%eax
80104784:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    t->tf->eip = (uint) start_func;  // beginning of run func
8010478b:	8b 43 10             	mov    0x10(%ebx),%eax
8010478e:	89 50 38             	mov    %edx,0x38(%eax)
    pushcli();
80104791:	e8 9a 03 00 00       	call   80104b30 <pushcli>
    c = mycpu();
80104796:	e8 c5 f0 ff ff       	call   80103860 <mycpu>
    p = c->proc;
8010479b:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801047a1:	e8 ca 03 00 00       	call   80104b70 <popcli>
    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
801047a6:	8d 43 20             	lea    0x20(%ebx),%eax
801047a9:	83 c4 0c             	add    $0xc,%esp
801047ac:	83 c6 64             	add    $0x64,%esi
801047af:	6a 10                	push   $0x10
801047b1:	56                   	push   %esi
801047b2:	50                   	push   %eax
801047b3:	e8 48 07 00 00       	call   80104f00 <safestrcpy>
    t->killed = 0;
801047b8:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    t->chan = 0;
801047bf:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    t->state = RUNNABLE;
801047c6:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    release(&ptable.lock);
801047cd:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801047d4:	e8 e7 04 00 00       	call   80104cc0 <release>
    return 0;
801047d9:	83 c4 10             	add    $0x10,%esp
}
801047dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801047df:	31 c0                	xor    %eax,%eax
}
801047e1:	5b                   	pop    %ebx
801047e2:	5e                   	pop    %esi
801047e3:	5d                   	pop    %ebp
801047e4:	c3                   	ret    
        t->state = UNUSED;
801047e5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
801047ec:	e9 cd fe ff ff       	jmp    801046be <kthread_create+0x4e>
801047f1:	eb 0d                	jmp    80104800 <kthread_id>
801047f3:	90                   	nop
801047f4:	90                   	nop
801047f5:	90                   	nop
801047f6:	90                   	nop
801047f7:	90                   	nop
801047f8:	90                   	nop
801047f9:	90                   	nop
801047fa:	90                   	nop
801047fb:	90                   	nop
801047fc:	90                   	nop
801047fd:	90                   	nop
801047fe:	90                   	nop
801047ff:	90                   	nop

80104800 <kthread_id>:

//this func haven't been used - i's implementation is in sysproc
int kthread_id() {
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104807:	e8 24 03 00 00       	call   80104b30 <pushcli>
    c = mycpu();
8010480c:	e8 4f f0 ff ff       	call   80103860 <mycpu>
    t = c->currThread;
80104811:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104817:	e8 54 03 00 00       	call   80104b70 <popcli>
    return mythread()->tid;
8010481c:	8b 43 0c             	mov    0xc(%ebx),%eax
}
8010481f:	83 c4 04             	add    $0x4,%esp
80104822:	5b                   	pop    %ebx
80104823:	5d                   	pop    %ebp
80104824:	c3                   	ret    
80104825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <kthread_exit>:

void kthread_exit() {
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104837:	e8 f4 02 00 00       	call   80104b30 <pushcli>
    c = mycpu();
8010483c:	e8 1f f0 ff ff       	call   80103860 <mycpu>
    p = c->proc;
80104841:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104847:	e8 24 03 00 00       	call   80104b70 <popcli>
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
8010484c:	83 ec 0c             	sub    $0xc,%esp
8010484f:	68 60 3d 11 80       	push   $0x80113d60
80104854:	e8 a7 03 00 00       	call   80104c00 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104859:	8d 43 74             	lea    0x74(%ebx),%eax
8010485c:	8d 8b b4 03 00 00    	lea    0x3b4(%ebx),%ecx
80104862:	83 c4 10             	add    $0x10,%esp
    int counter = 0;
80104865:	31 db                	xor    %ebx,%ebx
80104867:	eb 13                	jmp    8010487c <kthread_exit+0x4c>
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (t->state == UNUSED || t->state == ZOMBIE)
80104870:	83 fa 05             	cmp    $0x5,%edx
80104873:	74 0e                	je     80104883 <kthread_exit+0x53>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104875:	83 c0 34             	add    $0x34,%eax
80104878:	39 c8                	cmp    %ecx,%eax
8010487a:	73 11                	jae    8010488d <kthread_exit+0x5d>
        if (t->state == UNUSED || t->state == ZOMBIE)
8010487c:	8b 50 08             	mov    0x8(%eax),%edx
8010487f:	85 d2                	test   %edx,%edx
80104881:	75 ed                	jne    80104870 <kthread_exit+0x40>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104883:	83 c0 34             	add    $0x34,%eax
            counter++;
80104886:	83 c3 01             	add    $0x1,%ebx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104889:	39 c8                	cmp    %ecx,%eax
8010488b:	72 ef                	jb     8010487c <kthread_exit+0x4c>
    }
    if (counter == (NTHREADS - 1)){ //all other threads aren't available -> close proc
8010488d:	83 fb 0f             	cmp    $0xf,%ebx
80104890:	74 1d                	je     801048af <kthread_exit+0x7f>
        release(&ptable.lock);
        exit();
    }
    else{   //there are other threads in the same proc - close just the specific thread
        cleanThread(t);
80104892:	83 ec 0c             	sub    $0xc,%esp
80104895:	50                   	push   %eax
80104896:	e8 65 ef ff ff       	call   80103800 <cleanThread>
        release(&ptable.lock);
8010489b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801048a2:	e8 19 04 00 00       	call   80104cc0 <release>
    }
}
801048a7:	83 c4 10             	add    $0x10,%esp
801048aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048ad:	c9                   	leave  
801048ae:	c3                   	ret    
        release(&ptable.lock);
801048af:	83 ec 0c             	sub    $0xc,%esp
801048b2:	68 60 3d 11 80       	push   $0x80113d60
801048b7:	e8 04 04 00 00       	call   80104cc0 <release>
        exit();
801048bc:	e8 ff f7 ff ff       	call   801040c0 <exit>
801048c1:	eb 0d                	jmp    801048d0 <kthread_join>
801048c3:	90                   	nop
801048c4:	90                   	nop
801048c5:	90                   	nop
801048c6:	90                   	nop
801048c7:	90                   	nop
801048c8:	90                   	nop
801048c9:	90                   	nop
801048ca:	90                   	nop
801048cb:	90                   	nop
801048cc:	90                   	nop
801048cd:	90                   	nop
801048ce:	90                   	nop
801048cf:	90                   	nop

801048d0 <kthread_join>:

int kthread_join(int thread_id) {
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 10             	sub    $0x10,%esp
801048d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
801048da:	68 60 3d 11 80       	push   $0x80113d60
801048df:	e8 1c 03 00 00       	call   80104c00 <acquire>
801048e4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048e7:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
801048ec:	eb 10                	jmp    801048fe <kthread_join+0x2e>
801048ee:	66 90                	xchg   %ax,%ax
801048f0:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
801048f6:	81 fa 94 2c 12 80    	cmp    $0x80122c94,%edx
801048fc:	73 72                	jae    80104970 <kthread_join+0xa0>
        if (p->state != UNUSED) {
801048fe:	8b 42 08             	mov    0x8(%edx),%eax
80104901:	85 c0                	test   %eax,%eax
80104903:	74 eb                	je     801048f0 <kthread_join+0x20>
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->tid == thread_id)
80104905:	39 9a 80 00 00 00    	cmp    %ebx,0x80(%edx)
8010490b:	8d 42 74             	lea    0x74(%edx),%eax
8010490e:	8d 8a b4 03 00 00    	lea    0x3b4(%edx),%ecx
80104914:	74 16                	je     8010492c <kthread_join+0x5c>
80104916:	8d 76 00             	lea    0x0(%esi),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104920:	83 c0 34             	add    $0x34,%eax
80104923:	39 c8                	cmp    %ecx,%eax
80104925:	73 c9                	jae    801048f0 <kthread_join+0x20>
                if (t->tid == thread_id)
80104927:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010492a:	75 f4                	jne    80104920 <kthread_join+0x50>
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
    return -1;
    found2:
    if (t->state == UNUSED || t->state == ZOMBIE){
8010492c:	8b 50 08             	mov    0x8(%eax),%edx
8010492f:	85 d2                	test   %edx,%edx
80104931:	74 3d                	je     80104970 <kthread_join+0xa0>
80104933:	83 fa 05             	cmp    $0x5,%edx
80104936:	74 38                	je     80104970 <kthread_join+0xa0>
        release(&ptable.lock);
        return -1;
    }
    sleep(t,&ptable.lock);
80104938:	83 ec 08             	sub    $0x8,%esp
8010493b:	68 60 3d 11 80       	push   $0x80113d60
80104940:	50                   	push   %eax
80104941:	e8 fa f5 ff ff       	call   80103f40 <sleep>
    //TODO - not sure about release
    if(holding(&ptable.lock))
80104946:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
8010494d:	e8 7e 02 00 00       	call   80104bd0 <holding>
80104952:	83 c4 10             	add    $0x10,%esp
80104955:	85 c0                	test   %eax,%eax
80104957:	74 12                	je     8010496b <kthread_join+0x9b>
        release(&ptable.lock);
80104959:	83 ec 0c             	sub    $0xc,%esp
8010495c:	68 60 3d 11 80       	push   $0x80113d60
80104961:	e8 5a 03 00 00       	call   80104cc0 <release>
80104966:	83 c4 10             	add    $0x10,%esp
    return 0;
80104969:	31 c0                	xor    %eax,%eax
8010496b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010496e:	c9                   	leave  
8010496f:	c3                   	ret    
    release(&ptable.lock);
80104970:	83 ec 0c             	sub    $0xc,%esp
80104973:	68 60 3d 11 80       	push   $0x80113d60
80104978:	e8 43 03 00 00       	call   80104cc0 <release>
    return -1;
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104988:	c9                   	leave  
80104989:	c3                   	ret    
8010498a:	66 90                	xchg   %ax,%ax
8010498c:	66 90                	xchg   %ax,%ax
8010498e:	66 90                	xchg   %ax,%ax

80104990 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010499a:	68 58 7f 10 80       	push   $0x80107f58
8010499f:	8d 43 04             	lea    0x4(%ebx),%eax
801049a2:	50                   	push   %eax
801049a3:	e8 18 01 00 00       	call   80104ac0 <initlock>
  lk->name = name;
801049a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801049be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049c1:	c9                   	leave  
801049c2:	c3                   	ret    
801049c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049d8:	83 ec 0c             	sub    $0xc,%esp
801049db:	8d 73 04             	lea    0x4(%ebx),%esi
801049de:	56                   	push   %esi
801049df:	e8 1c 02 00 00       	call   80104c00 <acquire>
  while (lk->locked) {
801049e4:	8b 13                	mov    (%ebx),%edx
801049e6:	83 c4 10             	add    $0x10,%esp
801049e9:	85 d2                	test   %edx,%edx
801049eb:	74 16                	je     80104a03 <acquiresleep+0x33>
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049f0:	83 ec 08             	sub    $0x8,%esp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	e8 46 f5 ff ff       	call   80103f40 <sleep>
  while (lk->locked) {
801049fa:	8b 03                	mov    (%ebx),%eax
801049fc:	83 c4 10             	add    $0x10,%esp
801049ff:	85 c0                	test   %eax,%eax
80104a01:	75 ed                	jne    801049f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104a03:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a09:	e8 f2 ee ff ff       	call   80103900 <myproc>
80104a0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104a11:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a14:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a1a:	5b                   	pop    %ebx
80104a1b:	5e                   	pop    %esi
80104a1c:	5d                   	pop    %ebp
  release(&lk->lk);
80104a1d:	e9 9e 02 00 00       	jmp    80104cc0 <release>
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
80104a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a38:	83 ec 0c             	sub    $0xc,%esp
80104a3b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a3e:	56                   	push   %esi
80104a3f:	e8 bc 01 00 00       	call   80104c00 <acquire>
  lk->locked = 0;
80104a44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a4a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a51:	89 1c 24             	mov    %ebx,(%esp)
80104a54:	e8 d7 f9 ff ff       	call   80104430 <wakeup>
  release(&lk->lk);
80104a59:	89 75 08             	mov    %esi,0x8(%ebp)
80104a5c:	83 c4 10             	add    $0x10,%esp
}
80104a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a62:	5b                   	pop    %ebx
80104a63:	5e                   	pop    %esi
80104a64:	5d                   	pop    %ebp
  release(&lk->lk);
80104a65:	e9 56 02 00 00       	jmp    80104cc0 <release>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	53                   	push   %ebx
80104a76:	31 ff                	xor    %edi,%edi
80104a78:	83 ec 18             	sub    $0x18,%esp
80104a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a7e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a81:	56                   	push   %esi
80104a82:	e8 79 01 00 00       	call   80104c00 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a87:	8b 03                	mov    (%ebx),%eax
80104a89:	83 c4 10             	add    $0x10,%esp
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	74 13                	je     80104aa3 <holdingsleep+0x33>
80104a90:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a93:	e8 68 ee ff ff       	call   80103900 <myproc>
80104a98:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104a9b:	0f 94 c0             	sete   %al
80104a9e:	0f b6 c0             	movzbl %al,%eax
80104aa1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104aa3:	83 ec 0c             	sub    $0xc,%esp
80104aa6:	56                   	push   %esi
80104aa7:	e8 14 02 00 00       	call   80104cc0 <release>
  return r;
}
80104aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aaf:	89 f8                	mov    %edi,%eax
80104ab1:	5b                   	pop    %ebx
80104ab2:	5e                   	pop    %esi
80104ab3:	5f                   	pop    %edi
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    
80104ab6:	66 90                	xchg   %ax,%ax
80104ab8:	66 90                	xchg   %ax,%ax
80104aba:	66 90                	xchg   %ax,%ax
80104abc:	66 90                	xchg   %ax,%ax
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ac9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104acf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ad2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ad9:	5d                   	pop    %ebp
80104ada:	c3                   	ret    
80104adb:	90                   	nop
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ae0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ae1:	31 d2                	xor    %edx,%edx
{
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ae6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ae9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104aec:	83 e8 08             	sub    $0x8,%eax
80104aef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104af0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104af6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104afc:	77 1a                	ja     80104b18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104afe:	8b 58 04             	mov    0x4(%eax),%ebx
80104b01:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b04:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b07:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b09:	83 fa 0a             	cmp    $0xa,%edx
80104b0c:	75 e2                	jne    80104af0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b0e:	5b                   	pop    %ebx
80104b0f:	5d                   	pop    %ebp
80104b10:	c3                   	ret    
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b18:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b1b:	83 c1 28             	add    $0x28,%ecx
80104b1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b26:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b29:	39 c1                	cmp    %eax,%ecx
80104b2b:	75 f3                	jne    80104b20 <getcallerpcs+0x40>
}
80104b2d:	5b                   	pop    %ebx
80104b2e:	5d                   	pop    %ebp
80104b2f:	c3                   	ret    

80104b30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
80104b37:	9c                   	pushf  
80104b38:	5b                   	pop    %ebx
  asm volatile("cli");
80104b39:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b3a:	e8 21 ed ff ff       	call   80103860 <mycpu>
80104b3f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b45:	85 c0                	test   %eax,%eax
80104b47:	75 11                	jne    80104b5a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b49:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b4f:	e8 0c ed ff ff       	call   80103860 <mycpu>
80104b54:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b5a:	e8 01 ed ff ff       	call   80103860 <mycpu>
80104b5f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b66:	83 c4 04             	add    $0x4,%esp
80104b69:	5b                   	pop    %ebx
80104b6a:	5d                   	pop    %ebp
80104b6b:	c3                   	ret    
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <popcli>:

void
popcli(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b76:	9c                   	pushf  
80104b77:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b78:	f6 c4 02             	test   $0x2,%ah
80104b7b:	75 35                	jne    80104bb2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b7d:	e8 de ec ff ff       	call   80103860 <mycpu>
80104b82:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b89:	78 34                	js     80104bbf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b8b:	e8 d0 ec ff ff       	call   80103860 <mycpu>
80104b90:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b96:	85 d2                	test   %edx,%edx
80104b98:	74 06                	je     80104ba0 <popcli+0x30>
    sti();
}
80104b9a:	c9                   	leave  
80104b9b:	c3                   	ret    
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ba0:	e8 bb ec ff ff       	call   80103860 <mycpu>
80104ba5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bab:	85 c0                	test   %eax,%eax
80104bad:	74 eb                	je     80104b9a <popcli+0x2a>
  asm volatile("sti");
80104baf:	fb                   	sti    
}
80104bb0:	c9                   	leave  
80104bb1:	c3                   	ret    
    panic("popcli - interruptible");
80104bb2:	83 ec 0c             	sub    $0xc,%esp
80104bb5:	68 63 7f 10 80       	push   $0x80107f63
80104bba:	e8 d1 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104bbf:	83 ec 0c             	sub    $0xc,%esp
80104bc2:	68 7a 7f 10 80       	push   $0x80107f7a
80104bc7:	e8 c4 b7 ff ff       	call   80100390 <panic>
80104bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bd0 <holding>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	8b 75 08             	mov    0x8(%ebp),%esi
80104bd8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104bda:	e8 51 ff ff ff       	call   80104b30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bdf:	8b 06                	mov    (%esi),%eax
80104be1:	85 c0                	test   %eax,%eax
80104be3:	74 10                	je     80104bf5 <holding+0x25>
80104be5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104be8:	e8 73 ec ff ff       	call   80103860 <mycpu>
80104bed:	39 c3                	cmp    %eax,%ebx
80104bef:	0f 94 c3             	sete   %bl
80104bf2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104bf5:	e8 76 ff ff ff       	call   80104b70 <popcli>
}
80104bfa:	89 d8                	mov    %ebx,%eax
80104bfc:	5b                   	pop    %ebx
80104bfd:	5e                   	pop    %esi
80104bfe:	5d                   	pop    %ebp
80104bff:	c3                   	ret    

80104c00 <acquire>:
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104c05:	e8 26 ff ff ff       	call   80104b30 <pushcli>
  if(holding(lk))
80104c0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c0d:	83 ec 0c             	sub    $0xc,%esp
80104c10:	53                   	push   %ebx
80104c11:	e8 ba ff ff ff       	call   80104bd0 <holding>
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	85 c0                	test   %eax,%eax
80104c1b:	0f 85 83 00 00 00    	jne    80104ca4 <acquire+0xa4>
80104c21:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104c23:	ba 01 00 00 00       	mov    $0x1,%edx
80104c28:	eb 09                	jmp    80104c33 <acquire+0x33>
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c30:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c33:	89 d0                	mov    %edx,%eax
80104c35:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104c38:	85 c0                	test   %eax,%eax
80104c3a:	75 f4                	jne    80104c30 <acquire+0x30>
  __sync_synchronize();
80104c3c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c44:	e8 17 ec ff ff       	call   80103860 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c49:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104c4c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c4f:	89 e8                	mov    %ebp,%eax
80104c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c58:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104c5e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104c64:	77 1a                	ja     80104c80 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c66:	8b 48 04             	mov    0x4(%eax),%ecx
80104c69:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104c6c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c6f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c71:	83 fe 0a             	cmp    $0xa,%esi
80104c74:	75 e2                	jne    80104c58 <acquire+0x58>
}
80104c76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c79:	5b                   	pop    %ebx
80104c7a:	5e                   	pop    %esi
80104c7b:	5d                   	pop    %ebp
80104c7c:	c3                   	ret    
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
80104c80:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104c83:	83 c2 28             	add    $0x28,%edx
80104c86:	8d 76 00             	lea    0x0(%esi),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c96:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c99:	39 d0                	cmp    %edx,%eax
80104c9b:	75 f3                	jne    80104c90 <acquire+0x90>
}
80104c9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ca0:	5b                   	pop    %ebx
80104ca1:	5e                   	pop    %esi
80104ca2:	5d                   	pop    %ebp
80104ca3:	c3                   	ret    
    panic("acquire");
80104ca4:	83 ec 0c             	sub    $0xc,%esp
80104ca7:	68 81 7f 10 80       	push   $0x80107f81
80104cac:	e8 df b6 ff ff       	call   80100390 <panic>
80104cb1:	eb 0d                	jmp    80104cc0 <release>
80104cb3:	90                   	nop
80104cb4:	90                   	nop
80104cb5:	90                   	nop
80104cb6:	90                   	nop
80104cb7:	90                   	nop
80104cb8:	90                   	nop
80104cb9:	90                   	nop
80104cba:	90                   	nop
80104cbb:	90                   	nop
80104cbc:	90                   	nop
80104cbd:	90                   	nop
80104cbe:	90                   	nop
80104cbf:	90                   	nop

80104cc0 <release>:
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 10             	sub    $0x10,%esp
80104cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104cca:	53                   	push   %ebx
80104ccb:	e8 00 ff ff ff       	call   80104bd0 <holding>
80104cd0:	83 c4 10             	add    $0x10,%esp
80104cd3:	85 c0                	test   %eax,%eax
80104cd5:	74 22                	je     80104cf9 <release+0x39>
  lk->pcs[0] = 0;
80104cd7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cde:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ce5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104cf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf3:	c9                   	leave  
  popcli();
80104cf4:	e9 77 fe ff ff       	jmp    80104b70 <popcli>
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
80104cf9:	50                   	push   %eax
80104cfa:	50                   	push   %eax
80104cfb:	ff 73 04             	pushl  0x4(%ebx)
80104cfe:	68 94 7f 10 80       	push   $0x80107f94
80104d03:	e8 58 b9 ff ff       	call   80100660 <cprintf>
    panic("release");}
80104d08:	c7 04 24 89 7f 10 80 	movl   $0x80107f89,(%esp)
80104d0f:	e8 7c b6 ff ff       	call   80100390 <panic>
80104d14:	66 90                	xchg   %ax,%ax
80104d16:	66 90                	xchg   %ax,%ax
80104d18:	66 90                	xchg   %ax,%ax
80104d1a:	66 90                	xchg   %ax,%ax
80104d1c:	66 90                	xchg   %ax,%ax
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	53                   	push   %ebx
80104d25:	8b 55 08             	mov    0x8(%ebp),%edx
80104d28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d2b:	f6 c2 03             	test   $0x3,%dl
80104d2e:	75 05                	jne    80104d35 <memset+0x15>
80104d30:	f6 c1 03             	test   $0x3,%cl
80104d33:	74 13                	je     80104d48 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104d35:	89 d7                	mov    %edx,%edi
80104d37:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3a:	fc                   	cld    
80104d3b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d3d:	5b                   	pop    %ebx
80104d3e:	89 d0                	mov    %edx,%eax
80104d40:	5f                   	pop    %edi
80104d41:	5d                   	pop    %ebp
80104d42:	c3                   	ret    
80104d43:	90                   	nop
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104d48:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d4c:	c1 e9 02             	shr    $0x2,%ecx
80104d4f:	89 f8                	mov    %edi,%eax
80104d51:	89 fb                	mov    %edi,%ebx
80104d53:	c1 e0 18             	shl    $0x18,%eax
80104d56:	c1 e3 10             	shl    $0x10,%ebx
80104d59:	09 d8                	or     %ebx,%eax
80104d5b:	09 f8                	or     %edi,%eax
80104d5d:	c1 e7 08             	shl    $0x8,%edi
80104d60:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d62:	89 d7                	mov    %edx,%edi
80104d64:	fc                   	cld    
80104d65:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d67:	5b                   	pop    %ebx
80104d68:	89 d0                	mov    %edx,%eax
80104d6a:	5f                   	pop    %edi
80104d6b:	5d                   	pop    %ebp
80104d6c:	c3                   	ret    
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

80104d70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
80104d75:	53                   	push   %ebx
80104d76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d79:	8b 75 08             	mov    0x8(%ebp),%esi
80104d7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d7f:	85 db                	test   %ebx,%ebx
80104d81:	74 29                	je     80104dac <memcmp+0x3c>
    if(*s1 != *s2)
80104d83:	0f b6 16             	movzbl (%esi),%edx
80104d86:	0f b6 0f             	movzbl (%edi),%ecx
80104d89:	38 d1                	cmp    %dl,%cl
80104d8b:	75 2b                	jne    80104db8 <memcmp+0x48>
80104d8d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d92:	eb 14                	jmp    80104da8 <memcmp+0x38>
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d98:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d9c:	83 c0 01             	add    $0x1,%eax
80104d9f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104da4:	38 ca                	cmp    %cl,%dl
80104da6:	75 10                	jne    80104db8 <memcmp+0x48>
  while(n-- > 0){
80104da8:	39 d8                	cmp    %ebx,%eax
80104daa:	75 ec                	jne    80104d98 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104dac:	5b                   	pop    %ebx
  return 0;
80104dad:	31 c0                	xor    %eax,%eax
}
80104daf:	5e                   	pop    %esi
80104db0:	5f                   	pop    %edi
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	90                   	nop
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104db8:	0f b6 c2             	movzbl %dl,%eax
}
80104dbb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104dbc:	29 c8                	sub    %ecx,%eax
}
80104dbe:	5e                   	pop    %esi
80104dbf:	5f                   	pop    %edi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret    
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
80104dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ddb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dde:	39 c3                	cmp    %eax,%ebx
80104de0:	73 26                	jae    80104e08 <memmove+0x38>
80104de2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104de5:	39 c8                	cmp    %ecx,%eax
80104de7:	73 1f                	jae    80104e08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104de9:	85 f6                	test   %esi,%esi
80104deb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104dee:	74 0f                	je     80104dff <memmove+0x2f>
      *--d = *--s;
80104df0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104df4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104df7:	83 ea 01             	sub    $0x1,%edx
80104dfa:	83 fa ff             	cmp    $0xffffffff,%edx
80104dfd:	75 f1                	jne    80104df0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104dff:	5b                   	pop    %ebx
80104e00:	5e                   	pop    %esi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    
80104e03:	90                   	nop
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104e08:	31 d2                	xor    %edx,%edx
80104e0a:	85 f6                	test   %esi,%esi
80104e0c:	74 f1                	je     80104dff <memmove+0x2f>
80104e0e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104e10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104e14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104e1a:	39 d6                	cmp    %edx,%esi
80104e1c:	75 f2                	jne    80104e10 <memmove+0x40>
}
80104e1e:	5b                   	pop    %ebx
80104e1f:	5e                   	pop    %esi
80104e20:	5d                   	pop    %ebp
80104e21:	c3                   	ret    
80104e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e33:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104e34:	eb 9a                	jmp    80104dd0 <memmove>
80104e36:	8d 76 00             	lea    0x0(%esi),%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	8b 7d 10             	mov    0x10(%ebp),%edi
80104e48:	53                   	push   %ebx
80104e49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104e4f:	85 ff                	test   %edi,%edi
80104e51:	74 2f                	je     80104e82 <strncmp+0x42>
80104e53:	0f b6 01             	movzbl (%ecx),%eax
80104e56:	0f b6 1e             	movzbl (%esi),%ebx
80104e59:	84 c0                	test   %al,%al
80104e5b:	74 37                	je     80104e94 <strncmp+0x54>
80104e5d:	38 c3                	cmp    %al,%bl
80104e5f:	75 33                	jne    80104e94 <strncmp+0x54>
80104e61:	01 f7                	add    %esi,%edi
80104e63:	eb 13                	jmp    80104e78 <strncmp+0x38>
80104e65:	8d 76 00             	lea    0x0(%esi),%esi
80104e68:	0f b6 01             	movzbl (%ecx),%eax
80104e6b:	84 c0                	test   %al,%al
80104e6d:	74 21                	je     80104e90 <strncmp+0x50>
80104e6f:	0f b6 1a             	movzbl (%edx),%ebx
80104e72:	89 d6                	mov    %edx,%esi
80104e74:	38 d8                	cmp    %bl,%al
80104e76:	75 1c                	jne    80104e94 <strncmp+0x54>
    n--, p++, q++;
80104e78:	8d 56 01             	lea    0x1(%esi),%edx
80104e7b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e7e:	39 fa                	cmp    %edi,%edx
80104e80:	75 e6                	jne    80104e68 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e82:	5b                   	pop    %ebx
    return 0;
80104e83:	31 c0                	xor    %eax,%eax
}
80104e85:	5e                   	pop    %esi
80104e86:	5f                   	pop    %edi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e94:	29 d8                	sub    %ebx,%eax
}
80104e96:	5b                   	pop    %ebx
80104e97:	5e                   	pop    %esi
80104e98:	5f                   	pop    %edi
80104e99:	5d                   	pop    %ebp
80104e9a:	c3                   	ret    
80104e9b:	90                   	nop
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104eab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104eae:	89 c2                	mov    %eax,%edx
80104eb0:	eb 19                	jmp    80104ecb <strncpy+0x2b>
80104eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eb8:	83 c3 01             	add    $0x1,%ebx
80104ebb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104ebf:	83 c2 01             	add    $0x1,%edx
80104ec2:	84 c9                	test   %cl,%cl
80104ec4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ec7:	74 09                	je     80104ed2 <strncpy+0x32>
80104ec9:	89 f1                	mov    %esi,%ecx
80104ecb:	85 c9                	test   %ecx,%ecx
80104ecd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ed0:	7f e6                	jg     80104eb8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ed2:	31 c9                	xor    %ecx,%ecx
80104ed4:	85 f6                	test   %esi,%esi
80104ed6:	7e 17                	jle    80104eef <strncpy+0x4f>
80104ed8:	90                   	nop
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ee0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ee4:	89 f3                	mov    %esi,%ebx
80104ee6:	83 c1 01             	add    $0x1,%ecx
80104ee9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104eeb:	85 db                	test   %ebx,%ebx
80104eed:	7f f1                	jg     80104ee0 <strncpy+0x40>
  return os;
}
80104eef:	5b                   	pop    %ebx
80104ef0:	5e                   	pop    %esi
80104ef1:	5d                   	pop    %ebp
80104ef2:	c3                   	ret    
80104ef3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
80104f05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f08:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104f0e:	85 c9                	test   %ecx,%ecx
80104f10:	7e 26                	jle    80104f38 <safestrcpy+0x38>
80104f12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104f16:	89 c1                	mov    %eax,%ecx
80104f18:	eb 17                	jmp    80104f31 <safestrcpy+0x31>
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f20:	83 c2 01             	add    $0x1,%edx
80104f23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f27:	83 c1 01             	add    $0x1,%ecx
80104f2a:	84 db                	test   %bl,%bl
80104f2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f2f:	74 04                	je     80104f35 <safestrcpy+0x35>
80104f31:	39 f2                	cmp    %esi,%edx
80104f33:	75 eb                	jne    80104f20 <safestrcpy+0x20>
    ;
  *s = 0;
80104f35:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f38:	5b                   	pop    %ebx
80104f39:	5e                   	pop    %esi
80104f3a:	5d                   	pop    %ebp
80104f3b:	c3                   	ret    
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <strlen>:

int
strlen(const char *s)
{
80104f40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f41:	31 c0                	xor    %eax,%eax
{
80104f43:	89 e5                	mov    %esp,%ebp
80104f45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f48:	80 3a 00             	cmpb   $0x0,(%edx)
80104f4b:	74 0c                	je     80104f59 <strlen+0x19>
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
80104f50:	83 c0 01             	add    $0x1,%eax
80104f53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f57:	75 f7                	jne    80104f50 <strlen+0x10>
    ;
  return n;
}
80104f59:	5d                   	pop    %ebp
80104f5a:	c3                   	ret    

80104f5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f63:	55                   	push   %ebp
  pushl %ebx
80104f64:	53                   	push   %ebx
  pushl %esi
80104f65:	56                   	push   %esi
  pushl %edi
80104f66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f6b:	5f                   	pop    %edi
  popl %esi
80104f6c:	5e                   	pop    %esi
  popl %ebx
80104f6d:	5b                   	pop    %ebx
  popl %ebp
80104f6e:	5d                   	pop    %ebp
  ret
80104f6f:	c3                   	ret    

80104f70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	53                   	push   %ebx
80104f74:	83 ec 04             	sub    $0x4,%esp
80104f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f7a:	e8 81 e9 ff ff       	call   80103900 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f7f:	8b 00                	mov    (%eax),%eax
80104f81:	39 d8                	cmp    %ebx,%eax
80104f83:	76 1b                	jbe    80104fa0 <fetchint+0x30>
80104f85:	8d 53 04             	lea    0x4(%ebx),%edx
80104f88:	39 d0                	cmp    %edx,%eax
80104f8a:	72 14                	jb     80104fa0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f8f:	8b 13                	mov    (%ebx),%edx
80104f91:	89 10                	mov    %edx,(%eax)
  return 0;
80104f93:	31 c0                	xor    %eax,%eax
}
80104f95:	83 c4 04             	add    $0x4,%esp
80104f98:	5b                   	pop    %ebx
80104f99:	5d                   	pop    %ebp
80104f9a:	c3                   	ret    
80104f9b:	90                   	nop
80104f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa5:	eb ee                	jmp    80104f95 <fetchint+0x25>
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	83 ec 04             	sub    $0x4,%esp
80104fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104fba:	e8 41 e9 ff ff       	call   80103900 <myproc>

  if(addr >= curproc->sz)
80104fbf:	39 18                	cmp    %ebx,(%eax)
80104fc1:	76 29                	jbe    80104fec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104fc6:	89 da                	mov    %ebx,%edx
80104fc8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104fca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104fcc:	39 c3                	cmp    %eax,%ebx
80104fce:	73 1c                	jae    80104fec <fetchstr+0x3c>
    if(*s == 0)
80104fd0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104fd3:	75 10                	jne    80104fe5 <fetchstr+0x35>
80104fd5:	eb 39                	jmp    80105010 <fetchstr+0x60>
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fe0:	80 3a 00             	cmpb   $0x0,(%edx)
80104fe3:	74 1b                	je     80105000 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104fe5:	83 c2 01             	add    $0x1,%edx
80104fe8:	39 d0                	cmp    %edx,%eax
80104fea:	77 f4                	ja     80104fe0 <fetchstr+0x30>
    return -1;
80104fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104ff1:	83 c4 04             	add    $0x4,%esp
80104ff4:	5b                   	pop    %ebx
80104ff5:	5d                   	pop    %ebp
80104ff6:	c3                   	ret    
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105000:	83 c4 04             	add    $0x4,%esp
80105003:	89 d0                	mov    %edx,%eax
80105005:	29 d8                	sub    %ebx,%eax
80105007:	5b                   	pop    %ebx
80105008:	5d                   	pop    %ebp
80105009:	c3                   	ret    
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105010:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105012:	eb dd                	jmp    80104ff1 <fetchstr+0x41>
80105014:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010501a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105020 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80105025:	e8 06 e9 ff ff       	call   80103930 <mythread>
8010502a:	8b 40 10             	mov    0x10(%eax),%eax
8010502d:	8b 55 08             	mov    0x8(%ebp),%edx
80105030:	8b 40 44             	mov    0x44(%eax),%eax
80105033:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105036:	e8 c5 e8 ff ff       	call   80103900 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010503b:	8b 00                	mov    (%eax),%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
8010503d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105040:	39 c6                	cmp    %eax,%esi
80105042:	73 1c                	jae    80105060 <argint+0x40>
80105044:	8d 53 08             	lea    0x8(%ebx),%edx
80105047:	39 d0                	cmp    %edx,%eax
80105049:	72 15                	jb     80105060 <argint+0x40>
  *ip = *(int*)(addr);
8010504b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504e:	8b 53 04             	mov    0x4(%ebx),%edx
80105051:	89 10                	mov    %edx,(%eax)
  return 0;
80105053:	31 c0                	xor    %eax,%eax
}
80105055:	5b                   	pop    %ebx
80105056:	5e                   	pop    %esi
80105057:	5d                   	pop    %ebp
80105058:	c3                   	ret    
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80105065:	eb ee                	jmp    80105055 <argint+0x35>
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
80105075:	83 ec 10             	sub    $0x10,%esp
80105078:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010507b:	e8 80 e8 ff ff       	call   80103900 <myproc>
80105080:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105082:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105085:	83 ec 08             	sub    $0x8,%esp
80105088:	50                   	push   %eax
80105089:	ff 75 08             	pushl  0x8(%ebp)
8010508c:	e8 8f ff ff ff       	call   80105020 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105091:	83 c4 10             	add    $0x10,%esp
80105094:	85 c0                	test   %eax,%eax
80105096:	78 28                	js     801050c0 <argptr+0x50>
80105098:	85 db                	test   %ebx,%ebx
8010509a:	78 24                	js     801050c0 <argptr+0x50>
8010509c:	8b 16                	mov    (%esi),%edx
8010509e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a1:	39 c2                	cmp    %eax,%edx
801050a3:	76 1b                	jbe    801050c0 <argptr+0x50>
801050a5:	01 c3                	add    %eax,%ebx
801050a7:	39 da                	cmp    %ebx,%edx
801050a9:	72 15                	jb     801050c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801050ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801050ae:	89 02                	mov    %eax,(%edx)
  return 0;
801050b0:	31 c0                	xor    %eax,%eax
}
801050b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b5:	5b                   	pop    %ebx
801050b6:	5e                   	pop    %esi
801050b7:	5d                   	pop    %ebp
801050b8:	c3                   	ret    
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	eb eb                	jmp    801050b2 <argptr+0x42>
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050d9:	50                   	push   %eax
801050da:	ff 75 08             	pushl  0x8(%ebp)
801050dd:	e8 3e ff ff ff       	call   80105020 <argint>
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	85 c0                	test   %eax,%eax
801050e7:	78 17                	js     80105100 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801050e9:	83 ec 08             	sub    $0x8,%esp
801050ec:	ff 75 0c             	pushl  0xc(%ebp)
801050ef:	ff 75 f4             	pushl  -0xc(%ebp)
801050f2:	e8 b9 fe ff ff       	call   80104fb0 <fetchstr>
801050f7:	83 c4 10             	add    $0x10,%esp
}
801050fa:	c9                   	leave  
801050fb:	c3                   	ret    
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <syscall>:
[SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105115:	e8 e6 e7 ff ff       	call   80103900 <myproc>
8010511a:	89 c6                	mov    %eax,%esi
  struct thread *curthread = mythread();
8010511c:	e8 0f e8 ff ff       	call   80103930 <mythread>
80105121:	89 c3                	mov    %eax,%ebx

  num = curthread->tf->eax;
80105123:	8b 40 10             	mov    0x10(%eax),%eax
80105126:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105129:	8d 50 ff             	lea    -0x1(%eax),%edx
8010512c:	83 fa 18             	cmp    $0x18,%edx
8010512f:	77 1f                	ja     80105150 <syscall+0x40>
80105131:	8b 14 85 e0 7f 10 80 	mov    -0x7fef8020(,%eax,4),%edx
80105138:	85 d2                	test   %edx,%edx
8010513a:	74 14                	je     80105150 <syscall+0x40>
    curthread->tf->eax = syscalls[num]();
8010513c:	ff d2                	call   *%edx
8010513e:	8b 53 10             	mov    0x10(%ebx),%edx
80105141:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
  }
}
80105144:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105147:	5b                   	pop    %ebx
80105148:	5e                   	pop    %esi
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    
8010514b:	90                   	nop
8010514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105150:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105151:	8d 46 64             	lea    0x64(%esi),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105154:	50                   	push   %eax
80105155:	ff 76 0c             	pushl  0xc(%esi)
80105158:	68 b6 7f 10 80       	push   $0x80107fb6
8010515d:	e8 fe b4 ff ff       	call   80100660 <cprintf>
    curthread->tf->eax = -1;
80105162:	8b 43 10             	mov    0x10(%ebx),%eax
80105165:	83 c4 10             	add    $0x10,%esp
80105168:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010516f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105172:	5b                   	pop    %ebx
80105173:	5e                   	pop    %esi
80105174:	5d                   	pop    %ebp
80105175:	c3                   	ret    
80105176:	66 90                	xchg   %ax,%ax
80105178:	66 90                	xchg   %ax,%ax
8010517a:	66 90                	xchg   %ax,%ax
8010517c:	66 90                	xchg   %ax,%ax
8010517e:	66 90                	xchg   %ax,%ax

80105180 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
80105185:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105186:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105189:	83 ec 44             	sub    $0x44,%esp
8010518c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010518f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105192:	56                   	push   %esi
80105193:	50                   	push   %eax
{
80105194:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105197:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010519a:	e8 91 cd ff ff       	call   80101f30 <nameiparent>
8010519f:	83 c4 10             	add    $0x10,%esp
801051a2:	85 c0                	test   %eax,%eax
801051a4:	0f 84 46 01 00 00    	je     801052f0 <create+0x170>
    return 0;
  ilock(dp);
801051aa:	83 ec 0c             	sub    $0xc,%esp
801051ad:	89 c3                	mov    %eax,%ebx
801051af:	50                   	push   %eax
801051b0:	e8 fb c4 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801051b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801051b8:	83 c4 0c             	add    $0xc,%esp
801051bb:	50                   	push   %eax
801051bc:	56                   	push   %esi
801051bd:	53                   	push   %ebx
801051be:	e8 1d ca ff ff       	call   80101be0 <dirlookup>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	89 c7                	mov    %eax,%edi
801051ca:	74 34                	je     80105200 <create+0x80>
    iunlockput(dp);
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	53                   	push   %ebx
801051d0:	e8 6b c7 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
801051d5:	89 3c 24             	mov    %edi,(%esp)
801051d8:	e8 d3 c4 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801051e5:	0f 85 95 00 00 00    	jne    80105280 <create+0x100>
801051eb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801051f0:	0f 85 8a 00 00 00    	jne    80105280 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051f9:	89 f8                	mov    %edi,%eax
801051fb:	5b                   	pop    %ebx
801051fc:	5e                   	pop    %esi
801051fd:	5f                   	pop    %edi
801051fe:	5d                   	pop    %ebp
801051ff:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105200:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105204:	83 ec 08             	sub    $0x8,%esp
80105207:	50                   	push   %eax
80105208:	ff 33                	pushl  (%ebx)
8010520a:	e8 31 c3 ff ff       	call   80101540 <ialloc>
8010520f:	83 c4 10             	add    $0x10,%esp
80105212:	85 c0                	test   %eax,%eax
80105214:	89 c7                	mov    %eax,%edi
80105216:	0f 84 e8 00 00 00    	je     80105304 <create+0x184>
  ilock(ip);
8010521c:	83 ec 0c             	sub    $0xc,%esp
8010521f:	50                   	push   %eax
80105220:	e8 8b c4 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80105225:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105229:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010522d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105231:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105235:	b8 01 00 00 00       	mov    $0x1,%eax
8010523a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010523e:	89 3c 24             	mov    %edi,(%esp)
80105241:	e8 ba c3 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105246:	83 c4 10             	add    $0x10,%esp
80105249:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010524e:	74 50                	je     801052a0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105250:	83 ec 04             	sub    $0x4,%esp
80105253:	ff 77 04             	pushl  0x4(%edi)
80105256:	56                   	push   %esi
80105257:	53                   	push   %ebx
80105258:	e8 f3 cb ff ff       	call   80101e50 <dirlink>
8010525d:	83 c4 10             	add    $0x10,%esp
80105260:	85 c0                	test   %eax,%eax
80105262:	0f 88 8f 00 00 00    	js     801052f7 <create+0x177>
  iunlockput(dp);
80105268:	83 ec 0c             	sub    $0xc,%esp
8010526b:	53                   	push   %ebx
8010526c:	e8 cf c6 ff ff       	call   80101940 <iunlockput>
  return ip;
80105271:	83 c4 10             	add    $0x10,%esp
}
80105274:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105277:	89 f8                	mov    %edi,%eax
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5f                   	pop    %edi
8010527c:	5d                   	pop    %ebp
8010527d:	c3                   	ret    
8010527e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105280:	83 ec 0c             	sub    $0xc,%esp
80105283:	57                   	push   %edi
    return 0;
80105284:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105286:	e8 b5 c6 ff ff       	call   80101940 <iunlockput>
    return 0;
8010528b:	83 c4 10             	add    $0x10,%esp
}
8010528e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105291:	89 f8                	mov    %edi,%eax
80105293:	5b                   	pop    %ebx
80105294:	5e                   	pop    %esi
80105295:	5f                   	pop    %edi
80105296:	5d                   	pop    %ebp
80105297:	c3                   	ret    
80105298:	90                   	nop
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801052a0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801052a5:	83 ec 0c             	sub    $0xc,%esp
801052a8:	53                   	push   %ebx
801052a9:	e8 52 c3 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052ae:	83 c4 0c             	add    $0xc,%esp
801052b1:	ff 77 04             	pushl  0x4(%edi)
801052b4:	68 64 80 10 80       	push   $0x80108064
801052b9:	57                   	push   %edi
801052ba:	e8 91 cb ff ff       	call   80101e50 <dirlink>
801052bf:	83 c4 10             	add    $0x10,%esp
801052c2:	85 c0                	test   %eax,%eax
801052c4:	78 1c                	js     801052e2 <create+0x162>
801052c6:	83 ec 04             	sub    $0x4,%esp
801052c9:	ff 73 04             	pushl  0x4(%ebx)
801052cc:	68 63 80 10 80       	push   $0x80108063
801052d1:	57                   	push   %edi
801052d2:	e8 79 cb ff ff       	call   80101e50 <dirlink>
801052d7:	83 c4 10             	add    $0x10,%esp
801052da:	85 c0                	test   %eax,%eax
801052dc:	0f 89 6e ff ff ff    	jns    80105250 <create+0xd0>
      panic("create dots");
801052e2:	83 ec 0c             	sub    $0xc,%esp
801052e5:	68 57 80 10 80       	push   $0x80108057
801052ea:	e8 a1 b0 ff ff       	call   80100390 <panic>
801052ef:	90                   	nop
    return 0;
801052f0:	31 ff                	xor    %edi,%edi
801052f2:	e9 ff fe ff ff       	jmp    801051f6 <create+0x76>
    panic("create: dirlink");
801052f7:	83 ec 0c             	sub    $0xc,%esp
801052fa:	68 66 80 10 80       	push   $0x80108066
801052ff:	e8 8c b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	68 48 80 10 80       	push   $0x80108048
8010530c:	e8 7f b0 ff ff       	call   80100390 <panic>
80105311:	eb 0d                	jmp    80105320 <argfd.constprop.0>
80105313:	90                   	nop
80105314:	90                   	nop
80105315:	90                   	nop
80105316:	90                   	nop
80105317:	90                   	nop
80105318:	90                   	nop
80105319:	90                   	nop
8010531a:	90                   	nop
8010531b:	90                   	nop
8010531c:	90                   	nop
8010531d:	90                   	nop
8010531e:	90                   	nop
8010531f:	90                   	nop

80105320 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	56                   	push   %esi
80105324:	53                   	push   %ebx
80105325:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105327:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010532a:	89 d6                	mov    %edx,%esi
8010532c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010532f:	50                   	push   %eax
80105330:	6a 00                	push   $0x0
80105332:	e8 e9 fc ff ff       	call   80105020 <argint>
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	85 c0                	test   %eax,%eax
8010533c:	78 2a                	js     80105368 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010533e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105342:	77 24                	ja     80105368 <argfd.constprop.0+0x48>
80105344:	e8 b7 e5 ff ff       	call   80103900 <myproc>
80105349:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010534c:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
80105350:	85 c0                	test   %eax,%eax
80105352:	74 14                	je     80105368 <argfd.constprop.0+0x48>
  if(pfd)
80105354:	85 db                	test   %ebx,%ebx
80105356:	74 02                	je     8010535a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105358:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010535a:	89 06                	mov    %eax,(%esi)
  return 0;
8010535c:	31 c0                	xor    %eax,%eax
}
8010535e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105361:	5b                   	pop    %ebx
80105362:	5e                   	pop    %esi
80105363:	5d                   	pop    %ebp
80105364:	c3                   	ret    
80105365:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536d:	eb ef                	jmp    8010535e <argfd.constprop.0+0x3e>
8010536f:	90                   	nop

80105370 <sys_dup>:
{
80105370:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105371:	31 c0                	xor    %eax,%eax
{
80105373:	89 e5                	mov    %esp,%ebp
80105375:	56                   	push   %esi
80105376:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105377:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010537a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010537d:	e8 9e ff ff ff       	call   80105320 <argfd.constprop.0>
80105382:	85 c0                	test   %eax,%eax
80105384:	78 42                	js     801053c8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105386:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105389:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010538b:	e8 70 e5 ff ff       	call   80103900 <myproc>
80105390:	eb 0e                	jmp    801053a0 <sys_dup+0x30>
80105392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105398:	83 c3 01             	add    $0x1,%ebx
8010539b:	83 fb 10             	cmp    $0x10,%ebx
8010539e:	74 28                	je     801053c8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801053a0:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
801053a4:	85 d2                	test   %edx,%edx
801053a6:	75 f0                	jne    80105398 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801053a8:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
  filedup(f);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	ff 75 f4             	pushl  -0xc(%ebp)
801053b2:	e8 59 ba ff ff       	call   80100e10 <filedup>
  return fd;
801053b7:	83 c4 10             	add    $0x10,%esp
}
801053ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053bd:	89 d8                	mov    %ebx,%eax
801053bf:	5b                   	pop    %ebx
801053c0:	5e                   	pop    %esi
801053c1:	5d                   	pop    %ebp
801053c2:	c3                   	ret    
801053c3:	90                   	nop
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053d0:	89 d8                	mov    %ebx,%eax
801053d2:	5b                   	pop    %ebx
801053d3:	5e                   	pop    %esi
801053d4:	5d                   	pop    %ebp
801053d5:	c3                   	ret    
801053d6:	8d 76 00             	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_read>:
{
801053e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053e1:	31 c0                	xor    %eax,%eax
{
801053e3:	89 e5                	mov    %esp,%ebp
801053e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053eb:	e8 30 ff ff ff       	call   80105320 <argfd.constprop.0>
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 4c                	js     80105440 <sys_read+0x60>
801053f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053f7:	83 ec 08             	sub    $0x8,%esp
801053fa:	50                   	push   %eax
801053fb:	6a 02                	push   $0x2
801053fd:	e8 1e fc ff ff       	call   80105020 <argint>
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	85 c0                	test   %eax,%eax
80105407:	78 37                	js     80105440 <sys_read+0x60>
80105409:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540c:	83 ec 04             	sub    $0x4,%esp
8010540f:	ff 75 f0             	pushl  -0x10(%ebp)
80105412:	50                   	push   %eax
80105413:	6a 01                	push   $0x1
80105415:	e8 56 fc ff ff       	call   80105070 <argptr>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	78 1f                	js     80105440 <sys_read+0x60>
  return fileread(f, p, n);
80105421:	83 ec 04             	sub    $0x4,%esp
80105424:	ff 75 f0             	pushl  -0x10(%ebp)
80105427:	ff 75 f4             	pushl  -0xc(%ebp)
8010542a:	ff 75 ec             	pushl  -0x14(%ebp)
8010542d:	e8 4e bb ff ff       	call   80100f80 <fileread>
80105432:	83 c4 10             	add    $0x10,%esp
}
80105435:	c9                   	leave  
80105436:	c3                   	ret    
80105437:	89 f6                	mov    %esi,%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_write>:
{
80105450:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105451:	31 c0                	xor    %eax,%eax
{
80105453:	89 e5                	mov    %esp,%ebp
80105455:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105458:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010545b:	e8 c0 fe ff ff       	call   80105320 <argfd.constprop.0>
80105460:	85 c0                	test   %eax,%eax
80105462:	78 4c                	js     801054b0 <sys_write+0x60>
80105464:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105467:	83 ec 08             	sub    $0x8,%esp
8010546a:	50                   	push   %eax
8010546b:	6a 02                	push   $0x2
8010546d:	e8 ae fb ff ff       	call   80105020 <argint>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	85 c0                	test   %eax,%eax
80105477:	78 37                	js     801054b0 <sys_write+0x60>
80105479:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010547c:	83 ec 04             	sub    $0x4,%esp
8010547f:	ff 75 f0             	pushl  -0x10(%ebp)
80105482:	50                   	push   %eax
80105483:	6a 01                	push   $0x1
80105485:	e8 e6 fb ff ff       	call   80105070 <argptr>
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	85 c0                	test   %eax,%eax
8010548f:	78 1f                	js     801054b0 <sys_write+0x60>
  return filewrite(f, p, n);
80105491:	83 ec 04             	sub    $0x4,%esp
80105494:	ff 75 f0             	pushl  -0x10(%ebp)
80105497:	ff 75 f4             	pushl  -0xc(%ebp)
8010549a:	ff 75 ec             	pushl  -0x14(%ebp)
8010549d:	e8 6e bb ff ff       	call   80101010 <filewrite>
801054a2:	83 c4 10             	add    $0x10,%esp
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b5:	c9                   	leave  
801054b6:	c3                   	ret    
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <sys_close>:
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801054c6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054cc:	e8 4f fe ff ff       	call   80105320 <argfd.constprop.0>
801054d1:	85 c0                	test   %eax,%eax
801054d3:	78 2b                	js     80105500 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801054d5:	e8 26 e4 ff ff       	call   80103900 <myproc>
801054da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054dd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054e0:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
801054e7:	00 
  fileclose(f);
801054e8:	ff 75 f4             	pushl  -0xc(%ebp)
801054eb:	e8 70 b9 ff ff       	call   80100e60 <fileclose>
  return 0;
801054f0:	83 c4 10             	add    $0x10,%esp
801054f3:	31 c0                	xor    %eax,%eax
}
801054f5:	c9                   	leave  
801054f6:	c3                   	ret    
801054f7:	89 f6                	mov    %esi,%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105505:	c9                   	leave  
80105506:	c3                   	ret    
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <sys_fstat>:
{
80105510:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105511:	31 c0                	xor    %eax,%eax
{
80105513:	89 e5                	mov    %esp,%ebp
80105515:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105518:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010551b:	e8 00 fe ff ff       	call   80105320 <argfd.constprop.0>
80105520:	85 c0                	test   %eax,%eax
80105522:	78 2c                	js     80105550 <sys_fstat+0x40>
80105524:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105527:	83 ec 04             	sub    $0x4,%esp
8010552a:	6a 14                	push   $0x14
8010552c:	50                   	push   %eax
8010552d:	6a 01                	push   $0x1
8010552f:	e8 3c fb ff ff       	call   80105070 <argptr>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	85 c0                	test   %eax,%eax
80105539:	78 15                	js     80105550 <sys_fstat+0x40>
  return filestat(f, st);
8010553b:	83 ec 08             	sub    $0x8,%esp
8010553e:	ff 75 f4             	pushl  -0xc(%ebp)
80105541:	ff 75 f0             	pushl  -0x10(%ebp)
80105544:	e8 e7 b9 ff ff       	call   80100f30 <filestat>
80105549:	83 c4 10             	add    $0x10,%esp
}
8010554c:	c9                   	leave  
8010554d:	c3                   	ret    
8010554e:	66 90                	xchg   %ax,%ax
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_link>:
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
80105565:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105566:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105569:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010556c:	50                   	push   %eax
8010556d:	6a 00                	push   $0x0
8010556f:	e8 5c fb ff ff       	call   801050d0 <argstr>
80105574:	83 c4 10             	add    $0x10,%esp
80105577:	85 c0                	test   %eax,%eax
80105579:	0f 88 fb 00 00 00    	js     8010567a <sys_link+0x11a>
8010557f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105582:	83 ec 08             	sub    $0x8,%esp
80105585:	50                   	push   %eax
80105586:	6a 01                	push   $0x1
80105588:	e8 43 fb ff ff       	call   801050d0 <argstr>
8010558d:	83 c4 10             	add    $0x10,%esp
80105590:	85 c0                	test   %eax,%eax
80105592:	0f 88 e2 00 00 00    	js     8010567a <sys_link+0x11a>
  begin_op();
80105598:	e8 33 d6 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	ff 75 d4             	pushl  -0x2c(%ebp)
801055a3:	e8 68 c9 ff ff       	call   80101f10 <namei>
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	85 c0                	test   %eax,%eax
801055ad:	89 c3                	mov    %eax,%ebx
801055af:	0f 84 ea 00 00 00    	je     8010569f <sys_link+0x13f>
  ilock(ip);
801055b5:	83 ec 0c             	sub    $0xc,%esp
801055b8:	50                   	push   %eax
801055b9:	e8 f2 c0 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055c6:	0f 84 bb 00 00 00    	je     80105687 <sys_link+0x127>
  ip->nlink++;
801055cc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801055d1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801055d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055d7:	53                   	push   %ebx
801055d8:	e8 23 c0 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
801055dd:	89 1c 24             	mov    %ebx,(%esp)
801055e0:	e8 ab c1 ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055e5:	58                   	pop    %eax
801055e6:	5a                   	pop    %edx
801055e7:	57                   	push   %edi
801055e8:	ff 75 d0             	pushl  -0x30(%ebp)
801055eb:	e8 40 c9 ff ff       	call   80101f30 <nameiparent>
801055f0:	83 c4 10             	add    $0x10,%esp
801055f3:	85 c0                	test   %eax,%eax
801055f5:	89 c6                	mov    %eax,%esi
801055f7:	74 5b                	je     80105654 <sys_link+0xf4>
  ilock(dp);
801055f9:	83 ec 0c             	sub    $0xc,%esp
801055fc:	50                   	push   %eax
801055fd:	e8 ae c0 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	8b 03                	mov    (%ebx),%eax
80105607:	39 06                	cmp    %eax,(%esi)
80105609:	75 3d                	jne    80105648 <sys_link+0xe8>
8010560b:	83 ec 04             	sub    $0x4,%esp
8010560e:	ff 73 04             	pushl  0x4(%ebx)
80105611:	57                   	push   %edi
80105612:	56                   	push   %esi
80105613:	e8 38 c8 ff ff       	call   80101e50 <dirlink>
80105618:	83 c4 10             	add    $0x10,%esp
8010561b:	85 c0                	test   %eax,%eax
8010561d:	78 29                	js     80105648 <sys_link+0xe8>
  iunlockput(dp);
8010561f:	83 ec 0c             	sub    $0xc,%esp
80105622:	56                   	push   %esi
80105623:	e8 18 c3 ff ff       	call   80101940 <iunlockput>
  iput(ip);
80105628:	89 1c 24             	mov    %ebx,(%esp)
8010562b:	e8 b0 c1 ff ff       	call   801017e0 <iput>
  end_op();
80105630:	e8 0b d6 ff ff       	call   80102c40 <end_op>
  return 0;
80105635:	83 c4 10             	add    $0x10,%esp
80105638:	31 c0                	xor    %eax,%eax
}
8010563a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010563d:	5b                   	pop    %ebx
8010563e:	5e                   	pop    %esi
8010563f:	5f                   	pop    %edi
80105640:	5d                   	pop    %ebp
80105641:	c3                   	ret    
80105642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	56                   	push   %esi
8010564c:	e8 ef c2 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105651:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105654:	83 ec 0c             	sub    $0xc,%esp
80105657:	53                   	push   %ebx
80105658:	e8 53 c0 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
8010565d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105662:	89 1c 24             	mov    %ebx,(%esp)
80105665:	e8 96 bf ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010566a:	89 1c 24             	mov    %ebx,(%esp)
8010566d:	e8 ce c2 ff ff       	call   80101940 <iunlockput>
  end_op();
80105672:	e8 c9 d5 ff ff       	call   80102c40 <end_op>
  return -1;
80105677:	83 c4 10             	add    $0x10,%esp
}
8010567a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010567d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105682:	5b                   	pop    %ebx
80105683:	5e                   	pop    %esi
80105684:	5f                   	pop    %edi
80105685:	5d                   	pop    %ebp
80105686:	c3                   	ret    
    iunlockput(ip);
80105687:	83 ec 0c             	sub    $0xc,%esp
8010568a:	53                   	push   %ebx
8010568b:	e8 b0 c2 ff ff       	call   80101940 <iunlockput>
    end_op();
80105690:	e8 ab d5 ff ff       	call   80102c40 <end_op>
    return -1;
80105695:	83 c4 10             	add    $0x10,%esp
80105698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569d:	eb 9b                	jmp    8010563a <sys_link+0xda>
    end_op();
8010569f:	e8 9c d5 ff ff       	call   80102c40 <end_op>
    return -1;
801056a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a9:	eb 8f                	jmp    8010563a <sys_link+0xda>
801056ab:	90                   	nop
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056b0 <sys_unlink>:
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
801056b5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801056b6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056b9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801056bc:	50                   	push   %eax
801056bd:	6a 00                	push   $0x0
801056bf:	e8 0c fa ff ff       	call   801050d0 <argstr>
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	85 c0                	test   %eax,%eax
801056c9:	0f 88 77 01 00 00    	js     80105846 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801056cf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801056d2:	e8 f9 d4 ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056d7:	83 ec 08             	sub    $0x8,%esp
801056da:	53                   	push   %ebx
801056db:	ff 75 c0             	pushl  -0x40(%ebp)
801056de:	e8 4d c8 ff ff       	call   80101f30 <nameiparent>
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	89 c6                	mov    %eax,%esi
801056ea:	0f 84 60 01 00 00    	je     80105850 <sys_unlink+0x1a0>
  ilock(dp);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	50                   	push   %eax
801056f4:	e8 b7 bf ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056f9:	58                   	pop    %eax
801056fa:	5a                   	pop    %edx
801056fb:	68 64 80 10 80       	push   $0x80108064
80105700:	53                   	push   %ebx
80105701:	e8 ba c4 ff ff       	call   80101bc0 <namecmp>
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	85 c0                	test   %eax,%eax
8010570b:	0f 84 03 01 00 00    	je     80105814 <sys_unlink+0x164>
80105711:	83 ec 08             	sub    $0x8,%esp
80105714:	68 63 80 10 80       	push   $0x80108063
80105719:	53                   	push   %ebx
8010571a:	e8 a1 c4 ff ff       	call   80101bc0 <namecmp>
8010571f:	83 c4 10             	add    $0x10,%esp
80105722:	85 c0                	test   %eax,%eax
80105724:	0f 84 ea 00 00 00    	je     80105814 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010572a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010572d:	83 ec 04             	sub    $0x4,%esp
80105730:	50                   	push   %eax
80105731:	53                   	push   %ebx
80105732:	56                   	push   %esi
80105733:	e8 a8 c4 ff ff       	call   80101be0 <dirlookup>
80105738:	83 c4 10             	add    $0x10,%esp
8010573b:	85 c0                	test   %eax,%eax
8010573d:	89 c3                	mov    %eax,%ebx
8010573f:	0f 84 cf 00 00 00    	je     80105814 <sys_unlink+0x164>
  ilock(ip);
80105745:	83 ec 0c             	sub    $0xc,%esp
80105748:	50                   	push   %eax
80105749:	e8 62 bf ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105756:	0f 8e 10 01 00 00    	jle    8010586c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010575c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105761:	74 6d                	je     801057d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105763:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105766:	83 ec 04             	sub    $0x4,%esp
80105769:	6a 10                	push   $0x10
8010576b:	6a 00                	push   $0x0
8010576d:	50                   	push   %eax
8010576e:	e8 ad f5 ff ff       	call   80104d20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105773:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105776:	6a 10                	push   $0x10
80105778:	ff 75 c4             	pushl  -0x3c(%ebp)
8010577b:	50                   	push   %eax
8010577c:	56                   	push   %esi
8010577d:	e8 0e c3 ff ff       	call   80101a90 <writei>
80105782:	83 c4 20             	add    $0x20,%esp
80105785:	83 f8 10             	cmp    $0x10,%eax
80105788:	0f 85 eb 00 00 00    	jne    80105879 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010578e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105793:	0f 84 97 00 00 00    	je     80105830 <sys_unlink+0x180>
  iunlockput(dp);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	56                   	push   %esi
8010579d:	e8 9e c1 ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
801057a2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057a7:	89 1c 24             	mov    %ebx,(%esp)
801057aa:	e8 51 be ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801057af:	89 1c 24             	mov    %ebx,(%esp)
801057b2:	e8 89 c1 ff ff       	call   80101940 <iunlockput>
  end_op();
801057b7:	e8 84 d4 ff ff       	call   80102c40 <end_op>
  return 0;
801057bc:	83 c4 10             	add    $0x10,%esp
801057bf:	31 c0                	xor    %eax,%eax
}
801057c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c4:	5b                   	pop    %ebx
801057c5:	5e                   	pop    %esi
801057c6:	5f                   	pop    %edi
801057c7:	5d                   	pop    %ebp
801057c8:	c3                   	ret    
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057d4:	76 8d                	jbe    80105763 <sys_unlink+0xb3>
801057d6:	bf 20 00 00 00       	mov    $0x20,%edi
801057db:	eb 0f                	jmp    801057ec <sys_unlink+0x13c>
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
801057e0:	83 c7 10             	add    $0x10,%edi
801057e3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801057e6:	0f 83 77 ff ff ff    	jae    80105763 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
801057ef:	6a 10                	push   $0x10
801057f1:	57                   	push   %edi
801057f2:	50                   	push   %eax
801057f3:	53                   	push   %ebx
801057f4:	e8 97 c1 ff ff       	call   80101990 <readi>
801057f9:	83 c4 10             	add    $0x10,%esp
801057fc:	83 f8 10             	cmp    $0x10,%eax
801057ff:	75 5e                	jne    8010585f <sys_unlink+0x1af>
    if(de.inum != 0)
80105801:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105806:	74 d8                	je     801057e0 <sys_unlink+0x130>
    iunlockput(ip);
80105808:	83 ec 0c             	sub    $0xc,%esp
8010580b:	53                   	push   %ebx
8010580c:	e8 2f c1 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105811:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105814:	83 ec 0c             	sub    $0xc,%esp
80105817:	56                   	push   %esi
80105818:	e8 23 c1 ff ff       	call   80101940 <iunlockput>
  end_op();
8010581d:	e8 1e d4 ff ff       	call   80102c40 <end_op>
  return -1;
80105822:	83 c4 10             	add    $0x10,%esp
80105825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582a:	eb 95                	jmp    801057c1 <sys_unlink+0x111>
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105830:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105835:	83 ec 0c             	sub    $0xc,%esp
80105838:	56                   	push   %esi
80105839:	e8 c2 bd ff ff       	call   80101600 <iupdate>
8010583e:	83 c4 10             	add    $0x10,%esp
80105841:	e9 53 ff ff ff       	jmp    80105799 <sys_unlink+0xe9>
    return -1;
80105846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584b:	e9 71 ff ff ff       	jmp    801057c1 <sys_unlink+0x111>
    end_op();
80105850:	e8 eb d3 ff ff       	call   80102c40 <end_op>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585a:	e9 62 ff ff ff       	jmp    801057c1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010585f:	83 ec 0c             	sub    $0xc,%esp
80105862:	68 88 80 10 80       	push   $0x80108088
80105867:	e8 24 ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010586c:	83 ec 0c             	sub    $0xc,%esp
8010586f:	68 76 80 10 80       	push   $0x80108076
80105874:	e8 17 ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105879:	83 ec 0c             	sub    $0xc,%esp
8010587c:	68 9a 80 10 80       	push   $0x8010809a
80105881:	e8 0a ab ff ff       	call   80100390 <panic>
80105886:	8d 76 00             	lea    0x0(%esi),%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <sys_open>:

int
sys_open(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
80105895:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105896:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105899:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010589c:	50                   	push   %eax
8010589d:	6a 00                	push   $0x0
8010589f:	e8 2c f8 ff ff       	call   801050d0 <argstr>
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	85 c0                	test   %eax,%eax
801058a9:	0f 88 1d 01 00 00    	js     801059cc <sys_open+0x13c>
801058af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058b2:	83 ec 08             	sub    $0x8,%esp
801058b5:	50                   	push   %eax
801058b6:	6a 01                	push   $0x1
801058b8:	e8 63 f7 ff ff       	call   80105020 <argint>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	0f 88 04 01 00 00    	js     801059cc <sys_open+0x13c>
    return -1;

  begin_op();
801058c8:	e8 03 d3 ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
801058cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058d1:	0f 85 a9 00 00 00    	jne    80105980 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058d7:	83 ec 0c             	sub    $0xc,%esp
801058da:	ff 75 e0             	pushl  -0x20(%ebp)
801058dd:	e8 2e c6 ff ff       	call   80101f10 <namei>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	89 c6                	mov    %eax,%esi
801058e9:	0f 84 b2 00 00 00    	je     801059a1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801058ef:	83 ec 0c             	sub    $0xc,%esp
801058f2:	50                   	push   %eax
801058f3:	e8 b8 bd ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105900:	0f 84 aa 00 00 00    	je     801059b0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105906:	e8 95 b4 ff ff       	call   80100da0 <filealloc>
8010590b:	85 c0                	test   %eax,%eax
8010590d:	89 c7                	mov    %eax,%edi
8010590f:	0f 84 a6 00 00 00    	je     801059bb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105915:	e8 e6 df ff ff       	call   80103900 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010591a:	31 db                	xor    %ebx,%ebx
8010591c:	eb 0e                	jmp    8010592c <sys_open+0x9c>
8010591e:	66 90                	xchg   %ax,%ax
80105920:	83 c3 01             	add    $0x1,%ebx
80105923:	83 fb 10             	cmp    $0x10,%ebx
80105926:	0f 84 ac 00 00 00    	je     801059d8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010592c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105930:	85 d2                	test   %edx,%edx
80105932:	75 ec                	jne    80105920 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105934:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105937:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
  iunlock(ip);
8010593b:	56                   	push   %esi
8010593c:	e8 4f be ff ff       	call   80101790 <iunlock>
  end_op();
80105941:	e8 fa d2 ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80105946:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010594c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010594f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105952:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105955:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010595c:	89 d0                	mov    %edx,%eax
8010595e:	f7 d0                	not    %eax
80105960:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105963:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105966:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105969:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010596d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105970:	89 d8                	mov    %ebx,%eax
80105972:	5b                   	pop    %ebx
80105973:	5e                   	pop    %esi
80105974:	5f                   	pop    %edi
80105975:	5d                   	pop    %ebp
80105976:	c3                   	ret    
80105977:	89 f6                	mov    %esi,%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105986:	31 c9                	xor    %ecx,%ecx
80105988:	6a 00                	push   $0x0
8010598a:	ba 02 00 00 00       	mov    $0x2,%edx
8010598f:	e8 ec f7 ff ff       	call   80105180 <create>
    if(ip == 0){
80105994:	83 c4 10             	add    $0x10,%esp
80105997:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105999:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010599b:	0f 85 65 ff ff ff    	jne    80105906 <sys_open+0x76>
      end_op();
801059a1:	e8 9a d2 ff ff       	call   80102c40 <end_op>
      return -1;
801059a6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059ab:	eb c0                	jmp    8010596d <sys_open+0xdd>
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801059b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059b3:	85 c9                	test   %ecx,%ecx
801059b5:	0f 84 4b ff ff ff    	je     80105906 <sys_open+0x76>
    iunlockput(ip);
801059bb:	83 ec 0c             	sub    $0xc,%esp
801059be:	56                   	push   %esi
801059bf:	e8 7c bf ff ff       	call   80101940 <iunlockput>
    end_op();
801059c4:	e8 77 d2 ff ff       	call   80102c40 <end_op>
    return -1;
801059c9:	83 c4 10             	add    $0x10,%esp
801059cc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059d1:	eb 9a                	jmp    8010596d <sys_open+0xdd>
801059d3:	90                   	nop
801059d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801059d8:	83 ec 0c             	sub    $0xc,%esp
801059db:	57                   	push   %edi
801059dc:	e8 7f b4 ff ff       	call   80100e60 <fileclose>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	eb d5                	jmp    801059bb <sys_open+0x12b>
801059e6:	8d 76 00             	lea    0x0(%esi),%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059f6:	e8 d5 d1 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059fe:	83 ec 08             	sub    $0x8,%esp
80105a01:	50                   	push   %eax
80105a02:	6a 00                	push   $0x0
80105a04:	e8 c7 f6 ff ff       	call   801050d0 <argstr>
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	78 30                	js     80105a40 <sys_mkdir+0x50>
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a16:	31 c9                	xor    %ecx,%ecx
80105a18:	6a 00                	push   $0x0
80105a1a:	ba 01 00 00 00       	mov    $0x1,%edx
80105a1f:	e8 5c f7 ff ff       	call   80105180 <create>
80105a24:	83 c4 10             	add    $0x10,%esp
80105a27:	85 c0                	test   %eax,%eax
80105a29:	74 15                	je     80105a40 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a2b:	83 ec 0c             	sub    $0xc,%esp
80105a2e:	50                   	push   %eax
80105a2f:	e8 0c bf ff ff       	call   80101940 <iunlockput>
  end_op();
80105a34:	e8 07 d2 ff ff       	call   80102c40 <end_op>
  return 0;
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	31 c0                	xor    %eax,%eax
}
80105a3e:	c9                   	leave  
80105a3f:	c3                   	ret    
    end_op();
80105a40:	e8 fb d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105a45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a4a:	c9                   	leave  
80105a4b:	c3                   	ret    
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_mknod>:

int
sys_mknod(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a56:	e8 75 d1 ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a5e:	83 ec 08             	sub    $0x8,%esp
80105a61:	50                   	push   %eax
80105a62:	6a 00                	push   $0x0
80105a64:	e8 67 f6 ff ff       	call   801050d0 <argstr>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	85 c0                	test   %eax,%eax
80105a6e:	78 60                	js     80105ad0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a70:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a73:	83 ec 08             	sub    $0x8,%esp
80105a76:	50                   	push   %eax
80105a77:	6a 01                	push   $0x1
80105a79:	e8 a2 f5 ff ff       	call   80105020 <argint>
  if((argstr(0, &path)) < 0 ||
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	78 4b                	js     80105ad0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a88:	83 ec 08             	sub    $0x8,%esp
80105a8b:	50                   	push   %eax
80105a8c:	6a 02                	push   $0x2
80105a8e:	e8 8d f5 ff ff       	call   80105020 <argint>
     argint(1, &major) < 0 ||
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 c0                	test   %eax,%eax
80105a98:	78 36                	js     80105ad0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a9a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a9e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105aa1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105aa5:	ba 03 00 00 00       	mov    $0x3,%edx
80105aaa:	50                   	push   %eax
80105aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105aae:	e8 cd f6 ff ff       	call   80105180 <create>
80105ab3:	83 c4 10             	add    $0x10,%esp
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	74 16                	je     80105ad0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105aba:	83 ec 0c             	sub    $0xc,%esp
80105abd:	50                   	push   %eax
80105abe:	e8 7d be ff ff       	call   80101940 <iunlockput>
  end_op();
80105ac3:	e8 78 d1 ff ff       	call   80102c40 <end_op>
  return 0;
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	31 c0                	xor    %eax,%eax
}
80105acd:	c9                   	leave  
80105ace:	c3                   	ret    
80105acf:	90                   	nop
    end_op();
80105ad0:	e8 6b d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ada:	c9                   	leave  
80105adb:	c3                   	ret    
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <sys_chdir>:

int
sys_chdir(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	56                   	push   %esi
80105ae4:	53                   	push   %ebx
80105ae5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ae8:	e8 13 de ff ff       	call   80103900 <myproc>
80105aed:	89 c6                	mov    %eax,%esi
  //struct thread *curthread = mythread();
  
  begin_op();
80105aef:	e8 dc d0 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af7:	83 ec 08             	sub    $0x8,%esp
80105afa:	50                   	push   %eax
80105afb:	6a 00                	push   $0x0
80105afd:	e8 ce f5 ff ff       	call   801050d0 <argstr>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	78 77                	js     80105b80 <sys_chdir+0xa0>
80105b09:	83 ec 0c             	sub    $0xc,%esp
80105b0c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b0f:	e8 fc c3 ff ff       	call   80101f10 <namei>
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	85 c0                	test   %eax,%eax
80105b19:	89 c3                	mov    %eax,%ebx
80105b1b:	74 63                	je     80105b80 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	50                   	push   %eax
80105b21:	e8 8a bb ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b2e:	75 30                	jne    80105b60 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	53                   	push   %ebx
80105b34:	e8 57 bc ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105b39:	58                   	pop    %eax
80105b3a:	ff 76 60             	pushl  0x60(%esi)
80105b3d:	e8 9e bc ff ff       	call   801017e0 <iput>
  end_op();
80105b42:	e8 f9 d0 ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
80105b47:	89 5e 60             	mov    %ebx,0x60(%esi)
  return 0;
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	31 c0                	xor    %eax,%eax
}
80105b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b52:	5b                   	pop    %ebx
80105b53:	5e                   	pop    %esi
80105b54:	5d                   	pop    %ebp
80105b55:	c3                   	ret    
80105b56:	8d 76 00             	lea    0x0(%esi),%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	53                   	push   %ebx
80105b64:	e8 d7 bd ff ff       	call   80101940 <iunlockput>
    end_op();
80105b69:	e8 d2 d0 ff ff       	call   80102c40 <end_op>
    return -1;
80105b6e:	83 c4 10             	add    $0x10,%esp
80105b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b76:	eb d7                	jmp    80105b4f <sys_chdir+0x6f>
80105b78:	90                   	nop
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b80:	e8 bb d0 ff ff       	call   80102c40 <end_op>
    return -1;
80105b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b8a:	eb c3                	jmp    80105b4f <sys_chdir+0x6f>
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_exec>:

int
sys_exec(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
80105b95:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b96:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b9c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ba2:	50                   	push   %eax
80105ba3:	6a 00                	push   $0x0
80105ba5:	e8 26 f5 ff ff       	call   801050d0 <argstr>
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	85 c0                	test   %eax,%eax
80105baf:	0f 88 87 00 00 00    	js     80105c3c <sys_exec+0xac>
80105bb5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bbb:	83 ec 08             	sub    $0x8,%esp
80105bbe:	50                   	push   %eax
80105bbf:	6a 01                	push   $0x1
80105bc1:	e8 5a f4 ff ff       	call   80105020 <argint>
80105bc6:	83 c4 10             	add    $0x10,%esp
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	78 6f                	js     80105c3c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bcd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bd3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105bd6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bd8:	68 80 00 00 00       	push   $0x80
80105bdd:	6a 00                	push   $0x0
80105bdf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105be5:	50                   	push   %eax
80105be6:	e8 35 f1 ff ff       	call   80104d20 <memset>
80105beb:	83 c4 10             	add    $0x10,%esp
80105bee:	eb 2c                	jmp    80105c1c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105bf0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bf6:	85 c0                	test   %eax,%eax
80105bf8:	74 56                	je     80105c50 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bfa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105c00:	83 ec 08             	sub    $0x8,%esp
80105c03:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105c06:	52                   	push   %edx
80105c07:	50                   	push   %eax
80105c08:	e8 a3 f3 ff ff       	call   80104fb0 <fetchstr>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	85 c0                	test   %eax,%eax
80105c12:	78 28                	js     80105c3c <sys_exec+0xac>
  for(i=0;; i++){
80105c14:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c17:	83 fb 20             	cmp    $0x20,%ebx
80105c1a:	74 20                	je     80105c3c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c22:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c29:	83 ec 08             	sub    $0x8,%esp
80105c2c:	57                   	push   %edi
80105c2d:	01 f0                	add    %esi,%eax
80105c2f:	50                   	push   %eax
80105c30:	e8 3b f3 ff ff       	call   80104f70 <fetchint>
80105c35:	83 c4 10             	add    $0x10,%esp
80105c38:	85 c0                	test   %eax,%eax
80105c3a:	79 b4                	jns    80105bf0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c44:	5b                   	pop    %ebx
80105c45:	5e                   	pop    %esi
80105c46:	5f                   	pop    %edi
80105c47:	5d                   	pop    %ebp
80105c48:	c3                   	ret    
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c50:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c56:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c59:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c60:	00 00 00 00 
  return exec(path, argv);
80105c64:	50                   	push   %eax
80105c65:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c6b:	e8 a0 ad ff ff       	call   80100a10 <exec>
80105c70:	83 c4 10             	add    $0x10,%esp
}
80105c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c76:	5b                   	pop    %ebx
80105c77:	5e                   	pop    %esi
80105c78:	5f                   	pop    %edi
80105c79:	5d                   	pop    %ebp
80105c7a:	c3                   	ret    
80105c7b:	90                   	nop
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_pipe>:

int
sys_pipe(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
80105c85:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c86:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c89:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c8c:	6a 08                	push   $0x8
80105c8e:	50                   	push   %eax
80105c8f:	6a 00                	push   $0x0
80105c91:	e8 da f3 ff ff       	call   80105070 <argptr>
80105c96:	83 c4 10             	add    $0x10,%esp
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	0f 88 ae 00 00 00    	js     80105d4f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ca1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ca4:	83 ec 08             	sub    $0x8,%esp
80105ca7:	50                   	push   %eax
80105ca8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cab:	50                   	push   %eax
80105cac:	e8 bf d5 ff ff       	call   80103270 <pipealloc>
80105cb1:	83 c4 10             	add    $0x10,%esp
80105cb4:	85 c0                	test   %eax,%eax
80105cb6:	0f 88 93 00 00 00    	js     80105d4f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cbc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105cbf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105cc1:	e8 3a dc ff ff       	call   80103900 <myproc>
80105cc6:	eb 10                	jmp    80105cd8 <sys_pipe+0x58>
80105cc8:	90                   	nop
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105cd0:	83 c3 01             	add    $0x1,%ebx
80105cd3:	83 fb 10             	cmp    $0x10,%ebx
80105cd6:	74 60                	je     80105d38 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105cd8:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
80105cdc:	85 f6                	test   %esi,%esi
80105cde:	75 f0                	jne    80105cd0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105ce0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ce3:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ce6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105ce9:	e8 12 dc ff ff       	call   80103900 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cee:	31 d2                	xor    %edx,%edx
80105cf0:	eb 0e                	jmp    80105d00 <sys_pipe+0x80>
80105cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cf8:	83 c2 01             	add    $0x1,%edx
80105cfb:	83 fa 10             	cmp    $0x10,%edx
80105cfe:	74 28                	je     80105d28 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105d00:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
80105d04:	85 c9                	test   %ecx,%ecx
80105d06:	75 f0                	jne    80105cf8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105d08:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d0f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d11:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d14:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d17:	31 c0                	xor    %eax,%eax
}
80105d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d1c:	5b                   	pop    %ebx
80105d1d:	5e                   	pop    %esi
80105d1e:	5f                   	pop    %edi
80105d1f:	5d                   	pop    %ebp
80105d20:	c3                   	ret    
80105d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105d28:	e8 d3 db ff ff       	call   80103900 <myproc>
80105d2d:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
80105d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(rf);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d3e:	e8 1d b1 ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
80105d43:	58                   	pop    %eax
80105d44:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d47:	e8 14 b1 ff ff       	call   80100e60 <fileclose>
    return -1;
80105d4c:	83 c4 10             	add    $0x10,%esp
80105d4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d54:	eb c3                	jmp    80105d19 <sys_pipe+0x99>
80105d56:	66 90                	xchg   %ax,%ax
80105d58:	66 90                	xchg   %ax,%ax
80105d5a:	66 90                	xchg   %ax,%ax
80105d5c:	66 90                	xchg   %ax,%ax
80105d5e:	66 90                	xchg   %ax,%ax

80105d60 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d63:	5d                   	pop    %ebp
  return fork();
80105d64:	e9 f7 dd ff ff       	jmp    80103b60 <fork>
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_exit>:

int
sys_exit(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d76:	e8 45 e3 ff ff       	call   801040c0 <exit>
  return 0;  // not reached
}
80105d7b:	31 c0                	xor    %eax,%eax
80105d7d:	c9                   	leave  
80105d7e:	c3                   	ret    
80105d7f:	90                   	nop

80105d80 <sys_wait>:

int
sys_wait(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d83:	5d                   	pop    %ebp
  return wait();
80105d84:	e9 37 e5 ff ff       	jmp    801042c0 <wait>
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d90 <sys_kill>:

int
sys_kill(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d99:	50                   	push   %eax
80105d9a:	6a 00                	push   $0x0
80105d9c:	e8 7f f2 ff ff       	call   80105020 <argint>
80105da1:	83 c4 10             	add    $0x10,%esp
80105da4:	85 c0                	test   %eax,%eax
80105da6:	78 18                	js     80105dc0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105da8:	83 ec 0c             	sub    $0xc,%esp
80105dab:	ff 75 f4             	pushl  -0xc(%ebp)
80105dae:	e8 0d e7 ff ff       	call   801044c0 <kill>
80105db3:	83 c4 10             	add    $0x10,%esp
}
80105db6:	c9                   	leave  
80105db7:	c3                   	ret    
80105db8:	90                   	nop
80105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dc5:	c9                   	leave  
80105dc6:	c3                   	ret    
80105dc7:	89 f6                	mov    %esi,%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dd0 <sys_getpid>:

int
sys_getpid(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105dd6:	e8 25 db ff ff       	call   80103900 <myproc>
80105ddb:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105dde:	c9                   	leave  
80105ddf:	c3                   	ret    

80105de0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105de4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105de7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dea:	50                   	push   %eax
80105deb:	6a 00                	push   $0x0
80105ded:	e8 2e f2 ff ff       	call   80105020 <argint>
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	85 c0                	test   %eax,%eax
80105df7:	78 27                	js     80105e20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105df9:	e8 02 db ff ff       	call   80103900 <myproc>
  if(growproc(n) < 0)
80105dfe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e01:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105e03:	ff 75 f4             	pushl  -0xc(%ebp)
80105e06:	e8 b5 dc ff ff       	call   80103ac0 <growproc>
80105e0b:	83 c4 10             	add    $0x10,%esp
80105e0e:	85 c0                	test   %eax,%eax
80105e10:	78 0e                	js     80105e20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105e12:	89 d8                	mov    %ebx,%eax
80105e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e17:	c9                   	leave  
80105e18:	c3                   	ret    
80105e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e25:	eb eb                	jmp    80105e12 <sys_sbrk+0x32>
80105e27:	89 f6                	mov    %esi,%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e30 <sys_sleep>:

int
sys_sleep(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e3a:	50                   	push   %eax
80105e3b:	6a 00                	push   $0x0
80105e3d:	e8 de f1 ff ff       	call   80105020 <argint>
80105e42:	83 c4 10             	add    $0x10,%esp
80105e45:	85 c0                	test   %eax,%eax
80105e47:	0f 88 8a 00 00 00    	js     80105ed7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e4d:	83 ec 0c             	sub    $0xc,%esp
80105e50:	68 a0 2c 12 80       	push   $0x80122ca0
80105e55:	e8 a6 ed ff ff       	call   80104c00 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e5d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e60:	8b 1d e0 34 12 80    	mov    0x801234e0,%ebx
  while(ticks - ticks0 < n){
80105e66:	85 d2                	test   %edx,%edx
80105e68:	75 27                	jne    80105e91 <sys_sleep+0x61>
80105e6a:	eb 54                	jmp    80105ec0 <sys_sleep+0x90>
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e70:	83 ec 08             	sub    $0x8,%esp
80105e73:	68 a0 2c 12 80       	push   $0x80122ca0
80105e78:	68 e0 34 12 80       	push   $0x801234e0
80105e7d:	e8 be e0 ff ff       	call   80103f40 <sleep>
  while(ticks - ticks0 < n){
80105e82:	a1 e0 34 12 80       	mov    0x801234e0,%eax
80105e87:	83 c4 10             	add    $0x10,%esp
80105e8a:	29 d8                	sub    %ebx,%eax
80105e8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e8f:	73 2f                	jae    80105ec0 <sys_sleep+0x90>
    if(myproc()->killed){
80105e91:	e8 6a da ff ff       	call   80103900 <myproc>
80105e96:	8b 40 1c             	mov    0x1c(%eax),%eax
80105e99:	85 c0                	test   %eax,%eax
80105e9b:	74 d3                	je     80105e70 <sys_sleep+0x40>
      release(&tickslock);
80105e9d:	83 ec 0c             	sub    $0xc,%esp
80105ea0:	68 a0 2c 12 80       	push   $0x80122ca0
80105ea5:	e8 16 ee ff ff       	call   80104cc0 <release>
      return -1;
80105eaa:	83 c4 10             	add    $0x10,%esp
80105ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    
80105eb7:	89 f6                	mov    %esi,%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	68 a0 2c 12 80       	push   $0x80122ca0
80105ec8:	e8 f3 ed ff ff       	call   80104cc0 <release>
  return 0;
80105ecd:	83 c4 10             	add    $0x10,%esp
80105ed0:	31 c0                	xor    %eax,%eax
}
80105ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ed5:	c9                   	leave  
80105ed6:	c3                   	ret    
    return -1;
80105ed7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105edc:	eb f4                	jmp    80105ed2 <sys_sleep+0xa2>
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	53                   	push   %ebx
80105ee4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ee7:	68 a0 2c 12 80       	push   $0x80122ca0
80105eec:	e8 0f ed ff ff       	call   80104c00 <acquire>
  xticks = ticks;
80105ef1:	8b 1d e0 34 12 80    	mov    0x801234e0,%ebx
  release(&tickslock);
80105ef7:	c7 04 24 a0 2c 12 80 	movl   $0x80122ca0,(%esp)
80105efe:	e8 bd ed ff ff       	call   80104cc0 <release>
  return xticks;
}
80105f03:	89 d8                	mov    %ebx,%eax
80105f05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f08:	c9                   	leave  
80105f09:	c3                   	ret    
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f10 <sys_kthread_create>:

int
sys_kthread_create(void){
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 0c             	sub    $0xc,%esp
    void (*start_func)()=0;
    void* stack=0;
    if(argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
80105f16:	6a 01                	push   $0x1
80105f18:	6a 00                	push   $0x0
80105f1a:	6a 00                	push   $0x0
80105f1c:	e8 4f f1 ff ff       	call   80105070 <argptr>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	85 c0                	test   %eax,%eax
80105f26:	78 28                	js     80105f50 <sys_kthread_create+0x40>
        return -1;
    if(argptr(0, stack, sizeof(*stack)) < 0)
80105f28:	83 ec 04             	sub    $0x4,%esp
80105f2b:	6a 01                	push   $0x1
80105f2d:	6a 00                	push   $0x0
80105f2f:	6a 00                	push   $0x0
80105f31:	e8 3a f1 ff ff       	call   80105070 <argptr>
80105f36:	83 c4 10             	add    $0x10,%esp
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	78 13                	js     80105f50 <sys_kthread_create+0x40>
        return -1;
    return kthread_create(start_func, stack);
80105f3d:	83 ec 08             	sub    $0x8,%esp
80105f40:	6a 00                	push   $0x0
80105f42:	6a 00                	push   $0x0
80105f44:	e8 27 e7 ff ff       	call   80104670 <kthread_create>
80105f49:	83 c4 10             	add    $0x10,%esp
}
80105f4c:	c9                   	leave  
80105f4d:	c3                   	ret    
80105f4e:	66 90                	xchg   %ax,%ax
        return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <sys_kthread_id>:

int
sys_kthread_id(void){
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 08             	sub    $0x8,%esp
    return mythread()->tid;
80105f66:	e8 c5 d9 ff ff       	call   80103930 <mythread>
80105f6b:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105f6e:	c9                   	leave  
80105f6f:	c3                   	ret    

80105f70 <sys_kthread_exit>:

int
sys_kthread_exit(void){
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	83 ec 08             	sub    $0x8,%esp
    kthread_exit();
80105f76:	e8 b5 e8 ff ff       	call   80104830 <kthread_exit>
    return 0;
}
80105f7b:	31 c0                	xor    %eax,%eax
80105f7d:	c9                   	leave  
80105f7e:	c3                   	ret    
80105f7f:	90                   	nop

80105f80 <sys_kthread_join>:

int
sys_kthread_join(void){
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if(argint(0, &tid) < 0)
80105f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f89:	50                   	push   %eax
80105f8a:	6a 00                	push   $0x0
80105f8c:	e8 8f f0 ff ff       	call   80105020 <argint>
80105f91:	83 c4 10             	add    $0x10,%esp
80105f94:	85 c0                	test   %eax,%eax
80105f96:	78 18                	js     80105fb0 <sys_kthread_join+0x30>
        return -1;
    return kthread_join(tid);
80105f98:	83 ec 0c             	sub    $0xc,%esp
80105f9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f9e:	e8 2d e9 ff ff       	call   801048d0 <kthread_join>
80105fa3:	83 c4 10             	add    $0x10,%esp
}
80105fa6:	c9                   	leave  
80105fa7:	c3                   	ret    
80105fa8:	90                   	nop
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fb5:	c9                   	leave  
80105fb6:	c3                   	ret    

80105fb7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105fb7:	1e                   	push   %ds
  pushl %es
80105fb8:	06                   	push   %es
  pushl %fs
80105fb9:	0f a0                	push   %fs
  pushl %gs
80105fbb:	0f a8                	push   %gs
  pushal
80105fbd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fbe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fc2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fc4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fc6:	54                   	push   %esp
  call trap
80105fc7:	e8 c4 00 00 00       	call   80106090 <trap>
  addl $4, %esp
80105fcc:	83 c4 04             	add    $0x4,%esp

80105fcf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fcf:	61                   	popa   
  popl %gs
80105fd0:	0f a9                	pop    %gs
  popl %fs
80105fd2:	0f a1                	pop    %fs
  popl %es
80105fd4:	07                   	pop    %es
  popl %ds
80105fd5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fd6:	83 c4 08             	add    $0x8,%esp
  iret
80105fd9:	cf                   	iret   
80105fda:	66 90                	xchg   %ax,%ax
80105fdc:	66 90                	xchg   %ax,%ax
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105fe0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105fe1:	31 c0                	xor    %eax,%eax
{
80105fe3:	89 e5                	mov    %esp,%ebp
80105fe5:	83 ec 08             	sub    $0x8,%esp
80105fe8:	90                   	nop
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ff0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105ff7:	c7 04 c5 e2 2c 12 80 	movl   $0x8e000008,-0x7fedd31e(,%eax,8)
80105ffe:	08 00 00 8e 
80106002:	66 89 14 c5 e0 2c 12 	mov    %dx,-0x7fedd320(,%eax,8)
80106009:	80 
8010600a:	c1 ea 10             	shr    $0x10,%edx
8010600d:	66 89 14 c5 e6 2c 12 	mov    %dx,-0x7fedd31a(,%eax,8)
80106014:	80 
  for(i = 0; i < 256; i++)
80106015:	83 c0 01             	add    $0x1,%eax
80106018:	3d 00 01 00 00       	cmp    $0x100,%eax
8010601d:	75 d1                	jne    80105ff0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010601f:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

  initlock(&tickslock, "time");
80106024:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106027:	c7 05 e2 2e 12 80 08 	movl   $0xef000008,0x80122ee2
8010602e:	00 00 ef 
  initlock(&tickslock, "time");
80106031:	68 a9 80 10 80       	push   $0x801080a9
80106036:	68 a0 2c 12 80       	push   $0x80122ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010603b:	66 a3 e0 2e 12 80    	mov    %ax,0x80122ee0
80106041:	c1 e8 10             	shr    $0x10,%eax
80106044:	66 a3 e6 2e 12 80    	mov    %ax,0x80122ee6
  initlock(&tickslock, "time");
8010604a:	e8 71 ea ff ff       	call   80104ac0 <initlock>
}
8010604f:	83 c4 10             	add    $0x10,%esp
80106052:	c9                   	leave  
80106053:	c3                   	ret    
80106054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010605a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106060 <idtinit>:

void
idtinit(void)
{
80106060:	55                   	push   %ebp
  pd[0] = size-1;
80106061:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106066:	89 e5                	mov    %esp,%ebp
80106068:	83 ec 10             	sub    $0x10,%esp
8010606b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010606f:	b8 e0 2c 12 80       	mov    $0x80122ce0,%eax
80106074:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106078:	c1 e8 10             	shr    $0x10,%eax
8010607b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010607f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106082:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106085:	c9                   	leave  
80106086:	c3                   	ret    
80106087:	89 f6                	mov    %esi,%esi
80106089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106090 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	57                   	push   %edi
80106094:	56                   	push   %esi
80106095:	53                   	push   %ebx
80106096:	83 ec 1c             	sub    $0x1c,%esp
80106099:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010609c:	8b 47 30             	mov    0x30(%edi),%eax
8010609f:	83 f8 40             	cmp    $0x40,%eax
801060a2:	0f 84 f0 00 00 00    	je     80106198 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801060a8:	83 e8 20             	sub    $0x20,%eax
801060ab:	83 f8 1f             	cmp    $0x1f,%eax
801060ae:	77 10                	ja     801060c0 <trap+0x30>
801060b0:	ff 24 85 50 81 10 80 	jmp    *-0x7fef7eb0(,%eax,4)
801060b7:	89 f6                	mov    %esi,%esi
801060b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801060c0:	e8 3b d8 ff ff       	call   80103900 <myproc>
801060c5:	85 c0                	test   %eax,%eax
801060c7:	8b 5f 38             	mov    0x38(%edi),%ebx
801060ca:	0f 84 14 02 00 00    	je     801062e4 <trap+0x254>
801060d0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801060d4:	0f 84 0a 02 00 00    	je     801062e4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060da:	0f 20 d1             	mov    %cr2,%ecx
801060dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060e0:	e8 fb d7 ff ff       	call   801038e0 <cpuid>
801060e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801060e8:	8b 47 34             	mov    0x34(%edi),%eax
801060eb:	8b 77 30             	mov    0x30(%edi),%esi
801060ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801060f1:	e8 0a d8 ff ff       	call   80103900 <myproc>
801060f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060f9:	e8 02 d8 ff ff       	call   80103900 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106101:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106104:	51                   	push   %ecx
80106105:	53                   	push   %ebx
80106106:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106107:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010610a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010610d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010610e:	83 c2 64             	add    $0x64,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106111:	52                   	push   %edx
80106112:	ff 70 0c             	pushl  0xc(%eax)
80106115:	68 0c 81 10 80       	push   $0x8010810c
8010611a:	e8 41 a5 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010611f:	83 c4 20             	add    $0x20,%esp
80106122:	e8 d9 d7 ff ff       	call   80103900 <myproc>
80106127:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010612e:	e8 cd d7 ff ff       	call   80103900 <myproc>
80106133:	85 c0                	test   %eax,%eax
80106135:	74 1d                	je     80106154 <trap+0xc4>
80106137:	e8 c4 d7 ff ff       	call   80103900 <myproc>
8010613c:	8b 50 1c             	mov    0x1c(%eax),%edx
8010613f:	85 d2                	test   %edx,%edx
80106141:	74 11                	je     80106154 <trap+0xc4>
80106143:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106147:	83 e0 03             	and    $0x3,%eax
8010614a:	66 83 f8 03          	cmp    $0x3,%ax
8010614e:	0f 84 4c 01 00 00    	je     801062a0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106154:	e8 a7 d7 ff ff       	call   80103900 <myproc>
80106159:	85 c0                	test   %eax,%eax
8010615b:	74 0b                	je     80106168 <trap+0xd8>
8010615d:	e8 9e d7 ff ff       	call   80103900 <myproc>
80106162:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80106166:	74 68                	je     801061d0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106168:	e8 93 d7 ff ff       	call   80103900 <myproc>
8010616d:	85 c0                	test   %eax,%eax
8010616f:	74 19                	je     8010618a <trap+0xfa>
80106171:	e8 8a d7 ff ff       	call   80103900 <myproc>
80106176:	8b 40 1c             	mov    0x1c(%eax),%eax
80106179:	85 c0                	test   %eax,%eax
8010617b:	74 0d                	je     8010618a <trap+0xfa>
8010617d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106181:	83 e0 03             	and    $0x3,%eax
80106184:	66 83 f8 03          	cmp    $0x3,%ax
80106188:	74 37                	je     801061c1 <trap+0x131>
    exit();
}
8010618a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010618d:	5b                   	pop    %ebx
8010618e:	5e                   	pop    %esi
8010618f:	5f                   	pop    %edi
80106190:	5d                   	pop    %ebp
80106191:	c3                   	ret    
80106192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106198:	e8 63 d7 ff ff       	call   80103900 <myproc>
8010619d:	8b 58 1c             	mov    0x1c(%eax),%ebx
801061a0:	85 db                	test   %ebx,%ebx
801061a2:	0f 85 e8 00 00 00    	jne    80106290 <trap+0x200>
    mythread()->tf = tf;
801061a8:	e8 83 d7 ff ff       	call   80103930 <mythread>
801061ad:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
801061b0:	e8 5b ef ff ff       	call   80105110 <syscall>
    if(myproc()->killed)
801061b5:	e8 46 d7 ff ff       	call   80103900 <myproc>
801061ba:	8b 48 1c             	mov    0x1c(%eax),%ecx
801061bd:	85 c9                	test   %ecx,%ecx
801061bf:	74 c9                	je     8010618a <trap+0xfa>
}
801061c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061c4:	5b                   	pop    %ebx
801061c5:	5e                   	pop    %esi
801061c6:	5f                   	pop    %edi
801061c7:	5d                   	pop    %ebp
      exit();
801061c8:	e9 f3 de ff ff       	jmp    801040c0 <exit>
801061cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801061d0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801061d4:	75 92                	jne    80106168 <trap+0xd8>
    yield();
801061d6:	e8 15 dd ff ff       	call   80103ef0 <yield>
801061db:	eb 8b                	jmp    80106168 <trap+0xd8>
801061dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801061e0:	e8 fb d6 ff ff       	call   801038e0 <cpuid>
801061e5:	85 c0                	test   %eax,%eax
801061e7:	0f 84 c3 00 00 00    	je     801062b0 <trap+0x220>
    lapiceoi();
801061ed:	e8 8e c5 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061f2:	e8 09 d7 ff ff       	call   80103900 <myproc>
801061f7:	85 c0                	test   %eax,%eax
801061f9:	0f 85 38 ff ff ff    	jne    80106137 <trap+0xa7>
801061ff:	e9 50 ff ff ff       	jmp    80106154 <trap+0xc4>
80106204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106208:	e8 33 c4 ff ff       	call   80102640 <kbdintr>
    lapiceoi();
8010620d:	e8 6e c5 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106212:	e8 e9 d6 ff ff       	call   80103900 <myproc>
80106217:	85 c0                	test   %eax,%eax
80106219:	0f 85 18 ff ff ff    	jne    80106137 <trap+0xa7>
8010621f:	e9 30 ff ff ff       	jmp    80106154 <trap+0xc4>
80106224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106228:	e8 53 02 00 00       	call   80106480 <uartintr>
    lapiceoi();
8010622d:	e8 4e c5 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106232:	e8 c9 d6 ff ff       	call   80103900 <myproc>
80106237:	85 c0                	test   %eax,%eax
80106239:	0f 85 f8 fe ff ff    	jne    80106137 <trap+0xa7>
8010623f:	e9 10 ff ff ff       	jmp    80106154 <trap+0xc4>
80106244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106248:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010624c:	8b 77 38             	mov    0x38(%edi),%esi
8010624f:	e8 8c d6 ff ff       	call   801038e0 <cpuid>
80106254:	56                   	push   %esi
80106255:	53                   	push   %ebx
80106256:	50                   	push   %eax
80106257:	68 b4 80 10 80       	push   $0x801080b4
8010625c:	e8 ff a3 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106261:	e8 1a c5 ff ff       	call   80102780 <lapiceoi>
    break;
80106266:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106269:	e8 92 d6 ff ff       	call   80103900 <myproc>
8010626e:	85 c0                	test   %eax,%eax
80106270:	0f 85 c1 fe ff ff    	jne    80106137 <trap+0xa7>
80106276:	e9 d9 fe ff ff       	jmp    80106154 <trap+0xc4>
8010627b:	90                   	nop
8010627c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106280:	e8 2b be ff ff       	call   801020b0 <ideintr>
80106285:	e9 63 ff ff ff       	jmp    801061ed <trap+0x15d>
8010628a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106290:	e8 2b de ff ff       	call   801040c0 <exit>
80106295:	e9 0e ff ff ff       	jmp    801061a8 <trap+0x118>
8010629a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801062a0:	e8 1b de ff ff       	call   801040c0 <exit>
801062a5:	e9 aa fe ff ff       	jmp    80106154 <trap+0xc4>
801062aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801062b0:	83 ec 0c             	sub    $0xc,%esp
801062b3:	68 a0 2c 12 80       	push   $0x80122ca0
801062b8:	e8 43 e9 ff ff       	call   80104c00 <acquire>
      wakeup(&ticks);
801062bd:	c7 04 24 e0 34 12 80 	movl   $0x801234e0,(%esp)
      ticks++;
801062c4:	83 05 e0 34 12 80 01 	addl   $0x1,0x801234e0
      wakeup(&ticks);
801062cb:	e8 60 e1 ff ff       	call   80104430 <wakeup>
      release(&tickslock);
801062d0:	c7 04 24 a0 2c 12 80 	movl   $0x80122ca0,(%esp)
801062d7:	e8 e4 e9 ff ff       	call   80104cc0 <release>
801062dc:	83 c4 10             	add    $0x10,%esp
801062df:	e9 09 ff ff ff       	jmp    801061ed <trap+0x15d>
801062e4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062e7:	e8 f4 d5 ff ff       	call   801038e0 <cpuid>
801062ec:	83 ec 0c             	sub    $0xc,%esp
801062ef:	56                   	push   %esi
801062f0:	53                   	push   %ebx
801062f1:	50                   	push   %eax
801062f2:	ff 77 30             	pushl  0x30(%edi)
801062f5:	68 d8 80 10 80       	push   $0x801080d8
801062fa:	e8 61 a3 ff ff       	call   80100660 <cprintf>
      panic("trap");
801062ff:	83 c4 14             	add    $0x14,%esp
80106302:	68 ae 80 10 80       	push   $0x801080ae
80106307:	e8 84 a0 ff ff       	call   80100390 <panic>
8010630c:	66 90                	xchg   %ax,%ax
8010630e:	66 90                	xchg   %ax,%ax

80106310 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106310:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
{
80106315:	55                   	push   %ebp
80106316:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106318:	85 c0                	test   %eax,%eax
8010631a:	74 1c                	je     80106338 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010631c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106321:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106322:	a8 01                	test   $0x1,%al
80106324:	74 12                	je     80106338 <uartgetc+0x28>
80106326:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010632b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010632c:	0f b6 c0             	movzbl %al,%eax
}
8010632f:	5d                   	pop    %ebp
80106330:	c3                   	ret    
80106331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010633d:	5d                   	pop    %ebp
8010633e:	c3                   	ret    
8010633f:	90                   	nop

80106340 <uartputc.part.0>:
uartputc(int c)
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	57                   	push   %edi
80106344:	56                   	push   %esi
80106345:	53                   	push   %ebx
80106346:	89 c7                	mov    %eax,%edi
80106348:	bb 80 00 00 00       	mov    $0x80,%ebx
8010634d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106352:	83 ec 0c             	sub    $0xc,%esp
80106355:	eb 1b                	jmp    80106372 <uartputc.part.0+0x32>
80106357:	89 f6                	mov    %esi,%esi
80106359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106360:	83 ec 0c             	sub    $0xc,%esp
80106363:	6a 0a                	push   $0xa
80106365:	e8 36 c4 ff ff       	call   801027a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010636a:	83 c4 10             	add    $0x10,%esp
8010636d:	83 eb 01             	sub    $0x1,%ebx
80106370:	74 07                	je     80106379 <uartputc.part.0+0x39>
80106372:	89 f2                	mov    %esi,%edx
80106374:	ec                   	in     (%dx),%al
80106375:	a8 20                	test   $0x20,%al
80106377:	74 e7                	je     80106360 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106379:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010637e:	89 f8                	mov    %edi,%eax
80106380:	ee                   	out    %al,(%dx)
}
80106381:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106384:	5b                   	pop    %ebx
80106385:	5e                   	pop    %esi
80106386:	5f                   	pop    %edi
80106387:	5d                   	pop    %ebp
80106388:	c3                   	ret    
80106389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106390 <uartinit>:
{
80106390:	55                   	push   %ebp
80106391:	31 c9                	xor    %ecx,%ecx
80106393:	89 c8                	mov    %ecx,%eax
80106395:	89 e5                	mov    %esp,%ebp
80106397:	57                   	push   %edi
80106398:	56                   	push   %esi
80106399:	53                   	push   %ebx
8010639a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010639f:	89 da                	mov    %ebx,%edx
801063a1:	83 ec 0c             	sub    $0xc,%esp
801063a4:	ee                   	out    %al,(%dx)
801063a5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801063aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801063af:	89 fa                	mov    %edi,%edx
801063b1:	ee                   	out    %al,(%dx)
801063b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801063b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063bc:	ee                   	out    %al,(%dx)
801063bd:	be f9 03 00 00       	mov    $0x3f9,%esi
801063c2:	89 c8                	mov    %ecx,%eax
801063c4:	89 f2                	mov    %esi,%edx
801063c6:	ee                   	out    %al,(%dx)
801063c7:	b8 03 00 00 00       	mov    $0x3,%eax
801063cc:	89 fa                	mov    %edi,%edx
801063ce:	ee                   	out    %al,(%dx)
801063cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063d4:	89 c8                	mov    %ecx,%eax
801063d6:	ee                   	out    %al,(%dx)
801063d7:	b8 01 00 00 00       	mov    $0x1,%eax
801063dc:	89 f2                	mov    %esi,%edx
801063de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801063e5:	3c ff                	cmp    $0xff,%al
801063e7:	74 5a                	je     80106443 <uartinit+0xb3>
  uart = 1;
801063e9:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801063f0:	00 00 00 
801063f3:	89 da                	mov    %ebx,%edx
801063f5:	ec                   	in     (%dx),%al
801063f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801063fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801063ff:	bb d0 81 10 80       	mov    $0x801081d0,%ebx
  ioapicenable(IRQ_COM1, 0);
80106404:	6a 00                	push   $0x0
80106406:	6a 04                	push   $0x4
80106408:	e8 f3 be ff ff       	call   80102300 <ioapicenable>
8010640d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106410:	b8 78 00 00 00       	mov    $0x78,%eax
80106415:	eb 13                	jmp    8010642a <uartinit+0x9a>
80106417:	89 f6                	mov    %esi,%esi
80106419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106420:	83 c3 01             	add    $0x1,%ebx
80106423:	0f be 03             	movsbl (%ebx),%eax
80106426:	84 c0                	test   %al,%al
80106428:	74 19                	je     80106443 <uartinit+0xb3>
  if(!uart)
8010642a:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80106430:	85 d2                	test   %edx,%edx
80106432:	74 ec                	je     80106420 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106434:	83 c3 01             	add    $0x1,%ebx
80106437:	e8 04 ff ff ff       	call   80106340 <uartputc.part.0>
8010643c:	0f be 03             	movsbl (%ebx),%eax
8010643f:	84 c0                	test   %al,%al
80106441:	75 e7                	jne    8010642a <uartinit+0x9a>
}
80106443:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106446:	5b                   	pop    %ebx
80106447:	5e                   	pop    %esi
80106448:	5f                   	pop    %edi
80106449:	5d                   	pop    %ebp
8010644a:	c3                   	ret    
8010644b:	90                   	nop
8010644c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106450 <uartputc>:
  if(!uart)
80106450:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
80106456:	55                   	push   %ebp
80106457:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106459:	85 d2                	test   %edx,%edx
{
8010645b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010645e:	74 10                	je     80106470 <uartputc+0x20>
}
80106460:	5d                   	pop    %ebp
80106461:	e9 da fe ff ff       	jmp    80106340 <uartputc.part.0>
80106466:	8d 76 00             	lea    0x0(%esi),%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106470:	5d                   	pop    %ebp
80106471:	c3                   	ret    
80106472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106480 <uartintr>:

void
uartintr(void)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106486:	68 10 63 10 80       	push   $0x80106310
8010648b:	e8 80 a3 ff ff       	call   80100810 <consoleintr>
}
80106490:	83 c4 10             	add    $0x10,%esp
80106493:	c9                   	leave  
80106494:	c3                   	ret    

80106495 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $0
80106497:	6a 00                	push   $0x0
  jmp alltraps
80106499:	e9 19 fb ff ff       	jmp    80105fb7 <alltraps>

8010649e <vector1>:
.globl vector1
vector1:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $1
801064a0:	6a 01                	push   $0x1
  jmp alltraps
801064a2:	e9 10 fb ff ff       	jmp    80105fb7 <alltraps>

801064a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $2
801064a9:	6a 02                	push   $0x2
  jmp alltraps
801064ab:	e9 07 fb ff ff       	jmp    80105fb7 <alltraps>

801064b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $3
801064b2:	6a 03                	push   $0x3
  jmp alltraps
801064b4:	e9 fe fa ff ff       	jmp    80105fb7 <alltraps>

801064b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $4
801064bb:	6a 04                	push   $0x4
  jmp alltraps
801064bd:	e9 f5 fa ff ff       	jmp    80105fb7 <alltraps>

801064c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $5
801064c4:	6a 05                	push   $0x5
  jmp alltraps
801064c6:	e9 ec fa ff ff       	jmp    80105fb7 <alltraps>

801064cb <vector6>:
.globl vector6
vector6:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $6
801064cd:	6a 06                	push   $0x6
  jmp alltraps
801064cf:	e9 e3 fa ff ff       	jmp    80105fb7 <alltraps>

801064d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $7
801064d6:	6a 07                	push   $0x7
  jmp alltraps
801064d8:	e9 da fa ff ff       	jmp    80105fb7 <alltraps>

801064dd <vector8>:
.globl vector8
vector8:
  pushl $8
801064dd:	6a 08                	push   $0x8
  jmp alltraps
801064df:	e9 d3 fa ff ff       	jmp    80105fb7 <alltraps>

801064e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $9
801064e6:	6a 09                	push   $0x9
  jmp alltraps
801064e8:	e9 ca fa ff ff       	jmp    80105fb7 <alltraps>

801064ed <vector10>:
.globl vector10
vector10:
  pushl $10
801064ed:	6a 0a                	push   $0xa
  jmp alltraps
801064ef:	e9 c3 fa ff ff       	jmp    80105fb7 <alltraps>

801064f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801064f4:	6a 0b                	push   $0xb
  jmp alltraps
801064f6:	e9 bc fa ff ff       	jmp    80105fb7 <alltraps>

801064fb <vector12>:
.globl vector12
vector12:
  pushl $12
801064fb:	6a 0c                	push   $0xc
  jmp alltraps
801064fd:	e9 b5 fa ff ff       	jmp    80105fb7 <alltraps>

80106502 <vector13>:
.globl vector13
vector13:
  pushl $13
80106502:	6a 0d                	push   $0xd
  jmp alltraps
80106504:	e9 ae fa ff ff       	jmp    80105fb7 <alltraps>

80106509 <vector14>:
.globl vector14
vector14:
  pushl $14
80106509:	6a 0e                	push   $0xe
  jmp alltraps
8010650b:	e9 a7 fa ff ff       	jmp    80105fb7 <alltraps>

80106510 <vector15>:
.globl vector15
vector15:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $15
80106512:	6a 0f                	push   $0xf
  jmp alltraps
80106514:	e9 9e fa ff ff       	jmp    80105fb7 <alltraps>

80106519 <vector16>:
.globl vector16
vector16:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $16
8010651b:	6a 10                	push   $0x10
  jmp alltraps
8010651d:	e9 95 fa ff ff       	jmp    80105fb7 <alltraps>

80106522 <vector17>:
.globl vector17
vector17:
  pushl $17
80106522:	6a 11                	push   $0x11
  jmp alltraps
80106524:	e9 8e fa ff ff       	jmp    80105fb7 <alltraps>

80106529 <vector18>:
.globl vector18
vector18:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $18
8010652b:	6a 12                	push   $0x12
  jmp alltraps
8010652d:	e9 85 fa ff ff       	jmp    80105fb7 <alltraps>

80106532 <vector19>:
.globl vector19
vector19:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $19
80106534:	6a 13                	push   $0x13
  jmp alltraps
80106536:	e9 7c fa ff ff       	jmp    80105fb7 <alltraps>

8010653b <vector20>:
.globl vector20
vector20:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $20
8010653d:	6a 14                	push   $0x14
  jmp alltraps
8010653f:	e9 73 fa ff ff       	jmp    80105fb7 <alltraps>

80106544 <vector21>:
.globl vector21
vector21:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $21
80106546:	6a 15                	push   $0x15
  jmp alltraps
80106548:	e9 6a fa ff ff       	jmp    80105fb7 <alltraps>

8010654d <vector22>:
.globl vector22
vector22:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $22
8010654f:	6a 16                	push   $0x16
  jmp alltraps
80106551:	e9 61 fa ff ff       	jmp    80105fb7 <alltraps>

80106556 <vector23>:
.globl vector23
vector23:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $23
80106558:	6a 17                	push   $0x17
  jmp alltraps
8010655a:	e9 58 fa ff ff       	jmp    80105fb7 <alltraps>

8010655f <vector24>:
.globl vector24
vector24:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $24
80106561:	6a 18                	push   $0x18
  jmp alltraps
80106563:	e9 4f fa ff ff       	jmp    80105fb7 <alltraps>

80106568 <vector25>:
.globl vector25
vector25:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $25
8010656a:	6a 19                	push   $0x19
  jmp alltraps
8010656c:	e9 46 fa ff ff       	jmp    80105fb7 <alltraps>

80106571 <vector26>:
.globl vector26
vector26:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $26
80106573:	6a 1a                	push   $0x1a
  jmp alltraps
80106575:	e9 3d fa ff ff       	jmp    80105fb7 <alltraps>

8010657a <vector27>:
.globl vector27
vector27:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $27
8010657c:	6a 1b                	push   $0x1b
  jmp alltraps
8010657e:	e9 34 fa ff ff       	jmp    80105fb7 <alltraps>

80106583 <vector28>:
.globl vector28
vector28:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $28
80106585:	6a 1c                	push   $0x1c
  jmp alltraps
80106587:	e9 2b fa ff ff       	jmp    80105fb7 <alltraps>

8010658c <vector29>:
.globl vector29
vector29:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $29
8010658e:	6a 1d                	push   $0x1d
  jmp alltraps
80106590:	e9 22 fa ff ff       	jmp    80105fb7 <alltraps>

80106595 <vector30>:
.globl vector30
vector30:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $30
80106597:	6a 1e                	push   $0x1e
  jmp alltraps
80106599:	e9 19 fa ff ff       	jmp    80105fb7 <alltraps>

8010659e <vector31>:
.globl vector31
vector31:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $31
801065a0:	6a 1f                	push   $0x1f
  jmp alltraps
801065a2:	e9 10 fa ff ff       	jmp    80105fb7 <alltraps>

801065a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $32
801065a9:	6a 20                	push   $0x20
  jmp alltraps
801065ab:	e9 07 fa ff ff       	jmp    80105fb7 <alltraps>

801065b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $33
801065b2:	6a 21                	push   $0x21
  jmp alltraps
801065b4:	e9 fe f9 ff ff       	jmp    80105fb7 <alltraps>

801065b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $34
801065bb:	6a 22                	push   $0x22
  jmp alltraps
801065bd:	e9 f5 f9 ff ff       	jmp    80105fb7 <alltraps>

801065c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $35
801065c4:	6a 23                	push   $0x23
  jmp alltraps
801065c6:	e9 ec f9 ff ff       	jmp    80105fb7 <alltraps>

801065cb <vector36>:
.globl vector36
vector36:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $36
801065cd:	6a 24                	push   $0x24
  jmp alltraps
801065cf:	e9 e3 f9 ff ff       	jmp    80105fb7 <alltraps>

801065d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $37
801065d6:	6a 25                	push   $0x25
  jmp alltraps
801065d8:	e9 da f9 ff ff       	jmp    80105fb7 <alltraps>

801065dd <vector38>:
.globl vector38
vector38:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $38
801065df:	6a 26                	push   $0x26
  jmp alltraps
801065e1:	e9 d1 f9 ff ff       	jmp    80105fb7 <alltraps>

801065e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $39
801065e8:	6a 27                	push   $0x27
  jmp alltraps
801065ea:	e9 c8 f9 ff ff       	jmp    80105fb7 <alltraps>

801065ef <vector40>:
.globl vector40
vector40:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $40
801065f1:	6a 28                	push   $0x28
  jmp alltraps
801065f3:	e9 bf f9 ff ff       	jmp    80105fb7 <alltraps>

801065f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $41
801065fa:	6a 29                	push   $0x29
  jmp alltraps
801065fc:	e9 b6 f9 ff ff       	jmp    80105fb7 <alltraps>

80106601 <vector42>:
.globl vector42
vector42:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $42
80106603:	6a 2a                	push   $0x2a
  jmp alltraps
80106605:	e9 ad f9 ff ff       	jmp    80105fb7 <alltraps>

8010660a <vector43>:
.globl vector43
vector43:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $43
8010660c:	6a 2b                	push   $0x2b
  jmp alltraps
8010660e:	e9 a4 f9 ff ff       	jmp    80105fb7 <alltraps>

80106613 <vector44>:
.globl vector44
vector44:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $44
80106615:	6a 2c                	push   $0x2c
  jmp alltraps
80106617:	e9 9b f9 ff ff       	jmp    80105fb7 <alltraps>

8010661c <vector45>:
.globl vector45
vector45:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $45
8010661e:	6a 2d                	push   $0x2d
  jmp alltraps
80106620:	e9 92 f9 ff ff       	jmp    80105fb7 <alltraps>

80106625 <vector46>:
.globl vector46
vector46:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $46
80106627:	6a 2e                	push   $0x2e
  jmp alltraps
80106629:	e9 89 f9 ff ff       	jmp    80105fb7 <alltraps>

8010662e <vector47>:
.globl vector47
vector47:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $47
80106630:	6a 2f                	push   $0x2f
  jmp alltraps
80106632:	e9 80 f9 ff ff       	jmp    80105fb7 <alltraps>

80106637 <vector48>:
.globl vector48
vector48:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $48
80106639:	6a 30                	push   $0x30
  jmp alltraps
8010663b:	e9 77 f9 ff ff       	jmp    80105fb7 <alltraps>

80106640 <vector49>:
.globl vector49
vector49:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $49
80106642:	6a 31                	push   $0x31
  jmp alltraps
80106644:	e9 6e f9 ff ff       	jmp    80105fb7 <alltraps>

80106649 <vector50>:
.globl vector50
vector50:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $50
8010664b:	6a 32                	push   $0x32
  jmp alltraps
8010664d:	e9 65 f9 ff ff       	jmp    80105fb7 <alltraps>

80106652 <vector51>:
.globl vector51
vector51:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $51
80106654:	6a 33                	push   $0x33
  jmp alltraps
80106656:	e9 5c f9 ff ff       	jmp    80105fb7 <alltraps>

8010665b <vector52>:
.globl vector52
vector52:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $52
8010665d:	6a 34                	push   $0x34
  jmp alltraps
8010665f:	e9 53 f9 ff ff       	jmp    80105fb7 <alltraps>

80106664 <vector53>:
.globl vector53
vector53:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $53
80106666:	6a 35                	push   $0x35
  jmp alltraps
80106668:	e9 4a f9 ff ff       	jmp    80105fb7 <alltraps>

8010666d <vector54>:
.globl vector54
vector54:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $54
8010666f:	6a 36                	push   $0x36
  jmp alltraps
80106671:	e9 41 f9 ff ff       	jmp    80105fb7 <alltraps>

80106676 <vector55>:
.globl vector55
vector55:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $55
80106678:	6a 37                	push   $0x37
  jmp alltraps
8010667a:	e9 38 f9 ff ff       	jmp    80105fb7 <alltraps>

8010667f <vector56>:
.globl vector56
vector56:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $56
80106681:	6a 38                	push   $0x38
  jmp alltraps
80106683:	e9 2f f9 ff ff       	jmp    80105fb7 <alltraps>

80106688 <vector57>:
.globl vector57
vector57:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $57
8010668a:	6a 39                	push   $0x39
  jmp alltraps
8010668c:	e9 26 f9 ff ff       	jmp    80105fb7 <alltraps>

80106691 <vector58>:
.globl vector58
vector58:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $58
80106693:	6a 3a                	push   $0x3a
  jmp alltraps
80106695:	e9 1d f9 ff ff       	jmp    80105fb7 <alltraps>

8010669a <vector59>:
.globl vector59
vector59:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $59
8010669c:	6a 3b                	push   $0x3b
  jmp alltraps
8010669e:	e9 14 f9 ff ff       	jmp    80105fb7 <alltraps>

801066a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $60
801066a5:	6a 3c                	push   $0x3c
  jmp alltraps
801066a7:	e9 0b f9 ff ff       	jmp    80105fb7 <alltraps>

801066ac <vector61>:
.globl vector61
vector61:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $61
801066ae:	6a 3d                	push   $0x3d
  jmp alltraps
801066b0:	e9 02 f9 ff ff       	jmp    80105fb7 <alltraps>

801066b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $62
801066b7:	6a 3e                	push   $0x3e
  jmp alltraps
801066b9:	e9 f9 f8 ff ff       	jmp    80105fb7 <alltraps>

801066be <vector63>:
.globl vector63
vector63:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $63
801066c0:	6a 3f                	push   $0x3f
  jmp alltraps
801066c2:	e9 f0 f8 ff ff       	jmp    80105fb7 <alltraps>

801066c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $64
801066c9:	6a 40                	push   $0x40
  jmp alltraps
801066cb:	e9 e7 f8 ff ff       	jmp    80105fb7 <alltraps>

801066d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $65
801066d2:	6a 41                	push   $0x41
  jmp alltraps
801066d4:	e9 de f8 ff ff       	jmp    80105fb7 <alltraps>

801066d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $66
801066db:	6a 42                	push   $0x42
  jmp alltraps
801066dd:	e9 d5 f8 ff ff       	jmp    80105fb7 <alltraps>

801066e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $67
801066e4:	6a 43                	push   $0x43
  jmp alltraps
801066e6:	e9 cc f8 ff ff       	jmp    80105fb7 <alltraps>

801066eb <vector68>:
.globl vector68
vector68:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $68
801066ed:	6a 44                	push   $0x44
  jmp alltraps
801066ef:	e9 c3 f8 ff ff       	jmp    80105fb7 <alltraps>

801066f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $69
801066f6:	6a 45                	push   $0x45
  jmp alltraps
801066f8:	e9 ba f8 ff ff       	jmp    80105fb7 <alltraps>

801066fd <vector70>:
.globl vector70
vector70:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $70
801066ff:	6a 46                	push   $0x46
  jmp alltraps
80106701:	e9 b1 f8 ff ff       	jmp    80105fb7 <alltraps>

80106706 <vector71>:
.globl vector71
vector71:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $71
80106708:	6a 47                	push   $0x47
  jmp alltraps
8010670a:	e9 a8 f8 ff ff       	jmp    80105fb7 <alltraps>

8010670f <vector72>:
.globl vector72
vector72:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $72
80106711:	6a 48                	push   $0x48
  jmp alltraps
80106713:	e9 9f f8 ff ff       	jmp    80105fb7 <alltraps>

80106718 <vector73>:
.globl vector73
vector73:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $73
8010671a:	6a 49                	push   $0x49
  jmp alltraps
8010671c:	e9 96 f8 ff ff       	jmp    80105fb7 <alltraps>

80106721 <vector74>:
.globl vector74
vector74:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $74
80106723:	6a 4a                	push   $0x4a
  jmp alltraps
80106725:	e9 8d f8 ff ff       	jmp    80105fb7 <alltraps>

8010672a <vector75>:
.globl vector75
vector75:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $75
8010672c:	6a 4b                	push   $0x4b
  jmp alltraps
8010672e:	e9 84 f8 ff ff       	jmp    80105fb7 <alltraps>

80106733 <vector76>:
.globl vector76
vector76:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $76
80106735:	6a 4c                	push   $0x4c
  jmp alltraps
80106737:	e9 7b f8 ff ff       	jmp    80105fb7 <alltraps>

8010673c <vector77>:
.globl vector77
vector77:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $77
8010673e:	6a 4d                	push   $0x4d
  jmp alltraps
80106740:	e9 72 f8 ff ff       	jmp    80105fb7 <alltraps>

80106745 <vector78>:
.globl vector78
vector78:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $78
80106747:	6a 4e                	push   $0x4e
  jmp alltraps
80106749:	e9 69 f8 ff ff       	jmp    80105fb7 <alltraps>

8010674e <vector79>:
.globl vector79
vector79:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $79
80106750:	6a 4f                	push   $0x4f
  jmp alltraps
80106752:	e9 60 f8 ff ff       	jmp    80105fb7 <alltraps>

80106757 <vector80>:
.globl vector80
vector80:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $80
80106759:	6a 50                	push   $0x50
  jmp alltraps
8010675b:	e9 57 f8 ff ff       	jmp    80105fb7 <alltraps>

80106760 <vector81>:
.globl vector81
vector81:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $81
80106762:	6a 51                	push   $0x51
  jmp alltraps
80106764:	e9 4e f8 ff ff       	jmp    80105fb7 <alltraps>

80106769 <vector82>:
.globl vector82
vector82:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $82
8010676b:	6a 52                	push   $0x52
  jmp alltraps
8010676d:	e9 45 f8 ff ff       	jmp    80105fb7 <alltraps>

80106772 <vector83>:
.globl vector83
vector83:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $83
80106774:	6a 53                	push   $0x53
  jmp alltraps
80106776:	e9 3c f8 ff ff       	jmp    80105fb7 <alltraps>

8010677b <vector84>:
.globl vector84
vector84:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $84
8010677d:	6a 54                	push   $0x54
  jmp alltraps
8010677f:	e9 33 f8 ff ff       	jmp    80105fb7 <alltraps>

80106784 <vector85>:
.globl vector85
vector85:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $85
80106786:	6a 55                	push   $0x55
  jmp alltraps
80106788:	e9 2a f8 ff ff       	jmp    80105fb7 <alltraps>

8010678d <vector86>:
.globl vector86
vector86:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $86
8010678f:	6a 56                	push   $0x56
  jmp alltraps
80106791:	e9 21 f8 ff ff       	jmp    80105fb7 <alltraps>

80106796 <vector87>:
.globl vector87
vector87:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $87
80106798:	6a 57                	push   $0x57
  jmp alltraps
8010679a:	e9 18 f8 ff ff       	jmp    80105fb7 <alltraps>

8010679f <vector88>:
.globl vector88
vector88:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $88
801067a1:	6a 58                	push   $0x58
  jmp alltraps
801067a3:	e9 0f f8 ff ff       	jmp    80105fb7 <alltraps>

801067a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $89
801067aa:	6a 59                	push   $0x59
  jmp alltraps
801067ac:	e9 06 f8 ff ff       	jmp    80105fb7 <alltraps>

801067b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $90
801067b3:	6a 5a                	push   $0x5a
  jmp alltraps
801067b5:	e9 fd f7 ff ff       	jmp    80105fb7 <alltraps>

801067ba <vector91>:
.globl vector91
vector91:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $91
801067bc:	6a 5b                	push   $0x5b
  jmp alltraps
801067be:	e9 f4 f7 ff ff       	jmp    80105fb7 <alltraps>

801067c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $92
801067c5:	6a 5c                	push   $0x5c
  jmp alltraps
801067c7:	e9 eb f7 ff ff       	jmp    80105fb7 <alltraps>

801067cc <vector93>:
.globl vector93
vector93:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $93
801067ce:	6a 5d                	push   $0x5d
  jmp alltraps
801067d0:	e9 e2 f7 ff ff       	jmp    80105fb7 <alltraps>

801067d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $94
801067d7:	6a 5e                	push   $0x5e
  jmp alltraps
801067d9:	e9 d9 f7 ff ff       	jmp    80105fb7 <alltraps>

801067de <vector95>:
.globl vector95
vector95:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $95
801067e0:	6a 5f                	push   $0x5f
  jmp alltraps
801067e2:	e9 d0 f7 ff ff       	jmp    80105fb7 <alltraps>

801067e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $96
801067e9:	6a 60                	push   $0x60
  jmp alltraps
801067eb:	e9 c7 f7 ff ff       	jmp    80105fb7 <alltraps>

801067f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $97
801067f2:	6a 61                	push   $0x61
  jmp alltraps
801067f4:	e9 be f7 ff ff       	jmp    80105fb7 <alltraps>

801067f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $98
801067fb:	6a 62                	push   $0x62
  jmp alltraps
801067fd:	e9 b5 f7 ff ff       	jmp    80105fb7 <alltraps>

80106802 <vector99>:
.globl vector99
vector99:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $99
80106804:	6a 63                	push   $0x63
  jmp alltraps
80106806:	e9 ac f7 ff ff       	jmp    80105fb7 <alltraps>

8010680b <vector100>:
.globl vector100
vector100:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $100
8010680d:	6a 64                	push   $0x64
  jmp alltraps
8010680f:	e9 a3 f7 ff ff       	jmp    80105fb7 <alltraps>

80106814 <vector101>:
.globl vector101
vector101:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $101
80106816:	6a 65                	push   $0x65
  jmp alltraps
80106818:	e9 9a f7 ff ff       	jmp    80105fb7 <alltraps>

8010681d <vector102>:
.globl vector102
vector102:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $102
8010681f:	6a 66                	push   $0x66
  jmp alltraps
80106821:	e9 91 f7 ff ff       	jmp    80105fb7 <alltraps>

80106826 <vector103>:
.globl vector103
vector103:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $103
80106828:	6a 67                	push   $0x67
  jmp alltraps
8010682a:	e9 88 f7 ff ff       	jmp    80105fb7 <alltraps>

8010682f <vector104>:
.globl vector104
vector104:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $104
80106831:	6a 68                	push   $0x68
  jmp alltraps
80106833:	e9 7f f7 ff ff       	jmp    80105fb7 <alltraps>

80106838 <vector105>:
.globl vector105
vector105:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $105
8010683a:	6a 69                	push   $0x69
  jmp alltraps
8010683c:	e9 76 f7 ff ff       	jmp    80105fb7 <alltraps>

80106841 <vector106>:
.globl vector106
vector106:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $106
80106843:	6a 6a                	push   $0x6a
  jmp alltraps
80106845:	e9 6d f7 ff ff       	jmp    80105fb7 <alltraps>

8010684a <vector107>:
.globl vector107
vector107:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $107
8010684c:	6a 6b                	push   $0x6b
  jmp alltraps
8010684e:	e9 64 f7 ff ff       	jmp    80105fb7 <alltraps>

80106853 <vector108>:
.globl vector108
vector108:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $108
80106855:	6a 6c                	push   $0x6c
  jmp alltraps
80106857:	e9 5b f7 ff ff       	jmp    80105fb7 <alltraps>

8010685c <vector109>:
.globl vector109
vector109:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $109
8010685e:	6a 6d                	push   $0x6d
  jmp alltraps
80106860:	e9 52 f7 ff ff       	jmp    80105fb7 <alltraps>

80106865 <vector110>:
.globl vector110
vector110:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $110
80106867:	6a 6e                	push   $0x6e
  jmp alltraps
80106869:	e9 49 f7 ff ff       	jmp    80105fb7 <alltraps>

8010686e <vector111>:
.globl vector111
vector111:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $111
80106870:	6a 6f                	push   $0x6f
  jmp alltraps
80106872:	e9 40 f7 ff ff       	jmp    80105fb7 <alltraps>

80106877 <vector112>:
.globl vector112
vector112:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $112
80106879:	6a 70                	push   $0x70
  jmp alltraps
8010687b:	e9 37 f7 ff ff       	jmp    80105fb7 <alltraps>

80106880 <vector113>:
.globl vector113
vector113:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $113
80106882:	6a 71                	push   $0x71
  jmp alltraps
80106884:	e9 2e f7 ff ff       	jmp    80105fb7 <alltraps>

80106889 <vector114>:
.globl vector114
vector114:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $114
8010688b:	6a 72                	push   $0x72
  jmp alltraps
8010688d:	e9 25 f7 ff ff       	jmp    80105fb7 <alltraps>

80106892 <vector115>:
.globl vector115
vector115:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $115
80106894:	6a 73                	push   $0x73
  jmp alltraps
80106896:	e9 1c f7 ff ff       	jmp    80105fb7 <alltraps>

8010689b <vector116>:
.globl vector116
vector116:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $116
8010689d:	6a 74                	push   $0x74
  jmp alltraps
8010689f:	e9 13 f7 ff ff       	jmp    80105fb7 <alltraps>

801068a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $117
801068a6:	6a 75                	push   $0x75
  jmp alltraps
801068a8:	e9 0a f7 ff ff       	jmp    80105fb7 <alltraps>

801068ad <vector118>:
.globl vector118
vector118:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $118
801068af:	6a 76                	push   $0x76
  jmp alltraps
801068b1:	e9 01 f7 ff ff       	jmp    80105fb7 <alltraps>

801068b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $119
801068b8:	6a 77                	push   $0x77
  jmp alltraps
801068ba:	e9 f8 f6 ff ff       	jmp    80105fb7 <alltraps>

801068bf <vector120>:
.globl vector120
vector120:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $120
801068c1:	6a 78                	push   $0x78
  jmp alltraps
801068c3:	e9 ef f6 ff ff       	jmp    80105fb7 <alltraps>

801068c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $121
801068ca:	6a 79                	push   $0x79
  jmp alltraps
801068cc:	e9 e6 f6 ff ff       	jmp    80105fb7 <alltraps>

801068d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $122
801068d3:	6a 7a                	push   $0x7a
  jmp alltraps
801068d5:	e9 dd f6 ff ff       	jmp    80105fb7 <alltraps>

801068da <vector123>:
.globl vector123
vector123:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $123
801068dc:	6a 7b                	push   $0x7b
  jmp alltraps
801068de:	e9 d4 f6 ff ff       	jmp    80105fb7 <alltraps>

801068e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $124
801068e5:	6a 7c                	push   $0x7c
  jmp alltraps
801068e7:	e9 cb f6 ff ff       	jmp    80105fb7 <alltraps>

801068ec <vector125>:
.globl vector125
vector125:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $125
801068ee:	6a 7d                	push   $0x7d
  jmp alltraps
801068f0:	e9 c2 f6 ff ff       	jmp    80105fb7 <alltraps>

801068f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $126
801068f7:	6a 7e                	push   $0x7e
  jmp alltraps
801068f9:	e9 b9 f6 ff ff       	jmp    80105fb7 <alltraps>

801068fe <vector127>:
.globl vector127
vector127:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $127
80106900:	6a 7f                	push   $0x7f
  jmp alltraps
80106902:	e9 b0 f6 ff ff       	jmp    80105fb7 <alltraps>

80106907 <vector128>:
.globl vector128
vector128:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $128
80106909:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010690e:	e9 a4 f6 ff ff       	jmp    80105fb7 <alltraps>

80106913 <vector129>:
.globl vector129
vector129:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $129
80106915:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010691a:	e9 98 f6 ff ff       	jmp    80105fb7 <alltraps>

8010691f <vector130>:
.globl vector130
vector130:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $130
80106921:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106926:	e9 8c f6 ff ff       	jmp    80105fb7 <alltraps>

8010692b <vector131>:
.globl vector131
vector131:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $131
8010692d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106932:	e9 80 f6 ff ff       	jmp    80105fb7 <alltraps>

80106937 <vector132>:
.globl vector132
vector132:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $132
80106939:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010693e:	e9 74 f6 ff ff       	jmp    80105fb7 <alltraps>

80106943 <vector133>:
.globl vector133
vector133:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $133
80106945:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010694a:	e9 68 f6 ff ff       	jmp    80105fb7 <alltraps>

8010694f <vector134>:
.globl vector134
vector134:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $134
80106951:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106956:	e9 5c f6 ff ff       	jmp    80105fb7 <alltraps>

8010695b <vector135>:
.globl vector135
vector135:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $135
8010695d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106962:	e9 50 f6 ff ff       	jmp    80105fb7 <alltraps>

80106967 <vector136>:
.globl vector136
vector136:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $136
80106969:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010696e:	e9 44 f6 ff ff       	jmp    80105fb7 <alltraps>

80106973 <vector137>:
.globl vector137
vector137:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $137
80106975:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010697a:	e9 38 f6 ff ff       	jmp    80105fb7 <alltraps>

8010697f <vector138>:
.globl vector138
vector138:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $138
80106981:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106986:	e9 2c f6 ff ff       	jmp    80105fb7 <alltraps>

8010698b <vector139>:
.globl vector139
vector139:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $139
8010698d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106992:	e9 20 f6 ff ff       	jmp    80105fb7 <alltraps>

80106997 <vector140>:
.globl vector140
vector140:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $140
80106999:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010699e:	e9 14 f6 ff ff       	jmp    80105fb7 <alltraps>

801069a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $141
801069a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801069aa:	e9 08 f6 ff ff       	jmp    80105fb7 <alltraps>

801069af <vector142>:
.globl vector142
vector142:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $142
801069b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801069b6:	e9 fc f5 ff ff       	jmp    80105fb7 <alltraps>

801069bb <vector143>:
.globl vector143
vector143:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $143
801069bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801069c2:	e9 f0 f5 ff ff       	jmp    80105fb7 <alltraps>

801069c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $144
801069c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801069ce:	e9 e4 f5 ff ff       	jmp    80105fb7 <alltraps>

801069d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $145
801069d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801069da:	e9 d8 f5 ff ff       	jmp    80105fb7 <alltraps>

801069df <vector146>:
.globl vector146
vector146:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $146
801069e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801069e6:	e9 cc f5 ff ff       	jmp    80105fb7 <alltraps>

801069eb <vector147>:
.globl vector147
vector147:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $147
801069ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801069f2:	e9 c0 f5 ff ff       	jmp    80105fb7 <alltraps>

801069f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $148
801069f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801069fe:	e9 b4 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a03 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $149
80106a05:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a0a:	e9 a8 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a0f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $150
80106a11:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a16:	e9 9c f5 ff ff       	jmp    80105fb7 <alltraps>

80106a1b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $151
80106a1d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a22:	e9 90 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a27 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $152
80106a29:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a2e:	e9 84 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a33 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $153
80106a35:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a3a:	e9 78 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a3f <vector154>:
.globl vector154
vector154:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $154
80106a41:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a46:	e9 6c f5 ff ff       	jmp    80105fb7 <alltraps>

80106a4b <vector155>:
.globl vector155
vector155:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $155
80106a4d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a52:	e9 60 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a57 <vector156>:
.globl vector156
vector156:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $156
80106a59:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a5e:	e9 54 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a63 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $157
80106a65:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a6a:	e9 48 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a6f <vector158>:
.globl vector158
vector158:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $158
80106a71:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a76:	e9 3c f5 ff ff       	jmp    80105fb7 <alltraps>

80106a7b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $159
80106a7d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a82:	e9 30 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a87 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $160
80106a89:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a8e:	e9 24 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a93 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $161
80106a95:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a9a:	e9 18 f5 ff ff       	jmp    80105fb7 <alltraps>

80106a9f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $162
80106aa1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106aa6:	e9 0c f5 ff ff       	jmp    80105fb7 <alltraps>

80106aab <vector163>:
.globl vector163
vector163:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $163
80106aad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ab2:	e9 00 f5 ff ff       	jmp    80105fb7 <alltraps>

80106ab7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $164
80106ab9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106abe:	e9 f4 f4 ff ff       	jmp    80105fb7 <alltraps>

80106ac3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $165
80106ac5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106aca:	e9 e8 f4 ff ff       	jmp    80105fb7 <alltraps>

80106acf <vector166>:
.globl vector166
vector166:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $166
80106ad1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ad6:	e9 dc f4 ff ff       	jmp    80105fb7 <alltraps>

80106adb <vector167>:
.globl vector167
vector167:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $167
80106add:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ae2:	e9 d0 f4 ff ff       	jmp    80105fb7 <alltraps>

80106ae7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $168
80106ae9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106aee:	e9 c4 f4 ff ff       	jmp    80105fb7 <alltraps>

80106af3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $169
80106af5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106afa:	e9 b8 f4 ff ff       	jmp    80105fb7 <alltraps>

80106aff <vector170>:
.globl vector170
vector170:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $170
80106b01:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b06:	e9 ac f4 ff ff       	jmp    80105fb7 <alltraps>

80106b0b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $171
80106b0d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b12:	e9 a0 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b17 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $172
80106b19:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b1e:	e9 94 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b23 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $173
80106b25:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b2a:	e9 88 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b2f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $174
80106b31:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b36:	e9 7c f4 ff ff       	jmp    80105fb7 <alltraps>

80106b3b <vector175>:
.globl vector175
vector175:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $175
80106b3d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b42:	e9 70 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b47 <vector176>:
.globl vector176
vector176:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $176
80106b49:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b4e:	e9 64 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b53 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $177
80106b55:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b5a:	e9 58 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b5f <vector178>:
.globl vector178
vector178:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $178
80106b61:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b66:	e9 4c f4 ff ff       	jmp    80105fb7 <alltraps>

80106b6b <vector179>:
.globl vector179
vector179:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $179
80106b6d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b72:	e9 40 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b77 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $180
80106b79:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b7e:	e9 34 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b83 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $181
80106b85:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b8a:	e9 28 f4 ff ff       	jmp    80105fb7 <alltraps>

80106b8f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $182
80106b91:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b96:	e9 1c f4 ff ff       	jmp    80105fb7 <alltraps>

80106b9b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $183
80106b9d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ba2:	e9 10 f4 ff ff       	jmp    80105fb7 <alltraps>

80106ba7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $184
80106ba9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106bae:	e9 04 f4 ff ff       	jmp    80105fb7 <alltraps>

80106bb3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $185
80106bb5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106bba:	e9 f8 f3 ff ff       	jmp    80105fb7 <alltraps>

80106bbf <vector186>:
.globl vector186
vector186:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $186
80106bc1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106bc6:	e9 ec f3 ff ff       	jmp    80105fb7 <alltraps>

80106bcb <vector187>:
.globl vector187
vector187:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $187
80106bcd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106bd2:	e9 e0 f3 ff ff       	jmp    80105fb7 <alltraps>

80106bd7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $188
80106bd9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106bde:	e9 d4 f3 ff ff       	jmp    80105fb7 <alltraps>

80106be3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $189
80106be5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106bea:	e9 c8 f3 ff ff       	jmp    80105fb7 <alltraps>

80106bef <vector190>:
.globl vector190
vector190:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $190
80106bf1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106bf6:	e9 bc f3 ff ff       	jmp    80105fb7 <alltraps>

80106bfb <vector191>:
.globl vector191
vector191:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $191
80106bfd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c02:	e9 b0 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c07 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $192
80106c09:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c0e:	e9 a4 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c13 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $193
80106c15:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c1a:	e9 98 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c1f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $194
80106c21:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c26:	e9 8c f3 ff ff       	jmp    80105fb7 <alltraps>

80106c2b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $195
80106c2d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c32:	e9 80 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c37 <vector196>:
.globl vector196
vector196:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $196
80106c39:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c3e:	e9 74 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c43 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $197
80106c45:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c4a:	e9 68 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c4f <vector198>:
.globl vector198
vector198:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $198
80106c51:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c56:	e9 5c f3 ff ff       	jmp    80105fb7 <alltraps>

80106c5b <vector199>:
.globl vector199
vector199:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $199
80106c5d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c62:	e9 50 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c67 <vector200>:
.globl vector200
vector200:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $200
80106c69:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c6e:	e9 44 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c73 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $201
80106c75:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c7a:	e9 38 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c7f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $202
80106c81:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c86:	e9 2c f3 ff ff       	jmp    80105fb7 <alltraps>

80106c8b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $203
80106c8d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c92:	e9 20 f3 ff ff       	jmp    80105fb7 <alltraps>

80106c97 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $204
80106c99:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c9e:	e9 14 f3 ff ff       	jmp    80105fb7 <alltraps>

80106ca3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $205
80106ca5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106caa:	e9 08 f3 ff ff       	jmp    80105fb7 <alltraps>

80106caf <vector206>:
.globl vector206
vector206:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $206
80106cb1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106cb6:	e9 fc f2 ff ff       	jmp    80105fb7 <alltraps>

80106cbb <vector207>:
.globl vector207
vector207:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $207
80106cbd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106cc2:	e9 f0 f2 ff ff       	jmp    80105fb7 <alltraps>

80106cc7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $208
80106cc9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106cce:	e9 e4 f2 ff ff       	jmp    80105fb7 <alltraps>

80106cd3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $209
80106cd5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106cda:	e9 d8 f2 ff ff       	jmp    80105fb7 <alltraps>

80106cdf <vector210>:
.globl vector210
vector210:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $210
80106ce1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ce6:	e9 cc f2 ff ff       	jmp    80105fb7 <alltraps>

80106ceb <vector211>:
.globl vector211
vector211:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $211
80106ced:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106cf2:	e9 c0 f2 ff ff       	jmp    80105fb7 <alltraps>

80106cf7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $212
80106cf9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106cfe:	e9 b4 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d03 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $213
80106d05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d0a:	e9 a8 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d0f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $214
80106d11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d16:	e9 9c f2 ff ff       	jmp    80105fb7 <alltraps>

80106d1b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $215
80106d1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d22:	e9 90 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d27 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $216
80106d29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d2e:	e9 84 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d33 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $217
80106d35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d3a:	e9 78 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d3f <vector218>:
.globl vector218
vector218:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $218
80106d41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d46:	e9 6c f2 ff ff       	jmp    80105fb7 <alltraps>

80106d4b <vector219>:
.globl vector219
vector219:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $219
80106d4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d52:	e9 60 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d57 <vector220>:
.globl vector220
vector220:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $220
80106d59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d5e:	e9 54 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d63 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $221
80106d65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d6a:	e9 48 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d6f <vector222>:
.globl vector222
vector222:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $222
80106d71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d76:	e9 3c f2 ff ff       	jmp    80105fb7 <alltraps>

80106d7b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $223
80106d7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d82:	e9 30 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d87 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $224
80106d89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d8e:	e9 24 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d93 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $225
80106d95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d9a:	e9 18 f2 ff ff       	jmp    80105fb7 <alltraps>

80106d9f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $226
80106da1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106da6:	e9 0c f2 ff ff       	jmp    80105fb7 <alltraps>

80106dab <vector227>:
.globl vector227
vector227:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $227
80106dad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106db2:	e9 00 f2 ff ff       	jmp    80105fb7 <alltraps>

80106db7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $228
80106db9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106dbe:	e9 f4 f1 ff ff       	jmp    80105fb7 <alltraps>

80106dc3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $229
80106dc5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106dca:	e9 e8 f1 ff ff       	jmp    80105fb7 <alltraps>

80106dcf <vector230>:
.globl vector230
vector230:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $230
80106dd1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106dd6:	e9 dc f1 ff ff       	jmp    80105fb7 <alltraps>

80106ddb <vector231>:
.globl vector231
vector231:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $231
80106ddd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106de2:	e9 d0 f1 ff ff       	jmp    80105fb7 <alltraps>

80106de7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $232
80106de9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106dee:	e9 c4 f1 ff ff       	jmp    80105fb7 <alltraps>

80106df3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $233
80106df5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106dfa:	e9 b8 f1 ff ff       	jmp    80105fb7 <alltraps>

80106dff <vector234>:
.globl vector234
vector234:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $234
80106e01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e06:	e9 ac f1 ff ff       	jmp    80105fb7 <alltraps>

80106e0b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $235
80106e0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e12:	e9 a0 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e17 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $236
80106e19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e1e:	e9 94 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e23 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $237
80106e25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e2a:	e9 88 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e2f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $238
80106e31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e36:	e9 7c f1 ff ff       	jmp    80105fb7 <alltraps>

80106e3b <vector239>:
.globl vector239
vector239:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $239
80106e3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e42:	e9 70 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e47 <vector240>:
.globl vector240
vector240:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $240
80106e49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e4e:	e9 64 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e53 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $241
80106e55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e5a:	e9 58 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e5f <vector242>:
.globl vector242
vector242:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $242
80106e61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e66:	e9 4c f1 ff ff       	jmp    80105fb7 <alltraps>

80106e6b <vector243>:
.globl vector243
vector243:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $243
80106e6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e72:	e9 40 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e77 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $244
80106e79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e7e:	e9 34 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e83 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $245
80106e85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e8a:	e9 28 f1 ff ff       	jmp    80105fb7 <alltraps>

80106e8f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $246
80106e91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e96:	e9 1c f1 ff ff       	jmp    80105fb7 <alltraps>

80106e9b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $247
80106e9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ea2:	e9 10 f1 ff ff       	jmp    80105fb7 <alltraps>

80106ea7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $248
80106ea9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106eae:	e9 04 f1 ff ff       	jmp    80105fb7 <alltraps>

80106eb3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $249
80106eb5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106eba:	e9 f8 f0 ff ff       	jmp    80105fb7 <alltraps>

80106ebf <vector250>:
.globl vector250
vector250:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $250
80106ec1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ec6:	e9 ec f0 ff ff       	jmp    80105fb7 <alltraps>

80106ecb <vector251>:
.globl vector251
vector251:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $251
80106ecd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ed2:	e9 e0 f0 ff ff       	jmp    80105fb7 <alltraps>

80106ed7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $252
80106ed9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ede:	e9 d4 f0 ff ff       	jmp    80105fb7 <alltraps>

80106ee3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $253
80106ee5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106eea:	e9 c8 f0 ff ff       	jmp    80105fb7 <alltraps>

80106eef <vector254>:
.globl vector254
vector254:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $254
80106ef1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ef6:	e9 bc f0 ff ff       	jmp    80105fb7 <alltraps>

80106efb <vector255>:
.globl vector255
vector255:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $255
80106efd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f02:	e9 b0 f0 ff ff       	jmp    80105fb7 <alltraps>
80106f07:	66 90                	xchg   %ax,%ax
80106f09:	66 90                	xchg   %ax,%ax
80106f0b:	66 90                	xchg   %ax,%ax
80106f0d:	66 90                	xchg   %ax,%ax
80106f0f:	90                   	nop

80106f10 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106f16:	89 d3                	mov    %edx,%ebx
{
80106f18:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106f1a:	c1 eb 16             	shr    $0x16,%ebx
80106f1d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106f20:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106f23:	8b 06                	mov    (%esi),%eax
80106f25:	a8 01                	test   $0x1,%al
80106f27:	74 27                	je     80106f50 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f2e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106f34:	c1 ef 0a             	shr    $0xa,%edi
}
80106f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106f3a:	89 fa                	mov    %edi,%edx
80106f3c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106f42:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5f                   	pop    %edi
80106f48:	5d                   	pop    %ebp
80106f49:	c3                   	ret    
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f50:	85 c9                	test   %ecx,%ecx
80106f52:	74 2c                	je     80106f80 <walkpgdir+0x70>
80106f54:	e8 97 b5 ff ff       	call   801024f0 <kalloc>
80106f59:	85 c0                	test   %eax,%eax
80106f5b:	89 c3                	mov    %eax,%ebx
80106f5d:	74 21                	je     80106f80 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106f5f:	83 ec 04             	sub    $0x4,%esp
80106f62:	68 00 10 00 00       	push   $0x1000
80106f67:	6a 00                	push   $0x0
80106f69:	50                   	push   %eax
80106f6a:	e8 b1 dd ff ff       	call   80104d20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f6f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f75:	83 c4 10             	add    $0x10,%esp
80106f78:	83 c8 07             	or     $0x7,%eax
80106f7b:	89 06                	mov    %eax,(%esi)
80106f7d:	eb b5                	jmp    80106f34 <walkpgdir+0x24>
80106f7f:	90                   	nop
}
80106f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106f83:	31 c0                	xor    %eax,%eax
}
80106f85:	5b                   	pop    %ebx
80106f86:	5e                   	pop    %esi
80106f87:	5f                   	pop    %edi
80106f88:	5d                   	pop    %ebp
80106f89:	c3                   	ret    
80106f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f90 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106f96:	89 d3                	mov    %edx,%ebx
80106f98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f9e:	83 ec 1c             	sub    $0x1c,%esp
80106fa1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106fa4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106fa8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fb6:	29 df                	sub    %ebx,%edi
80106fb8:	83 c8 01             	or     $0x1,%eax
80106fbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106fbe:	eb 15                	jmp    80106fd5 <mappages+0x45>
    if(*pte & PTE_P)
80106fc0:	f6 00 01             	testb  $0x1,(%eax)
80106fc3:	75 45                	jne    8010700a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106fc5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106fc8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106fcb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106fcd:	74 31                	je     80107000 <mappages+0x70>
      break;
    a += PGSIZE;
80106fcf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fd8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106fdd:	89 da                	mov    %ebx,%edx
80106fdf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106fe2:	e8 29 ff ff ff       	call   80106f10 <walkpgdir>
80106fe7:	85 c0                	test   %eax,%eax
80106fe9:	75 d5                	jne    80106fc0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ff3:	5b                   	pop    %ebx
80106ff4:	5e                   	pop    %esi
80106ff5:	5f                   	pop    %edi
80106ff6:	5d                   	pop    %ebp
80106ff7:	c3                   	ret    
80106ff8:	90                   	nop
80106ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107000:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107003:	31 c0                	xor    %eax,%eax
}
80107005:	5b                   	pop    %ebx
80107006:	5e                   	pop    %esi
80107007:	5f                   	pop    %edi
80107008:	5d                   	pop    %ebp
80107009:	c3                   	ret    
      panic("remap");
8010700a:	83 ec 0c             	sub    $0xc,%esp
8010700d:	68 d8 81 10 80       	push   $0x801081d8
80107012:	e8 79 93 ff ff       	call   80100390 <panic>
80107017:	89 f6                	mov    %esi,%esi
80107019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107020 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107026:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010702c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010702e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107034:	83 ec 1c             	sub    $0x1c,%esp
80107037:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010703a:	39 d3                	cmp    %edx,%ebx
8010703c:	73 66                	jae    801070a4 <deallocuvm.part.0+0x84>
8010703e:	89 d6                	mov    %edx,%esi
80107040:	eb 3d                	jmp    8010707f <deallocuvm.part.0+0x5f>
80107042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107048:	8b 10                	mov    (%eax),%edx
8010704a:	f6 c2 01             	test   $0x1,%dl
8010704d:	74 26                	je     80107075 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010704f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107055:	74 58                	je     801070af <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107057:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010705a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107060:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107063:	52                   	push   %edx
80107064:	e8 d7 b2 ff ff       	call   80102340 <kfree>
      *pte = 0;
80107069:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010706c:	83 c4 10             	add    $0x10,%esp
8010706f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107075:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010707b:	39 f3                	cmp    %esi,%ebx
8010707d:	73 25                	jae    801070a4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010707f:	31 c9                	xor    %ecx,%ecx
80107081:	89 da                	mov    %ebx,%edx
80107083:	89 f8                	mov    %edi,%eax
80107085:	e8 86 fe ff ff       	call   80106f10 <walkpgdir>
    if(!pte)
8010708a:	85 c0                	test   %eax,%eax
8010708c:	75 ba                	jne    80107048 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010708e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107094:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010709a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070a0:	39 f3                	cmp    %esi,%ebx
801070a2:	72 db                	jb     8010707f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801070a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070aa:	5b                   	pop    %ebx
801070ab:	5e                   	pop    %esi
801070ac:	5f                   	pop    %edi
801070ad:	5d                   	pop    %ebp
801070ae:	c3                   	ret    
        panic("kfree");
801070af:	83 ec 0c             	sub    $0xc,%esp
801070b2:	68 c6 7a 10 80       	push   $0x80107ac6
801070b7:	e8 d4 92 ff ff       	call   80100390 <panic>
801070bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070c0 <seginit>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801070c6:	e8 15 c8 ff ff       	call   801038e0 <cpuid>
801070cb:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
801070d1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070d6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070da:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
801070e1:	ff 00 00 
801070e4:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
801070eb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070ee:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
801070f5:	ff 00 00 
801070f8:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
801070ff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107102:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107109:	ff 00 00 
8010710c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107113:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107116:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010711d:	ff 00 00 
80107120:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107127:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010712a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010712f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107133:	c1 e8 10             	shr    $0x10,%eax
80107136:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010713a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010713d:	0f 01 10             	lgdtl  (%eax)
}
80107140:	c9                   	leave  
80107141:	c3                   	ret    
80107142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107150 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107150:	a1 e4 34 12 80       	mov    0x801234e4,%eax
{
80107155:	55                   	push   %ebp
80107156:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107158:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010715d:	0f 22 d8             	mov    %eax,%cr3
}
80107160:	5d                   	pop    %ebp
80107161:	c3                   	ret    
80107162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107170 <switchuvm>:
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 1c             	sub    $0x1c,%esp
80107179:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010717c:	85 db                	test   %ebx,%ebx
8010717e:	0f 84 d7 00 00 00    	je     8010725b <switchuvm+0xeb>
  if(p->mainThread->tkstack == 0)
80107184:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
8010718a:	8b 40 04             	mov    0x4(%eax),%eax
8010718d:	85 c0                	test   %eax,%eax
8010718f:	0f 84 e0 00 00 00    	je     80107275 <switchuvm+0x105>
  if(p->pgdir == 0)
80107195:	8b 43 04             	mov    0x4(%ebx),%eax
80107198:	85 c0                	test   %eax,%eax
8010719a:	0f 84 c8 00 00 00    	je     80107268 <switchuvm+0xf8>
  pushcli();
801071a0:	e8 8b d9 ff ff       	call   80104b30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071a5:	e8 b6 c6 ff ff       	call   80103860 <mycpu>
801071aa:	89 c6                	mov    %eax,%esi
801071ac:	e8 af c6 ff ff       	call   80103860 <mycpu>
801071b1:	89 c7                	mov    %eax,%edi
801071b3:	e8 a8 c6 ff ff       	call   80103860 <mycpu>
801071b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071bb:	83 c7 08             	add    $0x8,%edi
801071be:	e8 9d c6 ff ff       	call   80103860 <mycpu>
801071c3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071c6:	83 c0 08             	add    $0x8,%eax
801071c9:	ba 67 00 00 00       	mov    $0x67,%edx
801071ce:	c1 e8 18             	shr    $0x18,%eax
801071d1:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801071d8:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801071df:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071e5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071ea:	83 c1 08             	add    $0x8,%ecx
801071ed:	c1 e9 10             	shr    $0x10,%ecx
801071f0:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801071f6:	b9 99 40 00 00       	mov    $0x4099,%ecx
801071fb:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107202:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107207:	e8 54 c6 ff ff       	call   80103860 <mycpu>
8010720c:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107213:	e8 48 c6 ff ff       	call   80103860 <mycpu>
80107218:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
8010721c:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80107222:	8b 70 04             	mov    0x4(%eax),%esi
80107225:	e8 36 c6 ff ff       	call   80103860 <mycpu>
8010722a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107230:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107233:	e8 28 c6 ff ff       	call   80103860 <mycpu>
80107238:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010723c:	b8 28 00 00 00       	mov    $0x28,%eax
80107241:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107244:	8b 43 04             	mov    0x4(%ebx),%eax
80107247:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010724c:	0f 22 d8             	mov    %eax,%cr3
}
8010724f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107252:	5b                   	pop    %ebx
80107253:	5e                   	pop    %esi
80107254:	5f                   	pop    %edi
80107255:	5d                   	pop    %ebp
  popcli();
80107256:	e9 15 d9 ff ff       	jmp    80104b70 <popcli>
    panic("switchuvm: no process");
8010725b:	83 ec 0c             	sub    $0xc,%esp
8010725e:	68 de 81 10 80       	push   $0x801081de
80107263:	e8 28 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107268:	83 ec 0c             	sub    $0xc,%esp
8010726b:	68 09 82 10 80       	push   $0x80108209
80107270:	e8 1b 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107275:	83 ec 0c             	sub    $0xc,%esp
80107278:	68 f4 81 10 80       	push   $0x801081f4
8010727d:	e8 0e 91 ff ff       	call   80100390 <panic>
80107282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107290 <inituvm>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 1c             	sub    $0x1c,%esp
80107299:	8b 75 10             	mov    0x10(%ebp),%esi
8010729c:	8b 45 08             	mov    0x8(%ebp),%eax
8010729f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801072a2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801072a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801072ab:	77 49                	ja     801072f6 <inituvm+0x66>
  mem = kalloc();
801072ad:	e8 3e b2 ff ff       	call   801024f0 <kalloc>
  memset(mem, 0, PGSIZE);
801072b2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801072b5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801072b7:	68 00 10 00 00       	push   $0x1000
801072bc:	6a 00                	push   $0x0
801072be:	50                   	push   %eax
801072bf:	e8 5c da ff ff       	call   80104d20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801072c4:	58                   	pop    %eax
801072c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072cb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072d0:	5a                   	pop    %edx
801072d1:	6a 06                	push   $0x6
801072d3:	50                   	push   %eax
801072d4:	31 d2                	xor    %edx,%edx
801072d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d9:	e8 b2 fc ff ff       	call   80106f90 <mappages>
  memmove(mem, init, sz);
801072de:	89 75 10             	mov    %esi,0x10(%ebp)
801072e1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801072e4:	83 c4 10             	add    $0x10,%esp
801072e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801072ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ed:	5b                   	pop    %ebx
801072ee:	5e                   	pop    %esi
801072ef:	5f                   	pop    %edi
801072f0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801072f1:	e9 da da ff ff       	jmp    80104dd0 <memmove>
    panic("inituvm: more than a page");
801072f6:	83 ec 0c             	sub    $0xc,%esp
801072f9:	68 1d 82 10 80       	push   $0x8010821d
801072fe:	e8 8d 90 ff ff       	call   80100390 <panic>
80107303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107310 <loaduvm>:
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	57                   	push   %edi
80107314:	56                   	push   %esi
80107315:	53                   	push   %ebx
80107316:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107319:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107320:	0f 85 91 00 00 00    	jne    801073b7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107326:	8b 75 18             	mov    0x18(%ebp),%esi
80107329:	31 db                	xor    %ebx,%ebx
8010732b:	85 f6                	test   %esi,%esi
8010732d:	75 1a                	jne    80107349 <loaduvm+0x39>
8010732f:	eb 6f                	jmp    801073a0 <loaduvm+0x90>
80107331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107338:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010733e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107344:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107347:	76 57                	jbe    801073a0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107349:	8b 55 0c             	mov    0xc(%ebp),%edx
8010734c:	8b 45 08             	mov    0x8(%ebp),%eax
8010734f:	31 c9                	xor    %ecx,%ecx
80107351:	01 da                	add    %ebx,%edx
80107353:	e8 b8 fb ff ff       	call   80106f10 <walkpgdir>
80107358:	85 c0                	test   %eax,%eax
8010735a:	74 4e                	je     801073aa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010735c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010735e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107361:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107366:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010736b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107371:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107374:	01 d9                	add    %ebx,%ecx
80107376:	05 00 00 00 80       	add    $0x80000000,%eax
8010737b:	57                   	push   %edi
8010737c:	51                   	push   %ecx
8010737d:	50                   	push   %eax
8010737e:	ff 75 10             	pushl  0x10(%ebp)
80107381:	e8 0a a6 ff ff       	call   80101990 <readi>
80107386:	83 c4 10             	add    $0x10,%esp
80107389:	39 f8                	cmp    %edi,%eax
8010738b:	74 ab                	je     80107338 <loaduvm+0x28>
}
8010738d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107395:	5b                   	pop    %ebx
80107396:	5e                   	pop    %esi
80107397:	5f                   	pop    %edi
80107398:	5d                   	pop    %ebp
80107399:	c3                   	ret    
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073a3:	31 c0                	xor    %eax,%eax
}
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5f                   	pop    %edi
801073a8:	5d                   	pop    %ebp
801073a9:	c3                   	ret    
      panic("loaduvm: address should exist");
801073aa:	83 ec 0c             	sub    $0xc,%esp
801073ad:	68 37 82 10 80       	push   $0x80108237
801073b2:	e8 d9 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801073b7:	83 ec 0c             	sub    $0xc,%esp
801073ba:	68 d8 82 10 80       	push   $0x801082d8
801073bf:	e8 cc 8f ff ff       	call   80100390 <panic>
801073c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801073d0 <allocuvm>:
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801073d9:	8b 7d 10             	mov    0x10(%ebp),%edi
801073dc:	85 ff                	test   %edi,%edi
801073de:	0f 88 8e 00 00 00    	js     80107472 <allocuvm+0xa2>
  if(newsz < oldsz)
801073e4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801073e7:	0f 82 93 00 00 00    	jb     80107480 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801073ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801073f6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801073fc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801073ff:	0f 86 7e 00 00 00    	jbe    80107483 <allocuvm+0xb3>
80107405:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107408:	8b 7d 08             	mov    0x8(%ebp),%edi
8010740b:	eb 42                	jmp    8010744f <allocuvm+0x7f>
8010740d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107410:	83 ec 04             	sub    $0x4,%esp
80107413:	68 00 10 00 00       	push   $0x1000
80107418:	6a 00                	push   $0x0
8010741a:	50                   	push   %eax
8010741b:	e8 00 d9 ff ff       	call   80104d20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107420:	58                   	pop    %eax
80107421:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107427:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010742c:	5a                   	pop    %edx
8010742d:	6a 06                	push   $0x6
8010742f:	50                   	push   %eax
80107430:	89 da                	mov    %ebx,%edx
80107432:	89 f8                	mov    %edi,%eax
80107434:	e8 57 fb ff ff       	call   80106f90 <mappages>
80107439:	83 c4 10             	add    $0x10,%esp
8010743c:	85 c0                	test   %eax,%eax
8010743e:	78 50                	js     80107490 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107440:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107446:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107449:	0f 86 81 00 00 00    	jbe    801074d0 <allocuvm+0x100>
    mem = kalloc();
8010744f:	e8 9c b0 ff ff       	call   801024f0 <kalloc>
    if(mem == 0){
80107454:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107456:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107458:	75 b6                	jne    80107410 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010745a:	83 ec 0c             	sub    $0xc,%esp
8010745d:	68 55 82 10 80       	push   $0x80108255
80107462:	e8 f9 91 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107467:	83 c4 10             	add    $0x10,%esp
8010746a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010746d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107470:	77 6e                	ja     801074e0 <allocuvm+0x110>
}
80107472:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107475:	31 ff                	xor    %edi,%edi
}
80107477:	89 f8                	mov    %edi,%eax
80107479:	5b                   	pop    %ebx
8010747a:	5e                   	pop    %esi
8010747b:	5f                   	pop    %edi
8010747c:	5d                   	pop    %ebp
8010747d:	c3                   	ret    
8010747e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107480:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107483:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107486:	89 f8                	mov    %edi,%eax
80107488:	5b                   	pop    %ebx
80107489:	5e                   	pop    %esi
8010748a:	5f                   	pop    %edi
8010748b:	5d                   	pop    %ebp
8010748c:	c3                   	ret    
8010748d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107490:	83 ec 0c             	sub    $0xc,%esp
80107493:	68 6d 82 10 80       	push   $0x8010826d
80107498:	e8 c3 91 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010749d:	83 c4 10             	add    $0x10,%esp
801074a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801074a3:	39 45 10             	cmp    %eax,0x10(%ebp)
801074a6:	76 0d                	jbe    801074b5 <allocuvm+0xe5>
801074a8:	89 c1                	mov    %eax,%ecx
801074aa:	8b 55 10             	mov    0x10(%ebp),%edx
801074ad:	8b 45 08             	mov    0x8(%ebp),%eax
801074b0:	e8 6b fb ff ff       	call   80107020 <deallocuvm.part.0>
      kfree(mem);
801074b5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801074b8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801074ba:	56                   	push   %esi
801074bb:	e8 80 ae ff ff       	call   80102340 <kfree>
      return 0;
801074c0:	83 c4 10             	add    $0x10,%esp
}
801074c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c6:	89 f8                	mov    %edi,%eax
801074c8:	5b                   	pop    %ebx
801074c9:	5e                   	pop    %esi
801074ca:	5f                   	pop    %edi
801074cb:	5d                   	pop    %ebp
801074cc:	c3                   	ret    
801074cd:	8d 76 00             	lea    0x0(%esi),%esi
801074d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801074d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d6:	5b                   	pop    %ebx
801074d7:	89 f8                	mov    %edi,%eax
801074d9:	5e                   	pop    %esi
801074da:	5f                   	pop    %edi
801074db:	5d                   	pop    %ebp
801074dc:	c3                   	ret    
801074dd:	8d 76 00             	lea    0x0(%esi),%esi
801074e0:	89 c1                	mov    %eax,%ecx
801074e2:	8b 55 10             	mov    0x10(%ebp),%edx
801074e5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801074e8:	31 ff                	xor    %edi,%edi
801074ea:	e8 31 fb ff ff       	call   80107020 <deallocuvm.part.0>
801074ef:	eb 92                	jmp    80107483 <allocuvm+0xb3>
801074f1:	eb 0d                	jmp    80107500 <deallocuvm>
801074f3:	90                   	nop
801074f4:	90                   	nop
801074f5:	90                   	nop
801074f6:	90                   	nop
801074f7:	90                   	nop
801074f8:	90                   	nop
801074f9:	90                   	nop
801074fa:	90                   	nop
801074fb:	90                   	nop
801074fc:	90                   	nop
801074fd:	90                   	nop
801074fe:	90                   	nop
801074ff:	90                   	nop

80107500 <deallocuvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	8b 55 0c             	mov    0xc(%ebp),%edx
80107506:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107509:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010750c:	39 d1                	cmp    %edx,%ecx
8010750e:	73 10                	jae    80107520 <deallocuvm+0x20>
}
80107510:	5d                   	pop    %ebp
80107511:	e9 0a fb ff ff       	jmp    80107020 <deallocuvm.part.0>
80107516:	8d 76 00             	lea    0x0(%esi),%esi
80107519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107520:	89 d0                	mov    %edx,%eax
80107522:	5d                   	pop    %ebp
80107523:	c3                   	ret    
80107524:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010752a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107530 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 0c             	sub    $0xc,%esp
80107539:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010753c:	85 f6                	test   %esi,%esi
8010753e:	74 59                	je     80107599 <freevm+0x69>
80107540:	31 c9                	xor    %ecx,%ecx
80107542:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107547:	89 f0                	mov    %esi,%eax
80107549:	e8 d2 fa ff ff       	call   80107020 <deallocuvm.part.0>
8010754e:	89 f3                	mov    %esi,%ebx
80107550:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107556:	eb 0f                	jmp    80107567 <freevm+0x37>
80107558:	90                   	nop
80107559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107560:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107563:	39 fb                	cmp    %edi,%ebx
80107565:	74 23                	je     8010758a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107567:	8b 03                	mov    (%ebx),%eax
80107569:	a8 01                	test   $0x1,%al
8010756b:	74 f3                	je     80107560 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010756d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107572:	83 ec 0c             	sub    $0xc,%esp
80107575:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107578:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010757d:	50                   	push   %eax
8010757e:	e8 bd ad ff ff       	call   80102340 <kfree>
80107583:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107586:	39 fb                	cmp    %edi,%ebx
80107588:	75 dd                	jne    80107567 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010758a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010758d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107590:	5b                   	pop    %ebx
80107591:	5e                   	pop    %esi
80107592:	5f                   	pop    %edi
80107593:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107594:	e9 a7 ad ff ff       	jmp    80102340 <kfree>
    panic("freevm: no pgdir");
80107599:	83 ec 0c             	sub    $0xc,%esp
8010759c:	68 89 82 10 80       	push   $0x80108289
801075a1:	e8 ea 8d ff ff       	call   80100390 <panic>
801075a6:	8d 76 00             	lea    0x0(%esi),%esi
801075a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075b0 <setupkvm>:
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	56                   	push   %esi
801075b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075b5:	e8 36 af ff ff       	call   801024f0 <kalloc>
801075ba:	85 c0                	test   %eax,%eax
801075bc:	89 c6                	mov    %eax,%esi
801075be:	74 42                	je     80107602 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801075c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801075c8:	68 00 10 00 00       	push   $0x1000
801075cd:	6a 00                	push   $0x0
801075cf:	50                   	push   %eax
801075d0:	e8 4b d7 ff ff       	call   80104d20 <memset>
801075d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801075d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075db:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075de:	83 ec 08             	sub    $0x8,%esp
801075e1:	8b 13                	mov    (%ebx),%edx
801075e3:	ff 73 0c             	pushl  0xc(%ebx)
801075e6:	50                   	push   %eax
801075e7:	29 c1                	sub    %eax,%ecx
801075e9:	89 f0                	mov    %esi,%eax
801075eb:	e8 a0 f9 ff ff       	call   80106f90 <mappages>
801075f0:	83 c4 10             	add    $0x10,%esp
801075f3:	85 c0                	test   %eax,%eax
801075f5:	78 19                	js     80107610 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075f7:	83 c3 10             	add    $0x10,%ebx
801075fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107600:	75 d6                	jne    801075d8 <setupkvm+0x28>
}
80107602:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107605:	89 f0                	mov    %esi,%eax
80107607:	5b                   	pop    %ebx
80107608:	5e                   	pop    %esi
80107609:	5d                   	pop    %ebp
8010760a:	c3                   	ret    
8010760b:	90                   	nop
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107610:	83 ec 0c             	sub    $0xc,%esp
80107613:	56                   	push   %esi
      return 0;
80107614:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107616:	e8 15 ff ff ff       	call   80107530 <freevm>
      return 0;
8010761b:	83 c4 10             	add    $0x10,%esp
}
8010761e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107621:	89 f0                	mov    %esi,%eax
80107623:	5b                   	pop    %ebx
80107624:	5e                   	pop    %esi
80107625:	5d                   	pop    %ebp
80107626:	c3                   	ret    
80107627:	89 f6                	mov    %esi,%esi
80107629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107630 <kvmalloc>:
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107636:	e8 75 ff ff ff       	call   801075b0 <setupkvm>
8010763b:	a3 e4 34 12 80       	mov    %eax,0x801234e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107640:	05 00 00 00 80       	add    $0x80000000,%eax
80107645:	0f 22 d8             	mov    %eax,%cr3
}
80107648:	c9                   	leave  
80107649:	c3                   	ret    
8010764a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107650 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107650:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107651:	31 c9                	xor    %ecx,%ecx
{
80107653:	89 e5                	mov    %esp,%ebp
80107655:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107658:	8b 55 0c             	mov    0xc(%ebp),%edx
8010765b:	8b 45 08             	mov    0x8(%ebp),%eax
8010765e:	e8 ad f8 ff ff       	call   80106f10 <walkpgdir>
  if(pte == 0)
80107663:	85 c0                	test   %eax,%eax
80107665:	74 05                	je     8010766c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107667:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010766a:	c9                   	leave  
8010766b:	c3                   	ret    
    panic("clearpteu");
8010766c:	83 ec 0c             	sub    $0xc,%esp
8010766f:	68 9a 82 10 80       	push   $0x8010829a
80107674:	e8 17 8d ff ff       	call   80100390 <panic>
80107679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107680 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	57                   	push   %edi
80107684:	56                   	push   %esi
80107685:	53                   	push   %ebx
80107686:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107689:	e8 22 ff ff ff       	call   801075b0 <setupkvm>
8010768e:	85 c0                	test   %eax,%eax
80107690:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107693:	0f 84 9f 00 00 00    	je     80107738 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010769c:	85 c9                	test   %ecx,%ecx
8010769e:	0f 84 94 00 00 00    	je     80107738 <copyuvm+0xb8>
801076a4:	31 ff                	xor    %edi,%edi
801076a6:	eb 4a                	jmp    801076f2 <copyuvm+0x72>
801076a8:	90                   	nop
801076a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801076b0:	83 ec 04             	sub    $0x4,%esp
801076b3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801076b9:	68 00 10 00 00       	push   $0x1000
801076be:	53                   	push   %ebx
801076bf:	50                   	push   %eax
801076c0:	e8 0b d7 ff ff       	call   80104dd0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076c5:	58                   	pop    %eax
801076c6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801076cc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076d1:	5a                   	pop    %edx
801076d2:	ff 75 e4             	pushl  -0x1c(%ebp)
801076d5:	50                   	push   %eax
801076d6:	89 fa                	mov    %edi,%edx
801076d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076db:	e8 b0 f8 ff ff       	call   80106f90 <mappages>
801076e0:	83 c4 10             	add    $0x10,%esp
801076e3:	85 c0                	test   %eax,%eax
801076e5:	78 61                	js     80107748 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801076e7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801076ed:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801076f0:	76 46                	jbe    80107738 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076f2:	8b 45 08             	mov    0x8(%ebp),%eax
801076f5:	31 c9                	xor    %ecx,%ecx
801076f7:	89 fa                	mov    %edi,%edx
801076f9:	e8 12 f8 ff ff       	call   80106f10 <walkpgdir>
801076fe:	85 c0                	test   %eax,%eax
80107700:	74 61                	je     80107763 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107702:	8b 00                	mov    (%eax),%eax
80107704:	a8 01                	test   $0x1,%al
80107706:	74 4e                	je     80107756 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107708:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010770a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010770f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107718:	e8 d3 ad ff ff       	call   801024f0 <kalloc>
8010771d:	85 c0                	test   %eax,%eax
8010771f:	89 c6                	mov    %eax,%esi
80107721:	75 8d                	jne    801076b0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107723:	83 ec 0c             	sub    $0xc,%esp
80107726:	ff 75 e0             	pushl  -0x20(%ebp)
80107729:	e8 02 fe ff ff       	call   80107530 <freevm>
  return 0;
8010772e:	83 c4 10             	add    $0x10,%esp
80107731:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107738:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010773b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010773e:	5b                   	pop    %ebx
8010773f:	5e                   	pop    %esi
80107740:	5f                   	pop    %edi
80107741:	5d                   	pop    %ebp
80107742:	c3                   	ret    
80107743:	90                   	nop
80107744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107748:	83 ec 0c             	sub    $0xc,%esp
8010774b:	56                   	push   %esi
8010774c:	e8 ef ab ff ff       	call   80102340 <kfree>
      goto bad;
80107751:	83 c4 10             	add    $0x10,%esp
80107754:	eb cd                	jmp    80107723 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107756:	83 ec 0c             	sub    $0xc,%esp
80107759:	68 be 82 10 80       	push   $0x801082be
8010775e:	e8 2d 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107763:	83 ec 0c             	sub    $0xc,%esp
80107766:	68 a4 82 10 80       	push   $0x801082a4
8010776b:	e8 20 8c ff ff       	call   80100390 <panic>

80107770 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107770:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107771:	31 c9                	xor    %ecx,%ecx
{
80107773:	89 e5                	mov    %esp,%ebp
80107775:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107778:	8b 55 0c             	mov    0xc(%ebp),%edx
8010777b:	8b 45 08             	mov    0x8(%ebp),%eax
8010777e:	e8 8d f7 ff ff       	call   80106f10 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107783:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107785:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107786:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107788:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010778d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107790:	05 00 00 00 80       	add    $0x80000000,%eax
80107795:	83 fa 05             	cmp    $0x5,%edx
80107798:	ba 00 00 00 00       	mov    $0x0,%edx
8010779d:	0f 45 c2             	cmovne %edx,%eax
}
801077a0:	c3                   	ret    
801077a1:	eb 0d                	jmp    801077b0 <copyout>
801077a3:	90                   	nop
801077a4:	90                   	nop
801077a5:	90                   	nop
801077a6:	90                   	nop
801077a7:	90                   	nop
801077a8:	90                   	nop
801077a9:	90                   	nop
801077aa:	90                   	nop
801077ab:	90                   	nop
801077ac:	90                   	nop
801077ad:	90                   	nop
801077ae:	90                   	nop
801077af:	90                   	nop

801077b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 1c             	sub    $0x1c,%esp
801077b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801077bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801077bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077c2:	85 db                	test   %ebx,%ebx
801077c4:	75 40                	jne    80107806 <copyout+0x56>
801077c6:	eb 70                	jmp    80107838 <copyout+0x88>
801077c8:	90                   	nop
801077c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801077d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801077d3:	89 f1                	mov    %esi,%ecx
801077d5:	29 d1                	sub    %edx,%ecx
801077d7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801077dd:	39 d9                	cmp    %ebx,%ecx
801077df:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077e2:	29 f2                	sub    %esi,%edx
801077e4:	83 ec 04             	sub    $0x4,%esp
801077e7:	01 d0                	add    %edx,%eax
801077e9:	51                   	push   %ecx
801077ea:	57                   	push   %edi
801077eb:	50                   	push   %eax
801077ec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801077ef:	e8 dc d5 ff ff       	call   80104dd0 <memmove>
    len -= n;
    buf += n;
801077f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801077f7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801077fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107800:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107802:	29 cb                	sub    %ecx,%ebx
80107804:	74 32                	je     80107838 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107806:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107808:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010780b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010780e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107814:	56                   	push   %esi
80107815:	ff 75 08             	pushl  0x8(%ebp)
80107818:	e8 53 ff ff ff       	call   80107770 <uva2ka>
    if(pa0 == 0)
8010781d:	83 c4 10             	add    $0x10,%esp
80107820:	85 c0                	test   %eax,%eax
80107822:	75 ac                	jne    801077d0 <copyout+0x20>
  }
  return 0;
}
80107824:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107827:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010782c:	5b                   	pop    %ebx
8010782d:	5e                   	pop    %esi
8010782e:	5f                   	pop    %edi
8010782f:	5d                   	pop    %ebp
80107830:	c3                   	ret    
80107831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107838:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010783b:	31 c0                	xor    %eax,%eax
}
8010783d:	5b                   	pop    %ebx
8010783e:	5e                   	pop    %esi
8010783f:	5f                   	pop    %edi
80107840:	5d                   	pop    %ebp
80107841:	c3                   	ret    
