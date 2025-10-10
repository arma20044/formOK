import 'package:flutter/material.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'registro.dart';

class RegistroMiCuentaScreen extends StatefulWidget {
  const RegistroMiCuentaScreen({super.key});

  @override
  State<RegistroMiCuentaScreen> createState() => _RegistroMiCuentaScreenState();
}

class _RegistroMiCuentaScreenState extends State<RegistroMiCuentaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoadingReclamo = false;

  /// Un formKey por cada paso
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    4,
    (_) => GlobalKey<FormState>(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _formKeys.length, vsync: this);
    // Listener para actualizar la UI cuando cambia el tab
    _tabController.addListener(() {
      // Solo cuando terminó la animación y no está en el medio de un swipe
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Validar el formulario del paso actual
  bool _validateCurrentStep() {
    final currentForm = _formKeys[_tabController.index].currentState;
    return currentForm?.validate() ?? false;
  }

  /// Ir al siguiente paso
  void _nextTab() {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete los campos obligatorios")),
      );
      return;
    }

    if (_tabController.index < _tabController.length - 1) {
      setState(() {
        _tabController.index += 1;
      });
    }
  }

  /// Volver al paso anterior
  void _previousTab() {
    if (_tabController.index > 0) {
      setState(() {
        _tabController.index -= 1;
      });
    }
  }

  /// Enviar formulario completo
  Future<void> _enviarFormulario() async {
    if (_isLoadingReclamo) return;

    // Validar todos los pasos
    for (final key in _formKeys) {
      final isValid = key.currentState?.validate() ?? false;
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Complete todos los campos obligatorios"),
          ),
        );
        return;
      }
    }

    setState(() => _isLoadingReclamo = true);

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Formulario enviado correctamente")),
      );
    } finally {
      setState(() => _isLoadingReclamo = false);
    }
  }

  Future<bool> _validarTabActual() async {
    // 🔹 ejemplo simple
    // si querés validar un Form: if (_formKey.currentState!.validate()) return true;
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastTab = _tabController.index == _tabController.length - 1;

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: RegistroAppBar(
        controller: _tabController,
        onNextTab: _nextTab,
        onPreviousTab: _previousTab,
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// Indicador de progreso
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LinearProgressIndicator(
                value: (_tabController.index + 1) / _tabController.length,
                backgroundColor: Colors.grey[300],
                color: Theme.of(context).colorScheme.primary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            /// Contenido de cada paso (cada uno con su propio Form)
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Paso1Tab(formKey: _formKeys[0]),
                  Paso2Tab(formKey: _formKeys[1]),
                  Paso3Tab(formKey: _formKeys[2]),
                  Paso4Tab(formKey: _formKeys[3]),
                ],
              ),
            ),
          ],
        ),
      ),

      /// Botones inferiores
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (_tabController.index > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoadingReclamo ? null : _previousTab,
                    child: _isLoadingReclamo
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Anterior'),
                  ),
                ),
              if (_tabController.index > 0) const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoadingReclamo
                      ? null
                      : isLastTab
                      ? _enviarFormulario
                      : _nextTab,
                  child: _isLoadingReclamo
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isLastTab ? 'Enviar' : 'Siguiente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
