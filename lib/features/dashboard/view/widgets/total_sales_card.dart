import 'package:flutter/material.dart';

/// A card displaying total sales with gradient background and decorative elements
class TotalSalesCard extends StatelessWidget {
  final String totalSales;
  final int totalOutlets;
  final int totalOrders;
  final VoidCallback? onChartTap;
  final VoidCallback? onMoreTap;

  const TotalSalesCard({
    super.key,
    required this.totalSales,
    required this.totalOutlets,
    required this.totalOrders,
    this.onChartTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [_buildWaveDecoration(context), _buildContent(context)],
      ),
    );
  }

  Widget _buildWaveDecoration(BuildContext context) {
    return Positioned(
      top: -20,
      left: -20,
      child: CustomPaint(
        size: const Size(120, 80),
        painter: _WavePainter(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: 20),
        _buildSalesInfo(context),
        const SizedBox(height: 16),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onChartTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.show_chart, color: colorScheme.primary, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onMoreTap,
          child: Icon(
            Icons.more_vert,
            color: colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSalesInfo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          'Total Sales',
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
          totalSales,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Of $totalOutlets Outlets',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.info_outline, size: 14, color: colorScheme.outline),
        const SizedBox(width: 4),
        Text(
          'Total Sales of $totalOrders Orders',
          style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// Custom painter for the decorative wave pattern
class _WavePainter extends CustomPainter {
  final BuildContext context;

  _WavePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final colorScheme = Theme.of(context).colorScheme;
    final paint = Paint()
      ..color = colorScheme.primary.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.8,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave with lighter opacity
    final paint2 = Paint()
      ..color = colorScheme.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.4,
      size.width * 0.6,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.9,
      size.width,
      size.height * 0.5,
    );
    path2.lineTo(size.width, 0);
    path2.lineTo(0, 0);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
