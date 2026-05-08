import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const baseUrl = 'https://pepe.codedoc.cloud/';

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
}
