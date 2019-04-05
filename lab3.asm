.386
Tabl1 struc 
namex db 8 dup (10h)
field1 db ?
field2 dw ?
field8 dq ?
Tabl1 ENDS

Data1 segment use16
I1 db 0
A1 Tabl1 6 dup (<>)
addrs  dd  code2_label
Data1 ends

Data2 segment use16
A2 Tabl1 6 dup (<>)
Data2 ends

Code1 segment use16
ASSUME cs:Code1, ds:Data1
_Code1Begin:
    mov ax, Data1  
    mov ds, ax

    mov ax, 0
    mov si, size Tabl1
    mov cx, 6
    cycl:         
    movzx ax, I1
    mul si
    mov bp, ax
    mov bx, 0
    c2:
        lea di, A1[bp].namex
        movzx dx, [di][bx]
        lea di, A1[bp].field2
        add [di], dx
        inc bx
        cmp bx, 8
    jl c2
    movzx ax, I1
    add [di], ax
    inc I1
    loop cycl

    jmp addrs
Code1 ENDS

Code2 segment use16
ASSUME cs:Code2, ds:Data1, es:Data2
    code2_label:
    mov ax, Data1
    mov ds, ax
    mov ax, Data2
    mov es, ax
    mov I1, 0
    c3:
        movzx bx, I1
        imul si, bx, size Tabl1
        imul di, bx, size Tabl1
        add si, 1
        add di, 11
        mov cx, 8
        cld
        rep movsb
        inc I1
        cmp I1, 6
    jl c3
    
    mov ax, Data2
    mov ds, ax

    MOV AX, 4C00H
    INT 21H
Code2 ENDS
end _Code1Begin