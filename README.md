<!DOCTYPE html>
<html lang="id" class="dark scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>JXL Novorius — Dokumentasi & Asisten Alur Kerja Interaktif</title>

  <!-- Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- Google Fonts: Inter & JetBrains Mono -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet" />

  <script>
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          fontFamily: {
            sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
            mono: ['JetBrains Mono', 'ui-monospace', 'SFMono-Regular', 'monospace'],
          },
          colors: {
            studio: {
              950: '#07090f',
              900: '#0b0f19',
              850: '#101624',
              800: '#151d2e',
              750: '#1c263b',
            },
            violetglow: '#8b5cf6',
            royal: '#2563eb',
          },
        },
      },
    };
  </script>

  <style>
    :root {
      color-scheme: dark;
    }

    body {
      background-color: #07090f;
      color: #e2e8f0;
      font-family: 'Inter', system-ui, -apple-system, sans-serif;
      overflow-x: hidden;
    }

    code, pre, .font-mono {
      font-family: 'JetBrains Mono', ui-monospace, SFMono-Regular, monospace;
    }

    /* Latar studio subtle grid & ambient glow */
    .studio-grid {
      background-size: 28px 28px;
      background-image:
        linear-gradient(to right, rgba(148, 163, 184, 0.05) 1px, transparent 1px),
        linear-gradient(to bottom, rgba(148, 163, 184, 0.05) 1px, transparent 1px);
    }

    .ambient-orb-violet {
      background: radial-gradient(circle, rgba(139, 92, 246, 0.22) 0%, rgba(139, 92, 246, 0) 70%);
    }

    .ambient-orb-blue {
      background: radial-gradient(circle, rgba(37, 99, 235, 0.20) 0%, rgba(37, 99, 235, 0) 70%);
    }

    /* Pola papan catur untuk pratinjau transparansi / alpha */
    .checkerboard {
      background-color: #111827;
      background-image:
        linear-gradient(45deg, #1f2937 25%, transparent 25%),
        linear-gradient(-45deg, #1f2937 25%, transparent 25%),
        linear-gradient(45deg, transparent 75%, #1f2937 75%),
        linear-gradient(-45deg, transparent 75%, #1f2937 75%);
      background-size: 16px 16px;
      background-position: 0 0, 0 8px, 8px -8px, -8px 0;
    }

    /* Custom subtle scrollbar */
    ::-webkit-scrollbar {
      width: 8px;
      height: 8px;
    }
    ::-webkit-scrollbar-track {
      background: #0b0f19;
    }
    ::-webkit-scrollbar-thumb {
      background: #233049;
      border-radius: 9999px;
    }
    ::-webkit-scrollbar-thumb:hover {
      background: #334669;
    }

    /* Animasi toast halus */
    @keyframes toastIn {
      from {
        opacity: 0;
        transform: translateY(12px) scale(0.97);
      }
      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }
    .toast-enter {
      animation: toastIn 0.22s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
  </style>
</head>
<body class="studio-grid min-h-screen antialiased selection:bg-violet-500/30 selection:text-violet-200">

  <!-- Ambient Background Glow -->
  <div class="pointer-events-none fixed inset-0 overflow-hidden -z-10">
    <div class="ambient-orb-violet absolute -top-28 -left-24 h-[420px] w-[420px] rounded-full blur-2xl"></div>
    <div class="ambient-orb-blue absolute top-32 right-0 h-[460px] w-[460px] rounded-full blur-2xl"></div>
  </div>

  <!-- Sticky Top Bar -->
  <header class="sticky top-0 z-40 border-b border-slate-800/80 bg-studio-950/85 backdrop-blur-xl">
    <div class="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-3 px-4 py-3 sm:px-6 lg:px-8">
      <!-- Brand Identity -->
      <a href="#top" class="flex items-center gap-3 rounded-xl py-1 pr-2 transition hover:opacity-95">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl border border-violet-500/40 bg-gradient-to-br from-violet-600/30 via-blue-600/20 to-slate-900 shadow-lg shadow-violet-950/50">
          <svg class="h-5 w-5 text-violet-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
        </div>
        <div>
          <div class="flex items-center gap-2">
            <span class="text-base font-bold tracking-tight text-white">JXL Novorius</span>
            <span class="rounded-md border border-amber-500/30 bg-amber-500/10 px-1.5 py-0.5 font-mono text-[10px] font-medium text-amber-300">
              EXPERIMENTAL
            </span>
          </div>
          <p class="hidden text-xs text-slate-400 sm:block">JPEG XL Integration for CorelDRAW</p>
        </div>
      </a>

      <!-- Quick Section Navigation -->
      <nav aria-label="Navigasi Utama" class="hidden items-center gap-1 lg:flex">
        <a href="#arsitektur" class="rounded-lg px-3 py-1.5 text-xs font-medium text-slate-300 transition hover:bg-slate-800/70 hover:text-white">Arsitektur</a>
        <a href="#kompatibilitas" class="rounded-lg px-3 py-1.5 text-xs font-medium text-slate-300 transition hover:bg-slate-800/70 hover:text-white">Kompatibilitas</a>
        <a href="#simulator" class="rounded-lg px-3 py-1.5 text-xs font-medium text-slate-300 transition hover:bg-slate-800/70 hover:text-white">Format & CLI</a>
        <a href="#panduan" class="rounded-lg px-3 py-1.5 text-xs font-medium text-slate-300 transition hover:bg-slate-800/70 hover:text-white">Instalasi & Alur</a>
        <a href="#validasi" class="rounded-lg px-3 py-1.5 text-xs font-medium text-slate-300 transition hover:bg-slate-800/70 hover:text-white">Batasan & Uji</a>
      </nav>

      <!-- Global Platform Switcher in Header -->
      <div class="flex items-center rounded-xl border border-slate-800 bg-studio-900 p-1" role="group" aria-label="Pilih Platform">
        <button
          id="nav-platform-windows"
          type="button"
          onclick="setPlatform('windows')"
          class="flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-semibold transition-all cursor-pointer"
        >
          <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="currentColor">
            <path d="M3 5.557L10.354 4.5v7.07H3V5.557zm0 12.886L10.354 19.5v-6.93H3v5.873zm8.246 1.19L21 21v-8.43h-9.754v7.063zm0-15.266v7.203H21V3l-9.754 1.367z" />
          </svg>
          <span>Windows</span>
        </button>
        <button
          id="nav-platform-macos"
          type="button"
          onclick="setPlatform('macos')"
          class="flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-semibold transition-all cursor-pointer"
        >
          <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="currentColor">
            <path d="M16.365 1.43c0 1.14-.493 2.27-1.177 3.08-.744.9-1.99 1.57-2.987 1.57-.12 0-.23-.02-.3-.03-.01-.06-.04-.22-.04-.39 0-1.15.572-2.27 1.206-2.98.804-.94 2.142-1.64 3.248-1.68.03.13.05.28.05.43zm4.565 15.71c-.03.07-.463 1.58-1.518 3.12-.945 1.34-1.94 2.71-3.43 2.71-1.517 0-1.9-.88-3.63-.88-1.698 0-2.302.91-3.67.91-1.377 0-2.332-1.26-3.428-2.8-1.287-1.82-2.323-4.63-2.323-7.28 0-4.28 2.797-6.55 5.552-6.55 1.448 0 2.675.95 3.6.95.865 0 2.222-1.01 3.902-1.01.613 0 2.886.06 4.374 2.19-.13.09-2.383 1.37-2.383 4.19 0 3.26 2.854 4.42 2.955 4.45z" />
          </svg>
          <span>macOS</span>
        </button>
      </div>
    </div>
  </header>

  <main id="top" class="mx-auto max-w-7xl px-4 py-8 sm:px-6 sm:py-12 lg:px-8 space-y-16">

    <!-- HERO & OVERVIEW -->
    <section class="relative overflow-hidden rounded-3xl border border-slate-800/90 bg-gradient-to-b from-studio-850/95 via-studio-900/95 to-studio-950 p-6 sm:p-10 shadow-2xl">
      <div class="grid gap-8 lg:grid-cols-12 lg:items-center">
        <div class="lg:col-span-7 space-y-5">
          <!-- Badges -->
          <div class="flex flex-wrap items-center gap-2">
            <span class="inline-flex items-center gap-1.5 rounded-full border border-violet-500/35 bg-violet-500/10 px-3 py-1 font-mono text-xs font-medium text-violet-300">
              <span class="h-1.5 w-1.5 rounded-full bg-violet-400"></span>
              Format: JPEG XL (.jxl)
            </span>
            <span class="inline-flex items-center rounded-full border border-blue-500/35 bg-blue-500/10 px-3 py-1 font-mono text-xs font-medium text-blue-300">
              Windows: CorelDRAW 2026 (v27) &amp; Compat
            </span>
            <span class="inline-flex items-center rounded-full border border-slate-700 bg-slate-800/80 px-3 py-1 font-mono text-xs font-medium text-slate-300">
              macOS: Standalone Launcher
            </span>
          </div>

          <h1 class="text-3xl font-extrabold tracking-tight text-white sm:text-4xl lg:text-5xl">
            JXL Novorius
            <span class="mt-1 block bg-gradient-to-r from-violet-400 via-indigo-300 to-blue-400 bg-clip-text text-transparent">
              Integrasi JPEG XL untuk CorelDRAW
            </span>
          </h1>

          <p class="max-w-2xl text-sm leading-relaxed text-slate-300 sm:text-base">
            Proyek eksperimental berbasis AI untuk menghadirkan konversi dan integrasi alur kerja file <code class="rounded bg-slate-800 px-1.5 py-0.5 text-violet-300">.jxl</code> ke CorelDRAW pada <strong>Windows</strong> dan <strong>macOS</strong>. Satu format, dua platform, dengan pendekatan integrasi yang dirancang sesuai karakter masing-masing sistem.
          </p>

          <!-- Platform Switcher Bar (Hero) -->
          <div class="pt-1">
            <div class="mb-2 text-xs font-semibold uppercase tracking-wider text-slate-400">
              Mode Platform Aktif (Memperbarui Pipeline, Log &amp; Panduan)
            </div>
            <div class="inline-grid w-full grid-cols-2 gap-2 rounded-2xl border border-slate-800 bg-studio-950/90 p-1.5 sm:w-auto">
              <button
                id="hero-btn-windows"
                type="button"
                onclick="setPlatform('windows')"
                class="flex items-center justify-center gap-2 rounded-xl px-4 py-2.5 text-xs font-semibold transition-all cursor-pointer sm:text-sm"
              >
                <span class="h-2 w-2 rounded-full bg-blue-400"></span>
                <span>Windows Docker</span>
              </button>
              <button
                id="hero-btn-macos"
                type="button"
                onclick="setPlatform('macos')"
                class="flex items-center justify-center gap-2 rounded-xl px-4 py-2.5 text-xs font-semibold transition-all cursor-pointer sm:text-sm"
              >
                <span class="h-2 w-2 rounded-full bg-violet-400"></span>
                <span>macOS Launcher</span>
              </button>
            </div>
          </div>

          <!-- Quick Action CTAs -->
          <div class="flex flex-wrap items-center gap-3 pt-1">
            <a href="#kompatibilitas" class="inline-flex items-center gap-2 rounded-xl bg-gradient-to-r from-violet-600 to-blue-600 px-4 py-2.5 text-xs font-semibold text-white shadow-lg shadow-violet-900/40 transition hover:brightness-110 sm:text-sm">
              <span>Cek Kompatibilitas Build</span>
              <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
            </a>
            <a href="#simulator" class="inline-flex items-center gap-2 rounded-xl border border-slate-700 bg-slate-800/70 px-4 py-2.5 text-xs font-semibold text-slate-200 transition hover:border-slate-600 hover:bg-slate-800 sm:text-sm">
              <span>Simulator Format &amp; CLI</span>
            </a>
          </div>
        </div>

        <!-- Right Card: Dynamic Active Platform Snapshot -->
        <div class="lg:col-span-5">
          <div id="platform-snapshot-card" class="rounded-2xl border border-slate-800 bg-studio-950/90 p-5 sm:p-6 shadow-inner">
            <!-- Diisi dinamis oleh JS sesuai platform aktif -->
          </div>
        </div>
      </div>

      <!-- Important Note Banner -->
      <div class="mt-8 rounded-2xl border border-amber-500/30 bg-amber-500/10 px-4 py-3.5 text-xs leading-relaxed text-amber-200/95 sm:text-sm">
        <strong class="font-semibold text-amber-300">Catatan Penting:</strong> Aplikasi <strong>macOS</strong> bukan add-on native CorelDRAW—tidak memasang Docker, tidak mendaftarkan ekstensi CorelDRAW, dan tidak menyuntikkan kode ke dalam proses aplikasi. Pada <strong>Windows</strong>, instalasi menggunakan <em>add-on deployment &amp; registration</em> standar, bukan injeksi proses saat runtime.
      </div>
    </section>

    <!-- SECTION 1: INTERACTIVE ARCHITECTURE PIPELINE & LOG PATHS -->
    <section id="arsitektur" class="space-y-6">
      <div class="flex flex-col justify-between gap-4 md:flex-row md:items-end">
        <div>
          <span class="font-mono text-xs font-semibold uppercase tracking-wider text-violet-400">01 / Arsitektur Sistem</span>
          <h2 class="mt-1 text-2xl font-bold tracking-tight text-white sm:text-3xl">
            Pipeline &amp; Tanggung Jawab File Interaktif
          </h2>
          <p class="mt-1.5 max-w-2xl text-sm text-slate-400">
            Klik setiap node pada alur kerja di bawah untuk melihat peran teknis, berkas sumber utama, dan lokasi log diagnostik pada platform yang sedang dipilih.
          </p>
        </div>

        <div class="inline-flex self-start rounded-xl border border-slate-800 bg-studio-900 p-1 text-xs">
          <button id="arch-tab-windows" type="button" onclick="setPlatform('windows')" class="rounded-lg px-3 py-1.5 font-semibold transition cursor-pointer">
            Windows Pipeline
          </button>
          <button id="arch-tab-macos" type="button" onclick="setPlatform('macos')" class="rounded-lg px-3 py-1.5 font-semibold transition cursor-pointer">
            macOS Pipeline
          </button>
        </div>
      </div>

      <div class="grid gap-6 lg:grid-cols-12">
        <!-- Pipeline Nodes Column -->
        <div class="lg:col-span-7 space-y-4">
          <div class="rounded-2xl border border-slate-800 bg-studio-900/85 p-5 sm:p-6">
            <div class="mb-4 flex items-center justify-between">
              <span id="arch-mode-label" class="font-mono text-xs font-semibold text-blue-300">WINDOWS • CPG + WPF + PYTHON</span>
              <span class="text-xs text-slate-400">Klik node untuk inspeksi</span>
            </div>

            <div id="pipeline-nodes-container" class="space-y-2.5">
              <!-- Diisi via JS -->
            </div>
          </div>

          <!-- Log & Storage Paths Box -->
          <div class="rounded-2xl border border-slate-800 bg-studio-900/85 p-5">
            <h3 class="text-sm font-semibold text-white">Lokasi Log Diagnostik &amp; Penyimpanan Lokal</h3>
            <p class="mt-1 text-xs text-slate-400">
              Membersihkan log yang tampil di UI tidak menghapus berkas log persisten di disk. Periksa isi log sebelum dibagikan karena dapat memuat nama file dan path lokal.
            </p>
            <div id="log-paths-container" class="mt-3.5 space-y-2.5">
              <!-- Diisi via JS -->
            </div>
          </div>
        </div>

        <!-- Node Inspector Drawer/Panel -->
        <div class="lg:col-span-5">
          <div id="node-inspector" class="sticky top-20 rounded-2xl border border-violet-500/30 bg-gradient-to-b from-studio-850 to-studio-950 p-5 sm:p-6 shadow-xl">
            <!-- Diisi via JS -->
          </div>
        </div>
      </div>
    </section>

    <!-- SECTION 2: COMPATIBILITY & BUILD FINDER -->
    <section id="kompatibilitas" class="space-y-6">
      <div>
        <span class="font-mono text-xs font-semibold uppercase tracking-wider text-blue-400">02 / Kompatibilitas &amp; Build Finder</span>
        <h2 class="mt-1 text-2xl font-bold tracking-tight text-white sm:text-3xl">
          Pencari Paket &amp; Status Kompatibilitas CorelDRAW
        </h2>
        <p class="mt-1.5 max-w-3xl text-sm text-slate-400">
          Pilih versi CorelDRAW atau lingkungan macOS Anda untuk langsung melihat rekomendasi paket, versi SDK Major, status pengujian, serta prasyarat dan checklist instalasi.
        </p>
      </div>

      <div class="grid gap-6 lg:grid-cols-12">
        <!-- Left: Selector & Version Matrix -->
        <div class="lg:col-span-5 space-y-5">
          <div class="rounded-2xl border border-slate-800 bg-studio-900/90 p-5 sm:p-6 space-y-4">
            <label for="compat-target-select" class="block text-xs font-semibold uppercase tracking-wider text-slate-300">
              Pilih Target Versi / Lingkungan
            </label>
            <select
              id="compat-target-select"
              onchange="selectCompatibilityTarget(this.value)"
              class="w-full rounded-xl border border-slate-700 bg-studio-950 px-3.5 py-2.5 text-sm font-medium text-white focus:border-violet-500 focus:outline-none focus:ring-2 focus:ring-violet-500/30"
            >
              <!-- Diisi via JS -->
            </select>

            <!-- Quick Pills for Popular Targets -->
            <div>
              <span class="block text-[11px] font-medium text-slate-400 mb-2">Pintasan Cepat:</span>
              <div class="flex flex-wrap gap-1.5">
                <button type="button" onclick="selectCompatibilityTarget('win-2026')" class="rounded-lg border border-slate-700 bg-slate-800/70 px-2.5 py-1 font-mono text-xs text-slate-200 hover:border-blue-500/60 hover:text-white transition cursor-pointer">2026 (v27)</button>
                <button type="button" onclick="selectCompatibilityTarget('win-2025')" class="rounded-lg border border-slate-700 bg-slate-800/70 px-2.5 py-1 font-mono text-xs text-slate-200 hover:border-blue-500/60 hover:text-white transition cursor-pointer">2025 (v26)</button>
                <button type="button" onclick="selectCompatibilityTarget('win-2024')" class="rounded-lg border border-slate-700 bg-slate-800/70 px-2.5 py-1 font-mono text-xs text-slate-200 hover:border-blue-500/60 hover:text-white transition cursor-pointer">2024 (v25)</button>
                <button type="button" onclick="selectCompatibilityTarget('win-2022-2023')" class="rounded-lg border border-slate-700 bg-slate-800/70 px-2.5 py-1 font-mono text-xs text-slate-200 hover:border-blue-500/60 hover:text-white transition cursor-pointer">2022–2023</button>
                <button type="button" onclick="selectCompatibilityTarget('win-x6')" class="rounded-lg border border-slate-700 bg-slate-800/70 px-2.5 py-1 font-mono text-xs text-slate-200 hover:border-rose-500/60 hover:text-white transition cursor-pointer">X6 &amp; earlier</button>
                <button type="button" onclick="selectCompatibilityTarget('mac-2026')" class="rounded-lg border border-slate-700 bg-slate-800/70 px-2.5 py-1 font-mono text-xs text-violet-300 hover:border-violet-500/60 hover:text-white transition cursor-pointer">macOS Launcher</button>
              </div>
            </div>
          </div>

          <!-- Compact Compatibility Table -->
          <div class="rounded-2xl border border-slate-800 bg-studio-900/90 overflow-hidden">
            <div class="border-b border-slate-800 px-4 py-3 flex items-center justify-between">
              <h3 class="text-xs font-semibold uppercase tracking-wider text-slate-300">Matriks Kompatibilitas Windows (x64)</h