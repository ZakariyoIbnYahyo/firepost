import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/detail_page.dart';
import 'package:firepost/pages/home_page.dart';
import 'package:firepost/pages/signIn_page.dart';
import 'package:firepost/pages/signUp_page.dart';
import 'package:flutter/material.dart';

import 'services/prefs_service.dart';

void main() {
  runApp(MyApp());
}

  Widget _startPage(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          Prefs.saveUserId(snapshot.data.uid);
          return HomePage();
        } else{
          Prefs.removeUserId();
          return SignInPage();
        }
      },
    );
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _startPage(),
      routes: {
        HomePage.id:(context) => HomePage(),
        SignInPage.id:(context) => SignInPage(),
        SignUpPage.id:(context) =>SignUpPage(),
        DetailPage.id:(context) => DetailPage(),
      },
    );
  }
}
