import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../widgets/widgets.dart';

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
  DateTimeRange? _selectedRange;
  DateFilterType? _selectedFilter = DateFilterType.month;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800; // 👉 условие для широкого экрана
        final crossAxisCount = isWide ? 2 : 1;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateFilter(Theme.of(context)),

              const SizedBox(height: 16),

              // 🔹 Метрики в ряд (автоматически подстраиваются)
              Row(
                children: [
                  Expanded(child: DefaultContainer(child: _buildMetric("Заказы", "128"))),
                  const SizedBox(width: 12),
                  Expanded(child: DefaultContainer(child: _buildMetric("Выручка", "₸ 356 000"))),
                  const SizedBox(width: 12),
                  Expanded(child: DefaultContainer(child: _buildMetric("Средний чек", "₸ 2780"))),
                ],
              ),

              const SizedBox(height: 16),

              // 🔹 Сетка для графиков
              GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _chartContainer(
                    "Источники заказов",
                    PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(value: 40, title: "Прямые", color: Colors.blue),
                          PieChartSectionData(value: 30, title: "Instagram", color: Colors.purple),
                          PieChartSectionData(value: 20, title: "Поиск", color: Colors.orange),
                          PieChartSectionData(value: 10, title: "Рефералы", color: Colors.green),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  _chartContainer(
                    "Повторные заказы",
                    BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text("Новые");
                                  case 1:
                                    return const Text("Повторные");
                                }
                                return const Text("");
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 80, color: Colors.grey)]),
                          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 120, color: Colors.blue)]),
                        ],
                      ),
                    ),
                  ),
                  _chartContainer(
                    "Популярные блюда",
                    LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
                          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.red,
                            spots: const [
                              FlSpot(0, 20),
                              FlSpot(1, 50),
                              FlSpot(2, 80),
                              FlSpot(3, 60),
                              FlSpot(4, 90),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chartContainer(String title, Widget chart) {
    return DefaultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.6, // чтобы графики не растягивались странно
            child: chart,
          ),
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
              }
            },
          ),
        ),
      ],
    );
  }
}
