
import 'package:beauty_nest/repositories/stylist_repository.dart';
import 'package:beauty_nest/services/stylist_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'service_locator.dart';
import 'viewmodels/auth_view_model.dart';
import 'routes/app_router.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        Provider<StylistRepository>(
          create: (_) => StylistRepository(),
        ),
        ChangeNotifierProvider<StylistService>(
          create: (context) => StylistService(
            repository: context.read<StylistRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final router = createRouter(context.read<AuthViewModel>());
    return MaterialApp.router(
      title: 'Beauty Nest',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
