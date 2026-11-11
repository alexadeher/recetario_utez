import 'package:flutter/material.dart';
import '../dominio/receta.dart';

class TarjetaReceta extends StatelessWidget {
  const TarjetaReceta({super.key, required this.receta});

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    final subtitulo = '${receta.cocina} · ${receta.dificultad.etiqueta}';
    final datos = 'Tiempo: ${receta.tiempoTotal} min · Porciones: ${receta.porciones}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    receta.nombre,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (receta.esRapida)
                  const Chip(
                    label: Text('Rápida'),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitulo, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              'Tiempo: ${receta.tiempoTotal} min ',
            ),
            Text(datos),
            const SizedBox(height: 4),
            Text(
              'Calificación: ${receta.calificacion.toStringAsFixed(1)}',
            ),
          ],
        ),
      ),
    );
  }
}