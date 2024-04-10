import 'package:cubex_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String token = '';
  String userName = '';
  String phone = '';
  String email = '';
  String address = '';

  void getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String tokenFromPrefs = prefs.getString('token').toString();
    String userNameFromPrefs = prefs.getString('userName').toString();
    String emailFromPrefs = prefs.getString('email').toString();
    String phoneFromPrefs = prefs.getString('phone').toString();
    String addressFromPrefs = prefs.getString('address').toString();

    setState(() {
      token = tokenFromPrefs.toString();
      userName = userNameFromPrefs.toString();
      phone = phoneFromPrefs.toString();
      email = emailFromPrefs.toString();
      address = addressFromPrefs.toString();
    });
    print(token);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor().appWhite,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Container(
                height: 250,
                width: 350,
                decoration: BoxDecoration(
                    color: CustomColor().appGrey300,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          color: CustomColor().appGrey400,
                          offset: Offset(5, 5))
                    ]),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(userName),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text(phone),
                        ),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text(email),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text(address),
                        ),
                      ],
                    ),
              ),
              SizedBox(
                height: 50,
              ),
              token != ''
                  ? Center(
                      child: Container(
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                            color: CustomColor().appBlack,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3,
                                  color: CustomColor().appGrey400,
                                  offset: Offset(5, 5))
                            ]),
                        child: TextButton(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                                color: CustomColor().appWhite,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => context.go('/'),
                        ),
                      ),
                    )
                  : Center(child: Text('profile page'))
            ],
          ),
        ),
      )),
    );
  }
}
