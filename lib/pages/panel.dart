import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sorgulapp/urun/urun_detay_page.dart';
import 'package:sorgulapp/urun/urun_ekle_page.dart';
import 'package:sorgulapp/urun/urun_update_page.dart';

import '../controller.dart';
import '../firebase_constants.dart';
import '../profile_page.dart';
import 'favorite_pages.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({Key? key}) : super(key: key);

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  //////SEARCH BAR
  String _scanBarcode = 'Unknown';
  Icon icon_heart = Icon(FontAwesomeIcons.heart);
  var heart_check = true;
  var barCodeOrSearch = 0;
  var searchControl = TextEditingController();
  Controller controller = Get.put(Controller());
  String indirmeBaglanti = "";
  var ucKurali = 0;
  var listUzunluk = 0;
  String searchKey = "";
  Stream<QuerySnapshot<Object?>>? streamQuery;
  Stream<QuerySnapshot<Object?>>? streamQueryBarcode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      profilPhotoBaglantiAl();
      controller.urunPhotoBaglantiAl();
      userNameGetir();
    });
  }

  userNameGetir() {
    FirebaseFirestore.instance
        .collection("usernames")
        .doc(auth.currentUser!.uid)
        .get()
        .then((gelenVeri) {
      setState(() {
        controller.username = gelenVeri.data()!["username"];
      });
    });

    print(auth.currentUser!.uid);
  }

  profilPhotoBaglantiAl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilResmi.png")
        .getDownloadURL();
    setState(() {
      controller.profil_photo = baglanti;
      print(controller.profil_photo);
      print("Bağlantı:  ${baglanti}");
    });
  }

  urunPhotoBaglantiAl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("urunFotograflari")
        .child(controller.urunIdBulucu)
        .child("urunFoto.png")
        .getDownloadURL();
    setState(() {
      controller.urunFotoBulucu = baglanti;
      print(controller.urunFotoBulucu);
      print("Bağlantı:  ${baglanti}");
      print("fonksiyon çalıştırıldı");
      print("Şu anki foto Link : ${controller.urunFotoBulucu}");
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      controller.scanBarcode = barcodeScanRes;
      print("scan barkod değer${controller.scanBarcode}");
    });
  }

  @override
  Widget build(BuildContext context) {
    userNameGetir() {
      FirebaseFirestore.instance
          .collection("usernames")
          .doc(auth.currentUser!.uid)
          .get()
          .then((gelenVeri) {
        setState(() {
          controller.username = gelenVeri.data()!["username "];
        });
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFF29313c),
      appBar: AppBar(
        backgroundColor: Color(0xFF29313c),
        title: Text("SorgulApp"),
        leading: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xFF29313c),
                  elevation: 25,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  title: Row(
                    children: [
                      Icon(Icons.info, color: Colors.white),
                      SizedBox(width: 10.0),
                      new Text(
                        "SorgulApp",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  content: new Text(
                    'SorgulApp, ürün barkod numarasına veya adına göre ürün isim ve fiyat bilgilerini sorgulamanızı sağlayan bir uygulamadır.',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    new TextButton(
                      child: new Text(
                        "Kapat",
                        style: TextStyle(
                          color: Color(0xFFf17c03),
                        ),
                      ),
                      onPressed: () {
                        print(controller.scanBarcode);

                        Get.back();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.info_outline_rounded,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => FavoritePages()),
                  child: Icon(FontAwesomeIcons.solidHeart),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    userNameGetir();
                    Get.to(ProfilePage());
                  },
                  child: Icon(Icons.manage_accounts),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          buildSearchBar(),
          Expanded(
            child: ucKurali < 3
                ? SizedBox()
                : StreamBuilder<QuerySnapshot>(
                    stream:
                        barCodeOrSearch == 0 ? streamQuery : streamQueryBarcode,
                    builder: (context, asyncsnaphot) {
                      if (asyncsnaphot.hasError) {
                        return Text("Something went wrong");
                      }
                      ;
                      if (asyncsnaphot.hasData) {
                        List<DocumentSnapshot> listem = asyncsnaphot.data!.docs;
                        if (listem.length == 0) {
                          controller.scanBarcodeKontrol = false;
                        } else {
                          controller.scanBarcodeKontrol = true;
                        }
                        if (listem.length == 0) {
                          return buildUrunEkleButton(TextButton(
                            onPressed: () {
                              userNameGetir();
                              Get.to(UrunEklePage());
                            },
                            child: Center(
                              child: Row(children: [
                                Text(
                                  "Ürün ekle",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ]),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFf17c03),
                              ),
                            ),
                          ));
                        } else {
                          return buildListView(listem);
                        }
                      }

                      return SizedBox();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Center buildUrunEkleButton(TextButton ozelTextButton) {
    return Center(
      child: Container(
        width: 1000,
        height: 100,
        child: ozelTextButton,
      ),
    );
  }

  ListView buildListView(List<DocumentSnapshot<Object?>> listem) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var data = listem[index].get;
        ListTile ozelListTile = ListTile(
            onTap: () {
              setState(() {
                controller.urunAdBulucu = data("urunAd");
                controller.urunIdBulucu = data("id");
                Get.to(() => UrunDetayPage());
                controller.urunFotoBulucu = "";
              });
            },
            title: Text(data("urunAd")),
            subtitle: Text('${data("urunFiyat")} TL'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.add),
                onPressed: () {
                  for (var i = 0; i < listem.length; i++) {
                    controller.listemFiltre.add({
                      "usernameID": (listem[i].get("urunFiyat")),
                    });
                  }

                  controller.urunFiyatBulucu = (data("urunFiyat"));
                  controller.urunAdBulucu = data("urunAd");
                  controller.urunIdBulucu = data("id");
                  controller.addFavorite();
                  Get.snackbar(
                      "Başarılı", "${data("urunAd")} favorilerine eklendi");
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    controller.urunMarketBulcucu = data("urunMarket");
                    controller.urunFiyatBulucu = data("urunFiyat");
                    controller.urunIdBulucu = data("id");
                    controller.urunAdBulucu = data("urunAd");
                    print("ürün fiyat bulucu  ${controller.urunFiyatBulucu}");
                  });

                  Get.to(UrunUpdatePage());
                },
              ),
            ]));
        controller.listTileOzel = ozelListTile;
        return Card(
          color: Color(0xFFf17c03),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ozelListTile,
        );
      },
      itemCount: listem.length,
    );
  }

  TextField buildSearchBar() {
    return TextField(
        cursorColor: Color(0xFFf1c740),
        style: TextStyle(color: Color(0xFFf1c740), fontSize: 18),
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
          labelText: "Ürün Arama",
          labelStyle: TextStyle(color: Color(0xFFf1c740)),
          suffixIcon: GestureDetector(
            onTap: () async {
              await scanBarcodeNormal();
              setState(() {
                streamQueryBarcode = controller.urun_records
                    .where("urunBarcode", isEqualTo: controller.scanBarcode)
                    .snapshots();
                ucKurali = 4;
                barCodeOrSearch = 1;

                Timer(Duration(milliseconds: 1000), () {
                  if (controller.scanBarcodeKontrol == true) {
                    controller.listTileOzel.onTap();
                    setState(() {
                      ucKurali = 0;
                    });
                  } else {}
                });
              });
            },
            child: Icon(
              FontAwesomeIcons.barcode,
              color: Colors.blueGrey,
            ),
          ),
          suffixStyle: TextStyle(color: Colors.blueGrey),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blueGrey,
          ),
          prefixStyle: TextStyle(color: Colors.red),
          focusColor: Color(0xFFf1c740),
        ),
        onChanged: (value) {
          setState(() {
            ucKurali = value.length;
            print(ucKurali);
            if (ucKurali >= 3) {
              barCodeOrSearch = 0;
              print(value.length);
              ucKurali = value.length;
              print("ife girildi");
              searchKey = value;
              streamQuery = FirebaseFirestore.instance
                  .collection('urunler')
                  .where('urunAd', isGreaterThanOrEqualTo: searchKey)
                  .where('urunAd', isLessThan: searchKey + 'z')
                  .snapshots();
            } else if (ucKurali < 3)
              setState(() {
                print("yok olmalı");
              });
          });
        });
  }
}
