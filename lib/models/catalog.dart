// Copyright 2023 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A model representing the restaurant's menu.
///
/// In a real app, this might be backed by a backend and cached on device.
/// This simplified model contains different food categories and items.
class MenuModel {
  // Food categories
  static const String appetizers = 'Appetizers';
  static const String mainCourses = 'Main Courses';
  static const String desserts = 'Desserts';
  static const String beverages = 'Beverages';
  
  // Menu items organized by category
  static Map<String, List<MenuItem>> menuItems = {
    appetizers: [
      MenuItem(1, 'Crispy Calamari', 'Tender calamari rings, lightly battered and fried', 9.99),
      MenuItem(2, 'Bruschetta', 'Toasted bread topped with tomatoes, basil, and garlic', 7.99),
      MenuItem(3, 'Buffalo Wings', 'Spicy chicken wings served with blue cheese dip', 11.99),
      MenuItem(4, 'Spinach Artichoke Dip', 'Creamy spinach dip with tortilla chips', 8.99),
    ],
    mainCourses: [
      MenuItem(5, 'Grilled Salmon', 'Fresh salmon with lemon butter sauce and asparagus', 18.99),
      MenuItem(6, 'Chicken Parmesan', 'Breaded chicken with marinara and melted mozzarella', 15.99),
      MenuItem(7, 'Beef Tenderloin', '8oz beef tenderloin with roasted vegetables', 24.99),
      MenuItem(8, 'Vegetable Pasta', 'Penne pasta with seasonal vegetables and pesto', 13.99),
      MenuItem(9, 'Fish Tacos', 'Grilled fish tacos with avocado and slaw', 14.99),
    ],
    desserts: [
      MenuItem(10, 'Chocolate Lava Cake', 'Warm cake with molten chocolate center', 7.99),
      MenuItem(11, 'Cheesecake', 'New York style cheesecake with berry compote', 6.99),
      MenuItem(12, 'Tiramisu', 'Classic Italian dessert with coffee and mascarpone', 8.99),
    ],
    beverages: [
      MenuItem(13, 'Fresh Lemonade', 'Homemade lemonade with mint', 3.99),
      MenuItem(14, 'Iced Tea', 'Sweet or unsweetened tea with lemon', 2.99),
      MenuItem(15, 'Espresso', 'Double shot of espresso', 4.99),
      MenuItem(16, 'Sparkling Water', 'Still or sparkling water', 1.99),
    ],
  };

  // List of all categories
  static List<String> get categories => menuItems.keys.toList();

  // Get all items flattened into a single list
  List<MenuItem> get allItems {
    List<MenuItem> items = [];
    menuItems.forEach((category, menuItems) {
      items.addAll(menuItems);
    });
    return items;
  }

  // Get item by its ID
  MenuItem getById(int id) {
    for (var category in menuItems.keys) {
      for (var item in menuItems[category]!) {
        if (item.id == id) return item;
      }
    }
    throw Exception('Menu item not found: $id');
  }

  // Get item by its position in the flattened list
  MenuItem getByPosition(int position) {
    List<MenuItem> items = allItems;
    if (position >= 0 && position < items.length) {
      return items[position];
    }
    // Return first item as fallback
    return items[0];
  }

  // Get all items in a specific category
  List<MenuItem> getItemsByCategory(String category) {
    return menuItems[category] ?? [];
  }
}

@immutable
class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final Color color;

  MenuItem(this.id, this.name, this.description, this.price)
      // Assign colors based on food categories to create a visually organized menu
      : color = _getColorForMenuItem(id);

  static Color _getColorForMenuItem(int id) {
    // Appetizers - shades of green
    if (id >= 1 && id <= 4) {
      return Colors.green[(id * 100) + 200]!;
    }
    // Main courses - shades of red/orange 
    else if (id >= 5 && id <= 9) {
      return Colors.orange[(id - 4) * 100]!;
    }
    // Desserts - shades of purple
    else if (id >= 10 && id <= 12) {
      return Colors.purple[(id - 9) * 100]!;
    }
    // Beverages - shades of blue
    else {
      return Colors.blue[(id - 12) * 100]!;
    }
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is MenuItem && other.id == id;
}