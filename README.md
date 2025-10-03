# AURA+ (Augmented Reality Therapy Assistant)

AURA+ adalah aplikasi terapi kosakata berbasis Augmented Reality (AR) yang dibangun dengan Flutter, Riverpod, dan pendekatan Clean Architecture. Proyek ini dirancang untuk berjalan di Android & iOS dengan dukungan offline-first, pelacakan sesi, dan panduan pelafalan.

## Fitur Utama
- **AR Vocabulary** dengan fallback viewer 3D ketika perangkat tidak mendukung ARCore/ARKit.
- **AR 3D Model Viewer** untuk eksplorasi aset GLB/GLTF secara orbit & zoom.
- **Pronunciation Guide** dengan TTS dan Speech-to-Text untuk evaluasi pelafalan.
- **Session Tracking** menggunakan penyimpanan lokal Hive untuk riwayat aktivitas.
- **Content Pack** lokal yang dapat diperluas dengan distribusi daring.
- **Offline-first** dengan sinkronisasi konten dari `assets/content_packs`.

## Prasyarat
- Flutter channel `stable` terbaru.
- Xcode (iOS) atau Android Studio + Android SDK.
- Akun Firebase (opsional) untuk analytics & crash reporting.

## Setup Proyek
```sh
make setup
```
Perintah di atas menjalankan `flutter pub get` dan menyiapkan adapter Hive yang diperlukan.

### Konfigurasi Android
- Tambahkan izin berikut pada `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-feature android:name="android.hardware.camera.ar" android:required="false" />
  <uses-feature android:name="android.hardware.camera" />
  ```
- Pastikan ARCore diaktifkan melalui [ARCore SDK setup](https://developers.google.com/ar/develop).

### Konfigurasi iOS
- Tambahkan entri berikut pada `ios/Runner/Info.plist`:
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Digunakan untuk pengalaman AR.</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>Digunakan untuk evaluasi pelafalan.</string>
  <key>NSPhotoLibraryAddUsageDescription</key>
  <string>Untuk menyimpan ekspor sesi.</string>
  ```
- Aktifkan ARKit capability pada target Xcode.

### Fallback Non-AR
Jika perangkat tidak mendukung ARCore/ARKit atau izin kamera ditolak, aplikasi otomatis menampilkan viewer 3D non-AR menggunakan `model_viewer_plus`. Pastikan file GLB/GLTF tersedia di `assets/models/`.

## Konten & Lokalisasi
- Lokalisasi menggunakan `intl` (`lib/l10n/`). Jalankan `make gen` setelah menambah string baru.
- Konten berada di `assets/content_packs/`. Struktur JSON:
  ```json
  {
    "id": "pack_basic_animals_v1",
    "title": {"en": "Basic Animals", "id": "Hewan Dasar"},
    "description": {"en": "Starter pack", "id": "Paket pemula"},
    "language": "en",
    "items": [
      {
        "id": "cat",
        "label": {"en": "Cat", "id": "Kucing"},
        "modelPath": "assets/models/cat.glb",
        "ttsText": {"en": "Cat", "id": "Kucing"},
        "tags": ["animal", "starter"],
        "difficulty": 1
      }
    ]
  }
  ```

### Menambah Content Pack Baru
1. Salin contoh di atas dan simpan sebagai `assets/content_packs/<nama_pack>.json`.
2. Pastikan setiap `modelPath` menunjuk ke file `.glb`/`.gltf` yang tersedia di `assets/models/`.
3. Jalankan `flutter pub get` bila perlu dan rebuild aplikasi.

## Firebase (Opsional)
- Tambahkan file `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS).
- Inisialisasi Firebase di `main.dart` atau gunakan flag fallback untuk menonaktifkan analytics/crashlytics bila belum tersedia.

## Testing & CI
- Jalankan semua pemeriksaan:
  ```sh
  make analyze
  make test
  make integration
  ```
- Laporan cakupan disimpan di `coverage/` setelah `make test`.

### CI/CD
Workflow GitHub Actions tersedia di `.github/workflows/ci.yaml` untuk menjalankan lint, test, dan build debug Android/iOS.

## Known Issues
- Aset GLB contoh berupa placeholder dan perlu diganti dengan model valid sebelum produksi.
- Integrasi Firebase memerlukan setup manual; tanpa file konfigurasi aplikasi berjalan dengan mode fallback.
- Plugin AR membutuhkan perangkat fisik; mode simulasi menggunakan viewer non-AR.

## Troubleshooting
- **Plugin AR tidak jalan**: pastikan perangkat mendukung ARCore/ARKit dan izin kamera diberikan.
- **Skor pelafalan tidak muncul**: cek koneksi internet untuk Google Speech; fallback offline belum tersedia.
- **Build iOS gagal**: jalankan `pod install` di direktori `ios/` setelah `flutter pub get`.

## Langkah Build Singkat
1. `flutter pub get`
2. `flutter run -d <device>`

Selamat berkarya dengan AURA+!
