import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitor_access_app_visitor/screen/home_screen.dart';
import 'package:visitor_access_app_visitor/screen/login_screen.dart';


import 'class/class.dart';
import 'function/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: const FirebaseOptions(
    apiKey: "AAAA8eTjZ2c:APA91bEW1bmGlZIP59wnFfyVAUCfAb1e-6677HEo7WvVCTMUGrYOgeN18bSyWpiKiSvhsvSnGRNJ7OwNREGUbXK12dPACGrsJ-pihDzV3WHeSmK1r-ANafx0aCiKpLGjYLaazUPZfr3P", // Your apiKey
    appId: "1:1038927226727:android:227c7e95bd5301f59771c2", // Your appId
    messagingSenderId: "1038927226727", // Your messagingSenderId
    projectId: "fypproject-42f8d", // Your projectId
  ));*/
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    checkLogin();
  }
  late Widget currentPage= LoginScreen() ;
  AuthClass authclass=AuthClass();
  void checkLogin() async{
    String? token=await authclass.getToken();
    if (token!=null){
      Fluttertoast.showToast(msg:'logging...');
      FirebaseFirestore.instance
          .collection('visitor').doc(token).get()
          .then((DocumentSnapshot documentSnapshot) =>{
        Visitor.uid=documentSnapshot['uid'],
        Visitor.email=documentSnapshot['email'],
        Visitor.name=documentSnapshot['name'],
        Visitor.userImage=documentSnapshot['userImage'],
        Visitor.icImage=documentSnapshot['icImage'],
        Visitor.icNumber=documentSnapshot['icNumber'],
        Visitor.address=documentSnapshot['address'],
        Visitor.phoneNumber=documentSnapshot['phoneNumber'],
        Visitor.gender=documentSnapshot['gender'],
        Visitor.status=documentSnapshot['status'],
        if(documentSnapshot['status']=='active'){
          setState((){
            currentPage=HomeScreen();
          }),
        }else{
          Fluttertoast.showToast(msg: 'Your account has been deactivated, please contact admin'),
          setState((){
            currentPage=LoginScreen();
          }),
        }
      }).catchError((error) =>
      {
        Fluttertoast.showToast(msg: error.toString()),
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitor Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:currentPage,
        //LoginScreen(),
                    //HomeScreen(),
                    //IDTypeScreen(),
                    //ScanFaceScreen(),
                    //RegisterScreen(),
        //CameraScreen(),

      //IDTypeScreen(),
      //ScanFaceScreen(),
      //RegisterScreen(),
    );
  }
}


