import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/features/home/find_garage/controller/find_charger_controller.dart';
import '../../../../core/common/widgets/custom_appbar.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ...existing imports
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/routes/app_route.dart';

class FindGaragePage extends StatelessWidget {
  final FindChargerController controller = Get.put(FindChargerController());
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  FindGaragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "Search nearby garage"),
              const SizedBox(height: 24),

              // Search bar + filter
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: "Search nearby garage",
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.searchController.clear();
                          },
                          child: const Icon(Icons.clear, size: 20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      controller.isDropdownVisible.value =
                          !controller.isDropdownVisible.value;
                    },
                    child: Image.asset(
                      Iconpath.filtericon,
                      height: 44,
                      width: 44,
                    ),
                  ),
                ],
              ),

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
                        onTap: () => controller.selectedItem.value = item,
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
                          child: Text(
                            item,
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
                // Determine initial camera target: prefer user's current location,
                // otherwise the first garage, otherwise a sensible fallback.
                LatLng initial;
                if (controller.currentLat.value != null &&
                    controller.currentLng.value != null) {
                  initial = LatLng(
                    controller.currentLat.value!,
                    controller.currentLng.value!,
                  );
                } else if (garages.isNotEmpty) {
                  initial = LatLng(
                    garages.first.garageLat,
                    garages.first.garageLng,
                  );
                } else {
                  initial = const LatLng(25.2048, 55.2708);
                }

                final markers = <Marker>{};
                // User marker
                if (controller.currentLat.value != null &&
                    controller.currentLng.value != null) {
                  markers.add(
                    Marker(
                      markerId: const MarkerId('user'),
                      position: LatLng(
                        controller.currentLat.value!,
                        controller.currentLng.value!,
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure,
                      ),
                      infoWindow: const InfoWindow(title: 'You'),
                    ),
                  );
                }

                // Garage markers
                for (var g in garages) {
                  if (g.garageLat != 0 && g.garageLng != 0) {
                    markers.add(
                      Marker(
                        markerId: MarkerId(g.id),
                        position: LatLng(g.garageLat, g.garageLng),
                        infoWindow: InfoWindow(title: g.name),
                      ),
                    );
                  }
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 260,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: initial,
                            zoom: 12,
                          ),
                          markers: markers,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          onMapCreated: (GoogleMapController ctrl) {
                            if (!_mapController.isCompleted) {
                              _mapController.complete(ctrl);
                            }
                          },
                        ),

                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Obx(() {
                            final hasLoc =
                                controller.currentLat.value != null &&
                                controller.currentLng.value != null;
                            return FloatingActionButton(
                              mini: true,
                              backgroundColor: hasLoc
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              onPressed: hasLoc
                                  ? () async {
                                      try {
                                        final mapCtrl =
                                            await _mapController.future;
                                        final lat =
                                            controller.currentLat.value!;
                                        final lng =
                                            controller.currentLng.value!;
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
                                  : null,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.black54,
                                size: 18,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Horizontal list of garages (image + name)
              Obx(() {
                final list = controller.garages.toList(growable: false);
                if (list.isEmpty) {
                  return const SizedBox();
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
                      final image = g.coverPhoto.isNotEmpty
                          ? g.coverPhoto
                          : (g.profileImage.isNotEmpty
                                ? g.profileImage
                                : 'assets/images/onboarding1.png');

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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: image.startsWith('http')
                                    ? Image.network(
                                        image,
                                        height: 84,
                                        width: 220,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        image,
                                        height: 84,
                                        width: 220,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  g.name,
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
