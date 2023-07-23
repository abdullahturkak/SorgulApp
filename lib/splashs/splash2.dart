import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorgulapp/splashs/splash3.dart';

class Splash2 extends StatelessWidget {
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
              child: Image.asset('assets/images/delivery.png'),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Tüm Ürünler \n elinizin altında!',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'SorgulApp bütçe dostudur. Tüm ürünlerin fiyat bilgisini görebilir, en uygun satış nerede olduğunu hemencecik öğrenebilirsin.',
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
                  child: Text('ileri'),
                  onPressed: () {
                    Get.to(Splash3());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
