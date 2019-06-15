module CA4_testbench();
	reg clk;
	wire [31:0] Inst, readData_Mem, adr_inst, adr_Mem, writeData_Mem;
	wire memWrite, memRead;

	Pipeline pl(clk, Inst, readData_Mem,
		adr_inst, adr_Mem, writeData_Mem,
		memWrite, memRead);

	InstMem#(20) instmem(adr_inst, Inst);
	DataMem#(20) datamem(clk, adr_Mem, writeData_Mem, memRead, memWrite,
				readData_Mem);

	initial begin
		clk <= 0;
	end
	initial repeat(10000) begin
		#30
		clk <= ~clk;
	end

	initial begin
		#(3500)
		$stop;
	end
endmodule
