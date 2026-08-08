class ProductModel {
  final String id;
  final String sellerId;
  final String createdById;
  final String partName;
  final String? brand;
  final String categoryId;
  final String condition;
  final double price;
  final int quantity;
  final String description;
  final List<String> photos;
  final String status; // "DRAFT" | "PENDING" | "APPROVED" | "REJECTED"
  final bool isPromoted;
  final String? promoCost;
  final DateTime? promotedUntil;
  final DateTime? expiresAt;
  final int views;
  final int inquiries;
  final String createdAt;
  final String updatedAt;
  final SellerInfo? seller;
  final CreatedByInfo? createdBy;

  ProductModel({
    required this.id,
    this.sellerId = '',
    this.createdById = '',
    required this.partName,
    this.brand,
    this.categoryId = '',
    this.condition = '',
    required this.price,
    this.quantity = 1,
    this.description = '',
    required this.photos,
    required this.status,
    required this.isPromoted,
    this.promoCost,
    this.promotedUntil,
    this.expiresAt,
    this.views = 0,
    this.inquiries = 0,
    this.createdAt = '',
    this.updatedAt = '',
    this.seller,
    this.createdBy,
  });

  /// Formula: status == 'APPROVED' && expiresAt != null && expiresAt.isBefore(DateTime.now())
  bool get isExpired =>
      status == 'APPROVED' &&
      expiresAt != null &&
      expiresAt!.isBefore(DateTime.now());

  /// Active status check
  bool get isActive => status != 'DRAFT' && !isExpired;

  /// Get main image or default fallback
  String get mainImage {
    if (photos.isNotEmpty && photos[0].isNotEmpty) {
      return photos[0];
    }
    return 'assets/images/spare_parts5.png';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
    }

    List<String> photosList = [];
    if (json['photos'] is List) {
      photosList = (json['photos'] as List).map((e) => e.toString()).toList();
    } else if (json['images'] is List) {
      photosList = (json['images'] as List).map((e) => e.toString()).toList();
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      sellerId: json['sellerId']?.toString() ?? '',
      createdById: json['createdById']?.toString() ?? '',
      partName: json['partName']?.toString() ?? json['title']?.toString() ?? '',
      brand: json['brand']?.toString(),
      categoryId: json['categoryId']?.toString() ?? '',
      condition: json['condition']?.toString() ?? '',
      price: parsedPrice,
      quantity: json['quantity'] is num ? (json['quantity'] as num).toInt() : 1,
      description: json['description']?.toString() ?? '',
      photos: photosList,
      status: json['status']?.toString().toUpperCase() ?? 'PENDING',
      isPromoted: json['isPromoted'] == true,
      promoCost: json['promoCost']?.toString(),
      promotedUntil: parseDate(json['promotedUntil']),
      expiresAt: parseDate(json['expiresAt']),
      views: json['views'] is num ? (json['views'] as num).toInt() : 0,
      inquiries: json['inquiries'] is num ? (json['inquiries'] as num).toInt() : 0,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      seller: json['seller'] != null ? SellerInfo.fromJson(json['seller']) : null,
      createdBy: json['createdBy'] != null
          ? CreatedByInfo.fromJson(json['createdBy'])
          : null,
    );
  }
}

class SellerInfo {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String sellerType;
  final bool isVerified;
  final String? verificationImage;
  final String subscriptionPlan;
  final String? subscriptionExpiresAt;
  final int freeProductsUsed;
  final String createdAt;
  final String updatedAt;

  SellerInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.sellerType,
    required this.isVerified,
    this.verificationImage,
    required this.subscriptionPlan,
    this.subscriptionExpiresAt,
    required this.freeProductsUsed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SellerInfo.fromJson(Map<String, dynamic> json) {
    return SellerInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      sellerType: json['sellerType'] ?? '',
      isVerified: json['isVerified'] ?? false,
      verificationImage: json['verificationImage'],
      subscriptionPlan: json['subscriptionPlan'] ?? '',
      subscriptionExpiresAt: json['subscriptionExpiresAt'],
      freeProductsUsed: json['freeProductsUsed'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class CreatedByInfo {
  final String id;
  final String email;
  final String fullName;

  CreatedByInfo({
    required this.id,
    required this.email,
    required this.fullName,
  });

  factory CreatedByInfo.fromJson(Map<String, dynamic> json) {
    return CreatedByInfo(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}
