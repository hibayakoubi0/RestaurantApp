package com.restaurant.model;

public class TableRestaurant 

{
	 private int id;
	 private int numero;
	 private int capacite;
	 private String statut; // LIBRE, OCCUPEE, RESERVEE


	 public TableRestaurant() {}
	 public TableRestaurant(int id, int numero, int capacite, String statut) 
	 {
	        this.id = id;
	        this.numero = numero;
	        this.capacite = capacite;
	        this.statut = statut;
	  }
	 
	// Getters & Setters
	  public int getId() { return id; }
	  public void setId(int id) { this.id = id; }
	  public int getNumero() { return numero; }
	  public void setNumero(int numero) { this.numero = numero; }
	  public int getCapacite() { return capacite; }
	  public void setCapacite(int capacite) { this.capacite = capacite; }
	  public String getStatut() { return statut; }
	  public void setStatut(String statut) { this.statut = statut; }

	 
	 
	 
}
