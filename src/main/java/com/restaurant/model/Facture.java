package com.restaurant.model;


import java.util.Date;


public class Facture {
    private int id;
    private int commandeId;
    private double montantHT;
    private double tva;
    private double montantTTC;
    private Date dateFacture;
    private String statut; // EN_ATTENTE, PAYEE


    public Facture() {}


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCommandeId() { return commandeId; }
    public void setCommandeId(int commandeId) { this.commandeId = commandeId; }
    public double getMontantHT() { return montantHT; }
    public void setMontantHT(double montantHT) { this.montantHT = montantHT; }
    public double getTva() { return tva; }
    public void setTva(double tva) { this.tva = tva; }
    public double getMontantTTC() { return montantTTC; }
    public void setMontantTTC(double montantTTC) { this.montantTTC = montantTTC; }
    public Date getDateFacture() { return dateFacture; }
    public void setDateFacture(Date dateFacture) { this.dateFacture = dateFacture; }
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
}
