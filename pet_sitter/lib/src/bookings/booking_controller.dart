import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pet_sitter/src/bookings/booking_service.dart';
import 'package:pet_sitter/src/network/failure.dart';
import 'package:pet_sitter/src/responseDto/booking_responseDto.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';

class BookingController with ChangeNotifier {
  BookingController(this._bookingService);

  final BookingService _bookingService;

  late List<BookingResponseDto> _bookings = [];
  late List<BookingResponseDto> _freeBookings = [];
  late String _apiKeyBooking = '';

  List<BookingResponseDto> get bookings => _bookings;
  String get apiKeyBooking => _apiKeyBooking;
  final Logger _logger = Logger('BookingLogger');

  final Uuid uuid = const Uuid();

  Future<void> loadBookings() async {
    Either<Failure, List<BookingResponseDto>> eitherBookings =
        await _bookingService.getBookings();

    eitherBookings.fold(
      (failure) {
        // Handle failure case
        // For example: print failure message
        _logger.severe('Failed to get bookings: ${failure.message}');
      },
      (bookingList) {
        // Handle success case
        // Assign the booking list to the variable
        _bookings = bookingList;
        notifyListeners();
      },
    );
  }

  Future<void> freeBookings() async {
    Either<Failure, List<BookingResponseDto>> eitherBookings =
        await _bookingService.getFreeBookings();

    eitherBookings.fold(
      (failure) {
        // Handle failure case

        _logger.severe('Failed to get free bookings: ${failure.message}');
      },
      (bookingList) {
        // Handle success case
        // Assign the booking list to the variable
        _freeBookings = bookingList;
        notifyListeners();
      },
    );
  }

  Future<void> deleteBooking(String? bookingId) async {
    if (bookingId == null) {
      // Log and handle the null case for bookingId
      _logger.severe('Booking ID is null. Cannot delete booking.');
      return;
    }

    // Assuming the BookingService has a method to delete a booking by ID
    Either<Failure, void> result =
        await _bookingService.deleteBooking(bookingId);

    result.fold(
      (failure) {
        // Handle failure case
        _logger.severe('Failed to delete booking: ${failure.message}', failure);
      },
      (_) {
        // Handle success case
        // Remove the booking from the list if deletion was successful
        _bookings.removeWhere((booking) => booking.bookingId == bookingId);
        notifyListeners();
        _logger.info('Booking successfully deleted: $bookingId');
      },
    );
  }

  Future<bool> bookDate(String dateISO, String description) async {
    Either<Failure, void> result =
        await _bookingService.bookDate(dateISO, description);
    return result.fold(
      (failure) {
        _logger.severe('Failed to book date: ${failure.message}');
        return false;
      },
      (_) {
        loadBookings();
        notifyListeners();
        return true;
      },
    );
  }

  // Helper function to check if a set contains a specific day
  bool containsDay(DateTime day) {
    for (BookingResponseDto d in _freeBookings) {
      if (d.datetime!.year == day.year &&
          d.datetime!.month == day.month &&
          d.datetime!.day == day.day) {
        return true;
      }
    }
    return false;
  }

  Future<bool> patchDate(
      String dateISO, String description, String uuid) async {
    Either<Failure, void> result =
        await _bookingService.patchDate(dateISO, description, uuid);
    return result.fold(
      (failure) {
        _logger.severe('Failed to patch date: ${failure.message}');
        return false;
      },
      (_) {
        loadBookings();
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> getKey() async {
    Either<Failure, String> result = await _bookingService.getKey();
    result.fold(
      (failure) {
        _logger.severe('Failed to get API key: ${failure.message}');
        // Handle the error state appropriately in your app
      },
      (key) {
        _apiKeyBooking = key;
        loadBookings();
        notifyListeners();
        // No return value needed for void
      },
    );
  }
}
