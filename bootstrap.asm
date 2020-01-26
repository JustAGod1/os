BITS 16
extern kmain

; code start

xor bx, bx
mov ds, bx
mov ss, bx
mov es, bx
;mov bx, 0x500
mov sp, bx

mov si, HELLO_MSG
call print
call read_tail
call enter_graphic_mode

call enter_pmode


jmp $


print:
  pusha

  print_loop:
    mov al, [si]
    and al, al
    jnz print_char
    popa
    ret
  print_char:
    mov ah, 0xE
    int 0x10
    inc si
    jmp print_loop

draw_line:
  pusha
  mov bx, 0xA000
  mov es, bx
  mov bx, 30
  mov dl, 4

  line_loop:
    mov [es:bx], dl
    dec bx
    and bx, bx
    jne line_loop

  popa
  ret

enter_graphic_mode:
  pusha
  mov ah, 0x0
  mov al, 0x13
  int 0x10
  popa
  ret

read_tail:
  clc
  pusha
  mov ah, 0x2
  mov al, 1
  mov ch, 0
  mov cl, 2
  mov dh, 0
  xor bx, bx
  mov es, bx
  mov bx, 0x7C00 + 512

  int 0x13
  jc disk_error
  mov si, DISK_SUCCESS_MSG
  call print
  popa
  ret

disk_error:
  mov si, DISK_ERR_MSG
  call print
  jmp $

enter_pmode:
  cli
  lgdt [gdtr]
  mov eax, cr0
  or eax, 1
  mov cr0, eax

  jmp 0x10:kmain

gdt:
; null descriptor
  dd 0x0 
  dd 0x0 
; Data descriptor
  dw 0xffff       ; Limit
  dw 0x0          ; Base
  db 0x0          ; Base
  db 0b10010010   ; Access
  db 0b01001111   ; Flags
  db 0x0          ; Base
; Code descriptor
  dw 0xffff       ; Limit
  dw 0x0          ; Base
  db 0x0          ; Base
  db 0b10011010   ; Access
  db 0b01001111   ; Flags
  db 0x0          ; Base
gdt_end:

gdtr:
  dw gdt_end - gdt
  dd gdt

HELLO_MSG: db 'Starting...', 0xA, 0xD, 0
DISK_ERR_MSG: db 'Error while reading from disk', 0xA, 0xD, 0
DISK_SUCCESS_MSG: db 'Disk data has been successfully read', 0xA, 0xD, 0

times (510 - ($ - $$)) db 0
db 0x55
db 0xAA
