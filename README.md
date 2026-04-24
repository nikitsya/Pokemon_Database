# Pokemon Database System

A MySQL and Java JDBC database system for managing Pokemon, trainers, regions, gyms, wild encounters, and trainer-owned Pokemon.

The system combines a normalized relational database with database-side business logic and a Java console application for querying operational data.

## What This Project Includes

- A normalized MySQL schema for Pokemon, trainers, regions, towns, types, gyms, badges, wild encounters, and trainer-owned Pokemon.
- Many-to-many relationships, including Pokemon-to-type mapping through a junction table.
- Foreign key constraints across the schema to keep relational data consistent.
- Seed data for regions, towns, Pokemon, Pokemon types, trainers, gyms, badges, wild Pokemon, and ownership records.
- SQL views for reusable reporting, including calculated trainer Pokemon stats.
- Stored procedures for adding Pokemon, adding trainers with starter Pokemon, trading Pokemon, and buying wild Pokemon.
- Triggers for business rules such as level limits, IV caps, trainer party limits, delete handling, and audit logging.
- Indexes with `EXPLAIN` examples for query-performance reasoning.
- MySQL user and privilege scripts showing role-based access control.
- A Java console application that connects to MySQL with JDBC and displays formatted query results.

## Technical Highlights

The implementation includes:

- Relational database design and normalization
- Primary keys, composite keys, foreign keys, and junction tables
- Complex SQL joins and aggregation
- Views for reusable reporting queries
- Stored procedures and transaction control
- Trigger-based data validation and business rules
- Index creation and basic query-plan analysis
- Database users, grants, revokes, and privilege separation
- Java JDBC connection handling
- Prepared statements and result-set formatting
- Console application structure with menu-driven user interaction

## Tech Stack

- Java
- JDBC
- MySQL
- MySQL Connector/J
- SQL

## Repository Structure

```text
Pokemon_Database/
├── DBConnectJava/              # Main Java source files
├── Java_compile_and_run/       # Runnable Java copy with MySQL Connector/J jar
│   ├── lib/
│   └── src/
├── sql/
│   ├── tables.sql              # Database and table creation
│   ├── inserts.sql             # Seed data
│   ├── join_queries.sql        # Example joins
│   ├── views.sql               # Reporting views
│   ├── stored_procedures.sql   # Stored procedures
│   ├── transactions.sql        # Transaction-based procedures
│   ├── triggers.sql            # Business-rule triggers
│   ├── indexes.sql             # Indexes and EXPLAIN examples
│   ├── users.sql               # MySQL users and privileges
│   └── AllSQL                  # Combined SQL script
└── README.md
```

## Database Model

The database is built around a Pokemon game domain:

- `Region` stores world regions.
- `Town` belongs to a region.
- `Trainer` belongs to a home town.
- `Pokemon` stores base species statistics.
- `Types` stores Pokemon type names.
- `PokemonTypes` maps Pokemon to one or more types.
- `TrainerPokemon` stores Pokemon owned by trainers, including nickname, level, and IV values.
- `WildPokemon` stores catchable Pokemon by region and level range.
- `Gym`, `Badge`, and `TypeAdvantage` model gym and battle-related data.

This structure separates core entities from relationships, avoids duplicated type data, and keeps ownership and wild-encounter records distinct.

## Java Console Application

The Java application provides a simple menu for exploring the database:

1. Show Pokemon by type
2. Show trainers and their Pokemon
3. Show wild Pokemon by region
4. Show gyms and their leaders
5. Show calculated Pokemon stats from the `TrainerPokemonStats` view

The application uses:

- `DBConnect` for the MySQL connection
- `DBCommand` for executing SQL queries
- `DBOutputFormatter` for table-like console output
- `Main` for menu navigation and user input

## SQL Features

### Views

The project includes views such as:

- `TrainerPokemonStats`: calculates HP, attack, and defense from base stats, IVs, and level.
- `PokemonWithTypes`: combines each Pokemon's types into one readable row.
- `TrainerSummary`: summarizes trainer details, Pokemon count, region, and gym-leader status.
- `TrainerPokemonMaxLevelView`: shows each trainer's highest-level Pokemon.

### Stored Procedures and Transactions

The SQL scripts include procedures for:

- Adding a Pokemon with type and wild-location data
- Adding a trainer with a starter Pokemon
- Trading Pokemon between trainers with rollback on failure
- Buying/catching a wild Pokemon and moving it into trainer ownership

Transaction examples use `START TRANSACTION`, `COMMIT`, `ROLLBACK`, and error handlers to protect multi-step operations.

### Triggers

Triggers enforce rules directly in the database, including:

- Capping Pokemon levels between 1 and 100
- Capping IV values at 31
- Limiting a trainer to a maximum of 6 Pokemon
- Removing related trainer Pokemon before trainer deletion
- Reassigning gym leaders before deleting a trainer
- Logging deleted trainers

### Indexes and Users

The project includes indexes for frequently joined or filtered fields, such as wild Pokemon region lookups and Pokemon type mappings. It also includes MySQL user-management examples for application, read-only, admin, and trainer-style users.

## How to Run

### 1. Create the database

Open MySQL and run the combined SQL script:

```sql
SOURCE /absolute/path/to/Pokemon_Database/sql/AllSQL;
```

Alternatively, run the individual scripts in this general order:

```text
tables.sql
inserts.sql
table_for_trigger.sql
views.sql
stored_procedures.sql
transactions.sql
triggers.sql
indexes.sql
users.sql
```

### 2. Configure the Java database connection

Update the connection settings in:

```text
Java_compile_and_run/src/DBConnect.java
```

Set the MySQL database URL, username, and password for your local environment:

```java
private static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/Pokemon";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

### 3. Compile and run on macOS or Linux

From the `Java_compile_and_run` directory:

```bash
javac -cp "lib/mysql-connector-j-9.4.0.jar" src/*.java -d out
java -cp "out:lib/mysql-connector-j-9.4.0.jar" Main
```

### 4. Compile and run on Windows

From the `Java_compile_and_run` directory:

```bash
javac -cp "lib/mysql-connector-j-9.4.0.jar" src\*.java -d out
java -cp "out;lib/mysql-connector-j-9.4.0.jar" Main
```

## Example Queries

Show trainers and their Pokemon:

```sql
SELECT
    tr.name AS Trainer,
    tr.gender,
    tr.age,
    p.name AS Pokemon,
    tp.nick_name AS Nickname,
    tp.pokemon_level AS Level
FROM TrainerPokemon AS tp
JOIN Trainer AS tr ON tp.trainer_id = tr.trainer_id
JOIN Pokemon AS p ON tp.pokemon_id = p.pokemon_id
ORDER BY tr.name;
```

Show calculated trainer Pokemon stats:

```sql
SELECT * FROM TrainerPokemonStats;
```

Trade Pokemon between trainers:

```sql
CALL TradePokemon(1, 1, 8, 4);
```

## Project Status

The database schema, SQL logic, seed data, and Java query application are implemented and ready to run locally with MySQL.
