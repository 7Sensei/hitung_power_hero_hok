# HOK Power Calculator (Honor of Kings - 分路战力 & 英雄战力计算器)

Aplikasi kalkulator pintar dan simulator untuk menghitung **Power Lane (分路战力)** dan **Power Hero Individual (英雄战力)** resmi sesuai sistem game **Honor of Kings (HoK)**.

---

## 📸 Fitur Utama Sesuai In-Game HoK

### 1. Kalkulator Power Lane (分路战力)
* **Dukungan 5 Lane**: Clash Lane (对抗路), Jungle (打野), Mid Lane (中路), Farm Lane (发育路), dan Roamer (游走).
* **Perhitungan Hero Utama (Top 1–5)**:
  * Bobot kontribusi **100%**.
  * $\text{Subtotal Utama} = \sum_{i=1}^5 \text{Power Hero}_i$
* **Perhitungan Hero OP Kamu (Top 6–10)**:
  * Bobot kontribusi **20%**.
  * $\text{Subtotal OP} = \left(\sum_{j=6}^{10} \text{Power Hero}_j\right) \times 20\%$
* **Total Power Lane**:
  $$\text{Power Lane} = \text{Subtotal Utama} + \text{Subtotal OP}$$
* **Sistem Tier Lane**:
  * Setiap kelipatan **1.000 Power** = **1 Tier** (Contoh: `29.782` Power = `Tier 29`).
* **Target Simulator & Strategi Push Paling Efisien**:
  * Menghitung sisa poin menuju target (misal target `33.190` Top 1%).
  * Memberikan rekomendasi hero mana yang paling hemat dan cepat dinaikkan (efisiensi 100% vs trik lompatan bobot 20% ke 100%).
* **Fitur Auto-Sort 10 Hero**: Secara otomatis menempatkan 5 hero ber-power tertinggi ke Hero Utama dan 5 berikutnya ke Hero OP.

---

### 2. Kalkulator Rincian Hero Power (英雄战力明细)
Berdasarkan rumus resmi in-game HoK:
$$\text{Power Hero} = \text{Power Total} \times \text{Pengali Total}$$

* **Komponen Power Total**:
  1. **Power Performa Ranked**: Berdasarkan tier & performa pertandingan ranked (Maks 1.500 poin).
  2. **Power Performa Peak**: Berdasarkan performa Peak Tournament (Poin Tourney).
  3. **Power Kemenangan**: Akumulasi kemenangan ranked & peak (Maks 3.000 poin).
* **Komponen Pengali Total**:
  1. **Pengali Peak (%)**: Diperoleh dari Poin Tourney Peak saat ini ($+1\%$ setiap kelipatan 20 poin di atas 1.200 poin).
     $$\text{Pengali Peak} = \max\left(0, \lfloor(\text{Poin Peak} - 1200) / 20\rfloor\right)\%$$
  2. **Pengali Keaktifan (%)**: Persentase keaktifan hero ($10\% - 100\%$).
  $$\text{Pengali Total} = (1 + \text{Pengali Peak}) \times \text{Pengali Keaktifan}$$
* **Fitur Integrasi**: Hasil kalkulasi Hero Power dapat langsung disalin ke slot hero mana pun di Kalkulator Lane!

---

### 3. Database Hero HoK Lengkap
* Tersedia dialog pencarian hero resmi HoK per role/lane (Dharma, Allain, Biron, Mayene, Arthur, Lam, Wukong, Diaochan, Marco Polo, Dolia, dll).

---

## 🚀 Menjalankan Project

1. Pastikan Flutter SDK sudah terpasang.
2. Jalankan aplikasi:
   ```bash
   flutter run -d chrome  # Untuk Web
   # atau
   flutter run            # Untuk Android / iOS / Desktop
   ```

---

## 🧪 Unit & Widget Testing

Jalankan test untuk memverifikasi akurasi matematis rumus:
```bash
flutter test
```
