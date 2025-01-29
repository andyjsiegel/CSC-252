public class Test_01_AND {
    public static void main(String[] args) {
        
        Sim1_AND p = new Sim1_AND();
        p.a.set(true);
        p.b.set(true);
        p.execute();
        System.out.print(p.out.get());

    }
}
