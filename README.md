# 🌌 OPENQUEST // BEYOND THE GRID

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Synthwave](https://img.shields.io/badge/Aesthetic-Synthwave-ff00ff.svg?style=flat)](https://github.com/synthalorian/open-quest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**OpenQuest** is a high-octane branching dialogue and quest tree editor for game developers who live in the neon-soaked future. Built with Flutter and Riverpod, it provides a fluid, hardware-accelerated canvas for mapping out the complex narratives of your digital worlds.

---

## ⚡ FEATURES

- **Interactive Canvas**: Pan, zoom, and drag nodes across a 2000x2000 digital frontier.
- **Node-Based Logic**: Connect different node types (Start, Dialogue, Choice, Action, Quest) using cubic-bezier signal paths.
- **Live State Management**: Powered by Riverpod for glitch-free, reactive performance.
- **Local Persistence**: Integrated Hive storage ensures your narrative data is cached locally.
- **JSON Export**: One-tap export of your entire quest tree structure for easy integration into your game engine.

## 🎹 THE TECH STACK

- **Flutter**: The engine of the future.
- **Riverpod**: Robust, reactive state synchronization.
- **Hive**: Fast, no-SQL key-value database for local storage.
- **Custom Painting**: Hand-coded `EdgePainter` for smooth, aesthetic signal connections.
- **UUID**: Unique identification for every node and edge in the grid.

## 🚀 GETTING STARTED

1.  **Sync the SDK**: Ensure you have Flutter installed (>= 3.4.0).
2.  **Initialize**: `flutter pub get`
3.  **Deploy**: `flutter run`

---

## 💾 DATA STRUCTURE

Trees are exported in a clean, machine-readable JSON format:

```json
{
  "id": "UUID",
  "name": "The Neon Heist",
  "nodes": [
    {
      "id": "node-id",
      "type": "dialogue",
      "content": "You enter the club. The bass hits your chest.",
      "x": 420.0,
      "y": 69.0
    }
  ],
  "edges": [
    {
      "id": "edge-id",
      "fromNodeId": "start-id",
      "toNodeId": "dialogue-id"
    }
  ]
}
```

---

## 🎹 SYNTHESIS BY SYNTHCLAW

Created by **synth** and **synthclaw**. This is the wave.
