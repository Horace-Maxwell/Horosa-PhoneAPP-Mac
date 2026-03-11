import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluwx/fluwx.dart';
import 'package:horosa/app.dart';
import 'package:horosa/utils/copy_database.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/widgets/chn_place_picker.dart';
import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Unhandled platform error: $error\n$stack');
    return true;
  };

  if (!kIsWeb && !LocalMode.enabled) {
    try {
      Fluwx fluwx = Fluwx();
      await fluwx.registerApi(
        appId: 'wx8559b476b39e28d1',
        universalLink: 'https://mobileweb.horosa.com/app/',
      );
    } catch (_) {}
  }
  if (!kIsWeb) {
    try {
      await copyDatabase();
    } catch (_) {}
  }

  try {
    await RiveFile.initialize();
  } catch (_) {}

  try {
    await CHNPlaceLoader.instance.loadRegions();
  } catch (_) {}
  runZonedGuarded(
    () => runApp(const HorosaApp()),
    (error, stackTrace) {
      debugPrint('Uncaught zone error: $error\n$stackTrace');
    },
  );
}
