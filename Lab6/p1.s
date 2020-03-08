.text

# // Ignore integer overflow for addition
# int update_alert_level(unsigned int* stockpiles, unsigned int cutoff,
#   unsigned int alert_level) {
#     int total_monster = 0;
#     for (int i = 0; i < 10; i++) {
#         total_monster += stockpiles[i];
#     }
#     if (total_monster < cutoff) {
#         return alert_level + 1;
#     } else if (total_monster == cutoff) {
#         return alert_level;
#     } else {
#         return alert_level - 1;
#     }
# }
# // a0: unsigned int *stockpiles
# // a1: unsigned int cutoff
# // a2: unsigned int alert_level

.globl update_alert_level
update_alert_level:
	li   $t0, 0 			# i = 0
	li   $t1, 0			# total_monster = 0
	li   $t2, 10			# store 10 into $t2 for i < 10

ual_for:
	bge  $t0, $t2, ual_if		# !(i < 10)
	sll  $t3, $t0, 2 		# i * 4
	add  $t3, $a0, $t3		# &stockpiles[i]
	lw   $t3, 0($t3)		# stockpiles[i]
	add  $t1, $t1, $t3		# total_monster += stockpiles[i]
	add  $t0, $t0, 1		# i++
	j    ual_for		
	
ual_if:
	bge  $t1, $a1, ual_else_if 	# !(total_monster < cutoff)
	add  $v0, $a2, 1		# return alert_level + 1 	
	j    ual_end

ual_else_if:
	bne  $t1, $a1, ual_else 	# !(total_monster == cutoff)
	move $v0, $a2			# return alert_level
	j    ual_end
ual_else:
	add  $v0, $a2, -1		# return alert_level - 1

ual_end:
	jr	$ra
