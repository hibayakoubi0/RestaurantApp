package com.restaurant.servlet;


import java.io.IOException;

import com.restaurant.dao.CommandeDAO;
import com.restaurant.dao.PlatDAO;
import com.restaurant.dao.TableDAO;
import com.restaurant.model.Commande;
import com.restaurant.model.LigneCommande;
import com.restaurant.model.Plat;
import com.restaurant.model.TableRestaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class CommandeServlet extends HttpServlet {


    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private CommandeDAO cmdDao = new CommandeDAO();
    private TableDAO tableDao = new TableDAO();
    private PlatDAO platDao = new PlatDAO();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("commandes", cmdDao.getAll());
            req.setAttribute("tables", tableDao.getAll());
            req.setAttribute("plats", platDao.getAll());
            req.getRequestDispatcher("/commande.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        try {
            if ("creer".equals(action)) {
                int tableId = Integer.parseInt(req.getParameter("tableId"));
                String[] platIds = req.getParameterValues("platId");
                String[] quantites = req.getParameterValues("quantite");
                // Créer la commande
                Commande cmd = new Commande();
                cmd.setTableId(tableId);
                int cmdId = cmdDao.insert(cmd);
                // Ajouter les lignes
                for (int i = 0; i < platIds.length; i++) {
                    Plat plat = platDao.getById(
                        Integer.parseInt(platIds[i]));
                    LigneCommande lc = new LigneCommande();
                    lc.setCommandeId(cmdId);
                    lc.setPlatId(plat.getId());
                    lc.setQuantite(Integer.parseInt(quantites[i]));
                    lc.setPrixUnitaire(plat.getPrix());
                    cmdDao.insertLigne(lc);
                }
                // Mettre à jour le statut de la table
                TableRestaurant t = tableDao.getById(tableId);
                t.setStatut("OCCUPEE");
                tableDao.update(t);
                resp.sendRedirect("commande");
            } else if ("statut".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String statut = req.getParameter("statut");
                cmdDao.updateStatut(id, statut);
                resp.sendRedirect("commande");
            }
        } catch (Exception e) { throw new ServletException(e); }
    }
}
