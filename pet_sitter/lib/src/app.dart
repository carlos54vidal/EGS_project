import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_sitter/src/SitterList/sample_item.dart';

import 'package:pet_sitter/src/bookings/booking_controller.dart';
import 'package:pet_sitter/src/constants/theme.dart';
import 'package:pet_sitter/src/organisms/organism_home.dart';
import 'package:pet_sitter/src/organisms/organism_list_bookings.dart';
import 'package:pet_sitter/src/organisms/organism_welcome.dart';
import 'SitterList/sample_item_details_view.dart';
import 'SitterList/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.bookingController,
  });

  final BookingController bookingController;
  final SettingsController settingsController;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.bookingController.loadBookings();

    // Perform initialization tasks here
    // For example, initialize state variables or subscribe to streams
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          initialRoute: OrganismWelcome.routeName,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: const MaterialTheme(TextTheme()).light(),

          darkTheme: const MaterialTheme(TextTheme()).dark(),
          themeMode: widget.settingsController.themeMode,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: _getBody(_currentIndex),
            ),
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: _currentIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'PetSitters',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.search),
                  icon: Icon(Icons.search_sharp),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Badge(child: Icon(Icons.pets)),
                  label: 'MyPet',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('2'),
                    child: Icon(Icons.person),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case SitterListView.routeName:
                    return SitterListView(controller: widget.bookingController);

                  case OrganismPetSitterProfile.routeName:
                    return OrganismPetSitterProfile(
                      tag: 'lol',
                      controller: widget.bookingController,
                    );
                  default:
                    return const OrganismWelcome();
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const OrganismHome();
      case 1:
        return SitterListView(controller: widget.bookingController);
      case 2:
        return BookingListView(
          controller: widget.bookingController,
        );
      // Add more cases for additional tabs
      default:
        return Container(); // Fallback case
    }
  }
}
