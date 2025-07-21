import '../../models/farmer.dart';

abstract class FarmerEvent {
  const FarmerEvent();
}

class LoadFarmerById extends FarmerEvent {
  final String farmerId;
  LoadFarmerById(this.farmerId);
}
