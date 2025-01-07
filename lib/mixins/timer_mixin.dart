import 'dart:async';
import 'package:flutter/material.dart';

mixin TimerMixin<T extends StatefulWidget> on State<T> {
  final List<Timer> _timers = [];
  final List<AnimationController> _controllers = [];

  void addTimer(Timer timer) {
    _timers.add(timer);
  }

  void addController(AnimationController controller) {
    _controllers.add(controller);
  }

  Timer createPeriodicTimer(Duration duration, void Function(Timer) callback) {
    final timer = Timer.periodic(duration, (timer) {
      if (mounted) {
        callback(timer);
      } else {
        timer.cancel();
      }
    });
    addTimer(timer);
    return timer;
  }

  @override
  void dispose() {
    for (var timer in _timers) {
      timer.cancel();
    }
    for (var controller in _controllers) {
      controller.stop();
      controller.dispose();
    }
    _timers.clear();
    _controllers.clear();
    super.dispose();
  }
} 