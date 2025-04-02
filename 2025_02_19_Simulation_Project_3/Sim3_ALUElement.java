public class Sim3_ALUElement {
    // inputs
    RussWire[] aluOp;
    RussWire bInvert, a, b, carryIn, less;

    // utilities
    RussWire bReal;
    Sim3_MUX_8by1 mux;
    Sim2_FullAdder adder;

    // outputs
    RussWire result, addResult, carryOut;

    // constructor initializes inputs and outputs to all be new RussWires, 
    // and initializes the mux and full adder. 
    public Sim3_ALUElement() {

        // inputs
        aluOp = new RussWire[3];
        bInvert = new RussWire();
        a = new RussWire();
        b = new RussWire();
        carryIn = new RussWire();
        
        // utilities 
        bReal = new RussWire();
        mux = new Sim3_MUX_8by1();
        adder = new Sim2_FullAdder();
        
        // outputs
        less = new RussWire();
        result = new RussWire();
        addResult = new RussWire();
        carryOut = new RussWire();

        for (int i = 0; i < 3; i++) {
			aluOp[i] = new RussWire();
		}
    }

    // the ALU has 2 passes. in the first pass, we determine if B needs to be inverted and we run the adder.
    public void execute_pass1() {
        bReal.set(b.get() ^ bInvert.get()); // XOR will flip the result of b input if bInvert is true. 
        adder.a.set(a.get());
        adder.b.set(bReal.get());
        adder.carryIn.set(carryIn.get());
        adder.execute();
        addResult.set(adder.sum.get());
        carryOut.set(adder.carryOut.get());
        
    }
    
    // in the second pass, the method sets the mux control inputs from aluOp, 
    // sets all the mux data inputs, and then runs the mux, setting the aluElement output to the mux output.
    public void execute_pass2() {
        // mux control is determined by binary representation of 0-4 like 000, 001, etc
        /* 0 - AND
           1 - OR
           2 - ADD
           3 - LESS
           4 - XOR
           (5, 6, 7 not used)
        */

        // mux control inputs are equal to the aluOp input. 
        mux.control[0].set(aluOp[0].get());
        mux.control[1].set(aluOp[1].get());
        mux.control[2].set(aluOp[2].get());

        // we set the first 5 mux inputs according to the comment above.
        mux.in[0].set(a.get() && bReal.get());
        mux.in[1].set(a.get() || bReal.get());
        mux.in[2].set(addResult.get());
        mux.in[3].set(less.get());
        mux.in[4].set(a.get() ^ bReal.get()); 
        
        // set the unused inputs to false
        mux.in[5].set(false); 
		mux.in[6].set(false); 
		mux.in[7].set(false);

        mux.execute();

        result.set(mux.out.get());
    }
}