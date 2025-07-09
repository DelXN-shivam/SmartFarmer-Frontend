import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_event.dart';
import 'filter_state.dart';
import '../../services/database_service.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {
    on<LoadLocations>((event, emit) async {
      emit(FilterLoading());
      try {
        final farmers = await DatabaseService.getAllFarmers();

        final villages = farmers.map((f) => f.village).toSet().toList()..sort();
        final talukas = farmers.map((f) => f.taluka).toSet().toList()..sort();
        final districts = farmers.map((f) => f.district).toSet().toList()
          ..sort();

        emit(
          FilterLoaded(
            villages: villages,
            talukas: talukas,
            districts: districts,
          ),
        );
      } catch (e) {
        emit(FilterError(e.toString()));
      }
    });

    on<FilterByLocation>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is FilterLoaded) {
          emit(
            FilterLoaded(
              villages: currentState.villages,
              talukas: currentState.talukas,
              districts: currentState.districts,
              selectedVillage: event.village,
              selectedTaluka: event.taluka,
              selectedDistrict: event.district,
            ),
          );
        }
      } catch (e) {
        emit(FilterError(e.toString()));
      }
    });

    on<ClearFilter>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is FilterLoaded) {
          emit(
            FilterLoaded(
              villages: currentState.villages,
              talukas: currentState.talukas,
              districts: currentState.districts,
            ),
          );
        }
      } catch (e) {
        emit(FilterError(e.toString()));
      }
    });
  }
}
