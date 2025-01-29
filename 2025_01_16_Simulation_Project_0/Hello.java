import java.util.Scanner;

public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello World!");
        Scanner in = new Scanner(System.in);
        System.out.println("What is your name?");
        String name = in.nextLine();
        System.out.println("Hello " + name + "!");
        in.close();
    }
}