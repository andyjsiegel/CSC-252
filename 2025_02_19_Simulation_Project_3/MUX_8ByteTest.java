public class MUX_8ByteTest {
    public static void main(String[] args) {
        // Test Case 0: Selecting input[0] (control = 000)
        Sim3_MUX_8by1 mux0 = new Sim3_MUX_8by1();
        mux0.control[0].set(false);
        mux0.control[1].set(false);
        mux0.control[2].set(false);
        mux0.in[0].set(true);  // This input should be selected
        mux0.in[1].set(false);
        mux0.in[2].set(false);
        mux0.in[3].set(false);
        mux0.in[4].set(false);
        mux0.in[5].set(false);
        mux0.in[6].set(false);
        mux0.in[7].set(false);
        mux0.execute();
        System.out.printf("MUX: control=0 in={1,0,0,0,0,0,0,0} -> %s\n", mux0.out.get());

        // Test Case 1: Selecting input[1] (control = 001)
        Sim3_MUX_8by1 mux1 = new Sim3_MUX_8by1();
        mux1.control[0].set(true);
        mux1.control[1].set(false);
        mux1.control[2].set(false);
        mux1.in[0].set(false);
        mux1.in[1].set(true);  // This input should be selected
        mux1.in[2].set(false);
        mux1.in[3].set(false);
        mux1.in[4].set(false);
        mux1.in[5].set(false);
        mux1.in[6].set(false);
        mux1.in[7].set(false);
        mux1.execute();
        System.out.printf("MUX: control=1 in={0,1,0,0,0,0,0,0} -> %s\n", mux1.out.get());

        // Test Case 2: Selecting input[2] (control = 010)
        Sim3_MUX_8by1 mux2 = new Sim3_MUX_8by1();
        mux2.control[0].set(false);
        mux2.control[1].set(true);
        mux2.control[2].set(false);
        mux2.in[0].set(false);
        mux2.in[1].set(false);
        mux2.in[2].set(true);  // This input should be selected
        mux2.in[3].set(false);
        mux2.in[4].set(false);
        mux2.in[5].set(false);
        mux2.in[6].set(false);
        mux2.in[7].set(false);
        mux2.execute();
        System.out.printf("MUX: control=2 in={0,0,1,0,0,0,0,0} -> %s\n", mux2.out.get());

        // Test Case 3: Selecting input[3] (control = 011)
        Sim3_MUX_8by1 mux3 = new Sim3_MUX_8by1();
        mux3.control[0].set(true);
        mux3.control[1].set(true);
        mux3.control[2].set(false);
        mux3.in[0].set(false);
        mux3.in[1].set(false);
        mux3.in[2].set(false);
        mux3.in[3].set(true);  // This input should be selected
        mux3.in[4].set(false);
        mux3.in[5].set(false);
        mux3.in[6].set(false);
        mux3.in[7].set(false);
        mux3.execute();
        System.out.printf("MUX: control=3 in={0,0,0,1,0,0,0,0} -> %s\n", mux3.out.get());

        // Test Case 4: Selecting input[4] (control = 100)
        Sim3_MUX_8by1 mux4 = new Sim3_MUX_8by1();
        mux4.control[0].set(false);
        mux4.control[1].set(false);
        mux4.control[2].set(true);
        mux4.in[0].set(false);
        mux4.in[1].set(false);
        mux4.in[2].set(false);
        mux4.in[3].set(false);
        mux4.in[4].set(true);  // This input should be selected
        mux4.in[5].set(false);
        mux4.in[6].set(false);
        mux4.in[7].set(false);
        mux4.execute();
        System.out.printf("MUX: control=4 in={0,0,0,0,1,0,0,0} -> %s\n", mux4.out.get());

        // Test Case 5: Selecting input[5] (control = 101)
        Sim3_MUX_8by1 mux5 = new Sim3_MUX_8by1();
        mux5.control[0].set(true);
        mux5.control[1].set(false);
        mux5.control[2].set(true);
        mux5.in[0].set(false);
        mux5.in[1].set(false);
        mux5.in[2].set(false);
        mux5.in[3].set(false);
        mux5.in[4].set(false);
        mux5.in[5].set(true);  // This input should be selected
        mux5.in[6].set(false);
        mux5.in[7].set(false);
        mux5.execute();
        System.out.printf("MUX: control=5 in={0,0,0,0,0,1,0,0} -> %s\n", mux5.out.get());

        // Test Case 6: Selecting input[6] (control = 110)
        Sim3_MUX_8by1 mux6 = new Sim3_MUX_8by1();
        mux6.control[0].set(false);
        mux6.control[1].set(true);
        mux6.control[2].set(true);
        mux6.in[0].set(false);
        mux6.in[1].set(false);
        mux6.in[2].set(false);
        mux6.in[3].set(false);
        mux6.in[4].set(false);
        mux6.in[5].set(false);
        mux6.in[6].set(true);  // This input should be selected
        mux6.in[7].set(false);
        mux6.execute();
        System.out.printf("MUX: control=6 in={0,0,0,0,0,0,1,0} -> %s\n", mux6.out.get());

        // Test Case 7: Selecting input[7] (control = 111)
        Sim3_MUX_8by1 mux7 = new Sim3_MUX_8by1();
        mux7.control[0].set(true);
        mux7.control[1].set(true);
        mux7.control[2].set(true);
        mux7.in[0].set(false);
        mux7.in[1].set(false);
        mux7.in[2].set(false);
        mux7.in[3].set(false);
        mux7.in[4].set(false);
        mux7.in[5].set(false);
        mux7.in[6].set(false);
        mux7.in[7].set(true);  // This input should be selected
        mux7.execute();
        System.out.printf("MUX: control=7 in={0,0,0,0,0,0,0,1} -> %s\n", mux7.out.get());
    }
}
