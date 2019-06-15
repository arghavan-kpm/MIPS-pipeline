module Pipeline(input clk, input [31:0] Inst, readData_Mem,
		output [31:0] adr_inst, adr_Mem, writeData_Mem,
		output memWrite, memRead);

	wire pcwrite, RegWrite, branch, MemWrite, MemRead, j, jr, jal,contsel, IFwrite, IFflush ,Pcwrite;
	wire [3:0] ALUcont;
	wire [2:0] ALUSrc1_CU, ALUSrc2_CU, ALUSrc1_FW, ALUSrc2_FW, Mem2Reg, RegDst;

	wire [1:0] ALUsrc1, ALUsrc2;
	wire [4:0] EX_Mem_Rd, Mem_WB_Rd, ID_EX_Rs, ID_EX_Rt;
	wire EX_Mem_regwrite, Mem_WB_regwrite;

	wire [31:0] readData1out, readData2out, Inst_CU;
	wire [5:0] IFout_opc;
	wire ID_EX_memread;
	wire [4:0] ID_EX_Rd, IF_ID_Rs, IF_ID_Rt;

	DP dp(clk, Inst, readData_Mem,
		pcwrite, RegWrite, branch, MemWrite, MemRead, j, jr, jal,contsel, IFwrite, IFflush,
		ALUcont,
		ALUSrc1_CU, ALUSrc2_CU, ALUSrc1_FW, ALUSrc2_FW, Mem2Reg, RegDst,

		ALUsrc1, ALUsrc2,
		EX_Mem_Rd, Mem_WB_Rd, ID_EX_Rs, ID_EX_Rt,
		EX_Mem_regwrite, Mem_WB_regwrite,

		readData1out, readData2out, 
		IFout_opc,
		ID_EX_memread,
		ID_EX_Rd, IF_ID_Rs, IF_ID_Rt,

		adr_inst, adr_Mem, writeData_Mem,Inst_CU,
		memWrite, memRead);

	CU cu(Inst_CU,
		clk,
		Pcwrite, RegWrite, branch, MemWrite, MemRead, j, jr, jal, 
		ALUcont,
		ALUSrc1_CU, ALUSrc2_CU, Mem2Reg, RegDst);

	forwardUnit FW(EX_Mem_Rd, Mem_WB_Rd, ID_EX_Rs, ID_EX_Rt,
			EX_Mem_regwrite, Mem_WB_regwrite,
			ALUsrc1, ALUsrc2,
			ALUSrc1_FW, ALUSrc2_FW);

	HazardDetec HD(readData1out, readData2out, IFout_opc,
			ID_EX_memread,
			ID_EX_Rd, IF_ID_Rs, IF_ID_Rt,
			IFflush,pcwrite,contsel,IFwrite );
endmodule
/*DP(input clk, input [31:0] Inst, readData_Mem,
		input pcwrite, RegWrite, branch, MemWrite, MemRead, j, jr, jal,contsel, IFwrite, IFflush,
		input [3:0] ALUcont,
		input [2:0] ALUSrc1_CU, ALUSrc2_CU, ALUSrc1_FW, ALUSrc2_FW, Mem2Reg, RegDst,

		output [1:0] ALUsrc1, ALUsrc2,
		output [4:0] EX_Mem_Rd, Mem_WB_Rd, ID_EX_Rs, ID_EX_Rt,
		output EX_Mem_regwrite, Mem_WB_regwrite,

		output [31:0] readData1out, readData2out, 
		output [5:0] IFout_opc,
		output ID_EX_memread,
		output [4:0] ID_EX_Rd, IF_ID_Rs, IF_ID_Rt,

		output [31:0] adr_inst, adr_Mem, writeData_Mem,Inst_CU,
		output MemWrite, MemRead)*/

/*CU(input [31:0] Inst,
		input clk,
		output reg pcwrite, RegWrite, branch, MemWrite, MemRead, j, jr, jal, 
		output reg [3:0] ALUcont,
		output reg [2:0] ALUSrc1, ALUSrc2, Mem2Reg, RegDst);*/

/*forwardUnit(input [4:0] EX_Mem_Rd, Mem_WB_Rd, ID_EX_Rs, ID_EX_Rt,
			 input EX_Mem_regwrite, Mem_WB_regwrite,
			input [1:0] ALUSrc1, ALUSrc2,
			output [1:0] ALUsrc1, ALUsrc2);*/

/*HazardDetec(input [31:0] readData1, readData2, input [5:0] IFout_opc,
			input ID_EX_memread,
			input [4:0] ID_EX_Rd, IF_ID_Rs, IF_ID_Rt,
			output IFflush,pcwrite,contsel,IFwrite );*/
