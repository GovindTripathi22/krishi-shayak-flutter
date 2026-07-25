import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/scheme_filter_params.dart';
import '../../../common_widgets/app_button.dart';
import '../../providers/scheme_providers.dart';

class SchemeFilterBottomSheet extends ConsumerStatefulWidget {
  const SchemeFilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLarge)),
      ),
      builder: (ctx) => const SchemeFilterBottomSheet(),
    );
  }

  @override
  ConsumerState<SchemeFilterBottomSheet> createState() => _SchemeFilterBottomSheetState();
}

class _SchemeFilterBottomSheetState extends ConsumerState<SchemeFilterBottomSheet> {
  String? _selectedCategory;
  String? _selectedState;
  String? _selectedCrop;
  bool? _isCentralScheme;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(schemeFilterProvider);
    _selectedCategory = filter.category;
    _selectedState = filter.state;
    _selectedCrop = filter.crop;
    _isCentralScheme = filter.isCentralScheme;
  }

  void _applyFilter() {
    ref.read(schemeFilterProvider.notifier).state = SchemeFilterParams(
      category: _selectedCategory,
      state: _selectedState,
      crop: _selectedCrop,
      isCentralScheme: _isCentralScheme,
    );
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    setState(() {
      _selectedCategory = null;
      _selectedState = null;
      _selectedCrop = null;
      _isCentralScheme = null;
    });
    ref.read(schemeFilterProvider.notifier).state = const SchemeFilterParams();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Schemes',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _resetFilter,
                child: const Text('Reset All', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scheme Type (Central vs State)
                  Text('Scheme Scope', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('All Schemes'),
                        selected: _isCentralScheme == null,
                        onSelected: (s) => setState(() => _isCentralScheme = null),
                      ),
                      const SizedBox(width: 8.0),
                      ChoiceChip(
                        label: const Text('Central Govt'),
                        selected: _isCentralScheme == true,
                        onSelected: (s) => setState(() => _isCentralScheme = true),
                      ),
                      const SizedBox(width: 8.0),
                      ChoiceChip(
                        label: const Text('State Govt'),
                        selected: _isCentralScheme == false,
                        onSelected: (s) => setState(() => _isCentralScheme = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // Category Filter
                  Text('Scheme Category', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    children: ['All', 'Financial Assistance', 'Crop Insurance', 'Agricultural Credit', 'Irrigation & Water']
                        .map((cat) {
                      final isSel = (_selectedCategory == cat) || (_selectedCategory == null && cat == 'All');
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        selectedColor: AppColors.primaryContainer,
                        onSelected: (sel) {
                          setState(() => _selectedCategory = cat == 'All' ? null : cat);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20.0),

                  // State Filter
                  Text('Applicable State', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6.0),
                  DropdownButton<String>(
                    value: _selectedState ?? 'All India',
                    isExpanded: true,
                    items: ['All India', 'Maharashtra', 'Gujarat', 'Uttar Pradesh', 'Rajasthan', 'Karnataka', 'Tamil Nadu']
                        .map((st) => DropdownMenuItem(value: st, child: Text(st)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedState = val == 'All India' ? null : val);
                    },
                  ),
                  const SizedBox(height: 20.0),

                  // Crop Filter
                  Text('Target Crop', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6.0),
                  DropdownButton<String>(
                    value: _selectedCrop ?? 'All Crops',
                    isExpanded: true,
                    items: ['All Crops', 'Wheat', 'Rice', 'Cotton', 'Sugarcane', 'Soybean']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedCrop = val == 'All Crops' ? null : val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          AppButton(
            text: 'Apply Filters',
            icon: Icons.filter_alt_rounded,
            onPressed: _applyFilter,
          ),
        ],
      ),
    );
  }
}
