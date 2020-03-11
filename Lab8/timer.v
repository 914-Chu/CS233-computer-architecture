module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
    wire [31:0] icq;
    wire [31:0] ccq;
    wire [31:0] ccd;    

    wire eq001c = 32'hffff001c == address;
    wire eq006c = 32'hffff006c == address;
    wire TimerRead = eq001c & MemRead;
    wire TimerWrite = eq001c & MemWrite;
    wire Acknowledge = eq006c & MemWrite;
    wire TimerAddress = eq006c | eq001c; 
    wire il_enable = ccq == icq;
    wire il_reset = Acknowledge | reset;
    
    register #(32, 32'hffffffff) interrupt_cycle(icq, data, clock, TimerWrite, reset);

    alu32 alu(ccd, , , `ALU_ADD, ccq, 32'h1);
    
    register cycle_counter(ccq, ccd, clock, 1'b1, reset); 

    tristate cycle_trisate(cycle, ccq, TimerRead);    

    register #(1) interrupt_line(TimerInterrupt, 1'b1, clock, il_enable, il_reset); 

    
endmodule
