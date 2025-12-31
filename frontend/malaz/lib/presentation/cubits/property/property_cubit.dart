import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/apartment.dart';
import '../../../domain/usecases/apartment/add_apartment_use_case.dart';
import '../../../domain/usecases/apartment/my_apartment_use_case.dart';


abstract class ApartmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApartmentInitial extends ApartmentState {}

class AddApartmentLoading extends ApartmentState {}
class AddApartmentSuccess extends ApartmentState {
  final String message;
  AddApartmentSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}
class AddApartmentError extends ApartmentState {
  final String message;
  AddApartmentError({required this.message});
  @override
  List<Object?> get props => [message];
}

class MyApartmentsLoading extends ApartmentState {}
class MyApartmentsLoaded extends ApartmentState {
  final List<Apartment> myApartments;
  final bool hasReachedMax;

  MyApartmentsLoaded({required this.myApartments, this.hasReachedMax = false});
  @override
  List<Object?> get props => [myApartments, hasReachedMax];
}
class MyApartmentsError extends ApartmentState {
  final String message;
  MyApartmentsError({required this.message});
  @override
  List<Object?> get props => [message];
}


class AddApartmentCubit extends Cubit<ApartmentState> {
  final AddApartmentUseCase addApartmentUseCase;

  AddApartmentCubit({required this.addApartmentUseCase}) : super(ApartmentInitial());

  Future<void> submitApartment({
    required String title,
    required int price,
    required String city,
    required String governorate,
    required String address,
    required String description,
    required String type,
    required int rooms,
    required int bathrooms,
    required int bedrooms,
    required int area,
    required List<XFile> images,
    required XFile main_pic,
  }) async {
    emit(AddApartmentLoading());

    final params = ApartmentParams(
      title: title,
      price: price,
      city: city,
      governorate: governorate,
      address: address,
      description: description,
      type: type,
      rooms: rooms,
      bathrooms: bathrooms,
      bedrooms: bedrooms,
      area: area,
      mainImageUrl: images,
      main_pic: main_pic,
    );

    final result = await addApartmentUseCase.call(params);

    result.fold(
          (failure) => emit(AddApartmentError(message: _mapFailureToMessage(failure))),
          (unit) => emit(AddApartmentSuccess(message: "تم رفع العقار بنجاح، وهو الآن قيد المراجعة.")),
    );
  }

  void resetState() => emit(ApartmentInitial());

  String _mapFailureToMessage(Failure f) {
    if (f is ServerFailure) return f.message ?? "خطأ من السيرفر";
    if (f is NetworkFailure) return "تأكد من الاتصال بالإنترنت";
    return "حدث خطأ غير متوقع";
  }
}


class MyApartmentsCubit extends Cubit<ApartmentState> {
  final GetMyApartmentsUseCase getMyApartmentsUseCase;

  String? _nextCursor;
  bool _isFetching = false;

  MyApartmentsCubit({required this.getMyApartmentsUseCase}) : super(ApartmentInitial());

  Future<void> fetchMyApartments({bool isRefresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      if (isRefresh) {
        _nextCursor = null;
        emit(MyApartmentsLoading());
      } else if (state is ApartmentInitial) {
        emit(MyApartmentsLoading());
      }

      final result = await getMyApartmentsUseCase.call(cursor: _nextCursor);

      List<Apartment> currentList = [];
      if (state is MyApartmentsLoaded && !isRefresh) {
        currentList = (state as MyApartmentsLoaded).myApartments;
      }

      _nextCursor = result.nextCursor;

      emit(MyApartmentsLoaded(
        myApartments: currentList + result.apartments,
        hasReachedMax: _nextCursor == null,
      ));
    } catch (e) {
      emit(MyApartmentsError(message: "حدث خطأ أثناء تحميل عقاراتك"));
    } finally {
      _isFetching = false;
    }
  }
}