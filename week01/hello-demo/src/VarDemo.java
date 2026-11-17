import java.util.Scanner;

public class VarDemo {
    public static void main(String[] args) {
        // ===== 1. 五种最常见的数据类型 =====
        int age = 18;              // 整数
        double height = 1.75;      // 小数
        double weight =65.5;
        char grade = 'A';          // 单个字符，用单引号
        boolean isStudent = true;  // 真假
        String name = "韩睿昊";     // 一串字符，用双引号，S 大写

        System.out.println("姓名：" + name);
        System.out.println("年龄：" + age);
        System.out.println("身高：" + height);
        System.out.println("体重：" + weight);
        System.out.println("等级：" + grade);
        System.out.println("是学生：" + isStudent);

        // ===== 2. 整数除法 vs 小数除法（必踩的坑）=====
        int a = 7;
        int b = 2;
        System.out.println("7 / 2 = " + (a /(double) b));
        System.out.println("7 / 2.0 = " + (a / 2.0));

        // ===== 3. 从键盘读一个数 =====
        Scanner sc = new Scanner(System.in);
        System.out.print("请输入你的年龄：");
        int input = (int)sc.nextDouble();
        System.out.println("明年你 " + (input + 1) + " 岁");
    }
}