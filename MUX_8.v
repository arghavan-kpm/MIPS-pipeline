module MUX_8#(parameter N = 1) (A,B,C,D,E,F,G,H,s,OUT);
	input[N - 1:0] A,B,C,D,E,F,G,H;
	input [2:0]s;
	output[N - 1:0] OUT;
	assign OUT = (s == 0)? A :
			(s == 1) ? B:
			(s == 2) ? C:
			(s == 3) ? D:
			(s == 4) ? E:
			(s == 5) ? F:
			(s == 6) ? G:
			(s == 7) ? H:
			0;
endmodule 
