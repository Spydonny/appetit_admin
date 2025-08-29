import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/di/di.dart';
import '../../../core/router/token_notifier.dart';
import 'models.dart';

class AnalyticsRepo {
  final String baseUrl;
  final http.Client client;

  AnalyticsRepo({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${getIt<TokenNotifier>().token}",
  };

  Future<AnalyticsSummary> fetchSummary({String? from, String? to}) async {
    final uri = Uri.parse("$baseUrl/admin/analytics/summary").replace(
      queryParameters: {
        if (from != null) "from": from,
        if (to != null) "to": to,
      },
    );

    final resp = await client.get(uri, headers: _headers);
    if (resp.statusCode != 200) throw Exception("Failed: ${resp.body}");
    return AnalyticsSummary.fromJson(jsonDecode(resp.body));
  }

  Future<List<OrdersByPeriod>> fetchOrdersByPeriod(
      String period, {
        String? from,
        String? to,
      }) async {
    final uri = Uri.parse("$baseUrl/admin/analytics/orders-by-period").replace(
      queryParameters: {
        "period": period,
        if (from != null) "from": from,
        if (to != null) "to": to,
      },
    );

    final resp = await client.get(uri, headers: _headers);
    if (resp.statusCode != 200) throw Exception("Failed: ${resp.body}");
    final data = jsonDecode(resp.body) as List;
    return data.map((e) => OrdersByPeriod.fromJson(e)).toList();
  }

  Future<List<OrderSource>> fetchOrderSources({String? from, String? to}) async {
    final uri = Uri.parse("$baseUrl/admin/analytics/order-sources").replace(
      queryParameters: {
        if (from != null) "from": from,
        if (to != null) "to": to,
      },
    );

    final resp = await client.get(uri, headers: _headers);
    if (resp.statusCode != 200) throw Exception("Failed: ${resp.body}");
    final data = jsonDecode(resp.body) as List;
    return data.map((e) => OrderSource.fromJson(e)).toList();
  }

  Future<List<UTMSource>> fetchUTMSources({String? from, String? to}) async {
    final uri = Uri.parse("$baseUrl/admin/analytics/utm-sources").replace(
      queryParameters: {
        if (from != null) "from": from,
        if (to != null) "to": to,
      },
    );

    final resp = await client.get(uri, headers: _headers);
    if (resp.statusCode != 200) throw Exception("Failed: ${resp.body}");
    final json = jsonDecode(resp.body);
    final sources = (json["sources"] as List);
    return sources.map((e) => UTMSource.fromJson(e)).toList();
  }
}
