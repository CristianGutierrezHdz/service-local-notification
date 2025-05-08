import 'package:flutter/material.dart';
import 'package:service_local_notification/presentation/screens/home_screen.dart';
import 'package:service_local_notification/presentation/screens/not_found_screen.dart';
import 'package:service_local_notification/presentation/screens/second_page.dart';

/// Clase estática que define las rutas utilizadas en la aplicación.
/// Evita el uso de strings "mágicos" directamente en el código.
class AppRoutes {
  static const String home = '/';
  static const String secondPage = '/secondPage';
}

/// Clase encargada de generar las rutas en base al nombre recibido.
/// Este método se usa en `MaterialApp` a través de la propiedad `onGenerateRoute`.
class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.secondPage:
        final args = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => SecondPage(args));
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
