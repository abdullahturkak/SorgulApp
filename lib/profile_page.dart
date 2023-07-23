import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_controller.dart';
import 'controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static AuthController authInstance = Get.find();
  Controller _controller = Get.put(Controller());
  AuthController _controller_auth = Get.put(AuthController());
  String bosPhoto =
      "https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.pinimg.com%2F736x%2F21%2F20%2Fb0%2F2120b058cb9946e36306778243eadae5.jpg&imgrefurl=https%3A%2F%2Fwww.pinterest.com%2Fpin%2F685813849509598045%2F&tbnid=sEs_mqc5VLJ9WM&vet=12ahUKEwjM5_qHloj0AhVSiqQKHXGpAFIQMygDegUIARC1AQ..i&docid=HeOae4kqLXsiyM&w=728&h=508&q=avatar%20png&hl=tr&ved=2ahUKEwjM5_qHloj0AhVSiqQKHXGpAFIQMygDegUIARC1AQ";

  yaziSil() {
    FirebaseFirestore.instance
        .collection("usernames")
        .doc(auth.currentUser!.uid)
        .delete();
  }

  final imagePicker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF29313c),
        title: Text("Profil Sayfası"),
      ),
      body: Material(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFF181f29)),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50.0),
                Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: _controller.profil_photo == ""
                            ? Image.asset(
                                'assets/images/photo_add.png',
                                width: 100,
                                height: 100,
                              )
                            : Image.network(
                                _controller.profil_photo,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50.0),
                Text(_controller.username.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
                SizedBox(height: 20.0),
                Divider(
                  height: 15.0,
                  color: Color(0xFF323c45),
                  indent: 150,
                  endIndent: 150,
                  thickness: 2.5,
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: _controller.newpassController,
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
                        labelText: 'Yeni Şifre',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),

                //ŞİFRE DEĞİŞME
                MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.newpassController.text == ""
                          ? Get.snackbar(
                              "Şifre Giriniz", "Herhangi bir şifre girmediniz")
                          : AuthController.authInstance.signOut();
                      auth.currentUser!
                          .updatePassword(_controller.newpassController.text);
                      _controller.newpassController.text = "";
                      _controller_auth.currentPage2 = 1;
                    });
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFFf17c03),
                  child:
                      Text('Değiştir', style: TextStyle(color: Colors.white)),
                ),
                Divider(
                  height: 30.0,
                ),

                //ÜYELİK SİLME
                MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    setState(() {
                      authInstance.deleteUser();
                      yaziSil();
                    });
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.red,
                  child: Text('Üyeliğimi Kalıcı Olarak Sil',
                      style: TextStyle(color: Colors.white)),
                ),
                Divider(
                  height: 30.0,
                ),
                MaterialButton(
                  height: 40.0,
                  minWidth: 100.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    AuthController.authInstance.signOut();
                    setState(() {
                      _controller_auth.currentPage2 = 1;
                    });
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.red,
                  child: Text('Oturumu kapat',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
