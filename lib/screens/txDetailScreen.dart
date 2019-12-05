import 'package:flutter/material.dart';
import 'package:personaltally/widgets/txDetail.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/transaction.dart';
import '../provider/transactions.dart';
import '../screens/add_transaction_screen.dart';

class TxDetailScreen extends StatefulWidget {
  static const routeName = '/tx-detail-screen';

  @override
  _TxDetailScreenState createState() => _TxDetailScreenState();
}

class _TxDetailScreenState extends State<TxDetailScreen> {
  User user;
  String type = 'All';
  List<Transaction> allTx;

  @override
  void didChangeDependencies() {
    user = ModalRoute.of(context).settings.arguments;
    allTx = Provider.of<Transactions>(context, listen: false)
        .filterTxByUser(user, 'All');

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context)
                .pushNamed(AddTransactionScreen.routeName, arguments: user),
          ),
          PopupMenuButton(
            onSelected: (int val) {
              setState(() {
                if (val == 0) {
                  allTx = Provider.of<Transactions>(context, listen: false)
                      .filterTxByUser(user, 'Credit');
                  type = 'Credit';
                } else if (val == 1) {
                  allTx = Provider.of<Transactions>(context, listen: false)
                      .filterTxByUser(user, 'Debit');
                  type = 'Debit';
                } else {
                  allTx = Provider.of<Transactions>(context, listen: false)
                      .filterTxByUser(user, 'All');
                  type = 'All';
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Credit Only'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('Debit Only'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: 2,
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder<Object>(
        future: Provider.of<Transactions>(context, listen: false)
            .fetchAndSetTransaction(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Transactions>(
                    builder: (ctx, allTx, ch) => ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: allTx.filterTxByUser(user, type).length,
                      itemBuilder: (ctx, i) => TxDetail(i, allTx, user, type),
                    ),
                  ),
      ),
    );
  }
}
