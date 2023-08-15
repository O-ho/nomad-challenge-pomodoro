import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(background: const Color(0xFFE7626C)),
        cardColor: const Color(0xFFF4EDDB),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> minuteList = [2, 20, 25, 30, 35];
  late int currentMinutes = minuteList.first;
  late int totalSeconds = minuteList.first * 60;
  late int restTime = 0;
  late Timer timer;
  late Timer restTimer;
  bool isRest = false;
  bool isRunning = false;
  int totalRound = 0;
  int totalGoal = 0;
  static const maxRound = 4;
  static const maxGoal = 12;
  static const staticRestTime = 300;

  void onRestTick(Timer restTimer) {
    if (restTime == 0) {
      setState(() {
        isRest = false;
      });
      restTimer.cancel();
    } else {
      setState(() {
        restTime = restTime - 1;
      });
    }
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRest = true;
        restTime = staticRestTime;
        restTimer = Timer.periodic(
          const Duration(seconds: 1),
          onRestTick,
        );
        totalRound = totalRound + 1;

        isRunning = false;
        totalSeconds = currentMinutes * 60;
      });
      if (totalRound == maxRound) {
        setState(() {
          totalRound = 0;
          totalGoal = totalGoal + 1;
        });
      }
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onSelectMinute(int minute) {
    setState(() {
      currentMinutes = minute;
      totalSeconds = minute * 60;
    });
    if (isRunning) {
      onPausePressed();
    }
  }

  String format(String type, int seconds) {
    var duration = Duration(seconds: seconds);
    if (type == 'minute') {
      return duration.toString().split(".").first.substring(2, 4);
    }
    return duration.toString().split(".").first.substring(5, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const SizedBox(
            height: 64,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'POMOTIMER',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      format('minute', isRest ? restTime : totalSeconds),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 36,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    width: 24,
                    alignment: Alignment.center,
                    child: Text(
                      ':',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 40,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      format('second', isRest ? restTime : totalSeconds),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 36,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < minuteList.length; i++)
                  Container(
                    alignment: Alignment.center,
                    width: 56,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2),
                        backgroundColor: currentMinutes == minuteList[i]
                            ? Colors.white
                            : Theme.of(context).colorScheme.background,
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () =>
                          isRest ? null : onSelectMinute(minuteList[i]),
                      child: Text(
                        '${minuteList[i]}',
                        style: TextStyle(
                            color: currentMinutes == minuteList[i]
                                ? Theme.of(context).colorScheme.background
                                : Colors.white),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: IconButton(
                iconSize: 120,
                color: Theme.of(context).cardColor,
                onPressed: isRest
                    ? null
                    : isRunning
                        ? onPausePressed
                        : onStartPressed,
                icon: Icon(isRest
                    ? Icons.close_outlined
                    : isRunning
                        ? Icons.pause_circle_outline_outlined
                        : Icons.play_circle_outline_outlined),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$totalRound/$maxRound',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'ROUND',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$totalGoal/$maxGoal',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'GOAL',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
