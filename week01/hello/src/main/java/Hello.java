/**
 * 第 0 周验收用：Maven 项目的第一个类。
 * 运行：mvn -q compile 之后，用 java -cp target/classes Hello
 */
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Java 21!");
        System.out.println("Java 版本: " + System.getProperty("java.version"));
        System.out.println("JVM: " + System.getProperty("java.vm.name"));
    }
}
