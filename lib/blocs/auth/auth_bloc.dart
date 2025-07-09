import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      try {
        developer.log('AppStarted event triggered', name: 'AuthBloc');
        final isLoggedIn = await AuthService.isLoggedIn();
        developer.log('Is logged in: $isLoggedIn', name: 'AuthBloc');

        if (isLoggedIn) {
          final userData = await AuthService.getCurrentUser();
          final role = await AuthService.getUserRole();
          final userId = await AuthService.getUserId();

          developer.log('User data retrieved: $userData', name: 'AuthBloc');
          developer.log('User role: $role', name: 'AuthBloc');
          developer.log('User ID: $userId', name: 'AuthBloc');

          if (userData != null && role != null && userId != null) {
            emit(Authenticated(role: role, userId: userId));
            developer.log('User authenticated successfully', name: 'AuthBloc');
          } else {
            emit(Unauthenticated());
            developer.log(
              'User data incomplete, unauthenticated',
              name: 'AuthBloc',
            );
          }
        } else {
          emit(Unauthenticated());
          developer.log('User not logged in', name: 'AuthBloc');
        }
      } catch (e) {
        developer.log('AppStarted error: $e', name: 'AuthBloc');
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      try {
        developer.log('LoginRequested event triggered', name: 'AuthBloc');
        developer.log(
          'Login attempt - Mobile: ${event.mobileNumber}, OTP: ${event.otp}, Role: ${event.role}',
          name: 'AuthBloc',
        );

        emit(AuthLoading());

        // Call the actual login method with mobileNumber, otp, and role
        final result = await AuthService.login(
          mobileNumber: event.mobileNumber,
          otp: event.otp,
          role: event.role,
        );

        developer.log('Login result: $result', name: 'AuthBloc');

        if (result['success']) {
          final role = await AuthService.getUserRole();
          final userId = await AuthService.getUserId();
          final userData = await AuthService.getCurrentUser();

          developer.log(
            'Login successful - Role: $role, UserID: $userId',
            name: 'AuthBloc',
          );
          developer.log('User data after login: $userData', name: 'AuthBloc');

          if (role != null && userId != null) {
            emit(Authenticated(role: role, userId: userId));
          } else {
            emit(Unauthenticated());
          }
        } else {
          developer.log('Login failed: ${result['message']}', name: 'AuthBloc');
          emit(AuthError(message: result['message']));
        }
      } catch (e) {
        developer.log('Login error: $e', name: 'AuthBloc');
        emit(AuthError(message: e.toString()));
      }
    });

    on<RegistrationRequested>((event, emit) async {
      try {
        developer.log(
          'RegistrationRequested event triggered',
          name: 'AuthBloc',
        );
        developer.log('Registration data received:', name: 'AuthBloc');
        developer.log('  Name: ${event.name}', name: 'AuthBloc');
        developer.log('  Mobile: ${event.mobileNumber}', name: 'AuthBloc');
        developer.log(
          '  Contact Number: ${event.contactNumber}',
          name: 'AuthBloc',
        );
        developer.log(
          '  Aadhaar Number: ${event.aadhaarNumber}',
          name: 'AuthBloc',
        );
        developer.log('  Village: ${event.village}', name: 'AuthBloc');
        developer.log('  Landmark: ${event.landmark}', name: 'AuthBloc');
        developer.log('  Taluka: ${event.taluka}', name: 'AuthBloc');
        developer.log('  District: ${event.district}', name: 'AuthBloc');
        developer.log('  Pincode: ${event.pincode}', name: 'AuthBloc');

        emit(AuthLoading());

        final result = await AuthService.registerFarmer(
          name: event.name,
          mobileNumber: event.mobileNumber,
          contactNumber: event.contactNumber,
          aadhaarNumber: event.aadhaarNumber,
          village: event.village,
          landmark: event.landmark,
          taluka: event.taluka,
          district: event.district,
          pincode: event.pincode,
        );

        developer.log('Registration result: $result', name: 'AuthBloc');

        if (result['success']) {
          developer.log('Registration successful!', name: 'AuthBloc');
          developer.log('Farmer ID: ${result['farmerId']}', name: 'AuthBloc');
          developer.log('Message: ${result['message']}', name: 'AuthBloc');

          // Log the complete saved data
          try {
            final savedFarmer = await _getSavedFarmerData(result['farmerId']);
            if (savedFarmer != null) {
              developer.log('Complete saved farmer data:', name: 'AuthBloc');
              developer.log('  ID: ${savedFarmer['id']}', name: 'AuthBloc');
              developer.log('  Name: ${savedFarmer['name']}', name: 'AuthBloc');
              developer.log(
                '  Contact Number: ${savedFarmer['contact_number']}',
                name: 'AuthBloc',
              );
              developer.log(
                '  Aadhaar Number: ${savedFarmer['aadhaar_number']}',
                name: 'AuthBloc',
              );
              developer.log(
                '  Village: ${savedFarmer['village']}',
                name: 'AuthBloc',
              );
              developer.log(
                '  Landmark: ${savedFarmer['landmark']}',
                name: 'AuthBloc',
              );
              developer.log(
                '  Taluka: ${savedFarmer['taluka']}',
                name: 'AuthBloc',
              );
              developer.log(
                '  District: ${savedFarmer['district']}',
                name: 'AuthBloc',
              );
              developer.log(
                '  Pincode: ${savedFarmer['pincode']}',
                name: 'AuthBloc',
              );
              developer.log(
                '  Created At: ${savedFarmer['created_at']}',
                name: 'AuthBloc',
              );
              developer.log(
                '  Updated At: ${savedFarmer['updated_at']}',
                name: 'AuthBloc',
              );
            }
          } catch (e) {
            developer.log(
              'Error getting saved farmer data: $e',
              name: 'AuthBloc',
            );
          }

          emit(Unauthenticated()); // Stay on login screen after registration
        } else {
          developer.log(
            'Registration failed: ${result['message']}',
            name: 'AuthBloc',
          );
          emit(AuthError(message: result['message']));
        }
      } catch (e) {
        developer.log('Registration error: $e', name: 'AuthBloc');
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        developer.log('LogoutRequested event triggered', name: 'AuthBloc');
        await AuthService.logout();
        developer.log('User logged out successfully', name: 'AuthBloc');
        emit(Unauthenticated());
      } catch (e) {
        developer.log('Logout error: $e', name: 'AuthBloc');
        emit(AuthError(message: e.toString()));
      }
    });
  }

  // Helper method to get saved farmer data for logging
  Future<Map<String, dynamic>?> _getSavedFarmerData(String farmerId) async {
    try {
      final farmer = await DatabaseService.getFarmerById(farmerId);
      return farmer?.toMap();
    } catch (e) {
      developer.log('Error getting saved farmer data: $e', name: 'AuthBloc');
      return null;
    }
  }
}
