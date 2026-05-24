<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.restaurant.model.*, com.restaurant.dao.*" %>
<%
  String cmdParam = request.getParameter("commandeId");
  if (cmdParam == null || cmdParam.isEmpty()) {
    response.sendRedirect("commande");
    return;
  }
  int commandeId = Integer.parseInt(cmdParam);
  CommandeDAO cmdDao = new CommandeDAO();
  Commande cmd = new Commande();
  cmd.setId(commandeId);
  cmd.setLignes(cmdDao.getLignes(commandeId));
  double ht  = cmd.getTotal();
  double tva = ht * 0.20;
  double ttc = ht + tva;
  java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
  String dateStr = sdf.format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Facture #<%= commandeId %> — Le Jardin</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    :root {
      --cream: #f5f0e8; --espresso: #1a0f0a; --amber: #c8873a;
      --gold: #e8b86d; --ink: #2d1f14;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: var(--cream); font-family: 'DM Sans', sans-serif; color: var(--ink); min-height: 100vh; display: flex; flex-direction: column; }

    nav { background: var(--espresso); padding: 0 2.5rem; display: flex; align-items: center; justify-content: space-between; height: 68px; box-shadow: 0 2px 20px rgba(0,0,0,0.35); }
    .nav-brand { font-family: 'Playfair Display', serif; font-size: 1.3rem; color: var(--gold); text-decoration: none; display: flex; align-items: center; gap: 0.6rem; }
    .nav-links { display: flex; gap: 0.5rem; }
    .nav-links a { color: #c8b89a; text-decoration: none; padding: 0.4rem 1rem; border-radius: 4px; font-size: 0.85rem; font-weight: 500; letter-spacing: 0.06em; text-transform: uppercase; transition: all 0.2s; }
    .nav-links a:hover { color: var(--gold); background: rgba(200,135,58,0.15); }

    .page-wrap { flex: 1; display: flex; align-items: flex-start; justify-content: center; padding: 2.5rem 1.5rem; }

    .invoice {
      width: 100%; max-width: 620px;
      background: #fff; border-radius: 16px;
      box-shadow: 0 8px 40px rgba(26,15,10,0.12);
      border: 1px solid #e8dcc8; overflow: hidden;
      animation: fadeUp 0.5s ease both;
    }

    /* ── INVOICE HEADER ── */
    .invoice-header {
      background: var(--espresso);
      padding: 2.2rem 2.5rem;
      position: relative;
      overflow: hidden;
    }
    .invoice-header::after {
      content: '';
      position: absolute;
      bottom: -30px; left: -30px;
      width: 200px; height: 200px;
      border: 40px solid rgba(232,184,109,0.08);
      border-radius: 50%;
    }
    .invoice-header::before {
      content: '';
      position: absolute;
      top: -50px; right: -50px;
      width: 180px; height: 180px;
      border: 35px solid rgba(200,135,58,0.07);
      border-radius: 50%;
    }
    .restaurant-name { font-family: 'Playfair Display', serif; font-size: 1.8rem; color: var(--gold); letter-spacing: 0.04em; position: relative; z-index: 1; }
    .restaurant-tagline { color: #8a7060; font-size: 0.8rem; letter-spacing: 0.15em; text-transform: uppercase; position: relative; z-index: 1; margin-top: 0.2rem; }
    .invoice-title-row { display: flex; justify-content: space-between; align-items: flex-end; margin-top: 1.5rem; position: relative; z-index: 1; }
    .invoice-title { font-size: 0.78rem; letter-spacing: 0.2em; text-transform: uppercase; color: #6a5848; }
    .invoice-num { font-family: 'Playfair Display', serif; font-size: 2rem; color: var(--amber); }
    .invoice-date { color: #6a5848; font-size: 0.82rem; }

    /* ── BODY ── */
    .invoice-body { padding: 2rem 2.5rem; }

    .invoice-divider { height: 1px; background: linear-gradient(to right, transparent, #e8dcc8, transparent); margin: 1.5rem 0; }

    .items-table { width: 100%; border-collapse: collapse; }
    .items-table th { text-align: left; padding: 0.6rem 0; font-size: 0.72rem; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: #9a8878; border-bottom: 2px solid #f0e8d8; }
    .items-table th:not(:first-child) { text-align: right; }
    .items-table td { padding: 0.75rem 0; border-bottom: 1px solid #f8f5f0; font-size: 0.9rem; vertical-align: middle; }
    .items-table td:not(:first-child) { text-align: right; }
    .items-table tr:last-child td { border-bottom: none; }
    .item-name { font-weight: 500; }

    /* ── TOTALS ── */
    .totals { margin-top: 1.5rem; }
    .total-row { display: flex; justify-content: space-between; align-items: center; padding: 0.5rem 0; font-size: 0.9rem; }
    .total-row.subtotal { color: #6b5a4a; }
    .total-row.tva { color: #6b5a4a; border-bottom: 1px dashed #e8dcc8; padding-bottom: 1rem; margin-bottom: 0.3rem; }
    .total-row.grand-total {
      background: var(--espresso); margin: 1rem -2.5rem -2rem;
      padding: 1.3rem 2.5rem;
      font-family: 'Playfair Display', serif; font-size: 1.1rem; color: #fff;
    }
    .grand-total .amount { color: var(--gold); font-size: 1.4rem; }

    /* ── ACTIONS ── */
    .invoice-actions { padding: 1.5rem 2.5rem 2rem; background: #faf7f2; display: flex; gap: 0.8rem; justify-content: flex-end; flex-wrap: wrap; border-top: 1px solid #f0e8d8; }

    .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.65rem 1.5rem; border-radius: 7px; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.88rem; font-weight: 500; text-decoration: none; transition: all 0.2s; }
    .btn-print { background: var(--amber); color: #fff; }
    .btn-print:hover { background: #b07530; box-shadow: 0 4px 14px rgba(200,135,58,0.3); }
    .btn-back { background: #f0e8da; color: var(--ink); }
    .btn-back:hover { background: #e0d4c0; }

    @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

    @media print {
      nav, .invoice-actions, .btn { display: none !important; }
      body { background: #fff; }
      .page-wrap { padding: 0; }
      .invoice { box-shadow: none; border: none; border-radius: 0; }
    }
  </style>
</head>
<body>

<nav class="no-print">
  <a href="index.jsp" class="nav-brand"><i class="bi bi-flower1"></i> Le Jardin</a>
  <div class="nav-links">
    <a href="tables"><i class="bi bi-grid-3x3-gap"></i> Tables</a>
    <a href="menu"><i class="bi bi-journal-richtext"></i> Menu</a>
    <a href="commande"><i class="bi bi-bag-check"></i> Commandes</a>
  </div>
</nav>

<div class="page-wrap">
  <div class="invoice">
    <div class="invoice-header">
      <div class="restaurant-name"><i class="bi bi-flower1"></i> Le Jardin</div>
      <div class="restaurant-tagline">Système de gestion — Facture officielle</div>
      <div class="invoice-title-row">
        <div>
          <div class="invoice-title">Facture</div>
          <div class="invoice-num">#<%= commandeId %></div>
        </div>
        <div class="invoice-date">
          <div><i class="bi bi-calendar3"></i> <%= dateStr %></div>
        </div>
      </div>
    </div>

    <div class="invoice-body">
      <table class="items-table">
        <thead>
          <tr><th>Désignation</th><th>Qté</th><th>P.U.</th><th>Total</th></tr>
        </thead>
        <tbody>
          <% for (LigneCommande l : cmd.getLignes()) { %>
          <tr>
            <td class="item-name"><%= l.getPlatNom() %></td>
            <td><%= l.getQuantite() %></td>
            <td><%= String.format("%.2f", l.getPrixUnitaire()) %> MAD</td>
            <td><strong><%= String.format("%.2f", l.getSousTotal()) %> MAD</strong></td>
          </tr>
          <% } %>
        </tbody>
      </table>

      <div class="totals">
        <div class="total-row subtotal">
          <span>Montant HT</span>
          <span><%= String.format("%.2f", ht) %> MAD</span>
        </div>
        <div class="total-row tva">
          <span>TVA (20%)</span>
          <span>+ <%= String.format("%.2f", tva) %> MAD</span>
        </div>
        <div class="total-row grand-total">
          <span>TOTAL TTC</span>
          <span class="amount"><%= String.format("%.2f", ttc) %> MAD</span>
        </div>
      </div>
    </div>

    <div class="invoice-actions no-print">
      <a href="commande" class="btn btn-back"><i class="bi bi-arrow-left"></i> Retour</a>
      <button onclick="window.print()" class="btn btn-print">
        <i class="bi bi-printer"></i> Imprimer
      </button>
    </div>
  </div>
</div>

</body>
</html>
