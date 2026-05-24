<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.restaurant.model.TableRestaurant" %>
<%
  List<TableRestaurant> tables = (List<TableRestaurant>) request.getAttribute("tables");
  TableRestaurant edit = (TableRestaurant) request.getAttribute("table");
  String msg = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tables — Le Jardin</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    :root {
      --cream: #f5f0e8; --espresso: #1a0f0a; --amber: #c8873a;
      --gold: #e8b86d; --sage: #7a8c6e; --ink: #2d1f14;
      --accent: #4a90a4;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: var(--cream); font-family: 'DM Sans', sans-serif; color: var(--ink); }

    nav {
      background: var(--espresso); padding: 0 2.5rem;
      display: flex; align-items: center; justify-content: space-between;
      height: 68px; position: sticky; top: 0; z-index: 100;
      box-shadow: 0 2px 20px rgba(0,0,0,0.35);
    }
    .nav-brand { font-family: 'Playfair Display', serif; font-size: 1.3rem; color: var(--gold); text-decoration: none; display: flex; align-items: center; gap: 0.6rem; }
    .nav-links { display: flex; gap: 0.5rem; }
    .nav-links a { color: #c8b89a; text-decoration: none; padding: 0.4rem 1rem; border-radius: 4px; font-size: 0.85rem; font-weight: 500; letter-spacing: 0.06em; text-transform: uppercase; transition: all 0.2s; }
    .nav-links a:hover, .nav-links a.active { color: var(--gold); background: rgba(200,135,58,0.15); }

    .page-header {
      background: #fff; border-bottom: 1px solid #e8dcc8;
      padding: 1.8rem 2.5rem; display: flex; align-items: center; justify-content: space-between;
    }
    .page-header h1 { font-family: 'Playfair Display', serif; font-size: 1.7rem; display: flex; align-items: center; gap: 0.7rem; }
    .page-header h1 i { color: var(--accent); }
    .breadcrumb { font-size: 0.82rem; color: #8a7060; }
    .breadcrumb a { color: var(--amber); text-decoration: none; }

    .layout { display: grid; grid-template-columns: 380px 1fr; gap: 2rem; max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }

    /* ── FORM PANEL ── */
    .form-panel {
      background: #fff; border-radius: 12px;
      border: 1px solid #e8dcc8; overflow: hidden;
      box-shadow: 0 2px 12px rgba(26,15,10,0.06);
      height: fit-content; position: sticky; top: 88px;
    }
    .panel-header {
      background: var(--accent); padding: 1.2rem 1.5rem;
      display: flex; align-items: center; gap: 0.6rem; color: #fff;
    }
    .panel-header h2 { font-size: 1rem; font-weight: 500; }
    .panel-body { padding: 1.5rem; }

    .form-group { margin-bottom: 1.1rem; }
    .form-group label { display: block; font-size: 0.8rem; font-weight: 500; letter-spacing: 0.07em; text-transform: uppercase; color: #6b5a4a; margin-bottom: 0.4rem; }
    .form-group input, .form-group select {
      width: 100%; padding: 0.65rem 0.9rem;
      border: 1.5px solid #e0d4c0; border-radius: 7px;
      font-family: 'DM Sans', sans-serif; font-size: 0.9rem; color: var(--ink);
      background: var(--cream); transition: border-color 0.2s, box-shadow 0.2s;
      outline: none;
    }
    .form-group input:focus, .form-group select:focus {
      border-color: var(--accent); box-shadow: 0 0 0 3px rgba(74,144,164,0.12);
    }

    .status-select option[value="LIBRE"]    { background: #eef5f0; }
    .status-select option[value="OCCUPEE"]  { background: #fef0ee; }
    .status-select option[value="RESERVEE"] { background: #fffbec; }

    .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.65rem 1.4rem; border-radius: 7px; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.88rem; font-weight: 500; text-decoration: none; transition: all 0.2s; }
    .btn-primary { background: var(--accent); color: #fff; }
    .btn-primary:hover { background: #3a7a8e; box-shadow: 0 4px 14px rgba(74,144,164,0.3); }
    .btn-secondary { background: #f0e8da; color: var(--ink); }
    .btn-secondary:hover { background: #e0d4c0; }
    .btn-warning { background: #f59e2a; color: #fff; }
    .btn-warning:hover { background: #e08a18; }
    .btn-danger { background: #e05a38; color: #fff; }
    .btn-danger:hover { background: #c8461e; }
    .btn-sm { padding: 0.4rem 0.85rem; font-size: 0.8rem; }
    .btn-full { width: 100%; justify-content: center; }

    /* ── TABLE LIST ── */
    .table-panel { background: #fff; border-radius: 12px; border: 1px solid #e8dcc8; box-shadow: 0 2px 12px rgba(26,15,10,0.06); overflow: hidden; }
    .table-panel-header { padding: 1.2rem 1.5rem; border-bottom: 1px solid #f0e8d8; display: flex; align-items: center; justify-content: space-between; }
    .table-panel-header h2 { font-family: 'Playfair Display', serif; font-size: 1.1rem; }
    .table-count { background: #f0e8d8; color: var(--amber); font-size: 0.78rem; font-weight: 600; padding: 0.2rem 0.7rem; border-radius: 99px; }

    table { width: 100%; border-collapse: collapse; }
    th { padding: 0.8rem 1.2rem; text-align: left; font-size: 0.75rem; font-weight: 600; letter-spacing: 0.09em; text-transform: uppercase; color: #8a7060; background: #faf7f2; border-bottom: 1px solid #ede5d0; }
    td { padding: 0.95rem 1.2rem; border-bottom: 1px solid #f5f0e8; font-size: 0.9rem; vertical-align: middle; }
    tr:last-child td { border-bottom: none; }
    tr:hover td { background: #fdf9f4; }

    .badge {
      display: inline-flex; align-items: center; gap: 0.35rem;
      padding: 0.25rem 0.75rem; border-radius: 99px; font-size: 0.75rem; font-weight: 600;
    }
    .badge::before { content: ''; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
    .badge-libre    { background: #e8f5ec; color: #2d7a4a; }
    .badge-occupee  { background: #fde8e4; color: #b83a1e; }
    .badge-reservee { background: #fff8e1; color: #b86a00; }

    .actions { display: flex; gap: 0.4rem; }

    .alert { padding: 0.75rem 1.2rem; border-radius: 7px; margin: 1rem 2rem 0; font-size: 0.88rem; background: #e8f5ec; color: #2d7a4a; border: 1px solid #a8dab8; display: flex; align-items: center; gap: 0.5rem; }

    .empty-state { text-align: center; padding: 3rem 2rem; color: #9a8878; }
    .empty-state i { font-size: 2.5rem; color: #d0c4b0; margin-bottom: 0.7rem; display: block; }
  </style>
</head>
<body>

<nav>
  <a href="index.jsp" class="nav-brand"><i class="bi bi-flower1"></i> Le Jardin</a>
  <div class="nav-links">
    <a href="tables" class="active"><i class="bi bi-grid-3x3-gap"></i> Tables</a>
    <a href="menu"><i class="bi bi-journal-richtext"></i> Menu</a>
    <a href="commande"><i class="bi bi-bag-check"></i> Commandes</a>
  </div>
</nav>

<div class="page-header">
  <div>
    <div class="breadcrumb"><a href="index.jsp">Accueil</a> / Tables</div>
    <h1><i class="bi bi-grid-3x3-gap-fill"></i> Gestion des Tables</h1>
  </div>
</div>

<% if (msg != null) { %>
<div class="alert"><i class="bi bi-check-circle-fill"></i> <%= msg %></div>
<% } %>

<div class="layout">
  <!-- FORM -->
  <div class="form-panel">
    <div class="panel-header">
      <i class="bi bi-<%= edit != null ? "pencil" : "plus-circle" %>"></i>
      <h2><%= edit != null ? "Modifier la table" : "Ajouter une table" %></h2>
    </div>
    <div class="panel-body">
      <form method="post" action="tables">
        <% if (edit != null) { %>
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" value="<%= edit.getId() %>">
        <% } %>
        <div class="form-group">
          <label>Numéro de table</label>
          <input type="number" name="numero" placeholder="ex: 1" required
                 value="<%= edit != null ? edit.getNumero() : "" %>">
        </div>
        <div class="form-group">
          <label>Capacité (personnes)</label>
          <input type="number" name="capacite" placeholder="ex: 4" min="1" required
                 value="<%= edit != null ? edit.getCapacite() : "" %>">
        </div>
        <div class="form-group">
          <label>Statut</label>
          <select name="statut" class="status-select">
            <option value="LIBRE"   <%= edit != null && "LIBRE".equals(edit.getStatut())    ? "selected" : "" %>>🟢 Libre</option>
            <option value="OCCUPEE" <%= edit != null && "OCCUPEE".equals(edit.getStatut())  ? "selected" : "" %>>🔴 Occupée</option>
            <option value="RESERVEE"<%= edit != null && "RESERVEE".equals(edit.getStatut()) ? "selected" : "" %>>🟡 Réservée</option>
          </select>
        </div>
        <div style="display:flex; gap:0.7rem; margin-top:1.5rem;">
          <button type="submit" class="btn btn-primary btn-full">
            <i class="bi bi-<%= edit != null ? "check2" : "plus-lg" %>"></i>
            <%= edit != null ? "Enregistrer" : "Ajouter" %>
          </button>
          <% if (edit != null) { %>
            <a href="tables" class="btn btn-secondary"><i class="bi bi-x"></i></a>
          <% } %>
        </div>
      </form>
    </div>
  </div>

  <!-- TABLE LIST -->
  <div class="table-panel">
    <div class="table-panel-header">
      <h2>Toutes les tables</h2>
      <span class="table-count"><%= tables != null ? tables.size() : 0 %> tables</span>
    </div>
    <% if (tables == null || tables.isEmpty()) { %>
      <div class="empty-state">
        <i class="bi bi-grid-3x3-gap"></i>
        <p>Aucune table enregistrée. Ajoutez votre première table.</p>
      </div>
    <% } else { %>
    <table>
      <thead>
        <tr><th>N°</th><th>Capacité</th><th>Statut</th><th>Actions</th></tr>
      </thead>
      <tbody>
        <% for (TableRestaurant t : tables) {
           String s = t.getStatut();
           String bc = "LIBRE".equals(s) ? "libre" : "OCCUPEE".equals(s) ? "occupee" : "reservee";
           String icon = "LIBRE".equals(s) ? "🟢" : "OCCUPEE".equals(s) ? "🔴" : "🟡";
        %>
        <tr>
          <td><strong>Table <%= t.getNumero() %></strong></td>
          <td><i class="bi bi-people" style="color:#8a7060"></i> <%= t.getCapacite() %> pers.</td>
          <td><span class="badge badge-<%= bc %>"><%= icon %> <%= s %></span></td>
          <td>
            <div class="actions">
              <a href="tables?action=edit&id=<%= t.getId() %>" class="btn btn-warning btn-sm">
                <i class="bi bi-pencil"></i> Modifier
              </a>
              <a href="tables?action=delete&id=<%= t.getId() %>" class="btn btn-danger btn-sm"
                 onclick="return confirm('Supprimer la table <%= t.getNumero() %> ?')">
                <i class="bi bi-trash3"></i>
              </a>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>

</body>
</html>
