import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon(
    this.icon, {
    super.key,
    required this.loading,
  });

  final IconData icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return loading //
        ? const Icon(Icons.refresh) //
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: const Duration(seconds: 1))
        : Icon(icon);
  }
}
