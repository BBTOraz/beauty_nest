import 'package:beauty_nest/app_theme.dart';
import 'package:beauty_nest/model/expert_model.dart';
import 'package:beauty_nest/views/booking_flow_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProCareListWidget extends StatelessWidget {
  const ProCareListWidget({super.key});

  Future<List<Expert>> _fetchExperts() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('stylists').get();
    final experts = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final firstName = data['firstName'] ?? '';
      final lastName = data['lastName'] ?? '';
      return Expert(
        name: '$firstName $lastName',
        // Опыт выводим с единицей измерения (например, "15 лет")
        experienceRange: '${data['experience'] ?? 0} лет',
        // Используем специализацию как информационное поле
        info: data['specialization'] ?? '',
        // Приводим рейтинг к double и округляем при выводе
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        photoUrl: data['photo'] ?? '',
      );
    }).toList();
    return experts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expert>>(
      future: _fetchExperts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 210,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
        }
        final experts = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Стилисты на дом',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: experts.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final expert = experts[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ProCareHorizontalCard(expert: expert),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProCareHorizontalCard extends StatelessWidget {
  final Expert expert;
  const ProCareHorizontalCard({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingFlowScreen(selectedExpert: expert),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(expert.photoUrl),
              ),
              const SizedBox(height: 8),
              // Имя специалиста (bold)
              Text(
                expert.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              // Дополнительная информация (например, специализация)
              Text(
                expert.info,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              // В нижней части карточки – Row с опытом и рейтингом
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Опыт (слева)
                  Text(
                    expert.experienceRange,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amberAccent,
                      ),
                      const SizedBox(width: 4),
                      // Округляем рейтинг до 2 знаков после запятой
                      Text(
                        expert.rating.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
