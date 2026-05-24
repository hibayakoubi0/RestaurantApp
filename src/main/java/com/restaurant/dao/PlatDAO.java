package com.restaurant.dao;


import com.restaurant.model.Plat;
import com.restaurant.util.DBConnection;
import java.sql.*;
import java.util.*;


public class PlatDAO {


    public List<Plat> getAll() throws SQLException {
        List<Plat> list = new ArrayList<>();
        String sql = "SELECT * FROM plat ORDER BY categorie, nom";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Plat p = new Plat();
                p.setId(rs.getInt("id"));
                p.setNom(rs.getString("nom"));
                p.setDescription(rs.getString("description"));
                p.setPrix(rs.getDouble("prix"));
                p.setCategorie(rs.getString("categorie"));
                list.add(p);
            }
        }
        return list;
    }


    public Plat getById(int id) throws SQLException {
        String sql = "SELECT * FROM plat WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Plat p = new Plat();
                p.setId(rs.getInt("id"));
                p.setNom(rs.getString("nom"));
                p.setDescription(rs.getString("description"));
                p.setPrix(rs.getDouble("prix"));
                p.setCategorie(rs.getString("categorie"));
                return p;
            }
        }
        return null;
    }


    public void insert(Plat p) throws SQLException {
        String sql = "INSERT INTO plat(nom,description,prix,categorie)"
                   + " VALUES(?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNom());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrix());
            ps.setString(4, p.getCategorie());
            ps.executeUpdate();
        }
    }


    public void update(Plat p) throws SQLException {
        String sql = "UPDATE plat SET nom=?,description=?,prix=?,categorie=?"
                   + " WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNom());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrix());
            ps.setString(4, p.getCategorie());
            ps.setInt(5, p.getId());
            ps.executeUpdate();
        }
    }


    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM plat WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
