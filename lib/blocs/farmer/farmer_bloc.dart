import 'package:flutter_bloc/flutter_bloc.dart';
import 'farmer_event.dart';
import 'farmer_state.dart';
import '../../services/database_service.dart';

class FarmerBloc extends Bloc<FarmerEvent, FarmerState> {
  FarmerBloc() : super(FarmerInitial()) {
    on<LoadFarmers>((event, emit) async {
      emit(FarmerLoading());
      try {
        final farmers = await DatabaseService.getAllFarmers();
        emit(FarmerLoaded(farmers));
      } catch (e) {
        emit(FarmerError(e.toString()));
      }
    });

    on<AddFarmer>((event, emit) async {
      try {
        await DatabaseService.insertFarmer(event.farmer);
        add(LoadFarmers());
      } catch (e) {
        emit(FarmerError(e.toString()));
      }
    });

    on<UpdateFarmer>((event, emit) async {
      try {
        await DatabaseService.updateFarmer(event.farmer);
        add(LoadFarmers());
      } catch (e) {
        emit(FarmerError(e.toString()));
      }
    });

    on<DeleteFarmer>((event, emit) async {
      try {
        await DatabaseService.deleteFarmer(event.farmerId);
        add(LoadFarmers());
      } catch (e) {
        emit(FarmerError(e.toString()));
      }
    });

    on<SearchFarmers>((event, emit) async {
      emit(FarmerLoading());
      try {
        final farmers = await DatabaseService.searchFarmers(event.query);
        emit(FarmerLoaded(farmers));
      } catch (e) {
        emit(FarmerError(e.toString()));
      }
    });

    on<FilterFarmersByLocation>((event, emit) async {
      emit(FarmerLoading());
      try {
        final farmers = await DatabaseService.filterFarmersByLocation(
          village: event.village,
          taluka: event.taluka,
          district: event.district,
        );
        emit(FarmerLoaded(farmers));
      } catch (e) {
        emit(FarmerError(e.toString()));
      }
    });

    on<LoadFarmerById>((event, emit) async {
      emit(FarmerLoading());
      try {
        final farmer = await DatabaseService.getFarmerById(event.farmerId);
        if (farmer != null) {
          emit(SingleFarmerLoaded(farmer));
        } else {
          emit(FarmerError('Farmer not found'));
        }
      } catch (e) {
        emit(FarmerError(e.toString()));
      }
    });
  }
}
