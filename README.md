# Myportofolio Mobile Edition

Nama  : Zayyan Ramadzaki Firdaus

NPM   : 2506550955

Kelas : PBP F

## Requirements & Installation

1. Instal [Flutter SDK](https://docs.flutter.dev/get-started/install). Periksa environment dengan `flutter doctor`.
2. Clone repositori ini, lalu masuk ke direktori proyek.
3. Jalankan `flutter pub get` untuk memasang dependensi.
4. Jalankan `flutter run` dan pilih devices. Untuk web (chrome), gunakan `flutter run -d chrome`.
5. Jalankan `flutter analyze` untuk analisis dan `flutter test` untuk pengujian widget.

## Progres mingguan

- **Tutorial 08:** Inisialisasi proyek Flutter, memisahkan halaman menu ke `lib/menu.dart`, dan membuat halaman utama stateless dengan kartu informasi serta aksi.
- **Tugas 7:** Melengkapi identitas pribadi, membedakan warna setiap action melalui model `ItemHomepage`, mempertahankan feedback SnackBar, dan memperbarui pengujian serta dokumentasi.
- **Tutorial 09:** Menambahkan drawer, navigasi ke formulir proyek, validasi dan dialog data proyek. Halaman berada di `lib/screens/`, sedangkan drawer dan kartu aksi berada di `lib/widgets/`. Data formulir hanya ditampilkan di dialog dan belum disimpan.

## Penggunaan AI

Pengerjaan Tugas 7 dibantu Google Overview melalui Google Search. Dipergunakan untuk debugging saat terjadi kesalahan serta memeriksa command yang tersedia untuk aplikasi Flutter.

## Pertanyaan reflektif

### Tugas 7

1. Widget tree adalah struktur hierarkis pada Flutter yang dimana parent widget bisa menyusun widget children melalui properti seperti `child` atau `children`, children dapat punya children lain. Misalnya, `Scaffold` memiliki `body` berupa `SingleChildScrollView`, yang membungkus `Padding` dan `Column`. Flutter menggunakan konfigurasi widget ini untuk membangun dan memperbarui element tree serta render tree. Hubungan tersebut menentukan komposisi, scope, dan access ke data dari ancestor tertentu.

2. Widget yang digunakan:
   - `MyApp`: widget root aplikasi yang mengonfigurasi `MaterialApp`
   - `MaterialApp`: menyediakan konfigurasi aplikasi Material, tema, dan halaman awal
   - `MyHomePage`: menyusun halaman profil dan daftar aksi dengan `StatelessWidget`
   - `Scaffold`: menyediakan struktur halaman Material, termasuk `AppBar`, body, dan tempat SnackBar ditampilkan melalui `ScaffoldMessenger`
   - `AppBar`: menampilkan judul di bagian atas
   - `SingleChildScrollView`: memungkinkan konten digulir saat tinggi layar terbatas
   - `Padding`: memberi jarak di sekeliling widget children
   - `Column`: menyusun children secara vertikal
   - `InfoCard`: komponen buatan untuk label dan nilai identitas
   - `Card`: menyediakan permukaan kartu informasi
   - `Container`: mengatur lebar atau padding konten kartu
   - `Text`: menampilkan judul, identitas, label aksi, dan pesan SnackBar
   - `SizedBox`: menyediakan jarak vertikal antarteks dan bagian halaman
   - `Center`: memusatkan konten children
   - `GridViewcount`: menyusun kartu aksi dalam kisi dua kolom
   - `ItemCard`: komponen buatan untuk menampilkan dan menangani satu aksi
   - `Material`: menyediakan permukaan berwarna dan tempat efek tinta ditampilkan
   - `InkWell`: mendeteksi ketukan dan menampilkan respons visual pada permukaan Material
   - `Icon`: menampilkan ikon aksi
   - `SnackBar`: menampilkan pesan sementara setelah aksi ditekan

   `ItemHomepage` adalah model data, bukan widget. `ThemeData`, `TextStyle`, dan `EdgeInsets` juga merupakan object

3. `MaterialApp` merangkai fasilitas aplikasi berbasis Material, termasuk tema, navigasi, lokalisasi, dan konfigurasi halaman awal. Widget ini lazim ditempatkan dekat root agar halaman descendantnya dapat menggunakan fasilitas dan tema yang konsisten. `MyApp` menjadi root pada proyek ini, sedangkan `MaterialApp` merupakan childrennya

4. `StatelessWidget` tidak menyimpan state yang dapat berubah di dalam instance widget, tetapi tampilannya ditentukan oleh konfigurasi dan data yang diwarisi saat `build`. Widget ini tetap dapat dibangun ulang ketika parent atau dependensinya berubah. `StatefulWidget` dipasangkan dengan object `State` yang dapat menyimpan data selama siklus hidupnya dan memanggil `setState` untuk meminta pembaruan tampilan. Gunakan stateless untuk tampilan yang tidak perlu mengelola state lokal, bisa jg gunakan stateful saat interaksi atau proses async mengubah data lokal yang harus muncul di layar, misalnya input formulir atau pilihan tab

5. `BuildContext` adalah pointer ke lokasi sebuah widget dalam element tree. Dalam `build`, context memungkinkan widget mengakses ancestor dan data turunan, seperti `Theme.of(context)`. Pada `ItemCard`, `ScaffoldMessenger.of(context)` menemukan messenger terdekat untuk menampilkan SnackBar. Context harus berada di bawah ancestor yang dicari. Setelah operasi async, periksa `context.mounted` sebelum menggunakannya karena widget mungkin saja dikeluarkan dari tree

6. Hot reload melakukan perubahan kode Dart dan rebuild widget sambil mempertahankan state aplikasi, biasanya cocok untuk mengubah tampilan atau metode `build`. Hot restart menjalankan ulang aplikasi Dart dari awal dan menghapus state, sehingga cocok ketika perubahan inisialisasi atau state awal tidak tercermin oleh hot reload. Perubahan kode native Android/iOS, konfigurasi build, atau dependensi native umumnya memerlukan penghentian dan pembangunan ulang aplikasi (full restart). Tidak semua perubahan struktur kode didukung hot reload, sehingga pesan Flutter dan hasil aktual tetap perlu diperiksa
