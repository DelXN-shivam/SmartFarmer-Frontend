import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../constants/app_constants.dart';
import '../../models/farmer.dart';
import '../../services/shared_prefs_service.dart';

class ProfileViewScreen extends StatelessWidget {
  final String userId;
  final String userRole;

  const ProfileViewScreen({
    super.key,
    required this.userId,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = SharedPrefsService.getLanguage() ?? 'en';

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
                        'JD', // TODO: Get user initials
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'John Doe', // TODO: Get user name
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
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        _getRoleDisplayName(userRole, langCode),
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
              title: AppStrings.getString('personal_information', langCode),
              children: [
                _buildInfoRow(
                  AppStrings.getString('name', langCode),
                  'John Doe',
                  Icons.person,
                ),
                _buildInfoRow(
                  AppStrings.getString('contact_number', langCode),
                  '+91 98765 43210',
                  Icons.phone,
                ),
                _buildInfoRow(
                  AppStrings.getString('aadhaar_number', langCode),
                  '1234 5678 9012',
                  Icons.credit_card,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Address Information
            _buildSection(
              title: AppStrings.getString('address_information', langCode),
              children: [
                _buildInfoRow(
                  AppStrings.getString('village', langCode),
                  'Sample Village',
                  Icons.location_city,
                ),
                _buildInfoRow(
                  AppStrings.getString('taluka', langCode),
                  'Sample Taluka',
                  Icons.location_on,
                ),
                _buildInfoRow(
                  AppStrings.getString('district', langCode),
                  'Sample District',
                  Icons.location_on,
                ),
                _buildInfoRow(
                  AppStrings.getString('pincode', langCode),
                  '123456',
                  Icons.pin_drop,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistics (for farmers and verifiers)
            if (userRole == AppConstants.roleFarmer) ...[
              _buildSection(
                title: AppStrings.getString('farming_statistics', langCode),
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
            ],
            const SizedBox(height: 24),

            // Account Information
            _buildSection(
              title: AppStrings.getString('account_information', langCode),
              children: [
                _buildInfoRow(
                  AppStrings.getString('user_id', langCode),
                  userId,
                  Icons.badge,
                ),
                _buildInfoRow(
                  AppStrings.getString('registration_date', langCode),
                  '15 Jan 2024',
                  Icons.calendar_today,
                ),
                _buildInfoRow(
                  AppStrings.getString('last_login', langCode),
                  '2 hours ago',
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
                    label: Text(AppStrings.getString('edit_profile', langCode)),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
