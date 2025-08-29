import 'package:appetit_admin/core/router/token_notifier.dart';
import 'package:appetit_admin/features/analytics/data/analytics_repo.dart';
import 'package:appetit_admin/features/analytics/services/analytics_service.dart';
import 'package:appetit_admin/features/auth/data/data.dart';
import 'package:appetit_admin/features/marketing/data/data.dart';
import 'package:appetit_admin/features/marketing/service/marketing_service.dart';
import 'package:appetit_admin/features/menu/data/data.dart';
import 'package:appetit_admin/features/menu/services/menu_services.dart';
import 'package:appetit_admin/features/orders/data/data.dart';
import 'package:appetit_admin/features/orders/services/order_service.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/services/auth_service.dart';

final getIt = GetIt.instance;

const baseUrl = 'http://127.0.0.1:8000/api/v1';

Future<void> dependencyInjection() async {
  getIt.registerCachedFactory(() => AuthService(AuthRepo(baseUrl: baseUrl)));

  getIt.registerCachedFactory(() => MenuService(MenuRepo(baseUrl: baseUrl)));
  
  getIt.registerCachedFactory(() => OrderService(OrderRepo(baseUrl: baseUrl)));

  getIt.registerCachedFactory(() => AnalyticsService(AnalyticsRepo(baseUrl:baseUrl)));

  getIt.registerCachedFactory(() => MarketingService(
      promoRepo: PromoRepo(baseUrl: baseUrl),
      pushRepo: PushRepo(baseUrl: baseUrl))
  );

  getIt.registerSingleton(TokenNotifier());
}