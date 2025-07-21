import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:smart_farmer/screens/auth/farmer_registration_screen.dart';
import 'package:smart_farmer/screens/common/language_selection.dart';
// import 'package:smart_farmer/screens/farmer/farmer_dashboard_screen.dart';
import '../../constants/app_constants.dart';
import '../../constants/strings.dart';
import '../../constants/app_theme.dart';
import '../../services/shared_prefs_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/farmer.dart';
import '../../screens/farmer/farmer_dashboard_screen.dart';
import 'package:smart_farmer/screens/auth/farmer_registration_screen.dart';

class MobileOTPScreen extends StatefulWidget {
  const MobileOTPScreen({super.key});

  @override
  State<MobileOTPScreen> createState() => _MobileOTPScreenState();
}

class _MobileOTPScreenState extends State<MobileOTPScreen>
    with TickerProviderStateMixin {
  String selectedRole = AppConstants.roleFarmer;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showOTPField = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _mobileController.text = '';
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
    _animationController.forward();

    // Future.delayed(const Duration(seconds: 5), () {
    //   if (!mounted) return;
    //   // Check authentication here if needed
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) {
    //         // Replace with your logic to check authentication
    //         // For example:
    //         // if (isAuthenticated) return FarmerDashboardScreen();
    //         // else return MobileOTPScreen();
    //         return MobileOTPScreen(); // or FarmerDashboardScreen()
    //       },
    //     ),
    //   );
    // });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = SharedPrefsService.getLanguage() ?? 'en';
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    // final isPortrait =
    //     MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Top Section with Logo and Title
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 16 : 24,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/smart-farmingLogo.png",
                            width: 120,
                            height: 120,
                          ),
                          SizedBox(height: isSmallScreen ? 14 : 16),
                          Text(
                            AppStrings.getString('app_title', langCode),
                            style: AppTheme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 24 : 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.getString(
                              'smart_farming_management',
                              langCode,
                            ),
                            style: AppTheme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // White container fills the rest of the screen
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_showOTPField)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: AppTheme.primaryColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showOTPField = false;
                                          _otpController.clear();
                                        });
                                      },
                                    ),
                                    Text(
                                      AppStrings.getString(
                                        'back_to_mobile_number',
                                        langCode,
                                      ),
                                      style: AppTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            Text(
                              _showOTPField
                                  ? AppStrings.getString('enter_otp', langCode)
                                  : AppStrings.getString(
                                      'mobile_verification',
                                      langCode,
                                    ),
                              style: AppTheme.textTheme.headlineLarge?.copyWith(
                                fontSize: isSmallScreen ? 20 : 22,
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              _showOTPField
                                  ? AppStrings.getString(
                                      'enter_otp_message',
                                      langCode,
                                    ).replaceFirst(
                                      '{number}',
                                      _mobileController.text,
                                    )
                                  : AppStrings.getString(
                                      'enter_mobile_number',
                                      langCode,
                                    ),
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 32),
                            // Role Selection (only show before OTP is sent)
                            if (!_showOTPField)
                              // _buildRoleSelection(
                              //   langCode,
                              //   isSmallScreen,
                              //   isPortrait,
                              // ),
                              if (!_showOTPField)
                                SizedBox(height: isSmallScreen ? 16 : 24),
                            // Mobile/OTP Form
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  if (!_showOTPField) ...[
                                    _buildMobileNumberField(),
                                    SizedBox(height: isSmallScreen ? 16 : 24),
                                    _buildSendOTPButton(langCode),
                                  ] else ...[
                                    _buildOTPField(),
                                    SizedBox(height: isSmallScreen ? 16 : 24),
                                    _buildVerifyOTPButton(langCode),
                                    SizedBox(height: isSmallScreen ? 12 : 16),
                                    _buildResendOTPButton(langCode),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            // Demo Info
                            _buildDemoInfo(langCode, isSmallScreen),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      // Bottom sheet for OTP entry
      // bottomSheet: _showOTPField ? _buildOTPBottomSheet() : null,
    );
  }

  Widget _buildMobileNumberField() {
    return TextFormField(
      controller: _mobileController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10), // Only 10 digits
      ],
      decoration: InputDecoration(
        labelText: AppStrings.getString(
          'mobile_number',
          SharedPrefsService.getLanguage() ?? 'en',
        ),
        hintText: AppStrings.getString(
          'enter_mobile_number_hint',
          SharedPrefsService.getLanguage() ?? 'en',
        ),
        prefixText: '+91 ',
        prefixIcon: const Icon(Icons.phone, color: AppTheme.primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.getString(
            'please_enter_mobile_number',
            SharedPrefsService.getLanguage() ?? 'en',
          );
        }
        if (value.length != 10) {
          return AppStrings.getString(
            'mobile_number_must_be_10_digits',
            SharedPrefsService.getLanguage() ?? 'en',
          );
        }
        return null;
      },
    );
  }

  Widget _buildOTPField() {
    return TextFormField(
      controller: _otpController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      decoration: InputDecoration(
        labelText: AppStrings.getString(
          'otp',
          SharedPrefsService.getLanguage() ?? 'en',
        ),
        hintText: AppStrings.getString(
          'enter_otp_hint',
          SharedPrefsService.getLanguage() ?? 'en',
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppTheme.primaryColor,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length != 6) {
          return AppStrings.getString(
            'please_enter_valid_otp',
            SharedPrefsService.getLanguage() ?? 'en',
          );
        }
        return null;
      },
    );
  }

  Widget _buildSendOTPButton(String langCode) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                AppStrings.getString('send_otp', langCode),
                style: AppTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildVerifyOTPButton(String langCode) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                AppStrings.getString('verify_otp', langCode),
                style: AppTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildResendOTPButton(String langCode) {
    return TextButton(
      onPressed: _isLoading ? null : _resendOTP,
      child: Text(
        AppStrings.getString('resend_otp', langCode),
        style: AppTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDemoInfo(String langCode, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.infoColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.infoColor,
                size: isSmallScreen ? 18 : 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.getString('demo_information', langCode),
                style: AppTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.infoColor,
                  fontWeight: FontWeight.w600,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.getString('demo_information_message', langCode),
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
              fontSize: isSmallScreen ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Enter OTP',
            style: AppTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We sent a 6-digit code to ${_mobileController.text}',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildOTPInputField(),
          const SizedBox(height: 16),
          _buildVerifyOTPButton(SharedPrefsService.getLanguage() ?? 'en'),
          const SizedBox(height: 8),
          _buildResendOTPButton(SharedPrefsService.getLanguage() ?? 'en'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOTPInputField() {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return SizedBox(
            width: 45,
            child: TextFormField(
              controller: TextEditingController(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
                // Update the full OTP controller
                _updateOTPController();
              },
            ),
          );
        }),
      ),
    );
  }

  void _updateOTPController() {
    // This would collect all 6 individual OTP digits and update the main OTP controller
    // Implementation depends on how you manage the 6 separate fields
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    // Immediately show OTP field and update UI
    if (mounted) {
      setState(() {
        _showOTPField = true;
      });
    }

    // Fire the network request in the background (no loading spinner, no UI feedback)
    // final url = Uri.parse(
    //   'https://smart-farmer-backend.vercel.app/api/farmer/contact/?contact=${_mobileController.text.trim()}',
    // );
    // http
    //     .post(url)
    //     .then((response) {
    //       log("Response status: ${response.statusCode}");
    //       log("Response body: ${response.body}");
    //       try {
    //         final data = json.decode(response.body);
    //         log("Decoded Body: $data");
    //       } catch (e) {
    //         log("Error decoding response body: $e");
    //       }
    //     })
    //     .catchError((e) {
    //       log("Network error: $e");
    //     });
  }

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // Call the login API (fetch farmer by contact)
      final url = Uri.parse(
        'https://smart-farmer-backend.vercel.app/api/farmer/contact?contact=${_mobileController.text.trim()}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['farmer'] != null && data['token'] != null) {
          // Save to shared preferences (like registration)
          await AuthService.saveCurrentUserFromBackend({
            'success': true,
            'farmer': data['farmer'],
            'token': data['token'],
          });
          // Save to local database
          final farmerJson = data['farmer'];
          final farmer = Farmer(
            id: farmerJson['_id'],
            name: farmerJson['name'],
            contactNumber: farmerJson['contact'],
            aadhaarNumber: farmerJson['aadhaarNumber'],
            village: farmerJson['village'],
            landmark: farmerJson['landMark'],
            taluka: farmerJson['taluka'],
            district: farmerJson['district'],
            pincode: farmerJson['pincode'],
            createdAt: DateTime.parse(farmerJson['createdAt']),
            updatedAt: DateTime.parse(farmerJson['updatedAt']),
          );
          await DatabaseService.deleteAllFarmers();
          await DatabaseService.insertFarmer(farmer);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(data['message'] ?? 'Login successful!'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => FarmerDashboardScreen()),
              (route) => false,
            );
          }
        }
      } else {
        // if (mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       // content: Text('Login failed: ${response.body}'),
        //       content: Text(
        //         json.decode(response.body)['message'] ?? 'Login failed',
        //       ),
        //       backgroundColor: AppTheme.errorColor,
        //     ),
        //   );
        // }
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => FarmerRegistrationScreen(
                initialContact: _mobileController.text.trim(),
              ),
            ),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOTP() async {
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP resent successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
}
