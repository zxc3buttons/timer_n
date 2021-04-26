import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_n/ticker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'bloc/timer_bloc.dart';
import 'bloc/timer_event.dart';
import 'bloc/timer_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(109, 234, 255, 1),
        accentColor: Color.fromRGBO(72, 74, 126, 1),
        brightness: Brightness.dark,
      ),
      title: 'Flutter Timer',
      home: BlocProvider(
        create: (context) => TimerBloc(ticker:Ticker()),
        child: Timer(),
      )
    );
  }
}

class Timer extends StatelessWidget{

  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Timer')),
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.0),
                  child:
                  Center(
                    child: BlocBuilder<TimerBloc, TimerState>(
                      builder: (context, state){
                        final String minutesStr = ((state.duration / 60) % 60)
                            .floor()
                            .toString()
                            .padLeft(2, '0');
                        final String secondsStr = (state.duration % 60)
                            .floor()
                            .toString()
                            .padLeft(2, '0');
                        return Text(
                          '$minutesStr:$secondsStr',
                          style: Timer.timerTextStyle,
                        );
                      },
                    ),
                  )
              ),
              BlocBuilder<TimerBloc, TimerState>(
                  buildWhen: (previousState, state) =>
                  state.runtimeType!= previousState.runtimeType, // проверяет изменился ли тип состояния(всего 4 типа). Если да, то ребилдит интерфейс, если нет, то нет
                  // без неё он бы ребилдился с каждым тиком, а это неэффективно (ребилд кнопок)
                  builder: (context, state)=> Actions())
            ],
          )
        ],
      )
    );
  }
}

class Actions extends StatelessWidget{ // класс действий, которые будут происходить в приложении
  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context) // blocProvider связывает одним контекстом TimerBloc и все виджеты класса _mapStateToActionsButtons
      ),
    );
  }
}

List<Widget> _mapStateToActionButtons({TimerBloc timerBloc}){
  final TimerState currentState = timerBloc.state;
  if (currentState is TimerInitial){ // проверяем currentState, и в зависимости от состояния возвращаем определенные кнопки с иконкой, апосредством timerBloc,
    //который с помощью метода add, добавляет в поток какой-то event, добавляем возможность кнопкам быть отзывчивыми и способными отправлять события в timerBloc
    return [
      FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.add(TimerStarted(duration: currentState.duration)) ),
    ];
  }
  if (currentState is TimerRunInProgress) {
    return [
      FloatingActionButton(
        child: Icon(Icons.pause),
        onPressed: () => timerBloc.add(TimerPaused()),
      ),
      FloatingActionButton(
        child: Icon(Icons.replay),
        onPressed: () => timerBloc.add(TimerReset()),
      ),
    ];
  }
  if (currentState is TimerRunPause) {
    return [
      FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () => timerBloc.add(TimerResumed()),
      ),
      FloatingActionButton(
        child: Icon(Icons.replay),
        onPressed: () => timerBloc.add(TimerReset()),
      ),
    ];
  }
  if (currentState is TimerRunComplete) {
    return [
      FloatingActionButton(
        child: Icon(Icons.replay),
        onPressed: () => timerBloc.add(TimerReset()),
      ),
    ];
  }
  return [];
}

class Background extends StatelessWidget{
  Widget build(BuildContext context){
    return WaveWidget(
        config: CustomConfig(
          gradients: [
            [
              Color.fromRGBO(72, 74, 126, 1),
              Color.fromRGBO(125, 170, 206, 1),
              Color.fromRGBO(184, 189, 245, 0.7)
            ],
            [
              Color.fromRGBO(72, 74, 126, 1),
              Color.fromRGBO(125, 170, 206, 1),
              Color.fromRGBO(172, 182, 219, 0.7)
            ],
            [
              Color.fromRGBO(72, 73, 126, 1),
              Color.fromRGBO(125, 170, 206, 1),
              Color.fromRGBO(190, 238, 246, 0.7)
            ],
          ],
          durations: [19440, 10800, 6000],
          heightPercentages: [0.03, 0.01, 0.02],
          gradientBegin: Alignment.bottomCenter,
          gradientEnd: Alignment.topCenter
        ),
        size: Size(double.infinity, double.infinity),
        waveAmplitude: 25,
        backgroundColor: Colors.blue[50],
    );
  }
}