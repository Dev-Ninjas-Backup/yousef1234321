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
  final bool isPromoted;

  const PartItem({
    super.key,
    required this.image,
    required this.name,
    required this.desc,
    required this.price,
    required this.rating,
    this.fallbackAsset = '',
    this.isPromoted = false,
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
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
              if (isPromoted)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.bolt, color: Colors.white, size: 11),
                        SizedBox(width: 2),
                        TranslatedText(
                          text: "promoted",
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
