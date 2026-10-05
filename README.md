# scratch_reveal

[![Pub Version](https://img.shields.io/pub/v/scratch_reveal.svg?style=flat-square&color=blue)](https://pub.dev/packages/scratch_reveal)
[![Pub Points](https://img.shields.io/pub/points/scratch_reveal?style=flat-square&color=2E8B57&label=pub%20points)](https://pub.dev/packages/scratch_reveal/score)
[![Pub Likes](https://img.shields.io/pub/likes/scratch_reveal?style=flat-square)](https://pub.dev/packages/scratch_reveal)
[![CI](https://github.com/govindtank/scratch_reveal/actions/workflows/ci.yml/badge.svg)](https://github.com/govindtank/scratch_reveal/actions)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square)](LICENSE)

A high-performance, GPU-accelerated **scratch card** and **scratch-to-reveal canvas** widget for Flutter with **sub-millisecond spatial bitmask area tracking**, smooth auto-reveal animations, and customizable foil styles.

<p align="center">
  <img src="https://raw.githubusercontent.com/govindtank/scratch_reveal/main/screenshot.svg" width="750" alt="scratch_reveal demo"/>
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

If you find this package useful, consider supporting its active maintenance and future development:

<p align="left">
  <a href="https://buymeacoffee.com/govindtanko"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=☕&slug=govindtanko&button_colour=FFDD00&font_colour=000000&font_family=Poppins&outline_colour=000000&coffee_colour=FFDD00" alt="Buy Me A Coffee" height="40"/></a>
  &nbsp;
  <a href="https://github.com/sponsors/govindtank"><img src="https://img.shields.io/badge/GitHub%20Sponsors-Sponsor-EA4AAA?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Sponsors" height="40"/></a>
  &nbsp;
  <a href="https://www.patreon.com/govindtank"><img src="https://img.shields.io/badge/Patreon-Support-F96854?style=for-the-badge&logo=patreon&logoColor=white" alt="Patreon" height="40"/></a>
</p>

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

*Maintained with ❤️ by [Govind Tank](https://github.com/govindtank).*
