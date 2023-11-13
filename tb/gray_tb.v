module gray_tb#(
	parameter CNT_W = 8
);
localparam CNT_MAX = $pow(2,CNT_W);

logic clk = 1'b0;
always clk = #5 ~clk;

logic [CNT_W-1:0] bin_i;
logic [CNT_W-1:0] gray;
reg   [CNT_W-1:0] tb_gray_q;
reg   [CNT_W-1:0] tb_bin_q;
logic [CNT_W-1:0] bin_o;

always @(posedge clk) begin
	tb_bin_q <= bin_i;
	tb_gray_q <= gray;
end
/* function for assertion checking */
function check_gray;
	input [CNT_W-1:0] tb_bin_q; 
	input [CNT_W-1:0] bin; 
	input [CNT_W-1:0] tb_gray_q; 
	input [CNT_W-1:0] gray; 
	begin
		if ( tb_bin_q + 1 == bin ) begin
			logic [CNT_W-1:0] diff;
			diff = (tb_gray_q ^ gray );
			assert( ~|(diff & (diff-1)));
		end
	end
endfunction

initial begin
	$dumpfile("wave/gray_tb.vcd");
	$dumpvars(0,gray_tb);
	for(int i=0; i<CNT_MAX;i++)begin
		#9
		bin_i = i;
		#1
		check_gray(tb_bin_q, bin_i, 
				   tb_gray_q, gray);
		assert( bin_i == bin_o );
	end
	$finish;
end

/* bin -> gray */
bin_to_gray #(.CNT_W(CNT_W))
m_bin_to_gray(
.bin_i(bin_i),
.gray_o(gray)
);

/* gray -> bin */
gray_to_bin #(.CNT_W(CNT_W))
m_gray_to_bin(
.gray_i(gray),
.bin_o(bin_o)
);

endmodule
