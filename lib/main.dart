import 'package:flutter/material.dart';
import 'package:flutter_censors_manager/application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child:  Application(),
  ));
}
