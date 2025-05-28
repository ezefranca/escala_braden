import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'models/braden_evaluation.dart';
import 'screens/history_screen.dart';
import 'screens/patients_list_screen.dart';
import 'screens/new_evaluation_screen.dart';
import 'screens/summary_view.dart';
import 'providers/braden_score_provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      fontFamily: isIOS ? 'SF Pro' : GoogleFonts.roboto().fontFamily,
      brightness: Brightness.light,
    );
    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
      useMaterial3: true,
      fontFamily: isIOS ? 'SF Pro' : GoogleFonts.roboto().fontFamily,
      brightness: Brightness.dark,
    );
    return ChangeNotifierProvider(
      create: (_) => BradenScoreProvider(),
      child: isIOS
          ? CupertinoApp(
              localizationsDelegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('pt', 'BR')],
              theme: const CupertinoThemeData(brightness: Brightness.light),
              navigatorObservers: [routeObserver],
              routes: {
                '/': (context) => const PatientsListScreen(),
                '/history': (context) => const HistoryScreen(),
                '/new_evaluation': (context) => const NewEvaluationScreen(patientId: ''),
                '/result': (context) {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  if (args is BradenEvaluation) {
                    return SummaryView(evaluation: args);
                  }
                  return const Scaffold(body: Center(child: Text('Avaliação não encontrada.')));
                },
              },
            )
          : MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('pt', 'BR')],
              theme: theme,
              darkTheme: darkTheme,
              navigatorObservers: [routeObserver],
              routes: {
                '/': (context) => const PatientsListScreen(),
                '/history': (context) => const HistoryScreen(),
                '/new_evaluation': (context) => const NewEvaluationScreen(patientId: ''),
                '/result': (context) {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  if (args is BradenEvaluation) {
                    return SummaryView(evaluation: args);
                  }
                  return const Scaffold(body: Center(child: Text('Avaliação não encontrada.')));
                },
              },
            ),
    );
  }
}
