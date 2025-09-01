import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// ignore: unused_import
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic>? userData = {};

  var db = FirebaseFirestore.instance;

  TextEditingController nameText = TextEditingController();

  var editprofileform = GlobalKey<FormState>();

  @override
  void initState() {
    nameText.text = Provider.of<Userprovider>(context, listen: false).userName;
    super.initState();
  }

  void updateData() {
    Map<String, dynamic> dataToUpdate = {

      "name": nameText.text,
    };

    db
        .collection("users")
        .doc(Provider.of<Userprovider>(context, listen: false).userId)
        .update(dataToUpdate);


 Provider.of<Userprovider>(context, listen: false).getUserDetails();
        Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var userProvider = Provider.of<Userprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          InkWell(
            onTap: () {
              if (editprofileform.currentState!.validate()) {
                updateData();
                //updating of the data on database
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: editprofileform,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return " Name cannot be empty";
                    }
                    return null;
                  },
                  controller: nameText,
                  decoration: InputDecoration(label: Text("Name")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
