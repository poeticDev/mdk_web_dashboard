import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomCard extends StatelessWidget {
  final EdgeInsets padding;
  final double elevation;
  final double? width;
  final double? height;
  final Widget? child;

  const CustomCard({
    super.key,
    this.padding = const EdgeInsets.all(24),
    this.elevation = 4.0,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: Card(
        elevation: elevation,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
