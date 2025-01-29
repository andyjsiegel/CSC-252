/* Simulates a physical device that performs 2's complement on a 32-bit input.
 *
 * Author: Andy Siegel
 */

public class Sim1_2sComplement
{
	public void execute()
	{

		for (int i=0; i<32; i++) {
			boolean value = in[i].get();
			inverters[i].in.set(value);
			inverters[i].execute();
			adder.a[i].set(inverters[i].out.get());
			if (i != 0) {
				adder.b[i].set(false);
			}
		}

		adder.b[0].set(true);
		adder.execute();

		for (int i=0; i<32; i++) {
			// System.out.print(adder.b[i].get() ? 1 : 0);
			out[i].set(adder.sum[i].get());
		}

	}

	// you shouldn't change these standard variables...
	public RussWire[] in;
	public RussWire[] out;
	
	public Sim1_NOT[] inverters;
	public Sim1_ADD adder;

	public Sim1_2sComplement()
	{
		in = new RussWire[32];
		out = new RussWire[32];
		inverters = new Sim1_NOT[32];
		for (int i=0; i<32; i++)
		{
			in[i] = new RussWire();
			out[i] = new RussWire();
			inverters[i] = new Sim1_NOT();
		}

		adder = new Sim1_ADD();
	}
}

