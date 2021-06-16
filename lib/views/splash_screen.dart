import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_app/helper/FirestoreHelper.dart';
import 'package:saloon_app/models/AppUser.dart';
import 'package:saloon_app/providers/ConfigProvider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var user = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration.zero, () {
      Provider.of<ConfigProvider>(context, listen: false).initializeAppconfig();
      if (user != null) {
        Timer(Duration(seconds: 2), () async {
          AppUser signedinUser = await FirestoreHelper.getUserData(user);
          Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
        });
      } else {
        Timer(Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ABC')),
      body: Center(child: Text('A Splash')),
    );
  }
}
