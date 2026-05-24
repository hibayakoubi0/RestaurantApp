package com.restaurant.model;


public class LigneCommande {
    private int id;
    private int commandeId;
    private int platId;
    private String platNom;
    private int quantite;
    private double prixUnitaire;


    public LigneCommande() {}


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCommandeId() { return commandeId; }
    public void setCommandeId(int commandeId) { this.commandeId = commandeId; }
    public int getPlatId() { return platId; }
    public void setPlatId(int platId) { this.platId = platId; }
    public String getPlatNom() { return platNom; }
    public void setPlatNom(String platNom) { this.platNom = platNom; }
    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }
    public double getPrixUnitaire() { return prixUnitaire; }
    public void setPrixUnitaire(double p) { this.prixUnitaire = p; }
    public double getSousTotal() { return quantite * prixUnitaire; }
}
