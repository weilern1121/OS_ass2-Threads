
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
8010004c:	68 60 78 10 80       	push   $0x80107860
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 15 4a 00 00       	call   80104a70 <initlock>

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
80100092:	68 67 78 10 80       	push   $0x80107867
80100097:	50                   	push   %eax
80100098:	e8 a3 48 00 00       	call   80104940 <initsleeplock>
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
801000e4:	e8 e7 4a 00 00       	call   80104bd0 <acquire>

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
80100162:	e8 19 4b 00 00       	call   80104c80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 48 00 00       	call   80104980 <acquiresleep>
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
80100193:	68 6e 78 10 80       	push   $0x8010786e
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
801001ae:	e8 6d 48 00 00       	call   80104a20 <holdingsleep>
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
801001cc:	68 7f 78 10 80       	push   $0x8010787f
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
801001ef:	e8 2c 48 00 00       	call   80104a20 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 47 00 00       	call   801049e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 c0 49 00 00       	call   80104bd0 <acquire>
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
8010025c:	e9 1f 4a 00 00       	jmp    80104c80 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 78 10 80       	push   $0x80107886
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
8010028c:	e8 3f 49 00 00       	call   80104bd0 <acquire>
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
801002bd:	e8 1e 3c 00 00       	call   80103ee0 <sleep>

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
801002d2:	e8 b9 35 00 00       	call   80103890 <myproc>
801002d7:	8b 40 1c             	mov    0x1c(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 95 49 00 00       	call   80104c80 <release>
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
80100346:	e8 35 49 00 00       	call   80104c80 <release>
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
80100392:	68 8d 78 10 80       	push   $0x8010788d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 87 82 10 80 	movl   $0x80108287,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 d3 46 00 00       	call   80104a90 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 a1 78 10 80       	push   $0x801078a1
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
8010041a:	e8 f1 5f 00 00       	call   80106410 <uartputc>
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
801004d3:	e8 38 5f 00 00       	call   80106410 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 2c 5f 00 00       	call   80106410 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 20 5f 00 00       	call   80106410 <uartputc>
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
80100514:	e8 77 48 00 00       	call   80104d90 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 b2 47 00 00       	call   80104ce0 <memset>
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
80100540:	68 a5 78 10 80       	push   $0x801078a5
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
801005b1:	0f b6 92 d0 78 10 80 	movzbl -0x7fef8730(%edx),%edx
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
8010061b:	e8 b0 45 00 00       	call   80104bd0 <acquire>
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
80100647:	e8 34 46 00 00       	call   80104c80 <release>
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
8010070d:	e8 6e 45 00 00       	call   80104c80 <release>
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
80100788:	b8 b8 78 10 80       	mov    $0x801078b8,%eax
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
801007c8:	e8 03 44 00 00       	call   80104bd0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 bf 78 10 80       	push   $0x801078bf
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
80100803:	e8 c8 43 00 00       	call   80104bd0 <acquire>
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
80100868:	e8 13 44 00 00       	call   80104c80 <release>
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
801008f6:	e8 e5 3a 00 00       	call   801043e0 <wakeup>
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
80100977:	e9 c4 3b 00 00       	jmp    80104540 <procdump>
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
801009a6:	68 c8 78 10 80       	push   $0x801078c8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 bb 40 00 00       	call   80104a70 <initlock>

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
801009fc:	e8 8f 2e 00 00       	call   80103890 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
    struct  thread *curthread = mythread();
80100a07:	e8 b4 2e 00 00       	call   801038c0 <mythread>
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
80100a7c:	e8 2f 6b 00 00       	call   801075b0 <setupkvm>
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
80100b0c:	e8 ef 68 00 00       	call   80107400 <allocuvm>
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
80100b42:	e8 f9 67 00 00       	call   80107340 <loaduvm>
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
80100b61:	e8 ca 69 00 00       	call   80107530 <freevm>
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
80100b9d:	e8 5e 68 00 00       	call   80107400 <allocuvm>
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
80100bb4:	e8 77 69 00 00       	call   80107530 <freevm>
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
80100bce:	68 e1 78 10 80       	push   $0x801078e1
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
80100bf9:	e8 52 6a 00 00       	call   80107650 <clearpteu>
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
80100c29:	e8 f2 42 00 00       	call   80104f20 <strlen>
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
80100c3c:	e8 df 42 00 00       	call   80104f20 <strlen>
80100c41:	83 c0 01             	add    $0x1,%eax
80100c44:	50                   	push   %eax
80100c45:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c48:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4b:	53                   	push   %ebx
80100c4c:	56                   	push   %esi
80100c4d:	e8 6e 6b 00 00       	call   801077c0 <copyout>
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
80100cb7:	e8 04 6b 00 00       	call   801077c0 <copyout>
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
80100cfc:	e8 df 41 00 00       	call   80104ee0 <safestrcpy>

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
80100d35:	e8 96 32 00 00       	call   80103fd0 <cleanProcOneThread>
    curproc->mainThread=curthread;
80100d3a:	89 f0                	mov    %esi,%eax
80100d3c:	89 98 b4 03 00 00    	mov    %ebx,0x3b4(%eax)

    switchuvm(curproc);
80100d42:	89 34 24             	mov    %esi,(%esp)
80100d45:	e8 56 64 00 00       	call   801071a0 <switchuvm>
    freevm(oldpgdir);
80100d4a:	89 3c 24             	mov    %edi,(%esp)
80100d4d:	e8 de 67 00 00       	call   80107530 <freevm>
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
80100d66:	68 ed 78 10 80       	push   $0x801078ed
80100d6b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d70:	e8 fb 3c 00 00       	call   80104a70 <initlock>
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
80100d91:	e8 3a 3e 00 00       	call   80104bd0 <acquire>
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
80100dc1:	e8 ba 3e 00 00       	call   80104c80 <release>
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
80100dd8:	e8 a3 3e 00 00       	call   80104c80 <release>
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
80100dff:	e8 cc 3d 00 00       	call   80104bd0 <acquire>
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
80100e1c:	e8 5f 3e 00 00       	call   80104c80 <release>
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
80100e2b:	68 f4 78 10 80       	push   $0x801078f4
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
80100e51:	e8 7a 3d 00 00       	call   80104bd0 <acquire>
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
80100e7c:	e9 ff 3d 00 00       	jmp    80104c80 <release>
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
80100ea8:	e8 d3 3d 00 00       	call   80104c80 <release>

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
80100f02:	68 fc 78 10 80       	push   $0x801078fc
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
80100fe2:	68 06 79 10 80       	push   $0x80107906
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
801010f4:	68 0f 79 10 80       	push   $0x8010790f
801010f9:	e8 72 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010fe:	83 ec 0c             	sub    $0xc,%esp
80101101:	68 15 79 10 80       	push   $0x80107915
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
801011b2:	68 1f 79 10 80       	push   $0x8010791f
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
801011f5:	e8 e6 3a 00 00       	call   80104ce0 <memset>
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
8010123a:	e8 91 39 00 00       	call   80104bd0 <acquire>
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
80101282:	e8 f9 39 00 00       	call   80104c80 <release>
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
801012cf:	e8 ac 39 00 00       	call   80104c80 <release>

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
801012e4:	68 35 79 10 80       	push   $0x80107935
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
801013aa:	68 45 79 10 80       	push   $0x80107945
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
801013e1:	e8 aa 39 00 00       	call   80104d90 <memmove>
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
80101476:	68 58 79 10 80       	push   $0x80107958
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
8010148c:	68 6b 79 10 80       	push   $0x8010796b
80101491:	68 00 1a 11 80       	push   $0x80111a00
80101496:	e8 d5 35 00 00       	call   80104a70 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 72 79 10 80       	push   $0x80107972
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 8c 34 00 00       	call   80104940 <initsleeplock>
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
801014f9:	68 d8 79 10 80       	push   $0x801079d8
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
8010158e:	e8 4d 37 00 00       	call   80104ce0 <memset>
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
801015c3:	68 78 79 10 80       	push   $0x80107978
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
80101631:	e8 5a 37 00 00       	call   80104d90 <memmove>
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
8010165f:	e8 6c 35 00 00       	call   80104bd0 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010166f:	e8 0c 36 00 00       	call   80104c80 <release>
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
801016a2:	e8 d9 32 00 00       	call   80104980 <acquiresleep>

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
80101718:	e8 73 36 00 00       	call   80104d90 <memmove>
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
8010173d:	68 90 79 10 80       	push   $0x80107990
80101742:	e8 29 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 8a 79 10 80       	push   $0x8010798a
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
80101773:	e8 a8 32 00 00       	call   80104a20 <holdingsleep>
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
8010178f:	e9 4c 32 00 00       	jmp    801049e0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 9f 79 10 80       	push   $0x8010799f
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
801017c0:	e8 bb 31 00 00       	call   80104980 <acquiresleep>
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
801017da:	e8 01 32 00 00       	call   801049e0 <releasesleep>

  acquire(&icache.lock);
801017df:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017e6:	e8 e5 33 00 00       	call   80104bd0 <acquire>
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
80101800:	e9 7b 34 00 00       	jmp    80104c80 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 00 1a 11 80       	push   $0x80111a00
80101810:	e8 bb 33 00 00       	call   80104bd0 <acquire>
    int r = ip->ref;
80101815:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101818:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010181f:	e8 5c 34 00 00       	call   80104c80 <release>
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
80101a08:	e8 83 33 00 00       	call   80104d90 <memmove>
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
80101b04:	e8 87 32 00 00       	call   80104d90 <memmove>
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
80101b9e:	e8 6d 32 00 00       	call   80104e10 <strncmp>
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
80101c05:	e8 06 32 00 00       	call   80104e10 <strncmp>
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
80101c3d:	68 b9 79 10 80       	push   $0x801079b9
80101c42:	e8 29 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c47:	83 ec 0c             	sub    $0xc,%esp
80101c4a:	68 a7 79 10 80       	push   $0x801079a7
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
80101c79:	e8 12 1c 00 00       	call   80103890 <myproc>
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
80101c89:	e8 42 2f 00 00       	call   80104bd0 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c99:	e8 e2 2f 00 00       	call   80104c80 <release>
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
80101cf5:	e8 96 30 00 00       	call   80104d90 <memmove>
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
80101d84:	e8 07 30 00 00       	call   80104d90 <memmove>
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
80101e6d:	e8 0e 30 00 00       	call   80104e80 <strncpy>
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
80101eab:	68 c8 79 10 80       	push   $0x801079c8
80101eb0:	e8 bb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	68 6e 80 10 80       	push   $0x8010806e
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
80101fc0:	68 34 7a 10 80       	push   $0x80107a34
80101fc5:	e8 a6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fca:	83 ec 0c             	sub    $0xc,%esp
80101fcd:	68 2b 7a 10 80       	push   $0x80107a2b
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
80101fe6:	68 46 7a 10 80       	push   $0x80107a46
80101feb:	68 80 b5 10 80       	push   $0x8010b580
80101ff0:	e8 7b 2a 00 00       	call   80104a70 <initlock>
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
8010206e:	e8 5d 2b 00 00       	call   80104bd0 <acquire>

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
8010209e:	e8 3d 23 00 00       	call   801043e0 <wakeup>

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
801020bc:	e8 bf 2b 00 00       	call   80104c80 <release>
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
8010210e:	e8 0d 29 00 00       	call   80104a20 <holdingsleep>
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
80102148:	e8 83 2a 00 00       	call   80104bd0 <acquire>

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
80102199:	e8 42 1d 00 00       	call   80103ee0 <sleep>
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
801021b6:	e9 c5 2a 00 00       	jmp    80104c80 <release>

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
801021ce:	68 4a 7a 10 80       	push   $0x80107a4a
801021d3:	e8 98 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021d8:	83 ec 0c             	sub    $0xc,%esp
801021db:	68 75 7a 10 80       	push   $0x80107a75
801021e0:	e8 8b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021e5:	83 ec 0c             	sub    $0xc,%esp
801021e8:	68 60 7a 10 80       	push   $0x80107a60
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
8010224a:	68 94 7a 10 80       	push   $0x80107a94
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
80102302:	81 fb e8 34 12 80    	cmp    $0x801234e8,%ebx
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
80102322:	e8 b9 29 00 00       	call   80104ce0 <memset>

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
8010235b:	e9 20 29 00 00       	jmp    80104c80 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 60 36 11 80       	push   $0x80113660
80102368:	e8 63 28 00 00       	call   80104bd0 <acquire>
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	eb c2                	jmp    80102334 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102372:	83 ec 0c             	sub    $0xc,%esp
80102375:	68 c6 7a 10 80       	push   $0x80107ac6
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
801023db:	68 cc 7a 10 80       	push   $0x80107acc
801023e0:	68 60 36 11 80       	push   $0x80113660
801023e5:	e8 86 26 00 00       	call   80104a70 <initlock>

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
801024ce:	e8 ad 27 00 00       	call   80104c80 <release>
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
801024e8:	e8 e3 26 00 00       	call   80104bd0 <acquire>
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
80102546:	0f b6 82 00 7c 10 80 	movzbl -0x7fef8400(%edx),%eax
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
8010256e:	0f b6 82 00 7c 10 80 	movzbl -0x7fef8400(%edx),%eax
80102575:	09 c1                	or     %eax,%ecx
80102577:	0f b6 82 00 7b 10 80 	movzbl -0x7fef8500(%edx),%eax
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
8010258e:	8b 04 85 e0 7a 10 80 	mov    -0x7fef8520(,%eax,4),%eax
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
801028f4:	e8 37 24 00 00       	call   80104d30 <memcmp>
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
80102a24:	e8 67 23 00 00       	call   80104d90 <memmove>
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
80102aca:	68 00 7d 10 80       	push   $0x80107d00
80102acf:	68 a0 36 11 80       	push   $0x801136a0
80102ad4:	e8 97 1f 00 00       	call   80104a70 <initlock>
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
80102b6b:	e8 60 20 00 00       	call   80104bd0 <acquire>
80102b70:	83 c4 10             	add    $0x10,%esp
80102b73:	eb 18                	jmp    80102b8d <begin_op+0x2d>
80102b75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b78:	83 ec 08             	sub    $0x8,%esp
80102b7b:	68 a0 36 11 80       	push   $0x801136a0
80102b80:	68 a0 36 11 80       	push   $0x801136a0
80102b85:	e8 56 13 00 00       	call   80103ee0 <sleep>
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
80102bbc:	e8 bf 20 00 00       	call   80104c80 <release>
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
80102bde:	e8 ed 1f 00 00       	call   80104bd0 <acquire>
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
80102c1d:	e8 5e 20 00 00       	call   80104c80 <release>
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
80102c7c:	e8 0f 21 00 00       	call   80104d90 <memmove>
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
80102cc5:	e8 06 1f 00 00       	call   80104bd0 <acquire>
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
80102cdb:	e8 00 17 00 00       	call   801043e0 <wakeup>
    release(&log.lock);
80102ce0:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102ce7:	e8 94 1f 00 00       	call   80104c80 <release>
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
80102d08:	e8 d3 16 00 00       	call   801043e0 <wakeup>
  }
  release(&log.lock);
80102d0d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d14:	e8 67 1f 00 00       	call   80104c80 <release>
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
80102d27:	68 04 7d 10 80       	push   $0x80107d04
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
80102d7e:	e8 4d 1e 00 00       	call   80104bd0 <acquire>
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
80102dce:	e9 ad 1e 00 00       	jmp    80104c80 <release>
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
80102df3:	68 13 7d 10 80       	push   $0x80107d13
80102df8:	e8 73 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dfd:	83 ec 0c             	sub    $0xc,%esp
80102e00:	68 29 7d 10 80       	push   $0x80107d29
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
80102e17:	e8 54 0a 00 00       	call   80103870 <cpuid>
80102e1c:	89 c3                	mov    %eax,%ebx
80102e1e:	e8 4d 0a 00 00       	call   80103870 <cpuid>
80102e23:	83 ec 04             	sub    $0x4,%esp
80102e26:	53                   	push   %ebx
80102e27:	50                   	push   %eax
80102e28:	68 44 7d 10 80       	push   $0x80107d44
80102e2d:	e8 2e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e32:	e8 29 32 00 00       	call   80106060 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e37:	e8 b4 09 00 00       	call   801037f0 <mycpu>
80102e3c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e3e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e43:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e4a:	e8 41 0e 00 00       	call   80103c90 <scheduler>
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
80102e56:	e8 25 43 00 00       	call   80107180 <switchkvm>
  seginit();
80102e5b:	e8 20 42 00 00       	call   80107080 <seginit>
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
80102e8c:	68 e8 34 12 80       	push   $0x801234e8
80102e91:	e8 3a f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e96:	e8 95 47 00 00       	call   80107630 <kvmalloc>
  mpinit();        // detect other processors
80102e9b:	e8 70 01 00 00       	call   80103010 <mpinit>
  lapicinit();     // interrupt controller
80102ea0:	e8 5b f7 ff ff       	call   80102600 <lapicinit>
  seginit();       // segment descriptors
80102ea5:	e8 d6 41 00 00       	call   80107080 <seginit>
  picinit();       // disable pic
80102eaa:	e8 31 03 00 00       	call   801031e0 <picinit>
  ioapicinit();    // another interrupt controller
80102eaf:	e8 4c f3 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102eb4:	e8 e7 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102eb9:	e8 92 34 00 00       	call   80106350 <uartinit>
  pinit();         // process table
80102ebe:	e8 8d 08 00 00       	call   80103750 <pinit>
  tvinit();        // trap vectors
80102ec3:	e8 f8 30 00 00       	call   80105fc0 <tvinit>
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
80102ee9:	e8 a2 1e 00 00       	call   80104d90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102eee:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80102ef5:	00 00 00 
80102ef8:	83 c4 10             	add    $0x10,%esp
80102efb:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f00:	39 d8                	cmp    %ebx,%eax
80102f02:	76 6f                	jbe    80102f73 <main+0x103>
80102f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f08:	e8 e3 08 00 00       	call   801037f0 <mycpu>
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
80102f85:	e8 66 09 00 00       	call   801038f0 <userinit>
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
80102fb8:	68 58 7d 10 80       	push   $0x80107d58
80102fbd:	56                   	push   %esi
80102fbe:	e8 6d 1d 00 00       	call   80104d30 <memcmp>
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
8010307c:	68 5d 7d 10 80       	push   $0x80107d5d
80103081:	56                   	push   %esi
80103082:	e8 a9 1c 00 00       	call   80104d30 <memcmp>
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
80103110:	ff 24 95 9c 7d 10 80 	jmp    *-0x7fef8264(,%edx,4)
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
801031b7:	68 62 7d 10 80       	push   $0x80107d62
801031bc:	e8 af d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031c1:	83 ec 0c             	sub    $0xc,%esp
801031c4:	68 7c 7d 10 80       	push   $0x80107d7c
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
80103273:	68 b0 7d 10 80       	push   $0x80107db0
80103278:	50                   	push   %eax
80103279:	e8 f2 17 00 00       	call   80104a70 <initlock>
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
8010330f:	e8 bc 18 00 00       	call   80104bd0 <acquire>
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
8010332f:	e8 ac 10 00 00       	call   801043e0 <wakeup>
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
80103354:	e9 27 19 00 00       	jmp    80104c80 <release>
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
80103374:	e8 67 10 00 00       	call   801043e0 <wakeup>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	eb b9                	jmp    80103337 <pipeclose+0x37>
8010337e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	53                   	push   %ebx
80103384:	e8 f7 18 00 00       	call   80104c80 <release>
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
801033ad:	e8 1e 18 00 00       	call   80104bd0 <acquire>
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
801033f0:	e8 9b 04 00 00       	call   80103890 <myproc>
801033f5:	8b 48 1c             	mov    0x1c(%eax),%ecx
801033f8:	85 c9                	test   %ecx,%ecx
801033fa:	75 34                	jne    80103430 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033fc:	83 ec 0c             	sub    $0xc,%esp
801033ff:	57                   	push   %edi
80103400:	e8 db 0f 00 00       	call   801043e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103405:	58                   	pop    %eax
80103406:	5a                   	pop    %edx
80103407:	53                   	push   %ebx
80103408:	56                   	push   %esi
80103409:	e8 d2 0a 00 00       	call   80103ee0 <sleep>
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
80103434:	e8 47 18 00 00       	call   80104c80 <release>
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
80103483:	e8 58 0f 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
80103488:	89 1c 24             	mov    %ebx,(%esp)
8010348b:	e8 f0 17 00 00       	call   80104c80 <release>
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
801034b0:	e8 1b 17 00 00       	call   80104bd0 <acquire>
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
801034e5:	e8 f6 09 00 00       	call   80103ee0 <sleep>
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
80103509:	e8 82 03 00 00       	call   80103890 <myproc>
8010350e:	8b 48 1c             	mov    0x1c(%eax),%ecx
80103511:	85 c9                	test   %ecx,%ecx
80103513:	74 cb                	je     801034e0 <piperead+0x40>
      release(&p->lock);
80103515:	83 ec 0c             	sub    $0xc,%esp
80103518:	53                   	push   %ebx
80103519:	e8 62 17 00 00       	call   80104c80 <release>
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
8010357e:	e8 5d 0e 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
80103583:	89 1c 24             	mov    %ebx,(%esp)
80103586:	e8 f5 16 00 00       	call   80104c80 <release>
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
801035d1:	68 b5 7d 10 80       	push   $0x80107db5
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
801035e1:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
    if (DEBUGMODE > 0)
        cprintf(" ALLOCPROC ");
    struct proc *p;
    struct thread *t;
    char *sp;
    acquire(&ptable.lock);
801035e6:	68 60 3d 11 80       	push   $0x80113d60
801035eb:	e8 e0 15 00 00       	call   80104bd0 <acquire>
801035f0:	83 c4 10             	add    $0x10,%esp
801035f3:	eb 11                	jmp    80103606 <allocproc+0x46>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035f8:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
801035fe:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
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
8010360d:	a1 08 b0 10 80       	mov    0x8010b008,%eax
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
8010362d:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
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
80103651:	68 60 3d 11 80       	push   $0x80113d60
80103656:	e8 25 16 00 00       	call   80104c80 <release>
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
80103670:	a1 04 b0 10 80       	mov    0x8010b004,%eax
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
80103688:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
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
801036ab:	c7 40 14 af 5f 10 80 	movl   $0x80105faf,0x14(%eax)

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
801036b2:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
801036b5:	6a 14                	push   $0x14
801036b7:	6a 00                	push   $0x0
801036b9:	50                   	push   %eax
801036ba:	e8 21 16 00 00       	call   80104ce0 <memset>
    t->context->eip = (uint) forkret;
801036bf:	8b 46 14             	mov    0x14(%esi),%eax
801036c2:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)
    release(&ptable.lock);
801036c9:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801036d0:	e8 ab 15 00 00       	call   80104c80 <release>
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
80103706:	68 60 3d 11 80       	push   $0x80113d60
8010370b:	e8 70 15 00 00       	call   80104c80 <release>

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
80103756:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
8010375b:	85 c0                	test   %eax,%eax
8010375d:	7e 10                	jle    8010376f <pinit+0x1f>
        cprintf(" PINIT ");
8010375f:	83 ec 0c             	sub    $0xc,%esp
80103762:	68 c1 7d 10 80       	push   $0x80107dc1
80103767:	e8 f4 ce ff ff       	call   80100660 <cprintf>
8010376c:	83 c4 10             	add    $0x10,%esp
    //struct spinlock *l;
    initlock(&ptable.lock, "ptable");
8010376f:	83 ec 08             	sub    $0x8,%esp
80103772:	68 c9 7d 10 80       	push   $0x80107dc9
80103777:	68 60 3d 11 80       	push   $0x80113d60
8010377c:	e8 ef 12 00 00       	call   80104a70 <initlock>
    //for (l = ptable.tlocks; l < &ptable.tlocks[NPROC]; l++)
    //initlock(l, "ttable");

}
80103781:	83 c4 10             	add    $0x10,%esp
80103784:	c9                   	leave  
80103785:	c3                   	ret    
80103786:	8d 76 00             	lea    0x0(%esi),%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103790 <cleanThread>:

//must be called under acquire(&ptable.lock); !!
void
cleanThread(struct thread *t) {
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 10             	sub    $0x10,%esp
80103797:	8b 5d 08             	mov    0x8(%ebp),%ebx
    kfree(t->tkstack);
8010379a:	ff 73 04             	pushl  0x4(%ebx)
8010379d:	e8 4e eb ff ff       	call   801022f0 <kfree>
    t->state = UNUSED;
    t->tid = 0;
    t->name[0] = 0;
    t->killed = 0;
    //clean trap frame and context
    memset(t->tf, 0, sizeof(*t->tf));
801037a2:	83 c4 0c             	add    $0xc,%esp

//must be called under acquire(&ptable.lock); !!
void
cleanThread(struct thread *t) {
    kfree(t->tkstack);
    t->tkstack = 0;
801037a5:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    t->state = UNUSED;
801037ac:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    t->tid = 0;
801037b3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    t->name[0] = 0;
801037ba:	c6 43 20 00          	movb   $0x0,0x20(%ebx)
    t->killed = 0;
801037be:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    //clean trap frame and context
    memset(t->tf, 0, sizeof(*t->tf));
801037c5:	6a 4c                	push   $0x4c
801037c7:	6a 00                	push   $0x0
801037c9:	ff 73 10             	pushl  0x10(%ebx)
801037cc:	e8 0f 15 00 00       	call   80104ce0 <memset>
    memset(t->context, 0, sizeof(*t->context));
801037d1:	83 c4 0c             	add    $0xc,%esp
801037d4:	6a 14                	push   $0x14
801037d6:	6a 00                	push   $0x0
801037d8:	ff 73 14             	pushl  0x14(%ebx)
801037db:	e8 00 15 00 00       	call   80104ce0 <memset>
}
801037e0:	83 c4 10             	add    $0x10,%esp
801037e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037e6:	c9                   	leave  
801037e7:	c3                   	ret    
801037e8:	90                   	nop
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037f0 <mycpu>:
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037f5:	9c                   	pushf  
801037f6:	58                   	pop    %eax
    int apicid, i;

    if (readeflags() & FL_IF)
801037f7:	f6 c4 02             	test   $0x2,%ah
801037fa:	75 5b                	jne    80103857 <mycpu+0x67>
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
801037fc:	e8 ff ee ff ff       	call   80102700 <lapicid>
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103801:	8b 35 40 3d 11 80    	mov    0x80113d40,%esi
80103807:	85 f6                	test   %esi,%esi
80103809:	7e 3f                	jle    8010384a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
8010380b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103812:	39 d0                	cmp    %edx,%eax
80103814:	74 30                	je     80103846 <mycpu+0x56>
80103816:	b9 54 38 11 80       	mov    $0x80113854,%ecx
8010381b:	31 d2                	xor    %edx,%edx
8010381d:	8d 76 00             	lea    0x0(%esi),%esi
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103820:	83 c2 01             	add    $0x1,%edx
80103823:	39 f2                	cmp    %esi,%edx
80103825:	74 23                	je     8010384a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
80103827:	0f b6 19             	movzbl (%ecx),%ebx
8010382a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
80103830:	39 d8                	cmp    %ebx,%eax
80103832:	75 ec                	jne    80103820 <mycpu+0x30>
            return &cpus[i];
80103834:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
    }
    panic("unknown apicid\n");
}
8010383a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010383d:	5b                   	pop    %ebx
    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
8010383e:	05 a0 37 11 80       	add    $0x801137a0,%eax
    }
    panic("unknown apicid\n");
}
80103843:	5e                   	pop    %esi
80103844:	5d                   	pop    %ebp
80103845:	c3                   	ret    
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103846:	31 d2                	xor    %edx,%edx
80103848:	eb ea                	jmp    80103834 <mycpu+0x44>
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
8010384a:	83 ec 0c             	sub    $0xc,%esp
8010384d:	68 d0 7d 10 80       	push   $0x80107dd0
80103852:	e8 19 cb ff ff       	call   80100370 <panic>
struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");
80103857:	83 ec 0c             	sub    $0xc,%esp
8010385a:	68 18 7f 10 80       	push   $0x80107f18
8010385f:	e8 0c cb ff ff       	call   80100370 <panic>
80103864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010386a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103870 <cpuid>:
    release(&ptable.lock);
}

// Must be called with interrupts disabled
int
cpuid() {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103876:	e8 75 ff ff ff       	call   801037f0 <mycpu>
8010387b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103880:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
    return mycpu() - cpus;
80103881:	c1 f8 02             	sar    $0x2,%eax
80103884:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
8010388a:	c3                   	ret    
8010388b:	90                   	nop
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103890 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 04             	sub    $0x4,%esp
    struct cpu *c;
    struct proc *p;
    pushcli();
80103897:	e8 54 12 00 00       	call   80104af0 <pushcli>
    c = mycpu();
8010389c:	e8 4f ff ff ff       	call   801037f0 <mycpu>
    p = c->proc;
801038a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801038a7:	e8 84 12 00 00       	call   80104b30 <popcli>
    return p;
}
801038ac:	83 c4 04             	add    $0x4,%esp
801038af:	89 d8                	mov    %ebx,%eax
801038b1:	5b                   	pop    %ebx
801038b2:	5d                   	pop    %ebp
801038b3:	c3                   	ret    
801038b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038c0 <mythread>:


// Disable interrupts so that we are not rescheduled
// while reading thread from the cpu structure
struct thread *
mythread(void) {
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
801038c4:	83 ec 04             	sub    $0x4,%esp
    struct cpu *c;
    struct thread *t;
    pushcli();
801038c7:	e8 24 12 00 00       	call   80104af0 <pushcli>
    c = mycpu();
801038cc:	e8 1f ff ff ff       	call   801037f0 <mycpu>
    t = c->currThread;
801038d1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801038d7:	e8 54 12 00 00       	call   80104b30 <popcli>
    return t;
}
801038dc:	83 c4 04             	add    $0x4,%esp
801038df:	89 d8                	mov    %ebx,%eax
801038e1:	5b                   	pop    %ebx
801038e2:	5d                   	pop    %ebp
801038e3:	c3                   	ret    
801038e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038f0 <userinit>:
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 04             	sub    $0x4,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
801038f7:	e8 c4 fc ff ff       	call   801035c0 <allocproc>
801038fc:	89 c3                	mov    %eax,%ebx
    initproc = p;
801038fe:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
    if ((p->pgdir = setupkvm()) == 0)
80103903:	e8 a8 3c 00 00       	call   801075b0 <setupkvm>
80103908:	85 c0                	test   %eax,%eax
8010390a:	89 43 04             	mov    %eax,0x4(%ebx)
8010390d:	0f 84 2d 01 00 00    	je     80103a40 <userinit+0x150>
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103913:	83 ec 04             	sub    $0x4,%esp
80103916:	68 2c 00 00 00       	push   $0x2c
8010391b:	68 60 b4 10 80       	push   $0x8010b460
80103920:	50                   	push   %eax
80103921:	e8 9a 39 00 00       	call   801072c0 <inituvm>
    p->sz = PGSIZE;
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
80103926:	83 c4 0c             	add    $0xc,%esp
    p = allocproc();
    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
80103929:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
8010392f:	6a 4c                	push   $0x4c
80103931:	6a 00                	push   $0x0
80103933:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103939:	ff 70 10             	pushl  0x10(%eax)
8010393c:	e8 9f 13 00 00       	call   80104ce0 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103941:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103947:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010394c:	b9 23 00 00 00       	mov    $0x23,%ecx
    p->mainThread->tf->ss = p->mainThread->tf->ds;
    p->mainThread->tf->eflags = FL_IF;
    p->mainThread->tf->esp = PGSIZE;
    p->mainThread->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103951:	83 c4 0c             	add    $0xc,%esp
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103954:	8b 40 10             	mov    0x10(%eax),%eax
80103957:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010395b:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103961:	8b 40 10             	mov    0x10(%eax),%eax
80103964:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
80103968:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
8010396e:	8b 40 10             	mov    0x10(%eax),%eax
80103971:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103975:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
80103979:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
8010397f:	8b 40 10             	mov    0x10(%eax),%eax
80103982:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103986:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
8010398a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103990:	8b 40 10             	mov    0x10(%eax),%eax
80103993:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
8010399a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039a0:	8b 40 10             	mov    0x10(%eax),%eax
801039a3:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
801039aa:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039b0:	8b 40 10             	mov    0x10(%eax),%eax
801039b3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
801039ba:	8d 43 64             	lea    0x64(%ebx),%eax
801039bd:	6a 10                	push   $0x10
801039bf:	68 f9 7d 10 80       	push   $0x80107df9
801039c4:	50                   	push   %eax
801039c5:	e8 16 15 00 00       	call   80104ee0 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
801039ca:	83 c4 0c             	add    $0xc,%esp
801039cd:	6a 10                	push   $0x10
801039cf:	68 02 7e 10 80       	push   $0x80107e02
801039d4:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039da:	83 c0 20             	add    $0x20,%eax
801039dd:	50                   	push   %eax
801039de:	e8 fd 14 00 00       	call   80104ee0 <safestrcpy>
    p->cwd = namei("/");
801039e3:	c7 04 24 0d 7e 10 80 	movl   $0x80107e0d,(%esp)
801039ea:	e8 e1 e4 ff ff       	call   80101ed0 <namei>
801039ef:	89 43 60             	mov    %eax,0x60(%ebx)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
801039f2:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801039f9:	e8 d2 11 00 00       	call   80104bd0 <acquire>
    //acquire(p->procLock);

    p->state = RUNNABLE;
    p->mainThread->state = RUNNABLE;
801039fe:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
    //acquire(p->procLock);

    p->state = RUNNABLE;
80103a04:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103a0b:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)

    //release(p->procLock);
    release(&ptable.lock);
80103a12:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103a19:	e8 62 12 00 00       	call   80104c80 <release>
    if (DEBUGMODE > 0)
80103a1e:	8b 1d b8 b5 10 80    	mov    0x8010b5b8,%ebx
80103a24:	83 c4 10             	add    $0x10,%esp
80103a27:	85 db                	test   %ebx,%ebx
80103a29:	7e 10                	jle    80103a3b <userinit+0x14b>
        cprintf("DONE USERINIT");
80103a2b:	83 ec 0c             	sub    $0xc,%esp
80103a2e:	68 0f 7e 10 80       	push   $0x80107e0f
80103a33:	e8 28 cc ff ff       	call   80100660 <cprintf>
80103a38:	83 c4 10             	add    $0x10,%esp

}
80103a3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3e:	c9                   	leave  
80103a3f:	c3                   	ret    
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	68 e0 7d 10 80       	push   $0x80107de0
80103a48:	e8 23 c9 ff ff       	call   80100370 <panic>
80103a4d:	8d 76 00             	lea    0x0(%esi),%esi

80103a50 <growproc>:
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
80103a55:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103a58:	e8 93 10 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80103a5d:	e8 8e fd ff ff       	call   801037f0 <mycpu>
    p = c->proc;
80103a62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103a68:	e8 c3 10 00 00       	call   80104b30 <popcli>
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();
    if (DEBUGMODE > 0)
80103a6d:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103a72:	85 c0                	test   %eax,%eax
80103a74:	7e 10                	jle    80103a86 <growproc+0x36>
        cprintf(" GROWPROC APPLYED ");
80103a76:	83 ec 0c             	sub    $0xc,%esp
80103a79:	68 1d 7e 10 80       	push   $0x80107e1d
80103a7e:	e8 dd cb ff ff       	call   80100660 <cprintf>
80103a83:	83 c4 10             	add    $0x10,%esp

    sz = curproc->sz;
    if (n > 0) {
80103a86:	83 fe 00             	cmp    $0x0,%esi
    uint sz;
    struct proc *curproc = myproc();
    if (DEBUGMODE > 0)
        cprintf(" GROWPROC APPLYED ");

    sz = curproc->sz;
80103a89:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103a8b:	7e 33                	jle    80103ac0 <growproc+0x70>
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a8d:	83 ec 04             	sub    $0x4,%esp
80103a90:	01 c6                	add    %eax,%esi
80103a92:	56                   	push   %esi
80103a93:	50                   	push   %eax
80103a94:	ff 73 04             	pushl  0x4(%ebx)
80103a97:	e8 64 39 00 00       	call   80107400 <allocuvm>
80103a9c:	83 c4 10             	add    $0x10,%esp
80103a9f:	85 c0                	test   %eax,%eax
80103aa1:	74 3d                	je     80103ae0 <growproc+0x90>
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
    switchuvm(curproc);
80103aa3:	83 ec 0c             	sub    $0xc,%esp
            return -1;
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
80103aa6:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103aa8:	53                   	push   %ebx
80103aa9:	e8 f2 36 00 00       	call   801071a0 <switchuvm>
    return 0;
80103aae:	83 c4 10             	add    $0x10,%esp
80103ab1:	31 c0                	xor    %eax,%eax
}
80103ab3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ab6:	5b                   	pop    %ebx
80103ab7:	5e                   	pop    %esi
80103ab8:	5d                   	pop    %ebp
80103ab9:	c3                   	ret    
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
80103ac0:	74 e1                	je     80103aa3 <growproc+0x53>
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ac2:	83 ec 04             	sub    $0x4,%esp
80103ac5:	01 c6                	add    %eax,%esi
80103ac7:	56                   	push   %esi
80103ac8:	50                   	push   %eax
80103ac9:	ff 73 04             	pushl  0x4(%ebx)
80103acc:	e8 2f 3a 00 00       	call   80107500 <deallocuvm>
80103ad1:	83 c4 10             	add    $0x10,%esp
80103ad4:	85 c0                	test   %eax,%eax
80103ad6:	75 cb                	jne    80103aa3 <growproc+0x53>
80103ad8:	90                   	nop
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" GROWPROC APPLYED ");

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
80103ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ae5:	eb cc                	jmp    80103ab3 <growproc+0x63>
80103ae7:	89 f6                	mov    %esi,%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103af0 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	57                   	push   %edi
80103af4:	56                   	push   %esi
80103af5:	53                   	push   %ebx
80103af6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103af9:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103afe:	85 c0                	test   %eax,%eax
80103b00:	7e 10                	jle    80103b12 <fork+0x22>
        cprintf(" FORK ");
80103b02:	83 ec 0c             	sub    $0xc,%esp
80103b05:	68 30 7e 10 80       	push   $0x80107e30
80103b0a:	e8 51 cb ff ff       	call   80100660 <cprintf>
80103b0f:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103b12:	e8 d9 0f 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80103b17:	e8 d4 fc ff ff       	call   801037f0 <mycpu>
    p = c->proc;
80103b1c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103b22:	89 c7                	mov    %eax,%edi
80103b24:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
80103b27:	e8 04 10 00 00       	call   80104b30 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103b2c:	e8 bf 0f 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80103b31:	e8 ba fc ff ff       	call   801037f0 <mycpu>
    t = c->currThread;
80103b36:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103b3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103b3f:	e8 ec 0f 00 00       	call   80104b30 <popcli>
    struct proc *np;
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    // Allocate process.
    if ((np = allocproc()) == 0) {
80103b44:	e8 77 fa ff ff       	call   801035c0 <allocproc>
80103b49:	85 c0                	test   %eax,%eax
80103b4b:	89 c3                	mov    %eax,%ebx
80103b4d:	0f 84 f1 00 00 00    	je     80103c44 <fork+0x154>
        return -1;
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103b53:	83 ec 08             	sub    $0x8,%esp
80103b56:	ff 37                	pushl  (%edi)
80103b58:	ff 77 04             	pushl  0x4(%edi)
80103b5b:	e8 20 3b 00 00       	call   80107680 <copyuvm>
80103b60:	83 c4 10             	add    $0x10,%esp
80103b63:	85 c0                	test   %eax,%eax
80103b65:	89 43 04             	mov    %eax,0x4(%ebx)
80103b68:	0f 84 dd 00 00 00    	je     80103c4b <fork+0x15b>
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;
80103b71:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b74:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103b76:	89 53 10             	mov    %edx,0x10(%ebx)
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b79:	89 03                	mov    %eax,(%ebx)
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;
80103b7b:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103b81:	8b 71 10             	mov    0x10(%ecx),%esi
80103b84:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b89:	8b 40 10             	mov    0x10(%eax),%eax
80103b8c:	89 c7                	mov    %eax,%edi
80103b8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103b90:	31 f6                	xor    %esi,%esi
80103b92:	89 d7                	mov    %edx,%edi
    np->sz = curproc->sz;
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;
80103b94:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103b9a:	8b 40 10             	mov    0x10(%eax),%eax
80103b9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
80103ba8:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	74 10                	je     80103bc0 <fork+0xd0>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	50                   	push   %eax
80103bb4:	e8 37 d2 ff ff       	call   80100df0 <filedup>
80103bb9:	83 c4 10             	add    $0x10,%esp
80103bbc:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    *np->mainThread->tf = *curthread->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103bc0:	83 c6 01             	add    $0x1,%esi
80103bc3:	83 fe 10             	cmp    $0x10,%esi
80103bc6:	75 e0                	jne    80103ba8 <fork+0xb8>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
//    np->mainThread->cwd = idup(curthread->cwd);
    np->cwd = idup(curproc->cwd);
80103bc8:	8b 7d e0             	mov    -0x20(%ebp),%edi
80103bcb:	83 ec 0c             	sub    $0xc,%esp
80103bce:	ff 77 60             	pushl  0x60(%edi)
80103bd1:	e8 7a da ff ff       	call   80101650 <idup>
80103bd6:	89 43 60             	mov    %eax,0x60(%ebx)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd9:	89 f8                	mov    %edi,%eax
80103bdb:	83 c4 0c             	add    $0xc,%esp
80103bde:	83 c0 64             	add    $0x64,%eax
80103be1:	6a 10                	push   $0x10
80103be3:	50                   	push   %eax
80103be4:	8d 43 64             	lea    0x64(%ebx),%eax
80103be7:	50                   	push   %eax
80103be8:	e8 f3 12 00 00       	call   80104ee0 <safestrcpy>
    //TODO
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103bed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bf0:	83 c4 0c             	add    $0xc,%esp
80103bf3:	6a 10                	push   $0x10
80103bf5:	83 c0 20             	add    $0x20,%eax
80103bf8:	50                   	push   %eax
80103bf9:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103bff:	83 c0 20             	add    $0x20,%eax
80103c02:	50                   	push   %eax
80103c03:	e8 d8 12 00 00       	call   80104ee0 <safestrcpy>

    pid = np->pid;
80103c08:	8b 73 0c             	mov    0xc(%ebx),%esi

    acquire(&ptable.lock);
80103c0b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103c12:	e8 b9 0f 00 00       	call   80104bd0 <acquire>
    //acquire(np->procLock);

    np->state = RUNNABLE;
    //TODO
    np->mainThread->state = RUNNABLE;
80103c17:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
    pid = np->pid;

    acquire(&ptable.lock);
    //acquire(np->procLock);

    np->state = RUNNABLE;
80103c1d:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    //TODO
    np->mainThread->state = RUNNABLE;
80103c24:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)

    //release(np->procLock);
    release(&ptable.lock);
80103c2b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103c32:	e8 49 10 00 00       	call   80104c80 <release>

    return pid;
80103c37:	83 c4 10             	add    $0x10,%esp
80103c3a:	89 f0                	mov    %esi,%eax
}
80103c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c3f:	5b                   	pop    %ebx
80103c40:	5e                   	pop    %esi
80103c41:	5f                   	pop    %edi
80103c42:	5d                   	pop    %ebp
80103c43:	c3                   	ret    
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
80103c44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c49:	eb f1                	jmp    80103c3c <fork+0x14c>
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
80103c4b:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c51:	83 ec 0c             	sub    $0xc,%esp
80103c54:	ff 70 04             	pushl  0x4(%eax)
80103c57:	e8 94 e6 ff ff       	call   801022f0 <kfree>
        np->mainThread->tkstack = 0;
80103c5c:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
80103c62:	83 c4 10             	add    $0x10,%esp
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
        np->mainThread->tkstack = 0;
80103c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
80103c6c:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
80103c72:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103c79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c85:	eb b5                	jmp    80103c3c <fork+0x14c>
80103c87:	89 f6                	mov    %esi,%esi
80103c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c90 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103c99:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103c9e:	85 c0                	test   %eax,%eax
80103ca0:	7e 10                	jle    80103cb2 <scheduler+0x22>
        cprintf(" SCHEDULER ");
80103ca2:	83 ec 0c             	sub    $0xc,%esp
80103ca5:	68 37 7e 10 80       	push   $0x80107e37
80103caa:	e8 b1 c9 ff ff       	call   80100660 <cprintf>
80103caf:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct cpu *c = mycpu();
80103cb2:	e8 39 fb ff ff       	call   801037f0 <mycpu>
    struct thread *t;
    c->proc = 0;
80103cb7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cbe:	00 00 00 
void
scheduler(void) {
    if (DEBUGMODE > 0)
        cprintf(" SCHEDULER ");
    struct proc *p;
    struct cpu *c = mycpu();
80103cc1:	89 c6                	mov    %eax,%esi
80103cc3:	8d 40 04             	lea    0x4(%eax),%eax
80103cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103cd0:	fb                   	sti    
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103cd1:	83 ec 0c             	sub    $0xc,%esp

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103cd4:	bf 94 3d 11 80       	mov    $0x80113d94,%edi
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103cd9:	68 60 3d 11 80       	push   $0x80113d60
80103cde:	e8 ed 0e 00 00       	call   80104bd0 <acquire>
80103ce3:	83 c4 10             	add    $0x10,%esp
80103ce6:	eb 1a                	jmp    80103d02 <scheduler+0x72>
80103ce8:	90                   	nop
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103cf0:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
80103cf6:	81 ff 94 2c 12 80    	cmp    $0x80122c94,%edi
80103cfc:	0f 84 9e 00 00 00    	je     80103da0 <scheduler+0x110>
            if (p->state != RUNNABLE)
80103d02:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d06:	75 e8                	jne    80103cf0 <scheduler+0x60>
            // to release ptable.lock and then reacquire it
            // before jumping back to us.

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
80103d08:	83 ec 0c             	sub    $0xc,%esp
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
80103d0b:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
80103d11:	8d 5f 74             	lea    0x74(%edi),%ebx
            switchuvm(p);
80103d14:	57                   	push   %edi
80103d15:	e8 86 34 00 00       	call   801071a0 <switchuvm>
80103d1a:	8d 97 b4 03 00 00    	lea    0x3b4(%edi),%edx
80103d20:	83 c4 10             	add    $0x10,%esp
80103d23:	eb 0a                	jmp    80103d2f <scheduler+0x9f>
80103d25:	8d 76 00             	lea    0x0(%esi),%esi
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d28:	83 c3 34             	add    $0x34,%ebx
80103d2b:	39 da                	cmp    %ebx,%edx
80103d2d:	76 41                	jbe    80103d70 <scheduler+0xe0>
                if (t->state != RUNNABLE)
80103d2f:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103d33:	75 f3                	jne    80103d28 <scheduler+0x98>
                    continue;

                //cprintf("\n  FOUND TRED TO RUN %d" , t->tid);
                t->state = RUNNING;
80103d35:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d3c:	83 ec 08             	sub    $0x8,%esp
                if (t->state != RUNNABLE)
                    continue;

                //cprintf("\n  FOUND TRED TO RUN %d" , t->tid);
                t->state = RUNNING;
                c->currThread = t;
80103d3f:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d45:	ff 73 14             	pushl  0x14(%ebx)
80103d48:	ff 75 e0             	pushl  -0x20(%ebp)

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d4b:	83 c3 34             	add    $0x34,%ebx
80103d4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d51:	e8 e5 11 00 00       	call   80104f3b <swtch>
                c->currThread = 0;
80103d56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d59:	83 c4 10             	add    $0x10,%esp
80103d5c:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103d63:	00 00 00 

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d66:	39 da                	cmp    %ebx,%edx
80103d68:	77 c5                	ja     80103d2f <scheduler+0x9f>
80103d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d70:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
//                    }
                swtch(&(c->scheduler), t->context);
                c->currThread = 0;

            }
            switchkvm();
80103d76:	e8 05 34 00 00       	call   80107180 <switchkvm>
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d7b:	81 ff 94 2c 12 80    	cmp    $0x80122c94,%edi
//            }


            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80103d81:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d88:	00 00 00 
            c->currThread = 0;
80103d8b:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103d92:	00 00 00 
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d95:	0f 85 67 ff ff ff    	jne    80103d02 <scheduler+0x72>
80103d9b:	90                   	nop
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            // It should have changed its p->state before coming back.
            c->proc = 0;
            c->currThread = 0;

        }
        release(&ptable.lock);
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	68 60 3d 11 80       	push   $0x80113d60
80103da8:	e8 d3 0e 00 00       	call   80104c80 <release>

    }
80103dad:	83 c4 10             	add    $0x10,%esp
80103db0:	e9 1b ff ff ff       	jmp    80103cd0 <scheduler+0x40>
80103db5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dc0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
    if (DEBUGMODE > 1)
80103dc0:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
80103dc7:	55                   	push   %ebp
80103dc8:	89 e5                	mov    %esp,%ebp
80103dca:	56                   	push   %esi
80103dcb:	53                   	push   %ebx
    if (DEBUGMODE > 1)
80103dcc:	7e 10                	jle    80103dde <sched+0x1e>
        cprintf(" SCHED ");
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	68 43 7e 10 80       	push   $0x80107e43
80103dd6:	e8 85 c8 ff ff       	call   80100660 <cprintf>
80103ddb:	83 c4 10             	add    $0x10,%esp
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103dde:	e8 0d 0d 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80103de3:	e8 08 fa ff ff       	call   801037f0 <mycpu>
    t = c->currThread;
80103de8:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103dee:	e8 3d 0d 00 00       	call   80104b30 <popcli>
        cprintf(" SCHED ");
    int intena;
    //struct proc *p = myproc();
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
80103df3:	83 ec 0c             	sub    $0xc,%esp
80103df6:	68 60 3d 11 80       	push   $0x80113d60
80103dfb:	e8 a0 0d 00 00       	call   80104ba0 <holding>
80103e00:	83 c4 10             	add    $0x10,%esp
80103e03:	85 c0                	test   %eax,%eax
80103e05:	74 4f                	je     80103e56 <sched+0x96>
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
80103e07:	e8 e4 f9 ff ff       	call   801037f0 <mycpu>
80103e0c:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e13:	75 68                	jne    80103e7d <sched+0xbd>
        panic("sched locks");
    if (t->state == RUNNING)
80103e15:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103e19:	74 55                	je     80103e70 <sched+0xb0>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e1b:	9c                   	pushf  
80103e1c:	58                   	pop    %eax
        panic("sched running");
    if (readeflags() & FL_IF)
80103e1d:	f6 c4 02             	test   $0x2,%ah
80103e20:	75 41                	jne    80103e63 <sched+0xa3>
        panic("sched interruptible");
    intena = mycpu()->intena;
80103e22:	e8 c9 f9 ff ff       	call   801037f0 <mycpu>
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
80103e27:	83 c3 14             	add    $0x14,%ebx
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
80103e2a:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
80103e30:	e8 bb f9 ff ff       	call   801037f0 <mycpu>
80103e35:	83 ec 08             	sub    $0x8,%esp
80103e38:	ff 70 04             	pushl  0x4(%eax)
80103e3b:	53                   	push   %ebx
80103e3c:	e8 fa 10 00 00       	call   80104f3b <swtch>
    mycpu()->intena = intena;
80103e41:	e8 aa f9 ff ff       	call   801037f0 <mycpu>
}
80103e46:	83 c4 10             	add    $0x10,%esp
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
    mycpu()->intena = intena;
80103e49:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e52:	5b                   	pop    %ebx
80103e53:	5e                   	pop    %esi
80103e54:	5d                   	pop    %ebp
80103e55:	c3                   	ret    
    int intena;
    //struct proc *p = myproc();
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
80103e56:	83 ec 0c             	sub    $0xc,%esp
80103e59:	68 4b 7e 10 80       	push   $0x80107e4b
80103e5e:	e8 0d c5 ff ff       	call   80100370 <panic>
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	68 77 7e 10 80       	push   $0x80107e77
80103e6b:	e8 00 c5 ff ff       	call   80100370 <panic>
    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
80103e70:	83 ec 0c             	sub    $0xc,%esp
80103e73:	68 69 7e 10 80       	push   $0x80107e69
80103e78:	e8 f3 c4 ff ff       	call   80100370 <panic>
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
80103e7d:	83 ec 0c             	sub    $0xc,%esp
80103e80:	68 5d 7e 10 80       	push   $0x80107e5d
80103e85:	e8 e6 c4 ff ff       	call   80100370 <panic>
80103e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e90 <yield>:
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	53                   	push   %ebx
80103e94:	83 ec 10             	sub    $0x10,%esp
    //struct  proc *p = myproc();
    //acquire(p->procLock);
    acquire(&ptable.lock);
80103e97:	68 60 3d 11 80       	push   $0x80113d60
80103e9c:	e8 2f 0d 00 00       	call   80104bd0 <acquire>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103ea1:	e8 4a 0c 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80103ea6:	e8 45 f9 ff ff       	call   801037f0 <mycpu>
    t = c->currThread;
80103eab:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103eb1:	e8 7a 0c 00 00       	call   80104b30 <popcli>
void
yield(void) {
    //struct  proc *p = myproc();
    //acquire(p->procLock);
    acquire(&ptable.lock);
    mythread()->state = RUNNABLE;
80103eb6:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103ebd:	e8 fe fe ff ff       	call   80103dc0 <sched>
    release(&ptable.lock);
80103ec2:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103ec9:	e8 b2 0d 00 00       	call   80104c80 <release>
    //release(p->procLock);
}
80103ece:	83 c4 10             	add    $0x10,%esp
80103ed1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed4:	c9                   	leave  
80103ed5:	c3                   	ret    
80103ed6:	8d 76 00             	lea    0x0(%esi),%esi
80103ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ee0 <sleep>:
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80103ee9:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103ef0:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ef3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (DEBUGMODE > 1)
80103ef6:	7e 10                	jle    80103f08 <sleep+0x28>
        cprintf(" SLEEP ");
80103ef8:	83 ec 0c             	sub    $0xc,%esp
80103efb:	68 8b 7e 10 80       	push   $0x80107e8b
80103f00:	e8 5b c7 ff ff       	call   80100660 <cprintf>
80103f05:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103f08:	e8 e3 0b 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80103f0d:	e8 de f8 ff ff       	call   801037f0 <mycpu>
    p = c->proc;
80103f12:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103f18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103f1b:	e8 10 0c 00 00       	call   80104b30 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103f20:	e8 cb 0b 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80103f25:	e8 c6 f8 ff ff       	call   801037f0 <mycpu>
    t = c->currThread;
80103f2a:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103f30:	e8 fb 0b 00 00       	call   80104b30 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103f35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f38:	85 d2                	test   %edx,%edx
80103f3a:	0f 84 83 00 00 00    	je     80103fc3 <sleep+0xe3>
        panic("sleep");

    if (lk == 0)
80103f40:	85 db                	test   %ebx,%ebx
80103f42:	74 72                	je     80103fb6 <sleep+0xd6>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {
80103f44:	81 fb 60 3d 11 80    	cmp    $0x80113d60,%ebx
80103f4a:	74 4c                	je     80103f98 <sleep+0xb8>
        acquire(&ptable.lock);
80103f4c:	83 ec 0c             	sub    $0xc,%esp
80103f4f:	68 60 3d 11 80       	push   $0x80113d60
80103f54:	e8 77 0c 00 00       	call   80104bd0 <acquire>
        release(lk);
80103f59:	89 1c 24             	mov    %ebx,(%esp)
80103f5c:	e8 1f 0d 00 00       	call   80104c80 <release>
    }
    // Go to sleep.
    t->chan = chan;
80103f61:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103f64:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103f6b:	e8 50 fe ff ff       	call   80103dc0 <sched>

    // Tidy up.
    t->chan = 0;
80103f70:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80103f77:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103f7e:	e8 fd 0c 00 00       	call   80104c80 <release>
        acquire(lk);
80103f83:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103f86:	83 c4 10             	add    $0x10,%esp
    }
}
80103f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f8c:	5b                   	pop    %ebx
80103f8d:	5e                   	pop    %esi
80103f8e:	5f                   	pop    %edi
80103f8f:	5d                   	pop    %ebp
    t->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
80103f90:	e9 3b 0c 00 00       	jmp    80104bd0 <acquire>
80103f95:	8d 76 00             	lea    0x0(%esi),%esi
    if (lk != &ptable.lock) {
        acquire(&ptable.lock);
        release(lk);
    }
    // Go to sleep.
    t->chan = chan;
80103f98:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103f9b:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103fa2:	e8 19 fe ff ff       	call   80103dc0 <sched>

    // Tidy up.
    t->chan = 0;
80103fa7:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}
80103fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fb1:	5b                   	pop    %ebx
80103fb2:	5e                   	pop    %esi
80103fb3:	5f                   	pop    %edi
80103fb4:	5d                   	pop    %ebp
80103fb5:	c3                   	ret    

    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");
80103fb6:	83 ec 0c             	sub    $0xc,%esp
80103fb9:	68 99 7e 10 80       	push   $0x80107e99
80103fbe:	e8 ad c3 ff ff       	call   80100370 <panic>

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
        panic("sleep");
80103fc3:	83 ec 0c             	sub    $0xc,%esp
80103fc6:	68 93 7e 10 80       	push   $0x80107e93
80103fcb:	e8 a0 c3 ff ff       	call   80100370 <panic>

80103fd0 <cleanProcOneThread>:
    memset(t->tf, 0, sizeof(*t->tf));
    memset(t->context, 0, sizeof(*t->context));
}

void
cleanProcOneThread(struct thread *curthread, struct proc *p) {
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 18             	sub    $0x18,%esp
80103fd9:	8b 75 0c             	mov    0xc(%ebp),%esi
80103fdc:	8b 7d 08             	mov    0x8(%ebp),%edi

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
80103fdf:	68 60 3d 11 80       	push   $0x80113d60
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103fe4:	8d 5e 74             	lea    0x74(%esi),%ebx
80103fe7:	81 c6 b4 03 00 00    	add    $0x3b4,%esi
void
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
80103fed:	e8 de 0b 00 00       	call   80104bd0 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103ff2:	83 c4 10             	add    $0x10,%esp
80103ff5:	eb 18                	jmp    8010400f <cleanProcOneThread+0x3f>
80103ff7:	89 f6                	mov    %esi,%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (t != curthread) {
            if (t->state == RUNNING)
                sleep(t, &ptable.lock);
            if (t->state == RUNNING || t->state == RUNNABLE) {
80104000:	83 e8 03             	sub    $0x3,%eax
80104003:	83 f8 01             	cmp    $0x1,%eax
80104006:	76 38                	jbe    80104040 <cleanProcOneThread+0x70>
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104008:	83 c3 34             	add    $0x34,%ebx
8010400b:	39 f3                	cmp    %esi,%ebx
8010400d:	73 44                	jae    80104053 <cleanProcOneThread+0x83>
        if (t != curthread) {
8010400f:	39 df                	cmp    %ebx,%edi
80104011:	74 f5                	je     80104008 <cleanProcOneThread+0x38>
            if (t->state == RUNNING)
80104013:	8b 43 08             	mov    0x8(%ebx),%eax
80104016:	83 f8 04             	cmp    $0x4,%eax
80104019:	75 e5                	jne    80104000 <cleanProcOneThread+0x30>
                sleep(t, &ptable.lock);
8010401b:	83 ec 08             	sub    $0x8,%esp
8010401e:	68 60 3d 11 80       	push   $0x80113d60
80104023:	53                   	push   %ebx
80104024:	e8 b7 fe ff ff       	call   80103ee0 <sleep>
80104029:	8b 43 08             	mov    0x8(%ebx),%eax
8010402c:	83 c4 10             	add    $0x10,%esp
            if (t->state == RUNNING || t->state == RUNNABLE) {
8010402f:	83 e8 03             	sub    $0x3,%eax
80104032:	83 f8 01             	cmp    $0x1,%eax
80104035:	77 d1                	ja     80104008 <cleanProcOneThread+0x38>
80104037:	89 f6                	mov    %esi,%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cleanThread(t);
80104040:	83 ec 0c             	sub    $0xc,%esp
80104043:	53                   	push   %ebx
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104044:	83 c3 34             	add    $0x34,%ebx
        if (t != curthread) {
            if (t->state == RUNNING)
                sleep(t, &ptable.lock);
            if (t->state == RUNNING || t->state == RUNNABLE) {
                cleanThread(t);
80104047:	e8 44 f7 ff ff       	call   80103790 <cleanThread>
8010404c:	83 c4 10             	add    $0x10,%esp
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010404f:	39 f3                	cmp    %esi,%ebx
80104051:	72 bc                	jb     8010400f <cleanProcOneThread+0x3f>
            if (t->state == RUNNING || t->state == RUNNABLE) {
                cleanThread(t);
            }
        }
    }
    release(&ptable.lock);
80104053:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
8010405a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010405d:	5b                   	pop    %ebx
8010405e:	5e                   	pop    %esi
8010405f:	5f                   	pop    %edi
80104060:	5d                   	pop    %ebp
            if (t->state == RUNNING || t->state == RUNNABLE) {
                cleanThread(t);
            }
        }
    }
    release(&ptable.lock);
80104061:	e9 1a 0c 00 00       	jmp    80104c80 <release>
80104066:	8d 76 00             	lea    0x0(%esi),%esi
80104069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104070 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104079:	e8 72 0a 00 00       	call   80104af0 <pushcli>
    c = mycpu();
8010407e:	e8 6d f7 ff ff       	call   801037f0 <mycpu>
    p = c->proc;
80104083:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104089:	e8 a2 0a 00 00       	call   80104b30 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
8010408e:	e8 5d 0a 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80104093:	e8 58 f7 ff ff       	call   801037f0 <mycpu>
    t = c->currThread;
80104098:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010409e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
801040a1:	e8 8a 0a 00 00       	call   80104b30 <popcli>
    struct proc *curproc = myproc();
    struct proc *p;
    //struct thread *t;
    struct thread *curthread = mythread();
    int fd;
    if (DEBUGMODE > 0)
801040a6:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
801040ab:	85 c0                	test   %eax,%eax
801040ad:	7e 10                	jle    801040bf <exit+0x4f>
        cprintf("EXIT");
801040af:	83 ec 0c             	sub    $0xc,%esp
801040b2:	68 aa 7e 10 80       	push   $0x80107eaa
801040b7:	e8 a4 c5 ff ff       	call   80100660 <cprintf>
801040bc:	83 c4 10             	add    $0x10,%esp
    if (curproc == initproc)
801040bf:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
801040c5:	0f 84 98 01 00 00    	je     80104263 <exit+0x1f3>
//        }
//    }

    // if (DEBUGMODE > 0)
    //cprintf(" BEFORE cleanProcOneThread\n");
    cleanProcOneThread(curthread, curproc);
801040cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801040ce:	83 ec 08             	sub    $0x8,%esp
801040d1:	8d 5e 60             	lea    0x60(%esi),%ebx
801040d4:	56                   	push   %esi
801040d5:	57                   	push   %edi
801040d6:	e8 f5 fe ff ff       	call   80103fd0 <cleanProcOneThread>
    // if (DEBUGMODE > 0)
    //cprintf(" AFTER cleanProcOneThread\n");
    acquire(&ptable.lock);
801040db:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801040e2:	e8 e9 0a 00 00       	call   80104bd0 <acquire>
    curproc->mainThread = curthread;
801040e7:	89 be b4 03 00 00    	mov    %edi,0x3b4(%esi)
801040ed:	8d 7e 20             	lea    0x20(%esi),%edi
801040f0:	83 c4 10             	add    $0x10,%esp
801040f3:	90                   	nop
801040f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //When got here - the only thread that is RUNNINNg is curThread
    //all other threads are ZOMBIE

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
801040f8:	8b 07                	mov    (%edi),%eax
801040fa:	85 c0                	test   %eax,%eax
801040fc:	74 12                	je     80104110 <exit+0xa0>
            fileclose(curproc->ofile[fd]);
801040fe:	83 ec 0c             	sub    $0xc,%esp
80104101:	50                   	push   %eax
80104102:	e8 39 cd ff ff       	call   80100e40 <fileclose>
            curproc->ofile[fd] = 0;
80104107:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010410d:	83 c4 10             	add    $0x10,%esp
80104110:	83 c7 04             	add    $0x4,%edi

    //When got here - the only thread that is RUNNINNg is curThread
    //all other threads are ZOMBIE

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
80104113:	39 df                	cmp    %ebx,%edi
80104115:	75 e1                	jne    801040f8 <exit+0x88>
        if (curproc->ofile[fd]) {
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }
    if (holding(&ptable.lock))
80104117:	83 ec 0c             	sub    $0xc,%esp
8010411a:	68 60 3d 11 80       	push   $0x80113d60
8010411f:	e8 7c 0a 00 00       	call   80104ba0 <holding>
80104124:	83 c4 10             	add    $0x10,%esp
80104127:	85 c0                	test   %eax,%eax
80104129:	0f 85 1f 01 00 00    	jne    8010424e <exit+0x1de>
        release(&ptable.lock);

    begin_op();
8010412f:	e8 2c ea ff ff       	call   80102b60 <begin_op>
    iput(curproc->cwd);
80104134:	83 ec 0c             	sub    $0xc,%esp
80104137:	ff 76 60             	pushl  0x60(%esi)
8010413a:	e8 71 d6 ff ff       	call   801017b0 <iput>
    end_op();
8010413f:	e8 8c ea ff ff       	call   80102bd0 <end_op>
    curproc->cwd = 0;
80104144:	c7 46 60 00 00 00 00 	movl   $0x0,0x60(%esi)

    acquire(&ptable.lock);
8010414b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80104152:	e8 79 0a 00 00       	call   80104bd0 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent->mainThread);
80104157:	8b 46 10             	mov    0x10(%esi),%eax
8010415a:	83 c4 10             	add    $0x10,%esp
8010415d:	ba 48 41 11 80       	mov    $0x80114148,%edx
80104162:	8b 88 b4 03 00 00    	mov    0x3b4(%eax),%ecx
80104168:	eb 14                	jmp    8010417e <exit+0x10e>
8010416a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104170:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104176:	81 fa 48 30 12 80    	cmp    $0x80123048,%edx
8010417c:	74 2d                	je     801041ab <exit+0x13b>
        if (p->state != RUNNABLE)
8010417e:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
80104185:	75 e9                	jne    80104170 <exit+0x100>
80104187:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
8010418d:	eb 08                	jmp    80104197 <exit+0x127>
8010418f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104190:	83 c0 34             	add    $0x34,%eax
80104193:	39 d0                	cmp    %edx,%eax
80104195:	73 d9                	jae    80104170 <exit+0x100>
            if (t->state == SLEEPING && t->chan == chan)
80104197:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010419b:	75 f3                	jne    80104190 <exit+0x120>
8010419d:	3b 48 18             	cmp    0x18(%eax),%ecx
801041a0:	75 ee                	jne    80104190 <exit+0x120>
                t->state = RUNNABLE;
801041a2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801041a9:	eb e5                	jmp    80104190 <exit+0x120>
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801041ab:	8b 3d bc b5 10 80    	mov    0x8010b5bc,%edi
801041b1:	b9 94 3d 11 80       	mov    $0x80113d94,%ecx
801041b6:	eb 16                	jmp    801041ce <exit+0x15e>
801041b8:	90                   	nop
801041b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    // Parent might be sleeping in wait().
    wakeup1(curproc->parent->mainThread);
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041c0:	81 c1 bc 03 00 00    	add    $0x3bc,%ecx
801041c6:	81 f9 94 2c 12 80    	cmp    $0x80122c94,%ecx
801041cc:	74 5d                	je     8010422b <exit+0x1bb>
        if (p->parent == curproc) {
801041ce:	39 71 10             	cmp    %esi,0x10(%ecx)
801041d1:	75 ed                	jne    801041c0 <exit+0x150>
            p->parent = initproc;
            if (p->state == ZOMBIE)
801041d3:	83 79 08 05          	cmpl   $0x5,0x8(%ecx)
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801041d7:	89 79 10             	mov    %edi,0x10(%ecx)
            if (p->state == ZOMBIE)
801041da:	75 e4                	jne    801041c0 <exit+0x150>
                wakeup1(initproc->mainThread);
801041dc:	8b 9f b4 03 00 00    	mov    0x3b4(%edi),%ebx
801041e2:	ba 48 41 11 80       	mov    $0x80114148,%edx
801041e7:	eb 15                	jmp    801041fe <exit+0x18e>
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041f0:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041f6:	81 fa 48 30 12 80    	cmp    $0x80123048,%edx
801041fc:	74 c2                	je     801041c0 <exit+0x150>
        if (p->state != RUNNABLE)
801041fe:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
80104205:	75 e9                	jne    801041f0 <exit+0x180>
80104207:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
8010420d:	eb 08                	jmp    80104217 <exit+0x1a7>
8010420f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104210:	83 c0 34             	add    $0x34,%eax
80104213:	39 d0                	cmp    %edx,%eax
80104215:	73 d9                	jae    801041f0 <exit+0x180>
            if (t->state == SLEEPING && t->chan == chan)
80104217:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010421b:	75 f3                	jne    80104210 <exit+0x1a0>
8010421d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104220:	75 ee                	jne    80104210 <exit+0x1a0>
                t->state = RUNNABLE;
80104222:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104229:	eb e5                	jmp    80104210 <exit+0x1a0>
    }
    //cprintf(" AFTER Pass abandoned children to init.\n");

    //TODO- where to unlock
    //cleanThread(curthread);
    curthread->state = ZOMBIE;
8010422b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010422e:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    //curthread->killed=1;
    //release(curproc->procLock);

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
80104235:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
8010423c:	e8 7f fb ff ff       	call   80103dc0 <sched>
    panic("zombie exit");
80104241:	83 ec 0c             	sub    $0xc,%esp
80104244:	68 bc 7e 10 80       	push   $0x80107ebc
80104249:	e8 22 c1 ff ff       	call   80100370 <panic>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }
    if (holding(&ptable.lock))
        release(&ptable.lock);
8010424e:	83 ec 0c             	sub    $0xc,%esp
80104251:	68 60 3d 11 80       	push   $0x80113d60
80104256:	e8 25 0a 00 00       	call   80104c80 <release>
8010425b:	83 c4 10             	add    $0x10,%esp
8010425e:	e9 cc fe ff ff       	jmp    8010412f <exit+0xbf>
    struct thread *curthread = mythread();
    int fd;
    if (DEBUGMODE > 0)
        cprintf("EXIT");
    if (curproc == initproc)
        panic("init exiting");
80104263:	83 ec 0c             	sub    $0xc,%esp
80104266:	68 af 7e 10 80       	push   $0x80107eaf
8010426b:	e8 00 c1 ff ff       	call   80100370 <panic>

80104270 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80104279:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
80104280:	7e 10                	jle    80104292 <wait+0x22>
        cprintf(" WAIT ");
80104282:	83 ec 0c             	sub    $0xc,%esp
80104285:	68 c8 7e 10 80       	push   $0x80107ec8
8010428a:	e8 d1 c3 ff ff       	call   80100660 <cprintf>
8010428f:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104292:	e8 59 08 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80104297:	e8 54 f5 ff ff       	call   801037f0 <mycpu>
    p = c->proc;
8010429c:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801042a2:	e8 89 08 00 00       	call   80104b30 <popcli>
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();
    struct thread *t;

    acquire(&ptable.lock);
801042a7:	83 ec 0c             	sub    $0xc,%esp
801042aa:	68 60 3d 11 80       	push   $0x80113d60
801042af:	e8 1c 09 00 00       	call   80104bd0 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
801042b7:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042b9:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
801042be:	eb 0e                	jmp    801042ce <wait+0x5e>
801042c0:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
801042c6:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
801042cc:	74 22                	je     801042f0 <wait+0x80>
            if (p->parent != curproc)
801042ce:	39 73 10             	cmp    %esi,0x10(%ebx)
801042d1:	75 ed                	jne    801042c0 <wait+0x50>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
801042d3:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
801042d7:	74 6a                	je     80104343 <wait+0xd3>

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042d9:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
            if (p->parent != curproc)
                continue;
            havekids = 1;
801042df:	b8 01 00 00 00       	mov    $0x1,%eax

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042e4:	81 fb 94 2c 12 80    	cmp    $0x80122c94,%ebx
801042ea:	75 e2                	jne    801042ce <wait+0x5e>
801042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
801042f0:	85 c0                	test   %eax,%eax
801042f2:	0f 84 c6 00 00 00    	je     801043be <wait+0x14e>
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801042f8:	e8 f3 07 00 00       	call   80104af0 <pushcli>
    c = mycpu();
801042fd:	e8 ee f4 ff ff       	call   801037f0 <mycpu>
    p = c->proc;
80104302:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104308:	e8 23 08 00 00       	call   80104b30 <popcli>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
8010430d:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104310:	85 c0                	test   %eax,%eax
80104312:	0f 85 a6 00 00 00    	jne    801043be <wait+0x14e>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104318:	e8 d3 07 00 00       	call   80104af0 <pushcli>
    c = mycpu();
8010431d:	e8 ce f4 ff ff       	call   801037f0 <mycpu>
    t = c->currThread;
80104322:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104328:	e8 03 08 00 00       	call   80104b30 <popcli>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
8010432d:	83 ec 08             	sub    $0x8,%esp
80104330:	68 60 3d 11 80       	push   $0x80113d60
80104335:	53                   	push   %ebx
80104336:	e8 a5 fb ff ff       	call   80103ee0 <sleep>
    }
8010433b:	83 c4 10             	add    $0x10,%esp
8010433e:	e9 74 ff ff ff       	jmp    801042b7 <wait+0x47>
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
80104343:	8b 43 0c             	mov    0xc(%ebx),%eax
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104346:	8d 73 74             	lea    0x74(%ebx),%esi
80104349:	8d bb b4 03 00 00    	lea    0x3b4(%ebx),%edi
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
8010434f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104352:	eb 0b                	jmp    8010435f <wait+0xef>
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104358:	83 c6 34             	add    $0x34,%esi
8010435b:	39 f7                	cmp    %esi,%edi
8010435d:	76 1a                	jbe    80104379 <wait+0x109>
                    if (t->state != UNUSED)
8010435f:	8b 56 08             	mov    0x8(%esi),%edx
80104362:	85 d2                	test   %edx,%edx
80104364:	74 f2                	je     80104358 <wait+0xe8>
                        cleanThread(t);
80104366:	83 ec 0c             	sub    $0xc,%esp
80104369:	56                   	push   %esi
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010436a:	83 c6 34             	add    $0x34,%esi
                    if (t->state != UNUSED)
                        cleanThread(t);
8010436d:	e8 1e f4 ff ff       	call   80103790 <cleanThread>
80104372:	83 c4 10             	add    $0x10,%esp
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104375:	39 f7                	cmp    %esi,%edi
80104377:	77 e6                	ja     8010435f <wait+0xef>
                    if (t->state != UNUSED)
                        cleanThread(t);
                }
//                release(p->procLock);

                freevm(p->pgdir);
80104379:	83 ec 0c             	sub    $0xc,%esp
8010437c:	ff 73 04             	pushl  0x4(%ebx)
8010437f:	e8 ac 31 00 00       	call   80107530 <freevm>
                p->pid = 0;
80104384:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
8010438b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
80104392:	c6 43 64 00          	movb   $0x0,0x64(%ebx)
                p->killed = 0;
80104396:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
8010439d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
801043a4:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801043ab:	e8 d0 08 00 00       	call   80104c80 <release>
                return pid;
801043b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043b3:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
801043b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b9:	5b                   	pop    %ebx
801043ba:	5e                   	pop    %esi
801043bb:	5f                   	pop    %edi
801043bc:	5d                   	pop    %ebp
801043bd:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
            release(&ptable.lock);
801043be:	83 ec 0c             	sub    $0xc,%esp
801043c1:	68 60 3d 11 80       	push   $0x80113d60
801043c6:	e8 b5 08 00 00       	call   80104c80 <release>
            return -1;
801043cb:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
801043ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
            release(&ptable.lock);
            return -1;
801043d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
801043d6:	5b                   	pop    %ebx
801043d7:	5e                   	pop    %esi
801043d8:	5f                   	pop    %edi
801043d9:	5d                   	pop    %ebp
801043da:	c3                   	ret    
801043db:	90                   	nop
801043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043e0 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 1)
801043e7:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801043ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 1)
801043f1:	7e 10                	jle    80104403 <wakeup+0x23>
        cprintf(" WAKEUP ");
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	68 cf 7e 10 80       	push   $0x80107ecf
801043fb:	e8 60 c2 ff ff       	call   80100660 <cprintf>
80104400:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	68 60 3d 11 80       	push   $0x80113d60
8010440b:	e8 c0 07 00 00       	call   80104bd0 <acquire>
80104410:	ba 48 41 11 80       	mov    $0x80114148,%edx
80104415:	83 c4 10             	add    $0x10,%esp
80104418:	eb 14                	jmp    8010442e <wakeup+0x4e>
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104420:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104426:	81 fa 48 30 12 80    	cmp    $0x80123048,%edx
8010442c:	74 2d                	je     8010445b <wakeup+0x7b>
        if (p->state != RUNNABLE)
8010442e:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
80104435:	75 e9                	jne    80104420 <wakeup+0x40>
80104437:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
8010443d:	eb 08                	jmp    80104447 <wakeup+0x67>
8010443f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104440:	83 c0 34             	add    $0x34,%eax
80104443:	39 d0                	cmp    %edx,%eax
80104445:	73 d9                	jae    80104420 <wakeup+0x40>
            if (t->state == SLEEPING && t->chan == chan)
80104447:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010444b:	75 f3                	jne    80104440 <wakeup+0x60>
8010444d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104450:	75 ee                	jne    80104440 <wakeup+0x60>
                t->state = RUNNABLE;
80104452:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104459:	eb e5                	jmp    80104440 <wakeup+0x60>
wakeup(void *chan) {
    if (DEBUGMODE > 1)
        cprintf(" WAKEUP ");
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
8010445b:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
80104462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104465:	c9                   	leave  
wakeup(void *chan) {
    if (DEBUGMODE > 1)
        cprintf(" WAKEUP ");
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80104466:	e9 15 08 00 00       	jmp    80104c80 <release>
8010446b:	90                   	nop
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 0)
80104477:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
8010447c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 0)
8010447f:	85 c0                	test   %eax,%eax
80104481:	7e 10                	jle    80104493 <kill+0x23>
        cprintf(" KILL ");
80104483:	83 ec 0c             	sub    $0xc,%esp
80104486:	68 d8 7e 10 80       	push   $0x80107ed8
8010448b:	e8 d0 c1 ff ff       	call   80100660 <cprintf>
80104490:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    acquire(&ptable.lock);
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	68 60 3d 11 80       	push   $0x80113d60
8010449b:	e8 30 07 00 00       	call   80104bd0 <acquire>
801044a0:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044a3:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
801044a8:	eb 12                	jmp    801044bc <kill+0x4c>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044b0:	05 bc 03 00 00       	add    $0x3bc,%eax
801044b5:	3d 94 2c 12 80       	cmp    $0x80122c94,%eax
801044ba:	74 64                	je     80104520 <kill+0xb0>
        if (p->pid == pid) {
801044bc:	39 58 0c             	cmp    %ebx,0xc(%eax)
801044bf:	75 ef                	jne    801044b0 <kill+0x40>
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801044c1:	8d 50 74             	lea    0x74(%eax),%edx
801044c4:	8d 88 b4 03 00 00    	lea    0x3b4(%eax),%ecx
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                t->killed = 1;
801044d0:	c7 42 1c 01 00 00 00 	movl   $0x1,0x1c(%edx)
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801044d7:	83 c2 34             	add    $0x34,%edx
801044da:	39 ca                	cmp    %ecx,%edx
801044dc:	72 f2                	jb     801044d0 <kill+0x60>
                t->killed = 1;
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
801044de:	8b 90 b4 03 00 00    	mov    0x3b4(%eax),%edx
801044e4:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
801044e8:	74 1e                	je     80104508 <kill+0x98>
                p->mainThread->state = RUNNABLE;
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
            }

            //release( p->procLock );
            release(&ptable.lock);
801044ea:	83 ec 0c             	sub    $0xc,%esp
801044ed:	68 60 3d 11 80       	push   $0x80113d60
801044f2:	e8 89 07 00 00       	call   80104c80 <release>
            return 0;
801044f7:	83 c4 10             	add    $0x10,%esp
801044fa:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801044fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044ff:	c9                   	leave  
80104500:	c3                   	ret    
80104501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
                t->killed = 1;
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
                p->mainThread->state = RUNNABLE;
80104508:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
8010450f:	8b 80 b4 03 00 00    	mov    0x3b4(%eax),%eax
80104515:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010451c:	eb cc                	jmp    801044ea <kill+0x7a>
8010451e:	66 90                	xchg   %ax,%ax
            //release( p->procLock );
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	68 60 3d 11 80       	push   $0x80113d60
80104528:	e8 53 07 00 00       	call   80104c80 <release>
    return -1;
8010452d:	83 c4 10             	add    $0x10,%esp
80104530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104538:	c9                   	leave  
80104539:	c3                   	ret    
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104549:	bb f8 3d 11 80       	mov    $0x80113df8,%ebx
8010454e:	83 ec 3c             	sub    $0x3c,%esp
80104551:	eb 27                	jmp    8010457a <procdump+0x3a>
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104558:	83 ec 0c             	sub    $0xc,%esp
8010455b:	68 87 82 10 80       	push   $0x80108287
80104560:	e8 fb c0 ff ff       	call   80100660 <cprintf>
80104565:	83 c4 10             	add    $0x10,%esp
80104568:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010456e:	81 fb f8 2c 12 80    	cmp    $0x80122cf8,%ebx
80104574:	0f 84 96 00 00 00    	je     80104610 <procdump+0xd0>
        if (p->state == UNUSED)
8010457a:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010457d:	85 c0                	test   %eax,%eax
8010457f:	74 e7                	je     80104568 <procdump+0x28>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104581:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
80104584:	ba df 7e 10 80       	mov    $0x80107edf,%edx
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104589:	77 11                	ja     8010459c <procdump+0x5c>
8010458b:	8b 14 85 40 7f 10 80 	mov    -0x7fef80c0(,%eax,4),%edx
            state = states[p->state];
        else
            state = "???";
80104592:	b8 df 7e 10 80       	mov    $0x80107edf,%eax
80104597:	85 d2                	test   %edx,%edx
80104599:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010459c:	53                   	push   %ebx
8010459d:	52                   	push   %edx
8010459e:	ff 73 a8             	pushl  -0x58(%ebx)
801045a1:	68 e3 7e 10 80       	push   $0x80107ee3
801045a6:	e8 b5 c0 ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
801045ab:	8b 83 50 03 00 00    	mov    0x350(%ebx),%eax
801045b1:	83 c4 10             	add    $0x10,%esp
801045b4:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801045b8:	75 9e                	jne    80104558 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
801045ba:	8d 4d c0             	lea    -0x40(%ebp),%ecx
801045bd:	83 ec 08             	sub    $0x8,%esp
801045c0:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045c3:	51                   	push   %ecx
801045c4:	8b 40 14             	mov    0x14(%eax),%eax
801045c7:	8b 40 0c             	mov    0xc(%eax),%eax
801045ca:	83 c0 08             	add    $0x8,%eax
801045cd:	50                   	push   %eax
801045ce:	e8 bd 04 00 00       	call   80104a90 <getcallerpcs>
801045d3:	83 c4 10             	add    $0x10,%esp
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801045e0:	8b 17                	mov    (%edi),%edx
801045e2:	85 d2                	test   %edx,%edx
801045e4:	0f 84 6e ff ff ff    	je     80104558 <procdump+0x18>
                cprintf(" %p", pc[i]);
801045ea:	83 ec 08             	sub    $0x8,%esp
801045ed:	83 c7 04             	add    $0x4,%edi
801045f0:	52                   	push   %edx
801045f1:	68 a1 78 10 80       	push   $0x801078a1
801045f6:	e8 65 c0 ff ff       	call   80100660 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
801045fb:	83 c4 10             	add    $0x10,%esp
801045fe:	39 f7                	cmp    %esi,%edi
80104600:	75 de                	jne    801045e0 <procdump+0xa0>
80104602:	e9 51 ff ff ff       	jmp    80104558 <procdump+0x18>
80104607:	89 f6                	mov    %esi,%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80104610:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104613:	5b                   	pop    %ebx
80104614:	5e                   	pop    %esi
80104615:	5f                   	pop    %edi
80104616:	5d                   	pop    %ebp
80104617:	c3                   	ret    
80104618:	90                   	nop
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <kthread_create>:

//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104625:	e8 c6 04 00 00       	call   80104af0 <pushcli>
    c = mycpu();
8010462a:	e8 c1 f1 ff ff       	call   801037f0 <mycpu>
    p = c->proc;
8010462f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104635:	e8 f6 04 00 00       	call   80104b30 <popcli>
//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    acquire(&ptable.lock);
8010463a:	83 ec 0c             	sub    $0xc,%esp
8010463d:	68 60 3d 11 80       	push   $0x80113d60
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104642:	8d 5e 74             	lea    0x74(%esi),%ebx
//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    acquire(&ptable.lock);
80104645:	e8 86 05 00 00       	call   80104bd0 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
8010464a:	8b 46 7c             	mov    0x7c(%esi),%eax
8010464d:	83 c4 10             	add    $0x10,%esp
80104650:	85 c0                	test   %eax,%eax
80104652:	74 3c                	je     80104690 <kthread_create+0x70>
80104654:	8d 86 b4 03 00 00    	lea    0x3b4(%esi),%eax
8010465a:	eb 0b                	jmp    80104667 <kthread_create+0x47>
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104660:	8b 73 08             	mov    0x8(%ebx),%esi
80104663:	85 f6                	test   %esi,%esi
80104665:	74 29                	je     80104690 <kthread_create+0x70>
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104667:	83 c3 34             	add    $0x34,%ebx
8010466a:	39 c3                	cmp    %eax,%ebx
8010466c:	72 f2                	jb     80104660 <kthread_create+0x40>
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
8010466e:	83 ec 0c             	sub    $0xc,%esp
80104671:	68 60 3d 11 80       	push   $0x80113d60
80104676:	e8 05 06 00 00       	call   80104c80 <release>
        return -1;
8010467b:	83 c4 10             	add    $0x10,%esp
    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
8010467e:	8d 65 f8             	lea    -0x8(%ebp),%esp

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
        return -1;
80104681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
80104686:	5b                   	pop    %ebx
80104687:	5e                   	pop    %esi
80104688:	5d                   	pop    %ebp
80104689:	c3                   	ret    
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
    t->tid = tidCounter++;
80104690:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    //got here- didn't have a room for new thread
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
80104695:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    t->tid = tidCounter++;
8010469c:	8d 50 01             	lea    0x1(%eax),%edx
8010469f:	89 43 0c             	mov    %eax,0xc(%ebx)
801046a2:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
801046a8:	e8 f3 dd ff ff       	call   801024a0 <kalloc>
801046ad:	85 c0                	test   %eax,%eax
801046af:	89 43 04             	mov    %eax,0x4(%ebx)
801046b2:	0f 84 dd 00 00 00    	je     80104795 <kthread_create+0x175>
    }

    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
801046b8:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
801046be:	83 ec 04             	sub    $0x4,%esp
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
801046c1:	05 9c 0f 00 00       	add    $0xf9c,%eax
    }

    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
801046c6:	89 53 10             	mov    %edx,0x10(%ebx)
    t->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;
801046c9:	c7 40 14 af 5f 10 80 	movl   $0x80105faf,0x14(%eax)

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
801046d0:	89 43 14             	mov    %eax,0x14(%ebx)
    memset(t->context, 0, sizeof *t->context);
801046d3:	6a 14                	push   $0x14
801046d5:	6a 00                	push   $0x0
801046d7:	50                   	push   %eax
801046d8:	e8 03 06 00 00       	call   80104ce0 <memset>
    t->context->eip = (uint) forkret;
801046dd:	8b 43 14             	mov    0x14(%ebx),%eax

    memset(t->tf, 0, sizeof(*t->tf));
801046e0:	83 c4 0c             	add    $0xc,%esp
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
801046e3:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)

    memset(t->tf, 0, sizeof(*t->tf));
801046ea:	6a 4c                	push   $0x4c
801046ec:	6a 00                	push   $0x0
801046ee:	ff 73 10             	pushl  0x10(%ebx)
801046f1:	e8 ea 05 00 00       	call   80104ce0 <memset>
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801046f6:	8b 43 10             	mov    0x10(%ebx),%eax
801046f9:	ba 1b 00 00 00       	mov    $0x1b,%edx
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801046fe:	b9 23 00 00 00       	mov    $0x23,%ecx
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;

    memset(t->tf, 0, sizeof(*t->tf));
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104703:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104707:	8b 43 10             	mov    0x10(%ebx),%eax
8010470a:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    t->tf->es = t->tf->ds;
8010470e:	8b 43 10             	mov    0x10(%ebx),%eax
80104711:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104715:	66 89 50 28          	mov    %dx,0x28(%eax)
    t->tf->ss = t->tf->ds;
80104719:	8b 43 10             	mov    0x10(%ebx),%eax
8010471c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104720:	66 89 50 48          	mov    %dx,0x48(%eax)
    t->tf->eflags = FL_IF;
80104724:	8b 43 10             	mov    0x10(%ebx),%eax
    t->tf->esp = PGSIZE;
    t->tf->eip = (uint) start_func;  // beginning of run func
80104727:	8b 55 08             	mov    0x8(%ebp),%edx
    memset(t->tf, 0, sizeof(*t->tf));
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    t->tf->es = t->tf->ds;
    t->tf->ss = t->tf->ds;
    t->tf->eflags = FL_IF;
8010472a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    t->tf->esp = PGSIZE;
80104731:	8b 43 10             	mov    0x10(%ebx),%eax
80104734:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    t->tf->eip = (uint) start_func;  // beginning of run func
8010473b:	8b 43 10             	mov    0x10(%ebx),%eax
8010473e:	89 50 38             	mov    %edx,0x38(%eax)
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104741:	e8 aa 03 00 00       	call   80104af0 <pushcli>
    c = mycpu();
80104746:	e8 a5 f0 ff ff       	call   801037f0 <mycpu>
    p = c->proc;
8010474b:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104751:	e8 da 03 00 00       	call   80104b30 <popcli>
    t->tf->ss = t->tf->ds;
    t->tf->eflags = FL_IF;
    t->tf->esp = PGSIZE;
    t->tf->eip = (uint) start_func;  // beginning of run func

    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
80104756:	8d 43 20             	lea    0x20(%ebx),%eax
80104759:	83 c4 0c             	add    $0xc,%esp
8010475c:	83 c6 64             	add    $0x64,%esi
8010475f:	6a 10                	push   $0x10
80104761:	56                   	push   %esi
80104762:	50                   	push   %eax
80104763:	e8 78 07 00 00       	call   80104ee0 <safestrcpy>
    //t->cwd = namei("/");

    t->killed = 0;
80104768:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    t->chan = 0;
8010476f:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    t->state = RUNNABLE;
80104776:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    release(&ptable.lock);
8010477d:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80104784:	e8 f7 04 00 00       	call   80104c80 <release>
    return 0;
80104789:	83 c4 10             	add    $0x10,%esp
}
8010478c:	8d 65 f8             	lea    -0x8(%ebp),%esp

    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
8010478f:	31 c0                	xor    %eax,%eax
}
80104791:	5b                   	pop    %ebx
80104792:	5e                   	pop    %esi
80104793:	5d                   	pop    %ebp
80104794:	c3                   	ret    
    t->state = EMBRYO;
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
80104795:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
8010479c:	e9 cd fe ff ff       	jmp    8010466e <kthread_create+0x4e>
801047a1:	eb 0d                	jmp    801047b0 <kthread_id>
801047a3:	90                   	nop
801047a4:	90                   	nop
801047a5:	90                   	nop
801047a6:	90                   	nop
801047a7:	90                   	nop
801047a8:	90                   	nop
801047a9:	90                   	nop
801047aa:	90                   	nop
801047ab:	90                   	nop
801047ac:	90                   	nop
801047ad:	90                   	nop
801047ae:	90                   	nop
801047af:	90                   	nop

801047b0 <kthread_id>:
    release(&ptable.lock);
    return 0;
}

//this func haven't been used - i's implementation is in sysproc
int kthread_id() {
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	53                   	push   %ebx
801047b4:	83 ec 04             	sub    $0x4,%esp
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
801047b7:	e8 34 03 00 00       	call   80104af0 <pushcli>
    c = mycpu();
801047bc:	e8 2f f0 ff ff       	call   801037f0 <mycpu>
    t = c->currThread;
801047c1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801047c7:	e8 64 03 00 00       	call   80104b30 <popcli>
    return 0;
}

//this func haven't been used - i's implementation is in sysproc
int kthread_id() {
    return mythread()->tid;
801047cc:	8b 43 0c             	mov    0xc(%ebx),%eax
}
801047cf:	83 c4 04             	add    $0x4,%esp
801047d2:	5b                   	pop    %ebx
801047d3:	5d                   	pop    %ebp
801047d4:	c3                   	ret    
801047d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <kthread_exit>:

void kthread_exit() {
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801047e7:	e8 04 03 00 00       	call   80104af0 <pushcli>
    c = mycpu();
801047ec:	e8 ff ef ff ff       	call   801037f0 <mycpu>
    p = c->proc;
801047f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801047f7:	e8 34 03 00 00       	call   80104b30 <popcli>

void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
801047fc:	83 ec 0c             	sub    $0xc,%esp
801047ff:	68 60 3d 11 80       	push   $0x80113d60
80104804:	e8 c7 03 00 00       	call   80104bd0 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104809:	8d 43 74             	lea    0x74(%ebx),%eax
8010480c:	8d 8b b4 03 00 00    	lea    0x3b4(%ebx),%ecx
80104812:	83 c4 10             	add    $0x10,%esp
80104815:	31 db                	xor    %ebx,%ebx
80104817:	eb 13                	jmp    8010482c <kthread_exit+0x4c>
80104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (t->state == UNUSED || t->state == ZOMBIE)
80104820:	83 fa 05             	cmp    $0x5,%edx
80104823:	74 0e                	je     80104833 <kthread_exit+0x53>
void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104825:	83 c0 34             	add    $0x34,%eax
80104828:	39 c8                	cmp    %ecx,%eax
8010482a:	73 11                	jae    8010483d <kthread_exit+0x5d>
        if (t->state == UNUSED || t->state == ZOMBIE)
8010482c:	8b 50 08             	mov    0x8(%eax),%edx
8010482f:	85 d2                	test   %edx,%edx
80104831:	75 ed                	jne    80104820 <kthread_exit+0x40>
void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104833:	83 c0 34             	add    $0x34,%eax
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
80104836:	83 c3 01             	add    $0x1,%ebx
void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104839:	39 c8                	cmp    %ecx,%eax
8010483b:	72 ef                	jb     8010482c <kthread_exit+0x4c>
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
    }
    if (counter == (NTHREADS - 1)){ //all other threads aren't available -> close proc
8010483d:	83 fb 0f             	cmp    $0xf,%ebx
80104840:	74 1d                	je     8010485f <kthread_exit+0x7f>
        release(&ptable.lock);
        exit();
    }
    else{   //there are other threads in the same proc - close just the specific thread
        cleanThread(t);
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	50                   	push   %eax
80104846:	e8 45 ef ff ff       	call   80103790 <cleanThread>
        release(&ptable.lock);
8010484b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80104852:	e8 29 04 00 00       	call   80104c80 <release>
    }
}
80104857:	83 c4 10             	add    $0x10,%esp
8010485a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010485d:	c9                   	leave  
8010485e:	c3                   	ret    
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
    }
    if (counter == (NTHREADS - 1)){ //all other threads aren't available -> close proc
        release(&ptable.lock);
8010485f:	83 ec 0c             	sub    $0xc,%esp
80104862:	68 60 3d 11 80       	push   $0x80113d60
80104867:	e8 14 04 00 00       	call   80104c80 <release>
        exit();
8010486c:	e8 ff f7 ff ff       	call   80104070 <exit>
80104871:	eb 0d                	jmp    80104880 <kthread_join>
80104873:	90                   	nop
80104874:	90                   	nop
80104875:	90                   	nop
80104876:	90                   	nop
80104877:	90                   	nop
80104878:	90                   	nop
80104879:	90                   	nop
8010487a:	90                   	nop
8010487b:	90                   	nop
8010487c:	90                   	nop
8010487d:	90                   	nop
8010487e:	90                   	nop
8010487f:	90                   	nop

80104880 <kthread_join>:
        cleanThread(t);
        release(&ptable.lock);
    }
}

int kthread_join(int thread_id) {
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	53                   	push   %ebx
80104884:	83 ec 10             	sub    $0x10,%esp
80104887:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
8010488a:	68 60 3d 11 80       	push   $0x80113d60
8010488f:	e8 3c 03 00 00       	call   80104bd0 <acquire>
80104894:	b9 08 3e 11 80       	mov    $0x80113e08,%ecx
80104899:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != UNUSED) {
8010489c:	8b 51 94             	mov    -0x6c(%ecx),%edx
8010489f:	89 c8                	mov    %ecx,%eax
801048a1:	85 d2                	test   %edx,%edx
801048a3:	74 1f                	je     801048c4 <kthread_join+0x44>
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->tid == thread_id)
801048a5:	39 59 0c             	cmp    %ebx,0xc(%ecx)
801048a8:	8d 91 40 03 00 00    	lea    0x340(%ecx),%edx
801048ae:	75 0d                	jne    801048bd <kthread_join+0x3d>
801048b0:	eb 3e                	jmp    801048f0 <kthread_join+0x70>
801048b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048b8:	39 58 0c             	cmp    %ebx,0xc(%eax)
801048bb:	74 33                	je     801048f0 <kthread_join+0x70>
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != UNUSED) {
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801048bd:	83 c0 34             	add    $0x34,%eax
801048c0:	39 d0                	cmp    %edx,%eax
801048c2:	72 f4                	jb     801048b8 <kthread_join+0x38>
801048c4:	81 c1 bc 03 00 00    	add    $0x3bc,%ecx

int kthread_join(int thread_id) {
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048ca:	81 f9 08 2d 12 80    	cmp    $0x80122d08,%ecx
801048d0:	75 ca                	jne    8010489c <kthread_join+0x1c>
                    goto found2;
            }
        }
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
801048d2:	83 ec 0c             	sub    $0xc,%esp
801048d5:	68 60 3d 11 80       	push   $0x80113d60
801048da:	e8 a1 03 00 00       	call   80104c80 <release>
    return -1;
801048df:	83 c4 10             	add    $0x10,%esp
801048e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    sleep(t,&ptable.lock);
    //TODO - not sure about release
    if(holding(&ptable.lock))
        release(&ptable.lock);
    return 0;
801048e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048ea:	c9                   	leave  
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
    return -1;
    found2:
    if (t->state == UNUSED || t->state == ZOMBIE){
801048f0:	8b 50 08             	mov    0x8(%eax),%edx
801048f3:	85 d2                	test   %edx,%edx
801048f5:	74 db                	je     801048d2 <kthread_join+0x52>
801048f7:	83 fa 05             	cmp    $0x5,%edx
801048fa:	74 d6                	je     801048d2 <kthread_join+0x52>
        release(&ptable.lock);
        return -1;
    }
    sleep(t,&ptable.lock);
801048fc:	83 ec 08             	sub    $0x8,%esp
801048ff:	68 60 3d 11 80       	push   $0x80113d60
80104904:	50                   	push   %eax
80104905:	e8 d6 f5 ff ff       	call   80103ee0 <sleep>
    //TODO - not sure about release
    if(holding(&ptable.lock))
8010490a:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80104911:	e8 8a 02 00 00       	call   80104ba0 <holding>
80104916:	83 c4 10             	add    $0x10,%esp
80104919:	85 c0                	test   %eax,%eax
8010491b:	74 ca                	je     801048e7 <kthread_join+0x67>
        release(&ptable.lock);
8010491d:	83 ec 0c             	sub    $0xc,%esp
80104920:	68 60 3d 11 80       	push   $0x80113d60
80104925:	e8 56 03 00 00       	call   80104c80 <release>
8010492a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010492d:	31 c0                	xor    %eax,%eax
8010492f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104932:	c9                   	leave  
80104933:	c3                   	ret    
80104934:	66 90                	xchg   %ax,%ax
80104936:	66 90                	xchg   %ax,%ax
80104938:	66 90                	xchg   %ax,%ax
8010493a:	66 90                	xchg   %ax,%ax
8010493c:	66 90                	xchg   %ax,%ax
8010493e:	66 90                	xchg   %ax,%ax

80104940 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 0c             	sub    $0xc,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010494a:	68 58 7f 10 80       	push   $0x80107f58
8010494f:	8d 43 04             	lea    0x4(%ebx),%eax
80104952:	50                   	push   %eax
80104953:	e8 18 01 00 00       	call   80104a70 <initlock>
  lk->name = name;
80104958:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010495b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104961:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104964:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010496b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010496e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104971:	c9                   	leave  
80104972:	c3                   	ret    
80104973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	8d 73 04             	lea    0x4(%ebx),%esi
8010498e:	56                   	push   %esi
8010498f:	e8 3c 02 00 00       	call   80104bd0 <acquire>
  while (lk->locked) {
80104994:	8b 13                	mov    (%ebx),%edx
80104996:	83 c4 10             	add    $0x10,%esp
80104999:	85 d2                	test   %edx,%edx
8010499b:	74 16                	je     801049b3 <acquiresleep+0x33>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049a0:	83 ec 08             	sub    $0x8,%esp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	e8 36 f5 ff ff       	call   80103ee0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801049aa:	8b 03                	mov    (%ebx),%eax
801049ac:	83 c4 10             	add    $0x10,%esp
801049af:	85 c0                	test   %eax,%eax
801049b1:	75 ed                	jne    801049a0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801049b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049b9:	e8 d2 ee ff ff       	call   80103890 <myproc>
801049be:	8b 40 0c             	mov    0xc(%eax),%eax
801049c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049ca:	5b                   	pop    %ebx
801049cb:	5e                   	pop    %esi
801049cc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801049cd:	e9 ae 02 00 00       	jmp    80104c80 <release>
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ee:	56                   	push   %esi
801049ef:	e8 dc 01 00 00       	call   80104bd0 <acquire>
  lk->locked = 0;
801049f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a01:	89 1c 24             	mov    %ebx,(%esp)
80104a04:	e8 d7 f9 ff ff       	call   801043e0 <wakeup>
  release(&lk->lk);
80104a09:	89 75 08             	mov    %esi,0x8(%ebp)
80104a0c:	83 c4 10             	add    $0x10,%esp
}
80104a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104a15:	e9 66 02 00 00       	jmp    80104c80 <release>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	53                   	push   %ebx
80104a26:	31 ff                	xor    %edi,%edi
80104a28:	83 ec 18             	sub    $0x18,%esp
80104a2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a2e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a31:	56                   	push   %esi
80104a32:	e8 99 01 00 00       	call   80104bd0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a37:	8b 03                	mov    (%ebx),%eax
80104a39:	83 c4 10             	add    $0x10,%esp
80104a3c:	85 c0                	test   %eax,%eax
80104a3e:	74 13                	je     80104a53 <holdingsleep+0x33>
80104a40:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a43:	e8 48 ee ff ff       	call   80103890 <myproc>
80104a48:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104a4b:	0f 94 c0             	sete   %al
80104a4e:	0f b6 c0             	movzbl %al,%eax
80104a51:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104a53:	83 ec 0c             	sub    $0xc,%esp
80104a56:	56                   	push   %esi
80104a57:	e8 24 02 00 00       	call   80104c80 <release>
  return r;
}
80104a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a5f:	89 f8                	mov    %edi,%eax
80104a61:	5b                   	pop    %ebx
80104a62:	5e                   	pop    %esi
80104a63:	5f                   	pop    %edi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104a7f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104a82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret    
80104a8b:	90                   	nop
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a94:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a9a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104a9d:	31 c0                	xor    %eax,%eax
80104a9f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104aa0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104aa6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aac:	77 1a                	ja     80104ac8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aae:	8b 5a 04             	mov    0x4(%edx),%ebx
80104ab1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ab4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104ab7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ab9:	83 f8 0a             	cmp    $0xa,%eax
80104abc:	75 e2                	jne    80104aa0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104abe:	5b                   	pop    %ebx
80104abf:	5d                   	pop    %ebp
80104ac0:	c3                   	ret    
80104ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104ac8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104acf:	83 c0 01             	add    $0x1,%eax
80104ad2:	83 f8 0a             	cmp    $0xa,%eax
80104ad5:	74 e7                	je     80104abe <getcallerpcs+0x2e>
    pcs[i] = 0;
80104ad7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ade:	83 c0 01             	add    $0x1,%eax
80104ae1:	83 f8 0a             	cmp    $0xa,%eax
80104ae4:	75 e2                	jne    80104ac8 <getcallerpcs+0x38>
80104ae6:	eb d6                	jmp    80104abe <getcallerpcs+0x2e>
80104ae8:	90                   	nop
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104af0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
80104af7:	9c                   	pushf  
80104af8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104af9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104afa:	e8 f1 ec ff ff       	call   801037f0 <mycpu>
80104aff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b05:	85 c0                	test   %eax,%eax
80104b07:	75 11                	jne    80104b1a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b09:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b0f:	e8 dc ec ff ff       	call   801037f0 <mycpu>
80104b14:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b1a:	e8 d1 ec ff ff       	call   801037f0 <mycpu>
80104b1f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b26:	83 c4 04             	add    $0x4,%esp
80104b29:	5b                   	pop    %ebx
80104b2a:	5d                   	pop    %ebp
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b30 <popcli>:

void
popcli(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b36:	9c                   	pushf  
80104b37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b38:	f6 c4 02             	test   $0x2,%ah
80104b3b:	75 52                	jne    80104b8f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b3d:	e8 ae ec ff ff       	call   801037f0 <mycpu>
80104b42:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104b48:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104b4b:	85 d2                	test   %edx,%edx
80104b4d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b53:	78 2d                	js     80104b82 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b55:	e8 96 ec ff ff       	call   801037f0 <mycpu>
80104b5a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b60:	85 d2                	test   %edx,%edx
80104b62:	74 0c                	je     80104b70 <popcli+0x40>
    sti();
}
80104b64:	c9                   	leave  
80104b65:	c3                   	ret    
80104b66:	8d 76 00             	lea    0x0(%esi),%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b70:	e8 7b ec ff ff       	call   801037f0 <mycpu>
80104b75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b7b:	85 c0                	test   %eax,%eax
80104b7d:	74 e5                	je     80104b64 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104b7f:	fb                   	sti    
    sti();
}
80104b80:	c9                   	leave  
80104b81:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104b82:	83 ec 0c             	sub    $0xc,%esp
80104b85:	68 7a 7f 10 80       	push   $0x80107f7a
80104b8a:	e8 e1 b7 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104b8f:	83 ec 0c             	sub    $0xc,%esp
80104b92:	68 63 7f 10 80       	push   $0x80107f63
80104b97:	e8 d4 b7 ff ff       	call   80100370 <panic>
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
80104ba5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ba8:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104baa:	e8 41 ff ff ff       	call   80104af0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104baf:	8b 06                	mov    (%esi),%eax
80104bb1:	85 c0                	test   %eax,%eax
80104bb3:	74 10                	je     80104bc5 <holding+0x25>
80104bb5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104bb8:	e8 33 ec ff ff       	call   801037f0 <mycpu>
80104bbd:	39 c3                	cmp    %eax,%ebx
80104bbf:	0f 94 c3             	sete   %bl
80104bc2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104bc5:	e8 66 ff ff ff       	call   80104b30 <popcli>
  return r;
}
80104bca:	89 d8                	mov    %ebx,%eax
80104bcc:	5b                   	pop    %ebx
80104bcd:	5e                   	pop    %esi
80104bce:	5d                   	pop    %ebp
80104bcf:	c3                   	ret    

80104bd0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104bd7:	e8 14 ff ff ff       	call   80104af0 <pushcli>
  if(holding(lk))
80104bdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bdf:	83 ec 0c             	sub    $0xc,%esp
80104be2:	53                   	push   %ebx
80104be3:	e8 b8 ff ff ff       	call   80104ba0 <holding>
80104be8:	83 c4 10             	add    $0x10,%esp
80104beb:	85 c0                	test   %eax,%eax
80104bed:	0f 85 7d 00 00 00    	jne    80104c70 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104bf3:	ba 01 00 00 00       	mov    $0x1,%edx
80104bf8:	eb 09                	jmp    80104c03 <acquire+0x33>
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c00:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c03:	89 d0                	mov    %edx,%eax
80104c05:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104c08:	85 c0                	test   %eax,%eax
80104c0a:	75 f4                	jne    80104c00 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104c0c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c14:	e8 d7 eb ff ff       	call   801037f0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104c19:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104c1b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104c1e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c21:	31 c0                	xor    %eax,%eax
80104c23:	90                   	nop
80104c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c28:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104c2e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c34:	77 1a                	ja     80104c50 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c36:	8b 5a 04             	mov    0x4(%edx),%ebx
80104c39:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c3c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104c3f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c41:	83 f8 0a             	cmp    $0xa,%eax
80104c44:	75 e2                	jne    80104c28 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104c46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c49:	c9                   	leave  
80104c4a:	c3                   	ret    
80104c4b:	90                   	nop
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104c50:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104c57:	83 c0 01             	add    $0x1,%eax
80104c5a:	83 f8 0a             	cmp    $0xa,%eax
80104c5d:	74 e7                	je     80104c46 <acquire+0x76>
    pcs[i] = 0;
80104c5f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104c66:	83 c0 01             	add    $0x1,%eax
80104c69:	83 f8 0a             	cmp    $0xa,%eax
80104c6c:	75 e2                	jne    80104c50 <acquire+0x80>
80104c6e:	eb d6                	jmp    80104c46 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104c70:	83 ec 0c             	sub    $0xc,%esp
80104c73:	68 81 7f 10 80       	push   $0x80107f81
80104c78:	e8 f3 b6 ff ff       	call   80100370 <panic>
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi

80104c80 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 10             	sub    $0x10,%esp
80104c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c8a:	53                   	push   %ebx
80104c8b:	e8 10 ff ff ff       	call   80104ba0 <holding>
80104c90:	83 c4 10             	add    $0x10,%esp
80104c93:	85 c0                	test   %eax,%eax
80104c95:	74 22                	je     80104cb9 <release+0x39>
  {
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
    panic("release");}

  lk->pcs[0] = 0;
80104c97:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c9e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104ca5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104caa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb3:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104cb4:	e9 77 fe ff ff       	jmp    80104b30 <popcli>
void
release(struct spinlock *lk)
{
  if(!holding(lk))
  {
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
80104cb9:	50                   	push   %eax
80104cba:	50                   	push   %eax
80104cbb:	ff 73 04             	pushl  0x4(%ebx)
80104cbe:	68 94 7f 10 80       	push   $0x80107f94
80104cc3:	e8 98 b9 ff ff       	call   80100660 <cprintf>
    panic("release");}
80104cc8:	c7 04 24 89 7f 10 80 	movl   $0x80107f89,(%esp)
80104ccf:	e8 9c b6 ff ff       	call   80100370 <panic>
80104cd4:	66 90                	xchg   %ax,%ax
80104cd6:	66 90                	xchg   %ax,%ax
80104cd8:	66 90                	xchg   %ax,%ax
80104cda:	66 90                	xchg   %ax,%ax
80104cdc:	66 90                	xchg   %ax,%ax
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	53                   	push   %ebx
80104ce5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ce8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104ceb:	f6 c2 03             	test   $0x3,%dl
80104cee:	75 05                	jne    80104cf5 <memset+0x15>
80104cf0:	f6 c1 03             	test   $0x3,%cl
80104cf3:	74 13                	je     80104d08 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104cf5:	89 d7                	mov    %edx,%edi
80104cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cfa:	fc                   	cld    
80104cfb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cfd:	5b                   	pop    %ebx
80104cfe:	89 d0                	mov    %edx,%eax
80104d00:	5f                   	pop    %edi
80104d01:	5d                   	pop    %ebp
80104d02:	c3                   	ret    
80104d03:	90                   	nop
80104d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104d08:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104d0c:	c1 e9 02             	shr    $0x2,%ecx
80104d0f:	89 fb                	mov    %edi,%ebx
80104d11:	89 f8                	mov    %edi,%eax
80104d13:	c1 e3 18             	shl    $0x18,%ebx
80104d16:	c1 e0 10             	shl    $0x10,%eax
80104d19:	09 d8                	or     %ebx,%eax
80104d1b:	09 f8                	or     %edi,%eax
80104d1d:	c1 e7 08             	shl    $0x8,%edi
80104d20:	09 f8                	or     %edi,%eax
80104d22:	89 d7                	mov    %edx,%edi
80104d24:	fc                   	cld    
80104d25:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d27:	5b                   	pop    %ebx
80104d28:	89 d0                	mov    %edx,%eax
80104d2a:	5f                   	pop    %edi
80104d2b:	5d                   	pop    %ebp
80104d2c:	c3                   	ret    
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi

80104d30 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	8b 45 10             	mov    0x10(%ebp),%eax
80104d38:	53                   	push   %ebx
80104d39:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d3f:	85 c0                	test   %eax,%eax
80104d41:	74 29                	je     80104d6c <memcmp+0x3c>
    if(*s1 != *s2)
80104d43:	0f b6 13             	movzbl (%ebx),%edx
80104d46:	0f b6 0e             	movzbl (%esi),%ecx
80104d49:	38 d1                	cmp    %dl,%cl
80104d4b:	75 2b                	jne    80104d78 <memcmp+0x48>
80104d4d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104d50:	31 c0                	xor    %eax,%eax
80104d52:	eb 14                	jmp    80104d68 <memcmp+0x38>
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d58:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104d5d:	83 c0 01             	add    $0x1,%eax
80104d60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d64:	38 ca                	cmp    %cl,%dl
80104d66:	75 10                	jne    80104d78 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d68:	39 f8                	cmp    %edi,%eax
80104d6a:	75 ec                	jne    80104d58 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d6c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104d6d:	31 c0                	xor    %eax,%eax
}
80104d6f:	5e                   	pop    %esi
80104d70:	5f                   	pop    %edi
80104d71:	5d                   	pop    %ebp
80104d72:	c3                   	ret    
80104d73:	90                   	nop
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104d78:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104d7b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104d7c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104d7e:	5e                   	pop    %esi
80104d7f:	5f                   	pop    %edi
80104d80:	5d                   	pop    %ebp
80104d81:	c3                   	ret    
80104d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	8b 45 08             	mov    0x8(%ebp),%eax
80104d98:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d9e:	39 c6                	cmp    %eax,%esi
80104da0:	73 2e                	jae    80104dd0 <memmove+0x40>
80104da2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104da5:	39 c8                	cmp    %ecx,%eax
80104da7:	73 27                	jae    80104dd0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104da9:	85 db                	test   %ebx,%ebx
80104dab:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104dae:	74 17                	je     80104dc7 <memmove+0x37>
      *--d = *--s;
80104db0:	29 d9                	sub    %ebx,%ecx
80104db2:	89 cb                	mov    %ecx,%ebx
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104db8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104dbc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104dbf:	83 ea 01             	sub    $0x1,%edx
80104dc2:	83 fa ff             	cmp    $0xffffffff,%edx
80104dc5:	75 f1                	jne    80104db8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104dc7:	5b                   	pop    %ebx
80104dc8:	5e                   	pop    %esi
80104dc9:	5d                   	pop    %ebp
80104dca:	c3                   	ret    
80104dcb:	90                   	nop
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104dd0:	31 d2                	xor    %edx,%edx
80104dd2:	85 db                	test   %ebx,%ebx
80104dd4:	74 f1                	je     80104dc7 <memmove+0x37>
80104dd6:	8d 76 00             	lea    0x0(%esi),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104de0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104de4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104de7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104dea:	39 d3                	cmp    %edx,%ebx
80104dec:	75 f2                	jne    80104de0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104dee:	5b                   	pop    %ebx
80104def:	5e                   	pop    %esi
80104df0:	5d                   	pop    %ebp
80104df1:	c3                   	ret    
80104df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e03:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104e04:	eb 8a                	jmp    80104d90 <memmove>
80104e06:	8d 76 00             	lea    0x0(%esi),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	56                   	push   %esi
80104e15:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e18:	53                   	push   %ebx
80104e19:	8b 7d 08             	mov    0x8(%ebp),%edi
80104e1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104e1f:	85 c9                	test   %ecx,%ecx
80104e21:	74 37                	je     80104e5a <strncmp+0x4a>
80104e23:	0f b6 17             	movzbl (%edi),%edx
80104e26:	0f b6 1e             	movzbl (%esi),%ebx
80104e29:	84 d2                	test   %dl,%dl
80104e2b:	74 3f                	je     80104e6c <strncmp+0x5c>
80104e2d:	38 d3                	cmp    %dl,%bl
80104e2f:	75 3b                	jne    80104e6c <strncmp+0x5c>
80104e31:	8d 47 01             	lea    0x1(%edi),%eax
80104e34:	01 cf                	add    %ecx,%edi
80104e36:	eb 1b                	jmp    80104e53 <strncmp+0x43>
80104e38:	90                   	nop
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e40:	0f b6 10             	movzbl (%eax),%edx
80104e43:	84 d2                	test   %dl,%dl
80104e45:	74 21                	je     80104e68 <strncmp+0x58>
80104e47:	0f b6 19             	movzbl (%ecx),%ebx
80104e4a:	83 c0 01             	add    $0x1,%eax
80104e4d:	89 ce                	mov    %ecx,%esi
80104e4f:	38 da                	cmp    %bl,%dl
80104e51:	75 19                	jne    80104e6c <strncmp+0x5c>
80104e53:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104e55:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104e58:	75 e6                	jne    80104e40 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e5a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104e5b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104e5d:	5e                   	pop    %esi
80104e5e:	5f                   	pop    %edi
80104e5f:	5d                   	pop    %ebp
80104e60:	c3                   	ret    
80104e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e68:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e6c:	0f b6 c2             	movzbl %dl,%eax
80104e6f:	29 d8                	sub    %ebx,%eax
}
80104e71:	5b                   	pop    %ebx
80104e72:	5e                   	pop    %esi
80104e73:	5f                   	pop    %edi
80104e74:	5d                   	pop    %ebp
80104e75:	c3                   	ret    
80104e76:	8d 76 00             	lea    0x0(%esi),%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	8b 45 08             	mov    0x8(%ebp),%eax
80104e88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e8e:	89 c2                	mov    %eax,%edx
80104e90:	eb 19                	jmp    80104eab <strncpy+0x2b>
80104e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e98:	83 c3 01             	add    $0x1,%ebx
80104e9b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e9f:	83 c2 01             	add    $0x1,%edx
80104ea2:	84 c9                	test   %cl,%cl
80104ea4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ea7:	74 09                	je     80104eb2 <strncpy+0x32>
80104ea9:	89 f1                	mov    %esi,%ecx
80104eab:	85 c9                	test   %ecx,%ecx
80104ead:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104eb0:	7f e6                	jg     80104e98 <strncpy+0x18>
    ;
  while(n-- > 0)
80104eb2:	31 c9                	xor    %ecx,%ecx
80104eb4:	85 f6                	test   %esi,%esi
80104eb6:	7e 17                	jle    80104ecf <strncpy+0x4f>
80104eb8:	90                   	nop
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ec0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ec4:	89 f3                	mov    %esi,%ebx
80104ec6:	83 c1 01             	add    $0x1,%ecx
80104ec9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104ecb:	85 db                	test   %ebx,%ebx
80104ecd:	7f f1                	jg     80104ec0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104ecf:	5b                   	pop    %ebx
80104ed0:	5e                   	pop    %esi
80104ed1:	5d                   	pop    %ebp
80104ed2:	c3                   	ret    
80104ed3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80104eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104eee:	85 c9                	test   %ecx,%ecx
80104ef0:	7e 26                	jle    80104f18 <safestrcpy+0x38>
80104ef2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ef6:	89 c1                	mov    %eax,%ecx
80104ef8:	eb 17                	jmp    80104f11 <safestrcpy+0x31>
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f00:	83 c2 01             	add    $0x1,%edx
80104f03:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f07:	83 c1 01             	add    $0x1,%ecx
80104f0a:	84 db                	test   %bl,%bl
80104f0c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f0f:	74 04                	je     80104f15 <safestrcpy+0x35>
80104f11:	39 f2                	cmp    %esi,%edx
80104f13:	75 eb                	jne    80104f00 <safestrcpy+0x20>
    ;
  *s = 0;
80104f15:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f18:	5b                   	pop    %ebx
80104f19:	5e                   	pop    %esi
80104f1a:	5d                   	pop    %ebp
80104f1b:	c3                   	ret    
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f20 <strlen>:

int
strlen(const char *s)
{
80104f20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f21:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104f23:	89 e5                	mov    %esp,%ebp
80104f25:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104f28:	80 3a 00             	cmpb   $0x0,(%edx)
80104f2b:	74 0c                	je     80104f39 <strlen+0x19>
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	83 c0 01             	add    $0x1,%eax
80104f33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f37:	75 f7                	jne    80104f30 <strlen+0x10>
    ;
  return n;
}
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    

80104f3b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f43:	55                   	push   %ebp
  pushl %ebx
80104f44:	53                   	push   %ebx
  pushl %esi
80104f45:	56                   	push   %esi
  pushl %edi
80104f46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f49:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f4b:	5f                   	pop    %edi
  popl %esi
80104f4c:	5e                   	pop    %esi
  popl %ebx
80104f4d:	5b                   	pop    %ebx
  popl %ebp
80104f4e:	5d                   	pop    %ebp
  ret
80104f4f:	c3                   	ret    

80104f50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 04             	sub    $0x4,%esp
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f5a:	e8 31 e9 ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f5f:	8b 00                	mov    (%eax),%eax
80104f61:	39 d8                	cmp    %ebx,%eax
80104f63:	76 1b                	jbe    80104f80 <fetchint+0x30>
80104f65:	8d 53 04             	lea    0x4(%ebx),%edx
80104f68:	39 d0                	cmp    %edx,%eax
80104f6a:	72 14                	jb     80104f80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f6f:	8b 13                	mov    (%ebx),%edx
80104f71:	89 10                	mov    %edx,(%eax)
  return 0;
80104f73:	31 c0                	xor    %eax,%eax
}
80104f75:	83 c4 04             	add    $0x4,%esp
80104f78:	5b                   	pop    %ebx
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    
80104f7b:	90                   	nop
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f85:	eb ee                	jmp    80104f75 <fetchint+0x25>
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	53                   	push   %ebx
80104f94:	83 ec 04             	sub    $0x4,%esp
80104f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f9a:	e8 f1 e8 ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz)
80104f9f:	39 18                	cmp    %ebx,(%eax)
80104fa1:	76 29                	jbe    80104fcc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104fa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104fa6:	89 da                	mov    %ebx,%edx
80104fa8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104faa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104fac:	39 c3                	cmp    %eax,%ebx
80104fae:	73 1c                	jae    80104fcc <fetchstr+0x3c>
    if(*s == 0)
80104fb0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104fb3:	75 10                	jne    80104fc5 <fetchstr+0x35>
80104fb5:	eb 29                	jmp    80104fe0 <fetchstr+0x50>
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fc0:	80 3a 00             	cmpb   $0x0,(%edx)
80104fc3:	74 1b                	je     80104fe0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104fc5:	83 c2 01             	add    $0x1,%edx
80104fc8:	39 d0                	cmp    %edx,%eax
80104fca:	77 f4                	ja     80104fc0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104fcc:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104fcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104fd4:	5b                   	pop    %ebx
80104fd5:	5d                   	pop    %ebp
80104fd6:	c3                   	ret    
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fe0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104fe3:	89 d0                	mov    %edx,%eax
80104fe5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104fe7:	5b                   	pop    %ebx
80104fe8:	5d                   	pop    %ebp
80104fe9:	c3                   	ret    
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ff0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80104ff5:	e8 c6 e8 ff ff       	call   801038c0 <mythread>
80104ffa:	8b 40 10             	mov    0x10(%eax),%eax
80104ffd:	8b 55 08             	mov    0x8(%ebp),%edx
80105000:	8b 40 44             	mov    0x44(%eax),%eax
80105003:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80105006:	e8 85 e8 ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010500b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
8010500d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105010:	39 c6                	cmp    %eax,%esi
80105012:	73 1c                	jae    80105030 <argint+0x40>
80105014:	8d 53 08             	lea    0x8(%ebx),%edx
80105017:	39 d0                	cmp    %edx,%eax
80105019:	72 15                	jb     80105030 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
8010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501e:	8b 53 04             	mov    0x4(%ebx),%edx
80105021:	89 10                	mov    %edx,(%eax)
  return 0;
80105023:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
}
80105025:	5b                   	pop    %ebx
80105026:	5e                   	pop    %esi
80105027:	5d                   	pop    %ebp
80105028:	c3                   	ret    
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	eb ee                	jmp    80105025 <argint+0x35>
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
80105045:	83 ec 10             	sub    $0x10,%esp
80105048:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010504b:	e8 40 e8 ff ff       	call   80103890 <myproc>
80105050:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105052:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105055:	83 ec 08             	sub    $0x8,%esp
80105058:	50                   	push   %eax
80105059:	ff 75 08             	pushl  0x8(%ebp)
8010505c:	e8 8f ff ff ff       	call   80104ff0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105061:	c1 e8 1f             	shr    $0x1f,%eax
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	84 c0                	test   %al,%al
80105069:	75 2d                	jne    80105098 <argptr+0x58>
8010506b:	89 d8                	mov    %ebx,%eax
8010506d:	c1 e8 1f             	shr    $0x1f,%eax
80105070:	84 c0                	test   %al,%al
80105072:	75 24                	jne    80105098 <argptr+0x58>
80105074:	8b 16                	mov    (%esi),%edx
80105076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105079:	39 c2                	cmp    %eax,%edx
8010507b:	76 1b                	jbe    80105098 <argptr+0x58>
8010507d:	01 c3                	add    %eax,%ebx
8010507f:	39 da                	cmp    %ebx,%edx
80105081:	72 15                	jb     80105098 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80105083:	8b 55 0c             	mov    0xc(%ebp),%edx
80105086:	89 02                	mov    %eax,(%edx)
  return 0;
80105088:	31 c0                	xor    %eax,%eax
}
8010508a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010508d:	5b                   	pop    %ebx
8010508e:	5e                   	pop    %esi
8010508f:	5d                   	pop    %ebp
80105090:	c3                   	ret    
80105091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb eb                	jmp    8010508a <argptr+0x4a>
8010509f:	90                   	nop

801050a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050a9:	50                   	push   %eax
801050aa:	ff 75 08             	pushl  0x8(%ebp)
801050ad:	e8 3e ff ff ff       	call   80104ff0 <argint>
801050b2:	83 c4 10             	add    $0x10,%esp
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 17                	js     801050d0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801050b9:	83 ec 08             	sub    $0x8,%esp
801050bc:	ff 75 0c             	pushl  0xc(%ebp)
801050bf:	ff 75 f4             	pushl  -0xc(%ebp)
801050c2:	e8 c9 fe ff ff       	call   80104f90 <fetchstr>
801050c7:	83 c4 10             	add    $0x10,%esp
}
801050ca:	c9                   	leave  
801050cb:	c3                   	ret    
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <syscall>:
[SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
801050e5:	53                   	push   %ebx
801050e6:	83 ec 0c             	sub    $0xc,%esp
  int num;
  struct proc *curproc = myproc();
801050e9:	e8 a2 e7 ff ff       	call   80103890 <myproc>
801050ee:	89 c7                	mov    %eax,%edi
  struct thread *curthread = mythread();
801050f0:	e8 cb e7 ff ff       	call   801038c0 <mythread>

  num = curthread->tf->eax;
801050f5:	8b 70 10             	mov    0x10(%eax),%esi
void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
  struct thread *curthread = mythread();
801050f8:	89 c3                	mov    %eax,%ebx

  num = curthread->tf->eax;
801050fa:	8b 56 1c             	mov    0x1c(%esi),%edx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050fd:	8d 42 ff             	lea    -0x1(%edx),%eax
80105100:	83 f8 18             	cmp    $0x18,%eax
80105103:	77 1b                	ja     80105120 <syscall+0x40>
80105105:	8b 04 95 e0 7f 10 80 	mov    -0x7fef8020(,%edx,4),%eax
8010510c:	85 c0                	test   %eax,%eax
8010510e:	74 10                	je     80105120 <syscall+0x40>
    curthread->tf->eax = syscalls[num]();
80105110:	ff d0                	call   *%eax
80105112:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
  }
}
80105115:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105118:	5b                   	pop    %ebx
80105119:	5e                   	pop    %esi
8010511a:	5f                   	pop    %edi
8010511b:	5d                   	pop    %ebp
8010511c:	c3                   	ret    
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
  num = curthread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curthread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105120:	8d 47 64             	lea    0x64(%edi),%eax

  num = curthread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curthread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105123:	52                   	push   %edx
80105124:	50                   	push   %eax
80105125:	ff 77 0c             	pushl  0xc(%edi)
80105128:	68 b6 7f 10 80       	push   $0x80107fb6
8010512d:	e8 2e b5 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
80105132:	8b 43 10             	mov    0x10(%ebx),%eax
80105135:	83 c4 10             	add    $0x10,%esp
80105138:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010513f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105142:	5b                   	pop    %ebx
80105143:	5e                   	pop    %esi
80105144:	5f                   	pop    %edi
80105145:	5d                   	pop    %ebp
80105146:	c3                   	ret    
80105147:	66 90                	xchg   %ax,%ax
80105149:	66 90                	xchg   %ax,%ax
8010514b:	66 90                	xchg   %ax,%ax
8010514d:	66 90                	xchg   %ax,%ax
8010514f:	90                   	nop

80105150 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	56                   	push   %esi
80105155:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105156:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105159:	83 ec 44             	sub    $0x44,%esp
8010515c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010515f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105162:	56                   	push   %esi
80105163:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105164:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105167:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010516a:	e8 81 cd ff ff       	call   80101ef0 <nameiparent>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	85 c0                	test   %eax,%eax
80105174:	0f 84 f6 00 00 00    	je     80105270 <create+0x120>
    return 0;
  ilock(dp);
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	89 c7                	mov    %eax,%edi
8010517f:	50                   	push   %eax
80105180:	e8 fb c4 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105185:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105188:	83 c4 0c             	add    $0xc,%esp
8010518b:	50                   	push   %eax
8010518c:	56                   	push   %esi
8010518d:	57                   	push   %edi
8010518e:	e8 1d ca ff ff       	call   80101bb0 <dirlookup>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	85 c0                	test   %eax,%eax
80105198:	89 c3                	mov    %eax,%ebx
8010519a:	74 54                	je     801051f0 <create+0xa0>
    iunlockput(dp);
8010519c:	83 ec 0c             	sub    $0xc,%esp
8010519f:	57                   	push   %edi
801051a0:	e8 6b c7 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
801051a5:	89 1c 24             	mov    %ebx,(%esp)
801051a8:	e8 d3 c4 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051ad:	83 c4 10             	add    $0x10,%esp
801051b0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801051b5:	75 19                	jne    801051d0 <create+0x80>
801051b7:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801051bc:	89 d8                	mov    %ebx,%eax
801051be:	75 10                	jne    801051d0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c3:	5b                   	pop    %ebx
801051c4:	5e                   	pop    %esi
801051c5:	5f                   	pop    %edi
801051c6:	5d                   	pop    %ebp
801051c7:	c3                   	ret    
801051c8:	90                   	nop
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	53                   	push   %ebx
801051d4:	e8 37 c7 ff ff       	call   80101910 <iunlockput>
    return 0;
801051d9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801051df:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051e1:	5b                   	pop    %ebx
801051e2:	5e                   	pop    %esi
801051e3:	5f                   	pop    %edi
801051e4:	5d                   	pop    %ebp
801051e5:	c3                   	ret    
801051e6:	8d 76 00             	lea    0x0(%esi),%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801051f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801051f4:	83 ec 08             	sub    $0x8,%esp
801051f7:	50                   	push   %eax
801051f8:	ff 37                	pushl  (%edi)
801051fa:	e8 11 c3 ff ff       	call   80101510 <ialloc>
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	85 c0                	test   %eax,%eax
80105204:	89 c3                	mov    %eax,%ebx
80105206:	0f 84 cc 00 00 00    	je     801052d8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010520c:	83 ec 0c             	sub    $0xc,%esp
8010520f:	50                   	push   %eax
80105210:	e8 6b c4 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105215:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105219:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010521d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105221:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105225:	b8 01 00 00 00       	mov    $0x1,%eax
8010522a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010522e:	89 1c 24             	mov    %ebx,(%esp)
80105231:	e8 9a c3 ff ff       	call   801015d0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105236:	83 c4 10             	add    $0x10,%esp
80105239:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010523e:	74 40                	je     80105280 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105240:	83 ec 04             	sub    $0x4,%esp
80105243:	ff 73 04             	pushl  0x4(%ebx)
80105246:	56                   	push   %esi
80105247:	57                   	push   %edi
80105248:	e8 c3 cb ff ff       	call   80101e10 <dirlink>
8010524d:	83 c4 10             	add    $0x10,%esp
80105250:	85 c0                	test   %eax,%eax
80105252:	78 77                	js     801052cb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	57                   	push   %edi
80105258:	e8 b3 c6 ff ff       	call   80101910 <iunlockput>

  return ip;
8010525d:	83 c4 10             	add    $0x10,%esp
}
80105260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105263:	89 d8                	mov    %ebx,%eax
}
80105265:	5b                   	pop    %ebx
80105266:	5e                   	pop    %esi
80105267:	5f                   	pop    %edi
80105268:	5d                   	pop    %ebp
80105269:	c3                   	ret    
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105270:	31 c0                	xor    %eax,%eax
80105272:	e9 49 ff ff ff       	jmp    801051c0 <create+0x70>
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105280:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105285:	83 ec 0c             	sub    $0xc,%esp
80105288:	57                   	push   %edi
80105289:	e8 42 c3 ff ff       	call   801015d0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010528e:	83 c4 0c             	add    $0xc,%esp
80105291:	ff 73 04             	pushl  0x4(%ebx)
80105294:	68 64 80 10 80       	push   $0x80108064
80105299:	53                   	push   %ebx
8010529a:	e8 71 cb ff ff       	call   80101e10 <dirlink>
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	85 c0                	test   %eax,%eax
801052a4:	78 18                	js     801052be <create+0x16e>
801052a6:	83 ec 04             	sub    $0x4,%esp
801052a9:	ff 77 04             	pushl  0x4(%edi)
801052ac:	68 63 80 10 80       	push   $0x80108063
801052b1:	53                   	push   %ebx
801052b2:	e8 59 cb ff ff       	call   80101e10 <dirlink>
801052b7:	83 c4 10             	add    $0x10,%esp
801052ba:	85 c0                	test   %eax,%eax
801052bc:	79 82                	jns    80105240 <create+0xf0>
      panic("create dots");
801052be:	83 ec 0c             	sub    $0xc,%esp
801052c1:	68 57 80 10 80       	push   $0x80108057
801052c6:	e8 a5 b0 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801052cb:	83 ec 0c             	sub    $0xc,%esp
801052ce:	68 66 80 10 80       	push   $0x80108066
801052d3:	e8 98 b0 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801052d8:	83 ec 0c             	sub    $0xc,%esp
801052db:	68 48 80 10 80       	push   $0x80108048
801052e0:	e8 8b b0 ff ff       	call   80100370 <panic>
801052e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801052f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801052fa:	89 d3                	mov    %edx,%ebx
801052fc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801052ff:	50                   	push   %eax
80105300:	6a 00                	push   $0x0
80105302:	e8 e9 fc ff ff       	call   80104ff0 <argint>
80105307:	83 c4 10             	add    $0x10,%esp
8010530a:	85 c0                	test   %eax,%eax
8010530c:	78 32                	js     80105340 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010530e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105312:	77 2c                	ja     80105340 <argfd.constprop.0+0x50>
80105314:	e8 77 e5 ff ff       	call   80103890 <myproc>
80105319:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010531c:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
80105320:	85 c0                	test   %eax,%eax
80105322:	74 1c                	je     80105340 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105324:	85 f6                	test   %esi,%esi
80105326:	74 02                	je     8010532a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105328:	89 16                	mov    %edx,(%esi)
  if(pf)
8010532a:	85 db                	test   %ebx,%ebx
8010532c:	74 22                	je     80105350 <argfd.constprop.0+0x60>
    *pf = f;
8010532e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105330:	31 c0                	xor    %eax,%eax
}
80105332:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105335:	5b                   	pop    %ebx
80105336:	5e                   	pop    %esi
80105337:	5d                   	pop    %ebp
80105338:	c3                   	ret    
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105340:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105348:	5b                   	pop    %ebx
80105349:	5e                   	pop    %esi
8010534a:	5d                   	pop    %ebp
8010534b:	c3                   	ret    
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105350:	31 c0                	xor    %eax,%eax
80105352:	eb de                	jmp    80105332 <argfd.constprop.0+0x42>
80105354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010535a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105360 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105360:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105361:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105363:	89 e5                	mov    %esp,%ebp
80105365:	56                   	push   %esi
80105366:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105367:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010536a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010536d:	e8 7e ff ff ff       	call   801052f0 <argfd.constprop.0>
80105372:	85 c0                	test   %eax,%eax
80105374:	78 1a                	js     80105390 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105376:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105378:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010537b:	e8 10 e5 ff ff       	call   80103890 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105380:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105384:	85 d2                	test   %edx,%edx
80105386:	74 18                	je     801053a0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105388:	83 c3 01             	add    $0x1,%ebx
8010538b:	83 fb 10             	cmp    $0x10,%ebx
8010538e:	75 f0                	jne    80105380 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105390:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105398:	5b                   	pop    %ebx
80105399:	5e                   	pop    %esi
8010539a:	5d                   	pop    %ebp
8010539b:	c3                   	ret    
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801053a0:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801053a4:	83 ec 0c             	sub    $0xc,%esp
801053a7:	ff 75 f4             	pushl  -0xc(%ebp)
801053aa:	e8 41 ba ff ff       	call   80100df0 <filedup>
  return fd;
801053af:	83 c4 10             	add    $0x10,%esp
}
801053b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801053b5:	89 d8                	mov    %ebx,%eax
}
801053b7:	5b                   	pop    %ebx
801053b8:	5e                   	pop    %esi
801053b9:	5d                   	pop    %ebp
801053ba:	c3                   	ret    
801053bb:	90                   	nop
801053bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_read>:

int
sys_read(void)
{
801053c0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053c1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
801053c3:	89 e5                	mov    %esp,%ebp
801053c5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053cb:	e8 20 ff ff ff       	call   801052f0 <argfd.constprop.0>
801053d0:	85 c0                	test   %eax,%eax
801053d2:	78 4c                	js     80105420 <sys_read+0x60>
801053d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d7:	83 ec 08             	sub    $0x8,%esp
801053da:	50                   	push   %eax
801053db:	6a 02                	push   $0x2
801053dd:	e8 0e fc ff ff       	call   80104ff0 <argint>
801053e2:	83 c4 10             	add    $0x10,%esp
801053e5:	85 c0                	test   %eax,%eax
801053e7:	78 37                	js     80105420 <sys_read+0x60>
801053e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ec:	83 ec 04             	sub    $0x4,%esp
801053ef:	ff 75 f0             	pushl  -0x10(%ebp)
801053f2:	50                   	push   %eax
801053f3:	6a 01                	push   $0x1
801053f5:	e8 46 fc ff ff       	call   80105040 <argptr>
801053fa:	83 c4 10             	add    $0x10,%esp
801053fd:	85 c0                	test   %eax,%eax
801053ff:	78 1f                	js     80105420 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105401:	83 ec 04             	sub    $0x4,%esp
80105404:	ff 75 f0             	pushl  -0x10(%ebp)
80105407:	ff 75 f4             	pushl  -0xc(%ebp)
8010540a:	ff 75 ec             	pushl  -0x14(%ebp)
8010540d:	e8 4e bb ff ff       	call   80100f60 <fileread>
80105412:	83 c4 10             	add    $0x10,%esp
}
80105415:	c9                   	leave  
80105416:	c3                   	ret    
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105425:	c9                   	leave  
80105426:	c3                   	ret    
80105427:	89 f6                	mov    %esi,%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <sys_write>:

int
sys_write(void)
{
80105430:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105431:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105433:	89 e5                	mov    %esp,%ebp
80105435:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105438:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010543b:	e8 b0 fe ff ff       	call   801052f0 <argfd.constprop.0>
80105440:	85 c0                	test   %eax,%eax
80105442:	78 4c                	js     80105490 <sys_write+0x60>
80105444:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105447:	83 ec 08             	sub    $0x8,%esp
8010544a:	50                   	push   %eax
8010544b:	6a 02                	push   $0x2
8010544d:	e8 9e fb ff ff       	call   80104ff0 <argint>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	85 c0                	test   %eax,%eax
80105457:	78 37                	js     80105490 <sys_write+0x60>
80105459:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010545c:	83 ec 04             	sub    $0x4,%esp
8010545f:	ff 75 f0             	pushl  -0x10(%ebp)
80105462:	50                   	push   %eax
80105463:	6a 01                	push   $0x1
80105465:	e8 d6 fb ff ff       	call   80105040 <argptr>
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	85 c0                	test   %eax,%eax
8010546f:	78 1f                	js     80105490 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105471:	83 ec 04             	sub    $0x4,%esp
80105474:	ff 75 f0             	pushl  -0x10(%ebp)
80105477:	ff 75 f4             	pushl  -0xc(%ebp)
8010547a:	ff 75 ec             	pushl  -0x14(%ebp)
8010547d:	e8 6e bb ff ff       	call   80100ff0 <filewrite>
80105482:	83 c4 10             	add    $0x10,%esp
}
80105485:	c9                   	leave  
80105486:	c3                   	ret    
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105495:	c9                   	leave  
80105496:	c3                   	ret    
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <sys_close>:

int
sys_close(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801054a6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ac:	e8 3f fe ff ff       	call   801052f0 <argfd.constprop.0>
801054b1:	85 c0                	test   %eax,%eax
801054b3:	78 2b                	js     801054e0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801054b5:	e8 d6 e3 ff ff       	call   80103890 <myproc>
801054ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054bd:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
801054c0:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
801054c7:	00 
  fileclose(f);
801054c8:	ff 75 f4             	pushl  -0xc(%ebp)
801054cb:	e8 70 b9 ff ff       	call   80100e40 <fileclose>
  return 0;
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	31 c0                	xor    %eax,%eax
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801054e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801054e5:	c9                   	leave  
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <sys_fstat>:

int
sys_fstat(void)
{
801054f0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054f1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801054f3:	89 e5                	mov    %esp,%ebp
801054f5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054fb:	e8 f0 fd ff ff       	call   801052f0 <argfd.constprop.0>
80105500:	85 c0                	test   %eax,%eax
80105502:	78 2c                	js     80105530 <sys_fstat+0x40>
80105504:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105507:	83 ec 04             	sub    $0x4,%esp
8010550a:	6a 14                	push   $0x14
8010550c:	50                   	push   %eax
8010550d:	6a 01                	push   $0x1
8010550f:	e8 2c fb ff ff       	call   80105040 <argptr>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	78 15                	js     80105530 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010551b:	83 ec 08             	sub    $0x8,%esp
8010551e:	ff 75 f4             	pushl  -0xc(%ebp)
80105521:	ff 75 f0             	pushl  -0x10(%ebp)
80105524:	e8 e7 b9 ff ff       	call   80100f10 <filestat>
80105529:	83 c4 10             	add    $0x10,%esp
}
8010552c:	c9                   	leave  
8010552d:	c3                   	ret    
8010552e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105535:	c9                   	leave  
80105536:	c3                   	ret    
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
80105545:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105546:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105549:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010554c:	50                   	push   %eax
8010554d:	6a 00                	push   $0x0
8010554f:	e8 4c fb ff ff       	call   801050a0 <argstr>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	0f 88 fb 00 00 00    	js     8010565a <sys_link+0x11a>
8010555f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105562:	83 ec 08             	sub    $0x8,%esp
80105565:	50                   	push   %eax
80105566:	6a 01                	push   $0x1
80105568:	e8 33 fb ff ff       	call   801050a0 <argstr>
8010556d:	83 c4 10             	add    $0x10,%esp
80105570:	85 c0                	test   %eax,%eax
80105572:	0f 88 e2 00 00 00    	js     8010565a <sys_link+0x11a>
    return -1;

  begin_op();
80105578:	e8 e3 d5 ff ff       	call   80102b60 <begin_op>
  if((ip = namei(old)) == 0){
8010557d:	83 ec 0c             	sub    $0xc,%esp
80105580:	ff 75 d4             	pushl  -0x2c(%ebp)
80105583:	e8 48 c9 ff ff       	call   80101ed0 <namei>
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	85 c0                	test   %eax,%eax
8010558d:	89 c3                	mov    %eax,%ebx
8010558f:	0f 84 f3 00 00 00    	je     80105688 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105595:	83 ec 0c             	sub    $0xc,%esp
80105598:	50                   	push   %eax
80105599:	e8 e2 c0 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055a6:	0f 84 c4 00 00 00    	je     80105670 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801055ac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801055b1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801055b4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801055b7:	53                   	push   %ebx
801055b8:	e8 13 c0 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
801055bd:	89 1c 24             	mov    %ebx,(%esp)
801055c0:	e8 9b c1 ff ff       	call   80101760 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801055c5:	58                   	pop    %eax
801055c6:	5a                   	pop    %edx
801055c7:	57                   	push   %edi
801055c8:	ff 75 d0             	pushl  -0x30(%ebp)
801055cb:	e8 20 c9 ff ff       	call   80101ef0 <nameiparent>
801055d0:	83 c4 10             	add    $0x10,%esp
801055d3:	85 c0                	test   %eax,%eax
801055d5:	89 c6                	mov    %eax,%esi
801055d7:	74 5b                	je     80105634 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801055d9:	83 ec 0c             	sub    $0xc,%esp
801055dc:	50                   	push   %eax
801055dd:	e8 9e c0 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	8b 03                	mov    (%ebx),%eax
801055e7:	39 06                	cmp    %eax,(%esi)
801055e9:	75 3d                	jne    80105628 <sys_link+0xe8>
801055eb:	83 ec 04             	sub    $0x4,%esp
801055ee:	ff 73 04             	pushl  0x4(%ebx)
801055f1:	57                   	push   %edi
801055f2:	56                   	push   %esi
801055f3:	e8 18 c8 ff ff       	call   80101e10 <dirlink>
801055f8:	83 c4 10             	add    $0x10,%esp
801055fb:	85 c0                	test   %eax,%eax
801055fd:	78 29                	js     80105628 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801055ff:	83 ec 0c             	sub    $0xc,%esp
80105602:	56                   	push   %esi
80105603:	e8 08 c3 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105608:	89 1c 24             	mov    %ebx,(%esp)
8010560b:	e8 a0 c1 ff ff       	call   801017b0 <iput>

  end_op();
80105610:	e8 bb d5 ff ff       	call   80102bd0 <end_op>

  return 0;
80105615:	83 c4 10             	add    $0x10,%esp
80105618:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010561a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010561d:	5b                   	pop    %ebx
8010561e:	5e                   	pop    %esi
8010561f:	5f                   	pop    %edi
80105620:	5d                   	pop    %ebp
80105621:	c3                   	ret    
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	56                   	push   %esi
8010562c:	e8 df c2 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105631:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105634:	83 ec 0c             	sub    $0xc,%esp
80105637:	53                   	push   %ebx
80105638:	e8 43 c0 ff ff       	call   80101680 <ilock>
  ip->nlink--;
8010563d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105642:	89 1c 24             	mov    %ebx,(%esp)
80105645:	e8 86 bf ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010564a:	89 1c 24             	mov    %ebx,(%esp)
8010564d:	e8 be c2 ff ff       	call   80101910 <iunlockput>
  end_op();
80105652:	e8 79 d5 ff ff       	call   80102bd0 <end_op>
  return -1;
80105657:	83 c4 10             	add    $0x10,%esp
}
8010565a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010565d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105662:	5b                   	pop    %ebx
80105663:	5e                   	pop    %esi
80105664:	5f                   	pop    %edi
80105665:	5d                   	pop    %ebp
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	53                   	push   %ebx
80105674:	e8 97 c2 ff ff       	call   80101910 <iunlockput>
    end_op();
80105679:	e8 52 d5 ff ff       	call   80102bd0 <end_op>
    return -1;
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105686:	eb 92                	jmp    8010561a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105688:	e8 43 d5 ff ff       	call   80102bd0 <end_op>
    return -1;
8010568d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105692:	eb 86                	jmp    8010561a <sys_link+0xda>
80105694:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010569a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801056a0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
801056a5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801056a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
801056a9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801056ac:	50                   	push   %eax
801056ad:	6a 00                	push   $0x0
801056af:	e8 ec f9 ff ff       	call   801050a0 <argstr>
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	85 c0                	test   %eax,%eax
801056b9:	0f 88 82 01 00 00    	js     80105841 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801056bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
801056c2:	e8 99 d4 ff ff       	call   80102b60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056c7:	83 ec 08             	sub    $0x8,%esp
801056ca:	53                   	push   %ebx
801056cb:	ff 75 c0             	pushl  -0x40(%ebp)
801056ce:	e8 1d c8 ff ff       	call   80101ef0 <nameiparent>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801056db:	0f 84 6a 01 00 00    	je     8010584b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
801056e1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
801056e4:	83 ec 0c             	sub    $0xc,%esp
801056e7:	56                   	push   %esi
801056e8:	e8 93 bf ff ff       	call   80101680 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056ed:	58                   	pop    %eax
801056ee:	5a                   	pop    %edx
801056ef:	68 64 80 10 80       	push   $0x80108064
801056f4:	53                   	push   %ebx
801056f5:	e8 96 c4 ff ff       	call   80101b90 <namecmp>
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	85 c0                	test   %eax,%eax
801056ff:	0f 84 fc 00 00 00    	je     80105801 <sys_unlink+0x161>
80105705:	83 ec 08             	sub    $0x8,%esp
80105708:	68 63 80 10 80       	push   $0x80108063
8010570d:	53                   	push   %ebx
8010570e:	e8 7d c4 ff ff       	call   80101b90 <namecmp>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	85 c0                	test   %eax,%eax
80105718:	0f 84 e3 00 00 00    	je     80105801 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010571e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105721:	83 ec 04             	sub    $0x4,%esp
80105724:	50                   	push   %eax
80105725:	53                   	push   %ebx
80105726:	56                   	push   %esi
80105727:	e8 84 c4 ff ff       	call   80101bb0 <dirlookup>
8010572c:	83 c4 10             	add    $0x10,%esp
8010572f:	85 c0                	test   %eax,%eax
80105731:	89 c3                	mov    %eax,%ebx
80105733:	0f 84 c8 00 00 00    	je     80105801 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	50                   	push   %eax
8010573d:	e8 3e bf ff ff       	call   80101680 <ilock>

  if(ip->nlink < 1)
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010574a:	0f 8e 24 01 00 00    	jle    80105874 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105750:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105755:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105758:	74 66                	je     801057c0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010575a:	83 ec 04             	sub    $0x4,%esp
8010575d:	6a 10                	push   $0x10
8010575f:	6a 00                	push   $0x0
80105761:	56                   	push   %esi
80105762:	e8 79 f5 ff ff       	call   80104ce0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105767:	6a 10                	push   $0x10
80105769:	ff 75 c4             	pushl  -0x3c(%ebp)
8010576c:	56                   	push   %esi
8010576d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105770:	e8 eb c2 ff ff       	call   80101a60 <writei>
80105775:	83 c4 20             	add    $0x20,%esp
80105778:	83 f8 10             	cmp    $0x10,%eax
8010577b:	0f 85 e6 00 00 00    	jne    80105867 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105781:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105786:	0f 84 9c 00 00 00    	je     80105828 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010578c:	83 ec 0c             	sub    $0xc,%esp
8010578f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105792:	e8 79 c1 ff ff       	call   80101910 <iunlockput>

  ip->nlink--;
80105797:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010579c:	89 1c 24             	mov    %ebx,(%esp)
8010579f:	e8 2c be ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801057a4:	89 1c 24             	mov    %ebx,(%esp)
801057a7:	e8 64 c1 ff ff       	call   80101910 <iunlockput>

  end_op();
801057ac:	e8 1f d4 ff ff       	call   80102bd0 <end_op>

  return 0;
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801057b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b9:	5b                   	pop    %ebx
801057ba:	5e                   	pop    %esi
801057bb:	5f                   	pop    %edi
801057bc:	5d                   	pop    %ebp
801057bd:	c3                   	ret    
801057be:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057c4:	76 94                	jbe    8010575a <sys_unlink+0xba>
801057c6:	bf 20 00 00 00       	mov    $0x20,%edi
801057cb:	eb 0f                	jmp    801057dc <sys_unlink+0x13c>
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
801057d0:	83 c7 10             	add    $0x10,%edi
801057d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801057d6:	0f 83 7e ff ff ff    	jae    8010575a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057dc:	6a 10                	push   $0x10
801057de:	57                   	push   %edi
801057df:	56                   	push   %esi
801057e0:	53                   	push   %ebx
801057e1:	e8 7a c1 ff ff       	call   80101960 <readi>
801057e6:	83 c4 10             	add    $0x10,%esp
801057e9:	83 f8 10             	cmp    $0x10,%eax
801057ec:	75 6c                	jne    8010585a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
801057ee:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057f3:	74 db                	je     801057d0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801057f5:	83 ec 0c             	sub    $0xc,%esp
801057f8:	53                   	push   %ebx
801057f9:	e8 12 c1 ff ff       	call   80101910 <iunlockput>
    goto bad;
801057fe:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105801:	83 ec 0c             	sub    $0xc,%esp
80105804:	ff 75 b4             	pushl  -0x4c(%ebp)
80105807:	e8 04 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
8010580c:	e8 bf d3 ff ff       	call   80102bd0 <end_op>
  return -1;
80105811:	83 c4 10             	add    $0x10,%esp
}
80105814:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010581c:	5b                   	pop    %ebx
8010581d:	5e                   	pop    %esi
8010581e:	5f                   	pop    %edi
8010581f:	5d                   	pop    %ebp
80105820:	c3                   	ret    
80105821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105828:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010582b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010582e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105833:	50                   	push   %eax
80105834:	e8 97 bd ff ff       	call   801015d0 <iupdate>
80105839:	83 c4 10             	add    $0x10,%esp
8010583c:	e9 4b ff ff ff       	jmp    8010578c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105846:	e9 6b ff ff ff       	jmp    801057b6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010584b:	e8 80 d3 ff ff       	call   80102bd0 <end_op>
    return -1;
80105850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105855:	e9 5c ff ff ff       	jmp    801057b6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	68 88 80 10 80       	push   $0x80108088
80105862:	e8 09 ab ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105867:	83 ec 0c             	sub    $0xc,%esp
8010586a:	68 9a 80 10 80       	push   $0x8010809a
8010586f:	e8 fc aa ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105874:	83 ec 0c             	sub    $0xc,%esp
80105877:	68 76 80 10 80       	push   $0x80108076
8010587c:	e8 ef aa ff ff       	call   80100370 <panic>
80105881:	eb 0d                	jmp    80105890 <sys_open>
80105883:	90                   	nop
80105884:	90                   	nop
80105885:	90                   	nop
80105886:	90                   	nop
80105887:	90                   	nop
80105888:	90                   	nop
80105889:	90                   	nop
8010588a:	90                   	nop
8010588b:	90                   	nop
8010588c:	90                   	nop
8010588d:	90                   	nop
8010588e:	90                   	nop
8010588f:	90                   	nop

80105890 <sys_open>:
  return ip;
}

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
  return ip;
}

int
sys_open(void)
{
80105899:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010589c:	50                   	push   %eax
8010589d:	6a 00                	push   $0x0
8010589f:	e8 fc f7 ff ff       	call   801050a0 <argstr>
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	85 c0                	test   %eax,%eax
801058a9:	0f 88 9e 00 00 00    	js     8010594d <sys_open+0xbd>
801058af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058b2:	83 ec 08             	sub    $0x8,%esp
801058b5:	50                   	push   %eax
801058b6:	6a 01                	push   $0x1
801058b8:	e8 33 f7 ff ff       	call   80104ff0 <argint>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	0f 88 85 00 00 00    	js     8010594d <sys_open+0xbd>
    return -1;

  begin_op();
801058c8:	e8 93 d2 ff ff       	call   80102b60 <begin_op>

  if(omode & O_CREATE){
801058cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058d1:	0f 85 89 00 00 00    	jne    80105960 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058d7:	83 ec 0c             	sub    $0xc,%esp
801058da:	ff 75 e0             	pushl  -0x20(%ebp)
801058dd:	e8 ee c5 ff ff       	call   80101ed0 <namei>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	89 c6                	mov    %eax,%esi
801058e9:	0f 84 8e 00 00 00    	je     8010597d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801058ef:	83 ec 0c             	sub    $0xc,%esp
801058f2:	50                   	push   %eax
801058f3:	e8 88 bd ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105900:	0f 84 d2 00 00 00    	je     801059d8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105906:	e8 75 b4 ff ff       	call   80100d80 <filealloc>
8010590b:	85 c0                	test   %eax,%eax
8010590d:	89 c7                	mov    %eax,%edi
8010590f:	74 2b                	je     8010593c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105911:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105913:	e8 78 df ff ff       	call   80103890 <myproc>
80105918:	90                   	nop
80105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105920:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105924:	85 d2                	test   %edx,%edx
80105926:	74 68                	je     80105990 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105928:	83 c3 01             	add    $0x1,%ebx
8010592b:	83 fb 10             	cmp    $0x10,%ebx
8010592e:	75 f0                	jne    80105920 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	57                   	push   %edi
80105934:	e8 07 b5 ff ff       	call   80100e40 <fileclose>
80105939:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	56                   	push   %esi
80105940:	e8 cb bf ff ff       	call   80101910 <iunlockput>
    end_op();
80105945:	e8 86 d2 ff ff       	call   80102bd0 <end_op>
    return -1;
8010594a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010594d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105955:	5b                   	pop    %ebx
80105956:	5e                   	pop    %esi
80105957:	5f                   	pop    %edi
80105958:	5d                   	pop    %ebp
80105959:	c3                   	ret    
8010595a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105966:	31 c9                	xor    %ecx,%ecx
80105968:	6a 00                	push   $0x0
8010596a:	ba 02 00 00 00       	mov    $0x2,%edx
8010596f:	e8 dc f7 ff ff       	call   80105150 <create>
    if(ip == 0){
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105979:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010597b:	75 89                	jne    80105906 <sys_open+0x76>
      end_op();
8010597d:	e8 4e d2 ff ff       	call   80102bd0 <end_op>
      return -1;
80105982:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105987:	eb 43                	jmp    801059cc <sys_open+0x13c>
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105990:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105993:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105997:	56                   	push   %esi
80105998:	e8 c3 bd ff ff       	call   80101760 <iunlock>
  end_op();
8010599d:	e8 2e d2 ff ff       	call   80102bd0 <end_op>

  f->type = FD_INODE;
801059a2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059ab:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801059ae:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801059b1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059b8:	89 d0                	mov    %edx,%eax
801059ba:	83 e0 01             	and    $0x1,%eax
801059bd:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059c0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059c3:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059c6:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
801059ca:	89 d8                	mov    %ebx,%eax
}
801059cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059cf:	5b                   	pop    %ebx
801059d0:	5e                   	pop    %esi
801059d1:	5f                   	pop    %edi
801059d2:	5d                   	pop    %ebp
801059d3:	c3                   	ret    
801059d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801059d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059db:	85 c9                	test   %ecx,%ecx
801059dd:	0f 84 23 ff ff ff    	je     80105906 <sys_open+0x76>
801059e3:	e9 54 ff ff ff       	jmp    8010593c <sys_open+0xac>
801059e8:	90                   	nop
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059f6:	e8 65 d1 ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059fe:	83 ec 08             	sub    $0x8,%esp
80105a01:	50                   	push   %eax
80105a02:	6a 00                	push   $0x0
80105a04:	e8 97 f6 ff ff       	call   801050a0 <argstr>
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	78 30                	js     80105a40 <sys_mkdir+0x50>
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a16:	31 c9                	xor    %ecx,%ecx
80105a18:	6a 00                	push   $0x0
80105a1a:	ba 01 00 00 00       	mov    $0x1,%edx
80105a1f:	e8 2c f7 ff ff       	call   80105150 <create>
80105a24:	83 c4 10             	add    $0x10,%esp
80105a27:	85 c0                	test   %eax,%eax
80105a29:	74 15                	je     80105a40 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a2b:	83 ec 0c             	sub    $0xc,%esp
80105a2e:	50                   	push   %eax
80105a2f:	e8 dc be ff ff       	call   80101910 <iunlockput>
  end_op();
80105a34:	e8 97 d1 ff ff       	call   80102bd0 <end_op>
  return 0;
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	31 c0                	xor    %eax,%eax
}
80105a3e:	c9                   	leave  
80105a3f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105a40:	e8 8b d1 ff ff       	call   80102bd0 <end_op>
    return -1;
80105a45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
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
80105a56:	e8 05 d1 ff ff       	call   80102b60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a5e:	83 ec 08             	sub    $0x8,%esp
80105a61:	50                   	push   %eax
80105a62:	6a 00                	push   $0x0
80105a64:	e8 37 f6 ff ff       	call   801050a0 <argstr>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	85 c0                	test   %eax,%eax
80105a6e:	78 60                	js     80105ad0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a70:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a73:	83 ec 08             	sub    $0x8,%esp
80105a76:	50                   	push   %eax
80105a77:	6a 01                	push   $0x1
80105a79:	e8 72 f5 ff ff       	call   80104ff0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	78 4b                	js     80105ad0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a88:	83 ec 08             	sub    $0x8,%esp
80105a8b:	50                   	push   %eax
80105a8c:	6a 02                	push   $0x2
80105a8e:	e8 5d f5 ff ff       	call   80104ff0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 c0                	test   %eax,%eax
80105a98:	78 36                	js     80105ad0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a9a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a9e:	83 ec 0c             	sub    $0xc,%esp
80105aa1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105aa5:	ba 03 00 00 00       	mov    $0x3,%edx
80105aaa:	50                   	push   %eax
80105aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105aae:	e8 9d f6 ff ff       	call   80105150 <create>
80105ab3:	83 c4 10             	add    $0x10,%esp
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	74 16                	je     80105ad0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105aba:	83 ec 0c             	sub    $0xc,%esp
80105abd:	50                   	push   %eax
80105abe:	e8 4d be ff ff       	call   80101910 <iunlockput>
  end_op();
80105ac3:	e8 08 d1 ff ff       	call   80102bd0 <end_op>
  return 0;
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	31 c0                	xor    %eax,%eax
}
80105acd:	c9                   	leave  
80105ace:	c3                   	ret    
80105acf:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105ad0:	e8 fb d0 ff ff       	call   80102bd0 <end_op>
    return -1;
80105ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
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
80105ae8:	e8 a3 dd ff ff       	call   80103890 <myproc>
80105aed:	89 c6                	mov    %eax,%esi
  //struct thread *curthread = mythread();
  
  begin_op();
80105aef:	e8 6c d0 ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af7:	83 ec 08             	sub    $0x8,%esp
80105afa:	50                   	push   %eax
80105afb:	6a 00                	push   $0x0
80105afd:	e8 9e f5 ff ff       	call   801050a0 <argstr>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	78 77                	js     80105b80 <sys_chdir+0xa0>
80105b09:	83 ec 0c             	sub    $0xc,%esp
80105b0c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b0f:	e8 bc c3 ff ff       	call   80101ed0 <namei>
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
80105b21:	e8 5a bb ff ff       	call   80101680 <ilock>
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
80105b34:	e8 27 bc ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105b39:	58                   	pop    %eax
80105b3a:	ff 76 60             	pushl  0x60(%esi)
80105b3d:	e8 6e bc ff ff       	call   801017b0 <iput>
  end_op();
80105b42:	e8 89 d0 ff ff       	call   80102bd0 <end_op>
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
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	53                   	push   %ebx
80105b64:	e8 a7 bd ff ff       	call   80101910 <iunlockput>
    end_op();
80105b69:	e8 62 d0 ff ff       	call   80102bd0 <end_op>
    return -1;
80105b6e:	83 c4 10             	add    $0x10,%esp
80105b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b76:	eb d7                	jmp    80105b4f <sys_chdir+0x6f>
80105b78:	90                   	nop
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
  //struct thread *curthread = mythread();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105b80:	e8 4b d0 ff ff       	call   80102bd0 <end_op>
    return -1;
80105b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b8a:	eb c3                	jmp    80105b4f <sys_chdir+0x6f>
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_exec>:
  return 0;
}

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
  return 0;
}

int
sys_exec(void)
{
80105b9c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ba2:	50                   	push   %eax
80105ba3:	6a 00                	push   $0x0
80105ba5:	e8 f6 f4 ff ff       	call   801050a0 <argstr>
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	85 c0                	test   %eax,%eax
80105baf:	78 7f                	js     80105c30 <sys_exec+0xa0>
80105bb1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bb7:	83 ec 08             	sub    $0x8,%esp
80105bba:	50                   	push   %eax
80105bbb:	6a 01                	push   $0x1
80105bbd:	e8 2e f4 ff ff       	call   80104ff0 <argint>
80105bc2:	83 c4 10             	add    $0x10,%esp
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	78 67                	js     80105c30 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bc9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bcf:	83 ec 04             	sub    $0x4,%esp
80105bd2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105bd8:	68 80 00 00 00       	push   $0x80
80105bdd:	6a 00                	push   $0x0
80105bdf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105be5:	50                   	push   %eax
80105be6:	31 db                	xor    %ebx,%ebx
80105be8:	e8 f3 f0 ff ff       	call   80104ce0 <memset>
80105bed:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bf0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bf6:	83 ec 08             	sub    $0x8,%esp
80105bf9:	57                   	push   %edi
80105bfa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105bfd:	50                   	push   %eax
80105bfe:	e8 4d f3 ff ff       	call   80104f50 <fetchint>
80105c03:	83 c4 10             	add    $0x10,%esp
80105c06:	85 c0                	test   %eax,%eax
80105c08:	78 26                	js     80105c30 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105c0a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c10:	85 c0                	test   %eax,%eax
80105c12:	74 2c                	je     80105c40 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c14:	83 ec 08             	sub    $0x8,%esp
80105c17:	56                   	push   %esi
80105c18:	50                   	push   %eax
80105c19:	e8 72 f3 ff ff       	call   80104f90 <fetchstr>
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	85 c0                	test   %eax,%eax
80105c23:	78 0b                	js     80105c30 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105c25:	83 c3 01             	add    $0x1,%ebx
80105c28:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105c2b:	83 fb 20             	cmp    $0x20,%ebx
80105c2e:	75 c0                	jne    80105bf0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105c33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105c38:	5b                   	pop    %ebx
80105c39:	5e                   	pop    %esi
80105c3a:	5f                   	pop    %edi
80105c3b:	5d                   	pop    %ebp
80105c3c:	c3                   	ret    
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105c40:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c46:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105c49:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c50:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105c54:	50                   	push   %eax
80105c55:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c5b:	e8 90 ad ff ff       	call   801009f0 <exec>
80105c60:	83 c4 10             	add    $0x10,%esp
}
80105c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c66:	5b                   	pop    %ebx
80105c67:	5e                   	pop    %esi
80105c68:	5f                   	pop    %edi
80105c69:	5d                   	pop    %ebp
80105c6a:	c3                   	ret    
80105c6b:	90                   	nop
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c70 <sys_pipe>:

int
sys_pipe(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c76:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105c79:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c7c:	6a 08                	push   $0x8
80105c7e:	50                   	push   %eax
80105c7f:	6a 00                	push   $0x0
80105c81:	e8 ba f3 ff ff       	call   80105040 <argptr>
80105c86:	83 c4 10             	add    $0x10,%esp
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	78 4a                	js     80105cd7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c8d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c90:	83 ec 08             	sub    $0x8,%esp
80105c93:	50                   	push   %eax
80105c94:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c97:	50                   	push   %eax
80105c98:	e8 63 d5 ff ff       	call   80103200 <pipealloc>
80105c9d:	83 c4 10             	add    $0x10,%esp
80105ca0:	85 c0                	test   %eax,%eax
80105ca2:	78 33                	js     80105cd7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ca4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ca6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105ca9:	e8 e2 db ff ff       	call   80103890 <myproc>
80105cae:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105cb0:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
80105cb4:	85 f6                	test   %esi,%esi
80105cb6:	74 30                	je     80105ce8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105cb8:	83 c3 01             	add    $0x1,%ebx
80105cbb:	83 fb 10             	cmp    $0x10,%ebx
80105cbe:	75 f0                	jne    80105cb0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	ff 75 e0             	pushl  -0x20(%ebp)
80105cc6:	e8 75 b1 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105ccb:	58                   	pop    %eax
80105ccc:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ccf:	e8 6c b1 ff ff       	call   80100e40 <fileclose>
    return -1;
80105cd4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105cda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105cdf:	5b                   	pop    %ebx
80105ce0:	5e                   	pop    %esi
80105ce1:	5f                   	pop    %edi
80105ce2:	5d                   	pop    %ebp
80105ce3:	c3                   	ret    
80105ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105ce8:	8d 73 08             	lea    0x8(%ebx),%esi
80105ceb:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105cf1:	e8 9a db ff ff       	call   80103890 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105cf6:	31 d2                	xor    %edx,%edx
80105cf8:	90                   	nop
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d00:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
80105d04:	85 c9                	test   %ecx,%ecx
80105d06:	74 18                	je     80105d20 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105d08:	83 c2 01             	add    $0x1,%edx
80105d0b:	83 fa 10             	cmp    $0x10,%edx
80105d0e:	75 f0                	jne    80105d00 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105d10:	e8 7b db ff ff       	call   80103890 <myproc>
80105d15:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
80105d1c:	eb a2                	jmp    80105cc0 <sys_pipe+0x50>
80105d1e:	66 90                	xchg   %ax,%ax
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105d20:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d27:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d2c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105d32:	31 c0                	xor    %eax,%eax
}
80105d34:	5b                   	pop    %ebx
80105d35:	5e                   	pop    %esi
80105d36:	5f                   	pop    %edi
80105d37:	5d                   	pop    %ebp
80105d38:	c3                   	ret    
80105d39:	66 90                	xchg   %ax,%ax
80105d3b:	66 90                	xchg   %ax,%ax
80105d3d:	66 90                	xchg   %ax,%ax
80105d3f:	90                   	nop

80105d40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d43:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105d44:	e9 a7 dd ff ff       	jmp    80103af0 <fork>
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_exit>:
}

int
sys_exit(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d56:	e8 15 e3 ff ff       	call   80104070 <exit>
  return 0;  // not reached
}
80105d5b:	31 c0                	xor    %eax,%eax
80105d5d:	c9                   	leave  
80105d5e:	c3                   	ret    
80105d5f:	90                   	nop

80105d60 <sys_wait>:

int
sys_wait(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d63:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105d64:	e9 07 e5 ff ff       	jmp    80104270 <wait>
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_kill>:
}

int
sys_kill(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 00                	push   $0x0
80105d7c:	e8 6f f2 ff ff       	call   80104ff0 <argint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 18                	js     80105da0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8e:	e8 dd e6 ff ff       	call   80104470 <kill>
80105d93:	83 c4 10             	add    $0x10,%esp
}
80105d96:	c9                   	leave  
80105d97:	c3                   	ret    
80105d98:	90                   	nop
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <sys_getpid>:

int
sys_getpid(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105db6:	e8 d5 da ff ff       	call   80103890 <myproc>
80105dbb:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105dbe:	c9                   	leave  
80105dbf:	c3                   	ret    

80105dc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105dc7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dca:	50                   	push   %eax
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 1e f2 ff ff       	call   80104ff0 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	78 27                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dd9:	e8 b2 da ff ff       	call   80103890 <myproc>
  if(growproc(n) < 0)
80105dde:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105de1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105de3:	ff 75 f4             	pushl  -0xc(%ebp)
80105de6:	e8 65 dc ff ff       	call   80103a50 <growproc>
80105deb:	83 c4 10             	add    $0x10,%esp
80105dee:	85 c0                	test   %eax,%eax
80105df0:	78 0e                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  return addr;
80105df2:	89 d8                	mov    %ebx,%eax
}
80105df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df7:	c9                   	leave  
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e05:	eb ed                	jmp    80105df4 <sys_sbrk+0x34>
80105e07:	89 f6                	mov    %esi,%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e10 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105e17:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e1a:	50                   	push   %eax
80105e1b:	6a 00                	push   $0x0
80105e1d:	e8 ce f1 ff ff       	call   80104ff0 <argint>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	0f 88 8a 00 00 00    	js     80105eb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	68 a0 2c 12 80       	push   $0x80122ca0
80105e35:	e8 96 ed ff ff       	call   80104bd0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e3d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105e40:	8b 1d e0 34 12 80    	mov    0x801234e0,%ebx
  while(ticks - ticks0 < n){
80105e46:	85 d2                	test   %edx,%edx
80105e48:	75 27                	jne    80105e71 <sys_sleep+0x61>
80105e4a:	eb 54                	jmp    80105ea0 <sys_sleep+0x90>
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e50:	83 ec 08             	sub    $0x8,%esp
80105e53:	68 a0 2c 12 80       	push   $0x80122ca0
80105e58:	68 e0 34 12 80       	push   $0x801234e0
80105e5d:	e8 7e e0 ff ff       	call   80103ee0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e62:	a1 e0 34 12 80       	mov    0x801234e0,%eax
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	29 d8                	sub    %ebx,%eax
80105e6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e6f:	73 2f                	jae    80105ea0 <sys_sleep+0x90>
    if(myproc()->killed){
80105e71:	e8 1a da ff ff       	call   80103890 <myproc>
80105e76:	8b 40 1c             	mov    0x1c(%eax),%eax
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	74 d3                	je     80105e50 <sys_sleep+0x40>
      release(&tickslock);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	68 a0 2c 12 80       	push   $0x80122ca0
80105e85:	e8 f6 ed ff ff       	call   80104c80 <release>
      return -1;
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105e92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	68 a0 2c 12 80       	push   $0x80122ca0
80105ea8:	e8 d3 ed ff ff       	call   80104c80 <release>
  return 0;
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	31 c0                	xor    %eax,%eax
}
80105eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	eb d4                	jmp    80105e92 <sys_sleep+0x82>
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	53                   	push   %ebx
80105ec4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ec7:	68 a0 2c 12 80       	push   $0x80122ca0
80105ecc:	e8 ff ec ff ff       	call   80104bd0 <acquire>
  xticks = ticks;
80105ed1:	8b 1d e0 34 12 80    	mov    0x801234e0,%ebx
  release(&tickslock);
80105ed7:	c7 04 24 a0 2c 12 80 	movl   $0x80122ca0,(%esp)
80105ede:	e8 9d ed ff ff       	call   80104c80 <release>
  return xticks;
}
80105ee3:	89 d8                	mov    %ebx,%eax
80105ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ee8:	c9                   	leave  
80105ee9:	c3                   	ret    
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ef0 <sys_kthread_create>:

int
sys_kthread_create(void){
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 0c             	sub    $0xc,%esp
    void (*start_func)()=0;
    void* stack=0;
    if(argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
80105ef6:	6a 01                	push   $0x1
80105ef8:	6a 00                	push   $0x0
80105efa:	6a 00                	push   $0x0
80105efc:	e8 3f f1 ff ff       	call   80105040 <argptr>
80105f01:	83 c4 10             	add    $0x10,%esp
80105f04:	85 c0                	test   %eax,%eax
80105f06:	78 28                	js     80105f30 <sys_kthread_create+0x40>
        return -1;
    if(argptr(0, stack, sizeof(*stack)) < 0)
80105f08:	83 ec 04             	sub    $0x4,%esp
80105f0b:	6a 01                	push   $0x1
80105f0d:	6a 00                	push   $0x0
80105f0f:	6a 00                	push   $0x0
80105f11:	e8 2a f1 ff ff       	call   80105040 <argptr>
80105f16:	83 c4 10             	add    $0x10,%esp
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	78 13                	js     80105f30 <sys_kthread_create+0x40>
        return -1;
    return kthread_create(start_func, stack);
80105f1d:	83 ec 08             	sub    $0x8,%esp
80105f20:	6a 00                	push   $0x0
80105f22:	6a 00                	push   $0x0
80105f24:	e8 f7 e6 ff ff       	call   80104620 <kthread_create>
80105f29:	83 c4 10             	add    $0x10,%esp
}
80105f2c:	c9                   	leave  
80105f2d:	c3                   	ret    
80105f2e:	66 90                	xchg   %ax,%ax
int
sys_kthread_create(void){
    void (*start_func)()=0;
    void* stack=0;
    if(argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
        return -1;
80105f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(argptr(0, stack, sizeof(*stack)) < 0)
        return -1;
    return kthread_create(start_func, stack);
}
80105f35:	c9                   	leave  
80105f36:	c3                   	ret    
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f40 <sys_kthread_id>:

int
sys_kthread_id(void){
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 08             	sub    $0x8,%esp
    return mythread()->tid;
80105f46:	e8 75 d9 ff ff       	call   801038c0 <mythread>
80105f4b:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105f4e:	c9                   	leave  
80105f4f:	c3                   	ret    

80105f50 <sys_kthread_exit>:

int
sys_kthread_exit(void){
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	83 ec 08             	sub    $0x8,%esp
    kthread_exit();
80105f56:	e8 85 e8 ff ff       	call   801047e0 <kthread_exit>
    return 0;
}
80105f5b:	31 c0                	xor    %eax,%eax
80105f5d:	c9                   	leave  
80105f5e:	c3                   	ret    
80105f5f:	90                   	nop

80105f60 <sys_kthread_join>:

int
sys_kthread_join(void){
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if(argint(0, &tid) < 0)
80105f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f69:	50                   	push   %eax
80105f6a:	6a 00                	push   $0x0
80105f6c:	e8 7f f0 ff ff       	call   80104ff0 <argint>
80105f71:	83 c4 10             	add    $0x10,%esp
80105f74:	85 c0                	test   %eax,%eax
80105f76:	78 18                	js     80105f90 <sys_kthread_join+0x30>
        return -1;
    return kthread_join(tid);
80105f78:	83 ec 0c             	sub    $0xc,%esp
80105f7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f7e:	e8 fd e8 ff ff       	call   80104880 <kthread_join>
80105f83:	83 c4 10             	add    $0x10,%esp
}
80105f86:	c9                   	leave  
80105f87:	c3                   	ret    
80105f88:	90                   	nop
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_kthread_join(void){
    int tid;
    if(argint(0, &tid) < 0)
        return -1;
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return kthread_join(tid);
}
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    

80105f97 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f97:	1e                   	push   %ds
  pushl %es
80105f98:	06                   	push   %es
  pushl %fs
80105f99:	0f a0                	push   %fs
  pushl %gs
80105f9b:	0f a8                	push   %gs
  pushal
80105f9d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f9e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fa2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fa4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fa6:	54                   	push   %esp
  call trap
80105fa7:	e8 e4 00 00 00       	call   80106090 <trap>
  addl $4, %esp
80105fac:	83 c4 04             	add    $0x4,%esp

80105faf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105faf:	61                   	popa   
  popl %gs
80105fb0:	0f a9                	pop    %gs
  popl %fs
80105fb2:	0f a1                	pop    %fs
  popl %es
80105fb4:	07                   	pop    %es
  popl %ds
80105fb5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fb6:	83 c4 08             	add    $0x8,%esp
  iret
80105fb9:	cf                   	iret   
80105fba:	66 90                	xchg   %ax,%ax
80105fbc:	66 90                	xchg   %ax,%ax
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105fc0:	31 c0                	xor    %eax,%eax
80105fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105fc8:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105fcf:	b9 08 00 00 00       	mov    $0x8,%ecx
80105fd4:	c6 04 c5 e4 2c 12 80 	movb   $0x0,-0x7fedd31c(,%eax,8)
80105fdb:	00 
80105fdc:	66 89 0c c5 e2 2c 12 	mov    %cx,-0x7fedd31e(,%eax,8)
80105fe3:	80 
80105fe4:	c6 04 c5 e5 2c 12 80 	movb   $0x8e,-0x7fedd31b(,%eax,8)
80105feb:	8e 
80105fec:	66 89 14 c5 e0 2c 12 	mov    %dx,-0x7fedd320(,%eax,8)
80105ff3:	80 
80105ff4:	c1 ea 10             	shr    $0x10,%edx
80105ff7:	66 89 14 c5 e6 2c 12 	mov    %dx,-0x7fedd31a(,%eax,8)
80105ffe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105fff:	83 c0 01             	add    $0x1,%eax
80106002:	3d 00 01 00 00       	cmp    $0x100,%eax
80106007:	75 bf                	jne    80105fc8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106009:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010600a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010600f:	89 e5                	mov    %esp,%ebp
80106011:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106014:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

  initlock(&tickslock, "time");
80106019:	68 a9 80 10 80       	push   $0x801080a9
8010601e:	68 a0 2c 12 80       	push   $0x80122ca0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106023:	66 89 15 e2 2e 12 80 	mov    %dx,0x80122ee2
8010602a:	c6 05 e4 2e 12 80 00 	movb   $0x0,0x80122ee4
80106031:	66 a3 e0 2e 12 80    	mov    %ax,0x80122ee0
80106037:	c1 e8 10             	shr    $0x10,%eax
8010603a:	c6 05 e5 2e 12 80 ef 	movb   $0xef,0x80122ee5
80106041:	66 a3 e6 2e 12 80    	mov    %ax,0x80122ee6

  initlock(&tickslock, "time");
80106047:	e8 24 ea ff ff       	call   80104a70 <initlock>
}
8010604c:	83 c4 10             	add    $0x10,%esp
8010604f:	c9                   	leave  
80106050:	c3                   	ret    
80106051:	eb 0d                	jmp    80106060 <idtinit>
80106053:	90                   	nop
80106054:	90                   	nop
80106055:	90                   	nop
80106056:	90                   	nop
80106057:	90                   	nop
80106058:	90                   	nop
80106059:	90                   	nop
8010605a:	90                   	nop
8010605b:	90                   	nop
8010605c:	90                   	nop
8010605d:	90                   	nop
8010605e:	90                   	nop
8010605f:	90                   	nop

80106060 <idtinit>:

void
idtinit(void)
{
80106060:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

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
801060a2:	0f 84 88 01 00 00    	je     80106230 <trap+0x1a0>
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
801060c0:	e8 cb d7 ff ff       	call   80103890 <myproc>
801060c5:	85 c0                	test   %eax,%eax
801060c7:	0f 84 d7 01 00 00    	je     801062a4 <trap+0x214>
801060cd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801060d1:	0f 84 cd 01 00 00    	je     801062a4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060d7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060da:	8b 57 38             	mov    0x38(%edi),%edx
801060dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801060e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801060e3:	e8 88 d7 ff ff       	call   80103870 <cpuid>
801060e8:	8b 77 34             	mov    0x34(%edi),%esi
801060eb:	8b 5f 30             	mov    0x30(%edi),%ebx
801060ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801060f1:	e8 9a d7 ff ff       	call   80103890 <myproc>
801060f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060f9:	e8 92 d7 ff ff       	call   80103890 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106101:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106104:	51                   	push   %ecx
80106105:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106106:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106109:	ff 75 e4             	pushl  -0x1c(%ebp)
8010610c:	56                   	push   %esi
8010610d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010610e:	83 c2 64             	add    $0x64,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106111:	52                   	push   %edx
80106112:	ff 70 0c             	pushl  0xc(%eax)
80106115:	68 0c 81 10 80       	push   $0x8010810c
8010611a:	e8 41 a5 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010611f:	83 c4 20             	add    $0x20,%esp
80106122:	e8 69 d7 ff ff       	call   80103890 <myproc>
80106127:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
8010612e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106130:	e8 5b d7 ff ff       	call   80103890 <myproc>
80106135:	85 c0                	test   %eax,%eax
80106137:	74 0c                	je     80106145 <trap+0xb5>
80106139:	e8 52 d7 ff ff       	call   80103890 <myproc>
8010613e:	8b 50 1c             	mov    0x1c(%eax),%edx
80106141:	85 d2                	test   %edx,%edx
80106143:	75 4b                	jne    80106190 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106145:	e8 46 d7 ff ff       	call   80103890 <myproc>
8010614a:	85 c0                	test   %eax,%eax
8010614c:	74 0b                	je     80106159 <trap+0xc9>
8010614e:	e8 3d d7 ff ff       	call   80103890 <myproc>
80106153:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80106157:	74 4f                	je     801061a8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106159:	e8 32 d7 ff ff       	call   80103890 <myproc>
8010615e:	85 c0                	test   %eax,%eax
80106160:	74 1d                	je     8010617f <trap+0xef>
80106162:	e8 29 d7 ff ff       	call   80103890 <myproc>
80106167:	8b 40 1c             	mov    0x1c(%eax),%eax
8010616a:	85 c0                	test   %eax,%eax
8010616c:	74 11                	je     8010617f <trap+0xef>
8010616e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106172:	83 e0 03             	and    $0x3,%eax
80106175:	66 83 f8 03          	cmp    $0x3,%ax
80106179:	0f 84 da 00 00 00    	je     80106259 <trap+0x1c9>
    exit();
}
8010617f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106182:	5b                   	pop    %ebx
80106183:	5e                   	pop    %esi
80106184:	5f                   	pop    %edi
80106185:	5d                   	pop    %ebp
80106186:	c3                   	ret    
80106187:	89 f6                	mov    %esi,%esi
80106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106190:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106194:	83 e0 03             	and    $0x3,%eax
80106197:	66 83 f8 03          	cmp    $0x3,%ax
8010619b:	75 a8                	jne    80106145 <trap+0xb5>
    exit();
8010619d:	e8 ce de ff ff       	call   80104070 <exit>
801061a2:	eb a1                	jmp    80106145 <trap+0xb5>
801061a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801061a8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801061ac:	75 ab                	jne    80106159 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801061ae:	e8 dd dc ff ff       	call   80103e90 <yield>
801061b3:	eb a4                	jmp    80106159 <trap+0xc9>
801061b5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801061b8:	e8 b3 d6 ff ff       	call   80103870 <cpuid>
801061bd:	85 c0                	test   %eax,%eax
801061bf:	0f 84 ab 00 00 00    	je     80106270 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801061c5:	e8 56 c5 ff ff       	call   80102720 <lapiceoi>
    break;
801061ca:	e9 61 ff ff ff       	jmp    80106130 <trap+0xa0>
801061cf:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801061d0:	e8 0b c4 ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
801061d5:	e8 46 c5 ff ff       	call   80102720 <lapiceoi>
    break;
801061da:	e9 51 ff ff ff       	jmp    80106130 <trap+0xa0>
801061df:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801061e0:	e8 5b 02 00 00       	call   80106440 <uartintr>
    lapiceoi();
801061e5:	e8 36 c5 ff ff       	call   80102720 <lapiceoi>
    break;
801061ea:	e9 41 ff ff ff       	jmp    80106130 <trap+0xa0>
801061ef:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061f0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801061f4:	8b 77 38             	mov    0x38(%edi),%esi
801061f7:	e8 74 d6 ff ff       	call   80103870 <cpuid>
801061fc:	56                   	push   %esi
801061fd:	53                   	push   %ebx
801061fe:	50                   	push   %eax
801061ff:	68 b4 80 10 80       	push   $0x801080b4
80106204:	e8 57 a4 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106209:	e8 12 c5 ff ff       	call   80102720 <lapiceoi>
    break;
8010620e:	83 c4 10             	add    $0x10,%esp
80106211:	e9 1a ff ff ff       	jmp    80106130 <trap+0xa0>
80106216:	8d 76 00             	lea    0x0(%esi),%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106220:	e8 3b be ff ff       	call   80102060 <ideintr>
80106225:	eb 9e                	jmp    801061c5 <trap+0x135>
80106227:	89 f6                	mov    %esi,%esi
80106229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106230:	e8 5b d6 ff ff       	call   80103890 <myproc>
80106235:	8b 58 1c             	mov    0x1c(%eax),%ebx
80106238:	85 db                	test   %ebx,%ebx
8010623a:	75 2c                	jne    80106268 <trap+0x1d8>
      exit();
    mythread()->tf = tf;
8010623c:	e8 7f d6 ff ff       	call   801038c0 <mythread>
80106241:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
80106244:	e8 97 ee ff ff       	call   801050e0 <syscall>
    if(myproc()->killed)
80106249:	e8 42 d6 ff ff       	call   80103890 <myproc>
8010624e:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106251:	85 c9                	test   %ecx,%ecx
80106253:	0f 84 26 ff ff ff    	je     8010617f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106259:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010625c:	5b                   	pop    %ebx
8010625d:	5e                   	pop    %esi
8010625e:	5f                   	pop    %edi
8010625f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    mythread()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106260:	e9 0b de ff ff       	jmp    80104070 <exit>
80106265:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106268:	e8 03 de ff ff       	call   80104070 <exit>
8010626d:	eb cd                	jmp    8010623c <trap+0x1ac>
8010626f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106270:	83 ec 0c             	sub    $0xc,%esp
80106273:	68 a0 2c 12 80       	push   $0x80122ca0
80106278:	e8 53 e9 ff ff       	call   80104bd0 <acquire>
      ticks++;
      wakeup(&ticks);
8010627d:	c7 04 24 e0 34 12 80 	movl   $0x801234e0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106284:	83 05 e0 34 12 80 01 	addl   $0x1,0x801234e0
      wakeup(&ticks);
8010628b:	e8 50 e1 ff ff       	call   801043e0 <wakeup>
      release(&tickslock);
80106290:	c7 04 24 a0 2c 12 80 	movl   $0x80122ca0,(%esp)
80106297:	e8 e4 e9 ff ff       	call   80104c80 <release>
8010629c:	83 c4 10             	add    $0x10,%esp
8010629f:	e9 21 ff ff ff       	jmp    801061c5 <trap+0x135>
801062a4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801062aa:	e8 c1 d5 ff ff       	call   80103870 <cpuid>
801062af:	83 ec 0c             	sub    $0xc,%esp
801062b2:	56                   	push   %esi
801062b3:	53                   	push   %ebx
801062b4:	50                   	push   %eax
801062b5:	ff 77 30             	pushl  0x30(%edi)
801062b8:	68 d8 80 10 80       	push   $0x801080d8
801062bd:	e8 9e a3 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801062c2:	83 c4 14             	add    $0x14,%esp
801062c5:	68 ae 80 10 80       	push   $0x801080ae
801062ca:	e8 a1 a0 ff ff       	call   80100370 <panic>
801062cf:	90                   	nop

801062d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801062d0:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801062d5:	55                   	push   %ebp
801062d6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801062d8:	85 c0                	test   %eax,%eax
801062da:	74 1c                	je     801062f8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062dc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062e1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062e2:	a8 01                	test   $0x1,%al
801062e4:	74 12                	je     801062f8 <uartgetc+0x28>
801062e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062eb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062ec:	0f b6 c0             	movzbl %al,%eax
}
801062ef:	5d                   	pop    %ebp
801062f0:	c3                   	ret    
801062f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801062f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801062fd:	5d                   	pop    %ebp
801062fe:	c3                   	ret    
801062ff:	90                   	nop

80106300 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	57                   	push   %edi
80106304:	56                   	push   %esi
80106305:	53                   	push   %ebx
80106306:	89 c7                	mov    %eax,%edi
80106308:	bb 80 00 00 00       	mov    $0x80,%ebx
8010630d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106312:	83 ec 0c             	sub    $0xc,%esp
80106315:	eb 1b                	jmp    80106332 <uartputc.part.0+0x32>
80106317:	89 f6                	mov    %esi,%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106320:	83 ec 0c             	sub    $0xc,%esp
80106323:	6a 0a                	push   $0xa
80106325:	e8 16 c4 ff ff       	call   80102740 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010632a:	83 c4 10             	add    $0x10,%esp
8010632d:	83 eb 01             	sub    $0x1,%ebx
80106330:	74 07                	je     80106339 <uartputc.part.0+0x39>
80106332:	89 f2                	mov    %esi,%edx
80106334:	ec                   	in     (%dx),%al
80106335:	a8 20                	test   $0x20,%al
80106337:	74 e7                	je     80106320 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106339:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010633e:	89 f8                	mov    %edi,%eax
80106340:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106341:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106344:	5b                   	pop    %ebx
80106345:	5e                   	pop    %esi
80106346:	5f                   	pop    %edi
80106347:	5d                   	pop    %ebp
80106348:	c3                   	ret    
80106349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106350 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106350:	55                   	push   %ebp
80106351:	31 c9                	xor    %ecx,%ecx
80106353:	89 c8                	mov    %ecx,%eax
80106355:	89 e5                	mov    %esp,%ebp
80106357:	57                   	push   %edi
80106358:	56                   	push   %esi
80106359:	53                   	push   %ebx
8010635a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010635f:	89 da                	mov    %ebx,%edx
80106361:	83 ec 0c             	sub    $0xc,%esp
80106364:	ee                   	out    %al,(%dx)
80106365:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010636a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010636f:	89 fa                	mov    %edi,%edx
80106371:	ee                   	out    %al,(%dx)
80106372:	b8 0c 00 00 00       	mov    $0xc,%eax
80106377:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010637c:	ee                   	out    %al,(%dx)
8010637d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106382:	89 c8                	mov    %ecx,%eax
80106384:	89 f2                	mov    %esi,%edx
80106386:	ee                   	out    %al,(%dx)
80106387:	b8 03 00 00 00       	mov    $0x3,%eax
8010638c:	89 fa                	mov    %edi,%edx
8010638e:	ee                   	out    %al,(%dx)
8010638f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106394:	89 c8                	mov    %ecx,%eax
80106396:	ee                   	out    %al,(%dx)
80106397:	b8 01 00 00 00       	mov    $0x1,%eax
8010639c:	89 f2                	mov    %esi,%edx
8010639e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010639f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063a4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801063a5:	3c ff                	cmp    $0xff,%al
801063a7:	74 5a                	je     80106403 <uartinit+0xb3>
    return;
  uart = 1;
801063a9:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801063b0:	00 00 00 
801063b3:	89 da                	mov    %ebx,%edx
801063b5:	ec                   	in     (%dx),%al
801063b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063bb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801063bc:	83 ec 08             	sub    $0x8,%esp
801063bf:	bb d0 81 10 80       	mov    $0x801081d0,%ebx
801063c4:	6a 00                	push   $0x0
801063c6:	6a 04                	push   $0x4
801063c8:	e8 e3 be ff ff       	call   801022b0 <ioapicenable>
801063cd:	83 c4 10             	add    $0x10,%esp
801063d0:	b8 78 00 00 00       	mov    $0x78,%eax
801063d5:	eb 13                	jmp    801063ea <uartinit+0x9a>
801063d7:	89 f6                	mov    %esi,%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801063e0:	83 c3 01             	add    $0x1,%ebx
801063e3:	0f be 03             	movsbl (%ebx),%eax
801063e6:	84 c0                	test   %al,%al
801063e8:	74 19                	je     80106403 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
801063ea:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
801063f0:	85 d2                	test   %edx,%edx
801063f2:	74 ec                	je     801063e0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801063f4:	83 c3 01             	add    $0x1,%ebx
801063f7:	e8 04 ff ff ff       	call   80106300 <uartputc.part.0>
801063fc:	0f be 03             	movsbl (%ebx),%eax
801063ff:	84 c0                	test   %al,%al
80106401:	75 e7                	jne    801063ea <uartinit+0x9a>
    uartputc(*p);
}
80106403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106406:	5b                   	pop    %ebx
80106407:	5e                   	pop    %esi
80106408:	5f                   	pop    %edi
80106409:	5d                   	pop    %ebp
8010640a:	c3                   	ret    
8010640b:	90                   	nop
8010640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106410 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106410:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106416:	55                   	push   %ebp
80106417:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106419:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010641b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010641e:	74 10                	je     80106430 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106420:	5d                   	pop    %ebp
80106421:	e9 da fe ff ff       	jmp    80106300 <uartputc.part.0>
80106426:	8d 76 00             	lea    0x0(%esi),%esi
80106429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106430:	5d                   	pop    %ebp
80106431:	c3                   	ret    
80106432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106440 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106446:	68 d0 62 10 80       	push   $0x801062d0
8010644b:	e8 a0 a3 ff ff       	call   801007f0 <consoleintr>
}
80106450:	83 c4 10             	add    $0x10,%esp
80106453:	c9                   	leave  
80106454:	c3                   	ret    

80106455 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $0
80106457:	6a 00                	push   $0x0
  jmp alltraps
80106459:	e9 39 fb ff ff       	jmp    80105f97 <alltraps>

8010645e <vector1>:
.globl vector1
vector1:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $1
80106460:	6a 01                	push   $0x1
  jmp alltraps
80106462:	e9 30 fb ff ff       	jmp    80105f97 <alltraps>

80106467 <vector2>:
.globl vector2
vector2:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $2
80106469:	6a 02                	push   $0x2
  jmp alltraps
8010646b:	e9 27 fb ff ff       	jmp    80105f97 <alltraps>

80106470 <vector3>:
.globl vector3
vector3:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $3
80106472:	6a 03                	push   $0x3
  jmp alltraps
80106474:	e9 1e fb ff ff       	jmp    80105f97 <alltraps>

80106479 <vector4>:
.globl vector4
vector4:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $4
8010647b:	6a 04                	push   $0x4
  jmp alltraps
8010647d:	e9 15 fb ff ff       	jmp    80105f97 <alltraps>

80106482 <vector5>:
.globl vector5
vector5:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $5
80106484:	6a 05                	push   $0x5
  jmp alltraps
80106486:	e9 0c fb ff ff       	jmp    80105f97 <alltraps>

8010648b <vector6>:
.globl vector6
vector6:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $6
8010648d:	6a 06                	push   $0x6
  jmp alltraps
8010648f:	e9 03 fb ff ff       	jmp    80105f97 <alltraps>

80106494 <vector7>:
.globl vector7
vector7:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $7
80106496:	6a 07                	push   $0x7
  jmp alltraps
80106498:	e9 fa fa ff ff       	jmp    80105f97 <alltraps>

8010649d <vector8>:
.globl vector8
vector8:
  pushl $8
8010649d:	6a 08                	push   $0x8
  jmp alltraps
8010649f:	e9 f3 fa ff ff       	jmp    80105f97 <alltraps>

801064a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $9
801064a6:	6a 09                	push   $0x9
  jmp alltraps
801064a8:	e9 ea fa ff ff       	jmp    80105f97 <alltraps>

801064ad <vector10>:
.globl vector10
vector10:
  pushl $10
801064ad:	6a 0a                	push   $0xa
  jmp alltraps
801064af:	e9 e3 fa ff ff       	jmp    80105f97 <alltraps>

801064b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801064b4:	6a 0b                	push   $0xb
  jmp alltraps
801064b6:	e9 dc fa ff ff       	jmp    80105f97 <alltraps>

801064bb <vector12>:
.globl vector12
vector12:
  pushl $12
801064bb:	6a 0c                	push   $0xc
  jmp alltraps
801064bd:	e9 d5 fa ff ff       	jmp    80105f97 <alltraps>

801064c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801064c2:	6a 0d                	push   $0xd
  jmp alltraps
801064c4:	e9 ce fa ff ff       	jmp    80105f97 <alltraps>

801064c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801064c9:	6a 0e                	push   $0xe
  jmp alltraps
801064cb:	e9 c7 fa ff ff       	jmp    80105f97 <alltraps>

801064d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $15
801064d2:	6a 0f                	push   $0xf
  jmp alltraps
801064d4:	e9 be fa ff ff       	jmp    80105f97 <alltraps>

801064d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $16
801064db:	6a 10                	push   $0x10
  jmp alltraps
801064dd:	e9 b5 fa ff ff       	jmp    80105f97 <alltraps>

801064e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801064e2:	6a 11                	push   $0x11
  jmp alltraps
801064e4:	e9 ae fa ff ff       	jmp    80105f97 <alltraps>

801064e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $18
801064eb:	6a 12                	push   $0x12
  jmp alltraps
801064ed:	e9 a5 fa ff ff       	jmp    80105f97 <alltraps>

801064f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $19
801064f4:	6a 13                	push   $0x13
  jmp alltraps
801064f6:	e9 9c fa ff ff       	jmp    80105f97 <alltraps>

801064fb <vector20>:
.globl vector20
vector20:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $20
801064fd:	6a 14                	push   $0x14
  jmp alltraps
801064ff:	e9 93 fa ff ff       	jmp    80105f97 <alltraps>

80106504 <vector21>:
.globl vector21
vector21:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $21
80106506:	6a 15                	push   $0x15
  jmp alltraps
80106508:	e9 8a fa ff ff       	jmp    80105f97 <alltraps>

8010650d <vector22>:
.globl vector22
vector22:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $22
8010650f:	6a 16                	push   $0x16
  jmp alltraps
80106511:	e9 81 fa ff ff       	jmp    80105f97 <alltraps>

80106516 <vector23>:
.globl vector23
vector23:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $23
80106518:	6a 17                	push   $0x17
  jmp alltraps
8010651a:	e9 78 fa ff ff       	jmp    80105f97 <alltraps>

8010651f <vector24>:
.globl vector24
vector24:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $24
80106521:	6a 18                	push   $0x18
  jmp alltraps
80106523:	e9 6f fa ff ff       	jmp    80105f97 <alltraps>

80106528 <vector25>:
.globl vector25
vector25:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $25
8010652a:	6a 19                	push   $0x19
  jmp alltraps
8010652c:	e9 66 fa ff ff       	jmp    80105f97 <alltraps>

80106531 <vector26>:
.globl vector26
vector26:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $26
80106533:	6a 1a                	push   $0x1a
  jmp alltraps
80106535:	e9 5d fa ff ff       	jmp    80105f97 <alltraps>

8010653a <vector27>:
.globl vector27
vector27:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $27
8010653c:	6a 1b                	push   $0x1b
  jmp alltraps
8010653e:	e9 54 fa ff ff       	jmp    80105f97 <alltraps>

80106543 <vector28>:
.globl vector28
vector28:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $28
80106545:	6a 1c                	push   $0x1c
  jmp alltraps
80106547:	e9 4b fa ff ff       	jmp    80105f97 <alltraps>

8010654c <vector29>:
.globl vector29
vector29:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $29
8010654e:	6a 1d                	push   $0x1d
  jmp alltraps
80106550:	e9 42 fa ff ff       	jmp    80105f97 <alltraps>

80106555 <vector30>:
.globl vector30
vector30:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $30
80106557:	6a 1e                	push   $0x1e
  jmp alltraps
80106559:	e9 39 fa ff ff       	jmp    80105f97 <alltraps>

8010655e <vector31>:
.globl vector31
vector31:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $31
80106560:	6a 1f                	push   $0x1f
  jmp alltraps
80106562:	e9 30 fa ff ff       	jmp    80105f97 <alltraps>

80106567 <vector32>:
.globl vector32
vector32:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $32
80106569:	6a 20                	push   $0x20
  jmp alltraps
8010656b:	e9 27 fa ff ff       	jmp    80105f97 <alltraps>

80106570 <vector33>:
.globl vector33
vector33:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $33
80106572:	6a 21                	push   $0x21
  jmp alltraps
80106574:	e9 1e fa ff ff       	jmp    80105f97 <alltraps>

80106579 <vector34>:
.globl vector34
vector34:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $34
8010657b:	6a 22                	push   $0x22
  jmp alltraps
8010657d:	e9 15 fa ff ff       	jmp    80105f97 <alltraps>

80106582 <vector35>:
.globl vector35
vector35:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $35
80106584:	6a 23                	push   $0x23
  jmp alltraps
80106586:	e9 0c fa ff ff       	jmp    80105f97 <alltraps>

8010658b <vector36>:
.globl vector36
vector36:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $36
8010658d:	6a 24                	push   $0x24
  jmp alltraps
8010658f:	e9 03 fa ff ff       	jmp    80105f97 <alltraps>

80106594 <vector37>:
.globl vector37
vector37:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $37
80106596:	6a 25                	push   $0x25
  jmp alltraps
80106598:	e9 fa f9 ff ff       	jmp    80105f97 <alltraps>

8010659d <vector38>:
.globl vector38
vector38:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $38
8010659f:	6a 26                	push   $0x26
  jmp alltraps
801065a1:	e9 f1 f9 ff ff       	jmp    80105f97 <alltraps>

801065a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $39
801065a8:	6a 27                	push   $0x27
  jmp alltraps
801065aa:	e9 e8 f9 ff ff       	jmp    80105f97 <alltraps>

801065af <vector40>:
.globl vector40
vector40:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $40
801065b1:	6a 28                	push   $0x28
  jmp alltraps
801065b3:	e9 df f9 ff ff       	jmp    80105f97 <alltraps>

801065b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $41
801065ba:	6a 29                	push   $0x29
  jmp alltraps
801065bc:	e9 d6 f9 ff ff       	jmp    80105f97 <alltraps>

801065c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $42
801065c3:	6a 2a                	push   $0x2a
  jmp alltraps
801065c5:	e9 cd f9 ff ff       	jmp    80105f97 <alltraps>

801065ca <vector43>:
.globl vector43
vector43:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $43
801065cc:	6a 2b                	push   $0x2b
  jmp alltraps
801065ce:	e9 c4 f9 ff ff       	jmp    80105f97 <alltraps>

801065d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $44
801065d5:	6a 2c                	push   $0x2c
  jmp alltraps
801065d7:	e9 bb f9 ff ff       	jmp    80105f97 <alltraps>

801065dc <vector45>:
.globl vector45
vector45:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $45
801065de:	6a 2d                	push   $0x2d
  jmp alltraps
801065e0:	e9 b2 f9 ff ff       	jmp    80105f97 <alltraps>

801065e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $46
801065e7:	6a 2e                	push   $0x2e
  jmp alltraps
801065e9:	e9 a9 f9 ff ff       	jmp    80105f97 <alltraps>

801065ee <vector47>:
.globl vector47
vector47:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $47
801065f0:	6a 2f                	push   $0x2f
  jmp alltraps
801065f2:	e9 a0 f9 ff ff       	jmp    80105f97 <alltraps>

801065f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $48
801065f9:	6a 30                	push   $0x30
  jmp alltraps
801065fb:	e9 97 f9 ff ff       	jmp    80105f97 <alltraps>

80106600 <vector49>:
.globl vector49
vector49:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $49
80106602:	6a 31                	push   $0x31
  jmp alltraps
80106604:	e9 8e f9 ff ff       	jmp    80105f97 <alltraps>

80106609 <vector50>:
.globl vector50
vector50:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $50
8010660b:	6a 32                	push   $0x32
  jmp alltraps
8010660d:	e9 85 f9 ff ff       	jmp    80105f97 <alltraps>

80106612 <vector51>:
.globl vector51
vector51:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $51
80106614:	6a 33                	push   $0x33
  jmp alltraps
80106616:	e9 7c f9 ff ff       	jmp    80105f97 <alltraps>

8010661b <vector52>:
.globl vector52
vector52:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $52
8010661d:	6a 34                	push   $0x34
  jmp alltraps
8010661f:	e9 73 f9 ff ff       	jmp    80105f97 <alltraps>

80106624 <vector53>:
.globl vector53
vector53:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $53
80106626:	6a 35                	push   $0x35
  jmp alltraps
80106628:	e9 6a f9 ff ff       	jmp    80105f97 <alltraps>

8010662d <vector54>:
.globl vector54
vector54:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $54
8010662f:	6a 36                	push   $0x36
  jmp alltraps
80106631:	e9 61 f9 ff ff       	jmp    80105f97 <alltraps>

80106636 <vector55>:
.globl vector55
vector55:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $55
80106638:	6a 37                	push   $0x37
  jmp alltraps
8010663a:	e9 58 f9 ff ff       	jmp    80105f97 <alltraps>

8010663f <vector56>:
.globl vector56
vector56:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $56
80106641:	6a 38                	push   $0x38
  jmp alltraps
80106643:	e9 4f f9 ff ff       	jmp    80105f97 <alltraps>

80106648 <vector57>:
.globl vector57
vector57:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $57
8010664a:	6a 39                	push   $0x39
  jmp alltraps
8010664c:	e9 46 f9 ff ff       	jmp    80105f97 <alltraps>

80106651 <vector58>:
.globl vector58
vector58:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $58
80106653:	6a 3a                	push   $0x3a
  jmp alltraps
80106655:	e9 3d f9 ff ff       	jmp    80105f97 <alltraps>

8010665a <vector59>:
.globl vector59
vector59:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $59
8010665c:	6a 3b                	push   $0x3b
  jmp alltraps
8010665e:	e9 34 f9 ff ff       	jmp    80105f97 <alltraps>

80106663 <vector60>:
.globl vector60
vector60:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $60
80106665:	6a 3c                	push   $0x3c
  jmp alltraps
80106667:	e9 2b f9 ff ff       	jmp    80105f97 <alltraps>

8010666c <vector61>:
.globl vector61
vector61:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $61
8010666e:	6a 3d                	push   $0x3d
  jmp alltraps
80106670:	e9 22 f9 ff ff       	jmp    80105f97 <alltraps>

80106675 <vector62>:
.globl vector62
vector62:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $62
80106677:	6a 3e                	push   $0x3e
  jmp alltraps
80106679:	e9 19 f9 ff ff       	jmp    80105f97 <alltraps>

8010667e <vector63>:
.globl vector63
vector63:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $63
80106680:	6a 3f                	push   $0x3f
  jmp alltraps
80106682:	e9 10 f9 ff ff       	jmp    80105f97 <alltraps>

80106687 <vector64>:
.globl vector64
vector64:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $64
80106689:	6a 40                	push   $0x40
  jmp alltraps
8010668b:	e9 07 f9 ff ff       	jmp    80105f97 <alltraps>

80106690 <vector65>:
.globl vector65
vector65:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $65
80106692:	6a 41                	push   $0x41
  jmp alltraps
80106694:	e9 fe f8 ff ff       	jmp    80105f97 <alltraps>

80106699 <vector66>:
.globl vector66
vector66:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $66
8010669b:	6a 42                	push   $0x42
  jmp alltraps
8010669d:	e9 f5 f8 ff ff       	jmp    80105f97 <alltraps>

801066a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $67
801066a4:	6a 43                	push   $0x43
  jmp alltraps
801066a6:	e9 ec f8 ff ff       	jmp    80105f97 <alltraps>

801066ab <vector68>:
.globl vector68
vector68:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $68
801066ad:	6a 44                	push   $0x44
  jmp alltraps
801066af:	e9 e3 f8 ff ff       	jmp    80105f97 <alltraps>

801066b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $69
801066b6:	6a 45                	push   $0x45
  jmp alltraps
801066b8:	e9 da f8 ff ff       	jmp    80105f97 <alltraps>

801066bd <vector70>:
.globl vector70
vector70:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $70
801066bf:	6a 46                	push   $0x46
  jmp alltraps
801066c1:	e9 d1 f8 ff ff       	jmp    80105f97 <alltraps>

801066c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $71
801066c8:	6a 47                	push   $0x47
  jmp alltraps
801066ca:	e9 c8 f8 ff ff       	jmp    80105f97 <alltraps>

801066cf <vector72>:
.globl vector72
vector72:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $72
801066d1:	6a 48                	push   $0x48
  jmp alltraps
801066d3:	e9 bf f8 ff ff       	jmp    80105f97 <alltraps>

801066d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $73
801066da:	6a 49                	push   $0x49
  jmp alltraps
801066dc:	e9 b6 f8 ff ff       	jmp    80105f97 <alltraps>

801066e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $74
801066e3:	6a 4a                	push   $0x4a
  jmp alltraps
801066e5:	e9 ad f8 ff ff       	jmp    80105f97 <alltraps>

801066ea <vector75>:
.globl vector75
vector75:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $75
801066ec:	6a 4b                	push   $0x4b
  jmp alltraps
801066ee:	e9 a4 f8 ff ff       	jmp    80105f97 <alltraps>

801066f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $76
801066f5:	6a 4c                	push   $0x4c
  jmp alltraps
801066f7:	e9 9b f8 ff ff       	jmp    80105f97 <alltraps>

801066fc <vector77>:
.globl vector77
vector77:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $77
801066fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106700:	e9 92 f8 ff ff       	jmp    80105f97 <alltraps>

80106705 <vector78>:
.globl vector78
vector78:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $78
80106707:	6a 4e                	push   $0x4e
  jmp alltraps
80106709:	e9 89 f8 ff ff       	jmp    80105f97 <alltraps>

8010670e <vector79>:
.globl vector79
vector79:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $79
80106710:	6a 4f                	push   $0x4f
  jmp alltraps
80106712:	e9 80 f8 ff ff       	jmp    80105f97 <alltraps>

80106717 <vector80>:
.globl vector80
vector80:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $80
80106719:	6a 50                	push   $0x50
  jmp alltraps
8010671b:	e9 77 f8 ff ff       	jmp    80105f97 <alltraps>

80106720 <vector81>:
.globl vector81
vector81:
  pushl $0
80106720:	6a 00                	push   $0x0
  pushl $81
80106722:	6a 51                	push   $0x51
  jmp alltraps
80106724:	e9 6e f8 ff ff       	jmp    80105f97 <alltraps>

80106729 <vector82>:
.globl vector82
vector82:
  pushl $0
80106729:	6a 00                	push   $0x0
  pushl $82
8010672b:	6a 52                	push   $0x52
  jmp alltraps
8010672d:	e9 65 f8 ff ff       	jmp    80105f97 <alltraps>

80106732 <vector83>:
.globl vector83
vector83:
  pushl $0
80106732:	6a 00                	push   $0x0
  pushl $83
80106734:	6a 53                	push   $0x53
  jmp alltraps
80106736:	e9 5c f8 ff ff       	jmp    80105f97 <alltraps>

8010673b <vector84>:
.globl vector84
vector84:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $84
8010673d:	6a 54                	push   $0x54
  jmp alltraps
8010673f:	e9 53 f8 ff ff       	jmp    80105f97 <alltraps>

80106744 <vector85>:
.globl vector85
vector85:
  pushl $0
80106744:	6a 00                	push   $0x0
  pushl $85
80106746:	6a 55                	push   $0x55
  jmp alltraps
80106748:	e9 4a f8 ff ff       	jmp    80105f97 <alltraps>

8010674d <vector86>:
.globl vector86
vector86:
  pushl $0
8010674d:	6a 00                	push   $0x0
  pushl $86
8010674f:	6a 56                	push   $0x56
  jmp alltraps
80106751:	e9 41 f8 ff ff       	jmp    80105f97 <alltraps>

80106756 <vector87>:
.globl vector87
vector87:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $87
80106758:	6a 57                	push   $0x57
  jmp alltraps
8010675a:	e9 38 f8 ff ff       	jmp    80105f97 <alltraps>

8010675f <vector88>:
.globl vector88
vector88:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $88
80106761:	6a 58                	push   $0x58
  jmp alltraps
80106763:	e9 2f f8 ff ff       	jmp    80105f97 <alltraps>

80106768 <vector89>:
.globl vector89
vector89:
  pushl $0
80106768:	6a 00                	push   $0x0
  pushl $89
8010676a:	6a 59                	push   $0x59
  jmp alltraps
8010676c:	e9 26 f8 ff ff       	jmp    80105f97 <alltraps>

80106771 <vector90>:
.globl vector90
vector90:
  pushl $0
80106771:	6a 00                	push   $0x0
  pushl $90
80106773:	6a 5a                	push   $0x5a
  jmp alltraps
80106775:	e9 1d f8 ff ff       	jmp    80105f97 <alltraps>

8010677a <vector91>:
.globl vector91
vector91:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $91
8010677c:	6a 5b                	push   $0x5b
  jmp alltraps
8010677e:	e9 14 f8 ff ff       	jmp    80105f97 <alltraps>

80106783 <vector92>:
.globl vector92
vector92:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $92
80106785:	6a 5c                	push   $0x5c
  jmp alltraps
80106787:	e9 0b f8 ff ff       	jmp    80105f97 <alltraps>

8010678c <vector93>:
.globl vector93
vector93:
  pushl $0
8010678c:	6a 00                	push   $0x0
  pushl $93
8010678e:	6a 5d                	push   $0x5d
  jmp alltraps
80106790:	e9 02 f8 ff ff       	jmp    80105f97 <alltraps>

80106795 <vector94>:
.globl vector94
vector94:
  pushl $0
80106795:	6a 00                	push   $0x0
  pushl $94
80106797:	6a 5e                	push   $0x5e
  jmp alltraps
80106799:	e9 f9 f7 ff ff       	jmp    80105f97 <alltraps>

8010679e <vector95>:
.globl vector95
vector95:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $95
801067a0:	6a 5f                	push   $0x5f
  jmp alltraps
801067a2:	e9 f0 f7 ff ff       	jmp    80105f97 <alltraps>

801067a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $96
801067a9:	6a 60                	push   $0x60
  jmp alltraps
801067ab:	e9 e7 f7 ff ff       	jmp    80105f97 <alltraps>

801067b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801067b0:	6a 00                	push   $0x0
  pushl $97
801067b2:	6a 61                	push   $0x61
  jmp alltraps
801067b4:	e9 de f7 ff ff       	jmp    80105f97 <alltraps>

801067b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $98
801067bb:	6a 62                	push   $0x62
  jmp alltraps
801067bd:	e9 d5 f7 ff ff       	jmp    80105f97 <alltraps>

801067c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $99
801067c4:	6a 63                	push   $0x63
  jmp alltraps
801067c6:	e9 cc f7 ff ff       	jmp    80105f97 <alltraps>

801067cb <vector100>:
.globl vector100
vector100:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $100
801067cd:	6a 64                	push   $0x64
  jmp alltraps
801067cf:	e9 c3 f7 ff ff       	jmp    80105f97 <alltraps>

801067d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $101
801067d6:	6a 65                	push   $0x65
  jmp alltraps
801067d8:	e9 ba f7 ff ff       	jmp    80105f97 <alltraps>

801067dd <vector102>:
.globl vector102
vector102:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $102
801067df:	6a 66                	push   $0x66
  jmp alltraps
801067e1:	e9 b1 f7 ff ff       	jmp    80105f97 <alltraps>

801067e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $103
801067e8:	6a 67                	push   $0x67
  jmp alltraps
801067ea:	e9 a8 f7 ff ff       	jmp    80105f97 <alltraps>

801067ef <vector104>:
.globl vector104
vector104:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $104
801067f1:	6a 68                	push   $0x68
  jmp alltraps
801067f3:	e9 9f f7 ff ff       	jmp    80105f97 <alltraps>

801067f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $105
801067fa:	6a 69                	push   $0x69
  jmp alltraps
801067fc:	e9 96 f7 ff ff       	jmp    80105f97 <alltraps>

80106801 <vector106>:
.globl vector106
vector106:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $106
80106803:	6a 6a                	push   $0x6a
  jmp alltraps
80106805:	e9 8d f7 ff ff       	jmp    80105f97 <alltraps>

8010680a <vector107>:
.globl vector107
vector107:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $107
8010680c:	6a 6b                	push   $0x6b
  jmp alltraps
8010680e:	e9 84 f7 ff ff       	jmp    80105f97 <alltraps>

80106813 <vector108>:
.globl vector108
vector108:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $108
80106815:	6a 6c                	push   $0x6c
  jmp alltraps
80106817:	e9 7b f7 ff ff       	jmp    80105f97 <alltraps>

8010681c <vector109>:
.globl vector109
vector109:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $109
8010681e:	6a 6d                	push   $0x6d
  jmp alltraps
80106820:	e9 72 f7 ff ff       	jmp    80105f97 <alltraps>

80106825 <vector110>:
.globl vector110
vector110:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $110
80106827:	6a 6e                	push   $0x6e
  jmp alltraps
80106829:	e9 69 f7 ff ff       	jmp    80105f97 <alltraps>

8010682e <vector111>:
.globl vector111
vector111:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $111
80106830:	6a 6f                	push   $0x6f
  jmp alltraps
80106832:	e9 60 f7 ff ff       	jmp    80105f97 <alltraps>

80106837 <vector112>:
.globl vector112
vector112:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $112
80106839:	6a 70                	push   $0x70
  jmp alltraps
8010683b:	e9 57 f7 ff ff       	jmp    80105f97 <alltraps>

80106840 <vector113>:
.globl vector113
vector113:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $113
80106842:	6a 71                	push   $0x71
  jmp alltraps
80106844:	e9 4e f7 ff ff       	jmp    80105f97 <alltraps>

80106849 <vector114>:
.globl vector114
vector114:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $114
8010684b:	6a 72                	push   $0x72
  jmp alltraps
8010684d:	e9 45 f7 ff ff       	jmp    80105f97 <alltraps>

80106852 <vector115>:
.globl vector115
vector115:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $115
80106854:	6a 73                	push   $0x73
  jmp alltraps
80106856:	e9 3c f7 ff ff       	jmp    80105f97 <alltraps>

8010685b <vector116>:
.globl vector116
vector116:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $116
8010685d:	6a 74                	push   $0x74
  jmp alltraps
8010685f:	e9 33 f7 ff ff       	jmp    80105f97 <alltraps>

80106864 <vector117>:
.globl vector117
vector117:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $117
80106866:	6a 75                	push   $0x75
  jmp alltraps
80106868:	e9 2a f7 ff ff       	jmp    80105f97 <alltraps>

8010686d <vector118>:
.globl vector118
vector118:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $118
8010686f:	6a 76                	push   $0x76
  jmp alltraps
80106871:	e9 21 f7 ff ff       	jmp    80105f97 <alltraps>

80106876 <vector119>:
.globl vector119
vector119:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $119
80106878:	6a 77                	push   $0x77
  jmp alltraps
8010687a:	e9 18 f7 ff ff       	jmp    80105f97 <alltraps>

8010687f <vector120>:
.globl vector120
vector120:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $120
80106881:	6a 78                	push   $0x78
  jmp alltraps
80106883:	e9 0f f7 ff ff       	jmp    80105f97 <alltraps>

80106888 <vector121>:
.globl vector121
vector121:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $121
8010688a:	6a 79                	push   $0x79
  jmp alltraps
8010688c:	e9 06 f7 ff ff       	jmp    80105f97 <alltraps>

80106891 <vector122>:
.globl vector122
vector122:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $122
80106893:	6a 7a                	push   $0x7a
  jmp alltraps
80106895:	e9 fd f6 ff ff       	jmp    80105f97 <alltraps>

8010689a <vector123>:
.globl vector123
vector123:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $123
8010689c:	6a 7b                	push   $0x7b
  jmp alltraps
8010689e:	e9 f4 f6 ff ff       	jmp    80105f97 <alltraps>

801068a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $124
801068a5:	6a 7c                	push   $0x7c
  jmp alltraps
801068a7:	e9 eb f6 ff ff       	jmp    80105f97 <alltraps>

801068ac <vector125>:
.globl vector125
vector125:
  pushl $0
801068ac:	6a 00                	push   $0x0
  pushl $125
801068ae:	6a 7d                	push   $0x7d
  jmp alltraps
801068b0:	e9 e2 f6 ff ff       	jmp    80105f97 <alltraps>

801068b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801068b5:	6a 00                	push   $0x0
  pushl $126
801068b7:	6a 7e                	push   $0x7e
  jmp alltraps
801068b9:	e9 d9 f6 ff ff       	jmp    80105f97 <alltraps>

801068be <vector127>:
.globl vector127
vector127:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $127
801068c0:	6a 7f                	push   $0x7f
  jmp alltraps
801068c2:	e9 d0 f6 ff ff       	jmp    80105f97 <alltraps>

801068c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $128
801068c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801068ce:	e9 c4 f6 ff ff       	jmp    80105f97 <alltraps>

801068d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $129
801068d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068da:	e9 b8 f6 ff ff       	jmp    80105f97 <alltraps>

801068df <vector130>:
.globl vector130
vector130:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $130
801068e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068e6:	e9 ac f6 ff ff       	jmp    80105f97 <alltraps>

801068eb <vector131>:
.globl vector131
vector131:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $131
801068ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068f2:	e9 a0 f6 ff ff       	jmp    80105f97 <alltraps>

801068f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $132
801068f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068fe:	e9 94 f6 ff ff       	jmp    80105f97 <alltraps>

80106903 <vector133>:
.globl vector133
vector133:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $133
80106905:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010690a:	e9 88 f6 ff ff       	jmp    80105f97 <alltraps>

8010690f <vector134>:
.globl vector134
vector134:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $134
80106911:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106916:	e9 7c f6 ff ff       	jmp    80105f97 <alltraps>

8010691b <vector135>:
.globl vector135
vector135:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $135
8010691d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106922:	e9 70 f6 ff ff       	jmp    80105f97 <alltraps>

80106927 <vector136>:
.globl vector136
vector136:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $136
80106929:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010692e:	e9 64 f6 ff ff       	jmp    80105f97 <alltraps>

80106933 <vector137>:
.globl vector137
vector137:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $137
80106935:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010693a:	e9 58 f6 ff ff       	jmp    80105f97 <alltraps>

8010693f <vector138>:
.globl vector138
vector138:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $138
80106941:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106946:	e9 4c f6 ff ff       	jmp    80105f97 <alltraps>

8010694b <vector139>:
.globl vector139
vector139:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $139
8010694d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106952:	e9 40 f6 ff ff       	jmp    80105f97 <alltraps>

80106957 <vector140>:
.globl vector140
vector140:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $140
80106959:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010695e:	e9 34 f6 ff ff       	jmp    80105f97 <alltraps>

80106963 <vector141>:
.globl vector141
vector141:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $141
80106965:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010696a:	e9 28 f6 ff ff       	jmp    80105f97 <alltraps>

8010696f <vector142>:
.globl vector142
vector142:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $142
80106971:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106976:	e9 1c f6 ff ff       	jmp    80105f97 <alltraps>

8010697b <vector143>:
.globl vector143
vector143:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $143
8010697d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106982:	e9 10 f6 ff ff       	jmp    80105f97 <alltraps>

80106987 <vector144>:
.globl vector144
vector144:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $144
80106989:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010698e:	e9 04 f6 ff ff       	jmp    80105f97 <alltraps>

80106993 <vector145>:
.globl vector145
vector145:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $145
80106995:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010699a:	e9 f8 f5 ff ff       	jmp    80105f97 <alltraps>

8010699f <vector146>:
.globl vector146
vector146:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $146
801069a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801069a6:	e9 ec f5 ff ff       	jmp    80105f97 <alltraps>

801069ab <vector147>:
.globl vector147
vector147:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $147
801069ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801069b2:	e9 e0 f5 ff ff       	jmp    80105f97 <alltraps>

801069b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $148
801069b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801069be:	e9 d4 f5 ff ff       	jmp    80105f97 <alltraps>

801069c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $149
801069c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801069ca:	e9 c8 f5 ff ff       	jmp    80105f97 <alltraps>

801069cf <vector150>:
.globl vector150
vector150:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $150
801069d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069d6:	e9 bc f5 ff ff       	jmp    80105f97 <alltraps>

801069db <vector151>:
.globl vector151
vector151:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $151
801069dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069e2:	e9 b0 f5 ff ff       	jmp    80105f97 <alltraps>

801069e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $152
801069e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069ee:	e9 a4 f5 ff ff       	jmp    80105f97 <alltraps>

801069f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $153
801069f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069fa:	e9 98 f5 ff ff       	jmp    80105f97 <alltraps>

801069ff <vector154>:
.globl vector154
vector154:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $154
80106a01:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a06:	e9 8c f5 ff ff       	jmp    80105f97 <alltraps>

80106a0b <vector155>:
.globl vector155
vector155:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $155
80106a0d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a12:	e9 80 f5 ff ff       	jmp    80105f97 <alltraps>

80106a17 <vector156>:
.globl vector156
vector156:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $156
80106a19:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a1e:	e9 74 f5 ff ff       	jmp    80105f97 <alltraps>

80106a23 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $157
80106a25:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a2a:	e9 68 f5 ff ff       	jmp    80105f97 <alltraps>

80106a2f <vector158>:
.globl vector158
vector158:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $158
80106a31:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a36:	e9 5c f5 ff ff       	jmp    80105f97 <alltraps>

80106a3b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $159
80106a3d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a42:	e9 50 f5 ff ff       	jmp    80105f97 <alltraps>

80106a47 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $160
80106a49:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a4e:	e9 44 f5 ff ff       	jmp    80105f97 <alltraps>

80106a53 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $161
80106a55:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a5a:	e9 38 f5 ff ff       	jmp    80105f97 <alltraps>

80106a5f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $162
80106a61:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a66:	e9 2c f5 ff ff       	jmp    80105f97 <alltraps>

80106a6b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $163
80106a6d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a72:	e9 20 f5 ff ff       	jmp    80105f97 <alltraps>

80106a77 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $164
80106a79:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a7e:	e9 14 f5 ff ff       	jmp    80105f97 <alltraps>

80106a83 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $165
80106a85:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a8a:	e9 08 f5 ff ff       	jmp    80105f97 <alltraps>

80106a8f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $166
80106a91:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a96:	e9 fc f4 ff ff       	jmp    80105f97 <alltraps>

80106a9b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $167
80106a9d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106aa2:	e9 f0 f4 ff ff       	jmp    80105f97 <alltraps>

80106aa7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $168
80106aa9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106aae:	e9 e4 f4 ff ff       	jmp    80105f97 <alltraps>

80106ab3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $169
80106ab5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106aba:	e9 d8 f4 ff ff       	jmp    80105f97 <alltraps>

80106abf <vector170>:
.globl vector170
vector170:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $170
80106ac1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ac6:	e9 cc f4 ff ff       	jmp    80105f97 <alltraps>

80106acb <vector171>:
.globl vector171
vector171:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $171
80106acd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ad2:	e9 c0 f4 ff ff       	jmp    80105f97 <alltraps>

80106ad7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $172
80106ad9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106ade:	e9 b4 f4 ff ff       	jmp    80105f97 <alltraps>

80106ae3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $173
80106ae5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106aea:	e9 a8 f4 ff ff       	jmp    80105f97 <alltraps>

80106aef <vector174>:
.globl vector174
vector174:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $174
80106af1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106af6:	e9 9c f4 ff ff       	jmp    80105f97 <alltraps>

80106afb <vector175>:
.globl vector175
vector175:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $175
80106afd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b02:	e9 90 f4 ff ff       	jmp    80105f97 <alltraps>

80106b07 <vector176>:
.globl vector176
vector176:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $176
80106b09:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b0e:	e9 84 f4 ff ff       	jmp    80105f97 <alltraps>

80106b13 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $177
80106b15:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b1a:	e9 78 f4 ff ff       	jmp    80105f97 <alltraps>

80106b1f <vector178>:
.globl vector178
vector178:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $178
80106b21:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b26:	e9 6c f4 ff ff       	jmp    80105f97 <alltraps>

80106b2b <vector179>:
.globl vector179
vector179:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $179
80106b2d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b32:	e9 60 f4 ff ff       	jmp    80105f97 <alltraps>

80106b37 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $180
80106b39:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b3e:	e9 54 f4 ff ff       	jmp    80105f97 <alltraps>

80106b43 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $181
80106b45:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b4a:	e9 48 f4 ff ff       	jmp    80105f97 <alltraps>

80106b4f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $182
80106b51:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b56:	e9 3c f4 ff ff       	jmp    80105f97 <alltraps>

80106b5b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $183
80106b5d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b62:	e9 30 f4 ff ff       	jmp    80105f97 <alltraps>

80106b67 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $184
80106b69:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b6e:	e9 24 f4 ff ff       	jmp    80105f97 <alltraps>

80106b73 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $185
80106b75:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b7a:	e9 18 f4 ff ff       	jmp    80105f97 <alltraps>

80106b7f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $186
80106b81:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b86:	e9 0c f4 ff ff       	jmp    80105f97 <alltraps>

80106b8b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $187
80106b8d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b92:	e9 00 f4 ff ff       	jmp    80105f97 <alltraps>

80106b97 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $188
80106b99:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b9e:	e9 f4 f3 ff ff       	jmp    80105f97 <alltraps>

80106ba3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $189
80106ba5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106baa:	e9 e8 f3 ff ff       	jmp    80105f97 <alltraps>

80106baf <vector190>:
.globl vector190
vector190:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $190
80106bb1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106bb6:	e9 dc f3 ff ff       	jmp    80105f97 <alltraps>

80106bbb <vector191>:
.globl vector191
vector191:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $191
80106bbd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106bc2:	e9 d0 f3 ff ff       	jmp    80105f97 <alltraps>

80106bc7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $192
80106bc9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106bce:	e9 c4 f3 ff ff       	jmp    80105f97 <alltraps>

80106bd3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $193
80106bd5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106bda:	e9 b8 f3 ff ff       	jmp    80105f97 <alltraps>

80106bdf <vector194>:
.globl vector194
vector194:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $194
80106be1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106be6:	e9 ac f3 ff ff       	jmp    80105f97 <alltraps>

80106beb <vector195>:
.globl vector195
vector195:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $195
80106bed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bf2:	e9 a0 f3 ff ff       	jmp    80105f97 <alltraps>

80106bf7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $196
80106bf9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bfe:	e9 94 f3 ff ff       	jmp    80105f97 <alltraps>

80106c03 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $197
80106c05:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c0a:	e9 88 f3 ff ff       	jmp    80105f97 <alltraps>

80106c0f <vector198>:
.globl vector198
vector198:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $198
80106c11:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c16:	e9 7c f3 ff ff       	jmp    80105f97 <alltraps>

80106c1b <vector199>:
.globl vector199
vector199:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $199
80106c1d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c22:	e9 70 f3 ff ff       	jmp    80105f97 <alltraps>

80106c27 <vector200>:
.globl vector200
vector200:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $200
80106c29:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c2e:	e9 64 f3 ff ff       	jmp    80105f97 <alltraps>

80106c33 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $201
80106c35:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c3a:	e9 58 f3 ff ff       	jmp    80105f97 <alltraps>

80106c3f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $202
80106c41:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c46:	e9 4c f3 ff ff       	jmp    80105f97 <alltraps>

80106c4b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $203
80106c4d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c52:	e9 40 f3 ff ff       	jmp    80105f97 <alltraps>

80106c57 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $204
80106c59:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c5e:	e9 34 f3 ff ff       	jmp    80105f97 <alltraps>

80106c63 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $205
80106c65:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c6a:	e9 28 f3 ff ff       	jmp    80105f97 <alltraps>

80106c6f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $206
80106c71:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c76:	e9 1c f3 ff ff       	jmp    80105f97 <alltraps>

80106c7b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $207
80106c7d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c82:	e9 10 f3 ff ff       	jmp    80105f97 <alltraps>

80106c87 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $208
80106c89:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c8e:	e9 04 f3 ff ff       	jmp    80105f97 <alltraps>

80106c93 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $209
80106c95:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c9a:	e9 f8 f2 ff ff       	jmp    80105f97 <alltraps>

80106c9f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $210
80106ca1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ca6:	e9 ec f2 ff ff       	jmp    80105f97 <alltraps>

80106cab <vector211>:
.globl vector211
vector211:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $211
80106cad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106cb2:	e9 e0 f2 ff ff       	jmp    80105f97 <alltraps>

80106cb7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $212
80106cb9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106cbe:	e9 d4 f2 ff ff       	jmp    80105f97 <alltraps>

80106cc3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $213
80106cc5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106cca:	e9 c8 f2 ff ff       	jmp    80105f97 <alltraps>

80106ccf <vector214>:
.globl vector214
vector214:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $214
80106cd1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106cd6:	e9 bc f2 ff ff       	jmp    80105f97 <alltraps>

80106cdb <vector215>:
.globl vector215
vector215:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $215
80106cdd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ce2:	e9 b0 f2 ff ff       	jmp    80105f97 <alltraps>

80106ce7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $216
80106ce9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cee:	e9 a4 f2 ff ff       	jmp    80105f97 <alltraps>

80106cf3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $217
80106cf5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cfa:	e9 98 f2 ff ff       	jmp    80105f97 <alltraps>

80106cff <vector218>:
.globl vector218
vector218:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $218
80106d01:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d06:	e9 8c f2 ff ff       	jmp    80105f97 <alltraps>

80106d0b <vector219>:
.globl vector219
vector219:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $219
80106d0d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d12:	e9 80 f2 ff ff       	jmp    80105f97 <alltraps>

80106d17 <vector220>:
.globl vector220
vector220:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $220
80106d19:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d1e:	e9 74 f2 ff ff       	jmp    80105f97 <alltraps>

80106d23 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $221
80106d25:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d2a:	e9 68 f2 ff ff       	jmp    80105f97 <alltraps>

80106d2f <vector222>:
.globl vector222
vector222:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $222
80106d31:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d36:	e9 5c f2 ff ff       	jmp    80105f97 <alltraps>

80106d3b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $223
80106d3d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d42:	e9 50 f2 ff ff       	jmp    80105f97 <alltraps>

80106d47 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $224
80106d49:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d4e:	e9 44 f2 ff ff       	jmp    80105f97 <alltraps>

80106d53 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $225
80106d55:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d5a:	e9 38 f2 ff ff       	jmp    80105f97 <alltraps>

80106d5f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $226
80106d61:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d66:	e9 2c f2 ff ff       	jmp    80105f97 <alltraps>

80106d6b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $227
80106d6d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d72:	e9 20 f2 ff ff       	jmp    80105f97 <alltraps>

80106d77 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $228
80106d79:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d7e:	e9 14 f2 ff ff       	jmp    80105f97 <alltraps>

80106d83 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $229
80106d85:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d8a:	e9 08 f2 ff ff       	jmp    80105f97 <alltraps>

80106d8f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $230
80106d91:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d96:	e9 fc f1 ff ff       	jmp    80105f97 <alltraps>

80106d9b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $231
80106d9d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106da2:	e9 f0 f1 ff ff       	jmp    80105f97 <alltraps>

80106da7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $232
80106da9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106dae:	e9 e4 f1 ff ff       	jmp    80105f97 <alltraps>

80106db3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $233
80106db5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106dba:	e9 d8 f1 ff ff       	jmp    80105f97 <alltraps>

80106dbf <vector234>:
.globl vector234
vector234:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $234
80106dc1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106dc6:	e9 cc f1 ff ff       	jmp    80105f97 <alltraps>

80106dcb <vector235>:
.globl vector235
vector235:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $235
80106dcd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106dd2:	e9 c0 f1 ff ff       	jmp    80105f97 <alltraps>

80106dd7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $236
80106dd9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106dde:	e9 b4 f1 ff ff       	jmp    80105f97 <alltraps>

80106de3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $237
80106de5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dea:	e9 a8 f1 ff ff       	jmp    80105f97 <alltraps>

80106def <vector238>:
.globl vector238
vector238:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $238
80106df1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106df6:	e9 9c f1 ff ff       	jmp    80105f97 <alltraps>

80106dfb <vector239>:
.globl vector239
vector239:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $239
80106dfd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e02:	e9 90 f1 ff ff       	jmp    80105f97 <alltraps>

80106e07 <vector240>:
.globl vector240
vector240:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $240
80106e09:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e0e:	e9 84 f1 ff ff       	jmp    80105f97 <alltraps>

80106e13 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $241
80106e15:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e1a:	e9 78 f1 ff ff       	jmp    80105f97 <alltraps>

80106e1f <vector242>:
.globl vector242
vector242:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $242
80106e21:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e26:	e9 6c f1 ff ff       	jmp    80105f97 <alltraps>

80106e2b <vector243>:
.globl vector243
vector243:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $243
80106e2d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e32:	e9 60 f1 ff ff       	jmp    80105f97 <alltraps>

80106e37 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $244
80106e39:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e3e:	e9 54 f1 ff ff       	jmp    80105f97 <alltraps>

80106e43 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $245
80106e45:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e4a:	e9 48 f1 ff ff       	jmp    80105f97 <alltraps>

80106e4f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $246
80106e51:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e56:	e9 3c f1 ff ff       	jmp    80105f97 <alltraps>

80106e5b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $247
80106e5d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e62:	e9 30 f1 ff ff       	jmp    80105f97 <alltraps>

80106e67 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $248
80106e69:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e6e:	e9 24 f1 ff ff       	jmp    80105f97 <alltraps>

80106e73 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $249
80106e75:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e7a:	e9 18 f1 ff ff       	jmp    80105f97 <alltraps>

80106e7f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $250
80106e81:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e86:	e9 0c f1 ff ff       	jmp    80105f97 <alltraps>

80106e8b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $251
80106e8d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e92:	e9 00 f1 ff ff       	jmp    80105f97 <alltraps>

80106e97 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $252
80106e99:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e9e:	e9 f4 f0 ff ff       	jmp    80105f97 <alltraps>

80106ea3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $253
80106ea5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106eaa:	e9 e8 f0 ff ff       	jmp    80105f97 <alltraps>

80106eaf <vector254>:
.globl vector254
vector254:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $254
80106eb1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106eb6:	e9 dc f0 ff ff       	jmp    80105f97 <alltraps>

80106ebb <vector255>:
.globl vector255
vector255:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $255
80106ebd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ec2:	e9 d0 f0 ff ff       	jmp    80105f97 <alltraps>
80106ec7:	66 90                	xchg   %ax,%ax
80106ec9:	66 90                	xchg   %ax,%ax
80106ecb:	66 90                	xchg   %ax,%ax
80106ecd:	66 90                	xchg   %ax,%ax
80106ecf:	90                   	nop

80106ed0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ed8:	c1 ea 16             	shr    $0x16,%edx
80106edb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ede:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106ee1:	8b 07                	mov    (%edi),%eax
80106ee3:	a8 01                	test   $0x1,%al
80106ee5:	74 29                	je     80106f10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ee7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106eec:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ef5:	c1 eb 0a             	shr    $0xa,%ebx
80106ef8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106efe:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106f01:	5b                   	pop    %ebx
80106f02:	5e                   	pop    %esi
80106f03:	5f                   	pop    %edi
80106f04:	5d                   	pop    %ebp
80106f05:	c3                   	ret    
80106f06:	8d 76 00             	lea    0x0(%esi),%esi
80106f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f10:	85 c9                	test   %ecx,%ecx
80106f12:	74 2c                	je     80106f40 <walkpgdir+0x70>
80106f14:	e8 87 b5 ff ff       	call   801024a0 <kalloc>
80106f19:	85 c0                	test   %eax,%eax
80106f1b:	89 c6                	mov    %eax,%esi
80106f1d:	74 21                	je     80106f40 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106f1f:	83 ec 04             	sub    $0x4,%esp
80106f22:	68 00 10 00 00       	push   $0x1000
80106f27:	6a 00                	push   $0x0
80106f29:	50                   	push   %eax
80106f2a:	e8 b1 dd ff ff       	call   80104ce0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f2f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f35:	83 c4 10             	add    $0x10,%esp
80106f38:	83 c8 07             	or     $0x7,%eax
80106f3b:	89 07                	mov    %eax,(%edi)
80106f3d:	eb b3                	jmp    80106ef2 <walkpgdir+0x22>
80106f3f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106f43:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5f                   	pop    %edi
80106f48:	5d                   	pop    %ebp
80106f49:	c3                   	ret    
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106f56:	89 d3                	mov    %edx,%ebx
80106f58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f5e:	83 ec 1c             	sub    $0x1c,%esp
80106f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f73:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f76:	29 df                	sub    %ebx,%edi
80106f78:	83 c8 01             	or     $0x1,%eax
80106f7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f7e:	eb 15                	jmp    80106f95 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106f80:	f6 00 01             	testb  $0x1,(%eax)
80106f83:	75 45                	jne    80106fca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f85:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106f88:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f8d:	74 31                	je     80106fc0 <mappages+0x70>
      break;
    a += PGSIZE;
80106f8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f98:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f9d:	89 da                	mov    %ebx,%edx
80106f9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106fa2:	e8 29 ff ff ff       	call   80106ed0 <walkpgdir>
80106fa7:	85 c0                	test   %eax,%eax
80106fa9:	75 d5                	jne    80106f80 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106fab:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106fae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106fb3:	5b                   	pop    %ebx
80106fb4:	5e                   	pop    %esi
80106fb5:	5f                   	pop    %edi
80106fb6:	5d                   	pop    %ebp
80106fb7:	c3                   	ret    
80106fb8:	90                   	nop
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106fc3:	31 c0                	xor    %eax,%eax
}
80106fc5:	5b                   	pop    %ebx
80106fc6:	5e                   	pop    %esi
80106fc7:	5f                   	pop    %edi
80106fc8:	5d                   	pop    %ebp
80106fc9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106fca:	83 ec 0c             	sub    $0xc,%esp
80106fcd:	68 d8 81 10 80       	push   $0x801081d8
80106fd2:	e8 99 93 ff ff       	call   80100370 <panic>
80106fd7:	89 f6                	mov    %esi,%esi
80106fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fe0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fe6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fec:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ff4:	83 ec 1c             	sub    $0x1c,%esp
80106ff7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106ffa:	39 d3                	cmp    %edx,%ebx
80106ffc:	73 66                	jae    80107064 <deallocuvm.part.0+0x84>
80106ffe:	89 d6                	mov    %edx,%esi
80107000:	eb 3d                	jmp    8010703f <deallocuvm.part.0+0x5f>
80107002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107008:	8b 10                	mov    (%eax),%edx
8010700a:	f6 c2 01             	test   $0x1,%dl
8010700d:	74 26                	je     80107035 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010700f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107015:	74 58                	je     8010706f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107017:	83 ec 0c             	sub    $0xc,%esp
8010701a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107020:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107023:	52                   	push   %edx
80107024:	e8 c7 b2 ff ff       	call   801022f0 <kfree>
      *pte = 0;
80107029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010702c:	83 c4 10             	add    $0x10,%esp
8010702f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107035:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010703b:	39 f3                	cmp    %esi,%ebx
8010703d:	73 25                	jae    80107064 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010703f:	31 c9                	xor    %ecx,%ecx
80107041:	89 da                	mov    %ebx,%edx
80107043:	89 f8                	mov    %edi,%eax
80107045:	e8 86 fe ff ff       	call   80106ed0 <walkpgdir>
    if(!pte)
8010704a:	85 c0                	test   %eax,%eax
8010704c:	75 ba                	jne    80107008 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010704e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107054:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010705a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107060:	39 f3                	cmp    %esi,%ebx
80107062:	72 db                	jb     8010703f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107064:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107067:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010706a:	5b                   	pop    %ebx
8010706b:	5e                   	pop    %esi
8010706c:	5f                   	pop    %edi
8010706d:	5d                   	pop    %ebp
8010706e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010706f:	83 ec 0c             	sub    $0xc,%esp
80107072:	68 c6 7a 10 80       	push   $0x80107ac6
80107077:	e8 f4 92 ff ff       	call   80100370 <panic>
8010707c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107080 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107086:	e8 e5 c7 ff ff       	call   80103870 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010708b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107091:	31 c9                	xor    %ecx,%ecx
80107093:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107098:	66 89 90 18 38 11 80 	mov    %dx,-0x7feec7e8(%eax)
8010709f:	66 89 88 1a 38 11 80 	mov    %cx,-0x7feec7e6(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070a6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801070ab:	31 c9                	xor    %ecx,%ecx
801070ad:	66 89 90 20 38 11 80 	mov    %dx,-0x7feec7e0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070b4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070b9:	66 89 88 22 38 11 80 	mov    %cx,-0x7feec7de(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070c0:	31 c9                	xor    %ecx,%ecx
801070c2:	66 89 90 28 38 11 80 	mov    %dx,-0x7feec7d8(%eax)
801070c9:	66 89 88 2a 38 11 80 	mov    %cx,-0x7feec7d6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070d0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801070d5:	31 c9                	xor    %ecx,%ecx
801070d7:	66 89 90 30 38 11 80 	mov    %dx,-0x7feec7d0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070de:	c6 80 1c 38 11 80 00 	movb   $0x0,-0x7feec7e4(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801070e5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070ea:	c6 80 1d 38 11 80 9a 	movb   $0x9a,-0x7feec7e3(%eax)
801070f1:	c6 80 1e 38 11 80 cf 	movb   $0xcf,-0x7feec7e2(%eax)
801070f8:	c6 80 1f 38 11 80 00 	movb   $0x0,-0x7feec7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070ff:	c6 80 24 38 11 80 00 	movb   $0x0,-0x7feec7dc(%eax)
80107106:	c6 80 25 38 11 80 92 	movb   $0x92,-0x7feec7db(%eax)
8010710d:	c6 80 26 38 11 80 cf 	movb   $0xcf,-0x7feec7da(%eax)
80107114:	c6 80 27 38 11 80 00 	movb   $0x0,-0x7feec7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010711b:	c6 80 2c 38 11 80 00 	movb   $0x0,-0x7feec7d4(%eax)
80107122:	c6 80 2d 38 11 80 fa 	movb   $0xfa,-0x7feec7d3(%eax)
80107129:	c6 80 2e 38 11 80 cf 	movb   $0xcf,-0x7feec7d2(%eax)
80107130:	c6 80 2f 38 11 80 00 	movb   $0x0,-0x7feec7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107137:	66 89 88 32 38 11 80 	mov    %cx,-0x7feec7ce(%eax)
8010713e:	c6 80 34 38 11 80 00 	movb   $0x0,-0x7feec7cc(%eax)
80107145:	c6 80 35 38 11 80 f2 	movb   $0xf2,-0x7feec7cb(%eax)
8010714c:	c6 80 36 38 11 80 cf 	movb   $0xcf,-0x7feec7ca(%eax)
80107153:	c6 80 37 38 11 80 00 	movb   $0x0,-0x7feec7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010715a:	05 10 38 11 80       	add    $0x80113810,%eax
8010715f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107163:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107167:	c1 e8 10             	shr    $0x10,%eax
8010716a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010716e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107171:	0f 01 10             	lgdtl  (%eax)
}
80107174:	c9                   	leave  
80107175:	c3                   	ret    
80107176:	8d 76 00             	lea    0x0(%esi),%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107180:	a1 e4 34 12 80       	mov    0x801234e4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107185:	55                   	push   %ebp
80107186:	89 e5                	mov    %esp,%ebp
80107188:	05 00 00 00 80       	add    $0x80000000,%eax
8010718d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107190:	5d                   	pop    %ebp
80107191:	c3                   	ret    
80107192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071a0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 1c             	sub    $0x1c,%esp
801071a9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801071ac:	85 f6                	test   %esi,%esi
801071ae:	0f 84 d9 00 00 00    	je     8010728d <switchuvm+0xed>
    panic("switchuvm: no process");
  if(p->mainThread->tkstack == 0)
801071b4:	8b 86 b4 03 00 00    	mov    0x3b4(%esi),%eax
801071ba:	8b 40 04             	mov    0x4(%eax),%eax
801071bd:	85 c0                	test   %eax,%eax
801071bf:	0f 84 e2 00 00 00    	je     801072a7 <switchuvm+0x107>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801071c5:	8b 7e 04             	mov    0x4(%esi),%edi
801071c8:	85 ff                	test   %edi,%edi
801071ca:	0f 84 ca 00 00 00    	je     8010729a <switchuvm+0xfa>
    panic("switchuvm: no pgdir");

  pushcli();
801071d0:	e8 1b d9 ff ff       	call   80104af0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071d5:	e8 16 c6 ff ff       	call   801037f0 <mycpu>
801071da:	89 c3                	mov    %eax,%ebx
801071dc:	e8 0f c6 ff ff       	call   801037f0 <mycpu>
801071e1:	89 c7                	mov    %eax,%edi
801071e3:	e8 08 c6 ff ff       	call   801037f0 <mycpu>
801071e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071eb:	83 c7 08             	add    $0x8,%edi
801071ee:	e8 fd c5 ff ff       	call   801037f0 <mycpu>
801071f3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071f6:	83 c0 08             	add    $0x8,%eax
801071f9:	ba 67 00 00 00       	mov    $0x67,%edx
801071fe:	c1 e8 18             	shr    $0x18,%eax
80107201:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107208:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010720f:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107216:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
8010721d:	83 c1 08             	add    $0x8,%ecx
80107220:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107226:	c1 e9 10             	shr    $0x10,%ecx
80107229:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010722f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107234:	e8 b7 c5 ff ff       	call   801037f0 <mycpu>
80107239:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107240:	e8 ab c5 ff ff       	call   801037f0 <mycpu>
80107245:	b9 10 00 00 00       	mov    $0x10,%ecx
8010724a:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
8010724e:	e8 9d c5 ff ff       	call   801037f0 <mycpu>
80107253:	8b 8e b4 03 00 00    	mov    0x3b4(%esi),%ecx
80107259:	8b 49 04             	mov    0x4(%ecx),%ecx
8010725c:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107262:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107265:	e8 86 c5 ff ff       	call   801037f0 <mycpu>
8010726a:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
8010726e:	b8 28 00 00 00       	mov    $0x28,%eax
80107273:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107276:	8b 46 04             	mov    0x4(%esi),%eax
80107279:	05 00 00 00 80       	add    $0x80000000,%eax
8010727e:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107281:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107284:	5b                   	pop    %ebx
80107285:	5e                   	pop    %esi
80107286:	5f                   	pop    %edi
80107287:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80107288:	e9 a3 d8 ff ff       	jmp    80104b30 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
8010728d:	83 ec 0c             	sub    $0xc,%esp
80107290:	68 de 81 10 80       	push   $0x801081de
80107295:	e8 d6 90 ff ff       	call   80100370 <panic>
  if(p->mainThread->tkstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010729a:	83 ec 0c             	sub    $0xc,%esp
8010729d:	68 09 82 10 80       	push   $0x80108209
801072a2:	e8 c9 90 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->mainThread->tkstack == 0)
    panic("switchuvm: no kstack");
801072a7:	83 ec 0c             	sub    $0xc,%esp
801072aa:	68 f4 81 10 80       	push   $0x801081f4
801072af:	e8 bc 90 ff ff       	call   80100370 <panic>
801072b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072c0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	53                   	push   %ebx
801072c6:	83 ec 1c             	sub    $0x1c,%esp
801072c9:	8b 75 10             	mov    0x10(%ebp),%esi
801072cc:	8b 45 08             	mov    0x8(%ebp),%eax
801072cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801072d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801072d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801072db:	77 49                	ja     80107326 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801072dd:	e8 be b1 ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
801072e2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801072e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801072e7:	68 00 10 00 00       	push   $0x1000
801072ec:	6a 00                	push   $0x0
801072ee:	50                   	push   %eax
801072ef:	e8 ec d9 ff ff       	call   80104ce0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801072f4:	58                   	pop    %eax
801072f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107300:	5a                   	pop    %edx
80107301:	6a 06                	push   $0x6
80107303:	50                   	push   %eax
80107304:	31 d2                	xor    %edx,%edx
80107306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107309:	e8 42 fc ff ff       	call   80106f50 <mappages>
  memmove(mem, init, sz);
8010730e:	89 75 10             	mov    %esi,0x10(%ebp)
80107311:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107314:	83 c4 10             	add    $0x10,%esp
80107317:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010731a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010731d:	5b                   	pop    %ebx
8010731e:	5e                   	pop    %esi
8010731f:	5f                   	pop    %edi
80107320:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107321:	e9 6a da ff ff       	jmp    80104d90 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	68 1d 82 10 80       	push   $0x8010821d
8010732e:	e8 3d 90 ff ff       	call   80100370 <panic>
80107333:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107340 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107349:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107350:	0f 85 91 00 00 00    	jne    801073e7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107356:	8b 75 18             	mov    0x18(%ebp),%esi
80107359:	31 db                	xor    %ebx,%ebx
8010735b:	85 f6                	test   %esi,%esi
8010735d:	75 1a                	jne    80107379 <loaduvm+0x39>
8010735f:	eb 6f                	jmp    801073d0 <loaduvm+0x90>
80107361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107368:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010736e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107374:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107377:	76 57                	jbe    801073d0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107379:	8b 55 0c             	mov    0xc(%ebp),%edx
8010737c:	8b 45 08             	mov    0x8(%ebp),%eax
8010737f:	31 c9                	xor    %ecx,%ecx
80107381:	01 da                	add    %ebx,%edx
80107383:	e8 48 fb ff ff       	call   80106ed0 <walkpgdir>
80107388:	85 c0                	test   %eax,%eax
8010738a:	74 4e                	je     801073da <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010738c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010738e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107391:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107396:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010739b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073a1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073a4:	01 d9                	add    %ebx,%ecx
801073a6:	05 00 00 00 80       	add    $0x80000000,%eax
801073ab:	57                   	push   %edi
801073ac:	51                   	push   %ecx
801073ad:	50                   	push   %eax
801073ae:	ff 75 10             	pushl  0x10(%ebp)
801073b1:	e8 aa a5 ff ff       	call   80101960 <readi>
801073b6:	83 c4 10             	add    $0x10,%esp
801073b9:	39 c7                	cmp    %eax,%edi
801073bb:	74 ab                	je     80107368 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801073bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801073c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801073c5:	5b                   	pop    %ebx
801073c6:	5e                   	pop    %esi
801073c7:	5f                   	pop    %edi
801073c8:	5d                   	pop    %ebp
801073c9:	c3                   	ret    
801073ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801073d3:	31 c0                	xor    %eax,%eax
}
801073d5:	5b                   	pop    %ebx
801073d6:	5e                   	pop    %esi
801073d7:	5f                   	pop    %edi
801073d8:	5d                   	pop    %ebp
801073d9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801073da:	83 ec 0c             	sub    $0xc,%esp
801073dd:	68 37 82 10 80       	push   $0x80108237
801073e2:	e8 89 8f ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801073e7:	83 ec 0c             	sub    $0xc,%esp
801073ea:	68 d8 82 10 80       	push   $0x801082d8
801073ef:	e8 7c 8f ff ff       	call   80100370 <panic>
801073f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107400 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 0c             	sub    $0xc,%esp
80107409:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010740c:	85 ff                	test   %edi,%edi
8010740e:	0f 88 ca 00 00 00    	js     801074de <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107414:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107417:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010741a:	0f 82 82 00 00 00    	jb     801074a2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107420:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107426:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010742c:	39 df                	cmp    %ebx,%edi
8010742e:	77 43                	ja     80107473 <allocuvm+0x73>
80107430:	e9 bb 00 00 00       	jmp    801074f0 <allocuvm+0xf0>
80107435:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107438:	83 ec 04             	sub    $0x4,%esp
8010743b:	68 00 10 00 00       	push   $0x1000
80107440:	6a 00                	push   $0x0
80107442:	50                   	push   %eax
80107443:	e8 98 d8 ff ff       	call   80104ce0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107448:	58                   	pop    %eax
80107449:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010744f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107454:	5a                   	pop    %edx
80107455:	6a 06                	push   $0x6
80107457:	50                   	push   %eax
80107458:	89 da                	mov    %ebx,%edx
8010745a:	8b 45 08             	mov    0x8(%ebp),%eax
8010745d:	e8 ee fa ff ff       	call   80106f50 <mappages>
80107462:	83 c4 10             	add    $0x10,%esp
80107465:	85 c0                	test   %eax,%eax
80107467:	78 47                	js     801074b0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107469:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010746f:	39 df                	cmp    %ebx,%edi
80107471:	76 7d                	jbe    801074f0 <allocuvm+0xf0>
    mem = kalloc();
80107473:	e8 28 b0 ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
80107478:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010747a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010747c:	75 ba                	jne    80107438 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010747e:	83 ec 0c             	sub    $0xc,%esp
80107481:	68 55 82 10 80       	push   $0x80108255
80107486:	e8 d5 91 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010748b:	83 c4 10             	add    $0x10,%esp
8010748e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107491:	76 4b                	jbe    801074de <allocuvm+0xde>
80107493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107496:	8b 45 08             	mov    0x8(%ebp),%eax
80107499:	89 fa                	mov    %edi,%edx
8010749b:	e8 40 fb ff ff       	call   80106fe0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801074a0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801074a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074a5:	5b                   	pop    %ebx
801074a6:	5e                   	pop    %esi
801074a7:	5f                   	pop    %edi
801074a8:	5d                   	pop    %ebp
801074a9:	c3                   	ret    
801074aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801074b0:	83 ec 0c             	sub    $0xc,%esp
801074b3:	68 6d 82 10 80       	push   $0x8010826d
801074b8:	e8 a3 91 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801074bd:	83 c4 10             	add    $0x10,%esp
801074c0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801074c3:	76 0d                	jbe    801074d2 <allocuvm+0xd2>
801074c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074c8:	8b 45 08             	mov    0x8(%ebp),%eax
801074cb:	89 fa                	mov    %edi,%edx
801074cd:	e8 0e fb ff ff       	call   80106fe0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801074d2:	83 ec 0c             	sub    $0xc,%esp
801074d5:	56                   	push   %esi
801074d6:	e8 15 ae ff ff       	call   801022f0 <kfree>
      return 0;
801074db:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801074de:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801074e1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801074e3:	5b                   	pop    %ebx
801074e4:	5e                   	pop    %esi
801074e5:	5f                   	pop    %edi
801074e6:	5d                   	pop    %ebp
801074e7:	c3                   	ret    
801074e8:	90                   	nop
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801074f3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801074f5:	5b                   	pop    %ebx
801074f6:	5e                   	pop    %esi
801074f7:	5f                   	pop    %edi
801074f8:	5d                   	pop    %ebp
801074f9:	c3                   	ret    
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107500 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	8b 55 0c             	mov    0xc(%ebp),%edx
80107506:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107509:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010750c:	39 d1                	cmp    %edx,%ecx
8010750e:	73 10                	jae    80107520 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107510:	5d                   	pop    %ebp
80107511:	e9 ca fa ff ff       	jmp    80106fe0 <deallocuvm.part.0>
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
80107549:	e8 92 fa ff ff       	call   80106fe0 <deallocuvm.part.0>
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
      kfree(v);
8010756d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107572:	83 ec 0c             	sub    $0xc,%esp
80107575:	83 c3 04             	add    $0x4,%ebx
80107578:	05 00 00 00 80       	add    $0x80000000,%eax
8010757d:	50                   	push   %eax
8010757e:	e8 6d ad ff ff       	call   801022f0 <kfree>
80107583:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107586:	39 fb                	cmp    %edi,%ebx
80107588:	75 dd                	jne    80107567 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
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
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107594:	e9 57 ad ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107599:	83 ec 0c             	sub    $0xc,%esp
8010759c:	68 89 82 10 80       	push   $0x80108289
801075a1:	e8 ca 8d ff ff       	call   80100370 <panic>
801075a6:	8d 76 00             	lea    0x0(%esi),%esi
801075a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075b0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	56                   	push   %esi
801075b4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801075b5:	e8 e6 ae ff ff       	call   801024a0 <kalloc>
801075ba:	85 c0                	test   %eax,%eax
801075bc:	74 6a                	je     80107628 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801075be:	83 ec 04             	sub    $0x4,%esp
801075c1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801075c8:	68 00 10 00 00       	push   $0x1000
801075cd:	6a 00                	push   $0x0
801075cf:	50                   	push   %eax
801075d0:	e8 0b d7 ff ff       	call   80104ce0 <memset>
801075d5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075d8:	8b 43 04             	mov    0x4(%ebx),%eax
801075db:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075de:	83 ec 08             	sub    $0x8,%esp
801075e1:	8b 13                	mov    (%ebx),%edx
801075e3:	ff 73 0c             	pushl  0xc(%ebx)
801075e6:	50                   	push   %eax
801075e7:	29 c1                	sub    %eax,%ecx
801075e9:	89 f0                	mov    %esi,%eax
801075eb:	e8 60 f9 ff ff       	call   80106f50 <mappages>
801075f0:	83 c4 10             	add    $0x10,%esp
801075f3:	85 c0                	test   %eax,%eax
801075f5:	78 19                	js     80107610 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075f7:	83 c3 10             	add    $0x10,%ebx
801075fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107600:	75 d6                	jne    801075d8 <setupkvm+0x28>
80107602:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107607:	5b                   	pop    %ebx
80107608:	5e                   	pop    %esi
80107609:	5d                   	pop    %ebp
8010760a:	c3                   	ret    
8010760b:	90                   	nop
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107610:	83 ec 0c             	sub    $0xc,%esp
80107613:	56                   	push   %esi
80107614:	e8 17 ff ff ff       	call   80107530 <freevm>
      return 0;
80107619:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010761c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010761f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107621:	5b                   	pop    %ebx
80107622:	5e                   	pop    %esi
80107623:	5d                   	pop    %ebp
80107624:	c3                   	ret    
80107625:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107628:	31 c0                	xor    %eax,%eax
8010762a:	eb d8                	jmp    80107604 <setupkvm+0x54>
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107630 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107636:	e8 75 ff ff ff       	call   801075b0 <setupkvm>
8010763b:	a3 e4 34 12 80       	mov    %eax,0x801234e4
80107640:	05 00 00 00 80       	add    $0x80000000,%eax
80107645:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
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

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107653:	89 e5                	mov    %esp,%ebp
80107655:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107658:	8b 55 0c             	mov    0xc(%ebp),%edx
8010765b:	8b 45 08             	mov    0x8(%ebp),%eax
8010765e:	e8 6d f8 ff ff       	call   80106ed0 <walkpgdir>
  if(pte == 0)
80107663:	85 c0                	test   %eax,%eax
80107665:	74 05                	je     8010766c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107667:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010766a:	c9                   	leave  
8010766b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010766c:	83 ec 0c             	sub    $0xc,%esp
8010766f:	68 9a 82 10 80       	push   $0x8010829a
80107674:	e8 f7 8c ff ff       	call   80100370 <panic>
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
80107693:	0f 84 c5 00 00 00    	je     8010775e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010769c:	85 c9                	test   %ecx,%ecx
8010769e:	0f 84 9c 00 00 00    	je     80107740 <copyuvm+0xc0>
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
801076c0:	e8 cb d6 ff ff       	call   80104d90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076c5:	58                   	pop    %eax
801076c6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801076cc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076d1:	5a                   	pop    %edx
801076d2:	ff 75 e4             	pushl  -0x1c(%ebp)
801076d5:	50                   	push   %eax
801076d6:	89 fa                	mov    %edi,%edx
801076d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076db:	e8 70 f8 ff ff       	call   80106f50 <mappages>
801076e0:	83 c4 10             	add    $0x10,%esp
801076e3:	85 c0                	test   %eax,%eax
801076e5:	78 69                	js     80107750 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076e7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801076ed:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801076f0:	76 4e                	jbe    80107740 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076f2:	8b 45 08             	mov    0x8(%ebp),%eax
801076f5:	31 c9                	xor    %ecx,%ecx
801076f7:	89 fa                	mov    %edi,%edx
801076f9:	e8 d2 f7 ff ff       	call   80106ed0 <walkpgdir>
801076fe:	85 c0                	test   %eax,%eax
80107700:	74 6d                	je     8010776f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107702:	8b 00                	mov    (%eax),%eax
80107704:	a8 01                	test   $0x1,%al
80107706:	74 5a                	je     80107762 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107708:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010770a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010770f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107718:	e8 83 ad ff ff       	call   801024a0 <kalloc>
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
80107731:	31 c0                	xor    %eax,%eax
}
80107733:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107736:	5b                   	pop    %ebx
80107737:	5e                   	pop    %esi
80107738:	5f                   	pop    %edi
80107739:	5d                   	pop    %ebp
8010773a:	c3                   	ret    
8010773b:	90                   	nop
8010773c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107740:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107743:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107746:	5b                   	pop    %ebx
80107747:	5e                   	pop    %esi
80107748:	5f                   	pop    %edi
80107749:	5d                   	pop    %ebp
8010774a:	c3                   	ret    
8010774b:	90                   	nop
8010774c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107750:	83 ec 0c             	sub    $0xc,%esp
80107753:	56                   	push   %esi
80107754:	e8 97 ab ff ff       	call   801022f0 <kfree>
      goto bad;
80107759:	83 c4 10             	add    $0x10,%esp
8010775c:	eb c5                	jmp    80107723 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010775e:	31 c0                	xor    %eax,%eax
80107760:	eb d1                	jmp    80107733 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107762:	83 ec 0c             	sub    $0xc,%esp
80107765:	68 be 82 10 80       	push   $0x801082be
8010776a:	e8 01 8c ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010776f:	83 ec 0c             	sub    $0xc,%esp
80107772:	68 a4 82 10 80       	push   $0x801082a4
80107777:	e8 f4 8b ff ff       	call   80100370 <panic>
8010777c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107780 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107780:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107781:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107783:	89 e5                	mov    %esp,%ebp
80107785:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107788:	8b 55 0c             	mov    0xc(%ebp),%edx
8010778b:	8b 45 08             	mov    0x8(%ebp),%eax
8010778e:	e8 3d f7 ff ff       	call   80106ed0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107793:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107795:	89 c2                	mov    %eax,%edx
80107797:	83 e2 05             	and    $0x5,%edx
8010779a:	83 fa 05             	cmp    $0x5,%edx
8010779d:	75 11                	jne    801077b0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010779f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801077a4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801077a5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801077aa:	c3                   	ret    
801077ab:	90                   	nop
801077ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801077b0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801077b2:	c9                   	leave  
801077b3:	c3                   	ret    
801077b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801077c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
801077c6:	83 ec 1c             	sub    $0x1c,%esp
801077c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801077cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801077cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077d2:	85 db                	test   %ebx,%ebx
801077d4:	75 40                	jne    80107816 <copyout+0x56>
801077d6:	eb 70                	jmp    80107848 <copyout+0x88>
801077d8:	90                   	nop
801077d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801077e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801077e3:	89 f1                	mov    %esi,%ecx
801077e5:	29 d1                	sub    %edx,%ecx
801077e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801077ed:	39 d9                	cmp    %ebx,%ecx
801077ef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077f2:	29 f2                	sub    %esi,%edx
801077f4:	83 ec 04             	sub    $0x4,%esp
801077f7:	01 d0                	add    %edx,%eax
801077f9:	51                   	push   %ecx
801077fa:	57                   	push   %edi
801077fb:	50                   	push   %eax
801077fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801077ff:	e8 8c d5 ff ff       	call   80104d90 <memmove>
    len -= n;
    buf += n;
80107804:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107807:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010780a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107810:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107812:	29 cb                	sub    %ecx,%ebx
80107814:	74 32                	je     80107848 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107816:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107818:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010781b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010781e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107824:	56                   	push   %esi
80107825:	ff 75 08             	pushl  0x8(%ebp)
80107828:	e8 53 ff ff ff       	call   80107780 <uva2ka>
    if(pa0 == 0)
8010782d:	83 c4 10             	add    $0x10,%esp
80107830:	85 c0                	test   %eax,%eax
80107832:	75 ac                	jne    801077e0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107834:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010783c:	5b                   	pop    %ebx
8010783d:	5e                   	pop    %esi
8010783e:	5f                   	pop    %edi
8010783f:	5d                   	pop    %ebp
80107840:	c3                   	ret    
80107841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107848:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010784b:	31 c0                	xor    %eax,%eax
}
8010784d:	5b                   	pop    %ebx
8010784e:	5e                   	pop    %esi
8010784f:	5f                   	pop    %edi
80107850:	5d                   	pop    %ebp
80107851:	c3                   	ret    
