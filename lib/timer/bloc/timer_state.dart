part of 'timer_bloc.dart';

sealed class TimerState extends Equatable {
  const TimerState(this.duration, this.sessions, this.isBreak);
  final int duration;
  final int sessions;
  final bool isBreak;

  @override
  List<Object> get props => [duration, sessions, isBreak];
}

final class TimerInitial extends TimerState {
  const TimerInitial(int duration, int sessions, bool isBreak)
      : super(duration, sessions, isBreak);

  @override
  String toString() =>
      'TimerInitial { duration: $duration, sessions: $sessions, isBreak: $isBreak }';
}

final class TimerRunPause extends TimerState {
  const TimerRunPause(int duration, int sessions, bool isBreak)
      : super(duration, sessions, isBreak);

  @override
  String toString() =>
      'TimerRunPause { duration: $duration, sessions: $sessions, isBreak: $isBreak }';
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int duration, int sessions, bool isBreak)
      : super(duration, sessions, isBreak);

  @override
  String toString() =>
      'TimerRunInProgress { duration: $duration, sessions: $sessions, isBreak: $isBreak }';
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete(int duration, int sessions, bool isBreak)
      : super(duration, sessions, isBreak);

  @override
  String toString() =>
      'TimerRunComplete { duration: $duration, sessions: $sessions, isBreak: $isBreak }';
}
