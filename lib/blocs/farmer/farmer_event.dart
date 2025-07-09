import '../../models/farmer.dart';

abstract class FarmerEvent {
  const FarmerEvent();
}

class LoadFarmers extends FarmerEvent {}

class AddFarmer extends FarmerEvent {
  final Farmer farmer;
  const AddFarmer(this.farmer);
}

class UpdateFarmer extends FarmerEvent {
  final Farmer farmer;
  const UpdateFarmer(this.farmer);
}

class DeleteFarmer extends FarmerEvent {
  final String farmerId;
  const DeleteFarmer(this.farmerId);
}

class SearchFarmers extends FarmerEvent {
  final String query;
  const SearchFarmers(this.query);
}

class FilterFarmersByLocation extends FarmerEvent {
  final String? village;
  final String? taluka;
  final String? district;
  const FilterFarmersByLocation({this.village, this.taluka, this.district});
}

class LoadFarmerById extends FarmerEvent {
  final String farmerId;
  LoadFarmerById(this.farmerId);
}
