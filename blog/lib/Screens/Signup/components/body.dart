import 'package:blog/Screens/Login/login_screen.dart';
import 'package:blog/Screens/Signup/components/social_icon.dart';
import 'package:blog/components/already_have_an_account_acheck.dart';
import 'package:blog/components/rounded_button.dart';
import 'package:blog/components/rounded_input_field.dart';
import 'package:blog/components/rounded_password_field.dart';
import 'package:blog/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../constants.dart';
import 'background.dart';
import 'or_divider.dart';

class Body extends StatelessWidget {
  String email, pass;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Enter your Email",
              onChanged: (value) {
                email = value;
              },
            ),
            RoundedPasswordField(onChanged: (value) {
              pass = value;
            }),
            RoundedButton(
                text: "SIGNUP",
                press: () async {
                  try {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kPrimaryColor),
                                ),
                              ],
                            )));
                    var auth = FirebaseAuth.instance;
                    UserCredential user =
                        await auth.createUserWithEmailAndPassword(
                            email: email, password: pass);
                    assert(user != null);
                    if (user != null) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Successfully created ");
                      FirebaseFirestore.instance
                          .collection('Users')
                          .add({"email": email});
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Email already taken");
                    } else if (e.code == 'invalid-email') {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Invalid Email");
                    } else if (e.code == "weak-password") {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Password should be at least 6 characters");
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                }),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () async {
                    final GoogleSignIn googleSignIn = GoogleSignIn();

                    FirebaseAuth auth = FirebaseAuth.instance;
                    User user;

                    final GoogleSignInAccount googleSignInAccount =
                        await googleSignIn.signIn();

                    if (googleSignInAccount != null) {
                      final GoogleSignInAuthentication
                          googleSignInAuthentication =
                          await googleSignInAccount.authentication;

                      final AuthCredential credential =
                          GoogleAuthProvider.credential(
                        accessToken: googleSignInAuthentication.accessToken,
                        idToken: googleSignInAuthentication.idToken,
                      );

                      try {
                        final UserCredential userCredential =
                            await auth.signInWithCredential(credential);
                        user = userCredential.user;

                        print(user.displayName);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
