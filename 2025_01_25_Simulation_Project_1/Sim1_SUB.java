/* Simulates a physical device that performs (signed) subtraction on
 * a 32-bit input.
 *
 * Author: Andy Siegel
 */

public class Sim1_SUB
{
	// this function subtracts two 32-bit binary numbers. it does this by using twos complement
	// on the second number as `a-b` = `a + (-b)`
	public void execute()
	{
		// first loop, set the first addend of the adder and
		// add all of b's bits to the twos complement
		for (int i=0; i<32; i++) {
			adder.a[i].set(a[i].get());
			twos.in[i].set(b[i].get());
		}
		// execute twos complement on b
		twos.execute();

		// add the twosified b value to the adder
		for (int i=0; i<32; i++) {
			adder.b[i].set(twos.out[i].get());
		}
		
		// add a + (-b) to calculate the difference
		adder.execute();
		
		// set the output
		for (int i=0; i<32; i++) {
			sum[i].set(adder.sum[i].get());
		}
	}



	// --------------------
	// Don't change the following standard variables...
	// --------------------

	// inputs
	public RussWire[] a,b;

	// output
	public RussWire[] sum;

	// --------------------
	// But you should add some *MORE* variables here.
	// --------------------
	public Sim1_ADD adder;
	public Sim1_2sComplement twos;

	public Sim1_SUB()
	{
		a = new RussWire[32];
		b = new RussWire[32];
		sum = new RussWire[32];
		for (int i=0; i<32; i++)
		
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
		}

		adder = new Sim1_ADD();
		twos = new Sim1_2sComplement();
	}
}

