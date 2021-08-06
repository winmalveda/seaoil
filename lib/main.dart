import 'package:flutter/material.dart';
import 'package:seaoil/screen/homepage.dart';
import 'package:seaoil/screen/login_page.dart';
import 'package:seaoil/screen/search_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Seaoil Stations',
        color: Colors.deepPurpleAccent,
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => new Login(),
          '/homepage': (BuildContext context) => new Homepage(),
          '/search': (BuildContext context) => new SearchLocation(),
        });
  }
}
