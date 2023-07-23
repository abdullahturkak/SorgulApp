import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';
import '../firebase_constants.dart';

class FavoritePages extends StatefulWidget {
  const FavoritePages({Key? key}) : super(key: key);

  @override
  _FavoritePagesState createState() => _FavoritePagesState();
}

class _FavoritePagesState extends State<FavoritePages> {
  List<DocumentSnapshot<Object>> listemFiltre = [];

  Controller controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoriler"),
        backgroundColor: Color(0xFF29313c),
      ),
      backgroundColor: Color(0xFF181f29),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.urun_favoriler
            .doc(auth.currentUser!.uid)
            .collection("favorites")
            .snapshots(),
        builder: (context, asyncsnaphot) {
          if (asyncsnaphot.hasError) {
            return Text("Something went wrong");
          }
          ;
          if (asyncsnaphot.hasData) {
            List<DocumentSnapshot> listemFavori = asyncsnaphot.data!.docs;
            if (listemFavori.length == 0) {
              return Center(
                child: Text("Favorilerde Ürün Yok"),
              );
            } else {
              return buildListView(listemFavori);
            }
          }

          return SizedBox();
        },
      ),
    );
  }

  ListView buildListView(
    List<DocumentSnapshot<Object?>> listemFavori,
  ) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var dataFav = listemFavori[index].get;

        return Card(
          color:
              dataFav("indirimCheck") == "1" ? Colors.green : Color(0xFFf17c03),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
              onTap: () {
                setState(() {});
              },
              title: Text(
                  "${dataFav("urunAd")}  ${dataFav("urunFiyat")} TL ${dataFav("urunMarket")}"),
              subtitle: dataFav("indirimCheck") == "1"
                  ? Text(
                      "İndirime Girdi!",
                      style: TextStyle(
                          color: Colors.white, backgroundColor: Colors.red),
                    )
                  : Text(""),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.urunIdBulucu = dataFav("urunID");
                      controller.indirimDel();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await listemFavori[index].reference.delete();
                  },
                ),
              ])),
        );
      },
      itemCount: listemFavori.length,
    );
  }
}
