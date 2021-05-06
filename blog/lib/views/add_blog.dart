import 'dart:io';
import 'package:blog/components/rounded_button.dart';
import 'package:blog/constants.dart';
import 'package:blog/services/crud.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddBlog extends StatefulWidget {
  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  //
  File selectedImage;
  final picker = ImagePicker();

  CrudMethods crudMethods = new CrudMethods();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadBlog() async {
    if (selectedImage != null) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kPrimaryLightColor),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Uploading..'),
                  ],
                ),
              ));

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(selectedImage);

      var imageUrl;
      await task.whenComplete(() async {
        try {
          imageUrl = await firebaseStorageRef.getDownloadURL();
        } catch (onError) {
          print("Error");
        }

        print(imageUrl);
      });

      Map<String, dynamic> blogData = {
        "imgUrl": imageUrl,
        "author": authorTextEditingController.text,
        "title": titleTextEditingController.text,
        "desc": descTextEditingController.text,
        "time": DateTime.now()
      };

      crudMethods
          .addData(blogData, authorTextEditingController.text)
          .then((value) {
        Fluttertoast.showToast(msg: "Image Added");
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Text('Image Required'),
                    ),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Okay',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.5000000286102295,
                        ),
                      ))
                ],
              ));
    }
  }

  //
  TextEditingController titleTextEditingController =
      new TextEditingController();
  TextEditingController descTextEditingController = new TextEditingController();
  TextEditingController authorTextEditingController =
      new TextEditingController();
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Discard image?',
                style: TextStyle(
                  // fontFamily: 'Inter',
                  color: kPrimaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.5000000286102295,
                )),
            content: new Text("This won't be saved"),
            actions: [
              Row(
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: new Text('No',
                          style: TextStyle(
                            // fontFamily: 'Inter',
                            color: kPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.5000000286102295,
                          ))),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: new Text('Yes',
                          style: TextStyle(
                            // fontFamily: 'Inter',
                            color: kPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.5000000286102295,
                          )))
                ],
              )
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    f() {
      Navigator.pop(context);
    }

    return WillPopScope(
      onWillPop: selectedImage != null ? _onBackPressed : f,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: kPrimaryColor,
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Add Image",
            style: TextStyle(
              color: kPrimaryColor,
              fontFamily: "Josefin",
            ),
          ),
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                uploadBlog();
              },
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.file_upload,
                    color: kPrimaryColor,
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: selectedImage != null
                        ? Container(
                            height: 210,
                            margin: EdgeInsets.symmetric(vertical: 24),
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            height: 210,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            margin: EdgeInsets.symmetric(vertical: 24),
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.camera_alt,
                              size: 51,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    controller: titleTextEditingController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid, color: Colors.black),
                        ),
                        hintStyle: TextStyle(
                            color: Colors.black, fontFamily: "Quicksand"),
                        hintText: "Enter title"),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    maxLines: null,
                    controller: descTextEditingController,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid, color: Colors.black),
                        ),
                        hintStyle: TextStyle(
                            color: Colors.black, fontFamily: "Quicksand"),
                        hintText: "Enter description"),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  TextField(
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    controller: authorTextEditingController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid, color: Colors.black),
                        ),
                        hintStyle: TextStyle(
                            color: Colors.black, fontFamily: "Quicksand"),
                        hintText: "Enter author name"),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 7,
                  ),
                  RoundedButton(
                    color: kPrimaryColor,
                    text: "Upload Video link?",
                    press: () {},
                    textColor: Colors.white,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
