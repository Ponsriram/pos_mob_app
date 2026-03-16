import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../../features/onboarding/view/pages/login_page.dart';

/// Handles drawer navigation across all pages in the app.
void handleDrawerNavigation(
  BuildContext context, {
  required String currentItemId,
  required String targetItemId,
}) {
  if (targetItemId == 'logout') {
    _showLogoutConfirmationDialog(context);
    return;
  }
  if (currentItemId == targetItemId) return;

  if (targetItemId == AppRoutes.dashboard) {
    Navigator.popUntil(context, (route) => route.isFirst);
    return;
  }

  if (!AppRoutes.hasRoute(targetItemId)) {
    debugPrint('No route found for: $targetItemId');
    _showNotImplementedSnackBar(context, targetItemId);
    return;
  }

  final Widget? targetPage = AppRoutes.getPage(targetItemId, context);
  if (targetPage == null) return;

  if (currentItemId == AppRoutes.dashboard) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }
}

void _showNotImplementedSnackBar(BuildContext context, String itemId) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Page "$itemId" is not yet implemented'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void _showLogoutConfirmationDialog(BuildContext context) {
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
            Text(
              'Logout',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to logout?\nYou will need to sign in again.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
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
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
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
