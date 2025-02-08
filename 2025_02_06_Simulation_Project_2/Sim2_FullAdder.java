/* This class implements a full adder in Java. It has three inputs, a, b, and
 * carryIn, and two outputs, sum and carryOut.
 * Author: Andy Siegel
 */
public class Sim2_FullAdder {
    
    // inputs
    RussWire a,b,carryIn;

    // outputs
    RussWire sum, carryOut;
    
    // logic components
    Sim2_HalfAdder halfAdder1, halfAdder2;
    OR or;
    
    public Sim2_FullAdder() {
        a = new RussWire();
        b = new RussWire();
        carryIn = new RussWire();

        sum = new RussWire();
        carryOut = new RussWire();

        halfAdder1 = new Sim2_HalfAdder();
        halfAdder2 = new Sim2_HalfAdder();
        or = new OR();
    }
    /*  This method executes the full adder. It takes two inputs, a and b, as 
        RussWires. It executes the first half adder, and uses the results of 
        that in the second half adder. The sum is returned and the carryOut is
        calculated with the OR of both halfAdder's carries. */
    public void execute() {
        halfAdder1.a.set(a.get());
        halfAdder1.b.set(b.get());
        halfAdder1.execute();
        // half adder returns sum & carry, to get full output we need to put
        // XOR of sum and carry as input to the next half adder

        halfAdder2.a.set(halfAdder1.sum.get());
        halfAdder2.b.set(carryIn.get());
        halfAdder2.execute();

        sum.set(halfAdder2.sum.get());
        
        /* carryOut (to the next adder) can come from the carryIn OR the 
        carryOut of the half adder */
        
        // carryOut.set(halfAdder2.carry.get() | halfAdder1.carry.get());
        or.a.set(halfAdder2.carry.get());
        or.b.set(halfAdder1.carry.get());
        or.execute();
        carryOut.set(or.out.get());
    }
}