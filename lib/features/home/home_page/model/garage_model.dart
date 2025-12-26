class GarageModel {
  final String id;
  final String name;
  final String? profileImage;
  final String? coverPhoto;
  final String garagePhone;
  final String email;
  final String street;
  final String city;
  final String emirate;
  final String address;
  final String? formattedAddress;
  final String? placeId;
  final double? garageLat;
  final double? garageLng;
  final String? description;
  final List<String>? certifications;
  final String? weekdaysHours;
  final String? weekendsHours;
  final List<String>? brandExpertise;
  final String status;
  final String userId;
  final List<String> services;
  final String createdAt;
  final String updatedAt;
  final double averageRating;
  final int totalReviews;

  // For backward compatibility with current UI
  double get rating => averageRating;
  int get reviews => totalReviews;
  double get distance => 0.0;
  List<String> get tags => services.take(3).toList();
  String get imageUrl => profileImage ?? coverPhoto ?? '';

  GarageModel({
    required this.id,
    required this.name,
    this.profileImage,
    this.coverPhoto,
    required this.garagePhone,
    required this.email,
    required this.street,
    required this.city,
    required this.emirate,
    required this.address,
    this.formattedAddress,
    this.placeId,
    this.garageLat,
    this.garageLng,
    this.description,
    this.certifications,
    this.weekdaysHours,
    this.weekendsHours,
    this.brandExpertise,
    required this.status,
    required this.userId,
    required this.services,
    required this.createdAt,
    required this.updatedAt,
    required this.averageRating,
    required this.totalReviews,
  });

  factory GarageModel.fromJson(Map<String, dynamic> json) {
    return GarageModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      coverPhoto: json['coverPhoto'],
      garagePhone: json['garagePhone'] ?? '',
      email: json['email'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      emirate: json['emirate'] ?? '',
      address: json['address'] ?? '',
      formattedAddress: json['formattedAddress'],
      placeId: json['placeId'],
      garageLat: json['garageLat']?.toDouble(),
      garageLng: json['garageLng']?.toDouble(),
      description: json['description'],
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
      weekdaysHours: json['weekdaysHours'],
      weekendsHours: json['weekendsHours'],
      brandExpertise: json['brandExpertise'] != null
          ? List<String>.from(json['brandExpertise'])
          : null,
      status: json['status'] ?? 'PENDING',
      userId: json['userId'] ?? '',
      services: json['services'] != null
          ? List<String>.from(json['services'])
          : [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'coverPhoto': coverPhoto,
      'garagePhone': garagePhone,
      'email': email,
      'street': street,
      'city': city,
      'emirate': emirate,
      'address': address,
      'formattedAddress': formattedAddress,
      'placeId': placeId,
      'garageLat': garageLat,
      'garageLng': garageLng,
      'description': description,
      'certifications': certifications,
      'weekdaysHours': weekdaysHours,
      'weekendsHours': weekendsHours,
      'brandExpertise': brandExpertise,
      'status': status,
      'userId': userId,
      'services': services,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }
}
