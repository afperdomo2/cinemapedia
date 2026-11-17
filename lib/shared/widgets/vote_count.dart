import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:flutter/material.dart';

class VoteCount extends StatelessWidget {
  final int voteCount;

  const VoteCount(this.voteCount, {super.key});

  @override
  Widget build(BuildContext context) {
    var textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(Icons.people, size: 14, color: colors.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          HumanFormatter.largeNumber(voteCount.toDouble()),
          style: textStyles.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
