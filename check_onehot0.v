// check if data_i is a onehot0
module check_onehot0 #(
	parameter W = 8
)(
	input [W-1:0] data_i,
	ouput         onehot0_o
);

assign onehot0_o = ~|( data_i & (data_i - W'd1));
endmodule
