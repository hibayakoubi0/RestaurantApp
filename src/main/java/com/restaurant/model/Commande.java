package com.restaurant.model;


import java.util.Date;
import java.util.List;


public class Commande {
    private int id;
    private int tableId;
    private Date dateHeure;
    private String statut; // EN_COURS, SERVIE, ANNULEE
    private List<LigneCommande> lignes;


    public Commande() {}


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getTableId() { return tableId; }
    public void setTableId(int tableId) { this.tableId = tableId; }
    public Date getDateHeure() { return dateHeure; }
    public void setDateHeure(Date dateHeure) { this.dateHeure = dateHeure; }
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    public List<LigneCommande> getLignes() { return lignes; }
    public void setLignes(List<LigneCommande> lignes) { this.lignes = lignes; }


    public double getTotal() {
        if (lignes == null) return 0;
        return lignes.stream()
            .mapToDouble(l -> l.getPrixUnitaire() * l.getQuantite())
            .sum();
    }
}
