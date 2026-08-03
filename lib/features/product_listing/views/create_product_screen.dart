import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/parts_details/model.dart/part_categories_model.dart';
import '../models/product_models.dart';
import '../services/product_api_service.dart';
import 'create_product_flow.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final _partNameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');
  final _brandCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _sellerEmailCtrl = TextEditingController();
  final _sellerNameCtrl = TextEditingController();
  final _sellerPhoneCtrl = TextEditingController();
  final _garageIdCtrl = TextEditingController();

  // State
  ProductCondition _condition = ProductCondition.NEW;
  SellerType _sellerType = SellerType.INDIVIDUAL;
  ListingPlan _plan = ListingPlan.PAY_PER;
  bool _isPromoted = false;
  bool _isSubmitting = false;
  String _promotedDuration = '7'; // Default to 7 days
  List<String> _photoPaths = [];
  String? _verificationImagePath;
  bool _termsAgreed = false;

  bool _isLoadingCategories = true;
  List<PartCategory> _categories = [];
  String? _selectedCategoryId;
  bool _hasActiveMonthly = false;
  ProductLimitQuota? _quota;

  late final ProductApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ProductApiService(
      baseUrl: Endpoint.baseUrl,
      token: ApiClient.to.token ?? '',
    );
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final categories = await _apiService.fetchCategories();
      ProductLimitQuota? quota;
      try {
        quota = await _apiService.checkUserQuota();
      } catch (e) {
        debugPrint("Failed to fetch quota: $e");
      }

      setState(() {
        _categories = categories;
        _quota = quota;
        if (quota != null) {
          if (quota.hasProductMonthly) {
            _hasActiveMonthly = true;
            _plan = quota.productMonthlyPlanType == 'PRO'
                ? ListingPlan.MONTHLY_PRO
                : ListingPlan.MONTHLY_BASIC;
          } else if (quota.freeProductsLeft > 0) {
            _plan = ListingPlan.FREE;
          } else {
            _plan = ListingPlan.PAY_PER;
          }
        }
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() => _isLoadingCategories = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories: $e')),
        );
      }
    }
  }

  Future<void> _purchaseMonthlySubscription() async {
    try {
      final url = await _apiService.createMonthlySubscriptionSession(
        planType: _plan == ListingPlan.MONTHLY_PRO ? 'PRO' : 'BASIC',
      );
      if (url.isNotEmpty) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initiate payment: $e')),
        );
      }
    }
  }

  Future<void> _purchasePayPerListing() async {
    try {
      final url = await _apiService.createPayPerPaymentSession();
      if (url.isNotEmpty) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initiate payment: $e')),
        );
      }
    }
  }

  Future<void> _downgradeToBasic() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Downgrade to Basic Plan?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Your PRO plan features will remain active until the end of your current cycle.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              'After cycle end, your listing limit will change to 10 products.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text(
              'Confirm Downgrade',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final result = await _apiService.downgradeProductPlan(planType: 'BASIC');
        final message = result['message'] ?? 'Plan will be downgraded to BASIC on renewal';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
        }
        await _loadInitialData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Downgrade failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _pickPhotos() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      if (_photoPaths.length + images.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 5 photos allowed')),
        );
        return;
      }
      setState(() {
        _photoPaths.addAll(images.map((e) => e.path));
      });
    }
  }

  Future<void> _pickVerificationImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _verificationImagePath = image.path;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms of Service')),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a Category')));
      return;
    }

    if (_photoPaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least 1 product photo')),
      );
      return;
    }

    if (_sellerType == SellerType.VERIFIED_SUPPLIER &&
        _verificationImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verification Image is required for Verified Suppliers',
          ),
        ),
      );
      return;
    }

    final request = CreateProductRequest(
      partName: _partNameCtrl.text,
      categoryId: _selectedCategoryId!,
      condition: _condition.name,
      price: double.tryParse(_priceCtrl.text) ?? 0.0,
      quantity: int.tryParse(_quantityCtrl.text) ?? 1,
      brand: _brandCtrl.text.isNotEmpty ? _brandCtrl.text : null,
      description: _descriptionCtrl.text.isNotEmpty
          ? _descriptionCtrl.text
          : null,
      sellerType: _sellerType,
      sellerEmail: _sellerEmailCtrl.text,
      sellerName: _sellerNameCtrl.text.isNotEmpty ? _sellerNameCtrl.text : null,
      sellerPhoneNumber: _sellerPhoneCtrl.text.isNotEmpty
          ? _sellerPhoneCtrl.text
          : null,
      plan: _plan,
      garageId: _garageIdCtrl.text.isNotEmpty ? _garageIdCtrl.text : null,
      isPromoted: _isPromoted,
      promotedDuration: _isPromoted ? _promotedDuration : null,
      photoPaths: _photoPaths,
      verificationImagePath: _verificationImagePath,
    );

    await handleCreateProduct(_apiService, request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Add New Product',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            const Text(
              'Fill in the details to list your product in our premium marketplace',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildSectionCard(
              step: 1,
              title: 'Product Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Part Name *'),
                  TextFormField(
                    controller: _partNameCtrl,
                    decoration: _inputDeco('Enter part name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  _buildLabel('Brand'),
                  TextFormField(
                    controller: _brandCtrl,
                    decoration: _inputDeco('Enter brand'),
                  ),
                  _buildLabel('Category *'),
                  _isLoadingCategories
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<String>(
                          decoration: _inputDeco('Select category'),
                          value: _selectedCategoryId,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          items: _categories
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCategoryId = v),
                          validator: (v) => v == null ? 'Required' : null,
                        ),
                  _buildLabel('Price (AED) *'),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputDeco('Enter price', suffixText: 'AED'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  _buildLabel('Quantity *'),
                  TextFormField(
                    controller: _quantityCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputDeco('1'),
                  ),
                  _buildLabel('Condition *'),
                  DropdownButtonFormField<ProductCondition>(
                    decoration: _inputDeco('Condition'),
                    value: _condition,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: ProductCondition.NEW,
                        child: Text('New'),
                      ),
                      DropdownMenuItem(
                        value: ProductCondition.USED,
                        child: Text('Used'),
                      ),
                      DropdownMenuItem(
                        value: ProductCondition.REFURBISHED,
                        child: Text('Refurbished'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _condition = v!),
                  ),
                  _buildLabel('Seller Type *'),
                  DropdownButtonFormField<SellerType>(
                    decoration: _inputDeco('Seller Type'),
                    value: _sellerType,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: SellerType.INDIVIDUAL,
                        child: Text('Individual'),
                      ),
                      DropdownMenuItem(
                        value: SellerType.VERIFIED_SUPPLIER,
                        child: Text('Verified Supplier'),
                      ),
                    ],
                    onChanged: (v) => setState(() {
                      _sellerType = v!;
                      if (_sellerType == SellerType.INDIVIDUAL) {
                        _verificationImagePath = null;
                        _garageIdCtrl.clear();
                      }
                    }),
                  ),
                  if (_sellerType == SellerType.VERIFIED_SUPPLIER) ...[
                    _buildLabel('Garage ID'),
                    TextFormField(
                      controller: _garageIdCtrl,
                      decoration: _inputDeco('Enter Garage ID'),
                    ),
                    _buildLabel('Verification Image *'),
                    GestureDetector(
                      onTap: _pickVerificationImage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _verificationImagePath?.split('/').last ??
                                    'Upload Trade License/ID',
                                style: const TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.upload_file, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              step: 2,
              title: 'Description',
              child: TextFormField(
                controller: _descriptionCtrl,
                maxLines: 4,
                decoration: _inputDeco(
                  'Describe your product, condition, features, compatibility and shipping info...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFBE4BA)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'SayaraHub Note',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD97706),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'SayaraHub only connects buyers and sellers. All payments and transactions happen directly between users. We recommend in-person pickup and inspecting parts before purchase.',
                          style: TextStyle(
                            color: Color(0xFF92400E),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              step: 3,
              title: 'Product Photos',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload clear photos of your spare part. High quality photos increase sales conversion. Max 5 photos.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickPhotos,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid,
                        ), // Ideally dashed but using solid for simplicity without ext package
                      ),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.upload_rounded,
                            size: 32,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Click to upload photos',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'PNG, JPG or WEBP (Max 5 MB)',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_photoPaths.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_photoPaths.length, (index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_photoPaths[index]),
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _photoPaths.removeAt(index)),
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.redAccent,
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              step: 4,
              title: 'Seller Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Provide contact info so potential buyers can reach out to you directly.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  _buildLabel('Seller Name'),
                  TextFormField(
                    controller: _sellerNameCtrl,
                    decoration: _inputDeco('Enter your name'),
                  ),
                  _buildLabel('Seller Email'),
                  TextFormField(
                    controller: _sellerEmailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDeco('Enter your email'),
                  ),
                  _buildLabel('Seller Phone Number *'),
                  TextFormField(
                    controller: _sellerPhoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDeco('Enter your phone number'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              step: 5,
              title: 'Choose Your Listing Plan',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose how you want to list your product in our marketplace',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'You have ${_quota?.freeProductsLeft ?? 0} free listings left!',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ElevatedButton.icon(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.settings, size: 16, color: Colors.white),
                      //   label: const Text('Manage Plan', style: TextStyle(fontSize: 12, color: Colors.white)),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: const Color(0xFF4A72FF),
                      //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      //     minimumSize: const Size(0, 36),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // FREE PLAN Card
                  Opacity(
                    opacity:
                        ((_quota?.freeProductsLeft ?? 0) == 0 ||
                            (_quota?.hasProductMonthly ?? false))
                        ? 0.5
                        : 1.0,
                    child: IgnorePointer(
                      ignoring:
                          ((_quota?.freeProductsLeft ?? 0) == 0 ||
                          (_quota?.hasProductMonthly ?? false)),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _plan == ListingPlan.FREE
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: _plan == ListingPlan.FREE ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE8F5E9),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'FREE PLAN',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            if (_plan == ListingPlan.FREE) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFDCFCE7,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                      size: 12,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'Current plan',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'First 3 Listings Only',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'FREE',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const Text(
                                          'Use your free listings',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const Text(
                                          'Active for 15 days',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _planFeatureLine(
                                          'Only for first 3 products',
                                        ),
                                        _planFeatureLine('Standard visibility'),
                                        _planFeatureLine(
                                          'Promotion not allowed',
                                          isCross: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Radio<ListingPlan>(
                                    value: ListingPlan.FREE,
                                    groupValue: _plan,
                                    onChanged: (v) =>
                                        setState(() => _plan = v!),
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'You have ${_quota?.freeProductsLeft ?? 0} free listings left',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        '${_quota?.freeProductsUsed ?? 0} of 3 used',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value:
                                        (_quota?.freeProductsUsed ?? 0) / 3.0,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.green,
                                        ),
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // PAY PER LISTING Card
                  Opacity(
                    opacity: (_quota?.hasProductMonthly ?? false) ? 0.5 : 1.0,
                    child: IgnorePointer(
                      ignoring: (_quota?.hasProductMonthly ?? false),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _plan == ListingPlan.PAY_PER
                                ? const Color(0xFFF59E0B)
                                : Colors.grey.shade300,
                            width: _plan == ListingPlan.PAY_PER ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEF3C7),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            (_quota?.payPerCredits ?? 0) > 0
                                                ? 'PAY PER LISTING (${_quota!.payPerCredits} remaining)'
                                                : 'PAY PER LISTING',
                                            style: const TextStyle(
                                              color: Color(0xFFD97706),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Single Product Listing',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '9 AED ',
                                                style: TextStyle(
                                                  color: Color(0xFFD97706),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '/ Listing',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          'Active for 15 days',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _planFeatureLine('Active for 15 days'),
                                        _planFeatureLine('Standard visibility'),
                                        _planFeatureLine('Promotion available'),
                                      ],
                                    ),
                                  ),
                                  Radio<ListingPlan>(
                                    value: ListingPlan.PAY_PER,
                                    groupValue: _plan,
                                    onChanged: (v) =>
                                        setState(() => _plan = v!),
                                    activeColor: const Color(0xFFF59E0B),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFBEB),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFFDE68A),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Color(0xFFB45309),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Expiry reminders:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Color(0xFF92400E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    _bulletPoint(
                                      '15 days left (on Day 15)',
                                      color: const Color(0xFF92400E),
                                    ),
                                    _bulletPoint(
                                      '3 days before expiry',
                                      color: const Color(0xFF92400E),
                                    ),
                                    _bulletPoint(
                                      '1 day before expiry',
                                      color: const Color(0xFF92400E),
                                    ),
                                  ],
                                ),
                              ),
                              if (_quota?.hasProductMonthly ?? false)
                                const Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    'Disabled on Monthly Plan',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // MONTHLY PLANS Container
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 12, bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF4A72FF),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFF8FAFF),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            // Basic Sub-card
                            GestureDetector(
                              onTap: () => setState(
                                () => _plan = ListingPlan.MONTHLY_BASIC,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _plan == ListingPlan.MONTHLY_BASIC
                                        ? const Color(0xFF4A72FF)
                                        : Colors.grey.shade300,
                                    width: _plan == ListingPlan.MONTHLY_BASIC
                                        ? 2
                                        : 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Radio<ListingPlan>(
                                      value: ListingPlan.MONTHLY_BASIC,
                                      groupValue: _plan,
                                      onChanged: (v) =>
                                          setState(() => _plan = v!),
                                      activeColor: const Color(0xFF4A72FF),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Basic',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                '29 AED/month',
                                                style: TextStyle(
                                                  color: Color(0xFF4A72FF),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          _planFeatureLine(
                                            'Up to 10 listings',
                                            small: true,
                                          ),
                                          _planFeatureLine(
                                            'Active for 15 days',
                                            small: true,
                                          ),
                                          _planFeatureLine(
                                            'Standard visibility',
                                            small: true,
                                          ),
                                          _planFeatureLine(
                                            'No promotion included',
                                            isCross: true,
                                            small: true,
                                          ),
                                        if (_quota?.hasProductMonthly == true &&
                                            _quota?.productMonthlyPlanType == 'PRO') ...[
                                          const SizedBox(height: 12),
                                          if (_quota?.productMonthlyPendingPlanType == 'BASIC')
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFBEB),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: const Color(0xFFFDE68A)),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.warning_amber_rounded,
                                                    color: Color(0xFFD97706),
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      'Your plan is scheduled to downgrade to BASIC on ${_quota?.productMonthlyEndDate != null ? _quota!.productMonthlyEndDate!.split('T')[0] : 'end of cycle'}.',
                                                      style: const TextStyle(
                                                        color: Color(0xFF92400E),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else
                                            SizedBox(
                                              width: double.infinity,
                                              child: OutlinedButton(
                                                onPressed: _downgradeToBasic,
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(color: Color(0xFFD97706)),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Downgrade to Basic',
                                                  style: TextStyle(
                                                    color: Color(0xFFD97706),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Pro Sub-card
                            GestureDetector(
                              onTap: () => setState(
                                () => _plan = ListingPlan.MONTHLY_PRO,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _plan == ListingPlan.MONTHLY_PRO
                                            ? const Color(0xFF4A72FF)
                                            : Colors.grey.shade300,
                                        width: _plan == ListingPlan.MONTHLY_PRO
                                            ? 2
                                            : 1,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Radio<ListingPlan>(
                                          value: ListingPlan.MONTHLY_PRO,
                                          groupValue: _plan,
                                          onChanged: (v) =>
                                              setState(() => _plan = v!),
                                          activeColor: const Color(0xFF4A72FF),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text(
                                                    'Pro',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    '59 AED/month',
                                                    style: TextStyle(
                                                      color: Color(0xFF4A72FF),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              _planFeatureLine(
                                                'Unlimited listings',
                                                small: true,
                                              ),
                                              _planFeatureLine(
                                                'Active for 30 days',
                                                small: true,
                                              ),
                                              _planFeatureLine(
                                                'Higher ranking in search',
                                                small: true,
                                              ),
                                              _planFeatureLine(
                                                '"Pro Seller" badge',
                                                small: true,
                                              ),
                                              _planFeatureLine(
                                                'Promotion available',
                                                small: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: 20,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6366F1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 10,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'BEST VALUE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Color(0xFF3730A3),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'IMPORTANT Expiry reminders:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF3730A3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  _bulletPoint(
                                    'Day 5 (10 days left)',
                                    color: const Color(0xFF3730A3),
                                  ),
                                  _bulletPoint(
                                    '3 days before expiry',
                                    color: const Color(0xFF3730A3),
                                  ),
                                  _bulletPoint(
                                    '1 day before expiry',
                                    color: const Color(0xFF3730A3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A72FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'MONTHLY PLANS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Pay Per Listing Subscribe Warning CTA
                  if (_plan == ListingPlan.PAY_PER &&
                      (_quota?.freeProductsLeft ?? 0) == 0 &&
                      !(_quota?.hasPayPerCredit ?? false) &&
                      !(_quota?.hasProductMonthly ?? false))
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You need to purchase a Pay-Per-Listing credit to add a product under this plan.',
                            style: TextStyle(
                              color: Color(0xFF92400E),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _purchasePayPerListing,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Purchase Pay Per Listing',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Monthly Subscribe Warning CTA
                  if ((_plan == ListingPlan.MONTHLY_BASIC &&
                          !(_quota?.hasProductMonthly ?? false)) ||
                      (_plan == ListingPlan.MONTHLY_PRO &&
                          !(_quota?.hasProductMonthly ?? false)) ||
                      (_plan == ListingPlan.MONTHLY_PRO &&
                          (_quota?.hasProductMonthly ?? false) &&
                          _quota?.productMonthlyPlanType == 'BASIC'))
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (_plan == ListingPlan.MONTHLY_PRO &&
                                    (_quota?.hasProductMonthly ?? false) &&
                                    _quota?.productMonthlyPlanType == 'BASIC')
                                ? 'You are currently on the Basic plan. Upgrade to the Pro plan to use this feature.'
                                : 'You need to subscribe to the Product Monthly plan to add products under this plan.',
                            style: const TextStyle(
                              color: Color(0xFF92400E),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _purchaseMonthlySubscription,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              (_plan == ListingPlan.MONTHLY_PRO &&
                                      (_quota?.hasProductMonthly ?? false) &&
                                      _quota?.productMonthlyPlanType == 'BASIC')
                                  ? 'Upgrade to Pro Plan'
                                  : 'Subscribe to Monthly Plan',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // How Listing Works Footer Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      border: Border.all(color: const Color(0xFFE0E7FF)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF3730A3),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'How Listing Works',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '1. First 3 listings are FREE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          'No promotion can be applied to free listings. Valid for 15 days.',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '2. Pay per listing',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          'Costs 9 AED per listing. Active for 15 days.',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '3. Monthly plans',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          'Basic (29 AED - 15 days active) and Pro (59 AED - 30 days active) plans.',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '4. Expiry reminders',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          'We\'ll notify you automatically before any of your listings expire.',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              step: 6,
              title: 'Promote This Product',
              trailing: Switch(
                value: _isPromoted,
                onChanged: (v) => setState(() => _isPromoted = v),
                activeColor: const Color(0xFFEC4899),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Boost your product visibility and appear at the top of search results.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  if (_isPromoted) ...[
                    const SizedBox(height: 20),

                    // Silver Promotion Card
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _promotedDuration == '7'
                              ? const Color(0xFF8B5CF6)
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _promotedDuration == '7'
                            ? const Color(0xFFF5F3FF)
                            : Colors.white,
                      ),
                      child: RadioListTile<String>(
                        value: '7',
                        groupValue: _promotedDuration,
                        onChanged: (v) =>
                            setState(() => _promotedDuration = v!),
                        activeColor: const Color(0xFF8B5CF6),
                        contentPadding: const EdgeInsets.all(8),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Silver Promotion',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '49 AED',
                              style: TextStyle(
                                color: _promotedDuration == '7'
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _planFeatureLine('Top of search results'),
                            _planFeatureLine('Highlighted in feed'),
                            _planFeatureLine('7 Days visibility'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Gold Promotion Card
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _promotedDuration == '15'
                              ? const Color(0xFFEC4899)
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _promotedDuration == '15'
                            ? const Color(0xFFFDF2F8)
                            : Colors.white,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          RadioListTile<String>(
                            value: '15',
                            groupValue: _promotedDuration,
                            onChanged: (v) =>
                                setState(() => _promotedDuration = v!),
                            activeColor: const Color(0xFFEC4899),
                            contentPadding: const EdgeInsets.all(8),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Gold Promotion',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '99 AED',
                                  style: TextStyle(
                                    color: _promotedDuration == '15'
                                        ? const Color(0xFFEC4899)
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                _planFeatureLine('Top of search results'),
                                _planFeatureLine('Highlighted in feed'),
                                _planFeatureLine('Homepage slider inclusion'),
                                _planFeatureLine('15 Days visibility'),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEC4899),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'RECOMMENDED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF4A72FF)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        text:
                            'By completing this listing, you confirm that you have read and agreed to the SayaraHub ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions.',
                            style: TextStyle(
                              color: Color(0xFF4A72FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _termsAgreed =
                      true; // Auto agree based on the new UI info box
                  _submit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A72FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Complete listing and Publish',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _planFeatureLine(
    String text, {
    bool isCross = false,
    bool small = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(
            isCross ? Icons.close : Icons.check,
            color: isCross ? Colors.red : Colors.green,
            size: small ? 14 : 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: small ? 12 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text, {required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required int step,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EFFF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$step',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4A72FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _inputDeco(
    String hint, {
    String? suffixText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      suffixIcon: suffixIcon,
    );
  }
}
