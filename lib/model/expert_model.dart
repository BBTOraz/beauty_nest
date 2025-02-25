import 'package:flutter/foundation.dart';

class Expert {
  final String name;
  final String experienceRange;
  final String info;
  final double rating;
  final String photoUrl;

  Expert({
    required this.info,
    required this.rating,
    required this.name,
    required this.experienceRange,
    required this.photoUrl,
  });
}
