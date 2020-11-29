import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:open_market/CustomOutlineButton.dart';

class ContaSenha extends StatefulWidget {
  @override
  _ContaSenhaState createState() => _ContaSenhaState();
}

class _ContaSenhaState extends State<ContaSenha> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  User user = FirebaseAuth.instance.currentUser;

  TextEditingController senhaAntiga = new TextEditingController();
  TextEditingController senhaNova= new TextEditingController();
  TextEditingController confirmaNova = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Trocar Senha"),
        ),
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
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha Atual",
                        ),
                        controller: senhaAntiga,
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return "Informe sua Senha Atual";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Nova Senha",
                        ),
                        controller: senhaNova,
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return "Informe a Nova Senha";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirmar Senha Nova",
                        ),
                        controller: confirmaNova,
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return "Informe novamente a Senha desejada";
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
                            if (formKey.currentState.validate() && (senhaNova.text == confirmaNova.text)) {
                              user.reauthenticateWithCredential(EmailAuthProvider
                                  .credential(email: user.email, password: senhaAntiga.text)).then((value) => user.updatePassword(senhaNova.text));
                            }
                            SnackBar snackbar = SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text("Operação realizada com sucesso"),
                            );
                            scaffoldKey.currentState.showSnackBar(snackbar);
                          },
                        ),
                      ),
                    ],
                  ))
            ])));
  }

  Future<String> ReturnImage() async {
    final ref = FirebaseStorage.instance.ref().child("imagensUsers/" + user.uid);
    String url = await ref.getDownloadURL();
    return url;
  }
}
