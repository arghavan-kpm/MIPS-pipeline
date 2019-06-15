module CU(input [31:0] Inst,
		input clk,
		output reg pcwrite, RegWrite, branch, MemWrite, MemRead, j, jr, jal, 
		output reg [3:0] ALUcont,
		output reg [2:0] ALUSrc1, ALUSrc2, Mem2Reg, RegDst);

		reg [3:0] ps, ns;

		initial begin
    			{pcwrite , RegWrite, branch, MemWrite, MemRead, j, jr, jal}<=8'b10000000;
   			ALUcont<=4'b0;
			ALUSrc1 <= 3'b0;
			ALUSrc2 <= 3'b0;
			Mem2Reg <= 3'b0;
			RegDst <= 3'b0;
   			ps <= 0;
    			ns <= 1;
  		end
		always@(Inst)begin
			{pcwrite , RegWrite, branch, MemWrite, MemRead, j, jr, jal}<=8'b10000000;
   			ALUcont<=4'b0;
			ALUSrc1 <= 3'b0;
			ALUSrc2 <= 3'b0;
			Mem2Reg <= 3'b0;
			RegDst <= 3'b0;
			 case(Inst[31:26])
				6'b001000: begin//addi
					ALUSrc2 <= 3;
					RegWrite <= 1;
					Mem2Reg <= 1;
					RegDst <= 1;
					//ns
				end
				6'b100000: begin//add
					RegWrite <= 1;
					Mem2Reg <= 1;
					RegDst <= 2;
					//ns
				end
				6'b100010: begin//sub
					RegWrite <= 1;
					Mem2Reg <= 1;
					RegDst <= 2;
					//ns
				end
				6'b100100: begin//and
					RegWrite <= 1;
					Mem2Reg <= 1;
					RegDst <= 2;
					//ns
				end
				6'b100101: begin//or
					RegWrite <= 1;
					Mem2Reg <= 1;
					RegDst <= 2;
					//ns
				end
				6'b100110: begin//xor
					RegWrite <= 1;
					Mem2Reg <= 1;
					RegDst <= 2;
					//ns
				end
				6'b101010: begin//slt
					RegWrite <= 1;
					Mem2Reg <= 1;
					RegDst <= 2;
					ALUcont <= 4'b0101;
					//ns
				end
				6'b001010: begin//slti
					ALUSrc2 <= 3;
					RegWrite <= 1;
					Mem2Reg <= 1;
					RegDst <= 1;
					ALUcont <= 4'b0101;
					//ns
				end
				6'b011000: begin//mult
					
					//ns
				end
				6'b011010: begin//div
					
					//ns
				end
				6'b100011:begin//lw
					RegWrite <= 1;
					MemRead <= 1;
					ALUSrc2 <= 3;
					RegDst <= 1;
					//ns
				end
				6'b101011:begin//sw
					MemWrite <= 1;
					ALUSrc2 <= 3;
					//ns
				end
				6'b010000:begin//mflo
					RegDst <= 0;
					RegWrite <= 1;
					Mem2Reg <= 5;
					//ns
				end
				6'b010001:begin//mfhi
					RegDst <= 0;
					RegWrite <= 1;
					Mem2Reg <= 2;
					//ns 
				end
				6'b000010:begin//j
					j <= 1;
					//ns
				end
				6'b000011:begin//jal
					RegWrite <= 1;
					Mem2Reg <= 3;
					RegDst <= 3;
					jal <= 1;
					//ns
				end
				6'b000111:begin//jr
					jr <= 1;
					//ns
				end
				6'b000100:begin//beq
					branch <= 1;
					ALUcont <= 4'd8;
					//ns
				end
				6'b000101:begin//bne
					branch <= 1;
					ALUcont <= 4'd9;
					//ns
				end
				6'b001111:begin//lui
					RegDst <= 0;
					RegWrite <= 1;
					Mem2Reg <= 4;
					//ns
				end
			endcase
		end
endmodule
