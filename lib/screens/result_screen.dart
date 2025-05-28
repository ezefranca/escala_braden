import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/braden_score_provider.dart';
import '../utils/score_interpreter.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BradenScoreProvider>(context, listen: false);
    final score = provider.lastScore;
    if (score == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }
    final result = ScoreInterpreter.interpret(score.totalScore);
    final isWeb = kIsWeb;
    final isIOS = !isWeb && Platform.isIOS;
    final color = result['color'] as Color;
    final icon = result['icon'] as String;
    final textColor = result['textColor'] as Color;
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark
        ? Color.alphaBlend(Colors.black.withOpacity(0.15), color)
        : color;
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border(
              left: BorderSide(
                color: color,
                width: 6,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result['risk'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pontuação total: ${score.totalScore}',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Recomendação:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
        Text(
          result['recommendation'],
          style: TextStyle(fontSize: 18, color: textColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        isIOS
            ? CupertinoButton.filled(
                onPressed: () {
                  provider.reset();
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: const Text('Nova Avaliação'),
              )
            : ElevatedButton(
                onPressed: () {
                  provider.reset();
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Nova Avaliação'),
              ),
      ],
    );
    return isIOS
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Resultado'),
            ),
            child: SafeArea(
              child: Center(child: content),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Resultado'),
            ),
            body: SafeArea(
              child: Center(child: content),
            ),
          );
  }
}
