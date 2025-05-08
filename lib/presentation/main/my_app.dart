import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:service_local_notification/presentation/main/app_routing.dart';
import 'package:service_local_notification/presentation/main/provider_setup.dart';
import 'package:service_local_notification/application/services/navigation_service.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final NavigationService navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return ProviderSetup.init(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigationService.navigatorKey,
        onGenerateRoute: AppRouter().generateRoute,
        initialRoute: AppRoutes.home,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('es', 'ES'), // Spanish
        ],
        locale: const Locale('es', 'ES'), // Set default locale to Spanish
      ),
    );
  }
}
