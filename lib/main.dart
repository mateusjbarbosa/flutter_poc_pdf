import 'package:flutter/material.dart';
import 'package:poc_pdf/home_page.dart';

void main() {
  runApp(const PoCPDF());
}

class PoCPDF extends StatelessWidget {
  const PoCPDF({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PoC PDF',
      home: HomePage(),
    );
  }
}
