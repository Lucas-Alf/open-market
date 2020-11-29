import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_market/CustomOutlineButton.dart';
import 'package:open_market/esqueci.dart';
import 'package:open_market/globals.dart';
import 'registrar.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Open Market',
    theme: ThemeData.from(
      colorScheme: ColorScheme.light(),
    ).copyWith(
      primaryColor: new Color(0xff305097),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: new Color(0xff305097),
        ),
      ),
    ),
    home: Main(),
  ));
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
                        "Open Market",
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
                          controller: emailController,
                          validator: (valor) {
                            if (valor.isEmpty) {
                              return "Informe o Email";
                            } else if (!emailController.text.contains("@")) {
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
                          controller: senhaController,
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
                            text: "Entrar",
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                logar();
                              }
                            },
                          ),
                        ),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  textColor: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => Registrar()));
                                  },
                                  child: Text("Registrar-se agora")),
                              FlatButton(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  textColor: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => Esqueci()));
                                  },
                                  child: Text("Esqueci a senha")),
                            ]),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )));
  }

  Future<void> logar() async {
    loading();
    try {
      UserCredential usuario = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text.replaceAll("\t", ""), password: senhaController.text.replaceAll("\t", ""));
      globals.userId = usuario.user.uid;
      Navigator.pop(context); //fecha o loading
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (a) {
      Navigator.pop(context); //fecha o loading
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text("Erro ao fazer o Login"),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0),
          child: new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            padding: EdgeInsets.all(10),
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  width: 30,
                ),
                new Text(" Verificando ..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
