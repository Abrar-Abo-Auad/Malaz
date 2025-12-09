// import 'package:dio/dio.dart';
//
// class DioClient {
//
//   late final Dio _dio;
//   DioClient(): _dio = Dio(
//     BaseOptions(
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8'
//       },
//       responseType: ResponseType.json,
//       sendTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//     ),
//   )..interceptors.addAll((iterable))
// }