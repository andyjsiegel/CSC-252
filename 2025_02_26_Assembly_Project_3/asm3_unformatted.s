.data
newline: .asciiz "\n"       # Newline string for formatting
bottles_msg: .asciiz " bottles of " # Message for bottles
on_the_wall: .asciiz " on the wall"
take_one_down: .asciiz "Take one down, pass it around, "
no_more_bottles: .asciiz "No more bottles of " # Message for no more bottles

.text
.globl strlen
strlen:
    # Function Prologue
    addiu $sp, $sp, -24        # Allocate space on the stack
    sw    $ra, 4($sp)        # Save the return address
    sw    $fp, 0($sp)        # Save the original string pointer
    addiu $fp, $sp, 20

    # Initialize counter to 0 (length)
    addi $t0, $zero, 0      

strlen_loop:
    lb   $t1, 0($a0)         # Load byte from the string (pointed by $a0)
    beq  $t1, $zero, strlen_done # If byte is null terminator, exit loop
    addi $t0, $t0, 1         # Increment the counter
    addi $a0, $a0, 1         # Move to the next character in the string
    j strlen_loop             # Repeat the loop

strlen_done:
    add $v0, $zero, $t0            # Move the length to $v0 for return

    # Function Epilogue
    lw    $ra, 4($sp)        # Restore the return address
    lw    $fp, 0($sp)           # Restore frame pointer
    addiu $sp, $sp, 24        # Deallocate space on the stack
    jr    $ra  
    
# Function: gcf
# Input:  $a0 - first integer (a)
# Input:  $a1 - second integer (b)
# Output: $v0 - GCF of a and b

.globl gcf
gcf:
    # Function Prologue
    addiu $sp, $sp, -24         # Allocate space on the stack
    sw    $ra, 4($sp)         # Save the return address
    sw    $fp, 0($sp)
    addiu $fp, $sp, 20

    # If (a < b)
    slt   $t0, $a0, $a1       # Set $t0 to 1 if a < b
    beq   $t0, $zero, gcf_check_b # if a >= b, go to gcf_check_b (do not swap a & b)

    # Swap a and b
    add   $t1, $a0, $zero     # t1 = a
    add   $a0, $a1, $zero     # a = b
    add   $a1, $t1, $zero     # b = t1 (original a)

gcf_check_b:
    # If (b == 1)
    addi    $t2, $zero, 1             # t2 = 1
    beq   $a1, $t2, gcf_return_one # If b == 1, return 1

    # If (a % b == 0)
    div   $a0, $a1             # Divide a by b
    mfhi  $t3                  # Move remainder to t3
    beq   $t3, $zero, gcf_return_b # If remainder is 0, return b

    # Recursive call: return gcf(b, a % b)
    add $a0, $zero, $a1              # Set a to b
    add $a1, $zero, $t3                  # a % b is now in a1
    jal gcf                  # Recursive call

gcf_return_b:
    add   $v0, $a1, $zero      # Return b
    j     gcf_end              # Jump to end

gcf_return_one:
    addi    $v0, $zero, 1               # Return 1

gcf_end:
    # Function Epilogue
    lw    $ra, 4($sp)          # Restore the return address
    lw    $fp, 0($sp)           # Restore frame pointer
    addiu $sp, $sp, 24          # Deallocate space on the stack
    jr    $ra                   # Return from function

.globl bottles
bottles:
    # Prologue
    addiu $sp, $sp, -24          # Allocate space on the stack
    sw    $ra, 4($sp)          # Save return address
    sw    $fp, 0($sp)          # Save count
    addiu $fp, $sp, 20

    # Loop: for (int i = count; i > 0; i--)
    add  $t0, $zero, $a0              # $t0 = i (count)

bottles_loop:
    # Check if i > 0
    addi   $t1, $zero, 0                # Load 0 into $t1
    slt   $t2, $t1, $t0         # Set $t2 to 1 if 0 < i
    beq   $t2, $zero, no_more   # If i < 0, go to no_more

    # Print: "%d bottles of %s on the wall, %d bottles of %s!\n"
    add $a0, $zero, $t0              # Set the first integer argument (i)
    addi $v0, $zero, 1                # Print integer syscall
    syscall

    # Print " bottles of "
    la    $a0, bottles_msg
    addi $v0, $zero, 4                # Print string syscall
    syscall

    add  $a0, $zero, $a1              # Set the string argument (thing)
    addi $v0, $zero, 4                # Print string syscall
    syscall

    # Print " on the wall, "
    la    $a0, on_the_wall
    addi $v0, $zero, 4                # Print string syscall
    syscall

    # print comma
    la   $a0, 44
    addi $v0, $zero, 11
    syscall

    # print space
    la   $a0, 32
    addi $v0, $zero, 11
    syscall

    add  $a0, $zero, $t0              # Set the second integer argument (i)
    addi $v0, $zero, 1                # Print integer syscall
    syscall

    # Print " bottles of "
    la   $a0, bottles_msg
    addi $v0, $zero, 4                # Print string syscall
    syscall

    add  $a0, $zero, $a1              # Set the string argument (thing)
    addi $v0, $zero, 4                # Print string syscall
    syscall

    # print exclamation point
    la   $a0, 33
    addi $v0, $zero, 11
    syscall

    # Print newline
    la   $a0, 10
    addi $v0, $zero, 11                # Print string syscall
    syscall

    # Print: "Take one down, pass it around, %d bottles of %s on the wall.\n"
    la   $a0, take_one_down
    addi $v0, $zero, 4                # Print string syscall
    syscall

    addiu $t1, $t0, -1          # i - 1
    add  $a0, $zero, $t1              # Set the integer argument (i - 1)
    addi $v0, $zero, 1                # Print integer syscall
    syscall

    # Print " bottles of "
    la    $a0, bottles_msg
    addi $v0, $zero, 4                # Print string syscall
    syscall

    add  $a0, $zero, $a1              # Set the string argument (thing)
    addi $v0, $zero, 4                # Print string syscall
    syscall

    la   $a0, on_the_wall
    addi $v0, $zero, 4                # Print string syscall
    syscall

    # print period
    la   $a0, 46
    addi $v0, $zero, 11
    syscall

    # Print newline
    la    $a0, 10
    addi $v0, $zero, 11                # Print string syscall
    syscall
    
    # print newline ($a0 and $v0 are already set correctly)
    syscall

    # Decrement i
    addiu $t0, $t0, -1          # i--

    j bottles_loop               # Repeat the loop

no_more:
    # Print "No more bottles of %s on the wall!\n"
    la   $a0, no_more_bottles
    addi $v0, $zero, 4                # Print string syscall
    syscall

    add  $a0, $zero, $a1              # Set the string argument (thing)
    addi $v0, $zero, 4                # Print string syscall
    syscall

    la   $a0, on_the_wall
    addi $v0, $zero, 4                # Print string syscall
    syscall

    # print exclamation point
    la   $a0, 33
    addi $v0, $zero, 11
    syscall

    # Print newline
    la   $a0, 10
    addi $v0, $zero, 11                # Print string syscall
    syscall

    # print newline ($a0 and $v0 are already set correctly)
    syscall

    # Epilogue
    lw    $ra, 4($sp)           # Restore return address
    lw    $fp, 0($sp)           # Restore frame pointer
    addiu $sp, $sp, 24           # Deallocate space on the stack
    jr    $ra                    # Return from function

.globl rotate
rotate:
    # a0 = int count
    # a1 = int a
    # a2 = int b
    # a3 = int c
    # 16($sp) = int d
    # 20($sp) = int e
    # 24($sp) = int f
    
    # int rotate(int count, int a, int b, int c, int d, int e, int f) {
    # int retval = 0;
    # for (int i=0; i<count; i++) {
    #     retval += util(a,b,c,d,e,f);
    #
    #     int tmp = a;
    #     a = b;
    #     b = c;
    #     c = d;
    #     d = e;
    #     e = f;
    #     f = tmp;
    #   }
    #   return retval;
    # }

    # Prologue
    addiu $sp, $sp, -28         # Allocate space on the stack
    sw    $ra, 4($sp)          # Save return address
    sw    $fp, 0($sp)          # Save count
    addiu $fp, $sp, 24

    lw $t4, 16($sp)                              # t5 = d
    lw $t5, 20($sp)                               # t6 = e
    lw $t6, 24($sp)                               # t7 = f

    # save s-registers onto the stack
    addiu $sp, $sp, -32			
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)

    addi $s1, $a1, 0		# s1 = a
	addi $s2, $a2, 0		# s2 = b
	addi $s3, $a3, 0		# s3 = c
	addi $s4, $t4, 0		# s4 = d
	addi $s5, $t5, 0 		# s5 = e
	addi $s6, $t6, 0		# s6 = f

    # initialize iterator, count, and return value
    addi $s0, $zero, 0	# s0 = retval
	addi $t0, $zero, 0	# i = 0
	addi $s7, $a0, 0	# s7 = count


rotate_loop:
    # if i >= len then exit loop.
    slt $t3, $t0, $s7       # if (i < count) then t3 = 1; else t3 = 0.
    beq $t3, $zero, rotate_epilogue

    # set up params for util()
    addi $a0, $s1, 0 # first param = int a
    addi $a1, $s2, 0 # second param = int b
    addi $a2, $s3, 0 # third param = int c
    addi $a3, $s4, 0 # fourth param = int d
    sw $s5, -8($sp) # put e and f onto the stack so util() can use them
    sw $s6, -4($sp)

    addi $s5, $t0, 0 # s5 = t0 (save t0 to s5 so util doesn't delete it)
    # we can overwrite s5 bc its real value can be summoned back from the stack 

    jal util

    addi $t9, $zero, 0 # set t9 to 0

    add $s0, $s0, $v0 # retval += util(a,b,c,d,e,f);
    add $t0, $s5, $zero # t0 = s5 (restore t0 from s5)

    # get the s-registers back from the stack
	lw 	$s6, -4($sp)		# s6 = f
	lw 	$s5, -8($sp) 		# s5 = e

    add $t1, $zero, $s1		# t1 = a
	add	$s1, $zero, $s2		# a = b
	add $s2, $zero, $s3		# b = c
	add	$s3, $zero, $s4		# c = d
	add	$s4, $zero, $s5		# d = e
	add $s5, $zero, $s6		# e = f
	add $s6, $zero, $t1 	# f = temp

    addi $t0, $t0, 1 # i++

    j rotate_loop

rotate_epilogue:
    addi $v0, $s0, 0     # set return value to retval

    # return all the s-registers to their previous values from the stack
	lw $s7, 28($sp)
	lw $s6, 24($sp)
	lw $s5, 20($sp)
	lw $s4, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addiu $sp, $sp, 32
	
    # Function Epilogue
	lw 	$ra, 4($sp)
	lw 	$fp, 0($sp)
	addiu $sp, $sp, 28
	jr	$ra 


.globl longestSorted
longestSorted:
    # Prologue
    addiu $sp, $sp, -24          # Allocate space on the stack
    sw    $ra, 4($sp)          # Save return address
    sw    $fp, 0($sp)          # Save count
    addiu $fp, $sp, 20

     # if length is zero, return 0.
    beq     $a1, $zero, return_zero

    addi    $t0, $zero, 1       # t0 = max_run = 1
    addi    $t1, $zero, 1       # t1 = current_run = 1
    addi    $t2, $zero, 1       # t2 = i = 1

loop:
    # if i >= len then exit loop.
    slt     $t5, $t2, $a1       # if (i < len) then t5 = 1; else t5 = 0.
    beq     $t5, $zero, exit_loop

    # Compute address for array[i]:
    sll     $t6, $t2, 2         # t6 = i * 4 
    addu    $t7, $a0, $t6       # t7 = address of array[i]
    lw      $t3, 0($t7)         # t3 = array[i]

    # Compute address for array[i-1]:
    addi    $t8, $t2, -1        # t8 = i - 1
    sll     $t9, $t8, 2         # t9 = (i-1) * 4
    addu    $t9, $a0, $t9       # t9 = address of array[i-1]
    lw      $t4, 0($t9)         # t4 = array[i-1]

    # Check if array[i] < array[i-1]:
    slt     $t5, $t3, $t4       # if (array[i] < array[i-1]) then t5 = 1.
    bne     $t5, $zero, new_run # if true, branch to new_run

    # Otherwise, the sequence continues in sorted order.
    addi    $t1, $t1, 1         # current_run++ (t1 = t1 + 1)
    j       next_iteration

new_run:
    # The sequence broke. Update max_run if current_run > max_run.
    slt     $t5, $t0, $t1       # if (max_run < current_run) then t5 = 1.
    beq     $t5, $zero, reset_run
    add     $t0, $t1, $zero     # max_run = current_run.

reset_run:
    addi    $t1, $zero, 1       # current_run = 1

next_iteration:
    addi $t2, $t2, 1         # i++
    j    loop

exit_loop:
    # Final check: update max_run if last current_run > max_run.
    slt $t5, $t0, $t1       # if (max_run < current_run)
    beq $t5, $zero, end
    add $t0, $t1, $zero     # max_run = current_run

end:
    add $v0, $t0, $zero     # set return value to max_run
    j   sorted_epilogue

return_zero:
    add $v0, $zero, $zero   # return 0
    j   sorted_epilogue

sorted_epilogue:
    lw    $ra, 4($sp)          # Restore the return address
    lw    $fp, 0($sp)           # Restore frame pointer
    addiu $sp, $sp, 24          # Deallocate space on the stack
    jr    $ra    
 