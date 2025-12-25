class GarageDetailModel {
  final String id;
  final String name;
  final String coverPhoto;
  final String profileImage;
  final String garagePhone;
  final String email;
  final String street;
  final String city;
  final String emirate;
  final String address;
  final String formattedAddress;
  final String placeId;
  final double garageLat;
  final double garageLng;
  final String description;
  final List<String> certifications;
  final String weekdaysHours;
  final String weekendsHours;
  final List<String> brandExpertise;
  final String status;
  final String userId;
  final List<String> services;
  final String createdAt;
  final String updatedAt;
  final GarageUser? user;
  final double averageRating;
  final int totalReviews;

  GarageDetailModel({
    required this.id,
    required this.name,
    required this.coverPhoto,
    required this.profileImage,
    required this.garagePhone,
    required this.email,
    required this.street,
    required this.city,
    required this.emirate,
    required this.address,
    required this.formattedAddress,
    required this.placeId,
    required this.garageLat,
    required this.garageLng,
    required this.description,
    required this.certifications,
    required this.weekdaysHours,
    required this.weekendsHours,
    required this.brandExpertise,
    required this.status,
    required this.userId,
    required this.services,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    required this.averageRating,
    required this.totalReviews,
  });

  factory GarageDetailModel.fromJson(Map<String, dynamic> json) {
    return GarageDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      coverPhoto: json['coverPhoto'] ?? '',
      profileImage: json['profileImage'] ?? '',
      garagePhone: json['garagePhone'] ?? '',
      email: json['email'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      emirate: json['emirate'] ?? '',
      address: json['address'] ?? '',
      formattedAddress: json['formattedAddress'] ?? '',
      placeId: json['placeId'] ?? '',
      garageLat: (json['garageLat'] ?? 0).toDouble(),
      garageLng: (json['garageLng'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      certifications:
          (json['certifications'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      weekdaysHours: json['weekdaysHours'] ?? '',
      weekendsHours: json['weekendsHours'] ?? '',
      brandExpertise:
          (json['brandExpertise'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: json['status'] ?? '',
      userId: json['userId'] ?? '',
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      user: json['user'] != null ? GarageUser.fromJson(json['user']) : null,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}

class GarageUser {
  final String id;
  final String email;
  final String fullName;
  final String? bio;
  final String phone;
  final String? profilePhoto;
  final String city;
  final String createdAt;
  final String updatedAt;

  GarageUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.bio,
    required this.phone,
    this.profilePhoto,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GarageUser.fromJson(Map<String, dynamic> json) {
    return GarageUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      bio: json['bio'],
      phone: json['phone'] ?? '',
      profilePhoto: json['profilePhoto'],
      city: json['city'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
