# Assembly Project 4 - CSC 252 Spring 2025
# Author: Andy Siegel
# This project implements a turtle "class/struct".
# turtle_init initializes a turtle object in memory.
# turtle_debug prints the turtle object to the console.
# turtle_turnLeft turns the turtle left by 90 degrees.
# turtle_turnRight turns the turtle right by 90 degrees.
# turtle_move moves the turtle in the current direction 
# by the given distance and updates the odometer.
# turtle_searchName searches the turtle array for a turtle
# with the given name and returns the index of the found turtle or -1 if not found.
# turtle_sortByX_indirect sorts the turtle array by each turtle's x coordinate using bubble sort.
.data
header:    .asciiz "Turtle "
pos:       .asciiz "  pos "
dir:       .asciiz "  dir "
odometer:  .asciiz "  odometer "
north:     .asciiz "North"
east:      .asciiz "East"
south:     .asciiz "South"
west:      .asciiz "West"

.text
# void turtle_init(Turtle *obj, char *name) {
#     obj->x = 0;                     // Initialize x position to 0
#     obj->y = 0;                     // Initialize y position to 0
#     obj->dir = 0;                   // Initialize direction to 0
#     obj->pad = 0;                   // Initialize padding to 0
#     obj->name = name;               // Duplicate the name string
#     obj->odometer = 0;              // Initialize odometer to 0
# }
.globl turtle_init
turtle_init:
    # Function Prologue
    addiu $sp, $sp, -24                                            # Allocate space on the stack
    sw    $ra, 4($sp)                                              # Save the return address
    sw    $fp, 0($sp)                                              # Save the original frame pointer
    addiu $fp, $sp, 20

    addi $t0, $a0, 0                                               # t0 = *turtle
    addi $t1, $a1, 0                                               # t1 = *name
    # lw   $t1, 0($t1)                                             # t1 = name

    sb $zero, 0($t0)                                               # turtle[0] = 0 (x = 0)
    sb $zero, 1($t0)                                               # turtle[1] = 0 (y = 0)
    sb $zero, 2($t0)                                               # turtle[2] = 0 (dir = 0)
    sb $zero, 3($t0)                                               # turtle[3] = 0 (pad = 0)
    sw $t1,   4($t0)                                               # turtle[4] = name
    sw $zero, 8($t0)                                               # turtle[8] = 0 (odometer = 0)

    # Function Epilogue
    lw    $ra, 4($sp)                                              # Restore the return address
    lw    $fp, 0($sp)                                              # Restore frame pointer
    addiu $sp, $sp, 24                                             # Deallocate space on the stack
    jr    $ra  

# void turtle_debug(Turtle *obj) {
#     printf(Turtle "%s\n", obj->name);
#     printf("  pos %d,%d\n", obj->x,obj->y);
#     printf("  dir %s\n", obj->dir == 0 ? "North" : obj->dir == 1 ? "East" : obj->dir == 2 ? "South" : "West");
#     printf("  odometer %d\n", obj->odometer);
# }
.globl turtle_debug
turtle_debug:
    # Function Prologue
    addiu $sp, $sp, -24                                            # Allocate space on the stack
    sw    $ra, 4($sp)                                              # Save the return address
    sw    $fp, 0($sp)                                              # Save the original frame pointer
    addiu $fp, $sp, 20

    addi $t0, $a0, 0                                               # t0 = *turtle
    
    la   $a0, header                                               # print "Turtle"
    addi $v0, $zero, 4                                             # print string syscall
    syscall

    addi $a0, $zero, 34                                            # print `"`
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    lw   $a0, 4($t0)                                               # print turtle.name
    addi $v0, $zero, 4                                             # print string syscall
    syscall

    addi $a0, $zero, 34                                            # print `"`
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    addi $a0, $zero, 10                                            # print "\n"
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    la   $a0, pos                                                  # print "  pos "
    addi $v0, $zero, 4                                             # print string syscall
    syscall

    lb   $a0, 0($t0)                                               # print turtle.x
    addi $v0, $zero, 1                                             # print integer syscall
    syscall

    addi $a0, $zero, 44                                            # print ","
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    lb   $a0, 1($t0)                                               # print turtle.y
    addi $v0, $zero, 1                                             # print integer syscall
    syscall

    addi $a0, $zero, 10                                            # print "\n"
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    la   $a0, dir                                                  # print "  dir "
    addi $v0, $zero, 4                                             # print string syscall
    syscall

    lb   $t1, 2($t0)                                               # t1 = turtle.dir
    beq  $t1, $zero, load_north                                    # if (turtle.dir == 0) goto load_north
    addi $t2, $zero, 1                                             # t2 = 1
    beq  $t1, $t2, load_east                                       # if (turtle.dir == 1) goto load_east
    addi $t2, $zero, 2                                             # t2 = 2
    beq  $t1, $t2, load_south                                      # if (turtle.dir == 2) goto load_south
    addi $t2, $zero, 3                                             # t2 = 3
    beq  $t1, $t2, load_west                                       # if (turtle.dir == 3) goto load_west\

load_north:
    la   $a0, north                                                # print "North"
    addi $v0, $zero, 4                                             # print string syscall
    syscall
    j print_odometer

load_east:
    la   $a0, east                                                 # print "East"
    addi $v0, $zero, 4                                             # print string syscall
    syscall
    j print_odometer

load_south:
    la   $a0, south                                                # print "South"
    addi $v0, $zero, 4                                             # print string syscall
    syscall
    j print_odometer

load_west:
    la   $a0, west                                                 # print "West"
    addi $v0, $zero, 4                                             # print string syscall
    syscall
    j print_odometer

print_odometer:
    addi $a0, $zero, 10                                            # print "\n"
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    la   $a0, odometer                                             # print "  odometer "
    addi $v0, $zero, 4                                             # print string syscall
    syscall

    lw   $a0, 8($t0)                                               # print turtle.odometer 
    addi $v0, $zero, 1                                             # print integer syscall
    syscall

    addi $a0, $zero, 10                                            # print "\n"
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    addi $a0, $zero, 10                                            # print "\n"
    addi $v0, $zero, 11                                            # print char syscall
    syscall

    # Function Epilogue
    lw    $ra, 4($sp)                                              # Restore the return address
    lw    $fp, 0($sp)                                              # Restore frame pointer
    addiu $sp, $sp, 24                                             # Deallocate space on the stack
    jr    $ra 
    

# void turtle_turnLeft(Turtle *obj) {
#     obj->dir = (obj->dir + 1) % 4;  // Increment the direction by 1 and wrap around to 0
# }
.globl turtle_turnLeft
turtle_turnLeft:
    # Function Prologue
    addiu $sp, $sp, -24                                            # Allocate space on the stack
    sw    $ra, 4($sp)                                              # Save the return address
    sw    $fp, 0($sp)                                              # Save the original frame pointer
    addiu $fp, $sp, 20

    addi $t0, $a0, 0                                               # t0 = *turtle

    # get dir
    lb   $t1, 2($t0)                                               # t1 = turtle[2] (turtle.dir)
    addi $t1, $t1, -1                                              # t1 = turtle[2] - 1 (decrement dir)
    andi $t1, $t1, 0x03                                            # t1 = t1 & 0x03 (bitwise AND to keep only bottom 2 bits)
    sb   $t1, 2($t0)                                               # turtle[2] = t1

     # Function Epilogue
    lw    $ra, 4($sp)                                              # Restore the return address
    lw    $fp, 0($sp)                                              # Restore frame pointer
    addiu $sp, $sp, 24                                             # Deallocate space on the stack
    jr    $ra 

# void turtle_turnRight(Turtle *obj) {
#     obj->dir = (obj->dir - 1) % 4;  // Decrement the direction by 1 and wrap around to 0  
# }
.globl turtle_turnRight
turtle_turnRight:
    # Function Prologue
    addiu $sp, $sp, -24                                            # Allocate space on the stack
    sw    $ra, 4($sp)                                              # Save the return address
    sw    $fp, 0($sp)                                              # Save the original frame pointer
    addiu $fp, $sp, 20

    addi $t0, $a0, 0                                               # t0 = *turtle

    # get dir
    lb   $t1, 2($t0)                                               # t1 = turtle[2] (turtle.dir)
    addi $t1, $t1, 1                                               # t1 = turtle[2] + 1 (increment dir)
    andi $t1, $t1, 0x03                                            # t1 = t1 & 0x03 (bitwise AND to keep only bottom 2 bits)
    sb   $t1, 2($t0)                                               # turtle[2] = t1

     # Function Epilogue
    lw    $ra, 4($sp)                                              # Restore the return address
    lw    $fp, 0($sp)                                              # Restore frame pointer
    addiu $sp, $sp, 24                                             # Deallocate space on the stack
    jr    $ra 

# void turtle_move(Turtle *obj, int dist) {
#     int x = obj->x;
#     int y = obj->y;
#     int dir = obj->dir;
#     int odometer = obj->odometer;
#     if(dir == 0) {
#         y += dist;
#     } else if(dir == 1) {
#         x += dist;
#     } else if(dir == 2) {
#         y -= dist;
#     } else if(dir == 3) {
#         x -= dist;
#     }
#     if(x > 10) {
#         x = 10;
#     } else if(x < -10) {
#         x = -10;
#     } else if(y > 10) {
#         y = 10;
#     } else if(y < -10) {
#         y = -10;
#     }
#     obj->x = x;
#     obj->y = y;
#     obj->odometer += abs(dist);
# }
.globl turtle_move
turtle_move:
    # Function Prologue
    addiu $sp, $sp, -24                                            # Allocate space on the stack
    sw    $ra, 4($sp)                                              # Save the return address
    sw    $fp, 0($sp)                                              # Save the original frame pointer
    addiu $fp, $sp, 20

    addi $t0, $a0, 0                                               # t0 = *turtle
    addi $t1, $a1, 0                                               # t1 = dist (t1 = input distance)

    # Get direction
    lb   $t2, 2($t0)                                               # t2 = turtle.dir
    sub  $t3, $zero, $t1                                           # t3 = -t1 (negate dist)
    lb   $t4, 0($t0)                                               # t4 = turtle.x
    lb   $t5, 1($t0)                                               # t5 = turtle.y
    lw   $t6, 8($t0)                                               # t6 = turtle.odometer
    add  $t9, $t1, $zero                                           # t9 = dist

    # Handle distance sign
    slt $t7, $t1, $zero                                            # t7 = 1 if dist < 0, else 0
    beq $t7, $zero, move_beqs                                      # if dist >= 0, go to move_beqs
    sub $t9, $zero, $t9                                            # t9 = -t9 (take absolute value for odometer)

move_beqs:
    # Move in the current direction
    add  $t9, $t6, $t9                                             # t9 = turtle.odometer + dist 
    sw   $t9, 8($t0)                                               # turtle.odometer = t9   

    beq  $t2, $zero, move_north                                    # if (turtle.dir == 0) goto move_north
    addi $t8, $zero, 1                                             # t8 = 1
    beq  $t2, $t8, move_east                                       # if (turtle.dir == 1) goto move_east
    addi $t8, $zero, 2                                             # t8 = 2
    beq  $t2, $t8, move_south                                      # if (turtle.dir == 2) goto move_south
    addi $t8, $zero, 3                                             # t8 = 3
    beq  $t2, $t8, move_west                                       # if (turtle.dir == 3) goto move_west

move_north:
    add $t5, $t5, $t1                                              # t5 = t5 + t1 (y += dist)
    j   check_bounds_y                                             # Check bounds for y

move_east:
    add $t4, $t4, $t1                                              # t4 = t4 + t1 (x += dist)
    j   check_bounds_x                                             # Check bounds for x

move_south:
    add $t5, $t5, $t3                                              # t5 = t5 + t3 (y -= dist)
    j   check_bounds_y                                             # Check bounds for y

move_west:
    add $t4, $t4, $t3                                              # t4 = t4 + t3 (x -= dist)
    j   check_bounds_x                                             # Check bounds for x

# Check bounds for turtle's y coordinate
check_bounds_y:
    addi $t8, $zero, -10                                           # t8 = -10
    slt $t7, $t5, $t8                                              # Set t7 if y (t5) < -10
    bne $t7, $zero, cap_y_lower                                    # If y < -10, cap it
    addi $t8, $zero, 10                                            # Load lower bound (-10)
    slt $t7, $t8, $t5                                              # Set t7 if y > 10
    bne $t7, $zero, cap_y_upper                                    # If y <= 10, jump to update
    j   move_update

cap_y_lower:
    addi $t5, $zero, -10                                           # Now t5 = -10
    j    move_update

cap_y_upper:
    addi $t5, $zero, 10                                            # Now t5 = 10
    j    move_update

# Check bounds for turtle's x coordinate
check_bounds_x:
    addi $t8, $zero, -10                                           # Load lower bound (-10)
    slt  $t7, $t4, $t8                                             # Set t7 if x < -10
    bne  $t7, $zero, cap_x_lower                                   # If x < -10, cap it
    addi $t8, $zero, 10                                            # Load upper bound (10)
    slt  $t7, $t8, $t4                                             # Set t7 if x > 10
    bne  $t7, $zero, cap_x_upper                                   # If x <= 10, jump to update
    j    move_update

cap_x_lower:
    addi $t4, $zero, -10                                           # Now t4 = -10
    j    move_update

cap_x_upper:
    addi $t4, $zero, 10                                            # Now t4 = 10
    j move_update

move_update:
    sb   $t5, 1($t0)                                               # Update turtle.y
    sb   $t4, 0($t0)                                               # Update turtle.x

    # Function Epilogue
    lw    $ra, 4($sp)                                              # Restore the return address
    lw    $fp, 0($sp)                                              # Restore frame pointer
    addiu $sp, $sp, 24                                             # Deallocate space on the stack
    jr    $ra                                                      # Return from function

# int turtle_searchName(Turtle *arr, int arrLen, char *needle) {
#     int i = 0;
#     int found = -1;
#     while (i < arrLen && !found) {
#         if (strcmp(arr[i].name, needle) == 0) {
#             found = 1;
#         }
#         i++;
#     }
#     return found;
# }
.globl turtle_searchName
turtle_searchName:
    # Function Prologue
    addiu $sp, $sp, -24                                            # Allocate space on the stack
    sw    $ra, 4($sp)                                              # Save the return address
    sw    $fp, 0($sp)                                              # Save the original frame pointer
    addiu $fp, $sp, 20                                            # Set frame pointer

    # save $s0, $s1, $s2 on the stack 
    addiu $sp, $sp, -20		
    sw    $s0, 0($sp)
    sw    $s1, 4($sp)
    sw    $s2, 8($sp)
    sw    $s3, 12($sp)
    sw    $s4, 16($sp)

    addi $s0, $a0, 0                                               # s0 = *turtle[0] (first element of the array)
    addi $s1, $a1, 0                                               # s1 = arrLen (length of the array)
    addi $s2, $a2, 0                                               # s2 = *needle
    addi $s3, $zero, 0                                             # s3 = i = 0
    
turtle_searchName_loop:
    slt $s4, $s3, $s1                                              # if (i < arrLen) then s4 = 1; else s4 = 0.
    beq $s4, $zero, turtle_searchName_notFound                   # if s4 = 0 goto turtle_searchName_notFound
    
    # Prepare arguments for strcmp
    addi $a0, $s4, 4                                                 # a0 = turtle[i].name 
    addi $a1, $a2, 0
    jal  strcmp                                                   # Call strcmp(a0, a1)
    
    beq  $v0, $zero, turtle_searchName_found                    # if (strcmp(a0, a1) == 0) then goto turtle_searchName_found
    
    addi $s0, $s0, 12                                             # Move to next turtle (increment by size of Turtle structure)
    addi $s3, $s3, 1                                              # i++
    j    turtle_searchName_loop                                   # Repeat the loop

turtle_searchName_found:
    addi $v0, $s3, 0                                             # return index of found element
    j    turtle_searchName_epilogue                              # goto turtle_searchName_epilogue

turtle_searchName_notFound:
    addi $v0, $zero, -1                                          # return -1
    j    turtle_searchName_epilogue                              # goto turtle_searchName_epilogue

turtle_searchName_epilogue:
    # retrieve values of $s0, ..., $s4 from the stack
    lw    $s4, 16($sp)
    lw    $s3, 12($sp)
    lw    $s2, 8($sp)
    lw    $s1, 4($sp)
    lw    $s0, 0($sp)
    addiu $sp, $sp, 20

    # Function Epilogue
    lw    $ra, 4($sp)                                           # Restore the return address
    lw    $fp, 0($sp)                                           # Restore frame pointer
    addiu $sp, $sp, 24                                          # Deallocate space on the stack
    jr    $ra                                                   # Return from function


# void turtle_sortByX_indirect(Turtle **arr, int arrLen) {
#     int i = 0;
#     int j = 0;
#     int temp = 0;
#     while (i < arrLen - 1) {
#         for (j = 0; j < arrLen - 1 - i; j++) {
#             if (arr[j].x > arr[j + 1].x) {
#                 temp = arr[j].x;
#                 arr[j].x = arr[j + 1].x;
#                 arr[j + 1].x = temp;
#             }
#         }
#         i++;
#     }
# }
.globl turtle_sortByX_indirect
turtle_sortByX_indirect:
    # Function Prologue
    addiu $sp, $sp, -24                                            # Allocate space on the stack
    sw    $ra, 4($sp)                                              # Save the return address
    sw    $fp, 0($sp)                                              # Save the original frame pointer
    addiu $fp, $sp, 20                                             # Set frame pointer
                           
    addi $t0, $a0, 0                                               # $t0 = arr (array of Turtle pointers)
    addi $t1, $a1, 0                                               # $t1 = arrLen (length of the array)
    
    # Outer loop for bubble sort
    addi $t2, $zero, 0                                             # $t2 = i = 0 (outer loop index)
outer_loop:
    addi $t3, $zero, 0                                             # $t3 = j = 0 (inner loop index)
    addi $t4, $t1, -1                                              # $t4 = arrLen - 1 (limit for inner loop)   

inner_loop:
    # Compare Turtle[x] with Turtle[x + 1]
    add $t5, $t0, $t3                                              # $t5 = arr[j]
    lw  $t6, 0($t5)                                                # Load pointer to Turtle[j]
    lb  $t7, 0($t6)                                                # Load x coordinate of Turtle[j]
                           
    addi $t3, $t3, 4                                               # Move to next pointer (4 bytes)
    add  $t8, $t0, $t3                                             # $t8 = arr[j + 1]
    lw   $t9, 0($t8)                                               # Load pointer to Turtle[j + 1]
    lb   $s0, 0($t9)                                               # Load x coordinate of Turtle[j + 1]
                           
    # Compare x coordinates                           
    slt $s1, $s0, $t7                                              # $s1 = (Turtle[j + 1].x < Turtle[j].x)
    beq $s1, $zero, no_swap                                        # If not less, skip swap

    # Swap pointers if Turtle[j + 1].x < Turtle[j].x
    sw $t8, 0($t5)                                                 # arr[j] = arr[j + 1]
    sw $t5, 0($t8)                                                 # arr[j + 1] = arr[j]
                           
no_swap:                           
    addi $t3, $t3, 4                                               # Increment j
    slt  $s1, $t3, $t4                                             # Check if j < arrLen - 1
    bne  $s1, $zero, inner_loop                                    # If true, continue inner loop
                           
    addi $t2, $t2, 1                                               # Increment i
    slt  $s1, $t2, $t4                                             # Compare i with arrLen - 1
    bne  $s1, $zero, outer_loop                                    # If true, continue outer loop
                           
    # Function Epilogue                           
    lw    $ra, 4($sp)                                              # Restore the return address
    lw    $fp, 0($sp)                                              # Restore frame pointer
    addiu $sp, $sp, 24                                             # Deallocate space on the stack
    jr    $ra                                                      # Return from function

