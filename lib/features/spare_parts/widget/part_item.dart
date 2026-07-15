import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';

class PartItem extends StatelessWidget {
  final String image;
  final String name;
  final String desc;
  final double price;
  final double rating;
  final String fallbackAsset;

  const PartItem({
    super.key,
    required this.image,
    required this.name,
    required this.desc,
    required this.price,
    required this.rating,
    this.fallbackAsset = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Builder(
              builder: (context) {
                final isNetwork = image.startsWith('http');
                if (isNetwork) {
                  return Image.network(
                    image,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Image.asset(
                        fallbackAsset.isNotEmpty
                            ? fallbackAsset
                            : Imagepath.image2,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        fallbackAsset.isNotEmpty
                            ? fallbackAsset
                            : Imagepath.image2,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }
                // treat as asset path
                return Image.asset(
                  image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    text: name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  TranslatedText(
                    text: desc,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${price.toStringAsFixed(2)} AED",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(
                            rating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
