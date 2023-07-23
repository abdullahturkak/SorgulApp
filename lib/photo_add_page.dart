import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sorgulapp/pages/panel.dart';

import 'controller.dart';

class PhotoAddPage extends StatefulWidget {
  @override
  State<PhotoAddPage> createState() => _PhotoAddPageState();
}

class _PhotoAddPageState extends State<PhotoAddPage> {
  Controller controller = Get.put(Controller());
  File? _image;
  String indirmeBaglanti = "";
  final imagePicker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              if (controller.photoControl == 0) {
                Get.snackbar("Hata", "Fotoğraf eklemediniz");
              } else {
                setState(() {
                  controller.photoControl = 0;
                });
                Get.to(() => PanelPage());
              }
            },
            child: Center(
                child: Text(
              "Devam et",
              style: TextStyle(fontSize: 10),
            )),
          ),
        ),
      ),
      backgroundColor: Color(0xFF181f29),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Üyelik fotoğraf seçimi',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFf0b90b),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                width: 150,
                child: Image.asset('assets/images/photo_add.png'),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Profilin için \n fotoğraf ekle!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFf0b90b),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Fotoğraf ekle",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFf1c740),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: buildHawkFabMenu(context),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                height: 50,
                width: 300,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.orange,
                      child: Text(
                        "1",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      color: Colors.orange,
                      height: 10,
                      width: 200,
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.orange,
                      child: Text(
                        "2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  HawkFabMenu buildHawkFabMenu(BuildContext context) {
    return HawkFabMenu(
      blur: 0,
      icon: AnimatedIcons.menu_arrow,
      fabColor: Colors.yellow,
      iconColor: Colors.grey,
      items: [
        HawkFabMenuItem(
          label: 'Kamera',
          ontap: () {
            getImageCamera();
          },
          icon: const Icon(FontAwesomeIcons.camera),
          labelColor: Colors.white,
          labelBackgroundColor: Colors.blue,
        ),
        HawkFabMenuItem(
          label: 'Fotoğraf',
          ontap: () {
            getImageGallery();
          },
          icon: const Icon(FontAwesomeIcons.images),
          labelColor: Colors.white,
          labelBackgroundColor: Colors.blue,
        ),
      ],
      body: const Center(
        child: Text(""),
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
        Get.to(() => Scaffold(
              backgroundColor: Color(0xFFf0b90b),
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ));
      });
      var referansYol = FirebaseStorage.instance
          .ref()
          .child("profilresimleri")
          .child(auth.currentUser!.uid)
          .child("profilResmi.png");

      var yuklemeGorevi = referansYol.putFile(_image!);

      var url = await (await yuklemeGorevi).ref.getDownloadURL();

      download() {
        indirmeBaglanti = url;
        controller.profil_photo = indirmeBaglanti;
        FirebaseFirestore.instance
            .collection("usernames")
            .doc(auth.currentUser!.uid)
            .set({
          "username": controller.username,
          "userID": auth.currentUser!.uid,
        }).whenComplete(() {
          Get.back();
          Get.snackbar("Başarılı", "Fotoğraf başarıyla eklendi", barBlur: 100);
          controller.photoControl = 1;
        });
      }

      setState(() {
        download();
      });
      ;
    }
  }

  Future getImageCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      //Lütfen bir resim ekleyiniz alert dialog eklenecek
      Get.snackbar("Dikkat", "Foto çekilmedi");
    } else {
      setState(() {
        _image = File(image.path);
        Get.to(() => Scaffold(
              backgroundColor: Color(0xFFf0b90b),
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ));
      });
      var referansYol = FirebaseStorage.instance
          .ref()
          .child("profilresimleri")
          .child(auth.currentUser!.uid)
          .child("profilResmi.png");

      var yuklemeGorevi = referansYol.putFile(_image!);

      var url = await (await yuklemeGorevi).ref.getDownloadURL();
      setState(() {
        indirmeBaglanti = url;
        controller.profil_photo = indirmeBaglanti;
        download() {
          indirmeBaglanti = url;
          controller.profil_photo = indirmeBaglanti;
          FirebaseFirestore.instance
              .collection("usernames")
              .doc(auth.currentUser!.uid)
              .set({
            "username": controller.username,
            "userID": auth.currentUser!.uid,
          }).whenComplete(() {
            Get.back();
            Get.snackbar("Başarılı", "Fotoğraf başarıyla eklendi",
                barBlur: 100);
            controller.photoControl = 1;
          });
        }

        download();
      });
      ;
    }
  }
}
