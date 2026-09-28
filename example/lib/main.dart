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
      title: 'Scratch Reveal Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF59E0B),
          surface: Color(0xFF1E293B),
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
  double _brushSize = 38.0;
  double _threshold = 0.60;
  bool _isUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scratch Reveal Demo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Scratch Card Card
            Container(
              constraints: const BoxConstraints(maxWidth: 340),
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: ScratchReveal(
                  key: _scratchKey,
                  brushSize: _brushSize,
                  threshold: _threshold,
                  coverGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFCBD5E1),
                      Color(0xFF94A3B8),
                      Color(0xFF64748B),
                    ],
                  ),
                  cover: Container(
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, size: 36, color: Colors.white70),
                        SizedBox(height: 6),
                        Text(
                          'SCRATCH HERE TO REVEAL',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.white,
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
                          Color(0xFFD97706),
                          Color(0xFFB45309),
                          Color(0xFF78350F)
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.stars_rounded,
                            size: 48, color: Color(0xFFFDE047)),
                        SizedBox(height: 8),
                        Text(
                          '₹500 CASHBACK REWARD',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Code: LUCKY2026',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFEF08A),
                              fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                  onProgressUpdate: (p) => setState(() => _progress = p),
                  onThresholdReached: () => setState(() => _isUnlocked = true),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Progress Meter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isUnlocked
                            ? '🎉 Reward Unlocked!'
                            : 'Scratch Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isUnlocked
                              ? const Color(0xFF10B981)
                              : Colors.white,
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}% / ${(_threshold * 100).toInt()}%',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF59E0B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progress.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: const Color(0xFF0F172A),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isUnlocked
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF334155)),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Card'),
                    onPressed: () {
                      setState(() {
                        _isUnlocked = false;
                        _progress = 0.0;
                      });
                      _scratchKey.currentState?.reset();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.visibility),
                    label: const Text('Reveal Now',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => _scratchKey.currentState?.reveal(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sliders
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Brush Size',
                          style:
                              TextStyle(fontSize: 12, color: Colors.white70)),
                      Expanded(
                        child: Slider(
                          value: _brushSize,
                          min: 20,
                          max: 70,
                          onChanged: (v) => setState(() => _brushSize = v),
                        ),
                      ),
                      Text('${_brushSize.toInt()}px',
                          style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Threshold',
                          style:
                              TextStyle(fontSize: 12, color: Colors.white70)),
                      Expanded(
                        child: Slider(
                          value: _threshold,
                          min: 0.2,
                          max: 0.9,
                          onChanged: (v) => setState(() => _threshold = v),
                        ),
                      ),
                      Text('${(_threshold * 100).toInt()}%',
                          style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
