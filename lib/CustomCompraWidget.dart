import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';

class CustomCompraWidget extends StatelessWidget {
  final String codRastreamento;
  final String produtoId;
  final int status;
  final VoidCallback onPressed;

  const CustomCompraWidget(
      {Key key,
      this.codRastreamento,
      this.produtoId,
      this.status,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: this.onPressed,
        child: Container(
          width: double.infinity,
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("produtos")
                .doc(this.produtoId)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return Row(children: [
                  Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: new Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: FutureBuilder<String>(
                        future: ReturnImage(snapshot.data["produtoImagem"]),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                                padding: EdgeInsets.all(10),
                                height: 282,
                                child: OctoImage(
                                  image:
                                      CachedNetworkImageProvider(snapshot.data),
                                  placeholderBuilder: OctoPlaceholder.blurHash(
                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                  ),
                                  errorBuilder:
                                      OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  height: 89,
                                ));
                          } else {
                            return Container(
                                padding: EdgeInsets.all(10),
                                height: 282,
                                child: OctoImage(
                                  image: CachedNetworkImageProvider(""),
                                  placeholderBuilder: OctoPlaceholder.blurHash(
                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                  ),
                                  errorBuilder:
                                      OctoError.icon(color: Colors.red),
                                  fit: BoxFit.cover,
                                  height: 89,
                                ));
                          }
                        },
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data["produtoNome"],
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        RetornaStatus(this.status)
                      ],
                    ),
                  )
                ]);
              } else {
                return Container();
              }
            },
          ),
        ));
  }

  Widget RetornaStatus(int status) {
    if (status == 1) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Pago",
            style: GoogleFonts.inter(
                textStyle: TextStyle(fontSize: 18, color: Colors.green))),
        SizedBox(
          height: 20,
        )
      ]);
    } else if (status == 2) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Objeto Postado",
            style: GoogleFonts.inter(
                textStyle: TextStyle(fontSize: 18, color: Colors.blue))),
        Text(this.codRastreamento,
            style: GoogleFonts.inter(textStyle: TextStyle(fontSize: 17))),
      ]);
    } else if (status == 3) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Cancelado",
            style: GoogleFonts.inter(
                textStyle: TextStyle(fontSize: 18, color: Colors.red))),
        SizedBox(
          height: 20,
        )
      ]);
    } else if (status == 4) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Aguardando Pagamento",
            style: GoogleFonts.inter(
                textStyle: TextStyle(fontSize: 18, color: Colors.yellow))),
        SizedBox(
          height: 20,
        )
      ]);
    }
  }

  Future<String> ReturnImage(String filename) async {
    final ref = FirebaseStorage.instance.ref().child(filename);
    String url = await ref.getDownloadURL();
    return url;
  }
}
