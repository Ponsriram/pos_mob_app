import 'package:flutter/material.dart';
import '../../../../core/widgets/common_scaffold.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';

/// Menu and Store Actions page
class MenuAndStorePage extends StatefulWidget {
  const MenuAndStorePage({super.key});

  @override
  State<MenuAndStorePage> createState() => _MenuAndStorePageState();
}

class _MenuAndStorePageState extends State<MenuAndStorePage> {
  String _selectedOutlet = 'All Outlets';
  final List<String> _availableOutlets = [
    'All Outlets',
    'Aarthi cake Magic',
    'Ambattur Aarthi sweets and bakery',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CommonScaffold(
      activeItemId: 'thirdparty_config',
      selectedOutlet: _selectedOutlet,
      availableOutlets: _availableOutlets,
      onOutletSelected: (outlet) {
        setState(() {
          _selectedOutlet = outlet;
        });
      },
      onLightBulbTap: () {},
      backgroundColor: colorScheme.surface,
      body: _buildBody(),
      floatingActionButton: ChatSupportButton(
        onTap: () {
          // Handle chat support tap
        },
      ),
    );
  }

  Widget _buildBody() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back arrow and title
        _buildHeader(colorScheme, textTheme),
        // Main content with empty state
        Expanded(
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            child: _buildEmptyState(colorScheme, textTheme),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),

              child: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          // Title on left
          Text(
            'Thirdparty User List',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration with decorative circles
            SizedBox(
              height: 150,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative pink circles
                  Positioned(
                    top: 10,
                    left: 30,
                    child: _buildDecorativeCircle(20),
                  ),
                  Positioned(
                    top: 5,
                    right: 40,
                    child: _buildDecorativeCircle(24),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: _buildDecorativeCircle(16),
                  ),
                  Positioned(
                    top: 40,
                    right: 25,
                    child: _buildDecorativeCircle(18),
                  ),
                  Positioned(
                    bottom: 50,
                    right: 35,
                    child: _buildDecorativeCircle(12),
                  ),
                  // Main icon - document with magnifying glass
                  Center(
                    child: Icon(
                      Icons.find_in_page_outlined,
                      size: 80,
                      color: colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // "Record Not Found" text
            Text(
              'Record Not Found',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFCDD2).withValues(alpha: 0.6),
      ),
    );
  }
}
