import 'package:flutter/material.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';

class ThirdPartyConfigPage extends StatefulWidget {
  const ThirdPartyConfigPage({super.key});

  @override
  State<ThirdPartyConfigPage> createState() =>
      _ThirdPartyConfigPageState();
}

class _ThirdPartyConfigPageState extends State<ThirdPartyConfigPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CommonScaffold(
      activeItemId: 'thirdparty_config',
      selectedOutlet: 'All Outlets',
      availableOutlets: const ['All Outlets'],
      onOutletSelected: (_) {},
      onLightBulbTap: () {},
      backgroundColor: colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and back button
          _buildHeader(context, colorScheme, textTheme),
          // Main content
          Expanded(
            child: Container(
              color: colorScheme.surfaceContainerLowest,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.lightbulb_outline,
                                    color: Color(0xFF2196F3),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Manage Third-Party Configurations',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildFeatureItem(
                              'You can easily',
                              'manage all third-party configurations',
                              'associated with a specific owner email address. This allows you to:',
                            ),
                            const SizedBox(height: 16),
                            _buildFeatureItem(
                              'View all third-parties',
                              '',
                              'linked to that email in one centralized place.',
                            ),
                            const SizedBox(height: 16),
                            _buildFeatureItem(
                              'Apply bulk changes',
                              '',
                              'to the third-party settings for all restaurants under that owner\'s email ID.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Illustration section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          // Puzzle illustration - 4 pieces connecting at center
                          Center(
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: Stack(
                                children: [
                                  // Top-left piece
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: _buildPuzzlePiece(
                                      const Color(0xFF424242),
                                      hasRightKnob: true,
                                      hasBottomKnob: true,
                                    ),
                                  ),
                                  // Top-right piece
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: _buildPuzzlePiece(
                                      const Color(0xFFE0E0E0),
                                      hasLeftSocket: true,
                                      hasBottomKnob: true,
                                    ),
                                  ),
                                  // Bottom-left piece
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: _buildPuzzlePiece(
                                      const Color(0xFF616161),
                                      hasTopSocket: true,
                                      hasRightKnob: true,
                                    ),
                                  ),
                                  // Bottom-right piece
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: _buildPuzzlePiece(
                                      const Color(0xFF9E9E9E),
                                      hasLeftSocket: true,
                                      hasTopSocket: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Description text
                          const Text(
                            'Integrating With Multiple Online Order Integrators And Manage Them Seamlessly. That\'s How 95% Of The Petpooja Users Optimise On Their Operations Related Efforts.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ChatSupportButton(
        onTap: () {
          // Handle chat support tap
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
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
            'Online Integrations',
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

  Widget _buildFeatureItem(
    String boldText,
    String boldText2,
    String normalText,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: const Icon(Icons.check, color: Color(0xFF4CAF50), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: boldText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (boldText2.isNotEmpty) ...[
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: boldText2,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
                const TextSpan(text: ' '),
                TextSpan(text: normalText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPuzzlePiece(
    Color color, {
    bool hasTopKnob = false,
    bool hasRightKnob = false,
    bool hasBottomKnob = false,
    bool hasLeftKnob = false,
    bool hasTopSocket = false,
    bool hasRightSocket = false,
    bool hasBottomSocket = false,
    bool hasLeftSocket = false,
  }) {
    return CustomPaint(
      size: const Size(60, 60),
      painter: PuzzlePiecePainter(
        color: color,
        hasTopKnob: hasTopKnob,
        hasRightKnob: hasRightKnob,
        hasBottomKnob: hasBottomKnob,
        hasLeftKnob: hasLeftKnob,
        hasTopSocket: hasTopSocket,
        hasRightSocket: hasRightSocket,
        hasBottomSocket: hasBottomSocket,
        hasLeftSocket: hasLeftSocket,
      ),
    );
  }
}

class PuzzlePiecePainter extends CustomPainter {
  final Color color;
  final bool hasTopKnob;
  final bool hasRightKnob;
  final bool hasBottomKnob;
  final bool hasLeftKnob;
  final bool hasTopSocket;
  final bool hasRightSocket;
  final bool hasBottomSocket;
  final bool hasLeftSocket;

  PuzzlePiecePainter({
    required this.color,
    this.hasTopKnob = false,
    this.hasRightKnob = false,
    this.hasBottomKnob = false,
    this.hasLeftKnob = false,
    this.hasTopSocket = false,
    this.hasRightSocket = false,
    this.hasBottomSocket = false,
    this.hasLeftSocket = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final knobRadius = 8.0;
    final knobDepth = 8.0;
    final cornerRadius = 6.0;

    // Start from top-left (after corner)
    path.moveTo(cornerRadius, 0);

    // Top edge
    if (hasTopKnob) {
      path.lineTo(size.width / 2 - knobRadius, 0);
      path.arcToPoint(
        Offset(size.width / 2, -knobDepth),
        radius: Radius.circular(knobRadius),
        clockwise: false,
      );
      path.arcToPoint(
        Offset(size.width / 2 + knobRadius, 0),
        radius: Radius.circular(knobRadius),
        clockwise: false,
      );
      path.lineTo(size.width - cornerRadius, 0);
    } else if (hasTopSocket) {
      path.lineTo(size.width / 2 - knobRadius, 0);
      path.arcToPoint(
        Offset(size.width / 2, knobDepth),
        radius: Radius.circular(knobRadius),
        clockwise: true,
      );
      path.arcToPoint(
        Offset(size.width / 2 + knobRadius, 0),
        radius: Radius.circular(knobRadius),
        clockwise: true,
      );
      path.lineTo(size.width - cornerRadius, 0);
    } else {
      path.lineTo(size.width - cornerRadius, 0);
    }

    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right edge
    if (hasRightKnob) {
      path.lineTo(size.width, size.height / 2 - knobRadius);
      path.arcToPoint(
        Offset(size.width + knobDepth, size.height / 2),
        radius: Radius.circular(knobRadius),
        clockwise: false,
      );
      path.arcToPoint(
        Offset(size.width, size.height / 2 + knobRadius),
        radius: Radius.circular(knobRadius),
        clockwise: false,
      );
      path.lineTo(size.width, size.height - cornerRadius);
    } else if (hasRightSocket) {
      path.lineTo(size.width, size.height / 2 - knobRadius);
      path.arcToPoint(
        Offset(size.width - knobDepth, size.height / 2),
        radius: Radius.circular(knobRadius),
        clockwise: true,
      );
      path.arcToPoint(
        Offset(size.width, size.height / 2 + knobRadius),
        radius: Radius.circular(knobRadius),
        clockwise: true,
      );
      path.lineTo(size.width, size.height - cornerRadius);
    } else {
      path.lineTo(size.width, size.height - cornerRadius);
    }

    // Bottom-right corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - cornerRadius,
      size.height,
    );

    // Bottom edge
    if (hasBottomKnob) {
      path.lineTo(size.width / 2 + knobRadius, size.height);
      path.arcToPoint(
        Offset(size.width / 2, size.height + knobDepth),
        radius: Radius.circular(knobRadius),
        clockwise: false,
      );
      path.arcToPoint(
        Offset(size.width / 2 - knobRadius, size.height),
        radius: Radius.circular(knobRadius),
        clockwise: false,
      );
      path.lineTo(cornerRadius, size.height);
    } else if (hasBottomSocket) {
      path.lineTo(size.width / 2 + knobRadius, size.height);
      path.arcToPoint(
        Offset(size.width / 2, size.height - knobDepth),
        radius: Radius.circular(knobRadius),
        clockwise: true,
      );
      path.arcToPoint(
        Offset(size.width / 2 - knobRadius, size.height),
        radius: Radius.circular(knobRadius),
        clockwise: true,
      );
      path.lineTo(cornerRadius, size.height);
    } else {
      path.lineTo(cornerRadius, size.height);
    }

    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // Left edge
    if (hasLeftKnob) {
      path.lineTo(0, size.height / 2 + knobRadius);
      path.arcToPoint(
        Offset(-knobDepth, size.height / 2),
        radius: Radius.circular(knobRadius),
        clockwise: false,
      );
      path.arcToPoint(
        Offset(0, size.height / 2 - knobRadius),
        radius: Radius.circular(knobRadius),
        clockwise: false,
      );
      path.lineTo(0, cornerRadius);
    } else if (hasLeftSocket) {
      path.lineTo(0, size.height / 2 + knobRadius);
      path.arcToPoint(
        Offset(knobDepth, size.height / 2),
        radius: Radius.circular(knobRadius),
        clockwise: true,
      );
      path.arcToPoint(
        Offset(0, size.height / 2 - knobRadius),
        radius: Radius.circular(knobRadius),
        clockwise: true,
      );
      path.lineTo(0, cornerRadius);
    } else {
      path.lineTo(0, cornerRadius);
    }

    // Top-left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

