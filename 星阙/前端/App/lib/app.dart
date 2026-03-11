import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:horosa/services/log.dart';
import 'package:horosa/utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:horosa/providers/providers.dart';
import 'package:horosa/router/routes.dart';

class HorosaApp extends StatefulWidget {
  const HorosaApp({super.key});

  @override
  State<HorosaApp> createState() => _HorosaAppState();
}

class _HorosaAppState extends State<HorosaApp> {
  Future<bool> _hasNetworkConnection() async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    return connectivityResult
        .any((result) => result != ConnectivityResult.none);
  }

  Future<void> initialization() async {
    if (!await _hasNetworkConnection()) {
      toast('请检查您的网络连接~');
      return;
    }
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!kIsWeb) {
        try {
          FlutterSplashScreen.hide();
        } catch (_) {}
      }
    });
    await LogSvc.logging(LogType.open);
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfigProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, _, __) => ScreenUtilInit(
          designSize: const Size(750, 1624),
          builder: (_, child) => ToastificationWrapper(
            child: MaterialApp(
              title: "星阙",
              builder: (context, child) =>
                  MediaQuery.withNoTextScaling(child: child ?? Container()),
              debugShowCheckedModeBanner: false,
              home: child,
              theme: ThemeData(
                fontFamily: 'SourceHanSerifCN',
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                scaffoldBackgroundColor: const Color(0xfffbfbfb),
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  },
                ),
              ),
              routes: routes,
            ),
          ),
        ),
      ),
    );
  }
}
