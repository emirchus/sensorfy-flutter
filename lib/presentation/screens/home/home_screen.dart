import 'package:flutter/material.dart';
import 'package:flutter_censors_manager/application/providers/home_provider.dart';
import 'package:flutter_censors_manager/presentation/screens/home/ui/active_sensor_widget.dart';
import 'package:flutter_censors_manager/presentation/common/appbar.dart';
import 'package:flutter_censors_manager/presentation/common/graph_container.dart';
import 'package:flutter_censors_manager/presentation/common/no_glow.dart';
import 'package:flutter_censors_manager/presentation/screens/home/ui/sensor_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(homeProvider.select((provider) => provider.graphsController));
    final changeCensorPage = ref.read(homeProvider.select((provider) => provider.changeCensorsPage));

    final sensors = ref.watch(homeProvider.select((provider) => provider.availablesSensors.values.toList()));
    var activeSensors = sensors.where((element) => element.isActive).toList();
    return Scaffold(
      body: SafeArea(
        top: true,
        child: CustomScrollView(
          scrollBehavior: NoGlowBehaviour(),
          slivers: [
            const SliverPersistentHeader(
              pinned: true,
              delegate: CustomAppbar(
                title: "Sensify",
              ),
            ),
            SliverToBoxAdapter(
              child: ActiveSensorWidget(
                sensors: activeSensors.map((e) => e.name).toList(),
              ),
            ),
            if (activeSensors.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: PageView(
                    scrollBehavior: NoGlowBehaviour(),
                    controller: pageController,
                    onPageChanged: changeCensorPage,
                    children: activeSensors
                        .map(
                          (e) => GraphContainer(
                            sensor: e,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            const SliverPadding(
              padding: EdgeInsets.only(top: 20, left: 20, bottom: 5),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Available Sensors",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final sensor = sensors[index];
                    return SensorCard(
                      isAvailable: sensor.available,
                      icon: sensor.icon,
                      sensorName: sensor.name,
                      isActive: sensor.isActive,
                      onTap: () {
                        ref.read(homeProvider).changeSensorState(sensor.type);
                      },
                    );
                  },
                  childCount: sensors.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
