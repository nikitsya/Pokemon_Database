import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class DBOutputFormatter {

    /**
     * Prints the contents of a ResultSet in a formatted table-like structure.
     *
     * @param resultSet the ResultSet to be printed
     * @throws SQLException if an SQL error occurs while reading from the ResultSet
     */
    public static void printResultSet(ResultSet resultSet) throws SQLException {

        // Get metadata to determine column info
        ResultSetMetaData meta = resultSet.getMetaData();
        int columnCount = meta.getColumnCount();

        // Print headers
        System.out.println("\n" + "-".repeat(20 * columnCount));
        for (int i = 1; i <= columnCount; i++) {
            System.out.printf("%-25s", meta.getColumnName(i));
        }
        System.out.println("\n" + "-".repeat(20 * columnCount));

        // Print rows
        while (resultSet.next()) {
            for (int i = 1; i <= columnCount; i++) {
                System.out.printf("%-25s", resultSet.getString(i));
            }
            System.out.println();
        }
    }
}

