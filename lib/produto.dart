import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:octo_image/octo_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_market/CustomOutlineButton.dart';
import 'package:open_market/main.dart';

class Produto extends StatefulWidget {

  final DocumentSnapshot dadosProduto;
  Produto(this.dadosProduto);

  @override
  _ProdutoState createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto> {

  String produtoCor;
  String produtoDescricao;
  String produtoImagem;
  String produtoMarca;
  String produtoNome;
  double produtoValor;
  int dropdownValue;

  @override
  void initState() {
    super.initState();
    if(widget.dadosProduto != null){
      produtoCor = widget.dadosProduto.data()["produtoCor"];
      produtoDescricao = widget.dadosProduto.data()["produtoDescricao"];
      produtoImagem = widget.dadosProduto.data()["produtoImagem"];
      produtoMarca = widget.dadosProduto.data()["produtoMarca"];
      produtoNome = widget.dadosProduto.data()["produtoNome"];
      produtoValor = widget.dadosProduto.data()["produtoPreco"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Produto"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(5, 2, 5, 0),
          child: Column(
              children: [
                //Imagem/Nome
                Container(
                  decoration: BoxDecoration(
                  color: new Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        FutureBuilder<String>(
                          future: ReturnImage(produtoImagem),
                          builder:
                              (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                  padding: EdgeInsets.all(10),
                                  height: 282,
                                  child: OctoImage(
                                    image: CachedNetworkImageProvider(snapshot.data),
                                    placeholderBuilder: OctoPlaceholder.blurHash(
                                      'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                    ),
                                    errorBuilder: OctoError.icon(color: Colors.red),
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
                                    errorBuilder: OctoError.icon(color: Colors.red),
                                    fit: BoxFit.cover,
                                    height: 89,
                                  )
                              );
                            }
                          },
                        ),
                        Container(
                            height: 55,
                            decoration: BoxDecoration(
                                color: new Color(0xffD9D9D9),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),),
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 310,
                                    padding: EdgeInsets.all(13),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(produtoNome,
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold))),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    alignment: Alignment.topRight,
                                    child: RawMaterialButton(
                                      onPressed: () {},
                                      child: Icon(Icons.favorite_border,
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
                            )
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                //Preço/Compartilhar
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("R\$ "+produtoValor.toString(),style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20) ,textAlign: TextAlign.start),
                                Text("à vista no boleto",style:TextStyle(color: Colors.green, fontSize: 18) ,textAlign: TextAlign.start),
                              ],
                            )
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 35,
                          alignment: Alignment.centerRight,
                          child: RawMaterialButton(
                            onPressed: () {},
                            child: Icon(
                              Icons.share_outlined,
                              size: 30,
                            ),
                            shape: CircleBorder(
                                side: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                //Descrição
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Descrição",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Text(produtoDescricao, style: TextStyle(fontSize: 18),),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                //Quantidade(Precisa de Melhorias!!!)
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButton<int>(
                        isExpanded: true,
                        hint:  Text("Quantidade: ",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        value: dropdownValue,

                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (int newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <int>[1, 2, 3, 4, 5]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text("Quantidade: " + value.toString(),style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  child: CustomOutlineButton(
                    text: "Comprar",
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      //Coisas acontecem!!!
                    },
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
    );
  }

  Future<String> ReturnImage(String filename) async {
    final ref = FirebaseStorage.instance.ref().child(filename);
    String url = await ref.getDownloadURL();
    return url;
  }
}
