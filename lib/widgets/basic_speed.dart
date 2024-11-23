import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:uksc_dashboard/models/speed.dart';

/// A basic widget that simply displays the speed, nice and big.
///
/// The speed also changes colors at different thresholds. This is meant as a template to help show how widgets can be implemented.
class BasicSpeed extends StatelessWidget {
  const BasicSpeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<Speed>(builder: (context, speed, child) {
        var color = Colors.green;
        if (speed.mph > 80) {
          color = Colors.red;
        } else if (speed.mph > 65) {
          color = Colors.orange;
        }

        return Text('${speed.mph.toStringAsFixed(0)} MPH',
            style: TextStyle(
              fontSize: 40,
              color: color,
            ));
      }),
    );
  }
}

/// A basic widget that displays a speedometer using syncfusion RadialGauge
///
/// This is meant as a template to help show how widgets can be implemented.
class BasicSpeedGauge extends StatelessWidget {
  const BasicSpeedGauge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(child: Consumer<Speed>(builder: (context, speed, child) {
      return SfRadialGauge(
        title: const GaugeTitle(text: 'Speedometer', textStyle: TextStyle(fontSize: 40)),
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100.0,
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 65, color: Colors.green, startWidth: 10, endWidth: 10),
              GaugeRange(startValue: 65, endValue: 80, color: Colors.orange, startWidth: 10, endWidth: 10),
              GaugeRange(startValue: 75, endValue: 100, color: Colors.red, startWidth: 10, endWidth: 10)
            ],
            pointers: <GaugePointer>[NeedlePointer(value: speed.mph)],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text('${speed.mph.toStringAsFixed(0)} MPH',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  angle: 90,
                  positionFactor: 0.5)
            ],
          )
        ],
      );
    }));
  }
}
