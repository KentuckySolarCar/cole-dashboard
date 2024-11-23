import 'package:flutter/material.dart';
import 'package:args/args.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import 'package:uksc_dashboard/telemetry.dart';
import 'package:uksc_dashboard/dashboards/main_dash.dart';
import 'package:uksc_dashboard/dashboards/basic.dart';
import 'package:uksc_dashboard/widgets/splash_screen.dart';

final log = Logger('main');

const defaultPort = 8090;
//const defaultPort = 55556;
const defaultHost = '127.0.0.1';
//const defaultHost = 'localhost';
const defaultDashboard = 'testing';

void main(List<String> args) {
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // argument setup
  final parser = ArgParser();
  parser.addOption('dashboard',
      abbr: 'd',
      help: 'Dashboard to display',
      allowed: ['driver', 'diagnostic', 'dev'],
      defaultsTo: defaultDashboard);
  parser.addOption('host',
      abbr: 'h', help: 'Webserver IP address', defaultsTo: defaultHost);
  parser.addOption('port',
      abbr: 'p', help: 'Webserver port', defaultsTo: defaultPort.toString());
  parser.addFlag('verbose', defaultsTo: false);
  final userArgs = parser.parse(args);

  Logger.root.level = userArgs['verbose'] ? Level.ALL : Level.INFO;
  log.config('Logging level set to ${Logger.root.level}');
  log.finer('Parsed arguments: $userArgs');

  final telemetryManager = TelemetryManager(
    Uri(
        scheme: 'ws',
        host: userArgs['host'],
        port: int.tryParse(userArgs['port']) ?? defaultPort),
  );

  telemetryManager.connect();

  final providers = [
    telemetryManager.telemetryStatus.provider,
    ...telemetryManager.carModels.map((e) => e.provider),
  ];

  log.info('loading dashboard ${userArgs['dashboard']}');
  switch (userArgs['dashboard']) {
    case 'driver':
      runApp(MultiProvider(
        providers: providers,
        child: const BaseApp(dashboard: BasicDashboard()),
      ));
      break;
    case 'diagnostic':
      runApp(MultiProvider(
        providers: providers,
        child: const BaseApp(dashboard: BasicDashboard()),
      ));
      break;
    case 'dev':
    case 'testing':
      runApp(MultiProvider(
        providers: providers,
        child: const BaseApp(dashboard: MainDashboard()),
      ));
      break;
    default:
      runApp(MultiProvider(
        providers: providers,
        child: const BaseApp(dashboard: BasicDashboard()),
      ));
  }
}

class BaseApp extends StatelessWidget {
  final Widget dashboard;

  const BaseApp({Key? key, required this.dashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      home: SplashScreen(dashboard: dashboard,),
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
