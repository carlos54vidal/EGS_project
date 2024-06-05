import 'package:dartz/dartz.dart';
import 'package:pet_sitter/src/di.dart';
import 'package:pet_sitter/src/network/api_service.dart';
import 'package:pet_sitter/src/network/error_handler.dart';
import 'package:pet_sitter/src/network/failure.dart';
import 'package:pet_sitter/src/responseDto/booking_responseDto.dart';
import 'package:uuid/uuid.dart';

class BookingService {
  final Uuid _uuid = const Uuid();

  Future<Either<Failure, List<BookingResponseDto>>> getBookings() async {
    final ApiService bookingApi = instance<ApiService>();
    List<BookingResponseDto> bookings;

    try {
      final response = await bookingApi.get(
        endPoint: '/bookings', // assuming your endpoint is '/bookings'
      );

      bookings = BookingResponseDto.listFromJson(response.data);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

    return Right(bookings);
  }

  Future<Either<Failure, void>> deleteBooking(String? bookingId) async {
    final ApiService bookingApi = instance<ApiService>();

    try {
      await bookingApi.delete(
        endPoint:
            '/bookings/$bookingId', // assuming your delete endpoint follows this pattern
      );
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

    return const Right(null);
  }

  Future<Either<Failure, void>> bookDate(
      String dateISO, String description) async {
    final ApiService bookingApi = instance<ApiService>();

    // Construct the request body as a JSON object
    Map<String, dynamic> data = {
      "bookingID": _uuid.v4(), // Generate a new UUID for the booking ID
      "datetime": dateISO,
      "duration": 1, // Adjust this value as needed
      "description": description // Adjust this value as needed
    };

    try {
      await bookingApi.post(
        endPoint: '/bookings', // assuming your booking endpoint is '/bookings'
        data: data, // Include the data payload in the POST request
      );
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

    return const Right(null);
  }

  Future<Either<Failure, List<BookingResponseDto>>> getFreeBookings() async {
    final ApiService bookingApi = instance<ApiService>();
    List<BookingResponseDto> freeBookings;

    try {
      final response = await bookingApi.get(
        endPoint: '/free-slots', // assuming your endpoint is '/bookings'
      );

      freeBookings = BookingResponseDto.listFromJson(response.data);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

    return Right(freeBookings);
  }

  Future<Either<Failure, void>> patchDate(
      String dateISO, String description, String bookingId) async {
    final ApiService bookingApi = instance<ApiService>();

    // Construct the request body as a JSON object
    Map<String, dynamic> data = {
      "datetime": dateISO,
      "duration": 1, // Adjust this value as needed
      "description": description // Adjust this value as needed
    };

    try {
      await bookingApi.patch(
          endPoint: '/bookings/$bookingId',
          data: data // assuming your delete endpoint follows this pattern
          );
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

    return const Right(null);
  }

  Future<Either<Failure, String>> getKey() async {
    final ApiService bookingApi = instance<ApiService>();
    final ClientsResponseDto client;
    // Construct the request body as a JSON object
    Map<String, dynamic> data = {
      "name": "Petcare",
    };

    try {
      final response = await bookingApi.post(endPoint: '/clients/', data: data);

      client = response.data;
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

    return Right(client.apiKey);
  }
}
