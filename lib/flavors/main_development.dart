import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fourtitude_assessment/configs/app_config.dart';
import 'package:fourtitude_assessment/configs/app_database.dart';
import 'package:fourtitude_assessment/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  await initiateDatabase();

  await AppConfig(
    appName: "Fourtitude Assessment",
    environment: AppEnvironment.developemnt
  ).run();
}