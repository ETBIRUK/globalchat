import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// ignore: unused_import
import 'package:flutter/src/widgets/placeholder.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/screens/edit_profile_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData = {};

  @override
  Widget build(BuildContext context) {

    var userProvider = Provider.of<Userprovider>(context);

    return Scaffold(appBar: AppBar(title: Text(""),
    ),
    body: SizedBox(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [

        CircleAvatar( radius: 50,  child: Text(userProvider.userName[0] )),
        SizedBox(height: 8),
        Text(userProvider.userName,
        style: TextStyle(fontWeight: FontWeight.bold)),

         SizedBox(height: 8 ),
        Text(userProvider.userEmail),


        ElevatedButton(onPressed: () {

  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditProfileScreen();
        },
      ), 
    );
        } , child: Text("Edit Profile")),
      
      ]),
    ),
    );
  }
}
