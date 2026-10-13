# Bill Splitter App

UI Design Flutter Lab project - **A. Harshitha (247R1A66D4), CSM-C**

A simple Flutter app that splits a bill among a group of people, with tip calculation.

## Features
- Enter total bill amount and number of people
- Tip percentage slider (0% - 30%)
- Automatic tip, total and per-person calculation
- Bill Summary card
- Reset button

## Tech
Flutter + Dart (Material 3)

## Download APK
Go to the **Releases** section of this repo and download `BillSplitter.apk`.

## Run locally
```bash
flutter create --platforms=android .   # generates android/ folder (first time only)
flutter pub get
flutter run
flutter build apk --release            # APK at build/app/outputs/flutter-apk/
```
