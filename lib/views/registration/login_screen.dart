import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:saloon_app/helper/AuthenticationHelper.dart';
import 'package:saloon_app/models/AppUser.dart';
import 'package:saloon_app/models/AuthCallback.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<ScaffoldState> scaffOld = GlobalKey();
  AppUser user = AppUser.empty();
  ValueNotifier<bool> busyNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffOld,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/img_1.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 30.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.all(23),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Center(
                        child: Text(
                          'Signin',
                          style: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 24.sp, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          onSaved: (String v) => user.email = v,
                          validator: emailAddressValidator,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.person_outline),
                            labelStyle: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        obscureText: true,
                        onSaved: (String v) => user.password = v,
                        validator: passwordValidator,
                        style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          labelStyle: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        onPressed: signinUser,
                        //since this is only a UI app
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFUIDisplay',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Color(0xffff2d55),
                        elevation: 0,
                        minWidth: 400,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: GestureDetector(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account?",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: " sign up",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Color(0xffff2d55),
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () => Navigator.pushNamed(context, '/profileRegistration'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String emailAddressValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'field could not be empty';
    }
    if (!value.contains('@')) {
      return 'not a valid email address';
    }
    RegExp exp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!exp.hasMatch(value)) {
      return 'not a valid email address';
    }
    return null;
  }

  String passwordValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'field could not be empty';
    }
    if (value.length < 4) {
      return 'password too short';
    }
    return null;
  }

  void signinUser() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    updateBusyState();
    User firebaseUser = await AuthenticationHelper.signUserIn(
      user,
      authenticationCallbacks,
    );
    if (firebaseUser != null && firebaseUser.uid != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
  }

  void authenticationCallbacks(AuthCallback callback) {
    showSnackBar(callback);
  }

  void updateBusyState() {
    busyNotifier.value = !busyNotifier.value;
  }

  showSnackBar(AuthCallback callback) {
    SnackBar snackBar = SnackBar(
      content: Text(callback.message, style: TextStyle(color: Colors.white)),
      backgroundColor: callback.error ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    updateBusyState();
  }
}
