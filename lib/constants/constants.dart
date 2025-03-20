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

class MessageType {
  static const text = 'text';
}

class FirebaseCollection {
  static const users = 'users';
  static const friends = 'friends';
  static const chat = 'chat';
}

enum EntityType {
  file, directory
}

enum ErrorSeverity {
  critical, major, minor, moderate
}