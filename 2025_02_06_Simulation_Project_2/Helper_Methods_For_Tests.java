public class Helper_Methods_For_Tests {
    static Sim2_AdderX adder; // always declare a global adderX if you're pasting the method into your test class
    public static void main(String[] args) {
        String aBinary = "00110";
        String bBinary = "0111";
        setAdder(aBinary, bBinary);
        adder.execute();
        String bitstring = getBitstring(adder.sum); 
        System.out.println(bitstring);
    }

    // paste this method into your test class and use the global adder and the above main method
    public static void setAdder(String aBinary, String bBinary) {
        int len = Math.max(aBinary.length(), bBinary.length());
        char aMSB = aBinary.charAt(0);
        char bMSB = bBinary.charAt(0);

        String paddedABinary = String.format("%" + len + "s", aBinary).replace(' ', aMSB);
        String paddedBBinary = String.format("%" + len + "s", bBinary).replace(' ', bMSB);

        adder = new Sim2_AdderX(len);
        for (int i = len-1; i >= 0; i--) {
            adder.a[i].set(paddedABinary.charAt(Math.abs(len-i-1)) == '1');
            adder.b[i].set(paddedBBinary.charAt(Math.abs(len-i-1)) == '1');
        }   
    }

    /*  or use this method in a different file with this code:
        String aBinary = "00110";
        String bBinary = "0111";
        Sim2_AdderX adder = Helper_Methods_For_Tests.setAndReturnAdder(aBinary, bBinary);
        adder.execute();
        String bitstring = Helper_Methods_For_Tests.getBitstring(adder.sum);
        System.out.println(bitstring);    
    */
    public static Sim2_AdderX setAndReturnAdder(String aBinary, String bBinary) {
        int len = Math.max(aBinary.length(), bBinary.length());
        Sim2_AdderX adderX = new Sim2_AdderX(len);
        char aMSB = aBinary.charAt(0);
        char bMSB = bBinary.charAt(0);

        String paddedABinary = String.format("%" + len + "s", aBinary).replace(' ', aMSB);
        String paddedBBinary = String.format("%" + len + "s", bBinary).replace(' ', bMSB);

        for (int i = len-1; i >= 0; i--) {
            adderX.a[i].set(paddedABinary.charAt(Math.abs(len-i-1)) == '1');
            adderX.b[i].set(paddedBBinary.charAt(Math.abs(len-i-1)) == '1');
        }   
        return adderX;
    }


    // use this method on adder.sum to get a string of the bits
    public static String getBitstring(RussWire[] bits)
	{
        StringBuilder sb = new StringBuilder();
		for (int i=bits.length-1; i>=0; i--)
		{
			if (bits[i].get())
				sb.append("1");
			else
				sb.append("0");
		}
        return sb.toString();
	}

}
