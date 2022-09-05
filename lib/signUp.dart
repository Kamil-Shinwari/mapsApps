import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapssssssssssss/login.dart';
import 'package:mapssssssssssss/services/authservices.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                label: Text("email"),
                border: OutlineInputBorder()),
            ),
          ),

           Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: passController,
              decoration: InputDecoration(
                label: Text("password"),
                border: OutlineInputBorder()),
            ),
          ),

          ElevatedButton(onPressed: () async{

           try{
             await authclass.signUp(email: emailcontroller.text,password: passController.text).then((value) {
              Fluttertoast.showToast(msg: "signup");
                Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen(),));
              });
           }on FirebaseAuthException catch(e){
            log(e.message.toString());
           }
          }, child: Text("SignUp"))
        ]),
      ),
    );

  }
}