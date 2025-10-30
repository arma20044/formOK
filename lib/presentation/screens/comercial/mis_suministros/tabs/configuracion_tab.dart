import 'package:flutter/material.dart';

import '../../../../components/common.dart';

class ConfiguracionTab extends StatefulWidget {
  const ConfiguracionTab({super.key});

  @override
  State<ConfiguracionTab> createState() => _ConfiguracionTabState();
}

class _ConfiguracionTabState extends State<ConfiguracionTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool _isSwitched = false; // Initial state of the switch

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Get the full screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText("Bloquear Suministro", fontWeight: FontWeight.bold),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // 👈 centra verticalmente
              children: [
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.visible,
                    
                    "Con el bloqueo del suministro no se podrán consultar ni descargar las facturas desde el acceso público en la Página Web ni desde la APP de la ANDE",
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Switch(
                  value: _isSwitched,
                  onChanged: (newValue) {
                    setState(() {
                      _isSwitched = newValue;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
