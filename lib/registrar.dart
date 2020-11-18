import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_market/CustomOutlineButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registrar extends StatefulWidget {
  @override
  _RegistrarState createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController usuarioNome = TextEditingController();
  TextEditingController usuarioSobrenome = TextEditingController();
  TextEditingController usuarioCPF = TextEditingController();
  TextEditingController usuarioEmail = TextEditingController();
  TextEditingController usuarioSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 130,
                    child: Center(
                        child:
                        Column(
                          children: [
                            SizedBox(height: 45),
                            Text(
                              "Registro",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Image(image: AssetImage('assets/userIcon.png'), height: 89),
                      SizedBox(height: 10),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                child: TextFormField(
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
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
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
                              )
                            ]),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CpfInputFormatter(),
                              ],
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "CPF",
                              ),
                              controller: usuarioCPF,
                              validator: (valor) {
                                if (valor.isEmpty) {
                                  return "Informe seu CPF";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                              ),
                              controller: usuarioEmail,
                              validator: (valor) {
                                if (valor.isEmpty) {
                                  return "Informe o Email";
                                } else if (!usuarioEmail.text.contains("@")) {
                                  return "Informe um email valido";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Senha",
                              ),
                              controller: usuarioSenha,
                              validator: (valor) {
                                if (valor.isEmpty) {
                                  return "Informe a Senha";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: CustomOutlineButton(
                                text: "Registrar-se",
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    registrar();
                                    FirebaseFirestore.instance.collection("usuarios").doc(usuarioCPF.text).set(
                                        {
                                          "usuarioNome": usuarioNome.text,
                                          "usuarioSobrenome": usuarioSobrenome.text,
                                          "usuarioCEP": usuarioCPF.text,
                                          "usuarioEndereço": "",
                                        }
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }

  Future<void> registrar() async {
    try{
      UserCredential usuario = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usuarioEmail.text,
          password: usuarioSenha.text
      );
      usuario.credential;
      Navigator.pop(context);
    } catch (error) {
      Navigator.pop(context);
      SnackBar snackbar = SnackBar(
        backgroundColor: Colors.red,
        content: Text("Erro ao fazer login"),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}

