import 'package:blog/constants.dart';
import 'package:blog/services/crud.dart';
import 'package:blog/views/add_blog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();

  Widget blogsList() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('images').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.docs.length != 0
                    ? ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 24),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          String time, last1;
                          time = DateFormat('EEE,MM/dd/y')
                              .format(
                                  snapshot.data.docs[index]['time'].toDate())
                              .toString();
                          List last = time.split(',');
                          last1 = last[0] + " , " + last[1];
                          return BlogTile(
                            time: last1,
                            author: snapshot.data.docs[index]['author'],
                            title: snapshot.data.docs[index]['title'],
                            desc: snapshot.data.docs[index]['desc'],
                            imgUrl: snapshot.data.docs[index]['imgUrl'],
                          );
                        },
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 3),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "No Image found!",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontFamily: "Quicksand"),
                          ),
                        ),
                      );
              } else {
                return Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "DwarkaDhish Images",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontFamily: "Josefin"),
          ),
          elevation: 0,
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddBlog()));
                },
                child: Image.asset(
                  "assets/add.png",
                  color: kPrimaryColor,
                ))
          ]),
      body: Container(child: blogsList()),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imgUrl;
  String title, desc, author, time;

  BlogTile(
      {@required this.author,
      @required this.time,
      @required this.desc,
      @required this.imgUrl,
      @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xffe3e3e3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.only(bottom: 24, right: 16, left: 16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  imgUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  // height: 200,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Quicksand",
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              '$desc - By $author',
              style: TextStyle(
                  fontSize: 14, fontFamily: "Quicksand", color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Quicksand",
                        color: Colors.black)),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: Text('Delete image?'),
                                  ),
                                ],
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () async {
                                      Reference ref = FirebaseStorage.instance
                                          .refFromURL(imgUrl);
                                      ref.delete();
                                      FirebaseFirestore.instance
                                          .collection('images')
                                          .doc(author)
                                          .delete();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg: "Image Deleted");
                                    },
                                    child: Text(
                                      'Yes',
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
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
