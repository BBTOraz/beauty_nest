import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await importData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Import Data Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Импорт данных в Firestore'),
        ),
        body: const Center(
          child: Text('Данные импортированы. Проверьте консоль Firebase.'),
        ),
      ),
    );
  }
}

/// Функция для импорта данных в Firestore
Future<void> importData() async {
  CollectionReference branches = FirebaseFirestore.instance.collection('branches');

  List<Map<String, dynamic>> branchesData = [
    {
      "id": "branch1",
      "name": "Beauty Nest",
      "address": "Астана, Казахстан",
      "averageRating": 4.6,
      "userRatings": [5, 4, 5, 4, 5],
      "workingHours": "09:00 - 21:00",
      "priceRange": "3000-52000тг",
      "salonPhoto":
      "assets/branch/branch1.webp", // ссылка на внешний ресурс
      "employees": [
        {
          "firstName": "Айжан",
          "lastName": "Кумисова",
          "photo": "assets/workers/1.jpeg",
          "experience": 5,
          "gender": "female",
          "age": 28
        },
        {
          "firstName": "Айым",
          "lastName": "Оразбаева",
          "photo": "assets/workers/2.jpg",
          "experience": 7,
          "gender": "male",
          "age": 32
        },
        {
          "firstName": "Алия",
          "lastName": "Бакылова",
          "photo": "assets/workers/3.jpg",
          "experience": 3,
          "gender": "female",
          "age": 24
        }
      ],
      "comments": [
        {
          "message": "Отличное обслуживание, рекомендую!",
          "sender": "+770****90",
          "rating": 5
        },
        {
          "message":
          "Хороший сервис, но можно улучшить время ожидания.",
          "sender": "+777****32",
          "rating": 4
        },
        {
          "message": "Впечатления положительные, уютная атмосфера.",
          "sender": "+772****78",
          "rating": 5
        }
      ]
    },
    {
      "id": "branch2",
      "name": "Beauty Nest",
      "address": "Астана, Казахстан",
      "averageRating": 4.2,
      "userRatings": [4, 4, 5, 4, 4],
      "workingHours": "10:00 - 20:00",
      "priceRange": "3000-52000тг",
      "salonPhoto":
      "assets/branch/branch2.jpg", // ссылка на внешний ресурс
      "employees": [
        {
          "firstName": "Диляра",
          "lastName": "Ермекова",
          "photo": "assets/workers/4.jpg",
          "experience": 4,
          "gender": "male",
          "age": 29
        },
        {
          "firstName": "Майра",
          "lastName": "Сайханова",
          "photo": "assets/workers/5.jpg",
          "experience": 6,
          "gender": "female",
          "age": 30
        },
        {
          "firstName": "Жанерке",
          "lastName": "Тлеубаева",
          "photo": "assets/workers/6.jpeg",
          "experience": 2,
          "gender": "male",
          "age": 26
        }
      ],
      "comments": [
        {
          "message":
          "Профессиональные мастера, сервис на высшем уровне.",
          "sender": "+777****76",
          "rating": 5
        },
        {
          "message":
          "Доволен качеством услуг, но цены немного высоковаты.",
          "sender": "+770****12",
          "rating": 4
        },
        {
          "message": "Отличное соотношение цена-качество!",
          "sender": "+770****34",
          "rating": 5
        }
      ]
    },
    {
      "id": "branch3",
      "name": "Beauty Nest",
      "address": "Астана, Казахстан",
      "averageRating": 4.8,
      "userRatings": [5, 5, 5, 4, 5],
      "workingHours": "08:30 - 22:00",
      "priceRange": "3000-52000тг",
      "salonPhoto":
      "assets/branch/branch3.png", // ссылка на внешний ресурс
      "employees": [
        {
          "firstName": "Гульнар",
          "lastName": "Жумабекова",
          "photo": "assets/workers/7.jpg",
          "experience": 8,
          "gender": "female",
          "age": 35
        },
        {
          "firstName": "Айгүл",
          "lastName": "Нуржанова",
          "photo": "assets/workers/8.jpg",
          "experience": 10,
          "gender": "male",
          "age": 38
        },
        {
          "firstName": "Саида",
          "lastName": "Абдрахманова",
          "photo": "assets/workers/9.jpg",
          "experience": 5,
          "gender": "female",
          "age": 29
        }
      ],
      "comments": [
        {
          "message": "Очень приятное обслуживание и уютная обстановка.",
          "sender": "+772****48",
          "rating": 5
        },
        {
          "message": "Всё понравилось, обязательно вернусь.",
          "sender": "+777****20",
          "rating": 5
        },
        {
          "message":
          "Хороший сервис, но можно добавить больше парковочных мест.",
          "sender": "+770****63",
          "rating": 4
        }
      ]
    }
  ];

  for (var branch in branchesData) {
    try {
      await branches.doc(branch['id']).set(branch);
      print('Филиал ${branch['id']} импортирован успешно.');
    } catch (e) {
      print('Ошибка при импорте филиала ${branch['id']}: $e');
    }
  }
}
