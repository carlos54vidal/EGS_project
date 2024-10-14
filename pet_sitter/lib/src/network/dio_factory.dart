import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_sitter/src/atoms/constants.dart';
import 'package:pet_sitter/src/network/error_handler.dart';
import 'package:pet_sitter/src/network/failure.dart';
import 'package:pet_sitter/src/responseDto/booking_responseDto.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String KEY = "Api-Key";

class DioFactory {
  final String? apiKey;

  DioFactory() : apiKey = null;

  DioFactory.withApiKey(this.apiKey);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    Map<String, String> headers = {
      ACCEPT: '*/*',
      if (apiKey != null) KEY: apiKey!,
      CONTENT_TYPE: APPLICATION_JSON,
      "Cookie": "sessionid=12345",
    };

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: headers,
      connectTimeout: Constants.apiTimeOut,
      receiveTimeout: Constants.apiTimeOut,
      sendTimeout: Constants.apiTimeOut,
    );

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }

  Future<Either<Failure, String>> requestApiKey(String endpoint) async {
    final ClientsResponseDto client;

    Dio dio = Dio(BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: Constants.apiTimeOut,
      receiveTimeout: Constants.apiTimeOut,
      sendTimeout: Constants.apiTimeOut,
    ));

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    Map<String, dynamic> data = {
      "name": "Petcare",
    };

    try {
      final response = await dio.post(endpoint, data: data);

      client = ClientsResponseDto.fromJson(response.data);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

    return Right(client.apiKey);
  }
}
