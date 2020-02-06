import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/add_product_screen.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/registration_screen.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../UserData.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Login',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Sign In',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            SingleChildScrollView(
              child: Card(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Enter Email'),
                      ),
                      TextFormField(
                        controller: passController,
                        decoration:
                            InputDecoration(labelText: 'Enter Password'),
                      ),
                      RaisedButton(
                        child: Text('Sign in'),
                        onPressed: () async {
                          if (emailController.text.isEmpty ||
                              passController.text.isEmpty) {
                            Utils.showAlertDialog(
                                context, "No fields can be left blank", "");
                            return;
                          }
                          if (passController.text.length < 6) {
                            Utils.showAlertDialog(
                                context,
                                "Password must be greater than 5 characters",
                                "");
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            final AuthResult result =
                                await _auth.signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passController.text.trim());
                            final FirebaseUser user = result.user;
                            if (user != null) {
                              var document = await Firestore.instance
                                  .collection('users')
                                  .document(user.uid)
                                  .get()
                                  .then((data) {
                                print(data['name']);
                                bool isAdmin = data["role"] == 'admin';
                                String Fname = data['first_name'];
                                String Lname = data['last_name'];
                                String address = data['address'];
                                String num = data['mobile_num'];
                                print("Role of User :  $data['role']");
                                Provider.of<UserData>(context, listen: false)
                                    .setUser(
                                        id: user.uid,
                                        email: user.email,
                                        firstName: Fname,
                                        lastName: Lname,
                                        address: address,
                                        mobileNum: num,
                                        adminStatus: isAdmin);
                              }).catchError((e) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Utils.showAlertDialog(
                                    context, "Error", e.toString());
                                return;
                              });
                            }

                            if (user != null) {
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pushReplacementNamed(
                                  context, HomeScreen.id);
                            }
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            Utils.showAlertDialog(
                                context, "Error", e.toString());
                            return;
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Don\'t have an account? '),
                GestureDetector(
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RegistrationScreen.id);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
