import java.util.Scanner;

public class Main {

    private static final Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        mainMenu();
    }

    /**
     * Displays the main menu for Pokemon database queries.
     */
    public static void mainMenu() {
        int choice;

        do {
            System.out.println("""
                
                ---------------------------------------------------
                Pokemon Database Query Menu
                ---------------------------------------------------
                1. Show Pokemon by type
                2. Show trainers and their Pokemon
                3. Show wild Pokemon by region
                4. Show gyms and their leaders
                5. Show Pokemon stats view
                0. Exit
                """);
            System.out.print("Enter your choice: ");
            choice = handleUserChoice();
            executeQuery(choice);

        } while (choice != 0);

        scanner.close();
    }

    /**
     * Executes SQL queries based on user choice.
     */
    private static void executeQuery(int choice) {
        switch (choice) {
            case 1 -> showPokemonByType();
            case 2 -> showTrainersAndPokemon();
            case 3 -> showWildPokemonByRegion();
            case 4 -> showGymsAndLeaders();
            case 5 -> DBCommand.runQuery("SELECT * FROM TrainerPokemonStats");
            case 0 -> System.out.println("\nGoodbye!");
            default -> System.out.println("\nInvalid option.");
        }
    }

    /**
     * Displays Pokemon filtered by type.
     */
    private static void showPokemonByType() {
        System.out.println("""
            
            ---------------------------------------------------
            Choose Pokemon Type:
            ---------------------------------------------------
            1. Fire
            2. Water
            3. Grass
            4. Electric
            5. Normal
            6. All
            """);
        System.out.print("Enter your choice: ");
        int choice = handleUserChoice();

        String query = """
            SELECT p.name AS Pokemon, GROUP_CONCAT(t.type_name SEPARATOR '/') AS Types
            FROM Pokemon p
            JOIN PokemonTypes pt ON p.pokemon_id = pt.pokemon_id
            JOIN Types t ON t.type_id = pt.type_id
            GROUP BY p.name
        """;

        switch (choice) {
            case 1 -> query += " HAVING Types LIKE '%Fire%';";
            case 2 -> query += " HAVING Types LIKE '%Water%';";
            case 3 -> query += " HAVING Types LIKE '%Grass%';";
            case 4 -> query += " HAVING Types LIKE '%Electric%';";
            case 5 -> query += " HAVING Types LIKE '%Normal%';";
            case 6 -> query += ";";
            default -> {
                System.out.println("Invalid type, defaulting to all Pokemon.\n");
                query += ";";
            }
        }

        DBCommand.runQuery(query);
    }

    /**
     * Shows trainers and Pokemon they own.
     */
    private static void showTrainersAndPokemon() {
        String query = """
            SELECT tr.name AS Trainer, tr.gender, tr.age,
                   p.name AS Pokemon, tp.nick_name AS Nickname, tp.pokemon_level AS Level
            FROM TrainerPokemon tp
            JOIN Trainer tr ON tp.trainer_id = tr.trainer_id
            JOIN Pokemon p ON tp.pokemon_id = p.pokemon_id
            ORDER BY tr.name;
        """;
        DBCommand.runQuery(query);
    }

    /**
     * Shows wild Pokemon found in regions.
     */
    private static void showWildPokemonByRegion() {
        System.out.println("""
            
            ---------------------------------------------------
            Choose Region:
            ---------------------------------------------------
            1. Kanto
            2. Johto
            3. Hoenn
            4. Sinnoh
            5. Unova
            6. Kalos
            7. Alola
            8. Galar
            9. Hisui
            10. Paldea
            0. All Regions
            """);
        System.out.print("Enter your choice: ");
        int choice = handleUserChoice();

        String query = """
            SELECT p.name AS Pokemon, r.name AS Region, w.location_description, w.min_level, w.max_level
            FROM WildPokemon w
            JOIN Pokemon p ON w.pokemon_id = p.pokemon_id
            JOIN Region r ON w.region_id = r.region_id
        """;

        if (choice >= 1 && choice <= 10)
            query += " WHERE r.region_id = " + choice + ";";
        else
            query += ";";

        DBCommand.runQuery(query);
    }

    /**
     * Shows gyms, their leaders, and badge information.
     */
    private static void showGymsAndLeaders() {
        String query = """
            SELECT g.gym_id, t.name AS Town, tr.name AS Leader, ty.type_name AS Type, b.badge_name AS Badge
            FROM Gym g
            JOIN Town t ON g.town_id = t.town_id
            JOIN Trainer tr ON g.leader_id = tr.trainer_id
            JOIN Types ty ON g.type_id = ty.type_id
            JOIN Badge b ON g.badge_id = b.badge_id;
        """;
        DBCommand.runQuery(query);
    }

    /**
     * Validates user input.
     */
    private static int handleUserChoice() {
        if (scanner.hasNextInt()) {
            int choice = scanner.nextInt();
            scanner.nextLine();
            return choice;
        } else {
            System.out.println("Invalid input.");
            scanner.nextLine();
            return -1;
        }
    }
}
