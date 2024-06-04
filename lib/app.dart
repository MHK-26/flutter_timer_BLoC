import 'package:flutter/material.dart';
import 'package:flutter_timer_bloc/timer/timer.dart';
import 'package:flutter_timer_bloc/utils/utils.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(
        primaryColor: ThemeColors.primary,
        primaryColorDark: ThemeColors.primaryDark,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      home: const TimerPage(),
    );
  }
}
