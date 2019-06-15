module DataMem#(parameter DATA = 1)(input clk, input [31:0] adr, writeData, input memread, memwrite,
					output [31:0] readData);
 	reg [31:0] DataMem [0:255];
	reg [31:0] readData_reg;

	integer               data_file    ; // file handler
	integer               scan_file    ; // file handler
	integer 	      index;
	
	`define NULL 0    
	`define FILENAME "data_set.txt"
	initial begin 
	  data_file = $fopen(`FILENAME, "r");	
	  if (data_file == `NULL) begin
	    $display("data_file handle was NULL");
	    $finish;
	  end
	  for (index=0; index < DATA; index = index + 1)
	 	scan_file = $fscanf(data_file, "%d\n", DataMem[index]);
	end
	always @(posedge clk) begin

		if(memwrite) DataMem[adr] <= writeData;
	end	
	always @(adr) begin
		
		if(memread) readData_reg <= DataMem[adr];		
	end

	assign readData = readData_reg;
endmodule
