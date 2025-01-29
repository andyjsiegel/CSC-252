/* Simulates a physical device that performs (signed) addition on
 * a 32-bit input.
 *
 * Author: Andy Siegel
 */

public class Sim1_ADD
{
	public void execute()
	{
		boolean carryNext = false;
		
		for (int i=0; i<32; i++) {
			
			/* a half adder has two input bits, and returns a carry out and a sum
			combine two half adders to make a full adder. calculate the carry 
			for the next column with OR. */
			boolean valueA = a[i].get();
			boolean valueB = b[i].get();

			xor1[i].a.set(valueA);
			xor1[i].b.set(valueB);

			and1[i].a.set(valueA);
			and1[i].b.set(valueB);

			xor1[i].execute(); 
			and1[i].execute();

			xor2[i].a.set(xor1[i].out.get());
			xor2[i].b.set(carryNext);
			xor2[i].execute();

			and2[i].a.set(xor1[i].out.get());
			and2[i].b.set(carryNext);
			and2[i].execute();

			or[i].a.set(and1[i].out.get());
			or[i].b.set(and2[i].out.get());
			or[i].execute();

			sum[i].set(xor2[i].out.get());
			carryNext = or[i].out.get();
		}

		// carry out is the last carry
		carryOut.set(carryNext);

		// overflow logic - if the inputs have the same sign and the sum has a 
		// different sign, then overflow is set to true.
		boolean signA = a[31].get();
		boolean signB = b[31].get();
		boolean signSum = sum[31].get();

		overflow.set(signA == signB && signA != signSum); // set overflow to the result of the comparison
	}

	// ------ 
	// It should not be necessary to change anything below this line,
	// although I'm not making a formal requirement that you cannot.
	// ------ 

	// inputs
	public RussWire[] a,b;

	// outputs
	public RussWire[] sum;
	public RussWire   carryOut, overflow;
	public Sim1_XOR[] xor1 = new Sim1_XOR[32];
	public Sim1_XOR[] xor2 = new Sim1_XOR[32]; 
	public Sim1_AND[] and1 = new Sim1_AND[32];
	public Sim1_AND[] and2 = new Sim1_AND[32];
	public Sim1_OR[] or = new Sim1_OR[32];

	public Sim1_ADD()
	{
		/* Instructor's Note:
		 *
		 * In Java, to allocate an array of objects, you need two
		 * steps: you first allocate the array (which is full of null
		 * references), and then a loop which allocates a whole bunch
		 * of individual objects (one at a time), and stores those
		 * objects into the slots of the array.
		 */

		a   = new RussWire[32];
		b   = new RussWire[32];
		sum = new RussWire[32];

		for (int i=0; i<32; i++)
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
			xor1[i] = new Sim1_XOR();
			xor2[i] = new Sim1_XOR();
			and1[i] = new Sim1_AND();
			and2[i] = new Sim1_AND();
			or[i] = new Sim1_OR();
		}

		carryOut = new RussWire();
		overflow = new RussWire();
	}
}

