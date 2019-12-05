import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/users.dart';
import '../models/user.dart';
import '../provider/transactions.dart';

class AddTransactionForm extends StatefulWidget {
  final int intial;
  AddTransactionForm(this.intial);
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  List<User> _listItems = [];
  List _listType = ['Credit', 'Debit'];
  User _selectedUser;
  var _type = 'Credit';
  final amount = TextEditingController();
  final description = TextEditingController();

  @override
  void didChangeDependencies() {
    final _items = Provider.of<Users>(context).users;
    _listItems = _items;
    _selectedUser = _items[widget.intial];
    //print(_listItems);
    super.didChangeDependencies();
  }

  void _submitTx(bool sub) {
    if (description.text.isEmpty && !sub) {
      return;
    }
    final txAmount = amount.text;
    final txDescription = description.text;

    if (int.parse(txAmount) <= 0) {
      return;
    }
    Provider.of<Transactions>(context, listen: false)
        .addTx(_selectedUser, _type, txAmount, txDescription);

    Navigator.of(context).pop();
  }

  void dropButtonType(String newItem) {
    setState(() {
      _type = newItem;
    });
  }

  void dropButtonUser(User newItem) {
    setState(() {
      _selectedUser = newItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: new DropdownButton<User>(
              elevation: 2,
              iconSize: 30,
              isExpanded: true,
              items: _listItems.map((item) {
                return DropdownMenuItem<User>(
                  value: item,
                  child: Text(item.name),
                );
              }).toList(),
              value: _selectedUser,
              onChanged: (selectedItem) => dropButtonUser(selectedItem),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: new DropdownButton<String>(
              elevation: 2,
              iconSize: 30,
              items: _listType.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              value: _type,
              disabledHint: Text('Not Applicable'),
              onChanged: _selectedUser.name == 'Self'
                  ? null
                  : (selectedType) => dropButtonType(selectedType),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: amount,
              decoration: InputDecoration(labelText: 'Enter Amount'),
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_) => _submitTx(false),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: description,
              decoration: InputDecoration(labelText: 'Enter Description'),
              onFieldSubmitted: (_) => _submitTx(true),
            ),
          ),
          FlatButton(
            child: Text('Add Tx'),
            onPressed: () => _submitTx(true),
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              //side: BorderSide(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
