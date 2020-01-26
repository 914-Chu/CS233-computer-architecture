// Complete the sc2_block module in this file
// Don't put any code in this file besides the sc2_block
// Refer to sc_block.v for hints!

module sc2_block(s, cout, a, b, cin);
    output s, cout;
    input a, b, cin;
    wire w1, w2, w3;

    xor xo1(w1, a, b);
    xor xo2(s, w1, cin);
    and a1(w2, a, b);
    and a2(w3, w1, cin);
    or  o1(cout, w2, w3);

endmodule // sc2_block
