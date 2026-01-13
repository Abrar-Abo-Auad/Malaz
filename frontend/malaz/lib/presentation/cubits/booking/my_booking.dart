
// --- States ---
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/booking/booking.dart';
import '../../../domain/usecases/booking/My_booking_usecase.dart';
import '../../../domain/usecases/booking/update_Booking_Date.dart';
import '../../../domain/usecases/booking/update_status_use_case.dart';

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

class MyBookingCancelSuccess extends MyBookingState {}

class MyBookingUpdateSuccess extends MyBookingState {}

class MyBookingError extends MyBookingState {
  final String message;
  const MyBookingError(this.message);
}


// --- Cubit ---
class MyBookingCubit extends Cubit<MyBookingState> {
  final GetMyBooking getMyBookingUseCase;
  final UpdateBookingUseCase updateBookingUseCase;
  final UpdateStatus updateStatusUseCase;

  MyBookingCubit(this.getMyBookingUseCase, this.updateBookingUseCase, this.updateStatusUseCase) : super(MyBookingInitial());

  Future<void> fetchMyBookings(int userId) async {
    emit(MyBookingLoading());
    final response = await getMyBookingUseCase(userId: userId);

    response.fold(
          (failure) => emit(MyBookingError(failure.message ?? "حدث خطأ أثناء جلب الحجوزات")),
          (bookingList) => emit(MyBookingLoaded(bookingList.booking)),
    );
  }
  Future<void> updateBookingDates({
    required int bookingId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int userId,
  }) async {
    emit(MyBookingLoading());

    final String checkInStr = checkIn.toIso8601String().split('T')[0];
    final String checkOutStr = checkOut.toIso8601String().split('T')[0];

    final result = await updateBookingUseCase(
      bookingId: bookingId,
      checkIn: checkInStr,
      checkOut: checkOutStr,
    );

    result.fold(
          (failure) => emit(MyBookingError(failure.message ?? "فشل تحديث الحجز")),
          (_) async {
        emit(MyBookingUpdateSuccess());
        await fetchMyBookings(userId);
      },
    );
  }
  Future<void> cancelBooking({required int propertyId, required int userId}) async {
    emit(MyBookingLoading());

    final result = await updateStatusUseCase(propertyId:propertyId , status: "cancelled");

    result.fold(
          (failure) => emit(MyBookingError(failure.message ?? "فشل إلغاء الحجز")),
          (_) async {
        emit(MyBookingCancelSuccess());
        await fetchMyBookings(userId);
      },
    );
  }
}
