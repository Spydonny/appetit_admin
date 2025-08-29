import 'dart:convert';
import 'package:appetit_admin/core/router/token_notifier.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../core/di/di.dart';

// Models
class PromoGenerateRequest extends Equatable {
  final String prefix;
  final int length;
  final int count;
  final String kind;
  final double value;
  final bool active;
  final DateTime? validFrom;
  final DateTime? validTo;
  final int? maxRedemptions;
  final int? perUserLimit;
  final double? minSubtotal;

  const PromoGenerateRequest({
    required this.prefix,
    this.length = 6,
    this.count = 10,
    this.kind = 'percent',
    this.value = 10.0,
    this.active = true,
    this.validFrom,
    this.validTo,
    this.maxRedemptions,
    this.perUserLimit,
    this.minSubtotal,
  });

  Map<String, dynamic> toJson() => {
    'prefix': prefix,
    'length': length,
    'count': count,
    'kind': kind,
    'value': value,
    'active': active,
    if (validFrom != null) 'valid_from': validFrom!.toIso8601String(),
    if (validTo != null) 'valid_to': validTo!.toIso8601String(),
    if (maxRedemptions != null) 'max_redemptions': maxRedemptions,
    if (perUserLimit != null) 'per_user_limit': perUserLimit,
    if (minSubtotal != null) 'min_subtotal': minSubtotal,
  };

  @override
  List<Object?> get props => [
    prefix,
    length,
    count,
    kind,
    value,
    active,
    validFrom,
    validTo,
    maxRedemptions,
    perUserLimit,
    minSubtotal,
  ];
}

class PromoGenerateResponse extends Equatable {
  final int batchId;
  final int generated;
  final String prefix;
  final int length;

  const PromoGenerateResponse({
    required this.batchId,
    required this.generated,
    required this.prefix,
    required this.length,
  });

  factory PromoGenerateResponse.fromJson(Map<String, dynamic> json) {
    return PromoGenerateResponse(
      batchId: json['batch_id'] as int,
      generated: json['generated'] as int,
      prefix: json['prefix'] as String,
      length: json['length'] as int,
    );
  }

  @override
  List<Object> get props => [batchId, generated, prefix, length];
}

class PromoOut extends Equatable {
  final String code;
  final String kind;
  final double value;
  final bool active;
  final int usedCount;
  final DateTime? validFrom;
  final DateTime? validTo;
  final int? maxRedemptions;
  final int? perUserLimit;
  final double? minSubtotal;
  final DateTime createdAt;
  final int? createdBy;

  const PromoOut({
    required this.code,
    required this.kind,
    required this.value,
    required this.active,
    required this.usedCount,
    this.validFrom,
    this.validTo,
    this.maxRedemptions,
    this.perUserLimit,
    this.minSubtotal,
    required this.createdAt,
    this.createdBy,
  });

  factory PromoOut.fromJson(Map<String, dynamic> json) {
    return PromoOut(
      code: json['code'] as String,
      kind: json['kind'] as String,
      value: (json['value'] as num).toDouble(),
      active: json['active'] as bool,
      usedCount: json['used_count'] as int,
      validFrom: json['valid_from'] != null ? DateTime.parse(json['valid_from'] as String) : null,
      validTo: json['valid_to'] != null ? DateTime.parse(json['valid_to'] as String) : null,
      maxRedemptions: json['max_redemptions'] as int?,
      perUserLimit: json['per_user_limit'] as int?,
      minSubtotal: json['min_subtotal'] != null ? (json['min_subtotal'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    code,
    kind,
    value,
    active,
    usedCount,
    validFrom,
    validTo,
    maxRedemptions,
    perUserLimit,
    minSubtotal,
    createdAt,
    createdBy,
  ];
}

class PromoUpdate extends Equatable {
  final String? kind;
  final double? value;
  final bool? active;
  final DateTime? validFrom;
  final DateTime? validTo;
  final int? maxRedemptions;
  final int? perUserLimit;
  final double? minSubtotal;

  const PromoUpdate({
    this.kind,
    this.value,
    this.active,
    this.validFrom,
    this.validTo,
    this.maxRedemptions,
    this.perUserLimit,
    this.minSubtotal,
  });

  Map<String, dynamic> toJson() => {
    if (kind != null) 'kind': kind,
    if (value != null) 'value': value,
    if (active != null) 'active': active,
    if (validFrom != null) 'valid_from': validFrom!.toIso8601String(),
    if (validTo != null) 'valid_to': validTo!.toIso8601String(),
    if (maxRedemptions != null) 'max_redemptions': maxRedemptions,
    if (perUserLimit != null) 'per_user_limit': perUserLimit,
    if (minSubtotal != null) 'min_subtotal': minSubtotal,
  };

  @override
  List<Object?> get props => [
    kind,
    value,
    active,
    validFrom,
    validTo,
    maxRedemptions,
    perUserLimit,
    minSubtotal,
  ];
}

// Repository
class PromoRepo {
  final client = http.Client();
  final String baseUrl;

  PromoRepo({
    required this.baseUrl,
  });

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${getIt<TokenNotifier>().token}',
  };

  Future<PromoGenerateResponse> generatePromo(PromoGenerateRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/admin/promo/generate'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PromoGenerateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to generate promo: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<PromoOut>> listPromocodes({bool? active}) async {
    final uri = Uri.parse('$baseUrl/admin/promo').replace(
      queryParameters: active != null ? {'active': active.toString()} : null,
    );
    final response = await client.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => PromoOut.fromJson(json)).toList();
    } else {
      throw Exception('Failed to list promocodes: ${response.statusCode} ${response.body}');
    }
  }

  Future<PromoOut> getPromocode(String code) async {
    final response = await client.get(
      Uri.parse('$baseUrl/admin/promo/$code'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return PromoOut.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get promocode: ${response.statusCode} ${response.body}');
    }
  }

  Future<PromoOut> updatePromocode(String code, PromoUpdate payload) async {
    final response = await client.put(
      Uri.parse('$baseUrl/admin/promo/$code'),
      headers: _headers,
      body: jsonEncode(payload.toJson()),
    );

    if (response.statusCode == 200) {
      return PromoOut.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update promocode: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> deletePromocode(String code) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/admin/promo/$code'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete promocode: ${response.statusCode} ${response.body}');
    }
  }
}