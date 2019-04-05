.686   					
.model flat,C

public BigShowN			

.const					
NewLine db 10,13,0		
Space db 32,0			
Symbol db '%c',0		

.code
printf PROTO arg1: Ptr Byte, printlist: VARARG	

show_bt		proc
	pushad 
	mov bx,di 
bt0:   
	mov edx,esi   
	mov cl,bl      
	shr edx,cl   
	and dl,00001111b   
	cmp dl,10  
	jl bt1   
	add dl,7 
bt1:   
	add dl,30h   
	invoke printf, offset Symbol, dl	 
	sub bl,4   
	jnc bt0  
	invoke printf, offset Space
	popad  
	ret 
show_bt 	endp 
 
; void BigShowN(byte* p1, int p2) 
BigShowN proc   
@mas  equ [ebp+8]		
@len  equ [ebp+12] 

	push ebp   
	mov ebp,esp 
	invoke printf, offset NewLine	

	mov ax, @len  
	test ax, 00000011b   
	pushf   
	shr ax,2   
	popf   
	jz @1 
 	inc ax 
@1:   
	xor bx,bx   
	mov di,28   
	and ax,00000111b   
	jz @2 
	mov ah,8   
	sub ah,al   
	mov al,ah   
	xor ah,ah   
	imul ax,9		;8+1   
	mov bx,ax 
@2:   
	mov dx,@len   
	and dx,00000011b  
	jz l000 
 
	mov di,dx		;di -  1  2   3   
	dec di  		;di -  0  1   2   
	shl di,3		;di -  0  8  16   
	add di,4		;di -  4  12 20  
 
	mov dh,4   
	xchg dh,dl		;dh -  1  2  3   
	sub dl,dh		;dl -  3  2  1   
	shl dl,1		;dl -  6  4  2  
	xor dh,dh		;dx -  6  4  2      
	add bx,dx 

l000:   
	jcxz l002 
 
l001:   
	invoke printf, offset Space 	   
	dec bx  
	cmp bx,0  
	jne l001 

l002:   
	xor  ecx,ecx   
	mov cx,@len   
	shr cx,2  
	cmp di,28   
	jz @3             

	inc  cx 
@3:  
	mov ebx,@mas			
  	lea ebx,[ebx+ecx*4]-4	

l004:   
	mov esi, dword ptr [ebx]	
	sub ebx,4					   
	call show_bt				
	mov di,28   
	dec cx   
	test cx,7					; 7 = 0111b   
	jne l005 
	push ecx   
	invoke printf, offset NewLine  
	pop ecx
l005:   
	jcxz l006   
	jmp  l004 
l006:   
	invoke printf, offset NewLine
	pop ebp   
	ret
BigShowN	endp 
end