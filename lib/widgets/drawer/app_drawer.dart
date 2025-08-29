import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = _getMenuItems();

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
          for (final item in items)
            _buildDrawerItem(
              context,
              icon: item.icon,
              title: item.title,
              route: item.route,
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

  /// Все пункты меню для всех
  List<_DrawerItem> _getMenuItems() {
    return [
      _DrawerItem(Icons.restaurant_menu, 'Меню', '/menu'),
      _DrawerItem(Icons.shopping_cart, 'Заказы', '/orders'),
      _DrawerItem(Icons.analytics, 'Аналитика', '/analytics'),
      _DrawerItem(Icons.campaign, 'Маркетинг', '/marketing'),
      _DrawerItem(Icons.work_history, 'Сотрудники', '/employees'),
    ];
  }
}

class _DrawerItem {
  final IconData icon;
  final String title;
  final String route;

  const _DrawerItem(this.icon, this.title, this.route);
}
