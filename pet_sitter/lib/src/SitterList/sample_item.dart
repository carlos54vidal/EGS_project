import 'dart:async';
import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_sitter/src/bookings/payment_service.dart';
import 'package:pet_sitter/src/di.dart';
import 'package:rive/rive.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pet_sitter/src/atoms/button.dart';
import 'package:pet_sitter/src/atoms/image_profile.dart';
import 'package:pet_sitter/src/atoms/image_profile_zoom.dart';
import 'package:pet_sitter/src/bookings/booking_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:math';
import 'package:http/http.dart' as http; // Import the http package

import 'package:pet_sitter/src/atoms/profileText.dart';
import 'package:pet_sitter/src/booking_service.dart';
import 'package:pet_sitter/src/entities/petsitter.dart';
import 'package:pet_sitter/src/settings/settings_view.dart';

import '../constants/constant_colors.dart';

class OrganismPetSitterProfile extends StatefulWidget {
  static const String routeName = '/Sitter';
  Object tag;
  Petsitter? sitter;
  final BookingController controller;
  late final Future<RiveFile> check;
  late final Future<RiveFile> pawLoad;
  late final Future<RiveFile> cross;

  OrganismPetSitterProfile(
      {Key? key, required this.tag, this.sitter, required this.controller})
      : super(key: key) {
    // Initialize check asynchronously
    check = _loadRiveFile(0);
    pawLoad = _loadRiveFile(1);
    cross = _loadRiveFile(2);
  }

  Future<RiveFile> _loadRiveFile(int i) async {
    switch (i) {
      case 0:
        return RiveFile.asset('assets/check_animation.riv');
      case 1:
        return RiveFile.asset('assets/paw.riv');
      case 2:
        return RiveFile.asset('assets/cross.riv');
      default:
        return RiveFile.asset('assets/paw.riv');
    }
  }

  @override
  State<OrganismPetSitterProfile> createState() =>
      OrganismPetSitterProfileState();
}

class OrganismPetSitterProfileState extends State<OrganismPetSitterProfile>
    with SingleTickerProviderStateMixin {
  bool _zoomed = false;
  Widget _zoomImg = Container();

  final List<String> tabNames = ['Posts', 'Reviews'];
  late TabController _tabController;
  final BookingService serviceBooking = BookingService();

  late Set<DateTime> availableDays;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabNames.length, vsync: this);
    availableDays = serviceBooking.getBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.sitter!.fname}\'s profile',
          textAlign: TextAlign.center,
        ),
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
      body: SafeArea(
        child: _zoom(
          chi: Column(
            children: [
              _infoSection,
              _tab,
            ],
          ),
        ),
      ),
    );
  }

  _onZoom(Widget wi) {
    setState(() {
      _zoomed = !_zoomed;
      _zoomImg = wi;
    });
  }

  Widget _zoom({required Column chi}) => _zoomed
      ? GestureDetector(
          onTap: () => _onZoom(Container()),
          child: Blur(
            blurColor: Colors.transparent,
            colorOpacity: 0.5,
            blur: 5,
            overlay: _zoomImg,
            child: chi,
          ),
        )
      : Container(child: chi);

  Widget get _infoSection {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(right: 15, top: 15),
              child: _booking),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _profileData,
              const ProfileText(
                text:
                    "Introducing Joshua, a devoted pet sitter with a deep passion for his four-legged companions.",
              ),
            ],
          ),
        ]);
  }

  Widget get _booking {
    return GestureDetector(
      onTap: () => {_handleBooking(context)},
      child: const Icon(
        Icons.calendar_month,
        size: 30,
      ),
    );
  }

  Widget get _profileData {
    double rating = 4.5;
    int lol = widget.tag as int;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hero(
          tag: widget.tag,
          child: const CircleAvatar(
            radius: 57,
            backgroundImage: AssetImage("assets/images/homem3.jpg"),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          '${widget.sitter!.fname} ${widget.sitter!.lname}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "3456 Followers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Rating: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            Text(
              rating.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _tab {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: tabNames.map((String name) => Tab(text: name)).toList(),
            /* labelColor:
                Colors.black, // Set the color for selected/active tab text
            unselectedLabelColor:
                Colors.grey, // Set the color for unselected/inactive tab text
            indicatorColor: ConstantColors.primary, */
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Replace with your tab content widgets
                Center(child: _gallery),
                Center(child: _review),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _review {
    final Random random = Random();
    final List<String> names = [
      'John Doe',
      'Jane Smith',
      'Michael Johnson',
      'Emily Davis',
      'David Wilson',
    ];

    final List<String> comments = [
      'Great pet sitter! Highly recommend.',
      'Very reliable and professional.',
      'Took excellent care of my pet. Will book again.',
      'Friendly and attentive towards animals.',
      'Fantastic experience. Thank you!',
    ];

    final List<String> avatarImages = [
      'assets/images/homem1.jpg',
      'assets/images/homem2.jpg',
      'assets/images/mulher2.jpg',
      'assets/images/mulher3.jpg',
      'assets/images/mulher1.jpg',
    ];

    final List<String> commentImages = [
      'assets/images/comment1.jpg',
      'assets/images/comment2.jpg',
      'assets/images/comment3.jpg',
      'assets/images/comment4.jpg',
      'assets/images/comment5.jpg',
    ];

    int currentIndex = 0;

    String getNextName() {
      if (currentIndex >= names.length) {
        currentIndex = 0;
        names.shuffle();
      }
      return names[currentIndex++];
    }

    String getNextComment() {
      if (currentIndex >= comments.length) {
        currentIndex = 0;
        comments.shuffle();
      }
      return comments[currentIndex++];
    }

    String getNextAvatarImage() {
      if (currentIndex >= avatarImages.length) {
        currentIndex = 0;
        avatarImages.shuffle();
      }
      return avatarImages[currentIndex++];
    }

    String getNextCommentImage() {
      if (currentIndex >= commentImages.length) {
        currentIndex = 0;
        commentImages.shuffle();
      }
      return commentImages[currentIndex++];
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final int rating = random.nextInt(6); // Random rating from 1 to 5
              final String name = getNextName();
              final String comment = getNextComment();
              final String avatarImage = getNextAvatarImage();
              final String commentImage = getNextCommentImage();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 2,
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(avatarImage),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => {}),
                ),
              );
            },
            childCount: 5,
          ),
        ),
      ],
    );
  }

  Widget get _gallery {
    return SingleChildScrollView(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(2),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: [
          GestureDetector(
              onLongPress: () =>
                  {_onZoom(const ImageZoom(image: "assets/images/persa.jpg"))},
              child: const ImageInProfile(image: "assets/images/persa.jpg")),
          GestureDetector(
              onLongPress: () => _onZoom(
                  const ImageZoom(image: "assets/images/pastorAlemao2.jpg")),
              child: const ImageInProfile(
                  image: "assets/images/pastorAlemao2.jpg")),
          GestureDetector(
              onLongPress: () => {
                    _onZoom(const ImageZoom(
                        image: "assets/images/pastorAlemao3.jpg"))
                  },
              child: const ImageInProfile(
                  image: "assets/images/pastorAlemao3.jpg")),
          GestureDetector(
              onLongPress: () => {
                    _onZoom(const ImageZoom(
                        image: "assets/images/pastorAlemao4.jpg"))
                  },
              child: const ImageInProfile(
                  image: "assets/images/pastorAlemao4.jpg")),
          GestureDetector(
              onLongPress: () =>
                  {_onZoom(const ImageZoom(image: "assets/images/jack.jpg"))},
              child: const ImageInProfile(image: "assets/images/jack.jpg")),
          GestureDetector(
              onLongPress: () =>
                  {_onZoom(const ImageZoom(image: "assets/images/jack2.jpg"))},
              child: const ImageInProfile(image: "assets/images/jack2.jpg")),
          GestureDetector(
              onLongPress: () => {
                    _onZoom(const ImageZoom(image: "assets/images/dogpark.jpg"))
                  },
              child: const ImageInProfile(image: "assets/images/dogpark.jpg")),
          GestureDetector(
              onLongPress: () =>
                  {_onZoom(const ImageZoom(image: "assets/images/dogEat.jpg"))},
              child: const ImageInProfile(image: "assets/images/dogEat.jpg")),
          GestureDetector(
              onLongPress: () => {
                    _onZoom(
                        const ImageZoom(image: "assets/images/saoBernardo.jpg"))
                  },
              child:
                  const ImageInProfile(image: "assets/images/saoBernardo.jpg")),
          GestureDetector(
              onLongPress: () => {
                    _onZoom(
                        const ImageZoom(image: "assets/images/dogLeash.jpg"))
                  },
              child: const ImageInProfile(image: "assets/images/dogLeash.jpg")),
          GestureDetector(
              onLongPress: () =>
                  {_onZoom(const ImageZoom(image: "assets/images/puppy.jpg"))},
              child: const ImageInProfile(image: "assets/images/puppy.jpg")),
          GestureDetector(
              onLongPress: () =>
                  {_onZoom(const ImageZoom(image: "assets/images/puppy2.jpg"))},
              child: const ImageInProfile(image: "assets/images/puppy2.jpg")),
          GestureDetector(
              onLongPress: () => {
                    _onZoom(const ImageZoom(
                        image: "assets/images/pastorAlemao.jpg"))
                  },
              child: const ImageInProfile(
                  image: "assets/images/pastorAlemao.jpg")),

          // Other images...
        ],
      ),
    ).frosted(
      frostColor: Theme.of(context).canvasColor,
    );
  }

  Widget get _settingsButton {
    return Button(
      label: "Settings",
      onTap: () => Navigator.pushNamed(context, SettingsView.routeName),
      width: 250,
    );
  }

  Widget get _signOutButton {
    return Button(
      label: "Sign out",
      onTap: () {
        Navigator.pushNamed(context, SettingsView.routeName);
      },
      width: 250,
      color: ConstantColors.white,
      textColor: ConstantColors.primary,
      borderColor: ConstantColors.primary,
    );
  }

  _onTapCalendar() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now().add(const Duration(days: 1)),
      helpText: "Select date to book ${widget.sitter!.fname}'s services ",
      confirmText: "Book now",
      selectableDayPredicate: (DateTime day) {
        // Create a new DateTime object for day with time set to midnight
        DateTime dayOnly = DateTime(day.year, day.month, day.day);
        if (day.isAfter(DateTime.now()) &&
            !_containsDay(availableDays, dayOnly)) {
          return true;
        }
        return false;
      },
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  Future<void> _openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.inAppWebView, webOnlyWindowName: '_self')) {
      throw Exception('Could not launch $url');
    }
  }

  // Helper function to check if a set contains a specific day
  bool _containsDay(Set<DateTime> days, DateTime day) {
    for (DateTime d in days) {
      if (d.year == day.year && d.month == day.month && d.day == day.day) {
        return true;
      }
    }
    return false;
  }

  Future<String?> _showDescriptionDialog(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Description'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(
                hintText: 'Brief description of your apointment'),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, textFieldController.text);
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /* CircularProgressIndicator(), */
                SizedBox(
                  width: 50,
                  height: 50,
                  child: FutureBuilder<RiveFile>(
                    future: widget.pawLoad,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show loading indicator while waiting for RiveFile to load
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Handle error if RiveFile loading failed
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // RiveFile is ready, build RiveAnimation using it
                        final riveFile = snapshot.data!;
                        return RiveAnimation.direct(riveFile);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
                const Text('Processing...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleBooking(BuildContext context) async {
    final PaymentService paymentApi = instance<PaymentService>();
    String? description;
    bool tryAgain = false;
    await _onTapCalendar();
    if (context.mounted) {
      description = await _showDescriptionDialog(context);
    }
    if (description != null) {
      do {
        if (context.mounted) {
          _showLoadingDialog(context); // Show loading dialog}
        }

        bool success = await widget.controller
            .bookDate(_selectedDate.toIso8601String(), description)
            .timeout(const Duration(seconds: 5), onTimeout: () {
          return false;
        });
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog}

          tryAgain = await _showResultDialog(
              context, success ? '' : 'Please try again', success);
        }
      } while (tryAgain);
    }
  }

  Future<bool> _showResultDialog(
      BuildContext context, String message, bool isSuccess) async {
    // Create a Completer to hold the result
    Completer<bool> completer = Completer<bool>();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsetsDirectional.only(top: 50),
          title: Text(
            isSuccess ? 'Success!' : 'Failed!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 50,
            height: 50,
            child: FutureBuilder<RiveFile>(
              future: isSuccess ? widget.check : widget.cross,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while waiting for RiveFile to load
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Handle error if RiveFile loading failed
                  return Text('Error: ${snapshot.error}');
                } else {
                  // RiveFile is ready, build RiveAnimation using it
                  final riveFile = snapshot.data!;
                  return RiveAnimation.direct(
                    riveFile,
                    fit: BoxFit.fitHeight,
                  );
                }
              },
            ),
          ),
          actions: <Widget>[
            isSuccess
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      completer
                          .complete(false); // Resolve the completer with true
                    },
                    child: const Text('OK'),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          completer.complete(
                              true); // Resolve the completer with false
                        },
                        child: const Text('Try Again'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          completer.complete(
                              false); // Resolve the completer with false
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
          ],
        );
      },
    );

    // Return the Future<bool> from the Completer
    return completer.future;
  }
}
