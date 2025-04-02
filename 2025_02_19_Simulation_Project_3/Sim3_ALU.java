public class Sim3_ALU {
    // inputs
    int bits;
    RussWire[] aluOp, a,b;
    RussWire bNegate;
    
    // utilities
    Sim3_ALUElement[] aluElement;

    // outputs
    RussWire[] result;

    // the constructor sets the global variable bits to the input number of bits 
    // (so we can use the ALU on inputs of any size) and initializes the inputs, utilities, and outputs to new RussWires.
    public Sim3_ALU(int bits) {
        this.bits = bits;
        aluOp = new RussWire[3];

        bNegate = new RussWire();

        a = new RussWire[bits];
        b = new RussWire[bits];
        result = new RussWire[bits];

        aluElement = new Sim3_ALUElement[bits];

        // initialize aluOp as russwires
        for (int i = 0; i < 3; i++) {
			aluOp[i] = new RussWire();
		}

        // initialize a, b, result, and aluElement as russwires.
		for (int i = 0; i < bits; i++) {
			a[i] = new RussWire();
			b[i] = new RussWire();
			result[i] = new RussWire();
			aluElement[i] = new Sim3_ALUElement();
		}

    }
    // the execute method runs the ALU. It starts by running the first aluElement which is special; its carryIn is equal to bNegate.
    // this is because when we want to do subtraction, we need to pass in a 1 to the carryIn for twos complement and 
    // we already have a 1 available from the bNegate. For all other alu elements, carryIn is equal to the previous aluElement's carryOut.
    // this method will also run both passes of the aluElements. 
    public void execute() {
        aluElement[0].aluOp[0].set(aluOp[0].get());
        aluElement[0].aluOp[1].set(aluOp[1].get());
        aluElement[0].aluOp[2].set(aluOp[2].get());

        aluElement[0].bInvert.set(bNegate.get());
        aluElement[0].carryIn.set(bNegate.get());
        
        aluElement[0].a.set(a[0].get());
        aluElement[0].b.set(b[0].get());

        aluElement[0].execute_pass1();

        for (int i=1; i<bits; i++) {
            aluElement[i].aluOp[0].set(aluOp[0].get());
            aluElement[i].aluOp[1].set(aluOp[1].get());
            aluElement[i].aluOp[2].set(aluOp[2].get());

            aluElement[i].bInvert.set(bNegate.get());
            aluElement[i].carryIn.set(aluElement[i-1].carryOut.get());
            aluElement[i].a.set(a[i].get());
            aluElement[i].b.set(b[i].get());
            aluElement[i].less.set(false);
            aluElement[i].execute_pass1();
        }
        // the less result for alu[0] is the addResult of the final aluElement
        aluElement[0].less.set(aluElement[bits - 1].addResult.get());

        // result is set to the result of the aluElement which is determined by the MUX. 
		for (int i = 0; i < bits; i++) {
			aluElement[i].execute_pass2();
			result[i].set(aluElement[i].result.get());
		}

    }

}
