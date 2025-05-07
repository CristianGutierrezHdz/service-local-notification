import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:service_local_notification/presentation/main/my_app.dart';

import 'services/local_notifications.dart';

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa el servicio de notificaciones
  await LocalNotificationService().initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}
