/// Defines the available runtime environments.
enum EnvironmentType { dev, uat, prod }

/// Holds the URLs and settings specific to ONE environment.
class EnvironmentConfig {
  final String insightsReportsBaseUrl;
  final String insightsBaseUrl;
  final String insightsBackendBaseUrl;
  final String blackBrokerUrl;
  final String commsEngineUrl;
  final String insightsAdminBaseUrl;
  final String miChatsBaseUrl;
  final String insightsApiBusBaseUrl;
  final String parlourConfigBaseUrl;
  final String strawberryBaseUrl;
  final String premiumCollectorUrl;
  final String underwriterEndpoint;
  final String fileIndexingUrl;
  final String hygieneBaseUrl;
  final String analytixBaseUrl;

  String get cclApiEndpoint => '${strawberryBaseUrl}cclapi/';

  String get ecommerceApiEndpoint => '${strawberryBaseUrl}ecommerce/';

  EnvironmentConfig({
    required this.insightsReportsBaseUrl,
    required this.insightsBaseUrl,
    required this.insightsBackendBaseUrl,
    required this.blackBrokerUrl,
    required this.commsEngineUrl,
    required this.insightsAdminBaseUrl,
    required this.miChatsBaseUrl,
    required this.insightsApiBusBaseUrl,
    required this.parlourConfigBaseUrl,
    required this.strawberryBaseUrl,
    required this.premiumCollectorUrl,
    required this.underwriterEndpoint,
    required this.fileIndexingUrl,
    required this.hygieneBaseUrl,
    required this.analytixBaseUrl,
  });
}

/// Manages the application's environment configuration.
class AppConfig {
  static EnvironmentType _currentEnvironment = EnvironmentType.prod;

  static final Map<EnvironmentType, EnvironmentConfig> _environments = {
    EnvironmentType.dev: EnvironmentConfig(
      insightsReportsBaseUrl: "http://102.210.146.67:8022/",
      insightsBaseUrl: "https://miinsightsapps.net/",
      insightsBackendBaseUrl: "https://mi.ngrok.pizza/api/",
      blackBrokerUrl: "http://localhost:8009/api/",
      commsEngineUrl: "http://localhost:5000/api/",
      fileIndexingUrl: "https://qa.miinsightsapps.net/files/save_media/",
      insightsAdminBaseUrl: "https://mi.ngrok.pizza/api/",
      miChatsBaseUrl: "https://mi.ngrok.dev/",
      insightsApiBusBaseUrl: "http://localhost:8080/api",
      parlourConfigBaseUrl: "http://localhost:8000/parlour_config/",
      strawberryBaseUrl: "http://localhost:8000/strawberry/",
      premiumCollectorUrl: "https://uat.miinsightsapps.net/collector_api/api/",
      underwriterEndpoint: "https://uat.miinsightsapps.net/underwriter_config",
      hygieneBaseUrl: "https://uat.miinsightsapps.net/underwriter_config",
      analytixBaseUrl: "http://102.210.146.67:8026/",
    ),
    EnvironmentType.uat: EnvironmentConfig(
      insightsReportsBaseUrl: "https://uat.reportsapp.miinsightsapps.net/",
      insightsBaseUrl: "https://uat.miinsightsapps.net/",
      insightsBackendBaseUrl: "https://uat.miinsightsapps.net/backend_api/api/",
      blackBrokerUrl: "https://blackbroker.miinsightsapps.net/api/",
      commsEngineUrl: "https://uat.miinsightsapps.net/communications/api/",
      insightsAdminBaseUrl: "https://uat.miinsightsapps.net/backend_api/api/",
      miChatsBaseUrl: "https://mi-chats.miinsightsapps.net/",
      insightsApiBusBaseUrl: "https://uat.miinsightsapps.net/apibus/api",
      parlourConfigBaseUrl: "https://uat.miinsightsapps.net/parlour_config/",
      strawberryBaseUrl: "https://uat.miinsightsapps.net/strawberry/",
      premiumCollectorUrl: "https://uat.miinsightsapps.net/collector_api/api/",
      underwriterEndpoint: "https://uat.miinsightsapps.net/underwriter_config",
      fileIndexingUrl: "https://uat.miinsightsapps.net/files/save_media/",
      hygieneBaseUrl: "https://uat.miinsightsapps.net/files/save_media/",
      analytixBaseUrl: "https://analytix.miinsightsapps.net/",
    ),
    EnvironmentType.prod: EnvironmentConfig(
      insightsReportsBaseUrl: "https://miinsightsapps.net/reportapp/",
      insightsBaseUrl: "https://miinsightsapps.net/",
      insightsBackendBaseUrl: "https://miinsightsapps.net/backend_api/api/",
      blackBrokerUrl: "https://blackbroker.miinsightsapps.net/api/",
      insightsApiBusBaseUrl: "https://miinsightsapps.net/apibus/api",
      commsEngineUrl: "https://miinsightsapps.net/communications/api/",
      insightsAdminBaseUrl: "https://miinsightsapps.net/backend_api/api/",
      //miChatsBaseUrl: "https://miinsightsapps.net/michats/",
      miChatsBaseUrl: "https://mi-chats.miinsightsapps.net/",
      parlourConfigBaseUrl: "https://miinsightsapps.net/parlour_config/",
      premiumCollectorUrl: "https://qa.miinsightsapps.net/collector_api/api/",
      underwriterEndpoint: "https://miinsightsapps.net/underwriter_config",
      fileIndexingUrl: "https://miinsightsapps.net/files/save_media/",
      strawberryBaseUrl: "https://miinsightsapps.net/strawberry/",
      hygieneBaseUrl: "https://miinsightsapps.net/strawberry/",
      analytixBaseUrl: "https://analytix.miinsightsapps.net/",
    ),
  };

  /// Sets the current environment (call this FIRST during app initialization).
  /// Example: AppConfig.setEnvironment(EnvironmentType.dev);
  static void setEnvironment(EnvironmentType env) {
    _currentEnvironment = env;
    print("----- APP ENVIRONMENT SET TO: ${env.name.toUpperCase()} -----");
    // You might want more robust logging here
  }

  static void switchEnvironment(EnvironmentType env) {
    if (_currentEnvironment != env) {
      // Optional: Only print if it changes
      _currentEnvironment = env;
      print(
        "----- APP ENVIRONMENT SWITCHED TO: ${env.name.toUpperCase()} -----",
      );
    }
  }

  /// Gets the configuration object for the currently set environment.
  static EnvironmentConfig get currentConfig =>
      _environments[_currentEnvironment]!;

  /// Convenience getter for the current environment type enum value.
  static EnvironmentType get currentEnvironmentType => _currentEnvironment;

  // --- Convenience Getters for URLs (Access these directly: AppConfig.insightsBaseUrl) ---
  static String get insightsReportsBaseUrl =>
      currentConfig.insightsReportsBaseUrl;
  static String get analitixAppBaseUrl => currentConfig.analytixBaseUrl;

  static String get insightsBaseUrl => currentConfig.insightsBaseUrl;
  static String get hygieneBaseUrl => currentConfig.hygieneBaseUrl;

  static String get insightsBackendBaseUrl =>
      currentConfig.insightsBackendBaseUrl;
  static String get premiumCollectorUrl => currentConfig.premiumCollectorUrl;
  static String get fileIndexingUrl => currentConfig.fileIndexingUrl;
  static String get underwriterEndpoint => currentConfig.underwriterEndpoint;

  static String get blackBrokerUrl => currentConfig.blackBrokerUrl;

  static String get commsEngineUrl => currentConfig.commsEngineUrl;

  static String get insightsAdminBaseUrl => currentConfig.insightsAdminBaseUrl;

  static String get miChatsBaseUrl => currentConfig.miChatsBaseUrl;

  static String get insightsApiBusBaseUrl =>
      currentConfig.insightsApiBusBaseUrl;

  static String get parlourConfigBaseUrl => currentConfig.parlourConfigBaseUrl;

  static String get cclApiEndpoint => currentConfig.cclApiEndpoint;

  static String get ecommerceApiEndpoint => currentConfig.ecommerceApiEndpoint;

  // Keep this if needed for backward compatibility temporarily
  static String get API_ENDPOINT => currentConfig.cclApiEndpoint;
}
