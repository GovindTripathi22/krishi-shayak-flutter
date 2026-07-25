import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.phoneNumber,
    super.name,
    super.state,
    super.district,
    required super.preferredLanguage,
    required super.isLoggedIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      name: json['name'] as String?,
      state: json['state'] as String?,
      district: json['district'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      isLoggedIn: json['isLoggedIn'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'state': state,
      'district': district,
      'preferredLanguage': preferredLanguage,
      'isLoggedIn': isLoggedIn,
    };
  }
}
