enum SellerType { INDIVIDUAL, VERIFIED_SUPPLIER }
enum ListingPlan { FREE, PAY_PER, MONTHLY_BASIC, MONTHLY_PRO }
enum ProductCondition { NEW, USED, REFURBISHED }

class ProductLimitQuota {
  final String userType;
  final int freeProductsLeft;
  final int freeProductsUsed;
  final bool hasProductMonthly;
  final String? productMonthlyPlanType;
  final String? productMonthlyPendingPlanType;
  final String? productMonthlyEndDate;
  final bool hasPayPerCredit;
  final int payPerCredits;
  final double promotionCredits;

  ProductLimitQuota({
    required this.userType,
    required this.freeProductsLeft,
    required this.freeProductsUsed,
    required this.hasProductMonthly,
    this.productMonthlyPlanType,
    this.productMonthlyPendingPlanType,
    this.productMonthlyEndDate,
    required this.hasPayPerCredit,
    required this.payPerCredits,
    this.promotionCredits = 0.0,
  });

  factory ProductLimitQuota.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    
    // Fallbacks to handle previous variable names while ensuring new ones work
    int totalFree = data['freeListingsTotal'] ?? 0;
    int used = data['freeListingsUsed'] ?? data['freeProductsUsed'] ?? 0;
    int remaining = data['freeListingsRemaining'] ?? data['freeProductsLeft'] ?? (totalFree - used);
    
    if (remaining < 0) remaining = 0;

    double promoCredits = 0.0;
    final pcRaw = data['promotionCredits'];
    if (pcRaw is num) {
      promoCredits = pcRaw.toDouble();
    } else if (pcRaw is String) {
      promoCredits = double.tryParse(pcRaw) ?? 0.0;
    }

    return ProductLimitQuota(
      userType: data['userType'] ?? 'INDIVIDUAL',
      freeProductsLeft: remaining,
      freeProductsUsed: used,
      hasProductMonthly: data['hasProductMonthly'] ?? false,
      productMonthlyPlanType: data['productMonthlyPlanType'],
      productMonthlyPendingPlanType: data['productMonthlyPendingPlanType'],
      productMonthlyEndDate: data['productMonthlyEndDate'],
      hasPayPerCredit: data['productCredits'] != null && data['productCredits'] > 0,
      payPerCredits: data['productCredits'] ?? 0,
      promotionCredits: promoCredits,
    );
  }
}

class CreateProductRequest {
  final String partName;
  final String categoryId;
  final String condition;
  final double price;
  final int quantity;
  final String? brand;
  final String? description;
  final SellerType sellerType;
  final String sellerEmail;
  final String? sellerName;
  final String? sellerPhoneNumber;
  final ListingPlan plan;
  final String? garageId;
  final bool isPromoted;
  final String? promotedDuration; // "7" or "15"
  final bool usePromotionCredits;
  final List<String> photoPaths;
  final String? verificationImagePath;

  CreateProductRequest({
    required this.partName,
    required this.categoryId,
    required this.condition,
    required this.price,
    this.quantity = 1,
    this.brand,
    this.description,
    required this.sellerType,
    required this.sellerEmail,
    this.sellerName,
    this.sellerPhoneNumber,
    required this.plan,
    this.garageId,
    this.isPromoted = false,
    this.promotedDuration,
    this.usePromotionCredits = false,
    this.photoPaths = const [],
    this.verificationImagePath,
  });
}
