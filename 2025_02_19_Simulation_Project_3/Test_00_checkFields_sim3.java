/* Testcase for Sim3.
 *
 * Author: Russ Lewis
 *
 * This testcase simply connects to all of the student classes; it exists to
 * sanity-check that the types of all of the inputs/outputs are correct.
 */

public class Test_00_checkFields_sim3
{
	public static void main(String[] args)
	{
		Sim3_MUX_8by1   mux  = new Sim3_MUX_8by1();
		Sim3_ALUElement alu_element = new Sim3_ALUElement();
		Sim3_ALU        alu  = new Sim3_ALU(4);

		/* we just just check the various fields - just to see
		 * if they exist.  This is *NOT* a logical test of any
		 * of the functionality!
		 */

		mux.control[0].set(false);
		mux.control[1].set(false);
		mux.control[2].set(true);
		mux.in[0].set(false);
		mux.in[1].set(false);
		mux.in[2].set(false);
		mux.in[3].set(false);
		mux.in[4].set(true);
		mux.in[5].set(false);
		mux.in[6].set(false);
		mux.in[7].set(false);
		mux.execute();
		System.out.printf("MUX: control=4 in={0,0,0,0,1,0,0,0} -> %s\n",
		                  mux.out.get());

		alu_element.aluOp[0].set(true);
		alu_element.aluOp[1].set(false);
		alu_element.aluOp[2].set(false);
		alu_element.bInvert.set(false);
		alu_element.a.set(true);
		alu_element.b.set(true);
		alu_element.carryIn.set(true);
		alu_element.less.set(true);
		alu_element.execute_pass1();
		alu_element.execute_pass2();
		System.out.printf("ALU Element: aluOp=1 bInvert=%s : a=%s b=%s carryIn=%s less=%s -> result=%s addResult=%s carryOut=%s\n",
		                  alu_element.bInvert.get(),
		                  alu_element.a.get(), alu_element.b.get(),
		                  alu_element.carryIn.get(), alu_element.less.get(),
		                  alu_element.result.get(), alu_element.addResult.get(),
		                  alu_element.carryOut.get());

		alu.aluOp[0].set(false);
		alu.aluOp[1].set(true);
		alu.aluOp[2].set(false);
		alu.bNegate.set(true);

		alu.a[0].set(true);
		alu.a[1].set(false);
		alu.a[2].set(false);
		alu.a[3].set(true);

		alu.b[0].set(true);
		alu.b[1].set(true);
		alu.b[2].set(true);
		alu.b[3].set(true);

		alu.execute();

		System.out.printf("ALU: aluOp=2 bNegate=1 : a=9 b=15 : result={[0]:%s,[1]:%s,[2]:%s,[3]:%s}\n",
		                  alu.result[0].get(), alu.result[1].get(),
		                  alu.result[2].get(), alu.result[3].get());
	}
}

