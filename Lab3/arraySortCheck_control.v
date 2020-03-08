
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;
	wire sGarbage, sStart, sDN, sAddIndex, sDS, sDnS;
        
	wire sGarbage_next = (sGarbage & ~go) | (~go&reset);
	wire sStart_next = ((sGarbage | sStart) & go) | (sDN&go);
	wire sDN_next = (sStart & ~go) | sAddIndex | sDS | sDnS;
	wire sAddIndex_next = (~zero_length_array & ~end_of_array & ~inversion_found);
	wire sDS_next = (zero_length_array | (~zero_length_array & end_of_array));
	wire sDnS_next = (~zero_length_array & ~end_of_array & inversion_found);

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0); 
	dffe fsStart(sStart, sStart_next, clock, 1'b1, reset);
	dffe fsDN(sDN, sDN_next, clock, 1'b1, reset);
	dffe fsAddIndex(sAddIndex, sAddIndex_next, clock, 1'b1, reset);
	dffe fsDS(sDS, sDS_next, clock, 1'b1, reset);
	dffe fsDnS(sDnS, sDnS_next, clock, 1'b1, reset);

        assign sorted = sDS; 
	assign done = sDnS | sDS;
	assign load_input = sStart; 
	assign load_index = sStart | sAddIndex;
	assign select_index = sAddIndex;

endmodule

