import 'package:flutter/material.dart';
import 'recetas_view_model.dart';
import 'tarjeta_receta.dart';

class RecetasPagina extends StatefulWidget {
  const RecetasPagina({super.key, required this.vm});

  final RecetasViewModel vm;

  @override
  State<RecetasPagina> createState() => _RecetasPaginaState();
}

class _RecetasPaginaState extends State<RecetasPagina> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _hacerBusqueda() {
    widget.vm.buscar(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetario UTEZ'),
      ),
      body: ListenableBuilder(
        listenable: widget.vm,
        builder: (context, _) {
          final vm = widget.vm;
          final cargando = vm.cargando;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  key: const Key('busqueda'),
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: cargando ? null : (_) => _hacerBusqueda(),
                  decoration: const InputDecoration(
                    labelText: 'Buscar recetas',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('buscar'),
                    onPressed: cargando ? null : _hacerBusqueda,
                    child: const Text('Buscar recetas'),
                  ),
                ),
                const SizedBox(height: 16),
                if (cargando) const CircularProgressIndicator(),
                Expanded(
                  child: _construirContenido(context, vm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _construirContenido(BuildContext context, RecetasViewModel vm) {
    return switch (vm.estado) {
      RecetasInicial() => const Center(
        child: Text(
          'Escribe una receta o déjalo vacío y toca Buscar recetas.',
        ),
      ),
      RecetasCargando() => const SizedBox.shrink(),
      RecetasVacias(:final busqueda) => Center(
        child: Text(
          busqueda.isEmpty
              ? 'No hay recetas disponibles.'
              : 'No encontramos recetas para "$busqueda".',
        ),
      ),
      RecetasFallidas(:final mensaje) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensaje),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: vm.reintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
      RecetasListas(:final recetas, :final total) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mostrando ${recetas.length} de $total recetas · Rápidas: ${vm.rapidas}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: recetas.length,
              itemBuilder: (context, index) {
                return TarjetaReceta(receta: recetas[index]);
              },
            ),
          ),
        ],
      ),
    };
  }
}