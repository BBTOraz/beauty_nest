import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../views/services_page.dart';

/// Модель услуги, содержащая сокращённое название и путь к изображению.
class ServiceItem {
  final String label;
  final String iconPath;
  ServiceItem({required this.label, required this.iconPath});
}

class ServicesNavigationBar extends StatefulWidget {
  const ServicesNavigationBar({Key? key}) : super(key: key);

  @override
  State<ServicesNavigationBar> createState() => _ServicesNavigationBarState();
}

class _ServicesNavigationBarState extends State<ServicesNavigationBar> {
  int selectedIndex = 0;

  final List<ServiceItem> services = [
    ServiceItem(label: 'Парикмахер', iconPath: 'assets/icons/hairdresser.png'),
    ServiceItem(label: 'Маникюр', iconPath: 'assets/icons/manicure.png'),
    ServiceItem(label: 'Косметология', iconPath: 'assets/icons/spa-mask.png'),
    ServiceItem(label: 'Массаж', iconPath: 'assets/icons/massage.png'),
    ServiceItem(label: 'Депиляция', iconPath: 'assets/icons/wax.png'),
    ServiceItem(label: 'Визаж', iconPath: 'assets/icons/makeup.png'),
    ServiceItem(label: 'Брови/Ресницы', iconPath: 'assets/icons/eyebrows.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Наши услуги',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(_createServicesRoute());
                  },
                  child: Text(
                    'все',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(services.length, (index) {
                  final service = services[index];
                  final bool isSelected = index == selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: isSelected
                              ? const LinearGradient(
                            colors: [
                              AppColors.onPrimaryContainer,
                              AppColors.primaryContainer,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          color: isSelected ? null : AppColors.surfaceBright,
                          border: Border.all(
                            color: isSelected ? Colors.transparent : AppColors.surfaceDim,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              service.iconPath,
                              width: 32,
                              height: 32,
                              color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Route _createServicesRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ServicesPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
