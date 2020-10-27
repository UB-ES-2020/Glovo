import 'package:customerapp/models/initial_logged.dart';
import 'package:customerapp/models/signup.dart';
import 'package:customerapp/screens/loggedPage/initial_logged_page.dart';
import 'package:customerapp/screens/anon_root.dart';
import 'package:customerapp/screens/signIn/signin_page.dart';
import 'package:customerapp/screens/signUp/signup_page.dart';
import 'package:customerapp/styles/Glovo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpModel()),
        ChangeNotifierProvider(create: (context) => InitialLoggedModel()),
        ChangeNotifierProvider(create: (context) => SignInModel()),
      ],
      child: MaterialApp(
          theme: appTheme,
          title: 'Komet',
          initialRoute: '/',
          routes: {
            '/': (context) => AnonRoute(),
            '/sign-up': (context) => SignUpPage(),
            '/sign-in': (context) => SignInPage(),
            '/initial-logged-in': (context) => InitialLogged(),
          }),
    );
  }
}
