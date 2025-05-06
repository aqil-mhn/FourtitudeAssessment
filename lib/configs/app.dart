import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtitude_assessment/configs/app_language.dart';
import 'package:fourtitude_assessment/configs/app_navigation.dart';
import 'package:fourtitude_assessment/modules/logins/login_screen.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  App({
    super.key,
    required this.appName
  });

  String? appName;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final sessionStateStream = StreamController<SessionState>();
  NavigatorState get _navigator => NavKey.navKey.currentState!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initiateLocalDatabase();
  }

  // initiateLocalDatabase() {
  //   initiateDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 5)
    );
    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: ScreenUtilInit(
        designSize: const Size(300, 690),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: NavKey.navKey,
          home: LoginScreen(),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          locale: Provider.of<AppLanguage>(context).appLocal,
          supportedLocales: [
            Locale('en'),
            Locale('my')
          ],
        ),
      ),
    );
  }
}