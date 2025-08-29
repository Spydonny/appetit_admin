import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String fullName;
  final String? email;
  final String? phone;
  final String dob;
  final String role;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    required this.dob,
    required this.role,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'] ?? 'Өмралинов Сабыржан',
      email: json['email'],
      phone: json['phone'] ?? '',
      dob: json['dob'] ?? '',
      role: json['role'] ?? 'user',
      isEmailVerified: json['is_email_verified'],
      isPhoneVerified: json['is_phone_verified'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()) ,
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "dob": dob,
      "role": role,
      "is_email_verified": isEmailVerified,
      "is_phone_verified": isPhoneVerified,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    dob,
    role,
    isEmailVerified,
    isPhoneVerified,
    createdAt,
    updatedAt,
  ];
}
