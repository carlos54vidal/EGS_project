import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitter/src/atoms/constants.dart';
import 'package:pet_sitter/src/bookings/booking_controller.dart';
import 'package:pet_sitter/src/bookings/payment_service.dart';
import 'package:pet_sitter/src/di.dart';
import 'package:pet_sitter/src/responseDto/booking_responseDto.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

/// Displays a list of SampleItems.
class BookingListView extends StatefulWidget {
  static const routeName = '/listbookings';
  final BookingController controller;
  late final Future<RiveFile> check;
  late final Future<RiveFile> pawLoad;
  late final Future<RiveFile> cross;
  BookingListView({Key? key, required this.controller}) : super(key: key) {
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
  State<BookingListView> createState() => _SitterListViewState();
}

class _SitterListViewState extends State<BookingListView> {
  int _selectedIndex = -1; // Initially no booking is selected
  // Define the date format you want
  DateFormat dateFormat = DateFormat('dd MMM yyyy');
  final PaymentService paymentApi = instance<PaymentService>();
  late DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: _selectedIndex != -1
                ? ListenableBuilder(
                    listenable: widget.controller,
                    builder: (context, child) => Text(
                      'Booking of ${dateFormat.format(widget.controller.bookings[_selectedIndex].datetime ?? DateTime.now())}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const Text('My Bookings'),
            centerTitle: true,
            expandedHeight: _selectedIndex != -1 ? 200 : kToolbarHeight,
            collapsedHeight: kToolbarHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: IconButton(
                color: Theme.of(context).primaryColor,
                iconSize: 50,
                padding: const EdgeInsetsDirectional.all(25),
                alignment: AlignmentDirectional.centerEnd,
                icon: const Icon(Icons.wallet),
                onPressed: () {
                  // Handle edit/patch action here
                  paymentApi.registerPayment(
                      widget.controller.bookings[_selectedIndex].bookingId!);
                  _openUrl(
                      "${Constants.baseUrl}/checkout/${widget.controller.bookings[_selectedIndex].bookingId!}/");
                },
              ),
              titlePadding:
                  const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
              centerTitle: false,
              title: _selectedIndex != -1
                  ? ListenableBuilder(
                      listenable: widget.controller,
                      builder: (context, child) => Text(
                            ' ${(widget.controller.bookings[_selectedIndex].description ?? '')}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.normal,
                            ),
                          ))
                  : const Text(''),
            ),
            actions: _selectedIndex != -1
                ? [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Handle delete action here
                        _deleteBooking(_selectedIndex);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Handle edit/patch action here
                        _editBooking(
                            widget.controller.bookings[_selectedIndex],
                            context,
                            widget
                                .controller.bookings[_selectedIndex].datetime!);
                      },
                    ),
                  ]
                : null,
          ),
          ListenableBuilder(
            listenable: widget.controller,
            builder: (BuildContext context, Widget? child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  DateTime date = widget.controller.bookings[index].datetime ??
                      DateTime.now();
                  return Column(
                    children: [
                      Dismissible(
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            // Handle edit action and prevent dismissal
                            _editBooking(
                                widget.controller.bookings[index],
                                context,
                                widget.controller.bookings[index].datetime!);
                            return false;
                          } else if (direction == DismissDirection.startToEnd) {
                            return await showDialog<bool>(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Do you want to delete this booking?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          return false; // By default, don't dismiss the item
                        },
                        key: Key(
                            widget.controller.bookings[index].bookingId ?? ''),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            // Delete the booking
                            _deleteBooking(index);
                          }
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.blue,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.calendar_month,
                              size: 30,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Theme.of(context).highlightColor),
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            title: Text(
                              ' ${date.day}/${date.month}/${date.year} ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              ' ${widget.controller.bookings[index].description}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }, childCount: widget.controller.bookings.length),
              );
            },
          ),
        ],
      ),
    );
  }

  // Method to edit a booking item
  Future<void> _editBooking(BookingResponseDto booking, BuildContext context,
      DateTime currentDate) async {
    // Handle edit/patch action here
    // Access the booking using index and navigate to the edit page or show a dialog
    String? description;
    bool tryAgain = false;
    await _onTapCalendar(currentDate);
    if (context.mounted) {
      description = await _showDescriptionDialog(context);
    }
    description ??= booking.description;

    do {
      if (context.mounted) {
        _showLoadingDialog(context); // Show loading dialog
      }

      bool success = await widget.controller
          .patchDate(_selectedDate.toIso8601String(), description!,
              booking.bookingId ?? '')
          .timeout(const Duration(seconds: 5), onTimeout: () {
        return false;
      });

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        tryAgain = await _showResultDialog(
            context, success ? '' : 'Please try again', success);
      }
    } while (tryAgain);
  }

  Future<String?> _showDescriptionDialog(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Activities'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(hintText: 'Edit resume'),
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

  Future<void> _openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.inAppWebView, webOnlyWindowName: '_self')) {
      throw Exception('Could not launch $url');
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

  // Method to delete a booking item
  void _deleteBooking(int index) {
    setState(() {
      widget.controller
          .deleteBooking(widget.controller.bookings[index].bookingId);
      // Update the list by removing the deleted booking
      widget.controller.bookings.removeAt(index);
      // Reset the selected index if the deleted item was selected
      if (_selectedIndex == index) {
        _selectedIndex = -1;
      } else if (_selectedIndex > index) {
        _selectedIndex -= 1; // Adjust selected index if needed
      }
    });
  }

  _onTapCalendar(DateTime currentDate) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: currentDate,
      helpText: "Select date to book services ",
      confirmText: "Edit",
      selectableDayPredicate: (DateTime day) {
        // Create a new DateTime object for day with time set to midnight
        if (day.isAfter(DateTime.now())) {
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
}
//https://thispersondoesnotexist.com/ 
//https://shibe.online/
//loremisum