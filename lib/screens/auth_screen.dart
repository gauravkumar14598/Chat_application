import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth=FirebaseAuth.instance;
  void _submitAuthForm(
      String email,
      String password,
      String username,
      bool isLogin,
      BuildContext ctx,
      ) async{
        UserCredential userCredential;
        
        try{
        if(isLogin){
          userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
        }
        else{
          userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        }

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
        });


      } on PlatformException catch(err){
        var message='An error occured, please check your credentials!';
        
        if(err.message!=null){
          message=err.message!;
        }
      }
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
