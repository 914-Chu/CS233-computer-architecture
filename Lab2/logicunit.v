// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire w0, w1, w2, w3;

    and a1(w0, A, B);
    or  o1(w1, A, B);
    nor no1(w2, A, B);
    xor x1(w3, A, B);
    
    mux4 m1(out, w0, w1, w2, w3, control);

endmodule // logicunit
