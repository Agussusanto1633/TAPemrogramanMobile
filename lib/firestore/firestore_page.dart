import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({super.key});

  @override
  State<FirestorePage> createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage>
{List<Map<String, dynamic>> dummyData = [
  {
    "name": "Layanan Potong Rumput",
    "discount": 10,
    "image": "https://res.cloudinary.com/dxk0ttpjw/image/upload/v1747721285/istockphoto-1346411253-640x640_1_qekbf1.png",
    "address": "Jl. Melati No. 23, Jakarta",
    "rating": 4.2,
    "price": 150000, // Nama field tetap "price"
    "link_maps": "https://goo.gl/maps/xyz123",
    "facilities": {
      "Peralatan": "Mesin Pemotong Rumput Modern",
      "Waktu Pemotongan": "60 menit - Selesai",
      "Penyiraman Tanaman": "Termasuk",
      "Jumlah Pekerja": 3,
      "Perawatan Tanaman": "Termasuk"
    },
    "photos": [
      "https://res.cloudinary.com/dxk0ttpjw/image/upload/v1747721965/image_65_rmhbnb.png",
      "https://res.cloudinary.com/dxk0ttpjw/image/upload/v1747721965/image_64_edyvdm.png",
      "https://res.cloudinary.com/dxk0ttpjw/image/upload/v1747721948/image_66_neasts.png" // Memperhatikan spasi di akhir URL jika ada
    ],
    "reviews": [
      {
        "uid": "user123",
        "user_name": "Budi",
        "user_photo": "https://example.com/images/budi.jpg",
        "message": "Layanannya cepat dan rapi.",
        "rating": 4.5
      }
    ],
    // --- Tambahan untuk booking ---
    "serviceDurationMinutes": 60,
    "operatingDays": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    "availableTimeSlots": ["09:00", "10:30", "13:00", "14:30", "16:00"],
    "workerNames": ["Pekerja Taman A", "Pekerja Taman B", "Pekerja Taman C"]
  },
  {
    "name": "Layanan Cuci Mobil",
    "discount": 0,
    "image": "https://res.cloudinary.com/dxk0ttpjw/image/upload/v1747728300/istockphoto-1346411253-640x640_1_gbd5qj.png",
    "address": "Jl. Kenanga No. 10, Bandung",
    "rating": 4.7,
    "price": 80000, // Nama field tetap "price"
    "link_maps": "https://goo.gl/maps/abc456",
    "facilities": {
      "Jenis Cuci": "Cuci Steam",
      "Waktu Pengerjaan": "30-45 menit",
      "Waxing": "Opsional",
      "Interior Cleaning": "Termasuk",
      "Jumlah Pekerja": 2
    },
    "photos": [
      "https://res.cloudinary.com/dxk0ttpjw/image/upload/v1747728273/image_66_nwkdph.png",
      "https://res.cloudinary.com/dxk0ttpjw/image/upload/v1747728333/image_64_esrqgz.png",
      "https://res.cloudinary.com/dxk0ttpjw/image/upload/v1747728325/image_65_foo8yv.png"
    ],
    "reviews": [
      {
        "uid": "user456",
        "user_name": "Siti",
        "user_photo": "https://example.com/images/siti.jpg",
        "message": "Mobil bersih seperti baru!",
        "rating": 5.0
      }
    ],
    // --- Tambahan untuk booking ---
    "seller_id": "seller789",
    "serviceDurationMinutes": 45,
    "operatingDays": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "availableTimeSlots": ["08:00", "09:00", "10:00", "11:00", "13:00", "14:00", "15:00", "16:00"],
    "workerNames": ["Pencuci Mobil X", "Pencuci Mobil Y"]
  },
  {
    "name": "Layanan Perawatan AC",
    "discount": 5,
    "image": "https://www.serviceaccibubur.com/wp-content/uploads/2021/06/cuci-ac.jpg",
    "address": "Jl. Mawar No. 5, Surabaya",
    "rating": 4.3,
    "price": 120000, // Nama field tetap "price"
    "link_maps": "https://goo.gl/maps/def789",
    "facilities": {
      "Pembersihan AC": "Termasuk",
      "Penggantian Filter": "Opsional",
      "Waktu Pengerjaan": "45 menit - 1 jam",
      "Jumlah Pekerja": 1,
      "Garansi": "1 Bulan"
    },
    "photos": [
      "https://www.serviceaccibubur.com/wp-content/uploads/2021/06/cuci-ac.jpg",
      "https://siopen.hulusungaiselatankab.go.id/storage/merchant/products/2023/10/12/95a8f4da996516b348cb705890693dbb.jpg",
      "https://www.abangbenerin.com/blog/wp-content/uploads/2021/08/service-ac-1200x675.jpg"
    ],
    "reviews": [
      {
        "uid": "user789",
        "user_name": "Andi",
        "user_photo": "https://example.com/images/andi.jpg",
        "message": "AC jadi dingin lagi, puas banget!",
        "rating": 4.0
      }
    ],
    // --- Tambahan untuk booking ---
    "serviceDurationMinutes": 60,
    "operatingDays": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    "availableTimeSlots": ["09:00", "10:30", "13:00", "14:30", "16:00"],
    "workerNames": ["Teknisi AC Handal"]
  }
];

// Dummy data untuk koleksi 'bookings'
// Setiap map di dalam list ini merepresentasikan satu dokumen booking
List<Map<String, dynamic>> dummyBookings = [
  // --- Booking untuk Layanan Potong Rumput (service_01_potong_rumput) ---
  // Durasi: 60 menit, Pekerja: ["Pekerja Taman A", "Pekerja Taman B", "Pekerja Taman C"], Harga: 150000
  // Slot tersedia (contoh): ["09:00", "10:30", "13:00", "14:30", "16:00"]
  {
    "userId": "user_alpha_123",
    "serviceId": "service_01_potong_rumput", // Merujuk ke layanan potong rumput
    "workerId": "Pekerja Taman A",          // Salah satu pekerja dari layanan tersebut
    "date": "2025-06-10",                   // Contoh tanggal booking (Selasa)
    "startTime": "09:00",
    "endTime": "10:00",                     // startTime + 60 menit
    "status": "confirmed",
    "price": 150000,
    "createdAt": "2025-05-28T08:30:00Z"     // Placeholder untuk Firestore Timestamp
  },
  {
    "userId": "user_beta_456",
    "serviceId": "service_01_potong_rumput",
    "workerId": "Pekerja Taman B",
    "date": "2025-06-10",                   // Tanggal dan slot yang sama, pekerja beda
    "startTime": "09:00",
    "endTime": "10:00",
    "status": "confirmed",
    "price": 150000,
    "createdAt": "2025-05-29T11:00:00Z"
  },
  // Slot 10:30 untuk Potong Rumput akan dibuat penuh (3 pekerja)
  {
    "userId": "user_gamma_789",
    "serviceId": "service_01_potong_rumput",
    "workerId": "Pekerja Taman A",
    "date": "2025-06-11",                   // Rabu
    "startTime": "10:30",
    "endTime": "11:30",
    "status": "confirmed",
    "price": 150000,
    "createdAt": "2025-05-30T09:15:00Z"
  },
  {
    "userId": "user_delta_012",
    "serviceId": "service_01_potong_rumput",
    "workerId": "Pekerja Taman B",
    "date": "2025-06-11",
    "startTime": "10:30",
    "endTime": "11:30",
    "status": "confirmed",
    "price": 150000,
    "createdAt": "2025-05-30T09:20:00Z"
  },
  {
    "userId": "user_epsilon_345",
    "serviceId": "service_01_potong_rumput",
    "workerId": "Pekerja Taman C",
    "date": "2025-06-11",
    "startTime": "10:30", // Slot 10:30 kini penuh untuk layanan potong rumput di tanggal ini
    "endTime": "11:30",
    "status": "confirmed",
    "price": 150000,
    "createdAt": "2025-05-30T10:00:00Z"
  },

  // --- Booking untuk Layanan Cuci Mobil (service_02_cuci_mobil) ---
  // Durasi: 45 menit, Pekerja: ["Pencuci Mobil X", "Pencuci Mobil Y"], Harga: 80000
  // Slot tersedia (contoh): ["08:00", "09:00", "10:00", ...]
  {
    "userId": "user_alpha_123",
    "serviceId": "service_02_cuci_mobil",    // Merujuk ke layanan cuci mobil
    "workerId": "Pencuci Mobil X",
    "date": "2025-06-12",                   // Kamis
    "startTime": "08:00",
    "endTime": "08:45",                     // startTime + 45 menit
    "status": "confirmed",
    "price": 80000,
    "createdAt": "2025-06-01T14:00:00Z"
  },
  {
    "userId": "user_zeta_678",
    "serviceId": "service_02_cuci_mobil",
    "workerId": "Pencuci Mobil Y",
    "date": "2025-06-12",
    "startTime": "09:00",
    "endTime": "09:45",
    "status": "pending_payment", // Contoh status berbeda
    "price": 80000,
    "createdAt": "2025-06-02T10:00:00Z"
  },

  // --- Booking untuk Layanan Perawatan AC (service_03_perawatan_ac) ---
  // Durasi: 60 menit, Pekerja: ["Teknisi AC Handal"], Harga: 120000
  // Slot tersedia (contoh): ["09:00", "10:30", ...]
  {
    "userId": "user_beta_456",
    "serviceId": "service_03_perawatan_ac", // Merujuk ke layanan AC
    "workerId": "Teknisi AC Handal",       // Hanya ada 1 pekerja
    "date": "2025-06-13",                   // Jumat
    "startTime": "09:00", // Slot ini sekarang penuh untuk layanan AC di tanggal ini karena hanya 1 pekerja
    "endTime": "10:00",                     // startTime + 60 menit
    "status": "confirmed",
    "price": 120000,
    "createdAt": "2025-06-03T16:00:00Z"
  }
];

  Future<void> createBooking({
    required String userId,
    required String serviceId,
    required String workerId,
    required String date, // Format: YYYY-MM-DD
    required String time, // Format: HH:mm
  }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final bookings = firestore.collection('bookings');

    try {
      // Cek apakah worker sudah terbooking di waktu tersebut
      final snapshot = await bookings
          .where('service_id', isEqualTo: serviceId)
          .where('worker_id', isEqualTo: workerId)
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print("⚠️ Worker sudah dibooking di jam ini!");
        return;
      }

      // Data booking baru
      final newBooking = {
        'user_id': userId,
        'service_id': serviceId,
        'worker_id': workerId,
        'date': date,
        'time': time,
        'status': 'confirmed',
        'created_at': FieldValue.serverTimestamp(),
      };

      await bookings.add(newBooking);
      print("✅ Booking berhasil ditambahkan!");
    } catch (e) {
      print("❌ Gagal menambahkan booking: $e");
    }
  }


  Future<void> addMultipleServices(List<Map<String, dynamic>> servicesData) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    for (var serviceData in servicesData) {
      String rawName = serviceData['name'].toString().toLowerCase().trim();

      // Hapus kata 'layanan' jika ada dan trim spasi berlebih
      String cleanName = rawName.replaceAll('layanan', '').trim();
      print("Clean Name (tanpa layanan): $cleanName");

      // Ganti spasi dengan strip
      String baseId = cleanName.replaceAll(RegExp(r'\s+'), '-');
      print("Base ID: $baseId");

      // Timestamp untuk memastikan ID unik
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String customId = "$baseId-$timestamp";

      print("Generated ID: $customId");

      DocumentReference docRef = firestore.collection('services').doc(customId);

      batch.set(docRef, serviceData);

      // Delay singkat agar timestamp berbeda
      await Future.delayed(Duration(milliseconds: 1));
    }

    try {
      await batch.commit();
      print("Semua data berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan data: $e");
    }
  }


Future<void> addMultipleBookings(List<Map<String, dynamic>> bookingsData) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  WriteBatch batch = firestore.batch();

  for (var bookingData in bookingsData) {
    // Membuat ID kustom untuk booking
    // Mengambil beberapa bagian informasi untuk membuat ID yang agak informatif
    // dan menambahkan timestamp untuk keunikan.

    // 1. Ambil serviceId dan bersihkan sedikit
    String serviceIdRaw = bookingData['serviceId']?.toString() ?? 'unknown-service';
    String serviceIdClean = serviceIdRaw.toLowerCase()
        .replaceAll('_', '-') // Ganti underscore dengan strip
        .replaceAll(RegExp(r'[^a-z0-9\-]'), ''); // Hanya alphanumeric dan strip

    // 2. Ambil tanggal dan format (misal, hilangkan strip)
    String dateRaw = bookingData['date']?.toString() ?? 'nodate';
    String dateClean = dateRaw.replaceAll('-', '');

    // 3. Ambil userId (opsional, bisa ditambahkan jika ingin ID lebih spesifik)
    // String userIdRaw = bookingData['userId']?.toString() ?? 'nouser';
    // String userIdClean = userIdRaw.substring(0, (userIdRaw.length < 5) ? userIdRaw.length : 5); // Ambil bbrp karakter awal

    // Membuat baseId
    // Format: "b-<serviceIdClean>-<dateClean>"
    // "b" sebagai prefix untuk booking
    String baseId = "b-$serviceIdClean-$dateClean";
    if (kDebugMode) {
      print("Booking Base ID components: serviceIdClean='$serviceIdClean', dateClean='$dateClean'");
      print("Booking Base ID: $baseId");
    }


    // 4. Timestamp untuk memastikan ID unik
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String customId = "$baseId-$timestamp";

    if (kDebugMode) {
      print("Generated Booking ID: $customId");
    }

    DocumentReference docRef = firestore.collection('bookings').doc(customId);

    // Menyiapkan data untuk ditambahkan.
    // Jika ada field 'createdAt' dan ingin menggunakan server timestamp:
    // Map<String, dynamic> dataToAdd = Map.from(bookingData);
    // if (dataToAdd.containsKey('createdAt')) {
    //   dataToAdd['createdAt'] = FieldValue.serverTimestamp();
    // }
    // batch.set(docRef, dataToAdd);
    //
    // Namun, jika dummy data 'createdAt' sudah berupa string dan ingin disimpan apa adanya:
    batch.set(docRef, bookingData);


    // Delay singkat agar timestamp berbeda jika loop berjalan sangat cepat
    // Ini penting untuk keunikan ID jika beberapa booking dibuat dalam milidetik yang sama
    // oleh proses ini.
    await Future.delayed(const Duration(milliseconds: 2)); // Sedikit lebih lama untuk memastikan
  }

  try {
    await batch.commit();
    print("Semua data booking berhasil ditambahkan!");
  } catch (e) {
    print("Gagal menambahkan data booking: $e");
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post to Firestore')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // addMultipleServices(dummyData);
            addMultipleBookings(dummyBookings);
            // await createBooking(
            //     userId: 'user_001',
            //     serviceId: 'potong-rumput-1747389442365',
            //     workerId: 'pekerja_3',
            //     date: '2025-05-19',
            //     time: '16:00',
            // );

          },
          child: const Text("Tambah Data"),
        ),
      ),
    );
  }
}
