import 'package:flutter/material.dart';

class CustomLoaderButton extends StatelessWidget {
  const CustomLoaderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      width: 15,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
    );
  }
}
