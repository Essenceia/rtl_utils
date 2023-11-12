/* test bench for fifo */
module fifo_tb#(
	parameter DATA_W = 8,
	parameter ENTRIES_N = 4
);

logic clk = 1'b0;
logic nreset;
logic              wr_i;// wr valid
logic [DATA_W-1:0] wr_data_i;
logic              rd_i;
logic [DATA_W-1:0] rd_data_o;	
logic              full_o;
logic              empty_o;

always clk = #5 ~clk;

initial begin
	// add waves
	$dumpfile("wave/fifo_tb.vcd");
	$dumpvars(0,fifo_tb);
	nreset = 1'b0;
	wr_i = 1'b0;
	rd_i = 1'b0;
	#10
	nreset = 1'b1;
	assert(empty_o);
	/* write */
	for(int i = 0; i < ENTRIES_N; i++) begin
		#10
		wr_i = 1'b1;
		wr_data_i = $random;
	end	
	#10
	wr_i = 1'b0;
	assert(full_o);
	#10
	/* read */
	for(int i = 0; i < ENTRIES_N; i++) begin
		#10
		rd_i = 1'b1;
	end
	#20	
	$finish;
end

/* uut */
fifo #(
	.DATA_W(DATA_W),
	.ENTRIES_N(ENTRIES_N)
)m_fifo(
.clk(clk),
.nreset(nreset),
.wr_i(wr_i),// wr valid
.wr_data_i(wr_data_i),
.rd_i(rd_i),
.rd_data_o(rd_data_o),	
.full_o(full_o),
.empty_o(empty_o)
);
endmodule
