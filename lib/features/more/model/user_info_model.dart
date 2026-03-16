/// Stub model for user profile information
class UserInfoModel {
  final String name;
  final String email;
  final bool isEmailVerified;
  final bool is2FAEnabled;
  final List<MobileNumber> mobileNumbers;

  const UserInfoModel({
    required this.name,
    required this.email,
    this.isEmailVerified = false,
    this.is2FAEnabled = false,
    this.mobileNumbers = const [],
  });
}

/// Stub model for a linked mobile number
class MobileNumber {
  final String id;
  final String countryCode;
  final String number;
  final bool isVerified;

  const MobileNumber({
    required this.id,
    required this.countryCode,
    required this.number,
    this.isVerified = false,
  });

  String get fullNumber => '$countryCode $number';
}

/// Stub model for a user activity log entry
class UserLogEntry {
  final String changes;
  final String doneByName;
  final String doneByEmail;
  final String browser;
  final String ipAddress;
  final DateTime timestamp;

  const UserLogEntry({
    required this.changes,
    required this.doneByName,
    required this.doneByEmail,
    required this.browser,
    required this.ipAddress,
    required this.timestamp,
  });
}
