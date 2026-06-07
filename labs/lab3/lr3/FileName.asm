.686
.model flat, stdcall
option casemap:none

.data

points label qword ;начали список координат

dq 0.0,0.0,  1.0,1.0,  2.0,2.0 ; вырожденный (на одной линии)

dq 0.0,0.0,  1.0,0.0,  0.0,1.0 ; нормальный треугольник

N equ 2 ; 2 набора точек

results dd N dup(0)

epsilon dq 1.0e-6 ;погрешность (почти 0)

curIndex dd ? ;какой сейчас тест
curResult dd ? ;ответ (0 или 1)
curS dq ? ; площадь

.code

ExitProcess PROTO STDCALL :DWORD

Start:

    xor esi, esi ;начинаем с первого набора

loop_main:
    cmp esi, N ; если esi >=N - все наборы проверены, выход
    jge exit

    mov eax, esi ;копируем номер набора
    imul eax, 48              ; каждый набор 6 * 8 байт
    lea ebx, points ; ebx - начало массива
    add ebx, eax ; ebx указывает на текущий набор точек

    ; S = x1(y2-y3)+x2(y3-y1)+x3(y1-y2) - формула для вычисления площади (если около нуля, то не треугольник)

    ; x1(y2-y3)
    fld qword ptr [ebx+8]     ; загрузили y2
    fsub qword ptr [ebx+40]   ; y2 - y3
    fmul qword ptr [ebx]      ; x1 * (...)

    ; + x2(y3-y1)
    fld qword ptr [ebx+40]    ; y3
    fsub qword ptr [ebx+16]   ; y3 - y1
    fmul qword ptr [ebx+16]   ; x2 * (...)

    faddp st(1), st(0) ;сложили 1 и 2 части

    ; + x3(y1-y2)
    fld qword ptr [ebx+16]    ; y1
    fsub qword ptr [ebx+24]   ; y1 - y2
    fmul qword ptr [ebx+32]   ; x3 * (...)

    faddp st(1), st(0) ;сложили все части

    fabs ;делаем число положительным
    fstp qword ptr [curS] ;записали результат в память

    mov [curIndex], esi ; сохранили индекс (какой набор сейчас проверяем)

    fld qword ptr [curS] ; загрузили площадь
    fcomp qword ptr [epsilon] ;сравниваем с почти нулём
    fstsw ax ;получаем результат сравнения
    sahf

    jb not_triangle ; если почти 0, то не треугольник

    mov dword ptr [results+esi*4], 1 ;записали 1
    mov dword ptr [curResult], 1 ;для отладки
    jmp next ;идем дальше

not_triangle: ; если не треугольник
    mov dword ptr [results+esi*4], 0 ; записали 0
    mov dword ptr [curResult], 0

next: ;переход к следующему набору
    inc esi
    jmp loop_main

exit:
    Invoke ExitProcess, 0

End Start