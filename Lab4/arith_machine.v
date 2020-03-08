// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  
    wire [31:0] nextPC;
    wire [31:0] A_data;
    wire [31:0] B_data;
    wire [31:0] B;
    wire [31:0] W_data;
    wire [5:0]  W_addr;
    wire [2:0]  alu_op;
    wire [1:0]  alu_src2;    
    wire        write_enable, rd_src, overflow, zero, negative;    
    
    wire [31:0] sext = {{16{inst[15]}}, inst[15:0]};
    wire [31:0] zext = {{16{1'b0}}, inst[15:0]};
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 32'h1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (A_data, B_data, inst[25:21], inst[20:16], W_addr, W_data, write_enable, clock, reset);

    /* add other modules */
    alu32 pcplus4(nextPC, , , , PC, 32'h4, `ALU_ADDU);
    
    alu32 alu(W_data, overflow, zero, negative, A_data, B, alu_op);
   
    mips_decode decoder(rd_src, write_enable, alu_src2, alu_op, except, inst[31:26], inst[5:0]);
    
    mux2v waddr(W_addr, inst[15:11], inst[20:16], rd_src);

    mux3v selB(B, B_data, sext, zext, alu_src2);
endmodule // arith_machine
