import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  // static String get getFileName {
  //   // return '.env.production';
  //   // }
  //   return '.env.development';
  // }

  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? '';
  }

  static bool get debugMode {
    return dotenv.getBool('DEBUG_MODE', fallback: false);
  }
}
