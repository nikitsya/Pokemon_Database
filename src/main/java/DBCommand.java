import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBCommand {

    /**
     * Executes a simple SQL query without parameters and prints the result set.
     *
     * @param sql the SQL query string to be executed
     */
    public static void runQuery(String sql) {
        try (Connection connect = DBConnect.connect()
        ) {
            assert connect != null;
            try (// Establish connection and prepare statement
                 PreparedStatement statement = connect.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()
            ) {
                // Pass the result set to a formatter for output
                DBOutputFormatter.printResultSet(resultSet);

            }
        } catch (SQLException exception) {
            // Handle SQL errors
            System.out.println("Error executing query: " + exception.getMessage());
        }
    }

    /**
     * Executes a SQL query with a single parameter and prints the result set.
     *
     * @param sql the SQL query with a parameter placeholder (?)
     * @param param the parameter to be used in the query
     */
    public static void runQueryWithParam(String sql, String param) {
        try (
                // Establish connection and prepare statement
                Connection connect = DBConnect.connect()
        ) {
            assert connect != null;
            try (// Establish connection and prepare statement
                 PreparedStatement statement = connect.prepareStatement(sql)
            ) {
                // Set the parameter value in the prepared statement
                statement.setString(1, param);

                // Execute the query and process the result
                ResultSet resultSet = statement.executeQuery();
                DBOutputFormatter.printResultSet(resultSet);

            }
        } catch (SQLException exception) {
            // Handle SQL errors
            System.out.println("Error executing parameterized query: " + exception.getMessage());
        }
    }
}
