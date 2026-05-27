<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.restaurant.model.*" %>
<%
  List<Commande> commandes = (List<Commande>) request.getAttribute("commandes");
  List<TableRestaurant> tables = (List<TableRestaurant>) request.getAttribute("tables");
  List<Plat> plats = (List<Plat>) request.getAttribute("plats");
  int tablesLibres = 0;
  if (tables != null) for (TableRestaurant t : tables)
    if ("LIBRE".equals(t.getStatut())) tablesLibres++;
  int nbCommandes = commandes != null ? commandes.size() : 0;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Le Jardin — Commandes</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,700;1,400;1,500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <style>
    :root {
      --bg: #fdf6f8;
      --card: #fffafc;
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
    }

    * { margin:0; padding:0; box-sizing:border-box; }

    body {
      min-height: 100vh;
      font-family: 'Lato', sans-serif;
      color: var(--text);
      overflow-x: hidden;
      background-color: var(--bg);
      background-image:
        radial-gradient(ellipse 900px 600px at 10% 0%, rgba(232,160,180,0.22) 0%, transparent 60%),
        radial-gradient(ellipse 700px 500px at 95% 15%, rgba(249,208,220,0.28) 0%, transparent 55%),
        radial-gradient(ellipse 600px 800px at 80% 100%, rgba(201,169,110,0.12) 0%, transparent 50%),
        radial-gradient(ellipse 500px 500px at 5% 90%, rgba(247,207,216,0.2) 0%, transparent 50%);
      position: relative;
    }

    body::before {
      content: '';
      position: fixed;
      inset: 0;
      pointer-events: none;
      z-index: 0;
      background-image:
        radial-gradient(circle 2px at 12% 18%, rgba(181,71,106,0.35) 100%, transparent),
        radial-gradient(circle 3px at 88% 12%, rgba(201,169,110,0.45) 100%, transparent),
        radial-gradient(circle 2px at 55% 6%, rgba(181,71,106,0.28) 100%, transparent),
        radial-gradient(circle 3px at 25% 92%, rgba(201,169,110,0.35) 100%, transparent),
        radial-gradient(circle 2px at 75% 88%, rgba(181,71,106,0.28) 100%, transparent);
    }

    /* ======= NAV ======= */
    nav {
      position: sticky; top: 0; z-index: 1000; height: 76px; padding: 0 60px;
      display: flex; justify-content: space-between; align-items: center;
      background: rgba(110,31,54,0.93);
      backdrop-filter: blur(20px);
      border-bottom: 1px solid rgba(249,208,220,0.18);
      box-shadow: 0 4px 24px rgba(110,31,54,0.22), 0 1px 0 rgba(255,255,255,0.06) inset;
      position: relative;
    }

    nav::after {
      content: '';
      position: absolute;
      bottom: 0; left: 50%; transform: translateX(-50%);
      width: 300px; height: 1px;
      background: linear-gradient(to right, transparent, rgba(201,169,110,0.5), transparent);
    }

    .logo {
      display: flex; align-items: center; gap: 12px;
      color: var(--gold-light); text-decoration: none;
      font-family: 'Playfair Display', serif; font-size: 1.85rem;
      letter-spacing: 2px; font-weight: 500;
      text-shadow: 0 2px 12px rgba(201,169,110,0.3);
    }

    .logo i {
      font-size: 1.6rem; color: var(--rose);
      filter: drop-shadow(0 0 6px rgba(232,160,180,0.5));
      animation: petalSway 4s ease-in-out infinite;
    }

    @keyframes petalSway {
      0%,100% { transform: rotate(-5deg) scale(1); }
      50% { transform: rotate(5deg) scale(1.08); }
    }

    .nav-links { display: flex; gap: 8px; }
    .nav-links a {
      color: rgba(255,255,255,0.65); text-decoration: none;
      padding: 10px 20px; border-radius: 50px;
      font-size: 0.72rem; text-transform: uppercase; letter-spacing: 3px; font-weight: 700;
      transition: all 0.35s ease; border: 1px solid transparent;
    }
    .nav-links a:hover, .nav-links a.active {
      color: var(--gold-light);
      background: rgba(201,169,110,0.1);
      border-color: rgba(201,169,110,0.25);
      transform: translateY(-2px);
    }

    /* ======= HERO ======= */
    .hero {
      position: relative; z-index: 1;
      text-align: center; padding: 80px 20px 50px; overflow: hidden;
    }

    /* Pétales décoratifs — purement visuel, aucun impact fonctionnel */
    .hero-petals {
      position: absolute; inset: 0; pointer-events: none; z-index: 0;
      overflow: hidden;
    }

    .petal {
      position: absolute;
      font-size: 1.4rem;
      opacity: 0;
      animation: petalFall linear infinite;
      user-select: none;
    }

    .petal:nth-child(1)  { left:8%;   font-size:1rem;   animation-duration:8s;  animation-delay:0s;   }
    .petal:nth-child(2)  { left:18%;  font-size:1.6rem; animation-duration:10s; animation-delay:1.5s; }
    .petal:nth-child(3)  { left:30%;  font-size:0.9rem; animation-duration:7s;  animation-delay:3s;   }
    .petal:nth-child(4)  { left:45%;  font-size:1.2rem; animation-duration:9s;  animation-delay:0.8s; }
    .petal:nth-child(5)  { left:58%;  font-size:1.5rem; animation-duration:11s; animation-delay:2s;   }
    .petal:nth-child(6)  { left:70%;  font-size:1rem;   animation-duration:8s;  animation-delay:4s;   }
    .petal:nth-child(7)  { left:82%;  font-size:1.3rem; animation-duration:9s;  animation-delay:1s;   }
    .petal:nth-child(8)  { left:92%;  font-size:0.85rem;animation-duration:6s;  animation-delay:2.5s; }

    @keyframes petalFall {
      0%   { opacity:0; transform: translateY(-30px) rotate(0deg) scale(0.8); }
      10%  { opacity: 0.6; }
      80%  { opacity: 0.4; }
      100% { opacity:0; transform: translateY(260px) rotate(360deg) scale(1.1); }
    }

    .hero::before {
      content: 'COMMANDES';
      position: absolute; top: 20px; left: 50%; transform: translateX(-50%);
      font-size: 7rem; font-family: 'Playfair Display', serif;
      color: rgba(181,71,106,0.04); letter-spacing: 16px;
      white-space: nowrap; pointer-events: none; font-style: italic;
    }

    .hero h1 {
      position: relative; z-index: 1;
      font-family: 'Playfair Display', serif; font-size: 4rem;
      font-weight: 400; color: var(--primary-dark); line-height: 1;
      animation: roseReveal 1s cubic-bezier(.22,1,.36,1);
    }

    .hero h1 span {
      display: block; font-style: italic; font-weight: 400;
      color: var(--primary); margin-top: 8px; font-size: 2.6rem;
    }

    .hero p {
      position: relative; z-index: 1;
      margin-top: 22px; letter-spacing: 8px; text-transform: uppercase;
      font-size: 0.68rem; color: var(--muted); font-weight: 700;
    }

    .divider {
      width: 260px; margin: 24px auto;
      display: flex; align-items: center; justify-content: center; gap: 14px;
      position: relative; z-index: 1;
    }
    .divider::before, .divider::after {
      content: ''; flex: 1; height: 1px;
    }
    .divider::before { background: linear-gradient(to right, transparent, var(--gold)); }
    .divider::after  { background: linear-gradient(to left, transparent, var(--gold)); }

    /* ======= STATS ======= */
    .stats-wrapper {
      position: relative; z-index: 1;
      width: min(1200px,92%); margin: auto;
      display: grid; grid-template-columns: repeat(4,1fr); gap: 20px;
    }

    .mini-stat {
      background: rgba(255,255,255,0.72);
      backdrop-filter: blur(16px);
      border: 1px solid rgba(255,255,255,0.9);
      border-radius: 22px; padding: 26px 28px;
      box-shadow: 0 2px 0 rgba(255,255,255,0.9) inset, 0 8px 28px rgba(110,31,54,0.09);
      animation: roseReveal 0.8s cubic-bezier(.22,1,.36,1) both;
      transition: transform 0.3s ease;
      position: relative; overflow: hidden;
    }
    .mini-stat:hover { transform: translateY(-5px); }
    .mini-stat::before {
      content: ''; position: absolute; top: -40px; right: -40px;
      width: 100px; height: 100px;
      background: radial-gradient(circle, rgba(232,160,180,0.2) 0%, transparent 70%);
      pointer-events: none;
    }
    .mini-stat .top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
    .mini-stat i { font-size: 1.3rem; color: var(--primary); background: var(--rose-light); padding: 8px; border-radius: 12px; }
    .mini-stat h3 { font-size: 2.1rem; font-family: 'Playfair Display', serif; color: var(--primary-dark); font-weight: 500; }
    .mini-stat p { color: var(--muted); font-size: 0.72rem; letter-spacing: 2.5px; text-transform: uppercase; font-weight: 700; }

    /* ======= LAYOUT ======= */
    .content {
      position: relative; z-index: 1;
      width: min(1200px,92%); margin: 50px auto 100px;
      display: grid; grid-template-columns: 1fr 1.6fr; gap: 30px; align-items: start;
    }

    /* ======= CARD ======= */
    .card {
      position: relative; overflow: hidden; border-radius: 32px;
      background: rgba(255,255,255,0.78);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255,255,255,0.95);
      box-shadow: 0 2px 0 rgba(255,255,255,0.9) inset, 0 12px 40px rgba(110,31,54,0.1), 0 24px 60px rgba(110,31,54,0.07);
      animation: roseReveal 0.9s cubic-bezier(.22,1,.36,1) both;
    }

    .card::before {
      content: ''; position: absolute; bottom: -50px; right: -50px;
      width: 180px; height: 180px;
      background: radial-gradient(circle, rgba(232,160,180,0.15) 0%, transparent 65%);
      pointer-events: none;
    }

    .card::after {
      content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
      background: linear-gradient(to right, var(--peach), var(--rose), var(--gold));
      border-radius: 32px 32px 0 0; opacity: 0.7;
    }

    .card-header { padding: 34px 34px 20px; }

    .icon-box {
      width: 62px; height: 62px; border-radius: 20px;
      background: linear-gradient(145deg, var(--primary), var(--primary-dark));
      display: flex; justify-content: center; align-items: center;
      margin-bottom: 18px;
      box-shadow: 0 12px 28px rgba(110,31,54,0.3), 0 2px 0 rgba(255,255,255,0.15) inset;
      position: relative;
    }
    .icon-box::after {
      content: ''; position: absolute; inset: -6px;
      border-radius: 26px; border: 1px solid rgba(181,71,106,0.18);
    }
    .icon-box i { font-size: 1.5rem; color: white; }

    .card-title { font-family: 'Playfair Display', serif; font-size: 1.8rem; color: var(--primary-dark); font-weight: 500; }
    .card-subtitle { margin-top: 6px; font-size: 0.68rem; text-transform: uppercase; letter-spacing: 3px; color: var(--primary); font-weight: 700; }
    .card-body { padding: 0 34px 34px; }

    /* ======= FORM ======= */
    .form-group { margin-bottom: 18px; }
    .form-group label { display: block; font-size: 0.72rem; text-transform: uppercase; letter-spacing: 2px; color: var(--muted); margin-bottom: 8px; font-weight: 700; }
    .form-group select {
      width: 100%; padding: 12px 16px;
      border: 1px solid var(--border); border-radius: 50px;
      background: rgba(255,255,255,0.8);
      font-family: 'Lato', sans-serif; font-size: 0.9rem; color: var(--text);
      outline: none; transition: 0.3s ease;
    }
    .form-group select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(181,71,106,0.1); }

    .plats-label { font-size: 0.72rem; text-transform: uppercase; letter-spacing: 2px; color: var(--muted); margin-bottom: 12px; font-weight: 700; }

    .plats-grid {
      display: grid; grid-template-columns: 1fr 1fr; gap: 10px;
      margin-bottom: 20px; max-height: 320px; overflow-y: auto; padding-right: 4px;
    }
    .plats-grid::-webkit-scrollbar { width: 4px; }
    .plats-grid::-webkit-scrollbar-track { background: transparent; }
    .plats-grid::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

    .plat-card {
      border: 1.5px solid var(--border); border-radius: 16px; padding: 12px;
      cursor: pointer; transition: 0.25s ease;
      background: linear-gradient(145deg, rgba(253,232,239,0.4), rgba(255,255,255,0.6));
      position: relative;
    }
    .plat-card:has(input:checked) {
      border-color: var(--primary);
      background: linear-gradient(145deg, rgba(253,232,239,0.8), rgba(255,255,255,0.7));
      box-shadow: 0 6px 18px rgba(181,71,106,0.12);
    }
    .plat-card input[type="checkbox"] { position: absolute; top: 10px; right: 10px; accent-color: var(--primary); }
    .plat-name { font-size: 0.85rem; font-weight: 700; margin-bottom: 2px; padding-right: 18px; }
    .plat-cat  { font-size: 0.68rem; color: var(--muted); margin-bottom: 4px; }
    .plat-price { font-family: 'Playfair Display', serif; color: var(--primary); font-size: 0.95rem; }
    .plat-qty { margin-top: 8px; display: none; align-items: center; gap: 6px; }
    .plat-card:has(input:checked) .plat-qty { display: flex; }
    .plat-qty input { width: 55px; padding: 4px 8px; border: 1px solid var(--border); border-radius: 8px; font-family: 'Lato', sans-serif; font-size: 0.82rem; text-align: center; outline: none; }
    .plat-qty label { font-size: 0.72rem; color: var(--muted); }

    .no-tables {
      background: rgba(201,169,110,0.12); border: 1px solid rgba(201,169,110,0.3);
      border-radius: 16px; padding: 16px; font-size: 0.85rem; color: var(--primary-dark);
      display: flex; align-items: center; gap: 8px;
    }

    /* ======= BUTTONS ======= */
    .btn-premium {
      position: relative; overflow: hidden; width: 100%; border: none;
      border-radius: 50px; padding: 16px; cursor: pointer; text-decoration: none;
      display: flex; justify-content: center; align-items: center; gap: 10px;
      background: linear-gradient(135deg, var(--primary), var(--primary-dark));
      color: white; letter-spacing: 3px; text-transform: uppercase; font-size: 0.68rem;
      font-weight: 700; transition: all 0.4s ease;
      box-shadow: 0 14px 30px rgba(110,31,54,0.25), 0 2px 0 rgba(255,255,255,0.15) inset;
      font-family: 'Lato', sans-serif;
    }
    .btn-premium::before {
      content: ''; position: absolute; top: 0; left: -100%; width: 60%; height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25), transparent);
      transform: skewX(-20deg); transition: 0.7s ease;
    }
    .btn-premium:hover::before { left: 140%; }
    .btn-premium:hover { transform: translateY(-3px); box-shadow: 0 20px 40px rgba(110,31,54,0.3); }

    /* ======= ORDERS ======= */
    .orders-title {
      font-family: 'Playfair Display', serif; font-size: 1.9rem;
      color: var(--primary-dark); margin-bottom: 22px;
      display: flex; align-items: center; gap: 12px;
    }
    .orders-title::after {
      content: ''; flex: 1; height: 1px;
      background: linear-gradient(to right, var(--border), transparent);
    }

    .order-card {
      position: relative; overflow: hidden; border-radius: 26px;
      background: rgba(255,255,255,0.78);
      backdrop-filter: blur(16px);
      border: 1px solid rgba(255,255,255,0.95);
      box-shadow: 0 4px 20px rgba(110,31,54,0.08); margin-bottom: 20px;
      transition: 0.35s cubic-bezier(.22,1,.36,1);
      animation: roseReveal 0.9s cubic-bezier(.22,1,.36,1) both;
    }
    .order-card:hover { transform: translateY(-5px); box-shadow: 0 16px 40px rgba(110,31,54,0.14); }
    .order-card::after {
      content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
      background: linear-gradient(to right, var(--peach), var(--rose), var(--gold));
      opacity: 0.6;
    }

    .order-head {
      padding: 20px 24px; display: flex; align-items: center; justify-content: space-between;
      border-bottom: 1px solid var(--border);
    }
    .order-id { font-family: 'Playfair Display', serif; font-size: 1.3rem; color: var(--primary-dark); font-weight: 500; }
    .order-meta { font-size: 0.75rem; color: var(--muted); display: flex; gap: 14px; margin-top: 4px; }

    .status-badge {
      padding: 5px 16px; border-radius: 99px; font-size: 0.68rem;
      font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;
    }
    .status-EN_COURS { background: rgba(201,169,110,0.2); color: #7a5a20; }
    .status-SERVIE   { background: rgba(60,140,90,0.15);  color: #1a5a30; }
    .status-ANNULEE  { background: rgba(180,60,60,0.12);  color: #7a2020; }

    .order-body { padding: 16px 24px; }

    .items-table { width: 100%; border-collapse: collapse; font-size: 0.83rem; margin-bottom: 14px; }
    .items-table th { text-align: left; padding: 6px 0; font-size: 0.68rem; letter-spacing: 2px; text-transform: uppercase; color: var(--muted); border-bottom: 1px solid var(--border); font-weight: 700; }
    .items-table td { padding: 9px 0; border-bottom: 1px solid rgba(181,71,106,0.06); }
    .items-table tr:last-child td { border-bottom: none; }

    .order-footer {
      display: flex; align-items: center; justify-content: space-between;
      flex-wrap: wrap; gap: 12px; padding-top: 14px; border-top: 1px solid var(--border);
    }
    .total-line { font-family: 'Playfair Display', serif; font-size: 1.1rem; color: var(--primary-dark); }
    .total-line span { color: var(--primary); font-size: 1.3rem; }

    .order-actions { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
    .status-form { display: flex; align-items: center; gap: 6px; }
    .status-select {
      padding: 7px 14px; border: 1px solid var(--border); border-radius: 50px;
      font-family: 'Lato', sans-serif; font-size: 0.78rem; color: var(--text);
      background: rgba(255,255,255,0.8); outline: none;
    }
    .btn-sm {
      padding: 7px 16px; border-radius: 50px; border: 1px solid var(--primary);
      background: transparent; color: var(--primary);
      font-family: 'Lato', sans-serif; font-size: 0.72rem; letter-spacing: 1px;
      text-transform: uppercase; cursor: pointer; transition: 0.25s ease;
      text-decoration: none; display: inline-flex; align-items: center; gap: 5px;
      font-weight: 700;
    }
    .btn-sm:hover { background: var(--primary); color: white; transform: translateY(-2px); }
    .btn-facture { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none; box-shadow: 0 6px 16px rgba(110,31,54,0.2); }
    .btn-facture:hover { opacity: 0.9; color: white; }

    .empty-orders { text-align: center; padding: 50px 20px; color: var(--muted); }
    .empty-orders i { font-size: 3rem; color: var(--border); display: block; margin-bottom: 12px; }

    /* ======= FOOTER ======= */
    footer {
      position: relative; z-index: 1;
      background: linear-gradient(180deg, rgba(110,31,54,0.96) 0%, rgba(70,15,32,0.98) 100%);
      backdrop-filter: blur(12px); text-align: center; padding: 70px 20px 45px; color: white; overflow: hidden;
    }
    footer::before {
      content: ''; position: absolute; top: 0; left: 50%; transform: translateX(-50%);
      width: 500px; height: 1px;
      background: linear-gradient(to right, transparent, rgba(201,169,110,0.5), transparent);
    }
    .footer-title { font-family: 'Playfair Display', serif; font-size: 2.2rem; color: var(--gold-light); font-style: italic; position: relative; z-index: 1; }
    .footer-sub { margin-top: 12px; color: rgba(255,255,255,0.45); letter-spacing: 5px; text-transform: uppercase; font-size: 0.68rem; font-weight: 700; }
    .socials { display: flex; justify-content: center; gap: 14px; margin-top: 32px; position: relative; z-index: 1; }
    .socials a { width: 50px; height: 50px; border-radius: 50%; display: flex; justify-content: center; align-items: center; text-decoration: none; color: var(--rose); border: 1px solid rgba(232,160,180,0.2); background: rgba(255,255,255,0.04); transition: all 0.35s ease; font-size: 1.1rem; }
    .socials a:hover { background: rgba(232,160,180,0.12); border-color: rgba(232,160,180,0.4); color: var(--gold-light); transform: translateY(-6px) scale(1.08); }
    .copyright { margin-top: 35px; color: rgba(255,255,255,0.25); font-size: 0.72rem; letter-spacing: 2.5px; }

    /* ======= ANIMATIONS ======= */
    @keyframes roseReveal {
      from { opacity:0; transform:translateY(36px); filter:blur(8px); }
      to   { opacity:1; transform:translateY(0);    filter:blur(0);   }
    }

    .mini-stat:nth-child(1) { animation-delay: 0.05s; }
    .mini-stat:nth-child(2) { animation-delay: 0.15s; }
    .mini-stat:nth-child(3) { animation-delay: 0.25s; }
    .mini-stat:nth-child(4) { animation-delay: 0.35s; }

    /* ======= RESPONSIVE ======= */
    @media (max-width:900px) {
      .content { grid-template-columns: 1fr; }
      .stats-wrapper { grid-template-columns: repeat(2,1fr); }
      nav { padding: 0 20px; }
      .nav-links { display: none; }
      .hero h1 { font-size: 2.8rem; }
      .hero h1 span { font-size: 1.8rem; }
    }
  </style>
</head>
<body>

<nav>
  <a href="index.jsp" class="logo"><i class="bi bi-flower1"></i> Le Jardin</a>
  <div class="nav-links">
    <a href="tables">Tables</a>
    <a href="menu">Menu</a>
    <a href="commande" class="active">Commandes</a>
  </div>
</nav>

<section class="hero">

  <!-- Pétales tombants — décoration pure, aucun impact servlet -->
  <div class="hero-petals" aria-hidden="true">
    <span class="petal">🌸</span>
    <span class="petal">🌷</span>
    <span class="petal">🌸</span>
    <span class="petal">🌹</span>
    <span class="petal">🌸</span>
    <span class="petal">🌷</span>
    <span class="petal">🌸</span>
    <span class="petal">🌹</span>
  </div>

  <h1>Commandes <span>Gestion des commandes</span></h1>
  <p>Suivi en temps réel</p>
  <div class="divider"></div>
</section>

<section class="stats-wrapper">
  <div class="mini-stat">
    <div class="top"><p>Commandes</p><i class="bi bi-receipt"></i></div>
    <h3><%= nbCommandes %></h3>
  </div>
  <div class="mini-stat">
    <div class="top"><p>Tables libres</p><i class="bi bi-grid-3x3-gap"></i></div>
    <h3><%= tablesLibres %></h3>
  </div>
  <div class="mini-stat">
    <div class="top"><p>Plats</p><i class="bi bi-journal-richtext"></i></div>
    <h3><%= plats != null ? plats.size() : 0 %></h3>
  </div>
  <div class="mini-stat">
    <div class="top"><p>Statut</p><i class="bi bi-activity"></i></div>
    <h3>Live</h3>
  </div>
</section>

<section class="content">

  <!-- NOUVELLE COMMANDE -->
  <div class="card">
    <div class="card-header">
      <div class="icon-box"><i class="bi bi-plus-lg"></i></div>
      <div class="card-title">Nouvelle Commande</div>
      <div class="card-subtitle">Créer une commande</div>
    </div>
    <div class="card-body">
      <% if (tablesLibres == 0) { %>
        <div class="no-tables"><i class="bi bi-exclamation-triangle"></i> Aucune table libre disponible.</div>
      <% } else { %>
      <form method="post" action="commande" onsubmit="return validateOrder(this)">
        <input type="hidden" name="action" value="creer">
        <div class="form-group">
          <label>Table</label>
          <select name="tableId" required>
            <option value="">— Sélectionner —</option>
            <% if (tables != null) for (TableRestaurant t : tables) {
                 if ("LIBRE".equals(t.getStatut())) { %>
              <option value="<%= t.getId() %>">Table <%= t.getNumero() %> (<%= t.getCapacite() %> pers.)</option>
            <% }} %>
          </select>
        </div>
        <div class="plats-label">Sélectionner les plats</div>
        <div class="plats-grid">
          <% if (plats != null) for (Plat p : plats) { %>
          <div class="plat-card" onclick="toggleCard(this)">
            <input type="checkbox" name="platId" value="<%= p.getId() %>" onclick="event.stopPropagation()">
            <div class="plat-name"><%= p.getNom() %></div>
            <div class="plat-cat"><%= p.getCategorie() %></div>
            <div class="plat-price"><%= String.format("%.2f", p.getPrix()) %> MAD</div>
            <div class="plat-qty">
              <label>Qté :</label>
              <input type="number" name="quantite" value="1" min="1" max="99" onclick="event.stopPropagation()">
            </div>
          </div>
          <% } %>
        </div>
        <button type="submit" class="btn-premium"><i class="bi bi-bag-plus"></i> Créer la commande</button>
      </form>
      <% } %>
    </div>
  </div>

  <!-- LISTE DES COMMANDES -->
  <div>
    <div class="orders-title">Commandes en cours</div>
    <% if (commandes == null || commandes.isEmpty()) { %>
    <div class="empty-orders"><i class="bi bi-bag-x"></i><p>Aucune commande pour le moment.</p></div>
    <% } else { for (Commande c : commandes) { %>
    <div class="order-card">
      <div class="order-head">
        <div>
          <div class="order-id">Commande #<%= c.getId() %></div>
          <div class="order-meta">
            <span><i class="bi bi-grid-3x3-gap"></i> Table <%= c.getTableId() %></span>
            <span><i class="bi bi-clock"></i> <%= c.getDateHeure() %></span>
          </div>
        </div>
        <span class="status-badge status-<%= c.getStatut() %>"><%= c.getStatut().replace("_"," ") %></span>
      </div>
      <div class="order-body">
        <table class="items-table">
          <thead><tr><th>Plat</th><th>Qté</th><th>P.U.</th><th>Total</th></tr></thead>
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
                <option value="EN_COURS" <%= "EN_COURS".equals(c.getStatut())?"selected":"" %>>En cours</option>
                <option value="SERVIE"   <%= "SERVIE".equals(c.getStatut())?"selected":"" %>>Servie</option>
                <option value="ANNULEE"  <%= "ANNULEE".equals(c.getStatut())?"selected":"" %>>Annulée</option>
              </select>
              <button type="submit" class="btn-sm"><i class="bi bi-arrow-repeat"></i> Mettre à jour</button>
            </form>
            <a href="facture.jsp?commandeId=<%= c.getId() %>" class="btn-sm btn-facture">
              <i class="bi bi-receipt"></i> Facture
            </a>
          </div>
        </div>
      </div>
    </div>
    <% } } %>
  </div>

</section>

<footer>
  <div class="footer-title">Le Jardin</div>
  <div class="footer-sub">Une expérience gastronomique d'exception</div>
  <div class="socials">
    <a href="#"><i class="bi bi-instagram"></i></a>
    <a href="#"><i class="bi bi-facebook"></i></a>
    <a href="#"><i class="bi bi-twitter-x"></i></a>
    <a href="#"><i class="bi bi-whatsapp"></i></a>
  </div>
  <div class="copyright">© 2026 Le Jardin — Tous droits réservés</div>
</footer>

<script>
function toggleCard(card){
  const cb = card.querySelector('input[type="checkbox"]');
  cb.checked = !cb.checked;
}
function validateOrder(form){
  const checked = form.querySelectorAll('input[name="platId"]:checked');
  if(checked.length===0){alert('Veuillez sélectionner au moins un plat.');return false;}
  if(!form.tableId.value){alert('Veuillez sélectionner une table.');return false;}
  return true;
}
</script>
</body>
</html>
