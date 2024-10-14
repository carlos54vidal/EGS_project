import 'package:flutter/material.dart';
import 'package:pet_sitter/isar_service.dart';
import 'package:pet_sitter/src/bookings/booking_controller.dart';
import 'package:pet_sitter/src/constants/constant_colors.dart';
import 'package:pet_sitter/src/entities/petsitter.dart';
import 'package:pet_sitter/src/organisms/organism_hero.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SitterListView extends StatefulWidget {
  SitterListView({
    required this.controller,
    super.key,
  });

  static const routeName = '/list';
  final BookingController controller;

  final service = IsarService();
  late var idx;

  @override
  State<SitterListView> createState() => _SitterListViewState();
}

class _SitterListViewState extends State<SitterListView> {
  @override
  void initState() {
    super.initState();
    // Perform initialization tasks here
    // For example, initialize state variables or subscribe to streams
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Search PetSitters'),
          backgroundColor: ThemeData().focusColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 20),
          child: FutureBuilder<List<Petsitter?>>(
            future: widget.service.getAllSitters(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading indicator while data is being fetched
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final petsitters = snapshot.data!;
                return ListView.separated(
                  // Providing a restorationId allows the ListView to restore the
                  // scroll position when a user leaves and returns to the app after it
                  // has been killed while running in the background.
                  restorationId: 'SitterListView',
                  itemCount: petsitters.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.blueGrey,
                    indent: 30,
                    endIndent: 30,
                    height: 30,
                  ),
                  itemBuilder: (context, index) {
                    final petsitter = petsitters[index];
                    return Container(
                      alignment: Alignment.center,
                      height: 100,
                      child: ListTile(
                          dense: false,
                          selectedColor: Colors.blueGrey,
                          title: Text(
                            ('${petsitter?.fname} ${petsitter?.lname}'),
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          //subtitle: petsitter.rating,
                          trailing: const Icon(Icons.arrow_forward_ios),
                          leading: Hero(
                            tag: index,
                            child: const CircleAvatar(
                              // Display the Flutter Logo image asset.

                              radius: 50,
                              backgroundImage:
                                  (AssetImage("assets/images/homem3.jpg")) ??
                                      AssetImage("assets/images/user_icon.png"),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          onTap: () {
                            // Navigate to the details page. If the user leaves and returns to
                            // the app after it has been killed while running in the
                            // background, the navigation stack is restored.
                            widget.idx = index; //to pass to hero

                            Navigator.of(context).push(
                              HeroPageRoute(
                                bookingController: widget.controller,
                                child: petsitter,
                                tag: index,
                                initElevation: 6.0,
                                initShape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                initBackgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            );
                          }),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
