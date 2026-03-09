import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../viewmodel/user_info_viewmodel.dart';
import '../widgets/edit_profile/edit_user_info_dialog.dart';
import '../widgets/edit_profile/user_logs_dialog.dart';

/// User Info page displaying user profile information
class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(userInfoViewModelProvider);

    // Listen for errors to show snackbar
    ref.listen(userInfoViewModelProvider, (prev, next) {
      if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: colorScheme.error,
          ),
        );
        ref.read(userInfoViewModelProvider.notifier).clearError();
      }
    });

    return CommonScaffold(
      activeItemId: 'user_info',
      selectedOutlet: state.selectedOutlet,
      availableOutlets: state.availableOutlets,
      onOutletSelected: ref
          .read(userInfoViewModelProvider.notifier)
          .setSelectedOutlet,
      onLightBulbTap: () {},
      backgroundColor: colorScheme.surface,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back button, title, and actions
        _buildHeader(colorScheme, textTheme),
        // Divider
        Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2)),
        // Main content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfoSection(colorScheme, textTheme),
                const SizedBox(height: 24),
                _build2FASection(colorScheme, textTheme),
                const SizedBox(height: 24),
                _buildChangePasswordSection(colorScheme, textTheme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
          // Title
          Text(
            'User Info',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          // View Logs button
          OutlinedButton(
            onPressed: _showLogsDialog,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              side: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'View Logs',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Edit button
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: _showEditDialog,
              icon: Icon(
                Icons.edit_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(ColorScheme colorScheme, TextTheme textTheme) {
    final state = ref.watch(userInfoViewModelProvider);
    final userInfo = state.userInfo;

    if (userInfo == null) {
      return const Center(child: Text('Loading user info...'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name row
        _buildInfoRow('Name', userInfo.name, colorScheme, textTheme),
        const SizedBox(height: 16),
        // Email row
        _buildInfoRow('Email', userInfo.email, colorScheme, textTheme),
        const SizedBox(height: 16),
        // Mobile Numbers row
        _buildInfoRow(
          'Mobile Numbers',
          userInfo.mobileNumbers.isNotEmpty
              ? userInfo.mobileNumbers.map((m) => m.fullNumber).join(', ')
              : 'Not provided',
          colorScheme,
          textTheme,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _build2FASection(ColorScheme colorScheme, TextTheme textTheme) {
    final state = ref.watch(userInfoViewModelProvider);
    final userInfo = state.userInfo;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          // Toggle
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: userInfo?.is2FAEnabled ?? false,
              onChanged: (value) =>
                  ref.read(userInfoViewModelProvider.notifier).toggle2FA(value),
              activeTrackColor: colorScheme.primary,
              activeThumbColor: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 12),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2FA For Login',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Keep your account safe with 2FA.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordSection(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lock icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.lock_outline, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Want To Change Your Password?',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Choose a strong password you haven't used before.",
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _showChangePasswordDialog,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  side: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Change Password',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogsDialog() {
    final state = ref.read(userInfoViewModelProvider);
    showUserLogsDialog(context: context, logs: state.logs, isLoading: false);
  }

  void _showEditDialog() {
    final state = ref.read(userInfoViewModelProvider);
    final userInfo = state.userInfo;

    if (userInfo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User info not loaded yet')));
      return;
    }

    showEditUserInfoDialog(
      context: context,
      userInfo: userInfo,
      onSave: (name, email, mobileNumbers) {
        ref
            .read(userInfoViewModelProvider.notifier)
            .updateUserInfo(
              name: name,
              email: email,
              mobileNumbers: mobileNumbers,
            );
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User info updated successfully')),
        );
      },
      onChangeEmail: () {
        // TODO: Implement change email flow
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Change email feature coming soon')),
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Change Password',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setDialogState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }

                ref
                    .read(userInfoViewModelProvider.notifier)
                    .changePassword(
                      currentPasswordController.text,
                      newPasswordController.text,
                    );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}
