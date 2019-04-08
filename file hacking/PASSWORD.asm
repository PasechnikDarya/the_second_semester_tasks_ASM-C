.model tiny
.code
org 100h

;--------------- consts ----------------
        colour		= 01110101b
	x1 = 10d
	x2 = 60d
	y1 = 4d
	y2 = 10d
;---------------------------------------

start:

;------------------ main ----------------
		mov ax, 0b800h
		mov es, ax
		call frame

		mov di, 2*(80*5d + 12d)
		mov bx, offset greeting
		call output_line
		
		mov di, 2*(80*7d + 12d)
		mov bx, di
		call input_pas

		call pas_check
		                               
		mov ax, 4c00h
		int 21h	

;--------------- end of main ------------

;---------------- pas_check -------------
;----------------------------------------
; dx - adress of enter password
; bx - adress of true password
;
;
;----------------------------------------
pas_check 	proc
                
                mov si, offset OMG_DONT_LOOK_HERE           
                mov bx, offset password
                mov cx, pas_len
                
symb_cheeeck:
		mov dl, [si]
		mov al, [bx]
		sub ax, 2

		inc bx
		inc si		
		
		cmp al, dl
		jne EXX
		loop symb_cheeeck
		
EXX:
		mov ax, 2
		cmp cx, 0
		je HASH
		jmp GENIUS
		nop



OMG_DONT_LOOK_HERE	db "5vb?B??poS&$2"

GENIUS:
		dec ax

HASH:
		xor bx, bx
		mov di, offset symb_cheeeck
		mov cx, 10

Check_hash:
		mov si, [di]
		add bx, si

		inc dx
		loop Check_hash

		cmp  bx, 52580
		jmp RR

GOD		db "EDINOLICHNIK"

LALKA:
		mov di, 2*(80*9d + 12d)
		mov bx, offset failure
		call output_line
		jmp END_CHK

GOOD_BOY:
		mov di, 2*(80*9d + 12d)
		mov bx, offset accept
		call output_line

END_CHK:
		ret
                endp
              

;-------------- end of pas_check --------

;-------------- input_pas ------------------  
; di - adress
; ax - number
;--------------------------------------------
input_pas	proc

		cld
		mov bx, di

input_symb:     mov ah, 0
                int 16h
                cmp al, 0dh       ; checking '\r'
                je END_LINE
                
                cmp al, 08h       ; checking 'backspace'
                je BCKSP

                mov ah, COLOUR + 1001b
                stosw
                jmp input_symb

password	db 'ucujcancnmc'
pas_len 	=  $ - password

BCKSP:          
		cmp di, bx        ; check clearing empty line
		je input_symb
		                               
		sub di, 2d
		jmp input_symb


END_LINE:       
		mov di, bx
		mov ax, 0
		mov si, offset OMG_DONT_LOOK_HERE 
next_symb:
		mov bx, es:[di]
                add di, 2

                cmp bl, 0
                je end_numb
               
                mov [si], bx
                inc si
             
		jmp next_symb
end_numb:
		ret
		endp

;---------------- end input_pas -------------

;-------------- output_line -----------------
;--------------------------------------------------------------------
; bx - message
; di - adress
; destr: ax
;--------------------------------------------------------------------
output_line	proc
		
		cld

next_liter:
		
		mov ax, [bx]
		cmp al, '$'
		jmp NN
RR:
		je AX_CHECK
		dec ax

AX_CHECK:
		cmp ax, 2
		jae GOOD_BOY
		jmp LALKA

NN:
		je end_liter
		mov ah, colour		 
		inc bx
		stosw 
		jmp next_liter

end_liter:
		ret
		endp
;-------------- end of output ---------------

;------------------- frame ------------------	
;============================ Frame_consts ============================
probel		= 00h
left_up         = 0c9h         ; a       
hor_line        = 0cdh         ; =
right_up        = 0bbh         ; ¬
ver_line        = 0bah         ; ¦
right_down      = 0bch         ; -
left_down       = 0c8h         ; L

;y1 		= 10d
;y2		= 20d
;x1		= 10d
;x2		= 40d      
;=======================================================================
; entry :	x1, x2, y1, y2
; destr : 	ax, dx, bx, cx, si, di
;=======================================================================
frame	proc


	mov ax, x2 
	mov cx, x1 
hor:	
	cmp ax, cx
	je vert

	mov bx, 80 * 2 * y1
	add bx, cx
	add bx, cx

	mov byte ptr es: [bx], hor_line
	mov byte ptr es: [bx + 1], colour

	mov bx, 80 * 2 * y2
	add bx, cx
	add bx, cx

	mov byte ptr es: [bx], hor_line
	mov byte ptr es: [bx + 1], colour

	add cx, 1

	jmp hor
vert:
	mov ax, y2
	mov cx, y1

	mov bx, (80d * y1 + x1) * 2
vert1:
	cmp ax, cx
	je inns
                    
	mov byte ptr es: [bx], ver_line
	mov byte ptr es: [bx + 1], colour
	
	add bx, (x2 - x1)
	add bx, (x2 - x1)

	mov byte ptr es: [bx], ver_line
	mov byte ptr es: [bx + 1], colour
	sub bx, (x2 - x1)
	sub bx, (x2 - x1)
	
	add cx, 1d

	add bx, 160d

	jmp vert1
inns:
	mov si, x1 + 1
	mov di, y1 + 1
	
	mov ax, (80 * (y1 + 1) + x1 + 1)*2
	mov bx, ax
A1:                  
	
B1:
	mov dx, x2
	cmp dx, si
	je B2

	mov byte ptr es: [bx], probel	
	mov byte ptr es: [bx + 1], colour

	add si, 1d
	
	add bx, 2d

	jmp B1
B2:
	add ax, 160d
	mov bx, ax

	mov si, x1 + 1
	add di, 1d

	mov dx, y2
	cmp dx, di
	je A2
	jmp A1

A2:
	mov bx, 2 * (80 * y1 + x1)
	mov byte ptr es: [bx], left_up
	mov byte ptr es: [bx + 1], colour

	mov bx, 2 * (80 * y1 + x2)
	mov byte ptr es: [bx], right_up
	mov byte ptr es: [bx + 1], colour

	mov bx, 2 * (80 * y2 + x1)
	mov byte ptr es: [bx], left_down
	mov byte ptr es: [bx + 1], colour

	mov bx, 2 * (80 * y2 + x2)
	mov byte ptr es: [bx], right_down
	mov byte ptr es: [bx + 1], colour


	ret
	endp	
;-------------- end frame --------------

.data

greeting 	db "Hello, user, enter a password, please $"
accept		db "access is allowed $"
failure		db "access denied $"

end start