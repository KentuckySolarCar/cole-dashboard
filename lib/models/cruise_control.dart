import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

class CruiseControl extends BaseModel {
  CruiseControl()
      : super({
          'Vehicle.ADAS.CruiseControl.SpeedSet': '0.0',
          'Vehicle.ADAS.CruiseControl.IsActive': 'false',
          'Vehicle.ADAS.CruiseControl.IsEnabled' : '1'
        });

  /// The set point in mph
  double get setPoint => double.parse(data['Vehicle.ADAS.CruiseControl.SpeedSet']!);
  // testing line - double get setPoint => 10;

  /// Whether cruise control is actively in control of modulating speed
  bool get active => data['Vehicle.ADAS.CruiseControl.IsActive'] == '1';

  /// Whether cruise control is on (not set, inactive, not in control)
  bool get enabled => data['Vehicle.ADAS.CruiseControl.IsEnabled'] == '1';
  // testing line - bool get enabled => true;
  @override
  ChangeNotifierProvider<CruiseControl> get provider =>
      ChangeNotifierProvider.value(value: this);
}
