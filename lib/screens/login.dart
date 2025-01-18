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

  Future<void> _onRegister() async {
    if (!_formkey.currentState!.validate()) return;

    User? user = await UserDao.getUser(_nameCtrll.text);

    if (user != null) {
      setState(() {
        _errorMsg = "El usuario ${_nameCtrll.text} ya está registrado";
      });
      return;
    }

    user = User(
        name: _nameCtrll.text,
        password: _passCtrll.text // TODO implementar encriptacion
    );

    user.idUser = await UserDao.insertUser(user);

    if (user.idUser == 0) {
      setState(() {
        _errorMsg = "No se ha podido crear el usuario";
      });
      return;
    }

    Navigator.pushNamed(context, "/app", arguments: user);
  }

  void _onLogIn() async {
    if (!_formkey.currentState!.validate()) return;

    final User? user = await UserDao.getUser(_nameCtrll.text);

    if (user == null) {
      setState(() {
        _errorMsg = "El usuario ${_nameCtrll.text} no existe";
      });
      return;
    }

    // TODO implementar encriptacion
    if (user.password != _passCtrll.text) {
      setState(() {
        _errorMsg = "Contraseña incorrecta";
      });
      return;
    }

    Navigator.pushNamed(context, "/app", arguments: user);
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
