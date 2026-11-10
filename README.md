<p align="center">
  <img src="assets/icon_app.png" alt="HOK by 7Sensei Logo" width="96" />
</p>

<h1 align="center">HOK by 7Sensei</h1>

<p align="center">
  Kalkulator resmi Power Lane & Power Hero Individual untuk Honor of Kings — akurat, cepat, dan mudah digunakan.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Web-4CAF50?logo=googlechrome&logoColor=white" alt="Platform: Web">
  <img src="https://img.shields.io/github/last-commit/7Sensei/hok-by-7sensei" alt="Last Commit">
  <img src="https://img.shields.io/github/stars/7Sensei/hok-by-7sensei?style=social" alt="Stars">
</p>

---

## 📋 Daftar Isi

- [Tentang Aplikasi](#tentang-aplikasi)
- [Fitur](#fitur)
- [Screenshot](#screenshot)
- [Teknologi](#teknologi)
- [Memulai](#memulai)
- [Build & Deploy](#build--deploy)
- [Struktur Folder](#struktur-folder)
- [Kontribusi](#kontribusi)
- [Disclaimer](#disclaimer)

---

## Tentang Aplikasi

**HOK by 7Sensei** adalah aplikasi web berbasis Flutter yang membantu pemain Honor of Kings menghitung **Power Lane (分路战力)** dan **Power Hero Individual (英雄战力)** secara akurat sesuai rumus resmi in-game. Aplikasi ini juga dilengkapi kalkulator Win Rate untuk membantu pemain merencanakan strategi ranked mereka.

---

## Fitur

### 🗺️ Kalkulator Power Lane
- 🛣️ Mendukung **5 lane**: Clash Lane, Jungle, Mid Lane, Farm Lane, dan Roamer
- 🏆 Kalkulasi otomatis **Hero Utama (bobot 100%)** dan **Hero OP (bobot 20%)**
- 🎯 **Target Simulator** — hitung sisa poin menuju target tier
- 📊 Rekomendasi hero yang paling efisien untuk di-push
- 🔀 **Auto-sort** 10 hero berdasarkan power tertinggi ke slot yang tepat
- 🏅 **Sistem Tier** — setiap 1.000 Power = 1 Tier
- ✏️ Input target tier/poin dapat diubah langsung di UI

### 🧮 Rincian Power Hero Individual
- 📈 Kalkulasi **Power Performa Ranked** berdasarkan performa pertandingan
- ⛰️ Kalkulasi **Power Performa Peak** berdasarkan Poin Tourney
- 🏅 Kalkulasi **Power Kemenangan** dari akumulasi kemenangan ranked & peak
- ✖️ Kalkulasi **Pengali Peak** dan **Pengali Keaktifan**
- 🔗 Hasil kalkulasi dapat langsung disalin ke slot hero di Kalkulator Lane

### 📉 Penghitung Win Rate
- 📈 Mode **Win Streak** — prediksi Win Rate baru setelah win streak berturut-turut
- 📉 Mode **Lose Streak** — prediksi Win Rate baru setelah lose streak berturut-turut
- ⚖️ Mode **Win / Lose** — hitung total win & lose dari WR dan total match
- 📊 Visualisasi grafik interaktif dengan **fl_chart** (BarChart & PieChart)

### 🗃️ Database Hero
- 🔍 Dialog pencarian hero Honor of Kings berdasarkan lane/role
- ⚡ Validasi input angka di seluruh form dengan peringatan SnackBar

### 🎨 UI / UX
- 🌙 Tema dark **Gameland** dengan aksen neon lime
- 📌 Floating mode selector (lane & WR mode) yang tetap terlihat saat scroll
- 📱 Desain responsif untuk berbagai ukuran layar

---

## Screenshot

<!-- Tambahkan screenshot di sini setelah tersedia: -->
<!-- ![Power Lane Calculator](docs/screenshot-power-lane.png) -->
<!-- ![Hero Detail](docs/screenshot-hero-detail.png) -->
<!-- ![Win Rate Calculator](docs/screenshot-win-rate.png) -->

---

## Teknologi

| Komponen | Detail |
|---|---|
| **Framework** | [Flutter](https://flutter.dev) 3.x |
| **Bahasa** | [Dart](https://dart.dev) ^3.12.2 |
| **Arsitektur** | Modern MVVM (Feature-first) |
| **State Management** | [provider](https://pub.dev/packages/provider) ^6.1.2 |
| **Grafik** | [fl_chart](https://pub.dev/packages/fl_chart) ^1.3.1 |
| **SVG Assets** | [flutter_svg](https://pub.dev/packages/flutter_svg) ^2.3.2 |
| **Platform** | Web (Flutter Web) |

---

## Memulai

### Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) versi **^3.12.2**
- Browser modern (Google Chrome direkomendasikan)

### Instalasi

```bash
# 1. Clone repositori
git clone https://github.com/7Sensei/hok-by-7sensei.git

# 2. Masuk ke folder proyek
cd hok-by-7sensei

# 3. Install dependensi
flutter pub get

# 4. Jalankan di browser
flutter run -d chrome
```

---

## Build & Deploy

```bash
flutter build web --release --base-href "/hok-by-7sensei/"
```

> [!NOTE]
> Nilai `--base-href` harus sesuai dengan nama repositori GitHub jika di-hosting di **GitHub Pages**. Jika menggunakan domain kustom atau subdomain lain, sesuaikan nilainya.

---

## Struktur Folder

```
lib/
├── main.dart       # Titik masuk utama aplikasi (entry point)
├── app/            # Setup aplikasi (HokApp) & tema global (HokTheme)
├── core/           # Konstanta, numeric input formatter, dan utilitas kalkulator
├── data/           # Data layer
│   └── models/     # Model data immutable (hero, lane, hero detail)
└── features/       # Arsitektur feature-first (MVVM):
    ├── hero_detail/    # View & ViewModel untuk rincian Hero Power individual
    ├── power_lane/     # View & ViewModel untuk kalkulator 5 Power Lane
    ├── shell/          # View & ViewModel untuk navbar, sidebar, dan layout shell
    └── win_rate/       # View & ViewModel untuk kalkulator Win Rate
```

---

## Kontribusi

Kontribusi sangat disambut! Caranya:

1. **Fork** repositori ini
2. Buat branch baru: `git checkout -b fitur/nama-fitur`
3. Commit perubahan: `git commit -m "feat: tambahkan fitur X"`
4. Push ke branch: `git push origin fitur/nama-fitur`
5. Buka **Pull Request** ke branch `main`

---

## Disclaimer

Aplikasi ini adalah **tools buatan penggemar** yang bersifat tidak resmi (*unofficial fan-made tool*). Aplikasi ini **tidak berafiliasi dengan, disponsori oleh, atau didukung oleh** Tencent, TiMi Studio Group, atau tim resmi Honor of Kings dalam bentuk apapun.

Semua nama game, karakter, merek dagang, dan aset terkait **Honor of Kings** adalah milik dari pemiliknya masing-masing (© Tencent / TiMi Studio Group).

---

<p align="center">
  Dibuat oleh <a href="https://github.com/7Sensei">7Sensei</a>
</p>
