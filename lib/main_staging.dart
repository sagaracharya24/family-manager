import 'core/config/app_config.dart';
import 'main.dart' as app;

Future<void> main() async {
  AppConfig.setEnvironment(Environment.staging);
  await app.main();
}