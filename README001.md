# Tiny Wonder Farm — Project Overview & Analysis

A 2D farming game prototype built with **Godot 4.5** (Mono), featuring an outdoor farm, house interior, time-of-day system, and player movement between areas.

---

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Controls](#controls)
- [Technical Summary](#technical-summary)
- [Bugs & Issues](#bugs--issues)
- [Patterns to Update](#patterns-to-update)
- [Credits](#credits)

---

## Features

- **Top-down farmer movement** — WASD or arrow keys
- **Two playable areas** — outdoor farm (grass + tilemap) and house interior
- **Scene transitions** — enter house via Area2D, exit via interior door
- **Day/night cycle** — in-game time advances ~1 minute per real second, with ambient color overlay
- **Dual time display** — IRL time and in-game time shown on screen
- **Placeholder crop** — strawberry sprite in main scene (crop logic not yet wired)

---

## Project Structure

```
tiny-wonder-farm/
├── project.godot          # Godot 4.5 config, autoload Global
├── scenes/
│   ├── main_scene.tscn    # Outdoor farm, grass, farmer, strawberry
│   ├── farmer.tscn        # CharacterBody2D with AnimatedSprite2D + camera
│   ├── grass_background.tscn  # Tilemap (summer/spring tiles)
│   ├── house_interior.tscn    # Interior tilemap, furniture, exit Area2D
│   └── strawberry.tscn    # Crop Area2D (animation only, no logic)
├── scripts/
│   ├── Global.gd          # Autoload: time system (minutes_total, hour, minute)
│   ├── main_scene.gd      # Updates IRL/ingame time labels
│   ├── farmer.gd          # Movement, animations, Area2D transitions
│   ├── house_interior.gd  # Placeholder (empty _ready/_process)
│   └── color_rect.gd      # Day/night overlay (gradient + opacity by time)
└── images/
    ├── Crop_Spritesheet.png
    ├── tilemaps/          # summer tilemap, inside, furniture, etc.
    ├── walk and idle.png
    └── up_down_walk and idle.png
```

---

## How to Run

1. Open the project in Godot 4.5 (Editor Path: `e:\Godot_v4.5.1-stable_mono_win64\`).
2. Press **F5** or use **Project → Run Project**.

---

## Controls

| Input | Action        |
|-------|---------------|
| WASD / Arrows | Move farmer |
| —     | Enter house (walk into door) |
| —     | Exit house (walk into door) |

---

## Technical Summary

### Time System (Global.gd)

- `minutes_total` — total in-game minutes since start (default 840 → 14:00).
- `hour`, `minute` — derived from `minutes_total`.
- `REAL_SECONDS_PER_GAME_MINUTE = 1.0` — 1 real second ≈ 1 in-game minute.
- `time_scale` — supports pause (0), normal (1), double (2), half (0.5).

### Scene Flow

- **Main scene**: `grass_background` has an Area2D (house door). When `farmer_main` enters → `change_scene_to_file("house_interior.tscn")`.
- **House interior**: Root has an Area2D (exit door). When `farmer_interior` enters → `change_scene_to_file("main_scene.tscn")`.
- Scene changes use `call_deferred` to avoid tree modification during callbacks.

### Day/Night Overlay (color_rect.gd)

- ColorRect follows camera (child of `AnimatedSprite2D/Camera2D/CanvasLayer`).
- `GRADIENT` defines colors by minute-of-day (e.g. 4:00 night → 6:00 dawn → 10:00–14:00 bright → dusk).
- Opacity fades in/out around dawn and dusk.

---

## Bugs & Issues

### 1. Print Format Typo (Global.gd)

- **Location**: Line 18  
- **Issue**: `"In-game time: ", hour, "hours, ", minute," minutes"` prints `14hours` (no space before "hours").
- **Fix**: Use `" " + str(hour) + " hours, " + str(minute) + " minutes"` or a proper format string.

### 2. Unused Constant (farmer.gd)

- **Location**: Line 4  
- **Issue**: `JUMP_VELOCITY = -400.0` is never used (top-down game, no jumping).
- **Fix**: Remove it, or keep only if jump will be implemented later.

### 3. Redundant Export Variables (color_rect.gd)

- **Location**: Lines 22–23, 26–27  
- **Issue**: `@export var hours` and `@export var minute` are set in `_ready()` but `update_overlay()` always uses `Global.hour` and `Global.minute`.
- **Fix**: Remove exports or use them consistently; currently they add confusion.

### 4. Strawberry Collision Shape

- **Location**: `strawberry.tscn` — `RectangleShape2D` has no explicit `size`.
- **Impact**: Uses Godot default (20×20). Sprite is 16×16, so hitbox is slightly larger than visual.
- **Fix**: Set `size = Vector2(16, 16)` if pixel-perfect hit detection is desired.

### 5. Potential Null / Node Path in House Interior

- **Location**: `house_interior.gd`  
- **Issue**: Script is attached to the Area2D but is effectively empty. `body_entered` is correctly connected to `farmer_interior._on_area_2d_body_entered` (from farmer.gd), so behavior is fine.
- **Suggestion**: Either attach `house_interior.gd` to the root node if it will hold scene logic, or remove it from the Area2D to reduce confusion.

---

## Patterns to Update

### 1. Scene Change API

- Current usage: `get_tree().change_scene_to_file.bind("res://path").call_deferred()`
- This is valid in Godot 4 to avoid tree modification during physics/signal callbacks.
- Consider `get_tree().call_deferred("change_scene_to_file", "res://path")` for consistency with other deferred calls.

### 2. Hardcoded Node Names

- `farmer.gd` checks `body.name == "farmer_main"` and `body.name == "farmer_interior"`.
- These depend on scene instance names. Prefer groups (`add_to_group("player")`) or a shared constant for robustness.

### 3. Commented-Out Code (main_scene.gd)

- Lines 15–18: commented strawberry placement on key press.
- Either remove if obsolete or document intent (e.g. for future planting).

### 4. Duplicate Logic in Movement

- `farmer.gd` uses `Input.get_vector()` and then overrides with `Input.is_action_pressed()` for animations.
- `direction = Vector2.ZERO` plus `play("idle")` when no input is redundant with `direction.normalized()` when direction is zero.
- Can be simplified with a single input/state flow.

### 5. `time` Variable Scope (main_scene.gd)

- `var time` is assigned every frame in `_process`; it is only used for display.
- Consider renaming to `_current_time` or making it local to `_process` to clarify scope.

---

## Credits

- **Tutorial inspiration** (pt-br): [YouTube — Tiny Wonder Forest](https://www.youtube.com/watch?v=yBepbShZe7Q&list=PLWQkzs8C_YkXIFFlCvvh21sP01jXSsGtk)
- **Main assets**: [Tiny Wonder Forest by butterymilk](https://butterymilk.itch.io/tiny-wonder-forest)
- **Vegetable/Crop assets**: [Farming Crops 16x16 — OpenGameArt](https://opengameart.org/content/farming-crops-16x16)

---

*Last updated: February 2025 — Godot 4.5, GL Compatibility renderer*
