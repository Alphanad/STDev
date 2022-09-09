import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stdev/pages/home.dart';
import 'package:stdev/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<Splash> {
  late bool _isLogin;

  @override
  void initState() {
    _checkLogin();
    Timer(const Duration(seconds: 2), _nextPage);
    super.initState();
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLogin = prefs.getBool('LOGIN') ?? false;
  }

  void _nextPage() async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => _isLogin ? const Home() : const Login()));

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(body: Center(child: FlutterLogo(size: screenSize.height * 0.15)));
  }
}
