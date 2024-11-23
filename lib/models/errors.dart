import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

//TODO Figure out how errors work on the car and implement

class Errors extends BaseModel {
  Errors()
      : super({
          'Vehicle.Chassis.SDStatus': '1',
        });

  bool get bottomShellError => double.parse(data['Vehicle.Chassis.SDStatus']) == 0;


 @override
  ChangeNotifierProvider<Errors> get provider =>
      ChangeNotifierProvider.value(value: this);
}