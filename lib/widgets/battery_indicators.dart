import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/battery.dart';

//TODO add color changing indicators
//TODO fix typecasting thing that is an issue with pack voltage in particular
//TODO fix the way this code deals with context. This uses some wack stuff that must be from when I first started writing the dash
// Generally, we use a builder for all context handling idk why it's this weird stuff here cuz it's all from the battery model
class BatteryDisplay extends StatelessWidget {
  const BatteryDisplay({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      // Define size of entire battery display widget
      width: 290,
      height: 330,
      // Create column of rows that have two _buildBatteryInfo's each
      child: Material(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Battery Pack',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBatteryInfo(context, 'State of Charge', 'State of Charge', '%', Colors.white),
                _buildBatteryInfo(context, 'Battery Pack', 'Pack Voltage', 'V', Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBatteryInfo(context, 'Total Current', 'Total Current', 'A', Colors.white),
                _buildBatteryInfo(context, 'Motor Current', 'Motor Current', 'A', Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBatteryInfo(context, 'Aux Battery', 'Aux Battery', 'V', Colors.white),
                //TODO add cell voltage changer
                _buildBatteryInfo(context, 'Cell Voltage', 'Cell Voltage', 'V', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Separate widget to build the battery readout information
  Widget _buildBatteryInfo(BuildContext context, String label, String batteryAttribute, String unit, Color textColor) {
    Battery battery = Provider.of<Battery>(context);

    // Fetching the value from the battery model based on the attribute name for potential use of other models
    double numericValue;
    String value;
    switch (batteryAttribute) {
      case 'State of Charge':
        numericValue = battery.stateOfCharge;
        if (numericValue <= 20){
          textColor = Colors.yellow;
          if (numericValue <= 10) {
            textColor = Colors.red;
          }
        }
        value = numericValue.toStringAsFixed(2);
        break;
      case 'Pack Voltage':
        value = battery.packVoltage.toString();
        break;
      case 'Total Current':
        value = battery.packCurrent.toStringAsFixed(2);
        break;
      case 'Motor Current':
        value = battery.controllerCurrent.toStringAsFixed(2);
        break;
      case 'Aux Battery':
        value = battery.auxPackVoltage.toString();
        break;
      case 'Cell Voltage':
        value = battery.controllerCurrent.toStringAsFixed(2);
        break;
      default:
        value = '0.00';
        break;
    }


    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white),
      ),
      // Define the size of the individual battery display readouts
      height: 90,
      width: 145,
      padding: const EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Function defined label for the readout
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, 
            ),
          ),
          const SizedBox(height: 5),
          // Text readout of battery value
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                double.tryParse(value)?.toStringAsFixed(2) ?? '0.00', // Ensure value has 2 decimal points
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
              ),
              Text(
                ' $unit', // Units next to the value
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
