## Tugas Pemrograman Mobile
### Aplikasi To-Do List (Hive + Provider)

### Deskripsi Aplikasi
1. Aplikasi ini merupakan aplikasi daftar tugas (To-Do List) sederhana yang berfungsi untuk menambahkan, mengedit, menandai, dan menghapus tugas.
2. Data disimpan secara lokal menggunakan Hive, sehingga tetap tersimpan walaupun aplikasi ditutup.
3. Menggunakan Provider sebagai state management untuk pengelolaan data dan pembaruan tampilan.

Aplikasi terdiri dari tiga halaman utama:
1. Halaman beranda untuk melihat daftar tugas.
2. Halaman tambah tugas.
3. Halaman edit tugas.

### Fitur Utama
1. Menambah to-do baru
2. Mengedit judul to-do yang sudah ada
3. Menandai tugas selesai atau belum selesai
4. Menghapus satu tugas
5. Menghapus semua tugas sekaligus dengan konfirmasi
6. Menyimpan data secara lokal menggunakan Hive
7. Menampilkan tampilan kosong jika belum ada data
8. Memiliki validasi agar input tidak boleh kosong

### Flow CRUD
**Create:** Pengguna dapat menambah data baru melalui halaman tambah to-do.
**Read:** Semua data ditampilkan secara otomatis di halaman utama menggunakan ListView.
**Update:** Pengguna dapat mengubah judul to-do atau menandai statusnya.
**Delete:** Data dapat dihapus satu per satu atau seluruhnya sekaligus.

Aplikasi ini dibuat menggunakan Flutter dengan beberapa library tambahan, yaitu:
1. Hive sebagai penyimpanan data lokal
2. Provider sebagai state management
3. Material 3 sebagai tema utama aplikasi

### Struktur Folder
**models/** berisi model data `Todo` dan adapter Hive
**providers/** berisi logika penyimpanan dan fungsi CRUD
**screens/** berisi halaman utama, tambah, dan edit tugas
**views/** berisi tampilan tambahan seperti halaman kosong
**widgets/** berisi widget terpisah seperti tampilan kartu tugas

### Implementasi Data Persistence
1. Aplikasi menggunakan Hive untuk menyimpan data secara permanen.
2. Inisialisasi Hive dilakukan di `main.dart` dan adapter `TodoAdapter` diregistrasikan agar Hive dapat mengenali model `Todo`.
3. Semua operasi penyimpanan dan pengambilan data dilakukan melalui `TodoProvider`, yang terhubung dengan UI menggunakan `ChangeNotifier`.
4. Dengan cara ini, setiap kali data berubah, tampilan akan otomatis diperbarui tanpa harus melakukan refresh manual.

### State Management
Provider digunakan untuk mengatur data dan memastikan tampilan selalu sinkron dengan perubahan data.
Fungsi seperti tambah, edit, hapus, dan ubah status terdapat di todo_provider.dart.
Setiap kali data berubah, notifyListeners() dipanggil agar halaman utama menampilkan pembaruan secara langsung.


### Tampilan Aplikasi
Halaman **Home** menampilkan daftar to-do dan tombol untuk menambah atau menghapus semua data.
Halaman **Add To-Do** digunakan untuk menambahkan tugas baru dengan form yang memiliki validasi.
Halaman **Edit To-Do** digunakan untuk mengubah judul tugas atau menghapusnya.
Tampilan **EmptyViews** muncul jika belum ada data yang tersimpan, dan memberi pilihan untuk membuat to-do pertama.

Warna latar kartu menyesuaikan status tugas, yaitu hijau untuk tugas yang sudah selesai dan oranye untuk yang belum selesai.