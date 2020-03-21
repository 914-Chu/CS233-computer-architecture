`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire [31:0] status_register;
    assign status_register[31:16] = 1'b0;
    assign status_register[15:8] = user_status[15:8];
    assign status_register[7:2] = 1'b0;
    assign status_register[1] = exception_level;
    assign status_register[0] = user_status[0];
    
    wire [31:0] cause_register;  
    assign cause_register[31:16] = 1'b0;
    assign cause_register[15] = TimerInterrupt;
    assign cause_register[14:0] = 1'b0;

    wire [31:0] mtc0_dec_out;
    wire bit12 = mtc0_dec_out[12];
    wire bit14 = mtc0_dec_out[14];
    wire [29:0] epc_D;
    wire [31:0] user_status;
    wire exception_level;
    wire el_reset = reset | ERET;
    wire epc_enable = TakenInterrupt | bit14;
    
    wire a0 = cause_register[15] & status_register[15];
    wire a1 = (~status_register[1]) & status_register[0];
    assign TakenInterrupt = a0 & a1;
 
    decoder32 mtc0_decoder(mtc0_dec_out, regnum, MTC0);
   
    mux2v #(30) wr_nextpc_mux(epc_D, wr_data[31:2], next_pc, TakenInterrupt);
    
    register #(32) us(user_status, wr_data, clock, bit12, reset);

    dffe el(exception_level, 1'b1, clock, TakenInterrupt, el_reset);

    register #(30) epc(EPC, epc_D, clock, epc_enable, reset);

    mux32v #(32) rd(rd_data, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, status_register, cause_register, {EPC, 2'b0}, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, regnum); 

endmodule
