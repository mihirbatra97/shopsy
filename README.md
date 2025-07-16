# Shopsy - Mobile Shopping App

A prototype for a small online store's mobile interface built with Flutter and GetX state management.

## Features

- Product listing from local JSON file
- Product details view with Hero animations
- Add products to cart
- Cart management (add, remove, increase/decrease quantity)
- Cart total calculation
- Local storage for cart persistence
- Loading indicators with shimmer effects

## Architecture

This project follows the MVVM (Model-View-ViewModel) architecture pattern using GetX for state management:

- **Models**: Data structures for products and cart items
- **View Models**: Business logic and reactive state management
- **Views**: UI screens for product list, product details, and cart
- **Repositories**: Data access layer for products and cart persistence

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Build APK

To build a release APK:

```bash
flutter build apk --release
```

The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

## Download APK

You can download the latest release APK from [Google Drive](https://drive.google.com/drive/folders/1s6XySR93zOpPwTwQ87BcNF3Szw1KpnaT)

> Note: After uploading to Google Drive, replace the link above with your actual Google Drive sharing link

## Dependencies

- [get](https://pub.dev/packages/get): State management, navigation, and dependency injection
- [shared_preferences](https://pub.dev/packages/shared_preferences): Local storage for cart persistence
- [shimmer](https://pub.dev/packages/shimmer): Loading effects for images and UI components
