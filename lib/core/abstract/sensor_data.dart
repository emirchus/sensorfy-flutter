class SensorData {
  final int timestamp;
  final double x;
  final double y;
  final double z;

  SensorData({required this.timestamp, required this.x, required this.y, required this.z});

  @override
  String toString() {
    return 'SensorData{timestamp: $timestamp, x: $x, y: $y, z: $z}';
  }
}
