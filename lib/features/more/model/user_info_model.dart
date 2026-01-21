/// Model class representing user information
class UserInfoModel {
  final String id;
  final String name;
  final String email;
  final bool isEmailVerified;
  final List<MobileNumber> mobileNumbers;
  final bool is2FAEnabled;
  final DateTime? createdAt;
  final String? createdBy;

  UserInfoModel({
    required this.id,
    required this.name,
    required this.email,
    this.isEmailVerified = false,
    this.mobileNumbers = const [],
    this.is2FAEnabled = false,
    this.createdAt,
    this.createdBy,
  });

  UserInfoModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isEmailVerified,
    List<MobileNumber>? mobileNumbers,
    bool? is2FAEnabled,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return UserInfoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      mobileNumbers: mobileNumbers ?? this.mobileNumbers,
      is2FAEnabled: is2FAEnabled ?? this.is2FAEnabled,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

/// Model class representing a mobile number
class MobileNumber {
  final String id;
  final String countryCode;
  final String number;
  final bool isVerified;

  MobileNumber({
    required this.id,
    required this.countryCode,
    required this.number,
    this.isVerified = false,
  });

  String get fullNumber => '$countryCode $number';

  MobileNumber copyWith({
    String? id,
    String? countryCode,
    String? number,
    bool? isVerified,
  }) {
    return MobileNumber(
      id: id ?? this.id,
      countryCode: countryCode ?? this.countryCode,
      number: number ?? this.number,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

/// Model class representing a user activity log entry
class UserLogEntry {
  final String id;
  final String changes;
  final String doneByName;
  final String doneByEmail;
  final String browser;
  final String ipAddress;
  final DateTime timestamp;

  UserLogEntry({
    required this.id,
    required this.changes,
    required this.doneByName,
    required this.doneByEmail,
    required this.browser,
    required this.ipAddress,
    required this.timestamp,
  });
}
