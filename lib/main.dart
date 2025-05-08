import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:service_local_notification/application/services/local_notifications_service.dart';
import 'package:service_local_notification/presentation/main/app_routing.dart';
import 'package:service_local_notification/presentation/main/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   // Inicializa el servicio de notificaciones
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Obtén los detalles del lanzamiento de la app por notificación
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await notificationService.plugin.getNotificationAppLaunchDetails();

  // Determina la ruta inicial en base a si la app fue lanzada por una notificación
  String initialRoute = AppRoutes.home;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    initialRoute = AppRoutes.secondPage;
  }  

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(
      initialRoute: initialRoute, 
      payload: notificationAppLaunchDetails?.notificationResponse?.payload));
  });
}
