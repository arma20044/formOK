import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/model/login_model.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/configuracion_tab.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/facturas_tab.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/historico_tab.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/lectura_tab.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/mensajes_tab.dart';

import 'package:form/provider/suministro_provider.dart';

class SuministrosScreen extends ConsumerStatefulWidget {
  const SuministrosScreen({super.key});

  @override
  ConsumerState<SuministrosScreen> createState() => _SuministrosScreenState();
}

class _SuministrosScreenState extends ConsumerState<SuministrosScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> configuracionKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  late TabController _tabController;

  final List<String> tabs = [
    "Facturas",
    "Histórico",
    "Mensajes",
    "Ingrese Lectura del Mes",
    "Configuración",
  ];

  bool _showLeftArrow = false;
  bool _showRightArrow = true;
  final double _scrollAmount = 100;

  SuministrosList? selectedNIS;
  String? _token;
  bool? _indicador;
  bool _hasFetched = false; // Para controlar fetch único

  bool _isListenerSet = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);
  }

  void fetchDatos(String token) {
    print('🚀 Fetch con token: $token');
    //print('🔐 Indicador de bloqueo: $indicador');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    final newOffset = (_scrollController.offset - _scrollAmount).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    final newOffset = (_scrollController.offset + _scrollAmount).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 🧩 Esperar a que el provider tenga valor
    if (authState.value == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ✅ Ahora es seguro acceder a los valores
    final List<SuministrosList?>? dropDownItemsSuministro =
        authState.value!.user?.userDatosAnexos;

    // Registrar listener solo una vez
    if (!_isListenerSet) {
      _isListenerSet = true;
      ref.listen(authProvider, (previous, next) {
        final nuevoIndicador = next.value?.indicadorBloqueoNIS;
        print('🔄 indicadorBloqueoNIS cambió: $nuevoIndicador');
      });
    }

    final token = authState.value!.user?.token;

    // Actualizar token e indicador si cambian
    if (token != null && _token != token) {
      _token = token;

      if (!_hasFetched) {
        _hasFetched = true;
        fetchDatos(_token!);
      }
    }

    if (dropDownItemsSuministro != null &&
        selectedNIS == null &&
        dropDownItemsSuministro.isNotEmpty) {
      // Selecciona el primer NIS
      selectedNIS = dropDownItemsSuministro.first;

      // Calcula indicador si querés
      final indicador = selectedNIS!.indicadorBloqueoWeb == 1 ? true : false;
      print('📊 indicador actual: $indicador');

      // 🔹 Posponer actualización del provider
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedNISProvider.notifier).set(selectedNIS);
      });
    }

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Mis Suministros"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Suministro Seleccionado:'),
                const SizedBox(height: 4),
                DropdownButtonFormField<SuministrosList>(
                  value: selectedNIS,
                  hint: const Text("Seleccionar NIS"),
                  items: (dropDownItemsSuministro ?? [])
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text('NIS: ${item?.nisRad ?? ""}'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() => selectedNIS = value);

                    // 🔥 Actualizamos el provider global
                    ref.read(selectedNISProvider.notifier).set(value);

                    // (opcional) mover al primer tab
                    _tabController.animateTo(0);
                  },

                  validator: (value) =>
                      value == null ? 'Seleccione un NIS' : null,
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : Colors.black, // Tab seleccionado
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey[90]
                              : Colors.white, // Tab no seleccionado
                        ),
                        tabs: tabs
                            .map(
                              (t) => Tab(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(t),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    if (_showLeftArrow)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _scrollLeft,
                          child: Container(
                            width: 20,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.8),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    if (_showRightArrow)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _scrollRight,
                          child: Container(
                            width: 20,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.8),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              FacturasTab( selectedNIS!,  _token),
              const HistoricoTab(),
              MensajesTab(selectedNIS),
              const LecturaTab(),
              if (selectedNIS != null && _token != null)
                ConfiguracionTab(key: configuracionKey, selectedNIS!, _token!)
              else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
