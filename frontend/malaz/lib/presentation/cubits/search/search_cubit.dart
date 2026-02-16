import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/apartment/search_properties_usecase.dart';
import '../../../domain/entities/apartment/apartment.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Apartment> results;
  SearchSuccess(this.results);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}


class SearchCubit extends Cubit<SearchState> {
  final SearchPropertiesUseCase searchUseCase;
  String currentQuery = "";

  SearchCubit(this.searchUseCase) : super(SearchInitial());

  void search(String query) async {
    currentQuery = query;
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    List<String> parts = query.trim().split(' ');
    String? title = query;
    String? fName;
    String? lName;

    if (parts.length >= 2) {
      fName = parts[0];
      lName = parts[1];
    }

    final result = await searchUseCase(
      title: title,
      ownerFirstName: fName,
      ownerLastName: lName,
    );

    result.fold(
          (failure) => emit(SearchError(failure.message.toString())),
          (apartments) => emit(SearchSuccess(apartments)),
    );
  }
}