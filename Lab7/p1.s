.text

# // part 1 p1.s
# unsigned char find_payment(TreeNode* trav) { 
# 	// Base case
# 	if (trav == NULL) {
# 		return 0;
# 	}
# 	// Recurse once for each child
# 	unsigned char payment_left = find_payment(trav->left);
# 	unsigned char payment_center = find_payment(trav->center);
# 	unsigned char payment_right = find_payment(trav->right);
# 	unsigned char value = payment_left + payment_center + payment_right + trav->value;
# 	return value / 2;
# }

.globl find_payment
find_payment:
	li 	$v0, 0			# return 0

fp_if:
	bne	$a0, $zero, fp_recurse
	jr	$ra

fp_recurse:
	sub     $sp, $sp, 16            # alloc
	sw      $ra, 0($sp)             # store $ra
	sw      $s0, 4($sp)             # store $s0
	sw      $s1, 8($sp)             # store $s1
	sw      $s2, 12($sp)            # store $s2
	
	move	$s0, $a0		# store $a0
	lb	$s2, 12($s0)		# store trav->value
	
	lw      $s1, 0($s0)             # TreeNode* trav->left 
	move    $a0, $s1		# $a0 = trav->left
	jal	find_payment		# find_payment(trav->left)
	add	$s2, $s2, $v0		# value += payment_left

	lw      $s1, 4($s0)             # TreeNode* trav->center
	move	$a0, $s1		# $a0 = trav->center
	jal     find_payment            # find_payment(trav->center)
	add     $s2, $s2, $v0           # $ value += payment_center 

	lw	$s1, 8($s0)		# TreeNode* trav->right
	move    $a0, $s1		# $a0 = trav->right
	jal	find_payment		# find_payment(trav->right)
	add     $s2, $s2, $v0           # value += payment_right 

	srl	$v0, $s2, 1	        # value / 2	

fp_end:
	lw      $s2, 12($sp)     	# restore $s2
	lw      $s1, 8($sp)     	# restore $s1
	lw      $s0, 4($sp)     	# restore $s0
	lw    	$ra, 0($sp)     	# restore $ra
	add 	$sp, $sp, 16 		# dealloc
	jr 	$ra
