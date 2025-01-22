import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_juegos/models/game.dart';

enum LayoutMode {vertical, horizontal}

class GameWidget extends StatelessWidget {
  final Game _game;
  final LayoutMode layoutMode;

  const GameWidget({super.key, required Game game, required this.layoutMode}) : _game = game;

  @override
  Widget build(BuildContext context) {
    switch (layoutMode) {
      case LayoutMode.vertical: return _buildVertical(context);
      case LayoutMode.horizontal: return _buildHorizontal(context);
    }
  }

  Widget _buildVertical(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/details", arguments: {"game": _game}),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(_game.image),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(_game.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis)
            )
          ]
        )
      )
    );
  }

  // TODO mejorar el display horizontal
  // TODO añadir botón para agregar sin entrar en details
  Widget _buildHorizontal(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/details", arguments: {"game": _game}),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.memory(_game.image),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_game.title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                        Divider(),
                        Text(_game.description, style: TextStyle(fontSize: 18), maxLines: 5, overflow: TextOverflow.ellipsis)
                      ],
                    )
                  )
                )
              ]
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.add),
            onPressed: () {
              print("Logica añadir juego");
              print("Pulsado ${_game.title}");
            }
          ),
        )
      ]
    );
  }
}