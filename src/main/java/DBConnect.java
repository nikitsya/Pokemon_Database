import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    private static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/Pokemon";

    private static final String USER = "root";
    private static final String PASSWORD = "smiichyk";

    public static Connection connect() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, USER, PASSWORD);

        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC driver not found. Make sure the .jar file is added to project dependencies.");
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
        }
        return null;
    }
}
