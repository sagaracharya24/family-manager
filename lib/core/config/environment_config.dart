enum Environment {
  development,
  production,
  staging,
  qa,
}

class EnvironmentConfig {
  static Environment _environment = Environment.development;
  
  static Environment get environment => _environment;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isQA => _environment == Environment.qa;
  
  static String get environmentName {
    switch (_environment) {
      case Environment.development:
        return 'dev';
      case Environment.production:
        return 'prod';
      case Environment.staging:
        return 'staging';
      case Environment.qa:
        return 'qa';
    }
  }
}