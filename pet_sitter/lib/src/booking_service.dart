import 'package:dio/dio.dart';
import 'dart:developer';

import 'package:flutter/material.dart';

class BookingService {
  late Dio dio;
  Map<String, dynamic>? headers;

  BookingService() {
    headers = {"apikey": "12345"};
    dio = Dio();
    configureDio();
  }

  void configureDio() {
    // Set default configs
    dio.options.baseUrl = 'http://localhost:8001/v1';
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.options.headers = headers;
  }

  Future<String> getKey() async {
    final response = await dio.get('');
    return response.data.toString();
  }

  Future<Response> newBooking(DateTime bookingDate) async {
    Response response;

    response = await dio.post(
      '',
      data: {
        "bookingId": "2314",
        "datetime": bookingDate.toIso8601String(),
        "durarion": 3,
        "description": "string"
      },
      options: Options(headers: {
        "Api-Key": "12345",
        "accept": "*/*",
        'Content-Type': 'application/json'
      }),
    );
    return response;
  }

  Set<DateTime> getBookings() {
    Set<DateTime> re = {
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().add(const Duration(days: 3))
    };
    return re;
  }
}
