import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:open_market/CustomOutlineButton.dart';
import 'package:open_market/home.dart';
import 'package:uuid/uuid.dart';

class ProdutoIncluir extends StatefulWidget {
  @override
  _ProdutoIncluirState createState() => _ProdutoIncluirState();
}

class _ProdutoIncluirState extends State<ProdutoIncluir> {

  File _image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController produtoInfoAdicional = new TextEditingController();
  TextEditingController produtoDescricao = new TextEditingController();
  TextEditingController produtoMarca = new TextEditingController();
  TextEditingController produtoNome = new TextEditingController();
  TextEditingController produtoPreco = new TextEditingController();
  String produtoCategoria;

  final List<String> categorias = [
    "Escritorio",
    "Moda",
    "Smartphone",
    "Moto",
    "Carro",
    "Console",
    "Jogos"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Incluir Produto'),
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
                  )))
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Produto Imagem:',style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                    CustomOutlineButton(
                      text: 'Escolher Imagem',
                      onPressed: chooseFile,
                      color: Colors.cyan,
                    )
                  ],
                )
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: _image != null
                    ?  Image.asset(
                    _image.path, height: 175,
                    )
                    : Container(height: 175,)
              )
            ]),
            SizedBox(height: 20,),
            DropdownButton<String>(
              isExpanded: true,
                hint:  Text("Categoria",style:TextStyle( fontSize: 16)),
              value: produtoCategoria,

              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  produtoCategoria = newValue;
                });
              },
              items: categorias
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style:TextStyle( fontSize: 16)),
                );
              }).toList(),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Nome",
                    ),
                    controller: produtoNome,
                    validator: (valor) {
                      if (valor.isEmpty) {
                        return "Informe o Nome do produto";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                    ),
                    controller: produtoDescricao,
                    validator: (valor) {
                      if (valor.isEmpty) {
                        return "Informe a Descrição do produto";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Marca",
                    ),
                    controller: produtoMarca,
                    validator: (valor) {
                      if (valor.isEmpty) {
                        return "Informe a Marca do produto";
                      } else {
                        return null;
                      }
                    },
                  ),
                   TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Preço",
                    ),
                    controller: produtoPreco,
                    validator: (valor) {
                      if (valor.isEmpty) {
                        return "Informe o Preço do produto";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Informações Adicionais",
                    ),
                    controller: produtoInfoAdicional,
                    validator: (valor) {
                      if (valor.isEmpty) {
                        return "Informe pontos adicionais";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: CustomOutlineButton(
                      text: "ADICIONAR",
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          /*_image != null
                              ? RaisedButton(
                                child: Text('Upload File'),
                                onPressed: uploadFile,
                                color: Colors.cyan,
                                )
                                : Container(),*/
                          uploadFile();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker().getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image =  File(image.path);
      });
    });
  }

  Future uploadFile() async {
    var uuid = Uuid().v4();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('produtos/${uuid}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    FirebaseFirestore.instance.collection("produtos").add(
        {
          "produtoCategoria" : produtoCategoria,
          "produtoAuxiliar" : produtoInfoAdicional.text,
          "produtoDescricao" : produtoDescricao.text,
          "produtoImagem" : "produtos/${uuid}",
          "produtoMarca" : produtoMarca.text,
          "produtoNome" : produtoNome.text,
          "produtoPreco" : double.parse(produtoPreco.text.replaceAll(",", ".")),
        }
    );
    setState(() {
      produtoInfoAdicional.text = "";
      produtoPreco.text = "";
      produtoNome.text = "";
      produtoMarca.text = "";
      produtoDescricao.text = "";
    });
    SnackBar snackbar = SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Operação realizada com sucesso"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
    //await uploadTask.onComplete;
    /*print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });*/
  }
}