class ServiceModel {
  final String id;
  final String name;
  final String address;
  final String image;
  final double range;
  final double rating;
  final int discount;
  final int price; // Tetap menggunakan 'price' sesuai permintaanmu
  final String linkMaps;
  final List<Facility> facilities;
  final List<String> photos;
  final List<Review> reviews;

  // --- Field tambahan untuk booking ---
  final String seller_id;
  final int serviceDurationMinutes;
  final List<String> operatingDays;
  final List<String> availableTimeSlots;
  final List<String> workerNames;
  //createdAt

  ServiceModel({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.range,
    required this.rating,
    required this.discount,
    required this.price,
    required this.linkMaps,
    required this.facilities,
    required this.photos,
    required this.reviews,
    // --- Inisialisasi field tambahan ---
    required this.seller_id,
    required this.serviceDurationMinutes,
    required this.operatingDays,
    required this.availableTimeSlots,
    required this.workerNames,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json, String docId) {
    return ServiceModel(
      id: docId,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      range: (json['range'] ?? 0.0).toDouble(), // Pastikan ada 'range' di JSON atau default value
      rating: (json['rating'] ?? 0.0).toDouble(),
      discount: json['discount'] ?? 0,
      price: json['price'] ?? 0,
      linkMaps: json['link_maps'] ?? '',
      facilities: (json['facilities'] as Map<String, dynamic>?)
          ?.entries
          .map((entry) => Facility.fromJson(entry.key, entry.value))
          .toList() ??
          [],
      photos: List<String>.from(json['photos'] ?? []),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map<Review>((item) => Review.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      // --- Parsing field tambahan ---
      seller_id: json['seller_id'] ?? '',
      serviceDurationMinutes: json['serviceDurationMinutes'] ?? 0,
      operatingDays: List<String>.from(json['operatingDays'] ?? []),
      availableTimeSlots: List<String>.from(json['availableTimeSlots'] ?? []),
      workerNames: List<String>.from(json['workerNames'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'image': image,
      'range': range,
      'rating': rating,
      'discount': discount,
      'price': price,
      'link_maps': linkMaps,
      'facilities': {for (var facility in facilities) facility.name: facility.toJsonValue()}, // Menggunakan toJsonValue() dari Facility
      'photos': photos,
      'reviews': reviews.map((item) => item.toJson()).toList(),
      // --- Serialisasi field tambahan ---
      'seller_id': seller_id,
      'serviceDurationMinutes': serviceDurationMinutes,
      'operatingDays': operatingDays,
      'availableTimeSlots': availableTimeSlots,
      'workerNames': workerNames,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
  }
}

class Facility {
  final String name;
  final dynamic detail; // Bisa String, int, bool dll tergantung value di JSON

  Facility({
    required this.name,
    required this.detail,
  });

  factory Facility.fromJson(String name, dynamic detail) {
    return Facility(
      name: name,
      detail: detail,
    );
  }

  // Mengembalikan value dari facility, karena di JSON services, facilities adalah Map<String, dynamic>
  dynamic toJsonValue() {
    return detail;
  }
}

class Review {
  final String uid;
  final String userName;
  final String userPhoto;
  final String message;
  final double rating;

  Review({
    required this.uid,
    required this.userName,
    required this.userPhoto,
    required this.message,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      uid: json['uid'] ?? '',
      userName: json['user_name'] ?? '',
      userPhoto: json['user_photo'] ?? '',
      message: json['message'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'user_name': userName,
      'user_photo': userPhoto,
      'message': message,
      'rating': rating,
    };
  }
}