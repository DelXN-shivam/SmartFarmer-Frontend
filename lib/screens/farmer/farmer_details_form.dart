import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/farmer/farmer_bloc.dart';
import '../../blocs/farmer/farmer_event.dart';
import '../../constants/strings.dart';
import '../../constants/app_constants.dart';
import '../../models/farmer.dart';
import '../../services/shared_prefs_service.dart';
import 'dart:math';

class FarmerDetailsForm extends StatefulWidget {
  final Farmer? farmer;

  const FarmerDetailsForm({super.key, this.farmer});

  @override
  State<FarmerDetailsForm> createState() => _FarmerDetailsFormState();
}

class _FarmerDetailsFormState extends State<FarmerDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _villageController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _talukaController = TextEditingController();
  final _districtController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.farmer != null) {
      _nameController.text = widget.farmer!.name;
      _contactController.text = widget.farmer!.contactNumber;
      _aadhaarController.text = widget.farmer!.aadhaarNumber;
      _villageController.text = widget.farmer!.village;
      _landmarkController.text = widget.farmer!.landmark;
      _talukaController.text = widget.farmer!.taluka;
      _districtController.text = widget.farmer!.district;
      _pincodeController.text = widget.farmer!.pincode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = SharedPrefsService.getLanguage() ?? 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.farmer == null
              ? AppStrings.getString('farmer_details', langCode)
              : 'Edit ${AppStrings.getString('farmer_details', langCode)}',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(
              controller: _nameController,
              label: AppStrings.getString('name', langCode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _contactController,
              label: AppStrings.getString('contact_number', langCode),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact number';
                }
                if (value.length != AppConstants.phoneLength) {
                  return AppStrings.getString('invalid_phone', langCode);
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _aadhaarController,
              label: AppStrings.getString('aadhaar_number', langCode),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Aadhaar number';
                }
                if (value.length != AppConstants.aadhaarLength) {
                  return AppStrings.getString('invalid_aadhaar', langCode);
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _villageController,
              label: AppStrings.getString('village', langCode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter village';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _landmarkController,
              label: AppStrings.getString('landmark', langCode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter landmark';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _talukaController,
              label: AppStrings.getString('taluka', langCode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter taluka';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _districtController,
              label: AppStrings.getString('district', langCode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter district';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _pincodeController,
              label: AppStrings.getString('pincode', langCode),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pincode';
                }
                if (value.length != AppConstants.pincodeLength) {
                  return AppStrings.getString('invalid_pincode', langCode);
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveFarmer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.farmer == null
                    ? AppStrings.getString('save', langCode)
                    : AppStrings.getString('update', langCode),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  void _saveFarmer() {
    if (_formKey.currentState!.validate()) {
      final farmer = Farmer(
        id: widget.farmer?.id ?? _generateId(),
        name: _nameController.text.trim(),
        contactNumber: _contactController.text.trim(),
        aadhaarNumber: _aadhaarController.text.trim(),
        village: _villageController.text.trim(),
        landmark: _landmarkController.text.trim(),
        taluka: _talukaController.text.trim(),
        district: _districtController.text.trim(),
        pincode: _pincodeController.text.trim(),
        createdAt: widget.farmer?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.farmer == null) {
        context.read<FarmerBloc>().add(AddFarmer(farmer));
      } else {
        context.read<FarmerBloc>().add(UpdateFarmer(farmer));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.farmer == null
                ? AppStrings.getString(
                    'data_saved_successfully',
                    SharedPrefsService.getLanguage() ?? 'en',
                  )
                : AppStrings.getString(
                    'data_updated_successfully',
                    SharedPrefsService.getLanguage() ?? 'en',
                  ),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  String _generateId() {
    return 'farmer_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _aadhaarController.dispose();
    _villageController.dispose();
    _landmarkController.dispose();
    _talukaController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }
}
