//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
	// Unsigned addition overflow = 0
        # 10 A = 32'hffffffff; B = 1; control = `ALU_UADD;      
	// Signed addition no overflow
	# 10 A = 32'he1065830; B = 32'h40529453; control = `ALU_ADD;
	// Signed addition overflow two pos
	# 10 A = 32'h7fffffff; B = 1; control = `ALU_ADD;
	// Signed addition overflow two neg
	# 10 A = 32'h80000000; B = 32'h80000000; control = `ALU_ADD;
        // Signed subtraction no overflow
	# 10 A = 32'h80000010; B = 32'h80000000; control = `ALU_SUB;
	// Signed subtraction overflow
	# 10 A = 32'h80000000; B = 1; control = `ALU_SUB;
	// Signed subtraction overflow sub large neg from large pos
	# 10 A = 32'h7fffffff; B = 32'h80000000; control = `ALU_SUB;
	// Signed subtraction from itself
	# 10 A = 6; B = 6; control = `ALU_SUB;
	// Signed subtraction huge from small
	# 10 A = 36; B = 32'h7ffffff0; control = `ALU_SUB;
	// AND to 0
	# 10 A = 7; B = 0; control = `ALU_AND; 
        // AND no change
	# 10 A = 32'h66920602; B = 32'hffffffff; control = `ALU_AND;
        // OR to 1s
	# 10 A = 6; B = 32'hffffffff; control = `ALU_OR;
        // NOR 0 nor 0
	# 10 A = 0; B = 0; control = `ALU_NOR;
        // NOR to 0
	# 10 A = 32'hfffffff7; B = 32'hffffffff; control = `ALU_NOR;	
	// XOR 
	# 10 A = 5; B = 7; control = `ALU_XOR;
	# 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);

endmodule // alu32_test
