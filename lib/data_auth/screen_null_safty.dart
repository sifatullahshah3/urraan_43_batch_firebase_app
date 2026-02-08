import 'package:flutter/material.dart';

class ScreenNullSafty extends StatefulWidget {
  const ScreenNullSafty({super.key});

  @override
  State<ScreenNullSafty> createState() => _ScreenNullSaftyState();
}

class _ScreenNullSaftyState extends State<ScreenNullSafty> {
  String? name;

  @override
  void initState() {
    super.initState();

    // name = "Sifat";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name != null ? name! : "Sifat")),
    );
  }
}
