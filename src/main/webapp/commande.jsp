<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.restaurant.model.*" %>
<%
  List<Commande> commandes = (List<Commande>) request.getAttribute("commandes");
  List<TableRestaurant> tables = (List<TableRestaurant>) request.getAttribute("tables");
  List<Plat> plats = (List<Plat>) request.getAttribute("plats");

  // Count free tables
  int tablesLibres = 0;
  if (tables != null) for (TableRestaurant t : tables)
    if ("LIBRE".equals(t.getStatut())) tablesLibres++;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Commandes — Le Jardin</title>
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

    .page-header { background: #fff; border-bottom: 1px solid #e8dcc8; padding: 1.5rem 2.5rem; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem; }
    .breadcrumb { font-size: 0.82rem; color: #8a7060; }
    .breadcrumb a { color: var(--amber); text-decoration: none; }
    .page-header h1 { font-family: 'Playfair Display', serif; font-size: 1.7rem; display: flex; align-items: center; gap: 0.7rem; }
    .page-header h1 i { color: var(--amber); }

    .header-stats { display: flex; gap: 1.5rem; }
    .hstat { text-align: center; }
    .hstat-num { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: var(--amber); display: block; }
    .hstat-lbl { font-size: 0.72rem; letter-spacing: 0.1em; text-transform: uppercase; color: #9a8878; }

    .container { max-width: 1100px; margin: 2rem auto; padding: 0 2rem; }

    /* ── NEW ORDER FORM ── */
    .new-order-panel {
      background: #fff; border-radius: 14px; border: 1px solid #e8dcc8;
      box-shadow: 0 2px 16px rgba(26,15,10,0.07); overflow: hidden; margin-bottom: 2.5rem;
    }
    .panel-header-amber { background: var(--amber); padding: 1.2rem 1.8rem; display: flex; align-items: center; gap: 0.7rem; color: #fff; }
    .panel-header-amber h2 { font-size: 1rem; font-weight: 500; }
    .panel-body { padding: 1.8rem; }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem; align-items: end; }
    .form-group { }
    .form-group label { display: block; font-size: 0.78rem; font-weight: 500; letter-spacing: 0.07em; text-transform: uppercase; color: #6b5a4a; margin-bottom: 0.4rem; }
    .form-group select {
      width: 100%; padding: 0.65rem 0.9rem;
      border: 1.5px solid #e0d4c0; border-radius: 7px;
      font-family: 'DM Sans', sans-serif; font-size: 0.9rem; color: var(--ink);
      background: var(--cream); outline: none; transition: border-color 0.2s;
    }
    .form-group select:focus { border-color: var(--amber); box-shadow: 0 0 0 3px rgba(200,135,58,0.12); }

    /* PLATS GRID */
    .plats-section-label { font-size: 0.78rem; font-weight: 500; letter-spacing: 0.07em; text-transform: uppercase; color: #6b5a4a; margin-bottom: 0.8rem; }
    .plats-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 0.75rem; margin-bottom: 1.5rem; }
    .plat-card {
      border: 1.5px solid #e8dcc8; border-radius: 9px; padding: 0.9rem;
      cursor: pointer; transition: all 0.2s; background: var(--cream); position: relative;
    }
    .plat-card:has(input:checked) { border-color: var(--amber); background: #fff9f0; box-shadow: 0 2px 10px rgba(200,135,58,0.15); }
    .plat-card input[type="checkbox"] { position: absolute; top: 0.7rem; right: 0.7rem; width: 16px; height: 16px; accent-color: var(--amber); }
    .plat-card-name { font-weight: 500; font-size: 0.9rem; margin-bottom: 0.2rem; padding-right: 1.5rem; }
    .plat-card-cat { font-size: 0.72rem; color: #9a8878; margin-bottom: 0.5rem; }
    .plat-card-price { font-family: 'Playfair Display', serif; color: var(--amber); font-size: 0.95rem; }
    .plat-qty { margin-top: 0.6rem; display: none; }
    .plat-card:has(input:checked) .plat-qty { display: flex; align-items: center; gap: 0.4rem; }
    .plat-qty input { width: 60px; padding: 0.3rem 0.5rem; border: 1px solid #e0d4c0; border-radius: 5px; font-family: 'DM Sans', sans-serif; font-size: 0.85rem; text-align: center; outline: none; }
    .plat-qty label { font-size: 0.78rem; color: #7a6a5a; }

    .no-tables-msg { background: #fff3e0; color: #8a4a00; padding: 1rem 1.2rem; border-radius: 8px; font-size: 0.88rem; display: flex; align-items: center; gap: 0.5rem; border: 1px solid #ffcc80; }

    .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.65rem 1.4rem; border-radius: 7px; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.88rem; font-weight: 500; text-decoration: none; transition: all 0.2s; }
    .btn-amber { background: var(--amber); color: #fff; }
    .btn-amber:hover { background: #b07530; box-shadow: 0 4px 14px rgba(200,135,58,0.3); }
    .btn-outline { background: transparent; color: var(--amber); border: 1.5px solid var(--amber); }
    .btn-outline:hover { background: #fdf3e7; }
    .btn-sm { padding: 0.35rem 0.8rem; font-size: 0.8rem; border-radius: 6px; }
    .btn-success { background: #3a8a5a; color: #fff; }
    .btn-success:hover { background: #2d7048; }
    .btn-secondary { background: #f0e8da; color: var(--ink); }
    .btn-secondary:hover { background: #e0d4c0; }

    /* ── ORDER CARDS ── */
    .orders-section-title { font-family: 'Playfair Display', serif; font-size: 1.2rem; margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; }
    .order-card {
      background: #fff; border-radius: 12px; border: 1px solid #e8dcc8;
      box-shadow: 0 2px 10px rgba(26,15,10,0.05); margin-bottom: 1.2rem;
      overflow: hidden; transition: box-shadow 0.2s;
    }
    .order-card:hover { box-shadow: 0 6px 24px rgba(26,15,10,0.1); }
    .order-card-header {
      padding: 1rem 1.5rem; display: flex; align-items: center;
      justify-content: space-between; flex-wrap: wrap; gap: 0.5rem;
      border-bottom: 1px solid #f5f0e8;
    }
    .order-id { font-family: 'Playfair Display', serif; font-size: 1rem; }
    .order-meta { font-size: 0.8rem; color: #8a7060; display: flex; align-items: center; gap: 1rem; flex-wrap: wrap; }
    .order-meta span { display: flex; align-items: center; gap: 0.3rem; }

    .status-badge { display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.25rem 0.75rem; border-radius: 99px; font-size: 0.75rem; font-weight: 600; }
    .status-EN_COURS { background: #fff3cd; color: #856404; }
    .status-SERVIE   { background: #d1e7dd; color: #0f5132; }
    .status-ANNULEE  { background: #f8d7da; color: #842029; }

    .order-body { padding: 1.2rem 1.5rem; }
    .items-table { width: 100%; border-collapse: collapse; margin-bottom: 1rem; font-size: 0.88rem; }
    .items-table th { text-align: left; padding: 0.4rem 0.7rem; color: #8a7060; font-size: 0.75rem; letter-spacing: 0.07em; text-transform: uppercase; border-bottom: 1px solid #f0e8d8; }
    .items-table td { padding: 0.55rem 0.7rem; border-bottom: 1px solid #f8f5f0; }
    .items-table tr:last-child td { border-bottom: none; }

    .order-footer { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem; padding-top: 0.8rem; border-top: 1px dashed #e8dcc8; }
    .total-line { font-family: 'Playfair Display', serif; font-size: 1.05rem; }
    .total-line span { color: var(--amber); font-size: 1.2rem; }
    .order-actions { display: flex; align-items: center; gap: 0.6rem; flex-wrap: wrap; }
    .status-form { display: flex; align-items: center; gap: 0.4rem; }
    .status-select { padding: 0.35rem 0.7rem; border: 1.5px solid #e0d4c0; border-radius: 6px; font-family: 'DM Sans', sans-serif; font-size: 0.82rem; color: var(--ink); background: var(--cream); outline: none; }

    .empty-orders { text-align: center; padding: 3rem; color: #9a8878; }
    .empty-orders i { font-size: 3rem; color: #d0c4b0; margin-bottom: 0.7rem; display: block; }

    @media (max-width: 700px) {
      .form-row { grid-template-columns: 1fr; }
      .plats-grid { grid-template-columns: 1fr 1fr; }
    }
  </style>
</head>
<body>

<nav>
  <a href="index.jsp" class="nav-brand"><i class="bi bi-flower1"></i> Le Jardin</a>
  <div class="nav-links">
    <a href="tables"><i class="bi bi-grid-3x3-gap"></i> Tables</a>
    <a href="menu"><i class="bi bi-journal-richtext"></i> Menu</a>
    <a href="commande" class="active"><i class="bi bi-bag-check"></i> Commandes</a>
  </div>
</nav>

<div class="page-header">
  <div>
    <div class="breadcrumb"><a href="index.jsp">Accueil</a> / Commandes</div>
    <h1><i class="bi bi-bag-check-fill"></i> Gestion des Commandes</h1>
  </div>
  <div class="header-stats">
    <div class="hstat">
      <span class="hstat-num"><%= commandes != null ? commandes.size() : 0 %></span>
      <span class="hstat-lbl">Commandes</span>
    </div>
    <div class="hstat">
      <span class="hstat-num"><%= tablesLibres %></span>
      <span class="hstat-lbl">Tables libres</span>
    </div>
  </div>
</div>

<div class="container">

  <!-- NEW ORDER -->
  <div class="new-order-panel">
    <div class="panel-header-amber">
      <i class="bi bi-plus-circle-fill"></i>
      <h2>Nouvelle Commande</h2>
    </div>
    <div class="panel-body">
      <% if (tablesLibres == 0) { %>
        <div class="no-tables-msg">
          <i class="bi bi-exclamation-triangle-fill"></i>
          Aucune table libre disponible. Libérez une table avant de créer une commande.
        </div>
      <% } else { %>
      <form method="post" action="commande" onsubmit="return validateOrder(this)">
        <input type="hidden" name="action" value="creer">
        <div class="form-row">
          <div class="form-group">
            <label>Table *</label>
            <select name="tableId" required>
              <option value="">— Sélectionner une table —</option>
              <% if (tables != null) for (TableRestaurant t : tables) {
                   if ("LIBRE".equals(t.getStatut())) { %>
                <option value="<%= t.getId() %>">Table <%= t.getNumero() %> (<%= t.getCapacite() %> pers.)</option>
              <% }} %>
            </select>
          </div>
        </div>

        <div class="plats-section-label">Sélectionner les plats *</div>
        <div class="plats-grid">
          <% if (plats != null) for (Plat p : plats) { %>
          <div class="plat-card" onclick="toggleCard(this)">
            <input type="checkbox" name="platId" value="<%= p.getId() %>" onclick="event.stopPropagation()">
            <div class="plat-card-name"><%= p.getNom() %></div>
            <div class="plat-card-cat"><%= p.getCategorie() %></div>
            <div class="plat-card-price"><%= String.format("%.2f", p.getPrix()) %> MAD</div>
            <div class="plat-qty">
              <label>Qté :</label>
              <input type="number" name="quantite" value="1" min="1" max="99" onclick="event.stopPropagation()">
            </div>
          </div>
          <% } %>
        </div>

        <button type="submit" class="btn btn-amber">
          <i class="bi bi-bag-plus"></i> Créer la commande
        </button>
      </form>
      <% } %>
    </div>
  </div>

  <!-- ORDERS LIST -->
  <h2 class="orders-section-title"><i class="bi bi-list-check" style="color:var(--amber)"></i> Commandes en cours</h2>

  <% if (commandes == null || commandes.isEmpty()) { %>
  <div class="empty-orders">
    <i class="bi bi-bag-x"></i>
    <p>Aucune commande pour le moment.</p>
  </div>
  <% } else { for (Commande c : commandes) { %>
  <div class="order-card">
    <div class="order-card-header">
      <div>
        <div class="order-id">Commande #<%= c.getId() %></div>
        <div class="order-meta">
          <span><i class="bi bi-grid-3x3-gap"></i> Table <%= c.getTableId() %></span>
          <span><i class="bi bi-clock"></i> <%= c.getDateHeure() %></span>
        </div>
      </div>
      <span class="status-badge status-<%= c.getStatut() %>"><%= c.getStatut().replace("_", " ") %></span>
    </div>
    <div class="order-body">
      <table class="items-table">
        <thead><tr><th>Plat</th><th>Qté</th><th>P.U.</th><th>Sous-total</th></tr></thead>
        <tbody>
          <% for (LigneCommande l : c.getLignes()) { %>
          <tr>
            <td><%= l.getPlatNom() %></td>
            <td><%= l.getQuantite() %></td>
            <td><%= String.format("%.2f", l.getPrixUnitaire()) %> MAD</td>
            <td><strong><%= String.format("%.2f", l.getSousTotal()) %> MAD</strong></td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <div class="order-footer">
        <div class="total-line">Total : <span><%= String.format("%.2f", c.getTotal()) %> MAD</span></div>
        <div class="order-actions">
          <form method="post" action="commande" class="status-form">
            <input type="hidden" name="action" value="statut">
            <input type="hidden" name="id" value="<%= c.getId() %>">
            <select name="statut" class="status-select">
              <option value="EN_COURS" <%= "EN_COURS".equals(c.getStatut()) ? "selected" : "" %>>En cours</option>
              <option value="SERVIE"   <%= "SERVIE".equals(c.getStatut())   ? "selected" : "" %>>Servie</option>
              <option value="ANNULEE"  <%= "ANNULEE".equals(c.getStatut())  ? "selected" : "" %>>Annulée</option>
            </select>
            <button type="submit" class="btn btn-outline btn-sm">
              <i class="bi bi-arrow-repeat"></i> Mettre à jour
            </button>
          </form>
          <a href="facture?commandeId=<%= c.getId() %>" class="btn btn-success btn-sm">
            <i class="bi bi-receipt"></i> Facture
          </a>
        </div>
      </div>
    </div>
  </div>
  <% } } %>

</div>

<script>
function toggleCard(card) {
  const cb = card.querySelector('input[type="checkbox"]');
  cb.checked = !cb.checked;
}
function validateOrder(form) {
  const checked = form.querySelectorAll('input[name="platId"]:checked');
  if (checked.length === 0) { alert('Veuillez sélectionner au moins un plat.'); return false; }
  if (!form.tableId.value) { alert('Veuillez sélectionner une table.'); return false; }
  return true;
}
</script>
</body>
</html>
