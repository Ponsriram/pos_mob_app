import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Handles drawer navigation across all pages in the app.
///
/// [context] - The build context
/// [currentItemId] - The ID of the current page
/// [targetItemId] - The ID of the page to navigate to
void handleDrawerNavigation(
  BuildContext context, {
  required String currentItemId,
  required String targetItemId,
}) {
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
