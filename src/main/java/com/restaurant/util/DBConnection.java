package com.restaurant.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection {

    private static String URL;
    private static String USER;
    private static String PASS;

    static {
        try (InputStream input = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("config.properties")) {

            Properties prop = new Properties();
            prop.load(input);

            URL  = prop.getProperty("db.url");
            USER = prop.getProperty("db.user");
            PASS = prop.getProperty("db.password");

        } catch (Exception e) {
            throw new RuntimeException("Impossible de charger config.properties", e);
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}