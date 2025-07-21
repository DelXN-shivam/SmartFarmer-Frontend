import 'package:flutter_bloc/flutter_bloc.dart';
import 'farmer_event.dart';
import 'farmer_state.dart';
import '../../services/database_service.dart';

class FarmerBloc extends Bloc<FarmerEvent, FarmerState> {
  FarmerBloc() : super(FarmerInitial()) {
    // Only keep LoadFarmerById event logic
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
