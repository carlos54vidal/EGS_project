import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_sitter/src/bookings/payment_service.dart';
import 'package:pet_sitter/src/network/api_service.dart';
import 'package:pet_sitter/src/network/dio_factory.dart';
import 'package:pet_sitter/src/network/failure.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // Register DioFactory without the API key initially
  instance.registerLazySingleton<DioFactory>(() => DioFactory());

  // Request the API key
  final dioFactory = instance<DioFactory>();
  Either<Failure, String> bookingKey =
      await dioFactory.requestApiKey("/clients/");

  return bookingKey.fold(
    (failure) {
      print('Failed to obtain API key: ${failure.message}');
    },
    (key) async {
      instance.registerLazySingleton<PaymentService>(() => PaymentService(key));

      // Re-register DioFactory with the obtained API key
      instance.unregister<DioFactory>();
      instance
          .registerLazySingleton<DioFactory>(() => DioFactory.withApiKey(key));

      // Create the Dio instance with the API key
      final dio = await instance<DioFactory>().getDio();

      // Register ApiService with the configured Dio instance
      instance.registerLazySingleton<ApiService>(() => ApiService(dio));
    },
  );
}
