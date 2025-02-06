.globl studentMain
studentMain:
    addiu $sp, $sp, -24               # allocate stack space -- default of 24 here
    sw    $fp, 0($sp)                 # save caller’s frame pointer
    sw    $ra, 4($sp)                 # save return address
    addiu $fp, $sp, 20                # setup main’s frame pointer

.data 
    IS_EQUALS:      .asciiz "EQUALS\n"
    NOTHING_EQUALS: .asciiz "NOTHING EQUALS\n"
    IS_REVERSE:     .asciiz "REVERSE\n"
    IS_PRINT:       .asciiz "PRINT\n"
    RED_HEADER:     .asciiz "red: "
    ORANGE_HEADER:  .asciiz "orange: "
    YELLOW_HEADER:  .asciiz "yellow: "
    GREEN_HEADER:   .asciiz "green: "
    BLUE_HEADER:    .asciiz "blue: "    
    PURPLE_HEADER:  .asciiz "purple: "
    NEWLINE:        .asciiz "\n"
    ASCENDING:      .asciiz "ASCENDING\n"
    DESCENDING:     .asciiz "DESCENDING\n"
    UNORDERED:      .asciiz "UNORDERED\n"
    ALL_EQUAL:      .asciiz "ALL EQUAL\n"

.text 
    # read 4 variables; equals, order, reverse, and print; either 1 or 0.
    # additional 6 variables: red, orange, yellow, green, blue, purple
    
    la $t0, equals
    lb $t0, 0($t0)
    la $t1, order
    lb $t1, 0($t1)
    la $t2, reverse
    lb $t2, 0($t2)
    la $t3, print
    lb $t3, 0($t3)
    
    if_equals:
        beq $t0, $zero, if_order       # if equals is 0, skip to order

        la $t4, red
        lb $t4, 0($t4)
        la $t5, orange
        lb $t5, 0($t5)
        la $t6, yellow
        lb $t6, 0($t6)
        la $t7, green
        lb $t7, 0($t7)

        beq $t4, $t5, eq
        beq $t4, $t6, eq
        beq $t4, $t7, eq
        beq $t5, $t6, eq
        beq $t5, $t7, eq
        beq $t6, $t7, eq

        j nothing_eq

    eq:
        addi $v0, $zero, 4
        la   $a0, IS_EQUALS
        syscall
        j if_order
    nothing_eq:
        addi $v0, $zero, 4
        la   $a0, NOTHING_EQUALS
        syscall

    if_order:
        beq $t1, $zero, if_reverse     # if order is 0, skip to reverse
            
        la $t9, red                    # load address of red
        lw $s0, 0($t9)                 # load red value
        la $t0, orange                 # load address of orange
        lw $s1, 0($t0)                 # load orange value
        la $t0, yellow                 # load address of yellow
        lw $s2, 0($t0)                 # load yellow value
        la $t0, green                  # load address of green
        lw $s3, 0($t0)                 # load green value
        la $t0, blue                   # load address of blue
        lw $s4, 0($t0)                 # load blue value
        la $t0, purple                 # load address of purple
        lw $s5, 0($t0)                 # load purple value
        
        # check if all colors are equal
        
        bne $s0, $s1, not_equal        # if red != orange, go to not_equal
        bne $s1, $s2, not_equal        # if orange != yellow, go to not_equal
        bne $s2, $s3, not_equal        # if yellow != green, go to not_equal
        bne $s3, $s4, not_equal        # if green != blue, go to not_equal
        bne $s4, $s5, not_equal        # if blue != purple, go to not_equal
       	j all_equal
            
    not_equal:

        slt $t5, $s0, $s1              # $t5 = red < orange
        slt $t6, $s1, $s2              # $t6 = orange < yellow
        slt $t7, $s2, $s3              # $t7 = yellow < green
        slt $t8, $s3, $s4              # $t8 = green < blue
        slt $t9, $s4, $s5              # $t9 = blue < purple
        
        # combine all results
        or $s6, $t5, $t6               # red < orange || orange < yellow
        or $s6, $s6, $t7               # prev || yellow < green
        or $s6, $s6, $t8               # prev || green < blue
        or $s6, $s6, $t9               # prev || blue < purple
        
        # if the final OR in the last line is 0, then red >= orange >= yellow >= green >= blue >= purple
        # which means the list is descending.
        beq $s6, $zero, descending

        slt $t5, $s1, $s0              # orange < red
        slt $t6, $s2, $s1              # yellow < orange
        slt $t7, $s3, $s2              # green < yellow
        slt $t8, $s4, $s3              # blue < green
        slt $t9, $s5, $s4              # purple < blue

        # combine all results
        or $s7, $t5, $t6               # orange < red || yellow < orange
        or $s7, $s7, $t7               # prev || green < yellow
        or $s7, $s7, $t8               # prev || blue < green
        or $s7, $s7, $t9               # prev || purple < blue

        # more logically: purple < blue || blue < green || green < yellow || yellow < orange || orange < red
        # if $s7 is still zero, then red >= orange >= yellow >= green >= blue >= purple which means the list is ascending.
        
        beq $s7, $zero, ascending
        # if we haven't jumped to ascending or descending, print unordered and jump to reverse check

        # Print unordered message
        addi $v0, $zero, 4             # Syscall for printing string
        la   $a0, UNORDERED            # Load address of "UNORDERED" string
        syscall  
        j if_reverse                   # Jump to reverse check
                
    ascending:
        addi $v0, $zero, 4             # Syscall for printing string
        la   $a0, ASCENDING            # Load address of "ASCENDING" string
        syscall  
        j if_reverse                   # Jump to reverse check
            
    descending:
        addi $v0, $zero, 4             # Syscall for printing string
        la   $a0, DESCENDING           # Load address of "DESCENDING" string
        syscall  
        j if_reverse                   # Jump to reverse check

    all_equal:
        addi $v0, $zero, 4             # Syscall for printing string
        la   $a0, ALL_EQUAL            # Load address of "ALL EQUAL" string
        syscall  

    if_reverse:
        beq $t2, $zero, if_print       # if reverse is 0, skip to print
        addi $v0, $zero, 4             # prepare to print
        la   $a0, IS_REVERSE           # load address of "REVERSE"
        syscall                        # print "REVERSE"

        la $t9, red                    # load address of red
        lw $t9, 0($t9)                 # load red value
        la $t8, orange                 # load address of orange
        lw $t8, 0($t8)                 # load orange value
        la $t7, yellow                 # load address of yellow
        lw $t7, 0($t7)                 # load yellow value
        la $t6, green                  # load address of green
        lw $t6, 0($t6)                 # load green value
        la $t5, blue                   # load address of blue
        lw $t5, 0($t5)                 # load blue value
        la $t4, purple                 # load address of purple
        lw $t4, 0($t4)                 # load purple value

        # Reverse the values and store them back

        la $t0, purple                 # load address of purple
        sw $t9, 0($t0)                 # store red in purple
        la $t0, blue                   # load address of blue
        sw $t8, 0($t0)                 # store orange in blue
        la $t0, green                  # load address of green
        sw $t7, 0($t0)                 # store yellow in green  
        la $t0, yellow                 # load address of yellow
        sw $t6, 0($t0)                 # store green in yellow
        la $t0, orange                 # load address of orange  
        sw $t5, 0($t0)                 # store blue in orange  
        la $t0, red                    # load address of red  
        sw $t4, 0($t0)                 # store purple in red        
       
    if_print:
        beq $t3, $zero, end_if         # if print is 0, skip to end_if

        la $t9, red                    # load address of red
        lw $s0, 0($t9)                 # load red value
        la $t0, orange                 # load address of orange
        lw $s1, 0($t0)                 # load orange value
        la $t0, yellow                 # load address of yellow
        lw $s2, 0($t0)                 # load yellow value
        la $t0, green                  # load address of green
        lw $s3, 0($t0)                 # load green value
        la $t0, blue                   # load address of blue
        lw $s4, 0($t0)                 # load blue value
        la $t0, purple                 # load address of purple
        lw $s5, 0($t0)                 # load purple value

        # Print each color and its value

        addi $v0, $zero, 4             # Print string
        la   $a0, RED_HEADER           # Load address of "red: "
        syscall                        

        addi $v0, $zero, 1             # Print integer
        add  $a0, $zero, $s0           # Load red value
        syscall                        

        addi $v0, $zero, 4             # Print string
        la   $a0, NEWLINE              # Load address of newline
        syscall                        

        addi $v0, $zero, 4             # Print string
        la   $a0, ORANGE_HEADER        # Load address of "orange: "
        syscall                        

        addi $v0, $zero, 1             # Print integer
        add  $a0, $zero, $s1           # Load orange value
        syscall                        

        addi $v0, $zero, 4             # Print string
        la   $a0, NEWLINE              # Load address of newline
        syscall                        

        addi $v0, $zero, 4             # Print string
        la   $a0, YELLOW_HEADER        # Load address of "yellow: "
        syscall                        

        addi $v0, $zero, 1             # Print integer
        add  $a0, $zero, $s2           # Load yellow value
        syscall                        
        
        addi $v0, $zero, 4             # Print string
        la   $a0, NEWLINE              # Load address of newline
        syscall                        

        addi $v0, $zero, 4             # Print string
        la   $a0, GREEN_HEADER         # Load address of "green: "
        syscall                        

        addi $v0, $zero, 1             # Print integer
        add  $a0, $zero, $s3           # Load green value
        syscall                       

        addi $v0, $zero, 4             # Print string
        la   $a0, NEWLINE              # Load address of newline
        syscall                        

        addi $v0, $zero, 4             # Print string
        la   $a0, BLUE_HEADER          # Load address of "blue: "
        syscall                        

        addi $v0, $zero, 1             # Print integer
        add  $a0, $zero, $s4           # Load blue value
        syscall                        

        addi $v0, $zero, 4             # Print string
        la   $a0, NEWLINE              # Load address of newline
        syscall

        addi $v0, $zero, 4             # Print string
        la   $a0, PURPLE_HEADER        # Load address of "purple: "
        syscall                        

        addi $v0, $zero, 1             # Print integer
        add  $a0, $zero, $s5           # Load purple value
        syscall

    end_if:
        lw $ra, 4($sp)                 # get return address from stack
        lw $fp, 0($sp)                 # restore the caller’s frame pointer
        addiu $sp, $sp, 24             # restore the caller’s stack pointer
        jr $ra                         # return to caller’s code