/* Get the index of the msb 1
 * Breaks the datapath down into a tree structure
 *
 * Contains 2 modules : 
 * idx_msb_one : main module
 * inner_idx_msb_one : inner module, should not be manipulated by user
 */
module inner_idx_msb_one#(
	parameter I  = 2,   // size of elements
	parameter D  = 32,  // number of input elements 
	parameter ID = I+1, // size of output elements
	parameter OD = D/2, // number of output elements
	parameter C  = 6    // final cnt size
	)
	(
	input  [(I*D)-1:0] data_i,
	output [C-1:0]     idx_o
	);
	
	wire [(ID*OD)-1:0] next;
	
	genvar i;
	generate
		for( i=0; i<OD; i=i+1 ) begin : loop_inner_idx_msb
			wire [I-1:0] left;
			wire [I-1:0] right;
			wire [I:0]   debug_next;
			wire         left_v;
			assign right  = data_i[((I*2)*i)+I-1:(I*2)*i];
			assign left   = data_i[((I*2)*i)+(I*2)-1:((I*2)*i)+I];
			assign left_v = |left;
			assign debug_next = ({I+1{left_v}} & ( { 1'b0 ,left } | (1 << I) ))
									|{ 1'b0 , {I{~left_v}}&right }; 
			assign next[(i*(I+1))+I:i*(I+1)] = ({I+1{left_v}} & ( { 1'b0 ,left } | (1 << I) ))
													 |{ 1'b0 , {I{~left_v}}&right }; 
		end 
	
	
	if (I+1 < C) begin
		inner_idx_msb_one#(I+1,D/2,ID+1,OD/2,C) inner_idx_msb_one
		(
			.data_i(next),
			.idx_o(idx_o)
		);
	end else begin
		assign idx_o = next;
	end
	
	endgenerate
endmodule


// get higher idx of 1
module idx_msb_one#(
	parameter I = 64, // input size
	parameter I_log = 6 // log(64) = 6
	)(
	input  [I-1:0]     data_i,
	output [I_log-1:0] idx_o
	);
	wire [I-1:0]     init;
	wire [I_log:0] res;
	genvar i;
	generate
		for( i=0; i<(I/2); i=i+1 ) begin : loop_init_idx_msb_one
			wire left;
			wire right;
			assign right = data_i[i*2];
			assign left  = data_i[(i*2)+1];
			assign init[(i*2)+1:i*2]     = {left, ~left & right};
		end
	endgenerate
	// size of elements
	// number of input elements 
	// size of output elements
	// number of output elements
	// final cnt siz
	inner_idx_msb_one#(2,I/2,3,I/4,I_log+1) inner_idx_msb_one
	(
		.data_i(init),
		.idx_o(res)
	);
	
	assign idx_o = res[I_log:1];
endmodule

