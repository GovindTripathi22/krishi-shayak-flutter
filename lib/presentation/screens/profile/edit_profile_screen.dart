import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/farmer_profile_entity.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_text_field.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../providers/auth_controller_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _villageController;
  late TextEditingController _pincodeController;

  String _selectedState = 'Maharashtra';
  String _selectedCrop = 'Wheat / Wheat';
  String _selectedLand = '2.5 Acres';

  @override
  void initState() {
    super.initState();
    final profile = ref.read(authControllerProvider).farmerProfile;

    _nameController = TextEditingController(text: profile?.fullName ?? 'Ramesh Patel');
    _ageController = TextEditingController(text: '${profile?.age ?? 42}');
    _villageController = TextEditingController(text: profile?.village ?? 'Pimplegaon');
    _pincodeController = TextEditingController(text: profile?.pincode ?? '422209');

    if (profile != null) {
      if (profile.state.isNotEmpty) _selectedState = profile.state;
      if (profile.primaryCrop.isNotEmpty) _selectedCrop = profile.primaryCrop;
      if (profile.landSize.isNotEmpty) _selectedLand = profile.landSize;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _villageController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final authState = ref.read(authControllerProvider);
    final currentProf = authState.farmerProfile;

    final updatedProfile = FarmerProfileEntity(
      userId: authState.user?.id ?? 'usr_101',
      authProvider: currentProf?.authProvider ?? 'phone',
      fullName: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 40,
      gender: currentProf?.gender ?? 'Male',
      phoneNumber: authState.user?.phoneNumber ?? '9876543210',
      preferredLanguage: currentProf?.preferredLanguage ?? 'hi',
      state: _selectedState,
      district: currentProf?.district ?? 'Nashik',
      village: _villageController.text.trim(),
      pincode: _pincodeController.text.trim(),
      primaryCrop: _selectedCrop,
      secondaryCrop: currentProf?.secondaryCrop ?? 'Onion',
      landSize: _selectedLand,
      landOwnership: currentProf?.landOwnership ?? 'Owned',
      annualIncome: currentProf?.annualIncome ?? '₹1,50,000 - ₹3,00,000',
      farmerCategory: currentProf?.farmerCategory ?? 'Small Farmer',
      irrigationType: currentProf?.irrigationType ?? 'Drip Irrigation',
      farmingExperience: currentProf?.farmingExperience ?? '10+ Years',
      isProfileComplete: true,
      createdAt: currentProf?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(authControllerProvider.notifier).updateFarmerProfile(updatedProfile);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farmer Profile Updated Successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locTheme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppTopBar(title: 'Edit Farmer Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Full Name',
                controller: _nameController,
              ),
              const SizedBox(height: 16.0),

              AppTextField(
                label: 'Age',
                controller: _ageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),

              Text('State', style: locTheme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6.0),
              DropdownButton<String>(
                value: _selectedState,
                isExpanded: true,
                items: ['Maharashtra', 'Uttar Pradesh', 'Punjab', 'Gujarat', 'Tamil Nadu', 'Karnataka']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedState = val);
                },
              ),
              const SizedBox(height: 16.0),

              AppTextField(
                label: 'Village / Town',
                controller: _villageController,
              ),
              const SizedBox(height: 16.0),

              AppTextField(
                label: 'Pin Code',
                controller: _pincodeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),

              Text('Primary Crop', style: locTheme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6.0),
              DropdownButton<String>(
                value: _selectedCrop,
                isExpanded: true,
                items: ['Wheat / Wheat', 'Rice / Paddy', 'Cotton', 'Sugarcane', 'Soybean']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCrop = val);
                },
              ),
              const SizedBox(height: 32.0),

              AppButton(
                text: 'Save Changes',
                icon: Icons.save_rounded,
                isLoading: authState.isLoading,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
