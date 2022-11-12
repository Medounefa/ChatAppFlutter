import 'package:chatflutter/firebase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';

class LoginPage extends StatelessWidget {
  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Service service = Service();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Connectez-vous",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Entrez votre mail",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: "Entrez votre mot de passe",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80)),
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    service.loginUser(
                        context, emailController.text, passwordController.text);
                    pref.setString("email", emailController.text);
                  } else {
                    service.errorBox(context,
                        "Les champs ne doivent pas être vides. Veuillez fournir une adresse e-mail et un mot de passe valides.");
                  }
                },
                child: Text("Connectez"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => Register())));
                  },
                  child: Text("Je n'ai pas de compte ?"))
            ],
          ),
        ),
      ),
    );
  }
}
