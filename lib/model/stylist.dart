import 'package:flutter/material.dart';

class Stylist {
  final String id;
  final String firstName;
  final String lastName;
  final String photo;
  final double rating;
  final int ratingCount;
  final int commentCount;
  final String quote;
  final String specialization;
  final String address;
  late final List<Comment> comments;

  final bool? isAvailable;
  final List<Service> services;
  final String salon;
  final Map<String, List<TimeSlot>> availableTimeSlots;
  final List<String> portfolioImages;
  final String description;
  final int experience;
  final List<String> certificates;

  String get fullName => '$firstName $lastName';

  Stylist({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.rating,
    required this.ratingCount,
    required this.commentCount,
    required this.quote,
    required this.specialization,
    required this.address,
    required this.comments,
    this.isAvailable,
    this.services = const [],
    this.salon = '',
    this.availableTimeSlots = const {},
    this.portfolioImages = const [],
    this.description = '',
    this.experience = 0,
    this.certificates = const [],
  });

  factory Stylist.fromMap(Map<String, dynamic> data, String documentId) {
    return Stylist(
      id: documentId,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      photo: data['photo'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: data['ratingCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      quote: data['quote'] ?? '',
      specialization: data['specialization'] ?? '',
      address: data['address'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
      salon: data['salon'] ?? '',
      experience: data['experience'] ?? 0,
      description: data['description'] ?? '',
      services: (data['services'] as List<dynamic>? ?? [])
          .map((e) => Service.fromMap(e as Map<String, dynamic>))
          .toList(),
      portfolioImages: List<String>.from(data['portfolioImages'] ?? []),
      availableTimeSlots: (data['availableTimeSlots'] as Map<String, dynamic>? ?? {})
          .map((date, slots) => MapEntry(
        date,
        (slots as List<dynamic>)
            .map((e) => TimeSlot.fromMap(e as Map<String, dynamic>))
            .toList(),
      )),
      certificates: List<String>.from(data['certificates'] ?? []),
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((e) => Comment.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'photo': photo,
      'rating': rating,
      'ratingCount': ratingCount,
      'commentCount': commentCount,
      'quote': quote,
      'specialization': specialization,
      'address': address,
      'isAvailable': isAvailable,
      'salon': salon,
      'experience': experience,
      'description': description,
      'services': services.map((s) => s.toMap()).toList(),
      'availableTimeSlots': availableTimeSlots.map((key, value) =>
          MapEntry(key, value.map((slot) => slot.toMap()).toList())),
      'portfolioImages': portfolioImages,
      'certificates': certificates,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }
}

class Comment {
  final String id;
  final String text;
  final int likes;
  final String userId;
  final String photo;
  final String name;
  final DateTime date;
  final int ratingCount;
  final bool isLiked;

  Comment({
    required this.id,
    required this.text,
    required this.likes,
    required this.userId,
    required this.photo,
    required this.name,
    required this.ratingCount,
    DateTime? date,
    bool? isLiked,
  }) :
        this.date = date ?? DateTime.now(),
        this.isLiked = isLiked ?? false;

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      likes: (data['likes'] as num?)?.round() ?? 0,
      userId: data['userId'] ?? '',
      photo: data['photo'] ?? '',
      name: data['name'] ?? '',
      ratingCount: (data['ratingCount'] as num?)?.round() ?? 0,
      date: data['date'] != null ? DateTime.parse(data['date']) : DateTime.now(),
      isLiked: data['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'likes': likes,
      'userId': userId,
      'photo': photo,
      'name': name,
      'date': date.toIso8601String(),
      'ratingCount': ratingCount,
      'isLiked': isLiked,
    };
  }
}

class Service {
  final String id;
  final String name;
  final double price;
  final int durationMinutes;
  final String description;
  final String category;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    this.description = '',
    this.category = '',
  });

  factory Service.fromMap(Map<String, dynamic> data) {
    return Service(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      durationMinutes: data['durationMinutes'] ?? 0,
      description: data['description'] ?? '',
      category: data['category'] ?? '',
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'durationMinutes': durationMinutes,
      'description': description,
      'category': category,
    };
  }


}

class TimeSlot {
  final String id;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isBooked;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  factory TimeSlot.fromMap(Map<String, dynamic> data) {
    String start = data['startTime'] ?? '00:00';
    String end = data['endTime'] ?? '00:00';
    final startParts = start.split(':');
    final endParts = end.split(':');
    return TimeSlot(
      id: data['id'] ?? '',
      startTime: TimeOfDay(
        hour: int.tryParse(startParts[0]) ?? 0,
        minute: int.tryParse(startParts[1]) ?? 0,
      ),
      endTime: TimeOfDay(
        hour: int.tryParse(endParts[0]) ?? 0,
        minute: int.tryParse(endParts[1]) ?? 0,
      ),
      isBooked: data['isBooked'] ?? false,
    );
  }


  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'endTime': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'isBooked': isBooked,
    };
  }
}


List<Stylist> static_stylists = [
  Stylist(
    id: '1',
    firstName: 'Айжан',
    lastName: 'Кумисова',
    photo: 'assets/workers/1.jpeg',
    rating: 4.8,
    ratingCount: 12,
    commentCount: 8,
    quote: 'Красота начинается с ухода за собой.',
    specialization: 'Стрижки',
    address: 'ул. Центральная, 1',
    isAvailable: true,
    salon: 'Beauty Salon "Гламур"',
    experience: 5,
    description: 'Профессиональный стилист с опытом работы более 5 лет. Специализируюсь на современных техниках стрижки и окрашивания.',
    services: [
      Service(
        id: 's1',
        name: 'Женская стрижка',
        price: 2500,
        durationMinutes: 60,
        category: 'Стрижки',
      ),
      Service(
        id: 's2',
        name: 'Окрашивание',
        price: 3500,
        durationMinutes: 120,
        category: 'Окрашивание',
      ),
      Service(
        id: 's3',
        name: 'Укладка',
        price: 1500,
        durationMinutes: 40,
        category: 'Укладка',
      ),
    ],
    portfolioImages: [
      'assets/portfolio/1_1.jpg',
      'assets/portfolio/1_2.jpg',
      'assets/portfolio/1_3.jpg',
    ],
    availableTimeSlots: {
      '2025-03-01': [
        TimeSlot(
          id: 'ts1',
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 11, minute: 0),
        ),
        TimeSlot(
          id: 'ts2',
          startTime: TimeOfDay(hour: 12, minute: 0),
          endTime: TimeOfDay(hour: 13, minute: 0),
        ),
        TimeSlot(
          id: 'ts3',
          startTime: TimeOfDay(hour: 15, minute: 0),
          endTime: TimeOfDay(hour: 16, minute: 0),
        ),
      ],
    },
    certificates: [
      'Сертификат колориста Wella Professionals',
      'Диплом академии парикмахерского искусства',
    ],
    comments: [
      Comment(
        id: 'c1',
        ratingCount: 5,
        photo: 'assets/avatars/user1.jpg',
        name: 'Анна Петрова',
        text: 'Отличный стилист, рекомендую! Очень довольна стрижкой и окрашиванием.',
        likes: 5,
        userId: 'user1',
        date: DateTime(2025, 2, 15),
        isLiked: true,
      ),
      Comment(
        id: 'c2',
        ratingCount: 4,
        photo: 'assets/avatars/user2.jpg',
        name: 'Елена Сидорова',
        text: 'Очень довольна результатом. Айжан профессионально подобрала стиль.',
        likes: 3,
        userId: 'user2',
        date: DateTime(2025, 2, 20),
      ),
    ],
  ),

  Stylist(
    id: '2',
    firstName: 'Елена',
    lastName: 'Сидорова',
    photo: 'assets/workers/2.jpg',
    rating: 4.5,
    ratingCount: 10,
    commentCount: 5,
    quote: 'Стиль — это отражение души.',
    specialization: 'Макияж',
    address: 'ул. Лесная, 15',
    isAvailable: false,
    salon: 'Beauty Bar "Элегант"',
    experience: 3,
    description: 'Профессиональный визажист. Создаю неповторимые образы для любых мероприятий.',
    services: [
      Service(
        id: 's4',
        name: 'Дневной макияж',
        price: 2000,
        durationMinutes: 45,
        category: 'Макияж',
      ),
      Service(
        id: 's5',
        name: 'Вечерний макияж',
        price: 3000,
        durationMinutes: 60,
        category: 'Макияж',
      ),
      Service(
        id: 's6',
        name: 'Свадебный макияж',
        price: 5000,
        durationMinutes: 90,
        category: 'Макияж',
      ),
    ],
    portfolioImages: [
      'assets/portfolio/2_1.jpg',
      'assets/portfolio/2_2.jpg',
    ],
    availableTimeSlots: {
      '2025-03-02': [
        TimeSlot(
          id: 'ts4',
          startTime: TimeOfDay(hour: 11, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
        ),
        TimeSlot(
          id: 'ts5',
          startTime: TimeOfDay(hour: 14, minute: 0),
          endTime: TimeOfDay(hour: 15, minute: 0),
        ),
      ],
    },
    certificates: [
      'Сертификат школы визажа',
    ],
    comments: [
      Comment(
        id: 'c3',
        ratingCount: 5,
        photo: 'assets/avatars/user3.jpg',
        name: 'Ирина Козлова',
        text: 'Прекрасная работа! Елена учла все мои пожелания и подобрала идеальный макияж.',
        likes: 4,
        userId: 'user3',
        date: DateTime(2025, 2, 10),
      ),
    ],
  ),
  Stylist(
    id: '3',
    firstName: 'Алексей',
    lastName: 'Морозов',
    photo: 'assets/workers/3.jpg',
    rating: 4.9,
    ratingCount: 15,
    commentCount: 10,
    quote: 'Мужской стиль — это больше, чем просто стрижка.',
    specialization: 'Стрижки',
    address: 'пр. Независимости, 54',
    isAvailable: true,
    salon: 'Barbershop "Бритва"',
    experience: 7,
    description: 'Барбер с 7-летним стажем. Специализируюсь на мужских стрижках и уходе за бородой.',
    services: [
      Service(
        id: 's7',
        name: 'Мужская стрижка',
        price: 2000,
        durationMinutes: 45,
        category: 'Стрижки',
      ),
      Service(
        id: 's8',
        name: 'Моделирование бороды',
        price: 1000,
        durationMinutes: 30,
        category: 'Стрижки',
      ),
      Service(
        id: 's9',
        name: 'Королевское бритьё',
        price: 1500,
        durationMinutes: 40,
        category: 'Стрижки',
      ),
    ],
    portfolioImages: [
      'assets/portfolio/3_1.jpg',
      'assets/portfolio/3_2.jpg',
      'assets/portfolio/3_3.jpg',
    ],
    availableTimeSlots: {
      '2025-03-01': [
        TimeSlot(
          id: 'ts6',
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 10, minute: 0),
        ),
        TimeSlot(
          id: 'ts7',
          startTime: TimeOfDay(hour: 13, minute: 0),
          endTime: TimeOfDay(hour: 14, minute: 0),
        ),
      ],
    },
    certificates: [
      'Сертификат Международной ассоциации барберов',
    ],
    comments: [
      Comment(
        id: 'c4',
        ratingCount: 5,
        photo: 'assets/avatars/user4.jpg',
        name: 'Дмитрий Иванов',
        text: 'Лучший барбер в городе! Всегда доволен результатом.',
        likes: 7,
        userId: 'user4',
        date: DateTime(2025, 2, 5),
        isLiked: true,
      ),
      Comment(
        id: 'c5',
        ratingCount: 5,
        photo: 'assets/avatars/user5.jpg',
        name: 'Сергей Петров',
        text: 'Отличный мастер, всегда понимает, что я хочу.',
        likes: 3,
        userId: 'user5',
        date: DateTime(2025, 2, 18),
      ),
    ],
  ),
];