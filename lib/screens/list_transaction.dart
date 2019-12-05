import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './add_transaction_screen.dart';
import '../provider/users.dart';
import '../models/user.dart';
import '../widgets/user_tx.dart';

class ListTransaction extends StatefulWidget {
  @override
  _ListTransactionState createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  List<User> usersTx;
  var val = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Tally'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pushNamed(
                AddTransactionScreen.routeName,
                arguments: Provider.of<Users>(context, listen: false).users[0]),
          ),
          PopupMenuButton(
            onSelected: (int value) {
              setState(() {
                val = value;
                // usersTx = Provider.of<Users>(context, listen: false)
                //     .filterUserbyBalance(val);
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: const Text('Credit Only'),
                value: 0,
              ),
              PopupMenuItem(
                child: const Text('Debit Only'),
                value: 1,
              ),
              PopupMenuItem(
                child: const Text('Show All'),
                value: 2,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<Users>(context, listen: false).fetchAndSetUsers(),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<Users>(
                      builder: (ctx, usersTx, ch) => ListView.builder(
                        itemCount: usersTx.filterUserbyBalance(val).length,
                        itemBuilder: (ctx, i) => Column(
                          children: <Widget>[
                            UsersTx(
                              usersTx.filterUserbyBalance(val)[i],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context).pushNamed(
                AddTransactionScreen.routeName,
                arguments: Provider.of<Users>(context, listen: false).users[0],
              )),
    );
  }
}
