#!/bin/bash

echo "🎨 MeeMi - Flutter App"
echo "=================================="
echo ""

echo "📦 Installing dependencies..."
flutter pub get

echo ""
echo "�� Checking for available devices..."
flutter devices

echo ""
echo "🚀 Starting the app..."
echo "   (If multiple devices available, select one)"
echo ""

flutter run

