class ProductModel {
  final String id;
  final String sellerId;
  final String createdById;
  final String partName;
  final String brand;
  final String categoryId;
  final String condition;
  final String price;
  final int quantity;
  final String description;
  final List<String> photos;
  final String status;
  final bool isPromoted;
  final double? promoCost;
  final int views;
  final int inquiries;
  final String createdAt;
  final String updatedAt;
  final SellerInfo? seller;
  final CreatedByInfo? createdBy;

  ProductModel({
    required this.id,
    required this.sellerId,
    required this.createdById,
    required this.partName,
    required this.brand,
    required this.categoryId,
    required this.condition,
    required this.price,
    required this.quantity,
    required this.description,
    required this.photos,
    required this.status,
    required this.isPromoted,
    this.promoCost,
    required this.views,
    required this.inquiries,
    required this.createdAt,
    required this.updatedAt,
    this.seller,
    this.createdBy,
  });

  // Check if product is active (not sold)
  bool get isActive => status != 'SOLD';

  // Get first photo or placeholder
  String get mainImage {
    if (photos.isNotEmpty && photos[0].isNotEmpty) {
      return photos[0];
    }
    return 'assets/images/spare_parts5.png'; // Default fallback
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      createdById: json['createdById'] ?? '',
      partName: json['partName'] ?? '',
      brand: json['brand'] ?? '',
      categoryId: json['categoryId'] ?? '',
      condition: json['condition'] ?? '',
      price: json['price']?.toString() ?? '0',
      quantity: json['quantity'] ?? 0,
      description: json['description'] ?? '',
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: json['status'] ?? 'PENDING',
      isPromoted: json['isPromoted'] ?? false,
      promoCost: (json['promoCost'] != null)
          ? double.tryParse(json['promoCost'].toString())
          : null,
      views: json['views'] ?? 0,
      inquiries: json['inquiries'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      seller: json['seller'] != null
          ? SellerInfo.fromJson(json['seller'])
          : null,
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
