/* Simulates a physical OR gate.
 *
 * Author: Andy Siegel
 */

public class Sim1_OR
{
	// the execute function takes two boolean values and returns the OR of them.
	public void execute()
	{
		boolean value_a = a.get();
		boolean value_b = b.get();

		out.set(value_a || value_b);
	}



	public RussWire a,b;   // inputs
	public RussWire out;   // output

	public Sim1_OR()
	{
		a = new RussWire();
		b = new RussWire();
		out = new RussWire();
	}
}

