<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.restaurant.model.Plat" %>
<%
  List<Plat> plats = (List<Plat>) request.getAttribute("plats");
  Plat edit = (Plat) request.getAttribute("plat");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Menu — Le Jardin</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    :root {
      --cream: #f5f0e8; --espresso: #1a0f0a; --amber: #c8873a;
      --gold: #e8b86d; --sage: #7a8c6e; --ink: #2d1f14;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: var(--cream); font-family: 'DM Sans', sans-serif; color: var(--ink); }

    nav { background: var(--espresso); padding: 0 2.5rem; display: flex; align-items: center; justify-content: space-between; height: 68px; position: sticky; top: 0; z-index: 100; box-shadow: 0 2px 20px rgba(0,0,0,0.35); }
    .nav-brand { font-family: 'Playfair Display', serif; font-size: 1.3rem; color: var(--gold); text-decoration: none; display: flex; align-items: center; gap: 0.6rem; }
    .nav-links { display: flex; gap: 0.5rem; }
    .nav-links a { color: #c8b89a; text-decoration: none; padding: 0.4rem 1rem; border-radius: 4px; font-size: 0.85rem; font-weight: 500; letter-spacing: 0.06em; text-transform: uppercase; transition: all 0.2s; }
    .nav-links a:hover, .nav-links a.active { color: var(--gold); background: rgba(200,135,58,0.15); }

    .page-header { background: #fff; border-bottom: 1px solid #e8dcc8; padding: 1.8rem 2.5rem; }
    .breadcrumb { font-size: 0.82rem; color: #8a7060; }
    .breadcrumb a { color: var(--amber); text-decoration: none; }
    .page-header h1 { font-family: 'Playfair Display', serif; font-size: 1.7rem; display: flex; align-items: center; gap: 0.7rem; }
    .page-header h1 i { color: var(--sage); }

    .layout { display: grid; grid-template-columns: 360px 1fr; gap: 2rem; max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }

    .form-panel { background: #fff; border-radius: 12px; border: 1px solid #e8dcc8; overflow: hidden; box-shadow: 0 2px 12px rgba(26,15,10,0.06); height: fit-content; position: sticky; top: 88px; }
    .panel-header { background: var(--sage); padding: 1.2rem 1.5rem; display: flex; align-items: center; gap: 0.6rem; color: #fff; }
    .panel-header h2 { font-size: 1rem; font-weight: 500; }
    .panel-body { padding: 1.5rem; }

    .form-group { margin-bottom: 1.1rem; }
    .form-group label { display: block; font-size: 0.78rem; font-weight: 500; letter-spacing: 0.07em; text-transform: uppercase; color: #6b5a4a; margin-bottom: 0.4rem; }
    .form-group input, .form-group select, .form-group textarea {
      width: 100%; padding: 0.65rem 0.9rem;
      border: 1.5px solid #e0d4c0; border-radius: 7px;
      font-family: 'DM Sans', sans-serif; font-size: 0.9rem; color: var(--ink);
      background: var(--cream); transition: border-color 0.2s, box-shadow 0.2s; outline: none;
    }
    .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
      border-color: var(--sage); box-shadow: 0 0 0 3px rgba(122,140,110,0.12);
    }
    .form-group textarea { resize: vertical; min-height: 70px; }

    .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.65rem 1.4rem; border-radius: 7px; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.88rem; font-weight: 500; text-decoration: none; transition: all 0.2s; }
    .btn-primary { background: var(--sage); color: #fff; }
    .btn-primary:hover { background: #627857; box-shadow: 0 4px 14px rgba(122,140,110,0.3); }
    .btn-secondary { background: #f0e8da; color: var(--ink); }
    .btn-secondary:hover { background: #e0d4c0; }
    .btn-warning { background: #f59e2a; color: #fff; }
    .btn-warning:hover { background: #e08a18; }
    .btn-danger { background: #e05a38; color: #fff; }
    .btn-danger:hover { background: #c8461e; }
    .btn-sm { padding: 0.4rem 0.85rem; font-size: 0.8rem; }

    /* ── CATEGORY TABS ── */
    .menu-panel { background: #fff; border-radius: 12px; border: 1px solid #e8dcc8; box-shadow: 0 2px 12px rgba(26,15,10,0.06); overflow: hidden; }
    .tabs { display: flex; border-bottom: 1px solid #ede5d0; background: #faf7f2; }
    .tab-btn { padding: 0.8rem 1.4rem; border: none; background: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.82rem; font-weight: 500; letter-spacing: 0.06em; text-transform: uppercase; color: #9a8878; border-bottom: 2px solid transparent; transition: all 0.2s; margin-bottom: -1px; }
    .tab-btn.active { color: var(--amber); border-bottom-color: var(--amber); background: #fff; }
    .tab-btn:hover:not(.active) { color: var(--ink); }

    .tab-content { display: none; }
    .tab-content.active { display: block; }

    .menu-table { width: 100%; border-collapse: collapse; }
    .menu-table th { padding: 0.8rem 1.2rem; text-align: left; font-size: 0.75rem; font-weight: 600; letter-spacing: 0.09em; text-transform: uppercase; color: #8a7060; background: #faf7f2; border-bottom: 1px solid #ede5d0; }
    .menu-table td { padding: 0.95rem 1.2rem; border-bottom: 1px solid #f5f0e8; font-size: 0.9rem; vertical-align: middle; }
    .menu-table tr:last-child td { border-bottom: none; }
    .menu-table tr:hover td { background: #fdf9f4; }

    .cat-badge { display: inline-block; padding: 0.2rem 0.7rem; border-radius: 99px; font-size: 0.72rem; font-weight: 600; }
    .cat-ENTREE  { background: #e8f0fe; color: #3a5ab0; }
    .cat-PLAT    { background: #fde8e4; color: #b83a1e; }
    .cat-DESSERT { background: #fce4f5; color: #8e2e7a; }
    .cat-BOISSON { background: #e4f5fc; color: #1e7a9e; }

    .price { font-family: 'Playfair Display', serif; font-size: 0.95rem; color: var(--amber); }
    .actions { display: flex; gap: 0.4rem; }
    .dish-name { font-weight: 500; }
    .dish-desc { font-size: 0.8rem; color: #8a7060; font-weight: 300; }

    .empty-state { text-align: center; padding: 3rem 2rem; color: #9a8878; }
    .empty-state i { font-size: 2.5rem; color: #d0c4b0; margin-bottom: 0.7rem; display: block; }

    .count-badge { background: #f0e8d8; color: var(--amber); font-size: 0.72rem; font-weight: 600; padding: 0.15rem 0.6rem; border-radius: 99px; margin-left: 0.4rem; }
  </style>
</head>
<body>

<nav>
  <a href="index.jsp" class="nav-brand"><i class="bi bi-flower1"></i> Le Jardin</a>
  <div class="nav-links">
    <a href="tables"><i class="bi bi-grid-3x3-gap"></i> Tables</a>
    <a href="menu" class="active"><i class="bi bi-journal-richtext"></i> Menu</a>
    <a href="commande"><i class="bi bi-bag-check"></i> Commandes</a>
  </div>
</nav>

<div class="page-header">
  <div class="breadcrumb"><a href="index.jsp">Accueil</a> / Menu</div>
  <h1><i class="bi bi-journal-richtext"></i> Gestion du Menu</h1>
</div>

<div class="layout">
  <!-- FORM -->
  <div class="form-panel">
    <div class="panel-header">
      <i class="bi bi-<%= edit != null ? "pencil" : "plus-circle" %>"></i>
      <h2><%= edit != null ? "Modifier le plat" : "Nouveau plat" %></h2>
    </div>
    <div class="panel-body">
      <form method="post" action="menu">
        <% if (edit != null) { %>
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" value="<%= edit.getId() %>">
        <% } %>
        <div class="form-group">
          <label>Nom du plat *</label>
          <input type="text" name="nom" placeholder="ex: Tajine d'agneau" required
                 value="<%= edit != null ? edit.getNom() : "" %>">
        </div>
        <div class="form-group">
          <label>Description</label>
          <textarea name="description" placeholder="Ingrédients, présentation..."><%= edit != null && edit.getDescription() != null ? edit.getDescription() : "" %></textarea>
        </div>
        <div class="form-group">
          <label>Prix (MAD) *</label>
          <input type="number" step="0.01" min="0" name="prix" placeholder="0.00" required
                 value="<%= edit != null ? edit.getPrix() : "" %>">
        </div>
        <div class="form-group">
          <label>Catégorie</label>
          <select name="categorie">
            <option value="ENTREE"  <%= edit != null && "ENTREE".equals(edit.getCategorie())  ? "selected" : "" %>>🥗 Entrée</option>
            <option value="PLAT"    <%= edit != null && "PLAT".equals(edit.getCategorie())    ? "selected" : "" %>>🍽️ Plat principal</option>
            <option value="DESSERT" <%= edit != null && "DESSERT".equals(edit.getCategorie()) ? "selected" : "" %>>🍮 Dessert</option>
            <option value="BOISSON" <%= edit != null && "BOISSON".equals(edit.getCategorie()) ? "selected" : "" %>>🥤 Boisson</option>
          </select>
        </div>
        <div style="display:flex; gap:0.7rem; margin-top:1.5rem;">
          <button type="submit" class="btn btn-primary" style="flex:1; justify-content:center;">
            <i class="bi bi-<%= edit != null ? "check2" : "plus-lg" %>"></i>
            <%= edit != null ? "Enregistrer" : "Ajouter" %>
          </button>
          <% if (edit != null) { %>
            <a href="menu" class="btn btn-secondary"><i class="bi bi-x"></i></a>
          <% } %>
        </div>
      </form>
    </div>
  </div>

  <!-- MENU LIST WITH TABS -->
  <div class="menu-panel">
    <%
      String[] cats = {"ENTREE","PLAT","DESSERT","BOISSON"};
      String[] catLabels = {"🥗 Entrées","🍽️ Plats","🍮 Desserts","🥤 Boissons"};
      java.util.Map<String,java.util.List<Plat>> grouped = new java.util.LinkedHashMap<>();
      for (String c : cats) grouped.put(c, new java.util.ArrayList<>());
      if (plats != null) for (Plat p : plats) {
        if (grouped.containsKey(p.getCategorie())) grouped.get(p.getCategorie()).add(p);
        else grouped.get("PLAT").add(p);
      }
    %>
    <div class="tabs">
      <% for (int i = 0; i < cats.length; i++) { %>
      <button class="tab-btn <%= i == 0 ? "active" : "" %>"
              onclick="showTab('<%= cats[i] %>', this)">
        <%= catLabels[i] %>
        <span class="count-badge"><%= grouped.get(cats[i]).size() %></span>
      </button>
      <% } %>
    </div>
    <% for (int i = 0; i < cats.length; i++) {
       String cat = cats[i];
       java.util.List<Plat> group = grouped.get(cat);
    %>
    <div class="tab-content <%= i == 0 ? "active" : "" %>" id="tab-<%= cat %>">
      <% if (group.isEmpty()) { %>
        <div class="empty-state">
          <i class="bi bi-journal-x"></i>
          <p>Aucun plat dans cette catégorie.</p>
        </div>
      <% } else { %>
      <table class="menu-table">
        <thead><tr><th>Plat</th><th>Catégorie</th><th>Prix</th><th>Actions</th></tr></thead>
        <tbody>
          <% for (Plat p : group) { %>
          <tr>
            <td>
              <div class="dish-name"><%= p.getNom() %></div>
              <% if (p.getDescription() != null && !p.getDescription().isEmpty()) { %>
              <div class="dish-desc"><%= p.getDescription() %></div>
              <% } %>
            </td>
            <td><span class="cat-badge cat-<%= p.getCategorie() %>"><%= p.getCategorie() %></span></td>
            <td><span class="price"><%= String.format("%.2f", p.getPrix()) %> MAD</span></td>
            <td>
              <div class="actions">
                <a href="menu?action=edit&id=<%= p.getId() %>" class="btn btn-warning btn-sm">
                  <i class="bi bi-pencil"></i>
                </a>
                <a href="menu?action=delete&id=<%= p.getId() %>" class="btn btn-danger btn-sm"
                   onclick="return confirm('Supprimer « <%= p.getNom() %> » ?')">
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
    <% } %>
  </div>
</div>

<script>
function showTab(cat, btn) {
  document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
  document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
  document.getElementById('tab-' + cat).classList.add('active');
  btn.classList.add('active');
}
// Auto-select the tab of the plat being edited
<% if (edit != null) { %>
document.addEventListener('DOMContentLoaded', () => {
  const cat = '<%= edit.getCategorie() %>';
  const btn = Array.from(document.querySelectorAll('.tab-btn')).find(b => b.textContent.includes(cat) || b.getAttribute('onclick')?.includes(cat));
  if (btn) btn.click();
});
<% } %>
</script>
</body>
</html>
