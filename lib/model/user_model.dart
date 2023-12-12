import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String? uid;
  String? email;
  String? name;
  String? address;
  String? gender;
  String? phoneNumber;
  String? userImage;
  String? icImage;
  String? icNumber;
  String? status;

  UserModel({this.uid,this.email,this.name,this.address,this.gender,this.phoneNumber,this.userImage,this.icImage,this.icNumber,this.status});

  factory UserModel.fromMap(map){
    return UserModel(
      uid:map['uid'],
      email: map['email'],
      name: map['name'],
      address: map['address'],
      gender: map['gender'],
      phoneNumber: map['phoneNumber'],
      userImage: map['userImage'],
      icImage: map['icImage'],
      icNumber: map['icNumber'],
      status: map['status']
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'uid':uid,
      'email':email,
      'name':name,
      'address':address,
      'gender':gender,
      'phoneNumber':phoneNumber,
      'userImage':userImage,
      'icImage':icImage,
      'icNumber':icNumber,
      'status':status
    };
  }
  Map<String,dynamic> update(){
    return{
      'address':address,
      'phoneNumber':phoneNumber,
    };
  }
}

class InvitationModel{
  DateTime? startDate;
  DateTime? endDate;
  DateTime? inviteDate;
  String? residentID;
  String? visitorID;
  String? status;

  InvitationModel({this.startDate,this.endDate,this.inviteDate,this.residentID,this.visitorID,this.status});

  factory InvitationModel.fromMap(map){
    return InvitationModel(
      startDate:map['startDate'],
      endDate: map['endDate'],
      inviteDate: map['inviteDate'],
      residentID: map['residentID'],
      visitorID: map['visitorID'],
      status: map['status'],
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'startDate':startDate,
      'endDate':endDate,
      'inviteDate':inviteDate,
      'residentID':residentID,
      'visitorID':visitorID,
      'status':status,

    };
  }


}
