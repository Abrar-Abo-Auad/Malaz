import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/domain/entities/booking/booking.dart';
import '../../../domain/usecases/booking/all_booking_use_case.dart';

// --- States ---
abstract class MyBookingState extends Equatable {
  const MyBookingState();
  @override
  List<Object?> get props => [];
}

class MyBookingInitial extends MyBookingState {}

class MyBookingLoading extends MyBookingState {}

class MyBookingLoaded extends MyBookingState {
  final List<Booking> bookings;
  const MyBookingLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class MyBookingError extends MyBookingState {
  final String message;
  const MyBookingError(this.message);
}


// --- Cubit ---
class MyBookingCubit extends Cubit<MyBookingState> {
  final GetUserBooking getMyBookingUseCase;

  MyBookingCubit(this.getMyBookingUseCase) : super(MyBookingInitial());

  Future<void> fetchMyBookings(int userId) async {
    emit(MyBookingLoading());
    final response = await getMyBookingUseCase(userId: userId);

    response.fold(
          (failure) => emit(MyBookingError(failure.message ?? "حدث خطأ أثناء جلب الحجوزات")),
          (bookingList) => emit(MyBookingLoaded(bookingList.booking)),
    );
  }
}