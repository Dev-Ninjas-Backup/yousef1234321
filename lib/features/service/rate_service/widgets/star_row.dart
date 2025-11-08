import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

Widget starRow(RxInt rating, Function(int) onTap) {
    return Row(
      children: List.generate(
        5,
        (i) => GestureDetector(
          onTap: () => onTap(i + 1),
          child: Padding(
            padding: EdgeInsets.only(right: 7),
            child: Icon(
              i < rating.value ? Icons.star : Icons.star_border,
              color: Color(0xFFFFC107),
              size: 25,
            ),
          ),
        ),
      ),
    );
  }