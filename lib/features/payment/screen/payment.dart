import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 52),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: "Payment & Publish listing"),

                           
SizedBox(height: 25,),

            // Text(
            //   "Payment Method",
            //   style: getTextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            // ),

            Center(
              child: Column(
                children: [
                  SizedBox(height: 200),

                  Image.asset("assets/images/stripeImage.png", height: 44),
                  SizedBox(height: 30),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Continue to payment",
                      style: getTextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
