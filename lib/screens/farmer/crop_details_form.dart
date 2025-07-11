import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_farmer/screens/farmer/CameraScreen.dart';

import '../../blocs/crop/crop_bloc.dart';
import '../../blocs/crop/crop_event.dart';
import '../../constants/strings.dart';
import '../../constants/app_constants.dart';
import '../../models/crop.dart';
import '../../services/shared_prefs_service.dart';
import 'dart:math';
import '../../data/crop_data.dart';

class CropDetailsForm extends StatefulWidget {
  final Crop? crop;
  final String farmerId;

  const CropDetailsForm({super.key, this.crop, required this.farmerId});

  @override
  State<CropDetailsForm> createState() => _CropDetailsFormState();
}

class _CropDetailsFormState extends State<CropDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _cropNameController = TextEditingController();
  final _areaController = TextEditingController();
  final _expectedYieldController = TextEditingController();
  final _previousCropController = TextEditingController();

  String _selectedCropType = AppConstants.cropTypes.first;
  String _selectedSoilType = AppConstants.soilTypes.first;
  DateTime _sowingDate = DateTime.now();
  DateTime _expectedHarvestDate = DateTime.now();
  double _latitude = AppConstants.defaultLatitude;
  double _longitude = AppConstants.defaultLongitude;
  List<String> _imagePaths = [];
  //after git added
  final ImagePicker _imagePicker = ImagePicker();
  List<String> _imageSources = [];

  @override
  void initState() {
    super.initState();
    if (widget.crop != null) {
      _cropNameController.text = widget.crop!.cropName;
      _areaController.text = widget.crop!.area.toString();
      _expectedYieldController.text = widget.crop!.expectedYield.toString();
      _previousCropController.text = widget.crop!.previousCrop;
      _selectedCropType = widget.crop!.cropType;
      _selectedSoilType = widget.crop!.soilType;
      _sowingDate = widget.crop!.sowingDate;
      _expectedHarvestDate = widget.crop!.expectedHarvestDate;
      _latitude = widget.crop!.latitude;
      _longitude = widget.crop!.longitude;
      _imagePaths = List.from(widget.crop!.imagePaths);
    } else {
      _calculateExpectedHarvestDate();
    }
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = SharedPrefsService.getLanguage() ?? 'en';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: _buildAppBar(langCode),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(langCode),
              const SizedBox(height: 32),
              _buildFormSection(langCode),
              const SizedBox(height: 32),
              _buildActionSection(langCode),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String langCode) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        widget.crop == null
            ? AppStrings.getString('crop_details', langCode)
            : 'Edit ${AppStrings.getString('crop_details', langCode)}',
        style: const TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.crop == null
                ? const Color(0xFFE8F5E8)
                : const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.crop == null
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFFF9800),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.crop == null ? Icons.add_circle : Icons.edit,
                color: widget.crop == null
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFE65100),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                widget.crop == null ? 'New' : 'Edit',
                style: TextStyle(
                  color: widget.crop == null
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE65100),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(String langCode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.agriculture, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.crop == null ? 'New Crop Entry' : 'Edit Crop Details',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.crop == null
                      ? 'Fill in the details to register your crop'
                      : 'Update the crop information as needed',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(String langCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Basic Information', Icons.info_outline),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _cropNameController,
          label: AppStrings.getString('crop_name', langCode),
          hint: 'Enter crop name',
          icon: Icons.eco,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter crop name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildAreaField(langCode),
        const SizedBox(height: 16),
        Row(
          children: [
            Flexible(
              child: _buildDropdownField(
                AppStrings.getString('crop_type', langCode),
                'Select crop type',
                _selectedCropType,
                AppConstants.cropTypes,
                Icons.grass,
                (value) {
                  setState(() {
                    _selectedCropType = value!;
                    _calculateExpectedHarvestDate();
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: _buildDropdownField(
                AppStrings.getString('soil_type', langCode),
                'Select soil type',
                _selectedSoilType,
                AppConstants.soilTypes,
                Icons.terrain,
                (value) {
                  setState(() {
                    _selectedSoilType = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Dates & Yield', Icons.schedule),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                AppStrings.getString('sowing_date', langCode),
                _sowingDate,
                Icons.event_available,
                (date) {
                  setState(() {
                    _sowingDate = date;
                    _calculateExpectedHarvestDate();
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                AppStrings.getString('expected_harvest_date', langCode),
                _expectedHarvestDate,
                Icons.event_note,
                (date) {
                  setState(() {
                    _expectedHarvestDate = date;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _expectedYieldController,
          label: AppStrings.getString('expected_yield', langCode),
          hint: 'Enter expected yield',
          icon: Icons.bar_chart,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter expected yield';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextAreaField(
          '${AppStrings.getString('previous_crop', langCode)} (Optional)',
          _previousCropController,
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Location & Images', Icons.location_on),
        const SizedBox(height: 16),
        _buildLocationSection(langCode),
        const SizedBox(height: 16),
        _buildImageSection(langCode),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAreaField(String langCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.getString('area', langCode),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _areaController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter area';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter area',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.square_foot,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'acres',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String hint,
    String? value,
    List<String> items,
    IconData icon,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            hint: Text(hint, style: TextStyle(color: Colors.grey[500])),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime value,
    IconData icon,
    ValueChanged<DateTime> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF4CAF50),
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF4CAF50), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${value.day}/${value.month}/${value.year}',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: 2,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter previous crop details...',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(Icons.history, color: Color(0xFF4CAF50), size: 20),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(String langCode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFF2E7D32),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.getString('live_location', langCode),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FFFE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8F5E8)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.my_location,
                      color: Color(0xFF4CAF50),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Latitude: ${_latitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_searching,
                      color: Color(0xFF4CAF50),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Longitude: ${_longitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.gps_fixed, color: Colors.white, size: 18),
              label: const Text(
                'Update Current Location',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildImageSection(String langCode) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: const Color(0xFFE0E0E0)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF2E7D32).withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFE8F5E8),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(
  //                 Icons.photo_library,
  //                 color: Color(0xFF2E7D32),
  //                 size: 20,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Text(
  //               AppStrings.getString('upload_images', langCode),
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFF1B5E20),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         if (_imagePaths.isNotEmpty)
  //           Container(
  //             height: 120,
  //             margin: const EdgeInsets.only(bottom: 16),
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: _imagePaths.length,
  //               itemBuilder: (context, index) {
  //                 return Container(
  //                   margin: const EdgeInsets.only(right: 12),
  //                   child: Stack(
  //                     children: [
  //                       Container(
  //                         width: 120,
  //                         height: 120,
  //                         decoration: BoxDecoration(
  //                           color: const Color(0xFFF8FFFE),
  //                           border: Border.all(color: const Color(0xFFE8F5E8)),
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                         child: const Center(
  //                           child: Icon(
  //                             Icons.image,
  //                             size: 40,
  //                             color: Color(0xFF4CAF50),
  //                           ),
  //                         ),
  //                       ),
  //                       Positioned(
  //                         top: 4,
  //                         right: 4,
  //                         child: GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               _imagePaths.removeAt(index);
  //                             });
  //                           },
  //                           child: Container(
  //                             padding: const EdgeInsets.all(4),
  //                             decoration: const BoxDecoration(
  //                               color: Colors.red,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: const Icon(
  //                               Icons.close,
  //                               color: Colors.white,
  //                               size: 14,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         if (_imagePaths.length < AppConstants.maxCropImages)
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton.icon(
  //               icon: const Icon(
  //                 Icons.add_photo_alternate,
  //                 color: Colors.white,
  //                 size: 18,
  //               ),
  //               label: Text(
  //                 'Add Image (${_imagePaths.length}/${AppConstants.maxCropImages})',
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               onPressed: _imagePaths.length >= AppConstants.maxCropImages
  //                   ? null
  //                   : _pickImage,
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFF4CAF50),
  //                 padding: const EdgeInsets.symmetric(vertical: 14),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 elevation: 2,
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActionSection(String langCode) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveCrop,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.crop == null
                      ? AppStrings.getString('Send for Verification', langCode)
                      : AppStrings.getString('update', langCode),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9800),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Status: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE65100),
                ),
              ),
              Text(
                widget.crop == null ? 'Ready to Save' : 'Ready to Update',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFE65100),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //today 11

  // Widget _buildImageSection(String langCode) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: const Color(0xFFE0E0E0)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF2E7D32).withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFE8F5E8),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(
  //                 Icons.photo_library,
  //                 color: Color(0xFF2E7D32),
  //                 size: 20,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Text(
  //               AppStrings.getString('upload_images', langCode),
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFF1B5E20),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         if (_imagePaths.isNotEmpty)
  //           Container(
  //             height: 120,
  //             margin: const EdgeInsets.only(bottom: 16),
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: _imagePaths.length,
  //               itemBuilder: (context, index) {
  //                 return Container(
  //                   margin: const EdgeInsets.only(right: 12),
  //                   //
  //                   child: Stack(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (_) => FullScreenImage(
  //                                 imagePath: _imagePaths[index],
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                         child: Container(
  //                           width: 120,
  //                           height: 120,
  //                           decoration: BoxDecoration(
  //                             color: const Color(0xFFF8FFFE),
  //                             border: Border.all(
  //                               color: const Color(0xFFE8F5E8),
  //                             ),
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: _imagePaths[index].startsWith('http')
  //                               ? Image.network(
  //                                   _imagePaths[index],
  //                                   fit: BoxFit.cover,
  //                                 )
  //                               : Image.file(
  //                                   File(_imagePaths[index]),
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                         ),
  //                       ),

  //                       Positioned(
  //                         top: 4,
  //                         right: 4,
  //                         child: GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               _imagePaths.removeAt(index);
  //                             });
  //                           },
  //                           child: Container(
  //                             padding: const EdgeInsets.all(4),
  //                             decoration: const BoxDecoration(
  //                               color: Colors.red,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: const Icon(
  //                               Icons.close,
  //                               color: Colors.white,
  //                               size: 14,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         if (_imagePaths.length < AppConstants.maxCropImages)
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: ElevatedButton.icon(
  //                   icon: const Icon(
  //                     Icons.add_photo_alternate,
  //                     color: Colors.white,
  //                     size: 18,
  //                   ),
  //                   label: Text(
  //                     'Add (${_imagePaths.length}/${AppConstants.maxCropImages})',
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   onPressed: _imagePaths.length >= AppConstants.maxCropImages
  //                       ? null
  //                       : _pickImage,
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: const Color(0xFF4CAF50),
  //                     padding: const EdgeInsets.symmetric(vertical: 14),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     elevation: 2,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: ElevatedButton.icon(
  //                   icon: const Icon(
  //                     Icons.camera_alt,
  //                     color: Colors.white,
  //                     size: 18,
  //                   ),
  //                   label: Text(
  //                     'Capture (${_imagePaths.length}/${AppConstants.maxCropImages})',
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   onPressed: _imagePaths.length >= AppConstants.maxCropImages
  //                       ? null
  //                       : _captureImage,
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: const Color(0xFF4CAF50),
  //                     padding: const EdgeInsets.symmetric(vertical: 14),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     elevation: 2,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildImageSection(String langCode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF2E7D32),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.getString('upload_images', langCode),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_imagePaths.isNotEmpty)
            Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: "Image Preview",
                              pageBuilder: (context, anim1, anim2) {
                                return Scaffold(
                                  backgroundColor: Colors.black,
                                  body: SafeArea(
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Center(
                                        child: InteractiveViewer(
                                          child:
                                              _imagePaths[index].startsWith(
                                                'http',
                                              )
                                              ? Image.network(
                                                  _imagePaths[index],
                                                  fit: BoxFit.contain,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                )
                                              : Image.file(
                                                  File(_imagePaths[index]),
                                                  fit: BoxFit.contain,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FFFE),
                              border: Border.all(
                                color: const Color(0xFFE8F5E8),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _imagePaths[index].startsWith('http')
                                ? Image.network(
                                    _imagePaths[index],
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_imagePaths[index]),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imagePaths.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (_imagePaths.length < AppConstants.maxCropImages)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      'Add (${_imagePaths.length}/${AppConstants.maxCropImages})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _imagePaths.length >= AppConstants.maxCropImages
                        ? null
                        : _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      'Capture (${_imagePaths.length}/${AppConstants.maxCropImages})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _imagePaths.length >= AppConstants.maxCropImages
                        ? null
                        : _captureImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _calculateExpectedHarvestDate() {
    final lifespan = AppConstants.cropLifespan[_selectedCropType] ?? 120;
    _expectedHarvestDate = _sowingDate.add(Duration(days: lifespan));
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Location updated successfully!'),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  //   if (image != null) {
  //     setState(() {
  //       _imagePaths.add(image.path);
  //     });

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Row(
  //             children: [
  //               Icon(Icons.check_circle, color: Colors.white, size: 20),
  //               SizedBox(width: 8),
  //               Text('Image added successfully!'),
  //             ],
  //           ),
  //           backgroundColor: const Color(0xFF4CAF50),
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           duration: const Duration(seconds: 2),
  //         ),
  //       );
  //     }
  //   }
  // }

  //changes
  //
  Future<void> _pickImage() async {
    if (_imagePaths.length >= AppConstants.maxCropImages) return;

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _imagePaths.add(pickedFile.path);
          _imageSources.add('gallery');
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      }
      debugPrint('Error picking image: $e');
    }
  }

  //after git

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  //   if (image != null && _imagePaths.length < AppConstants.maxCropImages) {
  //     setState(() {
  //       _imagePaths.add(image.path);
  //     });
  //   }
  // }

  //after git opush

  // Future<void> _captureImage() async {
  //   final cameras = await availableCameras();
  //   final firstCamera = cameras.first;

  //   final imagePath = await Navigator.push<String>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CameraScreen(
  //         camera: firstCamera,
  //         latitude: _latitude,
  //         longitude: _longitude,
  //       ),
  //     ),
  //   );

  //   if (imagePath != null) {
  //     setState(() {
  //       _imagePaths.add(imagePath);
  //     });
  //     _showSuccessSnackbar('Image captured successfully!');
  //   }
  // }

  void _showSuccessSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(message),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  //suraj change

  Future<void> _captureImage() async {
    try {
      // Check camera permissions first
      final cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Camera permission required')),
            );
          }
          return;
        }
      }

      // Get available cameras
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No cameras available')));
        }
        return;
      }

      // Open camera screen
      final imagePath = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            camera: cameras.first,
            latitude: _latitude,
            longitude: _longitude,
          ),
        ),
      );

      if (imagePath != null && mounted) {
        setState(() {
          _imagePaths.add(imagePath);
          _imageSources.add('camera');
        });
        _showSuccessSnackbar('Image captured successfully!');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture image: ${e.toString()}')),
        );
      }
      debugPrint('Error capturing image: $e');
    }
  }

  void _saveCrop() {
    if (_formKey.currentState!.validate()) {
      final crop = Crop(
        id: widget.crop?.id ?? _generateId(),
        farmerId: widget.farmerId,
        cropName: _cropNameController.text.trim(),
        area: double.parse(_areaController.text),
        cropType: _selectedCropType,
        soilType: _selectedSoilType,
        sowingDate: _sowingDate,
        expectedHarvestDate: _expectedHarvestDate,
        expectedYield: double.parse(_expectedYieldController.text),
        previousCrop: _previousCropController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        imagePaths: _imagePaths,
        status: widget.crop?.status ?? AppConstants.statusPending,
        createdAt: widget.crop?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.crop == null) {
        context.read<CropBloc>().add(AddCrop(crop));
        globalCropList.add(crop);
      } else {
        context.read<CropBloc>().add(UpdateCrop(crop));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.crop == null
                        ? AppStrings.getString(
                            'data_saved_successfully',
                            SharedPrefsService.getLanguage() ?? 'en',
                          )
                        : AppStrings.getString(
                            'data_updated_successfully',
                            SharedPrefsService.getLanguage() ?? 'en',
                          ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Please fill all required fields correctly'),
              ],
            ),
            backgroundColor: const Color(0xFFF44336),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _generateId() {
    return 'crop_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _areaController.dispose();
    _expectedYieldController.dispose();
    _previousCropController.dispose();
    super.dispose();
  }
}
