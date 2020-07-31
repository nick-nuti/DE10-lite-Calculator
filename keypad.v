module keypad(input clk, input [3:0] state_place, input [3:0] row, output reg [3:0] column, output [15:0] decode);

	//reg [23:0] clock_count;
	reg [15:0] key_pressed;
	reg [15:0] key_stored;
	
	reg [3:0] rows_int;
	
	integer clock_count = 0;
	integer presses;
	integer i;
	
	initial
	begin
		column = 4'b1111;
		
	end
	
	always @ (posedge clk)
	begin
	
		rows_int <= row;
		
	
	end
	
	always @ (posedge clk)
	begin
////////////////////////
			if(clock_count < 50) clock_count = clock_count + 1;
			
			else
			begin
				clock_count = 0;
			
				case(column)
					4'b1111 :	begin
										presses = 0;
										
										for (i = 0; i < 16; i = i + 1)
										begin
										
											if(key_pressed[i] == 1'b1) presses = presses + 1;
										
										end
										
										if(presses < 2) key_stored <= key_pressed;
										
										else
											
											key_stored <= 16'd0;
											key_stored <= key_pressed;
											key_pressed <= 16'd0;
										
											column <= 4'b0111;
										
									end
					4'b0111 :	begin
										key_pressed[1] <= ~(rows_int[3]);
										key_pressed[4] <= ~(rows_int[2]);
										key_pressed[7] <= ~(rows_int[1]);
										key_pressed[0] <= ~(rows_int[0]);            
										column <= 4'b1011;
									end
					4'b1011 :	begin
										key_pressed[2]  <= ~(rows_int[3]);
										key_pressed[5]  <= ~(rows_int[2]);
										key_pressed[8]  <= ~(rows_int[1]);
										key_pressed[15] <= ~(rows_int[0]);            
										column <= 4'b1101;
									end
					4'b1101 :	begin
										key_pressed[3]  <= ~(rows_int[3]);
										key_pressed[6]  <= ~(rows_int[2]);
										key_pressed[9]  <= ~(rows_int[1]);
										key_pressed[14] <= ~(rows_int[0]);            
										column <= 4'b1110;
									end
					4'b1110 :	begin
										key_pressed[10] <= ~(rows_int[3]);
										key_pressed[11] <= ~(rows_int[2]);
										key_pressed[12] <= ~(rows_int[1]);
										key_pressed[13] <= ~(rows_int[0]);            
										column <= 4'b1111;
									end
					default: column <= 4'b1111;
					
				endcase
				
		end
	end
	
	debounce d0 (.clk(clk), .state_place(state_place), .keypad_debounce(key_stored), .keypad_decode(decode));

endmodule
