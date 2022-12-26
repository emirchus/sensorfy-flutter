import 'dart:async';

import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_censors_manager/core/abstract/sensor.dart';
import 'package:flutter_censors_manager/core/abstract/sensor_data.dart';
import 'package:flutter_censors_manager/core/enum/sensors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

final List coordinatesEvents = [
  AccelerometerEvent,
  UserAccelerometerEvent,
  GyroscopeEvent,
  MagnetometerEvent,
];

final List numEvents = [
  double,
  int,
];

class HomeNotifier extends ChangeNotifier {
  int currentPage = 0;

  final EnvironmentSensors _environmentSensors = EnvironmentSensors();

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

    availablesSensors[SensorsTypes.proximity] = Sensor(
      icon: Icons.sensor_occupied_rounded,
      name: "Proximity",
      type: SensorsTypes.proximity,
      isActive: false,
      listener: ProximitySensor.events,
    );

    availablesSensors[SensorsTypes.temp] = Sensor(
      icon: Icons.thermostat_sharp,
      name: "Temperature",
      type: SensorsTypes.temp,
      isActive: false,
      listener: _environmentSensors.temperature,
    );

    availablesSensors[SensorsTypes.humidity] = Sensor(
      icon: Icons.h_mobiledata_outlined,
      name: "Humidity",
      type: SensorsTypes.humidity,
      isActive: false,
      listener: _environmentSensors.humidity,
    );

    availablesSensors[SensorsTypes.light] = Sensor(
      icon: Icons.lightbulb,
      name: "Light",
      type: SensorsTypes.light,
      isActive: false,
      listener: _environmentSensors.light,
    );

    availablesSensors[SensorsTypes.pressure] = Sensor(
      icon: Icons.radio_button_checked,
      name: "Pressure",
      type: SensorsTypes.pressure,
      isActive: false,
      listener: _environmentSensors.pressure,
    );

    availablesSensors[SensorsTypes.compass] = Sensor(
      icon: Icons.map_outlined,
      name: "Compass",
      type: SensorsTypes.compass,
      isActive: false,
      available: false,
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

      if (sensor.listener != null) {
        sensorsStreams[name] = sensor.listener!.listen((event) {
          sensorData[name] ??= [];

          if (coordinatesEvents.contains(event.runtimeType)) {
            sensorData[name]?.add(SensorData(
              values: [event.x, event.y, event.z],
              timestamp: DateTime.now().millisecondsSinceEpoch,
            ));
          } else if (numEvents.contains(event.runtimeType)) {
            sensorData[name]?.add(SensorData(
              values: [event + 0.0],
              timestamp: DateTime.now().millisecondsSinceEpoch,
            ));
          }

          if (sensorData[name]!.length > 1000) {
            sensorData[name]!.removeAt(0);
          }
          notify();
        });
      }
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
