enum Environment { production, staging, qa }

class AppConfig {
  static Environment _environment = Environment.production;
  
  static Environment get environment => _environment;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static String get appName {
    switch (_environment) {
      case Environment.production:
        return 'OurHome';
      case Environment.staging:
        return 'OurHome (Staging)';
      case Environment.qa:
        return 'OurHome (QA)';
    }
  }
  
  static String get bundleId {
    switch (_environment) {
      case Environment.production:
        return 'com.ourhome.prod';
      case Environment.staging:
        return 'com.ourhome.staging';
      case Environment.qa:
        return 'com.ourhome.qa';
    }
  }
  
  static bool get isProduction => _environment == Environment.production;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isQA => _environment == Environment.qa;
  
  static bool get enableLogging => !isProduction;
  
  static String get firebaseProjectId {
    switch (_environment) {
      case Environment.production:
        return 'ourhome-proj';
      case Environment.staging:
        return 'ourhome-proj';
      case Environment.qa:
        return 'ourhome-proj';
    }
  }
}