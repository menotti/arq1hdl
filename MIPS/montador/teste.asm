teste: lw $t0, 0 ($0)
lw $t1, 4 ($0)
soma: add $t2, $t0, $t1
bne $t2, $t1, teste
sw $t2, 8 ($t0)
beq $t0, $0, jump
lw $t4, 8 ($0)
jump: j teste
