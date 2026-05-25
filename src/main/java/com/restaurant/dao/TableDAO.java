package com.restaurant.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.restaurant.model.TableRestaurant;
import com.restaurant.util.DBConnection;


public class TableDAO {


    public List<TableRestaurant> getAll() throws SQLException {
        List<TableRestaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM table_restaurant ORDER BY numero";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                TableRestaurant t = new TableRestaurant();
                t.setId(rs.getInt("id"));
                t.setNumero(rs.getInt("numero"));
                t.setCapacite(rs.getInt("capacite"));
                t.setStatut(rs.getString("statut"));
                list.add(t);
            }
        } catch (Exception ex) {
            System.getLogger(TableDAO.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
        return list;
    }


    public TableRestaurant getById(int id) throws SQLException {
        String sql = "SELECT * FROM table_restaurant WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TableRestaurant t = new TableRestaurant();
                t.setId(rs.getInt("id"));
                t.setNumero(rs.getInt("numero"));
                t.setCapacite(rs.getInt("capacite"));
                t.setStatut(rs.getString("statut"));
                return t;
            }
        } catch (Exception ex) {
            System.getLogger(TableDAO.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
        return null;
    }


    public void insert(TableRestaurant t) throws SQLException {
        String sql = "INSERT INTO table_restaurant(numero,capacite,statut)"
                   + " VALUES(?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getNumero());
            ps.setInt(2, t.getCapacite());
            ps.setString(3, t.getStatut());
            ps.executeUpdate();
        } catch (Exception ex) {
            System.getLogger(TableDAO.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
    }


    public void update(TableRestaurant t) throws SQLException {
        String sql = "UPDATE table_restaurant SET numero=?,capacite=?,statut=?"
                   + " WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, t.getNumero());
            ps.setInt(2, t.getCapacite());
            ps.setString(3, t.getStatut());
            ps.setInt(4, t.getId());
            ps.executeUpdate();
        } catch (Exception ex) {
            System.getLogger(TableDAO.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
    }


    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM table_restaurant WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception ex) {
            System.getLogger(TableDAO.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
    }
}
