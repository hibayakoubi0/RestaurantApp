package com.restaurant.servlet;


import com.restaurant.dao.PlatDAO;
import com.restaurant.model.Plat;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


public class PlatServlet extends HttpServlet {


    private PlatDAO dao = new PlatDAO();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect("menu");
            } else if ("edit".equals(action)) {
                req.setAttribute("plat",
                    dao.getById(Integer.parseInt(req.getParameter("id"))));
                List<Plat> plats = dao.getAll();
                req.setAttribute("plats", plats);
                req.getRequestDispatcher("/menu.jsp").forward(req, resp);
            } else {
                req.setAttribute("plats", dao.getAll());
                req.getRequestDispatcher("/menu.jsp").forward(req, resp);
            }
        } catch (Exception e) { throw new ServletException(e); }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        Plat p = new Plat();
        p.setNom(req.getParameter("nom"));
        p.setDescription(req.getParameter("description"));
        p.setPrix(Double.parseDouble(req.getParameter("prix")));
        p.setCategorie(req.getParameter("categorie"));
        try {
            if ("update".equals(action)) {
                p.setId(Integer.parseInt(req.getParameter("id")));
                dao.update(p);
            } else { dao.insert(p); }
            resp.sendRedirect("menu");
        } catch (Exception e) { throw new ServletException(e); }
    }
}
