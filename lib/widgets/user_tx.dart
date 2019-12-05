import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/txDetailScreen.dart';

class UsersTx extends StatelessWidget {
  final User user;

  UsersTx(this.user);

  void _onUserTap(User user, BuildContext context) {
    Navigator.of(context).pushNamed(TxDetailScreen.routeName, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: CircleAvatar(
        backgroundColor: user.name == 'Self'
            ? Colors.deepPurple
            : user.balance >= 0
                ? user.balance == 0 ? null : Colors.green
                : Colors.red,
      ),
      title: Text(user.name),
      trailing: Text(
        user.balance.toString(),
        style: TextStyle(
            color: user.name == 'Self'
                ? Colors.deepPurple
                : user.balance >= 0
                    ? user.balance == 0 ? Colors.pink : Colors.green
                    : Colors.red),
      ),
      onTap: () => _onUserTap(user, context),
    );
  }
}
