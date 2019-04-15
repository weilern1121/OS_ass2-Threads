
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
8010002d:	b8 70 2e 10 80       	mov    $0x80102e70,%eax
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
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 7c 10 80       	push   $0x80107cc0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 65 4e 00 00       	call   80104ec0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
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
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 7c 10 80       	push   $0x80107cc7
80100097:	50                   	push   %eax
80100098:	e8 f3 4c 00 00       	call   80104d90 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
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
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 37 4f 00 00       	call   80105020 <acquire>

  // Is the block already cached?
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
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
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
80100162:	e8 69 4f 00 00       	call   801050d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 4c 00 00       	call   80104dd0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 7d 1f 00 00       	call   80102100 <iderw>
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
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 7c 10 80       	push   $0x80107cce
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

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
801001ae:	e8 bd 4c 00 00       	call   80104e70 <holdingsleep>
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
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 37 1f 00 00       	jmp    80102100 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 7c 10 80       	push   $0x80107cdf
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
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
801001ef:	e8 7c 4c 00 00       	call   80104e70 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 4c 00 00       	call   80104e30 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 10 4e 00 00       	call   80105020 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
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
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
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
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 6f 4e 00 00       	jmp    801050d0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 7c 10 80       	push   $0x80107ce6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
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
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 8f 4d 00 00       	call   80105020 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002a6:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 c0 0f 11 80       	push   $0x80110fc0
801002bd:	e8 2e 3c 00 00       	call   80103ef0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 c9 35 00 00       	call   801038a0 <myproc>
801002d7:	8b 40 1c             	mov    0x1c(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 e5 4d 00 00       	call   801050d0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 8d 13 00 00       	call   80101680 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 85 4d 00 00       	call   801050d0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 2d 13 00 00       	call   80101680 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 72 23 00 00       	call   80102700 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ed 7c 10 80       	push   $0x80107ced
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 e7 86 10 80 	movl   $0x801086e7,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 23 4b 00 00       	call   80104ee0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 01 7d 10 80       	push   $0x80107d01
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 41 64 00 00       	call   80106860 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 88 63 00 00       	call   80106860 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 7c 63 00 00       	call   80106860 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 70 63 00 00       	call   80106860 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 c7 4c 00 00       	call   801051e0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 02 4c 00 00       	call   80105130 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 05 7d 10 80       	push   $0x80107d05
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 30 7d 10 80 	movzbl -0x7fef82d0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 00 4a 00 00       	call   80105020 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 84 4a 00 00       	call   801050d0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

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
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 be 49 00 00       	call   801050d0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 18 7d 10 80       	mov    $0x80107d18,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 53 48 00 00       	call   80105020 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 1f 7d 10 80       	push   $0x80107d1f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 18 48 00 00       	call   80105020 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100836:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 63 48 00 00       	call   801050d0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
801008f1:	68 c0 0f 11 80       	push   $0x80110fc0
801008f6:	e8 f5 3a 00 00       	call   801043f0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010090d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100934:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 d4 3b 00 00       	jmp    80104550 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 28 7d 10 80       	push   $0x80107d28
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 0b 45 00 00       	call   80104ec0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 d2 18 00 00       	call   801022b0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3+MAXARG+1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
801009fc:	e8 9f 2e 00 00       	call   801038a0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
    struct  thread *curthread = mythread();
80100a07:	e8 c4 2e 00 00       	call   801038d0 <mythread>
80100a0c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
    //struct  thread *t;
    begin_op();
80100a12:	e8 49 21 00 00       	call   80102b60 <begin_op>

    if((ip = namei(path)) == 0){
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	ff 75 08             	pushl  0x8(%ebp)
80100a1d:	e8 ae 14 00 00       	call   80101ed0 <namei>
80100a22:	83 c4 10             	add    $0x10,%esp
80100a25:	85 c0                	test   %eax,%eax
80100a27:	0f 84 99 01 00 00    	je     80100bc6 <exec+0x1d6>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100a2d:	83 ec 0c             	sub    $0xc,%esp
80100a30:	89 c3                	mov    %eax,%ebx
80100a32:	50                   	push   %eax
80100a33:	e8 48 0c 00 00       	call   80101680 <ilock>
    pgdir = 0;

    // Check ELF header
    if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a38:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a3e:	6a 34                	push   $0x34
80100a40:	6a 00                	push   $0x0
80100a42:	50                   	push   %eax
80100a43:	53                   	push   %ebx
80100a44:	e8 17 0f 00 00       	call   80101960 <readi>
80100a49:	83 c4 20             	add    $0x20,%esp
80100a4c:	83 f8 34             	cmp    $0x34,%eax
80100a4f:	74 1f                	je     80100a70 <exec+0x80>

bad:
    if(pgdir)
        freevm(pgdir);
    if(ip){
        iunlockput(ip);
80100a51:	83 ec 0c             	sub    $0xc,%esp
80100a54:	53                   	push   %ebx
80100a55:	e8 b6 0e 00 00       	call   80101910 <iunlockput>
        end_op();
80100a5a:	e8 71 21 00 00       	call   80102bd0 <end_op>
80100a5f:	83 c4 10             	add    $0x10,%esp
    }
    return -1;
80100a62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a6a:	5b                   	pop    %ebx
80100a6b:	5e                   	pop    %esi
80100a6c:	5f                   	pop    %edi
80100a6d:	5d                   	pop    %ebp
80100a6e:	c3                   	ret    
80100a6f:	90                   	nop
    pgdir = 0;

    // Check ELF header
    if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
        goto bad;
    if(elf.magic != ELF_MAGIC)
80100a70:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a77:	45 4c 46 
80100a7a:	75 d5                	jne    80100a51 <exec+0x61>
        goto bad;

    if((pgdir = setupkvm()) == 0)
80100a7c:	e8 7f 6f 00 00       	call   80107a00 <setupkvm>
80100a81:	85 c0                	test   %eax,%eax
80100a83:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100a89:	74 c6                	je     80100a51 <exec+0x61>
        goto bad;

    // Load program into memory.
    sz = 0;
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a8b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a92:	00 
80100a93:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a99:	c7 85 e8 fe ff ff 00 	movl   $0x0,-0x118(%ebp)
80100aa0:	00 00 00 
80100aa3:	0f 84 c5 00 00 00    	je     80100b6e <exec+0x17e>
80100aa9:	31 ff                	xor    %edi,%edi
80100aab:	eb 18                	jmp    80100ac5 <exec+0xd5>
80100aad:	8d 76 00             	lea    0x0(%esi),%esi
80100ab0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ab7:	83 c7 01             	add    $0x1,%edi
80100aba:	83 c6 20             	add    $0x20,%esi
80100abd:	39 f8                	cmp    %edi,%eax
80100abf:	0f 8e a9 00 00 00    	jle    80100b6e <exec+0x17e>
        if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ac5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100acb:	6a 20                	push   $0x20
80100acd:	56                   	push   %esi
80100ace:	50                   	push   %eax
80100acf:	53                   	push   %ebx
80100ad0:	e8 8b 0e 00 00       	call   80101960 <readi>
80100ad5:	83 c4 10             	add    $0x10,%esp
80100ad8:	83 f8 20             	cmp    $0x20,%eax
80100adb:	75 7b                	jne    80100b58 <exec+0x168>
            goto bad;
        if(ph.type != ELF_PROG_LOAD)
80100add:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ae4:	75 ca                	jne    80100ab0 <exec+0xc0>
            continue;
        if(ph.memsz < ph.filesz)
80100ae6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aec:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100af2:	72 64                	jb     80100b58 <exec+0x168>
            goto bad;
        if(ph.vaddr + ph.memsz < ph.vaddr)
80100af4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100afa:	72 5c                	jb     80100b58 <exec+0x168>
            goto bad;
        if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100afc:	83 ec 04             	sub    $0x4,%esp
80100aff:	50                   	push   %eax
80100b00:	ff b5 e8 fe ff ff    	pushl  -0x118(%ebp)
80100b06:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b0c:	e8 3f 6d 00 00       	call   80107850 <allocuvm>
80100b11:	83 c4 10             	add    $0x10,%esp
80100b14:	85 c0                	test   %eax,%eax
80100b16:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b1c:	74 3a                	je     80100b58 <exec+0x168>
            goto bad;
        if(ph.vaddr % PGSIZE != 0)
80100b1e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b24:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b29:	75 2d                	jne    80100b58 <exec+0x168>
            goto bad;
        if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b2b:	83 ec 0c             	sub    $0xc,%esp
80100b2e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b34:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b3a:	53                   	push   %ebx
80100b3b:	50                   	push   %eax
80100b3c:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b42:	e8 49 6c 00 00       	call   80107790 <loaduvm>
80100b47:	83 c4 20             	add    $0x20,%esp
80100b4a:	85 c0                	test   %eax,%eax
80100b4c:	0f 89 5e ff ff ff    	jns    80100ab0 <exec+0xc0>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    freevm(oldpgdir);
    return 0;

bad:
    if(pgdir)
        freevm(pgdir);
80100b58:	83 ec 0c             	sub    $0xc,%esp
80100b5b:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b61:	e8 1a 6e 00 00       	call   80107980 <freevm>
80100b66:	83 c4 10             	add    $0x10,%esp
80100b69:	e9 e3 fe ff ff       	jmp    80100a51 <exec+0x61>
        if(ph.vaddr % PGSIZE != 0)
            goto bad;
        if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
            goto bad;
    }
    iunlockput(ip);
80100b6e:	83 ec 0c             	sub    $0xc,%esp
80100b71:	53                   	push   %ebx
80100b72:	e8 99 0d 00 00       	call   80101910 <iunlockput>
    end_op();
80100b77:	e8 54 20 00 00       	call   80102bd0 <end_op>
    ip = 0;

    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
80100b7c:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b82:	83 c4 0c             	add    $0xc,%esp
    end_op();
    ip = 0;

    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
80100b85:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b8f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b95:	52                   	push   %edx
80100b96:	50                   	push   %eax
80100b97:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b9d:	e8 ae 6c 00 00       	call   80107850 <allocuvm>
80100ba2:	83 c4 10             	add    $0x10,%esp
80100ba5:	85 c0                	test   %eax,%eax
80100ba7:	89 c6                	mov    %eax,%esi
80100ba9:	75 3a                	jne    80100be5 <exec+0x1f5>
    freevm(oldpgdir);
    return 0;

bad:
    if(pgdir)
        freevm(pgdir);
80100bab:	83 ec 0c             	sub    $0xc,%esp
80100bae:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bb4:	e8 c7 6d 00 00       	call   80107980 <freevm>
80100bb9:	83 c4 10             	add    $0x10,%esp
    if(ip){
        iunlockput(ip);
        end_op();
    }
    return -1;
80100bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc1:	e9 a1 fe ff ff       	jmp    80100a67 <exec+0x77>
    struct  thread *curthread = mythread();
    //struct  thread *t;
    begin_op();

    if((ip = namei(path)) == 0){
        end_op();
80100bc6:	e8 05 20 00 00       	call   80102bd0 <end_op>
        cprintf("exec: fail\n");
80100bcb:	83 ec 0c             	sub    $0xc,%esp
80100bce:	68 41 7d 10 80       	push   $0x80107d41
80100bd3:	e8 88 fa ff ff       	call   80100660 <cprintf>
        return -1;
80100bd8:	83 c4 10             	add    $0x10,%esp
80100bdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be0:	e9 82 fe ff ff       	jmp    80100a67 <exec+0x77>
    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100be5:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100beb:	83 ec 08             	sub    $0x8,%esp
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100bee:	31 ff                	xor    %edi,%edi
80100bf0:	89 f3                	mov    %esi,%ebx
    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
    if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	50                   	push   %eax
80100bf3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bf9:	e8 a2 6e 00 00       	call   80107aa0 <clearpteu>
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c01:	83 c4 10             	add    $0x10,%esp
80100c04:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c0a:	8b 00                	mov    (%eax),%eax
80100c0c:	85 c0                	test   %eax,%eax
80100c0e:	74 6d                	je     80100c7d <exec+0x28d>
80100c10:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
80100c16:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c1c:	eb 07                	jmp    80100c25 <exec+0x235>
80100c1e:	66 90                	xchg   %ax,%ax
        if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	74 86                	je     80100bab <exec+0x1bb>
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c25:	83 ec 0c             	sub    $0xc,%esp
80100c28:	50                   	push   %eax
80100c29:	e8 42 47 00 00       	call   80105370 <strlen>
80100c2e:	f7 d0                	not    %eax
80100c30:	01 c3                	add    %eax,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c32:	58                   	pop    %eax
80100c33:	8b 45 0c             	mov    0xc(%ebp),%eax

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
        if(argc >= MAXARG)
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c36:	83 e3 fc             	and    $0xfffffffc,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c39:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c3c:	e8 2f 47 00 00       	call   80105370 <strlen>
80100c41:	83 c0 01             	add    $0x1,%eax
80100c44:	50                   	push   %eax
80100c45:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c48:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4b:	53                   	push   %ebx
80100c4c:	56                   	push   %esi
80100c4d:	e8 be 6f 00 00       	call   80107c10 <copyout>
80100c52:	83 c4 20             	add    $0x20,%esp
80100c55:	85 c0                	test   %eax,%eax
80100c57:	0f 88 4e ff ff ff    	js     80100bab <exec+0x1bb>
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
        if(argc >= MAXARG)
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
            goto bad;
        ustack[3+argc] = sp;
80100c60:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100c67:	83 c7 01             	add    $0x1,%edi
        if(argc >= MAXARG)
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
            goto bad;
        ustack[3+argc] = sp;
80100c6a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
        goto bad;
    clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for(argc = 0; argv[argc]; argc++) {
80100c70:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c73:	85 c0                	test   %eax,%eax
80100c75:	75 a9                	jne    80100c20 <exec+0x230>
80100c77:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
    }
    ustack[3+argc] = 0;

    ustack[0] = 0xffffffff;  // fake return PC
    ustack[1] = argc;
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c84:	89 d9                	mov    %ebx,%ecx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
            goto bad;
        ustack[3+argc] = sp;
    }
    ustack[3+argc] = 0;
80100c86:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c8d:	00 00 00 00 

    ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
    ustack[1] = argc;
80100c9b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca1:	29 c1                	sub    %eax,%ecx

    sp -= (3+argc+1) * 4;
80100ca3:	83 c0 0c             	add    $0xc,%eax
80100ca6:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca8:	50                   	push   %eax
80100ca9:	52                   	push   %edx
80100caa:	53                   	push   %ebx
80100cab:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
    }
    ustack[3+argc] = 0;

    ustack[0] = 0xffffffff;  // fake return PC
    ustack[1] = argc;
    ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

    sp -= (3+argc+1) * 4;
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb7:	e8 54 6f 00 00       	call   80107c10 <copyout>
80100cbc:	83 c4 10             	add    $0x10,%esp
80100cbf:	85 c0                	test   %eax,%eax
80100cc1:	0f 88 e4 fe ff ff    	js     80100bab <exec+0x1bb>
        goto bad;

    // Save program name for debugging.
    for(last=s=path; *s; s++)
80100cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cca:	0f b6 10             	movzbl (%eax),%edx
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	74 19                	je     80100cea <exec+0x2fa>
80100cd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd4:	83 c0 01             	add    $0x1,%eax
        if(*s == '/')
            last = s+1;
80100cd7:	80 fa 2f             	cmp    $0x2f,%dl
    sp -= (3+argc+1) * 4;
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
        goto bad;

    // Save program name for debugging.
    for(last=s=path; *s; s++)
80100cda:	0f b6 10             	movzbl (%eax),%edx
        if(*s == '/')
            last = s+1;
80100cdd:	0f 44 c8             	cmove  %eax,%ecx
80100ce0:	83 c0 01             	add    $0x1,%eax
    sp -= (3+argc+1) * 4;
    if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
        goto bad;

    // Save program name for debugging.
    for(last=s=path; *s; s++)
80100ce3:	84 d2                	test   %dl,%dl
80100ce5:	75 f0                	jne    80100cd7 <exec+0x2e7>
80100ce7:	89 4d 08             	mov    %ecx,0x8(%ebp)
        if(*s == '/')
            last = s+1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cea:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf0:	50                   	push   %eax
80100cf1:	6a 10                	push   $0x10
80100cf3:	ff 75 08             	pushl  0x8(%ebp)
80100cf6:	89 f8                	mov    %edi,%eax
80100cf8:	83 c0 64             	add    $0x64,%eax
80100cfb:	50                   	push   %eax
80100cfc:	e8 2f 46 00 00       	call   80105330 <safestrcpy>

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
80100d01:	89 f8                	mov    %edi,%eax
    curproc->pgdir = pgdir;
80100d03:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
        if(*s == '/')
            last = s+1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
80100d09:	8b 7f 04             	mov    0x4(%edi),%edi
    curproc->pgdir = pgdir;
    curproc->sz = sz;
80100d0c:	89 30                	mov    %esi,(%eax)
    curthread->tf->eip = elf.entry;  // main
80100d0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
            last = s+1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
    curproc->pgdir = pgdir;
80100d14:	89 48 04             	mov    %ecx,0x4(%eax)
    curproc->sz = sz;
80100d17:	89 c1                	mov    %eax,%ecx
    curthread->tf->eip = elf.entry;  // main
80100d19:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1f:	8b 46 10             	mov    0x10(%esi),%eax
80100d22:	89 50 38             	mov    %edx,0x38(%eax)
    curthread->tf->esp = sp;
80100d25:	8b 46 10             	mov    0x10(%esi),%eax
80100d28:	89 f2                	mov    %esi,%edx
80100d2a:	89 58 44             	mov    %ebx,0x44(%eax)

    //func in proc.c
    //clean all other threads except curthread
    cleanProcOneThread(curthread,curproc);
80100d2d:	5b                   	pop    %ebx
80100d2e:	5e                   	pop    %esi
80100d2f:	51                   	push   %ecx
80100d30:	52                   	push   %edx
80100d31:	89 ce                	mov    %ecx,%esi
80100d33:	89 d3                	mov    %edx,%ebx
80100d35:	e8 a6 32 00 00       	call   80103fe0 <cleanProcOneThread>
    curproc->mainThread=curthread;
80100d3a:	89 f0                	mov    %esi,%eax
80100d3c:	89 98 b4 03 00 00    	mov    %ebx,0x3b4(%eax)

    switchuvm(curproc);
80100d42:	89 34 24             	mov    %esi,(%esp)
80100d45:	e8 a6 68 00 00       	call   801075f0 <switchuvm>
    freevm(oldpgdir);
80100d4a:	89 3c 24             	mov    %edi,(%esp)
80100d4d:	e8 2e 6c 00 00       	call   80107980 <freevm>
    return 0;
80100d52:	83 c4 10             	add    $0x10,%esp
80100d55:	31 c0                	xor    %eax,%eax
80100d57:	e9 0b fd ff ff       	jmp    80100a67 <exec+0x77>
80100d5c:	66 90                	xchg   %ax,%ax
80100d5e:	66 90                	xchg   %ax,%ax

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 4d 7d 10 80       	push   $0x80107d4d
80100d6b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d70:	e8 4b 41 00 00       	call   80104ec0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 10 11 80       	mov    $0x80111014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d8c:	68 e0 0f 11 80       	push   $0x80110fe0
80100d91:	e8 8a 42 00 00       	call   80105020 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100da9:	74 25                	je     80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 0f 11 80       	push   $0x80110fe0
80100dc1:	e8 0a 43 00 00       	call   801050d0 <release>
      return f;
80100dc6:	89 d8                	mov    %ebx,%eax
80100dc8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
80100dd3:	68 e0 0f 11 80       	push   $0x80110fe0
80100dd8:	e8 f3 42 00 00       	call   801050d0 <release>
  return 0;
80100ddd:	83 c4 10             	add    $0x10,%esp
80100de0:	31 c0                	xor    %eax,%eax
}
80100de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de5:	c9                   	leave  
80100de6:	c3                   	ret    
80100de7:	89 f6                	mov    %esi,%esi
80100de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 0f 11 80       	push   $0x80110fe0
80100dff:	e8 1c 42 00 00       	call   80105020 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 0f 11 80       	push   $0x80110fe0
80100e1c:	e8 af 42 00 00       	call   801050d0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 7d 10 80       	push   $0x80107d54
80100e30:	e8 3b f5 ff ff       	call   80100370 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e51:	e8 ca 41 00 00       	call   80105020 <acquire>
  if(f->ref < 1)
80100e56:	8b 47 04             	mov    0x4(%edi),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 47 04             	mov    %eax,0x4(%edi)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e7c:	e9 4f 42 00 00       	jmp    801050d0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e88:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e8c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e91:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e94:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ea0:	68 e0 0f 11 80       	push   $0x80110fe0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ea8:	e8 23 42 00 00       	call   801050d0 <release>

  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 fb 01             	cmp    $0x1,%ebx
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100eb5:	83 fb 02             	cmp    $0x2,%ebx
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 2a 24 00 00       	call   80103300 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ee0:	e8 7b 1c 00 00       	call   80102b60 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100efa:	e9 d1 1c 00 00       	jmp    80102bd0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 7d 10 80       	push   $0x80107d5c
80100f07:	e8 64 f4 ff ff       	call   80100370 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fb6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fcd:	e9 ce 24 00 00       	jmp    801034a0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fdd:	eb d9                	jmp    80100fb8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 7d 10 80       	push   $0x80107d66
80100fe7:	e8 84 f3 ff ff       	call   80100370 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c2 00 00 00    	je     801010df <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d8 00 00 00    	jne    801010fe <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101029:	31 ff                	xor    %edi,%edi
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 82 1b 00 00       	call   80102bd0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 d8                	cmp    %ebx,%eax
80101056:	0f 85 95 00 00 00    	jne    801010f1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010105c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101076:	e8 e5 1a 00 00       	call   80102b60 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 1e 1b 00 00       	call   80102bd0 <end_op>

      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010c4:	5b                   	pop    %ebx
801010c5:	5e                   	pop    %esi
801010c6:	5f                   	pop    %edi
801010c7:	5d                   	pop    %ebp
801010c8:	c3                   	ret    
801010c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010d0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010df:	8b 46 0c             	mov    0xc(%esi),%eax
801010e2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ec:	e9 af 22 00 00       	jmp    801033a0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010f1:	83 ec 0c             	sub    $0xc,%esp
801010f4:	68 6f 7d 10 80       	push   $0x80107d6f
801010f9:	e8 72 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010fe:	83 ec 0c             	sub    $0xc,%esp
80101101:	68 75 7d 10 80       	push   $0x80107d75
80101106:	e8 65 f2 ff ff       	call   80100370 <panic>
8010110b:	66 90                	xchg   %ax,%ax
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 85 00 00 00    	je     801011af <balloc+0x9f>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2d                	jmp    8010118a <balloc+0x7a>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
80101162:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101167:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101179:	85 d7                	test   %edx,%edi
8010117b:	74 43                	je     801011c0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117d:	83 c0 01             	add    $0x1,%eax
80101180:	83 c6 01             	add    $0x1,%esi
80101183:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101188:	74 05                	je     8010118f <balloc+0x7f>
8010118a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010118d:	72 d1                	jb     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	ff 75 e4             	pushl  -0x1c(%ebp)
80101195:	e8 46 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010119a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a1:	83 c4 10             	add    $0x10,%esp
801011a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a7:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801011ad:	77 82                	ja     80101131 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 7f 7d 10 80       	push   $0x80107d7f
801011b7:	e8 b4 f1 ff ff       	call   80100370 <panic>
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	09 fa                	or     %edi,%edx
801011c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 6e 1b 00 00       	call   80102d40 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 36 3f 00 00       	call   80105130 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 3e 1b 00 00       	call   80102d40 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101235:	68 00 1a 11 80       	push   $0x80111a00
8010123a:	e8 e1 3d 00 00       	call   80105020 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 1b                	jmp    80101262 <iget+0x42>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101250:	85 f6                	test   %esi,%esi
80101252:	74 44                	je     80101298 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101254:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010125a:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101260:	74 4e                	je     801012b0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101262:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101265:	85 c9                	test   %ecx,%ecx
80101267:	7e e7                	jle    80101250 <iget+0x30>
80101269:	39 3b                	cmp    %edi,(%ebx)
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101270:	75 de                	jne    80101250 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101272:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101275:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101278:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010127a:	68 00 1a 11 80       	push   $0x80111a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010127f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101282:	e8 49 3e 00 00       	call   801050d0 <release>
      return ip;
80101287:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	5b                   	pop    %ebx
80101290:	5e                   	pop    %esi
80101291:	5f                   	pop    %edi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
80101294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101298:	85 c9                	test   %ecx,%ecx
8010129a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129d:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012a3:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801012a9:	75 b7                	jne    80101262 <iget+0x42>
801012ab:	90                   	nop
801012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 2d                	je     801012e1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012b4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
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
801012cf:	e8 fc 3d 00 00       	call   801050d0 <release>

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
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 95 7d 10 80       	push   $0x80107d95
801012e9:	e8 82 f0 ff ff       	call   80100370 <panic>
801012ee:	66 90                	xchg   %ax,%ax

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	5b                   	pop    %ebx
8010130e:	5e                   	pop    %esi
8010130f:	5f                   	pop    %edi
80101310:	5d                   	pop    %ebp
80101311:	c3                   	ret    
80101312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 83 00 00 00    	ja     801013a7 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010132a:	85 c0                	test   %eax,%eax
8010132c:	74 6a                	je     80101398 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010132e:	83 ec 08             	sub    $0x8,%esp
80101331:	50                   	push   %eax
80101332:	ff 36                	pushl  (%esi)
80101334:	e8 97 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101339:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101340:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101342:	8b 1a                	mov    (%edx),%ebx
80101344:	85 db                	test   %ebx,%ebx
80101346:	75 1d                	jne    80101365 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101348:	8b 06                	mov    (%esi),%eax
8010134a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134d:	e8 be fd ff ff       	call   80101110 <balloc>
80101352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101358:	89 c3                	mov    %eax,%ebx
8010135a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135c:	57                   	push   %edi
8010135d:	e8 de 19 00 00       	call   80102d40 <log_write>
80101362:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101365:	83 ec 0c             	sub    $0xc,%esp
80101368:	57                   	push   %edi
80101369:	e8 72 ee ff ff       	call   801001e0 <brelse>
8010136e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101371:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101374:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101376:	5b                   	pop    %ebx
80101377:	5e                   	pop    %esi
80101378:	5f                   	pop    %edi
80101379:	5d                   	pop    %ebp
8010137a:	c3                   	ret    
8010137b:	90                   	nop
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 06                	mov    (%esi),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101398:	8b 06                	mov    (%esi),%eax
8010139a:	e8 71 fd ff ff       	call   80101110 <balloc>
8010139f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013a5:	eb 87                	jmp    8010132e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013a7:	83 ec 0c             	sub    $0xc,%esp
801013aa:	68 a5 7d 10 80       	push   $0x80107da5
801013af:	e8 bc ef ff ff       	call   80100370 <panic>
801013b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013c0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013c8:	83 ec 08             	sub    $0x8,%esp
801013cb:	6a 01                	push   $0x1
801013cd:	ff 75 08             	pushl  0x8(%ebp)
801013d0:	e8 fb ec ff ff       	call   801000d0 <bread>
801013d5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013da:	83 c4 0c             	add    $0xc,%esp
801013dd:	6a 1c                	push   $0x1c
801013df:	50                   	push   %eax
801013e0:	56                   	push   %esi
801013e1:	e8 fa 3d 00 00       	call   801051e0 <memmove>
  brelse(bp);
801013e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013e9:	83 c4 10             	add    $0x10,%esp
}
801013ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ef:	5b                   	pop    %ebx
801013f0:	5e                   	pop    %esi
801013f1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013f2:	e9 e9 ed ff ff       	jmp    801001e0 <brelse>
801013f7:	89 f6                	mov    %esi,%esi
801013f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101400 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	56                   	push   %esi
80101404:	53                   	push   %ebx
80101405:	89 d3                	mov    %edx,%ebx
80101407:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101409:	83 ec 08             	sub    $0x8,%esp
8010140c:	68 e0 19 11 80       	push   $0x801119e0
80101411:	50                   	push   %eax
80101412:	e8 a9 ff ff ff       	call   801013c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101417:	58                   	pop    %eax
80101418:	5a                   	pop    %edx
80101419:	89 da                	mov    %ebx,%edx
8010141b:	c1 ea 0c             	shr    $0xc,%edx
8010141e:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101424:	52                   	push   %edx
80101425:	56                   	push   %esi
80101426:	e8 a5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010142b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101433:	ba 01 00 00 00       	mov    $0x1,%edx
80101438:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143b:	c1 fb 03             	sar    $0x3,%ebx
8010143e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101441:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101443:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101448:	85 d1                	test   %edx,%ecx
8010144a:	74 27                	je     80101473 <bfree+0x73>
8010144c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010144e:	f7 d2                	not    %edx
80101450:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101452:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101455:	21 d0                	and    %edx,%eax
80101457:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010145b:	56                   	push   %esi
8010145c:	e8 df 18 00 00       	call   80102d40 <log_write>
  brelse(bp);
80101461:	89 34 24             	mov    %esi,(%esp)
80101464:	e8 77 ed ff ff       	call   801001e0 <brelse>
}
80101469:	83 c4 10             	add    $0x10,%esp
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
80101472:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101473:	83 ec 0c             	sub    $0xc,%esp
80101476:	68 b8 7d 10 80       	push   $0x80107db8
8010147b:	e8 f0 ee ff ff       	call   80100370 <panic>

80101480 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010148c:	68 cb 7d 10 80       	push   $0x80107dcb
80101491:	68 00 1a 11 80       	push   $0x80111a00
80101496:	e8 25 3a 00 00       	call   80104ec0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 d2 7d 10 80       	push   $0x80107dd2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 dc 38 00 00       	call   80104d90 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 e0 19 11 80       	push   $0x801119e0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 f1 fe ff ff       	call   801013c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 f8 19 11 80    	pushl  0x801119f8
801014d5:	ff 35 f4 19 11 80    	pushl  0x801119f4
801014db:	ff 35 f0 19 11 80    	pushl  0x801119f0
801014e1:	ff 35 ec 19 11 80    	pushl  0x801119ec
801014e7:	ff 35 e8 19 11 80    	pushl  0x801119e8
801014ed:	ff 35 e4 19 11 80    	pushl  0x801119e4
801014f3:	ff 35 e0 19 11 80    	pushl  0x801119e0
801014f9:	68 38 7e 10 80       	push   $0x80107e38
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 9d 3b 00 00       	call   80105130 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 9b 17 00 00       	call   80102d40 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015bb:	e9 60 fc ff ff       	jmp    80101220 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 d8 7d 10 80       	push   $0x80107dd8
801015c8:	e8 a3 ed ff ff       	call   80100370 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 aa 3b 00 00       	call   801051e0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 02 17 00 00       	call   80102d40 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 00 1a 11 80       	push   $0x80111a00
8010165f:	e8 bc 39 00 00       	call   80105020 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010166f:	e8 5c 3a 00 00       	call   801050d0 <release>
  return ip;
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 29 37 00 00       	call   80104dd0 <acquiresleep>

  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 c3 3a 00 00       	call   801051e0 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 f0 7d 10 80       	push   $0x80107df0
80101742:	e8 29 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ea 7d 10 80       	push   $0x80107dea
8010174f:	e8 1c ec ff ff       	call   80100370 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 f8 36 00 00       	call   80104e70 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010178f:	e9 9c 36 00 00       	jmp    80104e30 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 ff 7d 10 80       	push   $0x80107dff
8010179c:	e8 cf eb ff ff       	call   80100370 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017bc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 0b 36 00 00       	call   80104dd0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017d4:	74 32                	je     80101808 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 51 36 00 00       	call   80104e30 <releasesleep>

  acquire(&icache.lock);
801017df:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017e6:	e8 35 38 00 00       	call   80105020 <acquire>
  ip->ref--;
801017eb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101800:	e9 cb 38 00 00       	jmp    801050d0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 00 1a 11 80       	push   $0x80111a00
80101810:	e8 0b 38 00 00       	call   80105020 <acquire>
    int r = ip->ref;
80101815:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101818:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010181f:	e8 ac 38 00 00       	call   801050d0 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fb 01             	cmp    $0x1,%ebx
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fb                	cmp    %edi,%ebx
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 13                	mov    (%ebx),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 06                	mov    (%esi),%eax
8010184f:	e8 ac fb ff ff       	call   80101400 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101870:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101877:	56                   	push   %esi
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101883:	89 34 24             	mov    %esi,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 36                	pushl  (%esi)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fb                	cmp    %edi,%ebx
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 13                	mov    (%ebx),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 06                	mov    (%esi),%eax
801018d7:	e8 24 fb ff ff       	call   80101400 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    }
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018f2:	8b 06                	mov    (%esi),%eax
801018f4:	e8 07 fb ff ff       	call   80101400 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010196f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101977:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010197a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010197d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 f0                	cmp    %esi,%eax
80101991:	0f 82 c1 00 00 00    	jb     80101a58 <readi+0xf8>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 fa                	mov    %edi,%edx
8010199c:	01 f2                	add    %esi,%edx
8010199e:	0f 82 b4 00 00 00    	jb     80101a58 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c1                	mov    %eax,%ecx
801019a6:	29 f1                	sub    %esi,%ecx
801019a8:	39 d0                	cmp    %edx,%eax
801019aa:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6d                	je     80101a23 <readi+0xc3>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 21 f9 ff ff       	call   801012f0 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019d5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019da:	e8 f1 e6 ff ff       	call   801000d0 <bread>
801019df:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019e4:	89 f1                	mov    %esi,%ecx
801019e6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019ec:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019f2:	29 cb                	sub    %ecx,%ebx
801019f4:	29 f8                	sub    %edi,%eax
801019f6:	39 c3                	cmp    %eax,%ebx
801019f8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019ff:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
80101a02:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a04:	50                   	push   %eax
80101a05:	ff 75 e0             	pushl  -0x20(%ebp)
80101a08:	e8 d3 37 00 00       	call   801051e0 <memmove>
    brelse(bp);
80101a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a10:	89 14 24             	mov    %edx,(%esp)
80101a13:	e8 c8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a18:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1b:	83 c4 10             	add    $0x10,%esp
80101a1e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a21:	77 9d                	ja     801019c0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a29:	5b                   	pop    %ebx
80101a2a:	5e                   	pop    %esi
80101a2b:	5f                   	pop    %edi
80101a2c:	5d                   	pop    %ebp
80101a2d:	c3                   	ret    
80101a2e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 1e                	ja     80101a58 <readi+0xf8>
80101a3a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 13                	je     80101a58 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
80101a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a5d:	eb c7                	jmp    80101a26 <readi+0xc6>
80101a5f:	90                   	nop

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	89 f8                	mov    %edi,%eax
80101a9a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a9c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa1:	0f 87 d9 00 00 00    	ja     80101b80 <writei+0x120>
80101aa7:	39 c6                	cmp    %eax,%esi
80101aa9:	0f 87 d1 00 00 00    	ja     80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aaf:	85 ff                	test   %edi,%edi
80101ab1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ab8:	74 78                	je     80101b32 <writei+0xd2>
80101aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aca:	c1 ea 09             	shr    $0x9,%edx
80101acd:	89 f8                	mov    %edi,%eax
80101acf:	e8 1c f8 ff ff       	call   801012f0 <bmap>
80101ad4:	83 ec 08             	sub    $0x8,%esp
80101ad7:	50                   	push   %eax
80101ad8:	ff 37                	pushl  (%edi)
80101ada:	e8 f1 e5 ff ff       	call   801000d0 <bread>
80101adf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ae4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ae7:	89 f1                	mov    %esi,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101af2:	29 cb                	sub    %ecx,%ebx
80101af4:	39 c3                	cmp    %eax,%ebx
80101af6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101af9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101afd:	53                   	push   %ebx
80101afe:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b01:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	50                   	push   %eax
80101b04:	e8 d7 36 00 00       	call   801051e0 <memmove>
    log_write(bp);
80101b09:	89 3c 24             	mov    %edi,(%esp)
80101b0c:	e8 2f 12 00 00       	call   80102d40 <log_write>
    brelse(bp);
80101b11:	89 3c 24             	mov    %edi,(%esp)
80101b14:	e8 c7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b19:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1f:	83 c4 10             	add    $0x10,%esp
80101b22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b25:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b28:	77 96                	ja     80101ac0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b30:	77 36                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b6                	jmp    80101b32 <writei+0xd2>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ae                	jmp    80101b35 <writei+0xd5>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 bd 36 00 00       	call   80105260 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 80 00 00 00    	jne    80101c47 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	75 0d                	jne    80101be0 <dirlookup+0x30>
80101bd3:	eb 5b                	jmp    80101c30 <dirlookup+0x80>
80101bd5:	8d 76 00             	lea    0x0(%esi),%esi
80101bd8:	83 c7 10             	add    $0x10,%edi
80101bdb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bde:	76 50                	jbe    80101c30 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be0:	6a 10                	push   $0x10
80101be2:	57                   	push   %edi
80101be3:	56                   	push   %esi
80101be4:	53                   	push   %ebx
80101be5:	e8 76 fd ff ff       	call   80101960 <readi>
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	83 f8 10             	cmp    $0x10,%eax
80101bf0:	75 48                	jne    80101c3a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101bf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bf7:	74 df                	je     80101bd8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bf9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bfc:	83 ec 04             	sub    $0x4,%esp
80101bff:	6a 0e                	push   $0xe
80101c01:	50                   	push   %eax
80101c02:	ff 75 0c             	pushl  0xc(%ebp)
80101c05:	e8 56 36 00 00       	call   80105260 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c0a:	83 c4 10             	add    $0x10,%esp
80101c0d:	85 c0                	test   %eax,%eax
80101c0f:	75 c7                	jne    80101bd8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c11:	8b 45 10             	mov    0x10(%ebp),%eax
80101c14:	85 c0                	test   %eax,%eax
80101c16:	74 05                	je     80101c1d <dirlookup+0x6d>
        *poff = off;
80101c18:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c1d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c21:	8b 03                	mov    (%ebx),%eax
80101c23:	e8 f8 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c2b:	5b                   	pop    %ebx
80101c2c:	5e                   	pop    %esi
80101c2d:	5f                   	pop    %edi
80101c2e:	5d                   	pop    %ebp
80101c2f:	c3                   	ret    
80101c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c33:	31 c0                	xor    %eax,%eax
}
80101c35:	5b                   	pop    %ebx
80101c36:	5e                   	pop    %esi
80101c37:	5f                   	pop    %edi
80101c38:	5d                   	pop    %ebp
80101c39:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c3a:	83 ec 0c             	sub    $0xc,%esp
80101c3d:	68 19 7e 10 80       	push   $0x80107e19
80101c42:	e8 29 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c47:	83 ec 0c             	sub    $0xc,%esp
80101c4a:	68 07 7e 10 80       	push   $0x80107e07
80101c4f:	e8 1c e7 ff ff       	call   80100370 <panic>
80101c54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c73:	0f 84 53 01 00 00    	je     80101dcc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 22 1c 00 00       	call   801038a0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c81:	8b 70 60             	mov    0x60(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c84:	68 00 1a 11 80       	push   $0x80111a00
80101c89:	e8 92 33 00 00       	call   80105020 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c99:	e8 32 34 00 00       	call   801050d0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
    path++;
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 e3 00 00 00    	je     80101d9d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	89 da                	mov    %ebx,%edx
80101cbf:	84 c0                	test   %al,%al
80101cc1:	0f 84 ac 00 00 00    	je     80101d73 <namex+0x113>
80101cc7:	3c 2f                	cmp    $0x2f,%al
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a3 00 00 00       	jmp    80101d73 <namex+0x113>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 8d 00 00 00    	jle    80101d78 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 e6 34 00 00       	call   801051e0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 7f 00 00 00    	jne    80101dae <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 a3 00 00 00    	je     80101de2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 5c                	je     80101dae <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d73:	31 c9                	xor    %ecx,%ecx
80101d75:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d78:	83 ec 04             	sub    $0x4,%esp
80101d7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d7e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d81:	51                   	push   %ecx
80101d82:	53                   	push   %ebx
80101d83:	57                   	push   %edi
80101d84:	e8 57 34 00 00       	call   801051e0 <memmove>
    name[len] = 0;
80101d89:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d8f:	83 c4 10             	add    $0x10,%esp
80101d92:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d96:	89 d3                	mov    %edx,%ebx
80101d98:	e9 65 ff ff ff       	jmp    80101d02 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101da0:	85 c0                	test   %eax,%eax
80101da2:	75 54                	jne    80101df8 <namex+0x198>
80101da4:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101da9:	5b                   	pop    %ebx
80101daa:	5e                   	pop    %esi
80101dab:	5f                   	pop    %edi
80101dac:	5d                   	pop    %ebp
80101dad:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dae:	83 ec 0c             	sub    $0xc,%esp
80101db1:	56                   	push   %esi
80101db2:	e8 a9 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101db7:	89 34 24             	mov    %esi,(%esp)
80101dba:	e8 f1 f9 ff ff       	call   801017b0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dbf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dc5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc7:	5b                   	pop    %ebx
80101dc8:	5e                   	pop    %esi
80101dc9:	5f                   	pop    %edi
80101dca:	5d                   	pop    %ebp
80101dcb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dcc:	ba 01 00 00 00       	mov    $0x1,%edx
80101dd1:	b8 01 00 00 00       	mov    $0x1,%eax
80101dd6:	e8 45 f4 ff ff       	call   80101220 <iget>
80101ddb:	89 c6                	mov    %eax,%esi
80101ddd:	e9 c9 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101de2:	83 ec 0c             	sub    $0xc,%esp
80101de5:	56                   	push   %esi
80101de6:	e8 75 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101deb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101df1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101df3:	5b                   	pop    %ebx
80101df4:	5e                   	pop    %esi
80101df5:	5f                   	pop    %edi
80101df6:	5d                   	pop    %ebp
80101df7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101df8:	83 ec 0c             	sub    $0xc,%esp
80101dfb:	56                   	push   %esi
80101dfc:	e8 af f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e01:	83 c4 10             	add    $0x10,%esp
80101e04:	31 c0                	xor    %eax,%eax
80101e06:	eb 9e                	jmp    80101da6 <namex+0x146>
80101e08:	90                   	nop
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e10 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 20             	sub    $0x20,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e1c:	6a 00                	push   $0x0
80101e1e:	ff 75 0c             	pushl  0xc(%ebp)
80101e21:	53                   	push   %ebx
80101e22:	e8 89 fd ff ff       	call   80101bb0 <dirlookup>
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	85 c0                	test   %eax,%eax
80101e2c:	75 67                	jne    80101e95 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e2e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e31:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e34:	85 ff                	test   %edi,%edi
80101e36:	74 29                	je     80101e61 <dirlink+0x51>
80101e38:	31 ff                	xor    %edi,%edi
80101e3a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e3d:	eb 09                	jmp    80101e48 <dirlink+0x38>
80101e3f:	90                   	nop
80101e40:	83 c7 10             	add    $0x10,%edi
80101e43:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e46:	76 19                	jbe    80101e61 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e48:	6a 10                	push   $0x10
80101e4a:	57                   	push   %edi
80101e4b:	56                   	push   %esi
80101e4c:	53                   	push   %ebx
80101e4d:	e8 0e fb ff ff       	call   80101960 <readi>
80101e52:	83 c4 10             	add    $0x10,%esp
80101e55:	83 f8 10             	cmp    $0x10,%eax
80101e58:	75 4e                	jne    80101ea8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e5f:	75 df                	jne    80101e40 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e61:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e64:	83 ec 04             	sub    $0x4,%esp
80101e67:	6a 0e                	push   $0xe
80101e69:	ff 75 0c             	pushl  0xc(%ebp)
80101e6c:	50                   	push   %eax
80101e6d:	e8 5e 34 00 00       	call   801052d0 <strncpy>
  de.inum = inum;
80101e72:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e75:	6a 10                	push   $0x10
80101e77:	57                   	push   %edi
80101e78:	56                   	push   %esi
80101e79:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e7a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e7e:	e8 dd fb ff ff       	call   80101a60 <writei>
80101e83:	83 c4 20             	add    $0x20,%esp
80101e86:	83 f8 10             	cmp    $0x10,%eax
80101e89:	75 2a                	jne    80101eb5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e8b:	31 c0                	xor    %eax,%eax
}
80101e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e90:	5b                   	pop    %ebx
80101e91:	5e                   	pop    %esi
80101e92:	5f                   	pop    %edi
80101e93:	5d                   	pop    %ebp
80101e94:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	50                   	push   %eax
80101e99:	e8 12 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101e9e:	83 c4 10             	add    $0x10,%esp
80101ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ea6:	eb e5                	jmp    80101e8d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ea8:	83 ec 0c             	sub    $0xc,%esp
80101eab:	68 28 7e 10 80       	push   $0x80107e28
80101eb0:	e8 bb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	68 ce 84 10 80       	push   $0x801084ce
80101ebd:	e8 ae e4 ff ff       	call   80100370 <panic>
80101ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ed0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ed0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ed1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ed3:	89 e5                	mov    %esp,%ebp
80101ed5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80101edb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ede:	e8 7d fd ff ff       	call   80101c60 <namex>
}
80101ee3:	c9                   	leave  
80101ee4:	c3                   	ret    
80101ee5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ef0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ef1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ef6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101efb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101efe:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eff:	e9 5c fd ff ff       	jmp    80101c60 <namex>
80101f04:	66 90                	xchg   %ax,%ax
80101f06:	66 90                	xchg   %ax,%ax
80101f08:	66 90                	xchg   %ax,%ax
80101f0a:	66 90                	xchg   %ax,%ax
80101f0c:	66 90                	xchg   %ax,%ax
80101f0e:	66 90                	xchg   %ax,%ax

80101f10 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f10:	55                   	push   %ebp
  if(b == 0)
80101f11:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	56                   	push   %esi
80101f16:	53                   	push   %ebx
  if(b == 0)
80101f17:	0f 84 ad 00 00 00    	je     80101fca <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f1d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f20:	89 c1                	mov    %eax,%ecx
80101f22:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f28:	0f 87 8f 00 00 00    	ja     80101fbd <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f2e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f33:	90                   	nop
80101f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f38:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f39:	83 e0 c0             	and    $0xffffffc0,%eax
80101f3c:	3c 40                	cmp    $0x40,%al
80101f3e:	75 f8                	jne    80101f38 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f40:	31 f6                	xor    %esi,%esi
80101f42:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f47:	89 f0                	mov    %esi,%eax
80101f49:	ee                   	out    %al,(%dx)
80101f4a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f4f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f54:	ee                   	out    %al,(%dx)
80101f55:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f5a:	89 d8                	mov    %ebx,%eax
80101f5c:	ee                   	out    %al,(%dx)
80101f5d:	89 d8                	mov    %ebx,%eax
80101f5f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f64:	c1 f8 08             	sar    $0x8,%eax
80101f67:	ee                   	out    %al,(%dx)
80101f68:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f6d:	89 f0                	mov    %esi,%eax
80101f6f:	ee                   	out    %al,(%dx)
80101f70:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f74:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f79:	83 e0 01             	and    $0x1,%eax
80101f7c:	c1 e0 04             	shl    $0x4,%eax
80101f7f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f82:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f83:	f6 01 04             	testb  $0x4,(%ecx)
80101f86:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f8b:	75 13                	jne    80101fa0 <idestart+0x90>
80101f8d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f92:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f96:	5b                   	pop    %ebx
80101f97:	5e                   	pop    %esi
80101f98:	5d                   	pop    %ebp
80101f99:	c3                   	ret    
80101f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fa0:	b8 30 00 00 00       	mov    $0x30,%eax
80101fa5:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fa6:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fab:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101fae:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fb3:	fc                   	cld    
80101fb4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fb9:	5b                   	pop    %ebx
80101fba:	5e                   	pop    %esi
80101fbb:	5d                   	pop    %ebp
80101fbc:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fbd:	83 ec 0c             	sub    $0xc,%esp
80101fc0:	68 94 7e 10 80       	push   $0x80107e94
80101fc5:	e8 a6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fca:	83 ec 0c             	sub    $0xc,%esp
80101fcd:	68 8b 7e 10 80       	push   $0x80107e8b
80101fd2:	e8 99 e3 ff ff       	call   80100370 <panic>
80101fd7:	89 f6                	mov    %esi,%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fe6:	68 a6 7e 10 80       	push   $0x80107ea6
80101feb:	68 80 b5 10 80       	push   $0x8010b580
80101ff0:	e8 cb 2e 00 00       	call   80104ec0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101ff5:	58                   	pop    %eax
80101ff6:	a1 40 3d 11 80       	mov    0x80113d40,%eax
80101ffb:	5a                   	pop    %edx
80101ffc:	83 e8 01             	sub    $0x1,%eax
80101fff:	50                   	push   %eax
80102000:	6a 0e                	push   $0xe
80102002:	e8 a9 02 00 00       	call   801022b0 <ioapicenable>
80102007:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010200a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010200f:	90                   	nop
80102010:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102011:	83 e0 c0             	and    $0xffffffc0,%eax
80102014:	3c 40                	cmp    $0x40,%al
80102016:	75 f8                	jne    80102010 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102018:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010201d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102022:	ee                   	out    %al,(%dx)
80102023:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102028:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202d:	eb 06                	jmp    80102035 <ideinit+0x55>
8010202f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102030:	83 e9 01             	sub    $0x1,%ecx
80102033:	74 0f                	je     80102044 <ideinit+0x64>
80102035:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102036:	84 c0                	test   %al,%al
80102038:	74 f6                	je     80102030 <ideinit+0x50>
      havedisk1 = 1;
8010203a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102041:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102044:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102049:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010204e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010204f:	c9                   	leave  
80102050:	c3                   	ret    
80102051:	eb 0d                	jmp    80102060 <ideintr>
80102053:	90                   	nop
80102054:	90                   	nop
80102055:	90                   	nop
80102056:	90                   	nop
80102057:	90                   	nop
80102058:	90                   	nop
80102059:	90                   	nop
8010205a:	90                   	nop
8010205b:	90                   	nop
8010205c:	90                   	nop
8010205d:	90                   	nop
8010205e:	90                   	nop
8010205f:	90                   	nop

80102060 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102069:	68 80 b5 10 80       	push   $0x8010b580
8010206e:	e8 ad 2f 00 00       	call   80105020 <acquire>

  if((b = idequeue) == 0){
80102073:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	85 db                	test   %ebx,%ebx
8010207e:	74 34                	je     801020b4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102080:	8b 43 58             	mov    0x58(%ebx),%eax
80102083:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102088:	8b 33                	mov    (%ebx),%esi
8010208a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102090:	74 3e                	je     801020d0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102092:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102095:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102098:	83 ce 02             	or     $0x2,%esi
8010209b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010209d:	53                   	push   %ebx
8010209e:	e8 4d 23 00 00       	call   801043f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020a3:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020a8:	83 c4 10             	add    $0x10,%esp
801020ab:	85 c0                	test   %eax,%eax
801020ad:	74 05                	je     801020b4 <ideintr+0x54>
    idestart(idequeue);
801020af:	e8 5c fe ff ff       	call   80101f10 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020b4:	83 ec 0c             	sub    $0xc,%esp
801020b7:	68 80 b5 10 80       	push   $0x8010b580
801020bc:	e8 0f 30 00 00       	call   801050d0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c4:	5b                   	pop    %ebx
801020c5:	5e                   	pop    %esi
801020c6:	5f                   	pop    %edi
801020c7:	5d                   	pop    %ebp
801020c8:	c3                   	ret    
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020d5:	8d 76 00             	lea    0x0(%esi),%esi
801020d8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d9:	89 c1                	mov    %eax,%ecx
801020db:	83 e1 c0             	and    $0xffffffc0,%ecx
801020de:	80 f9 40             	cmp    $0x40,%cl
801020e1:	75 f5                	jne    801020d8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020e3:	a8 21                	test   $0x21,%al
801020e5:	75 ab                	jne    80102092 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020e7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020ea:	b9 80 00 00 00       	mov    $0x80,%ecx
801020ef:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020f4:	fc                   	cld    
801020f5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f7:	8b 33                	mov    (%ebx),%esi
801020f9:	eb 97                	jmp    80102092 <ideintr+0x32>
801020fb:	90                   	nop
801020fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102100 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	53                   	push   %ebx
80102104:	83 ec 10             	sub    $0x10,%esp
80102107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010210a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010210d:	50                   	push   %eax
8010210e:	e8 5d 2d 00 00       	call   80104e70 <holdingsleep>
80102113:	83 c4 10             	add    $0x10,%esp
80102116:	85 c0                	test   %eax,%eax
80102118:	0f 84 ad 00 00 00    	je     801021cb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010211e:	8b 03                	mov    (%ebx),%eax
80102120:	83 e0 06             	and    $0x6,%eax
80102123:	83 f8 02             	cmp    $0x2,%eax
80102126:	0f 84 b9 00 00 00    	je     801021e5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010212c:	8b 53 04             	mov    0x4(%ebx),%edx
8010212f:	85 d2                	test   %edx,%edx
80102131:	74 0d                	je     80102140 <iderw+0x40>
80102133:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102138:	85 c0                	test   %eax,%eax
8010213a:	0f 84 98 00 00 00    	je     801021d8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	68 80 b5 10 80       	push   $0x8010b580
80102148:	e8 d3 2e 00 00       	call   80105020 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102153:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102156:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215d:	85 d2                	test   %edx,%edx
8010215f:	75 09                	jne    8010216a <iderw+0x6a>
80102161:	eb 58                	jmp    801021bb <iderw+0xbb>
80102163:	90                   	nop
80102164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102168:	89 c2                	mov    %eax,%edx
8010216a:	8b 42 58             	mov    0x58(%edx),%eax
8010216d:	85 c0                	test   %eax,%eax
8010216f:	75 f7                	jne    80102168 <iderw+0x68>
80102171:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102174:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102176:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010217c:	74 44                	je     801021c2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 e0 06             	and    $0x6,%eax
80102183:	83 f8 02             	cmp    $0x2,%eax
80102186:	74 23                	je     801021ab <iderw+0xab>
80102188:	90                   	nop
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102190:	83 ec 08             	sub    $0x8,%esp
80102193:	68 80 b5 10 80       	push   $0x8010b580
80102198:	53                   	push   %ebx
80102199:	e8 52 1d 00 00       	call   80103ef0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 c4 10             	add    $0x10,%esp
801021a3:	83 e0 06             	and    $0x6,%eax
801021a6:	83 f8 02             	cmp    $0x2,%eax
801021a9:	75 e5                	jne    80102190 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
801021ab:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021b5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021b6:	e9 15 2f 00 00       	jmp    801050d0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021c0:	eb b2                	jmp    80102174 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021c2:	89 d8                	mov    %ebx,%eax
801021c4:	e8 47 fd ff ff       	call   80101f10 <idestart>
801021c9:	eb b3                	jmp    8010217e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021cb:	83 ec 0c             	sub    $0xc,%esp
801021ce:	68 aa 7e 10 80       	push   $0x80107eaa
801021d3:	e8 98 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021d8:	83 ec 0c             	sub    $0xc,%esp
801021db:	68 d5 7e 10 80       	push   $0x80107ed5
801021e0:	e8 8b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021e5:	83 ec 0c             	sub    $0xc,%esp
801021e8:	68 c0 7e 10 80       	push   $0x80107ec0
801021ed:	e8 7e e1 ff ff       	call   80100370 <panic>
801021f2:	66 90                	xchg   %ax,%ax
801021f4:	66 90                	xchg   %ax,%ax
801021f6:	66 90                	xchg   %ax,%ax
801021f8:	66 90                	xchg   %ax,%ax
801021fa:	66 90                	xchg   %ax,%ax
801021fc:	66 90                	xchg   %ax,%ax
801021fe:	66 90                	xchg   %ax,%ax

80102200 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102200:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102201:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102208:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010220b:	89 e5                	mov    %esp,%ebp
8010220d:	56                   	push   %esi
8010220e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010220f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102216:	00 00 00 
  return ioapic->data;
80102219:	8b 15 54 36 11 80    	mov    0x80113654,%edx
8010221f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102222:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102228:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102235:	89 f0                	mov    %esi,%eax
80102237:	c1 e8 10             	shr    $0x10,%eax
8010223a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102240:	c1 e8 18             	shr    $0x18,%eax
80102243:	39 d0                	cmp    %edx,%eax
80102245:	74 16                	je     8010225d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102247:	83 ec 0c             	sub    $0xc,%esp
8010224a:	68 f4 7e 10 80       	push   $0x80107ef4
8010224f:	e8 0c e4 ff ff       	call   80100660 <cprintf>
80102254:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102260:	ba 10 00 00 00       	mov    $0x10,%edx
80102265:	b8 20 00 00 00       	mov    $0x20,%eax
8010226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102270:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102272:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102278:	89 c3                	mov    %eax,%ebx
8010227a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102280:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102283:	89 59 10             	mov    %ebx,0x10(%ecx)
80102286:	8d 5a 01             	lea    0x1(%edx),%ebx
80102289:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010228e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102290:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102296:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010229d:	75 d1                	jne    80102270 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010229f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022a2:	5b                   	pop    %ebx
801022a3:	5e                   	pop    %esi
801022a4:	5d                   	pop    %ebp
801022a5:	c3                   	ret    
801022a6:	8d 76 00             	lea    0x0(%esi),%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022b0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022b7:	89 e5                	mov    %esp,%ebp
801022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022bc:	8d 50 20             	lea    0x20(%eax),%edx
801022bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022c5:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ce:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022d6:	a1 54 36 11 80       	mov    0x80113654,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022db:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022de:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022e1:	5d                   	pop    %ebp
801022e2:	c3                   	ret    
801022e3:	66 90                	xchg   %ax,%ax
801022e5:	66 90                	xchg   %ax,%ax
801022e7:	66 90                	xchg   %ax,%ax
801022e9:	66 90                	xchg   %ax,%ax
801022eb:	66 90                	xchg   %ax,%ax
801022ed:	66 90                	xchg   %ax,%ax
801022ef:	90                   	nop

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 04             	sub    $0x4,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 70                	jne    80102372 <kfree+0x82>
80102302:	81 fb 28 43 12 80    	cmp    $0x80124328,%ebx
80102308:	72 68                	jb     80102372 <kfree+0x82>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 5b                	ja     80102372 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	83 ec 04             	sub    $0x4,%esp
8010231a:	68 00 10 00 00       	push   $0x1000
8010231f:	6a 01                	push   $0x1
80102321:	53                   	push   %ebx
80102322:	e8 09 2e 00 00       	call   80105130 <memset>

  if(kmem.use_lock)
80102327:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010232d:	83 c4 10             	add    $0x10,%esp
80102330:	85 d2                	test   %edx,%edx
80102332:	75 2c                	jne    80102360 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102334:	a1 98 36 11 80       	mov    0x80113698,%eax
80102339:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010233b:	a1 94 36 11 80       	mov    0x80113694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102340:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102346:	85 c0                	test   %eax,%eax
80102348:	75 06                	jne    80102350 <kfree+0x60>
    release(&kmem.lock);
}
8010234a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234d:	c9                   	leave  
8010234e:	c3                   	ret    
8010234f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102350:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010235a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010235b:	e9 70 2d 00 00       	jmp    801050d0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 60 36 11 80       	push   $0x80113660
80102368:	e8 b3 2c 00 00       	call   80105020 <acquire>
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	eb c2                	jmp    80102334 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102372:	83 ec 0c             	sub    $0xc,%esp
80102375:	68 26 7f 10 80       	push   $0x80107f26
8010237a:	e8 f1 df ff ff       	call   80100370 <panic>
8010237f:	90                   	nop

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102385:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102388:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102391:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102397:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010239d:	39 de                	cmp    %ebx,%esi
8010239f:	72 23                	jb     801023c4 <freerange+0x44>
801023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ae:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023b7:	50                   	push   %eax
801023b8:	e8 33 ff ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	39 f3                	cmp    %esi,%ebx
801023c2:	76 e4                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023c7:	5b                   	pop    %ebx
801023c8:	5e                   	pop    %esi
801023c9:	5d                   	pop    %ebp
801023ca:	c3                   	ret    
801023cb:	90                   	nop
801023cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023d8:	83 ec 08             	sub    $0x8,%esp
801023db:	68 2c 7f 10 80       	push   $0x80107f2c
801023e0:	68 60 36 11 80       	push   $0x80113660
801023e5:	e8 d6 2a 00 00       	call   80104ec0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f0:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
801023f7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102400:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102406:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010240c:	39 de                	cmp    %ebx,%esi
8010240e:	72 1c                	jb     8010242c <kinit1+0x5c>
    kfree(p);
80102410:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102416:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102419:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010241f:	50                   	push   %eax
80102420:	e8 cb fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102425:	83 c4 10             	add    $0x10,%esp
80102428:	39 de                	cmp    %ebx,%esi
8010242a:	73 e4                	jae    80102410 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010242f:	5b                   	pop    %ebx
80102430:	5e                   	pop    %esi
80102431:	5d                   	pop    %ebp
80102432:	c3                   	ret    
80102433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102445:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102448:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102451:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102457:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245d:	39 de                	cmp    %ebx,%esi
8010245f:	72 23                	jb     80102484 <kinit2+0x44>
80102461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102468:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010246e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102471:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102477:	50                   	push   %eax
80102478:	e8 73 fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 e4                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102484:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
8010248b:	00 00 00 
}
8010248e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102491:	5b                   	pop    %ebx
80102492:	5e                   	pop    %esi
80102493:	5d                   	pop    %ebp
80102494:	c3                   	ret    
80102495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 94 36 11 80       	mov    0x80113694,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 98 36 11 80    	mov    0x80113698,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 1c                	je     801024d6 <kalloc+0x36>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 10                	je     801024d6 <kalloc+0x36>
    release(&kmem.lock);
801024c6:	83 ec 0c             	sub    $0xc,%esp
801024c9:	68 60 36 11 80       	push   $0x80113660
801024ce:	e8 fd 2b 00 00       	call   801050d0 <release>
801024d3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024d6:	89 d8                	mov    %ebx,%eax
801024d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024db:	c9                   	leave  
801024dc:	c3                   	ret    
801024dd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	68 60 36 11 80       	push   $0x80113660
801024e8:	e8 33 2b 00 00       	call   80105020 <acquire>
  r = kmem.freelist;
801024ed:	8b 1d 98 36 11 80    	mov    0x80113698,%ebx
  if(r)
801024f3:	83 c4 10             	add    $0x10,%esp
801024f6:	a1 94 36 11 80       	mov    0x80113694,%eax
801024fb:	85 db                	test   %ebx,%ebx
801024fd:	75 bb                	jne    801024ba <kalloc+0x1a>
801024ff:	eb c1                	jmp    801024c2 <kalloc+0x22>
80102501:	66 90                	xchg   %ax,%ax
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102510:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102511:	ba 64 00 00 00       	mov    $0x64,%edx
80102516:	89 e5                	mov    %esp,%ebp
80102518:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102519:	a8 01                	test   $0x1,%al
8010251b:	0f 84 af 00 00 00    	je     801025d0 <kbdgetc+0xc0>
80102521:	ba 60 00 00 00       	mov    $0x60,%edx
80102526:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102527:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010252a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102530:	74 7e                	je     801025b0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102532:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010253a:	79 24                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010253c:	f6 c1 40             	test   $0x40,%cl
8010253f:	75 05                	jne    80102546 <kbdgetc+0x36>
80102541:	89 c2                	mov    %eax,%edx
80102543:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102546:	0f b6 82 60 80 10 80 	movzbl -0x7fef7fa0(%edx),%eax
8010254d:	83 c8 40             	or     $0x40,%eax
80102550:	0f b6 c0             	movzbl %al,%eax
80102553:	f7 d0                	not    %eax
80102555:	21 c8                	and    %ecx,%eax
80102557:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010255c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010255e:	5d                   	pop    %ebp
8010255f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102560:	f6 c1 40             	test   $0x40,%cl
80102563:	74 09                	je     8010256e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102565:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102568:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010256e:	0f b6 82 60 80 10 80 	movzbl -0x7fef7fa0(%edx),%eax
80102575:	09 c1                	or     %eax,%ecx
80102577:	0f b6 82 60 7f 10 80 	movzbl -0x7fef80a0(%edx),%eax
8010257e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102580:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102582:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102588:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010258b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010258e:	8b 04 85 40 7f 10 80 	mov    -0x7fef80c0(,%eax,4),%eax
80102595:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102599:	74 c3                	je     8010255e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010259b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010259e:	83 fa 19             	cmp    $0x19,%edx
801025a1:	77 1d                	ja     801025c0 <kbdgetc+0xb0>
      c += 'A' - 'a';
801025a3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a6:	5d                   	pop    %ebp
801025a7:	c3                   	ret    
801025a8:	90                   	nop
801025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801025b0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025b2:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	90                   	nop
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025c0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025c3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025c6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025c7:	83 f9 19             	cmp    $0x19,%ecx
801025ca:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025d5:	5d                   	pop    %ebp
801025d6:	c3                   	ret    
801025d7:	89 f6                	mov    %esi,%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025e6:	68 10 25 10 80       	push   $0x80102510
801025eb:	e8 00 e2 ff ff       	call   801007f0 <consoleintr>
}
801025f0:	83 c4 10             	add    $0x10,%esp
801025f3:	c9                   	leave  
801025f4:	c3                   	ret    
801025f5:	66 90                	xchg   %ax,%ax
801025f7:	66 90                	xchg   %ax,%ax
801025f9:	66 90                	xchg   %ax,%ax
801025fb:	66 90                	xchg   %ax,%ax
801025fd:	66 90                	xchg   %ax,%ax
801025ff:	90                   	nop

80102600 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102600:	a1 9c 36 11 80       	mov    0x8011369c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102608:	85 c0                	test   %eax,%eax
8010260a:	0f 84 c8 00 00 00    	je     801026d8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102610:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102617:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010261a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010261d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102624:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102627:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010262a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102631:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102634:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102637:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010263e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102641:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102644:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010264b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102651:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102658:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010265b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010265e:	8b 50 30             	mov    0x30(%eax),%edx
80102661:	c1 ea 10             	shr    $0x10,%edx
80102664:	80 fa 03             	cmp    $0x3,%dl
80102667:	77 77                	ja     801026e0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102669:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102670:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102673:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102676:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102680:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102683:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010268a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102690:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102697:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
801026b7:	89 f6                	mov    %esi,%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026c6:	80 e6 10             	and    $0x10,%dh
801026c9:	75 f5                	jne    801026c0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026d8:	5d                   	pop    %ebp
801026d9:	c3                   	ret    
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
801026ed:	e9 77 ff ff ff       	jmp    80102669 <lapicinit+0x69>
801026f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102700:	a1 9c 36 11 80       	mov    0x8011369c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102705:	55                   	push   %ebp
80102706:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102708:	85 c0                	test   %eax,%eax
8010270a:	74 0c                	je     80102718 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010270c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010270f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102710:	c1 e8 18             	shr    $0x18,%eax
}
80102713:	c3                   	ret    
80102714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102718:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010271a:	5d                   	pop    %ebp
8010271b:	c3                   	ret    
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102720:	a1 9c 36 11 80       	mov    0x8011369c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102725:	55                   	push   %ebp
80102726:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102728:	85 c0                	test   %eax,%eax
8010272a:	74 0d                	je     80102739 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010272c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102733:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102736:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102739:	5d                   	pop    %ebp
8010273a:	c3                   	ret    
8010273b:	90                   	nop
8010273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102740 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
}
80102743:	5d                   	pop    %ebp
80102744:	c3                   	ret    
80102745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102750:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102751:	ba 70 00 00 00       	mov    $0x70,%edx
80102756:	b8 0f 00 00 00       	mov    $0xf,%eax
8010275b:	89 e5                	mov    %esp,%ebp
8010275d:	53                   	push   %ebx
8010275e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102761:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102764:	ee                   	out    %al,(%dx)
80102765:	ba 71 00 00 00       	mov    $0x71,%edx
8010276a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010276f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102770:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102772:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102775:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010277b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010277d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102780:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102783:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102785:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102788:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278e:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102793:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102799:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027bc:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ce:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027da:	5b                   	pop    %ebx
801027db:	5d                   	pop    %ebp
801027dc:	c3                   	ret    
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801027e0:	55                   	push   %ebp
801027e1:	ba 70 00 00 00       	mov    $0x70,%edx
801027e6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027eb:	89 e5                	mov    %esp,%ebp
801027ed:	57                   	push   %edi
801027ee:	56                   	push   %esi
801027ef:	53                   	push   %ebx
801027f0:	83 ec 4c             	sub    $0x4c,%esp
801027f3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f4:	ba 71 00 00 00       	mov    $0x71,%edx
801027f9:	ec                   	in     (%dx),%al
801027fa:	83 e0 04             	and    $0x4,%eax
801027fd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102800:	31 db                	xor    %ebx,%ebx
80102802:	88 45 b7             	mov    %al,-0x49(%ebp)
80102805:	bf 70 00 00 00       	mov    $0x70,%edi
8010280a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102810:	89 d8                	mov    %ebx,%eax
80102812:	89 fa                	mov    %edi,%edx
80102814:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102815:	b9 71 00 00 00       	mov    $0x71,%ecx
8010281a:	89 ca                	mov    %ecx,%edx
8010281c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010281d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102820:	89 fa                	mov    %edi,%edx
80102822:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102825:	b8 02 00 00 00       	mov    $0x2,%eax
8010282a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282b:	89 ca                	mov    %ecx,%edx
8010282d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010282e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102831:	89 fa                	mov    %edi,%edx
80102833:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102836:	b8 04 00 00 00       	mov    $0x4,%eax
8010283b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283c:	89 ca                	mov    %ecx,%edx
8010283e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010283f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102842:	89 fa                	mov    %edi,%edx
80102844:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102847:	b8 07 00 00 00       	mov    $0x7,%eax
8010284c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284d:	89 ca                	mov    %ecx,%edx
8010284f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102850:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102853:	89 fa                	mov    %edi,%edx
80102855:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102858:	b8 08 00 00 00       	mov    $0x8,%eax
8010285d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102861:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 fa                	mov    %edi,%edx
80102866:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102869:	b8 09 00 00 00       	mov    $0x9,%eax
8010286e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286f:	89 ca                	mov    %ecx,%edx
80102871:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102872:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102875:	89 fa                	mov    %edi,%edx
80102877:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010287a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010287f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102880:	89 ca                	mov    %ecx,%edx
80102882:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102883:	84 c0                	test   %al,%al
80102885:	78 89                	js     80102810 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102887:	89 d8                	mov    %ebx,%eax
80102889:	89 fa                	mov    %edi,%edx
8010288b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	89 ca                	mov    %ecx,%edx
8010288e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010288f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102892:	89 fa                	mov    %edi,%edx
80102894:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102897:	b8 02 00 00 00       	mov    $0x2,%eax
8010289c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289d:	89 ca                	mov    %ecx,%edx
8010289f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028a0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a3:	89 fa                	mov    %edi,%edx
801028a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028a8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ad:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ae:	89 ca                	mov    %ecx,%edx
801028b0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028b1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b4:	89 fa                	mov    %edi,%edx
801028b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028b9:	b8 07 00 00 00       	mov    $0x7,%eax
801028be:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bf:	89 ca                	mov    %ecx,%edx
801028c1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028c2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c5:	89 fa                	mov    %edi,%edx
801028c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028ca:	b8 08 00 00 00       	mov    $0x8,%eax
801028cf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	89 ca                	mov    %ecx,%edx
801028d2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028d3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d6:	89 fa                	mov    %edi,%edx
801028d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028db:	b8 09 00 00 00       	mov    $0x9,%eax
801028e0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e1:	89 ca                	mov    %ecx,%edx
801028e3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028e4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028e7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028ed:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028f0:	6a 18                	push   $0x18
801028f2:	56                   	push   %esi
801028f3:	50                   	push   %eax
801028f4:	e8 87 28 00 00       	call   80105180 <memcmp>
801028f9:	83 c4 10             	add    $0x10,%esp
801028fc:	85 c0                	test   %eax,%eax
801028fe:	0f 85 0c ff ff ff    	jne    80102810 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102904:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102908:	75 78                	jne    80102982 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010290a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010290d:	89 c2                	mov    %eax,%edx
8010290f:	83 e0 0f             	and    $0xf,%eax
80102912:	c1 ea 04             	shr    $0x4,%edx
80102915:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102918:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010291e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102921:	89 c2                	mov    %eax,%edx
80102923:	83 e0 0f             	and    $0xf,%eax
80102926:	c1 ea 04             	shr    $0x4,%edx
80102929:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102932:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102935:	89 c2                	mov    %eax,%edx
80102937:	83 e0 0f             	and    $0xf,%eax
8010293a:	c1 ea 04             	shr    $0x4,%edx
8010293d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102940:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102943:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102946:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102949:	89 c2                	mov    %eax,%edx
8010294b:	83 e0 0f             	and    $0xf,%eax
8010294e:	c1 ea 04             	shr    $0x4,%edx
80102951:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102954:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102957:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010295a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010295d:	89 c2                	mov    %eax,%edx
8010295f:	83 e0 0f             	and    $0xf,%eax
80102962:	c1 ea 04             	shr    $0x4,%edx
80102965:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102968:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010296e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102971:	89 c2                	mov    %eax,%edx
80102973:	83 e0 0f             	and    $0xf,%eax
80102976:	c1 ea 04             	shr    $0x4,%edx
80102979:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102982:	8b 75 08             	mov    0x8(%ebp),%esi
80102985:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102988:	89 06                	mov    %eax,(%esi)
8010298a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010298d:	89 46 04             	mov    %eax,0x4(%esi)
80102990:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102993:	89 46 08             	mov    %eax,0x8(%esi)
80102996:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102999:	89 46 0c             	mov    %eax,0xc(%esi)
8010299c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010299f:	89 46 10             	mov    %eax,0x10(%esi)
801029a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029a5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029a8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029b2:	5b                   	pop    %ebx
801029b3:	5e                   	pop    %esi
801029b4:	5f                   	pop    %edi
801029b5:	5d                   	pop    %ebp
801029b6:	c3                   	ret    
801029b7:	66 90                	xchg   %ax,%ax
801029b9:	66 90                	xchg   %ax,%ax
801029bb:	66 90                	xchg   %ax,%ax
801029bd:	66 90                	xchg   %ax,%ax
801029bf:	90                   	nop

801029c0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029c0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
801029c6:	85 c9                	test   %ecx,%ecx
801029c8:	0f 8e 85 00 00 00    	jle    80102a53 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029ce:	55                   	push   %ebp
801029cf:	89 e5                	mov    %esp,%ebp
801029d1:	57                   	push   %edi
801029d2:	56                   	push   %esi
801029d3:	53                   	push   %ebx
801029d4:	31 db                	xor    %ebx,%ebx
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029e0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
801029e5:	83 ec 08             	sub    $0x8,%esp
801029e8:	01 d8                	add    %ebx,%eax
801029ea:	83 c0 01             	add    $0x1,%eax
801029ed:	50                   	push   %eax
801029ee:	ff 35 e4 36 11 80    	pushl  0x801136e4
801029f4:	e8 d7 d6 ff ff       	call   801000d0 <bread>
801029f9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029fb:	58                   	pop    %eax
801029fc:	5a                   	pop    %edx
801029fd:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102a04:	ff 35 e4 36 11 80    	pushl  0x801136e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a0d:	e8 be d6 ff ff       	call   801000d0 <bread>
80102a12:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a14:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a17:	83 c4 0c             	add    $0xc,%esp
80102a1a:	68 00 02 00 00       	push   $0x200
80102a1f:	50                   	push   %eax
80102a20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a23:	50                   	push   %eax
80102a24:	e8 b7 27 00 00       	call   801051e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a29:	89 34 24             	mov    %esi,(%esp)
80102a2c:	e8 6f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a31:	89 3c 24             	mov    %edi,(%esp)
80102a34:	e8 a7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a39:	89 34 24             	mov    %esi,(%esp)
80102a3c:	e8 9f d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a41:	83 c4 10             	add    $0x10,%esp
80102a44:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102a4a:	7f 94                	jg     801029e0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a4f:	5b                   	pop    %ebx
80102a50:	5e                   	pop    %esi
80102a51:	5f                   	pop    %edi
80102a52:	5d                   	pop    %ebp
80102a53:	f3 c3                	repz ret 
80102a55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	53                   	push   %ebx
80102a64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a67:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102a6d:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102a73:	e8 58 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a78:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a7e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a81:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a83:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a85:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a88:	7e 1f                	jle    80102aa9 <write_head+0x49>
80102a8a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a91:	31 d2                	xor    %edx,%edx
80102a93:	90                   	nop
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a98:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102a9e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102aa2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102aa5:	39 c2                	cmp    %eax,%edx
80102aa7:	75 ef                	jne    80102a98 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102aa9:	83 ec 0c             	sub    $0xc,%esp
80102aac:	53                   	push   %ebx
80102aad:	e8 ee d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ab2:	89 1c 24             	mov    %ebx,(%esp)
80102ab5:	e8 26 d7 ff ff       	call   801001e0 <brelse>
}
80102aba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102abd:	c9                   	leave  
80102abe:	c3                   	ret    
80102abf:	90                   	nop

80102ac0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	53                   	push   %ebx
80102ac4:	83 ec 2c             	sub    $0x2c,%esp
80102ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aca:	68 60 81 10 80       	push   $0x80108160
80102acf:	68 a0 36 11 80       	push   $0x801136a0
80102ad4:	e8 e7 23 00 00       	call   80104ec0 <initlock>
  readsb(dev, &sb);
80102ad9:	58                   	pop    %eax
80102ada:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102add:	5a                   	pop    %edx
80102ade:	50                   	push   %eax
80102adf:	53                   	push   %ebx
80102ae0:	e8 db e8 ff ff       	call   801013c0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ae5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aeb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102aec:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102af2:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102af8:	a3 d4 36 11 80       	mov    %eax,0x801136d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102afd:	5a                   	pop    %edx
80102afe:	50                   	push   %eax
80102aff:	53                   	push   %ebx
80102b00:	e8 cb d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b05:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b08:	83 c4 10             	add    $0x10,%esp
80102b0b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b0d:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102b13:	7e 1c                	jle    80102b31 <initlog+0x71>
80102b15:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b1c:	31 d2                	xor    %edx,%edx
80102b1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b20:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b24:	83 c2 04             	add    $0x4,%edx
80102b27:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b2d:	39 da                	cmp    %ebx,%edx
80102b2f:	75 ef                	jne    80102b20 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b31:	83 ec 0c             	sub    $0xc,%esp
80102b34:	50                   	push   %eax
80102b35:	e8 a6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b3a:	e8 81 fe ff ff       	call   801029c0 <install_trans>
  log.lh.n = 0;
80102b3f:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102b46:	00 00 00 
  write_head(); // clear the log
80102b49:	e8 12 ff ff ff       	call   80102a60 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b51:	c9                   	leave  
80102b52:	c3                   	ret    
80102b53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b66:	68 a0 36 11 80       	push   $0x801136a0
80102b6b:	e8 b0 24 00 00       	call   80105020 <acquire>
80102b70:	83 c4 10             	add    $0x10,%esp
80102b73:	eb 18                	jmp    80102b8d <begin_op+0x2d>
80102b75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b78:	83 ec 08             	sub    $0x8,%esp
80102b7b:	68 a0 36 11 80       	push   $0x801136a0
80102b80:	68 a0 36 11 80       	push   $0x801136a0
80102b85:	e8 66 13 00 00       	call   80103ef0 <sleep>
80102b8a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b8d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102b92:	85 c0                	test   %eax,%eax
80102b94:	75 e2                	jne    80102b78 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b96:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102b9b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102ba1:	83 c0 01             	add    $0x1,%eax
80102ba4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ba7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102baa:	83 fa 1e             	cmp    $0x1e,%edx
80102bad:	7f c9                	jg     80102b78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102baf:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102bb2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102bb7:	68 a0 36 11 80       	push   $0x801136a0
80102bbc:	e8 0f 25 00 00       	call   801050d0 <release>
      break;
    }
  }
}
80102bc1:	83 c4 10             	add    $0x10,%esp
80102bc4:	c9                   	leave  
80102bc5:	c3                   	ret    
80102bc6:	8d 76 00             	lea    0x0(%esi),%esi
80102bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	57                   	push   %edi
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bd9:	68 a0 36 11 80       	push   $0x801136a0
80102bde:	e8 3d 24 00 00       	call   80105020 <acquire>
  log.outstanding -= 1;
80102be3:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102be8:	8b 1d e0 36 11 80    	mov    0x801136e0,%ebx
80102bee:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bf1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bf4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bf6:	a3 dc 36 11 80       	mov    %eax,0x801136dc
  if(log.committing)
80102bfb:	0f 85 23 01 00 00    	jne    80102d24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c01:	85 c0                	test   %eax,%eax
80102c03:	0f 85 f7 00 00 00    	jne    80102d00 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c09:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c0c:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102c13:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c16:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c18:	68 a0 36 11 80       	push   $0x801136a0
80102c1d:	e8 ae 24 00 00       	call   801050d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c22:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102c28:	83 c4 10             	add    $0x10,%esp
80102c2b:	85 c9                	test   %ecx,%ecx
80102c2d:	0f 8e 8a 00 00 00    	jle    80102cbd <end_op+0xed>
80102c33:	90                   	nop
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c38:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102c3d:	83 ec 08             	sub    $0x8,%esp
80102c40:	01 d8                	add    %ebx,%eax
80102c42:	83 c0 01             	add    $0x1,%eax
80102c45:	50                   	push   %eax
80102c46:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102c4c:	e8 7f d4 ff ff       	call   801000d0 <bread>
80102c51:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c53:	58                   	pop    %eax
80102c54:	5a                   	pop    %edx
80102c55:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102c5c:	ff 35 e4 36 11 80    	pushl  0x801136e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c62:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c65:	e8 66 d4 ff ff       	call   801000d0 <bread>
80102c6a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c6c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c6f:	83 c4 0c             	add    $0xc,%esp
80102c72:	68 00 02 00 00       	push   $0x200
80102c77:	50                   	push   %eax
80102c78:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c7b:	50                   	push   %eax
80102c7c:	e8 5f 25 00 00       	call   801051e0 <memmove>
    bwrite(to);  // write the log
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 17 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c89:	89 3c 24             	mov    %edi,(%esp)
80102c8c:	e8 4f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c91:	89 34 24             	mov    %esi,(%esp)
80102c94:	e8 47 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c99:	83 c4 10             	add    $0x10,%esp
80102c9c:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102ca2:	7c 94                	jl     80102c38 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ca4:	e8 b7 fd ff ff       	call   80102a60 <write_head>
    install_trans(); // Now install writes to home locations
80102ca9:	e8 12 fd ff ff       	call   801029c0 <install_trans>
    log.lh.n = 0;
80102cae:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102cb5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cb8:	e8 a3 fd ff ff       	call   80102a60 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cbd:	83 ec 0c             	sub    $0xc,%esp
80102cc0:	68 a0 36 11 80       	push   $0x801136a0
80102cc5:	e8 56 23 00 00       	call   80105020 <acquire>
    log.committing = 0;
    wakeup(&log);
80102cca:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cd1:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102cd8:	00 00 00 
    wakeup(&log);
80102cdb:	e8 10 17 00 00       	call   801043f0 <wakeup>
    release(&log.lock);
80102ce0:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102ce7:	e8 e4 23 00 00       	call   801050d0 <release>
80102cec:	83 c4 10             	add    $0x10,%esp
  }
}
80102cef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cf2:	5b                   	pop    %ebx
80102cf3:	5e                   	pop    %esi
80102cf4:	5f                   	pop    %edi
80102cf5:	5d                   	pop    %ebp
80102cf6:	c3                   	ret    
80102cf7:	89 f6                	mov    %esi,%esi
80102cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102d00:	83 ec 0c             	sub    $0xc,%esp
80102d03:	68 a0 36 11 80       	push   $0x801136a0
80102d08:	e8 e3 16 00 00       	call   801043f0 <wakeup>
  }
  release(&log.lock);
80102d0d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d14:	e8 b7 23 00 00       	call   801050d0 <release>
80102d19:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d1f:	5b                   	pop    %ebx
80102d20:	5e                   	pop    %esi
80102d21:	5f                   	pop    %edi
80102d22:	5d                   	pop    %ebp
80102d23:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d24:	83 ec 0c             	sub    $0xc,%esp
80102d27:	68 64 81 10 80       	push   $0x80108164
80102d2c:	e8 3f d6 ff ff       	call   80100370 <panic>
80102d31:	eb 0d                	jmp    80102d40 <log_write>
80102d33:	90                   	nop
80102d34:	90                   	nop
80102d35:	90                   	nop
80102d36:	90                   	nop
80102d37:	90                   	nop
80102d38:	90                   	nop
80102d39:	90                   	nop
80102d3a:	90                   	nop
80102d3b:	90                   	nop
80102d3c:	90                   	nop
80102d3d:	90                   	nop
80102d3e:	90                   	nop
80102d3f:	90                   	nop

80102d40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d47:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d50:	83 fa 1d             	cmp    $0x1d,%edx
80102d53:	0f 8f 97 00 00 00    	jg     80102df0 <log_write+0xb0>
80102d59:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102d5e:	83 e8 01             	sub    $0x1,%eax
80102d61:	39 c2                	cmp    %eax,%edx
80102d63:	0f 8d 87 00 00 00    	jge    80102df0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d69:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d6e:	85 c0                	test   %eax,%eax
80102d70:	0f 8e 87 00 00 00    	jle    80102dfd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d76:	83 ec 0c             	sub    $0xc,%esp
80102d79:	68 a0 36 11 80       	push   $0x801136a0
80102d7e:	e8 9d 22 00 00       	call   80105020 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d83:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102d89:	83 c4 10             	add    $0x10,%esp
80102d8c:	83 fa 00             	cmp    $0x0,%edx
80102d8f:	7e 50                	jle    80102de1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d91:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d94:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d96:	3b 0d ec 36 11 80    	cmp    0x801136ec,%ecx
80102d9c:	75 0b                	jne    80102da9 <log_write+0x69>
80102d9e:	eb 38                	jmp    80102dd8 <log_write+0x98>
80102da0:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102da7:	74 2f                	je     80102dd8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102da9:	83 c0 01             	add    $0x1,%eax
80102dac:	39 d0                	cmp    %edx,%eax
80102dae:	75 f0                	jne    80102da0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102db7:	83 c2 01             	add    $0x1,%edx
80102dba:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102dc0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102dc3:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dcd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dce:	e9 fd 22 00 00       	jmp    801050d0 <release>
80102dd3:	90                   	nop
80102dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dd8:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
80102ddf:	eb df                	jmp    80102dc0 <log_write+0x80>
80102de1:	8b 43 08             	mov    0x8(%ebx),%eax
80102de4:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102de9:	75 d5                	jne    80102dc0 <log_write+0x80>
80102deb:	eb ca                	jmp    80102db7 <log_write+0x77>
80102ded:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102df0:	83 ec 0c             	sub    $0xc,%esp
80102df3:	68 73 81 10 80       	push   $0x80108173
80102df8:	e8 73 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dfd:	83 ec 0c             	sub    $0xc,%esp
80102e00:	68 89 81 10 80       	push   $0x80108189
80102e05:	e8 66 d5 ff ff       	call   80100370 <panic>
80102e0a:	66 90                	xchg   %ax,%ax
80102e0c:	66 90                	xchg   %ax,%ax
80102e0e:	66 90                	xchg   %ax,%ax

80102e10 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e17:	e8 64 0a 00 00       	call   80103880 <cpuid>
80102e1c:	89 c3                	mov    %eax,%ebx
80102e1e:	e8 5d 0a 00 00       	call   80103880 <cpuid>
80102e23:	83 ec 04             	sub    $0x4,%esp
80102e26:	53                   	push   %ebx
80102e27:	50                   	push   %eax
80102e28:	68 a4 81 10 80       	push   $0x801081a4
80102e2d:	e8 2e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e32:	e8 79 36 00 00       	call   801064b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e37:	e8 c4 09 00 00       	call   80103800 <mycpu>
80102e3c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e3e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e43:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e4a:	e8 51 0e 00 00       	call   80103ca0 <scheduler>
80102e4f:	90                   	nop

80102e50 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e56:	e8 75 47 00 00       	call   801075d0 <switchkvm>
  seginit();
80102e5b:	e8 70 46 00 00       	call   801074d0 <seginit>
  lapicinit();
80102e60:	e8 9b f7 ff ff       	call   80102600 <lapicinit>
  mpmain();
80102e65:	e8 a6 ff ff ff       	call   80102e10 <mpmain>
80102e6a:	66 90                	xchg   %ax,%ax
80102e6c:	66 90                	xchg   %ax,%ax
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e70:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e74:	83 e4 f0             	and    $0xfffffff0,%esp
80102e77:	ff 71 fc             	pushl  -0x4(%ecx)
80102e7a:	55                   	push   %ebp
80102e7b:	89 e5                	mov    %esp,%ebp
80102e7d:	53                   	push   %ebx
80102e7e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e7f:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e84:	83 ec 08             	sub    $0x8,%esp
80102e87:	68 00 00 40 80       	push   $0x80400000
80102e8c:	68 28 43 12 80       	push   $0x80124328
80102e91:	e8 3a f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e96:	e8 e5 4b 00 00       	call   80107a80 <kvmalloc>
  mpinit();        // detect other processors
80102e9b:	e8 70 01 00 00       	call   80103010 <mpinit>
  lapicinit();     // interrupt controller
80102ea0:	e8 5b f7 ff ff       	call   80102600 <lapicinit>
  seginit();       // segment descriptors
80102ea5:	e8 26 46 00 00       	call   801074d0 <seginit>
  picinit();       // disable pic
80102eaa:	e8 31 03 00 00       	call   801031e0 <picinit>
  ioapicinit();    // another interrupt controller
80102eaf:	e8 4c f3 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102eb4:	e8 e7 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102eb9:	e8 e2 38 00 00       	call   801067a0 <uartinit>
  pinit();         // process table
80102ebe:	e8 8d 08 00 00       	call   80103750 <pinit>
  tvinit();        // trap vectors
80102ec3:	e8 48 35 00 00       	call   80106410 <tvinit>
  binit();         // buffer cache
80102ec8:	e8 73 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ecd:	e8 8e de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102ed2:	e8 09 f1 ff ff       	call   80101fe0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ed7:	83 c4 0c             	add    $0xc,%esp
80102eda:	68 8a 00 00 00       	push   $0x8a
80102edf:	68 8c b4 10 80       	push   $0x8010b48c
80102ee4:	68 00 70 00 80       	push   $0x80007000
80102ee9:	e8 f2 22 00 00       	call   801051e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102eee:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80102ef5:	00 00 00 
80102ef8:	83 c4 10             	add    $0x10,%esp
80102efb:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f00:	39 d8                	cmp    %ebx,%eax
80102f02:	76 6f                	jbe    80102f73 <main+0x103>
80102f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f08:	e8 f3 08 00 00       	call   80103800 <mycpu>
80102f0d:	39 d8                	cmp    %ebx,%eax
80102f0f:	74 49                	je     80102f5a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f11:	e8 8a f5 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f16:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f1b:	c7 05 f8 6f 00 80 50 	movl   $0x80102e50,0x80006ff8
80102f22:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f25:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f2c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f2f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f34:	0f b6 03             	movzbl (%ebx),%eax
80102f37:	83 ec 08             	sub    $0x8,%esp
80102f3a:	68 00 70 00 00       	push   $0x7000
80102f3f:	50                   	push   %eax
80102f40:	e8 0b f8 ff ff       	call   80102750 <lapicstartap>
80102f45:	83 c4 10             	add    $0x10,%esp
80102f48:	90                   	nop
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f50:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f56:	85 c0                	test   %eax,%eax
80102f58:	74 f6                	je     80102f50 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f5a:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80102f61:	00 00 00 
80102f64:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80102f6a:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f6f:	39 c3                	cmp    %eax,%ebx
80102f71:	72 95                	jb     80102f08 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f73:	83 ec 08             	sub    $0x8,%esp
80102f76:	68 00 00 00 8e       	push   $0x8e000000
80102f7b:	68 00 00 40 80       	push   $0x80400000
80102f80:	e8 bb f4 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102f85:	e8 76 09 00 00       	call   80103900 <userinit>
  mpmain();        // finish this processor's setup
80102f8a:	e8 81 fe ff ff       	call   80102e10 <mpmain>
80102f8f:	90                   	nop

80102f90 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f95:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f9b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f9c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f9f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fa2:	39 de                	cmp    %ebx,%esi
80102fa4:	73 48                	jae    80102fee <mpsearch1+0x5e>
80102fa6:	8d 76 00             	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fb0:	83 ec 04             	sub    $0x4,%esp
80102fb3:	8d 7e 10             	lea    0x10(%esi),%edi
80102fb6:	6a 04                	push   $0x4
80102fb8:	68 b8 81 10 80       	push   $0x801081b8
80102fbd:	56                   	push   %esi
80102fbe:	e8 bd 21 00 00       	call   80105180 <memcmp>
80102fc3:	83 c4 10             	add    $0x10,%esp
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	75 1e                	jne    80102fe8 <mpsearch1+0x58>
80102fca:	8d 7e 10             	lea    0x10(%esi),%edi
80102fcd:	89 f2                	mov    %esi,%edx
80102fcf:	31 c9                	xor    %ecx,%ecx
80102fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fd8:	0f b6 02             	movzbl (%edx),%eax
80102fdb:	83 c2 01             	add    $0x1,%edx
80102fde:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fe0:	39 fa                	cmp    %edi,%edx
80102fe2:	75 f4                	jne    80102fd8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe4:	84 c9                	test   %cl,%cl
80102fe6:	74 10                	je     80102ff8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe8:	39 fb                	cmp    %edi,%ebx
80102fea:	89 fe                	mov    %edi,%esi
80102fec:	77 c2                	ja     80102fb0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102ff1:	31 c0                	xor    %eax,%eax
}
80102ff3:	5b                   	pop    %ebx
80102ff4:	5e                   	pop    %esi
80102ff5:	5f                   	pop    %edi
80102ff6:	5d                   	pop    %ebp
80102ff7:	c3                   	ret    
80102ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ffb:	89 f0                	mov    %esi,%eax
80102ffd:	5b                   	pop    %ebx
80102ffe:	5e                   	pop    %esi
80102fff:	5f                   	pop    %edi
80103000:	5d                   	pop    %ebp
80103001:	c3                   	ret    
80103002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103010 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103019:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103020:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103027:	c1 e0 08             	shl    $0x8,%eax
8010302a:	09 d0                	or     %edx,%eax
8010302c:	c1 e0 04             	shl    $0x4,%eax
8010302f:	85 c0                	test   %eax,%eax
80103031:	75 1b                	jne    8010304e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103033:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010303a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103041:	c1 e0 08             	shl    $0x8,%eax
80103044:	09 d0                	or     %edx,%eax
80103046:	c1 e0 0a             	shl    $0xa,%eax
80103049:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010304e:	ba 00 04 00 00       	mov    $0x400,%edx
80103053:	e8 38 ff ff ff       	call   80102f90 <mpsearch1>
80103058:	85 c0                	test   %eax,%eax
8010305a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010305d:	0f 84 37 01 00 00    	je     8010319a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103066:	8b 58 04             	mov    0x4(%eax),%ebx
80103069:	85 db                	test   %ebx,%ebx
8010306b:	0f 84 43 01 00 00    	je     801031b4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103071:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103077:	83 ec 04             	sub    $0x4,%esp
8010307a:	6a 04                	push   $0x4
8010307c:	68 bd 81 10 80       	push   $0x801081bd
80103081:	56                   	push   %esi
80103082:	e8 f9 20 00 00       	call   80105180 <memcmp>
80103087:	83 c4 10             	add    $0x10,%esp
8010308a:	85 c0                	test   %eax,%eax
8010308c:	0f 85 22 01 00 00    	jne    801031b4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103092:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103099:	3c 01                	cmp    $0x1,%al
8010309b:	74 08                	je     801030a5 <mpinit+0x95>
8010309d:	3c 04                	cmp    $0x4,%al
8010309f:	0f 85 0f 01 00 00    	jne    801031b4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030a5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030ac:	85 ff                	test   %edi,%edi
801030ae:	74 21                	je     801030d1 <mpinit+0xc1>
801030b0:	31 d2                	xor    %edx,%edx
801030b2:	31 c0                	xor    %eax,%eax
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030b8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030bf:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030c0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030c3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030c5:	39 c7                	cmp    %eax,%edi
801030c7:	75 ef                	jne    801030b8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030c9:	84 d2                	test   %dl,%dl
801030cb:	0f 85 e3 00 00 00    	jne    801031b4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030d1:	85 f6                	test   %esi,%esi
801030d3:	0f 84 db 00 00 00    	je     801031b4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030d9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030df:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030e4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030eb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030f1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f6:	01 d6                	add    %edx,%esi
801030f8:	90                   	nop
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	39 c6                	cmp    %eax,%esi
80103102:	76 23                	jbe    80103127 <mpinit+0x117>
80103104:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103107:	80 fa 04             	cmp    $0x4,%dl
8010310a:	0f 87 c0 00 00 00    	ja     801031d0 <mpinit+0x1c0>
80103110:	ff 24 95 fc 81 10 80 	jmp    *-0x7fef7e04(,%edx,4)
80103117:	89 f6                	mov    %esi,%esi
80103119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103120:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103123:	39 c6                	cmp    %eax,%esi
80103125:	77 dd                	ja     80103104 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103127:	85 db                	test   %ebx,%ebx
80103129:	0f 84 92 00 00 00    	je     801031c1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010312f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103132:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103136:	74 15                	je     8010314d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103138:	ba 22 00 00 00       	mov    $0x22,%edx
8010313d:	b8 70 00 00 00       	mov    $0x70,%eax
80103142:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103143:	ba 23 00 00 00       	mov    $0x23,%edx
80103148:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103149:	83 c8 01             	or     $0x1,%eax
8010314c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010314d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103150:	5b                   	pop    %ebx
80103151:	5e                   	pop    %esi
80103152:	5f                   	pop    %edi
80103153:	5d                   	pop    %ebp
80103154:	c3                   	ret    
80103155:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103158:	8b 0d 40 3d 11 80    	mov    0x80113d40,%ecx
8010315e:	83 f9 07             	cmp    $0x7,%ecx
80103161:	7f 19                	jg     8010317c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103163:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103167:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
8010316d:	83 c1 01             	add    $0x1,%ecx
80103170:	89 0d 40 3d 11 80    	mov    %ecx,0x80113d40
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103176:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010317c:	83 c0 14             	add    $0x14,%eax
      continue;
8010317f:	e9 7c ff ff ff       	jmp    80103100 <mpinit+0xf0>
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103188:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010318c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010318f:	88 15 80 37 11 80    	mov    %dl,0x80113780
      p += sizeof(struct mpioapic);
      continue;
80103195:	e9 66 ff ff ff       	jmp    80103100 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010319a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010319f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031a4:	e8 e7 fd ff ff       	call   80102f90 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031a9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ae:	0f 85 af fe ff ff    	jne    80103063 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801031b4:	83 ec 0c             	sub    $0xc,%esp
801031b7:	68 c2 81 10 80       	push   $0x801081c2
801031bc:	e8 af d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031c1:	83 ec 0c             	sub    $0xc,%esp
801031c4:	68 dc 81 10 80       	push   $0x801081dc
801031c9:	e8 a2 d1 ff ff       	call   80100370 <panic>
801031ce:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031d0:	31 db                	xor    %ebx,%ebx
801031d2:	e9 30 ff ff ff       	jmp    80103107 <mpinit+0xf7>
801031d7:	66 90                	xchg   %ax,%ax
801031d9:	66 90                	xchg   %ax,%ax
801031db:	66 90                	xchg   %ax,%ax
801031dd:	66 90                	xchg   %ax,%ax
801031df:	90                   	nop

801031e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	ba 21 00 00 00       	mov    $0x21,%edx
801031e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031eb:	89 e5                	mov    %esp,%ebp
801031ed:	ee                   	out    %al,(%dx)
801031ee:	ba a1 00 00 00       	mov    $0xa1,%edx
801031f3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031f4:	5d                   	pop    %ebp
801031f5:	c3                   	ret    
801031f6:	66 90                	xchg   %ax,%ax
801031f8:	66 90                	xchg   %ax,%ax
801031fa:	66 90                	xchg   %ax,%ax
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
80103205:	53                   	push   %ebx
80103206:	83 ec 0c             	sub    $0xc,%esp
80103209:	8b 75 08             	mov    0x8(%ebp),%esi
8010320c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010320f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103215:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010321b:	e8 60 db ff ff       	call   80100d80 <filealloc>
80103220:	85 c0                	test   %eax,%eax
80103222:	89 06                	mov    %eax,(%esi)
80103224:	0f 84 a8 00 00 00    	je     801032d2 <pipealloc+0xd2>
8010322a:	e8 51 db ff ff       	call   80100d80 <filealloc>
8010322f:	85 c0                	test   %eax,%eax
80103231:	89 03                	mov    %eax,(%ebx)
80103233:	0f 84 87 00 00 00    	je     801032c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103239:	e8 62 f2 ff ff       	call   801024a0 <kalloc>
8010323e:	85 c0                	test   %eax,%eax
80103240:	89 c7                	mov    %eax,%edi
80103242:	0f 84 b0 00 00 00    	je     801032f8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103248:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010324b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103252:	00 00 00 
  p->writeopen = 1;
80103255:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010325c:	00 00 00 
  p->nwrite = 0;
8010325f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103266:	00 00 00 
  p->nread = 0;
80103269:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103270:	00 00 00 
  initlock(&p->lock, "pipe");
80103273:	68 10 82 10 80       	push   $0x80108210
80103278:	50                   	push   %eax
80103279:	e8 42 1c 00 00       	call   80104ec0 <initlock>
  (*f0)->type = FD_PIPE;
8010327e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103280:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103283:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103289:	8b 06                	mov    (%esi),%eax
8010328b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010328f:	8b 06                	mov    (%esi),%eax
80103291:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103295:	8b 06                	mov    (%esi),%eax
80103297:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010329a:	8b 03                	mov    (%ebx),%eax
8010329c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801032a2:	8b 03                	mov    (%ebx),%eax
801032a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801032a8:	8b 03                	mov    (%ebx),%eax
801032aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801032ae:	8b 03                	mov    (%ebx),%eax
801032b0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801032b6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032b8:	5b                   	pop    %ebx
801032b9:	5e                   	pop    %esi
801032ba:	5f                   	pop    %edi
801032bb:	5d                   	pop    %ebp
801032bc:	c3                   	ret    
801032bd:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032c0:	8b 06                	mov    (%esi),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 1e                	je     801032e4 <pipealloc+0xe4>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 71 db ff ff       	call   80100e40 <fileclose>
801032cf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d2:	8b 03                	mov    (%ebx),%eax
801032d4:	85 c0                	test   %eax,%eax
801032d6:	74 0c                	je     801032e4 <pipealloc+0xe4>
    fileclose(*f1);
801032d8:	83 ec 0c             	sub    $0xc,%esp
801032db:	50                   	push   %eax
801032dc:	e8 5f db ff ff       	call   80100e40 <fileclose>
801032e1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032ec:	5b                   	pop    %ebx
801032ed:	5e                   	pop    %esi
801032ee:	5f                   	pop    %edi
801032ef:	5d                   	pop    %ebp
801032f0:	c3                   	ret    
801032f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032f8:	8b 06                	mov    (%esi),%eax
801032fa:	85 c0                	test   %eax,%eax
801032fc:	75 c8                	jne    801032c6 <pipealloc+0xc6>
801032fe:	eb d2                	jmp    801032d2 <pipealloc+0xd2>

80103300 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	56                   	push   %esi
80103304:	53                   	push   %ebx
80103305:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103308:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010330b:	83 ec 0c             	sub    $0xc,%esp
8010330e:	53                   	push   %ebx
8010330f:	e8 0c 1d 00 00       	call   80105020 <acquire>
  if(writable){
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	85 f6                	test   %esi,%esi
80103319:	74 45                	je     80103360 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010331b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103321:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103324:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010332b:	00 00 00 
    wakeup(&p->nread);
8010332e:	50                   	push   %eax
8010332f:	e8 bc 10 00 00       	call   801043f0 <wakeup>
80103334:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103337:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010333d:	85 d2                	test   %edx,%edx
8010333f:	75 0a                	jne    8010334b <pipeclose+0x4b>
80103341:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103347:	85 c0                	test   %eax,%eax
80103349:	74 35                	je     80103380 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010334b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010334e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103351:	5b                   	pop    %ebx
80103352:	5e                   	pop    %esi
80103353:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103354:	e9 77 1d 00 00       	jmp    801050d0 <release>
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103360:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103366:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103369:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103370:	00 00 00 
    wakeup(&p->nwrite);
80103373:	50                   	push   %eax
80103374:	e8 77 10 00 00       	call   801043f0 <wakeup>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	eb b9                	jmp    80103337 <pipeclose+0x37>
8010337e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	53                   	push   %ebx
80103384:	e8 47 1d 00 00       	call   801050d0 <release>
    kfree((char*)p);
80103389:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010338c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010338f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103392:	5b                   	pop    %ebx
80103393:	5e                   	pop    %esi
80103394:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103395:	e9 56 ef ff ff       	jmp    801022f0 <kfree>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033a0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 28             	sub    $0x28,%esp
801033a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033ac:	53                   	push   %ebx
801033ad:	e8 6e 1c 00 00       	call   80105020 <acquire>
  for(i = 0; i < n; i++){
801033b2:	8b 45 10             	mov    0x10(%ebp),%eax
801033b5:	83 c4 10             	add    $0x10,%esp
801033b8:	85 c0                	test   %eax,%eax
801033ba:	0f 8e b9 00 00 00    	jle    80103479 <pipewrite+0xd9>
801033c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033cf:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033d5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033d8:	03 4d 10             	add    0x10(%ebp),%ecx
801033db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033de:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033e4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033ea:	39 d0                	cmp    %edx,%eax
801033ec:	74 38                	je     80103426 <pipewrite+0x86>
801033ee:	eb 59                	jmp    80103449 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033f0:	e8 ab 04 00 00       	call   801038a0 <myproc>
801033f5:	8b 48 1c             	mov    0x1c(%eax),%ecx
801033f8:	85 c9                	test   %ecx,%ecx
801033fa:	75 34                	jne    80103430 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033fc:	83 ec 0c             	sub    $0xc,%esp
801033ff:	57                   	push   %edi
80103400:	e8 eb 0f 00 00       	call   801043f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103405:	58                   	pop    %eax
80103406:	5a                   	pop    %edx
80103407:	53                   	push   %ebx
80103408:	56                   	push   %esi
80103409:	e8 e2 0a 00 00       	call   80103ef0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010340e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103414:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010341a:	83 c4 10             	add    $0x10,%esp
8010341d:	05 00 02 00 00       	add    $0x200,%eax
80103422:	39 c2                	cmp    %eax,%edx
80103424:	75 2a                	jne    80103450 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103426:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010342c:	85 c0                	test   %eax,%eax
8010342e:	75 c0                	jne    801033f0 <pipewrite+0x50>
        release(&p->lock);
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	53                   	push   %ebx
80103434:	e8 97 1c 00 00       	call   801050d0 <release>
        return -1;
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103441:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103444:	5b                   	pop    %ebx
80103445:	5e                   	pop    %esi
80103446:	5f                   	pop    %edi
80103447:	5d                   	pop    %ebp
80103448:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103449:	89 c2                	mov    %eax,%edx
8010344b:	90                   	nop
8010344c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103450:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103453:	8d 42 01             	lea    0x1(%edx),%eax
80103456:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010345a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103460:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103466:	0f b6 09             	movzbl (%ecx),%ecx
80103469:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010346d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103470:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103473:	0f 85 65 ff ff ff    	jne    801033de <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103479:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010347f:	83 ec 0c             	sub    $0xc,%esp
80103482:	50                   	push   %eax
80103483:	e8 68 0f 00 00       	call   801043f0 <wakeup>
  release(&p->lock);
80103488:	89 1c 24             	mov    %ebx,(%esp)
8010348b:	e8 40 1c 00 00       	call   801050d0 <release>
  return n;
80103490:	83 c4 10             	add    $0x10,%esp
80103493:	8b 45 10             	mov    0x10(%ebp),%eax
80103496:	eb a9                	jmp    80103441 <pipewrite+0xa1>
80103498:	90                   	nop
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034a0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 18             	sub    $0x18,%esp
801034a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801034af:	53                   	push   %ebx
801034b0:	e8 6b 1b 00 00       	call   80105020 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034b5:	83 c4 10             	add    $0x10,%esp
801034b8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034be:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034c4:	75 6a                	jne    80103530 <piperead+0x90>
801034c6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801034cc:	85 f6                	test   %esi,%esi
801034ce:	0f 84 cc 00 00 00    	je     801035a0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034d4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034da:	eb 2d                	jmp    80103509 <piperead+0x69>
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e0:	83 ec 08             	sub    $0x8,%esp
801034e3:	53                   	push   %ebx
801034e4:	56                   	push   %esi
801034e5:	e8 06 0a 00 00       	call   80103ef0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034ea:	83 c4 10             	add    $0x10,%esp
801034ed:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034f3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034f9:	75 35                	jne    80103530 <piperead+0x90>
801034fb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103501:	85 d2                	test   %edx,%edx
80103503:	0f 84 97 00 00 00    	je     801035a0 <piperead+0x100>
    if(myproc()->killed){
80103509:	e8 92 03 00 00       	call   801038a0 <myproc>
8010350e:	8b 48 1c             	mov    0x1c(%eax),%ecx
80103511:	85 c9                	test   %ecx,%ecx
80103513:	74 cb                	je     801034e0 <piperead+0x40>
      release(&p->lock);
80103515:	83 ec 0c             	sub    $0xc,%esp
80103518:	53                   	push   %ebx
80103519:	e8 b2 1b 00 00       	call   801050d0 <release>
      return -1;
8010351e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103521:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103524:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103529:	5b                   	pop    %ebx
8010352a:	5e                   	pop    %esi
8010352b:	5f                   	pop    %edi
8010352c:	5d                   	pop    %ebp
8010352d:	c3                   	ret    
8010352e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103530:	8b 45 10             	mov    0x10(%ebp),%eax
80103533:	85 c0                	test   %eax,%eax
80103535:	7e 69                	jle    801035a0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103537:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010353d:	31 c9                	xor    %ecx,%ecx
8010353f:	eb 15                	jmp    80103556 <piperead+0xb6>
80103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103548:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010354e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103554:	74 5a                	je     801035b0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103556:	8d 70 01             	lea    0x1(%eax),%esi
80103559:	25 ff 01 00 00       	and    $0x1ff,%eax
8010355e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103564:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103569:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010356c:	83 c1 01             	add    $0x1,%ecx
8010356f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103572:	75 d4                	jne    80103548 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103574:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010357a:	83 ec 0c             	sub    $0xc,%esp
8010357d:	50                   	push   %eax
8010357e:	e8 6d 0e 00 00       	call   801043f0 <wakeup>
  release(&p->lock);
80103583:	89 1c 24             	mov    %ebx,(%esp)
80103586:	e8 45 1b 00 00       	call   801050d0 <release>
  return i;
8010358b:	8b 45 10             	mov    0x10(%ebp),%eax
8010358e:	83 c4 10             	add    $0x10,%esp
}
80103591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103594:	5b                   	pop    %ebx
80103595:	5e                   	pop    %esi
80103596:	5f                   	pop    %edi
80103597:	5d                   	pop    %ebp
80103598:	c3                   	ret    
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801035a7:	eb cb                	jmp    80103574 <piperead+0xd4>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035b0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801035b3:	eb bf                	jmp    80103574 <piperead+0xd4>
801035b5:	66 90                	xchg   %ax,%ax
801035b7:	66 90                	xchg   %ax,%ax
801035b9:	66 90                	xchg   %ax,%ax
801035bb:	66 90                	xchg   %ax,%ax
801035bd:	66 90                	xchg   %ax,%ax
801035bf:	90                   	nop

801035c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
    if (DEBUGMODE > 0)
801035c0:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
801035c5:	55                   	push   %ebp
801035c6:	89 e5                	mov    %esp,%ebp
801035c8:	56                   	push   %esi
801035c9:	53                   	push   %ebx
    if (DEBUGMODE > 0)
801035ca:	85 c0                	test   %eax,%eax
801035cc:	7e 10                	jle    801035de <allocproc+0x1e>
        cprintf(" ALLOCPROC ");
801035ce:	83 ec 0c             	sub    $0xc,%esp
801035d1:	68 15 82 10 80       	push   $0x80108215
801035d6:	e8 85 d0 ff ff       	call   80100660 <cprintf>
801035db:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    char *sp;
    acquire(&ptable.lock);
801035de:	83 ec 0c             	sub    $0xc,%esp
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035e1:	bb d4 4b 11 80       	mov    $0x80114bd4,%ebx
    if (DEBUGMODE > 0)
        cprintf(" ALLOCPROC ");
    struct proc *p;
    struct thread *t;
    char *sp;
    acquire(&ptable.lock);
801035e6:	68 a0 4b 11 80       	push   $0x80114ba0
801035eb:	e8 30 1a 00 00       	call   80105020 <acquire>
801035f0:	83 c4 10             	add    $0x10,%esp
801035f3:	eb 11                	jmp    80103606 <allocproc+0x46>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035f8:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
801035fe:	81 fb d4 3a 12 80    	cmp    $0x80123ad4,%ebx
80103604:	74 48                	je     8010364e <allocproc+0x8e>
        if (p->state == UNUSED)
80103606:	8b 73 08             	mov    0x8(%ebx),%esi
80103609:	85 f6                	test   %esi,%esi
8010360b:	75 eb                	jne    801035f8 <allocproc+0x38>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
8010360d:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
80103612:	8b 4b 7c             	mov    0x7c(%ebx),%ecx

    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80103615:	8d 73 74             	lea    0x74(%ebx),%esi

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
80103618:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    p->pid = nextpid++;
8010361f:	8d 50 01             	lea    0x1(%eax),%edx
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
80103622:	85 c9                	test   %ecx,%ecx
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103624:	89 43 0c             	mov    %eax,0xc(%ebx)

    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80103627:	8d 83 b4 03 00 00    	lea    0x3b4(%ebx),%eax
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
8010362d:	89 15 0c b0 10 80    	mov    %edx,0x8010b00c
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
80103633:	75 12                	jne    80103647 <allocproc+0x87>
80103635:	eb 39                	jmp    80103670 <allocproc+0xb0>
80103637:	89 f6                	mov    %esi,%esi
80103639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103640:	8b 56 08             	mov    0x8(%esi),%edx
80103643:	85 d2                	test   %edx,%edx
80103645:	74 29                	je     80103670 <allocproc+0xb0>

    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80103647:	83 c6 34             	add    $0x34,%esi
8010364a:	39 f0                	cmp    %esi,%eax
8010364c:	77 f2                	ja     80103640 <allocproc+0x80>

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->state = UNUSED;
        t->state = UNUSED;
        release(&ptable.lock);
8010364e:	83 ec 0c             	sub    $0xc,%esp
80103651:	68 a0 4b 11 80       	push   $0x80114ba0
80103656:	e8 75 1a 00 00       	call   801050d0 <release>
        return 0;
8010365b:	83 c4 10             	add    $0x10,%esp
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);
//    release(p->procLock);
    return p;
}
8010365e:	8d 65 f8             	lea    -0x8(%ebp),%esp
    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->state = UNUSED;
        t->state = UNUSED;
        release(&ptable.lock);
        return 0;
80103661:	31 c0                	xor    %eax,%eax
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);
//    release(p->procLock);
    return p;
}
80103663:	5b                   	pop    %ebx
80103664:	5e                   	pop    %esi
80103665:	5d                   	pop    %ebp
80103666:	c3                   	ret    
80103667:	89 f6                	mov    %esi,%esi
80103669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&ptable.lock);
    return 0;

    foundThread:
    t->state = EMBRYO;
    t->tid = tidCounter++;
80103670:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    //release(p->procLock);
    release(&ptable.lock);
    return 0;

    foundThread:
    t->state = EMBRYO;
80103675:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    t->tid = tidCounter++;
8010367c:	8d 50 01             	lea    0x1(%eax),%edx
8010367f:	89 46 0c             	mov    %eax,0xc(%esi)
    p->mainThread = t;
80103682:	89 b3 b4 03 00 00    	mov    %esi,0x3b4(%ebx)
    release(&ptable.lock);
    return 0;

    foundThread:
    t->state = EMBRYO;
    t->tid = tidCounter++;
80103688:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
    p->mainThread = t;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
8010368e:	e8 0d ee ff ff       	call   801024a0 <kalloc>
80103693:	85 c0                	test   %eax,%eax
80103695:	89 46 04             	mov    %eax,0x4(%esi)
80103698:	74 47                	je     801036e1 <allocproc+0x121>
        return 0;
    }
    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
8010369a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
801036a0:	83 ec 04             	sub    $0x4,%esp
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
801036a3:	05 9c 0f 00 00       	add    $0xf9c,%eax
        return 0;
    }
    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
801036a8:	89 56 10             	mov    %edx,0x10(%esi)
    t->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;
801036ab:	c7 40 14 ff 63 10 80 	movl   $0x801063ff,0x14(%eax)

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
801036b2:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
801036b5:	6a 14                	push   $0x14
801036b7:	6a 00                	push   $0x0
801036b9:	50                   	push   %eax
801036ba:	e8 71 1a 00 00       	call   80105130 <memset>
    t->context->eip = (uint) forkret;
801036bf:	8b 46 14             	mov    0x14(%esi),%eax
801036c2:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)
    release(&ptable.lock);
801036c9:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801036d0:	e8 fb 19 00 00       	call   801050d0 <release>
//    release(p->procLock);
    return p;
801036d5:	83 c4 10             	add    $0x10,%esp
}
801036d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);
//    release(p->procLock);
    return p;
801036db:	89 d8                	mov    %ebx,%eax
}
801036dd:	5b                   	pop    %ebx
801036de:	5e                   	pop    %esi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret    
    t->tid = tidCounter++;
    p->mainThread = t;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->state = UNUSED;
801036e1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        t->state = UNUSED;
801036e8:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
801036ef:	e9 5a ff ff ff       	jmp    8010364e <allocproc+0x8e>
801036f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103700 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103706:	68 a0 4b 11 80       	push   $0x80114ba0
8010370b:	e8 c0 19 00 00       	call   801050d0 <release>

    if (first) {
80103710:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	85 c0                	test   %eax,%eax
8010371a:	75 04                	jne    80103720 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
8010371c:	c9                   	leave  
8010371d:	c3                   	ret    
8010371e:	66 90                	xchg   %ax,%ax
    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
80103720:	83 ec 0c             	sub    $0xc,%esp

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
80103723:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010372a:	00 00 00 
        iinit(ROOTDEV);
8010372d:	6a 01                	push   $0x1
8010372f:	e8 4c dd ff ff       	call   80101480 <iinit>
        initlog(ROOTDEV);
80103734:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010373b:	e8 80 f3 ff ff       	call   80102ac0 <initlog>
80103740:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103743:	c9                   	leave  
80103744:	c3                   	ret    
80103745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103750 <pinit>:
static void wakeup1(void *chan);

extern void cleanProcOneThread(struct thread *curthread, struct proc *p);

void
pinit(void) {
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	83 ec 08             	sub    $0x8,%esp
    if (DEBUGMODE > 0)
80103756:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
8010375c:	85 c9                	test   %ecx,%ecx
8010375e:	7e 10                	jle    80103770 <pinit+0x20>
        cprintf(" PINIT ");
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	68 21 82 10 80       	push   $0x80108221
80103768:	e8 f3 ce ff ff       	call   80100660 <cprintf>
8010376d:	83 c4 10             	add    $0x10,%esp
    //struct spinlock *l;
    initlock(&ptable.lock, "ptable");
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	68 29 82 10 80       	push   $0x80108229
80103778:	68 a0 4b 11 80       	push   $0x80114ba0
8010377d:	e8 3e 17 00 00       	call   80104ec0 <initlock>
    initlock(&mtable.lock, "mtable");
80103782:	58                   	pop    %eax
80103783:	5a                   	pop    %edx
80103784:	68 30 82 10 80       	push   $0x80108230
80103789:	68 60 3d 11 80       	push   $0x80113d60
8010378e:	e8 2d 17 00 00       	call   80104ec0 <initlock>
    //for (l = ptable.tlocks; l < &ptable.tlocks[NPROC]; l++)
    //initlock(l, "ttable");

}
80103793:	83 c4 10             	add    $0x10,%esp
80103796:	c9                   	leave  
80103797:	c3                   	ret    
80103798:	90                   	nop
80103799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037a0 <cleanThread>:

//must be called under acquire(&ptable.lock); !!
void
cleanThread(struct thread *t) {
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
801037a4:	83 ec 10             	sub    $0x10,%esp
801037a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    kfree(t->tkstack);
801037aa:	ff 73 04             	pushl  0x4(%ebx)
801037ad:	e8 3e eb ff ff       	call   801022f0 <kfree>
    t->state = UNUSED;
    t->tid = 0;
    t->name[0] = 0;
    t->killed = 0;
    //clean trap frame and context
    memset(t->tf, 0, sizeof(*t->tf));
801037b2:	83 c4 0c             	add    $0xc,%esp

//must be called under acquire(&ptable.lock); !!
void
cleanThread(struct thread *t) {
    kfree(t->tkstack);
    t->tkstack = 0;
801037b5:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    t->state = UNUSED;
801037bc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    t->tid = 0;
801037c3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    t->name[0] = 0;
801037ca:	c6 43 20 00          	movb   $0x0,0x20(%ebx)
    t->killed = 0;
801037ce:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    //clean trap frame and context
    memset(t->tf, 0, sizeof(*t->tf));
801037d5:	6a 4c                	push   $0x4c
801037d7:	6a 00                	push   $0x0
801037d9:	ff 73 10             	pushl  0x10(%ebx)
801037dc:	e8 4f 19 00 00       	call   80105130 <memset>
    memset(t->context, 0, sizeof(*t->context));
801037e1:	83 c4 0c             	add    $0xc,%esp
801037e4:	6a 14                	push   $0x14
801037e6:	6a 00                	push   $0x0
801037e8:	ff 73 14             	pushl  0x14(%ebx)
801037eb:	e8 40 19 00 00       	call   80105130 <memset>
}
801037f0:	83 c4 10             	add    $0x10,%esp
801037f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037f6:	c9                   	leave  
801037f7:	c3                   	ret    
801037f8:	90                   	nop
801037f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103800 <mycpu>:
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103805:	9c                   	pushf  
80103806:	58                   	pop    %eax
    int apicid, i;

    if (readeflags() & FL_IF)
80103807:	f6 c4 02             	test   $0x2,%ah
8010380a:	75 5b                	jne    80103867 <mycpu+0x67>
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
8010380c:	e8 ef ee ff ff       	call   80102700 <lapicid>
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103811:	8b 35 40 3d 11 80    	mov    0x80113d40,%esi
80103817:	85 f6                	test   %esi,%esi
80103819:	7e 3f                	jle    8010385a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
8010381b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103822:	39 d0                	cmp    %edx,%eax
80103824:	74 30                	je     80103856 <mycpu+0x56>
80103826:	b9 54 38 11 80       	mov    $0x80113854,%ecx
8010382b:	31 d2                	xor    %edx,%edx
8010382d:	8d 76 00             	lea    0x0(%esi),%esi
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103830:	83 c2 01             	add    $0x1,%edx
80103833:	39 f2                	cmp    %esi,%edx
80103835:	74 23                	je     8010385a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
80103837:	0f b6 19             	movzbl (%ecx),%ebx
8010383a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
80103840:	39 d8                	cmp    %ebx,%eax
80103842:	75 ec                	jne    80103830 <mycpu+0x30>
            return &cpus[i];
80103844:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
    }
    panic("unknown apicid\n");
}
8010384a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010384d:	5b                   	pop    %ebx
    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
8010384e:	05 a0 37 11 80       	add    $0x801137a0,%eax
    }
    panic("unknown apicid\n");
}
80103853:	5e                   	pop    %esi
80103854:	5d                   	pop    %ebp
80103855:	c3                   	ret    
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103856:	31 d2                	xor    %edx,%edx
80103858:	eb ea                	jmp    80103844 <mycpu+0x44>
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
8010385a:	83 ec 0c             	sub    $0xc,%esp
8010385d:	68 37 82 10 80       	push   $0x80108237
80103862:	e8 09 cb ff ff       	call   80100370 <panic>
struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");
80103867:	83 ec 0c             	sub    $0xc,%esp
8010386a:	68 9c 83 10 80       	push   $0x8010839c
8010386f:	e8 fc ca ff ff       	call   80100370 <panic>
80103874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010387a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103880 <cpuid>:
    release(&ptable.lock);
}

// Must be called with interrupts disabled
int
cpuid() {
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103886:	e8 75 ff ff ff       	call   80103800 <mycpu>
8010388b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103890:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
    return mycpu() - cpus;
80103891:	c1 f8 02             	sar    $0x2,%eax
80103894:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
8010389a:	c3                   	ret    
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
    struct cpu *c;
    struct proc *p;
    pushcli();
801038a7:	e8 94 16 00 00       	call   80104f40 <pushcli>
    c = mycpu();
801038ac:	e8 4f ff ff ff       	call   80103800 <mycpu>
    p = c->proc;
801038b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801038b7:	e8 c4 16 00 00       	call   80104f80 <popcli>
    return p;
}
801038bc:	83 c4 04             	add    $0x4,%esp
801038bf:	89 d8                	mov    %ebx,%eax
801038c1:	5b                   	pop    %ebx
801038c2:	5d                   	pop    %ebp
801038c3:	c3                   	ret    
801038c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038d0 <mythread>:


// Disable interrupts so that we are not rescheduled
// while reading thread from the cpu structure
struct thread *
mythread(void) {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 04             	sub    $0x4,%esp
    struct cpu *c;
    struct thread *t;
    pushcli();
801038d7:	e8 64 16 00 00       	call   80104f40 <pushcli>
    c = mycpu();
801038dc:	e8 1f ff ff ff       	call   80103800 <mycpu>
    t = c->currThread;
801038e1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801038e7:	e8 94 16 00 00       	call   80104f80 <popcli>
    return t;
}
801038ec:	83 c4 04             	add    $0x4,%esp
801038ef:	89 d8                	mov    %ebx,%eax
801038f1:	5b                   	pop    %ebx
801038f2:	5d                   	pop    %ebp
801038f3:	c3                   	ret    
801038f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103900 <userinit>:
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	53                   	push   %ebx
80103904:	83 ec 04             	sub    $0x4,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80103907:	e8 b4 fc ff ff       	call   801035c0 <allocproc>
8010390c:	89 c3                	mov    %eax,%ebx
    initproc = p;
8010390e:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
    if ((p->pgdir = setupkvm()) == 0)
80103913:	e8 e8 40 00 00       	call   80107a00 <setupkvm>
80103918:	85 c0                	test   %eax,%eax
8010391a:	89 43 04             	mov    %eax,0x4(%ebx)
8010391d:	0f 84 2d 01 00 00    	je     80103a50 <userinit+0x150>
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103923:	83 ec 04             	sub    $0x4,%esp
80103926:	68 2c 00 00 00       	push   $0x2c
8010392b:	68 60 b4 10 80       	push   $0x8010b460
80103930:	50                   	push   %eax
80103931:	e8 da 3d 00 00       	call   80107710 <inituvm>
    p->sz = PGSIZE;
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
80103936:	83 c4 0c             	add    $0xc,%esp
    p = allocproc();
    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
80103939:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
8010393f:	6a 4c                	push   $0x4c
80103941:	6a 00                	push   $0x0
80103943:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103949:	ff 70 10             	pushl  0x10(%eax)
8010394c:	e8 df 17 00 00       	call   80105130 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103951:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103957:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010395c:	b9 23 00 00 00       	mov    $0x23,%ecx
    p->mainThread->tf->ss = p->mainThread->tf->ds;
    p->mainThread->tf->eflags = FL_IF;
    p->mainThread->tf->esp = PGSIZE;
    p->mainThread->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103961:	83 c4 0c             	add    $0xc,%esp
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103964:	8b 40 10             	mov    0x10(%eax),%eax
80103967:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010396b:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103971:	8b 40 10             	mov    0x10(%eax),%eax
80103974:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
80103978:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
8010397e:	8b 40 10             	mov    0x10(%eax),%eax
80103981:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103985:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
80103989:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
8010398f:	8b 40 10             	mov    0x10(%eax),%eax
80103992:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103996:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
8010399a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039a0:	8b 40 10             	mov    0x10(%eax),%eax
801039a3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
801039aa:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039b0:	8b 40 10             	mov    0x10(%eax),%eax
801039b3:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
801039ba:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039c0:	8b 40 10             	mov    0x10(%eax),%eax
801039c3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
801039ca:	8d 43 64             	lea    0x64(%ebx),%eax
801039cd:	6a 10                	push   $0x10
801039cf:	68 60 82 10 80       	push   $0x80108260
801039d4:	50                   	push   %eax
801039d5:	e8 56 19 00 00       	call   80105330 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
801039da:	83 c4 0c             	add    $0xc,%esp
801039dd:	6a 10                	push   $0x10
801039df:	68 69 82 10 80       	push   $0x80108269
801039e4:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039ea:	83 c0 20             	add    $0x20,%eax
801039ed:	50                   	push   %eax
801039ee:	e8 3d 19 00 00       	call   80105330 <safestrcpy>
    p->cwd = namei("/");
801039f3:	c7 04 24 74 82 10 80 	movl   $0x80108274,(%esp)
801039fa:	e8 d1 e4 ff ff       	call   80101ed0 <namei>
801039ff:	89 43 60             	mov    %eax,0x60(%ebx)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
80103a02:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103a09:	e8 12 16 00 00       	call   80105020 <acquire>
    //acquire(p->procLock);

    p->state = RUNNABLE;
    p->mainThread->state = RUNNABLE;
80103a0e:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
    //acquire(p->procLock);

    p->state = RUNNABLE;
80103a14:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103a1b:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)

    //release(p->procLock);
    release(&ptable.lock);
80103a22:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103a29:	e8 a2 16 00 00       	call   801050d0 <release>
    if (DEBUGMODE > 0)
80103a2e:	8b 1d b8 b5 10 80    	mov    0x8010b5b8,%ebx
80103a34:	83 c4 10             	add    $0x10,%esp
80103a37:	85 db                	test   %ebx,%ebx
80103a39:	7e 10                	jle    80103a4b <userinit+0x14b>
        cprintf("DONE USERINIT");
80103a3b:	83 ec 0c             	sub    $0xc,%esp
80103a3e:	68 76 82 10 80       	push   $0x80108276
80103a43:	e8 18 cc ff ff       	call   80100660 <cprintf>
80103a48:	83 c4 10             	add    $0x10,%esp

}
80103a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a4e:	c9                   	leave  
80103a4f:	c3                   	ret    
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	68 47 82 10 80       	push   $0x80108247
80103a58:	e8 13 c9 ff ff       	call   80100370 <panic>
80103a5d:	8d 76 00             	lea    0x0(%esi),%esi

80103a60 <growproc>:
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
80103a65:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103a68:	e8 d3 14 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80103a6d:	e8 8e fd ff ff       	call   80103800 <mycpu>
    p = c->proc;
80103a72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103a78:	e8 03 15 00 00       	call   80104f80 <popcli>
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();
    if (DEBUGMODE > 0)
80103a7d:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103a82:	85 c0                	test   %eax,%eax
80103a84:	7e 10                	jle    80103a96 <growproc+0x36>
        cprintf(" GROWPROC APPLYED ");
80103a86:	83 ec 0c             	sub    $0xc,%esp
80103a89:	68 84 82 10 80       	push   $0x80108284
80103a8e:	e8 cd cb ff ff       	call   80100660 <cprintf>
80103a93:	83 c4 10             	add    $0x10,%esp

    sz = curproc->sz;
    if (n > 0) {
80103a96:	83 fe 00             	cmp    $0x0,%esi
    uint sz;
    struct proc *curproc = myproc();
    if (DEBUGMODE > 0)
        cprintf(" GROWPROC APPLYED ");

    sz = curproc->sz;
80103a99:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103a9b:	7e 33                	jle    80103ad0 <growproc+0x70>
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a9d:	83 ec 04             	sub    $0x4,%esp
80103aa0:	01 c6                	add    %eax,%esi
80103aa2:	56                   	push   %esi
80103aa3:	50                   	push   %eax
80103aa4:	ff 73 04             	pushl  0x4(%ebx)
80103aa7:	e8 a4 3d 00 00       	call   80107850 <allocuvm>
80103aac:	83 c4 10             	add    $0x10,%esp
80103aaf:	85 c0                	test   %eax,%eax
80103ab1:	74 3d                	je     80103af0 <growproc+0x90>
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
    switchuvm(curproc);
80103ab3:	83 ec 0c             	sub    $0xc,%esp
            return -1;
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
80103ab6:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103ab8:	53                   	push   %ebx
80103ab9:	e8 32 3b 00 00       	call   801075f0 <switchuvm>
    return 0;
80103abe:	83 c4 10             	add    $0x10,%esp
80103ac1:	31 c0                	xor    %eax,%eax
}
80103ac3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac6:	5b                   	pop    %ebx
80103ac7:	5e                   	pop    %esi
80103ac8:	5d                   	pop    %ebp
80103ac9:	c3                   	ret    
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
80103ad0:	74 e1                	je     80103ab3 <growproc+0x53>
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ad2:	83 ec 04             	sub    $0x4,%esp
80103ad5:	01 c6                	add    %eax,%esi
80103ad7:	56                   	push   %esi
80103ad8:	50                   	push   %eax
80103ad9:	ff 73 04             	pushl  0x4(%ebx)
80103adc:	e8 6f 3e 00 00       	call   80107950 <deallocuvm>
80103ae1:	83 c4 10             	add    $0x10,%esp
80103ae4:	85 c0                	test   %eax,%eax
80103ae6:	75 cb                	jne    80103ab3 <growproc+0x53>
80103ae8:	90                   	nop
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" GROWPROC APPLYED ");

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
80103af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103af5:	eb cc                	jmp    80103ac3 <growproc+0x63>
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b00 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	57                   	push   %edi
80103b04:	56                   	push   %esi
80103b05:	53                   	push   %ebx
80103b06:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103b09:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103b0e:	85 c0                	test   %eax,%eax
80103b10:	7e 10                	jle    80103b22 <fork+0x22>
        cprintf(" FORK ");
80103b12:	83 ec 0c             	sub    $0xc,%esp
80103b15:	68 97 82 10 80       	push   $0x80108297
80103b1a:	e8 41 cb ff ff       	call   80100660 <cprintf>
80103b1f:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103b22:	e8 19 14 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80103b27:	e8 d4 fc ff ff       	call   80103800 <mycpu>
    p = c->proc;
80103b2c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103b32:	89 c7                	mov    %eax,%edi
80103b34:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
80103b37:	e8 44 14 00 00       	call   80104f80 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103b3c:	e8 ff 13 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80103b41:	e8 ba fc ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80103b46:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103b4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103b4f:	e8 2c 14 00 00       	call   80104f80 <popcli>
    struct proc *np;
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    // Allocate process.
    if ((np = allocproc()) == 0) {
80103b54:	e8 67 fa ff ff       	call   801035c0 <allocproc>
80103b59:	85 c0                	test   %eax,%eax
80103b5b:	89 c3                	mov    %eax,%ebx
80103b5d:	0f 84 f1 00 00 00    	je     80103c54 <fork+0x154>
        return -1;
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103b63:	83 ec 08             	sub    $0x8,%esp
80103b66:	ff 37                	pushl  (%edi)
80103b68:	ff 77 04             	pushl  0x4(%edi)
80103b6b:	e8 60 3f 00 00       	call   80107ad0 <copyuvm>
80103b70:	83 c4 10             	add    $0x10,%esp
80103b73:	85 c0                	test   %eax,%eax
80103b75:	89 43 04             	mov    %eax,0x4(%ebx)
80103b78:	0f 84 dd 00 00 00    	je     80103c5b <fork+0x15b>
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;
80103b81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b84:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103b86:	89 53 10             	mov    %edx,0x10(%ebx)
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b89:	89 03                	mov    %eax,(%ebx)
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;
80103b8b:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103b91:	8b 71 10             	mov    0x10(%ecx),%esi
80103b94:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b99:	8b 40 10             	mov    0x10(%eax),%eax
80103b9c:	89 c7                	mov    %eax,%edi
80103b9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103ba0:	31 f6                	xor    %esi,%esi
80103ba2:	89 d7                	mov    %edx,%edi
    np->sz = curproc->sz;
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;
80103ba4:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103baa:	8b 40 10             	mov    0x10(%eax),%eax
80103bad:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
80103bb8:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103bbc:	85 c0                	test   %eax,%eax
80103bbe:	74 10                	je     80103bd0 <fork+0xd0>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	50                   	push   %eax
80103bc4:	e8 27 d2 ff ff       	call   80100df0 <filedup>
80103bc9:	83 c4 10             	add    $0x10,%esp
80103bcc:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    *np->mainThread->tf = *curthread->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103bd0:	83 c6 01             	add    $0x1,%esi
80103bd3:	83 fe 10             	cmp    $0x10,%esi
80103bd6:	75 e0                	jne    80103bb8 <fork+0xb8>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
//    np->mainThread->cwd = idup(curthread->cwd);
    np->cwd = idup(curproc->cwd);
80103bd8:	8b 7d e0             	mov    -0x20(%ebp),%edi
80103bdb:	83 ec 0c             	sub    $0xc,%esp
80103bde:	ff 77 60             	pushl  0x60(%edi)
80103be1:	e8 6a da ff ff       	call   80101650 <idup>
80103be6:	89 43 60             	mov    %eax,0x60(%ebx)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be9:	89 f8                	mov    %edi,%eax
80103beb:	83 c4 0c             	add    $0xc,%esp
80103bee:	83 c0 64             	add    $0x64,%eax
80103bf1:	6a 10                	push   $0x10
80103bf3:	50                   	push   %eax
80103bf4:	8d 43 64             	lea    0x64(%ebx),%eax
80103bf7:	50                   	push   %eax
80103bf8:	e8 33 17 00 00       	call   80105330 <safestrcpy>
    //TODO
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103bfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c00:	83 c4 0c             	add    $0xc,%esp
80103c03:	6a 10                	push   $0x10
80103c05:	83 c0 20             	add    $0x20,%eax
80103c08:	50                   	push   %eax
80103c09:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c0f:	83 c0 20             	add    $0x20,%eax
80103c12:	50                   	push   %eax
80103c13:	e8 18 17 00 00       	call   80105330 <safestrcpy>

    pid = np->pid;
80103c18:	8b 73 0c             	mov    0xc(%ebx),%esi

    acquire(&ptable.lock);
80103c1b:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103c22:	e8 f9 13 00 00       	call   80105020 <acquire>
    //acquire(np->procLock);

    np->state = RUNNABLE;
    //TODO
    np->mainThread->state = RUNNABLE;
80103c27:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
    pid = np->pid;

    acquire(&ptable.lock);
    //acquire(np->procLock);

    np->state = RUNNABLE;
80103c2d:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    //TODO
    np->mainThread->state = RUNNABLE;
80103c34:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)

    //release(np->procLock);
    release(&ptable.lock);
80103c3b:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103c42:	e8 89 14 00 00       	call   801050d0 <release>

    return pid;
80103c47:	83 c4 10             	add    $0x10,%esp
80103c4a:	89 f0                	mov    %esi,%eax
}
80103c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c4f:	5b                   	pop    %ebx
80103c50:	5e                   	pop    %esi
80103c51:	5f                   	pop    %edi
80103c52:	5d                   	pop    %ebp
80103c53:	c3                   	ret    
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
80103c54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c59:	eb f1                	jmp    80103c4c <fork+0x14c>
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
80103c5b:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c61:	83 ec 0c             	sub    $0xc,%esp
80103c64:	ff 70 04             	pushl  0x4(%eax)
80103c67:	e8 84 e6 ff ff       	call   801022f0 <kfree>
        np->mainThread->tkstack = 0;
80103c6c:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
80103c72:	83 c4 10             	add    $0x10,%esp
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
        np->mainThread->tkstack = 0;
80103c75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
80103c7c:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
80103c82:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103c89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c95:	eb b5                	jmp    80103c4c <fork+0x14c>
80103c97:	89 f6                	mov    %esi,%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ca0 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	56                   	push   %esi
80103ca5:	53                   	push   %ebx
80103ca6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103ca9:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103cae:	85 c0                	test   %eax,%eax
80103cb0:	7e 10                	jle    80103cc2 <scheduler+0x22>
        cprintf(" SCHEDULER ");
80103cb2:	83 ec 0c             	sub    $0xc,%esp
80103cb5:	68 9e 82 10 80       	push   $0x8010829e
80103cba:	e8 a1 c9 ff ff       	call   80100660 <cprintf>
80103cbf:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct cpu *c = mycpu();
80103cc2:	e8 39 fb ff ff       	call   80103800 <mycpu>
    struct thread *t;
    c->proc = 0;
80103cc7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cce:	00 00 00 
void
scheduler(void) {
    if (DEBUGMODE > 0)
        cprintf(" SCHEDULER ");
    struct proc *p;
    struct cpu *c = mycpu();
80103cd1:	89 c6                	mov    %eax,%esi
80103cd3:	8d 40 04             	lea    0x4(%eax),%eax
80103cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ce0:	fb                   	sti    
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103ce1:	83 ec 0c             	sub    $0xc,%esp

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ce4:	bf d4 4b 11 80       	mov    $0x80114bd4,%edi
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103ce9:	68 a0 4b 11 80       	push   $0x80114ba0
80103cee:	e8 2d 13 00 00       	call   80105020 <acquire>
80103cf3:	83 c4 10             	add    $0x10,%esp
80103cf6:	eb 1a                	jmp    80103d12 <scheduler+0x72>
80103cf8:	90                   	nop
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d00:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
80103d06:	81 ff d4 3a 12 80    	cmp    $0x80123ad4,%edi
80103d0c:	0f 84 9e 00 00 00    	je     80103db0 <scheduler+0x110>
            if (p->state != RUNNABLE)
80103d12:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d16:	75 e8                	jne    80103d00 <scheduler+0x60>
            // to release ptable.lock and then reacquire it
            // before jumping back to us.

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
80103d18:	83 ec 0c             	sub    $0xc,%esp
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
80103d1b:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
80103d21:	8d 5f 74             	lea    0x74(%edi),%ebx
            switchuvm(p);
80103d24:	57                   	push   %edi
80103d25:	e8 c6 38 00 00       	call   801075f0 <switchuvm>
80103d2a:	8d 97 b4 03 00 00    	lea    0x3b4(%edi),%edx
80103d30:	83 c4 10             	add    $0x10,%esp
80103d33:	eb 0a                	jmp    80103d3f <scheduler+0x9f>
80103d35:	8d 76 00             	lea    0x0(%esi),%esi
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d38:	83 c3 34             	add    $0x34,%ebx
80103d3b:	39 da                	cmp    %ebx,%edx
80103d3d:	76 41                	jbe    80103d80 <scheduler+0xe0>
                if (t->state != RUNNABLE)
80103d3f:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103d43:	75 f3                	jne    80103d38 <scheduler+0x98>
                    continue;

                //cprintf("\n  FOUND TRED TO RUN %d" , t->tid);
                t->state = RUNNING;
80103d45:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d4c:	83 ec 08             	sub    $0x8,%esp
                if (t->state != RUNNABLE)
                    continue;

                //cprintf("\n  FOUND TRED TO RUN %d" , t->tid);
                t->state = RUNNING;
                c->currThread = t;
80103d4f:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d55:	ff 73 14             	pushl  0x14(%ebx)
80103d58:	ff 75 e0             	pushl  -0x20(%ebp)

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d5b:	83 c3 34             	add    $0x34,%ebx
80103d5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d61:	e8 25 16 00 00       	call   8010538b <swtch>
                c->currThread = 0;
80103d66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d69:	83 c4 10             	add    $0x10,%esp
80103d6c:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103d73:	00 00 00 

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d76:	39 da                	cmp    %ebx,%edx
80103d78:	77 c5                	ja     80103d3f <scheduler+0x9f>
80103d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d80:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
//                    }
                swtch(&(c->scheduler), t->context);
                c->currThread = 0;

            }
            switchkvm();
80103d86:	e8 45 38 00 00       	call   801075d0 <switchkvm>
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d8b:	81 ff d4 3a 12 80    	cmp    $0x80123ad4,%edi
//            }


            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80103d91:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d98:	00 00 00 
            c->currThread = 0;
80103d9b:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103da2:	00 00 00 
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103da5:	0f 85 67 ff ff ff    	jne    80103d12 <scheduler+0x72>
80103dab:	90                   	nop
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            // It should have changed its p->state before coming back.
            c->proc = 0;
            c->currThread = 0;

        }
        release(&ptable.lock);
80103db0:	83 ec 0c             	sub    $0xc,%esp
80103db3:	68 a0 4b 11 80       	push   $0x80114ba0
80103db8:	e8 13 13 00 00       	call   801050d0 <release>

    }
80103dbd:	83 c4 10             	add    $0x10,%esp
80103dc0:	e9 1b ff ff ff       	jmp    80103ce0 <scheduler+0x40>
80103dc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dd0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
    if (DEBUGMODE > 1)
80103dd0:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
80103dd7:	55                   	push   %ebp
80103dd8:	89 e5                	mov    %esp,%ebp
80103dda:	56                   	push   %esi
80103ddb:	53                   	push   %ebx
    if (DEBUGMODE > 1)
80103ddc:	7e 10                	jle    80103dee <sched+0x1e>
        cprintf(" SCHED ");
80103dde:	83 ec 0c             	sub    $0xc,%esp
80103de1:	68 aa 82 10 80       	push   $0x801082aa
80103de6:	e8 75 c8 ff ff       	call   80100660 <cprintf>
80103deb:	83 c4 10             	add    $0x10,%esp
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103dee:	e8 4d 11 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80103df3:	e8 08 fa ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80103df8:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103dfe:	e8 7d 11 00 00       	call   80104f80 <popcli>
        cprintf(" SCHED ");
    int intena;
    //struct proc *p = myproc();
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
80103e03:	83 ec 0c             	sub    $0xc,%esp
80103e06:	68 a0 4b 11 80       	push   $0x80114ba0
80103e0b:	e8 e0 11 00 00       	call   80104ff0 <holding>
80103e10:	83 c4 10             	add    $0x10,%esp
80103e13:	85 c0                	test   %eax,%eax
80103e15:	74 4f                	je     80103e66 <sched+0x96>
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
80103e17:	e8 e4 f9 ff ff       	call   80103800 <mycpu>
80103e1c:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e23:	75 68                	jne    80103e8d <sched+0xbd>
        panic("sched locks");
    if (t->state == RUNNING)
80103e25:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103e29:	74 55                	je     80103e80 <sched+0xb0>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e2b:	9c                   	pushf  
80103e2c:	58                   	pop    %eax
        panic("sched running");
    if (readeflags() & FL_IF)
80103e2d:	f6 c4 02             	test   $0x2,%ah
80103e30:	75 41                	jne    80103e73 <sched+0xa3>
        panic("sched interruptible");
    intena = mycpu()->intena;
80103e32:	e8 c9 f9 ff ff       	call   80103800 <mycpu>
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
80103e37:	83 c3 14             	add    $0x14,%ebx
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
80103e3a:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
80103e40:	e8 bb f9 ff ff       	call   80103800 <mycpu>
80103e45:	83 ec 08             	sub    $0x8,%esp
80103e48:	ff 70 04             	pushl  0x4(%eax)
80103e4b:	53                   	push   %ebx
80103e4c:	e8 3a 15 00 00       	call   8010538b <swtch>
    mycpu()->intena = intena;
80103e51:	e8 aa f9 ff ff       	call   80103800 <mycpu>
}
80103e56:	83 c4 10             	add    $0x10,%esp
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
    mycpu()->intena = intena;
80103e59:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e62:	5b                   	pop    %ebx
80103e63:	5e                   	pop    %esi
80103e64:	5d                   	pop    %ebp
80103e65:	c3                   	ret    
    int intena;
    //struct proc *p = myproc();
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
80103e66:	83 ec 0c             	sub    $0xc,%esp
80103e69:	68 b2 82 10 80       	push   $0x801082b2
80103e6e:	e8 fd c4 ff ff       	call   80100370 <panic>
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	68 de 82 10 80       	push   $0x801082de
80103e7b:	e8 f0 c4 ff ff       	call   80100370 <panic>
    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
80103e80:	83 ec 0c             	sub    $0xc,%esp
80103e83:	68 d0 82 10 80       	push   $0x801082d0
80103e88:	e8 e3 c4 ff ff       	call   80100370 <panic>
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
80103e8d:	83 ec 0c             	sub    $0xc,%esp
80103e90:	68 c4 82 10 80       	push   $0x801082c4
80103e95:	e8 d6 c4 ff ff       	call   80100370 <panic>
80103e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ea0 <yield>:
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
80103ea4:	83 ec 10             	sub    $0x10,%esp
    //struct  proc *p = myproc();
    //acquire(p->procLock);
    acquire(&ptable.lock);
80103ea7:	68 a0 4b 11 80       	push   $0x80114ba0
80103eac:	e8 6f 11 00 00       	call   80105020 <acquire>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103eb1:	e8 8a 10 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80103eb6:	e8 45 f9 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80103ebb:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103ec1:	e8 ba 10 00 00       	call   80104f80 <popcli>
void
yield(void) {
    //struct  proc *p = myproc();
    //acquire(p->procLock);
    acquire(&ptable.lock);
    mythread()->state = RUNNABLE;
80103ec6:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103ecd:	e8 fe fe ff ff       	call   80103dd0 <sched>
    release(&ptable.lock);
80103ed2:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103ed9:	e8 f2 11 00 00       	call   801050d0 <release>
    //release(p->procLock);
}
80103ede:	83 c4 10             	add    $0x10,%esp
80103ee1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ee4:	c9                   	leave  
80103ee5:	c3                   	ret    
80103ee6:	8d 76 00             	lea    0x0(%esi),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <sleep>:
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80103ef9:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103f00:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f03:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (DEBUGMODE > 1)
80103f06:	7e 10                	jle    80103f18 <sleep+0x28>
        cprintf(" SLEEP ");
80103f08:	83 ec 0c             	sub    $0xc,%esp
80103f0b:	68 f2 82 10 80       	push   $0x801082f2
80103f10:	e8 4b c7 ff ff       	call   80100660 <cprintf>
80103f15:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103f18:	e8 23 10 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80103f1d:	e8 de f8 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80103f22:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103f28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103f2b:	e8 50 10 00 00       	call   80104f80 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103f30:	e8 0b 10 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80103f35:	e8 c6 f8 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80103f3a:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103f40:	e8 3b 10 00 00       	call   80104f80 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103f45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f48:	85 d2                	test   %edx,%edx
80103f4a:	0f 84 83 00 00 00    	je     80103fd3 <sleep+0xe3>
        panic("sleep");

    if (lk == 0)
80103f50:	85 db                	test   %ebx,%ebx
80103f52:	74 72                	je     80103fc6 <sleep+0xd6>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {
80103f54:	81 fb a0 4b 11 80    	cmp    $0x80114ba0,%ebx
80103f5a:	74 4c                	je     80103fa8 <sleep+0xb8>
        acquire(&ptable.lock);
80103f5c:	83 ec 0c             	sub    $0xc,%esp
80103f5f:	68 a0 4b 11 80       	push   $0x80114ba0
80103f64:	e8 b7 10 00 00       	call   80105020 <acquire>
        release(lk);
80103f69:	89 1c 24             	mov    %ebx,(%esp)
80103f6c:	e8 5f 11 00 00       	call   801050d0 <release>
    }
    // Go to sleep.
    t->chan = chan;
80103f71:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103f74:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103f7b:	e8 50 fe ff ff       	call   80103dd0 <sched>

    // Tidy up.
    t->chan = 0;
80103f80:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80103f87:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103f8e:	e8 3d 11 00 00       	call   801050d0 <release>
        acquire(lk);
80103f93:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103f96:	83 c4 10             	add    $0x10,%esp
    }
}
80103f99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f9c:	5b                   	pop    %ebx
80103f9d:	5e                   	pop    %esi
80103f9e:	5f                   	pop    %edi
80103f9f:	5d                   	pop    %ebp
    t->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
80103fa0:	e9 7b 10 00 00       	jmp    80105020 <acquire>
80103fa5:	8d 76 00             	lea    0x0(%esi),%esi
    if (lk != &ptable.lock) {
        acquire(&ptable.lock);
        release(lk);
    }
    // Go to sleep.
    t->chan = chan;
80103fa8:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103fab:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103fb2:	e8 19 fe ff ff       	call   80103dd0 <sched>

    // Tidy up.
    t->chan = 0;
80103fb7:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}
80103fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc1:	5b                   	pop    %ebx
80103fc2:	5e                   	pop    %esi
80103fc3:	5f                   	pop    %edi
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret    

    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");
80103fc6:	83 ec 0c             	sub    $0xc,%esp
80103fc9:	68 00 83 10 80       	push   $0x80108300
80103fce:	e8 9d c3 ff ff       	call   80100370 <panic>

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
        panic("sleep");
80103fd3:	83 ec 0c             	sub    $0xc,%esp
80103fd6:	68 fa 82 10 80       	push   $0x801082fa
80103fdb:	e8 90 c3 ff ff       	call   80100370 <panic>

80103fe0 <cleanProcOneThread>:
    memset(t->tf, 0, sizeof(*t->tf));
    memset(t->context, 0, sizeof(*t->context));
}

void
cleanProcOneThread(struct thread *curthread, struct proc *p) {
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 18             	sub    $0x18,%esp
80103fe9:	8b 75 0c             	mov    0xc(%ebp),%esi
80103fec:	8b 7d 08             	mov    0x8(%ebp),%edi

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
80103fef:	68 a0 4b 11 80       	push   $0x80114ba0
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103ff4:	8d 5e 74             	lea    0x74(%esi),%ebx
80103ff7:	81 c6 b4 03 00 00    	add    $0x3b4,%esi
void
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
80103ffd:	e8 1e 10 00 00       	call   80105020 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104002:	83 c4 10             	add    $0x10,%esp
80104005:	eb 18                	jmp    8010401f <cleanProcOneThread+0x3f>
80104007:	89 f6                	mov    %esi,%esi
80104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (t != curthread) {
            if (t->state == RUNNING)
                sleep(t, &ptable.lock);
            if (t->state == RUNNING || t->state == RUNNABLE) {
80104010:	83 e8 03             	sub    $0x3,%eax
80104013:	83 f8 01             	cmp    $0x1,%eax
80104016:	76 38                	jbe    80104050 <cleanProcOneThread+0x70>
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104018:	83 c3 34             	add    $0x34,%ebx
8010401b:	39 f3                	cmp    %esi,%ebx
8010401d:	73 44                	jae    80104063 <cleanProcOneThread+0x83>
        if (t != curthread) {
8010401f:	39 df                	cmp    %ebx,%edi
80104021:	74 f5                	je     80104018 <cleanProcOneThread+0x38>
            if (t->state == RUNNING)
80104023:	8b 43 08             	mov    0x8(%ebx),%eax
80104026:	83 f8 04             	cmp    $0x4,%eax
80104029:	75 e5                	jne    80104010 <cleanProcOneThread+0x30>
                sleep(t, &ptable.lock);
8010402b:	83 ec 08             	sub    $0x8,%esp
8010402e:	68 a0 4b 11 80       	push   $0x80114ba0
80104033:	53                   	push   %ebx
80104034:	e8 b7 fe ff ff       	call   80103ef0 <sleep>
80104039:	8b 43 08             	mov    0x8(%ebx),%eax
8010403c:	83 c4 10             	add    $0x10,%esp
            if (t->state == RUNNING || t->state == RUNNABLE) {
8010403f:	83 e8 03             	sub    $0x3,%eax
80104042:	83 f8 01             	cmp    $0x1,%eax
80104045:	77 d1                	ja     80104018 <cleanProcOneThread+0x38>
80104047:	89 f6                	mov    %esi,%esi
80104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cleanThread(t);
80104050:	83 ec 0c             	sub    $0xc,%esp
80104053:	53                   	push   %ebx
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104054:	83 c3 34             	add    $0x34,%ebx
        if (t != curthread) {
            if (t->state == RUNNING)
                sleep(t, &ptable.lock);
            if (t->state == RUNNING || t->state == RUNNABLE) {
                cleanThread(t);
80104057:	e8 44 f7 ff ff       	call   801037a0 <cleanThread>
8010405c:	83 c4 10             	add    $0x10,%esp
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010405f:	39 f3                	cmp    %esi,%ebx
80104061:	72 bc                	jb     8010401f <cleanProcOneThread+0x3f>
            if (t->state == RUNNING || t->state == RUNNABLE) {
                cleanThread(t);
            }
        }
    }
    release(&ptable.lock);
80104063:	c7 45 08 a0 4b 11 80 	movl   $0x80114ba0,0x8(%ebp)
}
8010406a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010406d:	5b                   	pop    %ebx
8010406e:	5e                   	pop    %esi
8010406f:	5f                   	pop    %edi
80104070:	5d                   	pop    %ebp
            if (t->state == RUNNING || t->state == RUNNABLE) {
                cleanThread(t);
            }
        }
    }
    release(&ptable.lock);
80104071:	e9 5a 10 00 00       	jmp    801050d0 <release>
80104076:	8d 76 00             	lea    0x0(%esi),%esi
80104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104080 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104089:	e8 b2 0e 00 00       	call   80104f40 <pushcli>
    c = mycpu();
8010408e:	e8 6d f7 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80104093:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104099:	e8 e2 0e 00 00       	call   80104f80 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
8010409e:	e8 9d 0e 00 00       	call   80104f40 <pushcli>
    c = mycpu();
801040a3:	e8 58 f7 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
801040a8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801040ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
801040b1:	e8 ca 0e 00 00       	call   80104f80 <popcli>
    struct proc *curproc = myproc();
    struct proc *p;
    //struct thread *t;
    struct thread *curthread = mythread();
    int fd;
    if (DEBUGMODE > 0)
801040b6:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
801040bb:	85 c0                	test   %eax,%eax
801040bd:	7e 10                	jle    801040cf <exit+0x4f>
        cprintf("EXIT");
801040bf:	83 ec 0c             	sub    $0xc,%esp
801040c2:	68 11 83 10 80       	push   $0x80108311
801040c7:	e8 94 c5 ff ff       	call   80100660 <cprintf>
801040cc:	83 c4 10             	add    $0x10,%esp
    if (curproc == initproc)
801040cf:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
801040d5:	0f 84 98 01 00 00    	je     80104273 <exit+0x1f3>
//        }
//    }

    // if (DEBUGMODE > 0)
    //cprintf(" BEFORE cleanProcOneThread\n");
    cleanProcOneThread(curthread, curproc);
801040db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801040de:	83 ec 08             	sub    $0x8,%esp
801040e1:	8d 5e 60             	lea    0x60(%esi),%ebx
801040e4:	56                   	push   %esi
801040e5:	57                   	push   %edi
801040e6:	e8 f5 fe ff ff       	call   80103fe0 <cleanProcOneThread>
    // if (DEBUGMODE > 0)
    //cprintf(" AFTER cleanProcOneThread\n");
    acquire(&ptable.lock);
801040eb:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801040f2:	e8 29 0f 00 00       	call   80105020 <acquire>
    curproc->mainThread = curthread;
801040f7:	89 be b4 03 00 00    	mov    %edi,0x3b4(%esi)
801040fd:	8d 7e 20             	lea    0x20(%esi),%edi
80104100:	83 c4 10             	add    $0x10,%esp
80104103:	90                   	nop
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //When got here - the only thread that is RUNNINNg is curThread
    //all other threads are ZOMBIE

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
80104108:	8b 07                	mov    (%edi),%eax
8010410a:	85 c0                	test   %eax,%eax
8010410c:	74 12                	je     80104120 <exit+0xa0>
            fileclose(curproc->ofile[fd]);
8010410e:	83 ec 0c             	sub    $0xc,%esp
80104111:	50                   	push   %eax
80104112:	e8 29 cd ff ff       	call   80100e40 <fileclose>
            curproc->ofile[fd] = 0;
80104117:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010411d:	83 c4 10             	add    $0x10,%esp
80104120:	83 c7 04             	add    $0x4,%edi

    //When got here - the only thread that is RUNNINNg is curThread
    //all other threads are ZOMBIE

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
80104123:	39 df                	cmp    %ebx,%edi
80104125:	75 e1                	jne    80104108 <exit+0x88>
        if (curproc->ofile[fd]) {
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }
    if (holding(&ptable.lock))
80104127:	83 ec 0c             	sub    $0xc,%esp
8010412a:	68 a0 4b 11 80       	push   $0x80114ba0
8010412f:	e8 bc 0e 00 00       	call   80104ff0 <holding>
80104134:	83 c4 10             	add    $0x10,%esp
80104137:	85 c0                	test   %eax,%eax
80104139:	0f 85 1f 01 00 00    	jne    8010425e <exit+0x1de>
        release(&ptable.lock);

    begin_op();
8010413f:	e8 1c ea ff ff       	call   80102b60 <begin_op>
    iput(curproc->cwd);
80104144:	83 ec 0c             	sub    $0xc,%esp
80104147:	ff 76 60             	pushl  0x60(%esi)
8010414a:	e8 61 d6 ff ff       	call   801017b0 <iput>
    end_op();
8010414f:	e8 7c ea ff ff       	call   80102bd0 <end_op>
    curproc->cwd = 0;
80104154:	c7 46 60 00 00 00 00 	movl   $0x0,0x60(%esi)

    acquire(&ptable.lock);
8010415b:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80104162:	e8 b9 0e 00 00       	call   80105020 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent->mainThread);
80104167:	8b 46 10             	mov    0x10(%esi),%eax
8010416a:	83 c4 10             	add    $0x10,%esp
8010416d:	ba 88 4f 11 80       	mov    $0x80114f88,%edx
80104172:	8b 88 b4 03 00 00    	mov    0x3b4(%eax),%ecx
80104178:	eb 14                	jmp    8010418e <exit+0x10e>
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104180:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104186:	81 fa 88 3e 12 80    	cmp    $0x80123e88,%edx
8010418c:	74 2d                	je     801041bb <exit+0x13b>
        if (p->state != RUNNABLE)
8010418e:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
80104195:	75 e9                	jne    80104180 <exit+0x100>
80104197:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
8010419d:	eb 08                	jmp    801041a7 <exit+0x127>
8010419f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801041a0:	83 c0 34             	add    $0x34,%eax
801041a3:	39 d0                	cmp    %edx,%eax
801041a5:	73 d9                	jae    80104180 <exit+0x100>
            if (t->state == SLEEPING && t->chan == chan)
801041a7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801041ab:	75 f3                	jne    801041a0 <exit+0x120>
801041ad:	3b 48 18             	cmp    0x18(%eax),%ecx
801041b0:	75 ee                	jne    801041a0 <exit+0x120>
                t->state = RUNNABLE;
801041b2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801041b9:	eb e5                	jmp    801041a0 <exit+0x120>
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801041bb:	8b 3d bc b5 10 80    	mov    0x8010b5bc,%edi
801041c1:	b9 d4 4b 11 80       	mov    $0x80114bd4,%ecx
801041c6:	eb 16                	jmp    801041de <exit+0x15e>
801041c8:	90                   	nop
801041c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    // Parent might be sleeping in wait().
    wakeup1(curproc->parent->mainThread);
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041d0:	81 c1 bc 03 00 00    	add    $0x3bc,%ecx
801041d6:	81 f9 d4 3a 12 80    	cmp    $0x80123ad4,%ecx
801041dc:	74 5d                	je     8010423b <exit+0x1bb>
        if (p->parent == curproc) {
801041de:	39 71 10             	cmp    %esi,0x10(%ecx)
801041e1:	75 ed                	jne    801041d0 <exit+0x150>
            p->parent = initproc;
            if (p->state == ZOMBIE)
801041e3:	83 79 08 05          	cmpl   $0x5,0x8(%ecx)
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801041e7:	89 79 10             	mov    %edi,0x10(%ecx)
            if (p->state == ZOMBIE)
801041ea:	75 e4                	jne    801041d0 <exit+0x150>
                wakeup1(initproc->mainThread);
801041ec:	8b 9f b4 03 00 00    	mov    0x3b4(%edi),%ebx
801041f2:	ba 88 4f 11 80       	mov    $0x80114f88,%edx
801041f7:	eb 15                	jmp    8010420e <exit+0x18e>
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104200:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104206:	81 fa 88 3e 12 80    	cmp    $0x80123e88,%edx
8010420c:	74 c2                	je     801041d0 <exit+0x150>
        if (p->state != RUNNABLE)
8010420e:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
80104215:	75 e9                	jne    80104200 <exit+0x180>
80104217:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
8010421d:	eb 08                	jmp    80104227 <exit+0x1a7>
8010421f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104220:	83 c0 34             	add    $0x34,%eax
80104223:	39 d0                	cmp    %edx,%eax
80104225:	73 d9                	jae    80104200 <exit+0x180>
            if (t->state == SLEEPING && t->chan == chan)
80104227:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010422b:	75 f3                	jne    80104220 <exit+0x1a0>
8010422d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104230:	75 ee                	jne    80104220 <exit+0x1a0>
                t->state = RUNNABLE;
80104232:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104239:	eb e5                	jmp    80104220 <exit+0x1a0>
    }
    //cprintf(" AFTER Pass abandoned children to init.\n");

    //TODO- where to unlock
    //cleanThread(curthread);
    curthread->state = ZOMBIE;
8010423b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010423e:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    //curthread->killed=1;
    //release(curproc->procLock);

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
80104245:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
8010424c:	e8 7f fb ff ff       	call   80103dd0 <sched>
    panic("zombie exit");
80104251:	83 ec 0c             	sub    $0xc,%esp
80104254:	68 23 83 10 80       	push   $0x80108323
80104259:	e8 12 c1 ff ff       	call   80100370 <panic>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }
    if (holding(&ptable.lock))
        release(&ptable.lock);
8010425e:	83 ec 0c             	sub    $0xc,%esp
80104261:	68 a0 4b 11 80       	push   $0x80114ba0
80104266:	e8 65 0e 00 00       	call   801050d0 <release>
8010426b:	83 c4 10             	add    $0x10,%esp
8010426e:	e9 cc fe ff ff       	jmp    8010413f <exit+0xbf>
    struct thread *curthread = mythread();
    int fd;
    if (DEBUGMODE > 0)
        cprintf("EXIT");
    if (curproc == initproc)
        panic("init exiting");
80104273:	83 ec 0c             	sub    $0xc,%esp
80104276:	68 16 83 10 80       	push   $0x80108316
8010427b:	e8 f0 c0 ff ff       	call   80100370 <panic>

80104280 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	57                   	push   %edi
80104284:	56                   	push   %esi
80104285:	53                   	push   %ebx
80104286:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80104289:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
80104290:	7e 10                	jle    801042a2 <wait+0x22>
        cprintf(" WAIT ");
80104292:	83 ec 0c             	sub    $0xc,%esp
80104295:	68 2f 83 10 80       	push   $0x8010832f
8010429a:	e8 c1 c3 ff ff       	call   80100660 <cprintf>
8010429f:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801042a2:	e8 99 0c 00 00       	call   80104f40 <pushcli>
    c = mycpu();
801042a7:	e8 54 f5 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801042ac:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801042b2:	e8 c9 0c 00 00       	call   80104f80 <popcli>
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();
    struct thread *t;

    acquire(&ptable.lock);
801042b7:	83 ec 0c             	sub    $0xc,%esp
801042ba:	68 a0 4b 11 80       	push   $0x80114ba0
801042bf:	e8 5c 0d 00 00       	call   80105020 <acquire>
801042c4:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
801042c7:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042c9:	bb d4 4b 11 80       	mov    $0x80114bd4,%ebx
801042ce:	eb 0e                	jmp    801042de <wait+0x5e>
801042d0:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
801042d6:	81 fb d4 3a 12 80    	cmp    $0x80123ad4,%ebx
801042dc:	74 22                	je     80104300 <wait+0x80>
            if (p->parent != curproc)
801042de:	39 73 10             	cmp    %esi,0x10(%ebx)
801042e1:	75 ed                	jne    801042d0 <wait+0x50>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
801042e3:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
801042e7:	74 6a                	je     80104353 <wait+0xd3>

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042e9:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
            if (p->parent != curproc)
                continue;
            havekids = 1;
801042ef:	b8 01 00 00 00       	mov    $0x1,%eax

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042f4:	81 fb d4 3a 12 80    	cmp    $0x80123ad4,%ebx
801042fa:	75 e2                	jne    801042de <wait+0x5e>
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
80104300:	85 c0                	test   %eax,%eax
80104302:	0f 84 c6 00 00 00    	je     801043ce <wait+0x14e>
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104308:	e8 33 0c 00 00       	call   80104f40 <pushcli>
    c = mycpu();
8010430d:	e8 ee f4 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80104312:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104318:	e8 63 0c 00 00       	call   80104f80 <popcli>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
8010431d:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104320:	85 c0                	test   %eax,%eax
80104322:	0f 85 a6 00 00 00    	jne    801043ce <wait+0x14e>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104328:	e8 13 0c 00 00       	call   80104f40 <pushcli>
    c = mycpu();
8010432d:	e8 ce f4 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104332:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104338:	e8 43 0c 00 00       	call   80104f80 <popcli>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
8010433d:	83 ec 08             	sub    $0x8,%esp
80104340:	68 a0 4b 11 80       	push   $0x80114ba0
80104345:	53                   	push   %ebx
80104346:	e8 a5 fb ff ff       	call   80103ef0 <sleep>
    }
8010434b:	83 c4 10             	add    $0x10,%esp
8010434e:	e9 74 ff ff ff       	jmp    801042c7 <wait+0x47>
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
80104353:	8b 43 0c             	mov    0xc(%ebx),%eax
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104356:	8d 73 74             	lea    0x74(%ebx),%esi
80104359:	8d bb b4 03 00 00    	lea    0x3b4(%ebx),%edi
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
8010435f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104362:	eb 0b                	jmp    8010436f <wait+0xef>
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104368:	83 c6 34             	add    $0x34,%esi
8010436b:	39 f7                	cmp    %esi,%edi
8010436d:	76 1a                	jbe    80104389 <wait+0x109>
                    if (t->state != UNUSED)
8010436f:	8b 56 08             	mov    0x8(%esi),%edx
80104372:	85 d2                	test   %edx,%edx
80104374:	74 f2                	je     80104368 <wait+0xe8>
                        cleanThread(t);
80104376:	83 ec 0c             	sub    $0xc,%esp
80104379:	56                   	push   %esi
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010437a:	83 c6 34             	add    $0x34,%esi
                    if (t->state != UNUSED)
                        cleanThread(t);
8010437d:	e8 1e f4 ff ff       	call   801037a0 <cleanThread>
80104382:	83 c4 10             	add    $0x10,%esp
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104385:	39 f7                	cmp    %esi,%edi
80104387:	77 e6                	ja     8010436f <wait+0xef>
                    if (t->state != UNUSED)
                        cleanThread(t);
                }
//                release(p->procLock);

                freevm(p->pgdir);
80104389:	83 ec 0c             	sub    $0xc,%esp
8010438c:	ff 73 04             	pushl  0x4(%ebx)
8010438f:	e8 ec 35 00 00       	call   80107980 <freevm>
                p->pid = 0;
80104394:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
8010439b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
801043a2:	c6 43 64 00          	movb   $0x0,0x64(%ebx)
                p->killed = 0;
801043a6:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
801043ad:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
801043b4:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801043bb:	e8 10 0d 00 00       	call   801050d0 <release>
                return pid;
801043c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043c3:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
801043c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043c9:	5b                   	pop    %ebx
801043ca:	5e                   	pop    %esi
801043cb:	5f                   	pop    %edi
801043cc:	5d                   	pop    %ebp
801043cd:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
            release(&ptable.lock);
801043ce:	83 ec 0c             	sub    $0xc,%esp
801043d1:	68 a0 4b 11 80       	push   $0x80114ba0
801043d6:	e8 f5 0c 00 00       	call   801050d0 <release>
            return -1;
801043db:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
801043de:	8d 65 f4             	lea    -0xc(%ebp),%esp
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
            release(&ptable.lock);
            return -1;
801043e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
801043e6:	5b                   	pop    %ebx
801043e7:	5e                   	pop    %esi
801043e8:	5f                   	pop    %edi
801043e9:	5d                   	pop    %ebp
801043ea:	c3                   	ret    
801043eb:	90                   	nop
801043ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043f0 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 1)
801043f7:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801043fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 1)
80104401:	7e 10                	jle    80104413 <wakeup+0x23>
        cprintf(" WAKEUP ");
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	68 36 83 10 80       	push   $0x80108336
8010440b:	e8 50 c2 ff ff       	call   80100660 <cprintf>
80104410:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
80104413:	83 ec 0c             	sub    $0xc,%esp
80104416:	68 a0 4b 11 80       	push   $0x80114ba0
8010441b:	e8 00 0c 00 00       	call   80105020 <acquire>
80104420:	ba 88 4f 11 80       	mov    $0x80114f88,%edx
80104425:	83 c4 10             	add    $0x10,%esp
80104428:	eb 14                	jmp    8010443e <wakeup+0x4e>
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104430:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104436:	81 fa 88 3e 12 80    	cmp    $0x80123e88,%edx
8010443c:	74 2d                	je     8010446b <wakeup+0x7b>
        if (p->state != RUNNABLE)
8010443e:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
80104445:	75 e9                	jne    80104430 <wakeup+0x40>
80104447:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
8010444d:	eb 08                	jmp    80104457 <wakeup+0x67>
8010444f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104450:	83 c0 34             	add    $0x34,%eax
80104453:	39 d0                	cmp    %edx,%eax
80104455:	73 d9                	jae    80104430 <wakeup+0x40>
            if (t->state == SLEEPING && t->chan == chan)
80104457:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010445b:	75 f3                	jne    80104450 <wakeup+0x60>
8010445d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104460:	75 ee                	jne    80104450 <wakeup+0x60>
                t->state = RUNNABLE;
80104462:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104469:	eb e5                	jmp    80104450 <wakeup+0x60>
wakeup(void *chan) {
    if (DEBUGMODE > 1)
        cprintf(" WAKEUP ");
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
8010446b:	c7 45 08 a0 4b 11 80 	movl   $0x80114ba0,0x8(%ebp)
}
80104472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104475:	c9                   	leave  
wakeup(void *chan) {
    if (DEBUGMODE > 1)
        cprintf(" WAKEUP ");
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80104476:	e9 55 0c 00 00       	jmp    801050d0 <release>
8010447b:	90                   	nop
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 0)
80104487:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
8010448c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 0)
8010448f:	85 c0                	test   %eax,%eax
80104491:	7e 10                	jle    801044a3 <kill+0x23>
        cprintf(" KILL ");
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	68 3f 83 10 80       	push   $0x8010833f
8010449b:	e8 c0 c1 ff ff       	call   80100660 <cprintf>
801044a0:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    acquire(&ptable.lock);
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 a0 4b 11 80       	push   $0x80114ba0
801044ab:	e8 70 0b 00 00       	call   80105020 <acquire>
801044b0:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044b3:	b8 d4 4b 11 80       	mov    $0x80114bd4,%eax
801044b8:	eb 12                	jmp    801044cc <kill+0x4c>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044c0:	05 bc 03 00 00       	add    $0x3bc,%eax
801044c5:	3d d4 3a 12 80       	cmp    $0x80123ad4,%eax
801044ca:	74 64                	je     80104530 <kill+0xb0>
        if (p->pid == pid) {
801044cc:	39 58 0c             	cmp    %ebx,0xc(%eax)
801044cf:	75 ef                	jne    801044c0 <kill+0x40>
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801044d1:	8d 50 74             	lea    0x74(%eax),%edx
801044d4:	8d 88 b4 03 00 00    	lea    0x3b4(%eax),%ecx
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                t->killed = 1;
801044e0:	c7 42 1c 01 00 00 00 	movl   $0x1,0x1c(%edx)
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801044e7:	83 c2 34             	add    $0x34,%edx
801044ea:	39 ca                	cmp    %ecx,%edx
801044ec:	72 f2                	jb     801044e0 <kill+0x60>
                t->killed = 1;
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
801044ee:	8b 90 b4 03 00 00    	mov    0x3b4(%eax),%edx
801044f4:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
801044f8:	74 1e                	je     80104518 <kill+0x98>
                p->mainThread->state = RUNNABLE;
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
            }

            //release( p->procLock );
            release(&ptable.lock);
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	68 a0 4b 11 80       	push   $0x80114ba0
80104502:	e8 c9 0b 00 00       	call   801050d0 <release>
            return 0;
80104507:	83 c4 10             	add    $0x10,%esp
8010450a:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
8010450c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010450f:	c9                   	leave  
80104510:	c3                   	ret    
80104511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
                t->killed = 1;
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
                p->mainThread->state = RUNNABLE;
80104518:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
8010451f:	8b 80 b4 03 00 00    	mov    0x3b4(%eax),%eax
80104525:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010452c:	eb cc                	jmp    801044fa <kill+0x7a>
8010452e:	66 90                	xchg   %ax,%ax
            //release( p->procLock );
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104530:	83 ec 0c             	sub    $0xc,%esp
80104533:	68 a0 4b 11 80       	push   $0x80114ba0
80104538:	e8 93 0b 00 00       	call   801050d0 <release>
    return -1;
8010453d:	83 c4 10             	add    $0x10,%esp
80104540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104548:	c9                   	leave  
80104549:	c3                   	ret    
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	57                   	push   %edi
80104554:	56                   	push   %esi
80104555:	53                   	push   %ebx
80104556:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104559:	bb 38 4c 11 80       	mov    $0x80114c38,%ebx
8010455e:	83 ec 3c             	sub    $0x3c,%esp
80104561:	eb 27                	jmp    8010458a <procdump+0x3a>
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	68 e7 86 10 80       	push   $0x801086e7
80104570:	e8 eb c0 ff ff       	call   80100660 <cprintf>
80104575:	83 c4 10             	add    $0x10,%esp
80104578:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010457e:	81 fb 38 3b 12 80    	cmp    $0x80123b38,%ebx
80104584:	0f 84 96 00 00 00    	je     80104620 <procdump+0xd0>
        if (p->state == UNUSED)
8010458a:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010458d:	85 c0                	test   %eax,%eax
8010458f:	74 e7                	je     80104578 <procdump+0x28>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104591:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
80104594:	ba 46 83 10 80       	mov    $0x80108346,%edx
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104599:	77 11                	ja     801045ac <procdump+0x5c>
8010459b:	8b 14 85 c4 83 10 80 	mov    -0x7fef7c3c(,%eax,4),%edx
            state = states[p->state];
        else
            state = "???";
801045a2:	b8 46 83 10 80       	mov    $0x80108346,%eax
801045a7:	85 d2                	test   %edx,%edx
801045a9:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
801045ac:	53                   	push   %ebx
801045ad:	52                   	push   %edx
801045ae:	ff 73 a8             	pushl  -0x58(%ebx)
801045b1:	68 4a 83 10 80       	push   $0x8010834a
801045b6:	e8 a5 c0 ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
801045bb:	8b 83 50 03 00 00    	mov    0x350(%ebx),%eax
801045c1:	83 c4 10             	add    $0x10,%esp
801045c4:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801045c8:	75 9e                	jne    80104568 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
801045ca:	8d 4d c0             	lea    -0x40(%ebp),%ecx
801045cd:	83 ec 08             	sub    $0x8,%esp
801045d0:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045d3:	51                   	push   %ecx
801045d4:	8b 40 14             	mov    0x14(%eax),%eax
801045d7:	8b 40 0c             	mov    0xc(%eax),%eax
801045da:	83 c0 08             	add    $0x8,%eax
801045dd:	50                   	push   %eax
801045de:	e8 fd 08 00 00       	call   80104ee0 <getcallerpcs>
801045e3:	83 c4 10             	add    $0x10,%esp
801045e6:	8d 76 00             	lea    0x0(%esi),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801045f0:	8b 17                	mov    (%edi),%edx
801045f2:	85 d2                	test   %edx,%edx
801045f4:	0f 84 6e ff ff ff    	je     80104568 <procdump+0x18>
                cprintf(" %p", pc[i]);
801045fa:	83 ec 08             	sub    $0x8,%esp
801045fd:	83 c7 04             	add    $0x4,%edi
80104600:	52                   	push   %edx
80104601:	68 01 7d 10 80       	push   $0x80107d01
80104606:	e8 55 c0 ff ff       	call   80100660 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
8010460b:	83 c4 10             	add    $0x10,%esp
8010460e:	39 f7                	cmp    %esi,%edi
80104610:	75 de                	jne    801045f0 <procdump+0xa0>
80104612:	e9 51 ff ff ff       	jmp    80104568 <procdump+0x18>
80104617:	89 f6                	mov    %esi,%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80104620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104623:	5b                   	pop    %ebx
80104624:	5e                   	pop    %esi
80104625:	5f                   	pop    %edi
80104626:	5d                   	pop    %ebp
80104627:	c3                   	ret    
80104628:	90                   	nop
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104630 <kthread_create>:

//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104635:	e8 06 09 00 00       	call   80104f40 <pushcli>
    c = mycpu();
8010463a:	e8 c1 f1 ff ff       	call   80103800 <mycpu>
    p = c->proc;
8010463f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104645:	e8 36 09 00 00       	call   80104f80 <popcli>
//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    acquire(&ptable.lock);
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	68 a0 4b 11 80       	push   $0x80114ba0
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104652:	8d 5e 74             	lea    0x74(%esi),%ebx
//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    acquire(&ptable.lock);
80104655:	e8 c6 09 00 00       	call   80105020 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
8010465a:	8b 46 7c             	mov    0x7c(%esi),%eax
8010465d:	83 c4 10             	add    $0x10,%esp
80104660:	85 c0                	test   %eax,%eax
80104662:	74 3c                	je     801046a0 <kthread_create+0x70>
80104664:	8d 86 b4 03 00 00    	lea    0x3b4(%esi),%eax
8010466a:	eb 0b                	jmp    80104677 <kthread_create+0x47>
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104670:	8b 73 08             	mov    0x8(%ebx),%esi
80104673:	85 f6                	test   %esi,%esi
80104675:	74 29                	je     801046a0 <kthread_create+0x70>
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104677:	83 c3 34             	add    $0x34,%ebx
8010467a:	39 c3                	cmp    %eax,%ebx
8010467c:	72 f2                	jb     80104670 <kthread_create+0x40>
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
8010467e:	83 ec 0c             	sub    $0xc,%esp
80104681:	68 a0 4b 11 80       	push   $0x80114ba0
80104686:	e8 45 0a 00 00       	call   801050d0 <release>
        return -1;
8010468b:	83 c4 10             	add    $0x10,%esp
    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
8010468e:	8d 65 f8             	lea    -0x8(%ebp),%esp

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
        return -1;
80104691:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
80104696:	5b                   	pop    %ebx
80104697:	5e                   	pop    %esi
80104698:	5d                   	pop    %ebp
80104699:	c3                   	ret    
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
    t->tid = tidCounter++;
801046a0:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    //got here- didn't have a room for new thread
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
801046a5:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    t->tid = tidCounter++;
801046ac:	8d 50 01             	lea    0x1(%eax),%edx
801046af:	89 43 0c             	mov    %eax,0xc(%ebx)
801046b2:	89 15 08 b0 10 80    	mov    %edx,0x8010b008

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
801046b8:	e8 e3 dd ff ff       	call   801024a0 <kalloc>
801046bd:	85 c0                	test   %eax,%eax
801046bf:	89 43 04             	mov    %eax,0x4(%ebx)
801046c2:	0f 84 dd 00 00 00    	je     801047a5 <kthread_create+0x175>
    }

    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
801046c8:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
801046ce:	83 ec 04             	sub    $0x4,%esp
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
801046d1:	05 9c 0f 00 00       	add    $0xf9c,%eax
    }

    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
801046d6:	89 53 10             	mov    %edx,0x10(%ebx)
    t->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;
801046d9:	c7 40 14 ff 63 10 80 	movl   $0x801063ff,0x14(%eax)

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
801046e0:	89 43 14             	mov    %eax,0x14(%ebx)
    memset(t->context, 0, sizeof *t->context);
801046e3:	6a 14                	push   $0x14
801046e5:	6a 00                	push   $0x0
801046e7:	50                   	push   %eax
801046e8:	e8 43 0a 00 00       	call   80105130 <memset>
    t->context->eip = (uint) forkret;
801046ed:	8b 43 14             	mov    0x14(%ebx),%eax

    memset(t->tf, 0, sizeof(*t->tf));
801046f0:	83 c4 0c             	add    $0xc,%esp
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
801046f3:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)

    memset(t->tf, 0, sizeof(*t->tf));
801046fa:	6a 4c                	push   $0x4c
801046fc:	6a 00                	push   $0x0
801046fe:	ff 73 10             	pushl  0x10(%ebx)
80104701:	e8 2a 0a 00 00       	call   80105130 <memset>
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104706:	8b 43 10             	mov    0x10(%ebx),%eax
80104709:	ba 1b 00 00 00       	mov    $0x1b,%edx
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010470e:	b9 23 00 00 00       	mov    $0x23,%ecx
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;

    memset(t->tf, 0, sizeof(*t->tf));
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104713:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104717:	8b 43 10             	mov    0x10(%ebx),%eax
8010471a:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    t->tf->es = t->tf->ds;
8010471e:	8b 43 10             	mov    0x10(%ebx),%eax
80104721:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104725:	66 89 50 28          	mov    %dx,0x28(%eax)
    t->tf->ss = t->tf->ds;
80104729:	8b 43 10             	mov    0x10(%ebx),%eax
8010472c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104730:	66 89 50 48          	mov    %dx,0x48(%eax)
    t->tf->eflags = FL_IF;
80104734:	8b 43 10             	mov    0x10(%ebx),%eax
    t->tf->esp = PGSIZE;
    t->tf->eip = (uint) start_func;  // beginning of run func
80104737:	8b 55 08             	mov    0x8(%ebp),%edx
    memset(t->tf, 0, sizeof(*t->tf));
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    t->tf->es = t->tf->ds;
    t->tf->ss = t->tf->ds;
    t->tf->eflags = FL_IF;
8010473a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    t->tf->esp = PGSIZE;
80104741:	8b 43 10             	mov    0x10(%ebx),%eax
80104744:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    t->tf->eip = (uint) start_func;  // beginning of run func
8010474b:	8b 43 10             	mov    0x10(%ebx),%eax
8010474e:	89 50 38             	mov    %edx,0x38(%eax)
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104751:	e8 ea 07 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80104756:	e8 a5 f0 ff ff       	call   80103800 <mycpu>
    p = c->proc;
8010475b:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104761:	e8 1a 08 00 00       	call   80104f80 <popcli>
    t->tf->ss = t->tf->ds;
    t->tf->eflags = FL_IF;
    t->tf->esp = PGSIZE;
    t->tf->eip = (uint) start_func;  // beginning of run func

    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
80104766:	8d 43 20             	lea    0x20(%ebx),%eax
80104769:	83 c4 0c             	add    $0xc,%esp
8010476c:	83 c6 64             	add    $0x64,%esi
8010476f:	6a 10                	push   $0x10
80104771:	56                   	push   %esi
80104772:	50                   	push   %eax
80104773:	e8 b8 0b 00 00       	call   80105330 <safestrcpy>
    //t->cwd = namei("/");

    t->killed = 0;
80104778:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    t->chan = 0;
8010477f:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    t->state = RUNNABLE;
80104786:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    release(&ptable.lock);
8010478d:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80104794:	e8 37 09 00 00       	call   801050d0 <release>
    return 0;
80104799:	83 c4 10             	add    $0x10,%esp
}
8010479c:	8d 65 f8             	lea    -0x8(%ebp),%esp

    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
8010479f:	31 c0                	xor    %eax,%eax
}
801047a1:	5b                   	pop    %ebx
801047a2:	5e                   	pop    %esi
801047a3:	5d                   	pop    %ebp
801047a4:	c3                   	ret    
    t->state = EMBRYO;
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
801047a5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
801047ac:	e9 cd fe ff ff       	jmp    8010467e <kthread_create+0x4e>
801047b1:	eb 0d                	jmp    801047c0 <kthread_id>
801047b3:	90                   	nop
801047b4:	90                   	nop
801047b5:	90                   	nop
801047b6:	90                   	nop
801047b7:	90                   	nop
801047b8:	90                   	nop
801047b9:	90                   	nop
801047ba:	90                   	nop
801047bb:	90                   	nop
801047bc:	90                   	nop
801047bd:	90                   	nop
801047be:	90                   	nop
801047bf:	90                   	nop

801047c0 <kthread_id>:
    release(&ptable.lock);
    return 0;
}

//this func haven't been used - i's implementation is in sysproc
int kthread_id() {
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 04             	sub    $0x4,%esp
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
801047c7:	e8 74 07 00 00       	call   80104f40 <pushcli>
    c = mycpu();
801047cc:	e8 2f f0 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
801047d1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801047d7:	e8 a4 07 00 00       	call   80104f80 <popcli>
    return 0;
}

//this func haven't been used - i's implementation is in sysproc
int kthread_id() {
    return mythread()->tid;
801047dc:	8b 43 0c             	mov    0xc(%ebx),%eax
}
801047df:	83 c4 04             	add    $0x4,%esp
801047e2:	5b                   	pop    %ebx
801047e3:	5d                   	pop    %ebp
801047e4:	c3                   	ret    
801047e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047f0 <kthread_exit>:

void kthread_exit() {
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801047f7:	e8 44 07 00 00       	call   80104f40 <pushcli>
    c = mycpu();
801047fc:	e8 ff ef ff ff       	call   80103800 <mycpu>
    p = c->proc;
80104801:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104807:	e8 74 07 00 00       	call   80104f80 <popcli>

void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
8010480c:	83 ec 0c             	sub    $0xc,%esp
8010480f:	68 a0 4b 11 80       	push   $0x80114ba0
80104814:	e8 07 08 00 00       	call   80105020 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104819:	8d 43 74             	lea    0x74(%ebx),%eax
8010481c:	8d 8b b4 03 00 00    	lea    0x3b4(%ebx),%ecx
80104822:	83 c4 10             	add    $0x10,%esp
80104825:	31 db                	xor    %ebx,%ebx
80104827:	eb 13                	jmp    8010483c <kthread_exit+0x4c>
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (t->state == UNUSED || t->state == ZOMBIE)
80104830:	83 fa 05             	cmp    $0x5,%edx
80104833:	74 0e                	je     80104843 <kthread_exit+0x53>
void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104835:	83 c0 34             	add    $0x34,%eax
80104838:	39 c8                	cmp    %ecx,%eax
8010483a:	73 11                	jae    8010484d <kthread_exit+0x5d>
        if (t->state == UNUSED || t->state == ZOMBIE)
8010483c:	8b 50 08             	mov    0x8(%eax),%edx
8010483f:	85 d2                	test   %edx,%edx
80104841:	75 ed                	jne    80104830 <kthread_exit+0x40>
void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104843:	83 c0 34             	add    $0x34,%eax
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
80104846:	83 c3 01             	add    $0x1,%ebx
void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104849:	39 c8                	cmp    %ecx,%eax
8010484b:	72 ef                	jb     8010483c <kthread_exit+0x4c>
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
    }
    if (counter == (NTHREADS - 1)){ //all other threads aren't available -> close proc
8010484d:	83 fb 0f             	cmp    $0xf,%ebx
80104850:	74 1d                	je     8010486f <kthread_exit+0x7f>
        release(&ptable.lock);
        exit();
    }
    else{   //there are other threads in the same proc - close just the specific thread
        cleanThread(t);
80104852:	83 ec 0c             	sub    $0xc,%esp
80104855:	50                   	push   %eax
80104856:	e8 45 ef ff ff       	call   801037a0 <cleanThread>
        release(&ptable.lock);
8010485b:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80104862:	e8 69 08 00 00       	call   801050d0 <release>
    }
}
80104867:	83 c4 10             	add    $0x10,%esp
8010486a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010486d:	c9                   	leave  
8010486e:	c3                   	ret    
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
    }
    if (counter == (NTHREADS - 1)){ //all other threads aren't available -> close proc
        release(&ptable.lock);
8010486f:	83 ec 0c             	sub    $0xc,%esp
80104872:	68 a0 4b 11 80       	push   $0x80114ba0
80104877:	e8 54 08 00 00       	call   801050d0 <release>
        exit();
8010487c:	e8 ff f7 ff ff       	call   80104080 <exit>
80104881:	eb 0d                	jmp    80104890 <kthread_join>
80104883:	90                   	nop
80104884:	90                   	nop
80104885:	90                   	nop
80104886:	90                   	nop
80104887:	90                   	nop
80104888:	90                   	nop
80104889:	90                   	nop
8010488a:	90                   	nop
8010488b:	90                   	nop
8010488c:	90                   	nop
8010488d:	90                   	nop
8010488e:	90                   	nop
8010488f:	90                   	nop

80104890 <kthread_join>:
        cleanThread(t);
        release(&ptable.lock);
    }
}

int kthread_join(int thread_id) {
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 10             	sub    $0x10,%esp
80104897:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
8010489a:	68 a0 4b 11 80       	push   $0x80114ba0
8010489f:	e8 7c 07 00 00       	call   80105020 <acquire>
801048a4:	b9 48 4c 11 80       	mov    $0x80114c48,%ecx
801048a9:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != UNUSED) {
801048ac:	8b 51 94             	mov    -0x6c(%ecx),%edx
801048af:	89 c8                	mov    %ecx,%eax
801048b1:	85 d2                	test   %edx,%edx
801048b3:	74 1f                	je     801048d4 <kthread_join+0x44>
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->tid == thread_id)
801048b5:	39 59 0c             	cmp    %ebx,0xc(%ecx)
801048b8:	8d 91 40 03 00 00    	lea    0x340(%ecx),%edx
801048be:	75 0d                	jne    801048cd <kthread_join+0x3d>
801048c0:	eb 3e                	jmp    80104900 <kthread_join+0x70>
801048c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c8:	39 58 0c             	cmp    %ebx,0xc(%eax)
801048cb:	74 33                	je     80104900 <kthread_join+0x70>
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != UNUSED) {
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801048cd:	83 c0 34             	add    $0x34,%eax
801048d0:	39 d0                	cmp    %edx,%eax
801048d2:	72 f4                	jb     801048c8 <kthread_join+0x38>
801048d4:	81 c1 bc 03 00 00    	add    $0x3bc,%ecx

int kthread_join(int thread_id) {
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048da:	81 f9 48 3b 12 80    	cmp    $0x80123b48,%ecx
801048e0:	75 ca                	jne    801048ac <kthread_join+0x1c>
                    goto found2;
            }
        }
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
801048e2:	83 ec 0c             	sub    $0xc,%esp
801048e5:	68 a0 4b 11 80       	push   $0x80114ba0
801048ea:	e8 e1 07 00 00       	call   801050d0 <release>
    return -1;
801048ef:	83 c4 10             	add    $0x10,%esp
801048f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    sleep(t,&ptable.lock);
    //TODO - not sure about release
    if(holding(&ptable.lock))
        release(&ptable.lock);
    return 0;
}
801048f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048fa:	c9                   	leave  
801048fb:	c3                   	ret    
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
    return -1;
    found2:
    if (t->state == UNUSED || t->state == ZOMBIE){
80104900:	8b 50 08             	mov    0x8(%eax),%edx
80104903:	85 d2                	test   %edx,%edx
80104905:	74 db                	je     801048e2 <kthread_join+0x52>
80104907:	83 fa 05             	cmp    $0x5,%edx
8010490a:	74 d6                	je     801048e2 <kthread_join+0x52>
        release(&ptable.lock);
        return -1;
    }
    sleep(t,&ptable.lock);
8010490c:	83 ec 08             	sub    $0x8,%esp
8010490f:	68 a0 4b 11 80       	push   $0x80114ba0
80104914:	50                   	push   %eax
80104915:	e8 d6 f5 ff ff       	call   80103ef0 <sleep>
    //TODO - not sure about release
    if(holding(&ptable.lock))
8010491a:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80104921:	e8 ca 06 00 00       	call   80104ff0 <holding>
80104926:	83 c4 10             	add    $0x10,%esp
80104929:	85 c0                	test   %eax,%eax
8010492b:	74 ca                	je     801048f7 <kthread_join+0x67>
        release(&ptable.lock);
8010492d:	83 ec 0c             	sub    $0xc,%esp
80104930:	68 a0 4b 11 80       	push   $0x80114ba0
80104935:	e8 96 07 00 00       	call   801050d0 <release>
8010493a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010493d:	31 c0                	xor    %eax,%eax
}
8010493f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104942:	c9                   	leave  
80104943:	c3                   	ret    
80104944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010494a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104950 <kthread_mutex_alloc>:



int
kthread_mutex_alloc()
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104954:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx



int
kthread_mutex_alloc()
{
80104959:	83 ec 10             	sub    $0x10,%esp
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);
8010495c:	68 60 3d 11 80       	push   $0x80113d60
80104961:	e8 ba 06 00 00       	call   80105020 <acquire>
80104966:	83 c4 10             	add    $0x10,%esp
80104969:	eb 10                	jmp    8010497b <kthread_mutex_alloc+0x2b>
8010496b:	90                   	nop
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104970:	83 c3 38             	add    $0x38,%ebx
80104973:	81 fb 94 4b 11 80    	cmp    $0x80114b94,%ebx
80104979:	74 45                	je     801049c0 <kthread_mutex_alloc+0x70>
        if (!m->active)
8010497b:	8b 43 04             	mov    0x4(%ebx),%eax
8010497e:	85 c0                	test   %eax,%eax
80104980:	75 ee                	jne    80104970 <kthread_mutex_alloc+0x20>
    release(&mtable.lock);
    return -1;

    alloc_mutex:
    m->active = 1;
    m->mid = mutexCounter++;
80104982:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
80104987:	83 ec 0c             	sub    $0xc,%esp

    release(&mtable.lock);
    return -1;

    alloc_mutex:
    m->active = 1;
8010498a:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
    m->mid = mutexCounter++;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
80104991:	68 60 3d 11 80       	push   $0x80113d60
    return -1;

    alloc_mutex:
    m->active = 1;
    m->mid = mutexCounter++;
    m->locked = 0;
80104996:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    m->thread = 0;
8010499c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    release(&mtable.lock);
    return -1;

    alloc_mutex:
    m->active = 1;
    m->mid = mutexCounter++;
801049a3:	8d 50 01             	lea    0x1(%eax),%edx
801049a6:	89 43 08             	mov    %eax,0x8(%ebx)
801049a9:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
801049af:	e8 1c 07 00 00       	call   801050d0 <release>
    return m->mid;
801049b4:	8b 43 08             	mov    0x8(%ebx),%eax
801049b7:	83 c4 10             	add    $0x10,%esp


}
801049ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049bd:	c9                   	leave  
801049be:	c3                   	ret    
801049bf:	90                   	nop
    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if (!m->active)
            goto alloc_mutex;
    }

    release(&mtable.lock);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	68 60 3d 11 80       	push   $0x80113d60
801049c8:	e8 03 07 00 00       	call   801050d0 <release>
    return -1;
801049cd:	83 c4 10             	add    $0x10,%esp
801049d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    m->thread = 0;
    release(&mtable.lock);
    return m->mid;


}
801049d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d8:	c9                   	leave  
801049d9:	c3                   	ret    
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049e0 <kthread_mutex_dealloc>:


int
kthread_mutex_dealloc(int mutex_id){
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 10             	sub    $0x10,%esp
801049e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);
801049ea:	68 60 3d 11 80       	push   $0x80113d60
801049ef:	e8 2c 06 00 00       	call   80105020 <acquire>
801049f4:	83 c4 10             	add    $0x10,%esp

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
801049f7:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
801049fc:	eb 0c                	jmp    80104a0a <kthread_mutex_dealloc+0x2a>
801049fe:	66 90                	xchg   %ax,%ax
80104a00:	83 c0 38             	add    $0x38,%eax
80104a03:	3d 94 4b 11 80       	cmp    $0x80114b94,%eax
80104a08:	74 46                	je     80104a50 <kthread_mutex_dealloc+0x70>
        if ( m->mid == mutex_id ) {
80104a0a:	39 58 08             	cmp    %ebx,0x8(%eax)
80104a0d:	75 f1                	jne    80104a00 <kthread_mutex_dealloc+0x20>
            if( m->locked ){
80104a0f:	8b 10                	mov    (%eax),%edx
80104a11:	85 d2                	test   %edx,%edx
80104a13:	75 3b                	jne    80104a50 <kthread_mutex_dealloc+0x70>
    dealloc_mutex:
    m->active = 0;
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
80104a15:	83 ec 0c             	sub    $0xc,%esp

    release(&mtable.lock);
    return -1;

    dealloc_mutex:
    m->active = 0;
80104a18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    m->mid = -1;
80104a1f:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
    m->locked = 0;
80104a26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    m->thread = 0;
80104a2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    release(&mtable.lock);
80104a33:	68 60 3d 11 80       	push   $0x80113d60
80104a38:	e8 93 06 00 00       	call   801050d0 <release>
    return 0;
80104a3d:	83 c4 10             	add    $0x10,%esp
80104a40:	31 c0                	xor    %eax,%eax
}
80104a42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a45:	c9                   	leave  
80104a46:	c3                   	ret    
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if ( m->mid == mutex_id ) {
            if( m->locked ){
                release(&mtable.lock);
80104a50:	83 ec 0c             	sub    $0xc,%esp
80104a53:	68 60 3d 11 80       	push   $0x80113d60
80104a58:	e8 73 06 00 00       	call   801050d0 <release>
                return -1;
80104a5d:	83 c4 10             	add    $0x10,%esp
80104a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
    return 0;
}
80104a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a68:	c9                   	leave  
80104a69:	c3                   	ret    
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <mgetcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
// TODO NOT OUR CODE MIGHT BE REMOVED
void
mgetcallerpcs(void *v, uint pcs[])
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
80104a74:	8b 45 08             	mov    0x8(%ebp),%eax

// Record the current call stack in pcs[] by following the %ebp chain.
// TODO NOT OUR CODE MIGHT BE REMOVED
void
mgetcallerpcs(void *v, uint pcs[])
{
80104a77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
80104a7a:	8d 50 f8             	lea    -0x8(%eax),%edx
    for(i = 0; i < 10; i++){
80104a7d:	31 c0                	xor    %eax,%eax
80104a7f:	90                   	nop
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a80:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a86:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a8c:	77 1a                	ja     80104aa8 <mgetcallerpcs+0x38>
            break;
        pcs[i] = ebp[1];     // saved %eip
80104a8e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104a91:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104a94:	83 c0 01             	add    $0x1,%eax
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
80104a97:	8b 12                	mov    (%edx),%edx
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104a99:	83 f8 0a             	cmp    $0xa,%eax
80104a9c:	75 e2                	jne    80104a80 <mgetcallerpcs+0x10>
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
        pcs[i] = 0;
}
80104a9e:	5b                   	pop    %ebx
80104a9f:	5d                   	pop    %ebp
80104aa0:	c3                   	ret    
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
        pcs[i] = 0;
80104aa8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
80104aaf:	83 c0 01             	add    $0x1,%eax
80104ab2:	83 f8 0a             	cmp    $0xa,%eax
80104ab5:	74 e7                	je     80104a9e <mgetcallerpcs+0x2e>
        pcs[i] = 0;
80104ab7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
80104abe:	83 c0 01             	add    $0x1,%eax
80104ac1:	83 f8 0a             	cmp    $0xa,%eax
80104ac4:	75 e2                	jne    80104aa8 <mgetcallerpcs+0x38>
80104ac6:	eb d6                	jmp    80104a9e <mgetcallerpcs+0x2e>
80104ac8:	90                   	nop
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <mpushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
mpushcli(void)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	9c                   	pushf  
80104ad8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104ad9:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if(mycpu()->ncli == 0)
80104ada:	e8 21 ed ff ff       	call   80103800 <mycpu>
80104adf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ae5:	85 c0                	test   %eax,%eax
80104ae7:	75 11                	jne    80104afa <mpushcli+0x2a>
        mycpu()->intena = eflags & FL_IF;
80104ae9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104aef:	e8 0c ed ff ff       	call   80103800 <mycpu>
80104af4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
    mycpu()->ncli += 1;
80104afa:	e8 01 ed ff ff       	call   80103800 <mycpu>
80104aff:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b06:	83 c4 04             	add    $0x4,%esp
80104b09:	5b                   	pop    %ebx
80104b0a:	5d                   	pop    %ebp
80104b0b:	c3                   	ret    
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b10 <mpopcli>:

void
mpopcli(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b16:	9c                   	pushf  
80104b17:	58                   	pop    %eax
    if(readeflags()&FL_IF)
80104b18:	f6 c4 02             	test   $0x2,%ah
80104b1b:	75 52                	jne    80104b6f <mpopcli+0x5f>
        panic("popcli - interruptible");
    if(--mycpu()->ncli < 0)
80104b1d:	e8 de ec ff ff       	call   80103800 <mycpu>
80104b22:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104b28:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104b2b:	85 d2                	test   %edx,%edx
80104b2d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b33:	78 2d                	js     80104b62 <mpopcli+0x52>
        panic("popcli");
    if(mycpu()->ncli == 0 && mycpu()->intena)
80104b35:	e8 c6 ec ff ff       	call   80103800 <mycpu>
80104b3a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b40:	85 d2                	test   %edx,%edx
80104b42:	74 0c                	je     80104b50 <mpopcli+0x40>
        sti();
}
80104b44:	c9                   	leave  
80104b45:	c3                   	ret    
80104b46:	8d 76 00             	lea    0x0(%esi),%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
    if(readeflags()&FL_IF)
        panic("popcli - interruptible");
    if(--mycpu()->ncli < 0)
        panic("popcli");
    if(mycpu()->ncli == 0 && mycpu()->intena)
80104b50:	e8 ab ec ff ff       	call   80103800 <mycpu>
80104b55:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b5b:	85 c0                	test   %eax,%eax
80104b5d:	74 e5                	je     80104b44 <mpopcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104b5f:	fb                   	sti    
        sti();
}
80104b60:	c9                   	leave  
80104b61:	c3                   	ret    
mpopcli(void)
{
    if(readeflags()&FL_IF)
        panic("popcli - interruptible");
    if(--mycpu()->ncli < 0)
        panic("popcli");
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	68 6a 83 10 80       	push   $0x8010836a
80104b6a:	e8 01 b8 ff ff       	call   80100370 <panic>

void
mpopcli(void)
{
    if(readeflags()&FL_IF)
        panic("popcli - interruptible");
80104b6f:	83 ec 0c             	sub    $0xc,%esp
80104b72:	68 53 83 10 80       	push   $0x80108353
80104b77:	e8 f4 b7 ff ff       	call   80100370 <panic>
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b80 <kthread_mutex_lock>:



int
kthread_mutex_lock(int mutex_id)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	83 ec 10             	sub    $0x10,%esp
80104b88:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct kthread_mutex_t *m;

    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
80104b8b:	e8 40 ff ff ff       	call   80104ad0 <mpushcli>
    acquire(&mtable.lock);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	68 60 3d 11 80       	push   $0x80113d60
80104b98:	e8 83 04 00 00       	call   80105020 <acquire>

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104b9d:	c7 45 f4 94 3d 11 80 	movl   $0x80113d94,-0xc(%ebp)
80104ba4:	83 c4 10             	add    $0x10,%esp
80104ba7:	31 d2                	xor    %edx,%edx
80104ba9:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80104bae:	66 90                	xchg   %ax,%ax
        if (m->active && m->mid == mutex_id) {
80104bb0:	8b 48 04             	mov    0x4(%eax),%ecx
80104bb3:	85 c9                	test   %ecx,%ecx
80104bb5:	74 05                	je     80104bbc <kthread_mutex_lock+0x3c>
80104bb7:	39 58 08             	cmp    %ebx,0x8(%eax)
80104bba:	74 34                	je     80104bf0 <kthread_mutex_lock+0x70>
    struct kthread_mutex_t *m;

    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104bbc:	83 c0 38             	add    $0x38,%eax
80104bbf:	ba 01 00 00 00       	mov    $0x1,%edx
80104bc4:	3d 94 4b 11 80       	cmp    $0x80114b94,%eax
80104bc9:	75 e5                	jne    80104bb0 <kthread_mutex_lock+0x30>
            goto lock_mutex;

        }
    }

    release(&mtable.lock);
80104bcb:	83 ec 0c             	sub    $0xc,%esp
80104bce:	68 60 3d 11 80       	push   $0x80113d60
80104bd3:	e8 f8 04 00 00       	call   801050d0 <release>
    return -1;
80104bd8:	83 c4 10             	add    $0x10,%esp
    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
}
80104bdb:	8d 65 f8             	lea    -0x8(%ebp),%esp

        }
    }

    release(&mtable.lock);
    return -1;
80104bde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
}
80104be3:	5b                   	pop    %ebx
80104be4:	5e                   	pop    %esi
80104be5:	5d                   	pop    %ebp
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bf0:	84 d2                	test   %dl,%dl
80104bf2:	0f 85 c0 00 00 00    	jne    80104cb8 <kthread_mutex_lock+0x138>
    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if (m->active && m->mid == mutex_id) {
            if (m->locked) {
80104bf8:	8b 10                	mov    (%eax),%edx
80104bfa:	85 d2                	test   %edx,%edx
80104bfc:	0f 85 9e 00 00 00    	jne    80104ca0 <kthread_mutex_lock+0x120>
80104c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c05:	b9 01 00 00 00       	mov    $0x1,%ecx
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c10:	89 c8                	mov    %ecx,%eax
80104c12:	f0 87 02             	lock xchg %eax,(%edx)
    return -1;

    lock_mutex:

    // The xchg is atomic.
    while(xchg(&m->locked, 1) != 0)
80104c15:	85 c0                	test   %eax,%eax
80104c17:	75 f7                	jne    80104c10 <kthread_mutex_lock+0x90>
        ;

    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that the critical section's memory
    // references happen after the lock is acquired.
    __sync_synchronize();   // << TODO - not our line!!!
80104c19:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
80104c1e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104c21:	e8 1a 03 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80104c26:	e8 d5 eb ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104c2b:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80104c31:	e8 4a 03 00 00       	call   80104f80 <popcli>
    // references happen after the lock is acquired.
    __sync_synchronize();   // << TODO - not our line!!!

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
80104c36:	8d 4b 10             	lea    0x10(%ebx),%ecx
mgetcallerpcs(void *v, uint pcs[])
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
80104c39:	8d 55 ec             	lea    -0x14(%ebp),%edx
    for(i = 0; i < 10; i++){
80104c3c:	31 c0                	xor    %eax,%eax
    // past this point, to ensure that the critical section's memory
    // references happen after the lock is acquired.
    __sync_synchronize();   // << TODO - not our line!!!

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
80104c3e:	89 73 0c             	mov    %esi,0xc(%ebx)
80104c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c48:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104c4e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c54:	77 2a                	ja     80104c80 <kthread_mutex_lock+0x100>
            break;
        pcs[i] = ebp[1];     // saved %eip
80104c56:	8b 5a 04             	mov    0x4(%edx),%ebx
80104c59:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104c5c:	83 c0 01             	add    $0x1,%eax
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
80104c5f:	8b 12                	mov    (%edx),%edx
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104c61:	83 f8 0a             	cmp    $0xa,%eax
80104c64:	75 e2                	jne    80104c48 <kthread_mutex_lock+0xc8>
    __sync_synchronize();   // << TODO - not our line!!!

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
80104c66:	83 ec 0c             	sub    $0xc,%esp
80104c69:	68 60 3d 11 80       	push   $0x80113d60
80104c6e:	e8 5d 04 00 00       	call   801050d0 <release>
    return 0;
80104c73:	83 c4 10             	add    $0x10,%esp
}
80104c76:	8d 65 f8             	lea    -0x8(%ebp),%esp

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
80104c79:	31 c0                	xor    %eax,%eax
}
80104c7b:	5b                   	pop    %ebx
80104c7c:	5e                   	pop    %esi
80104c7d:	5d                   	pop    %ebp
80104c7e:	c3                   	ret    
80104c7f:	90                   	nop
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
        pcs[i] = 0;
80104c80:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
80104c87:	83 c0 01             	add    $0x1,%eax
80104c8a:	83 f8 0a             	cmp    $0xa,%eax
80104c8d:	74 d7                	je     80104c66 <kthread_mutex_lock+0xe6>
        pcs[i] = 0;
80104c8f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
80104c96:	83 c0 01             	add    $0x1,%eax
80104c99:	83 f8 0a             	cmp    $0xa,%eax
80104c9c:	75 e2                	jne    80104c80 <kthread_mutex_lock+0x100>
80104c9e:	eb c6                	jmp    80104c66 <kthread_mutex_lock+0xe6>
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if (m->active && m->mid == mutex_id) {
            if (m->locked) {
                sleep( m->thread , &mtable.lock );
80104ca0:	83 ec 08             	sub    $0x8,%esp
80104ca3:	68 60 3d 11 80       	push   $0x80113d60
80104ca8:	ff 70 0c             	pushl  0xc(%eax)
80104cab:	e8 40 f2 ff ff       	call   80103ef0 <sleep>
80104cb0:	83 c4 10             	add    $0x10,%esp
80104cb3:	e9 4a ff ff ff       	jmp    80104c02 <kthread_mutex_lock+0x82>
80104cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104cbb:	e9 38 ff ff ff       	jmp    80104bf8 <kthread_mutex_lock+0x78>

80104cc0 <kthread_mutex_unlock>:
}

// Release the lock.
int
kthread_mutex_unlock(int mutex_id)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104cc6:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
}

// Release the lock.
int
kthread_mutex_unlock(int mutex_id)
{
80104ccb:	83 ec 28             	sub    $0x28,%esp
80104cce:	8b 75 08             	mov    0x8(%ebp),%esi
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);
80104cd1:	68 60 3d 11 80       	push   $0x80113d60
80104cd6:	e8 45 03 00 00       	call   80105020 <acquire>
80104cdb:	83 c4 10             	add    $0x10,%esp
80104cde:	eb 0f                	jmp    80104cef <kthread_mutex_unlock+0x2f>

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104ce0:	83 c3 38             	add    $0x38,%ebx
80104ce3:	81 fb 94 4b 11 80    	cmp    $0x80114b94,%ebx
80104ce9:	0f 84 81 00 00 00    	je     80104d70 <kthread_mutex_unlock+0xb0>
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
80104cef:	8b 53 04             	mov    0x4(%ebx),%edx
80104cf2:	85 d2                	test   %edx,%edx
80104cf4:	74 ea                	je     80104ce0 <kthread_mutex_unlock+0x20>
80104cf6:	39 73 08             	cmp    %esi,0x8(%ebx)
80104cf9:	75 e5                	jne    80104ce0 <kthread_mutex_unlock+0x20>
80104cfb:	8b 03                	mov    (%ebx),%eax
80104cfd:	85 c0                	test   %eax,%eax
80104cff:	74 df                	je     80104ce0 <kthread_mutex_unlock+0x20>
80104d01:	8b 7b 0c             	mov    0xc(%ebx),%edi
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104d04:	e8 37 02 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80104d09:	e8 f2 ea ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104d0e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80104d17:	e8 64 02 00 00       	call   80104f80 <popcli>
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
80104d1c:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80104d1f:	75 bf                	jne    80104ce0 <kthread_mutex_unlock+0x20>
    release(&mtable.lock);
    return -1;

    unlock_mutex:

    m->pcs[0] = 0;
80104d21:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    m->thread = 0;
80104d28:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that all the stores in the critical
    // section are visible to other cores before the lock is released.
    // Both the C compiler and the hardware may re-order loads and
    // stores; __sync_synchronize() tells them both not to.
    __sync_synchronize();
80104d2f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    // Release the lock, equivalent to lk->locked = 0.
    // This code can't use a C assignment, since it might
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );
80104d34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104d3a:	e8 01 02 00 00       	call   80104f40 <pushcli>
    c = mycpu();
80104d3f:	e8 bc ea ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104d44:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104d4a:	e8 31 02 00 00       	call   80104f80 <popcli>
    // Release the lock, equivalent to lk->locked = 0.
    // This code can't use a C assignment, since it might
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
80104d4f:	83 ec 0c             	sub    $0xc,%esp
80104d52:	53                   	push   %ebx
80104d53:	e8 98 f6 ff ff       	call   801043f0 <wakeup>
    mpopcli();
80104d58:	e8 b3 fd ff ff       	call   80104b10 <mpopcli>
    return 0;
80104d5d:	83 c4 10             	add    $0x10,%esp
}
80104d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
    mpopcli();
    return 0;
80104d63:	31 c0                	xor    %eax,%eax
}
80104d65:	5b                   	pop    %ebx
80104d66:	5e                   	pop    %esi
80104d67:	5f                   	pop    %edi
80104d68:	5d                   	pop    %ebp
80104d69:	c3                   	ret    
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
                goto unlock_mutex;
    }

    release(&mtable.lock);
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	68 60 3d 11 80       	push   $0x80113d60
80104d78:	e8 53 03 00 00       	call   801050d0 <release>
    return -1;
80104d7d:	83 c4 10             	add    $0x10,%esp
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
    mpopcli();
    return 0;
}
80104d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
                goto unlock_mutex;
    }

    release(&mtable.lock);
    return -1;
80104d83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
    mpopcli();
    return 0;
}
80104d88:	5b                   	pop    %ebx
80104d89:	5e                   	pop    %esi
80104d8a:	5f                   	pop    %edi
80104d8b:	5d                   	pop    %ebp
80104d8c:	c3                   	ret    
80104d8d:	66 90                	xchg   %ax,%ax
80104d8f:	90                   	nop

80104d90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104d9a:	68 dc 83 10 80       	push   $0x801083dc
80104d9f:	8d 43 04             	lea    0x4(%ebx),%eax
80104da2:	50                   	push   %eax
80104da3:	e8 18 01 00 00       	call   80104ec0 <initlock>
  lk->name = name;
80104da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104dab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104db1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104db4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80104dbb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104dbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc1:	c9                   	leave  
80104dc2:	c3                   	ret    
80104dc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
80104dd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	8d 73 04             	lea    0x4(%ebx),%esi
80104dde:	56                   	push   %esi
80104ddf:	e8 3c 02 00 00       	call   80105020 <acquire>
  while (lk->locked) {
80104de4:	8b 13                	mov    (%ebx),%edx
80104de6:	83 c4 10             	add    $0x10,%esp
80104de9:	85 d2                	test   %edx,%edx
80104deb:	74 16                	je     80104e03 <acquiresleep+0x33>
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104df0:	83 ec 08             	sub    $0x8,%esp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
80104df5:	e8 f6 f0 ff ff       	call   80103ef0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104dfa:	8b 03                	mov    (%ebx),%eax
80104dfc:	83 c4 10             	add    $0x10,%esp
80104dff:	85 c0                	test   %eax,%eax
80104e01:	75 ed                	jne    80104df0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104e03:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104e09:	e8 92 ea ff ff       	call   801038a0 <myproc>
80104e0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e11:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104e14:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104e17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e1a:	5b                   	pop    %ebx
80104e1b:	5e                   	pop    %esi
80104e1c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80104e1d:	e9 ae 02 00 00       	jmp    801050d0 <release>
80104e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
80104e35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e38:	83 ec 0c             	sub    $0xc,%esp
80104e3b:	8d 73 04             	lea    0x4(%ebx),%esi
80104e3e:	56                   	push   %esi
80104e3f:	e8 dc 01 00 00       	call   80105020 <acquire>
  lk->locked = 0;
80104e44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104e4a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104e51:	89 1c 24             	mov    %ebx,(%esp)
80104e54:	e8 97 f5 ff ff       	call   801043f0 <wakeup>
  release(&lk->lk);
80104e59:	89 75 08             	mov    %esi,0x8(%ebp)
80104e5c:	83 c4 10             	add    $0x10,%esp
}
80104e5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e62:	5b                   	pop    %ebx
80104e63:	5e                   	pop    %esi
80104e64:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104e65:	e9 66 02 00 00       	jmp    801050d0 <release>
80104e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e70 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	53                   	push   %ebx
80104e76:	31 ff                	xor    %edi,%edi
80104e78:	83 ec 18             	sub    $0x18,%esp
80104e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104e7e:	8d 73 04             	lea    0x4(%ebx),%esi
80104e81:	56                   	push   %esi
80104e82:	e8 99 01 00 00       	call   80105020 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104e87:	8b 03                	mov    (%ebx),%eax
80104e89:	83 c4 10             	add    $0x10,%esp
80104e8c:	85 c0                	test   %eax,%eax
80104e8e:	74 13                	je     80104ea3 <holdingsleep+0x33>
80104e90:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e93:	e8 08 ea ff ff       	call   801038a0 <myproc>
80104e98:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104e9b:	0f 94 c0             	sete   %al
80104e9e:	0f b6 c0             	movzbl %al,%eax
80104ea1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104ea3:	83 ec 0c             	sub    $0xc,%esp
80104ea6:	56                   	push   %esi
80104ea7:	e8 24 02 00 00       	call   801050d0 <release>
  return r;
}
80104eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eaf:	89 f8                	mov    %edi,%eax
80104eb1:	5b                   	pop    %ebx
80104eb2:	5e                   	pop    %esi
80104eb3:	5f                   	pop    %edi
80104eb4:	5d                   	pop    %ebp
80104eb5:	c3                   	ret    
80104eb6:	66 90                	xchg   %ax,%ax
80104eb8:	66 90                	xchg   %ax,%ax
80104eba:	66 90                	xchg   %ax,%ax
80104ebc:	66 90                	xchg   %ax,%ax
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ec9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104ecf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104ed2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ed9:	5d                   	pop    %ebp
80104eda:	c3                   	ret    
80104edb:	90                   	nop
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104ee4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104eea:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104eed:	31 c0                	xor    %eax,%eax
80104eef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ef0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104ef6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104efc:	77 1a                	ja     80104f18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104efe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104f01:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f04:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104f07:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f09:	83 f8 0a             	cmp    $0xa,%eax
80104f0c:	75 e2                	jne    80104ef0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104f0e:	5b                   	pop    %ebx
80104f0f:	5d                   	pop    %ebp
80104f10:	c3                   	ret    
80104f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104f18:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f1f:	83 c0 01             	add    $0x1,%eax
80104f22:	83 f8 0a             	cmp    $0xa,%eax
80104f25:	74 e7                	je     80104f0e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104f27:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f2e:	83 c0 01             	add    $0x1,%eax
80104f31:	83 f8 0a             	cmp    $0xa,%eax
80104f34:	75 e2                	jne    80104f18 <getcallerpcs+0x38>
80104f36:	eb d6                	jmp    80104f0e <getcallerpcs+0x2e>
80104f38:	90                   	nop
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	53                   	push   %ebx
80104f44:	83 ec 04             	sub    $0x4,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f47:	9c                   	pushf  
80104f48:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104f49:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104f4a:	e8 b1 e8 ff ff       	call   80103800 <mycpu>
80104f4f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f55:	85 c0                	test   %eax,%eax
80104f57:	75 11                	jne    80104f6a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104f59:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104f5f:	e8 9c e8 ff ff       	call   80103800 <mycpu>
80104f64:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104f6a:	e8 91 e8 ff ff       	call   80103800 <mycpu>
80104f6f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104f76:	83 c4 04             	add    $0x4,%esp
80104f79:	5b                   	pop    %ebx
80104f7a:	5d                   	pop    %ebp
80104f7b:	c3                   	ret    
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <popcli>:

void
popcli(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f86:	9c                   	pushf  
80104f87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104f88:	f6 c4 02             	test   $0x2,%ah
80104f8b:	75 52                	jne    80104fdf <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104f8d:	e8 6e e8 ff ff       	call   80103800 <mycpu>
80104f92:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104f98:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104f9b:	85 d2                	test   %edx,%edx
80104f9d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104fa3:	78 2d                	js     80104fd2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104fa5:	e8 56 e8 ff ff       	call   80103800 <mycpu>
80104faa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104fb0:	85 d2                	test   %edx,%edx
80104fb2:	74 0c                	je     80104fc0 <popcli+0x40>
    sti();
}
80104fb4:	c9                   	leave  
80104fb5:	c3                   	ret    
80104fb6:	8d 76 00             	lea    0x0(%esi),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104fc0:	e8 3b e8 ff ff       	call   80103800 <mycpu>
80104fc5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104fcb:	85 c0                	test   %eax,%eax
80104fcd:	74 e5                	je     80104fb4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104fcf:	fb                   	sti    
    sti();
}
80104fd0:	c9                   	leave  
80104fd1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104fd2:	83 ec 0c             	sub    $0xc,%esp
80104fd5:	68 6a 83 10 80       	push   $0x8010836a
80104fda:	e8 91 b3 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104fdf:	83 ec 0c             	sub    $0xc,%esp
80104fe2:	68 53 83 10 80       	push   $0x80108353
80104fe7:	e8 84 b3 ff ff       	call   80100370 <panic>
80104fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
80104ff5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ff8:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104ffa:	e8 41 ff ff ff       	call   80104f40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104fff:	8b 06                	mov    (%esi),%eax
80105001:	85 c0                	test   %eax,%eax
80105003:	74 10                	je     80105015 <holding+0x25>
80105005:	8b 5e 08             	mov    0x8(%esi),%ebx
80105008:	e8 f3 e7 ff ff       	call   80103800 <mycpu>
8010500d:	39 c3                	cmp    %eax,%ebx
8010500f:	0f 94 c3             	sete   %bl
80105012:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105015:	e8 66 ff ff ff       	call   80104f80 <popcli>
  return r;
}
8010501a:	89 d8                	mov    %ebx,%eax
8010501c:	5b                   	pop    %ebx
8010501d:	5e                   	pop    %esi
8010501e:	5d                   	pop    %ebp
8010501f:	c3                   	ret    

80105020 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105027:	e8 14 ff ff ff       	call   80104f40 <pushcli>
  if(holding(lk))
8010502c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010502f:	83 ec 0c             	sub    $0xc,%esp
80105032:	53                   	push   %ebx
80105033:	e8 b8 ff ff ff       	call   80104ff0 <holding>
80105038:	83 c4 10             	add    $0x10,%esp
8010503b:	85 c0                	test   %eax,%eax
8010503d:	0f 85 7d 00 00 00    	jne    801050c0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105043:	ba 01 00 00 00       	mov    $0x1,%edx
80105048:	eb 09                	jmp    80105053 <acquire+0x33>
8010504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105050:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105053:	89 d0                	mov    %edx,%eax
80105055:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80105058:	85 c0                	test   %eax,%eax
8010505a:	75 f4                	jne    80105050 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010505c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105061:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105064:	e8 97 e7 ff ff       	call   80103800 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105069:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010506b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010506e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105071:	31 c0                	xor    %eax,%eax
80105073:	90                   	nop
80105074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105078:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010507e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105084:	77 1a                	ja     801050a0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105086:	8b 5a 04             	mov    0x4(%edx),%ebx
80105089:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010508c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010508f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105091:	83 f8 0a             	cmp    $0xa,%eax
80105094:	75 e2                	jne    80105078 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80105096:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105099:	c9                   	leave  
8010509a:	c3                   	ret    
8010509b:	90                   	nop
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801050a0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050a7:	83 c0 01             	add    $0x1,%eax
801050aa:	83 f8 0a             	cmp    $0xa,%eax
801050ad:	74 e7                	je     80105096 <acquire+0x76>
    pcs[i] = 0;
801050af:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050b6:	83 c0 01             	add    $0x1,%eax
801050b9:	83 f8 0a             	cmp    $0xa,%eax
801050bc:	75 e2                	jne    801050a0 <acquire+0x80>
801050be:	eb d6                	jmp    80105096 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801050c0:	83 ec 0c             	sub    $0xc,%esp
801050c3:	68 e7 83 10 80       	push   $0x801083e7
801050c8:	e8 a3 b2 ff ff       	call   80100370 <panic>
801050cd:	8d 76 00             	lea    0x0(%esi),%esi

801050d0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	53                   	push   %ebx
801050d4:	83 ec 10             	sub    $0x10,%esp
801050d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801050da:	53                   	push   %ebx
801050db:	e8 10 ff ff ff       	call   80104ff0 <holding>
801050e0:	83 c4 10             	add    $0x10,%esp
801050e3:	85 c0                	test   %eax,%eax
801050e5:	74 22                	je     80105109 <release+0x39>
  {
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
    panic("release");}

  lk->pcs[0] = 0;
801050e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801050ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801050f5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801050fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80105100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105103:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80105104:	e9 77 fe ff ff       	jmp    80104f80 <popcli>
void
release(struct spinlock *lk)
{
  if(!holding(lk))
  {
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
80105109:	50                   	push   %eax
8010510a:	50                   	push   %eax
8010510b:	ff 73 04             	pushl  0x4(%ebx)
8010510e:	68 f8 83 10 80       	push   $0x801083f8
80105113:	e8 48 b5 ff ff       	call   80100660 <cprintf>
    panic("release");}
80105118:	c7 04 24 ef 83 10 80 	movl   $0x801083ef,(%esp)
8010511f:	e8 4c b2 ff ff       	call   80100370 <panic>
80105124:	66 90                	xchg   %ax,%ax
80105126:	66 90                	xchg   %ax,%ax
80105128:	66 90                	xchg   %ax,%ax
8010512a:	66 90                	xchg   %ax,%ax
8010512c:	66 90                	xchg   %ax,%ax
8010512e:	66 90                	xchg   %ax,%ax

80105130 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	53                   	push   %ebx
80105135:	8b 55 08             	mov    0x8(%ebp),%edx
80105138:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010513b:	f6 c2 03             	test   $0x3,%dl
8010513e:	75 05                	jne    80105145 <memset+0x15>
80105140:	f6 c1 03             	test   $0x3,%cl
80105143:	74 13                	je     80105158 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80105145:	89 d7                	mov    %edx,%edi
80105147:	8b 45 0c             	mov    0xc(%ebp),%eax
8010514a:	fc                   	cld    
8010514b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010514d:	5b                   	pop    %ebx
8010514e:	89 d0                	mov    %edx,%eax
80105150:	5f                   	pop    %edi
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    
80105153:	90                   	nop
80105154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80105158:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010515c:	c1 e9 02             	shr    $0x2,%ecx
8010515f:	89 fb                	mov    %edi,%ebx
80105161:	89 f8                	mov    %edi,%eax
80105163:	c1 e3 18             	shl    $0x18,%ebx
80105166:	c1 e0 10             	shl    $0x10,%eax
80105169:	09 d8                	or     %ebx,%eax
8010516b:	09 f8                	or     %edi,%eax
8010516d:	c1 e7 08             	shl    $0x8,%edi
80105170:	09 f8                	or     %edi,%eax
80105172:	89 d7                	mov    %edx,%edi
80105174:	fc                   	cld    
80105175:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80105177:	5b                   	pop    %ebx
80105178:	89 d0                	mov    %edx,%eax
8010517a:	5f                   	pop    %edi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    
8010517d:	8d 76 00             	lea    0x0(%esi),%esi

80105180 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
80105185:	8b 45 10             	mov    0x10(%ebp),%eax
80105188:	53                   	push   %ebx
80105189:	8b 75 0c             	mov    0xc(%ebp),%esi
8010518c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010518f:	85 c0                	test   %eax,%eax
80105191:	74 29                	je     801051bc <memcmp+0x3c>
    if(*s1 != *s2)
80105193:	0f b6 13             	movzbl (%ebx),%edx
80105196:	0f b6 0e             	movzbl (%esi),%ecx
80105199:	38 d1                	cmp    %dl,%cl
8010519b:	75 2b                	jne    801051c8 <memcmp+0x48>
8010519d:	8d 78 ff             	lea    -0x1(%eax),%edi
801051a0:	31 c0                	xor    %eax,%eax
801051a2:	eb 14                	jmp    801051b8 <memcmp+0x38>
801051a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051a8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801051ad:	83 c0 01             	add    $0x1,%eax
801051b0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801051b4:	38 ca                	cmp    %cl,%dl
801051b6:	75 10                	jne    801051c8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801051b8:	39 f8                	cmp    %edi,%eax
801051ba:	75 ec                	jne    801051a8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801051bc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801051bd:	31 c0                	xor    %eax,%eax
}
801051bf:	5e                   	pop    %esi
801051c0:	5f                   	pop    %edi
801051c1:	5d                   	pop    %ebp
801051c2:	c3                   	ret    
801051c3:	90                   	nop
801051c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801051c8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
801051cb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801051cc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801051ce:	5e                   	pop    %esi
801051cf:	5f                   	pop    %edi
801051d0:	5d                   	pop    %ebp
801051d1:	c3                   	ret    
801051d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
801051e5:	8b 45 08             	mov    0x8(%ebp),%eax
801051e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801051eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801051ee:	39 c6                	cmp    %eax,%esi
801051f0:	73 2e                	jae    80105220 <memmove+0x40>
801051f2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801051f5:	39 c8                	cmp    %ecx,%eax
801051f7:	73 27                	jae    80105220 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801051f9:	85 db                	test   %ebx,%ebx
801051fb:	8d 53 ff             	lea    -0x1(%ebx),%edx
801051fe:	74 17                	je     80105217 <memmove+0x37>
      *--d = *--s;
80105200:	29 d9                	sub    %ebx,%ecx
80105202:	89 cb                	mov    %ecx,%ebx
80105204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105208:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010520c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010520f:	83 ea 01             	sub    $0x1,%edx
80105212:	83 fa ff             	cmp    $0xffffffff,%edx
80105215:	75 f1                	jne    80105208 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105217:	5b                   	pop    %ebx
80105218:	5e                   	pop    %esi
80105219:	5d                   	pop    %ebp
8010521a:	c3                   	ret    
8010521b:	90                   	nop
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105220:	31 d2                	xor    %edx,%edx
80105222:	85 db                	test   %ebx,%ebx
80105224:	74 f1                	je     80105217 <memmove+0x37>
80105226:	8d 76 00             	lea    0x0(%esi),%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80105230:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80105234:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105237:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010523a:	39 d3                	cmp    %edx,%ebx
8010523c:	75 f2                	jne    80105230 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010523e:	5b                   	pop    %ebx
8010523f:	5e                   	pop    %esi
80105240:	5d                   	pop    %ebp
80105241:	c3                   	ret    
80105242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105253:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105254:	eb 8a                	jmp    801051e0 <memmove>
80105256:	8d 76 00             	lea    0x0(%esi),%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
80105265:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105268:	53                   	push   %ebx
80105269:	8b 7d 08             	mov    0x8(%ebp),%edi
8010526c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010526f:	85 c9                	test   %ecx,%ecx
80105271:	74 37                	je     801052aa <strncmp+0x4a>
80105273:	0f b6 17             	movzbl (%edi),%edx
80105276:	0f b6 1e             	movzbl (%esi),%ebx
80105279:	84 d2                	test   %dl,%dl
8010527b:	74 3f                	je     801052bc <strncmp+0x5c>
8010527d:	38 d3                	cmp    %dl,%bl
8010527f:	75 3b                	jne    801052bc <strncmp+0x5c>
80105281:	8d 47 01             	lea    0x1(%edi),%eax
80105284:	01 cf                	add    %ecx,%edi
80105286:	eb 1b                	jmp    801052a3 <strncmp+0x43>
80105288:	90                   	nop
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105290:	0f b6 10             	movzbl (%eax),%edx
80105293:	84 d2                	test   %dl,%dl
80105295:	74 21                	je     801052b8 <strncmp+0x58>
80105297:	0f b6 19             	movzbl (%ecx),%ebx
8010529a:	83 c0 01             	add    $0x1,%eax
8010529d:	89 ce                	mov    %ecx,%esi
8010529f:	38 da                	cmp    %bl,%dl
801052a1:	75 19                	jne    801052bc <strncmp+0x5c>
801052a3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801052a5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801052a8:	75 e6                	jne    80105290 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801052aa:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801052ab:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801052ad:	5e                   	pop    %esi
801052ae:	5f                   	pop    %edi
801052af:	5d                   	pop    %ebp
801052b0:	c3                   	ret    
801052b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052b8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801052bc:	0f b6 c2             	movzbl %dl,%eax
801052bf:	29 d8                	sub    %ebx,%eax
}
801052c1:	5b                   	pop    %ebx
801052c2:	5e                   	pop    %esi
801052c3:	5f                   	pop    %edi
801052c4:	5d                   	pop    %ebp
801052c5:	c3                   	ret    
801052c6:	8d 76 00             	lea    0x0(%esi),%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
801052d5:	8b 45 08             	mov    0x8(%ebp),%eax
801052d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801052db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801052de:	89 c2                	mov    %eax,%edx
801052e0:	eb 19                	jmp    801052fb <strncpy+0x2b>
801052e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052e8:	83 c3 01             	add    $0x1,%ebx
801052eb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801052ef:	83 c2 01             	add    $0x1,%edx
801052f2:	84 c9                	test   %cl,%cl
801052f4:	88 4a ff             	mov    %cl,-0x1(%edx)
801052f7:	74 09                	je     80105302 <strncpy+0x32>
801052f9:	89 f1                	mov    %esi,%ecx
801052fb:	85 c9                	test   %ecx,%ecx
801052fd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105300:	7f e6                	jg     801052e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105302:	31 c9                	xor    %ecx,%ecx
80105304:	85 f6                	test   %esi,%esi
80105306:	7e 17                	jle    8010531f <strncpy+0x4f>
80105308:	90                   	nop
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105310:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105314:	89 f3                	mov    %esi,%ebx
80105316:	83 c1 01             	add    $0x1,%ecx
80105319:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010531b:	85 db                	test   %ebx,%ebx
8010531d:	7f f1                	jg     80105310 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010531f:	5b                   	pop    %ebx
80105320:	5e                   	pop    %esi
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret    
80105323:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	53                   	push   %ebx
80105335:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105338:	8b 45 08             	mov    0x8(%ebp),%eax
8010533b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010533e:	85 c9                	test   %ecx,%ecx
80105340:	7e 26                	jle    80105368 <safestrcpy+0x38>
80105342:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105346:	89 c1                	mov    %eax,%ecx
80105348:	eb 17                	jmp    80105361 <safestrcpy+0x31>
8010534a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105350:	83 c2 01             	add    $0x1,%edx
80105353:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105357:	83 c1 01             	add    $0x1,%ecx
8010535a:	84 db                	test   %bl,%bl
8010535c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010535f:	74 04                	je     80105365 <safestrcpy+0x35>
80105361:	39 f2                	cmp    %esi,%edx
80105363:	75 eb                	jne    80105350 <safestrcpy+0x20>
    ;
  *s = 0;
80105365:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105368:	5b                   	pop    %ebx
80105369:	5e                   	pop    %esi
8010536a:	5d                   	pop    %ebp
8010536b:	c3                   	ret    
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <strlen>:

int
strlen(const char *s)
{
80105370:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105371:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80105373:	89 e5                	mov    %esp,%ebp
80105375:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80105378:	80 3a 00             	cmpb   $0x0,(%edx)
8010537b:	74 0c                	je     80105389 <strlen+0x19>
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
80105380:	83 c0 01             	add    $0x1,%eax
80105383:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105387:	75 f7                	jne    80105380 <strlen+0x10>
    ;
  return n;
}
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    

8010538b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010538b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010538f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105393:	55                   	push   %ebp
  pushl %ebx
80105394:	53                   	push   %ebx
  pushl %esi
80105395:	56                   	push   %esi
  pushl %edi
80105396:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105397:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105399:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010539b:	5f                   	pop    %edi
  popl %esi
8010539c:	5e                   	pop    %esi
  popl %ebx
8010539d:	5b                   	pop    %ebx
  popl %ebp
8010539e:	5d                   	pop    %ebp
  ret
8010539f:	c3                   	ret    

801053a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	53                   	push   %ebx
801053a4:	83 ec 04             	sub    $0x4,%esp
801053a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801053aa:	e8 f1 e4 ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053af:	8b 00                	mov    (%eax),%eax
801053b1:	39 d8                	cmp    %ebx,%eax
801053b3:	76 1b                	jbe    801053d0 <fetchint+0x30>
801053b5:	8d 53 04             	lea    0x4(%ebx),%edx
801053b8:	39 d0                	cmp    %edx,%eax
801053ba:	72 14                	jb     801053d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801053bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801053bf:	8b 13                	mov    (%ebx),%edx
801053c1:	89 10                	mov    %edx,(%eax)
  return 0;
801053c3:	31 c0                	xor    %eax,%eax
}
801053c5:	83 c4 04             	add    $0x4,%esp
801053c8:	5b                   	pop    %ebx
801053c9:	5d                   	pop    %ebp
801053ca:	c3                   	ret    
801053cb:	90                   	nop
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801053d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d5:	eb ee                	jmp    801053c5 <fetchint+0x25>
801053d7:	89 f6                	mov    %esi,%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	53                   	push   %ebx
801053e4:	83 ec 04             	sub    $0x4,%esp
801053e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801053ea:	e8 b1 e4 ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz)
801053ef:	39 18                	cmp    %ebx,(%eax)
801053f1:	76 29                	jbe    8010541c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801053f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801053f6:	89 da                	mov    %ebx,%edx
801053f8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801053fa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801053fc:	39 c3                	cmp    %eax,%ebx
801053fe:	73 1c                	jae    8010541c <fetchstr+0x3c>
    if(*s == 0)
80105400:	80 3b 00             	cmpb   $0x0,(%ebx)
80105403:	75 10                	jne    80105415 <fetchstr+0x35>
80105405:	eb 29                	jmp    80105430 <fetchstr+0x50>
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105410:	80 3a 00             	cmpb   $0x0,(%edx)
80105413:	74 1b                	je     80105430 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105415:	83 c2 01             	add    $0x1,%edx
80105418:	39 d0                	cmp    %edx,%eax
8010541a:	77 f4                	ja     80105410 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010541c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010541f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80105424:	5b                   	pop    %ebx
80105425:	5d                   	pop    %ebp
80105426:	c3                   	ret    
80105427:	89 f6                	mov    %esi,%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105430:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80105433:	89 d0                	mov    %edx,%eax
80105435:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105437:	5b                   	pop    %ebx
80105438:	5d                   	pop    %ebp
80105439:	c3                   	ret    
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105440 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80105445:	e8 86 e4 ff ff       	call   801038d0 <mythread>
8010544a:	8b 40 10             	mov    0x10(%eax),%eax
8010544d:	8b 55 08             	mov    0x8(%ebp),%edx
80105450:	8b 40 44             	mov    0x44(%eax),%eax
80105453:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80105456:	e8 45 e4 ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010545b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
8010545d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105460:	39 c6                	cmp    %eax,%esi
80105462:	73 1c                	jae    80105480 <argint+0x40>
80105464:	8d 53 08             	lea    0x8(%ebx),%edx
80105467:	39 d0                	cmp    %edx,%eax
80105469:	72 15                	jb     80105480 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
8010546b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546e:	8b 53 04             	mov    0x4(%ebx),%edx
80105471:	89 10                	mov    %edx,(%eax)
  return 0;
80105473:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
}
80105475:	5b                   	pop    %ebx
80105476:	5e                   	pop    %esi
80105477:	5d                   	pop    %ebp
80105478:	c3                   	ret    
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105485:	eb ee                	jmp    80105475 <argint+0x35>
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	53                   	push   %ebx
80105495:	83 ec 10             	sub    $0x10,%esp
80105498:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010549b:	e8 00 e4 ff ff       	call   801038a0 <myproc>
801054a0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801054a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054a5:	83 ec 08             	sub    $0x8,%esp
801054a8:	50                   	push   %eax
801054a9:	ff 75 08             	pushl  0x8(%ebp)
801054ac:	e8 8f ff ff ff       	call   80105440 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801054b1:	c1 e8 1f             	shr    $0x1f,%eax
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	84 c0                	test   %al,%al
801054b9:	75 2d                	jne    801054e8 <argptr+0x58>
801054bb:	89 d8                	mov    %ebx,%eax
801054bd:	c1 e8 1f             	shr    $0x1f,%eax
801054c0:	84 c0                	test   %al,%al
801054c2:	75 24                	jne    801054e8 <argptr+0x58>
801054c4:	8b 16                	mov    (%esi),%edx
801054c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c9:	39 c2                	cmp    %eax,%edx
801054cb:	76 1b                	jbe    801054e8 <argptr+0x58>
801054cd:	01 c3                	add    %eax,%ebx
801054cf:	39 da                	cmp    %ebx,%edx
801054d1:	72 15                	jb     801054e8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
801054d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801054d6:	89 02                	mov    %eax,(%edx)
  return 0;
801054d8:	31 c0                	xor    %eax,%eax
}
801054da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054dd:	5b                   	pop    %ebx
801054de:	5e                   	pop    %esi
801054df:	5d                   	pop    %ebp
801054e0:	c3                   	ret    
801054e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
801054e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ed:	eb eb                	jmp    801054da <argptr+0x4a>
801054ef:	90                   	nop

801054f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801054f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f9:	50                   	push   %eax
801054fa:	ff 75 08             	pushl  0x8(%ebp)
801054fd:	e8 3e ff ff ff       	call   80105440 <argint>
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	85 c0                	test   %eax,%eax
80105507:	78 17                	js     80105520 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105509:	83 ec 08             	sub    $0x8,%esp
8010550c:	ff 75 0c             	pushl  0xc(%ebp)
8010550f:	ff 75 f4             	pushl  -0xc(%ebp)
80105512:	e8 c9 fe ff ff       	call   801053e0 <fetchstr>
80105517:	83 c4 10             	add    $0x10,%esp
}
8010551a:	c9                   	leave  
8010551b:	c3                   	ret    
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <syscall>:
[SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
80105536:	83 ec 0c             	sub    $0xc,%esp
  int num;
  struct proc *curproc = myproc();
80105539:	e8 62 e3 ff ff       	call   801038a0 <myproc>
8010553e:	89 c7                	mov    %eax,%edi
  struct thread *curthread = mythread();
80105540:	e8 8b e3 ff ff       	call   801038d0 <mythread>

  num = curthread->tf->eax;
80105545:	8b 70 10             	mov    0x10(%eax),%esi
void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
  struct thread *curthread = mythread();
80105548:	89 c3                	mov    %eax,%ebx

  num = curthread->tf->eax;
8010554a:	8b 56 1c             	mov    0x1c(%esi),%edx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010554d:	8d 42 ff             	lea    -0x1(%edx),%eax
80105550:	83 f8 18             	cmp    $0x18,%eax
80105553:	77 1b                	ja     80105570 <syscall+0x40>
80105555:	8b 04 95 40 84 10 80 	mov    -0x7fef7bc0(,%edx,4),%eax
8010555c:	85 c0                	test   %eax,%eax
8010555e:	74 10                	je     80105570 <syscall+0x40>
    curthread->tf->eax = syscalls[num]();
80105560:	ff d0                	call   *%eax
80105562:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
  }
}
80105565:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105568:	5b                   	pop    %ebx
80105569:	5e                   	pop    %esi
8010556a:	5f                   	pop    %edi
8010556b:	5d                   	pop    %ebp
8010556c:	c3                   	ret    
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
  num = curthread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curthread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105570:	8d 47 64             	lea    0x64(%edi),%eax

  num = curthread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curthread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105573:	52                   	push   %edx
80105574:	50                   	push   %eax
80105575:	ff 77 0c             	pushl  0xc(%edi)
80105578:	68 1a 84 10 80       	push   $0x8010841a
8010557d:	e8 de b0 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
80105582:	8b 43 10             	mov    0x10(%ebx),%eax
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010558f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105592:	5b                   	pop    %ebx
80105593:	5e                   	pop    %esi
80105594:	5f                   	pop    %edi
80105595:	5d                   	pop    %ebp
80105596:	c3                   	ret    
80105597:	66 90                	xchg   %ax,%ax
80105599:	66 90                	xchg   %ax,%ax
8010559b:	66 90                	xchg   %ax,%ax
8010559d:	66 90                	xchg   %ax,%ax
8010559f:	90                   	nop

801055a0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
801055a5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055a6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801055a9:	83 ec 44             	sub    $0x44,%esp
801055ac:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801055af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055b2:	56                   	push   %esi
801055b3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801055b4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801055b7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055ba:	e8 31 c9 ff ff       	call   80101ef0 <nameiparent>
801055bf:	83 c4 10             	add    $0x10,%esp
801055c2:	85 c0                	test   %eax,%eax
801055c4:	0f 84 f6 00 00 00    	je     801056c0 <create+0x120>
    return 0;
  ilock(dp);
801055ca:	83 ec 0c             	sub    $0xc,%esp
801055cd:	89 c7                	mov    %eax,%edi
801055cf:	50                   	push   %eax
801055d0:	e8 ab c0 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801055d5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801055d8:	83 c4 0c             	add    $0xc,%esp
801055db:	50                   	push   %eax
801055dc:	56                   	push   %esi
801055dd:	57                   	push   %edi
801055de:	e8 cd c5 ff ff       	call   80101bb0 <dirlookup>
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	89 c3                	mov    %eax,%ebx
801055ea:	74 54                	je     80105640 <create+0xa0>
    iunlockput(dp);
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	57                   	push   %edi
801055f0:	e8 1b c3 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
801055f5:	89 1c 24             	mov    %ebx,(%esp)
801055f8:	e8 83 c0 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105605:	75 19                	jne    80105620 <create+0x80>
80105607:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010560c:	89 d8                	mov    %ebx,%eax
8010560e:	75 10                	jne    80105620 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105610:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105613:	5b                   	pop    %ebx
80105614:	5e                   	pop    %esi
80105615:	5f                   	pop    %edi
80105616:	5d                   	pop    %ebp
80105617:	c3                   	ret    
80105618:	90                   	nop
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	53                   	push   %ebx
80105624:	e8 e7 c2 ff ff       	call   80101910 <iunlockput>
    return 0;
80105629:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010562c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010562f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105631:	5b                   	pop    %ebx
80105632:	5e                   	pop    %esi
80105633:	5f                   	pop    %edi
80105634:	5d                   	pop    %ebp
80105635:	c3                   	ret    
80105636:	8d 76 00             	lea    0x0(%esi),%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105640:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105644:	83 ec 08             	sub    $0x8,%esp
80105647:	50                   	push   %eax
80105648:	ff 37                	pushl  (%edi)
8010564a:	e8 c1 be ff ff       	call   80101510 <ialloc>
8010564f:	83 c4 10             	add    $0x10,%esp
80105652:	85 c0                	test   %eax,%eax
80105654:	89 c3                	mov    %eax,%ebx
80105656:	0f 84 cc 00 00 00    	je     80105728 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010565c:	83 ec 0c             	sub    $0xc,%esp
8010565f:	50                   	push   %eax
80105660:	e8 1b c0 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105665:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105669:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010566d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105671:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105675:	b8 01 00 00 00       	mov    $0x1,%eax
8010567a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010567e:	89 1c 24             	mov    %ebx,(%esp)
80105681:	e8 4a bf ff ff       	call   801015d0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010568e:	74 40                	je     801056d0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105690:	83 ec 04             	sub    $0x4,%esp
80105693:	ff 73 04             	pushl  0x4(%ebx)
80105696:	56                   	push   %esi
80105697:	57                   	push   %edi
80105698:	e8 73 c7 ff ff       	call   80101e10 <dirlink>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	85 c0                	test   %eax,%eax
801056a2:	78 77                	js     8010571b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801056a4:	83 ec 0c             	sub    $0xc,%esp
801056a7:	57                   	push   %edi
801056a8:	e8 63 c2 ff ff       	call   80101910 <iunlockput>

  return ip;
801056ad:	83 c4 10             	add    $0x10,%esp
}
801056b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801056b3:	89 d8                	mov    %ebx,%eax
}
801056b5:	5b                   	pop    %ebx
801056b6:	5e                   	pop    %esi
801056b7:	5f                   	pop    %edi
801056b8:	5d                   	pop    %ebp
801056b9:	c3                   	ret    
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801056c0:	31 c0                	xor    %eax,%eax
801056c2:	e9 49 ff ff ff       	jmp    80105610 <create+0x70>
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801056d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801056d5:	83 ec 0c             	sub    $0xc,%esp
801056d8:	57                   	push   %edi
801056d9:	e8 f2 be ff ff       	call   801015d0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801056de:	83 c4 0c             	add    $0xc,%esp
801056e1:	ff 73 04             	pushl  0x4(%ebx)
801056e4:	68 c4 84 10 80       	push   $0x801084c4
801056e9:	53                   	push   %ebx
801056ea:	e8 21 c7 ff ff       	call   80101e10 <dirlink>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	85 c0                	test   %eax,%eax
801056f4:	78 18                	js     8010570e <create+0x16e>
801056f6:	83 ec 04             	sub    $0x4,%esp
801056f9:	ff 77 04             	pushl  0x4(%edi)
801056fc:	68 c3 84 10 80       	push   $0x801084c3
80105701:	53                   	push   %ebx
80105702:	e8 09 c7 ff ff       	call   80101e10 <dirlink>
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	85 c0                	test   %eax,%eax
8010570c:	79 82                	jns    80105690 <create+0xf0>
      panic("create dots");
8010570e:	83 ec 0c             	sub    $0xc,%esp
80105711:	68 b7 84 10 80       	push   $0x801084b7
80105716:	e8 55 ac ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010571b:	83 ec 0c             	sub    $0xc,%esp
8010571e:	68 c6 84 10 80       	push   $0x801084c6
80105723:	e8 48 ac ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	68 a8 84 10 80       	push   $0x801084a8
80105730:	e8 3b ac ff ff       	call   80100370 <panic>
80105735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105740 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	56                   	push   %esi
80105744:	53                   	push   %ebx
80105745:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105747:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010574a:	89 d3                	mov    %edx,%ebx
8010574c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010574f:	50                   	push   %eax
80105750:	6a 00                	push   $0x0
80105752:	e8 e9 fc ff ff       	call   80105440 <argint>
80105757:	83 c4 10             	add    $0x10,%esp
8010575a:	85 c0                	test   %eax,%eax
8010575c:	78 32                	js     80105790 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010575e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105762:	77 2c                	ja     80105790 <argfd.constprop.0+0x50>
80105764:	e8 37 e1 ff ff       	call   801038a0 <myproc>
80105769:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010576c:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
80105770:	85 c0                	test   %eax,%eax
80105772:	74 1c                	je     80105790 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105774:	85 f6                	test   %esi,%esi
80105776:	74 02                	je     8010577a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105778:	89 16                	mov    %edx,(%esi)
  if(pf)
8010577a:	85 db                	test   %ebx,%ebx
8010577c:	74 22                	je     801057a0 <argfd.constprop.0+0x60>
    *pf = f;
8010577e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105780:	31 c0                	xor    %eax,%eax
}
80105782:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105785:	5b                   	pop    %ebx
80105786:	5e                   	pop    %esi
80105787:	5d                   	pop    %ebp
80105788:	c3                   	ret    
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105790:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105793:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105798:	5b                   	pop    %ebx
80105799:	5e                   	pop    %esi
8010579a:	5d                   	pop    %ebp
8010579b:	c3                   	ret    
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801057a0:	31 c0                	xor    %eax,%eax
801057a2:	eb de                	jmp    80105782 <argfd.constprop.0+0x42>
801057a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801057b0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801057b0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801057b1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801057b3:	89 e5                	mov    %esp,%ebp
801057b5:	56                   	push   %esi
801057b6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801057b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801057ba:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801057bd:	e8 7e ff ff ff       	call   80105740 <argfd.constprop.0>
801057c2:	85 c0                	test   %eax,%eax
801057c4:	78 1a                	js     801057e0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801057c6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801057c8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801057cb:	e8 d0 e0 ff ff       	call   801038a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801057d0:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
801057d4:	85 d2                	test   %edx,%edx
801057d6:	74 18                	je     801057f0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801057d8:	83 c3 01             	add    $0x1,%ebx
801057db:	83 fb 10             	cmp    $0x10,%ebx
801057de:	75 f0                	jne    801057d0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801057e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801057e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801057e8:	5b                   	pop    %ebx
801057e9:	5e                   	pop    %esi
801057ea:	5d                   	pop    %ebp
801057eb:	c3                   	ret    
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801057f0:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	ff 75 f4             	pushl  -0xc(%ebp)
801057fa:	e8 f1 b5 ff ff       	call   80100df0 <filedup>
  return fd;
801057ff:	83 c4 10             	add    $0x10,%esp
}
80105802:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105805:	89 d8                	mov    %ebx,%eax
}
80105807:	5b                   	pop    %ebx
80105808:	5e                   	pop    %esi
80105809:	5d                   	pop    %ebp
8010580a:	c3                   	ret    
8010580b:	90                   	nop
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_read>:

int
sys_read(void)
{
80105810:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105811:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105813:	89 e5                	mov    %esp,%ebp
80105815:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105818:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010581b:	e8 20 ff ff ff       	call   80105740 <argfd.constprop.0>
80105820:	85 c0                	test   %eax,%eax
80105822:	78 4c                	js     80105870 <sys_read+0x60>
80105824:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105827:	83 ec 08             	sub    $0x8,%esp
8010582a:	50                   	push   %eax
8010582b:	6a 02                	push   $0x2
8010582d:	e8 0e fc ff ff       	call   80105440 <argint>
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	85 c0                	test   %eax,%eax
80105837:	78 37                	js     80105870 <sys_read+0x60>
80105839:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010583c:	83 ec 04             	sub    $0x4,%esp
8010583f:	ff 75 f0             	pushl  -0x10(%ebp)
80105842:	50                   	push   %eax
80105843:	6a 01                	push   $0x1
80105845:	e8 46 fc ff ff       	call   80105490 <argptr>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	78 1f                	js     80105870 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105851:	83 ec 04             	sub    $0x4,%esp
80105854:	ff 75 f0             	pushl  -0x10(%ebp)
80105857:	ff 75 f4             	pushl  -0xc(%ebp)
8010585a:	ff 75 ec             	pushl  -0x14(%ebp)
8010585d:	e8 fe b6 ff ff       	call   80100f60 <fileread>
80105862:	83 c4 10             	add    $0x10,%esp
}
80105865:	c9                   	leave  
80105866:	c3                   	ret    
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <sys_write>:

int
sys_write(void)
{
80105880:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105881:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105883:	89 e5                	mov    %esp,%ebp
80105885:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105888:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010588b:	e8 b0 fe ff ff       	call   80105740 <argfd.constprop.0>
80105890:	85 c0                	test   %eax,%eax
80105892:	78 4c                	js     801058e0 <sys_write+0x60>
80105894:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105897:	83 ec 08             	sub    $0x8,%esp
8010589a:	50                   	push   %eax
8010589b:	6a 02                	push   $0x2
8010589d:	e8 9e fb ff ff       	call   80105440 <argint>
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	85 c0                	test   %eax,%eax
801058a7:	78 37                	js     801058e0 <sys_write+0x60>
801058a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ac:	83 ec 04             	sub    $0x4,%esp
801058af:	ff 75 f0             	pushl  -0x10(%ebp)
801058b2:	50                   	push   %eax
801058b3:	6a 01                	push   $0x1
801058b5:	e8 d6 fb ff ff       	call   80105490 <argptr>
801058ba:	83 c4 10             	add    $0x10,%esp
801058bd:	85 c0                	test   %eax,%eax
801058bf:	78 1f                	js     801058e0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801058c1:	83 ec 04             	sub    $0x4,%esp
801058c4:	ff 75 f0             	pushl  -0x10(%ebp)
801058c7:	ff 75 f4             	pushl  -0xc(%ebp)
801058ca:	ff 75 ec             	pushl  -0x14(%ebp)
801058cd:	e8 1e b7 ff ff       	call   80100ff0 <filewrite>
801058d2:	83 c4 10             	add    $0x10,%esp
}
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801058e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <sys_close>:

int
sys_close(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801058f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801058f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058fc:	e8 3f fe ff ff       	call   80105740 <argfd.constprop.0>
80105901:	85 c0                	test   %eax,%eax
80105903:	78 2b                	js     80105930 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105905:	e8 96 df ff ff       	call   801038a0 <myproc>
8010590a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010590d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105910:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
80105917:	00 
  fileclose(f);
80105918:	ff 75 f4             	pushl  -0xc(%ebp)
8010591b:	e8 20 b5 ff ff       	call   80100e40 <fileclose>
  return 0;
80105920:	83 c4 10             	add    $0x10,%esp
80105923:	31 c0                	xor    %eax,%eax
}
80105925:	c9                   	leave  
80105926:	c3                   	ret    
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105935:	c9                   	leave  
80105936:	c3                   	ret    
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105940 <sys_fstat>:

int
sys_fstat(void)
{
80105940:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105941:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105943:	89 e5                	mov    %esp,%ebp
80105945:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105948:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010594b:	e8 f0 fd ff ff       	call   80105740 <argfd.constprop.0>
80105950:	85 c0                	test   %eax,%eax
80105952:	78 2c                	js     80105980 <sys_fstat+0x40>
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105957:	83 ec 04             	sub    $0x4,%esp
8010595a:	6a 14                	push   $0x14
8010595c:	50                   	push   %eax
8010595d:	6a 01                	push   $0x1
8010595f:	e8 2c fb ff ff       	call   80105490 <argptr>
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
80105969:	78 15                	js     80105980 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010596b:	83 ec 08             	sub    $0x8,%esp
8010596e:	ff 75 f4             	pushl  -0xc(%ebp)
80105971:	ff 75 f0             	pushl  -0x10(%ebp)
80105974:	e8 97 b5 ff ff       	call   80100f10 <filestat>
80105979:	83 c4 10             	add    $0x10,%esp
}
8010597c:	c9                   	leave  
8010597d:	c3                   	ret    
8010597e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105990 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	57                   	push   %edi
80105994:	56                   	push   %esi
80105995:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105996:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105999:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010599c:	50                   	push   %eax
8010599d:	6a 00                	push   $0x0
8010599f:	e8 4c fb ff ff       	call   801054f0 <argstr>
801059a4:	83 c4 10             	add    $0x10,%esp
801059a7:	85 c0                	test   %eax,%eax
801059a9:	0f 88 fb 00 00 00    	js     80105aaa <sys_link+0x11a>
801059af:	8d 45 d0             	lea    -0x30(%ebp),%eax
801059b2:	83 ec 08             	sub    $0x8,%esp
801059b5:	50                   	push   %eax
801059b6:	6a 01                	push   $0x1
801059b8:	e8 33 fb ff ff       	call   801054f0 <argstr>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	0f 88 e2 00 00 00    	js     80105aaa <sys_link+0x11a>
    return -1;

  begin_op();
801059c8:	e8 93 d1 ff ff       	call   80102b60 <begin_op>
  if((ip = namei(old)) == 0){
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801059d3:	e8 f8 c4 ff ff       	call   80101ed0 <namei>
801059d8:	83 c4 10             	add    $0x10,%esp
801059db:	85 c0                	test   %eax,%eax
801059dd:	89 c3                	mov    %eax,%ebx
801059df:	0f 84 f3 00 00 00    	je     80105ad8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
801059e5:	83 ec 0c             	sub    $0xc,%esp
801059e8:	50                   	push   %eax
801059e9:	e8 92 bc ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059f6:	0f 84 c4 00 00 00    	je     80105ac0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801059fc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a01:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105a04:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105a07:	53                   	push   %ebx
80105a08:	e8 c3 bb ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80105a0d:	89 1c 24             	mov    %ebx,(%esp)
80105a10:	e8 4b bd ff ff       	call   80101760 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105a15:	58                   	pop    %eax
80105a16:	5a                   	pop    %edx
80105a17:	57                   	push   %edi
80105a18:	ff 75 d0             	pushl  -0x30(%ebp)
80105a1b:	e8 d0 c4 ff ff       	call   80101ef0 <nameiparent>
80105a20:	83 c4 10             	add    $0x10,%esp
80105a23:	85 c0                	test   %eax,%eax
80105a25:	89 c6                	mov    %eax,%esi
80105a27:	74 5b                	je     80105a84 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	50                   	push   %eax
80105a2d:	e8 4e bc ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	8b 03                	mov    (%ebx),%eax
80105a37:	39 06                	cmp    %eax,(%esi)
80105a39:	75 3d                	jne    80105a78 <sys_link+0xe8>
80105a3b:	83 ec 04             	sub    $0x4,%esp
80105a3e:	ff 73 04             	pushl  0x4(%ebx)
80105a41:	57                   	push   %edi
80105a42:	56                   	push   %esi
80105a43:	e8 c8 c3 ff ff       	call   80101e10 <dirlink>
80105a48:	83 c4 10             	add    $0x10,%esp
80105a4b:	85 c0                	test   %eax,%eax
80105a4d:	78 29                	js     80105a78 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105a4f:	83 ec 0c             	sub    $0xc,%esp
80105a52:	56                   	push   %esi
80105a53:	e8 b8 be ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105a58:	89 1c 24             	mov    %ebx,(%esp)
80105a5b:	e8 50 bd ff ff       	call   801017b0 <iput>

  end_op();
80105a60:	e8 6b d1 ff ff       	call   80102bd0 <end_op>

  return 0;
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105a6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a6d:	5b                   	pop    %ebx
80105a6e:	5e                   	pop    %esi
80105a6f:	5f                   	pop    %edi
80105a70:	5d                   	pop    %ebp
80105a71:	c3                   	ret    
80105a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	56                   	push   %esi
80105a7c:	e8 8f be ff ff       	call   80101910 <iunlockput>
    goto bad;
80105a81:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	53                   	push   %ebx
80105a88:	e8 f3 bb ff ff       	call   80101680 <ilock>
  ip->nlink--;
80105a8d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a92:	89 1c 24             	mov    %ebx,(%esp)
80105a95:	e8 36 bb ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105a9a:	89 1c 24             	mov    %ebx,(%esp)
80105a9d:	e8 6e be ff ff       	call   80101910 <iunlockput>
  end_op();
80105aa2:	e8 29 d1 ff ff       	call   80102bd0 <end_op>
  return -1;
80105aa7:	83 c4 10             	add    $0x10,%esp
}
80105aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80105aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab2:	5b                   	pop    %ebx
80105ab3:	5e                   	pop    %esi
80105ab4:	5f                   	pop    %edi
80105ab5:	5d                   	pop    %ebp
80105ab6:	c3                   	ret    
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	53                   	push   %ebx
80105ac4:	e8 47 be ff ff       	call   80101910 <iunlockput>
    end_op();
80105ac9:	e8 02 d1 ff ff       	call   80102bd0 <end_op>
    return -1;
80105ace:	83 c4 10             	add    $0x10,%esp
80105ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad6:	eb 92                	jmp    80105a6a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105ad8:	e8 f3 d0 ff ff       	call   80102bd0 <end_op>
    return -1;
80105add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae2:	eb 86                	jmp    80105a6a <sys_link+0xda>
80105ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105af0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105af6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105af9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105afc:	50                   	push   %eax
80105afd:	6a 00                	push   $0x0
80105aff:	e8 ec f9 ff ff       	call   801054f0 <argstr>
80105b04:	83 c4 10             	add    $0x10,%esp
80105b07:	85 c0                	test   %eax,%eax
80105b09:	0f 88 82 01 00 00    	js     80105c91 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105b0f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105b12:	e8 49 d0 ff ff       	call   80102b60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b17:	83 ec 08             	sub    $0x8,%esp
80105b1a:	53                   	push   %ebx
80105b1b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b1e:	e8 cd c3 ff ff       	call   80101ef0 <nameiparent>
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	85 c0                	test   %eax,%eax
80105b28:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105b2b:	0f 84 6a 01 00 00    	je     80105c9b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105b31:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105b34:	83 ec 0c             	sub    $0xc,%esp
80105b37:	56                   	push   %esi
80105b38:	e8 43 bb ff ff       	call   80101680 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b3d:	58                   	pop    %eax
80105b3e:	5a                   	pop    %edx
80105b3f:	68 c4 84 10 80       	push   $0x801084c4
80105b44:	53                   	push   %ebx
80105b45:	e8 46 c0 ff ff       	call   80101b90 <namecmp>
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	0f 84 fc 00 00 00    	je     80105c51 <sys_unlink+0x161>
80105b55:	83 ec 08             	sub    $0x8,%esp
80105b58:	68 c3 84 10 80       	push   $0x801084c3
80105b5d:	53                   	push   %ebx
80105b5e:	e8 2d c0 ff ff       	call   80101b90 <namecmp>
80105b63:	83 c4 10             	add    $0x10,%esp
80105b66:	85 c0                	test   %eax,%eax
80105b68:	0f 84 e3 00 00 00    	je     80105c51 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b6e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105b71:	83 ec 04             	sub    $0x4,%esp
80105b74:	50                   	push   %eax
80105b75:	53                   	push   %ebx
80105b76:	56                   	push   %esi
80105b77:	e8 34 c0 ff ff       	call   80101bb0 <dirlookup>
80105b7c:	83 c4 10             	add    $0x10,%esp
80105b7f:	85 c0                	test   %eax,%eax
80105b81:	89 c3                	mov    %eax,%ebx
80105b83:	0f 84 c8 00 00 00    	je     80105c51 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105b89:	83 ec 0c             	sub    $0xc,%esp
80105b8c:	50                   	push   %eax
80105b8d:	e8 ee ba ff ff       	call   80101680 <ilock>

  if(ip->nlink < 1)
80105b92:	83 c4 10             	add    $0x10,%esp
80105b95:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b9a:	0f 8e 24 01 00 00    	jle    80105cc4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ba0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ba5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105ba8:	74 66                	je     80105c10 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105baa:	83 ec 04             	sub    $0x4,%esp
80105bad:	6a 10                	push   $0x10
80105baf:	6a 00                	push   $0x0
80105bb1:	56                   	push   %esi
80105bb2:	e8 79 f5 ff ff       	call   80105130 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bb7:	6a 10                	push   $0x10
80105bb9:	ff 75 c4             	pushl  -0x3c(%ebp)
80105bbc:	56                   	push   %esi
80105bbd:	ff 75 b4             	pushl  -0x4c(%ebp)
80105bc0:	e8 9b be ff ff       	call   80101a60 <writei>
80105bc5:	83 c4 20             	add    $0x20,%esp
80105bc8:	83 f8 10             	cmp    $0x10,%eax
80105bcb:	0f 85 e6 00 00 00    	jne    80105cb7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105bd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bd6:	0f 84 9c 00 00 00    	je     80105c78 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105bdc:	83 ec 0c             	sub    $0xc,%esp
80105bdf:	ff 75 b4             	pushl  -0x4c(%ebp)
80105be2:	e8 29 bd ff ff       	call   80101910 <iunlockput>

  ip->nlink--;
80105be7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105bec:	89 1c 24             	mov    %ebx,(%esp)
80105bef:	e8 dc b9 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105bf4:	89 1c 24             	mov    %ebx,(%esp)
80105bf7:	e8 14 bd ff ff       	call   80101910 <iunlockput>

  end_op();
80105bfc:	e8 cf cf ff ff       	call   80102bd0 <end_op>

  return 0;
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c09:	5b                   	pop    %ebx
80105c0a:	5e                   	pop    %esi
80105c0b:	5f                   	pop    %edi
80105c0c:	5d                   	pop    %ebp
80105c0d:	c3                   	ret    
80105c0e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c10:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105c14:	76 94                	jbe    80105baa <sys_unlink+0xba>
80105c16:	bf 20 00 00 00       	mov    $0x20,%edi
80105c1b:	eb 0f                	jmp    80105c2c <sys_unlink+0x13c>
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
80105c20:	83 c7 10             	add    $0x10,%edi
80105c23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105c26:	0f 83 7e ff ff ff    	jae    80105baa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c2c:	6a 10                	push   $0x10
80105c2e:	57                   	push   %edi
80105c2f:	56                   	push   %esi
80105c30:	53                   	push   %ebx
80105c31:	e8 2a bd ff ff       	call   80101960 <readi>
80105c36:	83 c4 10             	add    $0x10,%esp
80105c39:	83 f8 10             	cmp    $0x10,%eax
80105c3c:	75 6c                	jne    80105caa <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105c3e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105c43:	74 db                	je     80105c20 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105c45:	83 ec 0c             	sub    $0xc,%esp
80105c48:	53                   	push   %ebx
80105c49:	e8 c2 bc ff ff       	call   80101910 <iunlockput>
    goto bad;
80105c4e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105c51:	83 ec 0c             	sub    $0xc,%esp
80105c54:	ff 75 b4             	pushl  -0x4c(%ebp)
80105c57:	e8 b4 bc ff ff       	call   80101910 <iunlockput>
  end_op();
80105c5c:	e8 6f cf ff ff       	call   80102bd0 <end_op>
  return -1;
80105c61:	83 c4 10             	add    $0x10,%esp
}
80105c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c6c:	5b                   	pop    %ebx
80105c6d:	5e                   	pop    %esi
80105c6e:	5f                   	pop    %edi
80105c6f:	5d                   	pop    %ebp
80105c70:	c3                   	ret    
80105c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105c78:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105c7b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105c7e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105c83:	50                   	push   %eax
80105c84:	e8 47 b9 ff ff       	call   801015d0 <iupdate>
80105c89:	83 c4 10             	add    $0x10,%esp
80105c8c:	e9 4b ff ff ff       	jmp    80105bdc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c96:	e9 6b ff ff ff       	jmp    80105c06 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105c9b:	e8 30 cf ff ff       	call   80102bd0 <end_op>
    return -1;
80105ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca5:	e9 5c ff ff ff       	jmp    80105c06 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80105caa:	83 ec 0c             	sub    $0xc,%esp
80105cad:	68 e8 84 10 80       	push   $0x801084e8
80105cb2:	e8 b9 a6 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105cb7:	83 ec 0c             	sub    $0xc,%esp
80105cba:	68 fa 84 10 80       	push   $0x801084fa
80105cbf:	e8 ac a6 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105cc4:	83 ec 0c             	sub    $0xc,%esp
80105cc7:	68 d6 84 10 80       	push   $0x801084d6
80105ccc:	e8 9f a6 ff ff       	call   80100370 <panic>
80105cd1:	eb 0d                	jmp    80105ce0 <sys_open>
80105cd3:	90                   	nop
80105cd4:	90                   	nop
80105cd5:	90                   	nop
80105cd6:	90                   	nop
80105cd7:	90                   	nop
80105cd8:	90                   	nop
80105cd9:	90                   	nop
80105cda:	90                   	nop
80105cdb:	90                   	nop
80105cdc:	90                   	nop
80105cdd:	90                   	nop
80105cde:	90                   	nop
80105cdf:	90                   	nop

80105ce0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	56                   	push   %esi
80105ce5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ce6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105ce9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105cec:	50                   	push   %eax
80105ced:	6a 00                	push   $0x0
80105cef:	e8 fc f7 ff ff       	call   801054f0 <argstr>
80105cf4:	83 c4 10             	add    $0x10,%esp
80105cf7:	85 c0                	test   %eax,%eax
80105cf9:	0f 88 9e 00 00 00    	js     80105d9d <sys_open+0xbd>
80105cff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d02:	83 ec 08             	sub    $0x8,%esp
80105d05:	50                   	push   %eax
80105d06:	6a 01                	push   $0x1
80105d08:	e8 33 f7 ff ff       	call   80105440 <argint>
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	85 c0                	test   %eax,%eax
80105d12:	0f 88 85 00 00 00    	js     80105d9d <sys_open+0xbd>
    return -1;

  begin_op();
80105d18:	e8 43 ce ff ff       	call   80102b60 <begin_op>

  if(omode & O_CREATE){
80105d1d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105d21:	0f 85 89 00 00 00    	jne    80105db0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105d27:	83 ec 0c             	sub    $0xc,%esp
80105d2a:	ff 75 e0             	pushl  -0x20(%ebp)
80105d2d:	e8 9e c1 ff ff       	call   80101ed0 <namei>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	89 c6                	mov    %eax,%esi
80105d39:	0f 84 8e 00 00 00    	je     80105dcd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
80105d3f:	83 ec 0c             	sub    $0xc,%esp
80105d42:	50                   	push   %eax
80105d43:	e8 38 b9 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d48:	83 c4 10             	add    $0x10,%esp
80105d4b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105d50:	0f 84 d2 00 00 00    	je     80105e28 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105d56:	e8 25 b0 ff ff       	call   80100d80 <filealloc>
80105d5b:	85 c0                	test   %eax,%eax
80105d5d:	89 c7                	mov    %eax,%edi
80105d5f:	74 2b                	je     80105d8c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105d61:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105d63:	e8 38 db ff ff       	call   801038a0 <myproc>
80105d68:	90                   	nop
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105d70:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105d74:	85 d2                	test   %edx,%edx
80105d76:	74 68                	je     80105de0 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105d78:	83 c3 01             	add    $0x1,%ebx
80105d7b:	83 fb 10             	cmp    $0x10,%ebx
80105d7e:	75 f0                	jne    80105d70 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	57                   	push   %edi
80105d84:	e8 b7 b0 ff ff       	call   80100e40 <fileclose>
80105d89:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105d8c:	83 ec 0c             	sub    $0xc,%esp
80105d8f:	56                   	push   %esi
80105d90:	e8 7b bb ff ff       	call   80101910 <iunlockput>
    end_op();
80105d95:	e8 36 ce ff ff       	call   80102bd0 <end_op>
    return -1;
80105d9a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105da5:	5b                   	pop    %ebx
80105da6:	5e                   	pop    %esi
80105da7:	5f                   	pop    %edi
80105da8:	5d                   	pop    %ebp
80105da9:	c3                   	ret    
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105db6:	31 c9                	xor    %ecx,%ecx
80105db8:	6a 00                	push   $0x0
80105dba:	ba 02 00 00 00       	mov    $0x2,%edx
80105dbf:	e8 dc f7 ff ff       	call   801055a0 <create>
    if(ip == 0){
80105dc4:	83 c4 10             	add    $0x10,%esp
80105dc7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105dc9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105dcb:	75 89                	jne    80105d56 <sys_open+0x76>
      end_op();
80105dcd:	e8 fe cd ff ff       	call   80102bd0 <end_op>
      return -1;
80105dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd7:	eb 43                	jmp    80105e1c <sys_open+0x13c>
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105de0:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105de3:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105de7:	56                   	push   %esi
80105de8:	e8 73 b9 ff ff       	call   80101760 <iunlock>
  end_op();
80105ded:	e8 de cd ff ff       	call   80102bd0 <end_op>

  f->type = FD_INODE;
80105df2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105dfb:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105dfe:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105e01:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e08:	89 d0                	mov    %edx,%eax
80105e0a:	83 e0 01             	and    $0x1,%eax
80105e0d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e10:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e13:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e16:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105e1a:	89 d8                	mov    %ebx,%eax
}
80105e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e1f:	5b                   	pop    %ebx
80105e20:	5e                   	pop    %esi
80105e21:	5f                   	pop    %edi
80105e22:	5d                   	pop    %ebp
80105e23:	c3                   	ret    
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e28:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105e2b:	85 c9                	test   %ecx,%ecx
80105e2d:	0f 84 23 ff ff ff    	je     80105d56 <sys_open+0x76>
80105e33:	e9 54 ff ff ff       	jmp    80105d8c <sys_open+0xac>
80105e38:	90                   	nop
80105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e40 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e46:	e8 15 cd ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105e4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e4e:	83 ec 08             	sub    $0x8,%esp
80105e51:	50                   	push   %eax
80105e52:	6a 00                	push   $0x0
80105e54:	e8 97 f6 ff ff       	call   801054f0 <argstr>
80105e59:	83 c4 10             	add    $0x10,%esp
80105e5c:	85 c0                	test   %eax,%eax
80105e5e:	78 30                	js     80105e90 <sys_mkdir+0x50>
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e66:	31 c9                	xor    %ecx,%ecx
80105e68:	6a 00                	push   $0x0
80105e6a:	ba 01 00 00 00       	mov    $0x1,%edx
80105e6f:	e8 2c f7 ff ff       	call   801055a0 <create>
80105e74:	83 c4 10             	add    $0x10,%esp
80105e77:	85 c0                	test   %eax,%eax
80105e79:	74 15                	je     80105e90 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e7b:	83 ec 0c             	sub    $0xc,%esp
80105e7e:	50                   	push   %eax
80105e7f:	e8 8c ba ff ff       	call   80101910 <iunlockput>
  end_op();
80105e84:	e8 47 cd ff ff       	call   80102bd0 <end_op>
  return 0;
80105e89:	83 c4 10             	add    $0x10,%esp
80105e8c:	31 c0                	xor    %eax,%eax
}
80105e8e:	c9                   	leave  
80105e8f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105e90:	e8 3b cd ff ff       	call   80102bd0 <end_op>
    return -1;
80105e95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105e9a:	c9                   	leave  
80105e9b:	c3                   	ret    
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ea0 <sys_mknod>:

int
sys_mknod(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ea6:	e8 b5 cc ff ff       	call   80102b60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105eab:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105eae:	83 ec 08             	sub    $0x8,%esp
80105eb1:	50                   	push   %eax
80105eb2:	6a 00                	push   $0x0
80105eb4:	e8 37 f6 ff ff       	call   801054f0 <argstr>
80105eb9:	83 c4 10             	add    $0x10,%esp
80105ebc:	85 c0                	test   %eax,%eax
80105ebe:	78 60                	js     80105f20 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ec0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ec3:	83 ec 08             	sub    $0x8,%esp
80105ec6:	50                   	push   %eax
80105ec7:	6a 01                	push   $0x1
80105ec9:	e8 72 f5 ff ff       	call   80105440 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105ece:	83 c4 10             	add    $0x10,%esp
80105ed1:	85 c0                	test   %eax,%eax
80105ed3:	78 4b                	js     80105f20 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed8:	83 ec 08             	sub    $0x8,%esp
80105edb:	50                   	push   %eax
80105edc:	6a 02                	push   $0x2
80105ede:	e8 5d f5 ff ff       	call   80105440 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105ee3:	83 c4 10             	add    $0x10,%esp
80105ee6:	85 c0                	test   %eax,%eax
80105ee8:	78 36                	js     80105f20 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105eea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105eee:	83 ec 0c             	sub    $0xc,%esp
80105ef1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ef5:	ba 03 00 00 00       	mov    $0x3,%edx
80105efa:	50                   	push   %eax
80105efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105efe:	e8 9d f6 ff ff       	call   801055a0 <create>
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	85 c0                	test   %eax,%eax
80105f08:	74 16                	je     80105f20 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f0a:	83 ec 0c             	sub    $0xc,%esp
80105f0d:	50                   	push   %eax
80105f0e:	e8 fd b9 ff ff       	call   80101910 <iunlockput>
  end_op();
80105f13:	e8 b8 cc ff ff       	call   80102bd0 <end_op>
  return 0;
80105f18:	83 c4 10             	add    $0x10,%esp
80105f1b:	31 c0                	xor    %eax,%eax
}
80105f1d:	c9                   	leave  
80105f1e:	c3                   	ret    
80105f1f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105f20:	e8 ab cc ff ff       	call   80102bd0 <end_op>
    return -1;
80105f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105f2a:	c9                   	leave  
80105f2b:	c3                   	ret    
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f30 <sys_chdir>:

int
sys_chdir(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	56                   	push   %esi
80105f34:	53                   	push   %ebx
80105f35:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105f38:	e8 63 d9 ff ff       	call   801038a0 <myproc>
80105f3d:	89 c6                	mov    %eax,%esi
  //struct thread *curthread = mythread();
  
  begin_op();
80105f3f:	e8 1c cc ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f47:	83 ec 08             	sub    $0x8,%esp
80105f4a:	50                   	push   %eax
80105f4b:	6a 00                	push   $0x0
80105f4d:	e8 9e f5 ff ff       	call   801054f0 <argstr>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	78 77                	js     80105fd0 <sys_chdir+0xa0>
80105f59:	83 ec 0c             	sub    $0xc,%esp
80105f5c:	ff 75 f4             	pushl  -0xc(%ebp)
80105f5f:	e8 6c bf ff ff       	call   80101ed0 <namei>
80105f64:	83 c4 10             	add    $0x10,%esp
80105f67:	85 c0                	test   %eax,%eax
80105f69:	89 c3                	mov    %eax,%ebx
80105f6b:	74 63                	je     80105fd0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105f6d:	83 ec 0c             	sub    $0xc,%esp
80105f70:	50                   	push   %eax
80105f71:	e8 0a b7 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f7e:	75 30                	jne    80105fb0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	53                   	push   %ebx
80105f84:	e8 d7 b7 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105f89:	58                   	pop    %eax
80105f8a:	ff 76 60             	pushl  0x60(%esi)
80105f8d:	e8 1e b8 ff ff       	call   801017b0 <iput>
  end_op();
80105f92:	e8 39 cc ff ff       	call   80102bd0 <end_op>
  curproc->cwd = ip;
80105f97:	89 5e 60             	mov    %ebx,0x60(%esi)
  return 0;
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	31 c0                	xor    %eax,%eax
}
80105f9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fa2:	5b                   	pop    %ebx
80105fa3:	5e                   	pop    %esi
80105fa4:	5d                   	pop    %ebp
80105fa5:	c3                   	ret    
80105fa6:	8d 76 00             	lea    0x0(%esi),%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
80105fb3:	53                   	push   %ebx
80105fb4:	e8 57 b9 ff ff       	call   80101910 <iunlockput>
    end_op();
80105fb9:	e8 12 cc ff ff       	call   80102bd0 <end_op>
    return -1;
80105fbe:	83 c4 10             	add    $0x10,%esp
80105fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc6:	eb d7                	jmp    80105f9f <sys_chdir+0x6f>
80105fc8:	90                   	nop
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
  //struct thread *curthread = mythread();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105fd0:	e8 fb cb ff ff       	call   80102bd0 <end_op>
    return -1;
80105fd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fda:	eb c3                	jmp    80105f9f <sys_chdir+0x6f>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	57                   	push   %edi
80105fe4:	56                   	push   %esi
80105fe5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105fe6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105fec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ff2:	50                   	push   %eax
80105ff3:	6a 00                	push   $0x0
80105ff5:	e8 f6 f4 ff ff       	call   801054f0 <argstr>
80105ffa:	83 c4 10             	add    $0x10,%esp
80105ffd:	85 c0                	test   %eax,%eax
80105fff:	78 7f                	js     80106080 <sys_exec+0xa0>
80106001:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106007:	83 ec 08             	sub    $0x8,%esp
8010600a:	50                   	push   %eax
8010600b:	6a 01                	push   $0x1
8010600d:	e8 2e f4 ff ff       	call   80105440 <argint>
80106012:	83 c4 10             	add    $0x10,%esp
80106015:	85 c0                	test   %eax,%eax
80106017:	78 67                	js     80106080 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106019:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010601f:	83 ec 04             	sub    $0x4,%esp
80106022:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80106028:	68 80 00 00 00       	push   $0x80
8010602d:	6a 00                	push   $0x0
8010602f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106035:	50                   	push   %eax
80106036:	31 db                	xor    %ebx,%ebx
80106038:	e8 f3 f0 ff ff       	call   80105130 <memset>
8010603d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106040:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106046:	83 ec 08             	sub    $0x8,%esp
80106049:	57                   	push   %edi
8010604a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010604d:	50                   	push   %eax
8010604e:	e8 4d f3 ff ff       	call   801053a0 <fetchint>
80106053:	83 c4 10             	add    $0x10,%esp
80106056:	85 c0                	test   %eax,%eax
80106058:	78 26                	js     80106080 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010605a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106060:	85 c0                	test   %eax,%eax
80106062:	74 2c                	je     80106090 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106064:	83 ec 08             	sub    $0x8,%esp
80106067:	56                   	push   %esi
80106068:	50                   	push   %eax
80106069:	e8 72 f3 ff ff       	call   801053e0 <fetchstr>
8010606e:	83 c4 10             	add    $0x10,%esp
80106071:	85 c0                	test   %eax,%eax
80106073:	78 0b                	js     80106080 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106075:	83 c3 01             	add    $0x1,%ebx
80106078:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010607b:	83 fb 20             	cmp    $0x20,%ebx
8010607e:	75 c0                	jne    80106040 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80106080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80106083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80106088:	5b                   	pop    %ebx
80106089:	5e                   	pop    %esi
8010608a:	5f                   	pop    %edi
8010608b:	5d                   	pop    %ebp
8010608c:	c3                   	ret    
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106090:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106096:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80106099:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801060a0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801060a4:	50                   	push   %eax
801060a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801060ab:	e8 40 a9 ff ff       	call   801009f0 <exec>
801060b0:	83 c4 10             	add    $0x10,%esp
}
801060b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b6:	5b                   	pop    %ebx
801060b7:	5e                   	pop    %esi
801060b8:	5f                   	pop    %edi
801060b9:	5d                   	pop    %ebp
801060ba:	c3                   	ret    
801060bb:	90                   	nop
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_pipe>:

int
sys_pipe(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	57                   	push   %edi
801060c4:	56                   	push   %esi
801060c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801060c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801060c9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801060cc:	6a 08                	push   $0x8
801060ce:	50                   	push   %eax
801060cf:	6a 00                	push   $0x0
801060d1:	e8 ba f3 ff ff       	call   80105490 <argptr>
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	85 c0                	test   %eax,%eax
801060db:	78 4a                	js     80106127 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801060dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060e0:	83 ec 08             	sub    $0x8,%esp
801060e3:	50                   	push   %eax
801060e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060e7:	50                   	push   %eax
801060e8:	e8 13 d1 ff ff       	call   80103200 <pipealloc>
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	85 c0                	test   %eax,%eax
801060f2:	78 33                	js     80106127 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801060f4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060f6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801060f9:	e8 a2 d7 ff ff       	call   801038a0 <myproc>
801060fe:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80106100:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
80106104:	85 f6                	test   %esi,%esi
80106106:	74 30                	je     80106138 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106108:	83 c3 01             	add    $0x1,%ebx
8010610b:	83 fb 10             	cmp    $0x10,%ebx
8010610e:	75 f0                	jne    80106100 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	ff 75 e0             	pushl  -0x20(%ebp)
80106116:	e8 25 ad ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
8010611b:	58                   	pop    %eax
8010611c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010611f:	e8 1c ad ff ff       	call   80100e40 <fileclose>
    return -1;
80106124:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80106127:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010612a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010612f:	5b                   	pop    %ebx
80106130:	5e                   	pop    %esi
80106131:	5f                   	pop    %edi
80106132:	5d                   	pop    %ebp
80106133:	c3                   	ret    
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80106138:	8d 73 08             	lea    0x8(%ebx),%esi
8010613b:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010613e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80106141:	e8 5a d7 ff ff       	call   801038a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80106146:	31 d2                	xor    %edx,%edx
80106148:	90                   	nop
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106150:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
80106154:	85 c9                	test   %ecx,%ecx
80106156:	74 18                	je     80106170 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106158:	83 c2 01             	add    $0x1,%edx
8010615b:	83 fa 10             	cmp    $0x10,%edx
8010615e:	75 f0                	jne    80106150 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80106160:	e8 3b d7 ff ff       	call   801038a0 <myproc>
80106165:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
8010616c:	eb a2                	jmp    80106110 <sys_pipe+0x50>
8010616e:	66 90                	xchg   %ax,%ax
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80106170:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80106174:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106177:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106179:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010617c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010617f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80106182:	31 c0                	xor    %eax,%eax
}
80106184:	5b                   	pop    %ebx
80106185:	5e                   	pop    %esi
80106186:	5f                   	pop    %edi
80106187:	5d                   	pop    %ebp
80106188:	c3                   	ret    
80106189:	66 90                	xchg   %ax,%ax
8010618b:	66 90                	xchg   %ax,%ax
8010618d:	66 90                	xchg   %ax,%ax
8010618f:	90                   	nop

80106190 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106193:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106194:	e9 67 d9 ff ff       	jmp    80103b00 <fork>
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061a0 <sys_exit>:
}

int
sys_exit(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801061a6:	e8 d5 de ff ff       	call   80104080 <exit>
  return 0;  // not reached
}
801061ab:	31 c0                	xor    %eax,%eax
801061ad:	c9                   	leave  
801061ae:	c3                   	ret    
801061af:	90                   	nop

801061b0 <sys_wait>:

int
sys_wait(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801061b3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801061b4:	e9 c7 e0 ff ff       	jmp    80104280 <wait>
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061c0 <sys_kill>:
}

int
sys_kill(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801061c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061c9:	50                   	push   %eax
801061ca:	6a 00                	push   $0x0
801061cc:	e8 6f f2 ff ff       	call   80105440 <argint>
801061d1:	83 c4 10             	add    $0x10,%esp
801061d4:	85 c0                	test   %eax,%eax
801061d6:	78 18                	js     801061f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801061d8:	83 ec 0c             	sub    $0xc,%esp
801061db:	ff 75 f4             	pushl  -0xc(%ebp)
801061de:	e8 9d e2 ff ff       	call   80104480 <kill>
801061e3:	83 c4 10             	add    $0x10,%esp
}
801061e6:	c9                   	leave  
801061e7:	c3                   	ret    
801061e8:	90                   	nop
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801061f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801061f5:	c9                   	leave  
801061f6:	c3                   	ret    
801061f7:	89 f6                	mov    %esi,%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106200 <sys_getpid>:

int
sys_getpid(void)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106206:	e8 95 d6 ff ff       	call   801038a0 <myproc>
8010620b:	8b 40 0c             	mov    0xc(%eax),%eax
}
8010620e:	c9                   	leave  
8010620f:	c3                   	ret    

80106210 <sys_sbrk>:

int
sys_sbrk(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106214:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80106217:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010621a:	50                   	push   %eax
8010621b:	6a 00                	push   $0x0
8010621d:	e8 1e f2 ff ff       	call   80105440 <argint>
80106222:	83 c4 10             	add    $0x10,%esp
80106225:	85 c0                	test   %eax,%eax
80106227:	78 27                	js     80106250 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106229:	e8 72 d6 ff ff       	call   801038a0 <myproc>
  if(growproc(n) < 0)
8010622e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80106231:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106233:	ff 75 f4             	pushl  -0xc(%ebp)
80106236:	e8 25 d8 ff ff       	call   80103a60 <growproc>
8010623b:	83 c4 10             	add    $0x10,%esp
8010623e:	85 c0                	test   %eax,%eax
80106240:	78 0e                	js     80106250 <sys_sbrk+0x40>
    return -1;
  return addr;
80106242:	89 d8                	mov    %ebx,%eax
}
80106244:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106247:	c9                   	leave  
80106248:	c3                   	ret    
80106249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80106250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106255:	eb ed                	jmp    80106244 <sys_sbrk+0x34>
80106257:	89 f6                	mov    %esi,%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106260 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106264:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80106267:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010626a:	50                   	push   %eax
8010626b:	6a 00                	push   $0x0
8010626d:	e8 ce f1 ff ff       	call   80105440 <argint>
80106272:	83 c4 10             	add    $0x10,%esp
80106275:	85 c0                	test   %eax,%eax
80106277:	0f 88 8a 00 00 00    	js     80106307 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010627d:	83 ec 0c             	sub    $0xc,%esp
80106280:	68 e0 3a 12 80       	push   $0x80123ae0
80106285:	e8 96 ed ff ff       	call   80105020 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010628a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010628d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80106290:	8b 1d 20 43 12 80    	mov    0x80124320,%ebx
  while(ticks - ticks0 < n){
80106296:	85 d2                	test   %edx,%edx
80106298:	75 27                	jne    801062c1 <sys_sleep+0x61>
8010629a:	eb 54                	jmp    801062f0 <sys_sleep+0x90>
8010629c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801062a0:	83 ec 08             	sub    $0x8,%esp
801062a3:	68 e0 3a 12 80       	push   $0x80123ae0
801062a8:	68 20 43 12 80       	push   $0x80124320
801062ad:	e8 3e dc ff ff       	call   80103ef0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801062b2:	a1 20 43 12 80       	mov    0x80124320,%eax
801062b7:	83 c4 10             	add    $0x10,%esp
801062ba:	29 d8                	sub    %ebx,%eax
801062bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801062bf:	73 2f                	jae    801062f0 <sys_sleep+0x90>
    if(myproc()->killed){
801062c1:	e8 da d5 ff ff       	call   801038a0 <myproc>
801062c6:	8b 40 1c             	mov    0x1c(%eax),%eax
801062c9:	85 c0                	test   %eax,%eax
801062cb:	74 d3                	je     801062a0 <sys_sleep+0x40>
      release(&tickslock);
801062cd:	83 ec 0c             	sub    $0xc,%esp
801062d0:	68 e0 3a 12 80       	push   $0x80123ae0
801062d5:	e8 f6 ed ff ff       	call   801050d0 <release>
      return -1;
801062da:	83 c4 10             	add    $0x10,%esp
801062dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801062e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062e5:	c9                   	leave  
801062e6:	c3                   	ret    
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801062f0:	83 ec 0c             	sub    $0xc,%esp
801062f3:	68 e0 3a 12 80       	push   $0x80123ae0
801062f8:	e8 d3 ed ff ff       	call   801050d0 <release>
  return 0;
801062fd:	83 c4 10             	add    $0x10,%esp
80106300:	31 c0                	xor    %eax,%eax
}
80106302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106305:	c9                   	leave  
80106306:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80106307:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010630c:	eb d4                	jmp    801062e2 <sys_sleep+0x82>
8010630e:	66 90                	xchg   %ax,%ax

80106310 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	53                   	push   %ebx
80106314:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106317:	68 e0 3a 12 80       	push   $0x80123ae0
8010631c:	e8 ff ec ff ff       	call   80105020 <acquire>
  xticks = ticks;
80106321:	8b 1d 20 43 12 80    	mov    0x80124320,%ebx
  release(&tickslock);
80106327:	c7 04 24 e0 3a 12 80 	movl   $0x80123ae0,(%esp)
8010632e:	e8 9d ed ff ff       	call   801050d0 <release>
  return xticks;
}
80106333:	89 d8                	mov    %ebx,%eax
80106335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106338:	c9                   	leave  
80106339:	c3                   	ret    
8010633a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106340 <sys_kthread_create>:

int
sys_kthread_create(void){
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	83 ec 0c             	sub    $0xc,%esp
    void (*start_func)()=0;
    void* stack=0;
    if(argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
80106346:	6a 01                	push   $0x1
80106348:	6a 00                	push   $0x0
8010634a:	6a 00                	push   $0x0
8010634c:	e8 3f f1 ff ff       	call   80105490 <argptr>
80106351:	83 c4 10             	add    $0x10,%esp
80106354:	85 c0                	test   %eax,%eax
80106356:	78 28                	js     80106380 <sys_kthread_create+0x40>
        return -1;
    if(argptr(0, stack, sizeof(*stack)) < 0)
80106358:	83 ec 04             	sub    $0x4,%esp
8010635b:	6a 01                	push   $0x1
8010635d:	6a 00                	push   $0x0
8010635f:	6a 00                	push   $0x0
80106361:	e8 2a f1 ff ff       	call   80105490 <argptr>
80106366:	83 c4 10             	add    $0x10,%esp
80106369:	85 c0                	test   %eax,%eax
8010636b:	78 13                	js     80106380 <sys_kthread_create+0x40>
        return -1;
    return kthread_create(start_func, stack);
8010636d:	83 ec 08             	sub    $0x8,%esp
80106370:	6a 00                	push   $0x0
80106372:	6a 00                	push   $0x0
80106374:	e8 b7 e2 ff ff       	call   80104630 <kthread_create>
80106379:	83 c4 10             	add    $0x10,%esp
}
8010637c:	c9                   	leave  
8010637d:	c3                   	ret    
8010637e:	66 90                	xchg   %ax,%ax
int
sys_kthread_create(void){
    void (*start_func)()=0;
    void* stack=0;
    if(argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
        return -1;
80106380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(argptr(0, stack, sizeof(*stack)) < 0)
        return -1;
    return kthread_create(start_func, stack);
}
80106385:	c9                   	leave  
80106386:	c3                   	ret    
80106387:	89 f6                	mov    %esi,%esi
80106389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106390 <sys_kthread_id>:

int
sys_kthread_id(void){
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	83 ec 08             	sub    $0x8,%esp
    return mythread()->tid;
80106396:	e8 35 d5 ff ff       	call   801038d0 <mythread>
8010639b:	8b 40 0c             	mov    0xc(%eax),%eax
}
8010639e:	c9                   	leave  
8010639f:	c3                   	ret    

801063a0 <sys_kthread_exit>:

int
sys_kthread_exit(void){
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	83 ec 08             	sub    $0x8,%esp
    kthread_exit();
801063a6:	e8 45 e4 ff ff       	call   801047f0 <kthread_exit>
    return 0;
}
801063ab:	31 c0                	xor    %eax,%eax
801063ad:	c9                   	leave  
801063ae:	c3                   	ret    
801063af:	90                   	nop

801063b0 <sys_kthread_join>:

int
sys_kthread_join(void){
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if(argint(0, &tid) < 0)
801063b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063b9:	50                   	push   %eax
801063ba:	6a 00                	push   $0x0
801063bc:	e8 7f f0 ff ff       	call   80105440 <argint>
801063c1:	83 c4 10             	add    $0x10,%esp
801063c4:	85 c0                	test   %eax,%eax
801063c6:	78 18                	js     801063e0 <sys_kthread_join+0x30>
        return -1;
    return kthread_join(tid);
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	ff 75 f4             	pushl  -0xc(%ebp)
801063ce:	e8 bd e4 ff ff       	call   80104890 <kthread_join>
801063d3:	83 c4 10             	add    $0x10,%esp
}
801063d6:	c9                   	leave  
801063d7:	c3                   	ret    
801063d8:	90                   	nop
801063d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_kthread_join(void){
    int tid;
    if(argint(0, &tid) < 0)
        return -1;
801063e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return kthread_join(tid);
}
801063e5:	c9                   	leave  
801063e6:	c3                   	ret    

801063e7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801063e7:	1e                   	push   %ds
  pushl %es
801063e8:	06                   	push   %es
  pushl %fs
801063e9:	0f a0                	push   %fs
  pushl %gs
801063eb:	0f a8                	push   %gs
  pushal
801063ed:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801063ee:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801063f2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801063f4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801063f6:	54                   	push   %esp
  call trap
801063f7:	e8 e4 00 00 00       	call   801064e0 <trap>
  addl $4, %esp
801063fc:	83 c4 04             	add    $0x4,%esp

801063ff <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801063ff:	61                   	popa   
  popl %gs
80106400:	0f a9                	pop    %gs
  popl %fs
80106402:	0f a1                	pop    %fs
  popl %es
80106404:	07                   	pop    %es
  popl %ds
80106405:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106406:	83 c4 08             	add    $0x8,%esp
  iret
80106409:	cf                   	iret   
8010640a:	66 90                	xchg   %ax,%ax
8010640c:	66 90                	xchg   %ax,%ax
8010640e:	66 90                	xchg   %ax,%ax

80106410 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106410:	31 c0                	xor    %eax,%eax
80106412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106418:	8b 14 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%edx
8010641f:	b9 08 00 00 00       	mov    $0x8,%ecx
80106424:	c6 04 c5 24 3b 12 80 	movb   $0x0,-0x7fedc4dc(,%eax,8)
8010642b:	00 
8010642c:	66 89 0c c5 22 3b 12 	mov    %cx,-0x7fedc4de(,%eax,8)
80106433:	80 
80106434:	c6 04 c5 25 3b 12 80 	movb   $0x8e,-0x7fedc4db(,%eax,8)
8010643b:	8e 
8010643c:	66 89 14 c5 20 3b 12 	mov    %dx,-0x7fedc4e0(,%eax,8)
80106443:	80 
80106444:	c1 ea 10             	shr    $0x10,%edx
80106447:	66 89 14 c5 26 3b 12 	mov    %dx,-0x7fedc4da(,%eax,8)
8010644e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010644f:	83 c0 01             	add    $0x1,%eax
80106452:	3d 00 01 00 00       	cmp    $0x100,%eax
80106457:	75 bf                	jne    80106418 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106459:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010645a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010645f:	89 e5                	mov    %esp,%ebp
80106461:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106464:	a1 10 b1 10 80       	mov    0x8010b110,%eax

  initlock(&tickslock, "time");
80106469:	68 09 85 10 80       	push   $0x80108509
8010646e:	68 e0 3a 12 80       	push   $0x80123ae0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106473:	66 89 15 22 3d 12 80 	mov    %dx,0x80123d22
8010647a:	c6 05 24 3d 12 80 00 	movb   $0x0,0x80123d24
80106481:	66 a3 20 3d 12 80    	mov    %ax,0x80123d20
80106487:	c1 e8 10             	shr    $0x10,%eax
8010648a:	c6 05 25 3d 12 80 ef 	movb   $0xef,0x80123d25
80106491:	66 a3 26 3d 12 80    	mov    %ax,0x80123d26

  initlock(&tickslock, "time");
80106497:	e8 24 ea ff ff       	call   80104ec0 <initlock>
}
8010649c:	83 c4 10             	add    $0x10,%esp
8010649f:	c9                   	leave  
801064a0:	c3                   	ret    
801064a1:	eb 0d                	jmp    801064b0 <idtinit>
801064a3:	90                   	nop
801064a4:	90                   	nop
801064a5:	90                   	nop
801064a6:	90                   	nop
801064a7:	90                   	nop
801064a8:	90                   	nop
801064a9:	90                   	nop
801064aa:	90                   	nop
801064ab:	90                   	nop
801064ac:	90                   	nop
801064ad:	90                   	nop
801064ae:	90                   	nop
801064af:	90                   	nop

801064b0 <idtinit>:

void
idtinit(void)
{
801064b0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801064b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801064b6:	89 e5                	mov    %esp,%ebp
801064b8:	83 ec 10             	sub    $0x10,%esp
801064bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801064bf:	b8 20 3b 12 80       	mov    $0x80123b20,%eax
801064c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801064c8:	c1 e8 10             	shr    $0x10,%eax
801064cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801064cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801064d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801064d5:	c9                   	leave  
801064d6:	c3                   	ret    
801064d7:	89 f6                	mov    %esi,%esi
801064d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	57                   	push   %edi
801064e4:	56                   	push   %esi
801064e5:	53                   	push   %ebx
801064e6:	83 ec 1c             	sub    $0x1c,%esp
801064e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801064ec:	8b 47 30             	mov    0x30(%edi),%eax
801064ef:	83 f8 40             	cmp    $0x40,%eax
801064f2:	0f 84 88 01 00 00    	je     80106680 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801064f8:	83 e8 20             	sub    $0x20,%eax
801064fb:	83 f8 1f             	cmp    $0x1f,%eax
801064fe:	77 10                	ja     80106510 <trap+0x30>
80106500:	ff 24 85 b0 85 10 80 	jmp    *-0x7fef7a50(,%eax,4)
80106507:	89 f6                	mov    %esi,%esi
80106509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106510:	e8 8b d3 ff ff       	call   801038a0 <myproc>
80106515:	85 c0                	test   %eax,%eax
80106517:	0f 84 d7 01 00 00    	je     801066f4 <trap+0x214>
8010651d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106521:	0f 84 cd 01 00 00    	je     801066f4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106527:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010652a:	8b 57 38             	mov    0x38(%edi),%edx
8010652d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106530:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106533:	e8 48 d3 ff ff       	call   80103880 <cpuid>
80106538:	8b 77 34             	mov    0x34(%edi),%esi
8010653b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010653e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106541:	e8 5a d3 ff ff       	call   801038a0 <myproc>
80106546:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106549:	e8 52 d3 ff ff       	call   801038a0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010654e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106551:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106554:	51                   	push   %ecx
80106555:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106556:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106559:	ff 75 e4             	pushl  -0x1c(%ebp)
8010655c:	56                   	push   %esi
8010655d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010655e:	83 c2 64             	add    $0x64,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106561:	52                   	push   %edx
80106562:	ff 70 0c             	pushl  0xc(%eax)
80106565:	68 6c 85 10 80       	push   $0x8010856c
8010656a:	e8 f1 a0 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010656f:	83 c4 20             	add    $0x20,%esp
80106572:	e8 29 d3 ff ff       	call   801038a0 <myproc>
80106577:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
8010657e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106580:	e8 1b d3 ff ff       	call   801038a0 <myproc>
80106585:	85 c0                	test   %eax,%eax
80106587:	74 0c                	je     80106595 <trap+0xb5>
80106589:	e8 12 d3 ff ff       	call   801038a0 <myproc>
8010658e:	8b 50 1c             	mov    0x1c(%eax),%edx
80106591:	85 d2                	test   %edx,%edx
80106593:	75 4b                	jne    801065e0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106595:	e8 06 d3 ff ff       	call   801038a0 <myproc>
8010659a:	85 c0                	test   %eax,%eax
8010659c:	74 0b                	je     801065a9 <trap+0xc9>
8010659e:	e8 fd d2 ff ff       	call   801038a0 <myproc>
801065a3:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
801065a7:	74 4f                	je     801065f8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065a9:	e8 f2 d2 ff ff       	call   801038a0 <myproc>
801065ae:	85 c0                	test   %eax,%eax
801065b0:	74 1d                	je     801065cf <trap+0xef>
801065b2:	e8 e9 d2 ff ff       	call   801038a0 <myproc>
801065b7:	8b 40 1c             	mov    0x1c(%eax),%eax
801065ba:	85 c0                	test   %eax,%eax
801065bc:	74 11                	je     801065cf <trap+0xef>
801065be:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801065c2:	83 e0 03             	and    $0x3,%eax
801065c5:	66 83 f8 03          	cmp    $0x3,%ax
801065c9:	0f 84 da 00 00 00    	je     801066a9 <trap+0x1c9>
    exit();
}
801065cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d2:	5b                   	pop    %ebx
801065d3:	5e                   	pop    %esi
801065d4:	5f                   	pop    %edi
801065d5:	5d                   	pop    %ebp
801065d6:	c3                   	ret    
801065d7:	89 f6                	mov    %esi,%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065e0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801065e4:	83 e0 03             	and    $0x3,%eax
801065e7:	66 83 f8 03          	cmp    $0x3,%ax
801065eb:	75 a8                	jne    80106595 <trap+0xb5>
    exit();
801065ed:	e8 8e da ff ff       	call   80104080 <exit>
801065f2:	eb a1                	jmp    80106595 <trap+0xb5>
801065f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801065f8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801065fc:	75 ab                	jne    801065a9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801065fe:	e8 9d d8 ff ff       	call   80103ea0 <yield>
80106603:	eb a4                	jmp    801065a9 <trap+0xc9>
80106605:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106608:	e8 73 d2 ff ff       	call   80103880 <cpuid>
8010660d:	85 c0                	test   %eax,%eax
8010660f:	0f 84 ab 00 00 00    	je     801066c0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106615:	e8 06 c1 ff ff       	call   80102720 <lapiceoi>
    break;
8010661a:	e9 61 ff ff ff       	jmp    80106580 <trap+0xa0>
8010661f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106620:	e8 bb bf ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
80106625:	e8 f6 c0 ff ff       	call   80102720 <lapiceoi>
    break;
8010662a:	e9 51 ff ff ff       	jmp    80106580 <trap+0xa0>
8010662f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106630:	e8 5b 02 00 00       	call   80106890 <uartintr>
    lapiceoi();
80106635:	e8 e6 c0 ff ff       	call   80102720 <lapiceoi>
    break;
8010663a:	e9 41 ff ff ff       	jmp    80106580 <trap+0xa0>
8010663f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106640:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106644:	8b 77 38             	mov    0x38(%edi),%esi
80106647:	e8 34 d2 ff ff       	call   80103880 <cpuid>
8010664c:	56                   	push   %esi
8010664d:	53                   	push   %ebx
8010664e:	50                   	push   %eax
8010664f:	68 14 85 10 80       	push   $0x80108514
80106654:	e8 07 a0 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106659:	e8 c2 c0 ff ff       	call   80102720 <lapiceoi>
    break;
8010665e:	83 c4 10             	add    $0x10,%esp
80106661:	e9 1a ff ff ff       	jmp    80106580 <trap+0xa0>
80106666:	8d 76 00             	lea    0x0(%esi),%esi
80106669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106670:	e8 eb b9 ff ff       	call   80102060 <ideintr>
80106675:	eb 9e                	jmp    80106615 <trap+0x135>
80106677:	89 f6                	mov    %esi,%esi
80106679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106680:	e8 1b d2 ff ff       	call   801038a0 <myproc>
80106685:	8b 58 1c             	mov    0x1c(%eax),%ebx
80106688:	85 db                	test   %ebx,%ebx
8010668a:	75 2c                	jne    801066b8 <trap+0x1d8>
      exit();
    mythread()->tf = tf;
8010668c:	e8 3f d2 ff ff       	call   801038d0 <mythread>
80106691:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
80106694:	e8 97 ee ff ff       	call   80105530 <syscall>
    if(myproc()->killed)
80106699:	e8 02 d2 ff ff       	call   801038a0 <myproc>
8010669e:	8b 48 1c             	mov    0x1c(%eax),%ecx
801066a1:	85 c9                	test   %ecx,%ecx
801066a3:	0f 84 26 ff ff ff    	je     801065cf <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801066a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066ac:	5b                   	pop    %ebx
801066ad:	5e                   	pop    %esi
801066ae:	5f                   	pop    %edi
801066af:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    mythread()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801066b0:	e9 cb d9 ff ff       	jmp    80104080 <exit>
801066b5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801066b8:	e8 c3 d9 ff ff       	call   80104080 <exit>
801066bd:	eb cd                	jmp    8010668c <trap+0x1ac>
801066bf:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801066c0:	83 ec 0c             	sub    $0xc,%esp
801066c3:	68 e0 3a 12 80       	push   $0x80123ae0
801066c8:	e8 53 e9 ff ff       	call   80105020 <acquire>
      ticks++;
      wakeup(&ticks);
801066cd:	c7 04 24 20 43 12 80 	movl   $0x80124320,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801066d4:	83 05 20 43 12 80 01 	addl   $0x1,0x80124320
      wakeup(&ticks);
801066db:	e8 10 dd ff ff       	call   801043f0 <wakeup>
      release(&tickslock);
801066e0:	c7 04 24 e0 3a 12 80 	movl   $0x80123ae0,(%esp)
801066e7:	e8 e4 e9 ff ff       	call   801050d0 <release>
801066ec:	83 c4 10             	add    $0x10,%esp
801066ef:	e9 21 ff ff ff       	jmp    80106615 <trap+0x135>
801066f4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801066f7:	8b 5f 38             	mov    0x38(%edi),%ebx
801066fa:	e8 81 d1 ff ff       	call   80103880 <cpuid>
801066ff:	83 ec 0c             	sub    $0xc,%esp
80106702:	56                   	push   %esi
80106703:	53                   	push   %ebx
80106704:	50                   	push   %eax
80106705:	ff 77 30             	pushl  0x30(%edi)
80106708:	68 38 85 10 80       	push   $0x80108538
8010670d:	e8 4e 9f ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106712:	83 c4 14             	add    $0x14,%esp
80106715:	68 0e 85 10 80       	push   $0x8010850e
8010671a:	e8 51 9c ff ff       	call   80100370 <panic>
8010671f:	90                   	nop

80106720 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106720:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106725:	55                   	push   %ebp
80106726:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106728:	85 c0                	test   %eax,%eax
8010672a:	74 1c                	je     80106748 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010672c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106731:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106732:	a8 01                	test   $0x1,%al
80106734:	74 12                	je     80106748 <uartgetc+0x28>
80106736:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010673b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010673c:	0f b6 c0             	movzbl %al,%eax
}
8010673f:	5d                   	pop    %ebp
80106740:	c3                   	ret    
80106741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010674d:	5d                   	pop    %ebp
8010674e:	c3                   	ret    
8010674f:	90                   	nop

80106750 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	89 c7                	mov    %eax,%edi
80106758:	bb 80 00 00 00       	mov    $0x80,%ebx
8010675d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106762:	83 ec 0c             	sub    $0xc,%esp
80106765:	eb 1b                	jmp    80106782 <uartputc.part.0+0x32>
80106767:	89 f6                	mov    %esi,%esi
80106769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106770:	83 ec 0c             	sub    $0xc,%esp
80106773:	6a 0a                	push   $0xa
80106775:	e8 c6 bf ff ff       	call   80102740 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010677a:	83 c4 10             	add    $0x10,%esp
8010677d:	83 eb 01             	sub    $0x1,%ebx
80106780:	74 07                	je     80106789 <uartputc.part.0+0x39>
80106782:	89 f2                	mov    %esi,%edx
80106784:	ec                   	in     (%dx),%al
80106785:	a8 20                	test   $0x20,%al
80106787:	74 e7                	je     80106770 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106789:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010678e:	89 f8                	mov    %edi,%eax
80106790:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106794:	5b                   	pop    %ebx
80106795:	5e                   	pop    %esi
80106796:	5f                   	pop    %edi
80106797:	5d                   	pop    %ebp
80106798:	c3                   	ret    
80106799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067a0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801067a0:	55                   	push   %ebp
801067a1:	31 c9                	xor    %ecx,%ecx
801067a3:	89 c8                	mov    %ecx,%eax
801067a5:	89 e5                	mov    %esp,%ebp
801067a7:	57                   	push   %edi
801067a8:	56                   	push   %esi
801067a9:	53                   	push   %ebx
801067aa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801067af:	89 da                	mov    %ebx,%edx
801067b1:	83 ec 0c             	sub    $0xc,%esp
801067b4:	ee                   	out    %al,(%dx)
801067b5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801067ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801067bf:	89 fa                	mov    %edi,%edx
801067c1:	ee                   	out    %al,(%dx)
801067c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801067c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067cc:	ee                   	out    %al,(%dx)
801067cd:	be f9 03 00 00       	mov    $0x3f9,%esi
801067d2:	89 c8                	mov    %ecx,%eax
801067d4:	89 f2                	mov    %esi,%edx
801067d6:	ee                   	out    %al,(%dx)
801067d7:	b8 03 00 00 00       	mov    $0x3,%eax
801067dc:	89 fa                	mov    %edi,%edx
801067de:	ee                   	out    %al,(%dx)
801067df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801067e4:	89 c8                	mov    %ecx,%eax
801067e6:	ee                   	out    %al,(%dx)
801067e7:	b8 01 00 00 00       	mov    $0x1,%eax
801067ec:	89 f2                	mov    %esi,%edx
801067ee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067f4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801067f5:	3c ff                	cmp    $0xff,%al
801067f7:	74 5a                	je     80106853 <uartinit+0xb3>
    return;
  uart = 1;
801067f9:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106800:	00 00 00 
80106803:	89 da                	mov    %ebx,%edx
80106805:	ec                   	in     (%dx),%al
80106806:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010680b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010680c:	83 ec 08             	sub    $0x8,%esp
8010680f:	bb 30 86 10 80       	mov    $0x80108630,%ebx
80106814:	6a 00                	push   $0x0
80106816:	6a 04                	push   $0x4
80106818:	e8 93 ba ff ff       	call   801022b0 <ioapicenable>
8010681d:	83 c4 10             	add    $0x10,%esp
80106820:	b8 78 00 00 00       	mov    $0x78,%eax
80106825:	eb 13                	jmp    8010683a <uartinit+0x9a>
80106827:	89 f6                	mov    %esi,%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106830:	83 c3 01             	add    $0x1,%ebx
80106833:	0f be 03             	movsbl (%ebx),%eax
80106836:	84 c0                	test   %al,%al
80106838:	74 19                	je     80106853 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010683a:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80106840:	85 d2                	test   %edx,%edx
80106842:	74 ec                	je     80106830 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106844:	83 c3 01             	add    $0x1,%ebx
80106847:	e8 04 ff ff ff       	call   80106750 <uartputc.part.0>
8010684c:	0f be 03             	movsbl (%ebx),%eax
8010684f:	84 c0                	test   %al,%al
80106851:	75 e7                	jne    8010683a <uartinit+0x9a>
    uartputc(*p);
}
80106853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106856:	5b                   	pop    %ebx
80106857:	5e                   	pop    %esi
80106858:	5f                   	pop    %edi
80106859:	5d                   	pop    %ebp
8010685a:	c3                   	ret    
8010685b:	90                   	nop
8010685c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106860 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106860:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106866:	55                   	push   %ebp
80106867:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106869:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010686b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010686e:	74 10                	je     80106880 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106870:	5d                   	pop    %ebp
80106871:	e9 da fe ff ff       	jmp    80106750 <uartputc.part.0>
80106876:	8d 76 00             	lea    0x0(%esi),%esi
80106879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106880:	5d                   	pop    %ebp
80106881:	c3                   	ret    
80106882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106890 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106896:	68 20 67 10 80       	push   $0x80106720
8010689b:	e8 50 9f ff ff       	call   801007f0 <consoleintr>
}
801068a0:	83 c4 10             	add    $0x10,%esp
801068a3:	c9                   	leave  
801068a4:	c3                   	ret    

801068a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $0
801068a7:	6a 00                	push   $0x0
  jmp alltraps
801068a9:	e9 39 fb ff ff       	jmp    801063e7 <alltraps>

801068ae <vector1>:
.globl vector1
vector1:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $1
801068b0:	6a 01                	push   $0x1
  jmp alltraps
801068b2:	e9 30 fb ff ff       	jmp    801063e7 <alltraps>

801068b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $2
801068b9:	6a 02                	push   $0x2
  jmp alltraps
801068bb:	e9 27 fb ff ff       	jmp    801063e7 <alltraps>

801068c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $3
801068c2:	6a 03                	push   $0x3
  jmp alltraps
801068c4:	e9 1e fb ff ff       	jmp    801063e7 <alltraps>

801068c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $4
801068cb:	6a 04                	push   $0x4
  jmp alltraps
801068cd:	e9 15 fb ff ff       	jmp    801063e7 <alltraps>

801068d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $5
801068d4:	6a 05                	push   $0x5
  jmp alltraps
801068d6:	e9 0c fb ff ff       	jmp    801063e7 <alltraps>

801068db <vector6>:
.globl vector6
vector6:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $6
801068dd:	6a 06                	push   $0x6
  jmp alltraps
801068df:	e9 03 fb ff ff       	jmp    801063e7 <alltraps>

801068e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $7
801068e6:	6a 07                	push   $0x7
  jmp alltraps
801068e8:	e9 fa fa ff ff       	jmp    801063e7 <alltraps>

801068ed <vector8>:
.globl vector8
vector8:
  pushl $8
801068ed:	6a 08                	push   $0x8
  jmp alltraps
801068ef:	e9 f3 fa ff ff       	jmp    801063e7 <alltraps>

801068f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801068f4:	6a 00                	push   $0x0
  pushl $9
801068f6:	6a 09                	push   $0x9
  jmp alltraps
801068f8:	e9 ea fa ff ff       	jmp    801063e7 <alltraps>

801068fd <vector10>:
.globl vector10
vector10:
  pushl $10
801068fd:	6a 0a                	push   $0xa
  jmp alltraps
801068ff:	e9 e3 fa ff ff       	jmp    801063e7 <alltraps>

80106904 <vector11>:
.globl vector11
vector11:
  pushl $11
80106904:	6a 0b                	push   $0xb
  jmp alltraps
80106906:	e9 dc fa ff ff       	jmp    801063e7 <alltraps>

8010690b <vector12>:
.globl vector12
vector12:
  pushl $12
8010690b:	6a 0c                	push   $0xc
  jmp alltraps
8010690d:	e9 d5 fa ff ff       	jmp    801063e7 <alltraps>

80106912 <vector13>:
.globl vector13
vector13:
  pushl $13
80106912:	6a 0d                	push   $0xd
  jmp alltraps
80106914:	e9 ce fa ff ff       	jmp    801063e7 <alltraps>

80106919 <vector14>:
.globl vector14
vector14:
  pushl $14
80106919:	6a 0e                	push   $0xe
  jmp alltraps
8010691b:	e9 c7 fa ff ff       	jmp    801063e7 <alltraps>

80106920 <vector15>:
.globl vector15
vector15:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $15
80106922:	6a 0f                	push   $0xf
  jmp alltraps
80106924:	e9 be fa ff ff       	jmp    801063e7 <alltraps>

80106929 <vector16>:
.globl vector16
vector16:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $16
8010692b:	6a 10                	push   $0x10
  jmp alltraps
8010692d:	e9 b5 fa ff ff       	jmp    801063e7 <alltraps>

80106932 <vector17>:
.globl vector17
vector17:
  pushl $17
80106932:	6a 11                	push   $0x11
  jmp alltraps
80106934:	e9 ae fa ff ff       	jmp    801063e7 <alltraps>

80106939 <vector18>:
.globl vector18
vector18:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $18
8010693b:	6a 12                	push   $0x12
  jmp alltraps
8010693d:	e9 a5 fa ff ff       	jmp    801063e7 <alltraps>

80106942 <vector19>:
.globl vector19
vector19:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $19
80106944:	6a 13                	push   $0x13
  jmp alltraps
80106946:	e9 9c fa ff ff       	jmp    801063e7 <alltraps>

8010694b <vector20>:
.globl vector20
vector20:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $20
8010694d:	6a 14                	push   $0x14
  jmp alltraps
8010694f:	e9 93 fa ff ff       	jmp    801063e7 <alltraps>

80106954 <vector21>:
.globl vector21
vector21:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $21
80106956:	6a 15                	push   $0x15
  jmp alltraps
80106958:	e9 8a fa ff ff       	jmp    801063e7 <alltraps>

8010695d <vector22>:
.globl vector22
vector22:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $22
8010695f:	6a 16                	push   $0x16
  jmp alltraps
80106961:	e9 81 fa ff ff       	jmp    801063e7 <alltraps>

80106966 <vector23>:
.globl vector23
vector23:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $23
80106968:	6a 17                	push   $0x17
  jmp alltraps
8010696a:	e9 78 fa ff ff       	jmp    801063e7 <alltraps>

8010696f <vector24>:
.globl vector24
vector24:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $24
80106971:	6a 18                	push   $0x18
  jmp alltraps
80106973:	e9 6f fa ff ff       	jmp    801063e7 <alltraps>

80106978 <vector25>:
.globl vector25
vector25:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $25
8010697a:	6a 19                	push   $0x19
  jmp alltraps
8010697c:	e9 66 fa ff ff       	jmp    801063e7 <alltraps>

80106981 <vector26>:
.globl vector26
vector26:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $26
80106983:	6a 1a                	push   $0x1a
  jmp alltraps
80106985:	e9 5d fa ff ff       	jmp    801063e7 <alltraps>

8010698a <vector27>:
.globl vector27
vector27:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $27
8010698c:	6a 1b                	push   $0x1b
  jmp alltraps
8010698e:	e9 54 fa ff ff       	jmp    801063e7 <alltraps>

80106993 <vector28>:
.globl vector28
vector28:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $28
80106995:	6a 1c                	push   $0x1c
  jmp alltraps
80106997:	e9 4b fa ff ff       	jmp    801063e7 <alltraps>

8010699c <vector29>:
.globl vector29
vector29:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $29
8010699e:	6a 1d                	push   $0x1d
  jmp alltraps
801069a0:	e9 42 fa ff ff       	jmp    801063e7 <alltraps>

801069a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $30
801069a7:	6a 1e                	push   $0x1e
  jmp alltraps
801069a9:	e9 39 fa ff ff       	jmp    801063e7 <alltraps>

801069ae <vector31>:
.globl vector31
vector31:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $31
801069b0:	6a 1f                	push   $0x1f
  jmp alltraps
801069b2:	e9 30 fa ff ff       	jmp    801063e7 <alltraps>

801069b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $32
801069b9:	6a 20                	push   $0x20
  jmp alltraps
801069bb:	e9 27 fa ff ff       	jmp    801063e7 <alltraps>

801069c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $33
801069c2:	6a 21                	push   $0x21
  jmp alltraps
801069c4:	e9 1e fa ff ff       	jmp    801063e7 <alltraps>

801069c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $34
801069cb:	6a 22                	push   $0x22
  jmp alltraps
801069cd:	e9 15 fa ff ff       	jmp    801063e7 <alltraps>

801069d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $35
801069d4:	6a 23                	push   $0x23
  jmp alltraps
801069d6:	e9 0c fa ff ff       	jmp    801063e7 <alltraps>

801069db <vector36>:
.globl vector36
vector36:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $36
801069dd:	6a 24                	push   $0x24
  jmp alltraps
801069df:	e9 03 fa ff ff       	jmp    801063e7 <alltraps>

801069e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $37
801069e6:	6a 25                	push   $0x25
  jmp alltraps
801069e8:	e9 fa f9 ff ff       	jmp    801063e7 <alltraps>

801069ed <vector38>:
.globl vector38
vector38:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $38
801069ef:	6a 26                	push   $0x26
  jmp alltraps
801069f1:	e9 f1 f9 ff ff       	jmp    801063e7 <alltraps>

801069f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $39
801069f8:	6a 27                	push   $0x27
  jmp alltraps
801069fa:	e9 e8 f9 ff ff       	jmp    801063e7 <alltraps>

801069ff <vector40>:
.globl vector40
vector40:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $40
80106a01:	6a 28                	push   $0x28
  jmp alltraps
80106a03:	e9 df f9 ff ff       	jmp    801063e7 <alltraps>

80106a08 <vector41>:
.globl vector41
vector41:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $41
80106a0a:	6a 29                	push   $0x29
  jmp alltraps
80106a0c:	e9 d6 f9 ff ff       	jmp    801063e7 <alltraps>

80106a11 <vector42>:
.globl vector42
vector42:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $42
80106a13:	6a 2a                	push   $0x2a
  jmp alltraps
80106a15:	e9 cd f9 ff ff       	jmp    801063e7 <alltraps>

80106a1a <vector43>:
.globl vector43
vector43:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $43
80106a1c:	6a 2b                	push   $0x2b
  jmp alltraps
80106a1e:	e9 c4 f9 ff ff       	jmp    801063e7 <alltraps>

80106a23 <vector44>:
.globl vector44
vector44:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $44
80106a25:	6a 2c                	push   $0x2c
  jmp alltraps
80106a27:	e9 bb f9 ff ff       	jmp    801063e7 <alltraps>

80106a2c <vector45>:
.globl vector45
vector45:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $45
80106a2e:	6a 2d                	push   $0x2d
  jmp alltraps
80106a30:	e9 b2 f9 ff ff       	jmp    801063e7 <alltraps>

80106a35 <vector46>:
.globl vector46
vector46:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $46
80106a37:	6a 2e                	push   $0x2e
  jmp alltraps
80106a39:	e9 a9 f9 ff ff       	jmp    801063e7 <alltraps>

80106a3e <vector47>:
.globl vector47
vector47:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $47
80106a40:	6a 2f                	push   $0x2f
  jmp alltraps
80106a42:	e9 a0 f9 ff ff       	jmp    801063e7 <alltraps>

80106a47 <vector48>:
.globl vector48
vector48:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $48
80106a49:	6a 30                	push   $0x30
  jmp alltraps
80106a4b:	e9 97 f9 ff ff       	jmp    801063e7 <alltraps>

80106a50 <vector49>:
.globl vector49
vector49:
  pushl $0
80106a50:	6a 00                	push   $0x0
  pushl $49
80106a52:	6a 31                	push   $0x31
  jmp alltraps
80106a54:	e9 8e f9 ff ff       	jmp    801063e7 <alltraps>

80106a59 <vector50>:
.globl vector50
vector50:
  pushl $0
80106a59:	6a 00                	push   $0x0
  pushl $50
80106a5b:	6a 32                	push   $0x32
  jmp alltraps
80106a5d:	e9 85 f9 ff ff       	jmp    801063e7 <alltraps>

80106a62 <vector51>:
.globl vector51
vector51:
  pushl $0
80106a62:	6a 00                	push   $0x0
  pushl $51
80106a64:	6a 33                	push   $0x33
  jmp alltraps
80106a66:	e9 7c f9 ff ff       	jmp    801063e7 <alltraps>

80106a6b <vector52>:
.globl vector52
vector52:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $52
80106a6d:	6a 34                	push   $0x34
  jmp alltraps
80106a6f:	e9 73 f9 ff ff       	jmp    801063e7 <alltraps>

80106a74 <vector53>:
.globl vector53
vector53:
  pushl $0
80106a74:	6a 00                	push   $0x0
  pushl $53
80106a76:	6a 35                	push   $0x35
  jmp alltraps
80106a78:	e9 6a f9 ff ff       	jmp    801063e7 <alltraps>

80106a7d <vector54>:
.globl vector54
vector54:
  pushl $0
80106a7d:	6a 00                	push   $0x0
  pushl $54
80106a7f:	6a 36                	push   $0x36
  jmp alltraps
80106a81:	e9 61 f9 ff ff       	jmp    801063e7 <alltraps>

80106a86 <vector55>:
.globl vector55
vector55:
  pushl $0
80106a86:	6a 00                	push   $0x0
  pushl $55
80106a88:	6a 37                	push   $0x37
  jmp alltraps
80106a8a:	e9 58 f9 ff ff       	jmp    801063e7 <alltraps>

80106a8f <vector56>:
.globl vector56
vector56:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $56
80106a91:	6a 38                	push   $0x38
  jmp alltraps
80106a93:	e9 4f f9 ff ff       	jmp    801063e7 <alltraps>

80106a98 <vector57>:
.globl vector57
vector57:
  pushl $0
80106a98:	6a 00                	push   $0x0
  pushl $57
80106a9a:	6a 39                	push   $0x39
  jmp alltraps
80106a9c:	e9 46 f9 ff ff       	jmp    801063e7 <alltraps>

80106aa1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106aa1:	6a 00                	push   $0x0
  pushl $58
80106aa3:	6a 3a                	push   $0x3a
  jmp alltraps
80106aa5:	e9 3d f9 ff ff       	jmp    801063e7 <alltraps>

80106aaa <vector59>:
.globl vector59
vector59:
  pushl $0
80106aaa:	6a 00                	push   $0x0
  pushl $59
80106aac:	6a 3b                	push   $0x3b
  jmp alltraps
80106aae:	e9 34 f9 ff ff       	jmp    801063e7 <alltraps>

80106ab3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $60
80106ab5:	6a 3c                	push   $0x3c
  jmp alltraps
80106ab7:	e9 2b f9 ff ff       	jmp    801063e7 <alltraps>

80106abc <vector61>:
.globl vector61
vector61:
  pushl $0
80106abc:	6a 00                	push   $0x0
  pushl $61
80106abe:	6a 3d                	push   $0x3d
  jmp alltraps
80106ac0:	e9 22 f9 ff ff       	jmp    801063e7 <alltraps>

80106ac5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ac5:	6a 00                	push   $0x0
  pushl $62
80106ac7:	6a 3e                	push   $0x3e
  jmp alltraps
80106ac9:	e9 19 f9 ff ff       	jmp    801063e7 <alltraps>

80106ace <vector63>:
.globl vector63
vector63:
  pushl $0
80106ace:	6a 00                	push   $0x0
  pushl $63
80106ad0:	6a 3f                	push   $0x3f
  jmp alltraps
80106ad2:	e9 10 f9 ff ff       	jmp    801063e7 <alltraps>

80106ad7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $64
80106ad9:	6a 40                	push   $0x40
  jmp alltraps
80106adb:	e9 07 f9 ff ff       	jmp    801063e7 <alltraps>

80106ae0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ae0:	6a 00                	push   $0x0
  pushl $65
80106ae2:	6a 41                	push   $0x41
  jmp alltraps
80106ae4:	e9 fe f8 ff ff       	jmp    801063e7 <alltraps>

80106ae9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ae9:	6a 00                	push   $0x0
  pushl $66
80106aeb:	6a 42                	push   $0x42
  jmp alltraps
80106aed:	e9 f5 f8 ff ff       	jmp    801063e7 <alltraps>

80106af2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106af2:	6a 00                	push   $0x0
  pushl $67
80106af4:	6a 43                	push   $0x43
  jmp alltraps
80106af6:	e9 ec f8 ff ff       	jmp    801063e7 <alltraps>

80106afb <vector68>:
.globl vector68
vector68:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $68
80106afd:	6a 44                	push   $0x44
  jmp alltraps
80106aff:	e9 e3 f8 ff ff       	jmp    801063e7 <alltraps>

80106b04 <vector69>:
.globl vector69
vector69:
  pushl $0
80106b04:	6a 00                	push   $0x0
  pushl $69
80106b06:	6a 45                	push   $0x45
  jmp alltraps
80106b08:	e9 da f8 ff ff       	jmp    801063e7 <alltraps>

80106b0d <vector70>:
.globl vector70
vector70:
  pushl $0
80106b0d:	6a 00                	push   $0x0
  pushl $70
80106b0f:	6a 46                	push   $0x46
  jmp alltraps
80106b11:	e9 d1 f8 ff ff       	jmp    801063e7 <alltraps>

80106b16 <vector71>:
.globl vector71
vector71:
  pushl $0
80106b16:	6a 00                	push   $0x0
  pushl $71
80106b18:	6a 47                	push   $0x47
  jmp alltraps
80106b1a:	e9 c8 f8 ff ff       	jmp    801063e7 <alltraps>

80106b1f <vector72>:
.globl vector72
vector72:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $72
80106b21:	6a 48                	push   $0x48
  jmp alltraps
80106b23:	e9 bf f8 ff ff       	jmp    801063e7 <alltraps>

80106b28 <vector73>:
.globl vector73
vector73:
  pushl $0
80106b28:	6a 00                	push   $0x0
  pushl $73
80106b2a:	6a 49                	push   $0x49
  jmp alltraps
80106b2c:	e9 b6 f8 ff ff       	jmp    801063e7 <alltraps>

80106b31 <vector74>:
.globl vector74
vector74:
  pushl $0
80106b31:	6a 00                	push   $0x0
  pushl $74
80106b33:	6a 4a                	push   $0x4a
  jmp alltraps
80106b35:	e9 ad f8 ff ff       	jmp    801063e7 <alltraps>

80106b3a <vector75>:
.globl vector75
vector75:
  pushl $0
80106b3a:	6a 00                	push   $0x0
  pushl $75
80106b3c:	6a 4b                	push   $0x4b
  jmp alltraps
80106b3e:	e9 a4 f8 ff ff       	jmp    801063e7 <alltraps>

80106b43 <vector76>:
.globl vector76
vector76:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $76
80106b45:	6a 4c                	push   $0x4c
  jmp alltraps
80106b47:	e9 9b f8 ff ff       	jmp    801063e7 <alltraps>

80106b4c <vector77>:
.globl vector77
vector77:
  pushl $0
80106b4c:	6a 00                	push   $0x0
  pushl $77
80106b4e:	6a 4d                	push   $0x4d
  jmp alltraps
80106b50:	e9 92 f8 ff ff       	jmp    801063e7 <alltraps>

80106b55 <vector78>:
.globl vector78
vector78:
  pushl $0
80106b55:	6a 00                	push   $0x0
  pushl $78
80106b57:	6a 4e                	push   $0x4e
  jmp alltraps
80106b59:	e9 89 f8 ff ff       	jmp    801063e7 <alltraps>

80106b5e <vector79>:
.globl vector79
vector79:
  pushl $0
80106b5e:	6a 00                	push   $0x0
  pushl $79
80106b60:	6a 4f                	push   $0x4f
  jmp alltraps
80106b62:	e9 80 f8 ff ff       	jmp    801063e7 <alltraps>

80106b67 <vector80>:
.globl vector80
vector80:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $80
80106b69:	6a 50                	push   $0x50
  jmp alltraps
80106b6b:	e9 77 f8 ff ff       	jmp    801063e7 <alltraps>

80106b70 <vector81>:
.globl vector81
vector81:
  pushl $0
80106b70:	6a 00                	push   $0x0
  pushl $81
80106b72:	6a 51                	push   $0x51
  jmp alltraps
80106b74:	e9 6e f8 ff ff       	jmp    801063e7 <alltraps>

80106b79 <vector82>:
.globl vector82
vector82:
  pushl $0
80106b79:	6a 00                	push   $0x0
  pushl $82
80106b7b:	6a 52                	push   $0x52
  jmp alltraps
80106b7d:	e9 65 f8 ff ff       	jmp    801063e7 <alltraps>

80106b82 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b82:	6a 00                	push   $0x0
  pushl $83
80106b84:	6a 53                	push   $0x53
  jmp alltraps
80106b86:	e9 5c f8 ff ff       	jmp    801063e7 <alltraps>

80106b8b <vector84>:
.globl vector84
vector84:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $84
80106b8d:	6a 54                	push   $0x54
  jmp alltraps
80106b8f:	e9 53 f8 ff ff       	jmp    801063e7 <alltraps>

80106b94 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b94:	6a 00                	push   $0x0
  pushl $85
80106b96:	6a 55                	push   $0x55
  jmp alltraps
80106b98:	e9 4a f8 ff ff       	jmp    801063e7 <alltraps>

80106b9d <vector86>:
.globl vector86
vector86:
  pushl $0
80106b9d:	6a 00                	push   $0x0
  pushl $86
80106b9f:	6a 56                	push   $0x56
  jmp alltraps
80106ba1:	e9 41 f8 ff ff       	jmp    801063e7 <alltraps>

80106ba6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ba6:	6a 00                	push   $0x0
  pushl $87
80106ba8:	6a 57                	push   $0x57
  jmp alltraps
80106baa:	e9 38 f8 ff ff       	jmp    801063e7 <alltraps>

80106baf <vector88>:
.globl vector88
vector88:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $88
80106bb1:	6a 58                	push   $0x58
  jmp alltraps
80106bb3:	e9 2f f8 ff ff       	jmp    801063e7 <alltraps>

80106bb8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106bb8:	6a 00                	push   $0x0
  pushl $89
80106bba:	6a 59                	push   $0x59
  jmp alltraps
80106bbc:	e9 26 f8 ff ff       	jmp    801063e7 <alltraps>

80106bc1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106bc1:	6a 00                	push   $0x0
  pushl $90
80106bc3:	6a 5a                	push   $0x5a
  jmp alltraps
80106bc5:	e9 1d f8 ff ff       	jmp    801063e7 <alltraps>

80106bca <vector91>:
.globl vector91
vector91:
  pushl $0
80106bca:	6a 00                	push   $0x0
  pushl $91
80106bcc:	6a 5b                	push   $0x5b
  jmp alltraps
80106bce:	e9 14 f8 ff ff       	jmp    801063e7 <alltraps>

80106bd3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $92
80106bd5:	6a 5c                	push   $0x5c
  jmp alltraps
80106bd7:	e9 0b f8 ff ff       	jmp    801063e7 <alltraps>

80106bdc <vector93>:
.globl vector93
vector93:
  pushl $0
80106bdc:	6a 00                	push   $0x0
  pushl $93
80106bde:	6a 5d                	push   $0x5d
  jmp alltraps
80106be0:	e9 02 f8 ff ff       	jmp    801063e7 <alltraps>

80106be5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106be5:	6a 00                	push   $0x0
  pushl $94
80106be7:	6a 5e                	push   $0x5e
  jmp alltraps
80106be9:	e9 f9 f7 ff ff       	jmp    801063e7 <alltraps>

80106bee <vector95>:
.globl vector95
vector95:
  pushl $0
80106bee:	6a 00                	push   $0x0
  pushl $95
80106bf0:	6a 5f                	push   $0x5f
  jmp alltraps
80106bf2:	e9 f0 f7 ff ff       	jmp    801063e7 <alltraps>

80106bf7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $96
80106bf9:	6a 60                	push   $0x60
  jmp alltraps
80106bfb:	e9 e7 f7 ff ff       	jmp    801063e7 <alltraps>

80106c00 <vector97>:
.globl vector97
vector97:
  pushl $0
80106c00:	6a 00                	push   $0x0
  pushl $97
80106c02:	6a 61                	push   $0x61
  jmp alltraps
80106c04:	e9 de f7 ff ff       	jmp    801063e7 <alltraps>

80106c09 <vector98>:
.globl vector98
vector98:
  pushl $0
80106c09:	6a 00                	push   $0x0
  pushl $98
80106c0b:	6a 62                	push   $0x62
  jmp alltraps
80106c0d:	e9 d5 f7 ff ff       	jmp    801063e7 <alltraps>

80106c12 <vector99>:
.globl vector99
vector99:
  pushl $0
80106c12:	6a 00                	push   $0x0
  pushl $99
80106c14:	6a 63                	push   $0x63
  jmp alltraps
80106c16:	e9 cc f7 ff ff       	jmp    801063e7 <alltraps>

80106c1b <vector100>:
.globl vector100
vector100:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $100
80106c1d:	6a 64                	push   $0x64
  jmp alltraps
80106c1f:	e9 c3 f7 ff ff       	jmp    801063e7 <alltraps>

80106c24 <vector101>:
.globl vector101
vector101:
  pushl $0
80106c24:	6a 00                	push   $0x0
  pushl $101
80106c26:	6a 65                	push   $0x65
  jmp alltraps
80106c28:	e9 ba f7 ff ff       	jmp    801063e7 <alltraps>

80106c2d <vector102>:
.globl vector102
vector102:
  pushl $0
80106c2d:	6a 00                	push   $0x0
  pushl $102
80106c2f:	6a 66                	push   $0x66
  jmp alltraps
80106c31:	e9 b1 f7 ff ff       	jmp    801063e7 <alltraps>

80106c36 <vector103>:
.globl vector103
vector103:
  pushl $0
80106c36:	6a 00                	push   $0x0
  pushl $103
80106c38:	6a 67                	push   $0x67
  jmp alltraps
80106c3a:	e9 a8 f7 ff ff       	jmp    801063e7 <alltraps>

80106c3f <vector104>:
.globl vector104
vector104:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $104
80106c41:	6a 68                	push   $0x68
  jmp alltraps
80106c43:	e9 9f f7 ff ff       	jmp    801063e7 <alltraps>

80106c48 <vector105>:
.globl vector105
vector105:
  pushl $0
80106c48:	6a 00                	push   $0x0
  pushl $105
80106c4a:	6a 69                	push   $0x69
  jmp alltraps
80106c4c:	e9 96 f7 ff ff       	jmp    801063e7 <alltraps>

80106c51 <vector106>:
.globl vector106
vector106:
  pushl $0
80106c51:	6a 00                	push   $0x0
  pushl $106
80106c53:	6a 6a                	push   $0x6a
  jmp alltraps
80106c55:	e9 8d f7 ff ff       	jmp    801063e7 <alltraps>

80106c5a <vector107>:
.globl vector107
vector107:
  pushl $0
80106c5a:	6a 00                	push   $0x0
  pushl $107
80106c5c:	6a 6b                	push   $0x6b
  jmp alltraps
80106c5e:	e9 84 f7 ff ff       	jmp    801063e7 <alltraps>

80106c63 <vector108>:
.globl vector108
vector108:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $108
80106c65:	6a 6c                	push   $0x6c
  jmp alltraps
80106c67:	e9 7b f7 ff ff       	jmp    801063e7 <alltraps>

80106c6c <vector109>:
.globl vector109
vector109:
  pushl $0
80106c6c:	6a 00                	push   $0x0
  pushl $109
80106c6e:	6a 6d                	push   $0x6d
  jmp alltraps
80106c70:	e9 72 f7 ff ff       	jmp    801063e7 <alltraps>

80106c75 <vector110>:
.globl vector110
vector110:
  pushl $0
80106c75:	6a 00                	push   $0x0
  pushl $110
80106c77:	6a 6e                	push   $0x6e
  jmp alltraps
80106c79:	e9 69 f7 ff ff       	jmp    801063e7 <alltraps>

80106c7e <vector111>:
.globl vector111
vector111:
  pushl $0
80106c7e:	6a 00                	push   $0x0
  pushl $111
80106c80:	6a 6f                	push   $0x6f
  jmp alltraps
80106c82:	e9 60 f7 ff ff       	jmp    801063e7 <alltraps>

80106c87 <vector112>:
.globl vector112
vector112:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $112
80106c89:	6a 70                	push   $0x70
  jmp alltraps
80106c8b:	e9 57 f7 ff ff       	jmp    801063e7 <alltraps>

80106c90 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c90:	6a 00                	push   $0x0
  pushl $113
80106c92:	6a 71                	push   $0x71
  jmp alltraps
80106c94:	e9 4e f7 ff ff       	jmp    801063e7 <alltraps>

80106c99 <vector114>:
.globl vector114
vector114:
  pushl $0
80106c99:	6a 00                	push   $0x0
  pushl $114
80106c9b:	6a 72                	push   $0x72
  jmp alltraps
80106c9d:	e9 45 f7 ff ff       	jmp    801063e7 <alltraps>

80106ca2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ca2:	6a 00                	push   $0x0
  pushl $115
80106ca4:	6a 73                	push   $0x73
  jmp alltraps
80106ca6:	e9 3c f7 ff ff       	jmp    801063e7 <alltraps>

80106cab <vector116>:
.globl vector116
vector116:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $116
80106cad:	6a 74                	push   $0x74
  jmp alltraps
80106caf:	e9 33 f7 ff ff       	jmp    801063e7 <alltraps>

80106cb4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106cb4:	6a 00                	push   $0x0
  pushl $117
80106cb6:	6a 75                	push   $0x75
  jmp alltraps
80106cb8:	e9 2a f7 ff ff       	jmp    801063e7 <alltraps>

80106cbd <vector118>:
.globl vector118
vector118:
  pushl $0
80106cbd:	6a 00                	push   $0x0
  pushl $118
80106cbf:	6a 76                	push   $0x76
  jmp alltraps
80106cc1:	e9 21 f7 ff ff       	jmp    801063e7 <alltraps>

80106cc6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106cc6:	6a 00                	push   $0x0
  pushl $119
80106cc8:	6a 77                	push   $0x77
  jmp alltraps
80106cca:	e9 18 f7 ff ff       	jmp    801063e7 <alltraps>

80106ccf <vector120>:
.globl vector120
vector120:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $120
80106cd1:	6a 78                	push   $0x78
  jmp alltraps
80106cd3:	e9 0f f7 ff ff       	jmp    801063e7 <alltraps>

80106cd8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106cd8:	6a 00                	push   $0x0
  pushl $121
80106cda:	6a 79                	push   $0x79
  jmp alltraps
80106cdc:	e9 06 f7 ff ff       	jmp    801063e7 <alltraps>

80106ce1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ce1:	6a 00                	push   $0x0
  pushl $122
80106ce3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ce5:	e9 fd f6 ff ff       	jmp    801063e7 <alltraps>

80106cea <vector123>:
.globl vector123
vector123:
  pushl $0
80106cea:	6a 00                	push   $0x0
  pushl $123
80106cec:	6a 7b                	push   $0x7b
  jmp alltraps
80106cee:	e9 f4 f6 ff ff       	jmp    801063e7 <alltraps>

80106cf3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $124
80106cf5:	6a 7c                	push   $0x7c
  jmp alltraps
80106cf7:	e9 eb f6 ff ff       	jmp    801063e7 <alltraps>

80106cfc <vector125>:
.globl vector125
vector125:
  pushl $0
80106cfc:	6a 00                	push   $0x0
  pushl $125
80106cfe:	6a 7d                	push   $0x7d
  jmp alltraps
80106d00:	e9 e2 f6 ff ff       	jmp    801063e7 <alltraps>

80106d05 <vector126>:
.globl vector126
vector126:
  pushl $0
80106d05:	6a 00                	push   $0x0
  pushl $126
80106d07:	6a 7e                	push   $0x7e
  jmp alltraps
80106d09:	e9 d9 f6 ff ff       	jmp    801063e7 <alltraps>

80106d0e <vector127>:
.globl vector127
vector127:
  pushl $0
80106d0e:	6a 00                	push   $0x0
  pushl $127
80106d10:	6a 7f                	push   $0x7f
  jmp alltraps
80106d12:	e9 d0 f6 ff ff       	jmp    801063e7 <alltraps>

80106d17 <vector128>:
.globl vector128
vector128:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $128
80106d19:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106d1e:	e9 c4 f6 ff ff       	jmp    801063e7 <alltraps>

80106d23 <vector129>:
.globl vector129
vector129:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $129
80106d25:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106d2a:	e9 b8 f6 ff ff       	jmp    801063e7 <alltraps>

80106d2f <vector130>:
.globl vector130
vector130:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $130
80106d31:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106d36:	e9 ac f6 ff ff       	jmp    801063e7 <alltraps>

80106d3b <vector131>:
.globl vector131
vector131:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $131
80106d3d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106d42:	e9 a0 f6 ff ff       	jmp    801063e7 <alltraps>

80106d47 <vector132>:
.globl vector132
vector132:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $132
80106d49:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106d4e:	e9 94 f6 ff ff       	jmp    801063e7 <alltraps>

80106d53 <vector133>:
.globl vector133
vector133:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $133
80106d55:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106d5a:	e9 88 f6 ff ff       	jmp    801063e7 <alltraps>

80106d5f <vector134>:
.globl vector134
vector134:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $134
80106d61:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106d66:	e9 7c f6 ff ff       	jmp    801063e7 <alltraps>

80106d6b <vector135>:
.globl vector135
vector135:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $135
80106d6d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106d72:	e9 70 f6 ff ff       	jmp    801063e7 <alltraps>

80106d77 <vector136>:
.globl vector136
vector136:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $136
80106d79:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d7e:	e9 64 f6 ff ff       	jmp    801063e7 <alltraps>

80106d83 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $137
80106d85:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d8a:	e9 58 f6 ff ff       	jmp    801063e7 <alltraps>

80106d8f <vector138>:
.globl vector138
vector138:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $138
80106d91:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d96:	e9 4c f6 ff ff       	jmp    801063e7 <alltraps>

80106d9b <vector139>:
.globl vector139
vector139:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $139
80106d9d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106da2:	e9 40 f6 ff ff       	jmp    801063e7 <alltraps>

80106da7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $140
80106da9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106dae:	e9 34 f6 ff ff       	jmp    801063e7 <alltraps>

80106db3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $141
80106db5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106dba:	e9 28 f6 ff ff       	jmp    801063e7 <alltraps>

80106dbf <vector142>:
.globl vector142
vector142:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $142
80106dc1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106dc6:	e9 1c f6 ff ff       	jmp    801063e7 <alltraps>

80106dcb <vector143>:
.globl vector143
vector143:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $143
80106dcd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106dd2:	e9 10 f6 ff ff       	jmp    801063e7 <alltraps>

80106dd7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $144
80106dd9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106dde:	e9 04 f6 ff ff       	jmp    801063e7 <alltraps>

80106de3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $145
80106de5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106dea:	e9 f8 f5 ff ff       	jmp    801063e7 <alltraps>

80106def <vector146>:
.globl vector146
vector146:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $146
80106df1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106df6:	e9 ec f5 ff ff       	jmp    801063e7 <alltraps>

80106dfb <vector147>:
.globl vector147
vector147:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $147
80106dfd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106e02:	e9 e0 f5 ff ff       	jmp    801063e7 <alltraps>

80106e07 <vector148>:
.globl vector148
vector148:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $148
80106e09:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106e0e:	e9 d4 f5 ff ff       	jmp    801063e7 <alltraps>

80106e13 <vector149>:
.globl vector149
vector149:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $149
80106e15:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106e1a:	e9 c8 f5 ff ff       	jmp    801063e7 <alltraps>

80106e1f <vector150>:
.globl vector150
vector150:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $150
80106e21:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106e26:	e9 bc f5 ff ff       	jmp    801063e7 <alltraps>

80106e2b <vector151>:
.globl vector151
vector151:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $151
80106e2d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106e32:	e9 b0 f5 ff ff       	jmp    801063e7 <alltraps>

80106e37 <vector152>:
.globl vector152
vector152:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $152
80106e39:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106e3e:	e9 a4 f5 ff ff       	jmp    801063e7 <alltraps>

80106e43 <vector153>:
.globl vector153
vector153:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $153
80106e45:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106e4a:	e9 98 f5 ff ff       	jmp    801063e7 <alltraps>

80106e4f <vector154>:
.globl vector154
vector154:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $154
80106e51:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106e56:	e9 8c f5 ff ff       	jmp    801063e7 <alltraps>

80106e5b <vector155>:
.globl vector155
vector155:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $155
80106e5d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106e62:	e9 80 f5 ff ff       	jmp    801063e7 <alltraps>

80106e67 <vector156>:
.globl vector156
vector156:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $156
80106e69:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106e6e:	e9 74 f5 ff ff       	jmp    801063e7 <alltraps>

80106e73 <vector157>:
.globl vector157
vector157:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $157
80106e75:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106e7a:	e9 68 f5 ff ff       	jmp    801063e7 <alltraps>

80106e7f <vector158>:
.globl vector158
vector158:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $158
80106e81:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e86:	e9 5c f5 ff ff       	jmp    801063e7 <alltraps>

80106e8b <vector159>:
.globl vector159
vector159:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $159
80106e8d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e92:	e9 50 f5 ff ff       	jmp    801063e7 <alltraps>

80106e97 <vector160>:
.globl vector160
vector160:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $160
80106e99:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e9e:	e9 44 f5 ff ff       	jmp    801063e7 <alltraps>

80106ea3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $161
80106ea5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106eaa:	e9 38 f5 ff ff       	jmp    801063e7 <alltraps>

80106eaf <vector162>:
.globl vector162
vector162:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $162
80106eb1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106eb6:	e9 2c f5 ff ff       	jmp    801063e7 <alltraps>

80106ebb <vector163>:
.globl vector163
vector163:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $163
80106ebd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ec2:	e9 20 f5 ff ff       	jmp    801063e7 <alltraps>

80106ec7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $164
80106ec9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106ece:	e9 14 f5 ff ff       	jmp    801063e7 <alltraps>

80106ed3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $165
80106ed5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106eda:	e9 08 f5 ff ff       	jmp    801063e7 <alltraps>

80106edf <vector166>:
.globl vector166
vector166:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $166
80106ee1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ee6:	e9 fc f4 ff ff       	jmp    801063e7 <alltraps>

80106eeb <vector167>:
.globl vector167
vector167:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $167
80106eed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ef2:	e9 f0 f4 ff ff       	jmp    801063e7 <alltraps>

80106ef7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $168
80106ef9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106efe:	e9 e4 f4 ff ff       	jmp    801063e7 <alltraps>

80106f03 <vector169>:
.globl vector169
vector169:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $169
80106f05:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106f0a:	e9 d8 f4 ff ff       	jmp    801063e7 <alltraps>

80106f0f <vector170>:
.globl vector170
vector170:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $170
80106f11:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106f16:	e9 cc f4 ff ff       	jmp    801063e7 <alltraps>

80106f1b <vector171>:
.globl vector171
vector171:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $171
80106f1d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106f22:	e9 c0 f4 ff ff       	jmp    801063e7 <alltraps>

80106f27 <vector172>:
.globl vector172
vector172:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $172
80106f29:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106f2e:	e9 b4 f4 ff ff       	jmp    801063e7 <alltraps>

80106f33 <vector173>:
.globl vector173
vector173:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $173
80106f35:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106f3a:	e9 a8 f4 ff ff       	jmp    801063e7 <alltraps>

80106f3f <vector174>:
.globl vector174
vector174:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $174
80106f41:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106f46:	e9 9c f4 ff ff       	jmp    801063e7 <alltraps>

80106f4b <vector175>:
.globl vector175
vector175:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $175
80106f4d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106f52:	e9 90 f4 ff ff       	jmp    801063e7 <alltraps>

80106f57 <vector176>:
.globl vector176
vector176:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $176
80106f59:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106f5e:	e9 84 f4 ff ff       	jmp    801063e7 <alltraps>

80106f63 <vector177>:
.globl vector177
vector177:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $177
80106f65:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106f6a:	e9 78 f4 ff ff       	jmp    801063e7 <alltraps>

80106f6f <vector178>:
.globl vector178
vector178:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $178
80106f71:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106f76:	e9 6c f4 ff ff       	jmp    801063e7 <alltraps>

80106f7b <vector179>:
.globl vector179
vector179:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $179
80106f7d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f82:	e9 60 f4 ff ff       	jmp    801063e7 <alltraps>

80106f87 <vector180>:
.globl vector180
vector180:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $180
80106f89:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f8e:	e9 54 f4 ff ff       	jmp    801063e7 <alltraps>

80106f93 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $181
80106f95:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f9a:	e9 48 f4 ff ff       	jmp    801063e7 <alltraps>

80106f9f <vector182>:
.globl vector182
vector182:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $182
80106fa1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106fa6:	e9 3c f4 ff ff       	jmp    801063e7 <alltraps>

80106fab <vector183>:
.globl vector183
vector183:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $183
80106fad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106fb2:	e9 30 f4 ff ff       	jmp    801063e7 <alltraps>

80106fb7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $184
80106fb9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106fbe:	e9 24 f4 ff ff       	jmp    801063e7 <alltraps>

80106fc3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $185
80106fc5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106fca:	e9 18 f4 ff ff       	jmp    801063e7 <alltraps>

80106fcf <vector186>:
.globl vector186
vector186:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $186
80106fd1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106fd6:	e9 0c f4 ff ff       	jmp    801063e7 <alltraps>

80106fdb <vector187>:
.globl vector187
vector187:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $187
80106fdd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106fe2:	e9 00 f4 ff ff       	jmp    801063e7 <alltraps>

80106fe7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $188
80106fe9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106fee:	e9 f4 f3 ff ff       	jmp    801063e7 <alltraps>

80106ff3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $189
80106ff5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106ffa:	e9 e8 f3 ff ff       	jmp    801063e7 <alltraps>

80106fff <vector190>:
.globl vector190
vector190:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $190
80107001:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107006:	e9 dc f3 ff ff       	jmp    801063e7 <alltraps>

8010700b <vector191>:
.globl vector191
vector191:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $191
8010700d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107012:	e9 d0 f3 ff ff       	jmp    801063e7 <alltraps>

80107017 <vector192>:
.globl vector192
vector192:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $192
80107019:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010701e:	e9 c4 f3 ff ff       	jmp    801063e7 <alltraps>

80107023 <vector193>:
.globl vector193
vector193:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $193
80107025:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010702a:	e9 b8 f3 ff ff       	jmp    801063e7 <alltraps>

8010702f <vector194>:
.globl vector194
vector194:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $194
80107031:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107036:	e9 ac f3 ff ff       	jmp    801063e7 <alltraps>

8010703b <vector195>:
.globl vector195
vector195:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $195
8010703d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107042:	e9 a0 f3 ff ff       	jmp    801063e7 <alltraps>

80107047 <vector196>:
.globl vector196
vector196:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $196
80107049:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010704e:	e9 94 f3 ff ff       	jmp    801063e7 <alltraps>

80107053 <vector197>:
.globl vector197
vector197:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $197
80107055:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010705a:	e9 88 f3 ff ff       	jmp    801063e7 <alltraps>

8010705f <vector198>:
.globl vector198
vector198:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $198
80107061:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107066:	e9 7c f3 ff ff       	jmp    801063e7 <alltraps>

8010706b <vector199>:
.globl vector199
vector199:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $199
8010706d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107072:	e9 70 f3 ff ff       	jmp    801063e7 <alltraps>

80107077 <vector200>:
.globl vector200
vector200:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $200
80107079:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010707e:	e9 64 f3 ff ff       	jmp    801063e7 <alltraps>

80107083 <vector201>:
.globl vector201
vector201:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $201
80107085:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010708a:	e9 58 f3 ff ff       	jmp    801063e7 <alltraps>

8010708f <vector202>:
.globl vector202
vector202:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $202
80107091:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107096:	e9 4c f3 ff ff       	jmp    801063e7 <alltraps>

8010709b <vector203>:
.globl vector203
vector203:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $203
8010709d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801070a2:	e9 40 f3 ff ff       	jmp    801063e7 <alltraps>

801070a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $204
801070a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801070ae:	e9 34 f3 ff ff       	jmp    801063e7 <alltraps>

801070b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $205
801070b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801070ba:	e9 28 f3 ff ff       	jmp    801063e7 <alltraps>

801070bf <vector206>:
.globl vector206
vector206:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $206
801070c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801070c6:	e9 1c f3 ff ff       	jmp    801063e7 <alltraps>

801070cb <vector207>:
.globl vector207
vector207:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $207
801070cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801070d2:	e9 10 f3 ff ff       	jmp    801063e7 <alltraps>

801070d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $208
801070d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801070de:	e9 04 f3 ff ff       	jmp    801063e7 <alltraps>

801070e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $209
801070e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801070ea:	e9 f8 f2 ff ff       	jmp    801063e7 <alltraps>

801070ef <vector210>:
.globl vector210
vector210:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $210
801070f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801070f6:	e9 ec f2 ff ff       	jmp    801063e7 <alltraps>

801070fb <vector211>:
.globl vector211
vector211:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $211
801070fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107102:	e9 e0 f2 ff ff       	jmp    801063e7 <alltraps>

80107107 <vector212>:
.globl vector212
vector212:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $212
80107109:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010710e:	e9 d4 f2 ff ff       	jmp    801063e7 <alltraps>

80107113 <vector213>:
.globl vector213
vector213:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $213
80107115:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010711a:	e9 c8 f2 ff ff       	jmp    801063e7 <alltraps>

8010711f <vector214>:
.globl vector214
vector214:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $214
80107121:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107126:	e9 bc f2 ff ff       	jmp    801063e7 <alltraps>

8010712b <vector215>:
.globl vector215
vector215:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $215
8010712d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107132:	e9 b0 f2 ff ff       	jmp    801063e7 <alltraps>

80107137 <vector216>:
.globl vector216
vector216:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $216
80107139:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010713e:	e9 a4 f2 ff ff       	jmp    801063e7 <alltraps>

80107143 <vector217>:
.globl vector217
vector217:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $217
80107145:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010714a:	e9 98 f2 ff ff       	jmp    801063e7 <alltraps>

8010714f <vector218>:
.globl vector218
vector218:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $218
80107151:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107156:	e9 8c f2 ff ff       	jmp    801063e7 <alltraps>

8010715b <vector219>:
.globl vector219
vector219:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $219
8010715d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107162:	e9 80 f2 ff ff       	jmp    801063e7 <alltraps>

80107167 <vector220>:
.globl vector220
vector220:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $220
80107169:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010716e:	e9 74 f2 ff ff       	jmp    801063e7 <alltraps>

80107173 <vector221>:
.globl vector221
vector221:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $221
80107175:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010717a:	e9 68 f2 ff ff       	jmp    801063e7 <alltraps>

8010717f <vector222>:
.globl vector222
vector222:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $222
80107181:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107186:	e9 5c f2 ff ff       	jmp    801063e7 <alltraps>

8010718b <vector223>:
.globl vector223
vector223:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $223
8010718d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107192:	e9 50 f2 ff ff       	jmp    801063e7 <alltraps>

80107197 <vector224>:
.globl vector224
vector224:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $224
80107199:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010719e:	e9 44 f2 ff ff       	jmp    801063e7 <alltraps>

801071a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $225
801071a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801071aa:	e9 38 f2 ff ff       	jmp    801063e7 <alltraps>

801071af <vector226>:
.globl vector226
vector226:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $226
801071b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801071b6:	e9 2c f2 ff ff       	jmp    801063e7 <alltraps>

801071bb <vector227>:
.globl vector227
vector227:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $227
801071bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801071c2:	e9 20 f2 ff ff       	jmp    801063e7 <alltraps>

801071c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $228
801071c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801071ce:	e9 14 f2 ff ff       	jmp    801063e7 <alltraps>

801071d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $229
801071d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801071da:	e9 08 f2 ff ff       	jmp    801063e7 <alltraps>

801071df <vector230>:
.globl vector230
vector230:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $230
801071e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801071e6:	e9 fc f1 ff ff       	jmp    801063e7 <alltraps>

801071eb <vector231>:
.globl vector231
vector231:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $231
801071ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801071f2:	e9 f0 f1 ff ff       	jmp    801063e7 <alltraps>

801071f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $232
801071f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801071fe:	e9 e4 f1 ff ff       	jmp    801063e7 <alltraps>

80107203 <vector233>:
.globl vector233
vector233:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $233
80107205:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010720a:	e9 d8 f1 ff ff       	jmp    801063e7 <alltraps>

8010720f <vector234>:
.globl vector234
vector234:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $234
80107211:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107216:	e9 cc f1 ff ff       	jmp    801063e7 <alltraps>

8010721b <vector235>:
.globl vector235
vector235:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $235
8010721d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107222:	e9 c0 f1 ff ff       	jmp    801063e7 <alltraps>

80107227 <vector236>:
.globl vector236
vector236:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $236
80107229:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010722e:	e9 b4 f1 ff ff       	jmp    801063e7 <alltraps>

80107233 <vector237>:
.globl vector237
vector237:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $237
80107235:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010723a:	e9 a8 f1 ff ff       	jmp    801063e7 <alltraps>

8010723f <vector238>:
.globl vector238
vector238:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $238
80107241:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107246:	e9 9c f1 ff ff       	jmp    801063e7 <alltraps>

8010724b <vector239>:
.globl vector239
vector239:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $239
8010724d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107252:	e9 90 f1 ff ff       	jmp    801063e7 <alltraps>

80107257 <vector240>:
.globl vector240
vector240:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $240
80107259:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010725e:	e9 84 f1 ff ff       	jmp    801063e7 <alltraps>

80107263 <vector241>:
.globl vector241
vector241:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $241
80107265:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010726a:	e9 78 f1 ff ff       	jmp    801063e7 <alltraps>

8010726f <vector242>:
.globl vector242
vector242:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $242
80107271:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107276:	e9 6c f1 ff ff       	jmp    801063e7 <alltraps>

8010727b <vector243>:
.globl vector243
vector243:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $243
8010727d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107282:	e9 60 f1 ff ff       	jmp    801063e7 <alltraps>

80107287 <vector244>:
.globl vector244
vector244:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $244
80107289:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010728e:	e9 54 f1 ff ff       	jmp    801063e7 <alltraps>

80107293 <vector245>:
.globl vector245
vector245:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $245
80107295:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010729a:	e9 48 f1 ff ff       	jmp    801063e7 <alltraps>

8010729f <vector246>:
.globl vector246
vector246:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $246
801072a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801072a6:	e9 3c f1 ff ff       	jmp    801063e7 <alltraps>

801072ab <vector247>:
.globl vector247
vector247:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $247
801072ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801072b2:	e9 30 f1 ff ff       	jmp    801063e7 <alltraps>

801072b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $248
801072b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801072be:	e9 24 f1 ff ff       	jmp    801063e7 <alltraps>

801072c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $249
801072c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801072ca:	e9 18 f1 ff ff       	jmp    801063e7 <alltraps>

801072cf <vector250>:
.globl vector250
vector250:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $250
801072d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801072d6:	e9 0c f1 ff ff       	jmp    801063e7 <alltraps>

801072db <vector251>:
.globl vector251
vector251:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $251
801072dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801072e2:	e9 00 f1 ff ff       	jmp    801063e7 <alltraps>

801072e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $252
801072e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801072ee:	e9 f4 f0 ff ff       	jmp    801063e7 <alltraps>

801072f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $253
801072f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801072fa:	e9 e8 f0 ff ff       	jmp    801063e7 <alltraps>

801072ff <vector254>:
.globl vector254
vector254:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $254
80107301:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107306:	e9 dc f0 ff ff       	jmp    801063e7 <alltraps>

8010730b <vector255>:
.globl vector255
vector255:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $255
8010730d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107312:	e9 d0 f0 ff ff       	jmp    801063e7 <alltraps>
80107317:	66 90                	xchg   %ax,%ax
80107319:	66 90                	xchg   %ax,%ax
8010731b:	66 90                	xchg   %ax,%ax
8010731d:	66 90                	xchg   %ax,%ax
8010731f:	90                   	nop

80107320 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107328:	c1 ea 16             	shr    $0x16,%edx
8010732b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010732e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80107331:	8b 07                	mov    (%edi),%eax
80107333:	a8 01                	test   $0x1,%al
80107335:	74 29                	je     80107360 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107337:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010733c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107342:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107345:	c1 eb 0a             	shr    $0xa,%ebx
80107348:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010734e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80107351:	5b                   	pop    %ebx
80107352:	5e                   	pop    %esi
80107353:	5f                   	pop    %edi
80107354:	5d                   	pop    %ebp
80107355:	c3                   	ret    
80107356:	8d 76 00             	lea    0x0(%esi),%esi
80107359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107360:	85 c9                	test   %ecx,%ecx
80107362:	74 2c                	je     80107390 <walkpgdir+0x70>
80107364:	e8 37 b1 ff ff       	call   801024a0 <kalloc>
80107369:	85 c0                	test   %eax,%eax
8010736b:	89 c6                	mov    %eax,%esi
8010736d:	74 21                	je     80107390 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010736f:	83 ec 04             	sub    $0x4,%esp
80107372:	68 00 10 00 00       	push   $0x1000
80107377:	6a 00                	push   $0x0
80107379:	50                   	push   %eax
8010737a:	e8 b1 dd ff ff       	call   80105130 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010737f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107385:	83 c4 10             	add    $0x10,%esp
80107388:	83 c8 07             	or     $0x7,%eax
8010738b:	89 07                	mov    %eax,(%edi)
8010738d:	eb b3                	jmp    80107342 <walkpgdir+0x22>
8010738f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80107390:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80107393:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107395:	5b                   	pop    %ebx
80107396:	5e                   	pop    %esi
80107397:	5f                   	pop    %edi
80107398:	5d                   	pop    %ebp
80107399:	c3                   	ret    
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801073a6:	89 d3                	mov    %edx,%ebx
801073a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801073ae:	83 ec 1c             	sub    $0x1c,%esp
801073b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801073b4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801073b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801073bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801073c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801073c6:	29 df                	sub    %ebx,%edi
801073c8:	83 c8 01             	or     $0x1,%eax
801073cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801073ce:	eb 15                	jmp    801073e5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801073d0:	f6 00 01             	testb  $0x1,(%eax)
801073d3:	75 45                	jne    8010741a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801073d5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801073d8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801073db:	89 30                	mov    %esi,(%eax)
    if(a == last)
801073dd:	74 31                	je     80107410 <mappages+0x70>
      break;
    a += PGSIZE;
801073df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801073e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073e8:	b9 01 00 00 00       	mov    $0x1,%ecx
801073ed:	89 da                	mov    %ebx,%edx
801073ef:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801073f2:	e8 29 ff ff ff       	call   80107320 <walkpgdir>
801073f7:	85 c0                	test   %eax,%eax
801073f9:	75 d5                	jne    801073d0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801073fb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801073fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80107403:	5b                   	pop    %ebx
80107404:	5e                   	pop    %esi
80107405:	5f                   	pop    %edi
80107406:	5d                   	pop    %ebp
80107407:	c3                   	ret    
80107408:	90                   	nop
80107409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107410:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107413:	31 c0                	xor    %eax,%eax
}
80107415:	5b                   	pop    %ebx
80107416:	5e                   	pop    %esi
80107417:	5f                   	pop    %edi
80107418:	5d                   	pop    %ebp
80107419:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010741a:	83 ec 0c             	sub    $0xc,%esp
8010741d:	68 38 86 10 80       	push   $0x80108638
80107422:	e8 49 8f ff ff       	call   80100370 <panic>
80107427:	89 f6                	mov    %esi,%esi
80107429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107430 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107436:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010743c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010743e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107444:	83 ec 1c             	sub    $0x1c,%esp
80107447:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010744a:	39 d3                	cmp    %edx,%ebx
8010744c:	73 66                	jae    801074b4 <deallocuvm.part.0+0x84>
8010744e:	89 d6                	mov    %edx,%esi
80107450:	eb 3d                	jmp    8010748f <deallocuvm.part.0+0x5f>
80107452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107458:	8b 10                	mov    (%eax),%edx
8010745a:	f6 c2 01             	test   $0x1,%dl
8010745d:	74 26                	je     80107485 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010745f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107465:	74 58                	je     801074bf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107467:	83 ec 0c             	sub    $0xc,%esp
8010746a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107473:	52                   	push   %edx
80107474:	e8 77 ae ff ff       	call   801022f0 <kfree>
      *pte = 0;
80107479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010747c:	83 c4 10             	add    $0x10,%esp
8010747f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107485:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010748b:	39 f3                	cmp    %esi,%ebx
8010748d:	73 25                	jae    801074b4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010748f:	31 c9                	xor    %ecx,%ecx
80107491:	89 da                	mov    %ebx,%edx
80107493:	89 f8                	mov    %edi,%eax
80107495:	e8 86 fe ff ff       	call   80107320 <walkpgdir>
    if(!pte)
8010749a:	85 c0                	test   %eax,%eax
8010749c:	75 ba                	jne    80107458 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010749e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801074a4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801074aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074b0:	39 f3                	cmp    %esi,%ebx
801074b2:	72 db                	jb     8010748f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801074b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ba:	5b                   	pop    %ebx
801074bb:	5e                   	pop    %esi
801074bc:	5f                   	pop    %edi
801074bd:	5d                   	pop    %ebp
801074be:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801074bf:	83 ec 0c             	sub    $0xc,%esp
801074c2:	68 26 7f 10 80       	push   $0x80107f26
801074c7:	e8 a4 8e ff ff       	call   80100370 <panic>
801074cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074d0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801074d6:	e8 a5 c3 ff ff       	call   80103880 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801074db:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801074e1:	31 c9                	xor    %ecx,%ecx
801074e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801074e8:	66 89 90 18 38 11 80 	mov    %dx,-0x7feec7e8(%eax)
801074ef:	66 89 88 1a 38 11 80 	mov    %cx,-0x7feec7e6(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801074f6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801074fb:	31 c9                	xor    %ecx,%ecx
801074fd:	66 89 90 20 38 11 80 	mov    %dx,-0x7feec7e0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107504:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107509:	66 89 88 22 38 11 80 	mov    %cx,-0x7feec7de(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107510:	31 c9                	xor    %ecx,%ecx
80107512:	66 89 90 28 38 11 80 	mov    %dx,-0x7feec7d8(%eax)
80107519:	66 89 88 2a 38 11 80 	mov    %cx,-0x7feec7d6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107520:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107525:	31 c9                	xor    %ecx,%ecx
80107527:	66 89 90 30 38 11 80 	mov    %dx,-0x7feec7d0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010752e:	c6 80 1c 38 11 80 00 	movb   $0x0,-0x7feec7e4(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107535:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010753a:	c6 80 1d 38 11 80 9a 	movb   $0x9a,-0x7feec7e3(%eax)
80107541:	c6 80 1e 38 11 80 cf 	movb   $0xcf,-0x7feec7e2(%eax)
80107548:	c6 80 1f 38 11 80 00 	movb   $0x0,-0x7feec7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010754f:	c6 80 24 38 11 80 00 	movb   $0x0,-0x7feec7dc(%eax)
80107556:	c6 80 25 38 11 80 92 	movb   $0x92,-0x7feec7db(%eax)
8010755d:	c6 80 26 38 11 80 cf 	movb   $0xcf,-0x7feec7da(%eax)
80107564:	c6 80 27 38 11 80 00 	movb   $0x0,-0x7feec7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010756b:	c6 80 2c 38 11 80 00 	movb   $0x0,-0x7feec7d4(%eax)
80107572:	c6 80 2d 38 11 80 fa 	movb   $0xfa,-0x7feec7d3(%eax)
80107579:	c6 80 2e 38 11 80 cf 	movb   $0xcf,-0x7feec7d2(%eax)
80107580:	c6 80 2f 38 11 80 00 	movb   $0x0,-0x7feec7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107587:	66 89 88 32 38 11 80 	mov    %cx,-0x7feec7ce(%eax)
8010758e:	c6 80 34 38 11 80 00 	movb   $0x0,-0x7feec7cc(%eax)
80107595:	c6 80 35 38 11 80 f2 	movb   $0xf2,-0x7feec7cb(%eax)
8010759c:	c6 80 36 38 11 80 cf 	movb   $0xcf,-0x7feec7ca(%eax)
801075a3:	c6 80 37 38 11 80 00 	movb   $0x0,-0x7feec7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801075aa:	05 10 38 11 80       	add    $0x80113810,%eax
801075af:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801075b3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801075b7:	c1 e8 10             	shr    $0x10,%eax
801075ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801075be:	8d 45 f2             	lea    -0xe(%ebp),%eax
801075c1:	0f 01 10             	lgdtl  (%eax)
}
801075c4:	c9                   	leave  
801075c5:	c3                   	ret    
801075c6:	8d 76 00             	lea    0x0(%esi),%esi
801075c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075d0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801075d0:	a1 24 43 12 80       	mov    0x80124324,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801075d5:	55                   	push   %ebp
801075d6:	89 e5                	mov    %esp,%ebp
801075d8:	05 00 00 00 80       	add    $0x80000000,%eax
801075dd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801075e0:	5d                   	pop    %ebp
801075e1:	c3                   	ret    
801075e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075f0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	57                   	push   %edi
801075f4:	56                   	push   %esi
801075f5:	53                   	push   %ebx
801075f6:	83 ec 1c             	sub    $0x1c,%esp
801075f9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801075fc:	85 f6                	test   %esi,%esi
801075fe:	0f 84 d9 00 00 00    	je     801076dd <switchuvm+0xed>
    panic("switchuvm: no process");
  if(p->mainThread->tkstack == 0)
80107604:	8b 86 b4 03 00 00    	mov    0x3b4(%esi),%eax
8010760a:	8b 40 04             	mov    0x4(%eax),%eax
8010760d:	85 c0                	test   %eax,%eax
8010760f:	0f 84 e2 00 00 00    	je     801076f7 <switchuvm+0x107>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107615:	8b 7e 04             	mov    0x4(%esi),%edi
80107618:	85 ff                	test   %edi,%edi
8010761a:	0f 84 ca 00 00 00    	je     801076ea <switchuvm+0xfa>
    panic("switchuvm: no pgdir");

  pushcli();
80107620:	e8 1b d9 ff ff       	call   80104f40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107625:	e8 d6 c1 ff ff       	call   80103800 <mycpu>
8010762a:	89 c3                	mov    %eax,%ebx
8010762c:	e8 cf c1 ff ff       	call   80103800 <mycpu>
80107631:	89 c7                	mov    %eax,%edi
80107633:	e8 c8 c1 ff ff       	call   80103800 <mycpu>
80107638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010763b:	83 c7 08             	add    $0x8,%edi
8010763e:	e8 bd c1 ff ff       	call   80103800 <mycpu>
80107643:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107646:	83 c0 08             	add    $0x8,%eax
80107649:	ba 67 00 00 00       	mov    $0x67,%edx
8010764e:	c1 e8 18             	shr    $0x18,%eax
80107651:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107658:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010765f:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107666:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
8010766d:	83 c1 08             	add    $0x8,%ecx
80107670:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107676:	c1 e9 10             	shr    $0x10,%ecx
80107679:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010767f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107684:	e8 77 c1 ff ff       	call   80103800 <mycpu>
80107689:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107690:	e8 6b c1 ff ff       	call   80103800 <mycpu>
80107695:	b9 10 00 00 00       	mov    $0x10,%ecx
8010769a:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
8010769e:	e8 5d c1 ff ff       	call   80103800 <mycpu>
801076a3:	8b 8e b4 03 00 00    	mov    0x3b4(%esi),%ecx
801076a9:	8b 49 04             	mov    0x4(%ecx),%ecx
801076ac:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801076b2:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076b5:	e8 46 c1 ff ff       	call   80103800 <mycpu>
801076ba:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801076be:	b8 28 00 00 00       	mov    $0x28,%eax
801076c3:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076c6:	8b 46 04             	mov    0x4(%esi),%eax
801076c9:	05 00 00 00 80       	add    $0x80000000,%eax
801076ce:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801076d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d4:	5b                   	pop    %ebx
801076d5:	5e                   	pop    %esi
801076d6:	5f                   	pop    %edi
801076d7:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801076d8:	e9 a3 d8 ff ff       	jmp    80104f80 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801076dd:	83 ec 0c             	sub    $0xc,%esp
801076e0:	68 3e 86 10 80       	push   $0x8010863e
801076e5:	e8 86 8c ff ff       	call   80100370 <panic>
  if(p->mainThread->tkstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801076ea:	83 ec 0c             	sub    $0xc,%esp
801076ed:	68 69 86 10 80       	push   $0x80108669
801076f2:	e8 79 8c ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->mainThread->tkstack == 0)
    panic("switchuvm: no kstack");
801076f7:	83 ec 0c             	sub    $0xc,%esp
801076fa:	68 54 86 10 80       	push   $0x80108654
801076ff:	e8 6c 8c ff ff       	call   80100370 <panic>
80107704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010770a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107710 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 1c             	sub    $0x1c,%esp
80107719:	8b 75 10             	mov    0x10(%ebp),%esi
8010771c:	8b 45 08             	mov    0x8(%ebp),%eax
8010771f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107722:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010772b:	77 49                	ja     80107776 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010772d:	e8 6e ad ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
80107732:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107735:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107737:	68 00 10 00 00       	push   $0x1000
8010773c:	6a 00                	push   $0x0
8010773e:	50                   	push   %eax
8010773f:	e8 ec d9 ff ff       	call   80105130 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107744:	58                   	pop    %eax
80107745:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010774b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107750:	5a                   	pop    %edx
80107751:	6a 06                	push   $0x6
80107753:	50                   	push   %eax
80107754:	31 d2                	xor    %edx,%edx
80107756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107759:	e8 42 fc ff ff       	call   801073a0 <mappages>
  memmove(mem, init, sz);
8010775e:	89 75 10             	mov    %esi,0x10(%ebp)
80107761:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107764:	83 c4 10             	add    $0x10,%esp
80107767:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010776a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010776d:	5b                   	pop    %ebx
8010776e:	5e                   	pop    %esi
8010776f:	5f                   	pop    %edi
80107770:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107771:	e9 6a da ff ff       	jmp    801051e0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107776:	83 ec 0c             	sub    $0xc,%esp
80107779:	68 7d 86 10 80       	push   $0x8010867d
8010777e:	e8 ed 8b ff ff       	call   80100370 <panic>
80107783:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107790 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
80107796:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107799:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801077a0:	0f 85 91 00 00 00    	jne    80107837 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801077a6:	8b 75 18             	mov    0x18(%ebp),%esi
801077a9:	31 db                	xor    %ebx,%ebx
801077ab:	85 f6                	test   %esi,%esi
801077ad:	75 1a                	jne    801077c9 <loaduvm+0x39>
801077af:	eb 6f                	jmp    80107820 <loaduvm+0x90>
801077b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077be:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801077c4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801077c7:	76 57                	jbe    80107820 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801077c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801077cc:	8b 45 08             	mov    0x8(%ebp),%eax
801077cf:	31 c9                	xor    %ecx,%ecx
801077d1:	01 da                	add    %ebx,%edx
801077d3:	e8 48 fb ff ff       	call   80107320 <walkpgdir>
801077d8:	85 c0                	test   %eax,%eax
801077da:	74 4e                	je     8010782a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801077dc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801077de:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801077e1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801077e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801077eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801077f1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801077f4:	01 d9                	add    %ebx,%ecx
801077f6:	05 00 00 00 80       	add    $0x80000000,%eax
801077fb:	57                   	push   %edi
801077fc:	51                   	push   %ecx
801077fd:	50                   	push   %eax
801077fe:	ff 75 10             	pushl  0x10(%ebp)
80107801:	e8 5a a1 ff ff       	call   80101960 <readi>
80107806:	83 c4 10             	add    $0x10,%esp
80107809:	39 c7                	cmp    %eax,%edi
8010780b:	74 ab                	je     801077b8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010780d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107815:	5b                   	pop    %ebx
80107816:	5e                   	pop    %esi
80107817:	5f                   	pop    %edi
80107818:	5d                   	pop    %ebp
80107819:	c3                   	ret    
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107820:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107823:	31 c0                	xor    %eax,%eax
}
80107825:	5b                   	pop    %ebx
80107826:	5e                   	pop    %esi
80107827:	5f                   	pop    %edi
80107828:	5d                   	pop    %ebp
80107829:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010782a:	83 ec 0c             	sub    $0xc,%esp
8010782d:	68 97 86 10 80       	push   $0x80108697
80107832:	e8 39 8b ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107837:	83 ec 0c             	sub    $0xc,%esp
8010783a:	68 38 87 10 80       	push   $0x80108738
8010783f:	e8 2c 8b ff ff       	call   80100370 <panic>
80107844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010784a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107850 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	56                   	push   %esi
80107855:	53                   	push   %ebx
80107856:	83 ec 0c             	sub    $0xc,%esp
80107859:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010785c:	85 ff                	test   %edi,%edi
8010785e:	0f 88 ca 00 00 00    	js     8010792e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107864:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107867:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010786a:	0f 82 82 00 00 00    	jb     801078f2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107870:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107876:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010787c:	39 df                	cmp    %ebx,%edi
8010787e:	77 43                	ja     801078c3 <allocuvm+0x73>
80107880:	e9 bb 00 00 00       	jmp    80107940 <allocuvm+0xf0>
80107885:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107888:	83 ec 04             	sub    $0x4,%esp
8010788b:	68 00 10 00 00       	push   $0x1000
80107890:	6a 00                	push   $0x0
80107892:	50                   	push   %eax
80107893:	e8 98 d8 ff ff       	call   80105130 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107898:	58                   	pop    %eax
80107899:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010789f:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078a4:	5a                   	pop    %edx
801078a5:	6a 06                	push   $0x6
801078a7:	50                   	push   %eax
801078a8:	89 da                	mov    %ebx,%edx
801078aa:	8b 45 08             	mov    0x8(%ebp),%eax
801078ad:	e8 ee fa ff ff       	call   801073a0 <mappages>
801078b2:	83 c4 10             	add    $0x10,%esp
801078b5:	85 c0                	test   %eax,%eax
801078b7:	78 47                	js     80107900 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801078b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078bf:	39 df                	cmp    %ebx,%edi
801078c1:	76 7d                	jbe    80107940 <allocuvm+0xf0>
    mem = kalloc();
801078c3:	e8 d8 ab ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
801078c8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801078ca:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801078cc:	75 ba                	jne    80107888 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801078ce:	83 ec 0c             	sub    $0xc,%esp
801078d1:	68 b5 86 10 80       	push   $0x801086b5
801078d6:	e8 85 8d ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801078db:	83 c4 10             	add    $0x10,%esp
801078de:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801078e1:	76 4b                	jbe    8010792e <allocuvm+0xde>
801078e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078e6:	8b 45 08             	mov    0x8(%ebp),%eax
801078e9:	89 fa                	mov    %edi,%edx
801078eb:	e8 40 fb ff ff       	call   80107430 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801078f0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801078f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078f5:	5b                   	pop    %ebx
801078f6:	5e                   	pop    %esi
801078f7:	5f                   	pop    %edi
801078f8:	5d                   	pop    %ebp
801078f9:	c3                   	ret    
801078fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107900:	83 ec 0c             	sub    $0xc,%esp
80107903:	68 cd 86 10 80       	push   $0x801086cd
80107908:	e8 53 8d ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010790d:	83 c4 10             	add    $0x10,%esp
80107910:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107913:	76 0d                	jbe    80107922 <allocuvm+0xd2>
80107915:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107918:	8b 45 08             	mov    0x8(%ebp),%eax
8010791b:	89 fa                	mov    %edi,%edx
8010791d:	e8 0e fb ff ff       	call   80107430 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107922:	83 ec 0c             	sub    $0xc,%esp
80107925:	56                   	push   %esi
80107926:	e8 c5 a9 ff ff       	call   801022f0 <kfree>
      return 0;
8010792b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010792e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107931:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107933:	5b                   	pop    %ebx
80107934:	5e                   	pop    %esi
80107935:	5f                   	pop    %edi
80107936:	5d                   	pop    %ebp
80107937:	c3                   	ret    
80107938:	90                   	nop
80107939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107940:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107943:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107945:	5b                   	pop    %ebx
80107946:	5e                   	pop    %esi
80107947:	5f                   	pop    %edi
80107948:	5d                   	pop    %ebp
80107949:	c3                   	ret    
8010794a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107950 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	8b 55 0c             	mov    0xc(%ebp),%edx
80107956:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107959:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010795c:	39 d1                	cmp    %edx,%ecx
8010795e:	73 10                	jae    80107970 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107960:	5d                   	pop    %ebp
80107961:	e9 ca fa ff ff       	jmp    80107430 <deallocuvm.part.0>
80107966:	8d 76 00             	lea    0x0(%esi),%esi
80107969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107970:	89 d0                	mov    %edx,%eax
80107972:	5d                   	pop    %ebp
80107973:	c3                   	ret    
80107974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010797a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107980 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	57                   	push   %edi
80107984:	56                   	push   %esi
80107985:	53                   	push   %ebx
80107986:	83 ec 0c             	sub    $0xc,%esp
80107989:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010798c:	85 f6                	test   %esi,%esi
8010798e:	74 59                	je     801079e9 <freevm+0x69>
80107990:	31 c9                	xor    %ecx,%ecx
80107992:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107997:	89 f0                	mov    %esi,%eax
80107999:	e8 92 fa ff ff       	call   80107430 <deallocuvm.part.0>
8010799e:	89 f3                	mov    %esi,%ebx
801079a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801079a6:	eb 0f                	jmp    801079b7 <freevm+0x37>
801079a8:	90                   	nop
801079a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079b0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801079b3:	39 fb                	cmp    %edi,%ebx
801079b5:	74 23                	je     801079da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801079b7:	8b 03                	mov    (%ebx),%eax
801079b9:	a8 01                	test   $0x1,%al
801079bb:	74 f3                	je     801079b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801079bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079c2:	83 ec 0c             	sub    $0xc,%esp
801079c5:	83 c3 04             	add    $0x4,%ebx
801079c8:	05 00 00 00 80       	add    $0x80000000,%eax
801079cd:	50                   	push   %eax
801079ce:	e8 1d a9 ff ff       	call   801022f0 <kfree>
801079d3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801079d6:	39 fb                	cmp    %edi,%ebx
801079d8:	75 dd                	jne    801079b7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801079da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801079dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079e0:	5b                   	pop    %ebx
801079e1:	5e                   	pop    %esi
801079e2:	5f                   	pop    %edi
801079e3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801079e4:	e9 07 a9 ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801079e9:	83 ec 0c             	sub    $0xc,%esp
801079ec:	68 e9 86 10 80       	push   $0x801086e9
801079f1:	e8 7a 89 ff ff       	call   80100370 <panic>
801079f6:	8d 76 00             	lea    0x0(%esi),%esi
801079f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a00 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	56                   	push   %esi
80107a04:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107a05:	e8 96 aa ff ff       	call   801024a0 <kalloc>
80107a0a:	85 c0                	test   %eax,%eax
80107a0c:	74 6a                	je     80107a78 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80107a0e:	83 ec 04             	sub    $0x4,%esp
80107a11:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a13:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107a18:	68 00 10 00 00       	push   $0x1000
80107a1d:	6a 00                	push   $0x0
80107a1f:	50                   	push   %eax
80107a20:	e8 0b d7 ff ff       	call   80105130 <memset>
80107a25:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a28:	8b 43 04             	mov    0x4(%ebx),%eax
80107a2b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107a2e:	83 ec 08             	sub    $0x8,%esp
80107a31:	8b 13                	mov    (%ebx),%edx
80107a33:	ff 73 0c             	pushl  0xc(%ebx)
80107a36:	50                   	push   %eax
80107a37:	29 c1                	sub    %eax,%ecx
80107a39:	89 f0                	mov    %esi,%eax
80107a3b:	e8 60 f9 ff ff       	call   801073a0 <mappages>
80107a40:	83 c4 10             	add    $0x10,%esp
80107a43:	85 c0                	test   %eax,%eax
80107a45:	78 19                	js     80107a60 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a47:	83 c3 10             	add    $0x10,%ebx
80107a4a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107a50:	75 d6                	jne    80107a28 <setupkvm+0x28>
80107a52:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a57:	5b                   	pop    %ebx
80107a58:	5e                   	pop    %esi
80107a59:	5d                   	pop    %ebp
80107a5a:	c3                   	ret    
80107a5b:	90                   	nop
80107a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107a60:	83 ec 0c             	sub    $0xc,%esp
80107a63:	56                   	push   %esi
80107a64:	e8 17 ff ff ff       	call   80107980 <freevm>
      return 0;
80107a69:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80107a6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80107a6f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107a71:	5b                   	pop    %ebx
80107a72:	5e                   	pop    %esi
80107a73:	5d                   	pop    %ebp
80107a74:	c3                   	ret    
80107a75:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107a78:	31 c0                	xor    %eax,%eax
80107a7a:	eb d8                	jmp    80107a54 <setupkvm+0x54>
80107a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a80 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107a86:	e8 75 ff ff ff       	call   80107a00 <setupkvm>
80107a8b:	a3 24 43 12 80       	mov    %eax,0x80124324
80107a90:	05 00 00 00 80       	add    $0x80000000,%eax
80107a95:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107a98:	c9                   	leave  
80107a99:	c3                   	ret    
80107a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107aa0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107aa0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107aa1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107aa3:	89 e5                	mov    %esp,%ebp
80107aa5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107aab:	8b 45 08             	mov    0x8(%ebp),%eax
80107aae:	e8 6d f8 ff ff       	call   80107320 <walkpgdir>
  if(pte == 0)
80107ab3:	85 c0                	test   %eax,%eax
80107ab5:	74 05                	je     80107abc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107ab7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107aba:	c9                   	leave  
80107abb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107abc:	83 ec 0c             	sub    $0xc,%esp
80107abf:	68 fa 86 10 80       	push   $0x801086fa
80107ac4:	e8 a7 88 ff ff       	call   80100370 <panic>
80107ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ad0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107ad0:	55                   	push   %ebp
80107ad1:	89 e5                	mov    %esp,%ebp
80107ad3:	57                   	push   %edi
80107ad4:	56                   	push   %esi
80107ad5:	53                   	push   %ebx
80107ad6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107ad9:	e8 22 ff ff ff       	call   80107a00 <setupkvm>
80107ade:	85 c0                	test   %eax,%eax
80107ae0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ae3:	0f 84 c5 00 00 00    	je     80107bae <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ae9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107aec:	85 c9                	test   %ecx,%ecx
80107aee:	0f 84 9c 00 00 00    	je     80107b90 <copyuvm+0xc0>
80107af4:	31 ff                	xor    %edi,%edi
80107af6:	eb 4a                	jmp    80107b42 <copyuvm+0x72>
80107af8:	90                   	nop
80107af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107b00:	83 ec 04             	sub    $0x4,%esp
80107b03:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107b09:	68 00 10 00 00       	push   $0x1000
80107b0e:	53                   	push   %ebx
80107b0f:	50                   	push   %eax
80107b10:	e8 cb d6 ff ff       	call   801051e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107b15:	58                   	pop    %eax
80107b16:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107b1c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b21:	5a                   	pop    %edx
80107b22:	ff 75 e4             	pushl  -0x1c(%ebp)
80107b25:	50                   	push   %eax
80107b26:	89 fa                	mov    %edi,%edx
80107b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b2b:	e8 70 f8 ff ff       	call   801073a0 <mappages>
80107b30:	83 c4 10             	add    $0x10,%esp
80107b33:	85 c0                	test   %eax,%eax
80107b35:	78 69                	js     80107ba0 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b37:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107b3d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107b40:	76 4e                	jbe    80107b90 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107b42:	8b 45 08             	mov    0x8(%ebp),%eax
80107b45:	31 c9                	xor    %ecx,%ecx
80107b47:	89 fa                	mov    %edi,%edx
80107b49:	e8 d2 f7 ff ff       	call   80107320 <walkpgdir>
80107b4e:	85 c0                	test   %eax,%eax
80107b50:	74 6d                	je     80107bbf <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107b52:	8b 00                	mov    (%eax),%eax
80107b54:	a8 01                	test   $0x1,%al
80107b56:	74 5a                	je     80107bb2 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107b58:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107b5a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107b5f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107b65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107b68:	e8 33 a9 ff ff       	call   801024a0 <kalloc>
80107b6d:	85 c0                	test   %eax,%eax
80107b6f:	89 c6                	mov    %eax,%esi
80107b71:	75 8d                	jne    80107b00 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107b73:	83 ec 0c             	sub    $0xc,%esp
80107b76:	ff 75 e0             	pushl  -0x20(%ebp)
80107b79:	e8 02 fe ff ff       	call   80107980 <freevm>
  return 0;
80107b7e:	83 c4 10             	add    $0x10,%esp
80107b81:	31 c0                	xor    %eax,%eax
}
80107b83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b86:	5b                   	pop    %ebx
80107b87:	5e                   	pop    %esi
80107b88:	5f                   	pop    %edi
80107b89:	5d                   	pop    %ebp
80107b8a:	c3                   	ret    
80107b8b:	90                   	nop
80107b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b96:	5b                   	pop    %ebx
80107b97:	5e                   	pop    %esi
80107b98:	5f                   	pop    %edi
80107b99:	5d                   	pop    %ebp
80107b9a:	c3                   	ret    
80107b9b:	90                   	nop
80107b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107ba0:	83 ec 0c             	sub    $0xc,%esp
80107ba3:	56                   	push   %esi
80107ba4:	e8 47 a7 ff ff       	call   801022f0 <kfree>
      goto bad;
80107ba9:	83 c4 10             	add    $0x10,%esp
80107bac:	eb c5                	jmp    80107b73 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80107bae:	31 c0                	xor    %eax,%eax
80107bb0:	eb d1                	jmp    80107b83 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107bb2:	83 ec 0c             	sub    $0xc,%esp
80107bb5:	68 1e 87 10 80       	push   $0x8010871e
80107bba:	e8 b1 87 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107bbf:	83 ec 0c             	sub    $0xc,%esp
80107bc2:	68 04 87 10 80       	push   $0x80108704
80107bc7:	e8 a4 87 ff ff       	call   80100370 <panic>
80107bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107bd0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107bd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107bd1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107bd3:	89 e5                	mov    %esp,%ebp
80107bd5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bde:	e8 3d f7 ff ff       	call   80107320 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107be3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107be5:	89 c2                	mov    %eax,%edx
80107be7:	83 e2 05             	and    $0x5,%edx
80107bea:	83 fa 05             	cmp    $0x5,%edx
80107bed:	75 11                	jne    80107c00 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107bef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107bf4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107bf5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107bfa:	c3                   	ret    
80107bfb:	90                   	nop
80107bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107c00:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107c02:	c9                   	leave  
80107c03:	c3                   	ret    
80107c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c10 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107c10:	55                   	push   %ebp
80107c11:	89 e5                	mov    %esp,%ebp
80107c13:	57                   	push   %edi
80107c14:	56                   	push   %esi
80107c15:	53                   	push   %ebx
80107c16:	83 ec 1c             	sub    $0x1c,%esp
80107c19:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107c22:	85 db                	test   %ebx,%ebx
80107c24:	75 40                	jne    80107c66 <copyout+0x56>
80107c26:	eb 70                	jmp    80107c98 <copyout+0x88>
80107c28:	90                   	nop
80107c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107c30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c33:	89 f1                	mov    %esi,%ecx
80107c35:	29 d1                	sub    %edx,%ecx
80107c37:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107c3d:	39 d9                	cmp    %ebx,%ecx
80107c3f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107c42:	29 f2                	sub    %esi,%edx
80107c44:	83 ec 04             	sub    $0x4,%esp
80107c47:	01 d0                	add    %edx,%eax
80107c49:	51                   	push   %ecx
80107c4a:	57                   	push   %edi
80107c4b:	50                   	push   %eax
80107c4c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107c4f:	e8 8c d5 ff ff       	call   801051e0 <memmove>
    len -= n;
    buf += n;
80107c54:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107c57:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80107c5a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107c60:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107c62:	29 cb                	sub    %ecx,%ebx
80107c64:	74 32                	je     80107c98 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107c66:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107c68:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107c6b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107c6e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107c74:	56                   	push   %esi
80107c75:	ff 75 08             	pushl  0x8(%ebp)
80107c78:	e8 53 ff ff ff       	call   80107bd0 <uva2ka>
    if(pa0 == 0)
80107c7d:	83 c4 10             	add    $0x10,%esp
80107c80:	85 c0                	test   %eax,%eax
80107c82:	75 ac                	jne    80107c30 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107c8c:	5b                   	pop    %ebx
80107c8d:	5e                   	pop    %esi
80107c8e:	5f                   	pop    %edi
80107c8f:	5d                   	pop    %ebp
80107c90:	c3                   	ret    
80107c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107c9b:	31 c0                	xor    %eax,%eax
}
80107c9d:	5b                   	pop    %ebx
80107c9e:	5e                   	pop    %esi
80107c9f:	5f                   	pop    %edi
80107ca0:	5d                   	pop    %ebp
80107ca1:	c3                   	ret    
