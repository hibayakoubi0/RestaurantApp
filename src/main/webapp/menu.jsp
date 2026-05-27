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
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,700;1,400;1,500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    :root {
      --bg: #fdf6f8;
      --primary: #b5476a;
      --primary-dark: #6e1f36;
      --rose: #e8a0b4;
      --rose-light: #fde8ef;
      --gold: #c9a96e;
      --gold-light: #f5e6c8;
      --peach: #f7cfd8;
      --text: #2c1018;
      --muted: #9a6878;
      --border: rgba(181,71,106,0.15);
      --border-solid: #f0dde4;
      --surface: rgba(255,255,255,0.82);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      min-height: 100vh;
      font-family: 'Lato', sans-serif;
      color: var(--text);
      background-color: var(--bg);
      background-image:
        radial-gradient(ellipse 900px 600px at 10% 0%, rgba(232,160,180,0.2) 0%, transparent 60%),
        radial-gradient(ellipse 700px 500px at 95% 15%, rgba(249,208,220,0.25) 0%, transparent 55%),
        radial-gradient(ellipse 600px 700px at 80% 100%, rgba(201,169,110,0.1) 0%, transparent 50%);
    }

    /* ======= NAV ======= */
    nav {
      background: rgba(110,31,54,0.93);
      backdrop-filter: blur(20px);
      padding: 0 2.5rem;
      display: flex; align-items: center; justify-content: space-between;
      height: 72px;
      position: sticky; top: 0; z-index: 100;
      box-shadow: 0 4px 24px rgba(110,31,54,0.22), 0 1px 0 rgba(255,255,255,0.06) inset;
      border-bottom: 1px solid rgba(249,208,220,0.15);
    }

    nav::after {
      content: '';
      position: absolute; bottom: 0; left: 50%; transform: translateX(-50%);
      width: 300px; height: 1px;
      background: linear-gradient(to right, transparent, rgba(201,169,110,0.5), transparent);
    }

    .nav-brand {
      font-family: 'Playfair Display', serif; font-size: 1.6rem;
      color: var(--gold-light); text-decoration: none;
      display: flex; align-items: center; gap: 0.7rem;
      font-weight: 500; letter-spacing: 1.5px;
      text-shadow: 0 2px 12px rgba(201,169,110,0.3);
    }

    .nav-brand i {
      color: var(--rose);
      filter: drop-shadow(0 0 6px rgba(232,160,180,0.5));
      animation: petalSway 4s ease-in-out infinite;
    }

    @keyframes petalSway {
      0%,100% { transform: rotate(-5deg) scale(1); }
      50%      { transform: rotate(5deg) scale(1.08); }
    }

    .nav-links { display: flex; gap: 6px; }
    .nav-links a {
      color: rgba(255,255,255,0.65); text-decoration: none;
      padding: 9px 18px; border-radius: 50px;
      font-size: 0.72rem; text-transform: uppercase; letter-spacing: 2.5px; font-weight: 700;
      transition: all 0.3s ease; border: 1px solid transparent;
      display: flex; align-items: center; gap: 6px;
    }
    .nav-links a:hover, .nav-links a.active {
      color: var(--gold-light);
      background: rgba(201,169,110,0.1);
      border-color: rgba(201,169,110,0.25);
      transform: translateY(-2px);
    }

    /* ======= PAGE HEADER ======= */
    .page-header {
      background: rgba(255,255,255,0.75);
      backdrop-filter: blur(12px);
      border-bottom: 1px solid var(--border-solid);
      padding: 1.6rem 2.5rem;
      position: relative; overflow: hidden;
    }

    /* Décoration florale dans le header — purement visuelle */
    .page-header::after {
      content: '✿';
      position: absolute; right: 2.5rem; top: 50%; transform: translateY(-50%);
      font-size: 4rem; color: rgba(181,71,106,0.06);
      font-family: 'Playfair Display', serif;
      pointer-events: none;
    }

    .breadcrumb {
      font-size: 0.78rem; color: var(--muted); margin-bottom: 6px;
      text-transform: uppercase; letter-spacing: 2px; font-weight: 700;
    }
    .breadcrumb a { color: var(--primary); text-decoration: none; }
    .breadcrumb a:hover { text-decoration: underline; }

    .page-header h1 {
      font-family: 'Playfair Display', serif; font-size: 1.8rem;
      font-weight: 500; color: var(--primary-dark);
      display: flex; align-items: center; gap: 0.7rem;
    }
    .page-header h1 i { color: var(--primary); font-size: 1.5rem; }

    /* ======= LAYOUT ======= */
    .layout {
      display: grid; grid-template-columns: 360px 1fr; gap: 2rem;
      max-width: 1200px; margin: 2rem auto; padding: 0 2rem;
    }

    /* ======= FORM PANEL ======= */
    .form-panel {
      background: var(--surface);
      backdrop-filter: blur(16px);
      border-radius: 28px;
      border: 1px solid rgba(255,255,255,0.95);
      box-shadow: 0 2px 0 rgba(255,255,255,0.9) inset, 0 12px 40px rgba(110,31,54,0.1);
      overflow: hidden;
      height: fit-content; position: sticky; top: 88px;
    }

    .panel-header {
      background: linear-gradient(135deg, var(--primary), var(--primary-dark));
      padding: 1.3rem 1.6rem;
      display: flex; align-items: center; gap: 0.7rem; color: #fff;
      position: relative; overflow: hidden;
    }

    .panel-header::after {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; bottom: 0;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.07), transparent);
      pointer-events: none;
    }

    .panel-header i { font-size: 1.2rem; color: var(--gold-light); }
    .panel-header h2 { font-family: 'Playfair Display', serif; font-size: 1.1rem; font-weight: 500; }

    .panel-body { padding: 1.6rem; }

    .form-group { margin-bottom: 1.1rem; }
    .form-group label {
      display: block; font-size: 0.72rem; font-weight: 700;
      letter-spacing: 2px; text-transform: uppercase; color: var(--muted); margin-bottom: 0.45rem;
    }
    .form-group input, .form-group select, .form-group textarea {
      width: 100%; padding: 0.65rem 1rem;
      border: 1.5px solid var(--border-solid); border-radius: 50px;
      font-family: 'Lato', sans-serif; font-size: 0.9rem; color: var(--text);
      background: rgba(255,255,255,0.8); transition: all 0.25s; outline: none;
    }
    .form-group textarea {
      border-radius: 16px; resize: vertical; min-height: 70px;
    }
    .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(181,71,106,0.1);
      background: #fff;
    }

    /* ======= BUTTONS ======= */
    .btn {
      display: inline-flex; align-items: center; gap: 0.45rem;
      padding: 0.65rem 1.4rem; border-radius: 50px; border: none;
      cursor: pointer; font-family: 'Lato', sans-serif;
      font-size: 0.82rem; font-weight: 700; text-decoration: none;
      transition: all 0.3s ease; letter-spacing: 0.5px;
    }
    .btn-primary {
      background: linear-gradient(135deg, var(--primary), var(--primary-dark));
      color: #fff;
      box-shadow: 0 8px 22px rgba(110,31,54,0.25), 0 2px 0 rgba(255,255,255,0.12) inset;
    }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 14px 30px rgba(110,31,54,0.3); }

    .btn-secondary {
      background: var(--rose-light); color: var(--primary);
      border: 1px solid rgba(181,71,106,0.2);
    }
    .btn-secondary:hover { background: var(--peach); transform: translateY(-2px); }

    .btn-warning {
      background: linear-gradient(135deg, #d4834a, #b5622a); color: #fff;
      box-shadow: 0 4px 12px rgba(180,90,40,0.25);
    }
    .btn-warning:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(180,90,40,0.3); }

    .btn-danger {
      background: linear-gradient(135deg, #c84040, #8f2020); color: #fff;
      box-shadow: 0 4px 12px rgba(180,40,40,0.2);
    }
    .btn-danger:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(180,40,40,0.3); }

    .btn-sm { padding: 0.38rem 0.9rem; font-size: 0.78rem; }

    /* ======= MENU PANEL ======= */
    .menu-panel {
      background: var(--surface);
      backdrop-filter: blur(16px);
      border-radius: 28px;
      border: 1px solid rgba(255,255,255,0.95);
      box-shadow: 0 2px 0 rgba(255,255,255,0.9) inset, 0 12px 40px rgba(110,31,54,0.1);
      overflow: hidden;
      position: relative;
    }

    /* Ligne colorée en haut */
    .menu-panel::before {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; height: 3px;
      background: linear-gradient(to right, var(--peach), var(--rose), var(--gold));
      opacity: 0.8;
    }

    /* ======= TABS ======= */
    .tabs {
      display: flex; border-bottom: 1px solid var(--border-solid);
      background: rgba(253,232,239,0.3);
      padding-top: 3px;
    }

    .tab-btn {
      padding: 0.9rem 1.4rem; border: none; background: none; cursor: pointer;
      font-family: 'Lato', sans-serif; font-size: 0.75rem; font-weight: 700;
      letter-spacing: 2px; text-transform: uppercase; color: var(--muted);
      border-bottom: 2px solid transparent;
      transition: all 0.25s; margin-bottom: -1px;
      display: flex; align-items: center; gap: 6px;
    }
    .tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); background: rgba(255,255,255,0.6); }
    .tab-btn:hover:not(.active) { color: var(--primary-dark); background: rgba(253,232,239,0.4); }

    .tab-content { display: none; }
    .tab-content.active { display: block; }

    /* ======= TABLE ======= */
    .menu-table { width: 100%; border-collapse: collapse; }
    .menu-table th {
      padding: 0.85rem 1.4rem; text-align: left;
      font-size: 0.7rem; font-weight: 700; letter-spacing: 2.5px; text-transform: uppercase;
      color: var(--muted); background: rgba(253,232,239,0.25);
      border-bottom: 1px solid var(--border-solid);
    }
    .menu-table td { padding: 1rem 1.4rem; border-bottom: 1px solid rgba(181,71,106,0.06); font-size: 0.9rem; vertical-align: middle; }
    .menu-table tr:last-child td { border-bottom: none; }
    .menu-table tr:hover td { background: rgba(253,232,239,0.3); transition: background 0.2s; }

    .cat-badge {
      display: inline-block; padding: 0.22rem 0.8rem; border-radius: 99px;
      font-size: 0.7rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase;
    }
    .cat-ENTREE  { background: rgba(100,149,237,0.12); color: #3a5ab0; }
    .cat-PLAT    { background: rgba(181,71,106,0.12);  color: var(--primary-dark); }
    .cat-DESSERT { background: rgba(193,100,200,0.12); color: #7a2a8a; }
    .cat-BOISSON { background: rgba(50,160,180,0.12);  color: #1a6a7a; }

    .price {
      font-family: 'Playfair Display', serif; font-size: 1rem;
      color: var(--primary); font-weight: 500;
    }

    .actions { display: flex; gap: 0.45rem; }

    .dish-name { font-weight: 700; margin-bottom: 2px; }
    .dish-desc { font-size: 0.8rem; color: var(--muted); font-weight: 300; }

    .count-badge {
      background: var(--rose-light); color: var(--primary);
      font-size: 0.68rem; font-weight: 700; padding: 0.15rem 0.6rem;
      border-radius: 99px; margin-left: 4px;
    }

    .empty-state { text-align: center; padding: 3.5rem 2rem; color: var(--muted); }
    .empty-state i { font-size: 2.8rem; color: var(--border-solid); margin-bottom: 0.8rem; display: block; }
    .empty-state p { font-size: 0.9rem; }

    /* ======= PÉTALES TOMBANTS ======= */
    .petals-container {
      position: fixed; inset: 0;
      pointer-events: none; z-index: 0; overflow: hidden;
    }

    .petal {
      position: absolute; top: -60px;
      font-size: 1.3rem; opacity: 0;
      animation: petalFall linear infinite;
      user-select: none;
      filter: drop-shadow(0 2px 4px rgba(181,71,106,0.15));
    }

    /* Chaque pétale a sa position, taille, vitesse et délai uniques */
    .petal:nth-child(1)  { left:3%;   font-size:0.9rem;  animation-duration:9s;  animation-delay:0s;   }
    .petal:nth-child(2)  { left:8%;   font-size:1.5rem;  animation-duration:11s; animation-delay:1.2s; }
    .petal:nth-child(3)  { left:15%;  font-size:1.1rem;  animation-duration:8s;  animation-delay:3.5s; }
    .petal:nth-child(4)  { left:22%;  font-size:1.8rem;  animation-duration:13s; animation-delay:0.7s; }
    .petal:nth-child(5)  { left:30%;  font-size:0.85rem; animation-duration:7s;  animation-delay:5s;   }
    .petal:nth-child(6)  { left:38%;  font-size:1.4rem;  animation-duration:10s; animation-delay:2s;   }
    .petal:nth-child(7)  { left:46%;  font-size:1rem;    animation-duration:9s;  animation-delay:4.2s; }
    .petal:nth-child(8)  { left:54%;  font-size:1.6rem;  animation-duration:12s; animation-delay:1s;   }
    .petal:nth-child(9)  { left:62%;  font-size:0.95rem; animation-duration:8s;  animation-delay:6s;   }
    .petal:nth-child(10) { left:70%;  font-size:1.3rem;  animation-duration:10s; animation-delay:0.5s; }
    .petal:nth-child(11) { left:78%;  font-size:1.1rem;  animation-duration:9s;  animation-delay:3s;   }
    .petal:nth-child(12) { left:85%;  font-size:1.7rem;  animation-duration:14s; animation-delay:1.8s; }
    .petal:nth-child(13) { left:91%;  font-size:1rem;    animation-duration:8s;  animation-delay:7s;   }
    .petal:nth-child(14) { left:96%;  font-size:1.4rem;  animation-duration:11s; animation-delay:2.5s; }

    @keyframes petalFall {
      0%   { opacity:0;   transform: translateY(-40px) rotate(0deg)   scale(0.7); }
      8%   { opacity:0.7; }
      85%  { opacity:0.4; }
      100% { opacity:0;   transform: translateY(105vh) rotate(420deg) scale(1.1); }
    }

    /* ======= RESPONSIVE ======= */
    @media (max-width: 900px) {
      .layout { grid-template-columns: 1fr; }
      nav { padding: 0 1.2rem; }
      .nav-links { display: none; }
      .page-header { padding: 1.2rem 1.5rem; }
      .layout { padding: 0 1rem; }
    }
  </style>
</head>
<body>

<!-- Pétales tombants — décoration pure, aucun impact servlet -->
<div class="petals-container" aria-hidden="true">
  <span class="petal">🌸</span>
  <span class="petal">🌷</span>
  <span class="petal">🌹</span>
  <span class="petal">🌸</span>
  <span class="petal">✿</span>
  <span class="petal">🌷</span>
  <span class="petal">🌸</span>
  <span class="petal">🌹</span>
  <span class="petal">🌸</span>
  <span class="petal">🌷</span>
  <span class="petal">✿</span>
  <span class="petal">🌸</span>
  <span class="petal">🌹</span>
  <span class="petal">🌷</span>
</div>

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
