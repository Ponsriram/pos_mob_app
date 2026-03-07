import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/models/app_user.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';

/// Profile model representing user profile data.
/// Since the backend has no /users/me endpoint, profile is derived from
/// the stored AppUser (populated during login/register).
class ProfileModel {
  final String id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? role;
  final bool is2FAEnabled;
  final DateTime? createdAt;

  const ProfileModel({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.role,
    this.is2FAEnabled = false,
    this.createdAt,
  });

  factory ProfileModel.fromAppUser(AppUser user) {
    return ProfileModel(
      id: user.id,
      fullName: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      createdAt: user.createdAt,
    );
  }

  /// Check if user is owner or admin
  bool get isOwnerOrAdmin =>
      role?.toLowerCase() == 'owner' || role?.toLowerCase() == 'admin';
}

/// Repository for profile operations
abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile();
}

/// Implementation that reads from locally stored AppUser
class ProfileRepositoryImpl implements ProfileRepository {
  final LocalStorageService _localStorage;

  ProfileRepositoryImpl(this._localStorage);

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    final user = _localStorage.currentUser;
    if (user == null) {
      return left(const AuthFailure(message: 'User not authenticated'));
    }
    return right(ProfileModel.fromAppUser(user));
  }
}
