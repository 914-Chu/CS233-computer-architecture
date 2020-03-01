.text

# void matrix_mult(int *matr_a, int *matr_b, int *output, unsigned int width) {
#     for (int i = 0; i < width; i++) {
#         for (int j = 0; j < width; j++) {
#             output[i*width + j] = 0;
#             for (int k = 0; k < width; k++) {
#                 output[i*width + j] += matr_a[i*width + k] * matr_b[k*width + j];
#             }
#         }
#     }
# }
#
# // a0: int *matr_a
# // a1: int *matr_b
# // a2: int *output
# // a3: unsigned int width

.globl matrix_mult
matrix_mult:
	sub	$sp, $sp, 16		# alloc
	sw	$ra, 0($sp)		# save $ra 
	sw	$s0, 4($sp)		# save $s0
	sw      $s1, 8($sp)             # save $s1
	sw      $s2, 12($sp)            # save $s2
	li	$s0, 0			# i = 0
	
i_loop:
	li	$s1, 0			# j = 0 restart

j_loop: 
	li	$s2, 0			# k = 0

	mul	$t0, $s0, $a3		# i*width
	add 	$t0, $t0, $s1		# i*width + j
	mul	$t0, $t0, 4		# (i*width + j)*4
	add	$t0, $a2, $t0		# &output[i*width + j]
	sw	$zero, 0($t0)		# output[i*width + j] = 0 

k_loop: 
	mul	$t1, $s0, $a3	 	# i*width
	add     $t1, $t1, $s2		# i*width + k
	mul 	$t1, $t1, 4		# (i*width + k)*4
	add	$t1, $a0, $t1		# &matr_a[i*width + k]
	lw	$t1, 0($t1)		# matr_a[i*width + k]

	mul	$t2, $s2, $a3		# k*width
	add	$t2, $t2, $s1		# k*width + j
	mul	$t2, $t2, 4		# (k*width + j)*4
	add	$t2, $a1, $t2		# &matr_b[k*width + j]	
	lw      $t2, 0($t2)             # matr_b[k*width + j]
	
	mul	$t3, $t1, $t2		# matr_a[i*width + k] * matr_b[k*width + j];
	lw	$t4, 0($t0)		# output[i*width + j] 
	add	$t4, $t4, $t3		# output[i*width + j] + matr_a[i*width + k] * matr_b[k*width + j];
	sw	$t4, 0($t0)		# output[i*width + j] +=	

	add 	$s2, $s2, 1		# k++
	blt	$s2, $a3, k_loop	# k < width
	
	add	$s1, $s1, 1		# j++
	blt	$s1, $a3, j_loop	# j < width
	
	add	$s0, $s0, 1		# i++
	blt 	$s0, $a3, i_loop	# i < width
mm_end:	
	lw	$s2, 12($sp)		# restore $s2
	lw 	$s1, 8($sp)		# restore $s1
	lw	$s0, 4($sp)		# restore $s0
	lw 	$ra, 0($sp)		# restore $ra
	add	$sp, $sp, 16		# dealloc
	jr	$ra


# #define MAX_WIDTH 100
# int working_matrix[MAX_WIDTH*MAX_WIDTH];

# void markov_chain(int *state, int *transitions, unsigned int width, int times) {
#     for (int i = 0; i < times; i++) {
#         matrix_mult(state, transitions, working_matrix, width);
#         copy(state, working_matrix);
#     }
# }
#
# // a0: int *state
# // a1: int *transitions
# // a2: unsigned int width
# // a3: int times

.globl markov_chain
markov_chain:
	# Can access working_matrix from p2_main.s
	sub 	$sp, $sp, 20		# alloc
	sw 	$ra, 0($sp)		# save $ra
	sw      $s0, 4($sp)             # save $s0
	sw      $s1, 8($sp)		# save $s1
	sw 	$s2, 12($sp)		# save $s2
	sw	$s3, 16($sp)		# save $s3

	li	$s0, 0			# i = 0
	move 	$s1, $a1		# store transitions
	move 	$s2, $a2		# store width
	move 	$s3, $a3 		# store times
	

mc_for:
	bge	$s0, $s3, mc_end	# !(i < times)
	move 	$a1, $s1		# copy transition into $a1
	la	$a2, working_matrix	# load working_matrix into $a2
	move	$a3, $s2		# copy width into $a3
  	jal	matrix_mult
 	move	$a1, $a2		# copy working_matrix into $a1
	move 	$a2, $s2		# copy width into $a2
	jal	copy	
	add	$s0, $s0, 1		# i++
	j	mc_for		
				
mc_end:
	lw	$s3, 16($sp)		# restore $s3
	lw	$s2, 12($sp)		# restore $s2
	lw	$s1, 8($sp)		# restore $s1
	lw      $s0, 4($sp)            	# restore $s0
	lw      $ra, 0($sp)            	# restore $ra
	add     $sp, $sp, 20	        # dealloc
	jr	$ra
	
