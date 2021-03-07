import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_auth/utils/SignInfo.dart';

class Credentials {

  final String email;
  final String password;
  final SignInfo signInfo;

  Credentials(this.email, this.password, this.signInfo);
}