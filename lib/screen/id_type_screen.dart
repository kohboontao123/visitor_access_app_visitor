import 'dart:convert';

import 'package:flutter/material.dart';

import 'camera_screen.dart';

class IDTypeScreen extends StatefulWidget {
  const IDTypeScreen({Key? key}) : super(key: key);

  @override
  State<IDTypeScreen> createState() => _IDTypeScreenState();
}

class _IDTypeScreenState extends State<IDTypeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        title:Text('Take ID Photo',),
      ),
      body:Column(
          children:[
            /*Image.asset('assets/images/scan_ic_icon.png',
              height: 90,  //10% of screen height
              width: 150,
            ),*/
            SizedBox(height: 30,),
            Text(
              'Before You Start',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28
              ),
              textAlign: TextAlign.left,
            ),

            SizedBox( height:40),
            Image.asset('assets/images/ic_sample.png',
                height: 200,  //10% of screen height
                width: 300,
                fit:BoxFit.fitWidth),
            SizedBox( height:40),
            Text(
              '-Flash is not recommended.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15
            ),
            ),
            SizedBox( height:20),
            Text('-Ensure identity card is within frame',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15
              ),
            ),
            SizedBox( height:20),
            Text('-Identity card picture is clear, without any reflection',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15
              ),
            ),
            SizedBox( height:100),
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
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> CameraScreen()));

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
          ]

      ),
    );
  }

}
