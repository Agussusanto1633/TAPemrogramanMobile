import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../model/service_model.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ServiceModel>> getServices() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('services').get();

      return snapshot.docs.map((doc) {
        return ServiceModel.fromJson(
            doc.data() as Map<String, dynamic>,
            doc.id
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('services')
          .doc(serviceId)
          .get();

      if (doc.exists) {
        return ServiceModel.fromJson(
            doc.data() as Map<String, dynamic>,
            doc.id
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch service: $e');
    }
  }

  Future<List<ServiceModel>> getPromoServices() async {
    try {
      final QuerySnapshot snapshot = await _firestore
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
      print("Tidak ada pekerja yang terdefinisi untuk layanan ini, semua slot dianggap tidak tersedia.");
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
        QuerySnapshot bookingSnapshot = await firestore
            .collection('bookings')
            .where('serviceId', isEqualTo: serviceId)
            .where('date', isEqualTo: formattedDate)
            .where('startTime', isEqualTo: timeSlot)
            .get();

        int jumlahPekerjaYangSudahDipesanUntukJamIni = bookingSnapshot.docs.length;
        print(jumlahPekerjaYangSudahDipesanUntukJamIni);

        // Logika Pengecekan "Full" untuk Slot Jam
        if (jumlahPekerjaYangSudahDipesanUntukJamIni >= totalWorkers) {
          slotStatuses[timeSlot] = "Booked";
        } else {
          slotStatuses[timeSlot] = "Available";
        }
      } catch (e) {
        print("Error saat mengecek status slot $timeSlot: $e");
        slotStatuses[timeSlot] = "Error"; // Tandai sebagai error jika query gagal
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
    Map<String, String> workerStatuses = {}; // Format: {"Nama Pekerja": "Status"}

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

      QuerySnapshot bookingSnapshot = await firestore
          .collection('bookings')
          .where('serviceId', isEqualTo: serviceId)
          .where('date', isEqualTo: formattedDate)
          .where('startTime', isEqualTo: selectedTimeSlot) // Filter berdasarkan slot waktu yang dipilih
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
      print("Pekerja yang sudah di-booking untuk slot $selectedTimeSlot di tanggal $formattedDate: $bookedWorkerNames");


      // Tentukan status untuk setiap pekerja
      for (String workerName in allWorkerNames) {
        if (bookedWorkerNames.contains(workerName)) {
          workerStatuses[workerName] = "Booked";
        } else {
          workerStatuses[workerName] = "Available";
        }
      }
    } catch (e) {
      print("Error saat mengecek status pekerja untuk slot $selectedTimeSlot: $e");
      // Jika terjadi error, tandai semua pekerja sebagai Error atau sesuai kebijakanmu
      for (String workerName in allWorkerNames) {
        workerStatuses[workerName] = "Error";
      }
    }
    print("Hasil status pekerja: $workerStatuses");
    return workerStatuses;
  }
}