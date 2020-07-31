module keypadtodisp(input clk, input [3:0] state_place, input [19:0] equation_out, input [15:0] keypad_decode, input bttn1, input bttn0, output reg [9:0] leds, output reg [3:0] next_state, output reg [19:0] hex_disp, output reg en_calc, output reg flash_start);
	
	initial hex_disp = 20'd0;
	
	reg [3:0] input_counter = 4'd0;
	reg [3:0] counter_next = 4'd0;

	reg changeindecode;
	
	reg compare_changeindecode;
		
	always@(keypad_decode)
	begin
		changeindecode <= |keypad_decode[15:0];
		
	end
	
	always@(counter_next)
	begin
		if((state_place == 4'd0)||(state_place == 4'd1))
		begin

			input_counter <= counter_next;
			/*
			case(input_counter)
			
				4'd0: leds <= 10'b0000000000;
				4'd1: leds <= 10'b0000000001;
				4'd2: leds <= 10'b0000000010;
				4'd3: leds <= 10'b0000000011;
				4'd4: leds <= 10'b0000000100;
				4'd5: leds <= 10'b0000000101;
				4'd6: leds <= 10'b0000000110;
				4'd7: leds <= 10'b0000000111;
				4'd8: leds <= 10'b0000001000;
				4'd9: leds <= 10'b0000001001;
				4'd10:leds <= 10'b0000001010;
				4'd11: leds <= 10'b0000001011;
				4'd12: leds <= 10'b0000001100;
				4'd13: leds <= 10'b0000001101;
				4'd14: leds <= 10'b0000001110;
				4'd15: leds <= 10'b0000001111;
			
			endcase
			*/
		end
	end
	
	
	always@(negedge bttn1 or negedge bttn0 or posedge changeindecode)
	begin
		if (~bttn1) 
		begin
			
			if (state_place == 4'd3) hex_disp <= equation_out;
			else begin hex_disp <= 20'b0; counter_next <= 4'd0; end
		end
		else if (~bttn0) begin hex_disp <= 20'b0; counter_next <= 4'd0; end
		else if(((state_place == 4'd0)||(state_place == 4'd2)) && (counter_next < 6))
		begin
	
			case (keypad_decode)
			
				16'b0						:begin
											hex_disp <= 20'b0;
											
											end

				16'b0000000000000001 : begin
							hex_disp <= (hex_disp * 10) + 20'd0;  // 0
							//leds <= 10'b0000000000;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000000000000010 : begin
							hex_disp <= (hex_disp * 10) + 20'd1;  // 1
							//leds <= 10'b0000000001;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000000000000100 : begin
							hex_disp <= (hex_disp * 10) + 20'd2;  // 2
							//leds <= 10'b0000000010;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000000000001000 : begin
							hex_disp <= (hex_disp * 10) + 20'd3;  // 3
							//leds <= 10'b0000000011;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000000000010000 : begin
							hex_disp <= (hex_disp * 10) + 20'd4;  // 4
							//leds <= 10'b0000000100;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000000000100000 : begin
							hex_disp <= (hex_disp * 10) + 20'd5;  // 5
							//leds <= 10'b0000000101;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000000001000000 : begin
							hex_disp <= (hex_disp * 10) + 20'd6;  // 6
							//leds <= 10'b0000000110;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000000010000000 : begin
							hex_disp <= (hex_disp * 10) + 20'd7;  // 7
							//leds <= 10'b0000000111;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000000100000000 : begin
							hex_disp <= (hex_disp * 10) + 20'd8;  // 8
							//leds <= 10'b0000001000;
							counter_next <= input_counter + 4'd1;
						 end
				16'b0000001000000000 : begin
							hex_disp <= (hex_disp * 10) + 20'd9;  // 9
							//leds <= 10'b0000001001;
							counter_next <= input_counter + 4'd1;
						 end
				//16'hF : begin
				//			leds <= 10'b0000001111;
				//			next_state <= 4'd1;
				//		 end
				default : begin
								hex_disp <= hex_disp;
								//leds <= 10'b0000000000;
							 end
				
			endcase
		end
		
		/*else if (state_place == 4'd3)
				begin
					hex_disp <= equation_out;
	
				end*/
	end
	
	always@(posedge clk)
	begin
		if((state_place == 4'd0)||(state_place == 4'd2)||(state_place == 4'd3))
		begin
			en_calc = 1'b1;
			flash_start = 1'b0;
		end
		if(state_place == 4'd1)
		begin
			en_calc = 1'b0;
			flash_start = 1'b0;
		end
	end

endmodule
