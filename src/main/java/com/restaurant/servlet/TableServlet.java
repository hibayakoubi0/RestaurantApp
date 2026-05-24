package com.restaurant.servlet;


import java.io.IOException;
import java.util.List;

import com.restaurant.dao.TableDAO;
import com.restaurant.model.TableRestaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class TableServlet extends HttpServlet {


    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private TableDAO dao = new TableDAO();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.delete(id);
                resp.sendRedirect("tables");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                TableRestaurant t = dao.getById(id);
                req.setAttribute("table", t);
                req.getRequestDispatcher("/tables.jsp")
                    .forward(req, resp);
            } else {
                List<TableRestaurant> tables = dao.getAll();
                req.setAttribute("tables", tables);
                req.getRequestDispatcher("/tables.jsp")
                    .forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        TableRestaurant t = new TableRestaurant();
        t.setNumero(Integer.parseInt(req.getParameter("numero")));
        t.setCapacite(Integer.parseInt(req.getParameter("capacite")));
        t.setStatut(req.getParameter("statut"));
        try {
            if ("update".equals(action)) {
                t.setId(Integer.parseInt(req.getParameter("id")));
                dao.update(t);
            } else {
                dao.insert(t);
            }
            resp.sendRedirect("tables");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
