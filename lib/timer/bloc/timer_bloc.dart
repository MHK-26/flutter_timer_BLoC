import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_timer_bloc/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(initialDuration, _initialSessions, false)) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<_TimerTicked>(_onTicked);
  }

  final Ticker _ticker;
  static const int initialDuration = 25 * 60; // 25 minutes
  static const int breakDuration = 5 * 60; //  5 minutes break
  static const int _initialSessions = 1; // 4 sessions

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration, state.sessions, state.isBreak));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(_TimerTicked(duration: duration)));
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration, state.sessions, state.isBreak));
    }
  }

  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration, state.sessions, state.isBreak));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(initialDuration, _initialSessions, false));
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      emit(TimerRunInProgress(event.duration, state.sessions, state.isBreak));
    } else {
      if (state.isBreak) {
        final newSessions = state.sessions + 1;
        if (newSessions < 5) {
          emit(TimerRunComplete(initialDuration, newSessions, false));
          add(TimerStarted(duration: initialDuration));
        } else {
          emit(
              const TimerRunComplete(initialDuration, _initialSessions, false));
        }
      } else {
        emit(TimerRunComplete(breakDuration, state.sessions, true));
        add(TimerStarted(duration: breakDuration));
      }
    }
  }
}
