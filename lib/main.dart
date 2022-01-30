import 'package:disler_new/screens/home_screen.dart';
import 'package:disler_new/screens/login_screen.dart';
import 'package:disler_new/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _autoLogIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  loggedIn = prefs.containsKey('accessToken');
}

bool loggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _autoLogIn();
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Disler",
    theme: theme(),
    home: loggedIn ? HomeScreen() : LoginScreen(),
  ));
}
