import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/users.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void _submitData(bool sub) async{
    if (phoneController.text.isEmpty && !sub) {
      return;
    }
    if (nameController.text.isEmpty) {
      return;
    }
    final enteredName = nameController.text;
    var enteredNo;
    if (phoneController.text.isNotEmpty) {
      enteredNo = num.parse(phoneController.text);
    } else {
      enteredNo = 0;
    }
    await Provider.of<Users>(context, listen: false).addUser(enteredName, enteredNo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                controller: nameController,
                onSubmitted: (_) => _submitData(false),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone No.',
                ),
                controller: phoneController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(true),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  child: Text(
                    'Add User',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple,
                  onPressed: () => _submitData(true),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
