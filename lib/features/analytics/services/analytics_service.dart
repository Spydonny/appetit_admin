import '../../../core/di/di.dart';
import '../../../core/router/token_notifier.dart';
import '../data/data.dart';
class AnalyticsService {
  final AnalyticsRepo repo;

  AnalyticsService(this.repo);

  Future<AnalyticsSummary> getSummary({String? from, String? to}) =>
      repo.fetchSummary(from: from, to: to);

  Future<List<OrdersByPeriod>> getOrdersByPeriod(String period,
      {String? from, String? to}) =>
      repo.fetchOrdersByPeriod(period, from: from, to: to);

  Future<List<OrderSource>> getOrderSources({String? from, String? to}) =>
      repo.fetchOrderSources(from: from, to: to);

  Future<List<UTMSource>> getUTMSources({String? from, String? to}) =>
      repo.fetchUTMSources(from: from, to: to);
}
