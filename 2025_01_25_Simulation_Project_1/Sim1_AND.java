/* Simulates a physical AND gate.
 *
 * Author: Andy Siegel
 */

public class Sim1_AND
{
	public void execute()
	{
		boolean value_a = a.get();
		boolean value_b = b.get();

		out.set(value_a && value_b);
	}

	public RussWire a,b;   // inputs
	public RussWire out;   // output

	public Sim1_AND()
	{
		a = new RussWire();
		b = new RussWire();
		out = new RussWire();
	}
}

