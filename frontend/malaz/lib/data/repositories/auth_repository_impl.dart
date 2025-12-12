// data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/errors/exceptions.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/data/datasources/local/auth_local_datasource.dart';
import 'package:malaz/data/datasources/remote/auth_remote_datasource.dart';
import 'package:malaz/domain/entities/user_entity.dart';
import 'package:malaz/domain/repositories/auth_repository.dart';

import '../models/user_model.dart';
import '../utils/response_parser.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final AuthLocalDatasource authLocalDatasource;

  AuthRepositoryImpl({
    required this.authRemoteDatasource,
    required this.authLocalDatasource,
  });

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await authLocalDatasource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(const CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthentication() async {
    try {
      final token = await authLocalDatasource.getCachedToken();
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(const CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final result = await authRemoteDatasource.login(
        phone: phoneNumber,
        password: password,
      );

      final dataMap = (result['user'] ?? result['data'] ?? result) as Map<
          String,
          dynamic>;
      final user = UserModel.fromJson(dataMap);

      /// if backend gives token:
      final token = result['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await authLocalDatasource.cacheToken(token);
      } else {
        /// fallback: cache a mock token if you want:
        /// await authLocalDatasource.cacheToken('mock_token_${user.id}');
      }
      await authLocalDatasource.cacheUser(user);
      return Right(user);
    } on InvalidCredentialsException {
      return Left(const InvalidCredentialsFailure('Invalid credentials'));
    } on ServerException {
      return Left(const ServerFailure('Server error'));
    } on CacheException {
      return Left(const CacheFailure('Cache error'));
    } catch (e) {
      return Left(const GeneralFailure('Unknown error'));
    }
  }


  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemoteDatasource.logout();
      await authLocalDatasource.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
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
    try {
      final result = await authRemoteDatasource.registerUser(
        phone: phone,
        role: role,
        firstName: firstName,
        lastName: lastName,
        password: password,
        passwordConfirmation: passwordConfirmation,
        dateOfBirth: dateOfBirth,
        profileImage: profileImage,
        identityImage: identityImage,
      );
      final dataMap = (result['user'] ?? result['data'] ?? result) as Map<String, dynamic>;
      final user = UserModel.fromJson(dataMap);
      final token = result['token'] as String?;

      if (token != null && token.isNotEmpty) {
        await authLocalDatasource.cacheToken(token);
      }
      await authLocalDatasource.cacheUser(user);

      return Right(user);
    } on ServerException catch (e) {
      final msg = e.message ?? 'Server error';
      return Left(ServerFailure(msg));
    } on CacheException {
      return Left(const CacheFailure());
    } catch (e) {
      return Left(const GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp({required String phone}) async {
    try {
      await authRemoteDatasource.sendOtp(phone: phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(const GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(
      {required String phone, required String otp}) async {
    try {
      final res = await authRemoteDatasource.verifyOtp(phone: phone, otp: otp);
      // assume res contains success boolean or message
      final success = extractSuccess(res); // طبق شكل الاستجابة
      if (success) return Right(true);

      // فشل التحقق — حاول استخراج رسالة من الرد
      final message = extractMessage(res) ?? 'Invalid code';
      return Left(ServerFailure(message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(const GeneralFailure());
    }
  }
}