import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:service_local_notification/main.dart';
import 'package:service_local_notification/presentation/utils.dart';

class HomeVM extends ChangeNotifier {
  // constructor
  HomeVM() {
    _initialize();
  }

  Future<void> _initialize() async {
    notifyListeners();
  }

  Future<void> onClickShowNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  Future<void> onClickShowNotificationCustomSound() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      sound: 'slow_spring_board.aiff',
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'custom sound notification title',
      'custom sound notification body',
      notificationDetails,
    );
  }

  Future<void> onClickShowOngoingNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      channelDescription: 'This is your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, // Incrementa el ID para que cada notificación sea única
        'Ongoing Notification Title',
        'Ongoing Notification Body',
        notificationDetails);
  }

  Future<void> onClickShowNotificationWithNoSound() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('silent channel id', 'silent channel name',
            channelDescription: 'silent channel description',
            playSound: false,
            styleInformation: DefaultStyleInformation(true, true));
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentSound: false,
    );
    final WindowsNotificationDetails windowsDetails =
        WindowsNotificationDetails(audio: WindowsNotificationAudio.silent());
    final NotificationDetails notificationDetails = NotificationDetails(
        windows: windowsDetails,
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, '<b>silent</b> title', '<b>silent</b> body', notificationDetails);
  }

  Future<void> onClickCancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(--id);
  }

  Future<void> onClicKShowBigTextNotification() async {
    const BigTextStyleInformation bigTextStyleInformation =
        BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigTextStyleInformation);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'big text title', 'silent body', notificationDetails);
  }

  Future<void> onClicKCancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> onClicKShowNotificationWithActions() async {
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
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item z');
  }

  Future<void> onClicKShowNotificationWithTextChoice() async {
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
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }
}
