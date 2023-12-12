import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;

import '../class/class.dart';
import 'id_type_screen.dart';
import 'login_screen.dart';

class ScanFaceScreen extends StatefulWidget {
  const ScanFaceScreen({Key? key}) : super(key: key);

  @override
  State<ScanFaceScreen> createState() => _ScanFaceScreenState();
}

class _ScanFaceScreenState extends State<ScanFaceScreen> {
  @override
  Widget build(BuildContext context) {
    final loginButton= Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('I`m a member! ',
          style:TextStyle(
            fontWeight:FontWeight.bold,
          ),
        ),
        GestureDetector(
          child: Text(
            ' Login Now',
            style:TextStyle (
              color:Colors.blue,
              fontWeight:FontWeight.bold,
            ),
          ),
          onTap: ()=>{
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> LoginScreen()))
          },
        ),
      ],
    );
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        title:Text('Scan Face',),
      ),
      body:Column(
          children:[
            SizedBox(height: 20,),
           Row(
             children:[
               SizedBox(width: 20,),
               Text(
                 'We need your selfie',
                 style: TextStyle(
                     color: Colors.black,
                     fontWeight: FontWeight.bold,
                     fontSize: 28
                 ),
                 textAlign: TextAlign.left,
               ),
             ]
           ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 20,),
                Text(
                  'This is to ensure the owner of the submitted ID \nand the app user are the same',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox( height:20),
            Image.asset('assets/images/faceRecognitionIllustration.png',
                height: 300,  //10% of screen height
                width: 300,
                fit:BoxFit.fitWidth),
            SizedBox( height:30),
            Text(
              '-Position your face within the frame',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15
              ),
            ),
            SizedBox( height:10),
            Text('-Make sure it`s clear and bright enough',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15
              ),
            ),
            SizedBox( height:10),
            Text('-Face will be detectd automatically within 3s',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15
              ),
            ),
            SizedBox( height:30),
            Row(
                children:[
                  SizedBox( width:20),
                  Icon(
                    Icons.shield,
                    size:30,
                    color: Colors.green,
                  ),
                  SizedBox( width:10),
                  Column(
                    children: [
                      Text('Rest assured that your data are kept secure \nand confidential ',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15
                        ),
                      ),
                    ],
                  )
                ]
            ),
            SizedBox( height:10),
            MaterialButton(
              onPressed: () {
                liveness();
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
                        'I`m Ready',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      ),
                    )
                ),
              ),
            ),
            SizedBox(height: 10),
            loginButton,
          ]

      ),
    );
  }

  liveness() => Regula.FaceSDK.startLiveness().then((value) {
    var result = Regula.LivenessResponse.fromJson(json.decode(value));
    String _liveness;
    setState(() => _liveness = result?.liveness == 0 ? "passed" : "unknown");
    if (result?.liveness == 0){
      Visitor.userImage= base64Decode(result!.bitmap!.replaceAll("\n", ""));
        Navigator.push(context, MaterialPageRoute(builder: (context)=> IDTypeScreen()));
    }else{
      Fluttertoast.showToast(msg: "Please try again");
    }

  });

}
