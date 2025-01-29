# test_01.s
#
# A testcase for the dummy PreProject.

.data

.globl foo
foo:
	.word	1

.globl bar
bar:
	.word	22

.globl baz
baz:
	.word	333



# ----------- main() -----------
.text


.globl	main
main:
	# call the student code
	jal	studentMain


.data
MAIN_MSG:
	.ascii 	"------------------------------\n"
	.asciiz "Dumping out all of the variables, after the student code ran:\n"
.text

	# print_str(MSG)
	addi	$v0, $zero,4
	la	$a0, MAIN_MSG
	syscall

	# print_int(foo)
	addi	$v0, $zero,1
	la	$a0, foo
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,0xa
	syscall

	# print_int(bar)
	addi	$v0, $zero,1
	la	$a0, bar
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,0xa
	syscall

	# print_int(baz)
	addi	$v0, $zero,1
	la	$a0, baz
	lw	$a0, 0($a0)
	syscall

	# print_chr('\n')
	addi	$v0, $zero,11
	addi	$a0, $zero,0xa
	syscall


	# sys_exit()
	addi	$v0, $zero,10
	syscall

