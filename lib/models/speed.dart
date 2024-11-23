import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

class Speed extends BaseModel {
  Speed() : super({'Vehicle.Speed': '0.0'});

  /// The speed of the car in mph.
  double get mph => double.parse(data['Vehicle.Speed']);
  //double get mph => 67;

  /// The speed of the car in km/h.
  // double get kmh => data['speed']! * 1.60934;
  //
  /// The speed of the car in m/s.
  // double get ms => data['speed']! * 0.44704;

  @override
  ChangeNotifierProvider<Speed> get provider =>
      ChangeNotifierProvider.value(value: this);
}
