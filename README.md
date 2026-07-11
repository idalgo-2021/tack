# Tack

**Tack** is a local-first application for creating and managing notes with support for multimedia, geotags, and data export. The application was developed as a way to explore modern vibe-coding technologies in mobile development.

*[Read this document in Russian](README.ru.md)*


## Features

- **Notes** — create, edit, and delete notes; automatic saving; batch operations; empty notes are discarded
- **Tags** — flexible tagging system with search, creation, and management capabilities
- **Note Formatting** — built-in text formatting tools for notes
- **Multimedia** — photo capture, video and audio recording, file attachments
- **Geolocation** — manual and automatic location tagging (configurable auto-geotagging)
- **Thumbnail Preview** — tap to view enlarged previews of photos and files
- **Search** — full-text and tag-based search with date filtering
- **Export** — Markdown and JSON export with ZIP archiving
- **Settings** — theme customization (7 color schemes), font size, grouping, sorting, and language selection (13 languages)
- **Target Platform** — tablets and smartphones

## Technologies

- **Flutter** — cross-platform UI framework
- **Riverpod** — state management
- **SharedPreferences** — settings storage
- **SQLite** — notes database
- **Geolocator** — geolocation services
- **record** / **audioplayers** — audio recording and playback
- **ImagePicker** / **FilePicker** — media selection
- **l10n** — internationalization (13 languages)


## Ready-to-Install Builds (APK)

* [https://github.com/idalgo-2021/tack/releases](https://github.com/idalgo-2021/tack/releases)



## Installation

### Requirements

- Flutter SDK >= 3.16
- Dart >= 3.2

### Running and Building

```bash
git clone https://github.com/idalgo-2021/tack
cd tack
flutter pub get
dart run build_runner build
flutter gen-l10n
flutter run
```

#### APK Build Options

| Command | When to Use | Size | Notes |
|----------|------------|------|--------|
| `flutter build apk --release` | Standard build | Standard | Most commonly used option |
| `flutter build apk --release --split-per-abi` | To reduce file size | Smaller | Generates 3 APK files (`armeabi-v7a`, `arm64-v8a`, `x86_64`) |
| `flutter build appbundle --release` | For publishing to Google Play | — | Generates an `.aab` file (not intended for direct installation) |

The generated files can be found in: *build/app/outputs/flutter-apk/*

## Current Version Limitations

* Data encryption is not implemented (i.e., notes, attachments, and geolocation data are stored in plain text).
* When exporting or sharing a note, the note and its attached files are transferred without encryption.
* Temporary export files are cleaned up on a best-effort basis (if cleanup fails, files may remain in the temporary directory).
* There is no explicit validation of file opening/sharing results (e.g., no checks for file existence, successful opening, or proper error handling).
* Geolocation functionality works only when the required permissions are granted and location services are enabled on the device.
* Test coverage is minimal.
* The application has been tested on Android emulators (a 10" tablet running Android 16.0 / API 36 and a 6.4" smartphone running Android 13.0 / API 33) and on a single physical device running Android 10. It has not been tested on Apple (iOS) devices.


<details>
<summary>Ideas / TODO:</summary>

* Eliminate the limitations described above, with priority on data-at-rest encryption and automated test coverage
* Add note import functionality
* Refine the UI/UX, particularly the note editing workflow and text manipulation capabilities
* Implement freehand sketching functionality with finger and stylus input support
* Add desktop synchronization/export capabilities for notes
* Implement note/file relocation across device storage directories
* Resolve and display human-readable location names from geotag metadata
* Enforce validation constraints for tag count, attachment size limits, and supported file types
* Implement duplicate attachment detection and prevention mechanisms
* Add orphaned file detection, auditing, and garbage-collection workflows
* Address technical debt and optimize application performance

</details>
<br><br>



## Screenshots

### Smartphone

![](docs/screenshots/SmartphoneScreens.jpg)


### Tablet

![](docs/screenshots/Planshet_ListWithoutGroup.png)

![](docs/screenshots/Planshet_SettingsScreen.png)

![](docs/screenshots/Planshet_ItemForm.png)