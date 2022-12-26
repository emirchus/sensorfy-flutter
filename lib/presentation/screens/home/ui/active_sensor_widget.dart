import 'package:flutter/material.dart';
import 'package:flutter_censors_manager/application/providers/home_provider.dart';
import 'package:flutter_censors_manager/application/theme/colors.dart';
import 'package:flutter_censors_manager/presentation/common/no_glow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveSensorWidget extends ConsumerWidget {
  final List<String> sensors;

  const ActiveSensorWidget({super.key, this.sensors = const <String>[]});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final pageController = ref.watch(homeProvider.select((provider) => provider.censorsController));

    final changeGraphPage = ref.read(homeProvider.select((provider) => provider.changeGraphsPage));

    final sensorsLength = ref.watch(homeProvider.select((provider) => provider.availablesSensors.values.where((element) => element.isActive).length));

    final currentPage = ref.watch(homeProvider.select((provider) => provider.currentPage));

    return Container(
      width: width,
      height: 60,
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            SensifyGreen,
            SensifyGreen40,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(
          color: SensifyGreen40,
          width: 1,
        ),
      ),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: SensifyGreen30,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                "${sensors.length} Active",
              ),
            ),
          ),
          IconButton(
            onPressed: currentPage > 0
                ? () => {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    }
                : null,
            disabledColor: Colors.white.withOpacity(.4),
            icon: const Icon(Icons.keyboard_arrow_left),
            color: Colors.white,
          ),
          SizedBox(
            width: width * 0.3,
            height: 60,
            child: PageView(
              controller: pageController,
              scrollBehavior: NoGlowBehaviour(),
              onPageChanged: changeGraphPage,
              children: sensors
                  .map(
                    (sensor) => Center(
                      child: Text(
                        sensor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          IconButton(
            onPressed: currentPage < sensorsLength - 1
                ? () => {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    }
                : null,
            icon: const Icon(Icons.keyboard_arrow_right),
            color: Colors.white,
            disabledColor: Colors.white.withOpacity(.4),
          ),
        ],
      ),
    );
  }
}
