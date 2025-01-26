import 'dart:convert';
import 'package:crypto/crypto.dart';

extension StringExtensions on String {

  String encrypt() {

    return sha256.convert(utf8.encode(this)).toString();
  }

}