/* Parametric synchronous fifo design, 
 * read and write data ports are the same
 * width. */
module fifo #(
	parameter DATA_W = 8,
	parameter ENTRIES_N = 4
)(
	input clk,
	input nreset,

	/* wr */
	input              wr_i,// wr valid
	input [DATA_W-1:0] wr_data_i,

	/* rd */
	input               rd_i,
	output [DATA_W-1:0] rd_data_o,	

	/* full & empty valid signals */
	output             full_o,
	output             empty_o
);
/* rd and wr ptrs, need an extra bit for wrap around*/
localparam PTR_W = $clog2(ENTRIES_N)+1;
logic             unused_wr_ptr_add;
logic             unused_rd_ptr_add;
logic [PTR_W-1:0] wr_ptr_next;
logic [PTR_W-1:0] rd_ptr_next;
reg   [PTR_W-1:0] wr_ptr_q;
reg   [PTR_W-1:0] rd_ptr_q;

assign empty_o = wr_ptr_q == rd_ptr_q;
assign full_o = ( wr_ptr_q[PTR_W-1] ^ rd_ptr_q[PTR_W-1] ) & ( wr_ptr_q[PTR_W-2:0] == rd_ptr_q[PTR_W-2:0]);

assign { unused_wr_ptr_add,  wr_ptr_next } = wr_ptr_q + {{PTR_W-1{1'b0}},wr_i};
assign { unused_rd_ptr_add,  rd_ptr_next } = rd_ptr_q + {{PTR_W-1{1'b0}},rd_i};

always @(posedge clk) begin
	if ( ~nreset ) begin
		wr_ptr_q <= {PTR_W{1'b0}};
		rd_ptr_q <= {PTR_W{1'b0}};
	end else begin
		wr_ptr_q <= wr_ptr_next; 
		rd_ptr_q <= rd_ptr_next;
	end
end

/* fifo flops */
logic [DATA_W-1:0] data_next[ENTRIES_N-1:0];
reg   [DATA_W-1:0] data_q[ENTRIES_N-1:0];
genvar i;
generate
	for(i=0; i< ENTRIES_N; i++) begin : gen_wr_entries 
		assign data_next[i] = wr_data_i;	
		always @(posedge clk) begin
			if ( wr_ptr_q == i & wr_i ) begin
				data_q[i] <= data_next[i];	
			end
		end
	end
endgenerate


logic [DATA_W-1:0] rd_data;
generate
	for(i=0; i< ENTRIES_N; i++) begin : gen_rd_entries 
		always_comb begin
			if ( rd_ptr_q == i ) begin
				rd_data = data_q[i];
			end	
		end
	end
endgenerate
assign rd_data_o = rd_data;

endmodule
