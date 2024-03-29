import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

/// Displays detailed information about a Book
class LightSensorView extends StatelessWidget {
  const LightSensorView({super.key});

  static const routeName = '/light_sensor';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: LightSensor.luxStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  // space
                  const SizedBox(height: 250),
                  Text(
                    'Lux: ${snapshot.data}',
                    textScaler: TextScaler.linear(4),
                  ),
                  (snapshot.data! < 50)
                      ? Text(
                          'Zbyt ciemno',
                          textScaler: TextScaler.linear(2),
                          style: TextStyle(color: Colors.red),
                        )
                      : Text(
                          'Wystarczająco jasno',
                          textScaler: TextScaler.linear(2),
                          style: TextStyle(color: Colors.green),
                        ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
