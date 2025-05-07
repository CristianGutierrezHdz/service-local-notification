import 'package:flutter/material.dart';
import 'package:service_local_notification/presentation/screens/home_screen.dart';
import 'package:service_local_notification/presentation/screens/not_found_screen.dart';

/// Clase estática que define las rutas utilizadas en la aplicación.
/// Evita el uso de strings "mágicos" directamente en el código.
class AppRoutes {
  static const String onboardingStep1 = '/onboarding_step1';
}

/// Clase encargada de generar las rutas en base al nombre recibido.
/// Este método se usa en `MaterialApp` a través de la propiedad `onGenerateRoute`.
class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboardingStep1:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        var name = settings.name as String;
        return MaterialPageRoute(builder: (_) => NotFoundScreen(args: name));
    }
  }
}

/// Función alternativa para construir una pantalla basada en el nombre de la ruta.
/// Ideal para usar con transiciones personalizadas (por ejemplo, FadeTransition o SlideTransition).
/// Retorna directamente un `Widget` en lugar de un `Route`.
Widget buildPage(String routeName, Object? arguments) {
  switch (routeName) {
    default:
      return NotFoundScreen(
          args: routeName); // Pantalla de error si la ruta no existe.
  }
}
