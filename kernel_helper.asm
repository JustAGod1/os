[BITS 32]

;void __cdecl fetch_vga_fonts(char *buffer);
fetch_vga_fonts:
  pusha 

  mov edi, [esp]
  
  mov dx, 0x3ce
  mov ax, 5
  out dx, ax

  ;map VGA memory to 0A0000h
  mov ax, 0406h
  out dx, ax

  ;set bitplane 2
  mov dx, 0x3c4
  mov ax, 0x402
  out dx, ax

  ;clear even/odd mode (the other way, don't ask why)
  mov ax, 0x604
  out dx, ax

  ;copy charmap
  mov esi, 0xA0000
  mov ecx, 256

  ;copy 16 bytes to bitmap
  read_loop:	
    movsd
    movsd
    movsd
    movsd

    ;skip another 16 bytes
    add esi, 16
    loop read_loop

  ;restore VGA state to normal operation
  mov ax, 0x302
  out dx, ax
  mov ax, 0x204
  out dx, ax
  mov dx, 0x3ce
  mov ax, 0x1005
  out dx, ax
  mov ax, 0xE06
  out dx, ax

  popa 
  ret
