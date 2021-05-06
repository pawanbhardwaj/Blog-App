import 'package:blog/views/add_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../config.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void verificationCompleted(
    BuildContext context, AuthCredential authCredential) async {
  UserCredential result =
      await FirebaseAuth.instance.signInWithCredential(authCredential);
  Fluttertoast.showToast(
      msg: "Code verified Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);

  User user = result.user;

  DocumentSnapshot snap =
      await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
  if (snap.data() == null) {
    uid = user.uid;
    // print(widget.user.uid);
    Navigator.pushAndRemoveUntil(context,
        CupertinoPageRoute(builder: (context) => AddBlog()), (route) => false);
  } else {
    uid = user.uid;
    Navigator.pushAndRemoveUntil(context,
        CupertinoPageRoute(builder: (context) => AddBlog()), (route) => false);
  }
}

void verificationFailed(FirebaseAuthException exception) {
  print(exception);
}

void codeSent(String verificationId, [int forceResendingToken]) {}
