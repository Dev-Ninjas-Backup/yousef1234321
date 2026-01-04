class GarageModel {
  final String id;
  final String name;
  final double? garageLat;
  final double? garageLng;
  final String? description;
  final List<String>? certifications;
  final String? weekdaysHours;
  final String? weekendsHours;
  final List<String>? brandExpertise;
  final double? distance;
  final String? address;
  final String? profileImage;
  final String? userFullName;
  final String? userPhone;
  final double? averageRating;
  final int? totalReviews;
  final bool? isOpenNow;

  GarageModel({
    required this.id,
    required this.name,
    this.garageLat,
    this.garageLng,
    this.description,
    this.certifications,
    this.weekdaysHours,
    this.weekendsHours,
    this.brandExpertise,
    this.distance,
    this.address,
    this.profileImage,
    this.userFullName,
    this.userPhone,
    this.averageRating,
    this.totalReviews,
    this.isOpenNow,
  });

  factory GarageModel.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    List<String>? parseStringList(dynamic v) {
      if (v == null) return null;
      if (v is List) {
        return v
            .map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
      }
      return null;
    }

    final user = json['user'] as Map<String, dynamic>?;

    return GarageModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      garageLat: parseDouble(json['garageLat']),
      garageLng: parseDouble(json['garageLng']),
      description: json['description']?.toString(),
      certifications: parseStringList(json['certifications']),
      weekdaysHours: json['weekdaysHours']?.toString(),
      weekendsHours: json['weekendsHours']?.toString(),
      brandExpertise: parseStringList(json['brandExpertise']),
      distance: parseDouble(json['distance']),
      address: json['address']?.toString(),
      profileImage: json['profileImage']?.toString(),
      userFullName: user != null ? (user['fullName']?.toString()) : null,
      userPhone: user != null ? (user['phone']?.toString()) : null,
      averageRating: parseDouble(json['averageRating']),
      totalReviews: parseInt(json['totalReviews']),
      isOpenNow: json['isOpenNow'] is bool ? json['isOpenNow'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'garageLat': garageLat,
    'garageLng': garageLng,
    'description': description,
    'certifications': certifications,
    'weekdaysHours': weekdaysHours,
    'weekendsHours': weekendsHours,
    'brandExpertise': brandExpertise,
    'distance': distance,
    'address': address,
    'profileImage': profileImage,
    'user': {'fullName': userFullName, 'phone': userPhone},
    'averageRating': averageRating,
    'totalReviews': totalReviews,
    'isOpenNow': isOpenNow,
  };
}
