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

	mov ax, 0x0000
	mov ds, ax
	
	mov ax, 0xa000
	mov es, ax

	;; Draw black ball
	mov ch, 0x00
	call draw_ball
	
	;; Horizontal Collision Detection
	;; ball_x <= 0 || ball_x >= WIDTH - BALL_WIDTH
	mov ax, [ball_x]
	cmp ax, 0
	jle .neg_dx

	cmp ax, WIDTH - BALL_WIDTH
	jge .neg_dx
	
	jmp .horcol_end
.neg_dx:
	neg word [ball_dx]
.horcol_end:
	;; Vertical Collision Detection
	;; ball_y <= 0 ||  ball_y >= HEIGHT - BALL_HEIGHT
	mov ax, [ball_y]
	cmp ax, 0
	jle .neg_dy

	cmp ax, HEIGHT - BALL_HEIGHT
	jge .neg_dy

	jmp .vercol_end

.neg_dy:
	neg word [ball_dy]
.vercol_end:
	
	;; Change the ball position
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
	
	mov ax, 0x0000
	mov ds, ax

	;; cx - color
	;; ax - row
	;; bx - column
	mov word [y], 0
.y:			;row
	mov word [x], 0 
.x:			;col
	mov ax, WIDTH
	mov bx, [y]
	;; Add position offset
	add bx, [ball_y]
	mul bx
	mov bx, ax
	add bx, [x]
	;; Add position offset
	add bx, [ball_x]
	mov BYTE [es: bx], ch
	
	inc word [x]
	cmp word [x], BALL_WIDTH
	jb .x

	inc word [y]
	cmp word [y], BALL_HEIGHT
	jb .y 

	ret
	
x:	dw 0xcccc
y:	dw 0xcccc
 
ball_x:	dw 10
ball_y:	dw 10
ball_dx:	dw 2
ball_dy:	dw (-2)
	
;
; padding and magic bios number
;

	times 510 - ($-$$) db 0	; pad the sector out with zeros
	dw 0xaa55		; last two bytes form the magic number
                                ; so bios knows we are a movmov
