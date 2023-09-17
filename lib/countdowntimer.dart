import 'package:flutter/material.dart';
import 'dart:async';
import 'notifi_service.dart';

class countdownTimer extends StatelessWidget {
  const countdownTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Rian Kenji',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KindaCodeDemo(),
    );
  }
}

class KindaCodeDemo extends StatefulWidget {
  const KindaCodeDemo({super.key});

  @override
  State<KindaCodeDemo> createState() => _KindaCodeDemoState();
}

class _KindaCodeDemoState extends State<KindaCodeDemo> {
  // The seconds, minutes and hours
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;


  // The state of the timer (running or not)
  bool _isRunning = false;

  // The timer
  Timer? _timer;

  TextEditingController _hoursController = TextEditingController();
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hoursController.text = _hours.toString();
    _minutesController.text = _minutes.toString();
    _secondsController.text = _seconds.toString();
  }

  // This function will be called when the user presses the start button
  // Start the timer
  // The timer will run every second
  // The timer will stop when the hours, minutes and seconds are all 0
  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            if (_hours > 0) {
              _hours--;
              _minutes = 59;
              _seconds = 59;
            } else {
              _isRunning = false;
              _timer?.cancel();
              NotificationService()
                  .showNotification(title: 'Timer', body: 'Waktu Habis!');
            }
          }
        }
        _hoursController.text = _hours.toString();
        _minutesController.text = _minutes.toString();
        _secondsController.text = _seconds.toString();
      });
    });
  }


  // This function will be called when the user presses the pause button
  // Pause the timer
  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  // This function will be called when the user presses the cancel button
  // Cancel the timer
  void _cancelTimer() {
    setState(() {
      _hours = 0;
      _minutes = 0;
      _seconds = 0;
      _isRunning = false;
    });
    _timer?.cancel();
    _hoursController.text = _hours.toString();
    _minutesController.text = _minutes.toString();
    _secondsController.text = _seconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Display remaining time in HH:MM:SS format
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.amber,
                child: Center(
                  child: Text(
                    '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Hours:', style: const TextStyle(fontSize: 20)),
                  Row(
                    children: [
                      Slider(
                        value: _hours.toDouble(),
                        min: 0,
                        max: 24,
                        onChanged: (value) {
                          if (!_isRunning) {
                            setState(() {
                              _hours = value.toInt();
                              _hoursController.text = _hours.toString();
                            });
                          }
                        },
                        divisions: 24,
                        label: 'Hours: $_hours',
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _hoursController,
                          onChanged: (value) {
                            if (!_isRunning) {
                              setState(() {
                                _hours = int.tryParse(value) ?? 0;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('Minutes:', style: const TextStyle(fontSize: 20)),
                  Row(
                    children: [
                      Slider(
                        value: _minutes.toDouble(),
                        min: 0,
                        max: 59,
                        onChanged: (value) {
                          if (!_isRunning) {
                            setState(() {
                              _minutes = value.toInt();
                              _minutesController.text = _minutes.toString();
                            });
                          }
                        },
                        divisions: 59,
                        label: 'Minutes: $_minutes',
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _minutesController,
                          onChanged: (value) {
                            if (!_isRunning) {
                              setState(() {
                                _minutes = int.tryParse(value) ?? 0;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('Seconds:', style: const TextStyle(fontSize: 20)),
                  Row(
                    children: [
                      Slider(
                        value: _seconds.toDouble(),
                        min: 0,
                        max: 59,
                        onChanged: (value) {
                          if (!_isRunning) {
                            setState(() {
                              _seconds = value.toInt();
                              _secondsController.text = _seconds.toString();
                            });
                          }
                        },
                        divisions: 59,
                        label: 'Seconds: $_seconds',
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _secondsController,
                          onChanged: (value) {
                            if (!_isRunning) {
                              setState(() {
                                _seconds = int.tryParse(value) ?? 0;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_isRunning) {
                        _pauseTimer();
                      } else {
                        _startTimer();
                      }
                    },
                    style:
                    ElevatedButton.styleFrom(fixedSize: const Size(150, 40)),
                    child: _isRunning ? const Text('Pause') : const Text('Start'),
                  ),
                  ElevatedButton(
                    onPressed: _cancelTimer,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: const Size(150, 40)),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Cancel the timer when the widget is disposed
  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
}