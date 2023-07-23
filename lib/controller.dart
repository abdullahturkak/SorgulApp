import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Controller extends GetxController {
  var uuid = Uuid();
  var ID = Uuid().v4();
  var ID2 = Uuid().v4();
  var ID3 = Uuid().v4();

  var favUrunIdBulucu = "";
  var urunMarketBulcucu = "";
  var urunIdBulucu = "";
  var urunAdBulucu = "";
  var urunFotoBulucu = "";
  var urunFiyatBulucu = 0.0;
  var scanBarcode = '';
  var scanBarcodeKontrol = true;

  List<Map> listemFiltre = [];
  var listTileOzel = null;
  int counter = 0;
  int totalStep = 4;
  String profil_photo = "";
  var username = "";
  var mail = "";
  var urunTarih = "";
  var photoControl = 0;

  final newpassController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  TextEditingController urunAd = TextEditingController();
  TextEditingController urunFiyat = TextEditingController();
  TextEditingController urunMarket = TextEditingController();
  TextEditingController urunBarcode = TextEditingController();

  CollectionReference urun_records =
      FirebaseFirestore.instance.collection('urunler');
  CollectionReference urun_updates =
      FirebaseFirestore.instance.collection('urunGuncelleme');
  CollectionReference urun_favoriler =
      FirebaseFirestore.instance.collection('urunFavoriler');
  CollectionReference usernames =
      FirebaseFirestore.instance.collection('usernames');

  final FirebaseAuth auth = FirebaseAuth.instance;

  void indirimDel() {
    urun_favoriler
        .doc(auth.currentUser!.uid)
        .collection("favorites")
        .doc(urunIdBulucu)
        .update({"indirimCheck": "0"});
  }

  void updateUrun() {
    urun_updates.doc(ID2).set({
      "id": ID2,
      "urunAd": urunAdBulucu,
      "urunFiyat": double.parse(urunFiyat.text),
      "urunID": urunIdBulucu,
      "urunTarih": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "urunMarket": urunMarket.text == "" ? urunMarketBulcucu : urunMarket.text,
      "ekleyenAd": username,
    });

    urun_records.doc(urunIdBulucu).update({
      "urunFiyat": double.parse(urunFiyat.text),
      "urunMarket": urunMarket.text,
    });
    print(listemFiltre);
    for (int i = 0; i < listemFiltre.length; i++) {
      urun_favoriler
          .doc(listemFiltre[i]["userID"])
          .collection("favorites")
          .doc(urunIdBulucu)
          .update({
        "urunMarket": urunMarket.text,
        "urunFiyat": urunFiyat.text,
        "indirimCheck":
            double.parse(urunFiyat.text) < (urunFiyatBulucu) ? "1" : "0"
      });
    }
    listemFiltre = [];

    ID2 = Uuid().v4();
  }

  void addUrun() {
    urun_records.doc(ID).set({
      "id": ID,
      "urunAd": urunAd.text,
      "urunFiyat": double.parse(urunFiyat.text),
      "userID": auth.currentUser!.uid,
      "urunTarih": urunTarih,
      "urunMarket": urunMarket.text,
      "ekleyenAd": username,
      "urunBarcode": urunBarcode.text,
      "favori_check": "0",
    });
    urun_updates.doc(ID2).set({
      "id": ID2,
      "urunAd": urunAd.text,
      "urunFiyat": double.parse(urunFiyat.text),
      "urunID": ID,
      "urunTarih": urunTarih,
      "urunMarket": urunMarket.text,
      "ekleyenAd": username,
    });
    urunIdBulucu = ID;
    ID = Uuid().v4();
    ID2 = Uuid().v4();
  }

  void addFavorite() {
    urun_favoriler
        .doc(auth.currentUser!.uid)
        .collection("favorites")
        .doc(urunIdBulucu)
        .set({
      "id": ID3,
      "urunAd": urunAdBulucu,
      "urunMarket": urunMarket.text,
      "urunFiyat": urunFiyatBulucu,
      "urunID": urunIdBulucu,
      "indirimCheck": "0",
    });
    favUrunIdBulucu = ID3;
    ID3 = Uuid().v4();
  }

  void delFavorite() async {
    var response = await urun_favoriler.get();
    var listem_favori = response.docs;
    for (int i = 0; i < listem_favori.length; i++) {
      if ((listem_favori[i].data() as Map)["urunID"] == urunIdBulucu &&
          (listem_favori[i].data() as Map)["userID"] == auth.currentUser!.uid) ;
      listem_favori[i].reference.update;
    }
  }

  urunPhotoBaglantiAl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("urunFotograflari")
        .child(urunIdBulucu)
        .child("urunFoto.png")
        .getDownloadURL();

    urunFotoBulucu = baglanti;
    print(urunFotoBulucu);
    print("Bağlantı:  ${baglanti}");
    update();
  }
}
