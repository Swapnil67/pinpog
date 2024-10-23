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
	%define BALL_VELOCITY 4
	%define BALL_COLOR COLOR_YELLOW
	
	%define BAR_WIDTH 100
	%define BAR_Y 50
	%define BAR_HEIGHT BALL_HEIGHT
	%define BAR_COLOR COLOR_LIGHTBLUE

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
	cmp al, 'a'
	jz .swipe_left
	cmp al, 'd'
	jz .swipe_right
	cmp al, ' '
	jz .toggle_pause
	
	jmp .loop
.swipe_left:
	mov word [bar_dx], -10
	jmp .loop
.swipe_right:
	mov word [bar_dx], 10
	jmp .loop
.toggle_pause:
	mov ax, word [es:0x0070]
	cmp ax, do_nothing
	jz .unpause
	mov word [es:0x0070], do_nothing
	jmp .loop
.unpause:
	mov word [es:0x0070], draw_frame
	jmp .loop
	
draw_frame:
	pusha

	mov ax, 0x0000
	mov ds, ax
	
	mov ax, 0xa000
	mov es, ax

	;; Clear ball
	mov word [rect_width], BALL_WIDTH
	mov word [rect_height], BALL_HEIGHT
	mov ax, [ball_x]
	mov word [rect_x], ax
	mov ax, [ball_y]
	mov word [rect_y], ax
	mov ch, BACKGROUND_COLOR
	call fill_rect

	;; Clear bar
	mov word [rect_width], BAR_WIDTH
	mov word [rect_height], BAR_HEIGHT
	mov ax, [bar_x]
	mov [rect_x], ax
	mov word [rect_y], HEIGHT - BAR_Y
	mov ch, BACKGROUND_COLOR
	call fill_rect
	
	;; Horizontal Collision Detection
	;; ball_x <= 0 || ball_x >= WIDTH - BALL_WIDTH
	mov ax, [ball_x]
	cmp ax, 0
	jle .neg_ball_dx

	cmp ax, WIDTH - BALL_WIDTH
	jge .neg_ball_dx
	
	jmp .ball_x_col
.neg_ball_dx:
	neg word [ball_dx]
.ball_x_col:

	;; Vertical Collision Detection
	;; ball_y <= 0 ||  ball_y >= HEIGHT - BALL_HEIGHT
	;; top collision check
	cmp word [ball_y], 0
	jle .neg_ball_dy

	;; Ball touches the ground
	cmp word [ball_y], HEIGHT - BALL_HEIGHT
	jge .game_over
	
	;; ball to bar collision check
	;; bar_x <= ball_x && ball_x + BALL_WIDTH <= bar_x + BAR_WIDTH
	;; left bound check
	mov bx, [ball_x]
	cmp [bar_x], bx
	jg .ball_y_col

	;; ball_x + BALL_WIDTH <= bar_x + BAR_WIDTH
	;; ball_x - bar_x <= BAR_WIDTH - BALL_WIDTH
	sub bx, [bar_x]
	cmp bx, BAR_WIDTH - BALL_WIDTH
	jg .ball_y_col

	;; ball_y >= HEIGHT - BALL_HEIGHT - BAR_Y
	cmp word [ball_y], HEIGHT - BALL_HEIGHT - BAR_Y
	jge .neg_ball_dy
	jmp .ball_y_col
	
.game_over:
	xor ax, ax
	mov es, ax
	mov word [es:0x0070], game_over
	
.neg_ball_dy:
	neg word [ball_dy]
.ball_y_col:	

	;; BAR Collision detection
	;; bar_x <= 0 || bar_x >= WIDTH - BAR_WIDTH 
	mov ax, [bar_x]
	cmp ax, 0
	jle .neg_bar_dx

	cmp ax, WIDTH - BAR_WIDTH
	jge .neg_bar_dx

	jmp .bar_x_col
.neg_bar_dx:
	neg word [bar_dx]
.bar_x_col:
	
	;; ball_x += ball_dx
	mov ax, [ball_x]
	add ax, [ball_dx]
	mov [ball_x], ax

	;; ball_y += ball_dy
	mov ax, [ball_y]
	add ax, [ball_dy]
	mov [ball_y], ax

	;; bar_x += bar_dx
	mov ax, [bar_x]
	add ax, [bar_dx]
	mov [bar_x], ax

	;; Draw color ball
	;; Update ball_x -> rect_x
	;; Update ball_y -> rect_y
	mov word [rect_width], BALL_WIDTH
	mov word [rect_height], BALL_HEIGHT
	mov ax, [ball_x]
	mov word [rect_x], ax
	mov ax, [ball_y]
	mov word [rect_y], ax
	mov ch, BALL_COLOR
	call fill_rect

	;; Draw bar
	mov word [rect_width], BAR_WIDTH
	mov word [rect_height], BAR_HEIGHT
	mov ax, [bar_x]
	mov [rect_x], ax
	mov word [rect_y], HEIGHT - BAR_Y
	mov ch, BAR_COLOR
	call fill_rect	

	popa
	iret
	
do_nothing:	iret

game_over:
	mov ch, COLOR_RED
	call fill_screen
	iret
	
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
	
fill_rect:
	;; ch - color
	;; ax - row
	;; bx - column
	
	mov ax, 0x0000
	mov ds, ax

	mov word [y], 0
.y:			;row
	mov word [x], 0 
.x:			;col
	mov ax, WIDTH
	mov bx, [y]
	;; Add position offset
	add bx, [rect_y]
	mul bx
	mov bx, ax
	add bx, [x]
	;; Add position offset
	add bx, [rect_x]
	mov BYTE [es: bx], ch
	
	inc word [x]
	mov dx, [rect_width]
	cmp word [x], dx
	jb .x

	inc word [y]
	mov dx, [rect_height]
	cmp word [y], dx
	jb .y 

	ret
	
x:	dw 0xcccc
y:	dw 0xcccc
 
ball_x:	dw 10
ball_y:	dw 10
ball_dx:	dw BALL_VELOCITY
ball_dy:	dw -BALL_VELOCITY
	
bar_x:	dw 10
bar_y:	dw 0
bar_dx:	dw 4
	
rect_x:	dw 0xcccc
rect_y:	dw 0xcccc
rect_width:	dw 0xcccc
rect_height:	dw 0xcccc
	
;
; padding and magic bios number
;

	times 510 - ($-$$) db 0	; pad the sector out with zeros
	dw 0xaa55		; last two bytes form the magic number
                                ; so bios knows we are a movmov
