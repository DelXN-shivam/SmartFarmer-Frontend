import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../constants/app_constants.dart';
// import '../../models/farmer.dart';
import '../../services/shared_prefs_service.dart';
import '../../blocs/farmer/farmer_bloc.dart';
import '../../blocs/farmer/farmer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewScreen extends StatelessWidget {
  final String userId;
  final String userRole;

  const ProfileViewScreen({
    super.key,
    required this.userId,
    required this.userRole,
  });

  Future<Map<String, dynamic>?> _getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return json.decode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final langCode = SharedPrefsService.getLanguage() ?? 'en';

    return FutureBuilder<Map<String, dynamic>?>(
      future: _getProfileData(),
      builder: (context, snapshot) {
        Map<String, dynamic>? profileData = snapshot.data;
        return BlocBuilder<FarmerBloc, FarmerState>(
          builder: (context, state) {
            final farmer = (state is SingleFarmerLoaded) ? state.farmer : null;
            final name = profileData != null && profileData['name'] != null
                ? profileData['name']
                : farmer?.name ?? '';
            final aadhaar =
                profileData != null && profileData['aadhaarNumber'] != null
                ? profileData['aadhaarNumber']
                : farmer?.aadhaarNumber ?? '';
            final contact =
                profileData != null && profileData['contactNumber'] != null
                ? profileData['contactNumber']
                : farmer?.contactNumber ?? '';
            final village =
                profileData != null && profileData['village'] != null
                ? profileData['village']
                : farmer?.village ?? '';
            final taluka = profileData != null && profileData['taluka'] != null
                ? profileData['taluka']
                : farmer?.taluka ?? '';
            final district =
                profileData != null && profileData['district'] != null
                ? profileData['district']
                : farmer?.district ?? '';
            final pincode =
                profileData != null && profileData['pincode'] != null
                ? profileData['pincode']
                : farmer?.pincode ?? '';
            final id = profileData != null && profileData['id'] != null
                ? profileData['id']
                : farmer?.id ?? '';
            final createdAt =
                profileData != null && profileData['createdAt'] != null
                ? profileData['createdAt']
                : (farmer?.createdAt != null
                      ? farmer!.createdAt.toString().split(' ')[0]
                      : '');

            return Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.getString('profile', langCode)),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Navigate to edit profile
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.green,
                              child: Text(
                                name.isNotEmpty
                                    ? name.substring(0, 2).toUpperCase()
                                    : '',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Text(
                                _getRoleDisplayName(
                                  AppConstants.roleFarmer,
                                  langCode,
                                ),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal Information
                    _buildSection(
                      title: AppStrings.getString(
                        'personal_information',
                        langCode,
                      ),
                      children: [
                        _buildInfoRow(
                          AppStrings.getString('name', langCode),
                          name,
                          Icons.person,
                        ),
                        _buildInfoRow(
                          AppStrings.getString('contact_number', langCode),
                          contact,
                          Icons.phone,
                        ),
                        _buildInfoRow(
                          AppStrings.getString('aadhaar_number', langCode),
                          aadhaar,
                          Icons.credit_card,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Address Information
                    _buildSection(
                      title: AppStrings.getString(
                        'address_information',
                        langCode,
                      ),
                      children: [
                        _buildInfoRow(
                          AppStrings.getString('village', langCode),
                          village,
                          Icons.location_city,
                        ),
                        _buildInfoRow(
                          AppStrings.getString('taluka', langCode),
                          taluka,
                          Icons.location_on,
                        ),
                        _buildInfoRow(
                          AppStrings.getString('district', langCode),
                          district,
                          Icons.location_on,
                        ),
                        _buildInfoRow(
                          AppStrings.getString('pincode', langCode),
                          pincode,
                          Icons.pin_drop,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Statistics (for farmers)
                    _buildSection(
                      title: AppStrings.getString(
                        'farming_statistics',
                        langCode,
                      ),
                      children: [
                        _buildStatCard(
                          AppStrings.getString('total_crops', langCode),
                          '12',
                          Icons.agriculture,
                          Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildStatCard(
                          AppStrings.getString('total_area', langCode),
                          '45 acres',
                          Icons.area_chart,
                          Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _buildStatCard(
                          AppStrings.getString('verified_crops', langCode),
                          '8',
                          Icons.verified,
                          Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Account Information
                    _buildSection(
                      title: AppStrings.getString(
                        'account_information',
                        langCode,
                      ),
                      children: [
                        _buildInfoRow(
                          AppStrings.getString('user_id', langCode),
                          id,
                          Icons.badge,
                        ),
                        _buildInfoRow(
                          AppStrings.getString('registration_date', langCode),
                          createdAt,
                          Icons.calendar_today,
                        ),
                        _buildInfoRow(
                          AppStrings.getString('last_login', langCode),
                          '', // You can fill this if you track last login
                          Icons.access_time,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to edit profile
                            },
                            icon: const Icon(Icons.edit),
                            label: Text(
                              AppStrings.getString('edit_profile', langCode),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Share profile
                            },
                            icon: const Icon(Icons.share),
                            label: Text(
                              AppStrings.getString('share_profile', langCode),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(String role, String langCode) {
    switch (role) {
      case AppConstants.roleFarmer:
        return AppStrings.getString('farmer', langCode);
      default:
        return role;
    }
  }
}
