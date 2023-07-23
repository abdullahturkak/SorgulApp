import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller.dart';

class UrunUpdatePage extends StatefulWidget {
  const UrunUpdatePage({Key? key}) : super(key: key);

  @override
  _UrunUpdatePageState createState() => _UrunUpdatePageState();
}

class _UrunUpdatePageState extends State<UrunUpdatePage> {
  //ÜRÜN FOTO
  File? _image;
  String indirmeBaglanti = "";
  final imagePicker = ImagePicker();

  Controller controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("usernames").snapshots(),
      builder: (context, asyncsnaphot) {
        if (asyncsnaphot.hasError) {
          return Text("Something went wrong");
        }
        ;

        if (asyncsnaphot.hasData) {
          List<DocumentSnapshot> listemUsername = asyncsnaphot.data!.docs;
          for (var i = 0; i < listemUsername.length; i++) {
            controller.listemFiltre.add({
              "userID": (listemUsername[i].get("userID")),
            });
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.update),
              backgroundColor: Color(0xFFf17c03),
              onPressed: () {
                if (controller.urunFiyat.text == "") {
                  Get.snackbar("Hatalı", "Tüm yerleri doldurunuz",
                      barBlur: 100);
                } else {
                  controller.updateUrun();
                  Get.snackbar("Başarılı", "Ürün güncellendi", barBlur: 100);
                  controller.urunFiyat.text = "";
                  controller.urunMarket.text = "";
                }
              },
            ),
            appBar: AppBar(
              title: Text("Ürün Güncelle"),
              backgroundColor: Color(0xFF29313c),
            ),
            backgroundColor: Color(0xFF181f29),
            body: Center(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTextField(
                          controllerr: controller.urunFiyat,
                          urunADI: "Ürün Fiyat"),
                      MyTextField(
                          controllerr: controller.urunMarket,
                          urunADI: "Ürün Market"),
                    ],
                  ),
                ),
              ),
            ),
          );
          ;
        }

        return SizedBox();
      },
    );
  }
}

class MyTextField extends StatelessWidget {
  TextEditingController controllerr;
  String urunADI;
  MyTextField({required this.controllerr, required this.urunADI});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controllerr,
      cursorColor: Color(0xFFf1c740),
      style: TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFf1c740),
          ),
        ),
        labelText: urunADI,
        labelStyle: TextStyle(color: Color(0xFFf1c740)),
        focusColor: Color(0xFFf1c740),
      ),
    );
  }
}
