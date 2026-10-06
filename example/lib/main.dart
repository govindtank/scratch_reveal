import 'package:flutter/material.dart';
import 'package:scratch_reveal/scratch_reveal.dart';

void main() {
  runApp(const ScratchDemoApp());
}

class ScratchDemoApp extends StatelessWidget {
  const ScratchDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realistic Scratch Reveal Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF090A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF59E0B),
          surface: Color(0xFF11131A),
        ),
      ),
      home: const ScratchDemoScreen(),
    );
  }
}

class ScratchDemoScreen extends StatefulWidget {
  const ScratchDemoScreen({super.key});

  @override
  State<ScratchDemoScreen> createState() => _ScratchDemoScreenState();
}

class _ScratchDemoScreenState extends State<ScratchDemoScreen> {
  final GlobalKey<ScratchRevealState> _scratchKey =
      GlobalKey<ScratchRevealState>();
  double _progress = 0.0;
  final double _brushSize = 42.0;
  final double _threshold = 0.60;
  bool _isUnlocked = false;
  bool _particlesEnabled = true;
  ScratchBrushShape _selectedBrush = ScratchBrushShape.coin;
  bool _isGoldCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realistic Scratch Reveal Demo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        elevation: 0,
        backgroundColor: const Color(0xFF090A0F),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Scratch Card
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: (_isGoldCard
                                ? const Color(0xFFFFD700)
                                : const Color(0xFF00D4FF))
                            .withValues(alpha: 0.22),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: ScratchReveal(
                      key: _scratchKey,
                      brushSize: _brushSize,
                      brushShape: _selectedBrush,
                      showFoilParticles: _particlesEnabled,
                      threshold: _threshold,
                      coverGradient: _isGoldCard
                          ? ScratchFoilPreset.gold().gradient
                          : ScratchFoilPreset.silver().gradient,
                      cover: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _selectedBrush == ScratchBrushShape.coin
                                  ? Icons.monetization_on_outlined
                                  : Icons.gesture,
                              size: 40,
                              color: _isGoldCard
                                  ? const Color(0xFF78350F)
                                  : const Color(0xFF334155),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'SCRATCH WITH COIN / FINGER',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: _isGoldCard
                                    ? const Color(0xFF78350F)
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Real foil shavings & micro-grooves',
                              style: TextStyle(
                                fontSize: 11,
                                color: _isGoldCard
                                    ? const Color(0xFF92400E)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                      revealedChild: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF065F46),
                              Color(0xFF047857),
                              Color(0xFF059669),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emoji_events_rounded,
                                size: 54, color: Color(0xFFFDE047)),
                            SizedBox(height: 10),
                            Text(
                              '🎉 YOU WON \$5,000!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Promo Code: REVEAL2026',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF86EFAC),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      onProgressUpdate: (progress) {
                        setState(() {
                          _progress = progress;
                        });
                      },
                      onThresholdReached: () {
                        setState(() {
                          _isUnlocked = true;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Live Progress Indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11131A),
                    border: Border.all(color: const Color(0xFF1E222D)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Scratch Progress',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70)),
                          Text(
                            '${(_progress * 100).toInt()}% / ${(_threshold * 100).toInt()}%',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF00D4FF),
                                fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 8,
                          backgroundColor: const Color(0xFF1E222D),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _isUnlocked
                                ? const Color(0xFF00FF88)
                                : const Color(0xFF00D4FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Brush Shape Picker
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('BRUSH SCRATCH TEXTURE',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade400,
                          letterSpacing: 0.8)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBrushChip('Coin Edge', ScratchBrushShape.coin),
                    const SizedBox(width: 8),
                    _buildBrushChip('Rough Jagged', ScratchBrushShape.rough),
                    const SizedBox(width: 8),
                    _buildBrushChip('Smooth', ScratchBrushShape.circle),
                  ],
                ),

                const SizedBox(height: 16),

                // Controls: Card Type & Particles Toggle
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isGoldCard = !_isGoldCard;
                          });
                          _scratchKey.currentState?.reset();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF1E222D)),
                        ),
                        child: Text(
                          _isGoldCard ? '🪙 Gold Foil' : '🥈 Silver Foil',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _particlesEnabled = !_particlesEnabled;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                              color: _particlesEnabled
                                  ? const Color(0xFF00D4FF)
                                  : const Color(0xFF1E222D)),
                        ),
                        child: Text(
                          _particlesEnabled ? '✨ Particles: ON' : '✨ Particles: OFF',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _particlesEnabled
                                ? const Color(0xFF00D4FF)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Action Buttons: Reset & Instant Reveal
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reset Card'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E222D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          _scratchKey.currentState?.reset();
                          setState(() {
                            _progress = 0.0;
                            _isUnlocked = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text('Reveal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D4FF),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          _scratchKey.currentState?.reveal();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrushChip(String label, ScratchBrushShape shape) {
    final isSelected = _selectedBrush == shape;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedBrush = shape;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF00D4FF).withValues(alpha: 0.15)
                : const Color(0xFF11131A),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF00D4FF)
                  : const Color(0xFF1E222D),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? const Color(0xFF00D4FF) : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
