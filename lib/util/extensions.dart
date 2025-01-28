import 'dart:convert';
import 'package:crypto/crypto.dart';

extension StringExtensions on String {

  String encrypt() => sha256.convert(utf8.encode(this)).toString();

  String capitalize() => this[0].toUpperCase() + substring(1);

}

extension DateTimeExtensions on DateTime {
  String spanishDate() => "$day-$month-$year ";

  String spanishDateTime() => "$day-$month-$year $hour:$minute";

}