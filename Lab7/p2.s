.text

# void toggle_light(int row, int col, LightsOut* puzzle, int action_num){
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int num_colors = puzzle->num_colors;
#     unsigned char* board = (puzzle-> board);
#     board[row*num_cols + col] = (board[row*num_cols + col] + action_num) % num_colors;
#     if (row > 0){
#         board[(row-1)*num_cols + col] = (board[(row-1)*num_cols + col] + action_num) % num_colors;
#     }
#     if (col > 0){
#         board[(row)*num_cols + col-1] = (board[(row)*num_cols + col-1] + action_num) % num_colors;
#     }
#     
#     if (row < num_rows - 1){
#         board[(row+1)*num_cols + col] = (board[(row+1)*num_cols + col] + action_num) % num_colors;
#     }
# 
#     if (col < num_cols - 1){
#         board[(row)*num_cols + col+1] = (board[(row)*num_cols + col+1] + action_num) % num_colors;
#     }
# }
# $a0 row
# $a1 col
# $a2 puzzle
# $a3 action_num

.globl toggle_light
toggle_light:
	lw	$t3, 0($a2)		# num_rows = puzzle->num_rows
	lw      $t4, 4($a2)             # num_cols = puzzle->num_cols
	lw      $t5, 8($a2)             # num_colors = puzzle->num_colors
	add	$t6, $a2, 12		# char* board = puzzle->board

	mul	$t0, $a0, $t4		# row*num_cols
	add	$t0, $t0, $a1		# row*num_cols + col
	add	$t2, $t6, $t0		# &board[row*num_cols + col]
	lbu	$t1, 0($t2)		# board[row*num_cols + col] 
	add	$t1, $t1, $a3		# board[row*num_cols + col] + action_num
	rem	$t1, $t1, $t5		# board[row*num_cols + col] + action_num % num_colors
	sb	$t1, 0($t2)		# board[row*num_cols + col] = result
		
if_one:
	ble	$a0, $zero, if_two	# !(row > 0)
	add	$t0, $a0, -1		# row - 1
	mul     $t0, $t0, $t4           # (row - 1)*num_cols
	add     $t0, $t0, $a1           # (row - 1)*num_cols + col
	add     $t2, $t6, $t0           # &board[(row - 1)*num_cols + col]
	lbu     $t1, 0($t2)             # board[(row - 1)*num_cols + col]
	add     $t1, $t1, $a3           # board[(row - 1)*num_cols + col] + action_num
	rem     $t1, $t1, $t5           # board[(row - 1)*num_cols + col] + action_num % num_colors
	sb      $t1, 0($t2)             # board[(row - 1)*num_cols + col] = result

if_two:
	ble     $a1, $zero, if_three    # !(col > 0)	
	mul     $t0, $a0, $t4           # row*num_cols
	add     $t0, $t0, $a1           # row*num_cols + col
	add	$t0, $t0, -1		# row*num_cols + col - 1
	add     $t2, $t6, $t0           # &board[row*num_cols + col - 1]
	lbu     $t1, 0($t2)             # board[row*num_cols + col - 1]
	add     $t1, $t1, $a3           # board[row*num_cols + col - 1] + action_num
	rem     $t1, $t1, $t5           # board[row*num_cols + col - 1] + action_num % num_colors 
	sb      $t1, 0($t2)             # board[row*num_cols + col - 1] = result

if_three:
	add 	$t2, $t3, -1		# num_rows - 1
	bge 	$a0, $t2, if_four	# !(row < num_rows - 1)
	
	add     $t0, $a0, 1             # row + 1
	mul     $t0, $t0, $t4           # (row + 1)*num_cols
	add     $t0, $t0, $a1           # (row + 1)*num_cols + col
	add     $t2, $t6, $t0           # &board[(row + 1)*num_cols + col]
	lbu     $t1, 0($t2)             # board[(row + 1)*num_cols + col]
	add     $t1, $t1, $a3           # board[(row + 1)*num_cols + col] + action_num
	rem     $t1, $t1, $t5           # board[(row + 1)*num_cols + col] + action_num % num_colors
	sb      $t1, 0($t2)             # board[(row + 1)*num_cols + col] = result

if_four:
	add	$t2, $t4, -1		# num_cols - 1 
	bge 	$a1, $t2, tl_end	# !(col < num_cols - 1) 

	mul     $t0, $a0, $t4           # row*num_cols
	add     $t0, $t0, $a1           # row*num_cols + col
	add     $t0, $t0, 1             # row*num_cols + col + 1
	add     $t2, $t6, $t0           # &board[row*num_cols + col + 1]
	lbu     $t1, 0($t2)             # board[row*num_cols + col + 1]
	add     $t1, $t1, $a3           # board[row*num_cols + col + 1] + action_num
	rem     $t1, $t1, $t5           # board[row*num_cols + col + 1] + action_num % num_colors
	sb      $t1, 0($t2)             # board[row*num_cols + col + 1] = result

tl_end:
	jr	$ra



# bool solve(LightsOut* puzzle, unsigned char* solution, int row, int col){
#     int num_rows = puzzle->num_rows; 
#     int num_cols = puzzle->num_cols;
#     int num_colors = puzzle->num_colors;
#     int next_row = ((col == num_cols-1) ? row + 1 : row);
#     if (row >= num_rows || col >= num_cols) {
#          return board_done(num_rows,num_cols,puzzle->board);
#     }
# 
#     for(char actions = 0; actions < num_colors; actions++) {
#         solution[row*num_cols + col] = actions;
#         toggle_light(row, col, puzzle, actions);
#         if (solve(puzzle,solution, next_row, (col + 1) % num_cols)) {
#             return true;
#         }
#         toggle_light(row, col, puzzle, num_colors - actions); 
#         solution[row*num_cols + col] = 0;
#     }
#     return false;
# }
# $a0 puzzle
# $a1 solution
# $a2 row
# $a3 col

.globl solve
solve:
	sub     $sp, $sp, 36            # alloc
	sw      $ra, 0($sp)             # save $ra
	sw      $s0, 4($sp)             # save $s0
	sw      $s1, 8($sp)             # save $s1
	sw      $s2, 12($sp)            # save $s2
	sw      $s3, 16($sp)            # save $s3
	sw	$s4, 20($sp)		# save $s4
	sw	$s5, 24($sp)		# save $s5
	sw	$s6, 28($sp)		# save $s6
	sw	$s7, 32($sp)		# save $s7
	
	move	$s0, $a0		# store puzzle
	move	$s1, $a1		# store solution
	move 	$s2, $a2		# store row
	move 	$s3, $a3		# store col
	lw      $t4, 0($a0)             # num_rows = puzzle->num_rows
	lw      $t5, 4($a0)             # num_cols = puzzle->num_cols
	lw      $t6, 8($a0)             # num_colors = puzzle->num_colors
	add     $s6, $a0, 12            # char* board = puzzle->board 
	add	$s7, $a0, 268		# bool* clue = puzzle->clue
	li	$s5, 0			# action = 0
	
next_row_if:
	add	$t2, $t5, -1		# num_cols - 1
	bne  	$s3, $t2, next_row_nif  # !(col == num_cols - 1)
	add	$t2, $s2, 1		# row + 1
	move	$s4, $t2		# next_row = row + 1
	j 	sif_one		

next_row_nif:	
	move	$s4, $s2		# next_row = row

sif_one:
	slt	$t2, $s2, $t4		# !(row >= num_rows)
	slt	$t3, $s3, $t5		# !(col >= num_cols)
	and	$t2, $t2, $t3		# !(row >= num_rows) && !(col >= num_cols)
	bne	$t2, $zero, sif_two	# !(row >= num_rows) && !(col >= num_cols)
	move	$a0, $t4		# $a0 = num_rows
	move	$a1, $t5		# $a1 = num_cols
	move 	$a2, $s6		# $a2 = puzzle -> board
	jal	solver_board_done	# board_done(num_rows,num_cols,puzzle->board)
	move	$v0, $v0
	j	s_end			

sif_two:
	mul	$t2, $s2, $t5		# row*num_cols
	add	$t2, $t2, $s3		# row*num_cols + col
	add	$t3, $s7, $t2		# &clue[row*num_cols + col]
	lbu	$t2, 0($t3)		# clue[row*num_cols + col]
	beq	$t2, $zero, loop	# !(clue[row*num_cols + col])
	add	$t2, $s3, 1		# col + 1
	rem	$t2, $t2, $t5		# (col + 1) % num_cols
	move	$a0, $s0		# $a0 = puzzle
	move	$a1, $s1		# $a1 = solution
	move	$a2, $s4		# $a2 = next_row
	move	$a3, $t2		# $a3 = (col + 1) % num_cols 
	jal	solve			# solve(puzzle,solution, next_row, (col + 1) % num_cols)
	move	$v0, $v0
	j 	s_end		

loop:
	bge	$s5, $t6, return_false	# !(actions < num_colors)
	mul	$t2, $s2, $t5		# row*num_cols
	add	$t2, $t2, $s3		# row*num_cols + col  
	add	$t3, $s1, $t2		# &solution[row*num_cols + col]
	sb	$s5, 0($t3)		# solution[row*num_cols + col] = actions
	move	$a0, $s2		# $a0 = row
	move	$a1, $s3		# $a1 = col
	move	$a2, $s0		# $a2 = puzzle
	move	$a3, $s5		# $a3 = actions
	jal	toggle_light
	lw      $t4, 0($s0)             # num_rows = puzzle->num_rows
	lw      $t5, 4($s0)             # num_rows = puzzle->num_cols 
	lw      $t6, 8($s0)             # num_rows = puzzle->num_colors 

	add     $t2, $s3, 1             # col + 1
	rem     $t2, $t2, $t5           # (col + 1) % num_cols
	move    $a0, $s0                # $a0 = puzzle
	move    $a1, $s1                # $a1 = solution
	move    $a2, $s4                # $a2 = next_row
	move    $a3, $t2                # $a3 = (col + 1) % num_cols
	jal     solve                   # solve(puzzle,solution, next_row, (col + 1) % num_cols)
	lw      $t4, 0($s0)             # num_rows = puzzle->num_rows 
	lw      $t5, 4($s0)             # num_rows = puzzle->num_cols
	lw      $t6, 8($s0)             # num_rows = puzzle->num_colors
	move	$v0, $v0
	bne	$v0, $zero, return_true	# return true
	
	sub	$t2, $t6, $s5		# num_colors - actions
	move    $a0, $s2                # $a0 = row
	move    $a1, $s3                # $a1 = col
	move    $a2, $s0                # $a2 = puzzle
	move    $a3, $t2                # $a3 = num_colors - actions
	jal	toggle_light
	lw      $t4, 0($s0)             # num_rows = puzzle->num_rows
	lw      $t5, 4($s0)             # num_rows = puzzle->num_cols
	lw      $t6, 8($s0)             # num_rows = puzzle->num_colors

	mul     $t2, $s2, $t5           # row*num_cols
	add     $t2, $t2, $s3           # row*num_cols + col
	add     $t3, $s1, $t2           # &solution[row*num_cols + col]
	sb	$zero, 0($t3)		# solution[row*num_cols + col] = 0
	add	$s5, $s5, 1		# action++
	j	loop		

return_true:
	li	$v0, 1			# return false
	j 	s_end

return_false:
	li	$v0, 0		
	j 	s_end	
s_end:
	lw      $s7, 32($sp)            # restore $s5
	lw      $s6, 28($sp)            # restore $s5
	lw 	$s5, 24($sp)		# restore $s5
	lw	$s4, 20($sp)		# restore $s4
	lw      $s3, 16($sp)            # restore $s3 
	lw      $s2, 12($sp)            # restore $s2
	lw      $s1, 8($sp)             # restore $s1
	lw      $s0, 4($sp)             # restore $s0
	lw      $ra, 0($sp)             # restore $ra
	add     $sp, $sp, 36            # dealloc  
	jr      $ra
