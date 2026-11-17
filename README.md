# scratch_reveal

<p align="center">
  <a href="https://pub.dev/packages/scratch_reveal"><img src="https://img.shields.io/pub/v/scratch_reveal.svg?style=flat-square&color=blue" alt="Pub Version"></a>
  <a href="https://pub.dev/packages/scratch_reveal/score"><img src="https://img.shields.io/pub/points/scratch_reveal?style=flat-square&color=2E8B57&label=pub%20points" alt="Pub Points"></a>
  <a href="https://govindtank.github.io/scratch_reveal/"><img src="https://img.shields.io/badge/Live%20Demo-Try%20In%20Browser-00ff88?style=flat-square&logo=flutter" alt="Live Demo"></a>
  <a href="https://pub.dev/packages/scratch_reveal"><img src="https://img.shields.io/pub/likes/scratch_reveal?style=flat-square" alt="Pub Likes"></a>
  <a href="https://github.com/govindtank/scratch_reveal/actions"><img src="https://github.com/govindtank/scratch_reveal/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square" alt="License"></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/govindtank/scratch_reveal/main/doc/assets/scratch_showcase.svg" alt="scratch_reveal Showcase" width="100%">
</p>

An interactive, high-performance scratch-to-reveal card library and turnkey `RewardScratchCard` for Flutter. Features **celebratory confetti bursts, turnkey Google Pay & CRED style voucher rewards, flying metallic foil dust particles, coin serration brushes, and sub-0.1ms spatial bitmask progress calculation**.

---

## ⚡ Key Features

| Feature | Description | Real-World Benefit |
|---|---|---|
| **Turnkey `RewardScratchCard`** | Complete gamified reward card with metallic foil, coupon code, and claim action | Ready in 3 lines of code |
| **Celebratory Confetti Cannon** | Physics-based 2D confetti ribbons bursting upwards upon threshold auto-reveal | Delightful reward moment |
| **Zero-Latency Touch Punch** | Touching or tapping down immediately punches a crisp hole without drag delay | Instant, tactile response |
| **Coin & Rough Brushes** | Realistic coin edge serration with micro-grooves (`ScratchBrushShape.coin`) | Feels like a real coin scratcher |
| **Flying Foil Dust Particles** | Dynamic metallic shaving flakes and sparkle dust that scatter while scratching | Realistic physical sensation |
| **Sub-0.1ms Bitmask Tracking** | Zero heavy bitmap reading; pure 64-bit integer grid bitmasks on CPU | Constant 120 FPS on all devices |

---

## 🚀 Quick Usage

### 1. Turnkey Reward Card (Google Pay / CRED / PhonePe Style)

```dart
RewardScratchCard(
  rewardTitle: '₹ 250 Cashback',
  rewardSubtitle: 'Credited on orders above ₹499',
  couponCode: 'SWIGGY250',
  coverTitle: 'Scratch & Win',
  coverSubtitle: 'Scratch here to reveal your surprise cashback',
  threshold: 0.45,       // Auto-reveal at 45% scratched
  enableConfetti: true,  // Confetti explosion on unlock
  onClaimPressed: () {
    print('Voucher claimed!');
  },
)
```

---

### 2. Lower-Level Custom Scratch Card

```dart
ScratchReveal(
  brushSize: 40.0,
  brushShape: ScratchBrushShape.coin,
  threshold: 0.50,
  autoReveal: true,
  coverGradient: const LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
  ),
  revealedChild: Container(
    color: const Color(0xFF1E293B),
    child: const Center(
      child: Text('🎉 500 COINS WON!', style: TextStyle(color: Colors.white)),
    ),
  ),
  onThresholdReached: () => print('Unlocked!'),
)
```

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
