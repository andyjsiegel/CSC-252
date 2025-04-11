.data
main__STR1:	.asciiz "the quick brown fox jumped over the lazy dog."
main__STR2: .asciiz "abcdefghijklmnopqrstuvwxyz"
main__STR3: .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
.text

.globl main
main:
    la $a0, main__STR1
    jal countLetters

    la $a0, main__STR2
    jal countLetters

    la $a0, main__STR3
    jal countLetters

    addi $v0, $zero, 10
    syscall

# expected values
# a = 1
# b = 1
# c = 1
# d = 2
# e = 4
# f = 1
# g = 1
# h = 2
# j = 1
# k = 1
# l = 1
# m = 1
# n = 1
# o = 4
# p = 1
# q = 1
# r = 2
# s = 0
# t = 2
# u = 2
# v = 1
# w = 1
# x = 1
# y = 1
# z = 1