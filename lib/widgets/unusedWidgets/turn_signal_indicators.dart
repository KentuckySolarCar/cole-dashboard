// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uksc_dashboard/models/controls.dart';


// class TurnSignalBar extends StatelessWidget {
//   const TurnSignalBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 35.0, // Set the desired height for the bar
//       color: Theme.of(context).appBarTheme.backgroundColor,
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           TurnSignalIndicator(signal: TurnSignal.left),
//           //Clock(),
//           TurnSignalIndicator(signal: TurnSignal.right),
//         ],
//       ),
//     );
//   }
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
//           width: 100,
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

// enum TurnSignal { left, right }

// class TurnSignalIndicator extends StatefulWidget {
//   final TurnSignal signal;

//   const TurnSignalIndicator({Key? key, required this.signal}) : super(key: key);

//   @override
//   _TurnSignalIndicatorState createState() => _TurnSignalIndicatorState();
// }

// class _TurnSignalIndicatorState extends State<TurnSignalIndicator> {
//   late Timer _timer;
//   bool _isBlinking = false;

//   @override
//   void initState() {
//     super.initState();
//     _startBlinking();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void _startBlinking() {
//     _timer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
//       if (mounted) {
//         setState(() {
//           _isBlinking = !_isBlinking;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SteeringWheel>(
//       builder: (context, steeringWheel, child) {
//         final Button turnSignalButton = widget.signal == TurnSignal.left
//             ? steeringWheel.buttonLeftTurn
//             : steeringWheel.buttonRightTurn;
//         final bool isSignalActive = turnSignalButton.shortPresses % 2 != 0;
//         final IconData iconData = widget.signal == TurnSignal.left
//             ? Icons.arrow_back
//             : Icons.arrow_forward;

//         final Color color = isSignalActive
//             ? (_isBlinking ? Colors.green : Colors.grey)
//             : Colors.grey;

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5.0),
//           child: Icon(
//             iconData,
//             color: color,
//             size: 60,
//           ),
//         );
//       },
//     );
//   }
// }


// // class TurnSignalIndicator extends StatelessWidget {
// //   final TurnSignal signal;

// //   const TurnSignalIndicator({Key? key, required this.signal}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<SteeringWheel>(
// //       builder: (context, steeringWheel, child) {
// //         final Button turnSignalButton = signal == TurnSignal.left
// //             ? steeringWheel.buttonLeftTurn
// //             : steeringWheel.buttonRightTurn;
// //         final bool isSignalActive = turnSignalButton.shortPresses % 2 != 0;
// //         final IconData iconData = signal == TurnSignal.left ? Icons.arrow_back : Icons.arrow_forward;

// //         // Insert code that flips color from green to grey in 0.5 second intervals based on if isSignalActive is on or not
// //         final Color color = isSignalActive ? Colors.green : Colors.grey;

// //         return Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 5.0),
// //           child: Icon(
// //             iconData,
// //             color: color,
// //             size: 60,
// //             opticalSize: 30,
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // enum TurnSignal { left, right }