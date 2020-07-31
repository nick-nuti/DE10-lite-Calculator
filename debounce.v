
module debounce (input clk, input [3:0] state_place, input [15:0] keypad_debounce, output reg [15:0] keypad_decode);
									  
	reg [15:0] input_test; //input_test_compare;
	reg [19:0] counter = 20'h00000;
	reg [19:0] countupto = 20'd1000;
	reg [1:0] debounce_state;
	
	integer clock_count = 0;
	//wire clear_counter = (input_test_compare ^ input_test); 	  
	
	/*initial begin
		debounce_state = 0;
		counter = 0;
	end*/
	
	always @(posedge clk) 
	begin
		
			
        case (debounce_state)

        2'b00 : begin
                if (keypad_debounce == 16'b0) 
					 begin
					 debounce_state <= 2'b00;//if no key press, debounce is at idle 
              //  keypad_decode <= 16'b00;
					 end
					 else                                //if a key press, store that key into a temp "input_test to compare when debounce is called again
                    begin
                        input_test <= keypad_debounce;
                        debounce_state <= 2'b01;
                        counter <= 0;
								keypad_decode <= 16'b00;
                     end

                end
        2'b01 : begin//counting to 10 while key pressed to make sure the correct key is selected
                if (input_test != keypad_debounce) debounce_state = 2'b00; //if the key changed go back to state 0
                else
                    begin
                        counter = counter + 1'd1;
                        if (counter > countupto) debounce_state = 2'b10;
							end
                end
        2'b10 : begin//transistional state to detect if key has been released
                debounce_state = 2'b11; 
                counter = 0;
                end
        2'b11 : begin //final state is detect the key has released to avoid storing multiple input at one press
                if (keypad_debounce == 16'b0)//if key pad release, loop here 10 time before store the key to keypad_decode
                     begin
                        counter <= counter + 1'd1;
                        if (counter >countupto) 
                            begin
                                keypad_decode <= input_test;
										  input_test <= 16'b0;
                                debounce_state <= 2'b00;
                                counter <= 0;
                            end
                     end
                else counter <= 0; //if keypad is still hold, dont count up yet
                end
        default: debounce_state = 2'b00;

        endcase
	end
	
endmodule
