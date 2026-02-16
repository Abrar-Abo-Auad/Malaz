import 'package:dartz/dartz.dart';
import 'package:malaz/domain/repositories/apartment/apartment_repository.dart';

import '../../../core/errors/failures.dart';
import '../../entities/apartment/apartment.dart';

class SearchPropertiesUseCase {
  final ApartmentRepository repository;

  SearchPropertiesUseCase(this.repository);

  Future<Either<Failure, List<Apartment>>> call({
    String? title,
    String? ownerFirstName,
    String? ownerLastName,
  }) {
    return repository.searchProperties(
      title: title,
      ownerFirstName: ownerFirstName,
      ownerLastName: ownerLastName,
    );
  }
}