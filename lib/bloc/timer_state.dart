import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable{ //абстрактный класс состояния со свойством duration, который все наследуют, он наследует Equatable, то есть
  // все подклассы мы можем сравнивать по свойству duration с помощью оператора ==
  final int duration;

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState{ //начальное состояние
  const TimerInitial(int duration):super(duration);

  @override
  String toString()=> 'TimerInitial {duration: $duration}';
}

class TimerRunPause extends TimerState{ // состояние паузы
  const TimerRunPause(int duration):super(duration);

  @override
  String toString()=> 'TimerRunPause {duration: $duration}';
}

class TimerRunInProgress extends TimerState{ //состояние прогресса
  const TimerRunInProgress(int duration):super(duration);

  @override
  String toString()=> 'TimerRunInProgress {duration: $duration}';
}

class TimerRunComplete extends TimerState{ // завершенное состояние
  const TimerRunComplete(int duration):super(0);

}