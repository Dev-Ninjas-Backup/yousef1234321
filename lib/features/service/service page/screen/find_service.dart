import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/routes/app_route.dart';
import '../controller/service_controller.dart';
import '../widgets/search_and_filter.dart';

class FindService extends StatelessWidget {
  final controller = Get.put(ServiceController());

  FindService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.only(top: 52, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: "Find Service"),

            SizedBox(height: 32),

            SearchAndFilter(controller: controller),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nearby garages",
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View All",
                    style: getTextStyle(
                      color: AppColors.splashButtonColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: controller.serviceItemList.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                //  physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  var item = controller.serviceItemList[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Approute.getServiceBooking());
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9FAFB),

                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        spacing: 12,

                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(item.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 6,
                              children: [
                                //1at row
                                Row(
                                  spacing: 4,
                                  children: [
                                    Text(
                                      item.title,
                                      style: getTextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Color(0xFF2ECC71),
                                    ),
                                  ],
                                ),

                                //2nd row
                                Row(
                                  spacing: 7,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      "${item.rating} (${item.totalReview})",
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: AppColors.subTextColor,
                                      ),
                                    ),
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: AppColors.subTextColor,
                                    ),

                                    Text(
                                      "${item.distance} km",
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: AppColors.subTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                //3rd row
                                Row(
                                  spacing: 6,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color(0xFFDCFCE7),
                                      ),
                                      child: Text(
                                        "Open",
                                        style: getTextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2ECC71),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color(0xFFDDEAFC),
                                      ),
                                      child: Text(
                                        "Towing",
                                        style: getTextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0D6EFD),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item.serviceItem,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: AppColors.subTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
