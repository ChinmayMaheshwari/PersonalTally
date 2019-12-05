import 'package:flutter/foundation.dart';
import './user.dart';

class Transaction {
  final String id;
  final User user;
  final int amount;
  final String description;
  final String type;

  Transaction({
    @required this.id,
    @required this.amount,
    @required this.description,
    @required this.user,
    @required this.type,
  });
}
