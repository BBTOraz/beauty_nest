class Branch {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String priceRange;
  final String mainPhotoUrl;
  final List<ServiceItem> services;
  const Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.priceRange,
    required this.mainPhotoUrl,
    required this.services,
  });
}

class ServiceItem {
  final String title;
  final String imageUrl;
  final double price;
  const ServiceItem({required this.title, required this.imageUrl, required this.price});
}
