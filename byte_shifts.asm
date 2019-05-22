code SEGMENT			; 7 6 5 4 3 2 1 0		0 1 0 1 0 1 0 1  55 85
	 ASSUME	cs: code	; 5 2 7 0 5 1 3 3		0 1 0 1 0 0 0 0  50 80

begin:
		mov dl, 01010101b	;enter the initial data in the register dl(data register)
		xor bl, bl 			;the same thing as mov dh, 0, executes the local commands
		
		;0-th category
		mov al, dl			; copying dl Ò ah
		and al, 00000001b	; al = 01010101		1
		mov cl, 4			; cl = 100			
		shl al, cl			; al = 00010000		10 16
		or bl, al			; bl = 00010000
		xor al, al			; al = 00000000
		
		
		;1-th category
		mov al, dl 			; al = 01010101							
		and al, 00000010b	; al = 00000000
		mov cl, 1
		shl al,cl			; al = 00000000
		or bl, al			; bl = 00010000
		;shl al,cl			; al = 00000000
		
		;2-th category
		mov al, dl			; al = 10101010
		and al, 00000100b	; al = 00000100		4 4
		mov cl, 4			; cl = 4
		shl al, cl			; al = 01000000
		or bl, al			; bl = 01010000		50 80
		xor al, al			; al = 00000000
		
		;3-th category		
		mov al, dl			; al = 10101010
		and al, 00001000b	; al = 00000000
		mov cl, 2			; cl = 2
		shr al, cl 			; al = 00000000
		or bl, al 			; bl = 01010000
		mov cl, 1			; cl = 1
		shr al, cl			; al = 00000000
		or bl, al			; bl = 01010000
		xor al, al			; al = 00000000
		
		;4th-category
		mov al, dl;  		; al = 10101010
		and al, 00010000b	; al = 00010000
		mov cl, 3			; cl = 3
		shr al,cl			; al = 00000010
		or bl, al 			; bl = 01010010
		xor al, al
		
		;5-th category
		mov al, dl 			; al = 10101010
		and al, 00100000b	; al = 00000000
		mov cl, 2			; cl = 2
		shl al, cl 			; al = 00000000
		or bl, al			; bl = 01010000
		mov cl, 4
		shr al, cl			; al = 00000000
		or bl, al			; bl = 01010000
		xor al, al			; al = 00000000
		
		;7-th category
		mov al, dl			; al = 10101010
		and al, 10000000b	; al = 00000000
		mov cl, 2 
		shr al, cl			; al = 00000000
		or bl, al
		xor al, al 			
		mov ax, 4c00h 		; 4c00h - code for operation system
		int 21h				;call the function of the operating system
code ENDS
	end begin
		