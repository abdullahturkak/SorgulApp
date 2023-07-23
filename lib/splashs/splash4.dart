import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home.dart';

class Splash4 extends StatelessWidget {
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
              child: Image.asset('assets/images/smile.png'),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Hadi Durma \n aramıza katıl!',
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
              'SorgulApp uygulamasını çok seveceksin. Vakit kaybetmeden aramıza katıl herkesten önce en uygun fiyatlardan haberdar ol.',
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
                  child: Text('Başla'),
                  onPressed: () {
                    Get.to(MainContent());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
