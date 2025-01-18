import 'package:flutter/material.dart';
import 'package:gestion_juegos/daos/user_dao.dart';
import 'package:gestion_juegos/models/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final int _maxNameLength = 15;
  final int _minPassLength = 8;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameCtrll = TextEditingController();
  final TextEditingController _passCtrll = TextEditingController();
  String _errorMsg = "";

  void _onRegister() {
    setState(() async {
      if (!_formkey.currentState!.validate()) return;

      if ((await UserDao.getUser(_nameCtrll.text)) != null) {
        _errorMsg = "El usuario ${_nameCtrll.text} ya está registrado";
        return;
      }

      final int id = await UserDao.insertUser(
        User(
          name: _nameCtrll.text,
          password: _passCtrll.text
        )
      );

      if (id == 0) {
        _errorMsg = "No se ha podido crear el usuario";
        return;
      }

      Navigator.pushNamed(context, "/app");
    });
  }

  void _onLogIn() async {
    if (!_formkey.currentState!.validate()) return;

    final User? user = await UserDao.getUser(_nameCtrll.text);

    setState(() {
      if (user == null) {
        _errorMsg = "El usuario ${_nameCtrll.text} no existe";
        return;
      }

      // TODO implementar encriptacion
      if (user.password != _passCtrll.text) {
        _errorMsg = "Contrasena incorrecta";
        return;
      }

      _errorMsg = "";
    });

    if (_errorMsg != "") return;

    // TODO guardar el usuario obtenido

    Navigator.pushNamed(context, "/app");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login")),
      ),
      body: Padding(
          padding: EdgeInsets.all(50),
        child: Column(
          spacing: 70,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: Column(
                spacing: 15,
                children: [
                  TextFormField(
                    decoration:  InputDecoration(
                        labelText: "Introduzca su nombre"
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Introduzca un nombre";
                      return null;
                    },
                    maxLength: _maxNameLength,
                    controller: _nameCtrll,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Introduzca su contreña"
                    ),
                    validator: (value) {
                      if (value == null || value.length < _minPassLength) return "Su contraseña debe tener al menos $_minPassLength carácteres";
                      return null;
                    },
                    obscureText: true,
                    controller: _passCtrll,
                  )
                ],
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _onRegister();
                  },
                  child: Text("Registrarme")
                ),
                ElevatedButton(
                  onPressed: () {
                    _onLogIn();
                  },
                  child: Text("Iniciar sesión")
                )
              ],
            ),
            Text(_errorMsg)
          ],
        ),
      )
    );
  }
}
