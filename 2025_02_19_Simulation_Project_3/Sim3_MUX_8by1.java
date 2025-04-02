public class Sim3_MUX_8by1 {
    
    // inputs
    RussWire[] control;
    RussWire[] in;

    // output
    RussWire out;

    // constructor initializes inputs and outputs to all be new RussWires.
    public Sim3_MUX_8by1() {
        control = new RussWire[3];
        in = new RussWire[8];
        out = new RussWire();
        
        for(int i=0; i<3; i++) {
            control[i] = new RussWire();
        }
        
        for(int i=0; i<8; i++) {
            in[i] = new RussWire();
        }
    }

    // execute method will run the MUX; it will set the output to the selected input based on the control input in binary. 
    // this lets us pass 8 inputs to the mux as well as a 3 bit binary number to select which input is passed out. 
    public void execute() {
        boolean false_control0 = !(control[0].get());
        boolean false_control1 = !(control[1].get());
        boolean false_control2 = !(control[2].get());

        boolean output_and0 = in[0].get() && false_control0 && false_control1 && false_control2;
        boolean output_and1 = in[1].get() && control[0].get() && false_control2 && false_control1;
        boolean output_and2 = in[2].get() && control[1].get() && false_control0 && false_control2; 
        boolean output_and3 = in[3].get() && control[1].get() && control[0].get() && false_control2;
        boolean output_and4 = in[4].get() && control[2].get() && false_control1 && false_control0; 
        boolean output_and5 = in[5].get() && control[0].get() && control[2].get() && false_control1;
        boolean output_and6 = in[6].get() && control[2].get() && control[1].get() && false_control0;
        boolean output_and7 = in[7].get() && control[0].get() && control[1].get() && control[2].get();

        out.set(output_and0 || output_and1 || output_and2 || output_and3 || output_and4 || output_and5 || output_and6 || output_and7);
    }
}