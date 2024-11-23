import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/status.dart';
import 'package:uksc_dashboard/models/cruise_control.dart';
import 'package:uksc_dashboard/models/errors.dart';
import 'package:uksc_dashboard/models/controls.dart';
import 'package:uksc_dashboard/models/battery.dart';

class IndicatorLightsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Turn Signal
        TurnSignalIndicator(signal: TurnSignal.left),

        // Indicator Lights
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CruiseControl>(
              builder: (context, cruise, child) => StateIndicator(
                activeColor: Colors.lightGreen,
                inactiveColor: Colors.grey[800]!,
                isActive: cruise.enabled,
                activeText: "CC",
                inactiveText: "CC",
                textSize: 35,
              ),
            ),
            // Triggers Pedals
            Consumer<Status>(
              builder: (context, status, child) => StateIndicator(
                activeColor: Colors.grey[600]!,
                inactiveColor: Colors.grey[600]!,
                isActive: status.wheelPedal,
                activeText: "P",
                inactiveText: "T",
                textSize: 45,
              ),
            ),
            // Forward Reverse
            Consumer<Status>(
              builder: (context, status, child) => StateIndicator(
                activeColor: Colors.green,
                inactiveColor: Colors.red,
                isActive: status.forwardReverse,
                activeText: "FR",
                inactiveText: "RV",
                textSize: 35,
              ),
            ),
            // Temperature warning light
            Consumer<Battery>(
              builder: (context, battery, child) => StateIconIndicator(
                activeColor: Colors.red,
                inactiveColor: Colors.grey,
                // Is active determined by if temperature is above 38 degrees celcius
                isActive: battery.orionAverageTemp >= 38,
                activeIcon: Icons.battery_alert_sharp,
                inactiveIcon: Icons.battery_alert_outlined,
              ),
            ),
            // Error indicator
            Consumer<Errors>(
              builder: (context, errors, child) => StateIconIndicator(
                activeColor: Colors.red,
                inactiveColor: Colors.grey,
                isActive: errors.bottomShellError,
                activeIcon: Icons.error,
                inactiveIcon: Icons.error_outline,
              ),
            ),
          ],
        ),
        // Right Turn Signal
        TurnSignalIndicator(signal: TurnSignal.right),
      ],
    );
  }
}

// Class for widgets that use an icon
class StateIconIndicator extends StatefulWidget {
  final Color activeColor;
  final Color inactiveColor;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final bool isActive;

  const StateIconIndicator({
    Key? key,
    required this.activeColor,
    required this.inactiveColor,
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
  }) : super(key: key);

  @override
  _StateIconIndicatorState createState() => _StateIconIndicatorState();
}

// Class for icon widgets that actually updates the state idk why this one is separate and the text one is all in one
class _StateIconIndicatorState extends State<StateIconIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height:70,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: widget.isActive ? widget.activeColor : widget.inactiveColor,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(5),
      child: Center(
        child: Icon(
          widget.isActive ? widget.activeIcon : widget.inactiveIcon,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}

// Class for widgets that use text
class StateIndicator extends StatelessWidget {
  final Color activeColor;
  final Color inactiveColor;
  final String activeText;
  final String inactiveText;
  final double textSize;
  final bool isActive;

  const StateIndicator({
    Key? key,
    required this.activeColor,
    required this.inactiveColor,
    required this.isActive,
    required this.activeText,
    required this.inactiveText,
    required this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(5),
      child: Center(
        child: Text(
          isActive ? activeText : inactiveText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
}

// Class for turn signal indicators
enum TurnSignal { left, right }
class TurnSignalIndicator extends StatefulWidget {
  final TurnSignal signal;

  const TurnSignalIndicator({Key? key, required this.signal}) : super(key: key);

  @override
  _TurnSignalIndicatorState createState() => _TurnSignalIndicatorState();
}

// Class that implements the blinking behavior
class _TurnSignalIndicatorState extends State<TurnSignalIndicator> {
  late Timer _timer;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Blinking duration defined here
  void _startBlinking() {
    _timer = Timer.periodic(const Duration(milliseconds: 750), (timer) { 
      if (mounted) {
        setState(() {
          _isBlinking = !_isBlinking;
        });
      }
    });
  }

  // Build widget for the turn signals
  @override
  Widget build(BuildContext context) {
    return Consumer<SteeringWheel>(
      builder: (context, steeringWheel, child) {
        final Button turnSignalButton = widget.signal == TurnSignal.left
            ? steeringWheel.buttonLeftTurn
            : steeringWheel.buttonRightTurn;
        // Here rather than using .isPressed to check, since it's a toggle switch we can just do remainder of 2 on short press count
        final bool isSignalActive = turnSignalButton.shortPresses % 2 != 0;
        final IconData iconData = widget.signal == TurnSignal.left
            ? Icons.arrow_back
            : Icons.arrow_forward;

        final Color color = isSignalActive
            ? (_isBlinking ? Colors.lightGreen : Colors.grey)
            : Colors.grey;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Icon(
            iconData,
            color: color,
            size: 80,
          ),
        );
      },
    );
  }
}

// For continueously solid turn signal indicators use this code below

// class TurnSignalIndicator extends StatelessWidget {
//   final TurnSignal signal;

//   const TurnSignalIndicator({Key? key, required this.signal}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SteeringWheel>(
//       builder: (context, steeringWheel, child) {
//         final Button turnSignalButton = signal == TurnSignal.left
//             ? steeringWheel.buttonLeftTurn
//             : steeringWheel.buttonRightTurn;
//         final bool isSignalActive = turnSignalButton.shortPresses % 2 != 0;
//         final IconData iconData = signal == TurnSignal.left ? Icons.arrow_back : Icons.arrow_forward;

//         // Insert code that flips color from green to grey in 0.5 second intervals based on if isSignalActive is on or not
//         final Color color = isSignalActive ? Colors.green : Colors.grey;

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5.0),
//           child: Icon(
//             iconData,
//             color: color,
//             size: 60,
//             opticalSize: 30,
//           ),
//         );
//       },
//     );
//   }
// }

// enum TurnSignal { left, right }