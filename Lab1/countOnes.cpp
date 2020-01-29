/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	
	unsigned int temp, tempR, tempL;

	unsigned int r1 = 0x55555555;
	unsigned int l1 = ~r1;

	tempR = input&r1;
	tempL = input&l1;
	temp = (tempL >> 1)+tempR;

	unsigned int r2 = 0x33333333;
	unsigned int l2 = ~r2;

	tempR = temp&r2;
	tempL = temp&l2;
	temp = (tempL >> 2)+tempR;

	unsigned int r3 = 0x0f0f0f0f;
	unsigned int l3 = ~r3;

	tempR = temp&r3;
	tempL = temp&l3;
	temp = (tempL >> 4)+tempR;

	unsigned int r4 = 0x00ff00ff;
	unsigned int l4 = ~r4;

	tempR = temp&r4;
	tempL = temp&l4;
	temp = (tempL >> 8)+tempR;

	unsigned int r5 = 0x0000ffff;
	unsigned int l5 = ~r5;

	tempR = temp&r5;
	tempL = temp&l5;
	temp = (temp >> 16)+tempR;

	input = temp;
	return input;
}
