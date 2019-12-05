import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../provider/transactions.dart';
import 'package:provider/provider.dart';

class TxDetail extends StatelessWidget {
  final i;
  final User user;
  final Transactions allTx;
  final String type;
  TxDetail(
    this.i,
    this.allTx,
    this.user,
    this.type,
  );
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(allTx.filterTxByUser(user, type)[i].id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 20,
        ),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure'),
                  content: Text('Do you want to remove transaction?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(DateFormat.MMMd().format(
                DateTime.parse(allTx.filterTxByUser(user, type)[i].id))),
            Text(
              DateFormat.E().format(
                  DateTime.parse(allTx.filterTxByUser(user, type)[i].id)),
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        title: Text(
          allTx.filterTxByUser(user, type)[i].description,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: allTx.filterTxByUser(user, type)[i].description ==
                      'No Description'
                  ? Colors.grey
                  : Colors.black,
              fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          allTx.filterTxByUser(user, type)[i].amount.toString(),
          style: TextStyle(
              color: allTx.filterTxByUser(user, type)[i].type == 'Debit'
                  ? Colors.red
                  : Colors.green,
              fontWeight: FontWeight.w900),
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Transactions>(context, listen: false)
            .removeTx(allTx.filterTxByUser(user, type)[i].id);
      },
    );
  }
}
