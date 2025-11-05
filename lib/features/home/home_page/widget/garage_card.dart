import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';

class GarageCard extends StatelessWidget {
  final GarageModel garage;

  const GarageCard({super.key, required this.garage});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.containerFillColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                garage.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    garage.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text("${garage.rating} (${garage.reviews})"),
                      const SizedBox(width: 10),
                      Text("${garage.distance} km"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    spacing: 12,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenOpacity,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          garage.status,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 6,
                        children: garage.tags
                            .map(
                              (tag) => Text(
                                "$tag ",
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(children: [const Icon(Icons.more_vert, size: 20)]),
          ],
        ),
      ),
    );
  }
}
