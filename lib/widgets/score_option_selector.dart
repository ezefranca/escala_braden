import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScoreOptionSelector extends StatelessWidget {
  final List<String> descriptions;
  final int? value;
  final ValueChanged<int> onChanged;

  const ScoreOptionSelector({
    super.key,
    required this.descriptions,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final isIOS = !isWeb && Platform.isIOS;
    if (isIOS) {
      return Column(
        children: List.generate(descriptions.length, (i) {
          final idx = i + 1;
          return CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: value == idx ? CupertinoColors.activeBlue : CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(8),
            onPressed: () => onChanged(idx),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                descriptions[i],
                style: TextStyle(
                  color: value == idx ? CupertinoColors.white : CupertinoColors.black,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }),
      );
    } else {
      return Column(
        children: List.generate(descriptions.length, (i) {
          final idx = i + 1;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: RadioListTile<int>(
              value: idx,
              groupValue: value,
              onChanged: (v) => onChanged(v!),
              title: Text(
                descriptions[i],
                style: const TextStyle(fontSize: 16),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
            ),
          );
        }),
      );
    }
  }
}
