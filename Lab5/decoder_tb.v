module decoder_test;
    reg [5:0] opcode, funct;
    reg       zero  = 0;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

        // remember that all your instructions from last week should still work
             opcode = `OP_OTHER0; funct = `OP0_ADD; // see if addition still works
        # 10 opcode = `OP_OTHER0; funct = `OP0_ADDU; // try unsigned addition
	# 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // see if subtraction still works
        # 10 opcode = `OP_OTHER0; funct = `OP0_AND;  // try and
	# 10 opcode = `OP_OTHER0; funct = `OP0_OR;   // try or  
	# 10 opcode = `OP_OTHER0; funct = `OP0_NOR;  // try no
	# 10 opcode = `OP_OTHER0; funct = `OP0_XOR;  // try xor
	
	# 10 opcode = `OP_ADDI;                      // try add immediate 
	# 10 opcode = `OP_ADDIU;                     // try add unsigned immediate
	# 10 opcode = `OP_ANDI;                      // try and immediate
	# 10 opcode = `OP_ORI;                       // try or immediate
	# 10 opcode = `OP_XORI;                      // try xor immediate
	
	# 10 opcode = `OP_OTHER1;                    // try exception
	# 10 opcode = `OP0_ADD;                      // try exception   
	# 10 opcode = `OP0_SUB; funct = `OP_OTHER0;  // try exception
	# 10 funct = `OP_XORI;                       // try exception
	// test all of the others here
        
        // as should all the new instructions from this week
        # 10 opcode = `OP_BEQ; zero = 0; 	    // try a not taken beq (exception)
        # 10 opcode = `OP_BEQ; zero = 1; 	    // try a taken beq
	# 10 opcode = `OP_BNE; zero = 0; 	    // try a taken bne
	# 10 opcode = `OP_BNE; zero = 1; 	    // try a not taken bne (exception)
	
	# 10 opcode = `OP_J;			    // try jump
	# 10 opcode = `OP_OTHER0; funct = `OP0_JR;  // try jump register
	
	# 10 opcode = `OP_LUI;			    // try lui
	# 10 opcode = `OP_OTHER0; funct = `OP0_SLT; // try slt

	# 10 opcode = `OP_LW; 			    // try lw
	# 10 opcode = `OP_LBU;			    // try lbu
	# 10 opcode = `OP_SW;			    // try sw
	# 10 opcode = `OP_SB; 			    // try sb
	
	# 10 opcode = `OP_OTHER0; funct = `OP0_ADDM;// try addm (only wr_en should be 1 there should be another two muxs controling addm's functionality)
	
        // add more tests here!

        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire [1:0] alu_src2;
    wire       writeenable, rd_src, except;
    wire [1:0] control_type;
    wire       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                        mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                        opcode, funct, zero);
endmodule // decoder_test
