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
  scratch_reveal: ^1.0.0
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

## 👨💻 Author & Maintainer

Developed and maintained by **Govind Tank**.

Contributions and issues are welcome on [GitHub](https://github.com/govindtank/scratch_reveal)!

---

## 🌐 Ecosystem & Related Packages

Explore complementary production-grade libraries built for high-performance Flutter & Dart development:

| Package | Description | Version |
| :--- | :--- | :--- |
| **[`country_mobile_validator`](https://pub.dev/packages/country_mobile_validator)** | Zero-dependency per-country mobile validation (249 ISO regions). | `^0.2.0` |
| **[`currency_field_formatter`](https://pub.dev/packages/currency_field_formatter)** | Exact cursor-tracking currency and financial input formatter. | `^1.1.0` |
| **[`ambient_backdrop_glow`](https://pub.dev/packages/ambient_backdrop_glow)** | Dynamic ambient background glow & fluid OKLab mesh gradients. | `^1.1.0` |
| **[`segmented_ring_painter`](https://pub.dev/packages/segmented_ring_painter)** | High-performance segmented progress & concentric activity rings. | `^1.1.0` |
| **[`offline_outbox`](https://pub.dev/packages/offline_outbox)** | Offline-first resilient transactional outbox and retry queue. | `^1.1.0` |
| **[`cron_schedule`](https://pub.dev/packages/cron_schedule)** | Pure-Dart cron expression parser, predictor & fluent builder. | `^1.1.0` |
| **[`flutter_whisper`](https://pub.dev/packages/flutter_whisper)** | On-device speech-to-text transcription powered by whisper.cpp. | `^0.2.0` |
| **[`quote_painter`](https://pub.dev/packages/quote_painter)** | Canvas text styling with gradients, shadows, line badges & themes. | `^0.2.2` |
| **[`waveform_pro`](https://pub.dev/packages/waveform_pro)** | Audio waveform visualizer with discrete bars, splines & live buffer. | `^1.1.2` |

---

## 📄 License

This package is licensed under the [Apache-2.0 License](LICENSE).
