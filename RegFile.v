module RegFile(input clk, input [4:0] readReg1, readReg2, writeReg, input regwrite, input [31:0] writeData,
		output [31:0] readData1, readData2);
	reg [31:0] MemReg [0:31];


	integer index;
	initial begin
  		for (index=0; index < 32; index = index + 1)
  			MemReg[index] = 0;
	end
	always@(posedge clk)begin
		#1
		if(regwrite && writeReg != 0) MemReg[writeReg] <= writeData;
	end

	assign readData1 = MemReg[readReg1];
	assign readData2 = MemReg[readReg2];
endmodule
