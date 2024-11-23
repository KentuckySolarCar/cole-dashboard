import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';
// Provides car status information i.e. stuff like the car being in forward or reverse.
class Status extends BaseModel {
  Status() : super({
    'Vehicle.Chassis.WheelPedal' : 'pedal',
    'Vehicle.Chassis.ForwardReverse' : '0',
    //Brake lockout goes here
  });

  bool get forwardReverse => int.parse(data['Vehicle.Chassis.ForwardReverse']) == 0;
  bool get wheelPedal => data['Vehicle.Chassis.WheelPedal'] == 'pedal';
  bool get brakeLockout => true;

  @override
  ChangeNotifierProvider<Status> get provider =>
      ChangeNotifierProvider.value(value: this);
}
