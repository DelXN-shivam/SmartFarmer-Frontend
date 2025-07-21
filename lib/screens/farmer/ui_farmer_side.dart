import 'package:flutter/material.dart';

class SmartFarmScreen extends StatefulWidget {
  @override
  _SmartFarmScreenState createState() => _SmartFarmScreenState();
}

class _SmartFarmScreenState extends State<SmartFarmScreen> {
  String? selectedIrrigationMethod;
  DateTime? selectedSowingDate;
  TextEditingController areaController = TextEditingController();
  TextEditingController yieldController = TextEditingController();
  TextEditingController historyController = TextEditingController();

  final List<String> irrigationMethods = [
    'Drip',
    'Sprinkler',
    'Flood',
    'Furrow',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.lock, color: Colors.white, size: 20),
        ),
        title: Text(
          'SmartFarm',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Welcome,',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                'Rajesh Kumar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text('R', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Farm Input Form',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24),
            _buildAreaField(),
            SizedBox(height: 16),
            _buildDateField(),
            SizedBox(height: 16),
            _buildTextField(
              '📊 Expected Yield (tons)',
              'Enter expected yield',
              yieldController,
              TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              '💧 Irrigation Method',
              'Select irrigation method',
              selectedIrrigationMethod,
              irrigationMethods,
              (value) => setState(() => selectedIrrigationMethod = value),
            ),
            SizedBox(height: 16),
            _buildTextAreaField(
              '📋 Previous Crop History (Optional)',
              historyController,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Send for Validation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Status: ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Ready to Submit',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            _buildQuickTips(),
            SizedBox(height: 24),
            _buildFarmStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String hint,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint, style: TextStyle(color: Colors.grey[500])),
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAreaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📐 Area',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: areaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter area',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'acres',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🌱 Sowing Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() {
                selectedSowingDate = picked;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedSowingDate != null
                      ? '${selectedSowingDate!.day}/${selectedSowingDate!.month}/${selectedSowingDate!.year}'
                      : 'Select sowing date',
                  style: TextStyle(
                    color: selectedSowingDate != null
                        ? Colors.black
                        : Colors.grey[500],
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[500], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[500]),
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text(
              'Quick Tips',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 12),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soil Testing',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Get your soil tested before sowing for better yield predictions',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.wb_sunny, color: Colors.white, size: 12),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weather Monitoring',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Check weather forecasts before planning irrigation schedules',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFarmStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text(
              'Your Farm Stats',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('12.5', 'Total Acres', Colors.green),
            ),
            SizedBox(width: 12),
            Expanded(child: _buildStatCard('3', 'Active Crops', Colors.blue)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('85%', 'Success Rate', Colors.green),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('₹2.4L', 'Est. Revenue', Colors.orange),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _submitForm() {
    if (areaController.text.isEmpty ||
        selectedSowingDate == null ||
        yieldController.text.isEmpty ||
        selectedIrrigationMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form submitted successfully for validation!'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear form
    setState(() {
      selectedIrrigationMethod = null;
      selectedSowingDate = null;
    });
    areaController.clear();
    yieldController.clear();
    historyController.clear();
  }
}
