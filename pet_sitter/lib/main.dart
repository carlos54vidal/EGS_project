import 'package:flutter/material.dart';

import 'package:pet_sitter/src/bookings/booking_controller.dart';
import 'package:pet_sitter/src/bookings/booking_service.dart';

import 'src/app.dart';
import 'src/di.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  /* WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized */
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());
  final bookingController = BookingController(BookingService());
  // Define the date format you want

  await initAppModule();

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  runApp(MyApp(
    settingsController: settingsController,
    bookingController: bookingController,
  ));
}
