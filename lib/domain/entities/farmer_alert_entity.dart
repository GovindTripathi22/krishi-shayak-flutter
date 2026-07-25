import 'package:equatable/equatable.dart';

enum AlertType { announcement, deadline, heavyRain, diseaseWarning, payment }

class FarmerAlertEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final DateTime timestamp;
  final bool isDismissed;

  const FarmerAlertEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isDismissed = false,
  });

  FarmerAlertEntity copyWith({
    String? id,
    String? title,
    String? message,
    AlertType? type,
    DateTime? timestamp,
    bool? isDismissed,
  }) {
    return FarmerAlertEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }

  @override
  List<Object?> get props => [id, title, message, type, timestamp, isDismissed];
}
