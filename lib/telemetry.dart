import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:uksc_dashboard/models/cruise_control.dart';
import 'package:uksc_dashboard/models/motors.dart';
import 'package:uksc_dashboard/models/speed.dart';
import 'package:uksc_dashboard/models/base_model.dart';
import 'package:uksc_dashboard/models/telemetry_status.dart';
import 'package:uksc_dashboard/models/controls.dart';
import 'package:uksc_dashboard/models/status.dart';
import 'package:uksc_dashboard/models/battery.dart';
import 'package:uksc_dashboard/models/timing.dart';
import 'package:uksc_dashboard/models/errors.dart';



import 'package:uksc_dashboard/api/viss/viss.dart';
import 'package:uksc_dashboard/api/viss/models/request.dart';
import 'package:uksc_dashboard/api/viss/models/response.dart';


final log = Logger('telemetry');

const superToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJrdWtzYS52YWwiLCJpc3MiOiJFY2xpcHNlIEtVS1NBIERldiIsImFkbWluIjp0cnVlLCJpYXQiOjE1MTYyMzkwMjIsImV4cCI6MTc2NzIyNTU5OSwia3Vrc2EtdnNzIjp7IioiOiJydyJ9fQ.QQcVR0RuRJIoasPXYsMGZhdvhLjUalk4GcRaxhh3-0_j3CtVSZ0lTbv_Z3As5BfIYzaMlwUzFGvCVOq2MXVjRK81XOAZ6wIsyKOxva16zjbZryr2V_m3yZ4twI3CPEzJch11_qnhInirHltej-tGg6ySfLaTYeAkw4xYGwENMBBhN5t9odANpScZP_xx5bNfwdW1so6FkV1WhpKlCywoxk_vYZxo187d89bbiu-xOZUa5D-ycFkd1-1rjPXLGE_g5bc4jcQBvNBc-5FDbvt4aJlTQqjpdeppxhxn_gjkPGIAacYDI7szOLC-WYajTStbksUju1iQCyli11kPx0E66me_ZVwOX07f1lRF6D2brWm1LcMAHM3bQUK0LuyVwWPxld64uSAEsvSKsRyJERc7nZUgLf7COnUrrkxgIUNjukbdT2JVN_I-3l3b4YXg6JVD7Y5g0QYBKgXEFpZrDbBVhzo7PXPAhJD6-c3DcUQyRZExbrnFV56RwWuExphw8lYnbMvxPWImiVmB9nRVgFKD0TYaw1sidPSSlZt8Uw34VZzHWIZQAQY0BMjR33fefg42XQ1YzIwPmDx4GYXLl7HNIIVbsRsibKaJnf49mz2qnLC1K272zXSPljO11Ke1MNnsnKyUH7mcwEs9nhTsnMgEOx_TyMLRYo-VEHBDLuEOiBo';

class TelemetryManager extends ChangeNotifier {
  /// The address pointing to the websocket host
  Uri uri;

  late VissApi _vissApi;
  int _connectionAttempts = 0;

  /// The status model
  final telemetryStatus = TelemetryStatus();

  final List<BaseModel> carModels = [
    Speed(),
    LeftMotor(),
    RightMotor(),
    Pedals(),
    Status(),
    CruiseControl(),
    Battery(),
    Timing(),
    SteeringWheel(),
    Errors(),
  ];

  void _subscribeModels() async {
    log.info('Subscribing models...');
    for (final model in carModels) {
      // var bestNode = VissApi.findBestSharedNode(model.nodes);
      // log.finest('Best node for ${model.runtimeType}: $bestNode');
      for (final node in model.nodes) {
        _vissApi.subscribe(SubscribeRequest(node), (subscriptionDataResponse) {
          log.fine(
              'Received subscription data for ${subscriptionDataResponse.subscriptionId}');
          log.finest('Received $subscriptionDataResponse');
          model.updateFromData(subscriptionDataResponse.data);
        }).then((response) => {
              if (response is ErrorResponse)
                {
                  log.severe(
                      'Failed to subscribe to $node for ${model.runtimeType}: $response')
                }
              else
                {log.fine('Subscribed to $node for ${model.runtimeType}')}
            });
      }
    }
  }

  TelemetryManager(this.uri) {
    _vissApi = VissApi(uri, onResponse: (response) {
      log.finer('Received $response');
      if (response is ErrorResponse) {
        telemetryStatus.numErrors++;
      } else {
        telemetryStatus.numErrors = 0;
      }

      if (response.timestamp != null) {
        final latency =
            response.timestamp!.difference(response.processedTimestamp).abs();
        telemetryStatus.addLatency(latency);
      } else {
        log.finest('Response missing timestamp');
      }
    }, onDisconnect: () {
      telemetryStatus.state = State.disconnected;
      // reconnect disconnect
      log.warning('VISS disconnected');

      telemetryStatus.state = State.connecting;
      // async wait for time corresponding to 2^_connectionAttempts seconds
      final waitTime = Duration(seconds: pow(2, _connectionAttempts).toInt());
      log.fine('Waiting $waitTime before reconnecting');
      Future.delayed(waitTime, () {
        // TODO: magic number!!
        if (_connectionAttempts < 7) {
          _connectionAttempts++;
          log.info('Attempting to reconnect to VISS API $uri');
          connect();
        } else {
          telemetryStatus.state = State.error;
          log.severe('VISS did not reconnect after 5 attempts');
          // throw exception?
          throw Exception('VISS did not reconnect after 5 attempts');
        }
      });
    });
  }

  void connect() async {
    telemetryStatus.state = State.connecting;
    log.info('Connecting to VISS API $uri');
    _vissApi.connect();
    final authorizeResponse =
        await _vissApi.makeRequest(AuthorizeRequest(superToken));
    if (authorizeResponse is ErrorResponse) {
      // TODO failure handling
      log.severe('Failed to authorize: $authorizeResponse');
      telemetryStatus.state = State.disconnected;
      return;
    }
    log.info('Authorization successful');
    telemetryStatus.state = State.connected;
    _subscribeModels();
  }
}