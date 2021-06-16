import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:saloon_app/RouteGenerator.dart';
import 'package:saloon_app/providers/AuthenticationProvider.dart';
import 'package:saloon_app/providers/ConfigProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0x0ff26242e),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MultiProvider(
      child: ResponsiveSizer(
        builder: (ctx, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "DogFeed",
            builder: BotToastInit(),
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: '/',
            navigatorObservers: [routeObserver],
            theme: ThemeData(
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                elevation: 0,
                highlightElevation: 2,
                splashColor: Colors.white.withOpacity(0.35),
              ),
              primaryColor: Color(0x0ff424c58),
              accentColor: Color(0x0ff33c4b3),
              dividerColor: Color(0x0ffafb7c2),
              scaffoldBackgroundColor: Colors.grey.shade100,
              primaryIconTheme: IconThemeData(color: Colors.black87),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey.shade100,
                elevation: 0,
                brightness: Brightness.light,
                centerTitle: true,
              ),
              textTheme: TextTheme(
                headline5: TextStyle(color: Colors.black87),
                headline4: TextStyle(color: Colors.black87),
                headline3: TextStyle(color: Colors.black87),
                headline2: TextStyle(color: Colors.black87),
                headline1: TextStyle(color: Colors.black87),
                subtitle1: TextStyle(color: Colors.black87),
                headline6: TextStyle(color: Colors.black87),
                bodyText2: TextStyle(color: Colors.black87),
                bodyText1: TextStyle(color: Colors.black87),
                caption: TextStyle(color: Colors.black87),
              ),
            ),
          );
        },
      ),
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(create: (BuildContext ctx) => AuthenticationProvider()),
        ChangeNotifierProvider<ConfigProvider>(create: (BuildContext ctx) => ConfigProvider()),
      ],
    );

  }
}
