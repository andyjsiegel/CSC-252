str = "  This string is just six words long "
inWord = False
count = 0
for char in str:
    if char == ' ' and inWord:
        inWord = False
    elif char != ' ' and not inWord:
        count += 1
        inWord = True


    
# print(count)

# .word	93
	# .word	91
	# .word	81
	# .word	81
	# .word	80
	# .word	73
	# .word	63
	# .word	60
	# .word	59
	# .word	58
	# .word	55
	# .word	39
	# .word	30
	# .word	22
	# .word	6
	# .word	4

# array = [91,81,81,80,73,63,60,59,58,55,39,30,22,6,4]
# array = [1,1,1,1,1,1,1,1]
array = [4,3,2,1,1,2,3,4]
is_ascending = True
is_descending = True

for i in range(len(array)-1):
    if array[i] < array[i+1]:
        is_ascending = is_ascending and True
        is_descending = is_descending and False
    elif array[i] > array[i+1]:
        is_ascending = is_ascending and False
        is_descending = is_descending and True

# print(is_ascending)
# print(is_descending)

if not is_ascending and not is_descending:
    print("Run Check: NEITHER")
        