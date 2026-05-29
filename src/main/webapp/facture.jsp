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
      display: flex; flex-direction: column;
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

    /* ======= PÉTALES ======= */
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

    /* ======= PAGE WRAP ======= */
    .page-wrap {
      flex: 1; display: flex; align-items: flex-start;
      justify-content: center; padding: 2.5rem 1.5rem;
      position: relative; z-index: 1;
    }

    /* ======= INVOICE CARD ======= */
    .invoice {
      width: 100%; max-width: 640px;
      background: var(--surface);
      backdrop-filter: blur(16px);
      border-radius: 28px;
      border: 1px solid rgba(255,255,255,0.95);
      box-shadow: 0 2px 0 rgba(255,255,255,0.9) inset, 0 20px 60px rgba(110,31,54,0.14);
      overflow: hidden;
      animation: fadeUp 0.5s ease both;
      position: relative;
    }

    /* Barre colorée en haut */
    .invoice::before {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; height: 3px;
      background: linear-gradient(to right, var(--peach), var(--rose), var(--gold));
      opacity: 0.9; z-index: 2;
    }

    /* ── INVOICE HEADER ── */
    .invoice-header {
      background: linear-gradient(135deg, var(--primary-dark) 0%, #4a1020 100%);
      padding: 2.2rem 2.5rem 2rem;
      position: relative; overflow: hidden;
    }

    /* Cercles décoratifs */
    .invoice-header::after {
      content: '';
      position: absolute; bottom: -40px; left: -40px;
      width: 220px; height: 220px;
      border: 45px solid rgba(232,160,180,0.07);
      border-radius: 50%;
    }
    .invoice-header::before {
      content: '';
      position: absolute; top: -60px; right: -60px;
      width: 200px; height: 200px;
      border: 40px solid rgba(201,169,110,0.08);
      border-radius: 50%;
    }

    .restaurant-name {
      font-family: 'Playfair Display', serif; font-size: 1.9rem;
      color: var(--gold-light); letter-spacing: 2px;
      position: relative; z-index: 1;
      display: flex; align-items: center; gap: 0.7rem;
      text-shadow: 0 2px 12px rgba(201,169,110,0.3);
    }

    .restaurant-name i {
      color: var(--rose);
      filter: drop-shadow(0 0 6px rgba(232,160,180,0.5));
    }

    .restaurant-tagline {
      color: rgba(255,255,255,0.35); font-size: 0.72rem;
      letter-spacing: 3px; text-transform: uppercase;
      position: relative; z-index: 1; margin-top: 0.3rem;
      font-weight: 700;
    }

    .invoice-title-row {
      display: flex; justify-content: space-between; align-items: flex-end;
      margin-top: 1.8rem; position: relative; z-index: 1;
    }

    .invoice-label {
      font-size: 0.68rem; letter-spacing: 3px; text-transform: uppercase;
      color: rgba(255,255,255,0.35); font-weight: 700; margin-bottom: 4px;
    }

    .invoice-num {
      font-family: 'Playfair Display', serif; font-size: 2.2rem;
      color: var(--gold); line-height: 1;
    }

    .invoice-date {
      text-align: right;
    }

    .invoice-date-label {
      font-size: 0.68rem; letter-spacing: 3px; text-transform: uppercase;
      color: rgba(255,255,255,0.35); font-weight: 700; margin-bottom: 4px;
    }

    .invoice-date-value {
      color: rgba(255,255,255,0.7); font-size: 0.88rem;
      display: flex; align-items: center; gap: 0.4rem; justify-content: flex-end;
    }

    /* ── BODY ── */
    .invoice-body { padding: 2rem 2.5rem; }

    /* ── TABLE ITEMS ── */
    .items-table { width: 100%; border-collapse: collapse; }

    .items-table th {
      padding: 0.7rem 0; text-align: left;
      font-size: 0.68rem; font-weight: 700; letter-spacing: 2.5px; text-transform: uppercase;
      color: var(--muted); border-bottom: 1.5px solid var(--border-solid);
    }
    .items-table th:not(:first-child) { text-align: right; }

    .items-table td {
      padding: 0.85rem 0; border-bottom: 1px solid rgba(181,71,106,0.06);
      font-size: 0.9rem; vertical-align: middle;
    }
    .items-table td:not(:first-child) { text-align: right; }
    .items-table tr:last-child td { border-bottom: none; }
    .items-table tr:hover td { background: rgba(253,232,239,0.2); transition: background 0.2s; }

    .item-name { font-weight: 700; color: var(--text); }

    .item-qty {
      display: inline-flex; align-items: center; justify-content: center;
      width: 26px; height: 26px; border-radius: 50%;
      background: var(--rose-light); color: var(--primary);
      font-size: 0.78rem; font-weight: 700;
    }

    .item-price { color: var(--muted); font-size: 0.88rem; }

    .item-total {
      font-family: 'Playfair Display', serif;
      color: var(--primary); font-size: 0.95rem; font-weight: 500;
    }

    /* ── DIVIDER ── */
    .divider {
      height: 1px;
      background: linear-gradient(to right, transparent, var(--border-solid), transparent);
      margin: 1.5rem 0;
    }

    /* ── TOTALS ── */
    .totals { margin-top: 0.5rem; }

    .total-row {
      display: flex; justify-content: space-between; align-items: center;
      padding: 0.55rem 0; font-size: 0.9rem;
    }

    .total-row.subtotal { color: var(--muted); }
    .total-row.subtotal .total-label { font-weight: 400; }

    .total-row.tva {
      color: var(--muted);
      border-bottom: 1px dashed var(--border-solid);
      padding-bottom: 1rem; margin-bottom: 0.3rem;
    }

    /* Grand total — reprend le style panel-header */
    .grand-total-wrap {
      background: linear-gradient(135deg, var(--primary), var(--primary-dark));
      margin: 1.5rem -2.5rem -2rem;
      padding: 1.4rem 2.5rem;
      display: flex; justify-content: space-between; align-items: center;
      position: relative; overflow: hidden;
    }

    .grand-total-wrap::after {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; bottom: 0;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.06), transparent);
      pointer-events: none;
    }

    .grand-total-label {
      font-size: 0.72rem; letter-spacing: 3px; text-transform: uppercase;
      font-weight: 700; color: rgba(255,255,255,0.65);
    }

    .grand-total-amount {
      font-family: 'Playfair Display', serif; font-size: 1.7rem;
      color: var(--gold-light);
      text-shadow: 0 2px 12px rgba(201,169,110,0.3);
    }

    /* ── ACTIONS ── */
    .invoice-actions {
      padding: 1.4rem 2.5rem;
      background: rgba(253,232,239,0.25);
      border-top: 1px solid var(--border-solid);
      display: flex; gap: 0.7rem; justify-content: flex-end; flex-wrap: wrap;
    }

    .btn {
      display: inline-flex; align-items: center; gap: 0.45rem;
      padding: 0.65rem 1.4rem; border-radius: 50px; border: none;
      cursor: pointer; font-family: 'Lato', sans-serif;
      font-size: 0.82rem; font-weight: 700; text-decoration: none;
      transition: all 0.3s ease; letter-spacing: 0.5px;
    }

    .btn-print {
      background: linear-gradient(135deg, var(--gold), #a8843a);
      color: #fff;
      box-shadow: 0 8px 22px rgba(180,140,60,0.3), 0 2px 0 rgba(255,255,255,0.12) inset;
    }
    .btn-print:hover { transform: translateY(-2px); box-shadow: 0 14px 30px rgba(180,140,60,0.35); }

    .btn-back {
      background: var(--rose-light); color: var(--primary);
      border: 1px solid rgba(181,71,106,0.2);
    }
    .btn-back:hover { background: var(--peach); transform: translateY(-2px); }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(20px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ======= PRINT ======= */
    @media print {
      nav, .invoice-actions, .petals-container { display: none !important; }
      body { background: #fff; }
      .page-wrap { padding: 0; }
      .invoice {
        box-shadow: none; border: none; border-radius: 0;
        backdrop-filter: none; background: #fff;
      }
      .invoice::before { display: none; }
    }

    /* ======= RESPONSIVE ======= */
    @media (max-width: 700px) {
      nav { padding: 0 1.2rem; }
      .nav-links { display: none; }
      .invoice-header, .invoice-body, .invoice-actions { padding-left: 1.4rem; padding-right: 1.4rem; }
      .grand-total-wrap { margin-left: -1.4rem; margin-right: -1.4rem; padding: 1.2rem 1.4rem; }
    }
  </style>
</head>
<body>

<!-- Pétales tombants -->
<div class="petals-container no-print" aria-hidden="true">
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

<nav class="no-print">
  <a href="index.jsp" class="nav-brand"><i class="bi bi-flower1"></i> Le Jardin</a>
  <div class="nav-links">
    <a href="tables"><i class="bi bi-grid-3x3-gap"></i> Tables</a>
    <a href="menu"><i class="bi bi-journal-richtext"></i> Menu</a>
    <a href="commande" class="active"><i class="bi bi-bag-check"></i> Commandes</a>
  </div>
</nav>

<div class="page-wrap">
  <div class="invoice">

    <!-- HEADER -->
    <div class="invoice-header">
      <div class="restaurant-name"><i class="bi bi-flower1"></i> Le Jardin</div>
      <div class="restaurant-tagline">Système de gestion — Facture officielle</div>
      <div class="invoice-title-row">
        <div>
          <div class="invoice-label">Facture</div>
          <div class="invoice-num">#<%= commandeId %></div>
        </div>
        <div class="invoice-date">
          <div class="invoice-date-label">Date d'émission</div>
          <div class="invoice-date-value"><i class="bi bi-calendar3"></i> <%= dateStr %></div>
        </div>
      </div>
    </div>

    <!-- BODY -->
    <div class="invoice-body">
      <table class="items-table">
        <thead>
          <tr>
            <th>Désignation</th>
            <th>Qté</th>
            <th>P.U.</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          <% for (LigneCommande l : cmd.getLignes()) { %>
          <tr>
            <td class="item-name"><%= l.getPlatNom() %></td>
            <td><span class="item-qty"><%= l.getQuantite() %></span></td>
            <td class="item-price"><%= String.format("%.2f", l.getPrixUnitaire()) %> MAD</td>
            <td class="item-total"><%= String.format("%.2f", l.getSousTotal()) %> MAD</td>
          </tr>
          <% } %>
        </tbody>
      </table>

      <div class="divider"></div>

      <div class="totals">
        <div class="total-row subtotal">
          <span class="total-label">Montant HT</span>
          <span><%= String.format("%.2f", ht) %> MAD</span>
        </div>
        <div class="total-row tva">
          <span class="total-label">TVA (20%)</span>
          <span>+ <%= String.format("%.2f", tva) %> MAD</span>
        </div>
      </div>

      <div class="grand-total-wrap">
        <span class="grand-total-label">Total TTC</span>
        <span class="grand-total-amount"><%= String.format("%.2f", ttc) %> MAD</span>
      </div>
    </div>

    <!-- ACTIONS -->
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
