import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/domain/entities/user_entity.dart';
import 'package:malaz/domain/usecases/auth/check_auth_usecase.dart';
import 'package:malaz/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:malaz/domain/usecases/auth/login_usecase.dart';
import 'package:malaz/domain/usecases/auth/logout_usecase.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/send_otp_usecase.dart';
import '../../../domain/usecases/auth/verify_otp_usecase.dart';

// --- States --- //

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}

class OtpSending extends AuthState {}

class OtpSent extends AuthState {}

class OtpSendError extends AuthState { final String message; OtpSendError(this.message); }

class OtpVerifying extends AuthState {}

class OtpVerified extends AuthState {}

class OtpVerifyError extends AuthState { final String message; OtpVerifyError(this.message); }

// --- Cubit --- //

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final CheckAuthUsecase checkAuthUsecase;
  final RegisterUsecase registerUsecase;
  final SendOtpUsecase sendOtpUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;

  AuthCubit({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
    required this.checkAuthUsecase,
    required this.registerUsecase,
    required this.sendOtpUsecase,
    required this.verifyOtpUsecase
  }) : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    final res = await checkAuthUsecase(NoParams());
    res.fold(
          (failure) => emit(AuthUnauthenticated()),
          (isAuth) async {
        if (isAuth == true) {
          final userRes = await getCurrentUserUsecase(NoParams());
          userRes.fold(
                (_) => emit(AuthUnauthenticated()),
                (user) {
              if (user != null) emit(AuthAuthenticated(user));
              else emit(AuthUnauthenticated());
            },
          );
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> register({
    required String phone,
    required String firstName,
    required String lastName,
    required String password,
    required String dateOfBirth,
    required XFile profileImage,
    required XFile identityImage,
  }) async {
    emit(AuthLoading());

    try {
      final res = await registerUsecase(RegisterParams(
        phone: phone,
        role: 'OWNER',
        firstName: firstName,
        lastName: lastName,
        password: password,
        passwordConfirmation: password,
        dateOfBirth: dateOfBirth,
        profileImage: profileImage,
        identityCardImage: identityImage,
      ));
      print('>>>> ${res}');
      res.fold(
            (failure) {
          emit(AuthError(message: _mapFailureToMessage(failure)));
          emit(AuthUnauthenticated());
        },
            (user) {
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      emit(AuthError(message: 'Error preparing images: $e'));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({required String phone, required String password}) async {
    emit(AuthLoading());
    try {
      final res = await loginUsecase.call(LoginParams(phoneNumber: phone, password: password));
      res.fold(
            (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
            (user) => emit(AuthAuthenticated(user)),
      );
    } catch (e) {
      emit(AuthError(message: 'Unexpected error: $e'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await logoutUsecase.call(NoParams());
    emit(AuthUnauthenticated());
  }


  Future<void> sendOtp(String phone) async {
    emit(OtpSending());
    final res = await sendOtpUsecase(SendOtpParams(phone));
    res.fold(
          (failure) => emit(OtpSendError(_mapFailureToMessage(failure))),
          (_) => emit(OtpSent()),
    );
  }


  Future<void> verifyOtp(String phone, String otp) async {
    emit(OtpVerifying());
    final res = await verifyOtpUsecase(VerifyOtpParams(phone: phone, otp: otp));
    res.fold(
          (failure) => emit(OtpVerifyError(_mapFailureToMessage(failure))),
          (success) {
        if (success) emit(OtpVerified());
        else emit(OtpVerifyError('Invalid code'));
      },
    );
  }

  String _mapFailureToMessage(Failure f) {
    if (f is InvalidCredentialsFailure) return 'خطأ في بيانات الدخول';
    if (f is NetworkFailure) return 'تحقق من اتصال الانترنت';
    if (f is ServerFailure) return 'مشكلة في الخادم';
    return 'حدث خطأ غير متوقع';
  }
}
