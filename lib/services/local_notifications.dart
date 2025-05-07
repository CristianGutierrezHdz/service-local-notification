import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  //////////////////////////////////////////////////////////////////////////////
  /// # Singleton Pattern
  /// Garantiza que solo exista una instancia de esta clase.
  //////////////////////////////////////////////////////////////////////////////

  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  factory LocalNotificationService() => _instance;

  LocalNotificationService._internal();

  //////////////////////////////////////////////////////////////////////////////
  /// # Propiedades generales
  //////////////////////////////////////////////////////////////////////////////

  int id = 0;
  String? selectedNotificationPayload;

  /// ID para acción que lanza una URL
  static const String urlLaunchActionId = 'id_1';

  /// Categoría para notificaciones de entrada de texto (iOS/macOS)
  static const String darwinNotificationCategoryText = 'textCategory';

  /// Categoría para acciones simples (iOS/macOS)
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  /// Acción que desencadena una navegación interna
  static const String navigationActionId = 'id_3';

  //////////////////////////////////////////////////////////////////////////////
  /// # Instancias internas
  //////////////////////////////////////////////////////////////////////////////

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Stream que permite escuchar respuestas a notificaciones
  final StreamController<NotificationResponse> selectNotificationStream =
      StreamController<NotificationResponse>.broadcast();

  //////////////////////////////////////////////////////////////////////////////
  /// # Inicialización del servicio
  //////////////////////////////////////////////////////////////////////////////

  /// Inicializa el plugin y configura los canales/categorías por plataforma.
  Future<void> initialize() async {
    await _requestNotificationPermission();

    // Configuración Android
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // Categorías Darwin (iOS/macOS)
    final darwinCategories = <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: [
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: [
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: {DarwinNotificationActionOption.destructive},
          ),
          DarwinNotificationAction.plain(
            'id_3',
            'Action 3 (foreground)',
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: {DarwinNotificationActionOption.authenticationRequired},
          ),
        ],
        options: {DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
      ),
    ];

    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinCategories,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (kDebugMode) {
          print('Notification tapped with payload: ${response.payload}');
        }
      },
    );

    if (kDebugMode) {
      print('Notification plugin initialized');
    }

    // Si la app fue lanzada desde una notificación en Linux
    if (!kIsWeb && Platform.isLinux) {
      final details = await _flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp ?? false) {
        selectedNotificationPayload = details?.notificationResponse?.payload;
      }
    }
  }

  /// Solicita permiso para enviar notificaciones
  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  /// Getter expuesto para acceder al plugin
  FlutterLocalNotificationsPlugin get plugin =>
      _flutterLocalNotificationsPlugin;

  //////////////////////////////////////////////////////////////////////////////
  /// # Métodos para mostrar diferentes tipos de notificaciones
  //////////////////////////////////////////////////////////////////////////////

  Future<void> showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      id++,
      'plain title',
      'plain body',
      notificationDetails,
      payload: 'item x',
    );
  }

  Future<void> showNotificationCustomSound() async {
    const androidDetails = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: 'slow_spring_board.aiff',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id++,
      'custom sound title',
      'custom sound body',
      notificationDetails,
    );
  }

  Future<void> showOngoingNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      channelDescription: 'Ongoing notification',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );

    await _flutterLocalNotificationsPlugin.show(
      id++,
      'Ongoing Title',
      'Ongoing Body',
      NotificationDetails(android: androidDetails),
    );
  }

  Future<void> showNotificationWithNoSound() async {
    const androidDetails = AndroidNotificationDetails(
      'silent channel id',
      'silent channel name',
      channelDescription: 'silent channel description',
      playSound: false,
      styleInformation: DefaultStyleInformation(true, true),
    );

    const iosDetails = DarwinNotificationDetails(presentSound: false);
    final windowsDetails = WindowsNotificationDetails(
      audio: WindowsNotificationAudio.silent(),
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
      windows: windowsDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id++,
      'Silent Title',
      'Silent Body',
      notificationDetails,
    );
  }

  Future<void> showNotificationWithActions() async {
    // Agrega aquí tus acciones por plataforma como ya las tienes configuradas.
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          urlLaunchActionId,
          'Action 1',
          icon: DrawableResourceAndroidBitmap('food'),
          contextual: true,
        ),
        AndroidNotificationAction(
          'id_2',
          'Action 2',
          titleColor: Color.fromARGB(255, 255, 0, 0),
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
        ),
        AndroidNotificationAction(
          navigationActionId,
          'Action 3',
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
          showsUserInterface: true,
          // By default, Android plugin will dismiss the notification when the
          // user tapped on a action (this mimics the behavior on iOS).
          cancelNotification: false,
        ),
      ],
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const DarwinNotificationDetails macOSNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const LinuxNotificationDetails linuxNotificationDetails =
        LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(
          key: urlLaunchActionId,
          label: 'Action 1',
        ),
        LinuxNotificationAction(
          key: navigationActionId,
          label: 'Action 2',
        ),
      ],
    );

    final WindowsNotificationDetails windowsNotificationsDetails =
        WindowsNotificationDetails(
      subtitle: 'Click the three dots for another button',
      actions: <WindowsAction>[
        const WindowsAction(
          content: 'Text',
          arguments: 'text',
        ),
        WindowsAction(
          content: 'Image',
          arguments: 'image',
          imageUri: WindowsImage.getAssetUri('icons/coworker.png'),
        ),
        const WindowsAction(
          content: 'Context',
          arguments: 'context',
          placement: WindowsActionPlacement.contextMenu,
        ),
      ],
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: macOSNotificationDetails,
      linux: linuxNotificationDetails,
      windows: windowsNotificationsDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item z');
  }

  Future<void> showNotificationWithTextChoice() async {
    // Igual que el anterior, con inputs tipo elección de texto.

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'text_id_2',
          'Action 2',
          icon: DrawableResourceAndroidBitmap('food'),
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              choices: <String>['ABC', 'DEF'],
              allowFreeFormInput: false,
            ),
          ],
          contextual: true,
        ),
      ],
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryText,
    );

    const WindowsNotificationDetails windowsNotificationDetails =
        WindowsNotificationDetails(
      actions: <WindowsAction>[
        WindowsAction(
            content: 'Submit', arguments: 'submit', inputId: 'choice'),
      ],
      inputs: <WindowsInput>[
        WindowsSelectionInput(
          id: 'choice',
          defaultItem: 'abc',
          items: <WindowsSelection>[
            WindowsSelection(id: 'abc', content: 'abc'),
            WindowsSelection(id: 'def', content: 'def'),
          ],
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
      windows: windowsNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  Future<void> showBigTextNotification() async {
    const bigTextStyle = BigTextStyleInformation(
      'Lorem <i>ipsum...</i>',
      htmlFormatBigText: true,
      contentTitle: 'Big Title',
      htmlFormatContentTitle: true,
      summaryText: 'Summary text',
      htmlFormatSummaryText: true,
    );

    const androidDetails = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      channelDescription: 'big text channel description',
      styleInformation: bigTextStyle,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      id++,
      'Big Text Title',
      'Big Text Body',
      notificationDetails,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// # Cancelación de notificaciones
  //////////////////////////////////////////////////////////////////////////////

  Future<void> cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(--id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
