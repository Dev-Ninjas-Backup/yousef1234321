import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/profile/location/controller/location_page_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPageScreen extends StatelessWidget {
  const LocationPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationPageController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(title: "location"),
            const SizedBox(height: 20),
            Text(
              "choose_location_desc".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "type_area_city".tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onSubmitted: (_) => controller.searchLocationByText(),
                    decoration: InputDecoration(
                      hintText: "search".tr,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 22,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: controller.searchLocationByText,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF1F5FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: controller.setCurrentLocation,
                    icon: Icon(
                      Icons.my_location,
                      color: AppColors.primaryColor,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Obx(() {
                  // show a placeholder while profile load
                  if (controller.isLoadingProfile.value &&
                      controller.selectedLatLng.value == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final initial =
                      controller.selectedLatLng.value ??
                      const LatLng(25.2048, 55.2708);
                  final markers = <Marker>{
                    if (controller.selectedLatLng.value != null)
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: controller.selectedLatLng.value!,
                      ),
                  };

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initial,
                      zoom: 12,
                    ),
                    onMapCreated: controller.onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: markers,
                    onTap: controller.onMapTap,
                    onCameraMove: controller.onCameraMove,
                    zoomControlsEnabled: false,
                  );
                }),
              ),
            ),

            const SizedBox(height: 25),
            // Show selected address (reverse geocoded)
            Obx(() {
              final addr = controller.resolvedAddress.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  addr.isEmpty
                      ? 'Tap the map or search to select a location'
                      : addr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: addr.isEmpty ? Colors.grey : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),

            const SizedBox(height: 10),
            SizedBox(
              width: 215,
              child: ElevatedButton(
                onPressed: controller.setDefaultLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "set_default_location".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
