import 'package:flutter/material.dart';

class VoteAverage extends StatelessWidget {
  final double average;

  const VoteAverage(this.average, {super.key});

  @override
  Widget build(BuildContext context) {
    var textStyles = Theme.of(context).textTheme;

    return Row(
      children: [
        const Icon(Icons.star, size: 20, color: Colors.amber),
        const SizedBox(width: 2),
        Text(
          average.toStringAsFixed(1),
          style: textStyles.bodyMedium
              ?.copyWith(color: Colors.yellow[800], fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
