import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/branch_model.dart';

Future<void> importData() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Services List
  final List<ServiceItem> services = [
    ServiceItem(title: 'Стрижки', imageUrl: 'assets/services/haircut.jpg', price: 1500),
    ServiceItem(title: 'Окрашивание', imageUrl: 'assets/services/coloring.jpg', price: 3000),
    ServiceItem(title: 'Укладка', imageUrl: 'assets/services/styling.jpg', price: 1200),
    ServiceItem(title: 'Химическая завивка', imageUrl: 'assets/services/perm.jpg', price: 2500),
    ServiceItem(title: 'Восстановительные процедуры', imageUrl: 'assets/services/recovery.jpg', price: 2000),
    ServiceItem(title: 'Маникюр', imageUrl: 'assets/services/manicure.jpg', price: 1000),
    ServiceItem(title: 'Педикюр', imageUrl: 'assets/services/pedicure.jpg', price: 1500),
    ServiceItem(title: 'Дизайн ногтей', imageUrl: 'assets/services/naildesign.jpg', price: 800),
    ServiceItem(title: 'Чистка лица', imageUrl: 'assets/services/facecleaning.jpg', price: 2000),
    ServiceItem(title: 'Пилинги', imageUrl: 'assets/services/peeling.jpg', price: 2500),
    ServiceItem(title: 'Депиляция (восковая)', imageUrl: 'assets/services/waxdepilation.jpg', price: 800),
    ServiceItem(title: 'Макияж (дневной)', imageUrl: 'assets/services/daymakeup.jpg', price: 1500),
    ServiceItem(title: 'Макияж (вечерний)', imageUrl: 'assets/services/evenmakeup.jpg', price: 2000),
    ServiceItem(title: 'Уход за бровями', imageUrl: 'assets/services/browscare.jpg', price: 500),
  ];

  // Packages List
  final List<PackageItem> packages = [
    PackageItem(title: 'Свадебный образ', imageUrl: 'assets/packages/wedding.jpg', price: 15000),
    PackageItem(title: 'Полный spa-день', imageUrl: 'assets/packages/spaday.jpg', price: 12000),
    PackageItem(title: 'Преображение', imageUrl: 'assets/packages/transformation.jpg', price: 10000),
    PackageItem(title: 'Экспресс-уход', imageUrl: 'assets/packages/expresscare.jpg', price: 5000),
  ];

  // Fetch stylists from Firestore
  final QuerySnapshot stylistsSnapshot = await firestore.collection('stylists').get();
  final List<Stylist> allStylists = stylistsSnapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Stylist(
      firstname: data['firstName'],
      lastname: data['lastName'],
      img: data['photo'],
      rating: data['rating'],
      commentCount: data['ratingCount'],
    );
  }).toList();

  final List<Branch> branches = [
    Branch(
      id: 'branch1',
      name: 'Beauty Nest',
      location: 'Проспект Кабанбай Батыра 53, Астана',
      rating: 4.5,
      priceRange: '3000-51000',
      mainPhotoUrl: 'assets/branches/branch1.jpg',
      services: services.sublist(0, 7),
      packages: packages.sublist(0, 2),
      stylists: allStylists.sublist(0, 4),
    ),
    Branch(
      id: 'branch2',
      name: 'Beauty Nest',
      location: 'Улица Туран 37, Астана',
      rating: 4.3,
      priceRange: '3000-51000',
      mainPhotoUrl: 'assets/branches/branch2.jpg',
      services: services.sublist(7, 11),
      packages: packages.sublist(2, 4),
      stylists: allStylists.sublist(4, 8),
    ),
    Branch(
      id: 'branch3',
      name: 'Beauty Nest',
      location: 'Улица Сыганак 14',
      rating: 4.7,
      priceRange: '3000-51000',
      mainPhotoUrl: 'assets/branches/branch3.jpg',
      services: services.sublist(11),
      packages: packages,
      stylists: allStylists.sublist(8),
    ),
  ];

  // Import branches to Firestore
  for (var branch in branches) {
    await firestore.collection('branches').doc(branch.id).set({
      'id': branch.id,
      'name': branch.name,
      'location': branch.location,
      'rating': branch.rating,
      'priceRange': branch.priceRange,
      'mainPhotoUrl': branch.mainPhotoUrl,
      'services': services.map((service) => {
        'title': service.title,
        'imageUrl': service?.imageUrl,
        'price': service.price,
      }).toList(),
      'packages': packages.map((package) => {
        'title': package.title,
        'imageUrl': package.imageUrl,
        'price': package.price,
      }).toList(),
      'stylists': branch.stylists.map((stylist) => {
        'firstname': stylist.firstname,
        'lastname': stylist.lastname,
        'img': stylist.img,
        'rating': stylist.rating,
        'commentCount': stylist.commentCount,
      }).toList(),
    });
    print('Imported branch: ${branch.name}');
  }
}


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