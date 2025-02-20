.globl studentMain
studentMain:
    addiu $sp, $sp, -24                 # allocate stack space -- default of 24 here
    sw    $fp, 0($sp)                   # save caller’s frame pointer
    sw    $ra, 4($sp)                   # save return address
    addiu $fp, $sp, 20                  # setup main’s frame pointer

.data
    FIBONACCI_HEADER:  .asciiz "Fibonacci Numbers:\n"
    FIB_FIRST:         .asciiz "  0: 1\n"
    FIB_SECOND:        .asciiz "  1: 1\n"
    FIB_SPACES:        .asciiz "  "
    FIB_MIDDLE:        .asciiz ": "
    NEWLINE:           .asciiz "\n"
    RUN_CHECK_ASC:     .asciiz "Run Check: ASCENDING\n"
    RUN_CHECK_DESC:    .asciiz "Run Check: DESCENDING\n"
    RUN_CHECK_NEITHER: .asciiz "Run Check: NEITHER\n"
    WORD_COUNT:        .asciiz "Word Count: "
    SWAP_SUCCESS:      .asciiz "\nString successfully swapped!\n"

.text
    la $t0, fib
    lb $s0, 0($t0)

    la $t0, square
    lb $s1, 0($t0)

    la $t0, runCheck
    lb $s2, 0($t0)

    la $t0, countWords
    lb $s3, 0($t0)

    la $t0, revString
    lb $s4, 0($t0)

    fibonacci:
        beq $s0, $zero, square_print              # if (fib == 0) goto square_print
        addi $t0, $zero, 1                        # prev = 1
        addi $t1, $zero, 1                        # beforeThat = 1
        addi $t2, $zero, 2                        # n = 2
        
        # print("Fibonacci Numbers:\n")
        addi $v0, $zero, 4                        # print the header
        la   $a0, FIBONACCI_HEADER
        syscall

        addi $v0, $zero, 4
        la   $a0, FIB_FIRST
        syscall

        addi $v0, $zero, 4
        la $a0, FIB_SECOND
        syscall

        beq $s0, $t0, square_print      # if (fib == 1) goto square_print

        fib_loop:
            # print the current value of n
            add $t3, $t0, $t1           # cur = prev + beforeThat
            # printf("  %d: %d\n", n, cur);
            
            # print "  "
            addi $v0, $zero, 4
            la   $a0, FIB_SPACES
            syscall

            # print n
            addi $v0, $zero, 1
            add $a0, $zero, $t2
            syscall

            # print ": "
            addi $v0, $zero, 4
            la   $a0, FIB_MIDDLE
            syscall

            # print cur
            addi $v0, $zero, 1
            add  $a0, $zero, $t3
            syscall

            # print "\n"
            addi $v0, $zero, 4
            la   $a0, NEWLINE
            syscall

            addi $t2, $t2, 1            # n++
            add $t1, $zero, $t0         # beforeThat = prev
            add $t0, $zero, $t3         # prev = cur

            # if (t2 <= s0), branch to fib_loop
            slt $t9, $s0, $t2
            beq $t9, $zero, fib_loop

            addi $v0, $zero, 4
            la   $a0, NEWLINE
            syscall

    square_print:
        beq $s1, $zero, run_check       # if (square == 0) goto run_check
        la $t0, square_size             # t0 = &square_size
        lw $t0, 0($t0)                  # t0 = square_size  
        addi $t0, $t0, -1               # t0 = square_size - 1
        la $t1, square_fill             # t1 = &square_fill
        lw $t1, 0($t1)                  # t1 = square_fill 
        addi $t2, $zero, 0              # int row = 0
        # addi $t9, $zero, 1              # int cell = 1
        square_outer_loop:
            # for (int row=0; row < square_size; row++)
            # char lr, mid
            # addi $t6, $t0, -2
            beq $t2, $zero, first_or_last_row
            beq $t2, $t0, first_or_last_row
            
            j not_first_or_last_row

            first_or_last_row:
                addi $t4, $zero, '+'     # lr = '+'
                addi $t5, $zero, '-'     # mid = '-'
                j begin_loop
            
            not_first_or_last_row:
                addi $t4, $zero, '|'     # lr = '|'
                add $t5, $zero, $t1      # mid = square_fill
            
            begin_loop:
            # printf("%c", lr);
            addi $v0, $zero, 11          # syscall for print character
            add $a0, $zero, $t4
            syscall

            addi $t9, $zero, 1          # i = 1
            # for (int i=1; i<square_size-1; i++)
            square_inner_loop:
                # printf("%c", mid);
                addi $v0, $zero, 11      # syscall for print character
                add $a0, $zero, $t5
                syscall

                addi $t9, $t9, 1         # i++
                addi $t7, $t0, 0
                slt $t8, $t9, $t7         # if (i < square_size - 1)
                bne $t8, $zero, square_inner_loop # if i < square_size - 1, goto square_inner_loop
            
            addi $v0, $zero, 11          # syscall for print character
            add $a0, $zero, $t4
            syscall

            # print newline
            addi $v0, $zero, 4,          # syscall for print word
            la $a0, NEWLINE
            syscall
            
            slt $t3, $t2, $t0            # if t3 == 1, then row < square_size
            addi $t2, $t2, 1             # row++
            bne $t3, $zero, square_outer_loop # if row < square_size, goto square_outer_loop
        
        addi $v0, $zero, 4
        la   $a0, NEWLINE
        syscall

    run_check:
        beq $s2, $zero, count_words     # if (runCheck == 0) goto count_words
        la $s6, intArray_len            # s6 = &intArray_len
        lw $s6, 0($s6)                  # s6 = intArray_len
        beq $s6, $zero, print_asc_and_desc # if intArray_len == 0; goto print_asc_and_desc
        addi $s6, $s6, -1               # s6 = intArray_len - 1
        addi $t1, $zero, 1              # isAscending = 1
        addi $t2, $zero, 1              # isDescending = 1

        # s7 = &intArray
        addi $t0, $zero, 0              # int i = 0
        la $s7, intArray
        
        run_check_loop:
            beq $s6, $zero, print_asc_and_desc # if intArray_len-1 == 0; goto print_asc_and_desc
            lw $t6, 0($s7)              # t6 = intArray[i]
            lw $t7, 4($s7)              # t7 = intArray[i + 1]
            
            # if (t6 < t7), branch to check_ascending
            slt $t8, $t6, $t7           
            bne $t8, $zero, check_ascending       # branch if t6 < t7
            
            # if (t6 > t7), branch to check_descending
            slt $t8, $t7, $t6
            bne $t8, $zero, check_descending       # branch if t6 > t7

            addi $t0, $t0, 1            # i++
            addi $s7, $s7, 4            # shift intArray address by 4 bits to access i + 1 and i + 2 on next iteration
            slt $t9, $t0, $s6           # t9 = i < intArray_len-1
            bne $t9, $zero, run_check_loop # if i < intArray_len-1; loop.

            and $t3, $t1, $t2           # t3 = isAscending & isDescending
            beq $t3, $zero, check_neither # if neither isAscending or isDescending, goto check_neither

            addi $v0, $zero, 4          # print "Run Check: ASCENDING"
            la $a0, RUN_CHECK_ASC
            syscall

            addi $v0, $zero, 4
            la $a0, RUN_CHECK_DESC
            syscall

            j count_words

        check_ascending:
            addi $t0, $t0, 1            # i++

            andi $t1, $t1, 1            # isAscending = isAscending & 1
            andi $t2, $t2, 0            # isDescending = isDescending & 0

            addi $s7, $s7, 4            # shift intArray address by 4 bits to access i + 1 and i + 2 on next iteration
            bne $t0, $s6, run_check_loop # if i < intArray_len-1; loop.

            beq $t1, $zero, check_descending # if isAscending == 0; goto check_descending

            addi $v0, $zero, 4          # print "Run Check: ASCENDING"
            la $a0, RUN_CHECK_ASC
            syscall

            addi $v0, $zero, 4          # print "\n"
            la $a0, NEWLINE
            syscall

            j count_words

        check_descending:
            addi $t0, $t0, 1            # i++

            andi $t1, $t1, 0            # isAscending = isAscending & 0
            andi $t2, $t2, 1            # isDescending = isDescending & 1

            addi $s7, $s7, 4            # shift intArray address by 4 bits to access i + 1 and i + 2 on next iteration
            slt $t9, $t0, $s6           # t9 = i < intArray_len-1
            bne $t9, $zero, run_check_loop # if i < intArray_len-1; loop.

            beq $t2, $zero, check_neither # if checkDescending == 0; goto check_neither
            
            addi $v0, $zero, 4
            la $a0, RUN_CHECK_DESC
            syscall

            addi $v0, $zero, 4          # print "\n"
            la $a0, NEWLINE
            syscall

            j count_words

        check_neither:
            and $t3, $t1, $t2           # t3 = isAscending & isDescending
            bne $t3, $zero, count_words # if neither isAscending or isDescending, print "Run Check: NEITHER"

            addi $v0, $zero, 4          # print "Run Check: NEITHER"
            la $a0, RUN_CHECK_NEITHER
            syscall

            addi $v0, $zero, 4          # print "\n"
            la $a0, NEWLINE
            syscall

            j count_words

        print_asc_and_desc:
            addi $v0, $zero, 4          # print "Run Check: ASCENDING"
            la $a0, RUN_CHECK_ASC
            syscall

            addi $v0, $zero, 4          # print "Run Check: DESCENDING"
            la $a0, RUN_CHECK_DESC
            syscall

            addi $v0, $zero, 4          # print "\n"
            la $a0, NEWLINE            
            syscall
            

    count_words:
        beq $s3, $zero, reverse_string  # if (countWords == 0) goto reverse_string
        la $t0, str                     # Load address of the string
        addi $t1, $zero, 0              # count = 0
        addi $t2, $zero, '\0'           # t2 = '\0'
        addi $t4, $zero, ' '            # t4 = ' '
        addi $t5, $zero, '\n'           # t5 = '\n'
        addi $t6, $zero, 0              # t6 = 0; inWord flag; t6 = 1 if inWord
        
        count_words_loop:
            lb $t3, 0($t0)              # Load char from string
            beq $t3, $t4, char_is_whitespace    # if char is ' ' or '\n', goto char_is_whitespace
            beq $t3, $t5, char_is_whitespace    
            beq $t3, $t2, exit_count_words_loop # if char is null terminator, goto exit_count_words_loop

            bne $t6, $zero, repeat_count_words_loop

            addi $t1, $t1, 1            # Increment count of words
            addi $t6, $zero, 1
            addi $t0, $t0, 1
            j count_words_loop          # Repeat the loop
        
        char_is_whitespace:
            bne $t6, $zero, inword_true
            addi $t0, $t0, 1            # Increment address of string
            j count_words_loop          # Repeat the loop

        inword_true:
            addi $t6, $zero, 0          # Set inWord flag to 0
            addi $t0, $t0, 1            # Increment address of string
            j count_words_loop          # Repeat the loop

        repeat_count_words_loop:
            addi $t0, $t0, 1            # Increment address of string
            j count_words_loop          # Repeat the loop


        exit_count_words_loop:
        
        addi $v0, $zero, 4          # Set syscall up for printing word
        la $a0, WORD_COUNT          # Load word count message
        syscall

        addi $v0, $zero, 1          # Set syscall up for printing number
        add $a0, $zero, $t1         # print number of words
        syscall

        addi $v0, $zero, 4          # Set syscall up for printing newline
        la $a0, NEWLINE             # Load newline character
        syscall

        addi $v0, $zero, 4
        la $a0, NEWLINE
        syscall

    reverse_string:
        beq $s4, $zero, end_tasks       # if (revString == 0) goto end_tasks
        addi $t0, $zero, '\0'
        addi $t1, $zero, 0              # i = 0
        la $t2, str                     # Load address of the string
        addi $t4, $zero, ' '            # Space character
        addi $t5, $zero, '\n'           # Newline character
        addi $s5, $zero, 0              # head = 0
        addi $s6, $zero, 0              # tail = 0

    reverse_string_first_loop:
        lb $t3, 0($t2)                  # Load byte from string
        beq $t3, $t0, reverse_string_next  # if t3 is ending string character, go to skip
        addi $t2, $t2, 1                 # Iterate through string
        addi $s6, $s6, 1                 # tail++
        j reverse_string_first_loop      # Repeat the loop

    reverse_string_next:
        addi $s6, $s6, -1                # tail--
        la $t2, str

    reverse_string_second_loop:
        slt $s7, $s5, $s6                # s7 = (head < tail)
        beq $s7, $zero, print_reverse_string # If head >= tail, go to print

        # Swap characters at head and tail
        add $t8, $t2, $s5                # Address of str[head]
        add $t9, $t2, $s6                # Address of str[tail]

        lb $t7, 0($t8)                   # Load character at head
        lb $t6, 0($t9)                   # Load character at tail

        sb $t6, 0($t8)                   # Store tail character at head
        sb $t7, 0($t9)                   # Store head character at tail

        addi $s5, $s5, 1                  # head++
        addi $s6, $s6, -1                 # tail--

        j reverse_string_second_loop      # Repeat the loop

    print_reverse_string:
        addi $v0, $zero, 4               # Print string syscall
        la $a0, SWAP_SUCCESS              # Load success message
        syscall

        addi $v0, $zero, 4               # Print newline syscall
        la $a0, NEWLINE                   # Load newline character
        syscall

    end_tasks:
        lw $ra, 4($sp)                  # get return address from stack
        lw $fp, 0($sp)                  # restore the caller’s frame pointer
        addiu $sp, $sp, 24              # restore the caller’s stack pointer
        jr $ra                          # return to caller’s code