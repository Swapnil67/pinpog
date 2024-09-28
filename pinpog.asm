mov ah, 0x00
; VGA mode 0x13 gives you 320x200 256 colors
mov al, 0x13
int 0x10

mov ax, 0xA000
mov es, ax  

mov bx, 0
loop:
  mov BYTE [es:bx], 0x0C
  inc bx
  cmp bx, 64000
  jb loop


jmp $                           ; jump to the current address (i.e. forever)

;
; Padding and magic BIOS number
;

times 510 - ($-$$) db 0         ; Pad the sector out with zeros
dw 0xaa55                       ; Last two bytes form the magic number
                                ; so BIOS knows we are a boot sector