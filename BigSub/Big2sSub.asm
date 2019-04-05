.686
.model flat, C

.code
Big2sSub proc
	push ebp
	mov ebp, esp
	mov esi,0
    movzx esi, word ptr [ebp + 20]  ;length
	mov ebx, 0
	mov edx, [ebp + 8]  ;m1
	mov ecx, [ebp + 12] ;m2

	mov eax, esi
	and eax, 00000011b	
	sub esi, eax	

	clc
	pushf									
    start_32_loop:
        popf	
		mov eax, dword ptr [edx + ebx]
        sbb eax, dword ptr [ecx + ebx]
        mov dword ptr [edx + ebx], eax
		pushf								
		add ebx, 4
        cmp ebx, esi
        jnz start_32_loop

	cmp si, [ebp + 20]
	jz END_LABEL
	mov eax, 0
	mov esi, 0
	mov si, word ptr [ebp + 20]

    start_8_loop:
        popf
		mov al, byte ptr [edx + ebx]
        sbb al, byte ptr [ecx + ebx]
        pushf
		mov byte ptr [edx + ebx], al
        inc ebx
        cmp ebx, esi
        jnz start_8_loop

	END_LABEL:
	popf
	mov al, 1
	jc @labelCarry
	mov al, 0
	@labelCarry:
	mov edi, [ebp + 16]
	mov byte ptr [edi], al
	pop ebp
	ret
Big2sSub endp
end
