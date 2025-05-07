import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:service_local_notification/services/local_notifications.dart';

class HomeVM extends ChangeNotifier {
  final LocalNotificationService _navigationService =
      LocalNotificationService();

  HomeVM() {
    _initialize();
  }

  Future<void> _initialize() async {}

  Future<void> onClickShowNotification() async {
    _navigationService.showNotification();
  }

  Future<void> onClickShowNotificationCustomSound() async {
    _navigationService.showNotificationCustomSound();
  }

  Future<void> onClickShowOngoingNotification() async {
    _navigationService.showOngoingNotification();
  }

  Future<void> onClickShowNotificationWithNoSound() async {
    _navigationService.showNotificationWithNoSound();
  }

  Future<void> onClickCancelNotification() async {
    _navigationService.cancelNotification();
  }

  Future<void> onClicKCancelAllNotifications() async {
    _navigationService.cancelAllNotifications();
  }

  Future<void> onClicKShowNotificationWithActions() async {
    _navigationService.showNotificationWithActions();
  }

  Future<void> onClicKShowNotificationWithTextChoice() async {
    _navigationService.showNotificationWithTextChoice();
  }

  Future<void> onClicKShowBigTextNotification() async {
    _navigationService.showBigTextNotification();
  }
}
