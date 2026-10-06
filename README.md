# scratch_reveal

<p align="center">
  <a href="https://pub.dev/packages/scratch_reveal"><img src="https://img.shields.io/pub/v/scratch_reveal.svg?style=flat-square&color=blue" alt="Pub Version"></a>
  <a href="https://pub.dev/packages/scratch_reveal/score"><img src="https://img.shields.io/pub/points/scratch_reveal?style=flat-square&color=2E8B57&label=pub%20points" alt="Pub Points"></a>
  <a href="https://govindtank.github.io/scratch_reveal/"><img src="https://img.shields.io/badge/Live%20Demo-Try%20In%20Browser-00ff88?style=flat-square&logo=flutter" alt="Live Demo"></a>
  <a href="https://pub.dev/packages/scratch_reveal"><img src="https://img.shields.io/pub/likes/scratch_reveal?style=flat-square" alt="Pub Likes"></a>
  <a href="https://github.com/govindtank/scratch_reveal/actions"><img src="https://github.com/govindtank/scratch_reveal/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square" alt="License"></a>
</p>

---

## ⚡ Why scratch_reveal?

Existing scratch card packages on pub.dev suffer from a fundamental architectural flaw: they calculate scratch coverage by reading raw bitmap pixels out of CPU image buffers on every drag stroke, causing micro-stutters and frame drops.

`scratch_reveal` solves this with a **2D Spatial Bitmask Grid Engine**:
1. **Sub-0.1ms Progress Calculation**: Calculates the exact percentage scratched instantly without querying GPU memory or freezing the UI thread.
2. **GPU `BlendMode.clear` Pipeline**: Buttery smooth 120 FPS eraser strokes on high-refresh-rate mobile devices.
3. **Threshold Auto-Reveal & Animations**: Smoothly fades/scales out remaining foil once the target threshold (e.g. 60%) is reached.
4. **Rich Styling**: Solid colors, multi-stop metallic gradients (silver/gold foil), or custom widget overlays.
5. **Zero Native C++**: 100% pure Flutter & Dart across iOS, Android, Web, macOS, Windows, and Linux.

---

## 📦 Installation

Add `scratch_reveal` to your `pubspec.yaml`:

```yaml
dependencies:
  scratch_reveal: ^1.1.1
```

Or run:

```bash
flutter pub add scratch_reveal
```

---

## 🚀 Quick Start

### 1. Metallic Foil Scratch Card with Auto-Reveal

```dart
import 'package:flutter/material.dart';
import 'package:scratch_reveal/scratch_reveal.dart';

class PromoScratchCard extends StatelessWidget {
  const PromoScratchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ScratchReveal(
          brushSize: 40.0,
          threshold: 0.65, // Auto-reveals at 65% scratched
          coverGradient: const LinearGradient(
            colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8), Color(0xFF475569)],
          ),
          cover: const Center(
            child: Text('SCRATCH TO REVEAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          revealedChild: Container(
            color: const Color(0xFFD97706),
            alignment: Alignment.center,
            child: const Text('🎉 ₹500 VOUCHER CODE: LUCKY2026', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          onThresholdReached: () {
            print('Reward unlocked!');
          },
          onProgressUpdate: (progress) {
            print('Progress: ${(progress * 100).toInt()}%');
          },
        ),
      ),
    );
  }
}
```

---

### 2. Programmatic Reveal & Reset

```dart
final scratchKey = GlobalKey<ScratchRevealState>();

// Reset the card back to unscratched:
scratchKey.currentState?.reset();

// Automatically reveal the reward:
scratchKey.currentState?.reveal();
```

---

## 🛠️ API Reference

### `ScratchReveal` Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `revealedChild` | `Widget` | **Required** | The underlying prize or content to be revealed. |
| `cover` | `Widget?` | `null` | Optional visual widget overlay (e.g. icon + text). |
| `coverColor` | `Color` | `Color(0xFF64748B)` | Solid color of the scratch foil. |
| `coverGradient`| `Gradient?` | `null` | Gradient for realistic metallic foil textures. |
| `brushSize` | `double` | `36.0` | Thickness of the eraser stroke in logical pixels. |
| `threshold` | `double` | `0.60` | Fraction in `[0.0, 1.0]` needed to trigger auto-reveal. |
| `autoReveal` | `bool` | `true` | Whether to animate remaining foil away at threshold. |
| `revealDuration`| `Duration`| `Duration(milliseconds: 600)` | Transition animation duration. |
| `onThresholdReached`| `VoidCallback?` | `null` | Fired once when threshold is met. |
| `onProgressUpdate`| `ValueChanged<double>?` | `null` | Continuous progress callback `[0.0, 1.0]`. |
| `enableHaptics` | `bool` | `false` | Triggers subtle tactile haptics while scratching. |

---

## 💖 Support the Project

If you find this project useful, consider supporting its active maintenance and future development:

<p align="left">
  <a href="https://buymeacoffee.com/govindtanko"><img src="https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee" /></a>
  <a href="https://github.com/sponsors/govindtank"><img src="https://img.shields.io/badge/GitHub%20Sponsors-EA4AAA?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Sponsors" /></a>
  <a href="https://www.patreon.com/govindtank"><img src="https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white" alt="Patreon" /></a>
</p>

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

*Maintained with ❤️ by [Govind Tank](https://github.com/govindtank).*
