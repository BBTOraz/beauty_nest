import 'package:flutter/material.dart';

import '../model/stylist.dart';
import '../views/stylist_details_screen.dart';


class StylistCard extends StatelessWidget {
  final Stylist stylist;

  const StylistCard({super.key, required this.stylist});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(stylist.photo),
        ),
        title: Text(
          '${stylist.firstName} ${stylist.lastName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text('${stylist.rating} (${stylist.ratingCount})'),
            const SizedBox(width: 8),
            Text('${stylist.commentCount} комментариев'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StylistDetailScreen(stylist: stylist),
            ),
          );
        },
      ),
    );
  }
}