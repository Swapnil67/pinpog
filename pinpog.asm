org 0x7c00
	%define ROW 70
	%define WIDTH 320
	%define HEIGHT 200
	
	%define BALL_WIDTH 10
	%define BALL_HEIGHT 10



;; 	mov ah, 0x0e
;; 	mov bx, 0
;; loop2:
;; 	mov al, BYTE [hello + bx]
;; 	cmp al, 0
;; 	je loop_end2
;; 	int 0x10
;; 	inc bx
;; 	jmp loop2
;; loop_end2:
	
;; 	jmp $			
	
	mov ah, 0x00
	
				; VGA mode 0x13 gives you 320x200 256 colors
	MOV al, 0x13
	INT 0x10
	
	MOV ax,0xA000
	MOV es, ax

	mov word [ball_x], 0
	mov word [ball_y], 0
	mov word [ball_dx], 1
	mov word [ball_dy], 1

main_loop:
	mov ax, [ball_x]
	add ax, [ball_dx]
	mov [ball_x], ax

	mov ax, [ball_y]
	add ax, [ball_dy]
	mov [ball_y], ax

	mov ch, 0x0A
	call draw_ball
	call clear_screen
	
	jmp main_loop
				; jump to the current address (i.e. forever)

clear_screen:
	ret
	
  ;; hello: db "HELLO WORLD", 0
	
draw_ball:
	;; cx - color
	;; ax - row
	;; bx - column
	mov word [i], 0
draw_ball_i:			;row
	mov word [j], 0 
draw_ball_j:			;col
	mov ax, WIDTH
	mov bx, [i]
	;; Add position offset
	add bx, [ball_x]
	mul bx
	mov bx, ax
	add bx, [j]
	;; Add position offset
	add bx, [ball_y]
	mov BYTE [es: bx], ch
	
	inc word [j]
	cmp word [j], BALL_WIDTH
	jb draw_ball_j

	inc word [i]
	cmp word [i], BALL_HEIGHT
	jb draw_ball_i
	RET

i:	dw 0
j:	dw 0
 
ball_x:	dw 0
ball_y:	dw 0
ball_dx:	dw 0
ball_dy:	dw 0
	
;
; PADDING AND MAGIC BIOS NUMBER
;

	TIMES 510 - ($-$$) DB 0	; PAD THE SECTOR OUT WITH ZEROS
	DW 0XAA55		; LAST TWO BYTES FORM THE MAGIC NUMBER
                                ; SO BIOS KNOWS WE ARE A MOVMOV
