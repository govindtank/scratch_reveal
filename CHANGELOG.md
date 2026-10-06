## 1.1.2

* **Realistic Scratch Textures:** Added `ScratchBrushShape.coin` with parallel micro-grooves and `ScratchBrushShape.rough` with jagged organic edges simulating realistic coin lottery scratching.
* **Foil Dust & Shavings Particles:** Added dynamic metallic foil shaving flakes and sparkle dust physics (`ScratchParticle`) that fly and scatter naturally while scratching.
* **Factory Constructors:** Added `ScratchReveal.silverLottery()` and `ScratchReveal.goldLottery()` for instant pre-styled scratch cards.
* **Micro-Texture Shading:** Added subtle foil surface cross-hatch detail in `ScratchPainter`.

## 1.1.1

* Added `ScratchFoilPreset` with gold and silver metallic foil presets.
* Verified CI/CD workflows.

## 1.1.0

* Added `brushShape` support (`circle`, `coin`, `square`) in `ScratchReveal` widget and `ScratchPainter`.
* Added `onRevealComplete` callback triggered when auto-reveal fade animation finishes.
* Added `enabled` flag to programmatically toggle touch scratch interactions.
* Added `progress` and `isRevealed` getters on `ScratchRevealState`.
* Added explicit `platforms` declaration (Android, iOS, Web, macOS, Windows, Linux).

## 1.0.0

* Initial stable release of `scratch_reveal`.
* Sub-0.1ms spatial bitmask area tracking engine (`ScratchBitmaskGrid`).
* GPU-accelerated `BlendMode.clear` scratch path renderer (`ScratchPainter`).
* Configurable auto-reveal animations, metallic foil gradients, and custom cover widgets.
* Haptic feedback integration and programmatic `reset()` / `reveal()` controls.
* Interactive example app with real-time progress bar, code reveal, and customization sliders.
* 100% test coverage and zero pub.dev warnings.
