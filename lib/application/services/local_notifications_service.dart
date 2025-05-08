import 'dart:async';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:service_local_notification/application/services/navigation_service.dart';
import 'package:service_local_notification/presentation/main/app_routing.dart';

class NotificationService {
  //////////////////////////////////////////////////////////////////////////////
  /// # Singleton Pattern
  /// Garantiza que solo exista una instancia de esta clase.
  //////////////////////////////////////////////////////////////////////////////

  // Se declara una instancia estática y final de la clase.
  // Esto asegura que solo exista una única instancia de LocalNotificationService.
  static final NotificationService _instance = NotificationService._internal();

  // Constructor factory: siempre devuelve la misma instancia.
  // Esto significa que cada vez que se llame a LocalNotificationService(),
  // se retornará la misma instancia almacenada en _instance.
  factory NotificationService() {
    _instance._ensureInitialized(); // Asegura inicialización
    return _instance;
  }


  // Constructor privado: evita que se pueda crear una nueva instancia
  // desde fuera de la clase. Solo puede ser invocado dentro de esta clase.
  NotificationService._internal();

   Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// # Propiedades generales
  //////////////////////////////////////////////////////////////////////////////


  bool _isInitialized = false; // Bandera de inicialización

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
    if (_isInitialized) return; // Evita doble inicialización
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

    // Inicializa el plugin de notificaciones locales
    // Este método se ejecuta una sola vez, usualmente al iniciar la aplicación
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      
      // Este callback se ejecuta cuando el usuario hace clic en una notificación
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;

        // Navega a una ruta específica pasando el 'payload' como argumento
        // El payload generalmente contiene información útil como un ID o un mensaje
        NavigationService().navigateTo(AppRoutes.secondPage, arguments: payload);
      },
    );
    
    _isInitialized = true; // Marca como inicializado    
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
  
  /// AndroidNotificationAction
  ///   id (String)
  ///     Distinguir qué acción se seleccionó cuando el usuario interactúa con la notificación.
  ///   title (String)
  ///   icon (AndroidBitmap<Object>?)
  ///   contextual (bool)
  ///     Indica si la acción es contextual, es decir, si depende del contenido de la notificación
  ///   titleColor (Color?)
  ///   showsUserInterface (bool)
  ///   cancelNotification (bool)
  ///   inputs (List<AndroidNotificationActionInput>)
  ///     Lista de entradas que permiten al usuario proporcionar información directamente desde la notificación.
  ///   allowGeneratedReplies (bool)


  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
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
      title,
      body,
      notificationDetails,
      payload: payload ?? 'default_payload',
    );
  }


  Future<void> showNotificationCustomSound({
    required String title,
    required String body,
  }) async {
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
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> showOngoingNotification({
    required String title,
    required String body,
  }) async {
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
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  Future<void> showNotificationWithNoSound({
    required String title,
    required String body,
  }) async {
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
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> showNotificationWithActions({
    required String title,
    required String body,
    String? payload,
  }) async {
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

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(      
      id++,       
      title,
      body,
      notificationDetails,
      payload: payload ?? 'item z',
    );
  }

  Future<void> showNotificationWithTextChoice({
    required String title,
    required String body,
    String? payload,
  }) async {
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

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id++,       
      title,
      body,
      notificationDetails,
      payload: payload ?? 'default_payload',
    );
  }

  Future<void> showBigTextNotification({
    required String title,
    required String body,
    required String text,
  }) async {
    BigTextStyleInformation bigTextStyleInformation =
        BigTextStyleInformation(
      text,
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigTextStyleInformation);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
        
    await _flutterLocalNotificationsPlugin.show(
      id++,
      title,
      body,
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
