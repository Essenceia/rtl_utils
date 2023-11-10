module thermo_to_len #(
	parameter KEEP_W = 4,
	parameter LEN_W = $clog2(KEEP_W+1)
)(
	input  [KEEP_W-1:0] keep_i,
	output [LEN_W-1:0]  len_o
);

if ( KEEP_W > 2 ) begin
	/* translate thermo to onehot0 */
	logic [KEEP_W-1:0] onehot0;
	assign onehot0 = keep_i & ~(keep_i - 'd1);
	
	/* match onehot to value */
	always_comb begin
		for(int i=0; i<KEEP_W; i++) begin
			if(onehot0[i]) len_o = i;
		end
	end
end else begin
	/* KEEP_W == 2 */
	assign len_o = { keep_i[1], keep_i[1]^keep_i[0]};
end
endmodule
