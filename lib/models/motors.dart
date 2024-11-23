import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

class _Motor extends BaseModel {
  // keys should match what we expect to have to parse
  _Motor(String instance)
      : super({
          'Vehicle.PowerTrain.ElectricMotor.$instance.MaxPower': '0',
          'Vehicle.PowerTrain.ElectricMotor.$instance.MaxTorque': '0',
          'Vehicle.PowerTrain.ElectricMotor.$instance.MaxRegenPower': '0',
          'Vehicle.PowerTrain.ElectricMotor.$instance.MaxRegenTorque': '0',
          'Vehicle.PowerTrain.ElectricMotor.$instance.Speed': '0',
          'Vehicle.PowerTrain.ElectricMotor.$instance.Temperature': '0',
          'Vehicle.PowerTrain.ElectricMotor.$instance.Power': '0',
          'Vehicle.PowerTrain.ElectricMotor.$instance.Torque': '0',
          'Vehicle.Powertrain.ElectricMotor.$instance.ControllerVoltage': '0.0',
          // Used to be .MotorTemp but temperature fetching has been changed a little
        });

}

// create classes for both motors so we can have separate providers
class LeftMotor extends _Motor {
  LeftMotor() : super('MotorLeft');

  double get leftMotorTemp => double.parse(data['Vehicle.Powertrain.ElectricMotor.MotorLeft.ControllerVoltage']);
  
  @override
  ChangeNotifierProvider<LeftMotor> get provider =>
      ChangeNotifierProvider.value(value: this);
}

class RightMotor extends _Motor {
  RightMotor() : super('MotorRight');

  @override
  ChangeNotifierProvider<RightMotor> get provider =>
      ChangeNotifierProvider.value(value: this);
}
