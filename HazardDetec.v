module HazardDetec(input [31:0] readData1, readData2, input [5:0] IFout_opc,
			input ID_EX_memread,
			input [4:0] ID_EX_Rd, IF_ID_Rs, IF_ID_Rt,
			output IFflush,pcwrite,contsel,IFwrite );
	
	assign {pcwrite,contsel,IFwrite} = (ID_EX_memread==1 && (ID_EX_Rd==IF_ID_Rs || ID_EX_Rd==IF_ID_Rt))? 3'd0:3'd7;

	assign IFflush = ((IFout_opc == 6'b000100 && readData1 == readData2)||(IFout_opc == 6'b000101 && readData1 != readData2))?
		1 : 0;
endmodule
