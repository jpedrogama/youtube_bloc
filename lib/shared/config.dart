import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get title => _get('title');
  static String get environment => _get('environment');
  static String get apiKey => _get('apiKey');
  static String _get(String key) => dotenv.env[key] ?? '';
}