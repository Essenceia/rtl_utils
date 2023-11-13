/* Gray to bin
 * Decimal 	Binary 	Gray 
 * 0 	    0000 	0000 
 * 1 	    0001 	0001 
 * 2 	    0010 	0011 
 * 3 	    0011 	0010 
 * 4 	    0100 	0110 
 * 5 	    0101 	0111 
 * 6 	    0110 	0101 
 * 7 	    0111 	0100 
 * 8 	    1000 	1100 
 * 9 	    1001 	1101 
 * 10 	    1010 	1111 
 * 11 	    1011 	1110 
 * 12 	    1100 	1010 
 * 13 	    1101 	1011 
 * 14 	    1110 	1001 
 * 15 	    1111 	1000 
 */
module gray_to_bin #(
	parameter CNT_W = 8
)(
	input  [CNT_W-1:0] gray_i,
	output [CNT_W-1:0] bin_o
);

genvar i;
generate
	for(i=0;i<CNT_W;i++)begin
		assign bin_o[i] = ^gray_i[CNT_W-1:i];
	end
endgenerate

endmodule
