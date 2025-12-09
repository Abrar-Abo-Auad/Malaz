import 'package:dartz/dartz.dart';

abstract class AuthApiService {
  Future<Either> signup();
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either<dynamic, dynamic>> signup() {
    // TODO: implement signup
    throw UnimplementedError();
  }

}