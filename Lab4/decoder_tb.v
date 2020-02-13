module decoder_test;
    reg [5:0] opcode, funct;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

             opcode = `OP_OTHER0; funct = `OP0_ADD;  // try addition
        # 10 opcode = `OP_OTHER0; funct = `OP0_ADDU; // try unsigned addition
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB;  // try subtraction
        # 10 opcode = `OP_OTHER0; funct = `OP0_AND;  // try and
        # 10 opcode = `OP_OTHER0; funct = `OP0_OR;   // try or
        # 10 opcode = `OP_OTHER0; funct = `OP0_NOR;  // try nor
	# 10 opcode = `OP_OTHER0; funct = `OP0_XOR;  // try xor
      
        # 10 opcode = `OP_ADDI;                      // try add immediate 
        # 10 opcode = `OP_ADDIU;                     // try add unsigned immediate
	# 10 opcode = `OP_ANDI;                      // try and immediate 
	# 10 opcode = `OP_ORI;                       // try or immediate
	# 10 opcode = `OP_XORI;                      // try xor immediate

	# 10 opcode = `OP_OTHER1;                    // try exception   
	# 10 opcode = `OP0_ADD;                      // try exception
	# 10 opcode = `OP_OTHER0; funct = `OP_ADDI;  // try exception
	# 10 opcode = `OP0_SUB; funct = `OP_OTHER0;  // try exception 
	# 10 funct = `OP_XORI; 			     // try exception
	# 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire [1:0] alu_src2; 
    wire       rd_src, writeenable, except;
    mips_decode decoder(rd_src, writeenable, alu_src2, alu_op, except,
                        opcode, funct);
endmodule // decoder_test
