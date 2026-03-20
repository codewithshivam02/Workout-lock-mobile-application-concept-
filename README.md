# Workout Lock

Flutter MVP for Android: **lock selected apps** until the user finishes a **camera-verified workout** using on-device **ML Kit pose** + **face** detection. Local **SQLite** stores history; **SharedPreferences** + a native **MethodChannel** keep the Android accessibility layer in sync.

## Current product focus

Following the “reliable core loop first” roadmap, the app emphasizes **clear setup** (dashboard checklist + intro card), **honest copy** (Accessibility required, Usage optional), **resume sync** when returning from system settings, and **in-workout feedback** when the body isn’t detected. The **Home**, **Workout**, and **Lock** tabs **reload** when the app returns to the foreground; **Lock gate** refreshes after you finish a nested workout flow. **Skip-penalty** difficulty updates run on profile refresh / dashboard reload. Native **accessibility redirects** are **debounced** to reduce rapid re-launches. Firebase, usage-stats polling, and overlay blocking stay deferred until a concrete need appears.

## Quick start

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (3.16+).
2. From this folder:
   ```bash
   flutter pub get
   ```
3. If `android/gradlew` is missing (fresh checkout), regenerate Android glue:
   ```bash
   flutter create . --project-name workout_lock
   ```
4. Create `android/local.properties` with your SDK path (Flutter usually does this automatically):
   ```properties
   sdk.dir=/path/to/Android/sdk
   flutter.sdk=/path/to/flutter
   ```
5. Run on a physical device (recommended for camera + ML):
   ```bash
   flutter run
   ```

## Enable locking (Android)

1. Open **App lock** tab → **Open accessibility** → enable **Workout Lock**.
2. (Optional) **Open usage settings** and allow **Usage access** — the UI reflects permission status; **foreground detection for redirects uses the accessibility service** (reliable across OEMs). Usage access is reserved for future analytics / dual-checks.

After you pick apps to lock, complete a workout from the **Workout** tab. The native layer stores `workout_completed_date` and stops redirecting until the next calendar day (local date `yyyy-MM-dd`).

## Folder map

```
lib/
  main.dart                 # App + theme + Provider
  models/                   # Exercise, profile, workout record
  pose/                     # Joint angles + rep engine (pushup/squat/JJ/plank)
  providers/app_state.dart  # Theme + profile session
  screens/                  # Splash, auth, shell, dashboard, workout, lock, profile
  services/                 # SQLite, day-unlock state, TTS, platform bridge
  theme/                    # Gradients + light/dark Material 3
  utils/                    # CameraImage → ML Kit InputImage (NV21)
android/.../kotlin/         # MainActivity MethodChannel + AccessibilityService
```

## Security & privacy notes

- **Login/signup** is **local-demo only** (no server); passwords are not securely verified — replace with Firebase Auth (or similar) for production.
- The accessibility service uses **package names** from `TYPE_WINDOW_STATE_CHANGED` only; it does not read screen text or passwords.
- **Face detection** is used to encourage staying in frame (soft anti-cheat), not to identify users.

## Scaling ideas

- Swap `DatabaseService` for **Firestore** + **Firebase Auth**.
- Add **UsageStatsManager** polling as a second signal alongside accessibility on stubborn OEMs.
- Tune rep thresholds per user height via calibration poses.
- Add **overlay** (`SYSTEM_ALERT_WINDOW`) for a full-screen block instead of bringing `MainActivity` forward.

## Lock schedule (Android)

Under **Lock → Schedule** you can **pause redirects on weekends** and set **quiet hours** (supports overnight windows, e.g. 22:00–07:00). Values are stored in SharedPreferences and synced to the accessibility service via `syncLockState`. Pure-Dart helpers live in `lib/utils/quiet_hours.dart` with tests in `test/quiet_hours_test.dart`.

## Tech

- **Pose**: `google_mlkit_pose_detection` (angles at elbows/knees/hips).
- **Face**: `google_mlkit_face_detection`.
- **Voice**: `flutter_tts`.
- **Charts**: `fl_chart`.
- **DB**: `sqflite`.
