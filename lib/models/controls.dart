import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';
class Button {
  /// The name of this button.
  String name;

  /// The number of times the button has been long pressed.
  int longPresses;

  /// The number of times the button has been short pressed.
  int shortPresses;

  Button(this.name, this.longPresses, this.shortPresses);
}

//Since were not using the for loops to do the model this is unused for right now
const _buttonNames = [
  'ButtonX',
  'ButtonY',
  'ButtonA',
  'ButtonB',
  'ButtonL',
  'ButtonR',
  'RightTurn',
  'LeftTurn',
  'CruiseMain',
  'CruisePlus',
  'CruiseMinus'
];

class SteeringWheel extends BaseModel {
  //Map each buttonName to button_name_short and button_name_long for super call
  SteeringWheel() : super({
    'Vehicle.Chassis.SteeringWheel.ButtonX.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonX.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonY.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonY.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonA.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonA.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonB.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonB.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonL.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonL.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonR.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.ButtonR.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.RightTurn.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.RightTurn.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.LeftTurn.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.LeftTurn.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.CruiseMain.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.CruiseMain.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.CruisePlus.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.CruisePlus.ShortPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.CruiseMinus.LongPressCount': '0',
    'Vehicle.Chassis.SteeringWheel.CruiseMinus.ShortPressCount': '0',
  });

  //Defining button data members
  Button get buttonX => Button('ButtonX', int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonX.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonX.ShortPressCount']!));

  Button get buttonY => Button('ButtonY', int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonY.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonY.ShortPressCount']!));

  Button get buttonA => Button('ButtonA', int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonA.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonA.ShortPressCount']!));

  Button get buttonB => Button('ButtonB', int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonB.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonB.ShortPressCount']!));

  Button get buttonL => Button('ButtonL', int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonL.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonL.ShortPressCount']!)); //Laptime reset

  Button get buttonR => Button('ButtonR', int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonR.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.ButtonR.ShortPressCount']!));

  Button get buttonRightTurn => Button('RightTurn', int.parse(data['Vehicle.Chassis.SteeringWheel.RightTurn.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.RightTurn.ShortPressCount']!));

  Button get buttonLeftTurn => Button('LeftTurn', int.parse(data['Vehicle.Chassis.SteeringWheel.LeftTurn.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.LeftTurn.ShortPressCount']!));

  Button get buttonCruiseMain => Button('CruiseMain', int.parse(data['Vehicle.Chassis.SteeringWheel.CruiseMain.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.CruiseMain.ShortPressCount']!));

  Button get buttonCruisePlus => Button('CruisePlus', int.parse(data['Vehicle.Chassis.SteeringWheel.CruisePlus.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.CruisePlus.ShortPressCount']!));

  Button get buttonCruiseMinus => Button('CruiseMinus', int.parse(data['Vehicle.Chassis.SteeringWheel.CruiseMinus.LongPressCount']!), int.parse(data['Vehicle.Chassis.SteeringWheel.CruiseMinus.ShortPressCount']!));

  //Button get buttonL => Button('Button_L', 1, 1);

  @override
  ChangeNotifierProvider<SteeringWheel> get provider =>
      ChangeNotifierProvider.value(value: this);
}


class Pedals extends BaseModel {
  //Pedals get their own provider because there may be a throttle and brake pedal
  Pedals()
    : super({'Vehicle.Chassis.Accelerator.PedalPosition' : '0.0'});

    double get throttlePercentage => double.parse(data['Vehicle.Chassis.Accelerator.PedalPosition']);

  @override
  ChangeNotifierProvider<Pedals> get provider =>
      ChangeNotifierProvider.value(value: this);
}