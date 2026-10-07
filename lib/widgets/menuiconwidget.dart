import 'package:flutter/material.dart';

class MenuiconWIdget extends StatelessWidget {
  const MenuiconWIdget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Center(
        child: Image.asset("assets/icons/drawericon.png", height: 22),
      ),
    );
  }
}
