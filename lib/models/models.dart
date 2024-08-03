import 'dart:ui';

class AppTheme {
  String appName;
  String logoUrl;
  Color primaryColor;

  AppTheme({
    required this.appName,
    required this.logoUrl,
    required this.primaryColor
  });
}

class ClientAuthenticator {
  String secretKey;
  String clientKey;

  ClientAuthenticator({
    required this.secretKey,
    required this.clientKey,
  });
}

enum Environment {
  dev, prod
}

class SdkSettings {
  AppTheme appTheme;
  ClientAuthenticator authenticator;
  Environment environment;

  SdkSettings({
    required this.appTheme,
    required this.authenticator,
    required this.environment
  });
}