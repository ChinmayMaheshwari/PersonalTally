import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/list_transaction.dart';
import './provider/transactions.dart';
import './provider/users.dart';
import './screens/txDetailScreen.dart';
import './screens/add_transaction_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Transactions(),
        ),
        ChangeNotifierProvider.value(
          value: Users(),
        )
      ],
      child: MaterialApp(
        title: 'PersonalTally',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.cyan,
          accentColor: Colors.red,
        ),
        home: ListTransaction(),
        routes: {
          AddTransactionScreen.routeName: (ctx) => AddTransactionScreen(),
          TxDetailScreen.routeName: (ctx) => TxDetailScreen(),
        },
      ),
    );
  }
}
