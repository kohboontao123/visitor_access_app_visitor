import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitor_access_app_visitor/model/user_model.dart';
import '../class/class.dart';
import 'package:flutter/widgets.dart';



class EditVisitorScreen extends StatefulWidget {
  const EditVisitorScreen({Key? key}) : super(key: key);

  @override
  State<EditVisitorScreen> createState() => _EditVisitorScreenState();
}

class _EditVisitorScreenState extends State<EditVisitorScreen> {
  final _formKey=GlobalKey<FormState>();
  String? errorMessage;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _idTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  UploadTask? uploadTask;
  String imgPath ="";
  var img = Image.network(Visitor.userImage.toString());
  late var gender;
  late List<String> listOfValue=[Visitor.gender];
  bool _isLoading= false;
  bool _btnActiveIsLoading= false;
  bool _isBtnDisable = false;
  void initState(){
    super.initState();
    _nameTextController=TextEditingController(text:Visitor.name);
    _idTextController=TextEditingController(text:Visitor.icNumber);
    _addressTextController=TextEditingController(text:Visitor.address);
    _phoneNumberTextController=TextEditingController(text:Visitor.phoneNumber);
    _emailTextController=TextEditingController(text:Visitor.email);
    gender=Visitor.gender;

  }

  @override
  Widget build(BuildContext context) {
    final emailField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        enabled: false,
        controller:_emailTextController,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9_@.]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Your Email Address");
          }
          if (!RegExp("^[a-zA-Z0-9+.-]+@[a-zA-Z0-9+.-]+.[a-z]").hasMatch(value)){
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved:(value){
          _emailTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Your Email Address",
            labelText: "Email Address (Not Editable)",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 20,
      ),
    );
    final nameField=  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        enabled: false,
        controller:_nameTextController,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Visitor Name");
          }
          return null;
        },
        onSaved:(value){
          _nameTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Visitor Name",
            labelText: "Full Name (as per Mykad) (Not Editable)",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 20,
      ),
    );
    final idField= Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        enabled: false,
        keyboardType: TextInputType.number,
        controller:_idTextController,
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Visitor ID Number");
          }
          if (value.length != 12 ){
            return ("ID must equal 12 digits");
          }
          return null;
        },
        onSaved:(value){
          _idTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Visitor ID Number",
            labelText: "ID.No(Not Editable)",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 14,
      ),
    );
    final addressField= Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        controller:_addressTextController,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9/-]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Visitor Address");
          }

          return null;
        },
        onSaved:(value){
          _addressTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Visitor Address",
            labelText: "Address",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 20,
      ),
    );
    final phoneField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        controller:_phoneNumberTextController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Visitor Phone Number");
          }
          if (value.length < 10){
            return ("Phone Number must more then or equal 10 digits");
          }
          return null;
        },
        onSaved:(value){
          _phoneNumberTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Visitor Phone Number",
            labelText: "Phone Number",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 20,
      ),
    );
    final genderDropDown =SizedBox(
        width: MediaQuery. of(context). size. width,
        child: Row(
          children: [
            Expanded(
                child: idField
            ),
            Expanded(
              child:Padding(
                padding:  EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: "Gender (Not Editable)",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey[600]),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      fillColor: Colors.black12,
                      filled: true),
                  value: Visitor.gender,
                  hint: Text(
                    'choose one',
                  ),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Gender is required';
                    }
                  },
                  items: listOfValue
                      .map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        )
    );
    final btnUpdate = MaterialButton(
      onPressed: _isBtnDisable? null: ()async {
        if(_isLoading)return;
        update();
        setState((){
          _isLoading=true;
        });
        //Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraScreen()));
        await Future.delayed(Duration(seconds: 2));
        setState(()=>_isLoading=false);
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
              child: _isLoading
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(color: Colors.white,)),
                  SizedBox(width:24),
                  Text(
                    'Please wait...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ],
              )
                  :Text(
                'Update',
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
    return Scaffold(
      appBar: AppBar(
        leading:GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child:Icon(
            Icons.arrow_back,
            size: 26.0,

          ),
        ),
        backgroundColor: Colors.cyan,
        elevation: 0,
        title: Text('Edit Visitor Information'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Review visitor details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                },
                child:Container(
                  color: Colors.transparent,
                  child: CircleAvatar(
                    radius: 90.0,
                    backgroundImage: img.image, //here
                  ),

                ),
              ),
              SizedBox(height: 20),
              emailField,
              SizedBox(height: 20),
              GestureDetector(
                child:Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.height*0.2,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,),
                    image: DecorationImage(
                      image: NetworkImage(Visitor.icImage.toString()),
                      fit: BoxFit.cover
                    )
                  ),
                ) ,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                      builder: (BuildContext context){
                          return Scaffold(
                            body: GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Hero(
                                    tag:'Visitor Identity Card',
                                    child: Image.network(
                                      Visitor.icImage.toString(),
                                      fit: BoxFit.fill,),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                }
                            ),
                          );
                      }
                      )
                  );
                },
              ),
              SizedBox(height: 20),
              nameField,
              SizedBox(height: 20),
              genderDropDown,
              SizedBox(height: 20),
              addressField,
              SizedBox(height: 20),
              phoneField,
              SizedBox(height: 20),
              btnUpdate,
              SizedBox( height:5),
            ],
          ),
        ),
      ),
    );
  }
  update() async {
    UserModel visitorModel = UserModel();
    visitorModel.address=_addressTextController.text;
    visitorModel.phoneNumber=_phoneNumberTextController.text;

    var collection = FirebaseFirestore.instance.collection('visitor');
    collection
        .doc(Visitor.uid) // <-- Doc ID where data should be updated.
        .update(visitorModel.update()) // <-- Nested value
        .then((_) =>{
            Visitor.address=_addressTextController.text,
            Visitor.phoneNumber=_phoneNumberTextController.text,
            Fluttertoast.showToast(msg: "The visitor's profile has been successfully updated")
          })
        .catchError((error) =>  Fluttertoast.showToast(msg: 'Update failed: $error'));
  }

}
