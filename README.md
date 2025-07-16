# Shopsy - Mobile Shopping App

A prototype for a small online store's mobile interface built with Flutter and GetX state management.

## Features

- Product listing from local JSON file
- Product details view
- Add products to cart
- Cart management (add, remove, increase/decrease quantity)
- Cart total calculation
- Local storage for cart persistence

## Architecture

This project follows the MVC (Model-View-Controller) architecture pattern using GetX for state management:

- **Models**: Data structures for products and cart items
- **Views**: UI screens for product list, product details, and cart
- **Controllers**: Business logic for product and cart management

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Dependencies

- [get](https://pub.dev/packages/get): State management, navigation, and dependency injection
- [shared_preferences](https://pub.dev/packages/shared_preferences): Local storage for cart persistence
