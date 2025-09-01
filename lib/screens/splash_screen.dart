import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
// ignore: unused_import
import 'package:globalchat/screens/dashboard_screen.dart';
// ignore: unused_import
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:globalchat/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    //to do implement init state
    Future.delayed(Duration(seconds: 2), () {
      if (user == null) {
        openLogin();
      } else {
        openDashboard();
      }

  
    });

    super.initState();
  }

  void openDashboard() {
    Provider.of<Userprovider>(context, listen: false).
    getUserDetails();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DashboardScreen();
        },
      ), 
    );
    // To import dashboard_screen.dart, add the following import statement at the top of your file:
  }

  void openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
