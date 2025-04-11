# Assembly Project 5 - CSC 252 Spring 2025
# Author: Andy Siegel
# This project implements two tasks: countLetters() and subsCipher()
# countLetters() takes a string as input and returns the number of each letter in the string
# subsCipher() implements a substitution cipher, where each letter or symbol in the input string
# is replaced with another character according to a provided mapping table. It allocates memory
# for the encoded message on the stack, ensuring that the original string remains unmodified.

.data
    header:    .asciiz "----------------\n"
    bottom:    .asciiz "\n----------------\n"
    other:     .asciiz "<other>: "
    printSubstitutedString__MSG1:	.asciiz "pSS(dup): dup="
.text
#  void countLetters(char *str) { 
#         int letters[26];    // this function must fill these with zeroes 
#         int other = 0; 
# 
#         printf("----------------\n%s\n----------------\n", str); 
# 
#         char *cur = str; 
#         while (*cur != '\0') { 
#             if (*cur >= 'a' && *cur <= 'z') 
#                 letters[*cur-'a']++; 
#             else if (*cur >= 'A' && *cur <= 'Z') 
#                 letters[*cur-'A']++; 
#             else 
#                 other++; 
# 
#             cur++; 
#         } 
#
#         for (int i=0; i<26; i++) 
#             printf("%c: %d\n", 'a'+i, letters[i]); 
#         printf("<other>: %d\n", other); 
#     }
.globl countLetters
countLetters:
    # Function Prologue
    addiu $sp, $sp, -128                                           # Allocate space on the stack
    sw    $ra, 4($sp)                                              # Save the return address
    sw    $fp, 0($sp)                                              # Save the original frame pointer
    addiu $fp, $sp, 124

    addi $t0, $a0, 0                                               # t0 = str
    
    la   $a0, header                                               # print "----------------\n"
    addi $v0, $zero, 4                                             # print string syscall
    syscall
    
    addi $a0, $t0, 0                                               # print str
    addi $v0, $zero, 4                                             # print string syscall
    syscall
    
    la   $a0, bottom                                               # print "\n----------------\n"
    addi $v0, $zero, 4                                             # print string syscall
    syscall
    
    addi $t1, $zero, 26                                            # t1 = 26
    addi $t2, $zero, 0                                             # t2 = i = 0
    addi $t5, $zero, 0                                             # t5 = other = 0
    addi $t9, $sp, 8                                               # t9 = stack pointer

initialize_array_to_zero:
    slt $t3, $t2, $t1                                              # if (i < 26) then t3 = 1; else t3 = 0.
    beq $t3, $zero, count_chars_loop

    sw   $zero, 0($t9)                                             # letters[0] = 0
    addi $t9, $t9, 4                                               # increment stack pointer
    addi $t2, $t2, 1                                               # i++
    j    initialize_array_to_zero

count_chars_loop:
    lb  $t1, 0($t0)                                                # t1 = str[i]
    beq $t1, $zero, print_letter_counts                            # if (t1 == '\0') goto print_letter_counts

check_if_uppercase:
    slti $t3, $t1, 65                                              # if (t1 < 'A') then t3 = 1; else t3 = 0.
    bne  $t3, $zero, increment_other                               # if (t1 < 'A') then goto count_chars_loop_next_iteration
    slti $t3, $t1, 91                                              # if (t1 < 'Z') then t3 = 1; else t3 = 0.
    beq  $t3, $zero, check_if_lowercase                            # if (t1 > 'Z') then goto check_if_lowercase
    j upper_case_tracking

check_if_lowercase:
    slti $t3, $t1, 97                                              # if (t1 < 'a') then t3 = 1; else t3 = 0.
    bne  $t3, $zero, increment_other                               # if (t1 < 'a') then goto count_chars_loop_next_iteration
    slti $t3, $t1, 123                                             # if (t1 < 'z') then t3 = 1; else t3 = 0.
    beq  $t3, $zero, increment_other                               # if (t1 > 'z') then goto count_chars_loop_next_iteration
    j lower_case_tracking

lower_case_tracking:
    sll  $t2, $t1, 2                                               # t2 = t1 * 4
    addi $t2, $t2, -380                                            # a = 2 * 4 & z = 27 * 4 -> a = 8, z = 108 for array on stack
    addi $t9, $sp, 0                                               # t9 = stack pointer
    add  $t9, $t9, $t2                                             # t9 = &letters[char]
    lw   $t3, 0($t9)                                               # t3 = letters[char]
    addi $t3, $t3, 1                                               # t3 = letters[char] + 1
    sw   $t3, 0($t9)                                               # letters[char] = t3
    j count_chars_loop_next_iteration

upper_case_tracking:
    sll  $t2, $t1, 2                                               # t2 = t1 * 4
    addi $t2, $t2, -252                                            # a = 2 * 4 & z = 27 * 4 -> a = 8, z = 108 for array on stack
    addi $t9, $sp, 0                                               # t9 = stack pointer
    add  $t9, $t9, $t2                                             # t9 = &letters[char]
    lw   $t3, 0($t9)                                               # t3 = letters[char]
    addi $t3, $t3, 1                                               # t3 = letters[char] + 1
    sw   $t3, 0($t9)                                               # letters[char] = t3
    j count_chars_loop_next_iteration
increment_other:
    addi $t5, $t5, 1                                               # other++
    j count_chars_loop_next_iteration

count_chars_loop_next_iteration:
    addi $t0, $t0, 1
    j count_chars_loop

print_letter_counts:
    addi $t1, $zero, 26                                            # t1 = 26
    addi $t2, $zero, 0                                             # t2 = i = 0
    addi $t9, $sp, 8                                               # t9 = stack pointer

print_letter_counts_loop:
    slt $t3, $t2, $t1                                              # if (i < 26) then t3 = 1; else t3 = 0.
    beq $t3, $zero, count_letters_epilogue                         # if (i < 26) then goto count_letters_epilogue

    addi $a0, $t2, 97                                              # print letter at index i
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    addi $a0, $zero, 58                                            # print ':'
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    addi $a0, $zero, 32                                            # print ' '
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    lw $t4, 0($t9)                                                 # t4 = letters[i]
    addi $a0, $t4, 0                                               # print count of letter at index i
    addi $v0, $zero, 1                                             # print int syscall
    syscall

    addi $a0, $zero, 10                                            # print "\n"
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    addi $t2, $t2, 1                                               # i++
    addi $t9, $t9, 4                                               # increment stack pointer reference by 4
    j print_letter_counts_loop

count_letters_epilogue:
    la   $a0, other                                                # print "<other>: "
    addi $v0, $zero, 4                                             # print string syscall
    syscall

    addi $a0, $t5, 0                                               # print other
    addi $v0, $zero, 1                                             # print int syscall
    syscall

    addi $a0, $zero, 10                                            # print "\n"
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    # Function Epilogue
    lw    $ra, 4($sp)                                              # Restore the return address
    lw    $fp, 0($sp)                                              # Restore frame pointer
    addiu $sp, $sp, 128                                            # Deallocate space on the stack
    jr    $ra 

# void subsCipher(char [] str, char [] map) 
#     { 
#         // NOTE: len is one more than the length of the string; it includes 
#         //       an extra character for the null terminator. 
#         int len = strlen(str)+1; 
#  
#         int len_roundUp = (len+3) & ~0x3; 
#         char dup[len_roundUp];    // not legal in C, typically.  See spec. 
#  
#         for (int i=0; i<len-1; i++) 
#             dup[i] = map[str[i]]; 
#         dup[len-1] = '\0'; 
#  
#         printSubstitutedString(dup); 
#     }
.globl subsCipher
subsCipher:
    # Function Prologue
    addiu $sp, $sp, -32                                            # Allocate space for saved registers
    sw    $ra, 0($sp)                                              # Save return address
    sw    $fp, 4($sp)                                              # Save frame pointer
    sw    $s0, 8($sp)                                              # Save $s0
    sw    $s1, 12($sp)                                             # Save $s1
    sw    $s2, 16($sp)                                             # Save $s2
    addiu $fp, $sp, 28                                             # Set frame pointer

    # Save arguments
    addi $s0, $a0, 0                                               # $s0 = str (preserve original)
    addi $s1, $a1, 0                                               # $s1 = map

    # Calculate string length (strlen)
    addi $t0, $zero, 0                                             # $t0 = length counter
    addi $t1, $s0, 0                                               # $t1 = current char pointer

strlen_loop:
    lb   $t2, 0($t1)                                               # Load current character
    beq  $t2, $zero, strlen_done                                   # If null terminator, exit
    addi $t0, $t0, 1                                               # Increment length
    addi $t1, $t1, 1                                               # Move to next character
    j    strlen_loop

strlen_done:
    addi $t0, $t0, 1                                               # Add 1 for null terminator

    # Round up to nearest multiple of 4
    addi $t3, $t0, 3                                               # t3 = len + 3
    addi $t9, $zero, 0xFFFF                                        # t9 = 0xFFFF
    sll  $t9, $t9, 16                                              # t9 = 0xFFFF0000
    addi $t9, $t9, 0xFFFC                                          # t9 = 0xFFFFFFFC
    and  $t3, $t3, $t9                                             # Round down to multiple of 4
    sub  $t4, $t3, $t0                                             # Calculate padding needed
    sub  $sp, $sp, $t3                                             # Allocate space on stack

    # Perform substitution
    addi $t1, $s0, 0                                               # $t1 = str pointer
    addi $t2, $sp, 0                                               # $t2 = dup pointer
    addi $t5, $zero, 0                                             # $t5 = i = 0

subs_loop:
    lb   $t6, 0($t1)                                               # Load str[i]
    beq  $t6, $zero, subs_done                                     # If null terminator, exit
    
    # Map lookup: map[str[i]]
    add  $t7, $s1, $t6                                             # $t7 = map + str[i]
    lb   $t8, 0($t7)                                               # $t8 = map[str[i]]
    
    sb   $t8, 0($t2)                                               # Store in dup[i]
    addi $t1, $t1, 1                                               # Increment str pointer
    addi $t2, $t2, 1                                               # Increment dup pointer
    addi $t5, $t5, 1                                               # Increment counter
    j    subs_loop

subs_done:
    sb   $zero, 0($t2)                                             # Null-terminate dup string
    
    addi $s2, $t3, 0

    addi   $v0, $zero, 4     # print_str(MSG1)
	la     $a0, printSubstitutedString__MSG1
	syscall

    addi $a0, $sp, 0                                               # $a0 = dup
    syscall

    addi   $v0, $zero,11                                           # print_char('\n')
	addi   $a0, $zero,'\n'
	syscall

    # Deallocate stack space
    add  $sp, $sp, $s2                                             # Restore stack pointer

    # Function Epilogue
    lw    $ra, 0($sp)                                              # Restore return address
    lw    $fp, 4($sp)                                              # Restore frame pointer
    lw    $s0, 8($sp)                                              # Restore $s0
    lw    $s1, 12($sp)                                             # Restore $s1
    lw    $s2, 16($sp)                                             # Restore $s2
    addiu $sp, $sp, 32                                             # Deallocate stack space
    jr    $ra                                                      # Return
