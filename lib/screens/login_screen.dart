import 'package:ecommerce_app/widgets/appbar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      decoration: InputDecoration(labelText: 'Enter Email'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Enter Password'),
                    ),
                    RaisedButton(
                      child: Text('Sign in'),
                      onPressed: () {},
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
                  Navigator.of(context).pushReplacementNamed('/signup');
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
