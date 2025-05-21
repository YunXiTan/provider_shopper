// Copyright 2023 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/models/catalog.dart';
import 'package:provider_shopper/models/order.dart';

class MyMenu extends StatelessWidget {
  const MyMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: MenuModel.categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Restaurant Menu', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.restaurant_menu),
                  onPressed: () => context.go('/menu/order'),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<OrderModel>(
                    builder: (context, order, child) {
                      return order.items.isEmpty
                          ? const SizedBox.shrink()
                          : Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${order.items.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: MenuModel.categories
                .map((category) => Tab(text: category))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: MenuModel.categories
              .map((category) => _CategoryMenuList(category: category))
              .toList(),
        ),
      ),
    );
  }
}

class _CategoryMenuList extends StatelessWidget {
  final String category;

  const _CategoryMenuList({required this.category});

  @override
  Widget build(BuildContext context) {
    var menuModel = Provider.of<MenuModel>(context);
    List<MenuItem> categoryItems = menuModel.getItemsByCategory(category);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: categoryItems.length,
      itemBuilder: (context, index) {
        return _MenuItemCard(menuItem: categoryItems[index]);
      },
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;

  const _MenuItemCard({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color indicator representing the menu item
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: menuItem.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restaurant, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // Menu item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(menuItem.name, style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    menuItem.description,
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\RM${menuItem.price.toStringAsFixed(2)}',
                    style: textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            // Add button
            _AddButton(menuItem: menuItem),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final MenuItem menuItem;

  const _AddButton({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    // The context.select() method will let you listen to changes to
    // a *part* of a model. You define a function that "selects" (i.e. returns)
    // the part you're interested in, and the provider package will not rebuild
    // this widget unless that particular part of the model changes.
    var itemCount = context.select<OrderModel, int>(
      (order) => order.getQuantity(menuItem),
    );

    return Column(
      children: [
        if (itemCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '$itemCount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(0),
            minimumSize: const Size(36, 36),
          ),
          onPressed: () {
            // Add the item to the order
            var order = context.read<OrderModel>();
            order.add(menuItem);
            // Show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${menuItem.name} added to your order'),
                duration: const Duration(seconds: 1),
                action: SnackBarAction(
                  label: 'VIEW ORDER',
                  onPressed: () => context.go('/menu/order'),
                ),
              ),
            );
          },
          child: const Icon(Icons.add, size: 20),
        ),
      ],
    );
  }
}