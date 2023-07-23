import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';
import 'controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Controller _controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF181f29)),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.0),
              Text(
                "SorgulApp",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFFf0b90b),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Divider(
                height: 10.0,
                color: Color(0xFF323c45),
                indent: 150,
                endIndent: 150,
                thickness: 1.3,
              ),
              Text(
                "Giriş Yap",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFf1c740),
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: 75.0),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: _controller.usernameController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      labelText: 'Kullanıcı Adı',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: _controller.passwordController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      labelText: 'Şifre',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              MaterialButton(
                height: 40.0,
                minWidth: 100.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {
                  _controller.mail =
                      "${_controller.usernameController.text}@gmail.com";
                  // this is for the login function in auth controller
                  AuthController.authInstance.login(
                    _controller.mail.trim(),
                    _controller.passwordController.text.trim(),
                  ); // this is for the login function in auth controller
                  _controller.mail = "";
                  _controller.usernameController.text = "";
                  _controller.passwordController.text = "";
                },
                padding: EdgeInsets.all(12),
                color: Color(0xFFf17c03),
                child: Text('Giriş Yap', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
