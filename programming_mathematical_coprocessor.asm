.386
;макровизначення для обчислення масштабу
scale  macro  p1
;обчислення масштабного коефіцієнта по осі pl
  fld  max_&p1		; st0=max_&p1; top=7
  fsub  min_&p1		; st0=max_&p1 - min_&p1; ;top=7
  fild  p1&_result		; st0=max_crt_&p1,
					; st1=max_&p1-min_&p1; top=6

  fdivp  st(1), st(0)	; 1-й крок st1=st1/st0
  ; 2-й крок st1 стає st0; top=7
	; і містить масштаб

  fstp  scale_&p1
endm

x_result_  equ  320
y_result_  equ  200

_data  segment  use16
;обчислення масштабних коефіцієнтів 
  min_x  dq  -6.283
  max_x  dq  6.283
  x_result  dw  x_result_
  
  crt_x  dw  ?
  scale_x  dq  ?

  min_y  dq  -3.0
  max_y  dq  3.0
  y_result  dw  y_result_
  crt_y  dw  ?
  scale_y  dq  ?

  step  dq  0.001
  tmp  dw  ?
  
_data  ends

_code  segment  use16
  assume  cs:_code, ds:_data
begin:
  mov  ax, _data
  mov  ds, ax

  mov  ax, 13h		;задання графічного режиму
  int  10h			;відводиться один сегмент для відеоконтроллера 

  finit				; ініціалізація співпроцесора
  scale  x			; обчислення функцій
  scale  y

  call  draw_axis

  push  4
  push  offset func
  call  draw_gra
  add  sp, 4


  mov  ah, 8
  int  21h
  mov  ax, 3
  int  10h
  mov  ax, 4C00h
  int  21h

func  proc      ; 4. у=sin(x)+sin(2*x)
  fst st(2)			; работаем с st(0)б копируем в ст(2) ст(0) х, в ст(2) х
  fsin				; st(0) sinx    st(2) x
  fxch st(2)		; st(2) sinx 	st(0) x
  fadd st(0), st(0)	; st(0) 2x
  fsin				; st(0) sin2x
  fadd st(0), st(2)	; st(0) sinx + sin2x

  ret
func  endp

draw_gra  proc
  push  bp
  mov  bp, sp
  fld  min_x
beg:
  fld  st(0)
  fld  st(0)
  call  get_x
  fst st(2)
  fsin
  fxch st(2)
  fadd st(0), st(0)
  fsin
  fadd st(0), st(2)
  call  get_y
  push  2
  call  draw_point
  add  sp, 2
  fld  step
  faddp  st(1), st(0)
  fcom  max_x
  fstsw  ax
  sahf
  jna  beg
  ffree  st(0)
  fld  min_x
beg1:
  fld  st(0)
  fld  st(0)
  call  get_x
  fsin
  call  get_y
  push  6
  call  draw_point
  add  sp, 2
  fld  step
  faddp  st(1), st(0)
  fcom  max_x
  fstsw  ax
  sahf
  jna  beg1
  ffree  st(0)
  fld  min_x
beg2:
  fld  st(0)
  fld  st(0)
  call  get_x
  fadd st(0), st(0)
  fsin
  call  get_y
  push  7
  call  draw_point
  add  sp, 2
  fld  step
  faddp  st(1), st(0)
  fcom  max_x
  fstsw  ax
  sahf
  jna  beg2
  ffree  st(0)
  pop  bp
  ret
draw_gra  endp

get_x  proc
  fsub  min_x
  fdiv  scale_x
  frndint			;округлення
  fistp  crt_x		; збереження вершини стеку
  ret
get_x  endp

get_y  proc
  fsub  min_y
  fdiv  scale_y
  frndint
  fistp  crt_y			
  mov  ax, y_result
  sub  ax, crt_y
  mov  crt_y, ax
  ret
get_y  endp

draw_point  proc
  push  bp
  mov  bp, sp
  mov  ax, 0A000h
  mov  es, ax
  mov  si, crt_y
  mov  di, crt_x
  cmp  si, y_result_
  jae  end
  cmp  di, x_result_	
  jae  end
  mov  ax, x_result_			; обчислення байта у графічній відеопам'яті
  mul  si
  add  ax, di
  
  mov  bx, ax
  mov  dx, [bp+4]			 ; вивід точки на екран
  mov  byte ptr es:[bx], dl
end:
  pop  bp
  ret
draw_point  endp

draw_axis  proc
  fldz
  call  get_y
  mov  crt_x, 0
  mov  cx, x_result_
@x_c:
  push  15
  call  draw_point
  add  sp, 2
  inc  crt_x
  loop  @x_c

  fld  max_x
  fsub  min_x
  frndint
  fistp  tmp
  mov  cx, tmp

  fld  min_x
  frndint
  dec  crt_y
line_x:
  fld  st(0)
  call  get_x
  push  15
  call  draw_point
  add  sp, 2
  
  fld1
  faddp  st(1), st(0)
  loop  line_x
  ffree  st(0)

  fldz
  call  get_x
  mov  crt_y, 0
  mov  cx, y_result_
@y_c:
  push  15
  call  draw_point
  add  sp, 2
  inc  crt_y
  loop  @y_c

  fld  max_y
  fsub  min_y
  frndint
  fistp  tmp
  mov  cx, tmp

  fld  min_y
  frndint
  dec  crt_x
line_y:
  fst  st(1)
  call  get_y
  push  15
  call  draw_point
  add  sp, 2  

  fld1
  faddp  st(1), st(0)
  fcom  max_y
  loop  line_y
  ffree  st(0)
  ret
draw_axis  endp

_code  ends
  end  begin