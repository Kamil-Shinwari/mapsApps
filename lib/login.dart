import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapssssssssssss/services/authservices.dart';
import 'package:mapssssssssssss/testing_map.dart';
class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
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

          ElevatedButton(onPressed: () {

            try{
              
              // 
              authclass.signIn(email: emailcontroller.text,password: passController.text).then((value) {
                FirebaseFirestore.instance.collection("users").add({
                "email":emailcontroller.text,
                "pass":passController.text,
               });
               Fluttertoast.showToast(msg: "login");
                Navigator.push(context, MaterialPageRoute(builder: (context) => TestMap(),));
              });
              
                
                
              
            
            }
            on FirebaseAuthException catch(e){
              log(e.message.toString());
            }
          }, child: Text("LogIn"))
        ]),
      ),
    );

  }
}