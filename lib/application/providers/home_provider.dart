import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_censors_manager/core/abstract/sensor.dart';
import 'package:flutter_censors_manager/core/abstract/sensor_data.dart';
import 'package:flutter_censors_manager/core/enum/sensors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeNotifier extends ChangeNotifier {
  int currentPage = 0;

  PageController censorsController = PageController(initialPage: 0);
  PageController graphsController = PageController(initialPage: 0);

  final Map<SensorsTypes, Sensor> availablesSensors = {};

  final Map<SensorsTypes, List<SensorData>> sensorData = {};

  final Map<SensorsTypes, StreamSubscription> sensorsStreams = {};

  HomeNotifier() {
    availablesSensors[SensorsTypes.accelerometer] = Sensor<AccelerometerEvent>(
      icon: Icons.speed_rounded,
      type: SensorsTypes.accelerometer,
      name: "Accelerometer",
      isActive: false,
      listener: accelerometerEvents,
    );

    availablesSensors[SensorsTypes.userAccelerometer] = Sensor(
      icon: Icons.speaker_phone_rounded,
      name: "UserAccelerometer",
      isActive: false,
      type: SensorsTypes.userAccelerometer,
      listener: userAccelerometerEvents,
    );

    availablesSensors[SensorsTypes.gyroscope] = Sensor(
      icon: Icons.compass_calibration_outlined,
      name: "Gyroscope",
      isActive: false,
      type: SensorsTypes.gyroscope,
      listener: gyroscopeEvents,
    );

    availablesSensors[SensorsTypes.magnetometer] = Sensor(
      icon: Icons.stay_current_portrait_outlined,
      name: "Magnetometer",
      isActive: false,
      type: SensorsTypes.magnetometer,
      listener: magnetometerEvents,
    );
  }

  void changeCensorsPage(int index) {
    currentPage = index;
    censorsController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    notify();
  }

  void changeGraphsPage(int index) {
    currentPage = index;
    graphsController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notify();
  }

  void notify() {
    notifyListeners();
  }

  void changeSensorState(SensorsTypes name) {
    availablesSensors[name]?.isActive = !availablesSensors[name]!.isActive;
    if (availablesSensors[name]?.isActive ?? false) {
      final sensor = availablesSensors[name]!;

      sensorData[name] = [
        SensorData(
          x: 0,
          y: 0,
          z: 0,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        )
      ];

      sensorsStreams[name] = sensor.listener.listen((event) {
        sensorData[name] ??= [];
        sensorData[name]?.add(SensorData(
          x: event.x,
          y: event.y,
          z: event.z,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));

        if (sensorData[name]!.length > 10000) {
          sensorData[name]!.removeAt(0);
        }
        notify();
      });
    } else {
      sensorData.remove(name);
      sensorsStreams[name]?.cancel();
      sensorsStreams.remove(name);
    }
    notify();
  }
}

final homeProvider = ChangeNotifierProvider<HomeNotifier>((ref) {
  return HomeNotifier();
});
