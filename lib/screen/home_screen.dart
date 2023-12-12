import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:visitor_access_app_visitor/class/class.dart';
import 'package:visitor_access_app_visitor/screen/drawer_screen.dart';
import 'package:visitor_access_app_visitor/widget/invitationCard.dart';
import 'package:intl/intl.dart';

import 'edit_visitor.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.1,
        iconTheme:IconThemeData(
          color: Colors.blueGrey,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 16,right: 16,top: 16),
            child:GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => EditVisitorScreen()), (route) => true);
                },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: Image.network(Visitor.userImage).image, //here
              ),
            )
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      drawer: DrawerScreen(),
      body: Container(
        child: ListView(
          physics: ScrollPhysics(),
          children: [
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16,bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Welcome back',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700]
                    ),
                  ),
                  Text(
                      Visitor.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
            ),
            InvitationCard(),

          ],
        ),
      ),
    );
  }

  void updateInvitationStatus(String documentID,String name, String status){
    var collection = FirebaseFirestore.instance.collection('invitation');
    collection
        .doc(documentID) // <-- Doc ID where data should be updated.
        .update({'status':status}) // <-- Nested value
        .then((_) => Fluttertoast.showToast(msg: "You successfully responded to $name invitation"))
        .catchError((error) =>  Fluttertoast.showToast(msg: 'Update failed: $error'));
  }
  void qrCode(String invitationID){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Container(
              child: Center(
                child: QrImage(
                  data: invitationID,
                  size: 300,
                  backgroundColor: Colors.white,
                ),
              )
          );
        }
    );
  }
}

