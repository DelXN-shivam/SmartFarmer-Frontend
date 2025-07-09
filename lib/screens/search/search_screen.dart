import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/farmer/farmer_bloc.dart';
import '../../blocs/farmer/farmer_event.dart';
import '../../blocs/farmer/farmer_state.dart';
import '../../blocs/crop/crop_bloc.dart';
import '../../blocs/crop/crop_event.dart';
import '../../constants/strings.dart';
import '../../services/shared_prefs_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      _isSearching = _searchQuery.isNotEmpty;
    });

    if (_isSearching) {
      context.read<FarmerBloc>().add(SearchFarmers(_searchQuery));
    } else {
      context.read<FarmerBloc>().add(LoadFarmers());
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = SharedPrefsService.getLanguage() ?? 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getString('search_farmers', langCode)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppStrings.getString(
                  'search_farmers_placeholder',
                  langCode,
                ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          Expanded(
            child: _isSearching ? _buildSearchResults() : _buildAllFarmers(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<FarmerBloc, FarmerState>(
      builder: (context, state) {
        if (state is FarmerLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FarmerLoaded) {
          if (state.farmers.isEmpty) {
            return Center(
              child: Text(
                AppStrings.getString(
                  'no_data_found',
                  SharedPrefsService.getLanguage() ?? 'en',
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.farmers.length,
            itemBuilder: (context, index) {
              final farmer = state.farmers[index];
              return _buildFarmerCard(farmer);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAllFarmers() {
    return BlocBuilder<FarmerBloc, FarmerState>(
      builder: (context, state) {
        if (state is FarmerLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FarmerLoaded) {
          if (state.farmers.isEmpty) {
            return Center(
              child: Text(
                AppStrings.getString(
                  'no_data_found',
                  SharedPrefsService.getLanguage() ?? 'en',
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.farmers.length,
            itemBuilder: (context, index) {
              final farmer = state.farmers[index];
              return _buildFarmerCard(farmer);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFarmerCard(farmer) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(farmer.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(farmer.contactNumber), Text(farmer.fullAddress)],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: Navigate to farmer details
          _showFarmerDetails(farmer);
        },
      ),
    );
  }

  void _showFarmerDetails(farmer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Farmer Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailRow('Name', farmer.name),
                    _buildDetailRow('Contact', farmer.contactNumber),
                    _buildDetailRow('Aadhaar', farmer.aadhaarNumber),
                    _buildDetailRow('Village', farmer.village),
                    _buildDetailRow('Landmark', farmer.landmark),
                    _buildDetailRow('Taluka', farmer.taluka),
                    _buildDetailRow('District', farmer.district),
                    _buildDetailRow('Pincode', farmer.pincode),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: Load and show farmer's crops
                        context.read<CropBloc>().add(
                          LoadCropsByFarmer(farmer.id),
                        );
                      },
                      child: const Text('View Crops'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
