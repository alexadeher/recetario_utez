import '../dominio/receta.dart';

Dificultad dificultadDesdeTexto(Object? valor) {
  if (valor is! String) return Dificultad.desconocida;
  return switch (valor.toLowerCase()) {
    'easy' => Dificultad.facil,
    'medium' => Dificultad.media,
    'hard' => Dificultad.dificil,
    _ => Dificultad.desconocida,
  };
}

List<String> _listaTextoOpcional(Object? valor) {
  if (valor == null) return const [];
  if (valor is! List) throw const FormatException();
  final resultado = <String>[];
  for (final elemento in valor) {
    if (elemento is! String) throw const FormatException();
    resultado.add(elemento);
  }
  return resultado;
}

Receta recetaDesdeJson(Map<String, dynamic> json) {
  try {
    final id = json['id'];
    final name = json['name'];
    final cuisine = json['cuisine'];
    final prepTime = json['prepTimeMinutes'];
    final cookTime = json['cookTimeMinutes'];
    final servings = json['servings'];
    final rating = json['rating'];

    if (id is! int ||
        name is! String ||
        cuisine is! String ||
        prepTime is! int ||
        cookTime is! int ||
        servings is! int ||
        rating is! num) {
      throw const FormatException();
    }

    final dificultad = dificultadDesdeTexto(json['difficulty']);
    final tags = _listaTextoOpcional(json['tags']);
    final ingredients = _listaTextoOpcional(json['ingredients']);

    return Receta(
      id: id,
      nombre: name,
      cocina: cuisine,
      dificultad: dificultad,
      minutosPreparacion: prepTime,
      minutosCoccion: cookTime,
      porciones: servings,
      calificacion: rating.toDouble(),
      etiquetas: tags,
      ingredientes: ingredients,
    );
  } catch (e) {
    if (e is FormatException) rethrow;
    throw const FormatException();
  }
}

PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  final recipesRaw = json['recipes'];
  final totalRaw = json['total'];

  if (recipesRaw is! List || totalRaw is! int) {
    throw const FormatException();
  }

  final recetas = <Receta>[];
  for (final item in recipesRaw) {
    if (item is! Map<String, dynamic>) {
      throw const FormatException();
    }
    recetas.add(recetaDesdeJson(item));
  }

  return PaginaRecetas(
    recetas: recetas,
    total: totalRaw,
  );
}