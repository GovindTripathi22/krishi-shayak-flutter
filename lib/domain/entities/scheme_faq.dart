import 'package:equatable/equatable.dart';

class SchemeFaq extends Equatable {
  final String question;
  final String answer;

  const SchemeFaq({
    required this.question,
    required this.answer,
  });

  factory SchemeFaq.fromJson(Map<String, dynamic> json) {
    return SchemeFaq(
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  @override
  List<Object?> get props => [question, answer];
}
