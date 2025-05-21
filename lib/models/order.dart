// Copyright 2023 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:provider_shopper/models/catalog.dart';

class OrderModel extends ChangeNotifier {
  /// The private field backing [menuModel].
  late MenuModel _menuModel;

  /// Internal, private state of the order. Stores the ids of each item.
  final Map<int, int> _itemQuantities = {};

  // Tax rate for the order (8%)
  static const double taxRate = 0.08;

  // Optional tip percentage (default 15%)
  double _tipPercentage = 15.0;

  /// The current menu model. Used to construct items from numeric ids.
  MenuModel get menuModel => _menuModel;

  set menuModel(MenuModel newMenuModel) {
    _menuModel = newMenuModel;
    // Notify listeners, in case the new menu model provides different information
    notifyListeners();
  }

  /// List of items in the order, with their quantities
  List<OrderItem> get items {
    List<OrderItem> orderItems = [];
    _itemQuantities.forEach((id, quantity) {
      orderItems.add(OrderItem(_menuModel.getById(id), quantity));
    });
    return orderItems;
  }

  /// The current subtotal of all items (before tax and tip)
  double get subtotal {
    return items.fold(0, (total, current) => total + (current.menuItem.price * current.quantity));
  }

  /// The tax amount for the order
  double get tax => subtotal * taxRate;

  /// The tip amount based on current percentage
  double get tip => subtotal * (_tipPercentage / 100);

  /// The current total price of all items (including tax and tip)
  double get totalPrice => subtotal + tax + tip;

  /// Get the current tip percentage
  double get tipPercentage => _tipPercentage;

  /// Set a new tip percentage
  set tipPercentage(double percentage) {
    _tipPercentage = percentage;
    notifyListeners();
  }

  /// Adds [item] to order. This is the only way to modify the order from outside.
  void add(MenuItem item) {
    if (_itemQuantities.containsKey(item.id)) {
      _itemQuantities[item.id] = _itemQuantities[item.id]! + 1;
    } else {
      _itemQuantities[item.id] = 1;
    }
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  /// Removes one quantity of [item] from the order
  void remove(MenuItem item) {
    if (_itemQuantities.containsKey(item.id)) {
      if (_itemQuantities[item.id]! > 1) {
        _itemQuantities[item.id] = _itemQuantities[item.id]! - 1;
      } else {
        _itemQuantities.remove(item.id);
      }
      // Don't forget to tell dependent widgets to rebuild _every time_
      // you change the model.
      notifyListeners();
    }
  }

  /// Completely remove an item from the order regardless of quantity
  void removeCompletely(MenuItem item) {
    if (_itemQuantities.containsKey(item.id)) {
      _itemQuantities.remove(item.id);
      notifyListeners();
    }
  }

  /// Get quantity of a specific item
  int getQuantity(MenuItem item) {
    return _itemQuantities[item.id] ?? 0;
  }

  /// Clear the entire order
  void clear() {
    _itemQuantities.clear();
    notifyListeners();
  }
}

/// Represents an item in the order with its quantity
class OrderItem {
  final MenuItem menuItem;
  final int quantity;

  OrderItem(this.menuItem, this.quantity);

  double get totalPrice => menuItem.price * quantity;
}