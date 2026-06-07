.686
.model flat, stdcall
.stack 100h

.data
X dw 9189h
Y dw 714Bh
Z dw 0CD12h

X_ dw ?      ; X'
Y_ dw ?      ; Y'
Z_ dw ?      ; Z'
M dw ?
R dw ?

.code
ExitProcess PROTO STDCALL :DWORD

; Подпрограмма 1: R = M – 4101
Proc1 PROC
    mov ax, M
    sub ax, 4101
    mov R, ax
    ret
Proc1 ENDP

; Подпрограмма 2: R = M xor E130h
Proc2 PROC
    mov ax, M
    xor ax, 0E130h
    mov R, ax
    ret
Proc2 ENDP

; Подпрограмма адр1: R = R OR 1024
Addr1 PROC
    mov ax, R
    or ax, 1024
    mov R, ax
    ret
Addr1 ENDP

; Подпрограмма адр2: R = R / 2
Addr2 PROC
    mov ax, R
    shr ax, 1
    mov R, ax
    ret
Addr2 ENDP

Start:
    mov esi, OFFSET X      ; указатель на X
    mov edi, OFFSET X_     ; указатель на X'
    mov ecx, 3             ; цикл 3 раза (3 элемента)

obnul_cikl:
    movzx ax, byte ptr [esi]  ; обнуление старшего
    mov [edi], ax             ; запись в X', Y', Z'

    add esi, 2
    add edi, 2

    loop obnul_cikl

    ; Вычисление M = X' + (Y' & Z')
    mov ax, Y_
    and ax, Z_
    add ax, X_
    mov M, ax

    ; Проверка младшего байта М
    test byte ptr M, 0FFh
    jnz use_proc1
    call Proc2
    jmp check_parity
use_proc1:
    call Proc1

check_parity:
    ; Проверка чётности единиц в младшем байте R
    test byte ptr R, 0FFh
    jp even_parity
    call Addr2
    jmp exit_prog
even_parity:
    call Addr1

exit_prog:
    invoke ExitProcess, 0
END Start