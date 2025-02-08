// This class implements a full adder of X bits in Java. It has three inputs, a, b, and
// carryIn, and two outputs, sum and carryOut.
// a and b are arrays of RussWires, and the sum is also stored in an array of RussWires.
// overflow is calculated using two XOR gates, an AND gate, and a NOT gate.
// Author: Andy Siegel

public class Sim2_AdderX {

    boolean carryNext = false;
    int bits;

    Sim2_FullAdder[] fullAdders;
    RussWire[] a,b;
    RussWire[] sum;
    RussWire overflow;
    RussWire carryOut;

    XOR xorForEquals;
    NOT not;
    XOR xorForNotEquals;
    AND and;

    public Sim2_AdderX(int bits) {
        this.bits = bits;
        
        fullAdders = new Sim2_FullAdder[bits];
        a = new RussWire[bits];
        b = new RussWire[bits];
        sum = new RussWire[bits];

        carryOut = new RussWire();
        overflow = new RussWire();

        // to check for overflow, we need to implement == & != without those operators
        // this can be done with NOT XOR for equals: not(a ^ b)
        // and XOR for not equals: a ^ b
        // finally, we must use an AND gate to compare the two values.
        xorForEquals = new XOR();
        xorForNotEquals = new XOR();
        and = new AND();
        not = new NOT();

        for(int i=0; i<bits; i++) {
            fullAdders[i] = new Sim2_FullAdder();
            a[i] = new RussWire();
            b[i] = new RussWire();
            sum[i] = new RussWire();
        }
    }

    /*  this method executes the adderX, which takes in two arrays of bits as 
        RussWires and adds them together using the fullAdder in a loop. 
        Finally, it sets the carryOut to the last carry and checks whether there
        is overflow by checking the signs of the inputs and the sum. */
    public void execute() {
        for(int i=0; i<bits; i++) {
            fullAdders[i].a.set(a[i].get());
            fullAdders[i].b.set(b[i].get());
            fullAdders[i].carryIn.set(carryNext);
            fullAdders[i].execute();
            carryNext = fullAdders[i].carryOut.get();
            sum[i].set(fullAdders[i].sum.get());
        }

        // overflow.set(a[bits-1].get() == b[bits-1].get() && sum[bits-1].get() != a[bits-1].get());
        
        // MSB of a & b ==
        xorForEquals.a.set(a[bits-1].get());
        xorForEquals.b.set(b[bits-1].get());
        xorForEquals.execute();
        not.in.set(xorForEquals.out.get());
        not.execute();
        // not.out().get() = (a[bits-1].get() == b[bits-1].get())

        // MSB of sum != MSB of a
        xorForNotEquals.a.set(sum[bits-1].get());
        xorForNotEquals.b.set(a[bits-1].get());
        xorForNotEquals.execute();
        // xorForNotEquals.out().get() = (sum[bits-1].get() != a[bits-1].get())

        and.a.set(xorForNotEquals.out.get());
        and.b.set(not.out.get());
        and.execute();
        
        // a[bits-1].get() == b[bits-1].get() && sum[bits-1].get() != a[bits-1].get()
        overflow.set(and.out.get());

        carryOut.set(carryNext);
    }
}