org 0x7c00
	%define ROW 70
	%define WIDTH 320
	%define HEIGHT 200
	
	%define COLOR_BLACK 0
	%define COLOR_BLUE 1
	%define COLOR_GREEN 2
	%define COLOR_CYAN 3
	%define COLOR_RED 4
	%define COLOR_MAGENTA 5
	%define COLOR_BROWN 6
	%define COLOR_LIGHTGRAY 7
	%define COLOR_DARKGRAY 8
	%define COLOR_LIGHTBLUE 9
	%define COLOR_LIGHTGREEN 10
	%define COLOR_LIGHTCYAN 11
	%define COLOR_LIGHTRED 12
	%define COLOR_LIGHTMAGENTA 13
	%define COLOR_YELLOW 14
	%define COLOR_WHITE 15
	
	%define BACKGROUND_COLOR COLOR_DARKGRAY

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

entry:	
	mov ah, 0x00	
	;; VGA mode 0x13
	;; 320 x 200 256 colors
	mov al, 0x13
	int 0x10

	mov ch, BACKGROUND_COLOR
	call fill_screen

	;; Point int 0x1C to draw_frame
	mov ax, 0
	mov es, ax
	mov word [es:0x0070], draw_frame
	mov word [es:0x0072], 0x00

.loop:
	mov ah, 0x1
	int 0x16
	jz .loop		; Checks if keystrokes (0 == no keystroke)

	mov ah, 0x0
	int 0x16

	neg word [ball_dx]
	
	jmp .loop
	

draw_frame:
	pusha

	mov ax, 0x0000
	mov ds, ax
	
	mov ax, 0xa000
	mov es, ax

	;; Draw black ball
	mov ch, BACKGROUND_COLOR
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

fill_screen:
	;; ch - color
	pusha

	mov ax, 0xA000
	mov es, ax
	
	xor bx, bx
.loop:
	mov BYTE [es: bx], ch
	inc bx
	cmp bx, WIDTH * HEIGHT
	jb .loop

	popa
	ret
	
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
