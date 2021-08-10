import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seaoil/model/login_request.dart';
import 'package:http/http.dart';
import 'package:seaoil/model/login_response.dart';
import 'package:seaoil/widget/common.dart';
import 'package:seaoil/widget/errorMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    Common().getCurrentLocation();
    Common().checkPermission();
    checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              SizedBox(height: 80),
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset("asset/logo.png", fit: BoxFit.contain)),
              SizedBox(height: 50),
              Text(
                "L O G I N",
                style:
                    TextStyle(fontSize: 18.0, color: Colors.deepPurpleAccent),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: mobileController,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      hintText: "Mobile Number",
                      fillColor: Colors.white,
                    )),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      hintText: "Password",
                      fillColor: Colors.white,
                    )),
              ),
              SizedBox(height: 50),
              isLogin
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.deepPurpleAccent,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          onPressed: () async {
                            setState(() {
                              isLogin = true;
                            });
                            login();
                          },
                          child: Text("Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0)),
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    try {
      String mobile = mobileController.text;
      String password = passwordController.text;

      if (mobile.isEmpty || password.isEmpty) {
        errorMessage("Mobile and password fields is required!");
        setState(() {
          isLogin = false;
        });
        return;
      }

      LoginRequest loginRequest =
          new LoginRequest(mobile: mobile, password: password);
      String request = json.encode(loginRequest);
      String url = "https://stable-api.pricelocq.com/mobile/v2/sessions";
      Response response = await post(Uri.parse(url), body: request);
      setState(() {
        isLogin = false;
      });
      if (response.statusCode == 200) {
        Map responseMap = jsonDecode(response.body);
        LoginResponse loginResponse = LoginResponse.fromJson(responseMap);
        print(loginResponse.data.accessToken);
        if (loginResponse.status == "success") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLogin", true);
          prefs.setString("accessKey", loginResponse.data.accessToken);
          Navigator.pushReplacementNamed(context, "/homepage");
        } else {
          errorMessage(loginResponse.data.message);
        }
      } else {
        errorMessage("Something went wrong!");
      }
    } catch (Exception) {
      errorMessage("Something went wrong!");
    }
  }

  void checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = false;
    isLogin = prefs.getBool("isLogin");
    if (isLogin == true) {
      Navigator.pushReplacementNamed(context, "/homepage");
    }
  }
}
