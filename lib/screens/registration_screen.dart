import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../UserData.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        //backgroundColor: Colors.white,
        appBar: MyAppBar(
          title: 'Sign up',
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 580,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      controller: fNameController,
                                      decoration: InputDecoration(
                                          labelText: 'First Name'),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: lNameController,
                                      decoration: InputDecoration(
                                          labelText: 'Last Name'),
                                    ),
                                  )
                                ],
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(labelText: 'Email'),
                              ),
                              TextFormField(
                                controller: passController,
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                                obscureText: true,
                              ),
                              TextFormField(
                                controller: confirmPassController,
                                decoration: InputDecoration(
                                    labelText: 'Confirm Password'),
                                obscureText: true,
                              ),
                              TextFormField(
                                controller: mobileController,
                                decoration:
                                    InputDecoration(labelText: 'Mobile Number'),
                              ),
                              TextFormField(
                                controller: addressController,
                                decoration: InputDecoration(
                                    labelText: 'Shipping Address'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Colors.lightGreenAccent,
                                  child: Text('Sign up'),
                                  onPressed: () async {
                                    String firstName =
                                        fNameController.text.trim();
                                    String lastName =
                                        lNameController.text.trim();
                                    String email = emailController.text.trim();
                                    String pass = passController.text.trim();
                                    String mobileNum =
                                        mobileController.text.trim();
                                    String address =
                                        addressController.text.trim();
                                    if (firstName.isEmpty ||
                                        lastName.isEmpty ||
                                        email.isEmpty ||
                                        pass.isEmpty ||
                                        confirmPassController.text.isEmpty ||
                                        mobileNum.isEmpty ||
                                        address.isEmpty) {
                                      Utils.showAlertDialog(context,
                                          "No fields can be left blank", "");
                                      return;
                                    }

                                    if (pass !=
                                        confirmPassController.text.trim()) {
                                      Utils.showAlertDialog(context,
                                          "Passwords do not match", "");
                                      return;
                                    }

                                    if (!email.contains("@")) {
                                      Utils.showAlertDialog(context,
                                          "Please enter a valid email", "");
                                      return;
                                    }

                                    if (pass.length < 6) {
                                      Utils.showAlertDialog(
                                          context,
                                          "Password must have more than 5 characters",
                                          "");
                                      return;
                                    }

                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      final AuthResult result = await _auth
                                          .createUserWithEmailAndPassword(
                                              email: email, password: pass);
                                      final FirebaseUser user = result.user;

                                      assert(user != null);

                                      String userId = user.uid;

                                      try {
                                        final firestoreResult = await _firestore
                                            .collection("users")
                                            .document(userId)
                                            .setData({
                                          "first_name": firstName,
                                          "last_name": lastName,
                                          "email": email,
                                          "mobile_num": mobileNum,
                                          "address": address,
                                          "role": "user"
                                        });
                                        if (user != null) {
                                          Firestore.instance
                                              .collection('users')
                                              .document(user.uid)
                                              .get()
                                              .then((data) {
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .setUserWithoutNotifying(
                                                    userData: data);

                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    HomeScreen.id);
                                          }).catchError((e) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Utils.showAlertDialog(
                                                context, "Error", e.toString());
                                            return;
                                          });
                                        }
                                      } catch (e) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Utils.showAlertDialog(
                                            context, "Error", e.toString());
                                        return;
                                      }
                                    } catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Utils.showAlertDialog(
                                          context, "Error", e.toString());
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account? '),
                    GestureDetector(
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginScreen.id, (Route<dynamic> route) => false);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
