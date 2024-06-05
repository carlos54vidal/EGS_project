import 'package:dartz/dartz.dart';
import 'package:pet_sitter/src/di.dart';
import 'package:pet_sitter/src/network/api_service.dart';
import 'package:pet_sitter/src/network/error_handler.dart';
import 'package:pet_sitter/src/network/failure.dart';
import 'package:pet_sitter/src/responseDto/payment_responseDto.dart';
import 'package:uuid/uuid.dart';

class PaymentService {
  final Uuid _uuid = const Uuid();
  final String _key;

  PaymentService(this._key);

  Future<Either<Failure, void>> registerPayment(
    String id,
  ) async {
    final ApiService paymentApi = instance<ApiService>();

    // Construct the request body as a JSON object
    Map<String, dynamic> data = {
      "id": id, // Generate a new UUID for the booking ID
      "client_unique_key": _key,
      "name": "Petcare", // Adjust this value as needed
      "amount": "25" // Adjust this value as needed
    };

    try {
      final response = await paymentApi.post(
          endPoint: '/payment/',
          data: data // assuming your endpoint is '/Payments'
          );
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

    return const Right(null);
  }
}
