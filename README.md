# Myportofolio Mobile Edition

Nama  : Zayyan Ramadzaki Firdaus

NPM   : 2506550955

Kelas : PBP F

## Requirements & Installation

1. Instal [Flutter SDK](https://docs.flutter.dev/get-started/install). Periksa environment dengan `flutter doctor`.
2. Clone repositori ini, lalu masuk ke direktori proyek.
3. Jalankan `flutter pub get`, lalu `dart run build_runner build --delete-conflicting-outputs` untuk menghasilkan serialisasi model.
4. Jalankan backend Django dan migrasinya. Gunakan `flutter run` untuk emulator Android, atau `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000` untuk Chrome.
5. Untuk perangkat fisik, jalankan `adb reverse tcp:8000 tcp:8000`, lalu `flutter run --dart-define=API_BASE_URL=http://localhost:8000`. Untuk server terpasang, ganti URL dengan URL HTTPS server.
6. Jalankan `flutter analyze` dan `flutter test` untuk memeriksa aplikasi.

Daftar proyek dan edukasi dapat dibaca tanpa login. Penambahan data memerlukan akun superuser; token disimpan dalam memori sampai logout atau aplikasi ditutup. Untuk build APK CI yang terhubung ke backend terpasang, atur variabel GitHub Actions `API_BASE_URL` tanpa garis miring di akhir; tanpa variabel ini APK menggunakan alamat emulator lokal.

## Progres mingguan

- **Tutorial 08:** Inisialisasi proyek Flutter, memisahkan halaman menu ke `lib/menu.dart`, dan membuat halaman utama stateless dengan kartu informasi serta aksi.
- **Tugas 7:** Melengkapi identitas pribadi, membedakan warna setiap action melalui model `ItemHomepage`, mempertahankan feedback SnackBar, dan memperbarui pengujian serta dokumentasi.
- **Tutorial 09:** Menambahkan drawer, navigasi ke formulir proyek, validasi dan dialog data proyek. Halaman berada di `lib/screens/`, sedangkan drawer dan kartu aksi berada di `lib/widgets/`. Data formulir hanya ditampilkan di dialog dan belum disimpan.
- **Tugas 8:** Menambahkan formulir edukasi yang bisa dibuka lewat kartu aksi dan drawer. Isi formulir divalidasi lalu ditampilkan dalam dialog, belum disimpan secara permanen.
- **Tutorial 10 dan Tugas 9:** Menyinkronkan proyek dan edukasi dengan API Django, termasuk login token, daftar, detail, dan formulir terautentikasi.

## Penggunaan AI

Pengerjaan **Tugas 7** dibantu Google Overview melalui Google Search. Dipergunakan untuk debugging saat terjadi kesalahan serta memeriksa command yang tersedia untuk aplikasi Flutter.

Untuk **Tugas 8**, saya menggunakan DeepSeek v4.1 Flash untuk menjelaskan beberapa konsep yang masih belum saya pahami sepenuhnya seperti perbedaan `pushReplacement` dengan `pop` dan peran `GlobalKey<FormState>`. Instruksi yang saya berikan seputar menjelaskan apa perbedaan antara keduanya, bagaimana penggunaannya, dan penyelerasan pemahaman. Percakapn dapat dilihat [di sini](https://chat.deepseek.com/share/cpwxdrz371n1jluerk).

AI tidak selalu benar dan bisa saja menggunakan context atau pengetahuan yang sudah kadaluarsa/outdated atau yang terparahnya tidak tersedia (hallucination). Sehingga manusia tetap diperlukan untuk memeriksa kembali jawaban yang diberikan oleh Generative AI, seperti memeriksa langsung pada dokumentasi resmi Flutter, atau melihat arsip atau repository developer lain yang sudah terverifikasi. Dokumentasi Flutter yang saya gunakan dapat diakses [di sini](https://docs.flutter.dev/cookbook/navigation/navigation-basics).

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

### Tugas 8

1. `Navigator.push()` menambahkan halaman baru ke atas stack, jadi halaman sebelumnya masih ada dan bisa dituju lagi dengan kembali. `Navigator.pushReplacement()` mengganti halaman yang sedang aktif dengan halaman baru, sedangkan `Navigator.pop()` mengeluarkan halaman atau dialog teratas dari stack. Untuk kartu Tambah Edukasi saya menggunakan `push`, jadi tombol kembali perangkat bisa membawa pengguna ke halaman sebelumnya. Untuk Home di drawer, `pushReplacement` mengganti halaman formulir dengan halaman utama yang baru, bukan mencari halaman utama lama di stack.

2. `Scaffold` menyediakan kerangka halaman seperti tempat untuk `AppBar`, drawer, dan body. Dengan begitu susunan dasarnya tetap sama walaupun isi setiap halaman berbeda. `AppBar` memberikan judul dan akses navigasi, sedangkan `LeftDrawer` yang sama dipakai di halaman utama dan formulir agar pilihannya konsisten. Contoh warna yang dipakai di lebih dari satu halaman adalah warna primary dari tema indigo pada `AppBar` halaman utama dan formulir edukasi.

3. Saya menyusun input secara vertikal dengan `Column` karena field edukasi dibaca dan diisi satu per satu. `Padding` memberi ruang di sekitar formulir, sementara `SizedBox` memberi jarak antar input dan tombol supaya tidak terlalu berdesakan. Saat layar pendek atau keyboard muncul, `SingleChildScrollView` memungkinkan isi digulir sampai tombol Simpan tetap bisa dijangkau.

4. `GlobalKey<FormState>` memberikan akses ke state formulir dari tombol Simpan. Saat tombol ditekan, `validate()` menjalankan validator setiap input dan menampilkan pesan pada kolom yang salah, dialog baru muncul kalau semuanya valid. Misalnya, institusi yang hanya berisi spasi ditolak karena setelah `trim()` nilainya kosong. Untuk tanggal mulai saya menggunakan `showDatePicker` supaya pilihan tanggal lebih mudah dan dibatasi dari tahun 1900 sampai hari ini. Walaupun begitu, pemilihan tanggal saja belum cukup karena pengguna bisa menutup picker tanpa memilih apa pun, jadi validator tetap memeriksa apakah tanggal sudah diisi.
