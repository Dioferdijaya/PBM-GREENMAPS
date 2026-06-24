# GreenMap

GreenMap adalah aplikasi revolusioner berbasis *Flutter* yang dirancang untuk memudahkan masyarakat dalam mengelola sampah mereka secara bijak. Aplikasi ini menghubungkan pengguna dengan Bank Sampah terdekat, memungkinkan penyetoran sampah untuk ditukar menjadi poin, serta menyediakan *Marketplace* untuk menukarkan poin dengan berbagai *voucher* menarik.

## Fitur Utama
- **Lokasi Bank Sampah:** Cari dan temukan Bank Sampah terdekat menggunakan peta interaktif.
- **Setor Sampah:** Pengguna dapat menyetor sampah yang dapat didaur ulang dan mendapatkan poin.
- **Tukar Poin (Marketplace):** Poin yang terkumpul dapat ditukar dengan voucher belanja, pulsa, atau diskon.
- **Edukasi Lingkungan:** Artikel dan panduan untuk hidup lebih ramah lingkungan.
- **Sistem Peran (Role):** Memiliki antarmuka dan hak akses berbeda untuk *User* biasa, *Admin Bank*, dan *Super Admin*.

---

## Panduan Menjalankan Aplikasi (Mock Data) 

Aplikasi ini saat ini berjalan menggunakan **Data Mock (Dummy)**. Semua data disimpan secara sementara di memori aplikasi selama sesi berjalan. Anda tidak perlu menghubungkan aplikasi ke backend atau database apapun.

Untuk menjalankan aplikasi ini:
1. Pastikan Anda sudah menginstal [Flutter](https://docs.flutter.dev/get-started/install).
2. Jalankan `flutter pub get` untuk mengunduh semua *dependencies*.
3. Jalankan aplikasi menggunakan `flutter run`.

---

## Akun Demo (Login) 

Gunakan akun-akun di bawah ini untuk menguji berbagai fitur dan peran yang ada di dalam aplikasi.

### 1. Akun Pengguna (User)
Gunakan akun ini untuk mengetes fitur menyetor sampah, melihat peta, melihat riwayat poin, dan menukarkan voucher.
- **Email:** `eja@greenmap.id`
- **Password:** `user123`

*Catatan: Anda juga dapat mendaftar (Register) akun baru. Akun baru yang didaftarkan akan disimpan secara sementara di memori dan dapat digunakan untuk login kembali selama aplikasi belum di-restart.*

### 2. Akun Admin Bank Sampah (Admin Bank)
Gunakan akun ini untuk menerima atau menolak setoran sampah dari pengguna yang masuk ke bank sampah spesifik Anda.
- **Email:** `admin1@greenmap.id` (Admin Bank Syiah Kuala)
- **Password:** `admin123`
- *(Tersedia juga `admin2@greenmap.id` hingga `admin4@greenmap.id` dengan password yang sama).*

### 3. Akun Super Admin (Super Admin)
Gunakan akun ini untuk mengakses dashboard pengelolaan *Voucher* (membuat, mengedit, dan menghapus voucher).
- **Email:** `superadmin@greenmap.id`
- **Password:** `admin123`

---

## Arsitektur & Teknologi 
- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Routing:** GoRouter (Dengan ShellRoute untuk navigasi bawah bersarang)
- **Peta:** Flutter Map (Leaflet) dengan OpenStreetMap
- **Data:** *In-Memory Mock Data* (Model, Provider, dan Repository lokal)
  
---
### 3. Dokumentasi
## Sisi Pengguna (User)<br>
a. Dashboard

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/01b1a0e7-ca32-478a-98a3-9a50ab1763c8" />

---
b. Map

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/c1236339-5b1b-412b-975b-cd743770123a" />

---
c. Point Reward

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/ec920ae3-eb2a-49b7-af8f-caca847aa472" />

---
d. Riwayat Setoran

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/144c4d7e-0134-432f-aafa-20fa9ebdeb7a" />


---
e. Marketplace Reward

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/69c6fd08-43a5-47f9-adb0-ea6fb540ffe9" />

---
## Sisi Admin<br>
f. Dashboard Admin

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/d2f91d96-e3e6-4bb7-86d8-4225304a7872" />

---
g. Fitur Verifikasi

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/4e481fa3-a149-4bd2-abde-0c6783d5136e" />

---
h. Profil Admin

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/57da9fc4-7052-414a-ac6f-f24bb7211b72" />

---
## Sisi Super Admin <br>
i. Dashboard Super Admin

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/b1de8626-76cf-456c-a161-38aa5b0dfd91" />

---
j. Daftar Bank Sampah

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/56383370-ace9-4696-a383-5ff71eddaa5f" />

---
k. Fitur Atur Vocher

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/8d537cb8-c9ef-446b-a521-10f4a0aff206" />

---
l. Profil Super Admin

<img width="198" height="397" alt="image" src="https://github.com/user-attachments/assets/fb16c688-331f-4eff-9cc2-bb27a2c4afb2" />
