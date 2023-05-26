// Check if data_i is a thermometer
module check_termo #(
	parameter W = 8
)(
	input [W-1:0] data_i,
	output        thermo_o
);

assign thermo = (( data_i - W'd1 ) ^ data_i ) == data_i;

endmodule
