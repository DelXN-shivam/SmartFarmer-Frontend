import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/farmer.dart';
import 'database_service.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserData = 'user_data';
  static const String _keyUserEmail = 'user_email';

  // Login with mobile number and OTP
  static Future<Map<String, dynamic>> login({
    required String mobileNumber,
    required String otp,
    required String role,
  }) async {
    try {
      developer.log('AuthService.login called', name: 'AuthService');
      developer.log('Login parameters:', name: 'AuthService');
      developer.log('  Mobile Number: $mobileNumber', name: 'AuthService');
      developer.log('  OTP: $otp', name: 'AuthService');
      developer.log('  Role: $role', name: 'AuthService');

      // Validate input
      if (mobileNumber.isEmpty) {
        developer.log(
          'Validation failed: Mobile number is empty',
          name: 'AuthService',
        );
        return {'success': false, 'message': 'Mobile number is required'};
      }

      if (otp.isEmpty) {
        developer.log('Validation failed: OTP is empty', name: 'AuthService');
        return {'success': false, 'message': 'OTP is required'};
      }

      developer.log('Input validation passed', name: 'AuthService');

      // Check credentials based on role
      bool isValid = false;
      Map<String, dynamic> userData = {};

      switch (role) {
        case AppConstants.roleFarmer:
          developer.log('Checking farmer credentials...', name: 'AuthService');
          // For farmers, check in database
          final farmers = await DatabaseService.getAllFarmers();
          developer.log(
            'Found ${farmers.length} farmers in database',
            name: 'AuthService',
          );

          final farmer = farmers
              .where(
                (f) =>
                    f.contactNumber ==
                        mobileNumber || // Using contact number as mobile number for demo
                    f.id == mobileNumber, // Also allow farmer ID login for demo
              )
              .firstOrNull;

          if (farmer != null) {
            developer.log(
              'Farmer found: ${farmer.name} (ID: ${farmer.id})',
              name: 'AuthService',
            );
            // For demo purposes, accept any OTP for existing farmers
            // In real app, you'd check against hashed OTP in database
            isValid = true;
            userData = {
              'id': farmer.id,
              'name': farmer.name,
              'mobile_number': farmer.contactNumber,
              'role': role,
              'village': farmer.village,
              'district': farmer.district,
            };
            developer.log('Farmer login successful', name: 'AuthService');
          } else {
            developer.log(
              'No farmer found with mobile number: $mobileNumber',
              name: 'AuthService',
            );
          }
          break;
        default:
          break;
      }

      if (isValid) {
        developer.log(
          'Login successful, saving login state...',
          name: 'AuthService',
        );
        developer.log('User data to save: $userData', name: 'AuthService');

        // Save login state
        await _saveLoginState(userData);
        developer.log('Login state saved successfully', name: 'AuthService');

        return {
          'success': true,
          'message': 'Login successful',
          'userData': userData,
        };
      } else {
        developer.log('Login failed: Invalid credentials', name: 'AuthService');
        return {'success': false, 'message': 'Invalid mobile number'};
      }
    } catch (e) {
      developer.log('Login error: $e', name: 'AuthService');
      return {'success': false, 'message': 'Login failed: ${e.toString()}'};
    }
  }

  // Register new farmer with mobile number
  static Future<Map<String, dynamic>> registerFarmer({
    required String name,
    required String mobileNumber,
    required String contactNumber,
    required String aadhaarNumber,
    required String village,
    required String landmark,
    required String taluka,
    required String district,
    required String pincode,
  }) async {
    try {
      developer.log('AuthService.registerFarmer called', name: 'AuthService');
      developer.log('Registration parameters:', name: 'AuthService');
      developer.log('  Name: $name', name: 'AuthService');
      developer.log('  Mobile Number: $mobileNumber', name: 'AuthService');
      developer.log('  Contact Number: $contactNumber', name: 'AuthService');
      developer.log('  Aadhaar Number: $aadhaarNumber', name: 'AuthService');
      developer.log('  Village: $village', name: 'AuthService');
      developer.log('  Landmark: $landmark', name: 'AuthService');
      developer.log('  Taluka: $taluka', name: 'AuthService');
      developer.log('  District: $district', name: 'AuthService');
      developer.log('  Pincode: $pincode', name: 'AuthService');

      // Validate input
      if (name.isEmpty ||
          mobileNumber.isEmpty ||
          contactNumber.isEmpty ||
          aadhaarNumber.isEmpty) {
        developer.log(
          'Validation failed: Required fields are empty',
          name: 'AuthService',
        );
        return {'success': false, 'message': 'All fields are required'};
      }

      if (aadhaarNumber.length != 12) {
        developer.log(
          'Validation failed: Aadhaar number must be 12 digits',
          name: 'AuthService',
        );
        return {
          'success': false,
          'message': 'Aadhaar number must be 12 digits',
        };
      }

      if (contactNumber.length != 10) {
        developer.log(
          'Validation failed: Contact number must be 10 digits',
          name: 'AuthService',
        );
        return {
          'success': false,
          'message': 'Contact number must be 10 digits',
        };
      }

      if (pincode.length != 6) {
        developer.log(
          'Validation failed: Pincode must be 6 digits',
          name: 'AuthService',
        );
        return {'success': false, 'message': 'Pincode must be 6 digits'};
      }

      developer.log('Input validation passed', name: 'AuthService');

      // Check if farmer already exists with this mobile number or Aadhaar
      developer.log('Checking for existing farmers...', name: 'AuthService');
      final existingFarmers = await DatabaseService.getAllFarmers();
      developer.log(
        'Found ${existingFarmers.length} existing farmers',
        name: 'AuthService',
      );

      final existingByMobile = existingFarmers
          .where((f) => f.contactNumber == mobileNumber)
          .isNotEmpty;
      final existingByAadhaar = existingFarmers
          .where((f) => f.aadhaarNumber == aadhaarNumber)
          .isNotEmpty;

      if (existingByMobile) {
        developer.log(
          'Registration failed: Mobile number already exists',
          name: 'AuthService',
        );
        return {
          'success': false,
          'message': 'A farmer with this mobile number already exists',
        };
      }

      if (existingByAadhaar) {
        developer.log(
          'Registration failed: Aadhaar number already exists',
          name: 'AuthService',
        );
        return {
          'success': false,
          'message': 'A farmer with this Aadhaar number already exists',
        };
      }

      developer.log(
        'No existing farmers found with same mobile number or Aadhaar',
        name: 'AuthService',
      );

      // Create new farmer
      final farmerId = 'farmer_${DateTime.now().millisecondsSinceEpoch}';
      developer.log('Generated farmer ID: $farmerId', name: 'AuthService');

      final farmer = Farmer(
        id: farmerId,
        name: name,
        contactNumber: mobileNumber,
        aadhaarNumber: aadhaarNumber,
        village: village,
        landmark: landmark,
        taluka: taluka,
        district: district,
        pincode: pincode,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      developer.log('Created farmer object:', name: 'AuthService');
      developer.log('  ID: ${farmer.id}', name: 'AuthService');
      developer.log('  Name: ${farmer.name}', name: 'AuthService');
      developer.log(
        '  Contact Number: ${farmer.contactNumber}',
        name: 'AuthService',
      );
      developer.log(
        '  Aadhaar Number: ${farmer.aadhaarNumber}',
        name: 'AuthService',
      );
      developer.log('  Village: ${farmer.village}', name: 'AuthService');
      developer.log('  Landmark: ${farmer.landmark}', name: 'AuthService');
      developer.log('  Taluka: ${farmer.taluka}', name: 'AuthService');
      developer.log('  District: ${farmer.district}', name: 'AuthService');
      developer.log('  Pincode: ${farmer.pincode}', name: 'AuthService');
      developer.log('  Created At: ${farmer.createdAt}', name: 'AuthService');
      developer.log('  Updated At: ${farmer.updatedAt}', name: 'AuthService');

      developer.log('Inserting farmer into database...', name: 'AuthService');
      final result = await DatabaseService.insertFarmer(farmer);
      developer.log('Database insert result: $result', name: 'AuthService');

      if (result > 0) {
        developer.log(
          'Farmer successfully inserted into database',
          name: 'AuthService',
        );

        // Verify the saved data
        final savedFarmer = await DatabaseService.getFarmerById(farmerId);
        if (savedFarmer != null) {
          developer.log('Verified saved farmer data:', name: 'AuthService');
          developer.log('  ID: ${savedFarmer.id}', name: 'AuthService');
          developer.log('  Name: ${savedFarmer.name}', name: 'AuthService');
          developer.log(
            '  Contact Number: ${savedFarmer.contactNumber}',
            name: 'AuthService',
          );
          developer.log(
            '  Aadhaar Number: ${savedFarmer.aadhaarNumber}',
            name: 'AuthService',
          );
          developer.log(
            '  Village: ${savedFarmer.village}',
            name: 'AuthService',
          );
          developer.log(
            '  Landmark: ${savedFarmer.landmark}',
            name: 'AuthService',
          );
          developer.log('  Taluka: ${savedFarmer.taluka}', name: 'AuthService');
          developer.log(
            '  District: ${savedFarmer.district}',
            name: 'AuthService',
          );
          developer.log(
            '  Pincode: ${savedFarmer.pincode}',
            name: 'AuthService',
          );
          developer.log(
            '  Created At: ${savedFarmer.createdAt}',
            name: 'AuthService',
          );
          developer.log(
            '  Updated At: ${savedFarmer.updatedAt}',
            name: 'AuthService',
          );
        } else {
          developer.log(
            'WARNING: Could not verify saved farmer data',
            name: 'AuthService',
          );
        }

        return {
          'success': true,
          'message':
              'Registration successful! You can now login with your mobile number.',
          'farmerId': farmer.id,
        };
      } else {
        developer.log('Database insert failed', name: 'AuthService');
        return {'success': false, 'message': 'Registration failed'};
      }
    } catch (e) {
      developer.log('Registration error: $e', name: 'AuthService');
      return {
        'success': false,
        'message': 'Registration failed: ${e.toString()}',
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      developer.log('AuthService.logout called', name: 'AuthService');

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyUserRole);
      await prefs.remove(_keyUserData);
      await prefs.remove(_keyUserEmail);

      developer.log(
        'Logout successful - all login data cleared from SharedPreferences',
        name: 'AuthService',
      );
    } catch (e) {
      developer.log('Logout error: $e', name: 'AuthService');
      rethrow;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      developer.log('AuthService.isLoggedIn called', name: 'AuthService');
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      developer.log('Is logged in: $isLoggedIn', name: 'AuthService');
      return isLoggedIn;
    } catch (e) {
      developer.log('isLoggedIn error: $e', name: 'AuthService');
      return false;
    }
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      developer.log('AuthService.getCurrentUser called', name: 'AuthService');
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_keyUserData);
      if (userDataString != null) {
        final userData = json.decode(userDataString);
        developer.log('Current user data: $userData', name: 'AuthService');
        return userData;
      } else {
        developer.log('No current user data found', name: 'AuthService');
        return null;
      }
    } catch (e) {
      developer.log('getCurrentUser error: $e', name: 'AuthService');
      return null;
    }
  }

  // Get user role
  static Future<String?> getUserRole() async {
    try {
      developer.log('AuthService.getUserRole called', name: 'AuthService');
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString(_keyUserRole);
      developer.log('User role: $role', name: 'AuthService');
      return role;
    } catch (e) {
      developer.log('getUserRole error: $e', name: 'AuthService');
      return null;
    }
  }

  // Get user ID
  static Future<String?> getUserId() async {
    try {
      developer.log('AuthService.getUserId called', name: 'AuthService');
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_keyUserId);
      developer.log('User ID: $userId', name: 'AuthService');
      return userId;
    } catch (e) {
      developer.log('getUserId error: $e', name: 'AuthService');
      return null;
    }
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserEmail);
    } catch (e) {
      return null;
    }
  }

  // Save login state
  static Future<void> _saveLoginState(Map<String, dynamic> userData) async {
    try {
      developer.log('_saveLoginState called', name: 'AuthService');
      developer.log('Saving user data: $userData', name: 'AuthService');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserId, userData['id']);
      await prefs.setString(_keyUserRole, userData['role']);
      await prefs.setString(_keyUserEmail, userData['mobile_number']);
      await prefs.setString(_keyUserData, json.encode(userData));

      developer.log(
        'Login state saved to SharedPreferences',
        name: 'AuthService',
      );
      developer.log('  IsLoggedIn: true', name: 'AuthService');
      developer.log('  UserID: ${userData['id']}', name: 'AuthService');
      developer.log('  UserRole: ${userData['role']}', name: 'AuthService');
      developer.log(
        '  UserEmail: ${userData['mobile_number']}',
        name: 'AuthService',
      );
    } catch (e) {
      developer.log('Save login state error: $e', name: 'AuthService');
      rethrow;
    }
  }
}
