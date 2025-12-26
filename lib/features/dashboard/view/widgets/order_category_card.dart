import 'package:flutter/material.dart';
import '../../model/order_category_model.dart';

/// A card widget displaying order category statistics with decorative wave
class OrderCategoryCard extends StatelessWidget {
  final OrderCategoryModel category;
  final VoidCallback? onTap;

  const OrderCategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              _buildContent(context, textTheme, colorScheme),
              _buildWaveDecoration(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            category.title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Subtitle (Orders / KOTS)
          Text(
            category.subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          // Order count
          Text(
            '${category.orderCount}',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          // Estimated Total Amount label
          Text(
            'Estimated Total Amount',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          // Amount
          Text(
            '₹ ${category.estimatedAmount.toStringAsFixed(2)}',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          // Category type label for specific categories
          if (_shouldShowCategoryLabel()) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _getCategoryLabel(),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _shouldShowCategoryLabel() {
    return category.type == OrderCategoryType.yetToBeMarkedReady ||
        category.type == OrderCategoryType.yetToBePickedUp ||
        category.type == OrderCategoryType.yetToBeDelivered;
  }

  String _getCategoryLabel() {
    return 'Delivery';
  }

  Widget _buildWaveDecoration(ColorScheme colorScheme) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: CustomPaint(
        size: const Size(120, 60),
        painter: WavePainter(colors: _getWaveColors(colorScheme)),
      ),
    );
  }

  List<Color> _getWaveColors(ColorScheme colorScheme) {
    // Using theme-based colors with different hues for each category
    switch (category.type) {
      case OrderCategoryType.dineIn:
        return [
          colorScheme.tertiary.withValues(alpha: 0.3),
          colorScheme.tertiary.withValues(alpha: 0.4),
          colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        ];
      case OrderCategoryType.pickUp:
        return [
          colorScheme.secondary.withValues(alpha: 0.3),
          colorScheme.secondary.withValues(alpha: 0.4),
          colorScheme.secondaryContainer.withValues(alpha: 0.3),
        ];
      case OrderCategoryType.delivery:
        return [
          colorScheme.primary.withValues(alpha: 0.3),
          colorScheme.primary.withValues(alpha: 0.4),
          colorScheme.primaryContainer.withValues(alpha: 0.3),
        ];
      case OrderCategoryType.yetToBeMarkedReady:
        return [
          colorScheme.error.withValues(alpha: 0.3),
          colorScheme.error.withValues(alpha: 0.4),
          colorScheme.errorContainer.withValues(alpha: 0.3),
        ];
      case OrderCategoryType.yetToBePickedUp:
        return [
          colorScheme.tertiary.withValues(alpha: 0.3),
          colorScheme.tertiary.withValues(alpha: 0.4),
          colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        ];
      case OrderCategoryType.yetToBeDelivered:
        return [
          colorScheme.tertiary.withValues(alpha: 0.3),
          colorScheme.tertiary.withValues(alpha: 0.4),
          colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        ];
    }
  }
}

/// Custom painter to draw decorative waves
class WavePainter extends CustomPainter {
  final List<Color> colors;

  WavePainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw multiple wave layers
    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      final path = Path();
      final waveOffset = i * 15.0;
      final waveHeight = size.height - waveOffset;

      path.moveTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, waveHeight - 10);

      // Create wave curve
      path.quadraticBezierTo(
        size.width * 0.25,
        waveHeight - 25 - (i * 5),
        size.width * 0.5,
        waveHeight - 15,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        waveHeight - 5 + (i * 3),
        size.width,
        waveHeight - 20,
      );
      path.lineTo(size.width, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
