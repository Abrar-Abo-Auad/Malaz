import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/location_service/location_service.dart';
import '../../../data/datasources/local/location_local_data_source.dart';

/// ===========================
/// ----------[states]---------
/// ===========================

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final double lat;
  final double lng;
  final String address;

  LocationLoaded({required this.lat, required this.lng, required this.address});

  @override
  List<Object?> get props => [lat, lng, address];
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ===========================
/// ----------[cubit]----------
/// ===========================
class LocationCubit extends Cubit<LocationState> {
  final LocationService locationService;
  final LocationLocalDataSource localDataSource;

  LocationCubit({
    required this.locationService,
    required this.localDataSource,
  }) : super(LocationInitial());

  Future<void> getCurrentLocation(String languageCode) async {
    emit(LocationLoading());
    try {
      final position = await locationService.getCurrentLocation();

      final address = await locationService.getAddressFromCoords(
        position!.latitude!,
        position.longitude!,
        languageCode,
      );

      await localDataSource.cacheCoordinates(position.latitude!, position.longitude!);
      await localDataSource.cacheUserAddress(address);

      emit(LocationLoaded(
        lat: position.latitude!,
        lng: position.longitude!,
        address: address,
      ));
    } catch (e) {
      emit(LocationError("Failed to get location: ${e.toString()}"));
    }
  }

  Future<void> loadSavedLocation() async {
    final coords = await localDataSource.getCachedCoordinates();
    final address = await localDataSource.getCachedAddress();

    if (coords['lat'] != null && coords['lng'] != null && address != null) {
      emit(LocationLoaded(
        lat: coords['lat']!,
        lng: coords['lng']!,
        address: address,
      ));
    }
  }

  Future<void> updateManualLocation(double lat, double lng, String languageCode) async {
    emit(LocationLoading());
    try {
      final address = await locationService.getAddressFromCoords(lat, lng, languageCode);

      await localDataSource.cacheCoordinates(lat, lng);
      await localDataSource.cacheUserAddress(address);

      emit(LocationLoaded(lat: lat, lng: lng, address: address));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}