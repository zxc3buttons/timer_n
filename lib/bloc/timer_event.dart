import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TimerEvent extends Equatable{ // все обрабатываемые события, тоже сравниваются по свойству duration
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent{
  final int duration;

  const TimerStarted({@required this.duration});

  @override
  String toString()=>'Timer Started {duration: $duration}';
}

class TimerPaused extends TimerEvent {}

class TimerResumed extends TimerEvent {}

class TimerReset extends TimerEvent {}

class TimerTicked extends TimerEvent {
  final int duration;

  const TimerTicked({@required this.duration});

  @override
  List<Object> get props => [duration];

  @override
  String toString() => "TimerTicked { duration: $duration }";
}