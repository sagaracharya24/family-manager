#!/bin/bash

echo "Building OurHome for all flavors..."

# Build Production
echo "Building Production flavor..."
flutter build apk --target lib/main_prod.dart --flavor prod --release

# Build Staging
echo "Building Staging flavor..."
flutter build apk --target lib/main_staging.dart --flavor staging --release

# Build QA
echo "Building QA flavor..."
flutter build apk --target lib/main_qa.dart --flavor qa --release

echo "All builds completed!"
echo "APKs are located in build/app/outputs/flutter-apk/"