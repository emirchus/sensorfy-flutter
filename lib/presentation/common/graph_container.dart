import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_censors_manager/application/providers/home_provider.dart';
import 'package:flutter_censors_manager/application/theme/colors.dart';
import 'package:flutter_censors_manager/core/abstract/sensor.dart';
import 'package:flutter_censors_manager/presentation/common/line_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slidable_line_chart/slidable_line_chart.dart';

enum CoordinateType {
  left,
  right,
}

class GraphContainer extends ConsumerStatefulWidget {
  final Sensor sensor;

  const GraphContainer({super.key, required this.sensor});

  @override
  ConsumerState<GraphContainer> createState() => _GraphContainerState();
}

class _GraphContainerState extends ConsumerState<GraphContainer> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final size = MediaQuery.of(context).size;

    final width = size.width;
    final graphHeight = width * 9 / 16;
    final radius = graphHeight * 0.1;

    final data = ref.watch(homeProvider.select((value) => value.sensorData[widget.sensor.type]));

    if (data == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      width: width,
      height: graphHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: darkSurfaceColor,
          width: 2,
        ),
        gradient: LinearGradient(
          colors: [darkSurfaceColor, darkBackgroundColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SizedBox(
        width: width,
        height: graphHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 10,
            left: 20,
            right: 20,
          ),
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.sensor.name,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: LineChartContainer(
                  data: [
                    LineChartBarData(
                      spots: data.map((e) {
                        final remaningTime = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(e.timestamp)).inSeconds;

                        final x = 100.0 - remaningTime;

                        final y = e.x + 50;

                        return FlSpot(x, y);
                      }).toList(),
                      isCurved: false,
                      barWidth: 1,
                      isStrokeCapRound: false,
                      dotData: FlDotData(
                        show: false,
                      ),
                      color: GoalGreen,
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: data.map((e) {
                        final remaningTime = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(e.timestamp)).inSeconds;

                        final x = 100.0 - remaningTime;

                        final y = e.y + 30;

                        return FlSpot(x, y);
                      }).toList(),
                      isCurved: false,
                      barWidth: 1,
                      isStrokeCapRound: false,
                      dotData: FlDotData(
                        show: false,
                      ),
                      color: GoalCarrot,
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: data.map((e) {
                        final remaningTime = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(e.timestamp)).inSeconds;

                        final x = 100.0 - remaningTime;

                        final y = e.z + 10;

                        return FlSpot(x, y);
                      }).toList(),
                      isCurved: false,
                      barWidth: 1,
                      isStrokeCapRound: false,
                      dotData: FlDotData(
                        show: false,
                      ),
                      color: GoalYellow,
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
