# asm_preProject.s
#
# Author: Russ Lewis
#
# Dummy code, just for testing student environments.  Can they run the
# grading script successfully???


.text

.globl studentMain
studentMain:
         # Function prologue -- even main has one
         addiu $sp, $sp, -24   # allocate stack space -- default of 24 here
         sw    $fp, 0($sp)     # save caller's frame pointer
         sw    $ra, 4($sp)     # save return address
         addiu $fp, $sp, 20    # setup main's frame pointer


	# load the various control variables, plus the value variables.
	#
	# We keep around the address of all 4 variables because, in the
	# sanityCheck task, we (sometimes) have to update all of them.
	#    s0 -  foo
	#    s1 -  bar
	#    s2 -  baz

	la      $s0, foo                # s0 = &foo
	lw      $s0, 0($s0)             # s0 =  foo

	la      $s1, bar                # s1 = &bar
	lw      $s1, 0($s1)             # s1 =  bar

	la      $s2, baz                # s2 = &baz
	lw      $s2, 0($s2)             # s2 =  baz


	# print_int(foo)
	addi    $v0, $zero,1
	add     $a0, $s0,$zero
	syscall

	# print_char('\n')
	addi    $v0, $zero,11
	addi    $a0, $zero,'\n'
	syscall

	# print_int(bar)
	addi    $v0, $zero,1
	add     $a0, $s1,$zero
	syscall

	# print_char('\n')
	addi    $v0, $zero,11
	addi    $a0, $zero,'\n'
	syscall

	# print_int(baz)
	addi    $v0, $zero,1
	add     $a0, $s2,$zero
	syscall

	# print_char('\n')
	addi    $v0, $zero,11
	addi    $a0, $zero,'\n'
	syscall



AFTER_DUMP:

DONE:   # Epilogue for main -- restore stack & frame pointers and return
        lw    $ra, 4($sp)     # get return address from stack
        lw    $fp, 0($sp)     # restore the caller's frame pointer
        addiu $sp, $sp, 24    # restore the caller's stack pointer
        jr    $ra             # return to caller's code

