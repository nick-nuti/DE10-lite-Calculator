//#include "sys/alt_stdio.h"
#include <stdio.h>
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include <string.h>
#include <stdlib.h>
#include <unistd.h> //adds usleep
#include <math.h>

#define PIO_0_BASE 0x0

int calc_input;
double op_1; //needs to be long double
int op_2;
int operation;
double output;//needs to be long double

int alreadyhappened = 0b0111111;

int main()
{ 
  printf("Calculator!\n");

  /* Event loop never exits. */
  while (1)
  {
	  usleep(100000);

	  calc_input = IORD_ALTERA_AVALON_PIO_DATA(PIO_0_BASE);

	  if(((calc_input >> 20) == 0b111)&&((alreadyhappened&0b1000000)!=0b1000000)){
		  printf("\nRESET!!!\n");
		  alreadyhappened = 0b1000000;
	  }

	  /*
	   * some things that need to be worked out:
	   * 	- single number operations
	   * 	- reusing output as operand 1
	   */

	  if(((calc_input >> 20) == 0b001)&&((alreadyhappened&0b0000001)!=0b0000001)){
		  //printf("%d ", (calc_input & 0x0FFFFF));
		  op_1 = (calc_input & 0x0FFFFF);
		  printf("%.3f ", op_1);
		  alreadyhappened = 0b1;
	  }

	  if(((calc_input >> 20) == 0b010)&&((alreadyhappened&0b0000010)!=0b10)){
		  //printf("%d ", (calc_input & 0x0FFFFF));
		  operation = (calc_input & 0x0003FF);

		  if(operation == 0b0000000001){
			  printf("+ ");
		  }

		  if(operation == 0b0000000010){
			  printf("- ");
		  }

		  if(operation == 0b0000000100){
			  printf("* ");
		  }

		  if(operation == 0b0000001000){
			  printf("/ ");
		  }

		  if(operation == 0b1000000010){
			  printf("^ ");
		  }

		  alreadyhappened = 0b11;
	  }

	  if(((calc_input >> 20) == 0b011)&&((alreadyhappened&0b0000100)!=0b100)){
		  //printf("%d ", (calc_input & 0x0FFFFF));
		  operation = (calc_input & 0x0003FF);

		  if(operation == 0b1000000001){
			  printf("log2 ");
			  output = log2f(op_1);
		  }

		  if(operation == 0b1000000100){
			  printf("! ");
			  int fact_accum = 1;
			  for(int i = 1; i < (((int)op_1)+1); i=i+1){
				  fact_accum = fact_accum * i;
			  }

			  output = fact_accum;
		  }

		  if(operation == 0b1000001000){
			  printf("degrees -> radians ");
			  output = op_1 * (M_PI/180);
		  }
		  printf("= %.3f\n", output);
		  alreadyhappened = 0b111;
	  }

	  if(((calc_input >> 20) == 0b100)&&((alreadyhappened&0b0001000)!=0b1000)){
		  //printf("%d ", (calc_input & 0x0FFFFF));
		  op_2 = (calc_input & 0x0FFFFF);
		  printf("%d ", op_2);
		  usleep(1000);

		  if(operation == 0b0000000001){
			  output = op_1 + op_2;
		  }

		  if(operation == 0b0000000010){
			  output = op_1 - op_2;
		  }

		  if(operation == 0b0000000100){
			  output = op_1 * op_2;
		  }

		  if(operation == 0b0000001000){
			  output = op_1 / op_2;
		  }

		  if(operation == 0b1000000010){
			  output = pow(op_1, op_2);
		  }

		  printf("= %.3f\n", output);
		  alreadyhappened = 0b1111;
	  }

	  if(((calc_input >> 20) == 0b101)&&((alreadyhappened&0b0010000)!=0b10000)){
		  //printf("%here ");
		  printf("%.3f ", output);
		  op_1 = output;
		  alreadyhappened = 0b10000;
	  }
  }
}
