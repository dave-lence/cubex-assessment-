import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cubex_app/components/customTextField.dart';
import 'package:cubex_app/config/colors.dart';
import 'package:cubex_app/models/signup_model.dart';
import 'package:cubex_app/utils/screen_loader.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage; // Store the selected image file
  String? imagePath;
  bool isVisible = true;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      LoadingUtil(context).startLoading();

      Dio dio = Dio();

      SignUpModel postData = SignUpModel(
          username: _usernameController.text,
          password: _passwordController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          image: imagePath);

      String jsonData = jsonEncode(postData);
      try {
        Response response = await dio
            .post('https://stacked.com.ng/api/register', data: jsonData);
        if (response.statusCode == 201) {
          await Future.delayed(Duration(seconds: 3));
          LoadingUtil(context).stopLoading();
          showFlushbar(
              context,
              'Registration Succesful',
              CustomColor().appWhite,
              '$response',
              Icon(Icons.check_circle_outline, color: CustomColor().appGreen),
              CustomColor().appWhite,
              CustomColor().appBlack);
         await Future.delayed(Duration(seconds: 2));
         await prefs.setString('userName', _usernameController.text);
         await prefs.setString('email', _emailController.text);
         await prefs.setString('phone', _phoneController.text);
         await prefs.setString('address', _addressController.text);

          context.go('/');
          setState(() {
            _usernameController.clear();
            _passwordController.clear();
            _emailController.clear();
            _phoneController.clear();
            _addressController.clear();
          });
        } else {
          LoadingUtil(context).stopLoading();
          showFlushbar(
              context,
              'Registration Error',
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
              'Registration Error',
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
              'Registration Error',
              CustomColor().appWhite,
              '$e',
              Icon(Icons.error, color: CustomColor().appRed),
              CustomColor().appWhite,
              CustomColor().appBlack);
        }
      }
    }
  }

  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withReadStream: true,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedImage = io.File(result.files.single.path!)
            as File; // Store the selected image file
        imagePath = result.files.single.name;
      });
    } else {
      print('No image is selected');
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                        child: Text(
                      'Welcome on board!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Text(
                      'Let\s help you get started by registering with us',
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
                    SizedBox(height: 16.0),
                    CustomTextField(
                      labelText: 'Email',
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    CustomTextField(
                      labelText: 'Phone',
                      controller: _phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        } else if (value.length != 11) {
                          return 'Phone number must be 11 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    CustomTextField(
                      labelText: 'Address',
                      controller: _addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: getImage,
                      child: Container(
                        padding: EdgeInsets.only(right: 5, left: 20),
                        height: 60,
                        decoration: BoxDecoration(
                            color: CustomColor().appWhite,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Select an Image 📷'),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: _selectedImage !=
                                      null // Check if an image is selected
                                  ? Image.file(
                                      _selectedImage!,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColor().appBlack,
                            fixedSize: Size(345, 50)),
                        onPressed: registerUser,
                        child: Text(
                          'Register',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: Center(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'Already have an account ',
                              style: TextStyle(color: CustomColor().appBlack)),
                          TextSpan(
                              text: ' Sign In',
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
          ),
        ));
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
