import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octo_image/octo_image.dart';
import 'package:open_market/CustomOutlineButton.dart';
import 'package:open_market/home.dart';
import 'package:open_market/contaSenha.dart';

class Conta extends StatefulWidget {
  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usuarioCEP = new TextEditingController();
  TextEditingController usuarioCPF = new TextEditingController();
  TextEditingController usuarioNome = new TextEditingController();
  TextEditingController usuarioSobrenome = new TextEditingController();
  TextEditingController usuarioEndereco = new TextEditingController();
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.uid)
        .get()
        .then((value) {
      setState(() {
        usuarioNome.text = value.data()["usuarioNome"];
        usuarioSobrenome.text = value.data()["usuarioSobrenome"];
        usuarioCEP.text = value.data()["usuarioCEP"];
        usuarioCPF.text = value.data()["usuarioCPF"];
        usuarioEndereco.text = value.data()["usuarioEndereco"];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Minha Conta"),
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
        key: scaffoldKey,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: new Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      FutureBuilder<String>(
                        future: ReturnImage(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            //Add way to upload a photo
                            return Container(
                                padding: EdgeInsets.all(10),
                                height: 100,
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
                            return Column(
                              children: [
                                SizedBox(height: 25),
                                Image(
                                    image: AssetImage('assets/userIcon.png'),
                                    height: 89)
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
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
                        controller: usuarioNome,
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return "Informe seu Nome";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Sobrenome",
                        ),
                        controller: usuarioSobrenome,
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return "Informe seu Sobrenome";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CepInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "CEP",
                        ),
                        controller: usuarioCEP,
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return "Informe o CEP de sua localização";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Endereço",
                        ),
                        controller: usuarioEndereco,
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return "Informe seu Endereço";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomOutlineButton(
                          text: "SALVAR",
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              FirebaseFirestore.instance
                                  .collection("usuarios")
                                  .doc(user.uid)
                                  .update({
                                "usuarioCPF": usuarioCPF.text,
                                "usuarioNome": usuarioNome.text,
                                "usuarioSobrenome": usuarioSobrenome.text,
                                "usuarioCEP": usuarioCEP.text,
                                "usuarioEndereço": usuarioEndereco.text,
                              });
                            }
                            SnackBar snackbar = SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text("Operação realizada com sucesso"),
                            );
                            scaffoldKey.currentState.showSnackBar(snackbar);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomOutlineButton(
                          text: "TROCAR SENHA",
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContaSenha()));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomOutlineButton(
                          text: "EXCLUIR CONTA",
                          color: Colors.red,
                          onPressed: () {
                            //Confirmar com o usuário
                            confirmaExclusao();
                          },
                        ),
                      ),
                    ],
                  ))
            ])));
  }

  Future<String> ReturnImage() async {
    final ref =
        FirebaseStorage.instance.ref().child("imagensUsers/" + user.uid);
    String url = await ref.getDownloadURL();
    return url;
  }

  confirmaExclusao() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Atenção!"),
            content: Text(
                "Você deseja realmente EXCLUIR sua conta?\nEsta operação não pode ser revertida"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    user.delete();
                    FirebaseFirestore.instance
                        .collection("usuarios")
                        .doc(user.uid)
                        .delete();
                    Navigator.of(context).pop();
                  },
                  child: Text("Confirmar"))
            ],
          );
        });
  }
}
