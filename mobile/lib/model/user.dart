// lib/domain/model/user.dart
class User {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final UserRole role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.role = UserRole.unknown,
    this.createdAt,
    this.updatedAt,
  });

  /// Parse JSON -> User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _readId(json['_id']),
      fullName: (json['fullname'] ?? json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: json['phone'] as String?,
      avatarUrl: (json['avatar_url'] ?? json['avatarUrl']) as String?,
      role: UserRoleX.fromString(json['role']),
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
    );
  }

  /// User -> JSON (gửi lên server khi update/create)
  Map<String, dynamic> toJson({bool includeId = false}) {
    final map = <String, dynamic>{
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': role.nameString,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
    if (includeId) map['_id'] = id; // hoặc {'\$oid': id} nếu server yêu cầu
    map.removeWhere((k, v) => v == null);
    return map;
  }

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum vai trò
enum UserRole { admin, user, staff, unknown }

extension UserRoleX on UserRole {
  static UserRole fromString(dynamic v) {
    final s = (v ?? '').toString().toLowerCase();
    switch (s) {
      case 'admin': return UserRole.admin;
      case 'user':  return UserRole.user;
      case 'staff': return UserRole.staff;
      default:      return UserRole.unknown;
    }
  }

  String get nameString {
    switch (this) {
      case UserRole.admin: return 'admin';
      case UserRole.user:  return 'user';
      case UserRole.staff: return 'staff';
      case UserRole.unknown: return 'unknown';
    }
  }
}

/// Helpers cho Mongo-style id/date
String _readId(dynamic raw) {
  if (raw == null) return '';
  if (raw is String) return raw;
  if (raw is Map && raw[r'$oid'] != null) return raw[r'$oid'].toString();
  return raw.toString();
}

DateTime? _readDate(dynamic raw) {
  if (raw == null) return null;
  if (raw is String) return DateTime.tryParse(raw);
  if (raw is Map && raw[r'$date'] != null) {
    return DateTime.tryParse(raw[r'$date'].toString());
  }
  return null;
}
