import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:saloon_app/helper/FirestoreHelper.dart';
import 'package:saloon_app/models/AppUser.dart';
import 'package:saloon_app/models/AuthCallback.dart';
import 'package:saloon_app/providers/AuthenticationProvider.dart';

class ProfileRegistrationScreen extends StatefulWidget {
  @override
  _ProfileRegistrationScreenState createState() => _ProfileRegistrationScreenState();
}

class _ProfileRegistrationScreenState extends State<ProfileRegistrationScreen> {
  AuthenticationProvider authenticationProvider;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  ValueNotifier<bool> busyNotifier = ValueNotifier(false);

  AppUser appUser = AppUser.empty();

  @override
  Widget build(BuildContext context) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/img_1.png'), fit: BoxFit.cover, alignment: Alignment.center),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 30.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(23),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Center(
                        child: Text(
                          'Create Account',
                          style: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 24.sp, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: t1,
                          onSaved: (String v) => appUser.userName = v,
                          validator: (String v) => v.isEmpty ? 'Cannot be empty' : null,
                          style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_outline),
                            labelStyle: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: t2,
                          onSaved: (String v) => appUser.email = v,
                          validator: (String v) => v.isEmpty
                              ? 'Cannot be empty'
                              : !v.contains('@')
                                  ? 'Enter a valid email address'
                                  : null,
                          style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            labelStyle: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: t3,
                        onSaved: (String v) => appUser.password = v,
                        validator: (String v) => v.isEmpty
                            ? 'Cannot be empty'
                            : v.length < 4
                                ? 'Password too short'
                                : null,
                        obscureText: true,
                        style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: busyNotifier,
                        builder: (_, bool busy, __) {
                          if (busy) {
                            return Center(
                              child: Padding(padding: const EdgeInsets.only(top: 20.0), child: CircularProgressIndicator()),
                            );
                          }
                          return MaterialButton(
                            onPressed: signup,
                            //since this is only a UI app
                            child: Text(
                              'SIGN UP',
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void signup() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    busyNotifier.value = !busyNotifier.value;
    if (await FirestoreHelper.checkUserAlreadyExist(t2.text)) {
      showSnackBar(AuthCallback('User already exist with this email', true));
      return;
    }
    busyNotifier.value = !busyNotifier.value;
    authenticationProvider.setAppUser(AppUser(t1.text, t2.text, t3.text));
    Navigator.pushNamed(context, '/dogregistration');
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
