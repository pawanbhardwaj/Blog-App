import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(blogData, String id) async {
    print(blogData);
    FirebaseFirestore.instance.collection("images").doc(id).set(blogData);
  }

  // getData() async {
  //   return await FirebaseFirestore.instance.collection("images").get();
  // }
}
