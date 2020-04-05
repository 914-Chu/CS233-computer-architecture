module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_if, PC_plus4_if, PC_plus4_de, PC_target; //next_PC, PC_plus4, PC_target;
    wire [31:0]  inst_if, inst_de; //inst

    wire [31:0]  imm = {{ 16{inst_de[15]} }, inst_de[15:0] };  // sign-extended immediate
    //imm = {{ 16{inst[15]} }, inst[15:0] };
    wire [4:0]   rs = inst_de[25:21]; //inst[25:21];
    wire [4:0]   rt = inst_de[20:16]; //inst[20:16];
    wire [4:0]   rd = inst_de[15:11]; //inst[15:11];
    wire [5:0]   opcode = inst_de[31:26]; //inst[31:26];
    wire [5:0]   funct = inst_de[5:0]; //inst[5:0];

    wire [4:0]   wr_regnum_de, wr_regnum_mw;
    wire [2:0]   ALUOp;

    wire         RegWrite_de, RegWrite_mw, BEQ, ALUSrc, MemRead_de, MemRead_mw, MemWrite_de, MemWrite_mw, MemToReg_de, MemToReg_mw, RegDst;
    //RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, rd2_data_de, rd2_data_mw, A_data, B_data, alu_out_data_de, alu_out_data_mw, load_data, wr_data;
    wire ForwardA = RegWrite_mw & (wr_regnum_mw != 5'b0) & (wr_regnum_mw == rs);
    wire ForwardB = RegWrite_mw & (wr_regnum_mw != 5'b0) & (wr_regnum_mw == rt);
    wire Stall = MemRead_mw & (wr_regnum_mw != 5'b0) & ((wr_regnum_mw == rs) | ((wr_regnum_mw == rt & opcode != 6'h23))); 
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4_if, PC[31:2], 30'h1);
    //adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    mux2v #(30) pc_if_mux(PC_if, PC_plus4_if, PC[31:2], Stall);
    adder30 target_PC_adder(PC_target, PC_plus4_de, imm[29:0]);
    //adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_if, PC_target, PCSrc);
    //mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_if, PC[31:2]);

    //IF/DE
    register #(30, 30'd0) pc_plus4_IFDE(PC_plus4_de, PC_if, clk, /* enable */!Stall, (reset|PCSrc));
    register #(32, 32'd0) inst_IFDE(inst_de, inst_if, clk, /* enable */!Stall, (reset|PCSrc));

    //DE/MW
    register #(1, 1'd0) memWrite_DEMW(MemWrite_mw, MemWrite_de, clk, /* enable */1'b1, (reset|Stall));
    register #(1, 1'd0) memRead_DEMW(MemRead_mw, MemRead_de, clk, /* enable */1'b1, reset);
    register #(1, 1'd0) memToReg_DEMW(MemToReg_mw, MemToReg_de, clk, /* enable */1'b1, reset);
    register #(1, 1'd0) regWrite_DEMW(RegWrite_mw, RegWrite_de, clk, /* enable */1'b1, (reset|Stall));

    register #(32, 32'd0) alu_out_data_DEMW(alu_out_data_mw, alu_out_data_de, clk, /* enable */1'b1, reset);
    register #(32, 32'd0) rd2_data_DEMW(rd2_data_mw, rd2_data_de, clk, /* enable */1'b1, reset);
    register #(5, 5'd0) wr_regnum_DEMW(wr_regnum_mw, wr_regnum_de, clk, /* enable */1'b1, reset);

    mips_decode decode(ALUOp, RegWrite_de, BEQ, ALUSrc, MemRead_de, MemWrite_de, MemToReg_de, RegDst, opcode, funct);
    //mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_mw, wr_data,
               RegWrite_mw, clk, reset);
    //regfile rf (rd1_data, rd2_data,                                                                   rs, rt, wr_regnum, wr_data,                                                               RegWrite, clk, reset);
    
    mux2v #(32) forward_a(A_data, rd1_data, alu_out_data_mw, ForwardA);
    mux2v #(32) forward_b(rd2_data_de, rd2_data, alu_out_data_mw, ForwardB);

    mux2v #(32) imm_mux(B_data, rd2_data_de, imm, ALUSrc);
    // mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc); 
    alu32 alu(alu_out_data_de, zero, ALUOp, A_data, B_data);
    // alu32 alu(alu_out_data, zero, ALUOp, rd1_data, B_data); 

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_mw, rd2_data_mw, MemRead_mw, MemWrite_mw, clk, reset);
    //data_mem data_memory(load_data, alu_out_data, rd2_data, MemRead, MemWrite, clk, reset);
    mux2v #(32) wb_mux(wr_data, alu_out_data_mw, load_data, MemToReg_mw);
    mux2v #(5) rd_mux(wr_regnum_de, rt, rd, RegDst);

endmodule // pipelined_machine
