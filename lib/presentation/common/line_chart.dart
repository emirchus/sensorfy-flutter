import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_censors_manager/application/theme/colors.dart';

List<Color> colors = [GoalGreen, GoalCarrot, GoalRed, GoalYellow];

class LineChartContainer extends StatelessWidget {
  final List<LineChartBarData> data;

  const LineChartContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(
          border:  const Border(
            left: BorderSide(color: darkGrey, width: 1),
            bottom: BorderSide(color: darkGrey, width: 1),
          ),
          show: true,
        ),
        lineTouchData: LineTouchData(
          enabled: false,
        ),
        clipData: FlClipData.all(),
        minX: 0,
        minY: 0,
        lineBarsData: data,
      ),
      swapAnimationCurve: Curves.easeInOut,
      swapAnimationDuration: const Duration(milliseconds: 700),
    );
  }
}
