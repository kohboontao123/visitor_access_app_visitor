import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitor_access_app_visitor/model/user_model.dart';

class InvitationList extends StatefulWidget {
  const InvitationList({Key? key}) : super(key: key);

  @override
  State<InvitationList> createState() => _InvitationListState();
}

class _InvitationListState extends State<InvitationList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('invitation')
            .where("visitorID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('startDate', descending: true)
            .snapshots(),
        builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.data!.docs.length!=0){
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('resident')
                    .where("uid",isEqualTo:snapshot.data!.docs[0]['residentID'])
                    .snapshots(),
                builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        return Padding(
                            padding: EdgeInsets.all(15),
                            child:Container(
                              height: MediaQuery.of(context).size.height*0.3,
                              width: MediaQuery.of(context).size.width*0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Colors.grey[200],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      height: MediaQuery.of(context).size.height*0.08,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(28),
                                          topRight: Radius.circular(28),
                                        ),
                                        color: Colors.cyan,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            top: 12,
                                            right: 15
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      'Invitation Request',
                                                      textAlign: TextAlign.left,
                                                      style:TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white
                                                      )
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.access_time_sharp,
                                                        size: 15,
                                                        color: Colors.white54,
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                          '1 January 2023',
                                                          textAlign: TextAlign.left,
                                                          style:TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w700,
                                                              color: Colors.white54
                                                          )
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              tooltip: 'Details',
                                              onPressed: () {
                                                setState(() {
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        left: 15,
                                        right: 15
                                    ),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          radius: 45,
                                          backgroundImage: Image.network( streamSnapshot.data!.docs[index]['userImage']).image, //here
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              streamSnapshot.data!.docs[index]['name'],
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                            child: Text(
                                                "Accept".toUpperCase(),
                                                style: TextStyle(fontSize: 14)
                                            ),
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                backgroundColor:MaterialStateProperty.all<Color>(Colors.cyan),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.0),
                                                        side: BorderSide(color: Colors.cyan)
                                                    )
                                                )
                                            ),
                                            onPressed: () {
                                              updateInvitationStatus( snapshot.data!.docs[index].reference.id,streamSnapshot.data!.docs[index]['name'], 'Accepted');
                                            }
                                        ),
                                        SizedBox(width: 10),
                                        TextButton(
                                            child: Text(
                                                "Reject".toUpperCase(),
                                                style: TextStyle(fontSize: 14)
                                            ),
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                                                backgroundColor:MaterialStateProperty.all<Color>(Colors.white),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.0),
                                                        side: BorderSide(color: Colors.cyan)
                                                    )
                                                )
                                            ),
                                            onPressed: () {
                                              updateInvitationStatus( snapshot.data!.docs[index].reference.id, streamSnapshot.data!.docs[index]['name'], 'Rejected');
                                            }
                                        ),
                                      ]
                                  )

                                ],
                              ),
                            )
                        );
                      }
                  );
                }
            );
          }else{
            return Text('No Data');
          }
        }
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
}
