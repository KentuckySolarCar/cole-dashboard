import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

class Battery extends BaseModel {
  // Motor current is gonna need to be pulled from the motor model EXCEPT you can lowkey do whatever you want so I just put it here
  Battery()
      : super({
          'Vehicle.Powertrain.TractionBattery.StateOfCharge.PackSOC': '0',
          'Vehicle.Powertrain.TractionBattery.PackCurrent': '0.0',
          'Vehicle.Powertrain.TractionBattery.CurrentVoltage': '0,0',
          'Vehicle.Powertrain.ElectricMotor.MotorLeft.ControllerCurrent': '0.0', //TODO figure out why the logs never set this value to not 0
          'Vehicle.Powertrain.TractionBattery.AverageTemp' : '0',
          'Vehicle.LowVoltageBattery.CurrentVoltage' : '0.0',
        });

  double get stateOfCharge => double.parse(data['Vehicle.Powertrain.TractionBattery.StateOfCharge.PackSOC']);
  String get packVoltage => data['Vehicle.Powertrain.TractionBattery.CurrentVoltage'];
  double get packCurrent => double.parse(data['Vehicle.Powertrain.TractionBattery.PackCurrent']);
  double get controllerCurrent => double.parse(data['Vehicle.Powertrain.ElectricMotor.MotorLeft.ControllerCurrent']); //thus this is always 0
  double get orionAverageTemp => double.parse(data['Vehicle.Powertrain.TractionBattery.AverageTemp']);
  String get auxPackVoltage => data['Vehicle.LowVoltageBattery.CurrentVoltage'];

 @override
  ChangeNotifierProvider<Battery> get provider =>
      ChangeNotifierProvider.value(value: this);
}