import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_top_bar.dart';

class DocumentChecklistScreen extends ConsumerStatefulWidget {
  const DocumentChecklistScreen({super.key});

  @override
  ConsumerState<DocumentChecklistScreen> createState() => _DocumentChecklistScreenState();
}

class _DocumentChecklistScreenState extends ConsumerState<DocumentChecklistScreen> {
  final Map<String, bool> _documentStatus = {
    'Aadhaar Card (Linked with Bank)': true,
    '7/12 Land Extract Certificate': true,
    'Bank Account Passbook': true,
    'Crop Sowing Certificate': false,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedCount = _documentStatus.values.where((status) => status).length;
    final totalCount = _documentStatus.length;
    final double progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;

    return Scaffold(
      appBar: const AppTopBar(title: 'AI Document Checklist Generator'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preparedness Card
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade700, Colors.amber.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade900.withOpacity(0.25),
                      blurRadius: 16.0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PM-KISAN SCHEME CHECKLIST',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${(progress * 100).toInt()}% Ready for Portal',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.extrabold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$completedCount/$totalCount',
                              style: TextStyle(
                                color: Colors.amber.shade900,
                                fontWeight: FontWeight.extrabold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8.0,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '$completedCount of $totalCount required documents ready before online submission.',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              Text(
                'Required Documents Checklist',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),

              ..._documentStatus.keys.map((docName) {
                final isDone = _documentStatus[docName]!;

                return AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isDone,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _documentStatus[docName] = val ?? false;
                          });
                        },
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    docName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDone ? AppColors.textPrimary : Colors.red.shade900,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: isDone ? AppColors.primaryContainer : Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    isDone ? 'Completed' : 'Pending',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: isDone ? AppColors.primaryDark : Colors.orange.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              isDone
                                  ? 'AI Explanation: Verified beneficiary identity for Direct Benefit Transfer.'
                                  : 'AI Guidance: Obtain from your local Talathi or Gram Panchayat office before applying.',
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
