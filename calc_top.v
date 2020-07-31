/* here is the changes:

1: clear the hex_disp and counter_next to 0 when bttn0/bttn1 pressed
2: change bttn_track to be 10 bit and account the mode selection which is on sw[9]. this lead to the chage in cases of keypadtodisp function when display the operation
3: added the "bare bone" of state 3 to do the calculation. to show result i added this to the keypadtodisp "hex_disp <= equation_out;" (i think this should work as it is)
current problem: display all 0 when output result. I believe this is due to the reset hex_disp to 0 on the negative edge of the bttn1 detect. this then is fetch back into the operand0 and operand1
that lead to the result only display 0. just a thought i have but i think it might be case since the operand is taken value on the change of state while the hex_disp is change as soon as the negedge
being detected. So the reset to 0 on hex_display might happened fist and store that value into the operand before the state could have change.  i know it is all parrallel but still gat delay is 
different so this might be the case

*/
module calc_top(input fifty_MHz, input reset, input [3:0] row, output [3:0] column, input bttn1, input bttn0, input [9:0] sw, output [47:0] hex, output reg [9:0] leds);
	
	reg [22:0] number_out;
	
		uart_qsys u0 (
		.clk_clk                 (fifty_MHz),                 //              clk.clk
		.pio_fpga_to_nios_export (number_out), 					// pio_fpga_to_nios.export
		.reset_reset_n           (reset)                      //            reset.reset_n
	);

	wire twentyfive_mhz;
	
	twentyfive_mhz c0 (.clk(fifty_MHz), .twentyfive_mhz(twentyfive_mhz));
	
	wire [15:0] keypad;
	wire [3:0] keypad_decode;
	
	reg [3:0] state_place = 4'd0;
	wire [3:0] next_state;
	wire [19:0] hex_disp;
	
	wire [9:0] bttn_track;
	wire flash_start;
	wire en_calc;

	//reg reset = 1'b1;
	
	wire [19:0] operand_one;
	wire [19:0] operand_two;
	wire [19:0] equation_out;
	
	reg useanswer = 1'b0;
	
	wire [19:0] equation_out_disp;
	wire neg_out;
	reg zero_check;
	
	//always@(sw)
	//begin
	//	hex_disp <= ((sw[9]*(2**9))+(sw[8]*(2**8))+(sw[7]*(2**7))+(sw[6]*(2**6))+(sw[5]*(2**5))+(sw[4]*(2**4))+(sw[3]*(2**3))+(sw[2]*(2**2))+(sw[1]*(2**1))+(sw[0]*(2**0)));
	//end
	
	always@(negedge bttn0 or negedge bttn1)
    begin
        if(~bttn0) 
		  begin
				state_place = 4'd0;
				useanswer = 1'b0;
				number_out = 23'b11100000000000000000000;
				zero_check = 1'b0;
		  end	
				
		  else if(~bttn1) 
		  begin
					case (state_place)
					
					4'd0: begin
								number_out = 23'b00100000000000000000000 | operand_one;
								state_place = 4'd1;
						   end
						  
					4'd1: begin
								
								if ((sw[9:0] == 10'b1000000001) || (sw[9:0] == 10'b1000000100) || (sw[9:0] == 10'b1000001000) || (sw[9:0] == 10'b1000001000))
								begin
									number_out = 23'b01100000000000000000000 | bttn_track;
									state_place = 4'd3;
								end
								
								else 
								begin
									number_out = 23'b01000000000000000000000 | bttn_track;
									state_place = 4'd2;
								end
							end
							
					4'd2: begin
								if  ((operand_two == 0)&& (sw[9:0] == 10'b0000001000)) begin zero_check = 1'b1; number_out = 23'b10000000000000000000000 | operand_two;state_place = 4'd3; end
								else 
								begin
								number_out = 23'b10000000000000000000000 | operand_two;
								state_place = 4'd3;
								end
							end
							
					4'd3: begin
								number_out = 23'b10100000000000000000000; // tell microprocessor to reuse the output
								state_place = 4'd1;
								useanswer = 1'b1;
							end
				
				default : state_place = 4'd0;
				endcase
				
			end
			
			//else if((state_place == 4'd4)||(~bttn1)) state_place = 4'd1;

		  /*else if ((state_place < 4'd3)&& (sw[9] ==0 )) state_place = state_place + 4'd1;
		  
		  //else if ((state_place < 4'd3)&& (sw[9] == 0)) state_place = state_place + 4'd1;
		  
		  else if ((state_place == 4'd1) && (sw[9] ==1)) state_place = 4'd3;
		  //else if ((state_place == 4'd1)) state_place = 4'd3;
		  
		   else if((state_place == 4'd4)||(~bttn1)) state_place = 4'd1;*/
				


    end
	
	
	always@(posedge twentyfive_mhz)
	begin
		case(state_place)
			
				4'd0: leds <= 10'b0000000000;
				4'd1: leds <= 10'b0000000001;
				4'd2: leds <= 10'b0000000010;
				4'd3: begin
							if(neg_out == 1'b1)
								leds <= 10'b1000000011;
							else
								leds <= 10'b0000000011;
						end
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
	end
    
	display d0 (.hex_hold(hex_disp), .reset(bttn1), .clk(fifty_MHz), .en_calc(en_calc), .buttn_track(bttn_track), .flash_start(flash_start), .hex5(hex[47:40]), .hex4(hex[39:32]), .hex3(hex[31:24]),
				.hex2(hex[23:16]), .hex1(hex[15:8]), .hex0(hex[7:0]), .zero_check(zero_check));
	
	keypad k0 (.clk(twentyfive_mhz), .state_place(state_place), .row(row), .column(column), .decode(keypad));
	
	keypadtodisp kd0 (.clk(twentyfive_mhz), .state_place(state_place), .equation_out(equation_out_disp), .keypad_decode(keypad), .bttn0(bttn0), .bttn1(bttn1), .hex_disp(hex_disp), .en_calc(en_calc), .flash_start(flash_start));
	
	state0 s0 (.equation_out(equation_out), .useanswer(useanswer), .state_place(state_place), .clk(twentyfive_mhz), .hex_disp(hex_disp), .operand_one(operand_one));
	
	state1 t0 (.state_place(state_place),.clk(twentyfive_mhz), .sw(sw), .bttn_track(bttn_track));
	
	state2 a0 (.state_place(state_place),.clk(twentyfive_mhz), .hex_disp(hex_disp), .operand_two(operand_two));
	
	state3 b0 (.clk(twentyfive_mhz), .state_place(state_place), .operand_two(operand_two), .operand_one(operand_one), .bttn_track(bttn_track), .equation_out(equation_out), 
		.equation_out_disp(equation_out_disp), .neg_out(neg_out), .zero_check(zero_check));
	
endmodule	


module state0(input [19:0] equation_out, input useanswer, input clk, input [3:0] state_place, input [19:0] hex_disp, output reg [19:0] operand_one);

	always@(posedge clk)
	//always@( state_place or hex_disp)
	begin
		if(state_place == 4'd0)
		begin
			//if(useanswer == 1'b1)
			//	operand_one <= equation_out;
			//else
				operand_one <= hex_disp;
		end
		
		if((state_place == 4'd1)&&(useanswer == 1'd1))
		begin
			operand_one <= equation_out;
		end
	end

endmodule

module state1(input clk, input [3:0] state_place, input [9:0] sw, output reg [9:0] bttn_track);

	always@(posedge clk)
	//always@(state_place or sw)
	begin
		if(state_place == 4'd1)
		begin
			bttn_track <= sw;
		end
	end

endmodule

module state2(input clk, input [3:0] state_place, input [19:0] hex_disp, output reg [19:0] operand_two);

	always@(posedge clk)
	//always@(posedge clk or state_place or hex_disp)
	begin
		if(state_place == 4'd2)
		begin
			operand_two <= hex_disp;
		end
	end

endmodule

module state3 (input clk, input [3:0] state_place, input [19:0] operand_two, input [19:0] operand_one, input [9:0] bttn_track, output reg [19:0] equation_out, 
					output reg [19:0] equation_out_disp, output reg neg_out,  input zero_check);
	
	integer i;
	initial i =0;
	reg [19:0] operand_one_hold;
	reg [19:0] operand_two_hold;
	
	always @ (posedge clk)
		begin
			if (state_place == 4'd3)
			begin
				case (bttn_track)
				
				10'b0000000001: begin 
										equation_out <= operand_one + operand_two;
										
										if(equation_out[19] == 1'b1)
										begin
											equation_out_disp <= ((~equation_out)+20'd1);
											neg_out <= 1'd1;
										end
										
										else
										begin
											equation_out_disp <= equation_out;
											neg_out <= 1'd0;
										end
										
									 end
				
				10'b0000000010: begin 
										equation_out <= operand_one - operand_two;
										
										if(equation_out[19] == 1'b1)
										begin
											equation_out_disp <= ((~equation_out)+20'd1);
											neg_out <= 1'd1;
										end
										
										else
										begin
											equation_out_disp <= equation_out;
											neg_out <= 1'd0;
										end
										
									 end
				
				10'b0000000100: begin 
										equation_out <= operand_one * operand_two;
										
										if(equation_out[19] == 1'b1)
										begin
											equation_out_disp <= ((~equation_out)+20'd1);
											neg_out <= 1'd1;
										end
										
										else
										begin
											equation_out_disp <= equation_out;
											neg_out <= 1'd0;
										end
										
									 end
				
				10'b0000001000: begin 
										
										if (zero_check == 1'b1)
										begin
										  equation_out <= 20'b0; 
										
										end
										else 
										begin
										equation_out <= (operand_one / operand_two);
										
										if(equation_out[19] == 1'b1)
										begin
											equation_out_disp <= ((~equation_out)+20'd1);
											
											neg_out <= 1'd1;
										end
										
										else if (equation_out[19] == 1'b0)
										begin
											equation_out_disp <= equation_out;
											neg_out <= 1'd0;
										end
										end
									 end
				
				10'b1000000001: begin 
									if (i == 0) begin operand_one_hold <= operand_one; i = i +1; end
									else if ((i > 0) && (operand_one_hold >= 2))
										begin
											operand_one_hold <= operand_one_hold /2;
											i = i +1;
										end
									else if (operand_one_hold <2)
										begin
											equation_out <= (i -1 );
											
											if(equation_out[19] == 1'b1)
											begin
												equation_out_disp <= ((~equation_out)+20'd1);
												neg_out <= 1'd1;
											end
											
											else
											begin
												equation_out_disp <= equation_out;
												neg_out <= 1'd0;
											end
											
											i =0;
											
										end
				
									end
			
				
				10'b1000000010: begin 
										//equation_out <= (operand_one **2);
										
										if (i == 0) begin operand_one_hold <= operand_one; i = i +1; end
										else if ((i> 0) && (i < operand_two))
										begin
											operand_one_hold <= operand_one_hold * operand_one;i = i +1;
										end
										else begin 
											equation_out <= operand_one_hold; 
											
											if(equation_out[19] == 1'b1)
											begin
												equation_out_disp <= ((~equation_out)+20'd1);
												neg_out <= 1'd1;
											end
											
											else
											begin
												equation_out_disp <= equation_out;
												neg_out <= 1'd0;
											end
											
											operand_one_hold <= 0; 
											i <=0; 
										end
										
									end
				
				10'b1000000100: begin 
										if (i == 0) begin 
											operand_one_hold <= 1; 
											i <= 1; 
										end
										
										else if ((i <= operand_one)&&(operand_one_hold!=0))
										begin
											operand_one_hold <= operand_one_hold * i;
											i = i + 1;
										end
											
										else
										begin
											equation_out <= operand_one_hold;
											
											if(equation_out[19] == 1'b1)
											begin
												equation_out_disp <= ((~equation_out)+20'd1);
												neg_out <= 1'd1;
											end
											
											else
											begin
												equation_out_disp <= equation_out;
												neg_out <= 1'd0;
											end
												
											i <= 0;
											operand_one_hold<=0;
										end
										
									 
									 end
				
				10'b1000001000: begin 
										equation_out <= (3*operand_one)/180;
										
										if(equation_out[19] == 1'b1)
										begin
											equation_out_disp <= ((~equation_out)+20'd1);
											neg_out <= 1'd1;
										end
										
										else
										begin
											equation_out_disp <= equation_out;
											neg_out <= 1'd0;
										end
												
									 end
				
				default		 : begin equation_out <= 6'd999999; end
				
				endcase
				
			end
		end

endmodule
