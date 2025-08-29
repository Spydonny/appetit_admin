import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';

import '../../../widgets/widgets.dart';
import '../data/data.dart';
import '../services/analytics_service.dart';

enum DateFilterType { day, week, month }

extension DateFilterTypeExt on DateFilterType {
  String get label {
    switch (this) {
      case DateFilterType.day:
        return "День";
      case DateFilterType.week:
        return "Неделя";
      case DateFilterType.month:
        return "Месяц";
    }
  }
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _analyticsService = GetIt.I<AnalyticsService>();

  DateTimeRange? _selectedRange;
  DateFilterType? _selectedFilter = DateFilterType.month;

  AnalyticsSummary? _summary;
  List<OrderSource> _sources = [];
  List<OrdersByPeriod> _ordersByPeriod = [];
  List<UTMSource> _utmSources = [];

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final from = _selectedRange?.start.toIso8601String();
      final to = _selectedRange?.end.toIso8601String();

      final summary = await _analyticsService.getSummary(from: from, to: to);
      final sources = await _analyticsService.getOrderSources(from: from, to: to);
      final ordersByPeriod =
      await _analyticsService.getOrdersByPeriod("day", from: from, to: to);
      final utm = await _analyticsService.getUTMSources(from: from, to: to);

      setState(() {
        _summary = summary;
        _sources = sources;
        _ordersByPeriod = ordersByPeriod;
        _utmSources = utm;
      });
    } catch (e) {
      setState(() => _error = "Ошибка загрузки: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final crossAxisCount = isWide ? 2 : 1;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateFilter(Theme.of(context)),

              const SizedBox(height: 16),

              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_error != null)
                Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              else if (_summary != null) ...[
                  // 🔹 Метрики
                  Row(
                    children: [
                      Expanded(
                          child: DefaultContainer(
                              child: _buildMetric("Заказы", _summary!.totalOrders.toString()))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: DefaultContainer(
                              child: _buildMetric("Выручка", "₸ ${_summary!.totalRevenue.toStringAsFixed(0)}"))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: DefaultContainer(
                              child: _buildMetric("Средний чек", "₸ ${_summary!.avgOrderValue.toStringAsFixed(0)}"))),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Графики
                  GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _chartContainer("Источники заказов", _buildSourcesChart()),
                      _chartContainer("Заказы по дням", _buildOrdersLineChart()),
                      _chartContainer("UTM-источники", _buildUTMChart()),
                    ],
                  ),
                ],
            ],
          ),
        );
      },
    );
  }

  // ----------------- 🔹 UI ХЕЛПЕРЫ -----------------

  Widget _chartContainer(String title, Widget chart) {
    return DefaultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          AspectRatio(aspectRatio: 1.6, child: chart),
        ],
      ),
    );
  }

  Widget _buildMetric(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDateFilter(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: PillButton(
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 1),
                lastDate: now,
              );
              if (picked != null) {
                setState(() {
                  _selectedRange = picked;
                  _selectedFilter = null;
                });
                _loadData();
              }
            },
            child: Text(
              _selectedRange == null
                  ? "Выбрать период"
                  : "${DateFormat('dd.MM').format(_selectedRange!.start)} - ${DateFormat('dd.MM').format(_selectedRange!.end)}",
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: DropdownButton<DateFilterType>(
            isExpanded: true,
            value: _selectedFilter,
            items: DateFilterType.values
                .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                final now = DateTime.now();
                late DateTime start;

                switch (val) {
                  case DateFilterType.day:
                    start = DateTime(now.year, now.month, now.day);
                    break;
                  case DateFilterType.week:
                    start = now.subtract(Duration(days: now.weekday - 1));
                    break;
                  case DateFilterType.month:
                    start = DateTime(now.year, now.month, 1);
                    break;
                }

                setState(() {
                  _selectedFilter = val;
                  _selectedRange = DateTimeRange(start: start, end: now);
                });
                _loadData();
              }
            },
          ),
        ),
      ],
    );
  }

  // ----------------- 🔹 ГРАФИКИ -----------------

  /// PieChart по источникам заказов
  Widget _buildSourcesChart() {
    if (_sources.isEmpty) return const Center(child: Text("Нет данных"));
    return PieChart(
      PieChartData(
        sections: _sources.map((s) {
          return PieChartSectionData(
            value: s.percentage,
            title: "${s.type} (${s.percentage.toStringAsFixed(1)}%)",
            radius: 60,
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  /// LineChart по заказам за период
  Widget _buildOrdersLineChart() {
    if (_ordersByPeriod.isEmpty) return const Center(child: Text("Нет данных"));
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < 0 || index >= _ordersByPeriod.length) return const Text("");
                return Text(_ordersByPeriod[index].period);
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            spots: _ordersByPeriod.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.ordersCount.toDouble());
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// BarChart по UTM-источникам
  Widget _buildUTMChart() {
    if (_utmSources.isEmpty) return const Center(child: Text("Нет данных"));
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < 0 || index >= _utmSources.length) return const Text("");
                return Text(_utmSources[index].utmSource);
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _utmSources.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.revenue,
                color: Colors.green,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

