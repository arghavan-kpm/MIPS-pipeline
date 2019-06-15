module DP(input clk, input [31:0] Inst, readData_Mem,
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

		output [31:0] adr_inst, adr_Mem, writeData_Mem ,Inst_CU,
		output memWrite, memRead);

	wire [31:0] hiout, lowout, jrout, plus4out, pcsrcout, jjalout,  plusbranchout, signexout, readData1, readData2,
		ALUSrc1out, ALUSrc2out, Mem2Regout;
	wire [63:0] IFout, ALUout;
	wire [22:0] contselout;
	wire [165:0] IDout;
	wire [161:0] EXout;
	wire [157:0] Memout;
	wire [4:0] RegDstout;
	wire zero, tmp, pcsrc; //contsel b controller ezafe shavad

	Reg#(32) pc(jrout, clk, pcwrite, 0, adr_inst);
	Reg#(32) hi(Memout[121:90], clk, 1, 0, hiout);
	Reg#(32) lo(Memout[57:26], clk, 1, 0, lowout);
	Reg#(64) IF({plus4out, Inst}, clk, IFwrite, IFflush, IFout);//IFwrite mikhahad,  IFflush mikhahad
	Reg#(166) ID({contselout, IFout[63:32], readData1, readData2, signexout, IFout[25:21], IFout[20:16], IFout[15:11]},
			clk, 1, 0, IDout);
	Reg#(162) EX({IDout[165:162], IDout[148:146], IDout[142:111], zero, ALUout, IDout[78:47], IDout[9:5], IDout[30:15],
			RegDstout}, clk, 1, 0, EXout);
	Reg#(158) Mem({EXout[161], EXout[157:123], EXout[121:90], readData_Mem, EXout[89:58], EXout[25:5], EXout[4:0]},
			clk, 1'b1, 1'b0, Memout);

	ALU EXE(ALUSrc1out, ALUSrc2out, IDout[158:155], zero, ALUout);
	
	MUX_2#(32) Pcsrc(plusbranchout, plus4out, pcsrc, pcsrcout);
	/**/MUX_2#(32) jjal( {IDout[142:139], IDout[25:0], 2'b0}, pcsrcout, (IDout[161] | IDout[159]), jjalout);
	/**/MUX_2#(32) Jr((IDout[110:79] << 2), jjalout, IDout[160], jrout);
	MUX_2#(23) Contsel({RegWrite, branch, MemWrite, MemRead, j, jr, jal, 
				ALUcont, ALUSrc1_CU, ALUSrc2_CU, Mem2Reg, RegDst}, 0, contsel, contselout);
	
	MUX_4#(32) src1(IDout[110:79],EXout[89:58],Mem2Regout, 0 , ALUSrc1_FW,ALUSrc1out);
	MUX_4#(32) src2(IDout[78:47],Mem2Regout,EXout[89:58],IDout[46:15], ALUSrc2_FW,ALUSrc2out);
	MUX_4#(5) regdst(IDout[14:10], IDout[9:5], IDout[4:0], 5'd31, IDout[144:143],RegDstout);
	MUX_8#(32) mem2reg(Memout[89:58],Memout[57:26], hiout,Memout[153:122],{{11{Memout[25]}},Memout[25:5]},lowout,0,0,Memout[156:154],Mem2Regout);

	SignExtend SE(IFout[15:0], signexout);
	
	RegFile RF(clk, IFout[25:21], IFout[20:16], Memout[4:0], Memout[157], Mem2Regout,readData1,readData2);

	assign Inst_CU = IFout[31:0];
	assign memRead = EXout[158];
	assign memWrite = EXout[159];

	assign pcsrc = (IFout[31:26]==6'b000100)?(contselout[21] & (readData1==readData2)):
				(IFout[31:26]==6'b000101)?(contselout[21] & (readData1!=readData2)):0;
	assign plus4out = 4 + adr_inst;
	/**/assign plusbranchout = IFout[63:32] + (signexout << 2) ;
	assign adr_Mem = EXout[89:58];   //low
	assign writeData_Mem = EXout[57:26]; //opr sec

	assign EX_Mem_Rd = EXout[4:0];
	assign Mem_WB_Rd = Memout[4:0];
	assign ID_EX_Rs = IDout[14:10];
	assign ID_EX_Rt = IDout[9:5];
	assign EX_Mem_regwrite = EXout[161];
	assign Mem_WB_regwrite = Memout[157];

	assign ALUsrc1 = IDout[153:152];
	assign ALUsrc2 = IDout[150:149];

	assign readData1out = readData1;
	assign readData2out = readData2;
	assign IFout_opc = IFout[31:26];
	assign ID_EX_memread = IDout[162];
	assign ID_EX_Rd = RegDstout;
	assign IF_ID_Rs = IFout[25:21]; 
	assign IF_ID_Rt = IFout[20:16];
endmodule
