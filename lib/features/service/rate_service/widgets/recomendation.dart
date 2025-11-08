



import 'package:flutter/material.dart';

import '../../../../core/common/style/global_text_style.dart';

class Recomendation extends StatelessWidget {
  const Recomendation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              // color:Colors.amber,
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "No",
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.green[400],
                border: Border.all(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Yes, Recommended",
                textAlign: TextAlign.center,
    
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

