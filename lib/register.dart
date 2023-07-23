import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_controller.dart';
import 'controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Controller controller = Get.put(Controller());
  File? _image;
  String indirmeBaglanti = "";
  final imagePicker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
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
                "Üye Ol",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFf1c740),
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: 75.0),
              Text(
                'Kişisel bilgileri girin',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFf0b90b),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  controller: controller.usernameController,
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
                  controller: controller.passwordController,
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
                  setState(() {
                    controller.mail =
                        "${controller.usernameController.text}@gmail.com";
                    print(controller.mail);
                    // this is for the register function in auth controller
                    AuthController.authInstance.register(
                      controller.mail.trim(),
                      controller.passwordController.text.trim(),
                    );
                    controller.username = controller.usernameController.text;
                    print("Username ${controller.username}");

                    controller.mail = "";
                    controller.usernameController.text = "";
                    controller.passwordController.text = "";
                  });
                },
                padding: EdgeInsets.all(12),
                color: Color(0xFFf17c03),
                child: Text('Kaydır>>', style: TextStyle(color: Colors.white)),
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
                      color: Colors.white70,
                      height: 10,
                      width: 200,
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Text(
                        "2",
                        style: TextStyle(color: Colors.orange),
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

  Future getImageCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      //Lütfen bir resim ekleyiniz alert dialog eklenecek
      Get.snackbar("Dikkat", "Foto çekilmedi");
    } else {
      setState(() {
        _image = File(image.path);
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
      });
      ;
    }
  }
}
