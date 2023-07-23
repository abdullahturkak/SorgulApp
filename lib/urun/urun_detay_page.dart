import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';

class UrunDetayPage extends StatefulWidget {
  @override
  _UrunDetayPageState createState() => _UrunDetayPageState();
}

class _UrunDetayPageState extends State<UrunDetayPage> {
  Controller controller = Get.find();
  int _currentSortColumn = 0;
  bool _isAscending = true;
  int denetleyici = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      urunPhotoBaglantiAl();
    });
  }

  List<DocumentSnapshot> listemFiltre = [];
  final List<Map> _listGecici = [];

  urunPhotoBaglantiAl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("urunFotograflari")
        .child(controller.urunIdBulucu)
        .child("urunFoto.png")
        .getDownloadURL();
    setState(() {
      controller.urunFotoBulucu = baglanti;
    });
  }

  Widget build(BuildContext context) {
    var varsayilanStream = controller.urun_updates.snapshots();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF29313c),
          title: Text("Ürün detayı"),
        ),
        backgroundColor: Color(0xFF181f29),
        body: SingleChildScrollView(
          child: Column(children: [
            Center(
                child: controller.urunFotoBulucu == ""
                    ? CircularProgressIndicator()
                    : Image.network(
                        controller.urunFotoBulucu.toString(),
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.urunAdBulucu,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: varsayilanStream,
              builder: (context, asyncsnapshot) {
                if (asyncsnapshot.hasError) {
                  return Text("Error");
                }

                if (asyncsnapshot.hasData) {
                  List<DocumentSnapshot> listem = asyncsnapshot.data!.docs;

                  for (var i = 0; i < listem.length; i++) {
                    if (listem[i].get("urunID") == controller.urunIdBulucu) {
                      listemFiltre.add(listem[i]);
                    }
                  }
                  if (denetleyici == 0) {
                    denetleyici++;
                    for (var i = 0; i < listemFiltre.length; i++) {
                      _listGecici.add({
                        "urunFiyat": (listemFiltre[i].get("urunFiyat")),
                        "urunAd": listemFiltre[i].get("urunAd"),
                        "urunTarih": listemFiltre[i].get("urunTarih"),
                        "urunMarket": listemFiltre[i].get("urunMarket"),
                        "ekleyenAd": listemFiltre[i].get("ekleyenAd"),
                      });
                    }
                  }

                  void onSort(int columnIndex, bool ascending) {
                    if (columnIndex == 0) {
                      _listGecici.sort((a, b) => compareString(
                          ascending, a["urunTarih"], b["urunTarih"]));
                    }
                    if (columnIndex == 1) {
                      _listGecici.sort((a, b) => compareDouble(
                          ascending, a["urunFiyat"], b["urunFiyat"]));
                    }
                    if (columnIndex == 2) {
                      _listGecici.sort((a, b) => compareString(
                          ascending, a["urunMarket"], b["urunMarket"]));
                    }
                    if (columnIndex == 3) {
                      _listGecici.sort((a, b) => compareString(
                          ascending, a["ekleyenAd"], b["ekleyenAd"]));
                    }
                    setState(() {
                      this._currentSortColumn = columnIndex;
                      this._isAscending = ascending;
                    });
                  }

                  return DataTable(
                    sortColumnIndex: _currentSortColumn,
                    sortAscending: _isAscending,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.amber[200]),
                    columns: [
                      DataColumn(
                        label: Text('Tarih'),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: Text(
                          'Fiyat',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Sorting function
                        onSort: onSort,
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text('Market'),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: Text('Kullanıcı'),
                        onSort: onSort,
                      ),
                    ],
                    columnSpacing: 30,
                    rows: _listGecici.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(
                          item['urunTarih'],
                          style: TextStyle(color: Colors.white),
                        )),
                        DataCell(Text(
                          item['urunFiyat'].toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                        DataCell(Text(
                          item['urunMarket'].toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                        DataCell(Text(
                          item['ekleyenAd'].toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                      ]);
                    }).toList(),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ]),
        ));
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareDouble(bool ascending, var value1, var value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
