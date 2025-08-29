import 'dart:convert';
import 'package:appetit_admin/core/core.dart';
import 'package:appetit_admin/core/router/token_notifier.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart'; // тут лежат Order, OrderItem и т.д.

class OrderRepo {
  final String baseUrl;
  final client = http.Client();

  OrderRepo({required this.baseUrl});

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${getIt<TokenNotifier>().token}",
  };

  Future<List<Order>> getOrders({String? status, String? from, String? to}) async {
    final uri = Uri.parse('$baseUrl/admin/orders').replace(queryParameters: {
      if (status != null) 'status': status,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    });

    final response = await client.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to load orders: ${response.body}');
    }

    final List data = json.decode(response.body);
    return data.map((e) => Order.fromJson(e)).toList();
  }

  Future<Order> getOrder(int orderId) async {
    final uri = Uri.parse('$baseUrl/admin/orders/$orderId');
    final response = await client.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to load order: ${response.body}');
    }
    return Order.fromJson(json.decode(response.body));
  }

  Future<Order> updateStatus(int orderId, String status) async {
    final uri = Uri.parse('$baseUrl/admin/orders/$orderId/status');
    final response = await client.put(
      uri,
      headers: _headers,
      body: json.encode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status: ${response.body}');
    }
    return Order.fromJson(json.decode(response.body));
  }

  Future<void> deleteOrder(int orderId) async {
    final uri = Uri.parse('$baseUrl/admin/orders/$orderId');
    final response = await client.delete(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete order: ${response.body}');
    }
  }
}
