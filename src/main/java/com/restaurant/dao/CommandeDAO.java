package com.restaurant.dao;


import com.restaurant.model.*;
import com.restaurant.util.DBConnection;
import java.sql.*;
import java.util.*;


public class CommandeDAO {


    public List<Commande> getAll() throws SQLException {
        List<Commande> list = new ArrayList<>();
        String sql = "SELECT * FROM commande ORDER BY date_heure DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Commande c = new Commande();
                c.setId(rs.getInt("id"));
                c.setTableId(rs.getInt("table_id"));
                c.setDateHeure(rs.getTimestamp("date_heure"));
                c.setStatut(rs.getString("statut"));
                c.setLignes(getLignes(c.getId()));
                list.add(c);
            }
        }
        return list;
    }


    public int insert(Commande c) throws SQLException {
        String sql = "INSERT INTO commande(table_id,statut) VALUES(?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql,
                 Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, c.getTableId());
            ps.setString(2, "EN_COURS");
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        }
        return -1;
    }


    public void insertLigne(LigneCommande l) throws SQLException {
        String sql = "INSERT INTO ligne_commande"
                   + "(commande_id,plat_id,quantite,prix_unitaire) VALUES(?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, l.getCommandeId());
            ps.setInt(2, l.getPlatId());
            ps.setInt(3, l.getQuantite());
            ps.setDouble(4, l.getPrixUnitaire());
            ps.executeUpdate();
        }
    }


    public List<LigneCommande> getLignes(int commandeId) throws SQLException {
        List<LigneCommande> list = new ArrayList<>();
        String sql = "SELECT lc.*, p.nom as plat_nom FROM ligne_commande lc"
                   + " JOIN plat p ON lc.plat_id = p.id"
                   + " WHERE lc.commande_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commandeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                LigneCommande l = new LigneCommande();
                l.setId(rs.getInt("id"));
                l.setCommandeId(commandeId);
                l.setPlatId(rs.getInt("plat_id"));
                l.setPlatNom(rs.getString("plat_nom"));
                l.setQuantite(rs.getInt("quantite"));
                l.setPrixUnitaire(rs.getDouble("prix_unitaire"));
                list.add(l);
            }
        }
        return list;
    }


    public void updateStatut(int id, String statut) throws SQLException {
        String sql = "UPDATE commande SET statut=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statut);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }
}
