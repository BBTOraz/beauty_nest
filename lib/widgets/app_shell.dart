import 'package:beauty_nest/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../views/booking_screen.dart';
import '../views/main_screen.dart';
import '../views/stylists_screen.dart';
import 'custom_top_app_bar.dart';


class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final PersistentTabController _controller =
  PersistentTabController(initialIndex: 0);
  List<Widget> _buildScreens() {
    return [
      const MainScreen(),
      StylistsListScreen(),
      const BookingScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Главное",
        activeColorPrimary: AppColors.primaryContainer,
        activeColorSecondary: AppColors.onPrimaryContainer,
        inactiveColorPrimary: AppColors.onPrimaryContainer,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Стилисты",
        activeColorPrimary: AppColors.primaryContainer,
        activeColorSecondary: AppColors.onPrimaryContainer,
        inactiveColorPrimary: AppColors.onPrimaryContainer,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_today),
        title: "Запись",
        activeColorPrimary: AppColors.primaryContainer,
        activeColorSecondary: AppColors.onPrimaryContainer,
        inactiveColorPrimary: AppColors.onPrimaryContainer,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopAppBar(),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: kBottomNavigationBarHeight,
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}
