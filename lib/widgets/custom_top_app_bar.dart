import 'package:beauty_nest/app_theme.dart';
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
      leading: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Image.asset('assets/logo.png', fit: BoxFit.contain,),
      ),
      title: const Text('Beauty Nest'),
      backgroundColor: AppColors.primaryContainer,
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
