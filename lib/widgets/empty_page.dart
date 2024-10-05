import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final IconData icon;
  final String label;
  const EmptyPage({
    super.key, required this.icon, this.label = "",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black38, size: 75,),
          const SizedBox(width: double.infinity, height: 20,),
          Text(label)
        ]
      ),
    );
  }
}