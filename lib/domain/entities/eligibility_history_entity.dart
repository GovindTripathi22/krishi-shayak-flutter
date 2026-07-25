import 'package:equatable/equatable.dart';

class EligibilityHistoryEntity extends Equatable {
  final String id;
  final DateTime checkDate;
  final String state;
  final String crop;
  final int totalEligibleCount;
  final List<String> topSchemeNames;

  const EligibilityHistoryEntity({
    required this.id,
    required this.checkDate,
    required this.state,
    required this.crop,
    required this.totalEligibleCount,
    required this.topSchemeNames,
  });

  @override
  List<Object?> get props => [
        id,
        checkDate,
        state,
        crop,
        totalEligibleCount,
        topSchemeNames,
      ];
}
