.386
Data SEGMENT use16
symbol      db  'K'
pos         dw  1000
sw          db  0
Data ENDS

Code SEGMENT use16
ASSUME CS: Code, DS: Data

prmaus 	proc 		far
push		ds    
push 		es
pusha
push		0b800h ; сегментна адреса відеобуфера
pop 		es	
push 		Data 
pop ds 

    cli     
    mov     ax, 0b800h
    mov     es, ax   
    
    shr     dx, 03h 
    shr     cx, 03h

    imul    dx, (80*2)   
    add     dx, cx
    add     dx, cx
    add     dx, 2
    mov     di, dx  

    cmp sw, 0
    je @lf
    mov pos, di

@lf:
    test bx, 1b
    jne @q
    mov ax, pos
    cmp di, ax
    jne @q

    mov sw, 1
    cld

    mov al, 0
    mov di, 1
    mov cx, 4000
    rep stosb

    mov di, pos

    mov ax, 0
    mov si, 0
    movsb

    mov al, 00000111b
    stosb
    jmp @Quit
	
@q:
    mov sw, 0  
@Quit:
	sti
	popa
	pop 		es
	pop 		ds
	ret
prmaus	endp
begin:

    mov     ax, Data
    mov     ds, ax

    mov     ax, 3h
    int     10h
    mov     ax, 0001h       
    int     33h

    mov 		ax, 0ch	
    mov			cx, 00011b
    push 		es		 
    push 		cs
    pop 		es
    lea 		dx, prmaus
    int 		33h		

    mov ax, 0b800h
    mov es, ax  
    
    mov ax, 0
    mov si, 0
    mov di, pos
    movsb
    
@9:   
	mov ah, 01h	    ; ввести символ з клавіатури ПЕОМ
    int 21h			;call DOS function
    mov symbol, al;

    @eee:
    mov     ax,0Ch
    mov     cx,0
    int     33h 

    mov     ax, 3h
    int     10h

    mov     ax,4c00h
    int     21h

Code ENDS
END begin