import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_market/CustomCompraWidget.dart';
import 'package:open_market/home.dart';

class Compras extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Minhas Compras"),
          leading: RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: Icon(
                Icons.arrow_back_rounded,
                size: 24,
              ),
              shape: CircleBorder(
                  side: BorderSide(
                width: 0,
                style: BorderStyle.none,
              )))),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("compras")
                        .where('userId == ' +
                            FirebaseAuth.instance.currentUser.uid)
                        .orderBy("data", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.done:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot == null ||
                              snapshot.data == null ||
                              snapshot.data.documents.length == 0) {
                            return Center(
                              child: Text(
                                "Não há dados!",
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 20),
                              ),
                            );
                          } else {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: CustomCompraWidget(
                                          codRastreamento: snapshot
                                              .data.documents[index]
                                              .data()["codRastreamento"]
                                              .toString(),
                                          produtoId: snapshot
                                              .data.documents[index]
                                              .data()["produtoId"]
                                              .toString(),
                                          status: int.parse(snapshot
                                              .data.documents[index]
                                              .data()["status"]
                                              .toString()),
                                          onPressed: () {}));
                                });
                          }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
