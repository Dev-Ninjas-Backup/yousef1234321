import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/home/find_garage/controller/find_garage_controller.dart';
import '../../../../core/common/widgets/custom_appbar.dart';
import 'dart:async';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/core/service/translation_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/routes/app_route.dart';

class FindGaragePage extends StatefulWidget {
  const FindGaragePage({super.key});

  @override
  State<FindGaragePage> createState() => _FindGaragePageState();
}

class _FindGaragePageState extends State<FindGaragePage> {
  final FindGarageController controller = Get.put(FindGarageController());
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  String _youText = 'You';

  @override
  void initState() {
    super.initState();
    _fetchYouTranslation();

    // Always refresh user's location when this screen initializes.
    controller.loadCurrentLocation();

    // When garages or location updates, adjust map bounds so all garages are visible.
    ever(controller.garages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitMapToGarages();
      });
    });
  }

  Future<void> _fitMapToGarages() async {
    final garages = controller.garages;
    final markers = <Marker>{};

    for (var g in garages) {
      if (g.garageLat != null &&
          g.garageLng != null &&
          g.garageLat != 0 &&
          g.garageLng != 0) {
        markers.add(
          Marker(
            markerId: MarkerId(g.id),
            position: LatLng(g.garageLat!, g.garageLng!),
            infoWindow: InfoWindow(
              title: g.name,
              snippet: g.address ?? '',
            ),
          ),
        );
      }
    }

    if (controller.currentLat.value != null &&
        controller.currentLng.value != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(
            controller.currentLat.value!,
            controller.currentLng.value!,
          ),
        ),
      );
    }

    if (markers.isEmpty) return;

    try {
      final mapCtrl = await _mapController.future;
      double minLat = markers.first.position.latitude;
      double maxLat = markers.first.position.latitude;
      double minLng = markers.first.position.longitude;
      double maxLng = markers.first.position.longitude;

      for (var m in markers) {
        if (m.position.latitude < minLat) minLat = m.position.latitude;
        if (m.position.latitude > maxLat) maxLat = m.position.latitude;
        if (m.position.longitude < minLng) minLng = m.position.longitude;
        if (m.position.longitude > maxLng) maxLng = m.position.longitude;
      }

      if (minLat == maxLat && minLng == maxLng) {
        await mapCtrl.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(minLat, minLng), 14),
        );
      } else {
        final bounds = LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        );
        await mapCtrl.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    } catch (_) {}
  }

  Future<void> _fetchYouTranslation() async {
    try {
      final translationService = Get.find<TranslationService>();
      // Resolve 'you' key to English 'You' if possible, then translate
      final englishMap = Get.translations['en_US'];
      final sourceText = englishMap?['you'] ?? 'You';
      final translated = await translationService.translate(sourceText);
      if (mounted) setState(() => _youText = translated);
    } catch (_) {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "search_nearby_garage"),
              const SizedBox(height: 24),

              // Search bar + filter
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextField(
              //         controller: controller.searchController,
              //         decoration: InputDecoration(
              //           hintText: "Search nearby garage",
              //           prefixIcon: const Icon(Icons.search, size: 20),
              //           suffixIcon: GestureDetector(
              //             onTap: () {
              //               controller.searchController.clear();
              //             },
              //             child: const Icon(Icons.clear, size: 20),
              //           ),
              //           contentPadding: const EdgeInsets.symmetric(
              //             vertical: 14,
              //             horizontal: 16,
              //           ),
              //           filled: true,
              //           fillColor: const Color(0xFFF7F7F9),
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(14),
              //             borderSide: BorderSide.none,
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     GestureDetector(
              //       onTap: () {
              //         controller.isDropdownVisible.value =
              //             !controller.isDropdownVisible.value;
              //       },
              //       child: Image.asset(
              //         Iconpath.filtericon,
              //         height: 44,
              //         width: 44,
              //       ),
              //     ),
              //   ],
              // ),

              // Dropdown
              Obx(() {
                if (!controller.isDropdownVisible.value) {
                  return const SizedBox();
                }
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                        color: Color(0xFF000000).withValues(alpha: .25),
                      ),
                    ],
                  ),
                  child: Column(
                    children: controller.items.map((item) {
                      bool isSelected = controller.selectedItem.value == item;
                      return GestureDetector(
                        onTap: () => controller.selectCategory(item),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFE8F1FD)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TranslatedText(
                            text: item,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Map with garage markers and user's current location
              Obx(() {
                final garages = controller.garages;

                final markers = <Marker>{};

                // Garage markers
                for (var g in garages) {
                  if (g.garageLat != null &&
                      g.garageLng != null &&
                      g.garageLat != 0 &&
                      g.garageLng != 0) {
                    markers.add(
                      Marker(
                        markerId: MarkerId(g.id),
                        position: LatLng(g.garageLat!, g.garageLng!),
                        infoWindow: InfoWindow(title: g.name),
                      ),
                    );
                  }
                }

                // If we have user's location, show the map centered on user
                final hasUserLoc =
                    controller.currentLat.value != null &&
                    controller.currentLng.value != null;

                return
                
                
                 Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: hasUserLoc
                              ? LatLng(
                                  controller.currentLat.value!,
                                  controller.currentLng.value!,
                                )
                              : (markers.isNotEmpty
                                    ? markers.first.position
                                    : const LatLng(0, 0)),
                          zoom: 14,
                        ),
                        markers: {
                          ...markers,
                          if (hasUserLoc)
                            Marker(
                              markerId: const MarkerId('user'),
                              position: LatLng(
                                controller.currentLat.value!,
                                controller.currentLng.value!,
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure,
                              ),
                              infoWindow: InfoWindow(title: _youText),
                            ),
                        },
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              ),
                            },
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (GoogleMapController ctrl) async {
                          if (!_mapController.isCompleted) {
                            _mapController.complete(ctrl);
                          }
                          _fitMapToGarages();
                        },
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              await controller.loadCurrentLocation();
                              if (controller.currentLat.value != null &&
                                  controller.currentLng.value != null) {
                                try {
                                  final mapCtrl =
                                      await _mapController.future;
                                  final lat = controller.currentLat.value!;
                                  final lng = controller.currentLng.value!;
                                  await mapCtrl.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(lat, lng),
                                      14,
                                    ),
                                  );
                                } catch (e) {
                                  // ignore errors
                                }
                              }
                            },
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.black54,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Horizontal list of garages (image + name)
              Obx(() {
                final list = controller.garages.toList(growable: false);
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: TranslatedText(
                        text: "no_garage_available",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final g = list[index];
                      return GestureDetector(
                        onTap: () {
                          // navigate to booking for this garage
                          Get.toNamed(
                            Approute.getServiceBooking(),
                            arguments: {'garageId': g.id},
                          );
                        },
                        child: Container(
                          width: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child:
                                    (g.profileImage != null &&
                                            g.profileImage!.isNotEmpty)
                                        ? Image.network(
                                          g.profileImage!,
                                          height: 84,
                                          width: 220,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => Container(
                                                height: 84,
                                                width: 220,
                                                color: Colors.grey.shade100,
                                                child: const Icon(
                                                  Icons.storefront_outlined,
                                                  size: 36,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        )
                                        : Container(
                                          height: 84,
                                          width: 220,
                                          color: Colors.grey.shade100,
                                          child: const Icon(
                                            Icons.storefront_outlined,
                                            size: 36,
                                            color: Colors.grey,
                                          ),
                                        ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TranslatedText(
                                  text: g.name,
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// topLeft: Radius.circular(8),
