import 'dart:async';

import 'package:flutter/material.dart';
class TimerProvider with ChangeNotifier {
  int _remainingTime = 300;
  Timer? _timer;

  int get remainingTime => _remainingTime;

  void startTimer() {
    if (_timer == null || !_timer!.isActive) {  // Start only if not active
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          _remainingTime--;
          notifyListeners();
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  void decrementTime() {
    if (_remainingTime > 0) {
      _remainingTime--;
      notifyListeners();
    }
  }

  void setTime(int time) {
    _remainingTime = time;
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
