    .section .text
    .globl asm_routine
asm_routine:
    li t0, 1          # carica immediato 42 in t0
    li t1, 2          # carica immediato 17 in t1
    add t2, t0, t1     # somma t0 + t1 -> t2
    sub t3, t0, t1     # differenza t0 - t1 -> t3
    ret                # ritorna al chiamante
