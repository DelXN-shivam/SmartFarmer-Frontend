class Crop {
  final String id;
  final String farmerId;
  final String cropName;
  final double area;
  final String cropType;
  final String soilType;
  final DateTime sowingDate;
  final DateTime expectedHarvestDate;
  final double expectedYield;
  final String previousCrop;
  final double latitude;
  final double longitude;
  final List<String> imagePaths;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Crop({
    required this.id,
    required this.farmerId,
    required this.cropName,
    required this.area,
    required this.cropType,
    required this.soilType,
    required this.sowingDate,
    required this.expectedHarvestDate,
    required this.expectedYield,
    required this.previousCrop,
    required this.latitude,
    required this.longitude,
    required this.imagePaths,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      id: map['id'] ?? '',
      farmerId: map['farmer_id'] ?? '',
      cropName: map['crop_name'] ?? '',
      area: (map['area'] ?? 0.0).toDouble(),
      cropType: map['crop_type'] ?? '',
      soilType: map['soil_type'] ?? '',
      sowingDate: DateTime.parse(
        map['sowing_date'] ?? DateTime.now().toIso8601String(),
      ),
      expectedHarvestDate: DateTime.parse(
        map['expected_harvest_date'] ?? DateTime.now().toIso8601String(),
      ),
      expectedYield: (map['expected_yield'] ?? 0.0).toDouble(),
      previousCrop: map['previous_crop'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      imagePaths: List<String>.from(map['image_paths'] ?? []),
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmer_id': farmerId,
      'crop_name': cropName,
      'area': area,
      'crop_type': cropType,
      'soil_type': soilType,
      'sowing_date': sowingDate.toIso8601String(),
      'expected_harvest_date': expectedHarvestDate.toIso8601String(),
      'expected_yield': expectedYield,
      'previous_crop': previousCrop,
      'latitude': latitude,
      'longitude': longitude,
      'image_paths': imagePaths,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Crop copyWith({
    String? id,
    String? farmerId,
    String? cropName,
    double? area,
    String? cropType,
    String? soilType,
    DateTime? sowingDate,
    DateTime? expectedHarvestDate,
    double? expectedYield,
    String? previousCrop,
    double? latitude,
    double? longitude,
    List<String>? imagePaths,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Crop(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      cropName: cropName ?? this.cropName,
      area: area ?? this.area,
      cropType: cropType ?? this.cropType,
      soilType: soilType ?? this.soilType,
      sowingDate: sowingDate ?? this.sowingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      expectedYield: expectedYield ?? this.expectedYield,
      previousCrop: previousCrop ?? this.previousCrop,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagePaths: imagePaths ?? this.imagePaths,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Calculate crop age in days
  int get cropAgeInDays {
    final now = DateTime.now();
    return now.difference(sowingDate).inDays;
  }

  // Calculate days to harvest
  int get daysToHarvest {
    final now = DateTime.now();
    return expectedHarvestDate.difference(now).inDays;
  }

  // Get growth stage based on crop age
  String get growthStage {
    final age = cropAgeInDays;
    final lifespan = _getCropLifespan();

    if (age <= lifespan * 0.1) return 'Germination';
    if (age <= lifespan * 0.3) return 'Vegetative';
    if (age <= lifespan * 0.6) return 'Flowering';
    if (age <= lifespan * 0.8) return 'Fruiting';
    if (age <= lifespan) return 'Harvesting';
    return 'Mature';
  }

  int _getCropLifespan() {
    const cropLifespan = {
      'Wheat': 120,
      'Rice': 150,
      'Maize': 100,
      'Cotton': 180,
      'Sugarcane': 365,
      'Pulses': 90,
      'Oilseeds': 120,
      'Vegetables': 60,
      'Fruits': 730,
      'Other': 120,
    };
    return cropLifespan[cropType] ?? 120;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Crop && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
