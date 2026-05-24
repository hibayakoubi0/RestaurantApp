<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Le Jardin — Restaurant Manager</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    :root {
      --cream: #f5f0e8;
      --espresso: #1a0f0a;
      --amber: #c8873a;
      --gold: #e8b86d;
      --sage: #7a8c6e;
      --terracotta: #b85c3a;
      --parchment: #ede5d0;
      --ink: #2d1f14;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background-color: var(--cream);
      font-family: 'DM Sans', sans-serif;
      color: var(--ink);
      min-height: 100vh;
    }

    /* ── NAV ── */
    nav {
      background: var(--espresso);
      padding: 0 2.5rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 68px;
      position: sticky;
      top: 0;
      z-index: 100;
      box-shadow: 0 2px 20px rgba(0,0,0,0.35);
    }
    .nav-brand {
      font-family: 'Playfair Display', serif;
      font-size: 1.4rem;
      color: var(--gold);
      letter-spacing: 0.04em;
      display: flex;
      align-items: center;
      gap: 0.6rem;
      text-decoration: none;
    }
    .nav-brand .dot { color: var(--amber); }
    .nav-links { display: flex; gap: 0.5rem; }
    .nav-links a {
      color: #c8b89a;
      text-decoration: none;
      padding: 0.4rem 1rem;
      border-radius: 4px;
      font-size: 0.88rem;
      font-weight: 500;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      transition: all 0.2s;
    }
    .nav-links a:hover {
      color: var(--gold);
      background: rgba(200,135,58,0.12);
    }

    /* ── HERO ── */
    .hero {
      display: grid;
      place-items: center;
      text-align: center;
      padding: 6rem 2rem 5rem;
      position: relative;
      overflow: hidden;
    }
    .hero::before {
      content: '';
      position: absolute;
      inset: 0;
      background:
        radial-gradient(ellipse 60% 50% at 50% 100%, rgba(200,135,58,0.12) 0%, transparent 70%),
        url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23c8873a' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
      pointer-events: none;
    }
    .hero-eyebrow {
      font-size: 0.78rem;
      letter-spacing: 0.22em;
      text-transform: uppercase;
      color: var(--amber);
      font-weight: 500;
      margin-bottom: 1rem;
      animation: fadeUp 0.6s ease both;
    }
    .hero h1 {
      font-family: 'Playfair Display', serif;
      font-size: clamp(2.8rem, 6vw, 5rem);
      color: var(--espresso);
      line-height: 1.1;
      margin-bottom: 1.2rem;
      animation: fadeUp 0.7s ease 0.1s both;
    }
    .hero h1 em {
      color: var(--amber);
      font-style: italic;
    }
    .hero p {
      color: #6b5a4a;
      font-size: 1.05rem;
      font-weight: 300;
      max-width: 420px;
      line-height: 1.65;
      animation: fadeUp 0.7s ease 0.2s both;
    }

    /* ── CARDS ── */
    .cards-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 1.5rem;
      max-width: 1000px;
      margin: 3rem auto 4rem;
      padding: 0 2rem;
      animation: fadeUp 0.7s ease 0.3s both;
    }
    .card {
      background: #fff;
      border-radius: 12px;
      padding: 2.2rem 2rem;
      text-decoration: none;
      color: inherit;
      border: 1px solid #e8dcc8;
      box-shadow: 0 2px 12px rgba(26,15,10,0.06);
      display: flex;
      flex-direction: column;
      gap: 0.8rem;
      transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s;
      position: relative;
      overflow: hidden;
    }
    .card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: var(--card-accent, var(--amber));
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.3s ease;
    }
    .card:hover { transform: translateY(-4px); box-shadow: 0 12px 36px rgba(26,15,10,0.12); border-color: var(--card-accent, var(--amber)); }
    .card:hover::before { transform: scaleX(1); }
    .card.c-tables { --card-accent: #4a90a4; }
    .card.c-menu   { --card-accent: var(--sage); }
    .card.c-orders { --card-accent: var(--amber); }

    .card-icon {
      width: 52px; height: 52px;
      border-radius: 12px;
      background: var(--card-bg, #f5f0e8);
      display: grid; place-items: center;
      font-size: 1.5rem;
    }
    .c-tables .card-icon { background: #e8f4f8; color: #4a90a4; }
    .c-menu   .card-icon { background: #eef1eb; color: var(--sage); }
    .c-orders .card-icon { background: #fdf3e7; color: var(--amber); }

    .card h3 {
      font-family: 'Playfair Display', serif;
      font-size: 1.25rem;
      color: var(--espresso);
    }
    .card p { font-size: 0.88rem; color: #7a6a5a; line-height: 1.5; font-weight: 300; }
    .card-action {
      margin-top: auto;
      padding-top: 1rem;
      font-size: 0.82rem;
      font-weight: 500;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: var(--card-accent, var(--amber));
      display: flex;
      align-items: center;
      gap: 0.4rem;
    }

    /* ── STATS BAR ── */
    .stats-bar {
      background: var(--espresso);
      padding: 1.5rem 2rem;
      display: flex;
      justify-content: center;
      gap: 4rem;
      flex-wrap: wrap;
    }
    .stat { text-align: center; }
    .stat-num {
      font-family: 'Playfair Display', serif;
      font-size: 1.8rem;
      color: var(--gold);
      display: block;
    }
    .stat-label {
      font-size: 0.72rem;
      letter-spacing: 0.16em;
      text-transform: uppercase;
      color: #8a7060;
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<nav>
  <a href="index.jsp" class="nav-brand">
    <i class="bi bi-flower1"></i> Le Jardin <span class="dot">·</span> Manager
  </a>
  <div class="nav-links">
    <a href="tables"><i class="bi bi-grid-3x3-gap"></i> Tables</a>
    <a href="menu"><i class="bi bi-journal-richtext"></i> Menu</a>
    <a href="commande"><i class="bi bi-bag-check"></i> Commandes</a>
  </div>
</nav>

<div class="hero">
  <p class="hero-eyebrow">Système de gestion</p>
  <h1>Bienvenue au<br><em>Restaurant</em></h1>
  <p>Gérez vos tables, votre menu et vos commandes depuis un seul tableau de bord élégant.</p>
</div>

<div class="cards-grid">
  <a href="tables" class="card c-tables">
    <div class="card-icon"><i class="bi bi-grid-3x3-gap-fill"></i></div>
    <h3>Tables</h3>
    <p>Gérez la disposition, la disponibilité et le statut de chaque table en temps réel.</p>
    <div class="card-action">Gérer <i class="bi bi-arrow-right"></i></div>
  </a>
  <a href="menu" class="card c-menu">
    <div class="card-icon"><i class="bi bi-journal-richtext"></i></div>
    <h3>Menu</h3>
    <p>Ajoutez, modifiez ou retirez des plats. Organisez par catégorie avec prix et descriptions.</p>
    <div class="card-action">Gérer <i class="bi bi-arrow-right"></i></div>
  </a>
  <a href="commande" class="card c-orders">
    <div class="card-icon"><i class="bi bi-bag-check-fill"></i></div>
    <h3>Commandes</h3>
    <p>Suivez les commandes en cours, changez les statuts et générez les factures.</p>
    <div class="card-action">Gérer <i class="bi bi-arrow-right"></i></div>
  </a>
</div>

<div class="stats-bar">
  <div class="stat"><span class="stat-num">MAD</span><span class="stat-label">Devise</span></div>
  <div class="stat"><span class="stat-num">20%</span><span class="stat-label">TVA appliquée</span></div>
  <div class="stat"><span class="stat-num">3</span><span class="stat-label">Modules actifs</span></div>
</div>

</body>
</html>
