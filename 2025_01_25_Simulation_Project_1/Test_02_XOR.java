public class Test_02_XOR {
    public static void main(String[] args) {
        
        Sim1_XOR p = new Sim1_XOR();
        p.a.set(true);
        p.b.set(true);
        p.execute();
        System.out.print(p.out.get());

    }
}