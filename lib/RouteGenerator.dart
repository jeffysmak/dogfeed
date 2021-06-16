import 'package:flutter/material.dart';
import 'package:saloon_app/views/EditProfile.dart';
import 'package:saloon_app/views/Temp1.dart';
import 'package:saloon_app/views/Temp2.dart';
import 'package:saloon_app/views/boarding/on_boarding_screen.dart';
import 'package:saloon_app/views/dashboard_screen.dart';
import 'package:saloon_app/views/registration/PetRegistration.dart';
import 'package:saloon_app/views/registration/login_screen.dart';
import 'package:saloon_app/views/registration/profile_registration.dart';
import 'package:saloon_app/views/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/boarding':
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/profileRegistration':
        return MaterialPageRoute(builder: (_) => ProfileRegistrationScreen());
      case '/dogregistration':
        return MaterialPageRoute(builder: (_) => DogRegistration());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard());
      case '/editProfile':
        return MaterialPageRoute(builder: (_) => MyProfile());
      case '/t1':
        return MaterialPageRoute(builder: (_) => TempOne());
      case '/t2':
        return MaterialPageRoute(builder: (_) => TempTwo());
      default:
        return MaterialPageRoute(builder: (_) => ErrorRoute());
    }
  }
}

class ErrorRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route error'),
      ),
    );
  }
}
