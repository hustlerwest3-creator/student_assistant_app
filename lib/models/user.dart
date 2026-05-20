// Student Assistant Application - TPG316C Assignment
// Group Members:
// 221021198 - AM MATONA
// 221021493 - M MAKHASANE
// 222072446 - PN MONGWE
// 222071364 - N TLALI
// 222071216 - IKF NDLOVU
// Date: May 2026

class UserProfile {
  final String id;
  final String fullName;
  final int yearOfStudy;
  final String role;
  final String? bio;
  final String? avatarUrl;
  final String? phoneNumber;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.yearOfStudy,
    required this.role,
    this.bio,
    this.avatarUrl,
    this.phoneNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['full_name'],
      yearOfStudy: json['year_of_study'],
      role: json['role'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'year_of_study': yearOfStudy,
      'role': role,
      'bio': bio,
      'avatar_url': avatarUrl,
      'phone_number': phoneNumber,
    };
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    int? yearOfStudy,
    String? role,
    String? bio,
    String? avatarUrl,
    String? phoneNumber,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
