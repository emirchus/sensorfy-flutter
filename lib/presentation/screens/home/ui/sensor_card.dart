import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_censors_manager/application/theme/colors.dart';

class SensorCard extends StatelessWidget {
  final IconData icon;
  final String sensorName;
  final bool isActive;
  final bool isAvailable;
  final VoidCallback onTap;

  const SensorCard({
    super.key,
    required this.icon,
    required this.sensorName,
    required this.isActive,
    required this.onTap,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = isActive ? kSensifyGreen : darkSurfaceColor;
    Color borderColor = isActive ? kSensifyGreen : darkSurfaceColor;

    return Opacity(
      opacity: isAvailable ? 1 : .5,
      child: IgnorePointer(
        ignoring: !isAvailable,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                primaryColor.withOpacity(.03),
                primaryColor.withOpacity(.1),
              ],
              center: const Alignment(-1, -1),
              radius: 1.5,
            ),
            border: Border.all(
              color: borderColor.withOpacity(isActive ? .1 : 1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    border: Border.all(
                      color: Colors.white10,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white38,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                sensorName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isActive ? const Text("Running") : const SizedBox(),
                  SizedBox(
                    width: 40,
                    child: FittedBox(
                      child: CupertinoSwitch(
                        value: isActive,
                        onChanged: (_) {
                          onTap();
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
