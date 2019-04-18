
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
80100044:	bb 18 c6 10 80       	mov    $0x8010c618,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 40 7d 10 80       	push   $0x80107d40
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 d5 4e 00 00       	call   80104f30 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
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
80100088:	89 53 58             	mov    %edx,0x58(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 54 58 0d 11 80 	movl   $0x80110d58,0x54(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 7d 10 80       	push   $0x80107d47
80100097:	50                   	push   %eax
80100098:	e8 63 4d 00 00       	call   80104e00 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 b0 0d 11 80       	mov    0x80110db0,%eax

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
801000a7:	89 58 54             	mov    %ebx,0x54(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 60 02 00 00    	lea    0x260(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d b0 0d 11 80    	mov    %ebx,0x80110db0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 58 0d 11 80       	cmp    $0x80110d58,%eax
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
801000e4:	e8 a7 4f 00 00       	call   80105090 <acquire>

  // Is the block already cached?
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
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
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
80100162:	e8 f9 4f 00 00       	call   80105160 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 4c 00 00       	call   80104e40 <acquiresleep>
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
80100193:	68 4e 7d 10 80       	push   $0x80107d4e
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
801001ae:	e8 2d 4d 00 00       	call   80104ee0 <holdingsleep>
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
801001cc:	68 5f 7d 10 80       	push   $0x80107d5f
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
801001ef:	e8 ec 4c 00 00       	call   80104ee0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 4c 00 00       	call   80104ea0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 80 4e 00 00       	call   80105090 <acquire>
  b->refcnt--;
80100210:	8b 43 50             	mov    0x50(%ebx),%eax
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
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 58             	mov    %eax,0x58(%ebx)
    b->prev = &bcache.head;
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
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 ff 4e 00 00       	jmp    80105160 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 7d 10 80       	push   $0x80107d66
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
8010028c:	e8 ff 4d 00 00       	call   80105090 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 40 10 11 80       	mov    0x80111040,%eax
801002a6:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
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
801002b8:	68 40 10 11 80       	push   $0x80111040
801002bd:	e8 4e 3c 00 00       	call   80103f10 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 40 10 11 80       	mov    0x80111040,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 c9 35 00 00       	call   801038a0 <myproc>
801002d7:	8b 40 1c             	mov    0x1c(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 75 4e 00 00       	call   80105160 <release>
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
8010030b:	89 15 40 10 11 80    	mov    %edx,0x80111040
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 c0 0f 11 80 	movsbl -0x7feef040(%edx),%edx
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
80100346:	e8 15 4e 00 00       	call   80105160 <release>
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
80100360:	a3 40 10 11 80       	mov    %eax,0x80111040
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
80100379:	c7 05 58 b5 10 80 00 	movl   $0x0,0x8010b558
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
80100392:	68 6d 7d 10 80       	push   $0x80107d6d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 c7 87 10 80 	movl   $0x801087c7,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 93 4b 00 00       	call   80104f50 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 81 7d 10 80       	push   $0x80107d81
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
801003d9:	c7 05 5c b5 10 80 01 	movl   $0x1,0x8010b55c
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
801003f0:	8b 15 5c b5 10 80    	mov    0x8010b55c,%edx
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
8010041a:	e8 c1 64 00 00       	call   801068e0 <uartputc>
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
801004d3:	e8 08 64 00 00       	call   801068e0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 fc 63 00 00       	call   801068e0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 f0 63 00 00       	call   801068e0 <uartputc>
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
80100514:	e8 47 4d 00 00       	call   80105260 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 82 4c 00 00       	call   801051b0 <memset>
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
80100540:	68 85 7d 10 80       	push   $0x80107d85
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
801005b1:	0f b6 92 b0 7d 10 80 	movzbl -0x7fef8250(%edx),%edx
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
8010061b:	e8 70 4a 00 00       	call   80105090 <acquire>
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
80100647:	e8 14 4b 00 00       	call   80105160 <release>
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
80100669:	a1 58 b5 10 80       	mov    0x8010b558,%eax
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
8010070d:	e8 4e 4a 00 00       	call   80105160 <release>
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
80100788:	b8 98 7d 10 80       	mov    $0x80107d98,%eax
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
801007c8:	e8 c3 48 00 00       	call   80105090 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 9f 7d 10 80       	push   $0x80107d9f
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
80100803:	e8 88 48 00 00       	call   80105090 <acquire>
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
80100831:	a1 48 10 11 80       	mov    0x80111048,%eax
80100836:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 48 10 11 80       	mov    %eax,0x80111048
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
80100868:	e8 f3 48 00 00       	call   80105160 <release>
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
80100889:	a1 48 10 11 80       	mov    0x80111048,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 40 10 11 80    	sub    0x80111040,%edx
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
801008a8:	89 15 48 10 11 80    	mov    %edx,0x80111048
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 c0 0f 11 80    	mov    %cl,-0x7feef040(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 40 10 11 80       	mov    0x80111040,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 48 10 11 80    	cmp    %eax,0x80111048
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
801008ec:	a3 44 10 11 80       	mov    %eax,0x80111044
          wakeup(&input.r);
801008f1:	68 40 10 11 80       	push   $0x80111040
801008f6:	e8 15 3b 00 00       	call   80104410 <wakeup>
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
80100908:	a1 48 10 11 80       	mov    0x80111048,%eax
8010090d:	39 05 44 10 11 80    	cmp    %eax,0x80111044
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 48 10 11 80       	mov    0x80111048,%eax
80100934:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
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
80100948:	80 ba c0 0f 11 80 0a 	cmpb   $0xa,-0x7feef040(%edx)
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
80100977:	e9 14 3c 00 00       	jmp    80104590 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 c0 0f 11 80 0a 	movb   $0xa,-0x7feef040(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 48 10 11 80       	mov    0x80111048,%eax
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
801009a6:	68 a8 7d 10 80       	push   $0x80107da8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 7b 45 00 00       	call   80104f30 <initlock>

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
801009bb:	c7 05 0c 1a 11 80 00 	movl   $0x80100600,0x80111a0c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 08 1a 11 80 70 	movl   $0x80100270,0x80111a08
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
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
80100a7c:	e8 ff 6f 00 00       	call   80107a80 <setupkvm>
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
80100b0c:	e8 bf 6d 00 00       	call   801078d0 <allocuvm>
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
80100b42:	e8 c9 6c 00 00       	call   80107810 <loaduvm>
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
80100b61:	e8 9a 6e 00 00       	call   80107a00 <freevm>
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
80100b9d:	e8 2e 6d 00 00       	call   801078d0 <allocuvm>
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
80100bb4:	e8 47 6e 00 00       	call   80107a00 <freevm>
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
80100bce:	68 c1 7d 10 80       	push   $0x80107dc1
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
80100bf9:	e8 22 6f 00 00       	call   80107b20 <clearpteu>
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
80100c29:	e8 c2 47 00 00       	call   801053f0 <strlen>
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
80100c3c:	e8 af 47 00 00       	call   801053f0 <strlen>
80100c41:	83 c0 01             	add    $0x1,%eax
80100c44:	50                   	push   %eax
80100c45:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c48:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4b:	53                   	push   %ebx
80100c4c:	56                   	push   %esi
80100c4d:	e8 3e 70 00 00       	call   80107c90 <copyout>
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
80100cb7:	e8 d4 6f 00 00       	call   80107c90 <copyout>
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
80100cfc:	e8 af 46 00 00       	call   801053b0 <safestrcpy>

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
80100d33:	e8 e8 32 00 00       	call   80104020 <cleanProcOneThread>
    //curproc->mainThread=curthread;

    switchuvm(curproc);
80100d38:	89 34 24             	mov    %esi,(%esp)
80100d3b:	e8 30 69 00 00       	call   80107670 <switchuvm>
    freevm(oldpgdir);
80100d40:	89 3c 24             	mov    %edi,(%esp)
80100d43:	e8 b8 6c 00 00       	call   80107a00 <freevm>
    return 0;
80100d48:	83 c4 10             	add    $0x10,%esp
80100d4b:	31 c0                	xor    %eax,%eax
80100d4d:	e9 15 fd ff ff       	jmp    80100a67 <exec+0x77>
80100d52:	66 90                	xchg   %ax,%ax
80100d54:	66 90                	xchg   %ax,%ax
80100d56:	66 90                	xchg   %ax,%ax
80100d58:	66 90                	xchg   %ax,%ax
80100d5a:	66 90                	xchg   %ax,%ax
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
80100d66:	68 cd 7d 10 80       	push   $0x80107dcd
80100d6b:	68 60 10 11 80       	push   $0x80111060
80100d70:	e8 bb 41 00 00       	call   80104f30 <initlock>
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
80100d84:	bb 98 10 11 80       	mov    $0x80111098,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d8c:	68 60 10 11 80       	push   $0x80111060
80100d91:	e8 fa 42 00 00       	call   80105090 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb f8 19 11 80    	cmp    $0x801119f8,%ebx
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
80100dbc:	68 60 10 11 80       	push   $0x80111060
80100dc1:	e8 9a 43 00 00       	call   80105160 <release>
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
80100dd3:	68 60 10 11 80       	push   $0x80111060
80100dd8:	e8 83 43 00 00       	call   80105160 <release>
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
80100dfa:	68 60 10 11 80       	push   $0x80111060
80100dff:	e8 8c 42 00 00       	call   80105090 <acquire>
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
80100e17:	68 60 10 11 80       	push   $0x80111060
80100e1c:	e8 3f 43 00 00       	call   80105160 <release>
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
80100e2b:	68 d4 7d 10 80       	push   $0x80107dd4
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
80100e4c:	68 60 10 11 80       	push   $0x80111060
80100e51:	e8 3a 42 00 00       	call   80105090 <acquire>
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
80100e6e:	c7 45 08 60 10 11 80 	movl   $0x80111060,0x8(%ebp)
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
80100e7c:	e9 df 42 00 00       	jmp    80105160 <release>
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
80100ea0:	68 60 10 11 80       	push   $0x80111060
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
80100ea8:	e8 b3 42 00 00       	call   80105160 <release>

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
80100f02:	68 dc 7d 10 80       	push   $0x80107ddc
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
80100fe2:	68 e6 7d 10 80       	push   $0x80107de6
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
801010f4:	68 ef 7d 10 80       	push   $0x80107def
801010f9:	e8 72 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010fe:	83 ec 0c             	sub    $0xc,%esp
80101101:	68 f5 7d 10 80       	push   $0x80107df5
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
80101119:	8b 0d 60 1a 11 80    	mov    0x80111a60,%ecx
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
8010113c:	03 05 78 1a 11 80    	add    0x80111a78,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114e:	a1 60 1a 11 80       	mov    0x80111a60,%eax
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
80101174:	0f b6 7c 0b 60       	movzbl 0x60(%ebx,%ecx,1),%edi
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
801011a7:	39 05 60 1a 11 80    	cmp    %eax,0x80111a60
801011ad:	77 82                	ja     80101131 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 ff 7d 10 80       	push   $0x80107dff
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
801011c8:	88 54 0f 60          	mov    %dl,0x60(%edi,%ecx,1)
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
801011e7:	8d 40 60             	lea    0x60(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 b6 3f 00 00       	call   801051b0 <memset>
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
8010122a:	bb b8 1a 11 80       	mov    $0x80111ab8,%ebx
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
80101235:	68 80 1a 11 80       	push   $0x80111a80
8010123a:	e8 51 3e 00 00       	call   80105090 <acquire>
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
80101254:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010125a:	81 fb a0 37 11 80    	cmp    $0x801137a0,%ebx
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
8010127a:	68 80 1a 11 80       	push   $0x80111a80

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010127f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101282:	e8 d9 3e 00 00       	call   80105160 <release>
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
8010129d:	81 c3 94 00 00 00    	add    $0x94,%ebx
801012a3:	81 fb a0 37 11 80    	cmp    $0x801137a0,%ebx
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
801012c3:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
  release(&icache.lock);
801012ca:	68 80 1a 11 80       	push   $0x80111a80
801012cf:	e8 8c 3e 00 00       	call   80105160 <release>

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
801012e4:	68 15 7e 10 80       	push   $0x80107e15
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
80101303:	8b 43 60             	mov    0x60(%ebx),%eax
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
80101324:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
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
80101339:	8d 54 98 60          	lea    0x60(%eax,%ebx,4),%edx
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
80101387:	89 43 60             	mov    %eax,0x60(%ebx)
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
8010139f:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
801013a5:	eb 87                	jmp    8010132e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013a7:	83 ec 0c             	sub    $0xc,%esp
801013aa:	68 25 7e 10 80       	push   $0x80107e25
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
801013d7:	8d 40 60             	lea    0x60(%eax),%eax
801013da:	83 c4 0c             	add    $0xc,%esp
801013dd:	6a 1c                	push   $0x1c
801013df:	50                   	push   %eax
801013e0:	56                   	push   %esi
801013e1:	e8 7a 3e 00 00       	call   80105260 <memmove>
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
8010140c:	68 60 1a 11 80       	push   $0x80111a60
80101411:	50                   	push   %eax
80101412:	e8 a9 ff ff ff       	call   801013c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101417:	58                   	pop    %eax
80101418:	5a                   	pop    %edx
80101419:	89 da                	mov    %ebx,%edx
8010141b:	c1 ea 0c             	shr    $0xc,%edx
8010141e:	03 15 78 1a 11 80    	add    0x80111a78,%edx
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
80101443:	0f b6 4c 18 60       	movzbl 0x60(%eax,%ebx,1),%ecx
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
80101457:	88 44 1e 60          	mov    %al,0x60(%esi,%ebx,1)
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
80101476:	68 38 7e 10 80       	push   $0x80107e38
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
80101484:	bb c4 1a 11 80       	mov    $0x80111ac4,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010148c:	68 4b 7e 10 80       	push   $0x80107e4b
80101491:	68 80 1a 11 80       	push   $0x80111a80
80101496:	e8 95 3a 00 00       	call   80104f30 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 52 7e 10 80       	push   $0x80107e52
801014a8:	53                   	push   %ebx
801014a9:	81 c3 94 00 00 00    	add    $0x94,%ebx
801014af:	e8 4c 39 00 00       	call   80104e00 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb ac 37 11 80    	cmp    $0x801137ac,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 60 1a 11 80       	push   $0x80111a60
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 f1 fe ff ff       	call   801013c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 78 1a 11 80    	pushl  0x80111a78
801014d5:	ff 35 74 1a 11 80    	pushl  0x80111a74
801014db:	ff 35 70 1a 11 80    	pushl  0x80111a70
801014e1:	ff 35 6c 1a 11 80    	pushl  0x80111a6c
801014e7:	ff 35 68 1a 11 80    	pushl  0x80111a68
801014ed:	ff 35 64 1a 11 80    	pushl  0x80111a64
801014f3:	ff 35 60 1a 11 80    	pushl  0x80111a60
801014f9:	68 b8 7e 10 80       	push   $0x80107eb8
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
80101519:	83 3d 68 1a 11 80 01 	cmpl   $0x1,0x80111a68
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
8010154f:	39 1d 68 1a 11 80    	cmp    %ebx,0x80111a68
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 74 1a 11 80    	add    0x80111a74,%eax
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
80101579:	8d 4c 07 60          	lea    0x60(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 1d 3c 00 00       	call   801051b0 <memset>
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
801015c3:	68 58 7e 10 80       	push   $0x80107e58
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
801015de:	83 c3 60             	add    $0x60,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 74 1a 11 80    	add    0x80111a74,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a0             	pushl  -0x60(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
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
80101605:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
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
80101631:	e8 2a 3c 00 00       	call   80105260 <memmove>
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
8010165a:	68 80 1a 11 80       	push   $0x80111a80
8010165f:	e8 2c 3a 00 00       	call   80105090 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010166f:	e8 ec 3a 00 00       	call   80105160 <release>
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
801016a2:	e8 99 37 00 00       	call   80104e40 <acquiresleep>

  if(ip->valid == 0){
801016a7:	8b 43 50             	mov    0x50(%ebx),%eax
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
801016c9:	03 05 74 1a 11 80    	add    0x80111a74,%eax
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
801016e5:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
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
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 58          	mov    %dx,0x58(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 5a          	mov    %dx,0x5a(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 5c             	mov    %edx,0x5c(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 60             	lea    0x60(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 43 3b 00 00       	call   80105260 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 54 00       	cmpw   $0x0,0x54(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010172d:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 70 7e 10 80       	push   $0x80107e70
80101742:	e8 29 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 6a 7e 10 80       	push   $0x80107e6a
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
80101773:	e8 68 37 00 00       	call   80104ee0 <holdingsleep>
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
8010178f:	e9 0c 37 00 00       	jmp    80104ea0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 7f 7e 10 80       	push   $0x80107e7f
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
801017c0:	e8 7b 36 00 00       	call   80104e40 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 56 50             	mov    0x50(%esi),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7e 5a 00       	cmpw   $0x0,0x5a(%esi)
801017d4:	74 32                	je     80101808 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 c1 36 00 00       	call   80104ea0 <releasesleep>

  acquire(&icache.lock);
801017df:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801017e6:	e8 a5 38 00 00       	call   80105090 <acquire>
  ip->ref--;
801017eb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 80 1a 11 80 	movl   $0x80111a80,0x8(%ebp)
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
80101800:	e9 5b 39 00 00       	jmp    80105160 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 80 1a 11 80       	push   $0x80111a80
80101810:	e8 7b 38 00 00       	call   80105090 <acquire>
    int r = ip->ref;
80101815:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101818:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010181f:	e8 3c 39 00 00       	call   80105160 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fb 01             	cmp    $0x1,%ebx
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8e 90 00 00 00    	lea    0x90(%esi),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 5e 60             	lea    0x60(%esi),%ebx
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
80101860:	8b 86 90 00 00 00    	mov    0x90(%esi),%eax
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
80101870:	c7 46 5c 00 00 00 00 	movl   $0x0,0x5c(%esi)
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
8010187f:	66 89 46 54          	mov    %ax,0x54(%esi)
      iupdate(ip);
80101883:	89 34 24             	mov    %esi,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
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
801018ab:	8d 88 60 02 00 00    	lea    0x260(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 58 60             	lea    0x60(%eax),%ebx
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
801018ec:	8b 96 90 00 00 00    	mov    0x90(%esi),%edx
801018f2:	8b 06                	mov    (%esi),%eax
801018f4:	e8 07 fb ff ff       	call   80101400 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
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
80101944:	0f b7 4a 54          	movzwl 0x54(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 5a          	movzwl 0x5a(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 5c             	mov    0x5c(%edx),%edx
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
80101972:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
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
8010198c:	8b 40 5c             	mov    0x5c(%eax),%eax
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
801019fb:	8d 44 0a 60          	lea    0x60(%edx,%ecx,1),%eax
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
80101a08:	e8 53 38 00 00       	call   80105260 <memmove>
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
80101a30:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 1e                	ja     80101a58 <readi+0xf8>
80101a3a:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
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
80101a72:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
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
80101a8c:	39 70 5c             	cmp    %esi,0x5c(%eax)
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
80101af9:	8d 44 0f 60          	lea    0x60(%edi,%ecx,1),%eax
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
80101b04:	e8 57 37 00 00       	call   80105260 <memmove>
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
80101b2d:	3b 70 5c             	cmp    0x5c(%eax),%esi
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
80101b40:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
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
80101b6e:	89 70 5c             	mov    %esi,0x5c(%eax)
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
80101b9e:	e8 3d 37 00 00       	call   801052e0 <strncmp>
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
80101bbc:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80101bc1:	0f 85 80 00 00 00    	jne    80101c47 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	75 0d                	jne    80101be0 <dirlookup+0x30>
80101bd3:	eb 5b                	jmp    80101c30 <dirlookup+0x80>
80101bd5:	8d 76 00             	lea    0x0(%esi),%esi
80101bd8:	83 c7 10             	add    $0x10,%edi
80101bdb:	39 7b 5c             	cmp    %edi,0x5c(%ebx)
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
80101c05:	e8 d6 36 00 00       	call   801052e0 <strncmp>
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
80101c3d:	68 99 7e 10 80       	push   $0x80107e99
80101c42:	e8 29 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c47:	83 ec 0c             	sub    $0xc,%esp
80101c4a:	68 87 7e 10 80       	push   $0x80107e87
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
80101c84:	68 80 1a 11 80       	push   $0x80111a80
80101c89:	e8 02 34 00 00       	call   80105090 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101c99:	e8 c2 34 00 00       	call   80105160 <release>
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
80101cf5:	e8 66 35 00 00       	call   80105260 <memmove>
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
80101d24:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
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
80101d84:	e8 d7 34 00 00       	call   80105260 <memmove>
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
80101e2e:	8b 7b 5c             	mov    0x5c(%ebx),%edi
80101e31:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e34:	85 ff                	test   %edi,%edi
80101e36:	74 29                	je     80101e61 <dirlink+0x51>
80101e38:	31 ff                	xor    %edi,%edi
80101e3a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e3d:	eb 09                	jmp    80101e48 <dirlink+0x38>
80101e3f:	90                   	nop
80101e40:	83 c7 10             	add    $0x10,%edi
80101e43:	39 7b 5c             	cmp    %edi,0x5c(%ebx)
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
80101e6d:	e8 de 34 00 00       	call   80105350 <strncpy>
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
80101eab:	68 a8 7e 10 80       	push   $0x80107ea8
80101eb0:	e8 bb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	68 ae 85 10 80       	push   $0x801085ae
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
80101fab:	8d 71 60             	lea    0x60(%ecx),%esi
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
80101fc0:	68 14 7f 10 80       	push   $0x80107f14
80101fc5:	e8 a6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fca:	83 ec 0c             	sub    $0xc,%esp
80101fcd:	68 0b 7f 10 80       	push   $0x80107f0b
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
80101fe6:	68 26 7f 10 80       	push   $0x80107f26
80101feb:	68 80 b5 10 80       	push   $0x8010b580
80101ff0:	e8 3b 2f 00 00       	call   80104f30 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101ff5:	58                   	pop    %eax
80101ff6:	a1 c0 3e 11 80       	mov    0x80113ec0,%eax
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
8010206e:	e8 1d 30 00 00       	call   80105090 <acquire>

  if((b = idequeue) == 0){
80102073:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	85 db                	test   %ebx,%ebx
8010207e:	74 34                	je     801020b4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102080:	8b 43 5c             	mov    0x5c(%ebx),%eax
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
8010209e:	e8 6d 23 00 00       	call   80104410 <wakeup>

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
801020bc:	e8 9f 30 00 00       	call   80105160 <release>
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
801020e7:	8d 7b 60             	lea    0x60(%ebx),%edi
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
8010210e:	e8 cd 2d 00 00       	call   80104ee0 <holdingsleep>
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
80102148:	e8 43 2f 00 00       	call   80105090 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102153:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102156:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215d:	85 d2                	test   %edx,%edx
8010215f:	75 09                	jne    8010216a <iderw+0x6a>
80102161:	eb 58                	jmp    801021bb <iderw+0xbb>
80102163:	90                   	nop
80102164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102168:	89 c2                	mov    %eax,%edx
8010216a:	8b 42 5c             	mov    0x5c(%edx),%eax
8010216d:	85 c0                	test   %eax,%eax
8010216f:	75 f7                	jne    80102168 <iderw+0x68>
80102171:	83 c2 5c             	add    $0x5c,%edx
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
80102199:	e8 72 1d 00 00       	call   80103f10 <sleep>
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
801021b6:	e9 a5 2f 00 00       	jmp    80105160 <release>

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
801021ce:	68 2a 7f 10 80       	push   $0x80107f2a
801021d3:	e8 98 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021d8:	83 ec 0c             	sub    $0xc,%esp
801021db:	68 55 7f 10 80       	push   $0x80107f55
801021e0:	e8 8b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021e5:	83 ec 0c             	sub    $0xc,%esp
801021e8:	68 40 7f 10 80       	push   $0x80107f40
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
80102201:	c7 05 a0 37 11 80 00 	movl   $0xfec00000,0x801137a0
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
80102219:	8b 15 a0 37 11 80    	mov    0x801137a0,%edx
8010221f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102222:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102228:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222e:	0f b6 15 00 39 11 80 	movzbl 0x80113900,%edx
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
8010224a:	68 74 7f 10 80       	push   $0x80107f74
8010224f:	e8 0c e4 ff ff       	call   80100660 <cprintf>
80102254:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
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
80102272:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
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
80102290:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
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
801022b1:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
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
801022c5:	8b 0d a0 37 11 80    	mov    0x801137a0,%ecx
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
801022d6:	a1 a0 37 11 80       	mov    0x801137a0,%eax
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
80102302:	81 fb a8 45 12 80    	cmp    $0x801245a8,%ebx
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
80102322:	e8 89 2e 00 00       	call   801051b0 <memset>

  if(kmem.use_lock)
80102327:	8b 15 f8 37 11 80    	mov    0x801137f8,%edx
8010232d:	83 c4 10             	add    $0x10,%esp
80102330:	85 d2                	test   %edx,%edx
80102332:	75 2c                	jne    80102360 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102334:	a1 fc 37 11 80       	mov    0x801137fc,%eax
80102339:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010233b:	a1 f8 37 11 80       	mov    0x801137f8,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102340:	89 1d fc 37 11 80    	mov    %ebx,0x801137fc
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
80102350:	c7 45 08 c0 37 11 80 	movl   $0x801137c0,0x8(%ebp)
}
80102357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010235a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010235b:	e9 00 2e 00 00       	jmp    80105160 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 c0 37 11 80       	push   $0x801137c0
80102368:	e8 23 2d 00 00       	call   80105090 <acquire>
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	eb c2                	jmp    80102334 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102372:	83 ec 0c             	sub    $0xc,%esp
80102375:	68 a6 7f 10 80       	push   $0x80107fa6
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
801023db:	68 ac 7f 10 80       	push   $0x80107fac
801023e0:	68 c0 37 11 80       	push   $0x801137c0
801023e5:	e8 46 2b 00 00       	call   80104f30 <initlock>

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
801023f0:	c7 05 f8 37 11 80 00 	movl   $0x0,0x801137f8
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
80102484:	c7 05 f8 37 11 80 01 	movl   $0x1,0x801137f8
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
801024a7:	a1 f8 37 11 80       	mov    0x801137f8,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d fc 37 11 80    	mov    0x801137fc,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 1c                	je     801024d6 <kalloc+0x36>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 fc 37 11 80    	mov    %edx,0x801137fc
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 10                	je     801024d6 <kalloc+0x36>
    release(&kmem.lock);
801024c6:	83 ec 0c             	sub    $0xc,%esp
801024c9:	68 c0 37 11 80       	push   $0x801137c0
801024ce:	e8 8d 2c 00 00       	call   80105160 <release>
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
801024e3:	68 c0 37 11 80       	push   $0x801137c0
801024e8:	e8 a3 2b 00 00       	call   80105090 <acquire>
  r = kmem.freelist;
801024ed:	8b 1d fc 37 11 80    	mov    0x801137fc,%ebx
  if(r)
801024f3:	83 c4 10             	add    $0x10,%esp
801024f6:	a1 f8 37 11 80       	mov    0x801137f8,%eax
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
80102534:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
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
80102546:	0f b6 82 e0 80 10 80 	movzbl -0x7fef7f20(%edx),%eax
8010254d:	83 c8 40             	or     $0x40,%eax
80102550:	0f b6 c0             	movzbl %al,%eax
80102553:	f7 d0                	not    %eax
80102555:	21 c8                	and    %ecx,%eax
80102557:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
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
8010256e:	0f b6 82 e0 80 10 80 	movzbl -0x7fef7f20(%edx),%eax
80102575:	09 c1                	or     %eax,%ecx
80102577:	0f b6 82 e0 7f 10 80 	movzbl -0x7fef8020(%edx),%eax
8010257e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102580:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102582:	89 0d b8 b5 10 80    	mov    %ecx,0x8010b5b8
  c = charcode[shift & (CTL | SHIFT)][data];
80102588:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010258b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010258e:	8b 04 85 c0 7f 10 80 	mov    -0x7fef8040(,%eax,4),%eax
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
801025b2:	83 0d b8 b5 10 80 40 	orl    $0x40,0x8010b5b8
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
80102600:	a1 00 38 11 80       	mov    0x80113800,%eax
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
80102700:	a1 00 38 11 80       	mov    0x80113800,%eax
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
80102720:	a1 00 38 11 80       	mov    0x80113800,%eax
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
8010278e:	a1 00 38 11 80       	mov    0x80113800,%eax
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
801028f4:	e8 07 29 00 00       	call   80105200 <memcmp>
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
801029c0:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
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
801029e0:	a1 58 38 11 80       	mov    0x80113858,%eax
801029e5:	83 ec 08             	sub    $0x8,%esp
801029e8:	01 d8                	add    %ebx,%eax
801029ea:	83 c0 01             	add    $0x1,%eax
801029ed:	50                   	push   %eax
801029ee:	ff 35 68 38 11 80    	pushl  0x80113868
801029f4:	e8 d7 d6 ff ff       	call   801000d0 <bread>
801029f9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029fb:	58                   	pop    %eax
801029fc:	5a                   	pop    %edx
801029fd:	ff 34 9d 70 38 11 80 	pushl  -0x7feec790(,%ebx,4)
80102a04:	ff 35 68 38 11 80    	pushl  0x80113868
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
80102a14:	8d 47 60             	lea    0x60(%edi),%eax
80102a17:	83 c4 0c             	add    $0xc,%esp
80102a1a:	68 00 02 00 00       	push   $0x200
80102a1f:	50                   	push   %eax
80102a20:	8d 46 60             	lea    0x60(%esi),%eax
80102a23:	50                   	push   %eax
80102a24:	e8 37 28 00 00       	call   80105260 <memmove>
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
80102a44:	39 1d 6c 38 11 80    	cmp    %ebx,0x8011386c
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
80102a67:	ff 35 58 38 11 80    	pushl  0x80113858
80102a6d:	ff 35 68 38 11 80    	pushl  0x80113868
80102a73:	e8 58 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a78:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
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
80102a85:	89 48 60             	mov    %ecx,0x60(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a88:	7e 1f                	jle    80102aa9 <write_head+0x49>
80102a8a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a91:	31 d2                	xor    %edx,%edx
80102a93:	90                   	nop
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a98:	8b 8a 70 38 11 80    	mov    -0x7feec790(%edx),%ecx
80102a9e:	89 4c 13 64          	mov    %ecx,0x64(%ebx,%edx,1)
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
80102aca:	68 e0 81 10 80       	push   $0x801081e0
80102acf:	68 20 38 11 80       	push   $0x80113820
80102ad4:	e8 57 24 00 00       	call   80104f30 <initlock>
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
80102aec:	89 1d 68 38 11 80    	mov    %ebx,0x80113868

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102af2:	89 15 5c 38 11 80    	mov    %edx,0x8011385c
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102af8:	a3 58 38 11 80       	mov    %eax,0x80113858

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
80102b05:	8b 48 60             	mov    0x60(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b08:	83 c4 10             	add    $0x10,%esp
80102b0b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b0d:	89 0d 6c 38 11 80    	mov    %ecx,0x8011386c
  for (i = 0; i < log.lh.n; i++) {
80102b13:	7e 1c                	jle    80102b31 <initlog+0x71>
80102b15:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b1c:	31 d2                	xor    %edx,%edx
80102b1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b20:	8b 4c 10 64          	mov    0x64(%eax,%edx,1),%ecx
80102b24:	83 c2 04             	add    $0x4,%edx
80102b27:	89 8a 6c 38 11 80    	mov    %ecx,-0x7feec794(%edx)
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
80102b3f:	c7 05 6c 38 11 80 00 	movl   $0x0,0x8011386c
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
80102b66:	68 20 38 11 80       	push   $0x80113820
80102b6b:	e8 20 25 00 00       	call   80105090 <acquire>
80102b70:	83 c4 10             	add    $0x10,%esp
80102b73:	eb 18                	jmp    80102b8d <begin_op+0x2d>
80102b75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b78:	83 ec 08             	sub    $0x8,%esp
80102b7b:	68 20 38 11 80       	push   $0x80113820
80102b80:	68 20 38 11 80       	push   $0x80113820
80102b85:	e8 86 13 00 00       	call   80103f10 <sleep>
80102b8a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b8d:	a1 64 38 11 80       	mov    0x80113864,%eax
80102b92:	85 c0                	test   %eax,%eax
80102b94:	75 e2                	jne    80102b78 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b96:	a1 60 38 11 80       	mov    0x80113860,%eax
80102b9b:	8b 15 6c 38 11 80    	mov    0x8011386c,%edx
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
80102bb2:	a3 60 38 11 80       	mov    %eax,0x80113860
      release(&log.lock);
80102bb7:	68 20 38 11 80       	push   $0x80113820
80102bbc:	e8 9f 25 00 00       	call   80105160 <release>
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
80102bd9:	68 20 38 11 80       	push   $0x80113820
80102bde:	e8 ad 24 00 00       	call   80105090 <acquire>
  log.outstanding -= 1;
80102be3:	a1 60 38 11 80       	mov    0x80113860,%eax
  if(log.committing)
80102be8:	8b 1d 64 38 11 80    	mov    0x80113864,%ebx
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
80102bf6:	a3 60 38 11 80       	mov    %eax,0x80113860
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
80102c0c:	c7 05 64 38 11 80 01 	movl   $0x1,0x80113864
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
80102c18:	68 20 38 11 80       	push   $0x80113820
80102c1d:	e8 3e 25 00 00       	call   80105160 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c22:	8b 0d 6c 38 11 80    	mov    0x8011386c,%ecx
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
80102c38:	a1 58 38 11 80       	mov    0x80113858,%eax
80102c3d:	83 ec 08             	sub    $0x8,%esp
80102c40:	01 d8                	add    %ebx,%eax
80102c42:	83 c0 01             	add    $0x1,%eax
80102c45:	50                   	push   %eax
80102c46:	ff 35 68 38 11 80    	pushl  0x80113868
80102c4c:	e8 7f d4 ff ff       	call   801000d0 <bread>
80102c51:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c53:	58                   	pop    %eax
80102c54:	5a                   	pop    %edx
80102c55:	ff 34 9d 70 38 11 80 	pushl  -0x7feec790(,%ebx,4)
80102c5c:	ff 35 68 38 11 80    	pushl  0x80113868
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
80102c6c:	8d 40 60             	lea    0x60(%eax),%eax
80102c6f:	83 c4 0c             	add    $0xc,%esp
80102c72:	68 00 02 00 00       	push   $0x200
80102c77:	50                   	push   %eax
80102c78:	8d 46 60             	lea    0x60(%esi),%eax
80102c7b:	50                   	push   %eax
80102c7c:	e8 df 25 00 00       	call   80105260 <memmove>
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
80102c9c:	3b 1d 6c 38 11 80    	cmp    0x8011386c,%ebx
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
80102cae:	c7 05 6c 38 11 80 00 	movl   $0x0,0x8011386c
80102cb5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cb8:	e8 a3 fd ff ff       	call   80102a60 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cbd:	83 ec 0c             	sub    $0xc,%esp
80102cc0:	68 20 38 11 80       	push   $0x80113820
80102cc5:	e8 c6 23 00 00       	call   80105090 <acquire>
    log.committing = 0;
    wakeup(&log);
80102cca:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cd1:	c7 05 64 38 11 80 00 	movl   $0x0,0x80113864
80102cd8:	00 00 00 
    wakeup(&log);
80102cdb:	e8 30 17 00 00       	call   80104410 <wakeup>
    release(&log.lock);
80102ce0:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80102ce7:	e8 74 24 00 00       	call   80105160 <release>
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
80102d03:	68 20 38 11 80       	push   $0x80113820
80102d08:	e8 03 17 00 00       	call   80104410 <wakeup>
  }
  release(&log.lock);
80102d0d:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80102d14:	e8 47 24 00 00       	call   80105160 <release>
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
80102d27:	68 e4 81 10 80       	push   $0x801081e4
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
80102d47:	8b 15 6c 38 11 80    	mov    0x8011386c,%edx
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
80102d59:	a1 5c 38 11 80       	mov    0x8011385c,%eax
80102d5e:	83 e8 01             	sub    $0x1,%eax
80102d61:	39 c2                	cmp    %eax,%edx
80102d63:	0f 8d 87 00 00 00    	jge    80102df0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d69:	a1 60 38 11 80       	mov    0x80113860,%eax
80102d6e:	85 c0                	test   %eax,%eax
80102d70:	0f 8e 87 00 00 00    	jle    80102dfd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d76:	83 ec 0c             	sub    $0xc,%esp
80102d79:	68 20 38 11 80       	push   $0x80113820
80102d7e:	e8 0d 23 00 00       	call   80105090 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d83:	8b 15 6c 38 11 80    	mov    0x8011386c,%edx
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
80102d96:	3b 0d 70 38 11 80    	cmp    0x80113870,%ecx
80102d9c:	75 0b                	jne    80102da9 <log_write+0x69>
80102d9e:	eb 38                	jmp    80102dd8 <log_write+0x98>
80102da0:	39 0c 85 70 38 11 80 	cmp    %ecx,-0x7feec790(,%eax,4)
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
80102db0:	89 0c 95 70 38 11 80 	mov    %ecx,-0x7feec790(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102db7:	83 c2 01             	add    $0x1,%edx
80102dba:	89 15 6c 38 11 80    	mov    %edx,0x8011386c
  b->flags |= B_DIRTY; // prevent eviction
80102dc0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102dc3:	c7 45 08 20 38 11 80 	movl   $0x80113820,0x8(%ebp)
}
80102dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dcd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dce:	e9 8d 23 00 00       	jmp    80105160 <release>
80102dd3:	90                   	nop
80102dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dd8:	89 0c 85 70 38 11 80 	mov    %ecx,-0x7feec790(,%eax,4)
80102ddf:	eb df                	jmp    80102dc0 <log_write+0x80>
80102de1:	8b 43 08             	mov    0x8(%ebx),%eax
80102de4:	a3 70 38 11 80       	mov    %eax,0x80113870
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
80102df3:	68 f3 81 10 80       	push   $0x801081f3
80102df8:	e8 73 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dfd:	83 ec 0c             	sub    $0xc,%esp
80102e00:	68 09 82 10 80       	push   $0x80108209
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
80102e28:	68 24 82 10 80       	push   $0x80108224
80102e2d:	e8 2e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e32:	e8 f9 36 00 00       	call   80106530 <idtinit>
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
80102e4a:	e8 71 0e 00 00       	call   80103cc0 <scheduler>
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
80102e56:	e8 f5 47 00 00       	call   80107650 <switchkvm>
  seginit();
80102e5b:	e8 f0 46 00 00       	call   80107550 <seginit>
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
80102e7f:	bb 20 39 11 80       	mov    $0x80113920,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e84:	83 ec 08             	sub    $0x8,%esp
80102e87:	68 00 00 40 80       	push   $0x80400000
80102e8c:	68 a8 45 12 80       	push   $0x801245a8
80102e91:	e8 3a f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e96:	e8 65 4c 00 00       	call   80107b00 <kvmalloc>
  mpinit();        // detect other processors
80102e9b:	e8 70 01 00 00       	call   80103010 <mpinit>
  lapicinit();     // interrupt controller
80102ea0:	e8 5b f7 ff ff       	call   80102600 <lapicinit>
  seginit();       // segment descriptors
80102ea5:	e8 a6 46 00 00       	call   80107550 <seginit>
  picinit();       // disable pic
80102eaa:	e8 31 03 00 00       	call   801031e0 <picinit>
  ioapicinit();    // another interrupt controller
80102eaf:	e8 4c f3 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102eb4:	e8 e7 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102eb9:	e8 62 39 00 00       	call   80106820 <uartinit>
  pinit();         // process table
80102ebe:	e8 8d 08 00 00       	call   80103750 <pinit>
  tvinit();        // trap vectors
80102ec3:	e8 c8 35 00 00       	call   80106490 <tvinit>
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
80102ee9:	e8 72 23 00 00       	call   80105260 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102eee:	69 05 c0 3e 11 80 b4 	imul   $0xb4,0x80113ec0,%eax
80102ef5:	00 00 00 
80102ef8:	83 c4 10             	add    $0x10,%esp
80102efb:	05 20 39 11 80       	add    $0x80113920,%eax
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
80102f5a:	69 05 c0 3e 11 80 b4 	imul   $0xb4,0x80113ec0,%eax
80102f61:	00 00 00 
80102f64:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80102f6a:	05 20 39 11 80       	add    $0x80113920,%eax
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
80102fb8:	68 38 82 10 80       	push   $0x80108238
80102fbd:	56                   	push   %esi
80102fbe:	e8 3d 22 00 00       	call   80105200 <memcmp>
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
8010307c:	68 3d 82 10 80       	push   $0x8010823d
80103081:	56                   	push   %esi
80103082:	e8 79 21 00 00       	call   80105200 <memcmp>
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
801030df:	a3 00 38 11 80       	mov    %eax,0x80113800
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
80103110:	ff 24 95 7c 82 10 80 	jmp    *-0x7fef7d84(,%edx,4)
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
80103158:	8b 0d c0 3e 11 80    	mov    0x80113ec0,%ecx
8010315e:	83 f9 07             	cmp    $0x7,%ecx
80103161:	7f 19                	jg     8010317c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103163:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103167:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
8010316d:	83 c1 01             	add    $0x1,%ecx
80103170:	89 0d c0 3e 11 80    	mov    %ecx,0x80113ec0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103176:	88 97 20 39 11 80    	mov    %dl,-0x7feec6e0(%edi)
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
8010318f:	88 15 00 39 11 80    	mov    %dl,0x80113900
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
801031b7:	68 42 82 10 80       	push   $0x80108242
801031bc:	e8 af d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031c1:	83 ec 0c             	sub    $0xc,%esp
801031c4:	68 5c 82 10 80       	push   $0x8010825c
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
8010324b:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103252:	00 00 00 
  p->writeopen = 1;
80103255:	c7 80 44 02 00 00 01 	movl   $0x1,0x244(%eax)
8010325c:	00 00 00 
  p->nwrite = 0;
8010325f:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103266:	00 00 00 
  p->nread = 0;
80103269:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103270:	00 00 00 
  initlock(&p->lock, "pipe");
80103273:	68 90 82 10 80       	push   $0x80108290
80103278:	50                   	push   %eax
80103279:	e8 b2 1c 00 00       	call   80104f30 <initlock>
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
8010330f:	e8 7c 1d 00 00       	call   80105090 <acquire>
  if(writable){
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	85 f6                	test   %esi,%esi
80103319:	74 45                	je     80103360 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010331b:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103321:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103324:	c7 83 44 02 00 00 00 	movl   $0x0,0x244(%ebx)
8010332b:	00 00 00 
    wakeup(&p->nread);
8010332e:	50                   	push   %eax
8010332f:	e8 dc 10 00 00       	call   80104410 <wakeup>
80103334:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103337:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
8010333d:	85 d2                	test   %edx,%edx
8010333f:	75 0a                	jne    8010334b <pipeclose+0x4b>
80103341:	8b 83 44 02 00 00    	mov    0x244(%ebx),%eax
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
80103354:	e9 07 1e 00 00       	jmp    80105160 <release>
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103360:	8d 83 3c 02 00 00    	lea    0x23c(%ebx),%eax
80103366:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103369:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103370:	00 00 00 
    wakeup(&p->nwrite);
80103373:	50                   	push   %eax
80103374:	e8 97 10 00 00       	call   80104410 <wakeup>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	eb b9                	jmp    80103337 <pipeclose+0x37>
8010337e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	53                   	push   %ebx
80103384:	e8 d7 1d 00 00       	call   80105160 <release>
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
801033ad:	e8 de 1c 00 00       	call   80105090 <acquire>
  for(i = 0; i < n; i++){
801033b2:	8b 45 10             	mov    0x10(%ebp),%eax
801033b5:	83 c4 10             	add    $0x10,%esp
801033b8:	85 c0                	test   %eax,%eax
801033ba:	0f 8e b9 00 00 00    	jle    80103479 <pipewrite+0xd9>
801033c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033c3:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033c9:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033cf:	8d b3 3c 02 00 00    	lea    0x23c(%ebx),%esi
801033d5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033d8:	03 4d 10             	add    0x10(%ebp),%ecx
801033db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033de:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
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
80103400:	e8 0b 10 00 00       	call   80104410 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103405:	58                   	pop    %eax
80103406:	5a                   	pop    %edx
80103407:	53                   	push   %ebx
80103408:	56                   	push   %esi
80103409:	e8 02 0b 00 00       	call   80103f10 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010340e:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103414:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010341a:	83 c4 10             	add    $0x10,%esp
8010341d:	05 00 02 00 00       	add    $0x200,%eax
80103422:	39 c2                	cmp    %eax,%edx
80103424:	75 2a                	jne    80103450 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103426:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010342c:	85 c0                	test   %eax,%eax
8010342e:	75 c0                	jne    801033f0 <pipewrite+0x50>
        release(&p->lock);
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	53                   	push   %ebx
80103434:	e8 27 1d 00 00       	call   80105160 <release>
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
80103460:	89 83 3c 02 00 00    	mov    %eax,0x23c(%ebx)
80103466:	0f b6 09             	movzbl (%ecx),%ecx
80103469:	88 4c 13 38          	mov    %cl,0x38(%ebx,%edx,1)
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
80103479:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010347f:	83 ec 0c             	sub    $0xc,%esp
80103482:	50                   	push   %eax
80103483:	e8 88 0f 00 00       	call   80104410 <wakeup>
  release(&p->lock);
80103488:	89 1c 24             	mov    %ebx,(%esp)
8010348b:	e8 d0 1c 00 00       	call   80105160 <release>
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
801034b0:	e8 db 1b 00 00       	call   80105090 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034b5:	83 c4 10             	add    $0x10,%esp
801034b8:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034be:	39 83 3c 02 00 00    	cmp    %eax,0x23c(%ebx)
801034c4:	75 6a                	jne    80103530 <piperead+0x90>
801034c6:	8b b3 44 02 00 00    	mov    0x244(%ebx),%esi
801034cc:	85 f6                	test   %esi,%esi
801034ce:	0f 84 cc 00 00 00    	je     801035a0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034d4:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034da:	eb 2d                	jmp    80103509 <piperead+0x69>
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e0:	83 ec 08             	sub    $0x8,%esp
801034e3:	53                   	push   %ebx
801034e4:	56                   	push   %esi
801034e5:	e8 26 0a 00 00       	call   80103f10 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034ea:	83 c4 10             	add    $0x10,%esp
801034ed:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034f3:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034f9:	75 35                	jne    80103530 <piperead+0x90>
801034fb:	8b 93 44 02 00 00    	mov    0x244(%ebx),%edx
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
80103519:	e8 42 1c 00 00       	call   80105160 <release>
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
80103537:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010353d:	31 c9                	xor    %ecx,%ecx
8010353f:	eb 15                	jmp    80103556 <piperead+0xb6>
80103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103548:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010354e:	3b 83 3c 02 00 00    	cmp    0x23c(%ebx),%eax
80103554:	74 5a                	je     801035b0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103556:	8d 70 01             	lea    0x1(%eax),%esi
80103559:	25 ff 01 00 00       	and    $0x1ff,%eax
8010355e:	89 b3 38 02 00 00    	mov    %esi,0x238(%ebx)
80103564:	0f b6 44 03 38       	movzbl 0x38(%ebx,%eax,1),%eax
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
80103574:	8d 83 3c 02 00 00    	lea    0x23c(%ebx),%eax
8010357a:	83 ec 0c             	sub    $0xc,%esp
8010357d:	50                   	push   %eax
8010357e:	e8 8d 0e 00 00       	call   80104410 <wakeup>
  release(&p->lock);
80103583:	89 1c 24             	mov    %ebx,(%esp)
80103586:	e8 d5 1b 00 00       	call   80105160 <release>
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
801035c0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
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
801035d1:	68 95 82 10 80       	push   $0x80108295
801035d6:	e8 85 d0 ff ff       	call   80100660 <cprintf>
801035db:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    char *sp;
    ptable.lock.name = "ALLOC";
    acquire(&ptable.lock);
801035de:	83 ec 0c             	sub    $0xc,%esp
    if (DEBUGMODE > 0)
        cprintf(" ALLOCPROC ");
    struct proc *p;
    struct thread *t;
    char *sp;
    ptable.lock.name = "ALLOC";
801035e1:	c7 05 24 4e 11 80 a1 	movl   $0x801082a1,0x80114e24
801035e8:	82 10 80 
    acquire(&ptable.lock);
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035eb:	bb 58 4e 11 80       	mov    $0x80114e58,%ebx
        cprintf(" ALLOCPROC ");
    struct proc *p;
    struct thread *t;
    char *sp;
    ptable.lock.name = "ALLOC";
    acquire(&ptable.lock);
801035f0:	68 20 4e 11 80       	push   $0x80114e20
801035f5:	e8 96 1a 00 00       	call   80105090 <acquire>
801035fa:	83 c4 10             	add    $0x10,%esp
801035fd:	eb 0f                	jmp    8010360e <allocproc+0x4e>
801035ff:	90                   	nop
    //struct spinlock *JustLock;


    //for (p = ptable.proc , JustLock = ptable.tlocks ; p < &ptable.proc[NPROC]; p++ , JustLock++ )
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103600:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
80103606:	81 fb 58 3d 12 80    	cmp    $0x80123d58,%ebx
8010360c:	74 40                	je     8010364e <allocproc+0x8e>
        if (p->state == UNUSED)
8010360e:	8b 73 08             	mov    0x8(%ebx),%esi
80103611:	85 f6                	test   %esi,%esi
80103613:	75 eb                	jne    80103600 <allocproc+0x40>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103615:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
8010361a:	8b 4b 7c             	mov    0x7c(%ebx),%ecx

    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010361d:	8d 73 74             	lea    0x74(%ebx),%esi

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
80103620:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    p->pid = nextpid++;
80103627:	8d 50 01             	lea    0x1(%eax),%edx
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
8010362a:	85 c9                	test   %ecx,%ecx
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
8010362c:	89 43 0c             	mov    %eax,0xc(%ebx)

    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010362f:	8d 83 b4 03 00 00    	lea    0x3b4(%ebx),%eax
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103635:	89 15 0c b0 10 80    	mov    %edx,0x8010b00c
    //p->procLock = JustLock;

    //TODO - from here- thread alloc
    //acquire(p->procLock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
8010363b:	75 0a                	jne    80103647 <allocproc+0x87>
8010363d:	eb 31                	jmp    80103670 <allocproc+0xb0>
8010363f:	90                   	nop
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
80103651:	68 20 4e 11 80       	push   $0x80114e20
80103656:	e8 05 1b 00 00       	call   80105160 <release>
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
801036ab:	c7 40 14 7f 64 10 80 	movl   $0x8010647f,0x14(%eax)

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
801036b2:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
801036b5:	6a 14                	push   $0x14
801036b7:	6a 00                	push   $0x0
801036b9:	50                   	push   %eax
801036ba:	e8 f1 1a 00 00       	call   801051b0 <memset>
    t->context->eip = (uint) forkret;
801036bf:	8b 46 14             	mov    0x14(%esi),%eax
801036c2:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)
    release(&ptable.lock);
801036c9:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
801036d0:	e8 8b 1a 00 00       	call   80105160 <release>
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
80103706:	68 20 4e 11 80       	push   $0x80114e20
8010370b:	e8 50 1a 00 00       	call   80105160 <release>

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
80103756:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
8010375c:	85 c9                	test   %ecx,%ecx
8010375e:	7e 10                	jle    80103770 <pinit+0x20>
        cprintf(" PINIT ");
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	68 a7 82 10 80       	push   $0x801082a7
80103768:	e8 f3 ce ff ff       	call   80100660 <cprintf>
8010376d:	83 c4 10             	add    $0x10,%esp
    //struct spinlock *l;
    initlock(&ptable.lock, "ptable");
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	68 af 82 10 80       	push   $0x801082af
80103778:	68 20 4e 11 80       	push   $0x80114e20
8010377d:	e8 ae 17 00 00       	call   80104f30 <initlock>
    initlock(&mtable.lock, "mtable");
80103782:	58                   	pop    %eax
80103783:	5a                   	pop    %edx
80103784:	68 b6 82 10 80       	push   $0x801082b6
80103789:	68 e0 3e 11 80       	push   $0x80113ee0
8010378e:	e8 9d 17 00 00       	call   80104f30 <initlock>
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
801037dc:	e8 cf 19 00 00       	call   801051b0 <memset>
    memset(t->context, 0, sizeof(*t->context));
801037e1:	83 c4 0c             	add    $0xc,%esp
801037e4:	6a 14                	push   $0x14
801037e6:	6a 00                	push   $0x0
801037e8:	ff 73 14             	pushl  0x14(%ebx)
801037eb:	e8 c0 19 00 00       	call   801051b0 <memset>
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
80103811:	8b 35 c0 3e 11 80    	mov    0x80113ec0,%esi
80103817:	85 f6                	test   %esi,%esi
80103819:	7e 3f                	jle    8010385a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
8010381b:	0f b6 15 20 39 11 80 	movzbl 0x80113920,%edx
80103822:	39 d0                	cmp    %edx,%eax
80103824:	74 30                	je     80103856 <mycpu+0x56>
80103826:	b9 d4 39 11 80       	mov    $0x801139d4,%ecx
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
8010384e:	05 20 39 11 80       	add    $0x80113920,%eax
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
8010385d:	68 bd 82 10 80       	push   $0x801082bd
80103862:	e8 09 cb ff ff       	call   80100370 <panic>
struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");
80103867:	83 ec 0c             	sub    $0xc,%esp
8010386a:	68 84 84 10 80       	push   $0x80108484
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
8010388b:	2d 20 39 11 80       	sub    $0x80113920,%eax
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
801038a7:	e8 04 17 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
801038ac:	e8 4f ff ff ff       	call   80103800 <mycpu>
    p = c->proc;
801038b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801038b7:	e8 34 17 00 00       	call   80104ff0 <popcli>
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
801038d7:	e8 d4 16 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
801038dc:	e8 1f ff ff ff       	call   80103800 <mycpu>
    t = c->currThread;
801038e1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
801038e7:	e8 04 17 00 00       	call   80104ff0 <popcli>
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
8010390e:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
    if ((p->pgdir = setupkvm()) == 0)
80103913:	e8 68 41 00 00       	call   80107a80 <setupkvm>
80103918:	85 c0                	test   %eax,%eax
8010391a:	89 43 04             	mov    %eax,0x4(%ebx)
8010391d:	0f 84 37 01 00 00    	je     80103a5a <userinit+0x15a>
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103923:	83 ec 04             	sub    $0x4,%esp
80103926:	68 2c 00 00 00       	push   $0x2c
8010392b:	68 60 b4 10 80       	push   $0x8010b460
80103930:	50                   	push   %eax
80103931:	e8 5a 3e 00 00       	call   80107790 <inituvm>
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
8010394c:	e8 5f 18 00 00       	call   801051b0 <memset>
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
801039cf:	68 e6 82 10 80       	push   $0x801082e6
801039d4:	50                   	push   %eax
801039d5:	e8 d6 19 00 00       	call   801053b0 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
801039da:	83 c4 0c             	add    $0xc,%esp
801039dd:	6a 10                	push   $0x10
801039df:	68 ef 82 10 80       	push   $0x801082ef
801039e4:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039ea:	83 c0 20             	add    $0x20,%eax
801039ed:	50                   	push   %eax
801039ee:	e8 bd 19 00 00       	call   801053b0 <safestrcpy>
    p->cwd = namei("/");
801039f3:	c7 04 24 fa 82 10 80 	movl   $0x801082fa,(%esp)
801039fa:	e8 d1 e4 ff ff       	call   80101ed0 <namei>
801039ff:	89 43 60             	mov    %eax,0x60(%ebx)
    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.

    ptable.lock.name = "INIT";
80103a02:	c7 05 24 4e 11 80 05 	movl   $0x80108305,0x80114e24
80103a09:	83 10 80 
    acquire(&ptable.lock);
80103a0c:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103a13:	e8 78 16 00 00       	call   80105090 <acquire>
    //acquire(p->procLock);

    p->state = RUNNABLE;
    p->mainThread->state = RUNNABLE;
80103a18:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax

    ptable.lock.name = "INIT";
    acquire(&ptable.lock);
    //acquire(p->procLock);

    p->state = RUNNABLE;
80103a1e:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103a25:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)

    //release(p->procLock);
    release(&ptable.lock);
80103a2c:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103a33:	e8 28 17 00 00       	call   80105160 <release>
    if (DEBUGMODE > 0)
80103a38:	8b 1d bc b5 10 80    	mov    0x8010b5bc,%ebx
80103a3e:	83 c4 10             	add    $0x10,%esp
80103a41:	85 db                	test   %ebx,%ebx
80103a43:	7e 10                	jle    80103a55 <userinit+0x155>
        cprintf("DONE USERINIT");
80103a45:	83 ec 0c             	sub    $0xc,%esp
80103a48:	68 fc 82 10 80       	push   $0x801082fc
80103a4d:	e8 0e cc ff ff       	call   80100660 <cprintf>
80103a52:	83 c4 10             	add    $0x10,%esp

}
80103a55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a58:	c9                   	leave  
80103a59:	c3                   	ret    
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	68 cd 82 10 80       	push   $0x801082cd
80103a62:	e8 09 c9 ff ff       	call   80100370 <panic>
80103a67:	89 f6                	mov    %esi,%esi
80103a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a70 <growproc>:
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
80103a74:	53                   	push   %ebx
80103a75:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103a78:	e8 33 15 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80103a7d:	e8 7e fd ff ff       	call   80103800 <mycpu>
    p = c->proc;
80103a82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103a88:	e8 63 15 00 00       	call   80104ff0 <popcli>
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();
    if (DEBUGMODE > 0)
80103a8d:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103a92:	85 c0                	test   %eax,%eax
80103a94:	7e 10                	jle    80103aa6 <growproc+0x36>
        cprintf(" GROWPROC APPLYED ");
80103a96:	83 ec 0c             	sub    $0xc,%esp
80103a99:	68 0a 83 10 80       	push   $0x8010830a
80103a9e:	e8 bd cb ff ff       	call   80100660 <cprintf>
80103aa3:	83 c4 10             	add    $0x10,%esp

    sz = curproc->sz;
    if (n > 0) {
80103aa6:	83 fe 00             	cmp    $0x0,%esi
    uint sz;
    struct proc *curproc = myproc();
    if (DEBUGMODE > 0)
        cprintf(" GROWPROC APPLYED ");

    sz = curproc->sz;
80103aa9:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103aab:	7e 33                	jle    80103ae0 <growproc+0x70>
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aad:	83 ec 04             	sub    $0x4,%esp
80103ab0:	01 c6                	add    %eax,%esi
80103ab2:	56                   	push   %esi
80103ab3:	50                   	push   %eax
80103ab4:	ff 73 04             	pushl  0x4(%ebx)
80103ab7:	e8 14 3e 00 00       	call   801078d0 <allocuvm>
80103abc:	83 c4 10             	add    $0x10,%esp
80103abf:	85 c0                	test   %eax,%eax
80103ac1:	74 3d                	je     80103b00 <growproc+0x90>
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
    switchuvm(curproc);
80103ac3:	83 ec 0c             	sub    $0xc,%esp
            return -1;
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
80103ac6:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103ac8:	53                   	push   %ebx
80103ac9:	e8 a2 3b 00 00       	call   80107670 <switchuvm>
    return 0;
80103ace:	83 c4 10             	add    $0x10,%esp
80103ad1:	31 c0                	xor    %eax,%eax
}
80103ad3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad6:	5b                   	pop    %ebx
80103ad7:	5e                   	pop    %esi
80103ad8:	5d                   	pop    %ebp
80103ad9:	c3                   	ret    
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
80103ae0:	74 e1                	je     80103ac3 <growproc+0x53>
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae2:	83 ec 04             	sub    $0x4,%esp
80103ae5:	01 c6                	add    %eax,%esi
80103ae7:	56                   	push   %esi
80103ae8:	50                   	push   %eax
80103ae9:	ff 73 04             	pushl  0x4(%ebx)
80103aec:	e8 df 3e 00 00       	call   801079d0 <deallocuvm>
80103af1:	83 c4 10             	add    $0x10,%esp
80103af4:	85 c0                	test   %eax,%eax
80103af6:	75 cb                	jne    80103ac3 <growproc+0x53>
80103af8:	90                   	nop
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" GROWPROC APPLYED ");

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
80103b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b05:	eb cc                	jmp    80103ad3 <growproc+0x63>
80103b07:	89 f6                	mov    %esi,%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b10 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103b19:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103b1e:	85 c0                	test   %eax,%eax
80103b20:	7e 10                	jle    80103b32 <fork+0x22>
        cprintf(" FORK ");
80103b22:	83 ec 0c             	sub    $0xc,%esp
80103b25:	68 1d 83 10 80       	push   $0x8010831d
80103b2a:	e8 31 cb ff ff       	call   80100660 <cprintf>
80103b2f:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103b32:	e8 79 14 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80103b37:	e8 c4 fc ff ff       	call   80103800 <mycpu>
    p = c->proc;
80103b3c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103b42:	89 c7                	mov    %eax,%edi
80103b44:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
80103b47:	e8 a4 14 00 00       	call   80104ff0 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103b4c:	e8 5f 14 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80103b51:	e8 aa fc ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80103b56:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103b5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103b5f:	e8 8c 14 00 00       	call   80104ff0 <popcli>
    struct proc *np;
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    // Allocate process.
    if ((np = allocproc()) == 0) {
80103b64:	e8 57 fa ff ff       	call   801035c0 <allocproc>
80103b69:	85 c0                	test   %eax,%eax
80103b6b:	89 c3                	mov    %eax,%ebx
80103b6d:	0f 84 fb 00 00 00    	je     80103c6e <fork+0x15e>
        return -1;
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103b73:	83 ec 08             	sub    $0x8,%esp
80103b76:	ff 37                	pushl  (%edi)
80103b78:	ff 77 04             	pushl  0x4(%edi)
80103b7b:	e8 d0 3f 00 00       	call   80107b50 <copyuvm>
80103b80:	83 c4 10             	add    $0x10,%esp
80103b83:	85 c0                	test   %eax,%eax
80103b85:	89 43 04             	mov    %eax,0x4(%ebx)
80103b88:	0f 84 e7 00 00 00    	je     80103c75 <fork+0x165>
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;
80103b91:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b94:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103b96:	89 53 10             	mov    %edx,0x10(%ebx)
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103b99:	89 03                	mov    %eax,(%ebx)
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;
80103b9b:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103ba1:	8b 71 10             	mov    0x10(%ecx),%esi
80103ba4:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ba9:	8b 40 10             	mov    0x10(%eax),%eax
80103bac:	89 c7                	mov    %eax,%edi
80103bae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103bb0:	31 f6                	xor    %esi,%esi
80103bb2:	89 d7                	mov    %edx,%edi
    np->sz = curproc->sz;
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;
80103bb4:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103bba:	8b 40 10             	mov    0x10(%eax),%eax
80103bbd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
80103bc8:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103bcc:	85 c0                	test   %eax,%eax
80103bce:	74 10                	je     80103be0 <fork+0xd0>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103bd0:	83 ec 0c             	sub    $0xc,%esp
80103bd3:	50                   	push   %eax
80103bd4:	e8 17 d2 ff ff       	call   80100df0 <filedup>
80103bd9:	83 c4 10             	add    $0x10,%esp
80103bdc:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    *np->mainThread->tf = *curthread->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103be0:	83 c6 01             	add    $0x1,%esi
80103be3:	83 fe 10             	cmp    $0x10,%esi
80103be6:	75 e0                	jne    80103bc8 <fork+0xb8>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
//    np->mainThread->cwd = idup(curthread->cwd);
    np->cwd = idup(curproc->cwd);
80103be8:	8b 7d e0             	mov    -0x20(%ebp),%edi
80103beb:	83 ec 0c             	sub    $0xc,%esp
80103bee:	ff 77 60             	pushl  0x60(%edi)
80103bf1:	e8 5a da ff ff       	call   80101650 <idup>
80103bf6:	89 43 60             	mov    %eax,0x60(%ebx)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf9:	89 f8                	mov    %edi,%eax
80103bfb:	83 c4 0c             	add    $0xc,%esp
80103bfe:	83 c0 64             	add    $0x64,%eax
80103c01:	6a 10                	push   $0x10
80103c03:	50                   	push   %eax
80103c04:	8d 43 64             	lea    0x64(%ebx),%eax
80103c07:	50                   	push   %eax
80103c08:	e8 a3 17 00 00       	call   801053b0 <safestrcpy>
    //TODO
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c10:	83 c4 0c             	add    $0xc,%esp
80103c13:	6a 10                	push   $0x10
80103c15:	83 c0 20             	add    $0x20,%eax
80103c18:	50                   	push   %eax
80103c19:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c1f:	83 c0 20             	add    $0x20,%eax
80103c22:	50                   	push   %eax
80103c23:	e8 88 17 00 00       	call   801053b0 <safestrcpy>

    pid = np->pid;
80103c28:	8b 73 0c             	mov    0xc(%ebx),%esi

    ptable.lock.name = "FORK";
80103c2b:	c7 05 24 4e 11 80 24 	movl   $0x80108324,0x80114e24
80103c32:	83 10 80 
    acquire(&ptable.lock);
80103c35:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103c3c:	e8 4f 14 00 00       	call   80105090 <acquire>
    //acquire(np->procLock);

    np->state = RUNNABLE;
    //TODO
    np->mainThread->state = RUNNABLE;
80103c41:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax

    ptable.lock.name = "FORK";
    acquire(&ptable.lock);
    //acquire(np->procLock);

    np->state = RUNNABLE;
80103c47:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    //TODO
    np->mainThread->state = RUNNABLE;
80103c4e:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)

    //release(np->procLock);
    release(&ptable.lock);
80103c55:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103c5c:	e8 ff 14 00 00       	call   80105160 <release>

    return pid;
80103c61:	83 c4 10             	add    $0x10,%esp
80103c64:	89 f0                	mov    %esi,%eax
}
80103c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c69:	5b                   	pop    %ebx
80103c6a:	5e                   	pop    %esi
80103c6b:	5f                   	pop    %edi
80103c6c:	5d                   	pop    %ebp
80103c6d:	c3                   	ret    
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
80103c6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c73:	eb f1                	jmp    80103c66 <fork+0x156>
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
80103c75:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c7b:	83 ec 0c             	sub    $0xc,%esp
80103c7e:	ff 70 04             	pushl  0x4(%eax)
80103c81:	e8 6a e6 ff ff       	call   801022f0 <kfree>
        np->mainThread->tkstack = 0;
80103c86:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
80103c8c:	83 c4 10             	add    $0x10,%esp
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
        np->mainThread->tkstack = 0;
80103c8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
80103c96:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
80103c9c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103ca3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103caa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103caf:	eb b5                	jmp    80103c66 <fork+0x156>
80103cb1:	eb 0d                	jmp    80103cc0 <scheduler>
80103cb3:	90                   	nop
80103cb4:	90                   	nop
80103cb5:	90                   	nop
80103cb6:	90                   	nop
80103cb7:	90                   	nop
80103cb8:	90                   	nop
80103cb9:	90                   	nop
80103cba:	90                   	nop
80103cbb:	90                   	nop
80103cbc:	90                   	nop
80103cbd:	90                   	nop
80103cbe:	90                   	nop
80103cbf:	90                   	nop

80103cc0 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	57                   	push   %edi
80103cc4:	56                   	push   %esi
80103cc5:	53                   	push   %ebx
80103cc6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103cc9:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103cce:	85 c0                	test   %eax,%eax
80103cd0:	7e 10                	jle    80103ce2 <scheduler+0x22>
        cprintf(" SCHEDULER ");
80103cd2:	83 ec 0c             	sub    $0xc,%esp
80103cd5:	68 29 83 10 80       	push   $0x80108329
80103cda:	e8 81 c9 ff ff       	call   80100660 <cprintf>
80103cdf:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct cpu *c = mycpu();
80103ce2:	e8 19 fb ff ff       	call   80103800 <mycpu>
    struct thread *t;
    c->proc = 0;
80103ce7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cee:	00 00 00 
void
scheduler(void) {
    if (DEBUGMODE > 0)
        cprintf(" SCHEDULER ");
    struct proc *p;
    struct cpu *c = mycpu();
80103cf1:	89 c6                	mov    %eax,%esi
80103cf3:	8d 40 04             	lea    0x4(%eax),%eax
80103cf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103d00:	fb                   	sti    
        sti();

        // Loop over process table looking for process to run.

        ptable.lock.name = "SCHEDUALER";
        acquire(&ptable.lock);
80103d01:	83 ec 0c             	sub    $0xc,%esp
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.

        ptable.lock.name = "SCHEDUALER";
80103d04:	c7 05 24 4e 11 80 35 	movl   $0x80108335,0x80114e24
80103d0b:	83 10 80 
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d0e:	bf 58 4e 11 80       	mov    $0x80114e58,%edi
        sti();

        // Loop over process table looking for process to run.

        ptable.lock.name = "SCHEDUALER";
        acquire(&ptable.lock);
80103d13:	68 20 4e 11 80       	push   $0x80114e20
80103d18:	e8 73 13 00 00       	call   80105090 <acquire>
80103d1d:	83 c4 10             	add    $0x10,%esp
80103d20:	eb 18                	jmp    80103d3a <scheduler+0x7a>
80103d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d28:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
80103d2e:	81 ff 58 3d 12 80    	cmp    $0x80123d58,%edi
80103d34:	0f 84 9e 00 00 00    	je     80103dd8 <scheduler+0x118>
            if (p->state != RUNNABLE)
80103d3a:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d3e:	75 e8                	jne    80103d28 <scheduler+0x68>
            // to release ptable.lock and then reacquire it
            // before jumping back to us.

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
80103d40:	83 ec 0c             	sub    $0xc,%esp
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
80103d43:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
80103d49:	8d 5f 74             	lea    0x74(%edi),%ebx
            switchuvm(p);
80103d4c:	57                   	push   %edi
80103d4d:	e8 1e 39 00 00       	call   80107670 <switchuvm>
80103d52:	8d 97 b4 03 00 00    	lea    0x3b4(%edi),%edx
80103d58:	83 c4 10             	add    $0x10,%esp
80103d5b:	eb 0a                	jmp    80103d67 <scheduler+0xa7>
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d60:	83 c3 34             	add    $0x34,%ebx
80103d63:	39 da                	cmp    %ebx,%edx
80103d65:	76 41                	jbe    80103da8 <scheduler+0xe8>
                if (t->state != RUNNABLE)
80103d67:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103d6b:	75 f3                	jne    80103d60 <scheduler+0xa0>
                    continue;

                //cprintf("\n  FOUND TRED TO RUN %d" , t->tid);
                t->state = RUNNING;
80103d6d:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d74:	83 ec 08             	sub    $0x8,%esp
                if (t->state != RUNNABLE)
                    continue;

                //cprintf("\n  FOUND TRED TO RUN %d" , t->tid);
                t->state = RUNNING;
                c->currThread = t;
80103d77:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d7d:	ff 73 14             	pushl  0x14(%ebx)
80103d80:	ff 75 e0             	pushl  -0x20(%ebp)

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d83:	83 c3 34             	add    $0x34,%ebx
80103d86:	89 55 e4             	mov    %edx,-0x1c(%ebp)

//                    if( holding(p->procLock) )
//                    {
//                        release(p->procLock);
//                    }
                swtch(&(c->scheduler), t->context);
80103d89:	e8 7d 16 00 00       	call   8010540b <swtch>
                c->currThread = 0;
80103d8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103d9b:	00 00 00 

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
            switchuvm(p);
            //acquire(p->procLock);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103d9e:	39 da                	cmp    %ebx,%edx
80103da0:	77 c5                	ja     80103d67 <scheduler+0xa7>
80103da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        // Loop over process table looking for process to run.

        ptable.lock.name = "SCHEDUALER";
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103da8:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
//                    }
                swtch(&(c->scheduler), t->context);
                c->currThread = 0;

            }
            switchkvm();
80103dae:	e8 9d 38 00 00       	call   80107650 <switchkvm>
        // Loop over process table looking for process to run.

        ptable.lock.name = "SCHEDUALER";
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103db3:	81 ff 58 3d 12 80    	cmp    $0x80123d58,%edi
//            }


            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80103db9:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103dc0:	00 00 00 
            c->currThread = 0;
80103dc3:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103dca:	00 00 00 
        // Loop over process table looking for process to run.

        ptable.lock.name = "SCHEDUALER";
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dcd:	0f 85 67 ff ff ff    	jne    80103d3a <scheduler+0x7a>
80103dd3:	90                   	nop
80103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            // It should have changed its p->state before coming back.
            c->proc = 0;
            c->currThread = 0;

        }
        release(&ptable.lock);
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	68 20 4e 11 80       	push   $0x80114e20
80103de0:	e8 7b 13 00 00       	call   80105160 <release>

    }
80103de5:	83 c4 10             	add    $0x10,%esp
80103de8:	e9 13 ff ff ff       	jmp    80103d00 <scheduler+0x40>
80103ded:	8d 76 00             	lea    0x0(%esi),%esi

80103df0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
    if (DEBUGMODE > 1)
80103df0:	83 3d bc b5 10 80 01 	cmpl   $0x1,0x8010b5bc
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
80103df7:	55                   	push   %ebp
80103df8:	89 e5                	mov    %esp,%ebp
80103dfa:	56                   	push   %esi
80103dfb:	53                   	push   %ebx
    if (DEBUGMODE > 1)
80103dfc:	7e 10                	jle    80103e0e <sched+0x1e>
        cprintf(" SCHED ");
80103dfe:	83 ec 0c             	sub    $0xc,%esp
80103e01:	68 40 83 10 80       	push   $0x80108340
80103e06:	e8 55 c8 ff ff       	call   80100660 <cprintf>
80103e0b:	83 c4 10             	add    $0x10,%esp
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103e0e:	e8 9d 11 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80103e13:	e8 e8 f9 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80103e18:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103e1e:	e8 cd 11 00 00       	call   80104ff0 <popcli>
        cprintf(" SCHED ");
    int intena;
    //struct proc *p = myproc();
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
80103e23:	83 ec 0c             	sub    $0xc,%esp
80103e26:	68 20 4e 11 80       	push   $0x80114e20
80103e2b:	e8 30 12 00 00       	call   80105060 <holding>
80103e30:	83 c4 10             	add    $0x10,%esp
80103e33:	85 c0                	test   %eax,%eax
80103e35:	74 4f                	je     80103e86 <sched+0x96>
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
80103e37:	e8 c4 f9 ff ff       	call   80103800 <mycpu>
80103e3c:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e43:	75 68                	jne    80103ead <sched+0xbd>
        panic("sched locks");
    if (t->state == RUNNING)
80103e45:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103e49:	74 55                	je     80103ea0 <sched+0xb0>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e4b:	9c                   	pushf  
80103e4c:	58                   	pop    %eax
        panic("sched running");
    if (readeflags() & FL_IF)
80103e4d:	f6 c4 02             	test   $0x2,%ah
80103e50:	75 41                	jne    80103e93 <sched+0xa3>
        panic("sched interruptible");
    intena = mycpu()->intena;
80103e52:	e8 a9 f9 ff ff       	call   80103800 <mycpu>
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
80103e57:	83 c3 14             	add    $0x14,%ebx
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
80103e5a:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
80103e60:	e8 9b f9 ff ff       	call   80103800 <mycpu>
80103e65:	83 ec 08             	sub    $0x8,%esp
80103e68:	ff 70 04             	pushl  0x4(%eax)
80103e6b:	53                   	push   %ebx
80103e6c:	e8 9a 15 00 00       	call   8010540b <swtch>
    mycpu()->intena = intena;
80103e71:	e8 8a f9 ff ff       	call   80103800 <mycpu>
}
80103e76:	83 c4 10             	add    $0x10,%esp
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    //TODO - maybe need to change to mainThread->context
    swtch(&t->context, mycpu()->scheduler);
    mycpu()->intena = intena;
80103e79:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e82:	5b                   	pop    %ebx
80103e83:	5e                   	pop    %esi
80103e84:	5d                   	pop    %ebp
80103e85:	c3                   	ret    
    int intena;
    //struct proc *p = myproc();
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	68 48 83 10 80       	push   $0x80108348
80103e8e:	e8 dd c4 ff ff       	call   80100370 <panic>
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
80103e93:	83 ec 0c             	sub    $0xc,%esp
80103e96:	68 74 83 10 80       	push   $0x80108374
80103e9b:	e8 d0 c4 ff ff       	call   80100370 <panic>
    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	68 66 83 10 80       	push   $0x80108366
80103ea8:	e8 c3 c4 ff ff       	call   80100370 <panic>
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
80103ead:	83 ec 0c             	sub    $0xc,%esp
80103eb0:	68 5a 83 10 80       	push   $0x8010835a
80103eb5:	e8 b6 c4 ff ff       	call   80100370 <panic>
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ec0 <yield>:
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	53                   	push   %ebx
80103ec4:	83 ec 10             	sub    $0x10,%esp
    //struct  proc *p = myproc();
    //acquire(p->procLock);

    ptable.lock.name = "YIELD";
80103ec7:	c7 05 24 4e 11 80 88 	movl   $0x80108388,0x80114e24
80103ece:	83 10 80 
    acquire(&ptable.lock);
80103ed1:	68 20 4e 11 80       	push   $0x80114e20
80103ed6:	e8 b5 11 00 00       	call   80105090 <acquire>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103edb:	e8 d0 10 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80103ee0:	e8 1b f9 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80103ee5:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103eeb:	e8 00 11 00 00       	call   80104ff0 <popcli>
    //struct  proc *p = myproc();
    //acquire(p->procLock);

    ptable.lock.name = "YIELD";
    acquire(&ptable.lock);
    mythread()->state = RUNNABLE;
80103ef0:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103ef7:	e8 f4 fe ff ff       	call   80103df0 <sched>
    release(&ptable.lock);
80103efc:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103f03:	e8 58 12 00 00       	call   80105160 <release>
    //release(p->procLock);
}
80103f08:	83 c4 10             	add    $0x10,%esp
80103f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f0e:	c9                   	leave  
80103f0f:	c3                   	ret    

80103f10 <sleep>:
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80103f19:	83 3d bc b5 10 80 01 	cmpl   $0x1,0x8010b5bc
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103f20:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f23:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (DEBUGMODE > 1)
80103f26:	7e 10                	jle    80103f38 <sleep+0x28>
        cprintf(" SLEEP ");
80103f28:	83 ec 0c             	sub    $0xc,%esp
80103f2b:	68 8e 83 10 80       	push   $0x8010838e
80103f30:	e8 2b c7 ff ff       	call   80100660 <cprintf>
80103f35:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103f38:	e8 73 10 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80103f3d:	e8 be f8 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80103f42:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103f48:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103f4b:	e8 a0 10 00 00       	call   80104ff0 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80103f50:	e8 5b 10 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80103f55:	e8 a6 f8 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80103f5a:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103f60:	e8 8b 10 00 00       	call   80104ff0 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103f65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f68:	85 d2                	test   %edx,%edx
80103f6a:	0f 84 9b 00 00 00    	je     8010400b <sleep+0xfb>
        panic("sleep");

    if (lk == 0)
80103f70:	85 db                	test   %ebx,%ebx
80103f72:	0f 84 86 00 00 00    	je     80103ffe <sleep+0xee>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {
80103f78:	81 fb 20 4e 11 80    	cmp    $0x80114e20,%ebx
80103f7e:	74 60                	je     80103fe0 <sleep+0xd0>

        ptable.lock.name = "SLEEP";
        acquire(&ptable.lock);
80103f80:	83 ec 0c             	sub    $0xc,%esp
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {

        ptable.lock.name = "SLEEP";
80103f83:	c7 05 24 4e 11 80 ad 	movl   $0x801083ad,0x80114e24
80103f8a:	83 10 80 
        acquire(&ptable.lock);
80103f8d:	68 20 4e 11 80       	push   $0x80114e20
80103f92:	e8 f9 10 00 00       	call   80105090 <acquire>
        release(lk);
80103f97:	89 1c 24             	mov    %ebx,(%esp)
80103f9a:	e8 c1 11 00 00       	call   80105160 <release>
    }
    // Go to sleep.
    t->chan = chan;
80103f9f:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103fa2:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103fa9:	e8 42 fe ff ff       	call   80103df0 <sched>

    // Tidy up.
    t->chan = 0;
80103fae:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80103fb5:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80103fbc:	e8 9f 11 00 00       	call   80105160 <release>
        ptable.lock.name = "SLEEP2";
        acquire(lk);
80103fc1:	89 5d 08             	mov    %ebx,0x8(%ebp)
    t->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        ptable.lock.name = "SLEEP2";
80103fc4:	c7 05 24 4e 11 80 b3 	movl   $0x801083b3,0x80114e24
80103fcb:	83 10 80 
        acquire(lk);
80103fce:	83 c4 10             	add    $0x10,%esp
    }
}
80103fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fd4:	5b                   	pop    %ebx
80103fd5:	5e                   	pop    %esi
80103fd6:	5f                   	pop    %edi
80103fd7:	5d                   	pop    %ebp

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        ptable.lock.name = "SLEEP2";
        acquire(lk);
80103fd8:	e9 b3 10 00 00       	jmp    80105090 <acquire>
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
        ptable.lock.name = "SLEEP";
        acquire(&ptable.lock);
        release(lk);
    }
    // Go to sleep.
    t->chan = chan;
80103fe0:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103fe3:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103fea:	e8 01 fe ff ff       	call   80103df0 <sched>

    // Tidy up.
    t->chan = 0;
80103fef:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        ptable.lock.name = "SLEEP2";
        acquire(lk);
    }
}
80103ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ff9:	5b                   	pop    %ebx
80103ffa:	5e                   	pop    %esi
80103ffb:	5f                   	pop    %edi
80103ffc:	5d                   	pop    %ebp
80103ffd:	c3                   	ret    

    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	68 9c 83 10 80       	push   $0x8010839c
80104006:	e8 65 c3 ff ff       	call   80100370 <panic>

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
        panic("sleep");
8010400b:	83 ec 0c             	sub    $0xc,%esp
8010400e:	68 96 83 10 80       	push   $0x80108396
80104013:	e8 58 c3 ff ff       	call   80100370 <panic>
80104018:	90                   	nop
80104019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104020 <cleanProcOneThread>:
    memset(t->tf, 0, sizeof(*t->tf));
    memset(t->context, 0, sizeof(*t->context));
}

void
cleanProcOneThread(struct thread *curthread, struct proc *p) {
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 28             	sub    $0x28,%esp
80104029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010402c:	8b 5d 08             	mov    0x8(%ebp),%ebx

    struct thread *t;
    // Remove threads (except of the exec thread)
    ptable.lock.name = "CLEANPROCONETHREAD";
    acquire(&ptable.lock);
8010402f:	68 20 4e 11 80       	push   $0x80114e20
void
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    ptable.lock.name = "CLEANPROCONETHREAD";
80104034:	c7 05 24 4e 11 80 ba 	movl   $0x801083ba,0x80114e24
8010403b:	83 10 80 
    memset(t->tf, 0, sizeof(*t->tf));
    memset(t->context, 0, sizeof(*t->context));
}

void
cleanProcOneThread(struct thread *curthread, struct proc *p) {
8010403e:	89 c6                	mov    %eax,%esi
80104040:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    struct thread *t;
    // Remove threads (except of the exec thread)
    ptable.lock.name = "CLEANPROCONETHREAD";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104043:	8d 7e 74             	lea    0x74(%esi),%edi
80104046:	8d b6 b4 03 00 00    	lea    0x3b4(%esi),%esi
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    ptable.lock.name = "CLEANPROCONETHREAD";
    acquire(&ptable.lock);
8010404c:	e8 3f 10 00 00       	call   80105090 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (t != curthread && t->state != UNUSED ) {
80104058:	39 fb                	cmp    %edi,%ebx
8010405a:	74 18                	je     80104074 <cleanProcOneThread+0x54>
8010405c:	8b 57 08             	mov    0x8(%edi),%edx
8010405f:	85 d2                	test   %edx,%edx
80104061:	74 11                	je     80104074 <cleanProcOneThread+0x54>
            if (t->state == RUNNING)
80104063:	83 fa 04             	cmp    $0x4,%edx
80104066:	74 38                	je     801040a0 <cleanProcOneThread+0x80>
                sleep(t, &ptable.lock);
            //TODO MAYBE NEED TO BE ALSO PR ZOMBIE
            //if (t->state == RUNNING || t->state == RUNNABLE || t->state == ZOMBIE ) {
                cleanThread(t);
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	57                   	push   %edi
8010406c:	e8 2f f7 ff ff       	call   801037a0 <cleanThread>
80104071:	83 c4 10             	add    $0x10,%esp

    struct thread *t;
    // Remove threads (except of the exec thread)
    ptable.lock.name = "CLEANPROCONETHREAD";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104074:	83 c7 34             	add    $0x34,%edi
80104077:	39 f7                	cmp    %esi,%edi
80104079:	72 dd                	jb     80104058 <cleanProcOneThread+0x38>
            //if (t->state == RUNNING || t->state == RUNNABLE || t->state == ZOMBIE ) {
                cleanThread(t);
            //}
        }
    }
    p->mainThread = curthread;
8010407b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010407e:	89 98 b4 03 00 00    	mov    %ebx,0x3b4(%eax)
    release(&ptable.lock);
80104084:	c7 45 08 20 4e 11 80 	movl   $0x80114e20,0x8(%ebp)
}
8010408b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010408e:	5b                   	pop    %ebx
8010408f:	5e                   	pop    %esi
80104090:	5f                   	pop    %edi
80104091:	5d                   	pop    %ebp
                cleanThread(t);
            //}
        }
    }
    p->mainThread = curthread;
    release(&ptable.lock);
80104092:	e9 c9 10 00 00       	jmp    80105160 <release>
80104097:	89 f6                	mov    %esi,%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ptable.lock.name = "CLEANPROCONETHREAD";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t != curthread && t->state != UNUSED ) {
            if (t->state == RUNNING)
                sleep(t, &ptable.lock);
801040a0:	83 ec 08             	sub    $0x8,%esp
801040a3:	68 20 4e 11 80       	push   $0x80114e20
801040a8:	57                   	push   %edi
801040a9:	e8 62 fe ff ff       	call   80103f10 <sleep>
801040ae:	83 c4 10             	add    $0x10,%esp
801040b1:	eb b5                	jmp    80104068 <cleanProcOneThread+0x48>
801040b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040c0 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801040c9:	e8 e2 0e 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
801040ce:	e8 2d f7 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801040d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801040d9:	e8 12 0f 00 00       	call   80104ff0 <popcli>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
801040de:	e8 cd 0e 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
801040e3:	e8 18 f7 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
801040e8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801040ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
801040f1:	e8 fa 0e 00 00       	call   80104ff0 <popcli>
    struct proc *curproc = myproc();
    struct proc *p;
    //struct thread *t;
    struct thread *curthread = mythread();
    int fd;
    if (DEBUGMODE > 0)
801040f6:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801040fb:	85 c0                	test   %eax,%eax
801040fd:	7e 10                	jle    8010410f <exit+0x4f>
        cprintf("EXIT");
801040ff:	83 ec 0c             	sub    $0xc,%esp
80104102:	68 36 84 10 80       	push   $0x80108436
80104107:	e8 54 c5 ff ff       	call   80100660 <cprintf>
8010410c:	83 c4 10             	add    $0x10,%esp
    if (curproc == initproc)
8010410f:	39 35 c0 b5 10 80    	cmp    %esi,0x8010b5c0
80104115:	0f 84 63 01 00 00    	je     8010427e <exit+0x1be>
        panic("init exiting");


    cleanProcOneThread(curthread, curproc);
8010411b:	83 ec 08             	sub    $0x8,%esp
8010411e:	8d 7e 20             	lea    0x20(%esi),%edi
80104121:	8d 5e 60             	lea    0x60(%esi),%ebx
80104124:	56                   	push   %esi
80104125:	ff 75 e4             	pushl  -0x1c(%ebp)
80104128:	e8 f3 fe ff ff       	call   80104020 <cleanProcOneThread>
8010412d:	83 c4 10             	add    $0x10,%esp
    //When got here - the only thread that is RUNNINNg is curThread
    //all other threads are ZOMBIE

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
80104130:	8b 07                	mov    (%edi),%eax
80104132:	85 c0                	test   %eax,%eax
80104134:	74 12                	je     80104148 <exit+0x88>
            fileclose(curproc->ofile[fd]);
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	50                   	push   %eax
8010413a:	e8 01 cd ff ff       	call   80100e40 <fileclose>
            curproc->ofile[fd] = 0;
8010413f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	83 c7 04             	add    $0x4,%edi

    //When got here - the only thread that is RUNNINNg is curThread
    //all other threads are ZOMBIE

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
8010414b:	39 df                	cmp    %ebx,%edi
8010414d:	75 e1                	jne    80104130 <exit+0x70>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
8010414f:	e8 0c ea ff ff       	call   80102b60 <begin_op>
    iput(curproc->cwd);
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	ff 76 60             	pushl  0x60(%esi)
8010415a:	e8 51 d6 ff ff       	call   801017b0 <iput>
    end_op();
8010415f:	e8 6c ea ff ff       	call   80102bd0 <end_op>
    curproc->cwd = 0;
80104164:	c7 46 60 00 00 00 00 	movl   $0x0,0x60(%esi)

    ptable.lock.name = "EXIT2";
8010416b:	c7 05 24 4e 11 80 da 	movl   $0x801083da,0x80114e24
80104172:	83 10 80 
    acquire(&ptable.lock);
80104175:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
8010417c:	e8 0f 0f 00 00       	call   80105090 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent->mainThread);
80104181:	8b 46 10             	mov    0x10(%esi),%eax
80104184:	83 c4 10             	add    $0x10,%esp
80104187:	ba 0c 52 11 80       	mov    $0x8011520c,%edx
8010418c:	8b 88 b4 03 00 00    	mov    0x3b4(%eax),%ecx
80104192:	eb 12                	jmp    801041a6 <exit+0xe6>
80104194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104198:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010419e:	81 fa 0c 41 12 80    	cmp    $0x8012410c,%edx
801041a4:	74 35                	je     801041db <exit+0x11b>
        if (p->state != RUNNABLE)
801041a6:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
801041ad:	75 e9                	jne    80104198 <exit+0xd8>
801041af:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
801041b5:	eb 10                	jmp    801041c7 <exit+0x107>
801041b7:	89 f6                	mov    %esi,%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801041c0:	83 c0 34             	add    $0x34,%eax
801041c3:	39 d0                	cmp    %edx,%eax
801041c5:	73 d1                	jae    80104198 <exit+0xd8>
            if (t->state == SLEEPING && t->chan == chan)
801041c7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801041cb:	75 f3                	jne    801041c0 <exit+0x100>
801041cd:	3b 48 18             	cmp    0x18(%eax),%ecx
801041d0:	75 ee                	jne    801041c0 <exit+0x100>
                t->state = RUNNABLE;
801041d2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801041d9:	eb e5                	jmp    801041c0 <exit+0x100>
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801041db:	8b 3d c0 b5 10 80    	mov    0x8010b5c0,%edi
801041e1:	b9 58 4e 11 80       	mov    $0x80114e58,%ecx
801041e6:	eb 16                	jmp    801041fe <exit+0x13e>
801041e8:	90                   	nop
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    // Parent might be sleeping in wait().
    wakeup1(curproc->parent->mainThread);
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041f0:	81 c1 bc 03 00 00    	add    $0x3bc,%ecx
801041f6:	81 f9 58 3d 12 80    	cmp    $0x80123d58,%ecx
801041fc:	74 5d                	je     8010425b <exit+0x19b>
        if (p->parent == curproc) {
801041fe:	39 71 10             	cmp    %esi,0x10(%ecx)
80104201:	75 ed                	jne    801041f0 <exit+0x130>
            p->parent = initproc;
            if (p->state == ZOMBIE)
80104203:	83 79 08 05          	cmpl   $0x5,0x8(%ecx)
    //cprintf(" AFTER wakeup1(curproc->parent->mainThread);\n");

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
80104207:	89 79 10             	mov    %edi,0x10(%ecx)
            if (p->state == ZOMBIE)
8010420a:	75 e4                	jne    801041f0 <exit+0x130>
                wakeup1(initproc->mainThread);
8010420c:	8b 9f b4 03 00 00    	mov    0x3b4(%edi),%ebx
80104212:	ba 0c 52 11 80       	mov    $0x8011520c,%edx
80104217:	eb 15                	jmp    8010422e <exit+0x16e>
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104220:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104226:	81 fa 0c 41 12 80    	cmp    $0x8012410c,%edx
8010422c:	74 c2                	je     801041f0 <exit+0x130>
        if (p->state != RUNNABLE)
8010422e:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
80104235:	75 e9                	jne    80104220 <exit+0x160>
80104237:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
8010423d:	eb 08                	jmp    80104247 <exit+0x187>
8010423f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104240:	83 c0 34             	add    $0x34,%eax
80104243:	39 d0                	cmp    %edx,%eax
80104245:	73 d9                	jae    80104220 <exit+0x160>
            if (t->state == SLEEPING && t->chan == chan)
80104247:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010424b:	75 f3                	jne    80104240 <exit+0x180>
8010424d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104250:	75 ee                	jne    80104240 <exit+0x180>
                t->state = RUNNABLE;
80104252:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104259:	eb e5                	jmp    80104240 <exit+0x180>
    }
    //cprintf(" AFTER Pass abandoned children to init.\n");

    //TODO- where to unlock
    //cleanThread(curthread);
    curthread->state = ZOMBIE;
8010425b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010425e:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    //curthread->killed=1;
    //release(curproc->procLock);

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
80104265:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
8010426c:	e8 7f fb ff ff       	call   80103df0 <sched>
    panic("zombie exit");
80104271:	83 ec 0c             	sub    $0xc,%esp
80104274:	68 e0 83 10 80       	push   $0x801083e0
80104279:	e8 f2 c0 ff ff       	call   80100370 <panic>
    struct thread *curthread = mythread();
    int fd;
    if (DEBUGMODE > 0)
        cprintf("EXIT");
    if (curproc == initproc)
        panic("init exiting");
8010427e:	83 ec 0c             	sub    $0xc,%esp
80104281:	68 cd 83 10 80       	push   $0x801083cd
80104286:	e8 e5 c0 ff ff       	call   80100370 <panic>
8010428b:	90                   	nop
8010428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104290 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80104299:	83 3d bc b5 10 80 01 	cmpl   $0x1,0x8010b5bc
801042a0:	7e 10                	jle    801042b2 <wait+0x22>
        cprintf(" WAIT ");
801042a2:	83 ec 0c             	sub    $0xc,%esp
801042a5:	68 ec 83 10 80       	push   $0x801083ec
801042aa:	e8 b1 c3 ff ff       	call   80100660 <cprintf>
801042af:	83 c4 10             	add    $0x10,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801042b2:	e8 f9 0c 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
801042b7:	e8 44 f5 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801042bc:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801042c2:	e8 29 0d 00 00       	call   80104ff0 <popcli>
    int havekids, pid;
    struct proc *curproc = myproc();
    struct thread *t;

    ptable.lock.name = "WAIT";
    acquire(&ptable.lock);
801042c7:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();
    struct thread *t;

    ptable.lock.name = "WAIT";
801042ca:	c7 05 24 4e 11 80 f3 	movl   $0x801083f3,0x80114e24
801042d1:	83 10 80 
    acquire(&ptable.lock);
801042d4:	68 20 4e 11 80       	push   $0x80114e20
801042d9:	e8 b2 0d 00 00       	call   80105090 <acquire>
801042de:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
801042e1:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042e3:	bb 58 4e 11 80       	mov    $0x80114e58,%ebx
801042e8:	eb 14                	jmp    801042fe <wait+0x6e>
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042f0:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
801042f6:	81 fb 58 3d 12 80    	cmp    $0x80123d58,%ebx
801042fc:	74 22                	je     80104320 <wait+0x90>
            if (p->parent != curproc)
801042fe:	39 73 10             	cmp    %esi,0x10(%ebx)
80104301:	75 ed                	jne    801042f0 <wait+0x60>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
80104303:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80104307:	74 6a                	je     80104373 <wait+0xe3>
    ptable.lock.name = "WAIT";
    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104309:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
            if (p->parent != curproc)
                continue;
            havekids = 1;
8010430f:	b8 01 00 00 00       	mov    $0x1,%eax
    ptable.lock.name = "WAIT";
    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104314:	81 fb 58 3d 12 80    	cmp    $0x80123d58,%ebx
8010431a:	75 e2                	jne    801042fe <wait+0x6e>
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
80104320:	85 c0                	test   %eax,%eax
80104322:	0f 84 c6 00 00 00    	je     801043ee <wait+0x15e>
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104328:	e8 83 0c 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
8010432d:	e8 ce f4 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80104332:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104338:	e8 b3 0c 00 00       	call   80104ff0 <popcli>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
8010433d:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104340:	85 c0                	test   %eax,%eax
80104342:	0f 85 a6 00 00 00    	jne    801043ee <wait+0x15e>
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104348:	e8 63 0c 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
8010434d:	e8 ae f4 ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104352:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104358:	e8 93 0c 00 00       	call   80104ff0 <popcli>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
8010435d:	83 ec 08             	sub    $0x8,%esp
80104360:	68 20 4e 11 80       	push   $0x80114e20
80104365:	53                   	push   %ebx
80104366:	e8 a5 fb ff ff       	call   80103f10 <sleep>
    }
8010436b:	83 c4 10             	add    $0x10,%esp
8010436e:	e9 6e ff ff ff       	jmp    801042e1 <wait+0x51>
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
80104373:	8b 43 0c             	mov    0xc(%ebx),%eax
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104376:	8d 73 74             	lea    0x74(%ebx),%esi
80104379:	8d bb b4 03 00 00    	lea    0x3b4(%ebx),%edi
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
8010437f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104382:	eb 0b                	jmp    8010438f <wait+0xff>
80104384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104388:	83 c6 34             	add    $0x34,%esi
8010438b:	39 f7                	cmp    %esi,%edi
8010438d:	76 1a                	jbe    801043a9 <wait+0x119>
                    if (t->state != UNUSED)
8010438f:	8b 56 08             	mov    0x8(%esi),%edx
80104392:	85 d2                	test   %edx,%edx
80104394:	74 f2                	je     80104388 <wait+0xf8>
                        cleanThread(t);
80104396:	83 ec 0c             	sub    $0xc,%esp
80104399:	56                   	push   %esi
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010439a:	83 c6 34             	add    $0x34,%esi
                    if (t->state != UNUSED)
                        cleanThread(t);
8010439d:	e8 fe f3 ff ff       	call   801037a0 <cleanThread>
801043a2:	83 c4 10             	add    $0x10,%esp
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                //kfree for the stacks od the proc's threads
                //acquire(p->procLock);
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043a5:	39 f7                	cmp    %esi,%edi
801043a7:	77 e6                	ja     8010438f <wait+0xff>
                    if (t->state != UNUSED)
                        cleanThread(t);
                }
//                release(p->procLock);

                freevm(p->pgdir);
801043a9:	83 ec 0c             	sub    $0xc,%esp
801043ac:	ff 73 04             	pushl  0x4(%ebx)
801043af:	e8 4c 36 00 00       	call   80107a00 <freevm>
                p->pid = 0;
801043b4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
801043bb:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
801043c2:	c6 43 64 00          	movb   $0x0,0x64(%ebx)
                p->killed = 0;
801043c6:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
801043cd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
801043d4:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
801043db:	e8 80 0d 00 00       	call   80105160 <release>
                return pid;
801043e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043e3:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
801043e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e9:	5b                   	pop    %ebx
801043ea:	5e                   	pop    %esi
801043eb:	5f                   	pop    %edi
801043ec:	5d                   	pop    %ebp
801043ed:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
            release(&ptable.lock);
801043ee:	83 ec 0c             	sub    $0xc,%esp
801043f1:	68 20 4e 11 80       	push   $0x80114e20
801043f6:	e8 65 0d 00 00       	call   80105160 <release>
            return -1;
801043fb:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
801043fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
        }

        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
            release(&ptable.lock);
            return -1;
80104401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}
80104406:	5b                   	pop    %ebx
80104407:	5e                   	pop    %esi
80104408:	5f                   	pop    %edi
80104409:	5d                   	pop    %ebp
8010440a:	c3                   	ret    
8010440b:	90                   	nop
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104410 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 1)
80104417:	83 3d bc b5 10 80 01 	cmpl   $0x1,0x8010b5bc
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
8010441e:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 1)
80104421:	7e 10                	jle    80104433 <wakeup+0x23>
        cprintf(" WAKEUP ");
80104423:	83 ec 0c             	sub    $0xc,%esp
80104426:	68 f8 83 10 80       	push   $0x801083f8
8010442b:	e8 30 c2 ff ff       	call   80100660 <cprintf>
80104430:	83 c4 10             	add    $0x10,%esp
    char *aa =ptable.lock.name;
80104433:	a1 24 4e 11 80       	mov    0x80114e24,%eax
    ptable.lock.name = "WAKEUP";
    ptable.lock.namee = aa;
    acquire(&ptable.lock);
80104438:	83 ec 0c             	sub    $0xc,%esp
void
wakeup(void *chan) {
    if (DEBUGMODE > 1)
        cprintf(" WAKEUP ");
    char *aa =ptable.lock.name;
    ptable.lock.name = "WAKEUP";
8010443b:	c7 05 24 4e 11 80 01 	movl   $0x80108401,0x80114e24
80104442:	84 10 80 
    ptable.lock.namee = aa;
    acquire(&ptable.lock);
80104445:	68 20 4e 11 80       	push   $0x80114e20
wakeup(void *chan) {
    if (DEBUGMODE > 1)
        cprintf(" WAKEUP ");
    char *aa =ptable.lock.name;
    ptable.lock.name = "WAKEUP";
    ptable.lock.namee = aa;
8010444a:	a3 28 4e 11 80       	mov    %eax,0x80114e28
    acquire(&ptable.lock);
8010444f:	e8 3c 0c 00 00       	call   80105090 <acquire>
80104454:	ba 0c 52 11 80       	mov    $0x8011520c,%edx
80104459:	83 c4 10             	add    $0x10,%esp
8010445c:	eb 10                	jmp    8010446e <wakeup+0x5e>
8010445e:	66 90                	xchg   %ax,%ax
80104460:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104466:	81 fa 0c 41 12 80    	cmp    $0x8012410c,%edx
8010446c:	74 2d                	je     8010449b <wakeup+0x8b>
        if (p->state != RUNNABLE)
8010446e:	83 ba 54 fc ff ff 03 	cmpl   $0x3,-0x3ac(%edx)
80104475:	75 e9                	jne    80104460 <wakeup+0x50>
80104477:	8d 82 c0 fc ff ff    	lea    -0x340(%edx),%eax
8010447d:	eb 08                	jmp    80104487 <wakeup+0x77>
8010447f:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104480:	83 c0 34             	add    $0x34,%eax
80104483:	39 d0                	cmp    %edx,%eax
80104485:	73 d9                	jae    80104460 <wakeup+0x50>
            if (t->state == SLEEPING && t->chan == chan)
80104487:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010448b:	75 f3                	jne    80104480 <wakeup+0x70>
8010448d:	3b 58 18             	cmp    0x18(%eax),%ebx
80104490:	75 ee                	jne    80104480 <wakeup+0x70>
                t->state = RUNNABLE;
80104492:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104499:	eb e5                	jmp    80104480 <wakeup+0x70>
    char *aa =ptable.lock.name;
    ptable.lock.name = "WAKEUP";
    ptable.lock.namee = aa;
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
8010449b:	c7 45 08 20 4e 11 80 	movl   $0x80114e20,0x8(%ebp)
}
801044a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a5:	c9                   	leave  
    char *aa =ptable.lock.name;
    ptable.lock.name = "WAKEUP";
    ptable.lock.namee = aa;
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
801044a6:	e9 b5 0c 00 00       	jmp    80105160 <release>
801044ab:	90                   	nop
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044b0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 0)
801044b7:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801044bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 0)
801044bf:	85 c0                	test   %eax,%eax
801044c1:	7e 10                	jle    801044d3 <kill+0x23>
        cprintf(" KILL ");
801044c3:	83 ec 0c             	sub    $0xc,%esp
801044c6:	68 08 84 10 80       	push   $0x80108408
801044cb:	e8 90 c1 ff ff       	call   80100660 <cprintf>
801044d0:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    ptable.lock.name = "KILL";
    acquire(&ptable.lock);
801044d3:	83 ec 0c             	sub    $0xc,%esp
kill(int pid) {
    if (DEBUGMODE > 0)
        cprintf(" KILL ");
    struct proc *p;
    struct thread *t;
    ptable.lock.name = "KILL";
801044d6:	c7 05 24 4e 11 80 0f 	movl   $0x8010840f,0x80114e24
801044dd:	84 10 80 
    acquire(&ptable.lock);
801044e0:	68 20 4e 11 80       	push   $0x80114e20
801044e5:	e8 a6 0b 00 00       	call   80105090 <acquire>
801044ea:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044ed:	b8 58 4e 11 80       	mov    $0x80114e58,%eax
801044f2:	eb 10                	jmp    80104504 <kill+0x54>
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f8:	05 bc 03 00 00       	add    $0x3bc,%eax
801044fd:	3d 58 3d 12 80       	cmp    $0x80123d58,%eax
80104502:	74 6c                	je     80104570 <kill+0xc0>
        if (p->pid == pid) {
80104504:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104507:	75 ef                	jne    801044f8 <kill+0x48>
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104509:	8d 50 74             	lea    0x74(%eax),%edx
8010450c:	8d 88 b4 03 00 00    	lea    0x3b4(%eax),%ecx
80104512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                t->killed = 1;
80104518:	c7 42 1c 01 00 00 00 	movl   $0x1,0x1c(%edx)
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010451f:	83 c2 34             	add    $0x34,%edx
80104522:	39 ca                	cmp    %ecx,%edx
80104524:	72 f2                	jb     80104518 <kill+0x68>
                t->killed = 1;
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
80104526:	8b 90 b4 03 00 00    	mov    0x3b4(%eax),%edx
8010452c:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
80104530:	74 1e                	je     80104550 <kill+0xa0>
                p->mainThread->state = RUNNABLE;
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
            }

            //release( p->procLock );
            release(&ptable.lock);
80104532:	83 ec 0c             	sub    $0xc,%esp
80104535:	68 20 4e 11 80       	push   $0x80114e20
8010453a:	e8 21 0c 00 00       	call   80105160 <release>
            return 0;
8010453f:	83 c4 10             	add    $0x10,%esp
80104542:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104544:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104547:	c9                   	leave  
80104548:	c3                   	ret    
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
                t->killed = 1;
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
                p->mainThread->state = RUNNABLE;
80104550:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
80104557:	8b 80 b4 03 00 00    	mov    0x3b4(%eax),%eax
8010455d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104564:	eb cc                	jmp    80104532 <kill+0x82>
80104566:	8d 76 00             	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            //release( p->procLock );
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	68 20 4e 11 80       	push   $0x80114e20
80104578:	e8 e3 0b 00 00       	call   80105160 <release>
    return -1;
8010457d:	83 c4 10             	add    $0x10,%esp
80104580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104585:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104588:	c9                   	leave  
80104589:	c3                   	ret    
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
80104599:	bb bc 4e 11 80       	mov    $0x80114ebc,%ebx
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
801045ab:	68 c7 87 10 80       	push   $0x801087c7
801045b0:	e8 ab c0 ff ff       	call   80100660 <cprintf>
801045b5:	83 c4 10             	add    $0x10,%esp
801045b8:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045be:	81 fb bc 3d 12 80    	cmp    $0x80123dbc,%ebx
801045c4:	0f 84 96 00 00 00    	je     80104660 <procdump+0xd0>
        if (p->state == UNUSED)
801045ca:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801045cd:	85 c0                	test   %eax,%eax
801045cf:	74 e7                	je     801045b8 <procdump+0x28>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045d1:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
801045d4:	ba 14 84 10 80       	mov    $0x80108414,%edx
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045d9:	77 11                	ja     801045ec <procdump+0x5c>
801045db:	8b 14 85 ac 84 10 80 	mov    -0x7fef7b54(,%eax,4),%edx
            state = states[p->state];
        else
            state = "???";
801045e2:	b8 14 84 10 80       	mov    $0x80108414,%eax
801045e7:	85 d2                	test   %edx,%edx
801045e9:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
801045ec:	53                   	push   %ebx
801045ed:	52                   	push   %edx
801045ee:	ff 73 a8             	pushl  -0x58(%ebx)
801045f1:	68 18 84 10 80       	push   $0x80108418
801045f6:	e8 65 c0 ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
801045fb:	8b 83 50 03 00 00    	mov    0x350(%ebx),%eax
80104601:	83 c4 10             	add    $0x10,%esp
80104604:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
80104608:	75 9e                	jne    801045a8 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
8010460a:	8d 4d c0             	lea    -0x40(%ebp),%ecx
8010460d:	83 ec 08             	sub    $0x8,%esp
80104610:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104613:	51                   	push   %ecx
80104614:	8b 40 14             	mov    0x14(%eax),%eax
80104617:	8b 40 0c             	mov    0xc(%eax),%eax
8010461a:	83 c0 08             	add    $0x8,%eax
8010461d:	50                   	push   %eax
8010461e:	e8 2d 09 00 00       	call   80104f50 <getcallerpcs>
80104623:	83 c4 10             	add    $0x10,%esp
80104626:	8d 76 00             	lea    0x0(%esi),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104630:	8b 17                	mov    (%edi),%edx
80104632:	85 d2                	test   %edx,%edx
80104634:	0f 84 6e ff ff ff    	je     801045a8 <procdump+0x18>
                cprintf(" %p", pc[i]);
8010463a:	83 ec 08             	sub    $0x8,%esp
8010463d:	83 c7 04             	add    $0x4,%edi
80104640:	52                   	push   %edx
80104641:	68 81 7d 10 80       	push   $0x80107d81
80104646:	e8 15 c0 ff ff       	call   80100660 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
8010464b:	83 c4 10             	add    $0x10,%esp
8010464e:	39 f7                	cmp    %esi,%edi
80104650:	75 de                	jne    80104630 <procdump+0xa0>
80104652:	e9 51 ff ff ff       	jmp    801045a8 <procdump+0x18>
80104657:	89 f6                	mov    %esi,%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
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
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104675:	e8 36 09 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
8010467a:	e8 81 f1 ff ff       	call   80103800 <mycpu>
    p = c->proc;
8010467f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104685:	e8 66 09 00 00       	call   80104ff0 <popcli>
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    ptable.lock.name = "KTHREADCREATE";
    acquire(&ptable.lock);
8010468a:	83 ec 0c             	sub    $0xc,%esp
//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    ptable.lock.name = "KTHREADCREATE";
8010468d:	c7 05 24 4e 11 80 21 	movl   $0x80108421,0x80114e24
80104694:	84 10 80 
    acquire(&ptable.lock);
80104697:	68 20 4e 11 80       	push   $0x80114e20
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
8010469c:	8d 5e 74             	lea    0x74(%esi),%ebx
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    ptable.lock.name = "KTHREADCREATE";
    acquire(&ptable.lock);
8010469f:	e8 ec 09 00 00       	call   80105090 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
801046a4:	8b 46 7c             	mov    0x7c(%esi),%eax
801046a7:	83 c4 10             	add    $0x10,%esp
801046aa:	85 c0                	test   %eax,%eax
801046ac:	74 42                	je     801046f0 <kthread_create+0x80>
801046ae:	8d 86 b4 03 00 00    	lea    0x3b4(%esi),%eax
801046b4:	eb 11                	jmp    801046c7 <kthread_create+0x57>
801046b6:	8d 76 00             	lea    0x0(%esi),%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801046c0:	8b 73 08             	mov    0x8(%ebx),%esi
801046c3:	85 f6                	test   %esi,%esi
801046c5:	74 29                	je     801046f0 <kthread_create+0x80>
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    ptable.lock.name = "KTHREADCREATE";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801046c7:	83 c3 34             	add    $0x34,%ebx
801046ca:	39 c3                	cmp    %eax,%ebx
801046cc:	72 f2                	jb     801046c0 <kthread_create+0x50>
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	68 20 4e 11 80       	push   $0x80114e20
801046d6:	e8 85 0a 00 00       	call   80105160 <release>
        return -1;
801046db:	83 c4 10             	add    $0x10,%esp
    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
801046de:	8d 65 f8             	lea    -0x8(%ebp),%esp

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
        return -1;
801046e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
801046e6:	5b                   	pop    %ebx
801046e7:	5e                   	pop    %esi
801046e8:	5d                   	pop    %ebp
801046e9:	c3                   	ret    
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
    t->tid = tidCounter++;
801046f0:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    //got here- didn't have a room for new thread
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
801046f5:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    t->tid = tidCounter++;
801046fc:	8d 50 01             	lea    0x1(%eax),%edx
801046ff:	89 43 0c             	mov    %eax,0xc(%ebx)
80104702:	89 15 08 b0 10 80    	mov    %edx,0x8010b008

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
80104708:	e8 93 dd ff ff       	call   801024a0 <kalloc>
8010470d:	85 c0                	test   %eax,%eax
8010470f:	89 43 04             	mov    %eax,0x4(%ebx)
80104712:	0f 84 dd 00 00 00    	je     801047f5 <kthread_create+0x185>
    }

    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
80104718:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
8010471e:	83 ec 04             	sub    $0x4,%esp
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
80104721:	05 9c 0f 00 00       	add    $0xf9c,%eax
    }

    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
80104726:	89 53 10             	mov    %edx,0x10(%ebx)
    t->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;
80104729:	c7 40 14 7f 64 10 80 	movl   $0x8010647f,0x14(%eax)

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
80104730:	89 43 14             	mov    %eax,0x14(%ebx)
    memset(t->context, 0, sizeof *t->context);
80104733:	6a 14                	push   $0x14
80104735:	6a 00                	push   $0x0
80104737:	50                   	push   %eax
80104738:	e8 73 0a 00 00       	call   801051b0 <memset>
    t->context->eip = (uint) forkret;
8010473d:	8b 43 14             	mov    0x14(%ebx),%eax

    memset(t->tf, 0, sizeof(*t->tf));
80104740:	83 c4 0c             	add    $0xc,%esp
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
80104743:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)

    memset(t->tf, 0, sizeof(*t->tf));
8010474a:	6a 4c                	push   $0x4c
8010474c:	6a 00                	push   $0x0
8010474e:	ff 73 10             	pushl  0x10(%ebx)
80104751:	e8 5a 0a 00 00       	call   801051b0 <memset>
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104756:	8b 43 10             	mov    0x10(%ebx),%eax
80104759:	ba 1b 00 00 00       	mov    $0x1b,%edx
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010475e:	b9 23 00 00 00       	mov    $0x23,%ecx
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;

    memset(t->tf, 0, sizeof(*t->tf));
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104763:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104767:	8b 43 10             	mov    0x10(%ebx),%eax
8010476a:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    t->tf->es = t->tf->ds;
8010476e:	8b 43 10             	mov    0x10(%ebx),%eax
80104771:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104775:	66 89 50 28          	mov    %dx,0x28(%eax)
    t->tf->ss = t->tf->ds;
80104779:	8b 43 10             	mov    0x10(%ebx),%eax
8010477c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104780:	66 89 50 48          	mov    %dx,0x48(%eax)
    t->tf->eflags = FL_IF;
80104784:	8b 43 10             	mov    0x10(%ebx),%eax
    t->tf->esp = PGSIZE;
    t->tf->eip = (uint) start_func;  // beginning of run func
80104787:	8b 55 08             	mov    0x8(%ebp),%edx
    memset(t->tf, 0, sizeof(*t->tf));
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    t->tf->es = t->tf->ds;
    t->tf->ss = t->tf->ds;
    t->tf->eflags = FL_IF;
8010478a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    t->tf->esp = PGSIZE;
80104791:	8b 43 10             	mov    0x10(%ebx),%eax
80104794:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    t->tf->eip = (uint) start_func;  // beginning of run func
8010479b:	8b 43 10             	mov    0x10(%ebx),%eax
8010479e:	89 50 38             	mov    %edx,0x38(%eax)
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801047a1:	e8 0a 08 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
801047a6:	e8 55 f0 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801047ab:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801047b1:	e8 3a 08 00 00       	call   80104ff0 <popcli>
    t->tf->ss = t->tf->ds;
    t->tf->eflags = FL_IF;
    t->tf->esp = PGSIZE;
    t->tf->eip = (uint) start_func;  // beginning of run func

    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
801047b6:	8d 43 20             	lea    0x20(%ebx),%eax
801047b9:	83 c4 0c             	add    $0xc,%esp
801047bc:	83 c6 64             	add    $0x64,%esi
801047bf:	6a 10                	push   $0x10
801047c1:	56                   	push   %esi
801047c2:	50                   	push   %eax
801047c3:	e8 e8 0b 00 00       	call   801053b0 <safestrcpy>
    //t->cwd = namei("/");

    t->killed = 0;
801047c8:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    t->chan = 0;
801047cf:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    t->state = RUNNABLE;
801047d6:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    release(&ptable.lock);
801047dd:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
801047e4:	e8 77 09 00 00       	call   80105160 <release>
    return 0;
801047e9:	83 c4 10             	add    $0x10,%esp
}
801047ec:	8d 65 f8             	lea    -0x8(%ebp),%esp

    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
801047ef:	31 c0                	xor    %eax,%eax
}
801047f1:	5b                   	pop    %ebx
801047f2:	5e                   	pop    %esi
801047f3:	5d                   	pop    %ebp
801047f4:	c3                   	ret    
    t->state = EMBRYO;
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
801047f5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
801047fc:	e9 cd fe ff ff       	jmp    801046ce <kthread_create+0x5e>
80104801:	eb 0d                	jmp    80104810 <kthread_id>
80104803:	90                   	nop
80104804:	90                   	nop
80104805:	90                   	nop
80104806:	90                   	nop
80104807:	90                   	nop
80104808:	90                   	nop
80104809:	90                   	nop
8010480a:	90                   	nop
8010480b:	90                   	nop
8010480c:	90                   	nop
8010480d:	90                   	nop
8010480e:	90                   	nop
8010480f:	90                   	nop

80104810 <kthread_id>:
    release(&ptable.lock);
    return 0;
}

//this func haven't been used - i's implementation is in sysproc
int kthread_id() {
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 04             	sub    $0x4,%esp
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104817:	e8 94 07 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
8010481c:	e8 df ef ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104821:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104827:	e8 c4 07 00 00       	call   80104ff0 <popcli>
    return 0;
}

//this func haven't been used - i's implementation is in sysproc
int kthread_id() {
    return mythread()->tid;
8010482c:	8b 43 0c             	mov    0xc(%ebx),%eax
}
8010482f:	83 c4 04             	add    $0x4,%esp
80104832:	5b                   	pop    %ebx
80104833:	5d                   	pop    %ebp
80104834:	c3                   	ret    
80104835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <kthread_exit>:

void kthread_exit() {
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104847:	e8 64 07 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
8010484c:	e8 af ef ff ff       	call   80103800 <mycpu>
    p = c->proc;
80104851:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104857:	e8 94 07 00 00       	call   80104ff0 <popcli>
void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    ptable.lock.name = "KTHREADEXIT";
    acquire(&ptable.lock);
8010485c:	83 ec 0c             	sub    $0xc,%esp

void kthread_exit() {
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    ptable.lock.name = "KTHREADEXIT";
8010485f:	c7 05 24 4e 11 80 2f 	movl   $0x8010842f,0x80114e24
80104866:	84 10 80 
    acquire(&ptable.lock);
80104869:	68 20 4e 11 80       	push   $0x80114e20
8010486e:	e8 1d 08 00 00       	call   80105090 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104873:	8d 43 74             	lea    0x74(%ebx),%eax
80104876:	8d 8b b4 03 00 00    	lea    0x3b4(%ebx),%ecx
8010487c:	83 c4 10             	add    $0x10,%esp
8010487f:	31 db                	xor    %ebx,%ebx
80104881:	eb 11                	jmp    80104894 <kthread_exit+0x54>
80104883:	90                   	nop
80104884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (t->state == UNUSED || t->state == ZOMBIE)
80104888:	83 fa 05             	cmp    $0x5,%edx
8010488b:	74 0e                	je     8010489b <kthread_exit+0x5b>
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    ptable.lock.name = "KTHREADEXIT";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010488d:	83 c0 34             	add    $0x34,%eax
80104890:	39 c8                	cmp    %ecx,%eax
80104892:	73 11                	jae    801048a5 <kthread_exit+0x65>
        if (t->state == UNUSED || t->state == ZOMBIE)
80104894:	8b 50 08             	mov    0x8(%eax),%edx
80104897:	85 d2                	test   %edx,%edx
80104899:	75 ed                	jne    80104888 <kthread_exit+0x48>
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    ptable.lock.name = "KTHREADEXIT";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010489b:	83 c0 34             	add    $0x34,%eax
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
8010489e:	83 c3 01             	add    $0x1,%ebx
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    ptable.lock.name = "KTHREADEXIT";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801048a1:	39 c8                	cmp    %ecx,%eax
801048a3:	72 ef                	jb     80104894 <kthread_exit+0x54>
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
    }
    if (counter == (NTHREADS - 1)){ //all other threads aren't available -> close proc
801048a5:	83 fb 0f             	cmp    $0xf,%ebx
801048a8:	74 1d                	je     801048c7 <kthread_exit+0x87>
        release(&ptable.lock);
        exit();
    }
    else{   //there are other threads in the same proc - close just the specific thread
        cleanThread(t);
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	50                   	push   %eax
801048ae:	e8 ed ee ff ff       	call   801037a0 <cleanThread>
        release(&ptable.lock);
801048b3:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
801048ba:	e8 a1 08 00 00       	call   80105160 <release>
    }
}
801048bf:	83 c4 10             	add    $0x10,%esp
801048c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c5:	c9                   	leave  
801048c6:	c3                   	ret    
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t->state == UNUSED || t->state == ZOMBIE)
            counter++;
    }
    if (counter == (NTHREADS - 1)){ //all other threads aren't available -> close proc
        release(&ptable.lock);
801048c7:	83 ec 0c             	sub    $0xc,%esp
801048ca:	68 20 4e 11 80       	push   $0x80114e20
801048cf:	e8 8c 08 00 00       	call   80105160 <release>
        exit();
801048d4:	e8 e7 f7 ff ff       	call   801040c0 <exit>
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048e0 <kthread_join>:
        cleanThread(t);
        release(&ptable.lock);
    }
}

int kthread_join(int thread_id) {
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 10             	sub    $0x10,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
801048ea:	68 20 4e 11 80       	push   $0x80114e20
801048ef:	e8 9c 07 00 00       	call   80105090 <acquire>
801048f4:	b9 cc 4e 11 80       	mov    $0x80114ecc,%ecx
801048f9:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != UNUSED) {
801048fc:	8b 51 94             	mov    -0x6c(%ecx),%edx
801048ff:	89 c8                	mov    %ecx,%eax
80104901:	85 d2                	test   %edx,%edx
80104903:	74 1f                	je     80104924 <kthread_join+0x44>
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->tid == thread_id)
80104905:	39 59 0c             	cmp    %ebx,0xc(%ecx)
80104908:	8d 91 40 03 00 00    	lea    0x340(%ecx),%edx
8010490e:	75 0d                	jne    8010491d <kthread_join+0x3d>
80104910:	eb 3e                	jmp    80104950 <kthread_join+0x70>
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104918:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010491b:	74 33                	je     80104950 <kthread_join+0x70>
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != UNUSED) {
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010491d:	83 c0 34             	add    $0x34,%eax
80104920:	39 d0                	cmp    %edx,%eax
80104922:	72 f4                	jb     80104918 <kthread_join+0x38>
80104924:	81 c1 bc 03 00 00    	add    $0x3bc,%ecx

int kthread_join(int thread_id) {
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010492a:	81 f9 cc 3d 12 80    	cmp    $0x80123dcc,%ecx
80104930:	75 ca                	jne    801048fc <kthread_join+0x1c>
                    goto found2;
            }
        }
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
80104932:	83 ec 0c             	sub    $0xc,%esp
80104935:	68 20 4e 11 80       	push   $0x80114e20
8010493a:	e8 21 08 00 00       	call   80105160 <release>
    return -1;
8010493f:	83 c4 10             	add    $0x10,%esp
80104942:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    sleep(t,&ptable.lock);
    //TODO - not sure about release
    if(holding(&ptable.lock))
        release(&ptable.lock);
    return 0;
}
80104947:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010494a:	c9                   	leave  
8010494b:	c3                   	ret    
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
    return -1;
    found2:
    if (t->state == UNUSED || t->state == ZOMBIE){
80104950:	8b 50 08             	mov    0x8(%eax),%edx
80104953:	85 d2                	test   %edx,%edx
80104955:	74 db                	je     80104932 <kthread_join+0x52>
80104957:	83 fa 05             	cmp    $0x5,%edx
8010495a:	74 d6                	je     80104932 <kthread_join+0x52>
        release(&ptable.lock);
        return -1;
    }
    sleep(t,&ptable.lock);
8010495c:	83 ec 08             	sub    $0x8,%esp
8010495f:	68 20 4e 11 80       	push   $0x80114e20
80104964:	50                   	push   %eax
80104965:	e8 a6 f5 ff ff       	call   80103f10 <sleep>
    //TODO - not sure about release
    if(holding(&ptable.lock))
8010496a:	c7 04 24 20 4e 11 80 	movl   $0x80114e20,(%esp)
80104971:	e8 ea 06 00 00       	call   80105060 <holding>
80104976:	83 c4 10             	add    $0x10,%esp
80104979:	85 c0                	test   %eax,%eax
8010497b:	74 ca                	je     80104947 <kthread_join+0x67>
        release(&ptable.lock);
8010497d:	83 ec 0c             	sub    $0xc,%esp
80104980:	68 20 4e 11 80       	push   $0x80114e20
80104985:	e8 d6 07 00 00       	call   80105160 <release>
8010498a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010498d:	31 c0                	xor    %eax,%eax
}
8010498f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104992:	c9                   	leave  
80104993:	c3                   	ret    
80104994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010499a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049a0 <kthread_mutex_alloc>:



int
kthread_mutex_alloc()
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
801049a4:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx



int
kthread_mutex_alloc()
{
801049a9:	83 ec 10             	sub    $0x10,%esp
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);
801049ac:	68 e0 3e 11 80       	push   $0x80113ee0
801049b1:	e8 da 06 00 00       	call   80105090 <acquire>
801049b6:	83 c4 10             	add    $0x10,%esp
801049b9:	eb 10                	jmp    801049cb <kthread_mutex_alloc+0x2b>
801049bb:	90                   	nop
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
801049c0:	83 c3 3c             	add    $0x3c,%ebx
801049c3:	81 fb 18 4e 11 80    	cmp    $0x80114e18,%ebx
801049c9:	74 55                	je     80104a20 <kthread_mutex_alloc+0x80>
        if (!m->active)
801049cb:	8b 43 04             	mov    0x4(%ebx),%eax
801049ce:	85 c0                	test   %eax,%eax
801049d0:	75 ee                	jne    801049c0 <kthread_mutex_alloc+0x20>
    return -1;

    alloc_mutex:
    m->waitingCounter=0;
    m->active = 1;
    m->mid = mutexCounter++;
801049d2:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
801049d7:	83 ec 0c             	sub    $0xc,%esp

    release(&mtable.lock);
    return -1;

    alloc_mutex:
    m->waitingCounter=0;
801049da:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    m->active = 1;
    m->mid = mutexCounter++;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
801049e1:	68 e0 3e 11 80       	push   $0x80113ee0
    release(&mtable.lock);
    return -1;

    alloc_mutex:
    m->waitingCounter=0;
    m->active = 1;
801049e6:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
    m->mid = mutexCounter++;
    m->locked = 0;
801049ed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    m->thread = 0;
801049f3:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;

    alloc_mutex:
    m->waitingCounter=0;
    m->active = 1;
    m->mid = mutexCounter++;
801049fa:	8d 50 01             	lea    0x1(%eax),%edx
801049fd:	89 43 08             	mov    %eax,0x8(%ebx)
80104a00:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
80104a06:	e8 55 07 00 00       	call   80105160 <release>
    return m->mid;
80104a0b:	8b 43 08             	mov    0x8(%ebx),%eax
80104a0e:	83 c4 10             	add    $0x10,%esp


}
80104a11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a14:	c9                   	leave  
80104a15:	c3                   	ret    
80104a16:	8d 76 00             	lea    0x0(%esi),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if (!m->active)
            goto alloc_mutex;
    }

    release(&mtable.lock);
80104a20:	83 ec 0c             	sub    $0xc,%esp
80104a23:	68 e0 3e 11 80       	push   $0x80113ee0
80104a28:	e8 33 07 00 00       	call   80105160 <release>
    return -1;
80104a2d:	83 c4 10             	add    $0x10,%esp
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    m->thread = 0;
    release(&mtable.lock);
    return m->mid;


}
80104a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a38:	c9                   	leave  
80104a39:	c3                   	ret    
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a40 <kthread_mutex_dealloc>:


int
kthread_mutex_dealloc(int mutex_id){
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 10             	sub    $0x10,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);
80104a4a:	68 e0 3e 11 80       	push   $0x80113ee0
80104a4f:	e8 3c 06 00 00       	call   80105090 <acquire>
80104a54:	83 c4 10             	add    $0x10,%esp

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104a57:	b8 18 3f 11 80       	mov    $0x80113f18,%eax
80104a5c:	eb 0c                	jmp    80104a6a <kthread_mutex_dealloc+0x2a>
80104a5e:	66 90                	xchg   %ax,%ax
80104a60:	83 c0 3c             	add    $0x3c,%eax
80104a63:	3d 18 4e 11 80       	cmp    $0x80114e18,%eax
80104a68:	74 46                	je     80104ab0 <kthread_mutex_dealloc+0x70>
        if ( m->mid == mutex_id ) {
80104a6a:	39 58 08             	cmp    %ebx,0x8(%eax)
80104a6d:	75 f1                	jne    80104a60 <kthread_mutex_dealloc+0x20>
            if( m->locked || m->waitingCounter > 0){
80104a6f:	8b 08                	mov    (%eax),%ecx
80104a71:	85 c9                	test   %ecx,%ecx
80104a73:	75 3b                	jne    80104ab0 <kthread_mutex_dealloc+0x70>
80104a75:	8b 50 0c             	mov    0xc(%eax),%edx
80104a78:	85 d2                	test   %edx,%edx
80104a7a:	7f 34                	jg     80104ab0 <kthread_mutex_dealloc+0x70>
    dealloc_mutex:
    m->active = 0;
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
80104a7c:	83 ec 0c             	sub    $0xc,%esp

    release(&mtable.lock);
    return -1;

    dealloc_mutex:
    m->active = 0;
80104a7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    m->mid = -1;
80104a86:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
    m->locked = 0;
80104a8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    m->thread = 0;
80104a93:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    release(&mtable.lock);
80104a9a:	68 e0 3e 11 80       	push   $0x80113ee0
80104a9f:	e8 bc 06 00 00       	call   80105160 <release>
    return 0;
80104aa4:	83 c4 10             	add    $0x10,%esp
80104aa7:	31 c0                	xor    %eax,%eax
}
80104aa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aac:	c9                   	leave  
80104aad:	c3                   	ret    
80104aae:	66 90                	xchg   %ax,%ax
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if ( m->mid == mutex_id ) {
            if( m->locked || m->waitingCounter > 0){
                release(&mtable.lock);
80104ab0:	83 ec 0c             	sub    $0xc,%esp
80104ab3:	68 e0 3e 11 80       	push   $0x80113ee0
80104ab8:	e8 a3 06 00 00       	call   80105160 <release>
                return -1;
80104abd:	83 c4 10             	add    $0x10,%esp
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
    return 0;
}
80104ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac8:	c9                   	leave  
80104ac9:	c3                   	ret    
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <mgetcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
// TODO NOT OUR CODE MIGHT BE REMOVED
void
mgetcallerpcs(void *v, uint pcs[])
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
80104ad4:	8b 45 08             	mov    0x8(%ebp),%eax

// Record the current call stack in pcs[] by following the %ebp chain.
// TODO NOT OUR CODE MIGHT BE REMOVED
void
mgetcallerpcs(void *v, uint pcs[])
{
80104ad7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
80104ada:	8d 50 f8             	lea    -0x8(%eax),%edx
    for(i = 0; i < 10; i++){
80104add:	31 c0                	xor    %eax,%eax
80104adf:	90                   	nop
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ae0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104ae6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aec:	77 1a                	ja     80104b08 <mgetcallerpcs+0x38>
            break;
        pcs[i] = ebp[1];     // saved %eip
80104aee:	8b 5a 04             	mov    0x4(%edx),%ebx
80104af1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104af4:	83 c0 01             	add    $0x1,%eax
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
80104af7:	8b 12                	mov    (%edx),%edx
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104af9:	83 f8 0a             	cmp    $0xa,%eax
80104afc:	75 e2                	jne    80104ae0 <mgetcallerpcs+0x10>
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
        pcs[i] = 0;
}
80104afe:	5b                   	pop    %ebx
80104aff:	5d                   	pop    %ebp
80104b00:	c3                   	ret    
80104b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
        pcs[i] = 0;
80104b08:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
80104b0f:	83 c0 01             	add    $0x1,%eax
80104b12:	83 f8 0a             	cmp    $0xa,%eax
80104b15:	74 e7                	je     80104afe <mgetcallerpcs+0x2e>
        pcs[i] = 0;
80104b17:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
80104b1e:	83 c0 01             	add    $0x1,%eax
80104b21:	83 f8 0a             	cmp    $0xa,%eax
80104b24:	75 e2                	jne    80104b08 <mgetcallerpcs+0x38>
80104b26:	eb d6                	jmp    80104afe <mgetcallerpcs+0x2e>
80104b28:	90                   	nop
80104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b30 <mpushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
mpushcli(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
80104b37:	9c                   	pushf  
80104b38:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104b39:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if(mycpu()->ncli == 0)
80104b3a:	e8 c1 ec ff ff       	call   80103800 <mycpu>
80104b3f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b45:	85 c0                	test   %eax,%eax
80104b47:	75 11                	jne    80104b5a <mpushcli+0x2a>
        mycpu()->intena = eflags & FL_IF;
80104b49:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b4f:	e8 ac ec ff ff       	call   80103800 <mycpu>
80104b54:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
    mycpu()->ncli += 1;
80104b5a:	e8 a1 ec ff ff       	call   80103800 <mycpu>
80104b5f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b66:	83 c4 04             	add    $0x4,%esp
80104b69:	5b                   	pop    %ebx
80104b6a:	5d                   	pop    %ebp
80104b6b:	c3                   	ret    
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <mpopcli>:

void
mpopcli(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b76:	9c                   	pushf  
80104b77:	58                   	pop    %eax
    if(readeflags()&FL_IF)
80104b78:	f6 c4 02             	test   $0x2,%ah
80104b7b:	75 52                	jne    80104bcf <mpopcli+0x5f>
        panic("popcli - interruptible");
    if(--mycpu()->ncli < 0)
80104b7d:	e8 7e ec ff ff       	call   80103800 <mycpu>
80104b82:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104b88:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104b8b:	85 d2                	test   %edx,%edx
80104b8d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b93:	78 2d                	js     80104bc2 <mpopcli+0x52>
        panic("popcli");
    if(mycpu()->ncli == 0 && mycpu()->intena)
80104b95:	e8 66 ec ff ff       	call   80103800 <mycpu>
80104b9a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ba0:	85 d2                	test   %edx,%edx
80104ba2:	74 0c                	je     80104bb0 <mpopcli+0x40>
        sti();
}
80104ba4:	c9                   	leave  
80104ba5:	c3                   	ret    
80104ba6:	8d 76 00             	lea    0x0(%esi),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
    if(readeflags()&FL_IF)
        panic("popcli - interruptible");
    if(--mycpu()->ncli < 0)
        panic("popcli");
    if(mycpu()->ncli == 0 && mycpu()->intena)
80104bb0:	e8 4b ec ff ff       	call   80103800 <mycpu>
80104bb5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bbb:	85 c0                	test   %eax,%eax
80104bbd:	74 e5                	je     80104ba4 <mpopcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104bbf:	fb                   	sti    
        sti();
}
80104bc0:	c9                   	leave  
80104bc1:	c3                   	ret    
mpopcli(void)
{
    if(readeflags()&FL_IF)
        panic("popcli - interruptible");
    if(--mycpu()->ncli < 0)
        panic("popcli");
80104bc2:	83 ec 0c             	sub    $0xc,%esp
80104bc5:	68 52 84 10 80       	push   $0x80108452
80104bca:	e8 a1 b7 ff ff       	call   80100370 <panic>

void
mpopcli(void)
{
    if(readeflags()&FL_IF)
        panic("popcli - interruptible");
80104bcf:	83 ec 0c             	sub    $0xc,%esp
80104bd2:	68 3b 84 10 80       	push   $0x8010843b
80104bd7:	e8 94 b7 ff ff       	call   80100370 <panic>
80104bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104be0 <kthread_mutex_lock>:



int
kthread_mutex_lock(int mutex_id)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104be5:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx



int
kthread_mutex_lock(int mutex_id)
{
80104bea:	83 ec 10             	sub    $0x10,%esp
80104bed:	8b 75 08             	mov    0x8(%ebp),%esi
    struct kthread_mutex_t *m;

    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
80104bf0:	e8 3b ff ff ff       	call   80104b30 <mpushcli>
    acquire(&mtable.lock);
80104bf5:	83 ec 0c             	sub    $0xc,%esp
80104bf8:	68 e0 3e 11 80       	push   $0x80113ee0
80104bfd:	e8 8e 04 00 00       	call   80105090 <acquire>

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104c02:	c7 45 f4 18 3f 11 80 	movl   $0x80113f18,-0xc(%ebp)
80104c09:	83 c4 10             	add    $0x10,%esp
80104c0c:	31 c0                	xor    %eax,%eax
80104c0e:	66 90                	xchg   %ax,%ax
        if (m->active && m->mid == mutex_id) {
80104c10:	8b 53 04             	mov    0x4(%ebx),%edx
80104c13:	85 d2                	test   %edx,%edx
80104c15:	74 05                	je     80104c1c <kthread_mutex_lock+0x3c>
80104c17:	39 73 08             	cmp    %esi,0x8(%ebx)
80104c1a:	74 34                	je     80104c50 <kthread_mutex_lock+0x70>
    struct kthread_mutex_t *m;

    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104c1c:	83 c3 3c             	add    $0x3c,%ebx
80104c1f:	b8 01 00 00 00       	mov    $0x1,%eax
80104c24:	81 fb 18 4e 11 80    	cmp    $0x80114e18,%ebx
80104c2a:	75 e4                	jne    80104c10 <kthread_mutex_lock+0x30>
            }
            goto lock_mutex;
        }
    }

    release(&mtable.lock);
80104c2c:	83 ec 0c             	sub    $0xc,%esp
80104c2f:	68 e0 3e 11 80       	push   $0x80113ee0
80104c34:	e8 27 05 00 00       	call   80105160 <release>
    return -1;
80104c39:	83 c4 10             	add    $0x10,%esp
    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
}
80104c3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
            goto lock_mutex;
        }
    }

    release(&mtable.lock);
    return -1;
80104c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
}
80104c44:	5b                   	pop    %ebx
80104c45:	5e                   	pop    %esi
80104c46:	5d                   	pop    %ebp
80104c47:	c3                   	ret    
80104c48:	90                   	nop
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c50:	84 c0                	test   %al,%al
80104c52:	0f 85 c8 00 00 00    	jne    80104d20 <kthread_mutex_lock+0x140>
    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if (m->active && m->mid == mutex_id) {
            if (m->locked) {
80104c58:	8b 03                	mov    (%ebx),%eax
80104c5a:	85 c0                	test   %eax,%eax
80104c5c:	0f 85 9e 00 00 00    	jne    80104d00 <kthread_mutex_lock+0x120>
80104c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c65:	b9 01 00 00 00       	mov    $0x1,%ecx
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c70:	89 c8                	mov    %ecx,%eax
80104c72:	f0 87 02             	lock xchg %eax,(%edx)
    return -1;

    lock_mutex:

    // The xchg is atomic.
    while(xchg(&m->locked, 1) != 0)
80104c75:	85 c0                	test   %eax,%eax
80104c77:	75 f7                	jne    80104c70 <kthread_mutex_lock+0x90>
        ;

    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that the critical section's memory
    // references happen after the lock is acquired.
    __sync_synchronize();   // << TODO - not our line!!!
80104c79:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
80104c7e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104c81:	e8 2a 03 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80104c86:	e8 75 eb ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104c8b:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80104c91:	e8 5a 03 00 00       	call   80104ff0 <popcli>
    // references happen after the lock is acquired.
    __sync_synchronize();   // << TODO - not our line!!!

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
80104c96:	8d 4b 14             	lea    0x14(%ebx),%ecx
mgetcallerpcs(void *v, uint pcs[])
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
80104c99:	8d 55 ec             	lea    -0x14(%ebp),%edx
    for(i = 0; i < 10; i++){
80104c9c:	31 c0                	xor    %eax,%eax
    // past this point, to ensure that the critical section's memory
    // references happen after the lock is acquired.
    __sync_synchronize();   // << TODO - not our line!!!

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
80104c9e:	89 73 10             	mov    %esi,0x10(%ebx)
80104ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ca8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104cae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cb4:	77 2a                	ja     80104ce0 <kthread_mutex_lock+0x100>
            break;
        pcs[i] = ebp[1];     // saved %eip
80104cb6:	8b 5a 04             	mov    0x4(%edx),%ebx
80104cb9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104cbc:	83 c0 01             	add    $0x1,%eax
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
80104cbf:	8b 12                	mov    (%edx),%edx
{
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104cc1:	83 f8 0a             	cmp    $0xa,%eax
80104cc4:	75 e2                	jne    80104ca8 <kthread_mutex_lock+0xc8>
    __sync_synchronize();   // << TODO - not our line!!!

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
80104cc6:	83 ec 0c             	sub    $0xc,%esp
80104cc9:	68 e0 3e 11 80       	push   $0x80113ee0
80104cce:	e8 8d 04 00 00       	call   80105160 <release>
    return 0;
80104cd3:	83 c4 10             	add    $0x10,%esp
}
80104cd6:	8d 65 f8             	lea    -0x8(%ebp),%esp

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
80104cd9:	31 c0                	xor    %eax,%eax
}
80104cdb:	5b                   	pop    %ebx
80104cdc:	5e                   	pop    %esi
80104cdd:	5d                   	pop    %ebp
80104cde:	c3                   	ret    
80104cdf:	90                   	nop
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
        pcs[i] = 0;
80104ce0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
80104ce7:	83 c0 01             	add    $0x1,%eax
80104cea:	83 f8 0a             	cmp    $0xa,%eax
80104ced:	74 d7                	je     80104cc6 <kthread_mutex_lock+0xe6>
        pcs[i] = 0;
80104cef:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint*)ebp[0]; // saved %ebp
    }
    for(; i < 10; i++)
80104cf6:	83 c0 01             	add    $0x1,%eax
80104cf9:	83 f8 0a             	cmp    $0xa,%eax
80104cfc:	75 e2                	jne    80104ce0 <kthread_mutex_lock+0x100>
80104cfe:	eb c6                	jmp    80104cc6 <kthread_mutex_lock+0xe6>
    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if (m->active && m->mid == mutex_id) {
            if (m->locked) {
                m->waitingCounter++;
80104d00:	83 43 0c 01          	addl   $0x1,0xc(%ebx)
                sleep( m->thread , &mtable.lock );
80104d04:	83 ec 08             	sub    $0x8,%esp
80104d07:	68 e0 3e 11 80       	push   $0x80113ee0
80104d0c:	ff 73 10             	pushl  0x10(%ebx)
80104d0f:	e8 fc f1 ff ff       	call   80103f10 <sleep>
                m->waitingCounter--;
80104d14:	83 6b 0c 01          	subl   $0x1,0xc(%ebx)
80104d18:	83 c4 10             	add    $0x10,%esp
80104d1b:	e9 42 ff ff ff       	jmp    80104c62 <kthread_mutex_lock+0x82>
80104d20:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80104d23:	e9 30 ff ff ff       	jmp    80104c58 <kthread_mutex_lock+0x78>
80104d28:	90                   	nop
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d30 <kthread_mutex_unlock>:
}

// Release the lock.
int
kthread_mutex_unlock(int mutex_id)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104d36:	bb 18 3f 11 80       	mov    $0x80113f18,%ebx
}

// Release the lock.
int
kthread_mutex_unlock(int mutex_id)
{
80104d3b:	83 ec 28             	sub    $0x28,%esp
80104d3e:	8b 75 08             	mov    0x8(%ebp),%esi
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);
80104d41:	68 e0 3e 11 80       	push   $0x80113ee0
80104d46:	e8 45 03 00 00       	call   80105090 <acquire>
80104d4b:	83 c4 10             	add    $0x10,%esp
80104d4e:	eb 0f                	jmp    80104d5f <kthread_mutex_unlock+0x2f>

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104d50:	83 c3 3c             	add    $0x3c,%ebx
80104d53:	81 fb 18 4e 11 80    	cmp    $0x80114e18,%ebx
80104d59:	0f 84 81 00 00 00    	je     80104de0 <kthread_mutex_unlock+0xb0>
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
80104d5f:	8b 53 04             	mov    0x4(%ebx),%edx
80104d62:	85 d2                	test   %edx,%edx
80104d64:	74 ea                	je     80104d50 <kthread_mutex_unlock+0x20>
80104d66:	39 73 08             	cmp    %esi,0x8(%ebx)
80104d69:	75 e5                	jne    80104d50 <kthread_mutex_unlock+0x20>
80104d6b:	8b 03                	mov    (%ebx),%eax
80104d6d:	85 c0                	test   %eax,%eax
80104d6f:	74 df                	je     80104d50 <kthread_mutex_unlock+0x20>
80104d71:	8b 7b 10             	mov    0x10(%ebx),%edi
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104d74:	e8 37 02 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80104d79:	e8 82 ea ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104d7e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80104d87:	e8 64 02 00 00       	call   80104ff0 <popcli>
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
80104d8c:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80104d8f:	75 bf                	jne    80104d50 <kthread_mutex_unlock+0x20>
    release(&mtable.lock);
    return -1;

    unlock_mutex:

    m->pcs[0] = 0;
80104d91:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    m->thread = 0;
80104d98:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that all the stores in the critical
    // section are visible to other cores before the lock is released.
    // Both the C compiler and the hardware may re-order loads and
    // stores; __sync_synchronize() tells them both not to.
    __sync_synchronize();
80104d9f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    // Release the lock, equivalent to lk->locked = 0.
    // This code can't use a C assignment, since it might
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );
80104da4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
80104daa:	e8 01 02 00 00       	call   80104fb0 <pushcli>
    c = mycpu();
80104daf:	e8 4c ea ff ff       	call   80103800 <mycpu>
    t = c->currThread;
80104db4:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104dba:	e8 31 02 00 00       	call   80104ff0 <popcli>
    // Release the lock, equivalent to lk->locked = 0.
    // This code can't use a C assignment, since it might
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
80104dbf:	83 ec 0c             	sub    $0xc,%esp
80104dc2:	53                   	push   %ebx
80104dc3:	e8 48 f6 ff ff       	call   80104410 <wakeup>
    mpopcli();
80104dc8:	e8 a3 fd ff ff       	call   80104b70 <mpopcli>
    return 0;
80104dcd:	83 c4 10             	add    $0x10,%esp
}
80104dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
    mpopcli();
    return 0;
80104dd3:	31 c0                	xor    %eax,%eax
}
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5f                   	pop    %edi
80104dd8:	5d                   	pop    %ebp
80104dd9:	c3                   	ret    
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
                goto unlock_mutex;
    }

    release(&mtable.lock);
80104de0:	83 ec 0c             	sub    $0xc,%esp
80104de3:	68 e0 3e 11 80       	push   $0x80113ee0
80104de8:	e8 73 03 00 00       	call   80105160 <release>
    return -1;
80104ded:	83 c4 10             	add    $0x10,%esp
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
    mpopcli();
    return 0;
}
80104df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
                goto unlock_mutex;
    }

    release(&mtable.lock);
    return -1;
80104df3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
    mpopcli();
    return 0;
}
80104df8:	5b                   	pop    %ebx
80104df9:	5e                   	pop    %esi
80104dfa:	5f                   	pop    %edi
80104dfb:	5d                   	pop    %ebp
80104dfc:	c3                   	ret    
80104dfd:	66 90                	xchg   %ax,%ax
80104dff:	90                   	nop

80104e00 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	53                   	push   %ebx
80104e04:	83 ec 0c             	sub    $0xc,%esp
80104e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104e0a:	68 c4 84 10 80       	push   $0x801084c4
80104e0f:	8d 43 04             	lea    0x4(%ebx),%eax
80104e12:	50                   	push   %eax
80104e13:	e8 18 01 00 00       	call   80104f30 <initlock>
  lk->name = name;
80104e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104e1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104e21:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104e24:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80104e2b:	89 43 3c             	mov    %eax,0x3c(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104e2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e31:	c9                   	leave  
80104e32:	c3                   	ret    
80104e33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
80104e45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	8d 73 04             	lea    0x4(%ebx),%esi
80104e4e:	56                   	push   %esi
80104e4f:	e8 3c 02 00 00       	call   80105090 <acquire>
  while (lk->locked) {
80104e54:	8b 13                	mov    (%ebx),%edx
80104e56:	83 c4 10             	add    $0x10,%esp
80104e59:	85 d2                	test   %edx,%edx
80104e5b:	74 16                	je     80104e73 <acquiresleep+0x33>
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104e60:	83 ec 08             	sub    $0x8,%esp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
80104e65:	e8 a6 f0 ff ff       	call   80103f10 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104e6a:	8b 03                	mov    (%ebx),%eax
80104e6c:	83 c4 10             	add    $0x10,%esp
80104e6f:	85 c0                	test   %eax,%eax
80104e71:	75 ed                	jne    80104e60 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104e73:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104e79:	e8 22 ea ff ff       	call   801038a0 <myproc>
80104e7e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e81:	89 43 40             	mov    %eax,0x40(%ebx)
  release(&lk->lk);
80104e84:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104e87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e8a:	5b                   	pop    %ebx
80104e8b:	5e                   	pop    %esi
80104e8c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80104e8d:	e9 ce 02 00 00       	jmp    80105160 <release>
80104e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ea8:	83 ec 0c             	sub    $0xc,%esp
80104eab:	8d 73 04             	lea    0x4(%ebx),%esi
80104eae:	56                   	push   %esi
80104eaf:	e8 dc 01 00 00       	call   80105090 <acquire>
  lk->locked = 0;
80104eb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104eba:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  wakeup(lk);
80104ec1:	89 1c 24             	mov    %ebx,(%esp)
80104ec4:	e8 47 f5 ff ff       	call   80104410 <wakeup>
  release(&lk->lk);
80104ec9:	89 75 08             	mov    %esi,0x8(%ebp)
80104ecc:	83 c4 10             	add    $0x10,%esp
}
80104ecf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed2:	5b                   	pop    %ebx
80104ed3:	5e                   	pop    %esi
80104ed4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104ed5:	e9 86 02 00 00       	jmp    80105160 <release>
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ee0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	53                   	push   %ebx
80104ee6:	31 ff                	xor    %edi,%edi
80104ee8:	83 ec 18             	sub    $0x18,%esp
80104eeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104eee:	8d 73 04             	lea    0x4(%ebx),%esi
80104ef1:	56                   	push   %esi
80104ef2:	e8 99 01 00 00       	call   80105090 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104ef7:	8b 03                	mov    (%ebx),%eax
80104ef9:	83 c4 10             	add    $0x10,%esp
80104efc:	85 c0                	test   %eax,%eax
80104efe:	74 13                	je     80104f13 <holdingsleep+0x33>
80104f00:	8b 5b 40             	mov    0x40(%ebx),%ebx
80104f03:	e8 98 e9 ff ff       	call   801038a0 <myproc>
80104f08:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104f0b:	0f 94 c0             	sete   %al
80104f0e:	0f b6 c0             	movzbl %al,%eax
80104f11:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104f13:	83 ec 0c             	sub    $0xc,%esp
80104f16:	56                   	push   %esi
80104f17:	e8 44 02 00 00       	call   80105160 <release>
  return r;
}
80104f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f1f:	89 f8                	mov    %edi,%eax
80104f21:	5b                   	pop    %ebx
80104f22:	5e                   	pop    %esi
80104f23:	5f                   	pop    %edi
80104f24:	5d                   	pop    %ebp
80104f25:	c3                   	ret    
80104f26:	66 90                	xchg   %ax,%ax
80104f28:	66 90                	xchg   %ax,%ax
80104f2a:	66 90                	xchg   %ax,%ax
80104f2c:	66 90                	xchg   %ax,%ax
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f36:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104f39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104f3f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104f42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    
80104f4b:	90                   	nop
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104f54:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104f5a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104f5d:	31 c0                	xor    %eax,%eax
80104f5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f60:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104f66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f6c:	77 1a                	ja     80104f88 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f6e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104f71:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f74:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104f77:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f79:	83 f8 0a             	cmp    $0xa,%eax
80104f7c:	75 e2                	jne    80104f60 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104f7e:	5b                   	pop    %ebx
80104f7f:	5d                   	pop    %ebp
80104f80:	c3                   	ret    
80104f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104f88:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f8f:	83 c0 01             	add    $0x1,%eax
80104f92:	83 f8 0a             	cmp    $0xa,%eax
80104f95:	74 e7                	je     80104f7e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104f97:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f9e:	83 c0 01             	add    $0x1,%eax
80104fa1:	83 f8 0a             	cmp    $0xa,%eax
80104fa4:	75 e2                	jne    80104f88 <getcallerpcs+0x38>
80104fa6:	eb d6                	jmp    80104f7e <getcallerpcs+0x2e>
80104fa8:	90                   	nop
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	83 ec 04             	sub    $0x4,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104fb7:	9c                   	pushf  
80104fb8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104fb9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104fba:	e8 41 e8 ff ff       	call   80103800 <mycpu>
80104fbf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	75 11                	jne    80104fda <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104fc9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104fcf:	e8 2c e8 ff ff       	call   80103800 <mycpu>
80104fd4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104fda:	e8 21 e8 ff ff       	call   80103800 <mycpu>
80104fdf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104fe6:	83 c4 04             	add    $0x4,%esp
80104fe9:	5b                   	pop    %ebx
80104fea:	5d                   	pop    %ebp
80104feb:	c3                   	ret    
80104fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <popcli>:

void
popcli(void)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ff6:	9c                   	pushf  
80104ff7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ff8:	f6 c4 02             	test   $0x2,%ah
80104ffb:	75 52                	jne    8010504f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ffd:	e8 fe e7 ff ff       	call   80103800 <mycpu>
80105002:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80105008:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010500b:	85 d2                	test   %edx,%edx
8010500d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80105013:	78 2d                	js     80105042 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105015:	e8 e6 e7 ff ff       	call   80103800 <mycpu>
8010501a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105020:	85 d2                	test   %edx,%edx
80105022:	74 0c                	je     80105030 <popcli+0x40>
    sti();
}
80105024:	c9                   	leave  
80105025:	c3                   	ret    
80105026:	8d 76 00             	lea    0x0(%esi),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105030:	e8 cb e7 ff ff       	call   80103800 <mycpu>
80105035:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010503b:	85 c0                	test   %eax,%eax
8010503d:	74 e5                	je     80105024 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010503f:	fb                   	sti    
    sti();
}
80105040:	c9                   	leave  
80105041:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80105042:	83 ec 0c             	sub    $0xc,%esp
80105045:	68 52 84 10 80       	push   $0x80108452
8010504a:	e8 21 b3 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010504f:	83 ec 0c             	sub    $0xc,%esp
80105052:	68 3b 84 10 80       	push   $0x8010843b
80105057:	e8 14 b3 ff ff       	call   80100370 <panic>
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105060 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
80105065:	8b 75 08             	mov    0x8(%ebp),%esi
80105068:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010506a:	e8 41 ff ff ff       	call   80104fb0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010506f:	8b 06                	mov    (%esi),%eax
80105071:	85 c0                	test   %eax,%eax
80105073:	74 10                	je     80105085 <holding+0x25>
80105075:	8b 5e 0c             	mov    0xc(%esi),%ebx
80105078:	e8 83 e7 ff ff       	call   80103800 <mycpu>
8010507d:	39 c3                	cmp    %eax,%ebx
8010507f:	0f 94 c3             	sete   %bl
80105082:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105085:	e8 66 ff ff ff       	call   80104ff0 <popcli>
  return r;
}
8010508a:	89 d8                	mov    %ebx,%eax
8010508c:	5b                   	pop    %ebx
8010508d:	5e                   	pop    %esi
8010508e:	5d                   	pop    %ebp
8010508f:	c3                   	ret    

80105090 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	53                   	push   %ebx
80105094:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105097:	e8 14 ff ff ff       	call   80104fb0 <pushcli>
  if(holding(lk)) {
8010509c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010509f:	83 ec 0c             	sub    $0xc,%esp
801050a2:	53                   	push   %ebx
801050a3:	e8 b8 ff ff ff       	call   80105060 <holding>
801050a8:	83 c4 10             	add    $0x10,%esp
801050ab:	85 c0                	test   %eax,%eax
801050ad:	0f 85 7d 00 00 00    	jne    80105130 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801050b3:	ba 01 00 00 00       	mov    $0x1,%edx
801050b8:	eb 09                	jmp    801050c3 <acquire+0x33>
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050c3:	89 d0                	mov    %edx,%eax
801050c5:	f0 87 03             	lock xchg %eax,(%ebx)
    cprintf(" PANIC, %s \t %s \t %s", lk->name , lk->namee , mythread()->name  );
    panic("acquire");
  }
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801050c8:	85 c0                	test   %eax,%eax
801050ca:	75 f4                	jne    801050c0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801050cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801050d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050d4:	e8 27 e7 ff ff       	call   80103800 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801050d9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801050db:	8d 4b 10             	lea    0x10(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801050de:	89 43 0c             	mov    %eax,0xc(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050e1:	31 c0                	xor    %eax,%eax
801050e3:	90                   	nop
801050e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050e8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801050ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801050f4:	77 1a                	ja     80105110 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050f6:	8b 5a 04             	mov    0x4(%edx),%ebx
801050f9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050fc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801050ff:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105101:	83 f8 0a             	cmp    $0xa,%eax
80105104:	75 e2                	jne    801050e8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80105106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105109:	c9                   	leave  
8010510a:	c3                   	ret    
8010510b:	90                   	nop
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80105110:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105117:	83 c0 01             	add    $0x1,%eax
8010511a:	83 f8 0a             	cmp    $0xa,%eax
8010511d:	74 e7                	je     80105106 <acquire+0x76>
    pcs[i] = 0;
8010511f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105126:	83 c0 01             	add    $0x1,%eax
80105129:	83 f8 0a             	cmp    $0xa,%eax
8010512c:	75 e2                	jne    80105110 <acquire+0x80>
8010512e:	eb d6                	jmp    80105106 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk)) {
    cprintf(" PANIC, %s \t %s \t %s", lk->name , lk->namee , mythread()->name  );
80105130:	e8 9b e7 ff ff       	call   801038d0 <mythread>
80105135:	83 c0 20             	add    $0x20,%eax
80105138:	50                   	push   %eax
80105139:	ff 73 08             	pushl  0x8(%ebx)
8010513c:	ff 73 04             	pushl  0x4(%ebx)
8010513f:	68 cf 84 10 80       	push   $0x801084cf
80105144:	e8 17 b5 ff ff       	call   80100660 <cprintf>
    panic("acquire");
80105149:	c7 04 24 e4 84 10 80 	movl   $0x801084e4,(%esp)
80105150:	e8 1b b2 ff ff       	call   80100370 <panic>
80105155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	53                   	push   %ebx
80105164:	83 ec 10             	sub    $0x10,%esp
80105167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010516a:	53                   	push   %ebx
8010516b:	e8 f0 fe ff ff       	call   80105060 <holding>
80105170:	83 c4 10             	add    $0x10,%esp
80105173:	85 c0                	test   %eax,%eax
80105175:	74 22                	je     80105199 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80105177:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  lk->cpu = 0;
8010517e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105185:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010518a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80105190:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105193:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80105194:	e9 57 fe ff ff       	jmp    80104ff0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	68 ec 84 10 80       	push   $0x801084ec
801051a1:	e8 ca b1 ff ff       	call   80100370 <panic>
801051a6:	66 90                	xchg   %ax,%ax
801051a8:	66 90                	xchg   %ax,%ax
801051aa:	66 90                	xchg   %ax,%ax
801051ac:	66 90                	xchg   %ax,%ax
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	53                   	push   %ebx
801051b5:	8b 55 08             	mov    0x8(%ebp),%edx
801051b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801051bb:	f6 c2 03             	test   $0x3,%dl
801051be:	75 05                	jne    801051c5 <memset+0x15>
801051c0:	f6 c1 03             	test   $0x3,%cl
801051c3:	74 13                	je     801051d8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801051c5:	89 d7                	mov    %edx,%edi
801051c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ca:	fc                   	cld    
801051cb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801051cd:	5b                   	pop    %ebx
801051ce:	89 d0                	mov    %edx,%eax
801051d0:	5f                   	pop    %edi
801051d1:	5d                   	pop    %ebp
801051d2:	c3                   	ret    
801051d3:	90                   	nop
801051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801051d8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801051dc:	c1 e9 02             	shr    $0x2,%ecx
801051df:	89 fb                	mov    %edi,%ebx
801051e1:	89 f8                	mov    %edi,%eax
801051e3:	c1 e3 18             	shl    $0x18,%ebx
801051e6:	c1 e0 10             	shl    $0x10,%eax
801051e9:	09 d8                	or     %ebx,%eax
801051eb:	09 f8                	or     %edi,%eax
801051ed:	c1 e7 08             	shl    $0x8,%edi
801051f0:	09 f8                	or     %edi,%eax
801051f2:	89 d7                	mov    %edx,%edi
801051f4:	fc                   	cld    
801051f5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801051f7:	5b                   	pop    %ebx
801051f8:	89 d0                	mov    %edx,%eax
801051fa:	5f                   	pop    %edi
801051fb:	5d                   	pop    %ebp
801051fc:	c3                   	ret    
801051fd:	8d 76 00             	lea    0x0(%esi),%esi

80105200 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	8b 45 10             	mov    0x10(%ebp),%eax
80105208:	53                   	push   %ebx
80105209:	8b 75 0c             	mov    0xc(%ebp),%esi
8010520c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010520f:	85 c0                	test   %eax,%eax
80105211:	74 29                	je     8010523c <memcmp+0x3c>
    if(*s1 != *s2)
80105213:	0f b6 13             	movzbl (%ebx),%edx
80105216:	0f b6 0e             	movzbl (%esi),%ecx
80105219:	38 d1                	cmp    %dl,%cl
8010521b:	75 2b                	jne    80105248 <memcmp+0x48>
8010521d:	8d 78 ff             	lea    -0x1(%eax),%edi
80105220:	31 c0                	xor    %eax,%eax
80105222:	eb 14                	jmp    80105238 <memcmp+0x38>
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105228:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010522d:	83 c0 01             	add    $0x1,%eax
80105230:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105234:	38 ca                	cmp    %cl,%dl
80105236:	75 10                	jne    80105248 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105238:	39 f8                	cmp    %edi,%eax
8010523a:	75 ec                	jne    80105228 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010523c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010523d:	31 c0                	xor    %eax,%eax
}
8010523f:	5e                   	pop    %esi
80105240:	5f                   	pop    %edi
80105241:	5d                   	pop    %ebp
80105242:	c3                   	ret    
80105243:	90                   	nop
80105244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80105248:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010524b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010524c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010524e:	5e                   	pop    %esi
8010524f:	5f                   	pop    %edi
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret    
80105252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	56                   	push   %esi
80105264:	53                   	push   %ebx
80105265:	8b 45 08             	mov    0x8(%ebp),%eax
80105268:	8b 75 0c             	mov    0xc(%ebp),%esi
8010526b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010526e:	39 c6                	cmp    %eax,%esi
80105270:	73 2e                	jae    801052a0 <memmove+0x40>
80105272:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80105275:	39 c8                	cmp    %ecx,%eax
80105277:	73 27                	jae    801052a0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80105279:	85 db                	test   %ebx,%ebx
8010527b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010527e:	74 17                	je     80105297 <memmove+0x37>
      *--d = *--s;
80105280:	29 d9                	sub    %ebx,%ecx
80105282:	89 cb                	mov    %ecx,%ebx
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105288:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010528c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010528f:	83 ea 01             	sub    $0x1,%edx
80105292:	83 fa ff             	cmp    $0xffffffff,%edx
80105295:	75 f1                	jne    80105288 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105297:	5b                   	pop    %ebx
80105298:	5e                   	pop    %esi
80105299:	5d                   	pop    %ebp
8010529a:	c3                   	ret    
8010529b:	90                   	nop
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052a0:	31 d2                	xor    %edx,%edx
801052a2:	85 db                	test   %ebx,%ebx
801052a4:	74 f1                	je     80105297 <memmove+0x37>
801052a6:	8d 76 00             	lea    0x0(%esi),%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801052b0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801052b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801052b7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052ba:	39 d3                	cmp    %edx,%ebx
801052bc:	75 f2                	jne    801052b0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801052be:	5b                   	pop    %ebx
801052bf:	5e                   	pop    %esi
801052c0:	5d                   	pop    %ebp
801052c1:	c3                   	ret    
801052c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801052d3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801052d4:	eb 8a                	jmp    80105260 <memmove>
801052d6:	8d 76 00             	lea    0x0(%esi),%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801052e8:	53                   	push   %ebx
801052e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801052ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801052ef:	85 c9                	test   %ecx,%ecx
801052f1:	74 37                	je     8010532a <strncmp+0x4a>
801052f3:	0f b6 17             	movzbl (%edi),%edx
801052f6:	0f b6 1e             	movzbl (%esi),%ebx
801052f9:	84 d2                	test   %dl,%dl
801052fb:	74 3f                	je     8010533c <strncmp+0x5c>
801052fd:	38 d3                	cmp    %dl,%bl
801052ff:	75 3b                	jne    8010533c <strncmp+0x5c>
80105301:	8d 47 01             	lea    0x1(%edi),%eax
80105304:	01 cf                	add    %ecx,%edi
80105306:	eb 1b                	jmp    80105323 <strncmp+0x43>
80105308:	90                   	nop
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105310:	0f b6 10             	movzbl (%eax),%edx
80105313:	84 d2                	test   %dl,%dl
80105315:	74 21                	je     80105338 <strncmp+0x58>
80105317:	0f b6 19             	movzbl (%ecx),%ebx
8010531a:	83 c0 01             	add    $0x1,%eax
8010531d:	89 ce                	mov    %ecx,%esi
8010531f:	38 da                	cmp    %bl,%dl
80105321:	75 19                	jne    8010533c <strncmp+0x5c>
80105323:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80105325:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105328:	75 e6                	jne    80105310 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010532a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010532b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010532d:	5e                   	pop    %esi
8010532e:	5f                   	pop    %edi
8010532f:	5d                   	pop    %ebp
80105330:	c3                   	ret    
80105331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105338:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010533c:	0f b6 c2             	movzbl %dl,%eax
8010533f:	29 d8                	sub    %ebx,%eax
}
80105341:	5b                   	pop    %ebx
80105342:	5e                   	pop    %esi
80105343:	5f                   	pop    %edi
80105344:	5d                   	pop    %ebp
80105345:	c3                   	ret    
80105346:	8d 76 00             	lea    0x0(%esi),%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010539b:	85 db                	test   %ebx,%ebx
8010539d:	7f f1                	jg     80105390 <strncpy+0x40>
    *s++ = 0;
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
  return os;
}

int
strlen(const char *s)
{
801053f3:	89 e5                	mov    %esp,%ebp
801053f5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

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
8010542a:	e8 71 e4 ff ff       	call   801038a0 <myproc>

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
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
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
8010546a:	e8 31 e4 ff ff       	call   801038a0 <myproc>

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
80105485:	eb 29                	jmp    801054b0 <fetchstr+0x50>
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105490:	80 3a 00             	cmpb   $0x0,(%edx)
80105493:	74 1b                	je     801054b0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105495:	83 c2 01             	add    $0x1,%edx
80105498:	39 d0                	cmp    %edx,%eax
8010549a:	77 f4                	ja     80105490 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010549c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010549f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801054a4:	5b                   	pop    %ebx
801054a5:	5d                   	pop    %ebp
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801054b0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801054b3:	89 d0                	mov    %edx,%eax
801054b5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801054b7:	5b                   	pop    %ebx
801054b8:	5d                   	pop    %ebp
801054b9:	c3                   	ret    
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
801054c5:	e8 06 e4 ff ff       	call   801038d0 <mythread>
801054ca:	8b 40 10             	mov    0x10(%eax),%eax
801054cd:	8b 55 08             	mov    0x8(%ebp),%edx
801054d0:	8b 40 44             	mov    0x44(%eax),%eax
801054d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
801054d6:	e8 c5 e3 ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054db:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
801054dd:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054e0:	39 c6                	cmp    %eax,%esi
801054e2:	73 1c                	jae    80105500 <argint+0x40>
801054e4:	8d 53 08             	lea    0x8(%ebx),%edx
801054e7:	39 d0                	cmp    %edx,%eax
801054e9:	72 15                	jb     80105500 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801054eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ee:	8b 53 04             	mov    0x4(%ebx),%edx
801054f1:	89 10                	mov    %edx,(%eax)
  return 0;
801054f3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
}
801054f5:	5b                   	pop    %ebx
801054f6:	5e                   	pop    %esi
801054f7:	5d                   	pop    %ebp
801054f8:	c3                   	ret    
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105505:	eb ee                	jmp    801054f5 <argint+0x35>
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	53                   	push   %ebx
80105515:	83 ec 10             	sub    $0x10,%esp
80105518:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010551b:	e8 80 e3 ff ff       	call   801038a0 <myproc>
80105520:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105522:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105525:	83 ec 08             	sub    $0x8,%esp
80105528:	50                   	push   %eax
80105529:	ff 75 08             	pushl  0x8(%ebp)
8010552c:	e8 8f ff ff ff       	call   801054c0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105531:	c1 e8 1f             	shr    $0x1f,%eax
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	84 c0                	test   %al,%al
80105539:	75 2d                	jne    80105568 <argptr+0x58>
8010553b:	89 d8                	mov    %ebx,%eax
8010553d:	c1 e8 1f             	shr    $0x1f,%eax
80105540:	84 c0                	test   %al,%al
80105542:	75 24                	jne    80105568 <argptr+0x58>
80105544:	8b 16                	mov    (%esi),%edx
80105546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105549:	39 c2                	cmp    %eax,%edx
8010554b:	76 1b                	jbe    80105568 <argptr+0x58>
8010554d:	01 c3                	add    %eax,%ebx
8010554f:	39 da                	cmp    %ebx,%edx
80105551:	72 15                	jb     80105568 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80105553:	8b 55 0c             	mov    0xc(%ebp),%edx
80105556:	89 02                	mov    %eax,(%edx)
  return 0;
80105558:	31 c0                	xor    %eax,%eax
}
8010555a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010555d:	5b                   	pop    %ebx
8010555e:	5e                   	pop    %esi
8010555f:	5d                   	pop    %ebp
80105560:	c3                   	ret    
80105561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80105568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556d:	eb eb                	jmp    8010555a <argptr+0x4a>
8010556f:	90                   	nop

80105570 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105576:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105579:	50                   	push   %eax
8010557a:	ff 75 08             	pushl  0x8(%ebp)
8010557d:	e8 3e ff ff ff       	call   801054c0 <argint>
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	85 c0                	test   %eax,%eax
80105587:	78 17                	js     801055a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105589:	83 ec 08             	sub    $0x8,%esp
8010558c:	ff 75 0c             	pushl  0xc(%ebp)
8010558f:	ff 75 f4             	pushl  -0xc(%ebp)
80105592:	e8 c9 fe ff ff       	call   80105460 <fetchstr>
80105597:	83 c4 10             	add    $0x10,%esp
}
8010559a:	c9                   	leave  
8010559b:	c3                   	ret    
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <syscall>:
[SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
801055b5:	53                   	push   %ebx
801055b6:	83 ec 0c             	sub    $0xc,%esp
  int num;
  struct proc *curproc = myproc();
801055b9:	e8 e2 e2 ff ff       	call   801038a0 <myproc>
801055be:	89 c7                	mov    %eax,%edi
  struct thread *curthread = mythread();
801055c0:	e8 0b e3 ff ff       	call   801038d0 <mythread>

  num = curthread->tf->eax;
801055c5:	8b 70 10             	mov    0x10(%eax),%esi
void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
  struct thread *curthread = mythread();
801055c8:	89 c3                	mov    %eax,%ebx

  num = curthread->tf->eax;
801055ca:	8b 56 1c             	mov    0x1c(%esi),%edx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055cd:	8d 42 ff             	lea    -0x1(%edx),%eax
801055d0:	83 f8 18             	cmp    $0x18,%eax
801055d3:	77 1b                	ja     801055f0 <syscall+0x40>
801055d5:	8b 04 95 20 85 10 80 	mov    -0x7fef7ae0(,%edx,4),%eax
801055dc:	85 c0                	test   %eax,%eax
801055de:	74 10                	je     801055f0 <syscall+0x40>
    curthread->tf->eax = syscalls[num]();
801055e0:	ff d0                	call   *%eax
801055e2:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
  }
}
801055e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055e8:	5b                   	pop    %ebx
801055e9:	5e                   	pop    %esi
801055ea:	5f                   	pop    %edi
801055eb:	5d                   	pop    %ebp
801055ec:	c3                   	ret    
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
  num = curthread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curthread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801055f0:	8d 47 64             	lea    0x64(%edi),%eax

  num = curthread->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curthread->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801055f3:	52                   	push   %edx
801055f4:	50                   	push   %eax
801055f5:	ff 77 0c             	pushl  0xc(%edi)
801055f8:	68 f4 84 10 80       	push   $0x801084f4
801055fd:	e8 5e b0 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
80105602:	8b 43 10             	mov    0x10(%ebx),%eax
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010560f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105612:	5b                   	pop    %ebx
80105613:	5e                   	pop    %esi
80105614:	5f                   	pop    %edi
80105615:	5d                   	pop    %ebp
80105616:	c3                   	ret    
80105617:	66 90                	xchg   %ax,%ax
80105619:	66 90                	xchg   %ax,%ax
8010561b:	66 90                	xchg   %ax,%ax
8010561d:	66 90                	xchg   %ax,%ax
8010561f:	90                   	nop

80105620 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	57                   	push   %edi
80105624:	56                   	push   %esi
80105625:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105626:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105629:	83 ec 44             	sub    $0x44,%esp
8010562c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010562f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105632:	56                   	push   %esi
80105633:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105634:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105637:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010563a:	e8 b1 c8 ff ff       	call   80101ef0 <nameiparent>
8010563f:	83 c4 10             	add    $0x10,%esp
80105642:	85 c0                	test   %eax,%eax
80105644:	0f 84 f6 00 00 00    	je     80105740 <create+0x120>
    return 0;
  ilock(dp);
8010564a:	83 ec 0c             	sub    $0xc,%esp
8010564d:	89 c7                	mov    %eax,%edi
8010564f:	50                   	push   %eax
80105650:	e8 2b c0 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105655:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105658:	83 c4 0c             	add    $0xc,%esp
8010565b:	50                   	push   %eax
8010565c:	56                   	push   %esi
8010565d:	57                   	push   %edi
8010565e:	e8 4d c5 ff ff       	call   80101bb0 <dirlookup>
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	85 c0                	test   %eax,%eax
80105668:	89 c3                	mov    %eax,%ebx
8010566a:	74 54                	je     801056c0 <create+0xa0>
    iunlockput(dp);
8010566c:	83 ec 0c             	sub    $0xc,%esp
8010566f:	57                   	push   %edi
80105670:	e8 9b c2 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105675:	89 1c 24             	mov    %ebx,(%esp)
80105678:	e8 03 c0 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105685:	75 19                	jne    801056a0 <create+0x80>
80105687:	66 83 7b 54 02       	cmpw   $0x2,0x54(%ebx)
8010568c:	89 d8                	mov    %ebx,%eax
8010568e:	75 10                	jne    801056a0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105693:	5b                   	pop    %ebx
80105694:	5e                   	pop    %esi
80105695:	5f                   	pop    %edi
80105696:	5d                   	pop    %ebp
80105697:	c3                   	ret    
80105698:	90                   	nop
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	53                   	push   %ebx
801056a4:	e8 67 c2 ff ff       	call   80101910 <iunlockput>
    return 0;
801056a9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801056af:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056b1:	5b                   	pop    %ebx
801056b2:	5e                   	pop    %esi
801056b3:	5f                   	pop    %edi
801056b4:	5d                   	pop    %ebp
801056b5:	c3                   	ret    
801056b6:	8d 76 00             	lea    0x0(%esi),%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801056c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801056c4:	83 ec 08             	sub    $0x8,%esp
801056c7:	50                   	push   %eax
801056c8:	ff 37                	pushl  (%edi)
801056ca:	e8 41 be ff ff       	call   80101510 <ialloc>
801056cf:	83 c4 10             	add    $0x10,%esp
801056d2:	85 c0                	test   %eax,%eax
801056d4:	89 c3                	mov    %eax,%ebx
801056d6:	0f 84 cc 00 00 00    	je     801057a8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801056dc:	83 ec 0c             	sub    $0xc,%esp
801056df:	50                   	push   %eax
801056e0:	e8 9b bf ff ff       	call   80101680 <ilock>
  ip->major = major;
801056e5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801056e9:	66 89 43 56          	mov    %ax,0x56(%ebx)
  ip->minor = minor;
801056ed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801056f1:	66 89 43 58          	mov    %ax,0x58(%ebx)
  ip->nlink = 1;
801056f5:	b8 01 00 00 00       	mov    $0x1,%eax
801056fa:	66 89 43 5a          	mov    %ax,0x5a(%ebx)
  iupdate(ip);
801056fe:	89 1c 24             	mov    %ebx,(%esp)
80105701:	e8 ca be ff ff       	call   801015d0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010570e:	74 40                	je     80105750 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105710:	83 ec 04             	sub    $0x4,%esp
80105713:	ff 73 04             	pushl  0x4(%ebx)
80105716:	56                   	push   %esi
80105717:	57                   	push   %edi
80105718:	e8 f3 c6 ff ff       	call   80101e10 <dirlink>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	78 77                	js     8010579b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105724:	83 ec 0c             	sub    $0xc,%esp
80105727:	57                   	push   %edi
80105728:	e8 e3 c1 ff ff       	call   80101910 <iunlockput>

  return ip;
8010572d:	83 c4 10             	add    $0x10,%esp
}
80105730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105733:	89 d8                	mov    %ebx,%eax
}
80105735:	5b                   	pop    %ebx
80105736:	5e                   	pop    %esi
80105737:	5f                   	pop    %edi
80105738:	5d                   	pop    %ebp
80105739:	c3                   	ret    
8010573a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105740:	31 c0                	xor    %eax,%eax
80105742:	e9 49 ff ff ff       	jmp    80105690 <create+0x70>
80105747:	89 f6                	mov    %esi,%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105750:	66 83 47 5a 01       	addw   $0x1,0x5a(%edi)
    iupdate(dp);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	57                   	push   %edi
80105759:	e8 72 be ff ff       	call   801015d0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010575e:	83 c4 0c             	add    $0xc,%esp
80105761:	ff 73 04             	pushl  0x4(%ebx)
80105764:	68 a4 85 10 80       	push   $0x801085a4
80105769:	53                   	push   %ebx
8010576a:	e8 a1 c6 ff ff       	call   80101e10 <dirlink>
8010576f:	83 c4 10             	add    $0x10,%esp
80105772:	85 c0                	test   %eax,%eax
80105774:	78 18                	js     8010578e <create+0x16e>
80105776:	83 ec 04             	sub    $0x4,%esp
80105779:	ff 77 04             	pushl  0x4(%edi)
8010577c:	68 a3 85 10 80       	push   $0x801085a3
80105781:	53                   	push   %ebx
80105782:	e8 89 c6 ff ff       	call   80101e10 <dirlink>
80105787:	83 c4 10             	add    $0x10,%esp
8010578a:	85 c0                	test   %eax,%eax
8010578c:	79 82                	jns    80105710 <create+0xf0>
      panic("create dots");
8010578e:	83 ec 0c             	sub    $0xc,%esp
80105791:	68 97 85 10 80       	push   $0x80108597
80105796:	e8 d5 ab ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010579b:	83 ec 0c             	sub    $0xc,%esp
8010579e:	68 a6 85 10 80       	push   $0x801085a6
801057a3:	e8 c8 ab ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801057a8:	83 ec 0c             	sub    $0xc,%esp
801057ab:	68 88 85 10 80       	push   $0x80108588
801057b0:	e8 bb ab ff ff       	call   80100370 <panic>
801057b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057c0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	56                   	push   %esi
801057c4:	53                   	push   %ebx
801057c5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801057c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801057ca:	89 d3                	mov    %edx,%ebx
801057cc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801057cf:	50                   	push   %eax
801057d0:	6a 00                	push   $0x0
801057d2:	e8 e9 fc ff ff       	call   801054c0 <argint>
801057d7:	83 c4 10             	add    $0x10,%esp
801057da:	85 c0                	test   %eax,%eax
801057dc:	78 32                	js     80105810 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057de:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057e2:	77 2c                	ja     80105810 <argfd.constprop.0+0x50>
801057e4:	e8 b7 e0 ff ff       	call   801038a0 <myproc>
801057e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057ec:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
801057f0:	85 c0                	test   %eax,%eax
801057f2:	74 1c                	je     80105810 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801057f4:	85 f6                	test   %esi,%esi
801057f6:	74 02                	je     801057fa <argfd.constprop.0+0x3a>
    *pfd = fd;
801057f8:	89 16                	mov    %edx,(%esi)
  if(pf)
801057fa:	85 db                	test   %ebx,%ebx
801057fc:	74 22                	je     80105820 <argfd.constprop.0+0x60>
    *pf = f;
801057fe:	89 03                	mov    %eax,(%ebx)
  return 0;
80105800:	31 c0                	xor    %eax,%eax
}
80105802:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105805:	5b                   	pop    %ebx
80105806:	5e                   	pop    %esi
80105807:	5d                   	pop    %ebp
80105808:	c3                   	ret    
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105810:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105818:	5b                   	pop    %ebx
80105819:	5e                   	pop    %esi
8010581a:	5d                   	pop    %ebp
8010581b:	c3                   	ret    
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105820:	31 c0                	xor    %eax,%eax
80105822:	eb de                	jmp    80105802 <argfd.constprop.0+0x42>
80105824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010582a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105830 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105830:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105831:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105833:	89 e5                	mov    %esp,%ebp
80105835:	56                   	push   %esi
80105836:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105837:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010583a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010583d:	e8 7e ff ff ff       	call   801057c0 <argfd.constprop.0>
80105842:	85 c0                	test   %eax,%eax
80105844:	78 1a                	js     80105860 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105846:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105848:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010584b:	e8 50 e0 ff ff       	call   801038a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105850:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105854:	85 d2                	test   %edx,%edx
80105856:	74 18                	je     80105870 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105858:	83 c3 01             	add    $0x1,%ebx
8010585b:	83 fb 10             	cmp    $0x10,%ebx
8010585e:	75 f0                	jne    80105850 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105860:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105863:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105868:	5b                   	pop    %ebx
80105869:	5e                   	pop    %esi
8010586a:	5d                   	pop    %ebp
8010586b:	c3                   	ret    
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105870:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105874:	83 ec 0c             	sub    $0xc,%esp
80105877:	ff 75 f4             	pushl  -0xc(%ebp)
8010587a:	e8 71 b5 ff ff       	call   80100df0 <filedup>
  return fd;
8010587f:	83 c4 10             	add    $0x10,%esp
}
80105882:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105885:	89 d8                	mov    %ebx,%eax
}
80105887:	5b                   	pop    %ebx
80105888:	5e                   	pop    %esi
80105889:	5d                   	pop    %ebp
8010588a:	c3                   	ret    
8010588b:	90                   	nop
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_read>:

int
sys_read(void)
{
80105890:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105891:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105893:	89 e5                	mov    %esp,%ebp
80105895:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105898:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010589b:	e8 20 ff ff ff       	call   801057c0 <argfd.constprop.0>
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 4c                	js     801058f0 <sys_read+0x60>
801058a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a7:	83 ec 08             	sub    $0x8,%esp
801058aa:	50                   	push   %eax
801058ab:	6a 02                	push   $0x2
801058ad:	e8 0e fc ff ff       	call   801054c0 <argint>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 37                	js     801058f0 <sys_read+0x60>
801058b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058bc:	83 ec 04             	sub    $0x4,%esp
801058bf:	ff 75 f0             	pushl  -0x10(%ebp)
801058c2:	50                   	push   %eax
801058c3:	6a 01                	push   $0x1
801058c5:	e8 46 fc ff ff       	call   80105510 <argptr>
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	85 c0                	test   %eax,%eax
801058cf:	78 1f                	js     801058f0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801058d1:	83 ec 04             	sub    $0x4,%esp
801058d4:	ff 75 f0             	pushl  -0x10(%ebp)
801058d7:	ff 75 f4             	pushl  -0xc(%ebp)
801058da:	ff 75 ec             	pushl  -0x14(%ebp)
801058dd:	e8 7e b6 ff ff       	call   80100f60 <fileread>
801058e2:	83 c4 10             	add    $0x10,%esp
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <sys_write>:

int
sys_write(void)
{
80105900:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105901:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105903:	89 e5                	mov    %esp,%ebp
80105905:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105908:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010590b:	e8 b0 fe ff ff       	call   801057c0 <argfd.constprop.0>
80105910:	85 c0                	test   %eax,%eax
80105912:	78 4c                	js     80105960 <sys_write+0x60>
80105914:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105917:	83 ec 08             	sub    $0x8,%esp
8010591a:	50                   	push   %eax
8010591b:	6a 02                	push   $0x2
8010591d:	e8 9e fb ff ff       	call   801054c0 <argint>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	78 37                	js     80105960 <sys_write+0x60>
80105929:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010592c:	83 ec 04             	sub    $0x4,%esp
8010592f:	ff 75 f0             	pushl  -0x10(%ebp)
80105932:	50                   	push   %eax
80105933:	6a 01                	push   $0x1
80105935:	e8 d6 fb ff ff       	call   80105510 <argptr>
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	85 c0                	test   %eax,%eax
8010593f:	78 1f                	js     80105960 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105941:	83 ec 04             	sub    $0x4,%esp
80105944:	ff 75 f0             	pushl  -0x10(%ebp)
80105947:	ff 75 f4             	pushl  -0xc(%ebp)
8010594a:	ff 75 ec             	pushl  -0x14(%ebp)
8010594d:	e8 9e b6 ff ff       	call   80100ff0 <filewrite>
80105952:	83 c4 10             	add    $0x10,%esp
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <sys_close>:

int
sys_close(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105976:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105979:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010597c:	e8 3f fe ff ff       	call   801057c0 <argfd.constprop.0>
80105981:	85 c0                	test   %eax,%eax
80105983:	78 2b                	js     801059b0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105985:	e8 16 df ff ff       	call   801038a0 <myproc>
8010598a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010598d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105990:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
80105997:	00 
  fileclose(f);
80105998:	ff 75 f4             	pushl  -0xc(%ebp)
8010599b:	e8 a0 b4 ff ff       	call   80100e40 <fileclose>
  return 0;
801059a0:	83 c4 10             	add    $0x10,%esp
801059a3:	31 c0                	xor    %eax,%eax
}
801059a5:	c9                   	leave  
801059a6:	c3                   	ret    
801059a7:	89 f6                	mov    %esi,%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801059b5:	c9                   	leave  
801059b6:	c3                   	ret    
801059b7:	89 f6                	mov    %esi,%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_fstat>:

int
sys_fstat(void)
{
801059c0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059c1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801059c3:	89 e5                	mov    %esp,%ebp
801059c5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801059cb:	e8 f0 fd ff ff       	call   801057c0 <argfd.constprop.0>
801059d0:	85 c0                	test   %eax,%eax
801059d2:	78 2c                	js     80105a00 <sys_fstat+0x40>
801059d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d7:	83 ec 04             	sub    $0x4,%esp
801059da:	6a 14                	push   $0x14
801059dc:	50                   	push   %eax
801059dd:	6a 01                	push   $0x1
801059df:	e8 2c fb ff ff       	call   80105510 <argptr>
801059e4:	83 c4 10             	add    $0x10,%esp
801059e7:	85 c0                	test   %eax,%eax
801059e9:	78 15                	js     80105a00 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801059eb:	83 ec 08             	sub    $0x8,%esp
801059ee:	ff 75 f4             	pushl  -0xc(%ebp)
801059f1:	ff 75 f0             	pushl  -0x10(%ebp)
801059f4:	e8 17 b5 ff ff       	call   80100f10 <filestat>
801059f9:	83 c4 10             	add    $0x10,%esp
}
801059fc:	c9                   	leave  
801059fd:	c3                   	ret    
801059fe:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a16:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a19:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a1c:	50                   	push   %eax
80105a1d:	6a 00                	push   $0x0
80105a1f:	e8 4c fb ff ff       	call   80105570 <argstr>
80105a24:	83 c4 10             	add    $0x10,%esp
80105a27:	85 c0                	test   %eax,%eax
80105a29:	0f 88 fb 00 00 00    	js     80105b2a <sys_link+0x11a>
80105a2f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105a32:	83 ec 08             	sub    $0x8,%esp
80105a35:	50                   	push   %eax
80105a36:	6a 01                	push   $0x1
80105a38:	e8 33 fb ff ff       	call   80105570 <argstr>
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	85 c0                	test   %eax,%eax
80105a42:	0f 88 e2 00 00 00    	js     80105b2a <sys_link+0x11a>
    return -1;

  begin_op();
80105a48:	e8 13 d1 ff ff       	call   80102b60 <begin_op>
  if((ip = namei(old)) == 0){
80105a4d:	83 ec 0c             	sub    $0xc,%esp
80105a50:	ff 75 d4             	pushl  -0x2c(%ebp)
80105a53:	e8 78 c4 ff ff       	call   80101ed0 <namei>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	89 c3                	mov    %eax,%ebx
80105a5f:	0f 84 f3 00 00 00    	je     80105b58 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105a65:	83 ec 0c             	sub    $0xc,%esp
80105a68:	50                   	push   %eax
80105a69:	e8 12 bc ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105a76:	0f 84 c4 00 00 00    	je     80105b40 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105a7c:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105a81:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105a84:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105a87:	53                   	push   %ebx
80105a88:	e8 43 bb ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80105a8d:	89 1c 24             	mov    %ebx,(%esp)
80105a90:	e8 cb bc ff ff       	call   80101760 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105a95:	58                   	pop    %eax
80105a96:	5a                   	pop    %edx
80105a97:	57                   	push   %edi
80105a98:	ff 75 d0             	pushl  -0x30(%ebp)
80105a9b:	e8 50 c4 ff ff       	call   80101ef0 <nameiparent>
80105aa0:	83 c4 10             	add    $0x10,%esp
80105aa3:	85 c0                	test   %eax,%eax
80105aa5:	89 c6                	mov    %eax,%esi
80105aa7:	74 5b                	je     80105b04 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105aa9:	83 ec 0c             	sub    $0xc,%esp
80105aac:	50                   	push   %eax
80105aad:	e8 ce bb ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	8b 03                	mov    (%ebx),%eax
80105ab7:	39 06                	cmp    %eax,(%esi)
80105ab9:	75 3d                	jne    80105af8 <sys_link+0xe8>
80105abb:	83 ec 04             	sub    $0x4,%esp
80105abe:	ff 73 04             	pushl  0x4(%ebx)
80105ac1:	57                   	push   %edi
80105ac2:	56                   	push   %esi
80105ac3:	e8 48 c3 ff ff       	call   80101e10 <dirlink>
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	85 c0                	test   %eax,%eax
80105acd:	78 29                	js     80105af8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	56                   	push   %esi
80105ad3:	e8 38 be ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105ad8:	89 1c 24             	mov    %ebx,(%esp)
80105adb:	e8 d0 bc ff ff       	call   801017b0 <iput>

  end_op();
80105ae0:	e8 eb d0 ff ff       	call   80102bd0 <end_op>

  return 0;
80105ae5:	83 c4 10             	add    $0x10,%esp
80105ae8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aed:	5b                   	pop    %ebx
80105aee:	5e                   	pop    %esi
80105aef:	5f                   	pop    %edi
80105af0:	5d                   	pop    %ebp
80105af1:	c3                   	ret    
80105af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105af8:	83 ec 0c             	sub    $0xc,%esp
80105afb:	56                   	push   %esi
80105afc:	e8 0f be ff ff       	call   80101910 <iunlockput>
    goto bad;
80105b01:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105b04:	83 ec 0c             	sub    $0xc,%esp
80105b07:	53                   	push   %ebx
80105b08:	e8 73 bb ff ff       	call   80101680 <ilock>
  ip->nlink--;
80105b0d:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105b12:	89 1c 24             	mov    %ebx,(%esp)
80105b15:	e8 b6 ba ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105b1a:	89 1c 24             	mov    %ebx,(%esp)
80105b1d:	e8 ee bd ff ff       	call   80101910 <iunlockput>
  end_op();
80105b22:	e8 a9 d0 ff ff       	call   80102bd0 <end_op>
  return -1;
80105b27:	83 c4 10             	add    $0x10,%esp
}
80105b2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80105b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b32:	5b                   	pop    %ebx
80105b33:	5e                   	pop    %esi
80105b34:	5f                   	pop    %edi
80105b35:	5d                   	pop    %ebp
80105b36:	c3                   	ret    
80105b37:	89 f6                	mov    %esi,%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	53                   	push   %ebx
80105b44:	e8 c7 bd ff ff       	call   80101910 <iunlockput>
    end_op();
80105b49:	e8 82 d0 ff ff       	call   80102bd0 <end_op>
    return -1;
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b56:	eb 92                	jmp    80105aea <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105b58:	e8 73 d0 ff ff       	call   80102bd0 <end_op>
    return -1;
80105b5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b62:	eb 86                	jmp    80105aea <sys_link+0xda>
80105b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105b70 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b76:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105b79:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b7c:	50                   	push   %eax
80105b7d:	6a 00                	push   $0x0
80105b7f:	e8 ec f9 ff ff       	call   80105570 <argstr>
80105b84:	83 c4 10             	add    $0x10,%esp
80105b87:	85 c0                	test   %eax,%eax
80105b89:	0f 88 82 01 00 00    	js     80105d11 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105b8f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105b92:	e8 c9 cf ff ff       	call   80102b60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b97:	83 ec 08             	sub    $0x8,%esp
80105b9a:	53                   	push   %ebx
80105b9b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b9e:	e8 4d c3 ff ff       	call   80101ef0 <nameiparent>
80105ba3:	83 c4 10             	add    $0x10,%esp
80105ba6:	85 c0                	test   %eax,%eax
80105ba8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105bab:	0f 84 6a 01 00 00    	je     80105d1b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105bb1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105bb4:	83 ec 0c             	sub    $0xc,%esp
80105bb7:	56                   	push   %esi
80105bb8:	e8 c3 ba ff ff       	call   80101680 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bbd:	58                   	pop    %eax
80105bbe:	5a                   	pop    %edx
80105bbf:	68 a4 85 10 80       	push   $0x801085a4
80105bc4:	53                   	push   %ebx
80105bc5:	e8 c6 bf ff ff       	call   80101b90 <namecmp>
80105bca:	83 c4 10             	add    $0x10,%esp
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	0f 84 fc 00 00 00    	je     80105cd1 <sys_unlink+0x161>
80105bd5:	83 ec 08             	sub    $0x8,%esp
80105bd8:	68 a3 85 10 80       	push   $0x801085a3
80105bdd:	53                   	push   %ebx
80105bde:	e8 ad bf ff ff       	call   80101b90 <namecmp>
80105be3:	83 c4 10             	add    $0x10,%esp
80105be6:	85 c0                	test   %eax,%eax
80105be8:	0f 84 e3 00 00 00    	je     80105cd1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105bee:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105bf1:	83 ec 04             	sub    $0x4,%esp
80105bf4:	50                   	push   %eax
80105bf5:	53                   	push   %ebx
80105bf6:	56                   	push   %esi
80105bf7:	e8 b4 bf ff ff       	call   80101bb0 <dirlookup>
80105bfc:	83 c4 10             	add    $0x10,%esp
80105bff:	85 c0                	test   %eax,%eax
80105c01:	89 c3                	mov    %eax,%ebx
80105c03:	0f 84 c8 00 00 00    	je     80105cd1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105c09:	83 ec 0c             	sub    $0xc,%esp
80105c0c:	50                   	push   %eax
80105c0d:	e8 6e ba ff ff       	call   80101680 <ilock>

  if(ip->nlink < 1)
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
80105c1a:	0f 8e 24 01 00 00    	jle    80105d44 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c20:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105c25:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105c28:	74 66                	je     80105c90 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105c2a:	83 ec 04             	sub    $0x4,%esp
80105c2d:	6a 10                	push   $0x10
80105c2f:	6a 00                	push   $0x0
80105c31:	56                   	push   %esi
80105c32:	e8 79 f5 ff ff       	call   801051b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c37:	6a 10                	push   $0x10
80105c39:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c3c:	56                   	push   %esi
80105c3d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105c40:	e8 1b be ff ff       	call   80101a60 <writei>
80105c45:	83 c4 20             	add    $0x20,%esp
80105c48:	83 f8 10             	cmp    $0x10,%eax
80105c4b:	0f 85 e6 00 00 00    	jne    80105d37 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105c51:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105c56:	0f 84 9c 00 00 00    	je     80105cf8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105c5c:	83 ec 0c             	sub    $0xc,%esp
80105c5f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105c62:	e8 a9 bc ff ff       	call   80101910 <iunlockput>

  ip->nlink--;
80105c67:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
80105c6c:	89 1c 24             	mov    %ebx,(%esp)
80105c6f:	e8 5c b9 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105c74:	89 1c 24             	mov    %ebx,(%esp)
80105c77:	e8 94 bc ff ff       	call   80101910 <iunlockput>

  end_op();
80105c7c:	e8 4f cf ff ff       	call   80102bd0 <end_op>

  return 0;
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c89:	5b                   	pop    %ebx
80105c8a:	5e                   	pop    %esi
80105c8b:	5f                   	pop    %edi
80105c8c:	5d                   	pop    %ebp
80105c8d:	c3                   	ret    
80105c8e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c90:	83 7b 5c 20          	cmpl   $0x20,0x5c(%ebx)
80105c94:	76 94                	jbe    80105c2a <sys_unlink+0xba>
80105c96:	bf 20 00 00 00       	mov    $0x20,%edi
80105c9b:	eb 0f                	jmp    80105cac <sys_unlink+0x13c>
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
80105ca0:	83 c7 10             	add    $0x10,%edi
80105ca3:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80105ca6:	0f 83 7e ff ff ff    	jae    80105c2a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cac:	6a 10                	push   $0x10
80105cae:	57                   	push   %edi
80105caf:	56                   	push   %esi
80105cb0:	53                   	push   %ebx
80105cb1:	e8 aa bc ff ff       	call   80101960 <readi>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	83 f8 10             	cmp    $0x10,%eax
80105cbc:	75 6c                	jne    80105d2a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105cbe:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105cc3:	74 db                	je     80105ca0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105cc5:	83 ec 0c             	sub    $0xc,%esp
80105cc8:	53                   	push   %ebx
80105cc9:	e8 42 bc ff ff       	call   80101910 <iunlockput>
    goto bad;
80105cce:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105cd1:	83 ec 0c             	sub    $0xc,%esp
80105cd4:	ff 75 b4             	pushl  -0x4c(%ebp)
80105cd7:	e8 34 bc ff ff       	call   80101910 <iunlockput>
  end_op();
80105cdc:	e8 ef ce ff ff       	call   80102bd0 <end_op>
  return -1;
80105ce1:	83 c4 10             	add    $0x10,%esp
}
80105ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105ce7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cec:	5b                   	pop    %ebx
80105ced:	5e                   	pop    %esi
80105cee:	5f                   	pop    %edi
80105cef:	5d                   	pop    %ebp
80105cf0:	c3                   	ret    
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105cf8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105cfb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105cfe:	66 83 68 5a 01       	subw   $0x1,0x5a(%eax)
    iupdate(dp);
80105d03:	50                   	push   %eax
80105d04:	e8 c7 b8 ff ff       	call   801015d0 <iupdate>
80105d09:	83 c4 10             	add    $0x10,%esp
80105d0c:	e9 4b ff ff ff       	jmp    80105c5c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d16:	e9 6b ff ff ff       	jmp    80105c86 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105d1b:	e8 b0 ce ff ff       	call   80102bd0 <end_op>
    return -1;
80105d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d25:	e9 5c ff ff ff       	jmp    80105c86 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80105d2a:	83 ec 0c             	sub    $0xc,%esp
80105d2d:	68 c8 85 10 80       	push   $0x801085c8
80105d32:	e8 39 a6 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105d37:	83 ec 0c             	sub    $0xc,%esp
80105d3a:	68 da 85 10 80       	push   $0x801085da
80105d3f:	e8 2c a6 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105d44:	83 ec 0c             	sub    $0xc,%esp
80105d47:	68 b6 85 10 80       	push   $0x801085b6
80105d4c:	e8 1f a6 ff ff       	call   80100370 <panic>
80105d51:	eb 0d                	jmp    80105d60 <sys_open>
80105d53:	90                   	nop
80105d54:	90                   	nop
80105d55:	90                   	nop
80105d56:	90                   	nop
80105d57:	90                   	nop
80105d58:	90                   	nop
80105d59:	90                   	nop
80105d5a:	90                   	nop
80105d5b:	90                   	nop
80105d5c:	90                   	nop
80105d5d:	90                   	nop
80105d5e:	90                   	nop
80105d5f:	90                   	nop

80105d60 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	57                   	push   %edi
80105d64:	56                   	push   %esi
80105d65:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d66:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105d69:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d6c:	50                   	push   %eax
80105d6d:	6a 00                	push   $0x0
80105d6f:	e8 fc f7 ff ff       	call   80105570 <argstr>
80105d74:	83 c4 10             	add    $0x10,%esp
80105d77:	85 c0                	test   %eax,%eax
80105d79:	0f 88 9e 00 00 00    	js     80105e1d <sys_open+0xbd>
80105d7f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d82:	83 ec 08             	sub    $0x8,%esp
80105d85:	50                   	push   %eax
80105d86:	6a 01                	push   $0x1
80105d88:	e8 33 f7 ff ff       	call   801054c0 <argint>
80105d8d:	83 c4 10             	add    $0x10,%esp
80105d90:	85 c0                	test   %eax,%eax
80105d92:	0f 88 85 00 00 00    	js     80105e1d <sys_open+0xbd>
    return -1;

  begin_op();
80105d98:	e8 c3 cd ff ff       	call   80102b60 <begin_op>

  if(omode & O_CREATE){
80105d9d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105da1:	0f 85 89 00 00 00    	jne    80105e30 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105da7:	83 ec 0c             	sub    $0xc,%esp
80105daa:	ff 75 e0             	pushl  -0x20(%ebp)
80105dad:	e8 1e c1 ff ff       	call   80101ed0 <namei>
80105db2:	83 c4 10             	add    $0x10,%esp
80105db5:	85 c0                	test   %eax,%eax
80105db7:	89 c6                	mov    %eax,%esi
80105db9:	0f 84 8e 00 00 00    	je     80105e4d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
80105dbf:	83 ec 0c             	sub    $0xc,%esp
80105dc2:	50                   	push   %eax
80105dc3:	e8 b8 b8 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105dc8:	83 c4 10             	add    $0x10,%esp
80105dcb:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
80105dd0:	0f 84 d2 00 00 00    	je     80105ea8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105dd6:	e8 a5 af ff ff       	call   80100d80 <filealloc>
80105ddb:	85 c0                	test   %eax,%eax
80105ddd:	89 c7                	mov    %eax,%edi
80105ddf:	74 2b                	je     80105e0c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105de1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105de3:	e8 b8 da ff ff       	call   801038a0 <myproc>
80105de8:	90                   	nop
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105df0:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105df4:	85 d2                	test   %edx,%edx
80105df6:	74 68                	je     80105e60 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105df8:	83 c3 01             	add    $0x1,%ebx
80105dfb:	83 fb 10             	cmp    $0x10,%ebx
80105dfe:	75 f0                	jne    80105df0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	57                   	push   %edi
80105e04:	e8 37 b0 ff ff       	call   80100e40 <fileclose>
80105e09:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105e0c:	83 ec 0c             	sub    $0xc,%esp
80105e0f:	56                   	push   %esi
80105e10:	e8 fb ba ff ff       	call   80101910 <iunlockput>
    end_op();
80105e15:	e8 b6 cd ff ff       	call   80102bd0 <end_op>
    return -1;
80105e1a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105e25:	5b                   	pop    %ebx
80105e26:	5e                   	pop    %esi
80105e27:	5f                   	pop    %edi
80105e28:	5d                   	pop    %ebp
80105e29:	c3                   	ret    
80105e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e36:	31 c9                	xor    %ecx,%ecx
80105e38:	6a 00                	push   $0x0
80105e3a:	ba 02 00 00 00       	mov    $0x2,%edx
80105e3f:	e8 dc f7 ff ff       	call   80105620 <create>
    if(ip == 0){
80105e44:	83 c4 10             	add    $0x10,%esp
80105e47:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105e49:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105e4b:	75 89                	jne    80105dd6 <sys_open+0x76>
      end_op();
80105e4d:	e8 7e cd ff ff       	call   80102bd0 <end_op>
      return -1;
80105e52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e57:	eb 43                	jmp    80105e9c <sys_open+0x13c>
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e60:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105e63:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e67:	56                   	push   %esi
80105e68:	e8 f3 b8 ff ff       	call   80101760 <iunlock>
  end_op();
80105e6d:	e8 5e cd ff ff       	call   80102bd0 <end_op>

  f->type = FD_INODE;
80105e72:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e7b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105e7e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105e81:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e88:	89 d0                	mov    %edx,%eax
80105e8a:	83 e0 01             	and    $0x1,%eax
80105e8d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e90:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e93:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e96:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105e9a:	89 d8                	mov    %ebx,%eax
}
80105e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e9f:	5b                   	pop    %ebx
80105ea0:	5e                   	pop    %esi
80105ea1:	5f                   	pop    %edi
80105ea2:	5d                   	pop    %ebp
80105ea3:	c3                   	ret    
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ea8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105eab:	85 c9                	test   %ecx,%ecx
80105ead:	0f 84 23 ff ff ff    	je     80105dd6 <sys_open+0x76>
80105eb3:	e9 54 ff ff ff       	jmp    80105e0c <sys_open+0xac>
80105eb8:	90                   	nop
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ec0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ec6:	e8 95 cc ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105ecb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ece:	83 ec 08             	sub    $0x8,%esp
80105ed1:	50                   	push   %eax
80105ed2:	6a 00                	push   $0x0
80105ed4:	e8 97 f6 ff ff       	call   80105570 <argstr>
80105ed9:	83 c4 10             	add    $0x10,%esp
80105edc:	85 c0                	test   %eax,%eax
80105ede:	78 30                	js     80105f10 <sys_mkdir+0x50>
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee6:	31 c9                	xor    %ecx,%ecx
80105ee8:	6a 00                	push   $0x0
80105eea:	ba 01 00 00 00       	mov    $0x1,%edx
80105eef:	e8 2c f7 ff ff       	call   80105620 <create>
80105ef4:	83 c4 10             	add    $0x10,%esp
80105ef7:	85 c0                	test   %eax,%eax
80105ef9:	74 15                	je     80105f10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105efb:	83 ec 0c             	sub    $0xc,%esp
80105efe:	50                   	push   %eax
80105eff:	e8 0c ba ff ff       	call   80101910 <iunlockput>
  end_op();
80105f04:	e8 c7 cc ff ff       	call   80102bd0 <end_op>
  return 0;
80105f09:	83 c4 10             	add    $0x10,%esp
80105f0c:	31 c0                	xor    %eax,%eax
}
80105f0e:	c9                   	leave  
80105f0f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105f10:	e8 bb cc ff ff       	call   80102bd0 <end_op>
    return -1;
80105f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105f1a:	c9                   	leave  
80105f1b:	c3                   	ret    
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_mknod>:

int
sys_mknod(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f26:	e8 35 cc ff ff       	call   80102b60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f2e:	83 ec 08             	sub    $0x8,%esp
80105f31:	50                   	push   %eax
80105f32:	6a 00                	push   $0x0
80105f34:	e8 37 f6 ff ff       	call   80105570 <argstr>
80105f39:	83 c4 10             	add    $0x10,%esp
80105f3c:	85 c0                	test   %eax,%eax
80105f3e:	78 60                	js     80105fa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f43:	83 ec 08             	sub    $0x8,%esp
80105f46:	50                   	push   %eax
80105f47:	6a 01                	push   $0x1
80105f49:	e8 72 f5 ff ff       	call   801054c0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105f4e:	83 c4 10             	add    $0x10,%esp
80105f51:	85 c0                	test   %eax,%eax
80105f53:	78 4b                	js     80105fa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f58:	83 ec 08             	sub    $0x8,%esp
80105f5b:	50                   	push   %eax
80105f5c:	6a 02                	push   $0x2
80105f5e:	e8 5d f5 ff ff       	call   801054c0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105f63:	83 c4 10             	add    $0x10,%esp
80105f66:	85 c0                	test   %eax,%eax
80105f68:	78 36                	js     80105fa0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105f6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105f6e:	83 ec 0c             	sub    $0xc,%esp
80105f71:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105f75:	ba 03 00 00 00       	mov    $0x3,%edx
80105f7a:	50                   	push   %eax
80105f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f7e:	e8 9d f6 ff ff       	call   80105620 <create>
80105f83:	83 c4 10             	add    $0x10,%esp
80105f86:	85 c0                	test   %eax,%eax
80105f88:	74 16                	je     80105fa0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f8a:	83 ec 0c             	sub    $0xc,%esp
80105f8d:	50                   	push   %eax
80105f8e:	e8 7d b9 ff ff       	call   80101910 <iunlockput>
  end_op();
80105f93:	e8 38 cc ff ff       	call   80102bd0 <end_op>
  return 0;
80105f98:	83 c4 10             	add    $0x10,%esp
80105f9b:	31 c0                	xor    %eax,%eax
}
80105f9d:	c9                   	leave  
80105f9e:	c3                   	ret    
80105f9f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105fa0:	e8 2b cc ff ff       	call   80102bd0 <end_op>
    return -1;
80105fa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105faa:	c9                   	leave  
80105fab:	c3                   	ret    
80105fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fb0 <sys_chdir>:

int
sys_chdir(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	56                   	push   %esi
80105fb4:	53                   	push   %ebx
80105fb5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105fb8:	e8 e3 d8 ff ff       	call   801038a0 <myproc>
80105fbd:	89 c6                	mov    %eax,%esi
  //struct thread *curthread = mythread();
  
  begin_op();
80105fbf:	e8 9c cb ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105fc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc7:	83 ec 08             	sub    $0x8,%esp
80105fca:	50                   	push   %eax
80105fcb:	6a 00                	push   $0x0
80105fcd:	e8 9e f5 ff ff       	call   80105570 <argstr>
80105fd2:	83 c4 10             	add    $0x10,%esp
80105fd5:	85 c0                	test   %eax,%eax
80105fd7:	78 77                	js     80106050 <sys_chdir+0xa0>
80105fd9:	83 ec 0c             	sub    $0xc,%esp
80105fdc:	ff 75 f4             	pushl  -0xc(%ebp)
80105fdf:	e8 ec be ff ff       	call   80101ed0 <namei>
80105fe4:	83 c4 10             	add    $0x10,%esp
80105fe7:	85 c0                	test   %eax,%eax
80105fe9:	89 c3                	mov    %eax,%ebx
80105feb:	74 63                	je     80106050 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105fed:	83 ec 0c             	sub    $0xc,%esp
80105ff0:	50                   	push   %eax
80105ff1:	e8 8a b6 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105ff6:	83 c4 10             	add    $0x10,%esp
80105ff9:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105ffe:	75 30                	jne    80106030 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106000:	83 ec 0c             	sub    $0xc,%esp
80106003:	53                   	push   %ebx
80106004:	e8 57 b7 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80106009:	58                   	pop    %eax
8010600a:	ff 76 60             	pushl  0x60(%esi)
8010600d:	e8 9e b7 ff ff       	call   801017b0 <iput>
  end_op();
80106012:	e8 b9 cb ff ff       	call   80102bd0 <end_op>
  curproc->cwd = ip;
80106017:	89 5e 60             	mov    %ebx,0x60(%esi)
  return 0;
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	31 c0                	xor    %eax,%eax
}
8010601f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106022:	5b                   	pop    %ebx
80106023:	5e                   	pop    %esi
80106024:	5d                   	pop    %ebp
80106025:	c3                   	ret    
80106026:	8d 76 00             	lea    0x0(%esi),%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	53                   	push   %ebx
80106034:	e8 d7 b8 ff ff       	call   80101910 <iunlockput>
    end_op();
80106039:	e8 92 cb ff ff       	call   80102bd0 <end_op>
    return -1;
8010603e:	83 c4 10             	add    $0x10,%esp
80106041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106046:	eb d7                	jmp    8010601f <sys_chdir+0x6f>
80106048:	90                   	nop
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
  //struct thread *curthread = mythread();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80106050:	e8 7b cb ff ff       	call   80102bd0 <end_op>
    return -1;
80106055:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010605a:	eb c3                	jmp    8010601f <sys_chdir+0x6f>
8010605c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106060 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	57                   	push   %edi
80106064:	56                   	push   %esi
80106065:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106066:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010606c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106072:	50                   	push   %eax
80106073:	6a 00                	push   $0x0
80106075:	e8 f6 f4 ff ff       	call   80105570 <argstr>
8010607a:	83 c4 10             	add    $0x10,%esp
8010607d:	85 c0                	test   %eax,%eax
8010607f:	78 7f                	js     80106100 <sys_exec+0xa0>
80106081:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106087:	83 ec 08             	sub    $0x8,%esp
8010608a:	50                   	push   %eax
8010608b:	6a 01                	push   $0x1
8010608d:	e8 2e f4 ff ff       	call   801054c0 <argint>
80106092:	83 c4 10             	add    $0x10,%esp
80106095:	85 c0                	test   %eax,%eax
80106097:	78 67                	js     80106100 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106099:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010609f:	83 ec 04             	sub    $0x4,%esp
801060a2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801060a8:	68 80 00 00 00       	push   $0x80
801060ad:	6a 00                	push   $0x0
801060af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801060b5:	50                   	push   %eax
801060b6:	31 db                	xor    %ebx,%ebx
801060b8:	e8 f3 f0 ff ff       	call   801051b0 <memset>
801060bd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801060c0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801060c6:	83 ec 08             	sub    $0x8,%esp
801060c9:	57                   	push   %edi
801060ca:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801060cd:	50                   	push   %eax
801060ce:	e8 4d f3 ff ff       	call   80105420 <fetchint>
801060d3:	83 c4 10             	add    $0x10,%esp
801060d6:	85 c0                	test   %eax,%eax
801060d8:	78 26                	js     80106100 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801060da:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801060e0:	85 c0                	test   %eax,%eax
801060e2:	74 2c                	je     80106110 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801060e4:	83 ec 08             	sub    $0x8,%esp
801060e7:	56                   	push   %esi
801060e8:	50                   	push   %eax
801060e9:	e8 72 f3 ff ff       	call   80105460 <fetchstr>
801060ee:	83 c4 10             	add    $0x10,%esp
801060f1:	85 c0                	test   %eax,%eax
801060f3:	78 0b                	js     80106100 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801060f5:	83 c3 01             	add    $0x1,%ebx
801060f8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801060fb:	83 fb 20             	cmp    $0x20,%ebx
801060fe:	75 c0                	jne    801060c0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80106100:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80106103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80106108:	5b                   	pop    %ebx
80106109:	5e                   	pop    %esi
8010610a:	5f                   	pop    %edi
8010610b:	5d                   	pop    %ebp
8010610c:	c3                   	ret    
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106110:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106116:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80106119:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106120:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106124:	50                   	push   %eax
80106125:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010612b:	e8 c0 a8 ff ff       	call   801009f0 <exec>
80106130:	83 c4 10             	add    $0x10,%esp
}
80106133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106136:	5b                   	pop    %ebx
80106137:	5e                   	pop    %esi
80106138:	5f                   	pop    %edi
80106139:	5d                   	pop    %ebp
8010613a:	c3                   	ret    
8010613b:	90                   	nop
8010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106140 <sys_pipe>:

int
sys_pipe(void)
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	57                   	push   %edi
80106144:	56                   	push   %esi
80106145:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106146:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80106149:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010614c:	6a 08                	push   $0x8
8010614e:	50                   	push   %eax
8010614f:	6a 00                	push   $0x0
80106151:	e8 ba f3 ff ff       	call   80105510 <argptr>
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	85 c0                	test   %eax,%eax
8010615b:	78 4a                	js     801061a7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010615d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106160:	83 ec 08             	sub    $0x8,%esp
80106163:	50                   	push   %eax
80106164:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106167:	50                   	push   %eax
80106168:	e8 93 d0 ff ff       	call   80103200 <pipealloc>
8010616d:	83 c4 10             	add    $0x10,%esp
80106170:	85 c0                	test   %eax,%eax
80106172:	78 33                	js     801061a7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106174:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106176:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80106179:	e8 22 d7 ff ff       	call   801038a0 <myproc>
8010617e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80106180:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
80106184:	85 f6                	test   %esi,%esi
80106186:	74 30                	je     801061b8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80106188:	83 c3 01             	add    $0x1,%ebx
8010618b:	83 fb 10             	cmp    $0x10,%ebx
8010618e:	75 f0                	jne    80106180 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106190:	83 ec 0c             	sub    $0xc,%esp
80106193:	ff 75 e0             	pushl  -0x20(%ebp)
80106196:	e8 a5 ac ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
8010619b:	58                   	pop    %eax
8010619c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010619f:	e8 9c ac ff ff       	call   80100e40 <fileclose>
    return -1;
801061a4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801061a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801061aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801061af:	5b                   	pop    %ebx
801061b0:	5e                   	pop    %esi
801061b1:	5f                   	pop    %edi
801061b2:	5d                   	pop    %ebp
801061b3:	c3                   	ret    
801061b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801061b8:	8d 73 08             	lea    0x8(%ebx),%esi
801061bb:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801061c1:	e8 da d6 ff ff       	call   801038a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801061c6:	31 d2                	xor    %edx,%edx
801061c8:	90                   	nop
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801061d0:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
801061d4:	85 c9                	test   %ecx,%ecx
801061d6:	74 18                	je     801061f0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801061d8:	83 c2 01             	add    $0x1,%edx
801061db:	83 fa 10             	cmp    $0x10,%edx
801061de:	75 f0                	jne    801061d0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801061e0:	e8 bb d6 ff ff       	call   801038a0 <myproc>
801061e5:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
801061ec:	eb a2                	jmp    80106190 <sys_pipe+0x50>
801061ee:	66 90                	xchg   %ax,%ax
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801061f0:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801061f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061f7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801061f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061fc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801061ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80106202:	31 c0                	xor    %eax,%eax
}
80106204:	5b                   	pop    %ebx
80106205:	5e                   	pop    %esi
80106206:	5f                   	pop    %edi
80106207:	5d                   	pop    %ebp
80106208:	c3                   	ret    
80106209:	66 90                	xchg   %ax,%ax
8010620b:	66 90                	xchg   %ax,%ax
8010620d:	66 90                	xchg   %ax,%ax
8010620f:	90                   	nop

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
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106214:	e9 f7 d8 ff ff       	jmp    80103b10 <fork>
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_exit>:
}

int
sys_exit(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 08             	sub    $0x8,%esp
  exit();
80106226:	e8 95 de ff ff       	call   801040c0 <exit>
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
}

int
sys_wait(void)
{
  return wait();
80106234:	e9 57 e0 ff ff       	jmp    80104290 <wait>
80106239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106240 <sys_kill>:
}

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
8010624c:	e8 6f f2 ff ff       	call   801054c0 <argint>
80106251:	83 c4 10             	add    $0x10,%esp
80106254:	85 c0                	test   %eax,%eax
80106256:	78 18                	js     80106270 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106258:	83 ec 0c             	sub    $0xc,%esp
8010625b:	ff 75 f4             	pushl  -0xc(%ebp)
8010625e:	e8 4d e2 ff ff       	call   801044b0 <kill>
80106263:	83 c4 10             	add    $0x10,%esp
}
80106266:	c9                   	leave  
80106267:	c3                   	ret    
80106268:	90                   	nop
80106269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80106270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
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
80106286:	e8 15 d6 ff ff       	call   801038a0 <myproc>
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
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80106297:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010629a:	50                   	push   %eax
8010629b:	6a 00                	push   $0x0
8010629d:	e8 1e f2 ff ff       	call   801054c0 <argint>
801062a2:	83 c4 10             	add    $0x10,%esp
801062a5:	85 c0                	test   %eax,%eax
801062a7:	78 27                	js     801062d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801062a9:	e8 f2 d5 ff ff       	call   801038a0 <myproc>
  if(growproc(n) < 0)
801062ae:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801062b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801062b3:	ff 75 f4             	pushl  -0xc(%ebp)
801062b6:	e8 b5 d7 ff ff       	call   80103a70 <growproc>
801062bb:	83 c4 10             	add    $0x10,%esp
801062be:	85 c0                	test   %eax,%eax
801062c0:	78 0e                	js     801062d0 <sys_sbrk+0x40>
    return -1;
  return addr;
801062c2:	89 d8                	mov    %ebx,%eax
}
801062c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062c7:	c9                   	leave  
801062c8:	c3                   	ret    
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801062d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d5:	eb ed                	jmp    801062c4 <sys_sbrk+0x34>
801062d7:	89 f6                	mov    %esi,%esi
801062d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062e0 <sys_sleep>:
  return addr;
}

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
  return addr;
}

int
sys_sleep(void)
{
801062e7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801062ea:	50                   	push   %eax
801062eb:	6a 00                	push   $0x0
801062ed:	e8 ce f1 ff ff       	call   801054c0 <argint>
801062f2:	83 c4 10             	add    $0x10,%esp
801062f5:	85 c0                	test   %eax,%eax
801062f7:	0f 88 8a 00 00 00    	js     80106387 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801062fd:	83 ec 0c             	sub    $0xc,%esp
80106300:	68 60 3d 12 80       	push   $0x80123d60
80106305:	e8 86 ed ff ff       	call   80105090 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010630a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010630d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80106310:	8b 1d a0 45 12 80    	mov    0x801245a0,%ebx
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
80106323:	68 60 3d 12 80       	push   $0x80123d60
80106328:	68 a0 45 12 80       	push   $0x801245a0
8010632d:	e8 de db ff ff       	call   80103f10 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106332:	a1 a0 45 12 80       	mov    0x801245a0,%eax
80106337:	83 c4 10             	add    $0x10,%esp
8010633a:	29 d8                	sub    %ebx,%eax
8010633c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010633f:	73 2f                	jae    80106370 <sys_sleep+0x90>
    if(myproc()->killed){
80106341:	e8 5a d5 ff ff       	call   801038a0 <myproc>
80106346:	8b 40 1c             	mov    0x1c(%eax),%eax
80106349:	85 c0                	test   %eax,%eax
8010634b:	74 d3                	je     80106320 <sys_sleep+0x40>
      release(&tickslock);
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	68 60 3d 12 80       	push   $0x80123d60
80106355:	e8 06 ee ff ff       	call   80105160 <release>
      return -1;
8010635a:	83 c4 10             	add    $0x10,%esp
8010635d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
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
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106370:	83 ec 0c             	sub    $0xc,%esp
80106373:	68 60 3d 12 80       	push   $0x80123d60
80106378:	e8 e3 ed ff ff       	call   80105160 <release>
  return 0;
8010637d:	83 c4 10             	add    $0x10,%esp
80106380:	31 c0                	xor    %eax,%eax
}
80106382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106385:	c9                   	leave  
80106386:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80106387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010638c:	eb d4                	jmp    80106362 <sys_sleep+0x82>
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
80106397:	68 60 3d 12 80       	push   $0x80123d60
8010639c:	e8 ef ec ff ff       	call   80105090 <acquire>
  xticks = ticks;
801063a1:	8b 1d a0 45 12 80    	mov    0x801245a0,%ebx
  release(&tickslock);
801063a7:	c7 04 24 60 3d 12 80 	movl   $0x80123d60,(%esp)
801063ae:	e8 ad ed ff ff       	call   80105160 <release>
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
801063cc:	e8 3f f1 ff ff       	call   80105510 <argptr>
801063d1:	83 c4 10             	add    $0x10,%esp
801063d4:	85 c0                	test   %eax,%eax
801063d6:	78 28                	js     80106400 <sys_kthread_create+0x40>
        return -1;
    if(argptr(0, stack, sizeof(*stack)) < 0)
801063d8:	83 ec 04             	sub    $0x4,%esp
801063db:	6a 01                	push   $0x1
801063dd:	6a 00                	push   $0x0
801063df:	6a 00                	push   $0x0
801063e1:	e8 2a f1 ff ff       	call   80105510 <argptr>
801063e6:	83 c4 10             	add    $0x10,%esp
801063e9:	85 c0                	test   %eax,%eax
801063eb:	78 13                	js     80106400 <sys_kthread_create+0x40>
        return -1;
    return kthread_create(start_func, stack);
801063ed:	83 ec 08             	sub    $0x8,%esp
801063f0:	6a 00                	push   $0x0
801063f2:	6a 00                	push   $0x0
801063f4:	e8 77 e2 ff ff       	call   80104670 <kthread_create>
801063f9:	83 c4 10             	add    $0x10,%esp
}
801063fc:	c9                   	leave  
801063fd:	c3                   	ret    
801063fe:	66 90                	xchg   %ax,%ax
int
sys_kthread_create(void){
    void (*start_func)()=0;
    void* stack=0;
    if(argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
        return -1;
80106400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(argptr(0, stack, sizeof(*stack)) < 0)
        return -1;
    return kthread_create(start_func, stack);
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
80106416:	e8 b5 d4 ff ff       	call   801038d0 <mythread>
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
80106426:	e8 15 e4 ff ff       	call   80104840 <kthread_exit>
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
8010643c:	e8 7f f0 ff ff       	call   801054c0 <argint>
80106441:	83 c4 10             	add    $0x10,%esp
80106444:	85 c0                	test   %eax,%eax
80106446:	78 18                	js     80106460 <sys_kthread_join+0x30>
        return -1;
    return kthread_join(tid);
80106448:	83 ec 0c             	sub    $0xc,%esp
8010644b:	ff 75 f4             	pushl  -0xc(%ebp)
8010644e:	e8 8d e4 ff ff       	call   801048e0 <kthread_join>
80106453:	83 c4 10             	add    $0x10,%esp
}
80106456:	c9                   	leave  
80106457:	c3                   	ret    
80106458:	90                   	nop
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_kthread_join(void){
    int tid;
    if(argint(0, &tid) < 0)
        return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return kthread_join(tid);
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
80106477:	e8 e4 00 00 00       	call   80106560 <trap>
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
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106490:	31 c0                	xor    %eax,%eax
80106492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106498:	8b 14 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%edx
8010649f:	b9 08 00 00 00       	mov    $0x8,%ecx
801064a4:	c6 04 c5 a4 3d 12 80 	movb   $0x0,-0x7fedc25c(,%eax,8)
801064ab:	00 
801064ac:	66 89 0c c5 a2 3d 12 	mov    %cx,-0x7fedc25e(,%eax,8)
801064b3:	80 
801064b4:	c6 04 c5 a5 3d 12 80 	movb   $0x8e,-0x7fedc25b(,%eax,8)
801064bb:	8e 
801064bc:	66 89 14 c5 a0 3d 12 	mov    %dx,-0x7fedc260(,%eax,8)
801064c3:	80 
801064c4:	c1 ea 10             	shr    $0x10,%edx
801064c7:	66 89 14 c5 a6 3d 12 	mov    %dx,-0x7fedc25a(,%eax,8)
801064ce:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801064cf:	83 c0 01             	add    $0x1,%eax
801064d2:	3d 00 01 00 00       	cmp    $0x100,%eax
801064d7:	75 bf                	jne    80106498 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801064d9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064da:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801064df:	89 e5                	mov    %esp,%ebp
801064e1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064e4:	a1 10 b1 10 80       	mov    0x8010b110,%eax

  initlock(&tickslock, "time");
801064e9:	68 e9 85 10 80       	push   $0x801085e9
801064ee:	68 60 3d 12 80       	push   $0x80123d60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064f3:	66 89 15 a2 3f 12 80 	mov    %dx,0x80123fa2
801064fa:	c6 05 a4 3f 12 80 00 	movb   $0x0,0x80123fa4
80106501:	66 a3 a0 3f 12 80    	mov    %ax,0x80123fa0
80106507:	c1 e8 10             	shr    $0x10,%eax
8010650a:	c6 05 a5 3f 12 80 ef 	movb   $0xef,0x80123fa5
80106511:	66 a3 a6 3f 12 80    	mov    %ax,0x80123fa6

  initlock(&tickslock, "time");
80106517:	e8 14 ea ff ff       	call   80104f30 <initlock>
}
8010651c:	83 c4 10             	add    $0x10,%esp
8010651f:	c9                   	leave  
80106520:	c3                   	ret    
80106521:	eb 0d                	jmp    80106530 <idtinit>
80106523:	90                   	nop
80106524:	90                   	nop
80106525:	90                   	nop
80106526:	90                   	nop
80106527:	90                   	nop
80106528:	90                   	nop
80106529:	90                   	nop
8010652a:	90                   	nop
8010652b:	90                   	nop
8010652c:	90                   	nop
8010652d:	90                   	nop
8010652e:	90                   	nop
8010652f:	90                   	nop

80106530 <idtinit>:

void
idtinit(void)
{
80106530:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106531:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106536:	89 e5                	mov    %esp,%ebp
80106538:	83 ec 10             	sub    $0x10,%esp
8010653b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010653f:	b8 a0 3d 12 80       	mov    $0x80123da0,%eax
80106544:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106548:	c1 e8 10             	shr    $0x10,%eax
8010654b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010654f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106552:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106555:	c9                   	leave  
80106556:	c3                   	ret    
80106557:	89 f6                	mov    %esi,%esi
80106559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106560 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	57                   	push   %edi
80106564:	56                   	push   %esi
80106565:	53                   	push   %ebx
80106566:	83 ec 1c             	sub    $0x1c,%esp
80106569:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010656c:	8b 47 30             	mov    0x30(%edi),%eax
8010656f:	83 f8 40             	cmp    $0x40,%eax
80106572:	0f 84 88 01 00 00    	je     80106700 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106578:	83 e8 20             	sub    $0x20,%eax
8010657b:	83 f8 1f             	cmp    $0x1f,%eax
8010657e:	77 10                	ja     80106590 <trap+0x30>
80106580:	ff 24 85 90 86 10 80 	jmp    *-0x7fef7970(,%eax,4)
80106587:	89 f6                	mov    %esi,%esi
80106589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106590:	e8 0b d3 ff ff       	call   801038a0 <myproc>
80106595:	85 c0                	test   %eax,%eax
80106597:	0f 84 d7 01 00 00    	je     80106774 <trap+0x214>
8010659d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801065a1:	0f 84 cd 01 00 00    	je     80106774 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801065a7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065aa:	8b 57 38             	mov    0x38(%edi),%edx
801065ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801065b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801065b3:	e8 c8 d2 ff ff       	call   80103880 <cpuid>
801065b8:	8b 77 34             	mov    0x34(%edi),%esi
801065bb:	8b 5f 30             	mov    0x30(%edi),%ebx
801065be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801065c1:	e8 da d2 ff ff       	call   801038a0 <myproc>
801065c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801065c9:	e8 d2 d2 ff ff       	call   801038a0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801065d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801065d4:	51                   	push   %ecx
801065d5:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801065d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065d9:	ff 75 e4             	pushl  -0x1c(%ebp)
801065dc:	56                   	push   %esi
801065dd:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801065de:	83 c2 64             	add    $0x64,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065e1:	52                   	push   %edx
801065e2:	ff 70 0c             	pushl  0xc(%eax)
801065e5:	68 4c 86 10 80       	push   $0x8010864c
801065ea:	e8 71 a0 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801065ef:	83 c4 20             	add    $0x20,%esp
801065f2:	e8 a9 d2 ff ff       	call   801038a0 <myproc>
801065f7:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
801065fe:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106600:	e8 9b d2 ff ff       	call   801038a0 <myproc>
80106605:	85 c0                	test   %eax,%eax
80106607:	74 0c                	je     80106615 <trap+0xb5>
80106609:	e8 92 d2 ff ff       	call   801038a0 <myproc>
8010660e:	8b 50 1c             	mov    0x1c(%eax),%edx
80106611:	85 d2                	test   %edx,%edx
80106613:	75 4b                	jne    80106660 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106615:	e8 86 d2 ff ff       	call   801038a0 <myproc>
8010661a:	85 c0                	test   %eax,%eax
8010661c:	74 0b                	je     80106629 <trap+0xc9>
8010661e:	e8 7d d2 ff ff       	call   801038a0 <myproc>
80106623:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80106627:	74 4f                	je     80106678 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106629:	e8 72 d2 ff ff       	call   801038a0 <myproc>
8010662e:	85 c0                	test   %eax,%eax
80106630:	74 1d                	je     8010664f <trap+0xef>
80106632:	e8 69 d2 ff ff       	call   801038a0 <myproc>
80106637:	8b 40 1c             	mov    0x1c(%eax),%eax
8010663a:	85 c0                	test   %eax,%eax
8010663c:	74 11                	je     8010664f <trap+0xef>
8010663e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106642:	83 e0 03             	and    $0x3,%eax
80106645:	66 83 f8 03          	cmp    $0x3,%ax
80106649:	0f 84 da 00 00 00    	je     80106729 <trap+0x1c9>
    exit();
}
8010664f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106652:	5b                   	pop    %ebx
80106653:	5e                   	pop    %esi
80106654:	5f                   	pop    %edi
80106655:	5d                   	pop    %ebp
80106656:	c3                   	ret    
80106657:	89 f6                	mov    %esi,%esi
80106659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106660:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106664:	83 e0 03             	and    $0x3,%eax
80106667:	66 83 f8 03          	cmp    $0x3,%ax
8010666b:	75 a8                	jne    80106615 <trap+0xb5>
    exit();
8010666d:	e8 4e da ff ff       	call   801040c0 <exit>
80106672:	eb a1                	jmp    80106615 <trap+0xb5>
80106674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106678:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010667c:	75 ab                	jne    80106629 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010667e:	e8 3d d8 ff ff       	call   80103ec0 <yield>
80106683:	eb a4                	jmp    80106629 <trap+0xc9>
80106685:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106688:	e8 f3 d1 ff ff       	call   80103880 <cpuid>
8010668d:	85 c0                	test   %eax,%eax
8010668f:	0f 84 ab 00 00 00    	je     80106740 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106695:	e8 86 c0 ff ff       	call   80102720 <lapiceoi>
    break;
8010669a:	e9 61 ff ff ff       	jmp    80106600 <trap+0xa0>
8010669f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801066a0:	e8 3b bf ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
801066a5:	e8 76 c0 ff ff       	call   80102720 <lapiceoi>
    break;
801066aa:	e9 51 ff ff ff       	jmp    80106600 <trap+0xa0>
801066af:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801066b0:	e8 5b 02 00 00       	call   80106910 <uartintr>
    lapiceoi();
801066b5:	e8 66 c0 ff ff       	call   80102720 <lapiceoi>
    break;
801066ba:	e9 41 ff ff ff       	jmp    80106600 <trap+0xa0>
801066bf:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801066c0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801066c4:	8b 77 38             	mov    0x38(%edi),%esi
801066c7:	e8 b4 d1 ff ff       	call   80103880 <cpuid>
801066cc:	56                   	push   %esi
801066cd:	53                   	push   %ebx
801066ce:	50                   	push   %eax
801066cf:	68 f4 85 10 80       	push   $0x801085f4
801066d4:	e8 87 9f ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801066d9:	e8 42 c0 ff ff       	call   80102720 <lapiceoi>
    break;
801066de:	83 c4 10             	add    $0x10,%esp
801066e1:	e9 1a ff ff ff       	jmp    80106600 <trap+0xa0>
801066e6:	8d 76 00             	lea    0x0(%esi),%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801066f0:	e8 6b b9 ff ff       	call   80102060 <ideintr>
801066f5:	eb 9e                	jmp    80106695 <trap+0x135>
801066f7:	89 f6                	mov    %esi,%esi
801066f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106700:	e8 9b d1 ff ff       	call   801038a0 <myproc>
80106705:	8b 58 1c             	mov    0x1c(%eax),%ebx
80106708:	85 db                	test   %ebx,%ebx
8010670a:	75 2c                	jne    80106738 <trap+0x1d8>
      exit();
    mythread()->tf = tf;
8010670c:	e8 bf d1 ff ff       	call   801038d0 <mythread>
80106711:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
80106714:	e8 97 ee ff ff       	call   801055b0 <syscall>
    if(myproc()->killed)
80106719:	e8 82 d1 ff ff       	call   801038a0 <myproc>
8010671e:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106721:	85 c9                	test   %ecx,%ecx
80106723:	0f 84 26 ff ff ff    	je     8010664f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106729:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010672c:	5b                   	pop    %ebx
8010672d:	5e                   	pop    %esi
8010672e:	5f                   	pop    %edi
8010672f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    mythread()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106730:	e9 8b d9 ff ff       	jmp    801040c0 <exit>
80106735:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106738:	e8 83 d9 ff ff       	call   801040c0 <exit>
8010673d:	eb cd                	jmp    8010670c <trap+0x1ac>
8010673f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106740:	83 ec 0c             	sub    $0xc,%esp
80106743:	68 60 3d 12 80       	push   $0x80123d60
80106748:	e8 43 e9 ff ff       	call   80105090 <acquire>
      ticks++;
      wakeup(&ticks);
8010674d:	c7 04 24 a0 45 12 80 	movl   $0x801245a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106754:	83 05 a0 45 12 80 01 	addl   $0x1,0x801245a0
      wakeup(&ticks);
8010675b:	e8 b0 dc ff ff       	call   80104410 <wakeup>
      release(&tickslock);
80106760:	c7 04 24 60 3d 12 80 	movl   $0x80123d60,(%esp)
80106767:	e8 f4 e9 ff ff       	call   80105160 <release>
8010676c:	83 c4 10             	add    $0x10,%esp
8010676f:	e9 21 ff ff ff       	jmp    80106695 <trap+0x135>
80106774:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106777:	8b 5f 38             	mov    0x38(%edi),%ebx
8010677a:	e8 01 d1 ff ff       	call   80103880 <cpuid>
8010677f:	83 ec 0c             	sub    $0xc,%esp
80106782:	56                   	push   %esi
80106783:	53                   	push   %ebx
80106784:	50                   	push   %eax
80106785:	ff 77 30             	pushl  0x30(%edi)
80106788:	68 18 86 10 80       	push   $0x80108618
8010678d:	e8 ce 9e ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106792:	83 c4 14             	add    $0x14,%esp
80106795:	68 ee 85 10 80       	push   $0x801085ee
8010679a:	e8 d1 9b ff ff       	call   80100370 <panic>
8010679f:	90                   	nop

801067a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801067a0:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801067a5:	55                   	push   %ebp
801067a6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801067a8:	85 c0                	test   %eax,%eax
801067aa:	74 1c                	je     801067c8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067b1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801067b2:	a8 01                	test   $0x1,%al
801067b4:	74 12                	je     801067c8 <uartgetc+0x28>
801067b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067bb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801067bc:	0f b6 c0             	movzbl %al,%eax
}
801067bf:	5d                   	pop    %ebp
801067c0:	c3                   	ret    
801067c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801067c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801067cd:	5d                   	pop    %ebp
801067ce:	c3                   	ret    
801067cf:	90                   	nop

801067d0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	57                   	push   %edi
801067d4:	56                   	push   %esi
801067d5:	53                   	push   %ebx
801067d6:	89 c7                	mov    %eax,%edi
801067d8:	bb 80 00 00 00       	mov    $0x80,%ebx
801067dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801067e2:	83 ec 0c             	sub    $0xc,%esp
801067e5:	eb 1b                	jmp    80106802 <uartputc.part.0+0x32>
801067e7:	89 f6                	mov    %esi,%esi
801067e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801067f0:	83 ec 0c             	sub    $0xc,%esp
801067f3:	6a 0a                	push   $0xa
801067f5:	e8 46 bf ff ff       	call   80102740 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801067fa:	83 c4 10             	add    $0x10,%esp
801067fd:	83 eb 01             	sub    $0x1,%ebx
80106800:	74 07                	je     80106809 <uartputc.part.0+0x39>
80106802:	89 f2                	mov    %esi,%edx
80106804:	ec                   	in     (%dx),%al
80106805:	a8 20                	test   $0x20,%al
80106807:	74 e7                	je     801067f0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106809:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010680e:	89 f8                	mov    %edi,%eax
80106810:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106811:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106814:	5b                   	pop    %ebx
80106815:	5e                   	pop    %esi
80106816:	5f                   	pop    %edi
80106817:	5d                   	pop    %ebp
80106818:	c3                   	ret    
80106819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106820 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106820:	55                   	push   %ebp
80106821:	31 c9                	xor    %ecx,%ecx
80106823:	89 c8                	mov    %ecx,%eax
80106825:	89 e5                	mov    %esp,%ebp
80106827:	57                   	push   %edi
80106828:	56                   	push   %esi
80106829:	53                   	push   %ebx
8010682a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010682f:	89 da                	mov    %ebx,%edx
80106831:	83 ec 0c             	sub    $0xc,%esp
80106834:	ee                   	out    %al,(%dx)
80106835:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010683a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010683f:	89 fa                	mov    %edi,%edx
80106841:	ee                   	out    %al,(%dx)
80106842:	b8 0c 00 00 00       	mov    $0xc,%eax
80106847:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010684c:	ee                   	out    %al,(%dx)
8010684d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106852:	89 c8                	mov    %ecx,%eax
80106854:	89 f2                	mov    %esi,%edx
80106856:	ee                   	out    %al,(%dx)
80106857:	b8 03 00 00 00       	mov    $0x3,%eax
8010685c:	89 fa                	mov    %edi,%edx
8010685e:	ee                   	out    %al,(%dx)
8010685f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106864:	89 c8                	mov    %ecx,%eax
80106866:	ee                   	out    %al,(%dx)
80106867:	b8 01 00 00 00       	mov    $0x1,%eax
8010686c:	89 f2                	mov    %esi,%edx
8010686e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010686f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106874:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106875:	3c ff                	cmp    $0xff,%al
80106877:	74 5a                	je     801068d3 <uartinit+0xb3>
    return;
  uart = 1;
80106879:	c7 05 c4 b5 10 80 01 	movl   $0x1,0x8010b5c4
80106880:	00 00 00 
80106883:	89 da                	mov    %ebx,%edx
80106885:	ec                   	in     (%dx),%al
80106886:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010688b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010688c:	83 ec 08             	sub    $0x8,%esp
8010688f:	bb 10 87 10 80       	mov    $0x80108710,%ebx
80106894:	6a 00                	push   $0x0
80106896:	6a 04                	push   $0x4
80106898:	e8 13 ba ff ff       	call   801022b0 <ioapicenable>
8010689d:	83 c4 10             	add    $0x10,%esp
801068a0:	b8 78 00 00 00       	mov    $0x78,%eax
801068a5:	eb 13                	jmp    801068ba <uartinit+0x9a>
801068a7:	89 f6                	mov    %esi,%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068b0:	83 c3 01             	add    $0x1,%ebx
801068b3:	0f be 03             	movsbl (%ebx),%eax
801068b6:	84 c0                	test   %al,%al
801068b8:	74 19                	je     801068d3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
801068ba:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
801068c0:	85 d2                	test   %edx,%edx
801068c2:	74 ec                	je     801068b0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068c4:	83 c3 01             	add    $0x1,%ebx
801068c7:	e8 04 ff ff ff       	call   801067d0 <uartputc.part.0>
801068cc:	0f be 03             	movsbl (%ebx),%eax
801068cf:	84 c0                	test   %al,%al
801068d1:	75 e7                	jne    801068ba <uartinit+0x9a>
    uartputc(*p);
}
801068d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068d6:	5b                   	pop    %ebx
801068d7:	5e                   	pop    %esi
801068d8:	5f                   	pop    %edi
801068d9:	5d                   	pop    %ebp
801068da:	c3                   	ret    
801068db:	90                   	nop
801068dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068e0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801068e0:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801068e6:	55                   	push   %ebp
801068e7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
801068e9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801068eb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
801068ee:	74 10                	je     80106900 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801068f0:	5d                   	pop    %ebp
801068f1:	e9 da fe ff ff       	jmp    801067d0 <uartputc.part.0>
801068f6:	8d 76 00             	lea    0x0(%esi),%esi
801068f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106900:	5d                   	pop    %ebp
80106901:	c3                   	ret    
80106902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106910 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106916:	68 a0 67 10 80       	push   $0x801067a0
8010691b:	e8 d0 9e ff ff       	call   801007f0 <consoleintr>
}
80106920:	83 c4 10             	add    $0x10,%esp
80106923:	c9                   	leave  
80106924:	c3                   	ret    

80106925 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $0
80106927:	6a 00                	push   $0x0
  jmp alltraps
80106929:	e9 39 fb ff ff       	jmp    80106467 <alltraps>

8010692e <vector1>:
.globl vector1
vector1:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $1
80106930:	6a 01                	push   $0x1
  jmp alltraps
80106932:	e9 30 fb ff ff       	jmp    80106467 <alltraps>

80106937 <vector2>:
.globl vector2
vector2:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $2
80106939:	6a 02                	push   $0x2
  jmp alltraps
8010693b:	e9 27 fb ff ff       	jmp    80106467 <alltraps>

80106940 <vector3>:
.globl vector3
vector3:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $3
80106942:	6a 03                	push   $0x3
  jmp alltraps
80106944:	e9 1e fb ff ff       	jmp    80106467 <alltraps>

80106949 <vector4>:
.globl vector4
vector4:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $4
8010694b:	6a 04                	push   $0x4
  jmp alltraps
8010694d:	e9 15 fb ff ff       	jmp    80106467 <alltraps>

80106952 <vector5>:
.globl vector5
vector5:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $5
80106954:	6a 05                	push   $0x5
  jmp alltraps
80106956:	e9 0c fb ff ff       	jmp    80106467 <alltraps>

8010695b <vector6>:
.globl vector6
vector6:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $6
8010695d:	6a 06                	push   $0x6
  jmp alltraps
8010695f:	e9 03 fb ff ff       	jmp    80106467 <alltraps>

80106964 <vector7>:
.globl vector7
vector7:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $7
80106966:	6a 07                	push   $0x7
  jmp alltraps
80106968:	e9 fa fa ff ff       	jmp    80106467 <alltraps>

8010696d <vector8>:
.globl vector8
vector8:
  pushl $8
8010696d:	6a 08                	push   $0x8
  jmp alltraps
8010696f:	e9 f3 fa ff ff       	jmp    80106467 <alltraps>

80106974 <vector9>:
.globl vector9
vector9:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $9
80106976:	6a 09                	push   $0x9
  jmp alltraps
80106978:	e9 ea fa ff ff       	jmp    80106467 <alltraps>

8010697d <vector10>:
.globl vector10
vector10:
  pushl $10
8010697d:	6a 0a                	push   $0xa
  jmp alltraps
8010697f:	e9 e3 fa ff ff       	jmp    80106467 <alltraps>

80106984 <vector11>:
.globl vector11
vector11:
  pushl $11
80106984:	6a 0b                	push   $0xb
  jmp alltraps
80106986:	e9 dc fa ff ff       	jmp    80106467 <alltraps>

8010698b <vector12>:
.globl vector12
vector12:
  pushl $12
8010698b:	6a 0c                	push   $0xc
  jmp alltraps
8010698d:	e9 d5 fa ff ff       	jmp    80106467 <alltraps>

80106992 <vector13>:
.globl vector13
vector13:
  pushl $13
80106992:	6a 0d                	push   $0xd
  jmp alltraps
80106994:	e9 ce fa ff ff       	jmp    80106467 <alltraps>

80106999 <vector14>:
.globl vector14
vector14:
  pushl $14
80106999:	6a 0e                	push   $0xe
  jmp alltraps
8010699b:	e9 c7 fa ff ff       	jmp    80106467 <alltraps>

801069a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $15
801069a2:	6a 0f                	push   $0xf
  jmp alltraps
801069a4:	e9 be fa ff ff       	jmp    80106467 <alltraps>

801069a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $16
801069ab:	6a 10                	push   $0x10
  jmp alltraps
801069ad:	e9 b5 fa ff ff       	jmp    80106467 <alltraps>

801069b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801069b2:	6a 11                	push   $0x11
  jmp alltraps
801069b4:	e9 ae fa ff ff       	jmp    80106467 <alltraps>

801069b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $18
801069bb:	6a 12                	push   $0x12
  jmp alltraps
801069bd:	e9 a5 fa ff ff       	jmp    80106467 <alltraps>

801069c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $19
801069c4:	6a 13                	push   $0x13
  jmp alltraps
801069c6:	e9 9c fa ff ff       	jmp    80106467 <alltraps>

801069cb <vector20>:
.globl vector20
vector20:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $20
801069cd:	6a 14                	push   $0x14
  jmp alltraps
801069cf:	e9 93 fa ff ff       	jmp    80106467 <alltraps>

801069d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $21
801069d6:	6a 15                	push   $0x15
  jmp alltraps
801069d8:	e9 8a fa ff ff       	jmp    80106467 <alltraps>

801069dd <vector22>:
.globl vector22
vector22:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $22
801069df:	6a 16                	push   $0x16
  jmp alltraps
801069e1:	e9 81 fa ff ff       	jmp    80106467 <alltraps>

801069e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $23
801069e8:	6a 17                	push   $0x17
  jmp alltraps
801069ea:	e9 78 fa ff ff       	jmp    80106467 <alltraps>

801069ef <vector24>:
.globl vector24
vector24:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $24
801069f1:	6a 18                	push   $0x18
  jmp alltraps
801069f3:	e9 6f fa ff ff       	jmp    80106467 <alltraps>

801069f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $25
801069fa:	6a 19                	push   $0x19
  jmp alltraps
801069fc:	e9 66 fa ff ff       	jmp    80106467 <alltraps>

80106a01 <vector26>:
.globl vector26
vector26:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $26
80106a03:	6a 1a                	push   $0x1a
  jmp alltraps
80106a05:	e9 5d fa ff ff       	jmp    80106467 <alltraps>

80106a0a <vector27>:
.globl vector27
vector27:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $27
80106a0c:	6a 1b                	push   $0x1b
  jmp alltraps
80106a0e:	e9 54 fa ff ff       	jmp    80106467 <alltraps>

80106a13 <vector28>:
.globl vector28
vector28:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $28
80106a15:	6a 1c                	push   $0x1c
  jmp alltraps
80106a17:	e9 4b fa ff ff       	jmp    80106467 <alltraps>

80106a1c <vector29>:
.globl vector29
vector29:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $29
80106a1e:	6a 1d                	push   $0x1d
  jmp alltraps
80106a20:	e9 42 fa ff ff       	jmp    80106467 <alltraps>

80106a25 <vector30>:
.globl vector30
vector30:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $30
80106a27:	6a 1e                	push   $0x1e
  jmp alltraps
80106a29:	e9 39 fa ff ff       	jmp    80106467 <alltraps>

80106a2e <vector31>:
.globl vector31
vector31:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $31
80106a30:	6a 1f                	push   $0x1f
  jmp alltraps
80106a32:	e9 30 fa ff ff       	jmp    80106467 <alltraps>

80106a37 <vector32>:
.globl vector32
vector32:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $32
80106a39:	6a 20                	push   $0x20
  jmp alltraps
80106a3b:	e9 27 fa ff ff       	jmp    80106467 <alltraps>

80106a40 <vector33>:
.globl vector33
vector33:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $33
80106a42:	6a 21                	push   $0x21
  jmp alltraps
80106a44:	e9 1e fa ff ff       	jmp    80106467 <alltraps>

80106a49 <vector34>:
.globl vector34
vector34:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $34
80106a4b:	6a 22                	push   $0x22
  jmp alltraps
80106a4d:	e9 15 fa ff ff       	jmp    80106467 <alltraps>

80106a52 <vector35>:
.globl vector35
vector35:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $35
80106a54:	6a 23                	push   $0x23
  jmp alltraps
80106a56:	e9 0c fa ff ff       	jmp    80106467 <alltraps>

80106a5b <vector36>:
.globl vector36
vector36:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $36
80106a5d:	6a 24                	push   $0x24
  jmp alltraps
80106a5f:	e9 03 fa ff ff       	jmp    80106467 <alltraps>

80106a64 <vector37>:
.globl vector37
vector37:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $37
80106a66:	6a 25                	push   $0x25
  jmp alltraps
80106a68:	e9 fa f9 ff ff       	jmp    80106467 <alltraps>

80106a6d <vector38>:
.globl vector38
vector38:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $38
80106a6f:	6a 26                	push   $0x26
  jmp alltraps
80106a71:	e9 f1 f9 ff ff       	jmp    80106467 <alltraps>

80106a76 <vector39>:
.globl vector39
vector39:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $39
80106a78:	6a 27                	push   $0x27
  jmp alltraps
80106a7a:	e9 e8 f9 ff ff       	jmp    80106467 <alltraps>

80106a7f <vector40>:
.globl vector40
vector40:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $40
80106a81:	6a 28                	push   $0x28
  jmp alltraps
80106a83:	e9 df f9 ff ff       	jmp    80106467 <alltraps>

80106a88 <vector41>:
.globl vector41
vector41:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $41
80106a8a:	6a 29                	push   $0x29
  jmp alltraps
80106a8c:	e9 d6 f9 ff ff       	jmp    80106467 <alltraps>

80106a91 <vector42>:
.globl vector42
vector42:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $42
80106a93:	6a 2a                	push   $0x2a
  jmp alltraps
80106a95:	e9 cd f9 ff ff       	jmp    80106467 <alltraps>

80106a9a <vector43>:
.globl vector43
vector43:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $43
80106a9c:	6a 2b                	push   $0x2b
  jmp alltraps
80106a9e:	e9 c4 f9 ff ff       	jmp    80106467 <alltraps>

80106aa3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $44
80106aa5:	6a 2c                	push   $0x2c
  jmp alltraps
80106aa7:	e9 bb f9 ff ff       	jmp    80106467 <alltraps>

80106aac <vector45>:
.globl vector45
vector45:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $45
80106aae:	6a 2d                	push   $0x2d
  jmp alltraps
80106ab0:	e9 b2 f9 ff ff       	jmp    80106467 <alltraps>

80106ab5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $46
80106ab7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ab9:	e9 a9 f9 ff ff       	jmp    80106467 <alltraps>

80106abe <vector47>:
.globl vector47
vector47:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $47
80106ac0:	6a 2f                	push   $0x2f
  jmp alltraps
80106ac2:	e9 a0 f9 ff ff       	jmp    80106467 <alltraps>

80106ac7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $48
80106ac9:	6a 30                	push   $0x30
  jmp alltraps
80106acb:	e9 97 f9 ff ff       	jmp    80106467 <alltraps>

80106ad0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $49
80106ad2:	6a 31                	push   $0x31
  jmp alltraps
80106ad4:	e9 8e f9 ff ff       	jmp    80106467 <alltraps>

80106ad9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $50
80106adb:	6a 32                	push   $0x32
  jmp alltraps
80106add:	e9 85 f9 ff ff       	jmp    80106467 <alltraps>

80106ae2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $51
80106ae4:	6a 33                	push   $0x33
  jmp alltraps
80106ae6:	e9 7c f9 ff ff       	jmp    80106467 <alltraps>

80106aeb <vector52>:
.globl vector52
vector52:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $52
80106aed:	6a 34                	push   $0x34
  jmp alltraps
80106aef:	e9 73 f9 ff ff       	jmp    80106467 <alltraps>

80106af4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $53
80106af6:	6a 35                	push   $0x35
  jmp alltraps
80106af8:	e9 6a f9 ff ff       	jmp    80106467 <alltraps>

80106afd <vector54>:
.globl vector54
vector54:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $54
80106aff:	6a 36                	push   $0x36
  jmp alltraps
80106b01:	e9 61 f9 ff ff       	jmp    80106467 <alltraps>

80106b06 <vector55>:
.globl vector55
vector55:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $55
80106b08:	6a 37                	push   $0x37
  jmp alltraps
80106b0a:	e9 58 f9 ff ff       	jmp    80106467 <alltraps>

80106b0f <vector56>:
.globl vector56
vector56:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $56
80106b11:	6a 38                	push   $0x38
  jmp alltraps
80106b13:	e9 4f f9 ff ff       	jmp    80106467 <alltraps>

80106b18 <vector57>:
.globl vector57
vector57:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $57
80106b1a:	6a 39                	push   $0x39
  jmp alltraps
80106b1c:	e9 46 f9 ff ff       	jmp    80106467 <alltraps>

80106b21 <vector58>:
.globl vector58
vector58:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $58
80106b23:	6a 3a                	push   $0x3a
  jmp alltraps
80106b25:	e9 3d f9 ff ff       	jmp    80106467 <alltraps>

80106b2a <vector59>:
.globl vector59
vector59:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $59
80106b2c:	6a 3b                	push   $0x3b
  jmp alltraps
80106b2e:	e9 34 f9 ff ff       	jmp    80106467 <alltraps>

80106b33 <vector60>:
.globl vector60
vector60:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $60
80106b35:	6a 3c                	push   $0x3c
  jmp alltraps
80106b37:	e9 2b f9 ff ff       	jmp    80106467 <alltraps>

80106b3c <vector61>:
.globl vector61
vector61:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $61
80106b3e:	6a 3d                	push   $0x3d
  jmp alltraps
80106b40:	e9 22 f9 ff ff       	jmp    80106467 <alltraps>

80106b45 <vector62>:
.globl vector62
vector62:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $62
80106b47:	6a 3e                	push   $0x3e
  jmp alltraps
80106b49:	e9 19 f9 ff ff       	jmp    80106467 <alltraps>

80106b4e <vector63>:
.globl vector63
vector63:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $63
80106b50:	6a 3f                	push   $0x3f
  jmp alltraps
80106b52:	e9 10 f9 ff ff       	jmp    80106467 <alltraps>

80106b57 <vector64>:
.globl vector64
vector64:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $64
80106b59:	6a 40                	push   $0x40
  jmp alltraps
80106b5b:	e9 07 f9 ff ff       	jmp    80106467 <alltraps>

80106b60 <vector65>:
.globl vector65
vector65:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $65
80106b62:	6a 41                	push   $0x41
  jmp alltraps
80106b64:	e9 fe f8 ff ff       	jmp    80106467 <alltraps>

80106b69 <vector66>:
.globl vector66
vector66:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $66
80106b6b:	6a 42                	push   $0x42
  jmp alltraps
80106b6d:	e9 f5 f8 ff ff       	jmp    80106467 <alltraps>

80106b72 <vector67>:
.globl vector67
vector67:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $67
80106b74:	6a 43                	push   $0x43
  jmp alltraps
80106b76:	e9 ec f8 ff ff       	jmp    80106467 <alltraps>

80106b7b <vector68>:
.globl vector68
vector68:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $68
80106b7d:	6a 44                	push   $0x44
  jmp alltraps
80106b7f:	e9 e3 f8 ff ff       	jmp    80106467 <alltraps>

80106b84 <vector69>:
.globl vector69
vector69:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $69
80106b86:	6a 45                	push   $0x45
  jmp alltraps
80106b88:	e9 da f8 ff ff       	jmp    80106467 <alltraps>

80106b8d <vector70>:
.globl vector70
vector70:
  pushl $0
80106b8d:	6a 00                	push   $0x0
  pushl $70
80106b8f:	6a 46                	push   $0x46
  jmp alltraps
80106b91:	e9 d1 f8 ff ff       	jmp    80106467 <alltraps>

80106b96 <vector71>:
.globl vector71
vector71:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $71
80106b98:	6a 47                	push   $0x47
  jmp alltraps
80106b9a:	e9 c8 f8 ff ff       	jmp    80106467 <alltraps>

80106b9f <vector72>:
.globl vector72
vector72:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $72
80106ba1:	6a 48                	push   $0x48
  jmp alltraps
80106ba3:	e9 bf f8 ff ff       	jmp    80106467 <alltraps>

80106ba8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $73
80106baa:	6a 49                	push   $0x49
  jmp alltraps
80106bac:	e9 b6 f8 ff ff       	jmp    80106467 <alltraps>

80106bb1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106bb1:	6a 00                	push   $0x0
  pushl $74
80106bb3:	6a 4a                	push   $0x4a
  jmp alltraps
80106bb5:	e9 ad f8 ff ff       	jmp    80106467 <alltraps>

80106bba <vector75>:
.globl vector75
vector75:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $75
80106bbc:	6a 4b                	push   $0x4b
  jmp alltraps
80106bbe:	e9 a4 f8 ff ff       	jmp    80106467 <alltraps>

80106bc3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $76
80106bc5:	6a 4c                	push   $0x4c
  jmp alltraps
80106bc7:	e9 9b f8 ff ff       	jmp    80106467 <alltraps>

80106bcc <vector77>:
.globl vector77
vector77:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $77
80106bce:	6a 4d                	push   $0x4d
  jmp alltraps
80106bd0:	e9 92 f8 ff ff       	jmp    80106467 <alltraps>

80106bd5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $78
80106bd7:	6a 4e                	push   $0x4e
  jmp alltraps
80106bd9:	e9 89 f8 ff ff       	jmp    80106467 <alltraps>

80106bde <vector79>:
.globl vector79
vector79:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $79
80106be0:	6a 4f                	push   $0x4f
  jmp alltraps
80106be2:	e9 80 f8 ff ff       	jmp    80106467 <alltraps>

80106be7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $80
80106be9:	6a 50                	push   $0x50
  jmp alltraps
80106beb:	e9 77 f8 ff ff       	jmp    80106467 <alltraps>

80106bf0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $81
80106bf2:	6a 51                	push   $0x51
  jmp alltraps
80106bf4:	e9 6e f8 ff ff       	jmp    80106467 <alltraps>

80106bf9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106bf9:	6a 00                	push   $0x0
  pushl $82
80106bfb:	6a 52                	push   $0x52
  jmp alltraps
80106bfd:	e9 65 f8 ff ff       	jmp    80106467 <alltraps>

80106c02 <vector83>:
.globl vector83
vector83:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $83
80106c04:	6a 53                	push   $0x53
  jmp alltraps
80106c06:	e9 5c f8 ff ff       	jmp    80106467 <alltraps>

80106c0b <vector84>:
.globl vector84
vector84:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $84
80106c0d:	6a 54                	push   $0x54
  jmp alltraps
80106c0f:	e9 53 f8 ff ff       	jmp    80106467 <alltraps>

80106c14 <vector85>:
.globl vector85
vector85:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $85
80106c16:	6a 55                	push   $0x55
  jmp alltraps
80106c18:	e9 4a f8 ff ff       	jmp    80106467 <alltraps>

80106c1d <vector86>:
.globl vector86
vector86:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $86
80106c1f:	6a 56                	push   $0x56
  jmp alltraps
80106c21:	e9 41 f8 ff ff       	jmp    80106467 <alltraps>

80106c26 <vector87>:
.globl vector87
vector87:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $87
80106c28:	6a 57                	push   $0x57
  jmp alltraps
80106c2a:	e9 38 f8 ff ff       	jmp    80106467 <alltraps>

80106c2f <vector88>:
.globl vector88
vector88:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $88
80106c31:	6a 58                	push   $0x58
  jmp alltraps
80106c33:	e9 2f f8 ff ff       	jmp    80106467 <alltraps>

80106c38 <vector89>:
.globl vector89
vector89:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $89
80106c3a:	6a 59                	push   $0x59
  jmp alltraps
80106c3c:	e9 26 f8 ff ff       	jmp    80106467 <alltraps>

80106c41 <vector90>:
.globl vector90
vector90:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $90
80106c43:	6a 5a                	push   $0x5a
  jmp alltraps
80106c45:	e9 1d f8 ff ff       	jmp    80106467 <alltraps>

80106c4a <vector91>:
.globl vector91
vector91:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $91
80106c4c:	6a 5b                	push   $0x5b
  jmp alltraps
80106c4e:	e9 14 f8 ff ff       	jmp    80106467 <alltraps>

80106c53 <vector92>:
.globl vector92
vector92:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $92
80106c55:	6a 5c                	push   $0x5c
  jmp alltraps
80106c57:	e9 0b f8 ff ff       	jmp    80106467 <alltraps>

80106c5c <vector93>:
.globl vector93
vector93:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $93
80106c5e:	6a 5d                	push   $0x5d
  jmp alltraps
80106c60:	e9 02 f8 ff ff       	jmp    80106467 <alltraps>

80106c65 <vector94>:
.globl vector94
vector94:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $94
80106c67:	6a 5e                	push   $0x5e
  jmp alltraps
80106c69:	e9 f9 f7 ff ff       	jmp    80106467 <alltraps>

80106c6e <vector95>:
.globl vector95
vector95:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $95
80106c70:	6a 5f                	push   $0x5f
  jmp alltraps
80106c72:	e9 f0 f7 ff ff       	jmp    80106467 <alltraps>

80106c77 <vector96>:
.globl vector96
vector96:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $96
80106c79:	6a 60                	push   $0x60
  jmp alltraps
80106c7b:	e9 e7 f7 ff ff       	jmp    80106467 <alltraps>

80106c80 <vector97>:
.globl vector97
vector97:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $97
80106c82:	6a 61                	push   $0x61
  jmp alltraps
80106c84:	e9 de f7 ff ff       	jmp    80106467 <alltraps>

80106c89 <vector98>:
.globl vector98
vector98:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $98
80106c8b:	6a 62                	push   $0x62
  jmp alltraps
80106c8d:	e9 d5 f7 ff ff       	jmp    80106467 <alltraps>

80106c92 <vector99>:
.globl vector99
vector99:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $99
80106c94:	6a 63                	push   $0x63
  jmp alltraps
80106c96:	e9 cc f7 ff ff       	jmp    80106467 <alltraps>

80106c9b <vector100>:
.globl vector100
vector100:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $100
80106c9d:	6a 64                	push   $0x64
  jmp alltraps
80106c9f:	e9 c3 f7 ff ff       	jmp    80106467 <alltraps>

80106ca4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $101
80106ca6:	6a 65                	push   $0x65
  jmp alltraps
80106ca8:	e9 ba f7 ff ff       	jmp    80106467 <alltraps>

80106cad <vector102>:
.globl vector102
vector102:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $102
80106caf:	6a 66                	push   $0x66
  jmp alltraps
80106cb1:	e9 b1 f7 ff ff       	jmp    80106467 <alltraps>

80106cb6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $103
80106cb8:	6a 67                	push   $0x67
  jmp alltraps
80106cba:	e9 a8 f7 ff ff       	jmp    80106467 <alltraps>

80106cbf <vector104>:
.globl vector104
vector104:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $104
80106cc1:	6a 68                	push   $0x68
  jmp alltraps
80106cc3:	e9 9f f7 ff ff       	jmp    80106467 <alltraps>

80106cc8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $105
80106cca:	6a 69                	push   $0x69
  jmp alltraps
80106ccc:	e9 96 f7 ff ff       	jmp    80106467 <alltraps>

80106cd1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106cd1:	6a 00                	push   $0x0
  pushl $106
80106cd3:	6a 6a                	push   $0x6a
  jmp alltraps
80106cd5:	e9 8d f7 ff ff       	jmp    80106467 <alltraps>

80106cda <vector107>:
.globl vector107
vector107:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $107
80106cdc:	6a 6b                	push   $0x6b
  jmp alltraps
80106cde:	e9 84 f7 ff ff       	jmp    80106467 <alltraps>

80106ce3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $108
80106ce5:	6a 6c                	push   $0x6c
  jmp alltraps
80106ce7:	e9 7b f7 ff ff       	jmp    80106467 <alltraps>

80106cec <vector109>:
.globl vector109
vector109:
  pushl $0
80106cec:	6a 00                	push   $0x0
  pushl $109
80106cee:	6a 6d                	push   $0x6d
  jmp alltraps
80106cf0:	e9 72 f7 ff ff       	jmp    80106467 <alltraps>

80106cf5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106cf5:	6a 00                	push   $0x0
  pushl $110
80106cf7:	6a 6e                	push   $0x6e
  jmp alltraps
80106cf9:	e9 69 f7 ff ff       	jmp    80106467 <alltraps>

80106cfe <vector111>:
.globl vector111
vector111:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $111
80106d00:	6a 6f                	push   $0x6f
  jmp alltraps
80106d02:	e9 60 f7 ff ff       	jmp    80106467 <alltraps>

80106d07 <vector112>:
.globl vector112
vector112:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $112
80106d09:	6a 70                	push   $0x70
  jmp alltraps
80106d0b:	e9 57 f7 ff ff       	jmp    80106467 <alltraps>

80106d10 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $113
80106d12:	6a 71                	push   $0x71
  jmp alltraps
80106d14:	e9 4e f7 ff ff       	jmp    80106467 <alltraps>

80106d19 <vector114>:
.globl vector114
vector114:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $114
80106d1b:	6a 72                	push   $0x72
  jmp alltraps
80106d1d:	e9 45 f7 ff ff       	jmp    80106467 <alltraps>

80106d22 <vector115>:
.globl vector115
vector115:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $115
80106d24:	6a 73                	push   $0x73
  jmp alltraps
80106d26:	e9 3c f7 ff ff       	jmp    80106467 <alltraps>

80106d2b <vector116>:
.globl vector116
vector116:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $116
80106d2d:	6a 74                	push   $0x74
  jmp alltraps
80106d2f:	e9 33 f7 ff ff       	jmp    80106467 <alltraps>

80106d34 <vector117>:
.globl vector117
vector117:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $117
80106d36:	6a 75                	push   $0x75
  jmp alltraps
80106d38:	e9 2a f7 ff ff       	jmp    80106467 <alltraps>

80106d3d <vector118>:
.globl vector118
vector118:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $118
80106d3f:	6a 76                	push   $0x76
  jmp alltraps
80106d41:	e9 21 f7 ff ff       	jmp    80106467 <alltraps>

80106d46 <vector119>:
.globl vector119
vector119:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $119
80106d48:	6a 77                	push   $0x77
  jmp alltraps
80106d4a:	e9 18 f7 ff ff       	jmp    80106467 <alltraps>

80106d4f <vector120>:
.globl vector120
vector120:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $120
80106d51:	6a 78                	push   $0x78
  jmp alltraps
80106d53:	e9 0f f7 ff ff       	jmp    80106467 <alltraps>

80106d58 <vector121>:
.globl vector121
vector121:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $121
80106d5a:	6a 79                	push   $0x79
  jmp alltraps
80106d5c:	e9 06 f7 ff ff       	jmp    80106467 <alltraps>

80106d61 <vector122>:
.globl vector122
vector122:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $122
80106d63:	6a 7a                	push   $0x7a
  jmp alltraps
80106d65:	e9 fd f6 ff ff       	jmp    80106467 <alltraps>

80106d6a <vector123>:
.globl vector123
vector123:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $123
80106d6c:	6a 7b                	push   $0x7b
  jmp alltraps
80106d6e:	e9 f4 f6 ff ff       	jmp    80106467 <alltraps>

80106d73 <vector124>:
.globl vector124
vector124:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $124
80106d75:	6a 7c                	push   $0x7c
  jmp alltraps
80106d77:	e9 eb f6 ff ff       	jmp    80106467 <alltraps>

80106d7c <vector125>:
.globl vector125
vector125:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $125
80106d7e:	6a 7d                	push   $0x7d
  jmp alltraps
80106d80:	e9 e2 f6 ff ff       	jmp    80106467 <alltraps>

80106d85 <vector126>:
.globl vector126
vector126:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $126
80106d87:	6a 7e                	push   $0x7e
  jmp alltraps
80106d89:	e9 d9 f6 ff ff       	jmp    80106467 <alltraps>

80106d8e <vector127>:
.globl vector127
vector127:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $127
80106d90:	6a 7f                	push   $0x7f
  jmp alltraps
80106d92:	e9 d0 f6 ff ff       	jmp    80106467 <alltraps>

80106d97 <vector128>:
.globl vector128
vector128:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $128
80106d99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106d9e:	e9 c4 f6 ff ff       	jmp    80106467 <alltraps>

80106da3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $129
80106da5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106daa:	e9 b8 f6 ff ff       	jmp    80106467 <alltraps>

80106daf <vector130>:
.globl vector130
vector130:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $130
80106db1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106db6:	e9 ac f6 ff ff       	jmp    80106467 <alltraps>

80106dbb <vector131>:
.globl vector131
vector131:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $131
80106dbd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106dc2:	e9 a0 f6 ff ff       	jmp    80106467 <alltraps>

80106dc7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $132
80106dc9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106dce:	e9 94 f6 ff ff       	jmp    80106467 <alltraps>

80106dd3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $133
80106dd5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106dda:	e9 88 f6 ff ff       	jmp    80106467 <alltraps>

80106ddf <vector134>:
.globl vector134
vector134:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $134
80106de1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106de6:	e9 7c f6 ff ff       	jmp    80106467 <alltraps>

80106deb <vector135>:
.globl vector135
vector135:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $135
80106ded:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106df2:	e9 70 f6 ff ff       	jmp    80106467 <alltraps>

80106df7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $136
80106df9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106dfe:	e9 64 f6 ff ff       	jmp    80106467 <alltraps>

80106e03 <vector137>:
.globl vector137
vector137:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $137
80106e05:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e0a:	e9 58 f6 ff ff       	jmp    80106467 <alltraps>

80106e0f <vector138>:
.globl vector138
vector138:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $138
80106e11:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e16:	e9 4c f6 ff ff       	jmp    80106467 <alltraps>

80106e1b <vector139>:
.globl vector139
vector139:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $139
80106e1d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e22:	e9 40 f6 ff ff       	jmp    80106467 <alltraps>

80106e27 <vector140>:
.globl vector140
vector140:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $140
80106e29:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e2e:	e9 34 f6 ff ff       	jmp    80106467 <alltraps>

80106e33 <vector141>:
.globl vector141
vector141:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $141
80106e35:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e3a:	e9 28 f6 ff ff       	jmp    80106467 <alltraps>

80106e3f <vector142>:
.globl vector142
vector142:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $142
80106e41:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e46:	e9 1c f6 ff ff       	jmp    80106467 <alltraps>

80106e4b <vector143>:
.globl vector143
vector143:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $143
80106e4d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106e52:	e9 10 f6 ff ff       	jmp    80106467 <alltraps>

80106e57 <vector144>:
.globl vector144
vector144:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $144
80106e59:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106e5e:	e9 04 f6 ff ff       	jmp    80106467 <alltraps>

80106e63 <vector145>:
.globl vector145
vector145:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $145
80106e65:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106e6a:	e9 f8 f5 ff ff       	jmp    80106467 <alltraps>

80106e6f <vector146>:
.globl vector146
vector146:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $146
80106e71:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106e76:	e9 ec f5 ff ff       	jmp    80106467 <alltraps>

80106e7b <vector147>:
.globl vector147
vector147:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $147
80106e7d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106e82:	e9 e0 f5 ff ff       	jmp    80106467 <alltraps>

80106e87 <vector148>:
.globl vector148
vector148:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $148
80106e89:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106e8e:	e9 d4 f5 ff ff       	jmp    80106467 <alltraps>

80106e93 <vector149>:
.globl vector149
vector149:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $149
80106e95:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106e9a:	e9 c8 f5 ff ff       	jmp    80106467 <alltraps>

80106e9f <vector150>:
.globl vector150
vector150:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $150
80106ea1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ea6:	e9 bc f5 ff ff       	jmp    80106467 <alltraps>

80106eab <vector151>:
.globl vector151
vector151:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $151
80106ead:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106eb2:	e9 b0 f5 ff ff       	jmp    80106467 <alltraps>

80106eb7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $152
80106eb9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ebe:	e9 a4 f5 ff ff       	jmp    80106467 <alltraps>

80106ec3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $153
80106ec5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106eca:	e9 98 f5 ff ff       	jmp    80106467 <alltraps>

80106ecf <vector154>:
.globl vector154
vector154:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $154
80106ed1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ed6:	e9 8c f5 ff ff       	jmp    80106467 <alltraps>

80106edb <vector155>:
.globl vector155
vector155:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $155
80106edd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ee2:	e9 80 f5 ff ff       	jmp    80106467 <alltraps>

80106ee7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $156
80106ee9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106eee:	e9 74 f5 ff ff       	jmp    80106467 <alltraps>

80106ef3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $157
80106ef5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106efa:	e9 68 f5 ff ff       	jmp    80106467 <alltraps>

80106eff <vector158>:
.globl vector158
vector158:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $158
80106f01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f06:	e9 5c f5 ff ff       	jmp    80106467 <alltraps>

80106f0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $159
80106f0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f12:	e9 50 f5 ff ff       	jmp    80106467 <alltraps>

80106f17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $160
80106f19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f1e:	e9 44 f5 ff ff       	jmp    80106467 <alltraps>

80106f23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $161
80106f25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f2a:	e9 38 f5 ff ff       	jmp    80106467 <alltraps>

80106f2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $162
80106f31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f36:	e9 2c f5 ff ff       	jmp    80106467 <alltraps>

80106f3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $163
80106f3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f42:	e9 20 f5 ff ff       	jmp    80106467 <alltraps>

80106f47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $164
80106f49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106f4e:	e9 14 f5 ff ff       	jmp    80106467 <alltraps>

80106f53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $165
80106f55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106f5a:	e9 08 f5 ff ff       	jmp    80106467 <alltraps>

80106f5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $166
80106f61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106f66:	e9 fc f4 ff ff       	jmp    80106467 <alltraps>

80106f6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $167
80106f6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106f72:	e9 f0 f4 ff ff       	jmp    80106467 <alltraps>

80106f77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $168
80106f79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106f7e:	e9 e4 f4 ff ff       	jmp    80106467 <alltraps>

80106f83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $169
80106f85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106f8a:	e9 d8 f4 ff ff       	jmp    80106467 <alltraps>

80106f8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $170
80106f91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106f96:	e9 cc f4 ff ff       	jmp    80106467 <alltraps>

80106f9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $171
80106f9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106fa2:	e9 c0 f4 ff ff       	jmp    80106467 <alltraps>

80106fa7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $172
80106fa9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106fae:	e9 b4 f4 ff ff       	jmp    80106467 <alltraps>

80106fb3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $173
80106fb5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106fba:	e9 a8 f4 ff ff       	jmp    80106467 <alltraps>

80106fbf <vector174>:
.globl vector174
vector174:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $174
80106fc1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106fc6:	e9 9c f4 ff ff       	jmp    80106467 <alltraps>

80106fcb <vector175>:
.globl vector175
vector175:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $175
80106fcd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106fd2:	e9 90 f4 ff ff       	jmp    80106467 <alltraps>

80106fd7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $176
80106fd9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106fde:	e9 84 f4 ff ff       	jmp    80106467 <alltraps>

80106fe3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $177
80106fe5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106fea:	e9 78 f4 ff ff       	jmp    80106467 <alltraps>

80106fef <vector178>:
.globl vector178
vector178:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $178
80106ff1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ff6:	e9 6c f4 ff ff       	jmp    80106467 <alltraps>

80106ffb <vector179>:
.globl vector179
vector179:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $179
80106ffd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107002:	e9 60 f4 ff ff       	jmp    80106467 <alltraps>

80107007 <vector180>:
.globl vector180
vector180:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $180
80107009:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010700e:	e9 54 f4 ff ff       	jmp    80106467 <alltraps>

80107013 <vector181>:
.globl vector181
vector181:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $181
80107015:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010701a:	e9 48 f4 ff ff       	jmp    80106467 <alltraps>

8010701f <vector182>:
.globl vector182
vector182:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $182
80107021:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107026:	e9 3c f4 ff ff       	jmp    80106467 <alltraps>

8010702b <vector183>:
.globl vector183
vector183:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $183
8010702d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107032:	e9 30 f4 ff ff       	jmp    80106467 <alltraps>

80107037 <vector184>:
.globl vector184
vector184:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $184
80107039:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010703e:	e9 24 f4 ff ff       	jmp    80106467 <alltraps>

80107043 <vector185>:
.globl vector185
vector185:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $185
80107045:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010704a:	e9 18 f4 ff ff       	jmp    80106467 <alltraps>

8010704f <vector186>:
.globl vector186
vector186:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $186
80107051:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107056:	e9 0c f4 ff ff       	jmp    80106467 <alltraps>

8010705b <vector187>:
.globl vector187
vector187:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $187
8010705d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107062:	e9 00 f4 ff ff       	jmp    80106467 <alltraps>

80107067 <vector188>:
.globl vector188
vector188:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $188
80107069:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010706e:	e9 f4 f3 ff ff       	jmp    80106467 <alltraps>

80107073 <vector189>:
.globl vector189
vector189:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $189
80107075:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010707a:	e9 e8 f3 ff ff       	jmp    80106467 <alltraps>

8010707f <vector190>:
.globl vector190
vector190:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $190
80107081:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107086:	e9 dc f3 ff ff       	jmp    80106467 <alltraps>

8010708b <vector191>:
.globl vector191
vector191:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $191
8010708d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107092:	e9 d0 f3 ff ff       	jmp    80106467 <alltraps>

80107097 <vector192>:
.globl vector192
vector192:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $192
80107099:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010709e:	e9 c4 f3 ff ff       	jmp    80106467 <alltraps>

801070a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $193
801070a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801070aa:	e9 b8 f3 ff ff       	jmp    80106467 <alltraps>

801070af <vector194>:
.globl vector194
vector194:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $194
801070b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801070b6:	e9 ac f3 ff ff       	jmp    80106467 <alltraps>

801070bb <vector195>:
.globl vector195
vector195:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $195
801070bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801070c2:	e9 a0 f3 ff ff       	jmp    80106467 <alltraps>

801070c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $196
801070c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801070ce:	e9 94 f3 ff ff       	jmp    80106467 <alltraps>

801070d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $197
801070d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801070da:	e9 88 f3 ff ff       	jmp    80106467 <alltraps>

801070df <vector198>:
.globl vector198
vector198:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $198
801070e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801070e6:	e9 7c f3 ff ff       	jmp    80106467 <alltraps>

801070eb <vector199>:
.globl vector199
vector199:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $199
801070ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801070f2:	e9 70 f3 ff ff       	jmp    80106467 <alltraps>

801070f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $200
801070f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801070fe:	e9 64 f3 ff ff       	jmp    80106467 <alltraps>

80107103 <vector201>:
.globl vector201
vector201:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $201
80107105:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010710a:	e9 58 f3 ff ff       	jmp    80106467 <alltraps>

8010710f <vector202>:
.globl vector202
vector202:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $202
80107111:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107116:	e9 4c f3 ff ff       	jmp    80106467 <alltraps>

8010711b <vector203>:
.globl vector203
vector203:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $203
8010711d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107122:	e9 40 f3 ff ff       	jmp    80106467 <alltraps>

80107127 <vector204>:
.globl vector204
vector204:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $204
80107129:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010712e:	e9 34 f3 ff ff       	jmp    80106467 <alltraps>

80107133 <vector205>:
.globl vector205
vector205:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $205
80107135:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010713a:	e9 28 f3 ff ff       	jmp    80106467 <alltraps>

8010713f <vector206>:
.globl vector206
vector206:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $206
80107141:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107146:	e9 1c f3 ff ff       	jmp    80106467 <alltraps>

8010714b <vector207>:
.globl vector207
vector207:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $207
8010714d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107152:	e9 10 f3 ff ff       	jmp    80106467 <alltraps>

80107157 <vector208>:
.globl vector208
vector208:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $208
80107159:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010715e:	e9 04 f3 ff ff       	jmp    80106467 <alltraps>

80107163 <vector209>:
.globl vector209
vector209:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $209
80107165:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010716a:	e9 f8 f2 ff ff       	jmp    80106467 <alltraps>

8010716f <vector210>:
.globl vector210
vector210:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $210
80107171:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107176:	e9 ec f2 ff ff       	jmp    80106467 <alltraps>

8010717b <vector211>:
.globl vector211
vector211:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $211
8010717d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107182:	e9 e0 f2 ff ff       	jmp    80106467 <alltraps>

80107187 <vector212>:
.globl vector212
vector212:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $212
80107189:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010718e:	e9 d4 f2 ff ff       	jmp    80106467 <alltraps>

80107193 <vector213>:
.globl vector213
vector213:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $213
80107195:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010719a:	e9 c8 f2 ff ff       	jmp    80106467 <alltraps>

8010719f <vector214>:
.globl vector214
vector214:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $214
801071a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801071a6:	e9 bc f2 ff ff       	jmp    80106467 <alltraps>

801071ab <vector215>:
.globl vector215
vector215:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $215
801071ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801071b2:	e9 b0 f2 ff ff       	jmp    80106467 <alltraps>

801071b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $216
801071b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801071be:	e9 a4 f2 ff ff       	jmp    80106467 <alltraps>

801071c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $217
801071c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801071ca:	e9 98 f2 ff ff       	jmp    80106467 <alltraps>

801071cf <vector218>:
.globl vector218
vector218:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $218
801071d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801071d6:	e9 8c f2 ff ff       	jmp    80106467 <alltraps>

801071db <vector219>:
.globl vector219
vector219:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $219
801071dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801071e2:	e9 80 f2 ff ff       	jmp    80106467 <alltraps>

801071e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $220
801071e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801071ee:	e9 74 f2 ff ff       	jmp    80106467 <alltraps>

801071f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $221
801071f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801071fa:	e9 68 f2 ff ff       	jmp    80106467 <alltraps>

801071ff <vector222>:
.globl vector222
vector222:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $222
80107201:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107206:	e9 5c f2 ff ff       	jmp    80106467 <alltraps>

8010720b <vector223>:
.globl vector223
vector223:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $223
8010720d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107212:	e9 50 f2 ff ff       	jmp    80106467 <alltraps>

80107217 <vector224>:
.globl vector224
vector224:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $224
80107219:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010721e:	e9 44 f2 ff ff       	jmp    80106467 <alltraps>

80107223 <vector225>:
.globl vector225
vector225:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $225
80107225:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010722a:	e9 38 f2 ff ff       	jmp    80106467 <alltraps>

8010722f <vector226>:
.globl vector226
vector226:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $226
80107231:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107236:	e9 2c f2 ff ff       	jmp    80106467 <alltraps>

8010723b <vector227>:
.globl vector227
vector227:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $227
8010723d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107242:	e9 20 f2 ff ff       	jmp    80106467 <alltraps>

80107247 <vector228>:
.globl vector228
vector228:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $228
80107249:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010724e:	e9 14 f2 ff ff       	jmp    80106467 <alltraps>

80107253 <vector229>:
.globl vector229
vector229:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $229
80107255:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010725a:	e9 08 f2 ff ff       	jmp    80106467 <alltraps>

8010725f <vector230>:
.globl vector230
vector230:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $230
80107261:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107266:	e9 fc f1 ff ff       	jmp    80106467 <alltraps>

8010726b <vector231>:
.globl vector231
vector231:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $231
8010726d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107272:	e9 f0 f1 ff ff       	jmp    80106467 <alltraps>

80107277 <vector232>:
.globl vector232
vector232:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $232
80107279:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010727e:	e9 e4 f1 ff ff       	jmp    80106467 <alltraps>

80107283 <vector233>:
.globl vector233
vector233:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $233
80107285:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010728a:	e9 d8 f1 ff ff       	jmp    80106467 <alltraps>

8010728f <vector234>:
.globl vector234
vector234:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $234
80107291:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107296:	e9 cc f1 ff ff       	jmp    80106467 <alltraps>

8010729b <vector235>:
.globl vector235
vector235:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $235
8010729d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801072a2:	e9 c0 f1 ff ff       	jmp    80106467 <alltraps>

801072a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $236
801072a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801072ae:	e9 b4 f1 ff ff       	jmp    80106467 <alltraps>

801072b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $237
801072b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801072ba:	e9 a8 f1 ff ff       	jmp    80106467 <alltraps>

801072bf <vector238>:
.globl vector238
vector238:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $238
801072c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801072c6:	e9 9c f1 ff ff       	jmp    80106467 <alltraps>

801072cb <vector239>:
.globl vector239
vector239:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $239
801072cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801072d2:	e9 90 f1 ff ff       	jmp    80106467 <alltraps>

801072d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $240
801072d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801072de:	e9 84 f1 ff ff       	jmp    80106467 <alltraps>

801072e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $241
801072e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801072ea:	e9 78 f1 ff ff       	jmp    80106467 <alltraps>

801072ef <vector242>:
.globl vector242
vector242:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $242
801072f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801072f6:	e9 6c f1 ff ff       	jmp    80106467 <alltraps>

801072fb <vector243>:
.globl vector243
vector243:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $243
801072fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107302:	e9 60 f1 ff ff       	jmp    80106467 <alltraps>

80107307 <vector244>:
.globl vector244
vector244:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $244
80107309:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010730e:	e9 54 f1 ff ff       	jmp    80106467 <alltraps>

80107313 <vector245>:
.globl vector245
vector245:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $245
80107315:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010731a:	e9 48 f1 ff ff       	jmp    80106467 <alltraps>

8010731f <vector246>:
.globl vector246
vector246:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $246
80107321:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107326:	e9 3c f1 ff ff       	jmp    80106467 <alltraps>

8010732b <vector247>:
.globl vector247
vector247:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $247
8010732d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107332:	e9 30 f1 ff ff       	jmp    80106467 <alltraps>

80107337 <vector248>:
.globl vector248
vector248:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $248
80107339:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010733e:	e9 24 f1 ff ff       	jmp    80106467 <alltraps>

80107343 <vector249>:
.globl vector249
vector249:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $249
80107345:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010734a:	e9 18 f1 ff ff       	jmp    80106467 <alltraps>

8010734f <vector250>:
.globl vector250
vector250:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $250
80107351:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107356:	e9 0c f1 ff ff       	jmp    80106467 <alltraps>

8010735b <vector251>:
.globl vector251
vector251:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $251
8010735d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107362:	e9 00 f1 ff ff       	jmp    80106467 <alltraps>

80107367 <vector252>:
.globl vector252
vector252:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $252
80107369:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010736e:	e9 f4 f0 ff ff       	jmp    80106467 <alltraps>

80107373 <vector253>:
.globl vector253
vector253:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $253
80107375:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010737a:	e9 e8 f0 ff ff       	jmp    80106467 <alltraps>

8010737f <vector254>:
.globl vector254
vector254:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $254
80107381:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107386:	e9 dc f0 ff ff       	jmp    80106467 <alltraps>

8010738b <vector255>:
.globl vector255
vector255:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $255
8010738d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107392:	e9 d0 f0 ff ff       	jmp    80106467 <alltraps>
80107397:	66 90                	xchg   %ax,%ax
80107399:	66 90                	xchg   %ax,%ax
8010739b:	66 90                	xchg   %ax,%ax
8010739d:	66 90                	xchg   %ax,%ax
8010739f:	90                   	nop

801073a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801073a8:	c1 ea 16             	shr    $0x16,%edx
801073ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801073ae:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801073b1:	8b 07                	mov    (%edi),%eax
801073b3:	a8 01                	test   $0x1,%al
801073b5:	74 29                	je     801073e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073bc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801073c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801073c5:	c1 eb 0a             	shr    $0xa,%ebx
801073c8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801073ce:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
801073d1:	5b                   	pop    %ebx
801073d2:	5e                   	pop    %esi
801073d3:	5f                   	pop    %edi
801073d4:	5d                   	pop    %ebp
801073d5:	c3                   	ret    
801073d6:	8d 76 00             	lea    0x0(%esi),%esi
801073d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801073e0:	85 c9                	test   %ecx,%ecx
801073e2:	74 2c                	je     80107410 <walkpgdir+0x70>
801073e4:	e8 b7 b0 ff ff       	call   801024a0 <kalloc>
801073e9:	85 c0                	test   %eax,%eax
801073eb:	89 c6                	mov    %eax,%esi
801073ed:	74 21                	je     80107410 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801073ef:	83 ec 04             	sub    $0x4,%esp
801073f2:	68 00 10 00 00       	push   $0x1000
801073f7:	6a 00                	push   $0x0
801073f9:	50                   	push   %eax
801073fa:	e8 b1 dd ff ff       	call   801051b0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801073ff:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107405:	83 c4 10             	add    $0x10,%esp
80107408:	83 c8 07             	or     $0x7,%eax
8010740b:	89 07                	mov    %eax,(%edi)
8010740d:	eb b3                	jmp    801073c2 <walkpgdir+0x22>
8010740f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80107410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80107413:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107415:	5b                   	pop    %ebx
80107416:	5e                   	pop    %esi
80107417:	5f                   	pop    %edi
80107418:	5d                   	pop    %ebp
80107419:	c3                   	ret    
8010741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107420 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107426:	89 d3                	mov    %edx,%ebx
80107428:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010742e:	83 ec 1c             	sub    $0x1c,%esp
80107431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107434:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107438:	8b 7d 08             	mov    0x8(%ebp),%edi
8010743b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107440:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107443:	8b 45 0c             	mov    0xc(%ebp),%eax
80107446:	29 df                	sub    %ebx,%edi
80107448:	83 c8 01             	or     $0x1,%eax
8010744b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010744e:	eb 15                	jmp    80107465 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107450:	f6 00 01             	testb  $0x1,(%eax)
80107453:	75 45                	jne    8010749a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107455:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107458:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010745b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010745d:	74 31                	je     80107490 <mappages+0x70>
      break;
    a += PGSIZE;
8010745f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107468:	b9 01 00 00 00       	mov    $0x1,%ecx
8010746d:	89 da                	mov    %ebx,%edx
8010746f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107472:	e8 29 ff ff ff       	call   801073a0 <walkpgdir>
80107477:	85 c0                	test   %eax,%eax
80107479:	75 d5                	jne    80107450 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010747b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010747e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80107483:	5b                   	pop    %ebx
80107484:	5e                   	pop    %esi
80107485:	5f                   	pop    %edi
80107486:	5d                   	pop    %ebp
80107487:	c3                   	ret    
80107488:	90                   	nop
80107489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107490:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107493:	31 c0                	xor    %eax,%eax
}
80107495:	5b                   	pop    %ebx
80107496:	5e                   	pop    %esi
80107497:	5f                   	pop    %edi
80107498:	5d                   	pop    %ebp
80107499:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010749a:	83 ec 0c             	sub    $0xc,%esp
8010749d:	68 18 87 10 80       	push   $0x80108718
801074a2:	e8 c9 8e ff ff       	call   80100370 <panic>
801074a7:	89 f6                	mov    %esi,%esi
801074a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801074b6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801074bc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801074be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801074c4:	83 ec 1c             	sub    $0x1c,%esp
801074c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801074ca:	39 d3                	cmp    %edx,%ebx
801074cc:	73 66                	jae    80107534 <deallocuvm.part.0+0x84>
801074ce:	89 d6                	mov    %edx,%esi
801074d0:	eb 3d                	jmp    8010750f <deallocuvm.part.0+0x5f>
801074d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801074d8:	8b 10                	mov    (%eax),%edx
801074da:	f6 c2 01             	test   $0x1,%dl
801074dd:	74 26                	je     80107505 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801074df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801074e5:	74 58                	je     8010753f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801074e7:	83 ec 0c             	sub    $0xc,%esp
801074ea:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801074f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074f3:	52                   	push   %edx
801074f4:	e8 f7 ad ff ff       	call   801022f0 <kfree>
      *pte = 0;
801074f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074fc:	83 c4 10             	add    $0x10,%esp
801074ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107505:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010750b:	39 f3                	cmp    %esi,%ebx
8010750d:	73 25                	jae    80107534 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010750f:	31 c9                	xor    %ecx,%ecx
80107511:	89 da                	mov    %ebx,%edx
80107513:	89 f8                	mov    %edi,%eax
80107515:	e8 86 fe ff ff       	call   801073a0 <walkpgdir>
    if(!pte)
8010751a:	85 c0                	test   %eax,%eax
8010751c:	75 ba                	jne    801074d8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010751e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107524:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010752a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107530:	39 f3                	cmp    %esi,%ebx
80107532:	72 db                	jb     8010750f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107534:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107537:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010753a:	5b                   	pop    %ebx
8010753b:	5e                   	pop    %esi
8010753c:	5f                   	pop    %edi
8010753d:	5d                   	pop    %ebp
8010753e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010753f:	83 ec 0c             	sub    $0xc,%esp
80107542:	68 a6 7f 10 80       	push   $0x80107fa6
80107547:	e8 24 8e ff ff       	call   80100370 <panic>
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107550 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107556:	e8 25 c3 ff ff       	call   80103880 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010755b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107561:	31 c9                	xor    %ecx,%ecx
80107563:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107568:	66 89 90 98 39 11 80 	mov    %dx,-0x7feec668(%eax)
8010756f:	66 89 88 9a 39 11 80 	mov    %cx,-0x7feec666(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107576:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010757b:	31 c9                	xor    %ecx,%ecx
8010757d:	66 89 90 a0 39 11 80 	mov    %dx,-0x7feec660(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107584:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107589:	66 89 88 a2 39 11 80 	mov    %cx,-0x7feec65e(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107590:	31 c9                	xor    %ecx,%ecx
80107592:	66 89 90 a8 39 11 80 	mov    %dx,-0x7feec658(%eax)
80107599:	66 89 88 aa 39 11 80 	mov    %cx,-0x7feec656(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801075a0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801075a5:	31 c9                	xor    %ecx,%ecx
801075a7:	66 89 90 b0 39 11 80 	mov    %dx,-0x7feec650(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801075ae:	c6 80 9c 39 11 80 00 	movb   $0x0,-0x7feec664(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801075b5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801075ba:	c6 80 9d 39 11 80 9a 	movb   $0x9a,-0x7feec663(%eax)
801075c1:	c6 80 9e 39 11 80 cf 	movb   $0xcf,-0x7feec662(%eax)
801075c8:	c6 80 9f 39 11 80 00 	movb   $0x0,-0x7feec661(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801075cf:	c6 80 a4 39 11 80 00 	movb   $0x0,-0x7feec65c(%eax)
801075d6:	c6 80 a5 39 11 80 92 	movb   $0x92,-0x7feec65b(%eax)
801075dd:	c6 80 a6 39 11 80 cf 	movb   $0xcf,-0x7feec65a(%eax)
801075e4:	c6 80 a7 39 11 80 00 	movb   $0x0,-0x7feec659(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801075eb:	c6 80 ac 39 11 80 00 	movb   $0x0,-0x7feec654(%eax)
801075f2:	c6 80 ad 39 11 80 fa 	movb   $0xfa,-0x7feec653(%eax)
801075f9:	c6 80 ae 39 11 80 cf 	movb   $0xcf,-0x7feec652(%eax)
80107600:	c6 80 af 39 11 80 00 	movb   $0x0,-0x7feec651(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107607:	66 89 88 b2 39 11 80 	mov    %cx,-0x7feec64e(%eax)
8010760e:	c6 80 b4 39 11 80 00 	movb   $0x0,-0x7feec64c(%eax)
80107615:	c6 80 b5 39 11 80 f2 	movb   $0xf2,-0x7feec64b(%eax)
8010761c:	c6 80 b6 39 11 80 cf 	movb   $0xcf,-0x7feec64a(%eax)
80107623:	c6 80 b7 39 11 80 00 	movb   $0x0,-0x7feec649(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010762a:	05 90 39 11 80       	add    $0x80113990,%eax
8010762f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107633:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107637:	c1 e8 10             	shr    $0x10,%eax
8010763a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010763e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107641:	0f 01 10             	lgdtl  (%eax)
}
80107644:	c9                   	leave  
80107645:	c3                   	ret    
80107646:	8d 76 00             	lea    0x0(%esi),%esi
80107649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107650 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107650:	a1 a4 45 12 80       	mov    0x801245a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107655:	55                   	push   %ebp
80107656:	89 e5                	mov    %esp,%ebp
80107658:	05 00 00 00 80       	add    $0x80000000,%eax
8010765d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107660:	5d                   	pop    %ebp
80107661:	c3                   	ret    
80107662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107670 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	57                   	push   %edi
80107674:	56                   	push   %esi
80107675:	53                   	push   %ebx
80107676:	83 ec 1c             	sub    $0x1c,%esp
80107679:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010767c:	85 f6                	test   %esi,%esi
8010767e:	0f 84 d9 00 00 00    	je     8010775d <switchuvm+0xed>
    panic("switchuvm: no process");
  if(p->mainThread->tkstack == 0)
80107684:	8b 86 b4 03 00 00    	mov    0x3b4(%esi),%eax
8010768a:	8b 40 04             	mov    0x4(%eax),%eax
8010768d:	85 c0                	test   %eax,%eax
8010768f:	0f 84 e2 00 00 00    	je     80107777 <switchuvm+0x107>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107695:	8b 7e 04             	mov    0x4(%esi),%edi
80107698:	85 ff                	test   %edi,%edi
8010769a:	0f 84 ca 00 00 00    	je     8010776a <switchuvm+0xfa>
    panic("switchuvm: no pgdir");

  pushcli();
801076a0:	e8 0b d9 ff ff       	call   80104fb0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801076a5:	e8 56 c1 ff ff       	call   80103800 <mycpu>
801076aa:	89 c3                	mov    %eax,%ebx
801076ac:	e8 4f c1 ff ff       	call   80103800 <mycpu>
801076b1:	89 c7                	mov    %eax,%edi
801076b3:	e8 48 c1 ff ff       	call   80103800 <mycpu>
801076b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076bb:	83 c7 08             	add    $0x8,%edi
801076be:	e8 3d c1 ff ff       	call   80103800 <mycpu>
801076c3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801076c6:	83 c0 08             	add    $0x8,%eax
801076c9:	ba 67 00 00 00       	mov    $0x67,%edx
801076ce:	c1 e8 18             	shr    $0x18,%eax
801076d1:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801076d8:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801076df:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801076e6:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801076ed:	83 c1 08             	add    $0x8,%ecx
801076f0:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801076f6:	c1 e9 10             	shr    $0x10,%ecx
801076f9:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076ff:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107704:	e8 f7 c0 ff ff       	call   80103800 <mycpu>
80107709:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107710:	e8 eb c0 ff ff       	call   80103800 <mycpu>
80107715:	b9 10 00 00 00       	mov    $0x10,%ecx
8010771a:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
8010771e:	e8 dd c0 ff ff       	call   80103800 <mycpu>
80107723:	8b 8e b4 03 00 00    	mov    0x3b4(%esi),%ecx
80107729:	8b 49 04             	mov    0x4(%ecx),%ecx
8010772c:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107732:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107735:	e8 c6 c0 ff ff       	call   80103800 <mycpu>
8010773a:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
8010773e:	b8 28 00 00 00       	mov    $0x28,%eax
80107743:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107746:	8b 46 04             	mov    0x4(%esi),%eax
80107749:	05 00 00 00 80       	add    $0x80000000,%eax
8010774e:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107751:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107754:	5b                   	pop    %ebx
80107755:	5e                   	pop    %esi
80107756:	5f                   	pop    %edi
80107757:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80107758:	e9 93 d8 ff ff       	jmp    80104ff0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
8010775d:	83 ec 0c             	sub    $0xc,%esp
80107760:	68 1e 87 10 80       	push   $0x8010871e
80107765:	e8 06 8c ff ff       	call   80100370 <panic>
  if(p->mainThread->tkstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010776a:	83 ec 0c             	sub    $0xc,%esp
8010776d:	68 49 87 10 80       	push   $0x80108749
80107772:	e8 f9 8b ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->mainThread->tkstack == 0)
    panic("switchuvm: no kstack");
80107777:	83 ec 0c             	sub    $0xc,%esp
8010777a:	68 34 87 10 80       	push   $0x80108734
8010777f:	e8 ec 8b ff ff       	call   80100370 <panic>
80107784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010778a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107790 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
80107796:	83 ec 1c             	sub    $0x1c,%esp
80107799:	8b 75 10             	mov    0x10(%ebp),%esi
8010779c:	8b 45 08             	mov    0x8(%ebp),%eax
8010779f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801077a2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801077a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801077ab:	77 49                	ja     801077f6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801077ad:	e8 ee ac ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
801077b2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801077b5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801077b7:	68 00 10 00 00       	push   $0x1000
801077bc:	6a 00                	push   $0x0
801077be:	50                   	push   %eax
801077bf:	e8 ec d9 ff ff       	call   801051b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801077c4:	58                   	pop    %eax
801077c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077cb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077d0:	5a                   	pop    %edx
801077d1:	6a 06                	push   $0x6
801077d3:	50                   	push   %eax
801077d4:	31 d2                	xor    %edx,%edx
801077d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077d9:	e8 42 fc ff ff       	call   80107420 <mappages>
  memmove(mem, init, sz);
801077de:	89 75 10             	mov    %esi,0x10(%ebp)
801077e1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801077e4:	83 c4 10             	add    $0x10,%esp
801077e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801077ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ed:	5b                   	pop    %ebx
801077ee:	5e                   	pop    %esi
801077ef:	5f                   	pop    %edi
801077f0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801077f1:	e9 6a da ff ff       	jmp    80105260 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801077f6:	83 ec 0c             	sub    $0xc,%esp
801077f9:	68 5d 87 10 80       	push   $0x8010875d
801077fe:	e8 6d 8b ff ff       	call   80100370 <panic>
80107803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107810 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	57                   	push   %edi
80107814:	56                   	push   %esi
80107815:	53                   	push   %ebx
80107816:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107819:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107820:	0f 85 91 00 00 00    	jne    801078b7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107826:	8b 75 18             	mov    0x18(%ebp),%esi
80107829:	31 db                	xor    %ebx,%ebx
8010782b:	85 f6                	test   %esi,%esi
8010782d:	75 1a                	jne    80107849 <loaduvm+0x39>
8010782f:	eb 6f                	jmp    801078a0 <loaduvm+0x90>
80107831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107838:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010783e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107844:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107847:	76 57                	jbe    801078a0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107849:	8b 55 0c             	mov    0xc(%ebp),%edx
8010784c:	8b 45 08             	mov    0x8(%ebp),%eax
8010784f:	31 c9                	xor    %ecx,%ecx
80107851:	01 da                	add    %ebx,%edx
80107853:	e8 48 fb ff ff       	call   801073a0 <walkpgdir>
80107858:	85 c0                	test   %eax,%eax
8010785a:	74 4e                	je     801078aa <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010785c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010785e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107861:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107866:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010786b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107871:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107874:	01 d9                	add    %ebx,%ecx
80107876:	05 00 00 00 80       	add    $0x80000000,%eax
8010787b:	57                   	push   %edi
8010787c:	51                   	push   %ecx
8010787d:	50                   	push   %eax
8010787e:	ff 75 10             	pushl  0x10(%ebp)
80107881:	e8 da a0 ff ff       	call   80101960 <readi>
80107886:	83 c4 10             	add    $0x10,%esp
80107889:	39 c7                	cmp    %eax,%edi
8010788b:	74 ab                	je     80107838 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010788d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107895:	5b                   	pop    %ebx
80107896:	5e                   	pop    %esi
80107897:	5f                   	pop    %edi
80107898:	5d                   	pop    %ebp
80107899:	c3                   	ret    
8010789a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801078a3:	31 c0                	xor    %eax,%eax
}
801078a5:	5b                   	pop    %ebx
801078a6:	5e                   	pop    %esi
801078a7:	5f                   	pop    %edi
801078a8:	5d                   	pop    %ebp
801078a9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801078aa:	83 ec 0c             	sub    $0xc,%esp
801078ad:	68 77 87 10 80       	push   $0x80108777
801078b2:	e8 b9 8a ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801078b7:	83 ec 0c             	sub    $0xc,%esp
801078ba:	68 18 88 10 80       	push   $0x80108818
801078bf:	e8 ac 8a ff ff       	call   80100370 <panic>
801078c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801078d0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	57                   	push   %edi
801078d4:	56                   	push   %esi
801078d5:	53                   	push   %ebx
801078d6:	83 ec 0c             	sub    $0xc,%esp
801078d9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801078dc:	85 ff                	test   %edi,%edi
801078de:	0f 88 ca 00 00 00    	js     801079ae <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
801078e4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801078e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801078ea:	0f 82 82 00 00 00    	jb     80107972 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
801078f0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801078f6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801078fc:	39 df                	cmp    %ebx,%edi
801078fe:	77 43                	ja     80107943 <allocuvm+0x73>
80107900:	e9 bb 00 00 00       	jmp    801079c0 <allocuvm+0xf0>
80107905:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107908:	83 ec 04             	sub    $0x4,%esp
8010790b:	68 00 10 00 00       	push   $0x1000
80107910:	6a 00                	push   $0x0
80107912:	50                   	push   %eax
80107913:	e8 98 d8 ff ff       	call   801051b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107918:	58                   	pop    %eax
80107919:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010791f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107924:	5a                   	pop    %edx
80107925:	6a 06                	push   $0x6
80107927:	50                   	push   %eax
80107928:	89 da                	mov    %ebx,%edx
8010792a:	8b 45 08             	mov    0x8(%ebp),%eax
8010792d:	e8 ee fa ff ff       	call   80107420 <mappages>
80107932:	83 c4 10             	add    $0x10,%esp
80107935:	85 c0                	test   %eax,%eax
80107937:	78 47                	js     80107980 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107939:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010793f:	39 df                	cmp    %ebx,%edi
80107941:	76 7d                	jbe    801079c0 <allocuvm+0xf0>
    mem = kalloc();
80107943:	e8 58 ab ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
80107948:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010794a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010794c:	75 ba                	jne    80107908 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010794e:	83 ec 0c             	sub    $0xc,%esp
80107951:	68 95 87 10 80       	push   $0x80108795
80107956:	e8 05 8d ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010795b:	83 c4 10             	add    $0x10,%esp
8010795e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107961:	76 4b                	jbe    801079ae <allocuvm+0xde>
80107963:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107966:	8b 45 08             	mov    0x8(%ebp),%eax
80107969:	89 fa                	mov    %edi,%edx
8010796b:	e8 40 fb ff ff       	call   801074b0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107970:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107972:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107975:	5b                   	pop    %ebx
80107976:	5e                   	pop    %esi
80107977:	5f                   	pop    %edi
80107978:	5d                   	pop    %ebp
80107979:	c3                   	ret    
8010797a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107980:	83 ec 0c             	sub    $0xc,%esp
80107983:	68 ad 87 10 80       	push   $0x801087ad
80107988:	e8 d3 8c ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010798d:	83 c4 10             	add    $0x10,%esp
80107990:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107993:	76 0d                	jbe    801079a2 <allocuvm+0xd2>
80107995:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107998:	8b 45 08             	mov    0x8(%ebp),%eax
8010799b:	89 fa                	mov    %edi,%edx
8010799d:	e8 0e fb ff ff       	call   801074b0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801079a2:	83 ec 0c             	sub    $0xc,%esp
801079a5:	56                   	push   %esi
801079a6:	e8 45 a9 ff ff       	call   801022f0 <kfree>
      return 0;
801079ab:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801079ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801079b1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801079b3:	5b                   	pop    %ebx
801079b4:	5e                   	pop    %esi
801079b5:	5f                   	pop    %edi
801079b6:	5d                   	pop    %ebp
801079b7:	c3                   	ret    
801079b8:	90                   	nop
801079b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801079c3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801079c5:	5b                   	pop    %ebx
801079c6:	5e                   	pop    %esi
801079c7:	5f                   	pop    %edi
801079c8:	5d                   	pop    %ebp
801079c9:	c3                   	ret    
801079ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079d0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801079d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801079d9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801079dc:	39 d1                	cmp    %edx,%ecx
801079de:	73 10                	jae    801079f0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801079e0:	5d                   	pop    %ebp
801079e1:	e9 ca fa ff ff       	jmp    801074b0 <deallocuvm.part.0>
801079e6:	8d 76 00             	lea    0x0(%esi),%esi
801079e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801079f0:	89 d0                	mov    %edx,%eax
801079f2:	5d                   	pop    %ebp
801079f3:	c3                   	ret    
801079f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a00 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
80107a06:	83 ec 0c             	sub    $0xc,%esp
80107a09:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107a0c:	85 f6                	test   %esi,%esi
80107a0e:	74 59                	je     80107a69 <freevm+0x69>
80107a10:	31 c9                	xor    %ecx,%ecx
80107a12:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107a17:	89 f0                	mov    %esi,%eax
80107a19:	e8 92 fa ff ff       	call   801074b0 <deallocuvm.part.0>
80107a1e:	89 f3                	mov    %esi,%ebx
80107a20:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a26:	eb 0f                	jmp    80107a37 <freevm+0x37>
80107a28:	90                   	nop
80107a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a30:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107a33:	39 fb                	cmp    %edi,%ebx
80107a35:	74 23                	je     80107a5a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107a37:	8b 03                	mov    (%ebx),%eax
80107a39:	a8 01                	test   $0x1,%al
80107a3b:	74 f3                	je     80107a30 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80107a3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a42:	83 ec 0c             	sub    $0xc,%esp
80107a45:	83 c3 04             	add    $0x4,%ebx
80107a48:	05 00 00 00 80       	add    $0x80000000,%eax
80107a4d:	50                   	push   %eax
80107a4e:	e8 9d a8 ff ff       	call   801022f0 <kfree>
80107a53:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107a56:	39 fb                	cmp    %edi,%ebx
80107a58:	75 dd                	jne    80107a37 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107a5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a60:	5b                   	pop    %ebx
80107a61:	5e                   	pop    %esi
80107a62:	5f                   	pop    %edi
80107a63:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107a64:	e9 87 a8 ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107a69:	83 ec 0c             	sub    $0xc,%esp
80107a6c:	68 c9 87 10 80       	push   $0x801087c9
80107a71:	e8 fa 88 ff ff       	call   80100370 <panic>
80107a76:	8d 76 00             	lea    0x0(%esi),%esi
80107a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a80 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	56                   	push   %esi
80107a84:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107a85:	e8 16 aa ff ff       	call   801024a0 <kalloc>
80107a8a:	85 c0                	test   %eax,%eax
80107a8c:	74 6a                	je     80107af8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80107a8e:	83 ec 04             	sub    $0x4,%esp
80107a91:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a93:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107a98:	68 00 10 00 00       	push   $0x1000
80107a9d:	6a 00                	push   $0x0
80107a9f:	50                   	push   %eax
80107aa0:	e8 0b d7 ff ff       	call   801051b0 <memset>
80107aa5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107aa8:	8b 43 04             	mov    0x4(%ebx),%eax
80107aab:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107aae:	83 ec 08             	sub    $0x8,%esp
80107ab1:	8b 13                	mov    (%ebx),%edx
80107ab3:	ff 73 0c             	pushl  0xc(%ebx)
80107ab6:	50                   	push   %eax
80107ab7:	29 c1                	sub    %eax,%ecx
80107ab9:	89 f0                	mov    %esi,%eax
80107abb:	e8 60 f9 ff ff       	call   80107420 <mappages>
80107ac0:	83 c4 10             	add    $0x10,%esp
80107ac3:	85 c0                	test   %eax,%eax
80107ac5:	78 19                	js     80107ae0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ac7:	83 c3 10             	add    $0x10,%ebx
80107aca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107ad0:	75 d6                	jne    80107aa8 <setupkvm+0x28>
80107ad2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107ad4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ad7:	5b                   	pop    %ebx
80107ad8:	5e                   	pop    %esi
80107ad9:	5d                   	pop    %ebp
80107ada:	c3                   	ret    
80107adb:	90                   	nop
80107adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107ae0:	83 ec 0c             	sub    $0xc,%esp
80107ae3:	56                   	push   %esi
80107ae4:	e8 17 ff ff ff       	call   80107a00 <freevm>
      return 0;
80107ae9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80107aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80107aef:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107af1:	5b                   	pop    %ebx
80107af2:	5e                   	pop    %esi
80107af3:	5d                   	pop    %ebp
80107af4:	c3                   	ret    
80107af5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107af8:	31 c0                	xor    %eax,%eax
80107afa:	eb d8                	jmp    80107ad4 <setupkvm+0x54>
80107afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b00 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
80107b03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107b06:	e8 75 ff ff ff       	call   80107a80 <setupkvm>
80107b0b:	a3 a4 45 12 80       	mov    %eax,0x801245a4
80107b10:	05 00 00 00 80       	add    $0x80000000,%eax
80107b15:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107b18:	c9                   	leave  
80107b19:	c3                   	ret    
80107b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b21:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b23:	89 e5                	mov    %esp,%ebp
80107b25:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b28:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b2e:	e8 6d f8 ff ff       	call   801073a0 <walkpgdir>
  if(pte == 0)
80107b33:	85 c0                	test   %eax,%eax
80107b35:	74 05                	je     80107b3c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107b37:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107b3a:	c9                   	leave  
80107b3b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107b3c:	83 ec 0c             	sub    $0xc,%esp
80107b3f:	68 da 87 10 80       	push   $0x801087da
80107b44:	e8 27 88 ff ff       	call   80100370 <panic>
80107b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107b50:	55                   	push   %ebp
80107b51:	89 e5                	mov    %esp,%ebp
80107b53:	57                   	push   %edi
80107b54:	56                   	push   %esi
80107b55:	53                   	push   %ebx
80107b56:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107b59:	e8 22 ff ff ff       	call   80107a80 <setupkvm>
80107b5e:	85 c0                	test   %eax,%eax
80107b60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b63:	0f 84 c5 00 00 00    	je     80107c2e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b6c:	85 c9                	test   %ecx,%ecx
80107b6e:	0f 84 9c 00 00 00    	je     80107c10 <copyuvm+0xc0>
80107b74:	31 ff                	xor    %edi,%edi
80107b76:	eb 4a                	jmp    80107bc2 <copyuvm+0x72>
80107b78:	90                   	nop
80107b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107b80:	83 ec 04             	sub    $0x4,%esp
80107b83:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107b89:	68 00 10 00 00       	push   $0x1000
80107b8e:	53                   	push   %ebx
80107b8f:	50                   	push   %eax
80107b90:	e8 cb d6 ff ff       	call   80105260 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107b95:	58                   	pop    %eax
80107b96:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107b9c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ba1:	5a                   	pop    %edx
80107ba2:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ba5:	50                   	push   %eax
80107ba6:	89 fa                	mov    %edi,%edx
80107ba8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107bab:	e8 70 f8 ff ff       	call   80107420 <mappages>
80107bb0:	83 c4 10             	add    $0x10,%esp
80107bb3:	85 c0                	test   %eax,%eax
80107bb5:	78 69                	js     80107c20 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107bb7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107bbd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107bc0:	76 4e                	jbe    80107c10 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80107bc5:	31 c9                	xor    %ecx,%ecx
80107bc7:	89 fa                	mov    %edi,%edx
80107bc9:	e8 d2 f7 ff ff       	call   801073a0 <walkpgdir>
80107bce:	85 c0                	test   %eax,%eax
80107bd0:	74 6d                	je     80107c3f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107bd2:	8b 00                	mov    (%eax),%eax
80107bd4:	a8 01                	test   $0x1,%al
80107bd6:	74 5a                	je     80107c32 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107bd8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107bda:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107bdf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107be5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107be8:	e8 b3 a8 ff ff       	call   801024a0 <kalloc>
80107bed:	85 c0                	test   %eax,%eax
80107bef:	89 c6                	mov    %eax,%esi
80107bf1:	75 8d                	jne    80107b80 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107bf3:	83 ec 0c             	sub    $0xc,%esp
80107bf6:	ff 75 e0             	pushl  -0x20(%ebp)
80107bf9:	e8 02 fe ff ff       	call   80107a00 <freevm>
  return 0;
80107bfe:	83 c4 10             	add    $0x10,%esp
80107c01:	31 c0                	xor    %eax,%eax
}
80107c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c06:	5b                   	pop    %ebx
80107c07:	5e                   	pop    %esi
80107c08:	5f                   	pop    %edi
80107c09:	5d                   	pop    %ebp
80107c0a:	c3                   	ret    
80107c0b:	90                   	nop
80107c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c16:	5b                   	pop    %ebx
80107c17:	5e                   	pop    %esi
80107c18:	5f                   	pop    %edi
80107c19:	5d                   	pop    %ebp
80107c1a:	c3                   	ret    
80107c1b:	90                   	nop
80107c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107c20:	83 ec 0c             	sub    $0xc,%esp
80107c23:	56                   	push   %esi
80107c24:	e8 c7 a6 ff ff       	call   801022f0 <kfree>
      goto bad;
80107c29:	83 c4 10             	add    $0x10,%esp
80107c2c:	eb c5                	jmp    80107bf3 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80107c2e:	31 c0                	xor    %eax,%eax
80107c30:	eb d1                	jmp    80107c03 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107c32:	83 ec 0c             	sub    $0xc,%esp
80107c35:	68 fe 87 10 80       	push   $0x801087fe
80107c3a:	e8 31 87 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107c3f:	83 ec 0c             	sub    $0xc,%esp
80107c42:	68 e4 87 10 80       	push   $0x801087e4
80107c47:	e8 24 87 ff ff       	call   80100370 <panic>
80107c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c51:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c53:	89 e5                	mov    %esp,%ebp
80107c55:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c5e:	e8 3d f7 ff ff       	call   801073a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107c63:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107c65:	89 c2                	mov    %eax,%edx
80107c67:	83 e2 05             	and    $0x5,%edx
80107c6a:	83 fa 05             	cmp    $0x5,%edx
80107c6d:	75 11                	jne    80107c80 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107c6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107c74:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107c75:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107c7a:	c3                   	ret    
80107c7b:	90                   	nop
80107c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107c80:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107c82:	c9                   	leave  
80107c83:	c3                   	ret    
80107c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107c90:	55                   	push   %ebp
80107c91:	89 e5                	mov    %esp,%ebp
80107c93:	57                   	push   %edi
80107c94:	56                   	push   %esi
80107c95:	53                   	push   %ebx
80107c96:	83 ec 1c             	sub    $0x1c,%esp
80107c99:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ca2:	85 db                	test   %ebx,%ebx
80107ca4:	75 40                	jne    80107ce6 <copyout+0x56>
80107ca6:	eb 70                	jmp    80107d18 <copyout+0x88>
80107ca8:	90                   	nop
80107ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107cb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107cb3:	89 f1                	mov    %esi,%ecx
80107cb5:	29 d1                	sub    %edx,%ecx
80107cb7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107cbd:	39 d9                	cmp    %ebx,%ecx
80107cbf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107cc2:	29 f2                	sub    %esi,%edx
80107cc4:	83 ec 04             	sub    $0x4,%esp
80107cc7:	01 d0                	add    %edx,%eax
80107cc9:	51                   	push   %ecx
80107cca:	57                   	push   %edi
80107ccb:	50                   	push   %eax
80107ccc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107ccf:	e8 8c d5 ff ff       	call   80105260 <memmove>
    len -= n;
    buf += n;
80107cd4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107cd7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80107cda:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107ce0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ce2:	29 cb                	sub    %ecx,%ebx
80107ce4:	74 32                	je     80107d18 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107ce6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ce8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107ceb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107cee:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107cf4:	56                   	push   %esi
80107cf5:	ff 75 08             	pushl  0x8(%ebp)
80107cf8:	e8 53 ff ff ff       	call   80107c50 <uva2ka>
    if(pa0 == 0)
80107cfd:	83 c4 10             	add    $0x10,%esp
80107d00:	85 c0                	test   %eax,%eax
80107d02:	75 ac                	jne    80107cb0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107d0c:	5b                   	pop    %ebx
80107d0d:	5e                   	pop    %esi
80107d0e:	5f                   	pop    %edi
80107d0f:	5d                   	pop    %ebp
80107d10:	c3                   	ret    
80107d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107d1b:	31 c0                	xor    %eax,%eax
}
80107d1d:	5b                   	pop    %ebx
80107d1e:	5e                   	pop    %esi
80107d1f:	5f                   	pop    %edi
80107d20:	5d                   	pop    %ebp
80107d21:	c3                   	ret    
