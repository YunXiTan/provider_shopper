// Copyright 2023 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// Restaurant theme colors
const restaurantPrimaryColor = Color(0xFF8D6E63); // Brown
const restaurantAccentColor = Color(0xFFFF9800);  // Orange
const backgroundColor = Color(0xFFF5F5F5);        // Light gray

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: restaurantPrimaryColor,
    primary: restaurantPrimaryColor,
    secondary: restaurantAccentColor,
  ),
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: const AppBarTheme(
    color: restaurantPrimaryColor,
    elevation: 4.0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: restaurantAccentColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  cardTheme: const CardTheme(
    elevation: 2.0,
    margin: EdgeInsets.all(8.0),
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.black12,
    thickness: 1.0,
    space: 1.0,
  ),
  textTheme: const TextTheme(
    // Restaurant name and section headings
    displayLarge: TextStyle(
      fontFamily: 'Playfair Display',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: Colors.black87,
    ),
    // Menu item names
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: Colors.black87,
    ),
    // Menu item descriptions
    bodyMedium: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black54,
    ),
    // Price text
    labelLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: restaurantPrimaryColor,
    ),
  ),
);