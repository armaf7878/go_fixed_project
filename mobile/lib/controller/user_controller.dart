import 'package:flutter/foundation.dart';

class UserController {
  static const String man_domain = kReleaseMode
    ? 'https://api.yourdomain.com'
    : 'http://localhost:8000';
}