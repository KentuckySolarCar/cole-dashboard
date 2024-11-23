// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uksc_dashboard/models/controls.dart';

// const statusBarHeight = 35.0;
// const statusBarElevation = 1.0;
// const statusBarChildrenSpacing = 10.0;

// //As of right now were not using this turn signal widget at all im keeping it in my repo for possible use later

// class DrivingStatusBar extends StatelessWidget implements PreferredSizeWidget {
//   final List<Widget>? children;

//   const DrivingStatusBar({Key? key, this.children}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final appBarTheme = Theme.of(context).appBarTheme;

//     return Material(
//       elevation: appBarTheme.elevation ?? statusBarElevation,
//       color: appBarTheme.backgroundColor,
//       shadowColor: appBarTheme.shadowColor,
//       surfaceTintColor: appBarTheme.surfaceTintColor,
//       shape: appBarTheme.shape,
//       child: Row(
//         children: [
//           const TurnSignalIndicator(signal: TurnSignal.left),
//           Expanded(
//             child: Align(
//               alignment: Alignment.center,
//               child: Wrap(
//                 spacing: statusBarChildrenSpacing,
//                 children: [...?children],
//               ),
//             ),
//           ),
//           const TurnSignalIndicator(signal: TurnSignal.right),
//           const Expanded(
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Clock(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(statusBarHeight);
// }

// class Clock extends StatelessWidget {
//   const Clock({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: Stream.periodic(const Duration(seconds: 1)),
//       builder: (context, snapshot) {
//         return SizedBox(
//           height: double.infinity,
//           width: 70,
//           child: Align(
//             alignment: Alignment.center,
//             child: Text(
//               '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}',
//               style: Theme.of(context).textTheme.titleLarge,
//               textAlign: TextAlign.center,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

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
//         final Color color = isSignalActive ? Colors.green : Colors.grey;

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5.0),
//           child: Icon(
//             iconData,
//             color: color,
//           ),
//         );
//       },
//     );
//   }
// }

// enum TurnSignal { left, right }