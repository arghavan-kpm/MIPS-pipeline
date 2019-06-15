module ALU (A, B, ALUcont, zero, out);

	input [3:0] ALUcont;
	input signed [31:0] A, B;
	output reg zero;
	output reg signed [63:0] out = 0;

    always @(A, B, ALUcont)begin
     	out <= 0;
	    zero <= 0;
      	case(ALUcont)
         	4'b0000 : out <= A + B;
         	4'b0001 : out <= A - B;
         	4'b0010 : out <= A & B;
         	4'b0011 : out <= A | B;
         	4'b0100 : out <= A ^ B;
		4'b0101 : out <= (A < B) ? 1 : 0;
		4'b0110 : out <= A * B;
		4'b0111 : begin 
			out[31:0] <= A / B;
			out[63:32] <= A % B;
		end
		4'b1000 : begin
			zero <= ( A == B ) ? 1 : 0;
			out <= 0;
		end
		4'b1001 : begin
			zero <= ( A != B ) ? 1 : 0;
			out <= 0;
		end
       	endcase
     end
 endmodule
