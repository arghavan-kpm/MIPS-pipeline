module MUX_2#(parameter N = 1) (A,B,s,OUT);
	input[N - 1:0] A,B;
	input s;
	output[N - 1:0] OUT;
	assign OUT = (s)? A : B;
endmodule 
