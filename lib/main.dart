// Copyright 2023 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/common/theme.dart';
import 'package:provider_shopper/models/catalog.dart';
import 'package:provider_shopper/models/order.dart';
import 'package:provider_shopper/screens/menu.dart';
import 'package:provider_shopper/screens/order.dart';
import 'package:provider_shopper/screens/welcome.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(const MyApp());
}

const double windowWidth = 400;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Food Menu App');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(
        path: '/menu',
        builder: (context, state) => const MyMenu(),
        routes: [
          GoRoute(path: 'order', builder: (context, state) => const MyOrder()),
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, MenuModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => MenuModel()),
        // OrderModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, OrderModel depends
        // on MenuModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<MenuModel, OrderModel>(
          create: (context) => OrderModel(),
          update: (context, menuModel, order) {
            if (order == null) throw ArgumentError.notNull('order');
            order.menuModel = menuModel;
            return order;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Gourmet Delights Restaurant',
        theme: appTheme,
        routerConfig: router(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}