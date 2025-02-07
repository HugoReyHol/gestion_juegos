import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/providers/login_state_provider.dart';
import 'package:gestion_juegos/util/style_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends ConsumerStatefulWidget {
  Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final int _maxNameLength = 15;
  final int _minPassLength = 8;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameCtrll = TextEditingController();
  final TextEditingController _passCtrll = TextEditingController();
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginStateProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(loc.login_title)),
      ),
      body: SafeArea(
        child: Padding(
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
                      key: Key("name_field"),
                      enabled: !loginState,
                      decoration:  InputDecoration(
                        labelText: loc.login_name_field
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return loc.login_name_error;
                        return null;
                      },
                      maxLength: _maxNameLength,
                      controller: _nameCtrll,
                    ),
                    TextFormField(
                      key: Key("pass_field"),
                      enabled: !loginState,
                      decoration: InputDecoration(
                        labelText: loc.login_pass_field,
                        suffixIcon: IconButton(
                          icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          }
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.length < _minPassLength) return loc.login_pass_error(_minPassLength);
                        return null;
                      },
                      obscureText: isObscured,
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
                    onPressed: loginState ? null : () {
                      if (_formkey.currentState!.validate()) {
                        ref.read(loginStateProvider.notifier).onRegister(_nameCtrll.text, _passCtrll.text, context);
                      }
                    },
                    child: Text(loc.login_btn_reg)
                  ),
                  ElevatedButton(
                    key: Key("login_btn"),
                    onPressed: loginState ? null : () {
                      if (_formkey.currentState!.validate()) {
                        ref.read(loginStateProvider.notifier).onLogIn(_nameCtrll.text, _passCtrll.text, context);
                      }
                    },
                    child: Text(loc.login_btn_login)
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
