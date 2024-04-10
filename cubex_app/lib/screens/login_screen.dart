import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cubex_app/components/customTextField.dart';
import 'package:cubex_app/config/colors.dart';
import 'package:cubex_app/models/login_model.dart';
import 'package:cubex_app/utils/screen_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = true;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      LoadingUtil(context).startLoading();

      Dio dio = Dio();

      LoginModel postData = LoginModel(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      String jsonData = jsonEncode(postData);
      try {
        Response response =
            await dio.post('https://stacked.com.ng/api/login', data: jsonData);
        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();

          //print('reponse: ${response}');
          Map<String, dynamic> responseData = response.data;

          String token = responseData['token'];
          await prefs.setString('token', token);

          await Future.delayed(Duration(seconds: 3));
          LoadingUtil(context).stopLoading();

          context.go('/profile');
          setState(() {
            _usernameController.clear();
            _passwordController.clear();
          });
        } else {
          LoadingUtil(context).stopLoading();
          showFlushbar(
              context,
              'Login Error',
              CustomColor().appWhite,
              '$response',
              Icon(Icons.error, color: CustomColor().appRed),
              CustomColor().appWhite,
              CustomColor().appBlack);
        }
      } catch (e) {
        LoadingUtil(context).stopLoading();

        if (e is DioException) {
          // Handle bad request error
          print('Bad request: ${e.response?.data}');
          showFlushbar(
              context,
              'Login Error',
              CustomColor().appWhite,
              '${e.response?.data}',
              Icon(Icons.error, color: CustomColor().appRed),
              CustomColor().appWhite,
              CustomColor().appBlack);
        } else {
          // Handle other errors
          print('An error occurred: $e');
          LoadingUtil(context).stopLoading();
          showFlushbar(
              context,
              'Login Error',
              CustomColor().appWhite,
              '$e',
              Icon(Icons.error, color: CustomColor().appRed),
              CustomColor().appWhite,
              CustomColor().appBlack);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor().appGrey300,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Center(
                      child: Text(
                    'Welcome Back!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    'Login to your account',
                    style: TextStyle(fontSize: 16),
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    labelText: 'Username',
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  CustomTextField(
                    suffixIcon: IconButton(
                        color: CustomColor().appBlack,
                        icon: isVisible == true
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () => {
                          setState(() {
                            isVisible = !isVisible;
                          })
                        },
                      ),
                    labelText: 'Password',
                    controller: _passwordController,
                    obscureText: isVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor().appBlack,
                          fixedSize: Size(345, 50)),
                      onPressed: loginUser,
                      child: Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  GestureDetector(
                    onTap: () => context.go('/signup'),
                    child: Center(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Don\'t have an account ',
                            style: TextStyle(color: CustomColor().appBlack)),
                        TextSpan(
                            text: ' Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColor().appBlack)),
                      ])),
                    ),
                  )
                ],
              ),
            ),
          ),
        )));
  }

  void showFlushbar(BuildContext context, String title, Color titleColor,
      String message, Icon icon, Color messageColor, Color backgroundColor) {
    Flushbar(
      title: title,
      titleColor: titleColor,
      message: message,
      icon: icon,
      isDismissible: true,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(minutes: 2),
      animationDuration: Duration(seconds: 1),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.bounceInOut,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(5),
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      messageColor: messageColor,
      boxShadows: [
        BoxShadow(
            color: CustomColor().appGrey900,
            offset: Offset(2, 4),
            blurRadius: 10)
      ],
    )..show(context);
  }
}
