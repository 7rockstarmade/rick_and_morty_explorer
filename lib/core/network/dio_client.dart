import 'package:dio/dio.dart';
import 'package:rick_and_morty_exporer/core/constants/api_constants.dart';

class DioClient {
  const DioClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
