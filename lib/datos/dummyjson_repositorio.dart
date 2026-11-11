import 'package:dio/dio.dart';
import 'package:recetario_utez/datos/recetas_json.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/datos/traducir_error.dart';

import '../dominio/falla_red.dart';
import '../dominio/receta.dart';

const recetasPorPagina = 10;
class DummyJsonRepositorio implements RecetasRepositorio {
  DummyJsonRepositorio(this._dio);

  final Dio _dio;

  @override
  Future<PaginaRecetas> buscar({String texto = ''}) async {
    final limpio = texto.trim();
    try {
      final respuesta = await _dio.get<Object?>(
        limpio.isEmpty ? '/recipes' : '/recipes/search',
        queryParameters: {
          if(limpio.isNotEmpty) 'q': limpio,
          'limit': recetasPorPagina,
        },
      );

      final datos = respuesta.data;
      if(datos is! Map<String, dynamic>) throw const RespuestaInvalida();
      return paginaDesdeJson(datos);
    } on DioException catch (e) {
      throw traducirError(e);
    } on FormatException {
      throw const RespuestaInvalida();
    }
  }
}