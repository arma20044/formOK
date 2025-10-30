import 'package:flutter/material.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/configuracion_tab.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/facturas_tab.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/historico_tab.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/lectura_tab.dart';
import 'package:form/presentation/screens/comercial/mis_suministros/tabs/mensajes_tab.dart';

class SuministrosScreen extends StatefulWidget {
  const SuministrosScreen({super.key});

  @override
  State<SuministrosScreen> createState() => _SuministrosScreenState();
}

class _SuministrosScreenState extends State<SuministrosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final List<String> tabs = [
    "Facturas",
    "Histórico",
    "Mensajes",
    "Ingrese Lectura del Mes",
    "Configuración",
  ];

  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  final double _scrollAmount = 100; // Cantidad de scroll al tocar flecha

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    _scrollController.addListener(() {
      setState(() {
        _showLeftArrow = _scrollController.offset > 0;
        _showRightArrow =
            _scrollController.offset < _scrollController.position.maxScrollExtent;
      });
    });
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
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text("Mis Suministros"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  labelStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontSize: 12),
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
              // Flecha izquierda
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
              // Flecha derecha
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
                        //borderRadius: BorderRadius.horizontal(),
                        //borderRadius: BorderRadiusDirectional.circular(10),
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
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              FacturasTab(),
              HistoricoTab(),
              MensajesTab(),
              LecturaTab(),
              ConfiguracionTab(),
            ],
          ),
        ),
      ),
    );
  }
}
