import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/app_routes.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../features/onboarding/view/pages/login_page.dart';

/// Handles drawer navigation across all pages in the app.
///
/// [context] - The build context
/// [currentItemId] - The ID of the current page
/// [targetItemId] - The ID of the page to navigate to
/// [ref] - WidgetRef for accessing providers (optional, required for logout)
void handleDrawerNavigation(
  BuildContext context, {
  required String currentItemId,
  required String targetItemId,
  WidgetRef? ref,
}) {
  // Handle logout separately
  if (targetItemId == 'logout') {
    _showLogoutConfirmationDialog(context, ref);
    return;
  }
  // Don't navigate if already on the target page
  if (currentItemId == targetItemId) return;

  // If navigating to dashboard, just pop back to root
  if (targetItemId == AppRoutes.dashboard) {
    Navigator.popUntil(context, (route) => route.isFirst);
    return;
  }

  // Check if the route exists
  if (!AppRoutes.hasRoute(targetItemId)) {
    debugPrint('⚠️ No route found for: $targetItemId');
    _showNotImplementedSnackBar(context, targetItemId);
    return;
  }

  // Get the target page widget
  final Widget? targetPage = AppRoutes.getPage(targetItemId, context);
  if (targetPage == null) return;

  // If current page is dashboard, use push
  // Otherwise use pushReplacement to avoid building up the stack
  if (currentItemId == AppRoutes.dashboard) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }
}

/// Show a snackbar for unimplemented pages
void _showNotImplementedSnackBar(BuildContext context, String itemId) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Page "$itemId" is not yet implemented'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Shows a confirmation dialog for logout
void _showLogoutConfirmationDialog(BuildContext context, WidgetRef? ref) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  showDialog(
    context: context,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.5),
    builder: (dialogContext) => Dialog(
      backgroundColor: colorScheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              'Logout',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              'Are you sure you want to logout?\nYou will need to sign in again.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(color: colorScheme.outline, width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await _performLogout(context, ref);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Performs the actual logout operation
Future<void> _performLogout(BuildContext context, WidgetRef? ref) async {
  if (ref == null) {
    debugPrint('⚠️ WidgetRef is required for logout');
    return;
  }

  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.5),
    builder: (ctx) => PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Logging out...',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  try {
    final success = await ref.read(authViewModelProvider.notifier).signOut();

    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog

      if (success) {
        // Navigate to login page and clear all routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      } else {
        // Show error message
        final authState = ref.read(authViewModelProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.onError),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    authState.error ?? 'Failed to logout',
                    style: TextStyle(color: colorScheme.onError),
                  ),
                ),
              ],
            ),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.onError),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: colorScheme.onError),
                ),
              ),
            ],
          ),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}
