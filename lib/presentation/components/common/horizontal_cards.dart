
// Componente horizontal tipo PageView
import 'package:flutter/material.dart';
import 'package:form/presentation/components/common/card_item_first.dart';


class HorizontalCards extends StatelessWidget {
  final List<String> titles;

  const HorizontalCards({super.key, required this.titles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: CardItemFirst(
                onSecondaryPressed: () {
                  
                },
                onPrimaryPressed: () {
              
                  
                },
                totalConComision: "63333",
                fechaVencimiento: "15/11/2025",
                consumo: "222",
                lectura: "20202",
                fechaLectura: "01/10/2025",
                monto: '10000',
                title: titles[index],
                width: double.infinity,
                height: 200,
                //color: Colors.orangeAccent,
              ),
            ),
          );
        },
      ),
    );
  }
}