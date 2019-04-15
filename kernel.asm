
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
8010004c:	68 a0 7c 10 80       	push   $0x80107ca0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 a5 4e 00 00       	call   80104f00 <initlock>
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
80100092:	68 a7 7c 10 80       	push   $0x80107ca7
80100097:	50                   	push   %eax
80100098:	e8 33 4d 00 00       	call   80104dd0 <initsleeplock>
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
801000e4:	e8 57 4f 00 00       	call   80105040 <acquire>
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
80100162:	e8 99 4f 00 00       	call   80105100 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 4c 00 00       	call   80104e10 <acquiresleep>
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
80100193:	68 ae 7c 10 80       	push   $0x80107cae
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
801001ae:	e8 fd 4c 00 00       	call   80104eb0 <holdingsleep>
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
801001cc:	68 bf 7c 10 80       	push   $0x80107cbf
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
801001ef:	e8 bc 4c 00 00       	call   80104eb0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 4c 00 00       	call   80104e70 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 30 4e 00 00       	call   80105040 <acquire>
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
8010025c:	e9 9f 4e 00 00       	jmp    80105100 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 7c 10 80       	push   $0x80107cc6
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
8010028c:	e8 af 4d 00 00       	call   80105040 <acquire>
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
801002c5:	e8 86 3c 00 00       	call   80103f50 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 30 36 00 00       	call   80103910 <myproc>
801002e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 0c 4e 00 00       	call   80105100 <release>
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
8010034d:	e8 ae 4d 00 00       	call   80105100 <release>
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
801003b2:	68 cd 7c 10 80       	push   $0x80107ccd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 c7 86 10 80 	movl   $0x801086c7,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 43 4b 00 00       	call   80104f20 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 7c 10 80       	push   $0x80107ce1
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
8010043a:	e8 51 64 00 00       	call   80106890 <uartputc>
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
801004ec:	e8 9f 63 00 00       	call   80106890 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 93 63 00 00       	call   80106890 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 87 63 00 00       	call   80106890 <uartputc>
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
80100524:	e8 e7 4c 00 00       	call   80105210 <memmove>
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
80100541:	e8 1a 4c 00 00       	call   80105160 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 7c 10 80       	push   $0x80107ce5
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
801005b1:	0f b6 92 10 7d 10 80 	movzbl -0x7fef82f0(%edx),%edx
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
8010061b:	e8 20 4a 00 00       	call   80105040 <acquire>
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
80100647:	e8 b4 4a 00 00       	call   80105100 <release>
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
8010071f:	e8 dc 49 00 00       	call   80105100 <release>
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
801007d0:	ba f8 7c 10 80       	mov    $0x80107cf8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 4b 48 00 00       	call   80105040 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 7c 10 80       	push   $0x80107cff
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
80100823:	e8 18 48 00 00       	call   80105040 <acquire>
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
80100888:	e8 73 48 00 00       	call   80105100 <release>
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
80100916:	e8 25 3b 00 00       	call   80104440 <wakeup>
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
80100997:	e9 04 3c 00 00       	jmp    801045a0 <procdump>
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
801009c6:	68 08 7d 10 80       	push   $0x80107d08
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 2b 45 00 00       	call   80104f00 <initlock>

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
80100a9c:	e8 4f 6f 00 00       	call   801079f0 <setupkvm>
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
80100afe:	e8 0d 6d 00 00       	call   80107810 <allocuvm>
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
80100b30:	e8 1b 6c 00 00       	call   80107750 <loaduvm>
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
80100b7a:	e8 f1 6d 00 00       	call   80107970 <freevm>
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
80100bb2:	e8 59 6c 00 00       	call   80107810 <allocuvm>
80100bb7:	83 c4 10             	add    $0x10,%esp
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	89 c6                	mov    %eax,%esi
80100bbe:	75 3a                	jne    80100bfa <exec+0x1ea>
        freevm(pgdir);
80100bc0:	83 ec 0c             	sub    $0xc,%esp
80100bc3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bc9:	e8 a2 6d 00 00       	call   80107970 <freevm>
80100bce:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd6:	e9 ac fe ff ff       	jmp    80100a87 <exec+0x77>
        end_op();
80100bdb:	e8 60 20 00 00       	call   80102c40 <end_op>
        cprintf("exec: fail\n");
80100be0:	83 ec 0c             	sub    $0xc,%esp
80100be3:	68 21 7d 10 80       	push   $0x80107d21
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
80100c0e:	e8 7d 6e 00 00       	call   80107a90 <clearpteu>
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
80100c41:	e8 3a 47 00 00       	call   80105380 <strlen>
80100c46:	f7 d0                	not    %eax
80100c48:	01 c3                	add    %eax,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c4a:	58                   	pop    %eax
80100c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c4e:	83 e3 fc             	and    $0xfffffffc,%ebx
        if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c51:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c54:	e8 27 47 00 00       	call   80105380 <strlen>
80100c59:	83 c0 01             	add    $0x1,%eax
80100c5c:	50                   	push   %eax
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c60:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c63:	53                   	push   %ebx
80100c64:	56                   	push   %esi
80100c65:	e8 86 6f 00 00       	call   80107bf0 <copyout>
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
80100ccf:	e8 1c 6f 00 00       	call   80107bf0 <copyout>
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
80100d10:	e8 2b 46 00 00       	call   80105340 <safestrcpy>
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
80100d47:	e8 f4 32 00 00       	call   80104040 <cleanProcOneThread>
    curproc->mainThread=curthread;
80100d4c:	89 f1                	mov    %esi,%ecx
80100d4e:	89 99 b4 03 00 00    	mov    %ebx,0x3b4(%ecx)
    switchuvm(curproc);
80100d54:	89 34 24             	mov    %esi,(%esp)
80100d57:	e8 54 68 00 00       	call   801075b0 <switchuvm>
    freevm(oldpgdir);
80100d5c:	89 3c 24             	mov    %edi,(%esp)
80100d5f:	e8 0c 6c 00 00       	call   80107970 <freevm>
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
80100d86:	68 2d 7d 10 80       	push   $0x80107d2d
80100d8b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d90:	e8 6b 41 00 00       	call   80104f00 <initlock>
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
80100db1:	e8 8a 42 00 00       	call   80105040 <acquire>
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
80100de1:	e8 1a 43 00 00       	call   80105100 <release>
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
80100dfa:	e8 01 43 00 00       	call   80105100 <release>
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
80100e1f:	e8 1c 42 00 00       	call   80105040 <acquire>
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
80100e3c:	e8 bf 42 00 00       	call   80105100 <release>
  return f;
}
80100e41:	89 d8                	mov    %ebx,%eax
80100e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e46:	c9                   	leave  
80100e47:	c3                   	ret    
    panic("filedup");
80100e48:	83 ec 0c             	sub    $0xc,%esp
80100e4b:	68 34 7d 10 80       	push   $0x80107d34
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
80100e71:	e8 ca 41 00 00       	call   80105040 <acquire>
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
80100e9c:	e9 5f 42 00 00       	jmp    80105100 <release>
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
80100ec8:	e8 33 42 00 00       	call   80105100 <release>
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
80100f22:	68 3c 7d 10 80       	push   $0x80107d3c
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
80101002:	68 46 7d 10 80       	push   $0x80107d46
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
80101115:	68 4f 7d 10 80       	push   $0x80107d4f
8010111a:	e8 71 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 55 7d 10 80       	push   $0x80107d55
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
801011d4:	68 5f 7d 10 80       	push   $0x80107d5f
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
80101215:	e8 46 3f 00 00       	call   80105160 <memset>
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
8010125a:	e8 e1 3d 00 00       	call   80105040 <acquire>
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
801012bf:	e8 3c 3e 00 00       	call   80105100 <release>

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
801012ed:	e8 0e 3e 00 00       	call   80105100 <release>
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
80101302:	68 75 7d 10 80       	push   $0x80107d75
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
801013d7:	68 85 7d 10 80       	push   $0x80107d85
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
80101411:	e8 fa 3d 00 00       	call   80105210 <memmove>
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
801014a4:	68 98 7d 10 80       	push   $0x80107d98
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
801014bc:	68 ab 7d 10 80       	push   $0x80107dab
801014c1:	68 00 1a 11 80       	push   $0x80111a00
801014c6:	e8 35 3a 00 00       	call   80104f00 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 b2 7d 10 80       	push   $0x80107db2
801014d8:	53                   	push   %ebx
801014d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014df:	e8 ec 38 00 00       	call   80104dd0 <initsleeplock>
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
80101529:	68 18 7e 10 80       	push   $0x80107e18
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
801015be:	e8 9d 3b 00 00       	call   80105160 <memset>
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
801015f3:	68 b8 7d 10 80       	push   $0x80107db8
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
80101661:	e8 aa 3b 00 00       	call   80105210 <memmove>
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
8010168f:	e8 ac 39 00 00       	call   80105040 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010169f:	e8 5c 3a 00 00       	call   80105100 <release>
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
801016d2:	e8 39 37 00 00       	call   80104e10 <acquiresleep>
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
80101748:	e8 c3 3a 00 00       	call   80105210 <memmove>
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
8010176d:	68 d0 7d 10 80       	push   $0x80107dd0
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 ca 7d 10 80       	push   $0x80107dca
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
801017a3:	e8 08 37 00 00       	call   80104eb0 <holdingsleep>
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
801017bf:	e9 ac 36 00 00       	jmp    80104e70 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 df 7d 10 80       	push   $0x80107ddf
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
801017f0:	e8 1b 36 00 00       	call   80104e10 <acquiresleep>
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
8010180a:	e8 61 36 00 00       	call   80104e70 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101816:	e8 25 38 00 00       	call   80105040 <acquire>
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
80101830:	e9 cb 38 00 00       	jmp    80105100 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 00 1a 11 80       	push   $0x80111a00
80101840:	e8 fb 37 00 00       	call   80105040 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010184f:	e8 ac 38 00 00       	call   80105100 <release>
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
80101a37:	e8 d4 37 00 00       	call   80105210 <memmove>
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
80101b33:	e8 d8 36 00 00       	call   80105210 <memmove>
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
80101bce:	e8 ad 36 00 00       	call   80105280 <strncmp>
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
80101c2d:	e8 4e 36 00 00       	call   80105280 <strncmp>
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
80101c72:	68 f9 7d 10 80       	push   $0x80107df9
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 e7 7d 10 80       	push   $0x80107de7
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
80101cb4:	68 00 1a 11 80       	push   $0x80111a00
80101cb9:	e8 82 33 00 00       	call   80105040 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cc9:	e8 32 34 00 00       	call   80105100 <release>
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
80101d25:	e8 e6 34 00 00       	call   80105210 <memmove>
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
80101db8:	e8 53 34 00 00       	call   80105210 <memmove>
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
80101ead:	e8 2e 34 00 00       	call   801052e0 <strncpy>
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
80101eeb:	68 08 7e 10 80       	push   $0x80107e08
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 ae 84 10 80       	push   $0x801084ae
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
8010200b:	68 74 7e 10 80       	push   $0x80107e74
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 6b 7e 10 80       	push   $0x80107e6b
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 86 7e 10 80       	push   $0x80107e86
8010203b:	68 80 b5 10 80       	push   $0x8010b580
80102040:	e8 bb 2e 00 00       	call   80104f00 <initlock>
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
801020be:	e8 7d 2f 00 00       	call   80105040 <acquire>

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
80102121:	e8 1a 23 00 00       	call   80104440 <wakeup>

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
8010213f:	e8 bc 2f 00 00       	call   80105100 <release>

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
8010215e:	e8 4d 2d 00 00       	call   80104eb0 <holdingsleep>
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
80102198:	e8 a3 2e 00 00       	call   80105040 <acquire>

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
801021e9:	e8 62 1d 00 00       	call   80103f50 <sleep>
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
80102206:	e9 f5 2e 00 00       	jmp    80105100 <release>
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
8010222a:	68 a0 7e 10 80       	push   $0x80107ea0
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 8a 7e 10 80       	push   $0x80107e8a
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 b5 7e 10 80       	push   $0x80107eb5
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
80102297:	68 d4 7e 10 80       	push   $0x80107ed4
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
80102352:	81 fb 28 43 12 80    	cmp    $0x80124328,%ebx
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
80102372:	e8 e9 2d 00 00       	call   80105160 <memset>

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
801023ab:	e9 50 2d 00 00       	jmp    80105100 <release>
    acquire(&kmem.lock);
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 60 36 11 80       	push   $0x80113660
801023b8:	e8 83 2c 00 00       	call   80105040 <acquire>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	eb c2                	jmp    80102384 <kfree+0x44>
    panic("kfree");
801023c2:	83 ec 0c             	sub    $0xc,%esp
801023c5:	68 06 7f 10 80       	push   $0x80107f06
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
8010242b:	68 0c 7f 10 80       	push   $0x80107f0c
80102430:	68 60 36 11 80       	push   $0x80113660
80102435:	e8 c6 2a 00 00       	call   80104f00 <initlock>
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
80102523:	e8 18 2b 00 00       	call   80105040 <acquire>
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
80102551:	e8 aa 2b 00 00       	call   80105100 <release>
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
801025a3:	0f b6 82 40 80 10 80 	movzbl -0x7fef7fc0(%edx),%eax
801025aa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ac:	0f b6 82 40 7f 10 80 	movzbl -0x7fef80c0(%edx),%eax
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
801025c3:	8b 04 85 20 7f 10 80 	mov    -0x7fef80e0(,%eax,4),%eax
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
801025e8:	0f b6 82 40 80 10 80 	movzbl -0x7fef7fc0(%edx),%eax
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
80102967:	e8 44 28 00 00       	call   801051b0 <memcmp>
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
80102a94:	e8 77 27 00 00       	call   80105210 <memmove>
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
80102b3a:	68 40 81 10 80       	push   $0x80108140
80102b3f:	68 a0 36 11 80       	push   $0x801136a0
80102b44:	e8 b7 23 00 00       	call   80104f00 <initlock>
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
80102bdb:	e8 60 24 00 00       	call   80105040 <acquire>
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	eb 18                	jmp    80102bfd <begin_op+0x2d>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	83 ec 08             	sub    $0x8,%esp
80102beb:	68 a0 36 11 80       	push   $0x801136a0
80102bf0:	68 a0 36 11 80       	push   $0x801136a0
80102bf5:	e8 56 13 00 00       	call   80103f50 <sleep>
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
80102c2c:	e8 cf 24 00 00       	call   80105100 <release>
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
80102c4e:	e8 ed 23 00 00       	call   80105040 <acquire>
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
80102c8c:	e8 6f 24 00 00       	call   80105100 <release>
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
80102ce6:	e8 25 25 00 00       	call   80105210 <memmove>
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
80102d2f:	e8 0c 23 00 00       	call   80105040 <acquire>
    wakeup(&log);
80102d34:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102d3b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102d42:	00 00 00 
    wakeup(&log);
80102d45:	e8 f6 16 00 00       	call   80104440 <wakeup>
    release(&log.lock);
80102d4a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d51:	e8 aa 23 00 00       	call   80105100 <release>
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
80102d70:	e8 cb 16 00 00       	call   80104440 <wakeup>
  release(&log.lock);
80102d75:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d7c:	e8 7f 23 00 00       	call   80105100 <release>
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
80102d8f:	68 44 81 10 80       	push   $0x80108144
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
80102dde:	e8 5d 22 00 00       	call   80105040 <acquire>
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
80102e2d:	e9 ce 22 00 00       	jmp    80105100 <release>
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
80102e59:	68 53 81 10 80       	push   $0x80108153
80102e5e:	e8 2d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e63:	83 ec 0c             	sub    $0xc,%esp
80102e66:	68 69 81 10 80       	push   $0x80108169
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
80102e88:	68 84 81 10 80       	push   $0x80108184
80102e8d:	e8 ce d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e92:	e8 09 36 00 00       	call   801064a0 <idtinit>
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
80102eaa:	e8 61 0e 00 00       	call   80103d10 <scheduler>
80102eaf:	90                   	nop

80102eb0 <mpenter>:
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102eb6:	e8 d5 46 00 00       	call   80107590 <switchkvm>
  seginit();
80102ebb:	e8 40 46 00 00       	call   80107500 <seginit>
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
80102ee7:	68 28 43 12 80       	push   $0x80124328
80102eec:	e8 2f f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102ef1:	e8 7a 4b 00 00       	call   80107a70 <kvmalloc>
  mpinit();        // detect other processors
80102ef6:	e8 75 01 00 00       	call   80103070 <mpinit>
  lapicinit();     // interrupt controller
80102efb:	e8 60 f7 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102f00:	e8 fb 45 00 00       	call   80107500 <seginit>
  picinit();       // disable pic
80102f05:	e8 46 03 00 00       	call   80103250 <picinit>
  ioapicinit();    // another interrupt controller
80102f0a:	e8 41 f3 ff ff       	call   80102250 <ioapicinit>
  consoleinit();   // console hardware
80102f0f:	e8 ac da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f14:	e8 b7 38 00 00       	call   801067d0 <uartinit>
  pinit();         // process table
80102f19:	e8 a2 08 00 00       	call   801037c0 <pinit>
  tvinit();        // trap vectors
80102f1e:	e8 fd 34 00 00       	call   80106420 <tvinit>
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
80102f44:	e8 c7 22 00 00       	call   80105210 <memmove>

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
8010301e:	68 98 81 10 80       	push   $0x80108198
80103023:	56                   	push   %esi
80103024:	e8 87 21 00 00       	call   801051b0 <memcmp>
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
801030dc:	68 b5 81 10 80       	push   $0x801081b5
801030e1:	56                   	push   %esi
801030e2:	e8 c9 20 00 00       	call   801051b0 <memcmp>
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
80103170:	ff 24 95 dc 81 10 80 	jmp    *-0x7fef7e24(,%edx,4)
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
80103223:	68 9d 81 10 80       	push   $0x8010819d
80103228:	e8 63 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 bc 81 10 80       	push   $0x801081bc
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
8010332b:	68 f0 81 10 80       	push   $0x801081f0
80103330:	50                   	push   %eax
80103331:	e8 ca 1b 00 00       	call   80104f00 <initlock>
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
8010338f:	e8 ac 1c 00 00       	call   80105040 <acquire>
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
801033af:	e8 8c 10 00 00       	call   80104440 <wakeup>
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
801033d4:	e9 27 1d 00 00       	jmp    80105100 <release>
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033e6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033f0:	00 00 00 
    wakeup(&p->nwrite);
801033f3:	50                   	push   %eax
801033f4:	e8 47 10 00 00       	call   80104440 <wakeup>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	eb b9                	jmp    801033b7 <pipeclose+0x37>
801033fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	53                   	push   %ebx
80103404:	e8 f7 1c 00 00       	call   80105100 <release>
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
8010342d:	e8 0e 1c 00 00       	call   80105040 <acquire>
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
80103484:	e8 b7 0f 00 00       	call   80104440 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103489:	5a                   	pop    %edx
8010348a:	59                   	pop    %ecx
8010348b:	53                   	push   %ebx
8010348c:	56                   	push   %esi
8010348d:	e8 be 0a 00 00       	call   80103f50 <sleep>
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
801034b4:	e8 57 04 00 00       	call   80103910 <myproc>
801034b9:	8b 40 1c             	mov    0x1c(%eax),%eax
801034bc:	85 c0                	test   %eax,%eax
801034be:	74 c0                	je     80103480 <pipewrite+0x60>
        release(&p->lock);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	53                   	push   %ebx
801034c4:	e8 37 1c 00 00       	call   80105100 <release>
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
80103513:	e8 28 0f 00 00       	call   80104440 <wakeup>
  release(&p->lock);
80103518:	89 1c 24             	mov    %ebx,(%esp)
8010351b:	e8 e0 1b 00 00       	call   80105100 <release>
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
80103540:	e8 fb 1a 00 00       	call   80105040 <acquire>
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
80103575:	e8 d6 09 00 00       	call   80103f50 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010357a:	83 c4 10             	add    $0x10,%esp
8010357d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103583:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103589:	75 35                	jne    801035c0 <piperead+0x90>
8010358b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
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
801035ae:	e8 4d 1b 00 00       	call   80105100 <release>
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
80103607:	e8 34 0e 00 00       	call   80104440 <wakeup>
  release(&p->lock);
8010360c:	89 34 24             	mov    %esi,(%esp)
8010360f:	e8 ec 1a 00 00       	call   80105100 <release>
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
80103641:	68 f5 81 10 80       	push   $0x801081f5
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
80103651:	bb d4 4b 11 80       	mov    $0x80114bd4,%ebx
    acquire(&ptable.lock);
80103656:	68 a0 4b 11 80       	push   $0x80114ba0
8010365b:	e8 e0 19 00 00       	call   80105040 <acquire>
80103660:	83 c4 10             	add    $0x10,%esp
80103663:	eb 11                	jmp    80103676 <allocproc+0x46>
80103665:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103668:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
8010366e:	81 fb d4 3a 12 80    	cmp    $0x80123ad4,%ebx
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
8010367d:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
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
8010369d:	89 15 0c b0 10 80    	mov    %edx,0x8010b00c
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
801036c3:	68 a0 4b 11 80       	push   $0x80114ba0
801036c8:	e8 33 1a 00 00       	call   80105100 <release>
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
801036f2:	89 b3 b4 03 00 00    	mov    %esi,0x3b4(%ebx)
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
8010371b:	c7 40 14 0f 64 10 80 	movl   $0x8010640f,0x14(%eax)
    t->context = (struct context *) sp;
80103722:	89 46 14             	mov    %eax,0x14(%esi)
    memset(t->context, 0, sizeof *t->context);
80103725:	6a 14                	push   $0x14
80103727:	6a 00                	push   $0x0
80103729:	50                   	push   %eax
8010372a:	e8 31 1a 00 00       	call   80105160 <memset>
    t->context->eip = (uint) forkret;
8010372f:	8b 46 14             	mov    0x14(%esi),%eax
80103732:	c7 40 10 70 37 10 80 	movl   $0x80103770,0x10(%eax)
    release(&ptable.lock);
80103739:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103740:	e8 bb 19 00 00       	call   80105100 <release>
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
80103776:	68 a0 4b 11 80       	push   $0x80114ba0
8010377b:	e8 80 19 00 00       	call   80105100 <release>

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
801037c6:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
801037cc:	85 c9                	test   %ecx,%ecx
801037ce:	7e 10                	jle    801037e0 <pinit+0x20>
        cprintf(" PINIT ");
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	68 01 82 10 80       	push   $0x80108201
801037d8:	e8 83 ce ff ff       	call   80100660 <cprintf>
801037dd:	83 c4 10             	add    $0x10,%esp
    initlock(&ptable.lock, "ptable");
801037e0:	83 ec 08             	sub    $0x8,%esp
801037e3:	68 09 82 10 80       	push   $0x80108209
801037e8:	68 a0 4b 11 80       	push   $0x80114ba0
801037ed:	e8 0e 17 00 00       	call   80104f00 <initlock>
    initlock(&mtable.lock, "mtable");
801037f2:	58                   	pop    %eax
801037f3:	5a                   	pop    %edx
801037f4:	68 10 82 10 80       	push   $0x80108210
801037f9:	68 60 3d 11 80       	push   $0x80113d60
801037fe:	e8 fd 16 00 00       	call   80104f00 <initlock>
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
8010383a:	c6 43 20 00          	movb   $0x0,0x20(%ebx)
    t->killed = 0;
8010383e:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    memset(t->tf, 0, sizeof(*t->tf));
80103845:	6a 4c                	push   $0x4c
80103847:	6a 00                	push   $0x0
80103849:	ff 73 10             	pushl  0x10(%ebx)
8010384c:	e8 0f 19 00 00       	call   80105160 <memset>
    memset(t->context, 0, sizeof(*t->context));
80103851:	83 c4 0c             	add    $0xc,%esp
80103854:	6a 14                	push   $0x14
80103856:	6a 00                	push   $0x0
80103858:	ff 73 14             	pushl  0x14(%ebx)
8010385b:	e8 00 19 00 00       	call   80105160 <memset>
}
80103860:	83 c4 10             	add    $0x10,%esp
80103863:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103866:	c9                   	leave  
80103867:	c3                   	ret    
80103868:	90                   	nop
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
80103881:	8b 35 40 3d 11 80    	mov    0x80113d40,%esi
80103887:	85 f6                	test   %esi,%esi
80103889:	7e 42                	jle    801038cd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010388b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103892:	39 d0                	cmp    %edx,%eax
80103894:	74 30                	je     801038c6 <mycpu+0x56>
80103896:	b9 54 38 11 80       	mov    $0x80113854,%ecx
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
801038ba:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
801038bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c2:	5b                   	pop    %ebx
801038c3:	5e                   	pop    %esi
801038c4:	5d                   	pop    %ebp
801038c5:	c3                   	ret    
        if (cpus[i].apicid == apicid)
801038c6:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
            return &cpus[i];
801038cb:	eb f2                	jmp    801038bf <mycpu+0x4f>
    panic("unknown apicid\n");
801038cd:	83 ec 0c             	sub    $0xc,%esp
801038d0:	68 17 82 10 80       	push   $0x80108217
801038d5:	e8 b6 ca ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	68 7c 83 10 80       	push   $0x8010837c
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
801038fb:	2d a0 37 11 80       	sub    $0x801137a0,%eax
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
80103917:	e8 54 16 00 00       	call   80104f70 <pushcli>
    c = mycpu();
8010391c:	e8 4f ff ff ff       	call   80103870 <mycpu>
    p = c->proc;
80103921:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103927:	e8 84 16 00 00       	call   80104fb0 <popcli>
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
80103947:	e8 24 16 00 00       	call   80104f70 <pushcli>
    c = mycpu();
8010394c:	e8 1f ff ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103951:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103957:	e8 54 16 00 00       	call   80104fb0 <popcli>
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
8010397e:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
    if ((p->pgdir = setupkvm()) == 0)
80103983:	e8 68 40 00 00       	call   801079f0 <setupkvm>
80103988:	85 c0                	test   %eax,%eax
8010398a:	89 43 04             	mov    %eax,0x4(%ebx)
8010398d:	0f 84 2d 01 00 00    	je     80103ac0 <userinit+0x150>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103993:	83 ec 04             	sub    $0x4,%esp
80103996:	68 2c 00 00 00       	push   $0x2c
8010399b:	68 60 b4 10 80       	push   $0x8010b460
801039a0:	50                   	push   %eax
801039a1:	e8 2a 3d 00 00       	call   801076d0 <inituvm>
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
801039a6:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
801039a9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
801039af:	6a 4c                	push   $0x4c
801039b1:	6a 00                	push   $0x0
801039b3:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039b9:	ff 70 10             	pushl  0x10(%eax)
801039bc:	e8 9f 17 00 00       	call   80105160 <memset>
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039c1:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039c7:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039cc:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
801039d1:	83 c4 0c             	add    $0xc,%esp
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039d4:	8b 40 10             	mov    0x10(%eax),%eax
801039d7:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039db:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039e1:	8b 40 10             	mov    0x10(%eax),%eax
801039e4:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->mainThread->tf->es = p->mainThread->tf->ds;
801039e8:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039ee:	8b 40 10             	mov    0x10(%eax),%eax
801039f1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039f5:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->mainThread->tf->ss = p->mainThread->tf->ds;
801039f9:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801039ff:	8b 40 10             	mov    0x10(%eax),%eax
80103a02:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a06:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->mainThread->tf->eflags = FL_IF;
80103a0a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103a10:	8b 40 10             	mov    0x10(%eax),%eax
80103a13:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->mainThread->tf->esp = PGSIZE;
80103a1a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103a20:	8b 40 10             	mov    0x10(%eax),%eax
80103a23:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->mainThread->tf->eip = 0;  // beginning of initcode.S
80103a2a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103a30:	8b 40 10             	mov    0x10(%eax),%eax
80103a33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103a3a:	8d 43 64             	lea    0x64(%ebx),%eax
80103a3d:	6a 10                	push   $0x10
80103a3f:	68 40 82 10 80       	push   $0x80108240
80103a44:	50                   	push   %eax
80103a45:	e8 f6 18 00 00       	call   80105340 <safestrcpy>
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
80103a4a:	83 c4 0c             	add    $0xc,%esp
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 49 82 10 80       	push   $0x80108249
80103a54:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103a5a:	83 c0 20             	add    $0x20,%eax
80103a5d:	50                   	push   %eax
80103a5e:	e8 dd 18 00 00       	call   80105340 <safestrcpy>
    p->cwd = namei("/");
80103a63:	c7 04 24 54 82 10 80 	movl   $0x80108254,(%esp)
80103a6a:	e8 a1 e4 ff ff       	call   80101f10 <namei>
80103a6f:	89 43 60             	mov    %eax,0x60(%ebx)
    acquire(&ptable.lock);
80103a72:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103a79:	e8 c2 15 00 00       	call   80105040 <acquire>
    p->mainThread->state = RUNNABLE;
80103a7e:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
    p->state = RUNNABLE;
80103a84:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    p->mainThread->state = RUNNABLE;
80103a8b:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103a92:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103a99:	e8 62 16 00 00       	call   80105100 <release>
    if (DEBUGMODE > 0)
80103a9e:	8b 1d b8 b5 10 80    	mov    0x8010b5b8,%ebx
80103aa4:	83 c4 10             	add    $0x10,%esp
80103aa7:	85 db                	test   %ebx,%ebx
80103aa9:	7e 10                	jle    80103abb <userinit+0x14b>
        cprintf("DONE USERINIT");
80103aab:	83 ec 0c             	sub    $0xc,%esp
80103aae:	68 56 82 10 80       	push   $0x80108256
80103ab3:	e8 a8 cb ff ff       	call   80100660 <cprintf>
80103ab8:	83 c4 10             	add    $0x10,%esp
}
80103abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103abe:	c9                   	leave  
80103abf:	c3                   	ret    
        panic("userinit: out of memory?");
80103ac0:	83 ec 0c             	sub    $0xc,%esp
80103ac3:	68 27 82 10 80       	push   $0x80108227
80103ac8:	e8 c3 c8 ff ff       	call   80100390 <panic>
80103acd:	8d 76 00             	lea    0x0(%esi),%esi

80103ad0 <growproc>:
growproc(int n) {
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103ad8:	e8 93 14 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80103add:	e8 8e fd ff ff       	call   80103870 <mycpu>
    p = c->proc;
80103ae2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ae8:	e8 c3 14 00 00       	call   80104fb0 <popcli>
    if (DEBUGMODE > 0)
80103aed:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103af2:	85 c0                	test   %eax,%eax
80103af4:	7e 10                	jle    80103b06 <growproc+0x36>
        cprintf(" GROWPROC APPLYED ");
80103af6:	83 ec 0c             	sub    $0xc,%esp
80103af9:	68 64 82 10 80       	push   $0x80108264
80103afe:	e8 5d cb ff ff       	call   80100660 <cprintf>
80103b03:	83 c4 10             	add    $0x10,%esp
    if (n > 0) {
80103b06:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103b09:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103b0b:	7f 23                	jg     80103b30 <growproc+0x60>
    } else if (n < 0) {
80103b0d:	75 41                	jne    80103b50 <growproc+0x80>
    switchuvm(curproc);
80103b0f:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103b12:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103b14:	53                   	push   %ebx
80103b15:	e8 96 3a 00 00       	call   801075b0 <switchuvm>
    return 0;
80103b1a:	83 c4 10             	add    $0x10,%esp
80103b1d:	31 c0                	xor    %eax,%eax
}
80103b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b22:	5b                   	pop    %ebx
80103b23:	5e                   	pop    %esi
80103b24:	5d                   	pop    %ebp
80103b25:	c3                   	ret    
80103b26:	8d 76 00             	lea    0x0(%esi),%esi
80103b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	pushl  0x4(%ebx)
80103b3a:	e8 d1 3c 00 00       	call   80107810 <allocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 c9                	jne    80103b0f <growproc+0x3f>
            return -1;
80103b46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b4b:	eb d2                	jmp    80103b1f <growproc+0x4f>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 c6                	add    %eax,%esi
80103b55:	56                   	push   %esi
80103b56:	50                   	push   %eax
80103b57:	ff 73 04             	pushl  0x4(%ebx)
80103b5a:	e8 e1 3d 00 00       	call   80107940 <deallocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	75 a9                	jne    80103b0f <growproc+0x3f>
80103b66:	eb de                	jmp    80103b46 <growproc+0x76>
80103b68:	90                   	nop
80103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b70 <fork>:
fork(void) {
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103b79:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103b7e:	85 c0                	test   %eax,%eax
80103b80:	7e 10                	jle    80103b92 <fork+0x22>
        cprintf(" FORK ");
80103b82:	83 ec 0c             	sub    $0xc,%esp
80103b85:	68 77 82 10 80       	push   $0x80108277
80103b8a:	e8 d1 ca ff ff       	call   80100660 <cprintf>
80103b8f:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103b92:	e8 d9 13 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80103b97:	e8 d4 fc ff ff       	call   80103870 <mycpu>
    p = c->proc;
80103b9c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103ba2:	89 55 e0             	mov    %edx,-0x20(%ebp)
    popcli();
80103ba5:	e8 06 14 00 00       	call   80104fb0 <popcli>
    pushcli();
80103baa:	e8 c1 13 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80103baf:	e8 bc fc ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103bb4:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103bba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80103bbd:	e8 ee 13 00 00       	call   80104fb0 <popcli>
    if ((np = allocproc()) == 0) {
80103bc2:	e8 69 fa ff ff       	call   80103630 <allocproc>
80103bc7:	85 c0                	test   %eax,%eax
80103bc9:	89 c3                	mov    %eax,%ebx
80103bcb:	0f 84 f4 00 00 00    	je     80103cc5 <fork+0x155>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103bd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103bd4:	83 ec 08             	sub    $0x8,%esp
80103bd7:	ff 32                	pushl  (%edx)
80103bd9:	ff 72 04             	pushl  0x4(%edx)
80103bdc:	e8 df 3e 00 00       	call   80107ac0 <copyuvm>
80103be1:	83 c4 10             	add    $0x10,%esp
80103be4:	85 c0                	test   %eax,%eax
80103be6:	89 43 04             	mov    %eax,0x4(%ebx)
80103be9:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103bec:	0f 84 da 00 00 00    	je     80103ccc <fork+0x15c>
    np->sz = curproc->sz;
80103bf2:	8b 02                	mov    (%edx),%eax
    np->parent = curproc;
80103bf4:	89 53 10             	mov    %edx,0x10(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103bf7:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103bfc:	89 03                	mov    %eax,(%ebx)
    *np->mainThread->tf = *curthread->tf;
80103bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c01:	8b 70 10             	mov    0x10(%eax),%esi
80103c04:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c0a:	8b 40 10             	mov    0x10(%eax),%eax
80103c0d:	89 c7                	mov    %eax,%edi
80103c0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103c11:	31 f6                	xor    %esi,%esi
80103c13:	89 d7                	mov    %edx,%edi
    np->mainThread->tf->eax = 0;
80103c15:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c1b:	8b 40 10             	mov    0x10(%eax),%eax
80103c1e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103c25:	8d 76 00             	lea    0x0(%esi),%esi
        if (curproc->ofile[i])
80103c28:	8b 44 b7 20          	mov    0x20(%edi,%esi,4),%eax
80103c2c:	85 c0                	test   %eax,%eax
80103c2e:	74 10                	je     80103c40 <fork+0xd0>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	50                   	push   %eax
80103c34:	e8 d7 d1 ff ff       	call   80100e10 <filedup>
80103c39:	83 c4 10             	add    $0x10,%esp
80103c3c:	89 44 b3 20          	mov    %eax,0x20(%ebx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103c40:	83 c6 01             	add    $0x1,%esi
80103c43:	83 fe 10             	cmp    $0x10,%esi
80103c46:	75 e0                	jne    80103c28 <fork+0xb8>
    np->cwd = idup(curproc->cwd);
80103c48:	83 ec 0c             	sub    $0xc,%esp
80103c4b:	ff 77 60             	pushl  0x60(%edi)
80103c4e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80103c51:	e8 2a da ff ff       	call   80101680 <idup>
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c56:	8b 55 e0             	mov    -0x20(%ebp),%edx
    np->cwd = idup(curproc->cwd);
80103c59:	89 43 60             	mov    %eax,0x60(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c5c:	8d 43 64             	lea    0x64(%ebx),%eax
80103c5f:	83 c4 0c             	add    $0xc,%esp
80103c62:	6a 10                	push   $0x10
80103c64:	83 c2 64             	add    $0x64,%edx
80103c67:	52                   	push   %edx
80103c68:	50                   	push   %eax
80103c69:	e8 d2 16 00 00       	call   80105340 <safestrcpy>
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));
80103c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c71:	83 c4 0c             	add    $0xc,%esp
80103c74:	6a 10                	push   $0x10
80103c76:	83 c0 20             	add    $0x20,%eax
80103c79:	50                   	push   %eax
80103c7a:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103c80:	83 c0 20             	add    $0x20,%eax
80103c83:	50                   	push   %eax
80103c84:	e8 b7 16 00 00       	call   80105340 <safestrcpy>
    pid = np->pid;
80103c89:	8b 73 0c             	mov    0xc(%ebx),%esi
    acquire(&ptable.lock);
80103c8c:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103c93:	e8 a8 13 00 00       	call   80105040 <acquire>
    np->mainThread->state = RUNNABLE;
80103c98:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
    np->state = RUNNABLE;
80103c9e:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    np->mainThread->state = RUNNABLE;
80103ca5:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
    release(&ptable.lock);
80103cac:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103cb3:	e8 48 14 00 00       	call   80105100 <release>
    return pid;
80103cb8:	83 c4 10             	add    $0x10,%esp
}
80103cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cbe:	89 f0                	mov    %esi,%eax
80103cc0:	5b                   	pop    %ebx
80103cc1:	5e                   	pop    %esi
80103cc2:	5f                   	pop    %edi
80103cc3:	5d                   	pop    %ebp
80103cc4:	c3                   	ret    
        return -1;
80103cc5:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103cca:	eb ef                	jmp    80103cbb <fork+0x14b>
        kfree(np->mainThread->tkstack);
80103ccc:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80103cd2:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103cd5:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->mainThread->tkstack);
80103cda:	ff 70 04             	pushl  0x4(%eax)
80103cdd:	e8 5e e6 ff ff       	call   80102340 <kfree>
        np->mainThread->tkstack = 0;
80103ce2:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
        return -1;
80103ce8:	83 c4 10             	add    $0x10,%esp
        np->mainThread->tkstack = 0;
80103ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        np->mainThread->state = UNUSED;
80103cf2:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
        np->state = UNUSED;
80103cf8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->mainThread->state = UNUSED;
80103cff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return -1;
80103d06:	eb b3                	jmp    80103cbb <fork+0x14b>
80103d08:	90                   	nop
80103d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d10 <scheduler>:
scheduler(void) {
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 0)
80103d19:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	7e 10                	jle    80103d32 <scheduler+0x22>
        cprintf(" SCHEDULER ");
80103d22:	83 ec 0c             	sub    $0xc,%esp
80103d25:	68 7e 82 10 80       	push   $0x8010827e
80103d2a:	e8 31 c9 ff ff       	call   80100660 <cprintf>
80103d2f:	83 c4 10             	add    $0x10,%esp
    struct cpu *c = mycpu();
80103d32:	e8 39 fb ff ff       	call   80103870 <mycpu>
    c->proc = 0;
80103d37:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d3e:	00 00 00 
    struct cpu *c = mycpu();
80103d41:	89 c6                	mov    %eax,%esi
80103d43:	8d 40 04             	lea    0x4(%eax),%eax
80103d46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103d50:	fb                   	sti    
        acquire(&ptable.lock);
80103d51:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d54:	bf d4 4b 11 80       	mov    $0x80114bd4,%edi
        acquire(&ptable.lock);
80103d59:	68 a0 4b 11 80       	push   $0x80114ba0
80103d5e:	e8 dd 12 00 00       	call   80105040 <acquire>
80103d63:	83 c4 10             	add    $0x10,%esp
80103d66:	eb 1a                	jmp    80103d82 <scheduler+0x72>
80103d68:	90                   	nop
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d70:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
80103d76:	81 ff d4 3a 12 80    	cmp    $0x80123ad4,%edi
80103d7c:	0f 83 8c 00 00 00    	jae    80103e0e <scheduler+0xfe>
            if (p->state != RUNNABLE)
80103d82:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d86:	75 e8                	jne    80103d70 <scheduler+0x60>
            switchuvm(p);
80103d88:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80103d8b:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
80103d91:	8d 5f 74             	lea    0x74(%edi),%ebx
            switchuvm(p);
80103d94:	57                   	push   %edi
80103d95:	e8 16 38 00 00       	call   801075b0 <switchuvm>
80103d9a:	8d 97 b4 03 00 00    	lea    0x3b4(%edi),%edx
80103da0:	83 c4 10             	add    $0x10,%esp
80103da3:	90                   	nop
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if (t->state != RUNNABLE)
80103da8:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103dac:	75 2e                	jne    80103ddc <scheduler+0xcc>
                t->state = RUNNING;
80103dae:	c7 43 08 04 00 00 00 	movl   $0x4,0x8(%ebx)
                swtch(&(c->scheduler), t->context);
80103db5:	83 ec 08             	sub    $0x8,%esp
                c->currThread = t;
80103db8:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)
                swtch(&(c->scheduler), t->context);
80103dbe:	ff 73 14             	pushl  0x14(%ebx)
80103dc1:	ff 75 e0             	pushl  -0x20(%ebp)
80103dc4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103dc7:	e8 cf 15 00 00       	call   8010539b <swtch>
                c->currThread = 0;
80103dcc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dcf:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103dd6:	00 00 00 
80103dd9:	83 c4 10             	add    $0x10,%esp
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80103ddc:	83 c3 34             	add    $0x34,%ebx
80103ddf:	39 da                	cmp    %ebx,%edx
80103de1:	77 c5                	ja     80103da8 <scheduler+0x98>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103de3:	81 c7 bc 03 00 00    	add    $0x3bc,%edi
            switchkvm();
80103de9:	e8 a2 37 00 00       	call   80107590 <switchkvm>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dee:	81 ff d4 3a 12 80    	cmp    $0x80123ad4,%edi
            c->proc = 0;
80103df4:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103dfb:	00 00 00 
            c->currThread = 0;
80103dfe:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80103e05:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e08:	0f 82 74 ff ff ff    	jb     80103d82 <scheduler+0x72>
        release(&ptable.lock);
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	68 a0 4b 11 80       	push   $0x80114ba0
80103e16:	e8 e5 12 00 00       	call   80105100 <release>
        sti();
80103e1b:	83 c4 10             	add    $0x10,%esp
80103e1e:	e9 2d ff ff ff       	jmp    80103d50 <scheduler+0x40>
80103e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e30 <sched>:
    if (DEBUGMODE > 1)
80103e30:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
sched(void) {
80103e37:	55                   	push   %ebp
80103e38:	89 e5                	mov    %esp,%ebp
80103e3a:	56                   	push   %esi
80103e3b:	53                   	push   %ebx
    if (DEBUGMODE > 1)
80103e3c:	7e 10                	jle    80103e4e <sched+0x1e>
        cprintf(" SCHED ");
80103e3e:	83 ec 0c             	sub    $0xc,%esp
80103e41:	68 8a 82 10 80       	push   $0x8010828a
80103e46:	e8 15 c8 ff ff       	call   80100660 <cprintf>
80103e4b:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103e4e:	e8 1d 11 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80103e53:	e8 18 fa ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103e58:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103e5e:	e8 4d 11 00 00       	call   80104fb0 <popcli>
    if (!holding(&ptable.lock))
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	68 a0 4b 11 80       	push   $0x80114ba0
80103e6b:	e8 a0 11 00 00       	call   80105010 <holding>
80103e70:	83 c4 10             	add    $0x10,%esp
80103e73:	85 c0                	test   %eax,%eax
80103e75:	74 4f                	je     80103ec6 <sched+0x96>
    if (mycpu()->ncli != 1)
80103e77:	e8 f4 f9 ff ff       	call   80103870 <mycpu>
80103e7c:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e83:	75 68                	jne    80103eed <sched+0xbd>
    if (t->state == RUNNING)
80103e85:	83 7b 08 04          	cmpl   $0x4,0x8(%ebx)
80103e89:	74 55                	je     80103ee0 <sched+0xb0>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e8b:	9c                   	pushf  
80103e8c:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103e8d:	f6 c4 02             	test   $0x2,%ah
80103e90:	75 41                	jne    80103ed3 <sched+0xa3>
    intena = mycpu()->intena;
80103e92:	e8 d9 f9 ff ff       	call   80103870 <mycpu>
    swtch(&t->context, mycpu()->scheduler);
80103e97:	83 c3 14             	add    $0x14,%ebx
    intena = mycpu()->intena;
80103e9a:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&t->context, mycpu()->scheduler);
80103ea0:	e8 cb f9 ff ff       	call   80103870 <mycpu>
80103ea5:	83 ec 08             	sub    $0x8,%esp
80103ea8:	ff 70 04             	pushl  0x4(%eax)
80103eab:	53                   	push   %ebx
80103eac:	e8 ea 14 00 00       	call   8010539b <swtch>
    mycpu()->intena = intena;
80103eb1:	e8 ba f9 ff ff       	call   80103870 <mycpu>
}
80103eb6:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80103eb9:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ec2:	5b                   	pop    %ebx
80103ec3:	5e                   	pop    %esi
80103ec4:	5d                   	pop    %ebp
80103ec5:	c3                   	ret    
        panic("sched ptable.lock");
80103ec6:	83 ec 0c             	sub    $0xc,%esp
80103ec9:	68 92 82 10 80       	push   $0x80108292
80103ece:	e8 bd c4 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
80103ed3:	83 ec 0c             	sub    $0xc,%esp
80103ed6:	68 be 82 10 80       	push   $0x801082be
80103edb:	e8 b0 c4 ff ff       	call   80100390 <panic>
        panic("sched running");
80103ee0:	83 ec 0c             	sub    $0xc,%esp
80103ee3:	68 b0 82 10 80       	push   $0x801082b0
80103ee8:	e8 a3 c4 ff ff       	call   80100390 <panic>
        panic("sched locks");
80103eed:	83 ec 0c             	sub    $0xc,%esp
80103ef0:	68 a4 82 10 80       	push   $0x801082a4
80103ef5:	e8 96 c4 ff ff       	call   80100390 <panic>
80103efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f00 <yield>:
yield(void) {
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103f07:	68 a0 4b 11 80       	push   $0x80114ba0
80103f0c:	e8 2f 11 00 00       	call   80105040 <acquire>
    pushcli();
80103f11:	e8 5a 10 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80103f16:	e8 55 f9 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103f1b:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80103f21:	e8 8a 10 00 00       	call   80104fb0 <popcli>
    mythread()->state = RUNNABLE;
80103f26:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    sched();
80103f2d:	e8 fe fe ff ff       	call   80103e30 <sched>
    release(&ptable.lock);
80103f32:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103f39:	e8 c2 11 00 00       	call   80105100 <release>
}
80103f3e:	83 c4 10             	add    $0x10,%esp
80103f41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f44:	c9                   	leave  
80103f45:	c3                   	ret    
80103f46:	8d 76 00             	lea    0x0(%esi),%esi
80103f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f50 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	57                   	push   %edi
80103f54:	56                   	push   %esi
80103f55:	53                   	push   %ebx
80103f56:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
80103f59:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
sleep(void *chan, struct spinlock *lk) {
80103f60:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (DEBUGMODE > 1)
80103f66:	7e 10                	jle    80103f78 <sleep+0x28>
        cprintf(" SLEEP ");
80103f68:	83 ec 0c             	sub    $0xc,%esp
80103f6b:	68 d2 82 10 80       	push   $0x801082d2
80103f70:	e8 eb c6 ff ff       	call   80100660 <cprintf>
80103f75:	83 c4 10             	add    $0x10,%esp
    pushcli();
80103f78:	e8 f3 0f 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80103f7d:	e8 ee f8 ff ff       	call   80103870 <mycpu>
    p = c->proc;
80103f82:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103f88:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    popcli();
80103f8b:	e8 20 10 00 00       	call   80104fb0 <popcli>
    pushcli();
80103f90:	e8 db 0f 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80103f95:	e8 d6 f8 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80103f9a:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80103fa0:	e8 0b 10 00 00       	call   80104fb0 <popcli>
    // TODO sych problemss!!!

    struct proc *p = myproc();
    struct thread *t = mythread();

    if (p == 0)
80103fa5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fa8:	85 d2                	test   %edx,%edx
80103faa:	0f 84 83 00 00 00    	je     80104033 <sleep+0xe3>
        panic("sleep");

    if (lk == 0)
80103fb0:	85 db                	test   %ebx,%ebx
80103fb2:	74 72                	je     80104026 <sleep+0xd6>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {
80103fb4:	81 fb a0 4b 11 80    	cmp    $0x80114ba0,%ebx
80103fba:	74 4c                	je     80104008 <sleep+0xb8>
        acquire(&ptable.lock);
80103fbc:	83 ec 0c             	sub    $0xc,%esp
80103fbf:	68 a0 4b 11 80       	push   $0x80114ba0
80103fc4:	e8 77 10 00 00       	call   80105040 <acquire>
        release(lk);
80103fc9:	89 1c 24             	mov    %ebx,(%esp)
80103fcc:	e8 2f 11 00 00       	call   80105100 <release>
    }
    // Go to sleep.
    t->chan = chan;
80103fd1:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
80103fd4:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)

    sched();
80103fdb:	e8 50 fe ff ff       	call   80103e30 <sched>

    // Tidy up.
    t->chan = 0;
80103fe0:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80103fe7:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80103fee:	e8 0d 11 00 00       	call   80105100 <release>
        acquire(lk);
80103ff3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103ff6:	83 c4 10             	add    $0x10,%esp
    }
}
80103ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ffc:	5b                   	pop    %ebx
80103ffd:	5e                   	pop    %esi
80103ffe:	5f                   	pop    %edi
80103fff:	5d                   	pop    %ebp
        acquire(lk);
80104000:	e9 3b 10 00 00       	jmp    80105040 <acquire>
80104005:	8d 76 00             	lea    0x0(%esi),%esi
    t->chan = chan;
80104008:	89 7e 18             	mov    %edi,0x18(%esi)
    t->state = SLEEPING;
8010400b:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)
    sched();
80104012:	e8 19 fe ff ff       	call   80103e30 <sched>
    t->chan = 0;
80104017:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
}
8010401e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104021:	5b                   	pop    %ebx
80104022:	5e                   	pop    %esi
80104023:	5f                   	pop    %edi
80104024:	5d                   	pop    %ebp
80104025:	c3                   	ret    
        panic("sleep without lk");
80104026:	83 ec 0c             	sub    $0xc,%esp
80104029:	68 e0 82 10 80       	push   $0x801082e0
8010402e:	e8 5d c3 ff ff       	call   80100390 <panic>
        panic("sleep");
80104033:	83 ec 0c             	sub    $0xc,%esp
80104036:	68 da 82 10 80       	push   $0x801082da
8010403b:	e8 50 c3 ff ff       	call   80100390 <panic>

80104040 <cleanProcOneThread>:
cleanProcOneThread(struct thread *curthread, struct proc *p) {
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 18             	sub    $0x18,%esp
80104049:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010404c:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&ptable.lock);
8010404f:	68 a0 4b 11 80       	push   $0x80114ba0
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104054:	8d 5f 74             	lea    0x74(%edi),%ebx
80104057:	81 c7 b4 03 00 00    	add    $0x3b4,%edi
    acquire(&ptable.lock);
8010405d:	e8 de 0f 00 00       	call   80105040 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104062:	83 c4 10             	add    $0x10,%esp
80104065:	eb 10                	jmp    80104077 <cleanProcOneThread+0x37>
80104067:	89 f6                	mov    %esi,%esi
80104069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104070:	83 c3 34             	add    $0x34,%ebx
80104073:	39 fb                	cmp    %edi,%ebx
80104075:	73 27                	jae    8010409e <cleanProcOneThread+0x5e>
        if (t != curthread) {
80104077:	39 de                	cmp    %ebx,%esi
80104079:	74 f5                	je     80104070 <cleanProcOneThread+0x30>
            if (t->state == RUNNING)
8010407b:	8b 43 08             	mov    0x8(%ebx),%eax
8010407e:	83 f8 04             	cmp    $0x4,%eax
80104081:	74 35                	je     801040b8 <cleanProcOneThread+0x78>
            if (t->state == RUNNING || t->state == RUNNABLE) {
80104083:	83 e8 03             	sub    $0x3,%eax
80104086:	83 f8 01             	cmp    $0x1,%eax
80104089:	77 e5                	ja     80104070 <cleanProcOneThread+0x30>
                cleanThread(t);
8010408b:	83 ec 0c             	sub    $0xc,%esp
8010408e:	53                   	push   %ebx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010408f:	83 c3 34             	add    $0x34,%ebx
                cleanThread(t);
80104092:	e8 79 f7 ff ff       	call   80103810 <cleanThread>
80104097:	83 c4 10             	add    $0x10,%esp
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
8010409a:	39 fb                	cmp    %edi,%ebx
8010409c:	72 d9                	jb     80104077 <cleanProcOneThread+0x37>
    release(&ptable.lock);
8010409e:	c7 45 08 a0 4b 11 80 	movl   $0x80114ba0,0x8(%ebp)
}
801040a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040a8:	5b                   	pop    %ebx
801040a9:	5e                   	pop    %esi
801040aa:	5f                   	pop    %edi
801040ab:	5d                   	pop    %ebp
    release(&ptable.lock);
801040ac:	e9 4f 10 00 00       	jmp    80105100 <release>
801040b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                sleep(t, &ptable.lock);
801040b8:	83 ec 08             	sub    $0x8,%esp
801040bb:	68 a0 4b 11 80       	push   $0x80114ba0
801040c0:	53                   	push   %ebx
801040c1:	e8 8a fe ff ff       	call   80103f50 <sleep>
801040c6:	8b 43 08             	mov    0x8(%ebx),%eax
801040c9:	83 c4 10             	add    $0x10,%esp
801040cc:	eb b5                	jmp    80104083 <cleanProcOneThread+0x43>
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
801040d9:	e8 92 0e 00 00       	call   80104f70 <pushcli>
    c = mycpu();
801040de:	e8 8d f7 ff ff       	call   80103870 <mycpu>
    p = c->proc;
801040e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801040e9:	e8 c2 0e 00 00       	call   80104fb0 <popcli>
    pushcli();
801040ee:	e8 7d 0e 00 00       	call   80104f70 <pushcli>
    c = mycpu();
801040f3:	e8 78 f7 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
801040f8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801040fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
    popcli();
80104101:	e8 aa 0e 00 00       	call   80104fb0 <popcli>
    if (DEBUGMODE > 0)
80104106:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
8010410b:	85 c0                	test   %eax,%eax
8010410d:	7e 10                	jle    8010411f <exit+0x4f>
        cprintf("EXIT");
8010410f:	83 ec 0c             	sub    $0xc,%esp
80104112:	68 f1 82 10 80       	push   $0x801082f1
80104117:	e8 44 c5 ff ff       	call   80100660 <cprintf>
8010411c:	83 c4 10             	add    $0x10,%esp
    if (curproc == initproc)
8010411f:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
80104125:	0f 84 98 01 00 00    	je     801042c3 <exit+0x1f3>
    cleanProcOneThread(curthread, curproc);
8010412b:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010412e:	83 ec 08             	sub    $0x8,%esp
80104131:	8d 5e 60             	lea    0x60(%esi),%ebx
80104134:	56                   	push   %esi
80104135:	57                   	push   %edi
80104136:	e8 05 ff ff ff       	call   80104040 <cleanProcOneThread>
    acquire(&ptable.lock);
8010413b:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
80104142:	e8 f9 0e 00 00       	call   80105040 <acquire>
    curproc->mainThread = curthread;
80104147:	89 be b4 03 00 00    	mov    %edi,0x3b4(%esi)
8010414d:	8d 7e 20             	lea    0x20(%esi),%edi
80104150:	83 c4 10             	add    $0x10,%esp
80104153:	90                   	nop
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[fd]) {
80104158:	8b 07                	mov    (%edi),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	74 12                	je     80104170 <exit+0xa0>
            fileclose(curproc->ofile[fd]);
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	50                   	push   %eax
80104162:	e8 f9 cc ff ff       	call   80100e60 <fileclose>
            curproc->ofile[fd] = 0;
80104167:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	83 c7 04             	add    $0x4,%edi
    for (fd = 0; fd < NOFILE; fd++) {
80104173:	39 df                	cmp    %ebx,%edi
80104175:	75 e1                	jne    80104158 <exit+0x88>
    if (holding(&ptable.lock))
80104177:	83 ec 0c             	sub    $0xc,%esp
8010417a:	68 a0 4b 11 80       	push   $0x80114ba0
8010417f:	e8 8c 0e 00 00       	call   80105010 <holding>
80104184:	83 c4 10             	add    $0x10,%esp
80104187:	85 c0                	test   %eax,%eax
80104189:	0f 85 1f 01 00 00    	jne    801042ae <exit+0x1de>
    begin_op();
8010418f:	e8 3c ea ff ff       	call   80102bd0 <begin_op>
    iput(curproc->cwd);
80104194:	83 ec 0c             	sub    $0xc,%esp
80104197:	ff 76 60             	pushl  0x60(%esi)
8010419a:	e8 41 d6 ff ff       	call   801017e0 <iput>
    end_op();
8010419f:	e8 9c ea ff ff       	call   80102c40 <end_op>
    curproc->cwd = 0;
801041a4:	c7 46 60 00 00 00 00 	movl   $0x0,0x60(%esi)
    acquire(&ptable.lock);
801041ab:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801041b2:	e8 89 0e 00 00       	call   80105040 <acquire>
    wakeup1(curproc->parent->mainThread);
801041b7:	8b 46 10             	mov    0x10(%esi),%eax
801041ba:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041bd:	ba d4 4b 11 80       	mov    $0x80114bd4,%edx
    wakeup1(curproc->parent->mainThread);
801041c2:	8b 98 b4 03 00 00    	mov    0x3b4(%eax),%ebx
801041c8:	eb 14                	jmp    801041de <exit+0x10e>
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041d0:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
801041d6:	81 fa d4 3a 12 80    	cmp    $0x80123ad4,%edx
801041dc:	73 2d                	jae    8010420b <exit+0x13b>
        if (p->state != RUNNABLE)
801041de:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
801041e2:	75 ec                	jne    801041d0 <exit+0x100>
801041e4:	8d 42 74             	lea    0x74(%edx),%eax
801041e7:	8d 8a b4 03 00 00    	lea    0x3b4(%edx),%ecx
801041ed:	eb 08                	jmp    801041f7 <exit+0x127>
801041ef:	90                   	nop
            continue;
        //acquire( p->procLock );
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801041f0:	83 c0 34             	add    $0x34,%eax
801041f3:	39 c8                	cmp    %ecx,%eax
801041f5:	73 d9                	jae    801041d0 <exit+0x100>
            if (t->state == SLEEPING && t->chan == chan)
801041f7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801041fb:	75 f3                	jne    801041f0 <exit+0x120>
801041fd:	3b 58 18             	cmp    0x18(%eax),%ebx
80104200:	75 ee                	jne    801041f0 <exit+0x120>
                t->state = RUNNABLE;
80104202:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104209:	eb e5                	jmp    801041f0 <exit+0x120>
            p->parent = initproc;
8010420b:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104210:	bb d4 4b 11 80       	mov    $0x80114bd4,%ebx
            p->parent = initproc;
80104215:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104218:	eb 14                	jmp    8010422e <exit+0x15e>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104220:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
80104226:	81 fb d4 3a 12 80    	cmp    $0x80123ad4,%ebx
8010422c:	73 5d                	jae    8010428b <exit+0x1bb>
        if (p->parent == curproc) {
8010422e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104231:	75 ed                	jne    80104220 <exit+0x150>
            if (p->state == ZOMBIE)
80104233:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
            p->parent = initproc;
80104237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010423a:	89 43 10             	mov    %eax,0x10(%ebx)
            if (p->state == ZOMBIE)
8010423d:	75 e1                	jne    80104220 <exit+0x150>
                wakeup1(initproc->mainThread);
8010423f:	8b b8 b4 03 00 00    	mov    0x3b4(%eax),%edi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104245:	ba d4 4b 11 80       	mov    $0x80114bd4,%edx
8010424a:	eb 12                	jmp    8010425e <exit+0x18e>
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104250:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
80104256:	81 fa d4 3a 12 80    	cmp    $0x80123ad4,%edx
8010425c:	73 c2                	jae    80104220 <exit+0x150>
        if (p->state != RUNNABLE)
8010425e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104262:	75 ec                	jne    80104250 <exit+0x180>
80104264:	8d 42 74             	lea    0x74(%edx),%eax
80104267:	8d 8a b4 03 00 00    	lea    0x3b4(%edx),%ecx
8010426d:	eb 08                	jmp    80104277 <exit+0x1a7>
8010426f:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104270:	83 c0 34             	add    $0x34,%eax
80104273:	39 c1                	cmp    %eax,%ecx
80104275:	76 d9                	jbe    80104250 <exit+0x180>
            if (t->state == SLEEPING && t->chan == chan)
80104277:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010427b:	75 f3                	jne    80104270 <exit+0x1a0>
8010427d:	3b 78 18             	cmp    0x18(%eax),%edi
80104280:	75 ee                	jne    80104270 <exit+0x1a0>
                t->state = RUNNABLE;
80104282:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
80104289:	eb e5                	jmp    80104270 <exit+0x1a0>
    curthread->state = ZOMBIE;
8010428b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010428e:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
    curproc->state = ZOMBIE;
80104295:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
    sched();
8010429c:	e8 8f fb ff ff       	call   80103e30 <sched>
    panic("zombie exit");
801042a1:	83 ec 0c             	sub    $0xc,%esp
801042a4:	68 03 83 10 80       	push   $0x80108303
801042a9:	e8 e2 c0 ff ff       	call   80100390 <panic>
        release(&ptable.lock);
801042ae:	83 ec 0c             	sub    $0xc,%esp
801042b1:	68 a0 4b 11 80       	push   $0x80114ba0
801042b6:	e8 45 0e 00 00       	call   80105100 <release>
801042bb:	83 c4 10             	add    $0x10,%esp
801042be:	e9 cc fe ff ff       	jmp    8010418f <exit+0xbf>
        panic("init exiting");
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	68 f6 82 10 80       	push   $0x801082f6
801042cb:	e8 c0 c0 ff ff       	call   80100390 <panic>

801042d0 <wait>:
wait(void) {
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
801042d5:	53                   	push   %ebx
801042d6:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE > 1)
801042d9:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
801042e0:	7e 10                	jle    801042f2 <wait+0x22>
        cprintf(" WAIT ");
801042e2:	83 ec 0c             	sub    $0xc,%esp
801042e5:	68 0f 83 10 80       	push   $0x8010830f
801042ea:	e8 71 c3 ff ff       	call   80100660 <cprintf>
801042ef:	83 c4 10             	add    $0x10,%esp
    pushcli();
801042f2:	e8 79 0c 00 00       	call   80104f70 <pushcli>
    c = mycpu();
801042f7:	e8 74 f5 ff ff       	call   80103870 <mycpu>
    p = c->proc;
801042fc:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104302:	e8 a9 0c 00 00       	call   80104fb0 <popcli>
    acquire(&ptable.lock);
80104307:	83 ec 0c             	sub    $0xc,%esp
8010430a:	68 a0 4b 11 80       	push   $0x80114ba0
8010430f:	e8 2c 0d 00 00       	call   80105040 <acquire>
80104314:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
80104317:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104319:	bb d4 4b 11 80       	mov    $0x80114bd4,%ebx
8010431e:	eb 0e                	jmp    8010432e <wait+0x5e>
80104320:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
80104326:	81 fb d4 3a 12 80    	cmp    $0x80123ad4,%ebx
8010432c:	73 1e                	jae    8010434c <wait+0x7c>
            if (p->parent != curproc)
8010432e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104331:	75 ed                	jne    80104320 <wait+0x50>
            if (p->state == ZOMBIE) {
80104333:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80104337:	74 67                	je     801043a0 <wait+0xd0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104339:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
            havekids = 1;
8010433f:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104344:	81 fb d4 3a 12 80    	cmp    $0x80123ad4,%ebx
8010434a:	72 e2                	jb     8010432e <wait+0x5e>
        if (!havekids || myproc()->killed) {
8010434c:	85 c0                	test   %eax,%eax
8010434e:	0f 84 ca 00 00 00    	je     8010441e <wait+0x14e>
    pushcli();
80104354:	e8 17 0c 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80104359:	e8 12 f5 ff ff       	call   80103870 <mycpu>
    p = c->proc;
8010435e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104364:	e8 47 0c 00 00       	call   80104fb0 <popcli>
        if (!havekids || myproc()->killed) {
80104369:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010436c:	85 c0                	test   %eax,%eax
8010436e:	0f 85 aa 00 00 00    	jne    8010441e <wait+0x14e>
    pushcli();
80104374:	e8 f7 0b 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80104379:	e8 f2 f4 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
8010437e:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104384:	e8 27 0c 00 00       	call   80104fb0 <popcli>
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
80104389:	83 ec 08             	sub    $0x8,%esp
8010438c:	68 a0 4b 11 80       	push   $0x80114ba0
80104391:	53                   	push   %ebx
80104392:	e8 b9 fb ff ff       	call   80103f50 <sleep>
        havekids = 0;
80104397:	83 c4 10             	add    $0x10,%esp
8010439a:	e9 78 ff ff ff       	jmp    80104317 <wait+0x47>
8010439f:	90                   	nop
                pid = p->pid;
801043a0:	8b 43 0c             	mov    0xc(%ebx),%eax
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043a3:	8d 73 74             	lea    0x74(%ebx),%esi
801043a6:	8d bb b4 03 00 00    	lea    0x3b4(%ebx),%edi
                pid = p->pid;
801043ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043af:	eb 0e                	jmp    801043bf <wait+0xef>
801043b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043b8:	83 c6 34             	add    $0x34,%esi
801043bb:	39 f7                	cmp    %esi,%edi
801043bd:	76 1a                	jbe    801043d9 <wait+0x109>
                    if (t->state != UNUSED)
801043bf:	8b 56 08             	mov    0x8(%esi),%edx
801043c2:	85 d2                	test   %edx,%edx
801043c4:	74 f2                	je     801043b8 <wait+0xe8>
                        cleanThread(t);
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	56                   	push   %esi
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043ca:	83 c6 34             	add    $0x34,%esi
                        cleanThread(t);
801043cd:	e8 3e f4 ff ff       	call   80103810 <cleanThread>
801043d2:	83 c4 10             	add    $0x10,%esp
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801043d5:	39 f7                	cmp    %esi,%edi
801043d7:	77 e6                	ja     801043bf <wait+0xef>
                freevm(p->pgdir);
801043d9:	83 ec 0c             	sub    $0xc,%esp
801043dc:	ff 73 04             	pushl  0x4(%ebx)
801043df:	e8 8c 35 00 00       	call   80107970 <freevm>
                p->pid = 0;
801043e4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
801043eb:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->name[0] = 0;
801043f2:	c6 43 64 00          	movb   $0x0,0x64(%ebx)
                p->killed = 0;
801043f6:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
                p->state = UNUSED;
801043fd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                release(&ptable.lock);
80104404:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
8010440b:	e8 f0 0c 00 00       	call   80105100 <release>
                return pid;
80104410:	83 c4 10             	add    $0x10,%esp
}
80104413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104416:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104419:	5b                   	pop    %ebx
8010441a:	5e                   	pop    %esi
8010441b:	5f                   	pop    %edi
8010441c:	5d                   	pop    %ebp
8010441d:	c3                   	ret    
            release(&ptable.lock);
8010441e:	83 ec 0c             	sub    $0xc,%esp
80104421:	68 a0 4b 11 80       	push   $0x80114ba0
80104426:	e8 d5 0c 00 00       	call   80105100 <release>
            return -1;
8010442b:	83 c4 10             	add    $0x10,%esp
8010442e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104435:	eb dc                	jmp    80104413 <wait+0x143>
80104437:	89 f6                	mov    %esi,%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104440 <wakeup>:
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 1)
80104447:	83 3d b8 b5 10 80 01 	cmpl   $0x1,0x8010b5b8
wakeup(void *chan) {
8010444e:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 1)
80104451:	7e 10                	jle    80104463 <wakeup+0x23>
        cprintf(" WAKEUP ");
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 16 83 10 80       	push   $0x80108316
8010445b:	e8 00 c2 ff ff       	call   80100660 <cprintf>
80104460:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
80104463:	83 ec 0c             	sub    $0xc,%esp
80104466:	68 a0 4b 11 80       	push   $0x80114ba0
8010446b:	e8 d0 0b 00 00       	call   80105040 <acquire>
80104470:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104473:	ba d4 4b 11 80       	mov    $0x80114bd4,%edx
80104478:	eb 14                	jmp    8010448e <wakeup+0x4e>
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104480:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
80104486:	81 fa d4 3a 12 80    	cmp    $0x80123ad4,%edx
8010448c:	73 2d                	jae    801044bb <wakeup+0x7b>
        if (p->state != RUNNABLE)
8010448e:	83 7a 08 03          	cmpl   $0x3,0x8(%edx)
80104492:	75 ec                	jne    80104480 <wakeup+0x40>
80104494:	8d 42 74             	lea    0x74(%edx),%eax
80104497:	8d 8a b4 03 00 00    	lea    0x3b4(%edx),%ecx
8010449d:	eb 08                	jmp    801044a7 <wakeup+0x67>
8010449f:	90                   	nop
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
801044a0:	83 c0 34             	add    $0x34,%eax
801044a3:	39 c1                	cmp    %eax,%ecx
801044a5:	76 d9                	jbe    80104480 <wakeup+0x40>
            if (t->state == SLEEPING && t->chan == chan)
801044a7:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
801044ab:	75 f3                	jne    801044a0 <wakeup+0x60>
801044ad:	3b 58 18             	cmp    0x18(%eax),%ebx
801044b0:	75 ee                	jne    801044a0 <wakeup+0x60>
                t->state = RUNNABLE;
801044b2:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%eax)
801044b9:	eb e5                	jmp    801044a0 <wakeup+0x60>
    wakeup1(chan);
    release(&ptable.lock);
801044bb:	c7 45 08 a0 4b 11 80 	movl   $0x80114ba0,0x8(%ebp)
}
801044c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c5:	c9                   	leave  
    release(&ptable.lock);
801044c6:	e9 35 0c 00 00       	jmp    80105100 <release>
801044cb:	90                   	nop
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044d0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 04             	sub    $0x4,%esp
    if (DEBUGMODE > 0)
801044d7:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
kill(int pid) {
801044dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE > 0)
801044df:	85 c0                	test   %eax,%eax
801044e1:	7e 10                	jle    801044f3 <kill+0x23>
        cprintf(" KILL ");
801044e3:	83 ec 0c             	sub    $0xc,%esp
801044e6:	68 1f 83 10 80       	push   $0x8010831f
801044eb:	e8 70 c1 ff ff       	call   80100660 <cprintf>
801044f0:	83 c4 10             	add    $0x10,%esp
    struct proc *p;
    struct thread *t;
    acquire(&ptable.lock);
801044f3:	83 ec 0c             	sub    $0xc,%esp
801044f6:	68 a0 4b 11 80       	push   $0x80114ba0
801044fb:	e8 40 0b 00 00       	call   80105040 <acquire>
80104500:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104503:	b8 d4 4b 11 80       	mov    $0x80114bd4,%eax
80104508:	eb 12                	jmp    8010451c <kill+0x4c>
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104510:	05 bc 03 00 00       	add    $0x3bc,%eax
80104515:	3d d4 3a 12 80       	cmp    $0x80123ad4,%eax
8010451a:	73 5c                	jae    80104578 <kill+0xa8>
        if (p->pid == pid) {
8010451c:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010451f:	75 ef                	jne    80104510 <kill+0x40>
            //p->killed = 1;
            //turn on killed flags of the proc threads
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104521:	8d 50 74             	lea    0x74(%eax),%edx
80104524:	8d 88 b4 03 00 00    	lea    0x3b4(%eax),%ecx
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                t->killed = 1;
80104530:	c7 42 1c 01 00 00 00 	movl   $0x1,0x1c(%edx)
            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
80104537:	83 c2 34             	add    $0x34,%edx
8010453a:	39 d1                	cmp    %edx,%ecx
8010453c:	77 f2                	ja     80104530 <kill+0x60>
            // Wake process from sleep if necessary.
            //acquire( p->procLock );
            if (p->mainThread->state == SLEEPING) {
8010453e:	8b 90 b4 03 00 00    	mov    0x3b4(%eax),%edx
80104544:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
80104548:	75 14                	jne    8010455e <kill+0x8e>
                p->mainThread->state = RUNNABLE;
8010454a:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
80104551:	8b 80 b4 03 00 00    	mov    0x3b4(%eax),%eax
80104557:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
            }

            //release( p->procLock );
            release(&ptable.lock);
8010455e:	83 ec 0c             	sub    $0xc,%esp
80104561:	68 a0 4b 11 80       	push   $0x80114ba0
80104566:	e8 95 0b 00 00       	call   80105100 <release>
            return 0;
8010456b:	83 c4 10             	add    $0x10,%esp
8010456e:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104573:	c9                   	leave  
80104574:	c3                   	ret    
80104575:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	68 a0 4b 11 80       	push   $0x80114ba0
80104580:	e8 7b 0b 00 00       	call   80105100 <release>
    return -1;
80104585:	83 c4 10             	add    $0x10,%esp
80104588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010458d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104590:	c9                   	leave  
80104591:	c3                   	ret    
80104592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045a0 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	53                   	push   %ebx
801045a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045a9:	bb d4 4b 11 80       	mov    $0x80114bd4,%ebx
procdump(void) {
801045ae:	83 ec 3c             	sub    $0x3c,%esp
801045b1:	eb 27                	jmp    801045da <procdump+0x3a>
801045b3:	90                   	nop
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 c7 86 10 80       	push   $0x801086c7
801045c0:	e8 9b c0 ff ff       	call   80100660 <cprintf>
801045c5:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045c8:	81 c3 bc 03 00 00    	add    $0x3bc,%ebx
801045ce:	81 fb d4 3a 12 80    	cmp    $0x80123ad4,%ebx
801045d4:	0f 83 96 00 00 00    	jae    80104670 <procdump+0xd0>
        if (p->state == UNUSED)
801045da:	8b 43 08             	mov    0x8(%ebx),%eax
801045dd:	85 c0                	test   %eax,%eax
801045df:	74 e7                	je     801045c8 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045e1:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
801045e4:	ba 26 83 10 80       	mov    $0x80108326,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045e9:	77 11                	ja     801045fc <procdump+0x5c>
801045eb:	8b 14 85 a4 83 10 80 	mov    -0x7fef7c5c(,%eax,4),%edx
            state = "???";
801045f2:	b8 26 83 10 80       	mov    $0x80108326,%eax
801045f7:	85 d2                	test   %edx,%edx
801045f9:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
801045fc:	8d 43 64             	lea    0x64(%ebx),%eax
801045ff:	50                   	push   %eax
80104600:	52                   	push   %edx
80104601:	ff 73 0c             	pushl  0xc(%ebx)
80104604:	68 2a 83 10 80       	push   $0x8010832a
80104609:	e8 52 c0 ff ff       	call   80100660 <cprintf>
        if (p->mainThread->state == SLEEPING) {
8010460e:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80104614:	83 c4 10             	add    $0x10,%esp
80104617:	83 78 08 02          	cmpl   $0x2,0x8(%eax)
8010461b:	75 9b                	jne    801045b8 <procdump+0x18>
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
8010461d:	8d 4d c0             	lea    -0x40(%ebp),%ecx
80104620:	83 ec 08             	sub    $0x8,%esp
80104623:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104626:	51                   	push   %ecx
80104627:	8b 40 14             	mov    0x14(%eax),%eax
8010462a:	8b 40 0c             	mov    0xc(%eax),%eax
8010462d:	83 c0 08             	add    $0x8,%eax
80104630:	50                   	push   %eax
80104631:	e8 ea 08 00 00       	call   80104f20 <getcallerpcs>
80104636:	83 c4 10             	add    $0x10,%esp
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104640:	8b 17                	mov    (%edi),%edx
80104642:	85 d2                	test   %edx,%edx
80104644:	0f 84 6e ff ff ff    	je     801045b8 <procdump+0x18>
                cprintf(" %p", pc[i]);
8010464a:	83 ec 08             	sub    $0x8,%esp
8010464d:	83 c7 04             	add    $0x4,%edi
80104650:	52                   	push   %edx
80104651:	68 e1 7c 10 80       	push   $0x80107ce1
80104656:	e8 05 c0 ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
8010465b:	83 c4 10             	add    $0x10,%esp
8010465e:	39 fe                	cmp    %edi,%esi
80104660:	75 de                	jne    80104640 <procdump+0xa0>
80104662:	e9 51 ff ff ff       	jmp    801045b8 <procdump+0x18>
80104667:	89 f6                	mov    %esi,%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
}
80104670:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104673:	5b                   	pop    %ebx
80104674:	5e                   	pop    %esi
80104675:	5f                   	pop    %edi
80104676:	5d                   	pop    %ebp
80104677:	c3                   	ret    
80104678:	90                   	nop
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104680 <kthread_create>:

//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
    pushcli();
80104685:	e8 e6 08 00 00       	call   80104f70 <pushcli>
    c = mycpu();
8010468a:	e8 e1 f1 ff ff       	call   80103870 <mycpu>
    p = c->proc;
8010468f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104695:	e8 16 09 00 00       	call   80104fb0 <popcli>
    struct thread *t;
    struct proc *p = myproc();
    char *sp;
    acquire(&ptable.lock);
8010469a:	83 ec 0c             	sub    $0xc,%esp
8010469d:	68 a0 4b 11 80       	push   $0x80114ba0
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801046a2:	8d 5e 74             	lea    0x74(%esi),%ebx
    acquire(&ptable.lock);
801046a5:	e8 96 09 00 00       	call   80105040 <acquire>
        if (t->state == UNUSED)
801046aa:	8b 46 7c             	mov    0x7c(%esi),%eax
801046ad:	83 c4 10             	add    $0x10,%esp
801046b0:	85 c0                	test   %eax,%eax
801046b2:	74 3c                	je     801046f0 <kthread_create+0x70>
801046b4:	8d 86 b4 03 00 00    	lea    0x3b4(%esi),%eax
801046ba:	eb 0b                	jmp    801046c7 <kthread_create+0x47>
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046c0:	8b 73 08             	mov    0x8(%ebx),%esi
801046c3:	85 f6                	test   %esi,%esi
801046c5:	74 29                	je     801046f0 <kthread_create+0x70>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
801046c7:	83 c3 34             	add    $0x34,%ebx
801046ca:	39 c3                	cmp    %eax,%ebx
801046cc:	72 f2                	jb     801046c0 <kthread_create+0x40>
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        release(&ptable.lock);
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	68 a0 4b 11 80       	push   $0x80114ba0
801046d6:	e8 25 0a 00 00       	call   80105100 <release>
        return -1;
801046db:	83 c4 10             	add    $0x10,%esp
    t->killed = 0;
    t->chan = 0;
    t->state = RUNNABLE;
    release(&ptable.lock);
    return 0;
}
801046de:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
801046e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046e6:	5b                   	pop    %ebx
801046e7:	5e                   	pop    %esi
801046e8:	5d                   	pop    %ebp
801046e9:	c3                   	ret    
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    t->tid = tidCounter++;
801046f0:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    t->state = EMBRYO;
801046f5:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
    t->tid = tidCounter++;
801046fc:	8d 50 01             	lea    0x1(%eax),%edx
801046ff:	89 43 0c             	mov    %eax,0xc(%ebx)
80104702:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
    if ((t->tkstack = kalloc()) == 0) {
80104708:	e8 e3 dd ff ff       	call   801024f0 <kalloc>
8010470d:	85 c0                	test   %eax,%eax
8010470f:	89 43 04             	mov    %eax,0x4(%ebx)
80104712:	0f 84 dd 00 00 00    	je     801047f5 <kthread_create+0x175>
    sp -= sizeof *t->tf;
80104718:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(t->context, 0, sizeof *t->context);
8010471e:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *t->context;
80104721:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *t->tf;
80104726:	89 53 10             	mov    %edx,0x10(%ebx)
    *(uint *) sp = (uint) trapret;
80104729:	c7 40 14 0f 64 10 80 	movl   $0x8010640f,0x14(%eax)
    t->context = (struct context *) sp;
80104730:	89 43 14             	mov    %eax,0x14(%ebx)
    memset(t->context, 0, sizeof *t->context);
80104733:	6a 14                	push   $0x14
80104735:	6a 00                	push   $0x0
80104737:	50                   	push   %eax
80104738:	e8 23 0a 00 00       	call   80105160 <memset>
    t->context->eip = (uint) forkret;
8010473d:	8b 43 14             	mov    0x14(%ebx),%eax
    memset(t->tf, 0, sizeof(*t->tf));
80104740:	83 c4 0c             	add    $0xc,%esp
    t->context->eip = (uint) forkret;
80104743:	c7 40 10 70 37 10 80 	movl   $0x80103770,0x10(%eax)
    memset(t->tf, 0, sizeof(*t->tf));
8010474a:	6a 4c                	push   $0x4c
8010474c:	6a 00                	push   $0x0
8010474e:	ff 73 10             	pushl  0x10(%ebx)
80104751:	e8 0a 0a 00 00       	call   80105160 <memset>
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104756:	8b 43 10             	mov    0x10(%ebx),%eax
80104759:	ba 1b 00 00 00       	mov    $0x1b,%edx
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010475e:	b9 23 00 00 00       	mov    $0x23,%ecx
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
    t->tf->eip = (uint) start_func;  // beginning of run func
80104787:	8b 55 08             	mov    0x8(%ebp),%edx
    t->tf->eflags = FL_IF;
8010478a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    t->tf->esp = PGSIZE;
80104791:	8b 43 10             	mov    0x10(%ebx),%eax
80104794:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    t->tf->eip = (uint) start_func;  // beginning of run func
8010479b:	8b 43 10             	mov    0x10(%ebx),%eax
8010479e:	89 50 38             	mov    %edx,0x38(%eax)
    pushcli();
801047a1:	e8 ca 07 00 00       	call   80104f70 <pushcli>
    c = mycpu();
801047a6:	e8 c5 f0 ff ff       	call   80103870 <mycpu>
    p = c->proc;
801047ab:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801047b1:	e8 fa 07 00 00       	call   80104fb0 <popcli>
    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
801047b6:	8d 43 20             	lea    0x20(%ebx),%eax
801047b9:	83 c4 0c             	add    $0xc,%esp
801047bc:	83 c6 64             	add    $0x64,%esi
801047bf:	6a 10                	push   $0x10
801047c1:	56                   	push   %esi
801047c2:	50                   	push   %eax
801047c3:	e8 78 0b 00 00       	call   80105340 <safestrcpy>
    t->killed = 0;
801047c8:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    t->chan = 0;
801047cf:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    t->state = RUNNABLE;
801047d6:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
    release(&ptable.lock);
801047dd:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801047e4:	e8 17 09 00 00       	call   80105100 <release>
    return 0;
801047e9:	83 c4 10             	add    $0x10,%esp
}
801047ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801047ef:	31 c0                	xor    %eax,%eax
}
801047f1:	5b                   	pop    %ebx
801047f2:	5e                   	pop    %esi
801047f3:	5d                   	pop    %ebp
801047f4:	c3                   	ret    
        t->state = UNUSED;
801047f5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
801047fc:	e9 cd fe ff ff       	jmp    801046ce <kthread_create+0x4e>
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

//this func haven't been used - i's implementation is in sysproc
int kthread_id() {
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104817:	e8 54 07 00 00       	call   80104f70 <pushcli>
    c = mycpu();
8010481c:	e8 4f f0 ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104821:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104827:	e8 84 07 00 00       	call   80104fb0 <popcli>
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
    pushcli();
80104847:	e8 24 07 00 00       	call   80104f70 <pushcli>
    c = mycpu();
8010484c:	e8 1f f0 ff ff       	call   80103870 <mycpu>
    p = c->proc;
80104851:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104857:	e8 54 07 00 00       	call   80104fb0 <popcli>
    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    acquire(&ptable.lock);
8010485c:	83 ec 0c             	sub    $0xc,%esp
8010485f:	68 a0 4b 11 80       	push   $0x80114ba0
80104864:	e8 d7 07 00 00       	call   80105040 <acquire>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104869:	8d 43 74             	lea    0x74(%ebx),%eax
8010486c:	8d 8b b4 03 00 00    	lea    0x3b4(%ebx),%ecx
80104872:	83 c4 10             	add    $0x10,%esp
    int counter = 0;
80104875:	31 db                	xor    %ebx,%ebx
80104877:	eb 13                	jmp    8010488c <kthread_exit+0x4c>
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (t->state == UNUSED || t->state == ZOMBIE)
80104880:	83 fa 05             	cmp    $0x5,%edx
80104883:	74 0e                	je     80104893 <kthread_exit+0x53>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104885:	83 c0 34             	add    $0x34,%eax
80104888:	39 c8                	cmp    %ecx,%eax
8010488a:	73 11                	jae    8010489d <kthread_exit+0x5d>
        if (t->state == UNUSED || t->state == ZOMBIE)
8010488c:	8b 50 08             	mov    0x8(%eax),%edx
8010488f:	85 d2                	test   %edx,%edx
80104891:	75 ed                	jne    80104880 <kthread_exit+0x40>
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104893:	83 c0 34             	add    $0x34,%eax
            counter++;
80104896:	83 c3 01             	add    $0x1,%ebx
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104899:	39 c8                	cmp    %ecx,%eax
8010489b:	72 ef                	jb     8010488c <kthread_exit+0x4c>
    }
    if (counter == (NTHREADS - 1)){ //all other threads aren't available -> close proc
8010489d:	83 fb 0f             	cmp    $0xf,%ebx
801048a0:	74 1d                	je     801048bf <kthread_exit+0x7f>
        release(&ptable.lock);
        exit();
    }
    else{   //there are other threads in the same proc - close just the specific thread
        cleanThread(t);
801048a2:	83 ec 0c             	sub    $0xc,%esp
801048a5:	50                   	push   %eax
801048a6:	e8 65 ef ff ff       	call   80103810 <cleanThread>
        release(&ptable.lock);
801048ab:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
801048b2:	e8 49 08 00 00       	call   80105100 <release>
    }
}
801048b7:	83 c4 10             	add    $0x10,%esp
801048ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048bd:	c9                   	leave  
801048be:	c3                   	ret    
        release(&ptable.lock);
801048bf:	83 ec 0c             	sub    $0xc,%esp
801048c2:	68 a0 4b 11 80       	push   $0x80114ba0
801048c7:	e8 34 08 00 00       	call   80105100 <release>
        exit();
801048cc:	e8 ff f7 ff ff       	call   801040d0 <exit>
801048d1:	eb 0d                	jmp    801048e0 <kthread_join>
801048d3:	90                   	nop
801048d4:	90                   	nop
801048d5:	90                   	nop
801048d6:	90                   	nop
801048d7:	90                   	nop
801048d8:	90                   	nop
801048d9:	90                   	nop
801048da:	90                   	nop
801048db:	90                   	nop
801048dc:	90                   	nop
801048dd:	90                   	nop
801048de:	90                   	nop
801048df:	90                   	nop

801048e0 <kthread_join>:

int kthread_join(int thread_id) {
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 10             	sub    $0x10,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
801048ea:	68 a0 4b 11 80       	push   $0x80114ba0
801048ef:	e8 4c 07 00 00       	call   80105040 <acquire>
801048f4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048f7:	ba d4 4b 11 80       	mov    $0x80114bd4,%edx
801048fc:	eb 10                	jmp    8010490e <kthread_join+0x2e>
801048fe:	66 90                	xchg   %ax,%ax
80104900:	81 c2 bc 03 00 00    	add    $0x3bc,%edx
80104906:	81 fa d4 3a 12 80    	cmp    $0x80123ad4,%edx
8010490c:	73 72                	jae    80104980 <kthread_join+0xa0>
        if (p->state != UNUSED) {
8010490e:	8b 42 08             	mov    0x8(%edx),%eax
80104911:	85 c0                	test   %eax,%eax
80104913:	74 eb                	je     80104900 <kthread_join+0x20>
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->tid == thread_id)
80104915:	39 9a 80 00 00 00    	cmp    %ebx,0x80(%edx)
8010491b:	8d 42 74             	lea    0x74(%edx),%eax
8010491e:	8d 8a b4 03 00 00    	lea    0x3b4(%edx),%ecx
80104924:	74 16                	je     8010493c <kthread_join+0x5c>
80104926:	8d 76 00             	lea    0x0(%esi),%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
80104930:	83 c0 34             	add    $0x34,%eax
80104933:	39 c8                	cmp    %ecx,%eax
80104935:	73 c9                	jae    80104900 <kthread_join+0x20>
                if (t->tid == thread_id)
80104937:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010493a:	75 f4                	jne    80104930 <kthread_join+0x50>
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
    return -1;
    found2:
    if (t->state == UNUSED || t->state == ZOMBIE){
8010493c:	8b 50 08             	mov    0x8(%eax),%edx
8010493f:	85 d2                	test   %edx,%edx
80104941:	74 3d                	je     80104980 <kthread_join+0xa0>
80104943:	83 fa 05             	cmp    $0x5,%edx
80104946:	74 38                	je     80104980 <kthread_join+0xa0>
        release(&ptable.lock);
        return -1;
    }
    sleep(t,&ptable.lock);
80104948:	83 ec 08             	sub    $0x8,%esp
8010494b:	68 a0 4b 11 80       	push   $0x80114ba0
80104950:	50                   	push   %eax
80104951:	e8 fa f5 ff ff       	call   80103f50 <sleep>
    //TODO - not sure about release
    if(holding(&ptable.lock))
80104956:	c7 04 24 a0 4b 11 80 	movl   $0x80114ba0,(%esp)
8010495d:	e8 ae 06 00 00       	call   80105010 <holding>
80104962:	83 c4 10             	add    $0x10,%esp
80104965:	85 c0                	test   %eax,%eax
80104967:	74 12                	je     8010497b <kthread_join+0x9b>
        release(&ptable.lock);
80104969:	83 ec 0c             	sub    $0xc,%esp
8010496c:	68 a0 4b 11 80       	push   $0x80114ba0
80104971:	e8 8a 07 00 00       	call   80105100 <release>
80104976:	83 c4 10             	add    $0x10,%esp
    return 0;
80104979:	31 c0                	xor    %eax,%eax
}
8010497b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010497e:	c9                   	leave  
8010497f:	c3                   	ret    
    release(&ptable.lock);
80104980:	83 ec 0c             	sub    $0xc,%esp
80104983:	68 a0 4b 11 80       	push   $0x80114ba0
80104988:	e8 73 07 00 00       	call   80105100 <release>
    return -1;
8010498d:	83 c4 10             	add    $0x10,%esp
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104998:	c9                   	leave  
80104999:	c3                   	ret    
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801049a4:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
{
801049a9:	83 ec 10             	sub    $0x10,%esp
    acquire(&mtable.lock);
801049ac:	68 60 3d 11 80       	push   $0x80113d60
801049b1:	e8 8a 06 00 00       	call   80105040 <acquire>
801049b6:	83 c4 10             	add    $0x10,%esp
801049b9:	eb 10                	jmp    801049cb <kthread_mutex_alloc+0x2b>
801049bb:	90                   	nop
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
801049c0:	83 c3 38             	add    $0x38,%ebx
801049c3:	81 fb 94 4b 11 80    	cmp    $0x80114b94,%ebx
801049c9:	73 45                	jae    80104a10 <kthread_mutex_alloc+0x70>
        if (!m->active)
801049cb:	8b 43 04             	mov    0x4(%ebx),%eax
801049ce:	85 c0                	test   %eax,%eax
801049d0:	75 ee                	jne    801049c0 <kthread_mutex_alloc+0x20>
    release(&mtable.lock);
    return -1;

    alloc_mutex:
    m->active = 1;
    m->mid = mutexCounter++;
801049d2:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
801049d7:	83 ec 0c             	sub    $0xc,%esp
    m->active = 1;
801049da:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
    release(&mtable.lock);
801049e1:	68 60 3d 11 80       	push   $0x80113d60
    m->locked = 0;
801049e6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    m->thread = 0;
801049ec:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    m->mid = mutexCounter++;
801049f3:	8d 50 01             	lea    0x1(%eax),%edx
801049f6:	89 43 08             	mov    %eax,0x8(%ebx)
801049f9:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&mtable.lock);
801049ff:	e8 fc 06 00 00       	call   80105100 <release>
    return m->mid;
80104a04:	8b 43 08             	mov    0x8(%ebx),%eax
80104a07:	83 c4 10             	add    $0x10,%esp


}
80104a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a0d:	c9                   	leave  
80104a0e:	c3                   	ret    
80104a0f:	90                   	nop
    release(&mtable.lock);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	68 60 3d 11 80       	push   $0x80113d60
80104a18:	e8 e3 06 00 00       	call   80105100 <release>
    return -1;
80104a1d:	83 c4 10             	add    $0x10,%esp
80104a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a28:	c9                   	leave  
80104a29:	c3                   	ret    
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <kthread_mutex_dealloc>:


int
kthread_mutex_dealloc(int mutex_id){
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 10             	sub    $0x10,%esp
80104a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);
80104a3a:	68 60 3d 11 80       	push   $0x80113d60
80104a3f:	e8 fc 05 00 00       	call   80105040 <acquire>
80104a44:	83 c4 10             	add    $0x10,%esp

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104a47:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80104a4c:	eb 0c                	jmp    80104a5a <kthread_mutex_dealloc+0x2a>
80104a4e:	66 90                	xchg   %ax,%ax
80104a50:	83 c0 38             	add    $0x38,%eax
80104a53:	3d 94 4b 11 80       	cmp    $0x80114b94,%eax
80104a58:	73 3e                	jae    80104a98 <kthread_mutex_dealloc+0x68>
        if ( m->mid == mutex_id ) {
80104a5a:	39 58 08             	cmp    %ebx,0x8(%eax)
80104a5d:	75 f1                	jne    80104a50 <kthread_mutex_dealloc+0x20>
            if( m->locked ){
80104a5f:	8b 10                	mov    (%eax),%edx
80104a61:	85 d2                	test   %edx,%edx
80104a63:	75 33                	jne    80104a98 <kthread_mutex_dealloc+0x68>
    dealloc_mutex:
    m->active = 0;
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
80104a65:	83 ec 0c             	sub    $0xc,%esp
    m->active = 0;
80104a68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    m->mid = -1;
80104a6f:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
    m->thread = 0;
80104a76:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    release(&mtable.lock);
80104a7d:	68 60 3d 11 80       	push   $0x80113d60
80104a82:	e8 79 06 00 00       	call   80105100 <release>
    return 0;
80104a87:	83 c4 10             	add    $0x10,%esp
80104a8a:	31 c0                	xor    %eax,%eax
}
80104a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a8f:	c9                   	leave  
80104a90:	c3                   	ret    
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                release(&mtable.lock);
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	68 60 3d 11 80       	push   $0x80113d60
80104aa0:	e8 5b 06 00 00       	call   80105100 <release>
                return -1;
80104aa5:	83 c4 10             	add    $0x10,%esp
80104aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab0:	c9                   	leave  
80104ab1:	c3                   	ret    
80104ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <mgetcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
// TODO NOT OUR CODE MIGHT BE REMOVED
void
mgetcallerpcs(void *v, uint pcs[])
{
80104ac0:	55                   	push   %ebp
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for(i = 0; i < 10; i++){
80104ac1:	31 d2                	xor    %edx,%edx
{
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	53                   	push   %ebx
    ebp = (uint*)v - 2;
80104ac6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ac9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    ebp = (uint*)v - 2;
80104acc:	83 e8 08             	sub    $0x8,%eax
80104acf:	90                   	nop
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ad0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ad6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104adc:	77 1a                	ja     80104af8 <mgetcallerpcs+0x38>
            break;
        pcs[i] = ebp[1];     // saved %eip
80104ade:	8b 58 04             	mov    0x4(%eax),%ebx
80104ae1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for(i = 0; i < 10; i++){
80104ae4:	83 c2 01             	add    $0x1,%edx
        ebp = (uint*)ebp[0]; // saved %ebp
80104ae7:	8b 00                	mov    (%eax),%eax
    for(i = 0; i < 10; i++){
80104ae9:	83 fa 0a             	cmp    $0xa,%edx
80104aec:	75 e2                	jne    80104ad0 <mgetcallerpcs+0x10>
    }
    for(; i < 10; i++)
        pcs[i] = 0;
}
80104aee:	5b                   	pop    %ebx
80104aef:	5d                   	pop    %ebp
80104af0:	c3                   	ret    
80104af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104afb:	83 c1 28             	add    $0x28,%ecx
80104afe:	66 90                	xchg   %ax,%ax
        pcs[i] = 0;
80104b00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b06:	83 c0 04             	add    $0x4,%eax
    for(; i < 10; i++)
80104b09:	39 c1                	cmp    %eax,%ecx
80104b0b:	75 f3                	jne    80104b00 <mgetcallerpcs+0x40>
}
80104b0d:	5b                   	pop    %ebx
80104b0e:	5d                   	pop    %ebp
80104b0f:	c3                   	ret    

80104b10 <mpushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
mpushcli(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
80104b17:	9c                   	pushf  
80104b18:	5b                   	pop    %ebx
  asm volatile("cli");
80104b19:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if(mycpu()->ncli == 0)
80104b1a:	e8 51 ed ff ff       	call   80103870 <mycpu>
80104b1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b25:	85 c0                	test   %eax,%eax
80104b27:	75 11                	jne    80104b3a <mpushcli+0x2a>
        mycpu()->intena = eflags & FL_IF;
80104b29:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b2f:	e8 3c ed ff ff       	call   80103870 <mycpu>
80104b34:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
    mycpu()->ncli += 1;
80104b3a:	e8 31 ed ff ff       	call   80103870 <mycpu>
80104b3f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b46:	83 c4 04             	add    $0x4,%esp
80104b49:	5b                   	pop    %ebx
80104b4a:	5d                   	pop    %ebp
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <mpopcli>:

void
mpopcli(void)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b56:	9c                   	pushf  
80104b57:	58                   	pop    %eax
    if(readeflags()&FL_IF)
80104b58:	f6 c4 02             	test   $0x2,%ah
80104b5b:	75 35                	jne    80104b92 <mpopcli+0x42>
        panic("popcli - interruptible");
    if(--mycpu()->ncli < 0)
80104b5d:	e8 0e ed ff ff       	call   80103870 <mycpu>
80104b62:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b69:	78 34                	js     80104b9f <mpopcli+0x4f>
        panic("popcli");
    if(mycpu()->ncli == 0 && mycpu()->intena)
80104b6b:	e8 00 ed ff ff       	call   80103870 <mycpu>
80104b70:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b76:	85 d2                	test   %edx,%edx
80104b78:	74 06                	je     80104b80 <mpopcli+0x30>
        sti();
}
80104b7a:	c9                   	leave  
80104b7b:	c3                   	ret    
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mycpu()->ncli == 0 && mycpu()->intena)
80104b80:	e8 eb ec ff ff       	call   80103870 <mycpu>
80104b85:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b8b:	85 c0                	test   %eax,%eax
80104b8d:	74 eb                	je     80104b7a <mpopcli+0x2a>
  asm volatile("sti");
80104b8f:	fb                   	sti    
}
80104b90:	c9                   	leave  
80104b91:	c3                   	ret    
        panic("popcli - interruptible");
80104b92:	83 ec 0c             	sub    $0xc,%esp
80104b95:	68 33 83 10 80       	push   $0x80108333
80104b9a:	e8 f1 b7 ff ff       	call   80100390 <panic>
        panic("popcli");
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	68 4a 83 10 80       	push   $0x8010834a
80104ba7:	e8 e4 b7 ff ff       	call   80100390 <panic>
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <kthread_mutex_lock>:



int
kthread_mutex_lock(int mutex_id)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
80104bb5:	83 ec 10             	sub    $0x10,%esp
80104bb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct kthread_mutex_t *m;

    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!
80104bbb:	e8 50 ff ff ff       	call   80104b10 <mpushcli>
    acquire(&mtable.lock);
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	68 60 3d 11 80       	push   $0x80113d60
80104bc8:	e8 73 04 00 00       	call   80105040 <acquire>

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104bcd:	c7 45 f4 94 3d 11 80 	movl   $0x80113d94,-0xc(%ebp)
80104bd4:	83 c4 10             	add    $0x10,%esp
80104bd7:	31 d2                	xor    %edx,%edx
80104bd9:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80104bde:	66 90                	xchg   %ax,%ax
        if (m->active && m->mid == mutex_id) {
80104be0:	8b 48 04             	mov    0x4(%eax),%ecx
80104be3:	85 c9                	test   %ecx,%ecx
80104be5:	74 05                	je     80104bec <kthread_mutex_lock+0x3c>
80104be7:	39 58 08             	cmp    %ebx,0x8(%eax)
80104bea:	74 34                	je     80104c20 <kthread_mutex_lock+0x70>
    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104bec:	83 c0 38             	add    $0x38,%eax
80104bef:	ba 01 00 00 00       	mov    $0x1,%edx
80104bf4:	3d 94 4b 11 80       	cmp    $0x80114b94,%eax
80104bf9:	72 e5                	jb     80104be0 <kthread_mutex_lock+0x30>
            goto lock_mutex;

        }
    }

    release(&mtable.lock);
80104bfb:	83 ec 0c             	sub    $0xc,%esp
80104bfe:	68 60 3d 11 80       	push   $0x80113d60
80104c03:	e8 f8 04 00 00       	call   80105100 <release>
    return -1;
80104c08:	83 c4 10             	add    $0x10,%esp
    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
}
80104c0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c13:	5b                   	pop    %ebx
80104c14:	5e                   	pop    %esi
80104c15:	5d                   	pop    %ebp
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c20:	84 d2                	test   %dl,%dl
80104c22:	0f 85 c0 00 00 00    	jne    80104ce8 <kthread_mutex_lock+0x138>
        if (m->active && m->mid == mutex_id) {
80104c28:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
            if (m->locked) {
80104c2d:	8b 10                	mov    (%eax),%edx
80104c2f:	85 d2                	test   %edx,%edx
80104c31:	0f 85 99 00 00 00    	jne    80104cd0 <kthread_mutex_lock+0x120>
  asm volatile("lock; xchgl %0, %1" :
80104c37:	ba 01 00 00 00       	mov    $0x1,%edx
80104c3c:	eb 05                	jmp    80104c43 <kthread_mutex_lock+0x93>
80104c3e:	66 90                	xchg   %ax,%ax
80104c40:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104c43:	89 d0                	mov    %edx,%eax
80104c45:	f0 87 03             	lock xchg %eax,(%ebx)
    while(xchg(&m->locked, 1) != 0)
80104c48:	85 c0                	test   %eax,%eax
80104c4a:	75 f4                	jne    80104c40 <kthread_mutex_lock+0x90>
    __sync_synchronize();   // << TODO - not our line!!!
80104c4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    m->thread = mythread();
80104c51:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    pushcli();
80104c54:	e8 17 03 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80104c59:	e8 12 ec ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104c5e:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
    popcli();
80104c64:	e8 47 03 00 00       	call   80104fb0 <popcli>
    mgetcallerpcs(&m, m->pcs);
80104c69:	8d 4b 10             	lea    0x10(%ebx),%ecx
    ebp = (uint*)v - 2;
80104c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
    for(i = 0; i < 10; i++){
80104c6f:	31 d2                	xor    %edx,%edx
    m->thread = mythread();
80104c71:	89 73 0c             	mov    %esi,0xc(%ebx)
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c78:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c7e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c84:	77 2a                	ja     80104cb0 <kthread_mutex_lock+0x100>
        pcs[i] = ebp[1];     // saved %eip
80104c86:	8b 58 04             	mov    0x4(%eax),%ebx
80104c89:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for(i = 0; i < 10; i++){
80104c8c:	83 c2 01             	add    $0x1,%edx
        ebp = (uint*)ebp[0]; // saved %ebp
80104c8f:	8b 00                	mov    (%eax),%eax
    for(i = 0; i < 10; i++){
80104c91:	83 fa 0a             	cmp    $0xa,%edx
80104c94:	75 e2                	jne    80104c78 <kthread_mutex_lock+0xc8>
    release(&mtable.lock);
80104c96:	83 ec 0c             	sub    $0xc,%esp
80104c99:	68 60 3d 11 80       	push   $0x80113d60
80104c9e:	e8 5d 04 00 00       	call   80105100 <release>
    return 0;
80104ca3:	83 c4 10             	add    $0x10,%esp
}
80104ca6:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80104ca9:	31 c0                	xor    %eax,%eax
}
80104cab:	5b                   	pop    %ebx
80104cac:	5e                   	pop    %esi
80104cad:	5d                   	pop    %ebp
80104cae:	c3                   	ret    
80104caf:	90                   	nop
80104cb0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104cb3:	83 c1 28             	add    $0x28,%ecx
80104cb6:	8d 76 00             	lea    0x0(%esi),%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        pcs[i] = 0;
80104cc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104cc6:	83 c0 04             	add    $0x4,%eax
    for(; i < 10; i++)
80104cc9:	39 c1                	cmp    %eax,%ecx
80104ccb:	75 f3                	jne    80104cc0 <kthread_mutex_lock+0x110>
80104ccd:	eb c7                	jmp    80104c96 <kthread_mutex_lock+0xe6>
80104ccf:	90                   	nop
                sleep( m->thread , &mtable.lock );
80104cd0:	83 ec 08             	sub    $0x8,%esp
80104cd3:	68 60 3d 11 80       	push   $0x80113d60
80104cd8:	ff 70 0c             	pushl  0xc(%eax)
80104cdb:	e8 70 f2 ff ff       	call   80103f50 <sleep>
80104ce0:	83 c4 10             	add    $0x10,%esp
80104ce3:	e9 4f ff ff ff       	jmp    80104c37 <kthread_mutex_lock+0x87>
80104ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (m->active && m->mid == mutex_id) {
80104ceb:	89 c3                	mov    %eax,%ebx
80104ced:	e9 3b ff ff ff       	jmp    80104c2d <kthread_mutex_lock+0x7d>
80104cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <kthread_mutex_unlock>:

// Release the lock.
int
kthread_mutex_unlock(int mutex_id)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	53                   	push   %ebx
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104d06:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
{
80104d0b:	83 ec 28             	sub    $0x28,%esp
80104d0e:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&mtable.lock);
80104d11:	68 60 3d 11 80       	push   $0x80113d60
80104d16:	e8 25 03 00 00       	call   80105040 <acquire>
80104d1b:	83 c4 10             	add    $0x10,%esp
80104d1e:	eb 0f                	jmp    80104d2f <kthread_mutex_unlock+0x2f>
    for( m = mtable.kthread_mutex_t ; m < &mtable.kthread_mutex_t[MAX_MUTEXES] ; m++ ) {
80104d20:	83 c3 38             	add    $0x38,%ebx
80104d23:	81 fb 94 4b 11 80    	cmp    $0x80114b94,%ebx
80104d29:	0f 83 81 00 00 00    	jae    80104db0 <kthread_mutex_unlock+0xb0>
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
80104d2f:	8b 53 04             	mov    0x4(%ebx),%edx
80104d32:	85 d2                	test   %edx,%edx
80104d34:	74 ea                	je     80104d20 <kthread_mutex_unlock+0x20>
80104d36:	39 73 08             	cmp    %esi,0x8(%ebx)
80104d39:	75 e5                	jne    80104d20 <kthread_mutex_unlock+0x20>
80104d3b:	8b 03                	mov    (%ebx),%eax
80104d3d:	85 c0                	test   %eax,%eax
80104d3f:	74 df                	je     80104d20 <kthread_mutex_unlock+0x20>
80104d41:	8b 7b 0c             	mov    0xc(%ebx),%edi
    pushcli();
80104d44:	e8 27 02 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80104d49:	e8 22 eb ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104d4e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    popcli();
80104d57:	e8 54 02 00 00       	call   80104fb0 <popcli>
        if ( m->active && m->mid == mutex_id && m->locked && m->thread == mythread() )
80104d5c:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80104d5f:	75 bf                	jne    80104d20 <kthread_mutex_unlock+0x20>
    release(&mtable.lock);
    return -1;

    unlock_mutex:

    m->pcs[0] = 0;
80104d61:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    m->thread = 0;
80104d68:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that all the stores in the critical
    // section are visible to other cores before the lock is released.
    // Both the C compiler and the hardware may re-order loads and
    // stores; __sync_synchronize() tells them both not to.
    __sync_synchronize();
80104d6f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    // Release the lock, equivalent to lk->locked = 0.
    // This code can't use a C assignment, since it might
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );
80104d74:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    pushcli();
80104d7a:	e8 f1 01 00 00       	call   80104f70 <pushcli>
    c = mycpu();
80104d7f:	e8 ec ea ff ff       	call   80103870 <mycpu>
    t = c->currThread;
80104d84:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
    popcli();
80104d8a:	e8 21 02 00 00       	call   80104fb0 <popcli>

    wakeup(mythread());
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	53                   	push   %ebx
80104d93:	e8 a8 f6 ff ff       	call   80104440 <wakeup>
    mpopcli();
80104d98:	e8 b3 fd ff ff       	call   80104b50 <mpopcli>
    return 0;
80104d9d:	83 c4 10             	add    $0x10,%esp
}
80104da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104da3:	31 c0                	xor    %eax,%eax
}
80104da5:	5b                   	pop    %ebx
80104da6:	5e                   	pop    %esi
80104da7:	5f                   	pop    %edi
80104da8:	5d                   	pop    %ebp
80104da9:	c3                   	ret    
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&mtable.lock);
80104db0:	83 ec 0c             	sub    $0xc,%esp
80104db3:	68 60 3d 11 80       	push   $0x80113d60
80104db8:	e8 43 03 00 00       	call   80105100 <release>
    return -1;
80104dbd:	83 c4 10             	add    $0x10,%esp
}
80104dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80104dc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc8:	5b                   	pop    %ebx
80104dc9:	5e                   	pop    %esi
80104dca:	5f                   	pop    %edi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	66 90                	xchg   %ax,%ax
80104dcf:	90                   	nop

80104dd0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 0c             	sub    $0xc,%esp
80104dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104dda:	68 bc 83 10 80       	push   $0x801083bc
80104ddf:	8d 43 04             	lea    0x4(%ebx),%eax
80104de2:	50                   	push   %eax
80104de3:	e8 18 01 00 00       	call   80104f00 <initlock>
  lk->name = name;
80104de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104deb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104df1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104df4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104dfb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e01:	c9                   	leave  
80104e02:	c3                   	ret    
80104e03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	53                   	push   %ebx
80104e15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	8d 73 04             	lea    0x4(%ebx),%esi
80104e1e:	56                   	push   %esi
80104e1f:	e8 1c 02 00 00       	call   80105040 <acquire>
  while (lk->locked) {
80104e24:	8b 13                	mov    (%ebx),%edx
80104e26:	83 c4 10             	add    $0x10,%esp
80104e29:	85 d2                	test   %edx,%edx
80104e2b:	74 16                	je     80104e43 <acquiresleep+0x33>
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104e30:	83 ec 08             	sub    $0x8,%esp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
80104e35:	e8 16 f1 ff ff       	call   80103f50 <sleep>
  while (lk->locked) {
80104e3a:	8b 03                	mov    (%ebx),%eax
80104e3c:	83 c4 10             	add    $0x10,%esp
80104e3f:	85 c0                	test   %eax,%eax
80104e41:	75 ed                	jne    80104e30 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104e43:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104e49:	e8 c2 ea ff ff       	call   80103910 <myproc>
80104e4e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e51:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104e54:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104e57:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e5a:	5b                   	pop    %ebx
80104e5b:	5e                   	pop    %esi
80104e5c:	5d                   	pop    %ebp
  release(&lk->lk);
80104e5d:	e9 9e 02 00 00       	jmp    80105100 <release>
80104e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
80104e75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e78:	83 ec 0c             	sub    $0xc,%esp
80104e7b:	8d 73 04             	lea    0x4(%ebx),%esi
80104e7e:	56                   	push   %esi
80104e7f:	e8 bc 01 00 00       	call   80105040 <acquire>
  lk->locked = 0;
80104e84:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104e8a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104e91:	89 1c 24             	mov    %ebx,(%esp)
80104e94:	e8 a7 f5 ff ff       	call   80104440 <wakeup>
  release(&lk->lk);
80104e99:	89 75 08             	mov    %esi,0x8(%ebp)
80104e9c:	83 c4 10             	add    $0x10,%esp
}
80104e9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea2:	5b                   	pop    %ebx
80104ea3:	5e                   	pop    %esi
80104ea4:	5d                   	pop    %ebp
  release(&lk->lk);
80104ea5:	e9 56 02 00 00       	jmp    80105100 <release>
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104eb0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
80104eb5:	53                   	push   %ebx
80104eb6:	31 ff                	xor    %edi,%edi
80104eb8:	83 ec 18             	sub    $0x18,%esp
80104ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ebe:	8d 73 04             	lea    0x4(%ebx),%esi
80104ec1:	56                   	push   %esi
80104ec2:	e8 79 01 00 00       	call   80105040 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104ec7:	8b 03                	mov    (%ebx),%eax
80104ec9:	83 c4 10             	add    $0x10,%esp
80104ecc:	85 c0                	test   %eax,%eax
80104ece:	74 13                	je     80104ee3 <holdingsleep+0x33>
80104ed0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104ed3:	e8 38 ea ff ff       	call   80103910 <myproc>
80104ed8:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104edb:	0f 94 c0             	sete   %al
80104ede:	0f b6 c0             	movzbl %al,%eax
80104ee1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104ee3:	83 ec 0c             	sub    $0xc,%esp
80104ee6:	56                   	push   %esi
80104ee7:	e8 14 02 00 00       	call   80105100 <release>
  return r;
}
80104eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eef:	89 f8                	mov    %edi,%eax
80104ef1:	5b                   	pop    %ebx
80104ef2:	5e                   	pop    %esi
80104ef3:	5f                   	pop    %edi
80104ef4:	5d                   	pop    %ebp
80104ef5:	c3                   	ret    
80104ef6:	66 90                	xchg   %ax,%ax
80104ef8:	66 90                	xchg   %ax,%ax
80104efa:	66 90                	xchg   %ax,%ax
80104efc:	66 90                	xchg   %ax,%ax
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104f09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104f0f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104f12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    
80104f1b:	90                   	nop
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f20 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f20:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f21:	31 d2                	xor    %edx,%edx
{
80104f23:	89 e5                	mov    %esp,%ebp
80104f25:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104f26:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104f29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104f2c:	83 e8 08             	sub    $0x8,%eax
80104f2f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f30:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104f36:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f3c:	77 1a                	ja     80104f58 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f3e:	8b 58 04             	mov    0x4(%eax),%ebx
80104f41:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104f44:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104f47:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f49:	83 fa 0a             	cmp    $0xa,%edx
80104f4c:	75 e2                	jne    80104f30 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104f4e:	5b                   	pop    %ebx
80104f4f:	5d                   	pop    %ebp
80104f50:	c3                   	ret    
80104f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f58:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104f5b:	83 c1 28             	add    $0x28,%ecx
80104f5e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104f60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104f66:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104f69:	39 c1                	cmp    %eax,%ecx
80104f6b:	75 f3                	jne    80104f60 <getcallerpcs+0x40>
}
80104f6d:	5b                   	pop    %ebx
80104f6e:	5d                   	pop    %ebp
80104f6f:	c3                   	ret    

80104f70 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	53                   	push   %ebx
80104f74:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f77:	9c                   	pushf  
80104f78:	5b                   	pop    %ebx
  asm volatile("cli");
80104f79:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104f7a:	e8 f1 e8 ff ff       	call   80103870 <mycpu>
80104f7f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f85:	85 c0                	test   %eax,%eax
80104f87:	75 11                	jne    80104f9a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104f89:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104f8f:	e8 dc e8 ff ff       	call   80103870 <mycpu>
80104f94:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104f9a:	e8 d1 e8 ff ff       	call   80103870 <mycpu>
80104f9f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104fa6:	83 c4 04             	add    $0x4,%esp
80104fa9:	5b                   	pop    %ebx
80104faa:	5d                   	pop    %ebp
80104fab:	c3                   	ret    
80104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <popcli>:

void
popcli(void)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104fb6:	9c                   	pushf  
80104fb7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104fb8:	f6 c4 02             	test   $0x2,%ah
80104fbb:	75 35                	jne    80104ff2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104fbd:	e8 ae e8 ff ff       	call   80103870 <mycpu>
80104fc2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104fc9:	78 34                	js     80104fff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104fcb:	e8 a0 e8 ff ff       	call   80103870 <mycpu>
80104fd0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104fd6:	85 d2                	test   %edx,%edx
80104fd8:	74 06                	je     80104fe0 <popcli+0x30>
    sti();
}
80104fda:	c9                   	leave  
80104fdb:	c3                   	ret    
80104fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104fe0:	e8 8b e8 ff ff       	call   80103870 <mycpu>
80104fe5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104feb:	85 c0                	test   %eax,%eax
80104fed:	74 eb                	je     80104fda <popcli+0x2a>
  asm volatile("sti");
80104fef:	fb                   	sti    
}
80104ff0:	c9                   	leave  
80104ff1:	c3                   	ret    
    panic("popcli - interruptible");
80104ff2:	83 ec 0c             	sub    $0xc,%esp
80104ff5:	68 33 83 10 80       	push   $0x80108333
80104ffa:	e8 91 b3 ff ff       	call   80100390 <panic>
    panic("popcli");
80104fff:	83 ec 0c             	sub    $0xc,%esp
80105002:	68 4a 83 10 80       	push   $0x8010834a
80105007:	e8 84 b3 ff ff       	call   80100390 <panic>
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105010 <holding>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	8b 75 08             	mov    0x8(%ebp),%esi
80105018:	31 db                	xor    %ebx,%ebx
  pushcli();
8010501a:	e8 51 ff ff ff       	call   80104f70 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010501f:	8b 06                	mov    (%esi),%eax
80105021:	85 c0                	test   %eax,%eax
80105023:	74 10                	je     80105035 <holding+0x25>
80105025:	8b 5e 08             	mov    0x8(%esi),%ebx
80105028:	e8 43 e8 ff ff       	call   80103870 <mycpu>
8010502d:	39 c3                	cmp    %eax,%ebx
8010502f:	0f 94 c3             	sete   %bl
80105032:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105035:	e8 76 ff ff ff       	call   80104fb0 <popcli>
}
8010503a:	89 d8                	mov    %ebx,%eax
8010503c:	5b                   	pop    %ebx
8010503d:	5e                   	pop    %esi
8010503e:	5d                   	pop    %ebp
8010503f:	c3                   	ret    

80105040 <acquire>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105045:	e8 26 ff ff ff       	call   80104f70 <pushcli>
  if(holding(lk))
8010504a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010504d:	83 ec 0c             	sub    $0xc,%esp
80105050:	53                   	push   %ebx
80105051:	e8 ba ff ff ff       	call   80105010 <holding>
80105056:	83 c4 10             	add    $0x10,%esp
80105059:	85 c0                	test   %eax,%eax
8010505b:	0f 85 83 00 00 00    	jne    801050e4 <acquire+0xa4>
80105061:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105063:	ba 01 00 00 00       	mov    $0x1,%edx
80105068:	eb 09                	jmp    80105073 <acquire+0x33>
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105070:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105073:	89 d0                	mov    %edx,%eax
80105075:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105078:	85 c0                	test   %eax,%eax
8010507a:	75 f4                	jne    80105070 <acquire+0x30>
  __sync_synchronize();
8010507c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105081:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105084:	e8 e7 e7 ff ff       	call   80103870 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105089:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010508c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010508f:	89 e8                	mov    %ebp,%eax
80105091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105098:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010509e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801050a4:	77 1a                	ja     801050c0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801050a6:	8b 48 04             	mov    0x4(%eax),%ecx
801050a9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801050ac:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801050af:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801050b1:	83 fe 0a             	cmp    $0xa,%esi
801050b4:	75 e2                	jne    80105098 <acquire+0x58>
}
801050b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b9:	5b                   	pop    %ebx
801050ba:	5e                   	pop    %esi
801050bb:	5d                   	pop    %ebp
801050bc:	c3                   	ret    
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
801050c0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801050c3:	83 c2 28             	add    $0x28,%edx
801050c6:	8d 76 00             	lea    0x0(%esi),%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801050d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801050d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801050d9:	39 d0                	cmp    %edx,%eax
801050db:	75 f3                	jne    801050d0 <acquire+0x90>
}
801050dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e0:	5b                   	pop    %ebx
801050e1:	5e                   	pop    %esi
801050e2:	5d                   	pop    %ebp
801050e3:	c3                   	ret    
    panic("acquire");
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	68 c7 83 10 80       	push   $0x801083c7
801050ec:	e8 9f b2 ff ff       	call   80100390 <panic>
801050f1:	eb 0d                	jmp    80105100 <release>
801050f3:	90                   	nop
801050f4:	90                   	nop
801050f5:	90                   	nop
801050f6:	90                   	nop
801050f7:	90                   	nop
801050f8:	90                   	nop
801050f9:	90                   	nop
801050fa:	90                   	nop
801050fb:	90                   	nop
801050fc:	90                   	nop
801050fd:	90                   	nop
801050fe:	90                   	nop
801050ff:	90                   	nop

80105100 <release>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	53                   	push   %ebx
80105104:	83 ec 10             	sub    $0x10,%esp
80105107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010510a:	53                   	push   %ebx
8010510b:	e8 00 ff ff ff       	call   80105010 <holding>
80105110:	83 c4 10             	add    $0x10,%esp
80105113:	85 c0                	test   %eax,%eax
80105115:	74 22                	je     80105139 <release+0x39>
  lk->pcs[0] = 0;
80105117:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010511e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105125:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010512a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105133:	c9                   	leave  
  popcli();
80105134:	e9 77 fe ff ff       	jmp    80104fb0 <popcli>
    cprintf( "\n LOCK THAT FUCKED US IS -- %s  \n" , lk->name );
80105139:	50                   	push   %eax
8010513a:	50                   	push   %eax
8010513b:	ff 73 04             	pushl  0x4(%ebx)
8010513e:	68 d8 83 10 80       	push   $0x801083d8
80105143:	e8 18 b5 ff ff       	call   80100660 <cprintf>
    panic("release");}
80105148:	c7 04 24 cf 83 10 80 	movl   $0x801083cf,(%esp)
8010514f:	e8 3c b2 ff ff       	call   80100390 <panic>
80105154:	66 90                	xchg   %ax,%ax
80105156:	66 90                	xchg   %ax,%ax
80105158:	66 90                	xchg   %ax,%ax
8010515a:	66 90                	xchg   %ax,%ax
8010515c:	66 90                	xchg   %ax,%ax
8010515e:	66 90                	xchg   %ax,%ax

80105160 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	53                   	push   %ebx
80105165:	8b 55 08             	mov    0x8(%ebp),%edx
80105168:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010516b:	f6 c2 03             	test   $0x3,%dl
8010516e:	75 05                	jne    80105175 <memset+0x15>
80105170:	f6 c1 03             	test   $0x3,%cl
80105173:	74 13                	je     80105188 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105175:	89 d7                	mov    %edx,%edi
80105177:	8b 45 0c             	mov    0xc(%ebp),%eax
8010517a:	fc                   	cld    
8010517b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010517d:	5b                   	pop    %ebx
8010517e:	89 d0                	mov    %edx,%eax
80105180:	5f                   	pop    %edi
80105181:	5d                   	pop    %ebp
80105182:	c3                   	ret    
80105183:	90                   	nop
80105184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105188:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010518c:	c1 e9 02             	shr    $0x2,%ecx
8010518f:	89 f8                	mov    %edi,%eax
80105191:	89 fb                	mov    %edi,%ebx
80105193:	c1 e0 18             	shl    $0x18,%eax
80105196:	c1 e3 10             	shl    $0x10,%ebx
80105199:	09 d8                	or     %ebx,%eax
8010519b:	09 f8                	or     %edi,%eax
8010519d:	c1 e7 08             	shl    $0x8,%edi
801051a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801051a2:	89 d7                	mov    %edx,%edi
801051a4:	fc                   	cld    
801051a5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801051a7:	5b                   	pop    %ebx
801051a8:	89 d0                	mov    %edx,%eax
801051aa:	5f                   	pop    %edi
801051ab:	5d                   	pop    %ebp
801051ac:	c3                   	ret    
801051ad:	8d 76 00             	lea    0x0(%esi),%esi

801051b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
801051b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801051b9:	8b 75 08             	mov    0x8(%ebp),%esi
801051bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801051bf:	85 db                	test   %ebx,%ebx
801051c1:	74 29                	je     801051ec <memcmp+0x3c>
    if(*s1 != *s2)
801051c3:	0f b6 16             	movzbl (%esi),%edx
801051c6:	0f b6 0f             	movzbl (%edi),%ecx
801051c9:	38 d1                	cmp    %dl,%cl
801051cb:	75 2b                	jne    801051f8 <memcmp+0x48>
801051cd:	b8 01 00 00 00       	mov    $0x1,%eax
801051d2:	eb 14                	jmp    801051e8 <memcmp+0x38>
801051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051d8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801051dc:	83 c0 01             	add    $0x1,%eax
801051df:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801051e4:	38 ca                	cmp    %cl,%dl
801051e6:	75 10                	jne    801051f8 <memcmp+0x48>
  while(n-- > 0){
801051e8:	39 d8                	cmp    %ebx,%eax
801051ea:	75 ec                	jne    801051d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801051ec:	5b                   	pop    %ebx
  return 0;
801051ed:	31 c0                	xor    %eax,%eax
}
801051ef:	5e                   	pop    %esi
801051f0:	5f                   	pop    %edi
801051f1:	5d                   	pop    %ebp
801051f2:	c3                   	ret    
801051f3:	90                   	nop
801051f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801051f8:	0f b6 c2             	movzbl %dl,%eax
}
801051fb:	5b                   	pop    %ebx
      return *s1 - *s2;
801051fc:	29 c8                	sub    %ecx,%eax
}
801051fe:	5e                   	pop    %esi
801051ff:	5f                   	pop    %edi
80105200:	5d                   	pop    %ebp
80105201:	c3                   	ret    
80105202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105210 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
80105215:	8b 45 08             	mov    0x8(%ebp),%eax
80105218:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010521b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010521e:	39 c3                	cmp    %eax,%ebx
80105220:	73 26                	jae    80105248 <memmove+0x38>
80105222:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105225:	39 c8                	cmp    %ecx,%eax
80105227:	73 1f                	jae    80105248 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105229:	85 f6                	test   %esi,%esi
8010522b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010522e:	74 0f                	je     8010523f <memmove+0x2f>
      *--d = *--s;
80105230:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105234:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105237:	83 ea 01             	sub    $0x1,%edx
8010523a:	83 fa ff             	cmp    $0xffffffff,%edx
8010523d:	75 f1                	jne    80105230 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010523f:	5b                   	pop    %ebx
80105240:	5e                   	pop    %esi
80105241:	5d                   	pop    %ebp
80105242:	c3                   	ret    
80105243:	90                   	nop
80105244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105248:	31 d2                	xor    %edx,%edx
8010524a:	85 f6                	test   %esi,%esi
8010524c:	74 f1                	je     8010523f <memmove+0x2f>
8010524e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105250:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105254:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105257:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010525a:	39 d6                	cmp    %edx,%esi
8010525c:	75 f2                	jne    80105250 <memmove+0x40>
}
8010525e:	5b                   	pop    %ebx
8010525f:	5e                   	pop    %esi
80105260:	5d                   	pop    %ebp
80105261:	c3                   	ret    
80105262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105270 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105273:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105274:	eb 9a                	jmp    80105210 <memmove>
80105276:	8d 76 00             	lea    0x0(%esi),%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	8b 7d 10             	mov    0x10(%ebp),%edi
80105288:	53                   	push   %ebx
80105289:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010528c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010528f:	85 ff                	test   %edi,%edi
80105291:	74 2f                	je     801052c2 <strncmp+0x42>
80105293:	0f b6 01             	movzbl (%ecx),%eax
80105296:	0f b6 1e             	movzbl (%esi),%ebx
80105299:	84 c0                	test   %al,%al
8010529b:	74 37                	je     801052d4 <strncmp+0x54>
8010529d:	38 c3                	cmp    %al,%bl
8010529f:	75 33                	jne    801052d4 <strncmp+0x54>
801052a1:	01 f7                	add    %esi,%edi
801052a3:	eb 13                	jmp    801052b8 <strncmp+0x38>
801052a5:	8d 76 00             	lea    0x0(%esi),%esi
801052a8:	0f b6 01             	movzbl (%ecx),%eax
801052ab:	84 c0                	test   %al,%al
801052ad:	74 21                	je     801052d0 <strncmp+0x50>
801052af:	0f b6 1a             	movzbl (%edx),%ebx
801052b2:	89 d6                	mov    %edx,%esi
801052b4:	38 d8                	cmp    %bl,%al
801052b6:	75 1c                	jne    801052d4 <strncmp+0x54>
    n--, p++, q++;
801052b8:	8d 56 01             	lea    0x1(%esi),%edx
801052bb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801052be:	39 fa                	cmp    %edi,%edx
801052c0:	75 e6                	jne    801052a8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801052c2:	5b                   	pop    %ebx
    return 0;
801052c3:	31 c0                	xor    %eax,%eax
}
801052c5:	5e                   	pop    %esi
801052c6:	5f                   	pop    %edi
801052c7:	5d                   	pop    %ebp
801052c8:	c3                   	ret    
801052c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052d0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801052d4:	29 d8                	sub    %ebx,%eax
}
801052d6:	5b                   	pop    %ebx
801052d7:	5e                   	pop    %esi
801052d8:	5f                   	pop    %edi
801052d9:	5d                   	pop    %ebp
801052da:	c3                   	ret    
801052db:	90                   	nop
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
801052e5:	8b 45 08             	mov    0x8(%ebp),%eax
801052e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801052eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801052ee:	89 c2                	mov    %eax,%edx
801052f0:	eb 19                	jmp    8010530b <strncpy+0x2b>
801052f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052f8:	83 c3 01             	add    $0x1,%ebx
801052fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801052ff:	83 c2 01             	add    $0x1,%edx
80105302:	84 c9                	test   %cl,%cl
80105304:	88 4a ff             	mov    %cl,-0x1(%edx)
80105307:	74 09                	je     80105312 <strncpy+0x32>
80105309:	89 f1                	mov    %esi,%ecx
8010530b:	85 c9                	test   %ecx,%ecx
8010530d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105310:	7f e6                	jg     801052f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105312:	31 c9                	xor    %ecx,%ecx
80105314:	85 f6                	test   %esi,%esi
80105316:	7e 17                	jle    8010532f <strncpy+0x4f>
80105318:	90                   	nop
80105319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105320:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105324:	89 f3                	mov    %esi,%ebx
80105326:	83 c1 01             	add    $0x1,%ecx
80105329:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010532b:	85 db                	test   %ebx,%ebx
8010532d:	7f f1                	jg     80105320 <strncpy+0x40>
  return os;
}
8010532f:	5b                   	pop    %ebx
80105330:	5e                   	pop    %esi
80105331:	5d                   	pop    %ebp
80105332:	c3                   	ret    
80105333:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	53                   	push   %ebx
80105345:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105348:	8b 45 08             	mov    0x8(%ebp),%eax
8010534b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010534e:	85 c9                	test   %ecx,%ecx
80105350:	7e 26                	jle    80105378 <safestrcpy+0x38>
80105352:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105356:	89 c1                	mov    %eax,%ecx
80105358:	eb 17                	jmp    80105371 <safestrcpy+0x31>
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105360:	83 c2 01             	add    $0x1,%edx
80105363:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105367:	83 c1 01             	add    $0x1,%ecx
8010536a:	84 db                	test   %bl,%bl
8010536c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010536f:	74 04                	je     80105375 <safestrcpy+0x35>
80105371:	39 f2                	cmp    %esi,%edx
80105373:	75 eb                	jne    80105360 <safestrcpy+0x20>
    ;
  *s = 0;
80105375:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105378:	5b                   	pop    %ebx
80105379:	5e                   	pop    %esi
8010537a:	5d                   	pop    %ebp
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <strlen>:

int
strlen(const char *s)
{
80105380:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105381:	31 c0                	xor    %eax,%eax
{
80105383:	89 e5                	mov    %esp,%ebp
80105385:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105388:	80 3a 00             	cmpb   $0x0,(%edx)
8010538b:	74 0c                	je     80105399 <strlen+0x19>
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
80105390:	83 c0 01             	add    $0x1,%eax
80105393:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105397:	75 f7                	jne    80105390 <strlen+0x10>
    ;
  return n;
}
80105399:	5d                   	pop    %ebp
8010539a:	c3                   	ret    

8010539b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010539b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010539f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801053a3:	55                   	push   %ebp
  pushl %ebx
801053a4:	53                   	push   %ebx
  pushl %esi
801053a5:	56                   	push   %esi
  pushl %edi
801053a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801053a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801053a9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801053ab:	5f                   	pop    %edi
  popl %esi
801053ac:	5e                   	pop    %esi
  popl %ebx
801053ad:	5b                   	pop    %ebx
  popl %ebp
801053ae:	5d                   	pop    %ebp
  ret
801053af:	c3                   	ret    

801053b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	53                   	push   %ebx
801053b4:	83 ec 04             	sub    $0x4,%esp
801053b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801053ba:	e8 51 e5 ff ff       	call   80103910 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053bf:	8b 00                	mov    (%eax),%eax
801053c1:	39 d8                	cmp    %ebx,%eax
801053c3:	76 1b                	jbe    801053e0 <fetchint+0x30>
801053c5:	8d 53 04             	lea    0x4(%ebx),%edx
801053c8:	39 d0                	cmp    %edx,%eax
801053ca:	72 14                	jb     801053e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801053cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801053cf:	8b 13                	mov    (%ebx),%edx
801053d1:	89 10                	mov    %edx,(%eax)
  return 0;
801053d3:	31 c0                	xor    %eax,%eax
}
801053d5:	83 c4 04             	add    $0x4,%esp
801053d8:	5b                   	pop    %ebx
801053d9:	5d                   	pop    %ebp
801053da:	c3                   	ret    
801053db:	90                   	nop
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801053e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e5:	eb ee                	jmp    801053d5 <fetchint+0x25>
801053e7:	89 f6                	mov    %esi,%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	53                   	push   %ebx
801053f4:	83 ec 04             	sub    $0x4,%esp
801053f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801053fa:	e8 11 e5 ff ff       	call   80103910 <myproc>

  if(addr >= curproc->sz)
801053ff:	39 18                	cmp    %ebx,(%eax)
80105401:	76 29                	jbe    8010542c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105403:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105406:	89 da                	mov    %ebx,%edx
80105408:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010540a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010540c:	39 c3                	cmp    %eax,%ebx
8010540e:	73 1c                	jae    8010542c <fetchstr+0x3c>
    if(*s == 0)
80105410:	80 3b 00             	cmpb   $0x0,(%ebx)
80105413:	75 10                	jne    80105425 <fetchstr+0x35>
80105415:	eb 39                	jmp    80105450 <fetchstr+0x60>
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105420:	80 3a 00             	cmpb   $0x0,(%edx)
80105423:	74 1b                	je     80105440 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105425:	83 c2 01             	add    $0x1,%edx
80105428:	39 d0                	cmp    %edx,%eax
8010542a:	77 f4                	ja     80105420 <fetchstr+0x30>
    return -1;
8010542c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105431:	83 c4 04             	add    $0x4,%esp
80105434:	5b                   	pop    %ebx
80105435:	5d                   	pop    %ebp
80105436:	c3                   	ret    
80105437:	89 f6                	mov    %esi,%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105440:	83 c4 04             	add    $0x4,%esp
80105443:	89 d0                	mov    %edx,%eax
80105445:	29 d8                	sub    %ebx,%eax
80105447:	5b                   	pop    %ebx
80105448:	5d                   	pop    %ebp
80105449:	c3                   	ret    
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105450:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105452:	eb dd                	jmp    80105431 <fetchstr+0x41>
80105454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010545a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105460 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
80105465:	e8 d6 e4 ff ff       	call   80103940 <mythread>
8010546a:	8b 40 10             	mov    0x10(%eax),%eax
8010546d:	8b 55 08             	mov    0x8(%ebp),%edx
80105470:	8b 40 44             	mov    0x44(%eax),%eax
80105473:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105476:	e8 95 e4 ff ff       	call   80103910 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010547b:	8b 00                	mov    (%eax),%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
8010547d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105480:	39 c6                	cmp    %eax,%esi
80105482:	73 1c                	jae    801054a0 <argint+0x40>
80105484:	8d 53 08             	lea    0x8(%ebx),%edx
80105487:	39 d0                	cmp    %edx,%eax
80105489:	72 15                	jb     801054a0 <argint+0x40>
  *ip = *(int*)(addr);
8010548b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010548e:	8b 53 04             	mov    0x4(%ebx),%edx
80105491:	89 10                	mov    %edx,(%eax)
  return 0;
80105493:	31 c0                	xor    %eax,%eax
}
80105495:	5b                   	pop    %ebx
80105496:	5e                   	pop    %esi
80105497:	5d                   	pop    %ebp
80105498:	c3                   	ret    
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((mythread()->tf->esp) + 4 + 4*n, ip);
801054a5:	eb ee                	jmp    80105495 <argint+0x35>
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	53                   	push   %ebx
801054b5:	83 ec 10             	sub    $0x10,%esp
801054b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801054bb:	e8 50 e4 ff ff       	call   80103910 <myproc>
801054c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801054c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054c5:	83 ec 08             	sub    $0x8,%esp
801054c8:	50                   	push   %eax
801054c9:	ff 75 08             	pushl  0x8(%ebp)
801054cc:	e8 8f ff ff ff       	call   80105460 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801054d1:	83 c4 10             	add    $0x10,%esp
801054d4:	85 c0                	test   %eax,%eax
801054d6:	78 28                	js     80105500 <argptr+0x50>
801054d8:	85 db                	test   %ebx,%ebx
801054da:	78 24                	js     80105500 <argptr+0x50>
801054dc:	8b 16                	mov    (%esi),%edx
801054de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e1:	39 c2                	cmp    %eax,%edx
801054e3:	76 1b                	jbe    80105500 <argptr+0x50>
801054e5:	01 c3                	add    %eax,%ebx
801054e7:	39 da                	cmp    %ebx,%edx
801054e9:	72 15                	jb     80105500 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801054eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801054ee:	89 02                	mov    %eax,(%edx)
  return 0;
801054f0:	31 c0                	xor    %eax,%eax
}
801054f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054f5:	5b                   	pop    %ebx
801054f6:	5e                   	pop    %esi
801054f7:	5d                   	pop    %ebp
801054f8:	c3                   	ret    
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105505:	eb eb                	jmp    801054f2 <argptr+0x42>
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105516:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105519:	50                   	push   %eax
8010551a:	ff 75 08             	pushl  0x8(%ebp)
8010551d:	e8 3e ff ff ff       	call   80105460 <argint>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	85 c0                	test   %eax,%eax
80105527:	78 17                	js     80105540 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105529:	83 ec 08             	sub    $0x8,%esp
8010552c:	ff 75 0c             	pushl  0xc(%ebp)
8010552f:	ff 75 f4             	pushl  -0xc(%ebp)
80105532:	e8 b9 fe ff ff       	call   801053f0 <fetchstr>
80105537:	83 c4 10             	add    $0x10,%esp
}
8010553a:	c9                   	leave  
8010553b:	c3                   	ret    
8010553c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105545:	c9                   	leave  
80105546:	c3                   	ret    
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <syscall>:
[SYS_kthread_join]   sys_kthread_join,
};

void
syscall(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105555:	e8 b6 e3 ff ff       	call   80103910 <myproc>
8010555a:	89 c6                	mov    %eax,%esi
  struct thread *curthread = mythread();
8010555c:	e8 df e3 ff ff       	call   80103940 <mythread>
80105561:	89 c3                	mov    %eax,%ebx

  num = curthread->tf->eax;
80105563:	8b 40 10             	mov    0x10(%eax),%eax
80105566:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105569:	8d 50 ff             	lea    -0x1(%eax),%edx
8010556c:	83 fa 18             	cmp    $0x18,%edx
8010556f:	77 1f                	ja     80105590 <syscall+0x40>
80105571:	8b 14 85 20 84 10 80 	mov    -0x7fef7be0(,%eax,4),%edx
80105578:	85 d2                	test   %edx,%edx
8010557a:	74 14                	je     80105590 <syscall+0x40>
    curthread->tf->eax = syscalls[num]();
8010557c:	ff d2                	call   *%edx
8010557e:	8b 53 10             	mov    0x10(%ebx),%edx
80105581:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curthread->tf->eax = -1;
  }
}
80105584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105587:	5b                   	pop    %ebx
80105588:	5e                   	pop    %esi
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret    
8010558b:	90                   	nop
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105590:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105591:	8d 46 64             	lea    0x64(%esi),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105594:	50                   	push   %eax
80105595:	ff 76 0c             	pushl  0xc(%esi)
80105598:	68 fa 83 10 80       	push   $0x801083fa
8010559d:	e8 be b0 ff ff       	call   80100660 <cprintf>
    curthread->tf->eax = -1;
801055a2:	8b 43 10             	mov    0x10(%ebx),%eax
801055a5:	83 c4 10             	add    $0x10,%esp
801055a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801055af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055b2:	5b                   	pop    %ebx
801055b3:	5e                   	pop    %esi
801055b4:	5d                   	pop    %ebp
801055b5:	c3                   	ret    
801055b6:	66 90                	xchg   %ax,%ax
801055b8:	66 90                	xchg   %ax,%ax
801055ba:	66 90                	xchg   %ax,%ax
801055bc:	66 90                	xchg   %ax,%ax
801055be:	66 90                	xchg   %ax,%ax

801055c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
801055c5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055c6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801055c9:	83 ec 44             	sub    $0x44,%esp
801055cc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801055cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801055d2:	56                   	push   %esi
801055d3:	50                   	push   %eax
{
801055d4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801055d7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801055da:	e8 51 c9 ff ff       	call   80101f30 <nameiparent>
801055df:	83 c4 10             	add    $0x10,%esp
801055e2:	85 c0                	test   %eax,%eax
801055e4:	0f 84 46 01 00 00    	je     80105730 <create+0x170>
    return 0;
  ilock(dp);
801055ea:	83 ec 0c             	sub    $0xc,%esp
801055ed:	89 c3                	mov    %eax,%ebx
801055ef:	50                   	push   %eax
801055f0:	e8 bb c0 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801055f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801055f8:	83 c4 0c             	add    $0xc,%esp
801055fb:	50                   	push   %eax
801055fc:	56                   	push   %esi
801055fd:	53                   	push   %ebx
801055fe:	e8 dd c5 ff ff       	call   80101be0 <dirlookup>
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	89 c7                	mov    %eax,%edi
8010560a:	74 34                	je     80105640 <create+0x80>
    iunlockput(dp);
8010560c:	83 ec 0c             	sub    $0xc,%esp
8010560f:	53                   	push   %ebx
80105610:	e8 2b c3 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
80105615:	89 3c 24             	mov    %edi,(%esp)
80105618:	e8 93 c0 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105625:	0f 85 95 00 00 00    	jne    801056c0 <create+0x100>
8010562b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105630:	0f 85 8a 00 00 00    	jne    801056c0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105639:	89 f8                	mov    %edi,%eax
8010563b:	5b                   	pop    %ebx
8010563c:	5e                   	pop    %esi
8010563d:	5f                   	pop    %edi
8010563e:	5d                   	pop    %ebp
8010563f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105640:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105644:	83 ec 08             	sub    $0x8,%esp
80105647:	50                   	push   %eax
80105648:	ff 33                	pushl  (%ebx)
8010564a:	e8 f1 be ff ff       	call   80101540 <ialloc>
8010564f:	83 c4 10             	add    $0x10,%esp
80105652:	85 c0                	test   %eax,%eax
80105654:	89 c7                	mov    %eax,%edi
80105656:	0f 84 e8 00 00 00    	je     80105744 <create+0x184>
  ilock(ip);
8010565c:	83 ec 0c             	sub    $0xc,%esp
8010565f:	50                   	push   %eax
80105660:	e8 4b c0 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80105665:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105669:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010566d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105671:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105675:	b8 01 00 00 00       	mov    $0x1,%eax
8010567a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010567e:	89 3c 24             	mov    %edi,(%esp)
80105681:	e8 7a bf ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010568e:	74 50                	je     801056e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105690:	83 ec 04             	sub    $0x4,%esp
80105693:	ff 77 04             	pushl  0x4(%edi)
80105696:	56                   	push   %esi
80105697:	53                   	push   %ebx
80105698:	e8 b3 c7 ff ff       	call   80101e50 <dirlink>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	85 c0                	test   %eax,%eax
801056a2:	0f 88 8f 00 00 00    	js     80105737 <create+0x177>
  iunlockput(dp);
801056a8:	83 ec 0c             	sub    $0xc,%esp
801056ab:	53                   	push   %ebx
801056ac:	e8 8f c2 ff ff       	call   80101940 <iunlockput>
  return ip;
801056b1:	83 c4 10             	add    $0x10,%esp
}
801056b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b7:	89 f8                	mov    %edi,%eax
801056b9:	5b                   	pop    %ebx
801056ba:	5e                   	pop    %esi
801056bb:	5f                   	pop    %edi
801056bc:	5d                   	pop    %ebp
801056bd:	c3                   	ret    
801056be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	57                   	push   %edi
    return 0;
801056c4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801056c6:	e8 75 c2 ff ff       	call   80101940 <iunlockput>
    return 0;
801056cb:	83 c4 10             	add    $0x10,%esp
}
801056ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056d1:	89 f8                	mov    %edi,%eax
801056d3:	5b                   	pop    %ebx
801056d4:	5e                   	pop    %esi
801056d5:	5f                   	pop    %edi
801056d6:	5d                   	pop    %ebp
801056d7:	c3                   	ret    
801056d8:	90                   	nop
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801056e0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801056e5:	83 ec 0c             	sub    $0xc,%esp
801056e8:	53                   	push   %ebx
801056e9:	e8 12 bf ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801056ee:	83 c4 0c             	add    $0xc,%esp
801056f1:	ff 77 04             	pushl  0x4(%edi)
801056f4:	68 a4 84 10 80       	push   $0x801084a4
801056f9:	57                   	push   %edi
801056fa:	e8 51 c7 ff ff       	call   80101e50 <dirlink>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	78 1c                	js     80105722 <create+0x162>
80105706:	83 ec 04             	sub    $0x4,%esp
80105709:	ff 73 04             	pushl  0x4(%ebx)
8010570c:	68 a3 84 10 80       	push   $0x801084a3
80105711:	57                   	push   %edi
80105712:	e8 39 c7 ff ff       	call   80101e50 <dirlink>
80105717:	83 c4 10             	add    $0x10,%esp
8010571a:	85 c0                	test   %eax,%eax
8010571c:	0f 89 6e ff ff ff    	jns    80105690 <create+0xd0>
      panic("create dots");
80105722:	83 ec 0c             	sub    $0xc,%esp
80105725:	68 97 84 10 80       	push   $0x80108497
8010572a:	e8 61 ac ff ff       	call   80100390 <panic>
8010572f:	90                   	nop
    return 0;
80105730:	31 ff                	xor    %edi,%edi
80105732:	e9 ff fe ff ff       	jmp    80105636 <create+0x76>
    panic("create: dirlink");
80105737:	83 ec 0c             	sub    $0xc,%esp
8010573a:	68 a6 84 10 80       	push   $0x801084a6
8010573f:	e8 4c ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105744:	83 ec 0c             	sub    $0xc,%esp
80105747:	68 88 84 10 80       	push   $0x80108488
8010574c:	e8 3f ac ff ff       	call   80100390 <panic>
80105751:	eb 0d                	jmp    80105760 <argfd.constprop.0>
80105753:	90                   	nop
80105754:	90                   	nop
80105755:	90                   	nop
80105756:	90                   	nop
80105757:	90                   	nop
80105758:	90                   	nop
80105759:	90                   	nop
8010575a:	90                   	nop
8010575b:	90                   	nop
8010575c:	90                   	nop
8010575d:	90                   	nop
8010575e:	90                   	nop
8010575f:	90                   	nop

80105760 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	56                   	push   %esi
80105764:	53                   	push   %ebx
80105765:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105767:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010576a:	89 d6                	mov    %edx,%esi
8010576c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010576f:	50                   	push   %eax
80105770:	6a 00                	push   $0x0
80105772:	e8 e9 fc ff ff       	call   80105460 <argint>
80105777:	83 c4 10             	add    $0x10,%esp
8010577a:	85 c0                	test   %eax,%eax
8010577c:	78 2a                	js     801057a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010577e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105782:	77 24                	ja     801057a8 <argfd.constprop.0+0x48>
80105784:	e8 87 e1 ff ff       	call   80103910 <myproc>
80105789:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010578c:	8b 44 90 20          	mov    0x20(%eax,%edx,4),%eax
80105790:	85 c0                	test   %eax,%eax
80105792:	74 14                	je     801057a8 <argfd.constprop.0+0x48>
  if(pfd)
80105794:	85 db                	test   %ebx,%ebx
80105796:	74 02                	je     8010579a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105798:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010579a:	89 06                	mov    %eax,(%esi)
  return 0;
8010579c:	31 c0                	xor    %eax,%eax
}
8010579e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a1:	5b                   	pop    %ebx
801057a2:	5e                   	pop    %esi
801057a3:	5d                   	pop    %ebp
801057a4:	c3                   	ret    
801057a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ad:	eb ef                	jmp    8010579e <argfd.constprop.0+0x3e>
801057af:	90                   	nop

801057b0 <sys_dup>:
{
801057b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801057b1:	31 c0                	xor    %eax,%eax
{
801057b3:	89 e5                	mov    %esp,%ebp
801057b5:	56                   	push   %esi
801057b6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801057b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801057ba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801057bd:	e8 9e ff ff ff       	call   80105760 <argfd.constprop.0>
801057c2:	85 c0                	test   %eax,%eax
801057c4:	78 42                	js     80105808 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801057c6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057c9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057cb:	e8 40 e1 ff ff       	call   80103910 <myproc>
801057d0:	eb 0e                	jmp    801057e0 <sys_dup+0x30>
801057d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057d8:	83 c3 01             	add    $0x1,%ebx
801057db:	83 fb 10             	cmp    $0x10,%ebx
801057de:	74 28                	je     80105808 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801057e0:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
801057e4:	85 d2                	test   %edx,%edx
801057e6:	75 f0                	jne    801057d8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801057e8:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
  filedup(f);
801057ec:	83 ec 0c             	sub    $0xc,%esp
801057ef:	ff 75 f4             	pushl  -0xc(%ebp)
801057f2:	e8 19 b6 ff ff       	call   80100e10 <filedup>
  return fd;
801057f7:	83 c4 10             	add    $0x10,%esp
}
801057fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057fd:	89 d8                	mov    %ebx,%eax
801057ff:	5b                   	pop    %ebx
80105800:	5e                   	pop    %esi
80105801:	5d                   	pop    %ebp
80105802:	c3                   	ret    
80105803:	90                   	nop
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105808:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010580b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105810:	89 d8                	mov    %ebx,%eax
80105812:	5b                   	pop    %ebx
80105813:	5e                   	pop    %esi
80105814:	5d                   	pop    %ebp
80105815:	c3                   	ret    
80105816:	8d 76 00             	lea    0x0(%esi),%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <sys_read>:
{
80105820:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105821:	31 c0                	xor    %eax,%eax
{
80105823:	89 e5                	mov    %esp,%ebp
80105825:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105828:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010582b:	e8 30 ff ff ff       	call   80105760 <argfd.constprop.0>
80105830:	85 c0                	test   %eax,%eax
80105832:	78 4c                	js     80105880 <sys_read+0x60>
80105834:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	50                   	push   %eax
8010583b:	6a 02                	push   $0x2
8010583d:	e8 1e fc ff ff       	call   80105460 <argint>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	78 37                	js     80105880 <sys_read+0x60>
80105849:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010584c:	83 ec 04             	sub    $0x4,%esp
8010584f:	ff 75 f0             	pushl  -0x10(%ebp)
80105852:	50                   	push   %eax
80105853:	6a 01                	push   $0x1
80105855:	e8 56 fc ff ff       	call   801054b0 <argptr>
8010585a:	83 c4 10             	add    $0x10,%esp
8010585d:	85 c0                	test   %eax,%eax
8010585f:	78 1f                	js     80105880 <sys_read+0x60>
  return fileread(f, p, n);
80105861:	83 ec 04             	sub    $0x4,%esp
80105864:	ff 75 f0             	pushl  -0x10(%ebp)
80105867:	ff 75 f4             	pushl  -0xc(%ebp)
8010586a:	ff 75 ec             	pushl  -0x14(%ebp)
8010586d:	e8 0e b7 ff ff       	call   80100f80 <fileread>
80105872:	83 c4 10             	add    $0x10,%esp
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105885:	c9                   	leave  
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <sys_write>:
{
80105890:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105891:	31 c0                	xor    %eax,%eax
{
80105893:	89 e5                	mov    %esp,%ebp
80105895:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105898:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010589b:	e8 c0 fe ff ff       	call   80105760 <argfd.constprop.0>
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 4c                	js     801058f0 <sys_write+0x60>
801058a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a7:	83 ec 08             	sub    $0x8,%esp
801058aa:	50                   	push   %eax
801058ab:	6a 02                	push   $0x2
801058ad:	e8 ae fb ff ff       	call   80105460 <argint>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 37                	js     801058f0 <sys_write+0x60>
801058b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058bc:	83 ec 04             	sub    $0x4,%esp
801058bf:	ff 75 f0             	pushl  -0x10(%ebp)
801058c2:	50                   	push   %eax
801058c3:	6a 01                	push   $0x1
801058c5:	e8 e6 fb ff ff       	call   801054b0 <argptr>
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	85 c0                	test   %eax,%eax
801058cf:	78 1f                	js     801058f0 <sys_write+0x60>
  return filewrite(f, p, n);
801058d1:	83 ec 04             	sub    $0x4,%esp
801058d4:	ff 75 f0             	pushl  -0x10(%ebp)
801058d7:	ff 75 f4             	pushl  -0xc(%ebp)
801058da:	ff 75 ec             	pushl  -0x14(%ebp)
801058dd:	e8 2e b7 ff ff       	call   80101010 <filewrite>
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

80105900 <sys_close>:
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105906:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105909:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010590c:	e8 4f fe ff ff       	call   80105760 <argfd.constprop.0>
80105911:	85 c0                	test   %eax,%eax
80105913:	78 2b                	js     80105940 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105915:	e8 f6 df ff ff       	call   80103910 <myproc>
8010591a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010591d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105920:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
80105927:	00 
  fileclose(f);
80105928:	ff 75 f4             	pushl  -0xc(%ebp)
8010592b:	e8 30 b5 ff ff       	call   80100e60 <fileclose>
  return 0;
80105930:	83 c4 10             	add    $0x10,%esp
80105933:	31 c0                	xor    %eax,%eax
}
80105935:	c9                   	leave  
80105936:	c3                   	ret    
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105945:	c9                   	leave  
80105946:	c3                   	ret    
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105950 <sys_fstat>:
{
80105950:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105951:	31 c0                	xor    %eax,%eax
{
80105953:	89 e5                	mov    %esp,%ebp
80105955:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105958:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010595b:	e8 00 fe ff ff       	call   80105760 <argfd.constprop.0>
80105960:	85 c0                	test   %eax,%eax
80105962:	78 2c                	js     80105990 <sys_fstat+0x40>
80105964:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105967:	83 ec 04             	sub    $0x4,%esp
8010596a:	6a 14                	push   $0x14
8010596c:	50                   	push   %eax
8010596d:	6a 01                	push   $0x1
8010596f:	e8 3c fb ff ff       	call   801054b0 <argptr>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	78 15                	js     80105990 <sys_fstat+0x40>
  return filestat(f, st);
8010597b:	83 ec 08             	sub    $0x8,%esp
8010597e:	ff 75 f4             	pushl  -0xc(%ebp)
80105981:	ff 75 f0             	pushl  -0x10(%ebp)
80105984:	e8 a7 b5 ff ff       	call   80100f30 <filestat>
80105989:	83 c4 10             	add    $0x10,%esp
}
8010598c:	c9                   	leave  
8010598d:	c3                   	ret    
8010598e:	66 90                	xchg   %ax,%ax
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105995:	c9                   	leave  
80105996:	c3                   	ret    
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059a0 <sys_link>:
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	57                   	push   %edi
801059a4:	56                   	push   %esi
801059a5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801059a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059ac:	50                   	push   %eax
801059ad:	6a 00                	push   $0x0
801059af:	e8 5c fb ff ff       	call   80105510 <argstr>
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	85 c0                	test   %eax,%eax
801059b9:	0f 88 fb 00 00 00    	js     80105aba <sys_link+0x11a>
801059bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801059c2:	83 ec 08             	sub    $0x8,%esp
801059c5:	50                   	push   %eax
801059c6:	6a 01                	push   $0x1
801059c8:	e8 43 fb ff ff       	call   80105510 <argstr>
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	85 c0                	test   %eax,%eax
801059d2:	0f 88 e2 00 00 00    	js     80105aba <sys_link+0x11a>
  begin_op();
801059d8:	e8 f3 d1 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801059e3:	e8 28 c5 ff ff       	call   80101f10 <namei>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	85 c0                	test   %eax,%eax
801059ed:	89 c3                	mov    %eax,%ebx
801059ef:	0f 84 ea 00 00 00    	je     80105adf <sys_link+0x13f>
  ilock(ip);
801059f5:	83 ec 0c             	sub    $0xc,%esp
801059f8:	50                   	push   %eax
801059f9:	e8 b2 bc ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a06:	0f 84 bb 00 00 00    	je     80105ac7 <sys_link+0x127>
  ip->nlink++;
80105a0c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a11:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105a14:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a17:	53                   	push   %ebx
80105a18:	e8 e3 bb ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80105a1d:	89 1c 24             	mov    %ebx,(%esp)
80105a20:	e8 6b bd ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a25:	58                   	pop    %eax
80105a26:	5a                   	pop    %edx
80105a27:	57                   	push   %edi
80105a28:	ff 75 d0             	pushl  -0x30(%ebp)
80105a2b:	e8 00 c5 ff ff       	call   80101f30 <nameiparent>
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	85 c0                	test   %eax,%eax
80105a35:	89 c6                	mov    %eax,%esi
80105a37:	74 5b                	je     80105a94 <sys_link+0xf4>
  ilock(dp);
80105a39:	83 ec 0c             	sub    $0xc,%esp
80105a3c:	50                   	push   %eax
80105a3d:	e8 6e bc ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	8b 03                	mov    (%ebx),%eax
80105a47:	39 06                	cmp    %eax,(%esi)
80105a49:	75 3d                	jne    80105a88 <sys_link+0xe8>
80105a4b:	83 ec 04             	sub    $0x4,%esp
80105a4e:	ff 73 04             	pushl  0x4(%ebx)
80105a51:	57                   	push   %edi
80105a52:	56                   	push   %esi
80105a53:	e8 f8 c3 ff ff       	call   80101e50 <dirlink>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	78 29                	js     80105a88 <sys_link+0xe8>
  iunlockput(dp);
80105a5f:	83 ec 0c             	sub    $0xc,%esp
80105a62:	56                   	push   %esi
80105a63:	e8 d8 be ff ff       	call   80101940 <iunlockput>
  iput(ip);
80105a68:	89 1c 24             	mov    %ebx,(%esp)
80105a6b:	e8 70 bd ff ff       	call   801017e0 <iput>
  end_op();
80105a70:	e8 cb d1 ff ff       	call   80102c40 <end_op>
  return 0;
80105a75:	83 c4 10             	add    $0x10,%esp
80105a78:	31 c0                	xor    %eax,%eax
}
80105a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a7d:	5b                   	pop    %ebx
80105a7e:	5e                   	pop    %esi
80105a7f:	5f                   	pop    %edi
80105a80:	5d                   	pop    %ebp
80105a81:	c3                   	ret    
80105a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	56                   	push   %esi
80105a8c:	e8 af be ff ff       	call   80101940 <iunlockput>
    goto bad;
80105a91:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a94:	83 ec 0c             	sub    $0xc,%esp
80105a97:	53                   	push   %ebx
80105a98:	e8 13 bc ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80105a9d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105aa2:	89 1c 24             	mov    %ebx,(%esp)
80105aa5:	e8 56 bb ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80105aaa:	89 1c 24             	mov    %ebx,(%esp)
80105aad:	e8 8e be ff ff       	call   80101940 <iunlockput>
  end_op();
80105ab2:	e8 89 d1 ff ff       	call   80102c40 <end_op>
  return -1;
80105ab7:	83 c4 10             	add    $0x10,%esp
}
80105aba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105abd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac2:	5b                   	pop    %ebx
80105ac3:	5e                   	pop    %esi
80105ac4:	5f                   	pop    %edi
80105ac5:	5d                   	pop    %ebp
80105ac6:	c3                   	ret    
    iunlockput(ip);
80105ac7:	83 ec 0c             	sub    $0xc,%esp
80105aca:	53                   	push   %ebx
80105acb:	e8 70 be ff ff       	call   80101940 <iunlockput>
    end_op();
80105ad0:	e8 6b d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105ad5:	83 c4 10             	add    $0x10,%esp
80105ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105add:	eb 9b                	jmp    80105a7a <sys_link+0xda>
    end_op();
80105adf:	e8 5c d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae9:	eb 8f                	jmp    80105a7a <sys_link+0xda>
80105aeb:	90                   	nop
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105af0 <sys_unlink>:
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105af6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105af9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105afc:	50                   	push   %eax
80105afd:	6a 00                	push   $0x0
80105aff:	e8 0c fa ff ff       	call   80105510 <argstr>
80105b04:	83 c4 10             	add    $0x10,%esp
80105b07:	85 c0                	test   %eax,%eax
80105b09:	0f 88 77 01 00 00    	js     80105c86 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105b0f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105b12:	e8 b9 d0 ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b17:	83 ec 08             	sub    $0x8,%esp
80105b1a:	53                   	push   %ebx
80105b1b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b1e:	e8 0d c4 ff ff       	call   80101f30 <nameiparent>
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	85 c0                	test   %eax,%eax
80105b28:	89 c6                	mov    %eax,%esi
80105b2a:	0f 84 60 01 00 00    	je     80105c90 <sys_unlink+0x1a0>
  ilock(dp);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	50                   	push   %eax
80105b34:	e8 77 bb ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b39:	58                   	pop    %eax
80105b3a:	5a                   	pop    %edx
80105b3b:	68 a4 84 10 80       	push   $0x801084a4
80105b40:	53                   	push   %ebx
80105b41:	e8 7a c0 ff ff       	call   80101bc0 <namecmp>
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	0f 84 03 01 00 00    	je     80105c54 <sys_unlink+0x164>
80105b51:	83 ec 08             	sub    $0x8,%esp
80105b54:	68 a3 84 10 80       	push   $0x801084a3
80105b59:	53                   	push   %ebx
80105b5a:	e8 61 c0 ff ff       	call   80101bc0 <namecmp>
80105b5f:	83 c4 10             	add    $0x10,%esp
80105b62:	85 c0                	test   %eax,%eax
80105b64:	0f 84 ea 00 00 00    	je     80105c54 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105b6a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105b6d:	83 ec 04             	sub    $0x4,%esp
80105b70:	50                   	push   %eax
80105b71:	53                   	push   %ebx
80105b72:	56                   	push   %esi
80105b73:	e8 68 c0 ff ff       	call   80101be0 <dirlookup>
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	89 c3                	mov    %eax,%ebx
80105b7f:	0f 84 cf 00 00 00    	je     80105c54 <sys_unlink+0x164>
  ilock(ip);
80105b85:	83 ec 0c             	sub    $0xc,%esp
80105b88:	50                   	push   %eax
80105b89:	e8 22 bb ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
80105b8e:	83 c4 10             	add    $0x10,%esp
80105b91:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b96:	0f 8e 10 01 00 00    	jle    80105cac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ba1:	74 6d                	je     80105c10 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105ba3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ba6:	83 ec 04             	sub    $0x4,%esp
80105ba9:	6a 10                	push   $0x10
80105bab:	6a 00                	push   $0x0
80105bad:	50                   	push   %eax
80105bae:	e8 ad f5 ff ff       	call   80105160 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bb3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105bb6:	6a 10                	push   $0x10
80105bb8:	ff 75 c4             	pushl  -0x3c(%ebp)
80105bbb:	50                   	push   %eax
80105bbc:	56                   	push   %esi
80105bbd:	e8 ce be ff ff       	call   80101a90 <writei>
80105bc2:	83 c4 20             	add    $0x20,%esp
80105bc5:	83 f8 10             	cmp    $0x10,%eax
80105bc8:	0f 85 eb 00 00 00    	jne    80105cb9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105bce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bd3:	0f 84 97 00 00 00    	je     80105c70 <sys_unlink+0x180>
  iunlockput(dp);
80105bd9:	83 ec 0c             	sub    $0xc,%esp
80105bdc:	56                   	push   %esi
80105bdd:	e8 5e bd ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80105be2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105be7:	89 1c 24             	mov    %ebx,(%esp)
80105bea:	e8 11 ba ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80105bef:	89 1c 24             	mov    %ebx,(%esp)
80105bf2:	e8 49 bd ff ff       	call   80101940 <iunlockput>
  end_op();
80105bf7:	e8 44 d0 ff ff       	call   80102c40 <end_op>
  return 0;
80105bfc:	83 c4 10             	add    $0x10,%esp
80105bff:	31 c0                	xor    %eax,%eax
}
80105c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c04:	5b                   	pop    %ebx
80105c05:	5e                   	pop    %esi
80105c06:	5f                   	pop    %edi
80105c07:	5d                   	pop    %ebp
80105c08:	c3                   	ret    
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c10:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105c14:	76 8d                	jbe    80105ba3 <sys_unlink+0xb3>
80105c16:	bf 20 00 00 00       	mov    $0x20,%edi
80105c1b:	eb 0f                	jmp    80105c2c <sys_unlink+0x13c>
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
80105c20:	83 c7 10             	add    $0x10,%edi
80105c23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105c26:	0f 83 77 ff ff ff    	jae    80105ba3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c2c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c2f:	6a 10                	push   $0x10
80105c31:	57                   	push   %edi
80105c32:	50                   	push   %eax
80105c33:	53                   	push   %ebx
80105c34:	e8 57 bd ff ff       	call   80101990 <readi>
80105c39:	83 c4 10             	add    $0x10,%esp
80105c3c:	83 f8 10             	cmp    $0x10,%eax
80105c3f:	75 5e                	jne    80105c9f <sys_unlink+0x1af>
    if(de.inum != 0)
80105c41:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105c46:	74 d8                	je     80105c20 <sys_unlink+0x130>
    iunlockput(ip);
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	53                   	push   %ebx
80105c4c:	e8 ef bc ff ff       	call   80101940 <iunlockput>
    goto bad;
80105c51:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105c54:	83 ec 0c             	sub    $0xc,%esp
80105c57:	56                   	push   %esi
80105c58:	e8 e3 bc ff ff       	call   80101940 <iunlockput>
  end_op();
80105c5d:	e8 de cf ff ff       	call   80102c40 <end_op>
  return -1;
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c6a:	eb 95                	jmp    80105c01 <sys_unlink+0x111>
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105c70:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105c75:	83 ec 0c             	sub    $0xc,%esp
80105c78:	56                   	push   %esi
80105c79:	e8 82 b9 ff ff       	call   80101600 <iupdate>
80105c7e:	83 c4 10             	add    $0x10,%esp
80105c81:	e9 53 ff ff ff       	jmp    80105bd9 <sys_unlink+0xe9>
    return -1;
80105c86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8b:	e9 71 ff ff ff       	jmp    80105c01 <sys_unlink+0x111>
    end_op();
80105c90:	e8 ab cf ff ff       	call   80102c40 <end_op>
    return -1;
80105c95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9a:	e9 62 ff ff ff       	jmp    80105c01 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105c9f:	83 ec 0c             	sub    $0xc,%esp
80105ca2:	68 c8 84 10 80       	push   $0x801084c8
80105ca7:	e8 e4 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105cac:	83 ec 0c             	sub    $0xc,%esp
80105caf:	68 b6 84 10 80       	push   $0x801084b6
80105cb4:	e8 d7 a6 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105cb9:	83 ec 0c             	sub    $0xc,%esp
80105cbc:	68 da 84 10 80       	push   $0x801084da
80105cc1:	e8 ca a6 ff ff       	call   80100390 <panic>
80105cc6:	8d 76 00             	lea    0x0(%esi),%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <sys_open>:

int
sys_open(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	57                   	push   %edi
80105cd4:	56                   	push   %esi
80105cd5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105cd6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105cd9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105cdc:	50                   	push   %eax
80105cdd:	6a 00                	push   $0x0
80105cdf:	e8 2c f8 ff ff       	call   80105510 <argstr>
80105ce4:	83 c4 10             	add    $0x10,%esp
80105ce7:	85 c0                	test   %eax,%eax
80105ce9:	0f 88 1d 01 00 00    	js     80105e0c <sys_open+0x13c>
80105cef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cf2:	83 ec 08             	sub    $0x8,%esp
80105cf5:	50                   	push   %eax
80105cf6:	6a 01                	push   $0x1
80105cf8:	e8 63 f7 ff ff       	call   80105460 <argint>
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	85 c0                	test   %eax,%eax
80105d02:	0f 88 04 01 00 00    	js     80105e0c <sys_open+0x13c>
    return -1;

  begin_op();
80105d08:	e8 c3 ce ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
80105d0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105d11:	0f 85 a9 00 00 00    	jne    80105dc0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105d17:	83 ec 0c             	sub    $0xc,%esp
80105d1a:	ff 75 e0             	pushl  -0x20(%ebp)
80105d1d:	e8 ee c1 ff ff       	call   80101f10 <namei>
80105d22:	83 c4 10             	add    $0x10,%esp
80105d25:	85 c0                	test   %eax,%eax
80105d27:	89 c6                	mov    %eax,%esi
80105d29:	0f 84 b2 00 00 00    	je     80105de1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105d2f:	83 ec 0c             	sub    $0xc,%esp
80105d32:	50                   	push   %eax
80105d33:	e8 78 b9 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d38:	83 c4 10             	add    $0x10,%esp
80105d3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105d40:	0f 84 aa 00 00 00    	je     80105df0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105d46:	e8 55 b0 ff ff       	call   80100da0 <filealloc>
80105d4b:	85 c0                	test   %eax,%eax
80105d4d:	89 c7                	mov    %eax,%edi
80105d4f:	0f 84 a6 00 00 00    	je     80105dfb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105d55:	e8 b6 db ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d5a:	31 db                	xor    %ebx,%ebx
80105d5c:	eb 0e                	jmp    80105d6c <sys_open+0x9c>
80105d5e:	66 90                	xchg   %ax,%ax
80105d60:	83 c3 01             	add    $0x1,%ebx
80105d63:	83 fb 10             	cmp    $0x10,%ebx
80105d66:	0f 84 ac 00 00 00    	je     80105e18 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105d6c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
80105d70:	85 d2                	test   %edx,%edx
80105d72:	75 ec                	jne    80105d60 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d74:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105d77:	89 7c 98 20          	mov    %edi,0x20(%eax,%ebx,4)
  iunlock(ip);
80105d7b:	56                   	push   %esi
80105d7c:	e8 0f ba ff ff       	call   80101790 <iunlock>
  end_op();
80105d81:	e8 ba ce ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80105d86:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105d8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d8f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105d92:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105d95:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105d9c:	89 d0                	mov    %edx,%eax
80105d9e:	f7 d0                	not    %eax
80105da0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105da3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105da6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105da9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db0:	89 d8                	mov    %ebx,%eax
80105db2:	5b                   	pop    %ebx
80105db3:	5e                   	pop    %esi
80105db4:	5f                   	pop    %edi
80105db5:	5d                   	pop    %ebp
80105db6:	c3                   	ret    
80105db7:	89 f6                	mov    %esi,%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dc6:	31 c9                	xor    %ecx,%ecx
80105dc8:	6a 00                	push   $0x0
80105dca:	ba 02 00 00 00       	mov    $0x2,%edx
80105dcf:	e8 ec f7 ff ff       	call   801055c0 <create>
    if(ip == 0){
80105dd4:	83 c4 10             	add    $0x10,%esp
80105dd7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105dd9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ddb:	0f 85 65 ff ff ff    	jne    80105d46 <sys_open+0x76>
      end_op();
80105de1:	e8 5a ce ff ff       	call   80102c40 <end_op>
      return -1;
80105de6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105deb:	eb c0                	jmp    80105dad <sys_open+0xdd>
80105ded:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105df0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105df3:	85 c9                	test   %ecx,%ecx
80105df5:	0f 84 4b ff ff ff    	je     80105d46 <sys_open+0x76>
    iunlockput(ip);
80105dfb:	83 ec 0c             	sub    $0xc,%esp
80105dfe:	56                   	push   %esi
80105dff:	e8 3c bb ff ff       	call   80101940 <iunlockput>
    end_op();
80105e04:	e8 37 ce ff ff       	call   80102c40 <end_op>
    return -1;
80105e09:	83 c4 10             	add    $0x10,%esp
80105e0c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e11:	eb 9a                	jmp    80105dad <sys_open+0xdd>
80105e13:	90                   	nop
80105e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105e18:	83 ec 0c             	sub    $0xc,%esp
80105e1b:	57                   	push   %edi
80105e1c:	e8 3f b0 ff ff       	call   80100e60 <fileclose>
80105e21:	83 c4 10             	add    $0x10,%esp
80105e24:	eb d5                	jmp    80105dfb <sys_open+0x12b>
80105e26:	8d 76 00             	lea    0x0(%esi),%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e30 <sys_mkdir>:

int
sys_mkdir(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e36:	e8 95 cd ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105e3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e3e:	83 ec 08             	sub    $0x8,%esp
80105e41:	50                   	push   %eax
80105e42:	6a 00                	push   $0x0
80105e44:	e8 c7 f6 ff ff       	call   80105510 <argstr>
80105e49:	83 c4 10             	add    $0x10,%esp
80105e4c:	85 c0                	test   %eax,%eax
80105e4e:	78 30                	js     80105e80 <sys_mkdir+0x50>
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e56:	31 c9                	xor    %ecx,%ecx
80105e58:	6a 00                	push   $0x0
80105e5a:	ba 01 00 00 00       	mov    $0x1,%edx
80105e5f:	e8 5c f7 ff ff       	call   801055c0 <create>
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	85 c0                	test   %eax,%eax
80105e69:	74 15                	je     80105e80 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e6b:	83 ec 0c             	sub    $0xc,%esp
80105e6e:	50                   	push   %eax
80105e6f:	e8 cc ba ff ff       	call   80101940 <iunlockput>
  end_op();
80105e74:	e8 c7 cd ff ff       	call   80102c40 <end_op>
  return 0;
80105e79:	83 c4 10             	add    $0x10,%esp
80105e7c:	31 c0                	xor    %eax,%eax
}
80105e7e:	c9                   	leave  
80105e7f:	c3                   	ret    
    end_op();
80105e80:	e8 bb cd ff ff       	call   80102c40 <end_op>
    return -1;
80105e85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e8a:	c9                   	leave  
80105e8b:	c3                   	ret    
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_mknod>:

int
sys_mknod(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105e96:	e8 35 cd ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105e9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e9e:	83 ec 08             	sub    $0x8,%esp
80105ea1:	50                   	push   %eax
80105ea2:	6a 00                	push   $0x0
80105ea4:	e8 67 f6 ff ff       	call   80105510 <argstr>
80105ea9:	83 c4 10             	add    $0x10,%esp
80105eac:	85 c0                	test   %eax,%eax
80105eae:	78 60                	js     80105f10 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105eb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eb3:	83 ec 08             	sub    $0x8,%esp
80105eb6:	50                   	push   %eax
80105eb7:	6a 01                	push   $0x1
80105eb9:	e8 a2 f5 ff ff       	call   80105460 <argint>
  if((argstr(0, &path)) < 0 ||
80105ebe:	83 c4 10             	add    $0x10,%esp
80105ec1:	85 c0                	test   %eax,%eax
80105ec3:	78 4b                	js     80105f10 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105ec5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ec8:	83 ec 08             	sub    $0x8,%esp
80105ecb:	50                   	push   %eax
80105ecc:	6a 02                	push   $0x2
80105ece:	e8 8d f5 ff ff       	call   80105460 <argint>
     argint(1, &major) < 0 ||
80105ed3:	83 c4 10             	add    $0x10,%esp
80105ed6:	85 c0                	test   %eax,%eax
80105ed8:	78 36                	js     80105f10 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105eda:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105ede:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105ee1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105ee5:	ba 03 00 00 00       	mov    $0x3,%edx
80105eea:	50                   	push   %eax
80105eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105eee:	e8 cd f6 ff ff       	call   801055c0 <create>
80105ef3:	83 c4 10             	add    $0x10,%esp
80105ef6:	85 c0                	test   %eax,%eax
80105ef8:	74 16                	je     80105f10 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105efa:	83 ec 0c             	sub    $0xc,%esp
80105efd:	50                   	push   %eax
80105efe:	e8 3d ba ff ff       	call   80101940 <iunlockput>
  end_op();
80105f03:	e8 38 cd ff ff       	call   80102c40 <end_op>
  return 0;
80105f08:	83 c4 10             	add    $0x10,%esp
80105f0b:	31 c0                	xor    %eax,%eax
}
80105f0d:	c9                   	leave  
80105f0e:	c3                   	ret    
80105f0f:	90                   	nop
    end_op();
80105f10:	e8 2b cd ff ff       	call   80102c40 <end_op>
    return -1;
80105f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f1a:	c9                   	leave  
80105f1b:	c3                   	ret    
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_chdir>:

int
sys_chdir(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	56                   	push   %esi
80105f24:	53                   	push   %ebx
80105f25:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105f28:	e8 e3 d9 ff ff       	call   80103910 <myproc>
80105f2d:	89 c6                	mov    %eax,%esi
  //struct thread *curthread = mythread();
  
  begin_op();
80105f2f:	e8 9c cc ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105f34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f37:	83 ec 08             	sub    $0x8,%esp
80105f3a:	50                   	push   %eax
80105f3b:	6a 00                	push   $0x0
80105f3d:	e8 ce f5 ff ff       	call   80105510 <argstr>
80105f42:	83 c4 10             	add    $0x10,%esp
80105f45:	85 c0                	test   %eax,%eax
80105f47:	78 77                	js     80105fc0 <sys_chdir+0xa0>
80105f49:	83 ec 0c             	sub    $0xc,%esp
80105f4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105f4f:	e8 bc bf ff ff       	call   80101f10 <namei>
80105f54:	83 c4 10             	add    $0x10,%esp
80105f57:	85 c0                	test   %eax,%eax
80105f59:	89 c3                	mov    %eax,%ebx
80105f5b:	74 63                	je     80105fc0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105f5d:	83 ec 0c             	sub    $0xc,%esp
80105f60:	50                   	push   %eax
80105f61:	e8 4a b7 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105f66:	83 c4 10             	add    $0x10,%esp
80105f69:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f6e:	75 30                	jne    80105fa0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f70:	83 ec 0c             	sub    $0xc,%esp
80105f73:	53                   	push   %ebx
80105f74:	e8 17 b8 ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105f79:	58                   	pop    %eax
80105f7a:	ff 76 60             	pushl  0x60(%esi)
80105f7d:	e8 5e b8 ff ff       	call   801017e0 <iput>
  end_op();
80105f82:	e8 b9 cc ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
80105f87:	89 5e 60             	mov    %ebx,0x60(%esi)
  return 0;
80105f8a:	83 c4 10             	add    $0x10,%esp
80105f8d:	31 c0                	xor    %eax,%eax
}
80105f8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f92:	5b                   	pop    %ebx
80105f93:	5e                   	pop    %esi
80105f94:	5d                   	pop    %ebp
80105f95:	c3                   	ret    
80105f96:	8d 76 00             	lea    0x0(%esi),%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105fa0:	83 ec 0c             	sub    $0xc,%esp
80105fa3:	53                   	push   %ebx
80105fa4:	e8 97 b9 ff ff       	call   80101940 <iunlockput>
    end_op();
80105fa9:	e8 92 cc ff ff       	call   80102c40 <end_op>
    return -1;
80105fae:	83 c4 10             	add    $0x10,%esp
80105fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb6:	eb d7                	jmp    80105f8f <sys_chdir+0x6f>
80105fb8:	90                   	nop
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105fc0:	e8 7b cc ff ff       	call   80102c40 <end_op>
    return -1;
80105fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fca:	eb c3                	jmp    80105f8f <sys_chdir+0x6f>
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_exec>:

int
sys_exec(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	57                   	push   %edi
80105fd4:	56                   	push   %esi
80105fd5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105fd6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105fdc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105fe2:	50                   	push   %eax
80105fe3:	6a 00                	push   $0x0
80105fe5:	e8 26 f5 ff ff       	call   80105510 <argstr>
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	85 c0                	test   %eax,%eax
80105fef:	0f 88 87 00 00 00    	js     8010607c <sys_exec+0xac>
80105ff5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105ffb:	83 ec 08             	sub    $0x8,%esp
80105ffe:	50                   	push   %eax
80105fff:	6a 01                	push   $0x1
80106001:	e8 5a f4 ff ff       	call   80105460 <argint>
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	85 c0                	test   %eax,%eax
8010600b:	78 6f                	js     8010607c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010600d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106013:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106016:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106018:	68 80 00 00 00       	push   $0x80
8010601d:	6a 00                	push   $0x0
8010601f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106025:	50                   	push   %eax
80106026:	e8 35 f1 ff ff       	call   80105160 <memset>
8010602b:	83 c4 10             	add    $0x10,%esp
8010602e:	eb 2c                	jmp    8010605c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106030:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106036:	85 c0                	test   %eax,%eax
80106038:	74 56                	je     80106090 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010603a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106040:	83 ec 08             	sub    $0x8,%esp
80106043:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106046:	52                   	push   %edx
80106047:	50                   	push   %eax
80106048:	e8 a3 f3 ff ff       	call   801053f0 <fetchstr>
8010604d:	83 c4 10             	add    $0x10,%esp
80106050:	85 c0                	test   %eax,%eax
80106052:	78 28                	js     8010607c <sys_exec+0xac>
  for(i=0;; i++){
80106054:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106057:	83 fb 20             	cmp    $0x20,%ebx
8010605a:	74 20                	je     8010607c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010605c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106062:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106069:	83 ec 08             	sub    $0x8,%esp
8010606c:	57                   	push   %edi
8010606d:	01 f0                	add    %esi,%eax
8010606f:	50                   	push   %eax
80106070:	e8 3b f3 ff ff       	call   801053b0 <fetchint>
80106075:	83 c4 10             	add    $0x10,%esp
80106078:	85 c0                	test   %eax,%eax
8010607a:	79 b4                	jns    80106030 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010607c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010607f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106084:	5b                   	pop    %ebx
80106085:	5e                   	pop    %esi
80106086:	5f                   	pop    %edi
80106087:	5d                   	pop    %ebp
80106088:	c3                   	ret    
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106090:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106096:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106099:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801060a0:	00 00 00 00 
  return exec(path, argv);
801060a4:	50                   	push   %eax
801060a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801060ab:	e8 60 a9 ff ff       	call   80100a10 <exec>
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
{
801060c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801060cc:	6a 08                	push   $0x8
801060ce:	50                   	push   %eax
801060cf:	6a 00                	push   $0x0
801060d1:	e8 da f3 ff ff       	call   801054b0 <argptr>
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	85 c0                	test   %eax,%eax
801060db:	0f 88 ae 00 00 00    	js     8010618f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801060e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060e4:	83 ec 08             	sub    $0x8,%esp
801060e7:	50                   	push   %eax
801060e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060eb:	50                   	push   %eax
801060ec:	e8 7f d1 ff ff       	call   80103270 <pipealloc>
801060f1:	83 c4 10             	add    $0x10,%esp
801060f4:	85 c0                	test   %eax,%eax
801060f6:	0f 88 93 00 00 00    	js     8010618f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801060ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106101:	e8 0a d8 ff ff       	call   80103910 <myproc>
80106106:	eb 10                	jmp    80106118 <sys_pipe+0x58>
80106108:	90                   	nop
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106110:	83 c3 01             	add    $0x1,%ebx
80106113:	83 fb 10             	cmp    $0x10,%ebx
80106116:	74 60                	je     80106178 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106118:	8b 74 98 20          	mov    0x20(%eax,%ebx,4),%esi
8010611c:	85 f6                	test   %esi,%esi
8010611e:	75 f0                	jne    80106110 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106120:	8d 73 08             	lea    0x8(%ebx),%esi
80106123:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106126:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106129:	e8 e2 d7 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010612e:	31 d2                	xor    %edx,%edx
80106130:	eb 0e                	jmp    80106140 <sys_pipe+0x80>
80106132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106138:	83 c2 01             	add    $0x1,%edx
8010613b:	83 fa 10             	cmp    $0x10,%edx
8010613e:	74 28                	je     80106168 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106140:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
80106144:	85 c9                	test   %ecx,%ecx
80106146:	75 f0                	jne    80106138 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106148:	89 7c 90 20          	mov    %edi,0x20(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010614c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010614f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106151:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106154:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106157:	31 c0                	xor    %eax,%eax
}
80106159:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010615c:	5b                   	pop    %ebx
8010615d:	5e                   	pop    %esi
8010615e:	5f                   	pop    %edi
8010615f:	5d                   	pop    %ebp
80106160:	c3                   	ret    
80106161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106168:	e8 a3 d7 ff ff       	call   80103910 <myproc>
8010616d:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
80106174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(rf);
80106178:	83 ec 0c             	sub    $0xc,%esp
8010617b:	ff 75 e0             	pushl  -0x20(%ebp)
8010617e:	e8 dd ac ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
80106183:	58                   	pop    %eax
80106184:	ff 75 e4             	pushl  -0x1c(%ebp)
80106187:	e8 d4 ac ff ff       	call   80100e60 <fileclose>
    return -1;
8010618c:	83 c4 10             	add    $0x10,%esp
8010618f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106194:	eb c3                	jmp    80106159 <sys_pipe+0x99>
80106196:	66 90                	xchg   %ax,%ax
80106198:	66 90                	xchg   %ax,%ax
8010619a:	66 90                	xchg   %ax,%ax
8010619c:	66 90                	xchg   %ax,%ax
8010619e:	66 90                	xchg   %ax,%ax

801061a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801061a3:	5d                   	pop    %ebp
  return fork();
801061a4:	e9 c7 d9 ff ff       	jmp    80103b70 <fork>
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061b0 <sys_exit>:

int
sys_exit(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801061b6:	e8 15 df ff ff       	call   801040d0 <exit>
  return 0;  // not reached
}
801061bb:	31 c0                	xor    %eax,%eax
801061bd:	c9                   	leave  
801061be:	c3                   	ret    
801061bf:	90                   	nop

801061c0 <sys_wait>:

int
sys_wait(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801061c3:	5d                   	pop    %ebp
  return wait();
801061c4:	e9 07 e1 ff ff       	jmp    801042d0 <wait>
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061d0 <sys_kill>:

int
sys_kill(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801061d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061d9:	50                   	push   %eax
801061da:	6a 00                	push   $0x0
801061dc:	e8 7f f2 ff ff       	call   80105460 <argint>
801061e1:	83 c4 10             	add    $0x10,%esp
801061e4:	85 c0                	test   %eax,%eax
801061e6:	78 18                	js     80106200 <sys_kill+0x30>
    return -1;
  return kill(pid);
801061e8:	83 ec 0c             	sub    $0xc,%esp
801061eb:	ff 75 f4             	pushl  -0xc(%ebp)
801061ee:	e8 dd e2 ff ff       	call   801044d0 <kill>
801061f3:	83 c4 10             	add    $0x10,%esp
}
801061f6:	c9                   	leave  
801061f7:	c3                   	ret    
801061f8:	90                   	nop
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106205:	c9                   	leave  
80106206:	c3                   	ret    
80106207:	89 f6                	mov    %esi,%esi
80106209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106210 <sys_getpid>:

int
sys_getpid(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106216:	e8 f5 d6 ff ff       	call   80103910 <myproc>
8010621b:	8b 40 0c             	mov    0xc(%eax),%eax
}
8010621e:	c9                   	leave  
8010621f:	c3                   	ret    

80106220 <sys_sbrk>:

int
sys_sbrk(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106224:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106227:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010622a:	50                   	push   %eax
8010622b:	6a 00                	push   $0x0
8010622d:	e8 2e f2 ff ff       	call   80105460 <argint>
80106232:	83 c4 10             	add    $0x10,%esp
80106235:	85 c0                	test   %eax,%eax
80106237:	78 27                	js     80106260 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106239:	e8 d2 d6 ff ff       	call   80103910 <myproc>
  if(growproc(n) < 0)
8010623e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106241:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106243:	ff 75 f4             	pushl  -0xc(%ebp)
80106246:	e8 85 d8 ff ff       	call   80103ad0 <growproc>
8010624b:	83 c4 10             	add    $0x10,%esp
8010624e:	85 c0                	test   %eax,%eax
80106250:	78 0e                	js     80106260 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106252:	89 d8                	mov    %ebx,%eax
80106254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106257:	c9                   	leave  
80106258:	c3                   	ret    
80106259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106260:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106265:	eb eb                	jmp    80106252 <sys_sbrk+0x32>
80106267:	89 f6                	mov    %esi,%esi
80106269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106270 <sys_sleep>:

int
sys_sleep(void)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106274:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106277:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010627a:	50                   	push   %eax
8010627b:	6a 00                	push   $0x0
8010627d:	e8 de f1 ff ff       	call   80105460 <argint>
80106282:	83 c4 10             	add    $0x10,%esp
80106285:	85 c0                	test   %eax,%eax
80106287:	0f 88 8a 00 00 00    	js     80106317 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010628d:	83 ec 0c             	sub    $0xc,%esp
80106290:	68 e0 3a 12 80       	push   $0x80123ae0
80106295:	e8 a6 ed ff ff       	call   80105040 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010629a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010629d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801062a0:	8b 1d 20 43 12 80    	mov    0x80124320,%ebx
  while(ticks - ticks0 < n){
801062a6:	85 d2                	test   %edx,%edx
801062a8:	75 27                	jne    801062d1 <sys_sleep+0x61>
801062aa:	eb 54                	jmp    80106300 <sys_sleep+0x90>
801062ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801062b0:	83 ec 08             	sub    $0x8,%esp
801062b3:	68 e0 3a 12 80       	push   $0x80123ae0
801062b8:	68 20 43 12 80       	push   $0x80124320
801062bd:	e8 8e dc ff ff       	call   80103f50 <sleep>
  while(ticks - ticks0 < n){
801062c2:	a1 20 43 12 80       	mov    0x80124320,%eax
801062c7:	83 c4 10             	add    $0x10,%esp
801062ca:	29 d8                	sub    %ebx,%eax
801062cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801062cf:	73 2f                	jae    80106300 <sys_sleep+0x90>
    if(myproc()->killed){
801062d1:	e8 3a d6 ff ff       	call   80103910 <myproc>
801062d6:	8b 40 1c             	mov    0x1c(%eax),%eax
801062d9:	85 c0                	test   %eax,%eax
801062db:	74 d3                	je     801062b0 <sys_sleep+0x40>
      release(&tickslock);
801062dd:	83 ec 0c             	sub    $0xc,%esp
801062e0:	68 e0 3a 12 80       	push   $0x80123ae0
801062e5:	e8 16 ee ff ff       	call   80105100 <release>
      return -1;
801062ea:	83 c4 10             	add    $0x10,%esp
801062ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801062f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062f5:	c9                   	leave  
801062f6:	c3                   	ret    
801062f7:	89 f6                	mov    %esi,%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106300:	83 ec 0c             	sub    $0xc,%esp
80106303:	68 e0 3a 12 80       	push   $0x80123ae0
80106308:	e8 f3 ed ff ff       	call   80105100 <release>
  return 0;
8010630d:	83 c4 10             	add    $0x10,%esp
80106310:	31 c0                	xor    %eax,%eax
}
80106312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106315:	c9                   	leave  
80106316:	c3                   	ret    
    return -1;
80106317:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010631c:	eb f4                	jmp    80106312 <sys_sleep+0xa2>
8010631e:	66 90                	xchg   %ax,%ax

80106320 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	53                   	push   %ebx
80106324:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106327:	68 e0 3a 12 80       	push   $0x80123ae0
8010632c:	e8 0f ed ff ff       	call   80105040 <acquire>
  xticks = ticks;
80106331:	8b 1d 20 43 12 80    	mov    0x80124320,%ebx
  release(&tickslock);
80106337:	c7 04 24 e0 3a 12 80 	movl   $0x80123ae0,(%esp)
8010633e:	e8 bd ed ff ff       	call   80105100 <release>
  return xticks;
}
80106343:	89 d8                	mov    %ebx,%eax
80106345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106348:	c9                   	leave  
80106349:	c3                   	ret    
8010634a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106350 <sys_kthread_create>:

int
sys_kthread_create(void){
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	83 ec 0c             	sub    $0xc,%esp
    void (*start_func)()=0;
    void* stack=0;
    if(argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
80106356:	6a 01                	push   $0x1
80106358:	6a 00                	push   $0x0
8010635a:	6a 00                	push   $0x0
8010635c:	e8 4f f1 ff ff       	call   801054b0 <argptr>
80106361:	83 c4 10             	add    $0x10,%esp
80106364:	85 c0                	test   %eax,%eax
80106366:	78 28                	js     80106390 <sys_kthread_create+0x40>
        return -1;
    if(argptr(0, stack, sizeof(*stack)) < 0)
80106368:	83 ec 04             	sub    $0x4,%esp
8010636b:	6a 01                	push   $0x1
8010636d:	6a 00                	push   $0x0
8010636f:	6a 00                	push   $0x0
80106371:	e8 3a f1 ff ff       	call   801054b0 <argptr>
80106376:	83 c4 10             	add    $0x10,%esp
80106379:	85 c0                	test   %eax,%eax
8010637b:	78 13                	js     80106390 <sys_kthread_create+0x40>
        return -1;
    return kthread_create(start_func, stack);
8010637d:	83 ec 08             	sub    $0x8,%esp
80106380:	6a 00                	push   $0x0
80106382:	6a 00                	push   $0x0
80106384:	e8 f7 e2 ff ff       	call   80104680 <kthread_create>
80106389:	83 c4 10             	add    $0x10,%esp
}
8010638c:	c9                   	leave  
8010638d:	c3                   	ret    
8010638e:	66 90                	xchg   %ax,%ax
        return -1;
80106390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106395:	c9                   	leave  
80106396:	c3                   	ret    
80106397:	89 f6                	mov    %esi,%esi
80106399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063a0 <sys_kthread_id>:

int
sys_kthread_id(void){
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	83 ec 08             	sub    $0x8,%esp
    return mythread()->tid;
801063a6:	e8 95 d5 ff ff       	call   80103940 <mythread>
801063ab:	8b 40 0c             	mov    0xc(%eax),%eax
}
801063ae:	c9                   	leave  
801063af:	c3                   	ret    

801063b0 <sys_kthread_exit>:

int
sys_kthread_exit(void){
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 08             	sub    $0x8,%esp
    kthread_exit();
801063b6:	e8 85 e4 ff ff       	call   80104840 <kthread_exit>
    return 0;
}
801063bb:	31 c0                	xor    %eax,%eax
801063bd:	c9                   	leave  
801063be:	c3                   	ret    
801063bf:	90                   	nop

801063c0 <sys_kthread_join>:

int
sys_kthread_join(void){
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 20             	sub    $0x20,%esp
    int tid;
    if(argint(0, &tid) < 0)
801063c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063c9:	50                   	push   %eax
801063ca:	6a 00                	push   $0x0
801063cc:	e8 8f f0 ff ff       	call   80105460 <argint>
801063d1:	83 c4 10             	add    $0x10,%esp
801063d4:	85 c0                	test   %eax,%eax
801063d6:	78 18                	js     801063f0 <sys_kthread_join+0x30>
        return -1;
    return kthread_join(tid);
801063d8:	83 ec 0c             	sub    $0xc,%esp
801063db:	ff 75 f4             	pushl  -0xc(%ebp)
801063de:	e8 fd e4 ff ff       	call   801048e0 <kthread_join>
801063e3:	83 c4 10             	add    $0x10,%esp
}
801063e6:	c9                   	leave  
801063e7:	c3                   	ret    
801063e8:	90                   	nop
801063e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801063f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063f5:	c9                   	leave  
801063f6:	c3                   	ret    

801063f7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801063f7:	1e                   	push   %ds
  pushl %es
801063f8:	06                   	push   %es
  pushl %fs
801063f9:	0f a0                	push   %fs
  pushl %gs
801063fb:	0f a8                	push   %gs
  pushal
801063fd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801063fe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106402:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106404:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106406:	54                   	push   %esp
  call trap
80106407:	e8 c4 00 00 00       	call   801064d0 <trap>
  addl $4, %esp
8010640c:	83 c4 04             	add    $0x4,%esp

8010640f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010640f:	61                   	popa   
  popl %gs
80106410:	0f a9                	pop    %gs
  popl %fs
80106412:	0f a1                	pop    %fs
  popl %es
80106414:	07                   	pop    %es
  popl %ds
80106415:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106416:	83 c4 08             	add    $0x8,%esp
  iret
80106419:	cf                   	iret   
8010641a:	66 90                	xchg   %ax,%ax
8010641c:	66 90                	xchg   %ax,%ax
8010641e:	66 90                	xchg   %ax,%ax

80106420 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106420:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106421:	31 c0                	xor    %eax,%eax
{
80106423:	89 e5                	mov    %esp,%ebp
80106425:	83 ec 08             	sub    $0x8,%esp
80106428:	90                   	nop
80106429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106430:	8b 14 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%edx
80106437:	c7 04 c5 22 3b 12 80 	movl   $0x8e000008,-0x7fedc4de(,%eax,8)
8010643e:	08 00 00 8e 
80106442:	66 89 14 c5 20 3b 12 	mov    %dx,-0x7fedc4e0(,%eax,8)
80106449:	80 
8010644a:	c1 ea 10             	shr    $0x10,%edx
8010644d:	66 89 14 c5 26 3b 12 	mov    %dx,-0x7fedc4da(,%eax,8)
80106454:	80 
  for(i = 0; i < 256; i++)
80106455:	83 c0 01             	add    $0x1,%eax
80106458:	3d 00 01 00 00       	cmp    $0x100,%eax
8010645d:	75 d1                	jne    80106430 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010645f:	a1 10 b1 10 80       	mov    0x8010b110,%eax

  initlock(&tickslock, "time");
80106464:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106467:	c7 05 22 3d 12 80 08 	movl   $0xef000008,0x80123d22
8010646e:	00 00 ef 
  initlock(&tickslock, "time");
80106471:	68 e9 84 10 80       	push   $0x801084e9
80106476:	68 e0 3a 12 80       	push   $0x80123ae0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010647b:	66 a3 20 3d 12 80    	mov    %ax,0x80123d20
80106481:	c1 e8 10             	shr    $0x10,%eax
80106484:	66 a3 26 3d 12 80    	mov    %ax,0x80123d26
  initlock(&tickslock, "time");
8010648a:	e8 71 ea ff ff       	call   80104f00 <initlock>
}
8010648f:	83 c4 10             	add    $0x10,%esp
80106492:	c9                   	leave  
80106493:	c3                   	ret    
80106494:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010649a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801064a0 <idtinit>:

void
idtinit(void)
{
801064a0:	55                   	push   %ebp
  pd[0] = size-1;
801064a1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801064a6:	89 e5                	mov    %esp,%ebp
801064a8:	83 ec 10             	sub    $0x10,%esp
801064ab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801064af:	b8 20 3b 12 80       	mov    $0x80123b20,%eax
801064b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801064b8:	c1 e8 10             	shr    $0x10,%eax
801064bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801064bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801064c2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801064c5:	c9                   	leave  
801064c6:	c3                   	ret    
801064c7:	89 f6                	mov    %esi,%esi
801064c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	57                   	push   %edi
801064d4:	56                   	push   %esi
801064d5:	53                   	push   %ebx
801064d6:	83 ec 1c             	sub    $0x1c,%esp
801064d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801064dc:	8b 47 30             	mov    0x30(%edi),%eax
801064df:	83 f8 40             	cmp    $0x40,%eax
801064e2:	0f 84 f0 00 00 00    	je     801065d8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801064e8:	83 e8 20             	sub    $0x20,%eax
801064eb:	83 f8 1f             	cmp    $0x1f,%eax
801064ee:	77 10                	ja     80106500 <trap+0x30>
801064f0:	ff 24 85 90 85 10 80 	jmp    *-0x7fef7a70(,%eax,4)
801064f7:	89 f6                	mov    %esi,%esi
801064f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106500:	e8 0b d4 ff ff       	call   80103910 <myproc>
80106505:	85 c0                	test   %eax,%eax
80106507:	8b 5f 38             	mov    0x38(%edi),%ebx
8010650a:	0f 84 14 02 00 00    	je     80106724 <trap+0x254>
80106510:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106514:	0f 84 0a 02 00 00    	je     80106724 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010651a:	0f 20 d1             	mov    %cr2,%ecx
8010651d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106520:	e8 cb d3 ff ff       	call   801038f0 <cpuid>
80106525:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106528:	8b 47 34             	mov    0x34(%edi),%eax
8010652b:	8b 77 30             	mov    0x30(%edi),%esi
8010652e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106531:	e8 da d3 ff ff       	call   80103910 <myproc>
80106536:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106539:	e8 d2 d3 ff ff       	call   80103910 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010653e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106541:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106544:	51                   	push   %ecx
80106545:	53                   	push   %ebx
80106546:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106547:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010654a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010654d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010654e:	83 c2 64             	add    $0x64,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106551:	52                   	push   %edx
80106552:	ff 70 0c             	pushl  0xc(%eax)
80106555:	68 4c 85 10 80       	push   $0x8010854c
8010655a:	e8 01 a1 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010655f:	83 c4 20             	add    $0x20,%esp
80106562:	e8 a9 d3 ff ff       	call   80103910 <myproc>
80106567:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010656e:	e8 9d d3 ff ff       	call   80103910 <myproc>
80106573:	85 c0                	test   %eax,%eax
80106575:	74 1d                	je     80106594 <trap+0xc4>
80106577:	e8 94 d3 ff ff       	call   80103910 <myproc>
8010657c:	8b 50 1c             	mov    0x1c(%eax),%edx
8010657f:	85 d2                	test   %edx,%edx
80106581:	74 11                	je     80106594 <trap+0xc4>
80106583:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106587:	83 e0 03             	and    $0x3,%eax
8010658a:	66 83 f8 03          	cmp    $0x3,%ax
8010658e:	0f 84 4c 01 00 00    	je     801066e0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106594:	e8 77 d3 ff ff       	call   80103910 <myproc>
80106599:	85 c0                	test   %eax,%eax
8010659b:	74 0b                	je     801065a8 <trap+0xd8>
8010659d:	e8 6e d3 ff ff       	call   80103910 <myproc>
801065a2:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
801065a6:	74 68                	je     80106610 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065a8:	e8 63 d3 ff ff       	call   80103910 <myproc>
801065ad:	85 c0                	test   %eax,%eax
801065af:	74 19                	je     801065ca <trap+0xfa>
801065b1:	e8 5a d3 ff ff       	call   80103910 <myproc>
801065b6:	8b 40 1c             	mov    0x1c(%eax),%eax
801065b9:	85 c0                	test   %eax,%eax
801065bb:	74 0d                	je     801065ca <trap+0xfa>
801065bd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801065c1:	83 e0 03             	and    $0x3,%eax
801065c4:	66 83 f8 03          	cmp    $0x3,%ax
801065c8:	74 37                	je     80106601 <trap+0x131>
    exit();
}
801065ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065cd:	5b                   	pop    %ebx
801065ce:	5e                   	pop    %esi
801065cf:	5f                   	pop    %edi
801065d0:	5d                   	pop    %ebp
801065d1:	c3                   	ret    
801065d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801065d8:	e8 33 d3 ff ff       	call   80103910 <myproc>
801065dd:	8b 58 1c             	mov    0x1c(%eax),%ebx
801065e0:	85 db                	test   %ebx,%ebx
801065e2:	0f 85 e8 00 00 00    	jne    801066d0 <trap+0x200>
    mythread()->tf = tf;
801065e8:	e8 53 d3 ff ff       	call   80103940 <mythread>
801065ed:	89 78 10             	mov    %edi,0x10(%eax)
    syscall();
801065f0:	e8 5b ef ff ff       	call   80105550 <syscall>
    if(myproc()->killed)
801065f5:	e8 16 d3 ff ff       	call   80103910 <myproc>
801065fa:	8b 48 1c             	mov    0x1c(%eax),%ecx
801065fd:	85 c9                	test   %ecx,%ecx
801065ff:	74 c9                	je     801065ca <trap+0xfa>
}
80106601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106604:	5b                   	pop    %ebx
80106605:	5e                   	pop    %esi
80106606:	5f                   	pop    %edi
80106607:	5d                   	pop    %ebp
      exit();
80106608:	e9 c3 da ff ff       	jmp    801040d0 <exit>
8010660d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106610:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106614:	75 92                	jne    801065a8 <trap+0xd8>
    yield();
80106616:	e8 e5 d8 ff ff       	call   80103f00 <yield>
8010661b:	eb 8b                	jmp    801065a8 <trap+0xd8>
8010661d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106620:	e8 cb d2 ff ff       	call   801038f0 <cpuid>
80106625:	85 c0                	test   %eax,%eax
80106627:	0f 84 c3 00 00 00    	je     801066f0 <trap+0x220>
    lapiceoi();
8010662d:	e8 4e c1 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106632:	e8 d9 d2 ff ff       	call   80103910 <myproc>
80106637:	85 c0                	test   %eax,%eax
80106639:	0f 85 38 ff ff ff    	jne    80106577 <trap+0xa7>
8010663f:	e9 50 ff ff ff       	jmp    80106594 <trap+0xc4>
80106644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106648:	e8 f3 bf ff ff       	call   80102640 <kbdintr>
    lapiceoi();
8010664d:	e8 2e c1 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106652:	e8 b9 d2 ff ff       	call   80103910 <myproc>
80106657:	85 c0                	test   %eax,%eax
80106659:	0f 85 18 ff ff ff    	jne    80106577 <trap+0xa7>
8010665f:	e9 30 ff ff ff       	jmp    80106594 <trap+0xc4>
80106664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106668:	e8 53 02 00 00       	call   801068c0 <uartintr>
    lapiceoi();
8010666d:	e8 0e c1 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106672:	e8 99 d2 ff ff       	call   80103910 <myproc>
80106677:	85 c0                	test   %eax,%eax
80106679:	0f 85 f8 fe ff ff    	jne    80106577 <trap+0xa7>
8010667f:	e9 10 ff ff ff       	jmp    80106594 <trap+0xc4>
80106684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106688:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010668c:	8b 77 38             	mov    0x38(%edi),%esi
8010668f:	e8 5c d2 ff ff       	call   801038f0 <cpuid>
80106694:	56                   	push   %esi
80106695:	53                   	push   %ebx
80106696:	50                   	push   %eax
80106697:	68 f4 84 10 80       	push   $0x801084f4
8010669c:	e8 bf 9f ff ff       	call   80100660 <cprintf>
    lapiceoi();
801066a1:	e8 da c0 ff ff       	call   80102780 <lapiceoi>
    break;
801066a6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066a9:	e8 62 d2 ff ff       	call   80103910 <myproc>
801066ae:	85 c0                	test   %eax,%eax
801066b0:	0f 85 c1 fe ff ff    	jne    80106577 <trap+0xa7>
801066b6:	e9 d9 fe ff ff       	jmp    80106594 <trap+0xc4>
801066bb:	90                   	nop
801066bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801066c0:	e8 eb b9 ff ff       	call   801020b0 <ideintr>
801066c5:	e9 63 ff ff ff       	jmp    8010662d <trap+0x15d>
801066ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801066d0:	e8 fb d9 ff ff       	call   801040d0 <exit>
801066d5:	e9 0e ff ff ff       	jmp    801065e8 <trap+0x118>
801066da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801066e0:	e8 eb d9 ff ff       	call   801040d0 <exit>
801066e5:	e9 aa fe ff ff       	jmp    80106594 <trap+0xc4>
801066ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801066f0:	83 ec 0c             	sub    $0xc,%esp
801066f3:	68 e0 3a 12 80       	push   $0x80123ae0
801066f8:	e8 43 e9 ff ff       	call   80105040 <acquire>
      wakeup(&ticks);
801066fd:	c7 04 24 20 43 12 80 	movl   $0x80124320,(%esp)
      ticks++;
80106704:	83 05 20 43 12 80 01 	addl   $0x1,0x80124320
      wakeup(&ticks);
8010670b:	e8 30 dd ff ff       	call   80104440 <wakeup>
      release(&tickslock);
80106710:	c7 04 24 e0 3a 12 80 	movl   $0x80123ae0,(%esp)
80106717:	e8 e4 e9 ff ff       	call   80105100 <release>
8010671c:	83 c4 10             	add    $0x10,%esp
8010671f:	e9 09 ff ff ff       	jmp    8010662d <trap+0x15d>
80106724:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106727:	e8 c4 d1 ff ff       	call   801038f0 <cpuid>
8010672c:	83 ec 0c             	sub    $0xc,%esp
8010672f:	56                   	push   %esi
80106730:	53                   	push   %ebx
80106731:	50                   	push   %eax
80106732:	ff 77 30             	pushl  0x30(%edi)
80106735:	68 18 85 10 80       	push   $0x80108518
8010673a:	e8 21 9f ff ff       	call   80100660 <cprintf>
      panic("trap");
8010673f:	83 c4 14             	add    $0x14,%esp
80106742:	68 ee 84 10 80       	push   $0x801084ee
80106747:	e8 44 9c ff ff       	call   80100390 <panic>
8010674c:	66 90                	xchg   %ax,%ax
8010674e:	66 90                	xchg   %ax,%ax

80106750 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106750:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
{
80106755:	55                   	push   %ebp
80106756:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106758:	85 c0                	test   %eax,%eax
8010675a:	74 1c                	je     80106778 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010675c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106761:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106762:	a8 01                	test   $0x1,%al
80106764:	74 12                	je     80106778 <uartgetc+0x28>
80106766:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010676b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010676c:	0f b6 c0             	movzbl %al,%eax
}
8010676f:	5d                   	pop    %ebp
80106770:	c3                   	ret    
80106771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106778:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010677d:	5d                   	pop    %ebp
8010677e:	c3                   	ret    
8010677f:	90                   	nop

80106780 <uartputc.part.0>:
uartputc(int c)
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	57                   	push   %edi
80106784:	56                   	push   %esi
80106785:	53                   	push   %ebx
80106786:	89 c7                	mov    %eax,%edi
80106788:	bb 80 00 00 00       	mov    $0x80,%ebx
8010678d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106792:	83 ec 0c             	sub    $0xc,%esp
80106795:	eb 1b                	jmp    801067b2 <uartputc.part.0+0x32>
80106797:	89 f6                	mov    %esi,%esi
80106799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801067a0:	83 ec 0c             	sub    $0xc,%esp
801067a3:	6a 0a                	push   $0xa
801067a5:	e8 f6 bf ff ff       	call   801027a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801067aa:	83 c4 10             	add    $0x10,%esp
801067ad:	83 eb 01             	sub    $0x1,%ebx
801067b0:	74 07                	je     801067b9 <uartputc.part.0+0x39>
801067b2:	89 f2                	mov    %esi,%edx
801067b4:	ec                   	in     (%dx),%al
801067b5:	a8 20                	test   $0x20,%al
801067b7:	74 e7                	je     801067a0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067be:	89 f8                	mov    %edi,%eax
801067c0:	ee                   	out    %al,(%dx)
}
801067c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067c4:	5b                   	pop    %ebx
801067c5:	5e                   	pop    %esi
801067c6:	5f                   	pop    %edi
801067c7:	5d                   	pop    %ebp
801067c8:	c3                   	ret    
801067c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067d0 <uartinit>:
{
801067d0:	55                   	push   %ebp
801067d1:	31 c9                	xor    %ecx,%ecx
801067d3:	89 c8                	mov    %ecx,%eax
801067d5:	89 e5                	mov    %esp,%ebp
801067d7:	57                   	push   %edi
801067d8:	56                   	push   %esi
801067d9:	53                   	push   %ebx
801067da:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801067df:	89 da                	mov    %ebx,%edx
801067e1:	83 ec 0c             	sub    $0xc,%esp
801067e4:	ee                   	out    %al,(%dx)
801067e5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801067ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801067ef:	89 fa                	mov    %edi,%edx
801067f1:	ee                   	out    %al,(%dx)
801067f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801067f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067fc:	ee                   	out    %al,(%dx)
801067fd:	be f9 03 00 00       	mov    $0x3f9,%esi
80106802:	89 c8                	mov    %ecx,%eax
80106804:	89 f2                	mov    %esi,%edx
80106806:	ee                   	out    %al,(%dx)
80106807:	b8 03 00 00 00       	mov    $0x3,%eax
8010680c:	89 fa                	mov    %edi,%edx
8010680e:	ee                   	out    %al,(%dx)
8010680f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106814:	89 c8                	mov    %ecx,%eax
80106816:	ee                   	out    %al,(%dx)
80106817:	b8 01 00 00 00       	mov    $0x1,%eax
8010681c:	89 f2                	mov    %esi,%edx
8010681e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010681f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106824:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106825:	3c ff                	cmp    $0xff,%al
80106827:	74 5a                	je     80106883 <uartinit+0xb3>
  uart = 1;
80106829:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106830:	00 00 00 
80106833:	89 da                	mov    %ebx,%edx
80106835:	ec                   	in     (%dx),%al
80106836:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010683b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010683c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010683f:	bb 10 86 10 80       	mov    $0x80108610,%ebx
  ioapicenable(IRQ_COM1, 0);
80106844:	6a 00                	push   $0x0
80106846:	6a 04                	push   $0x4
80106848:	e8 b3 ba ff ff       	call   80102300 <ioapicenable>
8010684d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106850:	b8 78 00 00 00       	mov    $0x78,%eax
80106855:	eb 13                	jmp    8010686a <uartinit+0x9a>
80106857:	89 f6                	mov    %esi,%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106860:	83 c3 01             	add    $0x1,%ebx
80106863:	0f be 03             	movsbl (%ebx),%eax
80106866:	84 c0                	test   %al,%al
80106868:	74 19                	je     80106883 <uartinit+0xb3>
  if(!uart)
8010686a:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80106870:	85 d2                	test   %edx,%edx
80106872:	74 ec                	je     80106860 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106874:	83 c3 01             	add    $0x1,%ebx
80106877:	e8 04 ff ff ff       	call   80106780 <uartputc.part.0>
8010687c:	0f be 03             	movsbl (%ebx),%eax
8010687f:	84 c0                	test   %al,%al
80106881:	75 e7                	jne    8010686a <uartinit+0x9a>
}
80106883:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106886:	5b                   	pop    %ebx
80106887:	5e                   	pop    %esi
80106888:	5f                   	pop    %edi
80106889:	5d                   	pop    %ebp
8010688a:	c3                   	ret    
8010688b:	90                   	nop
8010688c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106890 <uartputc>:
  if(!uart)
80106890:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
80106896:	55                   	push   %ebp
80106897:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106899:	85 d2                	test   %edx,%edx
{
8010689b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010689e:	74 10                	je     801068b0 <uartputc+0x20>
}
801068a0:	5d                   	pop    %ebp
801068a1:	e9 da fe ff ff       	jmp    80106780 <uartputc.part.0>
801068a6:	8d 76 00             	lea    0x0(%esi),%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801068b0:	5d                   	pop    %ebp
801068b1:	c3                   	ret    
801068b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068c0 <uartintr>:

void
uartintr(void)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801068c6:	68 50 67 10 80       	push   $0x80106750
801068cb:	e8 40 9f ff ff       	call   80100810 <consoleintr>
}
801068d0:	83 c4 10             	add    $0x10,%esp
801068d3:	c9                   	leave  
801068d4:	c3                   	ret    

801068d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $0
801068d7:	6a 00                	push   $0x0
  jmp alltraps
801068d9:	e9 19 fb ff ff       	jmp    801063f7 <alltraps>

801068de <vector1>:
.globl vector1
vector1:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $1
801068e0:	6a 01                	push   $0x1
  jmp alltraps
801068e2:	e9 10 fb ff ff       	jmp    801063f7 <alltraps>

801068e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $2
801068e9:	6a 02                	push   $0x2
  jmp alltraps
801068eb:	e9 07 fb ff ff       	jmp    801063f7 <alltraps>

801068f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $3
801068f2:	6a 03                	push   $0x3
  jmp alltraps
801068f4:	e9 fe fa ff ff       	jmp    801063f7 <alltraps>

801068f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $4
801068fb:	6a 04                	push   $0x4
  jmp alltraps
801068fd:	e9 f5 fa ff ff       	jmp    801063f7 <alltraps>

80106902 <vector5>:
.globl vector5
vector5:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $5
80106904:	6a 05                	push   $0x5
  jmp alltraps
80106906:	e9 ec fa ff ff       	jmp    801063f7 <alltraps>

8010690b <vector6>:
.globl vector6
vector6:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $6
8010690d:	6a 06                	push   $0x6
  jmp alltraps
8010690f:	e9 e3 fa ff ff       	jmp    801063f7 <alltraps>

80106914 <vector7>:
.globl vector7
vector7:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $7
80106916:	6a 07                	push   $0x7
  jmp alltraps
80106918:	e9 da fa ff ff       	jmp    801063f7 <alltraps>

8010691d <vector8>:
.globl vector8
vector8:
  pushl $8
8010691d:	6a 08                	push   $0x8
  jmp alltraps
8010691f:	e9 d3 fa ff ff       	jmp    801063f7 <alltraps>

80106924 <vector9>:
.globl vector9
vector9:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $9
80106926:	6a 09                	push   $0x9
  jmp alltraps
80106928:	e9 ca fa ff ff       	jmp    801063f7 <alltraps>

8010692d <vector10>:
.globl vector10
vector10:
  pushl $10
8010692d:	6a 0a                	push   $0xa
  jmp alltraps
8010692f:	e9 c3 fa ff ff       	jmp    801063f7 <alltraps>

80106934 <vector11>:
.globl vector11
vector11:
  pushl $11
80106934:	6a 0b                	push   $0xb
  jmp alltraps
80106936:	e9 bc fa ff ff       	jmp    801063f7 <alltraps>

8010693b <vector12>:
.globl vector12
vector12:
  pushl $12
8010693b:	6a 0c                	push   $0xc
  jmp alltraps
8010693d:	e9 b5 fa ff ff       	jmp    801063f7 <alltraps>

80106942 <vector13>:
.globl vector13
vector13:
  pushl $13
80106942:	6a 0d                	push   $0xd
  jmp alltraps
80106944:	e9 ae fa ff ff       	jmp    801063f7 <alltraps>

80106949 <vector14>:
.globl vector14
vector14:
  pushl $14
80106949:	6a 0e                	push   $0xe
  jmp alltraps
8010694b:	e9 a7 fa ff ff       	jmp    801063f7 <alltraps>

80106950 <vector15>:
.globl vector15
vector15:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $15
80106952:	6a 0f                	push   $0xf
  jmp alltraps
80106954:	e9 9e fa ff ff       	jmp    801063f7 <alltraps>

80106959 <vector16>:
.globl vector16
vector16:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $16
8010695b:	6a 10                	push   $0x10
  jmp alltraps
8010695d:	e9 95 fa ff ff       	jmp    801063f7 <alltraps>

80106962 <vector17>:
.globl vector17
vector17:
  pushl $17
80106962:	6a 11                	push   $0x11
  jmp alltraps
80106964:	e9 8e fa ff ff       	jmp    801063f7 <alltraps>

80106969 <vector18>:
.globl vector18
vector18:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $18
8010696b:	6a 12                	push   $0x12
  jmp alltraps
8010696d:	e9 85 fa ff ff       	jmp    801063f7 <alltraps>

80106972 <vector19>:
.globl vector19
vector19:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $19
80106974:	6a 13                	push   $0x13
  jmp alltraps
80106976:	e9 7c fa ff ff       	jmp    801063f7 <alltraps>

8010697b <vector20>:
.globl vector20
vector20:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $20
8010697d:	6a 14                	push   $0x14
  jmp alltraps
8010697f:	e9 73 fa ff ff       	jmp    801063f7 <alltraps>

80106984 <vector21>:
.globl vector21
vector21:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $21
80106986:	6a 15                	push   $0x15
  jmp alltraps
80106988:	e9 6a fa ff ff       	jmp    801063f7 <alltraps>

8010698d <vector22>:
.globl vector22
vector22:
  pushl $0
8010698d:	6a 00                	push   $0x0
  pushl $22
8010698f:	6a 16                	push   $0x16
  jmp alltraps
80106991:	e9 61 fa ff ff       	jmp    801063f7 <alltraps>

80106996 <vector23>:
.globl vector23
vector23:
  pushl $0
80106996:	6a 00                	push   $0x0
  pushl $23
80106998:	6a 17                	push   $0x17
  jmp alltraps
8010699a:	e9 58 fa ff ff       	jmp    801063f7 <alltraps>

8010699f <vector24>:
.globl vector24
vector24:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $24
801069a1:	6a 18                	push   $0x18
  jmp alltraps
801069a3:	e9 4f fa ff ff       	jmp    801063f7 <alltraps>

801069a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801069a8:	6a 00                	push   $0x0
  pushl $25
801069aa:	6a 19                	push   $0x19
  jmp alltraps
801069ac:	e9 46 fa ff ff       	jmp    801063f7 <alltraps>

801069b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801069b1:	6a 00                	push   $0x0
  pushl $26
801069b3:	6a 1a                	push   $0x1a
  jmp alltraps
801069b5:	e9 3d fa ff ff       	jmp    801063f7 <alltraps>

801069ba <vector27>:
.globl vector27
vector27:
  pushl $0
801069ba:	6a 00                	push   $0x0
  pushl $27
801069bc:	6a 1b                	push   $0x1b
  jmp alltraps
801069be:	e9 34 fa ff ff       	jmp    801063f7 <alltraps>

801069c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $28
801069c5:	6a 1c                	push   $0x1c
  jmp alltraps
801069c7:	e9 2b fa ff ff       	jmp    801063f7 <alltraps>

801069cc <vector29>:
.globl vector29
vector29:
  pushl $0
801069cc:	6a 00                	push   $0x0
  pushl $29
801069ce:	6a 1d                	push   $0x1d
  jmp alltraps
801069d0:	e9 22 fa ff ff       	jmp    801063f7 <alltraps>

801069d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801069d5:	6a 00                	push   $0x0
  pushl $30
801069d7:	6a 1e                	push   $0x1e
  jmp alltraps
801069d9:	e9 19 fa ff ff       	jmp    801063f7 <alltraps>

801069de <vector31>:
.globl vector31
vector31:
  pushl $0
801069de:	6a 00                	push   $0x0
  pushl $31
801069e0:	6a 1f                	push   $0x1f
  jmp alltraps
801069e2:	e9 10 fa ff ff       	jmp    801063f7 <alltraps>

801069e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $32
801069e9:	6a 20                	push   $0x20
  jmp alltraps
801069eb:	e9 07 fa ff ff       	jmp    801063f7 <alltraps>

801069f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801069f0:	6a 00                	push   $0x0
  pushl $33
801069f2:	6a 21                	push   $0x21
  jmp alltraps
801069f4:	e9 fe f9 ff ff       	jmp    801063f7 <alltraps>

801069f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801069f9:	6a 00                	push   $0x0
  pushl $34
801069fb:	6a 22                	push   $0x22
  jmp alltraps
801069fd:	e9 f5 f9 ff ff       	jmp    801063f7 <alltraps>

80106a02 <vector35>:
.globl vector35
vector35:
  pushl $0
80106a02:	6a 00                	push   $0x0
  pushl $35
80106a04:	6a 23                	push   $0x23
  jmp alltraps
80106a06:	e9 ec f9 ff ff       	jmp    801063f7 <alltraps>

80106a0b <vector36>:
.globl vector36
vector36:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $36
80106a0d:	6a 24                	push   $0x24
  jmp alltraps
80106a0f:	e9 e3 f9 ff ff       	jmp    801063f7 <alltraps>

80106a14 <vector37>:
.globl vector37
vector37:
  pushl $0
80106a14:	6a 00                	push   $0x0
  pushl $37
80106a16:	6a 25                	push   $0x25
  jmp alltraps
80106a18:	e9 da f9 ff ff       	jmp    801063f7 <alltraps>

80106a1d <vector38>:
.globl vector38
vector38:
  pushl $0
80106a1d:	6a 00                	push   $0x0
  pushl $38
80106a1f:	6a 26                	push   $0x26
  jmp alltraps
80106a21:	e9 d1 f9 ff ff       	jmp    801063f7 <alltraps>

80106a26 <vector39>:
.globl vector39
vector39:
  pushl $0
80106a26:	6a 00                	push   $0x0
  pushl $39
80106a28:	6a 27                	push   $0x27
  jmp alltraps
80106a2a:	e9 c8 f9 ff ff       	jmp    801063f7 <alltraps>

80106a2f <vector40>:
.globl vector40
vector40:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $40
80106a31:	6a 28                	push   $0x28
  jmp alltraps
80106a33:	e9 bf f9 ff ff       	jmp    801063f7 <alltraps>

80106a38 <vector41>:
.globl vector41
vector41:
  pushl $0
80106a38:	6a 00                	push   $0x0
  pushl $41
80106a3a:	6a 29                	push   $0x29
  jmp alltraps
80106a3c:	e9 b6 f9 ff ff       	jmp    801063f7 <alltraps>

80106a41 <vector42>:
.globl vector42
vector42:
  pushl $0
80106a41:	6a 00                	push   $0x0
  pushl $42
80106a43:	6a 2a                	push   $0x2a
  jmp alltraps
80106a45:	e9 ad f9 ff ff       	jmp    801063f7 <alltraps>

80106a4a <vector43>:
.globl vector43
vector43:
  pushl $0
80106a4a:	6a 00                	push   $0x0
  pushl $43
80106a4c:	6a 2b                	push   $0x2b
  jmp alltraps
80106a4e:	e9 a4 f9 ff ff       	jmp    801063f7 <alltraps>

80106a53 <vector44>:
.globl vector44
vector44:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $44
80106a55:	6a 2c                	push   $0x2c
  jmp alltraps
80106a57:	e9 9b f9 ff ff       	jmp    801063f7 <alltraps>

80106a5c <vector45>:
.globl vector45
vector45:
  pushl $0
80106a5c:	6a 00                	push   $0x0
  pushl $45
80106a5e:	6a 2d                	push   $0x2d
  jmp alltraps
80106a60:	e9 92 f9 ff ff       	jmp    801063f7 <alltraps>

80106a65 <vector46>:
.globl vector46
vector46:
  pushl $0
80106a65:	6a 00                	push   $0x0
  pushl $46
80106a67:	6a 2e                	push   $0x2e
  jmp alltraps
80106a69:	e9 89 f9 ff ff       	jmp    801063f7 <alltraps>

80106a6e <vector47>:
.globl vector47
vector47:
  pushl $0
80106a6e:	6a 00                	push   $0x0
  pushl $47
80106a70:	6a 2f                	push   $0x2f
  jmp alltraps
80106a72:	e9 80 f9 ff ff       	jmp    801063f7 <alltraps>

80106a77 <vector48>:
.globl vector48
vector48:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $48
80106a79:	6a 30                	push   $0x30
  jmp alltraps
80106a7b:	e9 77 f9 ff ff       	jmp    801063f7 <alltraps>

80106a80 <vector49>:
.globl vector49
vector49:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $49
80106a82:	6a 31                	push   $0x31
  jmp alltraps
80106a84:	e9 6e f9 ff ff       	jmp    801063f7 <alltraps>

80106a89 <vector50>:
.globl vector50
vector50:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $50
80106a8b:	6a 32                	push   $0x32
  jmp alltraps
80106a8d:	e9 65 f9 ff ff       	jmp    801063f7 <alltraps>

80106a92 <vector51>:
.globl vector51
vector51:
  pushl $0
80106a92:	6a 00                	push   $0x0
  pushl $51
80106a94:	6a 33                	push   $0x33
  jmp alltraps
80106a96:	e9 5c f9 ff ff       	jmp    801063f7 <alltraps>

80106a9b <vector52>:
.globl vector52
vector52:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $52
80106a9d:	6a 34                	push   $0x34
  jmp alltraps
80106a9f:	e9 53 f9 ff ff       	jmp    801063f7 <alltraps>

80106aa4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106aa4:	6a 00                	push   $0x0
  pushl $53
80106aa6:	6a 35                	push   $0x35
  jmp alltraps
80106aa8:	e9 4a f9 ff ff       	jmp    801063f7 <alltraps>

80106aad <vector54>:
.globl vector54
vector54:
  pushl $0
80106aad:	6a 00                	push   $0x0
  pushl $54
80106aaf:	6a 36                	push   $0x36
  jmp alltraps
80106ab1:	e9 41 f9 ff ff       	jmp    801063f7 <alltraps>

80106ab6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ab6:	6a 00                	push   $0x0
  pushl $55
80106ab8:	6a 37                	push   $0x37
  jmp alltraps
80106aba:	e9 38 f9 ff ff       	jmp    801063f7 <alltraps>

80106abf <vector56>:
.globl vector56
vector56:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $56
80106ac1:	6a 38                	push   $0x38
  jmp alltraps
80106ac3:	e9 2f f9 ff ff       	jmp    801063f7 <alltraps>

80106ac8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106ac8:	6a 00                	push   $0x0
  pushl $57
80106aca:	6a 39                	push   $0x39
  jmp alltraps
80106acc:	e9 26 f9 ff ff       	jmp    801063f7 <alltraps>

80106ad1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106ad1:	6a 00                	push   $0x0
  pushl $58
80106ad3:	6a 3a                	push   $0x3a
  jmp alltraps
80106ad5:	e9 1d f9 ff ff       	jmp    801063f7 <alltraps>

80106ada <vector59>:
.globl vector59
vector59:
  pushl $0
80106ada:	6a 00                	push   $0x0
  pushl $59
80106adc:	6a 3b                	push   $0x3b
  jmp alltraps
80106ade:	e9 14 f9 ff ff       	jmp    801063f7 <alltraps>

80106ae3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $60
80106ae5:	6a 3c                	push   $0x3c
  jmp alltraps
80106ae7:	e9 0b f9 ff ff       	jmp    801063f7 <alltraps>

80106aec <vector61>:
.globl vector61
vector61:
  pushl $0
80106aec:	6a 00                	push   $0x0
  pushl $61
80106aee:	6a 3d                	push   $0x3d
  jmp alltraps
80106af0:	e9 02 f9 ff ff       	jmp    801063f7 <alltraps>

80106af5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106af5:	6a 00                	push   $0x0
  pushl $62
80106af7:	6a 3e                	push   $0x3e
  jmp alltraps
80106af9:	e9 f9 f8 ff ff       	jmp    801063f7 <alltraps>

80106afe <vector63>:
.globl vector63
vector63:
  pushl $0
80106afe:	6a 00                	push   $0x0
  pushl $63
80106b00:	6a 3f                	push   $0x3f
  jmp alltraps
80106b02:	e9 f0 f8 ff ff       	jmp    801063f7 <alltraps>

80106b07 <vector64>:
.globl vector64
vector64:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $64
80106b09:	6a 40                	push   $0x40
  jmp alltraps
80106b0b:	e9 e7 f8 ff ff       	jmp    801063f7 <alltraps>

80106b10 <vector65>:
.globl vector65
vector65:
  pushl $0
80106b10:	6a 00                	push   $0x0
  pushl $65
80106b12:	6a 41                	push   $0x41
  jmp alltraps
80106b14:	e9 de f8 ff ff       	jmp    801063f7 <alltraps>

80106b19 <vector66>:
.globl vector66
vector66:
  pushl $0
80106b19:	6a 00                	push   $0x0
  pushl $66
80106b1b:	6a 42                	push   $0x42
  jmp alltraps
80106b1d:	e9 d5 f8 ff ff       	jmp    801063f7 <alltraps>

80106b22 <vector67>:
.globl vector67
vector67:
  pushl $0
80106b22:	6a 00                	push   $0x0
  pushl $67
80106b24:	6a 43                	push   $0x43
  jmp alltraps
80106b26:	e9 cc f8 ff ff       	jmp    801063f7 <alltraps>

80106b2b <vector68>:
.globl vector68
vector68:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $68
80106b2d:	6a 44                	push   $0x44
  jmp alltraps
80106b2f:	e9 c3 f8 ff ff       	jmp    801063f7 <alltraps>

80106b34 <vector69>:
.globl vector69
vector69:
  pushl $0
80106b34:	6a 00                	push   $0x0
  pushl $69
80106b36:	6a 45                	push   $0x45
  jmp alltraps
80106b38:	e9 ba f8 ff ff       	jmp    801063f7 <alltraps>

80106b3d <vector70>:
.globl vector70
vector70:
  pushl $0
80106b3d:	6a 00                	push   $0x0
  pushl $70
80106b3f:	6a 46                	push   $0x46
  jmp alltraps
80106b41:	e9 b1 f8 ff ff       	jmp    801063f7 <alltraps>

80106b46 <vector71>:
.globl vector71
vector71:
  pushl $0
80106b46:	6a 00                	push   $0x0
  pushl $71
80106b48:	6a 47                	push   $0x47
  jmp alltraps
80106b4a:	e9 a8 f8 ff ff       	jmp    801063f7 <alltraps>

80106b4f <vector72>:
.globl vector72
vector72:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $72
80106b51:	6a 48                	push   $0x48
  jmp alltraps
80106b53:	e9 9f f8 ff ff       	jmp    801063f7 <alltraps>

80106b58 <vector73>:
.globl vector73
vector73:
  pushl $0
80106b58:	6a 00                	push   $0x0
  pushl $73
80106b5a:	6a 49                	push   $0x49
  jmp alltraps
80106b5c:	e9 96 f8 ff ff       	jmp    801063f7 <alltraps>

80106b61 <vector74>:
.globl vector74
vector74:
  pushl $0
80106b61:	6a 00                	push   $0x0
  pushl $74
80106b63:	6a 4a                	push   $0x4a
  jmp alltraps
80106b65:	e9 8d f8 ff ff       	jmp    801063f7 <alltraps>

80106b6a <vector75>:
.globl vector75
vector75:
  pushl $0
80106b6a:	6a 00                	push   $0x0
  pushl $75
80106b6c:	6a 4b                	push   $0x4b
  jmp alltraps
80106b6e:	e9 84 f8 ff ff       	jmp    801063f7 <alltraps>

80106b73 <vector76>:
.globl vector76
vector76:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $76
80106b75:	6a 4c                	push   $0x4c
  jmp alltraps
80106b77:	e9 7b f8 ff ff       	jmp    801063f7 <alltraps>

80106b7c <vector77>:
.globl vector77
vector77:
  pushl $0
80106b7c:	6a 00                	push   $0x0
  pushl $77
80106b7e:	6a 4d                	push   $0x4d
  jmp alltraps
80106b80:	e9 72 f8 ff ff       	jmp    801063f7 <alltraps>

80106b85 <vector78>:
.globl vector78
vector78:
  pushl $0
80106b85:	6a 00                	push   $0x0
  pushl $78
80106b87:	6a 4e                	push   $0x4e
  jmp alltraps
80106b89:	e9 69 f8 ff ff       	jmp    801063f7 <alltraps>

80106b8e <vector79>:
.globl vector79
vector79:
  pushl $0
80106b8e:	6a 00                	push   $0x0
  pushl $79
80106b90:	6a 4f                	push   $0x4f
  jmp alltraps
80106b92:	e9 60 f8 ff ff       	jmp    801063f7 <alltraps>

80106b97 <vector80>:
.globl vector80
vector80:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $80
80106b99:	6a 50                	push   $0x50
  jmp alltraps
80106b9b:	e9 57 f8 ff ff       	jmp    801063f7 <alltraps>

80106ba0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ba0:	6a 00                	push   $0x0
  pushl $81
80106ba2:	6a 51                	push   $0x51
  jmp alltraps
80106ba4:	e9 4e f8 ff ff       	jmp    801063f7 <alltraps>

80106ba9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106ba9:	6a 00                	push   $0x0
  pushl $82
80106bab:	6a 52                	push   $0x52
  jmp alltraps
80106bad:	e9 45 f8 ff ff       	jmp    801063f7 <alltraps>

80106bb2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106bb2:	6a 00                	push   $0x0
  pushl $83
80106bb4:	6a 53                	push   $0x53
  jmp alltraps
80106bb6:	e9 3c f8 ff ff       	jmp    801063f7 <alltraps>

80106bbb <vector84>:
.globl vector84
vector84:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $84
80106bbd:	6a 54                	push   $0x54
  jmp alltraps
80106bbf:	e9 33 f8 ff ff       	jmp    801063f7 <alltraps>

80106bc4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106bc4:	6a 00                	push   $0x0
  pushl $85
80106bc6:	6a 55                	push   $0x55
  jmp alltraps
80106bc8:	e9 2a f8 ff ff       	jmp    801063f7 <alltraps>

80106bcd <vector86>:
.globl vector86
vector86:
  pushl $0
80106bcd:	6a 00                	push   $0x0
  pushl $86
80106bcf:	6a 56                	push   $0x56
  jmp alltraps
80106bd1:	e9 21 f8 ff ff       	jmp    801063f7 <alltraps>

80106bd6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106bd6:	6a 00                	push   $0x0
  pushl $87
80106bd8:	6a 57                	push   $0x57
  jmp alltraps
80106bda:	e9 18 f8 ff ff       	jmp    801063f7 <alltraps>

80106bdf <vector88>:
.globl vector88
vector88:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $88
80106be1:	6a 58                	push   $0x58
  jmp alltraps
80106be3:	e9 0f f8 ff ff       	jmp    801063f7 <alltraps>

80106be8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106be8:	6a 00                	push   $0x0
  pushl $89
80106bea:	6a 59                	push   $0x59
  jmp alltraps
80106bec:	e9 06 f8 ff ff       	jmp    801063f7 <alltraps>

80106bf1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106bf1:	6a 00                	push   $0x0
  pushl $90
80106bf3:	6a 5a                	push   $0x5a
  jmp alltraps
80106bf5:	e9 fd f7 ff ff       	jmp    801063f7 <alltraps>

80106bfa <vector91>:
.globl vector91
vector91:
  pushl $0
80106bfa:	6a 00                	push   $0x0
  pushl $91
80106bfc:	6a 5b                	push   $0x5b
  jmp alltraps
80106bfe:	e9 f4 f7 ff ff       	jmp    801063f7 <alltraps>

80106c03 <vector92>:
.globl vector92
vector92:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $92
80106c05:	6a 5c                	push   $0x5c
  jmp alltraps
80106c07:	e9 eb f7 ff ff       	jmp    801063f7 <alltraps>

80106c0c <vector93>:
.globl vector93
vector93:
  pushl $0
80106c0c:	6a 00                	push   $0x0
  pushl $93
80106c0e:	6a 5d                	push   $0x5d
  jmp alltraps
80106c10:	e9 e2 f7 ff ff       	jmp    801063f7 <alltraps>

80106c15 <vector94>:
.globl vector94
vector94:
  pushl $0
80106c15:	6a 00                	push   $0x0
  pushl $94
80106c17:	6a 5e                	push   $0x5e
  jmp alltraps
80106c19:	e9 d9 f7 ff ff       	jmp    801063f7 <alltraps>

80106c1e <vector95>:
.globl vector95
vector95:
  pushl $0
80106c1e:	6a 00                	push   $0x0
  pushl $95
80106c20:	6a 5f                	push   $0x5f
  jmp alltraps
80106c22:	e9 d0 f7 ff ff       	jmp    801063f7 <alltraps>

80106c27 <vector96>:
.globl vector96
vector96:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $96
80106c29:	6a 60                	push   $0x60
  jmp alltraps
80106c2b:	e9 c7 f7 ff ff       	jmp    801063f7 <alltraps>

80106c30 <vector97>:
.globl vector97
vector97:
  pushl $0
80106c30:	6a 00                	push   $0x0
  pushl $97
80106c32:	6a 61                	push   $0x61
  jmp alltraps
80106c34:	e9 be f7 ff ff       	jmp    801063f7 <alltraps>

80106c39 <vector98>:
.globl vector98
vector98:
  pushl $0
80106c39:	6a 00                	push   $0x0
  pushl $98
80106c3b:	6a 62                	push   $0x62
  jmp alltraps
80106c3d:	e9 b5 f7 ff ff       	jmp    801063f7 <alltraps>

80106c42 <vector99>:
.globl vector99
vector99:
  pushl $0
80106c42:	6a 00                	push   $0x0
  pushl $99
80106c44:	6a 63                	push   $0x63
  jmp alltraps
80106c46:	e9 ac f7 ff ff       	jmp    801063f7 <alltraps>

80106c4b <vector100>:
.globl vector100
vector100:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $100
80106c4d:	6a 64                	push   $0x64
  jmp alltraps
80106c4f:	e9 a3 f7 ff ff       	jmp    801063f7 <alltraps>

80106c54 <vector101>:
.globl vector101
vector101:
  pushl $0
80106c54:	6a 00                	push   $0x0
  pushl $101
80106c56:	6a 65                	push   $0x65
  jmp alltraps
80106c58:	e9 9a f7 ff ff       	jmp    801063f7 <alltraps>

80106c5d <vector102>:
.globl vector102
vector102:
  pushl $0
80106c5d:	6a 00                	push   $0x0
  pushl $102
80106c5f:	6a 66                	push   $0x66
  jmp alltraps
80106c61:	e9 91 f7 ff ff       	jmp    801063f7 <alltraps>

80106c66 <vector103>:
.globl vector103
vector103:
  pushl $0
80106c66:	6a 00                	push   $0x0
  pushl $103
80106c68:	6a 67                	push   $0x67
  jmp alltraps
80106c6a:	e9 88 f7 ff ff       	jmp    801063f7 <alltraps>

80106c6f <vector104>:
.globl vector104
vector104:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $104
80106c71:	6a 68                	push   $0x68
  jmp alltraps
80106c73:	e9 7f f7 ff ff       	jmp    801063f7 <alltraps>

80106c78 <vector105>:
.globl vector105
vector105:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $105
80106c7a:	6a 69                	push   $0x69
  jmp alltraps
80106c7c:	e9 76 f7 ff ff       	jmp    801063f7 <alltraps>

80106c81 <vector106>:
.globl vector106
vector106:
  pushl $0
80106c81:	6a 00                	push   $0x0
  pushl $106
80106c83:	6a 6a                	push   $0x6a
  jmp alltraps
80106c85:	e9 6d f7 ff ff       	jmp    801063f7 <alltraps>

80106c8a <vector107>:
.globl vector107
vector107:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $107
80106c8c:	6a 6b                	push   $0x6b
  jmp alltraps
80106c8e:	e9 64 f7 ff ff       	jmp    801063f7 <alltraps>

80106c93 <vector108>:
.globl vector108
vector108:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $108
80106c95:	6a 6c                	push   $0x6c
  jmp alltraps
80106c97:	e9 5b f7 ff ff       	jmp    801063f7 <alltraps>

80106c9c <vector109>:
.globl vector109
vector109:
  pushl $0
80106c9c:	6a 00                	push   $0x0
  pushl $109
80106c9e:	6a 6d                	push   $0x6d
  jmp alltraps
80106ca0:	e9 52 f7 ff ff       	jmp    801063f7 <alltraps>

80106ca5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ca5:	6a 00                	push   $0x0
  pushl $110
80106ca7:	6a 6e                	push   $0x6e
  jmp alltraps
80106ca9:	e9 49 f7 ff ff       	jmp    801063f7 <alltraps>

80106cae <vector111>:
.globl vector111
vector111:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $111
80106cb0:	6a 6f                	push   $0x6f
  jmp alltraps
80106cb2:	e9 40 f7 ff ff       	jmp    801063f7 <alltraps>

80106cb7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $112
80106cb9:	6a 70                	push   $0x70
  jmp alltraps
80106cbb:	e9 37 f7 ff ff       	jmp    801063f7 <alltraps>

80106cc0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106cc0:	6a 00                	push   $0x0
  pushl $113
80106cc2:	6a 71                	push   $0x71
  jmp alltraps
80106cc4:	e9 2e f7 ff ff       	jmp    801063f7 <alltraps>

80106cc9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106cc9:	6a 00                	push   $0x0
  pushl $114
80106ccb:	6a 72                	push   $0x72
  jmp alltraps
80106ccd:	e9 25 f7 ff ff       	jmp    801063f7 <alltraps>

80106cd2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $115
80106cd4:	6a 73                	push   $0x73
  jmp alltraps
80106cd6:	e9 1c f7 ff ff       	jmp    801063f7 <alltraps>

80106cdb <vector116>:
.globl vector116
vector116:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $116
80106cdd:	6a 74                	push   $0x74
  jmp alltraps
80106cdf:	e9 13 f7 ff ff       	jmp    801063f7 <alltraps>

80106ce4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $117
80106ce6:	6a 75                	push   $0x75
  jmp alltraps
80106ce8:	e9 0a f7 ff ff       	jmp    801063f7 <alltraps>

80106ced <vector118>:
.globl vector118
vector118:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $118
80106cef:	6a 76                	push   $0x76
  jmp alltraps
80106cf1:	e9 01 f7 ff ff       	jmp    801063f7 <alltraps>

80106cf6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $119
80106cf8:	6a 77                	push   $0x77
  jmp alltraps
80106cfa:	e9 f8 f6 ff ff       	jmp    801063f7 <alltraps>

80106cff <vector120>:
.globl vector120
vector120:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $120
80106d01:	6a 78                	push   $0x78
  jmp alltraps
80106d03:	e9 ef f6 ff ff       	jmp    801063f7 <alltraps>

80106d08 <vector121>:
.globl vector121
vector121:
  pushl $0
80106d08:	6a 00                	push   $0x0
  pushl $121
80106d0a:	6a 79                	push   $0x79
  jmp alltraps
80106d0c:	e9 e6 f6 ff ff       	jmp    801063f7 <alltraps>

80106d11 <vector122>:
.globl vector122
vector122:
  pushl $0
80106d11:	6a 00                	push   $0x0
  pushl $122
80106d13:	6a 7a                	push   $0x7a
  jmp alltraps
80106d15:	e9 dd f6 ff ff       	jmp    801063f7 <alltraps>

80106d1a <vector123>:
.globl vector123
vector123:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $123
80106d1c:	6a 7b                	push   $0x7b
  jmp alltraps
80106d1e:	e9 d4 f6 ff ff       	jmp    801063f7 <alltraps>

80106d23 <vector124>:
.globl vector124
vector124:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $124
80106d25:	6a 7c                	push   $0x7c
  jmp alltraps
80106d27:	e9 cb f6 ff ff       	jmp    801063f7 <alltraps>

80106d2c <vector125>:
.globl vector125
vector125:
  pushl $0
80106d2c:	6a 00                	push   $0x0
  pushl $125
80106d2e:	6a 7d                	push   $0x7d
  jmp alltraps
80106d30:	e9 c2 f6 ff ff       	jmp    801063f7 <alltraps>

80106d35 <vector126>:
.globl vector126
vector126:
  pushl $0
80106d35:	6a 00                	push   $0x0
  pushl $126
80106d37:	6a 7e                	push   $0x7e
  jmp alltraps
80106d39:	e9 b9 f6 ff ff       	jmp    801063f7 <alltraps>

80106d3e <vector127>:
.globl vector127
vector127:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $127
80106d40:	6a 7f                	push   $0x7f
  jmp alltraps
80106d42:	e9 b0 f6 ff ff       	jmp    801063f7 <alltraps>

80106d47 <vector128>:
.globl vector128
vector128:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $128
80106d49:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106d4e:	e9 a4 f6 ff ff       	jmp    801063f7 <alltraps>

80106d53 <vector129>:
.globl vector129
vector129:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $129
80106d55:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106d5a:	e9 98 f6 ff ff       	jmp    801063f7 <alltraps>

80106d5f <vector130>:
.globl vector130
vector130:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $130
80106d61:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106d66:	e9 8c f6 ff ff       	jmp    801063f7 <alltraps>

80106d6b <vector131>:
.globl vector131
vector131:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $131
80106d6d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106d72:	e9 80 f6 ff ff       	jmp    801063f7 <alltraps>

80106d77 <vector132>:
.globl vector132
vector132:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $132
80106d79:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106d7e:	e9 74 f6 ff ff       	jmp    801063f7 <alltraps>

80106d83 <vector133>:
.globl vector133
vector133:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $133
80106d85:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106d8a:	e9 68 f6 ff ff       	jmp    801063f7 <alltraps>

80106d8f <vector134>:
.globl vector134
vector134:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $134
80106d91:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106d96:	e9 5c f6 ff ff       	jmp    801063f7 <alltraps>

80106d9b <vector135>:
.globl vector135
vector135:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $135
80106d9d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106da2:	e9 50 f6 ff ff       	jmp    801063f7 <alltraps>

80106da7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $136
80106da9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106dae:	e9 44 f6 ff ff       	jmp    801063f7 <alltraps>

80106db3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $137
80106db5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106dba:	e9 38 f6 ff ff       	jmp    801063f7 <alltraps>

80106dbf <vector138>:
.globl vector138
vector138:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $138
80106dc1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106dc6:	e9 2c f6 ff ff       	jmp    801063f7 <alltraps>

80106dcb <vector139>:
.globl vector139
vector139:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $139
80106dcd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106dd2:	e9 20 f6 ff ff       	jmp    801063f7 <alltraps>

80106dd7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $140
80106dd9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106dde:	e9 14 f6 ff ff       	jmp    801063f7 <alltraps>

80106de3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $141
80106de5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106dea:	e9 08 f6 ff ff       	jmp    801063f7 <alltraps>

80106def <vector142>:
.globl vector142
vector142:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $142
80106df1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106df6:	e9 fc f5 ff ff       	jmp    801063f7 <alltraps>

80106dfb <vector143>:
.globl vector143
vector143:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $143
80106dfd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106e02:	e9 f0 f5 ff ff       	jmp    801063f7 <alltraps>

80106e07 <vector144>:
.globl vector144
vector144:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $144
80106e09:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106e0e:	e9 e4 f5 ff ff       	jmp    801063f7 <alltraps>

80106e13 <vector145>:
.globl vector145
vector145:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $145
80106e15:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106e1a:	e9 d8 f5 ff ff       	jmp    801063f7 <alltraps>

80106e1f <vector146>:
.globl vector146
vector146:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $146
80106e21:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106e26:	e9 cc f5 ff ff       	jmp    801063f7 <alltraps>

80106e2b <vector147>:
.globl vector147
vector147:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $147
80106e2d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106e32:	e9 c0 f5 ff ff       	jmp    801063f7 <alltraps>

80106e37 <vector148>:
.globl vector148
vector148:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $148
80106e39:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106e3e:	e9 b4 f5 ff ff       	jmp    801063f7 <alltraps>

80106e43 <vector149>:
.globl vector149
vector149:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $149
80106e45:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106e4a:	e9 a8 f5 ff ff       	jmp    801063f7 <alltraps>

80106e4f <vector150>:
.globl vector150
vector150:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $150
80106e51:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106e56:	e9 9c f5 ff ff       	jmp    801063f7 <alltraps>

80106e5b <vector151>:
.globl vector151
vector151:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $151
80106e5d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106e62:	e9 90 f5 ff ff       	jmp    801063f7 <alltraps>

80106e67 <vector152>:
.globl vector152
vector152:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $152
80106e69:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106e6e:	e9 84 f5 ff ff       	jmp    801063f7 <alltraps>

80106e73 <vector153>:
.globl vector153
vector153:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $153
80106e75:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106e7a:	e9 78 f5 ff ff       	jmp    801063f7 <alltraps>

80106e7f <vector154>:
.globl vector154
vector154:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $154
80106e81:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106e86:	e9 6c f5 ff ff       	jmp    801063f7 <alltraps>

80106e8b <vector155>:
.globl vector155
vector155:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $155
80106e8d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106e92:	e9 60 f5 ff ff       	jmp    801063f7 <alltraps>

80106e97 <vector156>:
.globl vector156
vector156:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $156
80106e99:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106e9e:	e9 54 f5 ff ff       	jmp    801063f7 <alltraps>

80106ea3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $157
80106ea5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106eaa:	e9 48 f5 ff ff       	jmp    801063f7 <alltraps>

80106eaf <vector158>:
.globl vector158
vector158:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $158
80106eb1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106eb6:	e9 3c f5 ff ff       	jmp    801063f7 <alltraps>

80106ebb <vector159>:
.globl vector159
vector159:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $159
80106ebd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ec2:	e9 30 f5 ff ff       	jmp    801063f7 <alltraps>

80106ec7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $160
80106ec9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106ece:	e9 24 f5 ff ff       	jmp    801063f7 <alltraps>

80106ed3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $161
80106ed5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106eda:	e9 18 f5 ff ff       	jmp    801063f7 <alltraps>

80106edf <vector162>:
.globl vector162
vector162:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $162
80106ee1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ee6:	e9 0c f5 ff ff       	jmp    801063f7 <alltraps>

80106eeb <vector163>:
.globl vector163
vector163:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $163
80106eed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ef2:	e9 00 f5 ff ff       	jmp    801063f7 <alltraps>

80106ef7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $164
80106ef9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106efe:	e9 f4 f4 ff ff       	jmp    801063f7 <alltraps>

80106f03 <vector165>:
.globl vector165
vector165:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $165
80106f05:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106f0a:	e9 e8 f4 ff ff       	jmp    801063f7 <alltraps>

80106f0f <vector166>:
.globl vector166
vector166:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $166
80106f11:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106f16:	e9 dc f4 ff ff       	jmp    801063f7 <alltraps>

80106f1b <vector167>:
.globl vector167
vector167:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $167
80106f1d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106f22:	e9 d0 f4 ff ff       	jmp    801063f7 <alltraps>

80106f27 <vector168>:
.globl vector168
vector168:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $168
80106f29:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106f2e:	e9 c4 f4 ff ff       	jmp    801063f7 <alltraps>

80106f33 <vector169>:
.globl vector169
vector169:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $169
80106f35:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106f3a:	e9 b8 f4 ff ff       	jmp    801063f7 <alltraps>

80106f3f <vector170>:
.globl vector170
vector170:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $170
80106f41:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106f46:	e9 ac f4 ff ff       	jmp    801063f7 <alltraps>

80106f4b <vector171>:
.globl vector171
vector171:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $171
80106f4d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106f52:	e9 a0 f4 ff ff       	jmp    801063f7 <alltraps>

80106f57 <vector172>:
.globl vector172
vector172:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $172
80106f59:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106f5e:	e9 94 f4 ff ff       	jmp    801063f7 <alltraps>

80106f63 <vector173>:
.globl vector173
vector173:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $173
80106f65:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106f6a:	e9 88 f4 ff ff       	jmp    801063f7 <alltraps>

80106f6f <vector174>:
.globl vector174
vector174:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $174
80106f71:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106f76:	e9 7c f4 ff ff       	jmp    801063f7 <alltraps>

80106f7b <vector175>:
.globl vector175
vector175:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $175
80106f7d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106f82:	e9 70 f4 ff ff       	jmp    801063f7 <alltraps>

80106f87 <vector176>:
.globl vector176
vector176:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $176
80106f89:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106f8e:	e9 64 f4 ff ff       	jmp    801063f7 <alltraps>

80106f93 <vector177>:
.globl vector177
vector177:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $177
80106f95:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106f9a:	e9 58 f4 ff ff       	jmp    801063f7 <alltraps>

80106f9f <vector178>:
.globl vector178
vector178:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $178
80106fa1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106fa6:	e9 4c f4 ff ff       	jmp    801063f7 <alltraps>

80106fab <vector179>:
.globl vector179
vector179:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $179
80106fad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106fb2:	e9 40 f4 ff ff       	jmp    801063f7 <alltraps>

80106fb7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $180
80106fb9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106fbe:	e9 34 f4 ff ff       	jmp    801063f7 <alltraps>

80106fc3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $181
80106fc5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106fca:	e9 28 f4 ff ff       	jmp    801063f7 <alltraps>

80106fcf <vector182>:
.globl vector182
vector182:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $182
80106fd1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106fd6:	e9 1c f4 ff ff       	jmp    801063f7 <alltraps>

80106fdb <vector183>:
.globl vector183
vector183:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $183
80106fdd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106fe2:	e9 10 f4 ff ff       	jmp    801063f7 <alltraps>

80106fe7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $184
80106fe9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106fee:	e9 04 f4 ff ff       	jmp    801063f7 <alltraps>

80106ff3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $185
80106ff5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106ffa:	e9 f8 f3 ff ff       	jmp    801063f7 <alltraps>

80106fff <vector186>:
.globl vector186
vector186:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $186
80107001:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107006:	e9 ec f3 ff ff       	jmp    801063f7 <alltraps>

8010700b <vector187>:
.globl vector187
vector187:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $187
8010700d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107012:	e9 e0 f3 ff ff       	jmp    801063f7 <alltraps>

80107017 <vector188>:
.globl vector188
vector188:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $188
80107019:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010701e:	e9 d4 f3 ff ff       	jmp    801063f7 <alltraps>

80107023 <vector189>:
.globl vector189
vector189:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $189
80107025:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010702a:	e9 c8 f3 ff ff       	jmp    801063f7 <alltraps>

8010702f <vector190>:
.globl vector190
vector190:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $190
80107031:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107036:	e9 bc f3 ff ff       	jmp    801063f7 <alltraps>

8010703b <vector191>:
.globl vector191
vector191:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $191
8010703d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107042:	e9 b0 f3 ff ff       	jmp    801063f7 <alltraps>

80107047 <vector192>:
.globl vector192
vector192:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $192
80107049:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010704e:	e9 a4 f3 ff ff       	jmp    801063f7 <alltraps>

80107053 <vector193>:
.globl vector193
vector193:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $193
80107055:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010705a:	e9 98 f3 ff ff       	jmp    801063f7 <alltraps>

8010705f <vector194>:
.globl vector194
vector194:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $194
80107061:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107066:	e9 8c f3 ff ff       	jmp    801063f7 <alltraps>

8010706b <vector195>:
.globl vector195
vector195:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $195
8010706d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107072:	e9 80 f3 ff ff       	jmp    801063f7 <alltraps>

80107077 <vector196>:
.globl vector196
vector196:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $196
80107079:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010707e:	e9 74 f3 ff ff       	jmp    801063f7 <alltraps>

80107083 <vector197>:
.globl vector197
vector197:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $197
80107085:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010708a:	e9 68 f3 ff ff       	jmp    801063f7 <alltraps>

8010708f <vector198>:
.globl vector198
vector198:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $198
80107091:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107096:	e9 5c f3 ff ff       	jmp    801063f7 <alltraps>

8010709b <vector199>:
.globl vector199
vector199:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $199
8010709d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801070a2:	e9 50 f3 ff ff       	jmp    801063f7 <alltraps>

801070a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $200
801070a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801070ae:	e9 44 f3 ff ff       	jmp    801063f7 <alltraps>

801070b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $201
801070b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801070ba:	e9 38 f3 ff ff       	jmp    801063f7 <alltraps>

801070bf <vector202>:
.globl vector202
vector202:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $202
801070c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801070c6:	e9 2c f3 ff ff       	jmp    801063f7 <alltraps>

801070cb <vector203>:
.globl vector203
vector203:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $203
801070cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801070d2:	e9 20 f3 ff ff       	jmp    801063f7 <alltraps>

801070d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $204
801070d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801070de:	e9 14 f3 ff ff       	jmp    801063f7 <alltraps>

801070e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $205
801070e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801070ea:	e9 08 f3 ff ff       	jmp    801063f7 <alltraps>

801070ef <vector206>:
.globl vector206
vector206:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $206
801070f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801070f6:	e9 fc f2 ff ff       	jmp    801063f7 <alltraps>

801070fb <vector207>:
.globl vector207
vector207:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $207
801070fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107102:	e9 f0 f2 ff ff       	jmp    801063f7 <alltraps>

80107107 <vector208>:
.globl vector208
vector208:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $208
80107109:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010710e:	e9 e4 f2 ff ff       	jmp    801063f7 <alltraps>

80107113 <vector209>:
.globl vector209
vector209:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $209
80107115:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010711a:	e9 d8 f2 ff ff       	jmp    801063f7 <alltraps>

8010711f <vector210>:
.globl vector210
vector210:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $210
80107121:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107126:	e9 cc f2 ff ff       	jmp    801063f7 <alltraps>

8010712b <vector211>:
.globl vector211
vector211:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $211
8010712d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107132:	e9 c0 f2 ff ff       	jmp    801063f7 <alltraps>

80107137 <vector212>:
.globl vector212
vector212:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $212
80107139:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010713e:	e9 b4 f2 ff ff       	jmp    801063f7 <alltraps>

80107143 <vector213>:
.globl vector213
vector213:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $213
80107145:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010714a:	e9 a8 f2 ff ff       	jmp    801063f7 <alltraps>

8010714f <vector214>:
.globl vector214
vector214:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $214
80107151:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107156:	e9 9c f2 ff ff       	jmp    801063f7 <alltraps>

8010715b <vector215>:
.globl vector215
vector215:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $215
8010715d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107162:	e9 90 f2 ff ff       	jmp    801063f7 <alltraps>

80107167 <vector216>:
.globl vector216
vector216:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $216
80107169:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010716e:	e9 84 f2 ff ff       	jmp    801063f7 <alltraps>

80107173 <vector217>:
.globl vector217
vector217:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $217
80107175:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010717a:	e9 78 f2 ff ff       	jmp    801063f7 <alltraps>

8010717f <vector218>:
.globl vector218
vector218:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $218
80107181:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107186:	e9 6c f2 ff ff       	jmp    801063f7 <alltraps>

8010718b <vector219>:
.globl vector219
vector219:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $219
8010718d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107192:	e9 60 f2 ff ff       	jmp    801063f7 <alltraps>

80107197 <vector220>:
.globl vector220
vector220:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $220
80107199:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010719e:	e9 54 f2 ff ff       	jmp    801063f7 <alltraps>

801071a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $221
801071a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801071aa:	e9 48 f2 ff ff       	jmp    801063f7 <alltraps>

801071af <vector222>:
.globl vector222
vector222:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $222
801071b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801071b6:	e9 3c f2 ff ff       	jmp    801063f7 <alltraps>

801071bb <vector223>:
.globl vector223
vector223:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $223
801071bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801071c2:	e9 30 f2 ff ff       	jmp    801063f7 <alltraps>

801071c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $224
801071c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801071ce:	e9 24 f2 ff ff       	jmp    801063f7 <alltraps>

801071d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $225
801071d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801071da:	e9 18 f2 ff ff       	jmp    801063f7 <alltraps>

801071df <vector226>:
.globl vector226
vector226:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $226
801071e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801071e6:	e9 0c f2 ff ff       	jmp    801063f7 <alltraps>

801071eb <vector227>:
.globl vector227
vector227:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $227
801071ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801071f2:	e9 00 f2 ff ff       	jmp    801063f7 <alltraps>

801071f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $228
801071f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801071fe:	e9 f4 f1 ff ff       	jmp    801063f7 <alltraps>

80107203 <vector229>:
.globl vector229
vector229:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $229
80107205:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010720a:	e9 e8 f1 ff ff       	jmp    801063f7 <alltraps>

8010720f <vector230>:
.globl vector230
vector230:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $230
80107211:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107216:	e9 dc f1 ff ff       	jmp    801063f7 <alltraps>

8010721b <vector231>:
.globl vector231
vector231:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $231
8010721d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107222:	e9 d0 f1 ff ff       	jmp    801063f7 <alltraps>

80107227 <vector232>:
.globl vector232
vector232:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $232
80107229:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010722e:	e9 c4 f1 ff ff       	jmp    801063f7 <alltraps>

80107233 <vector233>:
.globl vector233
vector233:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $233
80107235:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010723a:	e9 b8 f1 ff ff       	jmp    801063f7 <alltraps>

8010723f <vector234>:
.globl vector234
vector234:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $234
80107241:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107246:	e9 ac f1 ff ff       	jmp    801063f7 <alltraps>

8010724b <vector235>:
.globl vector235
vector235:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $235
8010724d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107252:	e9 a0 f1 ff ff       	jmp    801063f7 <alltraps>

80107257 <vector236>:
.globl vector236
vector236:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $236
80107259:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010725e:	e9 94 f1 ff ff       	jmp    801063f7 <alltraps>

80107263 <vector237>:
.globl vector237
vector237:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $237
80107265:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010726a:	e9 88 f1 ff ff       	jmp    801063f7 <alltraps>

8010726f <vector238>:
.globl vector238
vector238:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $238
80107271:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107276:	e9 7c f1 ff ff       	jmp    801063f7 <alltraps>

8010727b <vector239>:
.globl vector239
vector239:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $239
8010727d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107282:	e9 70 f1 ff ff       	jmp    801063f7 <alltraps>

80107287 <vector240>:
.globl vector240
vector240:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $240
80107289:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010728e:	e9 64 f1 ff ff       	jmp    801063f7 <alltraps>

80107293 <vector241>:
.globl vector241
vector241:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $241
80107295:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010729a:	e9 58 f1 ff ff       	jmp    801063f7 <alltraps>

8010729f <vector242>:
.globl vector242
vector242:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $242
801072a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801072a6:	e9 4c f1 ff ff       	jmp    801063f7 <alltraps>

801072ab <vector243>:
.globl vector243
vector243:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $243
801072ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801072b2:	e9 40 f1 ff ff       	jmp    801063f7 <alltraps>

801072b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $244
801072b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801072be:	e9 34 f1 ff ff       	jmp    801063f7 <alltraps>

801072c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $245
801072c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801072ca:	e9 28 f1 ff ff       	jmp    801063f7 <alltraps>

801072cf <vector246>:
.globl vector246
vector246:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $246
801072d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801072d6:	e9 1c f1 ff ff       	jmp    801063f7 <alltraps>

801072db <vector247>:
.globl vector247
vector247:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $247
801072dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801072e2:	e9 10 f1 ff ff       	jmp    801063f7 <alltraps>

801072e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $248
801072e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801072ee:	e9 04 f1 ff ff       	jmp    801063f7 <alltraps>

801072f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $249
801072f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801072fa:	e9 f8 f0 ff ff       	jmp    801063f7 <alltraps>

801072ff <vector250>:
.globl vector250
vector250:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $250
80107301:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107306:	e9 ec f0 ff ff       	jmp    801063f7 <alltraps>

8010730b <vector251>:
.globl vector251
vector251:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $251
8010730d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107312:	e9 e0 f0 ff ff       	jmp    801063f7 <alltraps>

80107317 <vector252>:
.globl vector252
vector252:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $252
80107319:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010731e:	e9 d4 f0 ff ff       	jmp    801063f7 <alltraps>

80107323 <vector253>:
.globl vector253
vector253:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $253
80107325:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010732a:	e9 c8 f0 ff ff       	jmp    801063f7 <alltraps>

8010732f <vector254>:
.globl vector254
vector254:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $254
80107331:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107336:	e9 bc f0 ff ff       	jmp    801063f7 <alltraps>

8010733b <vector255>:
.globl vector255
vector255:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $255
8010733d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107342:	e9 b0 f0 ff ff       	jmp    801063f7 <alltraps>
80107347:	66 90                	xchg   %ax,%ax
80107349:	66 90                	xchg   %ax,%ax
8010734b:	66 90                	xchg   %ax,%ax
8010734d:	66 90                	xchg   %ax,%ax
8010734f:	90                   	nop

80107350 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107356:	89 d3                	mov    %edx,%ebx
{
80107358:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010735a:	c1 eb 16             	shr    $0x16,%ebx
8010735d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107360:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107363:	8b 06                	mov    (%esi),%eax
80107365:	a8 01                	test   $0x1,%al
80107367:	74 27                	je     80107390 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107369:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010736e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107374:	c1 ef 0a             	shr    $0xa,%edi
}
80107377:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010737a:	89 fa                	mov    %edi,%edx
8010737c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107382:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107385:	5b                   	pop    %ebx
80107386:	5e                   	pop    %esi
80107387:	5f                   	pop    %edi
80107388:	5d                   	pop    %ebp
80107389:	c3                   	ret    
8010738a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107390:	85 c9                	test   %ecx,%ecx
80107392:	74 2c                	je     801073c0 <walkpgdir+0x70>
80107394:	e8 57 b1 ff ff       	call   801024f0 <kalloc>
80107399:	85 c0                	test   %eax,%eax
8010739b:	89 c3                	mov    %eax,%ebx
8010739d:	74 21                	je     801073c0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010739f:	83 ec 04             	sub    $0x4,%esp
801073a2:	68 00 10 00 00       	push   $0x1000
801073a7:	6a 00                	push   $0x0
801073a9:	50                   	push   %eax
801073aa:	e8 b1 dd ff ff       	call   80105160 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801073af:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073b5:	83 c4 10             	add    $0x10,%esp
801073b8:	83 c8 07             	or     $0x7,%eax
801073bb:	89 06                	mov    %eax,(%esi)
801073bd:	eb b5                	jmp    80107374 <walkpgdir+0x24>
801073bf:	90                   	nop
}
801073c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801073c3:	31 c0                	xor    %eax,%eax
}
801073c5:	5b                   	pop    %ebx
801073c6:	5e                   	pop    %esi
801073c7:	5f                   	pop    %edi
801073c8:	5d                   	pop    %ebp
801073c9:	c3                   	ret    
801073ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801073d6:	89 d3                	mov    %edx,%ebx
801073d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801073de:	83 ec 1c             	sub    $0x1c,%esp
801073e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801073e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801073e8:	8b 7d 08             	mov    0x8(%ebp),%edi
801073eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801073f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f6:	29 df                	sub    %ebx,%edi
801073f8:	83 c8 01             	or     $0x1,%eax
801073fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801073fe:	eb 15                	jmp    80107415 <mappages+0x45>
    if(*pte & PTE_P)
80107400:	f6 00 01             	testb  $0x1,(%eax)
80107403:	75 45                	jne    8010744a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107405:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107408:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010740b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010740d:	74 31                	je     80107440 <mappages+0x70>
      break;
    a += PGSIZE;
8010740f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107418:	b9 01 00 00 00       	mov    $0x1,%ecx
8010741d:	89 da                	mov    %ebx,%edx
8010741f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107422:	e8 29 ff ff ff       	call   80107350 <walkpgdir>
80107427:	85 c0                	test   %eax,%eax
80107429:	75 d5                	jne    80107400 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010742b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010742e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107433:	5b                   	pop    %ebx
80107434:	5e                   	pop    %esi
80107435:	5f                   	pop    %edi
80107436:	5d                   	pop    %ebp
80107437:	c3                   	ret    
80107438:	90                   	nop
80107439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107440:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107443:	31 c0                	xor    %eax,%eax
}
80107445:	5b                   	pop    %ebx
80107446:	5e                   	pop    %esi
80107447:	5f                   	pop    %edi
80107448:	5d                   	pop    %ebp
80107449:	c3                   	ret    
      panic("remap");
8010744a:	83 ec 0c             	sub    $0xc,%esp
8010744d:	68 18 86 10 80       	push   $0x80108618
80107452:	e8 39 8f ff ff       	call   80100390 <panic>
80107457:	89 f6                	mov    %esi,%esi
80107459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107460 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107466:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010746c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010746e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107474:	83 ec 1c             	sub    $0x1c,%esp
80107477:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010747a:	39 d3                	cmp    %edx,%ebx
8010747c:	73 66                	jae    801074e4 <deallocuvm.part.0+0x84>
8010747e:	89 d6                	mov    %edx,%esi
80107480:	eb 3d                	jmp    801074bf <deallocuvm.part.0+0x5f>
80107482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107488:	8b 10                	mov    (%eax),%edx
8010748a:	f6 c2 01             	test   $0x1,%dl
8010748d:	74 26                	je     801074b5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010748f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107495:	74 58                	je     801074ef <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107497:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010749a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801074a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801074a3:	52                   	push   %edx
801074a4:	e8 97 ae ff ff       	call   80102340 <kfree>
      *pte = 0;
801074a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074ac:	83 c4 10             	add    $0x10,%esp
801074af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801074b5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074bb:	39 f3                	cmp    %esi,%ebx
801074bd:	73 25                	jae    801074e4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801074bf:	31 c9                	xor    %ecx,%ecx
801074c1:	89 da                	mov    %ebx,%edx
801074c3:	89 f8                	mov    %edi,%eax
801074c5:	e8 86 fe ff ff       	call   80107350 <walkpgdir>
    if(!pte)
801074ca:	85 c0                	test   %eax,%eax
801074cc:	75 ba                	jne    80107488 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801074ce:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801074d4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801074da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074e0:	39 f3                	cmp    %esi,%ebx
801074e2:	72 db                	jb     801074bf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801074e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ea:	5b                   	pop    %ebx
801074eb:	5e                   	pop    %esi
801074ec:	5f                   	pop    %edi
801074ed:	5d                   	pop    %ebp
801074ee:	c3                   	ret    
        panic("kfree");
801074ef:	83 ec 0c             	sub    $0xc,%esp
801074f2:	68 06 7f 10 80       	push   $0x80107f06
801074f7:	e8 94 8e ff ff       	call   80100390 <panic>
801074fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107500 <seginit>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107506:	e8 e5 c3 ff ff       	call   801038f0 <cpuid>
8010750b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
80107511:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107516:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010751a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107521:	ff 00 00 
80107524:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010752b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010752e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107535:	ff 00 00 
80107538:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
8010753f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107542:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107549:	ff 00 00 
8010754c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107553:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107556:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010755d:	ff 00 00 
80107560:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107567:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010756a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010756f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107573:	c1 e8 10             	shr    $0x10,%eax
80107576:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010757a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010757d:	0f 01 10             	lgdtl  (%eax)
}
80107580:	c9                   	leave  
80107581:	c3                   	ret    
80107582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107590 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107590:	a1 24 43 12 80       	mov    0x80124324,%eax
{
80107595:	55                   	push   %ebp
80107596:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107598:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010759d:	0f 22 d8             	mov    %eax,%cr3
}
801075a0:	5d                   	pop    %ebp
801075a1:	c3                   	ret    
801075a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075b0 <switchuvm>:
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
801075b6:	83 ec 1c             	sub    $0x1c,%esp
801075b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801075bc:	85 db                	test   %ebx,%ebx
801075be:	0f 84 d7 00 00 00    	je     8010769b <switchuvm+0xeb>
  if(p->mainThread->tkstack == 0)
801075c4:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
801075ca:	8b 40 04             	mov    0x4(%eax),%eax
801075cd:	85 c0                	test   %eax,%eax
801075cf:	0f 84 e0 00 00 00    	je     801076b5 <switchuvm+0x105>
  if(p->pgdir == 0)
801075d5:	8b 43 04             	mov    0x4(%ebx),%eax
801075d8:	85 c0                	test   %eax,%eax
801075da:	0f 84 c8 00 00 00    	je     801076a8 <switchuvm+0xf8>
  pushcli();
801075e0:	e8 8b d9 ff ff       	call   80104f70 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801075e5:	e8 86 c2 ff ff       	call   80103870 <mycpu>
801075ea:	89 c6                	mov    %eax,%esi
801075ec:	e8 7f c2 ff ff       	call   80103870 <mycpu>
801075f1:	89 c7                	mov    %eax,%edi
801075f3:	e8 78 c2 ff ff       	call   80103870 <mycpu>
801075f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075fb:	83 c7 08             	add    $0x8,%edi
801075fe:	e8 6d c2 ff ff       	call   80103870 <mycpu>
80107603:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107606:	83 c0 08             	add    $0x8,%eax
80107609:	ba 67 00 00 00       	mov    $0x67,%edx
8010760e:	c1 e8 18             	shr    $0x18,%eax
80107611:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107618:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010761f:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107625:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010762a:	83 c1 08             	add    $0x8,%ecx
8010762d:	c1 e9 10             	shr    $0x10,%ecx
80107630:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107636:	b9 99 40 00 00       	mov    $0x4099,%ecx
8010763b:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107642:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107647:	e8 24 c2 ff ff       	call   80103870 <mycpu>
8010764c:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107653:	e8 18 c2 ff ff       	call   80103870 <mycpu>
80107658:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->mainThread->tkstack + KSTACKSIZE;
8010765c:	8b 83 b4 03 00 00    	mov    0x3b4(%ebx),%eax
80107662:	8b 70 04             	mov    0x4(%eax),%esi
80107665:	e8 06 c2 ff ff       	call   80103870 <mycpu>
8010766a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107670:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107673:	e8 f8 c1 ff ff       	call   80103870 <mycpu>
80107678:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010767c:	b8 28 00 00 00       	mov    $0x28,%eax
80107681:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107684:	8b 43 04             	mov    0x4(%ebx),%eax
80107687:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010768c:	0f 22 d8             	mov    %eax,%cr3
}
8010768f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107692:	5b                   	pop    %ebx
80107693:	5e                   	pop    %esi
80107694:	5f                   	pop    %edi
80107695:	5d                   	pop    %ebp
  popcli();
80107696:	e9 15 d9 ff ff       	jmp    80104fb0 <popcli>
    panic("switchuvm: no process");
8010769b:	83 ec 0c             	sub    $0xc,%esp
8010769e:	68 1e 86 10 80       	push   $0x8010861e
801076a3:	e8 e8 8c ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801076a8:	83 ec 0c             	sub    $0xc,%esp
801076ab:	68 49 86 10 80       	push   $0x80108649
801076b0:	e8 db 8c ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801076b5:	83 ec 0c             	sub    $0xc,%esp
801076b8:	68 34 86 10 80       	push   $0x80108634
801076bd:	e8 ce 8c ff ff       	call   80100390 <panic>
801076c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076d0 <inituvm>:
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
801076d6:	83 ec 1c             	sub    $0x1c,%esp
801076d9:	8b 75 10             	mov    0x10(%ebp),%esi
801076dc:	8b 45 08             	mov    0x8(%ebp),%eax
801076df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801076e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801076e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801076eb:	77 49                	ja     80107736 <inituvm+0x66>
  mem = kalloc();
801076ed:	e8 fe ad ff ff       	call   801024f0 <kalloc>
  memset(mem, 0, PGSIZE);
801076f2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801076f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801076f7:	68 00 10 00 00       	push   $0x1000
801076fc:	6a 00                	push   $0x0
801076fe:	50                   	push   %eax
801076ff:	e8 5c da ff ff       	call   80105160 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107704:	58                   	pop    %eax
80107705:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010770b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107710:	5a                   	pop    %edx
80107711:	6a 06                	push   $0x6
80107713:	50                   	push   %eax
80107714:	31 d2                	xor    %edx,%edx
80107716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107719:	e8 b2 fc ff ff       	call   801073d0 <mappages>
  memmove(mem, init, sz);
8010771e:	89 75 10             	mov    %esi,0x10(%ebp)
80107721:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107724:	83 c4 10             	add    $0x10,%esp
80107727:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010772a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010772d:	5b                   	pop    %ebx
8010772e:	5e                   	pop    %esi
8010772f:	5f                   	pop    %edi
80107730:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107731:	e9 da da ff ff       	jmp    80105210 <memmove>
    panic("inituvm: more than a page");
80107736:	83 ec 0c             	sub    $0xc,%esp
80107739:	68 5d 86 10 80       	push   $0x8010865d
8010773e:	e8 4d 8c ff ff       	call   80100390 <panic>
80107743:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107750 <loaduvm>:
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	56                   	push   %esi
80107755:	53                   	push   %ebx
80107756:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107759:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107760:	0f 85 91 00 00 00    	jne    801077f7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107766:	8b 75 18             	mov    0x18(%ebp),%esi
80107769:	31 db                	xor    %ebx,%ebx
8010776b:	85 f6                	test   %esi,%esi
8010776d:	75 1a                	jne    80107789 <loaduvm+0x39>
8010776f:	eb 6f                	jmp    801077e0 <loaduvm+0x90>
80107771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107778:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010777e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107784:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107787:	76 57                	jbe    801077e0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107789:	8b 55 0c             	mov    0xc(%ebp),%edx
8010778c:	8b 45 08             	mov    0x8(%ebp),%eax
8010778f:	31 c9                	xor    %ecx,%ecx
80107791:	01 da                	add    %ebx,%edx
80107793:	e8 b8 fb ff ff       	call   80107350 <walkpgdir>
80107798:	85 c0                	test   %eax,%eax
8010779a:	74 4e                	je     801077ea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010779c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010779e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801077a1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801077a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801077ab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801077b1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801077b4:	01 d9                	add    %ebx,%ecx
801077b6:	05 00 00 00 80       	add    $0x80000000,%eax
801077bb:	57                   	push   %edi
801077bc:	51                   	push   %ecx
801077bd:	50                   	push   %eax
801077be:	ff 75 10             	pushl  0x10(%ebp)
801077c1:	e8 ca a1 ff ff       	call   80101990 <readi>
801077c6:	83 c4 10             	add    $0x10,%esp
801077c9:	39 f8                	cmp    %edi,%eax
801077cb:	74 ab                	je     80107778 <loaduvm+0x28>
}
801077cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5f                   	pop    %edi
801077d8:	5d                   	pop    %ebp
801077d9:	c3                   	ret    
801077da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077e3:	31 c0                	xor    %eax,%eax
}
801077e5:	5b                   	pop    %ebx
801077e6:	5e                   	pop    %esi
801077e7:	5f                   	pop    %edi
801077e8:	5d                   	pop    %ebp
801077e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801077ea:	83 ec 0c             	sub    $0xc,%esp
801077ed:	68 77 86 10 80       	push   $0x80108677
801077f2:	e8 99 8b ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801077f7:	83 ec 0c             	sub    $0xc,%esp
801077fa:	68 18 87 10 80       	push   $0x80108718
801077ff:	e8 8c 8b ff ff       	call   80100390 <panic>
80107804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010780a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107810 <allocuvm>:
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	57                   	push   %edi
80107814:	56                   	push   %esi
80107815:	53                   	push   %ebx
80107816:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107819:	8b 7d 10             	mov    0x10(%ebp),%edi
8010781c:	85 ff                	test   %edi,%edi
8010781e:	0f 88 8e 00 00 00    	js     801078b2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107824:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107827:	0f 82 93 00 00 00    	jb     801078c0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010782d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107830:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107836:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010783c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010783f:	0f 86 7e 00 00 00    	jbe    801078c3 <allocuvm+0xb3>
80107845:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107848:	8b 7d 08             	mov    0x8(%ebp),%edi
8010784b:	eb 42                	jmp    8010788f <allocuvm+0x7f>
8010784d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107850:	83 ec 04             	sub    $0x4,%esp
80107853:	68 00 10 00 00       	push   $0x1000
80107858:	6a 00                	push   $0x0
8010785a:	50                   	push   %eax
8010785b:	e8 00 d9 ff ff       	call   80105160 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107860:	58                   	pop    %eax
80107861:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107867:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010786c:	5a                   	pop    %edx
8010786d:	6a 06                	push   $0x6
8010786f:	50                   	push   %eax
80107870:	89 da                	mov    %ebx,%edx
80107872:	89 f8                	mov    %edi,%eax
80107874:	e8 57 fb ff ff       	call   801073d0 <mappages>
80107879:	83 c4 10             	add    $0x10,%esp
8010787c:	85 c0                	test   %eax,%eax
8010787e:	78 50                	js     801078d0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107880:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107886:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107889:	0f 86 81 00 00 00    	jbe    80107910 <allocuvm+0x100>
    mem = kalloc();
8010788f:	e8 5c ac ff ff       	call   801024f0 <kalloc>
    if(mem == 0){
80107894:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107896:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107898:	75 b6                	jne    80107850 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010789a:	83 ec 0c             	sub    $0xc,%esp
8010789d:	68 95 86 10 80       	push   $0x80108695
801078a2:	e8 b9 8d ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801078a7:	83 c4 10             	add    $0x10,%esp
801078aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ad:	39 45 10             	cmp    %eax,0x10(%ebp)
801078b0:	77 6e                	ja     80107920 <allocuvm+0x110>
}
801078b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801078b5:	31 ff                	xor    %edi,%edi
}
801078b7:	89 f8                	mov    %edi,%eax
801078b9:	5b                   	pop    %ebx
801078ba:	5e                   	pop    %esi
801078bb:	5f                   	pop    %edi
801078bc:	5d                   	pop    %ebp
801078bd:	c3                   	ret    
801078be:	66 90                	xchg   %ax,%ax
    return oldsz;
801078c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801078c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078c6:	89 f8                	mov    %edi,%eax
801078c8:	5b                   	pop    %ebx
801078c9:	5e                   	pop    %esi
801078ca:	5f                   	pop    %edi
801078cb:	5d                   	pop    %ebp
801078cc:	c3                   	ret    
801078cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801078d0:	83 ec 0c             	sub    $0xc,%esp
801078d3:	68 ad 86 10 80       	push   $0x801086ad
801078d8:	e8 83 8d ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801078dd:	83 c4 10             	add    $0x10,%esp
801078e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801078e3:	39 45 10             	cmp    %eax,0x10(%ebp)
801078e6:	76 0d                	jbe    801078f5 <allocuvm+0xe5>
801078e8:	89 c1                	mov    %eax,%ecx
801078ea:	8b 55 10             	mov    0x10(%ebp),%edx
801078ed:	8b 45 08             	mov    0x8(%ebp),%eax
801078f0:	e8 6b fb ff ff       	call   80107460 <deallocuvm.part.0>
      kfree(mem);
801078f5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801078f8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801078fa:	56                   	push   %esi
801078fb:	e8 40 aa ff ff       	call   80102340 <kfree>
      return 0;
80107900:	83 c4 10             	add    $0x10,%esp
}
80107903:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107906:	89 f8                	mov    %edi,%eax
80107908:	5b                   	pop    %ebx
80107909:	5e                   	pop    %esi
8010790a:	5f                   	pop    %edi
8010790b:	5d                   	pop    %ebp
8010790c:	c3                   	ret    
8010790d:	8d 76 00             	lea    0x0(%esi),%esi
80107910:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107913:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107916:	5b                   	pop    %ebx
80107917:	89 f8                	mov    %edi,%eax
80107919:	5e                   	pop    %esi
8010791a:	5f                   	pop    %edi
8010791b:	5d                   	pop    %ebp
8010791c:	c3                   	ret    
8010791d:	8d 76 00             	lea    0x0(%esi),%esi
80107920:	89 c1                	mov    %eax,%ecx
80107922:	8b 55 10             	mov    0x10(%ebp),%edx
80107925:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107928:	31 ff                	xor    %edi,%edi
8010792a:	e8 31 fb ff ff       	call   80107460 <deallocuvm.part.0>
8010792f:	eb 92                	jmp    801078c3 <allocuvm+0xb3>
80107931:	eb 0d                	jmp    80107940 <deallocuvm>
80107933:	90                   	nop
80107934:	90                   	nop
80107935:	90                   	nop
80107936:	90                   	nop
80107937:	90                   	nop
80107938:	90                   	nop
80107939:	90                   	nop
8010793a:	90                   	nop
8010793b:	90                   	nop
8010793c:	90                   	nop
8010793d:	90                   	nop
8010793e:	90                   	nop
8010793f:	90                   	nop

80107940 <deallocuvm>:
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	8b 55 0c             	mov    0xc(%ebp),%edx
80107946:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107949:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010794c:	39 d1                	cmp    %edx,%ecx
8010794e:	73 10                	jae    80107960 <deallocuvm+0x20>
}
80107950:	5d                   	pop    %ebp
80107951:	e9 0a fb ff ff       	jmp    80107460 <deallocuvm.part.0>
80107956:	8d 76 00             	lea    0x0(%esi),%esi
80107959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107960:	89 d0                	mov    %edx,%eax
80107962:	5d                   	pop    %ebp
80107963:	c3                   	ret    
80107964:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010796a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107970 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	57                   	push   %edi
80107974:	56                   	push   %esi
80107975:	53                   	push   %ebx
80107976:	83 ec 0c             	sub    $0xc,%esp
80107979:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010797c:	85 f6                	test   %esi,%esi
8010797e:	74 59                	je     801079d9 <freevm+0x69>
80107980:	31 c9                	xor    %ecx,%ecx
80107982:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107987:	89 f0                	mov    %esi,%eax
80107989:	e8 d2 fa ff ff       	call   80107460 <deallocuvm.part.0>
8010798e:	89 f3                	mov    %esi,%ebx
80107990:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107996:	eb 0f                	jmp    801079a7 <freevm+0x37>
80107998:	90                   	nop
80107999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801079a3:	39 fb                	cmp    %edi,%ebx
801079a5:	74 23                	je     801079ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801079a7:	8b 03                	mov    (%ebx),%eax
801079a9:	a8 01                	test   $0x1,%al
801079ab:	74 f3                	je     801079a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801079ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801079b2:	83 ec 0c             	sub    $0xc,%esp
801079b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801079b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801079bd:	50                   	push   %eax
801079be:	e8 7d a9 ff ff       	call   80102340 <kfree>
801079c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801079c6:	39 fb                	cmp    %edi,%ebx
801079c8:	75 dd                	jne    801079a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801079ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801079cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079d0:	5b                   	pop    %ebx
801079d1:	5e                   	pop    %esi
801079d2:	5f                   	pop    %edi
801079d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801079d4:	e9 67 a9 ff ff       	jmp    80102340 <kfree>
    panic("freevm: no pgdir");
801079d9:	83 ec 0c             	sub    $0xc,%esp
801079dc:	68 c9 86 10 80       	push   $0x801086c9
801079e1:	e8 aa 89 ff ff       	call   80100390 <panic>
801079e6:	8d 76 00             	lea    0x0(%esi),%esi
801079e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079f0 <setupkvm>:
{
801079f0:	55                   	push   %ebp
801079f1:	89 e5                	mov    %esp,%ebp
801079f3:	56                   	push   %esi
801079f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801079f5:	e8 f6 aa ff ff       	call   801024f0 <kalloc>
801079fa:	85 c0                	test   %eax,%eax
801079fc:	89 c6                	mov    %eax,%esi
801079fe:	74 42                	je     80107a42 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107a00:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a03:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107a08:	68 00 10 00 00       	push   $0x1000
80107a0d:	6a 00                	push   $0x0
80107a0f:	50                   	push   %eax
80107a10:	e8 4b d7 ff ff       	call   80105160 <memset>
80107a15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107a18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a1b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107a1e:	83 ec 08             	sub    $0x8,%esp
80107a21:	8b 13                	mov    (%ebx),%edx
80107a23:	ff 73 0c             	pushl  0xc(%ebx)
80107a26:	50                   	push   %eax
80107a27:	29 c1                	sub    %eax,%ecx
80107a29:	89 f0                	mov    %esi,%eax
80107a2b:	e8 a0 f9 ff ff       	call   801073d0 <mappages>
80107a30:	83 c4 10             	add    $0x10,%esp
80107a33:	85 c0                	test   %eax,%eax
80107a35:	78 19                	js     80107a50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a37:	83 c3 10             	add    $0x10,%ebx
80107a3a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107a40:	75 d6                	jne    80107a18 <setupkvm+0x28>
}
80107a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a45:	89 f0                	mov    %esi,%eax
80107a47:	5b                   	pop    %ebx
80107a48:	5e                   	pop    %esi
80107a49:	5d                   	pop    %ebp
80107a4a:	c3                   	ret    
80107a4b:	90                   	nop
80107a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107a50:	83 ec 0c             	sub    $0xc,%esp
80107a53:	56                   	push   %esi
      return 0;
80107a54:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107a56:	e8 15 ff ff ff       	call   80107970 <freevm>
      return 0;
80107a5b:	83 c4 10             	add    $0x10,%esp
}
80107a5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a61:	89 f0                	mov    %esi,%eax
80107a63:	5b                   	pop    %ebx
80107a64:	5e                   	pop    %esi
80107a65:	5d                   	pop    %ebp
80107a66:	c3                   	ret    
80107a67:	89 f6                	mov    %esi,%esi
80107a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a70 <kvmalloc>:
{
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107a76:	e8 75 ff ff ff       	call   801079f0 <setupkvm>
80107a7b:	a3 24 43 12 80       	mov    %eax,0x80124324
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a80:	05 00 00 00 80       	add    $0x80000000,%eax
80107a85:	0f 22 d8             	mov    %eax,%cr3
}
80107a88:	c9                   	leave  
80107a89:	c3                   	ret    
80107a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107a90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a91:	31 c9                	xor    %ecx,%ecx
{
80107a93:	89 e5                	mov    %esp,%ebp
80107a95:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107a98:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80107a9e:	e8 ad f8 ff ff       	call   80107350 <walkpgdir>
  if(pte == 0)
80107aa3:	85 c0                	test   %eax,%eax
80107aa5:	74 05                	je     80107aac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107aa7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107aaa:	c9                   	leave  
80107aab:	c3                   	ret    
    panic("clearpteu");
80107aac:	83 ec 0c             	sub    $0xc,%esp
80107aaf:	68 da 86 10 80       	push   $0x801086da
80107ab4:	e8 d7 88 ff ff       	call   80100390 <panic>
80107ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ac0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	57                   	push   %edi
80107ac4:	56                   	push   %esi
80107ac5:	53                   	push   %ebx
80107ac6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107ac9:	e8 22 ff ff ff       	call   801079f0 <setupkvm>
80107ace:	85 c0                	test   %eax,%eax
80107ad0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ad3:	0f 84 9f 00 00 00    	je     80107b78 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ad9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107adc:	85 c9                	test   %ecx,%ecx
80107ade:	0f 84 94 00 00 00    	je     80107b78 <copyuvm+0xb8>
80107ae4:	31 ff                	xor    %edi,%edi
80107ae6:	eb 4a                	jmp    80107b32 <copyuvm+0x72>
80107ae8:	90                   	nop
80107ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107af0:	83 ec 04             	sub    $0x4,%esp
80107af3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107af9:	68 00 10 00 00       	push   $0x1000
80107afe:	53                   	push   %ebx
80107aff:	50                   	push   %eax
80107b00:	e8 0b d7 ff ff       	call   80105210 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107b05:	58                   	pop    %eax
80107b06:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107b0c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b11:	5a                   	pop    %edx
80107b12:	ff 75 e4             	pushl  -0x1c(%ebp)
80107b15:	50                   	push   %eax
80107b16:	89 fa                	mov    %edi,%edx
80107b18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b1b:	e8 b0 f8 ff ff       	call   801073d0 <mappages>
80107b20:	83 c4 10             	add    $0x10,%esp
80107b23:	85 c0                	test   %eax,%eax
80107b25:	78 61                	js     80107b88 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107b27:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107b2d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107b30:	76 46                	jbe    80107b78 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107b32:	8b 45 08             	mov    0x8(%ebp),%eax
80107b35:	31 c9                	xor    %ecx,%ecx
80107b37:	89 fa                	mov    %edi,%edx
80107b39:	e8 12 f8 ff ff       	call   80107350 <walkpgdir>
80107b3e:	85 c0                	test   %eax,%eax
80107b40:	74 61                	je     80107ba3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107b42:	8b 00                	mov    (%eax),%eax
80107b44:	a8 01                	test   $0x1,%al
80107b46:	74 4e                	je     80107b96 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107b48:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107b4a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107b4f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107b58:	e8 93 a9 ff ff       	call   801024f0 <kalloc>
80107b5d:	85 c0                	test   %eax,%eax
80107b5f:	89 c6                	mov    %eax,%esi
80107b61:	75 8d                	jne    80107af0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107b63:	83 ec 0c             	sub    $0xc,%esp
80107b66:	ff 75 e0             	pushl  -0x20(%ebp)
80107b69:	e8 02 fe ff ff       	call   80107970 <freevm>
  return 0;
80107b6e:	83 c4 10             	add    $0x10,%esp
80107b71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107b78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b7e:	5b                   	pop    %ebx
80107b7f:	5e                   	pop    %esi
80107b80:	5f                   	pop    %edi
80107b81:	5d                   	pop    %ebp
80107b82:	c3                   	ret    
80107b83:	90                   	nop
80107b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107b88:	83 ec 0c             	sub    $0xc,%esp
80107b8b:	56                   	push   %esi
80107b8c:	e8 af a7 ff ff       	call   80102340 <kfree>
      goto bad;
80107b91:	83 c4 10             	add    $0x10,%esp
80107b94:	eb cd                	jmp    80107b63 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107b96:	83 ec 0c             	sub    $0xc,%esp
80107b99:	68 fe 86 10 80       	push   $0x801086fe
80107b9e:	e8 ed 87 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107ba3:	83 ec 0c             	sub    $0xc,%esp
80107ba6:	68 e4 86 10 80       	push   $0x801086e4
80107bab:	e8 e0 87 ff ff       	call   80100390 <panic>

80107bb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107bb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107bb1:	31 c9                	xor    %ecx,%ecx
{
80107bb3:	89 e5                	mov    %esp,%ebp
80107bb5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bbe:	e8 8d f7 ff ff       	call   80107350 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107bc3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107bc5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107bc6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107bc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107bcd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107bd0:	05 00 00 00 80       	add    $0x80000000,%eax
80107bd5:	83 fa 05             	cmp    $0x5,%edx
80107bd8:	ba 00 00 00 00       	mov    $0x0,%edx
80107bdd:	0f 45 c2             	cmovne %edx,%eax
}
80107be0:	c3                   	ret    
80107be1:	eb 0d                	jmp    80107bf0 <copyout>
80107be3:	90                   	nop
80107be4:	90                   	nop
80107be5:	90                   	nop
80107be6:	90                   	nop
80107be7:	90                   	nop
80107be8:	90                   	nop
80107be9:	90                   	nop
80107bea:	90                   	nop
80107beb:	90                   	nop
80107bec:	90                   	nop
80107bed:	90                   	nop
80107bee:	90                   	nop
80107bef:	90                   	nop

80107bf0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107bf0:	55                   	push   %ebp
80107bf1:	89 e5                	mov    %esp,%ebp
80107bf3:	57                   	push   %edi
80107bf4:	56                   	push   %esi
80107bf5:	53                   	push   %ebx
80107bf6:	83 ec 1c             	sub    $0x1c,%esp
80107bf9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107c02:	85 db                	test   %ebx,%ebx
80107c04:	75 40                	jne    80107c46 <copyout+0x56>
80107c06:	eb 70                	jmp    80107c78 <copyout+0x88>
80107c08:	90                   	nop
80107c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107c10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c13:	89 f1                	mov    %esi,%ecx
80107c15:	29 d1                	sub    %edx,%ecx
80107c17:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107c1d:	39 d9                	cmp    %ebx,%ecx
80107c1f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107c22:	29 f2                	sub    %esi,%edx
80107c24:	83 ec 04             	sub    $0x4,%esp
80107c27:	01 d0                	add    %edx,%eax
80107c29:	51                   	push   %ecx
80107c2a:	57                   	push   %edi
80107c2b:	50                   	push   %eax
80107c2c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107c2f:	e8 dc d5 ff ff       	call   80105210 <memmove>
    len -= n;
    buf += n;
80107c34:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107c37:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107c3a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107c40:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107c42:	29 cb                	sub    %ecx,%ebx
80107c44:	74 32                	je     80107c78 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107c46:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107c48:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107c4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107c4e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107c54:	56                   	push   %esi
80107c55:	ff 75 08             	pushl  0x8(%ebp)
80107c58:	e8 53 ff ff ff       	call   80107bb0 <uva2ka>
    if(pa0 == 0)
80107c5d:	83 c4 10             	add    $0x10,%esp
80107c60:	85 c0                	test   %eax,%eax
80107c62:	75 ac                	jne    80107c10 <copyout+0x20>
  }
  return 0;
}
80107c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c6c:	5b                   	pop    %ebx
80107c6d:	5e                   	pop    %esi
80107c6e:	5f                   	pop    %edi
80107c6f:	5d                   	pop    %ebp
80107c70:	c3                   	ret    
80107c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c7b:	31 c0                	xor    %eax,%eax
}
80107c7d:	5b                   	pop    %ebx
80107c7e:	5e                   	pop    %esi
80107c7f:	5f                   	pop    %edi
80107c80:	5d                   	pop    %ebp
80107c81:	c3                   	ret    
