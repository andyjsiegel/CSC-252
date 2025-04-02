/* This class implements a half adder in Java. It has two inputs, a and b,
 * and two outputs, sum and carry.
 * Author: Andy Siegel
 */
public class Sim2_HalfAdder {
    // inputs
    RussWire a,b = new RussWire();
    // outputs
    RussWire sum, carry;
    // gates
    AND and;
    XOR xor;
    
    // initializes the half adder with RussWires for a, b, sum, and carry plus an AND and XOR gate
    public Sim2_HalfAdder() {
        a = new RussWire();
        b = new RussWire();
        sum = new RussWire();
        carry = new RussWire();
        xor = new XOR();
        and = new AND();
    }

    /*  This code executes the half adder. After a and b (boolean values as RussWires)
        are set, the sum and carry are calculated using XOR and AND. */
    public void execute() {
        // sum.set(a.get() ^ b.get());
        xor.a.set(a.get());
        xor.b.set(b.get());
        xor.execute();
        sum.set(xor.out.get());

        // carry.set(a.get() & b.get());
        and.a.set(a.get());
        and.b.set(b.get());
        and.execute();
        carry.set(and.out.get());
    }
}