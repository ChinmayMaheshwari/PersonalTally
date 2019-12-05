import 'package:flutter/material.dart';
import '../widgets/add_user.dart';
import '../widgets/add_transaction.dart';
import '../provider/users.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class AddTransactionScreen extends StatelessWidget {
  static const String routeName = '/add-tx';

  void addNewUser(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return AddUser();
        });
  }

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Transaction'),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              height: double.infinity,
              child: Text(
                'Add User',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () => addNewUser(context),
          ),
        ],
      ),
      body: AddTransactionForm(Provider.of<Users>(context).users.indexWhere(
            (item) => user.id == item.id,
          )),
    );
  }
}
