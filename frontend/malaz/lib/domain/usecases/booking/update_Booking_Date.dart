import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/booking/booking_repository.dart';

class UpdateBookingUseCase {
  final BookingRepository repository;

  UpdateBookingUseCase(this.repository);
  Future<Either<Failure, void>> call({required int bookingId, required String checkIn, required String checkOut,}) async {
    return await repository.updateBookingDates(bookingId: bookingId, checkIn: checkIn, checkOut: checkOut,);
  }
}