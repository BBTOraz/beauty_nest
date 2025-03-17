import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m3_carousel/m3_carousel.dart';
import '../app_theme.dart';
import '../model/branch_model.dart';
import '../views/branch_detail_screen.dart';

class BranchesCarouselWidget extends StatefulWidget {
  const BranchesCarouselWidget({super.key});

  @override
  _BranchesCarouselWidgetState createState() => _BranchesCarouselWidgetState();
}

class _BranchesCarouselWidgetState extends State<BranchesCarouselWidget> {
  List<Branch> branches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBranches();
  }

  Future<void> _fetchBranches() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot branchesSnapshot = await firestore.collection('branches').get();

      setState(() {
        branches = branchesSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Branch(
            id: doc.id,
            name: data['name'],
            location: data['location'],
            rating: (data['rating'] as num).toDouble(),
            priceRange: data['priceRange'],
            mainPhotoUrl: data['mainPhotoUrl'],
            services: (data['services'] as List)
                .map((service) => ServiceItem(
              title: service['title'],
              imageUrl: service['imageUrl'],
              price: (service['price'] as num).toDouble(),
            ))
                .toList(),
            packages: (data['packages'] as List)
                .map((package) => PackageItem(
              title: package['title'],
              imageUrl: package['imageUrl'],
              price: double.parse(package['price']),
            ))
                .toList(),
            stylists: (data['stylists'] as List)
                .map((stylist) => Stylist(
              firstname: stylist['firstname'],
              lastname: stylist['lastname'],
              img: stylist['img'],
              rating: (stylist['rating'] as num).toDouble(),
              commentCount: stylist['commentCount'],
            ))
                .toList(),
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching branches: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (branches.isEmpty)
          const Center(child: Text('Нет доступных филиалов'))
        else
          SizedBox(
            height: 250,
            child: M3Carousel(
              type: "uncontained",
              freeScroll: false,
              uncontainedItemExtent: 380,
              uncontainedShrinkExtent: 180,
              childElementBorderRadius: 16,
              onTap: (int index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BranchDetailScreen(branch: branches[index]),
                  ),
                );
              },
              children: branches
                  .map((branch) => _BranchCard(branch: branch))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _BranchCard extends StatelessWidget {
  final Branch branch;
  const _BranchCard({super.key, required this.branch});

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
            branch.mainPhotoUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.error_outline)),
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
                    branch.location,
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