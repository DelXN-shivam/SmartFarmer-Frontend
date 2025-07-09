import '../models/farmer.dart';
import '../models/crop.dart';
import 'database_service.dart';

class DatabaseInitService {
  static Future<void> initializeSampleData() async {
    try {
      // Check if sample data already exists
      final existingFarmers = await DatabaseService.getAllFarmers();
      if (existingFarmers.isNotEmpty) {
        return; // Sample data already exists
      }

      // Add sample farmers
      final sampleFarmers = [
        Farmer(
          id: 'farmer_001',
          name: 'Rajesh Kumar',
          contactNumber: 'farmer_001@example.com',
          aadhaarNumber: '123456789012',
          village: 'Village A',
          landmark: 'Near Temple',
          taluka: 'Taluka A',
          district: 'Mumbai',
          pincode: '400001',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Farmer(
          id: 'farmer_002',
          name: 'Suresh Patel',
          contactNumber: 'farmer_002@example.com',
          aadhaarNumber: '123456789013',
          village: 'Village B',
          landmark: 'Near School',
          taluka: 'Taluka B',
          district: 'Pune',
          pincode: '411001',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Farmer(
          id: 'farmer_003',
          name: 'Amit Singh',
          contactNumber: 'farmer_003@example.com',
          aadhaarNumber: '123456789014',
          village: 'Village C',
          landmark: 'Near Market',
          taluka: 'Taluka C',
          district: 'Nagpur',
          pincode: '440001',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final farmer in sampleFarmers) {
        await DatabaseService.insertFarmer(farmer);
      }

      // Add sample crops
      final sampleCrops = [
        Crop(
          id: 'crop_001',
          farmerId: 'farmer_001',
          cropName: 'Wheat',
          area: 5.5,
          cropType: 'Rabi',
          soilType: 'Loamy',
          sowingDate: DateTime.now().subtract(const Duration(days: 30)),
          expectedHarvestDate: DateTime.now().add(const Duration(days: 120)),
          expectedYield: 22.0,
          previousCrop: 'Rice',
          latitude: 19.0760,
          longitude: 72.8777,
          imagePaths: ['sample_wheat_1.jpg', 'sample_wheat_2.jpg'],
          status: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Crop(
          id: 'crop_002',
          farmerId: 'farmer_002',
          cropName: 'Cotton',
          area: 3.2,
          cropType: 'Kharif',
          soilType: 'Black',
          sowingDate: DateTime.now().subtract(const Duration(days: 45)),
          expectedHarvestDate: DateTime.now().add(const Duration(days: 90)),
          expectedYield: 12.8,
          previousCrop: 'Soybean',
          latitude: 18.5204,
          longitude: 73.8567,
          imagePaths: ['sample_cotton_1.jpg'],
          status: 'verified',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Crop(
          id: 'crop_003',
          farmerId: 'farmer_003',
          cropName: 'Sugarcane',
          area: 7.0,
          cropType: 'Perennial',
          soilType: 'Red',
          sowingDate: DateTime.now().subtract(const Duration(days: 60)),
          expectedHarvestDate: DateTime.now().add(const Duration(days: 300)),
          expectedYield: 350.0,
          previousCrop: 'Wheat',
          latitude: 21.1458,
          longitude: 79.0882,
          imagePaths: ['sample_sugarcane_1.jpg', 'sample_sugarcane_2.jpg'],
          status: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final crop in sampleCrops) {
        await DatabaseService.insertCrop(crop);
      }

      print('Sample data initialized successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
}
