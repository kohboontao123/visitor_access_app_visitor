
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visitor_access_app_visitor/screen/home_screen.dart';
import '../api/firebase_api.dart';
import '../class/class.dart';
import '../function/auth.dart';
import '../model/user_model.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey=GlobalKey<FormState>();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _idTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _comfirmPasswordTextController = TextEditingController();
  late List<String> listOfValue=['Male','Female'];
  final _auth= FirebaseAuth.instance;
  String? errorMessage;
  UploadTask? uploadTask;
  late File fileImg;
  bool _isLoading= false;
  bool _isBtnDisable = false;
  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(text:Visitor.name);
    _idTextController = TextEditingController(text:Visitor.icNumber);
    _addressTextController = TextEditingController(text:Visitor.address);
  }

  @override
  Widget build(BuildContext context) {
    final nameField=  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
          controller:_nameTextController,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
          ],
          validator: (value){
            if (value!.isEmpty){
              return ("Please Enter Your Name");
            }
            return null;
          },
          onSaved:(value){
            _nameTextController.text=value!;
          },
          decoration: InputDecoration(
              hintText: "Your Name",
              labelText: "Full Name (as per Mykad)",
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
        keyboardType: TextInputType.number,
        controller:_idTextController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9-]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Your ID Number");
          }
          if (value.length != 14 ){
            return ("ID must equal 14 digits\n including [-] ");
          }
          return null;
        },
        onSaved:(value){
          _idTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Your ID Number",
            labelText: "ID Number",
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
            return ("Please Enter Your Address");
          }

          return null;
        },
        onSaved:(value){
          _addressTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Your Address",
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
    final emailField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
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
            labelText: "Email Address",
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
            return ("Please Enter Your Phone Number");
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
            hintText: "Your Phone Number",
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
    final passwordField =  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
          controller:_passwordTextController,
        validator: (value){
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty){
            return ("Password is required for register");
          }
          if (!regex.hasMatch(value)){
            return ("PLease Enter Valid Password(Min. 6 Character");
          }
        },
        onSaved:(value){
          _passwordTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Your Password",
            labelText: "Password",
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
        obscureText: true,
        //maxLength: 20,
      ),
    );
    final confirmPasswordField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        controller:_comfirmPasswordTextController,
        validator: (value){
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty){
            return ("Password is required for register");
          }
          if (!regex.hasMatch(value)){
            return ("PLease Enter Valid Password(Min. 6 Character");
          }
        },
        onSaved:(value){
          _comfirmPasswordTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Confirm Your Password",
            labelText: "Confirm Password",
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
        obscureText: true,
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
                      labelText: "Gender",
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
                      Visitor.gender = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      Visitor.gender = value;
                    });
                  },
                  validator: (value) {
                    if (value=="") {
                      return "can't empty";
                    } else {
                      return null;
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
    final btnRegister = MaterialButton(
      onPressed: _isBtnDisable? null: ()async {
        if(_isLoading)return;
        setState((){
          _isLoading=true;
          if (_passwordTextController.text==_comfirmPasswordTextController.text){
            signUp( _emailTextController.text, _passwordTextController.text,context);
          }else{
            Fluttertoast.showToast(msg: "Please ensure that the password and the confirmation password are the same.");
            _isLoading=false;
          }
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
                      'Register',
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
        appBar:AppBar(
          backgroundColor: Colors.cyan,
          elevation: 0,
          title:Text('Identity Information',),
        ),
        body:Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Review your details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                      width: double.infinity,
                      height: 40,
                      color:  Colors.deepPurple[100],
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.warning),
                          SizedBox(width: 20),
                          const Text("Please fill in your real information, it cannot \nbe modified after verification",
                              style: TextStyle(fontSize : 15)),
                        ],
                      )
                  ),
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 75.0,
                  backgroundImage: Image.memory(Visitor.userImage).image, //here
                ),
                SizedBox(height: 20),
                nameField,
                SizedBox(height: 20),
                genderDropDown,//gender
                //idField,
                SizedBox(height: 20),
                addressField,
                SizedBox(height: 20),
                emailField,
                SizedBox(height: 20),
                phoneField,
                SizedBox(height: 20),
                passwordField,
                SizedBox(height: 20),
                confirmPasswordField,
                SizedBox(height: 20),
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
                btnRegister,
              ],
            ),
          ),
        ),
    );
  }

  void signUp(String email, String password,context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore(context),})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
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
        setState(()=>_isLoading=false);
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore(context) async {
    // calling our firestore
    // calling our user model
    // sedning these values
    Fluttertoast.showToast(msg: "Please wait...");
    _isBtnDisable=true;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name=_nameTextController.text;
    userModel.address=_addressTextController.text;
    userModel.gender= Visitor.gender;
    userModel.phoneNumber=_phoneNumberTextController.text;
    userModel.icNumber=_idTextController.text;
    userModel.userImage=await uploadVisitorImage();
    userModel.icImage=await uploadIC();
    userModel.status='active';
    _isBtnDisable=true;
    await firebaseFirestore
        .collection("visitor")
        .doc(user.uid)
        .set(userModel.toMap());
    authorizeAccess(context);
    _isBtnDisable=false;
  }
  Future<String> uploadVisitorImage() async {
    final decodedBytes = Visitor.userImage;
    final directory = await getApplicationDocumentsDirectory();
    fileImg = File('${directory.path}/${_idTextController.text+"_"+_nameTextController.text}');
    fileImg.writeAsBytesSync(List.from(decodedBytes));
    final facePath= 'visitorImage/${basename(fileImg.path)}';
    final faceRef=FirebaseStorage.instance.ref().child(facePath);
    uploadTask=faceRef.putFile(fileImg);

    final faceSnapshot= await uploadTask!.whenComplete(() {});
    return await faceSnapshot.ref.getDownloadURL();
  }
  Future<String> uploadIC() async {
    final path= 'visitorIC/${_idTextController.text+"_"+_nameTextController.text}';
    final file= File(Visitor.icImage);
    final ref=FirebaseStorage.instance.ref().child(path);
    uploadTask=ref.putFile(file);
    final snapshot= await uploadTask!.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();

  }
  void authorizeAccess(context){
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
          authclass.storeTokenAndData(Visitor.uid),
          Fluttertoast.showToast(
              msg: "Account created successfully :) ",
              toastLength: Toast.LENGTH_LONG),
          Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false),

        }).catchError((error) =>
        {
          Fluttertoast.showToast(msg: error.toString())
        }),

      } else {
        Fluttertoast.showToast(
            msg: "User not found.",
            toastLength: Toast.LENGTH_LONG),
      }

    })
        .catchError((error) =>
    {
      Fluttertoast.showToast(msg: "An error occured."),
    });
  }
  }

