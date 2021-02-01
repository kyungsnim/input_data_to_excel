import 'package:input_data_to_excel/LoginPage/SignInPageWithUserId.dart';
import 'package:input_data_to_excel/services/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() {
    print("completed");
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
              create: (_) => AuthService()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '조지형 국어학원',
          theme: ThemeData(
            fontFamily: 'Godo',
            primarySwatch: Colors.blue,
          ),
          home: SignInPageWithUserId(),
        ));
  }
}
