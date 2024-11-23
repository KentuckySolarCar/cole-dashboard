import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

// Provider for all signals related to time.
class LapTimes {
  final List<double> _lapTimes = [];

  void addTime(double time) {
    _lapTimes.add(time);
  }

  double getBestLap() {
    return _lapTimes.isEmpty ? 0.0 : _lapTimes.reduce((a, b) => a < b ? a : b);
  }

  double getLastAddedLap() {
    return _lapTimes.isEmpty ? 0.0 : _lapTimes.last;
  }

  int getNumLaps() {
    return _lapTimes.length + 1;
  }

  int getBestLapIndex() {
    if (_lapTimes.isEmpty) {
      return -1; // Return -1 if there are no lap times
    }
    double bestLapTime = getBestLap();
    return _lapTimes.indexOf(bestLapTime) + 1;
  }

  List<double> get allLapTimes => List.unmodifiable(_lapTimes);
}
class Timing extends BaseModel {

  Timing()
      : super({
          'Vehicle.CurrentLocation.LapTime' : '0',
          'Vehicle.CurrentLocation.Timestamp' : '0',
        });

  double get lapTime => double.parse(data['Vehicle.CurrentLocation.LapTime']);
  double get unixTime => double.parse(data['Vehicle.CurrentLocation.Timestamp']);
  
  //double get lapTime => 3; //for testing

  final LapTimes lapTimes = LapTimes();

  // Example method to add a lap time (you would call this from your widget)
  void addLapTime(double time) {
    lapTimes.addTime(time);
  }

 @override
  ChangeNotifierProvider<Timing> get provider =>
      ChangeNotifierProvider.value(value: this);
}