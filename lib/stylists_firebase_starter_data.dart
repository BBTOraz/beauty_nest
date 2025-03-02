import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'branches.dart';
import 'model/stylist.dart';


class BeautyNestDataUploader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Main method to upload all data
  Future<void> uploadAllData() async {
    final dataset = generateBeautyNestDataset();

    // Create a batch
    final batch = _firestore.batch();

    for (final stylist in dataset) {
      final docRef = _firestore.collection('stylists').doc(stylist.id);
      batch.set(docRef, stylist.toMap());
    }

    // Commit the batch
    await batch.commit();
    print('Successfully uploaded ${dataset.length} stylists to Firestore');
  }

  // Generate the dataset
  List<Stylist> generateBeautyNestDataset() {
    return beautyNestStylists;
  }
}

// Beauty Nest Dataset Constants
class BeautyNestConstants {
  // Salon branches in Astana
  static const List<String> branches = [
    'Beauty Nest, Проспект Кабанбай Батыра 53, Астана',
    'Beauty Nest, Улица Туран 37, Астана',
    'Beauty Nest, Улица Сыганак 14, Астана',
  ];

  // Services offered
  static const List<String> serviceCategories = [
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
    'Консультации стилиста',
  ];

  static const List<String> femaleFirstNames = [
    'Айгуль', 'Айжан', 'Айнур', 'Алия', 'Алтын', 'Амина', 'Анара', 'Асель',
    'Асия', 'Бибигуль', 'Ботагоз', 'Гульнара', 'Гульмира', 'Дана', 'Дария',
    'Динара', 'Жанар', 'Жанна', 'Зарина', 'Зере', 'Карлыгаш', 'Куляш',
    'Лаура', 'Лейла', 'Мадина', 'Маншук', 'Меруерт', 'Надия', 'Назгуль',
    'Назира', 'Нургуль', 'Раушан', 'Роза', 'Сабина', 'Салтанат', 'Самал',
    'Сауле', 'Толганай', 'Томирис', 'Фарида'
  ];


  static const List<String> lastNames = [
    'Абдуллина', 'Алиева', 'Ахметова', 'Аубакирова', 'Баймуратова', 'Бекова',
    'Бердиева', 'Джумагулова', 'Досымова', 'Ергалиева', 'Есенова', 'Жансугурова',
    'Жумабаева', 'Ибрагимова', 'Иманова', 'Искакова', 'Касымова', 'Кенжебаева',
    'Кожахметова', 'Кунанбаева', 'Курманова', 'Муканова', 'Мусина', 'Назарбаева',
    'Нуржанова', 'Омарова', 'Оспанова', 'Рахимова', 'Сагадиева', 'Сатпаева',
    'Сулейменова', 'Тасбулатова', 'Токаева', 'Толеуова', 'Тулегенова', 'Утегенова',
    'Шаханова', 'Шарипова', 'Шокенова'
  ];


  static const List<String> beautyQuotes = [
    'Красота начинается с ухода за собой.',
    'Хорошая прическа — лучшее украшение женщины.',
    'Красота спасет мир.',
    'Быть красивой — значит быть собой.',
    'Ваша красота заслуживает профессионального ухода.',
    'Красота — это сила, а улыбка — ее меч.',
    'Красота приходит изнутри, но немного макияжа тоже не помешает.',
    'Жизнь слишком коротка для плохих причесок.',
    'Каждая женщина заслуживает быть королевой.',
    'Стиль — это способ сказать, кто вы есть, без слов.',
    'Уделите время своей красоте, это инвестиция в себя.',
    'Красота — это не только то, что вы видите, но и то, что вы чувствуете.',
    'Ухоженные волосы — визитная карточка женщины.',
    'Правильно подобранный образ — ключ к уверенности.',
    'Ваша внешность — это искусство, а я — художник.',
  ];


  static const List<String> stylistDescriptions = [
    'Профессиональный стилист с многолетним опытом работы. Специализируюсь на современных техниках стрижки и окрашивания.',
    'Мастер с профессиональным подходом к каждому клиенту. Создаю неповторимые образы, учитывая особенности внешности и пожелания.',
    'Креативный стилист с опытом работы в индустрии красоты. Постоянно повышаю квалификацию, осваивая новые техники и методики.',
    'Талантливый мастер, который всегда в курсе последних тенденций в мире моды и красоты. Индивидуальный подход к каждому клиенту.',
    'Опытный стилист-визажист. Помогу подобрать идеальный образ для любого случая — от повседневного до свадебного.',
    'Профессиональный колорист. Создаю натуральные и яркие образы с учетом цветотипа, структуры волос и модных тенденций.',
    'Визажист-стилист с международными сертификатами. Подчеркну вашу естественную красоту и создам неповторимый образ.',
    'Мастер ногтевого сервиса высшей категории. Предлагаю качественные услуги с использованием профессиональных материалов.',
    'Специалист по уходовым процедурам. Помогу вернуть волосам здоровье и блеск с помощью современных методик восстановления.',
    'Эксперт в области бровей и ресниц. Создаю гармоничные и естественные формы, которые подчеркнут вашу красоту.',
  ];


  static const List<String> certificates = [
    'Сертификат колориста Wella Professionals',
    'Диплом академии парикмахерского искусства',
    'Сертификат мастера по наращиванию ресниц',
    'Сертификат визажиста международного класса',
    'Диплом специалиста по уходовым процедурам',
    'Сертификат мастера по перманентному макияжу',
    'Диплом эксперта по колористике Matrix',
    'Сертификат мастера маникюра и педикюра',
    'Диплом стилиста-имиджмейкера',
    'Сертификат тренера по макияжу',
    'Диплом мастера по SPA-процедурам',
    'Сертификат специалиста по лазерной косметологии',
    'Диплом мастера по наращиванию волос',
    'Сертификат эксперта по ботоксу волос',
    'Диплом мастера по кератиновому выпрямлению',
  ];


  static const List<Map<String, dynamic>> userComments = [
    {
      'name': 'Айгерим Сакенова',
      'text': 'Отличный мастер! Прекрасно сделала стрижку и окрашивание, всем рекомендую.',
      'ratingCount': 5
    },
    {
      'name': 'Дина Омарова',
      'text': 'Очень довольна результатом. Профессионально подобрала стиль, который мне подходит.',
      'ratingCount': 5
    },
    {
      'name': 'Камила Ергалиева',
      'text': 'Прекрасная работа! Мастер учла все мои пожелания и подобрала идеальный образ.',
      'ratingCount': 5
    },
    {
      'name': 'Жанна Кулиева',
      'text': 'Результат превзошел все ожидания! Обязательно приду еще раз.',
      'ratingCount': 5
    },
    {
      'name': 'Асель Тлеуова',
      'text': 'Лучший салон в городе! Всегда внимательное отношение и высокое качество услуг.',
      'ratingCount': 5
    },
    {
      'name': 'Майра Дюсенова',
      'text': 'Хороший мастер, но немного задержала с началом процедуры.',
      'ratingCount': 4
    },
    {
      'name': 'Сауле Бейсенова',
      'text': 'Мастер со вкусом и чувством стиля. Всегда довольна результатом.',
      'ratingCount': 5
    },
    {
      'name': 'Гульнара Сарсенова',
      'text': 'Качественная работа, приятная атмосфера в салоне.',
      'ratingCount': 4
    },
    {
      'name': 'Карина Исмаилова',
      'text': 'Не совсем то, что я хотела, но в целом неплохо.',
      'ratingCount': 3
    },
    {
      'name': 'Алия Нургалиева',
      'text': 'Восхитительный результат! Теперь только к этому мастеру.',
      'ratingCount': 5
    },
    {
      'name': 'Назира Кадырова',
      'text': 'Превосходная работа! Мастер — настоящий профессионал своего дела.',
      'ratingCount': 5
    },
    {
      'name': 'Мадина Турсунова',
      'text': 'Очень внимательный мастер, учла все мои пожелания.',
      'ratingCount': 5
    },
    {
      'name': 'Зарина Касымова',
      'text': 'Немного не то, что я ожидала, но все равно красиво.',
      'ratingCount': 4
    },
    {
      'name': 'Салтанат Муканова',
      'text': 'Приятный мастер и отличный результат! Буду рекомендовать друзьям.',
      'ratingCount': 5
    },
    {
      'name': 'Айнур Жумабаева',
      'text': 'Великолепная работа, мастер — настоящий художник!',
      'ratingCount': 5
    },
  ];


  static Map<String, List<Map<String, dynamic>>> serviceDetails = {
  'Стрижки': [
  {'name': 'Женская стрижка (короткие волосы)', 'price': 5000, 'duration': 45},
  {'name': 'Женская стрижка (средние волосы)', 'price': 6000, 'duration': 60},
  {'name': 'Женская стрижка (длинные волосы)', 'price': 7000, 'duration': 75},
  {'name': 'Стрижка челки', 'price': 3000, 'duration': 15},
  {'name': 'Детская стрижка', 'price': 4000, 'duration': 40},
  ],
  'Окрашивание': [
  {'name': 'Однотонное окрашивание (короткие волосы)', 'price': 8000, 'duration': 90},
  {'name': 'Однотонное окрашивание (средние волосы)', 'price': 10000, 'duration': 120},
  {'name': 'Однотонное окрашивание (длинные волосы)', 'price': 12000, 'duration': 150},
  {'name': 'Мелирование (короткие волосы)', 'price': 9000, 'duration': 100},
  {'name': 'Мелирование (средние волосы)', 'price': 11000, 'duration': 130},
  {'name': 'Мелирование (длинные волосы)', 'price': 13000, 'duration': 160},
  {'name': 'Омбре/балаяж (средние волосы)', 'price': 15000, 'duration': 180},
  {'name': 'Омбре/балаяж (длинные волосы)', 'price': 18000, 'duration': 210},
  {'name': 'Креативное окрашивание', 'price': 20000, 'duration': 240},
  ],
  'Укладка': [
  {'name': 'Укладка повседневная', 'price': 5000, 'duration': 40},
  {'name': 'Укладка вечерняя', 'price': 7000, 'duration': 60},
  {'name': 'Укладка свадебная', 'price': 12000, 'duration': 90},
  {'name': 'Укладка с плетением', 'price': 8000, 'duration': 70},
  {'name': 'Голливудские локоны', 'price': 9000, 'duration': 80},
  ],
  'Химическая завивка': [
  {'name': 'Химическая завивка (короткие волосы)', 'price': 8000, 'duration': 120},
  {'name': 'Химическая завивка (средние волосы)', 'price': 10000, 'duration': 150},
  {'name': 'Химическая завивка (длинные волосы)', 'price': 12000, 'duration': 180},
  {'name': 'Биозавивка (короткие волосы)', 'price': 9000, 'duration': 130},
  {'name': 'Биозавивка (средние волосы)', 'price': 11000, 'duration': 160},
  {'name': 'Биозавивка (длинные волосы)', 'price': 13000, 'duration': 190},
  ],
  'Восстановительные процедуры': [
  {'name': 'Кератиновое выпрямление (средние волосы)', 'price': 15000, 'duration': 180},
  {'name': 'Кератиновое выпрямление (длинные волосы)', 'price': 18000, 'duration': 210},
  {'name': 'Ботокс для волос (средние волосы)', 'price': 12000, 'duration': 120},
  {'name': 'Ботокс для волос (длинные волосы)', 'price': 15000, 'duration': 150},
  {'name': 'Ламинирование волос (средние волосы)', 'price': 10000, 'duration': 100},
  {'name': 'Ламинирование волос (длинные волосы)', 'price': 12000, 'duration': 120},
  {'name': 'Экспресс-восстановление', 'price': 8000, 'duration': 60},
  ],
  'Маникюр': [
  {'name': 'Маникюр классический', 'price': 4000, 'duration': 60},
  {'name': 'Маникюр аппаратный', 'price': 5000, 'duration': 70},
  {'name': 'Маникюр комбинированный', 'price': 5500, 'duration': 75},
  {'name': 'Маникюр с покрытием гель-лак', 'price': 7000, 'duration': 90},
  {'name': 'Европейский маникюр', 'price': 4500, 'duration': 65},
  {'name': 'SPA-маникюр', 'price': 6000, 'duration': 80},
  ],
  'Педикюр': [
  {'name': 'Педикюр классический', 'price': 6000, 'duration': 80},
  {'name': 'Педикюр аппаратный', 'price': 7000, 'duration': 90},
  {'name': 'Педикюр комбинированный', 'price': 7500, 'duration': 95},
  {'name': 'Педикюр с покрытием гель-лак', 'price': 9000, 'duration': 110},
  {'name': 'SPA-педикюр', 'price': 8000, 'duration': 100},
  ],
  'Дизайн ногтей': [
  {'name': 'Простой дизайн (1 ноготь)', 'price': 500, 'duration': 10},
  {'name': 'Сложный дизайн (1 ноготь)', 'price': 1000, 'duration': 15},
  {'name': 'Стразы, наклейки', 'price': 800, 'duration': 10},
  {'name': 'Френч', 'price': 1500, 'duration': 20},
  {'name': 'Омбре', 'price': 2000, 'duration': 25},
  {'name': 'Художественная роспись', 'price': 3000, 'duration': 30},
  ],
  'Чистка лица': [
  {'name': 'Механическая чистка лица', 'price': 9000, 'duration': 90},
  {'name': 'Ультразвуковая чистка лица', 'price': 8000, 'duration': 60},
  {'name': 'Комбинированная чистка лица', 'price': 10000, 'duration': 100},
  {'name': 'Атравматическая чистка лица', 'price': 9500, 'duration': 80},
  ],
  'Пилинги': [
  {'name': 'Поверхностный пилинг', 'price': 7000, 'duration': 50},
  {'name': 'Средний пилинг', 'price': 9000, 'duration': 60},
  {'name': 'Глубокий пилинг', 'price': 12000, 'duration': 70},
  {'name': 'Фруктовый пилинг', 'price': 6000, 'duration': 45},
  {'name': 'Миндальный пилинг', 'price': 7500, 'duration': 55},
  {'name': 'Молочный пилинг', 'price': 6500, 'duration': 50},
  ],
  'Маски': [
  {'name': 'Увлажняющая маска', 'price': 5000, 'duration': 30},
  {'name': 'Питательная маска', 'price': 5500, 'duration': 30},
  {'name': 'Омолаживающая маска', 'price': 6000, 'duration': 35},
  {'name': 'Маска для проблемной кожи', 'price': 5800, 'duration': 35},
  {'name': 'Альгинатная маска', 'price': 7000, 'duration': 40},
  {'name': 'Коллагеновая маска', 'price': 8000, 'duration': 40},
  ],
  'Мезотерапия': [
  {'name': 'Мезотерапия лица', 'price': 15000, 'duration': 60},
  {'name': 'Мезотерапия волосистой части головы', 'price': 12000, 'duration': 50},
  {'name': 'Мезотерапия тела', 'price': 18000, 'duration': 70},
  {'name': 'Безинъекционная мезотерапия', 'price': 10000, 'duration': 45},
  ],
  'Инъекции': [
  {'name': 'Ботокс (1 зона)', 'price': 18000, 'duration': 30},
  {'name': 'Филлеры (1 мл)', 'price': 35000, 'duration': 45},
  {'name': 'Биоревитализация', 'price': 25000, 'duration': 60},
  {'name': 'Плазмолифтинг', 'price': 20000, 'duration': 50},
  {'name': 'Контурная пластика губ', 'price': 32000, 'duration': 45},
  {'name': 'Контурная пластика скул', 'price': 38000, 'duration': 50},
  ],
  'Лазерные процедуры': [
  {'name': 'Лазерное омоложение лица', 'price': 12000, 'duration': 45},
  {'name': 'Лазерное удаление пигментации', 'price': 8000, 'duration': 30},
  {'name': 'Лазерное удаление сосудистых звездочек', 'price': 9000, 'duration': 35},
  {'name': 'Лазерная шлифовка лица', 'price': 15000, 'duration': 50},
  {'name': 'Лазерное лечение акне', 'price': 10000, 'duration': 40},
  ],
  'Депиляция (восковая)': [
  {'name': 'Депиляция ног полностью', 'price': 8000, 'duration': 60},
  {'name': 'Депиляция ног до колена', 'price': 5000, 'duration': 40},
  {'name': 'Депиляция рук полностью', 'price': 6000, 'duration': 50},
  {'name': 'Депиляция подмышечных впадин', 'price': 3000, 'duration': 20},
  {'name': 'Депиляция зоны бикини классическое', 'price': 5000, 'duration': 30},
  {'name': 'Депиляция глубокое бикини', 'price': 7000, 'duration': 40},
  ],
    'Депиляция (шугаринг)': [
      {'name': 'Шугаринг ног полностью', 'price': 9000, 'duration': 70},
      {'name': 'Шугаринг ног до колена', 'price': 6000, 'duration': 45},
      {'name': 'Шугаринг рук полностью', 'price': 7000, 'duration': 55},
      {'name': 'Шугаринг подмышечных впадин', 'price': 3500, 'duration': 25},
      {'name': 'Шугаринг зоны бикини классическое', 'price': 6000, 'duration': 35},
      {'name': 'Шугаринг глубокое бикини', 'price': 8000, 'duration': 45},
    ],
    'Депиляция (лазерная)': [
      {'name': 'Лазерная эпиляция ног полностью', 'price': 25000, 'duration': 90},
      {'name': 'Лазерная эпиляция ног до колена', 'price': 15000, 'duration': 50},
      {'name': 'Лазерная эпиляция рук полностью', 'price': 17000, 'duration': 60},
      {'name': 'Лазерная эпиляция подмышечных впадин', 'price': 8000, 'duration': 30},
      {'name': 'Лазерная эпиляция зоны бикини', 'price': 12000, 'duration': 45},
      {'name': 'Лазерная эпиляция лица', 'price': 7000, 'duration': 25},
    ],
    'Депиляция (электроэпиляция)': [
      {'name': 'Электроэпиляция верхней губы', 'price': 4000, 'duration': 30},
      {'name': 'Электроэпиляция подбородка', 'price': 4500, 'duration': 35},
      {'name': 'Электроэпиляция щек', 'price': 5000, 'duration': 40},
      {'name': 'Электроэпиляция подмышечных впадин', 'price': 9000, 'duration': 60},
    ],
    'Макияж (дневной)': [
      {'name': 'Дневной макияж', 'price': 7000, 'duration': 45},
      {'name': 'Макияж в стиле нюд', 'price': 6000, 'duration': 40},
      {'name': 'Деловой макияж', 'price': 7500, 'duration': 50},
    ],
    'Макияж (вечерний)': [
      {'name': 'Вечерний макияж', 'price': 9000, 'duration': 60},
      {'name': 'Праздничный макияж', 'price': 10000, 'duration': 65},
      {'name': 'Голливудский макияж', 'price': 12000, 'duration': 70},
      {'name': 'Смоки айс', 'price': 8000, 'duration': 55},
    ],
    'Макияж (свадебный)': [
      {'name': 'Свадебный макияж', 'price': 15000, 'duration': 80},
      {'name': 'Свадебный макияж с репетицией', 'price': 20000, 'duration': 140},
      {'name': 'Макияж для мамы невесты', 'price': 10000, 'duration': 60},
      {'name': 'Макияж для подружек невесты', 'price': 8000, 'duration': 50},
    ],
    'Макияж (пробный)': [
      {'name': 'Пробный макияж', 'price': 5000, 'duration': 60},
      {'name': 'Консультация по макияжу', 'price': 3000, 'duration': 30},
      {'name': 'Обучение технике макияжа', 'price': 12000, 'duration': 120},
    ],
    'Макияж (перманентный)': [
      {'name': 'Перманентный макияж бровей', 'price': 25000, 'duration': 120},
      {'name': 'Перманентный макияж губ', 'price': 23000, 'duration': 120},
      {'name': 'Перманентный макияж век', 'price': 20000, 'duration': 100},
      {'name': 'Коррекция перманентного макияжа', 'price': 12000, 'duration': 90},
    ],
    'Уход за бровями и ресницами': [
      {'name': 'Оформление бровей', 'price': 4000, 'duration': 30},
      {'name': 'Окрашивание бровей', 'price': 3500, 'duration': 25},
      {'name': 'Окрашивание ресниц', 'price': 3000, 'duration': 20},
      {'name': 'Ламинирование бровей', 'price': 7000, 'duration': 60},
      {'name': 'Долговременная укладка бровей', 'price': 6500, 'duration': 55},
    ],
    'Коррекция бровей': [
      {'name': 'Коррекция бровей пинцетом', 'price': 3000, 'duration': 20},
      {'name': 'Коррекция бровей воском', 'price': 3500, 'duration': 25},
      {'name': 'Коррекция бровей сахарной пастой', 'price': 4000, 'duration': 30},
    ],
    'Оформление бровей': [
      {'name': 'Моделирование формы бровей', 'price': 4500, 'duration': 35},
      {'name': 'Окрашивание и оформление бровей', 'price': 6000, 'duration': 45},
      {'name': 'Архитектура бровей', 'price': 5000, 'duration': 40},
    ],
    'Окрашивание бровей': [
      {'name': 'Окрашивание бровей краской', 'price': 3500, 'duration': 25},
      {'name': 'Окрашивание бровей хной', 'price': 4500, 'duration': 35},
      {'name': 'Биотатуаж бровей', 'price': 5500, 'duration': 45},
    ],
    'Ламинирование': [
      {'name': 'Ламинирование ресниц', 'price': 8000, 'duration': 60},
      {'name': 'Ботокс ресниц', 'price': 7000, 'duration': 55},
      {'name': 'Ламинирование + ботокс ресниц', 'price': 12000, 'duration': 90},
      {'name': 'Ламинирование + окрашивание ресниц', 'price': 10000, 'duration': 75},
    ],
    'Наращивание ресниц': [
      {'name': 'Классическое наращивание ресниц', 'price': 9000, 'duration': 120},
      {'name': '2D наращивание ресниц', 'price': 11000, 'duration': 140},
      {'name': '3D наращивание ресниц', 'price': 13000, 'duration': 160},
      {'name': 'Объемное наращивание ресниц', 'price': 15000, 'duration': 180},
      {'name': 'Снятие ресниц', 'price': 3000, 'duration': 30},
      {'name': 'Коррекция ресниц', 'price': 5000, 'duration': 90},
    ],
    'Уход за телом': [
      {'name': 'Массаж спины', 'price': 7000, 'duration': 40},
      {'name': 'Общий массаж тела', 'price': 12000, 'duration': 90},
      {'name': 'Антицеллюлитный массаж', 'price': 10000, 'duration': 60},
      {'name': 'Лимфодренажный массаж', 'price': 9000, 'duration': 50},
      {'name': 'Массаж лица', 'price': 6000, 'duration': 30},
    ],
    'Массаж': [
      {'name': 'Классический массаж', 'price': 10000, 'duration': 60},
      {'name': 'Спортивный массаж', 'price': 12000, 'duration': 70},
      {'name': 'Релаксирующий массаж', 'price': 11000, 'duration': 60},
      {'name': 'Точечный массаж', 'price': 9000, 'duration': 50},
      {'name': 'Массаж головы', 'price': 5000, 'duration': 30},
      {'name': 'Массаж шейно-воротниковой зоны', 'price': 6000, 'duration': 40},
    ],
    'SPA-процедуры': [
      {'name': 'SPA-программа для тела', 'price': 20000, 'duration': 120},
      {'name': 'SPA-уход за лицом', 'price': 15000, 'duration': 90},
      {'name': 'SPA-программа для рук', 'price': 7000, 'duration': 60},
      {'name': 'SPA-программа для ног', 'price': 8000, 'duration': 70},
      {'name': 'Аромапрограмма', 'price': 12000, 'duration': 80},
      {'name': 'Талассотерапия', 'price': 18000, 'duration': 100},
    ],
    'Обертывания': [
      {'name': 'Шоколадное обертывание', 'price': 12000, 'duration': 80},
      {'name': 'Водорослевое обертывание', 'price': 13000, 'duration': 90},
      {'name': 'Медовое обертывание', 'price': 11000, 'duration': 75},
      {'name': 'Грязевое обертывание', 'price': 14000, 'duration': 90},
      {'name': 'Обертывание с термоэффектом', 'price': 15000, 'duration': 100},
    ],
    'Консультации стилиста': [
      {'name': 'Консультация по подбору стрижки', 'price': 5000, 'duration': 45},
      {'name': 'Консультация по цветотипу', 'price': 6000, 'duration': 50},
      {'name': 'Подбор индивидуального образа', 'price': 10000, 'duration': 90},
      {'name': 'Консультация по уходу за волосами', 'price': 4500, 'duration': 40},
      {'name': 'Имидж-консультация', 'price': 12000, 'duration': 120},
    ],
  };
}

// Helpers to generate random data
class DataGenerator {
  static final Random _random = Random();

  // Generate random rating between 3.5 and 5.0
  static double randomRating() {
    return 3.5 + _random.nextDouble() * 1.5;
  }

  // Get random item from list
  static T getRandomItem<T>(List<T> list) {
    return list[_random.nextInt(list.length)];
  }

  // Get multiple random items from list
  static List<T> getRandomItems<T>(List<T> list, int count) {
    if (count >= list.length) return List.from(list);

    final items = <T>[];
    final tempList = List<T>.from(list);

    for (int i = 0; i < count; i++) {
      final index = _random.nextInt(tempList.length);
      items.add(tempList[index]);
      tempList.removeAt(index);
    }

    return items;
  }

  // Generate random number between min and max
  static int randomInt(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  // Generate random TimeOfDay
  static TimeOfDay randomTimeOfDay(int startHour, int endHour) {
    final hour = startHour + _random.nextInt(endHour - startHour);
    final minute = _random.nextInt(4) * 15; // 0, 15, 30, 45
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Generate time slots for a day
  static List<TimeSlot> generateTimeSlots(String date, int count) {
    final slots = <TimeSlot>[];

    for (int i = 0; i < count; i++) {
      final startTime = randomTimeOfDay(9, 18);
      final endTime = TimeOfDay(
        hour: startTime.hour + _random.nextInt(2) + 1,
        minute: startTime.minute,
      );

      slots.add(TimeSlot(
        id: 'ts_${date}_$i',
        startTime: startTime,
        endTime: endTime,
        isBooked: _random.nextBool() && _random.nextBool(),
      ));
    }

    return slots;
  }

  // Generate available time slots for multiple days
  static Map<String, List<TimeSlot>> generateAvailableTimeSlots() {
    final slots = <String, List<TimeSlot>>{};

    final now = DateTime.now();
    for (int i = 0; i < 14; i++) {
      final date = now.add(Duration(days: i));
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (_random.nextBool() || i < 3) { // More likely to have slots in next 3 days
        slots[dateString] = generateTimeSlots(dateString, _random.nextInt(5) + 3);
      }
    }

    return slots;
  }

  // Generate services for a stylist based on specialization
  static List<Service> generateServices(String specialization) {
    final services = <Service>[];
    final addedCategories = <String>{};

    // Add services from the stylist's primary specialization
    if (BeautyNestConstants.serviceDetails.containsKey(specialization)) {
      final primaryServices = BeautyNestConstants.serviceDetails[specialization]!;
      for (final service in primaryServices) {
        services.add(Service(
          id: 'serv_${services.length}',
          name: service['name'],
          price: service['price'].toDouble(),
          durationMinutes: service['duration'],
          category: specialization,
          description: 'Профессиональная услуга в категории $specialization',
        ));
      }
      addedCategories.add(specialization);
    }

    final additionalCategoriesCount = _random.nextInt(3) + 2;
    final availableCategories = BeautyNestConstants.serviceCategories
        .where((cat) => cat != specialization)
        .toList();

    final additionalCategories = getRandomItems(availableCategories, additionalCategoriesCount);

    for (final category in additionalCategories) {
      if (BeautyNestConstants.serviceDetails.containsKey(category)) {
        final categoryServices = BeautyNestConstants.serviceDetails[category]!;
        final servicesToAdd = getRandomItems(categoryServices, _random.nextInt(3) + 1);

        for (final service in servicesToAdd) {
          services.add(Service(
            id: 'serv_${services.length}',
            name: service['name'],
            price: service['price'].toDouble(),
            durationMinutes: service['duration'],
            category: category,
            description: 'Профессиональная услуга в категории $category',
          ));
        }
        addedCategories.add(category);
      }
    }

    return services;
  }

  // Generate comments for a stylist
  static List<Comment> generateComments(int count) {
    final comments = <Comment>[];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      final commentData = getRandomItem(BeautyNestConstants.userComments);
      final daysAgo = _random.nextInt(60) + 1;

      comments.add(Comment(
        id: 'comment_$i',
        text: commentData['text'],
        likes: _random.nextInt(15),
        userId: 'user_$i',
        photo: 'assets/avatars/anonymous.jpg',
        name: commentData['name'],
        ratingCount: commentData['ratingCount'],
        date: now.subtract(Duration(days: daysAgo)),
        isLiked: false
      ));
    }

    return comments;
  }
}

// Full dataset generation
List<Stylist> get beautyNestStylists {
  final stylists = <Stylist>[];

  // Generate stylists for each branch
  for (int branchIndex = 0; branchIndex < BeautyNestConstants.branches.length; branchIndex++) {
    final branch = BeautyNestConstants.branches[branchIndex];

    // Each branch has 4-6 stylists
    final stylistCount = DataGenerator.randomInt(4, 6);

    for (int i = 0; i < stylistCount; i++) {
      final stylistId = '${branchIndex}_$i';
      final firstName = DataGenerator.getRandomItem(BeautyNestConstants.femaleFirstNames);
      final lastName = DataGenerator.getRandomItem(BeautyNestConstants.lastNames);

      // Select a specialization
      final specialization = DataGenerator.getRandomItem(BeautyNestConstants.serviceCategories);

      // Generate stylist data
      final stylist = Stylist(
        id: stylistId,
        firstName: firstName,
        lastName: lastName,
        photo: 'assets/workers/${DataGenerator.randomInt(1, 20)}.jpg',
        rating: DataGenerator.randomRating(),
        ratingCount: DataGenerator.randomInt(8, 40),
        commentCount: DataGenerator.randomInt(5, 20),
        quote: DataGenerator.getRandomItem(BeautyNestConstants.beautyQuotes),
        specialization: specialization,
        address: branch,
        isAvailable: DataGenerator.randomInt(1, 4) <= 3, // 75% chance of being available
        salon: 'Beauty Nest',
        experience: DataGenerator.randomInt(1, 15),
        description: DataGenerator.getRandomItem(BeautyNestConstants.stylistDescriptions),
        services: DataGenerator.generateServices(specialization),
        portfolioImages: [
          'assets/portfolio/${stylistId}_1.jpg',
          'assets/portfolio/${stylistId}_2.jpg',
          'assets/portfolio/${stylistId}_3.jpg',
        ],
        availableTimeSlots: DataGenerator.generateAvailableTimeSlots(),
        certificates: DataGenerator.getRandomItems(
            BeautyNestConstants.certificates,
            DataGenerator.randomInt(1, 4)
        ),
        comments: DataGenerator.generateComments(DataGenerator.randomInt(3, 10)),
      );

      stylists.add(stylist);
    }
  }

  return stylists;
}

// Example usage of the uploader
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final uploader = BeautyNestDataUploader();
  await uploader.uploadAllData();
  runApp(MyApp());
  final stylists = beautyNestStylists;
  print('Generated ${stylists.length} stylists');
  print('First stylist: ${stylists[0].firstName} ${stylists[0].lastName}');
  print('Services: ${stylists[0].services.length}');
  print('Time slots: ${stylists[0].availableTimeSlots.length} days');
}
