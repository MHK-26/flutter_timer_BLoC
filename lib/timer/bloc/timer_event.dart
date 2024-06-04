part of 'timer_bloc.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}

final class TimerPaused extends TimerEvent {
  const TimerPaused();

  @override
  List<Object> get props => [];
}

final class TimerResumed extends TimerEvent {
  const TimerResumed();

  @override
  List<Object> get props => [];
}

final class TimerReset extends TimerEvent {
  const TimerReset();

  @override
  List<Object> get props => [];
}

final class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}
