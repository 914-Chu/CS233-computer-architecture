// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    output       rd_src, writeenable, except;
    output [1:0] alu_src2;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;

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

    assign rd_src = (opcode != 6'h0);
    assign writeenable = 1; 
    assign alu_src2[0] = Addi|Addui;
    assign alu_src2[1] = Andi|Ori|Xori;
    assign alu_op[0] = Sub|Or|Xor|Ori|Xori;
    assign alu_op[1] = Add|Sub|Nor|Xor|Addi|Xori;
    assign alu_op[2] = And|Or|Nor|Xor|Andi|Ori|Xori;
    assign except = !(Add|Addu|Sub|And|Or|Nor|Xor|Addi|Addui|Andi|Ori|Xori);
    
endmodule // mips_decode
