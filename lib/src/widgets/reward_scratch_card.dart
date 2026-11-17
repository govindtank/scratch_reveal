import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../scratch_config.dart';
import '../scratch_reveal_widget.dart';

/// A turnkey, gamified reward scratch card for Fintech, E-Commerce, and Loyalty apps
/// inspired by Google Pay, CRED, and PhonePe.
///
/// Bundles metallic foil covers, auto-reveal thresholds, celebratory confetti bursts,
/// and voucher code copy actions.
class RewardScratchCard extends StatefulWidget {
  const RewardScratchCard({
    super.key,
    required this.rewardTitle,
    required this.rewardSubtitle,
    this.couponCode,
    this.coverTitle = 'Scratch & Win',
    this.coverSubtitle = 'Scratch here to reveal your surprise cashback',
    this.brandLogo,
    this.expiryText,
    this.onClaimPressed,
    this.claimButtonText = 'Claim Reward',
    this.threshold = 0.45,
    this.enableConfetti = true,
    this.foilGradient,
    this.cardWidth = 320,
    this.cardHeight = 360,
  });

  /// Primary reward text (e.g. `₹ 250 Cashback` or `Flat 20% OFF`).
  final String rewardTitle;

  /// Secondary reward detail (e.g. `On your next booking at MakeMyTrip`).
  final String rewardSubtitle;

  /// Optional promo/coupon code (e.g. `MMT250`).
  final String? couponCode;

  /// Title shown on the un-scratched cover foil.
  final String coverTitle;

  /// Subtitle shown on the un-scratched cover foil.
  final String coverSubtitle;

  /// Optional brand icon or logo widget.
  final Widget? brandLogo;

  /// Optional expiry notice (e.g. `Expires in 48h`).
  final String? expiryText;

  /// Action callback when user taps the claim button.
  final VoidCallback? onClaimPressed;

  /// Label for the claim action button.
  final String claimButtonText;

  /// Percentage of foil scratched before auto-revealing and popping confetti (0.0 to 1.0).
  final double threshold;

  /// Whether to burst celebratory confetti particles when unlocked.
  final bool enableConfetti;

  /// Custom gradient for the metallic foil.
  final Gradient? foilGradient;

  /// Width of the scratch card.
  final double cardWidth;

  /// Height of the scratch card.
  final double cardHeight;

  @override
  State<RewardScratchCard> createState() => _RewardScratchCardState();
}

class _RewardScratchCardState extends State<RewardScratchCard>
    with SingleTickerProviderStateMixin {
  bool _isUnlocked = false;
  bool _copiedCode = false;
  late AnimationController _confettiController;
  final List<_ConfettiParticle> _confettiParticles = [];

  static const _defaultFoilGradient = LinearGradient(
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFD97706),
      Color(0xFFB45309),
      Color(0xFFFBBF24),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..addListener(() {
        if (_isUnlocked) {
          setState(() {
            for (final p in _confettiParticles) {
              p.update();
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerCelebration() {
    HapticFeedback.heavyImpact();
    setState(() => _isUnlocked = true);

    if (widget.enableConfetti) {
      _confettiParticles.clear();
      final rnd = math.Random();
      final colors = [
        const Color(0xFFF59E0B),
        const Color(0xFF10B981),
        const Color(0xFF38BDF8),
        const Color(0xFFEC4899),
        const Color(0xFFA855F7),
      ];

      for (int i = 0; i < 45; i++) {
        _confettiParticles.add(
          _ConfettiParticle(
            x: widget.cardWidth / 2,
            y: widget.cardHeight / 2,
            vx: (rnd.nextDouble() - 0.5) * 12,
            vy: -rnd.nextDouble() * 12 - 4,
            color: colors[rnd.nextInt(colors.length)],
            size: rnd.nextDouble() * 7 + 4,
            rotation: rnd.nextDouble() * math.pi * 2,
          ),
        );
      }
      _confettiController.forward(from: 0.0);
    }
  }

  Future<void> _copyCode() async {
    if (widget.couponCode == null) return;
    await Clipboard.setData(ClipboardData(text: widget.couponCode!));
    HapticFeedback.lightImpact();
    setState(() => _copiedCode = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedCode = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.cardWidth,
        height: widget.cardHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // The Main ScratchReveal Widget
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ScratchReveal(
                threshold: widget.threshold,
                brushShape: ScratchBrushShape.coin,
                brushSize: 42.0,
                coverGradient: widget.foilGradient ?? _defaultFoilGradient,
                onThresholdReached: _triggerCelebration,
                cover: _buildCoverFoil(),
                revealedChild: _buildRevealedReward(),
              ),
            ),

            // Confetti Overlay
            if (_isUnlocked && widget.enableConfetti) ...[
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _ConfettiPainter(_confettiParticles),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCoverFoil() {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.foilGradient ?? _defaultFoilGradient,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withAlpha(40),
              border: Border.all(color: Colors.white.withAlpha(60), width: 2),
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              size: 44,
              color: Color(0xFFFEF08A),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            widget.coverTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.coverSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(200),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(50)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded, size: 14, color: Colors.white70),
                SizedBox(width: 6),
                Text(
                  'SCRATCH TO REVEAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedReward() {
    return Container(
      color: const Color(0xFF111827),
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.brandLogo != null) ...[
            widget.brandLogo!,
            const SizedBox(height: 12),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withAlpha(30),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                size: 36,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            widget.rewardTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.rewardSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 18),

          // Coupon Code Box
          if (widget.couponCode != null) ...[
            InkWell(
              onTap: _copyCode,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF030712),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _copiedCode
                        ? const Color(0xFF10B981)
                        : const Color(0xFF374151),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.couponCode!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF67E8F9),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      _copiedCode ? Icons.check_circle : Icons.copy_rounded,
                      size: 16,
                      color:
                          _copiedCode ? const Color(0xFF10B981) : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          if (widget.expiryText != null) ...[
            Text(
              widget.expiryText!,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.withAlpha(150),
              ),
            ),
            const SizedBox(height: 14),
          ],

          if (widget.onClaimPressed != null) ...[
            ElevatedButton(
              onPressed: widget.onClaimPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.claimButtonText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConfettiParticle {
  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
  });

  double x;
  double y;
  double vx;
  double vy;
  final Color color;
  final double size;
  double rotation;

  void update() {
    x += vx;
    y += vy;
    vy += 0.45; // Gravity
    vx *= 0.98; // Drag
    rotation += 0.12;
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.particles);
  final List<_ConfettiParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = p.color;
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation);
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: p.size, height: p.size * 0.5),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
