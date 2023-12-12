import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitor_access_app_visitor/screen/home_screen.dart';

import '../class/class.dart';
import '../function/auth.dart';
import 'reset_screen.dart';
import 'scan_face_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey=GlobalKey<FormState>();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  final _auth= FirebaseAuth.instance;
  bool buttonDisable=false;
  String? errorMessage;
  var _firstPress = true;
  bool _isBtnDisable = false;
  @override
  Widget build(BuildContext context) {
    final emailField =  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child:TextFormField(
          cursorColor: Colors.black,
          style: TextStyle(color: Colors.black.withOpacity(0.9)),
          autofocus:false,
          controller:  _emailTextController,
          keyboardType: TextInputType.emailAddress,
          validator: (value){
            if (value!.isEmpty){
              return ("Please Enter Your Email");
            }
            if (!RegExp("^[a-zA-Z0-9+.-]+@[a-zA-Z0-9+.-]+.[a-z]").hasMatch(value)){
              return ("Please Enter a valid email");
            }
            return null;
          },
          onSaved:(value){
            _emailTextController.text=value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText:"Email",
              filled: true,
              floatingLabelBehavior:FloatingLabelBehavior.never,
              fillColor: Colors.white.withOpacity(0.3),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 100,style: BorderStyle.none)
              )

          ),
        ));
    final passwordField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black.withOpacity(0.9)),
        autofocus:false,
        controller:  _passwordTextController,
        obscureText: true,
        validator: (value){
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty){
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)){
            return ("PLease Enter Valid Password(Min. 6 Character");
          }
        },
        onSaved:(value){
          _passwordTextController.text=value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText:"Password",
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
            filled: true,
            floatingLabelBehavior:FloatingLabelBehavior.never,
            fillColor: Colors.white.withOpacity(0.3),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 100,style: BorderStyle.none)
            )

        ),
      ),);
    final loginButton = MaterialButton(
        onPressed:() {
          setState((){
            if(_firstPress){
              _firstPress=false;
              signIn( _emailTextController.text, _passwordTextController.text);
              _isBtnDisable=false;
            }else{
              Fluttertoast.showToast(msg: "Please wait a while");
              _isBtnDisable=false;
            }
          });


      },
      child: Padding(
        padding:const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Sign In',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
            )
        ),
      ),
    );
    final signUpButton= Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Not a member? ',
          style:TextStyle(
            fontWeight:FontWeight.bold,
          ),
        ),
        GestureDetector(
          child: Text(
            ' Register now',
            style:TextStyle (
              color:Colors.blue,
              fontWeight:FontWeight.bold,
            ),
          ),
          onTap: ()=>{
            //livenes(),
             Navigator.push(context,
                MaterialPageRoute(builder: (context)=> ScanFaceScreen()))
          },
        ),
      ],
    );
    return Scaffold(
      backgroundColor:Colors.grey[300],
      body:Center(
          child: Form(
            key:_formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people,
                    size:100,
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Hello Again!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'It\'s so good to have you back!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    child: emailField,
                  ),
                  SizedBox(height: 20),
                  passwordField,
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text('Forget Password?',
                        style:TextStyle(
                            fontWeight:FontWeight.bold,
                            color: Colors.blue
                        ),),
                      onTap: ()=>{
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> ResetPasswordScreen()))
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  loginButton,
                  SizedBox(height: 20),
                  signUpButton,
                ],
              ),
            )
          )
        )

    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      _isBtnDisable=true;
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
        FirebaseFirestore.instance
            .collection('visitor').doc(FirebaseAuth.instance.currentUser?.uid).get()
            .then((DocumentSnapshot documentSnapshot) =>{
              if (documentSnapshot.exists&&documentSnapshot['status']!='active'){
                Fluttertoast.showToast(msg: 'Your account has been deactivated, please contact admin'),
                _firstPress=true,
              } else if (documentSnapshot.exists&&documentSnapshot['status']=='active'){
                authorizeAccess(),
                _isBtnDisable=false,
              }else{
                Fluttertoast.showToast(msg: 'User not found'),
                _firstPress=true, _isBtnDisable=false,
              }

            },
        )
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        _firstPress=true;
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }

  }
  void authorizeAccess(){
    AuthClass authclass=AuthClass();
    User? user = _auth.currentUser;
    FirebaseFirestore.instance
        .collection('visitor').doc(user?.uid).get()
        .then((DocumentSnapshot documentSnapshot) =>
    {
      if (documentSnapshot.exists) {
        FirebaseFirestore.instance
            .collection('visitor').doc(documentSnapshot['uid']).get()
            .then((DocumentSnapshot documentSnapshot) =>{
          Visitor.uid=documentSnapshot['uid'],
          Visitor.email=documentSnapshot['email'],
          Visitor.address=documentSnapshot['address'],
          Visitor.gender=documentSnapshot['gender'],
          Visitor.icImage=documentSnapshot['icImage'],
          Visitor.icNumber=documentSnapshot['icNumber'],
          Visitor.phoneNumber=documentSnapshot['phoneNumber'],
          Visitor.status=documentSnapshot['status'],
          Visitor.userImage=documentSnapshot['userImage'],
          Visitor.name=documentSnapshot['name'],
          authclass.storeTokenAndData(Visitor.uid),
          Fluttertoast.showToast(
              msg: "Login Successful",
              toastLength: Toast.LENGTH_LONG),
          Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false),
          _isBtnDisable=false
        }).catchError((error) =>
        {
          Fluttertoast.showToast(msg: error.toString())
        }),

      } else {
        Fluttertoast.showToast(
            msg: "User not found.",
            toastLength: Toast.LENGTH_LONG),
            _isBtnDisable=false,
      }

    })
        .catchError((error) =>
    {
      Fluttertoast.showToast(msg: "An error occured."),
    });
  }
}
