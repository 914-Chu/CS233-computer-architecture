module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;      

   assign valid = ((a^b)^c)&((d^e)^(f^g));

   assign number[3] = valid&((b|c)&f);
   assign number[2] = valid&(((a|b|c)&e)|(a&f));
   assign number[1] = valid&((a&f)|(b&d)|(c&(d|e)));
   assign number[0] = valid&(((a|c)&(d|f))|(b&e));

endmodule // keypad
