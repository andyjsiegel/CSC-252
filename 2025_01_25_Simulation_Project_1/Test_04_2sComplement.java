public class Test_04_2sComplement {
    public static void main(String[] args) {
        Sim1_2sComplement twos = new Sim1_2sComplement();

        twos.in[0].set(true);
        twos.in[1].set(true);
        twos.in[2].set(true);
        twos.in[3].set(true);
        twos.in[4].set(false);
        twos.in[5].set(false);
        twos.in[6].set(true);
        twos.in[7].set(true);
        twos.in[8].set(true);
        twos.in[9].set(false);
        twos.in[10].set(true);
        twos.in[11].set(false);
        twos.in[12].set(false);
        twos.in[13].set(false);
        twos.in[14].set(false);
        twos.in[15].set(false);
        twos.in[16].set(true);
        twos.in[17].set(false);
        twos.in[18].set(false);
        twos.in[19].set(true);
        twos.in[20].set(false);
        twos.in[21].set(false);
        twos.in[22].set(false);
        twos.in[23].set(false);
        twos.in[24].set(false);
        twos.in[25].set(false);
        twos.in[26].set(false);
        twos.in[27].set(false);
        twos.in[28].set(false);
        twos.in[29].set(false);
        twos.in[30].set(false);        
        twos.in[31].set(true);

        // System.out.println();
        // for(int i = 31; i >= 0; i--) {
        //     System.out.print(twos.in[i].get() ? 1 : 0);
        // }
        // System.out.println();
        twos.execute();
        for(int i = 31; i >= 0; i--) {
            System.out.print(twos.out[i].get() ? 1 : 0);
        }
    }
}