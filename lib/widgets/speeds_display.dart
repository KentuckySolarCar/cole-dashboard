import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/speed.dart';
import 'package:uksc_dashboard/models/cruise_control.dart';

// Class that builds the two speed displays
const double speedWidth = 160;

class SpeedDisplay extends StatelessWidget {
  const SpeedDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSpeedDisplay(context),
          const SizedBox(height: 30),
          _buildCCSpeedDisplay(context),
        ],
      ),
    );
  }

  // Widget that displays the speed
  Widget _buildSpeedDisplay(BuildContext context) {
    return Consumer<Speed>(
      builder: (context, speed, child) {
        // Indicate to driver speed limit
        Color textColor;
        if (speed.mph >= 60) {
          textColor = Colors.yellow;
          if (speed.mph > 65) {
            textColor = Colors.red;
          }
        } else {
          textColor = Colors.white;
        }

        // Display one decimal point when below 10 mph and none when above
        String displaySpeed = speed.mph.abs() <= 9.9
            ? speed.mph.abs().toStringAsFixed(1)
            : speed.mph.abs().toStringAsFixed(0);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white, width: 2),
          ),
          padding: const EdgeInsets.all(10),
          width: speedWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Speed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    displaySpeed,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 90,
                child: const Text(
                  'mph',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget that displays the CC speed only when it is enabled
  Widget _buildCCSpeedDisplay(BuildContext context) {
    return Consumer<CruiseControl>(
      builder: (context, cruiseControl, child) {
        // Pull cc speed setting
        String displayCCSpeed =
            cruiseControl.enabled ? cruiseControl.setPoint.toStringAsFixed(0) : 'N/A';
        double fontSize = 40;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white, width: 2),
          ),
          padding: const EdgeInsets.all(10),
          width: speedWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Cruise Speed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    displayCCSpeed,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 60,
                child: const Text(
                  'mph',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
