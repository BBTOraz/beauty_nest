import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';

class CustomTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/logo.png',
            height: 40,
          ),
          const SizedBox(width: 8),
          const Text('Beauty Nest'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await authVM.logout();
            context.go('/login');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
