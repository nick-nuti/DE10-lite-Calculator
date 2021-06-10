# DE10-nano-Calculator
Scientific calculator on Intel DE10-nano FPGA + NIOS II processor.
  - Calculator is capable of the following:
    - Addition, Subtraction, Multiplication, Division, Log10, Power, Factorial, Degrees to Radians, Negative numbers
    - Using Verilog to debounce keypresses
    - Carrying over answer of previous operation to operand 1 of next equation
    - Displaying answer on DE10-nano seven segment displays (truncated)
    - Displaying "double" formatted answer to a PC using NIOS II UART

- Requires a Digilent PMOD keypad to run this program: https://store.digilentinc.com/pmod-kypd-16-button-keypad/
-******NOTE THIS PROJECT WAS DONE USING QUARTUS 18.1; IF YOU SEE WEIRD RESULTS IT'S DUE TO VERSION DIFFERENCES******

Pinout for keypad is as follows:
- Pinout (https://reference.digilentinc.com/reference/pmod/pmodkypd/reference-manual?_ga=2.92793757.1442846861.1596228241-882181328.1596228241)
(Keypad Pin,DE-10 Nano):
(Pin 1, Pin_W12), 
(Pin 2, Pin_AB12), 
(Pin 3, Pin_AB11), 
(Pin 4, Pin_AB10), 
(Pin 5, GND), 
(Pin 6, 5/3.3V), 
(Pin 7, Pin_AB13), 
(Pin 8, Pin_Y11), 
(Pin 9, Pin_W11), 
(Pin 10, Pin_AA10), 
(Pin 11, GND), 
(Pin 12, 5/3.3V)

General State Machine:

State 0:
  - Reset (async: enter this state via KEY0 button)
  
State 1:
  - Type in operand 0 using keypad, enter the number by pressing KEY1 button
  - Advance to state 2
  
State 2:
  - Choose operator
    - SW9 is off
      - SW0 is on -> Add
      - SW1 is on -> Sub
      - SW2 is on -> Mul
      - SW3 is on -> Div
    - SW9 is on
      - SW0 is on -> Log_2
      - SW1 is on -> Pow
      - SW2 is on -> Fact
      - SW3 is on -> D2r
  - Enter desired operator by pressing KEY1 button
  - Advance to state 3
  
State 3:
  - Type in operand 1 using keypad, enter the number by pressing KEY1 button
  - Advance to state 4
  
State 4:
  - Show the output of the operation. Output will show in NIOS II uart terminal (in float format); output will also show on SSD on FPGA dev board. Obviously the uart terminal will show the best and most accurate results
  - Press KEY1 to use output as operand0 and advance to state 2
  - Press KEY0 to reset operation and advance to state 0
  
Note: Calculator can handle negative outputs and negative operands
  
  
  
***Easiest way to run the project:***
1. Download the .qar file
2. Open the .qar file using Quartus
3. Run compilation
4. Program the FPGA
5. In file explorer, open "Calculator_restored -> software -> nios2_uart_sw_bsp" directory
6. Edit "settings.bsp"
  6a. Change "BspGeneratedLocation" path to whatever the path to the directory is on your pc (inside of generated Calculator_restored project directory)
  6b. Change "SopcDesignFile" path to whatever the path to the .sopc file is on your pc
7. In Quartus -> tools -> nios ii software build tools for eclipse
8. Eclipse opens, open workspace at "Calculator_restored -> software"
9. Go to "File -> import", then "general -> existing projects in workspace", then "browse"
  9a. Navigate to "Calculator_restored -> software" and press ok
  9b. Under "Projects", "nios2_uart_sw" and "nios2_uart_sw_bsp" will show up, make sure they have check-marks next to them and press finish
  9c. "nios2_uart_sw" and "nios2_uart_sw_bsp" should show up under project explorer at this point
10. Go to "Nios II -> BSP Editor" in top bar
11. "File -> open", navigate to "Calculator_restored -> software -> nios2_uart_sw_bsp", and open "settings.bsp"
12. Hit "generate" and exit BSP editor
13. Right-click "nios2_uart_sw_bsp" directory in the project explorer and press "NIOS II -> Generate BSP"
14. Project -> Build all
15. Run -> Run configurations
  15a. Double-click "nios II hardware"
  15b. "New_configuration" will show up, click on it
  15c. Under "new configuration", go to project, press on project name and select "nios2_uart_sw"
  15d. Go to "target connection", make sure you can see USB Blaster (if you can't, hit refresh connections), select the USB Blaster, and click run
  
