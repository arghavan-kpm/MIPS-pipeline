module MUX_4#(parameter N = 1) (A,B,C,D,s,OUT);
	input[N - 1:0] A,B,C,D;
	input [1:0]s;
	output[N - 1:0] OUT;
	assign OUT = (s == 2'b0)? A :
			(s == 2'b01) ? B:
			(s == 2'b10) ? C:
			(s == 2'b11) ? D:
			0;
endmodule 
