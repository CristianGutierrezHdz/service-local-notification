import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_local_notification/presentation/main/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}
