/* Implementation of a 32-bit adder in C.
 *
 * Author: Andy Siegel
 */


#include "sim1.h"

void execute_add(Sim1Data *obj) {
	
	// get the addends
	int a = (int)obj->a;  
    int b = (int)obj->b;
    
	obj->sum = 0;  // Initialize the sum to 0

    // Check if we are performing subtraction
    int isSubtraction = obj->isSubtraction;
    int carry = isSubtraction; // carry for subtraction is 1

    // Iterate over each bit
    for (int i = 0; i < 32; i++) {
		if (isSubtraction) { // if the bit needs to be substracted, flip the bit before assingning it 
        	// Flip the bits of b (XOR with 1) to get the 1's complement 
			// (by passing in isSubtraction as carry) this is now 2s complement
            b = b ^ (1 << i);  // flip the i-th bit of b with XOR operator     
    	}
        // Extract bits from a and b
        int aBit = (a >> i) & 1; // Get the i-th bit of a
        int bBit = (b >> i) & 1; // Get the i-th bit of b
		// take 'xor' of a and b with ^ and 'and' with &
		int xor1 = aBit ^ bBit;
		int and1 = aBit & bBit;
		int xor2 = xor1 ^ carry;
		int and2 = xor1 & carry;
		int or = and1 | and2;
		carry = or;
		int sumBit = xor2;
		// use bitwise or to set the i-th bit of the sum
		obj->sum |= (sumBit << i);
	}

	// shift the bits by 31 - this moves the MSB to the LSB
	// use bitwise AND - if the MSB is 1, then the result is 0
	// use == 0 to "flip" the result so the flag is accurate
	obj->aNonNeg = ((obj->a >> 31) & 1) == 0; 
    obj->bNonNeg = ((obj->b >> 31) & 1) == 0; 
	obj->sumNonNeg = ((obj->sum >> 31) & 1) == 0; 

	// for a and sum, flip the value of the flag. 
	int aSign = (obj->a >> 31) & 1;
    int bSignBit = obj->b >> 31; // Extract the sign bit (0 or 1)
	
	// If we're doing subtraction, invert the sign bit
	if (isSubtraction) {
		bSignBit = ~bSignBit;
	}
	int bSign = bSignBit & 1;
    int sumSign = (obj->sum >> 31) & 1;

	obj->carryOut = carry;
	obj->overflow = ((aSign == bSign) && (aSign != sumSign));
}