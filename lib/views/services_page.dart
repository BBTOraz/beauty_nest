import 'package:flutter/material.dart';
import '../app_theme.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const List<String> services = [
    'Стрижки',
    'Окрашивание',
    'Укладка',
    'Химическая завивка',
    'Восстановительные процедуры',
    'Маникюр',
    'Педикюр',
    'Дизайн ногтей',
    'Чистка лица',
    'Пилинги',
    'Маски',
    'Мезотерапия',
    'Инъекции',
    'Лазерные процедуры',
    'Депиляция (восковая)',
    'Депиляция (шугаринг)',
    'Депиляция (лазерная)',
    'Депиляция (электроэпиляция)',
    'Макияж (дневной)',
    'Макияж (вечерний)',
    'Макияж (свадебный)',
    'Макияж (пробный)',
    'Макияж (перманентный)',
    'Уход за бровями и ресницами',
    'Коррекция бровей',
    'Оформление бровей',
    'Окрашивание бровей',
    'Ламинирование',
    'Наращивание ресниц',
    'Уход за телом',
    'Массаж',
    'SPA-процедуры',
    'Обертывания',
    'Барбершоп',
    'Консультации стилиста',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все услуги'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                services[index],
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          );
        },
      ),
    );
  }
}
