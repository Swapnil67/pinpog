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
	;; VGA mode 0x13
	;; 320 x 200 256 colors
	MOV al, 0x13
	INT 0x10

	;; Point int 0x1C to draw_frame
	mov ax, 0
	mov es, ax
	mov word [es:0x0070], draw_frame
	mov word [es:0x0072], 0x00
	
	jmp $
	

draw_frame:
	pusha
	
	MOV ax, 0xA000
	MOV es, ax

	;; Draw black ball
	mov ch, 0x00
	call draw_ball

	;; Move x,y co-ordinates
	mov ax, [ball_x]
	add ax, [ball_dx]
	mov [ball_x], ax

	mov ax, [ball_y]
	add ax, [ball_dy]
	mov [ball_y], ax

	;; Draw color ball
	mov ch, 0x0A
	call draw_ball

	popa
	iret
	
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

	ret

i:	dw 0xcccc
j:	dw 0xcccc
 
ball_x:	dw 0
ball_y:	dw 0
ball_dx:	dw 1
ball_dy:	dw 1
	
;
; PADDING AND MAGIC BIOS NUMBER
;

	TIMES 510 - ($-$$) DB 0	; PAD THE SECTOR OUT WITH ZEROS
	DW 0XAA55		; LAST TWO BYTES FORM THE MAGIC NUMBER
                                ; SO BIOS KNOWS WE ARE A MOVMOV
