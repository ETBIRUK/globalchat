import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/screens/chatroom_screen.dart';
import 'package:globalchat/screens/profile_screen.dart';
import 'package:globalchat/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  var Scaffoldkey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> chatroomsList = [];
  List<String> chatroomIds = [];

  void getChatrooms() {
    db.collection("chatrooms").get().then((datasnapshot) {
      for (var singleChatroomData in datasnapshot.docs) {
        chatroomsList.add(singleChatroomData.data());
        chatroomIds.add(singleChatroomData.id.toString());
      }

      if (mounted) {
        setState(() {});
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getChatrooms();
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<Userprovider>(context);

    return Scaffold(
      key: Scaffoldkey,
      appBar: AppBar(
        title: Text("Global Chat"),
        leading: InkWell(
          onTap: (){
            Scaffoldkey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar (  radius:  20,child: Text(userprovider.userName[0])),
          ),
        ),
      ),
      
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 50),
               ListTile(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                leading: CircleAvatar(child: Text(userprovider.userName[0])),
                title: Text(userprovider.userName),
                subtitle: Text(userprovider.userEmail),


              ),

              ListTile(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                leading: Icon(Icons.people),
                title: Text("profile"),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SplashScreen(),
                    ),
                    (Route) => false,
                  );
                },
                leading: Icon(Icons.logout),
                title: Text("logout"),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: chatroomsList.length,
        itemBuilder: (BuildContext context, int index) {
          String chatroomName = chatroomsList[index]["chatroom_name"] ?? "";

          return ListTile(
            onTap: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) {
                return ChatroomScreen(

                  chatroomName: chatroomName,
                  chatroomId: chatroomIds[index],




                );
              }));
         
              // Navigate to chat screen
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[900],
              child: Text(chatroomName[0],
              style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(chatroomName),
            subtitle: Text(chatroomsList[index]["desc"] ?? ""),
          );
        },
      ),
    );
  }
}
