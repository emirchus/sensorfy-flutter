class SensorData {
  final int timestamp;
  final List<double> values;

  SensorData({required this.timestamp, required this.values});

  @override
  String toString() {
    return 'SensorData{timestamp: $timestamp}';
  }
}
