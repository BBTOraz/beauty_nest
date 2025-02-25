import 'package:beauty_nest/views/branch_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:m3_carousel/m3_carousel.dart';
import '../app_theme.dart';
import '../model/branch_model.dart';

class BranchItem {
  final String image;
  final String address;
  const BranchItem({required this.image, required this.address});
}

class BranchesCarouselWidget extends StatelessWidget {
  const BranchesCarouselWidget({super.key});

  static const List<BranchItem> branches = [
    BranchItem(image: 'assets/branch/branch1.webp', address: 'ул. Центральная, 1'),
    BranchItem(image: 'assets/branch/branch2.jpg', address: 'пр-т Мира, 12'),
    BranchItem(image: 'assets/branch/branch3.png', address: 'ул. Ленина, 5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Наши филиалы',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: M3Carousel(
            type: "uncontained",
            freeScroll: false,
            uncontainedItemExtent: 380,
            uncontainedShrinkExtent: 180,
            childElementBorderRadius: 16,
            onTap: (int index) {
              final item = branches[index];
              final branch = Branch(
                id: 'branch_$index',
                name: 'Beauty Nest',
                location: item.address,
                rating: 4.9,
                priceRange: '100 - 220₸',
                mainPhotoUrl: item.image,
                services: [
                  ServiceItem(
                    title: 'Deep Cleansing Facial',
                    imageUrl: 'assets/services/facial.jpg',
                    price: 89,
                  ),
                  ServiceItem(
                    title: 'Anti-Aging Treatment',
                    imageUrl: 'assets/services/anti_aging.jpg',
                    price: 99,
                  ),
                  ServiceItem(
                    title: 'Nail Art',
                    imageUrl: 'assets/services/nail_art.jpg',
                    price: 75,
                  ),
                ],
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BranchDetailScreen(branch: branch),
                ),
              );
            },
            children: branches
                .map((branch) => _BranchCard(item: branch))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _BranchCard extends StatelessWidget {
  final BranchItem item;
  const _BranchCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            item.image,
            fit: BoxFit.cover,
          ),
          Container(
            color: AppColors.overlay,
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceBright.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
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
