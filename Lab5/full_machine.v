// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;
  
    wire [31:0] PC;  
    wire [31:0] nextPC;
    wire [31:0] ct0;
    wire [31:0] ct1;
    wire [31:0] badr = {{14{inst[15]}}, inst[15:0], 2'b0};
    wire [31:0] jadr = {ct0[31:28], inst[25:0], 2'b0};
    wire [1:0]  control_type;

    wire [31:0] inst;

    wire [31:0] A_data;
    wire [31:0] B_data;
    wire [31:0] W_data;
    wire [4:0]  W_addr;
    wire write_enable, rd_src;

    wire [31:0] out;
    wire [31:0] A;
    wire [31:0] B;
    wire [2:0]  alu_op;
    wire [1:0]  alu_src2;
    wire overflow, zero, negative;
    
    wire [31:0] slt1 = {{31{1'b0}}, negative};
    wire slt;

    wire [31:0] mem0;
    wire [31:0] mem1;
    wire [31:0] lui0;
    wire [31:0] lui1 = {inst[15:0], {16{1'b0}}}; 
    wire mem_read, lui;

    wire [31:0] data_out;
    wire [31:0] addr;
    wire [7:0]  b_out;
    wire [31:0] bl1 = {{24{1'b0}}, b_out};
    wire word_we, byte_we, byte_load; 

    wire   addm;
    
    wire [31:0] sext = {{16{inst[15]}}, inst[15:0]};
    wire [31:0] zext = {{16{1'b0}}, inst[15:0]};
    wire [5:0]  opcode = inst[31:26];
    wire [5:0]  funct  = inst[5:0];

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);
 
    alu32 pcplus4(ct0, , , , PC, 32'h4, `ALU_ADDU);
    
    alu32 pcoffset(ct1, , , , ct0, badr, `ALU_ADDU);

    mux4v control(nextPC, ct0, ct1, jadr, A_data, control_type);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);  
 
    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (A_data, B_data, inst[25:21], inst[20:16], W_addr, W_data, write_enable, clock, reset);
   
    mux2v #(5) waddr(W_addr, inst[15:11], inst[20:16], rd_src);
    
    mux2v wdata(W_data, lui0, lui1, lui);
    
    // arith_alu
    alu32 alu(out, overflow, zero, negative, A, B, alu_op);
   
    mux3v selB(B, B_data, sext, zext, alu_src2);

    mux2v selA(A, A_data, data_out, addm); //select A for ALU(ADDM implementation)
    
    mux2v Slt(mem0, out, slt1, slt);
    
    mux2v memR(lui0, mem0, mem1, mem_read); 

    //Data Memory
    data_mem dm(data_out, addr, B_data, word_we, byte_we, clock, reset);    

    mux2v dm_adr(addr, out, A_data, addm); //select addr for Data Memory(ADDM implementation)  
    
    mux4v #(8) b(b_out, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);
    
    mux2v bl(mem1, data_out, bl1, byte_load);    
    
    // Decoder
    mips_decode decoder(alu_op, write_enable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, opcode, funct, zero);
endmodule // full_machine
