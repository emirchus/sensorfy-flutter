// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_censors_manager/core/enum/sensors.dart';

class Sensor<T> {
  final IconData icon;
  final String name;
  final SensorsTypes type;
  bool isActive;
  Stream<T> listener;

  Sensor({
    required this.icon,
    required this.name,
    required this.type,
    required this.isActive,
    required this.listener
  });
}
