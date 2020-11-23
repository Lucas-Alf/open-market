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
    );
  }
}
