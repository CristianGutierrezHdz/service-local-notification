import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:service_local_notification/application/services/local_notifications_service.dart';

class HomeVM extends ChangeNotifier {
  final NotificationService _localNotificationsService;

  HomeVM(this._localNotificationsService) {
    _initialize();
  }

  Future<void> _initialize() async {}

  Future<void> onClickShowNotification() async {
    _localNotificationsService.showNotification(
      title: 'Notificación personalizada',
      body: 'Este es el cuerpo del mensaje',
      payload: 'dato_extra',
    );
  }

  Future<void> onClickShowNotificationCustomSound() async {
    _localNotificationsService.showNotificationCustomSound(
      title: 'custom sound notification title',
      body: 'custom sound notification body',
    );
  }

  Future<void> onClickShowOngoingNotification() async {
    _localNotificationsService.showOngoingNotification(
      title: 'ongoing notification title',
      body: 'ongoing notification body',
    );
  }

  Future<void> onClickShowNotificationWithNoSound() async {
    _localNotificationsService.showNotificationWithNoSound(
      title: '<b>silent</b> title',
      body: '<b>silent</b> body',
    );
  }

  Future<void> onClickCancelNotification() async {
    _localNotificationsService.cancelNotification();
  }

  Future<void> onClicKCancelAllNotifications() async {
    _localNotificationsService.cancelAllNotifications();
  }

  Future<void> onClicKShowNotificationWithActions() async {
    _localNotificationsService.showNotificationWithActions(
      title: 'Notificación personalizada2',
      body: 'Este es el cuerpo del mensaje',
      payload: 'item z'
    );
  }

  Future<void> onClicKShowNotificationWithTextChoice() async {
    _localNotificationsService.showNotificationWithTextChoice(
      title: 'Notificación personalizada2',
      body: 'Este es el cuerpo del mensaje',
      payload: 'item x'
    );
  }

  Future<void> onClicKShowBigTextNotification() async {
    _localNotificationsService.showBigTextNotification(
      title: 'Notificación personalizada2',
      body: 'Este es el cuerpo del mensaje',
      text: 'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 
    );
  }
}
