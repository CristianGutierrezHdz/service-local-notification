import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_local_notification/presentation/viewmodels/home_vm.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeVM>(context);
    return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClickShowNotification();
                      },
                      child: const Text('Show plain notification with payload'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClickShowNotificationCustomSound();
                      },
                      child: const Text('Show notification with custom sound'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClickShowNotificationWithNoSound();
                      },
                      child:
                          const Text('Show notification from silent channel'),
                    ),
                  ),
                ),
                const Divider(),
                const Text(
                  'Notifications with actions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClicKShowNotificationWithActions();
                      },
                      child: const Text('Show notification with plain actions'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClicKShowNotificationWithTextChoice();
                      },
                      child: const Text('Show notification with text choice'),
                    ),
                  ),
                ),
                const Divider(),
                const Text(
                  'Platform-specific examples',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClicKShowBigTextNotification();
                      },
                      child: const Text('Show big text notification'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClickShowOngoingNotification();
                      },
                      child: const Text('Show ongoing notification'),
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClickCancelNotification();
                      },
                      child: const Text('Cancel latest notification'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 240,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.onClicKCancelAllNotifications();
                      },
                      child: const Text('Cancel all notifications'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
