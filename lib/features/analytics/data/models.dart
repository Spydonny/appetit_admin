import 'package:equatable/equatable.dart';

class AnalyticsSummary extends Equatable {
  final int totalOrders;
  final double totalRevenue;
  final int totalUsers;
  final int activeUsers;
  final double avgOrderValue;
  final int ordersToday;
  final double revenueToday;

  const AnalyticsSummary({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalUsers,
    required this.activeUsers,
    required this.avgOrderValue,
    required this.ordersToday,
    required this.revenueToday,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      totalOrders: json["total_orders"] ?? 0,
      totalRevenue: (json["total_revenue"] ?? 0).toDouble(),
      totalUsers: json["total_users"] ?? 0,
      activeUsers: json["active_users"] ?? 0,
      avgOrderValue: (json["avg_order_value"] ?? 0).toDouble(),
      ordersToday: json["orders_today"] ?? 0,
      revenueToday: (json["revenue_today"] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props =>
      [totalOrders, totalRevenue, totalUsers, activeUsers, avgOrderValue, ordersToday, revenueToday];
}

class OrdersByPeriod extends Equatable {
  final String period;
  final int ordersCount;
  final double revenue;
  final double avgOrderValue;

  const OrdersByPeriod({
    required this.period,
    required this.ordersCount,
    required this.revenue,
    required this.avgOrderValue,
  });

  factory OrdersByPeriod.fromJson(Map<String, dynamic> json) {
    return OrdersByPeriod(
      period: json["period"],
      ordersCount: json["orders_count"] ?? 0,
      revenue: (json["revenue"] ?? 0).toDouble(),
      avgOrderValue: (json["avg_order_value"] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [period, ordersCount, revenue, avgOrderValue];
}

class OrderSource extends Equatable {
  final String type;
  final int count;
  final double total;
  final double percentage;

  const OrderSource({
    required this.type,
    required this.count,
    required this.total,
    required this.percentage,
  });

  factory OrderSource.fromJson(Map<String, dynamic> json) {
    return OrderSource(
      type: json["pickup_or_delivery"],
      count: json["count"] ?? 0,
      total: (json["total"] ?? 0).toDouble(),
      percentage: (json["percentage"] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [type, count, total, percentage];
}

class UTMSource extends Equatable {
  final String utmSource;
  final int ordersCount;
  final double revenue;
  final double ordersPercentage;
  final double revenuePercentage;
  final double avgOrderValue;
  final List<String> campaigns;
  final int campaignCount;

  const UTMSource({
    required this.utmSource,
    required this.ordersCount,
    required this.revenue,
    required this.ordersPercentage,
    required this.revenuePercentage,
    required this.avgOrderValue,
    required this.campaigns,
    required this.campaignCount,
  });

  factory UTMSource.fromJson(Map<String, dynamic> json) {
    return UTMSource(
      utmSource: json["utm_source"],
      ordersCount: json["orders_count"] ?? 0,
      revenue: (json["revenue"] ?? 0).toDouble(),
      ordersPercentage: (json["orders_percentage"] ?? 0).toDouble(),
      revenuePercentage: (json["revenue_percentage"] ?? 0).toDouble(),
      avgOrderValue: (json["avg_order_value"] ?? 0).toDouble(),
      campaigns: List<String>.from(json["campaigns"] ?? []),
      campaignCount: json["campaign_count"] ?? 0,
    );
  }

  @override
  List<Object?> get props =>
      [utmSource, ordersCount, revenue, ordersPercentage, revenuePercentage, avgOrderValue, campaigns, campaignCount];
}
