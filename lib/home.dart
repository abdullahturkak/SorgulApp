import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorgulapp/login.dart';
import 'package:sorgulapp/register.dart';

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFF181f29)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                "Aramıza Katıl",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFf1c740),
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: 50.0),
              Column(
                children: [
                  MaterialButton(
                    height: 40.0,
                    minWidth: 200.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
                      Get.to(RegisterPage());
                    },
                    padding: EdgeInsets.all(12),
                    color: Color(0xFFf17c03),
                    child:
                        Text('Üye Ol', style: TextStyle(color: Colors.white)),
                  ),
                  MaterialButton(
                    height: 40.0,
                    minWidth: 200.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
                      Get.to(LoginPage());
                    },
                    padding: EdgeInsets.all(12),
                    color: Color(0xFFf17c03),
                    child: Text('Giriş Yap',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
