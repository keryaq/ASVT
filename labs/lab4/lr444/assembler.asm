.586
.MODEL FLAT, C

.DATA

.CODE
    public CalculateValues
    
CalculateValues PROC C
    push ebp
    mov  ebp, esp
    push ebx
    push esi
    
    mov  ecx, [ebp+8]
    mov  esi, [ebp+16]
    fld  dword ptr [ebp+12]
    
    xor  ebx, ebx
    cmp  ecx, 0
    jle  done
    
compute_loop:
    push ecx
    
    push ebx
    fild dword ptr [esp]
    add  esp, 4
    fld  dword ptr [ebp+12]
    fmul
    fld  ST(0)
    
    ftst
    fstsw ax
    sahf
    jz   x_zero
    
    fsin
    fld  ST(1)
    fcos
    fld  ST(1)
    fdiv ST(0), ST(1)
    fxch ST(2)
    fadd ST(0), ST(2)
    
    ; e^x ≈ 1 + x + x^2/2
    fxch ST(3)
    fld  ST(0)
    fmul
    fld1
    fadd ST(0), ST(2)
    fld  ST(1)
    fld1
    fadd ST(0), ST(1)
    fdiv
    fadd
    
    fxch ST(3)
    fdiv
    jmp save
    
x_zero:
    fstp ST(0)
    fstp ST(0)
    fldz
    
save:
    fstp dword ptr [esi + ebx*4]
    
;очищаем стек
    fstp ST(0)
    fstp ST(0)
    fstp ST(0)
    fstp ST(0)
    fstp ST(0)
    fstp ST(0)
    fstp ST(0)
    
    fld  dword ptr [ebp+12]
    
    pop  ecx
    inc  ebx
    loop compute_loop
    
done:
    pop  esi
    pop  ebx
    pop  ebp
    ret
CalculateValues ENDP

END