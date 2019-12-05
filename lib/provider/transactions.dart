import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../helper/db_helper.dart';
import './users.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    return [..._transactions];
  }

  void addTx(User userId, String type, String amount, String description) {
    if (type == 'Credit') {
      userId.balance += int.parse(amount);
    } else {
      userId.balance -= int.parse(amount);
    }
    DBHelper.updateUserBalance({
      'id': userId.id,
      'balance': userId.balance,
      'name': userId.name,
      'phone': userId.number,
    });
    _transactions.insert(
      0,
      Transaction(
        id: DateTime.now().toString(),
        type: type,
        amount: int.parse(amount),
        user: userId,
        description: description.isEmpty ? 'No Description' : description,
      ),
    );
    notifyListeners();
    try {
      DBHelper.insertTransaction({
        'id': DateTime.now().toString(),
        'amount': int.parse(amount),
        'description': description.isEmpty ? 'No Description' : description,
        'type': type,
        'user': userId.id,
      });
    } catch (error) {
      print(error);
    }
  }

  List<Transaction> filterTxByUser(User userId, String type) {
    if (type != 'All') {
      return _transactions.where((trans) {
        return trans.user.id == userId.id && trans.type == type;
      }).toList();
    } else {
      return _transactions.where((trans) {
        return trans.user.id == userId.id;
      }).toList();
    }
  }

  Future<void> fetchAndSetTransaction(BuildContext context) async {
    final datalist = await DBHelper.getTxs();
    try {
      _transactions = datalist
          .map(
            (item) => Transaction(
              id: item['id'],
              type: item['type'],
              amount: item['amount'],
              description: item['description'],
              user: Provider.of<Users>(context, listen: false).users.firstWhere(
                    (test) => test.id == item['user'],
                  ),
            ),
          )
          .toList();
    } catch (error) {
      print(error);
    }
    //print(_transactions);
    notifyListeners();
  }

  void removeTx(String txId) {
    final int i = _transactions.indexWhere((test) => txId == test.id);
    final tx = _transactions[i];
    if (tx.type == 'Credit') {
      tx.user.balance -= tx.amount;
    } else {
      tx.user.balance += tx.amount;
    }
    User userId = tx.user;
    _transactions.removeAt(i);
    notifyListeners();
    DBHelper.deletetx(txId);
    DBHelper.updateUserBalance({
      'id': userId.id,
      'balance': userId.balance,
      'name': userId.name,
      'phone': userId.number,
    });
  }
}
