import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_theme.dart';
import '../../services/auth_service.dart';

class FarmerRegistrationScreen extends StatefulWidget {
  const FarmerRegistrationScreen({super.key});

  @override
  State<FarmerRegistrationScreen> createState() =>
      _FarmerRegistrationScreenState();
}

class _FarmerRegistrationScreenState extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _villageController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _talukaController = TextEditingController();
  final _districtController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool _isLoading = false;
  int _currentStep = 0;
  bool _acceptedTerms = false;
  bool _showTermsError = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentStep) {
        setState(() => _currentStep = page);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _aadhaarController.dispose();
    _villageController.dispose();
    _landmarkController.dispose();
    _talukaController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Registration'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress Indicator
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Row(
                  children: [
                    _buildProgressStep(
                      0,
                      'Personal Info',
                      Icons.person,
                      isSmallScreen,
                    ),
                    _buildProgressLine(),
                    _buildProgressStep(
                      1,
                      'Address',
                      Icons.location_on,
                      isSmallScreen,
                    ),
                    _buildProgressLine(),
                    _buildProgressStep(
                      2,
                      'Security',
                      Icons.lock,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      _buildPersonalInfoStep(isSmallScreen),
                      _buildAddressStep(isSmallScreen),
                      _buildSecurityStep(isSmallScreen),
                    ],
                  ),
                ),
              ),

              // Navigation Buttons
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _previousStep,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 12 : 16,
                                ),
                              ),
                              child: const Text('Previous'),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleStepAction,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 12 : 16,
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(_currentStep == 2 ? 'Register' : 'Next'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    // Back to Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Back to Login',
                            style: AppTheme.textTheme.labelLarge?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep(
    int step,
    String title,
    IconData icon,
    bool isSmallScreen,
  ) {
    final isActive = _currentStep >= step;
    final isCompleted = _currentStep > step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: isSmallScreen ? 32 : 40,
            height: isSmallScreen ? 32 : 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.successColor
                  : isActive
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: Colors.white,
              size: isSmallScreen ? 16 : 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTheme.textTheme.labelSmall?.copyWith(
              color: isActive
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondaryColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: isSmallScreen ? 10 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine() {
    return Container(
      height: 2,
      width: 20,
      color: _currentStep > 0 ? AppTheme.primaryColor : AppTheme.dividerColor,
    );
  }

  Widget _buildPersonalInfoStep(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: AppTheme.textTheme.headlineMedium?.copyWith(
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide your basic information',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),

          _buildTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            icon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Invalid email format';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),

          _buildTextField(
            controller: _contactController,
            label: 'Contact Number',
            hint: 'Enter 10-digit mobile number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Contact number is required';
              }
              if (value.length != 10) {
                return 'Contact number must be 10 digits';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),

          _buildTextField(
            controller: _aadhaarController,
            label: 'Aadhaar Number',
            hint: 'Enter 12-digit Aadhaar number',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Aadhaar number is required';
              }
              if (value.length != 12) {
                return 'Aadhaar number must be 12 digits';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address Information',
            style: AppTheme.textTheme.headlineMedium?.copyWith(
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide your address details',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          _buildTextField(
            controller: _villageController,
            label: 'Village',
            hint: 'Enter your village name',
            icon: Icons.location_city,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Village is required';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),

          _buildTextField(
            controller: _landmarkController,
            label: 'Landmark',
            hint: 'Enter nearby landmark',
            icon: Icons.place,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Landmark is required';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),

          _buildTextField(
            controller: _talukaController,
            label: 'Taluka',
            hint: 'Enter your taluka',
            icon: Icons.map,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Taluka is required';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),

          _buildTextField(
            controller: _districtController,
            label: 'District',
            hint: 'Enter your district',
            icon: Icons.map,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'District is required';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),

          _buildTextField(
            controller: _pincodeController,
            label: 'Pincode',
            hint: 'Enter 6-digit pincode',
            icon: Icons.pin_drop,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pincode is required';
              }
              if (value.length != 6) {
                return 'Pincode must be 6 digits';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityStep(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Setup',
            style: AppTheme.textTheme.headlineMedium?.copyWith(
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a secure password for your account',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          // Terms and Conditions
          Row(
            children: [
              Checkbox(
                value: _acceptedTerms,
                onChanged: (value) =>
                    setState(() => _acceptedTerms = value ?? false),
                activeColor: AppTheme.primaryColor,
              ),
              Expanded(
                child: Text(
                  'I agree to the Terms and Conditions',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    fontSize: isSmallScreen ? 11 : 12,
                  ),
                ),
              ),
            ],
          ),
          if (!_acceptedTerms && _showTermsError)
            Padding(
              padding: const EdgeInsets.only(left: 48, top: 4),
              child: Text(
                'Please accept the terms and conditions',
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.errorColor,
                  fontSize: isSmallScreen ? 10 : 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleStepAction() {
    if (_currentStep < 2) {
      if (_validateCurrentStep()) {
        _nextStep();
      }
    } else {
      _handleRegistration();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey.currentState!.validate() &&
            _nameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _contactController.text.isNotEmpty &&
            _aadhaarController.text.isNotEmpty;
      case 1:
        return _formKey.currentState!.validate() &&
            _villageController.text.isNotEmpty &&
            _landmarkController.text.isNotEmpty &&
            _talukaController.text.isNotEmpty &&
            _districtController.text.isNotEmpty &&
            _pincodeController.text.isNotEmpty;
      case 2:
        if (!_acceptedTerms) {
          setState(() => _showTermsError = true);
          return false;
        }
        setState(() => _showTermsError = false);
        return _formKey.currentState!.validate();
      default:
        return false;
    }
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      print('RegistrationScreen: Starting registration process');

      final result = await AuthService.registerFarmer(
        name: _nameController.text.trim(),
        mobileNumber: _contactController.text.trim(),
        contactNumber: _contactController.text.trim(),
        aadhaarNumber: _aadhaarController.text.trim(),
        village: _villageController.text.trim(),
        landmark: _landmarkController.text.trim(),
        taluka: _talukaController.text.trim(),
        district: _districtController.text.trim(),
        pincode: _pincodeController.text.trim(),
      );

      print('RegistrationScreen: Registration result: $result');

      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => FarmerRegistrationScreen()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      print('RegistrationScreen: Registration error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
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
}
