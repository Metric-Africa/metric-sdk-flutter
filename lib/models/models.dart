enum Environment {
  dev, prod
}

class AppTheme {
  String appName;
  String brandLogoUrl;
  String brandPrimaryColor;

  AppTheme({
    required this.appName,
    required this.brandLogoUrl,
    required this.brandPrimaryColor
  });

  Map<String, dynamic> get map {
    return {
      'appName': appName,
      'brandLogoUrl': brandLogoUrl,
      'brandPrimaryColor': brandPrimaryColor
    };
  }
}

class ClientAuthenticator {
  String secretKey;
  String clientKey;

  ClientAuthenticator({
    required this.secretKey,
    required this.clientKey,
  });

  Map<String, dynamic> get map {
    return {
      'secretKey': secretKey,
      'clientKey': clientKey
    };
  }
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

  Map<String, dynamic> get map {
    return {
      'appTheme': appTheme.map,
      'authenticator': authenticator.map,
      'environment': environment.toString()
    };
  }
}
