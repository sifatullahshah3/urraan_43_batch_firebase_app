import 'package:flutter/material.dart';

class ScreenGuest extends StatefulWidget {
  const ScreenGuest({super.key});

  @override
  State<ScreenGuest> createState() => _ScreenGuestState();
}

class _ScreenGuestState extends State<ScreenGuest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Guest Screen")));
  }
}
