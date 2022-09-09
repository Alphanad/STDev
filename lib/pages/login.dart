import 'package:flutter/material.dart';
import 'package:stdev/pages/home.dart';
import 'package:stdev/configs/strings.dart';
import 'package:stdev/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("LOGIN", true);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: screenSize.width * 0.05, right: screenSize.width * 0.05, bottom: screenSize.height * 0.03),
                child: Column(children: <Widget>[
                  FlutterLogo(size: screenSize.height * 0.23),
                  Padding(padding: EdgeInsets.only(top: screenSize.height * 0.03), child: CustomTextField(controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, prefixIcon: const Icon(Icons.email), labelText: Strings.email, isEmailValidator: true)),
                  Padding(padding: EdgeInsets.only(top: screenSize.height * 0.03), child: CustomTextField(controller: _passwordController, keyboardType: TextInputType.visiblePassword, textInputAction: TextInputAction.done, prefixIcon: const Icon(Icons.password), labelText: Strings.password, isEmailValidator: false, obscureText: true,)),
                  Padding(padding: EdgeInsets.only(top: screenSize.height * 0.1), child: ElevatedButton(onPressed: () => _onLogin(), style: ElevatedButton.styleFrom(fixedSize: Size(screenSize.width, screenSize.height * 0.07)), child: const Text(Strings.login, style: TextStyle(fontSize: 20)))),
                ]),
              ),
            ),
          ),
        )
    );
  }
}
