// import 'package:flutter/material.dart';
// import 'package:uksc_dashboard/widgets/speeds_display.dart';
// import 'package:uksc_dashboard/widgets/status_bar.dart';
// import 'package:uksc_dashboard/widgets/throttle.dart';
// import 'package:uksc_dashboard/widgets/indicator_lights.dart';
// import 'package:uksc_dashboard/widgets/battery_indicators.dart';
// import 'package:uksc_dashboard/widgets/time_indicators.dart';
// class MainDashboard extends StatelessWidget {
//   const MainDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: const StatusBar(),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           IndicatorLightsRow(),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 padding: const EdgeInsets.all(5),
//                 child: const BatteryDisplay(),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(0),
//                 child: const SpeedDisplay(),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 padding: const EdgeInsets.all(5),
//                 child: const Throttle(),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 padding: const EdgeInsets.all(5),
//                 child: TimeReadout(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/widgets/speeds_display.dart';
import 'package:uksc_dashboard/widgets/status_bar.dart';
import 'package:uksc_dashboard/widgets/throttle.dart';
import 'package:uksc_dashboard/widgets/indicator_lights.dart';
import 'package:uksc_dashboard/widgets/battery_indicators.dart';
import 'package:uksc_dashboard/widgets/time_indicators.dart';
import 'package:uksc_dashboard/models/status.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Grab status provider for the brake lockout
    Status status = Provider.of<Status>(context);
    bool brakeLockout = status.brakeLockout;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const StatusBar(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IndicatorLightsRow(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const BatteryDisplay(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: const SpeedDisplay(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const Throttle(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: TimeReadout(),
                  ),
                ],
              ),
            ],
          ),
          // This is not fully implemented yet
          if (!brakeLockout)  // Show popup if brake is not pressed
            Center(
              child: Container(
                width: 300,
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 70,
                    ),
                    Text(
                      'Accelerator Locked',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Press Brake to Enable',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
