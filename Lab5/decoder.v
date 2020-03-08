// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, opcode, funct, zero);

    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;
    

    wire Add = !opcode & (funct == 6'h20);
    wire Addu = !opcode & (funct == 6'h21);
    wire Sub = !opcode & (funct == 6'h22);
    wire And = !opcode & (funct == 6'h24);
    wire Or = !opcode & (funct == 6'h25);
    wire Nor = !opcode & (funct == 6'h27);
    wire Xor = !opcode & (funct == 6'h26);
    wire Addi = (opcode == 6'h8);
    wire Addui = (opcode == 6'h9);
    wire Andi = (opcode == 6'hc);
    wire Ori = (opcode == 6'hd);   
    wire Xori = (opcode == 6'he);
    wire Beq = (opcode == 6'h4);
    wire Bne = (opcode == 6'h5);
    wire J = (opcode == 6'h2);
    wire Jr = !opcode & (funct == 6'h8);
    wire Lui = (opcode == 6'hf);
    wire Slt = !opcode & (funct == 6'h2a);
    wire Lw = (opcode == 6'h23);
    wire Lbu = (opcode == 6'h24);
    wire Sw = (opcode == 6'h2b);
    wire Sb = (opcode == 6'h28);
    wire Addm = !opcode & (funct == 6'h2c);
    wire beqz = Beq&zero;
    wire bnez = Bne&!zero;
  
    assign rd_src = Lui|Lw|Lbu|Addi|Addui|Andi|Ori|Xori;
    assign alu_src2[0] = Addi|Addui|Lw|Lbu|Sw|Sb;
    assign alu_src2[1] = Andi|Ori|Xori;
    assign alu_op[0] = Sub|Or|Xor|Ori|Xori|Beq|Bne|Slt; 
    assign alu_op[1] = Add|Sub|Nor|Xor|Addi|Xori|Beq|Bne|Slt|Lw|Lbu|Sw|Sb|Addm;
    assign alu_op[2] = And|Or|Nor|Xor|Andi|Ori|Xori;
    assign except = !(Add|Addu|Sub|And|Or|Nor|Xor|Addi|Addui|Andi|Ori|Xori|Beq|Bne|J|Jr|Lui|Slt|Lw|Lbu|Sw|Sb|Addm);
    assign writeenable = Lui|Slt|Lw|Lbu|Addm|Add|Addu|Sub|And|Or|Nor|Xor|Addi|Addui|Andi|Ori|Xori;
    assign control_type[0] = beqz|bnez|Jr; 
    assign control_type[1] = J|Jr;
    assign mem_read = Lw|Lbu;
    assign word_we = Sw;
    assign byte_we = Sb;
    assign byte_load = Lbu;
    assign slt = Slt;
    assign lui = Lui;
    assign addm = Addm;     //ADDM implementation 
endmodule // mips_decode
