import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';

class CustomProductWidget extends StatelessWidget {
  final String id;
  final String descricao;
  final double valor;
  final String imageURL;
  final bool favorito;
  final VoidCallback onPressed;

  const CustomProductWidget(
      {Key key,
      this.id,
      this.descricao,
      this.valor,
      this.favorito,
      this.onPressed,
      this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = new NumberFormat("#,##0.00", "pt_BR");
    return new GestureDetector(
        onTap: this.onPressed,
        child: Container(
          height: 358,
          decoration: BoxDecoration(
            color: new Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    height: 282,
                    child: OctoImage(
                      image: CachedNetworkImageProvider(
                          ReturnImage(this.imageURL)),
                      placeholderBuilder: OctoPlaceholder.blurHash(
                        'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                      ),
                      errorBuilder: OctoError.icon(color: Colors.red),
                      fit: BoxFit.cover,
                      height: 89,
                    )),
                Container(
                    height: 76,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: Offset(
                              0.0, // Move to right 10  horizontally
                              1.0, // Move to bottom 5 Vertically
                            ),
                          )
                        ]),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 310,
                            padding: EdgeInsets.all(13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(this.descricao,
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                SizedBox(height: 5),
                                Text("R\$ " + numberFormat.format(this.valor),
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.topRight,
                            child: RawMaterialButton(
                              onPressed: () {},
                              child: Icon(
                                this.favorito
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 24,
                              ),
                              shape: CircleBorder(
                                  side: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              )),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }

  String ReturnImage(String filename) {
    // final ref = FirebaseStorage.instance.ref().child(filename);
    // var url = "";
    // ref.getDownloadURL().then((value) => {url = value});
    // return url;
    return 'https://blurha.sh/assets/images/img1.jpg';
  }
}
