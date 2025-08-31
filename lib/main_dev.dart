import 'package:flutter/material.dart';

import 'core/config/environment_config.dart';
import 'main.dart' as main_app;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set environment to development
  EnvironmentConfig.setEnvironment(Environment.development);
  
  // Run the main app
  main_app.main();
}