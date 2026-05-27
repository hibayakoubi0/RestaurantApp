<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Le Jardin — Dashboard Premium</title>

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
            --border: rgba(181,71,106,0.13);
            --bloom1: #f9d0dc;
            --bloom2: #fce8c4;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

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

        /* === PÉTALES DÉCORATIFS === */
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
                radial-gradient(circle 2px at 75% 88%, rgba(181,71,106,0.28) 100%, transparent),
                radial-gradient(ellipse 180px 80px at 3% 40%, rgba(232,160,180,0.1) 0%, transparent),
                radial-gradient(ellipse 120px 180px at 97% 60%, rgba(249,208,220,0.12) 0%, transparent);
        }

        body::after {
            content: '❀ ✿ ❀ ✿ ❀ ✿ ❀ ✿ ❀ ✿ ❀ ✿ ❀';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            text-align: center;
            font-size: 0.55rem;
            letter-spacing: 24px;
            color: rgba(181,71,106,0.08);
            padding: 8px 0;
            pointer-events: none;
            z-index: 0;
        }

        /* ============================
           NAVBAR
        ============================ */

        nav {
            position: sticky;
            top: 0;
            z-index: 1000;
            height: 76px;
            padding: 0 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(110,31,54,0.93);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(249,208,220,0.18);
            box-shadow:
                0 4px 24px rgba(110,31,54,0.22),
                0 1px 0 rgba(255,255,255,0.06) inset;
        }

        nav::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 300px;
            height: 1px;
            background: linear-gradient(to right, transparent, rgba(201,169,110,0.5), transparent);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--gold-light);
            text-decoration: none;
            font-family: 'Playfair Display', serif;
            font-size: 1.85rem;
            letter-spacing: 2px;
            font-weight: 500;
            text-shadow: 0 2px 12px rgba(201,169,110,0.3);
        }

        .logo i {
            font-size: 1.6rem;
            color: var(--rose);
            filter: drop-shadow(0 0 6px rgba(232,160,180,0.5));
            animation: petalSway 4s ease-in-out infinite;
        }

        @keyframes petalSway {
            0%, 100% { transform: rotate(-5deg) scale(1); }
            50% { transform: rotate(5deg) scale(1.08); }
        }

        .nav-links {
            display: flex;
            gap: 8px;
        }

        .nav-links a {
            color: rgba(255,255,255,0.65);
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 50px;
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 3px;
            font-weight: 700;
            transition: all 0.35s ease;
            border: 1px solid transparent;
            position: relative;
        }

        .nav-links a:hover {
            color: var(--gold-light);
            background: rgba(201,169,110,0.1);
            border-color: rgba(201,169,110,0.25);
            transform: translateY(-2px);
            letter-spacing: 3.5px;
        }

        /* ============================
           HERO
        ============================ */

        .hero {
            position: relative;
            z-index: 1;
            text-align: center;
            padding: 100px 20px 60px;
            overflow: hidden;
        }

        .hero::before {
            content: 'LE JARDIN';
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 9rem;
            font-family: 'Playfair Display', serif;
            color: rgba(181,71,106,0.04);
            letter-spacing: 20px;
            white-space: nowrap;
            pointer-events: none;
            font-style: italic;
        }

        /* Fleurs décoratives hero */
        .hero::after {
            content: '🌸';
            position: absolute;
            font-size: 8rem;
            top: 10px;
            right: 8%;
            opacity: 0.08;
            pointer-events: none;
            animation: floatPetal 6s ease-in-out infinite;
        }

        @keyframes floatPetal {
            0%, 100% { transform: translateY(0) rotate(0deg); opacity: 0.08; }
            50% { transform: translateY(-18px) rotate(12deg); opacity: 0.12; }
        }

        .hero h1 {
            position: relative;
            font-family: 'Playfair Display', serif;
            font-size: 4.8rem;
            font-weight: 400;
            color: var(--primary-dark);
            line-height: 1.05;
            animation: roseReveal 1.1s cubic-bezier(.22,1,.36,1) both;
        }

        .hero h1 span {
            display: block;
            font-style: italic;
            font-weight: 400;
            color: var(--primary);
            margin-top: 8px;
            font-size: 3.2rem;
        }

        .hero p {
            margin-top: 28px;
            letter-spacing: 8px;
            text-transform: uppercase;
            font-size: 0.68rem;
            color: var(--muted);
            font-weight: 700;
        }

        .divider {
            width: 260px;
            margin: 28px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 14px;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(to right, transparent, var(--gold), transparent);
        }

        .divider::before {
            background: linear-gradient(to right, transparent, var(--gold));
        }

        .divider::after {
            background: linear-gradient(to left, transparent, var(--gold));
        }

        /* Remplacement de la div .divider par un ornement floral */
        .divider {
            position: relative;
        }

        /* ============================
           STATS
        ============================ */

        .stats-wrapper {
            position: relative;
            z-index: 1;
            width: min(1200px, 92%);
            margin: auto;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .mini-stat {
            background: rgba(255,255,255,0.72);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255,255,255,0.9);
            border-radius: 22px;
            padding: 26px 28px;
            box-shadow:
                0 2px 0 rgba(255,255,255,0.9) inset,
                0 8px 28px rgba(110,31,54,0.09),
                0 1px 3px rgba(181,71,106,0.07);
            animation: roseReveal 0.8s cubic-bezier(.22,1,.36,1) both;
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .mini-stat:hover {
            transform: translateY(-5px);
            box-shadow:
                0 2px 0 rgba(255,255,255,0.9) inset,
                0 18px 40px rgba(110,31,54,0.14),
                0 1px 3px rgba(181,71,106,0.1);
        }

        .mini-stat::before {
            content: '';
            position: absolute;
            top: -40px;
            right: -40px;
            width: 100px;
            height: 100px;
            background: radial-gradient(circle, rgba(232,160,180,0.2) 0%, transparent 70%);
            pointer-events: none;
        }

        .mini-stat .top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .mini-stat i {
            font-size: 1.3rem;
            color: var(--primary);
            background: var(--rose-light);
            padding: 8px;
            border-radius: 12px;
        }

        .mini-stat h3 {
            font-size: 2.1rem;
            font-family: 'Playfair Display', serif;
            color: var(--primary-dark);
            font-weight: 500;
        }

        .mini-stat p {
            color: var(--muted);
            font-size: 0.72rem;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            font-weight: 700;
        }

        /* ============================
           DASHBOARD GRID
        ============================ */

        .dashboard-grid {
            position: relative;
            z-index: 1;
            width: min(1200px, 92%);
            margin: 56px auto 100px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 28px;
        }

        .card {
            position: relative;
            overflow: hidden;
            border-radius: 32px;
            background: rgba(255,255,255,0.78);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.95);
            box-shadow:
                0 2px 0 rgba(255,255,255,0.9) inset,
                0 12px 40px rgba(110,31,54,0.1),
                0 24px 60px rgba(110,31,54,0.07);
            transition: all 0.45s cubic-bezier(.22,1,.36,1);
            animation: roseReveal 0.9s cubic-bezier(.22,1,.36,1) both;
        }

        .card:hover {
            transform: translateY(-12px) scale(1.015);
            box-shadow:
                0 2px 0 rgba(255,255,255,0.9) inset,
                0 28px 60px rgba(110,31,54,0.16),
                0 40px 80px rgba(110,31,54,0.08);
        }

        /* Fleur de fond sur chaque carte */
        .card::before {
            content: '';
            position: absolute;
            bottom: -50px;
            right: -50px;
            width: 180px;
            height: 180px;
            background: radial-gradient(circle, rgba(232,160,180,0.15) 0%, transparent 65%);
            pointer-events: none;
        }

        .card::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(to right, var(--peach), var(--rose), var(--gold));
            border-radius: 32px 32px 0 0;
            opacity: 0.7;
        }

        .card-header {
            padding: 36px 36px 20px;
        }

        .icon-box {
            width: 66px;
            height: 66px;
            border-radius: 20px;
            background: linear-gradient(145deg, var(--primary) 0%, var(--primary-dark) 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 22px;
            box-shadow:
                0 12px 28px rgba(110,31,54,0.3),
                0 2px 0 rgba(255,255,255,0.15) inset;
            position: relative;
        }

        .icon-box::after {
            content: '';
            position: absolute;
            inset: -6px;
            border-radius: 26px;
            border: 1px solid rgba(181,71,106,0.18);
        }

        .icon-box i {
            font-size: 1.75rem;
            color: white;
        }

        .card-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: var(--primary-dark);
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .card-subtitle {
            margin-top: 7px;
            font-size: 0.68rem;
            text-transform: uppercase;
            letter-spacing: 3px;
            color: var(--primary);
            font-weight: 700;
        }

        .card-body {
            padding: 0 36px 36px;
        }

        .card-body p {
            color: var(--muted);
            line-height: 1.85;
            margin-bottom: 28px;
            font-size: 0.9rem;
        }

        .stats-row {
            display: flex;
            gap: 14px;
            margin-bottom: 28px;
        }

        .stats-box {
            flex: 1;
            padding: 18px 14px;
            border-radius: 18px;
            background: linear-gradient(145deg, rgba(253,232,239,0.7), rgba(255,255,255,0.6));
            border: 1px solid rgba(232,160,180,0.3);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stats-box::before {
            content: '';
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 60px;
            background: radial-gradient(circle, rgba(232,160,180,0.25) 0%, transparent 70%);
        }

        .stats-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 24px rgba(181,71,106,0.1);
            background: linear-gradient(145deg, rgba(253,232,239,0.9), rgba(255,255,255,0.8));
        }

        .stats-box h4 {
            font-size: 2rem;
            font-family: 'Playfair Display', serif;
            color: var(--primary-dark);
            font-weight: 500;
        }

        .stats-box span {
            font-size: 0.65rem;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            color: var(--primary);
            font-weight: 700;
        }

        .btn-premium {
            position: relative;
            overflow: hidden;
            width: 100%;
            border: none;
            border-radius: 50px;
            padding: 17px;
            cursor: pointer;
            text-decoration: none;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            letter-spacing: 3px;
            text-transform: uppercase;
            font-size: 0.68rem;
            font-weight: 700;
            transition: all 0.4s ease;
            box-shadow:
                0 14px 30px rgba(110,31,54,0.25),
                0 2px 0 rgba(255,255,255,0.15) inset;
        }

        .btn-premium::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 60%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25), transparent);
            transform: skewX(-20deg);
            transition: 0.7s ease;
        }

        .btn-premium:hover::before {
            left: 140%;
        }

        .btn-premium:hover {
            transform: translateY(-3px);
            box-shadow: 0 20px 40px rgba(110,31,54,0.3), 0 2px 0 rgba(255,255,255,0.15) inset;
            background: linear-gradient(135deg, #c25078 0%, var(--primary-dark) 100%);
        }

        /* ============================
           FOOTER
        ============================ */

        footer {
            position: relative;
            z-index: 1;
            background: linear-gradient(180deg, rgba(110,31,54,0.96) 0%, rgba(70,15,32,0.98) 100%);
            backdrop-filter: blur(12px);
            text-align: center;
            padding: 70px 20px 45px;
            color: white;
            overflow: hidden;
        }

        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 500px;
            height: 1px;
            background: linear-gradient(to right, transparent, rgba(201,169,110,0.5), transparent);
        }

        footer::after {
            content: '✿';
            position: absolute;
            font-size: 12rem;
            top: -30px;
            left: 50%;
            transform: translateX(-50%);
            color: rgba(255,255,255,0.02);
            pointer-events: none;
            font-family: 'Playfair Display', serif;
        }

        .footer-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            color: var(--gold-light);
            font-style: italic;
            position: relative;
            z-index: 1;
            text-shadow: 0 4px 16px rgba(201,169,110,0.25);
        }

        .footer-sub {
            margin-top: 12px;
            color: rgba(255,255,255,0.45);
            letter-spacing: 5px;
            text-transform: uppercase;
            font-size: 0.68rem;
            font-weight: 700;
            position: relative;
            z-index: 1;
        }

        .socials {
            display: flex;
            justify-content: center;
            gap: 14px;
            margin-top: 32px;
            position: relative;
            z-index: 1;
        }

        .socials a {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            text-decoration: none;
            color: var(--rose);
            border: 1px solid rgba(232,160,180,0.2);
            background: rgba(255,255,255,0.04);
            transition: all 0.35s ease;
            font-size: 1.1rem;
        }

        .socials a:hover {
            background: rgba(232,160,180,0.12);
            border-color: rgba(232,160,180,0.4);
            color: var(--gold-light);
            transform: translateY(-6px) scale(1.08);
            box-shadow: 0 12px 24px rgba(0,0,0,0.2);
        }

        .copyright {
            margin-top: 35px;
            color: rgba(255,255,255,0.25);
            font-size: 0.72rem;
            letter-spacing: 2.5px;
            position: relative;
            z-index: 1;
        }

        /* ============================
           ANIMATIONS
        ============================ */

        @keyframes roseReveal {
            from {
                opacity: 0;
                transform: translateY(36px);
                filter: blur(8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
                filter: blur(0);
            }
        }

        /* Stagger animations */
        .mini-stat:nth-child(1) { animation-delay: 0.05s; }
        .mini-stat:nth-child(2) { animation-delay: 0.15s; }
        .mini-stat:nth-child(3) { animation-delay: 0.25s; }
        .mini-stat:nth-child(4) { animation-delay: 0.35s; }

        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.22s; }
        .card:nth-child(3) { animation-delay: 0.34s; }

        /* ============================
           RESPONSIVE
        ============================ */

        @media (max-width: 1000px) {
            .dashboard-grid,
            .stats-wrapper {
                grid-template-columns: 1fr;
            }

            .hero h1 {
                font-size: 3rem;
            }

            .hero h1 span {
                font-size: 2rem;
            }

            .hero::before {
                font-size: 3.5rem;
            }

            nav {
                padding: 0 20px;
            }

            .nav-links {
                display: none;
            }
        }


        /* ======= PÉTALES TOMBANTS ======= */
        .petals-container {
            position: fixed; inset: 0;
            pointer-events: none; z-index: 0; overflow: hidden;
        }
        .petal {
            position: absolute; top: -60px; opacity: 0;
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
    <a href="index.jsp" class="logo">
        <i class="bi bi-flower1"></i>
        Le Jardin
    </a>

    <div class="nav-links">
        <a href="tables">Tables</a>
        <a href="menu">Menu</a>
        <a href="commande">Commandes</a>
    </div>
</nav>

<section class="hero">
    <h1>
        Dashboard Premium
        <span>Restaurant Gastronomique</span>
    </h1>

    <p>Luxury Restaurant Experience</p>

    <div class="divider"></div>
</section>

<section class="stats-wrapper">

    <div class="mini-stat">
        <div class="top">
            <p>Revenus</p>
            <i class="bi bi-cash-stack"></i>
        </div>
        <h3>24K €</h3>
    </div>

    <div class="mini-stat">
        <div class="top">
            <p>Clients</p>
            <i class="bi bi-people"></i>
        </div>
        <h3>1,284</h3>
    </div>

    <div class="mini-stat">
        <div class="top">
            <p>Réservations</p>
            <i class="bi bi-calendar-check"></i>
        </div>
        <h3>347</h3>
    </div>

    <div class="mini-stat">
        <div class="top">
            <p>Satisfaction</p>
            <i class="bi bi-star"></i>
        </div>
        <h3>98%</h3>
    </div>

</section>

<section class="dashboard-grid">

    <!-- TABLES -->

    <div class="card">

        <div class="card-header">
            <div class="icon-box">
                <i class="bi bi-grid-3x3-gap"></i>
            </div>

            <div class="card-title">Tables</div>
            <div class="card-subtitle">Gestion des places</div>
        </div>

        <div class="card-body">
            <p>
                Gérez les tables du restaurant et surveillez l'occupation en temps réel.
            </p>

            <div class="stats-row">
                <div class="stats-box">
                    <h4>12</h4>
                    <span>Tables</span>
                </div>

                <div class="stats-box">
                    <h4>8</h4>
                    <span>Occupées</span>
                </div>
            </div>

            <a href="tables" class="btn-premium">
                <i class="bi bi-arrow-right"></i>
                Gérer les tables
            </a>
        </div>

    </div>

    <!-- MENU -->

    <div class="card">

        <div class="card-header">
            <div class="icon-box">
                <i class="bi bi-journal-richtext"></i>
            </div>

            <div class="card-title">Menu</div>
            <div class="card-subtitle">Cuisine gastronomique</div>
        </div>

        <div class="card-body">
            <p>
                Consultez les plats, catégories et spécialités gastronomiques du restaurant.
            </p>

            <div class="stats-row">
                <div class="stats-box">
                    <h4>34</h4>
                    <span>Plats</span>
                </div>

                <div class="stats-box">
                    <h4>6</h4>
                    <span>Catégories</span>
                </div>
            </div>

            <a href="menu" class="btn-premium">
                <i class="bi bi-arrow-right"></i>
                Voir le menu
            </a>
        </div>

    </div>

    <!-- COMMANDES -->

    <div class="card">

        <div class="card-header">
            <div class="icon-box">
                <i class="bi bi-receipt"></i>
            </div>

            <div class="card-title">Commandes</div>
            
        </div>

        <div class="card-body">
            <p>
                Consultez les commandes en cours et générez les factures des clients.
            </p>

            <div class="stats-row">
                <div class="stats-box">
                    <h4>5</h4>
                    <span>En cours</span>
                </div>

                <div class="stats-box">
                    <h4>47</h4>
                    <span>Ce mois</span>
                </div>
            </div>

            <a href="commande" class="btn-premium">
                <i class="bi bi-arrow-right"></i>
                Voir les commandes
            </a>
        </div>

    </div>

</section>

<footer>

    <div class="footer-title">Le Jardin</div>

    <div class="footer-sub">
        Une expérience gastronomique d'exception
    </div>

    <div class="socials">
        <a href="#"><i class="bi bi-instagram"></i></a>
        <a href="#"><i class="bi bi-facebook"></i></a>
        <a href="#"><i class="bi bi-twitter-x"></i></a>
        <a href="#"><i class="bi bi-whatsapp"></i></a>
    </div>

    <div class="copyright">
        © 2026 Le Jardin — Tous droits réservés
    </div>

</footer>

</body>
</html>
