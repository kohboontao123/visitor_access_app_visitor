import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../screen/list_view_page.dart';

class InvitationCard extends StatefulWidget {
  const InvitationCard({Key? key}) : super(key: key);

  @override
  State<InvitationCard> createState() => _InvitationCardState();
}

class _InvitationCardState extends State<InvitationCard> {
  @override

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('invitation')
            .where("visitorID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where("status",isEqualTo: 'Pending')
            .orderBy('startDate', descending: true)
            .limit(1)
            .snapshots(),
        builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.data!.docs.length!=0){

            if (DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.docs[0]['endDate'].toDate())).isBefore(DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))==true){
              updateInvitationInformation(snapshot.data!.docs[0].id);
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

                                      ],
                                    ),
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
                              Column(
                                children: [
                                  Text(
                                    'No Invitation',
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
                      ],
                    ),
                  )
              );
            }else{
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
                                                            '${DateFormat.yMMMMEEEEd().format(snapshot.data!.docs[index]['startDate'].toDate())}',
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
                                                  _showInvitationDetails(snapshot.data!.docs[index].reference.id, streamSnapshot.data!.docs[index]['uid']);

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

                                          Container(
                                            width:MediaQuery.of(context).size.width*0.59,

                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      streamSnapshot.data!.docs[index]['name'],
                                                      softWrap: false,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                  ],
                                                )

                                            ),
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
            }
          }else{
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

                                    ],
                                  ),
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
                            Column(
                              children: [
                                Text(
                                  'No Invitation',
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
                    ],
                  ),
                )
            );
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
  updateInvitationInformation(String docID){
    var collection = FirebaseFirestore.instance.collection('invitation');
    collection
        .doc(docID) // <-- Doc ID where data should be updated.
        .update({'checkInStatus':'Expired',
                  'status':'Rejected'}); // <-- Nested value;
  }
  Future<void> _showInvitationDetails(String invitationID,String residentID) async {
    var collection = FirebaseFirestore.instance.collection('resident') .where("uid", isEqualTo: residentID);
    var querySnapshot = await collection.get();
    var iconButton ;
    Map<String, dynamic> data;
    FirebaseFirestore.instance
        .collection('invitation').doc(invitationID).get()
        .then((DocumentSnapshot documentSnapshot) =>{

      if (documentSnapshot.exists){
        for(var queryDocumentSnapshot in querySnapshot.docs){
          data = queryDocumentSnapshot.data(),
          if (data['uid'].toString()== documentSnapshot['residentID'].toString()){
            if(documentSnapshot['status']=='Accepted'&&documentSnapshot['checkInStatus']!='CheckIn'){
              iconButton=Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<
                            Color>(Colors.blue),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18.0),
                            ))),
                    onPressed: () {
                      qrCode(invitationID);
                    },
                    icon: Icon(
                      // <-- Icon
                      Icons.qr_code,
                      size: 24.0,
                    ),
                    label: Text('QR-Code'), // <-- Text
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<
                            Color>(Colors.red),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18.0),
                            ))),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(
                          'dialog');
                    },
                    icon: Icon(
                      // <-- Icon
                      Icons.close,
                      size: 24.0,
                    ),
                    label: Text('Close'), // <-- Text
                  ),
                ],
              )
            }else if (documentSnapshot['status']=='Pending'){
              iconButton=Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<
                                Color>(Colors.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                ))),
                        onPressed: () {
                          updateInvitationStatus( invitationID,data['name'].toString(), 'Accepted');
                          Navigator.of(context, rootNavigator: true).pop(
                              'dialog');
                        },
                        icon: Icon(
                          // <-- Icon
                          Icons.check,
                          size: 24.0,
                        ),
                        label: Text('Accept'), // <-- Text
                      ),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<
                                Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                ))),
                        onPressed: () {
                          updateInvitationStatus( invitationID,data['name'].toString(), 'Rejected');
                          Navigator.of(context, rootNavigator: true).pop(
                              'dialog');
                        },
                        icon: Icon(
                          // <-- Icon
                          Icons.cancel,
                          size: 24.0,
                        ),
                        label: Text('Reject'), // <-- Text
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<
                            Color>(Colors.red),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18.0),
                            ))),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(
                          'dialog');
                    },
                    icon: Icon(
                      // <-- Icon
                      Icons.close,
                      size: 24.0,
                    ),
                    label: Text('Close'), // <-- Text
                  ),

                ],
              )
            }else{
              iconButton=Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<
                            Color>(Colors.red),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18.0),
                            ))),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(
                          'dialog');
                    },
                    icon: Icon(
                      // <-- Icon
                      Icons.cancel,
                      size: 24.0,
                    ),
                    label: Text('Close'), // <-- Text
                  ),
                ],
              )
            },
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    scrollable: true,
                    title: Text(
                      'Invitation Details',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: Image.network(data['userImage'].toString()).image, //here
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text:data['name'].toString()) ,
                              decoration: InputDecoration(
                                labelText: 'Resident Name',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text:data['address'].toString()) ,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                icon: Icon(Icons.location_on),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text:data['phoneNumber'].toString()),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                icon: Icon(Icons.phone ),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text: '${DateFormat('EEE, MMM d, ' 'yy').format(documentSnapshot['startDate'].toDate())}'),
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                icon: Icon(Icons.access_time_outlined ),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text: '${DateFormat('EEE, MMM d, ' 'yy').format(documentSnapshot['endDate'].toDate())}'),
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                icon: Icon(Icons.access_time_outlined ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      iconButton,
                    ],
                  );
                }
            )
          }
          else{
            Row(),
          }
        }

      }else{
        Row(),
      }
    });

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

