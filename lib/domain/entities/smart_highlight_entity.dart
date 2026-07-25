import 'package:equatable/equatable.dart';

enum HighlightType { money, deadline, document, eligibility }

class SmartHighlightEntity extends Equatable {
  final String text;
  final HighlightType type;

  const SmartHighlightEntity({
    required this.text,
    required this.type,
  });

  @override
  List<Object?> get props => [text, type];
}
