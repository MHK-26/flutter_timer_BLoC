import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_bloc/ticker.dart';
import 'package:flutter_timer_bloc/timer/timer.dart';
import 'package:flutter_timer_bloc/utils/utils.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Center(child: TimerProgress()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: BreakText()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: SessionWidget()),
              ),
              Actions(),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerProgress extends StatelessWidget {
  const TimerProgress({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final isBreak = context.select((TimerBloc bloc) => bloc.state.isBreak);
    final totalDuration =
        isBreak ? TimerBloc.breakDuration : TimerBloc.initialDuration;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: 1 - duration / totalDuration,
            strokeWidth: 10,
            backgroundColor: ThemeColors.indicatorBackground,
            valueColor: AlwaysStoppedAnimation<Color>(
                isBreak ? ThemeColors.breakColor : ThemeColors.primaryDark),
          ),
        ),
        const TimerText(),
      ],
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ThemeColors.textColor,
          ),
    );
  }
}

class BreakText extends StatelessWidget {
  const BreakText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isBreak = context.select((TimerBloc bloc) => bloc.state.isBreak);
    return Text(
      isBreak ? 'Break' : '',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: ThemeColors.breakColor, fontWeight: FontWeight.w500),
    );
  }
}

class SessionWidget extends StatelessWidget {
  const SessionWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sessions = context.select((TimerBloc bloc) => bloc.state.sessions);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(4, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            height: 12,
            width: MediaQuery.of(context).size.width * .2 - 10,
            decoration: BoxDecoration(
              color: index < sessions
                  ? ThemeColors.progress
                  : ThemeColors.progressBackground,
              borderRadius: BorderRadius.circular(5.0),
            ),
          );
        }),
      ],
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
              TimerInitial() => [
                  FloatingActionButton(
                    backgroundColor: ThemeColors.primaryDark,
                    child: const Icon(
                      Icons.play_arrow,
                      color: ThemeColors.primary,
                    ),
                    onPressed: () => context
                        .read<TimerBloc>()
                        .add(TimerStarted(duration: state.duration)),
                  ),
                ],
              TimerRunInProgress() => [
                  FloatingActionButton(
                    backgroundColor: ThemeColors.progressBackground,
                    child: const Icon(Icons.pause),
                    onPressed: () =>
                        context.read<TimerBloc>().add(const TimerPaused()),
                  ),
                  FloatingActionButton(
                    backgroundColor: ThemeColors.primaryDark,
                    child: const Icon(Icons.replay),
                    onPressed: () =>
                        context.read<TimerBloc>().add(const TimerReset()),
                  ),
                ],
              TimerRunPause() => [
                  FloatingActionButton(
                    backgroundColor: ThemeColors.secondary,
                    child: const Icon(Icons.play_arrow),
                    onPressed: () =>
                        context.read<TimerBloc>().add(const TimerResumed()),
                  ),
                  FloatingActionButton(
                    backgroundColor: ThemeColors.primaryDark,
                    child: const Icon(Icons.replay),
                    onPressed: () =>
                        context.read<TimerBloc>().add(const TimerReset()),
                  ),
                ],
              TimerRunComplete() => [
                  FloatingActionButton(
                    backgroundColor: ThemeColors.primaryDark,
                    child: const Icon(Icons.replay),
                    onPressed: () =>
                        context.read<TimerBloc>().add(const TimerReset()),
                  ),
                ]
            }
          ],
        );
      },
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ThemeColors.background,
            ThemeColors.primary,
          ],
        ),
      ),
    );
  }
}
