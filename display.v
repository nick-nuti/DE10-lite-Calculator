// this will only be used to display number sequences and not operation types

module display(
					input [19:0] hex_hold,
					input reset,
					input clk,
					input en_calc,
					input [9:0] buttn_track,
					input flash_start,
					input zero_check,
					output reg [7:0] hex5, hex4, hex3, hex2, hex1, hex0
					);

	wire eb_calc;
	
	localparam blank = 8'b11111111;
	localparam zero = 8'b11000000;
	localparam one = 8'b11111001;
	localparam two = 8'b10100100;
	localparam three = 8'b10110000;
	localparam four = 8'b10011001;
	localparam five = 8'b10010010;
	localparam six = 8'b10000010;
	localparam seven = 8'b11111000;
	localparam eight = 8'b10000000;
	localparam nine = 8'b10010000;
	//localparam negative = 8'b11111111; //I'm leaving this out for now
	
	localparam add = 24'b100010001010000110100001;
	localparam sub = 24'b100100101110001110000011;
	localparam mul = 32'b11001000110010001110001111000111;
	localparam div = 24'b110000001111101111100011;
	localparam log = 24'b110001111010001110010000;
	localparam pow = 32'b10001100101000111110001111100011;
	localparam fact = 32'b10001110100010001100011010001111;
	localparam dtor = 24'b101000011010010010101111;
	localparam ifn =  24'b111110111000111010101011;
	localparam err =  24'b100001101010111110101111;
	localparam nios = 32'b10101011111110111010001110010010;
	
	localparam calc = 32'b11000110100010001100011111000110;
	
	reg [27:0] beep_bop;
	
	reg [18:0] refresh;
	wire [2:0] en;
	reg [3:0] hex_decode [5:0];
	
	always@(posedge clk)
	begin
		refresh <= refresh + 16'b1;	
	end
	
	assign en = refresh [18:16];
	
	always @ (*)
	begin
		
		if  (zero_check == 1'b1)
			begin
				hex5 <= ifn[23:16];
				hex4 <= ifn[15:8]; 
				hex3 <= ifn[7:0];
				hex2 <= blank;
				hex1 <= blank;
				hex0 <= blank;
			end
	
		else if(en_calc == 1'b1)
		begin

			case(en)
			
				0 	  : begin
								hex_decode[0] <= ((((hex_hold % 100000)%10000)%1000)%100)%10;
								
								if(hex_decode[0] == 4'd0) hex0 <= zero;
								else if(hex_decode[0] == 4'd1) hex0 <= one;
								else if(hex_decode[0] == 4'd2) hex0 <= two;
								else if(hex_decode[0] == 4'd3) hex0 <= three;
								else if(hex_decode[0] == 4'd4) hex0 <= four;
								else if(hex_decode[0] == 4'd5) hex0 <= five;
								else if(hex_decode[0] == 4'd6) hex0 <= six;
								else if(hex_decode[0] == 4'd7) hex0 <= seven;
								else if(hex_decode[0] == 4'd8) hex0 <= eight;
								else if(hex_decode[0] == 4'd9) hex0 <= nine;
								else hex0 <= blank;
								
							 end
				1 	  : begin
								hex_decode[1] <= ((((hex_hold % 100000)%10000)%1000)%100)/10;
								
								if(hex_decode[1] == 4'd0) hex1 <= zero;
								else if(hex_decode[1] == 4'd1) hex1 <= one;
								else if(hex_decode[1] == 4'd2) hex1 <= two;
								else if(hex_decode[1] == 4'd3) hex1 <= three;
								else if(hex_decode[1] == 4'd4) hex1 <= four;
								else if(hex_decode[1] == 4'd5) hex1 <= five;
								else if(hex_decode[1] == 4'd6) hex1 <= six;
								else if(hex_decode[1] == 4'd7) hex1 <= seven;
								else if(hex_decode[1] == 4'd8) hex1 <= eight;
								else if(hex_decode[1] == 4'd9) hex1 <= nine;
								else hex1 <= blank;
								
							 end
				2 	  : begin
								hex_decode[2] <= (((hex_hold % 100000)%10000)%1000)/100;
								
								if(hex_decode[2] == 4'd0) hex2 <= zero;
								else if(hex_decode[2] == 4'd1) hex2 <= one;
								else if(hex_decode[2] == 4'd2) hex2 <= two;
								else if(hex_decode[2] == 4'd3) hex2 <= three;
								else if(hex_decode[2] == 4'd4) hex2 <= four;
								else if(hex_decode[2] == 4'd5) hex2 <= five;
								else if(hex_decode[2] == 4'd6) hex2 <= six;
								else if(hex_decode[2] == 4'd7) hex2 <= seven;
								else if(hex_decode[2] == 4'd8) hex2 <= eight;
								else if(hex_decode[2] == 4'd9) hex2 <= nine;
								else hex2 <= blank;
								
							 end
				3 	  : begin
								hex_decode[3] <= ((hex_hold % 100000)%10000)/1000;
								
								if(hex_decode[3] == 4'd0) hex3 <= zero;
								else if(hex_decode[3] == 4'd1) hex3 <= one;
								else if(hex_decode[3] == 4'd2) hex3 <= two;
								else if(hex_decode[3] == 4'd3) hex3 <= three;
								else if(hex_decode[3] == 4'd4) hex3 <= four;
								else if(hex_decode[3] == 4'd5) hex3 <= five;
								else if(hex_decode[3] == 4'd6) hex3 <= six;
								else if(hex_decode[3] == 4'd7) hex3 <= seven;
								else if(hex_decode[3] == 4'd8) hex3 <= eight;
								else if(hex_decode[3] == 4'd9) hex3 <= nine;
								else hex3 <= blank;
								
							 end
				4 	  : begin
								hex_decode[4] <= (hex_hold % 100000)/10000;
								
								if(hex_decode[4] == 4'd0) hex4 <= zero;
								else if(hex_decode[4] == 4'd1) hex4 <= one;
								else if(hex_decode[4] == 4'd2) hex4 <= two;
								else if(hex_decode[4] == 4'd3) hex4 <= three;
								else if(hex_decode[4] == 4'd4) hex4 <= four;
								else if(hex_decode[4] == 4'd5) hex4 <= five;
								else if(hex_decode[4] == 4'd6) hex4 <= six;
								else if(hex_decode[4] == 4'd7) hex4 <= seven;
								else if(hex_decode[4] == 4'd8) hex4 <= eight;
								else if(hex_decode[4] == 4'd9) hex4 <= nine;
								else hex4 <= blank;
								
							 end
				5 	  : begin
								hex_decode[5] <= (hex_hold / 100000);
								
								if(hex_decode[5] == 4'd0) hex5 <= zero;
								else if(hex_decode[5] == 4'd1) hex5 <= one;
								else if(hex_decode[5] == 4'd2) hex5 <= two;
								else if(hex_decode[5] == 4'd3) hex5 <= three;
								else if(hex_decode[5] == 4'd4) hex5 <= four;
								else if(hex_decode[5] == 4'd5) hex5 <= five;
								else if(hex_decode[5] == 4'd6) hex5 <= six;
								else if(hex_decode[5] == 4'd7) hex5 <= seven;
								else if(hex_decode[5] == 4'd8) hex5 <= eight;
								else if(hex_decode[5] == 4'd9) hex5 <= nine;
								else hex5 <= blank;
								
							 end
			
			endcase
			
	   end	
	  
		else if((en_calc == 1'b0) && (flash_start == 1'b0))
		begin
			
			case(buttn_track)
				10'b0000000001 : begin //add
								hex5 <= add[23:16];
								hex4 <= add[15:8]; 
								hex3 <= add[7:0];
								hex2 <= blank;
								hex1 <= blank;
								hex0 <= blank;
							 end
				10'b0000000010 : begin //sub
								hex5 <= sub[23:16];
								hex4 <= sub[15:8]; 
								hex3 <= sub[7:0];
								hex2 <= blank;
								hex1 <= blank;
								hex0 <= blank;
							 end
				10'b0000000100 : begin //mul
								hex5 <= mul[31:24];
								hex4 <= mul[23:16];
								hex3 <= mul[15:8]; 
								hex2 <= mul[7:0];
								hex1 <= blank;
								hex0 <= blank;
							 end
				10'b0000001000 : begin //div
								hex5 <= div[23:16];
								hex4 <= div[15:8]; 
								hex3 <= div[7:0];
								hex2 <= blank;
								hex1 <= blank;
								hex0 <= blank;
							 end
				10'b1000000001: begin //log
								hex5 <= log[23:16];
								hex4 <= log[15:8]; 
								hex3 <= log[7:0];
								hex2 <= two;
								hex1 <= blank;
								hex0 <= blank;
							 end
				10'b1000000010 : begin //pow
								hex5 <= pow[31:24];
								hex4 <= pow[23:16];
								hex3 <= pow[15:8]; 
								hex2 <= pow[7:0];
								hex1 <= blank;
								hex0 <= blank;
							 end
				10'b1000000100 : begin //factorial
								hex5 <= fact[31:24];
								hex4 <= fact[23:16];
								hex3 <= fact[15:8]; 
								hex2 <= fact[7:0];
								hex1 <= blank;
								hex0 <= blank;
							 end
				10'b1000001000 : begin //degrees to radians
								hex5 <= dtor[23:16];
								hex4 <= dtor[15:8]; 
								hex3 <= dtor[7:0];
								hex2 <= blank;
								hex1 <= blank;
								hex0 <= blank;
							 end
				/*10'b1000010000 : begin //tan
								hex5 <= tan[31:24];
								hex4 <= tan[23:16];
								hex3 <= tan[15:8]; 
								hex2 <= tan[7:0];
								hex1 <= blank;
								hex0 <= blank;
							 end
				
				9'b000010000 : begin //log
								hex5 <= log[23:16];
								hex4 <= log[15:8]; 
								hex3 <= log[7:0];
								hex2 <= two;
								hex1 <= blank;
								hex0 <= blank;
							 end
				9'b000100000 : begin //pow
								hex5 <= pow[31:24];
								hex4 <= pow[23:16];
								hex3 <= pow[15:8]; 
								hex2 <= pow[7:0];
								hex1 <= blank;
								hex0 <= blank;
							 end
				9'b001000000 : begin //sin
								hex5 <= sin[23:16];
								hex4 <= sin[15:8]; 
								hex3 <= sin[7:0];
								hex2 <= blank;
								hex1 <= blank;
								hex0 <= blank;
							 end
				9'b010000000 : begin //cos
								hex5 <= cos[23:16];
								hex4 <= cos[15:8]; 
								hex3 <= cos[7:0];
								hex2 <= blank;
								hex1 <= blank;
								hex0 <= blank;
							 end
				9'b100000000 : begin //tan
								hex5 <= tan[31:24];
								hex4 <= tan[23:16];
								hex3 <= tan[15:8]; 
								hex2 <= tan[7:0];
								hex1 <= blank;
								hex0 <= blank;
							 end*/
				default : begin
								hex5 <= blank;
								hex4 <= blank; 
								hex3 <= blank;
								hex2 <= blank;
								hex1 <= blank;
								hex0 <= blank;
							 end
			endcase
			
		end
		
		/*
		else if(flash_start == 1'b1)
		begin
			
			if(beep_bop == 1)
			begin
			
				hex5 <= calc[31:24];
				hex4 <= calc[23:16]; 
				hex3 <= calc[15:8];
				hex2 <= calc[7:0];
				hex1 <= blank;
				hex0 <= blank;
				
			end
			
			else if(beep_bop == 25000000)
			begin
			
				hex5 <= blank;
				hex4 <= blank; 
				hex3 <= blank;
				hex2 <= blank;
				hex1 <= blank;
				hex0 <= blank;
			
			end
			
			else if(beep_bop == 50000000)
			begin
			
				beep_bop = 0;
			
			end
			
			beep_bop = beep_bop + 1;
		
		end*/
	
	end
	
endmodule
