import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({Key? key}) : super(key: key);

  @override
  State<FirestorePage> createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  List<Map<String, dynamic>> dummyData = [
    {
      "name": "Layanan Potong Rumput",
      "discount": 10,
      "image": "https://example.com/images/potong-rumput.jpg",
      "address": "Jl. Melati No. 23, Jakarta",
      "rating": 4.2,
      "price": 150000,
      "link_maps": "https://goo.gl/maps/xyz123",
      "facilities": {
        "Peralatan": "Mesin Pemotong Rumput Modern",
        "Waktu Pemotongan": "60 menit - Selesai",
        "Penyiraman Tanaman": "Termasuk",
        "Jumlah Pekerja": 3,
        "Perawatan Tanaman": "Termasuk"
      },
      "photos": [
        "https://example.com/images/potong-rumput-1.jpg",
        "https://example.com/images/potong-rumput-2.jpg"
      ],
      "reviews": [
        {
          "uid": "user123",
          "user_name": "Budi",
          "user_photo": "https://example.com/images/budi.jpg",
          "message": "Layanannya cepat dan rapi.",
          "rating": 4.5
        }
      ]
    },
    {
      "name": "Layanan Cuci Mobil",
      "discount": 0,
      "image": "https://example.com/images/cuci-mobil.jpg",
      "address": "Jl. Kenanga No. 10, Bandung",
      "rating": 4.7,
      "price": 80000,
      "link_maps": "https://goo.gl/maps/abc456",
      "facilities": {
        "Jenis Cuci": "Cuci Steam",
        "Waktu Pengerjaan": "30-45 menit",
        "Waxing": "Opsional",
        "Interior Cleaning": "Termasuk",
        "Jumlah Pekerja": 2
      },
      "photos": [
        "https://example.com/images/cuci-mobil-1.jpg",
        "https://example.com/images/cuci-mobil-2.jpg"
      ],
      "reviews": [
        {
          "uid": "user456",
          "user_name": "Siti",
          "user_photo": "https://example.com/images/siti.jpg",
          "message": "Mobil bersih seperti baru!",
          "rating": 5.0
        }
      ]
    },
    {
      "name": "Layanan Perawatan AC",
      "discount": 5,
      "image": "https://example.com/images/perawatan-ac.jpg",
      "address": "Jl. Mawar No. 5, Surabaya",
      "rating": 4.3,
      "price": 120000,
      "link_maps": "https://goo.gl/maps/def789",
      "facilities": {
        "Pembersihan AC": "Termasuk",
        "Penggantian Filter": "Opsional",
        "Waktu Pengerjaan": "45 menit - 1 jam",
        "Jumlah Pekerja": 1,
        "Garansi": "1 Bulan"
      },
      "photos": [
        "https://example.com/images/perawatan-ac-1.jpg"
      ],
      "reviews": [
        {
          "uid": "user789",
          "user_name": "Andi",
          "user_photo": "https://example.com/images/andi.jpg",
          "message": "AC jadi dingin lagi, puas banget!",
          "rating": 4.0
        }
      ]
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post to Firestore')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // addMultipleServices(dummyData);
            await createBooking(
                userId: 'user_001',
                serviceId: 'potong-rumput-1747389442365',
                workerId: 'pekerja_3',
                date: '2025-05-19',
                time: '16:00',
            );

          },
          child: const Text("Tambah Data"),
        ),
      ),
    );
  }
}
