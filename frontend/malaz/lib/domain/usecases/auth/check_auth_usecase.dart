import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/core/usecases/usecase.dart';
import 'package:malaz/domain/repositories/auth_repository.dart';

class CheckAuthUsecase implements UseCase<bool,NoParams>{
  final AuthRepository repository;

  CheckAuthUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async{
    return await repository.isAuthentication();
  }


}