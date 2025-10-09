import 'package:flutter/material.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/enviromens/enrivoment.dart';

     
    //Environment.HOST_SITIO_ANDE + "/expedientes/";




class ExpedienteScreen extends StatefulWidget {
  //final String? url;
  
  const ExpedienteScreen({super.key});

  @override
  State<ExpedienteScreen> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<ExpedienteScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
String url = '${Environment.hostSitioAnde}/expedientes/';
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(url),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
