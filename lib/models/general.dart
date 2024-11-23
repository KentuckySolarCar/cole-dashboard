import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

//TODO assess whether this stuff is gonna be used for anything other than the initial widget
enum DriveMode { forward, reverse }

class CarStatus extends BaseModel {
  CarStatus()
      : super({
          'array_status': '0',
          'drive_mode': '0',
          'regen_status': '0',
          'wheel_pedal': '0',
          'Vehicle.Chassis.Accelerator.PedalPosition': '0',
          'Vehicle.Chassis.Brake.PedalPosition': '0',
        });

  // bool get isArrayEnabled => data['array_status'] == 1;

  // bool get isRegenEnabled => data['regen_status'] == 1;

  // DriveMode get driveMode => data['drive_mode'] == 1 ? DriveMode.forward : DriveMode.reverse;

  // bool get triggerControlEnabled => data['wheel_pedal'] == 0;

  int get accelerator => int.parse(data['Vehicle.Chassis.Accelerator.PedalPosition']!);

  int get brake => int.parse(data['Vehicle.Chassis.Brake.PedalPosition']!);

  @override
  ChangeNotifierProvider<CarStatus> get provider => ChangeNotifierProvider.value(value: this);
}

// As of now we need a different method from the one Cole wrote to fetch time
// Thus we have created the timing model

// class CarTime extends BaseModel {
//   CarTime() : super({'time': 0, 'last_bottom_shell_power_cycle': 0, 'lap_time': 0});
//
//   DateTime get time => DateTime.fromMillisecondsSinceEpoch(data['time']);
//
//   Duration get bottomShellPowerCycle => Duration(milliseconds: data['last_bottom_shell_power_cycle']);
//
//   Duration get lapTime => Duration(milliseconds: data['lap_time']);
//
//   @override
//   ChangeNotifierProvider<CarTime> get provider => ChangeNotifierProvider.value(value: this);
// }
