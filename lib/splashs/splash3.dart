import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sorgulapp/splashs/splash4.dart';

class Splash3 extends StatelessWidget {
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
              height: 150,
              width: 150,
              child: Image.asset('assets/images/bell.png'),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Tüm Ürünlerden \n anında haberdar ol!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'SorgulApp seni düşünüyor. Favorilerine eklediğin tüm ürünlerin fiyat değişikliğinden hemen haberdar ol, indirimleri kaçırma.',
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
                    Get.to(Splash4());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
