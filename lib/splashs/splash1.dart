import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorgulapp/splashs/splash2.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/sorgula.png'),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'SorgulApp',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'SorgulApp, ürün barkod numarasına veya adına göre ürün isim ve fiyat bilgilerini sorgulamanızı sağlayan bir uygulamadır.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 100,
              child: ElevatedButton(
                  child: Text("ileri"),
                  onPressed: () {
                    Get.to(Splash2());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
