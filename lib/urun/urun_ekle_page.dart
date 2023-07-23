import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller.dart';

class UrunEklePage extends StatefulWidget {
  const UrunEklePage({Key? key}) : super(key: key);

  @override
  _UrunEklePageState createState() => _UrunEklePageState();
}

class _UrunEklePageState extends State<UrunEklePage> {
  //ÜRÜN FOTO
  File? _image;
  String indirmeBaglanti = "";
  final imagePicker = ImagePicker();

  Controller controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFf17c03),
        onPressed: () {
          if (controller.urunAd.text == "" ||
              controller.urunFiyat.text == "" ||
              controller.urunMarket.text == "" ||
              controller.urunBarcode.text == "" ||
              controller.urunTarih == "") {
            Get.snackbar("Hatalı", "Tüm yerleri doldurunuz", barBlur: 100);
          } else {
            Get.back();
            Get.snackbar("Başarılı", "Ürün Eklendi");
            controller.urunAd.text = "";
            controller.urunMarket.text = "";
            controller.urunFiyat.text = "";
            controller.urunBarcode.text = "";
            controller.urunTarih = "";
          }
        },
      ),
      appBar: AppBar(
        title: Text("Ürün Ekle"),
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
                  controllerr: controller.urunAd,
                  urunADI: "Ürün Adı",
                ),
                MyTextField(
                    controllerr: controller.urunFiyat, urunADI: "Ürün Fiyat"),
                MyTextField(
                    controllerr: controller.urunMarket, urunADI: "Ürün Market"),
                MyTextField(
                    controllerr: controller.urunBarcode,
                    urunADI: "Ürün Barkod"),
                DateTimePicker(
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
                    labelText: "Ürün Tarih",
                    labelStyle: TextStyle(color: Color(0xFFf1c740)),
                    focusColor: Color(0xFFf1c740),
                  ),
                  cursorColor: Colors.orange,
                  locale: Locale("tr", "TR"),
                  initialValue: null,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: "Tarih",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  onChanged: (val) => controller.urunTarih = val,
                  validator: (val) {
                    return null;
                  },
                  onSaved: (val) => print(val),
                  initialDate: DateTime.now(),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 40,
                  color: Color(0xFFf17c03),
                  child: GestureDetector(
                    onTap: () {
                      controller.addUrun();
                      getImageGallery();
                    },
                    child: Center(
                      child: Text(
                        "Fotoğraf Ekle",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImageGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      //Lütfen bir resim ekleyiniz alert dialog eklenecek
      Get.snackbar("Dikkat", "Foto çekilmedi");
    } else {
      setState(() {
        _image = File(image.path);
      });
      var referansYol = FirebaseStorage.instance
          .ref()
          .child("urunFotograflari")
          .child(controller.urunIdBulucu)
          .child("urunFoto.png");

      var yuklemeGorevi = referansYol.putFile(_image!);

      var url = await (await yuklemeGorevi).ref.getDownloadURL();
      setState(() {
        indirmeBaglanti = url;
      });
      ;

      Get.snackbar("Başarılı", "Fotoğraf Yüklendi", barBlur: 100);
    }
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
