import 'package:input_data_to_excel/LoginPage/SignInPageWithUserId.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '조지형 국어학원',
      theme: ThemeData(
        fontFamily: 'Godo',
        primarySwatch: Colors.blue,

      ),
      home: SignInPageWithUserId(),
    );
  }
}
