import 'package:flutter/widgets.dart';
import 'braden_score_provider.dart';

class BradenState extends InheritedWidget {
  final BradenScoreProvider provider;

  const BradenState({
    Key? key,
    required this.provider,
    required Widget child,
  }) : super(key: key, child: child);

  static BradenState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BradenState>();
  }

  @override
  bool updateShouldNotify(BradenState oldWidget) => provider != oldWidget.provider;
}
