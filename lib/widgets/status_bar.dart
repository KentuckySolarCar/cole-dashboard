import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/telemetry_status.dart' as telemetry;

/// The preferred height of the status bar
const statusBarHeight = 45.0;

/// The elevation of the statusBar
// TODO: would prefer not to use this at all
const statusBarElevation = 1.0;

/// The spacing between provided children to be placed in the status bar
const statusBarChildrenSpacing = 10.0;

/// Represents a status bar, displaying essential information such as connection status, time, etc.
///
/// This widget is meant to be used as an [AppBar] for the [Scaffold] of a dashboard. Can be passed
/// a list of [Widget]s to display on the status bar.
class StatusBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? children;

  const StatusBar({Key? key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return Material(
      elevation: appBarTheme.elevation ?? 0.0,
      //color: appBarTheme.backgroundColor,
      color: Colors.black,
      shadowColor: appBarTheme.shadowColor,
      surfaceTintColor: appBarTheme.surfaceTintColor,
      shape: appBarTheme.shape,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Placeholder(
            color: Colors.transparent,
            fallbackWidth: 245,
          ),
          SizedBox(width: 10),
          Clock(),
          SizedBox(width: 75),
          ConnectionStatus(),
        ],
      )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(statusBarHeight);
}

class Clock extends StatelessWidget {
  const Clock({Key? key}) : super(key: key);

  // TODO: display time zone, allow user to change timezone when clicked... and/or maybe we can use the GPS data to automatically set the default timezone
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return SizedBox(
          height: double.infinity,
          width: 300,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

// We can also use the bottom shell clock signal using this function
// Function to convert a unix time double to a string displaying the time
String _formatUnixTime(int unixTime) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    return formattedTime;
}

/// Widget that displays the websocket connection status in a friendly manner
class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Consumer<telemetry.TelemetryStatus>(
        builder: (context, webSocketStatus, child) {
          Widget statusIcon;
          Widget statusText;
          switch (webSocketStatus.state) {
            case telemetry.State.connected:
              statusIcon = const Icon(Icons.sync, size: 30, color: Colors.green);
              statusText = Text(
                '${webSocketStatus.averageLatency.inMilliseconds.toStringAsFixed(1)}ms',
                style: const TextStyle(
                fontSize: 20
                ),
                textAlign: TextAlign.center,
              );
              break;
            case telemetry.State.connecting:
              // padding object here is a workaround for https://github.com/flutter/flutter/issues/3282
              statusIcon = const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 3,
                  ),
                ),
              );
              statusText = const Text(
                'Connecting...',
                style: TextStyle(
                fontSize: 20
                ),
                textAlign: TextAlign.center,
              );
              break;
            case telemetry.State.disconnected:
              statusIcon =
                  const Icon(Icons.sync_disabled, size: 30, color: Colors.orange);
              statusText = const Text(
                'Disconnected',
                style: TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
              );
              break;
            case telemetry.State.error:
              statusIcon = const Icon(Icons.sync_problem, size: 30, color: Colors.red);
              statusText = const Text(
                'Error',
                style: TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
              );
          }
      
          return Row(
            children: [
              statusIcon,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: statusText,
              )
            ],
          );
        },
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}