import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_view_model.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/uncotained_carousel.dart';

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
      body: Center(
        child: UncontainedCarouselWidget(),
      ),
    );
  }
}
