import 'dart:convert';
import 'package:appetit_admin/core/core.dart';
import 'package:appetit_admin/core/router/token_notifier.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

// Models
class AdminPushTargeting extends Equatable {
  final String audience;
  final String? topic;
  final String? platform;
  final String? userRole;
  final bool? verifiedOnly;
  final int? maxDevices;

  const AdminPushTargeting({
    this.audience = 'all',
    this.topic,
    this.platform,
    this.userRole,
    this.verifiedOnly,
    this.maxDevices,
  });

  Map<String, dynamic> toJson() => {
    'audience': audience,
    if (topic != null) 'topic': topic,
    if (platform != null) 'platform': platform,
    if (userRole != null) 'user_role': userRole,
    if (verifiedOnly != null) 'verified_only': verifiedOnly,
    if (maxDevices != null) 'max_devices': maxDevices,
  };

  factory AdminPushTargeting.fromJson(Map<String, dynamic> json) {
    return AdminPushTargeting(
      audience: json['audience'] as String,
      topic: json['topic'] as String?,
      platform: json['platform'] as String?,
      userRole: json['user_role'] as String?,
      verifiedOnly: json['verified_only'] as bool?,
      maxDevices: json['max_devices'] as int?,
    );
  }

  @override
  List<Object?> get props => [audience, topic, platform, userRole, verifiedOnly, maxDevices];
}

class AdminPushRequest extends Equatable {
  final String title;
  final String body;
  final AdminPushTargeting targeting;
  final Map<String, String>? data;
  final String priority;
  final int? ttl;
  final bool dryRun;

  const AdminPushRequest({
    required this.title,
    required this.body,
    this.targeting = const AdminPushTargeting(),
    this.data,
    this.priority = 'normal',
    this.ttl,
    this.dryRun = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'targeting': targeting.toJson(),
    if (data != null) 'data': data,
    'priority': priority,
    if (ttl != null) 'ttl': ttl,
    'dry_run': dryRun,
  };

  @override
  List<Object?> get props => [title, body, targeting, data, priority, ttl, dryRun];
}

class PushResult extends Equatable {
  final String? token;
  final bool success;
  final String? messageId;
  final String? error;

  const PushResult({
    this.token,
    required this.success,
    this.messageId,
    this.error,
  });

  factory PushResult.fromJson(Map<String, dynamic> json) {
    return PushResult(
      token: json['token'] as String?,
      success: json['success'] as bool,
      messageId: json['message_id'] as String?,
      error: json['error'] as String?,
    );
  }

  @override
  List<Object?> get props => [token, success, messageId, error];
}

class AdminPushResponse extends Equatable {
  final String status;
  final int sent;
  final int failed;
  final int total;
  final String targetingMethod;
  final String timestamp;
  final String? messageId;
  final String? topic;
  final List<String>? errors;
  final List<PushResult>? results;
  final String? reason;

  const AdminPushResponse({
    required this.status,
    required this.sent,
    required this.failed,
    required this.total,
    required this.targetingMethod,
    required this.timestamp,
    this.messageId,
    this.topic,
    this.errors,
    this.results,
    this.reason,
  });

  factory AdminPushResponse.fromJson(Map<String, dynamic> json) {
    return AdminPushResponse(
      status: json['status'] as String,
      sent: json['sent'] as int,
      failed: json['failed'] as int,
      total: json['total'] as int,
      targetingMethod: json['targeting_method'] as String,
      timestamp: json['timestamp'] as String,
      messageId: json['message_id'] as String?,
      topic: json['topic'] as String?,
      errors: (json['errors'] as List<dynamic>?)?.cast<String>(),
      results: (json['results'] as List<dynamic>?)?.map((e) => PushResult.fromJson(e as Map<String, dynamic>)).toList(),
      reason: json['reason'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sent,
    failed,
    total,
    targetingMethod,
    timestamp,
    messageId,
    topic,
    errors,
    results,
    reason,
  ];
}

class AdminSmsRequest extends Equatable {
  final String message;
  final String audience;

  const AdminSmsRequest({
    required this.message,
    this.audience = 'all',
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'audience': audience,
  };

  @override
  List<Object> get props => [message, audience];
}

class AdminSmsResponse extends Equatable {
  final int sent;

  const AdminSmsResponse({
    required this.sent,
  });

  factory AdminSmsResponse.fromJson(Map<String, dynamic> json) {
    return AdminSmsResponse(
      sent: json['sent'] as int,
    );
  }

  @override
  List<Object> get props => [sent];
}

// Repository
class PushRepo {
  final client = http.Client();
  final String baseUrl;

  PushRepo({
    required this.baseUrl,
  });

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${getIt<TokenNotifier>().token}',
  };

  Future<AdminPushResponse> sendPush(AdminPushRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/admin/push/send'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AdminPushResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send push: ${response.statusCode} ${response.body}');
    }
  }

  Future<AdminSmsResponse> sendSms(AdminSmsRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/admin/push/send-sms'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AdminSmsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send SMS: ${response.statusCode} ${response.body}');
    }
  }
}