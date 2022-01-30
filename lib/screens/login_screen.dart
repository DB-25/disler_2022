import 'package:disler_new/components/input_field.dart';
import 'package:disler_new/components/password_field.dart';
import 'package:disler_new/model/login_model.dart';
import 'package:disler_new/networking/ApiResponse.dart';
import 'package:disler_new/networking/api_driver.dart';
import 'package:disler_new/screens/home_screen.dart';
import 'package:disler_new/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page_2.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _formKey = GlobalKey<FormState>();
final _formKey2 = GlobalKey<FormState>();
final scaffoldKey = GlobalKey<ScaffoldState>();
var formData = {
  'email': '',
  'password': '',
};
var formData2 = {
  'email': '',
};

ApiDriver apiDriver = ApiDriver();

class _LoginScreenState extends State<LoginScreen> {
  bool enableGoogleLogin = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  Future<void> _handleSignIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await _googleSignIn.signIn();
      await prefs.setBool('autoLogin', true);
      await prefs.setString('emailId', _googleSignIn.currentUser.email);
      await prefs.setString('name', _googleSignIn.currentUser.displayName);
      await _showMyDialog(title: 'Login Successful', body: 'USER LOGIN.');
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    _autoLogIn();
    super.initState();
  }

  String emailIdFromLocal = "";
  String passwordFromLocal = "";

  Future<void> _autoLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailIdFromLocal =
        prefs.containsKey('emailId') ? prefs.getString('emailId') : "";
    passwordFromLocal =
        prefs.containsKey('password') ? prefs.getString('password') : "";
    if (emailIdFromLocal != "" && passwordFromLocal != "")
      _handleLogin(emailIdFromLocal, passwordFromLocal);
    // bool loggedIn = prefs.containsKey('accessToken');
    // if (loggedIn == true)
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Future<void> loginFun(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await apiDriver.login(email, password);
    if (response != null) {
      if (response.status) {
        await prefs.clear();
        await prefs.setBool('autoLogin', true);
        await prefs.setString('email', email);
        await prefs.setString('emailId', email);
        await prefs.setString('accessToken', response.data[0]['accessToken']);
        await prefs.setString('password', password);
        await prefs.setString('userType', response.data[0]['userType']);
        print(response.data[0]['userType']);
        if (response.data[0]['userType'] == 'ROLE_ADMIN') {
          prefs.setBool('admin', true);
          setState(() {
            admin.value = true;
            autoLoginBool.value = true;
            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
            admin.notifyListeners();
            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
            autoLoginBool.notifyListeners();
          });
          _showMyDialog(title: 'Login Successful', body: 'ADMIN LOGIN.');
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          // _autoLogIn();
        } else {
          setState(() {
            admin.value = false;
            autoLoginBool.value = true;
            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
            admin.notifyListeners();
            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
            autoLoginBool.notifyListeners();
          });
          _showMyDialog(
              title: 'Login Successful',
              body: response != null ? response.message : "Enjoy Shopping.");
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          // _autoLogIn();
        }
      }
    } else {
      _showMyDialog(
          title: 'Login Failed',
          body:
              response != null ? response.message : "User Credentials Wrong!");
    }
  }

  Future<void> _handleLogin(String email, String password) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Wanna Login?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Login from previously saved details!"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('YES'),
              onPressed: () {
                loginFun(email, password);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog2({String title}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey2,
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InputField(
                      hintText: "Enter your Email",
                      validator: emptyValidator('Enter your Email'),
                      onSaved: (val) => formData2['email'] = val,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('RESET'),
              onPressed: () async {
                _formKey2.currentState.save();
                if (!_formKey2.currentState.validate()) return;
                Navigator.of(context).pop();
                ApiResponse forgotPassword =
                    await apiDriver.forgotPassword(formData2['email']);
                print(forgotPassword.message);
                if (forgotPassword != null)
                  _showMyDialog(
                      title: forgotPassword.message,
                      body: forgotPassword.message);
              },
            ),
            TextButton(
              child: Text('CANCEL'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // IconButton(
                    //   icon: Icon(Icons.arrow_back),
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    Center(
                      child: Text(
                        'DISLER',
                        style: GoogleFonts.notoSerif(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFff5860),
                          letterSpacing: 4,
                        ),
                        // TextStyle(
                        //     fontFamily: 'Muli',
                        //     color: Color(0xFFff5860),
                        //     fontSize: 35,
                        //     fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      height: 90,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Color(0xFFff5860),
                          fontSize: 28,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: InputField(
                        hintText: 'Enter your Email / Phone Number',
                        // validator: emailValidator(),
                        onSaved: (val) => formData['email'] = val,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: PasswordField(
                        hintText: "Enter your Password",
                        icon: Icons.lock,
                        validator:
                            passwordValidator("Password must not be empty"),
                        onSaved: (val) => formData['password'] = val,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFFff5860)),

                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        _formKey.currentState.save();
                        if (!_formKey.currentState.validate()) return;
                        final loginModel = LoginModel.fromMap(formData);
                        loginFun(loginModel.email, loginModel.password);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    enableGoogleLogin
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFff5860)),

                            child: Container(
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "Log in with GOOGLE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              _handleSignIn();

                              await prefs.setBool('autoLogin', true);
                              setState(() {
                                autoLoginBool.value = true;
                                // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                                autoLoginBool.notifyListeners();
                              });

                              Navigator.pop(context);
                            },
                          )
                        : Container(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 650,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _showMyDialog2(title: 'Forgot Password');
                          },
                          child: Text(
                            'Forgot your Password?',
                            style: TextStyle(
                                color: Color(0xFFff5860),
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Color(0xFFff5860),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog({String title, String body}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
