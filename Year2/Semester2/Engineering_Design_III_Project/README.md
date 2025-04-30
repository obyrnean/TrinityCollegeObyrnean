# Design Engineering: Smart Buggy Project

This repository documents my work for the Design Engineering project in second-year Computer Engineering.  
The project focuses on building an **autonomous Arduino-powered buggy** with **wireless control** and **graphical feedback via a Processing-based GUI**, delivered in three progressive stages: Bronze, Silver, and Gold Challenges.

---

## Project Overview

The buggy is equipped with:
- **IR sensors** for line-following
- **Ultrasonic rangefinder** for obstacle detection
- **Wheel encoders** for distance tracking
- **WiFi (ESP)** module for wireless PC-buggy communication
- **HuskyLens** for visual tag recognition (Gold Challenge)

The GUI (built in **Processing**) allows users to start/stop the buggy, switch modes, and monitor telemetry in real-time.

---

## 🥉 Bronze Challenge – Basic Autonomous Navigation

### Buggy Requirements:
- Follow a **loop track** (~3m, light line on dark surface) with at least two right-angle turns.
- Traverse the track **twice** using IR line sensors.
- **Pause** when obstacles are detected by ultrasonic sensor (≈10cm threshold).
- **Report** events (obstacles, distance) wirelessly to PC.

### GUI Requirements (Processing):
- Start/Stop buttons
- Console or GUI output for:
  - Obstacle detection messages
  - Distance estimates (via encoders)

---

## 🥈 Silver Challenge – PID-Controlled Speed

### New Features:
- **PID Controller** for dynamic speed control
- **Two speed control modes**:
  1. **Manual reference speed** input from GUI
  2. **Object tracking** mode (maintain 15cm distance from a moving object using ultrasonic sensor)

### Telemetry Sent to GUI:
- Current control mode
- Reference speed
- Actual speed
- Distance to object (when in object tracking mode)

---

## 🥇 Gold Challenge – Advanced Autonomy with Vision

### HuskyLens Vision + Tags:
The buggy uses **AprilTags** detected by the **HuskyLens** to determine behavior:

- **Turn Left** at next junction
- **Turn Right** at next junction
- **Slow Down** at Speed Limit tag
- **Go Fast** when safe

### Track Behavior:
- Make decisions at junctions based on tag commands
- Adjust speed at correct points (e.g. *after* reaching speed marker)

### GUI Enhancements:
- Display current tag detected
- Show interpreted behavior (turn, speed)
- Bonus marks for creative, informative, or interactive designs!

---

## Final Race:
- Fastest team around the final course wins a prize!
- Leaderboard ranking based on performance, correctness, and speed
