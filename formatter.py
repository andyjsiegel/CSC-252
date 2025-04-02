file_path = "/Users/andysiegel/Library/CloudStorage/GoogleDrive-andyjsiegel1@gmail.com/My Drive/University/Semester 4/CSC 252/2025_02_26_Assembly_Project_3/asm3.s"
modified_lines = []
file_name = file_path.split('/')[-2] + "/" + file_path.split('/')[-1]
only_file_name = file_name.split('/')[-1]

# align registers after operators
with open(file_name, "r") as f:
    lines = f.readlines()

    i = 0
    while i < len(lines):
        # If the current line does not contain an operand, simply store it.
        if '$' not in lines[i] or lines[i].strip().startswith('#'):
            if lines[i].strip().startswith('j'):
                leading_spaces = len(lines[i]) - len(lines[i].lstrip())
                modified_lines.append(' ' * leading_spaces + ' '.join(lines[i].split()))
            else:
                modified_lines.append(lines[i])
            i += 1
            continue

        # We've found a block that uses the operand.
        block = []
        while i < len(lines) and '$' in lines[i]:
            block.append(lines[i])
            i += 1

        # For each line, extract the leading indentation and the operand text.
        # The operand is the part before the first '$'.
        op_texts = []
        for line in block:
            prefix = line.split('$', 1)[0]
            # Save the operand text (after removing indentation and trailing spaces)
            op_text = prefix.strip()
            op_texts.append(op_text)

        max_op_length = max(len(op) for op in op_texts)

        # Reassemble each line in the block using the original indentation,
        # the left-justified operator text padded to max_op_length, exactly 1 space, then the '$' and the rest.
        for idx, line in enumerate(block):
            parts = line.split('$', 1)
            prefix = parts[0]
            indent = prefix[:len(prefix) - len(prefix.lstrip())]  # preserve indentation
            op_text = prefix.lstrip().rstrip()
            formatted_op = op_text.ljust(max_op_length)
            new_line = indent + formatted_op + ' $' + parts[1]
            modified_lines.append(new_line)

# fix jal and j operators to align with the previous line
for idx, line in enumerate(modified_lines): 
    # process j and jal operators
    if line.strip().startswith('jal'):
        modified_lines[idx] = modified_lines[idx].split('jal')[0] + 'jal' + (' ' * (len(modified_lines[idx-1].split('$',1)[0].lstrip())-4)) + modified_lines[idx].split('jal')[1] + "\n"
    elif line.strip().startswith('j') and not line.strip().startswith('jr'):
        modified_lines[idx] = modified_lines[idx].split('j')[0] + 'j' + (' ' * (len(modified_lines[idx-1].split('$',1)[0].lstrip())-2)) + modified_lines[idx].split('j')[1] + "\n"


fixed_asciiz_lines = []
longest_length_asciiz = max(len(line.split(".asciiz")[0]) for line in lines if ".asciiz" in line)
for line in modified_lines:
    if ".asciiz" in line:
        fixed_asciiz_lines.append(line.split(".asciiz")[0].ljust(longest_length_asciiz) + ".asciiz " + line.split(".asciiz")[1])
    else:
        fixed_asciiz_lines.append(line)

lines = fixed_asciiz_lines
longest_line_len = 0
longest_line_number = 0
align_comment_lines = []
for i, line in enumerate(lines, start=1):
    # ignore lines that start with # (comments)
    if line.strip().startswith("#"):
        continue
    # Extract content before any inline comment, and remove trailing spaces
    content = line.split('#')[0].strip()
    if len(content) > longest_line_len:
        longest_line_len = len(content)
        longest_line_number = i  # update with the current line number

for line in lines:
    if line.strip().startswith("#"):
        align_comment_lines.append(line)
        continue
    if not('#' in line):
        align_comment_lines.append(line)
        continue
    align_comment_lines.append(line.split('#')[0].ljust(longest_line_len+4, ' ') + '#' + line.split('#')[1])

for line in align_comment_lines:
    print(line,end="")

with open(f'formatted_{only_file_name}', 'w') as file:
    # Write each string to the file followed by a newline
    for string in align_comment_lines:
        file.write(string)

