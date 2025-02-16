import 'package:beauty_nest/widgets/branches_carousel.dart';
import 'package:beauty_nest/widgets/list_of_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../app_theme.dart';
import '../viewmodels/auth_view_model.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/pro_care_list.dart';
import '../widgets/uncotained_discount_carousel.dart';

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
        showCustomSnackBar(
            context,
            'Добро пожаловать, ${authVM.userModel!.firstName}!',
            SnackbarType.success);
      });
      _welcomeShown = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DiscountCarouselWidget(),
            const ServicesNavigationBar(),
            const ProCareListWidget(),
            const BranchesCarouselWidget(),
          ],
        ),
      ),
    );
  }
}
