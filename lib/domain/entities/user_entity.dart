import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? state;
  final String? district;
  final String preferredLanguage;
  final bool isLoggedIn;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.state,
    this.district,
    required this.preferredLanguage,
    required this.isLoggedIn,
  });

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        name,
        state,
        district,
        preferredLanguage,
        isLoggedIn,
      ];
}
