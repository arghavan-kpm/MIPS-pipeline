module forwardUnit(input [4:0] EX_Mem_Rd, Mem_WB_Rd, ID_EX_Rs, ID_EX_Rt,
			 input EX_Mem_regwrite, Mem_WB_regwrite,
			input [1:0] ALUSrc1, ALUSrc2,
			output [1:0] ALUsrc1, ALUsrc2);
	assign ALUsrc1 = (Mem_WB_regwrite==1 && (Mem_WB_Rd==ID_EX_Rs /*|| Mem_WB_Rd==ID_EX_Rt*/) && Mem_WB_Rd != 0)?
			2'd2 : (EX_Mem_regwrite == 1 && (EX_Mem_Rd==ID_EX_Rs /*|| EX_Mem_Rd==ID_EX_Rt*/) && EX_Mem_Rd!=0)?
			2'd1 : ALUSrc1;
	assign ALUsrc2 = (Mem_WB_regwrite==1 && (/*Mem_WB_Rd==ID_EX_Rs ||*/ Mem_WB_Rd==ID_EX_Rt) && Mem_WB_Rd != 0)?
			2'd1 : (EX_Mem_regwrite == 1 && (/*EX_Mem_Rd==ID_EX_Rs || */EX_Mem_Rd==ID_EX_Rt) && EX_Mem_Rd!=0)?
			2'd2 : ALUSrc2;
endmodule
