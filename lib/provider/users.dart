import 'package:flutter/foundation.dart';
import 'package:personaltally/helper/db_helper.dart';
import '../models/user.dart';

class Users with ChangeNotifier {
  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<void> addUser(String name, num phone) {
    _users.add(User(
      name: name,
      number: phone,
      id: DateTime.now().toString(),
      balance: 0,
    ));
    notifyListeners();
    return DBHelper.insertUser({
      'id': DateTime.now().toString(),
      'balance': 0,
      'name': name,
      'phone': phone,
    });
  }

  List<User> filterUserbyBalance(int val) {
    return _users.where((user) {
      if (val == 0) {
        return user.balance > 0;
      } else if (val == 1) {
        return user.balance < 0;
      } else {
        return true;
      }
    }).toList();
  }

  Future<void> fetchAndSetUsers() async {
    final datalist = await DBHelper.getUserData();
    //print(datalist);
    try {
      _users = datalist
          .map(
            (item) => User(
              id: item['id'].toString(),
              balance: item['balance'],
              name: item['name'],
              number: num.parse(item['phone'].toString()),
            ),
          )
          .toList();
    } catch (error) {
      print(error);
    }
    // _users.insert(0, User(name: 'Self', id: 'Self', balance: 0));
    //print(_users);
    notifyListeners();
  }
}
