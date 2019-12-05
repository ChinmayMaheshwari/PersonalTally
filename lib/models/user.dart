import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final num number;
  int balance;

  User({
    @required this.id,
    @required this.name,
    this.number,
    this.balance,
  });
}
