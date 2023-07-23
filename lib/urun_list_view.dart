import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'controller.dart';

class RecordView extends StatefulWidget {
  @override
  _RecordViewState createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  final Controller _controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.urun_records.snapshots(),
      builder: (context, asyncsnaphot) {
        if (asyncsnaphot.hasError) {
          return Text("Something went wrong");
        }
        ;
        if (asyncsnaphot.hasData) {
          List<DocumentSnapshot> listem = asyncsnaphot.data!.docs;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var data = listem[index].get;
              return Card(
                color: Colors.teal[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.userTie),
                  ),
                  onTap: () {
                    _controller.urunIdBulucu = data("id");
                    print(_controller.urunIdBulucu);
                    print("bastınki");
                  },
                ),
              );
            },
            itemCount: listem.length,
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
