import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_view_model.dart';
import '../widgets/custom_snackbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _welcomeShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authVM = Provider.of<AuthViewModel>(context);
    if (!_welcomeShown && authVM.userModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackBar(context, 'Добро пожаловать, ${authVM.userModel!.firstName}!', SnackbarType.success);
      });
      _welcomeShown = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главный экран'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authVM.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: authVM.userModel != null
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Добро пожаловать, ${authVM.userModel!.firstName}!'),
              const SizedBox(height: 16),
              Text('Email: ${authVM.userModel!.email}'),
              Text('Имя: ${authVM.userModel!.firstName}'),
              Text('Фамилия: ${authVM.userModel!.lastName}'),
              Text('Город: ${authVM.userModel!.city}'),
            ],
          ),
        )
            : const Text('Нет данных о пользователе'),
      ),
    );
  }
}
