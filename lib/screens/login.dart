import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/user_provider.dart';

class Login extends ConsumerWidget {
  final int _maxNameLength = 15;
  final int _minPassLength = 8;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameCtrll = TextEditingController();
  final TextEditingController _passCtrll = TextEditingController();
  String _errorMsg = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProv = ref.watch(userProvider);
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
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _errorMsg = await ref.watch(userProvider.notifier).onRegister(_nameCtrll.text, _passCtrll.text);
                    }

                    if (_errorMsg == "") {
                      Navigator.pushNamed(context, "/app");
                    }
                  },
                  child: Text("Registrarme")
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _errorMsg = await ref.watch(userProvider.notifier).onLogIn(_nameCtrll.text, _passCtrll.text);
                    }

                    if (_errorMsg == "") {
                      Navigator.pushNamed(context, "/app");
                    }
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

// class Login extends StatefulWidget {
//   const Login({super.key});
//
//   @override
//   State<Login> createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   final int _maxNameLength = 15;
//   final int _minPassLength = 8;
//   final _formkey = GlobalKey<FormState>();
//   final TextEditingController _nameCtrll = TextEditingController();
//   final TextEditingController _passCtrll = TextEditingController();
//   String _errorMsg = "";
//
//   Future<void> _onRegister() async {
//     if (!_formkey.currentState!.validate()) return;
//
//     User? user = await UserDao.getUser(_nameCtrll.text);
//
//     if (user != null) {
//       setState(() {
//         _errorMsg = "El usuario ${_nameCtrll.text} ya está registrado";
//       });
//       return;
//     }
//
//     user = User(
//         name: _nameCtrll.text,
//         password: _passCtrll.text // TODO implementar encriptacion
//     );
//
//     user.idUser = await UserDao.insertUser(user);
//
//     if (user.idUser == 0) {
//       setState(() {
//         _errorMsg = "No se ha podido crear el usuario";
//       });
//       return;
//     }
//
//     UserDao.user = user;
//
//     Navigator.pushNamed(context, "/app");
//   }
//
//   void _onLogIn() async {
//     if (!_formkey.currentState!.validate()) return;
//
//     final User? user = await UserDao.getUser(_nameCtrll.text);
//
//     if (user == null) {
//       setState(() {
//         _errorMsg = "El usuario ${_nameCtrll.text} no existe";
//       });
//       return;
//     }
//
//     // TODO implementar encriptacion
//     if (user.password != _passCtrll.text) {
//       setState(() {
//         _errorMsg = "Contraseña incorrecta";
//       });
//       return;
//     }
//
//     UserDao.user = user;
//
//     Navigator.pushNamed(context, "/app");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text("Login")),
//       ),
//       body: Padding(
//           padding: EdgeInsets.all(50),
//         child: Column(
//           spacing: 70,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Form(
//               key: _formkey,
//               child: Column(
//                 spacing: 15,
//                 children: [
//                   TextFormField(
//                     decoration:  InputDecoration(
//                         labelText: "Introduzca su nombre"
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return "Introduzca un nombre";
//                       return null;
//                     },
//                     maxLength: _maxNameLength,
//                     controller: _nameCtrll,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: "Introduzca su contreña"
//                     ),
//                     validator: (value) {
//                       if (value == null || value.length < _minPassLength) return "Su contraseña debe tener al menos $_minPassLength carácteres";
//                       return null;
//                     },
//                     obscureText: true,
//                     controller: _passCtrll,
//                   )
//                 ],
//               )
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               spacing: 20,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     _onRegister();
//                   },
//                   child: Text("Registrarme")
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _onLogIn();
//                   },
//                   child: Text("Iniciar sesión")
//                 )
//               ],
//             ),
//             Text(_errorMsg)
//           ],
//         ),
//       )
//     );
//   }
// }
