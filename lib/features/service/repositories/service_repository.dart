import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/service_model.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ServiceModel>> getServices() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('services').get();

      return snapshot.docs.map((doc) {
        return ServiceModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  Future<List<ServiceModel>> getServicesBySeller(String sellerId) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore
              .collection('services')
              .where('seller_id', isEqualTo: sellerId)
              .get();
      return snapshot.docs.map((doc) {
        return ServiceModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('services').doc(serviceId).get();

      if (doc.exists) {
        return ServiceModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch service: $e');
    }
  }

  Future<List<ServiceModel>> getPromoServices() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore
              .collection('services')
              .where('discount', isGreaterThan: 0)
              .get();

      return snapshot.docs.map((doc) {
        return ServiceModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch promo services: $e');
    }
  }

  Future<Map<String, String>> getTimeSlotStatuses({
    required String serviceId,
    required ServiceModel service,
    required DateTime selectedDate,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, String> slotStatuses = {};

    // Format tanggal agar sesuai dengan yang disimpan di Firestore (YYYY-MM-DD)
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    int totalWorkers = service.workerNames.length;

    // Jika tidak ada slot waktu yang tersedia untuk layanan ini, kembalikan map kosong
    if (service.availableTimeSlots.isEmpty) {
      print("Tidak ada slot waktu yang terdefinisi untuk layanan ini.");
      return slotStatuses;
    }

    // Jika tidak ada pekerja yang terdefinisi, anggap semua slot tidak tersedia (atau handle sesuai bisnismu)
    if (totalWorkers == 0) {
      print(
        "Tidak ada pekerja yang terdefinisi untuk layanan ini, semua slot dianggap tidak tersedia.",
      );
      for (String timeSlot in service.availableTimeSlots) {
        slotStatuses[timeSlot] = "Booked"; // Atau "Unavailable"
      }
      return slotStatuses;
    }

    // Iterasi untuk setiap slot waktu yang tersedia di ServiceModel
    for (String timeSlot in service.availableTimeSlots) {
      try {
        // Query ke koleksi 'bookings'
        print(serviceId);
        QuerySnapshot bookingSnapshot =
            await firestore
                .collection('bookings')
                .where('serviceId', isEqualTo: serviceId)
                .where('date', isEqualTo: formattedDate)
                .where('startTime', isEqualTo: timeSlot)
                .get();

        int jumlahPekerjaYangSudahDipesanUntukJamIni =
            bookingSnapshot.docs.length;
        print(jumlahPekerjaYangSudahDipesanUntukJamIni);

        // Logika Pengecekan "Full" untuk Slot Jam
        if (jumlahPekerjaYangSudahDipesanUntukJamIni >= totalWorkers) {
          slotStatuses[timeSlot] = "Booked";
        } else {
          slotStatuses[timeSlot] = "Available";
        }
      } catch (e) {
        print("Error saat mengecek status slot $timeSlot: $e");
        slotStatuses[timeSlot] =
            "Error"; // Tandai sebagai error jika query gagal
      }
    }

    return slotStatuses;
  }

  Future<Map<String, String>> getWorkerStatusesForSlot({
    required String serviceId,
    required DateTime selectedDate,
    required String selectedTimeSlot,
    required ServiceModel service,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, String> workerStatuses =
        {}; // Format: {"Nama Pekerja": "Status"}

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    List<String> allWorkerNames = service.workerNames;

    // Jika tidak ada pekerja yang terdefinisi untuk layanan ini
    if (allWorkerNames.isEmpty) {
      print("Tidak ada pekerja yang terdefinisi untuk layanan ini.");
      return workerStatuses; // Kembalikan map kosong
    }

    try {
      print("--- Firestore Query Parameters (Worker Status) ---");
      print("serviceId: '$serviceId'");
      print("formattedDate: '$formattedDate'");
      print("selectedTimeSlot (startTime): '$selectedTimeSlot'");
      print("status: 'confirmed'");
      print("-----------------------------------------------");

      QuerySnapshot bookingSnapshot =
          await firestore
              .collection('bookings')
              .where('serviceId', isEqualTo: serviceId)
              .where('date', isEqualTo: formattedDate)
              .where(
                'startTime',
                isEqualTo: selectedTimeSlot,
              ) // Filter berdasarkan slot waktu yang dipilih
              .where('status', isEqualTo: 'confirmed')
              .get();

      List<String> bookedWorkerNames = [];
      for (var doc in bookingSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        // Pastikan field 'workerId' ada dan tidak null sebelum menambahkannya
        if (data.containsKey('workerId') && data['workerId'] != null) {
          bookedWorkerNames.add(data['workerId'] as String);
        }
      }
      print(
        "Pekerja yang sudah di-booking untuk slot $selectedTimeSlot di tanggal $formattedDate: $bookedWorkerNames",
      );

      // Tentukan status untuk setiap pekerja
      for (String workerName in allWorkerNames) {
        if (bookedWorkerNames.contains(workerName)) {
          workerStatuses[workerName] = "Booked";
        } else {
          workerStatuses[workerName] = "Available";
        }
      }
    } catch (e) {
      print(
        "Error saat mengecek status pekerja untuk slot $selectedTimeSlot: $e",
      );
      // Jika terjadi error, tandai semua pekerja sebagai Error atau sesuai kebijakanmu
      for (String workerName in allWorkerNames) {
        workerStatuses[workerName] = "Error";
      }
    }
    print("Hasil status pekerja: $workerStatuses");
    return workerStatuses;
  }

  Future<String> uploadImageToCloudinary(File file) async {
    final cloudName = 'dxk0ttpjw'; // Ganti dengan cloudname kamu
    final uploadPreset = 'services'; // Ganti dengan upload preset kamu

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request =
        http.MultipartRequest('POST', uri)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final res = await response.stream.bytesToString();
      final jsonRes = json.decode(res);
      return jsonRes['secure_url'];
    } else {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
  }

  // 🔹 Fungsi 2: Create Service (upload semua gambar + simpan ke Firestore)
  Future<void> createServiceWithImages({
    required String name,
    required String address,
    required int price,
    required int discount,
    required String linkMaps,
    required List<Facility> facilities,
    required File mainImage,
    required List<File> additionalPhotos,
    required String sellerId,
    required int duration,
    required List<String> workerNames,
  }) async {
    try {
      // Upload gambar utama
      final mainImageUrl = await uploadImageToCloudinary(mainImage);

      // Upload gambar tambahan
      final List<String> additionalImageUrls = [];
      for (final photo in additionalPhotos) {
        final url = await uploadImageToCloudinary(photo);
        additionalImageUrls.add(url);
      }

      // Buat ServiceModel
      final newService = ServiceModel(
        id: '', // Akan dibuat otomatis oleh Firestore
        name: name,
        address: address,
        image: mainImageUrl,
        range: 0.0,
        rating: 0.0,
        discount: discount,
        price: price,
        linkMaps: linkMaps,
        facilities: facilities,
        photos: additionalImageUrls,
        reviews: [],
        seller_id: sellerId,
        serviceDurationMinutes: duration,
        operatingDays: [
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday",
        ],
        availableTimeSlots: [
          "08:00",
          "09:00",
          "10:00",
          "11:00",
          "13:00",
          "14:00",
          "15:00",
          "16:00",
        ],
        workerNames: workerNames,
      );

      // Simpan ke Firestore
      await _firestore.collection('services').add(newService.toJson());
    } catch (e) {
      throw Exception('Gagal membuat layanan: $e');
    }
  }

  Future<void> deleteServiceById(String serviceId) async {
    await FirebaseFirestore.instance
        .collection('services')
        .doc(serviceId)
        .delete();
  }
}
