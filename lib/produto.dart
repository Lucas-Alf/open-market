import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Imagem:
            Container(

            ),
            SizedBox(height: 20,),
            //Preço/Compartilhar
            Container(
              padding: EdgeInsets.all(15),
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
            SizedBox(height: 20,),
            //Descrição
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Descrição",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 22) ,textAlign: TextAlign.start),
                  Text(produtoDescricao, style: TextStyle(fontSize: 19), textAlign: TextAlign.start,),
                ],
              ),
            ),
            SizedBox(height: 20,),
            //Quantidade
          ],
        ),
      ),
    );
  }
}
