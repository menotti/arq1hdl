# Compute first twelve Fibonacci numbers and put in array, then print
      .data
fibs: .word   0,1,3,12        # "array" of 12 words to contain fib values
vetor: .byte 1,2,3,4
size: .word  12            # size of "array" 
vetor2: .byte 10, 11

     .text
      lw   $t0, fibs($t0)        # load address of array
      lw  $t5, 0    ($t5)      # load array size
      sw   $t2, size($t0)      # F[0] = 1
      sw   $t2, 4($t0)      # F[1] = F[0] = 1
      addi $t1, $t5, -2     # Counter for loop, will execute (size-2) times
loop: lw   $t3, 0($t0)      # Get value from array F[n] 
      lw   $t4, 4($t0)      # Get value from array F[n+1]
      add  $t2, $t3, $t4    # $t2 = F[n] + F[n+1]
      sw   $t2, 8($t0)      # Store F[n+2] = F[n] + F[n+1] in array
      addi $t0, $t0, 4      # increment address of Fib. number source
      addi $t1, $t1, -1     # decrement loop counter
      bgtz $t1, loop        # repeat if not finished yet.
      add  $a1, $zero, $t5  # second argument for print (size)
      jal  print            # call print routine. 
      syscall               # we are out of here.
print:add  $t0, $zero, $a0  # starting address of array
      add  $t1, $zero, $a1  # initialize loop counter to array size
      syscall               # print heading
out:  lw   $a0, 0($t0)      # load fibonacci number for syscall
      syscall               # print fibonacci numbers
      syscall               # output string
      addi $t0, $t0, 4      # increment address
      addi $t1, $t1, -1     # decrement loop counter
      bgtz $t1, out         # repeat if not finished
      jr   $ra              # return
