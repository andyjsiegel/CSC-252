/*
 * Test_invis_ALUElement_LESS_1.java
 *
 * Test case for Simulation 3
 */

public class Test_invis_student2_ALUElement_LESS_1 {
    public static void main(String args[]) {
        Sim3_ALUElement alu = new Sim3_ALUElement();

        alu.a.set(false);
        alu.b.set(false);

        alu.bInvert.set(false);
        alu.carryIn.set(false);

        alu.aluOp[0].set(true);
        alu.aluOp[1].set(true);
        alu.aluOp[2].set(false);

        alu.less.set(true);

        // Print inputs
        System.out.printf("Inputs:\n");
        System.out.printf("  a: %s\n", toBit(alu.a.get()));
        System.out.printf("  b: %s\n", toBit(alu.b.get()));
        System.out.printf("  bInvert: %s\n", toBit(alu.bInvert.get()));
        System.out.printf("  carryIn: %s\n", toBit(alu.carryIn.get()));
        System.out.printf("  aluOp: %s%s%s\n", toBit(alu.aluOp[2].get()), toBit(alu.aluOp[1].get()),
                toBit(alu.aluOp[0].get()));
        System.out.printf("  less: %s\n\n", toBit(alu.less.get()));

        alu.execute_pass1();

        System.out.printf("Pass 1:\n");
        System.out.printf("  addResult: %s\n", toBit(alu.addResult.get()));
        System.out.printf("  carryOut: %s\n\n", toBit(alu.carryOut.get()));

        alu.execute_pass2();

        System.out.printf("Pass 2:\n");
        //System.out.printf("  AND: %s\n", toBit(alu.and.out.get()));
        //System.out.printf("  OR: %s\n", toBit(alu.or.out.get()));
        //System.out.printf("  XOR: %s\n", toBit(alu.xor.out.get()));
        System.out.printf("  result: %s\n", toBit(alu.result.get()));;
    }

    private static String toBit(boolean val) {
        if (val) {
            return "1";
        }
        return "0";
    }
}
