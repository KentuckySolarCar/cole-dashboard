import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/timing.dart';
import 'package:uksc_dashboard/models/controls.dart';
const redLapTimeOffset = 5;

//TODO improve performance by reducing function calls
class TimeReadout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      width: 190,
      child: Consumer<Timing>(
        builder: (context, timing, child) {
          return Consumer<SteeringWheel>(
            builder: (context, steeringWheel, child) {
              // Display the last added lap time and best lap time
              //double carTime = timing.unixTime; // May not be used
              double lapTime = timing.lapTime;
              double lastLapTime = timing.lapTimes.getLastAddedLap();
              double bestLapTime = timing.lapTimes.getBestLap();
              int numLaps = timing.lapTimes.getNumLaps();
              int bestLapIndex = timing.lapTimes.getBestLapIndex();

              int recordedShortPressOffset = 1;

              // Color variables for changing colors
              Color lapTimeColor = Colors.white;
              Color lastLapTimeColor = Colors.cyan;

              //TODO debug this section here which updates the offset in the case that the car is reset but the dash is not
              //if (steeringWheel.buttonL.shortPresses + 1 < timing.lapTimes.getNumLaps()) {
              //  recordedShortPressOffset = (timing.lapTimes.getNumLaps() - steeringWheel.buttonL.shortPresses) + 1;
              //}
      
              // Update laptimes when shortpresses is more than the number of laps
              if (steeringWheel.buttonL.shortPresses + recordedShortPressOffset > timing.lapTimes.getNumLaps()){
                timing.addLapTime(lapTime);
              }
      
              // If your laptime runs over the previous laptime+offset then red lap
              if (lapTime >= lastLapTime+redLapTimeOffset) {
                lapTimeColor = Colors.red;
                if (numLaps < 2) {
                  lapTimeColor = Colors.white;
                }
              }
      
              // If your last laptime is also your best laptime gold lap
              if (lastLapTime == bestLapTime) {
                lastLapTimeColor = Colors.yellow;
                if (lastLapTime == 0) {
                  lastLapTimeColor = Colors.cyan;
                }
              }
      
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLapsReadout(context, 'Lap Number:', numLaps, Colors.orange),
                      SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTimeReadout(context, 'Current Lap:', lapTime, lapTimeColor),
                      SizedBox(height: 10),
                      _buildTimeReadout(context, 'Prev. Lap:', lastLapTime, lastLapTimeColor),
                      SizedBox(height: 10),
                      _buildTimeReadout(context, 'Best Lap:', bestLapTime, Colors.yellow),
                      SizedBox(height: 10),
                      _buildBestLapReadout(context, 'On lap', bestLapIndex)
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimeReadout(BuildContext context, String label, double value, Color readoutColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        Text(
          _formatTime(value),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: readoutColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLapsReadout(BuildContext context, String label, int value, Color readoutColor) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 5),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: readoutColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBestLapReadout(BuildContext context, String label, int value) {
    String realValue = value.toString();
    if (value == -1) {
      realValue = 'N/A';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 5),
        Text(
          realValue,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _formatTime(double value) {
    int minutes = (value % 3600) ~/ 60;
    int seconds = value.toInt() % 60;
    double milliseconds = value - value.toInt();

    String timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    if (milliseconds > 0) {
      String msString = (milliseconds * 1000).toStringAsFixed(0).padLeft(3, '0');
      timeString += '.${msString.substring(0, msString.length - 1)}'; // Trim last zero
    }
    // If laptime goes above an hour readout overflow since its overflowing
    // I dont think this is a big deal because we should never have a laptime more than like 30 minutes even on a pit lap
    if (value > 3600) {
      timeString = 'OVERFLOW';
    }

    return timeString;
  }
}