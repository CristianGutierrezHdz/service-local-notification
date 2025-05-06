import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_local_notification/main/my_app.dart';

// orquesta la aplicación e inicializa la inyección de dependencias
void main() async {
  // Asegura que la vinculación de Flutter esté inicializada
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MyApp(),
    );
  });
}
