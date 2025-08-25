import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Навигация',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.restaurant_menu,
            title: 'Меню',
            route: '/menu',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.shopping_cart,
            title: 'Заказы',
            route: '/orders',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.analytics,
            title: 'Аналитика',
            route: '/analytics',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.campaign,
            title: 'Маркетинг',
            route: '/marketing',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // закрыть Drawer
        context.go(route);
      },
    );
  }
}


