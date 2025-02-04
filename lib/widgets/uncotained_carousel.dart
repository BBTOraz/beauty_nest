import 'package:flutter/material.dart';
import 'package:m3_carousel/m3_carousel.dart';

class UncontainedCarouselWidget extends StatelessWidget {
  const UncontainedCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {"image": "assets/elektroep.jpeg", "title": "Электроэпиляция", "discount": "20%"},
      {"image": "assets/makeup.jpg", "title": "Макияж", "discount": "15%"},
      {"image": "assets/mask.webp", "title": "Маски", "discount": "10%"},
      {"image": "assets/nail.webp", "title": "Маникюр", "discount": "25%"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: M3Carousel(
          type: "uncontained",
          freeScroll: false,
          onTap: (int tapIndex) {
            //todo плавный переход
          },
          children: items
              .asMap()
              .entries
              .map(
                (entry) => _CarouselItem(
              image: entry.value["image"]!,
              title: entry.value["title"]!,
              discount: entry.value["discount"]!,
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

class _CarouselItem extends StatelessWidget {
  final String image;
  final String title;
  final String discount;

  const _CarouselItem({
    super.key,
    required this.image,
    required this.title,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    const double circleSize = 400;
    const double offset = circleSize / 2;

    return Stack(
      fit: StackFit.expand,
      children: [

        Image.asset(
          image,
          fit: BoxFit.cover,
        ),

        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        Positioned(
          top: -offset,
          left: -offset,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  const Color(0xFFFF8BC8),
                  const Color(0xFFFFBBD8).withAlpha(0),
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                'Скидка $discount',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
