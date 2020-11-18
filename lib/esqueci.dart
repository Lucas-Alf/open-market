import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_market/CustomOutlineButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Esqueci extends StatefulWidget {
  @override
  _EsqueciState createState() => _EsqueciState();
}

class _EsqueciState extends State<Esqueci> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController usuarioEmail = TextEditingController();

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
                              "Resgatar Senha",
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
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: CustomOutlineButton(
                                text: "Resgatar",
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    resgatar();
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

  Future<void> resgatar() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: usuarioEmail.text);
      Navigator.pop(context);
    } catch (error){
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text("Erro ao tentar resgatar a Senha"),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}
