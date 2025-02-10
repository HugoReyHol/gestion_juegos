import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_juegos/services/user_service.dart';
import 'package:gestion_juegos/models/user.dart';
import 'package:gestion_juegos/providers/user_provider.dart';
import 'package:gestion_juegos/util/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Notifier del estado de inicio de sesión
///
/// Representa si login está realizando alguna función de inicio o de registro
/// Por defecto es `false`
/// Contiene métodos para iniciar sesión y registrar un usuario
class LoginStateNotifier extends AutoDisposeNotifier<bool> {
  @override
  bool build() => false;

  /// Inicia sesión en la app
  Future<void> onLogIn(String name, String password, BuildContext context) async {
    state = true;
    final loc = AppLocalizations.of(context)!;

    final User? user;

    try {
      user = await UserService.getUser(name, password.encrypt());
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text(loc.log_prv_wrg_pass)))
        );
      }
      state = false;
      return;
    }

    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text(loc.log_prv_no_user(name))))
        );
      }
      state = false;
      return;
    }

    ref.read(userProvider.notifier).state = user;
    ref.read(userProvider.notifier).saveUser();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, "/app");
    }
  }

  /// Registra a un usuario e inicia sesión como él
  Future<void> onRegister(String name, String password, BuildContext context) async {
    state = true;
    final loc = AppLocalizations.of(context)!;

    final User user;

    try {
      user = await UserService.insertUser(
        User(
          username: name,
          password: password.encrypt()
        )
      );
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text(loc.log_prv_user_exst(name))))
        );
      }
      state = false;
      return;
    }

    if (user.idUser == 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text(loc.log_prv_err_user)))
        );
      }
      state = false;
      return;
    }

    ref.read(userProvider.notifier).state = user;
    ref.read(userProvider.notifier).saveUser();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, "/app");
    }
  }
}

/// Provider del estado de login
final loginStateProvider = AutoDisposeNotifierProvider<LoginStateNotifier, bool>(() => LoginStateNotifier());