
import 'package:malaz/domain/entities/apartment.dart';
import 'package:malaz/domain/entities/apartments_list.dart';

abstract class ApartmentRepository {
  Future<ApartmentsList> getApartments();
}
