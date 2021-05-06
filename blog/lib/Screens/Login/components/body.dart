import 'package:blog/Screens/Login/components/background.dart';
import 'package:blog/Screens/Signup/signup_screen.dart';
import 'package:blog/components/already_have_an_account_acheck.dart';
import 'package:blog/components/rounded_button.dart';
import 'package:blog/components/rounded_input_field.dart';
import 'package:blog/components/rounded_password_field.dart';
import 'package:blog/constants.dart';
import 'package:blog/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _email, _pass;
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Enter your Email",
              onChanged: (value) {
                _email = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _pass = value;
              },
            ),
            RoundedButton(
                text: "LOGIN",
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
                    UserCredential user = await auth.signInWithEmailAndPassword(
                        email: _email, password: _pass);

                    assert(user != null);
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: "Successfully logged in");

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-email') {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Invalid Email");
                    } else if (e.code == 'user-not-found') {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "User not found");
                    } else if (e.code == "wrong-password") {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Wrong password");
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                }),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
