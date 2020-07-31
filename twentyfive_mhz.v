module twentyfive_mhz(input clk, output reg twentyfive_mhz);
	
	initial
	begin
	
		twentyfive_mhz = 1'b0;
	
	end
	
	always@(posedge clk)
	begin
	
		twentyfive_mhz = ~twentyfive_mhz;
	
	end

endmodule
