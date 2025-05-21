// Copyright 2023 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/models/order.dart';

class MyOrder extends StatelessWidget {
  const MyOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
      ),
      body: Consumer<OrderModel>(
        builder: (context, order, child) {
          return order.items.isEmpty
              ? const _EmptyOrder()
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _OrderItemList(),
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    _OrderSummary(),
                  ],
                );
        },
      ),
    );
  }
}

class _EmptyOrder extends StatelessWidget {
  const _EmptyOrder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.restaurant,
            size: 80,
            color: Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'Your order is empty',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some delicious items from our menu',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('BACK TO MENU'),
          ),
        ],
      ),
    );
  }
}

class _OrderItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleLarge;
    var order = context.watch<OrderModel>();

    return ListView.separated(
      itemCount: order.items.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final orderItem = order.items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quantity controls
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      order.add(orderItem.menuItem);
                    },
                  ),
                  Text(
                    '${orderItem.quantity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      order.remove(orderItem.menuItem);
                    },
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderItem.menuItem.name, style: itemNameStyle),
                    const SizedBox(height: 4),
                    Text(
                      orderItem.menuItem.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Price and remove button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\RM${orderItem.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      order.removeCompletely(orderItem.menuItem);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var priceStyle = textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);
    var tipController = TextEditingController();
    
    return Consumer<OrderModel>(
      builder: (context, order, child) {
        // Initialize tip controller with current percentage
        tipController.text = order.tipPercentage.toString();
        
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Summary', style: textTheme.titleLarge),
              const SizedBox(height: 16),
              // Order details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal:', style: textTheme.bodyLarge),
                  Text('\RM${order.subtotal.toStringAsFixed(2)}', style: textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax (${(OrderModel.taxRate * 100).toStringAsFixed(0)}%):', style: textTheme.bodyLarge),
                  Text('\RM${order.tax.toStringAsFixed(2)}', style: textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 8),
              
              const Divider(height: 24, thickness: 1),
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: priceStyle),
                  Text('\RM${order.totalPrice.toStringAsFixed(2)}', style: priceStyle),
                ],
              ),
              const SizedBox(height: 24),
              // Place order button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Show order confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thank You!'),
                        content: const Text(
                          'Your order has been placed successfully. It will be ready for pickup in about 20 minutes.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Clear the order and navigate back to menu
                              order.clear();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('PLACE ORDER'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}