module blackbox_test;
    reg x, s, b;

    wire v;

    blackbox bl1 (v, x, s, b);
    
    initial begin 
	    
	    $dumpfile("bl.vcd");
            $dumpvars(0,blackbox_test);

	    x = 0; s = 0; b = 0; # 10;
	    x = 0; s = 0; b = 1; # 10;
	    x = 0; s = 1; b = 0; # 10;
	    x = 0; s = 1; b = 1; # 10;
	    x = 1; s = 0; b = 0; # 10;
	    x = 1; s = 0; b = 1; # 10;
	    x = 1; s = 1; b = 0; # 10;
	    x = 1; s = 1; b = 1; # 10;	    

	    $finish;
											end
							  
							    				initial 										$monitor("At time %2t, x = %d s = %d b = %d v = %d",
                  $time, x, s, b, v);

endmodule // blackbox_test
