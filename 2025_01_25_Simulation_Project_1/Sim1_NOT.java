/* Simulates a physical NOT gate.
 *
 * Author: Andy Siegel
 */

public class Sim1_NOT
{
	// the execute function takes a boolean value and negates it. 
	public void execute()
	{
		
		boolean value = in.get();
		out.set(!value);
	}



	public RussWire in;    // input
	public RussWire out;   // output

	public Sim1_NOT()
	{
		in = new RussWire();
		out = new RussWire();
	}
}

