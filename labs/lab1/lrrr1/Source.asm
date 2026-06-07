.686
.model flat, stdcall

.data
X dw 3
Y dw 0
Z dw 12
M dw ?
temp dw ? ; €чейка пам€ти дл€ временного хранени€

.code
ExitProcess proto stdcall :dword

Start:
    
    ; X*Y'
    mov ax, Y
    not ax
    mov temp, ax
    mov ax, X
    mul temp
    mov temp, ax

    ;X*Z'
    mov ax, Z
    not ax
    mov bx, ax
    mov ax, X
    mul bx
    mov bx, ax

    ;y/2 и or x*z'
    mov ax, Y
    shr ax, 1
    or ax, bx
    
    ;сложение и сохранение
    add ax, temp
    mov M, ax

exit:
    call ExitProcess

end Start