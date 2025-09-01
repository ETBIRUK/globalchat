import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// ignore: unused_import
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:globalchat/controllers/login_controller.dart';
// ignore: unused_import
import 'package:globalchat/controllers/signup_controller.dart';
import 'package:globalchat/screens/dashboard_screen.dart';
import 'package:globalchat/screens/signup_screen.dart';
// ignore: unused_import
import 'package:globalchat/screens/splash_screen.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userForm = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> createAccount() async {
    try {
    await FirebaseAuth.instance.
    createUserWithEmailAndPassword(
      email: email.text,
      password: password.text);


       Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) {
              return DashboardScreen();
        }),(Route){
          return false;
        });


      print("Account created successfully");

    }catch (e) {

      SnackBar messageSnackbar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()));

      ScaffoldMessenger.of(context).showSnackBar
      (messageSnackbar);
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     //ppBar: AppBar(title: Text("Login")),
      body: Form(
        key: userForm,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,


            children: [     
              
    SizedBox(
      height: 100,
      width: 100,
       child: Image.asset("assets/images/logo.png")),

              TextFormField(

                autovalidateMode:  
                 AutovalidateMode.
                onUserInteraction,
                controller: email,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },

                decoration: InputDecoration(label: Text("Email")),
              ),
              SizedBox(height: 23),

              TextFormField(

                autovalidateMode: AutovalidateMode.
                onUserInteraction,
                controller: password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "password is required";
                  }
                  return null;
                },

                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,

                decoration: InputDecoration(label: Text("Password")),
              ),
              SizedBox(height: 23),
              Row(
                children: [
                  Expanded(

                    child: ElevatedButton(
                      style: ElevatedButton.
                      styleFrom(
                        minimumSize: Size(0, 50),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent),
                      onPressed: ()async {
                        if (userForm.currentState!.
                        validate()) {
                          //create account
                          isLoading = true;
                          setState(() {});

                       await  LoginController.login(
                            context: context, 
                            email: email.text, 
                            password: password.text);


                            isLoading = false;
                          setState(() {});
                    
                        }
                      },
                
                      child: isLoading
                      ?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                      
                      :Text("Login")),
                  ),
                ],
              ),
                SizedBox(height: 20),
                Row (
                  children: [
                    Text("Don't have an account?"),
                    SizedBox(width: 5 ),
                    InkWell(
                      onTap:(){
                        
    Navigator.pushReplacement(context, MaterialPageRoute
    (builder: (context) {
      return SignupScreen();
}));



                      },
                    
                      child: Text("Signup here!",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                    )
                    
                  ],
                    )
                ],
          ),
        ),
      ),
    );
  }
}
