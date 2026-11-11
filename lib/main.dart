import 'package:flutter/material.dart';
import 'app.dart';
import 'datos/cliente_http.dart';
import 'datos/dummyjson_repositorio.dart';

void main() {
  final dio = crearDioRecetas();
  final repositorio = DummyJsonRepositorio(dio);
  runApp(AppRecetario(repositorio: repositorio));
}