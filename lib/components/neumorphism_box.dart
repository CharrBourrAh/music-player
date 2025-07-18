import 'package:flutter/material.dart';

class NeumorphismBox extends StatelessWidget {
  final Widget? child;
  const NeumorphismBox({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          offset: const Offset(4, 4),
          blurRadius: 10,
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          offset: const Offset(-4, -4),
          blurRadius: 10,
        ),
      ],
    ),
    padding: EdgeInsets.all(12),
    child: child,
    );
  }
}
