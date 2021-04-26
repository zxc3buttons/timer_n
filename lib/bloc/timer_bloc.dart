import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_n/bloc/timer_event.dart';
import 'package:timer_n/bloc/timer_state.dart';
import 'package:timer_n/ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState>{
  final Ticker _ticker;
  static const int _duration = 60;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({Ticker ticker}):assert(ticker!=null), _ticker = ticker, super(TimerInitial(_duration));

  @override
  Stream<TimerState> mapEventToState(
      TimerEvent event,
      ) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    }
    else if (event is TimerPaused) {
      yield* _mapTimerPausedToState(event);
    }
    else if (event is TimerResumed) {
      yield* _mapTimerResumedToState(event);
    }
     else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
     }
    else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    }
  }

  @override // закрывает поток, отменяет подписку на поток
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* { // превращает событие TimerStarted в состояние
    yield TimerRunInProgress(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async*{
    yield tick.duration > 0 ? TimerRunInProgress(tick.duration) : TimerRunComplete(0);//мб здесб ошибка TimerRunComplete(0 or nothing)
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPaused event) async*{
    if (state is TimerRunInProgress){
      _tickerSubscription.pause();
      yield TimerRunPause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumedToState(TimerResumed event) async*{
    if(state is TimerRunPause){
      _tickerSubscription.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerReset event) async*{
      _tickerSubscription.cancel();
      yield TimerInitial(_duration);
  }
}

