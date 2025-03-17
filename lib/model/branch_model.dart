import 'dart:ffi';

class Branch {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String priceRange;
  final String mainPhotoUrl;
  final List<ServiceItem> services;
  final List<PackageItem> packages;
  final List<Stylist> stylists;
  const Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.priceRange,
    required this.mainPhotoUrl,
    required this.services,
    required this.packages,
    required this.stylists,
  });
}

abstract class ItemBase{
  String get title;
  String get imageUrl;
  double get price;
}

class ServiceItem implements ItemBase{
  @override
  final String title;
  @override
  final String imageUrl;
  @override
  final double price;
  const ServiceItem({required this.title, required this.imageUrl, required this.price});
}

class PackageItem implements ItemBase{
  @override
  final String title;
  @override
  final String imageUrl;
  @override
  final double price;
  const PackageItem({required this.title, required this.imageUrl, required this.price});
}

class Stylist {
  final String firstname;
  final String lastname;
  final String img;
  final double rating;
  final int commentCount;
  const Stylist({required this.firstname, required this.lastname, required this.img, required this.rating, required this.commentCount});
}