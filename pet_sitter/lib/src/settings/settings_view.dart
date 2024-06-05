import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pet_sitter/src/booking_service.dart';
import 'package:pet_sitter/src/di.dart';
import 'package:pet_sitter/src/network/api_service.dart';
import 'package:pet_sitter/src/responseDto/booking_responseDto.dart';
import 'package:uuid/uuid.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;
  final BookingService serviceBooking = BookingService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ApiService booking = instance<ApiService>();
  final Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;

    // Determine if dark mode is selected or if the system theme is dark
    bool isDarkMode = controller.themeMode == ThemeMode.dark ||
        (controller.themeMode == ThemeMode.system &&
            brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: const Text('Theme Mode'),
                      value: isDarkMode,
                      thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Icon(Icons.light_mode);
                          }
                          return const Icon(Icons.dark_mode);
                        },
                      ),
                      secondary: const Icon(Icons.lightbulb_outline),
                      onChanged: (value) {
                        /*  _showNotification("Theme Mode Changed!"); */
                        // If the current theme mode is system, toggle based on current brightness
                        if (controller.themeMode == ThemeMode.system) {
                          controller.updateThemeMode(
                            brightness == Brightness.dark
                                ? ThemeMode.light
                                : ThemeMode.dark,
                          );
                        } else {
                          controller.updateThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a notification
  Future<void> _showNotification(String title) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      "lol",
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
