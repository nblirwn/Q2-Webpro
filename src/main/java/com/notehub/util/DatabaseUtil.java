package com.notehub.util;

import java.sql.*;

public class DatabaseUtil {
    private static final String DB_URL = "jdbc:h2:~/notehub;AUTO_SERVER=TRUE";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";
    
    static {
        try {
            Class.forName("org.h2.Driver");
            initDatabase();
        } catch (Exception e) {
            throw new RuntimeException("Database initialization failed", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    private static void initDatabase() {
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                "name VARCHAR(255) NOT NULL, " +
                "email VARCHAR(255) UNIQUE NOT NULL, " +
                "password VARCHAR(255) NOT NULL, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            
            stmt.execute("CREATE TABLE IF NOT EXISTS categories (" +
                "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                "user_id BIGINT NOT NULL, " +
                "name VARCHAR(255) NOT NULL, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)");
            
            stmt.execute("CREATE TABLE IF NOT EXISTS notes (" +
                "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                "user_id BIGINT NOT NULL, " +
                "category_id BIGINT, " +
                "title VARCHAR(255), " +
                "content CLOB, " +
                "is_pinned BOOLEAN DEFAULT FALSE, " +
                "is_archived BOOLEAN DEFAULT FALSE, " +
                "share_token VARCHAR(255) UNIQUE, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, " +
                "FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL)");
            
            stmt.execute("CREATE TABLE IF NOT EXISTS tags (" +
                "id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                "user_id BIGINT NOT NULL, " +
                "name VARCHAR(255) NOT NULL, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "UNIQUE(user_id, name), " +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)");
            
            stmt.execute("CREATE TABLE IF NOT EXISTS note_tag (" +
                "note_id BIGINT NOT NULL, " +
                "tag_id BIGINT NOT NULL, " +
                "PRIMARY KEY (note_id, tag_id), " +
                "FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE, " +
                "FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE)");
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create tables", e);
        }
    }
}