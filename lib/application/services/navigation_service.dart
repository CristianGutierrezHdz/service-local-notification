// Esta clase implementa un servicio de navegación que permite navegar sin necesidad de usar el context.

// Utiliza el patrón Singleton para garantizar que solo haya una instancia compartida en toda la app.
// El patrón Singleton es un patrón de diseño que se utiliza en programación para garantizar que una clase
//tenga solo una única instancia y proporcionar un punto de acceso global a esa instancia. Este patrón es
//útil en situaciones donde se necesita controlar el acceso a recursos compartidos, como conexiones a bases
//de datos o configuraciones de aplicación. En resumen, el patrón Singleton asegura que no se creen múltiples
//instancias de una clase, lo que puede llevar a inconsistencias y problemas de rendimiento.

import 'package:flutter/material.dart';
import 'package:service_local_notification/domain/interfaces/services/i_navigation_service.dart';
import 'package:service_local_notification/presentation/main/app_routing.dart';

class NavigationService extends INavigationService {
  // 1. Declaramos una instancia estática privada de la clase.
  // Esta será la única instancia viva de NavigationService.
  static final NavigationService _instance = NavigationService._internal();

  // 2. Constructor público tipo factory, siempre devuelve la misma instancia.
  // Si alguien hace NavigationService(), devolverá siempre _instance.
  factory NavigationService() => _instance;

  // 3. Constructor interno privado, impide crear nuevas instancias desde fuera de la clase.
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> replaceWith(String routeName, {Object? arguments}) {
    // Verificar si la ruta actual es diferente a la ruta de destino
    if (navigatorKey.currentState?.context != null &&
        ModalRoute.of(navigatorKey.currentState!.context)?.settings.name ==
            routeName) {
      return Future.value(null);
    }

    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> replaceWithoutAnimation(String routeName,
      {Object? arguments}) {
    // Verificar si la ruta actual es diferente a la ruta de destino
    if (navigatorKey.currentState?.context != null &&
        ModalRoute.of(navigatorKey.currentState!.context)?.settings.name ==
            routeName) {
      // Si ya estamos en la ruta deseada, no hacemos nada
      return Future.value(null);
    }

    // Si la ruta es diferente, realizamos la navegación sin animación
    return navigatorKey.currentState!.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return buildPage(routeName, arguments); // Construye la página deseada
        },
        transitionDuration:
            Duration.zero, // Sin duración (transición instantánea)
        reverseTransitionDuration: Duration.zero, // Sin animación al volver
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child; // Devuelve directamente el widget sin animación
        },
      ),
    );
  }

  @override
  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
