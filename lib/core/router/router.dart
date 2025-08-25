import 'package:appetit_admin/features/analytics/view/analytics_screen.dart';
import 'package:appetit_admin/features/marketing/view/marketing_screen.dart';
import 'package:appetit_admin/features/menu/view/screens/menu_screen.dart';
import 'package:appetit_admin/features/orders/view/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_state.dart';
import '../../widgets/widgets.dart';

final authState = AuthState();

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  refreshListenable: authState,

  // redirect: (context, state) {
  //   final loggedIn = authState.isLoggedIn;
  //   final loc = state.matchedLocation;
  //   final loggingIn = loc == '/login';
  //
  //   if (!loggedIn && !loggingIn) return '/login';
  //   if (loggedIn && loggingIn) return '/menu';
  //   return null;
  // },

  initialLocation: '/menu',

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Scaffold(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Панель')),
          drawer: const AppDrawer(),
          body: child,
        );
      },
      routes: [
        GoRoute(path: '/menu', builder: (c, s) => const MenuScreen()),
        GoRoute(path: '/orders', builder: (c, s) => const OrdersScreen()),
        GoRoute(path: '/analytics', builder: (c, s) => const AnalyticsScreen()),
        GoRoute(path: '/marketing', builder: (c, s) => const MarketingScreen()),
      ],
    ),
  ],

);