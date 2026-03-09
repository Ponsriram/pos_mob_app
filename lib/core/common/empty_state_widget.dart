import 'package:flutter/material.dart';

/// Empty state widget with decorative circles and customizable message
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.find_in_page_outlined,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
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
                // Main icon
                Center(
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Message text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
