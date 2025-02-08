public class Ignore_Test_Template {
    public static void main(String[] args) {
        String aBinary = "00110";
        String bBinary = "0111";
        Sim2_AdderX adder = Helper_Methods_For_Tests.setAndReturnAdder(aBinary, bBinary);
        adder.execute();
        String bitstring = Helper_Methods_For_Tests.getBitstring(adder.sum);
        System.out.println(bitstring);    
    }
}
