# IDEA 操作手册（2026.3 · 已装好）

> 装的部分我已经做完了，你只需要「打开 → 登录 → 建工程」。
> 遇到没写的，先看本文最后「出问题怎么办」。

---

## 1. 它是什么（一句话）

IDEA 是写 Java 的**编辑器 + 编译器 + 调试器 + 项目管理器**的合体。
你不用再手敲 `javac`、`java`，它帮你编译、运行、打断点、提示错误。
以后写 Spring 项目（阶段 6）必须在它里面做，所以现在就得用顺手。

## 2. 怎么启动

**桌面上已经有 `IntelliJ IDEA` 图标了，双击即可。**

其他方式：

- 双击 `D:\ai\deepseek\dev\IntelliJ IDEA.cmd`
- 或直接双击 `D:\ai\deepseek\dev\idea\bin\idea64.exe`

第一次启动会问 **Import Settings（要不要导入旧配置）** → 选 **Do not import settings**（你没有旧配置）。

> 桌面那个 .lnk 只有 1 KB，是唯一落在 C 盘的 Java 相关文件（`C:\Users\HUAWEI\Desktop`）。
> 快捷方式里的路径指向 D 盘，程序本体、配置、缓存、Maven 仓库全在 D 盘。

## 3. 激活（第一次必须做，否则 30 天试用）

打开后左下角/欢迎页会有 **Log in to JetBrains Account**。

### 路线 A：学生免费（推荐，你有保研/在校身份）
1. 浏览器打开 https://www.jetbrains.com/shop/eform/students
2. 选 **Student Pack**，用**学校邮箱**（`@xxx.edu.cn`）或**学信网/ISIC** 认证
3. 1～3 天收到邮件，之后在 IDEA 里用同一个账号登录，许可证自动生效

### 路线 B：非商业免费（不用等审核）
IDEA 2026.3 对**非商业用途**免费：登录账号后在激活界面选
**"Free non-commercial use"**（学习、个人项目都算非商业）。
以后如果拿它接商业外包，要换成付费或学生授权。

> 两条路都用**同一个 JetBrains 账号**，登录一次就行。断网也能用（许可证有离线期）。

## 4. 建第一个工程（跟着点，5 分钟）

1. 欢迎页点 **New Project**
2. 左侧选 **Java**（不要选空项目/Spring）
3. 右边填：
   - **Name**：`hello-demo`
   - **Location**：`D:\ai\deepseek\dsh-workplace\java\week01`（它会在里面建 `hello-demo` 文件夹）
   - **Build system**：`IntelliJ`（第一次先不用 Maven，减少变量）
   - **JDK**：如果下拉里没有 21，点 **Add JDK…** → 选 `D:\ai\deepseek\dev\jdk-21.0.13` → OK
4. 点 **Create**
5. 左边项目树 `src` 右键 → **New → Java Class** → 输入 `Main` → 回车
6. 在 `Main` 里输入 `psvm` 然后按 **Tab**（自动生成 main 方法），
   再在方法里输入 `sout` 按 **Tab**（自动生成打印语句），改成：
   ```java
   public class Main {
       public static void main(String[] args) {
           System.out.println("Hello, IDEA!");
       }
   }
   ```
7. 点代码左边行号旁的**绿色三角** → **Run 'Main.main()'**
8. 下面弹出 Run 窗口，看到 `Hello, IDEA!` —— 成功

> `psvm` = public static void main 的缩写，`sout` = System.out.println 的缩写。
> 这两个是 IDEA 的「代码模板」，打字少一半，第一天就记住。

## 5. 打开我已经建好的 Maven 工程（验证 Maven 链路）

1. 欢迎页 **Open**（或 File → Open）
2. 选 `D:\ai\deepseek\dsh-workplace\java\week01\hello\pom.xml` → **Open as Project**
3. 右下角会提示 Maven 正在导入，等进度条走完
4. 打开 `src/main/java/Hello.java`（会有一小段黄色提示，不用管），
   点 `main` 左边的绿三角运行，输出 `Hello, Java 21!`

## 6. 必改的 4 个设置（Ctrl+Alt+S 打开 Settings）

| 位置 | 改什么 | 为什么 |
|---|---|---|
| `Editor → Font` | 字号调到 16～18 | 默认字太小，伤眼 |
| `Editor → File Encodings` | 三个都设 **UTF-8** | 否则中文注释/控制台乱码 |
| `Build Tools → Maven` | **Maven home**：`D:\ai\deepseek\dev\maven-3.9.16`；勾选 **Override** 并指定 `...\conf\settings.xml` | 用我们配好的阿里云镜像，下载快 |
| `Build Tools → Maven → Importing` | **JDK for importer**：21 | 否则导入慢/报错 |

可选：`Plugins` 搜 `Chinese` 装官方中文语言包，重启后界面变中文（想练英文就别装）。

## 7. 十个够用的快捷键

| 快捷键 | 作用 |
|---|---|
| `Ctrl+Alt+S` | 打开设置 |
| `Ctrl+N` | 按类名找文件 |
| `Ctrl+Shift+F` | 全项目搜索文字 |
| `Ctrl+B` | 跳到定义 |
| `Alt+Enter` | 万能修复（导包、改错） |
| `Ctrl+Alt+L` | 格式化代码（交作业前按一下） |
| `Ctrl+D` | 复制当前行 |
| `Shift+F6` | 重命名（会全项目一起改） |
| `Ctrl+/` | 注释/取消注释 |
| `Shift+F10` / `Ctrl+Shift+F10` | 运行上次 / 运行当前 |

## 8. 出问题怎么办

| 现象 | 处理 |
|---|---|
| 打开项目一片红，`java` 找不到 | `File → Project Structure → Project`，SDK 选 21，Language level 选 21 |
| 中文全是问号 | 第 6 节的 File Encodings 改成 UTF-8，然后重启 |
| Maven 项目不识别（pom 图标是普通文件） | 右键 `pom.xml` → **Add as Maven Project** |
| 一直 indexing，风扇狂转 | 正常，第一次要建索引；等它完，别急着点 |
| 提示内存不足 | 编辑 `D:\ai\deepseek\dev\idea\bin\idea64.exe.vmoptions`，把 `-Xmx` 改到 `-Xmx2048m` |
| 想彻底重来 | 关掉 IDEA，删 `D:\ai\deepseek\dev\idea-data`，重启即可（配置全清） |
| 想确认缓存没写 C 盘 | 看 `D:\ai\deepseek\dev\idea-data` 里有没有 `system`、`config` 在长个儿 |

## 9. 和命令行的关系

IDEA 里跑的 Maven 和你终端里的 `mvn` 是同一个程序（都是 `D:\ai\deepseek\dev\maven-3.9.16`），
所以两边行为一致。区别只是：IDEA 帮你点了按钮、看得见报错。
**建议：先用终端跑通一次（知道背后发生了什么），再用 IDEA 提高效率。**
