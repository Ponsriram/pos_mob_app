## Navigation System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Navigation Architecture                      │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────┐
│  Drawer Menu Item    │
│  drawer_menu_item_   │
│    model.dart        │
│                      │
│  id: 'running_       │
│       orders'        │
└──────────┬───────────┘
           │
           │ User taps menu item
           │
           ▼
┌──────────────────────┐
│  handleDrawer        │
│  Navigation()        │
│  drawer_navigation.  │
│    dart              │
└──────────┬───────────┘
           │
           │ Looks up route
           │
           ▼
┌──────────────────────┐
│   AppRoutes.routes   │
│   app_routes.dart    │
│                      │
│  'running_orders':   │
│  → RunningOrders     │
│     Page()           │
└──────────┬───────────┘
           │
           │ Returns widget
           │
           ▼
┌──────────────────────┐
│  Navigator.push()    │
│  or                  │
│  Navigator.push      │
│  Replacement()       │
└──────────────────────┘


═══════════════════════════════════════════════════════════════════
                         Navigation Flow
═══════════════════════════════════════════════════════════════════

                         ┌─────────────┐
                         │  Dashboard  │
                         │   (root)    │
                         └──────┬──────┘
                                │
                   ┌────────────┼────────────┐
                   │            │            │
                   ▼            ▼            ▼
            ┌──────────┐ ┌──────────┐ ┌──────────┐
            │ Running  │ │ Online   │ │ Menu &   │
            │ Orders   │ │ Orders   │ │ Store    │
            └─────┬────┘ └─────┬────┘ └─────┬────┘
                  │            │            │
                  └────────────┼────────────┘
                               │
                  Push Replacement between pages
                  (Back button goes to Dashboard)


═══════════════════════════════════════════════════════════════════
                      Adding New Page (3 Steps)
═══════════════════════════════════════════════════════════════════

Step 1: Create Page
───────────────────
lib/features/more/view/pages/my_page.dart

  class MyPage extends StatelessWidget {
    const MyPage({super.key});
    
    @override
    Widget build(BuildContext context) {
      return CommonScaffold(
        activeItemId: 'my_page',  // ← Important!
        ...
      );
    }
  }


Step 2: Register Route
──────────────────────
lib/core/routes/app_routes.dart

  import '../../features/more/view/pages/my_page.dart';
  
  class AppRoutes {
    static const String myPage = 'my_page';  // ← Constant
    
    static final Map<String, WidgetBuilder> routes = {
      myPage: (_) => const MyPage(),  // ← Add here
    };
  }


Step 3: Add Menu Item (Optional)
─────────────────────────────────
lib/features/dashboard/model/drawer_menu_item_model.dart

  const DrawerMenuItemModel(
    id: 'my_page',  // ← Must match route constant
    title: 'My Page',
    icon: Icons.star,
  ),


                         ✓ Done! Navigation works!


═══════════════════════════════════════════════════════════════════
                         Quick Reference
═══════════════════════════════════════════════════════════════════

Current Routes:
  • dashboard               → DashboardPage
  • running_orders          → RunningOrdersPage
  • online_orders           → OnlineOrdersPage
  • menu_store_actions      → MenuAndStorePage
  • thirdparty_config       → MenuAndStorePage (alias)
  • store_status_tracking   → StoreStatusTrackingPage
  • pending_purchases       → PendingPurchasePage
  • notification            → NotificationPage

Navigation Rules:
  ✓ From Dashboard          → Navigator.push()
  ✓ Between Pages           → Navigator.pushReplacement()
  ✓ To Dashboard            → Navigator.popUntil(isFirst)
  ✓ Same Page               → No navigation
  ✓ Unknown Route           → Shows "Not Implemented" snackbar

Key Components:
  📁 app_routes.dart         → Route registry
  📁 drawer_navigation.dart  → Navigation handler
  📁 common_scaffold.dart    → Consistent UI wrapper
  📁 drawer_menu_item_       → Menu structure
     model.dart
