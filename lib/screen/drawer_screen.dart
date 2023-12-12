import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitor_access_app_visitor/class/class.dart';
import 'package:visitor_access_app_visitor/function/auth.dart';
import 'package:visitor_access_app_visitor/screen/list_view_page.dart';
import 'package:visitor_access_app_visitor/screen/list_view_page.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*0.2,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: Image.network(Visitor.userImage).image, //here
                  ),
                  SizedBox(height: 10,),
                  Text(
                    Visitor.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:24),
            child: ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
              ),
            ),
            onTap: (){
              Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
            },
          ),
          ),
          Padding(
            padding: EdgeInsets.only(left:24),
            child: ListTile(
              leading: Icon(Icons.library_books_outlined),
              title: Text('Invitation List',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
              onTap: (){
                Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => ListViewScreen()), (route) => false);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:24),
            child: ListTile(
              leading: Icon(Icons.password_outlined),
              title: Text('Reset Password',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
              onTap: (){
                resetPassword();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:24),
            child: ListTile(
              leading: Icon(Icons.exit_to_app_outlined),
              title: Text('Exit',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
              onTap: (){
                logout(context);
              },
            ),
          ),
        ],

      ),
    );

  }
  Future<void> logout(BuildContext context) async {
    AuthClass authclass=AuthClass();
    await authclass.logout();
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "You have been logged out");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
  Future resetPassword()async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: Visitor.email);
      Fluttertoast.showToast(msg: "Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }
}
