import 'package:flutter/material.dart';
import '../farmer/crop_add_edit__form.dart';
import '../../data/crop_data.dart';

class CropDetailScreen extends StatelessWidget {
  final dynamic crop;
  const CropDetailScreen({Key? key, required this.crop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Crop Details',
          style: TextStyle(
            // color: Color(0xFF2E7D32),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Crop',
            onPressed: () async {
              final updatedCrop = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CropDetailsForm(crop: crop, farmerId: crop.farmerId),
                ),
              );
              if (updatedCrop != null) {
                // Update the crop in globalCropList
                final idx = globalCropList.indexWhere(
                  (c) => c.id == updatedCrop.id,
                );
                if (idx != -1) {
                  globalCropList[idx] = updatedCrop;
                }
                // Refresh the detail screen with new data
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CropDetailScreen(crop: updatedCrop),
                  ),
                );
              }
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop.cropName ?? '-',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Type: ${crop.cropType ?? '-'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildDetailSection(
              'Area',
              '${crop.area ?? '-'} acres',
              Icons.landscape_rounded,
            ),
            // _buildDetailSection(
            //   'Soil Type',
            //   crop.soilType ?? '-',
            //   Icons.terrain_rounded,
            // ),
            _buildDetailSection(
              'Sowing Date',
              crop.sowingDate != null
                  ? crop.sowingDate.toString().split(' ')[0]
                  : '-',
              Icons.calendar_today_rounded,
            ),
            _buildDetailSection(
              'Expected Harvest',
              crop.expectedHarvestDate != null
                  ? crop.expectedHarvestDate.toString().split(' ')[0]
                  : '-',
              Icons.event_available_rounded,
            ),
            _buildDetailSection(
              'Expected Yield',
              crop.expectedYield != null ? '${crop.expectedYield} tons' : '-',
              Icons.stacked_line_chart_rounded,
            ),
            _buildDetailSection(
              'Previous Crop',
              crop.previousCrop ?? '-',
              Icons.history_rounded,
            ),
            _buildDetailSection(
              'Status',
              crop.status ?? '-',
              Icons.verified_rounded,
            ),
            _buildDetailSection(
              'Location',
              'Lat: ${crop.latitude ?? '-'}, Lng: ${crop.longitude ?? '-'}',
              Icons.location_on_rounded,
            ),
            if (crop.imagePaths != null && crop.imagePaths.isNotEmpty)
              _buildImagesSection(crop.imagePaths),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection(List<dynamic> imagePaths) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        const Text(
          'Crop Images',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final path = imagePaths[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  path,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
