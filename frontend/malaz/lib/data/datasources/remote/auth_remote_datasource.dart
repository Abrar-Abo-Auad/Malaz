// data/datasources/auth/auth_remote_datasource.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/errors/exceptions.dart';
import 'package:path/path.dart';

import '../../../core/service_locator/service_locator.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  });

  Future<void> logout();

  Future<Map<String, dynamic>> registerUser({
    required String phone,
    required String role,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirmation,
    required String dateOfBirth,
    required XFile profileImage,
    required XFile identityImage,
  });

  Future<void> sendOtp({required String phone});

  Future<Map<String, dynamic>> verifyOtp({required String phone, required String otp});

}


class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> registerUser({
    required String phone,
    required String role,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirmation,
    required String dateOfBirth,
    required XFile profileImage,
    required XFile identityImage,
  }) async {
    final url = '${baseurlForUsers}register';

    try {
      final formData = FormData.fromMap({
        'phone': phone,
        'role': role,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'date_of_birth': dateOfBirth,
        'profile_image': await MultipartFile.fromFile(
          profileImage.path,
          filename: basename(profileImage.path),
        ),
        'identity_card_image': await MultipartFile.fromFile(
          identityImage.path,
          filename: basename(identityImage.path),
        ),
      });

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
          followRedirects: false,
        ),
        // إذا تريدي callback للـ progress:
         onSendProgress: (sent, total) { print('uploaded $sent / $total'); },
      );

      print('>>> register HTTP ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException('register failed: ${response.statusCode} - ${response.data}');
      }
    } on DioError catch (e) {
    print('>>> DioError REGISTER: $e');
    throw ServerException(e.response?.data?.toString() ?? e.message);
    } catch (e) {
    throw ServerException(e.toString());
    }
  }


  @override
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final url = '${baseurlForUsers}login';
    try {
      final response = await dio.post(url, data: {'phone': phone, 'password': password});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException('login failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      /// if backend returns 401 with message -> we can throw InvalidCredentialsException
      if (e.response?.statusCode == 401) {
        throw InvalidCredentialsException(e.response?.data?.toString());
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      ///
      return;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> sendOtp({required String phone}) async {
    try {
      final url = '${baseurlForUsers}send-otp';
      final response = await dio.post(url, queryParameters: {'phone': phone});
      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
        return;
      } else {
        throw ServerException('sendOtp failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({required String phone, required String otp}) async {
    try {
      final url = '${baseurlForUsers}verify-otp';
      final response = await dio.post(url, queryParameters: {'phone': phone, 'otp': otp});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException('verifyOtp failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw ServerException(e.message);
    }
  }
}
