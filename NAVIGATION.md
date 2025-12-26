# Navigation Guide

This document explains the navigation system in this Flutter app.

## Architecture

The app uses a **centralized route management** system for clean, scalable navigation.

### Key Files

1. **`lib/core/routes/app_routes.dart`** - Central route registry
2. **`lib/core/widgets/drawer_navigation.dart`** - Drawer navigation handler
3. **`lib/features/dashboard/model/drawer_menu_item_model.dart`** - Drawer menu structure

---

## How Navigation Works

### 1. Define Routes

All routes are defined in `app_routes.dart`:

```dart
class AppRoutes {
  static const String myNewPage = 'my_new_page';
  
  static final Map<String, WidgetBuilder> routes = {
    myNewPage: (_) => const MyNewPage(),
  };
}
```

### 2. Add Menu Item

Add the menu item in `drawer_menu_item_model.dart`:

```dart
const DrawerMenuItemModel(
  id: 'my_new_page',  // Must match route name in AppRoutes
  title: 'My New Page',
  icon: Icons.star_outlined,
),
```

### 3. Navigation Happens Automatically

The `handleDrawerNavigation` function automatically:
- Checks if route exists
- Shows "not implemented" message if page doesn't exist
- Handles proper navigation (push/pushReplacement) based on context
- Pops to root when navigating to dashboard

---

## Adding a New Page

### Step-by-Step Example

Let's add a "Reports" page:

#### 1. Create the page file
**File:** `lib/features/more/view/pages/reports_page.dart`

```dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/common_scaffold.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      activeItemId: 'reports',  // Must match route name
      selectedOutlet: 'All Outlets',
      availableOutlets: const ['All Outlets'],
      onOutletSelected: (_) {},
      body: const Center(
        child: Text('Reports Page'),
      ),
    );
  }
}
```

#### 2. Register the route
**File:** `lib/core/routes/app_routes.dart`

```dart
// Add import
import '../../features/more/view/pages/reports_page.dart';

class AppRoutes {
  // Add constant
  static const String reports = 'reports';
  
  // Add to routes map
  static final Map<String, WidgetBuilder> routes = {
    // ... existing routes
    reports: (_) => const ReportsPage(),
  };
}
```

#### 3. Add menu item (optional)
**File:** `lib/features/dashboard/model/drawer_menu_item_model.dart`

```dart
const DrawerMenuItemModel(
  id: 'reports',  // Must match route constant
  title: 'Reports',
  icon: Icons.bar_chart_outlined,
),
```

**That's it!** Navigation will work automatically. ✅

---

## Current Available Routes

| Route Name | Page | Status |
|------------|------|--------|
| `dashboard` | Dashboard | ✅ |
| `running_orders` | Running Orders | ✅ |
| `online_orders` | Online Orders | ✅ |
| `menu_store_actions` | Menu & Store | ✅ |
| `thirdparty_config` | Menu & Store (alias) | ✅ |
| `store_status_tracking` | Store Status | ✅ |
| `pending_purchases` | Pending Purchases | ✅ |
| `notification` | Notifications | ✅ |

---

## Navigation Behavior

### From Dashboard
- Uses `Navigator.push()` - allows back navigation to dashboard
- Example: Dashboard → Running Orders (can press back to return)

### Between Non-Dashboard Pages
- Uses `Navigator.pushReplacement()` - replaces current page
- Example: Running Orders → Online Orders (back button goes to dashboard)

### To Dashboard
- Uses `Navigator.popUntil()` - returns to root
- Always returns to the initial dashboard screen

---

## Troubleshooting

### ❌ "No route found" message appears

**Cause:** The menu item ID doesn't match any route in `AppRoutes`.

**Fix:** 
1. Check the `id` in `drawer_menu_item_model.dart`
2. Ensure matching constant exists in `AppRoutes`
3. Verify the route is added to the `routes` map

### ❌ Navigation doesn't work

**Checklist:**
- [ ] Route constant defined in `AppRoutes`
- [ ] Route added to `routes` map
- [ ] Page widget imported in `app_routes.dart`
- [ ] Menu item `id` matches route constant exactly

### ❌ Page shows but "not implemented" still appears

**Cause:** Route exists but returns `null` widget.

**Fix:** Ensure the `WidgetBuilder` in routes map returns a valid widget.

---

## Best Practices

### ✅ DO

- Use `AppRoutes` constants instead of hardcoded strings
- Match menu item IDs exactly to route names
- Use `CommonScaffold` for consistent navigation experience
- Set correct `activeItemId` in each page

### ❌ DON'T

- Hardcode route strings directly in navigation calls
- Create multiple navigation systems
- Modify `drawer_navigation.dart` for each new page
- Use different navigation patterns for different features

---

## Future Enhancements

Consider these improvements as the app grows:

1. **Named Routes**: Convert to Flutter's named route system
   ```dart
   Navigator.pushNamed(context, AppRoutes.reports);
   ```

2. **Route Guards**: Add authentication checks
   ```dart
   static bool canAccess(String route, User? user) { ... }
   ```

3. **Deep Linking**: Support URL-based navigation
   ```dart
   /dashboard/reports?outlet=main
   ```

4. **Route Transitions**: Custom page transitions
   ```dart
   PageRouteBuilder with custom animation
   ```

---

## Quick Reference

### Navigate to a page programmatically

```dart
handleDrawerNavigation(
  context,
  currentItemId: 'current_page',
  targetItemId: AppRoutes.targetPage,
);
```

### Check if route exists

```dart
if (AppRoutes.hasRoute('some_route')) {
  // Route exists
}
```

### Get page widget directly

```dart
final widget = AppRoutes.getPage('reports', context);
```

---

**Last Updated:** December 26, 2025
