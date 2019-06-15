module InstMem#(parameter INST = 1)(input [31:0] adr, output [31:0] inst);
	reg [7:0] Mem [0:1023];
	reg [31 : 0] inst_reg;
	
	integer               data_file    ; // file handler
	integer               scan_file    ; // file handler
	integer 	      index;


	`define NULL 0    
	`define FILENAME "inst_set.txt"
	initial begin 
	  	data_file = $fopen("inst_set.txt", "r");	
	  	if (data_file == `NULL) begin
	    		$display("data_file handle was NULL");
	    		$finish;
	  	end
	  	for (index=0; index < 4*INST; index = index + 4)
	 		scan_file = $fscanf(data_file, "%b\n", {Mem[index],Mem[index+1],Mem[index+2],Mem[index+3]});
	end
	always@(adr)begin
		inst_reg <=  {Mem[adr],Mem[adr+1],Mem[adr+2],Mem[adr+3]};
	end
	assign inst = inst_reg;
endmodule
