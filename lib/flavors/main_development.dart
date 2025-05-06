import 'package:flutter/material.dart';
import 'package:fourtitude_assessment/configs/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig(
    appName: "Teacher App",
    environment: AppEnvironment.developemnt
  ).run();
}