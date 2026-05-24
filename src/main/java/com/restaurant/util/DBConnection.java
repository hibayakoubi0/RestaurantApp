package com.restaurant.util;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;




public class DBConnection {


    // Paramètres de connexion — à adapter selon votre config
    private static final String URL  =
        "jdbc:mysql://localhost:3306/restaurant_db?useSSL=false" +
        "&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASS = "newpassword123";  //  mot de passe MySQL


    // Chargement du driver (optionnel depuis Java 6)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Driver MySQL introuvable : " + e.getMessage());
        }
    }


    /**
     * Retourne une connexion à la base de données.
     * Chaque DAO crée et ferme sa propre connexion.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
