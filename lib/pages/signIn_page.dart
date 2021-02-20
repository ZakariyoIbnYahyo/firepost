import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/home_page.dart';
import 'package:firepost/pages/signUp_page.dart';
import 'package:firepost/services/auth_service.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/utils_service.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static final String id = "signIn_page";
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  var emailController = TextEditingController();
  var pwController = TextEditingController();

  _doSignIn(){
    String email = emailController.text.toString().trim();
    String password = pwController.text.toString().trim();
    if(email.isEmpty || password.isEmpty) return;

    AuthService.signInUser(context, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser),
    });
  }


  _getFirebaseUser(FirebaseUser firebaseUser)async{
    if(firebaseUser != null){
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushNamed(context, HomePage.id);
    }else{
      Utils.fireToast("Check your email or password");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              obscureText: true,
              controller: pwController,
              decoration: InputDecoration(
                hintText: "Password",
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                color: Colors.blue,
                child: Text("Sing In", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  _doSignIn();
                },
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Don't have an account?"),
                SizedBox(width: 5,),
                GestureDetector(
                  child: Text("Sign Up", style: TextStyle(color: Colors.blue, fontSize: 20),),
                  onTap: (){
                    Navigator.pushNamed(context, SignUpPage.id);
                  },
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
