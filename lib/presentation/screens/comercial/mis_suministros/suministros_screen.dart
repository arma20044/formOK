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
  bool _hasFetched = false; // Para controlar fetch único

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    _scrollController.addListener(() {
      setState(() {
        _showLeftArrow = _scrollController.offset > 0;
        _showRightArrow =
            _scrollController.offset <
            _scrollController.position.maxScrollExtent;
      });
    });
  }

  void fetchDatos(String token) {
    // Aquí tu lógica de fetch
    print('Fetch con token: $token');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    double newOffset = (_scrollController.offset - _scrollAmount).clamp(
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
    double newOffset = (_scrollController.offset + _scrollAmount).clamp(
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
    final List<SuministrosList?>? dropDownItemsSuministro =
        authState.value?.user?.userDatosAnexos;

    final token = authState.value?.user?.token;

    // Actualizar _token y selectedNIS solo si cambian
    if (token != null && _token != token) {
      _token = token;

      // Opcional: fetch automático la primera vez que llega token
      if (!_hasFetched) {
        _hasFetched = true;
        fetchDatos(_token!);
      }
    }

    if (dropDownItemsSuministro != null &&
        selectedNIS == null &&
        dropDownItemsSuministro.isNotEmpty) {
      selectedNIS = dropDownItemsSuministro.first;
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
                    setState(() => selectedNIS = value);
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
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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
              const FacturasTab(),
              const HistoricoTab(),
              const MensajesTab(),
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
