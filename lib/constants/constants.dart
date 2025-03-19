class AppConfig {
  static const appVersion = 1.0;
  static const name = 'WhatsApp';
}

class SharedPrefsKeys {
  static const users = 'users';
  static const name = 'name';
  static const username = 'username';
  static const email = 'email';
  static const isLoggedIn = 'isLoggedIn';
  static const firebaseId = 'firebaseId';
}

enum EntityType {
  file, directory
}

enum ErrorSeverity {
  critical, major, minor, moderate
}