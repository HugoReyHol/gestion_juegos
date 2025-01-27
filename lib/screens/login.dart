import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/login_state_provider.dart';
import 'package:gestion_juegos/util/style_constants.dart';

class Login extends ConsumerWidget {
  Login({super.key});

  final int _maxNameLength = 15;
  final int _minPassLength = 8;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameCtrll = TextEditingController();
  final TextEditingController _passCtrll = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login")),
      ),
      body: Padding(
        padding: EdgeInsets.all(normalMargin),
        child: Column(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
              child: Column(
                spacing: 15,
                children: [
                  TextFormField(
                    enabled: !loginState,
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
                    enabled: !loginState,
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
                  onPressed: loginState ? null :
                    () {
                      if (_formkey.currentState!.validate()) {
                        ref.read(loginStateProvider.notifier).onRegister(_nameCtrll.text, _passCtrll.text, context);
                      }
                    },
                  child: Text("Registrarme")
                ),
                ElevatedButton(
                  onPressed: loginState ? null :
                    () {
                      if (_formkey.currentState!.validate()) {
                        ref.read(loginStateProvider.notifier).onLogIn(_nameCtrll.text, _passCtrll.text, context);
                      }
                    },
                  child: Text("Iniciar sesión")
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
